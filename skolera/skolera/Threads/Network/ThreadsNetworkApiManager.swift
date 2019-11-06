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

func setThreadSeenApi(parameters: Parameters,completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: SET_THREAD_IS_SEEN())
    Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

//TODO: Send/ upload image of chatViewController

 func uploadImageApi(threadId: Int, imageData: Data, imageName: String, completion: @escaping ((Bool, Int, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = "\(String(format: SEND_MESSAGE(),threadId))/messages"
    Alamofire.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append("file attached".data(using: .utf8)!, withName: "body")
            multipartFormData.append("\(imageName)".data(using: .utf8)!, withName: "filename")
            multipartFormData.append(imageData, withName: "attachment", fileName: imageName, mimeType: "image/jpeg")
    },
        to: url, method: .post, headers: headers,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let status = response.response!.statusCode
                    completion(true, status, nil)
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(false, -1, encodingError)
            }
    })
    
}
