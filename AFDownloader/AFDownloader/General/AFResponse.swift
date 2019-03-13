//
//  AFResponse.swift
//  AFDownloader
//
//  Created by Arun Jose on 12/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation

public struct AFResponse<Type> {
    public let url:URL?
    public let response:Type?
}
