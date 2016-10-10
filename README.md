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
        3.Error message will autoLayout when show

1.Demo With (Error,Scuess,Transition)

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/demo.gif)

2.Setting

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/setting.png)

3.Setting (Error Color , Top Margin ,Font)

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/settingInfo.png)


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

4.Error With Crossed ,message and Animation

    loadingButton.stopWithError("Error !!", hideInternal: 2, completed: {
        print ("Fail Message Completed")
    })

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/fourDemo.gif)


5.Add Transition With function

        loadingBtn.addScuessPresentVC(vc)

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/fiveDemo.gif)

If you presentViewController with default transition,you can add custom transition use

        loadingBtn.addScuessWithDismissVC()

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/sixDemo.gif)


6.Auto Push the bottom View when show Error Message

![LoadingButton](https://github.com/MillmanY/MMLoadingButton/blob/master/DemoGif/demoPush.gif)

## Installation

MMLoadingButton is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
Swift3
pod "MMLoadingButton"
Swift 2.3
pod ‘MMCardView’,:git => 'https://github.com/MillmanY/MMLoadingButton', :branch => ‘Swift2’

```

## Author

Millman, millmanyang@gmail.com

## License

MMLoadingButton is available under the MIT license. See the LICENSE file for more info.
