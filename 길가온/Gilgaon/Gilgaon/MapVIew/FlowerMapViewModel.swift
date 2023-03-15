//
//  FlowerMapViewModel.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/02.
//

import SwiftUI
import MapKit
import Combine

final class FlowerMapViewModel: ObservableObject{
    let firestoreViewModel = FireStoreViewModel()
    let friendViewModel = FriendViewModel()
    
    @Published var locations:[MarkerModel] = []
    @Published var mapRegions = MKCoordinateRegion()
    @Published var mapLocation = MarkerModel(id: "", title: "", photo: "", createdAt: 0, contents: "", locationName: "", lat: "", lon: "", shareFriend: [])
    
    @Published var nextBtnPressed: Bool = false
    @Published var detailBtnPressed:Bool = false
    @Published var showLocationsList: Bool = false
    
    var buttonCancellable: AnyCancellable?
    
    func showNextLocation(location: MarkerModel){
        withAnimation(.easeInOut) {
            mapLocation = location
//                        showLocationsList = false
        }
    }

    func clickNextButton(){
        guard let currentIndex  = locations.firstIndex(where: { $0  == mapLocation }) else { return }
        
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else{
            guard let firstLocation = locations.first else {return }
            showNextLocation(location: firstLocation)
            updateMapRegions(firstLocation)
            return
        }
        
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
        updateMapRegions(nextLocation)
    }
    
    func clickDetailButton(){
        
    }
    
    @MainActor
    func fetchMarkers(inputID: String) async {
        self.locations = await firestoreViewModel.fetchMarkers(inputID: inputID)
        print(locations)
        if !locations.isEmpty {
            mapLocation = locations[0]
            updateMapRegions(mapLocation)
        }
        
//        mapRegions = MKCoordinateRegion(center: <#T##CLLocationCoordinate2D#>, span: <#T##MKCoordinateSpan#>)
//        mapRegions = locations[0]
    }
    
    @MainActor
    func fetchFriendMarkers(userUid: String, inputID: String) async {
        self.locations = await friendViewModel.fetchMarkers(userUid: userUid, inputID: inputID)
        print(locations)
        if !locations.isEmpty {
            mapLocation = locations[0]
            updateMapRegions(mapLocation)
        }
        
//        mapRegions = MKCoordinateRegion(center: <#T##CLLocationCoordinate2D#>, span: <#T##MKCoordinateSpan#>)
//        mapRegions = locations[0]
    }
    
    func updateMapRegions(_ mapMarker: MarkerModel){
        self.mapRegions = MKCoordinateRegion(center: mapMarker.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta:0.02))
    }
    
    func toggleLocationsList(){
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
}
