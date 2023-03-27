//
//  GameBrain.swift
//  Domino
//
//  Created by Administrador on 12/03/23.
//

import Foundation

///Estructura para el control de fichas
struct GameBrain {
    
    private var tales: [Domino] = [
        Domino(id: 1, imageName: "0_0", isMule: true, leftSide: 0, rightSide: 0),
        Domino(id: 2, imageName: "0_1", isMule: false, leftSide: 0, rightSide: 1),
        Domino(id: 3, imageName: "0_2", isMule: false, leftSide: 0, rightSide: 2),
        Domino(id: 4, imageName: "0_3", isMule: false, leftSide: 0, rightSide: 3),
        Domino(id: 5, imageName: "0_4", isMule: false, leftSide: 0, rightSide: 4),
        Domino(id: 6, imageName: "0_5", isMule: false, leftSide: 0, rightSide: 5),
        Domino(id: 7, imageName: "0_6", isMule: false, leftSide: 0, rightSide: 6),
        Domino(id: 8, imageName: "1_1", isMule: true, leftSide: 1, rightSide: 1),
        Domino(id: 9, imageName: "1_2", isMule: false, leftSide: 1, rightSide: 2),
        Domino(id: 10, imageName: "1_3", isMule: false, leftSide: 1, rightSide: 3),
        Domino(id: 11, imageName: "1_4", isMule: false, leftSide: 1, rightSide: 4),
        Domino(id: 12, imageName: "1_5", isMule: false, leftSide: 1, rightSide: 5),
        Domino(id: 13, imageName: "1_6", isMule: false, leftSide: 1, rightSide: 6),
        Domino(id: 14, imageName: "2_2", isMule: true, leftSide: 2, rightSide: 2),
        Domino(id: 15, imageName: "2_3", isMule: false, leftSide: 2, rightSide: 3),
        Domino(id: 16, imageName: "2_4", isMule: false, leftSide: 2, rightSide: 4),
        Domino(id: 17, imageName: "2_5", isMule: false, leftSide: 2, rightSide: 5),
        Domino(id: 18, imageName: "2_6", isMule: false, leftSide: 2, rightSide: 6),
        Domino(id: 19, imageName: "3_3", isMule: true, leftSide: 3, rightSide: 3),
        Domino(id: 20, imageName: "3_4", isMule: false, leftSide: 3, rightSide: 4),
        Domino(id: 21, imageName: "3_5", isMule: false, leftSide: 3, rightSide: 5),
        Domino(id: 22, imageName: "3_6", isMule: false, leftSide: 3, rightSide: 6),
        Domino(id: 23, imageName: "4_4", isMule: true, leftSide: 4, rightSide: 4),
        Domino(id: 24, imageName: "4_5", isMule: false, leftSide: 4, rightSide: 5),
        Domino(id: 25, imageName: "4_6", isMule: false, leftSide: 4, rightSide: 6),
        Domino(id: 26, imageName: "5_5", isMule: true, leftSide: 5, rightSide: 5),
        Domino(id: 27, imageName: "5_6", isMule: false, leftSide: 5, rightSide: 6),
        Domino(id: 28, imageName: "6_6", isMule: true, leftSide: 6, rightSide: 6)
    ]
    
    private var remainingTales: [Domino] = []
    
    mutating func shuffleAndAssignTales(player1: inout Player, player2: inout Player) {
        let shuffledTales = tales.shuffled()
                
        player1.hand = Array(shuffledTales[0...6])
        player2.hand = Array(shuffledTales[7...13])
        remainingTales = Array(shuffledTales.suffix(from: 14))
    }
    
    func getHigherMule(_ player: Player) -> Domino? {
        var mules: [Domino] = []
        
        for tale in player.hand where tale.isMule {
            mules.append(tale)
        }
        
        return mules.max { domino1, domino2 in
            domino1.leftSide < domino2.leftSide
        }
    }
 
    mutating func getTaleFromRemaining() -> Domino {        
        return remainingTales.removeFirst()
    }
    
    func hasRemainingTales() -> Bool {
        !remainingTales.isEmpty
    }
}
