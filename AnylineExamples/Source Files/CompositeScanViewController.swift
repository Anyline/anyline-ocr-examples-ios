import UIKit
import Anyline

/// Demo for a composite scanning workflow involving 2 or more plugins
///
/// The view controller loads the config JSON whose filename is supplied in the initializer into its
/// ALScanViewPlugin and ALScanView.
///
class CompositeScanViewController: UIViewController {
    // Some special error types
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

    private var configFileName: String

    private var scanView: ALScanView!

    private var scanViewConfigJSONStr: String!

    private let showConfigButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Config", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
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

        self.addScanView(scanView: self.scanView)
        self.scanView.startCamera()

        self.view.addSubview(showConfigButton)
        showConfigButton.translatesAutoresizingMaskIntoConstraints = false

        showConfigButton.centerXAnchor.constraint(equalTo: scanView.centerXAnchor).isActive = true
        showConfigButton.bottomAnchor.constraint(equalTo: scanView.bottomAnchor, constant: -25).isActive = true
        showConfigButton.addTarget(self, action: #selector(showConfigButtonTapped), for: .touchUpInside)
    }

    @objc func showConfigButtonTapped() {
        try? self.scanView.stopScanning()
        showBigBodyAlert(scanViewConfigJSONStr, title: "Config") { [weak self] _ in
            try? self?.scanView.startScanning()
        }
    }

    func setupAnyline(configFileName: String) throws {

        // Initialize the ScanViewPlugin with an Anyline config read from a JSON file
        scanViewConfigJSONStr = try type(of: self).anylineConfigString(from: configFileName)

        // Initialize the ScanView.
        let scanViewConfig = try ALScanViewConfig(jsonString: scanViewConfigJSONStr)
        self.scanView = try ALScanView(frame: .zero, scanViewConfig: scanViewConfig)

        // Start the ScanViewPlugin. Remember to set the ScanPlugin delegate.
        if let viewPluginComposite = self.scanView.viewPlugin as? ALViewPluginComposite {
            viewPluginComposite.delegate = self
        }

        try self.scanView.startScanning()
    }

    private static func anylineConfigString(from fileName: String) throws -> String {
        // Passing filename with .json extension from previous VC
        guard let path = Bundle.main.path(forResource: fileName, ofType: "", inDirectory: "AnylineConfigs.bundle") else {
            throw AnylineError.configError(msg: "no such path: \(fileName)")
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
}

extension CompositeScanViewController: ALViewPluginCompositeDelegate {
    func viewPluginComposite(_ viewPluginComposite: ALViewPluginComposite, allResultsReceived scanResults: [ALScanResult]) {
        print("All scan results: \(scanResults)")

        let modalVC = ResultViewController()
        modalVC.modalPresentationStyle = .overFullScreen

        modalVC.images = scanResults.map { $0.croppedImage }
        modalVC.resultText = scanResults.map { $0.asJSONStringPretty(true) }.joined(separator: "\n")

        modalVC.delegate = self

        present(modalVC, animated: true, completion: nil)
    }
}


extension CompositeScanViewController: ResultViewControllerDelegate {
    
    func didDismissModalViewController(_ viewController: ResultViewController) {
        try? self.scanView.startScanning()
    }

    private func showResultAlert(_ body: String, handler: ((UIAlertAction) -> Void)? = nil) {
        showBigBodyAlert(body, title: "Result", handler: handler)
    }

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
