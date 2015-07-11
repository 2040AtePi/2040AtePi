.section .data

@// mode 0 - manual
@// mode 1 - AI
.align 4
GameMode:
.int 0

.align 4
ActiveBoard:
.int 0

.align 4
Board:
.int -1
.int -1
.int -1
.int -1
.int -1
.int -1

.int -1
.int 0
.int 0
.int 0
.int 0
.int -1

.int -1
.int 0
.int 0
.int 0
.int 0
.int -1

.int -1
.int 0
.int 0
.int 0
.int 0
.int -1

.int -1
.int 0
.int 0
.int 0
.int 0
.int -1

.int -1
.int -1
.int -1
.int -1
.int -1
.int -1

.align 4
BoardCopy:
.int -1
.int -1
.int -1
.int -1
.int -1
.int -1
.int -1
.int 0
.int 0
.int 0
.int 0
.int -1
.int -1
.int 0
.int 0
.int 0
.int 0
.int -1
.int -1
.int 0
.int 0
.int 0
.int 0
.int -1
.int -1
.int 0
.int 0
.int 0
.int 0
.int -1
.int -1
.int -1
.int -1
.int -1
.int -1
.int -1

.section .text

@// r0: 0 for Board, 1 for BoardCopy
.globl SetActiveBoard
SetActiveBoard:
cmp r0,#1
beq setBoardCopy$
ldr r0,=Board
ldr r1,=ActiveBoard
str r0,[r1]
mov pc,lr

setBoardCopy$:
ldr r0,=BoardCopy
ldr r1,=ActiveBoard
str r0,[r1]
mov pc,lr


@//Args: 1
@//   r12: boardLocation
@//Return: 0
.globl ResetBoard
ResetBoard:
  boardLocation .req r12
  
  boardIndex .req r4
  val .req r5
  row .req r6
  col .req r7
  push {r4, r5, r6, r7, lr}

  ldr boardIndex,=ActiveBoard
  ldr boardIndex,[boardIndex]
  mov row, #0

  ClearRowLoop$:
    mov col, #0

    ClearColLoop$:
      teq row, #0
      teqne row, #5
      teqne col, #0
      teqne col, #5

      beq outOfBounds$ 
        mov val, #0
        b endBoundsCond$
      outOfBounds$:
        ldr val, =-1
      endBoundsCond$:
      str val, [boardIndex]

      add col, #1
      add boardIndex, #4
      cmp col, #6
      blt ClearColLoop$

    add row, #1
    cmp row, #6
    blt ClearRowLoop$

  .unreq boardLocation

  .unreq boardIndex
  .unreq val
  .unreq row
  .unreq col
  pop {r4, r5, r6, r7, pc}


@//Args: 3
@//    r0: oldTile
@//    r1: newTile
@//    r2: hasMerged
@//Return: 2
@//    r0: mergedTile
@//    r1: hasMergedRes
.global Merge
Merge:
  oldTile .req r0
  newTile .req r1
  hasMerged .req r2

  mergedTile .req r0
  hasMergedRes .req r1

  minusOne .req r4
  push {r4, lr}

  ldr minusOne, =-1

  teq oldTile, #0
  moveq hasMergedRes, #2
  beq MergeErrorReturn$
 
  teq oldTile, newTile
  bne ContinueMerge$
    teq hasMerged, #1
    moveq hasMergedRes, #0
    beq MergeErrorReturn$

    add mergedTile, oldTile, newTile
    mov hasMergedRes, #1
    b MergeReturn$

  ContinueMerge$:

  teq newTile, #0
  moveq mergedTile, oldTile
  moveq hasMergedRes, #2
  beq MergeReturn$

  mov hasMergedRes, #0
  MergeErrorReturn$:
  mov mergedTile, minusOne

  MergeReturn$:
  .unreq oldTile
  .unreq newTile
  .unreq hasMerged

  .unreq mergedTile
  .unreq hasMergedRes

  .unreq minusOne
  pop {r4, pc}


