//
//  DMReviewView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct DMReviewView: View {
    var body: some View {
        List(0...3, id: \.self) { index in
            NavigationLink {
                
            } label: {
                DMReviewCell()
            }
        }
        .listStyle(.plain)
        .menuIndicator(.hidden)
    }
}

#Preview {
    NavigationStack {
        DMReviewView()
    }
}
