//
//  DrawerView.swift
//  Gilgaon
//
//  Created by zooey on 2022/12/19.
//
// MARK: -준수 수정함
import SwiftUI
import PhotosUI

enum MiddleView: String {
    case guestBook = "방명록"
    case list = "서랍"
}

struct DrawerView: View {
    
    @EnvironmentObject var fireStoreViewModel: FireStoreViewModel
    

    @State private var showMenu: Bool = false

    
    
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Color("White")
                        .ignoresSafeArea()
                    //서랍, 꽃갈피 뷰
                    DrawerDetailView(showMenu: $showMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    HStack {
                        
                        Spacer()
                        if showMenu {
                            //햄버거 메뉴 눌렀을 때 보이는 뷰
                            DrawerSettingView()
                                .frame(width: geometry.size.width/2)
                                .animation(.easeInOut(duration: 0.1), value: showMenu)
                                .transition(.move(edge: .trailing)) //왼쪽에서 스윽 나옴
                            //햄버거 메뉴 뷰 터치하면 화면 안꺼지게
                                .onTapGesture { self.showMenu = true }
                        }
                        
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showMenu.toggle() }) {
                                Image(systemName: "line.3.horizontal")
                            }
                        }
                    }
                    .background(Color("DarkGray").opacity(showMenu ? 0.5 : 0))
                    //햄버거 메뉴 버튼말고 터치로 닫는 코드
                    .onTapGesture { if self.showMenu { self.showMenu.toggle() } }
                }
                
            }
     
            .onAppear {
                fireStoreViewModel.myInfo(fireStoreViewModel.currentUserId!)
                fireStoreViewModel.fetchImageUrl()
                fireStoreViewModel.fetchFriend()
            }

        
    }
}

//struct DrawerView_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawerView()
//    }
//}
