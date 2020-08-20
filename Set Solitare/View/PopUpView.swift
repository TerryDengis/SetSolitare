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
    var title: String
    var message: String
    var buttonText: String
    var action: () -> Void
    
    var body: some View {
        
        ZStack {
            Color(.lightGray)
            
            VStack (spacing:0) {
                Text(title)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.heavy)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color("HintColor"))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()

                Text (message)
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                Spacer()
                Button (buttonText) {
                    self.action ()
                }
                .font(.system(.title, design: .rounded))
                Spacer()
            }
        }
        .frame(minWidth: 270, idealWidth: 270, maxWidth: 280, minHeight: 210, idealHeight: 210, maxHeight: 220, alignment: .center)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
    }
}

struct PopUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = SetSolitareVM()
        vm.showPopUp = true
        
        return PopUpView(gameVM: vm, title: "Preview", message: "This is a preview", buttonText: "OK", action: { })
        
    }
}
