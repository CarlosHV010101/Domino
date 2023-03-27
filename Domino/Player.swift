//
//  Player.swift
//  Domino
//
//  Created by Administrador on 12/03/23.
//

import Foundation

///Clase de jugador
class Player {
    var id: UUID = UUID()
    var name: String
    var hand: [Domino]
    
    init(name: String, hand: [Domino]) {
        self.name = name
        self.hand = hand
    }
    
    func removeDomino(with id: Int) {
        hand.removeAll(where: { $0.id == id })
    }
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
    
    
}
