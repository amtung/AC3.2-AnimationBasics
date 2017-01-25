//
//  TouchAnimatorViewController.swift
//  AC3.2-AnimationBasics
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 Access Code. All rights reserved.
//

import UIKit
import SnapKit

class TouchAnimatorViewController: UIViewController {
    
    var animator: UIViewPropertyAnimator? = UIViewPropertyAnimator(duration: 2.0, curve: .linear, animations: nil)
    let squareSize = CGSize(width: 100.0, height: 100.0)
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        configureConstraints()
    }
    
    
    // MARK: - Setup
    private func configureConstraints() {
        darkBlueView.snp.makeConstraints{ view in
            view.center.equalToSuperview()
            view.size.equalTo(squareSize)
        }
    }
    
    private func setupViewHierarchy() {
        self.view.backgroundColor = .white
        self.view.isUserInteractionEnabled = true
        
        view.addSubview(darkBlueView)
    }
    
    
    // MARK: - Movement
    internal func move(view: UIView, to point: CGPoint) {
        
        view.snp.remakeConstraints { (view) in
            view.center.equalTo(point)
            view.size.equalTo(squareSize)
        }
        
        let animator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.9) {
            self.view.layoutIfNeeded()
        }
        
        animator.addAnimations({
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, delayFactor: 0.15)
        
        animator.addAnimations({
            view.transform = CGAffineTransform.identity
            }, delayFactor: 0.85)
        
        animator.startAnimation()
    }
    
    internal func pickUp(view: UIView) {
        // 1. Give self.animator a value, right now it's nil
        // 2. Add a scale transform to the view that is being passed in 
        // 3. Animate that scale transform
        // 4. Call this function from touchesBegan
    }
    
    internal func putDownView(view: UIView) {
        // 1. Give self.animator a value, even if it isn't nil
        // 2. Add a scale transform to the view to make it CGAffineTransform.identity
        // 3. Animate that identity transform
        // 4. Call this function from touchesEnded
    }
    
    
    // MARK: - Tracking Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            print("No touching!")
            return
        }
        
        let touchLocationInView = touch.location(in: view)
        //    print("Touch at: \(touchLocationInView)")
        
        move(view: darkBlueView, to: touchLocationInView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            print("No touching!")
            return
        }
        
        let touchLocationInView = touch.location(in: view)
        move(view: darkBlueView, to: touchLocationInView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    // MARK: - Views
    internal lazy var darkBlueView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.darkBlue
        return view
    }()
}
