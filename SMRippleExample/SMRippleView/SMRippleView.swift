import UIKit

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
    
    convenience init(frame: CGRect, rippleColor: UIColor, rippleThickness: Float, rippleTimer: Float, fillColor: UIColor?, animationDuration: Double, parentFrame: CGRect) {
        self.init(frame: frame)
        self.layer.zPosition = -1
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
        if fillColor != nil {
            self.fillColor = fillColor!
        } else {
            self.fillColor = UIColor.clear
        }
        
        self.animationDuration = TimeInterval(animationDuration)
        self.drawWithFrame(frame)
        
        let maxSize = min(parentFrame.width,parentFrame.height)
        self.rippleEndScale = Float(maxSize - (self.originalSize?.width)!) / Float(self.frame.width)

    }
    
    func drawWithFrame(_ frame: CGRect) {
        self.timer = Timer.scheduledTimer(timeInterval: Double(self.rippleTimer), target: self, selector: #selector(continuousRipples), userInfo: nil, repeats: true)
    }
    
    @objc
    private func continuousRipples() {
        let pathFrame: CGRect = CGRect(x: -self.bounds.midX, y: -self.bounds.midY, width: self.bounds.size.width, height: self.bounds.size.height)
        let path = UIBezierPath(roundedRect: pathFrame, cornerRadius: self.frame.size.height)
        let shapePosition = self.convert(self.center, from: nil)
        
        let circleShape = CAShapeLayer()
        circleShape.path = path.cgPath
        circleShape.position = shapePosition
        circleShape.fillColor = self.fillColor.cgColor
        circleShape.opacity = 0
        circleShape.zPosition = -1
        circleShape.strokeColor = self.rippleColor.cgColor
        circleShape.lineWidth = CGFloat(self.rippleThickness)
        
        self.layer.addSublayer(circleShape)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(caTransform3D:CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(caTransform3D:CATransform3DMakeScale(CGFloat(self.rippleEndScale), 1, 1))
        let alphaAnimation = CABasicAnimation(keyPath:"opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = self.animationDuration
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        circleShape.add(animation, forKey:nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
