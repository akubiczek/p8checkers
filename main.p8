%import textio
%zeropage basicsafe

main {


    const ubyte x_offset = 12
    const ubyte y_offset = 4

    const ubyte WHITE_CHECKER_COLOR = 10;
    const ubyte BLACK_CHECKER_COLOR = 0;
    const ubyte WHITE_FIELD_COLOR = 6;
    const ubyte BLACK_FIELD_COLOR = 3;

    ubyte cursor_x = 7
    ubyte cursor_y = 7

    ubyte[] board = [2,9,2,9,2,9,2,9,9,2,9,2,9,2,9,2,9,0,9,0,9,0,9,9,0,9,0,9,0,9,0,9,0,9,0,9,0,9,9,0,9,0,9,0,9,0,9,0,1,9,1,9,1,9,1,9,9,1,9,1,9,1,9,1]

    sub start ()  {
        init()
        handle()
    }

    sub init() {
        void cx16.screen_set_mode(0)
    }

    sub handle ()  {

        draw_info()
        draw_board()

        repeat {
            ubyte key=c64.GETIN()
            when key {
                145 -> {
                    ;up
                    if (cursor_y > 0) {
                        cursor_y--
                    }
                }
                17 -> {
                    ;down
                    if (cursor_y < 7) {
                        cursor_y++
                    }
                }
                29 -> {
                    ;right
                    if (cursor_x < 7) {
                        cursor_x++
                    }
                }
                157 -> {
                    ;left
                    if (cursor_x > 0) {
                        cursor_x--
                    }
                }
                13 -> {
                    ;return
                }
            }
            
            if (key != 0) {
                draw_board()
            }
        }
    }

    sub draw_info() {

        txt.plot(15, 1)
        txt.color(52)
        txt.print("p8")
        txt.color(5)
        txt.print("checkers")

        txt.plot(1, 24)
        txt.print("shift+n - new game")
        txt.plot(1, 25)
        txt.print("c - change colors")

    }

    sub draw_board() {
        ubyte x
        ubyte y
        for x in 0 to 7 {
            for y in 0 to 7 {
                if (x == cursor_x and y == cursor_y) {
                    txt.color2(0, WHITE_CHECKER_COLOR)
                }
                else if ((x + y) % 2) {
                    txt.color2(0, WHITE_FIELD_COLOR)
                } else {
                    txt.color2(0, BLACK_FIELD_COLOR)
                }
                txt.plot(x*2 + x_offset, y*2 + y_offset)
                txt.print("  ")
                txt.plot(x*2 + x_offset, y*2+1 + y_offset)
                txt.print("  ")
            }
        }  

        ubyte i
        for y in 0 to 7 {
            for x in 0 to 7 {
                i = x + y * 8
                when board[i] {
                    1 -> {
                        draw_white_piece(x, y)
                    }
                    2 ->  {
                        draw_black_piece(x, y)
                    }
                }
            }
        }
    }

    sub draw_white_piece(ubyte x, ubyte y) {
        if (x == cursor_x and y == cursor_y) {
            txt.color2(BLACK_FIELD_COLOR, WHITE_CHECKER_COLOR)
        } else {
            txt.color2(WHITE_CHECKER_COLOR, BLACK_FIELD_COLOR)
        }

        draw_piece(x, y)
    }

    sub draw_black_piece(ubyte x, ubyte y) {
        if (x == cursor_x and y == cursor_y) {
            txt.color2(BLACK_CHECKER_COLOR, WHITE_CHECKER_COLOR)
        } else {
            txt.color2(BLACK_CHECKER_COLOR, BLACK_FIELD_COLOR)
        }

        draw_piece(x, y)
    }

    sub draw_piece(ubyte x, ubyte y) {
        txt.plot(x * 2 + x_offset, y * 2 + y_offset)
        txt.print("UI")
        txt.plot(x * 2 + x_offset, y * 2 + 1 + y_offset)
        txt.print("JK")
    }
}