@//Args: 0
@//Return: 1
@//    r0: score  <- not done yet
.global MoveLeft
MoveLeft:
  hasMoved .req r11 

  score .req r4
  boardIndex .req r4
  row .req r5
  col .req r6
  j .req r7
  val .req r8 
  resVal .req r9
  minusOne .req r10
  push {r4, r5, r6, r7, r8, r9, r10, lr}

  mov score, #0
  push {score}

  ldr boardIndex,=ActiveBoard
  ldr boardIndex,[boardIndex]
  ldr minusOne, =-1

  didMerges .req r3
  mov didMerges, #0
  
  mov row, #1
  LeftRowLoop$:
    add boardIndex, #24
    mov col, #2
    LeftColLoop$:
      mov j, col, lsl #2
      LeftWhile$:
        ldr val, [boardIndex, j]
        sub j, #4
        mov r0, val
        ldr r1, [boardIndex, j] 
        mov r2, didMerges, lsr row
        and r2, #1
        push {r2}
        bl Merge
        pop {r2}

        teq r1, #2
        beq LeftEndSetMerges$
          teq r2, #0
          orreq didMerges, r1, lsl row
          beq LeftEndSetMerges$

          eor r1, #1
          eor didMerges, r1, lsl row 

        LeftEndSetMerges$:

        teq r0, minusOne
        beq EndLeftWhile$

        mov resVal, r0

        teq hasMoved, #0
        moveq hasMoved, #1

        mov r0, #0
        add r1, j, #4
        str r0, [boardIndex, r1]
        str resVal, [boardIndex, j]

        push {didMerges}
        mov r0, row
        lsr r1, #2
        bl DrawColouredTile

        mov r0, row
        mov r1, j, lsr #2
        bl DrawColouredTile
        pop {didMerges}

        teq resVal, val
        beq LeftWhile$

        mov r0, boardIndex
        pop {score}
        add score, resVal
        push {score}
        mov boardIndex, r0

        teq resVal, #2048
        moveq hasMoved, #2
      EndLeftWhile$:
      
      add col, #1
      cmp col, #5
      blt LeftColLoop$

    add row, #1
    cmp row, #5
    blt LeftRowLoop$

  pop {r0}
  .unreq hasMoved
  .unreq didMerges
  .unreq score
  .unreq boardIndex
  .unreq row
  .unreq col
  .unreq j
  .unreq val
  .unreq resVal
  pop {r4, r5, r6, r7, r8, r9, r10, pc}


@//Args: 0
@//Return: 0
.global MoveUp
MoveUp:
  hasMoved .req r11 

  score .req r4
  boardIndex .req r4
  row .req r5
  col .req r6
  i .req r7
  val .req r8 
  resVal .req r9
  minusOne .req r10
  push {r4, r5, r6, r7, r8, r9, r10, lr}

  mov score, #0
  push {score}
  
  ldr boardIndex,=ActiveBoard
  ldr boardIndex,[boardIndex]
  add boardIndex, boardIndex, #24
  ldr minusOne, =-1

  didMerges .req r3
  mov didMerges, #0

  mov row, #2
  UpRowLoop$:
    add boardIndex, #24
    mov col, #1
    UpColLoop$:
      mov i, row
      mov r2, col, lsl #2
      UpWhile$:
        ldr val, [boardIndex, r2]
        sub i, #1
        sub r2, #24
        mov r0, val
        ldr r1, [boardIndex, r2]
        push {r2}
        mov r2, didMerges, lsr col
        and r2, #1
        push {r2}
        bl Merge
        pop {r2}

        teq r1, #2
        beq UpEndSetMerges$
          teq r2, #0
          orreq didMerges, r1, lsl col
          beq UpEndSetMerges$

          eor r1, #1
          eor didMerges, r1, lsl col 

        UpEndSetMerges$:

        pop {r2}
        teq r0, minusOne
        beq EndUpWhile$

        mov resVal, r0

        teq hasMoved, #0
        moveq hasMoved, #1

        mov r0, #0
        add r1, r2, #24
        str r0, [boardIndex, r1]
        str resVal, [boardIndex, r2]

        push {r2, didMerges}
        add r0, i, #1
        mov r1, col
        bl DrawColouredTile

        mov r0, i
        mov r1, col
        bl DrawColouredTile
        pop {r2, didMerges}

        teq resVal, val
        beq UpWhile$

        mov r0, boardIndex
        pop {score}
        add score, resVal
        push {score}
        mov boardIndex, r0

        teq resVal, #2048
        moveq hasMoved, #2
      EndUpWhile$:

      add col, #1
      cmp col, #5
      blt UpColLoop$
    
    add row, #1
    cmp row, #5
    blt UpRowLoop$

  pop {r0}
  .unreq hasMoved
  .unreq didMerges
  .unreq score
  .unreq boardIndex
  .unreq row
  .unreq col
  .unreq i
  .unreq val
  .unreq resVal
  pop {r4, r5, r6, r7, r8, r9, r10, pc}


