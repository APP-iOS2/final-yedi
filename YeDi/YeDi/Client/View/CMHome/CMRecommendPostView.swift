//
//  CMRecommendPostView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/30.
//

import SwiftUI

struct CMRecommendPostView: View {
    @ObservedObject var postViewModel = CMPostViewModel()
    
    // 지역 구조체 하나 만들어주세요
    var regions = ["서울", "경기", "인천"]
    @State private var selectedRegion = ""
    
    var body: some View {
        NavigationStack {
            // MARK: Select Region
            HStack {
                Menu {
                    ForEach(regions, id: \.self) { region in
                        Button(action: { selectedRegion = region },
                               label: { Text(region)})
                    }
                } label: {
                    Label(selectedRegion.isEmpty ? "위치 선택" : selectedRegion, systemImage: "location")
                }
                .font(.title3)
                .foregroundStyle(.black)
                Spacer()
            }
            .padding()
            
            // MARK: Post
            ScrollView {
                LazyVStack(content: {
                    ForEach(postViewModel.posts, id: \.id) { post in
                        CMHomeCell(post: post)
                    }
                })
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("YeDi")
                        .font(.title)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    })
                }
            }
            .onAppear {
                Task {
                    await postViewModel.fetchPosts()
                }
            }
        }
    }
}

#Preview {
    CMRecommendPostView()
}
