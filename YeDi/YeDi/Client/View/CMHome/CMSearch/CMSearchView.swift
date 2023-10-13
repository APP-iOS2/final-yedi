//
//  CMSearchView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMSearchView: View {
    @State private var searchQuery: String = ""
    @ObservedObject var viewModel = CMSearchViewModel()
    
    var body: some View {
        NavigationStack {
            if searchQuery.isEmpty {
                CMSearchHistoryView()
            } else {
                CMSearchResultView(designers: viewModel.designers)
            }
        }
        .searchable(text: $searchQuery, prompt: "디자이너를 검색해보세요.")
        .onAppear {
            viewModel.searchDesigners(query: searchQuery)
        }
    }
}

#Preview {
    CMSearchView()
}
