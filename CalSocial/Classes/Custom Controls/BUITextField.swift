//
//  BUITextField.swift
//  CalSocial
//
//  Created by DevBatch on 30/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
final class BUITextField: UITextField, UITextFieldDelegate {
    
    
    private var maxLengths = [UITextField: Int]()
    private var minLengths = [UITextField: Int]()
    var isMobileNumberTextField = false
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.delegate = self
        self.autocapitalizationType = .sentences
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.autocapitalizationType = .sentences
        
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
        get {
            return self.placeHolderColor
        }
    }
    
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            
            return self.layer.shadowOpacity
        }
        set {
            
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
            
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
            
        }
    }
    @IBInspectable var maskToBound: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
            
        }
    }
    
    //MARK:- Maximum length
    @IBInspectable var maxLengthx: Int {
        get {
            guard let length = maxLengths[self] else {
                return 30
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(fixMax), for: .editingChanged)
        }
    }
    
    @objc func fixMax(textField: UITextField) {
        let text = textField.text
        textField.text = text?.safelyLimitedTo(length: maxLength)
    }
    
    //MARk:- Minimum length
    @IBInspectable var minLegth: Int {
        get {
            guard let l = minLengths[self] else {
                return 0
            }
            return l
        }
        set {
            minLengths[self] = newValue
            addTarget(self, action: #selector(fixMin), for: .editingChanged)
        }
    }
    @objc func fixMin(textField: UITextField) {
        let text = textField.text
        textField.text = text?.safelyLimitedFrom(length: minLegth)
    }
  
    func setupPadding() {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: self.frame.size.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: self.frame.size.height))
        rightView = rightPaddingView
        leftView = leftPaddingView
        leftViewMode = .always
        rightViewMode = .always
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "" && isMobileNumberTextField {
            textField.text = "+1"
        }
        
    }
}
