import UIKit
import Anyline

class PrototypesViewController: UITableViewController {
    
    // List of dictionaries with fileName and scanViewConfig
    private var configLists: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Anyline Developer Examples"
        loadConfigs()
        
        // Assign custom "Back" button to previous view controller's navigation item
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationItem.backBarButtonItem = backButton
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
            cell.imageView?.image = UIImage.init(named: "ic_file")
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
            if scanViewConfig.viewPluginCompositeConfig != nil {
                viewController = CompositeScanViewController(configFileName: fileName)
            } else {
                viewController = SimpleScanViewController(configFileName: fileName)
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
