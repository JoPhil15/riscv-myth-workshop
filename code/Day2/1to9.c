#include<stdio.h> 
extern int load(int x, int y); //fn initialisation 
int main() 
{ 
int result = 0; 
int count = 9; 
result = load(0x0, count+1); //receives data in the ao register, also those 2 arg are passed to the fn 
printf("Sum of numbers from 1 to %d is %d \n",count, result); 
}
