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
    
    private var nameCellViewModel: TitleSubtitleCellViewModel?
    private var dateCellViewModel: TitleSubtitleCellViewModel?
    private var backgroundImageCellViewModel: TitleSubtitleCellViewModel?
    
    private let cellBuilder: EventsCellBuilder
    private let coreDataManager: CoreDataManager
    
    lazy var dateFormatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        return dateformatter
    }()
    
    init(cellBuilder: EventsCellBuilder, coreDataManager: CoreDataManager) {
        self.cellBuilder = cellBuilder
        self.coreDataManager = coreDataManager
    }
    
    // Metoda wywowływana podczas ładowania widoku kontrolera
    func viewDidLoad() {
        setupCells()
        onUpdate()
    }
    
    // Metoda wywoływana podczas kończenia widoku
    // Przekazuje działanie do kooordynatora
    func viewDidDisappear() {
        coordinator?.didFinish()
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
        if let name = nameCellViewModel?.subtitle,
           name.trimmingCharacters(in: .whitespaces) != "",
           let dateString = dateCellViewModel?.subtitle,
           let date = dateFormatter.date(from: dateString),
           let image = backgroundImageCellViewModel?.image {
            coreDataManager.saveEvent(name: name, date: date, image: image)
        }
        coordinator?.didFinishSaveEvent()
    }
    
    // Aktualizowanie cellki
    func updateCell(indexPath: IndexPath, subtitle: String) {
        switch cells[indexPath.row] {
        case .titleSubtitle(let titleSubtitleCellViewModel):
            titleSubtitleCellViewModel.update(subtitle: subtitle)
        }
    }
    
    // Metoda wywoływana podczas kliknięcia w cellkę na kontrolerze
    // Posiada logikę tylko dla typu .image ponieważ ma otwierać Image Picker
    func didSelectRow(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .titleSubtitle(let titleSubtitleCellViewModel):
            guard titleSubtitleCellViewModel.type == .image else { return }
            coordinator?.showImagePicker { image in
                titleSubtitleCellViewModel.update(image: image)
            }
        }
    }
}

private extension AddEventViewModel {
    func setupCells() {
        nameCellViewModel = cellBuilder.makeTitleSubtitleCellViewModel(type: .text)
        dateCellViewModel = cellBuilder.makeTitleSubtitleCellViewModel(type: .date) { [weak self] in
            self?.onUpdate()
        }
        backgroundImageCellViewModel = cellBuilder.makeTitleSubtitleCellViewModel(type: .image) { [weak self] in
            self?.onUpdate()
        }
        
        guard let nameCellViewModel = nameCellViewModel,
              let dateCellViewModel = dateCellViewModel,
              let backgroundImageCellViewModel = backgroundImageCellViewModel else { return }
        
        cells = [
            .titleSubtitle(nameCellViewModel),
            .titleSubtitle(dateCellViewModel),
            .titleSubtitle(backgroundImageCellViewModel)
        ]
    }
}
