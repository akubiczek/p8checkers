board {
    const ubyte BLACK = 0
    const ubyte WHITE = 1

    const ubyte EMPTY_FIELD = 0
    const ubyte FAKE_FIELD = 255
    const ubyte BLACK_PIECE = 1
    const ubyte WHITE_PIECE = 2
    const ubyte BLACK_KING = 3
    const ubyte WHITE_KING = 4    

    const ubyte BOARD_WIDTH = 10
    const ubyte BOARD_HEIGHT = 10

    const ubyte BOARD_FIELDS = 54

    ubyte[] piece_color = [BLACK_PIECE, WHITE_PIECE]
    ubyte[BOARD_FIELDS] board_fields   

    ubyte who_plays
    ubyte who_waits
    ubyte moves_length = 0
    uword[128] moves
    ubyte[128] pieces_to_take

    sub reset() {
        board_fields = [
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, FAKE_FIELD,
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, FAKE_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, FAKE_FIELD,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, FAKE_FIELD,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE
        ] 

        who_plays = WHITE
        who_waits = BLACK

        calculate_legal_moves()
    }

    sub calculate_legal_moves() {
        moves_length = 0

        txt.plot(0, 0)
        
        calculate_jumps()
        if (moves_length == 0) {
            calculate_regular_moves ()
            txt.print_ub(moves_length)
            txt.print(" m  ")            
        } else {
            txt.print_ub(moves_length)
            txt.print(" j  ")        
        }
        
        ubyte i
        for i in 0 to 20 {
            txt.plot(0, 1 + i)
            txt.print_uwhex(moves[i], 0)
        }
    }

    sub calculate_jumps() {
        ubyte i
        for i in 0 to BOARD_FIELDS - 1 {
            calculate_jumps_from(i)       
        }        
    }

    sub calculate_jumps_from(ubyte source_field) {
        ;can jump forward right
        if (source_field >= 10 and board_fields[source_field] == piece_color[who_plays] and board_fields[source_field-10] == EMPTY_FIELD and board_fields[source_field-5] == piece_color[who_waits]) {
            moves[moves_length] = mkword(source_field-10, source_field)
            pieces_to_take[moves_length] = source_field-5
            moves_length++
        }

        ;can jump forward left
        if (source_field >= 12 and board_fields[source_field] == piece_color[who_plays] and board_fields[source_field-12] == EMPTY_FIELD and board_fields[source_field-6] == piece_color[who_waits]) {
            moves[moves_length] = mkword(source_field-12, source_field)
            pieces_to_take[moves_length] = source_field-6
            moves_length++
        }

        ;can jump backward left
        if (source_field < BOARD_FIELDS - 10 and board_fields[source_field] == piece_color[who_plays] and board_fields[source_field+10] == EMPTY_FIELD and board_fields[source_field+5] == piece_color[who_waits]) {
            moves[moves_length] = mkword(source_field+10, source_field)
            pieces_to_take[moves_length] = source_field+5
            moves_length++
        }

        ;can jump backward right
        if (source_field < BOARD_FIELDS - 12 and board_fields[source_field] == piece_color[who_plays] and board_fields[source_field+12] == EMPTY_FIELD and board_fields[source_field+6] == piece_color[who_waits]) {
            moves[moves_length] = mkword(source_field+12, source_field)
            pieces_to_take[moves_length] = source_field+6
            moves_length++
        }         
    }

    sub calculate_regular_moves() {
        ubyte i
        for i in 0 to BOARD_FIELDS - 1 {
            if (who_plays == WHITE) {
                ;can forward right
                if (i >= 5 and board_fields[i] == WHITE_PIECE and board_fields[i-5] == EMPTY_FIELD) {
                    moves[moves_length] = mkword(i-5, i)
                    pieces_to_take[moves_length] = 255
                    moves_length++
                }

                ;can forward left
                if (i >= 6 and board_fields[i] == WHITE_PIECE and board_fields[i-6] == EMPTY_FIELD) {
                    moves[moves_length] = mkword(i-6, i)
                    pieces_to_take[moves_length] = 255
                    moves_length++
                }
            }  else {
                ;can backward left
                if (i < BOARD_FIELDS - 5 and board_fields[i] == BLACK_PIECE and board_fields[i+5] == EMPTY_FIELD) {
                    moves[moves_length] = mkword(i+5, i)
                    pieces_to_take[moves_length] = 255
                    moves_length++
                }

                ;can backward right
                if (i < BOARD_FIELDS - 6 and board_fields[i] == BLACK_PIECE and board_fields[i+6] == EMPTY_FIELD) {
                    moves[moves_length] = mkword(i+6, i)
                    pieces_to_take[moves_length] = 255
                    moves_length++
                }                
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

    sub is_jump(uword move) -> ubyte {
        ubyte source_field = lsb(move)
        ubyte destination_field = msb(move)

        if (abs(source_field - destination_field) > 6) {
            return true
        }

        return false
    }

    sub make_move(byte move_index) {
        ;move is encoded into a single word: lsb is a source field index, msb is a destination field index
        uword move = moves[move_index]
        ubyte source_field = lsb(move)
        ubyte destination_field = msb(move)

        board_fields[destination_field] = board_fields[source_field]
        board_fields[source_field] = EMPTY_FIELD

        if (pieces_to_take[move_index] != 255) {
            board_fields[pieces_to_take[move_index]] = EMPTY_FIELD
        }

        if (is_jump(move)) {
            moves_length = 0
            calculate_jumps_from(destination_field)
            if (moves_length > 0) {
                ;there are some obligatory jumps
                return
            }
        }

        if (who_plays == WHITE) {
            who_plays = BLACK
            who_waits = WHITE
        } else {
            who_plays = WHITE
            who_waits = BLACK
        }

        calculate_legal_moves()
    }

    sub is_game_over() -> ubyte {
        if (moves_length == 0) {
            return true
        }
        return false
    }
}
