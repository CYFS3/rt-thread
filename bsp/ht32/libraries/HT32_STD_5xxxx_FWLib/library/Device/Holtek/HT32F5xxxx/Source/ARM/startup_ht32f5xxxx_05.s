;/*---------------------------------------------------------------------------------------------------------*/
;/* Holtek Semiconductor Inc.                                                                               */
;/*                                                                                                         */
;/* Copyright (C) Holtek Semiconductor Inc.                                                                 */
;/* All rights reserved.                                                                                    */
;/*                                                                                                         */
;/*-----------------------------------------------------------------------------------------------------------
;  File Name        : startup_ht32f5xxxx_05.s
;  Version          : $Rev:: 7935         $
;  Date             : $Date:: 2024-08-08 #$
;  Description      : Startup code.
;-----------------------------------------------------------------------------------------------------------*/

;  Supported Device
;  ========================================
;   HT32F57331, HT32F57341
;   HT32F57342, HT32F57352
;   HT32F59741
;   HT32F5828
;   HT32F67742
;   HT32F59746
;   HT32F57541
;   HT32F57552

;/* <<< Use Configuration Wizard in Context Menu >>>                                                        */

;// <o>  HT32 Device
;// <i> Select HT32 Device for the assembly setting. 
;// <i> Notice that the project's Asm Define has the higher priority.
;//      <0=> By Project Asm Define
;//      <13=> HT32F57331/41
;//      <14=> HT32F57342/52
;//      <13=> HT32F59741
;//      <14=> HT32F5828
;//      <13=> HT32F67742
;//      <13=> HT32F59746
;//      <13=> HT32F57541
;//      <14=> HT32F57552
USE_HT32_CHIP_SET   EQU     0 ; Notice that the project's Asm Define has the higher priority.

_HT32FWID           EQU     0xFFFFFFFF
;_HT32FWID           EQU     0x00057331
;_HT32FWID           EQU     0x00057341
;_HT32FWID           EQU     0x00057342
;_HT32FWID           EQU     0x00057352
;_HT32FWID           EQU     0x00059741
;_HT32FWID           EQU     0x00005828
;_HT32FWID           EQU     0x00067742
;_HT32FWID           EQU     0x00059746
;_HT32FWID           EQU     0x00057541
;_HT32FWID           EQU     0x00057552

HT32F57331_41       EQU     13
HT32F57342_52       EQU     14
HT32F59741          EQU     13
HT32F5828           EQU     14
HT32F67742          EQU     13
HT32F59746          EQU     13
HT32F57541          EQU     13
HT32F57552          EQU     14

  IF USE_HT32_CHIP_SET=0
  ; Use project's Asm Define setting (default)
  ELSE
  IF :DEF:USE_HT32_CHIP
  ; Use project's Asm Define setting (higher priority than the "USE_HT32_CHIP_SET")
  ELSE
  ; Use "USE_HT32_CHIP_SET" in the "startup_ht32xxxxx_xx.s" file
USE_HT32_CHIP       EQU     USE_HT32_CHIP_SET
  ENDIF
  ENDIF

; Amount of memory (in bytes) allocated for Stack and Heap
; Tailor those values to your application needs

;//   <o> Stack Location
;//       <0=> After the RW/ZI/Heap (Default)
;//       <1=> On the top of the SRAM (The end of the SRAM)
USE_STACK_ON_TOP    EQU     0

;//   <o> Stack Size (in Bytes, must 8 byte aligned) <0-16384:8>
;//       <i> Only meanful when the Stack Location = "After the RW/ZI/Heap" (USE_STACK_ON_TOP = 0).
Stack_Size          EQU     512

                    AREA    STACK, NOINIT, READWRITE, ALIGN = 3
__HT_check_sp
Stack_Mem           SPACE   Stack_Size
  IF (USE_STACK_ON_TOP = 1)
__initial_sp        EQU 0x20000000 + USE_LIBCFG_RAM_SIZE
  ELSE
__initial_sp
  ENDIF

;//   <o>  Heap Size (in Bytes) <0-16384:8>
Heap_Size           EQU     0

                    AREA    HEAP, NOINIT, READWRITE, ALIGN = 3
