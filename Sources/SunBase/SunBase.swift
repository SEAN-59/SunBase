#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

typealias originX = CGPoint

//public struct SunBase {
//    private var isToastOn: Bool = false
//
//    public private(set) var text = "Hello, World!"
//
//    public init() {}
//
//
//}

public final class SunBase {
    public private(set) var text = "Hello, World!"
}


class SunLabel: UILabel {
    private var padding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    
    public func padding(top: CGFloat,left: CGFloat,bottom: CGFloat,right: CGFloat) {
        padding.top = top
        padding.left = left
        padding.bottom = bottom
        padding.right = right
    }
//    UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}
