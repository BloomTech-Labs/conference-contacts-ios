//
//  OnboardingPageViewController.swift
//  swaap
//
//  Created by Chad Rutherford on 4/14/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
	let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setViewControllers([getScreenOne()], direction: .forward, animated: true)
		dataSource = self
	}
	
	func getScreenOne() -> ScreenOne {
		onboardingStoryboard.instantiateViewController(identifier: "ScreenOne") as ScreenOne
	}
	
	func getScreenTwo() -> ScreenTwo {
		onboardingStoryboard.instantiateViewController(identifier: "ScreenTwo") as ScreenTwo
	}
	
	func getScreenThree() -> ScreenThree {
		onboardingStoryboard.instantiateViewController(identifier: "ScreenThree") as ScreenThree
	}
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if viewController.isKind(of: ScreenThree.self) {
			return getScreenTwo()
		} else if viewController.isKind(of: ScreenTwo.self) {
			return getScreenOne()
		} else {
			return nil
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if viewController.isKind(of: ScreenOne.self) {
			return getScreenTwo()
		} else if viewController.isKind(of: ScreenTwo.self) {
			return getScreenThree()
		} else {
			return nil
		}
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		3
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		0
	}
}
