//
//  CMReservationInfoView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/13.
//

import SwiftUI
import FirebaseFirestore

struct CMReservationInfoView: View {
    // MARK: - Properties
    @EnvironmentObject var cmHistoryViewModel: CMHistoryViewModel
    
    @State private var designerName: String = ""
    @State private var designerRank: String = ""
    @State private var designerShop: String = ""
    @State private var reservationDate: String = ""
    @State private var styles: [String] = []
    
    var reservation: Reservation
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Group {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(designerRank) \(designerName)")
                        .font(.title3)
                    HStack {
                        ForEach(styles, id: \.self) { style in
                            if styles.last == style {
                                Text("\(style)")
                                    .font(.title)
                            } else {
                                Text("\(style),")
                                    .font(.title)
                            }
                        }
                    }
                }
                .fontWeight(.semibold)
                
                HStack {
                    Text("\(reservationDate) 예약")
                    Spacer()
                }
            }
            .offset(y: 65)
            
            Spacer()
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .frame(height: 300)
                .foregroundColor(.white)
                .shadow(color: Color.gray3, radius: 5, x: 0, y: 5)
                .opacity(0.2)
        )
        .offset(y: -70)
        .onAppear {
            Task {
                await cmHistoryViewModel.fetchDesigner(designerId: reservation.designerUID)
                
                designerName = cmHistoryViewModel.designer.name
                designerRank = cmHistoryViewModel.designer.rank.rawValue
                designerShop = cmHistoryViewModel.designer.shop?.shopName ?? "프리랜서"
                reservationDate = SingleTonDateFormatter.sharedDateFommatter.changeDateString(transition: "MM월 dd일 HH시 mm분", from: reservation.reservationTime)
                for hairStyle in reservation.hairStyle {
                    styles.append(hairStyle.name)
                }
            }
        }
    }
}

#Preview {
    CMReservationInfoView(reservation: Reservation(clientUID: "", designerUID: "", reservationTime: "", hairStyle: [], isFinished: true))
}
