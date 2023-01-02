# Diary

## 🍎 작동 화면
| 일기 추가 | 일기 수정 | 일기 삭제 |
| :-: | :-: | :-: |
| ![](https://i.imgur.com/ZbU7T44.gif) | ![](https://i.imgur.com/YKx8MAx.gif) | ![](https://i.imgur.com/iOQAsjC.gif)|
| 스타 클릭 | 정보 유지 | 스타 유지 | 
| ![](https://i.imgur.com/aVzNww4.gif) | ![](https://i.imgur.com/kKn0sCO.gif) | ![](https://i.imgur.com/6EOEo5A.gif) |


## 🍎 UI 구성할 때 생긴 UITabBarController 관련 궁금증.
- [TabBarItem과 BarItem은 무엇이 다를까?](https://github.com/KayAhn0126/iOS-Study/tree/main/UI/UITabBarController/DifferencesBetweenTabBarItemAndBarItem)

## 🍎 touchesBegan 메서드는 무엇일까?
```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}
```
- [UIResponder 개념 정리](https://github.com/KayAhn0126/iOS-Study/tree/main/UI/UIResponder/Basic_UIResponder)에서 'responder 객체가 전달받는 이벤트' 카테고리에 정리

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
- 프로젝트에서 사용한 [Modern CollectionView](https://github.com/KayAhn0126/iOS-Study/tree/main/GrammarAndKnowledge/ModernCollectionView) 정리

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
- [notification](https://github.com/KayAhn0126/iOS-Study/tree/main/GrammarAndKnowledge/NotificationCenter)은 앱 내 상관 관계가 없는 부분과 부분을 이어주기 위한 방법이다.

## 🍎 같은 ViewController에 다른 목적으로 접근을 어떻게 관리 할까?
- [열거형을 사용해 같은 View Controller를 여러가지 목적으로 접근할 수 있다.](https://github.com/KayAhn0126/iOS-Study/tree/main/GrammarAndKnowledge/Enumeration/AccessVCWithSeveralPurpose)

## 🍎 TextField의 shouldChangeCharactersIn 메서드는 무엇일까? (업데이트 예정)
- 현재는 텍스트필드에 키보드로 입력을 하지 못하게 막아 놓았다.


## 🍎 다크모드 감지하기(정리 필수) (업데이트 예정)
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

## 🍎 required init 생성자 알아보기 (업데이트 예정)
- [required init 생성자 정리](https://github.com/KayAhn0126/iOS-Study/tree/main/GrammarAndKnowledge/RequiredInit)

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

## 🍎 앱 크래쉬 이유 및 해결 방법
- 앱 크래쉬: DiaryVC에서 Cell을 클릭하면 해당 cell의 정보를 DetailVC로 보여준다. 그 상태에서 즐겨찾기 버튼을 누르고, 앱 하단의 즐겨찾기 탭을 누르면 방금 즐겨찾기 버튼을 눌렀던 cell이 있고, 해당 cell을 클릭 후 DetailVC로 들어가 삭제를 해준다. 그리고 앱 하단의 '일기장' 탭을 누르면 아까 '즐겨찾기' 탭으로 넘어오기 전 화면이 그대로 있다(네비게이션 스택에서 pop이 되지 않아서). 현재 상태에서 수정이나 삭제를 누르면 앱이 충돌이 난다. 왜 그럴까?
- 결론은 해당 일기가 없는데 수정하려 하거나 삭제하려고 했기 때문이다.
- 수정이나 삭제는 결국 지정 구분자를 통해 post하는데 그 안에 cell의 indexPath와 같은 정보를 담아서 보낸다.
- indexPath로 일기를 구분하는 코드를 범용 고유 식별자인 UUID(Universally Unique IDentifier)로 바꿔 앱이 크래쉬 나던 현상을 해결했다.

## 🍎 사용자 경험 저하 요소 발견
- 아래의 GIF와 같이 탭마다 상태가 다르기 때문에 데이터의 통일성에 대해 생각 해봤다. 
- 두 가지 방법이 있는데 하나는 
    - 1. 탭이 눌릴때마다 해당 탭의 가장 윗단인 rootVC로 가는 로직 구현하기
    - 2. 수정이 일어날때 마다 notification을 보내 업데이트 하기
- 1번으로 진행하려고 했는데 이 또한 탭을 누르면 이전 작업물이 메모리에서 해제(popViewController)되는 상황이라 사용자 경험을 고려해 2번으로 진행했다.
- 먼저 현재 코드는 DetailDiaryVC에서 수정버튼을 누르면 "editDiary" 노티에 대한 구독을 시작하는데, 문제는 일기장 탭에서는 DetailDiaryVC에 들어와 있고()"editDiary" 노티에 대한 구독 안하고 있음), 즐겨찾기에서는 수정버튼을 눌러 "editDiary" 노티에 대한 구독을 하고있다. 즉 변경이 일어나면 즐겨찾기의 DetailDiaryVC의 값들만 바뀌고 있는 상황.
- 수정버튼을 클릭하면 notification을 구독하는 코드를 DetailDiary의 viewDidLoad()에 넣어주어서 수정이 일어나자 마자 바로 업데이트를 할 수 있게 만들어줬다.
- 아래는 데이터 일관성 문제와 해결에 대한 GIF

| 문제 | 해결 |
| :-: | :-: |
| ![](https://i.imgur.com/xvo32QN.gif) | ![](https://i.imgur.com/2HMjjV2.gif) |


## 🍎 프로젝트를 끝내고 느낀점. 
- 1. 아직 정확하게 무엇 때문인지는 모르겠지만, combine의 파이프라인 구현이 필요하다고 느꼈다.
- 2. DiffableDataSource를 사용 할 때, flowlayout에서 사용하는 deleteItmes와 같은 메서드를 사용하지 말자. -> snapshot과 동시에 이루어져 크래쉬 발생!


