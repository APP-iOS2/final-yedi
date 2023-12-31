//
//  CMReviewViewModel.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/06.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

/// 고객 리뷰 뷰 모델
class CMReviewViewModel: ObservableObject {
    // MARK: - Properties
    @Published var reviews: [Review] = []
    
    /// reviews 컬렉션 참조 변수
    let collectionRef = Firestore.firestore().collection("reviews")
    /// storage 참조 변수
    let storageRef = Storage.storage().reference()
    /// storage에 저장된 이미지 URL 배열
    var downloadURLs: [String] = []
    
    // MARK: - Methods
    /// 리뷰 패치 메서드
    @MainActor
    func fetchReview(userAuth: UserAuth) async {
        self.reviews = []
        
        do {
            if let clientId = userAuth.currentClientID {
                // 본인이 작성한 리뷰만 가져오기
                let docSnapshot = try await collectionRef.whereField("reviewer", isEqualTo: clientId).getDocuments()
                
                for doc in docSnapshot.documents {
                    if let review = try? doc.data(as: Review.self) {
                        self.reviews.append(review)
                    }
                }
                
                // 작성일을 기준으로 최신순 정렬
                self.reviews = self.reviews.sorted { $0.date > $1.date }
            }
        } catch {
            print("Error fetching client reviews: \(error)")
        }
    }
    
    /// 리뷰 업로드 메서드
    @MainActor
    func uploadReview(review: Review) async {
        self.downloadURLs = []
        
        for imageURLString in review.imageURLStrings {
            let temp = UUID().uuidString
            
            let localFile = URL(string: imageURLString)!
            
            // 로컬에 임시로 저장된 이미지를 Jpeg으로 압축 > storage에 업로드하고 URL 다운받기
            let uploadTask = URLSession.shared.dataTask(with: localFile) { data, response, error in
                guard let data = data else { return }
                
                let localJpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.2)
                if let localJpeg {
                    let uploadTask = self.storageRef.child("reviews/\(temp)").putData(localJpeg)
                    uploadTask.observe(.success) { StorageTaskSnapshot in
                        if StorageTaskSnapshot.status == .success {
                            Task {
                                do {
                                    var capturedReview = review
                                    
                                    let downloadURL = try await self.storageRef.child("reviews/\(temp)").downloadURL()
                                    self.downloadURLs.append(downloadURL.absoluteString)
                                    
                                    capturedReview.imageURLStrings = self.downloadURLs
                                    try self.collectionRef.document(capturedReview.id ?? "").setData(from: capturedReview)
                                } catch {
                                    print("Error uploading client reviews: \(error)")
                                }
                            }
                        }
                    }
                }
            }
            
            uploadTask.resume()
        }
    }
}

