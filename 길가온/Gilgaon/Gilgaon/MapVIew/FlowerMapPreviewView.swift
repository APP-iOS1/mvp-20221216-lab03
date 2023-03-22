//
//  FlowerMapPreview.swift
//  MapAnnotation
//
//  Created by sehooon on 2022/11/30.
//

import SwiftUI

struct FlowerMapPreview: View {
    @State var isTapped: Bool = false
    @ObservedObject var flowerMapViewModel: FlowerMapViewModel
   
    
    var body: some View {
        HStack(alignment: .bottom){
            VStack(alignment: .leading, spacing: 16){
                imageSection
                titleSection
            }
            VStack(spacing:8){
                detailButton.sheet(isPresented: $isTapped) {
                    
//                    SheetView()
//                        .presentationDetents([.height(450)])
                }
                
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y:65)
        )
        .cornerRadius(10)
        
    
    }
}

extension FlowerMapPreview{
    private var imageSection: some View{
        ZStack{
            if let imageName = flowerMapViewModel.mapLocation.photo{
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .cornerRadius(10)
            }else{
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .cornerRadius(10)
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleSection: some View{
        VStack(alignment: .leading,spacing: 4){
            Text(flowerMapViewModel.mapLocation.locationName)
                .font(.custom("NotoSerifKR-SemiBold", size: 22))
                .fontWeight(.bold)
                .foregroundColor(Color("DarkGray"))
            Text(flowerMapViewModel.mapLocation.createdDate)
                .font(.custom("NotoSerifKR-SemiBold", size: 15))
                .foregroundColor(Color("DarkGray"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var nextButton: some View{
        Button {
            flowerMapViewModel.nextBtnPressed.toggle()
            flowerMapViewModel.clickNextButton()
            
//            vm.nextButtonPressed()
        } label: {
            Text("다음 장소")
                .font(.custom("NotoSerifKR-SemiBold", size: 17))
                
                .frame(width: 125,height: 35)
                .foregroundColor(Color("Pink"))
        }
        .buttonStyle(.bordered)
    }
    
    private var detailButton: some View{
        Button {
            isTapped.toggle()
        } label: {
            Text("꽃갈피 확인")
                .font(.custom("NotoSerifKR-SemiBold", size: 17))
                .frame(width: 125,height: 35)
                .foregroundColor(Color("Pink"))

        }
        .buttonStyle(.bordered)
    }

}


//struct FlowerMapPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowerMapPreview(location: LocationsDataService.locations.first!)
//            .environmentObject(LocationsViewModel())
//    }
//}
//
//

