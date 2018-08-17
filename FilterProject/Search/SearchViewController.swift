//
//  SearchViewController.swift
//  FilterProject
//
//  Created by Artem Kolyadin on 13.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

// MARK: - States for FilterContainerView animation

private enum State {
    case closed
    case open
    
    var opposite: State {
        return self == .open ? .closed : .open
    }
}

class SearchViewController: UITableViewController {
    
    
    private lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        return blurView
    }()
    
    private lazy var filterView: FiltersContainerView = {
        let view = FiltersContainerView(frame: self.navigationController!.view.frame)
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        return view
    }()
    
    var filterViewOffset: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
    }

    private var bottomConstraint = NSLayoutConstraint()
    
    func filterLayout () {
        navigationController?.view.addSubview(blurView)
        blurView.leadingAnchor.constraint(equalTo: (navigationController?.view.leadingAnchor)!).isActive = true
        blurView.trailingAnchor.constraint(equalTo: (navigationController?.view.trailingAnchor)!).isActive = true
        blurView.topAnchor.constraint(equalTo: (navigationController?.view.topAnchor)!).isActive = true
        blurView.bottomAnchor.constraint(equalTo: (navigationController?.view.bottomAnchor)!).isActive = true
        blurView.frame = (navigationController?.view.frame)!
        blurView.isHidden = true
        
        filterViewOffset = (self.navigationController?.view.frame.size.height)!
        
        filterView.tappableView.addGestureRecognizer(panRecognizer)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.view.addSubview(filterView)
        filterView.leadingAnchor.constraint(equalTo: (navigationController?.view.leadingAnchor)!).isActive = true
        filterView.trailingAnchor.constraint(equalTo: (navigationController?.view.trailingAnchor)!).isActive = true
        bottomConstraint = filterView.bottomAnchor.constraint(equalTo: (navigationController?.view.bottomAnchor)!, constant: (navigationController?.view.frame.height)!)
        bottomConstraint.isActive = true
        filterView.heightAnchor.constraint(equalToConstant: (navigationController?.view.frame.height)!).isActive = true
        filterView.roundedCornerView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        self.blurView.isHidden = false
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.filterView.roundedCornerView.layer.cornerRadius = 14
            case .closed:
                self.bottomConstraint.constant = self.filterViewOffset! + self.filterView.lineAngleIndicatorContainer.frame.height
                self.filterView.roundedCornerView.layer.cornerRadius = 0
            }
            self.navigationController?.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.filterViewOffset! + self.filterView.lineAngleIndicatorContainer.frame.height
            }
            
            // remove all runningcl animators
            self.runningAnimators.removeAll()
        }
        
        let lineAngleAnimator = UIViewPropertyAnimator (duration: duration, dampingRatio: 1 , animations: {
            switch state {
            case .open:
                self.filterView.lineAngleIndicator.alpha = 1.0
            case .closed:
                self.filterView.lineAngleIndicator.alpha = 0.0
            }
        })
        
        let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.blurView.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            case .closed:
                self.blurView.effect = nil
            }
        })
        
        blurAnimator.scrubsLinearly = false
        lineAngleAnimator.startAnimation()
        blurAnimator.startAnimation()
        transitionAnimator.startAnimation()
        
        blurAnimator.addCompletion { _ in
            switch self.currentState {
            case .open:
                self.blurView.isHidden = false
            case .closed:
                self.blurView.isHidden = true
            }
        }
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(blurAnimator)
        runningAnimators.append(lineAngleAnimator)
    }
    
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.75)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: filterView)
            var fraction = -translation.y / filterViewOffset!
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: filterView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
    
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        animateTransitionIfNeeded(to: .open, duration: 0.7)
    }
    
    // MARK: - InstantPanGestureRecognizer
    
    /// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
    class InstantPanGestureRecognizer: UIPanGestureRecognizer {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            if (self.state == UIGestureRecognizerState.began) { return }
            super.touchesBegan(touches, with: event)
            self.state = UIGestureRecognizerState.began
        }
        
    }
    
}

    // MARK:  UITableViewDatasource

extension SearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(describing: indexPath.row)
        return cell
    }
}
