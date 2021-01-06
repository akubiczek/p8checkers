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

    ubyte[] opponents = [WHITE_PIECE, WHITE_KING, BLACK_PIECE, BLACK_KING]
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

        calculate_jumps()
        if (moves_length == 0) {
            calculate_regular_moves()
        }        
    }

    sub calculate_jumps() {
        ubyte i
        for i in 0 to BOARD_FIELDS - 1 {
            calculate_jumps_from(i)       
        }        
    }

    sub calculate_jumps_from(ubyte source_field) {
        ubyte current_player_king = opponents[who_waits*2+1]
        ubyte opponents_piece = opponents[who_plays*2]
        ubyte opponents_king = opponents[who_plays*2+1]

        if (board_fields[source_field] == current_player_king) {
            ubyte j
            for j in source_field + 6 to $30 step 6 {
                if (board_fields[j] == FAKE_FIELD) {
                    ;edge of the board achieved
                    break    
                }
                ;matches opponent's piece and opponent's king
                if (board_fields[j] == opponents_piece or board_fields[j] == opponents_king) {
                    if (board_fields[j+6] == EMPTY_FIELD) {
                        store_move(source_field, j+6, j)
                    }
                    break
                }                
            }
            for j in source_field + 5 to $30 step 5 {
                if (board_fields[j] == FAKE_FIELD) {
                    ;edge of the board achieved
                    break    
                }                
                ;matches opponent's piece and opponent's king
                if (board_fields[j] == opponents_piece or board_fields[j] == opponents_king) {
                    if (board_fields[j+5] == EMPTY_FIELD) {
                        store_move(source_field, j+5, j)
                    }
                    break
                }                
            }
            for j in source_field - 5 to 5 step -5 {
                if (board_fields[j] == FAKE_FIELD) {
                    ;edge of the board achieved
                    break    
                }                
                ;matches opponent's piece and opponent's king
                if (board_fields[j] == opponents_piece or board_fields[j] == opponents_king) {
                    if (board_fields[j-5] == EMPTY_FIELD) {
                        store_move(source_field, j-5, j)
                    }
                    break
                }                
            }
            for j in source_field - 6 to 6 step -6 {
                if (board_fields[j] == FAKE_FIELD) {
                    ;edge of the board achieved
                    break    
                }                
                ;matches opponent's piece and opponent's king
                if (board_fields[j] == opponents_piece or board_fields[j] == opponents_king) {
                    if (board_fields[j-6] == EMPTY_FIELD) {
                        store_move(source_field, j-6, j)
                    }
                    break
                }                
            }
        } else {
            ;can jump forward right
            if (source_field >= 10 and board_fields[source_field] == piece_color[who_plays] and board_fields[source_field-10] == EMPTY_FIELD and (board_fields[source_field-5] == opponents_piece or board_fields[source_field-5] == opponents_king)) {
                moves[moves_length] = mkword(source_field-10, source_field)
                pieces_to_take[moves_length] = source_field-5
                moves_length++
            }

            ;can jump forward left
            if (source_field >= 12 and board_fields[source_field] == piece_color[who_plays] and board_fields[source_field-12] == EMPTY_FIELD and (board_fields[source_field-6] == opponents_piece or board_fields[source_field-6] == opponents_king)) {
                moves[moves_length] = mkword(source_field-12, source_field)
                pieces_to_take[moves_length] = source_field-6
                moves_length++
            }

            ;can jump backward left
            if (source_field < BOARD_FIELDS - 10 and board_fields[source_field] == piece_color[who_plays] and board_fields[source_field+10] == EMPTY_FIELD and (board_fields[source_field+5] == opponents_piece or board_fields[source_field+5] == opponents_king)) {
                moves[moves_length] = mkword(source_field+10, source_field)
                pieces_to_take[moves_length] = source_field+5
                moves_length++
            }

            ;can jump backward right
            if (source_field < BOARD_FIELDS - 12 and board_fields[source_field] == piece_color[who_plays] and board_fields[source_field+12] == EMPTY_FIELD and (board_fields[source_field+6] == opponents_piece or board_fields[source_field+6] == opponents_king)) {
                moves[moves_length] = mkword(source_field+12, source_field)
                pieces_to_take[moves_length] = source_field+6
                moves_length++
            }  
        }       
    }

    sub calculate_regular_moves() {
        ubyte i
        ubyte current_player_king = opponents[who_waits*2+1]
        for i in 0 to BOARD_FIELDS - 1 {
            if (board_fields[i] == current_player_king) {
                ubyte j
                for j in i + 6 to $35 step 6 {
                    if (board_fields[j] == EMPTY_FIELD) {
                        store_move(i, j, 255)
                    } else {
                        break
                    }                  
                }
                for j in i + 5 to $35 step 5 {
                    if (board_fields[j] == EMPTY_FIELD) {
                        store_move(i, j, 255)
                    } else {
                        break
                    }                    
                }
                for j in i - 6 to 0 step -6 {
                    if (board_fields[j] == EMPTY_FIELD) {
                        store_move(i, j, 255)
                    } else {
                        break
                    }                     
                }
                for j in i - 5 to 0 step -5 {
                    if (board_fields[j] == EMPTY_FIELD) {
                        store_move(i, j, 255)
                    } else {
                        break
                    }                    
                }                               
            } else if (who_plays == WHITE and board_fields[i] == WHITE_PIECE) {
                ;can forward right
                if (i >= 5 and board_fields[i-5] == EMPTY_FIELD) {
                    store_move(i, i-5, 255)
                }

                ;can forward left
                if (i >= 6 and board_fields[i-6] == EMPTY_FIELD) {
                    store_move(i, i-6, 255)
                }
            }  else if (who_plays == BLACK and board_fields[i] == BLACK_PIECE) {
                ;can backward left
                if (i < BOARD_FIELDS - 5 and board_fields[i+5] == EMPTY_FIELD) {
                    store_move(i, i+5, 255)
                }

                ;can backward right
                if (i < BOARD_FIELDS - 6 and board_fields[i+6] == EMPTY_FIELD) {
                    store_move(i, i+6, 255)
                }                
            }                           
        }
    }

    sub store_move(ubyte source, ubyte destination, ubyte piece_to_take) {
        moves[moves_length] = mkword(destination, source)
        pieces_to_take[moves_length] = piece_to_take
        moves_length++        
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

    sub is_jump(byte move_index) -> ubyte {
        uword move = moves[move_index]
        ubyte source_field = lsb(move)
        ubyte destination_field = msb(move)
        ubyte current_player_piece = opponents[who_waits*2]
        ubyte current_player_king = opponents[who_waits*2+1]

        ;TODO conditions below can be simplified
        if board_fields[source_field] == current_player_piece and abs(source_field - destination_field) > 6 {
            return true
        }

        if board_fields[source_field] == current_player_king and pieces_to_take[move_index] != 255 and abs(source_field - destination_field) > 6 {
            return true
        }

        return false
    }

    sub make_move(byte move_index) {
        ;move is encoded into a single word: lsb is a source field index, msb is a destination field index
        uword move = moves[move_index]
        ubyte source_field = lsb(move)
        ubyte destination_field = msb(move)

        ubyte was_jump = is_jump(move_index)

        board_fields[destination_field] = board_fields[source_field]
        board_fields[source_field] = EMPTY_FIELD

        if (pieces_to_take[move_index] != 255) {
            board_fields[pieces_to_take[move_index]] = EMPTY_FIELD
        }

        ;obligatory jumps
        if was_jump == true {
            moves_length = 0
            calculate_jumps_from(destination_field)
            if moves_length > 0 {
                ;there are some obligatory jumps
                return
            }
        }

        ;promoting to king
        if (who_plays == WHITE and destination_field < $05) {
            board_fields[destination_field] = WHITE_KING
        }
        if (who_plays == BLACK and destination_field > $30) {
            board_fields[destination_field] = BLACK_KING
        }

        ;swap turn
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
