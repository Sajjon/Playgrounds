//: Playground - noun: a place where people can play

import UIKit


class MyTextFieldDelegate: NSObject, UITextFieldDelegate { //NSObjectProtocol
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

class MyTextViewDelegate: NSObject, UITextViewDelegate { //NSObjectProtocol, UIScrollViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        print("hej")
    }
}

class MyScrollViewDelegate: NSObject, UIScrollViewDelegate { //NSObjectProtocol
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("hej")
    }
}

let textField = UITextField()
textField.delegate = MyTextFieldDelegate()

let textView = UITextView()
textView.delegate = MyTextViewDelegate()


let scrollView = UIScrollView()
scrollView.delegate = MyScrollViewDelegate()