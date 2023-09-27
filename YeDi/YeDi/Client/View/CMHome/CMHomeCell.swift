//
//  CMHomeCell.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/25.
//

import SwiftUI

struct CMHomeCell: View {
    var post: Post
    @State private var selectedImageIndex: Int = 0
    @State private var isLiked: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(post.designerID)
                    Text(post.location)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Button(action: {}, label: {
                    Text("팔로잉")
                })
                .buttonStyle(.borderedProminent)
                .tint(.black)
                
            }
            .padding(.horizontal)
            
            if post.photos.count == 1 {
                // 이미지가 한 장인 경우
                AsyncImage(url: post.photos[0].imageURL, placeholder: Image(systemName: "photo"))
                    .frame(width: 360, height: 360)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            } else {
                // 이미지가 여러 장인 경우
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<post.photos.count, id: \.self) { index in
                        AsyncImage(url: post.photos[index].imageURL, placeholder: Image(systemName: "photo"))
                            .frame(width: 360, height: 360)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 360)
                .padding(.horizontal)
            }
            
            HStack {
                Button(action: {isLiked.toggle()}, label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(isLiked ? .red : .black)
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack {
                        Spacer()
                        Text("상담하기")
                        Spacer()
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }
            .padding()
        }
    }
}

#Preview {
    CMHomeCell(post: Post(id: "1", designerID: "디자이너 이름", location: "디자이너 근무 지점", title: "게시물 제목", description: "게시물 설명", photos: [Photo(id: "1", imageURL: "https://example.com/image1.jpg"), Photo(id: "2", imageURL: "https://example.com/image2.jpg")], comments: 0, timestamp: "타임스탬프"))
}
