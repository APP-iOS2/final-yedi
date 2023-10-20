//
//  DMProfileViewModel.swift
//  YeDi
//
//  Created by 박찬호 on 2023/10/05.
//

import Foundation
import Firebase
import UIKit
import FirebaseStorage

// MARK: - DMProfileViewModel
/// 디자이너 프로필에 대한 데이터를 관리하는 ViewModel 클래스입니다.
class DMProfileViewModel: ObservableObject {
    static let shared = DMProfileViewModel() // 싱글톤 인스턴스 생성
    var previousFollowerCount: Int = 0
    
    // MARK: - Published Properties
    /// 디자이너 정보를 저장하는 Published 변수입니다.
    @Published var designer = Designer(
        id: nil,
        name: "",
        email: "",
        phoneNumber: "",
        description: nil,
        designerScore: 0,
        reviewCount: 0,
        followerCount: 0,
        skill: [],
        chatRooms: [],
        birthDate: "",
        gender: "",
        rank: .Designer,
        designerUID: ""
    )
    
    /// 샵 정보를 저장하는 Published 변수입니다.
    @Published var shop = Shop(
        shopName: "",
        headAddress: "",
        subAddress: "",
        detailAddress: "",
        telNumber: nil,
        longitude: 0,
        latitude: 0,
        openingHour: "",
        closingHour: "",
        messangerLinkURL: nil,
        closedDays: []
    )
    
