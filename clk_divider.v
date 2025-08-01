module clk_divider(
    input clk, 
    output reg clk_div
);
    reg [31:0] count = 0;
    always @(posedge clk) begin
        if(count == 6250000) begin  // Changed to ~10Hz for better responsiveness
            count <= 0;
            clk_div <= ~clk_div;
        end else begin
            count <= count + 1;
        end
    end
endmodule
