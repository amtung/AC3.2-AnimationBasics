//
//  ViewController.swift
//  AC3.2-AnimationBasics
//
//  Created by Louis Tur on 1/22/17.
//  Copyright © 2017 Access Code. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    static let animationDuration: TimeInterval = 4.0
    static let squareSize = CGSize(width: 100.0, height: 100.0)
    
    let darkBlueAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear, animations: nil)
    let tealAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeIn, animations: nil)
    let yellowAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut, animations: nil)
    let orangeAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut, animations: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        configureConstraints()
        
        addGesturesAndActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 1. We add these calls inside of viewDidAppear to defer the animations occuring
        // until after the self.view first appears. This gives us a little more time to view the actual animations.
        
        //    self.animateDarkBlueViewWithFrames()
        //    self.animateDarkBlueViewWithSnapkit()
        //    self.animateTealView()
        //    self.animateYellowView()
        //    self.animateOrangeView()
    }
    
    // MARK: - Set up
    
    private func setupViewHierarchy() {
        self.view.backgroundColor = .white
        // views
        self.view.addSubview(darkBlueView)
        self.view.addSubview(tealView)
        self.view.addSubview(yellowView)
        self.view.addSubview(orangeView)
        // button
        self.view.addSubview(animateButton)
        self.view.addSubview(resetAnimationsButton)
    }
    
    private func configureConstraints() {
        
        let _ = [darkBlueView, tealView, yellowView, orangeView].map{ $0.snp.removeConstraints() }
        // blue
        darkBlueView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalToSuperview().offset(20.0)
            view.size.equalTo(ViewController.squareSize)
        }
        // teal
        tealView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalTo(darkBlueView.snp.bottom).offset(20.0)
            view.size.equalTo(ViewController.squareSize)
        }
        // yellow
        yellowView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalTo(tealView.snp.bottom).offset(20.0)
            view.size.equalTo(ViewController.squareSize)
        }
        // orange
        orangeView.snp.makeConstraints { (view) in
            view.leading.equalToSuperview().offset(20.0)
            view.top.equalTo(yellowView.snp.bottom).offset(20.0)
            view.size.equalTo(ViewController.squareSize)
        }
        // button
        animateButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalToSuperview().inset(50.0)
            view.width.greaterThanOrEqualTo(100.0)
        }
        resetAnimationsButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(animateButton.snp.bottom).offset(8.0)
            view.width.greaterThanOrEqualTo(100.0)
        }
    }
    
    private func addGesturesAndActions() {
        self.animateButton.addTarget(self, action: #selector(animateViews), for: .touchUpInside)
        self.resetAnimationsButton.addTarget(self, action: #selector(resetAnimations), for: .touchUpInside)
    }
    
    // MARK: Property Animator
    
    internal func animateViews() {
        //    animateDarkBlueViewWithSnapkit()
        animateBlueViewWithAnimator()
        animateTealView()
        animateOrangeView()
        animateYellowView()
    }
    
    // MARK: - Animations
    
    internal func resetAnimations() {
        let _ = [darkBlueAnimator, tealAnimator, yellowAnimator, orangeAnimator].map{ $0.isReversed = true } // { $0.stopAnimation(true) }
        
        darkBlueAnimator.addCompletion { (position: UIViewAnimatingPosition) in
            switch position {
            case .start: print("Just started")
            case .end: print("Just ended")
            case .current: print("In progress")
            }
        }
        //        UIViewPropertyAnimator(duration: 1.0, curve: .linear) {
        //            let _ = [self.darkBlueView, self.tealView, self.yellowView, self.orangeView].map{ $0.transform = CGAffineTransform.identity }
        //        }.startAnimation()
        
        UIViewPropertyAnimator(duration: 3.0, controlPoint1: CGPoint(x: 0.97, y: 0), controlPoint2: CGPoint(x: 0.01, y: 1.01)) {
            let _ = [self.darkBlueView, self.tealView, self.yellowView, self.orangeView].map{ $0.transform = CGAffineTransform.identity }
            }.startAnimation()
        
        configureConstraints()
    }

    internal func animateDarkBlueViewWithSnapkit() {
        //    let newFrame = darkBlueView.frame.offsetBy(dx: 100.0, dy: 400.0)
        
        // 1. Can be used as a self contained class function, just like UIView.animate
        //    In  addition to using frames
        //    UIViewPropertyAnimator(duration: 1.0, curve: .linear) {
        //      self.darkBlueView.frame = newFrame
        //    }.startAnimation()
        
        // 2. Can be called and return a animator object for further changes
        let animator = UIViewPropertyAnimator(duration: ViewController.animationDuration, curve: .linear) {
            self.darkBlueView.snp.remakeConstraints { (view) in
                view.trailing.equalToSuperview().inset(20.0)
                view.top.equalToSuperview().offset(20.0)
                view.size.equalTo(ViewController.squareSize)
            }
            // 3. When animating the movement of views in a constraint-based layout,
            //    layoutIfNeeded() is used to indicate that the view needs to immediately
            //    re-lay themselves out based on new constraints. Having it inside of this
            //    animation block ensures that the changes are animated
            self.view.layoutIfNeeded()
        }
        // 4. Just like URLSessionDataTask, we need to launch the animator's animations by
        //    calling .startAnimation()
        animator.startAnimation()
    }
    
    internal func animateBlueViewWithAnimator() {
        self.darkBlueView.snp.remakeConstraints { (view) in
            view.trailing.equalToSuperview().inset(20.0)
            view.top.equalToSuperview().offset(20.0)
            view.size.equalTo(ViewController.squareSize)
        }
        darkBlueAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        darkBlueAnimator.addAnimations({
            self.darkBlueView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, delayFactor: 0.5)
        darkBlueAnimator.startAnimation()
    }
    
    internal func animateTealView() {
        tealView.snp.remakeConstraints { (view) in
            view.trailing.equalToSuperview().inset(20.0)
            view.top.equalTo(darkBlueView.snp.bottom).offset(20.0)
            view.size.equalTo(ViewController.squareSize)
        }
        tealAnimator.addAnimations({
            self.tealView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }, delayFactor: 0.25)
        tealAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        tealAnimator.startAnimation()
    }
    
    internal func animateYellowView() {
        yellowView.snp.remakeConstraints { (view) in
            view.trailing.equalToSuperview().inset(20.0)
            view.top.equalTo(tealView.snp.bottom).offset(20.0)
            view.size.equalTo(ViewController.squareSize)
        }
        yellowAnimator.addAnimations({
            self.yellowView.transform = CGAffineTransform(translationX: 0.0, y: 1000.0)
            }, delayFactor: 0.3)
        yellowAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        yellowAnimator.startAnimation()
    }
    
    internal func animateOrangeView() {
        orangeView.snp.remakeConstraints { (view) in
            view.trailing.equalToSuperview().inset(20.0)
            view.top.equalTo(yellowView.snp.bottom).offset(20.0)
            view.size.equalTo(ViewController.squareSize)
        }
        orangeAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }
        orangeAnimator.startAnimation()
    }
    
    // MARK: - Frames
    
    internal func animateDarkBlueViewWithFrames() {
        // 1. The view starts off with an initial frame of (x: 20, y: 20, w: 100, h: 100)
        //    due to the constraints we've set for it
        
        // 2. The newFrame is a derived frame from the original blueView, offset by a specified number of pts in the x & y axis
        let newFrame = darkBlueView.frame.offsetBy(dx: 300.0, dy: 550.0)
        UIView.animate(withDuration: 3.0) {
            // 3. We set an end state for the view
            // 4. The drawing engine takes care of the "tweening" (the in between states)
            //    of the animations for us. So we really only need to specify a starting state
            // and an ending state.
            self.darkBlueView.frame = newFrame // move the position of the view
            self.darkBlueView.alpha = 0.0 // makes the view transparent
            self.darkBlueView.backgroundColor = .green // changes the color from blue to green
        }
    }
    
    // MARK: - Lazy Inits
    
    internal lazy var darkBlueView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.darkBlue
        return view
    }()
    
    internal lazy var tealView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.teal
        return view
    }()
    
    internal lazy var yellowView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.yellow
        return view
    }()
    
    internal lazy var orangeView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.orange
        return view
    }()
    
    internal lazy var animateButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.setTitle("Animate", for: .normal)
        return button
    }()
    
    internal lazy var resetAnimationsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Reset", for: .normal)
        return button
    }()
}

