//
//  RulesView.swift
//  Domino
//
//  Created by Administrador on 12/03/23.
//

import SwiftUI

///Vista de regla
struct DominoRulesView: View {
    let rules = [
            "El juego se juega con 28 fichas o piezas. Cada ficha tiene dos lados, cada uno de los cuales tiene entre cero y seis puntos.",
            "El juego se puede jugar entre dos a cuatro jugadores.",
            "Antes de comenzar, se mezclan todas las fichas boca abajo sobre la mesa y cada jugador toma un número determinado de fichas. El número de fichas depende del número de jugadores, pero generalmente es de siete fichas por jugador en una partida de dos o tres jugadores y cinco fichas por jugador en una partida de cuatro jugadores.",
            "El jugador con la ficha doble seis (si está jugando con una doble seis) o con la ficha doble más alta comienza el juego.",
            "El jugador comienza el juego colocando una ficha en el centro de la mesa. Luego, cada jugador en su turno debe colocar una ficha en uno de los extremos de la ficha previamente jugada, de manera que los puntos en los extremos de la ficha coincidan.",
            "Si un jugador no puede jugar una ficha, debe pasar su turno y no robar una ficha del montón.",
            "El juego continúa hasta que un jugador coloca todas sus fichas o cuando ningún jugador puede jugar una ficha. En este último caso, se dice que el juego está bloqueado.",
            "El jugador con la menor cantidad de puntos en sus fichas gana la ronda y obtiene la cantidad de puntos en las fichas del oponente que no pudo colocar. Si un jugador gana colocando su última ficha, no se cuentan los puntos en las fichas de los oponentes.",
            "El juego continúa con los jugadores robando del montón y tratando de colocar sus fichas. El primer jugador en alcanzar una cantidad predeterminada de puntos (generalmente 100) gana el juego."
        ]

        var body: some View {
            List(rules, id: \.self) { rule in
                Text(rule)
            }
            .navigationTitle("Reglas del Dominó")
        }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        DominoRulesView()
    }
}
