board {
    const ubyte EMPTY_FIELD = 0
    const ubyte BLACK_PIECE = 1
    const ubyte WHITE_PIECE = 2
    const ubyte BLACK_KING = 3
    const ubyte WHITE_KING = 4    

    const ubyte BOARD_WIDTH = 10
    const ubyte BOARD_HEIGHT = 10

    const ubyte BOARD_FIELDS = 50 ;number of valid fields

    ubyte[BOARD_FIELDS] board_fields = [
        BLACK_PIECE, EMPTY_FIELD, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
        BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
        EMPTY_FIELD, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
        BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
        EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
        EMPTY_FIELD, EMPTY_FIELD, BLACK_PIECE, EMPTY_FIELD, EMPTY_FIELD,
        WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
        EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
        EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
        EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD
        ]    

    ubyte moves_length = 0
    uword[128] moves
    ubyte[128] pieces_to_take

    sub calculate_legal_moves() {
        moves_length = 0

        calculate_jumps()
        if (moves_length == 0) {
            calculate_regular_moves()
        }

        txt.plot(0, 3)
        txt.print("moves:")
        ubyte i
        for i in 0 to moves_length - 1 {
            txt.plot(0, 4 + i)
            txt.print_uwhex(moves[i], 0)
        }
        for i in moves_length to moves_length + 5 {
            txt.plot(0, 4 + i)
            txt.print("      ")
        }
        
    }

    sub calculate_jumps() {
        ubyte i
        for i in 0 to BOARD_FIELDS - 1 {
            ubyte odd = (i / 5) % 2 ;can be faster by using precalc array
    
            ;can jump forward right
            if (i >= 9  and board_fields[i] == WHITE_PIECE and board_fields[i-9] == EMPTY_FIELD and board_fields[i-4-odd] == BLACK_PIECE) {
                moves[moves_length] = mkword(i - 9, i)
                pieces_to_take[moves_length] = i-4-odd
                moves_length++
            }

            ;can jump forward left
            if (i >= 11  and board_fields[i] == WHITE_PIECE and board_fields[i-11] == EMPTY_FIELD and board_fields[i-5-odd] == BLACK_PIECE) {
                moves[moves_length] = mkword(i - 11, i)
                pieces_to_take[moves_length] = i-5-odd
                moves_length++
            }

            ;can jump backward left
            if (i < BOARD_FIELDS - 9  and board_fields[i] == WHITE_PIECE and board_fields[i+9] == EMPTY_FIELD and board_fields[i+4+(1-odd)] == BLACK_PIECE) {
                moves[moves_length] = mkword(i + 9, i)
                pieces_to_take[moves_length] = i+4+(1-odd)
                moves_length++
            }

            ;can jump backward right
            if (i < BOARD_FIELDS - 11  and board_fields[i] == WHITE_PIECE and board_fields[i+11] == EMPTY_FIELD and board_fields[i+5+(1-odd)] == BLACK_PIECE) {
                moves[moves_length] = mkword(i + 11, i)
                pieces_to_take[moves_length] = i+5+(1-odd)
                moves_length++
            }                      
        }        
    }

    sub calculate_regular_moves() {
        ubyte i
        for i in 0 to BOARD_FIELDS - 1 {
            ubyte odd = (i / 5) % 2 ;can be faster by using precalc array

            ;can forward right
            if (i >= 4 + odd and board_fields[i] == WHITE_PIECE and board_fields[i-4-odd] == EMPTY_FIELD) {
                moves[moves_length] = mkword(i - 4 - odd, i)
                pieces_to_take[moves_length] = 255
                moves_length++
            }

            ;can forward left
            if (i >= 5 + odd and board_fields[i] == WHITE_PIECE and board_fields[i-5 - odd] == EMPTY_FIELD) {
                moves[moves_length] = mkword(i - 5 - odd, i)
                pieces_to_take[moves_length] = 255
                moves_length++
            }                                 
        }
    }


    ;returns move index in legal moves table or -1 if there is no such move
    sub legal_move_index(uword move) -> byte {
        ubyte i
        for i in 0 to moves_length - 1 {
            if (moves[i] == move) {
                return i
            }
        }
        return -1
    }

    sub make_move(byte move_index) {
        ;move is encoded into a single word: lsb is a source field index, msb is a destination field index
        uword move = moves[move_index]

        board_fields[msb(move)] = board_fields[lsb(move)]
        board_fields[lsb(move)] = EMPTY_FIELD

        if (pieces_to_take[move_index] != 255) {
            board_fields[pieces_to_take[move_index]] = EMPTY_FIELD
        }
    }

    sub is_game_over() -> ubyte {
        if (moves_length == 0) {
            return true
        }
        return false
    }
}
