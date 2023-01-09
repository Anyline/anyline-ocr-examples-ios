//
//  ALRatioTableViewCell.swift
//  AnylineExamples
//
//  Created by Angela Brett on 31.07.20.
//

import Foundation

class ALRatioTableViewCell : UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    let spacing:CGFloat = 8 //we could change this to use equalToSystemSpacingBelow: etc if we change the target to iOS 11
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let margin:CGFloat = 10
        let spacingAroundColon:CGFloat = 20
        contentView.addSubview(titleLabel)
        contentView.addSubview(firstTermLabel)
        contentView.addSubview(firstTermValue)
        contentView.addSubview(colonLabel)
        contentView.addSubview(secondTermLabel)
        contentView.addSubview(secondTermValue)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant:-margin),
            colonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colonLabel.centerYAnchor.constraint(equalTo: firstTermLabel.bottomAnchor),
            firstTermLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            firstTermLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            firstTermLabel.trailingAnchor.constraint(equalTo: colonLabel.leadingAnchor, constant: -spacingAroundColon),
            secondTermLabel.leadingAnchor.constraint(equalTo:colonLabel.trailingAnchor, constant: spacingAroundColon),
            //secondTermLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            secondTermLabel.topAnchor.constraint(equalTo: firstTermLabel.topAnchor),
            firstTermValue.topAnchor.constraint(equalTo: firstTermLabel.bottomAnchor, constant: spacing),
            firstTermValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            firstTermValue.leadingAnchor.constraint(equalTo:firstTermLabel.leadingAnchor),
            firstTermValue.trailingAnchor.constraint(equalTo: firstTermLabel.trailingAnchor),
            secondTermValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            secondTermValue.leadingAnchor.constraint(equalTo: secondTermLabel.leadingAnchor)
            //secondTermValue.trailingAnchor.constraint(equalTo: secondTermLabel.trailingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title:String? = nil {
        didSet {
            titleLabel.text = title
            pickerLabel.text = title
        }
    }
    
    var firstTermTitle:String? = nil {
        didSet {
            firstTermLabel.text = firstTermTitle
        }
    }
    
    var secondTermTitle:String? = nil {
        didSet {
            secondTermLabel.text = secondTermTitle
        }
    }
    
    var minimumValue:Int = 0
    var maximumValue:Int = 10
    
    var value:Int {
        set {
            secondTermValue.text = "\(newValue.clamped(to: (minimumValue...maximumValue)))"
        }
        get {
            return Int(secondTermValue.text ?? "0")?.clamped(to: (minimumValue...maximumValue)) ?? minimumValue
        }
    }
    
    // MARK: Reusing Cells
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func label() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    lazy private var firstTermLabel: UILabel = {
        return label()
    }()
    
    //this could be turned into a text field if we decide we need that to be editable
    lazy private var firstTermValue: UILabel = {
        let firstValue = label()
        firstValue.text = "1"
        firstValue.isEnabled = false; //this part of the ratio is not editable
        return firstValue
    }()
    
    lazy private var secondTermLabel: UILabel = {
        return label()
    }()
    
    lazy private var pickerLabel:UILabel = {
        let pickerLabel: UILabel = UILabel.init(frame: .zero)
        pickerLabel.text = self.title
        pickerLabel.sizeToFit()
        pickerLabel.textAlignment = .center
        return pickerLabel
    }()
    
    lazy private var termPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.addSubview(pickerLabel)
        pickerLabel.topAnchor.constraint(equalTo: picker.topAnchor, constant: spacing).isActive = true
        pickerLabel.leadingAnchor.constraint(equalTo: picker.leadingAnchor).isActive = true
        pickerLabel.trailingAnchor.constraint(equalTo: picker.trailingAnchor).isActive = true
        pickerLabel.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy private var secondTermValue: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.inputView = termPicker
        textField.delegate = self
        return textField
    }()
    
    lazy private var colonLabel: UILabel = {
        let colonLabel = label()
        colonLabel.text = ":"
        return colonLabel
    }()
    
    lazy private var titleLabel: UILabel = {
        return label()
    }()
    
    // MARK: Handling Text Input
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        secondTermValue.becomeFirstResponder()
        secondTermValue.selectedTextRange = nil
    }
    
    public var valueDidChange: (Int) -> () = { _ in }
    
    @objc private func textDidChange() {
        if let text = secondTermValue.text, !text.isEmpty {
            secondTermValue.text = "\(value)" //show the clamped value
            valueDidChange(value)
        }
    }
    
    //MARK: UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maximumValue
    }
    
    func titleForRow(_ row:Int) -> String {
        return "1:\(row+1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleForRow(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        secondTermValue.text = "\(row+1)"
        secondTermValue.selectedTextRange = nil
        //secondTermValue.endEditing(true) //this is probably too soon to dismiss the picker. We will do it when they save instead.
        valueDidChange(value)
    }
        
    //MARK: Dismissing Picker on tap
    
    //a little bit hacky, but we need the enclosing table view so that we can dismiss the picker when they tap elsewhere on it.
    var tableView: UITableView? {
        return parentView(of: UITableView.self)
    }
    
    lazy private var tapGestureRecognizer : UIGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tap.cancelsTouchesInView = false
        return tap;
    }()
    
    @objc func handleTapGesture(sender: AnyObject)
    {
        //if they tapped outside of either the picker or this cell, dismiss the picker
        //taps anywhere on this cell don't dismiss it because we already show the picker whenever they tap anywhere on the cell, so it would be inconsistent
        let subview = tableView?.hitTest(sender.location(in: tableView), with: nil)

        if(!(subview?.isDescendant(of: termPicker) ?? false || subview?.isDescendant(of: self) ?? false))
        {
            secondTermValue.endEditing(true)
        }
     }
    
    //only have the tap gesture recognizer on while the picker is shown
    //(we would have to add/remove it on didMove/willMoveToSuperview otherwise, so this is not any extra code)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tableView?.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tableView?.removeGestureRecognizer(self.tapGestureRecognizer)
    }
}

extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}
