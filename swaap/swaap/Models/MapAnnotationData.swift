//
//  MapAnnotationData.swift
//  swaap
//
//  Created by Marlon Raskin on 1/9/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import MapKit

class MapAnnotationData: NSObject, MKAnnotation {
	var title: String?
	var subtitle: String?
	var coordinate: CLLocationCoordinate2D

	init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.subtitle = subtitle
		self.coordinate = coordinate

		super.init()
	}

	var locationName: String? {
		title
	}
}
