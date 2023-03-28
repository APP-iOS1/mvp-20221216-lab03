//
//  FriendSearchViewModel.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/19.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import Combine

class FriendSearchViewModel: ObservableObject{
    @Published var searchString: String = ""
    @Published var recordFriendList: [FriendModel] = []
    @Published var tempFriendList:[FriendModel] = []
    private var cancellables = Set<AnyCancellable>()
    init(){
        searching()
    }
    
    // (1) 친구 목록 불러오기
    func fetchFriendList() async -> [FriendModel]{
        print(#function)
        let database = Firestore.firestore()
        var userList:[FriendModel] = []
        do{
            let querySnapshots = try await database
                .collection("User")
                .document(Auth.auth().currentUser!.uid)
                .collection("Friend")
                .getDocuments()
            for document in querySnapshots.documents{
                let docData = document.data()
                let id: String = document.documentID
                let nickName: String = docData["nickName"] as? String ?? ""
                let userPhoto: String = docData["userPhoto"] as? String ?? ""
                let userEmail:String = docData["userEmail"] as? String ?? ""
                let friend = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                userList.append(friend)
            }
            return userList
        }catch{
            return []
        }
        
    }
    
    
    // (2)입력한 친구 조회하기
    func searchUser(_ userName: String) async -> [FriendModel] {
        print(#function)
        let database = Firestore.firestore()
        var userList:[FriendModel] = []
        let lowercaseUserName = userName.lowercased()
        do{
            let querySnapshots = try await database.collection("User")
                .document(Auth.auth().currentUser!.uid)
                .collection("Friend")
                .getDocuments()
            
            for document in querySnapshots.documents{
                let docData = document.data()
                let id: String = document.documentID
                let nickName: String = docData["nickName"] as? String ?? ""
                let userPhoto: String = docData["userPhoto"] as? String ?? ""
                let userEmail:String = docData["userEmail"] as? String ?? ""
                let friend = FriendModel(id: id, nickName: nickName, userPhoto: userPhoto, userEmail: userEmail)
                if nickName.lowercased().contains(lowercaseUserName){ userList.append(friend) }
            }
            return userList
        }catch{
            return []
        }
    }
    
    func searching(){
        $searchString
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { _ in
            } receiveValue: { username in
                if username.isEmpty{
                    Task{
                        let userList = await self.fetchFriendList()
                        DispatchQueue.main.async{ self.recordFriendList = userList }
                    }
                }else{
                    Task{
                        let userList = await self.searchUser(username)
                        DispatchQueue.main.async { self.recordFriendList = userList }
                    }
                }
            }
            .store(in: &cancellables)
        
        
    }
    //
    func isCheck( _ friend: FriendModel) -> Bool {
        return tempFriendList.contains(friend) ? true : false
    }
    
    //
    func tappedChecking(_ isChecked:Bool, _ friend: FriendModel){
        if isChecked == true{
            if let index = tempFriendList.firstIndex(of: friend) {
                tempFriendList.remove(at: index)
                print(tempFriendList)
            }
        }else{
            withAnimation { tempFriendList.append(friend) }
            print(tempFriendList)
        }
    }
    
    
}
