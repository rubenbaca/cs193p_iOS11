//
//  CardView.swift
//  Set
//
//  Created by Ruben on 12/9/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

///
/// UIView that represents a Card to play a traditional Set game
///
@IBDesignable
class CardView: UIView {
    
    // MARK: Public properties

    ///
    /// The card's Color type
    ///
    var color: Color? { didSet { setNeedsDisplay() } }
    
    ///
    /// The card's Shade type
    ///
    var shade: Shade? { didSet { setNeedsDisplay() } }
    
    ///
    /// The number of elements/shapes in the card
    ///
    var elements: Elements? { didSet { setNeedsDisplay() } }
    
    ///
    /// The card's Shape
    ///
    var shape: Shape? { didSet { setNeedsDisplay() } }
    
    ///
    /// Whether or not the card is currently selected
    ///
    @IBInspectable
    var isSelected: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: Public types

    ///
    /// Different types of color
    ///
    enum Color: Int {
        case green, red, purple
    }
    
    ///
    /// Different types of shade/fill
    ///
    enum Shade {
        case solid, shaded, unfilled
    }
    
    ///
    /// Number of elements/figures in the card
    ///
    enum Elements {
        case one, two, three
    }
    
    ///
    /// The shape of the card's figures
    ///
    enum Shape {
        case squiggle, diamond, oval
    }
    
    // MARK: Overriden properties

