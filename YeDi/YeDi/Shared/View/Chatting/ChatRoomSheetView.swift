//
//  ChatRoomSheetView.swift
//  YeDi
//
//  Created by 김성준 on 2023/10/06.
//

import SwiftUI

struct ChatRoomSheetView: View {
    @State var chatRoomId: String
    @EnvironmentObject var consultationViewModel: ConsultationViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                ChatRoomView(chatRoomId: chatRoomId)
            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {consultationViewModel.showChattingRoom = false}, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.primary)
                    })
                }
            })
            
            .onDisappear(perform: {
                consultationViewModel.showChattingRoom = false
            })
        }
    }
}

#Preview {
    NavigationStack {
        ChatRoomSheetView(chatRoomId: "6E4B79BB-E370-42C3-85FB-A3B93D09AFFE")
    }
}
