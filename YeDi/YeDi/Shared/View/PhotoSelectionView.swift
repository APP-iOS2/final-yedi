//
//  PhotoSelectionView.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/13.
//

import SwiftUI

struct PhotoSelectionView: View {
    @Binding var selectedPhotoURLs: [String]
    
    @Binding var isShowingPhotoPicker: Bool
    
    var body: some View {
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
    }
}

#Preview {
    PhotoSelectionView(selectedPhotoURLs: .constant([]), isShowingPhotoPicker: .constant(false))
}
