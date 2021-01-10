agent {
    const ubyte BOARD_FIELDS = 54

    sub get_move_rnd() -> ubyte {
        ubyte divider = 255 / board.moves_length
        return rnd() / divider
    }

    sub get_move() -> ubyte {
        ubyte i
        ubyte strongest_move_index = 0
        word strongest_move_strength = 0

        for i in 0 to board.moves_length - 1 {
            saved_state.save()
            board.make_move(i)
            word move_strength = score()
            if move_strength > strongest_move_strength {
                strongest_move_index = i
                strongest_move_strength = move_strength
            }
            saved_state.restore()
        } 

        return strongest_move_index
    }

    sub get_move_nm() -> ubyte {
        if board.moves_length == 1 {
            return 0
        }        
        ubyte move_index = negamax(board.who_plays)
        return move_index
    }

    ;returns the strongest move index
    ;https://en.wikipedia.org/wiki/Negamax
    sub negamax(ubyte who_plays) -> ubyte {

        const ubyte DIR_DOWN = 0
        const ubyte DIR_UP = 1
        const word INF = $7FFF
        const ubyte MAXMAX_DEPTH = 5

        ubyte direction = DIR_DOWN
        ubyte current_depth = 0
        ubyte max_depth = 2

        word[MAXMAX_DEPTH] best_score
        ubyte[MAXMAX_DEPTH] best_move
        ubyte[MAXMAX_DEPTH] current_move
        ubyte[MAXMAX_DEPTH] moves_length

        repeat {
            ubyte parent = current_depth-1
            txt.plot(10,1)
            txt.print_ub(current_depth)

            ; do {
            ;     ubyte key=c64.GETIN()
            ; } until key > 0

            if direction == DIR_DOWN {
                if current_depth < max_depth {
                    best_move[current_depth] = 0
                    best_score[current_depth] = -INF
                    current_move[current_depth] = 0
                    moves_length[current_depth] = board.moves_length
                    
                    saved_state.save()
                    board.make_move(0)
                    ui.draw_board()
                    
                    current_depth++
                } else {
                    word leaf_score = -score()
                    if leaf_score > best_score[parent] {
                        best_score[parent] = leaf_score
                        best_move[parent] = current_move[parent]
                    }
                    direction = DIR_UP
                    current_depth--
                    saved_state.restore()
                }
            }
            else if direction == DIR_UP {
                if current_move[current_depth] >= moves_length[current_depth]-1  {
                    word bs = -best_score[current_depth]
                    if bs > best_score[parent] {
                        best_score[parent] = bs
                        best_move[parent] = current_move[parent]
                    }

                    if current_depth == 0 {
                        break
                    }

                    current_depth--
                    saved_state.restore()

                } else {
                    current_move[current_depth]++

                    saved_state.save()
                    board.make_move(current_move[current_depth])
                    
                    txt.plot(0,0)
                    txt.print_ub(current_move[current_depth])
                    txt.print(" ")

                    ui.draw_board()

                    direction = DIR_DOWN
                    current_depth++    
                }
            }
        }

        return best_move[0]
    }

    sub dummy_negamax(ubyte who_plays) -> ubyte {
        ubyte strongest_move_index = 0
        word strongest_move_strength = 0

        ubyte d1
        ubyte d2
        ubyte d3

        ubyte who_plays2

        txt.plot(0,0)
        txt.print("          ")

        byte color = 1

        for d1 in 0 to board.moves_length - 1 {
            txt.plot(0,0)
            txt.print_ub(d1)
            saved_state.save()
            board.make_move(d1)

            if board.who_plays != who_plays {
                color = color * -1
            }

            who_plays2 = board.who_plays

            for d2 in 0 to board.moves_length - 1 {
                txt.plot(2,0)
                txt.print_ub(d2)
                saved_state.save()
                board.make_move(d2)

                if board.who_plays != who_plays2 {
                    color = color * -1
                }                

                for d3 in 0 to board.moves_length - 1 {
                    saved_state.save()
                    board.make_move(d3)

                    word move_strength = score()
                    if move_strength > strongest_move_strength {
                        strongest_move_index = d1
                        strongest_move_strength = move_strength
                    }                    

                    saved_state.restore()
                }

                saved_state.restore()
            }

            saved_state.restore()
        }

        return strongest_move_index
    }

    sub score() -> word {
        word board_score = score_piecies()
        return board_score
    }

    sub score_piecies() -> word {
        ubyte i
        word black_score = 0
        word white_score = 0

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

        txt.plot(0,4)
        txt.print_w(black_score)
        txt.print_w(white_score)

        ; do {
        ;     ubyte key=c64.GETIN()
        ; } until key > 0

        if (board.who_plays == board.BLACK) {        
            return black_score - white_score
        }

        return white_score - black_score
    }
}