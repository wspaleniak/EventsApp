//
//  UIView+Ex.swift
//  EventsApp
//
//  Created by Wojciech Spaleniak on 05/03/2023.
//

import UIKit

// Enum dla poniższego rozszerzenia
enum Edge {
    case top
    case right
    case bottom
    case left
}

// Poniższe rozszerzenie pozwala w łatwiejszy sposób ustawiać constraints dla elementów, na których wywołamy poniższą metodę
extension UIView {
    func pinToSuperviewEdges(edges: [Edge] = [.top, .right, .bottom, .left], constant: CGFloat = 0.0) {
        guard let superview = superview else { return }
        edges.forEach {
            switch $0 {
            case .top:
                topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
            case .right:
                rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -constant).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: superview.bottomAnchor,constant: -constant).isActive = true
            case .left:
                leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant).isActive = true
            }
        }
    }
}
