//
//  ViewUtilities.swift
//  Set Solitare
//
//  Created by Terry Dengis on 8/18/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI


func randomOffscreenPosition() -> CGSize {
    let angle = Double.random(in: 0..<(2 * Double.pi))
    let distance = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) * CGFloat(2.0.squareRoot())
    
    return CGSize(width: distance * CGFloat(cos(angle)), height: distance * CGFloat(sin(angle)))
}
