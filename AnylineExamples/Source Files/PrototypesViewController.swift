import UIKit

class PrototypesViewController: UITableViewController {
    // group names of examples are indicated in configs.json. All those not matching
    // the ones here are filtered into "Others"
    private static let initialGroupNames: [String] = [
        "Vehicle", "Meter Reading", "Barcode", "Identity Documents", "Others"
    ]

    private var groupNames: [String] = []

    private var configGroups: [String: [Example]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Anyline Developer Examples"
        loadConfigs()

        // Assign custom "Back" button to previous view controller's navigation item
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationItem.backBarButtonItem = backButton
    }

    private func loadConfigs() {
        guard let examples = Example.examplesFromBundle() else { return }
        let enabledExamples = examples.filter { $0.isEnabled }
        self.configGroups = type(of: self).loadConfigsIntoGroups(examples: enabledExamples, groupNames: type(of:self).initialGroupNames)

        // only list those named in initialGroupNames
        self.groupNames = type(of:self).initialGroupNames.filter({ str in
            self.configGroups.keys.contains(str)
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = groupNames[section]
        if let group = configGroups[key] {
            return group.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupNames[section]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = indexPath.section
        let identifier = "section-\(section)"

        let style: UITableViewCell.CellStyle = .subtitle // can be .default for other cases depending on section

        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: style, reuseIdentifier: identifier)
        }

        var example: Example?
        let key = groupNames[section]
        if let group: [Example] = configGroups[key] {
            example = group[indexPath.row]
        }

        if #available(iOS 14.0, *) {
            var cellConfig = cell.defaultContentConfiguration()
            if let example = example {
                cellConfig.text = example.displayName
                cellConfig.secondaryText = "\(example.filename).json"
            }
            cell.contentConfiguration = cellConfig
        } else {
            cell.textLabel?.text = example?.filename
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        self.tableView.deselectRow(at: indexPath, animated: true)
        let key = groupNames[section]
        if let group: [Example] = configGroups[key] {
            let selectedExample = group[indexPath.row]

            var viewController: UIViewController!
            if selectedExample.isComposite {
                viewController = CompositeScanViewController(configFilename: selectedExample.filename)
            } else {
                viewController = SimpleScanViewController(configFilename: selectedExample.filename)
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private static func loadConfigsIntoGroups(examples: [Example],
                                              groupNames: [String]) -> [String: [Example]] {
        var mutDict = [String: [Example]]()
        for example in examples {
            var groupName: String = "Others"
            if let trimmedName = example.groupName?.trimmingCharacters(in: .whitespacesAndNewlines),
               groupNames.contains(trimmedName) {
                groupName = trimmedName
            }
            if var group = mutDict[groupName] {
                group.append(example)
                mutDict[groupName] = group
            } else {
                mutDict[groupName] = [ example ]
            }
        }
        return mutDict
    }
}


struct Example: Codable {

    let filename: String
    let displayName: String?
    let description: String?
    let groupName: String?
    let composite: Bool?
    let enabled: Bool?

    init(filename: String, displayName: String?, groupName: String?, description: String?, composite: Bool = false, enabled: Bool = true) {
        self.filename = filename
        self.displayName = displayName
        self.description = description
        self.composite = composite
        self.enabled = enabled
        self.groupName = groupName
    }

    var isEnabled: Bool {
        if let enabled = enabled {
            return enabled
        }
        return true // unspecified use default
    }

    var isComposite: Bool {
        if let composite = composite {
            return composite
        }
        return false // unspecified use default
    }

    static func examplesFromBundle() -> [Example]? {
        // get the plist and load the config arrays with the contents
        guard let path = Bundle.main.path(forResource: "configs", ofType: "json", inDirectory: "AnylineConfigs.bundle"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("unable to get configlist")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let examples = try decoder.decode([Example].self, from: data)
            return examples
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
}
