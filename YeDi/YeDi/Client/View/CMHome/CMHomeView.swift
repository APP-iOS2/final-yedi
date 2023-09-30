//
//  CMHomeView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI

struct CMHomeView: View {
    @ObservedObject var postViewModel = CMPostViewModel()
    
    @State var selectedSegment: String = "회원님을 위한 추천"
    let segments: [String] = ["회원님을 위한 추천", "팔로잉"]
    
    var regions = ["서울", "경기", "인천"]
    @State private var selectedRegion = ""
    
    var body: some View {
        NavigationStack {
            HStack {
                ForEach(segments, id: \.self) { segment in
                    Button(action: {
                        selectedSegment = segment
                    }, label: {
                        VStack {
                            Text(segment)
                                .fontWeight(selectedSegment == segment ? .semibold : .medium)
                                .foregroundStyle(.black)
                            Rectangle()
                                .fill(selectedSegment == segment ? .black : .white)
                                .frame(width: 180, height: 3)
                        }
                    })
                }
            }
            .padding(.top)
 
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
                postViewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    CMHomeView()
}
