//
//  FireStoreViewModel.swift
//  Gilgaon
//
//  Created by kimminho on 2022/12/20.
// MARK: -준수 수정함
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Combine


class FireStoreViewModel: ObservableObject {
    
    @Published var info: FireStoreModel?
    
    @Published var users: [FireStoreModel] = []
    @Published var userList: [FriendModel] = []
    @Published var markerList: [MarkerModel] = []
    @Published var myFriendArray: [FriendModel] = []
    @Published var calendarList:[DayCalendarModel] = []
    @Published var sharedFriend: [FriendModel] = []
    //[마커ㅎ
    @Published var sharedFriendList:[FriendModel] = []
    @Published var isRecording: Bool = false
    @Published var profileUrlString: String?
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userNickName: String = ""
    let database = Firestore.firestore()
    var nowCalendarId: String = ""
    var currentUserId:String?{ Auth.auth().currentUser?.uid }
    
    @Published var guestBookList:[GuestBookModel] = []
    
    // [Image to Storage]
    func uploadImageToStorage(userImage: UIImage, photoId: String) {
        let ref = Storage.storage().reference(withPath: photoId)
        guard let imageData = userImage.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err { return }
        }
        ref.downloadURL { url, err in
            if let err = err { return }
            print(url?.absoluteString)
        }
    }
    
    
    func fetchFriendImageUrl(){
        let storage = Storage.storage()
        guard !myFriendArray.isEmpty else {return}
        self.myFriendArray.forEach { friend in
            let pathReference = storage.reference(withPath: friend.id)
            pathReference.downloadURL { url, error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    // [fetch Profile Image]
    func fetchImageUrl() {
        let storage = Storage.storage()
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let pathReference = storage.reference(withPath: uid)
        pathReference.downloadURL { url, error in
            if let error = error {
                print(error)
            } else {
                guard let urlString = url?.absoluteString else {
                    return
                }
                self.profileUrlString = urlString
            }
        }
    }
    
    //
    func addLocationImage(){
        
    }
    
    //친구목록을 조회하는 함수
    func fetchFriend() {
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("Friend")
            .getDocuments { (snapshot, error) in
                self.myFriendArray.removeAll()
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let userPhoto: String = docData["userPhoto"] as? String ?? ""
                        let userEmail: String = docData["userEmail"] as? String ?? ""
                        
                        let friendInstance: FriendModel = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                        
                        self.myFriendArray.append(friendInstance)
                    }
                    print(self.myFriendArray)
                }
            }
    }
    
    //일정 추가
    func addSchedule(_ scheduleData: MarkerModel){
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("Calendar")
            .document(scheduleData.id)
            .setData([
                "id": scheduleData.id,
                "title": scheduleData.title,
                "photo": scheduleData.photo,
                "createdAt": scheduleData.createdAt,
                "contents": scheduleData.contents,
                "locationName": scheduleData.locationName,
                "lat": scheduleData.lat,
                "lon": scheduleData.lon
            ])
        self.nowCalendarId = scheduleData.id
    }
    
    
    //친구를 추가하는 함수
    func addFriend(friend: FriendModel) {
        database
            .collection("User") //
            .document(self.currentUserId!)
            .collection("Friend")
            .document(friend.id)
            .setData(["id": friend.id,
                      "nickName": friend.nickName,
                      "userPhoto": friend.userPhoto,
                      "userEmail": friend.userEmail])
    }
    
    // 친구를 삭제하는 함수
    func deleteFriend(friend: FriendModel) {
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("Friend")
            .document(friend.id)
            .delete()
        fetchFriend()
    }
    
    
    
    //사용자의 로그인 정보를 추가하는 함수
    func addUser(user: FireStoreModel, photoId: String){
        database
            .collection("User") //
            .document(user.id)
            .setData(["id": user.id, "nickName": user.nickName, "userPhoto": photoId,
                      "userEmail": user.userEmail])
    }
    
    //사용자로부터 닉네임을 입력받아 일치하는 유저를 조회하는 함수
    func myInfo(_ userID: String){
        database
            .collection("User")
            .getDocuments { (snapshot, error) in
                self.userList.removeAll()
                if let snapshot{
                    for document in snapshot.documents{
                        let id: String = document.documentID
                        let docData = document.data()
                        if id == userID {
                            let docData = document.data()
                            let nickName: String = docData["nickName"] as? String ?? ""
                            let userPhoto: String = docData["userPhoto"] as? String ?? ""
                            let userEmail:String = docData["userEmail"] as? String ?? ""
                            let friend = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                            self.userNickName = friend.nickName
                        }
                    }
                }
            }
    }
    
    //사용자로부터 닉네임을 입력받아 일치하는 유저를 조회하는 함수
    func searchUser(_ userName: String) async {
        print(#function)
        database
            .collection("User")
            .getDocuments { (snapshot, error) in
                self.userList.removeAll()
                if let snapshot{
                    for document in snapshot.documents{
                        let id: String = document.documentID
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let userPhoto: String = docData["userPhoto"] as? String ?? ""
                        let userEmail:String = docData["userEmail"] as? String ?? ""
                        let friend = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                        for i in self.myFriendArray {
                            if i.id != id && nickName.contains(userName) {
                                self.userList.append(friend)
                                print(self.userList)
                            }
                        }
                        self.userList = Array(Set(self.userList))
                        
                    }
                }
            }
    }
    

    // id를 가지고 유저를 조회해 사진 url 가져오는 함수
    @MainActor
    func getImageURL(userId: [String]) async -> [FriendModel] {
        print(#function)
        
        self.sharedFriend.removeAll()
        
        do {
            let snapshot = try await database.collection("User").getDocuments()
            for docoment in snapshot.documents {
                let id: String = docoment.documentID
                let docData = docoment.data()
                let nickName: String = docData["nickName"] as? String ?? ""
                let userPhoto: String = docData["userPhoto"] as? String ?? ""
                let userEmail: String = docData["userEmail"] as? String ?? ""
                let user: FriendModel = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                
                for id in userId {
                    if user.id == id {
                        self.sharedFriend.append(user)
                    }
                }
            }
            self.sharedFriend = Array(Set(self.sharedFriend))
            return self.sharedFriend
        } catch {
            print("User 정보 가져오기 실패")
            return []
        }
    }
    func searchUser() {
        print(#function)
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { _ in
            } receiveValue: { text in
                Task {
                    await self.searchUser(text)
                }
            }
            .store(in: &cancellables)
            
    }
    
    

    func persisImageToStorage(user:FireStoreModel, userImage: UIImage) async -> Void {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("uid성공!")
        let ref = Storage.storage().reference(withPath: uid)
        guard let imageData = userImage.jpegData(compressionQuality: 0.5) else { return }
        do{
            let _ = try await ref.putDataAsync(imageData)
            let downloadUrl = try await ref.downloadURL()
            self.addUser(user: user,photoId: downloadUrl.absoluteString)
        }catch{
           print("imageUpload Fail!")
        }
    }
    
    //프로필설정을 마치고 완료버튼을 눌렀을 때 발동
    func addUserInfo(user: FireStoreModel, downloadUrl: String) {
        print(#function)
        database.collection("User")
            .document(Auth.auth().currentUser?.uid ?? "")
            .setData(["id": Auth.auth().currentUser?.uid ?? "",
                      "nickName": user.nickName,
                      "userPhoto": downloadUrl,
                      "userEmail": user.userEmail
                     ])
    }
    
    
    // MARK: - 회원가입 메서드
    /// 회원가입시, 유저의 프로필을 파이어스토어 User컬렉션에 등록하는 메서드.
    func uploadImageToStorage(userImage: UIImage?, user: FireStoreModel) async -> Void {
        let ref = Storage.storage().reference(withPath: Auth.auth().currentUser?.uid ?? "")
        guard let userImage, let imageData = userImage.jpegData(compressionQuality: 0.5) else {
            self.addUserInfo(user: user, downloadUrl: "")
            return
        }
        do{
            let _ = try await ref.putDataAsync(imageData)
            let downloadUrl = try await ref.downloadURL()
            self.addUserInfo(user: user, downloadUrl: downloadUrl.absoluteString)
        }catch{
           print("imageUpload Fail!")
        }
    }
    
    // [서랍 doc생성]
    func addCalendar(_ calendar: DayCalendarModel){
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("Calendar")
            .document(calendar.id)
            .setData([
                "id": calendar.id,
                "title": calendar.title,
                "shareFriend": calendar.shareFriend,
                "realDate": calendar.realDate
            ])
        
        self.nowCalendarId = calendar.id
        print("nowCalendarId: \(self.nowCalendarId)")
        calendarList.append(calendar)
    }
    
    
    //[서랍 data불러오기]
    func fetchDayCalendar(){
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("Calendar")
            .order(by: "realDate", descending: true)
            .getDocuments { (snapshot, error) in
                self.calendarList.removeAll()
                if let snapshot{
                    for document in snapshot.documents{
                        let id = document.documentID
                        let docData = document.data()
                        let createdAt = docData["createdAt"] as? Double ?? 0
                        let title = docData["title"] as? String ?? ""
                        let shareFriend = docData["shareFriend"] as? [String] ?? []
                        let taskDate = docData["taskDate"] as? Date ?? Date()
                        let realDate = docData["realDate"] as? Double ?? 0.0
//                        print("realDate: \(realDate)")
                        let calendarData = DayCalendarModel(id: id, taskDate: taskDate, title: title, shareFriend: shareFriend, realDate: realDate)
                        print(#function)
                        self.calendarList.append(calendarData)
                    }
                }
            }
    }
    
    // [마커 생성하기]
    @MainActor func addMarker(_ marker: MarkerModel){
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("Calendar")
            .document(self.nowCalendarId) //출력됨
            .collection("Marker")
            .document(marker.id)
            .setData([
                "id": marker.id,
                "title": marker.title,
                "photo": marker.photo,
                "createdAt": marker.createdAt,
                "contents": marker.contents,
                "locationName": marker.locationName,
                "lat": marker.lat,
                "lon": marker.lon,
                "sharedFriend": marker.shareFriend
            ])
//        fetchMarkers(inputID: self.nowCalendarId)
    }
    
    
    // [마커 가져오기]
    @MainActor
    func fetchMarkers(inputID: String) async -> [MarkerModel] {
        print(#function)
        var markerArr: [MarkerModel] = []
        let ref = database.collection("User").document(self.currentUserId!).collection("Calendar").document(inputID).collection("Marker")
        do{
            let querySnapshots = try await ref.getDocuments()
            for document in querySnapshots.documents{
                let id: String = document.documentID
                let docData = document.data()
                let title: String = docData["title"] as? String ?? ""
                let photo: String = docData["photo"] as? String ?? ""
                let createdAt: Double = docData["createdAt"] as? Double ?? 0
                let contents: String = docData["contents"] as? String ?? ""
                let locationName: String = docData["locationName"] as? String ?? ""
                let lat: String = docData["lat"] as? String ?? ""
                let lon: String = docData["lon"] as? String ?? ""
                let sharedFriend:[String] = docData["sharedFriend"] as? [String] ?? []
                
                let marker: MarkerModel = MarkerModel(id: id, title: title, photo: photo, createdAt: createdAt, contents: contents, locationName: locationName, lat: lat, lon: lon, shareFriend: sharedFriend)
                
                markerArr.append(marker)
                LocationsDataService.locations = self.markerList
            }
            return markerArr
        }catch{
            return []
        }
        
        
    }
    
    // 나의 방명록 삭제
    func deleteGuestBook(guestBook: GuestBookModel) {
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("GuestBook")
            .document(guestBook.id)
            .delete()
    }
    
    // 나의 방명록 불러오기
    func fetchGuestBook() async{
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("GuestBook")
            .order(by: "date", descending: true)
            .getDocuments { (snapshot, error) in
                self.guestBookList.removeAll()
                if let snapshot{
                    for document in snapshot.documents{
                        let id = document.documentID
                        let docData = document.data()
                        let to = docData["to"] as? String ?? ""
                        let from = docData["from"] as? String ?? ""
                        let fromNickName = docData["fromNickName"] as? String ?? ""
                        let fromPhoto = docData["fromPhoto"] as? String ?? ""
                        let board = docData["board"] as? String ?? ""
                        let date = docData["date"] as? Double ?? 0.0
                        let report = docData["report"] as? Bool ?? false
                        let guestBookData = GuestBookModel(id: id, to: to, from: from, fromNickName: fromNickName, fromPhoto: fromPhoto, board: board, date: date, report: report)
                        print(#function)
                        self.guestBookList.append(guestBookData)
                    }
                }
            }
    }
    
    // 나의 방명록 글 신고하기
    func reportGuestBookON(guestBook: GuestBookModel) {
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("GuestBook")
            .document(guestBook.id)
            .updateData([
                "report": true
            ])
    }
    
    // 나의 방명록 글 신고 취소하기
    func ReportGuestBookOFF(guestBook: GuestBookModel) {
        database
            .collection("User")
            .document(self.currentUserId!)
            .collection("GuestBook")
            .document(guestBook.id)
            .updateData([
                "report": false
            ])
    }
    
}
