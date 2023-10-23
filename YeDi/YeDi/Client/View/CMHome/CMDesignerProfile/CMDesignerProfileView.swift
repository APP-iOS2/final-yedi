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
                VStack(alignment: .leading) {
                    HStack {
                        if let imageURLString = designer.imageURLString {
                            AsyncImage(url: URL(string: "\(imageURLString)")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: 80, maxHeight: 80)
                                    .clipShape(Circle())
                            } placeholder: {
                                Text(String(designer.name.first ?? " ").capitalized)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .frame(width: 80, height: 80)
                                            .background(Circle().fill(Color.quaternarySystemFill))
                                            .foregroundColor(Color.primaryLabel)
                            }
                        } else {
                            Text(String(designer.name.first ?? " ").capitalized)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .frame(width: 80, height: 80)
                                        .background(Circle().fill(Color.quaternarySystemFill))
                                        .foregroundColor(Color.primaryLabel)
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text(designer.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("팔로워 \(viewModel.formattedFollowerCount(followerCount: viewModel.previousFollowerCount)) · 게시물 \(viewModel.designerPosts.count)")
                                .font(.callout)
                        }
                        .padding(.leading, 4)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await viewModel.toggleFollow(designerUid: designer.designerUID)
                                await viewModel.updateFollowerCountForDesigner(designerUID: designer.designerUID, followerCount: designer.followerCount)
                            }
                        } label: {
                            Text("\(viewModel.isFollowing ? "팔로잉" : "팔로우")")
                                .font(.callout)
                                .foregroundStyle(viewModel.isFollowing ? Color.primaryLabel :  .white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 7)
                                .background {
                                    Capsule(style: .continuous)
                                        .fill(viewModel.isFollowing ? Color.quaternarySystemFill : Color.subColor)
                                }
                        }
                        
                    }
                    
                    if let description = designer.description {
                        if description != "" {
                            Text(description)
                                .lineLimit(1)
                                .font(.callout)
                                .foregroundStyle(Color.primaryLabel)
                                .padding(.top, 4)
                        }
                    }
                    
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack {
                                Spacer()
                                Text("상담하기")
                                    .font(.callout)
                                    .foregroundStyle(Color.primaryLabel)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 7)
                                Spacer()
                            }
                            .background {
                                Capsule(style: .continuous)
                                    .fill(Color.quaternarySystemFill)
                            }
                        }
                        .padding(.trailing, 1)
                        Button {
                            //
                        } label: {
                            HStack {
                                Spacer()
                                Text("예약하기")
                                    .font(.callout)
                                    .foregroundStyle(Color.primaryLabel)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 7)
                                Spacer()
                            }
                            .background {
                                Capsule(style: .continuous)
                                    .fill(Color.quaternarySystemFill)
                            }
                        }
                        .padding(.leading, 1)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal)
                
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
            viewModel.fetchReview(designerUID: designer.designerUID)
            viewModel.fetchKeywords(designerUID: designer.designerUID)
            viewModel.previousFollowerCount = designer.followerCount
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
