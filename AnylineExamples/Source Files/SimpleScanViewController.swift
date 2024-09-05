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

    private let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        if #available(iOS 13.0, *) {
            textView.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        }
        return textView
    }()

    private var configFilename: String

    private var scanView: ALScanView!

    private var scanViewConfigJSONStr: String!

    private let showConfigButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Config", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        return button
    }()

    @objc
    init(configFilename: String) {
        self.configFilename = configFilename
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
            try setupAnyline(configFilename: configFilename)
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

        self.addScanView(scanView: self.scanView)
        self.scanView.startCamera()

        self.addShowConfigButton()
    }

    @objc func showConfigButtonTapped() {
        try? self.scanView.stopScanning()
        showBigBodyAlert(scanViewConfigJSONStr, title: "Config") { [weak self] _ in
            try? self?.scanView.startScanning()
        }
    }

    func setupAnyline(configFilename: String) throws {

        // Initialize the ScanViewConfig with an Anyline config read from a JSON file
        scanViewConfigJSONStr = try type(of: self).anylineConfigString(from: configFilename)
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
        guard let path = Bundle.main.path(forResource: filename, ofType: "json", inDirectory: "AnylineConfigs.bundle") else {
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

    private func addShowConfigButton() {
        self.view.addSubview(showConfigButton)
        showConfigButton.translatesAutoresizingMaskIntoConstraints = false
        showConfigButton.centerXAnchor.constraint(equalTo: scanView.centerXAnchor).isActive = true
        showConfigButton.bottomAnchor.constraint(equalTo: scanView.bottomAnchor, constant: -25).isActive = true
        showConfigButton.addTarget(self, action: #selector(showConfigButtonTapped), for: .touchUpInside)
    }
}

extension SimpleScanViewController: ALScanPluginDelegate {
    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {
        print("Scan Result: \(scanResult.resultDictionary)")
        let modalVC = ResultViewController()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.images = [ scanResult.croppedImage ]
        modalVC.resultText = scanResult.asJSONStringPretty(true)
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
    }
}


extension SimpleScanViewController: ResultViewControllerDelegate {

    func didDismissModalViewController(_ viewController: ResultViewController) {
        try? self.scanView.startScanning()
    }
}

extension SimpleScanViewController {

    private func showErrorAlert(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert: UIAlertController = .init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .default, handler: handler))
        self.navigationController?.present(alert, animated: true)
    }

    private func showBigBodyAlert(_ body: String, title: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let newLines = String(repeating: "\n", count: 12)
        let alertController: UIAlertController = .init(title: title, message: newLines, preferredStyle: .alert)
        alertController.addAction(.init(title: "Okay", style: .default, handler: { [weak alertController] action in
            alertController?.view.removeObserver(self, forKeyPath: "bounds")
            handler?(action)
        }))
        textView.text = body
        textView.backgroundColor = .clear
        textView.textContainerInset = .init(top: 8, left: 5, bottom: 8, right: 5)
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        alertController.view.addObserver(self, forKeyPath: "bounds",
                                         options: NSKeyValueObservingOptions.new,
                                         context: nil)
        alertController.view.addSubview(textView)
        self.navigationController?.present(alertController, animated: true)
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin: CGFloat = 8
                let xPos = rect.origin.x + margin
                let yPos = rect.origin.y + 54
                let width = rect.width - 2 * margin
                let height: CGFloat = rect.size.height - 112
                textView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
            }
        }
    }
}
