//
//  SMTabbar.swift
//
//  Created by JaN on 2017/2/13.
//  Copyright © 2017年 Yu-Chun-Chen. All rights reserved.
//

import UIKit

class SMTabbar: UIScrollView {
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
    
    var underLineHeight : CGFloat = 4.0 {
        didSet {
            if underLineHeight < 1 {
                underLineHeight = oldValue
            }
        }
    }
    
    var moveDuration : CGFloat = 0.3 {
        didSet {
            if moveDuration < 0.01 {
                moveDuration = oldValue
            }
        }
    }
    
    var fontSize : CGFloat = 14.0 {
        didSet {
            if fontSize < 8 {
                fontSize = oldValue
            }
        }
    }
    
    var fontColor : UIColor = .black
    var underLineColor : UIColor = .orange
    var buttonBackgroundColor : UIColor = .white
    
    // MARK: Private Member Variables
    private var m_aryTitleList : [String] = []
    private var m_layerUnderline : CALayer = CALayer()
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
        self.initUnderLineLayer()
    }
    
    // MARK: Private Methods
    private func initScrollView() {
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    private func initUnderLineLayer() {
        self.m_layerUnderline.frame = CGRect(x: padding, y: self.frame.height - self.underLineHeight, width: self.buttonWidth, height: self.underLineHeight)
        self.m_layerUnderline.backgroundColor = self.underLineColor.cgColor
        self.m_layerUnderline.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(self.m_layerUnderline)
    }
    
    private func addButtons() {
        var x : CGFloat = 0.0
        
        for (index,title) in (self.m_aryTitleList.enumerated()) {
            x = CGFloat(index) * self.buttonWidth
            
            let btn : UIButton = UIButton(type: .custom)
            
            btn.tag = index
            btn.titleLabel?.font = UIFont.systemFont(ofSize: self.fontSize)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(self.fontColor, for: .normal)
            btn.backgroundColor = self.buttonBackgroundColor
            btn.frame = CGRect(x: x + (padding * CGFloat(index+1)), y: 0.0, width: self.buttonWidth, height: self.frame.height - self.underLineHeight)
            btn.addTarget(self, action: #selector(SMTabbar.handleTap(_:)), for: .touchUpInside)
            
            self.addSubview(btn)
        }
        
        self.contentSize = CGSize(width: x + self.buttonWidth + (padding * CGFloat(self.m_aryTitleList.count+1)), height: 1)
    }
    
    // MARK: Handle Action
    @objc fileprivate func handleTap(_ sender : UIButton) {
        let target_x = sender.frame.origin.x

        self.m_layerUnderline.frame = CGRect(x: target_x, y: self.m_layerUnderline.frame.origin.y, width: self.buttonWidth, height: self.underLineHeight)
        
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
        
        if self.m_completionHandler != nil {
            self.m_completionHandler!(sender.tag)
        }
    }
}
