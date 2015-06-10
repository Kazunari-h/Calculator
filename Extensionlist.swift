import UIKit

extension UIColor {
    class func hexColor(hex:Int,alpha:Float = 1.0) -> UIColor{
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >>  8) & 0xFF)
        let b = Float((hex)       & 0xFF)
        return UIColor(red:CGFloat(r/255.0),green:CGFloat(g/255.0),blue:CGFloat(b/255.0),alpha:CGFloat(alpha))
    }
    
    class func hexColor(hex:Int) -> UIColor{
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >>  8) & 0xFF)
        let b = Float((hex)       & 0xFF)
        return UIColor(red:CGFloat(r/255.0),green:CGFloat(g/255.0),blue:CGFloat(b/255.0),alpha:CGFloat(1))
    }
}
