//
//  CardView.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/14/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

// MARK: - Drawing Constants
private let cardCornerRadius: CGFloat = 20.0
private let cardLineWidth: CGFloat = 4.0
private let cardSelectedLineWidth: CGFloat = 9.0
private let shapeLineWidth: CGFloat = 3.0
private let shadeOpaque: Double = 0.4
private let shadeSolid: Double = 1.0
private let shadeEmpty: Double = 0.0

struct CardView: View {
    var card: SetSolitareVM.ViewableCard

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
                return Color("SelectedColor")
            } else if card.cardStatus == .matched {
                return Color("MatchedColor")
            } else if card.cardStatus == .mismatched {
                return Color("MismatchedColor")
            } else if card.cardStatus == .hint {
                return Color("HintColor")
            }
            return Color(.darkGray)
        }
    }

    private var shapeColor: Color {
        get {
            if card.color == .blue {
                return Color.blue
            } else if card.color == .red {
                return Color.red
            } else { //.green
                return Color.green
            }
        }
    }

    private var shapeOpacity: Double {
        get {
            if card.shading == .solid {
                return shadeSolid
            } else if card.shading == .opaque {
                return shadeOpaque
            } else { //.empty
                return shadeEmpty
            }
        }
    }

    @ViewBuilder
    private func drawShape () -> some View {

        if card.shape == .rectangle {
            ZStack {
                Rectangle ()
                    .stroke(lineWidth: shapeLineWidth)
                Rectangle ()
                    .fill(shapeColor)
                    .opacity(shapeOpacity)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .foregroundColor(shapeColor)

        } else if card.shape == .capsule {
            ZStack {
                Capsule ()
                    .stroke(lineWidth: shapeLineWidth)
                Capsule ()
                    .fill(shapeColor)
                    .opacity(shapeOpacity)

            }
            .aspectRatio(7/3, contentMode: .fit)
            .foregroundColor(shapeColor)

        } else { //.circle
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
                .fill(Color("CardColor"))
            VStack {
                ForEach (0..<card.numberOfShapes) { _ in
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
        let card = SetSolitareVM.ViewableCard(id: UUID(), numberOfShapes: 3, shape: .capsule, color: .blue, shading: .opaque, cardStatus: .matched)
        return CardView(card: card)
    }
}
