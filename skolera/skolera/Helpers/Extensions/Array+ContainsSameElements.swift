//
//  Array+ContainsSameElements.swift
//  skolera
//
//  Created by Rana Hossam on 10/28/19.
//  Copyright © 2019 Skolera. All rights reserved.
//
import Foundation

extension Array where Element: Comparable {
   func containsSameElements(as other: [Element]) -> Bool {
       return self.count == other.count && self.sorted() == other.sorted()
   }
}
