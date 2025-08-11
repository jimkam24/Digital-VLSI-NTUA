#include <stdio.h>
#include "xil_io.h"
#include "xparameters.h"
#include "sleep.h"

#define FIR_BASEADDR      0x43C00000
#define REG_CONTROL       (FIR_BASEADDR + 0x00) // slv_reg0
#define REG_OUTPUT        (FIR_BASEADDR + 0x04) // slv_reg1

//int data_x[16] = {
//    0xBE, 0x01, 0x58, 0xC7, 0x6D, 0x9A, 0x13, 0xF5,
//    0x2E, 0xD6, 0x4B, 0x89, 0xE1, 0x7C, 0xA2, 0x3F
//};

length = 20;

int data_x2[20] = {
    0xD0, 0xE7, 0x20, 0xE9, 0xA1, 0x18, 0x47, 0x8C,
    0xF5, 0xF7, 0x28, 0xF8, 0xF5, 0x7C, 0xCC, 0x24,
    0x6B, 0xEA, 0xCA, 0xF5
};

int main() {
    printf("Starting FIR filter test...\n");

    // ---------- RESET FIRST ----------
    printf("Applying reset...\n");
    Xil_Out32(REG_CONTROL, (1 << 9));  // rst = 1 (bit 9)
    usleep(10);
    Xil_Out32(REG_CONTROL, 0);         // rst = 0
    printf("Reset complete.\n");

    // ---------- FIRST TEST LOOP ----------
    for (int i = 0; i < length; i++) {
        printf("1st loop - sending sample %2d\n", i);

        u32 control_word = (1 << 8) | (data_x2[i] & 0xFF);  // valid_in = 1
        Xil_Out32(REG_CONTROL, control_word);
        usleep(10);  // short pulse
        Xil_Out32(REG_CONTROL, data_x2[i] & 0xFF); // valid_in = 0

        while ((Xil_In32(REG_OUTPUT) & (1 << 19)) == 0); // wait for valid_out

        u32 result = Xil_In32(REG_OUTPUT) & 0x7FFFF; // 19-bit output
        printf("1st loop Input[%2d] = %3d → FIR Output = %5d\n", i, data_x2[i], result);

        usleep(1000);
    }

    // ---------- APPLY RESET BEFORE SECOND LOOP ----------
    printf("\nApplying reset again before second test loop...\n");
    Xil_Out32(REG_CONTROL, (1 << 9));  // rst = 1
    usleep(10);
    Xil_Out32(REG_CONTROL, 0);         // rst = 0
    printf("Reset complete.\n");

    // ---------- SECOND TEST LOOP ----------
    for (int i = 0; i < length; i++) {
        printf("2nd loop - sending sample %2d\n", i);

        u32 control_word = (1 << 8) | (data_x2[i] & 0xFF);  // valid_in = 1
        Xil_Out32(REG_CONTROL, control_word);
        usleep(10);  // short pulse
        Xil_Out32(REG_CONTROL, data_x2[i] & 0xFF); // valid_in = 0

        while ((Xil_In32(REG_OUTPUT) & (1 << 19)) == 0); // wait for valid_out

        u32 result = Xil_In32(REG_OUTPUT) & 0x7FFFF; // 19-bit output
        printf("2nd loop Input[%2d] = %3d → FIR Output = %5d\n", i, data_x2[i], result);

        usleep(1000);
    }

    printf("\nFIR test complete.\n");
    return 0;
}
