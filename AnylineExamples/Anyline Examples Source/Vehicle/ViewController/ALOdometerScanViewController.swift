import Foundation

@objc(ALOdometerScanViewController) // this attribute makes it usable by NSClassFromString()
class ALOdometerScanViewController: ALBaseScanViewController {

    var resultEntries: [ALResultEntry]?

    var resultImage: UIImage?

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
        resultImage = nil
        resultEntries = nil
    }

    fileprivate func reloadScanView() {
        guard let JSONStr = self.configJSONStr(withFilename: configJSONFilename),
              let JSONDict = (JSONStr as NSString).asJSONObject() as? [String : Any] else {
            print("error: unable to find JSON config")
            return
        }

        var scanViewPluginBase: ALScanViewPluginBase!
        do {
            scanViewPluginBase = try scanViewPluginConfig(fromDict: JSONDict)
            if let scanPlugin = (scanViewPluginBase as? ALScanViewPlugin)?.scanPlugin {
                scanPlugin.delegate = self
            }
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

    fileprivate static func odometerScanViewPlugin(from config: ALScanViewPluginConfig) throws -> ALScanViewPlugin {
        let scanPluginConfig = config.scanPluginConfig
        let cutoutConfig = config.cutoutConfig
        let scanFeedbackConfig = config.scanFeedbackConfig

        // handle any adaptations to the config based on the scan mode

        let scanViewPluginConfig: ALScanViewPluginConfig = try .init(scanPluginConfig: scanPluginConfig,
                                                                     cutoutConfig: cutoutConfig,
                                                                     scanFeedbackConfig: scanFeedbackConfig)

        return try .init(config: scanViewPluginConfig)
    }

    func scanViewPluginConfig(fromDict JSONDict: [String: Any]) throws -> ALScanViewPluginBase {
        let config: ALScanViewPluginConfig = ALScanViewPluginConfig.withJSONDictionary(JSONDict)!
        return try ALScanViewPlugin(config: config)
    }
}

extension ALOdometerScanViewController: ALScanPluginDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {
        if let _ = self.loadOdometerResult(from: scanResult) {
            displayResults()
        }
    }

    func viewPluginComposite(_ viewPluginComposite: ALViewPluginComposite, allResultsReceived scanResults: [ALScanResult]) {
        displayResults()
    }

    func loadOdometerResult(from scanResult: ALScanResult) -> String? {

        if let odometerResult = scanResult.pluginResult.odometerResult {
            var result = odometerResult.value
            self.resultEntries = (scanResult.pluginResult.fieldList() as NSArray).resultEntries
            self.resultImage = scanResult.croppedImage
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
        if let resultEntries = self.resultEntries {
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
                                  image: self.resultImage,
                                  scanPlugin: scanPlugin,
                                  viewPlugin: scanViewPlugin) { [weak self] in
            let resultVC: ALResultViewController = .init(results: resultData)
            resultVC.imagePrimary = self?.resultImage
            self?.navigationController?.pushViewController(resultVC, animated: true)
            self?.clearResults()
        }
    }
}
