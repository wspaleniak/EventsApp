//
//  EventsCellBuilder.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 05/03/2023.
//

import Foundation

struct EventsCellBuilder {
    func makeTitleSubtitleCellViewModel(type: TitleSubtitleCellViewModel.CellType, onCellUpdate: (() -> Void)? = nil) -> TitleSubtitleCellViewModel {
        switch type {
        case .text:
            return TitleSubtitleCellViewModel(
                title: "Name",
                subtitle: "",
                placeholder: "Add a name...",
                type: .text,
                onCellUpdate: onCellUpdate
            )
        case .date:
            return TitleSubtitleCellViewModel(
                title: "Date",
                subtitle: "",
                placeholder: "Select a date...",
                type: .date,
                onCellUpdate: onCellUpdate
            )
        case .image:
            return TitleSubtitleCellViewModel(
                title: "Background",
                subtitle: "",
                placeholder: "",
                type: .image,
                onCellUpdate: onCellUpdate
            )
        }
    }
}
