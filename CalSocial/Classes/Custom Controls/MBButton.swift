//
//  File.swift
//  Move Big
//
//  Created by yasir on 13/12/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
final class MBButton: UIButton {
    
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
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
    
    @IBInspectable var semanticContentAttributeshadowOffset:  UISemanticContentAttribute {
        get {
            
            return self.semanticContentAttribute
        }
        set {
            self.semanticContentAttribute = newValue
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
}
