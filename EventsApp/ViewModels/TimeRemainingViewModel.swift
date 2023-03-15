//
//  TimeRemainingViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 15/03/2023.
//

import UIKit

final class TimeRemainingViewModel {
    
    // Mode w zależności czy będziemy go używać do wyświetlania daty w EventList, czy w EventDetail
    enum Mode {
        case cell
        case detail
    }
    
    let timeRemainingParts: [String]
    private let mode: Mode
    
    var fontSize: CGFloat {
        switch mode {
        case .cell:
            return 25.0
        case .detail:
            return 60.0
        }
    }
    
    var alignment: UIStackView.Alignment {
        switch mode {
        case .cell:
            return .trailing
        case .detail:
            return .center
        }
    }
    
    init(timeRemainingParts: [String], mode: Mode) {
        self.timeRemainingParts = timeRemainingParts
        self.mode = mode
    }
}
