//
//  AsyncImage.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/25.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private let imageCache = NSCacheManager.sharedNSCache.memoryCache
    
    var cancellable: AnyCancellable?
    
    // MARK: - 이미지 로딩 메소드
    func load(from url: String) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let imageURL = URL(string: url) else {
            return
        }
        
        // URLSession을 이용하여 네트워크에서 이미지 로딩
        cancellable = URLSession.shared.dataTaskPublisher(for: imageURL)
            .map { UIImage(data: $0.data) }  // 받은 데이터를 UIImage로 변환
            .replaceError(with: nil)  // 에러 처리
            .receive(on: DispatchQueue.main)
            .sink { [self] in
                if let image = $0 {
                    DispatchQueue.global(qos: .default).async {
                        let imageCache = self.imageCache
                        imageCache.setObject(image, forKey: url as NSString)
                    }
                }
                self.image = $0
            }

    }
}

struct AsnycCacheImage: View {
    @ObservedObject var imageLoader = ImageLoader()
    
    @State private var skeletonAnimationTrigger = false
    
    // MARK: - 스켈레톤 뷰
    var skeletonView: some View {
        GeometryReader { geometry in
            let gradient = Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3), Color.gray.opacity(0.5)])
            let startPoint = skeletonAnimationTrigger ? UnitPoint(x: -1, y: 0.5) : UnitPoint(x: 0, y: 0.5)
            let endPoint = skeletonAnimationTrigger ? UnitPoint(x: 1, y: 0.5) : UnitPoint(x: 2, y: 0.5)
            
            Rectangle()
                .fill(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 0.6).repeatForever(autoreverses: false)) {
                skeletonAnimationTrigger.toggle()
            }
        }
    }

    init(url: String) {
        imageLoader.load(from: url)
    }
    
    var body: some View {
        // 이미지가 로드되면 표시, 그렇지 않으면 스켈레톤 뷰 표시
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            skeletonView
        }
    }
}
