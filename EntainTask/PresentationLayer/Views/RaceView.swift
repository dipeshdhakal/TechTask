//
//  RaceView.swift
//  EntainTask
//
//  Created by Dipesh Dhakal on 31/10/2023.
//

import SwiftUI

struct RaceView: View {
    
    @ObservedObject var viewModel: RaceViewModel
    
    var body: some View {
        HStack {
            Image(viewModel.iconName)
                .resizable()
                .foregroundColor(Color.brandColor)
                .frame(width: 80, height: 80)
            VStack(alignment: .leading) {
                Text(viewModel.raceName)
                    .foregroundColor(Color.brandColor)
                    .font(.title)
                    .lineLimit(2)
                Text(viewModel.raceMeeting)
                    .font(.title2)
                    .lineLimit(1)
                Text(viewModel.countdownText ?? "")
                    .foregroundColor(viewModel.countDownTime > .zero ? .primary : .red)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityIdentifier(viewModel.raceID)
        .accessibilityLabel(viewModel.accessibilityLabel)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Tap to view race detail")
    }
}

#Preview {
    RaceView(viewModel: RaceViewModel(race: .init(id: "0", category: .greyhound, name: "Test greyhound Race1", number: "00012", meeting: "Test GH meeting 1", startTime: .now.withAddingValue(40, to: .second) ?? .now)))
}
