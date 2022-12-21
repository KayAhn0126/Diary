# Diary

## 🍎 UI 구성할 때 생긴 UITabBarController 관련 궁금증.
- [TabBarItem과 BarItem은 무엇이 다를까?](https://github.com/KayAhn0126/iOS-Study/tree/main/UI/UITabBarController/DifferencesBetweenTabBarItemAndBarItem)

## 🍎 touchesBegan 메서드는 무엇일까?
```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}
```

## 🍎 addTarget 메서드 활용법
- [UIControl 클래스 내 addTarget 메서드 이해하기](https://github.com/KayAhn0126/iOS-Study/tree/main/UI/UIControl/addTargetMethod)

## 🍎 sendActions 메서드를 이용해 이벤트를 전달하기
- [sendActions 메서드 이해하기](https://github.com/KayAhn0126/iOS-Study/tree/main/UI/UIControl/sendActionsMethod)

## 🍎 등록 버튼 활성화 로직
```swift
private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
```
- 닐 코얼레싱을 사용해 옵셔널값을 해제 할 때, 아래와 같이 사용했었다.
```swift
let x = something ?? 10 // 여기서 something은 Optional Int 타입
```
- 몰랐던건 아직 옵셔널이 해제되지 않은 상태에서 내장함수를 사용하면 내장함수의 반환값에 옵셔널이 붙는다.
- self.dateTextField.text?.isEmpty의 반환값은 Bool? 타입이다.

## 🍎 segue + show(Navigation)을 통해 화면을 전환시
- segue + show를 통해 화면을 전환시, 전환되는 화면에 어떤 값을 보내줘야 할때는 아래와 같이 prepare(for,sender) 메서드를 override 해서 사용.
```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let wrietDiaryViewController = segue.destination as? WriteDiaryViewController {
        wrietDiaryViewController.delegate = self
    }
}
```

## 🍎 Modern CollectionView
- [Modern CollectionView](https://github.com/KayAhn0126/iOS-Study/tree/main/GrammarAndKnowledge/ModernCollectionView)

## 🍎 userDefaults 사용 및 didSet
- 먼저 userDefaults를 사용한 코드를 보자
```swift
// MARK: - userDefaults에서 DiaryList를 가져오는 메서드
private func loadDiaryList() {
    let userDefaults = UserDefaults.standard
    if let data = userDefaults.value(forKey: "diary") as? Data {
        let realData = try? PropertyListDecoder().decode([Diary].self, from: data)
        self.diaryList = realData!
        self.diaryList = self.diaryList.sorted(by: { // 코드
            $0.date > $1.date
            // $0.date.compare($1.date) == .orderedDescending   이렇게도 작성할 수 있다.
        })
    }
}
```
- loadDiaryList 메서드는 userDefaults에서 key를 통해 값을 가져와 정렬 후 diaryList에 저장하는 메서드이다.
- 프로퍼티 옵져버 didSet을 통해 값이 바뀌는것을 관찰하다 바뀌면 저장해주는 saveDiaryList() 메서드를 호출하자
```swift
private var diaryList = [Diary]() {
    didSet {
        saveDiaryList()
    }
}
```

## 🍎 Notification Center를 사용해 변경사항 전달하기
- notification은 앱 내 상관 관계가 없는 부분과 부분을 이어주기 위한 방법이다.

## 🍎 같은 ViewController에 다른 목적으로 접근을 어떻게 관리 할까?
- [열거형을 사용해 같은 View Controller를 여러가지 목적으로 접근할 수 있다.](https://github.com/KayAhn0126/iOS-Study/tree/main/GrammarAndKnowledge/Enumeration/AccessVCWithSeveralPurpose)

## 🍎 TextField의 shouldChangeCharactersIn 메서드는 무엇일까?
- 현재는 텍스트필드에 키보드로 입력을 하지 못하게 막아 놓았다.
- 추후 업데이트 예정


## 🍎 다크모드 감지하기(정리 필수)
```swift
override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            print(previousTraitCollection?.userInterfaceStyle)
            print(UITraitCollection.current.userInterfaceStyle.rawValue)
            // enum이라 케이스로 나온다. 케이스별 분기처리
        }
    }
```

## 🍎 required init 생성자 알아보기

## 🍎 delegate에서 notification으로 변경한 이유
### 📖 delegate의 문제점
- 구조: DiaryVC(목록)과 StarVC(즐겨찾기)에서 셀을 클릭하면 DetailDiaryVC가 띄워진다.
- 기존 목록 화면에서 일기를 클릭하면 DetailDiaryViewController를 띄우게 된다. 여기에는 '삭제'버튼과 '즐겨찾기' 토글 버튼이 있는데 이 버튼을 누르면 각각의 설정 해둔 delegate의 실행 메서드가 실행된다.
- 현재의 로직을 표로 보자면 아래와 같다. (그림이 이상한것이 아니라 삭제와 즐겨찾기 버튼이 눌렸을때 실제로 작동하는 메서드가 DiaryVC에 구현 되어있기 때문이다.
![](https://i.imgur.com/VcyKxLT.png)
- DiaryVC에서 아래와 같은 코드를 볼 수 있다.
```swift
extension DiaryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ...
        DiaryDetailViewController.deleteDelegate = self
        DiaryDetailViewController.starDelegate = self
        ... self.navigationController?.pushViewController(DiaryDetailViewController, animated: true)
    }
}
```
- 즉, DiaryDetailViewController의 deleteDelegate와 starDelegate의 의무를 DiaryViewController가 하겠다는 의미이다.
- 즉, 삭제에서 일어난 일, 즐겨찾기를 누르면 일어나는 일들은 무조건 DiaryVC가 처리하고 있다는것. (**delegate 패턴은 1:1로만 가능하다.**)
![](https://i.imgur.com/TuGvPve.png)
- 위와 같은 그림은 delegate pattern을 사용해서는 불가능하다는 이야기 이다.
- DiaryVC와 StarVC에서 특정 구분자를 구독하고 삭제와 즐겨찾기 버튼이 클릭될 때마다 포스트를 하면 하나의 행동이 2명의 구독자에게 영향을 끼칠수 있다는 점을 활용했다.

### 📖 Notification으로 대체 후 플로우 차트
![](https://i.imgur.com/8rLcDys.png)
- delegate 패턴을 사용했을 때 보다 확실히 1:N을 관리하는 측면에서는 좋아졌다.
- NotificationCenter는 연관이 없는 곳으로 특정 이벤트나 행동을 전달 할 떄 가장 효율적이다. 지정 구분자가 post 될 때 원하는 곳에서 편하게 받을수 있다는 장점도 있지만 분명히 단점도 존재했다.
- 이벤트에 따라 세세하게 다른 행동을 해야한다면 지정 구분자를 다르게 해서 보내야한다는 것과, 지정 구분자의 갯수가 많아지면 무엇이 어떤 행동을 하는지 분간하기 힘들 수도 있다는 생각이 들었다.

## 🍎 프로젝트를 끝내고 느낀점. 
- 1. 아직 정확하게 무엇 때문인지는 모르겠지만, combine의 파이프라인 구현이 필요하다고 느꼈다.
- 2. DiffableDataSource를 사용 할 때, flowlayout에서 사용하는 deleteItmes와 같은 메서드를 사용하지 말자. -> snapshot과 동시에 이루어져 크래쉬 발생!


