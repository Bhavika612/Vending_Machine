module vending_machine_core(

    input clk,

    input rst,

    input coin_insert,

    input [1:0] coin_value,

    input [1:0] selection,

    input cancel,

    output reg [3:0] led_state,

    output reg led5_r, led5_g, led5_b,  // Product indication

    output reg led6_r, led6_g, led6_b   // Status indication

);
 
    // State definitions

    parameter IDLE = 3'b000;

    parameter COLLECTING = 3'b001;

    parameter WAIT_SELECTION = 3'b010;

    parameter DISPENSE = 3'b011;

    parameter RETURN = 3'b100;
 
    reg [2:0] present_state, next_state;

    reg [7:0] balance;

    reg [7:0] change_amount;

    reg [3:0] dispense_counter;  // Counter for dispense state duration

    // Product costs

    localparam CHIPS_COST = 8'd10;   

    localparam SOFT_DRINK_COST = 8'd15; 

    localparam CHOCOLATE_COST = 8'd20;

    // Function to get product cost

    function [7:0] get_product_cost;

        input [1:0] sel;

        begin

            case(sel)

                2'b00: get_product_cost = CHIPS_COST;

                2'b01: get_product_cost = SOFT_DRINK_COST;

                2'b10: get_product_cost = CHOCOLATE_COST;

                default: get_product_cost = 8'd0;

            endcase

        end

    endfunction

    // State machine - sequential logic

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            present_state <= IDLE;

            balance <= 8'd0;

            change_amount <= 8'd0;

            dispense_counter <= 4'd0;

        end 

        else begin

            present_state <= next_state;

            // Handle balance updates and other sequential operations

            case(present_state)

                IDLE: begin

                    if(coin_insert) begin

                        // Add coin value to balance when transitioning to COLLECTING

                        case(coin_value)

                            2'b00: balance <= balance + 8'd1;

                            2'b01: balance <= balance + 8'd2;

                            2'b10: balance <= balance + 8'd5;

                            2'b11: balance <= balance + 8'd10;

                        endcase

                    end

                end

                COLLECTING: begin

                    if(coin_insert) begin

                        // Add more coins

                        case(coin_value)

                            2'b00: balance <= balance + 8'd1;

                            2'b01: balance <= balance + 8'd2;

                            2'b10: balance <= balance + 8'd5;

                            2'b11: balance <= balance + 8'd10;

                        endcase

                    end

                end

                WAIT_SELECTION: begin

                    if(coin_insert) begin

                        // Add more coins

                        case(coin_value)

                            2'b00: balance <= balance + 8'd1;

                            2'b01: balance <= balance + 8'd2;

                            2'b10: balance <= balance + 8'd5;

                            2'b11: balance <= balance + 8'd10;

                        endcase

                    end

                end

                DISPENSE: begin

                    if(dispense_counter == 4'd0) begin

                        // Calculate change when entering dispense state

                        change_amount <= balance - get_product_cost(selection);

                        dispense_counter <= 4'd10;  // Stay in dispense for 10 clock cycles

                    end

                    else begin

                        dispense_counter <= dispense_counter - 1;

                    end

                end
 
RETURN: begin

                    balance <= 8'd0;  // Reset balance

                    change_amount <= 8'd0;

                    dispense_counter <= 4'd0;

                end

            endcase

        end

    end

    // State machine - combinational logic for next state

    always @(*) begin

        next_state = present_state;

        case(present_state)

            IDLE: begin

                if(coin_insert) 

                    next_state = COLLECTING;

            end

            COLLECTING: begin

                if(cancel) begin

                    next_state = RETURN;

                end

                else if(selection != 2'b11) begin  // Valid selection made

                    if(balance >= get_product_cost(selection)) begin

                        next_state = DISPENSE;

                    end

                    else begin

                        next_state = WAIT_SELECTION;

                    end

                end

                else if(coin_insert) begin

                    next_state = COLLECTING;  // Stay in collecting for more coins

                end

            end

            WAIT_SELECTION: begin

                if(cancel) begin 

                    next_state = RETURN;

                end 

                else if(coin_insert) begin

                    next_state = COLLECTING;

                end

                else if(selection != 2'b11) begin  // Check selection

                    if(balance >= get_product_cost(selection)) begin

                        next_state = DISPENSE;

                    end

                    // Stay in WAIT_SELECTION if insufficient balance

                end

            end

            DISPENSE: begin

                if(dispense_counter == 4'd1) begin  // Last cycle of dispense

                    next_state = RETURN;

                end

            end

            RETURN: begin 

                next_state = IDLE;

            end

            default: begin

                next_state = IDLE;

            end

        endcase

    end

    // Output logic

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            led_state <= 4'b0001;  // IDLE indicator

            led5_r <= 1'b0; led5_g <= 1'b0; led5_b <= 1'b0;

            led6_r <= 1'b0; led6_g <= 1'b0; led6_b <= 1'b0;

        end

        else begin

            // Default LED states

            led_state <= 4'b0000;

            led5_r <= 1'b0; led5_g <= 1'b0; led5_b <= 1'b0;

            led6_r <= 1'b0; led6_g <= 1'b0; led6_b <= 1'b0;

            case(present_state)

                IDLE: begin

                    led_state[0] <= 1'b1;  // IDLE LED

                    if(balance > 0)

                        led6_g <= 1'b1;  // Show we have balance

                end

                COLLECTING: begin

                    led_state[1] <= 1'b1;  // COLLECTING LED

                    // Show balance status

                    if(balance >= CHOCOLATE_COST)  // Highest cost item

                        led6_g <= 1'b1;  // Sufficient for any item

                    else if(balance >= CHIPS_COST)  // Lowest cost item

                        led6_b <= 1'b1;  // Sufficient for some items

                    else

                        led6_r <= 1'b1;  // Insufficient balance

                end

                WAIT_SELECTION: begin

                    led_state[2] <= 1'b1;  // WAIT_SELECTION LED

                    // Show balance status for current selection

                    if (selection != 2'b11) begin

                        if(balance >= get_product_cost(selection)) 

                            led6_g <= 1'b1;  // Sufficient balance

                        else 

                            led6_r <= 1'b1;  // Insufficient balance

                    end else begin

                        led6_b <= 1'b1;  // Waiting for selection

                    end

                end

                DISPENSE: begin

                    led_state[3] <= 1'b1;  // DISPENSE LED

                    // Show product being dispensed

                    case(selection)

                        2'b00: led5_r <= 1'b1;  // Chips = Red

                        2'b01: led5_g <= 1'b1;  // Drink = Green

                        2'b10: led5_b <= 1'b1;  // Chocolate = Blue

                    endcase

                end

                RETURN: begin

                    if(change_amount > 0)

                        led6_b <= 1'b1;  // Change being returned

                    else

                        led6_g <= 1'b1;  // Transaction complete

                end

            endcase

        end

    end
 
endmodule
