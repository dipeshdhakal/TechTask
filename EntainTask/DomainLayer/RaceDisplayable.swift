//
//  RaceDisplayable.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation

public struct RaceDisplayable: Identifiable {

    public let id: String
    public let category: Category
    public let name: String
    public let number: String
    public let meeting: String
    public let startTime: Date

    /// A convenience initialiser to be used for mocking and testing purposes
    public init(
        id: String,
        category: Category,
        name: String,
        number: String,
        meeting: String,
        startTime: Date
    ) {
        self.id = id
        self.category = category
        self.name = name
        self.number = number
        self.meeting = meeting
        self.startTime = startTime
    }

}

public extension RaceDisplayable {

    enum Category: String, CaseIterable {
        case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
        case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
        case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    }

}

extension RaceDisplayable: Hashable {

    public static func == (lhs: RaceDisplayable, rhs: RaceDisplayable) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(category)
        hasher.combine(name)
        hasher.combine(meeting)
    }

}

extension RaceResponse {
    var raceDisplayable: RaceDisplayable {
        return .init(id: raceID, category: RaceDisplayable.Category(rawValue: categoryID) ?? .greyhound, name: raceName ?? "", number: "\(raceNumber)", meeting: meetingName ?? "", startTime: Date(timeIntervalSince1970: TimeInterval(advertisedStartTime)))
    }
}

extension RaceDisplayable: Comparable {
    public static func < (lhs: RaceDisplayable, rhs: RaceDisplayable) -> Bool {
        return lhs.startTime < rhs.startTime
    }
}
