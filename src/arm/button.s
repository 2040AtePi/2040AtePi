.section .text
@//Args: 1
@//    r0: pinNum
@//Return: 1
@//    r0: isPinOn
.globl IsOn
IsOn:
ldr r1, =0x20200000

ldr r2, [r1, #0x34]
mov r3, #1
mov r3, r3, lsl r0

and r0, r2, r3
teq r0, #0
beq returnIsOn$
mov r0, #1
returnIsOn$:
mov pc,lr

@//Args: 0
@//Return: 1
@//    r0: isRightPressed
.globl IsRightPressed
IsRightPressed:
mov r0,#17
push {lr}
bl IsOn
pop {pc}

@//Args: 0
@//Return: 1
@//    r0: isUpPressed
.globl IsUpPressed
IsUpPressed:
mov r0,#18
push {lr}
bl IsOn
pop {pc}

@//Args: 0
@//Return: 1
@//    r0: isDownPressed
.globl IsDownPressed
IsDownPressed:
mov r0,#22
push {lr}
bl IsOn
pop {pc}

@//Args: 0
@//Return: 1
@//    r0: isLeftPressed
.globl IsLeftPressed
IsLeftPressed:
mov r0,#23
push {lr}
bl IsOn
pop {pc}

@//Args: 0
@//Return: 1
@//    r0: modeState
.globl CheckModeState
CheckModeState:
mov r0,#24
push {lr}
bl IsOn
pop {pc}

@//Args: 0
@//Return: 1
@//    r0: isResetPressed
.global IsResetPressed
IsResetPressed:
mov r0,#25
push {lr}
bl IsOn
pop {pc}

@//refactored
.globl ProcessInput
ProcessInput:
movDir .req r0
res .req r1
push {lr}

bl IsUpPressed
mov res,r0
cmp res,#1
moveq r0,#1
popeq {pc}

bl IsRightPressed
mov res,r0
cmp res,#1
moveq r0,#2
popeq {pc}

bl IsDownPressed
mov res,r0
cmp res,#1
moveq r0,#3
popeq {pc}

bl IsLeftPressed
mov res,r0
cmp res,#1
moveq r0,#4
popeq {pc}

mov r0,#0
pop {pc}
.unreq movDir
.unreq res
