import SwiftUI
import Firebase
import FirebaseFirestore

class CMSearchViewModel: ObservableObject {
    @Published var designers: [Designer] = []
    @Published var searchText: String = ""
    @Published var recentSearches: [String] = []
    @Published var showRecentSearches = true
    @Published var isHeartSelected: Bool = false
    
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
    
    func saveRecentSearch() {
        if !searchText.isEmpty {
            if !recentSearches.contains(searchText) {
                recentSearches.insert(searchText, at: 0)
                if recentSearches.count > 5 {
                    recentSearches.removeLast()
                }
                
                // UserDefaults를 사용하여 최근 검색어를 저장합니다.
                UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
            }
            searchText = ""
        }
    }
    
    func removeRecentSearch(_ search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
            
            // UserDefaults에서 해당 검색어를 삭제합니다.
            UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
        }
    }
    
    func removeAllRecentSearches() {
        recentSearches.removeAll()
        UserDefaults.standard.removeObject(forKey: "RecentSearches")
    }

    
    func loadRecentSearches() {
        // UserDefaults에서 최근 검색어를 불러옵니다.
        if let loadedSearches = UserDefaults.standard.array(forKey: "RecentSearches") as? [String] {
            recentSearches = loadedSearches
        }
    }
    
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
            self.designers = documents.compactMap{ document in
                try? document.data(as: Designer.self)
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