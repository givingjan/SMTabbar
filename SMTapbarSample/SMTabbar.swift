//
//  SMTabbar.swift
//
//  Created by JaN on 2017/2/13.
//  Copyright © 2017年 Yu-Chun-Chen. All rights reserved.
//

import UIKit

class SMTabbar: UIScrollView {
    enum LinePosition  {
        case bottom
        case top
    }
    // MARK: Public Member Variables
    var padding : CGFloat = 0.0
    var extraConstant : CGFloat = 40.0 
    var buttonWidth : CGFloat = 52.0 {
        didSet {
            if buttonWidth < 1 {
                buttonWidth = oldValue
            }
        }
    }
    
    var lineHeight : CGFloat = 1.0 {
        didSet {
            if lineHeight < 1 {
                lineHeight = oldValue
            }
        }
    }
    
    var lineWidth : CGFloat = 10.0
    
    var lineYoffset : CGFloat = -5.0
    
    var moveDuration : CGFloat = 0.3 {
        didSet {
            if moveDuration < 0.01 {
                moveDuration = oldValue
            }
        }
    }
    
    var fontSize : CGFloat = 12.0 {
        didSet {
            if fontSize < 8 {
                fontSize = oldValue
            }
        }
    }
    
    var buttonTitlefont : UIFont?
    
    var linePosition : LinePosition = .bottom
    var fontColor : UIColor = .black
    var lineColor : UIColor = .black
    var buttonBackgroundColor : UIColor = .white
    
    // MARK: Private Member Variables
    private var m_aryButtons : [UIButton] = []
    private var m_aryTitleList : [String] = []
    private var m_layerLine : CALayer = CALayer()
    private var m_completionHandler : ((_ index : Int)->(Void))?
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: Public Methods
    
    func configureSMTabbar(titleList : [String], completionHandler :@escaping ((_ index : Int)->(Void))){
        self.m_completionHandler = completionHandler
        self.m_aryTitleList = titleList
        self.initScrollView()
        self.addButtons()
        self.initLineLayer()
    }
    
    func selectTab(index : NSInteger) {
        guard self.m_aryButtons.count > 0 else {
            return
        }
        
        let sender = self.m_aryButtons[index]
        
        // deselected all buttons.
        self.deselectedButtons()
        
        sender.isSelected = true
        
        let target_x = sender.frame.origin.x
        
        self.m_layerLine.frame = CGRect(x: target_x + (self.buttonWidth/2) - (self.lineWidth/2), y: self.m_layerLine.frame.origin.y, width: self.lineWidth, height: self.lineHeight)
        
        if self.contentOffset.x + self.frame.width < target_x + self.buttonWidth {
            let extraMove : CGFloat = sender.tag == self.m_aryTitleList.count - 1 ? 0 : self.extraConstant
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentOffset.x = target_x + self.padding + self.buttonWidth - self.frame.width + extraMove
            })
        } else if self.contentOffset.x > target_x {
            let extraMove : CGFloat = sender.tag == 0 ? 0 : self.extraConstant
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentOffset.x = target_x - self.padding - extraMove
            })
        }
        
        self.animateSelected(sender)
        
        if self.m_completionHandler != nil {
            self.m_completionHandler!(sender.tag)
        }
    }
    
    // MARK: Private Methods
    private func initScrollView() {
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    private func initLineLayer() {
        let y : CGFloat = self.linePosition == .bottom ? self.frame.height - self.lineHeight + self.lineYoffset : 0 + self.lineYoffset
        self.m_layerLine.frame = CGRect(x: padding + (self.buttonWidth/2) - (self.lineWidth/2), y: y, width: self.lineWidth, height: self.lineHeight)
        self.m_layerLine.backgroundColor = self.lineColor.cgColor
        self.m_layerLine.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(self.m_layerLine)
    }
    
    private func deselectedButtons() {
        for btn in self.m_aryButtons {
            btn.isSelected = false
        }
    }
    
    private func addButtons() {
        var x : CGFloat = 0.0
        let y : CGFloat = self.linePosition == .bottom ? 0 : self.lineHeight
        
        for (index,title) in (self.m_aryTitleList.enumerated()) {
            x = CGFloat(index) * self.buttonWidth
            
            let btn : UIButton = UIButton(type: .custom)
            btn.tag = index
            btn.titleLabel?.font = self.buttonTitlefont == nil ? UIFont.systemFont(ofSize: fontSize) : self.buttonTitlefont
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(self.fontColor, for: .selected)
            btn.backgroundColor = self.buttonBackgroundColor
            btn.frame = CGRect(x: x + (padding * CGFloat(index+1)), y: y, width: self.buttonWidth, height: self.frame.height - self.lineHeight)
            btn.setTitleColor(UIColor.lightGray, for: .normal)
            btn.addTarget(self, action: #selector(SMTabbar.handleTap(_:)), for: .touchUpInside)
            
            self.m_aryButtons.append(btn)
            self.addSubview(btn)
        }
        
        self.contentSize = CGSize(width: x + self.buttonWidth + (padding * CGFloat(self.m_aryTitleList.count+1)), height: 1)
    }
    
    private func animateSelected(_ sender : UIButton) {
        let originalFrame : CGRect = sender.frame
        var frame : CGRect = sender.frame
        frame.origin.y -= 2.5
        
        UIView.animate(withDuration: 0.2, animations: { 
            sender.frame = frame
        }) { (isDone) in
            UIView.animate(withDuration: 0.2, animations: { 
                sender.frame = originalFrame
            })
        }
    }
    
    // MARK: Handle Action
    @objc fileprivate func handleTap(_ sender : UIButton) {
        self.selectTab(index: sender.tag)
    }
}
