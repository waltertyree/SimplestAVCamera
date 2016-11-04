//
//  ImageReviewViewController.swift
//  AVCamera
//
//  Created by Walter Tyree on 3/26/16.
//  Copyright © 2016 Tyree Apps, LLC. All rights reserved.
//

import UIKit

class ImageReviewViewController: UIViewController {

    @IBOutlet weak var finalImage : UIImageView!
    var imageSource : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.finalImage.image = self.imageSource
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
