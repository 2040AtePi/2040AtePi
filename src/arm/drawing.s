.section .data
.align 4
foreColour:
.int 0xFFFF

.align 4
graphicsAddress:
.int 0

.align 4
.globl BackgroundColour
BackgroundColour:
.int 0xFFFF

.section .text
.globl SetForeColour
SetForeColour:
cmp r0,#0x10000
movcs pc,lr
ldr r1,=foreColour
str r0,[r1]
mov pc,lr


.globl SetForeColourForBackground
SetForeColourForBackground:
ldr r0,=BackgroundColour
ldr r0,[r0]
push {lr}
bl SetForeColour
pop {pc}


.globl DrawBackground
DrawBackground:
x .req r4
y .req r5
screenWidth .req r6
screenHeight .req r7
push {r4,r5,r6,r7}

push {lr}
bl SetForeColourForBackground

bl GetScreenWidth
mov screenWidth,r0

bl GetScreenHeight
mov screenHeight,r0
pop {lr}

mov x,#0
mov y,#0
drawBackgroundXLoop$:

  mov x,#0
  drawBackgroundYLoop$:

    push {lr}
    mov r0,x
    mov r1,y
    bl DrawPixel
    pop {lr}

    add x,x,#1
    cmp x,screenWidth
    blt drawBackgroundYLoop$

  add y,y,#1
  cmp y,screenHeight
  blt drawBackgroundXLoop$

pop {r4,r5,r6,r7}
mov pc,lr
.unreq x
.unreq y
.unreq screenWidth
.unreq screenHeight


.globl SetGraphicsAddress
SetGraphicsAddress:
ldr r1,=graphicsAddress
str r0,[r1]
mov pc,lr

.globl GetScreenWidth
GetScreenWidth:
width .req r0
addr .req r1
ldr addr,=graphicsAddress
ldr addr,[addr]
ldr width,[addr,#0]
mov pc,lr
.unreq width
.unreq addr

.globl GetScreenHeight
GetScreenHeight:
height .req r0
addr .req r1
ldr addr,=graphicsAddress
ldr addr,[addr]
ldr height,[addr,#4]
mov pc,lr
.unreq height
.unreq addr

.globl DrawPixel
DrawPixel:
px .req r0
py .req r1
addr .req r2
ldr addr,=graphicsAddress
ldr addr,[addr]

height .req r3
ldr height,[addr,#4]
sub height,#1
cmp py,height
movhi pc,lr
.unreq height

width .req r3
ldr width,[addr,#0]
sub width,#1
cmp px,width
movhi pc,lr

ldr addr,[addr,#32]
add width,#1
mla px,py,width,px
.unreq width
.unreq py
add addr, px,lsl #1
.unreq px

fore .req r3
ldr fore,=foreColour
ldr fore,[fore]

strh fore,[addr]
.unreq fore
.unreq addr
mov pc,lr

.globl DrawGrid
DrawGrid:
posX .req r4
posY .req r5
tempX .req r6
tempY .req r7
width .req r8
height .req r9
push {r4,r5,r6,r7,r8,r9}
mov posX,r0
mov posY,r1
mov width,r2
mov height,r3

mov r0, posX
mov r1, posY
mov tempX,#0
mov tempY,#0
tileRow$:

  mov tempX,#0
  tileCol$:
    push {lr}
    mov r0,posX
    add r0,r0,tempX
    mov r1,posY
    add r1,r1,tempY
    bl DrawPixel
    pop {lr}
    add tempX,tempX,#1
    cmp tempX,width 
    blt tileCol$
  
  add tempY,tempY,#1
  cmp tempY,height
  blt tileRow$

push {lr}
mov r0,posX
mov r1,posY
pop {lr}

.unreq width 
.unreq height
.unreq posX
.unreq posY
.unreq tempX
.unreq tempY
pop {r4,r5,r6,r7,r8,r9}
mov pc,lr
