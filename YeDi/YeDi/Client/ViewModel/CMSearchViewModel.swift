//
//  CMSearchViewModel.swift
//  YeDi
//
//  Created by Jaehui Yu on 10/11/23.
//

import SwiftUI
import FirebaseFirestore

class CMSearchViewModel: ObservableObject {
    @Published var designers: [Designer] = []
    
    private var db = Firestore.firestore()
    
    func searchDesigners(query: String) {
        db.collection("designers")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    var designerData: [Designer] = []
                    for document in querySnapshot!.documents {
                        if let data = try? document.data(as: Designer.self) {
                            designerData.append(data)
                        }
                    }
                    DispatchQueue.main.async {
                        self.designers = designerData
                    }
                }
            }
    }
}

