// MARK: -준수 수정함
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var registerModel: RegisterModel
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        
        GeometryReader { g in
            ZStack {
                
                Color("White")
                    .ignoresSafeArea()
                
                Lottie2()
                    
           
               
      

                    VStack {
                        
            Spacer()
                        
                        VStack {
                            ZStack {
                                Image("Path")
                                    .resizable()
                                    .frame(width: g.size.width / 1.4, height: g.size.width / 8)
                                
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(Color("DarkGray"))
                                    TextField("이메일", text: $email)
                                        .font(.custom("NotoSerifKR-Regular",size:16))
                                }
                            }
                            .frame(width: g.size.width / 1.4, height: g.size.width / 5)
                         
                            
                      
                            
                            ZStack {
                                Image("Path")
                                    .resizable()
                                    .frame(width: g.size.width / 1.4, height: g.size.width / 8)
                                
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(Color("DarkGray"))
                                    SecureField("비밀번호", text: $password)
                                        .font(.custom("NotoSerifKR-Regular",size:16))
                                }
                            }
                            .frame(width: g.size.width / 1.4, height: g.size.width / 5)
                          
                           
                        }
                        .frame(width: g.size.width / 1.4, height: g.size.width / 3)
                
                        
                    
                        VStack {
                            Button {
                                registerModel.login(email: email, password: password)
                            } label: {
                                
                                Text("로그인")
                                    .foregroundColor(Color("DarkGray"))
                                    .font(.custom("NotoSerifKR-Bold",size:20))
                                    .bold()
                                
                            }
                            .alert("계정 확인", isPresented: $registerModel.isError, actions: {
                                
                                Button("확인",role: .cancel,action: {
                                })
                            }, message: {
                                Text("아이디 및 비밀번호를 확인해보세요.")
                                    .font(.custom("NotoSerifKR-Regular",size:16))
                            })
                            .frame(width: g.size.width / 1.4, height: g.size.width / 9)
               
                            
                            NavigationLink {
                                RegisterView()
                            } label: {
                                
                                Text("회원가입")
                                    .foregroundColor(Color("DarkGray"))
                                    .font(.custom("NotoSerifKR-Bold",size:20))
                                    .bold()
                            }
                            .frame(width: g.size.width / 1.4, height: g.size.width / 9)
                            
                  
                            
                            Text("OR")
                                .foregroundColor(Color("DarkGray"))
                                .font(.custom("NotoSerifKR-Medium",size:16))
                                .frame(width: g.size.width / 1.4, height: g.size.width / 9)
                         
                        }
                        .frame(width: g.size.width / 1.4, height: g.size.width / 2)
                        
            
                            
                        VStack {
                            SignInWithAppleButton { request in
                                registerModel.nonce = randomNonceString()
                                request.requestedScopes = [.fullName, .email]
                                request.nonce = sha256(registerModel.nonce)
                            } onCompletion: { (result) in
                                switch result {
                                case .success(let user):
                                    print("success")
                                    guard let credential = user.credential as?
                                            ASAuthorizationAppleIDCredential else {
                                        print("error with firebase")
                                        return
                                    }
                                    Task { await registerModel.appleAuthenticate(credential: credential) }
                                case.failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                            .frame(width: g.size.width / 1.31, height: g.size.height / 16.8666)
                        }
                        .frame(width: g.size.width / 1.4, height: g.size.width / 12)
                        
                        Spacer()
                        
         
                          
                        }
                        .textInputAutocapitalization(.never)
                        
               
//            }
//            .navigationBarHidden(true)
        }
        .accentColor(Color("Red"))
        .onAppear {
            print("== 로그인 뷰 ==")
            registerModel.listenToAuthState()
            if registerModel.currentUser != nil {
                Task{
                    registerModel.currentUserProfile = try await registerModel.fetchUserInfo(_: registerModel.currentUser!.uid)
                }
            }
        }
        }
           
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(RegisterModel())
    }
}


struct Lottie2: View {
    var body: some View {
        GeometryReader { g in
            LottieView2(filename: "Sakura")
                .ignoresSafeArea()
                .offset(x: -g.size.width / 0.47,y: -g.size.height / 2.2)
                .frame(width: g.size.width * 5,height: g.size.height * 2)
                .opacity(0.6)
        }
    }
}

struct MyPath2: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: 50, y: 320))
        path.addLine(to: CGPoint(x: 340, y: 320))
        
        path.move(to: CGPoint(x: 50, y: 323))
        path.addLine(to: CGPoint(x: 340, y: 323))
        
        path.move(to: CGPoint(x: 50, y: 360))
        path.addLine(to: CGPoint(x: 340, y: 360))
        
        path.move(to: CGPoint(x: 50, y: 363))
        path.addLine(to: CGPoint(x: 340, y: 363))
        
        path.move(to: CGPoint(x: 50, y: 280))
        path.addLine(to: CGPoint(x: 340, y: 280))
        
        path.move(to: CGPoint(x: 50, y: 283))
        path.addLine(to: CGPoint(x: 340, y: 283))
        
        path.move(to: CGPoint(x: 50, y: 240))
        path.addLine(to: CGPoint(x: 340, y: 240))
        
        path.move(to: CGPoint(x: 50, y: 243))
        path.addLine(to: CGPoint(x: 340, y: 243))
        
        return path
    }
}
