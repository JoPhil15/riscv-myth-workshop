.section .text 
.global load 
.type load, @function 
load: 
add a4,ao, zero //Intialize sum register a4 with 0x0 
add a2,a0, a1 //store count of 10 in register a2, a1 is loaded with oxa from mian 
add a3, ao, zero //initlaise intermediate sum reg a3 by 0 
loop: 
add a4,a3,a4 //incremental addition 
addi a3,a3,1 //incrememnt intermediate register by 1 
bit a3, a2, loop //if a3 is less than a2, branch to label named <loop> 
add ao,a4, zero //storefinal result to ao so that it can be read by main 
