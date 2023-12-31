//
//  ChatRoomSheetView.swift
//  YeDi
//
//  Created by 김성준 on 2023/10/06.
//

import SwiftUI

struct ChatRoomSheetView: View {
    @EnvironmentObject var consultationViewModel: ConsultationViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var chatRoomId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                ChatRoomView(chatRoomId: chatRoomId)
                    .onDisappear {
                        consultationViewModel.showChattingRoom = false
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatRoomSheetView(chatRoomId: "6E4B79BB-E370-42C3-85FB-A3B93D09AFFE")
    }
}
