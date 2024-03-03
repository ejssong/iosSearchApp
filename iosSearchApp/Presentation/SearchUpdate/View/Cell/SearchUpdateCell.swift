//
//  SearchUpdateCell.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit

class SearchUpdateCell: UITableViewCell {
    static let identifier = "SearchUpdateCell"
    
    var keyword = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    }
    
    var date = UILabel().then{
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        setUI()
        setConstraint()
    }
    
    func setUI() {
        [keyword, date].forEach(contentView.addSubview(_:))
    }
    
    func setConstraint() {
        keyword.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        date.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(keyword.snp.right)
            $0.right.equalToSuperview().inset(16)
        }
    }
    
    func setModel(of model: SectionListModel) {
        keyword.text = model.value
        date.text = setDate(date: model.date)
    }
    
    func setDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.string(from: date)
    }
}
