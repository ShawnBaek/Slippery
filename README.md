# Slippery

[![CI Status](http://img.shields.io/travis/shawnbaek/Slippery.svg?style=flat)](https://travis-ci.org/shawnbaek/Slippery)
[![Version](https://img.shields.io/cocoapods/v/Slippery.svg?style=flat)](http://cocoapods.org/pods/Slippery)
[![License](https://img.shields.io/cocoapods/l/Slippery.svg?style=flat)](http://cocoapods.org/pods/Slippery)
[![Platform](https://img.shields.io/cocoapods/p/Slippery.svg?style=flat)](http://cocoapods.org/pods/Slippery)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 4.0
iOS 11.0

## Installation

Slippery is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Slippery'
```

## Sample Project

![Calendar View](./Images/calendar.gif)
```swift

func setupCollectionView(){

    self.collectionViewLayout = SlipperyFlowLayout.configureLayout(collectionView: self.calendarView, itemSize: CGSize(width: 120, height: 180), minimumLineSpacing: 10, highlightOption: .center(.cropping))
    self.collectionViewLayout.scaleItems = true
    self.collectionViewLayout.invalidateLayout()
    self.calendarView.layoutIfNeeded()

}

```

![SliceNumver View](./Images/slice.gif)

```swift

func setupCollectionView(){

    self.collectionViewLayout = SlipperyFlowLayout.configureLayout(collectionView: self.sliceView, itemSize: CGSize(width: 30, height: 180), minimumLineSpacing: 20, highlightOption: .custom(.leading, .third))

    self.collectionViewLayout.invalidateLayout()
    self.sliceView.layoutIfNeeded()

}

```

![Photo View](./Images/photo.gif)

```swift
func setupCollectionView(){

    self.collectionViewLayout = SlipperyFlowLayout.configureLayout(collectionView: self.photoView, itemSize: CGSize(width: 150, height: 180), minimumLineSpacing: 20, highlightOption: .center(.normal))

    self.collectionViewLayout.invalidateLayout()
    self.photoView.layoutIfNeeded()

}
```

## scrollToItem

create a scrollToItem function in your ViewController

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    createDummyNumbers()

    setupCollectionView()
    scrollToItem(item: 20, animated: true)
}

func createDummyNumbers(){

    for i in 0 ... 100 {
    dummyNumbers.append(i)
    }
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.view.layoutIfNeeded()
}

func scrollToItem(item: Int, animated: Bool) {

    let itemOffset = self.collectionViewLayout.updateOffset(item: item)
    self.calendarView.setContentOffset(CGPoint(x: itemOffset, y: 0), animated: true)
    self.calendarView.layoutIfNeeded()

}

```


## Acknowledgment

I make this Library inspired by [LGLinearFlow](https://github.com/lukagabric/LGLinearFlow).
Thank you for sharing your code.

## Author

shawnbaek, shawn@shawnbaek.com


## Contact

twitter, [@yoshiboarder](https://twitter.com/yoshiboarder)

## License

Slippery is available under the MIT license. See the LICENSE file for more info.
