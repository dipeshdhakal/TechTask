//
//  RaceListViewModel.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation
import Combine

extension RaceDisplayable.Category {
    
    var title: String {
        switch self {
        case .greyhound:
            return "Greyhound racing"
        case .harness:
            return "Harness racing"
        case .horse:
            return "Horse racing"
        }
    }
    
    var iconName: String {
        switch self {
        case .greyhound:
            return "icon-greyhound"
        case .harness:
            return "icon-harness"
        case .horse:
            return "icon-horse"
        }
    }
}

enum DataState {
    case loaded
    case loading
    case error(message: String)
}

class RaceListViewModel: ObservableObject {
    
    @Published var dataState: DataState = .loading
    @Published var races: [RaceDisplayable] = []
    @Published var selectedCategories = RaceDisplayable.Category.allCases
    @Published var allCategories: [Selected<RaceDisplayable.Category>] = []
    
    private var cancelabels = Set<AnyCancellable>()
    private var raceManager: RacesManagable
    
    init(raceManager: RacesManagable = RacesManager()) {
        
        self.raceManager = isUITest ? MockRacesManagable() : raceManager
        
        $selectedCategories
            .sink { categories in
                self.allCategories = RaceDisplayable.Category.allCases.map { Selected(element: $0, selected: categories.contains($0)) }
        }
        .store(in: &cancelabels)
        
        Task {
            await observeStream()
        }
        
        Task {
            await fetchData()
        }
    }
    
    func observeStream() async {
        for await races in self.raceManager.raceStream {
            await MainActor.run {
                self.dataState = .loaded
                self.races = races
            }
        }
    }
    
    func fetchData() async {
        do {
            try await self.raceManager.startAPICall()
        } catch {
            dataState = .error(message: error.localizedDescription)
        }
    }
    
    func updateCategory(category: RaceDisplayable.Category) {
        
        if let index = selectedCategories.firstIndex(where: { $0 == category }) {
            if selectedCategories.count == 1 { // Last category also unselected
                selectedCategories = RaceDisplayable.Category.allCases // Select all categories
            } else {
                selectedCategories.remove(at: index)
            }
        } else {
            selectedCategories.append(category)
        }
        
        Task { @MainActor in
            do {
                self.dataState = .loading
                try await self.raceManager.updateFilters(categories: selectedCategories)
                self.dataState = .loaded
            } catch {
                self.dataState = .error(message: error.localizedDescription)
            }
        }
    }
    
}
