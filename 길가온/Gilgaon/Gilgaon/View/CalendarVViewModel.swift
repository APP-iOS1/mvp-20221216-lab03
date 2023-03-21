//
//  CalendarVViewModel.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/10.
//

import SwiftUI

final class CalendarVViewModel: ObservableObject{
    @AppStorage("isRecording") var isRecordingStatus: Bool = UserDefaults.standard.bool(forKey: "isRecording")
    @AppStorage("recordingKey") var recordingKey: String = UserDefaults.standard.string(forKey: "recordingKey") ?? ""
    @Published var isTapped: Bool = false
    @Published var isRecording: Bool = false
    init(){
        NotificationCenter.default.addObserver(forName: Notification.Name("isRecording"), object: nil, queue: nil) { noti in
            if let (recordingReciv, rKey) = noti.object as? (Bool, String) {
                self.isRecordingStatus = recordingReciv
                self.recordingKey = rKey
            } else{
                self.isRecordingStatus = false
                self.isRecording = false
                self.recordingKey = ""
            }
        }
    }
}
