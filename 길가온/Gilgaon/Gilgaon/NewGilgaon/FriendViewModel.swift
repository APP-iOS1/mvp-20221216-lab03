//
//  FriendViewModel.swift
//  Gilgaon
//
//  Created by 김민호 on 2023/03/02.
//

import Foundation
import Firebase
import FirebaseAuth

class FriendViewModel: ObservableObject {
    @Published var myInfo: FriendModel?
    @Published var friendInfo: FriendModel?
    @Published var friendRequestArray: [FriendModel] = []
    @Published var friendRequestArrayUid: [String] = []
    @Published var listener: ListenerRegistration?
    @Published var myFriendFriendArray: [FriendModel] = []
    @Published var friendCalendarList:[DayCalendarModel] = []
    @Published var friendCalendarListSharedFriend: [FriendModel] = []
    @Published var markerList: [MarkerModel] = []
    @Published var friendGuestBook: GuestBookModel?
    @Published var friendGuestBookList:[GuestBookModel] = []
    
    var friendGuestBookId: String = ""

    
    let database = Firestore.firestore()
    //상대방이 추가할 때 내 아이디에 친구의 uid를 담아준다.
    
    //나의 친구요청목록을 확인할 때
    func fetchFriendRequest(){
        print(#function)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = database.collection("Waiting").document(uid)
        listener = ref.addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot  else { return }
            guard let docData = document.data() else { return }
            self.friendRequestArrayUid = docData["sendToFriend"] as? [String] ?? []
        }
    }
    
    
    //[sendFriendRequest를 위한 함수] 친구에게 온 친구목록을 조회
    private func fetchWaitingFriend(_ userId: String) async -> [String]? {
        print(#function)
        do{
            let document = try await database.collection("Waiting").document(userId).getDocument()
            guard let docData = document.data() else{ return [] }
            let waitingArr = docData["sendToFriend"] as? [String] ?? []
            return waitingArr
        }catch{
            print("Error!")
            return nil
        }
    }
    //친구요청을 보낼 때
    func sendFriendRequest(friendUid: String) async {
        print(#function)
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        guard var friendsWaitingArray = await self.fetchWaitingFriend(friendUid) else {return}
        friendsWaitingArray.append(myUid)
        print("없니..?",friendsWaitingArray)
        //친구의 uid에 내 uid를 추가함
        do {
            print("do문 입니다.")
            try await database
                .collection("Waiting")
                .document(friendUid)
                .setData(["sendToFriend": friendsWaitingArray])
        } catch {
            print("== sendFriendRequest error ==")
        }
    }
    //친구를 추가할 때
    func addFriendBoth() {
        
    }
    func deleteWaitingFriend(userId: String) async {
        print(#function)
        guard let myId = Auth.auth().currentUser?.uid else { return }
        guard var waitingFriend = await fetchWaitingFriend(myId) else { return }
        guard let index = waitingFriend.firstIndex(of: userId) else { return }
        waitingFriend.remove(at: index)
        do{
            try await database.collection("Waiting").document(myId).updateData([ "sendToFriend" : waitingFriend ])
        }catch{
                print("Error")
        }
    }
    
    //친구추가
    func addFriendMe() async throws{
        try await database
            .collection("User") //
            .document(myInfo!.id)
            .collection("Friend")
            .document(friendInfo!.id)
            .setData(["id": friendInfo!.id,
                      "nickName": friendInfo!.nickName,
                      "userPhoto": friendInfo!.userPhoto,
                      "userEmail": friendInfo!.userEmail])
    }
    
    func addFriend() async throws{
        try await database
            .collection("User") //
            .document(friendInfo!.id)
            .collection("Friend")
            .document(myInfo!.id)
            .setData(["id": myInfo!.id,
                      "nickName": myInfo!.nickName,
                      "userPhoto": myInfo!.userPhoto,
                      "userEmail": myInfo!.userEmail])
    }
    
    //사용자로부터 닉네임을 입력받아 일치하는 유저를 조회하는 함수
    func findUserUIdMe(userUid: String) async{
        database
            .collection("User")
            .getDocuments { (snapshot, error) in
//                self.userList.removeAll()
                if let snapshot{
                    for document in snapshot.documents{
                        let id: String = document.documentID
                        if id == userUid {
                            let docData = document.data()
                            let nickName: String = docData["nickName"] as? String ?? ""
                            let userPhoto: String = docData["userPhoto"] as? String ?? ""
                            let userEmail:String = docData["userEmail"] as? String ?? ""
                            let friend = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                            self.myInfo = friend
                            print(self.myInfo)
                        }
                    }
                }
            }
    }
    
    func findUserFriend(userUid: String) async{
        database
            .collection("User")
            .getDocuments { (snapshot, error) in
//                self.userList.removeAll()
                if let snapshot{
                    for document in snapshot.documents{
                        let id: String = document.documentID
                        if id == userUid {
                            let docData = document.data()
                            let nickName: String = docData["nickName"] as? String ?? ""
                            let userPhoto: String = docData["userPhoto"] as? String ?? ""
                            let userEmail:String = docData["userEmail"] as? String ?? ""
                            let friend = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                            self.friendInfo = friend
                        }
                    }
                }
            }
    }
    
    //친구의 친구목록을 조회하는 함수
    func fetchFriendFriend(userUid: String) async{
         database
            .collection("User")
            .document(userUid)
            .collection("Friend")
            .getDocuments { (snapshot, error) in
                self.myFriendFriendArray.removeAll()
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let userPhoto: String = docData["userPhoto"] as? String ?? ""
                        let userEmail: String = docData["userEmail"] as? String ?? ""
                        
                        let friendInstance: FriendModel = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                        
                        self.myFriendFriendArray.append(friendInstance)
                    }
                    print("니친구들 다보여줘바")
                    print(self.myFriendFriendArray)
                }
            }
    }
    
    //친구의 서랍목록을 조회하는 함수
    func fetchFriendDayCalendar(userUid: String) async{
        database
            .collection("User")
            .document(userUid)
            .collection("Calendar")
            .order(by: "realDate", descending: true)
            .getDocuments { (snapshot, error) in
                self.friendCalendarList.removeAll()
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
                        self.friendCalendarList.append(calendarData)
                        print("친구 서랍 데이터입니다")
                        print(calendarData)
                    }
                }
            }
    }
    
    // 친구의 id를 가지고 유저를 조회해 사진 url 가져오는 함수
    @MainActor
    func fetchFriendDayCalendarFriendGetImageURL(userId: [String]) async -> [FriendModel] {
        print(#function)
        
        self.friendCalendarListSharedFriend.removeAll()
        
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
                        self.friendCalendarListSharedFriend.append(user)
                    }
                }
            }
            self.friendCalendarListSharedFriend = Array(Set(self.friendCalendarListSharedFriend))
            return self.friendCalendarListSharedFriend
        } catch {
            print("User 정보 가져오기 실패")
            return []
        }
    }
    
    // [마커 가져오기]
    @MainActor
    func fetchMarkers(userUid: String, inputID: String) async -> [MarkerModel] {
        print(#function)
        var markerArr: [MarkerModel] = []
        let ref = database.collection("User").document(userUid).collection("Calendar").document(inputID).collection("Marker")
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
    // 친구 방명록 작성
    func addFriendGuestBook(guestBook: GuestBookModel, friendID: String) {
        database
            .collection("User")
            .document(friendID)
            .collection("GuestBook")
            .document(guestBook.id)
            .setData([
                "id": guestBook.id,
                "to": guestBook.to,
                "from": guestBook.from,
                "fromNickName": guestBook.fromNickName,
                "fromPhoto": guestBook.fromPhoto,
                "board": guestBook.board,
                "date": guestBook.date,
                "report": guestBook.report
            ])
        
        self.friendGuestBookId = guestBook.id
        print("friendGuestBookId: \(self.friendGuestBookId)")
        friendGuestBookList.append(guestBook)
    }
    
    // 친구 방명록 삭제
    func deleteFriendGuestBook(guestBook: GuestBookModel, friendID: String) {
        database
            .collection("User")
            .document(friendID)
            .collection("GuestBook")
            .document(guestBook.id)
            .delete()
    }
    

    // 친구 방명록 불러오기
    func fetchFriendGuestBook(friendID: String) async{
        database
            .collection("User")
            .document(friendID)
            .collection("GuestBook")
            .order(by: "date", descending: true)
            .getDocuments { (snapshot, error) in
                self.friendGuestBookList.removeAll()
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
                        let friendGuestBookData = GuestBookModel(id: id, to: to, from: from, fromNickName: fromNickName, fromPhoto: fromPhoto, board: board, date: date, report: report)
                        print(#function)
                        self.friendGuestBookList.append(friendGuestBookData)
                    }
                }
            }
    }



    
}
