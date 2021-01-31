//
//  SchoolFeesResponse.swift
//  skolera
//
//  Created by Yehia Beram on 13/01/2021.
//  Copyright © 2021 Skolera. All rights reserved.
//

import Foundation

class SchoolFeesResponse {

    let schoolFees: [SchoolFees]?
    let meta: Meta

    init(_ dict: [String: Any]) {

        if let schoolFeesDictArray = dict["school_fees"] as? [[String: Any]] {
            schoolFees = schoolFeesDictArray.map { SchoolFees($0) }
        } else {
            schoolFees = []
        }

        let metaDict = dict["meta"] as? [String: Any]
        meta = Meta(fromDictionary: metaDict ?? [:])
        
    }

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["school_fees"] = schoolFees?.map { $0.toDictionary() }
        jsonDict["meta"] = meta.toDictionary()
        return jsonDict
    }

}
