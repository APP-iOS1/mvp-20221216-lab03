//
//  PleaseLoginView.swift
//  Gilgaon
//
//  Created by 전준수 on 2022/12/19.
//
// MARK: -준수 수정함
import SwiftUI

struct PleaseLoginView: View {
    @EnvironmentObject var registerModel: RegisterModel
    var body: some View {
        
        NavigationStack {
            Group {
//                if registerModel.currentUser != nil {
//                    if registerModel.currentUserProfile == nil {
//                            RegisterView()
//                            .deferredRendering(for: 1.0)
//                    } else {
//                        HomeView()
//                            .deferredRendering(for: 1.0)
//                    }
//                } else {
//                    LoginView()
//                }
                if registerModel.currentUserProfile != nil {
                    HomeView()
                        .deferredRendering(for: 1.0)
                } else { LoginView() }
            }
            .onChange(of: registerModel.currentUserProfile, perform: { newValue in
                registerModel.currentUserProfile = newValue
            })
            .onAppear {
                print("== PleaseLoginView ==")
                registerModel.listenToAuthState()
                if registerModel.currentUser != nil {
                    Task{
                        registerModel.currentUserProfile = try await registerModel.fetchUserInfo(_: registerModel.currentUser!.uid)
                    }
                }
            }
        }
        .accentColor(Color("Red"))
    }
}

struct PleaseLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PleaseLoginView().environmentObject(RegisterModel())
    }
}

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}

// MARK: 지연 시키는 ViewModifier
private struct DeferredViewModifier: ViewModifier {
    
    // MARK: API
    
    let threshold: Double
    
    // MARK: - ViewModifier
    
    func body(content: Content) -> some View {
        _content(content)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + threshold) {
                    self.shouldRender = true
                }
            }
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private func _content(_ content: Content) -> some View {
        if shouldRender {
            content
        } else {
            content
                .hidden()
        }
    }
    
    @State
    private var shouldRender = false
}

extension View {
    func deferredRendering(for seconds: Double) -> some View {
        modifier(DeferredViewModifier(threshold: seconds))
    }
}
