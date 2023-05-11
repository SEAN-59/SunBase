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




public final class SunLabel: UILabel {
    private var padding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    
    public func padding(top: CGFloat,left: CGFloat,bottom: CGFloat,right: CGFloat) {
        padding.top = top
        padding.left = left
        padding.bottom = bottom
        padding.right = right
    }
//    UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}


public extension UIView {
    enum toastType{
        case simple
        case top
        case down
        case right
        case left
    }
    
    func showToast(message: String, type: toastType = .simple) {
        let toast: SunLabel = makeToast(message: message)
        self.addToast(toast)
        switch type{
        case .simple:
            self.simpleToast(toast: toast)
        case .top:
            print("up")
        case .down:
            print("up")
        case .right:
            print("up")
        case .left:
            print("up")
        }
    }
    
    private func simpleToast(toast: SunLabel) {
        toast.translatesAutoresizingMaskIntoConstraints = false
        [
            NSLayoutConstraint.init(item: toast,
                                attribute: .centerX,
                                relatedBy: .equal,
                                    toItem: toast.superview,
                                attribute: .centerX,
                                multiplier: 1,
                                 constant: 0),
            NSLayoutConstraint.init(item: toast,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: toast.superview,
                                attribute: .bottom,
                                multiplier: 1,
                                 constant: -200)
        ].forEach{$0.isActive = true}
        
        UIView.animate(withDuration: 3.0,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: {
            toast.alpha = 0.0
        },
                       completion: { _ in
            print("good")
        })

    }
    
    private func addToast<T>(_ toast: T) {
        guard let toast = toast as? UIView else { return }
        self.addSubview(toast)
    }
    
    private func makeToast(message: String) -> SunLabel {
        let label: SunLabel = {
            let label = SunLabel()
            label.padding(top: 10, left: 10, bottom: 10, right: 10)
            label.backgroundColor = .black.withAlphaComponent(0.5)
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 20.0)
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.6
            label.textAlignment = .center
            label.alpha = 1.0
            label.text = message
            label.layer.cornerRadius = label.font.pointSize / 2
            label.clipsToBounds = true
            return label
        }()
        
        return label
    }
}
