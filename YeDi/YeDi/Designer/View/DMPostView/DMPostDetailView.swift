//
//  PostDetailView.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/26.
//

import SwiftUI

struct DMPostDetailView: View {
    let post: Post  // 선택된 게시글

    var body: some View {
        // 게시글 제목 출력
        Text(post.title)
    }
}

#Preview {
    DMPostDetailView(post: Post(id: "1", designerID: "원장루디", location: "예디샵 홍대지점", title: "물결 펌", description: "This is post 1", photos: [Photo(id: "p1", imageURL: "https://i.pinimg.com/564x/1a/cb/ac/1acbacd1cbc2a1510c629305e71b9847.jpg")], comments: 5, timestamp: "1시간 전"))
}
