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
	@IBOutlet private weak var locationButton: UIButton!
	@IBOutlet private weak var panButton: UIButton!
	@IBOutlet private weak var buttonsContainer: UIView!

	let panImage = UIImage(systemName: "hand.draw.fill")
	let noPanImage = UIImage(systemName: "hand.draw")

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

	var isScrollingEnabled: Bool = false

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

		mapView.isScrollEnabled = isScrollingEnabled
		buttonsContainer.clipsToBounds = true
		buttonsContainer.layer.cornerRadius = buttonsContainer.frame.width / 2

		self.backgroundColor = .clear
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
		configureAnnotation()
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

	private func configureAnnotation() {
		guard let location = location,
			let locationName = locationName else { return }
		let coords = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		let annotation = MapAnnotationData(title: locationName, subtitle: nil, coordinate: coords)
		mapView.addAnnotation(annotation)
	}

	@IBAction func toggleMapViewPan(_ sender: UIButton) {
		mapView.isScrollEnabled = !isScrollingEnabled
		isScrollingEnabled.toggle()
		if isScrollingEnabled {
			panButton.setImage(panImage, for: .normal)
		} else {
			panButton.setImage(noPanImage, for: .normal)
		}
	}

	@IBAction func locateOriginalLocation(_ sender: UIButton) {
		centerMapOnLocation()
	}
}

extension MeetingLocationView: MKMapViewDelegate, UIScrollViewDelegate {

}

extension CLLocation {
	func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> Void) {
		CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
	}
}
