//
//  ProfileImage.swift
//  AFDownloader-Demo
//
//  Created by Arun Jose on 15/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation
import ObjectMapper

public class ProfileImage: Mappable {
    public var small:String?
    public var medium:String?
    public var large:String?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        small <- map[Constants.PARAMS.SMALL]
        medium <- map[Constants.PARAMS.MEDIUM]
        large <- map[Constants.PARAMS.LARGE]
    }
}
