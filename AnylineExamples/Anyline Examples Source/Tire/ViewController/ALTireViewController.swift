import Foundation
import Anyline

@objc(ALTireViewController)
class ALTireViewController: ALBaseScanViewController {

    @objc public enum TireConfigType: NSInteger {
        case tinConfig
        case tireSizeConfig
        case commercialTireConfig
        case tireMake
    }

    @objc public var configType: TireConfigType = .tinConfig

    var scanViewConfig: ALScanViewConfig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTirePlugin()
        setupFlipOrientationButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        isOrientationFlipped = true
        enableLandscapeOrientation(true)

        do {
            try startScanning()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scanViewPlugin?.stop()
        super.viewWillDisappear(animated)
    }


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            if self?.scanViewPlugin?.isStarted == true {
                self?.setupTirePlugin()
            }
        }
    }

    func setupTirePlugin() {

        var JSONFileName = ""
        var titleString: String?
        switch configType {
        case .tinConfig:
            JSONFileName = "tire_tin_config"
            titleString = "DOT / TIN"
            self.controllerType = ALScanHistoryTIN
        case .tireSizeConfig:
            JSONFileName = "tire_size_config"
            titleString = "Tire Size"
            self.controllerType = ALScanHistoryTireSizeConfiguration
        case .commercialTireConfig:
            JSONFileName = "commercial_tire_id_config"
            titleString = "Tire Commercial ID"
            self.controllerType = ALScanHistoryCommercialTireID
        case .tireMake:
            JSONFileName = "tire_make_config"
            titleString = "Tire Make (Beta)"
            self.controllerType = ALScanHistoryTireMake
        }

        self.title = titleString

        guard let configJSONStr = try? self.configJSONStr(withFilename: JSONFileName),
              let scanViewConfig = try? ALScanViewConfig.withJSONString(configJSONStr),
              let viewPluginConfig = scanViewConfig.viewPluginConfig else {
            return
        }

        do {
            let scanViewPlugin = try ALScanViewPlugin(config: viewPluginConfig)
            scanViewPlugin.scanPlugin.delegate = self
            if self.scanView == nil {
                let scanView = try ALScanView(frame: .zero, scanViewPlugin: scanViewPlugin)
                self.installScanView(scanView)
                scanView.delegate = self
                scanView.startCamera()
                self.scanView = scanView
            } else {
                try self.scanView?.setViewPlugin(scanViewPlugin)
                self.scanView?.startCamera()
            }
            try startScanning()
        } catch {
            if (self.popWithAlert(onError: error)) {
                return
            }
        }
    }
}

extension ALTireViewController: ALScanPluginDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {

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
            guard let self = self else { return }
            let vc = ALResultViewController(results: resultEntries)
            vc.imagePrimary = scanResult.croppedImage

            self.isOrientationFlipped = false
            self.enableLandscapeOrientation(false)
            self.navigationController?.pushViewController(vc, animated: true)
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

@objc class ALTireMakeViewController: ALTireViewController {
    override func viewDidLoad() {
        configType = .tireMake
        super.viewDidLoad()
    }
}

@objc class ALTINDotViewController: ALTireViewController {
    override func viewDidLoad() {
        configType = .tinConfig
        super.viewDidLoad()

        // starts in landscape mode (APP-383)
        self.isOrientationFlipped = true
        self.enableLandscapeOrientation(true)
    }
}
