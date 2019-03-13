//
//  AFRequest.swift
//  AFDownloader
//
//  Created by Arun Jose on 12/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation
import UIKit

protocol RequestDelegate {
    func start(request:AFRequest)
    func cancel(request:AFRequest)
}

public class AFRequest{
    var fileURL:URL
    var responseData:Data?
    var responseError:Error?
    var task:URLSessionDownloadTask
    var completionHandler: ((Data?, Error?) -> Void)?
    var delegate:RequestDelegate
    
    init(url: URL, downloadTask:URLSessionDownloadTask, responseData:Data?=nil, delegate:RequestDelegate) {
        fileURL = url
        task = downloadTask
        self.responseData = responseData
        self.delegate = delegate
    }
    
    func setResponseData(downlaodedData: Data) {
        self.responseData = downlaodedData;
    }
    
    func setResponseError(errorInDownload: Error) {
        self.responseError = errorInDownload;
    }
    
    public func start() {
        delegate.start(request: self)
    }
    
    public func cancel() {
        delegate.cancel(request: self)
    }
    
    func didFailTask() {
        if let completionHandler = completionHandler {
            completionHandler(nil, self.responseError)
        }
    }
    
    func didCompleteTask() {
        if let completionHandler = completionHandler {
            completionHandler(self.responseData, nil)
        }
    }
}

extension AFRequest {
    @discardableResult
    public func responseImage(
        completionHandler: @escaping (AFResponse<UIImage>?, Error?) -> Void)
        -> Self
    {
        self.completionHandler = {downloadedData, error in
            
            if let data = downloadedData {
                let image = UIImage(data:data,scale:1.0)
                let afImageResponse = AFResponse<UIImage>(url: self.fileURL, response: image)
                completionHandler(afImageResponse, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        return self
        
    }
}

extension AFRequest {
    @discardableResult
    public func responseJSON(
        completionHandler: @escaping (AFResponse<Any>?, Error?) -> Void)
        -> Self
    {
        self.completionHandler = {downloadedData, error in
            if let data = downloadedData {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data) as! [Any]
                    let afJSONResponse = AFResponse<Any>(url: self.fileURL, response: parsedData)
                    completionHandler(afJSONResponse, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, error)
            }
        }
        return self
        
    }
}
