import UIKit

/**
 Ripple View
 
 Creates a view with concentric circular ripples.
 
 Creates a layer of the ripple on the frame and constraints its max frame to the parent's frame.
 
 
 `init(frame: CGRect, rippleColor: UIColor, rippleThickness: Float, rippleTimer: Float, fillColor: UIColor?, animationDuration: Double, parentFrame: CGRect)`
 */
final class SMRippleView: UIView {
    
    var rippleColor: UIColor = UIColor.black
    var rippleThickness: Float = 0.5
    var rippleTimer: Float = 1
    var rippleEndScale: Float = 5
    var rippleTrailColor: UIColor = UIColor.clear
    var fillColor: UIColor = UIColor.clear
    var animationDuration: TimeInterval = 2.5
    var originalSize: CGRect?
    
    fileprivate var timer: Timer?
    
    var originalFrame: CGRect!
    
    convenience init(frame: CGRect, rippleColor: UIColor, rippleThickness: Float, rippleTimer: Float, fillColor: UIColor?, animationDuration: Double, parentFrame: CGRect) {
        self.init(frame: frame)
        originalFrame = frame
        self.layer.zPosition = -10
        commonInit(frame, rippleColor: rippleColor, rippleThickness: rippleThickness, rippleTimer: rippleTimer, fillColor: fillColor,  animationDuration: animationDuration, parentFrame: parentFrame)
    }
    
    fileprivate override init(frame: CGRect) {
        let squareRect = CGRect(x: frame.minX, y: frame.minY, width: max(frame.width, frame.height), height: max(frame.width, frame.height))
        super.init(frame: squareRect)
    }
    
    func stopAnimation() {
        guard let timer = self.timer else { return }
        timer.invalidate()
    }
    
    fileprivate func commonInit(_ frame: CGRect, rippleColor: UIColor = UIColor.black, rippleThickness: Float = 0.5, rippleTimer: Float = 1,  fillColor: UIColor?, animationDuration: Double, parentFrame: CGRect) {
        self.originalSize = frame
        self.rippleColor = rippleColor
        self.rippleThickness = rippleThickness
        self.rippleTimer = rippleTimer
        if let fillColor = fillColor {
            self.fillColor = fillColor
        } else {
            self.fillColor = UIColor.clear
        }
        
        self.animationDuration = TimeInterval(animationDuration)
        let maxSize = min(parentFrame.width, parentFrame.height)
        self.rippleEndScale = Float(maxSize - frame.width) / Float(self.frame.width)
        
        self.drawWithFrame(frame)
    }
    
    /// For initial ripple ie. at 0 time
    private func drawWithFrame(_ frame: CGRect) {
        startRipple()
    }
    
    private func getLayer() -> RippleCALayer {
        
        //Minimum bounds
        let pathFrame: CGRect = CGRect(x: -self.bounds.midX, y: -self.bounds.midY, width: self.bounds.size.width, height: self.bounds.size.height)

        
        let path = UIBezierPath(roundedRect: pathFrame, cornerRadius: self.frame.size.height)
        
        let shapePosition = CGPoint(x: originalFrame.midX, y: originalFrame.midY)
        let circleShape = RippleCALayer()
        circleShape.path = path.cgPath
        
        //position set to Center of bounds. If set to origin, it will only expand to +x and +y
        circleShape.position = shapePosition
        circleShape.fillColor = self.fillColor.cgColor
        circleShape.opacity = 0//Opacity is 0 so it is invisible in initial state
        circleShape.zPosition = -10
        circleShape.strokeColor = self.rippleColor.cgColor
        circleShape.lineWidth = CGFloat(self.rippleThickness)

        return circleShape
    }
    
    private func getAnimation() -> CAAnimationGroup {
        // Scale Animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(CGFloat(self.rippleEndScale), 1, 1))
        
        // Alpha Animation
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = self.animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return animation
    }
    
    
    func startRipple() {
        self.timer = Timer.scheduledTimer(timeInterval: Double(self.rippleTimer), target: self, selector: #selector(continuousRipples), userInfo: nil, repeats: true)
    }
    
    @objc
    private func continuousRipples() {
        let layer = getLayer()
        let animation = getAnimation()
        // To remove layer from super layer after animation completes
        animation.delegate = layer
        layer.animationDelegate = self
        layer.add(animation, forKey: nil)
        //self.superview?.layer.insertSublayer(layer, below: self.superview?.layer)//addSublayer(layer)
        self.superview?.layer.addSublayer(layer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

// Protocol and extension for removing layer from super layer after animation completes

extension SMRippleView: AnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, layer: CALayer, finished: Bool) {
        layer.removeFromSuperlayer()
        print("removed layer")
        print(layer)
    }
}

extension RippleCALayer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animationDelegate?.animationDidStop(anim, layer: self, finished: flag)
    }
}

final class RippleCALayer: CAShapeLayer {
    var animationDelegate: AnimationDelegate?
}

protocol AnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, layer: CALayer, finished: Bool)
}
