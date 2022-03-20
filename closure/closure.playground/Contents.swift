import Foundation

struct User {
    var name: String
}

// 同期的に書くとサーバ（非同期処理）からもらった値を使うことができない（userの名前がbeforeのまま）
func download() -> User {
    var user = User(name: "before")
    user.name
    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
        user = User(name: "after")
    }
    return user
}

let user = download()
user.name

// --------------------------------------

// closureを使うことで，非同期処理が終わった後の処理（持っていたuser2に代入）をすることができる
func download(completion: @escaping (User) -> ()) {
    var user = User(name: "before")
    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
        user = User(name: "after")
        completion(user) // downloadを呼んだ側に返す
    }
}

var user2 = User(name: "before")
user2.name

download { user in
    user2 = user
    user2.name
}

// --------------------------------------

// 非同期的に実行されるので，その他の処理を進めることができる
print("before")
download { user in
    user2 = user
    print(user2)
}
print("after")
