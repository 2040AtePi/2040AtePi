.section .data
.align 4
.globl Draw8Info
Draw8Info:
.int 276
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
.int 69
.int 58
.int 70
.int 80
.int 58
.int 81
.int 102
.int 59
.int 48
.int 68
.int 59
.int 82
.int 102
.int 60
.int 48
.int 68
.int 60
.int 82
.int 102
.int 61
.int 48
.int 68
.int 61
.int 82
.int 102
.int 62
.int 48
.int 68
.int 62
.int 82
.int 102
.int 63
.int 48
.int 68
.int 63
.int 82
.int 102
.int 64
.int 48
.int 68
.int 64
.int 82
.int 102
.int 65
.int 48
.int 68
.int 65
.int 82
.int 102
.int 66
.int 48
.int 68
.int 66
.int 82
.int 102
.int 67
.int 48
.int 68
.int 67
.int 82
.int 102
.int 68
.int 48
.int 68
.int 68
.int 82
.int 102
.int 69
.int 48
.int 68
.int 69
.int 82
.int 102
.int 70
.int 48
.int 68
.int 70
.int 82
.int 102
.int 71
.int 48
.int 68
.int 71
.int 82
.int 102
.int 72
.int 54
.int 96
.int 73
.int 55
.int 95
.int 74
.int 55
.int 95
.int 75
.int 55
.int 95
.int 76
.int 55
.int 95
.int 77
.int 55
.int 95
.int 78
.int 55
.int 96
.int 79
.int 48
.int 68
.int 79
.int 82
.int 102
.int 80
.int 48
.int 68
.int 80
.int 82
.int 102
.int 81
.int 48
.int 68
.int 81
.int 82
.int 102
.int 82
.int 48
.int 68
.int 82
.int 82
.int 102
.int 83
.int 48
.int 68
.int 83
.int 82
.int 102
.int 84
.int 48
.int 68
.int 84
.int 82
.int 102
.int 85
.int 48
.int 68
.int 85
.int 82
.int 102
.int 86
.int 48
.int 68
.int 86
.int 82
.int 102
.int 87
.int 48
.int 68
.int 87
.int 82
.int 102
.int 88
.int 48
.int 68
.int 88
.int 82
.int 102
.int 89
.int 48
.int 68
.int 89
.int 82
.int 102
.int 90
.int 48
.int 68
.int 90
.int 82
.int 102
.int 91
.int 48
.int 68
.int 91
.int 82
.int 102
.int 92
.int 48
.int 68
.int 92
.int 82
.int 102
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
.int 55
.int 96
.int 101
.int 55
.int 95
.int 102
.int 55
.int 95
.int 103
.int 55
.int 95
.int 104
.int 55
.int 95
.int 105
.int 55
.int 96
.int 106
.int 55
.int 56
.int 106
.int 94
.int 95

.section .text
.globl Draw8
Draw8:
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

ldr addr,=Draw8Info
ldr count,[addr]
add addr,addr,#4
loopDraw81$:

  ldr tempY,[addr]
  add addr,addr,#4
  ldr left,[addr]
  add addr,addr,#4
  ldr right,[addr]
  add addr,addr,#4
  sub count,count,#3
  
  loopDraw82$:

    push {lr}
    mov r0,posX
    add r0,r0,left
    mov r1,posY
    add r1,r1,tempY
    bl DrawPixel
    pop {lr}

    add left,left,#1
    cmp left,right
    blt loopDraw82$

  cmp count,#0
  bgt loopDraw81$

.unreq posX
.unreq posY
.unreq count
.unreq left
.unreq right
.unreq addr
.unreq tempY
pop {r4,r5,r6,r7,r8,r9,r10}
mov pc,lr
