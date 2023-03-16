//
//  EditEventViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 15/03/2023.
//

import UIKit

// MARK: - ViewModel zarządzający widokiem AddEvent
final class EditEventViewModel {
    
    enum Cell {
        case titleSubtitle(TitleSubtitleCellViewModel)
    }
    
    let title = "Edit"
    private(set) var cells: [Cell] = []
    weak var coordinator: EditEventCoordinator?
    var onUpdate: () -> Void = {}   // pozwala odświeżyć tablicę zdefiniowaną w kontrolerze
    
    private var nameCellViewModel: TitleSubtitleCellViewModel?
    private var dateCellViewModel: TitleSubtitleCellViewModel?
    private var backgroundImageCellViewModel: TitleSubtitleCellViewModel?
    
    private let cellBuilder: EventsCellBuilder
    private let eventService: EventServiceProtocol
    private let event: Event
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    init(cellBuilder: EventsCellBuilder,
         eventService: EventServiceProtocol = EventService(),
         event: Event
    ) {
        self.cellBuilder = cellBuilder
        self.eventService = eventService
        self.event = event
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
            let data = EventService.EventInputData(name: name, date: date, image: image)
            eventService.perform(action: .update(event), data: data)
        }
        coordinator?.didFinishUpdateEvent()
    }
    
    // Aktualizowanie cellki
    func updateCell(indexPath: IndexPath, subtitle: String) {
        switch cells[indexPath.row] {
        case .titleSubtitle(let titleSubtitleCellViewModel):
            titleSubtitleCellViewModel.update(subtitle: subtitle)
        }
    }
    
    // Metoda wywoływana podczas kliknięcia w cellkę na kontrolerze widoku
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

private extension EditEventViewModel {
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
        
        guard let name = event.name,
            let date = event.date,
            let imageData = event.image,
            let image = UIImage(data: imageData)
        else { return }
        
        nameCellViewModel.update(subtitle: name)
        dateCellViewModel.update(date: date)
        backgroundImageCellViewModel.update(image: image)
    }
}
