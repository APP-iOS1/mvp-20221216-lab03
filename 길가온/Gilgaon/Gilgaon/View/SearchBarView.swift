//
//  SearchBarView.swift
//  Gilgaon
//
//  Created by 정소희 on 2023/03/21.
//

import SwiftUI

struct SearchBarView: View {
    
    @ObservedObject var searchNetwork: SearchNetwork
    @Binding var isSearching: Bool // 서치바 터치시 ture
    
    var body: some View {
        HStack {
            HStack {
                TextField("장소 검색", text: $searchNetwork.searchText)
                    .padding(.leading, 24)
                
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(6)
            .padding()
            .onTapGesture {
                isSearching = true
            }
            .overlay {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    if isSearching {
                        Button(action: { searchNetwork.searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .foregroundColor(.gray)
            }
            .transition(.move(edge: .trailing))
            .animation(.spring(), value: isSearching)
            
            if isSearching {
                Button("Cancel") {
                    isSearching = false
                    searchNetwork.searchText = ""
                    searchNetwork.searchResult()
                    
                    //취소 버튼 터치 시 키보드 내려감
                    endTextEditing()
                }
                .padding(.trailing)
                .padding(.leading, -5)
                .transition(.move(edge: .trailing))
                .animation(.spring(), value: isSearching)
            }
        }
        
    }

}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchNetwork: SearchNetwork(), isSearching: .constant(true))
    }
}
