//
//  BasicSettingsViewController.swift
//  AnylineExamples
//
//  Created by Angela Brett on 15.07.20.
//

import UIKit

class BasicSettingsViewController: BaseSettingsViewController {
    static let cellReuseIdentifier = "BasicSettingsPlainCellIdentifier"
    static let textCellReuseIdentifier = "BasicSettingsTextCellIdentifier"
    static let sliderCellReuseIdentifier = "BasicSettingsSliderCellIdentifier"
        
    enum Section : Int, CaseIterable {
        case numberOfCharacters,include,excludedCharacters,reset
        static func getSection(_ section: Int) -> Section {
            return self.allCases[section]
        }
    }
    
    enum NumberOfCharactersSetting : Int, CaseIterable {
        case minimum,maximum
        static func getSetting(_ section: Int) -> NumberOfCharactersSetting {
            return self.allCases[section]
        }
    }
    
    var selectedIncludeSetting = SerialNumberSettings.shared.includeSetting
    var minCharacters = SerialNumberSettings.shared.minCharacters
    var maxCharacters = SerialNumberSettings.shared.maxCharacters
    var excludedCharacters = SerialNumberSettings.shared.excludedCharacters
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addSaveButton()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
        tableView.register(ALTextInputTableViewCell.self, forCellReuseIdentifier: Self.textCellReuseIdentifier)
        tableView.register(ALSliderTableViewCell.self, forCellReuseIdentifier: Self.sliderCellReuseIdentifier)
        self.title = "Basic character settings"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.getSection(section) {
        case .numberOfCharacters:
            return NumberOfCharactersSetting.allCases.count
        case .include:
            return IncludeSetting.allCases.count
        case .excludedCharacters:
            return 1
        case .reset:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section.getSection(section) {
        case .numberOfCharacters:
            return "Number of characters"
        case .include:
            return "Include"
        case .excludedCharacters:
            return "Exclude characters"
        case .reset:
            return resetSectionHeading
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == Section.excludedCharacters.rawValue {
         return """
• Numbers 0–9
• Capital letters only
"""
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = {
            switch Section.getSection(indexPath.section) {
            case .numberOfCharacters:
                let cell = tableView.dequeueReusableCell(withIdentifier: Self.sliderCellReuseIdentifier, for: indexPath)
                if let sliderCell = cell as? ALSliderTableViewCell {
                    sliderCell.maximumValue = 20
                    sliderCell.minimumValue = 4
                    sliderCell.isPercentage = false
                    switch NumberOfCharactersSetting.getSetting(indexPath.row) {
                    case .minimum:
                        sliderCell.title = "Minimum"
                        sliderCell.sliderValueDidChange = {
                            cell in
                            self.minCharacters = UInt(lroundf(cell.value))
                            let maximumPath = IndexPath(row: NumberOfCharactersSetting.maximum.rawValue, section: indexPath.section)
                            if let maximumCell = tableView.cellForRow(at: maximumPath) as? ALSliderTableViewCell {
                                if maximumCell.value < cell.value {
                                    maximumCell.value = cell.value
                                }
                            }
                            self.settingsDidChange()
                        }
                        sliderCell.value = Float(minCharacters)
                        sliderCell.isPercentage = false
                    case .maximum:
                        sliderCell.title = "Maximum"
                        sliderCell.sliderValueDidChange = {
                            cell in
                            self.maxCharacters = UInt(lroundf(cell.value))
                            let minimumPath = IndexPath(row: NumberOfCharactersSetting.minimum.rawValue, section: indexPath.section)
                            if let minimumCell = tableView.cellForRow(at: minimumPath) as? ALSliderTableViewCell {
                                if minimumCell.value > cell.value {
                                    minimumCell.value = cell.value
                                }
                            }
                            self.settingsDidChange()
                        }
                        sliderCell.value = Float(maxCharacters)
                    }
                }
                return cell
            case .include:
                let includeSetting = IncludeSetting.getSetting(indexPath.row)
                let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
                switch includeSetting {
                case .numbersAndCapitals:
                    cell.textLabel?.text = "Numbers and capital letters"
                case .numbersOnly:
                    cell.textLabel?.text = "Numbers only"
                case .capitalsOnly:
                    cell.textLabel?.text = "Capital letters only"
                }
                setChecked(for: cell, to: (includeSetting == selectedIncludeSetting))
                return cell
            case .excludedCharacters:
                let cell = tableView.dequeueReusableCell(withIdentifier: Self.textCellReuseIdentifier, for: indexPath)
                (cell as? ALTextInputTableViewCell)?.placeholder = "Type in your excluded characters list"
                (cell as? ALTextInputTableViewCell)?.value = excludedCharacters
                (cell as? ALTextInputTableViewCell)?.valueDidChange = { value in
                    self.excludedCharacters = value
                    self.settingsDidChange()
                }
                return cell
            case .reset:
                let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
                cell.textLabel?.text = "Reset basic settings to default"
                setUpResetCell(cell)
                return cell
            }
        }()
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section.getSection(indexPath.section) {
        case .numberOfCharacters:
            break
        case .include:
            let newSetting = IncludeSetting.getSetting(indexPath.row)
            if newSetting != selectedIncludeSetting {
                let oldSelectedCell = tableView.cellForRow(at: IndexPath(row: selectedIncludeSetting.rawValue, section: indexPath.section))
                setChecked(for: oldSelectedCell, to: false)
                selectedIncludeSetting = newSetting
                setChecked(for: tableView.cellForRow(at: indexPath), to:true)
                self.settingsDidChange()
            }
        case .excludedCharacters:
            break
        case .reset:
            resetSettings()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func reset() {
        SerialNumberSettings.shared.resetBasicSettings()
        selectedIncludeSetting = SerialNumberSettings.shared.includeSetting
        minCharacters = SerialNumberSettings.shared.minCharacters
        maxCharacters = SerialNumberSettings.shared.maxCharacters
        excludedCharacters = SerialNumberSettings.shared.excludedCharacters
        tableView.reloadData()
    }
    
    override func saveSettings() {
        SerialNumberSettings.shared.characterSetting = .basic(minCharacters: self.minCharacters, maxCharacters: self.maxCharacters, includeSetting: self.selectedIncludeSetting, excludedCharacters: self.excludedCharacters)
        self.view.endEditing(true)
        super.saveSettings()
    }
}
