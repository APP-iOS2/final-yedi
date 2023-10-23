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
    @State private var isDesignerProfileActive: Bool = false
    
    
    
    
    var body: some View {
        NavigationStack {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("디자이너를 검색해보세요.", text: $viewModel.searchText)
                        .textFieldModifier()
                        .onSubmit {
                            viewModel.saveRecentSearch()
                        }
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }
                }
                
            }
            .padding()
            
            if viewModel.searchText.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("최근 검색어")
                            .foregroundStyle(Color.primaryLabel)
                        Spacer()
                        if !viewModel.recentSearches.isEmpty || !viewModel.recentDesigners.isEmpty {
                            Button(action: {
                                viewModel.removeAllRecentSearches()
                                viewModel.recentDesigners.removeAll()
                            }) {
                                Text("전체 삭제")
                                    .foregroundColor(Color.primaryLabel)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    ForEach(viewModel.recentSearches + viewModel.recentDesigners.map({ $0.name }), id: \.self) { search in
                        HStack {
                            Button {
                                if viewModel.recentSearches.contains(search) {
                                    viewModel.searchText = search
                                } else if let designer = viewModel.recentDesigners.first(where: { $0.name == search }) {
                                }
                            } label: {
                                if viewModel.recentSearches.contains(search) {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(15)
                                            .overlay {
                                                Circle().stroke(.gray, lineWidth: 1)
                                            }
                                        
                                        Text(search)
                                            .padding(.leading, 5)
                                        
                                        Spacer()
                                    }
                                    .foregroundStyle(Color.primaryLabel)
                                } else if let designer = viewModel.recentDesigners.first(where: { $0.name == search }) {
                                    HStack {
                                        if let imageURLString = designer.imageURLString {
                                            AsyncImage(url: URL(string: "\(imageURLString)")) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(maxWidth: 50, maxHeight: 50)
                                                    .clipShape(Circle())
                                            } placeholder: {
                                                Text(String(designer.name.first ?? " ").capitalized)
                                                    .font(.title3)
                                                    .fontWeight(.bold)
                                                    .frame(width: 50, height: 50)
                                                    .background(Circle().fill(Color.quaternarySystemFill))
                                                    .foregroundColor(Color.primaryLabel)
                                            }
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
                                    }
                                    .foregroundStyle(Color.primaryLabel)
                                }
                                
                            }
                            
                            Button(action: {
                                if viewModel.recentSearches.contains(search) {
                                    viewModel.removeRecentSearch(search)
                                } else if let index = viewModel.recentDesigners.firstIndex(where: { $0.name == search }) {
                                    // Handle the action when a recent designer's remove button is tapped
                                    // For example, you can remove the designer from the recentDesigners array.
                                    
                                    viewModel.recentDesigners.remove(at: index)
                                }
                            }, label: {
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
                                            AsyncImage(url: URL(string: "\(imageURLString)")) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(maxWidth: 50, maxHeight: 50)
                                                    .clipShape(Circle())
                                            } placeholder: {
                                                Text(String(designer.name.first ?? " ").capitalized)
                                                    .font(.title3)
                                                    .fontWeight(.bold)
                                                    .frame(width: 50, height: 50)
                                                    .background(Circle().fill(Color.quaternarySystemFill))
                                                    .foregroundColor(Color.primaryLabel)
                                            }
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
                                        .padding(.leading,5)
                                        Spacer()
                                    }
                                }
                                
                            }
                            
                            .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            // 여기에 원하는 동작을 추가합니다.
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
            
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.loadData()
            viewModel.loadRecentSearches()
            viewModel.loadRecentDesigners() 


        }
    }
}

#Preview {
    CMSearchView()
}
