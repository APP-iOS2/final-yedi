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
    @State var selectedHour = Date()
    @State var showPicker = false
    
    var body: some View {
        VStack {
            Text("Picker View 구현 중...")
            
            Text(selectedHour, style: .time)
                .font(.largeTitle)
                .fontWeight(.bold)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPicker.toggle()
                    }
                }
            //picker view
            VStack {
                
                HStack(spacing: 15) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Text("\(timeModel.hour):00")
                            .font(.largeTitle)
                            .fontWeight(timeModel.changeToHour ? .bold : .light)
                            .onTapGesture {
                                timeModel.changeToHour = false
                            }
                    }
                    
                    VStack(spacing: 8) {
                        Text("AM")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("PM")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
            //Max width
            .frame(width: getWidth() - 120)
            .background(Color.primary)
            .cornerRadius(8)
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
