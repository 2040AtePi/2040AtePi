.section .data
.align 4
IsError:
.int 0

.section .text
.globl Wait
Wait:
mov r3,#0x1F0000
waitLoop$:
sub r3,#1
teq r3,#0
bne waitLoop$
mov pc,lr

.globl Error
Error:
mov r0,#16
mov r1,#1
push {r0,r1,r2,r3,lr}
bl SetGpioFunction
pop {r0,r1,r2,r3,lr}
mov r0,#16
mov r1,#0
push {r0,r1,r2,r3,lr}
bl SetGpio
pop {r0,r1,r2,r3,lr}
push {r0,r1,r2,r3,lr}
mov r0,#1
bl SetIsError
pop {r0,r1,r2,r3,lr}
mov pc,lr

.globl ErrorOff
ErrorOff:
mov r0,#16
mov r1,#1
push {r0,r1,r2,r3,lr}
bl SetGpioFunction
pop {r0,r1,r2,r3,lr}
mov r0,#16
mov r1,#1
push {r0,r1,r2,r3,lr}
bl SetGpio
pop {r0,r1,r2,r3,lr}
push {r0,r1,r2,r3,lr}
mov r0,#0
bl SetIsError
pop {r0,r1,r2,r3,lr}
mov pc,lr

.globl GetIsError
GetIsError:
res .req r0
addr .req r1
ldr addr,=IsError
ldr res,[addr]
mov pc,lr
.unreq res
.unreq addr

.globl SetIsError
SetIsError:
val .req r0
addr .req r1
ldr addr,=IsError
str val,[addr]
mov pc,lr
.unreq val
.unreq addr

.globl ToggleError
ToggleError:
res .req r0
addr .req r1
temp .req r2
push {r1,r2,r3,lr}
bl Wait
bl GetIsError
pop {r1,r2,r3,lr}

cmp r0,#0
beq errorOn$

push {lr}
bl ErrorOff
pop {lr}
mov pc,lr

errorOn$:
push {lr}
bl Error
pop {lr}

mov pc,lr
.unreq res
.unreq addr
.unreq temp

