//
//  RaceService.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation

protocol RaceServiceable {
    func fetchRaces() async throws -> RacesResponse
}

struct RaceService: HTTPClient, RaceServiceable {
    func fetchRaces() async throws -> RacesResponse {
        return try await sendRequest(endpoint: RacesEndpoint.listRaces, responseModel: RacesResponse.self)
    }
}
