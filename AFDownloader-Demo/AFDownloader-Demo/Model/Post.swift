//
//  Post.swift
//  AFDownloader-Demo
//
//  Created by Arun Jose on 15/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation
import ObjectMapper

public class Post: Mappable {
    public var id:String?
    public var createdAt:String?
    public var width:Int?
    public var height:Int?
    public var color:String?
    public var likes:Int?
    public var likedByUser:Bool?
    public var user:User?
    public var url:URLS?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        id <- map[Constants.PARAMS.ID]
        createdAt <- map[Constants.PARAMS.CREATED_AT]
        width <- map[Constants.PARAMS.WIDTH]
        height <- map[Constants.PARAMS.HEIGHT]
        color <- map[Constants.PARAMS.COLOR]
        likes <- map[Constants.PARAMS.LIKES]
        likedByUser <- map[Constants.PARAMS.LIKED_BY_USER]
        user <- map[Constants.PARAMS.USER]
        url <- map[Constants.PARAMS.URLS]
    }
}

extension Post {
    public static func getPostListFrom(jsonArray:[[String:Any]]) -> [Post] {
        let postList = Mapper<Post>().mapArray(JSONArray: jsonArray)
        return postList
    }
}
