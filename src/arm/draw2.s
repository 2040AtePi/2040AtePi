.section .data
.align 4
.globl Draw2Info
Draw2Info:
.int 213
.int 45
.int 55
.int 96
.int 46
.int 55
.int 95
.int 47
.int 55
.int 95
.int 48
.int 55
.int 95
.int 49
.int 55
.int 95
.int 50
.int 55
.int 95
.int 51
.int 54
.int 96
.int 52
.int 48
.int 102
.int 53
.int 48
.int 102
.int 54
.int 48
.int 102
.int 55
.int 48
.int 102
.int 56
.int 48
.int 102
.int 57
.int 48
.int 102
.int 58
.int 48
.int 62
.int 58
.int 63
.int 73
.int 58
.int 74
.int 102
.int 59
.int 48
.int 61
.int 59
.int 75
.int 102
.int 60
.int 48
.int 61
.int 60
.int 75
.int 102
.int 61
.int 48
.int 61
.int 61
.int 75
.int 102
.int 62
.int 48
.int 61
.int 62
.int 75
.int 102
.int 63
.int 48
.int 61
.int 63
.int 75
.int 102
.int 64
.int 48
.int 61
.int 64
.int 75
.int 102
.int 65
.int 75
.int 102
.int 66
.int 75
.int 102
.int 67
.int 75
.int 102
.int 68
.int 75
.int 102
.int 69
.int 75
.int 102
.int 70
.int 75
.int 102
.int 71
.int 75
.int 102
.int 72
.int 69
.int 96
.int 73
.int 68
.int 95
.int 74
.int 68
.int 95
.int 75
.int 68
.int 95
.int 76
.int 68
.int 95
.int 77
.int 68
.int 95
.int 78
.int 68
.int 96
.int 79
.int 62
.int 89
.int 80
.int 61
.int 89
.int 81
.int 61
.int 89
.int 82
.int 61
.int 89
.int 83
.int 61
.int 89
.int 84
.int 61
.int 89
.int 85
.int 61
.int 89
.int 86
.int 55
.int 82
.int 87
.int 55
.int 82
.int 88
.int 55
.int 82
.int 89
.int 55
.int 82
.int 90
.int 55
.int 82
.int 91
.int 55
.int 82
.int 92
.int 54
.int 82
.int 93
.int 48
.int 102
.int 94
.int 48
.int 102
.int 95
.int 48
.int 102
.int 96
.int 48
.int 102
.int 97
.int 48
.int 102
.int 98
.int 48
.int 102
.int 99
.int 48
.int 102
.int 100
.int 48
.int 102
.int 101
.int 48
.int 102
.int 102
.int 48
.int 102
.int 103
.int 48
.int 102
.int 104
.int 48
.int 102
.int 105
.int 48
.int 102
.int 106
.int 48
.int 49
.int 106
.int 101
.int 102

.section .text
.globl Draw2
Draw2:
posX .req r4
posY .req r5
count .req r6
left .req r7
right .req r8
addr .req r9
tempY .req r10
push {r4,r5,r6,r7,r8,r9,r10}
mov posX,r0
mov posY,r1

ldr addr,=Draw2Info
ldr count,[addr]
add addr,addr,#4
loopDraw21$:

  ldr tempY,[addr]
  add addr,addr,#4
  ldr left,[addr]
  add addr,addr,#4
  ldr right,[addr]
  add addr,addr,#4
  sub count,count,#3
  
  loopDraw22$:

    push {lr}
    mov r0,posX
    add r0,r0,left
    mov r1,posY
    add r1,r1,tempY
    bl DrawPixel
    pop {lr}

    add left,left,#1
    cmp left,right
    blt loopDraw22$

  cmp count,#0
  bgt loopDraw21$

.unreq posX
.unreq posY
.unreq count
.unreq left
.unreq right
.unreq addr
.unreq tempY
pop {r4,r5,r6,r7,r8,r9,r10}
mov pc,lr
