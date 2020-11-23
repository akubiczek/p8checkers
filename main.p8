%import textio
%zeropage basicsafe

#include ui.p8
#include board.p8

main {
    sub start ()  {
        board.reset()
        ui.init()
        ui.draw_info()
        ui.draw_board()

        board.calculate_legal_moves()
        
        while not board.is_game_over() {
            uword move = ui.get_user_move()
            txt.print_uwhex(move, 0)
            byte move_index = board.legal_move_index(move)

            if (move_index != -1) {
                board.make_move(move_index)
                board.calculate_legal_moves()
            }
            ui.draw_board()
        }

        ui.draw_gameover()
    }
}
