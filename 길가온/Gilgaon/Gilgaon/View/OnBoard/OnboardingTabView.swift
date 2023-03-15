//
//  OnboardingTabView.swift
//  Onboard
//
//  Created by kimminho on 2022/12/01.
//
// MARK: -준수 수정
import SwiftUI

struct OnboardingTabView: View {
    @Binding var isFirstLaunching: Bool
//    let locationFetcher = LocationFetcher()
    @EnvironmentObject var locationFetcher: LocationFetcher
    
    // timer count
    @State var count: Int = 1
    let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color("White")
                .ignoresSafeArea()
            if isFirstLaunching == true {
                LottieView2(filename: "Sakura")
                    .ignoresSafeArea()
                    .offset(x:200,y:-270)
                    .frame(width: 2000,height: 1300)
                    .opacity(0.6)
            }
            
            TabView(selection: $count,
                    content: {
                if count == 1 {
                    // 페이지 1: 앱 소개
                    OnboardingDescribeView()
                        .tag(1)
                } else if count == 2 {
                    // 페이지 2: 꽃갈피 소개
                    OnboardingMapDescribeView()
                        .tag(2)
                } else if count == 3 {
                    // 페이지 3: 카메라,위치추적 활성화
                    GilgaonRequestPermissonView()
                        .tag(3)
                }
            })
            .ignoresSafeArea()
            .onReceive(timer, perform: { _ in
                withAnimation(.default) {
                    count = count == 3 ? 1 : count + 1
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .always))
           .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack {
                Spacer()
                Button {
                    Task {
                        await self.locationFetcher.setLocationManager()
                    }
//                    sleep(3)
                    isFirstLaunching = false
                } label: {
                    Text("시작하기")
                        .font(.custom("NotoSerifKR-Bold", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 30.0, alignment: .center)
                        .foregroundColor(Color("White"))
                        .padding(10.0)
                        .background {
                            Color("Pink")
                        }
                        .cornerRadius(10.0)
                    
                }
                .frame(width: 330)
            }
            .frame(height: 650)
                
        }
        
    }
}

struct OnboardingTabView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTabView(isFirstLaunching: .constant(false))
    }
}
