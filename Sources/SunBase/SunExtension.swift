#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public final class SunExtension{
    
}

//MARK: - UIView (TOAST MESSAGE)
public extension UIView {
    enum simpleType{
        case top
        case down
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


//MARK: - Date
public extension Date {
    /// 연도 표시
    ///
    /// 변환에 실패시 현재 날짜의 년 표시
    var year: Int {
        let dateFormatter = self.setDateFormatter("yyyy")
        if let year = Int(dateFormatter.string(from: self)){
            return year
        } else {
            return Calendar.current.component(.year, from: self)
        }
    }
    
    /// 월 표시
    ///
    /// 변환 실패시 현재 날짜의 월 표시
    var month: Int {
        let dateFormatter = self.setDateFormatter("MM")
        if let month = Int(dateFormatter.string(from: self)) {
            return month
        } else {
            return Calendar.current.component(.month, from: self)
        }
    }
    
    /// 일 표시
    ///
    /// 변환 실패시 현재 날짜의 월 표시
    var day: Int {
        let dateFormatter = self.setDateFormatter("dd")
        if let day = Int(dateFormatter.string(from: self)) {
            return day
        } else {
            return Calendar.current.component(.day, from: self)
        }
    }
    
    /// 요일 표시
    ///
    /// 일요일 부터 시작해 0~6까지 반환
    ///
    /// -1 반환시 오류 발생
    var dayOfWeek: Int {
        let dateFormatter = self.setDateFormatter("EEEEEE")
        let convert = dateFormatter.string(from: self)
        switch convert {
        case "일":
            return 0
        case "월":
            return 1
        case "화":
            return 2
        case "수":
            return 3
        case "목":
            return 4
        case "금":
            return 5
        case "토":
            return 6
        default:
            return -1
        }
    }
    
    func setDateFormatter(_ dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter
    }
    
    
    /// String 값으로 변환
    func convertString(_ dateFormat: String = "yyyyMMdd") -> String {
        let dateFormatter = self.setDateFormatter(dateFormat)
        return dateFormatter.string(from: self)
    }
    
    
    /// 해당 년도가 윤년인지 확인
    ///
    /// 값이 정확하지 않으면 현재 날짜로 파악
    func checkLeapMonth() -> Bool {
        if self.year % 4 == 0 {
            if self.year % 100 == 0 {
                if self.year % 400 == 0 {
                    return true
                }
            } else {
                return true
            }
        }
        return false
    }
    
    /// 해당 월의 날짜 수 확인
    ///
    /// 값이 정확하지 않으면 현재 날짜로 파악
    func getLastDayOfMonth() -> Int {
        switch self.month {
        case 1,3,5,7,8,10,12 :
            return 31
        case 2:
            if self.checkLeapMonth() {
                return 29
            } else {
                return 28
            }
        case 4,6,9,11:
            return 30
        default:
            return -1
        }
    }
    
    
}

//MARK: - String
public extension String {
    /// 원하는 길이 만큼 절단
    func cut(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex,offsetBy: start >= 0 ? start : 0)
        let endIndex = self.index(self.startIndex,offsetBy: end >= 0 ? end : 0)
        let result: String = "\(self[startIndex ..< endIndex])"
        return result
    }
    
    /// 글자 하나 단위로 구분
    func letter() -> [String] {
        return self.map { String($0) }
    }
    
    /// 단어 하나 단위로 구문
    func word() -> [String] {
        return self.components(separatedBy: " ")
    }
    
    /// Date() 로 변환 -> (Bool, Date) 출력
    func convertDate(_ dateFormat: String = "yyyyMMdd") -> (Bool, Date) {
        let dateFormatter = Date().setDateFormatter(dateFormat)
        if let convert = dateFormatter.date(from: self) {
            return (true, convert)
        } else {
            return (false, Date())
        }
    }
    
    /// 정규식 체크
    ///
    /// 이메일 정규식 예시: "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._%+-]+\\.[A-Za-z]{2,64}"
    /// 비밀번호 정규식 에시: "[A-Z0-9a-z._%+-]{6,12}"
    func checkFilter(_ filter: String) -> Bool {
        var result = false
        if self == "" { return result }
        if (self.range(of: filter, options: .regularExpression) != nil) {
            result = true
        } else {
            result = false
        }
        
        return result
    }
    
