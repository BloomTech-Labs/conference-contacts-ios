//
//  ImageHelper.swift
//  swaap
//
//  Created by Marlon Raskin on 11/27/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable conditional_returns_on_newline

import UIKit
import ImageIO

extension UIImage {
	static let socialFacebookIcon = UIImage(named: "facebookIcon")!
	static let socialInstagramIconFill = UIImage(named: "instagramIconFill")!
	static let socialInstagramIconOutline = UIImage(named: "instagramIconOutline")!
	static let socialLinkedinIcon = UIImage(named: "linkedinIcon")!
	static let socialTwitterIcon = UIImage(named: "twitterIcon")!
	static let socialPhoneIcon = UIImage(systemName: "phone.fill.arrow.up.right")!
	static let socialEmailIcon = UIImage(systemName: "paperplane.fill")!
	static let socialTextIcon = UIImage(systemName: "message.fill")!
}


extension UIImage {
    /// Resize the image to a max dimension from size parameter
	func imageByScaling(toSize size: CGSize, inPixels pixels: Bool = false) -> UIImage? {

        guard let data = flattened.pngData(),
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                return nil
        }

		let screenScale = pixels ? 1.0 : UIScreen.main.scale

        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width * screenScale, size.height * screenScale),
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ]

        return CGImageSourceCreateThumbnailAtIndex(imageSource,
												   0,
												   options as CFDictionary)
			.flatMap {
				UIImage(cgImage: $0, scale: screenScale, orientation: .up)
		}
    }

    /// Renders the image if the pixel data was rotated due to orientation of camera
    var flattened: UIImage {
        if imageOrientation == .up { return self }
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
            draw(at: .zero)
        }
    }
}

extension CGFloat {
	var squaredSize: CGSize {
		CGSize(width: self, height: self)
	}
}
