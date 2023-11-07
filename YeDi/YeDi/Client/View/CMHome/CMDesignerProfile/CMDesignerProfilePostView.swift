//
//  CMDesignerProfilePostView.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/21/23.
//

import SwiftUI

struct CMDesignerProfilePostView: View {
    var designer: Designer
    var designerPosts: [Post]
    
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 5
    
    var body: some View {
        if designerPosts.isEmpty {
            VStack {
                Text("업로드된 게시물이 없습니다.")
                    .foregroundStyle(Color.primaryLabel)
                    .padding()
            }
            .padding(.horizontal)
        } else {
            VStack {
                LazyVGrid(columns: gridItems, spacing: 1) {
                    ForEach(designerPosts.prefix(6), id: \.id) { post in
                        NavigationLink(destination: CMFeedDetailView(post: post)) {
                            ZStack(alignment: .topTrailing) {
                                AsnycCacheImage(url: post.photos[0].imageURL)
                                    .scaledToFill()
                                    .frame(width: imageDimension, height: imageDimension)
                                    .clipped()
                                
                                if post.photos.count > 1 { // 이미지가 여러 장인 경우에만 아이콘 표시
                                    Image(systemName: "square.on.square.fill")
                                        .foregroundColor(.white)
                                        .padding(10)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    CMDesignerProfilePostView()
//}
