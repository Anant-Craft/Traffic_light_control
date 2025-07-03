module Trafficlight(ped_btn, reset, clk, ped_light, car_light);
  input ped_btn;
  input reset, clk;
  output reg [2:0] ped_light;
  output reg [2:0] car_light;

  // Light color encodings
  parameter RED    = 3'b100;
  parameter YELLOW = 3'b010;
  parameter GREEN  = 3'b001;

  // FSM states
  parameter S0 = 3'd0,  // Car Green, Ped Red
            S1 = 3'd1,  // Car Yellow
            S2 = 3'd2,  // Car Red, Ped Green
            S3 = 3'd3;  // All Red

  reg [2:0] state;
  reg [2:0] nxt_state;

  initial begin
    car_light = GREEN;
    ped_light = RED;
    state     = S0;
    nxt_state = S0;
  end

  // State register with synchronous reset
  always @(posedge clk or posedge reset) begin
    if (reset)
      state <= S0;
    else
      state <= nxt_state;
  end

  // Output logic based on current state
  always @(state) begin
    case (state)
      S0: begin
        car_light = GREEN;
        ped_light = RED;
      end
      S1: begin
        car_light = YELLOW;
        ped_light = RED;
      end
      S2: begin
        car_light = RED;
        ped_light = GREEN;
      end
      S3: begin
        car_light = RED;
        ped_light = RED;
      end
      default: begin
        car_light = RED;
        ped_light = RED;
      end
    endcase
  end

  // Next state logic with simulated delays
  always @(state or ped_btn) begin
    case (state)
      S0: begin
        if (ped_btn)
          nxt_state = S1;
        else
          nxt_state = S0;
      end
      S1: begin
        repeat(2) @(posedge clk); // simulate 2 clock wait
        nxt_state = S2;
      end
      S2: begin
        repeat(4) @(posedge clk);
        nxt_state = S3;
      end
      S3: begin
        repeat(2) @(posedge clk);
        nxt_state = S0;
      end
      default: nxt_state = S0;
    endcase
  end

endmodule
