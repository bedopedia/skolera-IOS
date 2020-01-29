//
//  GradesNetworkManager.swift
//  skolera
//
//  Created by Rana Hossam on 10/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Alamofire

func getStudentGradeBookApi(childId: Int, gradeSubject: ShortCourseGroup, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders(addMobileVersion: true)
    let url = String(format: GET_STUDENT_GRADE_BOOK(), gradeSubject.courseId!, gradeSubject.id!, childId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }

}


