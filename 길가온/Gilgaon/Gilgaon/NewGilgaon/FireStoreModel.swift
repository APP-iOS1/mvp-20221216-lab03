//
//  FireStoreModel.swift
//  Gilgaon
//
//  Created by kimminho on 2022/12/20.
//

import Foundation
import MapKit
// Collection User
struct FireStoreModel: Codable,Identifiable,Hashable {
    var id: String //currentUser UID (Document ID)
    // field 값들
    var nickName: String
    var userPhoto: String
    var userEmail: String
    //
}

// [기록시작 -> 생성]
struct DayCalendarModel: Identifiable,Hashable{
    var id: String
    var taskDate: Date
    // 제목 : [서울여행]
    var title: String
    // 추후
    var shareFriend:[String]
    var realDate: Double
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: realDate)
        print(dateCreatedAt)
        print(Date().timeIntervalSince1970)
        return dateFormatter.string(from: dateCreatedAt)
    }
}

// [마커 Data]
struct MarkerModel: Identifiable, Equatable, Hashable {
    var id: String
    var title: String
    var photo: String
    var createdAt: Double
    var contents: String
    var locationName: String
    var lat: String
    var lon: String
    //
    var shareFriend:[String]
    
    var coordinate:CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: Double(self.lat)!, longitude: Double(self.lon)!)
    }
    
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_Kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: createdAt)
        
        return dateFormatter.string(from: dateCreatedAt)
    }
    
    static func == (lhs: MarkerModel, rhs: MarkerModel) -> Bool {
        lhs.id == rhs.id
    }
}



struct FriendModel: Codable,Identifiable,Hashable {
    var id: String //currentUser UID (Document ID)
    // field 값들
    var nickName: String
    var userPhoto: String
    var userEmail: String
}

struct GuestBookModel: Codable,Identifiable,Hashable {
    var id: String // Document ID
    // GuestBook 값들
    var to: String // 받는 사람
    var from: String // 보내는 사람
    var board: String // 방명록 내용
    var date: Double // 작성 날짜
    var report: Bool // 신고 상태
}


