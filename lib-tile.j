library tilelib initializer createGrid requires cord {
    globals
        constant integer walltile = 'Oaby'
        constant integer pathBlocker = 'YTfc'
        constant integer walkBlocker = 'YTpc'
        constant integer visionBlocker = 'YTlb'
        constant integer gridMaxX = 64 
        constant integer gridMaxY = 64
        hashtable pathingGrid
        hashtable pathingBlockGrid
        hashtable visionGrid
        hashtable visionBlockGrid
        private hashtable timerHash
    endglobals
    
    real getTileCenterXByIndex(integer ix, integer iy) {
        return ((gridMaxX/2) * -128.0) + (ix * 128.0)
    }
    
    real getTileCenterYByIndex(integer ix, integer iy) {
        return ((gridMaxY/2) * -128.0) + (iy * 128.0)
    }
    
    struct tile extends cord {
        integer tilecode
        integer pathing
        integer vision
        destructable pBlocker
        destructable vBlocker
            
        }
    
    tile initTile(integer ix, integer iy) {
            tile t = tile.create()
            t.x = getTileCenterXByIndex(ix, iy)
            t.y = getTileCenterYByIndex(ix, iy)
            t.tilecode = GetTerrainType(t.x, t.y)
            t.pathing = LoadInteger(pathingGrid, ix, iy)
            t.vision = LoadInteger(visionGrid, ix, iy)
            t.pBlocker = LoadDestructableHandle(pathingBlockGrid, ix, iy)
            t.vBlocker = LoadDestructableHandle(visionBlockGrid, ix, iy)
            return t
    }
    
    private nothing loopNewThread1() {
        integer j = 0
        integer terrtype
        timer t = GetExpiredTimer()
        integer i = LoadInteger(timerHash, GetHandleId(t), 0)
        loop {
            exitwhen j >= gridMaxY
            terrtype = GetTerrainType(getTileCenterXByIndex(i, j), getTileCenterYByIndex(i, j))
            if terrtype == walltile {
                    SaveInteger(pathingGrid, i, j, 2)
                    SaveDestructableHandle(pathingBlockGrid, i, j, CreateDestructable(pathBlocker, getTileCenterXByIndex(i, j), getTileCenterYByIndex(i, j), 0.0, 1.0, 0))
                    SaveInteger(visionGrid, i, j, 1)
                    SaveDestructableHandle(visionBlockGrid, i, j, CreateDestructable(visionBlocker, getTileCenterXByIndex(i, j), getTileCenterYByIndex(i, j), 0.0, 1.0, 0))
            } else {
                    SaveInteger(pathingGrid, i, j, 0)
                    SaveInteger(visionGrid, i, j, 0)
                    SaveDestructableHandle(pathingBlockGrid, i, j, null)
                    SaveDestructableHandle(visionBlockGrid, i, j, null)
            }
            j++
                
        }
        if i == gridMaxX {
            BJDebugMsg("pathing grid succesfully initialized")
            FlushParentHashtable(timerHash)
        }
        DestroyTimer(t)
        t = null
    }
    
    nothing createGrid() {
        integer i = 0
        integer j = 0
        timer t
        pathingGrid = InitHashtable()
        visionGrid = InitHashtable()
        pathingBlockGrid = InitHashtable()
        visionBlockGrid = InitHashtable()
        timerHash = InitHashtable()
        loop {
            exitwhen i > gridMaxX
            t = CreateTimer()
            SaveInteger(timerHash, GetHandleId(t), 0, i)
            TimerStart(t, (i+1) * 0.01, false, function loopNewThread1)
            i++
        }
        FogEnable(true)
        FogMaskEnable(true)
        t = null
    }
}