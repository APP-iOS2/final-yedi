//
//  CMSearchView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CMSearchView: View {
    @ObservedObject var viewModel = CMSearchViewModel()
    
    var body: some View {
        NavigationStack {
            SearchTextFieldView(viewModel: viewModel)
            SearchRecentItemView(viewModel: viewModel)
            SearchResultView(viewModel: viewModel)
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.loadData()
            viewModel.loadRecentItems()
        }
    }
}

// MARK: - TextField
private struct SearchTextFieldView: View {
    @ObservedObject var viewModel: CMSearchViewModel
    
    fileprivate init(viewModel: CMSearchViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                TextField("디자이너를 검색해보세요.", text: $viewModel.searchText)
                    .textFieldModifier()
                    .onSubmit {
                        viewModel.saveRecentSearch()
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        .padding()
    }
}

// MARK: - RecentItem
private struct SearchRecentItemView: View {
    @ObservedObject var viewModel: CMSearchViewModel
    
    fileprivate init(viewModel: CMSearchViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        if viewModel.searchText.isEmpty {
            VStack(alignment: .leading) {
                HStack {
                    Text("최근 검색")
                        .foregroundStyle(Color.primaryLabel)
                    Spacer()
                    if !viewModel.recentItems.isEmpty {
                        Button {
                            viewModel.removeAllRecentItems()
                            viewModel.recentDesigners.removeAll()
                        } label: {
                            Text("전체 삭제")
                                .foregroundColor(Color.primaryLabel)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                ForEach(viewModel.recentItems) { item in
                    HStack {
                        if item.isSearch {
                            HStack {
                                Button {
                                    viewModel.searchText = item.text
                                } label: {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(15)
                                            .overlay {
                                                Circle().stroke(.gray, lineWidth: 1)
                                            }
                                        
                                        Text(item.text)
                                            .padding(.leading, 5)
                                    }
                                    .foregroundStyle(Color.primaryLabel)
                                }
                                Spacer()
                                Button {
                                    viewModel.removeRecentSearch(item.text)
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .foregroundStyle(.gray)
                            }
                        } else if let designer = item.designer {
                            NavigationLink(destination: CMDesignerProfileView(designer: designer)) {
                                HStack {
                                    if let imageURLString = designer.imageURLString {
                                        AsnycCacheImage(url: imageURLString)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: 50, maxHeight: 50)
                                            .clipShape(Circle())
                                    } else {
                                        Text(String(designer.name.first ?? " ").capitalized)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .frame(width: 50, height: 50)
                                            .background(Circle().fill(Color.quaternarySystemFill))
                                            .foregroundColor(Color.primaryLabel)
                                        
                                    }
                                    VStack(alignment: .leading) {
                                        Text(designer.name)
                                            .foregroundStyle(Color.primaryLabel)
                                        if let shop = designer.shop {
                                            Text(shop.shopName)
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                    Spacer()
                                    Button {
                                        viewModel.removeRecentDesigner(item.designer!)
                                    } label: {
                                        Image(systemName: "xmark")
                                    }
                                    .foregroundStyle(.gray)
                                }
                                .foregroundStyle(Color.primaryLabel)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 7)
                }
                Spacer()
                    .listStyle(.plain)
            }
        }
    }
}

// MARK: - Result
private struct SearchResultView: View {
    @ObservedObject var viewModel: CMSearchViewModel
    
    fileprivate init(viewModel: CMSearchViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        if !viewModel.searchText.isEmpty {
            if viewModel.filteredDesignerCount > 0 {
                HStack {
                    Text("디자이너 (\(viewModel.filteredDesignerCount)건)")
                        .foregroundStyle(Color.primaryLabel)
                    Spacer()
                }
                .padding(.horizontal)
                Divider()
                ScrollView {
                    ForEach(viewModel.filterDesigners, id: \.id) { designer in
                        NavigationLink(destination: CMDesignerProfileView(designer: designer)) {
                            VStack {
                                HStack {
                                    if let imageURLString = designer.imageURLString {
                                        AsnycCacheImage(url: imageURLString)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: 50, maxHeight: 50)
                                            .clipShape(Circle())
                                    } else {
                                        Text(String(designer.name.first ?? " ").capitalized)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .frame(width: 50, height: 50)
                                            .background(Circle().fill(Color.quaternarySystemFill))
                                            .foregroundColor(Color.primaryLabel)
                                        
                                    }
                                    VStack(alignment: .leading) {
                                        Text(designer.name)
                                            .foregroundStyle(Color.primaryLabel)
                                        if let shop = designer.shop {
                                            Text(shop.shopName)
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                    .padding(.leading, 5)
                                    Spacer()
                                }
                            }
                        }
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    viewModel.addRecentDesigner(designer)
                                }
                        )
                    }
                    .padding()
                    .listStyle(.plain)
                }
            } else {
                Text("검색 결과가 없습니다.")
                    .foregroundStyle(Color.primaryLabel)
            }
        }
    }
}

#Preview {
    CMSearchView()
}
