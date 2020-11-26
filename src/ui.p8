ui {
    const ubyte BOARD_X_OFFSET = 10
    const ubyte BOARD_Y_OFFSET = 3

    const ubyte WHITE_CHECKER_COLOR = 1
    const ubyte BLACK_CHECKER_COLOR = 8
    const ubyte LIGHT_FIELD_COLOR = 6
    const ubyte DARK_FIELD_COLOR = 3
    const ubyte CURSOR_BG_COLOR = 10
    const ubyte CHOOSEN_BG_COLOR = 5

    ubyte cursor_x = board.BOARD_WIDTH - 1
    ubyte cursor_y = board.BOARD_HEIGHT - 1

    ubyte choosen_piece_x = 255
    ubyte choosen_piece_y = 255

    sub init() {
        void cx16.screen_set_mode(0)

        ui.draw_info()
        ui.draw_board()        
    }    

    sub ask_who_plays() -> ubyte {
        txt.color2(1, 6)
        txt.plot(5, 10)
        txt.print("                               ")
        txt.plot(5, 11)
        txt.print("           who plays?          ")
        txt.plot(5, 12)
        txt.print("                               ")
        txt.plot(5, 13)
        txt.print("   1 - player vs computer      ")
        txt.plot(5, 14)
        txt.print("   2 - player vs player        ")
        txt.plot(5, 15)
        txt.print("   3 - computer vs computer    ")
        txt.plot(5, 16)
        txt.print("                               ")
        ubyte key
        do {
            key=c64.GETIN()
        } until key >= 49 and key <= 51
        
        txt.fill_screen(0,0) ;clear screen and colors
        ui.draw_info()
        ui.draw_board()

        return key-48       
    }

    sub xy_to_index(ubyte x, ubyte y) -> ubyte {
        ;board array has 50 items, not 100
        ;top left corner is 0,0 (x,y)
        ubyte index = y * (board.BOARD_WIDTH / 2) + x / 2

        ;fake fields offset
        if (y > 1) {
            index++
        }
        if (y > 3) {
            index++
        }        
        if (y > 5) {
            index++
        }
        if (y > 7) {
            index++
        }             

        return index
    }

    sub is_dark_field(ubyte x, ubyte y) -> ubyte {
        return ((x + y) % 2)
    }

    sub draw_board() {
        ubyte x
        ubyte y
        for x in 0 to board.BOARD_WIDTH - 1 {
            for y in 0 to board.BOARD_HEIGHT - 1 {
                if (not is_dark_field(x, y)) {
                    draw_empty_field(x, y);
                } else {
                    when board.board_fields[xy_to_index(x, y)] {
                        0 -> draw_empty_field(x, y) ;EMPTY_FIELD const doesnt work
                        1 -> draw_black_piece(x, y, false) ;BLACK_PIECE const doesnt work
                        2 -> draw_white_piece(x, y, false) ;WHITE_PIECE const doesnt work
                        3 -> draw_black_piece(x, y, true) ;BLACK_KING const doesnt work
                        4 -> draw_white_piece(x, y, true) ;WHITE_KING const doesnt work
                    }
                }
            }
        }  
    }

    sub draw_empty_field(ubyte x, ubyte y) {
        txt.color2(0, get_bg_color(x, y))

        txt.plot(x*2 + BOARD_X_OFFSET, y*2 + BOARD_Y_OFFSET)
        txt.print("  ")
        txt.plot(x*2 + BOARD_X_OFFSET, y*2+1 + BOARD_Y_OFFSET)
        txt.print("  ")
    }

    sub get_bg_color(ubyte x, ubyte y) -> ubyte {
        if (x == choosen_piece_x and y == choosen_piece_y) {
            return CHOOSEN_BG_COLOR
        }
        else if (x == cursor_x and y == cursor_y) {
            return CURSOR_BG_COLOR 
        } else if ((x + y) % 2) {
            return LIGHT_FIELD_COLOR
        }

        return DARK_FIELD_COLOR        
    }

    sub draw_white_piece(ubyte x, ubyte y, ubyte is_king) {
        txt.color2(WHITE_CHECKER_COLOR, get_bg_color(x, y))
        if (is_king) {
            draw_king(x, y)
        } else {
            draw_piece(x, y)
        }
    }

    sub draw_black_piece(ubyte x, ubyte y, ubyte is_king) {
        txt.color2(BLACK_CHECKER_COLOR, get_bg_color(x, y))
        if (is_king) {
            draw_king(x, y)
        } else {
            draw_piece(x, y)
        }
    }

    sub draw_piece(ubyte x, ubyte y) {
        txt.plot(x * 2 + BOARD_X_OFFSET, y * 2 + BOARD_Y_OFFSET)
        txt.print("UI")
        txt.plot(x * 2 + BOARD_X_OFFSET, y * 2 + 1 + BOARD_Y_OFFSET)
        txt.print("JK")
    }

    sub draw_king(ubyte x, ubyte y) {
        txt.plot(x * 2 + BOARD_X_OFFSET, y * 2 + BOARD_Y_OFFSET)
        txt.print("NM")
        txt.plot(x * 2 + BOARD_X_OFFSET, y * 2 + 1 + BOARD_Y_OFFSET)
        txt.print("MN")
    }

    sub draw_info() {
        txt.plot(13, 1)
        txt.color(7)
        txt.print("polish")
        txt.color(5)
        txt.print(" draughts")

        txt.plot(1, 24)
        txt.print("shift+n - new game")
        txt.plot(1, 25)
        txt.print("c - change colors")
    }

    sub draw_gameover() {
        txt.plot(13, 10)
        txt.color(7)
        txt.print("game over")        
    }

    sub clear_choosen_piece() {
        choosen_piece_x = 255
        choosen_piece_y = 255
    }

    sub get_user_move() -> uword {
        ;move is encoded into a single word: lsb is a source field index, msb is a destination field index
        const ubyte KEY_RETURN = 13
        const ubyte KEY_ESC = 3

        ubyte source = 255
        ubyte destination = 255

        do {
            ubyte key_pressed = check_key_press()

            if (key_pressed == KEY_RETURN and source == 255) {
                source = xy_to_index(cursor_x, cursor_y)
                choosen_piece_x = cursor_x
                choosen_piece_y = cursor_y
                draw_board()
            } else if (key_pressed == KEY_RETURN and source != 255) {
                destination = xy_to_index(cursor_x, cursor_y)
            } else if (key_pressed == KEY_ESC) {
                ;cancel move
                source = 255
                clear_choosen_piece()
                draw_board()
            }

        } until source != 255 and destination != 255

        clear_choosen_piece()
        return mkword(destination, source)

        sub check_key_press () -> ubyte  {
            ubyte key=c64.GETIN()
            when key {
                145 -> {
                    ;up
                    if (cursor_y > 0) {
                        cursor_y--
                        draw_board()
                    }
                }
                17 -> {
                    ;down
                    if (cursor_y < board.BOARD_HEIGHT - 1) {
                        cursor_y++
                        draw_board()
                    }
                }
                29 -> {
                    ;right
                    if (cursor_x < board.BOARD_WIDTH - 1) {
                        cursor_x++
                        draw_board()
                    }
                }
                157 -> {
                    ;left
                    if (cursor_x > 0) {
                        cursor_x--
                        draw_board()
                    }
                }
                13 -> {
                    return KEY_RETURN
                }
                3 -> {
                    return KEY_ESC
                }            
            }

            return key
        }          
    }
}
