//
//  AddFriendView.swift
//  Gilgaon
//
//  Created by kimminho on 2022/12/20.
//

import SwiftUI

struct AddFriendView: View {
    @StateObject  var fireStoreViewModel: FireStoreViewModel = FireStoreViewModel()
    
    var body: some View {
        
        if fireStoreViewModel.myFriendArray.count > 0 {
                VStack {
                    List {
                        ForEach(fireStoreViewModel.myFriendArray, id: \.self) { myFriend in
                            
                            HStack(alignment: .center) {
                                // profile Image
                                if let url = myFriend.userPhoto,
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
                                        
                                    }
                                } else{
                                    Image(systemName: "person.fill")
                                        .foregroundColor(Color("Pink"))
                                        .font(.system(size: 20))
                                        .padding()
                                        .overlay(RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color("Pink"), lineWidth: 3))
                                }
                                
                                Text(myFriend.nickName)
                                    .foregroundColor(Color("DarkGray"))
                                    .font(.custom("NotoSerifKR-Regular",size:16))
                                    .bold()
                                    .padding(.leading, 16.0)
                                
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                                Button(role: .destructive) {
                                    fireStoreViewModel.deleteFriend(friend: myFriend)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            })
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
                .onAppear {
                    fireStoreViewModel.fetchFriend()
                }
                .toolbar {
                    NavigationLink {
                        SearchUserView()
                    } label: {
                        Text("+")
                            .font(.custom("NotoSerifKR-Regular",size:26))
                            .bold()
                    }
            }
        } else {
            ZStack {
                Color("White")
                    .ignoresSafeArea()
            }
            .onAppear {
                fireStoreViewModel.fetchFriend()
            }
            .toolbar {
                NavigationLink {
                    SearchUserView()
                } label: {
                    Text("+")
                        .font(.custom("NotoSerifKR-Regular",size:26))
                        .bold()
                }
        }
        }
        
        
    }
}




//struct AddFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFriendView()
//    }
//}
