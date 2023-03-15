//
//  CustomSheetModifier.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/09.
//

import SwiftUI

struct CustomSheetModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    @Binding var isRecording: Bool
    let firstButtonAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack{
            content
            ZStack{
                if isPresented{
                    Rectangle()
                        .fill(.black.opacity(0.3))
                        .ignoresSafeArea()
                        .transition(.opacity)
                    CustomSheetView(isPresendted: $isPresented, isRecording: $isRecording, stopWritingButtonAction:firstButtonAction, markerWritingButtonAction: firstButtonAction)
                }
            }
        }
    }
}

extension View{
    func customSheet(
        isPresented: Binding<Bool>,
        isRecording: Binding<Bool>,
        title:String,
        message: String,
        firstButtonTitle: String,
        firstButtonAction: @escaping ()-> Void ) -> some View
    {
        modifier(CustomSheetModifier(isPresented: isPresented, isRecording: isRecording, firstButtonAction: firstButtonAction))
    }
}

//struct CustomSheetModifier_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack{
//            Text("ghgh")
//        }.modifier(
//            CustomSheetModifier(isPresented: .constant(true))
//        )
//        
//    }
//}
