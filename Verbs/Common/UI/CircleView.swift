//
//  CircleView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class CircleView: UIView {
    
    var color: UIColor = AccentColor.current.color {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bounds = frame.insetBy(dx: 1, dy: 0)
    }
    
    override func draw(_ rect: CGRect) {
        let rectange = CGRect(x: frame.minX + 10,
                              y: frame.minY + 10,
                              width: frame.width - 20,
                              height: frame.height - 20)
        let ovalPath = UIBezierPath(ovalIn: rectange)
        color.setStroke()
        ovalPath.lineWidth = 3
        ovalPath.stroke()
        
        let rectange2 = CGRect(x: frame.minX + 15,
                               y: frame.minY + 15,
                               width: frame.width - 30,
                               height: frame.height - 30)
        let oval2Path = UIBezierPath(ovalIn: rectange2)
        color.setFill()
        oval2Path.fill()
    }
}
