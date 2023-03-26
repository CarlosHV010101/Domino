//
//  Domino.swift
//  Domino
//
//  Created by Administrador on 12/03/23.
//

import Foundation

struct Domino: Identifiable, Hashable {
    let id: Int
    let imageName: String
    let isMule: Bool
    let leftSide: Int
    let rightSide: Int
}