    // MARK: - Image Uploading
    /// Firebase Storage에서 디자이너 프로필 이미지를 업로드하는 함수입니다.
    func uploadDesignerProfileImage(userAuth: UserAuth, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let designerId = userAuth.currentDesignerID, let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "YeDi", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 변환 실패"])))
            return
        }
        let storageRef = Storage.storage().reference().child("profile_images/\(designerId).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
    
    // MARK: - Profile Updating
    /// 디자이너 프로필을 업데이트하는 비동기 함수입니다.
    func updateDesignerProfile(userAuth: UserAuth, designer: Designer) async -> Bool {
        let designerRef = Firestore.firestore().collection("designers").document(designer.id ?? "")
        do {
            try await designerRef.setData([
                "id": designer.id ?? "",
                "name": designer.name,
                "email": designer.email ,
                "imageURLString": designer.imageURLString ?? "",
                "phoneNumber": designer.phoneNumber ,
                "description": designer.description ?? "",
                "designerScore": designer.designerScore,
                "reviewCount": designer.reviewCount,
                "followerCount": designer.followerCount,
                "skill": designer.skill,
                "chatRooms": designer.chatRooms,
                "birthDate": designer.birthDate,
                "gender": designer.gender,
                "rank": designer.rank.rawValue,
                "designerUID": designer.designerUID
            ], merge: true)
            return true
        } catch {
            print("Firestore 데이터 저장 에러:", error)
            return false
        }
    }
    
    // MARK: - Data Fetching
    /// 디자이너 프로필 정보를 Firestore에서 가져오는 비동기 함수입니다.
    func fetchDesignerProfile(userAuth: UserAuth) async {
        let db = Firestore.firestore()
        if let designerId = userAuth.currentDesignerID {
            let docRef = db.collection("designers").document(designerId)
            do {
                let document = try await docRef.getDocument()
                if let designerData = document.data() {
                    if let rankString = designerData["rank"] as? String, let rank = Rank(rawValue: rankString) {
                        DispatchQueue.main.async {
                            self.designer = Designer(
                                id: designerData["id"] as? String,
                                name: designerData["name"] as! String,
                                email: designerData["email"] as! String,
                                imageURLString: designerData["imageURLString"] as? String ?? "",
                                phoneNumber: designerData["phoneNumber"] as! String,
                                description: designerData["description"] as? String,
                                designerScore: designerData["designerScore"] as! Double,
                                reviewCount: designerData["reviewCount"] as! Int,
                                followerCount: designerData["followerCount"] as! Int,
                                skill: designerData["skill"] as! [String],
                                chatRooms: designerData["chatRooms"] as! [String],
                                birthDate: designerData["birthDate"] as! String,
                                gender: designerData["gender"] as! String,
                                rank: rank,
                                designerUID: designerData["designerUID"] as! String
                            )

                            if let shopData = designerData as? [String: Any] {
                                self.shop = Shop(
                                    shopName: shopData["shopName"] as? String ?? "",
                                    headAddress: shopData["headAddress"] as? String ?? "",
                                    subAddress: shopData["subAddress"] as? String ?? "",
                                    detailAddress: shopData["detailAddress"] as? String ?? "",
                                    telNumber: shopData["telNumber"] as? String,
                                    longitude: shopData["longitude"] as? Double ?? 0.0,
                                    latitude: shopData["latitude"] as? Double ?? 0.0,
                                    openingHour: shopData["openingHour"] as? String ?? "",
                                    closingHour: shopData["closingHour"] as? String ?? "",
                                    messangerLinkURL: shopData["messangerLinkURL"] as? [String: String],
                                    closedDays: shopData["closedDays"] as? [String] ?? []
                                )
                            }
                        }
                    }
                }
            } catch {
                print("Error fetching designer data: \(error)")
            }
        }
    }
    
    /// 샵 정보를 Firestore에 업데이트하는 비동기 함수입니다.
    func updateShopInfo(userAuth: UserAuth, shop: Shop) async {
        let db = Firestore.firestore()
        if let designerId = userAuth.currentDesignerID {
            let docRef = db.collection("designers").document(designerId).collection("shop").document("shopInfo")
            
            let shopData: [String: Any] = [
                "shopName": shop.shopName,
                "headAddress": shop.headAddress,
                "subAddress": shop.subAddress,
                "detailAddress": shop.detailAddress,
                "telNumber": shop.telNumber ?? NSNull(),
                "longitude": shop.longitude ?? 0.0,
                "latitude": shop.latitude ?? 0.0,
                "openingHour": shop.openingHour,
                "closingHour": shop.closingHour,
                "messangerLinkURL": shop.messangerLinkURL ?? NSNull(),
                "closedDays": shop.closedDays
            ]
            
            do {
                try await docRef.setData(shopData)
                print("Shop info successfully updated.")
            } catch {
                print("Error updating shop data: \(error)")
            }
        }
    }
    
    func fetchShopInfo(userAuth: UserAuth) async {
        let db = Firestore.firestore()
        if let designerId = userAuth.currentDesignerID {
            let shopCollectionRef = db.collection("designers").document(designerId).collection("shop")
            do {
                let shopDocuments = try await shopCollectionRef.getDocuments()
                if let firstShopDocument = shopDocuments.documents.first {
                    let shopData = firstShopDocument.data()
                    DispatchQueue.main.async {
                        self.shop = Shop(
                            shopName: shopData["shopName"] as? String ?? "",
                            headAddress: shopData["headAddress"] as! String ,
                            subAddress: shopData["subAddress"] as? String ?? "",
                            detailAddress: shopData["detailAddress"] as? String ?? "",
                            telNumber: shopData["telNumber"] as? String,
                            longitude: shopData["longitude"] as? Double ?? 0.0,
                            latitude: shopData["latitude"] as? Double ?? 0.0,
                            openingHour: shopData["openingHour"] as? String ?? "",
                            closingHour: shopData["closingHour"] as? String ?? "",
                            messangerLinkURL: shopData["messangerLinkURL"] as? [String: String],
                            closedDays: shopData["closedDays"] as? [String] ?? []
                        )
                    }
                } else {
                    print("Error: Document data is nil")  // 디버그 코드
                }
            } catch {
                print("Error fetching shop data: \(error)")
            }
        } else {
            print("Error: designerId is nil")  // 디버그 코드
        }
    }

    // MARK: - Follower Updating
    /// 해당 디자이너를 팔로워 갯수 가져오는 함수
    func updateFollowerCountForDesigner(designerUID: String) async {
        print("Received designerUID: \(designerUID)")
        guard !designerUID.isEmpty else {
            print("UID가 유효하지 않습니다.")
            return
        }
        
        let followingCollection = Firestore.firestore().collection("following")
        let designerRef = Firestore.firestore().collection("designers").document(designerUID)
        
        do {
            let followingDocuments = try await followingCollection.whereField("uids", arrayContains: designerUID).getDocuments()
            
            let validDocuments = followingDocuments.documents
            if !validDocuments.isEmpty {
                let followerCountFromFirebase = validDocuments.count
                
                if followerCountFromFirebase != self.previousFollowerCount {
                    try await designerRef.updateData(["followerCount": followerCountFromFirebase])
                    self.designer.followerCount = followerCountFromFirebase
                    print("팔로워 수가 \(followerCountFromFirebase)로 업데이트되었습니다.")
                    self.previousFollowerCount = followerCountFromFirebase
                } else {
                    print("팔로워 수가 변경되지 않았습니다.")
                }
            } else {
                print("팔로우한 디자이너를 찾지 못했습니다.")
            }
        } catch let error {
            print("Error updating follower count: \(error.localizedDescription)")
        }
    }
}
