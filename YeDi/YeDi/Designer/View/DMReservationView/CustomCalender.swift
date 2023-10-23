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
    @State var showingAlert: Bool = false
    @Binding var showingRestDaySetting: Bool
    @ObservedObject var dayModel = ClosedDaySetting()
    @State var isContent2: Bool = false
    
    func dateSetToStringArray(dateSet: Set<Date>) -> [String] {
        return dateSet.map { date in
            let dateString = date.formatted(.iso8601)
            return dateString
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("휴무일 설정")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                    Spacer().frame(width: 230).padding(.bottom)
                    Button {
                        showingRestDaySetting = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                .padding(.top)
                .padding(.leading)
                Divider()
                /// 년, 월 표시 view
                headerView
                /// 달력 표시하는 view
                calendarGridView
                Spacer().frame(height: 20)
                Divider()
                Spacer().frame(height: 20)
                Button(action: {
                    showingAlert.toggle()
                }, label: {
                    Text("설정하기")
                        .foregroundColor(.black)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 100, height: 40)
                                .foregroundColor(.gray4)
                        }
                })
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("휴무일 설정"),
                        message: Text("설정하시겠습니까?"),
                        primaryButton: .destructive(Text("취소")) {
                            showingAlert = false
                        },
                        secondaryButton: .default(Text("설정하기"), action: {
                            // 선택된 날짜 파이어베이스에 저장
                            dayModel.addDay(dateSetToStringArray(dateSet: clickedDates))
                            
                            clickedDates = []
                            // toast messege 추후 구현
                        }))
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 21)
                        .foregroundStyle(Color.gray4)
                        .frame(width: .infinity, height: 330)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                        .padding(.top, 10)
                    
                    ScrollView {
                            Text("날짜를 추가하세요")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                            .padding(.top, 3)
                            ForEach(dateSetToStringArray(dateSet: clickedDates), id: \.self) { date in
                                Text("\(date)")
                                    .padding(.top, 3)
                                    .font(.system(size: 15))
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
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
                .font(.title)
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
                            .foregroundColor(Color.black)
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
    CustomCalender(showingRestDaySetting: .constant(true))
}
