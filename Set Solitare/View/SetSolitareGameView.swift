//
//  SetSolitareGameView.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/14/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct SetSolitareGameView: View {
    @ObservedObject var gameVM: SetSolitareVM
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // MARK: - DEALT CARDS
                    if gameVM.isGameOver() {
                        Spacer ()
                        Text("GAME OVER")
                            .font(.largeTitle)
                        Spacer ()
                    } else {
                        DealtCardsView (gameVM: gameVM)
                    }
                    
                    // MARK: - TABLE BOTTOM
                    FooterView(gameVM: gameVM)
                    .padding()
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0)){
                        self.gameVM.newGame()
                    }
                }
                // MARK: - NAVIGATION BAR
                .navigationBarTitle("Set Solitare")
                .navigationBarItems(leading: Text("Score: \(gameVM.gameScore())"), trailing: Button("New Game") {
                    withAnimation(.easeInOut(duration: 2.0)){
                        self.gameVM.showPopUp = false
                        self.gameVM.newGame()
                    }
                })
                
                // MARK: - POPUP
                if gameVM.showPopUp  {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        PopUpView(gameVM: gameVM)
                    }
                }
            } // ZStack
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetSolitareVM()
        return SetSolitareGameView(gameVM: game)
    }
}
