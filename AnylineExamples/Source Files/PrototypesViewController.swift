import UIKit
import Anyline

class PrototypesViewController: UITableViewController {
    
    // List of dictionaries with fileName and scanViewConfig
    private var configLists: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Anyline Developer Examples"
        loadConfigs()
        setupLicenseInfoHeader()

        // Assign custom "Back" button to previous view controller's navigation item
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationItem.backBarButtonItem = backButton
    }

    private func setupLicenseInfoHeader() {
        let headerView = UIView()

        // Use semantic colors for dark mode support (iOS 13+), with fallback for iOS 12
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = .secondarySystemGroupedBackground
        } else {
            headerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // SDK Version label
        let versionLabel = UILabel()
        versionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        if #available(iOS 13.0, *) {
            versionLabel.textColor = .secondaryLabel
        } else {
            versionLabel.textColor = .darkGray
        }
        versionLabel.text = "Anyline SDK v\(AnylineSDK.versionNumber()) (build \(AnylineSDK.buildNumber()))"

        // License expiry label
        let expiryLabel = UILabel()
        expiryLabel.font = .systemFont(ofSize: 13)
        if #available(iOS 13.0, *) {
            expiryLabel.textColor = .secondaryLabel
        } else {
            expiryLabel.textColor = .darkGray
        }
        if AnylineSDK.isInitialized() {
            expiryLabel.text = "License expires: \(AnylineSDK.licenseExpirationDate())"
        } else {
            expiryLabel.text = "License not initialized"
            if #available(iOS 13.0, *) {
                expiryLabel.textColor = .systemRed
            } else {
                expiryLabel.textColor = .red
            }
        }

        stackView.addArrangedSubview(versionLabel)
        stackView.addArrangedSubview(expiryLabel)
        headerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])

        // Size the header view to fit its content
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + 32
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)

        tableView.tableHeaderView = headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configLists.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let style: UITableViewCell.CellStyle = .subtitle // can be .default for other cases depending on section
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: style, reuseIdentifier: "cell")
        }
        
        let configDetails = configLists[indexPath.row]
        if let fileName = configDetails["fileName"] as? String, let scanViewConfig = configDetails["scanViewConfig"] as? ALScanViewConfig {
            cell.imageView?.image = UIImage(named: "ic_file")
            cell.textLabel?.text = fileName
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = scanViewConfig.scanViewConfigDescription
            cell.detailTextLabel?.numberOfLines = 0
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let configDetails = configLists[indexPath.row]
        if let fileName = configDetails["fileName"] as? String, let scanViewConfig = configDetails["scanViewConfig"] as? ALScanViewConfig {
            var viewController: UIViewController!

            let useOverlays = useOverlayUI(config: scanViewConfig)
            let isComposite = scanViewConfig.viewPluginCompositeConfig != nil

            // use overlays UI with these configs
            if useOverlays {
                viewController = BarcodeOverlayScanViewController(configFileName: fileName)
            } else {
                if isComposite {
                    viewController = CompositeScanViewController(configFileName: fileName)
                } else {
                    viewController = SimpleScanViewController(configFileName: fileName)
                }
            }
            print("loaded: \(fileName) - \(useOverlays ? "overlays" : (isComposite ? "composite": "simple"))")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    private func useOverlayUI(config: ALScanViewConfig) -> Bool {
        // plugin id contains "overlay"
        if let id = config.viewPluginConfig?.pluginConfig.identifier {
            let idComponents = id.components(separatedBy: "_").map { $0.lowercased() }
            if idComponents.contains("overlay") {
                return true
            }
        }
        return false
    }
    func loadConfigs() {
        let paths = Bundle.main.paths(forResourcesOfType: ".json", inDirectory: "AnylineConfigs.bundle")
        var configDetail: [String:Any] = [:]
        for path in paths {
            let fileName = (path as NSString).lastPathComponent
            configDetail["fileName"] = fileName
            configDetail["scanViewConfig"] = scanViewConfig(configFileName: fileName)
            configLists.append(configDetail)
        }
        configLists.sort { config1, config2 in
            if let fileName1 = config1["fileName"] as? String, let fileName2 = config2["fileName"] as? String {
                return (fileName1.localizedCaseInsensitiveCompare(fileName2) == .orderedAscending)
            } else{
                return false
            }
        }
    }
    
    func scanViewConfig(configFileName: String) -> ALScanViewConfig? {
        var scanViewConfig:ALScanViewConfig? = nil
        do {
            if let scanViewConfigJSONStr = try anylineConfigString(from: configFileName) {
                scanViewConfig = try ALScanViewConfig(jsonString: scanViewConfigJSONStr)
            }
        } catch {
            print(error)
        }
        return scanViewConfig
    }
    
    func anylineConfigString(from filename: String) throws -> String? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "", inDirectory: "AnylineConfigs.bundle") else {
            return nil
        }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path, isDirectory: false)),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
}
