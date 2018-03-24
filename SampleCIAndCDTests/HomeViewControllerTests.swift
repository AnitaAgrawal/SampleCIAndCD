//
//  HomeViewControllerTests.swift
//  SampleCIAndCDTests
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import XCTest
@testable import SampleCIAndCD

class HomeViewControllerTests: XCTestCase {
    
    var viewController : HomeViewController?
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerIdentifier") as? HomeViewController
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testgetTheNextPageData() {
        XCTAssertNotNil(viewController?.getTheNextPageData())
    }
    
    func testgoToTheDetailView(){
        XCTAssertNotNil(viewController?.goToTheDetailView(displayData: UserData()))
        
    }
    
    func testmapViewTapped() {
        XCTAssertNotNil(viewController?.mapViewTapped())
    }
    
    func testlistViewTapped() {
        XCTAssertNotNil(viewController?.listViewTapped())
    }
    
    func testsearchStringUpdated() {
        XCTAssertNotNil(viewController?.searchStringUpdated(searchStr: "asfdgf"))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
