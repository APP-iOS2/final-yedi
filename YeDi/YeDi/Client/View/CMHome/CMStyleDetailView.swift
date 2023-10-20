//
//  CMStyleDetailView.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/15/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CMStyleDetailView: View {
    var designer: Designer
    @State private var designerPosts: [Post] = []
    
    let db = Firestore.firestore()

    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 2) - 5

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 5) {
                        ForEach(designerPosts, id: \.id) { post in
                            NavigationLink(destination: CMFeedDetailView(post: post)) {
                                DMAsyncImage(url: post.photos[0].imageURL)
                                    .scaledToFill()
                                    .frame(width: imageDimension, height: imageDimension)
                                    .clipped()
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(designer.name)의 Style")
        }
        .onAppear {
            fetchDesignerPosts()
        }
    }
    
    // Firestore에서 디자이너의 게시물 데이터를 가져오는 함수
    func fetchDesignerPosts() {
        db.collection("posts")
            .whereField("designerID", isEqualTo: designer.designerUID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching designer posts: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    designerPosts = documents.compactMap { document in
                        do {
                            let post = try document.data(as: Post.self)
                            return post
                        } catch {
                            print("Error decoding post: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
    }
}

#Preview {
    CMStyleDetailView(designer: Designer(name: "", email: "", phoneNumber: "", designerScore: 0, reviewCount: 0, followerCount: 0, skill: [], chatRooms: [], birthDate: "", gender: "", rank: .Designer, designerUID: ""))
}
