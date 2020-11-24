%import textio
%zeropage basicsafe

#include ui.p8
#include board.p8
#include agent.p8

main {

    const ubyte GAME_MODE_PVC = 1
    const ubyte GAME_MODE_PVP = 2
    const ubyte GAME_MODE_CVC = 3

    ubyte game_mode = 0

    sub start ()  {
        board.reset()
        ui.init()
        game_mode = ui.ask_who_plays()

        board.calculate_legal_moves()
        
        while not board.is_game_over() {
            byte move_index

            if (is_computer_move()) {
                move_index = agent.get_move()
            } else {
                uword move = ui.get_user_move()
                move_index = board.legal_move_index(move)
            }

            if (move_index != -1) {
                board.make_move(move_index)
                board.calculate_legal_moves()
            }

            ui.draw_board()
        }

        ui.draw_gameover()
    }

    sub is_computer_move() -> ubyte {
        return game_mode == GAME_MODE_CVC or (game_mode == GAME_MODE_PVC and board.who_plays == board.BLACK)
    }
}
