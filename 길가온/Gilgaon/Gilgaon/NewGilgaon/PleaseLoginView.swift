//
//  PleaseLoginView.swift
//  Gilgaon
//
//  Created by 전준수 on 2022/12/19.
//

import SwiftUI

struct PleaseLoginView: View {
    @EnvironmentObject private var registerModel: RegisterModel
    var body: some View {
        Group {
            if registerModel.currentUser != nil {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
           registerModel.listenToAuthState()
        }
    }
}

struct PleaseLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PleaseLoginView().environmentObject(RegisterModel())
    }
}
