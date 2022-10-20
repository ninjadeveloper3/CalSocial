//
//  NativeClass.swift
//  HomeMedics
//
//  Created by DevBatch on 18/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation

@objc(NativeClass)
open class NativeClass: NSObject {
    open func getValue() -> String
    {
        return "Value came from NativeClass.swift!"
    }
}
