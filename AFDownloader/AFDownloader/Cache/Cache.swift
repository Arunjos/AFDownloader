//
//  Cache.swift
//  AFDownloader
//
//  Created by Arun Jose on 13/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation


public class Cache<ObjectType>{
    var cacheStoreList:[CacheStore] = Array<CacheStore>()
    var capacity:Int
    struct CacheStore {
        var key:String
        var value:ObjectType
    }
    
    public init(capacity: Int) {
//        self.cacheStoreList = Array<CacheStore>()
        self.capacity = max(0, capacity)
    }
    
    public func setValue(_ value: ObjectType, for key: String) {
        if let index = cacheStoreList.index(where: { $0.key == key }) {
            cacheStoreList[index].value = value
            let element = cacheStoreList.remove(at: index)
            cacheStoreList.insert(element, at: 0)
        }else {
            cacheStoreList.insert(CacheStore(key: key, value: value), at: 0)
        }
        
        if(cacheStoreList.count > capacity){
            cacheStoreList.removeLast()
        }
    }
    
    public func getValue(for key: String) -> ObjectType? {
        if let index = cacheStoreList.index(where: { $0.key == key }) {
            let element = cacheStoreList.remove(at: index)
            cacheStoreList.insert(element, at: 0)
            return element.value
        }
        return nil
    }
    
    @discardableResult
    public func deleteValue(for key: String) -> ObjectType? {
        if let index = cacheStoreList.index(where: { $0.key == key }) {
            let element = cacheStoreList.remove(at: index)
            return element.value
        }
        return nil
    }
}
