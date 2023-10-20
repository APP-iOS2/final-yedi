//
//  UnReadCountCircle.swift
//  YeDi
//
//  Created by 김성준 on 10/20/23.
//

import SwiftUI

struct UnReadCountCircle: View {
    @State var unreadCount: Int
    
    var drawCount: Int {
        if unreadCount > 999 {
            return 999
        } else {
            return unreadCount
        }
    }
    
    var body: some View {
        Circle()
            .foregroundStyle(.red)
            .overlay {
                Text("\(drawCount)")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            .frame(width: 25, height: 25)
    }
}

#Preview {
    UnReadCountCircle(unreadCount: 999)
}
