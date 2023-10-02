//
//  CMChattingView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct CMMainChattingView: View {
    var body: some View {
        NavigationLink {
            ChatRoomView()
        } label: {
            Text("Go to ChatRoomView")
        }

    }
}

#Preview {
    CMMainChattingView()
}
