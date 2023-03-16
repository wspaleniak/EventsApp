//
//  EventDetailViewController.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 15/03/2023.
//

import UIKit

// MARK: - Kontroler widoku dla EventDetail
class EventDetailViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timeRemainingStackView: TimeRemainingStackView!
    
    // Definicja ViewModel dla zarządzania widokiem
    // ZAWSZE wszelkie dane do widoku przekazujemy poprzez ViewModel
    var viewModel: EventDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel?.onUpdate = { [weak self] in
            self?.setupStackView()
            self?.backgroundImageView.image = self?.viewModel?.image
            self?.timeRemainingStackView.update()
            // event name label
            // date label
        }
        viewModel?.viewDidLoad()
    }
    
    // Metoda wywoływana w momencie zamykania widoku
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisappear()
    }

    // Metoda wewnętrz której ustawiamy widok UIStackView oraz przypisujemy mu wybrany ViewModel, który nim zarządza
    func setupStackView() {
        timeRemainingStackView.setup()
        self.timeRemainingStackView.viewModel = self.viewModel?.timeRemainingViewModel
    }
    
    func setupViews() {
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "pencil"), style: .plain, target: viewModel, action: #selector(viewModel?.editButtonTapped))
    }
}