    /// Bool 값에 맞게  DateFormat을 반환
    static func makeDateFormat(year: Bool, month: Bool, day: Bool, dayOfWeek: Bool = false, am_pm: Bool = false, hour: Bool = false,_ fullTime: Bool = true, minute: Bool = false, second: Bool = false, mSecond: Bool = false, mSDigit: Int = 1) -> String {
        
        var dateFomat = ""
        
        if year {
            dateFomat = dateFomat + "yyyy"
        }
        if month {
            dateFomat = dateFomat + "MM"
        }
        if day {
            dateFomat = dateFomat + "dd"
        }
        if dayOfWeek {
            dateFomat = dateFomat + "EEEEEE"
        }
        
        if am_pm {
            dateFomat = dateFomat + "a"
        }
        
        if fullTime { // 24시간
            if hour {
                dateFomat = dateFomat + "HH"
            }
        } else { // 12시간
            if hour {
                dateFomat = dateFomat + "hh"
            }
        }
        
        if minute {
            dateFomat = dateFomat + "mm"
        }
        
        if second {
            dateFomat = dateFomat + "ss"
        }
        
        if mSecond {
            for _ in 0 ..< mSDigit {
                dateFomat = dateFomat + "S"
            }
        }
        
        return dateFomat
    }
    
    /// 날짜를 합쳐서 하나의 String으로 반환
    static func combineDate(year: Int, month: Int, day: Int) -> String {
        return "\(year * 10000 + month * 100 + day)"
    }
}

//MARK: - Collection
// 아직 무엇을 추가 해야 할지 제대로 정해지지 않은 상태
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

//MARK: - SunIndicator
public final class SunIndicator: UIActivityIndicatorView {
    
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

//MARK: - SunButton
public final class SunButton: UIButton {
    private enum BtnSize {
        typealias Element = (
            duration: TimeInterval,
            delay: TimeInterval,
            options: UIView.AnimationOptions,
            scale: CGAffineTransform,
            alpha: CGFloat
        )
        
        case sizeUPTouchDown
        case sizeDownTouchDown
        case touchUp
        
        var element: Element {
            switch self {
            case .sizeUPTouchDown:
                return Element(duration: 0,
                               delay: 0,
                               options: .curveLinear,
                               scale: .init(scaleX: 1.3, y: 1.3),
                               alpha: 0.8)
                
            case .sizeDownTouchDown:
                return Element(duration: 0,
                               delay: 0,
                               options: .curveLinear,
                               scale: .init(scaleX: 0.7, y: 0.7),
                               alpha: 0.8)
            case .touchUp:
                return Element(duration: 0,
                               delay: 0,
                               options: .curveLinear,
                               scale: .identity,
                               alpha: 1)
            }
        }
    }

    @IBInspectable var animateBig: Bool = false
    @IBInspectable var animateSmall: Bool = false
    
    public override var isHighlighted: Bool {
        didSet {
            if animateBig {
                let animation: BtnSize = BtnSize.sizeUPTouchDown
                self.doAnimating(animation: animation)
            } else if animateSmall {
                let animation: BtnSize = BtnSize.sizeDownTouchDown
                self.doAnimating(animation: animation)
            }
        }
    }
    
    private func doAnimating(animation: BtnSize) {
        let animationElement = self.isHighlighted ? animation.element : BtnSize.touchUp.element
        UIView.animate(withDuration: animationElement.duration,
                       delay: animationElement.delay,
                       options: animationElement.options) {
            self.transform = animationElement.scale
            self.alpha = animationElement.alpha
        }
    }
}

//MARK: - SunView
public class SunView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadNib()
    }
    
    private func loadNib () {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        guard let nibView = nibs?.first as? UIView else { return }
        self.addSubview(nibView)
        self.viewLoad()
    }
    
    func viewLoad(){
        
    }
}

/*
//MARK: - SunViewController
// 이부분도 추가를 해보려 했으나 생각보다 VC 베이스는 그냥 프로젝트 할 때마다 만드는게 훨씬 좋다는 판단이 들게 되었음
public final class SunViewController: UIViewController {

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
*/
