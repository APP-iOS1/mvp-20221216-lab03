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
        GeometryReader{ g in
            HStack{
                AsyncImage(url: URL(string: friend.userPhoto)) { Image in
                    Image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: g.size.width/9, height: g.size.width/9)
                        
                        .overlay(RoundedRectangle(cornerRadius: g.size.width/9)
                            .stroke(Color("Pink"), lineWidth: 3))
                        .padding(.trailing)
                } placeholder: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("Pink"))
                        .frame(width: g.size.width/9, height: g.size.width/9)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing)
                }
                Text("\(friend.nickName)")
                Spacer()
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color("Red"))
            }
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
