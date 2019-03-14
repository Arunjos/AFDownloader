//
//  User.swift
//  AFDownloader-Demo
//
//  Created by Arun Jose on 15/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation
import ObjectMapper

public class User: Mappable {
    public var id:String?
    public var userName:String?
    public var name:String?
    public var profileImage:ProfileImage?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        id <- map[Constants.PARAMS.ID]
        userName <- map[Constants.PARAMS.USER_NAME]
        name <- map[Constants.PARAMS.NAME]
        profileImage <- map[Constants.PARAMS.PROFILE_IMAGE]
    }
}

extension Post {
    public static func getUserFrom(jsonObject:[String:Any]) -> User {
        let user = User(JSON: jsonObject)
        return user!
    }
}
