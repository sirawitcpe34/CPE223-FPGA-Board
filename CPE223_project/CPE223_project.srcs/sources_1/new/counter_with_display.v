`timescale 1ns / 1ps

module counter (clk, btnL, btnR, seven_seg, an); 

input clk, btnL, btnR;
output reg [6:0] seven_seg;
output reg [3:0] an;

reg temp = 0;
reg [6:0] Q;
reg [3:0] Qe;
reg [26:0] counter;
reg clk_out;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 1_000_000) begin
        counter <= 0;
        clk_out <= ~clk_out;
    end
end

always @ (posedge clk) begin
    if (btnR) begin
        Q <= 7'b000_0000; 
    end
    if (btnL == 0) begin
        temp <= 0;
    end
    else if (btnL) begin
        if (temp == 0) begin
        temp <= 1;
            if (Q < 99) begin
                Q <= Q + 1'b1;
            end
            else begin
                Q <= 0;
            end
        end     
    end
end

always @(*) begin
    case(clk_out) 
        1'b0: begin
            an = 4'b1101; 
            Qe = ((Q % 1000) % 100) / 10;
        end
        1'b1: begin
            an = 4'b1110; 
            Qe = Q % 10;
        end
    endcase
end

parameter zero    = 7'b100_0000;
parameter one     = 7'b111_1001;
parameter two     = 7'b010_0100;
parameter three   = 7'b011_0000;
parameter four    = 7'b001_1001;
parameter five    = 7'b001_0010;
parameter six     = 7'b000_0010;
parameter seven   = 7'b111_1000;
parameter eight   = 7'b000_0000;
parameter nine    = 7'b001_0000;

always @(*) begin
    case(Qe)
        0: seven_seg = zero;
        1: seven_seg = one;
        2: seven_seg = two;
        3: seven_seg = three;
        4: seven_seg = four;    
        5: seven_seg = five;
        6: seven_seg = six;
        7: seven_seg = seven;
        8: seven_seg = eight;
        9: seven_seg = nine;
        default: seven_seg = zero;
    endcase
end

endmodule