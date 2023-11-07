//
//  PhotoSelectionView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/13.
//

import SwiftUI

struct PhotoSelectionView: View {
    // MARK: - Properties
    @Binding var selectedPhotoURLs: [String]
    @Binding var isShowingPhotoPicker: Bool

    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray6)
                        .frame(width: 100, height: 100)
                    VStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("사진 추가")
                    }
                    .foregroundStyle(.gray)
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 0))
                .onTapGesture(perform: {
                    isShowingPhotoPicker.toggle()
                })

                ForEach(selectedPhotoURLs, id: \.self) { photoURL in
                    ZStack {
                        AsnycCacheImage(url: photoURL)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Button(action: {
                            DispatchQueue.main.async {
                                selectedPhotoURLs.removeAll(where: { $0 == photoURL })
                            }
                        }, label: {
                            Image(systemName: "x.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.main)
                        })
                        .offset(x: 52, y: -53)
                    }
                }
                .padding(EdgeInsets(top: 13, leading: 5, bottom: 20, trailing: 0))
            }
            .padding(.trailing)
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    PhotoSelectionView(selectedPhotoURLs: .constant([]), isShowingPhotoPicker: .constant(false))
}
