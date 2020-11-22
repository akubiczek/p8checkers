board {
    const ubyte EMPTY_FIELD = 0
    const ubyte BLACK_PIECE = 1
    const ubyte WHITE_PIECE = 2

    const ubyte BOARD_WIDTH = 10
    const ubyte BOARD_HEIGHT = 10

    const ubyte BOARD_FIELDS = 50 ;number of valid fields

    ubyte[BOARD_FIELDS] board_fields = [
        BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
        BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
        BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
        BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
        EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
        EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
        WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
        WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
        WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
        WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE
        ]    

    ubyte moves_length = 0
    uword[128] moves

    sub calculate_legal_moves() {
        ubyte moves_length = 0
        ubyte i
        for i in 0 to BOARD_FIELDS - 1 {
            ubyte odd = (i / 5) % 2 ;can be faster by using precalc array

            ;can forward right
            if (i >= 4 + odd and board_fields[i] == WHITE_PIECE and board_fields[i-4-odd] == EMPTY_FIELD) {
                moves[moves_length] = mkword(i - 4 - odd, i)
                moves_length++
            }

            ;can forward left
            if (i >= 5 + odd and board_fields[i] == WHITE_PIECE and board_fields[i-5 - odd] == EMPTY_FIELD) {
                moves[moves_length] = mkword(i - 5 - odd, i)
                moves_length++
            }            

            ;can jump forward right
            if (i >= 9  and board_fields[i] == WHITE_PIECE and board_fields[i-9] == EMPTY_FIELD and board_fields[i-4-odd] == BLACK_PIECE) {
                moves[moves_length] = mkword(i - 9, i)
                moves_length++
            }

            ;can jump forward left
            if (i >= 11  and board_fields[i] == WHITE_PIECE and board_fields[i-11] == EMPTY_FIELD and board_fields[i-5-odd] == BLACK_PIECE) {
                moves[moves_length] = mkword(i - 11, i)
                moves_length++
            }

            ;can jump backward left
            if (i < BOARD_FIELDS - 9  and board_fields[i] == WHITE_PIECE and board_fields[i+9] == EMPTY_FIELD and board_fields[i+4+(1-odd)] == BLACK_PIECE) {
                moves[moves_length] = mkword(i + 9, i)
                moves_length++
            }

            ;can jump backward right
            if (i < BOARD_FIELDS - 11  and board_fields[i] == WHITE_PIECE and board_fields[i+11] == EMPTY_FIELD and board_fields[i+5+(1-odd)] == BLACK_PIECE) {
                moves[moves_length] = mkword(i + 11, i)
                moves_length++
            }                      
        }
    }


    sub is_legal_move(uword move) ->ubyte {
        ;TODO temporary condition for testing - blacks can make any move
        if (board_fields[lsb(move)] == BLACK_PIECE) {
            return true
        }

        ubyte i
        for i in 0 to moves_length - 1 {
            if (moves[i] == move) {
                return true
            }
        }
        return false
    }

    sub make_move(uword move) {
        ;move is encoded into a single word: lsb is a source field index, msb is a destination field index

        board_fields[msb(move)] = board_fields[lsb(move)]
        board_fields[lsb(move)] = EMPTY_FIELD
    }

    sub is_game_over() -> ubyte {
        ;TODO implement
        return false
    }
}
