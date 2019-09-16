//
//  AttendanceStudent.swift
//  skolera
//
//  Created by Rana Hossam on 9/16/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation


class AttendanceStudent {
    
    let firstname: String!
    let lastname: String!
    let id: Int!
    let email: String!
    let username: String!
    let avatarUrl: String!
    let thumbUrl: String!
    let userType: String!
    let dateofbirth: String!
    let country: String!
    let city: String!
    let homeAddress: String!
    let password: Any!
    let phone: String!
    let gender: String!
    let isActive: Bool!
    let lastSignInAt: String!
    let name: String!
    let childId: Int!
    let middlename: Any!
    let secondaryPhone: Any!
    let secondaryAddress: Any!
    let locale: String!
    let actableId: Int!
    let actableType: String!
    let unseenNotifications: Int!
    let schoolName: String!
    let realtimeIp: String!
    let passwordChanged: Bool!
    let parentId: Int!
    let levelName: String!
    let sectionName: String!
    let levelId: Int!
    let userId: Int!
    let stageName: String!
    let badges: Any!
    let code: String!
    let todayWorkloadStatus: Any!
    let studentGradeFlag: Any!
    let parentName: String!
    let parentUserId: Int!
    
    init(_ dict: [String: Any]) {
        firstname = dict["firstname"] as? String
        lastname = dict["lastname"] as? String
        id = dict["id"] as? Int
        email = dict["email"] as? String
        username = dict["username"] as? String
        avatarUrl = dict["avatar_url"] as? String
        thumbUrl = dict["thumb_url"] as? String
        userType = dict["user_type"] as? String
        dateofbirth = dict["dateofbirth"] as? String
        country = dict["country"] as? String
        city = dict["city"] as? String
        homeAddress = dict["home_address"] as? String
        password = dict["password"] as? Any
        phone = dict["phone"] as? String
        gender = dict["gender"] as? String
        isActive = dict["is_active"] as? Bool
        lastSignInAt = dict["last_sign_in_at"] as? String
        name = dict["name"] as? String
        childId = dict["child_id"] as? Int
        middlename = dict["middlename"] as? Any
        secondaryPhone = dict["secondary_phone"] as? Any
        secondaryAddress = dict["secondary_address"] as? Any
        locale = dict["locale"] as? String
        actableId = dict["actable_id"] as? Int
        actableType = dict["actable_type"] as? String
        unseenNotifications = dict["unseen_notifications"] as? Int
        schoolName = dict["school_name"] as? String
        realtimeIp = dict["realtime_ip"] as? String
        passwordChanged = dict["password_changed"] as? Bool
        parentId = dict["parent_id"] as? Int
        levelName = dict["level_name"] as? String
        sectionName = dict["section_name"] as? String
        levelId = dict["level_id"] as? Int
        userId = dict["user_id"] as? Int
        stageName = dict["stage_name"] as? String
        badges = dict["badges"]
        code = dict["code"] as? String
        todayWorkloadStatus = dict["today_workload_status"]
        studentGradeFlag = dict["student_grade_flag"]
        parentName = dict["parent_name"] as? String
        parentUserId = dict["parent_user_id"] as? Int
    }
    
}
