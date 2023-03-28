//
//  FriendSearchViewModel.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/19.
//

import Foundation

class FriendSearchViewModel: ObservableObject{
    @Published var searchString: String = ""
    @Published var recordFriendList: [FriendModel] = []
    @Published var tempFriendList:[FriendModel] = []
    init(){
       
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
            tempFriendList.append(friend)
            print(tempFriendList)
        }
    }
    
    
}
