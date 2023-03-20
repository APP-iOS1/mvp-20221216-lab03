//
//  SecterView.swift
//  HanselAndGretel
//
//  Created by Deokhun KIM on 2022/11/16.
//

import SwiftUI
import MapKit
struct TestAPIView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var searchNetwork: SearchNetwork = SearchNetwork()
    @EnvironmentObject var viewModel: SearchViewModel
    @ObservedObject var jogakData: JogakData = JogakData()
    @EnvironmentObject private var vm: LocationsViewModel
    @State private var searchText: String = ""
    @Binding var lonString: String
    @Binding var lanString: String
    @Binding var locationName: String
    //    @EnvironmentObject private var firestore: FireStoreViewModel
    
    
//    @State private var testFilter: [Poi] = []
    
    
//    var filterData: [Poi] {
//        if searchText.isEmpty {
//            return viewModel.center!.searchPoiInfo.pois.poi
//        } else {
//            return viewModel.center!.searchPoiInfo.pois.poi.filter
//            {$0.name.localizedStandardContains(searchText)}
//        }
//    }
    
//    var getUser: [FireStoreModel] {
//        Task {
//            try! await firestore.searchUser(searchText)
//        }
//        return firestore.users.filter {$0.nickName.localizedStandardContains(searchText)}
//    }

    
    
//    var filterData: [Poi] {
//        Task {
//            viewModel.center = try await searchNetwork.loadJson(searchTerm: searchText)
//        }
//            return viewModel.center!.searchPoiInfo.pois.poi.filter {$0.name.localizedStandardContains(searchText)}
//
//
//    }

    
    var body: some View {
        NavigationView {
            VStack {
//                if viewModel.center?.searchPoiInfo.pois.poi.count ?? 0 > 0 {
                HStack {
                    TextField("장소 검색", text: $searchNetwork.searchText)
                    Button("검색") {
                        searchNetwork.searchResult()
                    }
                }
                    List(searchNetwork.searchResultArray ,id:\.self) { datum in
//                        Text("\(datum.name)")
                        Button {
                            locationName = datum.name //목적지의 이름
                            lonString = datum.frontLon //목적지의 이름
                            lanString = datum.frontLat // 목적지의 경도
                            
                            
//                            LocationsDataService.locations.append(
//                                Location(
//                                    name: datum.name,
//                                    cityName: "경기 안산시 단원구 원곡동 906",
//                                    coordinate: CLLocationCoordinate2D(latitude: Double(datum.frontLat)!, longitude: Double(datum.frontLon)!),
//                                    description: "...",
//                                    imageNames: ["b00"],
//                                    link: "dfsdfsdf"))
//                            jogakData.datum.append(datum)
                            dismiss()
                            vm.doSomeThing()
                        } label: {
                            Text("\(datum.name)")
                                .font(.custom("NotoSerifKR-SemiBold", size: 15))
                        }


//                    }
//                    .searchable(
//                        text: $searchText,
//                        placement: .navigationBarDrawer,
//                        prompt: "장소 검색"
//                    )
                }
            }
        }
        .onAppear {
            searchNetwork.searchResult()
        }
//        .onAppear {
//            Task {viewModel.center = try await searchNetwork.loadJson(searchTerm: "초지역")
//            }
////            print(viewModel.center?.searchPoiInfo.pois.poi.count)
//
//
//        }
    }

}

struct TestAPIView_Previews: PreviewProvider {
    static var previews: some View {
        TestAPIView(lonString: .constant(""), lanString: .constant(""), locationName: .constant(""))
            .environmentObject(SearchViewModel())
            .environmentObject(LocationsViewModel())
    }
}
