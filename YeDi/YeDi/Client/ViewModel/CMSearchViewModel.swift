import SwiftUI
import Firebase
import FirebaseFirestore

class CMSearchViewModel: ObservableObject {
    @Published var designers: [Designer] = []
    @Published var searchText: String = ""
    @Published var recentSearches: [String] = []
    @Published var isTextFieldActive: Bool = false

    
    private let db = Firestore.firestore()
    
    var filterDesigners: [Designer] {
        if searchText.isEmpty {
            return []
        } else {
            return designers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var filteredDesignerCount: Int {
        return filterDesigners.count
    }
    
    init() {
        loadRecentSearches()
        loadData()
    }
    
    //최근 검색어 저장
    func saveRecentSearch() {
        if !searchText.isEmpty {
            if !recentSearches.contains(searchText) {
                recentSearches.insert(searchText, at: 0)
                if recentSearches.count > 5 {
                    recentSearches.removeLast()
                }
                
                UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
            }
            searchText = ""
        }
    }
    
    // 최근 검색어 삭제
    func removeRecentSearch(_ search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
            
            UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
        }
    }
    
    // 최근 검색어 전체 삭제
    func removeAllRecentSearches() {
        recentSearches.removeAll()
        
        UserDefaults.standard.removeObject(forKey: "RecentSearches")
    }

    // 최근 검색어 불러오기
    func loadRecentSearches() {
        if let loadedSearches = UserDefaults.standard.array(forKey: "RecentSearches") as? [String] {
            recentSearches = loadedSearches
        }
    }
    
    // 디자이너 정보 불러오기
    func loadData() {
        let db = Firestore.firestore()
        
        db.collection("designers").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            var designersWithShops: [Designer] = []
            let dispatchGroup = DispatchGroup() // Create a DispatchGroup to use
            
            for document in documents {
                if var designer = try? document.data(as: Designer.self) {
                    let designerID = document.documentID
                    let shopCollection = db.collection("designers").document(designerID).collection("shop")
                    
                    dispatchGroup.enter() // Enter the DispatchGroup
                    
                    shopCollection.getDocuments { (shopSnapshot, shopError) in
                        if let shopError = shopError {
                            print("Shop data retrieval failed: \(shopError)")
                        } else {
                            if let shopData = shopSnapshot?.documents.compactMap({ try? $0.data(as: Shop.self) }) {
                                designer.shop = shopData.first
                            }
                        }
                        
                        designersWithShops.append(designer)
                        dispatchGroup.leave() // Leave the DispatchGroup
                    }
                }
            }
            
            // Wait for all tasks to complete
            dispatchGroup.notify(queue: .main) {
                // The designersWithShops array contains all designers with related shop data
                self.designers = designersWithShops
            }
        }
    }


    
    func performSearch() {
        designers = []

        let query = db.collection("designers").whereField("name", isGreaterThanOrEqualTo: searchText)
        
        query.getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            self?.designers = documents.compactMap { document in
                try? document.data(as: Designer.self)
            }
        }
    }


}
