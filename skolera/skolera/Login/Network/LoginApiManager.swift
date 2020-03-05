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

func setLocaleAPI(_ locale: String, token: String, deviceId: String, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let parameters: Parameters = ["user": ["language": locale, "fcm_token": token, "device_id": deviceId]]
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: EDIT_USER(), userId())
    Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0,response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
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

func getProfileAPI(id: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_PROFILE(),"\(id)")
     Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
       switch response.result{
         case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
         case .failure(let error):
             completion(true, response.response?.statusCode ?? 0, response.result.value, error)
         }
     }
}

func logoutAPI(parameter: Parameters,completion: @escaping (Bool, Int, Any?, Error?) -> ()){
    let headers : HTTPHeaders? = getHeaders()
        Alamofire.request(LOGOUT(), method: .delete, parameters: nil, headers: headers).validate().responseJSON { response in
          switch response.result{
            case .success(_):
               completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
            case .failure(let error):
                completion(true, response.response?.statusCode ?? 0, response.result.value, error)
            }
        }
}
