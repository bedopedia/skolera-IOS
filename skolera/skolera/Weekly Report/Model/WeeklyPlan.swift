//
//    WeeklyPlan.swift
//
//    Create by Salma Medhat on 2/13/2020
//    Copyright © 2019 TrianglZ LLC. All rights reserved.


import Foundation


class WeeklyPlan {

    let id: Int
    let startDate: String
    let endDate: String
    let generalNote: GeneralNote
    let dailyNotes: [String: [DailyNote]]

    init(_ dict: [String: Any]) {
        id = dict["id"] as! Int
        startDate = dict["start_date"] as! String
        endDate = dict["end_date"] as! String

        if let generalNoteDict = dict["general_note"] as? [String: Any] {
            generalNote = GeneralNote(generalNoteDict)
        } else {
            generalNote = GeneralNote([:])
        }

        dailyNotes = dict["daily_notes"] as! [String: [DailyNote]]
        
        
    }

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["start_date"] = startDate
        jsonDict["end_date"] = endDate
        jsonDict["general_note"] = generalNote.toDictionary()
        return jsonDict
    }

}
