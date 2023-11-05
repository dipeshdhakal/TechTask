//
//  RacesManagable.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation

protocol RacesManagable {
    var raceStream: AsyncStream<[RaceDisplayable]> { get set }
    var raceDisplayables: [RaceDisplayable] { get set }
    func startAPICall() async throws
    func updateFilters(categories: [RaceDisplayable.Category]?) async throws
}