    ///
    /// Redraw the card when the view's frame changes
    ///
    override var frame: CGRect {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: Overriden methods

    ///
    /// Do custom drawing of the current card. Note that the card must have these set
    /// to properly display a Set card:
    ///    - Shape
    ///    - Color
    ///    - Shade
    ///    - Elements
    ///
    override func draw(_ rect: CGRect) {
        
        // Setup card's general look and feel (without the actual figures/shapes)
        setupCard()
        
        // Make sure all features are set (not nil)
        guard color != nil, shade != nil, elements != nil, shape != nil else {
            print("All features must be set. Cannot draw card.")
            return
        }
        
        // Draw each shape (i.e. card might have one, two, or three shapes)
        for rect in getRects(for: elements!) {
            drawContent(rect: rect, shape: shape!, color: color!, shade: shade!)
        }
    }
    
    // Init with frame (i.e. through code)
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    // Init with coder (i.e. through storyboard/interface-builder)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    // MARK: Private properties

    ///
    /// Shape margin percentage. Used to add a little margin to each shape, relative to the
    /// frame's size.
    ///
    private let shapeMargin: CGFloat = 0.15
    
    // MARK: Private methods
    
    ///
    /// Do any initial setup (called right after init())
    ///
    private func initialSetup() {
        isOpaque = false
    }
    
    ///
    /// Setup card's general look and feel (without the actual features)
    ///
    private func setupCard() {
        
        // We want rounded corners in our card
        let cornerRadius = min(bounds.size.width, bounds.size.height) * 0.1
        
        // The path that draws the card's structure
        let cardPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        // Add clip on the card's border
        cardPath.addClip()
        
        // Card's background/fill color
        UIColor.white.setFill()
        
        // If card is selected, draw a highlight color around it
        if isSelected {
            cardPath.lineWidth = min(bounds.size.width, bounds.size.height) * 0.1
            #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).setStroke()
        }
        else {
            cardPath.lineWidth = min(bounds.size.width, bounds.size.height) * 0.01
            UIColor.lightGray.setStroke()
        }
        
        // Fill and stroke it
        cardPath.fill()
        cardPath.stroke()
    }
    
    ///
    /// Draw the card's features inside the given rect
    ///
    private func drawContent(rect: CGRect, shape: Shape, color: Color, shade: Shade) {
        
        // Get the shape's path
        let shapePath = path(forShape: shape, in: rect)
        
        // The stroke color we want to use
        let stroke = strokeColor(for: color)
        
        // The fill/shade color we want to use
        let fill = fillColor(for: color, with: shade)
        
        // Set stroke and fill colors
        stroke.setStroke()
        fill.setFill()
        
        // Set the lineWidth
        shapePath.lineWidth = min(rect.size.width, rect.size.height) * 0.05
        
        // Stroke and fill
        shapePath.fill()
        shapePath.stroke()
    }

    ///
    /// Get a UIBezierPath for the given shape which fits in the given rect
    ///
    private func path(forShape shape: Shape, in rect: CGRect) -> UIBezierPath {
        // Delegate the actual work to specific methods
        switch shape {
        case .diamond: return diamondPath(in: rect)
        case .oval: return ovalPath(in: rect)
        case .squiggle: return squigglePath(in: rect)
        }
    }
    
    ///
    /// Get CGRect(s) for the given number of elements.
    ///
    private func getRects(for elements: Elements) -> [CGRect] {
        
        // Calculate the size for each rect
        let maxOfWidthAndHeight = max(bounds.size.width, bounds.size.height)
        let sizeOfEachRect = CGSize(width: maxOfWidthAndHeight/3, height: maxOfWidthAndHeight/3)
        
        // The CGRects we'll return
        var rects = [CGRect]()
        
        switch elements {
            
        // One rect
        case .one:
            rects.append(rectForOneElement(sizeOfEachRect: sizeOfEachRect))
        // Two rects
        case .two:
            rects += rectsForTwoElements(sizeOfEachRect: sizeOfEachRect)
        // Three rects
        case .three:
            rects += rectsForThreeElements(sizeOfEachRect: sizeOfEachRect)
        }
        
        return rects
    }
    
    ///
    /// Get a CGRect for drawing one element/shape inside the card:
    ///    - The rect will be centered horizontally and vertically
    ///
    private func rectForOneElement(sizeOfEachRect: CGSize) -> CGRect {
        
        let x = bounds.midX - sizeOfEachRect.width / 2
        let y = bounds.midY - sizeOfEachRect.height / 2
        
        let originPoint = CGPoint(x: x, y: y)
        
        return CGRect(origin: originPoint, size: sizeOfEachRect)
    }
    
    ///
    /// Get two CGRects for drawing two elements/shapes inside the card:
    ///    - If card's width > card's height:
    ///       - Rects will be horizontally distributed (to better use the available space)
    ///    - Else:
    ///       - Rects will be vertically distributed (to better use the available space)
    ///
    private func rectsForTwoElements(sizeOfEachRect: CGSize) -> [CGRect] {
        
        // We'll use the rect for showing 1 element as a guide to distribute the
        // acutal rects (top/bottom or left/right) we want to create
        let rectForOne = rectForOneElement(sizeOfEachRect: sizeOfEachRect)
        
        // Could be top/bottom or left/right depending on card's bounds.
        let rect1, rect2: CGRect
        
        // We have more width than height, distribute them horizontally
        if bounds.width > bounds.height {
            rect1 = rectForOne.offsetBy(dx: sizeOfEachRect.width/2, dy: 0)
            rect2 = rectForOne.offsetBy(dx: -(sizeOfEachRect.width/2), dy: 0)
        }
        // We have more height than width, distribute them vertically
        else {
            rect1 = rectForOne.offsetBy(dx: 0, dy: sizeOfEachRect.height/2)
            rect2 = rectForOne.offsetBy(dx: 0, dy: -(sizeOfEachRect.height/2))
        }
        
        return [rect1, rect2]
    }
    
    ///
    /// Get three CGRects for drawing three elements/shapes inside the card:
    ///    - If card's width > card's height:
    ///       - Rects will be horizontally distributed (to better use the available space)
    ///    - Else:
    ///       - Rects will be vertically distributed (to better use the available space)
    ///
    private func rectsForThreeElements(sizeOfEachRect: CGSize) -> [CGRect] {
        
        // The rect for the element in the center is the same for 1 or 3 elements
        let centerRect = rectForOneElement(sizeOfEachRect: sizeOfEachRect)
        
        // Could be top/bottom or left/right depending on card's bounds.
        let rect1, rect2: CGRect
        
        // We have more width than height, distribute them horizontally
        if bounds.width > bounds.height {
            rect1 = CGRect(x: centerRect.minX - sizeOfEachRect.width,
                           y: centerRect.minY,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
            
            rect2 = CGRect(x: centerRect.maxX,
                           y: centerRect.minY,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
        }
        // We have more height than width, distribute them vertically
        else {
            rect1 = CGRect(x: centerRect.minX,
                           y: centerRect.minY - sizeOfEachRect.height,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
            
            rect2 = CGRect(x: centerRect.minX,
                           y: centerRect.maxY,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
        }
        
        return [centerRect, rect1, rect2]
    }
    
    ///
    /// Get UIBezierPath for a diamond shape that fits inside the given rect.
    /// The path will contain a small margin/padding space.
    ///
    private func diamondPath(in rect: CGRect) -> UIBezierPath {
        
        // Path to populate
        let path = UIBezierPath()
        
        // Add a little margin/padding
        let margin = min(rect.size.width, rect.size.height) * shapeMargin
        
        // The top-center point
        let topCenter = CGPoint(x: rect.midX, y: rect.minY + margin)
        path.move(to: topCenter)
        
        // Go to the center-right
        let centerRight = CGPoint(x: rect.maxX - margin, y: rect.midY)
        path.addLine(to: centerRight)
        
        // Got to the bottom-center
        let bottomCenter = CGPoint(x: rect.midX, y: rect.maxY - margin)
        path.addLine(to: bottomCenter)
        
        // Go to the center-left
        let centerLeft = CGPoint(x: rect.minX + margin, y: rect.midY)
        path.addLine(to: centerLeft)
        
        // Close it to complete the shape
        path.close()
        
        return path
    }
    
    ///
    /// Get UIBezierPath for an oval shape that fits inside the given rect.
    /// The path will contain a small margin/padding space.
    ///
    private func ovalPath(in rect: CGRect) -> UIBezierPath {
        
        // To add a little margin/padding
        let margin = min(rect.size.width, rect.size.height) * shapeMargin
        
        // Oval needs to fit inside this space
        let rectWithMargin = CGRect(x: rect.origin.x + margin,
                                    y: rect.origin.y + margin,
                                    width: rect.size.width - (margin * 2),
                                    height: rect.size.height - (margin * 2))
        
        // Create the oval
        return UIBezierPath(ovalIn: rectWithMargin)
    }
    
    ///
    /// Get a stroke UIColor for the given `Color`
    ///
    private func strokeColor(for color: Color) -> UIColor {
        switch color {
        case .green: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .purple: return #colorLiteral(red: 0.6377331317, green: 0, blue: 0.7568627596, alpha: 1)
        case .red: return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    ///
    /// Get a fill UIColor for the given Shade/Color combination.
    ///
    private func fillColor(for color: Color, with shade: Shade) -> UIColor {
        
        // The shade color depends on the stroke color, it just changes in transparency based on
        // the shade type
        let stroke = strokeColor(for: color)
        
        // Change transparency based on shade type
        switch shade {
        // Totally filled/solid
        case .solid: return stroke.withAlphaComponent(1.0)
        // A little transparency (shaded)
        case .shaded: return stroke.withAlphaComponent(0.2)
        // No fill at all (totally transparent)
        case .unfilled: return stroke.withAlphaComponent(0.0)
        }
    }
    
    ///
    /// Get UIBezierPath for a "squiggle" shape that fits inside the given rect.
    /// The path will contain a small margin/padding space.
    ///
    private func squigglePath(in rect: CGRect) -> UIBezierPath {
        
        // ************************************
        // **** NOTE: *************************
        // Path for squiggle retrieved from:
        // https://stackoverflow.com/questions/25387940
        // TODO: Eventually revisit this implementation and come up with one in my own.
        // ************************************
        // ************************************
        
        let margin = min(rect.size.width, rect.size.height) * shapeMargin
        let drawingRect = rect.insetBy(dx: margin, dy: margin)
        
        let path = UIBezierPath()
        var point, cp1, cp2: CGPoint

        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.05, y: drawingRect.origin.y + drawingRect.size.height*0.40)
        path.move(to: point)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.35, y: drawingRect.origin.y + drawingRect.size.height*0.25)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.09, y: drawingRect.origin.y + drawingRect.size.height*0.15)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.18, y: drawingRect.origin.y + drawingRect.size.height*0.10)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.75, y: drawingRect.origin.y + drawingRect.size.height*0.30)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.40, y: drawingRect.origin.y + drawingRect.size.height*0.30)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.60, y: drawingRect.origin.y + drawingRect.size.height*0.45)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.97, y: drawingRect.origin.y + drawingRect.size.height*0.35)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.87, y: drawingRect.origin.y + drawingRect.size.height*0.15)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.98, y: drawingRect.origin.y + drawingRect.size.height*0.00)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.45, y: drawingRect.origin.y + drawingRect.size.height*0.85)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.95, y: drawingRect.origin.y + drawingRect.size.height*1.10)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.50, y: drawingRect.origin.y + drawingRect.size.height*0.95)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.25, y: drawingRect.origin.y + drawingRect.size.height*0.85)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.40, y: drawingRect.origin.y + drawingRect.size.height*0.80)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.35, y: drawingRect.origin.y + drawingRect.size.height*0.75)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        
        point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.05, y: drawingRect.origin.y + drawingRect.size.height*0.40)
        cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.00, y: drawingRect.origin.y + drawingRect.size.height*1.10)
        cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.005, y: drawingRect.origin.y + drawingRect.size.height*0.60)
        path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
        return path
    }
}
