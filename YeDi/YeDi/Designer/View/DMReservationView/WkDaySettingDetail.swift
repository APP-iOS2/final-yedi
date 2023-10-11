//
//  WkDaySettingDetail.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/27.
//

import SwiftUI

struct WkDaySettingDetail: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomCalender()
            Divider().padding(.top)
            VStack(alignment: .leading, content: {
                Text("휴무일을 선택하세요")
                Text("선택한 날짜 : ")
            })
            .padding(.horizontal, 9)
            Spacer()
        }
        .navigationTitle("휴무일 설정")
    }
}

#Preview {
    NavigationStack {
        WkDaySettingDetail()
    }
}
