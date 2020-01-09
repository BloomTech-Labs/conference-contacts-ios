//
//  ConcurrentOperation.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class ConcurrentOperation: Operation {

	// MARK: Types

	enum State: String {
		case isReady, isExecuting, isFinished
	}

	// MARK: Properties
	let task: () -> Void

	private var _state = State.isReady

	private let stateQueue = DispatchQueue(label: "com.swaap.concurrentStateQueue")
	var state: State {
		get {
			var result: State?
			let queue = self.stateQueue
			queue.sync {
				result = _state
			}
			return result!
		}

		set {
			let oldValue = state
			willChangeValue(forKey: newValue.rawValue)
			willChangeValue(forKey: oldValue.rawValue)

			stateQueue.sync { self._state = newValue }

			didChangeValue(forKey: oldValue.rawValue)
			didChangeValue(forKey: newValue.rawValue)
		}
	}

	// MARK: NSOperation

	override dynamic var isReady: Bool { super.isReady && state == .isReady }

	override dynamic var isExecuting: Bool { state == .isExecuting }

	override dynamic var isFinished: Bool { state == .isFinished }

	override var isAsynchronous: Bool { true }

	init(task: @escaping () -> Void) {
		self.task = task
		super.init()
	}

	override func start() {
		defer {
			state = .isFinished
		}
		state = .isExecuting
		task()
	}
}
