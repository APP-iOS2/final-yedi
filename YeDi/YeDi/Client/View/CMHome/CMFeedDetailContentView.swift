//
//  CMFeedDetailContentView.swift
//  YeDi
//
//  Created by SONYOONHO on 2023/09/25.
//

import SwiftUI

struct CMFeedDetailContentView: View {
    @Environment(\.dismiss) var dismiss
    let images: [String] = ["https://images.pexels.com/photos/18005100/pexels-photo-18005100/free-photo-of-fa1-vsco.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", "https://images.pexels.com/photos/17410647/pexels-photo-17410647.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"]
    var safeArea: EdgeInsets
    var size: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: true) {
                imageTabView()
                feedInfoView()
                designerProfileView()
            }
            .coordinateSpace(name: "SCROLL")
            .overlay(alignment: .top) {
                headerView()
            }
            
            footerView()
        }
        .overlay(
            ZStack {
                // TODO: Image DetailView
            }
        )
    }
    
    // 불투명 반환타입이기 때문에 코드가 하나의 컨텍스트로 되어있지 않으면 @ViewBuilder를 명시해주어야 한다.
    private func headerView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCORLL")).minY
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundStyle(.pink)
                }

            }
            .padding(.top, safeArea.top)
            .padding([.horizontal, .bottom], 20)
            .offset(y: -minY)
        }
    }
    
    @ViewBuilder
    private func imageTabView() -> some View {
        let height = size.height * 0.4
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            
            TabView {
                ForEach(images, id: \.self) { imageString in
                    AsyncImage(url: imageString)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: safeArea.top + 50)
                                .zIndex(1),
                                alignment: .top
                            )
                    .onTapGesture {
                        withAnimation(.default) {
                            // TODO: 선택한 이미지 배열에
                        }
                    }
                }
            }
            .background(.black)
            .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
            .offset(y: minY > 0 ? -minY : 0)
            .tabViewStyle(PageTabViewStyle())
        }
        .frame(height: height + safeArea.top)
    }
    
    private func feedInfoView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0...1, id: \.self) { _ in
                    Text("#레이어드")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(UIColor(red: 0, green: 0, blue: 1, alpha: 0.45)))
                        .clipShape(RoundedRectangle(cornerRadius:5))
                        .foregroundStyle(.white)
                }
            }
            .padding([.leading, .top])
            .padding(.bottom, 8)
            
            Text("무겁게 축 쳐지는 머리 ➡️ 가벼운 허쉬 레이어드")
                .padding(.horizontal)
            
            Divider()
                .frame(height: 7)
                .background(.gray)
                .padding(.top)
                .padding(.bottom, 10)
            
            //TODO: 이거도 팔고 있어요 View
        }
    }
    
    private func designerProfileView() -> some View {
        HStack(alignment: .center) {
            AsyncImage(url: images[0])
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 50)
                    .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("elwkdlsj_dkdlel")
                    .font(.system(size: 16, design: .serif))
                
                Group {
                    Text("서울/합정")
                    Text("팔로우 234")
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                 
            } label: {
                Text("팔로우")
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
        }
        .padding(.horizontal)
    }
    
    private func footerView() -> some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(alignment: .center) {
                Button {
                    
                } label: {
                    Text("상담하기")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button {
                    
                } label: {
                    Text("바로예약")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                //TODO: 작성자인지 구분하여 버튼을 다르게
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        }
    }
    
    // TODO: Image DetailView
//    var imageDetailView: some View {
//        ZStack {
//            Color.black
//                .ignoresSafeArea()
//            
//            TabView(selection: $postViewModel.selectedImageID) {
//                ForEach(postViewModel.selectedImages, id: \.self) { imageString in
//                    AsyncImage(url: URL(string: imageString)) { image in
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                    } placeholder: {
//                        ProgressView()
//                    }
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//            .overlay(
//                Button {
//                    withAnimation(.default) {
//                        postViewModel.selectedImages.removeAll()
//                    }
//                } label: {
//                    Image(systemName: "xmark")
//                        .foregroundColor(.white)
//                        .padding()
//                }
//                    .padding(.top, safeArea.top)
//                ,alignment: .topTrailing
//            )
//        }
//    }
}

#Preview {
    CMFeedDetailView()
}
