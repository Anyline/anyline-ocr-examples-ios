//
//  SerialNumberSettingsViewController.swift
//  AnylineExamples
//
//  Created by Angela Brett on 15.07.20.
//

import UIKit

class SerialNumberSettingsViewController: BaseSettingsViewController {
    static let cellReuseIdentifier = "SerialNumberSettingsCellIdentifier"
    static let checkmarkCellReuseIdentifier = "checkmarkCellReuseIdentifier"
    enum Section : CaseIterable {
        case scanAreaSettings,characterSettings,reset //it's not clear yet whether we want this separate reset button at the bottom, or the one in the navbar (which we can add with addResetButton())
        static func getSection(_ section: Int) -> Section {
            return self.allCases[section]
        }
    }
    
    enum CharacterSetting : CaseIterable {
        case basicSettings,advancedSettings
        static func getRow(_ section: Int) -> CharacterSetting {
            return self.allCases[section]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Serial Number Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
    }
    
    func refreshCheckmarks() {
        //we just need to reload the character settings section so the checkmark is shown in the right place, so if the table gets larger it might be quicker to just load specific rows here.
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshCheckmarks()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.getSection(section) {
        case .scanAreaSettings:
            return 1
        case .characterSettings:
            return CharacterSetting.allCases.count
        case .reset:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section.getSection(section) {
        case .scanAreaSettings:
            return "Scan area settings"
        case .characterSettings:
            return "Character settings"
        case .reset:
            return resetSectionHeading
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
        switch Section.getSection(indexPath.section) {
        case .scanAreaSettings:
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Scan area editor"
        case .characterSettings:
            let checkmarkCell = ALLeftCheckmarkCell(style: .subtitle, reuseIdentifier: Self.checkmarkCellReuseIdentifier)
            cell = checkmarkCell
            cell.accessoryType = .disclosureIndicator
            switch CharacterSetting.getRow(indexPath.row) {
            case .basicSettings:
                checkmarkCell.isChecked = !SerialNumberSettings.shared.isUsingAdvancedCharacterSettings
                checkmarkCell.rowWasChecked = { _ in
                    SerialNumberSettings.shared.isUsingAdvancedCharacterSettings = false
                    self.refreshCheckmarks()
                }
                cell.textLabel?.text = "Basic character settings"
            case .advancedSettings:
                checkmarkCell.isChecked = SerialNumberSettings.shared.isUsingAdvancedCharacterSettings
                checkmarkCell.rowWasChecked = { _ in
                    SerialNumberSettings.shared.isUsingAdvancedCharacterSettings = true
                    self.refreshCheckmarks()
                }
                cell.textLabel?.text = "Advanced character settings"
                //cell.detailTextLabel?.text = "Regex & allow list" //we might put this back if we bring back the allow list
            }
        case .reset:
            cell.textLabel?.text = "Reset all settings to default"
            setUpResetCell(cell)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section.getSection(indexPath.section) {
        case .scanAreaSettings:
            self.navigationController?.pushViewController(ScanAreaEditorViewController.init(style: .grouped), animated: true)
        case .characterSettings:
            switch CharacterSetting.getRow(indexPath.row) {
            case .basicSettings:
                self.navigationController?.pushViewController(BasicSettingsViewController.init(style: .grouped), animated: true)
            case .advancedSettings:
                self.navigationController?.pushViewController(AdvancedSettingsViewController.init(style: .grouped), animated: true)
            }
        case .reset:
            resetSettings()
            break
        }
    }
    
    override func reset () {
        SerialNumberSettings.shared.reset()
        CutoutSettings.shared.reset()
        refreshCheckmarks()
    }
}
