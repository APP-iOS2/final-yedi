//
//  CMUpcomingReservationView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/26.
//

import SwiftUI

struct CMUpcomingReservationView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("아직 예약이 없습니다")
                .fontWeight(.bold)
            Button {
                //
            } label: {
                Text("내 주변 디자이너 찾아보기")
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            Spacer()
        }
    }
}

#Preview {
    CMUpcomingReservationView()
}
