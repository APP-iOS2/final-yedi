//
//  CMReviewSelectPhotosView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/01.
//

import SwiftUI
import PhotosUI

struct CMReviewSelectPhotosView: View {
    // MARK: - Properties
    @Binding var selectedPhotoURLs: [String]
    
    @State private var isShowingPhotoPicker: Bool = false
    
    // MARK: - Body
    var body: some View {
        Section {
            ScrollView(.horizontal) {
                PhotoSelectionView(selectedPhotoURLs: $selectedPhotoURLs, isShowingPhotoPicker: $isShowingPhotoPicker)
                    .padding(.bottom, 10)
            }
            .scrollIndicators(.never)
        } header: {
            HStack {
                Text("시술 사진을 추가해주세요")
                    .fontWeight(.semibold)
                    .padding(.leading)
                Spacer()
            }
            Divider()
                .frame(width: 360)
                .padding(.bottom, 10)
        }
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            PhotoPicker { imageURL in
                selectedPhotoURLs.append(imageURL.absoluteString)
            }
        })
    }
}

#Preview {
    CMReviewSelectPhotosView(
        selectedPhotoURLs: .constant([])
    )
}
