//
//  ChatUtilityMenuView.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import SwiftUI
import PhotosUI

struct ChatUtilityMenuView: View {
    @State private var selectedItem: PhotosPickerItem?
    var body: some View {
        HStack {
            Spacer()
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                VStack {
                    VStack{
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text("사진")
                    }
                }
            }
            
            Spacer()
            
            Button(action: {}, label: {
                VStack{
                    Image(systemName: "clock.badge.checkmark.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("바로예약")
                }
            })
            
            Spacer()
        }
        .padding()
        .background(content: {
            Rectangle()
                .stroke()
        })
        //MARK: 색상 변경시 여기 수정
        .foregroundStyle(.primary)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

#Preview {
    ChatUtilityMenuView()
        .scaledToFit()
}
