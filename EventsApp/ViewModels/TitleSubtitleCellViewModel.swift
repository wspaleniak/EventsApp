//
//  TitleSubtitleCellViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import UIKit

// MARK: - ViewModel zarządzający widokiem TitleSubtitleCell
final class TitleSubtitleCellViewModel {
    enum CellType {
        case text
        case date
        case image
    }
    
    let title: String
    private(set) var subtitle: String
    let placeholder: String
    let type: CellType
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyy"
        return dateFormatter
    }()
    private(set) var image: UIImage?
    
    private(set) var onCellUpdate: (() -> Void)?
    
    init(title: String, subtitle: String, placeholder: String, type: CellType, onCellUpdate: (() -> Void)?) {
        self.title = title
        self.subtitle = subtitle
        self.placeholder = placeholder
        self.type = type
        self.onCellUpdate = onCellUpdate
    }
    
    func update(subtitle: String) {
        self.subtitle = subtitle
    }
    
    func update(date: Date) {
        let dateString = dateFormatter.string(from: date)
        self.subtitle = dateString
        onCellUpdate?()
    }
    
    func update(image: UIImage) {
        self.image = image
        onCellUpdate?()
    }
}
