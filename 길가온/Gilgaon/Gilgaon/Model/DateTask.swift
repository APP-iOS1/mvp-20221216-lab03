////
////  DateTask.swift
////  Gilgaon
////
////  Created by zooey on 2022/11/29.
////
//
//import SwiftUI
//
//
//struct DateTask: Identifiable {
//    var id = UUID().uuidString
//    var title: String
//    var taskDate: Date
//    var realDate: [String]
//    var time: Date = Date()
//}
//
//class CalendarViewModel: ObservableObject,Identifiable {
//    @Published var tasks: [DateTask]
//    init() {
//        let tasks = CalendarModel.selectDayInfo
//        self.tasks = tasks
//    }
//}
//
//class CalendarModel {
//    static var selectDayInfo: [DateTask] = []
//}
//
//func getSampleDate(offset: Int) -> Date {
//
//    let calender = Calendar.current
//    let date = calender.date(byAdding: .day, value: offset, to: Date())
//    return date ?? Date()
//
//}
//
//var tasks: [DateTask] = []
//
//func DateType2String() -> [String]{
//    let current = Date()
//
//    let formatter = DateFormatter()
//    //한국 시간으로 표시
//    formatter.locale = Locale(identifier: "ko_kr")
//    formatter.timeZone = TimeZone(abbreviation: "KST")
//    //형태 변환
//    formatter.dateFormat = "yyyy MM dd"
//
//    let date = formatter.string(from: current)
////    return date
//    return date.components(separatedBy: " ")
//}
