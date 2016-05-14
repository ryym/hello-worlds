//: ## Error Handling
//:
//: You represent errors using any type that adopts the `ErrorType` protocol.
//:
enum PrinterError: ErrorType {
    case OutOfPaper
    case NoToner
    case OnFire
}

//: Use `throw` to throw an error and `throws` to mark a function that can throw an error. If you throw an error in a function, the function returns immediately and the code that called the function handles the error.
//:
// throwsといっても、Javaと違って投げるエラーの種類を列挙する必要はなく、throwsをつけるだけ。
// また、Javaの例外のように検査・非検査といった違いはなく、throwsがついた関数を実行する際には、
// 必ず例外を補足するコードが必要になる。めずらしい。
func sendToPrinter(printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.NoToner
    }
    return "Job sent"
}

// sendToPrinter("")

//: There are several ways to handle errors. One way is to use `do`-`catch`. Inside the `do` block, you mark code that can throw an error by writing `try` in front of it. Inside the `catch` block, the error is automatically given the name `error` unless you can give it a different name.
//:
// do-catch and try! not try-catch.
do {
    let printerResponse = try sendToPrinter("Never Has Toner")
    print(printerResponse)
} catch {
    print(error)
}

//: - Experiment:
//: Change the printer name to `"Never Has Toner"`, so that the `sendToPrinter(_:)` function throws an error.
//:
//: You can provide multiple `catch` blocks that handle specific errors. You write a pattern after `catch` just as you do after `case` in a switch.
//:
do {
    let printerResponse = try sendToPrinter("Never Has Toner")
    print(printerResponse)
    
    //throw PrinterError.OnFire

} catch PrinterError.OnFire {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}

//: - Experiment:
//: Add code to throw an error inside the `do` block. What kind of error do you need to throw so that the error is handled by the first `catch` block? What about the second and third blocks?
//:
//: Another way to handle errors is to use `try?` to convert the result to an optional. If the function throws an error, the specific error is discarded and the result is `nil`. Otherwise, the result is an optional containing the value that the function returned.
//:
// もし正常終了する場合にnilを返し、かつ例外が発生しうる関数があった場合、
// try?を使っちゃうと例外が起きたのかどうか判定できない?
let printerSuccess = try? sendToPrinter("Mergenthaler")
let printerFailure = try? sendToPrinter("Never Has Toner")

//: Use `defer` to write a block of code that is executed after all other code in the function, just before the function returns. The code is executed regardless of whether the function throws an error. You can use `defer` to write setup and cleanup code next to each other, even though they need to be executed at different times.
//:
var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]

// deferはGoと同じ。Javaでいうfinally
func fridgeContains(itemName: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }

    let result = fridgeContent.contains(itemName)
    return result
}
fridgeContains("banana")
print(fridgeIsOpen)



//: [Previous](@previous) | [Next](@next)
