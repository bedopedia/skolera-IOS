//
//  Routes.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/22/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation

let GET_SCHOOL_LINK = "https://bedopedia-schools.herokuapp.com/schools/get_by_code"
var BASE_URL : String!
//Login
func GET_SCHOOL_BY_CODE() -> String{
  return "\(BASE_URL!)/api/get_school_by_code"
}
func SIGN_IN() -> String {
    return "\(BASE_URL!)/api/auth/sign_in"
}

func EDIT_USER() -> String {
    return "\(BASE_URL!)/api/users/%@"
}
//Children
func GET_CHILDREN() ->String {
    return "\(BASE_URL!)/api/parents/%@/children"
}
//Notifications
func GET_NOTIFCATIONS() ->String {
   return "\(BASE_URL!)/api/users/%@/notifications?page=%u"
}

func SET_SEEN_NOTIFICATIONS() -> String {
    return "\(BASE_URL!)/api/users/%@/notifications/mark_as_seen"
}
//Grades
func GET_GRADES() ->String
{
    return "\(BASE_URL!)/api/students/%d/grade_certificate"
}
func GET_SUBJECTS() ->String
{
    return "\(BASE_URL!)/api/students/%d/grade_certificate"
}
func GET_COURSE_GROUPS() -> String
{
    return "\(BASE_URL!)/api/students/%d/course_groups?source=home"
}
func GET_COURSE_GRADING_PERIODS() -> String
{
    return "\(BASE_URL!)/api/grading_periods/course_grading_periods"
}
func GET_STUDENT_GRADE_BOOK() -> String
{
    return "\(BASE_URL!)/api/courses/%d/course_groups/%d/student_grade_book"
}
func GET_STUDENT_GRADE_AVG() -> String
{
    return "\(BASE_URL!)/api/courses/%d/course_groups/%d/student_grade"
}
//Behavior Notes
func GET_BEHAVIOR_NOTES_COUNT() -> String
{
    return "\(BASE_URL!)/api/behavior_notes/count_types"
}
func GET_BEHAVIOR_NOTES() -> String
{
    return "\(BASE_URL!)/api/behavior_notes"
}
//WeeklyPlanner
func GET_WEEKLY_PLANNER() -> String
{
    return "\(BASE_URL!)/api/weekly_plans?search_by_date=%@"
}
//Timetable
func GET_TIME_TABLE() -> String
{
    return "\(BASE_URL!)/api/students/%d/timetable"
}
//Chat
func GET_THREADS() -> String
{
    return "\(BASE_URL!)/api/threads"
}
func GET_THREADS_COURSE_GROUPS() -> String
{
    return "\(BASE_URL!)/api/students/%d/course_groups"
}
func SEND_MESSAGE() -> String
{
    return "\(BASE_URL!)/api/threads/%d"
}
func SET_THREAD_IS_SEEN() -> String{
    return "\(BASE_URL!)/api/thread_participants/bulk_mark_as_read"
}
//Announcements
func GET_ANNOUNCEMENTS() -> String {
    return "\(BASE_URL!)/api/announcements?page=%u&per_page=%u&running_announcement=true&user_type=\(getUserType())"
}
//Assignments
func GET_ASSINGMENTS() -> String {
//    return "\(BASE_URL!)/api/students/%d/assignments"
    return "\(BASE_URL!)/api/courses/%d/assignments"
}



//AssignmentsCourses
func GET_ASSINGMENTS_COURSES() -> String {
    return "\(BASE_URL!)/api/students/%d/course_groups_with_assignments_number"
}

func GET_POSTS_COURSES() -> String {
    return "\(BASE_URL!)/api/students/%d/course_groups_recent_posts"
}

func GET_STUDENT_POSTS() -> String {
    return "\(BASE_URL!)/api/posts?access_by_entity=Course+Group+Posts&course_group_id=%d"
}

func COMMENTS_URL() -> String {
    return "\(BASE_URL!)/api/comments"
}
