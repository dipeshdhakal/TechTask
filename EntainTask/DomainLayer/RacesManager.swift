//
//  RacesManager.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation

class RacesManager: RacesManagable {
    
    // https://github.com/apple/swift-evolution/blob/main/proposals/0388-async-stream-factory.md
    private var continuation: AsyncStream<[RaceDisplayable]>.Continuation?
    private var service: RaceServiceable
    private var categories: [RaceDisplayable.Category]?
    private var apiTask: Task<Void, Never>?
    private var scheduleTimer: Timer?
    var raceDisplayables: [RaceDisplayable] = []

    // https://forums.swift.org/t/unlike-other-continuations-in-swift-asyncstream-continuation-supports-escaping/53254/5
    // Sends stream of `RaceDisplayable` array to the stream observer
    lazy var raceStream = AsyncStream<[RaceDisplayable]> { continuation in
        self.continuation = continuation
        
        continuation.onTermination = { @Sendable _ in
            self.stopAPICalls()
        }
    }
    
    init(service: RaceServiceable = RaceService()) {
        self.service = service
    }
    
    func startAPICall() async throws {
        let races = try await service.fetchRaces()
        // TODO: - Ideally we should apply filter in the API by passing categoryIDs as a query parameter because we don't know if response will have at least 5 items for each categories. If this is a backend limitation, we will need some analytics data for best `count` query parameter. If the response still won't have n items to display in the UI, we should increament the count and make API call again until we get minimum number of items to display in the UI. We should have a miximum limit and handle error in UI so that we don't get stuck in the loop.
        raceDisplayables = races.races.map(\.raceDisplayable)
        publishFilteredRaces()
    }
    
    func publishFilteredRaces() {
        let filteredSortedRaces = raceDisplayables.filter { race in
            let timeLeft = race.startTime.timeIntervalSinceNow
            return timeLeft > -60 && categories?.contains(race.category) ?? true
        }
        .sorted {  $0.startTime <= $1.startTime }
        continuation?.yield(Array(filteredSortedRaces.prefix(5))) // Fire Async stream with latest filtered and sorted races
        if filteredSortedRaces.count < 5 {
            apiTask = Task {
                do {
                    // Fire next API call because we no longer have at least 5 valid races
                    try await startAPICall()
                } catch {
                    //TODO: - Unhandled error.
                    print(error.localizedDescription)
                }
            }
        } else {
            // Schedule next calculation
            scheduleNextCalculation(expiryTime: filteredSortedRaces.first?.startTime ?? Date.now)
        }
    }
    
    func updateFilters(categories: [RaceDisplayable.Category]? = nil) async throws {
        self.categories = categories
        try await startAPICall()
    }
    
    // A method that takes expiry date of oldest race in the list and schedules next calculation before race oldest expiry so that the data is always updated automatically.
    func scheduleNextCalculation(expiryTime: Date) {
        let expiryDate = expiryTime.withAddingValue(1, to: .minute) ?? .now // Add 1 minute to the start time (get expiry time).
        // Schedule next timer after the latest race is expired.
        scheduleTimer?.invalidate()
        scheduleTimer = Timer(fireAt: expiryDate, interval: 0, target: self, selector: #selector(calculateNextRaces), userInfo: nil, repeats: false)
        if let scheduleTimer {
            RunLoop.main.add(scheduleTimer, forMode: .common)
        }
    }
    
    @objc func calculateNextRaces() {
        publishFilteredRaces()
    }
    
    func stopAPICalls() {
        apiTask?.cancel()
        scheduleTimer?.invalidate()
    }
        
}
