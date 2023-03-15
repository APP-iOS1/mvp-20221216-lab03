//
//  CalendarVViewModel.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/10.
//

import SwiftUI

final class CalendarVViewModel: ObservableObject{
    @AppStorage("isRecording") var isRecordingStatus: Bool = UserDefaults.standard.bool(forKey: "isRecording")
    @Published var isTapped: Bool = false
    @Published var isRecording: Bool = false
    init(){
        NotificationCenter.default.addObserver(forName: Notification.Name("isRecording"), object: nil, queue: nil) { _ in
            self.isRecordingStatus = true
            self.isRecording = true
            print(self.isRecordingStatus)
        }
        print("fff")
    }
    func t (){
        NotificationCenter.default.post(name: Notification.Name("isRecording"), object: nil)
        
    }
}
