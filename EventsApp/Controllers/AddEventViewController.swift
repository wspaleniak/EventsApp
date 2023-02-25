//
//  AddEventViewController.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 25/02/2023.
//

import UIKit

class AddEventViewController: UIViewController {

    var viewModel: AddEventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel?.viewDidDisappear()
    }
}
