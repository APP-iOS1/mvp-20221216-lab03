//
//  FriendGuestBookView.swift
//  Gilgaon
//
//  Created by 전준수 on 2023/03/20.
//

import SwiftUI
import FirebaseAuth

enum FriendAlertType {
    case delete, cancel
}

struct FriendGuestBookView: View {
    
    @State private var ellipsisToggle: Bool = false // ...버튼
    @State private var showingAlert = false // ...버튼 누르고 삭제 버튼 누르면 다시한번 올라오는 얼럿용 토글
    @State private var friendAlertType = FriendAlertType.delete
    @State private var guestBookFullScreenToggle = false
    @State private var profileImage: UIImage? = nil
    @State var friendID: String
    @StateObject private var friendViewModel = FriendViewModel()
    
    var guestBook: String = "  " //방명록
    var currentUserId:String?{ Auth.auth().currentUser?.uid }
    
    var body: some View {
        GeometryReader { geometry in
            //빙명록이 비어있을 경우
            if friendViewModel.friendGuestBookList.isEmpty {
                
                guestBookIsEmptyTexts
                
            } else {
                ZStack {
                    ScrollView {
                        VStack {
                            ForEach(friendViewModel.friendGuestBookList) { value in
                                HStack(alignment: .top, spacing: 10) {
                                    
                                    VStack {
                                        if profileImage == nil {
                                            if let url = value.fromPhoto,
                                               let imageUrl = URL(string: url) {
                                                AsyncImage(url: imageUrl) { image in
                                                    image
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .frame(width: geometry.size.width/6.5, height: geometry.size.height/9.5)
                                                        .overlay(RoundedRectangle(cornerRadius: 64)
                                                            .stroke(Color("Pink"), lineWidth: 3))
                                                    
                                                } placeholder: {
                                                    Image(systemName: "person.circle")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundColor(Color("Pink"))
                                                        .frame(width: geometry.size.width/6.5, height: geometry.size.height/9.5)
                                                        .aspectRatio(contentMode: .fit)
                                                }
                                            } else {
                                                Image(systemName: "person.circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(Color("Pink"))
                                                    .frame(width: geometry.size.width/6.5, height: geometry.size.height/9.5)
                                            }
                                        } else {
                                            if profileImage != nil {
                                                Image(uiImage: profileImage!)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: geometry.size.width/6.5, height: geometry.size.height/9.5)
                                                    .overlay(RoundedRectangle(cornerRadius: 64)
                                                        .stroke(Color("Pink"), lineWidth: 3))
                                            } else {
                                                Image(systemName: "person.circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(Color("Pink"))
                                                    .frame(width: geometry.size.width/6.5, height: geometry.size.height/9.5)
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                        }
                                    }
                            
                               
                                    //방명록 쓴 사람의 정보 : 닉네임, 글, 작성시간
                                    VStack(alignment: .leading, spacing: 9) {
                                        Text(value.fromNickName)
                                            .font(.custom("NotoSerifKR-Bold", size: 17))
                                        
                                        Text(value.board)
                                            .font(.custom("NotoSerifKR-Regular",size: 15))
                                        
                                        Text("\(value.createdDate)")
                                            .font(.custom("NotoSerifKR-Regular",size: 13))
                                            .foregroundColor(Color("DarkGray"))
                                    }

                            

                                    
                                    Spacer()
                                    
                                    // 본인이 작성한 방문록만 삭제 가능
                                    if currentUserId == value.from {
                                        
                                        Button {
                                            friendViewModel.deleteFriendGuestBook(guestBook: value, friendID: friendID)
                                        } label: {
                                            Text("삭제")
                                        }

                                        
                                        
                                        // 얼럿을 사용하니 삭제가 랜덤으로 되어버림
//                                        // ...버튼
//                                        Button(action: {
//                                            print("눌렀습니다")
//                                            ellipsisToggle.toggle()
//                                        }) {
//                                            Image(systemName: "ellipsis")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .foregroundColor(Color("Pink"))
//                                                .frame(width: 20, height: 20)
//                                        }
//                                        //하단에 뜨는 얼럿
//                                        .confirmationDialog("해당 방명록이 불편하신가요?", isPresented: $ellipsisToggle, titleVisibility: .visible, presenting: friendAlertType, actions: { type in
//                                            Button("삭제", role: .destructive) {
//                                                print("삭제하기")
//                                                friendAlertType = .delete
//                                                showingAlert = true
//
//                                            }
//
//                                            Button("취소", role: .cancel) {
//                                                print("취소하기")
//                                            }
//
//                                        })
//                                        //삭제 or 신고 버튼을 누르면 가운데에 뜨는 얼럿
//                                        .alert("해당 방명록을 삭제하시겠습니까?", isPresented: $showingAlert, presenting: friendAlertType) { type in
//
//                                            if type == .delete {
//                                                Button("삭제", role: .destructive) {
//                                                    friendViewModel.deleteFriendGuestBook(guestBook: value, friendID: friendID)
//
//                                                }
//                                                Button("취소", role: .cancel) {}
//                                            }
//                                        }
                                        
                                        
                                    }
                                }
                                .padding(.horizontal)
                                
                                Divider()
                                    .background(Color.red)
                            } //ForEach
                            
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            //방명록 작성하는 버튼
            Button(action: {
                print("방명록 글쓰기 버튼 누름")
                guestBookFullScreenToggle = true
            }) {
                Circle()
                    .fill(Color("Pink"))
                    .frame(width: geometry.size.width/6.5, height: geometry.size.height/6.5)
                    .opacity(0.8)
                    .overlay {
                        Image(systemName: "pencil")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: geometry.size.width/14.5, height: geometry.size.height/19.5)
                    }
                
            }
            .offset(x: geometry.size.width/1.22, y: geometry.size.height/1.21)
            .fullScreenCover(isPresented: $guestBookFullScreenToggle) {
                FriendGuestBookWritingView(guestBookFullScreenToggle: $guestBookFullScreenToggle, friendID: friendID)
            }
        }
        .refreshable {
            Task{
                await friendViewModel.fetchFriendGuestBook(friendID: friendID)
            }
        }
        .onAppear {
            Task{
                await friendViewModel.fetchFriendGuestBook(friendID: friendID)
            }
        }
    }
    
    
}

extension FriendGuestBookView {
    
    private var guestBookIsEmptyTexts: some View {
        VStack {
            Spacer()
            Text("방명록이 비어있습니다!")
                .font(.custom("NotoSerifKR-Bold", size: 17))
            HStack {
                Spacer()
                Text("방명록을 남겨주세요!")
                    .font(.custom("NotoSerifKR-Bold", size: 17))
                Spacer()
            }
            Spacer()
        }
    }
}

//struct FriendGuestBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendGuestBookView()
//    }
//}
