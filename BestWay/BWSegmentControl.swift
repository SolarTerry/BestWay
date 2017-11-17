//
//  BWSegmentController.swift
//  BestWay
//
//  Created by solar on 17/3/27.
//  Copyright © 2017年 PigVillageStudio. All rights reserved.
//

import UIKit

// MARK: - 选中的segment下的滑动条颜色
fileprivate class BWSliderView : UIView {
    
    fileprivate var color : UIColor? {
        didSet{
            self.backgroundColor = color
        }
    }
}

// MARK: - item状态集
fileprivate enum BWItemViewState : Int {
    case Normal
    case Selected
}

// MARK: - 控制segment每一个item的view
fileprivate class BWItemView : UIView {
    
    // MARK: - 设置item宽度
    fileprivate func itemWidth() -> CGFloat {
        
        if let text = titleLabel.text {
            let string = text as NSString
            let size = string.size(attributes: [NSFontAttributeName:selectedFont!])
            return size.width + BWSegmentPattern.itemBorder
        }
        
        return 0.0
    }
    
    // MARK: - item标题
    fileprivate let titleLabel = UILabel()
    
    // MARK: - item上的小红点
    fileprivate lazy var bridgeView : CALayer = {
        let view = CALayer()
        let width = BWSegmentPattern.bridgeWidth
        view.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        view.backgroundColor = BWSegmentPattern.bridgeColor.cgColor
        view.cornerRadius = view.bounds.size.width * 0.5
        return view
    }()
    
    // MARK: - 是否显示item上的小红点
    fileprivate func showBridge(show:Bool){
        self.bridgeView.isHidden = !show
    }
    
    // MARK: - item状态
    fileprivate var state : BWItemViewState = .Normal {
        didSet{
            updateItemView(state: state)
        }
    }
    
    // MARK: - item字体
    fileprivate var font : UIFont?{
        didSet{
            if state == .Normal {
                self.titleLabel.font = font
            }
        }
    }
    // MARK: - 选中item的字体
    fileprivate var selectedFont : UIFont?{
        didSet{
            if state == .Selected {
                self.titleLabel.font = selectedFont
            }
        }
    }
    // MARK: - item标题
    fileprivate var text : String?{
        didSet{
            self.titleLabel.text = text
        }
    }
    // MARK: - item字体颜色
    fileprivate var textColor : UIColor?{
        didSet{
            if state == .Normal {
                self.titleLabel.textColor = textColor
            }
        }
    }
    // MARK: - 选中item字体颜色
    fileprivate var selectedTextColor : UIColor?{
        didSet{
            if state == .Selected {
                self.titleLabel.textColor = selectedTextColor
            }
        }
    }
    // MARK: - item背景色
    fileprivate var itemBackgroundColor : UIColor?{
        didSet{
            if state == .Normal {
                self.backgroundColor = itemBackgroundColor
            }
        }
    }
    // MARK: - 选中item背景色
    fileprivate var selectedBackgroundColor : UIColor?{
        didSet{
            if state == .Selected {
                self.backgroundColor = selectedBackgroundColor
            }
        }
    }
    // MARK: - item字体居中
    fileprivate var textAlignment = NSTextAlignment.center {
        didSet{
            self.titleLabel.textAlignment = textAlignment
        }
    }
    // MARK: - 根据item状态更新item样式
    private func updateItemView(state:BWItemViewState){
        switch state {
        case .Normal:
            self.titleLabel.font = self.font
            self.titleLabel.textColor = self.textColor
            self.backgroundColor = self.itemBackgroundColor
        case .Selected:
            self.titleLabel.font = selectedFont
            self.titleLabel.textColor = self.selectedTextColor
            self.backgroundColor = self.selectedBackgroundColor
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        bridgeView.isHidden = true
        layer.addSublayer(bridgeView)
        layer.masksToBounds = true
    }
    
    fileprivate override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.center.x = bounds.size.width * 0.5
        titleLabel.center.y = bounds.size.height * 0.5
        let width = bridgeView.bounds.size.width
        let x:CGFloat = titleLabel.frame.maxX
        bridgeView.frame = CGRect(x: x, y: bounds.midY - width, width: width, height: width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc public protocol BWSegmentControlDelegate {
    @objc optional func didSelected(segement:BWSegmentControl, index: Int)
}

open class BWSegmentControl: UIControl {
    
    fileprivate struct Constants {
        static let height : CGFloat = 40.0
    }
    
    open weak var delegate : BWSegmentControlDelegate?
    
    open var autoAdjustWidth = false {
        didSet{
            
        }
    }
    
    //recomend to use segmentWidth(index:Int)
    open func segementWidth() -> CGFloat {
        return bounds.size.width / (CGFloat)(itemViews.count)
    }
    //when autoAdjustWidth is true, the width is not necessarily the same
    open func segmentWidth(index:Int) -> CGFloat {
        guard index >= 0 && index < itemViews.count else {
            return 0.0
        }
        if autoAdjustWidth {
            return itemViews[index].itemWidth()
        }else{
            return segementWidth()
        }
    }
    
    open var selectedIndex = 0 {
        willSet{
            let originItem = self.itemViews[selectedIndex]
            originItem.state = .Normal
            
            let selectItem = self.itemViews[newValue]
            selectItem.state = .Selected
        }
    }
    
    // MARK: - 未选中字体颜色
    open var itemTextColor = BWSegmentPattern.itemTextColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.textColor = itemTextColor
            }
        }
    }
    
    // MARK: - 选中字体颜色
    open var itemSelectedTextColor = BWSegmentPattern.itemSelectedTextColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedTextColor = itemSelectedTextColor
            }
        }
    }
    
    // MARK: - 未选中背景颜色
    open var itemBackgroundColor = BWSegmentPattern.itemBackgroundColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.itemBackgroundColor = itemBackgroundColor
            }
        }
    }
    
    // MARK: - 选中背景颜色
    open var itemSelectedBackgroundColor = BWSegmentPattern.itemSelectedBackgroundColor{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedBackgroundColor = itemSelectedBackgroundColor
            }
        }
    }
    
    // MARK: - 滑动条颜色
    open var sliderViewColor = BWSegmentPattern.sliderColor{
        didSet{
            self.sliderView.color = sliderViewColor
        }
    }
    
    // MARK: - 未选中字体
    open var font = BWSegmentPattern.textFont{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.font = font
            }
        }
    }
    
    // MARK: - 选中字体
    open var selectedFont = BWSegmentPattern.selectedTextFont{
        didSet{
            self.itemViews.forEach { (itemView) in
                itemView.selectedFont = selectedFont
            }
        }
    }
    
    // MARK: - 每个单元
    open var items : [String]?{
        didSet{
            guard items != nil && items!.count > 0 else {
                fatalError("Items cannot be empty")
            }
            
            self.removeAllItemView()
            
            for title in items! {
                let view = self.createItemView(title: title)
                self.itemViews.append(view)
                self.contentView.addSubview(view)
            }
            self.selectedIndex = 0
            
            self.contentView.bringSubview(toFront: self.sliderView)
        }
    }
    
    // MARK: - 显示小圆点
    open func showBridge(show:Bool, index:Int){
        guard index < itemViews.count && index >= 0 else {
            return
        }
        itemViews[index].showBridge(show: show)
    }
    
    //when true, scrolled the itemView to a point when index changed
    open var autoScrollWhenIndexChange = true
    
    open var scrollToPointWhenIndexChanged = CGPoint(x: 0.0, y: 0.0)
    
    open var bounces = false {
        didSet{
            self.scrollView.bounces = bounces
        }
    }
    
    // MARK: - 去除所有单元
    fileprivate func removeAllItemView() {
        itemViews.forEach { (label) in
            label.removeFromSuperview()
        }
        itemViews.removeAll()
    }
    
    // MARK: - 单元格宽度
    private var itemWidths = [CGFloat]()
    
    // MARK: - 创建默认单元格
    private func createItemView(title:String) -> BWItemView {
        return createItemView(title: title,
                              font: self.font,
                              selectedFont: self.selectedFont,
                              textColor: self.itemTextColor,
                              selectedTextColor: self.itemSelectedTextColor,
                              backgroundColor: self.itemBackgroundColor,
                              selectedBackgroundColor: self.itemSelectedBackgroundColor
        )
    }
    
    // MARK: - 创建自定义单元格
    private func createItemView(title:String, font:UIFont, selectedFont:UIFont, textColor:UIColor, selectedTextColor:UIColor, backgroundColor:UIColor, selectedBackgroundColor:UIColor) -> BWItemView {
        let item = BWItemView()
        item.text = title
        item.textColor = textColor
        item.textAlignment = .center
        item.font = font
        item.selectedFont = selectedFont
        item.itemBackgroundColor = backgroundColor
        item.selectedTextColor = selectedTextColor
        item.selectedBackgroundColor = selectedBackgroundColor
        item.state = .Normal
        return item
    }
    
    // MARK: - 滚动view
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    // MARK: - 内容view
    fileprivate lazy var contentView = UIView()
    
    // MARK: - 滑动条
    fileprivate lazy var sliderView : BWSliderView = BWSliderView()
    
    // MARK: - 单元格
    fileprivate var itemViews = [BWItemView]()
    
    // MARK: - 单元格数量
    fileprivate var numberOfSegments : Int {
        return itemViews.count
    }
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        scrollToPointWhenIndexChanged = scrollView.center
    }
    
    // MARK: - 初始化
    fileprivate func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(sliderView)
        sliderView.color = sliderViewColor
        scrollView.frame = bounds
        contentView.frame = scrollView.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSegement(tapGesture:)))
        
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapSegement(tapGesture:UITapGestureRecognizer) {
        let index = selectedTargetIndex(gesture: tapGesture)
        move(to: index)
    }
    
    open func move(to index:Int){
        move(to: index, animated: true)
    }
    
    open func move(to index:Int, animated:Bool) {
        
        let position = centerX(with: index)
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.sliderView.center.x = position
                self.sliderView.bounds = CGRect(x: 0.0, y: 0.0, width: self.segmentWidth(index: index), height: self.sliderView.bounds.height)
            })
        }else{
            self.sliderView.center.x = position
            self.sliderView.bounds = CGRect(x: 0.0, y: 0.0, width: self.segmentWidth(index: index), height: self.sliderView.bounds.height)
        }
        
        delegate?.didSelected?(segement: self, index: index)
        selectedIndex = index
        
        if autoScrollWhenIndexChange {
            scrollItemToPoint(index: index, point: scrollToPointWhenIndexChanged)
        }
    }
    
    fileprivate func currentItemX(index:Int) -> CGFloat {
        if autoAdjustWidth {
            var x:CGFloat = 0.0
            for i in 0..<index {
                x += segmentWidth(index: i)
            }
            return x
        }
        return segementWidth() * CGFloat(index)
    }
    
    fileprivate func centerX(with index:Int) -> CGFloat {
        if autoAdjustWidth {
            return currentItemX(index: index) + segmentWidth(index: index)*0.5
        }
        return (CGFloat(index) + 0.5)*segementWidth()
    }
    
    private func selectedTargetIndex(gesture: UIGestureRecognizer) -> Int {
        let location = gesture.location(in: contentView)
        var index = 0
        
        if autoAdjustWidth {
            for (i,itemView) in itemViews.enumerated() {
                if itemView.frame.contains(location) {
                    index = i
                    break
                }
            }
        }else{
            index = Int(location.x / sliderView.bounds.size.width)
        }
        
        if index < 0 {
            index = 0
        }
        if index > numberOfSegments - 1 {
            index = numberOfSegments - 1
        }
        return index
    }
    
    private func scrollItemToCenter(index : Int) {
        scrollItemToPoint(index: index, point: CGPoint(x: scrollView.bounds.size.width * 0.5, y: 0))
    }
    
    private func scrollItemToPoint(index : Int,point:CGPoint) {
        
        let currentX = currentItemX(index: index)
        
        let scrollViewWidth = scrollView.bounds.size.width
        
        var scrollX = currentX - point.x + segmentWidth(index: index) * 0.5
        
        let maxScrollX = scrollView.contentSize.width - scrollViewWidth
        
        if scrollX > maxScrollX {
            scrollX = maxScrollX
        }
        if scrollX < 0.0 {
            scrollX = 0.0
        }
        
        scrollView.setContentOffset(CGPoint(x: scrollX, y: 0.0), animated: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard itemViews.count > 0 else {
            return
        }
        
        var x:CGFloat = 0.0
        let y:CGFloat = 0.0
        var width:CGFloat = segmentWidth(index: selectedIndex)
        let height:CGFloat = bounds.size.height
        
        sliderView.frame = CGRect(x: currentItemX(index: selectedIndex), y: contentView.bounds.size.height - BWSegmentPattern.sliderHeight, width: width, height: BWSegmentPattern.sliderHeight)
        
        var contentWidth:CGFloat = 0.0
        
        for (index,item) in itemViews.enumerated() {
            x = contentWidth
            width = segmentWidth(index: index)
            item.frame = CGRect(x: x, y: y, width: width, height: height)
            
            contentWidth += width
        }
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: contentWidth, height: contentView.bounds.height)
        scrollView.contentSize = contentView.bounds.size
    }
}
