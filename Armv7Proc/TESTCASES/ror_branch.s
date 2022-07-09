mov r0,#-3
mov r1,r0, ROR #30
eor r2,r1,r0, LSL #1
cmp r2,#13
beq L
mov r4,#1
b Ret
L:
mov r4,#0
Ret:
