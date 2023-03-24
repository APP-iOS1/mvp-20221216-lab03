//
//  OnboardingMapDescribeView.swift
//  Gilgaon
//
//  Created by sehooon on 2022/12/22.
//
// MARK: -준수 수정
import SwiftUI

struct OnboardingMapDescribeView: View {
    
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
                    Spacer()
                    VStack {
                        Text("꽃갈피")
                            .font(.custom("NotoSerifKR-Bold",size:40))
                            .foregroundColor(Color("Pink"))
                            .padding()
                    }
                    VStack() {
                        ZStack{
                            Image("flowerPink")
                                .resizable()
                                .scaledToFit()
                                .frame(width: g.size.width / 4.9125, height: g.size.height / 7.59)
                            Circle()
                                .stroke(lineWidth: 4)
                                .frame(width: g.size.width / 2.62)
                                .foregroundColor(Color("Pink"))
                                .rotation3DEffect(Angle(degrees: 85), axis: (x: 1, y: 0, z: 0))
                                .offset(y:50)
                        }
                        .padding(.bottom,50)
                        
                        VStack(spacing: 5) {
                            Text("“꽃갈피”는")
                                .kerning(-0.5)
                                .font(.custom("NotoSerifKR-SemiBold",size:25))
                                .foregroundColor(Color("Pink")) + Text(" 지나온 동선에 ")
                                .kerning(-0.5)
                                .foregroundColor(Color("DarkGray"))
                                .font(.custom("NotoSerifKR-Light",size:25))
                            
                            
                            
                            
                            Text("특별한 기록을 남겨주는 말입니다.")
                                .padding(.top,5)
                                .kerning(-0.5)
                        }
                        
                    }
                    .font(.custom("NotoSerifKR-Light",size:25))
                    .foregroundColor(Color("DarkGray"))
                    Spacer()
                }
                .frame(width: g.size.width, height: g.size.height / 1.8975)
                
                VStack {
                    Spacer()
                    HStack(spacing: 7) {
                        // MARK: End ProgressView
                        ProgressView(timerInterval: progressEnd, countsDown: false)
                            .tint(Color("Pink"))
                            .foregroundColor(.clear)
                            .frame(width: g.size.width / 4.9125)
                        
                        // MARK: Start ProgressView
                        ProgressView(timerInterval: progressStart, countsDown: false)
                            .tint(Color("Pink"))
                            .foregroundColor(.clear)
                            .frame(width: g.size.width / 4.9125)
                        
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

struct OnboardingMapDescribeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingMapDescribeView()
    }
}
