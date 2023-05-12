#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif


public final class SunBase {
    //    public private(set) var text = "Hello, World!"
}

//MARK: - Timer
public final class SunTimer {
    public static let shared = SunTimer()
    private var timer = Timer()
    
    private init() {
        
    }
    
    public func startTimer(interval: Double, repeats: Bool = false, completion: @escaping (_ isStop: Bool) -> ()) {
        let nowDate = Date()
        
        // 타이머 시작전 다른 타이머가 동작 중이면 중지
        if self.timer.isValid {
            self.timer.invalidate()
        }
        
        self.timer = .scheduledTimer(withTimeInterval: interval,
                                     repeats: repeats,
                                     block: { [weak self] timer in
            guard let weakSelf = self else {return}
            let firstTime = Date().timeIntervalSince(nowDate)
            let secondTime = Int(interval - firstTime)
            
            if secondTime == 0 {
                // 정지는 되었겠지만 그래도 혹시 몰라서
                weakSelf.timer.invalidate()
                print("TIMER_END")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    public func stopTimer(completion: (Bool) -> ()) {
        // 중간에 타이머를 정지시키기 위해서 사용
        if self.timer.isValid {
            self.timer.invalidate()
            completion(true)
        } else {
            completion(false)
        }
    }
    
}

//MARK: - TOAST MESSAGE
public extension UIView {
    enum simpleType{
        case top
        case down
    }
    
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
    
    func showIndicator() {
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
    }
    
    func stopIndicator() {
        self.isUserInteractionEnabled = true
        self.subviews.forEach {
            if $0 is SunIndicator {
                $0.removeFromSuperview()
            }
        }
        
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
    
    private func addToast<T>(_ toast: T) {
        guard let toast = toast as? UIView else { return }
        self.addSubview(toast)
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
