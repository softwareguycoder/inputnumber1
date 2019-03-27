; 
; FILENAME:     inputnumber1.asm
; CREATED BY:   Brian Hart
; DATE:         15 Nov 2018
; PURPOSE:      Demonstrating gathering input from the user
;
; COMMENTS:     See <https://www.tutorialspoint.com/assembly_programming/assembly_quick_guide.htm>
;

section .data                                                   ;Data segment
   userPrompt db 'Please enter a number (-9999 to 9999): ',0x0                  ;Ask the user to enter a number
   userPromptLen equ $-userPrompt                                               ;The length of the message
   dispMsg db 'The value entered was: ',0x0                                     ;Output display prompt
   lenDispMsg equ $-dispMsg                                                     ;Length of the output display prompt

section .bss                                                                    ;Uninitialized data
   num resb 5
	
section .text                                                                   ;Code Segment
   global _start
	
_start:                                 ; User prompt
   mov eax, 4                           ; syscall number for sys_write
   mov ebx, 1                           ; STDOUT file descriptor
   mov ecx, userPrompt                  ; Address of the first char of the user prompt
   mov edx, userPromptLen               ; User prompt length
   int 80h                              ; call kernel

   ;Read and store the user input; since the user is going to type into
   ;the console, the input will come as ASCII codes.
   mov eax, 3                           ; syscall number for sys_read
   mov ebx, 2                           ; STDERR file descriptor-- better to read fromm STDERR than STDIN
   mov ecx, num                         ; address of the storage to receive the data
   mov edx, 5                           ; length (5 bytes numeric, 1 for sign) of that information
   int 80h                              ; call kernel
	
   ;Output the message 'The entered number is: '
   mov eax, 4                           ; syscall number for sys_write
   mov ebx, 1                           ; STDOUT file descriptor
   mov ecx, dispMsg                     ; Address of the first char of the display prompt
   mov edx, lenDispMsg                  ; display prompt length
   int 80h                              ; call the kernel

   ;Output the number entered
   mov eax, 4                           ; syscall number for sys_write
   mov ebx, 1                           ; STDOUT file descriptor
   mov ecx, num                         ; number to be displayed
   mov edx, 5                           ; length of the number to be displayed, in bytes
   int 80h                              ; call the kernel
    
   ; Exit the process
   mov eax, 1                           ; syscall number for sys_exit       
   mov ebx, 0                           ; process exit code
   int 80h                              ; call the kernel
