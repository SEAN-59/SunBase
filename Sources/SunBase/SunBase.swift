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
//    public static let drop = SunDropDown()
    public static let alert = SunAlert()
    public static let timer = SunTimer.shared
    public static let device = SunCheckDevice()
    
    public static let button = SunButton()
}

//

public final class SunCheckDevice {
    // SEAN - 앱 무결성 탈옥 검사
    /// 앱 탈옥 기기 여부 확인 (true 반환시 문제가 있는것)
    public func checkDevice() -> Bool {
        var result = false
        
        // 시뮬레이터 구동 시 true 반환
        func isSimulator() -> Bool {
            return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
        }
        
        func canOpen(path: String) -> Bool {
            let file = fopen(path, "r")
            guard file != nil else { return false }
            fclose(file)
            return true
        }
        
        
        if !(isSimulator()) {
            let nsFileManager = FileManager.default
            guard let cydiaURL = NSURL(string: "cydia://package/com.example.package") else { return result}
            
            if nsFileManager.fileExists(atPath: "/Applications/Cydia.app") || nsFileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") || nsFileManager.fileExists(atPath: "/bin/bash") || nsFileManager.fileExists(atPath: "/usr/sbin/sshd") || nsFileManager.fileExists(atPath: "/etc/apt") || nsFileManager.fileExists(atPath: "/private/var/lib/apt/") || UIApplication.shared.canOpenURL(cydiaURL as URL)  {
                result = true
            }
            
            if canOpen(path: "/bin/bash") || canOpen(path: "/Applications/Cydia.app") || canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") || canOpen(path: "/usr/sbin/sshd") || canOpen(path:  "/etc/apt") {
                result = true
            }
            
            let jailbreakPath = "/private/jailbreak.txt"
            
            do {
                try "Jailbreak_Test".write(toFile: jailbreakPath, atomically: true, encoding: String.Encoding.utf8)
                result = true
            } catch {
                do {
                    try nsFileManager.removeItem(atPath: jailbreakPath)
                } catch {
                    print("[ERROR] remove Jailbreak_test: \(error)")
                }
            }
            
        }
        
        return result
    }
}


//MARK: - Radio Button
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
            _ = self.buttonArray.map {
                $0.setImage(self.emptyImage, for: .normal)
            }
        } else {
            self.checkArray = self.checkArray.map{ _ in true}
            _ = self.buttonArray.map {
                $0.setImage(self.fillImage, for: .normal)
            }
        }
    }
}

//MARK: - DropDown Menu
/*
public final class SunDropDown {
    
    private var tableView: UITableView = UITableView()
    
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
    }
}
 */

//MARK: - Alert
public final class SunAlert {
    public func alertOneBtn(_ VC: UIViewController, title: String, message: String, firstTitle: String, firstStyle: UIAlertAction.Style = .default, firstHandler: ((UIAlertAction)->())?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let firstAction = UIAlertAction(title: firstTitle, style: firstStyle, handler: firstHandler)
        
        [firstAction].forEach{alertController.addAction($0)}
        
        VC.present(alertController, animated: true, completion: nil)
    }
    
    public func alertTwoBtn(_ VC: UIViewController, title: String, message: String, firstTitle: String, firstStyle: UIAlertAction.Style = .default, firstHandler: ((UIAlertAction)->())?, secondTitle: String, secondStyle: UIAlertAction.Style = .default, secondHandler: ((UIAlertAction)->())?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstTitle, style: firstStyle, handler: firstHandler)
        let secondAction = UIAlertAction(title: secondTitle, style: secondStyle, handler: secondHandler)
        
        [firstAction, secondAction].forEach{alertController.addAction($0)}
        
        VC.present(alertController, animated: true, completion: nil)
    }
    
    public func alertThreeBtn(_ VC: UIViewController, title: String, message: String, firstTitle: String, firstStyle: UIAlertAction.Style = .default, firstHandler: ((UIAlertAction)->())?, secondTitle: String, secondStyle: UIAlertAction.Style = .default, secondHandler: ((UIAlertAction)->())?, thirdTitle: String, thirdStyle: UIAlertAction.Style = .default, thirdHandler: ((UIAlertAction)->())?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstTitle, style: firstStyle, handler: firstHandler)
        let secondAction = UIAlertAction(title: secondTitle, style: secondStyle, handler: secondHandler)
        let thirdAction = UIAlertAction(title: thirdTitle, style: thirdStyle, handler: thirdHandler)
        
        [firstAction, secondAction, thirdAction].forEach{alertController.addAction($0)}
        
        VC.present(alertController, animated: true, completion: nil)
    }
    
    
    public func show1Type(_ VC: UIViewController, title: String, message: String, okTitle: String = "확인", okStyle: UIAlertAction.Style = .default, ok: ((UIAlertAction)->())?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: okTitle, style: okStyle, handler: ok)
        
        [okAction].forEach{alertController.addAction($0)}
        
        VC.present(alertController, animated: true, completion: nil)
    }
    
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
        // 중간에 타이머를 정지시키기 위해서 사용x
        if self.timer.isValid {
            self.timer.invalidate()
            completion(true)
        } else {
            completion(false)
        }
    }
    
}


