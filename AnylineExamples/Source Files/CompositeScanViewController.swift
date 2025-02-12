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

    private var lastResultText: String? {
        didSet {
            if lastResultText != nil {
                showLastResultButton.isEnabled = true
            }
        }
    }

    private var lastResultImages: [UIImage]?

    private var configFileName: String

    private var scanView: ALScanView!

    private var scanViewConfigJSONStr: String!

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

        view.addSubview(showInfoConfigButton)

        addInfoBox()

        addExtraButtons()
    }

    @objc func showConfigButtonTapped() {
        try? self.scanView.stopScanning()
        showConfigOnInfoBox(configText: scanViewConfigJSONStr)
    }

    @objc func showLastResultButtonTapped() {
        try? scanView.stopScanning()
        showInfoBox(mode: .result, text: lastResultText, images: lastResultImages)
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

    private func showConfigOnInfoBox(configText: String?) {

        infoBox.text = configText
        infoBox.images = nil
        infoBox.visibility = .configuration

        showInfoConfigButton.isHidden = true
    }

    private func showInfoBox(mode: InfoScrollBox.Mode, text: String?, images: [UIImage]?) {

        infoBox.text = text
        infoBox.images = images
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

    private func addInfoBox() {
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


extension CompositeScanViewController: ALViewPluginCompositeDelegate {

    func viewPluginComposite(_ viewPluginComposite: ALViewPluginComposite, allResultsReceived scanResults: [ALScanResult]) {

        print("All scan results: \(scanResults)")
        let resultString = scanResults.map { $0.asJSONStringPretty(true) }.joined(separator: "\n")

        lastResultText = resultString
        lastResultImages = scanResults.map { $0.croppedImage }

        infoBox.text = lastResultText
        infoBox.images = lastResultImages

        // we assume it's cancelOnResult=true all the time with composites
        try? scanView.stopScanning()
        infoBox.visibility = .result

    }
}


extension CompositeScanViewController: ResultViewControllerDelegate {

    func didDismissModalViewController(_ viewController: ResultViewController,
                                       restart: Bool) {
        guard restart else {
            self.navigationController?.popViewController(animated: false)
            return
        }
        try? self.scanView.startScanning()
    }

    private func showErrorAlert(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert: UIAlertController = .init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .default, handler: handler))
        self.navigationController?.present(alert, animated: true)
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
