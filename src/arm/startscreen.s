.section .data
.align 4
.globl DrawStartScreenColours
DrawStartScreenColours:
.int 0xFFFF
.int 0x4BF5
.int 0x5D19
.int 0xF626
.int 0xFDB0
.int 0xF205
.int 0xFFFF

.section .text
.globl DrawStartScreen
DrawStartScreen:
addr .req r4
push {r4,lr}

ldr addr,=DrawStartScreenColours
ldr r0,[addr]
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen1

add addr,addr,#4

ldr r0,[addr]
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen2

add addr,addr,#4

ldr r0,[addr]
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen3

add addr,addr,#4

ldr r0,[addr]
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen4

add addr,addr,#4

ldr r0,[addr]
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen5

add addr,addr,#4

ldr r0,[addr]
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen6

add addr,addr,#4

ldr r0,[addr]
bl SetForeColour
mov r0,#0
mov r1,#0
bl DrawStartScreen7

pop {r4,pc}
.unreq addr


