//
//  GenderAgeView.swift
//  StatisticsTestTask
//
//  Created by shijan on 20.12.2025.
//

import UIKit
import DGCharts
import PinLayout
import StatBusinessLogic

class GenderAgeView: View {
    
    private var allUsers: [User] = []
    private var filteredUsers: [User] = []
    private var selectedIndex: Int = 3
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пол и возраст"
        label.font = .gilroy(size: 20, weight: .bold)
        label.textColor = .mainTextColor
        return label
    }()
    
    private let btnToday: UIButton = {
        let btn = UIButton()
        btn.setTitle("Сегодня", for: .normal)
        btn.titleLabel?.font = .gilroy(size: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let btnWeek: UIButton = {
        let btn = UIButton()
        btn.setTitle("Неделя", for: .normal)
        btn.titleLabel?.font = .gilroy(size: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let btnMonth: UIButton = {
        let btn = UIButton()
        btn.setTitle("Месяц", for: .normal)
        btn.titleLabel?.font = .gilroy(size: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let btnAllTime: UIButton = {
        let btn = UIButton()
        btn.setTitle("Все время", for: .normal)
        btn.titleLabel?.font = .gilroy(size: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .moduleBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let pieChartView: PieChartView = {
        let chart = PieChartView()
        chart.holeRadiusPercent = 0.7
        chart.transparentCircleRadiusPercent = 0
        chart.legend.enabled = false
        chart.drawEntryLabelsEnabled = false
        chart.rotationEnabled = false
        return chart
    }()
    
    private let menLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(size: 14, weight: .medium)
        label.textColor = .mainTextColor
        return label
    }()
    
    private let womenLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(size: 14, weight: .medium)
        label.textColor = .mainTextColor
        return label
    }()
    
    private let menDot: UIView = {
        let view = UIView()
        view.backgroundColor = .mainThemeOrange
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let womenDot: UIView = {
        let view = UIView()
        view.backgroundColor = .mainThemeLightOrange
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let row1 = AgeRowView()
    private let row2 = AgeRowView()
    private let row3 = AgeRowView()
    private let row4 = AgeRowView()
    private let row5 = AgeRowView()
    private let row6 = AgeRowView()
    private let row7 = AgeRowView()
    
    override func setupContent() {
        addSubview(titleLabel)
        addSubview(btnToday)
        addSubview(btnWeek)
        addSubview(btnMonth)
        addSubview(btnAllTime)
        addSubview(cardContainer)
        cardContainer.addSubview(pieChartView)
        cardContainer.addSubview(menDot)
        cardContainer.addSubview(menLabel)
        cardContainer.addSubview(womenDot)
        cardContainer.addSubview(womenLabel)
        cardContainer.addSubview(row1)
        cardContainer.addSubview(row2)
        cardContainer.addSubview(row3)
        cardContainer.addSubview(row4)
        cardContainer.addSubview(row5)
        cardContainer.addSubview(row6)
        cardContainer.addSubview(row7)
        
        btnToday.addTarget(self, action: #selector(todayTapped), for: .touchUpInside)
        btnWeek.addTarget(self, action: #selector(weekTapped), for: .touchUpInside)
        btnMonth.addTarget(self, action: #selector(monthTapped), for: .touchUpInside)
        btnAllTime.addTarget(self, action: #selector(allTimeTapped), for: .touchUpInside)
        
        updateButtonStyles()
    }
    
    @objc private func todayTapped() {
        selectedIndex = 0
        updateButtonStyles()
        applyFilter()
        updatePieChart()
        updateAgeRows()
    }
    
    @objc private func weekTapped() {
        selectedIndex = 1
        updateButtonStyles()
        applyFilter()
        updatePieChart()
        updateAgeRows()
    }
    
    @objc private func monthTapped() {
        selectedIndex = 2
        updateButtonStyles()
        applyFilter()
        updatePieChart()
        updateAgeRows()
    }
    
    @objc private func allTimeTapped() {
        selectedIndex = 3
        updateButtonStyles()
        applyFilter()
        updatePieChart()
        updateAgeRows()
    }
    
    private func updateButtonStyles() {
        let buttons = [btnToday, btnWeek, btnMonth, btnAllTime]
        for (index, btn) in buttons.enumerated() {
            if index == selectedIndex {
                btn.backgroundColor = .mainThemeOrange
                btn.setTitleColor(.white, for: .normal)
                btn.layer.borderWidth = 0
            } else {
                btn.backgroundColor = .clear
                btn.setTitleColor(.black, for: .normal)
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor.systemGray4.cgColor
            }
        }
    }
    
    private func applyFilter() {
        switch selectedIndex {
        case 0:
            filteredUsers = Array(allUsers.prefix(1))
        case 1:
            filteredUsers = Array(allUsers.prefix(2))
        case 2:
            filteredUsers = Array(allUsers.prefix(3))
        default:
            filteredUsers = allUsers
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.pin
            .top()
            .left(20)
            .sizeToFit()
        
        let buttonWidth = (bounds.width - 40 - 24) / 4
        
        btnToday.pin
            .below(of: titleLabel)
            .marginTop(16)
            .left(20)
            .width(buttonWidth)
            .height(40)
        
        btnWeek.pin
            .top(to: btnToday.edge.top)
            .after(of: btnToday)
            .marginLeft(8)
            .width(buttonWidth)
            .height(40)
        
        btnMonth.pin
            .top(to: btnToday.edge.top)
            .after(of: btnWeek)
            .marginLeft(8)
            .width(buttonWidth)
            .height(40)
        
        btnAllTime.pin
            .top(to: btnToday.edge.top)
            .after(of: btnMonth)
            .marginLeft(8)
            .width(buttonWidth)
            .height(40)
        
        cardContainer.pin
            .below(of: btnToday)
            .marginTop(16)
            .left(20)
            .right(20)
            .bottom()
        
        pieChartView.pin
            .top(20)
            .hCenter()
            .size(180)
        
        menDot.pin
            .below(of: pieChartView)
            .marginTop(16)
            .left(40)
            .size(10)
        
        menLabel.pin
            .after(of: menDot)
            .marginLeft(8)
            .vCenter(to: menDot.edge.vCenter)
            .sizeToFit()
        
        womenDot.pin
            .vCenter(to: menDot.edge.vCenter)
            .after(of: menLabel)
            .marginLeft(30)
            .size(10)
        
        womenLabel.pin
            .after(of: womenDot)
            .marginLeft(8)
            .vCenter(to: womenDot.edge.vCenter)
            .sizeToFit()
        
        let rows = [row1, row2, row3, row4, row5, row6, row7]
        var previousView: UIView = menDot
        
        for row in rows {
            row.pin
                .below(of: previousView)
                .marginTop(8)
                .left(16)
                .right(16)
                .height(32)
            previousView = row
        }
    }
    
    func configure(with users: [User]) {
        self.allUsers = users
        applyFilter()
        updatePieChart()
        updateAgeRows()
    }
    
    private func updateAgeRows() {
        let ageRanges = [
            ("18-21", 18, 21),
            ("22-25", 22, 25),
            ("26-30", 26, 30),
            ("31-35", 31, 35),
            ("36-40", 36, 40),
            ("40-50", 40, 50),
            (">50", 51, 100)
        ]
        
        let rows = [row1, row2, row3, row4, row5, row6, row7]
        let total = max(filteredUsers.count, 1)
        
        for (index, (label, minAge, maxAge)) in ageRanges.enumerated() {
            let menCount = filteredUsers.filter { $0.sex == "M" && $0.age >= minAge && $0.age <= maxAge }.count
            let womenCount = filteredUsers.filter { $0.sex == "W" && $0.age >= minAge && $0.age <= maxAge }.count
            let menPercent = Int((Double(menCount) / Double(total)) * 100)
            let womenPercent = Int((Double(womenCount) / Double(total)) * 100)
            
            rows[index].configure(label: label, menPercent: menPercent, womenPercent: womenPercent)
        }
    }
    
    private func updatePieChart() {
        let menCount = filteredUsers.filter { $0.sex == "M" }.count
        let womenCount = filteredUsers.filter { $0.sex == "W" }.count
        let total = Double(menCount + womenCount)
        
        guard total > 0 else {
            menLabel.text = "Мужчины 0%"
            womenLabel.text = "Женщины 0%"
            pieChartView.data = nil
            setNeedsLayout()
            return
        }
        
        let menPercent = Int((Double(menCount) / total) * 100)
        let womenPercent = 100 - menPercent
        
        menLabel.text = "Мужчины \(menPercent)%"
        womenLabel.text = "Женщины \(womenPercent)%"
        
        let entries = [
            PieChartDataEntry(value: Double(menCount)),
            PieChartDataEntry(value: Double(womenCount))
        ]
        
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [.mainThemeOrange, .mainThemeLightOrange]
        dataSet.drawValuesEnabled = false
        dataSet.sliceSpace = 2
        
        pieChartView.data = PieChartData(dataSet: dataSet)
        setNeedsLayout()
    }
}

class AgeRowView: View {
    
    private let rangeLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(size: 14, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let menBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainThemeOrange
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let menPercentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let womenBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainThemeLightOrange
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let womenPercentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private var menPercent: Int = 0
    private var womenPercent: Int = 0
    
    override func setupContent() {
        addSubview(rangeLabel)
        addSubview(menBar)
        addSubview(menPercentLabel)
        addSubview(womenBar)
        addSubview(womenPercentLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxBarWidth: CGFloat = 100
        
        rangeLabel.pin
            .left()
            .top()
            .width(50)
            .sizeToFit(.width)
        
        menBar.pin
            .after(of: rangeLabel)
            .marginLeft(12)
            .top(2)
            .width(max(4, CGFloat(menPercent) / 100 * maxBarWidth))
            .height(6)
        
        menPercentLabel.pin
            .after(of: menBar)
            .marginLeft(4)
            .vCenter(to: menBar.edge.vCenter)
            .sizeToFit()
        
        womenBar.pin
            .after(of: rangeLabel)
            .marginLeft(12)
            .below(of: menBar)
            .marginTop(6)
            .width(max(4, CGFloat(womenPercent) / 100 * maxBarWidth))
            .height(6)
        
        womenPercentLabel.pin
            .after(of: womenBar)
            .marginLeft(4)
            .vCenter(to: womenBar.edge.vCenter)
            .sizeToFit()
    }
    
    func configure(label: String, menPercent: Int, womenPercent: Int) {
        rangeLabel.text = label
        self.menPercent = menPercent
        self.womenPercent = womenPercent
        menPercentLabel.text = "\(menPercent)%"
        womenPercentLabel.text = "\(womenPercent)%"
        setNeedsLayout()
    }
}
