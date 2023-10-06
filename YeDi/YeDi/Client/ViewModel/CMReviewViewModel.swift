//
//  CMReviewViewModel.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/06.
//

import Foundation
import FirebaseFirestore

class CMReviewViewModel: ObservableObject {
    @Published var reveiws: [Review] = []
}
