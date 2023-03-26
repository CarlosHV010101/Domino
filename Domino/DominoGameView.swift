//
//  DominoGame.swift
//  Domino
//
//  Created by Administrador on 12/03/23.
//

import SwiftUI

struct DominoGameView: View {
    @StateObject private var viewModel: DominoGameViewModel
    @State private var leftDominoRotationDegrees: CGFloat = 0
    @State private var rightDominoRotationDegrees: CGFloat = 0
    
    init(viewModel: DominoGameViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private func rotateLeftDomino() {
        guard let leftDomino = viewModel.leftDomino else { return }
        guard let leftSideValue = viewModel.leftSideLeftDomino else { return }
        
        if leftDomino.isMule {
            self.leftDominoRotationDegrees = 0
            return
        }
        
        self.leftDominoRotationDegrees = leftDomino.leftSide == leftSideValue ? -90 : 90
    }
    
    private func rotateRightDomino() {
        guard let rightDomino = viewModel.rightDomino else { return }
        guard let rightSideValue = viewModel.rightSideRightDomino else { return }
        
        if rightDomino.isMule {
            self.rightDominoRotationDegrees = 0
            return
        }
        
        self.rightDominoRotationDegrees = rightDomino.rightSide == rightSideValue ? -90 : 90
    }
    
    var body: some View {
        VStack {
            Text("Turno de: \(viewModel.currentPlayer?.name ?? "")")
                
            
            Spacer()
            
            if viewModel.isFirstRound {
                VStack {
                    Text("Mula más alta")
                    
                    Image(viewModel.firstDomino?.imageName ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 120, alignment: .center)
                    
                    Text(String(viewModel.firstDomino?.leftSide ?? 0))
                }
            } else {
                HStack(spacing: 60) {
                    VStack {
                        
                        Text("Lado izquierdo")
                            .font(.callout)
                        
                        Image(viewModel.leftDomino?.imageName ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 120, alignment: .center)
                            .rotationEffect(Angle(degrees: leftDominoRotationDegrees))
                        
                        Text(String(viewModel.leftSideLeftDomino ?? 0))
                    }
                    
                    VStack {
                        Text("Lado derecho")
                            .font(.callout)
                        
                        Image(viewModel.rightDomino?.imageName ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 120, alignment: .center)
                            .rotationEffect(Angle(degrees: rightDominoRotationDegrees))
                        
                        Text(String(viewModel.rightSideRightDomino ?? 0))
                    }
                }
            }
            
            Spacer()
            
            VStack {
                
                if viewModel.showGameOptions {
                    HStack(spacing: 20) {
                        
                        Button {
                            withAnimation {
                                viewModel.playLeftMovement()
                            }
                        } label: {
                            Image(systemName: "arrowshape.left.fill")
                                .font(.system(size: 35))
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            withAnimation {
                                viewModel.playRightMovement()
                            }
                        } label: {
                            Image(systemName: "arrowshape.right.fill")
                                .font(.system(size: 35))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom)
                }
                
                Text("Tienes: \(viewModel.currentPlayer?.hand.count ?? 0) fichas")
                
                HStack {
                    
                    Button {
                        viewModel.showTales.toggle()
                    } label: {
                        HStack {
                            
                            Text("Mostrar/ocultar fichas")
                            
                            Image(systemName: viewModel.showTales ? "eye.slash" : "eye.fill")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    
                    Button {
                        self.viewModel.addTaleToCurrentPlayerFromRemainingTales()
                    } label: {
                        HStack {
                            Text(viewModel.allowTake ? "Tomar ficha" : "Pasar")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .padding()
                
                ScrollView(.horizontal) {
                    if viewModel.showTales {
                        HStack {
                            ForEach(viewModel.currentPlayer?.hand ?? [], id: \.self) { domino in
                                Image(domino.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        viewModel.selectedDominoByCurrentPlayer = domino
                                    }
                                    .border(Color.red, width: viewModel.selectedDominoByCurrentPlayer == domino ?  2 : 0)
                            }
                        }
                    }
                }
                .frame(height: 150)
                .padding([.bottom, .leading], 15)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Juego terminado"),
                  message: Text("El jugador \(viewModel.winner?.name ?? "") ha ganado"),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .default(Text("Iniciar nuevo juego"), action: {
                self.viewModel.startNewGame()
            })
            )
        }
        .onChange(of: viewModel.leftDomino) { _ in
            rotateLeftDomino()
        }
        .onChange(of: viewModel.rightDomino) { _ in
            rotateRightDomino()
        }
    }
}

struct DominoGame_Previews: PreviewProvider {
    static var previews: some View {
        DominoGameView(viewModel: DominoGameViewModel())
    }
}
