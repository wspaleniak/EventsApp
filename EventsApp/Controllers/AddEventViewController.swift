//
//  AddEventViewController.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import UIKit

// MARK: - Kontroler widoku dla AddEvent
class AddEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Definicja ViewModel dla zarządzanai widokiem
    // ZAWSZE wszelkie dane do widoku przekazujemy poprzez ViewModel
    var viewModel: AddEventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(TitleSubtitleCell.self, forCellReuseIdentifier: "TitleSubtitleCell")
        
        viewModel?.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel?.viewDidLoad()
        
        
        navigationItem.title = viewModel?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        // Wymuszenie pokazywania się dużego tytułu bez przewijania strony
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.setContentOffset(.init(x: 0, y: -1), animated: true)
    }
    
    // Metoda wywoływana w momencie zamykania
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.viewDidDisappear()
    }
}

// MARK: - Ustawienie właściwości dla Table View
extension AddEventViewController: UITableViewDataSource {
    // Użycie metody numberOfRows() z ViewModel
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    // Ustawianie cellki w zależności od typu elementu (enum Cell)
    // Pobiera elementy z tablicy cells z ViewModel
    // Użycie metody cell(for:) z ViewModel
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.cell(for: indexPath) else { return UITableViewCell() }
        switch cellViewModel {
        case .titleSubtitle(let titleSubtitleCellViewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleSubtitleCell", for: indexPath) as? TitleSubtitleCell else { return UITableViewCell() }
            cell.update(with: titleSubtitleCellViewModel)
            return cell
        case .titleImage:
            return UITableViewCell()
        }
    }
}
