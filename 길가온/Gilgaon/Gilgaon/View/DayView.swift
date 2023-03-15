////
////  DayView.swift
////  Gilgaon
////
////  Created by zooey on 2022/12/01.
////
//
import SwiftUI
//
//struct DayView: View {
//    
//    @StateObject var taskModel: TaskViewModel = TaskViewModel()
//    @EnvironmentObject private var cvm: CalendarViewModel
//    @Binding var calID: [String]
//    @Namespace var animation
//    
//    var body: some View {
//        
//        ZStack {
//            
//            Color("White")
//                .ignoresSafeArea()
//            
//            ScrollView(.vertical, showsIndicators: false) {
//                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
//                    
//                    Section {
//                        
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            
//                            HStack(spacing: 10) {
//                                
//                                ForEach(taskModel.currentWeek, id: \.self) { day in
//                                    
//                                    VStack(spacing: 10) {
//                                        
//                                        Text(taskModel.extractDate(date: day, format: "dd"))
//                                            .font(.custom("NotoSerifKR-SemiBold", size: 17))
//                                        
//                                        
//                                        Text(taskModel.extractDate(date: day, format: "EEE"))
//                                            .font(.custom("NotoSerifKR-SemiBold", size: 17))
//                                        
//                                        Circle()
//                                            .fill(Color("White"))
//                                            .frame(width: 8, height: 8)
//                                            .opacity(taskModel.isToday(date: day) ? 1 : 0)
//                                            
//                                        
//                                    }
//                                    .foregroundStyle(taskModel.isToday(date: day) ? .primary : .secondary)
//                                    .foregroundColor(taskModel.isToday(date: day) ? Color("White") : Color("DarkGray"))
//                                    .frame(width: 45, height: 90)
//                                    .background(
//                                    
//                                        ZStack {
//                                            if taskModel.isToday(date: day) {
//                                                
//                                                Capsule()
//                                                    .fill(Color("Pink"))
//                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
//                                            }
//                                        }
//                                    )
//                                    .contentShape(Capsule())
//                                    .onTapGesture {
//                                        withAnimation {
//                                            taskModel.currentDay = day
//                                        }
//                                    }
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//                        
//                        tasksView()
//                        
//                    } header: {
//                        headerView()
//                    }
//                }
//            }
//            .ignoresSafeArea(.container, edges: .top)
//        }
//    }
//    
//    func tasksView() -> some View {
//        LazyVStack(spacing: 18) {
//            if let tasks = cvm.tasks {
//                if tasks.isEmpty {
//                    Text("남겨진 꽃갈피가 없습니다.")
//                        .font(.custom("NotoSerifKR-Light", size: 15))
//                        .foregroundColor(Color("DarkGray"))
//                        .offset(y: 100)
//                } else {
//                    ForEach(cvm.tasks.filter {$0.realDate.contains(calID)}) { task in
//                        NavigationLink(destination: EmptyView()) {
//                            taskCardView(task: task)
//                                .font(.custom("NotoSerifKR-SemiBold", size: 15))
//                        }
//                    }
//                }
//            } else {
//                ProgressView()
//                    .offset(y: 100)
//            }
//        }
//        .padding()
//        .padding(.top)
//        .onChange(of: taskModel.currentDay) { newValue in
//            taskModel.filterTodayTasks()
//        }
//    }
//    
//    func taskCardView(task: DateTask) -> some View {
//        
//        HStack(alignment: .top, spacing: 30) {
//            VStack(spacing: 10) {
//                Circle()
//                    .fill(Color("Pink"))
//                    .frame(width: 15, height: 15)
//                    .background(
//                        Circle()
//                            .stroke(Color("Pink"), lineWidth: 1)
//                            .padding(-3)
//                    )
//                
//                Rectangle()
//                    .fill(Color("Pink"))
//                    .opacity(0.4)
//                    .frame(width: 3)
//            }
//            
//            VStack {
//                
//                HStack(alignment: .top, spacing: 10) {
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text(task.title)
//                            .font(.custom("NotoSerifKR-Bold", size: 19))
//                        
//                        Text("\(task.time)")
//                            .font(.custom("NotoSerifKR-Regular", size: 16))
//                            .foregroundStyle(.secondary)
//                        
//                    }
//                    .hLeading()
//                    
//                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
//                }
//                
//                HStack(spacing: 0) {
//                    HStack(spacing: -10) {
//                        ForEach(["p2", "p3", "p4"], id: \.self) { user in
//                            
//                            Image(user)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 45, height: 45)
//                                .clipShape(Circle())
//                                .background(
//                                Circle()
//                                    .stroke(Color("DarkGray"), lineWidth: 2)
//                                )
//                            
//                        }
//                    }
//                    .hLeading()
//                }
//                .padding(.top)
//                
//            }
//            .foregroundColor(Color("DarkGray"))
//            .padding()
//            .hLeading()
//            .background(
//            Color("Pink")
//                .cornerRadius(25)
//                .opacity(0.4)
//            )
//        }
//        .hLeading()
//    }
// 
//    func headerView() -> some View {
//        
//        HStack(spacing: 10) {
//            
//            VStack(alignment: .leading, spacing: 10) {
//                
//                ZStack(alignment: .leading) {
//                    
//                    MyPath6()
//                        .stroke(Color("Pink"))
//                    
//                    Text("꽃   갈   피")
//                        .font(.custom("NotoSerifKR-Bold", size: 30))
//                        .foregroundColor(Color("DarkGray"))
//                        .offset(x: 50, y: 4)
//                }
//                .padding(.top, 20)
//            }
//
//            
//            Button {
//                
//            } label: {
//                Image("p1")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 45, height: 45)
//                    .clipShape(Circle())
//            }
//        }
//        .padding()
//        .padding(.top, getSafeAtrea().top)
//    }
//    
//}
//
//struct DayView_Previews: PreviewProvider {
//    static var previews: some View {
//        DayView(calID: .constant([]))
//    }
//}
//
//
extension View {
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func getSafeAtrea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
//
//
//struct MyPath6: Shape {
//    
//    func path(in rect: CGRect) -> Path {
//        
//        var path = Path()
//        
//        path.move(to: CGPoint(x: 20, y: 0))
//        path.addLine(to: CGPoint(x: 210, y: 0))
//        
//        path.move(to: CGPoint(x: 20, y: 3))
//        path.addLine(to: CGPoint(x: 210, y: 3))
//        
//        path.move(to: CGPoint(x: 20, y: 50))
//        path.addLine(to: CGPoint(x: 210, y: 50))
//        
//        path.move(to: CGPoint(x: 20, y: 53))
//        path.addLine(to: CGPoint(x: 210, y: 53))
//        
//        path.move(to: CGPoint(x: 40, y: 3))
//        path.addLine(to: CGPoint(x: 40, y: 50))
//        
//        path.move(to: CGPoint(x: 90, y: 3))
//        path.addLine(to: CGPoint(x: 90, y: 50))
//        
//        path.move(to: CGPoint(x: 140, y: 3))
//        path.addLine(to: CGPoint(x: 140, y: 50))
//        
//        path.move(to: CGPoint(x: 190, y: 3))
//        path.addLine(to: CGPoint(x: 190, y: 50))
//       
//        
//        return path
//    }
//}
