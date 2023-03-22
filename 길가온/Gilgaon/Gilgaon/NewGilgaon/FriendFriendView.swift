//
//  FriendFriendView.swift
//  Gilgaon
//
//  Created by 전준수 on 2023/03/12.
//

import SwiftUI
import SkeletonUI

struct FriendFriendView: View {
    @ObservedObject var friendViewModel: FriendViewModel
    @State var friendID: String
    var body: some View {
        
        if friendViewModel.myFriendFriendArray.count > 0 {
            
            VStack {
                List {
                    SkeletonForEach(with: friendViewModel.myFriendFriendArray) { loading,myFriend in
                        
                        
                        
                        HStack(alignment: .center) {
                            // profile Image
                            if let url = myFriend?.userPhoto,
                               let imageUrl = URL(string: url) {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 55, height: 55)
                                        .cornerRadius(28)
                                        .overlay(RoundedRectangle(cornerRadius: 55)
                                            .stroke(Color("Pink"), lineWidth: 3))
                                } placeholder: {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(Color("Pink"))
                                        .font(.system(size: 20))
                                        .padding()
                                        .overlay(RoundedRectangle(cornerRadius: 55)
                                            .stroke(Color("Pink"), lineWidth: 3))
                                }
                            } else{
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color("Pink"))
                                    .font(.system(size: 20))
                                    .padding()
                                    .overlay(RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color("Pink"), lineWidth: 3))
                            }
                            
                            Text(myFriend?.nickName)
                                .foregroundColor(Color("DarkGray"))
                                .font(.custom("NotoSerifKR-Regular",size:16))
                                .bold()
                                .padding(.leading, 16.0)
                                .skeleton(with: loading)
                            
                        }
                        
                        
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 20)
                                .background(.clear)
                                .foregroundColor(Color("White"))
                                .padding(
                                    EdgeInsets(
                                        top: 10,
                                        leading: 10,
                                        bottom: 10,
                                        trailing: 10
                                    )
                                )
                        )
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color("White"))
                    
                }
                .navigationTitle("친구목록")
                .onAppear {
                    Task{
                        await friendViewModel.fetchFriendFriend(userUid: friendID)
                    }
                }
            }
            
            
            
            
        } else {
            ZStack {
                Color("White")
                    .ignoresSafeArea()
            }
            .onAppear {
                Task{
                    await friendViewModel.fetchFriendFriend(userUid: friendID)
                }
            }
        }
    }
}

//struct FriendFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendFriendView()
//    }
//}