@//Args: 0
@//Return: 0
.global MoveDown
MoveDown:
  hasMoved .req r11 

  score .req r4
  boardIndex .req r4
  row .req r5
  col .req r6
  i .req r7
  val .req r8 
  resVal .req r9
  minusOne .req r10
  push {r4, r5, r6, r7, r8, r9, r10, lr}

  mov score, #0
  push {score}

  ldr boardIndex,=ActiveBoard
  ldr boardIndex,[boardIndex]
  add boardIndex, boardIndex, #96
  ldr minusOne, =-1

  didMerges .req r3
  mov didMerges, #0

  mov row, #3
  DownRowLoop$:
    sub boardIndex, #24
    mov col, #1
    DownColLoop$:
      mov i, row
      mov r2, col, lsl #2
      DownWhile$:
        ldr val, [boardIndex, r2]
        add i, #1
        add r2, #24
        mov r0, val
        ldr r1, [boardIndex, r2]
        push {r2}
        mov r2, didMerges, lsr col
        and r2, #1
        push {r2}
        bl Merge
        pop {r2}

        teq r1, #2
        beq DownEndSetMerges$
          teq r2, #0
          orreq didMerges, r1, lsl col
          beq DownEndSetMerges$

          eor r1, #1
          eor didMerges, r1, lsl col 

        DownEndSetMerges$:

        pop {r2}
        teq r0, minusOne
        beq EndDownWhile$

        mov resVal, r0

        teq hasMoved, #0
        moveq hasMoved, #1

        mov r0, #0
        sub r1, r2, #24
        str r0, [boardIndex, r1]
        str resVal, [boardIndex, r2]

        push {r2, didMerges}
        sub r0, i, #1
        mov r1, col
        bl DrawColouredTile

        mov r0, i
        mov r1, col
        bl DrawColouredTile
        pop {r2, didMerges}

        teq resVal, val
        beq DownWhile$

        mov r0, boardIndex
        pop {score}
        add score, resVal
        push {score}
        mov boardIndex, r0

        teq resVal, #2048
        moveq hasMoved, #2
      EndDownWhile$:

      add col, #1
      cmp col, #5
      blt DownColLoop$
    
    sub row, #1
    cmp row, #1
    bge DownRowLoop$

  pop {r0}
  .unreq hasMoved
  .unreq didMerges
  .unreq score
  .unreq boardIndex
  .unreq row
  .unreq col
  .unreq i
  .unreq val
  .unreq resVal
  pop {r4, r5, r6, r7, r8, r9, r10, pc}


