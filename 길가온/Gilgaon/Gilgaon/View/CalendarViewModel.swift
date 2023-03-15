//
//  CalendarViewModel.swift
//  Gilgaon
//
//  Created by zooey on 2023/03/09.
//

import Foundation

final class CalendarViewModel: ObservableObject {
    
    let fireStore = FireStoreViewModel()
    
    @Published var drawerID: String = ""
    @Published var mapID: String = ""
    @Published var drawerDataList: [DayCalendarModel] = []
    @Published var mapDataList: [MarkerModel] = []
    
    func fetchDrawer() {
        fireStore.fetchDayCalendar()
        self.drawerDataList = fireStore.calendarList
    }
    
    @MainActor
    func fetchMap() async {
        self.mapDataList = await fireStore.fetchMarkers(inputID: self.mapID).sorted(by: { $1.createdDate > $0.createdDate})
    }
}

