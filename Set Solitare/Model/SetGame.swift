//
//  SetGame.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/14/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import Foundation

struct SetGame {
    private (set) var deck: Array<Card>
    private (set) var cardsDealt: Array<Card>
    private (set) var matchedCards: Array<Card>
    private (set) var gameScore: Int
    
    private var matchPoints: Int
    private var hintDeduction: Int
    private var mismatchDeduction: Int
    private var dealDuction: Int
    
    enum cardStatus : Int {
        case none = 0
        case selected = 1
        case matched = 2
        case mismatched = 3
        case hint = 4
    }
    
    struct Card: Identifiable {
        var id: UUID = UUID()
        var shape: Int
        var color: Int
        var shading: Int
        var number: Int
        var cardStatus: cardStatus = .none
    }
    
    init (matchPoints: Int=0, hintDeduction: Int=0, mismatchDeduction: Int=0, dealDeduction: Int=0) {
        deck = Array<Card> ()
        cardsDealt = Array<Card> ()
        matchedCards = Array<Card> ()
        gameScore = 0
        self.matchPoints = matchPoints
        self.hintDeduction = hintDeduction
        self.mismatchDeduction = mismatchDeduction
        self.dealDuction = dealDeduction
        
        for shape in 1...3 {
            for color in 1...3 {
                for shading in 1...3 {
                    for number in 1...3 {
                        deck.append(Card (shape: shape, color: color, shading: shading, number: number))
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if touchedIndices.count < 3 {
            if let chosenIndex = cardsDealt.firstIndex(matching: card) {
                if cardsDealt[chosenIndex].cardStatus == .selected {
                    cardsDealt[chosenIndex].cardStatus = .none
                } else if cardsDealt[chosenIndex].cardStatus == .none || cardsDealt[chosenIndex].cardStatus == .hint {
                    cardsDealt[chosenIndex].cardStatus = .selected
                }
                
                let selection = selectedIndices
                if selection.count == 3 {
                    let _ = checkForSet(in: selection, forGamePlay: true)
                }
            }
        }
    }
    
    mutating func deal () {
        for _ in 1...12 {
            cardsDealt.append(deck.removeFirst())
        }
    }
    
    mutating func dealThree() {
        if selectedMatchedIndicies.count == 3 {
            insertCards()
        } else {
            if (isThereAValidSet() != nil) {
                // deduction for dealing with a set present
                gameScore -= dealDuction
            }
            clearCardStatus()
            appendCards()
        }
    }
    
    mutating func resetMismatch () {
        let selection = selectedMismatchesIndicies
        
        selection.forEach { index in
            cardsDealt[index].cardStatus = .none
        }
    }
    
    mutating func clearCardStatus () {
        cardsDealt.forEach {card in
            if let index = cardsDealt.firstIndex(matching: card){
                cardsDealt[index].cardStatus = .none
            }
        }
    }
    
    mutating func isThereAValidSet () -> Array<Int>? {
        for index1 in 0..<cardsDealt.count-2 {
            for index2 in index1+1..<cardsDealt.count-1 {
                for index3 in index2+1..<cardsDealt.count {
                    let setTest = [index1, index2, index3]
                    if checkForSet(in: setTest, forGamePlay: false) {
                        return setTest
                    }
                }
            }
        }
        return nil
    }
    
    // Find all cards chosen by the user
    private var selectedIndices: [Int] {
        get {
            cardsDealt.indices.filter {cardsDealt[$0].cardStatus == cardStatus.selected}
        }
    }
    
    private var touchedIndices: [Int] {
        get {
            cardsDealt.indices.filter {cardsDealt[$0].cardStatus != cardStatus.none && cardsDealt[$0].cardStatus != cardStatus.hint}
        }
    }
    
    private var selectedMismatchesIndicies: [Int] {
        get {
            cardsDealt.indices.filter {cardsDealt[$0].cardStatus == cardStatus.mismatched}
        }
    }
    
    private var selectedMatchedIndicies: [Int] {
        get {
            cardsDealt.indices.filter {cardsDealt[$0].cardStatus == cardStatus.matched}
        }
    }
    
    private mutating func appendCards () {
        for _ in 1...3 {
            cardsDealt.append(deck.removeFirst())
        }
    }
    
    private mutating func insertCards () {
        let matchedIndicies = selectedMatchedIndicies
        
        matchedIndicies.forEach {index in
            if cardsDealt[index].cardStatus == .matched {
                matchedCards.append(cardsDealt[index])
            }
        }
        cardsDealt.removeAll { card in
            card.cardStatus == .matched
        }
        if deck.count >= 3 {
            matchedIndicies.forEach { index in
                cardsDealt.insert(deck.removeFirst(), at: index)
            }
        }
    }
    private func compareAttributes (_ a1: Int, _ a2: Int, _ a3: Int) -> Bool {
        return (a1 == a2 && a1==a3 && a2==a3) || (a1 != a2 && a1 != a3 && a2 != a3)
    }
    
    private mutating func checkForSet (in selection: Array<Int>, forGamePlay: Bool) -> Bool {
        let firstCard = cardsDealt[selection[0]]
        let secondCard = cardsDealt[selection[1]]
        let thirdCard = cardsDealt[selection[2]]
        
        
        let test1 = compareAttributes(firstCard.color, secondCard.color, thirdCard.color)
        let test2 = compareAttributes(firstCard.shading, secondCard.shading, thirdCard.shading)
        let test3 = compareAttributes(firstCard.number, secondCard.number, thirdCard.number)
        let test4 = compareAttributes(firstCard.shape, secondCard.shape, thirdCard.shape)
        
        var matchStatus: cardStatus = .none
        
        if test1 && test2 && test3 && test4 {
            
            if forGamePlay {
                matchStatus = .matched
                // add to score for match
                gameScore += matchPoints
            }
            else {
                // for a hint
                matchStatus = .hint
                // deduct points for a hint
                gameScore -= hintDeduction
            }
        }
        else {
            // it this call was not for a hint
            if forGamePlay {
                matchStatus = .mismatched
                // deduct for mismatch
                gameScore -= mismatchDeduction
            }
        }
        
        // for testing
        //matchStatus = .matched
        
        selection.forEach {index in
            cardsDealt[index].cardStatus = matchStatus
        }
        
        return matchStatus == .matched || matchStatus == .hint
    }
}
