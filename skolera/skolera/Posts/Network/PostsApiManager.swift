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
