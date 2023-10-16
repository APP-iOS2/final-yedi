//
//  DismissButton.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/16.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) var dismiss
    
    let color: Color?
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(color ?? .primary)
        }
    }
}
