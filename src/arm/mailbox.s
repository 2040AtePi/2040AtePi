@// This code has been written with help of Cambrige Baking Pi Tutorial
@// http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/index.html

.globl GetMailboxBase
GetMailboxBase:
ldr r0,=0x2000B880
mov pc,lr

.globl MailboxWrite
MailboxWrite:
tst r0,#0b1111
movne pc,lr
cmp r1,#15
movhi pc,lr
channel .req r1
value .req r2
mov value,r0
push {lr}
bl GetMailboxBase
mailbox .req r0
wait1$:
status .req r3
ldr status,[mailbox,#0x18]
tst status,#0x80000000
.unreq status
bne wait1$
add value,channel
.unreq channel
str value,[mailbox,#0x20]
.unreq value
.unreq mailbox
pop {pc}


.globl MailboxRead
MailboxRead:
cmp r0,#15
movhi pc,lr
channel .req r1
mov channel,r0
push {lr}
bl GetMailboxBase
mailbox .req r0
rightmail$:
wait2$:
status .req r2
ldr status,[mailbox,#0x18]
tst status,#0x40000000
.unreq status
bne wait2$
mail .req r2
ldr mail,[mailbox,#0]
inchan .req r3
and inchan,mail,#0b1111
teq inchan,channel
.unreq inchan
bne rightmail$
.unreq mailbox
.unreq channel
and r0,mail,#0xfffffff0
.unreq mail
pop {pc}

