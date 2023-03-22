//
//  RegisterModel.swift
//  Gilgaon
//
//  Created by kimminho on 2022/12/19.
//
// MARK: -준수 수정함
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import FirebaseStorage
import Combine

// 회원가입 진행에 Apple과 Email을 나눔
enum RegisterType: String {
    case Apple = "Apple"
    case Email = "Email"
}


@MainActor
class RegisterModel: ObservableObject {
    
    //MARK: Error Properties
    @Published var currentUserProfile: FireStoreModel? = nil
    @Published var currentUser = Auth.auth().currentUser
    
    @AppStorage("userLoginType") var userRegisterType: RegisterType = .Email
    
    // MARK: Apple Sign in Properties
    @Published var nonce: String = ""
    
        //@Published var currentUser: Firebase.User?
        @Published var isError: Bool = false
        @Published var DetailError: String = ""
        @Published var userUID: String = ""
    
        init() {
            currentUser = Auth.auth().currentUser
        }
    
    
        var user: User? {
            didSet {
                objectWillChange.send()
            }
        }
    
        func listenToAuthState() {
            Auth.auth().addStateDidChangeListener { [weak self] _, user in
                guard let self = self else {
                    return
                }
                self.user = user
            }
    
        }
    
        // 회원가입
        func registerUser(userID: String, userPW: String, userImage: UIImage?) async{
    
            do {
                let result = try await Auth.auth().createUser(withEmail: userID, password: userPW)
                let user = result.user
                self.isError = false
                print(user.uid)
                userUID = user.uid
    //            if let userImage = userImage {
    //                persisImageToStorage(userImage: userImage)
    //            }
            }
    
            catch {
                self.isError = true
    
                let code = (error as NSError).code
                switch code {
                case 17007:
                    self.DetailError = "이미 있는 아이디"
                case 17008:
                    self.DetailError = "올바름 이메일 형식이 아님"
                case 17026:
                    self.DetailError = "비밀번호가 6자리 미만"
                default:
                    return
                }
    
            }
        }
    
    
    
        func persisImageToStorage(userImage: UIImage) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let ref = Storage.storage().reference(withPath: uid)
            guard let imageData = userImage.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    self.DetailError = "Failed to push image to Storage: \(err)"
                    return
                }
            }
    
            ref.downloadURL { url, err in
                if let err = err {
                    self.DetailError = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                if let url = url{
                    self.DetailError = "Successfully stored image wioth url: \(url.absoluteString ?? "")"
                    print(url.absoluteString)
                }
    
            }
    
        }
    
    
    
    
        // 로그인
        func login(email: String, password: String) {
                Auth.auth().signIn(withEmail: email, password: password) {result, error in
                if let error {
                    print("Error: \(error.localizedDescription)")
                    self.isError = true
                    return
                }
                self.currentUser = result?.user
    
                    //나중에 document 접근할 때 사용할 유저 uid
                    print(self.currentUser!.uid)
    
            }
        }
    
    // MARK: - UserProfile 유무 판별함수
    /// 로그인 후, 해당 유저의 프로필이 등록되어있는지 확인하는 함수
    func fetchUserInfo(_ userId: String) async throws -> FireStoreModel? {
        print(#function)
        guard (Auth.auth().currentUser != nil) else { return nil}
        let ref = Firestore.firestore().collection("User").document(userId)
        let snapshot = try await ref.getDocument()
        guard let docData = snapshot.data() else { return nil }
        let nickName: String = docData["nickName"] as? String ?? ""
        let userPhoto: String = docData["userPhoto"] as? String ?? ""
        let userEmail: String = docData["userEmail"] as? String ?? ""
        let userInfo = FireStoreModel(id: snapshot.documentID, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
        return userInfo
    }
    
    func signout(){
        do{
            try Auth.auth().signOut()
            self.currentUserProfile = nil
            currentUser = nil
            
        }catch{
            print("실패")
        }
        
    }
    
    // MARK: Apple Sign in API
    func appleAuthenticate(credential: ASAuthorizationAppleIDCredential) async {
        // getting Token...
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        // Token String...
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        do {
            let authResult = try await Auth.auth().signIn(with: firebaseCredential)
            self.currentUserProfile =  try await fetchUserInfo(authResult.user.uid)
            self.currentUser = authResult.user
            self.userRegisterType = .Apple
        }catch{
            print("appleLogin Fail..!")
        }
        
    }
    
    // 로그아웃
    func logout() {
        currentUser = nil
        PhotoId.photoUrl = ""
        try? Auth.auth().signOut()
        self.userRegisterType = .Email
    }
    // 회원탈퇴
    func deleteUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("User").document(uid).delete() { err in
            
            if let err {
                print("회원탈퇴 중 error 만남: \(err)")
            } else {
                let user = Auth.auth().currentUser
                user?.delete { err in
                    if let err {
                        print("사용자 삭제 중 오류 - \(err)")
                    } else {
                        print("회원탈퇴 성공")
                        self.currentUser = nil
                    }
                }
                
            }
            
        }
    }
}
    
// MARK: Apple Sign in Helpers
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}



//let fireStoreAddUser = FireStoreModel(id: user.uid, nickName: nickName, userPhoto: "", userEmail: userID)
//self.fireStoreViewModel.addUser(user: fireStoreAddUser)
