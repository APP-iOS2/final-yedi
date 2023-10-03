//
//  CMReviewCreatePhotosView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/01.
//

import SwiftUI
import PhotosUI

struct CMReviewCreatePhotosView: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var selectedPhotoData: [Data]?
    
    var body: some View {
        Section {
            ScrollView(.horizontal) {
                HStack {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(white: 0.9))
                                .frame(width: 100, height: 100)
                            VStack(spacing: 10) {
                                Image(systemName: "plus")
                                Text("사진 추가")
                            }
                            .foregroundStyle(.gray)
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 40, trailing: 0))
                    }
                    .onChange(of: selectedPhoto) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedPhotoData?.append(data)
                            }
                        }
                    }
                    
                    // TODO: x 버튼을 누르면 배열에서 사라지는데 뷰에도 반영할 것
                    if var selectedPhotoData {
                        ForEach(selectedPhotoData, id: \.self) { photoData in
                            if let image = UIImage(data: photoData) {
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                    
                                    Button(action: {
                                        selectedPhotoData.removeAll(where: { $0 == photoData })
                                    }, label: {
                                        Image(systemName: "x.circle.fill")
                                            .font(.title3)
                                            .foregroundStyle(.black)
                                    })
                                    .offset(x: 50, y: -50)
                                }
                                .padding(EdgeInsets(top: 10, leading: 5, bottom: 40, trailing: 0))
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.never)
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
    }
}

#Preview {
    CMReviewCreatePhotosView(
        selectedPhoto: .constant(PhotosPickerItem(itemIdentifier: "")),
        selectedPhotoData: .constant([])
    )
}
