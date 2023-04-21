import Foundation

@objc(ALMeterScanViewController) // this attribute makes it usable by NSClassFromString()
class ALMeterScanViewController: ALBaseScanViewController {

    enum Constants {
        static let choices: [String] = [
            "Digital (EMEA)",
            "Digital (APAC)",
            "Analog",
            "Dial",
        ]

        static let scanModes: [ALMeterConfigScanMode] = [
            .autoAnalogDigitalMeter(), // EMEA
            .digitalMeter2_Experimental(), // APAC
            .autoAnalogDigitalMeter(), // Analog
            .dialMeter() // Dial
        ]
    }

    var scanMode: ALMeterConfigScanMode = .autoAnalogDigitalMeter()

    var meterResultEntries: [ALResultEntry]?

    var barcodeResultEntries: [ALResultEntry]?

    var meterImage: UIImage?

    var barcodeImage: UIImage?

    var barcodeString: String?

    private var dialogIndexSelected: UInt = 0

    var withBarcode: Bool = false {
        didSet {
            reloadScanView()
            clearResults()
            try! self.startScanning()
        }
    }

    var configJSONFilename: String {
        withBarcode ? "parallel_meter_barcode_config" : "meter_config"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // fix title (but if you came by Meter Reading, the title will be prefilled)
        if self.title == nil || self.title!.count < 1 {
            self.title = "Analog/Digital Meter"
        }

        if (self.title == "Digital (APAC)") {
            self.scanMode = .digitalMeter2_Experimental()
        } else if (self.title == "Dial Meter" || self.title == "Dial") {
            self.scanMode = .dialMeter()
        } else {
            self.scanMode = .autoAnalogDigitalMeter()
        }

        self.controllerType = ALScanHistoryElectricMeter

        setUpBarcodeSwitchView()

        reloadScanView()

        addModeSelectButton(withTitle: Constants.choices[0]) { [weak self] in // didPress block
            self?.showOptionsSelectionDialog()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try! self.startScanning()
    }

    func clearResults() {
        meterImage = nil
        meterResultEntries = nil
        barcodeResultEntries = nil
        barcodeString = nil
        barcodeImage = nil
    }

    fileprivate func reloadScanView() {
        guard let JSONStr = self.configJSONStr(withFilename: configJSONFilename),
              let JSONDict = (JSONStr as NSString).asJSONObject() as? [String : Any] else {
            print("error: unable to find JSON config")
            return
        }

        var scanViewPluginBase: ALScanViewPluginBase!
        do {
            scanViewPluginBase = try scanViewPluginConfig(fromDict: JSONDict,
                                                          withBarcode: withBarcode,
                                                          scanMode: self.scanMode)
        } catch {
            if (self.popWithAlert(onError: error)) {
                return
            }
        }

        // ScanViewConfig
        let scanViewConfig: ALScanViewConfig? = .withJSONDictionary(JSONDict)

        if self.scanView != nil {
            do {
                try self.scanView?.setScanViewPlugin(scanViewPluginBase)
            } catch {
                print("unable to set scan view plugin: \(error.localizedDescription)")
                if (self.popWithAlert(onError: error)) {
                    return
                }
            }
        } else { // create a scanView
            do {
                self.scanView = try .init(frame: .zero,
                                          scanViewPlugin: scanViewPluginBase,
                                          scanViewConfig: scanViewConfig)
                self.scanView?.delegate = self
                if let scanView = self.scanView {
                    self.installScanView(scanView)
                    self.view.sendSubviewToBack(scanView)
                    scanView.startCamera()
                }
            } catch {
                print("unable to instantiate scan view: \(error.localizedDescription)")
                if (self.popWithAlert(onError: error)) {
                    return
                }
            }
        }
    }

    fileprivate static func meterScanViewPlugin(from config: ALScanViewPluginConfig,
                                                scanMode: ALMeterConfigScanMode) throws -> ALScanViewPlugin {
        var scanPluginConfig = config.scanPluginConfig
        var cutoutConfig = config.cutoutConfig
        let scanFeedbackConfig = config.scanFeedbackConfig

        // edit scan mode
        scanPluginConfig.pluginConfig.meterConfig?.scanMode = scanMode

        // apply a new cutout config
        if scanMode == ALMeterConfigScanMode.dialMeter() {

            // increase startScanDelay
            let pluginConfig = scanPluginConfig.pluginConfig
            pluginConfig.startScanDelay = 1000
            scanPluginConfig = .init(pluginConfig: pluginConfig)

            // create a new ALCutoutConfig
            cutoutConfig = .init(alignment: config.cutoutConfig.alignment,
                                 animation: config.cutoutConfig.animation,
                                 ratioFrom: .init(width: 2, height: 1), // modified
                                 offset: .init(x: 0, y: 50), // modified
                                 width: config.cutoutConfig.width,
                                 maxHeightPercent: config.cutoutConfig.maxHeightPercent,
                                 maxWidthPercent: 85, // modified
                                 cornerRadius: config.cutoutConfig.cornerRadius,
                                 strokeWidth: config.cutoutConfig.strokeWidth,
                                 strokeColor: config.cutoutConfig.strokeColor,
                                 feedbackStrokeColor: config.cutoutConfig.feedbackStrokeColor,
                                 outerColor: config.cutoutConfig.outerColor,
                                 cropOffset: config.cutoutConfig.cropOffset,
                                 cropPadding: config.cutoutConfig.cropPadding,
                                 image: config.cutoutConfig.image)!
        }

        let scanViewPluginConfig: ALScanViewPluginConfig = try .init(scanPluginConfig: scanPluginConfig,
                                                                     cutoutConfig: cutoutConfig,
                                                                     scanFeedbackConfig: scanFeedbackConfig)

        return try .init(config: scanViewPluginConfig)
    }

    func scanViewPluginConfig(fromDict JSONDict: [String: Any],
                              withBarcode: Bool,
                              scanMode: ALMeterConfigScanMode) throws -> ALScanViewPluginBase {

        if !withBarcode { // the non-composite mode
            let config: ALScanViewPluginConfig = ALScanViewPluginConfig.withJSONDictionary(JSONDict)!
            let scanViewPlugin = try! type(of: self).meterScanViewPlugin(from: config, scanMode: scanMode)
            scanViewPlugin.scanPlugin.delegate = self
            return scanViewPlugin
        }

        // (re)creating a composite plugin with the correct scan mode (and additional adaptations based on
        // scan mode)
        var composite = try ALScanViewPluginFactory.withJSONDictionary(JSONDict) as! ALViewPluginComposite

        // we have a composite with two children in this view controller (as per JSON). For the meter child,
        // reconstruct it
        var children = [ALScanViewPlugin]()
        try composite.children.forEach { child in
            if var scanViewPlugin = child as? ALScanViewPlugin {
                // remake a scanViewPlugin with your change to the meter plugin scan mode

                // make sure it's the meter child plugin you are doing this to
                if scanViewPlugin.scanPlugin.scanPluginConfig.pluginConfig.meterConfig != nil {
                    scanViewPlugin = try type(of: self)
                        .meterScanViewPlugin(from: scanViewPlugin.scanViewPluginConfig,
                                             scanMode: scanMode)
                }
                scanViewPlugin.scanPlugin.delegate = self
                children.append(scanViewPlugin)
            }
        }

        if let newComposite: ALViewPluginComposite = try .init(id: composite.pluginID,
                                                               mode: composite.processingMode,
                                                               children: children) {
            composite = newComposite
        }
        composite.delegate = self
        return composite
    }

    private func setUpBarcodeSwitchView() {
        let container: UIView = .init()
        container.translatesAutoresizingMaskIntoConstraints = false

        let label: UILabel = .init()
        label.font = .al_proximaRegular(withSize: 14)
        label.text = "Barcode Detection"
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: label.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.03), range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString

        let toggle: UISwitch = .init()
        toggle.isOn = withBarcode
        toggle.tintColor = .init(red: 0, green: 153/255.0, blue: 1, alpha: 1)
        // toggle.useHighContrast() // ?
        toggle.translatesAutoresizingMaskIntoConstraints = false

        toggle.addTarget(self, action: #selector(barcodeSwitchToggled(_:)), for: .valueChanged)

        container.addSubview(label)
        container.addSubview(toggle)

        label.rightAnchor.constraint(equalTo: toggle.leftAnchor, constant: -10).isActive = true
        label.centerYAnchor.constraint(equalTo: toggle.centerYAnchor).isActive = true

        toggle.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        label.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        self.view.addSubview(container)
        container.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }

    @objc
    func barcodeSwitchToggled(_ toggle: UISwitch?) {
        self.withBarcode = toggle?.isOn ?? false
    }
}

extension ALMeterScanViewController: ALScanPluginDelegate, ALViewPluginCompositeDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {
        if let _ = self.loadMeterResult(from: scanResult) {
            if !withBarcode {
                displayResults()
            }
        }
        if let barcodeString = self.loadBarcodeResult(from: scanResult) {
            self.barcodeString = barcodeString
        }
    }

