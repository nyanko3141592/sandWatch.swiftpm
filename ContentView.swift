import SpriteKit
import SwiftUI

struct ContentView: View {
    @State private var isInverted: Bool = false // 上下反転の状態を管理する変数
    @State private var scene: SKScene = .init() // SpriteKitのシーンを管理する変数
    let ballDiameter: CGFloat = 50 // ボールの直径を管理する変数

    var body: some View {
        GeometryReader { geometry in // 画面サイズを取得するGeometryReader
            VStack {
                SpriteView(scene: scene)
                    .frame(width: geometry.size.width - 10, height: geometry.size.height - 50) // シーンのサイズを画面最大より10小さくする
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        // シーンが表示されたときに実行する処理
                        scene = createScene(size: CGSize(width: geometry.size.width - 10, height: geometry.size.height - 10)) // シーンを作成してscene変数に代入
                    }

                // 上下反転ボタン
                Button(action: {
                    isInverted.toggle() // 上下反転の状態を切り替える
                    scene.physicsWorld.gravity.dy = isInverted ? 9.8 : -9.8 // 重力の方向を変更する
                }) {
                    Text("上下反転")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }

    // シーンを作成する関数
    func createScene(size: CGSize) -> SKScene {
        let newScene = SKScene(size: size) // 新しいシーンを作成
        newScene.backgroundColor = .gray // シーンの背景色を設定
        newScene.physicsBody = SKPhysicsBody(edgeLoopFrom: newScene.frame) // シーンの境界に物理ボディを設定

        // 100個のボールを作成
        for _ in 0 ..< 100 {
            let ball = SKShapeNode(circleOfRadius: ballDiameter / 2) // ボールの形状を作成
            ball.position = CGPoint(x: CGFloat.random(in: ballDiameter / 2...size.width - ballDiameter / 2), y: CGFloat.random(in: ballDiameter / 2...size.height - ballDiameter / 2)) // ボールの位置をランダムに設定
            ball.fillColor = .white // ボールの塗りつぶし色を設定
            ball.strokeColor = .clear // ボールの線の色を透明に設定

            let physicsBody = SKPhysicsBody(circleOfRadius: ballDiameter / 2) // ボールの物理ボディを作成
            physicsBody.affectedByGravity = true // 重力の影響を受けるように設定
            physicsBody.allowsRotation = true
            physicsBody.restitution = 0.5
            physicsBody.usesPreciseCollisionDetection = true
            ball.physicsBody = physicsBody

            newScene.addChild(ball)
        }

        // 三角形の追加
        let triangle = SKShapeNode()
        let trianglePath = CGMutablePath()
        trianglePath.move(to: CGPoint(x: size.width / 4, y: size.height / 4))
        trianglePath.addLine(to: CGPoint(x: size.width / 4, y: size.height / 2))
        trianglePath.addLine(to: CGPoint(x: size.width / 2, y: size.height / 4))
        trianglePath.closeSubpath()
        triangle.path = trianglePath
        triangle.fillColor = .white
        triangle.strokeColor = .clear

        let trianglePhysicsBody = SKPhysicsBody(polygonFrom: trianglePath)
        trianglePhysicsBody.affectedByGravity = false
        trianglePhysicsBody.isDynamic = false
        trianglePhysicsBody.restitution = 0.5
        triangle.physicsBody = trianglePhysicsBody

        newScene.addChild(triangle)

        return newScene
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
