//
//  CMReservationHistoryView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI

struct CMReservationHistoryView: View {
    @State var selectedSegment: String = "다가오는 예약"
    let segments: [String] = ["다가오는 예약", "지난 예약"]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ForEach(segments, id: \.self) { segment in
                        Button(action: {
                            selectedSegment = segment
                        }, label: {
                            VStack {
                                Text(segment)
                                    .fontWeight(selectedSegment == segment ? .semibold : .medium)
                                    .foregroundStyle(Color(UIColor.label))
                                Rectangle()
                                    .fill(selectedSegment == segment ? .black : .white)
                                    .frame(width: 180, height: 3)
                            }
                        })
                    }
                }
                
                switch selectedSegment {
                case "다가오는 예약":
                    CMUpcomingReservationView()
                case "지난 예약":
                    CMLastReservationView()
                default:
                    Text("")
                }
            }
            .padding(.top)
            .navigationTitle("예약내역")
        }
    }
}

#Preview {
    CMReservationHistoryView()
}

