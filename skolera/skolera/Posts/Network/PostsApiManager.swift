//
//  PostsApiManager.swift
//  skolera
//
//  Created by Yehia Beram on 8/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import Alamofire

func getPostsCoursesApi(childId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_POSTS_COURSES(), childId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getPostsForCourseApi(page: Int, courseId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_STUDENT_POSTS(), courseId, page)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            debugPrint(response.result.value)
           completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
           completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func addPostReplyApi(parameters: Parameters, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = COMMENTS_URL()
    Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}


func createPostApi(parameters: Parameters, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = CREATE_POST()
    Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func uploadFileApi(file: URL, postId: Int, fileName: String, completion: @escaping ((Bool, Int, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = UPLOAD_FILE_FOR_POST()
    Alamofire.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append(fileName.data(using:.utf8)!, withName: "name")
            multipartFormData.append(file, withName: "file[file]" )
            multipartFormData.append(String(postId).data(using: .utf8)!, withName: "post_ids[]")
    },
        to: url,
        method: .post,
        headers: headers,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { progress in
                    debugPrint(progress.fractionCompleted)
                }
                upload.responseJSON { response in
                    debugPrint(response)
                    if (response.response != nil) {
                        let status = response.response!.statusCode
                        switch status {
                        case 200...299 :
                            if response.data != nil {
                                completion(true, status, nil)
                            }
                        default :
                            if response.data != nil {
                                completion(false, -1, nil)
                            }
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(false, -1, nil)
                
            }
        }
    )
    
}
