//
//  WkDaySettingDetail.swift
//  YeDi
//
//  Created by 송성욱 on 2023/09/27.
//

import SwiftUI

struct WkDaySettingDetail: View {
    
    @Binding var showingRestDaySetting: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomCalender(showingRestDaySetting: $showingRestDaySetting)
        }
    }
}

#Preview {
    NavigationStack {
        WkDaySettingDetail(showingRestDaySetting: .constant(true))
    }
}
