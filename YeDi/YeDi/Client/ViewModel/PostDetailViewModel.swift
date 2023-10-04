//
//  PostDetailViewModel.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/09/26.
//

import Foundation

final class PostDetailViewModel: ObservableObject {
    @Published var selectedImages: [String] = []
    @Published var selectedImageID: String = ""
    
}
