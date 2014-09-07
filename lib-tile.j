library tilelib initializer createGrid requires cord {
    globals
        integer walltile = 'Oaby'
        hashtable tileGrid
    endglobals
    
    struct tile extends cord {
        integer tilecode
        //tilecode - код тайла формата 'xxxx'
        
        cord getTileCentre() {
            cord c = cord.create()
            c.modCord(c.x + 64.0, c.y - 64.0)
            return c
        }
    }
    
    nothing createGrid() {
    
    }
    
    
}