    func viewPluginComposite(_ viewPluginComposite: ALViewPluginComposite, allResultsReceived scanResults: [ALScanResult]) {
        displayResults()
    }

    func loadBarcodeResult(from scanResult: ALScanResult) -> String? {

        if let _ = scanResult.pluginResult.barcodeResult {

            let arr = scanResult.pluginResult.fieldList() as NSArray
            self.barcodeResultEntries = arr.resultEntries
            self.barcodeImage = scanResult.croppedImage

            let decodeValue = arr
                .compactMap { $0 as? [String: String] }
                .filter { $0["name"] == "barcode" }
                .map { $0["value"] }
                .first;

            return decodeValue ?? ""
        }
        return nil
    }

    func loadMeterResult(from scanResult: ALScanResult) -> String? {

        if let meterResult = scanResult.pluginResult.meterResult {
            var result = meterResult.value
            if let meterUnit = meterResult.unit {
                result += String(format: " %@", meterUnit)
            } // move this result to extension

            let arr = scanResult.pluginResult.fieldList() as NSArray
            self.meterResultEntries = arr.resultEntries
            self.meterImage = scanResult.croppedImage
            return result
        }
        return nil
    }

    func displayResults() {
        guard let scanViewPlugin = self.scanViewPlugin else {
            print("error: need both ScanViewPlugin")
            return
        }

        var resultData: [ALResultEntry] = []
        if let resultEntries = self.meterResultEntries {
            resultData.append(contentsOf: resultEntries)
        }
        if let resultEntries = self.barcodeResultEntries {
            resultData.append(contentsOf: resultEntries)
        }

        var scanPlugin: ALScanPlugin!
        if let scanViewPlugin = self.scanViewPlugin as? ALScanViewPlugin {
            // this is it
            scanPlugin = scanViewPlugin.scanPlugin
        } else if let composite = self.scanViewPlugin as? ALViewPluginComposite {
            scanPlugin = composite.children.compactMap { base in
                if let b = base as? ALScanViewPlugin {
                    return b.scanPlugin
                }
                return nil
            }.first
        }

        guard let scanPlugin = scanPlugin else {
            return
        }

        let JSONString = resultData.JSONStringFromResultData!
        
        self.anylineDidFindResult(JSONString,
                                  barcodeResult: self.barcodeString,
                                  image: self.meterImage,
                                  scanPlugin: scanPlugin,
                                  viewPlugin: scanViewPlugin) { [weak self] in
            let resultVC: ALResultViewController = .init(results: resultData)
            resultVC.imagePrimary = self?.meterImage
            resultVC.imageSecondary = self?.barcodeImage
            self?.navigationController?.pushViewController(resultVC, animated: true)

            self?.clearResults()
        }
    }

    private func showOptionsSelectionDialog() {
        let vc = ALConfigurationDialogViewController.singleSelectDialog(withChoices: Constants.choices,
                                                                        selectedIndex: dialogIndexSelected,
                                                                        delegate: self)
        self.present(vc, animated: true)
        self.scanView?.stopCamera()
    }
}

extension ALMeterScanViewController: ALConfigurationDialogViewControllerDelegate {

    func configDialog(_ dialog: ALConfigurationDialogViewController, selectedIndex index: UInt) {
        dialogIndexSelected = index
        self.modeSelectButton?.setTitle(Constants.choices[Int(dialogIndexSelected)],
                                        for: .normal)
        self.scanMode = Constants.scanModes[Int(dialogIndexSelected)]
        self.reloadScanView()
        self.scanView?.startCamera()
        self.dismiss(animated: true)
        try! self.startScanning()
    }

    func configDialogCommitted(_ commited: Bool, dialog: ALConfigurationDialogViewController) {}

    func configDialogCancelled(_ dialog: ALConfigurationDialogViewController) {
        self.scanView?.startCamera()
    }
}
