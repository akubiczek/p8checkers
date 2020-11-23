%import textio
%zeropage basicsafe

#include ui.p8
#include board.p8

main {
    sub start ()  {
        init()
        test_ui()
        ui.draw_info()
        ui.draw_board()

        board.calculate_legal_moves()
        
        while not board.is_game_over() {
            uword move = ui.get_user_move()
            txt.print_uw(move)
            byte move_index = board.legal_move_index(move)

            if (move_index != -1) {
                board.make_move(move_index)
                board.calculate_legal_moves()
            }
            ui.draw_board()
        }

        ui.draw_gameover()
    }

    sub init() {
        void cx16.screen_set_mode(0)
    }

    sub test_ui() {
        if (ui.xy_to_index(1, 0) != 0) {
            txt.print("err 1,0")
        }
        if (ui.xy_to_index(3, 0) != 1) {
            txt.print("err 3,0")
        }
        if (ui.xy_to_index(9, 0) != 4) {
            txt.print("err 9,0")
        }
        if (ui.xy_to_index(0, 1) != 5) {
            txt.print("err 0,1")
        }        
        if (ui.xy_to_index(1, 2) != 10) {
            txt.print("err 1,2")
        }        
    }
}
