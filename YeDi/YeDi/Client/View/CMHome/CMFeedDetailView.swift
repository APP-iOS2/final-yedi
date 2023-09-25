//
//  CMFeedDetailView.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/09/25.
//

import SwiftUI

struct CMFeedDetailView: View {
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let size = proxy.size
            CMFeedDetailContentView(safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            // TODO: Fetch Data
        }
    }
}

#Preview {
    CMFeedDetailView()
}
