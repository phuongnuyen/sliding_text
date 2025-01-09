import Foundation
import SnapKit
import UIKit

class ZPSlidingLabel: UIView {
    var label = UILabel()
    var spacing = 30.0
    
    private(set) var isSliding = false
    // keep reference to the copy labels to make sliding circular
    private var cpLabels = [UILabel]()
    private var velocity = 0.0
    private var delay = 0.0
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        label.numberOfLines = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func stopAnimation() {
        resetLayout()
        isSliding = false
        velocity = 0.0
        delay = 0.0
    }
    
    
    func startAnimation(_ velocity: Double = 100.0, delay: Double = 1.0) {
        if isSliding { return }
        self.velocity = velocity
        self.delay = delay
        DispatchQueue.main.async {
            self.startSlidingIfNeed()
        }
    }
    
    private func startSlidingIfNeed() {
        let desiredWidth = computeDesiredSize(view: label).width
        if label.text?.isEmpty != true,
           velocity > 0,
           desiredWidth > bounds.width {
            self.isSliding = true
            self.slide(delay,
                       velocity,
                       bounds.width,
                       desiredWidth)
        }
    }
    
    private func computeDesiredSize(view: UIView) -> CGSize {
        let maximumLabelSize = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                      height: CGFloat.greatestFiniteMagnitude)
        var expectedLabelSize = view.sizeThatFits(maximumLabelSize)
        expectedLabelSize.height = view.bounds.size.height
        return expectedLabelSize
    }
    
    private func slide(_ delay: Double,
                       _ velocity: CGFloat,
                       _ displayWidth: Double,
                       _ desiredWidth: Double) {
        let copy1 = label.deepCopy()
        addSubview(copy1)
        copy1.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        let copy2 = label.deepCopy()
        addSubview(copy2)
        copy2.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        cpLabels.append(contentsOf: [copy1, copy2])
    
        let gap = (displayWidth - spacing) / velocity
        let slideFromEdgeDuration = (displayWidth + desiredWidth) / velocity
        let loopDuration = (slideFromEdgeDuration - gap) * 2
        
        let _1stDuration = desiredWidth / velocity
        let _2ndDelay = delay + _1stDuration - gap
        let _3rdDelay = _2ndDelay + slideFromEdgeDuration - gap
        
        let linearOption = KeyframeAnimationOptions(rawValue: AnimationOptions.curveLinear.rawValue)
        UIView.animate(withDuration: _1stDuration,
                       delay: delay,
                       options: [.curveLinear],
                       animations: { [weak self] in
            self?.label.transform = CGAffineTransform(translationX: -desiredWidth, y: 0)
        })
        
        copy1.transform = CGAffineTransform(translationX: displayWidth, y: 0)
        UIView.animateKeyframes(withDuration: loopDuration,
                                delay: _2ndDelay,
                                options: [.repeat, linearOption]) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, 
                               relativeDuration: slideFromEdgeDuration / loopDuration) { [weak copy1] in
                copy1?.transform = CGAffineTransform(translationX: -desiredWidth, y: 0)
            }
        }
        
        copy2.transform = CGAffineTransform(translationX: displayWidth, y: 0)
        UIView.animateKeyframes(withDuration: loopDuration,
                                delay: _3rdDelay,
                                options: [.repeat, linearOption]) {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: slideFromEdgeDuration / loopDuration) { [weak copy2] in
                copy2?.transform = CGAffineTransform(translationX: -desiredWidth, y: 0)
            }
        }
    }
    
    @objc private func willEnterForeground() {
        if self.isSliding {
            resetLayout()
            startSlidingIfNeed()
        }
    }
    
    private func resetLayout() {
        label.layer.removeAllAnimations()
        cpLabels.forEach { $0.removeFromSuperview() }
        label.transform = .identity
    }
}

fileprivate extension UILabel {
    func deepCopy() -> UILabel {
        let copy = UILabel()
        copy.text = self.text
        copy.font = self.font
        copy.textColor = self.textColor
        copy.textAlignment = self.textAlignment
        copy.lineBreakMode = self.lineBreakMode
        copy.numberOfLines = self.numberOfLines
        copy.backgroundColor = self.backgroundColor
        copy.isEnabled = self.isEnabled
        copy.isHidden = self.isHidden
        copy.isHighlighted = self.isHighlighted
        copy.shadowColor = self.shadowColor
        copy.shadowOffset = self.shadowOffset
        copy.attributedText = self.attributedText
        copy.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth
        copy.minimumScaleFactor = self.minimumScaleFactor
        copy.allowsDefaultTighteningForTruncation = self.allowsDefaultTighteningForTruncation
        
        // Frame-related properties
        copy.frame = self.frame
        copy.bounds = self.bounds
        copy.center = self.center
        copy.transform = self.transform
        
        // Layer properties
        copy.layer.cornerRadius = self.layer.cornerRadius
        copy.layer.borderWidth = self.layer.borderWidth
        copy.layer.borderColor = self.layer.borderColor
        copy.layer.shadowColor = self.layer.shadowColor
        copy.layer.shadowOpacity = self.layer.shadowOpacity
        copy.layer.shadowOffset = self.layer.shadowOffset
        copy.layer.shadowRadius = self.layer.shadowRadius
        copy.layer.masksToBounds = self.layer.masksToBounds
        return copy
    }
}
