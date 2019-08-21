//
//  ViewController.swift
//  20
//
//  Created by 吉冨優太 on 2019/08/20.
//  Copyright © 2019 吉冨優太. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Create a new scene
        let ship = SCNScene(named: "art.scnassets/ship.scn")!
        let shipNode = ship.rootNode.childNodes.first!
        shipNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        //カメラ座標系で30cm前
        let infrontCamera = SCNVector3(0, 0, -0.3)
        
        guard let cameraNode = sceneView.pointOfView else {
            return
        }
        
        //ワールド座標系
        let pointInWorld = cameraNode.convertPosition(infrontCamera, to: nil)
        
        //スクリーン座標系へ
        var screenPosition = sceneView.projectPoint(pointInWorld)
        
        //スクリーン座標系
        guard let location: CGPoint = touches.first?.location(in: sceneView) else {
            return
        }
        screenPosition.x = Float(location.x)
        screenPosition.y = Float(location.y)
        
        //ワールド座標系
        let finalPosition = sceneView.unprojectPoint(screenPosition)
        
        shipNode.eulerAngles = cameraNode.eulerAngles
        shipNode.position = finalPosition
        sceneView.scene.rootNode.addChildNode(shipNode)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("anchor added")
        
        if anchor is ARPlaneAnchor {
            print("this is ARPlaneAnchor.")
        }
    }
}
