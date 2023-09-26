//
//  AsyncImage.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/25.
//

// SwiftUI와 Combine 프레임워크를 임포트합니다.
import SwiftUI
import Combine

// 이미지를 로드하는 클래스를 정의합니다. 이 클래스는 ObservableObject 프로토콜을 채택
class ImageLoader: ObservableObject {
    // 로드한 이미지를 저장할 변수입니다.
    @Published var image: UIImage?
    
    // 데이터 로딩 작업을 취소할 수 있는 변수입니다.
    var cancellable: AnyCancellable?

    // 이미지를 로드하는 함수입니다.
    func load(from url: String) {
        // 주어진 URL 문자열을 URL 객체로 변환합니다.
        guard let imageURL = URL(string: url) else {
            return
        }
        
        // URLSession을 이용하여 이미지를 비동기적으로 로드합니다.
        cancellable = URLSession.shared.dataTaskPublisher(for: imageURL)
            .map { UIImage(data: $0.data) }  // 데이터를 UIImage로 변환합니다.
            .replaceError(with: nil)  // 에러가 발생하면 nil을 반환합니다.
            .receive(on: DispatchQueue.main)  // 메인 스레드에서 결과를 받습니다.
            .assign(to: \.image, on: self)  // 결과를 self.image에 할당합니다.
    }
}

// 비동기로 이미지를 로드하여 표시
struct AsyncImage: View {
    // ImageLoader 인스턴스를 생성하고 관찰합니다.
    @ObservedObject var imageLoader = ImageLoader()
    
    var placeholder: Image

    // 초기화 함수입니다. URL과 플레이스홀더 이미지를 인자로 받습니다.
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        imageLoader.load(from: url)  // ImageLoader를 이용하여 이미지를 로드합니다.
    }

    var body: some View {
        // 이미지가 로드되면 그 이미지를 표시하고, 그렇지 않으면 플레이스홀더를 표시합니다.
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
        }
    }
}
