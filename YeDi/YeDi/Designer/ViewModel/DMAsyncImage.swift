//
//  AsyncImage.swift
//  YeDi
//
//  Created by 박찬호 on 2023/09/25.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    var cancellable: AnyCancellable?

    func load(from url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: imageURL)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

struct AsyncImage: View {
    @ObservedObject var imageLoader = ImageLoader()
    var placeholder: Image

    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        imageLoader.load(from: url)
    }

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
        }
    }
}
