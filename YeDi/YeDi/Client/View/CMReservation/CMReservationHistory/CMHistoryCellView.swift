//
//  CMHistoryCellView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/24.
//

import SwiftUI
import FirebaseFirestore

/// 예약 내역 셀 뷰
struct CMHistoryCellView: View {
    // MARK: - Properties
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    @State private var designerName: String = ""
    @State private var designerShop: String = ""
    @State private var reservationDate: String = ""
    
    var reservation: Reservation
    
    /// 디데이 텍스트
    var dDayText: String {
        let offsetComps = Calendar.current.dateComponents(
            [.year,.month,.day], from: SingleTonDateFormatter.sharedDateFommatter.changeStringToDate(dateString: reservation.reservationTime), to: Date()
        )
        
        var dDay = offsetComps.day ?? 0
        
        if dDay == 0 {
            return "D-Day"
        } else {
            return "D-\(dDay)"
        }
    }
    
    /// 리뷰 작성 여부에 따른 텍스트
    var reviewStatusText: String {
        return "리뷰 작성 완료"
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - 뱃지 섹션
            HStack {
                Spacer()
                if reservation.isFinished {
                    Text("\(reviewStatusText)")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray6)
                        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.sub)
                        )
                        .padding([.top, .trailing], 10)
                } else {
                    Text("\(dDayText)")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray6)
                        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.sub)
                        )
                        .padding([.top, .trailing], 10)
                }
            }
            
            Divider()
            
            Group {
                // MARK: - 디자이너 정보 섹션
                HStack {
                    Text("디자이너 정보")
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(designerName)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primaryLabel)
                }
                .padding([.top, .horizontal])
                
                // MARK: - 샵 정보 섹션
                HStack {
                    Text("샵 정보")
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(designerShop)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primaryLabel)
                }
                .padding([.top, .horizontal])
                
                // MARK: - 예약 일시 섹션
                HStack {
                    Text("예약일시")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("\(reservationDate) 예약")
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .foregroundStyle(Color.primaryLabel)
                }
                .padding([.top, .horizontal])
                
                // MARK: - 스타일 섹션
                HStack(alignment: .top) {
                    Text("스타일")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Group {
                            ForEach(reservation.hairStyle) { hairStyle in
                                VStack(alignment: .trailing) {
                                    Text("\(hairStyle.name)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.primaryLabel)
                                    
                                    Text("\(hairStyle.price)원")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding([.top, .horizontal])
            }
            .onAppear {
                Task {
                    await cmHistoryViewModel.fetchDesigner(designerId: reservation.designerUID)
                    
                    designerName = cmHistoryViewModel.designer.name
                    designerShop = cmHistoryViewModel.designer.shop?.shopName ?? "프리랜서"
                    reservationDate = SingleTonDateFormatter.sharedDateFommatter.changeDateString(transition: "MM월 dd일 HH시 mm분", from: reservation.reservationTime)
                }
            }
        }
    }
}

#Preview {
    CMHistoryCellView(reservation: Reservation(clientUID: "", designerUID: "", reservationTime: "", hairStyle: [], isFinished: false))
}
