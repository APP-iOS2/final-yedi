//
//  CMHomeView.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI

struct CMHomeView: View {
    
    @State var selectedSegment: String = "회원님을 위한 추천"
    let segments: [String] = ["회원님을 위한 추천", "팔로잉"]
    
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
            
            switch selectedSegment {
            case "회원님을 위한 추천":
                CMRecommendPostView()
            case "팔로잉":
                CMFollowingPostView()
            default:
                Text("")
            }
        }
        .padding(.bottom, 1)
    }
}

#Preview {
    CMHomeView()
}
