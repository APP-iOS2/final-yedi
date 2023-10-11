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
            ScrollView(.horizontal) {
                HStack {
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
                    .onTapGesture(perform: {
                        isShowingPhotoPicker.toggle()
                    })
                    
                    ForEach(selectedPhotoURLs, id: \.self) { photoURL in
                        AsyncImage(url: URL(string: photoURL), content: { image in
                            ZStack {
                                image
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                Button(action: {
                                    DispatchQueue.main.async {
                                        selectedPhotoURLs.removeAll(where: { $0 == photoURL })
                                    }
                                }, label: {
                                    Image(systemName: "x.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.black)
                                })
                                .offset(x: 50, y: -50)
                            }
                            .padding(EdgeInsets(top: 10, leading: 5, bottom: 40, trailing: 0))
                        }, placeholder: {
                            ProgressView()
                        })
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
