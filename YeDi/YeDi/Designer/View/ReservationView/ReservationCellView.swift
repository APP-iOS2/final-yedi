//
//  ReservationCellView.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/26.
//

import SwiftUI

struct ReservationCellView: View {
    var body: some View {
        NavigationLink {
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 300, height: 100)
                    .foregroundColor(.gray)
                    .shadow(radius: 4)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("회원명")
                    }
                    Spacer().frame(width: 70)
                    VStack {
                        Text("예약 날짜")
                        Text("예약 시간")
                    }
                }
            }
        }
    }
}

#Preview {
    ReservationCellView()
}
