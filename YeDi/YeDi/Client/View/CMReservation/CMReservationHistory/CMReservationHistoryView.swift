//
//  CMReservationHistoryView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI

/// 예약 내역 뷰
struct CMReservationHistoryView: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    @State var selectedSegment: String = "다가오는 예약"
    
    let segments: [String] = ["다가오는 예약", "지난 예약"]
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - 세그먼티트 컨트롤 섹션
                HStack(spacing: 0) {
                    ForEach(segments, id: \.self) { segment in
                        Button(action: {
                            selectedSegment = segment
                        }, label: {
                            VStack {
                                Text(segment)
                                    .fontWeight(selectedSegment == segment ? .semibold : .medium)
                                    .foregroundStyle(Color(UIColor.label))
                                Rectangle()
                                    .fill(selectedSegment == segment ? Color.primaryLabel : .gray6)
                                    .frame(width: 200, height: 3)
                            }
                        })
                    }
                }
                
                // MARK: - 예약 내역 섹션
                switch selectedSegment {
                case "다가오는 예약":
                    CMUpcomingReservationListView()
                case "지난 예약":
                    CMLastReservationListView()
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
        .environmentObject(CMHistoryViewModel())
}

