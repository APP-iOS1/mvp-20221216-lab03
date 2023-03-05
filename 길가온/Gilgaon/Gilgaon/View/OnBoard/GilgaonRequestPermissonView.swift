//
//  GilgaonRequestPermissonView.swift
//  Onboard
//
//  Created by 서광현 on 2022/12/01.
//
// MARK: -준수 수정함
import SwiftUI

struct GilgaonRequestPermissonView: View {
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
        
        ZStack {
            VStack(spacing: 48.0) {
                Text("길가온")
                    .font(.custom("NotoserifKR-Regular", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(Color("Pink")) + Text("을 이용하려면 다음이 필요해요.")
                    .font(.custom("NotoSerifKR-Regular", size: 28))
                    .foregroundColor(Color("DarkGray"))
                
                VStack(spacing:25){
                    HStack(alignment: .center, spacing: 16.0) {
                        Image(systemName: "location.fill.viewfinder")
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("소중한 하루의 발 자취를 기록할 **위치 접근**을 허용해 주세요.")
                            .font(.custom("NotoSerifKR-Regular", size: 17))
                    }
                    .foregroundColor(Color("DarkGray"))
                    
                    HStack(alignment: .center, spacing: 16.0) {
                        Image(systemName: "camera.viewfinder")
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text("추억을 남길 사진촬영을 위해 **카메라 접근**을 허용해 주세요.")
                            .font(.custom("NotoSerifKR-Regular", size: 17))
                    }
                    .foregroundColor(Color("DarkGray"))
                }
                Text("설정하신 모든 접근들은 환경설정에서 변경하실 수 있어요.")
                    .font(.custom("NotoSerifKR-Regular", size: 15))
                    .foregroundColor(Color("DarkGray"))
                
                
            }
            .frame(width: 350, height: 400)
            
            VStack {
                Spacer()
                HStack(spacing: 7) {
                    // MARK: End ProgressView
                    ProgressView(timerInterval: progressEnd, countsDown: false)
                        .tint(Color("Pink"))
                        .foregroundColor(.clear)
                        .frame(width: 80)
                    
                    // MARK: End ProgressView
                    ProgressView(timerInterval: progressEnd, countsDown: false)
                        .tint(Color("Pink"))
                        .foregroundColor(.clear)
                        .frame(width: 80)
                    
                    // MARK: Start ProgressView
                    ProgressView(timerInterval: progressStart, countsDown: false)
                        .tint(Color("Pink"))
                        .foregroundColor(.clear)
                        .frame(width: 80)
                    
                }
            }
            .frame(height: 500)
        }
        

        
    }
}

struct GilgaonRequestPermissonView_Previews: PreviewProvider {
    static var previews: some View {
        GilgaonRequestPermissonView()
    }
}
