
saved_state {
    const ubyte MAX_DEPTH = 7
    ubyte current_depth = 0

    ubyte[MAX_DEPTH] who_plays
    ubyte[MAX_DEPTH] who_waits
    ubyte[MAX_DEPTH] moves_length

    ;don't know how to make a single memory block in prog8
    ubyte[board.BOARD_FIELDS] memory_block0
    ubyte[board.BOARD_FIELDS] memory_block1
    ubyte[board.BOARD_FIELDS] memory_block2
    ubyte[board.BOARD_FIELDS] memory_block3
    ubyte[board.BOARD_FIELDS] memory_block4
    ubyte[board.BOARD_FIELDS] memory_block5
    ubyte[board.BOARD_FIELDS] memory_block6

    uword[128] moves0;
    uword[128] moves1;
    uword[128] moves2;
    uword[128] moves3;
    uword[128] moves4;
    uword[128] moves5;
    uword[128] moves6;

    ubyte[128] pieces_to_take0;
    ubyte[128] pieces_to_take1;
    ubyte[128] pieces_to_take2;
    ubyte[128] pieces_to_take3;
    ubyte[128] pieces_to_take4;
    ubyte[128] pieces_to_take5;
    ubyte[128] pieces_to_take6;

    sub save() {
        ;don't know how to make a big memory block in prog8
        when current_depth {
            0 -> {
                memcopy(&board.board_fields,     &memory_block0, board.BOARD_FIELDS)
                memcopy(&board.moves,                   &moves0, board.moves_length*2)
                memcopy(&board.pieces_to_take, &pieces_to_take0, board.moves_length)
            }
            1 -> {
                memcopy(&board.board_fields,     &memory_block1, board.BOARD_FIELDS)
                memcopy(&board.moves,                   &moves1, board.moves_length*2)
                memcopy(&board.pieces_to_take, &pieces_to_take1, board.moves_length)
            }
            2 -> {
                memcopy(&board.board_fields,     &memory_block2, board.BOARD_FIELDS)
                memcopy(&board.moves,                   &moves2, board.moves_length*2)
                memcopy(&board.pieces_to_take, &pieces_to_take2, board.moves_length)
            }
            3 -> {
                memcopy(&board.board_fields,     &memory_block3, board.BOARD_FIELDS)
                memcopy(&board.moves,                   &moves3, board.moves_length*2)
                memcopy(&board.pieces_to_take, &pieces_to_take3, board.moves_length)
            }
            4 -> {
                memcopy(&board.board_fields,     &memory_block4, board.BOARD_FIELDS)
                memcopy(&board.moves,                   &moves4, board.moves_length*2)
                memcopy(&board.pieces_to_take, &pieces_to_take4, board.moves_length)
            }
            5 -> {
                memcopy(&board.board_fields,     &memory_block5, board.BOARD_FIELDS)
                memcopy(&board.moves,                   &moves5, board.moves_length*2)
                memcopy(&board.pieces_to_take, &pieces_to_take5, board.moves_length)
            }
            6 -> {
                memcopy(&board.board_fields,     &memory_block6, board.BOARD_FIELDS)
                memcopy(&board.moves,                   &moves6, board.moves_length*2)
                memcopy(&board.pieces_to_take, &pieces_to_take6, board.moves_length)
            }
        }
        
        who_plays[current_depth] = board.who_plays
        who_waits[current_depth] = board.who_waits
        moves_length[current_depth] = board.moves_length

        current_depth++
        txt.plot(0,1)
        txt.print("depth=")
        txt.print_ub(current_depth)
    }

    sub restore() {
        current_depth--
        txt.plot(0,1)
        txt.print("depth=")
        txt.print_ub(current_depth)
        when current_depth {
            0 -> {
                memcopy(  &memory_block0, &board.board_fields, board.BOARD_FIELDS)
                memcopy(         &moves0, &board.moves, board.moves_length*2)
                memcopy(&pieces_to_take0, &board.pieces_to_take, board.moves_length)                
            }
            1 -> {
                memcopy(  &memory_block1, &board.board_fields, board.BOARD_FIELDS)
                memcopy(         &moves1, &board.moves, board.moves_length*2)
                memcopy(&pieces_to_take1, &board.pieces_to_take, board.moves_length)                
            }
            2 -> {
                memcopy(  &memory_block2, &board.board_fields, board.BOARD_FIELDS)
                memcopy(         &moves2, &board.moves, board.moves_length*2)
                memcopy(&pieces_to_take2, &board.pieces_to_take, board.moves_length)                
            }
            3 -> {
                memcopy(  &memory_block3, &board.board_fields, board.BOARD_FIELDS)
                memcopy(         &moves3, &board.moves, board.moves_length*2)
                memcopy(&pieces_to_take3, &board.pieces_to_take, board.moves_length)                
            }
            4 -> {
                memcopy(  &memory_block4, &board.board_fields, board.BOARD_FIELDS)
                memcopy(         &moves4, &board.moves, board.moves_length*2)
                memcopy(&pieces_to_take4, &board.pieces_to_take, board.moves_length)                
            }
            5 -> {
                memcopy(  &memory_block5, &board.board_fields, board.BOARD_FIELDS)
                memcopy(         &moves5, &board.moves, board.moves_length*2)
                memcopy(&pieces_to_take5, &board.pieces_to_take, board.moves_length)                
            }
            6 -> {
                memcopy(  &memory_block6, &board.board_fields, board.BOARD_FIELDS)
                memcopy(         &moves6, &board.moves, board.moves_length*2)
                memcopy(&pieces_to_take6, &board.pieces_to_take, board.moves_length)                
            }

        }        
        board.who_plays = who_plays[current_depth]
        board.who_waits = who_waits[current_depth]
        board.moves_length = moves_length[current_depth]
    }    
}
