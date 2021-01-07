
saved_state {
    const ubyte MAX_DEPTH = 7
    ubyte current_depth = 0

    ubyte[MAX_DEPTH] who_plays_saved
    ubyte[MAX_DEPTH] who_waits_saved

    ;don't know how to make a single memory block in prog8
    ubyte[board.BOARD_FIELDS] memory_block0 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] 
    ubyte[board.BOARD_FIELDS] memory_block1 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] 
    ubyte[board.BOARD_FIELDS] memory_block2 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] 
    ubyte[board.BOARD_FIELDS] memory_block3 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] 
    ubyte[board.BOARD_FIELDS] memory_block4 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] 
    ubyte[board.BOARD_FIELDS] memory_block5 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] 
    ubyte[board.BOARD_FIELDS] memory_block6 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] 

    sub save() {
        ;don't know how to make a big memory block in prog8
        when current_depth {
            0 -> memcopy(&board.board_fields, &memory_block0, board.BOARD_FIELDS)
            1 -> memcopy(&board.board_fields, &memory_block1, board.BOARD_FIELDS)
            2 -> memcopy(&board.board_fields, &memory_block2, board.BOARD_FIELDS)
            3 -> memcopy(&board.board_fields, &memory_block3, board.BOARD_FIELDS)
            4 -> memcopy(&board.board_fields, &memory_block4, board.BOARD_FIELDS)
            5 -> memcopy(&board.board_fields, &memory_block5, board.BOARD_FIELDS)
            6 -> memcopy(&board.board_fields, &memory_block6, board.BOARD_FIELDS)
        }
        
        who_plays_saved[current_depth] = board.who_plays
        who_waits_saved[current_depth] = board.who_waits

        current_depth++
    }

    sub restore() {
        current_depth--

        when current_depth {
            0 -> memcopy(&memory_block0, &board.board_fields, board.BOARD_FIELDS)
            1 -> memcopy(&memory_block1, &board.board_fields, board.BOARD_FIELDS)
            2 -> memcopy(&memory_block2, &board.board_fields, board.BOARD_FIELDS)
            3 -> memcopy(&memory_block3, &board.board_fields, board.BOARD_FIELDS)
            4 -> memcopy(&memory_block4, &board.board_fields, board.BOARD_FIELDS)
            5 -> memcopy(&memory_block5, &board.board_fields, board.BOARD_FIELDS)
            6 -> memcopy(&memory_block6, &board.board_fields, board.BOARD_FIELDS)
        }        
        board.who_plays = who_plays_saved[current_depth]
        board.who_waits = who_waits_saved[current_depth]
        board.calculate_legal_moves()
    }    
}
