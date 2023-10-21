//
//  CMDesignerProfileSegmentedView.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/21/23.
//

import SwiftUI

struct CMDesignerProfileSegmentedView: View {
    var designer: Designer
    var designerPosts: [Post]
    var reviews: [Review]
    var keywords: [String]
    var keywordCount: [(String, Int)]
    
    @State private var selectedSegment: String = "게시물"
    let segments: [String] = ["게시물", "리뷰"]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(segments, id: \.self) { segment in
                    Button(action: {
                        selectedSegment = segment
                    }, label: {
                        VStack {
                            Text(segment)
                                .fontWeight(selectedSegment == segment ? .semibold : .medium)
                                .foregroundStyle(Color(UIColor.label))
                            Rectangle()
                                .fill(selectedSegment == segment ? Color.primaryLabel : .gray6)
                                .frame(width: 180, height: 3)
                        }
                    })
                }
            }
            
            switch selectedSegment {
            case "게시물":
                CMDesignerProfilePostView(designer: designer, designerPosts: designerPosts)
            case "리뷰":
                CMDesignerProfileReviewView(designer: designer, reviews: reviews, keywords: keywords, keywordCount: keywordCount)
            default:
                Text("")
            }
            
            Spacer()
        }
    }
}

//#Preview {
//    CMDesignerProfileSegmentedView()
//}
