//
//  ProfileUITests.swift
//  MessengerUITests
//
//  Created by Nikita Gundorin on 03.12.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

@testable import Messenger
import XCTest

class ProfileUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    func testTextViewsExists() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.otherElements["profileImageView"].tap()
        XCTAssertTrue(app.textViews["userDescription"].exists)
        XCTAssertTrue(app.textViews["userName"].exists)
    }
}
