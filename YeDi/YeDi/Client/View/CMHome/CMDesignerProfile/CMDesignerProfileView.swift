//
//  CMDesignerProfileView.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/13/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CMDesignerProfileView: View {
    var designer: Designer
    @StateObject var viewModel = CMDesignerProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    if let imageURLString = designer.imageURLString {
                        AsyncImage(url: URL(string: "\(imageURLString)")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 100, maxHeight: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            Text(String(designer.name.first ?? " ").capitalized)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .frame(width: 100, height: 100)
                                        .background(Circle().fill(.gray))
                                        .foregroundColor(Color.primaryLabel)
                        }
                    } else {
                        Text(String(designer.name.first ?? " ").capitalized)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .frame(width: 100, height: 100)
                                    .background(Circle().fill(.gray))
                                    .foregroundColor(Color.primaryLabel)
                        
                    }
                    Text(designer.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top,10)
                    Text(designer.description ?? "")
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.callout)
                        .fontWeight(.light)
                        .padding(.horizontal)
                    Text("팔로워 \(viewModel.isFollowing ? viewModel.formattedFollowerCount(followerCount: designer.followerCount + 1) : viewModel.formattedFollowerCount(followerCount: designer.followerCount)) · 게시물 \(viewModel.designerPosts.count)")
                        .fontWeight(.medium)
                        .padding(.vertical,10)
                    Button {
                        Task {
                            await viewModel.toggleFollow(designerUid: designer.designerUID)
                        }
                    } label: {
                        Text("\(viewModel.isFollowing ? "팔로잉" : "팔로우")")
                            .foregroundStyle(viewModel.isFollowing ? Color.primaryLabel :  .white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 7)
                            .background {
                                Capsule(style: .continuous)
                                    .fill(viewModel.isFollowing ? .gray : Color.subColor)
                            }
                    }
                }
                .padding(.top)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text(designer.shop?.shopName ?? "Shop 이름")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primaryLabel)
                        Text(designer.shop?.headAddress ?? "Shop 주소")
                            .foregroundStyle(.gray)
                        Divider()
                        if let closedDays = designer.shop?.closedDays {
                            Text("휴무일 : \(closedDays.joined(separator: ", "))")
                                .foregroundStyle(.gray)
                        } else {
                            Text("Shop휴무일")
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding()
                }
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.quaternarySystemFill)
                }
                .padding()
                
                CMDesignerProfileSegmentedView(designer: designer, designerPosts: viewModel.designerPosts, reviews: viewModel.reviews, keywords: viewModel.keywords, keywordCount: viewModel.keywordCount)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
        .onAppear {
            Task {
                await viewModel.isFollowed(designerUid: designer.designerUID)
            }
            viewModel.fetchDesignerPosts(designerUID: designer.designerUID)
            viewModel.fetchReview()
            viewModel.fetchKeywords()
        }
        Spacer()
    }
}

struct RatingView: View {
    let score: Int
    let maxScore: Int
    let filledColor: Color
    
    var body: some View {
        HStack {
            ForEach(0..<maxScore, id: \.self) { index in
                Image(systemName: index < score ? "star.fill" : "star")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(index < score ? filledColor : Color.gray)
            }
        }
    }
}


#Preview {
    CMDesignerProfileView(designer: Designer(name: "양파쿵야", email: "", phoneNumber: "", designerScore: 0, reviewCount: 0, followerCount: 15430020, skill: [], chatRooms: [], birthDate: "", gender: "", rank: .Owner, designerUID: ""))
}