@//Args: 0
@//Return: 0
.global MoveRight
MoveRight:
  hasMoved .req r11 

  score .req r4
  boardIndex .req r4
  row .req r5
  col .req r6
  j .req r7
  val .req r8 
  resVal .req r9
  minusOne .req r10
  push {r4, r5, r6, r7, r8, r9, r10, lr}

  mov score, #0
  push {score}

  ldr boardIndex,=ActiveBoard
  ldr boardIndex,[boardIndex]
  ldr minusOne, =-1

  didMerges .req r3
  mov didMerges, #0

  mov row, #1
  RightRowLoop$:
    add boardIndex, #24
    mov col, #3
    RightColLoop$:
      mov j, col, lsl #2
      RightWhile$:
        ldr val, [boardIndex, j]
        add j, #4
        mov r0, val
        ldr r1, [boardIndex, j] 
        mov r2, didMerges, lsr row
        and r2, #1
        push {r2}
        bl Merge
        pop {r2}

        teq r1, #2
        beq RightEndSetMerges$
          teq r2, #0
          orreq didMerges, r1, lsl row
          beq RightEndSetMerges$

          eor r1, #1
          eor didMerges, r1, lsl row 

        RightEndSetMerges$:

        teq r0, minusOne 
        beq EndRightWhile$

        mov resVal, r0

        teq hasMoved, #0
        moveq hasMoved, #1

        mov r0, #0
        sub r1, j, #4
        str r0, [boardIndex, r1]
        str resVal, [boardIndex, j]

        push {didMerges}
        mov r0, row
        lsr r1, #2
        bl DrawColouredTile

        mov r0, row
        mov r1, j, lsr #2
        bl DrawColouredTile
        pop {didMerges}

        teq resVal, val
        beq RightWhile$

        mov r0, boardIndex
        pop {score}
        add score, resVal
        push {score}
        mov boardIndex, r0

        teq resVal, #2048
        moveq hasMoved, #2
      EndRightWhile$:
      
      sub col, #1
      cmp col, #1
      bge RightColLoop$

    add row, #1
    cmp row, #5
    blt RightRowLoop$

  pop {r0}
  .unreq hasMoved
  .unreq didMerges
  .unreq score
  .unreq boardIndex
  .unreq row
  .unreq col
  .unreq j
  .unreq val
  .unreq resVal
  pop {r4, r5, r6, r7, r8, r9, r10, pc}


@//Args: 0
@//Return: 1
@//    r0: isGameLost
.global IsGameLost
IsGameLost:
  boardIndex .req r4
  row .req r5
  col .req r6
  val .req r7
  delta .req r8
  next .req r9
  push {r4, r5, r6, r7, r8, r9, lr}    

  ldr boardIndex,=ActiveBoard
  ldr boardIndex,[boardIndex]
  mov delta, #24

  add boardIndex, delta
  mov row, #1
  mov r0, #0
  LostRowLoop$:
    mov col, #1
    add boardIndex, #4
    ldr val, [boardIndex]
    LostColLoop$:
      teq val, #0
      beq IsLostReturn$

      ldr next, [boardIndex, delta]
      teq val, next
      beq IsLostReturn$

      add boardIndex, #4
      ldr next, [boardIndex]
      teq val, next
      beq IsLostReturn$

      mov val, next

      add col, #1
      cmp col, #5
      blt LostColLoop$

    add boardIndex, #4
    add row, #1
    cmp row, #5
    blt LostRowLoop$

  mov r0, #16
  mov r1, #0
  bl SetGpio

  mov r0, #1

  IsLostReturn$:
  .unreq boardIndex
  .unreq row
  .unreq col
  .unreq val
  .unreq delta
  .unreq next
  pop {r4, r5, r6, r7, r8, r9, pc}


