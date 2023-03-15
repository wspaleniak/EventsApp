//
//  EventCell.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 05/03/2023.
//

import UIKit

final class EventCell: UITableViewCell {
    var viewModel: EventCellViewModel?
    
    private let timeRemainigStackView = TimeRemainingStackView()
    private let dateLabel = UILabel()
    private let eventNameLabel = UILabel()
    private let backgroundImageView = UIImageView()
    private let verticalStackView = UIStackView()
    
    // Metoda init wywołuje 3 prywatne metody utworzone poniżej
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Funkcja ta wywoływana jest podczas ustawiania cellki w tabeli
    // Ustawia dane na bazie View Modelu
    // ZAWSZE wszelkie dane do widoku przekazujemy poprzez ViewModel
    func update() {
        timeRemainigStackView.viewModel = viewModel?.timeRemainingViewModel
        timeRemainigStackView.update()
        dateLabel.text = viewModel?.dateText
        eventNameLabel.text = viewModel?.eventName
        viewModel?.loadImage { image in
            self.backgroundImageView.image = image
        }
    }
    
    // Ustawienie odpowiednich cech dla elementów widoku
    private func setupViews() {
        timeRemainigStackView.setup()
        
        [dateLabel, eventNameLabel, backgroundImageView, verticalStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        dateLabel.font = .systemFont(ofSize: 20, weight: .medium)
        dateLabel.textColor = .white
        
        eventNameLabel.font = .systemFont(ofSize: 34, weight: .bold)
        eventNameLabel.textColor = .white
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .trailing
        
        backgroundImageView.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    // Dodanie elementów do innych elementów, etc.
    private func setupHierarchy() {
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(timeRemainigStackView)
        verticalStackView.addArrangedSubview(UIView())
        verticalStackView.addArrangedSubview(dateLabel)
    }
    
    // Ustawienie constraints dla Vertical Stack View
    private func setupLayout() {
        backgroundImageView.pinToSuperviewEdges(edges: [.top, .right, .left])
        let bottomConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = .required - 1
        bottomConstraint.isActive = true
        
        backgroundImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        verticalStackView.pinToSuperviewEdges(edges: [.top, .right, .bottom], constant: 15)
        eventNameLabel.pinToSuperviewEdges(edges: [.bottom, .left], constant: 15)
    }
}
