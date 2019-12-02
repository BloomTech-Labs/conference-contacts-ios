//
//  InteractivePopRecognizer.swift
//  swaap
//
//  Created by Marlon Raskin on 12/2/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {

    var navigationController: UINavigationController

    init(controller: UINavigationController) {
        self.navigationController = controller
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }

    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
