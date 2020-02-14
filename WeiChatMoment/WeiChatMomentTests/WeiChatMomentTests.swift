//
//  WeiChatMomentTests.swift
//  WeiChatMomentTests
//
//  Created by lin kang on 2019/11/11.
//  Copyright © 2019 TW. All rights reserved.
//
import XCTest


class WeiChatMomentTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testLongImageURLPath(){

        DownLoadImageHelper.sharedInstance.loadImage(urlString: "http://pic26.nipic.com/pic/20121229/9252150_101107077359_4.jpg", completionHandler: { (image, url) in
            XCTAssertNotNil(image)
        } )
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
