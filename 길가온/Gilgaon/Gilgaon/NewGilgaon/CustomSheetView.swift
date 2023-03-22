//
//  CustomSheetView.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/09.
//

import SwiftUI

struct CustomSheetView: View {
 
    @Binding var isPresendted:Bool
    @Binding var isRecording: Bool
    @Binding var recordingID: String
    let stopWritingButtonAction: () -> Void
    let markerWritingButtonAction: () -> Void
    
    var body: some View {
        VStack{
            VStack{
                ZStack{
                    HStack(){
                        Button {
                            isPresendted = false
                        } label: {
                            Image(systemName: "xmark")
                            
                        }
                        .padding(.leading)
                        Spacer()
                    }
                    Text("작업끝내기")
                }
                .foregroundColor(.black)
                .padding(.bottom)
                sheetViewButton()
            }
            .padding(.bottom)
            .background( Color("White"))
            Spacer()
        }
        .font(.custom("NotoSerifKR-Regular",size:16))
        
        
    
        
    }
}

extension CustomSheetView{
    @ViewBuilder
    private func sheetViewButton() -> some View{
        if isRecording{
            HStack(spacing: 50){
                Button {
                    isRecording = false
                } label: {
                    VStack(spacing: 10){
                        Image(systemName: "stop.circle")
                        Text("기록중지")
                    }
                    
                }
                
                NavigationLink {
                    WritingView()
                } label: {
                    VStack(spacing: 10){
                        Image(systemName: "mappin.and.ellipse")
                        Text("마커찍기")
                    }

                }
                
                NavigationLink {
                    FlowerMapView(getStringValue: recordingID)
                } label: {
                    VStack(spacing: 10){
                        Image(systemName: "map")
                        Text("지도보기")
                    }
                 
                }
            }
            .padding(5)
            .frame(maxWidth: .infinity)
        }else{
            NavigationLink {
                FlowerRecordView()
            } label: {
                VStack{
                    Image(systemName: "pencil.line")
                    Text("기록 생성하기")
                }
            }
            .padding(5)
    
          
        }
    }
}

//struct CustomSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomSheetView(isPresendted: .constant(false), isRecording: .constant(false), stopWritingButtonAction: {}, markerWritingButtonAction: {})
//    }
//}
