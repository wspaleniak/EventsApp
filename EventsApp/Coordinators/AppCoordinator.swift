//
//  AppCoordinator.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 22/02/2023.
//

import UIKit

// MARK: - Protokół dla wszytskich koordynatorów
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    func start()
    func childDidFinish(childCoordinator: Coordinator)
}

extension Coordinator {
    // Usuwanie instancji widoku, gdy nie jest już używany (gdy widok zostaje zamknięty)
    func childDidFinish(childCoordinator: Coordinator) {}
}

// MARK: - Główny koordynator aplikacji
// Odpala widok z eventami - EventList
final class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // Wywołanie w SceneDelegate
    func start() {
        let navigationController = UINavigationController()
        
        let eventListCoordinator = EventListCoordinator(navigationController: navigationController)
        childCoordinators.append(eventListCoordinator)
        eventListCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
