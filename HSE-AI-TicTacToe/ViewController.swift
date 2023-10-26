//
//  ViewController.swift
//  HSE-AI-TicTacToe
//
//  Created by Богдан Полыгалов on 25.10.2023.
//

import UIKit

final class ViewController: UIViewController {
    private let winnerLabel = CustomUILabel()
    private let fieldCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let restartButton = UIButton()

    let gameModel = GameModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        configureWinnerLabel()
        configureFieldCollection()
        configureRestartButton()
        gameModel.startGame()
    }
    
    private func configureWinnerLabel() {
        winnerLabel.backgroundColor = .white
        winnerLabel.textColor = .black
        winnerLabel.text = "Победитель:"
        winnerLabel.font = UIFont.systemFont(ofSize: 20)
        winnerLabel.layer.cornerRadius = 8
        winnerLabel.layer.masksToBounds = true
        winnerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(winnerLabel)
        NSLayoutConstraint.activate([
            winnerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            winnerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            winnerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            winnerLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func configureFieldCollection() {
        fieldCollection.backgroundColor = .clear
        fieldCollection.dataSource = self
        fieldCollection.delegate = self
        fieldCollection.register(ViewControllerCollectionCell.self)
        fieldCollection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fieldCollection)
        NSLayoutConstraint.activate([
            fieldCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fieldCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fieldCollection.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 20),
            fieldCollection.heightAnchor.constraint(equalToConstant: (view.frame.width - 32) + 48)
        ])
    }

    private func configureRestartButton() {
        restartButton.backgroundColor = .white
        restartButton.setTitle("Заново", for: .normal)
        restartButton.setTitleColor(.black, for: .normal)
        restartButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        restartButton.layer.cornerRadius = 8
        restartButton.layer.masksToBounds = true
        restartButton.addTarget(self, action: #selector(restartButtonTap), for: .touchUpInside)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(restartButton)
        NSLayoutConstraint.activate([
            restartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            restartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            restartButton.topAnchor.constraint(equalTo: fieldCollection.bottomAnchor)
        ])
    }

    func secondPlayerMove(index: Int) {
        let cell: ViewControllerCollectionCell = fieldCollection.cellForItem(at: IndexPath(row: index, section: 0))
        cell.cellButtonTap()
    }
    
    func setWinnerLabel(player: Player?) {
        switch player {
        case .first:
            winnerLabel.text = "Победитель: Вы"
            winnerLabel.textColor = .systemBlue
        case .second:
            winnerLabel.text = "Победитель: Компьютер"
            winnerLabel.textColor = .red
        case nil:
            winnerLabel.text = "Победитель: Никто"
        }
    }
    
    private func clearLabel() {
        winnerLabel.text = "Победитель:"
        winnerLabel.textColor = .black
    }
    
    private func removeImagesInCollection() {
        for cell in fieldCollection.visibleCells {
            guard let cell = cell as? ViewControllerCollectionCell else { return }
            cell.removeImage()
        }
    }
    
    @objc private func restartButtonTap() {
        removeImagesInCollection()
        clearLabel()
        gameModel.startGame()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32) / 3 - 9
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        28
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ViewControllerCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.viewController = self
        cell.indexOfCell = indexPath.row
        return cell
    }
}
