//
//  HomeApiManager.swift
//  skolera
//
//  Created by Yehia Beram on 8/5/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import Alamofire


func sendFCMTokenAPI(parameters: Parameters, completion: @escaping ((Bool, Int, Error?) -> ())) {
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

func getGradesAPI(childActableId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_GRADES(), childActableId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getCourseGroupsAPI(childId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_COURSE_GROUPS(), childId)
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getCourseGroupShortListApi(childId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
      let headers : HTTPHeaders? = getHeaders()
      let url = String(format: GET_SHORT_COURSE_GROUPS(), childId)
      debugPrint("GRADESURL: ", url)
      Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
          switch response.result{
          case .success(_):
              completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
          case .failure(let error):
              completion(false, response.response?.statusCode ?? 0, nil, error)
          }
      }
  }
  

func getBehaviourNotesCountAPI(completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = GET_BEHAVIOR_NOTES_COUNT()
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getWeeklyPlansAPI(completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_WEEKLY_PLANNER())
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { (response) in
        switch response.result {
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getTimeTableAPI(childActableId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_TIME_TABLE(), childActableId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getAttendancesCountAPI(childId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = GET_ATTENDANCES_COUNT(childId: childId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getTeacherTimeTableAPI(teacherActableId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_TEACHER_TIME_TABLE(), teacherActableId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}


func setNotificationSeenAPI(completion: @escaping ((Bool, Int, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: SET_SEEN_NOTIFICATIONS(), userId())
    
    Alamofire.request(url, method: .post, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            debugPrint(response.result.value)
            completion(true, response.response?.statusCode ?? 0, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, error)
        }
    }
}

func getNotificationsAPI(page: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_NOTIFCATIONS(), userId(), page)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func getCoursesForTeacherAPI(teacherActableId: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = String(format: GET_TEACHER_COURSES(), teacherActableId)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}

func changePasswordAPI(userId: Int, parameters: Parameters, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers : HTTPHeaders? = getHeaders()
    let url = CHANGE_PASSWORD(userId: userId)
    Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
        switch response.result {
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, response.result.value, error)
        }
    }
}

func getSchoolFeesAPI(page: Int, completion: @escaping ((Bool, Int, Any?, Error?) -> ())) {
    let headers: HTTPHeaders? = getHeaders()
    let url = String(format: GET_SCHOOL_FEES(), page)
    Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { (response) in
        switch response.result{
        case .success(_):
            completion(true, response.response?.statusCode ?? 0, response.result.value, nil)
        case .failure(let error):
            completion(false, response.response?.statusCode ?? 0, nil, error)
        }
    }
}
