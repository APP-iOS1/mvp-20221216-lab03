//
//  WritingView.swift
//  Gilgaon
//
//  Created by sehooon on 2022/12/20.
//

import SwiftUI


struct WritingView: View {
    @EnvironmentObject var firestoreViewModel:FireStoreViewModel
    @AppStorage("recordingKey") var recordingKey = UserDefaults.standard.string(forKey: "recordingKey") ?? ""
    @EnvironmentObject var viewModel: SearchViewModel
    
    @State private var travelName2: String = ""
    @State private var travel: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var location: [String] = []
    @State private var showModal2 = false
    @State private var showModal3 = false
    @State private var lanString = ""
    @State private var lonString = ""
    @State private var locationName = ""
    //사진을 보관할 상태 변수
    @State private var selectedImageData: Data? = nil
    
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    
    
    var body: some View {
        GeometryReader{ g in
            
        ZStack {
            Color("White")
                .ignoresSafeArea()
            
            VStack {
                
                ZStack(alignment: .leading) {
                    MyPath3()
                        .stroke(Color("Pink"))
                    Text("꽃   갈   피")
                        .font(.custom("NotoSerifKR-Bold", size: 30))
                        .foregroundColor(Color("DarkGray"))
                        .padding(.leading, 50)
                }
                .frame(height: g.size.height/12.5)
                .offset(y: -g.size.height/10)
                
                VStack(spacing: 20) {
                    HStack {
                        if location != [] {
                            Text("\(locationName)")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("DarkGray"))
                        } else {
                            Button {
                                showModal2.toggle()
                                //                            print(viewModel.center?.searchPoiInfo.pois.poi.count)
                            } label: {
                                HStack() {
                                    Image(systemName: "pin.fill")
                                    Text("위치")
                                    Text(locationName)
                                        .foregroundColor(Color("Red"))
                                }
                                .foregroundColor(Color("DarkGray"))
                                .font(.custom("NotoSerifKR-SemiBold", size: 15))
                            }
                            .sheet(isPresented: $showModal2) {
                                TestAPIView(lonString: $lonString, lanString: $lanString, locationName: $locationName)
                                    .presentationDetents([.medium])
                            }
                        }
                        Spacer()
                    }
                    
                    HStack {
                        
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = image{
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: g.size.width/5, height: g.size.width/5)
                                        .cornerRadius(15)
                                } else {
                                    HStack {
                                        Image(systemName: "plus.app")
                                        Text("사진")
                                    }
                                    .foregroundColor(Color("DarkGray"))
                                    .font(.custom("NotoSerifKR-SemiBold", size: 15))
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding(.leading, 10)
                
                VStack {
                    TextField("제목", text: $travelName2)
                        .scrollContentBackground(.hidden)
                        .foregroundColor(Color("DarkGray"))
                        .frame(width: g.size.width/1.1)
                        .font(.custom("NotoSerifKR-SemiBold", size: 15))
                    
                    Divider()
                    ZStack(alignment: .topLeading){
                        if travel.isEmpty{
                         Text("내용")
                                .foregroundColor(Color.primary.opacity(0.25))
                                .font(.custom("NotoSerifKR-SemiBold", size: 15))
                                .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                        }
                        TextEditor(text: $travel)
                            .scrollContentBackground(.hidden)
                            .foregroundColor(Color("DarkGray"))
                            .frame(height: g.size.height/3)
                            .font(.custom("NotoSerifKR-SemiBold", size: 15))
                    }
                    .onAppear{
                        UITextView.appearance().backgroundColor = .clear
                    }.onDisappear{
                        UITextView.appearance().backgroundColor = nil
                    }
                }
                .padding()
                Button {
                    let id = UUID().uuidString
                    let createdAt = Date().timeIntervalSince1970
                    var photoId = ""
                    if let image = image{
                        photoId = UUID().uuidString
                        firestoreViewModel.uploadImageToStorage(userImage: image, photoId: photoId)
                    }
                    let marker = MarkerModel(id: id, title: travelName2, photo: photoId, createdAt: createdAt, contents: travel, locationName: locationName, lat: lanString, lon: lonString, shareFriend: [])
                    
                    firestoreViewModel.addMarker(marker)
                    dismiss()
                } label: {
                    Text("추가")
                        .frame(width:60,height:40)
                        .font(.custom("NotoSerifKR-SemiBold", size: 17))
                        .background(Color("Pink"))
                        .foregroundColor(Color("White"))
                        .cornerRadius(8)
                }
            }
        }
    }
        .ignoresSafeArea(.keyboard)
        .onAppear{ firestoreViewModel.nowCalendarId = recordingKey }
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }
}

struct MyPath3: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: 20, y: 0))
        path.addLine(to: CGPoint(x: 210, y: 0))
        
        path.move(to: CGPoint(x: 20, y: 3))
        path.addLine(to: CGPoint(x: 210, y: 3))
        
        path.move(to: CGPoint(x: 20, y: 50))
        path.addLine(to: CGPoint(x: 210, y: 50))
        
        path.move(to: CGPoint(x: 20, y: 53))
        path.addLine(to: CGPoint(x: 210, y: 53))
        
        path.move(to: CGPoint(x: 40, y: 3))
        path.addLine(to: CGPoint(x: 40, y: 50))
        
        path.move(to: CGPoint(x: 90, y: 3))
        path.addLine(to: CGPoint(x: 90, y: 50))
        
        path.move(to: CGPoint(x: 140, y: 3))
        path.addLine(to: CGPoint(x: 140, y: 50))
        
        path.move(to: CGPoint(x: 190, y: 3))
        path.addLine(to: CGPoint(x: 190, y: 50))
        
        return path
    }
}


struct WritingView_Previews: PreviewProvider {
    static var previews: some View {
        WritingView()
            .environmentObject(FireStoreViewModel())
            .environmentObject(SearchViewModel())
    }
}
