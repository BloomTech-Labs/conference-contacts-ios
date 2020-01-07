//
//  LocationHandler.swift
//  LambdaTimeline
//
//  Created by Michael Redig on 10/3/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationHandlerDelegate: AnyObject {
	func locationRequester(_ locationRequester: LocationHandler, didUpdateLocation location: CLLocation)
}

class LocationHandler: NSObject {

	private lazy var manager: CLLocationManager = {
		let manager = CLLocationManager()
		manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		manager.delegate = self
		return manager
	}()

	var lastLocation: CLLocation?
	weak var delegate: LocationHandlerDelegate?

	var isAuthorized: Bool {
		switch CLLocationManager.authorizationStatus() {
		case .authorizedAlways, .authorizedWhenInUse:
			return true
		default:
			return false
		}
	}

	func requestAuth() {
		manager.requestWhenInUseAuthorization()
	}

	func singleLocationRequest() {
		manager.requestLocation()
	}

	func startTrackingLocation() {
		manager.startUpdatingLocation()
	}

	func stopTrackingLocation() {
		manager.stopUpdatingLocation()
	}
}

extension LocationHandler: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else { return }
		lastLocation = location
		delegate?.locationRequester(self, didUpdateLocation: location)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Location request failed with error: \(error)")
	}
}

extension CLLocationCoordinate2D {
    func midPoint(from location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
		let toRad = Double.pi / 180
		let toDeg = 180 / Double.pi

		let lon1 = longitude * toRad
		let lon2 = location.longitude * toRad
		let lat1 = latitude * toRad
		let lat2 = location.latitude * toRad
        let dLon = lon2 - lon1
        let xVal = cos(lat2) * cos(dLon)
        let yVal = cos(lat2) * sin(dLon)
        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + xVal) * (cos(lat1) + xVal) + yVal * yVal))
        let lon3 = lon1 + atan2(yVal, cos(lat1) + xVal)

		return CLLocationCoordinate2D(latitude: lat3 * toDeg, longitude: lon3 * toDeg)
    }
}
