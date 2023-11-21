//
//  CMReservationHistoryView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI

/// 고객 예약 내역 뷰
struct CMReservationHistoryView: View {
    // MARK: - Properties
    /// 유저 Auth 관리 뷰 모델
    @EnvironmentObject var userAuth: UserAuth
    /// 고객 예약 내역 뷰 모델
    @EnvironmentObject var reservationHistoryViewModel: CMReservationHistoryViewModel
    
    @State var selectedSegment: String = "다가오는 예약"
    
    let segments: [String] = ["다가오는 예약", "지난 예약"]
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - 세그먼티트 컨트롤
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
                
                // MARK: - 선택한 세그먼트에 따른 뷰
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
        }
    }
}

#Preview {
    CMReservationHistoryView()
        .environmentObject(UserAuth())
        .environmentObject(CMReservationHistoryViewModel())
}

