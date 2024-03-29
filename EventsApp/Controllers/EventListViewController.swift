//
//  EventListViewController.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 22/02/2023.
//

import UIKit

// MARK: - Kontroler widoku dla EventList
class EventListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Definicja ViewModel dla zarządzanai widokiem
    // ZAWSZE wszelkie dane do widoku przekazujemy poprzez ViewModel
    var viewModel: EventListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel?.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel?.viewDidLoad()
    }
    
    // Ustawianie widoku wywoływane podczas jego ładowania
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        
        let plusImage = UIImage(systemName: "plus.circle.fill")
        let addEventBtn = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addEventBtnTapped))
        addEventBtn.tintColor = .primary
        navigationItem.rightBarButtonItem = addEventBtn
        navigationItem.title = viewModel?.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // Akcja dla przycisku dodawania nowego wydarzenia
    // Przekazuje działanie do ViewModel, który następnie przekazuje je dalej do koordynatora
    @objc private func addEventBtnTapped() {
        viewModel?.addEventBtnTapped()
    }
}

// MARK: - Ustawienie właściwości dla Table View
extension EventListViewController: UITableViewDataSource {
    // Użycie metody numberOfRows() z ViewModel
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows() ?? 0
    }
    
    // Ustawianie cellki w zależności od typu elementu (enum Cell)
    // Pobiera elementy z tablicy cells z ViewModel
    // Użycie metody cell(for:) z ViewModel
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.cell(for: indexPath) else { return UITableViewCell() }
        switch cellViewModel {
        case .event(let eventCellViewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell else { return UITableViewCell() }
            cell.viewModel = eventCellViewModel
            cell.update()
            return cell
        }
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            self.viewModel?.deleteEvent(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
