//
//  CMDesignerProfileView.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/13/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

struct CMDesignerProfileView: View {
    var designer: Designer
    
    @StateObject var viewModel = CMDesignerProfileViewModel()
    @StateObject var postDetailViewModel = PostDetailViewModel()
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var consultationViewModel: ConsultationViewModel
    @State private var isPresentedNavigation: Bool = false
    @State private var isPresentedAlert: Bool = false
    @State private var region = MKCoordinateRegion()
    @State private var markers: [MapMarker] = []
    @State private var isShowingMap = false
    @State private var selectedSegment: String = "게시물"
    
    var body: some View {
        ScrollView {
            VStack {
                // MARK: Designer Info & Button
                VStack(alignment: .leading) {
                    HStack {
                        if let imageURLString = designer.imageURLString {
                            AsnycCacheImage(url: imageURLString)
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 80, maxHeight: 80)
                                .clipShape(Circle())
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
                        
                        // 팔로우 버튼
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
                        // 상담하기 버튼
                        Button {
                            consultationViewModel.setEmptyChatRoomList(customerId: userAuth.currentClientID ?? "", designerId: designer.designerUID)
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
                        
                        // 예약하기 버튼
                        Button {
                            isPresentedNavigation.toggle()
                            isPresentedAlert.toggle()
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
                        
                        .navigationDestination(isPresented: $isPresentedNavigation, destination: {
                            CMReservationDateTimeView(isPresentedAlert: $isPresentedAlert, isPresentedNavigation: $isPresentedNavigation, designerID: designer.designerUID)
                                .environmentObject(postDetailViewModel)
                        })
                        .padding(.leading, 1)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal)
                
                // MARK: Shop Info
                VStack {
                    VStack(alignment: .leading) {
                        Text(designer.shop?.shopName ?? "Shop 이름")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primaryLabel)
                        HStack {
                            Text("\(designer.shop?.headAddress ?? "") \(designer.shop?.subAddress ?? "") \(designer.shop?.detailAddress ?? "")")
                                .foregroundStyle(.gray)
                            Spacer()
                                Button {
                                    isShowingMap.toggle()
                                } label: {
                                    Image(systemName: isShowingMap ? "chevron.up" : "chevron.down")
                                        .foregroundStyle(.gray)
                                }
                        }
                        if isShowingMap {
                            Map(coordinateRegion: $region, annotationItems: markers) { marker in
                                MapAnnotation(coordinate: marker.coordinate) {
                                    Image(systemName: "scissors.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.sub)
                                }
                            }
                            .frame(minHeight: 200)
                        }
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
                
                // MARK: Post & Review
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section(header: HeaderView(selectedSegment: $selectedSegment)) {
                        VStack {
                            switch selectedSegment {
                            case "게시물":
                                CMDesignerProfilePostView(designer: designer, designerPosts: viewModel.designerPosts)
                            case "리뷰":
                                CMDesignerProfileReviewView(designer: designer, reviews: viewModel.reviews, keywords: viewModel.keywords, keywordCount: viewModel.keywordCount)
                            default:
                                Text("")
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding([.leading, .trailing], 5)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton(color: nil, action: {})
            }
        }
        .onAppear {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await viewModel.isFollowed(designerUid: designer.designerUID)
                    }
                    
                    group.addTask {
                        await postDetailViewModel.getDesignerProfile(designerUid: designer.designerUID)
                    }
                }
            }
            viewModel.fetchDesignerPosts(designerUID: designer.designerUID)
            viewModel.fetchReview(designerUID: designer.designerUID)
            viewModel.fetchKeywords(designerUID: designer.designerUID)
            viewModel.previousFollowerCount = designer.followerCount
            
            region.center = CLLocationCoordinate2D(
                latitude: designer.shop?.latitude ?? 0,
                longitude: designer.shop?.longitude ?? 0
            )
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            markers.append(
                MapMarker(
                    name: designer.shop?.shopName ?? "",
                    coordinate: CLLocationCoordinate2D(
                        latitude: designer.shop?.latitude ?? 37.57,
                        longitude: designer.shop?.longitude ?? 126.98)
                )
            )
        }
        Spacer()
    }
}

struct HeaderView: View {
    @Binding var selectedSegment: String

    var body: some View {
        HStack(spacing: 0) {
            ForEach(["게시물", "리뷰"], id: \.self) { segment in
                Button(action: {
                    selectedSegment = segment
                }, label: {
                    VStack {
                        Text(segment)
                            .fontWeight(selectedSegment == segment ? .semibold : .medium)
                            .foregroundColor(Color(UIColor.label))
                        Rectangle()
                            .fill(selectedSegment == segment ? Color.primaryLabel : .gray6)
                            .frame(width: 180, height: 3)
                    }
                })
            }
        }
        .padding(.top)
        .background(Rectangle().foregroundColor(Color.systemBackground))
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
