//
//  TitleSubtitleCellViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import Foundation

// MARK: - ViewModel zarządzający widokiem TitleSubtitleCell
final class TitleSubtitleCellViewModel {
    
    let title: String
    private(set) var subtitle: String
    let placeholder: String
    
    init(title: String, subtitle: String, placeholder: String) {
        self.title = title
        self.subtitle = subtitle
        self.placeholder = placeholder
    }
}
