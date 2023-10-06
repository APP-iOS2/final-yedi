//
//  Review.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/06.
//

import Foundation
import FirebaseFirestoreSwift

struct Review: Identifiable, Codable {
    /// 리뷰 ID
    @DocumentID var id: String?
    /// 작성자 ID
    let reviewer: String
    /// 리뷰 작성일
    let date: String
    /// 리뷰 키워드 평가
    let keywordReviews: [Keyword]
    /// 시술 별점 평가
    let designerScore: Int
    /// 리뷰 내용
    let content: String
    /// 시술 이미지
    let imageURLStrings: [String]

    /// 예약 ID
    let reservationId: String
    /// 시술 내용
    let style: String
    /// 디자이너 ID
    let designer: String
}
