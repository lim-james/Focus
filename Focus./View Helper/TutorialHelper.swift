//
//  TutorialHelper.swift
//  Focus.
//
//  Created by James on 28/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

enum Tutorial {
    case none
    case new
    case title
    case time
    case start
}

extension ViewController: TutorialDelegate {
    
    func updateTutorial() {
        if tutorial == .none {
            if tasks.isEmpty { setTutorialStatus(to: .new) }
            else { setTutorialStatus(to: .start) }
        } else {
            setTutorialStatus(to: .none)
        }
    }
    
    func setupOverlays() {
        let layers = [newOverlay, titleOverlay, editOverlay, topCoverOverlay, bottomLine]
        for layer in layers {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeTutorial))
            layer?.addGestureRecognizer(tap)
        }
    }
    
    @objc func closeTutorial() {
        setTutorialStatus(to: .none)
    }
    
    func showOverlays() {
        newOverlay.isHidden = false
        titleOverlay.isHidden = false
        editOverlay.isHidden = false
        
        topCoverOverlay.isHidden = false
        bottomCoverOverlay.isHidden = false
        
        newHelpOverlay.isHidden = false
        titleHelpOverlay.isHidden = false
        timeHelpOverlay.isHidden = false
        startHelpOverlay.isHidden = false
    }
    
    func hideOverlays() {
        newOverlay.isHidden = true
        titleOverlay.isHidden = true
        editOverlay.isHidden = true
        
        topCoverOverlay.isHidden = true
        bottomCoverOverlay.isHidden = true
        
        newHelpOverlay.isHidden = true
        titleHelpOverlay.isHidden = true
        timeHelpOverlay.isHidden = false
        startHelpOverlay.isHidden = true
    }
    
    func fadeInOverlays() {
        UIView.animate(withDuration: 0.25) {
            self.newOverlay.alpha = self.overlayAlpha
            self.titleOverlay.alpha = self.overlayAlpha
            self.editOverlay.alpha = self.overlayAlpha
            
            self.topCoverOverlay.alpha = self.overlayAlpha
            self.bottomCoverOverlay.alpha = self.overlayAlpha
            
            self.newHelpOverlay.alpha = self.overlayAlpha
            self.titleHelpOverlay.alpha = self.overlayAlpha
            self.timeHelpOverlay.alpha = self.overlayAlpha
            self.startHelpOverlay.alpha = self.overlayAlpha
        }
    }
    
    func fadeOutOverlays() {
        UIView.animate(withDuration: 0.25, animations: {
            self.newOverlay.alpha = 0
            self.titleOverlay.alpha = 0
            self.editOverlay.alpha = 0
            
            self.topCoverOverlay.alpha = 0
            self.bottomCoverOverlay.alpha = 0
            
            self.newHelpOverlay.alpha = 0
            self.titleHelpOverlay.alpha = 0
            self.timeHelpOverlay.alpha = 0
            self.startHelpOverlay.alpha = 0
        }) { (Bool) in
            self.hideOverlays()
        }
    }
    
    func newTutorial() {
        showOverlays()
        
        titleHelpOverlay.isHidden = true
        timeHelpOverlay.isHidden = true
        startHelpOverlay.isHidden = true
        
        newOverlay.isHidden = true
        
        fadeInOverlays()
    }
    
    func titleTutorial() {
        showOverlays()
        
        newHelpOverlay.isHidden = true
        timeHelpOverlay.isHidden = true
        startHelpOverlay.isHidden = true
        
        titleOverlay.isHidden = true
        
        fadeInOverlays()
    }
    
    func timeTutorial() {
        showOverlays()
        
        newHelpOverlay.isHidden = true
        titleHelpOverlay.isHidden = true
        startHelpOverlay.isHidden = true
        
        titleOverlay.isHidden = true
        bottomCoverOverlay.isHidden = true
        newOverlay.isHidden = true
        
        fadeInOverlays()
    }
    
    func startTutorial() {
        showOverlays()
        newHelpOverlay.isHidden = true
        titleHelpOverlay.isHidden = true
        timeHelpOverlay.isHidden = true
        
        fadeInOverlays()
    }
    
    // Delegate methods
    
    func getTutorialStatus() -> Tutorial {
        return tutorial
    }
    
    func setTutorialStatus(to tutorial: Tutorial) {
        self.tutorial = tutorial
        switch tutorial {
        case .new: newTutorial()
        case .title: titleTutorial()
        case .time: timeTutorial()
        case .start: startTutorial()
        default:
            fadeOutOverlays()
            editButton.isEnabled = true
        }
    }
}
