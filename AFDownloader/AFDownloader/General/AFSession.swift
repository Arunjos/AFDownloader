//
//  AFSession.swift
//  AFDownloader
//
//  Created by Arun Jose on 12/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import Foundation

open class AFSession: NSObject {
    public static let `default` = AFSession()
    private var requestList = [AFRequest]()
    private var taskToRequest = [URLSessionTask:[AFRequest]]()
    private var taskToProcessingRequest = [URLSessionTask:[AFRequest]]()
    
    public override init() {
        super.init()
    }
    
    public func downloadFileRequest(fileURL:URL) -> AFRequest{
        
        let downloadTask = createDownloadTask(withURL: fileURL)
        let request = AFRequest(url: fileURL, downloadTask: downloadTask, responseData:nil, delegate:self)
        if taskToRequest[downloadTask] == nil {
            taskToRequest[downloadTask] = Array<AFRequest>()
        }
        taskToRequest[downloadTask]?.append(request)
        return request
    }
    
    public func createDownloadTask(withURL url:URL) -> URLSessionDownloadTask {
        if let exisitingRequest = checkURLInRequests(fileURL: url){
            return exisitingRequest.task
        }else{
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
            return session.downloadTask(with: url)
        }
    }
    
    public func checkURLInRequests(fileURL: URL) -> AFRequest? {
        for request in requestList{
            if request.fileURL == fileURL{
                return request
            }
        }
        return nil
    }
    
    public func didFailTask(task:URLSessionTask, withError error: Error) {
        for request in taskToProcessingRequest[task] ?? []{
            request.setResponseError(errorInDownload: error)
            request.didFailTask()
        }
        taskToProcessingRequest[task]?.removeAll()
        for request in taskToRequest[task] ?? [] {
            request.responseError = error
        }
    }
    
    public func didCompleteTask(task:URLSessionTask, withData data: Data) {
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
    
    public func start(request: AFRequest) {
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
    
    public func cancel(request: AFRequest) {
        if let index = taskToProcessingRequest[request.task]?.index(where: { $0 === request }) {
            taskToProcessingRequest[request.task]?.remove(at: index)
        }
        if taskToProcessingRequest[request.task]?.count == 0 && taskToRequest[request.task]?.count == 0 {
            request.task.cancel()
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
