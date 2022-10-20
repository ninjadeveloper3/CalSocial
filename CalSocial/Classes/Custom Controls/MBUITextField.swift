////
////  MBUITextField.swift
////  Labour Choice
////
////  Created by Usama on 21/06/2017.
////  Copyright © 2017 Usama. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SkyFloatingLabelTextField
//
//protocol MBUITextFieldDelegate {
//    func didTextFieldEndEditing(textField: UITextField)
//}
//
//class MBUITextField: SkyFloatingLabelTextField, UITextFieldDelegate {
//
//    var isCreditCardTextField = false
//    var isExpirayDateTextField =  false
//    var isMobileNumberTextField = false
//    var isSSNTextField = false
//    var mbTextFieldDelegate: MBUITextFieldDelegate?
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        setupPlaceHolder()
//        setupPadding()
//        self.delegate = self
//    }
//
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupPlaceHolder()
//        setupPadding()
//        self.delegate = self
//    }
//
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        _ = super.textRect(forBounds: bounds)
//        let rect = CGRect(
//            x: 5,
//            y: titleHeight(),
//            width: bounds.size.width - 25,
//            height: bounds.size.height - titleHeight() - selectedLineHeight
//        )
//        return rect
//    }
//
//    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
//
//        if editing {
//            return CGRect(x: 5, y: 0, width: bounds.size.width-10, height: titleHeight())
//        }
//
//        return CGRect(x: 5, y: titleHeight(), width: bounds.size.width-10, height: titleHeight())
//    }
//
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        let rect = CGRect(
//            x: 5,
//            y: titleHeight(),
//            width: bounds.size.width-25,
//            height: bounds.size.height - titleHeight() - selectedLineHeight + 5
//        )
//        return rect
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        let rect = CGRect(
//            x: 5,
//            y: 0,
//            width: bounds.size.width,
//            height: bounds.size.height - titleHeight() - selectedLineHeight
//        )
//        return rect
//    }
//
//
//    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        var textRect = super.rightViewRect(forBounds: bounds)
//        textRect.origin.x -= 10
//        return textRect
//    }
//
//    func setupPlaceHolder(){
//
//        self.title = self.placeholder
//
//        self.lineColor = UIColor.PasswordTextFieldBorderColor()
//        self.selectedLineColor = UIColor.emailTextFieldBorderColor()
//        //self.selectedTitleColor = UIColor.textFieldTitleColor()
//
//        self.titleFormatter = { (text: String) -> String in // to avoid Upper casing of title
//            return text
//        }
//
//        self.font = UIFont.appThemeFontWithSize(13.0)
//        self.titleLabel.font = UIFont.appThemeFontWithSize(14.0)
//        self.textColor = UIColor.appThemeBlackColor()
//        self.placeholderColor = UIColor.appThemeBlackColor()
//        self.titleFont = UIFont.appThemeFontWithSize(10.0)
//        //self.autocapitalizationType = .sentences
//        self.borderStyle = .none
//    }
//
//    func setIcon(_ image: UIImage, width: CGFloat, height: CGFloat) {
//        let iconView = UIImageView(frame:
//            CGRect(x: 20, y: 5, width: width, height: height))
//        iconView.image = image
//        let iconContainerView: UIView = UIView(frame:
//            CGRect(x: 30, y: 0, width: width + 10, height: height + 10))
//        iconContainerView.addSubview(iconView)
//        rightView = iconContainerView
//        rightViewMode = .always
//    }
//
//    func setupPadding() {
//        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5.0, height: self.frame.size.height))
//        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5.0, height: self.frame.size.height))
//        rightView = rightPaddingView
//        leftView = leftPaddingView
//        leftViewMode = .always
//        rightViewMode = .always
//    }
//
//    // MARK: - UITextField Delegate
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.resignFirstResponder()
//        return false
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        self.errorMessage = ""
//        self.titleColor = UIColor.black
//        self.selectedLineColor = UIColor.black
//        self.lineColor = UIColor.black
//
//        if isCreditCardTextField {
//            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
//            textField.text = currentText.grouping(every: 4, with: " ")
//            return false
//
//        } else if isExpirayDateTextField {
//            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
//            textField.text = currentText.grouping(every: 2, with: "/")
//            return false
//
//        } else if isSSNTextField {
//
//            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
//            if (textField.text?.count)! < 11 {
//                textField.text = currentText.grouping(every: 3, with: "-")
//
//                if textField.text?.count == 11 {
//
//                }
//                return false
//            }
//            return true
//        }
//
//        return true
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if textField.text == "" && isMobileNumberTextField {
//            textField.text = "+92"
//        }
//
//        self.titleColor = UIColor.black
//        self.selectedTitleColor = UIColor.black
//        self.selectedLineColor = UIColor.black
//        self.lineColor = UIColor.black
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.titleColor = UIColor.lightGray
//        self.selectedTitleColor = UIColor.lightGray
//        self.selectedLineColor = UIColor.lightGray
//        self.lineColor = UIColor.lightGray
//        mbTextFieldDelegate?.didTextFieldEndEditing(textField: textField)
//    }
//}
