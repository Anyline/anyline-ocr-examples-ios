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

@objc class FormFieldView: UIView, UITextFieldDelegate {

    fileprivate var inputTextHover : UILabel = UILabel()
    @objc var inputTextField : UITextField = UITextField()
    fileprivate let underlineView : UIView = UIView()
    fileprivate var errorMessageLabel : UILabel = UILabel()
    
    fileprivate var hoverBottomConstraints : NSLayoutConstraint = NSLayoutConstraint()
    fileprivate var errorTopConstraints : NSLayoutConstraint = NSLayoutConstraint()
    
    @objc var fieldType : FieldType = .validateSimple
    @objc var nextField : UITextField?
    
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
        inputTextField.returnKeyType = .done
        inputTextField.textAlignment = .left
        inputTextField.backgroundColor = UIColor.clear
        inputTextField.font = UIFont.al_proximaRegular(withSize: 19)
        inputTextField.borderStyle = .none
        
        inputTextHover.textAlignment = .left
        inputTextHover.textColor = UIColor.lightGray
        inputTextHover.backgroundColor = UIColor.clear
        inputTextHover.alpha = 0
        inputTextHover.font = UIFont.al_proximaRegular(withSize: 19)
        
        
        errorMessageLabel.textAlignment = .left
        errorMessageLabel.textColor = UIColor.red
        errorMessageLabel.backgroundColor = UIColor.clear
        errorMessageLabel.alpha = 0
        errorMessageLabel.text = "This field is required"
        errorMessageLabel.font = UIFont.al_proximaRegular(withSize: 14)
        
        underlineView.backgroundColor = UIColor.gray
    }
    
    fileprivate func setupConstraints() {
        var constraints = [inputTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
                           inputTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                           inputTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                           inputTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)]
        
        constraints.append(contentsOf: [underlineView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 0),
                                        underlineView.leadingAnchor.constraint(equalTo: inputTextField.leadingAnchor, constant: 0),
                                        underlineView.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor, constant: 0),
                                        underlineView.heightAnchor.constraint(equalToConstant: 1)])
        
        hoverBottomConstraints = inputTextHover.bottomAnchor.constraint(equalTo: inputTextField.topAnchor, constant: inputTextHover.bounds.height)
        constraints.append(contentsOf: [hoverBottomConstraints,
                                        inputTextHover.leadingAnchor.constraint(equalTo: self.inputTextField.leadingAnchor, constant: 0)])
        
        errorTopConstraints = errorMessageLabel.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: -errorMessageLabel.bounds.height)
        constraints.append(contentsOf: [errorTopConstraints,
                                        errorMessageLabel.leadingAnchor.constraint(equalTo: inputTextField.leadingAnchor),
                                        errorMessageLabel.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor)])
        
        self.addConstraints(constraints)
    }
    
    fileprivate func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        predicate.evaluate(with: self.inputTextField.text)
    }
    
    fileprivate func validateSimple() {
        if (self.inputTextField.text?.isEmpty ?? true) {
            errorTopConstraints.constant = 5
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                self.errorMessageLabel.alpha = 1
                self.layoutIfNeeded()
            })
        } else {
            errorTopConstraints.constant = -errorMessageLabel.bounds.height
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                self.errorMessageLabel.alpha = 0
                self.layoutIfNeeded()
            })
        }
    }
    
    // TODO: when we replace all textfield with this we can add an animation for the hover text going in and out of the field :)
    fileprivate func animateHoverTextUp() {
        
    }
    
    fileprivate func animateHoverTextIn() {
        
    }
    
    // MARK: - Public Methods
    
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
        switch fieldType {
        case .email:
            validateEmail()
        case .validateSimple:
            validateSimple()
        default:
            print("nothing to validate")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
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
