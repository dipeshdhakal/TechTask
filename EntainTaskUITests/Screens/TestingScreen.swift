//
//  TestingBase.swift
//  EntainTaskUITests
//
//  Created by Dipesh Dhakal on 05/11/2023.
//

import XCTest

class TestingBase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["IS_UI_TEST"]
        app.launch()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
    }
}

class BaseScreen {
    static var UITestDelay: TimeInterval = 3

    let test: TestingBase!

    init(_ test: TestingBase) {
        self.test = test
    }
}

extension XCTestCase {
    func waitForCondition(element: XCUIElement, predicate: NSPredicate, timeout: TimeInterval = BaseScreen.UITestDelay) {
        let conditionalExpectation = expectation(for: predicate, evaluatedWith: element, handler: nil)
        wait(for: [conditionalExpectation], timeout: timeout)
    }

    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = BaseScreen.UITestDelay) {
        waitForCondition(element: element, predicate: NSPredicate(format: "exists == true"), timeout: timeout)
    }

    func waitForElementToDisappear(_ element: XCUIElement, timeout: TimeInterval = BaseScreen.UITestDelay) {
        waitForCondition(element: element, predicate: NSPredicate(format: "exists == false"), timeout: timeout)
    }
}
