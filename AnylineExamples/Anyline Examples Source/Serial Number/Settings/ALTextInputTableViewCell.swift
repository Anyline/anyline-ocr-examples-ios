//
//  ALTextInputTableViewCell.swift
//  AnylineExamples
//
//  Created by Angela Brett on 22.07.20.
//

import UIKit

final class ALTextInputTableViewCell: UITableViewCell {
    
    public var placeholder:String? {
        didSet {
            editableTextField.placeholder = placeholder
        }
    }
    
    public var capitalsOnly = true {
        didSet {
            setCapitalization()
        }
    }
    
    public var value:String? {
        get {
            return editableTextField.text
        }
        set {
            editableTextField.text = newValue
        }
    }
    
    private func setCapitalization() {
        editableTextField.autocapitalizationType = capitalsOnly ? .allCharacters : .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.backgroundColor = .clear
        contentView.addSubview(editableTextField)
        NSLayoutConstraint.activate([
            editableTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            editableTextField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            editableTextField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        setCapitalization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Reusing Cells
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    lazy private var editableTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(Self.textDidChange), for: .editingChanged)
        //dismiss the keyboard when they press return
        textField.addTarget(textField, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
        return textField
    }()
    
    // MARK: Handling Text Input
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editableTextField.becomeFirstResponder()
    }
    
    public var valueDidChange: (String) -> () = { _ in }
    
    @objc private func textDidChange() {
        valueDidChange(value ?? "")
    }
}
