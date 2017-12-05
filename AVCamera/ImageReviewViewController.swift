//
//  ImageReviewViewController.swift
//  AVCamera
//
//  Created by Walter Tyree on a warm, Spring day.
//  Copyright © 2016 Tyree Apps, LLC. All rights reserved.
//

import UIKit

class ImageReviewViewController: UIViewController {

    @IBOutlet weak var finalImage : UIImageView!
    var imageSource : UIImage?

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.finalImage.image = self.imageSource
               self.finalImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
    }

}
