//
//  RacesServiceMock.swift
//  EntainTaskTests
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation
@testable import EntainTask

final class RacesServiceMock: Mockable, RaceServiceable {
    
    func fetchRaces() async throws -> RacesResponse {
        return try loadJSON(filename: "race_response", type: RacesResponse.self)
    }

}
