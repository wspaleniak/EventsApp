//
//  TitleSubtitleCell.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import UIKit

final class TitleSubtitleCell: UITableViewCell {
    var viewModel: TitleSubtitleCellViewModel?
    
    private let titleLabel = UILabel()
    let subtitleTextField = UITextField()
    private let verticalStackView = UIStackView()
    private let constant: CGFloat = 15
    
    private let datePickerView = UIDatePicker()
    private let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 0, height: 35))
    lazy var doneButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
    }()
    
    private let photoImageView = UIImageView()
    
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
        titleLabel.text = viewModel?.title
        subtitleTextField.text = viewModel?.subtitle
        subtitleTextField.placeholder = viewModel?.placeholder
        
        subtitleTextField.inputView = viewModel?.type == .text ? nil : datePickerView
        subtitleTextField.inputAccessoryView = viewModel?.type == .text ? nil : toolbar
        
        subtitleTextField.isHidden = viewModel?.type == .image
        photoImageView.isHidden = viewModel?.type != .image
        
        verticalStackView.spacing = viewModel?.type == .image ? constant : verticalStackView.spacing
    }
    
    // Ustawienie odpowiednich cech dla elementów widoku
    private func setupViews() {
        verticalStackView.axis = .vertical
        titleLabel.font = .systemFont(ofSize: 22, weight: .medium)
        subtitleTextField.font = .systemFont(ofSize: 20, weight: .medium)
        
        [verticalStackView, titleLabel, subtitleTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.datePickerMode = .date
        toolbar.setItems([doneButton], animated: false)
        
        photoImageView.layer.cornerRadius = constant
        photoImageView.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    // Dodanie elementów do innych elementów, etc.
    private func setupHierarchy() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleTextField)
        verticalStackView.addArrangedSubview(photoImageView)
    }
    
    // Ustawienie constraints dla Vertical Stack View
    private func setupLayout() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constant),
            verticalStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constant),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constant),
            verticalStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -constant)
        ])
        
        photoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    // Metoda wywoływana po kliknięciu przycisku 'Done' na UIDatePicker
    // Uaktualnia subtitle w ViewModel - dzięki temu w subtitle pokazuje się wybrana przez nas data
    @objc private func doneBtnTapped() {
        viewModel?.update(date: datePickerView.date)
    }
}
