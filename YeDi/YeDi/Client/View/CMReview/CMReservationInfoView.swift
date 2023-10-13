//
//  CMReservationInfoView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/13.
//

import SwiftUI

struct CMReservationInfoView: View {
    // MARK: - Properties
    @State private var designerName: String = "박채영 디자이너"
    @State private var style: String = "디자인 컷"
    @State private var reservationDate: String = "2023년 7월 11일 12:30"
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Group {
                VStack(alignment: .leading, spacing: 10) {
                    Text(designerName)
                        .font(.title3)
                    Text(style)
                        .font(.title)
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
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                .opacity(0.3)
        )
        .offset(y: -20)
    }
}

#Preview {
    CMReservationInfoView()
}
