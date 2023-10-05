//
//  DMProfileViewModel.swift
//  YeDi
//
//  Created by 박찬호 on 2023/10/05.
//

import Foundation
import Firebase  // Firebase 라이브러리 임포트

// 디자이너 프로필에 대한 데이터를 관리하는 ViewModel
class DMProfileViewModel: ObservableObject {
    
    // 디자이너 정보를 저장하는 Published 변수
    @Published var designer = Designer(
        id: nil, name: "", email: "", phoneNumber: "", description: nil,
        designerScore: 0, reviewCount: 0, followerCount: 0, skill: [], chatRooms: []
    )
    
    // 샵 정보를 저장하는 Published 변수
    @Published var shop: Shop = Shop(
        shopName: "", headAddress: "", subAddress: "", detailAddress: "",
        telNumber: nil, longitude: 0, latitude: 0, openingHour: "", closingHour: "", messangerLinkURL: nil
    )
    
    // 디자이너 프로필 정보를 Firestore에서 가져오는 비동기 함수
    func fetchDesignerProfile(userAuth: UserAuth) async {
        let db = Firestore.firestore()  // Firestore 인스턴스 생성
        
        // 현재 로그인한 디자이너의 ID가 있을 경우
        if let designerId = userAuth.currentDesignerID {
            let docRef = db.collection("designers").document(designerId)  // 해당 디자이너 문서의 레퍼런스
            
            do {
                let document = try await docRef.getDocument()  // 문서 가져오기
                // 문서 데이터를 Designer 타입으로 변환하여 저장
                if let designerData = try? document.data(as: Designer.self) {
                    self.designer = designerData  // 가져온 데이터로 designer 변수 업데이트
                }
            } catch {
                // 데이터를 가져오는 도중 에러가 발생한 경우
                print("Error fetching designer data: \(error)")
            }
        }
        
        // TODO: 샵 정보를 가져오는 로직을 추가해야 함
    }
}
