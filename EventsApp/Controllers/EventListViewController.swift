//
//  EventListViewController.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 22/02/2023.
//

import UIKit

class EventListViewController: UIViewController {

    var viewModel: EventListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let plusImage = UIImage(systemName: "plus.circle.fill")
        let addEventBtn = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addEventBtnTapped))
        addEventBtn.tintColor = .primary
        navigationItem.rightBarButtonItem = addEventBtn
        navigationItem.title = viewModel?.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func addEventBtnTapped() {
        viewModel?.addEventBtnTapped()
    }
}
