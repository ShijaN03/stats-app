//
//  TopVisitorsView.swift
//  StatisticsTestTask
//
//  Created by shijan on 20.12.2025.
//

import UIKit
import PinLayout
import StatBusinessLogic

class TopVisitorsView: View {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Чаще всех посещают Ваш профиль"
        label.font = .gilroy(size: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let row1 = UserRowView()
    private let row2 = UserRowView()
    private let row3 = UserRowView()
    
    override func setupContent() {
        addSubview(titleLabel)
        addSubview(cardContainer)
        cardContainer.addSubview(row1)
        cardContainer.addSubview(row2)
        cardContainer.addSubview(row3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.pin
            .top()
            .left(20)
            .right(20)
            .sizeToFit()
        
        cardContainer.pin
            .below(of: titleLabel)
            .marginTop(16)
            .left(20)
            .right(20)
            .bottom()
            .marginBottom(-8)
        
        row1.pin
            .top(16)
            .left(16)
            .right(16)
            .height(60)
        
        row2.pin
            .below(of: row1)
            .marginTop(8)
            .left(16)
            .right(16)
            .height(60)
        
        row3.pin
            .below(of: row2)
            .marginTop(8)
            .left(16)
            .right(16)
            .height(60)
    }
    
    func configure(with users: [User]) {
        let rows = [row1, row2, row3]
        for (index, row) in rows.enumerated() {
            if index < users.count {
                row.configure(with: users[index])
                row.isHidden = false
            } else {
                row.isHidden = true
            }
        }
    }
}

class UserRowView: View {
    
    private let avatarView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let onlineIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(size: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let arrowView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrow_right")
        view.tintColor = .systemGray3
        return view
    }()
    
    override func setupContent() {
        addSubview(avatarView)
        addSubview(onlineIndicator)
        addSubview(nameLabel)
        addSubview(arrowView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.pin
            .left()
            .vCenter()
            .size(50)
        
        onlineIndicator.pin
            .bottom(to: avatarView.edge.bottom)
            .right(to: avatarView.edge.right)
            .size(14)
        
        nameLabel.pin
            .after(of: avatarView)
            .marginLeft(12)
            .vCenter()
            .sizeToFit()
        
        arrowView.pin
            .right()
            .vCenter()
            .width(12)
            .height(20)
    }
    
    func configure(with user: User) {
        nameLabel.text = "\(user.username), \(user.age)"
        nameLabel.textColor = .black
        onlineIndicator.backgroundColor = user.isOnline ? .systemGreen : .systemGray
        
        if let avatarURL = user.files.first?.url, let url = URL(string: avatarURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.avatarView.image = image
                    }
                }
            }.resume()
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
