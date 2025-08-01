module vending_machine_fpga(
    input sysclk,           // 125MHz system clock
    input [3:0] sw,         // 4 switches
    input [3:0] btn,        // 4 buttons
    output [3:0] led,       // 4 LEDs for state indication
    output led5_r,          // RGB LED 5 - Red
    output led5_g,          // RGB LED 5 - Green
    output led5_b,          // RGB LED 5 - Blue
    output led6_r,          // RGB LED 6 - Red
    output led6_g,          // RGB LED 6 - Green
    output led6_b           // RGB LED 6 - Blue
);

    wire clk_div;
    wire coin_insert, cancel, reset;
    wire [1:0] coin_value, selection;

    reg [3:0] btn_sync1, btn_sync2, btn_prev;
    wire [3:0] btn_edge;

    always @(posedge clk_div) begin
        btn_sync1 <= btn;
        btn_sync2 <= btn_sync1;
        btn_prev <= btn_sync2;
    end

    assign btn_edge = btn_sync2 & ~btn_prev;  // Rising edge detection
    assign coin_insert = btn_edge[0];
    assign cancel = btn_edge[1];
    assign reset = btn_edge[2];
    assign coin_value = sw[1:0];
    assign selection = sw[3:2];

    clk_divider clk_div_inst(
        .clk(sysclk),
        .clk_div(clk_div)
    );

    vending_machine_core vm_core(
        .clk(clk_div),
        .rst(reset),
        .coin_insert(coin_insert),
        .coin_value(coin_value),
        .selection(selection),
        .cancel(cancel),
        .led_state(led),
        .led5_r(led5_r),
        .led5_g(led5_g), 
        .led5_b(led5_b),
        .led6_r(led6_r),
        .led6_g(led6_g),
        .led6_b(led6_b)
    );
endmodule
