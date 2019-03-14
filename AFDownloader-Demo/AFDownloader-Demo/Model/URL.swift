//
//  URL.swift
//  AFDownloader-Demo
//
//  Created by Arun Jose on 15/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation
import ObjectMapper

public class URLS: Mappable {
    public var raw:String?
    public var full:String?
    public var regular:String?
    public var small:String?
    public var thumb:String?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        raw <- map[Constants.PARAMS.RAW]
        full <- map[Constants.PARAMS.FULL]
        regular <- map[Constants.PARAMS.REGULAR]
        small <- map[Constants.PARAMS.SMALL]
        thumb <- map[Constants.PARAMS.THUMB]
    }
}
