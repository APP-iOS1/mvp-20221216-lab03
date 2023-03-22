//
//  HomeView.swift
//  HanselAndGretel
//
//  Created by zooey on 2022/11/29.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @State private var selectedTabBar: SelectedTab = .first
    var body: some View {
        
        VStack {
            switch selectedTabBar {
            case .first:
                DrawerView()
            case .second:
                CalendarView()

            }
            TabBarView(selectedTabBar: $selectedTabBar)
                .frame(height: 30)
        }
        .onAppear {
            print("==  HomeView  ==")
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Color("Red"))
        .fullScreenCover(isPresented: $isFirstLaunching) {
            OnboardingTabView(isFirstLaunching: $isFirstLaunching)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
