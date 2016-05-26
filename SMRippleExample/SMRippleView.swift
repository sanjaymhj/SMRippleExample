import UIKit

class SMRippleView: UIView {
    
    var rippleColor: UIColor = UIColor.blackColor()
    var rippleThickness: Float = 0.5
    var rippleTimer: Float = 1
    var rippleEndScale: Float = 5
    var rippleTrailColor: UIColor = UIColor.clearColor()
    var fillColor: UIColor = UIColor.clearColor()
    var animationDuration: NSTimeInterval = 2.5
    var originalSize: CGRect?
    
    private var timer: NSTimer?
    
    convenience init(frame: CGRect, rippleColor: UIColor, rippleThickness: Float, rippleTimer: Float, fillColor: UIColor?, animationDuration: Double, parentFrame: CGRect) {
        self.init(frame: frame)
        self.layer.zPosition = -1
        commonInit(frame, rippleColor: rippleColor, rippleThickness: rippleThickness, rippleTimer: rippleTimer, fillColor: fillColor,  animationDuration: animationDuration, parentFrame: parentFrame)
    }
    
    private override init(frame: CGRect) {
        let squareRect = CGRect(x: frame.minX, y: frame.minY, width: max(frame.width, frame.height), height: max(frame.width, frame.height))
        super.init(frame: squareRect)
    }
    
    func stopAnimation() {
        guard let timer = self.timer else { return }
        timer.invalidate()
    }
    
    private func commonInit(frame: CGRect, rippleColor: UIColor = UIColor.blackColor(), rippleThickness: Float = 0.5, rippleTimer: Float = 1,  fillColor: UIColor?, animationDuration: Double, parentFrame: CGRect) {
        self.originalSize = frame
        self.rippleColor = rippleColor
        self.rippleThickness = rippleThickness
        self.rippleTimer = rippleTimer
        if fillColor != nil {
            self.fillColor = fillColor!
        } else {
            self.fillColor = UIColor.clearColor()
        }
        
        self.animationDuration = NSTimeInterval(animationDuration)
        self.drawWithFrame(frame)
        
        let maxSize = min(parentFrame.width,parentFrame.height)
        self.rippleEndScale = Float(maxSize - (self.originalSize?.width)!) / Float(self.frame.width)

    }
    
    func drawWithFrame(frame: CGRect) {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(self.rippleTimer), target: self, selector: #selector(continuousRipples), userInfo: nil, repeats: true)
    }
    
    func continuousRipples() {
        let pathFrame: CGRect = CGRect(x: -CGRectGetMidX(self.bounds), y: -CGRectGetMidY(self.bounds), width: self.bounds.size.width, height: self.bounds.size.height)
        let path = UIBezierPath(roundedRect: pathFrame, cornerRadius: self.frame.size.height)
        let shapePosition = self.convertPoint(self.center, fromView: nil)
        
        let circleShape = CAShapeLayer()
        circleShape.path = path.CGPath
        circleShape.position = shapePosition
        circleShape.fillColor = self.fillColor.CGColor
        circleShape.opacity = 0
        circleShape.zPosition = -1
        circleShape.strokeColor = self.rippleColor.CGColor
        circleShape.lineWidth = CGFloat(self.rippleThickness)
        
        self.layer.addSublayer(circleShape)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(CATransform3D:CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(CATransform3D:CATransform3DMakeScale(CGFloat(self.rippleEndScale), 1, 1))
        let alphaAnimation = CABasicAnimation(keyPath:"opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = self.animationDuration
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        circleShape.addAnimation(animation, forKey:nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
