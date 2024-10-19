`ifndef RVREG 
`define RVREG 

// RISC-V Register Definitions
`define X0   5'b00000  // ZERO
`define X1   5'b00001  // RA (Return Address)
`define X2   5'b00010  // SP (Stack Pointer)
`define X3   5'b00011  // GP (Global Pointer)
`define X4   5'b00100  // TP (Thread Pointer)
`define X5   5'b00101  // T0 (Temporary)
`define X6   5'b00110  // T1 (Temporary)
`define X7   5'b00111  // T2 (Temporary)
`define X8   5'b01000  // S0 (Saved Register / Frame Pointer)
`define X9   5'b01001  // S1 (Saved Register)
`define X10  5'b01010  // A0 (Function Argument / Return Value)
`define X11  5'b01011  // A1 (Function Argument)
`define X12  5'b01100  // A2 (Function Argument)
`define X13  5'b01101  // A3 (Function Argument)
`define X14  5'b01110  // A4 (Function Argument)
`define X15  5'b01111  // A5 (Function Argument)
`define X16  5'b10000  // A6 (Function Argument)
`define X17  5'b10001  // A7 (Function Argument)
`define X18  5'b10010  // S2 (Saved Register)
`define X19  5'b10011  // S3 (Saved Register)
`define X20  5'b10100  // S4 (Saved Register)
`define X21  5'b10101  // S5 (Saved Register)
`define X22  5'b10110  // S6 (Saved Register)
`define X23  5'b10111  // S7 (Saved Register)
`define X24  5'b11000  // S8 (Saved Register)
`define X25  5'b11001  // S9 (Saved Register)
`define X26  5'b11010  // S10 (Saved Register)
`define X27  5'b11011  // S11 (Saved Register)
`define X28  5'b11100  // T3 (Temporary)
`define X29  5'b11101  // T4 (Temporary)
`define X30  5'b11110  // T5 (Temporary)
`define X31  5'b11111  // T6 (Temporary)

// Aliases for commonly used registers
`define ZERO  `X0   // Zero Register
`define RA    `X1   // Return Address
`define SP    `X2   // Stack Pointer
`define GP    `X3   // Global Pointer
`define TP    `X4   // Thread Pointer
`define T0    `X5   // Temporary Register
`define T1    `X6   // Temporary Register
`define T2    `X7   // Temporary Register
`define S0    `X8   // Saved Register / Frame Pointer
`define S1    `X9   // Saved Register
`define A0    `X10  // Function Argument / Return Value
`define A1    `X11  // Function Argument
`define A2    `X12  // Function Argument
`define A3    `X13  // Function Argument
`define A4    `X14  // Function Argument
`define A5    `X15  // Function Argument
`define A6    `X16  // Function Argument
`define A7    `X17  // Function Argument
`define S2    `X18  // Saved Register
`define S3    `X19  // Saved Register
`define S4    `X20  // Saved Register
`define S5    `X21  // Saved Register
`define S6    `X22  // Saved Register
`define S7    `X23  // Saved Register
`define S8    `X24  // Saved Register
`define S9    `X25  // Saved Register
`define S10   `X26  // Saved Register
`define S11   `X27  // Saved Register
`define T3    `X28  // Temporary Register
`define T4    `X29  // Temporary Register
`define T5    `X30  // Temporary Register
`define T6    `X31  // Temporary Register



`endif 