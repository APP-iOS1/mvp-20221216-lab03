//
//  CalendarView.swift
//  HanselAndGretel
//
//  Created by zooey on 2022/11/29.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var calendarVViewModel = CalendarVViewModel()
    @State var currentDate = Date()
    @State var calID: [String] = []
    @State var isTapped: Bool = true
    
    var body: some View {
        
        ZStack {
            Color("White")
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    CustomDataPicker(calendarVViewModel: calendarVViewModel, currentDate: currentDate, calID: $calID)
                }
                .padding(.vertical)
        }.customSheet(
            isPresented: $calendarVViewModel.isTapped,
            isRecording: $calendarVViewModel.isRecordingStatus,
            recordingID: $calendarVViewModel.recordingKey,
            title: "",
            message: "",
            firstButtonTitle: "",
            firstButtonAction: {calendarVViewModel.isTapped = false }
        )

    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}



