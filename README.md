# SunBase
```swift
    typealias SB = SunBase
```
## 목록
1. Toast Message
2. Radio Button
3. Check Box
4. Drop Down
5. Custon Alert
6. Timer

## 기능 설명
[x] Toast Message <br>
- 기능
    1. 토스트 메세지
    2. 토스트 인디케이터
    
### 1. Simple Toast Message
```swift
    showToast(message: String,
              type: simpleType = .down,
              constatns: CGFloat = 100,
              duration: CGFloat = 2.0,
              delay:CGFloat = 0.4,
              isRepeat: Bool = false)
```
- message만 입력해도 기본적으로 하단에 토스트 메세지 띄우는것이 가능하나, 조금 더 디테일한 조정을 위해서는 다른 파라미터들을 입력하면 된다. 
    1. message: 토스트 메세지 내용
    2. type: .top 과 .bottom 2가지로 구성 = Optional
    3. constants: 토스트 메세지가 나타날 위치 = Optional
        (type이 bottom인 경우 화면 하단에서 얼마나 떨어진 위치에서 메세지가 나타나게 될지 결정) = Optional
    4. duration: 토스트 메세지가 화면에서 사라지는 시간 = Optional
    5. delay: 토스트 메세지가 화면에 남아있는 시간 = Optional
    6. isRepeat: 화면에 토스트 메세지가 1개 이상 쌓일 수 있는지 체크 = Optional


### 2. Toast Indicator
```swift
    showIndicator(_ time: Double = 5, isTimer: Bool = false)
    stopIndicator(completion: ((Bool)->())? = nil)
```
- 단순히 함수 이름을 적는것 만으로도 동작이 실행되는 Indicator가 만들어짐
    showIndicator()의 경우 동작이 실행되면 화면상의 터치 동작이 멈춘다.
- 타이머와 연결하여 쓰거나 다른 용도로 사용하게 될 경우를 의해서 isTimer의 파라미터가 false로 되어있으나 showIndicator 동작과 함께 특정 시간 후 바로 stop을 시키기 위해서는 해당 파라미터를 true로 전환하면 된다.
- 기본적으로 5초의 시간 제한이 걸려있어서 5초가 지나면 자동으로 stopIndicator가 동작되게 된다.

- stopIndicator를 외부에서 사용할 경우 특별하게 멈췄을때 다른 동작을 할 수 있게 completion을 지원한다.

[x] Radio button <br>
- 기능
    1. 라디오 버튼 동작
    
### 사용방법
    1. UIButton 오브젝트를 스토리보드, code 등 여러 방법을 통해서 만들어서 배치한다.
    2. 1에서 만든 오브젝트들을 하나의 Array로 묶어준다. (해당 순서는 생략 가능)
    
```swift
    let buttonArray: [UIButton] = [firstBtn, secondBtn, thirdBtn]
```

    3. SB.radio의 makeRadio 함수의 파라미터들을 통해 1의 오브젝트들을 라디오 버튼의 동작을 하는 버튼으로 전환한다.
    4. RadioButton의 값을 확인하기 위해서는 checkRadioArray 함수를 통해 확인할 수 있다.  
    
```swift
    makeRadio(_ array: [UIButton],
                isText: Bool = false,
                isRight: Bool = false,
                emptyImage: UIImage? = UIImage(systemName: "circle"),
                fillImage: UIImage? = UIImage(systemName: "circle.fill"),
                defaultTarger: Int? = nil) 
```

- 단순하고 array 파라미터에 들어갈 UIButton array만 넣어준다면 다른 값들은 기본값으로 넣어준대로 동작하며 다른 동작을 위해서는 내부의 파라미터를 변경해주면 된다.
    1. array: Radio button 동작을 할 UIButton array
    2. isText: 변환이 이루어진 버튼은 이미지만 존재하고 텍스트는 지워지게 되므로 텍스트를 살리기 위해서 사용 = Optional
    3. isRight: text가 존재하는 경우 이미지와 text간의 배치 변경 가능 = Optional
    4. emptyImage & fillImage: 표시하고자 하는 버튼의 이미지 변경 가능 = Optional
    5. defaultTarger: 처음 버튼을 만들때 바로 체크를 걸어 둘 수 있으며 array에 넣은 오브젝트의 배열 넘버를 넣으면 됨 (0부터 시작) = Optional

```swift
    checkRadioArray(completion: (_ radio: [Bool]) -> ())
```

- 외부에서 해당 함수 호출시 completion을 통해 현재 radio button으로 선택된 값이 Bool 값으로 나타난다.

