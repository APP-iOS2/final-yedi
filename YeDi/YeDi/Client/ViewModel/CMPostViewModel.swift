//
//  CMPostViewModel.swift
//  YeDi
//
//  Created by Jaehui Yu on 2023/09/27.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class CMPostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    let dbRef = Firestore.firestore().collection("posts")
    
    func fetchPosts() async {
        do {
            let snapshot = try await dbRef.getDocuments()
            self.posts.removeAll()
            
            var tempPosts: [Post] = []
            
            for document in snapshot.documents {
                let id = document.documentID
                
                if let docData = document.data() as? [String:Any],
                   let designerID = docData["designerID"] as? String,
                   let location = docData["location"] as? String,
                   let title = docData["title"] as? String,
                   let description = docData["description"] as? String,
                   let photosDataArray = docData["photos"] as? [[String:Any]] {

                    // photos 필드 처리
                    var photos: [Photo] = []
                    
                    for photoData in photosDataArray {
                        if let photoID = photoData["id"] as? String,
                           let imageURLString = photoData["imageURL"] as? String {

                            // Photo 객체 생성 및 배열에 추가
                            let photo = Photo(id: photoID, imageURL: imageURLString)
                            photos.append(photo)
                        }
                    }
                    
                    let post = Post(id: id, designerID: designerID, location: location, title: title, description: description, photos: photos, comments: 0, timestamp: "")
                    
                    tempPosts.append(post)
                }
            }
            
            self.posts = tempPosts
            
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
}



