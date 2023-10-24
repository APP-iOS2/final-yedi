//
//  MapMarker.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/24.
//

import Foundation
import CoreLocation

struct MapMarker: Identifiable {
    let id: UUID = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
