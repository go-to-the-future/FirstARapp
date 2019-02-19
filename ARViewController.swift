//
//  ARViewController.swift
//  ARKit-Emperor
//
//  Created by Kiyoto Ryuman on 2019/01/27.
//  Copyright © 2019 Kiyoto Ryuman. All rights reserved.
//


import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController {
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
    
}

// MARK: - <#ARSCNViewDelegate#>
extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}

