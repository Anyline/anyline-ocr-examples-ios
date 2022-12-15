//
//  BaseSettingsViewController.swift
//  AnylineExamples
//
//  Created by Angela Brett on 24.07.20.
//

import Foundation

public class BaseSettingsViewController: UITableViewController {
    
    public let resetSectionHeading = "Reset Settings"
    var saveButton:UIBarButtonItem? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func addSaveButton() {
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSettings))
        saveButton?.isEnabled = false
        self.navigationItem.setRightBarButton(saveButton, animated: false)
    }
    
    func confirmReset(_ handler:((UIAlertAction)->())?) {
        let alert = UIAlertController(title: "Are you sure you want to reset these values?", message: "You are about to reset to preset configuration values", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Reset", style: .destructive, handler: handler)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func resetSettings() {
        confirmReset { (action) in
            self.reset()
            //reset saves the defaults it just set
            self.saveButton?.isEnabled = false
        }
    }
    
    func askToSaveChanges() {
        let alert = UIAlertController(title: "Apply new settings?", message: "You have unsaved changes; do you want to apply them?", preferredStyle: .alert)
        let discardChangesAction = UIAlertAction(title: "Discard", style: .destructive, handler: nil)
        alert.addAction(discardChangesAction)
        let applyChangesAction = UIAlertAction(title: "Apply", style: .default, handler: { alertAction in
            self.saveSettings()
        })
        alert.addAction(applyChangesAction)
        present(alert, animated: true, completion: nil)
    }
    
    public func setChecked(for cell:UITableViewCell?, to:Bool) {
        cell?.accessoryType = to ? .checkmark : .none
    }
    
    func setUpResetCell(_ cell:UITableViewCell) {
        cell.textLabel?.textColor = UIColor.systemRed
        cell.selectionStyle = .none
    }
    

    //override this in subclasses to save the settings on each specific screen. Call super once the settings are saved.
    @objc func saveSettings () {
        saveButton?.isEnabled = false
    }
    
    func settingsDidChange() {
        saveButton?.isEnabled = true
    }
    
    func reset() {
        //override this in subclasses to reset the settings on each specific screen
    }
    
    //ask if they want to save changes if they attempt to go back while they have unsaved changes.
    //this is a bit nicer than doing it on viewWillDisappear, because the view is still in the view hierarchy so we can present the UIAlert ourselves instead of on UIApplication.shared.keyWindow?.rootViewController?
    //in both cases, we move to the parent view before the alert is dismissed, which might not be ideal UI, but at least doing it this way we could potentially block until the alert is dismissed by using a semaphore or something
    public override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            if let saveButton = saveButton, saveButton.isEnabled {
                askToSaveChanges()
            }
        }
    }
}
