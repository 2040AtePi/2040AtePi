.section .data
.align 4
.globl DrawTileInfo
DrawTileInfo:
.int 300
.int 23
.int 126
.int 22
.int 127
.int 18
.int 131
.int 16
.int 133
.int 14
.int 135
.int 12
.int 137
.int 11
.int 138
.int 9
.int 140
.int 8
.int 141
.int 7
.int 142
.int 6
.int 143
.int 6
.int 143
.int 5
.int 144
.int 4
.int 145
.int 4
.int 145
.int 3
.int 146
.int 3
.int 146
.int 2
.int 147
.int 2
.int 147
.int 1
.int 148
.int 1
.int 148
.int 1
.int 148
.int 1
.int 148
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 0
.int 149
.int 1
.int 148
.int 1
.int 148
.int 1
.int 148
.int 1
.int 148
.int 2
.int 147
.int 2
.int 147
.int 3
.int 146
.int 3
.int 146
.int 4
.int 145
.int 4
.int 145
.int 5
.int 144
.int 6
.int 143
.int 6
.int 143
.int 7
.int 142
.int 8
.int 141
.int 9
.int 140
.int 11
.int 138
.int 12
.int 137
.int 14
.int 135
.int 16
.int 133
.int 18
.int 131
.int 22
.int 127
.int 23
.int 126

.section .text
.globl DrawTile
DrawTile:
posX .req r4
posY .req r5
count .req r6
left .req r7
right .req r8
addr .req r9
push {r4,r5,r6,r7,r8,r9}
mov posX,r0
mov posY,r1

ldr addr,=DrawTileInfo
ldr count,[addr]
add addr,addr,#4
drawTileLoop1$:

  ldr left,[addr]
  add addr,addr,#4
  ldr right,[addr]
  add addr,addr,#4

  drawTileLoop2$:
    
    push {lr}
    mov r0,posX
    add r0,left
    mov r1,posY
    bl DrawPixel
    pop {lr}

    add left,left,#1

    cmp left,right
    ble drawTileLoop2$

  add posY,posY,#1
  
  sub count,count,#2
  cmp count,#0
  bgt drawTileLoop1$

.unreq posX
.unreq posY
.unreq count
.unreq left
.unreq right
.unreq addr
pop {r4,r5,r6,r7,r8,r9}
mov pc,lr


