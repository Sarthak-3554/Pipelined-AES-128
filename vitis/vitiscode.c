#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "sleep.h"
#include "xbasic_types.h"


#define AES_BASEADDR  0x43C00000U 

int main() {
    init_platform();
    xil_printf("\r\n=== AES-128 Encryption Test on PYNQ ===\r\n");

    
    Xil_Out32(AES_BASEADDR + 0x04, 0x2b7e1516);
    Xil_Out32(AES_BASEADDR + 0x08, 0x28aed2a6);
    Xil_Out32(AES_BASEADDR + 0x0C, 0xabf71588);
    Xil_Out32(AES_BASEADDR + 0x10, 0x09cf4f3c);

    Xil_Out32(AES_BASEADDR + 0x14, 0x00000000);
    Xil_Out32(AES_BASEADDR + 0x18, 0x00000000);
    Xil_Out32(AES_BASEADDR + 0x1C, 0x00000000);
    Xil_Out32(AES_BASEADDR + 0x20, 0x00000000);

    usleep(50);

    u32 ct3 = Xil_In32(AES_BASEADDR + 0x24);
    u32 ct2 = Xil_In32(AES_BASEADDR + 0x28);
    u32 ct1 = Xil_In32(AES_BASEADDR + 0x2C);
    u32 ct0 = Xil_In32(AES_BASEADDR + 0x30);

    xil_printf("\r\nCiphertext = %08x%08x%08x%08x\r\n", ct3, ct2, ct1, ct0);
    xil_printf("Expected    = 7df76b0c1ab899b33e42f047b91b546f\r\n");

    xil_printf("\r\nAES Encryption completed successfully!\r\n");
    cleanup_platform();
    return 0;
}