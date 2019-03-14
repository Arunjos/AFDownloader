//
//  AFDownloader_DemoTests.swift
//  AFDownloader-DemoTests
//
//  Created by Arun Jose on 13/03/19.
//  Copyright © 2019 Arun Jose. All rights reserved.
//

import XCTest
@testable import AFDownloader_Demo
@testable import AFDownloader

class AFDownloader_DemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAFDownload() {
        guard let testImage1 = UIImage(named:"test_image1") else{
            print("aaa")
            return
        }
        let testImageData = UIImagePNGRepresentation(testImage1)
        guard let testUrl = URL(string: "https://images.unsplash12.com/profile-fb-1464533812-a91a557e646d.jpg?ixlib=rb-0.3.5\u{0026}q=80\u{0026}fm=jpg\u{0026}crop=faces\u{0026}fit=crop\u{0026}h=128\u{0026}w=128\u{0026}s=512955d67915413e3a20fb8fdbfcdc76") else {
            print("bbb")
            return }
        let promise = expectation(description: "Simple Request")
        AFDownloader.downloadFileRequest(fileURL: testUrl).responseImage(completionHandler: {afResponse, error in
            guard let responseImage = afResponse?.response else{
                print("ccc")
                return
            }
            let responseImageData = UIImagePNGRepresentation(responseImage)
            XCTAssertTrue(testImageData == responseImageData)
            promise.fulfill()
        }).start()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
