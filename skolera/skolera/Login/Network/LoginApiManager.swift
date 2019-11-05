//
//  LoginApiManager.swift
//  skolera
//
//  Created by Yehia Beram on 8/4/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import Alamofire

func getSchoolurlAPI(parameters: Parameters, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    Alamofire.request(GET_SCHOOL_LINK, method: .get, parameters: parameters, headers: nil).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getSchoolInfoAPI(parameters: Parameters, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    Alamofire.request(GET_SCHOOL_BY_CODE(), method: .get, parameters: parameters, headers: nil).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func setLocaleAPI(_ locale: String, completion: @escaping ((Bool, Int, Error?) -> ())) {
    let parameters: Parameters = ["user": ["language": locale]]
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: EDIT_USER(), userId())
    Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, error)
        }
    }
}

func loginAPI(parameters: Parameters, completion: @escaping ((Bool, Int, Any?, [AnyHashable: Any], Error?) -> ())) {
    let url = SIGN_IN()
    Alamofire.request(url, method: .post, parameters: parameters, headers: nil).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, response.response?.allHeaderFields ?? [:], nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, response.result.value, [:], error)
        }
    }
}

func getChildrenAPI(parentId: Int, completion: @escaping (Bool, Int, Any?, Error?) -> ()) {
    let parameters : Parameters = ["parent_id" : parentId]
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_CHILDREN(),"\(parentId)")
    Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
           completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(true, response.response?.statusCode ?? 0, response.result.value, error)
        }
    }
}
