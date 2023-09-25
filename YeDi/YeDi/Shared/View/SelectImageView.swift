//
//  SelectImage.swift
//  YeDi
//
//  Created by 김성준 on 2023/09/25.
//

import SwiftUI
import PhotosUI

struct SelectImageView: View {
        @State private var selectedItem: PhotosPickerItem?
        @State private var selectedImage: Image = Image(systemName: "camera.circle.fill")
        
        var body: some View {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                VStack {
                    selectedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                    Text("수정")
                }
            }
            .task {
                imageLoadToFileManager()
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    newItem?.loadTransferable(type: Data.self, completionHandler: { result in
                            switch result {
                            case .success(let success):
                                if let imageData = success,
                                    let _ = UIImage(data: imageData) {
                                    // 파일 경로를 설정
                                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                    let fileURL = documentsDirectory.appendingPathComponent("selected_image.jpg")
                                    // 이미지 데이터를 파일로 저장
                                    do {
                                        try imageData.write(to: fileURL)
                                    } catch {
                                        print("Error saving image: \(error)")
                                    }
                                    // 저장된 이미지 데이터를 로드
                                    if let loadedImageData = try? Data(contentsOf: fileURL),
                                       let loadedUIImage = UIImage(data: loadedImageData) {
                                        selectedImage = Image(uiImage: loadedUIImage)
                                    }
                                } else {
                                    selectedImage = Image(systemName: "camera.circle.fill")
                                }
                            case .failure(let error):
                                print(error)
                                selectedImage = Image(systemName: "camera.circle.fill")
                            }
                        
                    })
                }
            }
            .controlSize(.large)
        }
        
        func imageLoadToFileManager() {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("selected_image.jpg")
            if let loadedImageData = try? Data(contentsOf: fileURL),
               let loadedUIImage = UIImage(data: loadedImageData) {
                selectedImage = Image(uiImage: loadedUIImage)
            }
        }
    }

#Preview {
    SelectImageView()
}
