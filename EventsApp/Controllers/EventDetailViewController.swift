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
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    
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
            self?.eventNameLbl.text = self?.viewModel?.name
            self?.eventDateLbl.text = self?.viewModel?.dateText
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
        eventNameLbl.font = .systemFont(ofSize: 50, weight: .bold)
        eventNameLbl.textColor = .white
        eventNameLbl.layer.shadowColor = UIColor.black.cgColor
        eventNameLbl.layer.shadowOpacity = 0.7
        eventNameLbl.layer.shadowRadius = 4.0
        eventNameLbl.layer.shadowOffset = CGSize()
        
        eventDateLbl.font = .systemFont(ofSize: 25, weight: .medium)
        eventDateLbl.textColor = .white
        eventDateLbl.layer.shadowColor = UIColor.black.cgColor
        eventDateLbl.layer.shadowOpacity = 0.7
        eventDateLbl.layer.shadowRadius = 4.0
        eventDateLbl.layer.shadowOffset = CGSize()
        
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "pencil"), style: .plain, target: viewModel, action: #selector(viewModel?.editButtonTapped))
    }
}
