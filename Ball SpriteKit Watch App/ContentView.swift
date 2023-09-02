//
//  ContentView.swift
//  Ball SpriteKit Watch App
//
//  Created by Yusron Alfauzi on 01/09/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @State private var scene = GameScene()
    
    var body: some View {
       SpriteView(scene: scene)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .focusable()
            .digitalCrownRotation($scene.playerPosX)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
