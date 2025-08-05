//
//  ARViewController.swift
//  SecretGraffiti
//
//  Created by 川岸遥奈 on 2025/08/05.
//
import SwiftUI
import ARKit
import SceneKit

struct ARSCNViewContainer: UIViewRepresentable {
    let words = [
        "ウェーイ", "やったー、できた！", "まじかー", "エモい", "尊い",
        "それな", "ワンチャン", "草", "てかさ", "めっちゃわかる",
        "やばい", "だるい", "授業眠い", "バイトだるい", "えぐい",
        "ぴえん", "好きぴ", "つらたん", "まじ卍", "あー、お腹すいた"
    ];

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView(frame: .zero)
        sceneView.delegate = context.coordinator

        // ARWorldTrackingConfigurationで水平面を検出
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(config)

        // シーン作成
        sceneView.scene = SCNScene()
        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARSCNViewContainer

        init(_ parent: ARSCNViewContainer) {
            self.parent = parent
            super.init()
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

            let count = Int.random(in: 1...3)
            let randomWords = parent.words.shuffled().prefix(count)

            var placedPositions: [SCNVector3] = []

            for word in randomWords {
                let text = SCNText(string: word, extrusionDepth: 2)
                text.font = UIFont(name: "harutegakifont", size: 20) ?? UIFont.systemFont(ofSize: 20)
                text.flatness = 0.05
                text.firstMaterial?.diffuse.contents = UIColor.black

                let textNode = SCNNode(geometry: text)
                let scale: Float = 0.015
                textNode.scale = SCNVector3(scale, scale, scale)

                // 衝突しない位置を探す
                var position: SCNVector3
                var tries = 0
                repeat {
                    let randomX = Float.random(in: -0.1...0.1)
                    let randomZ = Float.random(in: -0.1...0.1)
                    position = SCNVector3(randomX, 0, randomZ)

                    tries += 1

                    // 既存の位置との距離をチェック
                } while placedPositions.contains(where: { existingPos in
                    let dx = existingPos.x - position.x
                    let dz = existingPos.z - position.z
                    let distance = sqrt(dx*dx + dz*dz)
                    return distance < 0.1  // 最低6cmは離す
                }) && tries < 10

                textNode.position = position

                if planeAnchor.alignment == .vertical {
                    textNode.eulerAngles.x = -.pi / 2
                }

                placedPositions.append(position)
                node.addChildNode(textNode)
            }
        }
    }
}

struct ARSCNTextView: View {
    var body: some View {
        ARSCNViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ARSCNTextView()
}
