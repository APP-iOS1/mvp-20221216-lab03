//
//  OnboardingDescribeView.swift
//  Onboard
//
//  Created by kimminho on 2022/12/01.
//

//감성적이게 작성해보기!
//


/*
 === NotoSerifKR-Regular
 === NotoSerifKR-ExtraLight
 === NotoSerifKR-Light
 === NotoSerifKR-Medium
 === NotoSerifKR-SemiBold
 === NotoSerifKR-Bold
 === NotoSerifKR-Black
 */
// MARK: -준수 수정
import SwiftUI

struct OnboardingDescribeView: View {
    
    // MARK: Ready ProgressView
    var progressReady : Double = 0.0
    
    // MARK: Start ProgressView
    var progressStart: ClosedRange<Date> {
        let start = Date()
        let end = start.addingTimeInterval(5)
        
        return start...end
    }
    
    // MARK: End ProgressView
    var progressEnd: ClosedRange<Date> {
        let start = Date()
        let end = start.addingTimeInterval(0)
        return start...end
    }
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                
                VStack(alignment: .center, spacing: 5) {
                    
                    VStack {
                        Text("안녕하세요")
                            .font(.custom("NotoSerifKR-Bold",size:40))
                            .foregroundColor(Color("Pink"))
                            .padding()
                    }
                    //              HStack {
                    Text("“길가온”")
                        .kerning(-0.5)
                        .font(.custom("NotoSerifKR-SemiBold",size:25))
                        .foregroundColor(Color("Pink")) + Text("은 사용자의 위치를")
                        .kerning(-0.5)
                        .foregroundColor(Color("DarkGray"))
                        .font(.custom("NotoSerifKR-Light",size:25))
                    //                }
                    
                    VStack(spacing: 5) {
                        Text("실시간으로 추적하여")
                            .kerning(-0.5)
                        Text("지나온 동선을 볼 수 있으며")
                            .kerning(-0.5)
                        Text("장소에 대해 마커를 찍고")
                            .kerning(-0.5)
                        Text("마커에 대한 기록을")
                            .kerning(-0.5)
                        Text("남기는 앱 입니다.")
                            .kerning(-0.5)
                    }
                    .font(.custom("NotoSerifKR-Light",size:25))
                    .foregroundColor(Color("DarkGray"))
                    Spacer()
                }
                .frame(width: g.size.width, height: g.size.height / 1.8975)
                
                VStack {
                    Spacer()
                    HStack(spacing: 7) {
                        
                        // MARK: Start ProgressView
                        ProgressView(timerInterval: progressStart, countsDown: false)
                            .tint(Color("Pink"))
                            .foregroundColor(.clear)
                            .frame(width: g.size.width / 4.9125)
                        
                        // MARK: Ready ProgressView
                        ProgressView(value: progressReady)
                            .frame(width: g.size.width / 4.9125)
                            .padding(.bottom, 19)
                        
                        // MARK: Ready ProgressView
                        ProgressView(value: progressReady)
                            .frame(width: g.size.width / 4.9125)
                            .padding(.bottom, 19)
                        
                    }
                }
                .frame(height: g.size.height / 1.518)
            }
        }
    }
}

struct OnboardingDescribeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingDescribeView()
    }
}
