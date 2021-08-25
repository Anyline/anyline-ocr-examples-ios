//
//  FormFieldView.swift
//  AnylineExamples
//
//  Created by Renato Neves Ribeiro on 24.01.21.
//

import UIKit

@objc enum FieldType : Int {
    case validateSimple = 1
    case email = 2
}

@objc protocol FormFieldViewDelegate {
    func formFieldEndedEditing(field: UITextField)
}

@objc class FormFieldView: UIView, UITextFieldDelegate {

    fileprivate var inputTextHover : UILabel = UILabel()
    @objc var inputTextField : UITextField = UITextField()
    fileprivate let underlineView : UIView = UIView()
    fileprivate var errorMessageLabel : UILabel = UILabel()
    
    fileprivate var hoverBottomConstraints : NSLayoutConstraint = NSLayoutConstraint()
    fileprivate var errorTopConstraints : NSLayoutConstraint = NSLayoutConstraint()
    
    @objc var fieldType: FieldType = .validateSimple {
        didSet {
           configureByFieldType()
        }
    }

    @objc var nextField : UITextField?
    
    @objc var delegate : FormFieldViewDelegate?
    
    required init() {
        super.init(frame: CGRect.zero)
        self.setupFormField()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFormField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init with coder has not been implemented");
    }
    
    // MARK: - Private methods
    
    fileprivate func setupFormField() {
        self.inputTextField.delegate = self
        self.addSubview(inputTextHover)
        inputTextHover.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(inputTextField)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(errorMessageLabel)
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupStyles()
        setupConstraints()
    }
    
    fileprivate func setupStyles() {
        
        inputTextField.keyboardType = .emailAddress
        inputTextField.autocorrectionType = .no
        inputTextField.returnKeyType = .next
        inputTextField.textAlignment = .left
        inputTextField.backgroundColor = UIColor.clear
        inputTextField.font = UIFont.al_proximaRegular(withSize: 16)
        inputTextField.borderStyle = .none
        
        inputTextHover.textAlignment = .left
        inputTextHover.textColor = UIColor.lightGray
        inputTextHover.backgroundColor = UIColor.clear
        inputTextHover.alpha = 0
        inputTextHover.font = UIFont.al_proximaRegular(withSize: 16)
        
        errorMessageLabel.textAlignment = .left
        errorMessageLabel.textColor = UIColor.red
        errorMessageLabel.backgroundColor = UIColor.clear
        errorMessageLabel.alpha = 0
        errorMessageLabel.text = "This field is required"
        errorMessageLabel.font = UIFont.al_proximaRegular(withSize: 12)
        
        underlineView.backgroundColor = UIColor.gray
    }
    
    fileprivate func setupConstraints() {
        var constraints = [inputTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                           inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                           inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                           inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)]
        
        constraints.append(contentsOf: [underlineView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 4),
                                        underlineView.leadingAnchor.constraint(equalTo: inputTextField.leadingAnchor, constant: 0),
                                        underlineView.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor, constant: 0),
                                        underlineView.heightAnchor.constraint(equalToConstant: 1)])
        
        hoverBottomConstraints = inputTextHover.bottomAnchor.constraint(equalTo: inputTextField.topAnchor,
                                                                        constant: inputTextHover.bounds.height - 4)
        constraints.append(contentsOf: [hoverBottomConstraints,
                                        inputTextHover.leadingAnchor.constraint(equalTo: self.inputTextField.leadingAnchor, constant: 0)])
        
        errorTopConstraints = errorMessageLabel.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: -errorMessageLabel.bounds.height)
        constraints.append(contentsOf: [errorTopConstraints,
                                        errorMessageLabel.leadingAnchor.constraint(equalTo: inputTextField.leadingAnchor),
                                        errorMessageLabel.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor)])
        
        self.addConstraints(constraints)
    }
    
    fileprivate func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self.inputTextField.text)
    }
    
    fileprivate func isValidSimple() -> Bool {
        return !(self.inputTextField.text?.isEmpty ?? true)
    }
    
    fileprivate func animateErrorVisible() {
        errorTopConstraints.constant = 8
        UIView.animate(withDuration: 0.3, animations: {
            self.errorMessageLabel.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    fileprivate func animateErrorHide() {
        errorTopConstraints.constant = -errorMessageLabel.bounds.height
        UIView.animate(withDuration: 0.3, animations: {
            self.errorMessageLabel.alpha = 0
            self.layoutIfNeeded()
        })
    }
    
    fileprivate func showHoverText() {
        UIView.animate(withDuration: 0.1, delay: 0.85, options: []) {
            self.inputTextHover.alpha = 1
        }
    }
    
    fileprivate func hideHoverText() {
        self.inputTextHover.alpha = 0
    }
    
    // make additional customizations to the field after being assigned a field type.
    fileprivate func configureByFieldType() {
        switch self.fieldType {
        case .email:
            inputTextField.autocapitalizationType = .none
        default:
            break
        }
    }
    
    // MARK: - Public Methods
    @objc func setReturnKeyType(_ returnKeyType: UIReturnKeyType) {
        self.inputTextField.returnKeyType = returnKeyType
    }
    
    // Hover Text
    @objc func setHoverText(text: String) {
        self.inputTextHover.text = text
    }
    
    @objc func setHoverTextColor(color: UIColor) {
        self.inputTextHover.textColor = color
    }
    
    @objc func setHoverTextFont(font: UIFont) {
        self.inputTextHover.font = font
    }
    
    //  Input Text Field
    @objc func setInputFieldTextDelegate(delegate: UITextFieldDelegate) {
        self.inputTextField.delegate = delegate
    }
    
    @objc func setPlaceHolder(text: String) {
        self.inputTextField.placeholder = text
    }
    
    @objc func setText(text: String) {
        self.inputTextField.text = text
    }
    
    @objc func text() -> String? {
        return self.inputTextField.text
    }
    
    @objc func isEmpty() -> Bool {
        return self.inputTextField.text?.isEmpty ?? true
    }
    
    // Error Message Label
    @objc func setErrorText(text: String) {
        self.errorMessageLabel.text = text
    }
    
    // MARK: - UITextViewDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var isValid = false
        switch fieldType {
        case .email:
            isValid = isValidEmail()
        case .validateSimple:
            isValid = isValidSimple()
        default:
            print("nothing to validate")
        }
        
        if isValid {
            animateErrorHide()
        } else {
            animateErrorVisible()
        }
        self.delegate?.formFieldEndedEditing(field: textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "")
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.isEmpty {
            self.hideHoverText()
        } else {
            self.showHoverText()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if fieldType == .email && isValidEmail() {
            animateErrorHide()
        }
        self.delegate?.formFieldEndedEditing(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextResponder = nextField else {
            textField.resignFirstResponder()
            return true
        }
        nextResponder.becomeFirstResponder()
        return true
    }

}
