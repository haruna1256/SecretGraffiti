//
//  ContentView.swift
//  SecretGraffiti
//
//  Created by 川岸遥奈 on 2025/08/05.
//

import SwiftUI
import RealityKit

struct ContentView : View {

    var body: some View {
        RealityView { content in
                    // 立方体モデル作成
                    let model = Entity()
                    let mesh = MeshResource.generateBox(size: 0.2, cornerRadius: 0.01)
                    let material = SimpleMaterial(color: .gray, roughness: 0.1, isMetallic: false)
                    model.components.set(ModelComponent(mesh: mesh, materials: [material]))
                    model.position = [0, 0.1, -0.3]

                    // ライト（方向性ライト）作成
                    let lightEntity = Entity()
                    let light = DirectionalLightComponent(color: .white, intensity: 1500, isRealWorldProxy: false)
                    lightEntity.components.set(light)
                    lightEntity.position = [0, 1, 1]

                    // アンカー作成（水平面）
                    let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [0.2, 0.2]))
                    anchor.addChild(model)
                    anchor.addChild(lightEntity)

                    content.add(anchor)

                    content.camera = .spatialTracking
                }

        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    ContentView()
}
