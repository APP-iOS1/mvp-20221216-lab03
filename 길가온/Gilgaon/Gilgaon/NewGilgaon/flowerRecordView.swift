
//
//  flowerRecordView.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/09.
//

import SwiftUI

struct FlowerRecordView: View {
    
    @State private var titleString = ""
    @State private var sheetViewToggle = false
    @State private var friendList:[FriendModel] = []
    @StateObject private var friendSearchViewModel = FriendSearchViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var fireStoreViewModel: FireStoreViewModel
    
//    @AppStorage("recordingKey") var recordingKey: String = UserDefaults.standard.string(forKey: "recordingKey") ?? ""
//    @AppStorage("isRecording") var isRecordingStatus: Bool = UserDefaults.standard.bool(forKey: "isRecording")
//    
    var body: some View {
        GeometryReader{ g in
            ZStack{
                Color("White")
                    .ignoresSafeArea()
                
                // [Title] 꽃갈피
                ZStack(alignment: .leading) {
                    MyPath3()
                        .stroke(Color("Pink"))
                    Text("꽃   갈   피")
                        .font(.custom("NotoSerifKR-Bold", size: 30))
                        .foregroundColor(Color("DarkGray"))
                        .padding(.leading, 50)
                }
                .offset(x: g.size.width/4.5, y: -g.size.height/2.3)
                .frame(height: 50)
                
                
                VStack(alignment: .leading, spacing: 30){
                    
                    // [제목]
                    VStack(alignment: .leading){
                        Text("- 제목 ")
                        HStack{
                            TextField("제목을 입력하세요.", text: $titleString )
                                .fontWeight(.semibold)
                            Button {
                                
                            } label: {
                                Image(systemName: "delete.left.fill")
                            }
                        }
                    }
                    .font(.custom("NotoSerifKR-Regular",size:18))
                    .fontWeight(.bold)
                    
                    //[날짜]
                    VStack(alignment: .leading, spacing: 10){
                        Text("- 날짜")
                            .font(.custom("NotoSerifKR-Regular",size:18))
                            .fontWeight(.bold)
                        
                        Text("\(Date().ISO8601Format())")
                            .font(.custom("NotoSerifKR-Regular",size:18))
                            .fontWeight(.semibold)
                    }
                    
                    //[함께할 친구]
                    VStack(alignment: .leading){
                        HStack{
                            Text("- 함께할 친구")
                                .font(.custom("NotoSerifKR-Regular",size:18))
                                .fontWeight(.bold)
                            Spacer()
                            Button {
                                sheetViewToggle.toggle()
                            } label: {
                                HStack{
                                    Text("친구찾기")
                                    Image(systemName: "magnifyingglass")
                                }.foregroundColor(.gray)
                            }
                            .fullScreenCover(isPresented: $sheetViewToggle){
                                FriendSearchView(friendList: $friendList, friendSearchViewModel: friendSearchViewModel)
                            }
                        }
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 10){
                                ForEach(friendList) { friend in
                                    friendCellView(friend)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(width: 300,height: 150)

                    Spacer()
                    HStack(alignment:  .center){
                        Spacer()
                        Button {
                            var shareFriend:[String] = []
                            let createdAt = Date().timeIntervalSince1970
                            friendList.forEach{ shareFriend.append($0.id) }
                            let rKey = UUID().uuidString
                            let calendar = DayCalendarModel(id: rKey, taskDate: Date(), title: titleString, shareFriend: shareFriend, realDate: createdAt)
                            fireStoreViewModel.addCalendar(calendar)
//                            isRecordingStatus = true

                            NotificationCenter.default.post(name: Notification.Name("isRecording"), object: (true, rKey))
                            dismiss()
                        } label: {
                            Text("기록하기")
                        }
                        Spacer()
                    }
                    .foregroundColor(Color("Pink"))
                    .padding()
                }
                .frame(width: g.size.width/1.2,height: g.size.height/1.6)
                .padding()
                .overlay{
                    Rectangle()
                        .stroke(Color("Red"), lineWidth: 1)
                        .padding(3)
                        .overlay {
                            Rectangle()
                                .stroke(Color("Red"),lineWidth: 1)
                        }
                }
                
                
                
            }
        }
        
    }
    
}

extension FlowerRecordView{
    
    private func friendCellView(_ friend: FriendModel) -> some View{
        HStack{
            AsyncImage(url: URL(string: friend.userPhoto)) { Image in
                Image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 20, height: 20)
                    .overlay(RoundedRectangle(cornerRadius: 64)
                        .stroke(Color("Pink"), lineWidth: 3))
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("Pink"))
                    .frame(width: 20, height: 20)
                    .aspectRatio(contentMode: .fit)
                
            }
            Text("\(friend.nickName)")
            Button {
                friendList.remove(at: friendList.firstIndex(of: friend)!)
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 120, height: 50)
        .overlay{
            Capsule()
                .stroke(Color.white, lineWidth: 1)
        }
    }
}

struct FlowerRecordView_Previews: PreviewProvider {
    static var previews: some View {
        FlowerRecordView()
        
    }
}
