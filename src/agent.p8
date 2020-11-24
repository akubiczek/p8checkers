agent {
    sub get_move() -> byte {
        ubyte divider = 255 / board.moves_length
        return rnd() / divider
    }
}