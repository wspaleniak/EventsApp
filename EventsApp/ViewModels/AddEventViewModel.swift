//
//  AddEventViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import Foundation

// MARK: ViewModel zarządzający widokiem AddEvent
final class AddEventViewModel {
    enum Cell {
        case titleSubtitle(TitleSubtitleCellViewModel)
    }
    
    let title = "Add"
    private(set) var cells: [Cell] = []
    var coordinator: AddEventCoordinator?
    var onUpdate: () -> Void = {}   // pozwala odświeżyć tablicę zdefiniowaną w kontrolerze
    
    func viewDidLoad() {
        cells = [
            .titleSubtitle(TitleSubtitleCellViewModel(title: "Name", subtitle: "", placeholder: "Add a name...", type: .text, onCellUpdate: {})),
            .titleSubtitle(TitleSubtitleCellViewModel(title: "Date", subtitle: "", placeholder: "Select a date...", type: .date, onCellUpdate: { [weak self] in
                self?.onUpdate()
            })),
            .titleSubtitle(TitleSubtitleCellViewModel(title: "Background", subtitle: "", placeholder: "", type: .image, onCellUpdate: { [weak self] in
                self?.onUpdate()
            }))
        ]
        onUpdate()
    }
    
    // Metoda wywoływana podczas kończenia widoku
    // Przekazuje działanie do kooordynatora
    func viewDidDisappear() {
        coordinator?.didFinishAddEvent()
    }
    
    // Metoda zwraca ilość elementów w tablicy cells
    // Wywoływana podczas ustawiania właściwości TableView w kontrolerze
    func numberOfRows() -> Int {
        return cells.count
    }
    
    // Metoda zwracająca element z tablicy cells na podstawie IndexPath
    // Wywoływana podczas ustawiania właściwości TableView w kontrolerze
    func cell(for indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
    
    // Metoda wywoływana podczas kliknięcia w przycik 'Done' na kontrolerze
    func doneBtnTapped() {
        print("Done tapped!")
        // extract info from cell view model and save in core data
        // say coordinator to dismiss
    }
    
    // Aktualizowanie cellki
    func updateCell(indexPath: IndexPath, subtitle: String) {
        switch cells[indexPath.row] {
        case .titleSubtitle(let titleSubtitleCellViewModel):
            titleSubtitleCellViewModel.update(subtitle: subtitle)
        }
    }
}
