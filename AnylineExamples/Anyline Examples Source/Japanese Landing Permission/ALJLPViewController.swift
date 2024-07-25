import Foundation
import Anyline

@objc(ALJLPViewController)
class ALJLPViewController: ALBaseScanViewController {

    var scanViewConfig: ALScanViewConfig?
    let japaneseLandingPermissionScanVC_configJSONFilename = "japanese_landing_permission_config"
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    func configure() {
        var titleString: String?
        titleString = "Japanese Landing Permission"
        self.controllerType = ALScanHistoryJapaneseLandingPermission
        self.title = titleString

        guard let configJSONStr = try? self.configJSONStr(withFilename: japaneseLandingPermissionScanVC_configJSONFilename) as NSString,
           let configDict = configJSONStr.asJSONObject() as? [AnyHashable: Any] else {
            return
        }

        do {
            let scanViewPlugin = try ALScanViewPlugin(jsonDictionary: configDict)
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

extension ALJLPViewController: ALScanPluginDelegate {

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
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
