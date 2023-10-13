//
//  ReservationView.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/26.
//

import SwiftUI

struct ReservationView: View {
    
    @State private var isClicked: Bool = false
    @State private var isShowing: Bool = false
    @State private var tasks: [Tasks] = sampleTasks
    @State private var currentDay: Date = .init()
    
    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink {
                    WkDaySettingDetail()
                } label: {
                    Text("휴무일 설정")
                        .frame(width: 150, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                }
                Spacer().frame(width: 25)
                NavigationLink {
                   // MARK: Dev머지 후 해당파일 경로수정 필요
                    TimeSettingDetail()
                } label: {
                    Text("브레이크 타임 설정")
                        .frame(width: 150, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                }
            }
            .padding(.top)
            .padding(.bottom)
            
            HCustomCalendar(singleDateF: .sharedDateFommatter)
                .padding(.bottom)
                .padding(.horizontal)
            .scrollIndicators(.hidden)
            
            HStack {
                VStack {
                    Divider().padding(.leading)
                }
                Text("예약현황")
                    .font(.caption)
                    .foregroundStyle(.gray)
                VStack {
                    Divider().padding(.trailing)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                TimeLineView()
            }
            .padding(.horizontal, 10)
        }
    }
    
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
                    .stroke(.gray.opacity(0.3), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [15], dashPhase: 10))
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
    
    /// - Task Row
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

#Preview {
    ReservationView()
}

extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
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
