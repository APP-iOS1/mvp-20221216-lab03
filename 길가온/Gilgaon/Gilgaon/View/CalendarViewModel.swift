//
//  CalendarViewModel.swift
//  Gilgaon
//
//  Created by zooey on 2023/03/09.
//

import Foundation

@MainActor
final class CalendarViewModel: ObservableObject {
    
    let fireStore = FireStoreViewModel()
    
    @Published var documentID: String = ""
    @Published var mapDataList: [MarkerModel] = []
    
    @Published var calendarList: [DayCalendarModel] = []
    @Published var sharedFriend: [FriendModel] = []
    
    
    func fetchMap() async {
        self.mapDataList = await fireStore.fetchMarkers(inputID: self.documentID).sorted(by: { $1.createdDate > $0.createdDate})
    }
    
    func fetchCarendar() async {
        self.calendarList = await fireStore.fetchCarendalData(inputID: self.documentID)
    }
    
    func fetchSharedFriendImage() async {
        let userId = await fireStore.fetchCarendalData(inputID: self.documentID)
        self.sharedFriend = await fireStore.getImageURL(userId: userId.first?.shareFriend ?? [])
    }
}

