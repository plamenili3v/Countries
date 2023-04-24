//
//  LoadViewFromXibParentView.swift
//  Countries
//
//  Created by Plamen I. Iliev on 21.04.23.
//  Copyright © 2023 Plamen I. Iliev. All rights reserved.
//

import UIKit

@IBDesignable open class LoadViewFromXibParentView: UIView {
    open var view:UIView!
    
    //MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    //MARK: - Load nib method
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NSStringFromClass(type(of: self)).components(separatedBy: ".")[1], bundle: bundle)
        let view1 = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view1
    }
}
