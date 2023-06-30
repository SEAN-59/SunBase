#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

import SunBase

public final class SunExtension {
    
}

//MARK: - String
public extension String {
    
    func cut(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex,offsetBy: start)
        let endIndex = self.index(self.startIndex,offsetBy: end)
        let result: String = "\(self[startIndex ..< endIndex])"
        return result
    }
    
    func letter() -> [String] {
        return self.map { String($0) }
    }
    
    func word() -> [String] {
        return self.components(separatedBy: " ")
    }
}


//MARK: - Collection

/*
/// 이거 관련서는 일단 보류
public extension Collection {
    func sumArray<T>(_ someThing: T) -> Array<String> {
        if someThing is Array<Any> {
            if self is Array<String> {
                // String 일 경우에는 아무 상관 없이 그냥 붙여 버리면 그만
                if var selfValue = self as? Array<String> {
                    if let some = someThing as? Array<String> {
                        _ = some.map{ selfValue.append($0)}
                        return selfValue
                    }
                }
            } else if type(of: self) == type(of: someThing) {
                // 그외의 경우에는 같을 경우에만 붙어지게 해 둠
//                print(self + someThing)
//                self.map{$0.}
//                if var selfValue = self as? Array<String> {
//                    print(selfValue.append("\(someThing)"))
//
//                }
            } else {
                
            }
        }
        
//            print()}
//        print(type(of: someThing))
//        print((any Collection).self))
//        print(type(of: (any Collection).self))
//        if type(of:someThing) == (any Collection).self {
//            
//        }
        
//        if type(of: self) == type(of: [String]()) {
            
//        }
        return [""]
    }
}
 
 */

//MARK: - TOAST MESSAGE
enum simpleType{
    case top
    case down
}

public extension UIView {
    
    func showToast(message: String, type: simpleType = .down, constatns: CGFloat = 100, duration: CGFloat = 2.0, delay:CGFloat = 0.4 ,isRepeat: Bool = false) {
        var isSunLabel: Bool = false
        
        if isRepeat {
            self.subviews.forEach {
                if $0 is SunLabel {
                    isSunLabel = true
                }
            }
        }
        
        if !isSunLabel {
            let toast: SunLabel = makeToast(message: message)
            self.addToast(toast)
            
            switch type{
            case .down:
                self.simpleDownToast(toast: toast,constant: constatns,duration: duration,delay: delay)
            case .top:
                self.simpleTopToast(toast: toast,constant: constatns,duration: duration,delay: delay)
            }
//            self.willRemoveSubview(toast)
        }
    }
    
    func showIndicator(_ time: Double = 5, isTimer: Bool = false, completion: ((Bool) -> ())? = nil) {
        let indicator: SunIndicator = makeIndicatorToast()
        self.isUserInteractionEnabled = false
        self.subviews.forEach {
            if $0 is SunIndicator {
                $0.removeFromSuperview()
            }
        }
        self.addToast(indicator)
        indicator.startAnimating()

        self.indicatorToast(toast: indicator)
        
        if isTimer {
            SB.timer.startTimer(time) { result in
                switch result{
                case .success(_):
                    self.stopIndicator { isDone in
                        completion?(isDone)
                    }
                case .failure(let error):
                    print(error)
                }
            }
//            SB.timer.startTimer(time) { isStop in
//                if isStop {
//                    self.stopIndicator { isDone in
//                        completion?(isDone)
//                    }
//                }
//            }
        }
    }
    
    func stopIndicator(completion: ((Bool)->())? = nil) {
        var completionType: Bool = false
        self.isUserInteractionEnabled = true
        self.subviews.forEach {
            if $0 is SunIndicator {
                $0.removeFromSuperview()
                completionType = true
            }
        }
        completion?(completionType)
        
    }
    
    private func addToast<T>(_ toast: T) {
        guard let toast = toast as? UIView else { return }
        self.addSubview(toast)
    }
    
    //MARK: - Simple Toast Animation
    private func simpleDownToast(toast: SunLabel, constant: CGFloat, duration:CGFloat, delay:CGFloat) {
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
                                    constant: constant * -1),
            
            NSLayoutConstraint.init(item: toast,
                                    attribute: .leading,
                                    relatedBy: .greaterThanOrEqual,
                                    toItem: toast.superview,
                                    attribute: .leading,
                                    multiplier: 1,
                                    constant: 30)
        ].forEach{$0.isActive = true}
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseOut,
                       animations: {
            toast.alpha = 0.0
        },
                       completion: { _ in
            toast.removeFromSuperview()
            
        })
        
    }
    
    private func simpleTopToast(toast: SunLabel, constant: CGFloat, duration:CGFloat, delay:CGFloat) {
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
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: toast.superview,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: constant),
            
            NSLayoutConstraint.init(item: toast,
                                    attribute: .leading,
                                    relatedBy: .greaterThanOrEqual,
                                    toItem: toast.superview,
                                    attribute: .leading,
                                    multiplier: 1,
                                    constant: 30)
        ].forEach{$0.isActive = true}
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseOut,
                       animations: {
            toast.alpha = 0.0
        },
                       completion: { _ in
            toast.removeFromSuperview()
        })
        
    }
    
    //MARK: - Toast Indicator
    private func indicatorToast(toast: SunIndicator) {
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
                                    attribute: .centerY,
                                    relatedBy: .equal,
                                    toItem: toast.superview,
                                    attribute: .centerY,
                                    multiplier: 1,
                                    constant: 0),
            
            toast.widthAnchor.constraint(equalToConstant: 100),
            toast.heightAnchor.constraint(equalToConstant: 100)
        ].forEach{$0.isActive = true}
        
    }
    
    private func makeIndicatorToast() -> SunIndicator {
        let indicator: SunIndicator = {
            let indicator = SunIndicator()
            indicator.backgroundColor = .black.withAlphaComponent(0.5)
            indicator.style = .large
            indicator.color = .white
            indicator.alpha = 1.0
            indicator.layer.cornerRadius = 15
            indicator.isHidden = false
            return indicator
        }()
        return indicator
    }
}

private func makeToast(message: String) -> SunLabel {
    let label: SunLabel = {
        let label = SunLabel()
        
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0
        label.textAlignment = .center
        label.alpha = 1.0
        label.text = message
        label.layer.cornerRadius = label.font.pointSize / 2
        label.clipsToBounds = true
        return label
    }()
    label.padding(top: 5, left: 10, bottom: 5, right: 10)
    
    return label
    
}


//MARK: - SunLabel
public final class SunLabel: UILabel {
    private var padding: UIEdgeInsets = UIEdgeInsets()
    
    public func padding(top: CGFloat,left: CGFloat,bottom: CGFloat,right: CGFloat) {
        padding.top = top
        padding.left = left
        padding.bottom = bottom
        padding.right = right
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}

//MARK: - SunIndicator
public final class SunIndicator: UIActivityIndicatorView {
    
}
