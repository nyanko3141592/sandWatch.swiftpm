import SpriteKit
import SwiftUI

struct ContentView: View {
    @State private var isInverted: Bool = false // 上下反転の状態を管理する変数
    @State private var scene: SKScene = .init() // SpriteKitのシーンを管理する変数
    let ballNum: Int = 300
    let gravity: CGFloat = 9.8

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
                    scene.physicsWorld.gravity.dy = isInverted ? gravity : -gravity // 重力の方向を変更する
                }) {
                    Text("Reverse")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }.padding()
    }

    // シーンを作成する関数
    func createScene(size: CGSize) -> SKScene {
        let newScene = SKScene(size: size) // 新しいシーンを作成
        newScene.backgroundColor = .systemGray // シーンの背景色を設定
        newScene.physicsBody = SKPhysicsBody(edgeLoopFrom: newScene.frame) // シーンの境界に物理ボディを設定
        let ballDiameter: CGFloat = size.width / 15 // ボールの直径を管理する変数
        // 100個のボールを作成
        for _ in 0 ..< ballNum {
            let ball = SKShapeNode(circleOfRadius: ballDiameter / 2) // ボールの形状を作成
            ball.position = CGPoint(x: CGFloat.random(in: ballDiameter / 2...size.width - ballDiameter / 2), y: CGFloat.random(in: ballDiameter / 2...size.height / 2 - ballDiameter / 2)) // ボールの位置をランダムに設定
            ball.fillColor = .blue // ボールの塗りつぶし色を設定
            ball.strokeColor = .clear // ボールの線の色を透明に設定
            ball.physicsBody?.friction = 0

            let physicsBody = SKPhysicsBody(circleOfRadius: (ballDiameter / 2) * 0.5) // ボールの物理ボディを作成
            physicsBody.affectedByGravity = true // 重力の影響を受けるように設定
            physicsBody.allowsRotation = true
            physicsBody.restitution = 0
            physicsBody.usesPreciseCollisionDetection = true
            ball.physicsBody = physicsBody

            newScene.addChild(ball)
        }

        let a = size.width / 2 - ballDiameter * 1
        // 三角形の追加
        let triangle1 = SKShapeNode()
        let triangle1Path = CGMutablePath()
        triangle1Path.move(to: CGPoint(x: size.width, y: size.height / 2 - a))
        triangle1Path.addLine(to: CGPoint(x: size.width, y: size.height / 2 + a))
        triangle1Path.addLine(to: CGPoint(x: size.width - a, y: size.height / 2))
        triangle1Path.closeSubpath()
        triangle1.path = triangle1Path
        triangle1.fillColor = .white
        triangle1.strokeColor = .clear

        let trianglePhysicsBody = SKPhysicsBody(polygonFrom: triangle1Path)
        trianglePhysicsBody.affectedByGravity = false
        trianglePhysicsBody.isDynamic = false
        trianglePhysicsBody.restitution = 0
        trianglePhysicsBody.friction = 0
        triangle1.physicsBody = trianglePhysicsBody

        newScene.addChild(triangle1)

        // 三角形の追加
        let triangle2 = SKShapeNode()
        let triangle2Path = CGMutablePath()
        triangle2Path.move(to: CGPoint(x: 0, y: size.height / 2 - a))
        triangle2Path.addLine(to: CGPoint(x: 0, y: size.height / 2 + a))
        triangle2Path.addLine(to: CGPoint(x: a, y: size.height / 2))
        triangle2Path.closeSubpath()
        triangle2.path = triangle2Path
        triangle2.fillColor = .white
        triangle2.strokeColor = .clear

        let triangle2PhysicsBody = SKPhysicsBody(polygonFrom: triangle2Path)
        triangle2PhysicsBody.affectedByGravity = false
        triangle2PhysicsBody.isDynamic = false
        triangle2PhysicsBody.restitution = 0
        triangle2PhysicsBody.friction = 0
        triangle2.physicsBody = triangle2PhysicsBody

        newScene.addChild(triangle2)

        return newScene
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
