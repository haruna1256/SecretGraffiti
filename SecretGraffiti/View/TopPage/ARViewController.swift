//
//  ARViewController.swift
//  SecretGraffiti
//
//  Created by 川岸遥奈 on 2025/08/05.
//

// 現実の画面に文字列などを表示する画面
import SwiftUI
import RealityKit

struct ARViewController: View {
    // ランダムに選ぶ単語リスト
        let words = [
            "ウェーイ",
            "やったー、できた！",
            "まじかー",
            "エモい",
            "尊い",
            "それな",
            "ワンチャンある",
            "草",
            "てかさ",
            "めっちゃわかる",
            "やばい",
            "だるい",
            "授業眠いね",
            "バイトだるい",
            "えぐい",
            "ぴえん",
            "好きぴ",
            "つらたん",
            "まじ卍",
            "あー、お腹すいた"
        ]
    
    var body: some View {
        RealityView{ content in
            // 壁（垂直平面）を認識したときに設置されるアンカーを作成
            let anchor = AnchorEntity(
                plane: .vertical,               // 垂直面（壁）を対象
                classification: .any,           // どの種類の壁でもOK
                minimumBounds: [0.3,0.3]        // 最低30cm四方の壁を検出対象に
                )
            
            // 単語リストからランダムに３個選ぶ
            let randomWords = words.shuffled().prefix(3)
            
            // 選んだ単語を３個それぞれランダムな位置に表示
            for word in randomWords {
                // 文字列からRealiyKitで使うテキスト平面モデルを作成
                let textEntity = createTextEntity(text: word)
                
                // 壁平面上のランダムなX,Y位置（単位はメートル）
                let randomX = Float.random(in: -0.1...0.1)
                let randomY = Float.random(in: -0.1...0.1)
                
                // Zは壁にぴったり張り付くので０に設定
                textEntity.position = SIMD3(randomX,randomY,0)
                
                anchor.addChild(textEntity)
            }
            
            // シーンにアンカーを追加して描画開始
            content.add(anchor)
            
            // カメラを空間追跡モードに設定
            content.camera = .spatialTracking
        }
        
        // 画面いっぱいに表示
        .edgesIgnoringSafeArea(.all)
    }
    
    
    // 文字列をRealityKitの3Dオブジェクトに変換する関数
    func createTextEntity(text: String) -> ModelEntity {
        let uiImage = textToUIImage(text: text)

        guard let cgImage = uiImage.cgImage else {
            fatalError("UIImageからCGImageを取得できません")
        }

        // RealityKit 4以降 (iOS 18+) の初期化方法
        let texture = try! TextureResource(image: cgImage, options: .init(semantic: .color))

        let planeSize: Float = 0.15
        let mesh = MeshResource.generatePlane(width: planeSize, height: planeSize)

        // UnlitMaterialでテクスチャを貼り付ける
        var material = UnlitMaterial()
        material.color = UnlitMaterial.BaseColor(
            texture: MaterialParameters.Texture(texture)
        )




        return ModelEntity(mesh: mesh, materials: [material])
    }

        
        // UILabelを使って文字列をUIImageに変換するヘルパー関数
        func textToUIImage(text: String) -> UIImage {
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 48) // フォントサイズ
            label.textColor = .black
            label.backgroundColor = .clear
            label.sizeToFit() // ラベルのサイズをテキストに合わせて自動調整
            
            // UIGraphicsを使ってUILabelを画像化
            UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
            label.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            return image
        }
    }

#Preview {
    ARViewController()
}
