//
//  MeetingLocationView.swift
//  swaap
//
//  Created by Marlon Raskin on 1/6/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import UIKit
import IBPreview
import MapKit
import CoreLocation

@IBDesignable
class MeetingLocationView: IBPreviewControl {

	@IBOutlet private var contentView: UIView!
	@IBOutlet private weak var headerLabel: UILabel!
	@IBOutlet private weak var locationLabel: UILabel!
	@IBOutlet private weak var mapView: MKMapView!

	var header: String {
		get { headerLabel.text ?? "" }
		set { headerLabel.text = newValue }
	}

	var location: MeetingCoordinate? {
		didSet {
			centerMapOnLocation()
		}
	}

	var locationName: String? {
		didSet {
			locationLabel.text = locationName
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		guard !isInterfaceBuilder else { return }
		let nib = UINib(nibName: "MeetingLocationView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.layer.masksToBounds = true
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		self.backgroundColor = .clear
		//		location = CLLocation(latitude: 21.282778, longitude: -157.829444)
		configureMapView()
	}

	private func configureMapView() {
		mapView.layer.cornerRadius = 20
		mapView.layer.cornerCurve = .continuous
	}

	private func centerMapOnLocation() {
		guard let location = location else { return }
		let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		let displayDistance = max(location.distance * 2, 500)
		let coordinateRegion = MKCoordinateRegion(center: loc.coordinate,
												  latitudinalMeters: displayDistance,
												  longitudinalMeters: displayDistance)
		mapView.setRegion(coordinateRegion, animated: true)
		reverseGeocodeForCityname()
	}

	func reverseGeocodeForCityname() {
		guard let location = location else { return }
		if location.distance > 1000 {
			self.locationName = "Remote Connection"
		} else {
			let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			loc.fetchCityAndCountry { city, _, error in
				guard let city = city, error == nil else { return }
				DispatchQueue.main.async {
					self.locationName = city
				}
			}
		}
	}
}

extension CLLocation {
	func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
		CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
	}
}
