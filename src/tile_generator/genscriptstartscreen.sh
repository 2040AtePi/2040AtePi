#!/bin/bash

generate_data(){
cat <<- _EOF_
.section .data
.align 4
.globl DrawStartScreen${1}Info
DrawStartScreen${1}Info:
$(./generatorout startscreenimages/startscreen${1}.png)
_EOF_
}

generate_function(){
cat << _EOF_
.section .text
.globl DrawStartScreen$1
DrawStartScreen$1:
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

ldr addr,=DrawStartScreen${1}Info
ldr count,[addr]
add addr,addr,#4
loopDrawStartScreen${1}1\$:

  ldr tempY,[addr]
  add addr,addr,#4
  ldr left,[addr]
  add addr,addr,#4
  ldr right,[addr]
  add addr,addr,#4
  sub count,count,#3
  
  loopDrawStartScreen${1}2\$:

    push {lr}
    mov r0,posX
    add r0,r0,left
    mov r1,posY
    add r1,r1,tempY
    bl DrawPixel
    pop {lr}

    add left,left,#1
    cmp left,right
    blt loopDrawStartScreen${1}2\$

  cmp count,#0
  bgt loopDrawStartScreen${1}1\$

.unreq posX
.unreq posY
.unreq count
.unreq left
.unreq right
.unreq addr
.unreq tempY
pop {r4,r5,r6,r7,r8,r9,r10}
mov pc,lr

_EOF_
}

generate_file(){
cat <<- _EOF_
$(generate_data $1)

$(generate_function $1)

_EOF_
}


for f in startscreenimages/*; do
  temp=${f//startscreenimages\/startscreen/}
  temp=${temp//.png/}
  number="$temp"
  filename="generated/drawstartscreen$number.s"
 
  if [[ -n $filename ]]; then
    if touch $filename && [[ -f $filename ]]; then
      generate_file $number > $filename
    else
      echo "Cannot generate file"
    fi
  else
    echo "ERROR"
  fi
done

