//
//  CMSearchView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CMSearchView: View {
    @ObservedObject var viewModel = CMSearchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .trailing) {
                TextField("디자이너를 검색해보세요.", text: $viewModel.searchText, onCommit: {
                    viewModel.saveRecentSearch()
                })
                .textFieldStyle(.roundedBorder)
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.saveRecentSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            
            if viewModel.searchText.isEmpty && viewModel.showRecentSearches {
                VStack(alignment: .leading) {
                    HStack {
                        Text("최근 검색어")
                        Spacer()
                        if !viewModel.recentSearches.isEmpty {
                            Button(action: {
                                viewModel.removeAllRecentSearches()
                            }) {
                                Text("전체 삭제")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    ForEach(viewModel.recentSearches, id: \.self) { search in
                        HStack {
                            Button {
                                viewModel.searchText = search
                                viewModel.performSearch()
                            } label: {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(15)
                                        .overlay {
                                            Circle().stroke(.gray, lineWidth: 1)
                                        }
                                    Text(search)
                                        .padding(.leading,5)
                                    Spacer()
                                }
                                .foregroundStyle(.black)
                            }
                            Button(action: {viewModel.removeRecentSearch(search)}, label: {
                                Image(systemName: "xmark")
                            })
                            .foregroundStyle(.gray)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7)
                    }
                    Spacer()
                    
                        .listStyle(.plain)
                }
            }
            
            if !viewModel.searchText.isEmpty {
                if viewModel.filteredDesignerCount > 0 {
                    HStack {
                        Text("디자이너 (\(viewModel.filteredDesignerCount)건)")
                        Spacer()
                    }
                    .padding(.horizontal)
                    Divider()
                    ForEach(viewModel.filterDesigners, id: \.id) { designer in
                        NavigationLink(destination: CMDesignerProfileView(designer: designer)) {
                            VStack {
                                HStack {
                                    Image(systemName: "person")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(15)
                                        .overlay {
                                            Circle().stroke(.gray, lineWidth: 1)
                                        }
                                    VStack(alignment: .leading) {
                                        Text(designer.name)
                                        Text("유칼립투스 헤어 | 단원구 선부동")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                    .padding(.leading,5)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                    .listStyle(.plain)
                } else {
                    Text("검색 결과가 없습니다.")
                }
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.loadRecentSearches()
            viewModel.loadData()
        }
    }
}

#Preview {
    CMSearchView()
}
