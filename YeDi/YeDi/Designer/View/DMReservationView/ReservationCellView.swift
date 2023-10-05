//
//  ReservationCellView.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/26.
//

import SwiftUI

struct ReservationCellView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: .infinity, height: 100)
                .foregroundColor(.white)
                .shadow(radius: 4)
            VStack(alignment: .leading) {
                Text("김고객")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer().frame(height: 10)
                Text("가일펌, 스페셜 두피케어")
                    .font(.system(size: 20))
            }
        }
    }
}

#Preview {
    ReservationCellView()
}
