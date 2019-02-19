//
//  DoodleViewController.swift
//  ARKit-Emperor
//
//  Created by Kiyoto Ryuman on 2019/01/26.
//  Copyright © 2019 Kiyoto Ryuman. All rights reserved.
//

import UIKit
import ARKit

class DoodleViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    private var drawingNode: SCNNode?
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let node: SCNNode
        
        if let drawingNode = drawingNode{
                node = drawingNode.clone()
        }else{
            let lineNode = createBallLine()
            drawingNode = lineNode
            node = lineNode
        }
        
        //スクリーン座標系
        guard let location: CGPoint = touches.first?.location(in: sceneView) else {
            return
        }
        let pos: SCNVector3 = SCNVector3(location.x, location.y, 0.996)
        
        //ワールド座標系
        let finalPosition = sceneView.unprojectPoint(pos)
        
        node.position = finalPosition
        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    
    private func createBallLine() -> SCNNode{
        let ball = SCNSphere(radius: 0.005)
        
        let node = SCNNode(geometry: ball)
        return node
    }
}
// MARK: - ARSCNViewDelegate
extension DoodleViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("anchor added")
        
        if anchor is ARPlaneAnchor {
            print("This is ARPlaneAnchor.")
        }
    }
}
