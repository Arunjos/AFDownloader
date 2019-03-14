//
//  AFSession.swift
//  AFDownloader
//
//  Created by Arun Jose on 12/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation

public class AFSession: NSObject {
    public static let `default` = AFSession()
    var requestList = [AFRequest]()
    var taskToRequest = [URLSessionTask:[AFRequest]]()
    var taskToProcessingRequest = [URLSessionTask:[AFRequest]]()
    var cache = Cache<Data>(capacity: 10)
    
    public func downloadFileRequest(fileURL:URL) -> AFRequest{
        let cachedData = getCachedDataFor(url: fileURL)
        let downloadTask = createDownloadTask(withURL: fileURL)
        let request = AFRequest(url: fileURL, downloadTask: downloadTask, responseData:cachedData, delegate:self)
        if taskToRequest[downloadTask] == nil {
            taskToRequest[downloadTask] = Array<AFRequest>()
        }
        taskToRequest[downloadTask]?.append(request)
        return request
    }
    
    func getCachedDataFor(url:URL) -> Data? {
        if let cachedData = cache.getValue(for: url.absoluteString) {
            return cachedData
        }
        return nil
    }
    
    func createDownloadTask(withURL url:URL) -> URLSessionDownloadTask {
        if let exisitingRequest = checkURLInRequests(fileURL: url){
            return exisitingRequest.task
        }else{
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
            return session.downloadTask(with: url)
        }
    }
    
    func checkURLInRequests(fileURL: URL) -> AFRequest? {
        for request in requestList{
            if request.fileURL == fileURL{
                return request
            }
        }
        return nil
    }
    
    func didFailTask(task:URLSessionTask, withError error: Error) {
        for request in taskToProcessingRequest[task] ?? []{
            request.setResponseError(errorInDownload: error)
            request.didFailTask()
        }
        taskToProcessingRequest[task]?.removeAll()
        for request in taskToRequest[task] ?? [] {
            request.responseError = error
        }
    }
    
    func didCompleteTask(task:URLSessionTask, withData data: Data) {
        if let urlString = task.currentRequest?.url?.absoluteString {
            cache.setValue(data, for:urlString)
        }
        for request in taskToProcessingRequest[task] ?? [] {
            request.setResponseData(downlaodedData: data)
            request.didCompleteTask()
        }
        taskToProcessingRequest[task]?.removeAll()
        for request in taskToRequest[task] ?? [] {
            request.responseData = data
        }
    }
    
}

extension AFSession:RequestDelegate{
    
    func start(request: AFRequest) {
        if request.responseData != nil {
            request.didCompleteTask()
        } else if request.responseError != nil {
            request.didFailTask()
        }else {
            if taskToProcessingRequest[request.task] == nil {
                taskToProcessingRequest[request.task] = Array<AFRequest>()
            }
            taskToProcessingRequest[request.task]?.append(request)
            if taskToProcessingRequest[request.task]?.count == 1 {
                request.task.resume()
            }
        }
        if let index = taskToRequest[request.task]?.index(where: { $0 === request }) {
            taskToRequest[request.task]?.remove(at: index)
        }
    }
    
    func cancel(request: AFRequest) {
        if taskToProcessingRequest[request.task]?.count == 1 && taskToRequest[request.task]?.count == 0 {
            request.task.cancel()
            return
        }
        if let index = taskToProcessingRequest[request.task]?.index(where: { $0 === request }) {
            let request = taskToProcessingRequest[request.task]?.remove(at: index)
            if let error = (CFNetworkErrors.cfurlErrorCancelled as? Error) {
                request?.setResponseError(errorInDownload:error)
            }
            request?.didFailTask()
        }
    }
    
    
}

extension AFSession: URLSessionDownloadDelegate{
    // MARK: - URLSession download delegates
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                           didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                           totalBytesExpectedToWrite: Int64) {
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            let fileData:Data = try Data(contentsOf: location)
            didCompleteTask(task: downloadTask, withData: fileData)
        } catch {
            didFailTask(task: downloadTask, withError: error)
        }
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error{
            didFailTask(task: task, withError: error)
        }
    }
}
