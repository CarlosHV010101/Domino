//
//  DominoGameViewModel.swift
//  Domino
//
//  Created by Administrador on 12/03/23.
//

import Foundation

///View Model de vista de juego
class DominoGameViewModel: ObservableObject {
    @Published var player1: Player = Player(name: "Jugador 1", hand: [])
    @Published var player2: Player = Player(name: "Jugador 2", hand: [])
    @Published var currentPlayer: Player?
    @Published var isFirstRound: Bool = true
    @Published var firstDomino: Domino?
    @Published var showTales: Bool = false
    @Published var allowTake: Bool = true
    @Published var selectedDominoByCurrentPlayer: Domino? {
        didSet {            
            showGameOptions = selectedDominoByCurrentPlayer != nil
        }
    }
    @Published var showGameOptions: Bool = false
    @Published var rightDomino: Domino?
    @Published var rightSideRightDomino: Int?
    @Published var leftDomino: Domino?
    @Published var leftSideLeftDomino: Int?
    @Published var showAlert: Bool = false
    @Published var winner: Player?
    
    private var dominoBrain: GameBrain = GameBrain()
    
    init() {
        self.startGame()
    }
    
    func startGame() {
        self.addDominoesToPlayers()
        self.getPlayerWithHigherMule()
    }
    
    func addDominoesToPlayers() {
        dominoBrain.shuffleAndAssignTales(player1: &player1, player2: &player2)
    }
    
    func getPlayerWithHigherMule() {
        let player1HigherMule = dominoBrain.getHigherMule(player1)
        let player2HigherMule = dominoBrain.getHigherMule(player2)
        
        let leftSideMulePlayer1 = player1HigherMule?.leftSide ?? 0
        let leftSideMulePlayer2 = player2HigherMule?.leftSide ?? 0
        
        if leftSideMulePlayer1 > leftSideMulePlayer2 {
            self.firstDomino = player1HigherMule
            
            guard let id = player1HigherMule?.id  else { return }
            
            player1.removeDomino(with: id)
            currentPlayer = player2
        } else {
            self.firstDomino = player2HigherMule
            
            guard let id = player2HigherMule?.id else { return }
            player2.removeDomino(with: id)
            currentPlayer = player1
        }
    }
    
    func addTaleToCurrentPlayerFromRemainingTales() {
        if dominoBrain.hasRemainingTales() {
            self.currentPlayer?.hand.append(dominoBrain.getTaleFromRemaining())
            objectWillChange.send()
        } else {
            self.allowTake = false
            self.changePlayer()
        }
    }
    
    func playLeftMovement() {
        
        if isFirstRound {
            playLeftMovementForFirstRound()
            return
        }
        
        guard let selectedDominoByCurrentPlayer = selectedDominoByCurrentPlayer else {
            return
        }
        
        if selectedDominoByCurrentPlayer.leftSide == leftSideLeftDomino {
            self.leftSideLeftDomino = selectedDominoByCurrentPlayer.rightSide
        } else if selectedDominoByCurrentPlayer.rightSide == leftSideLeftDomino {
            self.leftSideLeftDomino = selectedDominoByCurrentPlayer.leftSide
        }                
        
        if selectedDominoByCurrentPlayer.leftSide != leftSideLeftDomino && selectedDominoByCurrentPlayer.rightSide != leftSideLeftDomino {
            return
        }
        
        self.leftDomino = selectedDominoByCurrentPlayer
        
        currentPlayer?.removeDomino(with: selectedDominoByCurrentPlayer.id)
                
        changePlayer()
        
        checkWinner()
    }
    
