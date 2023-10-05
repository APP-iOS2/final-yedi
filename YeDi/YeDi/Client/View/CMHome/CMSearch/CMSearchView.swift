//
//  CMSearchView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMSearchView: View {
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            if searchQuery.isEmpty {
                CMSearchHistoryView()
            } else {
                CMSearchResultView()
            }
        }
        .searchable(text: $searchQuery, prompt: "디자이너를 검색해보세요.")
    }
}

#Preview {
    CMSearchView()
}
