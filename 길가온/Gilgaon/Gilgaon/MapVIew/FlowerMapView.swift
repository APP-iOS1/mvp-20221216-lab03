//
//  ContentView.swift
//  MapAnnotation
//
//  Created by sehooon on 2022/11/30.
//
import SwiftUI
import MapKit

struct Place: Identifiable{
    var id = UUID()
    var name: String = ""
    var coordinate: CLLocationCoordinate2D
}

struct FlowerMapView: View {
    
    @StateObject var flowerMapViewModel = FlowerMapViewModel()
    @State var getStringValue: String
    @State private var mapRegion = MKCoordinateRegion()
    @State var userTracking = MapUserTrackingMode.follow
    @State var value = 0
    var body: some View {
        UserMapView(flowerMapViewModel: flowerMapViewModel)
            .ignoresSafeArea()
            .overlay{
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
                await flowerMapViewModel.fetchMarkers(inputID: getStringValue)
            }
        }
    }
    
    
}

extension FlowerMapView {
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



//struct FlowerMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowerMapView()
//            .environmentObject(LocationsViewModel())
//    }
//}

