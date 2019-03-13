//
//  AFDownloader.swift
//  AFDownloader
//
//  Created by Arun Jose on 08/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation

public enum AFDownloader{
    public static func downloadFileRequest(fileURL:URL) -> AFRequest{
        return AFSession.default.downloadFileRequest(fileURL:fileURL)
    }
}
