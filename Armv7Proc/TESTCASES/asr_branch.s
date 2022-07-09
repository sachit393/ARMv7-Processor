add r0,r0,#4
mov r1,r0,ASR #1
mov r2, #-9
movs r3,r2,ASR #3
adc r5,r5,#1
add r4,r3,r1
cmp r4,#0
beq Ret1
mov r4,#1

Ret1:
cmp r5,#2
beq Ret2
mov r4,#1
Ret2: