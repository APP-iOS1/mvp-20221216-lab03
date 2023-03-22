//
//  SwiftUIView.swift
//  Gilgaon
//
//  Created by sehooon on 2022/12/01.
//

import SwiftUI

//struct SheetView: View {
////    @EnvironmentObject var location: LocationsViewModel
//    var body: some View {
//        ZStack {
//            Color(.white)
//                .opacity(0.6)
//                .ignoresSafeArea()
//
//            //[Title - PlaceName]
//            VStack {
//                HStack{
//                    Text("\(location.mapLocation.locationName) ")
//                        .font(.custom("NotoSerifKR-SemiBold", size: 22))
//                        .fontWeight(.heavy)
//                        .foregroundColor(Color("DarkGray"))
//                        .frame(maxWidth: .infinity)
//                        .padding(.leading, 90)
//                    Image(systemName: "eraser")
//                    Image(systemName: "trash")
//                        .padding(.trailing)
//                }
//                .border(Color("Pink"))
//                .padding()
//
//
//                HStack(spacing: 35) {
//                    // [Place Image]
//                    Image("b00")
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                        .cornerRadius(15)
//
//                    VStack {
//                        // [PersonName Button]
//                        HStack {
//                            personButton("준수")
//                            personButton("주희")
//                            personButton("민호")
//                            personButton("광현")
//                        }
//
//                        // [Time]
//                        Text("15:06")
//                            .font(.custom("NotoSerifKR-SemiBold", size: 15))
//                            .foregroundColor(Color("DarkGray"))
//                            .padding(.leading, 100)
//                            .padding(.bottom)
//
//                        // [TextBody]
//                        Text("예쁜 카페에서 \n즐거운 시간 보내기 ♥︎")
//                            .font(.custom("NotoSerifKR-SemiBold", size: 17))
//                            .foregroundColor(Color("DarkGray"))
//                    }
//
//                }
//                .padding(.bottom,40)
//                //[SubTitle]
//                Text("오늘의 여정")
//                    .font(.custom("NotoSerifKR-SemiBold", size: 22))
//                    .foregroundColor(Color("DarkGray"))
//
//                //[Place Images]
//                HStack(spacing: 30){
//                    ForEach(location.locations){ city in
//                        if city == location.mapLocation{
//                            VStack{
//                                ZStack(alignment: .center){
//                                    Image("flowerPink")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 40, height: 40)
//                                        .offset(y:-10)
//                                }
//                            }
//                        }else{
//                            HStack{
//                                VStack{
//                                    ZStack{
//                                        Image(city.photo)
//                                            .resizable()
//                                            .scaledToFit()
//                                            .opacity(0.7)
//                                            .frame(width: 60)
//                                            .cornerRadius(10)
//                                            .shadow(radius: 2)
//                                    }
//                                    .padding(4)
//                                    .background(Color("Pink"))
//                                    .cornerRadius(10)
//                                    Text(city.locationName)
//                                }
//                            }
//
//                        }
//
//                    }
//
//                }
//            }
//
//        }
//    }
//}

//extension SheetView{
//    private func personButton( _ name: String) -> some View{
//        Button {
//            
//        } label: {
//            Text(name)
//                .foregroundColor(Color("DarkGray"))
//                .font(.custom("NotoSerifKR-SemiBold", size: 17))
//                .bold()
//                .cornerRadius(5)
//        }
//    }
//}
//
//struct SheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        SheetView()
//            .environmentObject(LocationsViewModel())
//    }
//}
