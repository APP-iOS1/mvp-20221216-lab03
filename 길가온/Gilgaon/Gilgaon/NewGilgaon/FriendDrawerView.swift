//
//  FriendDrawerView.swift
//  Gilgaon
//
//  Created by 전준수 on 2023/03/12.
//

import SwiftUI
import PhotosUI

enum FriendMiddleView: String {
    case comment = "방명록"
    case list = "서랍"
}

struct FriendDrawerView: View {
    @State var friendID: String
    @State private var friendMiddleView: FriendMiddleView = .comment
    @State private var profileImage: UIImage? = nil
    @StateObject var friendViewModel = FriendViewModel()
    
    var friendMiddleViewArray: [FriendMiddleView] = [.comment, .list]
    
    var body: some View {
//        Text("\(friendID)")


            GeometryReader { geometry in
                ZStack {
                    Color("White")
                        .ignoresSafeArea()

                    VStack {
                        HStack {
                            // profile Image
                            Spacer()
                            
                            VStack {
                                if profileImage == nil {
                                    if let url = friendViewModel.myInfo?.userPhoto,
                                       let imageUrl = URL(string: url) {
                                        AsyncImage(url: imageUrl) { image in
                                            image
                                                .resizable()
                                                .clipShape(Circle())
                                                .frame(width: 110, height: 110)
                                                .overlay(RoundedRectangle(cornerRadius: 64)
                                                    .stroke(Color("Pink"), lineWidth: 3))
                                            
                                        } placeholder: {
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("Pink"))
                                                .frame(width: 110, height: 110)
                                                .aspectRatio(contentMode: .fit)
                                        }
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color("Pink"))
                                            .frame(width: 110, height: 110)
                                    }
                                } else {
                                    if profileImage != nil {
                                        Image(uiImage: profileImage!)
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: 110, height: 110)
                                            .overlay(RoundedRectangle(cornerRadius: 64)
                                                .stroke(Color("Pink"), lineWidth: 3))
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color("Pink"))
                                            .frame(width: 110, height: 110)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                
                                Text(friendViewModel.myInfo?.nickName ?? "")
                                    .font(.custom("NotoSerifKR-Regular",size:25))
                                    .foregroundColor(Color("DarkGray"))
                                    .bold()
                                    .padding(.bottom, 10)
                            
                                
                                
                                NavigationLink {
                                    FriendFriendView(friendViewModel: friendViewModel, friendID: friendID)
                                } label: {
                                    Text("\(friendViewModel.myFriendFriendArray.count)명의 친구")
                                            .font(.custom("NotoSerifKR-Regular",size:16))
                                }
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            ForEach(friendMiddleViewArray, id: \.self) { select in
                                ZStack {
                                    Button {
                                        friendMiddleView = select
                                    } label: {
                                        Text(select.rawValue)
                                            .foregroundColor(friendMiddleView == select ? Color("Pink") : Color("DarkGray"))
                                            .font(.custom("NotoSerifKR-Regular",size:16))
                                    }
                                    
                                    
                                    if friendMiddleView == select {
                                        Capsule()
                                            .foregroundColor(Color("Red"))
                                            .frame(height: 3)
                                            .offset(y: 17)
                                    }
                                    
                                }
                                .frame(width: geometry.size.width/2.4)
                            }
                        }
                        
                        switch friendMiddleView {
                        case .comment:
                            FriendGuestBookView(friendID: friendID)
                        case .list:
                            FriendDrawerListView(friendID: friendID)
                        }
                        
                    }
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .onAppear {
                Task{
                    await friendViewModel.findUserUIdMe(userUid: friendID)
                    await friendViewModel.fetchFriendFriend(userUid: friendID)
                }
            }

        
    }
}

//struct FriendDrawerView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDrawerView()
//    }
//}
