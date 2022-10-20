//
//  Table+Ext.swift
//  CalSocial
//
//  Created by DevBatch on 11/02/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}

extension Array {
    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
        var result = [Element]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }
        return result
    }
}
