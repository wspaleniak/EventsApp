//
//  EventListViewController.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 22/02/2023.
//

import UIKit

// MARK: - Kontroler widoku dla EventList
class EventListViewController: UIViewController {

    // Definicja ViewModel dla zarządzanai widokiem
    // ZAWSZE wszelkie dane do widoku przekazujemy poprzez ViewModel
    var viewModel: EventListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // Ustawianie widoku wywoływane podczas jego ładowania
    private func setupViews() {
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
