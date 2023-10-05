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
    var chattingVM : ChattingViewModel
    var userID: String
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
            .onChange(of: selectedItem) { newItem in ///사진앱에서 선택된 사진이 저장되고 Data로 형변환 되는 코드
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        ///형변환이 완료 되면 바로 사진 보내기
                        chattingVM.sendImageBubble(imageData: data, sender: userID)
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
        .background(.gray.opacity(0.4))
        //MARK: 색상 변경시 여기 수정
        .foregroundStyle(.primary)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

#Preview {
    ChatUtilityMenuView(chattingVM: ChattingViewModel(), userID: "customerUser1")
        .scaledToFit()
}
