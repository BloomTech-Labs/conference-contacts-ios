//
//  NavigationControllerExtension.swift
//  swaap
//
//  Created by Marlon Raskin on 12/5/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func installBlurEffect() {

        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
		let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        blurView.layer.zPosition = -1
    }
}