__HT_check_heap
__heap_base
Heap_Mem            SPACE   Heap_Size
__heap_limit

                    PRESERVE8
                    THUMB

;*******************************************************************************
; Fill-up the Vector Table entries with the exceptions ISR address
;*******************************************************************************
                    AREA    RESET, CODE, READONLY
                    EXPORT  __Vectors
_RESERVED           EQU  0xFFFFFFFF
__Vectors
                    DCD  __initial_sp                       ; ---, 00, 0x000, Top address of Stack
                    DCD  Reset_Handler                      ; ---, 01, 0x004, Reset Handler
                    DCD  NMI_Handler                        ; -14, 02, 0x008, NMI Handler
                    DCD  HardFault_Handler                  ; -13, 03, 0x00C, Hard Fault Handler
                    DCD  _RESERVED                          ; ---, 04, 0x010, Reserved
                    DCD  _RESERVED                          ; ---, 05, 0x014, Reserved
                    DCD  _RESERVED                          ; ---, 06, 0x018, Reserved
                    DCD  _RESERVED                          ; ---, 07, 0x01C, Reserved
                    DCD  _HT32FWID                          ; ---, 08, 0x020, Reserved
                    DCD  _RESERVED                          ; ---, 09, 0x024, Reserved
                    DCD  _RESERVED                          ; ---, 10, 0x028, Reserved
                    DCD  SVC_Handler                        ; -05, 11, 0x02C, SVC Handler
                    DCD  _RESERVED                          ; ---, 12, 0x030, Reserved
                    DCD  _RESERVED                          ; ---, 13, 0x034, Reserved
                    DCD  PendSV_Handler                     ; -02, 14, 0x038, PendSV Handler
                    DCD  SysTick_Handler                    ; -01, 15, 0x03C, SysTick Handler

                    ; External Interrupt Handler
                    DCD  LVD_BOD_IRQHandler                 ;  00, 16, 0x040,
                    DCD  RTC_IRQHandler                     ;  01, 17, 0x044,
                    DCD  FLASH_IRQHandler                   ;  02, 18, 0x048,
                    DCD  EVWUP_IRQHandler                   ;  03, 19, 0x04C,
                    DCD  EXTI0_1_IRQHandler                 ;  04, 20, 0x050,
                    DCD  EXTI2_3_IRQHandler                 ;  05, 21, 0x054,
                    DCD  EXTI4_15_IRQHandler                ;  06, 22, 0x058,
                  IF (USE_HT32_CHIP=HT32F57331_41)
                    DCD  _RESERVED                          ;  07, 23, 0x05C,
                  ENDIF
                  IF (USE_HT32_CHIP=HT32F57342_52)
                    DCD  COMP_DAC_IRQHandler                ;  07, 23, 0x05C,
                  ENDIF
                    DCD  ADC_IRQHandler                     ;  08, 24, 0x060,
                  IF (USE_HT32_CHIP=HT32F57331_41)
                    DCD  _RESERVED                          ;  09, 25, 0x064,
                  ENDIF
                  IF (USE_HT32_CHIP=HT32F57342_52)
                    DCD  AES_IRQHandler                     ;  09, 25, 0x064,
                  ENDIF
                    DCD  _RESERVED                          ;  10, 26, 0x068,
                    DCD  LCD_IRQHandler                     ;  11, 27, 0x06C,
                    DCD  GPTM0_IRQHandler                   ;  12, 28, 0x070,
                  IF (USE_HT32_CHIP=HT32F57331_41)
                    DCD  _RESERVED                          ;  13, 29, 0x074,
                    DCD  _RESERVED                          ;  14, 30, 0x078,
                  ENDIF
                  IF (USE_HT32_CHIP=HT32F57342_52)
                    DCD  SCTM0_IRQHandler                   ;  13, 29, 0x074,
                    DCD  SCTM1_IRQHandler                   ;  14, 30, 0x078,
                  ENDIF
                    DCD  PWM0_IRQHandler                    ;  15, 31, 0x07C,
                    DCD  PWM1_IRQHandler                    ;  16, 32, 0x080,
                    DCD  BFTM0_IRQHandler                   ;  17, 33, 0x084,
                    DCD  BFTM1_IRQHandler                   ;  18, 34, 0x088,
                    DCD  I2C0_IRQHandler                    ;  19, 35, 0x08C,
                    DCD  I2C1_IRQHandler                    ;  20, 36, 0x090,
                    DCD  SPI0_IRQHandler                    ;  21, 37, 0x094,
                    DCD  SPI1_IRQHandler                    ;  22, 38, 0x098,
                    DCD  USART0_IRQHandler                  ;  23, 39, 0x09C,
                    DCD  _RESERVED                          ;  24, 40, 0x0A0,
                    DCD  UART0_IRQHandler                   ;  25, 41, 0x0A4,
                    DCD  UART1_IRQHandler                   ;  26, 42, 0x0A8,
                    DCD  SCI_IRQHandler                     ;  27, 43, 0x0AC,
                    DCD  I2S_IRQHandler                     ;  28, 44, 0x0B0,
                    DCD  USB_IRQHandler                     ;  29, 45, 0x0B4,
                  IF (USE_HT32_CHIP=HT32F57331_41)
                    DCD  _RESERVED                          ;  30, 46, 0x0B8,
                    DCD  _RESERVED                          ;  31, 47, 0x0BC,
                  ENDIF
                  IF (USE_HT32_CHIP=HT32F57342_52)
                    DCD  PDMA_CH0_1_IRQHandler              ;  30, 46, 0x0B8,
                    DCD  PDMA_CH2_5_IRQHandler              ;  31, 47, 0x0BC,
                  ENDIF

