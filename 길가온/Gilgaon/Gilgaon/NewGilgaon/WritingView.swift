//
//  WritingView.swift
//  Gilgaon
//
//  Created by sehooon on 2022/12/20.
//

import SwiftUI


struct WritingView: View {
    @EnvironmentObject var firestoreViewModel:FireStoreViewModel
    
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
                .frame(height: 50)
                .offset(y: -90)
                
                VStack(spacing: 20) {
                    HStack {
                        Button {
                            showModal3.toggle()
                        } label: {
                            if firestoreViewModel.sharedFriendList.isEmpty {
                                Label("함께", systemImage: "plus")
                                    .foregroundColor(Color("DarkGray"))
                                    .font(.custom("NotoSerifKR-SemiBold", size: 15))
                            } else {
                                ForEach(firestoreViewModel.sharedFriendList, id: \.self) { user in
                                    Text(user.nickName)
                                        .foregroundColor(Color("DarkGray"))
                                        .font(.custom("NotoSerifKR-SemiBold", size: 15))
                                }
                            }
                        }
                        .sheet(isPresented: $showModal3) {
                            AddMarkerFriendView(fireStoreViewModel: firestoreViewModel)
                                .presentationDetents([.medium])
                        }
                        Spacer()
                        
                        
                    }
                    
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
                                        .frame(width: 100, height: 100)
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
                        .foregroundColor(Color("DarkGray"))
                        .frame(width: 380)
                        .font(.custom("NotoSerifKR-SemiBold", size: 15))
                    
                    Divider()
                    
                    TextField("내용", text: $travel)
                        .foregroundColor(Color("DarkGray"))
                        .frame(width: 380)
                        .font(.custom("NotoSerifKR-SemiBold", size: 15))
                }
                .padding(.bottom, 200)
                
                
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