    func playLeftMovementForFirstRound() {
        guard let selectedDominoByCurrentPlayer = selectedDominoByCurrentPlayer else {
            return
        }
        
        guard let firstDomino = firstDomino else {
            return
        }
        
        if selectedDominoByCurrentPlayer.leftSide == firstDomino.leftSide {
            self.leftSideLeftDomino = selectedDominoByCurrentPlayer.rightSide
            self.rightSideRightDomino = firstDomino.rightSide
        }
        
        if selectedDominoByCurrentPlayer.rightSide == firstDomino.rightSide {
            self.leftSideLeftDomino = selectedDominoByCurrentPlayer.leftSide
            self.rightSideRightDomino = firstDomino.rightSide
        }
        
        if selectedDominoByCurrentPlayer.leftSide != firstDomino.leftSide && selectedDominoByCurrentPlayer.rightSide != firstDomino.rightSide {
            return
        }
        
        self.rightDomino = firstDomino
        self.leftDomino = selectedDominoByCurrentPlayer
        self.isFirstRound = false
        
        currentPlayer?.removeDomino(with: selectedDominoByCurrentPlayer.id)
        
        changePlayer()
    }
    
    func playRightMovement() {
        
        if isFirstRound {
            playRightMovementForFirstPlay()
            return
        }
        
        guard let selectedDominoByCurrentPlayer = selectedDominoByCurrentPlayer else {
            return
        }
        
        if selectedDominoByCurrentPlayer.leftSide == rightSideRightDomino {
            self.rightSideRightDomino = selectedDominoByCurrentPlayer.rightSide
        } else if selectedDominoByCurrentPlayer.rightSide == rightSideRightDomino {
            self.rightSideRightDomino = selectedDominoByCurrentPlayer.leftSide
        }
        
        if selectedDominoByCurrentPlayer.leftSide != rightSideRightDomino && selectedDominoByCurrentPlayer.rightSide != rightSideRightDomino {
            return
        }
        
        self.rightDomino = selectedDominoByCurrentPlayer
        
        currentPlayer?.removeDomino(with: selectedDominoByCurrentPlayer.id)
        
        changePlayer()
        
        checkWinner()
    }
    
    func playRightMovementForFirstPlay() {
        guard let selectedDominoByCurrentPlayer = selectedDominoByCurrentPlayer else {
            return
        }
        
        guard let firstDomino = firstDomino else {
            return
        }
        
        if selectedDominoByCurrentPlayer.leftSide == firstDomino.rightSide {
            self.leftSideLeftDomino = firstDomino.leftSide
            self.rightSideRightDomino = selectedDominoByCurrentPlayer.rightSide
        }
        
        if selectedDominoByCurrentPlayer.rightSide == firstDomino.rightSide {
            self.leftSideLeftDomino = firstDomino.leftSide
            self.rightSideRightDomino = selectedDominoByCurrentPlayer.leftSide
        }
        
        if selectedDominoByCurrentPlayer.leftSide != firstDomino.rightSide && selectedDominoByCurrentPlayer.rightSide != firstDomino.rightSide {
            return
        }
        
        self.rightDomino = selectedDominoByCurrentPlayer
        self.leftDomino = firstDomino
        self.isFirstRound = false
        
        currentPlayer?.removeDomino(with: selectedDominoByCurrentPlayer.id)
        
        changePlayer()
    }
    
    func changePlayer() {
        
        guard let currentPlayer = currentPlayer else { return }
        
        guard !currentPlayer.hand.isEmpty else { return }
        
        if currentPlayer.id == player1.id {
            self.currentPlayer = player2
        } else if currentPlayer.id == player2.id {
            self.currentPlayer = player1
        }
        
        objectWillChange.send()
        
        self.showTales = false
        self.selectedDominoByCurrentPlayer = nil
    }
    
    func checkWinner() {
        
        guard let currentPlayer = currentPlayer else { return }
        
        guard currentPlayer.hand.isEmpty else { return }
        
        self.winner = currentPlayer        
        self.showAlert = true
        
    }
    
    func startNewGame() {
        self.player1 = Player(name: "Jugador 1", hand: [])
        self.player2 = Player(name: "Jugador 2", hand: [])
        self.currentPlayer = nil
        self.isFirstRound = true
        self.firstDomino = nil
        self.showTales = false
        self.allowTake = true
        self.selectedDominoByCurrentPlayer = nil
        self.showGameOptions = false
        self.rightDomino = nil
        self.rightSideRightDomino = nil
        self.leftDomino = nil
        self.leftSideLeftDomino = nil
        self.winner = nil
        
        startGame()
    }
}
