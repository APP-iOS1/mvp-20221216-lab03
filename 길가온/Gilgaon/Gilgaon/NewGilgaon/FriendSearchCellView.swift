//
//  FriendSearchCellView.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/19.
//

import SwiftUI

struct FriendSearchCellView: View {
    @State private var isChecked: Bool = false
    @ObservedObject var friendsearchViewModel: FriendSearchViewModel
    var friend: FriendModel
    var body: some View {
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
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color("Red"))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            friendsearchViewModel.tappedChecking(isChecked,friend)
            isChecked.toggle()
        }
        .onAppear{
            isChecked = friendsearchViewModel.isCheck(friend)
        }
        
//        .padding()
       
    }
}
//
//struct FriendSearchCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendSearchCellView(friend: .constant(FriendModel(id: "", nickName: "", userPhoto: "", userEmail: "")))
//    }
//}
