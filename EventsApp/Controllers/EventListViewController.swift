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
