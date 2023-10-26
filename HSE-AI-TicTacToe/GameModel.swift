//
//  GameModel.swift
//  HSE-AI-TicTacToe
//
//  Created by Богдан Полыгалов on 26.10.2023.
//

import Foundation

enum Player: String {
    case first
    case second
}

final class GameModel {
    private let winCombos = [
        Set([0, 1, 2]),
        Set([3, 4, 5]),
        Set([6, 7, 8]),
        Set([0, 3, 6]),
        Set([1, 4, 7]),
        Set([2, 5, 8]),
        Set([0, 4, 8]),
        Set([6, 4, 2])
    ]

    var winner: Player?
    var activePlayer: Player = .first
    private var firstPlayerCells: Set<Int> = []
    private var secondPlayerCells: Set<Int> = []

    func startGame() {
        activePlayer = .first
        firstPlayerCells = []
        secondPlayerCells = []
        winner = nil
    }

    func addCellInSet(cellIndex: Int, player: Player) {
        switch player {
        case .first:
            firstPlayerCells.insert(cellIndex)
        case .second:
            secondPlayerCells.insert(cellIndex)
        }
    }

    func takeCellsSet(for player: Player) -> Set<Int> {
        switch player {
        case .first:
            firstPlayerCells
        case .second:
            secondPlayerCells
        }
    }

    func checkWin(for playerCells: Set<Int>) -> Bool {
        for comb in winCombos {
            var isItWin: [Bool] = []
            for i in playerCells {
                if comb.contains(i) {
                    isItWin.append(true)
                }
            }
            if isItWin.count == 3 {
                return true
            }
        }
        return false
    }

    func minimax(firstPlayerCells: Set<Int>, secondPlayerCells: Set<Int>, player: Player, depth: Int) -> Int {
        // Первый ход случайный для разнообразия и уменьшения времени подсчёта деревьев
        if secondPlayerCells.isEmpty {
            var randomNumber: Int
            repeat {
                randomNumber = Int.random(in: 0..<9)
            } while randomNumber == firstPlayerCells.first
            return randomNumber
        }

        // Оценочная функция
        if checkWin(for: firstPlayerCells) {
            return -10 + depth // Если человек (первый игрок) победил, то наказываем компьютер -10 очками, но если человек долго пытался (глубоко ушёл по дереву) победить, то это поощрается, поскольку это потенциальная возможность выйграть
        }
        if checkWin(for: secondPlayerCells) {
            return 10 - depth // Если компьютер (второй игрок) победил, то поощряем его +10 очками, но если он к этому долго шёл (ушёл далеко по дереву), то это наказывается, поскольку соперник мог выйграть
        }
        if firstPlayerCells.count + secondPlayerCells.count == 9 { // Ничья, ни для кого нет пользы
            return 0
        }

        var result: [Int:Int] = [:]
        var bestMove: Int = 0
        var bestScore: Int = 0

        // Для каждой свободной клетки на поле
        for freeCell in 0..<9 {
            if !firstPlayerCells.contains(freeCell) && !secondPlayerCells.contains(freeCell) {

                // Предугадываем ходы соперника
                if player == .first {
                    // Предугадываем, если мы первый игрок, какой ход сделает второй

                    // Добавляем свободную клетку к клеткам первого
                    var newFirstPlayerCells = firstPlayerCells
                    newFirstPlayerCells.insert(freeCell)

                    // Записываем результат - ход:оценка
                    result[freeCell] = minimax(firstPlayerCells: newFirstPlayerCells, secondPlayerCells: secondPlayerCells, player: .second, depth: depth + 1)
                } else {
                    // Предугадываем, если мы второй игрок, какой ход сделает первый

                    // Добавляем свободную клетку к клеткам второго игрока
                    var newSecondPlayerCells = secondPlayerCells
                    newSecondPlayerCells.insert(freeCell)

                    // Записываем результат - ход:оценка
                    result[freeCell] = minimax(firstPlayerCells: firstPlayerCells, secondPlayerCells: newSecondPlayerCells, player: .first, depth: depth + 1)
                }
            }
        }

        var sortedResult = result.sorted{$0.key < $1.key}
        // Выбираем лучший ход для игрока
        if player == .first {
            // Если мы - первый игрок, то лучшим для нас ходом будет тот, у которого меньше оценка, поскольку для компьютера в такие ходы шло наказание и врятли он в нём выйграет
            bestScore = sortedResult.min{$0.value < $1.value}!.value
            bestMove = sortedResult.min{$0.value < $1.value}!.key
        } else {
            // Если мы - второй игрок, то лучшим для нас ходом будет тот, у которого больше оценка, поскольку там шло поощрение и, скорее всего, мы в нём выйграем
            bestScore = sortedResult.max{$0.value < $1.value}!.value
            bestMove = sortedResult.max{$0.value < $1.value}!.key
        }

        // Для первой итерации возвращаем лучший ход и выводим статистику
        if depth == 0 {
            print("\n\nОценки ходов:")
            print(sortedResult)
            print("\nЛучшей ход с оценкой [\(bestScore)] имеют клетки с индексом: \(detectSameValue(dictionary: result)[bestScore] ?? [])")
            return bestMove
        }
        else {
            // Для остальных итераций возвращаем оценку, чтобы она возвращалась/поднималась по дереву
            return bestScore
        }
    }

    private func detectSameValue(dictionary: [Int:Int]) -> [Int: [Int]] {
        var valueToKeysMap: [Int: [Int]] = [:]

        for (key, value) in dictionary {
            if valueToKeysMap[value] == nil {
                valueToKeysMap[value] = [key]
            } else {
                valueToKeysMap[value]?.append(key)
            }
        }

        return valueToKeysMap
    }
}
