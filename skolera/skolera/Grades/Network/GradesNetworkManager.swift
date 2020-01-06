//
//  GradesNetworkManager.swift
//  skolera
//
//  Created by Rana Hossam on 10/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Alamofire

func getStudentGradeBookApi(studentId: Int, grade: PostCourse, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    var headers : HTTPHeaders? = getHeaders()
//    do another header
    headers?["Accept"] = "application/vnd.skolera.v1"
    let url = String(format: GET_STUDENT_GRADE_BOOK(), grade.courseId!, grade.id!, studentId)
    debugPrint(url)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getCourseGradingPeriodsApi(parameters: Parameters, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_COURSE_GRADING_PERIODS())
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


