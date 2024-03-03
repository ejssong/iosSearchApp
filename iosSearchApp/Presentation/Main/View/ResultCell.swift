//
//  ResultCell.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit
import SDWebImage

class ResultCell: UITableViewCell {
    static let identifier = "ResultCell"
    
    var containerView = UIView()
    
    var thumbImage = UIImageView().then{
        $0.layer.masksToBounds = true
    }
    
    var detailView = UIView()
    
    var stackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    var title = UILabel().then{
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .black
    }
    
    var subTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .gray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        thumbImage.layer.cornerRadius = thumbImage.frame.size.height / 2
    }
    
    override func prepareForReuse() {
        thumbImage.image = nil
        subTitle.text    = ""
        title.text       = ""
    }
    
    func commonInit() {
        selectionStyle = .none
        setUI()
        setConstraint()
    }
    
    func setUI() {
        [containerView].forEach(contentView.addSubview(_:))
        [thumbImage, detailView].forEach(containerView.addSubview(_:))
        detailView.addSubview(stackView)
        [title, subTitle].forEach(stackView.addArrangedSubview(_:))
    }
    
    func setConstraint() {
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(16)
        }
        
        thumbImage.snp.makeConstraints{
            $0.top.left.bottom.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        detailView.snp.makeConstraints{
            $0.left.equalTo(thumbImage.snp.right).offset(10)
            $0.top.bottom.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints{
            $0.left.right.centerY.equalToSuperview()
        }
    }
    
    func setModel(of model: ResultItem) {
        thumbImage.sd_setImage(with: URL(string: model.owner?.avatar ?? ""))
        title.text = model.name
        subTitle.text = model.owner?.login
    }
}
