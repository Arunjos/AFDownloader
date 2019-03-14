//
//  Tests.swift
//  Tests
//
//  Created by Arun Jose on 14/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import XCTest
import AFDownloader
import UIKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAFImageDownload() {
        //get test image 1 for comparing with finalresult
        guard let testImage1 = UIImage(named: "test_image1.png", in: Bundle(for:type(of:self)), compatibleWith: nil) else{
            XCTAssert(false, "Failed to get test image");
            return
        }
        let testImageData = UIImagePNGRepresentation(testImage1)
        
        // get stub url for download
        let bundle = Bundle(for: type(of: self))
        guard let testUrl = bundle.url(forResource: "test_image1", withExtension: "png") else {
            XCTAssert(false, "Failed to create stub url");
            return
        }
        
        let promise = expectation(description: "Simple Request")
        AFDownloader.downloadFileRequest(fileURL: testUrl).responseImage(completionHandler: { afResponse, error in
            
            guard let responseImage = afResponse?.response else{
                XCTAssert(false, "Failed to get response from AFDownloader");
                return
            }
            let responseImageData = UIImagePNGRepresentation(responseImage)
            
            XCTAssertTrue(testImageData == responseImageData)
            promise.fulfill()
            
        }).start()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testAFDownloadCancel() {
        // get stub url for download
        let bundle = Bundle(for: type(of: self))
        guard let testUrl = bundle.url(forResource: "test_image_large", withExtension: "png") else {
            XCTAssert(false, "Failed to create stub url");
            return
        }

        let promise = expectation(description: "Simple Request")
        let afRequest = AFDownloader.downloadFileRequest(fileURL: testUrl).responseImage(completionHandler: { afResponse, error in
            if let error = error {
                XCTAssertTrue(error.localizedDescription == "cancelled")
            }else {
                XCTAssert(false, "Failed to cancel the request");
            }
            promise.fulfill()

        })
        afRequest.start()
        afRequest.cancel()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAFDownloadCancelSingleRequestFromMultiple() {
        
        guard let testImage1 = UIImage(named: "test_image_large.png", in: Bundle(for:type(of:self)), compatibleWith: nil) else{
            XCTAssert(false, "Failed to get test image");
            return
        }
        let testImageData = UIImagePNGRepresentation(testImage1)
        
        // get stub url for download
        let bundle = Bundle(for: type(of: self))
        guard let testUrl = bundle.url(forResource: "test_image_large", withExtension: "png") else {
            XCTAssert(false, "Failed to create stub url");
            return
        }
        
        let promise1 = expectation(description: "Simple Request1")
        let afRequest1 = AFDownloader.downloadFileRequest(fileURL: testUrl).responseImage(completionHandler: { afResponse, error in
            if let error = error {
                XCTAssertTrue(error.localizedDescription == "cancelled")
            }else {
                XCTAssert(false, "Failed to cancel the request");
            }
            promise1.fulfill()
            
        })
        
        let promise2 = expectation(description: "Simple Request2")
        let afRequest2 = AFDownloader.downloadFileRequest(fileURL: testUrl).responseImage(completionHandler: { afResponse, error in
            guard let responseImage = afResponse?.response else{
                XCTAssert(false, "Failed to get response from AFDownloader");
                return
            }
            let responseImageData = UIImagePNGRepresentation(responseImage)
            XCTAssertTrue(testImageData == responseImageData)
            promise2.fulfill()
            
        })
        afRequest1.start()
        afRequest2.start()
        
        afRequest1.cancel()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAFDownloadJSON() {
        let bundle = Bundle(for: type(of: self))
        guard let testUrl = bundle.url(forResource: "test_json", withExtension: "json") else {
            XCTAssert(false, "Failed to load local url");
            return
        }
        
        do {
            let jsonTestData = try Data(contentsOf: testUrl)
            let jsonTestObject = try JSONSerialization.jsonObject(with: jsonTestData, options: [])
        
        // get stub url for dowjsonTestDatanload
        guard let testStubUrl = bundle.url(forResource: "test_json", withExtension: "json") else {
            XCTAssert(false, "Failed to create stub url");
            return
        }
        
        let promise = expectation(description: "Simple Request")
        AFDownloader.downloadFileRequest(fileURL: testStubUrl).responseJSON(completionHandler: { afResponse, error in
            guard let responseJSON = afResponse?.response else{
                XCTAssert(false, "Failed to get response from AFDownloader");
                return
            }
            do {
                let responseJSONData = try JSONSerialization.data(withJSONObject: responseJSON, options: [])
                let testData = try JSONSerialization.data(withJSONObject: jsonTestObject, options: [])
                XCTAssertTrue(responseJSONData == testData)
                promise.fulfill()
            } catch {
                 XCTAssert(false, "Failed to get json data from response");
                promise.fulfill()
            }
            
        }).start()
        } catch {
            XCTAssert(false, "Failed to get data from url");
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testInvalidTypeFail() {
        let bundle = Bundle(for: type(of: self))
        // get stub url for dowjsonTestDatanload
        guard let testStubUrl = bundle.url(forResource: "test_json", withExtension: "json") else {
            XCTAssert(false, "Failed to create stub url");
            return
        }
        
        let promise = expectation(description: "Simple Request")
        AFDownloader.downloadFileRequest(fileURL: testStubUrl).responseImage(completionHandler: { afResponse, error in
            if let error = error, let afError = error as? AFError {
                XCTAssertTrue(afError == AFError.wrongTypeError)
            }else {
                XCTAssert(false, "Failed not throw error for invalid type");
            }
            promise.fulfill()
        }).start()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCacheCapacity() {
        let cache = Cache<Int>(capacity: 3)
        cache.setValue(1, for: "one")
        cache.setValue(2, for: "two")
        cache.setValue(3, for: "three")
        cache.setValue(4, for: "four")
        
        // here the value is not recently used
        if cache.getValue(for: "one") == nil {
            XCTAssert(true, "Successfully removed cache when exceed capacity")
        }else {
            XCTAssert(false, "Not removed exceeded record")
        }
    }
    
    func testDeleteNotRecentlyUsedInCache() {
        let cache = Cache<Int>(capacity: 3)
        cache.setValue(1, for: "one")
        cache.setValue(2, for: "two")
        cache.setValue(3, for: "three")
        
        _ = cache.getValue(for: "one")
        
        cache.setValue(4, for: "four")
        // here the value is not recently used
        if cache.getValue(for: "two") == nil {
            XCTAssert(true, "Successfully ignored not recently used item from cache")
        }else {
            XCTAssert(false, "Not recently used item still exist")
        }
    }
    
    func testCacheDeleteFunction() {
        let cache = Cache<Int>(capacity: 3)
        cache.setValue(1, for: "one")
        cache.setValue(2, for: "two")
        cache.setValue(3, for: "three")
        
        cache.deleteValue(for: "two")
        if cache.getValue(for: "two") == nil {
            XCTAssert(true, "Successfully deleted item")
        }else {
            XCTAssert(false, "Failed to download item")
        }
    }
}
