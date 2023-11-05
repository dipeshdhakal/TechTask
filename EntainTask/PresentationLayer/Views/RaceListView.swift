//
//  RaceListView.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 27/10/2023.
//

import Foundation
import SwiftUI

struct RaceListView: View {
    
    @StateObject var viewModel = RaceListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ForEach(viewModel.allCategories, id: \.id) { category in
                        HStack(spacing: 8) {
                            Image(category.element.iconName)
                                .resizable()
                                .foregroundColor(category.color)
                                .frame(width: 50, height: 40)
                            Image(systemName: category.selected ?
                                  "checkmark.circle.fill" : "circle")
                        }
                        .accessibilityElement(children: .combine)
                        .foregroundColor(category.color)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(color: category.color,
                                        radius: 3,
                                    x: 0, y: 0))
                        .padding(.horizontal, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.updateCategory(category: category.element)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityIdentifier(category.element.title)
                        .accessibilityLabel(category.element.title)
                        .accessibilityHint("Tap to filter by categories")
                    }
                }
                .padding(.top, 20)
                ZStack {
                    switch viewModel.dataState {
                    case .loading:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .error(let message):
                        ContentUnavailableView {
                            Text(message)
                        } description: {
                            Text("Please try again later")
                        } actions: {
                            
                        }
                    case .loaded:
                        List {
                            ForEach(viewModel.races, id: \.id) { race in
                                RaceView(viewModel: RaceViewModel(race: race))
                            }
                        }
                        .listStyle(.inset)
                    }
                }
                Spacer()
            }
            .navigationTitle("Next to go")
            .refreshable {
                await viewModel.fetchData()
            }
        }
    }
}

#Preview {
    RaceListView(viewModel: RaceListViewModel(raceManager: MockRacesManagable()))
}
