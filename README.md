# Sliding Text Animation
Provide a SlidingLabel to display a circular sliding animation using UIKit.
The SlidingLabel automatically checks if the text is larger than its size to animate or not.

![Alt Text](https://github.com/phuongnuyen/sliding_text/blob/main/sliding_text.gif)

# Installing
Supports Swift Package Manager

To install please use Swift Package Manager you can follow the tutorial published by Apple using the URL for the Lottie repo with the current version:

In Xcode, select “File” → “Add Packages...”
Enter https://github.com/phuongnuyen/sliding_text_spm.git

# How to use
Add an instance of SlidingLabel to your view, then call startAnimation to begin to start sliding or call stopAnimation to stop sliding.

```swift
let slidingLabel = SlidingLabel()
slidingLabel.label.text = "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
slidingLabel.spacing = 50.0
view.addSubview(slidingLabel)

if slidingLabel.isSliding {
  slidingLabel.stopAnimation()
} else {
  slidingLabel.startAnimation()
}
```
