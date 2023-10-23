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
    @StateObject var profileVM: DMProfileViewModel = DMProfileViewModel.shared
    
    @State private var region = MKCoordinateRegion()
    @State private var isShowDesignerShopEditView = false
    
    var location: MapMarker {
        MapMarker(
            coordinate: CLLocationCoordinate2D(
                    latitude: locationManager.coordinate?.latitude ?? 30,
                    longitude: locationManager.coordinate?.longitude ?? 30
            )
        )
    }
    
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
                        Text(profileVM.designer.description ?? "자기소개가 없습니다.")  // 자기소개
                            .font(.subheadline)
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
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            case .failure(_):
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
                        Text(profileVM.shop.headAddress)  // 샵 위치
                            .foregroundStyle(.gray)
                        
                        switch locationManager.authorizationStatus {
                        case .notDetermined:
                            Map(coordinateRegion: $region, showsUserLocation: true)
                        case .restricted:
                            Map(coordinateRegion: $region, showsUserLocation: true)
                        case .denied:
                            Map(coordinateRegion: $region, showsUserLocation: true)
                        case .authorizedAlways:
                            Map(coordinateRegion: $region, showsUserLocation: true)
                        case .authorizedWhenInUse:
                            Map(coordinateRegion: $region, showsUserLocation: true)
                        case .authorized:
                            Map(coordinateRegion: $region, showsUserLocation: true)
                        @unknown default:
                            fatalError()
                        }
                        
                        Divider()
                        
                        Text("휴무일: \(profileVM.shop.closedDays.joined(separator: ", "))")  // 휴무일 정보
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
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink {
                            CMSettingsView()
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(Color.primaryLabel)
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text("YeDi")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            // MARK: - Fetch Data on Appear
            .onAppear {
                Task {
                    locationManager.requestLocationPermission()
                    region.center = CLLocationCoordinate2D(
                        latitude: locationManager.coordinate?.latitude ?? 30,
                        longitude: locationManager.coordinate?.longitude ?? 130
                    )
                    region.span = MKCoordinateSpan(
                        latitudeDelta: 0.001,
                        longitudeDelta: 0.001
                    )
                    
                    // 디자이너 정보가 변경되지 않았다면 로딩하지 않음
                    if profileVM.designer.id == nil {
                        await profileVM.fetchDesignerProfile(userAuth: userAuth)
                    }
                    
                    // 샵 정보를 항상 업데이트
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
                }
            }
        }
    }
    
    // 스켈레톤 뷰를 반환하는 함수
    func skeletonView() -> some View {
        return Circle()
            .frame(width: 70, height: 70)
            .foregroundColor(Color.gray.opacity(0.5))
    }
    
    // 기본 프로필 이미지를 반환하는 함수
    func defaultProfileImage() -> some View {
        return Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70)
            .clipShape(Circle())
    }
}

#Preview {
    NavigationView {
        DMProfileView()
            .environmentObject(UserAuth())
            .environmentObject(LocationManager())
    }
}
