import UIKit

class ScanAreaEditorViewController: BaseSettingsViewController {
    static let sliderCellReuseIdentifier = "ScanAreaSliderCellIdentifier"
    static let cellReuseIdentifier = "ScanAreaPlainCellIdentifier"
    static let ratioCellReuseIdentifier = "ScanAreaRatioCellIdentifier"
    
    enum ScanAreaSection : CaseIterable {
        case sizes,verticalAlignment,reset
        static func getSection(_ row: Int) -> ScanAreaSection {
            return self.allCases[row]
        }
    }
    
    enum ScanAreaRow : CaseIterable {
        case ratio,width/*,verticalAlignment*/,cornerRadius
        static func getRow(_ row: Int) -> ScanAreaRow {
            return self.allCases[row]
        }
    }
    
    var selectedVerticalAlignment = CutoutSettings.shared.alignment
    var cornerRadius = CutoutSettings.shared.cornerRadius
    var width = CutoutSettings.shared.maxWidthPercent
    var ratio = CutoutSettings.shared.ratioFromSize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSaveButton()
        tableView.register(ALSliderTableViewCell.self, forCellReuseIdentifier: Self.sliderCellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
        tableView.register(ALRatioTableViewCell.self, forCellReuseIdentifier: Self.ratioCellReuseIdentifier)
        self.title = "Scan area editor"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ScanAreaSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ScanAreaSection.getSection(section) {
        case .sizes:
            return ScanAreaRow.allCases.count
        case .verticalAlignment:
            return VerticalAlignment.allCases.count
        case .reset:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch ScanAreaSection.getSection(section) {
        case .sizes:
            return "Shape"
        case .verticalAlignment:
            return "Vertical Center"
        case .reset:
            return resetSectionHeading
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ScanAreaSection.getSection(indexPath.section) {
        case .sizes:
            var cell:UITableViewCell? = nil
            switch ScanAreaRow.getRow(indexPath.row) {
            case .width:
                if let sliderCell = tableView.dequeueReusableCell(withIdentifier: Self.sliderCellReuseIdentifier, for: indexPath) as? ALSliderTableViewCell {
                    sliderCell.title = "Width"
                    sliderCell.isPercentage = true
                    sliderCell.value = Float(width)
                    sliderCell.sliderValueDidChange = { sliderCell in
                        self.width = lroundf(sliderCell.value)
                        self.settingsDidChange()
                    }
                    cell = sliderCell
                }
            case .ratio:
                if let ratioCell = tableView.dequeueReusableCell(withIdentifier: Self.ratioCellReuseIdentifier, for: indexPath) as? ALRatioTableViewCell {
                    ratioCell.title = "Aspect Ratio"
                    ratioCell.firstTermTitle = "Height"
                    ratioCell.secondTermTitle = "Width"
                    ratioCell.minimumValue = 1
                    ratioCell.maximumValue = 10
                    ratioCell.value = ratio
                    ratioCell.valueDidChange = { value in
                        self.ratio = value
                        self.settingsDidChange()
                    }
                    cell = ratioCell
                }
            case .cornerRadius:
                if let sliderCell = tableView.dequeueReusableCell(withIdentifier: Self.sliderCellReuseIdentifier, for: indexPath) as? ALSliderTableViewCell {
                    sliderCell.minimumValueImage = UIImage.init(named: "Rectangle")
                    sliderCell.maximumValueImage = UIImage.init(named: "Ellipse")
                    sliderCell.isPercentage = true
                    sliderCell.maximumValue = Float(CutoutSettings.maxCornerRadius)
                    sliderCell.value = Float(cornerRadius)
                    sliderCell.title = "Corner radius"
                    sliderCell.sliderValueDidChange = { sliderCell in
                        self.cornerRadius = lroundf(sliderCell.value)
                        self.settingsDidChange()
                    }
                    cell = sliderCell
                }
            }
            return cell ?? UITableViewCell()
            case .verticalAlignment:
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
            let alignmentSetting = VerticalAlignment.getRow(indexPath.row)
            switch alignmentSetting {
            case .top:
                cell.textLabel?.text = "Top"
            case .center:
                cell.textLabel?.text = "Center"
            case .bottom:
                cell.textLabel?.text = "Bottom"
            }
            setChecked(for: cell, to: (alignmentSetting == selectedVerticalAlignment))
            cell.selectionStyle = .none
            return cell
        case .reset:
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
            cell.textLabel?.text = "Reset scan area settings to default"
            setUpResetCell(cell)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ScanAreaSection.getSection(indexPath.section) {
        case .sizes:
            break //nothing to do here
        case .verticalAlignment:
            //todo: share this code with the basic settings view controller
            let newSetting = VerticalAlignment.getRow(indexPath.row)
            if newSetting != selectedVerticalAlignment {
                let oldSelectedCell = tableView.cellForRow(at: IndexPath(row: selectedVerticalAlignment.rawValue, section: indexPath.section))
                setChecked(for: oldSelectedCell, to: false)
                selectedVerticalAlignment = newSetting
                setChecked(for: tableView.cellForRow(at: indexPath), to:true)
                self.settingsDidChange()
            }
        case .reset:
            resetSettings()
        }
    }
    
    override func reset() {
        CutoutSettings.shared.reset()
        selectedVerticalAlignment = CutoutSettings.shared.alignment
        cornerRadius = CutoutSettings.shared.cornerRadius
        width = CutoutSettings.shared.maxWidthPercent
        ratio = CutoutSettings.shared.ratioFromSize
        tableView.reloadData()
    }
        
    //this is called when they use the 'Save' button. We don't save the settings before that, in case they want to go back to the previous screen and and revert
    override func saveSettings() {
        CutoutSettings.shared.alignment = selectedVerticalAlignment
        CutoutSettings.shared.cornerRadius = cornerRadius
        CutoutSettings.shared.ratioFromSize = ratio
        CutoutSettings.shared.maxWidthPercent = width
        self.view.endEditing(true)
        super.saveSettings()
    }
}
