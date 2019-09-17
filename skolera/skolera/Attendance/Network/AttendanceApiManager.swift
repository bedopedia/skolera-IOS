//
//  AttendanceApiManager.swift
//  skolera
//
//  Created by Rana Hossam on 9/16/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

import Alamofire

func getFullDayAttendanceStudentsApi(courseGroupId: Int,startDate: String, endDate: String, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = GET_FULL_DAY_ATTENDANCES(courseGroupId: courseGroupId, startDate: startDate, endDate: endDate)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func createFullDayAttendanceApi(parameters: Parameters, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = CREATE_ATTENDANCE()
    debugPrint(parameters)
    Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
        debugPrint(response)
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func updateAttendanceApi(attendanceId: Int, parameters: Parameters, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = UPDATE_ATTENDANCE(attendanceId: attendanceId)
    Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
        debugPrint(response)
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}


