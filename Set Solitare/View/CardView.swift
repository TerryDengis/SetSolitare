//
//  CardView.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/14/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

// MARK: - Drawing Constants
private let cardCornerRadius: CGFloat = 10.0
private let cardLineWidth: CGFloat = 3.0
private let cardSelectedLineWidth: CGFloat = 9.0
private let shapeLineWidth: CGFloat = 3.0
private let shadeOpaque: Double = 0.25
private let shadeSolid: Double = 1.0
private let shadeEmpty: Double = 0.0
private let cardOpacity: Double = 0.2

// MARK: - Card Attributes
let shapeFeature_rectangle = 1
let shapeFeature_circle = 2
let shapeFeature_capsule = 3

let shadingFeature_solid = 1
let shadingFeature_opaque = 2
let shadingFeature_empty = 3

let colorFeature_red = 1
let colorFeature_green = 2
let colorFeature_blue = 3

struct CardView: View {
    var card: SetGame.Card

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }

    private var borderWidth: CGFloat {
        get {
            if card.cardStatus == .none {
                return cardLineWidth
            } else {
                return cardSelectedLineWidth
            }
        }
    }

    private var borderColor: Color {
        get {
            if card.cardStatus == .selected {
                return Color("SelectedColor")//Color.init(hex: "382933")
            } else if card.cardStatus == .matched {
                return Color("MatchedColor")//Color.init(hex: "799351")
            } else if card.cardStatus == .mismatched {
                return Color("MismatchedColor")//Color.init(hex: "d54062")
            } else if card.cardStatus == .hint {
                return Color("HintColor")//Color.init(hex: "ebdc87")
            }
            return Color("RegularColor")//Color.gray
        }
    }

    private var shapeColor: Color {
        get {
            if card.color == colorFeature_blue {
                return Color.blue
            } else if card.color == colorFeature_red {
                return Color.red
            } else { //colorFeature_green
                return Color.green
            }
        }
    }

    private var shapeOpacity: Double {
        get {
            if card.shading == shadingFeature_solid {
                return shadeSolid
            } else if card.shading == shadingFeature_opaque {
                return shadeOpaque
            } else { //shadingFeature_empty
                return shadeEmpty
            }
        }
    }

    @ViewBuilder
    private func drawShape () -> some View {

        if card.shape == shapeFeature_rectangle {
            ZStack {
                Rectangle ()
                    .stroke(lineWidth: shapeLineWidth)
                Rectangle ()
                    .fill(shapeColor)
                    .opacity(shapeOpacity)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .foregroundColor(shapeColor)

        } else if card.shape == shapeFeature_capsule {
            ZStack {
                Capsule ()
                    .stroke(lineWidth: shapeLineWidth)
                Capsule ()
                    .fill(shapeColor)
                    .opacity(shapeOpacity)

            }
            .aspectRatio(7/3, contentMode: .fit)
            .foregroundColor(shapeColor)

        } else { //shapeFeature_circle
            ZStack {
                Circle ()
                    .stroke(lineWidth: shapeLineWidth)
                Circle ()
                    .fill(shapeColor)
                    .opacity(shapeOpacity)
            }
            .foregroundColor(shapeColor)
        }
    }

    private func body(for size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(lineWidth: borderWidth)
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(Color("RegularColor"))
                .opacity(cardOpacity)
            VStack {
                ForEach (0..<card.number) { _ in
                    self.drawShape()
                }
            }
            .padding()
        }
        .foregroundColor(borderColor)
        .padding(5)
        .aspectRatio(2/3, contentMode: .fit)

    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGame.Card(id: UUID(), shape: 3, color: 3, shading: 2, number: 3, cardStatus: .mismatched)
        return CardView(card: card)
    }
}
