# MMLoadingButton

[![CI Status](http://img.shields.io/travis/Millman/MMLoadingButton.svg?style=flat)](https://travis-ci.org/Millman/MMLoadingButton)
[![Version](https://img.shields.io/cocoapods/v/MMLoadingButton.svg?style=flat)](http://cocoapods.org/pods/MMLoadingButton)
[![License](https://img.shields.io/cocoapods/l/MMLoadingButton.svg?style=flat)](http://cocoapods.org/pods/MMLoadingButton)
[![Platform](https://img.shields.io/cocoapods/p/MMLoadingButton.svg?style=flat)](http://cocoapods.org/pods/MMLoadingButton)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Desc: This is a custom Button With loading progress animation with status scuess and error

        1.Scuess can set Transition
        2.Error can set reminder message

1.Demo With (Error,Scuess,Transition)

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/firstDemo.gif)

2.Setting

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/setting.png)

3.Error Color

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/setting1.png)


2.Scuess With Tick Animation

    loadingButton.stopLoading(true, completed: {
        print("Scuess Completed")
    })
    
![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/secondDemo.gif)

3.Error With Crossed Animation

    loadingButton.stopLoading(false, completed: {
        print("Error Completed")
    })

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/thirdDemo.gif)

4.Error With Crossed and Animation

    loadingButton.stopWithError("Error !!", hideInternal: 2, completed: {
        print ("Fail Message Completed")
    })

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/fourDemo.gif)


5.Add Transition With function

    self.loadingBtn.addScuessPresentVC(vc)

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/fiveDemo.gif)

## Installation

MMLoadingButton is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MMLoadingButton"
```

## Author

Millman, millmanyang@gmail.com

## License

MMLoadingButton is available under the MIT license. See the LICENSE file for more info.
