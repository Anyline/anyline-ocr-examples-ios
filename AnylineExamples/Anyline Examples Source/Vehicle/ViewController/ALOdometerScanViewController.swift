import Foundation
import Anyline

@objc(ALOdometerScanViewController)
class ALOdometerScanViewController: ALBaseScanViewController {

    private var configJSONFilename: String = "odometer_config"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Odometer"
        self.controllerType = ALScanHistoryOdometer
        configureScanView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try! self.startScanning()
    }

    fileprivate func configureScanView() {

        guard let JSONStr = try? self.configJSONStr(withFilename: configJSONFilename) else {
            let error = NSError(domain: "com.anyline.examples",
                                code: 1001,
                                userInfo: [NSLocalizedDescriptionKey : "file \(configJSONFilename) not found."])
            popWithAlert(onError: error)
            return
        }

        do {
            self.scanView = try ALScanViewFactory.withJSONString(JSONStr, delegate: self)
        } catch {
            if (self.popWithAlert(onError: error)) {
                return
            }
        }

        if let scanView = self.scanView {
            self.installScanView(scanView)
            scanView.startCamera()
        }
    }

    fileprivate func displayResults(entries: [ALResultEntry], image: UIImage?) {
        guard let scanViewPlugin = self.scanView?.viewPlugin as? ALScanViewPlugin,
              let JSONString = entries.JSONStringFromResultData else {
            return
        }

        self.anylineDidFindResult(JSONString,
                                  barcodeResult: nil,
                                  image: image,
                                  scanPlugin: scanViewPlugin.scanPlugin,
                                  viewPlugin: scanViewPlugin) { [weak self] in
            let resultVC: ALResultViewController = .init(results: entries)
            resultVC.imagePrimary = image
            self?.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}

extension ALOdometerScanViewController: ALScanPluginDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {
        let resultEntries = (scanResult.pluginResult.fieldList() as NSArray).resultEntries
        let resultImage = scanResult.croppedImage
        displayResults(entries: resultEntries, image: resultImage)

    }
}
