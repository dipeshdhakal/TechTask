//
//  RacesResponse.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation


public struct RacesResponse: Decodable {

    public let races: [RaceResponse]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedData = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        let dictArray = try nestedData.decode(Dictionary<String, RaceResponse>.self, forKey: CodingKeys.raceSummaries)
        self.races = dictArray.map { $1 }
            .sorted { $0.advertisedStartTime > $1.advertisedStartTime }
    }
    
    init(races: [RaceResponse]) {
        self.races = races
    }

    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case raceSummaries = "race_summaries"
    }

}

public struct RaceResponse: Decodable {
    
    public let raceID: String
    public let categoryID: String
    public let raceName: String?
    public let raceNumber: Int
    public let meetingName: String?
    public let advertisedStartTime: UInt64
    
    init(raceID: String, categoryID: String, raceName: String?, raceNumber: Int, meetingName: String?, advertisedStartTime: UInt64) {
        self.raceID = raceID
        self.categoryID = categoryID
        self.raceName = raceName
        self.raceNumber = raceNumber
        self.meetingName = meetingName
        self.advertisedStartTime = advertisedStartTime
    }
    
    private enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case categoryID = "category_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingName = "meeting_name"
        case advertisedStart = "advertised_start"
    }

    enum AdvertisedStartKeys: String, CodingKey {
        case seconds
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.raceID = try container.decode(String.self, forKey: .raceID)
        self.categoryID = try container.decode(String.self, forKey: .categoryID)
        self.raceName = try? container.decode(String.self, forKey: .raceName)
        self.raceNumber = try container.decode(Int.self, forKey: .raceNumber)
        self.meetingName = try? container.decode(String.self, forKey: .meetingName)

        let advertisedStart = try container.nestedContainer(keyedBy: AdvertisedStartKeys.self, forKey: .advertisedStart)
        self.advertisedStartTime = try advertisedStart.decode(UInt64.self, forKey: .seconds)
    }
}

