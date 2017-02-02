//
//  PracticeViewController.swift
//  AC3.2-AnimationBasics
//
//  Created by Annie Tung on 2/1/17.
//  Copyright © 2017 Access Code. All rights reserved.
//

import UIKit
import SnapKit

class PracticeViewController: UIViewController {
    
    var animator = UIViewPropertyAnimator(duration: 2.0, curve: UIViewAnimationCurve.easeIn, animations: nil)
    var dynamicAnimator: UIDynamicAnimator? = nil
    let squareSize = CGSize(width: 100, height: 100)
    var isHeld = true
    var firstAnimationHappening = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupHierarchy()
        configureConstraints()
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        animateView()
        setupGravity()
    }
    
    // MARK: - Set up
    
    func setupHierarchy() {
        self.view.addSubview(blueView)
    }
    
    func configureConstraints() {
        blueView.snp.makeConstraints { (view) in
            view.top.leading.equalToSuperview()
            view.size.equalTo(squareSize)
        }
    }
    
    func setupGravity() {
        let gravityBehavior = UIGravityBehavior(items: [blueView])
        gravityBehavior.angle = CGFloat.pi / 8
        gravityBehavior.magnitude = 0.2
        dynamicAnimator?.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [blueView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator?.addBehavior(collisionBehavior)
        
        let elasticBehavior = UIDynamicItemBehavior(items: [blueView])
        elasticBehavior.elasticity = 0.5
        dynamicAnimator?.addBehavior(elasticBehavior)
    }
    
    func animateView() {
        self.blueView.snp.remakeConstraints { (view) in
            view.bottom.trailing.equalToSuperview()
            view.size.equalTo(self.squareSize)
        }
        animator.addAnimations {
            
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    // MARK: - Methods
    
    func pickup(view: UIView) {
        firstAnimationHappening = true
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        let rotationAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            view.transform = CGAffineTransform(rotationAngle: 180)
            self.firstAnimationHappening = false
        }
        animator.startAnimation()
        rotationAnimator.startAnimation()
    }
    
    func dropOff(view: UIView) {
        if !firstAnimationHappening {
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            view.transform = CGAffineTransform.identity
        }
        animator.startAnimation()
        }
    }
    
    func move(view: UIView, toPoint: CGPoint) {
//        if animator.isRunning {
//            animator.addAnimations {
//                self.view.layoutIfNeeded()
//            }
//        }
//        blueView.snp.remakeConstraints { (view) in
//            view.center.equalTo(toPoint)
//            view.size.equalTo(squareSize)
//        }
        let snapBehavior = UISnapBehavior(item: view, snapTo: toPoint)
        let _ = dynamicAnimator?.behaviors.map {
            if $0 is UISnapBehavior {
                self.dynamicAnimator?.removeBehavior($0)
            }
        }
        dynamicAnimator?.addBehavior(snapBehavior)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if blueView.frame.contains(touch.location(in: view)) {
            isHeld = true
            pickup(view: blueView)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHeld = false
        dropOff(view: blueView)
        
        let _ = dynamicAnimator?.behaviors.map {
            if $0 is UISnapBehavior {
                self.dynamicAnimator?.removeBehavior($0)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isHeld else { return }
        move(view: blueView, toPoint: touch.location(in: view))
    }
    
    var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
}
