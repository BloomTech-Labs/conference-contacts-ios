//
//  Coordinator.swift
//  swaap
//
//  Created by Michael Redig on 11/12/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
//	var parentCoordinator: Coordinator? { get set }
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController { get set }

	func start()
}
