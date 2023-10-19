//
//  TimeSettingDetail.swift
//  YeDi
//
//  Created by 송성욱 on 10/5/23.
//

import SwiftUI

struct TimeSettingDetail: View {
    var body: some View {
        TimeHome()
    }
}

struct TimeHome: View {
    
    @StateObject var timeModel = BreakTimeSetting()
    @State private var selectedHour: Int = 1
    @State private var selectedTimePeriod: TimePeriod = .am
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("쉬는 시간 설정을 하세요")
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Picker("SelectedTimePriod", selection: $selectedTimePeriod) {
                        ForEach(TimePeriod.allCases, id: \.self) {
                            timePeriod in
                            Text(timePeriod.displayText)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width/4, height: 200)
                    .clipped()
                    
                    Picker("Selected Hour", selection: $selectedHour) {
                        ForEach(1..<13, id: \.self) {
                            hour in
                            Text("\(hour)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width/4, height: 200)
                    .clipped()
                    Text("시")
                    Spacer()
                }
                List {
                    HStack {
                        if selectedTimePeriod == .am {
                            Text("AM")
                        } else {
                            Text("PM")
                        }
                        Text("\(selectedHour)시")
                    }
                }
            }
        }
    }
}

extension View {
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

#Preview {
    TimeSettingDetail()
}
