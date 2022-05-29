module Board where
import           Data.List                      ( insert )

data Cell = E | X | O deriving (Eq)


data Board = Board Cell Cell Cell Cell Cell Cell Cell Cell Cell

boardLine = "+---------+---------+---------+"

makeLines :: Cell -> Cell -> Cell -> [Char]
makeLines c1 c2 c3 =
    makeLine1 c1 c2 c3
        ++ "\n"
        ++ makeLine2 c1 c2 c3
        ++ "\n"
        ++ makeLine3 c1 c2 c3

makeLine1 :: Cell -> Cell -> Cell -> [Char]
makeLine1 c1 c2 c3 = 
    "|" ++ makePiece1 c1 ++ "|" ++ makePiece1 c2 ++ "|" ++ makePiece1 c3 ++ "|"

makeLine2 :: Cell -> Cell -> Cell -> [Char]
makeLine2 c4 c5 c6 = 
    "|" ++ makePiece2 c4 ++ "|" ++ makePiece2 c5 ++ "|" ++ makePiece2 c6 ++ "|"

makeLine3 :: Cell -> Cell -> Cell -> [Char]
makeLine3 c7 c8 c9 = 
    "|" ++ makePiece3 c7 ++ "|" ++ makePiece3 c8 ++ "|" ++ makePiece3 c9 ++ "|"

makePiece1 :: Cell -> [Char]
makePiece1 E = "         "
makePiece1 O = "  * * *  "
makePiece1 X = "    *    "

makePiece2 :: Cell -> [Char]
makePiece2 E = "         "
makePiece2 O = "  * * *  "
makePiece2 X = "  * * *  "

makePiece3 :: Cell -> [Char]
makePiece3 E = "         "
makePiece3 O = "  * * *  "
makePiece3 X = "    *    "


instance Show Board where
    show (Board c1 c2 c3 c4 c5 c6 c7 c8 c9) =
        boardLine
            ++ "\n"
            ++ makeLines c1 c2 c3
            ++ "\n"
            ++ boardLine
            ++ "\n"
            ++ makeLines c4 c5 c6
            ++ "\n"
            ++ boardLine
            ++ "\n"
            ++ makeLines c7 c8 c9
            ++ "\n"
            ++ boardLine
            ++ "\n"


boardToList :: Board -> [Cell]
boardToList (Board c1 c2 c3 c4 c5 c6 c7 c8 c9) =
    [c1, c2, c3, c4, c5, c6, c7, c8, c9]

boardToRows :: Board -> [[Cell]]
boardToRows (Board c1 c2 c3 c4 c5 c6 c7 c8 c9) =
    [ [c1, c2, c3]
    , [c4, c5, c6]
    , [c7, c8, c9]
    , [c1, c4, c7]
    , [c2, c5, c8]
    , [c3, c6, c9]
    , [c1, c5, c9]
    , [c3, c5, c7]
    ]

boardIsFull :: Board -> Bool
boardIsFull board = E `notElem` boardToList board

-- update the cell in board only if it is empty
updateBoard :: Board -> Cell -> Int -> Board
updateBoard board@(Board c1 c2 c3 c4 c5 c6 c7 c8 c9) cell num
    | num == 1 && c1 == E = Board cell c2 c3 c4 c5 c6 c7 c8 c9
    | num == 2 && c2 == E = Board c1 cell c3 c4 c5 c6 c7 c8 c9
    | num == 3 && c3 == E = Board c1 c2 cell c4 c5 c6 c7 c8 c9
    | num == 4 && c4 == E = Board c1 c2 c3 cell c5 c6 c7 c8 c9
    | num == 5 && c5 == E = Board c1 c2 c3 c4 cell c6 c7 c8 c9
    | num == 6 && c6 == E = Board c1 c2 c3 c4 c5 cell c7 c8 c9
    | num == 7 && c7 == E = Board c1 c2 c3 c4 c5 c6 cell c8 c9
    | num == 8 && c8 == E = Board c1 c2 c3 c4 c5 c6 c7 cell c9
    | num == 9 && c9 == E = Board c1 c2 c3 c4 c5 c6 c7 c8 cell
    | otherwise           = board


data Player = PlayerO | PlayerX

instance Show Player where
    show PlayerO = "Player O"
    show PlayerX = "Player x"


playerOWon :: Board -> Bool
playerOWon b = playerWon b PlayerO

playerXWon :: Board -> Bool
playerXWon b = playerWon b PlayerX

playerWon :: Board -> Player -> Bool
playerWon board player = True `elem` checkRows
  where
    c = cellOfPlayer player

    checkRows :: [Bool]
    checkRows = map (all (== c)) (boardToRows board)

cellOfPlayer :: Player -> Cell
cellOfPlayer player = case player of
    PlayerO -> O
    PlayerX -> X

nextPlayer :: Player -> Player
nextPlayer player = case player of
    PlayerO -> PlayerX
    PlayerX -> PlayerO