@//Args: 0
@//Return: 0
.global PlaceTile
PlaceTile:
  boardIndex .req r4
  row .req r5
  col .req r6
  delta .req r7
  val .req r8
  push {r4, r5, r6, r7, r8, lr}

  ldr boardIndex,=ActiveBoard
  ldr boardIndex,[boardIndex]
  While$:
    bl Random
    mov row, r0, lsr #30
    bl Random
    mov col, r0, lsr #30
    
    add row, #1
    add col, #1
    mov delta, #6
    mla delta, row, delta, col
    @//add delta, #7
    ldr r0, [boardIndex, delta, lsl #2]
    teq r0, #0
    bne While$
    
  add boardIndex, delta, lsl #2

  bl Random
  lsr r0, #21
  ldr r1, =1843
  cmp r0, r1
  blt Store2$
    mov val, #4
    b endStoreCond$
  Store2$:
    mov val, #2
  endStoreCond$:
  str val, [boardIndex]

  mov r0, row
  mov r1, col
  bl DrawColouredTile

  .unreq boardIndex
  .unreq row
  .unreq col
  .unreq delta
  .unreq val
  pop {r4, r5, r6, r7, r8, pc}


@//@//refactored
@//.globl StorePrevGrid
@//StorePrevGrid:
@//row .req r4
@//col .req r5
@//addr1 .req r6
@//addr2 .req r7
@//temp .req r8
@//push {r4,r5,r6,r7,r8}
@//ldr addr1,=grid
@//add addr1,addr1,#24
@//ldr addr2,=prevgrid
@//add addr2,addr2,#24
@//
@//mov row,#1
@//storePrevRowLoop$:
@//  
@//  add addr1,addr1,#4
@//  add addr2,addr2,#4
@//
@//  mov col,#1
@//  storePrevColLoop$:
@//
@//    ldr temp,[addr1]
@//    str temp,[addr2]
@//
@//    add addr1,addr1,#4
@//    add addr2,addr2,#4
@//
@//    add col,col,#1
@//    cmp col,#5
@//    blt storePrevColLoop$
@//
@//  add addr1,addr1,#4
@//  add addr2,addr2,#4
@//  add row,row,#1
@//  cmp row,#5
@//  blt storePrevRowLoop$
@//
@//pop {r4,r5,r6,r7,r8}
@//mov pc,lr
@//.unreq row
@//.unreq col
@//.unreq addr1
@//.unreq addr2
@//.unreq temp
@//

@//refactored
.globl HasEmptyTile
HasEmptyTile:
row .req r4 @//r0
col .req r5 @//r1
addr .req r6 @//r3
temp .req r7 @//r4
val .req r8 @//r5
push {r4,r5,r6,r7,r8}
mov row,#1
mov col,#1
hasEmptyRowLoop$:

  mov col,#1
  
  hasEmptyColLoop$:
    
    push {lr}
    mov r0,row
    mov r1,col
    bl GetBoardValue
    mov val,r0
    pop {lr}

    cmp val,#0
    beq returnHasEmpty$

    add col,col,#1
    cmp col,#5
    blt hasEmptyColLoop$

  add row,row,#1
  cmp row,#5
  blt hasEmptyRowLoop$

pop {r4,r5,r6,r7,r8}
mov r0,#0
mov pc,lr

returnHasEmpty$:
pop {r4,r5,r6,r7,r8}
mov r0,#1
mov pc,lr
.unreq row
.unreq col
.unreq addr
.unreq temp
.unreq val

@//refactored
.globl IsEmpty
IsEmpty:
row .req r0
col .req r1

push {lr}
bl GetBoardValue
pop {lr}

cmp r0,#0
moveq r0,#1
moveq pc,lr

mov r0,#0
mov pc,lr
.unreq row
.unreq col

@//refactored
.globl GetRandomEmptyPos
GetRandomEmptyPos:
row .req r4 @//r0
col .req r5 @//r1
temp .req r6 @//r2
iter .req r7 @//r3
push {r4,r5,r6,r7}

push {lr}
bl Random
mov iter,r0
pop {lr}

mov temp,#0x15
and iter,iter,temp
add iter,iter,#1

randEmptyLoopStart$:
mov row,#1
randEmptyRowLoop$:
  
  mov col,#1

  randEmptyColLoop$:

    push {lr}
    mov r0,row
    mov r1,col
    bl IsEmpty
    mov temp,r0
    pop {lr}
    
    cmp temp,#1
    subeq iter,iter,#1
    
    cmp iter,#0
    moveq r0,row
    moveq r1,col
    pople {r4,r5,r6,r7}
    movle pc,lr

    add col,col,#1
    cmp col,#5
    blt randEmptyColLoop$

  add row,row,#1
  cmp row,#5
  blt randEmptyRowLoop$

b randEmptyLoopStart$
pop {r4,r5,r6,r7}
mov pc,lr
.unreq row
.unreq col
.unreq temp
.unreq iter

@//Jacek
.globl PlaceTileBackup
PlaceTileBackup:
  row .req r4
  col .req r5 
  val .req r6 
  temp .req r7 
  rtemp .req r8 
  push {r4,r5,r6,r7,r8,lr}

  bl HasEmptyTile
  cmp r0,#0
  beq PlaceTileReturn$

  bl GetRandomEmptyPos
  mov row,r0
  mov col,r1

  bl Random
  mov rtemp,r0

  add rtemp,rtemp,#1

  mov temp,#7
  and rtemp,rtemp,temp

  mov r0,row
  mov r1,col

  cmp rtemp,#0
  bne placeTileElse1$
    mov r2,#4
    b endPlaceTileCond$
  placeTileElse1$:
    mov r2,#2
  endPlaceTileCond$:
  bl SetBoardValue

  mov r0, row
  mov r1, col
  bl DrawColouredTile

  PlaceTileReturn$:
  pop {r4,r5,r6,r7,r8,pc}
  .unreq row
  .unreq col
  .unreq temp
  .unreq val
  .unreq rtemp

@//Args: 0
@//Return: 0
.globl InitGame
InitGame:
  push {lr}

  bl ResetBoard
  bl PlaceTile
  bl DrawColouredBoard

  pop {pc}


@//Args: 0
@//Return: 0
.globl StartGame
StartGame:
  boardLocation .req r12 
  push {lr}

  mov r0,#0
  bl SetActiveBoard

  ldr r0, =FrameBufferInfo
  ldr r1, [r0, #8]
  lsr r1, #1
  ldr r2, [r0, #12]
  lsr r2, #1
  ldr r0, =BoardSpacing
  ldr r0, [r0] 
  lsr r0, #1
  @//add r0, r0, lsl #1
  ldr r3, =TileWidth
  ldr r3, [r3]
  add r3, r0, r3, lsl #1
  add r3, r0, lsl #1
  sub r1, r3
  mov r5, r3, lsl #1
  ldr r3, =TileHeight
  ldr r3, [r3]
  add r3, r0, r3, lsl #1
  add r3, r0, lsl #1
  sub r2, r3
  mov r6, r3, lsl #1
  ldr r4, =BoardPosX
  str r1, [r4]
  ldr r4, =BoardPosY
  str r2, [r4]

  push {r0, r1}
  ldr r0, =TileGridColour
  ldr r0, [r0]
  bl SetForeColour
  pop {r0, r1}

  add r5, r0, lsl #2
  add r6, r0, lsl #2
  sub r2, r0, lsl #1
  sub r0, r1, r0, lsl #1
  mov r1, r2
  mov r2, r5
  mov r3, r6
  bl DrawGrid

  @//ldr boardLocation, =Board
  mov r0,#0
  bl SetActiveBoard

  bl InitGame

  ldr r0,=GameMode
  mov r1,#0
  str r1,[r0]

  modeLoop$:
  ldr r0,=GameMode
  ldr r0,[r0]
  cmp r0,#0
  blne AIGame
  bleq MainGame
  b modeLoop$
  .unreq boardLocation
  pop {pc}
 

@//Args: 0
@//Return: 0
.globl MainGame
MainGame:
  hasMoved .req r11
  push {lr}

  InputLoop$:
    mov hasMoved, #0

    bl IsResetPressed
    teq r0, #1
    beq Reset$
 
    bl IsLeftPressed
    teq r0, #1
    beq Left$

    bl IsUpPressed
    teq r0, #1
    beq Up$

    bl IsRightPressed
    teq r0, #1
    beq Right$

    bl IsDownPressed
    teq r0, #1
    beq Down$

    bl CheckModeState
    teq r0,#1
    beq Mode$
    
    b InputLoop$

    Left$:
      bl MoveLeft
      b endMoveCond$
    Down$:
      bl MoveDown
      b endMoveCond$
    Up$:
      bl MoveUp
      b endMoveCond$
    Right$:
      bl MoveRight
      b endMoveCond$
    Mode$:
      ldr r0,=GameMode
      mov r1,#1
      str r1,[r0]
      pop {pc}
    endMoveCond$:
    
    teq hasMoved, #0
    beq InputLoop$

    bl PlaceTile
    @//bl DrawColouredBoard

    teq hasMoved, #2
    beq EndInputLoop$

    bl IsGameLost
    teq r0, #0
    beq InputLoop$

    mov r0, #0x3F0000
    bl Wait

    Reset$:
    bl InitGame
    b InputLoop$
  EndInputLoop$:

  .unreq hasMoved
  pop {pc}


@//Args: 2
@//    r0: row
@//    r1: col
@//Return: 1
@//    r0: value
.globl GetBoardValue
GetBoardValue:
  boardLocation .req r4
  delta .req r5
  push {r4, r5, lr}

  ldr boardLocation,=ActiveBoard
  ldr boardLocation,[boardLocation]
  lsl r1, #2
  mov delta, #24
  mla delta, r0, delta, r1
  ldr r0, [boardLocation, delta]

  .unreq boardLocation
  .unreq delta
  pop {r4, r5, pc}

@//Args: 3
@//    r0: row
@//    r1: col
@//    r2: val
@//Return: 0
.globl SetBoardValue
SetBoardValue:
  row .req r0
  col .req r1
  val .req r2

  boardLocation .req r4
  delta .req r5
  push {r4, r5, lr}

  ldr boardLocation,=ActiveBoard
  ldr boardLocation,[boardLocation]
  lsl col, #2
  mov delta, #24
  mla delta, row, delta, col
  str val, [boardLocation, delta]

  .unreq row
  .unreq col
  .unreq val

  .unreq boardLocation
  .unreq delta
  pop {r4, r5, pc}



.globl CopyBoard
CopyBoard:
row .req r4
col .req r5
addr1 .req r6
addr2 .req r7
temp .req r8
push {r4,r5,r6,r7,r8}
ldr addr1,=Board
add addr1,addr1,#24
ldr addr2,=BoardCopy
add addr2,addr2,#24

mov row,#1
copyBoardRowLoop$:
  
  add addr1,addr1,#4
  add addr2,addr2,#4

  mov col,#1
  copyBoardColLoop$:

    ldr temp,[addr1]
    str temp,[addr2]

    add addr1,addr1,#4
    add addr2,addr2,#4

    add col,col,#1
    cmp col,#5
    blt copyBoardColLoop$

  add addr1,addr1,#4
  add addr2,addr2,#4
  add row,row,#1
  cmp row,#5
  blt copyBoardRowLoop$

pop {r4,r5,r6,r7,r8}
mov pc,lr
.unreq row
.unreq col
.unreq addr1
.unreq addr2
.unreq temp

@//////////////////// AI //////////////////////////////////

@//Args: 0
@//Return: 0
.globl AIGame
AIGame:
  hasMoved .req r11
  push {lr}

  AILoop$:
    mov hasMoved, #0

    bl IsResetPressed
    teq r0, #1
    beq AIReset$

    bl CheckModeState
    teq r0,#1
    beq noModeChange$

      ldr r0,=GameMode
      mov r1,#0
      str r1,[r0]
      pop {pc}

    noModeChange$:

    bl AIStep
    
    teq hasMoved, #0
    beq AILoop$

    bl PlaceTile

    bl IsGameLost
    teq r0, #0
    beq AILoop$

    mov r0, #0x3F0000
    bl Wait
    
    AIReset$:
    bl InitGame
    b AILoop$
  EndAILoop$:

  .unreq hasMoved
  pop {pc}


.globl AIStep
AIStep:
bestDir .req r4
hasMoved .req r11
push {r4,lr}

@// bestDir : 1 up, 2 right, 3 down, 4 left
bl GetBestDir
mov bestDir,r0

mov hasMoved,#0
teq bestDir,#1
  beq aiUpStep$
teq bestDir,#2
  beq aiRightStep$
teq bestDir,#3
  beq aiDownStep$
teq bestDir,#4
  beq aiLeftStep$
 
aiUpStep$:
  bl MoveUp
  b endBestDir$
aiRightStep$:
  bl MoveRight
  b endBestDir$
aiDownStep$:
  bl MoveDown
  b endBestDir$
aiLeftStep$:
  bl MoveLeft
  b endBestDir$
  
endBestDir$:

pop {r4,pc}
.unreq bestDir
.unreq hasMoved

@// restul r0 : 1 up, 2 right, 3 down, 4 left
.globl GetBestDir
GetBestDir:
push {r4,r5,r6,lr}
bestScore .req r4
bestMove .req r5
iter .req r6

mov bestScore,#0
mov bestMove,#1

mov iter,#1
bestDirLoop$:

  mov r0,iter
  bl MultiRandomRun

  cmp r0,bestScore
  movgt bestScore,r0
  movgt bestMove,iter

  add iter,iter,#1
  cmp iter,#5
  blt bestDirLoop$

mov r0,bestMove
pop {r4,r5,r6,pc}
.unreq bestScore
.unreq bestMove
.unreq iter


@//args : r0 - dir
@//return : r0 - totalscore
.globl MultiRandomRun
MultiRandomRun:
dir .req r4
total .req r5
iter .req r6
push {r4,r5,r6,lr}

mov dir,r0

mov total,#0
mov iter,#0

multiRandomLoop$:

  mov r0,dir
  bl RandomRun
  add total,total,r0

  add iter,iter,#1
  cmp iter,#25
  blt multiRandomLoop$

mov r0,total
pop {r4,r5,r6,pc}
.unreq dir
.unreq total
.unreq iter

@//args : r0 0x3- dir
@//return : r0 - score
.globl RandomRun
RandomRun:
dir .req r4
score .req r5
hasMoved .req r11
push {r4,r5,lr}
mov dir,r0

bl CopyBoard
mov r0,#1
bl SetActiveBoard

mov hasMoved,#0
mov score,#0
mov r0,dir
bl MoveByDir
add score,score,r0
cmp hasMoved,#1
blge PlaceTile
blt randRunFail$

randomRunWhile$:

  bl Random
  lsr r0, #30
  add r0,r0,#1

  mov hasMoved,#0
  bl MoveByDir
  add score,score,r0
  cmp hasMoved,#1
  blge PlaceTile

  bl IsGameLost
  cmp r0,#0
  beq randomRunWhile$

randRunFail$:
mov r0,#0
bl SetActiveBoard
mov r0,score
pop {r4,r5,pc}
.unreq dir
.unreq score
.unreq hasMoved

@// arg r0: 1 up, 2 right, 3 down, 4 left
@//return r0 - score
.globl MoveByDir
MoveByDir:
hasMoved .req r11
push {r4, lr}
  teq r0, #1
  beq upDir$

  teq r0, #2
  beq rightDir$

  teq r0, #3
  beq downDir$

  teq r0, #4
  beq leftDir$

  bl Error

  leftDir$:
    bl MoveLeft
    b endMoveByDir$
  downDir$:
    bl MoveDown
    b endMoveByDir$
  upDir$:
    bl MoveUp
    b endMoveByDir$
  rightDir$:
    bl MoveRight

  endMoveByDir$:

pop {r4, pc}
.unreq hasMoved



.globl ShouldDraw
ShouldDraw:
ldr r0,=ActiveBoard
ldr r0,[r0]
ldr r1,=Board

cmp r0,r1
moveq r0,#1
moveq pc,lr

mov r0,#0
mov pc,lr



