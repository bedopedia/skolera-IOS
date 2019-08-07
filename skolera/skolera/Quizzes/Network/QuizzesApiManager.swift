//
//  QuizzesApiManager.swift
//  skolera
//
//  Created by Yehia Beram on 8/7/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import Alamofire

func getQuizzesCoursesApi(childId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_QUIZZES_COURSES(), childId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getQuizzesForChildApi(childId: Int, courseId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_QUIZZES(), childId, courseId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getQuizzesForTeacherApi(completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = URL(string: GET_TEACHER_QUIZZES())!
        .appending("fields%5Bend_date%5D", value: "true")
        .appending("fields%5Bgrading_period_lock%5D", value: "true")
        .appending("fields%5Bid%5D", value: "true")
        .appending("fields%5Blesson_id%5D", value: "true")
        .appending("fields%5Bname%5D", value: "true")
        .appending("fields%5Bstart_date%5D", value: "true")
        .appending("fields%5Bstate%5D", value: "true")
        .appending("fields%5Bstudent_solve%5D", value: "true")
        .appending("course_group_ids[]", value: "68")
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

