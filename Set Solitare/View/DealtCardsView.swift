//
//  DealtCardsView.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/18/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct DealtCardsView: View {
    @ObservedObject var gameVM: SetSolitareVM
    
    var body: some View {
        GridView(gameVM.cardsDealt) { card in
            CardView (card: card)
            .onTapGesture {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.15, blendDuration: 0.0)) {
                    self.gameVM.choose(card: card)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onEnded { _ in
                        if card.cardStatus == .mismatched {
                            withAnimation(.easeInOut(duration: 1.0)){
                                self.gameVM.resetStatus()
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 1.0)){
                                self.gameVM.dealThree()
                            }
                        }
                }
            )
            .transition(.offset(randomOffscreenPosition()))
        }
    }
}

struct DealtCardsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SetSolitareVM()
        return DealtCardsView(gameVM: vm)
    }
}
