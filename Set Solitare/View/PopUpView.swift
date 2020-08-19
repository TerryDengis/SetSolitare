//
//  PopUpView.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/18/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct PopUpView: View {
    @ObservedObject var gameVM: SetSolitareVM
    
    var body: some View {
        
        ZStack {
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack (spacing:0) {
                Text("No Sets Available")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.heavy)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color("HintColor"))
                    .foregroundColor(.white)
                    
                Spacer()
                Text ("Deal more cards")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.black)
                Spacer()
                Button ("OK") {
                    withAnimation (.easeInOut(duration: 1.0)) {
                        self.gameVM.showPopUp = false
                        self.gameVM.dealThree()
                    }
                }
                .font(.system(.title, design: .rounded))
                Spacer()
            }
        }
        .frame(minWidth: 270, idealWidth: 270, maxWidth: 280, minHeight: 210, idealHeight: 210, maxHeight: 220, alignment: .center)
        .background(Color.white)
        .cornerRadius(20)
        //.shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
        //.opacity($animatingModal.wrappedValue ? 1 : 0)
        //.animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
        .onAppear(perform: {
            //self.animatingModal = true
        })
    }
}

struct PopUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = SetSolitareVM()
        vm.showPopUp = true
        
        return PopUpView(gameVM: vm)
        
    }
}
