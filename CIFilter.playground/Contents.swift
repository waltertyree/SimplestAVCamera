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
let inputColor = CIColor(color: UIColor.yellow)
filter.setValue(inputColor, forKey: kCIInputColorKey)
/*:
If you want to pass the image through multiple filters just you the filter.outputImage as the value for the kCIInputImageKey of the next filter you create.
*/
let monoKitty = filter.outputImage!
//CIPhotoEffectNoir
//CITwirlDistortion
//CIDiscBlur - takes a long time
let filter2 = CIFilter(name: "CIMotionBlur")!
filter2.setValue(monoKitty, forKey: kCIInputImageKey)


let histogramPic = filter2.outputImage!
