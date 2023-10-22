//
//  LocationManager.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/22.
//

import SwiftUI
import CoreLocation

/// 위치 권한 및 위치 관련 작동을 처리하는 클래스
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: - Properties
    @Published var authorizationStatus : CLAuthorizationStatus = .notDetermined
    @Published var coordinate : CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()
    
    // MARK: - Initializer
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Methods
    /// 위치 권한 요청하는 메서드
    func requestLocationPermission()  {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 위치 권한 변경시 호출되는 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    /// 위치 업데이트 처리 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        coordinate = location.coordinate
    }
    
    /// 위치 업데이트 에러 처리 메서드
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating with: \(error)")
    }
}
