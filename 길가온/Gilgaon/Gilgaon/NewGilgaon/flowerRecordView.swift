
//
//  flowerRecordView.swift
//  Gilgaon
//
//  Created by sehooon on 2023/03/09.
//

import SwiftUI

struct FlowerRecordView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isRecording") var isRecordingStatus: Bool = UserDefaults.standard.bool(forKey: "isRecording")
    @State private var titleString = ""
    var body: some View {
        GeometryReader{ g in
            ZStack{
                Color("White")
                    .ignoresSafeArea()
                
                ZStack(alignment: .leading) {
                    MyPath3()
                        .stroke(Color("Pink"))
                    Text("꽃   갈   피")
                        .font(.custom("NotoSerifKR-Bold", size: 30))
                        .foregroundColor(Color("DarkGray"))
                        .padding(.leading, 50)
                }
                .offset(x: g.size.width/4.5, y: -g.size.height/2.3)
                .frame(height: 50)
                
                
                VStack(alignment: .leading, spacing: 30){
                    
                    // [제목]
                    VStack(alignment: .leading){
                        Text("- 제목 ")
                        HStack{
                            TextField("어디에있나요", text: $titleString )
                                .fontWeight(.semibold)
                            Button {
                                
                            } label: {
                                Image(systemName: "delete.left.fill")
                            }
                        }
                    }
                    .font(.custom("NotoSerifKR-Regular",size:18))
                    .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("- 날짜")
                            .font(.custom("NotoSerifKR-Regular",size:18))
                            .fontWeight(.bold)

                        Text("\(Date().ISO8601Format())")
                            .font(.custom("NotoSerifKR-Regular",size:18))
                            .fontWeight(.semibold)
                    }
                    
                    //[함께할 친구]
                    VStack(alignment: .leading, spacing: 10){
                        HStack{
                            Text("- 함께할 친구")
                                .font(.custom("NotoSerifKR-Regular",size:18))
                                .fontWeight(.bold)
                        }
                        HStack{
//                            Button {
//
//                            } label: {
//                                Image(systemName: "person.badge.plus")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 20)
//                                Text("친구 등록")
//                                    .font(.custom("NotoSerifKR-Regular",size:18))
//                            }
//                            .padding(12)
//                            .foregroundColor(.black)
//                            .frame(minWidth: 120)
//                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("Pink")))
//                            friendCellView
                        }
                    }
                    Spacer()
                    HStack(alignment:  .center){
                        Spacer()
                        Button {
                            isRecordingStatus = true
                            NotificationCenter.default.post(name: Notification.Name("isRecording"), object: nil)
                            dismiss()
                        } label: {
                            Text("기록하기")
                        }
                        Spacer()
                    }
                    .foregroundColor(Color("Pink"))
                    .padding()
                }
                .frame(width: g.size.width/1.2,height: g.size.height/1.6)
                .padding()
                .overlay{
                    Rectangle()
                        .stroke(Color("Red"), lineWidth: 1)
                        .padding(3)
                        .overlay {
                            Rectangle()
                                .stroke(Color("Red"),lineWidth: 1)
                        }
                }
                
                
                
            }
        }
        
    }
    
}

extension FlowerRecordView{
    
    private var friendCellView: some View{
        HStack{
            Image(systemName: "person")
            Text("정세훈")
        }.background(.cyan)
    }
}

struct FlowerRecordView_Previews: PreviewProvider {
    static var previews: some View {
        FlowerRecordView()
    }
}
