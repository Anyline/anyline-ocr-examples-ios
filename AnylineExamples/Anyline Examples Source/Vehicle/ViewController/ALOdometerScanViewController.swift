import Foundation

@objc(ALOdometerScanViewController) // this attribute makes it usable by NSClassFromString()
class ALOdometerScanViewController: ALBaseScanViewController {

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

    var meterImage: UIImage?

    private var dialogIndexSelected: UInt = 0

    var configJSONFilename: String {
        "odometer_config"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Odometer"
        
        self.controllerType = ALScanHistoryOdometer
        reloadScanView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try! self.startScanning()
    }

    func clearResults() {
        meterImage = nil
        meterResultEntries = nil
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

        // handle any adaptations to the config based on the scan mode

        let scanViewPluginConfig: ALScanViewPluginConfig = try .init(scanPluginConfig: scanPluginConfig,
                                                                     cutoutConfig: cutoutConfig,
                                                                     scanFeedbackConfig: scanFeedbackConfig)

        return try .init(config: scanViewPluginConfig)
    }

    func scanViewPluginConfig(fromDict JSONDict: [String: Any],
                              scanMode: ALMeterConfigScanMode) throws -> ALScanViewPluginBase {
        let config: ALScanViewPluginConfig = ALScanViewPluginConfig.withJSONDictionary(JSONDict)!
        let scanViewPlugin = try! type(of: self).meterScanViewPlugin(from: config, scanMode: scanMode)
        scanViewPlugin.scanPlugin.delegate = self
        return scanViewPlugin
    }
}

extension ALOdometerScanViewController: ALScanPluginDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {
        if let _ = self.loadMeterResult(from: scanResult) {
            displayResults()
        }
    }

    func viewPluginComposite(_ viewPluginComposite: ALViewPluginComposite, allResultsReceived scanResults: [ALScanResult]) {
        displayResults()
    }

    func loadMeterResult(from scanResult: ALScanResult) -> String? {

        if let meterResult = scanResult.pluginResult.meterResult {
            var result = meterResult.value
            if let meterUnit = meterResult.unit {
                result += String(format: " %@", meterUnit)
            } // move this result to extension

            let resultFieldList = scanResult.pluginResult.fieldList()
            if var resultDict = resultFieldList.first {
                // go through the first result object, find a key named nameReadable, and introduce
                // "Odometer Reading" as result title.
                resultDict["nameReadable"] = "Odometer Reading"
                self.meterResultEntries = ([ resultDict ] as NSArray).resultEntries
            } else {
                self.meterResultEntries = (resultFieldList as NSArray).resultEntries
            }
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
                                  barcodeResult: nil,
                                  image: self.meterImage,
                                  scanPlugin: scanPlugin,
                                  viewPlugin: scanViewPlugin) { [weak self] in
            let resultVC: ALResultViewController = .init(results: resultData)
            resultVC.imagePrimary = self?.meterImage
            self?.navigationController?.pushViewController(resultVC, animated: true)
            self?.clearResults()
        }
    }
}
