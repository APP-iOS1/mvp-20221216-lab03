//
//  SplashView.swift
//  HanselAndGretel
//
//  Created by zooey on 2022/11/28.
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






import SwiftUI

struct SplashView: View {
    
    @State private var isActive = false
    
    var body: some View {
        
        if isActive {
            
            PleaseLoginView()
            
        } else {
            
            ZStack {
                
                Color("White")
                    .ignoresSafeArea()
                
                LottieView1(filename: "Loading")
                    .ignoresSafeArea()
                    .offset(x:0,y:-330)
                    .opacity(0.7)
                MyPath()
                    .stroke(Color("Pink"))
                
                VStack(spacing: 10) {
                    Text("길")
                    Text("⏐")
                    Text("가")
                    Text("온")
                }
                .foregroundColor(Color("DarkGray"))
                .font(.custom("NotoSerifKR-SemiBold", size: 29))
                .offset(x: 90, y: -171)
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isActive = true
                }
                print("Splash")
            }
        }
    }
}




struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}


struct MyPath: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: 310, y: 60))
        path.addLine(to: CGPoint(x: 310, y: 360))
        
        path.move(to: CGPoint(x: 313, y: 60))
        path.addLine(to: CGPoint(x: 313, y: 360))
        
        path.move(to: CGPoint(x: 260, y: 60))
        path.addLine(to: CGPoint(x: 260, y: 360))
        
        path.move(to: CGPoint(x: 263, y: 60))
        path.addLine(to: CGPoint(x: 263, y: 360))
        
        path.move(to: CGPoint(x: 313, y: 60))
        path.addLine(to: CGPoint(x: 260, y: 60))
        
        path.move(to: CGPoint(x: 310, y: 110))
        path.addLine(to: CGPoint(x: 263, y: 110))
        
        path.move(to: CGPoint(x: 310, y: 160))
        path.addLine(to: CGPoint(x: 263, y: 160))
        
        path.move(to: CGPoint(x: 310, y: 210))
        path.addLine(to: CGPoint(x: 263, y: 210))
        
        path.move(to: CGPoint(x: 310, y: 260))
        path.addLine(to: CGPoint(x: 263, y: 260))
        
        path.move(to: CGPoint(x: 310, y: 310))
        path.addLine(to: CGPoint(x: 263, y: 310))
        
        path.move(to: CGPoint(x: 313, y: 360))
        path.addLine(to: CGPoint(x: 260, y: 360))
        
        return path
    }
}
