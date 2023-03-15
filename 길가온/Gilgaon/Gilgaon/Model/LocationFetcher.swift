import CoreLocation
import SwiftUI
import MapKit

class LocationFetcher: NSObject, CLLocationManagerDelegate,ObservableObject {
    let manager = CLLocationManager()
    @Published var recentLocation: CLLocationCoordinate2D?
//    @Published var lineDraw: MKPolyline?
    @Published var points: [CLLocationCoordinate2D] = [
        // TEST
//        CLLocationCoordinate2D(latitude: 37.25062407449622, longitude: 127.0635877387619),
//        CLLocationCoordinate2D(latitude: 37.25111939891473, longitude: 127.0639310615158),
//        CLLocationCoordinate2D(latitude: 37.251384139941024, longitude: 127.06349117923736),
    ]
    

    override init() {
        super.init()
        manager.delegate = self
    }

    
    func setLocationManager() async {
//        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        Task {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.manager.startUpdatingLocation()
                }
//                manager.delegate = self
            } else {
                print("[Fail] 위치 서비스 off 상태 ")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let location = locations.first {
            recentLocation = location.coordinate
        }
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        if let recentLocation = self.recentLocation {
            print(" ##Count:\(points.count)")
            print("\(recentLocation.latitude)")
            //현재위치의 좌표 (START)
            let startPoint = CLLocationCoordinate2DMake(recentLocation.latitude, recentLocation.longitude)
            points.append(startPoint)
            //위치정보의 마지막값 (LAST)
            if locations.last!.horizontalAccuracy <= manager.desiredAccuracy {
                let lon = manager.location?.coordinate.longitude
                let lat = manager.location?.coordinate.latitude
                let lastPoint: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lon!)
                points.append(lastPoint)
            }
        }
        self.recentLocation = location.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
}
