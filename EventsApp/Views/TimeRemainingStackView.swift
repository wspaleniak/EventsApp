//
//  TimeRemainingStackView.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 15/03/2023.
//

import UIKit

final class TimeRemainingStackView: UIStackView {
    private let timeRemainigLabels = [UILabel(), UILabel(), UILabel(), UILabel()]
    
    var viewModel: TimeRemainingViewModel?
    
    func setup() {
        timeRemainigLabels.forEach {
            self.addArrangedSubview($0)
        }
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func update() {
        guard let viewModel = viewModel else { return }
        timeRemainigLabels.forEach {
            $0.text = ""
            $0.font = .systemFont(ofSize: viewModel.fontSize, weight: .medium)
            $0.textColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowRadius = 4.0
            $0.layer.shadowOffset = CGSize()
        }
        viewModel.timeRemainingParts.enumerated().forEach {
            timeRemainigLabels[$0.offset].text = $0.element
        }
        self.alignment = viewModel.alignment
    }
}
