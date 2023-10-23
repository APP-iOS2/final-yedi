//
//  Marker.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/23.
//

import SwiftUI
import MapKit

struct Marker: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let coordinate: CLLocationCoordinate2D
}
