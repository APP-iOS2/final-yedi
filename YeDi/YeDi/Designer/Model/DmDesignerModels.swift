//
//  DmDesignerModels.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/25.
//

import FirebaseFirestoreSwift  // Firestore를 사용
import Foundation
import SwiftUI

// 샵에 대한 정보를 담는 구조체
struct Shop: Codable {
    @DocumentID var id: String?
    
    var shopName: String  // 샵 이름
    /// [시] 만 담고 있는 주소
    var headAddress: String
    /// [동 or 도로명 주소] 만 담고 있는 주소
    var subAddress: String
    /// [건물 번호,명 and 도로 번호] 만 담고 있는 주소
    var detailAddress: String
    /// 샵 전화번호
    var telNumber: String?
    /// 위도
    var longitude: Double?
    /// 경도
    var latitude: Double?
    /// 시작시간
    var openingHour: String
    /// 마감시간
    var closingHour: String
    /// 샵 메신저[카카오톡 채널] 링크 주소
    var messangerLinkURL: [String: String]? // ["KakaoTalk" : "URL"]
    /// 휴무일 정보
    var closedDays: [String]
    
}

// 디자이너에 대한 정보를 담는 구조체
struct Designer: Codable {
    @DocumentID var id: String?  // Firestore 문서 ID
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
    /// 디자이너 생년월일
    var birthDate: String
    /// 디자이너 성별
    var gender: String
    /// 디자이너 직급
    var rank: Rank
    /// 디자이너 고유 ID
    var designerUID: String
    /// 디자이너 샵 정보
    var shop: Shop?
}

/// 직급
enum Rank: String, CaseIterable, Codable {
    case Owner = "원장"
    case Principal = "실장"
    case Designer = "디자이너"
    case Intern = "인턴"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        switch rawValue {
        case "원장":
            self = .Owner
        case "디자이너":
            self = .Designer
        case "실장":
            self = .Principal
        case "인턴":
            self = .Intern
        default:
            self = .Owner // 기본값 설정
        }
    }
}

/// 사진에 대한 정보를 담는 구조체
struct Photo: Identifiable, Codable {
    var id: String  // 사진의 고유 ID
    var imageURL: String  // 사진의 URL
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "imageURL": imageURL
        ]
    }
}

struct Post: Codable {
    @DocumentID var id: String?  // Firestore 문서 ID
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
    // var styles: [Style]
    /// 좋아요 수
    var comments: Int
    /// 게시 시간 (타임스탬프)
    var timestamp: String  // 실제로는 Timestamp 타입 사용해야할거같네요? - ChanHo
    /// 헤어 디자인 카테고리
    var hairCategory: HairCategory
    ///게시물 시술 가격
    var price: Int
}

// 헤어 디자인 카테고리를 정의하는 Enum
enum HairCategory: String, Codable {
    case Cut = "커트"
    case Perm = "펌"
    case Dying = "염색"
    case Else = "기타 시술"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        switch rawValue {
        case "커트":
            self = .Cut
        case "펌":
            self = .Perm
        case "염색":
            self = .Dying
        case "기타 시술":
            self = .Else
        default:
            self = .Else // 기본값 설정
        }
    }
    
    // 각 카테고리에 대한 색상을 반환하는 메소드
    var color: Color {
        switch self {
        case .Cut:
            return Color.red
        case .Perm:
            return Color.blue
        case .Dying:
            return Color.purple
        case .Else:
            return Color.gray
        }
    }
}

/// - 휴무일 설정 구조체
struct ClosedDay: Identifiable, Codable {
    /// Firestore 문서 ID
    var id: String
    /// designerUid
    var designerUid: String
    /// 설정한 휴무일
    var closedDay: [String]
}

/// - Recess Structure
struct BreakTime: Codable {
    /// firebase 문서 ID
    var id: String
    /// designerUid
    var designerUid: String
    /// 설정한 휴게 시간
    var selectedTime: [String]
}
