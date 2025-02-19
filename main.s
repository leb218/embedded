
;******************** (C) Yifeng ZHU *******************************************
; @file    main.s
; @author  Yifeng Zhu
; @date    May-17-2015
; @note
;           This code is for the book "Embedded Systems with ARM Cortex-M
;           Microcontrollers in Assembly Language and C, Yifeng Zhu,
;           ISBN-13: 978-0982692639, ISBN-10: 0982692633
; @attension
;           This code is provided for education purpose. The author shall not be
;           held liable for any direct, indirect or consequential damages, for any
;           reason whatever. More information can be found from book website:
;           http:;www.eece.maine.edu/~zhu/book
;*******************************************************************************


      INCLUDE core_cm4_constants.s        ; Load Constant Definitions
      INCLUDE stm32l476xx_constants.s      

      IMPORT      System_Clock_Init
      IMPORT      UART2_Init
      IMPORT      USART2_Write
      
      AREA    main, CODE, READONLY
      EXPORT      __main                        ; make __main visible to linker
      ENTRY             
                        
__main      PROC
      
; enable clocking on GPIOB
      LDR r0, =RCC_BASE ; set rCC_BASE instructions to register 0
      LDR r1, [r0, #RCC_AHB2ENR] ; set peripheral register & clocking to reg 1
      ORR r1, r1, #0x6 ; orring r1 with itself to enable specifically the pins that the clock can pass thru, activating both B abnd c!
      STR r1, [r0, #RCC_AHB2ENR] ; store the now clock-compatible peripheral setting back into r0
      
;1: WE NEED AN OUTPUT
; LET'S ENABLE OUR OUPUT PERIPHERALS IN PORT B
      ;GPIO_MODER EQU 0x00 ; sets moder equal to all 0s
      LDR   r0, =GPIOB_BASE ; load GPIOB to register 0
      LDR   r1, [r0, #GPIO_MODER] ; in r1, load the GPIO moder and GPIOB Base
      BIC r1, r1, #0x0000F000 ; clearing pins 7, 6, 3, 2 which we want to be our outputs
      BIC r1, r1, #0x000000F0 ; has to be done in separate step because god hates us ^
      ORR r1, r1, #0x00000050 ; setting our bits to output #maskmoment
      ORR r1, r1, #0x00005000 ; same idea
      STR r1, [r0, #GPIO_MODER] ; storing all our lovely work into r0
      
; setting up push/pull so we can have 2 activation types ( i think )
      LDR r0, =GPIOB_BASE ; load address of GPIOB to reg 0
      LDR r1, [r0, #GPIO_OTYPER] ; output type is being loaded as the "action" sort of deal for the r0 Gpiob data and set into r1
      BIC r1, r1, #0xCC ; clear output pins 2, 3, 6, and 7 --> they are the output pins for our whole config
      STR r1, [r0, #GPIO_OTYPER] ; store r1 contents to the address of r0.
 
; WE WANT OUR REGISTERS TO BE NO PULL-UP, NO PULL-DOWN SO THAT WE CAN MANIPULATE HARDWARE CORRECTLY
      ;GPIO_PUPDR EQU 0x00 ; sets pupdr to all 0's
      LDR r0, =GPIOB_BASE     ; load GPIOB's base structure into register 0
      LDR r1, [r0, #GPIO_PUPDR] ; overlay Pullup/pulldown instructions onto the GPIOB base in reg1
      BIC r1, r1, #0x000000F0 ; clear out only the PUPDR parts that we want to mask on (so the correct registers)
      BIC r1, r1, #0x0000F000 ; clear out only the PUPDR parts that we want to mask on (so the correct registers)
; since those registers are already at 00, we can then store it
      STR r1, [r0, #GPIO_PUPDR] ; maintain the manipulation so it can be understood by program.

;setting up the input pins
      LDR r0, =GPIOC_BASE ;loading the base register of GPIOC to r0
      LDR r1, [r0, #GPIO_MODER] ;offsetting the register to be the moder register
      BIC r1, r1,#0x0C000000 ;clearing the blue buttons pins, clearing it sets it to input which is 00
      STR r1, [r0, #GPIO_MODER] ;storing the contents of r1 into r0 witht the offset
      
;no pull up pull down for the push button
      LDR r0, =GPIOC_BASE; loading the base register to r0
      LDR r1, [r0, #GPIO_PUPDR] ;loading the register r0 offset to r1
      BIC r1, r1, #0x0C000000 ;clearing the bits of the push button to be 00
      STR r1,[r0, #GPIO_PUPDR] ; storing the contents of r1 back to r0 at the offset
      
; LOAD VAL LOCATED IN BASE REGISTER + OFFSET
	  LDR r0, =GPIOB_BASE ; loading base register
	  LDR r1, [r0, #GPIO_ODR] ;storing the offset register into r1
	  MOV r1, #0x0
	  STR r1, [r0, #GPIO_ODR] ;storing back into output register
	  
      
      ; CHANGE VAL WITH BITWISE OPERATIONS
      ; STORE VAL IN THE ADDRESS OF BASE REGISTER + OFFSET
      
      ;;;;;;;;; (LEC 7 HAS EXAMPLES) ;;;;;;;;;;;
      
      ; WRITE LOGIC FOR COUNNTING UP
      ; BE SURE TO INCLUDE RESET BUTTON
      
      
      
      
stop  B           stop              ; dead loop & program hangs here

      ENDP
                                                

      AREA myData, DATA, READWRITE
      ALIGN

      END