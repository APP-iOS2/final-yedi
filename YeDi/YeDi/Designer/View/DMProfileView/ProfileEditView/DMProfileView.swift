//
//  DMProfileView.swift
//  YeDi
//
//  Created by 이승준 on 2023/09/25.
//

import SwiftUI
import MapKit

struct DMProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var locationManager: LocationManager
    
    @StateObject var profileVM: DMProfileViewModel = DMProfileViewModel()
    
    @State private var region = MKCoordinateRegion()
    @State private var markers: [MapMarker] = []
    
    @State private var isShowDesignerShopEditView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(profileVM.designer.rank.rawValue) \(profileVM.designer.name)")  // 디자이너 이름과 직급
                            .font(.system(size: 20, weight: .bold))
                        HStack {
                            Text("팔로워")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("\(profileVM.designer.followerCount)")
                                .font(.subheadline)
                        }
                        if let description = profileVM.designer.description {
                            if description.isEmpty {
                                Text("자기소개가 없습니다.")
                                    .font(.subheadline)
                            }
                            Text(description)
                                .font(.subheadline)
                        } else {
                            Text("자기소개가 없습니다.")
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                    // 디자이너 프로필 사진
                    if let url = URL(string: profileVM.designer.imageURLString ?? "") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            case .failure:
                                defaultProfileImage()
                            case .empty:
                                skeletonView()
                            @unknown default:
                                defaultProfileImage()
                            }
                        }
                        .padding(.trailing, 20)
                    } else {
                        defaultProfileImage()
                            .padding(.trailing, 20)
                    }
                }
                .padding([.leading], 20)  // HStack의 전체 왼쪽 패딩을 조절
                
                // 프로필 편집으로 이동하는 버튼
                NavigationLink {
                    DMProfileEditView()
                        .environmentObject(profileVM)  // ViewModel 전달
                } label: {
                    Text("프로필 편집")
                        .frame(width: 350, height: 40)
                        .background(Color.mainColor)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding(.bottom, 10)
                
                // MARK: - Shop Info Section
                // 샵 정보 섹션
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(profileVM.shop.shopName)  // 샵 이름
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primaryLabel)
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .onTapGesture {
                                    isShowDesignerShopEditView.toggle()
                                }
                        }
                        Text("\(profileVM.shop.headAddress) \(profileVM.shop.subAddress) \(profileVM.shop.detailAddress)")  // 샵 위치
                            .foregroundStyle(.gray)
                        
                        switch locationManager.authorizationStatus {
                        case .notDetermined:
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: nil, annotationItems: markers) { marker in
                                MapAnnotation(coordinate: marker.coordinate) {
                                    Image(systemName: "scissors.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.sub)
                                }
                            }
                        case .restricted:
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: nil, annotationItems: markers) { marker in
                                MapAnnotation(coordinate: marker.coordinate) {
                                    Image(systemName: "scissors.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.sub)
                                }
                            }
                        case .denied:
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: nil, annotationItems: markers) { marker in
                                MapAnnotation(coordinate: marker.coordinate) {
                                    Image(systemName: "scissors.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.sub)
                                }
                            }
                        case .authorizedAlways:
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: nil, annotationItems: markers) { marker in
                                MapAnnotation(coordinate: marker.coordinate) {
                                    Image(systemName: "scissors.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.sub)
                                }
                            }
                        case .authorizedWhenInUse:
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: nil, annotationItems: markers) { marker in
                                MapAnnotation(coordinate: marker.coordinate) {
                                    Image(systemName: "scissors.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.sub)
                                }
                            }
                        case .authorized:
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: nil, annotationItems: markers) { marker in
                                MapAnnotation(coordinate: marker.coordinate) {
                                    Image(systemName: "scissors.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.sub)
                                }
                            }
                        @unknown default:
                            fatalError()
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("휴무일 ")
                                .fontWeight(.semibold)
                            Text("\(profileVM.shop.closedDays.joined(separator: ", "))")
                        }
                        .foregroundStyle(.gray)
                            
                    }
                    .padding()
                }
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.quaternarySystemFill)
                }
                .padding()
                
                Spacer()
            }
            .padding([.leading, .trailing], 5)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .sheet(isPresented: $isShowDesignerShopEditView, content: {
                DMShopEditView(
                    shop: $profileVM.shop,
                    rank: $profileVM.designer.rank,
                    isShowDesignerShopEditView: $isShowDesignerShopEditView,
                    colorScheme: _colorScheme,
                    userAuth: _userAuth
                )
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    YdIconView(height: 32)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink {
                            CMSettingsView()
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(Color.primaryLabel)
                        }
                    }
                }
            }
            // MARK: - Fetch Data on Appear
            .onAppear {
                Task {
                    await profileVM.fetchDesignerProfile(userAuth: userAuth)
                    await profileVM.fetchShopInfo(userAuth: userAuth)
                    
                    // 현재 사용자의 유형에 따라 적절한 ID를 가져옵니다.
                    let designerUID: String?
                    switch userAuth.userType {
                    case .client:
                        designerUID = userAuth.currentClientID
                    case .designer:
                        designerUID = userAuth.currentDesignerID
                    case .none:
                        designerUID = nil
                    }

                    // UID 확인 후 팔로워 수 업데이트
                    if let designerUID = designerUID, !designerUID.isEmpty {
                        await profileVM.updateFollowerCountForDesigner(designerUID: designerUID)
                        // 팔로워의 수가 변경되었을 때만 디자이너 정보와 샵 정보를 가져옵니다.
                        if profileVM.designer.followerCount != profileVM.previousFollowerCount {
                            await profileVM.fetchDesignerProfile(userAuth: userAuth)
                            await profileVM.fetchShopInfo(userAuth: userAuth)
                        }
                    } else {
                        print("디자이너 UID가 유효하지 않습니다.")
                    }
                    
                    region.center = CLLocationCoordinate2D(
                        latitude: profileVM.shop.latitude ?? 37.57,
                        longitude: profileVM.shop.longitude ?? 126.98
                    )
                    region.span = MKCoordinateSpan(
                        latitudeDelta: 0.001,
                        longitudeDelta: 0.001
                    )
                    
                    markers.append(
                        MapMarker(
                            name: "\(profileVM.shop.shopName)",
                            coordinate: CLLocationCoordinate2D(
                                latitude: profileVM.shop.latitude ?? 37.57,
                                longitude: profileVM.shop.longitude ?? 126.98)
                        )
                    )
                }
            }
        }
    }
    
    // 스켈레톤 뷰를 반환하는 함수
    func skeletonView() -> some View {
        return Circle()
            .frame(width: 60, height: 60)
            .foregroundColor(Color.gray.opacity(0.5))
    }
    
    // 기본 프로필 이미지를 반환하는 함수
    func defaultProfileImage() -> some View {
        return Text(String(profileVM.designer.name.first ?? " ").capitalized)
            .font(.title3)
            .fontWeight(.bold)
            .frame(width: 60, height: 60)
            .background(Circle().fill(Color.quaternarySystemFill))
            .foregroundColor(Color.primaryLabel)
            .offset(y: -5)
    }
}

#Preview {
    NavigationStack {
        DMProfileView()
            .environmentObject(UserAuth())
            .environmentObject(LocationManager())
    }
}
