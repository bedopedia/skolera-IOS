//
//  ThreadsNetworkApiManager.swift
//  skolera
//
//  Created by Rana Hossam on 10/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import Alamofire


func getSubjectsApi(parameters: Parameters, child: Child, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_THREADS_COURSE_GROUPS(),child.actableId)
    debugPrint(url)
    Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getThreadsApi(completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_THREADS())
    debugPrint(url)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

