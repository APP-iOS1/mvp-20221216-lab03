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
                                
                               Image("flowerPink")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                Rectangle()
                                    .frame(height: 1)
                            }
                            .foregroundColor(.clear)
                            
                            VStack {
                                Text(item.calendarDate)
                                Text(item.locationName)
                            }
                            .padding()
                            .frame(minWidth: 180)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Pink"), lineWidth: 1.5)
                            }
                        }
                    }
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