; Reset handler routine
Reset_Handler       PROC
                    EXPORT  Reset_Handler                   [WEAK]
                    IMPORT  SystemInit
                    IMPORT  __main
                    LDR     R0, =BootProcess
                    BLX     R0
                    LDR     R0, =SystemInit
                    BLX     R0
                    LDR     R0, =__main
                    BX      R0
                    ENDP

BootProcess         PROC
                    LDR     R0, =0x40080300
                    LDR     R1,[R0, #0x10]
                    CMP     R1, #0
                    BNE     BP1
                    LDR     R1,[R0, #0x14]
                    CMP     R1, #0
                    BNE     BP1
                    LDR     R1,[R0, #0x18]
                    CMP     R1, #0
                    BNE     BP1
                    LDR     R1,[R0, #0x1C]
                    CMP     R1, #0
                    BEQ     BP2
BP1                 LDR     R0, =0x40080180
                    LDR     R1,[R0, #0xC]
                    LSLS    R1, R1, #4
                    LSRS    R1, R1, #20
                    CMP     R1, #0
                    BEQ     BP3
                    CMP     R1, #5
                    BEQ     BP3
                    CMP     R1, #6
                    BEQ     BP3
BP2                 DSB
                    LDR     R0, =0x20000000
                    LDR     R1, =0x05fa0004
                    STR     R1, [R0]
                    LDR     R1, =0xe000ed00
                    LDR     R0, =0x05fa0004
                    STR     R0, [R1, #0xC]
                    DSB
                    B       .
BP3                 LDR     R0, =0x20000000
                    LDR     R1, [R0]
                    LDR     R0, =0x05fa0004
                    CMP     R0, R1
                    BEQ     BP4
                    BX      LR
BP4                 LDR     R0, =0x40088100
                    LDR     R1, =0x00000001
                    STR     R1, [R0]
                    LDR     R0, =0x20000000
                    LDR     R1, =0x0
                    STR     R1, [R0]
                    BX      LR
                    ENDP

; Dummy Exception Handlers
NMI_Handler         PROC
                    EXPORT  NMI_Handler                     [WEAK]
                    B       .
                    ENDP

HardFault_Handler   PROC
                    EXPORT  HardFault_Handler               [WEAK]
                    B       .
                    ENDP

SVC_Handler         PROC
                    EXPORT  SVC_Handler                     [WEAK]
                    B       .
                    ENDP

PendSV_Handler      PROC
                    EXPORT  PendSV_Handler                  [WEAK]
                    B       .
                    ENDP

SysTick_Handler     PROC
                    EXPORT  SysTick_Handler                 [WEAK]
                    B       .
                    ENDP

Default_Handler     PROC
                    EXPORT  LVD_BOD_IRQHandler              [WEAK]
                    EXPORT  RTC_IRQHandler                  [WEAK]
                    EXPORT  FLASH_IRQHandler                [WEAK]
                    EXPORT  EVWUP_IRQHandler                [WEAK]
                    EXPORT  EXTI0_1_IRQHandler              [WEAK]
                    EXPORT  EXTI2_3_IRQHandler              [WEAK]
                    EXPORT  EXTI4_15_IRQHandler             [WEAK]
                    EXPORT  COMP_DAC_IRQHandler             [WEAK]
                    EXPORT  ADC_IRQHandler                  [WEAK]
                    EXPORT  AES_IRQHandler                  [WEAK]
                    EXPORT  LCD_IRQHandler                  [WEAK]
                    EXPORT  GPTM0_IRQHandler                [WEAK]
                    EXPORT  SCTM0_IRQHandler                [WEAK]
                    EXPORT  SCTM1_IRQHandler                [WEAK]
                    EXPORT  PWM0_IRQHandler                 [WEAK]
                    EXPORT  PWM1_IRQHandler                 [WEAK]
                    EXPORT  BFTM0_IRQHandler                [WEAK]
                    EXPORT  BFTM1_IRQHandler                [WEAK]
                    EXPORT  I2C0_IRQHandler                 [WEAK]
                    EXPORT  I2C1_IRQHandler                 [WEAK]
                    EXPORT  SPI0_IRQHandler                 [WEAK]
                    EXPORT  SPI1_IRQHandler                 [WEAK]
                    EXPORT  USART0_IRQHandler               [WEAK]
                    EXPORT  USART1_IRQHandler               [WEAK]
                    EXPORT  UART0_IRQHandler                [WEAK]
                    EXPORT  UART1_IRQHandler                [WEAK]
                    EXPORT  SCI_IRQHandler                  [WEAK]
                    EXPORT  I2S_IRQHandler                  [WEAK]
                    EXPORT  USB_IRQHandler                  [WEAK]
                    EXPORT  PDMA_CH0_1_IRQHandler           [WEAK]
                    EXPORT  PDMA_CH2_5_IRQHandler           [WEAK]

LVD_BOD_IRQHandler
RTC_IRQHandler
FLASH_IRQHandler
EVWUP_IRQHandler
EXTI0_1_IRQHandler
EXTI2_3_IRQHandler
EXTI4_15_IRQHandler
COMP_DAC_IRQHandler
ADC_IRQHandler
AES_IRQHandler
LCD_IRQHandler
GPTM0_IRQHandler
SCTM0_IRQHandler
SCTM1_IRQHandler
PWM0_IRQHandler
PWM1_IRQHandler
BFTM0_IRQHandler
BFTM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
SPI0_IRQHandler
SPI1_IRQHandler
USART0_IRQHandler
USART1_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
SCI_IRQHandler
I2S_IRQHandler
USB_IRQHandler
PDMA_CH0_1_IRQHandler
PDMA_CH2_5_IRQHandler
                    B       .
                    ENDP

                    ALIGN

;*******************************************************************************
; User Stack and Heap initialization
;*******************************************************************************
                    EXPORT  __HT_check_heap
                    EXPORT  __HT_check_sp

                    IF      :DEF:__MICROLIB

                    EXPORT  __initial_sp
                    EXPORT  __heap_base
                    EXPORT  __heap_limit

                    ELSE

                    IMPORT  __use_two_region_memory
                    EXPORT  __user_initial_stackheap
__user_initial_stackheap

                  IF (USE_STACK_ON_TOP = 1)
                    LDR     R0, = Heap_Mem
                    LDR     R1, = (0x20000000 + USE_LIBCFG_RAM_SIZE)
                    LDR     R2, = (Heap_Mem + Heap_Size)
                    LDR     R3, = (Heap_Mem + Heap_Size)
                    BX      LR
                  ELSE
                    LDR     R0, = Heap_Mem
                    LDR     R1, = (Stack_Mem + Stack_Size)
                    LDR     R2, = (Heap_Mem + Heap_Size)
                    LDR     R3, = Stack_Mem
                    BX      LR
                  ENDIF

                    ALIGN

                    ENDIF

                    END
