//
//  BusinessCardViewController.swift
//  ARKit-Emperor
//
//  Created by Kiyoto Ryuman on 2019/01/27.
//  Copyright © 2019 Kiyoto Ryuman. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class BusinessCardViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
   
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        configuration.detectionImages = images
        
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    let imageConfiguration: ARImageTrackingConfiguration = {
        let configuration = ARImageTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        configuration.trackingImages = images!
        return configuration
    }()
    
    private var buttonNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        buttonNode = SCNScene(named: "art.scnassets/birthdaycake.scn")!.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(imageConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
}

// MARK: - <#ARSCNViewDelegate#>
extension BusinessCardViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else {
            return
        }
        //名刺の上にボタンを表示
        node.addChildNode(buttonNode)
        print("imageAnchor!")
    }
}

