//
//  AsyncImage.swift
//  YeDi
//
//  Created by 김성준 on 10/12/23.
//

import SwiftUI

final class SingletonNSCache {
    
    static var sharedNSCache: SingletonNSCache = {
        
        let instance = SingletonNSCache()
        
        return instance
        
    }()
    
    private init() {  memoryCache.delegate = delegate }
    
    private let delegate = CacheDelegate()
    
    let memoryCache: NSCache<NSString, UIImage> = {
        
        let cache = NSCache<NSString, UIImage>()
        let limitSize = 50 * 1048576 // 5MB
        
        cache.totalCostLimit = limitSize
        
        return cache
    }()
}

class CacheDelegate: NSObject, NSCacheDelegate {
    
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        print("An object was evicted from the cache:", obj)
    }
}
