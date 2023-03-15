//
//  FriendDrawerListView.swift
//  Gilgaon
//
//  Created by 전준수 on 2023/03/13.
//

import SwiftUI

struct FriendDrawerListView: View {
    @StateObject private var friendViewModel = FriendViewModel()
    @State var friendID: String
    var body: some View {
        GeometryReader { geometry in
  
                ZStack {
                    Color("White")
                        .ignoresSafeArea()
                    List {
                        ForEach(friendViewModel.friendCalendarList){ value in
                            taskCardView(task: value)
                                .background {
                                    NavigationLink(destination: FriendFlowerMapView(getStringValue: value.id, friendID: friendID)) { EmptyView() }
                                        .opacity(0)
                                        .buttonStyle(PlainButtonStyle())
                                }
                        }
                        .listRowBackground(Color("White"))
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .onAppear{
                        Task {
                           await friendViewModel.fetchFriendDayCalendar(userUid: friendID)
                        }
                    }
  
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    func taskCardView(task: DayCalendarModel) -> some View {
        
        HStack(alignment: .top, spacing: 30) {
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.title)
                            .font(.custom("NotoSerifKR-Bold", size: 19))
                    }
                    .hLeading()
                    
                    // 생성 날짜
                    Text(task.createdDate)
                    
                }
                
                HStack(spacing: 0) {
                    HStack(spacing: -10) {
                        ForEach(friendViewModel.friendCalendarListSharedFriend) { user in
                            if let url = user.userPhoto,
                               let imageUrl = URL(string: url) {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 45, height: 45)
                                        .clipShape(Circle())
                                        .background(
                                            Circle()
                                                .stroke(Color("DarkGray"), lineWidth: 2)
                                        )
                                } placeholder: {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 45, height: 45)
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
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle()
                                            .stroke(Color("DarkGray"), lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .hLeading()
                    .onAppear {
                        Task {
                            await friendViewModel.fetchFriendDayCalendarFriendGetImageURL(userId: task.shareFriend)
                        }
                    }
                }
                .padding(.top)
            }
            .foregroundColor(Color("DarkGray"))
            .padding()
            .hLeading()
            .background(
                Color("Pink")
                    .cornerRadius(25)
                    .opacity(0.4)
            )
        }
        .hLeading()
    }
}

//struct FriendDrawerListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDrawerListView()
//    }
//}
