//
//  BasicsViewController.swift
//  ARKit-Emperor
//
//  Created by Kiyoto Ryuman on 2019/01/26.
//  Copyright © 2019 Kiyoto Ryuman. All rights reserved.
//

import UIKit
import ARKit

class BasicsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        sceneView.session.run(configuration, options: [])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ship = SCNScene(named: "art.scnassets/ship.scn")!
        let shipNode = ship.rootNode.childNodes.first!
        shipNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        // カメラ座標系で30cm手前
        let inFrontCamera = SCNVector3Make(0, 0, -0.3)
        
        guard let cameraNode = sceneView.pointOfView else {
            return
        }
        // ワールド座標系
        let pointInWorld = cameraNode.convertPosition(inFrontCamera, to: nil)
        
        // スクリーン座標系へ
        var screenPosition = sceneView.projectPoint(pointInWorld)
        // スクリーン座標系
        guard let location: CGPoint = touches.first?.location(in: sceneView) else{
            return
        }
        screenPosition.x = Float(location.x)
        screenPosition.y = Float(location.y)
        //ワールド座標系へ
        let finalPosition = sceneView.unprojectPoint(screenPosition)
        
        
        shipNode.eulerAngles = cameraNode.eulerAngles
        shipNode.position = finalPosition
        
        sceneView.scene.rootNode.addChildNode(shipNode)
    }
    
}
// MARK: - ARSCNViewDelegate
extension BasicsViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("anchor added")
        
        if anchor is ARPlaneAnchor {
            print("This is ARPlaneAnchor.")
        }
    }
}
