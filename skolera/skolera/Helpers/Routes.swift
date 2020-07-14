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

func GET_PROFILE() -> String {
    return "\(BASE_URL!)/api/users/%@/getProfile"
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
    return "\(BASE_URL!)/api/courses/%d/course_groups/%d/grade_book_items/student?grading_period_id=%d&student_id=%d"
    
}

func GET_GRADING_PERIODS() ->String {
    return "\(BASE_URL!)/api/grading_periods/course_grading_periods?course_id=%d"
}

func GET_STUDENT_GRADE_AVG() -> String
{
    return "\(BASE_URL!)/api/courses/%d/course_groups/%d/student_grade"
    //    return "\(BASE_URL!)/api/courses/%d/course_groups/%d/student_grade_book?student_id=%d"
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
    return "\(BASE_URL!)/api/weekly_plans?mobile=true"
}
//Timetable
func GET_TIME_TABLE() -> String
{
    return "\(BASE_URL!)/api/students/%d/timetable"
}
//Attendances count
func GET_ATTENDANCES_COUNT(childId: Int) -> String
{
    return "\(BASE_URL!)/api/attendances/percentage?by_student=\(childId)"
}
func GET_TEACHER_TIME_TABLE() -> String
{
    return "\(BASE_URL!)/api/teachers/%d/timetable"
}
//Chat
func GET_THREADS() -> String
{
    return "\(BASE_URL!)/api/threads"
}
// for the uploaded files
func GET_MESSAGES() -> String
{
    return "\(BASE_URL!)/api/threads/%d/messages"
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
    if getUserType() == .admin {
        return "\(BASE_URL!)/api/announcements?page=%u&per_page=%u&running_announcement=true"
    }
    else {
        return "\(BASE_URL!)/api/announcements?page=%u&per_page=%u&running_announcement=true&user_type=\(getUserType())"
    }
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

func GET_QUIZZES_COURSES() -> String {
    return "\(BASE_URL!)/api/students/%d/course_groups_with_quizzes_number"
}

func GET_POSTS_COURSES() -> String {
    return "\(BASE_URL!)/api/students/%d/course_groups_recent_posts"
}

func GET_SHORT_COURSE_GROUPS() -> String {
    return "\(BASE_URL!)/api/students/%d/course_groups_short_list"
}

func GET_STUDENT_POSTS() -> String {
    return "\(BASE_URL!)/api/posts?access_by_entity=Course+Group+Posts&course_group_id=%d&page=%d&per_page=1000"
}

func COMMENTS_URL() -> String {
    return "\(BASE_URL!)/api/comments"
}

func GET_ASSIGNMENT_DETAILS_URL() -> String {
    return "\(BASE_URL!)/api/courses/%d/assignments/%d"
}


func GET_QUIZZES() -> String {
    "\(BASE_URL!)/api/quizzes?page=%d&per_page=1000&by_course_group=%d&mobile=true"
}

func GET_TEACHER_QUIZZES() -> String {
    return "\(BASE_URL!)/api/quizzes"
}

func GET_TEACHER_COURSES() -> String {
    return "\(BASE_URL!)/api/teachers/%d/courses"
}


func GET_ASSIGNMENT_SUBMISSIONS_URL() -> String {
    return "\(BASE_URL!)/api/courses/%d/course_groups/%d/assignments/%d/submissions"
}

func SUBMIT_STUDENT_ASSIGNMENT_GRADE_URL() -> String {
    return "\(BASE_URL!)/api/courses/%d/course_groups/%d/assignments/%d/student_grade"
}

func SUBMIT_FEEDBACK_URL() -> String {
    return "\(BASE_URL!)/api/feedbacks"
}

func EDIT_FEEDBACK_URL() -> String {
    return "\(BASE_URL!)/api/feedbacks/%d"
}

func GET_QUIZZES_SUBMISSIONS_URL() -> String {
    return "\(BASE_URL!)/api/quizzes/%d/submissions?course_group_id=%d"
}

func SUBMIT_STUDENT_QUIZ_GRADE_URL() -> String {
    return "\(BASE_URL!)/api/courses/%d/course_groups/%d/quizzes/%d/student_grade"
}

func GET_STUDENT_EVENTS(uid: Int, startDate: String, endDate: String) -> String {
    return "\(BASE_URL!)/api/events?by_subscriber%5Bsubscriber_id%5D=\(uid)&by_subscriber%5Bsubscriber_type%5D=user"
    //&start_date_between%5Bend_date%5D=\(endDate)&start_date_between%5Bstart_date%5D=\(startDate)"
}

func CREATE_STUDENT_EVENTS() -> String {
    return "\(BASE_URL!)/api/events"
}

func CREATE_POST() -> String {
    return "\(BASE_URL!)/api/posts"
}

func UPLOAD_FILE_FOR_POST() -> String {
    return "\(BASE_URL!)/api/posts/create_uploaded_file_for_posts"
}

func GET_FULL_DAY_ATTENDANCES(courseGroupId: Int, startDate: String, endDate: String) -> String {
    return "\(BASE_URL!)/api/course_groups/\(courseGroupId)/attendances?by_period%5Bend_date%5D=\(endDate)&by_period%5Bstart_date%5D=\(startDate)"
}

func GET_SLOT_ATTENDANCES(courseGroupId: Int, date: String) -> String {
    return "\(BASE_URL!)/api/course_groups/\(courseGroupId)/attendances?by_slots=\(date)"
}

func CREATE_ATTENDANCE() -> String {
    return "\(BASE_URL!)/api/attendances/batch_create"
}

func UPDATE_ATTENDANCE(attendanceId: Int) -> String {
    return "\(BASE_URL!)/api/attendances/\(attendanceId)"
}

func DELETE_ATTENDANCE() -> String {
    return "\(BASE_URL!)/api/attendances/batch_destroy"
}

func GET_QUIZ(quizId: Int) -> String {
    return "\(BASE_URL!)/api/quizzes/\(quizId)"
}

func CREATE_SUBMISSION() -> String {
    return "\(BASE_URL!)/api/active_quizzes/create_submission"
}

func QUIZ_SOLVE_DETAILS(quizId: Int) -> String {
    return "\(BASE_URL!)/api/quizzes/\(quizId)/quiz_solve_details"
}


func GET_ANSWER_SUBMISSIONS(submissionId: Int) -> String {
    return "\(BASE_URL!)/api/answer_submissions?by_quiz_sumbission=\(submissionId)"
}

func POST_ANSWER_SUBMISSIONS() -> String {
    return "\(BASE_URL!)/api/answer_submissions"
}

func DELETE_ANSWER_SUBMISSIONS() -> String {
    return "\(BASE_URL!)/api/answer_submissions/remove_answer_submission"
}

func SUBMIT_QUIZ() -> String {
    return "\(BASE_URL!)/api/active_quizzes/submit_quiz"
}

func CHANGE_PASSWORD(userId: Int) -> String {
    return "\(BASE_URL!)/api/users/\(userId)"
}

func LOGOUT() -> String {
    return "\(BASE_URL!)/api/auth/sign_out"
}
