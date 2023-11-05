//
//  RaceListUITests.swift
//  EntainTaskUITests
//
//  Created by Dipesh Dhakal on 05/11/2023.
//

import XCTest

final class RaceListUITests: TestingBase {
    
    var invoicesScreen: RacesScreen!

    override func setUpWithError() throws {
        try super.setUpWithError()
        invoicesScreen = RacesScreen(self)
        invoicesScreen.navigateTo()
    }

    func testAppLaunch() {
        XCTAssertNotNil(invoicesScreen.screen)
        XCTAssertTrue(invoicesScreen.navBar.exists)
        XCTAssertTrue(invoicesScreen.horseFilterButton.exists)
        XCTAssertTrue(invoicesScreen.greyhoundFilterButton.exists)
        XCTAssertTrue(invoicesScreen.harnessFilterButton.exists)
        XCTAssertTrue(invoicesScreen.raceItem.exists)
    }
}
