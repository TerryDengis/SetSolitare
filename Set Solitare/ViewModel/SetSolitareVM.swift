//
//  SetSolitareVM.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/14/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

class SetSolitareVM: ObservableObject {
    @Published private var setModel : SetGame
    
    var showPopUp : Bool = false
    var startingUp : Bool = true
    var viewableCards = Array<ViewableCard> ()
    
    // MARK: - Score constants
    let matchPoints = 100
    let hintDeduction = 100
    let mismatchDeduction = 10
    let dealDeduction = 25
    
    enum ShapeFeature : Int {
        case undefined = 0
        case rectangle = 1
        case circle = 2
        case capsule = 3
    }
    
    enum ShadingFeature : Int {
        case undefined = 0
        case solid = 1
        case opaque = 2
        case empty = 3
    }
    
    enum ColorFeature : Int {
        case undefined = 0
        case  red = 1
        case  green = 2
        case  blue = 3
    }
    
    struct ViewableCard: Identifiable {
        var id: UUID
        var numberOfShapes: Int
        var shape: ShapeFeature
        var color: ColorFeature
        var shading: ShadingFeature
        var cardStatus: SetGame.CardStatus
    }
    
    private func updateViewFromModel () {
        let model = setModel.cardsDealt

        func shape (from card: SetGame.Card) -> ShapeFeature {
            switch card.shape {
                case 1: return .capsule
                case 2: return .circle
                case 3: return .rectangle
                default: return .undefined // will never happen, included for completeness
            }
        }
        
        func shade (from card: SetGame.Card) -> ShadingFeature {
            switch card.shading {
                case 1: return .empty
                case 2: return .opaque
                case 3: return .solid
                default: return .undefined // will never happen, included for completeness
            }
        }
        
        func color(from card: SetGame.Card) -> ColorFeature {
            switch card.color {
                case 1: return .blue
                case 2: return .green
                case 3: return .red
                default: return .undefined // will never happen, included for completeness
            }
        }
        
        viewableCards.removeAll()
        model.forEach { card in
            viewableCards.append(ViewableCard(id: card.id, numberOfShapes: card.number, shape: shape(from: card), color: color(from: card), shading: shade(from: card), cardStatus: card.cardStatus))
        }
    }
    
    init () {
        setModel = SetGame()
        viewableCards = Array<ViewableCard> ()
    }
    
    // MARK: - Access to the model

    
    // MARK: - Intent(s)
    func choose(card: SetSolitareVM.ViewableCard) {
        
        if let index = viewableCards.firstIndex(matching: card) {
        
            setModel.choose(setModel.cardsDealt[index])
            updateViewFromModel()
        }
    }
    
    func newGame() {
        setModel = SetGame(matchPoints: matchPoints, hintDeduction: hintDeduction, mismatchDeduction: mismatchDeduction, dealDeduction: dealDeduction)
        deal()
        startingUp = false
        showPopUp = false
    }
    
    func deal() {
        setModel.deal()
        updateViewFromModel()
    }
    
    func dealThree() {
        showPopUp = false
        setModel.dealThree()
        updateViewFromModel()
    }
    
    func isDeckEmpty () -> Bool {
        setModel.deck.isEmpty
    }
    
    func isGameOver () -> Bool {
        setModel.cardsDealt.isEmpty
    }
    
    func matchedSets () -> Int {
        setModel.matchedCards.count / 3
    }
    
    func resetStatus () {
        setModel.clearCardStatus()
        updateViewFromModel()
    }
    
    func showHint () -> Bool {
        setModel.clearCardStatus ()

        if let _ = setModel.isThereAValidSet() {
            updateViewFromModel()
            return true
        }
        return false
    }
    
    func gameScore () -> Int {
        setModel.gameScore
    }
}
