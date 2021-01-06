
testsuit {

    const ubyte EMPTY_FIELD = 0
    const ubyte FAKE_FIELD = 255
    const ubyte BLACK_PIECE = 1
    const ubyte WHITE_PIECE = 2
    const ubyte BLACK_KING = 3
    const ubyte WHITE_KING = 4   

    sub run() {
        txt.plot(0, 0)
        txt.fill_screen($20,ui.SCREEN_BACKGROUND_COLOR << 4) ;clear screen and colors
        txt.color2(ui.DIALOG_TEXT_COLOR, ui.SCREEN_BACKGROUND_COLOR)
        txt.print("running test1")
        test1()
        txt.print("running test2")
        test2()
        txt.print("running test3")
        test3()
        txt.print("running test4")
        test4()
    }

    sub passed() {
        txt.color2(ui.DIALOG_TEXT_COLOR, ui.SCREEN_BACKGROUND_COLOR)
        txt.print("passed")
        txt.color2(ui.DIALOG_TEXT_COLOR, ui.SCREEN_BACKGROUND_COLOR)
    }

    sub failed() {
        txt.color2(ui.DIALOG_TEXT_COLOR, ui.ILLEGAL_MOVE_COLOR)
        txt.print("failed")
        txt.color2(ui.DIALOG_TEXT_COLOR, ui.SCREEN_BACKGROUND_COLOR)
    }

    sub test1() {
        ubyte[] board_fields = [
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, FAKE_FIELD,
            BLACK_PIECE, EMPTY_FIELD, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, FAKE_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, WHITE_PIECE, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, FAKE_FIELD,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, FAKE_FIELD,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE
        ] 

        board.board_fields = board_fields
        board.who_plays = board.WHITE

        board.calculate_legal_moves()

        if board.moves_length == 1 and board.moves[0] == $0c18 {
            passed()
        } else {
            failed()
        }

        board.make_move(0)
        board.calculate_legal_moves()

        if board.who_plays == board.WHITE and board.moves_length == 1 and board.moves[0] == $160c {
            passed()
        } else {
            failed()
        }        
    }

    sub test2() {
        ubyte[] board_fields = [
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, FAKE_FIELD,
            BLACK_PIECE, EMPTY_FIELD, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE,
            BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, BLACK_PIECE, FAKE_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, WHITE_KING, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, FAKE_FIELD,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, FAKE_FIELD,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE
        ] 

        board.board_fields = board_fields
        board.who_plays = board.WHITE

        board.calculate_legal_moves()

        if board.moves_length == 1 and board.moves[0] == $0c18 {
            passed()
        } else {
            failed()
        }

        board.make_move(0)
        board.calculate_legal_moves()

        if board.who_plays == board.WHITE and board.moves_length == 1 and board.moves[0] == $160c {
            passed()
        } else {
            failed()
        }        
    }

    sub test3() {
        ubyte[] board_fields = [
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, FAKE_FIELD,
            BLACK_PIECE, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, BLACK_PIECE,
            BLACK_PIECE, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, WHITE_PIECE, FAKE_FIELD,
            BLACK_PIECE, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, BLACK_PIECE,
            BLACK_PIECE, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, BLACK_PIECE, FAKE_FIELD,
            BLACK_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, BLACK_PIECE,
            EMPTY_FIELD, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, FAKE_FIELD,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE,
            WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE, WHITE_PIECE
        ] 

        board.board_fields = board_fields
        board.who_plays = board.WHITE

        board.calculate_legal_moves()

        if board.moves_length == 7 {
            passed()
        } else {
            failed()
        }      
    } 

    sub test4() {
        ubyte[] board_fields = [
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, FAKE_FIELD,
            EMPTY_FIELD, BLACK_PIECE, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, FAKE_FIELD,
            EMPTY_FIELD, BLACK_PIECE, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, FAKE_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, FAKE_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD,
            EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, EMPTY_FIELD, WHITE_KING
        ] 

        board.board_fields = board_fields
        board.who_plays = board.WHITE

        board.calculate_legal_moves()

        if board.moves_length == 1 and board.moves[0] == $1135 {
            passed()
        } else {
            failed()
        }

        board.make_move(0)
        board.calculate_legal_moves()

        if board.who_plays == board.WHITE and board.moves_length == 1 and board.moves[0] == $0711 {
            passed()
        } else {
            failed()
        } 

        board.make_move(0)
        board.calculate_legal_moves()        

        if board.is_game_over() and board.who_waits == board.WHITE {
            passed()
        } else {
            failed()
        }                
    }       
}
