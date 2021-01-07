agent {
    const ubyte BOARD_FIELDS = 54

    sub get_move_rnd() -> ubyte {
        ubyte divider = 255 / board.moves_length
        return rnd() / divider
    }

    sub get_move() -> ubyte {
        ubyte i
        ubyte strongest_move_index = 0
        uword strongest_move_strength = 0

        for i in 0 to board.moves_length - 1 {
            saved_state.save()
            board.make_move(i)
            uword move_strength = score()
            if move_strength > strongest_move_strength {
                strongest_move_index = i
                strongest_move_strength = move_strength
            }
            saved_state.restore()
        } 

        return strongest_move_index
    }

    ; sub negamax(board_fields, depth, word alpha, word beta, byte color) {
    ;     ;https://en.wikipedia.org/wiki/Negamax
    ;     if depth == 0 {
    ;         return score(board_fields) * color
    ;     }
    ;     word best_value = -$7FFF
    ;     return best_value        
    ; }

    sub score() -> uword {
        uword board_score = score_piecies()
        return board_score
    }

    sub score_piecies() -> uword {
        ubyte i
        uword black_score = 0
        uword white_score = 0

        for i in 0 to BOARD_FIELDS - 1 {
            if board.board_fields[i] == board.BLACK_PIECE {
                black_score = black_score + 2
            }
            else if board.board_fields[i] == board.BLACK_KING {
                black_score = black_score + 3
            }
            else if board.board_fields[i] == board.WHITE_PIECE {
                white_score = white_score + 2
            }
            else if board.board_fields[i] == board.WHITE_KING {
                white_score = white_score + 3
            }                        
        } 

        if (board.who_plays == board.BLACK) {
            return black_score - white_score
        }

        return white_score - black_score
    }
}