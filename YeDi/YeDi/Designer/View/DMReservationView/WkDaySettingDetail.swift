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
            Text("이번달 휴무일을 선택해주세요.")
            CustomCalender()
            Divider().padding(.top)
            VStack(alignment: .leading, content: {
                Text("고정 휴무일을 선택해주세요")
               
            })
            Spacer()
        }
        .navigationTitle("휴무일 설정")
        .padding(.horizontal, 9)
    }
}

#Preview {
    NavigationStack {
        WkDaySettingDetail()
    }
}
