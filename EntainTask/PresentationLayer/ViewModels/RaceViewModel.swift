//
//  RaceViewModel.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 1/11/2023.
//

import Foundation
import Combine

final class RaceViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let race: RaceDisplayable
    @Published private(set) var countdownText: String?
    @Published private(set) var countDownTime = TimeInterval.zero
    private(set) var raceID: String
    private(set) var accessibilityLabel: String
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(race: RaceDisplayable) {
        
        self.race = race
        self.raceID = race.id
        self.accessibilityLabel = "Race of \(race.category.title) named \(race.name), meeting \(race.meeting), id\(race.id)"
        
        Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .prepend(Date.now)
            .sink { [weak self] _ in
                let time = race.startTime.timeIntervalSinceNow
                self?.countDownTime = time
                self?.countdownText = time.formattedCountDownTime
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Computed properties
    
    var iconName: String {
        return race.category.iconName
    }
    
    var raceName: String {
        return race.name
    }
    
    var raceMeeting: String {
        return race.meeting
    }
    
}
