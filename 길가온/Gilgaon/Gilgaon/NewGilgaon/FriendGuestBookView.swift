//
//  FriendGuestBookView.swift
//  Gilgaon
//
//  Created by 전준수 on 2023/03/20.
//

import SwiftUI

enum FriendAlertType {
    case delete, cancel
}

struct FriendGuestBookView: View {
    
    @State private var ellipsisToggle: Bool = false // ...버튼
    @State private var showingAlert = false // ...버튼 누르고 삭제 버튼 누르면 다시한번 올라오는 얼럿용 토글
    @State private var friendAlertType = FriendAlertType.delete
    @State private var guestBookFullScreenToggle = false
    var personImage: String = " " //user 프로필 이미지
    var guestBook: String = "  " //방명록
    
    var body: some View {
        GeometryReader { geometry in
            //빙명록이 비어있을 경우
            if guestBook.isEmpty {
                
                guestBookIsEmptyTexts
                
            } else {
                ZStack {
                    ScrollView {
                        VStack {
                            ForEach(1..<6) { _ in
                                HStack(alignment: .top, spacing: 10) {
                                    
                                    if personImage.isEmpty {
                                        //기본 프로필 이미지
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: geometry.size.width/6.5, height: geometry.size.height/9.5)
                                            .foregroundColor(Color("Pink"))
                                        
                                    } else {
                                        //사용자 프로필 이미지
                                        Image("b02")
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: geometry.size.width/6.5, height: geometry.size.height/9.5)
                                    }
                                    
                                    //방명록 쓴 사람의 정보 : 닉네임, 글, 작성시간
                                    guestInfo
                                    
                                    Spacer()
                                    
                                    // ...버튼
                                    Button(action: {
                                        print("눌렀습니다")
                                        ellipsisToggle.toggle()
                                    }) {
                                        Image(systemName: "ellipsis")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color("Pink"))
                                            .frame(width: 20, height: 20)
                                    }
                                    //하단에 뜨는 얼럿
                                    .confirmationDialog("해당 방명록이 불편하신가요?", isPresented: $ellipsisToggle, titleVisibility: .visible, presenting: friendAlertType, actions: { type in
                                        Button("삭제", role: .destructive) {
                                            print("삭제하기")
                                            friendAlertType = .delete
                                            showingAlert = true
                                        }

                                        Button("취소", role: .cancel) {
                                            print("취소하기")
                                        }
                                        
                                    })
                                    //삭제 or 신고 버튼을 누르면 가운데에 뜨는 얼럿
                                    .alert("해당 방명록을 삭제하시겠습니까?", isPresented: $showingAlert, presenting: friendAlertType) { type in
                                        
                                        if type == .delete {
                                            Button("삭제", role: .destructive) {}
                                            Button("취소", role: .cancel) {}
                                        }
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
                FriendGuestBookWritingView(guestBookFullScreenToggle: $guestBookFullScreenToggle)
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
    
    private var guestInfo: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("닉네임")
                .font(.custom("NotoSerifKR-Bold", size: 17))
            
            Text("들어와서 반가워!들어와서 반가워!들어와서 반가워!들어와서 반가워!")
                .font(.custom("NotoSerifKR-Regular",size: 15))
            
            Text("41분 전")
                .font(.custom("NotoSerifKR-Regular",size: 13))
                .foregroundColor(Color("DarkGray"))
        }
    }
}

struct FriendGuestBookView_Previews: PreviewProvider {
    static var previews: some View {
        FriendGuestBookView()
    }
}
