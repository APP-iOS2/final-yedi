//
//  TimeSettingDetail.swift
//  YeDi
//
//  Created by 송성욱 on 10/5/23.
//

import SwiftUI

struct TimeSettingDetail: View {
    
    let breakTime: [String] = []
    
    var body: some View {
        
        Text("따로 구현부분 테스트 중 / 피커로 고민")
        
        HStack {
            VStack {
                Button {
                    //토글 시 선택
                } label: {
                    Text("브레이크 타임 설정")
                }
                
                Button {
                    //토글 시 선택
                } label: {
                    Text("브레이크 타임 설정")
                }
                
                Button {
                    //토글 시 선택
                } label: {
                    Text("브레이크 타임 설정")
                }
            }
            .padding()
            
            VStack {
                Button {
                    //토글 시 선택
                } label: {
                    Text("브레이크 타임 설정")
                }
                
                Button {
                    //토글 시 선택
                } label: {
                    Text("브레이크 타임 설정")
                }
                
                Button {
                    //토글 시 선택
                } label: {
                    Text("브레이크 타임 설정")
                }
            }
            .padding()
        }
    }
}

#Preview {
    TimeSettingDetail()
}
