//
//  RacesManagable+Mock.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation

class MockRacesManagable: RacesManagable {
    
    var continuation: AsyncStream<[RaceDisplayable]>.Continuation?
    var raceDisplayables = [RaceDisplayable.init(id: "0", category: .greyhound, name: "Test greyhound Race1", number: "00012", meeting: "Test GH meeting 1", startTime: Date.now.withAddingValue(50, to: .second)!),
                            .init(id: "1", category: .greyhound, name: "Test greyhound Race2", number: "00013", meeting: "Test GH meeting 2", startTime: Date.now.withAddingValue(20, to: .second)!),
                            .init(id: "2", category: .harness, name: "Test harness Race1", number: "00014", meeting: "Test HR meeting 1", startTime: Date.now.withAddingValue(30, to: .second)!),
                            .init(id: "3", category: .horse, name: "Test horse Race1", number: "00015", meeting: "Test H meeting 1", startTime: Date.now.withAddingValue(30, to: .second)!),
                            .init(id: "3", category: .horse, name: "Test horse Race1", number: "00015", meeting: "Test H meeting 1", startTime: Date.now.withAddingValue(30, to: .second)!),
                            .init(id: "3", category: .horse, name: "Test horse Race1", number: "00015", meeting: "Test H meeting 1", startTime: Date.now.withAddingValue(30, to: .second)!),
                            .init(id: "3", category: .horse, name: "Test horse Race1", number: "00015", meeting: "Test H meeting 1", startTime: .now)]
    
    lazy var raceStream = AsyncStream<[RaceDisplayable]> { continuation in
        self.continuation = continuation
    }
    
    func startAPICall() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        continuation?.yield(raceDisplayables)
    }
    
    func updateFilters(categories: [RaceDisplayable.Category]?) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let filteredData = raceDisplayables.filter { categories?.contains($0.category) ?? true}
        continuation?.yield(filteredData)
    }
    
}
