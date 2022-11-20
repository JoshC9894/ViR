//
//  EyeTracker.swift
//  KeepieUpiee
//
//  Created by Joshua Colley on 19/11/2022.
//

import ARKit

protocol EyeTrackerDelegate {
    func gazeDidMove(_ face: ARFaceAnchor) 
}

class EyeTracker: NSObject {
    let view = ARSCNView()
    var delegate: EyeTrackerDelegate?
    
    override init() {
        super.init()
        view.delegate = self
        if let scene = SCNScene(named: "TrackingScene") {
            view.scene = scene
        }
    }
    
    func trackEyes() {
        let config = ARFaceTrackingConfiguration()
        view.session.run(config)
    }
    
    func stopTracking() {
        view.session.pause()
    }
}

extension EyeTracker: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = view.device else { fatalError() }
        let mesh = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: mesh)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor,
           let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            
            print("@DEBUG X: \(faceAnchor.lookAtPoint.x)")
            self.delegate?.gazeDidMove(faceAnchor)
        }
    }
}
