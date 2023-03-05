//
//  EventCell.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 05/03/2023.
//

import UIKit

final class EventCell: UITableViewCell {
    var viewModel: EventCellViewModel?
    
    private let yearLabel = UILabel()
    private let monthLabel = UILabel()
    private let weekLabel = UILabel()
    private let daysLabel = UILabel()
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
        yearLabel.text = viewModel?.yearText
        monthLabel.text = viewModel?.monthText
        weekLabel.text = viewModel?.weekText
        daysLabel.text = viewModel?.dayText
        dateLabel.text = viewModel?.dateText
        eventNameLabel.text = viewModel?.eventName
        backgroundImageView.image = viewModel?.image
    }
    
    // Ustawienie odpowiednich cech dla elementów widoku
    private func setupViews() {
        [yearLabel, monthLabel, weekLabel, daysLabel, dateLabel, eventNameLabel, backgroundImageView, verticalStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [yearLabel, monthLabel, weekLabel, daysLabel].forEach {
            $0.font = .systemFont(ofSize: 28, weight: .medium)
            $0.textColor = .white
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
        
        verticalStackView.addArrangedSubview(yearLabel)
        verticalStackView.addArrangedSubview(monthLabel)
        verticalStackView.addArrangedSubview(weekLabel)
        verticalStackView.addArrangedSubview(daysLabel)
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
