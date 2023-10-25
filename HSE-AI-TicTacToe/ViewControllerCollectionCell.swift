//
//  ViewControllerCollectionCell.swift
//  HSE-AI-TicTacToe
//
//  Created by Богдан Полыгалов on 25.10.2023.
//

import UIKit

final class ViewControllerCollectionCell: UICollectionViewCell, ReuseIdentifying {
    var viewController: ViewController?
    var indexOfCell: Int?

    private let cellButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cellButtonTap), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(cellButton)
        NSLayoutConstraint.activate([
            cellButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func removeImage() {
        cellButton.setImage(nil, for: .normal)
    }

    @objc func cellButtonTap() {
        guard let gameModel = viewController?.gameModel,
              let indexOfCell = indexOfCell else { return }
        if cellButton.image(for: .normal) == nil && gameModel.winner == nil {
            // Делаем ход
            switch gameModel.activePlayer {
            case .first:
                cellButton.setImage(UIImage(named: "FirstPlayer"), for: .normal)
                gameModel.addCellInSet(cellIndex: indexOfCell, player: .first)
            case .second:
                cellButton.setImage(UIImage(named: "SecondPlayer"), for: .normal)
                gameModel.addCellInSet(cellIndex: indexOfCell, player: .second)
            }

            // Меняем игрока
            gameModel.activePlayer = gameModel.activePlayer == .first ? .second : .first

            let firstPlayerCells = gameModel.takeCellsSet(for: .first)
            let secondPlayerCells = gameModel.takeCellsSet(for: .second)
            
            // Проверяем победу
            if gameModel.checkWin(for: firstPlayerCells) {
                gameModel.winner = .first
                viewController?.setWinnerLabel(player: .first)
            }
            if gameModel.checkWin(for: secondPlayerCells) {
                gameModel.winner = .second
                viewController?.setWinnerLabel(player: .second)
            }

            // Проверяем ничью
            if firstPlayerCells.count + secondPlayerCells.count == 9 && gameModel.winner == nil {
                viewController?.setWinnerLabel(player: nil)
            }

            // Даём ход компьютеру
            if gameModel.activePlayer == .second && gameModel.winner == nil  {
                viewController?.secondPlayerMove(index: gameModel.minimax(firstPlayerCells: firstPlayerCells, secondPlayerCells: secondPlayerCells, player: .second, depth: 0))
            }
        }
    }
}
