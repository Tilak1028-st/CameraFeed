//
//  ViewController.swift
//  CameraFeed
//
//  Created by PCS213 on 07/12/22.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var toogleCameraButton: UIButton!
    @IBOutlet weak var photoModeButton: UIButton!
    @IBOutlet weak var videoModeButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    
    let cameraController = CameraController()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleCaptureButton()
        self.configureCameraController()
        // Do any additional setup after loading the view.
    }

}

extension ViewController {
    func styleCaptureButton() {
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
    }
    
    func configureCameraController() {
             cameraController.prepare {(error) in
                 if let error = error {
                     print(error)
                 }
                 
                 try? self.cameraController.displayPreview(on: self.cameraPreviewView)
             }
         }
}

extension ViewController {
    @IBAction func toggleFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            toogleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            
        case .some(.rear):
            toogleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            
        case .none:
            return
        }
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
    
}
