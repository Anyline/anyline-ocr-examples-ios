import Foundation

class ALMeterScanViewController: ALBaseScanViewController {

    var scanViewPlugin: ALScanViewPluginBase?

    var scanMode: ALMeterConfigScanMode = .autoAnalogDigitalMeter()

    var meterResultEntries: [ALResultEntry]?

    var barcodeResultEntries: [ALResultEntry]?

    var meterImage: UIImage?

    var barcodeImage: UIImage?

    var barcodeString: String?

    var withBarcode: Bool = false {
        didSet {
            reloadScanView()
            clearResults()
            try! self.scanViewPlugin?.start()
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try! self.scanViewPlugin?.start()
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
            print("error: unable to find json config")
            return
        }

        let scanViewPluginBase: ALScanViewPluginBase? = scanViewPluginConfig(fromDict: JSONDict,
                                                                             scanMode: self.scanMode)
        // ScanViewConfig
        let configJSONDict: [AnyHashable: Any]! = [:]
        let scanViewConfig: ALScanViewConfig? = .withJSONDictionary(configJSONDict)

        self.scanViewPlugin = scanViewPluginBase

        if self.scanView != nil {
            do {
                try self.scanView?.setScanViewPlugin(scanViewPluginBase!)
            } catch {
                print("unable to set scan view plugin: \(error.localizedDescription)")
            }
        } else {
            do {
                self.scanView = try .init(frame: .zero,
                                          scanViewPlugin: scanViewPluginBase!,
                                          scanViewConfig: scanViewConfig)
                self.scanView?.delegate = self

                if let scanView = self.scanView {
                    self.installScanView(scanView)
                    self.view.sendSubviewToBack(scanView)
                    scanView.startCamera()
                }
            } catch {
                print("unable to instantiate scan view: \(error.localizedDescription)")
            }
        }
    }

    func scanViewPluginConfig(fromDict JSONDict: [String: Any], scanMode: ALMeterConfigScanMode) -> ALScanViewPluginBase? {
        if withBarcode {
            var composite = ALScanViewPluginFactory.withJSONDictionary(JSONDict) as! ALViewPluginComposite
            // we have a composite with two children in this view controller (as per JSON). For the meter child,
            // reconstruct it
            var children = [ALScanViewPlugin]()
            composite.children.forEach { child in
                if let svpCopy = child as? ALScanViewPlugin {
                    // remake a scanViewPlugin with your change to the meter plugin scan mode
                    let scanPluginConfig = svpCopy.scanPlugin.scanPluginConfig
                    scanPluginConfig.pluginConfig.meterConfig?.scanMode = scanMode
                    if let newSVP: ALScanViewPlugin = try! .init(config: try! .init(scanPluginConfig: scanPluginConfig,
                                                                                    cutoutConfig: svpCopy.scanViewPluginConfig.cutoutConfig,
                                                                                    scanFeedbackConfig: svpCopy.scanViewPluginConfig.scanFeedbackConfig)) {
                        newSVP.delegate = self
                        newSVP.scanPlugin.delegate = self
                        children.append(newSVP)
                    }
                }
            }

            if let newComposite: ALViewPluginComposite = try! .init(id: composite.pluginID,
                                                               mode: composite.processingMode,
                                                               children: children) {
                composite = newComposite
            }
            composite.delegate = self
            return composite

        } else {
            let config = ALScanViewPluginConfig.withJSONDictionary(JSONDict)!
            var scanViewPlugin: ALScanViewPlugin? = try! .init(config: config)

            // NOTE: this won't work! ScanPlugin has already been created and the script loaded. You won't be changing it
            // here. Recreate from scratch.
            // scanViewPlugin?.scanPlugin.scanPluginConfig.pluginConfig.meterConfig?.scanMode = .dialMeter()

            if let svpCopy = scanViewPlugin {
                let scanPluginConfig = svpCopy.scanPlugin.scanPluginConfig
                scanPluginConfig.pluginConfig.meterConfig?.scanMode = scanMode
                scanViewPlugin = try! .init(config: .init(scanPluginConfig: scanPluginConfig,
                                                          cutoutConfig: svpCopy.scanViewPluginConfig.cutoutConfig,
                                                          scanFeedbackConfig: svpCopy.scanViewPluginConfig.scanFeedbackConfig))
            }

            scanViewPlugin?.scanPlugin.delegate = self
            scanViewPlugin?.delegate = self
            return scanViewPlugin
        }
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

extension ALMeterScanViewController: ALScanPluginDelegate, ALScanViewPluginDelegate, ALViewPluginCompositeDelegate {

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
        if let barcodeResult = scanResult.pluginResult.barcodeResult {
            self.barcodeResultEntries = barcodeResult.resultEntryList
            self.barcodeImage = scanResult.croppedImage
            return barcodeResult.barcodes.first?.decoded() // get one for the barcode string to be used later
        }
        return nil
    }

    func loadMeterResult(from scanResult: ALScanResult) -> String? {
        if let meterResult = scanResult.pluginResult.meterResult {
            var result = meterResult.value
            if let meterUnit = meterResult.unit {
                result += String(format: " %@", meterUnit)
            } // move this result to extension
            self.meterResultEntries = meterResult.resultEntryList
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
}
