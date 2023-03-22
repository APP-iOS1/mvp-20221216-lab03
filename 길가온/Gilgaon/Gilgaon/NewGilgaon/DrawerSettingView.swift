//
//  DrawerSettingView.swift
//  Gilgaon
//
//  Created by zooey on 2022/12/19.
//

import SwiftUI

struct DrawerSettingView: View {
    @EnvironmentObject var registerModel: RegisterModel
    @EnvironmentObject var locationFetcher: LocationFetcher
    @State private var deleteAlert: Bool = false
    
    var body: some View {
        
        
        VStack {
            
            Text("설정")
                .foregroundColor(Color("DarkGray"))
                .font(.custom("NotoSerifKR-Bold", size: 30))
            
            Divider()
                .frame(width: 140, height: 2)
                .background(Color("DarkGray"))
                .padding(.horizontal, 16)
            Button {
                Task {
                    await locationFetcher.setLocationManager()
                    print("registerModel.currentUserProfile:?? ==> ",registerModel.currentUserProfile)
                }
            } label: {
                Text("위치 설정")
                    .foregroundColor(Color("DarkGray"))
                    .font(.custom("NotoSerifKR-Regular",size:16))
                    
            }
            .padding()
            
            Button {
                registerModel.logout()
            } label: {
                Text("로그아웃")
                    .foregroundColor(Color("DarkGray"))
                    .font(.custom("NotoSerifKR-Regular",size:16))
                    
            }
            .padding()
           
                Button {
                    
                    self.deleteAlert = true
                    
                } label: {
                    Text("회원탈퇴")
                        .foregroundColor(Color("DarkGray"))
                        .font(.custom("NotoSerifKR-Regular",size:16))
                    
                }
                .alert("회원탈퇴", isPresented: $deleteAlert) {
                    Button("취소") {}
                    Button("회원탈퇴") {registerModel.deleteUser()
                        
                    }
                       } message: {
                           Text("회원탈퇴를 하시겠습니까?")
                       }
            
            Spacer()
        }
        .padding(32)
        .background(Color("White"))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct DrawerSettingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerSettingView()
    }
}
