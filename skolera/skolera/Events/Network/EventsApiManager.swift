//
//  EventsApiManager.swift
//  skolera
//
//  Created by Yehia Beram on 8/19/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import Alamofire

func getEventsAPI(userId: Int, startDate: String, endDate: String, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = GET_STUDENT_EVENTS(uid: userId, startDate: startDate, endDate: endDate)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}
