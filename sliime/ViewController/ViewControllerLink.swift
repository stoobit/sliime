//
//  ViewControllerLink.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import UIKit

extension ViewController {
    func setupDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func step(displaylink: CADisplayLink) {
        print(displaylink.targetTimestamp)
    }
}
