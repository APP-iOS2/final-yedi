//
//  CMSegmentedControl.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

/// 고객 세그먼티드 컨트롤 뷰
struct CMSegmentedControl: View {
    // MARK: - Properties
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var selectedSegment: String = "찜한 게시물"
    
    let segments: [String] = ["찜한 게시물", "팔로잉", "리뷰"]
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - 세그먼티드 컨트롤
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
                                .frame(width: 120, height: 3)
                        }
                    })
                }
            }
            
            // MARK: - 선택된 세그먼트에 해당하는 뷰
            switch selectedSegment {
            case "찜한 게시물":
                CMLikePostListView()
            case "팔로잉":
                CMFollowingListView()
            case "리뷰":
                CMReviewListView()
            default:
                Text("")
            }
            
            Spacer()
        }
    }
}

#Preview {
    CMSegmentedControl()
        .environmentObject(UserAuth())
}
