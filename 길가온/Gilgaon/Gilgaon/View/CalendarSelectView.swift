//
//  CalendarSelectView.swift
//  Gilgaon
//
//  Created by zooey on 2023/03/07.
//

import SwiftUI

struct CalendarSelectView: View {
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        
        ZStack {
            Color("White")
                .ignoresSafeArea()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(calendarViewModel.mapDataList, id: \.self) { item in
                        VStack {
                            HStack {
                                Rectangle()
                                    .frame(height: 1)
                                
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .background(
                                        Circle()
                                            .stroke(lineWidth: 1)
                                            .padding(-3)
                                    )
                                
                                Rectangle()
                                    .frame(height: 1)
                            }
                            
                            VStack {
                                Text(item.createdDate)
                                Text(item.locationName)
                            }
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Pink"), lineWidth: 1.5)
                            }
                        }
                    }
                    .foregroundColor(Color("DarkGray"))
                    .font(.custom("NotoSerifKR-Regular", size: 18))
                }
                .padding()
            }
        }
    }
}

struct CalendarSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSelectView(calendarViewModel: CalendarViewModel())
    }
}


