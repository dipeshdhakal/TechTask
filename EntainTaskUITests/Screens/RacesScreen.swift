//
//  RacesScreen.swift
//  EntainTaskUITests
//
//  Created by Dipesh Dhakal on 05/11/2023.
//

import Foundation
import XCTest

class RacesScreen: BaseScreen {

    lazy var screen = test.app.otherElements.containing(.staticText, identifier: "Next to go")
    lazy var navBar: XCUIElement = screen.navigationBars.element
    lazy var collectionViewsQuery = screen.collectionViews
    lazy var horseFilterButton: XCUIElement = test.app.buttons["Horse racing"]
    lazy var greyhoundFilterButton: XCUIElement = test.app.buttons["Greyhound racing"]
    lazy var harnessFilterButton: XCUIElement = test.app.buttons["Harness racing"]
    lazy var raceItem: XCUIElement = test.app.buttons["0"]

    @discardableResult
    func navigateTo() -> Self {
        test.waitForElementToAppear(navBar)
        return self
    }

}
