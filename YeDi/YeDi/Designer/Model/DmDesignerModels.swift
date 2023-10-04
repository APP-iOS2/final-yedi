//
//  DmDesignerModels.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/25.
//

import Foundation

struct Shop {
var shopName: String
/// [시] 만 담고 있는 주소
var headAddress: String
/// [동 or 도로명 주소] 만 담고 있는 주소
var subAddress: String
/// [건물 번호,명 and 도로 번호] 만 담고 있는 주소
var detailAddress: String
/// 샵 전화번호
var telNumber: String?
/// 위도
var langitude: Double
/// 경도
var latitude: Double
/// 시작시간
var openingHour: String
/// 마감시간
var closingHour: String
/// 샵 메신저[카카오톡 채널] 링크 주소
var messangerLinkURL: [String: String]? // ["KakaoTalk" : "URL"]
}

struct Designer {
/// ID
var id: String
/// 디자이너 이름
var name: String
/// 디자이너 이메일
var email: String
/// 프로필 사진
var imageURLString: String?
/// 휴대폰 번호
var phoneNumber: String
/// 소개글
var description: String?
/// 평점
var designerScore: Double
/// 리뷰개수
var reviewCount: Int
/// 팔로워 인원수
var followerCount: Int
/// 스킬
var skill: [String] // 디자이너가 적은 스킬을 태그화 시키기 ?? 어렵긴하겠다.
///채팅방의 아이디
var chatRooms: [String]
}

/// 직급
enum Rank {
/// 원장
case Owner
/// 실장
case Principal
/// 디자이너
case Designer
/// 인턴
case Intern
}

struct Photo {
/// 사진의 고유 ID
var id: String
var imageURL : String
}

struct Post {
    /// 게시물 ID
    var id: String
    /// 디자이너 ID
    var designerID: String
    /// 디자이너 샵 정보
    var location: String
    /// 게시물 제목
    var title: String
    /// 게시물 설명
    var description: String?
    /// 게시물에 포함된 사진들 (Photo 모델 배열)
    var photos: [Photo]
    /// 관련 스타일
//    var styles: [Style]
    /// 좋아요 수
    var comments: Int
    /// 게시 시간 (타임스탬프)
    var timestamp: String

}
