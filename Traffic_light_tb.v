module testbench;

  // Inputs
  reg ped_btn;
  reg clk;
  reg reset;

  // Outputs
  wire [2:0] car_light;
  wire [2:0] ped_light;

  // Instantiate the Trafficlight module
  Trafficlight uut (
    .ped_btn(ped_btn),
    .reset(reset),
    .clk(clk),
    .ped_light(ped_light),
    .car_light(car_light)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    ped_btn = 0;
    reset = 1;
    #2 reset = 0;

    // Apply pedestrian request after some time
    #10 ped_btn = 1;
    #10 ped_btn = 0;  // simulate button release
  end

  // Monitor outputs
  initial begin
    $monitor("time=%0t | ped_btn=%b | reset=%b | car_light=%b | ped_light=%b", $time, ped_btn, reset, car_light, ped_light);
    $dumpfile("trafficlight.vcd");
    $dumpvars(1, testbench);
    #200 $finish;
  end

endmodule
