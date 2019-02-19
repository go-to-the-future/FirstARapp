//
//  MirrorViewController.swift
//  ARKit-Emperor
//
//  Created by Kiyoto Ryuman on 2019/01/27.
//  Copyright © 2019 Kiyoto Ryuman. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MirrorViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let mirror = SCNScene(named: "art.scnassets/ojisanobachanmotion.scn")!
        let mirrorNode = mirror.rootNode.childNodes.first!
        mirrorNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        // カメラ座標系で50cm手前
        let inFrontCamera = SCNVector3Make(0, 0, -0.5)
        
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
        

        mirrorNode.position = finalPosition
        
        sceneView.scene.rootNode.addChildNode(mirrorNode)
    }
}

// MARK: - <#ARSCNViewDelegate#>
extension MirrorViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
