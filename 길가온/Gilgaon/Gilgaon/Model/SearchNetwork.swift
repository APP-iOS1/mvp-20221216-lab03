//
//  APINetwork.swift
//  HanselAndGretel
//
//  Created by kimminho on 2022/11/29.
//

import Foundation
import Combine

class SearchNetwork: ObservableObject {
    //tsetApi에있는 거를 옮김
    @Published var searchText: String = ""
    @Published var searchResultArray: [Poi] = []
    var cancel = Set<AnyCancellable>()
    func searchResult() {
        print(#function)
        //값의 변동을 체크
        $searchText
        //for는 얼마주기로 할건지 , scheduler는 (0.8초 "뒤"에 행동을 메인쓰레드에서 돌리겠따.)
            .debounce(for: .milliseconds(800) , scheduler: RunLoop.main)
        // 공백이오면 받지 않겠따.
            .removeDuplicates()
            .sink { _ in
                //데이터 완료가 끝났을 떄 적는 칸이라고 생각하면됨
            } receiveValue: { text in
                Task{
                    self.searchResultArray = try await self.loadJson(searchTerm: text)
                }
            }.store(in: &cancel)
//        viewModel.center!.searchPoiInfo.pois.poi
    }
    
    //https://apis.openapi.sk.com/tmap/pois?version=1&searchKeyword=\(fetchEncoded(searchTerm))&searchType=all&searchtypCd=A&reqCoordType=WGS84GEO&resCoordType=WGS84GEO&page=1&count=20&multiPoint=Y&poiGroupYn=N
    func fetchEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? string
    }
    
    
    func loadJson(searchTerm: String) async throws -> [Poi] {
        //        let url = URL(string: inputUrl)!
        print(#function)
        let urlString = "https://apis.openapi.sk.com/tmap/pois?version=1&searchKeyword=\(fetchEncoded(searchTerm))&searchType=all&searchtypCd=A&reqCoordType=WGS84GEO&resCoordType=WGS84GEO&page=1&count=3&multiPoint=Y&poiGroupYn=N"
        //내 리스트에있는 거를 최대 5개까지 불러오겠다
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //사용시에 키값 ❤️지우기
        
        request.addValue("l7xx8749f7a7b24c491682f94ec946029847", forHTTPHeaderField: "appKey")
        
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(DataHere.self, from: data)
            print(result.searchPoiInfo.pois.poi.count)
            let data = result.searchPoiInfo.pois.poi
            return data
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
//        let result = try JSONDecoder().decode([Poi].self, from: data)
        
        //        print(result.count)
        
        //        print(String(data: data, encoding: .utf8))
        
        //        do {
        //            let decoder = JSONDecoder()
        //            let result = try decoder.decode(DataHere.self, from: data)
        ////            return result
        //        } catch DecodingError.dataCorrupted(let context) {
        //            print(context)
        //        } catch DecodingError.keyNotFound(let key, let context) {
        //            print("Key '\(key)' not found:", context.debugDescription)
        //            print("codingPath:", context.codingPath)
        //        } catch DecodingError.valueNotFound(let value, let context) {
        //            print("Value '\(value)' not found:", context.debugDescription)
        //            print("codingPath:", context.codingPath)
        //        } catch DecodingError.typeMismatch(let type, let context) {
        //            print("Type '\(type)' mismatch:", context.debugDescription)
        //            print("codingPath:", context.codingPath)
        //        } catch {
        //            print("error: ", error)
        //        }
        return []
    }
}
