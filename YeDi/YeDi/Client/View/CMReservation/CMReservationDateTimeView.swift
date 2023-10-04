//
//  CMReservationDateTimeView.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/09/27.
//

// TODO: 현재 날짜만 색깔로 표시 & 시간까지 합쳐서 구조체 만들기
import SwiftUI

struct CMReservationDateTimeView: View {
    @State private var currentMonth: Int = 0
    @State private var currentDate: Date = Date()
    private var isCurrentMonth: Bool {
        currentMonth == 0
    }
    
    var body: some View {
        VStack(spacing: 35) {
            
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            HStack {
                Button {
                    if currentMonth > 0 {
                        currentMonth -= 1
                        currentDate = Date() // 이번달 이전의 달로 이동할 때 currentDate를 초기화
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(isCurrentMonth ? .gray : .pink)
                        
                }
                .disabled(isCurrentMonth)
                
                Text("\(extraData()[0]). \(extraData()[1])")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Button {
                    currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundStyle(.pink)
                }
            }
            
            // 요일
            HStack {
                ForEach(days, id: \.self) { day in
                    Text("\(day)")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background(
                            Circle()
                                .fill(Color.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            if !value.isPast {                            
                                currentDate = value.date
                                print(currentDate)
                            }
                        }
                }
            }
            Spacer()
        }
        .onChange(of: currentMonth) { newValue in
            
        }
    }
    
    @ViewBuilder
    func CardView(value: CalendarModel) -> some View {
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(value.isPast ? .gray : isSameDay(date1: value.date, date2: currentDate) ? .white : .black)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 5)
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraData() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func isPastDate(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.compare(date, to: currentDate, toGranularity: .day) == .orderedAscending
    }
    
    func extractDate() -> [CalendarModel] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)

        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonth
        components.day = 1 // 1일로 설정

        let firstDayOfMonth = calendar.date(from: components)! //TODO: 여기서 8월 31일이 나옴 ㅋㅋ
        let today = Calendar.current.startOfDay(for: Date())
        print("asd\(firstDayOfMonth)")
        
        var days = firstDayOfMonth.getAllDates().compactMap { date -> CalendarModel in
            let day = calendar.component(.day, from: date)
            let isPast = date < today
            print(date)
            print(day)
            
            return CalendarModel(day: day, date: date, isPast: isPast)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(CalendarModel(day: -1, date: Date(), isPast: true), at: 0)
        }
        
        return days
    }
}

extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

#Preview {
    NavigationStack {
        CMReservationDateTimeView()
    }
}

struct CalendarModel: Identifiable {
    let id = UUID().uuidString
    var day: Int
    let date: Date
    let isPast: Bool
}
