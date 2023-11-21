//
//  UIWindow.swift
//  YeDi
//
//  Created by 박채영 on 2023/11/07.
//

import SwiftUI

let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
let window = windowScene?.windows.first

let screenWidth = window?.screen.bounds.width ?? 0
let screenHeight = window?.screen.bounds.height ?? 0
