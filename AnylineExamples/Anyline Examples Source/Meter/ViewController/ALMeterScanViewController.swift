import Foundation

@objc(ALMeterScanViewController) // this attribute makes it usable by NSClassFromString()
class ALMeterScanViewController: ALBaseScanViewController {

    enum MeterError: Error {
        case configError(String)
    }

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
            clearResults()
            do {
                try reloadScanView()
            } catch {
                if (self.popWithAlert(onError: error)) {
                    return
                }
            }

        }
    }

    var configJSONFilename: String {
        return withBarcode ? "parallel_meter_barcode_config" : "meter_config"
    }

    func scanViewConfigJSONString() throws -> String {
        return try self.configJSONStr(withFilename: configJSONFilename)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.title == nil || self.title!.count < 1 {
            self.title = "Meter"
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

        do {
            try reloadScanView()
        } catch {
            if (self.popWithAlert(onError: error)) {
                return
            }
        }

        addModeSelectButton(withTitle: Constants.choices[0]) { [weak self] in // didPress block
            self?.showOptionsSelectionDialog()
        }

        if let scanView = self.scanView {
            scanView.startCamera()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try? self.scanView?.startScanning()
    }

    func clearResults() {
        meterImage = nil
        meterResultEntries = nil
        barcodeResultEntries = nil
        barcodeString = nil
        barcodeImage = nil
    }

    fileprivate func reloadScanView() throws {
        let scanViewConfigJSONStr = try scanViewConfigJSONString()

        var scanViewConfig: ALScanViewConfig! = nil
        var viewPluginBase: ALViewPluginBase!

        scanViewConfig = try ALScanViewConfig.withJSONString(scanViewConfigJSONStr)

        viewPluginBase = try type(of: self).viewPlugin(fromScanViewConfigStr: scanViewConfigJSONStr,
                                                       withBarcode: withBarcode,
                                                       scanMode: self.scanMode,
                                                       delegate: self)

        if self.scanView == nil {
            self.scanView = try .init(frame: .zero,
                                      scanViewConfig: scanViewConfig)
        }

        if let scanView = self.scanView {
            try scanView.setViewPlugin(viewPluginBase)

            scanView.delegate = self

            self.installScanView(scanView)
            self.view.sendSubviewToBack(scanView)

            try scanView.startScanning()
        }
    }

    fileprivate static func viewPlugin(fromScanViewConfigStr JSONString: String,
                                       withBarcode: Bool,
                                       scanMode: ALMeterConfigScanMode,
                                       delegate: Any) throws -> ALViewPluginBase {

        // only the meter running
        if withBarcode == false {
            let config: ALScanViewConfig = try ALScanViewConfig.withJSONString(JSONString)
            let scanViewPlugin = try meterScanViewPlugin(from: config.viewPluginConfig!, scanMode: scanMode)
            scanViewPlugin.scanPlugin.delegate = delegate as? any ALScanPluginDelegate
            return scanViewPlugin
        }

        // meter and barcode composite scanning
        let config = try ALScanViewConfig.withJSONString(JSONString)
        guard let compositeConfig = config.viewPluginCompositeConfig else {
            throw MeterError.configError("unable to get composite config")
        }

        // update the scan mode for the meter plugin child
        compositeConfig.viewPlugins.forEach {
            $0.viewPluginConfig?.pluginConfig.meterConfig?.scanMode = scanMode
        }

        // create the composite view plugin, and then set its delegate
        let viewPluginComposite = try ALViewPluginComposite(config: compositeConfig)
        viewPluginComposite.delegate = delegate as? any ALViewPluginCompositeDelegate
        
        // do the same for each of its children
        viewPluginComposite.children.forEach { viewPluginBase in
            if let scanViewPlugin = viewPluginBase as? ALScanViewPlugin {
                scanViewPlugin.scanPlugin.delegate = delegate as? any ALScanPluginDelegate
            }
        }
        
        return viewPluginComposite
    }

    // override dial meter's scan delay on start fixing it to 1s
    fileprivate static func meterScanViewPlugin(from config: ALViewPluginConfig,
                                                scanMode: ALMeterConfigScanMode) throws -> ALScanViewPlugin {
        let pluginConfig = config.pluginConfig
        pluginConfig.meterConfig?.scanMode = scanMode
        if pluginConfig.meterConfig?.scanMode == ALMeterConfigScanMode.dialMeter() {
            pluginConfig.startScanDelay = 1000
        }
        return try .init(config: config)
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

        do {
            try self.reloadScanView()
            self.dismiss(animated: true) { [weak self] in
                self?.scanView?.startCamera()
            }
        } catch {
            if (self.popWithAlert(onError: error)) {
                return
            }
        }
    }

    func configDialogCommitted(_ commited: Bool, dialog: ALConfigurationDialogViewController) {}

    func configDialogCancelled(_ dialog: ALConfigurationDialogViewController) {
        self.scanView?.startCamera()
    }
}
