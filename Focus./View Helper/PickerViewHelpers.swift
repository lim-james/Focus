//
//  PickerViewHelpers.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 9
        case 1: return 1
        case 2: return 60
        case 3: return 1
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component % 2 != 0 {
            return 30
        }
        return 45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize * 2)
        label.textColor = .white
        label.text = "\(row)"
        label.textAlignment = .right
        if component % 2 != 0 {
            label.font = UIFont(name: label.font.familyName, size: label.font.pointSize * 0.75)
            label.textAlignment = .left
            label.text = component == 1 ? "h" : "m"
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateTime()
    }
}
