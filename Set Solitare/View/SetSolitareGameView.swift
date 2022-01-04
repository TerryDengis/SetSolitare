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
                // MARK: - BACKGROUND
                LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor1"), Color("BackgroundColor2")]), startPoint: .center, endPoint: .top)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    // MARK: - DEALT CARDS
                    DealtCardsView (gameVM: gameVM)

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
                    .navigationBarTitle ("Set Solitare", displayMode: .automatic)
                .navigationBarItems(leading: Text("Score: \(gameVM.gameScore)"), trailing: Button("New Game") {
                    withAnimation(.easeInOut(duration: 2.0)){
                        self.gameVM.newGame()
                    }
                })
                
                // MARK: - GAME OVER
                if gameVM.isGameOver && !gameVM.startingUp {
                    PopUpView (gameVM: gameVM, title: "Game Over", message: "Congratulations you won!", buttonText: "New Game", action: {
                        withAnimation(.easeInOut(duration: 2.0)){
                            self.gameVM.newGame()
                        }
                    })
                }

                // MARK: - POPUP
                if gameVM.showPopUp {
                    if gameVM.isDeckEmpty {
                        PopUpView (gameVM: gameVM, title: "Game Over", message: "No more sets available!", buttonText: "New Game", action: {
                            withAnimation(.easeInOut(duration: 2.0)) {
                                self.gameVM.newGame()
                            }
                        })
                    } else {
                        PopUpView (gameVM: gameVM, title: "No Sets Available", message: "Deal more cards", buttonText: "OK", action: {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                self.gameVM.dealThree()
                            }
                        })
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
