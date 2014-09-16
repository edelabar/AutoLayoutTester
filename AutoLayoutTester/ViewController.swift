//
//  ViewController.swift
//  autolayout-view-tester
//
//  Created by Eric DeLabar on 9/16/14.
//  Copyright (c) 2014 Eric DeLabar. All rights reserved.
//

import UIKit

enum PanDirection {
    case Up
    case Right
    case Down
    case Left
    
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var topArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var bottomArrow: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    var topArrowGesture: UIPanGestureRecognizer!
    var rightArrowGesture: UIPanGestureRecognizer!
    var bottomArrowGesture: UIPanGestureRecognizer!
    var leftArrowGesture: UIPanGestureRecognizer!
    
    var lastPoint: CGPoint!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.topArrowGesture = UIPanGestureRecognizer(target: self, action: Selector("handleTopPan:"))
        self.topArrow.addGestureRecognizer(self.topArrowGesture)
        
        self.rightArrowGesture = UIPanGestureRecognizer(target: self, action: Selector("handleRightPan:"))
        self.rightArrow.addGestureRecognizer(self.rightArrowGesture)
        
        self.bottomArrowGesture = UIPanGestureRecognizer(target: self, action: Selector("handleBottomPan:"))
        self.bottomArrow.addGestureRecognizer(self.bottomArrowGesture)
        
        self.leftArrowGesture = UIPanGestureRecognizer(target: self, action: Selector("handleLeftPan:"))
        self.leftArrow.addGestureRecognizer(self.leftArrowGesture)
        
    }
    
    func resize(activeConstraint aConstraint: NSLayoutConstraint, panGesture pan: UIPanGestureRecognizer, direction panDirection: PanDirection) {
        
        switch pan.state {
        case .Began:
            self.lastPoint = pan.locationInView(self.view)
        case .Changed:
            let point = pan.locationInView(self.view)
            
            var multiplier: CGFloat = 1
            if panDirection == .Left || panDirection == .Up {
                multiplier = -1
            }
            
            var amount: CGFloat = (self.lastPoint.x - point.x) * multiplier
            if panDirection == .Up || panDirection == .Down {
                amount = (self.lastPoint.y - point.y) * multiplier
            }
            
            let oppositeConstraint = self.oppositeConstraint(aConstraint)
            let totalConstraints = aConstraint.constant + oppositeConstraint.constant
            if totalConstraints + amount > self.view.bounds.width {
                amount = self.view.bounds.width - totalConstraints
            }
            
            aConstraint.constant += amount
            if aConstraint.constant < 44 {
                aConstraint.constant = 44
            }
            
            self.lastPoint = point
            
        default:
            self.lastPoint = nil;
        }
        
        self.view.setNeedsLayout()

    }
    
    func oppositeConstraint(aConstraint: NSLayoutConstraint) -> NSLayoutConstraint {
        if (aConstraint == self.topConstraint) {
            return self.bottomConstraint
        } else if (aConstraint == self.bottomConstraint) {
            return self.topConstraint
        } else if (aConstraint == self.rightConstraint) {
            return self.leftConstraint
        }
        return self.rightConstraint
    }

    func handleTopPan(pan: UIPanGestureRecognizer) {
        self.resize(activeConstraint: self.topConstraint, panGesture: pan, direction: .Up)
    }
    
    func handleRightPan(pan: UIPanGestureRecognizer) {
        self.resize(activeConstraint: self.rightConstraint, panGesture: pan, direction: .Right)
    }
    
    func handleBottomPan(pan: UIPanGestureRecognizer) {
        self.resize(activeConstraint: self.bottomConstraint, panGesture: pan, direction: .Down)
    }
    
    func handleLeftPan(pan: UIPanGestureRecognizer) {
        self.resize(activeConstraint: self.leftConstraint, panGesture: pan, direction: .Left)
    }
    
}

