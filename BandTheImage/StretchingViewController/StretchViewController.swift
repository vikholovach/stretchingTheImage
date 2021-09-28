//
//  StretchViewController.swift
//  BandTheImage
//
//  Created by VikHolovach on 16.09.2021.
//


import UIKit
import BCMeshTransformView

class StretchViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var fingerCircle: UIImageView!
    var fingerCirclePoint: CGPoint!
    var transformView: BCMeshTransformView!
    var imageView: UIImageView!
    var transform: BCMutableMeshTransform!
    fileprivate var startPoint:CGPoint?
    var imageToChange = [UIImage(named: "testImage.jpg")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMeshAction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // to redraw image for smooth animation
        backgroundImage.image = imageToChange.last!
        imageView.removeFromSuperview()
        transformView.removeFromSuperview()
        setupMeshAction()
    }
    
    func setupMeshAction() {
        transformView = BCMeshTransformView(frame: self.view.bounds)
        imageView = UIImageView(image: imageToChange.last!)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = transformView.bounds
        transformView.contentView.addSubview(imageView)
        mainContainer.addSubview(transformView)
        mainContainer.bringSubviewToFront(fingerCircle)
    }
    
    
    override func touchesBegan(_ sender: Set<UITouch>, with event: UIEvent?) {
        guard let touch = sender.first else { return }
        startPoint = touch.location(in: self.transformView)
        fingerCirclePoint = touch.location(in: self.view)
        fingerCircle.center = fingerCirclePoint
        if !self.view.bounds.contains(fingerCircle.center) {
            fingerCircle.center = transformView.center
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let startPoint_ = startPoint else { return }
        guard let touch = touches.first else { return }
        fingerCirclePoint = touch.location(in: self.view)
        let position = touch.location(in: self.transformView)
        fingerCircle.center = fingerCirclePoint
        transformView.meshTransform = BCMutableMeshTransform.warpTransform(from: startPoint_, to: position, in: self.transformView.bounds.size)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let image = transformView.takeScreenshot()
        imageToChange.append(image)
        backgroundImage.image = imageToChange.last!
        imageView.removeFromSuperview()
        transformView.removeFromSuperview()
        setupMeshAction()
    }
    
    
}
