//
//  FadeTableView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FadeTableView: UITableView, UIScrollViewDelegate {

    private let fadePercentage = 0.3
    private let gradientLayer = CAGradientLayer()
    private let transparentColor = UIColor.clear.cgColor
    private let opaqueColor = UIColor.black.cgColor

    var topOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y

        let alpha: CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset <= 0) ? 1 : 0

        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }

    var bottomOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y

        let isAlphaFull = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset + scrollViewHeight >= scrollContentSizeHeight)
        let alpha: CGFloat = isAlphaFull ? 1 : 0

        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let maskLayer = CALayer()
        maskLayer.frame = bounds

        gradientLayer.frame = CGRect(x: bounds.origin.x,
                                     y: 0,
                                     width: bounds.size.width,
                                     height: bounds.size.height)
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
        gradientLayer.locations = [0,
                                   NSNumber(floatLiteral: fadePercentage),
                                   NSNumber(floatLiteral: 1 - fadePercentage), 1]
        maskLayer.addSublayer(gradientLayer)

        self.layer.mask = maskLayer
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
    }
}
