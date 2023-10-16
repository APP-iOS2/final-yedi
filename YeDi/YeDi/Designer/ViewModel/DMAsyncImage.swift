//
//  AsyncImage.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/25.
//

import SwiftUI
import Combine
import Foundation

// MARK: - 이미지 로더 클래스
class ImageLoader: ObservableObject {
    // MARK: - Published 변수
    @Published var image: UIImage?
    
    // MARK: - 싱글톤 NS캐시 변수
    private let imageCache = NSCacheManager.sharedNSCache.memoryCache
    
    // MARK: - URLSession 관리 변수
    var cancellable: AnyCancellable?
    
    // MARK: - 이미지 로딩 메소드
    func load(from url: String) {
        // 메모리 캐시에서 이미지를 먼저 검색
        
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            self.image = cachedImage
            return
        }
        
        // URL 유효성 검사
        guard let imageURL = URL(string: url) else {
            return
        }
        
        // URLSession을 이용하여 네트워크에서 이미지 로딩
        cancellable = URLSession.shared.dataTaskPublisher(for: imageURL)
            .map { UIImage(data: $0.data) }  // 받은 데이터를 UIImage로 변환
            .replaceError(with: nil)  // 에러 처리
            .receive(on: DispatchQueue.main)  // 요청 완료 후 메인 스레드에서 처리
            .sink { [weak self] in
                // 로드된 이미지를 캐시에 저장
                if let image = $0 {
                    DispatchQueue.global(qos: .default).async {
                        self?.imageCache.setObject(image, forKey: url as NSString)
                    }
                }
                // 이미지를 화면에 표시
                self?.image = $0
            }
    }
}

struct DMAsyncImage: View {
    @ObservedObject var imageLoader = ImageLoader()
    
    // MARK: - 플레이스홀더 이미지
    var placeholder: Image
    
    // MARK: - 초기화 메소드
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        imageLoader.load(from: url)
    }
    
    // MARK: - 뷰 본문
    var body: some View {
        // 이미지가 로드되면 표시, 그렇지 않으면 플레이스홀더 표시
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
                .resizable()
        }
    }
}
