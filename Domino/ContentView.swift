//
//  ContentView.swift
//  Domino
//
//  Created by Carlos Hernández on 12/03/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                Text("Bienvenido!!")
                
                NavigationLink(destination: DominoRulesView()) {
                    Text("Ver reglas")
                }
                
                NavigationLink(destination: DominoGameView(viewModel: DominoGameViewModel())) {
                    Text("Jugar")
                }

            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
