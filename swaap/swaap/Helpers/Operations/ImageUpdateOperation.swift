//
//  ImageUpdateOperation.swift
//  swaap
//
//  Created by Michael Redig on 1/4/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import Foundation

class ImageUpdateOperation: ConcurrentOperation {
	var updatedImageURL: URL?
	var profileController: ProfileController?

	let imageData: Data

	init(profileController: ProfileController?, imageData: Data) {
		self.imageData = imageData
		self.profileController = profileController
		super.init(task: {})
	}

	override func start() {

		state = .isExecuting

		profileController?.uploadImageData(imageData, completion: { result in
			defer {
				self.state = .isFinished
			}
			do {
				self.updatedImageURL = try result.get()
			} catch {
				NSLog("Error uploading image: \(error)")

			}
		})
	}
}
