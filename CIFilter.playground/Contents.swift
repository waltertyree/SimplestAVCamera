/*:
# Using CoreGraphics Filters
*/
import UIKit
import CoreGraphics


let pic = CIImage(image: UIImage(named: "kitten1.jpg")!)!
let filter = CIFilter(name: "CIColorMonochrome")!
/*:
A list of ALL of the filters can be found at this [link](https://developer.apple.com/library/tvos/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP30000136-SW190) which goes to the Apple documentation

Set the parameters for the filter you chose, here. Remember that for most filters, there are "realistic" defaults so you can get something if you just pass in an image.
*/

filter.setValue(pic, forKey: kCIInputImageKey)
let inputColor = CIColor(color: UIColor.blackColor())
filter.setValue(inputColor, forKey: kCIInputColorKey)
/*:
If you want to pass the image through multiple filters just you the filter.outputImage as the value for the kCIInputImageKey of the next filter you create.
*/
let filter2 = CIFilter(name: "CIAreaHistogram")!
filter2.setValue(pic, forKey: kCIInputImageKey)
filter2.setValue(CIVector(CGRect:pic.extent), forKey: "inputExtent")
filter2.setValue(10, forKey: "inputCount")
filter2.setValue(0.5, forKey: "inputScale")
let filteredPic = filter.outputImage!

let histogramPic = filter2.outputImage!
