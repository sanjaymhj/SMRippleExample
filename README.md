SMRippleView
============

Simple Ripple View to add ripple effect to the view.

ScreenShot
----------
![Gif](/Screenshot/RippleView.gif)

![Screenshot 1](/Screenshot/Screenshot_1.png)

![Screenshot 2](/Screenshot/Screenshot_2.png)

Code Snippet
------------
```
let fillColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
let rippleView = SMRippleView(frame: baseView.frame, rippleColor: UIColor.clearColor(), rippleThickness: 0.2, rippleTimer: 1, fillColor: fillColor, animationDuration: 3, parentFrame: self.view.frame)
self.view.addSubview(rippleView)
```

[Wrote a blog](https://medium.com/@snjmhj/creating-a-ripple-effect-in-ios-9957f9099873)
