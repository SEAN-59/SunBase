# SunBase

A description of this package.

## 구현 목록
[x] Toast Messagae <br>
- 가장 기본이 되는 토스트 메세지 구현 완료
```swift
    showToast(message: String, type: simpleType, constatns: CGFloat, duration: CGFloat, delay:CGFloat ,isRepeat: Bool)
```
- message만 입력해도 바로 토스트 메세지는 호출되나 조금더 세부 사항을 설정하기 위해서는 다른 입력 파라미터들도 조정을 해준다.

```swift
    showIndicator()
    stopIndicator()
```

- 따로 설정할 것 없이 showIndicator 와 stopIndicator로만 동작을 제어한다.

[ ] Radio button <br>

[ ] Check Box <br>

[ ] Drop down <br>

[ ] Custom Alert <br>

[x] Timer <br>
- 타이머 실행과 타이머 중간에 멈추게 하는 동작이 되는 기능 구현
- 싱글턴으로 만들어져 있어서 다음과 같은 방법으로 접근하는걸 추천

```swift
    let sunTimer = SunTimer.shared
```

```swift
    startTimer(interval: Double, repeats: Bool, completion: @escaping (_ isStop: Bool) -> ())
    
    stopTimer(completion: (Bool) -> ())
```
- 2가지의 함수로만 동작을 제어함

- startTimer의 경우에는 타이머 시간과 반복을 입력해주면 클로저로 들어오는 값을 가지고 원하는 작업을 진행하면 됨
- 이때 들어오는 값은 Bool로 타이머가 제시간에 맞게 종료 되면 true를 받을 수 있음
```swift
    sunTimer.startTimer(interval: 3) { isStop in
            print(isStop)
    }
    
    // true
```

- stopTimer의 경우에는 타이머가 동작 중인 경우에 해당 타이머를 중간에 끊어주기 위해 사용하는 함수
```swift
    sunTimer.stopTimer { isStop in
        print(isStop)
    }
    
    // true
```
