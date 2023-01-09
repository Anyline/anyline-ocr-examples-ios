//
//  AdvancedSettingsViewController.swift
//  AnylineExamples
//
//  Created by Angela Brett on 15.07.20.
//

import UIKit

class AdvancedSettingsViewController: BaseSettingsViewController {
    static let textCellReuseIdentifier = "AdvancedSettingsTextCellIdentifier"
    
    var regex = SerialNumberSettings.shared.regex
    var allowlist = SerialNumberSettings.shared.allowlist
    
    var isRegularExpressionValid = true {
        didSet {
            //update the footer below the regex text box to show that there's an error
            UIView.setAnimationsEnabled(false)
             tableView.beginUpdates()

            if let footer = footerView(section: Section.regex), let textLabel = footer.textLabel {
                textLabel.text = regexFooterText()
                //set to red if the regex is invalid, otherwise the text colour of the header
                //this is the easiest way to get the standard text colour in both dark and light mode, since UIColor.label etc. are not available in all iOS versions
                let invalidRegexColor = UIColor.systemRed
                if let headerText = headerView(section: Section.regex)?.textLabel {
                    textLabel.textColor = isRegularExpressionValid ? headerText.textColor : invalidRegexColor
                }
                footer.sizeToFit()
             }
            
             tableView.endUpdates()
             UIView.setAnimationsEnabled(true)
        }
    }
    
    enum Section : Int, CaseIterable {
        //we might decide to bring back allowlist in the future
        case regex/*,allowlist*/,reset
        static func getSection(_ section: Int) -> Section {
            return self.allCases[section]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSaveButton()
        tableView.register(ALTextInputTableViewCell.self, forCellReuseIdentifier: Self.textCellReuseIdentifier)
        self.title = "Advanced character settings"
    }

    func footerView(section:Section) -> UITableViewHeaderFooterView? {
        return tableView.footerView(forSection: section.rawValue)
    }
    
    func headerView(section:Section) -> UITableViewHeaderFooterView? {
        return tableView.headerView(forSection: section.rawValue)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Self.textCellReuseIdentifier, for: indexPath)
        if let textInputCell = cell as? ALTextInputTableViewCell {
            switch Section.getSection(indexPath.section) {
            case .regex:
                textInputCell.placeholder = "Type in your desired regular expression"
                textInputCell.capitalsOnly = false //they won't want to match any literal lowercase characters, but might need to use shorthands such as \d
                textInputCell.valueDidChange = {
                    value in
                    let regex = try? NSRegularExpression(pattern: value)
                    if (regex != nil) != self.isRegularExpressionValid {
                        self.isRegularExpressionValid = regex != nil
                    }
                    if self.isRegularExpressionValid {
                        self.regex = value
                        self.settingsDidChange()
                    }
                }
                textInputCell.value = regex
                //we might bring this back in future
            /*case .allowlist:
                textInputCell.placeholder = "Type in your allowed characters list"
                textInputCell.value = allowlist
                textInputCell.valueDidChange = { value in
                    self.allowlist = value
                    self.settingsDidChange()
                }*/
            case .reset:
                cell = UITableViewCell()
                cell.textLabel?.text = "Reset advanced settings to default"
                setUpResetCell(cell)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section.getSection(section) {
        case .regex:
            return "Regex"
            //we might bring this back in future
        /*case .allowlist:
            return "Character allow list"*/
        case .reset:
            return resetSectionHeading
        }
    }
    
    func regexFooterText() -> String {
        let example = "Example: [A-Z0-9]{4,}"
        if isRegularExpressionValid {
            return example
        } else {
            return "Use a valid regex format\n\(example)"
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch Section.getSection(section) {
        case .regex:
            return regexFooterText()
        //we might bring this back in future
        /*case .allowlist:
            return """
            • Numbers 0–9
            • Capital letters only

            Example: ABCDEFG01256789
            """*/
        case .reset:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.reset.rawValue {
            resetSettings()
        }
    }
    
    override func reset() {
        SerialNumberSettings.shared.resetAdvancedSettings()
        regex = SerialNumberSettings.shared.regex
        allowlist = SerialNumberSettings.shared.allowlist
        tableView.reloadData()
    }
    
    override func saveSettings() {
        SerialNumberSettings.shared.characterSetting = .advanced(regularExpression: self.regex, allowlist: self.allowlist)
        self.view.endEditing(true)
        super.saveSettings()
    }
}