- 단, 라디오 버튼으로 사용하는 버튼에 확인하는 이 함수를 같이 동작을 시키게 될 경우 해당 함수는 버튼이 동작하기 전의 값이 출력이 되므로 라디오 버튼으로 사용하는 버튼들에게는 따로 동작을 부여하지 않는것이 좋다.

[x] Check Box <br>
- 라디오 버튼과 90% 가까이 동일한 방법
- 단, 체크박스의 경우에는 다중 선택이 가능하다는 차이만 존재
- 그래서 전체 선택과 해제가 가능한 함수가 있음
- defaultTarger: [Int] = [] 파라미터가 이렇게 배열 방식으로 array에 넣은 오브젝트의 배열 넘버를 적어주면 된다. (0부터 시작) = Optional

```swift
    allCheckBox()
```


[ ] Drop down <br>

[x] Custom Alert <br>
- 기능
    1. 2타입 얼럿
    2. 3타입 얼럿
    
### 1. Two Type Alert
```swift
    show2Type(_ VC: UIViewController,
                title: String,
                message: String, 
                okTitle: String = "확인", 
                okStyle: UIAlertAction.Style = .default, 
                ok: ((UIAlertAction)->())?, 
                cancelTitle: String = "취소",
                cancelStyle: UIAlertAction.Style = .cancel, 
                cancel: ((UIAlertAction)->())? )
```
- ok 기능과 cancel 기능을 위해서 만들었으며 내부의 파라미터 조정이 가능하다.
    1. VC: Alert이 나타날 viewController 설정
    2. title: Alert의 제목
    3. message: Alert의 내용
    4. okTitle: ok의 제목 = Optional
    5. okStyle: ok의 버튼 타입 = Optional
    6. ok: ok 버튼 클릭시 동작할 클로저 = Optional
    7. cancelTitle: cancel의 제목 = Optional
    8. cancelStyle: cancel의 버튼 타입 = Optional
    9. cancel: cancel 버튼 클릭시 동작할 클로저 = Optional


### 2. Three Type Alert
```swift
    show3Type(_ VC: UIViewController,
                title: String,
                message: String,
                okTitle: String = "확인",
                okStyle: UIAlertAction.Style = .default, 
                ok: ((UIAlertAction)->())?, 
                cancelTitle: String = "취소", 
                cancelStyle: UIAlertAction.Style = .cancel, 
                cancel: ((UIAlertAction)->())?, 
                destructiveTitle: String = "삭제", 
                destructiveStyle: UIAlertAction.Style = .destructive, 
                destructive: ((UIAlertAction)->())? )
```
- ok 기능과 cancel, destructive 기능을 위해서 만들었으며 내부의 파라미터 조정이 가능하다.
    1. VC: Alert이 나타날 viewController 설정
    2. title: Alert의 제목
    3. message: Alert의 내용
    4. okTitle: ok의 제목 = Optional
    5. okStyle: ok의 버튼 타입 = Optional
    6. ok: ok 버튼 클릭시 동작할 클로저 = Optional
    7. cancelTitle: cancel의 제목 = Optional
    8. cancelStyle: cancel의 버튼 타입 = Optional
    9. cancel: cancel 버튼 클릭시 동작할 클로저 = Optional
    10. destructiveTitle: destructive의 제목 = Optional
    11. destructiveStyle: destructive의 버튼 타입 = Optional
    12. destructive: destructive 버튼 클릭시 동작할 클로저 = Optional
    
[x] Timer <br>
- 기능
    1. 타이머 실행
    2. 타이머 종료
    
- 싱글턴으로 만들어져 있다는 점은 일단은 알아두는게 좋을것 같다.

- 사용방법은 아래의 2가지 방식이 존재한다.
```swift
    let sunTimer = SunTimer.shared
    
    suntTimer.startTimer(3)
```

or

```swift
    SB.timer.startTimer(3) { isStop in
        print(isStop)
    }
    
    // true
```
- 모두 다 같은 동작을 수행하므로 원하는 방식을 사용하면 된다.

```swift
    startTimer(_ interval: Double,
                 repeats: Bool, 
                 completion: @escaping (_ isStop: Bool) -> ())
    
    stopTimer(completion: (Bool) -> ())
```

- startTimer의 경우에는 타이머 시간과 반복을 입력해주면 클로저로 들어오는 Bool값으로 제대로 동작했는지 확인할 수 있다.

- stopTimer의 경우에는 타이머가 동작 중인 경우에 해당 타이머를 중간에 끊어주기 위해 사용하는 함수이다.
```swift
    sunTimer.stopTimer { isStop in
        print(isStop)
    }
    
    // true
```
