//
//  RaceManagerTests.swift
//  EntainTaskTests
//
//  Created by Dipesh Dhakal on 5/11/2023.
//

import XCTest
@testable import EntainTask

final class RaceManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartAPICall() async throws {
        let manager = RacesManager(service: MockRacesService())
        try await manager.startAPICall()
        XCTAssertEqual(manager.raceDisplayables.count, 8)
    }
    
    func testPublishedAsyncStreamSuccess() throws {
        let manager = RacesManager(service: MockRacesService())
        let expectation = expectation(description: "Async stream execution")
        
        Task {
            for await races in manager.raceStream {
                XCTAssertEqual(races.count, 5)
                expectation.fulfill()
            }
        }
        
        Task {
            try await manager.startAPICall()
        }
        wait(for: [expectation], timeout: 3)
    }

}


final class MockRacesService: RaceServiceable {
    
    func fetchRaces() async throws -> RacesResponse {
        let currentTime = Date.now
        return RacesResponse(races: [
            RaceResponse(raceID: "0", categoryID: "0", raceName: "Test race 00", raceNumber: 1, meetingName: "Test meeting 00", advertisedStartTime: UInt64(currentTime.timeIntervalSince1970)),
            RaceResponse(raceID: "1", categoryID: "0", raceName: "Test race 10", raceNumber: 2, meetingName: "Test meeting 10", advertisedStartTime: UInt64(currentTime.withAddingValue(65, to: .second)!.timeIntervalSince1970)),
            RaceResponse(raceID: "2", categoryID: "0", raceName: "Test race 20", raceNumber: 3, meetingName: "Test meeting 20", advertisedStartTime: UInt64(currentTime.withAddingValue(3, to: .minute)!.timeIntervalSince1970)),
            RaceResponse(raceID: "3", categoryID: "1", raceName: "Test race 31", raceNumber: 4, meetingName: "Test meeting 31", advertisedStartTime: UInt64(currentTime.withAddingValue(4, to: .minute)!.timeIntervalSince1970)),
            RaceResponse(raceID: "4", categoryID: "1", raceName: "Test race 41", raceNumber: 5, meetingName: "Test meeting 41", advertisedStartTime: UInt64(currentTime.withAddingValue(5, to: .minute)!.timeIntervalSince1970)),
            RaceResponse(raceID: "5", categoryID: "2", raceName: "Test race 52", raceNumber: 6, meetingName: "Test meeting 52", advertisedStartTime: UInt64(currentTime.withAddingValue(6, to: .minute)!.timeIntervalSince1970)),
            RaceResponse(raceID: "6", categoryID: "2", raceName: "Test race 62", raceNumber: 7, meetingName: "Test meeting 62", advertisedStartTime: UInt64(currentTime.timeIntervalSince1970)),
            RaceResponse(raceID: "7", categoryID: "2", raceName: "Test race 72", raceNumber: 8, meetingName: "Test meeting 72", advertisedStartTime: UInt64(currentTime.withAddingValue(-65, to: .second)!.timeIntervalSince1970))])
    }

}
