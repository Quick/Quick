# 코드를 테스트하지 말고, 동작을 확인하라

테스트는 응용프로그렘이 **다르게 동작하는** 경우에만 실패해야 합니다.
응용 프로그램 코드가 하는 일을 테스트하는 것이지, 코드가 어떻게 동작하는지 테스트 하는 것이 아닙니다.

- 응용 프로그램이 **행동 테스트**인지 확인하는 테스트
- 동작이 동일하게 유지되더라도 응용 프로그램 코드가 변경되면 중단되는 테스트는 **망가지기 쉬운 테스트** 입니다.

우리가 `GorillaDB` 라 불리는 바나나 데이터베이스를 가지고 있다고 해봅시다.
`GorillaDB` 는 key-value 로 바나나들을 저장하고 있습니다. 우리는 바바나를 이렇게 저장할 수 있습니다 :

```swift
let database = GorillaDB()
let banana = Banana()
database.save(banana: banana, key: "my-banana")
```

그리고 나중에 디스크에서 바나나를 이렇게 불러올 수 있습니다 :

```swift
let banana = database.load(key: "my-banana")
```

## 과도한 테스트

이 동작을 어떻게 테스트해야 할까요? 한 가지 방법은 바나나를 저장한 이후의 데이터베이스 크기를 확인하는 것입니다 :

```swift
// GorillaDBTests.swift

func testSave_savesTheBananaToTheDatabase() {
  // Arrange: Create a database and get its original size.
  let database = GorillaDB()
  let originalSize = database.size

  // Act: Save a banana to the database.
  let banana = Banana()
  database.save(banana: banana, key: "test-banana")

  // Assert: The size of the database should have increased by one.
  XCTAssertEqual(database.size, originalSize + 1)
}
```


그러나 `GorillaDB` 의 코드가 변경된다고 상상해 보세요. 바나나를 데이터베이스에서 빠르게 읽을 수 있도록 만드려면 가장 자주 사용되는 바나나의 캐시를 유지해야 합니다. `GorillaDB.size` 의 크기는 캐시가 커짐에 따라 점차 커지고, 테스트는 실패할 것입니다.

![](https://raw.githubusercontent.com/Quick/Assets/master/Screenshots/Screenshot_database_size_fail.png)

## 행동 테스트

행동 테스트 작성의 핵심은 애플리케이션 코드의 동작이 기대하는 것을 정확하게 결정하는 것입니다.

`testSave_savesTheBananaToTheDatabase` 테스트의 맥락에서 : 우리가 바나나를 데이터베이스에 "저장" 할 때 우리가 기대하는 행동은 무엇일까요? "저장" 은 나에게 우리가 나중에 로드할 수 있음을 암시합니다. 따라서 데이터베이스의 사이즈가 증가하는 것을 테스트하는 대신에, 우리가 바나나를 로드할 수 있는지를 테스트해야 합니다.

```diff
// GorillaDBTests.swift

func testSave_savesTheBananaToTheDatabase() {
  // Arrange: Create a database and get its original size.
  let database = GorillaDB()
-  let originalSize = database.size

  // Act: Save a banana to the database.
  let banana = Banana()
  database.save(banana: banana, key: "test-banana")

-  // Assert: The size of the database should have increased by one.
-  XCTAssertEqual(database.size, originalSize + 1)
+  // Assert: The bananas saved to and loaded from the database should be the same.
+  XCTAssertEqual(database.load(key: "test-banana"), banana)
}
```

행동테스트를 작성하는 열쇠는 다음과 같습니다 :

- 정확히 이 애플리케이션 코드가 무엇을 해야 하는지?

- 나의 테스트가 오직 그 동작만을 테스트 하는가?

  또는 코드가 다르게 작동함에 따라 실패할 수 있는가?
