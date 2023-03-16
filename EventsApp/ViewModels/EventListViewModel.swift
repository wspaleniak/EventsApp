//
//  EventListViewModel.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import Foundation

// MARK: - ViewModel zarządzający widokiem EventList
final class EventListViewModel {
    enum Cell {
        case event(EventCellViewModel)
    }
    
    let title = "Events"
    private(set) var cells: [Cell] = []
    private let eventService: EventServiceProtocol
    weak var coordinator: EventListCoordinator?
    var onUpdate: () -> Void = {}   // pozwala odświeżyć tablicę zdefiniowaną w kontrolerze
    
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
    }
    
    // Metoda wywoływana podczas ładowania widoku kontrolera
    func viewDidLoad() {
        reload()
    }
    
    // Wykonywanie tej funkcji przypisujemy w kooordynatorze, gdy jego dziecko skończy działanie
    func reload() {
        EventCellViewModel.imageCache.removeAllObjects()
        let events = eventService.getAllEvents()
        cells = events.map {
            var eventCellViewModel = EventCellViewModel(event: $0)
            if let coordinator = coordinator {
                eventCellViewModel.onSelect = coordinator.onSelect
            }
            return .event(eventCellViewModel)
        }
        onUpdate()
    }
    
    // Metoda wywoływana podczas naciśnięcia przycisku dodawania nowego eventu
    // Przekazuje działanie do kooordynatora
    func addEventBtnTapped() {
        coordinator?.startAddEvent()
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
    
    // Metoda wywoływana podczas kliknięcia w cellkę na kontrolerze widoku
    func didSelectRow(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .event(let eventCellViewModel):
            eventCellViewModel.didSelect()
        }
    }
    
    // Metoda wywoływana podczas usuwania wybranego eventu
    func deleteEvent(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .event(let eventCellViewModel):
            eventService.deleteEvent(id: eventCellViewModel.event.objectID)
        }
        reload()
    }
}
