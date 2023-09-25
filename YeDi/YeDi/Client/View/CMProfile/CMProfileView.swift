//
//  CMProfileView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct CMProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("@@@님")
                        Text("오늘도 빛나는 하루 보내세요")
                    }
                    .font(.system(size: 20, weight: .bold))
                    Spacer()
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                }
                .padding()
                
                Text("정보 수정")
                    .font(.system(size: 15))
                    .frame(width: 350, height: 35)
                    .border(.gray)
                    .padding(.bottom, 40)
                
                CMSegmentedControl()
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CMNotificationView()
                } label: {
                    Image(systemName: "bell")
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CMSettingsView()
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CMProfileView()
    }
}
