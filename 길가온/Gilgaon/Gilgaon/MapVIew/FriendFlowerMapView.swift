//
//  FriendFlowerMapView.swift
//  Gilgaon
//
//  Created by 전준수 on 2023/03/13.
//

import SwiftUI
import MapKit

struct FriendFlowerMapView: View {
    @StateObject private var friendViewModel = FriendViewModel()
    @StateObject var flowerMapViewModel = FlowerMapViewModel()
    @State var getStringValue: String
    @State private var mapRegion = MKCoordinateRegion()
    @State var userTracking = MapUserTrackingMode.follow
    @State var value = 0
    @State var friendID: String
    var body: some View {
        UserMapView(flowerMapViewModel: flowerMapViewModel).overlay{
            VStack{
                header
                    .padding()
                Spacer()
                ZStack{
                    ForEach(flowerMapViewModel.locations) { location in
                        if flowerMapViewModel.mapLocation == location {
                            FlowerMapPreview(flowerMapViewModel: flowerMapViewModel)
                            .shadow(color: Color("DarkGray").opacity(0.3), radius: 20)
                                .padding()
                        }
                    }
                }
            }
        }
        .onAppear{
            Task{
                print(getStringValue)
                await flowerMapViewModel.fetchFriendMarkers(userUid: friendID, inputID: getStringValue)
            }
        }
    }
    
    
}

extension FriendFlowerMapView {
    var header: some View{
        Button(action: flowerMapViewModel.toggleLocationsList){
            VStack{
                Text(flowerMapViewModel.mapLocation.locationName)
                    .font(.custom("NotoSerifKR-SemiBold", size: 22))
                    .fontWeight(.black)
                    .foregroundColor(Color("Pink"))
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: flowerMapViewModel.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "chevron.up")
                            .font(.headline)
                            .foregroundColor(Color("DarkGray"))
                            .padding()
                            .rotationEffect(Angle(degrees: flowerMapViewModel.showLocationsList ? 180 : 0))
                    }
                if flowerMapViewModel.showLocationsList{
                    LocationsListView(flowerMapViewModel: flowerMapViewModel)
                }
            }
            .background(.thickMaterial)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x:0, y:15)
        }
    }
}
