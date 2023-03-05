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
        setupViews()
        
        viewModel?.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel?.viewDidLoad()
    }
    
    // Metoda wywoływana w momencie zamykania widoku
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisappear()
    }
    
    // Metoda wywoływana podczas kliknięcia w przycisk 'Done'
    @objc private func doneBtnTapped() {
        viewModel?.doneBtnTapped()
    }
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TitleSubtitleCell.self, forCellReuseIdentifier: "TitleSubtitleCell")
        
        // Ustawienia dla NavigationController
        navigationItem.title = viewModel?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .white
        // Wymuszenie pokazywania się dużego tytułu bez przewijania strony
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.setContentOffset(.init(x: 0, y: -1), animated: true)
    }
}

// MARK: - Ustawienie właściwości dla Table View
extension AddEventViewController: UITableViewDataSource, UITableViewDelegate {
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
            cell.viewModel = titleSubtitleCellViewModel
            cell.update()
            cell.subtitleTextField.delegate = self
            return cell
        }
    }
    
    // Metoda wywoływana podczas kliknięcia w cellkę
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Delegat dla UITextField
extension AddEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        let text = currentText + string
        
        let point = textField.convert(textField.bounds.origin, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            viewModel?.updateCell(indexPath: indexPath, subtitle: text)
        }
        return true
    }
}
