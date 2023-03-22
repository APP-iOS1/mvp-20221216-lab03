//
//  GilgaonApp.swift
//  Gilgaon
//
//  Created by zooey on 2022/11/29.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
        
    }
}

@main
struct GilgaonApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @StateObject var locationFetcher = LocationFetcher()
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(RegisterModel())
//                .environmentObject(LocationsViewModel())
                .environmentObject(SearchViewModel())
//                .environmentObject(CalendarViewModel())
                .environmentObject(FireStoreViewModel())
                .environmentObject(locationFetcher)
        }
    }
}
