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
        VStack {
            ChatRoomView(chatRoomId: chatRoomId)
        }
        .onDisappear(perform: {
            consultationViewModel.showChattingRoom = false
        })
    }
}

#Preview {
    ChatRoomSheetView(chatRoomId: "6E4B79BB-E370-42C3-85FB-A3B93D09AFFE")
}
