library cord {
    struct cord {
        real x
        real y
    
        nothing modCord(real xd, real yd) {
            this.x += xd
            this.y += yd
        }
    }
}