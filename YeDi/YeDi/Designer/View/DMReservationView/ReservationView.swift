//
//  ReservationView.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/26.
//

import SwiftUI

struct ReservationView: View {
    @State var show: Bool = false
    @State private var isClicked: Bool = false
    @State private var isShowing: Bool = false
    @State private var tasks: [Tasks] = sampleTasks // 예약내역 받아오는 걸로 바꿔야 함
    @State private var currentDay: Date = .init()
    @State var showingRestDaySetting: Bool = false
    @State var showingBreakTimeSetting: Bool = false
    
    // MARK: - Reservation List View
    var body: some View {
        VStack {
            HCustomCalendar(singleDateF: .sharedDateFommatter)
                .padding(.bottom)
                .padding(.horizontal)
                .scrollIndicators(.hidden)
            
            HStack {
                VStack {
                    Divider()
                }
                Text("예약현황")
                    .font(.caption)
                    .foregroundStyle(.gray)
                VStack {
                    Divider()
                }
            }
            .padding(.horizontal)
            
            ZStack {
                ScrollView {
                    TimeLineView()
                }
                .padding(.horizontal, 10)
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        
                        FloatingButton(show: $show, showingRestDaySetting: $showingRestDaySetting, showingBreakTimeSetting: $showingBreakTimeSetting)
                            .padding(.top)
                            .padding(.bottom)
                    }
                }
                .padding(.trailing, 40)
            }
        }
    }
    /// - Timeline Main View
    @ViewBuilder
    func TimeLineView() -> some View {
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack {
                ForEach(hours, id: \.self) { hour in
                    TimelineViewRow(hour)
                        .id(hour)
                }
            }
            .onAppear {
                proxy.scrollTo(midHour)
            }
        }
    }
    
    /// - Timeline View Row
    @ViewBuilder
    func TimelineViewRow(_ date: Date) -> some View {
        HStack(alignment: .top) {
            Text(date.toString("h a"))
                .font(.body)
                .frame(width: 50, alignment: .leading)
            
            /// - Filtering Tasks
            let calendar = Calendar.current
            let filteredTasks = tasks.filter {
                if let hour = calendar.dateComponents([.hour], from: date).hour,
                   let taskHour = calendar.dateComponents([.hour], from: $0.dateAdded).hour,
                   hour == taskHour && calendar.isDate($0.dateAdded, inSameDayAs: currentDay) {
                    return true
                }
                return false
            }
            
            if filteredTasks.isEmpty {
                Rectangle()
                    .stroke(.gray.opacity(0.3), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel))
                    .frame(height: 0.5)
                    .offset(y: 10)
            } else {
                /// - Task View
                VStack(spacing: 10) {
                    ForEach(filteredTasks) { task in
                        TaskRow(task)
                    }
                }
            }
        }
        .hAlign(.leading)
        .padding(.vertical, 15)
    }
    
    /// - Reservation History Row
    @ViewBuilder
    func TaskRow(_ task: Tasks) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.reservationName.uppercased())
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            if task.reservationDC != "" {
                Text(task.reservationDC)
                    .foregroundColor(.red.opacity(0.8))
            }
        }
        .hAlign(.leading)
        .padding(12)
        .background {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray)
                    .frame(width: 4)
            }
        }
    }
}

// MARK: - Custom FloatingButton
struct FloatingButton: View {
    @Binding var show: Bool
    @State var angle: Double = 180
    @Binding var showingRestDaySetting: Bool
    @Binding var showingBreakTimeSetting: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            if self.show {
                Button {
                    showingRestDaySetting.toggle()
                } label: {
                    Image(systemName: "bed.double")
                        .resizable()
                        .frame(width: 25, height: 25).padding(7)
                }
                .background(Color.white)
                .foregroundColor(Color.gray4)
                .clipShape(Circle())
                .shadow(radius: 5)
                .sheet(isPresented: $showingRestDaySetting, content: {
                    WkDaySettingDetail(showingRestDaySetting: $showingRestDaySetting)
                        .presentationCornerRadius(20)
                        .presentationDetents([.fraction(0.6)])
                })
                
                Button {
                    showingBreakTimeSetting.toggle()
                } label: {
                    Image(systemName: "calendar.badge.clock")
                        .resizable()
                        .frame(width: 25, height: 25).padding(7)
                }
                .background(Color.white)
                .foregroundColor(Color.gray4)
                .clipShape(Circle())
                .shadow(radius: 5)
                .sheet(isPresented: $showingBreakTimeSetting, content: {
                    TimeSettingDetail(showingBreakTimeSetting: $showingBreakTimeSetting)
                        .presentationCornerRadius(20)
                        .presentationDetents([.fraction(0.6)])
                })
            }
            
            Button {
                self.show.toggle()
            } label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 30, height: 30).padding(7)
            }
            .background(Color.white)
            .foregroundColor(Color.gray4)
            .clipShape(Circle())
            .shadow(radius: 5)
            .rotationEffect(.init(degrees: self.show ? 100 : 0))
        }
        .animation(.spring, value: angle)
    }
}

// MARK: - Extension
extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}

extension Calendar {
    /// - Return 24 Hours in  a day
    var hours: [Date] {
        let startOfDay = self.startOfDay(for: Date())
        var hours: [Date] = []
        for index in 0..<24 {
            if let date =  self.date(byAdding: .hour, value: index, to: startOfDay) {
                hours.append(date)
            }
        }
        return hours
    }
    
    /// - Used to Store Data of Each Week Day
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var string: String
        var date: Date
        var isToday: Bool = false
    }
}

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

#Preview {
    ReservationView()
}
