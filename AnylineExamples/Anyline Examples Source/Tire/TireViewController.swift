import Foundation
import Anyline

@objc(TireViewController)
class TireViewController: ALBaseScanViewController {

    @objc public enum TireConfigType: NSInteger {
        case tinConfig
        case tireSizeConfig
        case commercialTireConfig
    }

    @objc public var configType: TireConfigType = .tinConfig

    var scanViewPlugin: ALScanViewPluginBase?
    var scanViewConfig: ALScanViewConfig?
    var configJSONString: NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTirePlugin()
        setupFlipOrientationButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        do {
            try scanViewPlugin?.start()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scanViewPlugin?.stop()
        super.viewWillDisappear(animated)
    }
    
    func setupTirePlugin() {
        var JSONFileName: String?
        var titleString: String?
        switch configType {
        case .tinConfig:
            JSONFileName = "tire_config_tin"
            titleString = "TIN"
            self.controllerType = ALScanHistoryTIN
        case .tireSizeConfig:
            JSONFileName = "tire_config_tire_size"
            titleString = "Tire Size"
            self.controllerType = ALScanHistoryTireSizeConfiguration
        case .commercialTireConfig:
            JSONFileName = "tire_config_commercial_tire_id"
            titleString = "Commercial Tire"
            self.controllerType = ALScanHistoryCommercialTireID
        }

        self.title = titleString;

        guard let filename = JSONFileName else {
            print("Initialization error: unable to load scan plugin from config")
            return;
        }
        let JSONStr = self.configJSONStr(withFilename: filename)

        configJSONString = JSONStr as NSString?

        if let configJSONDict = configJSONString?.asJSONObject() as? [String: Any],
           let scanViewPlugin = ALScanViewPluginFactory.withJSONDictionary(configJSONDict) as? ALScanViewPlugin {

            self.scanViewPlugin = scanViewPlugin

            if let scanViewConfig = try? ALScanViewConfig(jsonDictionary: configJSONDict),
               let scanView = try? ALScanView(frame: .zero,
                                              scanViewPlugin: scanViewPlugin,
                                              scanViewConfig: scanViewConfig) {
                self.scanView = scanView
            } else {
                print("error: ScanView was not created. Please check the error.")
            }

            self.installScanView(self.scanView!)

            let scanPlugin: ALScanPlugin = (self.scanViewPlugin as! ALScanViewPlugin).scanPlugin
            scanPlugin.delegate = self

            self.scanView?.startCamera()

        } else {
            let msg = "Initialization error: tireConfig couldn't be converted in json object"
            assertionFailure(msg)
        }
    }
}

extension TireViewController: ALScanPluginDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {

        enableLandscapeOrientation(false)

        var resultData: Array<ALResultEntry>!
        var resultString: String?
        let result = scanResult.pluginResult
        switch configType {
        case .commercialTireConfig:
            if let commercialTireIDResult = result.commercialTireIDResult {
                resultData = commercialTireIDResult.resultEntryList
                resultString = resultData.JSONStringFromResultData
            }
        case .tinConfig:
            if let tinResult = result.tinResult {
                resultData = tinResult.resultEntryList
                resultString = resultData.JSONStringFromResultData
            }
        case .tireSizeConfig:
            if let tireSizeResult = result.tireSizeResult {
                resultData = tireSizeResult.resultEntryList
                resultString = resultData.JSONStringFromResultData
            }
        }

        guard let resultData = resultData, let resultString = resultString else {
            assertionFailure("no value to scan (not possible)!")
            return
        }

        self.anylineDidFindResult(resultString,
                                  barcodeResult: nil,
                                  image: scanResult.croppedImage,
                                  scanPlugin: scanPlugin,
                                  viewPlugin: self.scanViewPlugin!) { [weak self] in

            let vc = ALResultViewController(results: resultData)
            vc.imagePrimary = scanResult.croppedImage
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

@objc class TireSizeViewController: TireViewController {
    override func viewDidLoad() {
        configType = .tireSizeConfig
        super.viewDidLoad()
    }
}

@objc class CommercialTireIdViewController: TireViewController {
    override func viewDidLoad() {
        configType = .commercialTireConfig
        super.viewDidLoad()
    }
}

@objc class TINDotViewController: TireViewController {
    override func viewDidLoad() {
        configType = .tinConfig
        super.viewDidLoad()
    }
}
