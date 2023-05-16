#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public typealias SB = SunBase
//    public private(set) var text = "Hello, World!"

public final class SunBase {
    public static let radio = SunRadioButton()
    public static let check = SunCheckBox()
    public static let drop = SunDropDown()
    public static let alert = SunAlert()
    public static let timer = SunTimer.shared
}

//MARK: - Radio Button
/// 기본으로 하나 켜지게 할 수 있는 방법이 있으면 좋을 것 같음: CheckBox 또한 마찬가지
public final class SunRadioButton {
    private var buttonArray: [UIButton] = []
    private var radioArray: [Bool] = []
    private var emptyImage: UIImage? = nil
    private var fillImage: UIImage? = nil
    
    public func makeRadio(_ array: [UIButton], isText: Bool = false, isRight: Bool = false, emptyImage: UIImage? = UIImage(systemName: "circle"), fillImage: UIImage? = UIImage(systemName: "circle.fill"), defaultTarger: Int? = nil) {
        
        self.buttonArray = array
        self.emptyImage = emptyImage
        self.fillImage = fillImage
        
        for i in 0 ..< array.count {
            radioArray.append(false)
            array[i].tag = i+199459
        }
        
        array.forEach{
            if isRight {
                $0.semanticContentAttribute = .forceRightToLeft
            } else {
                $0.semanticContentAttribute = .forceLeftToRight
            }
            if !isText {
                $0.setTitle("", for: .normal)
            }
            $0.setImage(self.emptyImage, for: .normal)
            $0.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
        }
        
        if let target = defaultTarger {
            array[target].setImage(self.fillImage, for: .normal)
            self.radioArray[target] = true
        }
    }
    
    @objc private func radioButtonTapped(_ sender: UIButton) {
        let tag = sender.tag - 199459
        if let tagIndex = self.radioArray.firstIndex(of: true) {
            self.buttonArray[tagIndex].setImage(self.emptyImage, for: .normal)
            self.radioArray[tagIndex] = false
        }
        
        self.radioArray[tag] = true
        self.buttonArray[tag].setImage(self.fillImage, for: .normal)
    }
    
    public func checkRadioArray(completion: (_ radio: [Bool]) -> ()){
        completion(radioArray)
    }
    
}

//MARK: - Check Box
public final class SunCheckBox {
    private var buttonArray: [UIButton] = []
    private var checkArray: [Bool] = []
    private var emptyImage: UIImage? = nil
    private var fillImage: UIImage? = nil
    
    public func makeCheck(_ array: [UIButton], isText: Bool = false, isRight: Bool = false, emptyImage: UIImage? = UIImage(systemName: "square"), fillImage: UIImage? = UIImage(systemName: "square.fill"), defaultTarger: [Int] = []) {
        
        self.buttonArray = array
        self.emptyImage = emptyImage
        self.fillImage = fillImage
        
        for i in 0 ..< array.count {
            checkArray.append(false)
            array[i].tag = i+199459
        }
        
        array.forEach{
            if isRight {
                $0.semanticContentAttribute = .forceRightToLeft
            } else {
                $0.semanticContentAttribute = .forceLeftToRight
            }
            if !isText {
                $0.setTitle("", for: .normal)
            }
            $0.setImage(self.emptyImage, for: .normal)
            $0.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        }
        
        for i in 0 ..< defaultTarger.count {
            array[defaultTarger[i]].setImage(self.fillImage, for: .normal)
            self.checkArray[defaultTarger[i]] = true
        }
    }
    
    @objc private func checkButtonTapped(_ sender: UIButton) {
        let tag = sender.tag - 199459
        self.checkArray[tag].toggle()
        if checkArray[tag] {
            self.buttonArray[tag].setImage(self.fillImage, for: .normal)
        } else {
            self.buttonArray[tag].setImage(self.emptyImage, for: .normal)
        }
    }
    
    public func checkCheckArray(completion: (_ check: [Bool]) -> ()){
        completion(checkArray)
    }
    
    public func allCheckBox() {
        if self.checkArray.filter({$0 == true}).count == self.checkArray.count {
            self.checkArray = self.checkArray.map{ _ in false}
            self.buttonArray.map {
                $0.setImage(self.emptyImage, for: .normal)
            }
        } else {
            self.checkArray = self.checkArray.map{ _ in true}
            self.buttonArray.map {
                $0.setImage(self.fillImage, for: .normal)
            }
        }
    }
}


//MARK: - DropDown Menu
public final class SunDropDown {
    public func makeDropDown(_ target: UIButton, _ VC: UIViewController) {
        var superX: CGFloat = 0
        var superY: CGFloat = 0
        var currentView: UIView? = target
        
        while currentView != VC.view {
            if let currentView = currentView {
                superX += currentView.frame.origin.x
                superY += currentView.frame.origin.y
            }
            currentView = currentView?.superview
        }
        
        print(superX)
        print(superY)
        print(VC.view.frame.height)
//        if VC.view == check {
//            print("Super!")
//        } else {
//            print(check)
//        }
//        target.superview
    }
}

//MARK: - Alert
public final class SunAlert {
    public func show2Type(_ VC: UIViewController, title: String, message: String, okTitle: String = "확인", okStyle: UIAlertAction.Style = .default, ok: ((UIAlertAction)->())?, cancelTitle: String = "취소", cancelStyle: UIAlertAction.Style = .cancel, cancel: ((UIAlertAction)->())? ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: okTitle, style: okStyle, handler: ok)
        let cancelAction = UIAlertAction(title: cancelTitle, style: cancelStyle, handler: cancel)
        
        [okAction, cancelAction].forEach{alertController.addAction($0)}
        
        VC.present(alertController, animated: true, completion: nil)
    }
    
    public func show3Type(_ VC: UIViewController, title: String, message: String, okTitle: String = "확인", okStyle: UIAlertAction.Style = .default, ok: ((UIAlertAction)->())?, cancelTitle: String = "취소", cancelStyle: UIAlertAction.Style = .cancel, cancel: ((UIAlertAction)->())?, destructiveTitle: String = "삭제", destructiveStyle: UIAlertAction.Style = .destructive, destructive: ((UIAlertAction)->())? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: okStyle, handler: ok)
        let cancelAction = UIAlertAction(title: cancelTitle, style: cancelStyle, handler: cancel)
        let destructiveAction = UIAlertAction(title: destructiveTitle, style: destructiveStyle, handler: destructive)
        
        
        [okAction, cancelAction, destructiveAction].forEach{alertController.addAction($0)}
        
        VC.present(alertController, animated: true, completion: nil)
    }
    
    
}

//MARK: - Timer
public final class SunTimer {
    public static let shared = SunTimer()
    private var timer = Timer()
    
    private init() {
        
    }
    
    public func startTimer(_ interval: Double, repeats: Bool = false, completion: @escaping (_ isStop: Bool) -> ()) {
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
            SB.timer.startTimer(time) { isStop in
                if isStop {
                    self.stopIndicator { isDone in
                        completion?(isDone)
                    }
                }
            }
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
