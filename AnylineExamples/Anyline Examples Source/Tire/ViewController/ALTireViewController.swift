import Foundation
import Anyline

@objc(ALTireViewController)
class ALTireViewController: ALBaseScanViewController {

    @objc public enum TireConfigType: NSInteger {
        case tinConfig
        case tireSizeConfig
        case commercialTireConfig
    }

    @objc public var configType: TireConfigType = .tinConfig

    var scanViewPlugin: ALScanViewPluginBase?
    var scanViewConfig: ALScanViewConfig?
    
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

        var JSONFileName = ""
        var titleString: String?
        switch configType {
        case .tinConfig:
            JSONFileName = "tire_tin_config"
            titleString = "TIN"
            self.controllerType = ALScanHistoryTIN
        case .tireSizeConfig:
            JSONFileName = "tire_size_config"
            titleString = "Tire Size"
            self.controllerType = ALScanHistoryTireSizeConfiguration
        case .commercialTireConfig:
            JSONFileName = "commercial_tire_id_config"
            titleString = "Commercial Tire"
            self.controllerType = ALScanHistoryCommercialTireID
        }

        self.title = titleString;

        let path = Bundle.main.path(forResource:JSONFileName, ofType: "json") ?? ""

        do {
            let scanView = try ALScanViewFactory.withConfigFilePath(path, delegate: self)
            self.scanViewPlugin = scanView.scanViewPlugin as? ALScanViewPlugin
            self.installScanView(scanView)
            scanView.delegate = self
            scanView.startCamera()
            self.scanView = scanView

        } catch {
            if (self.popWithAlert(onError: error)) {
                return
            }
        }
    }
}

extension ALTireViewController: ALScanPluginDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {

        enableLandscapeOrientation(false)

        let resultEntries: [ALResultEntry] = (scanResult.pluginResult.fieldList() as NSArray).resultEntries

        guard let resultString = resultEntries.JSONStringFromResultData else {
            assertionFailure("no resultString!")
            return
        }

        self.anylineDidFindResult(resultString,
                                  barcodeResult: nil,
                                  image: scanResult.croppedImage,
                                  scanPlugin: scanPlugin,
                                  viewPlugin: self.scanViewPlugin!) { [weak self] in

            let vc = ALResultViewController(results: resultEntries)
            vc.imagePrimary = scanResult.croppedImage
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

@objc class ALTireSizeViewController: ALTireViewController {
    override func viewDidLoad() {
        configType = .tireSizeConfig
        super.viewDidLoad()
    }
}

@objc class ALCommercialTireIdViewController: ALTireViewController {
    override func viewDidLoad() {
        configType = .commercialTireConfig
        super.viewDidLoad()
    }
}

@objc class ALTINDotViewController: ALTireViewController {
    override func viewDidLoad() {
        configType = .tinConfig
        super.viewDidLoad()
    }
}
