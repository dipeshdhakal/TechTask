//
//  RacesServiceTests.swift
//  EntainTaskTests
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import XCTest
@testable import EntainTask

final class RacesServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMoviesServiceMock() async {
        do {
            let serviceMock = RacesServiceMock()
            let racesResponse = try await serviceMock.fetchRaces()
            XCTAssertEqual(racesResponse.races.count, 10)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
