//
//  LocationsViewModel.swift
//  MapAnnotation
//
//  Created by sehooon on 2022/12/01.
//

import Foundation
import MapKit
import SwiftUI
import Combine


//class LocationsViewModel: ObservableObject{
//    @Published var locations: [MarkerModel]
//    
//    @Published var mapLocation: MarkerModel{
//        didSet{
//            updateMapRegion(location: mapLocation)
//        }
//    }
//    
//    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
//    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//    
//    @Published var showLocationsList: Bool = false
//    
//    init(){
//        let locations = LocationsDataService.locations
//        print(locations.count)
//        self.locations = locations
//        self.mapLocation = locations.first!
//        self.updateMapRegion(location: locations.first!)
//    }
//    
//    func doSomeThing() {
//        let locations = LocationsDataService.locations
//        print(locations.count)
//        self.locations = locations
//        self.mapLocation = locations.first!
//        self.updateMapRegion(location: locations.first!)
//    }
//    
//    
//    private func updateMapRegion(location: MarkerModel){
//        withAnimation(.easeInOut){
//            mapRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta:0.02))
//        }
//        
//    }
//    
//    func toggleLocationsList(){
//        withAnimation(.easeInOut) {
//            showLocationsList.toggle()
//        }
//    }
//    
//    func showNextLocation(location: MarkerModel){
//        withAnimation(.easeInOut) {
//            mapLocation = location
//            showLocationsList = false
//        }
//    }
//    
//    func nextButtonPressed(){
//        guard let currentIndex  = locations.firstIndex(where: { $0  == mapLocation }) else { return }
//        
//        let nextIndex = currentIndex + 1
//        guard locations.indices.contains(nextIndex) else{
//            guard let firstLocation = locations.first else {return }
//            showNextLocation(location: firstLocation)
//            return
//        }
//        
//        let nextLocation = locations[nextIndex]
//        showNextLocation(location: nextLocation)
//    }
//}
