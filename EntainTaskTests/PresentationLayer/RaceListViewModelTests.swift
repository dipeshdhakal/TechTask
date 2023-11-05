//
//  RaceListViewModelTests.swift
//  EntainTaskTests
//
//  Created by Dipesh Dhakal on 5/11/2023.
//

import XCTest
@testable import EntainTask

final class RaceListViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCategoriesList() {
        let categories = RaceDisplayable.Category.allCases
        XCTAssertEqual(categories.count, 3)
        XCTAssertEqual(categories[0].rawValue, "4a2788f8-e825-4d36-9894-efd4baf1cfae")
        XCTAssertEqual(categories[0].title, "Horse racing")
        XCTAssertEqual(categories[0].iconName, "icon-horse")
        XCTAssertEqual(categories[1].rawValue, "9daef0d7-bf3c-4f50-921d-8e818c60fe61")
        XCTAssertEqual(categories[1].title, "Greyhound racing")
        XCTAssertEqual(categories[1].iconName, "icon-greyhound")
        XCTAssertEqual(categories[2].rawValue, "161d9be2-e909-4326-8c2c-35ed71fb460b")
        XCTAssertEqual(categories[2].title, "Harness racing")
        XCTAssertEqual(categories[2].iconName, "icon-harness")
    }

    func testFetchListSuccess() throws {
        let expectation = expectation(description: "Data fetched")
        let mockRaceManager =  MockRacesManagable()
        let viewModel = RaceListViewModel(raceManager: mockRaceManager)
        Task {
            for await races in mockRaceManager.raceStream {
                XCTAssertEqual(races.count, 7)
                sleep(1) // letting viewmodel get the async stream
                XCTAssertEqual(viewModel.races.count, 7)
                expectation.fulfill()
            }
        }
        Task {
            await viewModel.fetchData()
        }
        
        wait(for: [expectation], timeout: 5)
    }

}
