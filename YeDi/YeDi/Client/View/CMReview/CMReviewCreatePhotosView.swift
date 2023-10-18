//
//  CMReviewCreatePhotosView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/01.
//

import SwiftUI
import PhotosUI

struct CMReviewCreatePhotosView: View {
    @Binding var selectedPhotoURLs: [String]
    
    @State private var isShowingPhotoPicker: Bool = false
    
    var body: some View {
        Section {
            PhotoSelectionView(selectedPhotoURLs: $selectedPhotoURLs, isShowingPhotoPicker: $isShowingPhotoPicker)
        } header: {
            HStack {
                Text("시술 사진 추가을 추가해주세요")
                    .padding(.leading)
                    .fontWeight(.semibold)
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
    CMReviewCreatePhotosView(
        selectedPhotoURLs: .constant([])
    )
}
