//
//  CustomUILabel.swift
//  HSE-AI-TicTacToe
//
//  Created by Богдан Полыгалов on 26.10.2023.
//

import UIKit

final class CustomUILabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: rect.inset(by: insets))
    }
}
