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
                VStack {
                    ForEach(calendarViewModel.calendarList, id: \.self) { item in
                        HStack {
                            Text(item.title)
                                .font(.custom("NotoSerifKR-Bold", size: 15))
                            
                            HStack(spacing: -10) {
                                ForEach(calendarViewModel.sharedFriend, id: \.self) { user in
                                    if let url = user.userPhoto,
                                       let imageUrl = URL(string: url) {
                                        AsyncImage(url: imageUrl) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 30, height: 30)
                                                .clipShape(Circle())
                                                .background(
                                                    Circle()
                                                        .stroke(Color("DarkGray"), lineWidth: 2)
                                                )
                                        } placeholder: {
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 30, height: 30)
                                                .clipShape(Circle())
                                                .background(
                                                    Circle()
                                                        .stroke(Color("DarkGray"), lineWidth: 2)
                                                )
                                        }
                                    } else{
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                            .background(
                                                Circle()
                                                    .stroke(Color("DarkGray"), lineWidth: 2)
                                            )
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
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
}

struct CalendarSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSelectView(calendarViewModel: CalendarViewModel())
    }
}


