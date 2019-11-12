# PhotoSlider
![](https://github.com/phuhuynh2411/PhotoSlider/blob/master/Nov-12-2019%2015-48-54.gif)

## Features
- Create a photo slider with predefined images
- After reaching the last image, it should not stop and goes to the first image.
- Auto switch between images by a time interval

## Usage
Create an array of UI Images
```swift
images: [UIImage] = [UIImage(named: "image1")!,
                                 UIImage(named: "image2")!,
                                 UIImage(named: "image3")!,
                                 UIImage(named: "image4")!]
```

Select one of the following option
1. Set up a normal photo slider
```swift
photoSliderView.configure(with: images)
```
2. Create a circular photo slider
```swift
photoSliderView.configure(with: images, circular: true)
```
3. Auto switches between pages by a time interval
```swift
photoSliderView.configure(with: images, circular: true, timeInterval: 5)
```

You can also show or hide the page indicator. The page indicator displays by default.
```swift
photoSliderView.showPageIndicator = false
```

