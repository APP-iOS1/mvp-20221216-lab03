//
//  FriendGuestBookWritingView.swift
//  Gilgaon
//
//  Created by 전준수 on 2023/03/21.
//

import SwiftUI
struct FriendGuestBookWritingView: View {
    
    @Binding var guestBookFullScreenToggle: Bool
    @State private var cancelToggle: Bool = false //취소버튼
    @State private var alertType = AlertType.cancel
    @State private var showingAlert = false
    @State private var guestBookTextField: String = ""
    @State private var emptyTextField: String = "방명록을 작성해주세요!"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, Color("Pink")]), startPoint: .top, endPoint: .bottom).opacity(0.75)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        //취소버튼
                        cancelButton
                        
                        Spacer()
                        
                        //등록버튼
                        registrationButton
                        
                    }
                    .font(.custom("NotoSerifKR-Bold",size: 15))
                    .padding(.horizontal)
                    .padding(.top)
                    .alert(cancelToggle ? "현재까지 작성중이던 방명록이 초기화됩니다." : "등록이 완료되었습니다!", isPresented: $showingAlert, presenting: alertType) { type in
                        //취소를 누른 경우
                        if type == .cancel {
                            
                            Button("확인") { guestBookFullScreenToggle = false }
                            Button("취소", role: .cancel) {}
                            
                            //등록을 누른 경우
                        } else if type == .registration {
                            Button("확인") { guestBookFullScreenToggle = false }
                        }
                    }
                    
                    VStack {
                        Text("방명록을 작성해주세요!")
                            .padding(-10)
                            .font(.custom("NotoSerifKR-Regular",size: 15))

                            TextEditor(text: $guestBookTextField)
                                .cornerRadius(15)
                                .padding()
                                .font(.custom("NotoSerifKR-Regular",size: 18))
                                .lineSpacing(5) //줄 간격
                    }
                    .padding(.vertical)
                }
            }
            .onTapGesture {
                endTextEditing()
            }
        }
    }
}
extension FriendGuestBookWritingView {
    
    private var cancelButton: some View {
        Button(action: {
            alertType = .cancel //취소
            cancelToggle = true
            showingAlert = true
        }) {
            Capsule()
                .stroke(Color("Pink"), lineWidth: 2)
                .frame(width: 75, height: 38)
                .overlay{Text("취소").foregroundColor(Color("Pink"))}
        }
    }
    
    private var registrationButton: some View {
        Button(action: {
            alertType = .registration //등록
            cancelToggle = false
            showingAlert = true
        }) {
            Capsule()
                .fill(Color("Pink").opacity(0.85))
                .frame(width: 75, height: 38)
//                                .frame(width: geometry.size.width/5.2, height: geometry.size.height/19.5)
                .overlay{Text("등록").foregroundColor(Color.white)}
        }
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct FriendGuestBookWritingView_Previews: PreviewProvider {
    static var previews: some View {
        FriendGuestBookWritingView(guestBookFullScreenToggle: .constant(true))
    }
}
