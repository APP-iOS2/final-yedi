//
//  CustomCalendar.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/27.
//

import SwiftUI

struct CustomCalender: View {
    @State var day: Date = Date()
    @State var month: Date = Date()
    @State var offset: CGSize = CGSize()
    @State var clickedDates: Set<Date> = []
    let collectNum: [String] = []
    
    var body: some View {
        VStack {
            headerView
            calendarGridView
        }
        .padding(.horizontal, 9)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        changeMonth(by: 1)
                    } else if gesture.translation.width > 100 {
                        changeMonth(by: -1)
                    }
                    self.offset = CGSize()
                }
        )
        
    }
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            Text(month, formatter: Self.dateFormatter)
                .font(.title2)
                .padding(.bottom)
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
        }
    }
    
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                    } else {
                        let date = getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        let clicked = clickedDates.contains(date)
                        
                        CellView(day: day, clicked: clicked)
                            .onTapGesture {
                                if clicked {
                                    clickedDates.remove(date)
                                } else {
                                    clickedDates.insert(date)
                                }
                            }
                    }
                }
            }
        }
    }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    var day: Int
    var clicked: Bool = false
    
    init(day: Int, clicked: Bool) {
        self.day = day
        self.clicked = clicked
    }
    
    var body: some View {
        VStack {
            if clicked {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 30)
                    .opacity(0.3)
                    .overlay(Text(String(day)))
                    .foregroundColor(.blue)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 30)
                    .opacity(0.7)
                    .overlay(Text(String(day)))
                    .foregroundColor(.gray)
            }
        }
    }
}
// MARK: - 내부 메서드
private extension CustomCalender {
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
    ///일 변경
    func changeDay(by value: Int) {
        let calendar = Calendar.current
        if let newDay = calendar.date(byAdding: .day, value: value, to: day) {
            self.day = newDay
        }
    }
}

// MARK: - Static 프로퍼티
extension CustomCalender {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    static let weekdaySymbols = Calendar.current.shortWeekdaySymbols
}



#Preview {
    CustomCalender()
}
