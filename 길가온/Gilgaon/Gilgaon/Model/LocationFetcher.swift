import CoreLocation
import SwiftUI
import MapKit
import Firebase
import FirebaseAuth
import Combine


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
    
    let testPoint: [[CLLocationCoordinate2D]] = [
        [CLLocationCoordinate2D(latitude: 37.25062407449622, longitude: 127.0635877387619),CLLocationCoordinate2D(latitude: 37.25111939891473, longitude: 127.0639310615158),CLLocationCoordinate2D(latitude: 37.251384139941024, longitude: 127.06349117923736)],        [CLLocationCoordinate2D(latitude: 36.25062407449622, longitude: 126.0635877387619),CLLocationCoordinate2D(latitude: 36.25111939891473, longitude: 126.0639310615158),CLLocationCoordinate2D(latitude: 36.251384139941024, longitude: 126.06349117923736)]
    ]
    
    var cancellable = Set<AnyCancellable>()
    let touchCell = CurrentValueSubject<[CLLocationCoordinate2D],Never>([])

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
                switch manager.authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    print("사용자가 위치 사용하겠다고 알림")
                    DispatchQueue.main.async {
                        self.manager.startUpdatingLocation()
                    }
                case .notDetermined:
                    //처음 상태는 notDetermined
                    print("notDetermined")
                case .restricted:
                    print("restricted")
                case .denied:
                    await MainActor.run {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
//                manager.delegate = self
            } else {
                print("[Fail] 위치 서비스 off 상태 ")
            }
        }
    }
    
    func setup() {
        
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
    
    
    func stopLocation(_ scheduleData: MarkerModel) {
        //1. 위치정보를 끈다.
        manager.stopUpdatingLocation()
        //2. 배열을 서버로 전송한다.
        Firestore.firestore()
            .collection("User")
            .document(Auth.auth().currentUser?.uid ?? "")
            .collection("Calendar")
            .document(scheduleData.id)
            .collection("TrafficLine")
            .document("dongseon")
            .setData(["myTrafficLine":points])
    }
    
    func getTrafficLine(_ scheduleData: MarkerModel) async{
        let ref = Firestore
                        .firestore()
                        .collection("User")
                        .document(Auth.auth().currentUser?.uid ?? "")
                        .collection("Calendar")
                        .document(scheduleData.id)
                        .collection("TrafficLine")
                        .document("dongseon")
        
        do {
            let snapShot = try await ref.getDocument()
            let docData = snapShot.data()!
            let data = docData["myTrafficLine"] as? [CLLocationCoordinate2D] ?? []
            touchCell.send(data)
        } catch {
            print("동선데이터를 받아올 수 없음")
        }
    }
    
    func a() {
        touchCell
            .receive(on: DispatchQueue.main)
//            .assign(to: &sad)
            .sink { trafficLine in
                print(trafficLine)
            }.store(in: &cancellable)
    }
    
}
