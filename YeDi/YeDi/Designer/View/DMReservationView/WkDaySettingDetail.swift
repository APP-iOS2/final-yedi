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
        }
        .navigationTitle("휴무일 설정")
    }
}

#Preview {
    NavigationStack {
        WkDaySettingDetail()
    }
}
