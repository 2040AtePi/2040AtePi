.section .data
.align 4
.globl TileColours
TileColours:
.int 0xD617
.int 0xF75C
.int 0xF73A
.int 0xF590
.int 0xF46B
.int 0xFBEE
.int 0xEAE8
.int 0xFECF
.int 0xF64C
.int 0xF64C
.int 0xF64A
.int 0xF628

.int 0x41E7
.int 0x41E7
.int 0x41E7
.int 0x41E7
.int 0x41E7
.int 0x41E7

.align 4
.globl TextColours
TextColours:
.int 0xFFDE 
.int 0x7B8D

.align 4
.globl TileGridColour
TileGridColour:
.int 0xBD74

.align 4
.globl TileWidth
TileWidth:
.int 150

.align 4
.globl TileHeight
TileHeight:
.int 150

.align 4
.globl BoardPosX
BoardPosX:
.int 172

.align 4
.globl BoardPosY
BoardPosY:
.int 44

.align 4
.globl BoardSpacing
BoardSpacing:
.int 20

.section .text
@//Args: 1
@//    r0: number
@//Return: 0
.globl SetForeColourForTile
SetForeColourForTile:
tileColourLocation .req r4
push {r4, lr}

ldr tileColourLocation, =TileColours
ldr r0, [tileColourLocation, r0, lsl #2]
bl SetForeColour

.unreq tileColourLocation
pop {r4, pc}

@//Args: 1
@//    r0: number
@//Return: 0
.globl SetForeColourForText
SetForeColourForText:
number .req r0
push {lr}

ldr r1, =TextColours

cmp number, #2
bgt TextGreaterThanFour$
  ldr r0, [r1, #4]
  b EndTextCond$
TextGreaterThanFour$:
  ldr r0, [r1]
EndTextCond$:

bl SetForeColour

.unreq number
pop {pc}

@//Args: 3
@//  r0: posX
@//  r1: posY
@//  r2: number
.globl DrawNumber
DrawNumber:
posX .req r4
posY .req r5
number .req r6
push {r4, r5, r6, lr}

mov posX, r0
mov posY, r1
mov number, r2

teq number, #0
beq DrawNumberReturn$ 

@//////////////

teq number,#1
bne notDraw2$
bl Draw2
b DrawNumberReturn$
notDraw2$:

teq number,#2
bne notDraw4$
bl Draw4
b DrawNumberReturn$
notDraw4$:

teq number,#3
bne notDraw8$
bl Draw8
b DrawNumberReturn$
notDraw8$:

teq number,#4
bne notDraw16$
bl Draw16
b DrawNumberReturn$
notDraw16$:

teq number,#5
bne notDraw32$
bl Draw32
b DrawNumberReturn$
notDraw32$:

teq number,#6
bne notDraw64$
bl Draw64
b DrawNumberReturn$
notDraw64$:

teq number,#7
bne notDraw128$
bl Draw128
b DrawNumberReturn$
notDraw128$:

teq number,#8
bne notDraw256$
bl Draw256
b DrawNumberReturn$
notDraw256$:

teq number,#9
bne notDraw512$
bl Draw512
b DrawNumberReturn$
notDraw512$:

teq number,#10
bne notDraw1024$
bl Draw1024
b DrawNumberReturn$
notDraw1024$:

teq number,#11
bne notDraw2048$
bl Draw2048
b DrawNumberReturn$
notDraw2048$:

teq number,#12
bne notDraw4096$
bl Draw4096
b DrawNumberReturn$
notDraw4096$:

teq number,#13
bne notDraw8192$
bl Draw8192
b DrawNumberReturn$
notDraw8192$:

teq number,#14
bne notDraw16384$
bl Draw16384
b DrawNumberReturn$
notDraw16384$:

teq number,#15
bne notDraw32768$
bl Draw32768
b DrawNumberReturn$
notDraw32768$:

teq number,#16
bne notDraw65536$
bl Draw65536
b DrawNumberReturn$
notDraw65536$:

teq number,#17
bne DrawNumberReturn$
bl Draw131072

@//////////////

DrawNumberReturn$:
pop {r4, r5, r6, pc}
.unreq posX
.unreq posY
.unreq number

@//Args: 0
@//Return: 1
@//    r0: tileWidth
.globl GetTileWidth
GetTileWidth:
push {lr}

ldr r0, =TileWidth
ldr r0, [r0]

pop {pc}

@//Args: 0
@//Return: 1
@//    r0: tileHeight
.globl GetTileHeight
GetTileHeight:
push {lr}

ldr r0, =TileHeight
ldr r0, [r0]

pop {pc}


@//Args: 0
@//Return: 1
@//    r1: boardPosX
.globl GetBoardPosX
GetBoardPosX:
push {lr}

ldr r0, =BoardPosX
ldr r0, [r0]

pop {pc}

@//Args: 0
@//Return: 1
@//    r0: boardPosY
.globl GetBoardPosY
GetBoardPosY:
push {lr}

ldr r0, =BoardPosY
ldr r0, [r0]

pop {pc}

@//Args: 0
@//Return: 1
@//    r0: boardSpacing
.globl GetBoardSpacing
GetBoardSpacing:
spacing .req r0
addr .req r1
ldr addr,=BoardSpacing
ldr spacing,[addr]
mov pc,lr
.unreq spacing
.unreq addr

@//Args: 1
@//    r0: value
@//Return: 1
@//    r0: number
.globl GetNumByValue
GetNumByValue:
value .req r4
push {r4, lr}

mov value, r0

teq value, #0
moveq r0, #0
beq returnNumByValue$

teq value, #2
moveq r0, #1
beq returnNumByValue$

teq value, #4
moveq r0, #2
beq returnNumByValue$

teq value, #8
moveq r0, #3
beq returnNumByValue$

teq value, #16
moveq r0, #4
beq returnNumByValue$

teq value, #32
moveq r0, #5
beq returnNumByValue$

teq value, #64
moveq r0, #6
beq returnNumByValue$

teq value, #128
moveq r0, #7
beq returnNumByValue$

teq value, #256
moveq r0, #8
beq returnNumByValue$

teq value, #512
moveq r0, #9
beq returnNumByValue$

teq value, #1024
moveq r0, #10
beq returnNumByValue$

teq value, #2048
moveq r0, #11
beq returnNumByValue$

teq value, #4096
moveq r0, #12
beq returnNumByValue$

teq value, #8192
moveq r0, #13
beq returnNumByValue$

teq value, #16384
moveq r0, #14
beq returnNumByValue$

teq value, #32768
moveq r0, #15
beq returnNumByValue$

teq value, #65536
moveq r0, #16
beq returnNumByValue$

teq value, #131072
moveq r0, #17
beq returnNumByValue$

returnNumByValue$:
.unreq value
pop {r4, pc}


@//Args: 2
@//    r0: row
@//    r1: col
@//Return: 0
.globl DrawColouredTile
DrawColouredTile:
row .req r0
col .req r1

posX .req r4
posY .req r5
width .req r6
height .req r7
number .req r8
push {r4, r5, r6, r7, r8, lr}

sub posY, row, #1
sub posX, col, #1
.unreq row
.unreq col

push {r0,r1}
bl ShouldDraw
cmp r0,#0
popeq {r0,r1}
popeq {r4, r5, r6, r7, r8,  pc}
pop {r0,r1}

bl GetBoardValue
bl GetNumByValue
mov number, r0

bl GetTileWidth
mov width, r0
bl GetTileHeight
mov height, r0

bl GetBoardSpacing
add r1, width, r0
add r2, height, r0

mul posX, r1, posX 
mul posY, r2, posY

bl GetBoardPosX
add posX, r0

bl GetBoardPosY
add posY, r0

mov r0, number
bl SetForeColourForTile

mov r0, posX
mov r1, posY
mov r2, width
mov r3, height
@//bl DrawTile
bl DrawGrid

mov r0, number
bl SetForeColourForText

mov r0, posX
mov r1, posY
mov r2, number
bl DrawNumber

pop {r4, r5, r6, r7, r8,  pc}
.unreq posX
.unreq posY
.unreq width
.unreq height
.unreq number


@//Args: 0
@//Return: 0
.globl DrawColouredBoard
DrawColouredBoard:
row .req r4
col .req r5
push {r4, r5, lr}

mov col, #1
colouredGridCol$:
  mov row, #1
  colouredGridRow$:
    mov r0, row
    mov r1, col
    bl DrawColouredTile

    add row, #1
    cmp row, #5
    blt colouredGridRow$

  add col, #1
  cmp col, #5
  blt colouredGridCol$

.unreq row
.unreq col
pop {r4, r5, pc}

@//Args: 0
@//Return: 0
.globl ClearBoard
ClearBoard:
push {lr}

ldr r0, =0x0
bl SetForeColour
ldr r0, =FrameBufferInfo
ldr r2, [r0]
ldr r3, [r0,#4]
mov r0, #0
mov r1, #0
bl DrawGrid

pop {pc}


