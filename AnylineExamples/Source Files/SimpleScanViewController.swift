import UIKit
import Anyline

/// Demo for a basic scanning workflow with a single plugin config
///
/// The view controller loads the config JSON whose filename is supplied in the initializer into its
/// ALScanViewPlugin and ALScanView.
///
/// NOTE: the value of `cancelOnResult` in config is ignored. Each result causes the plugin to stop.
class SimpleScanViewController: UIViewController {

    // Some special error types.
    enum AnylineError: Error {
        case configError(msg: String)
    }

    private var configFileName: String

    private var scanView: ALScanView!

    private var scanViewConfigJSONStr: String!

    private var lastResultText: String? {
        didSet {
            if lastResultText != nil {
                showLastResultButton.isEnabled = true
            }
        }
    }

    private var lastResultImage: UIImage?

    private var totalScanned = 0

    private var isCancelOnResult: Bool {
        return true == scanView.scanViewConfig?.viewPluginConfig?.pluginConfig.cancelOnResult?.boolValue
    }

    private let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        if #available(iOS 13.0, *) {
            textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        }
        return textView
    }()

    private let infoBox: InfoScrollBox = {
        let infoScrollBox = InfoScrollBox(frame: .zero)
        infoScrollBox.translatesAutoresizingMaskIntoConstraints = false
        return infoScrollBox
    }()

    private let showInfoConfigButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Config", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()

    private let showLastResultButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Last Result", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()

    @objc
    init(configFileName: String) {
        self.configFileName = configFileName
        super.init(nibName: nil, bundle: nil)
    }

    init() {
        fatalError("call init with configFilename instead")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try setupAnyline(configFileName: configFileName)
        } catch {
            var errorMsg = "Anyline error: \(error.localizedDescription)"
            if let anylineError = error as? AnylineError {
                switch anylineError {
                case let .configError(msg):
                    errorMsg = "Unable to load Anyline config:\n\n\(msg)"
                }
            }
            showErrorAlert(errorMsg) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }

        addScanView(scanView: self.scanView)

        scanView.startCamera()

        addInfoBoxAndDismissButton()

        addExtraButtons()
    }

    @objc func showConfigButtonTapped() {
        try? scanView.stopScanning()
        showInfoBox(mode: .configuration, text: scanViewConfigJSONStr, image: nil)
    }

    @objc func showLastResultButtonTapped() {
        try? scanView.stopScanning()
        showInfoBox(mode: .result, text: lastResultText, image: lastResultImage)
    }

    func setupAnyline(configFileName: String) throws {

        // Initialize the ScanViewConfig with an Anyline config read from a JSON file
        scanViewConfigJSONStr = try type(of: self).anylineConfigString(from: configFileName)
        let scanViewConfig = try ALScanViewConfig.withJSONString(scanViewConfigJSONStr)

        // Initialize the ScanView.
        self.scanView = try ALScanView(frame: .zero,
                                       scanViewConfig: scanViewConfig)

        // Start the ScanViewPlugin. Remember to set the ScanPlugin delegate.
        if let scanViewPlugin = self.scanView.viewPlugin as? ALScanViewPlugin {
            scanViewPlugin.scanPlugin.delegate = self
        }

        try self.scanView.startScanning()
    }

    private static func anylineConfigString(from filename: String) throws -> String {
        // Passing filename with .json extension from previous VC
        guard let path = Bundle.main.path(forResource: filename, ofType: "", inDirectory: "AnylineConfigs.bundle") else {
            throw AnylineError.configError(msg: "no such path: \(filename)")
        }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path, isDirectory: false)),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw AnylineError.configError(msg: "unable to read config file from resource: \(path)")
        }
        return jsonString
    }

    private func addScanView(scanView: ALScanView) {
        self.view.addSubview(scanView)
        scanView.translatesAutoresizingMaskIntoConstraints = false
        scanView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scanView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scanView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scanView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func showInfoBox(mode: InfoScrollBox.Mode, text: String?, image: UIImage?) {

        infoBox.text = text
        infoBox.images = image != nil ? [ image! ] : []
        infoBox.visibility = mode

        var showButtons = false
        switch mode {
        case .none:
            showButtons = true
        default:
            break
        }

        showInfoConfigButton.isHidden = !showButtons
        showLastResultButton.isHidden = !showButtons
    }

    private func addInfoBoxAndDismissButton() {
        self.view.addSubview(infoBox)

        NSLayoutConstraint.activate([
            infoBox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            infoBox.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            infoBox.topAnchor.constraint(equalTo: self.view.topAnchor),
            infoBox.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])

        infoBox.visibility = .none

        infoBox.scrollBoxVisibilityChanged = { [weak self] scrollBoxVisible in
            self?.showInfoConfigButton.isHidden = scrollBoxVisible
            self?.showLastResultButton.isHidden = scrollBoxVisible

            if !scrollBoxVisible {
                try? self?.scanView.startScanning()
            }
        }
    }

    private func addExtraButtons() {
        self.view.addSubview(showLastResultButton)
        showLastResultButton.translatesAutoresizingMaskIntoConstraints = false
        showLastResultButton.leadingAnchor.constraint(equalTo: scanView.leadingAnchor, constant: 20).isActive = true
        showLastResultButton.bottomAnchor.constraint(equalTo: scanView.bottomAnchor, constant: -40).isActive = true
        showLastResultButton.addTarget(self, action: #selector(showLastResultButtonTapped), for: .touchUpInside)

        self.view.addSubview(showInfoConfigButton)
        showInfoConfigButton.translatesAutoresizingMaskIntoConstraints = false
        showInfoConfigButton.leadingAnchor.constraint(equalTo: showLastResultButton.trailingAnchor, constant: 25).isActive = true
        showInfoConfigButton.bottomAnchor.constraint(equalTo: showLastResultButton.bottomAnchor).isActive = true
        showInfoConfigButton.addTarget(self, action: #selector(showConfigButtonTapped), for: .touchUpInside)

        showLastResultButton.isEnabled = false
    }
}

extension SimpleScanViewController: ALScanPluginDelegate {

    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {
        print("Scan Result: \(scanResult.resultDictionary)")

        let resultString = scanResult.asJSONStringPretty(true)

        lastResultText = resultString
        lastResultImage = scanResult.croppedImage

        infoBox.text = lastResultText
        infoBox.images = lastResultImage != nil ? [ lastResultImage! ] : []

        if isCancelOnResult {
            try? scanView.stopScanning()
            infoBox.visibility = .result
        } else {
            if let barcodes = scanResult.pluginResult.barcodeResult?.barcodes {
                totalScanned += barcodes.count
            } else {
                totalScanned += 1
            }
            infoBox.visibility = .resultWithTotals(totalScanned)
        }
    }
}


extension SimpleScanViewController: ResultViewControllerDelegate {

    func didDismissModalViewController(_ viewController: ResultViewController,
                                       restart: Bool) {
        guard restart else {
            self.navigationController?.popViewController(animated: false)
            return
        }
        try? self.scanView.startScanning()
    }
}


extension SimpleScanViewController {

    private func showErrorAlert(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert: UIAlertController = .init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .default, handler: handler))
        self.navigationController?.present(alert, animated: true)
    }
}
