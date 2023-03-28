//
//  FriendSearchView.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/19.
//

import SwiftUI

struct FriendSearchView: View {
    
    @State private var searchString = ""
    @Binding var friendList:[FriendModel]
    @ObservedObject var friendSearchViewModel = FriendSearchViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var fireStoreViewModel : FireStoreViewModel
    
    
    var body: some View {
        GeometryReader{ g in
            ZStack{
                Color("White")
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        Button {
                            friendSearchViewModel.tempFriendList = []
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(Color("Pink"))
                        }
                        Spacer()
                        Text("기록친구 추가")
                        Spacer()
                        Button {
                            friendList = friendSearchViewModel.tempFriendList
                            dismiss()
                        } label: {
                            Text("확인")
                                .foregroundColor(Color("Pink"))
                        }
                    }
                    .padding()
                    ZStack{
                        TextField("친구 검색", text: $friendSearchViewModel.searchString)
                            .padding([.leading, .trailing], g.size.width/12)
                    }
                    ScrollView{
                        ForEach(friendSearchViewModel.recordFriendList, id:\.self){ friend in
                            FriendSearchCellView(friendsearchViewModel: friendSearchViewModel, friend: friend)
                                .padding(g.size.width/16)
                        }
                    }
                    
                }
                
            }
        }
        .onAppear{
            friendSearchViewModel.tempFriendList = friendList
            Task{ friendSearchViewModel.recordFriendList = await friendSearchViewModel.fetchFriendList() }
        }
        
        
        
        
    }
}

extension FriendSearchView{
    
    private func friendCell (_ friend: FriendModel) -> some View {
        HStack{
            AsyncImage(url: URL(string: friend.userPhoto)) { Image in
                Image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 64)
                        .stroke(Color("Pink"), lineWidth: 3))
                    .padding(.trailing, 10)
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("Pink"))
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing, 10)
            }
            
            Text("\(friend.nickName)")
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("Red"))
            }
        }
    }
    
}
//struct FriendSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendSearchView()
//            .environmentObject(FireStoreViewModel())
//    }
//}
