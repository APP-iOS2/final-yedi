//
//  CMSegmentedControl.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMSegmentedControl: View {
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var reviewViewModel: CMReviewViewModel
    
    @State private var selectedSegment: String = "찜한 게시물"
    let profileViewModel: CMProfileViewModel
    let segments: [String] = ["찜한 게시물", "팔로잉", "리뷰"]
    
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
                                .foregroundStyle(.black)
                            Rectangle()
                                .fill(selectedSegment == segment ? .black : .white)
                                .frame(width: 120, height: 3)
                        }
                    })
                }
            }
            
            switch selectedSegment {
            case "찜한 게시물":
                CMLikePostListView()
            case "팔로잉":
                CMFollowingListView(profileViewModel: profileViewModel)
            case "리뷰":
                CMReviewListView()
                    .environmentObject(reviewViewModel)
            default:
                Text("")
            }
        }
    }
}

#Preview {
    CMSegmentedControl(profileViewModel: CMProfileViewModel())
        .environmentObject(CMReviewViewModel())
}
