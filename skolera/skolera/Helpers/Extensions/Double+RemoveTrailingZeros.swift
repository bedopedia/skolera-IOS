//
//  Double+RemoveTrailingZeros.swift
//  skolera
//
//  Created by Salma Medhat on 3/10/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

extension Double {
    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
