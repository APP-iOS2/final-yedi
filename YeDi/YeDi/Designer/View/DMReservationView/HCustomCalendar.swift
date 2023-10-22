//
//  HCustomCalendar.swift
//  YeDi
//
//  Created by 송성욱 on 10/5/23.
//

import SwiftUI

struct HCustomCalendar: View {
    
    @State private var selectedDate = Date()
    private let calendar = Calendar.current
    let singleDateF: SingleTonDateFormatter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            monthView
            ZStack {
                dayView
                blurView
            }
            .frame(height: 30)
        }
    }
    
    // MARK: - 월 표시 뷰
    private var monthView: some View {
        HStack(spacing: 30) {
            Button(
                action: {
                    changeMonth(-1)
                },
                label: {
                    Image(systemName: "chevron.left")
                        .padding()
                }
            )
            
            Text(monthTitle(from: selectedDate))
                .font(.title)
            
            Button(
                action: {
                    changeMonth(1)
                },
                label: {
                    Image(systemName: "chevron.right")
                        .padding()
                }
            )
        }
    }
    
    // MARK: - 날짜 표시 뷰
    @ViewBuilder
    private var dayView: some View {
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                let components = (
                    0 ..< calendar.range(of: .day, in: .month, for: startDate)!.count).map {
                        calendar.date(byAdding: .day, value: $0, to: startDate)!
                    }
                
                ForEach(components, id: \.self) { date in
                    VStack {
                        Text(day(from: date))
                            .font(.caption)
                        Text("\(calendar.component(.day, from: date))")
                    }
                    .frame(width: 30, height: 30)
                    .padding(5)
                    .background(content: {
                        if colorScheme == .light {
                            calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) ? Color.green : Color.clear
                        } else if colorScheme == .dark {
                            calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) ? Color.blue : Color.white
                        }
                    })
                    .cornerRadius(8)
                    .foregroundColor( calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) ? .white : .black)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
        }
    }
    
    // MARK: - 날짜 블러 뷰
     private var blurView: some View {
        HStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        colorScheme == .light ? .white.opacity(1) : .black.opacity(1),
                        colorScheme == .light ? .white.opacity(0) : .black.opacity(0)
                    ]
                ),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 20)
            .edgesIgnoringSafeArea(.leading)
            
            Spacer()
            
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        colorScheme == .light ? .white.opacity(1) : .black.opacity(1),
                        colorScheme == .light ? .white.opacity(0) : .black.opacity(0)
                    ]
                ),
                startPoint: .trailing,
                endPoint: .leading
            )
            .frame(width: 20)
            .edgesIgnoringSafeArea(.leading)
        }
    }
}

// MARK: - 로직
    extension HCustomCalendar {
    /// 월 표시
    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM yyyy")
        return dateFormatter.string(from: date)
    }
    
    /// 월 변경
    func changeMonth(_ value: Int) {
        guard let date = calendar.date(
            byAdding: .month,
            value: value,
            to: selectedDate
        ) else {
            return
        }
        selectedDate = date
    }
    
    /// 요일 추출
    func day(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("E")
        return dateFormatter.string(from: date)
    }
}

#Preview {
        HCustomCalendar(singleDateF: .sharedDateFommatter)
}

/// Theme structure
/// - Structure to respond to dark mode
struct Theme {
    static func darkModeColor(forScheme scheme: ColorScheme) -> Color {
        let lightColor = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let darkColor = Color.black
        
        switch scheme {
        case .light
            : return lightColor
        case .dark
            : return darkColor
        @unknown default: return lightColor
        }
    }
}
