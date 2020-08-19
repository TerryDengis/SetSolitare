//
//  FooterView.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/18/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct FooterView: View {
    @ObservedObject var gameVM: SetSolitareVM
    
    var body: some View {
        HStack {
            Text("Matched Sets: \(gameVM.matchedSets())")
            Spacer()
            Button ("Hint") {
                if !self.gameVM.showHint() {
                    self.gameVM.showPopUp = true
                }
            }
            .disabled(gameVM.isGameOver ())
            Spacer()
            Button ("Deal") {
                withAnimation (.easeInOut(duration: 1.0)) {
                    self.gameVM.dealThree()
                }
            }
            .disabled(gameVM.isDeckEmpty())
        }
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SetSolitareVM()
        return FooterView(gameVM: vm)
    }
}
