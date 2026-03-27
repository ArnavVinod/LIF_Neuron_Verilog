`timescale 1ns/1ps

module tb_lif_neuron;

    // Parameters matches the design
    parameter WIDTH = 16;
    parameter THRESHOLD = 16'd1000;
    parameter LEAK_SHIFT = 4;

    // Inputs
    reg clk;
    reg rst_n;
    reg [WIDTH-1:0] i_in;

    // Outputs
    wire spike;

    // Instantiate the Unit Under Test (UUT)
    lif_neuron #(
        .WIDTH(WIDTH),
        .THRESHOLD(THRESHOLD),
        .LEAK_SHIFT(LEAK_SHIFT)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .i_in(i_in),
        .spike(spike)
    );

    // Clock generation: 100MHz (10ns period)
    always #5 clk = ~clk;

    initial begin
        // --- Required for GTKWave ---
        $dumpfile("lif_sim.vcd");
        $dumpvars(0, tb_lif_neuron);

        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        i_in = 0;

        // Reset the system
        #20 rst_n = 1;
        #10;

        // Test 1: Sub-threshold input
        // Current = 50. Equilibrium = 50 * 16 = 800 (Below 1000)
        $display("Applying input: 50 (Expect no spikes)");
        i_in = 16'd50;
        #500;

        // Test 2: Supra-threshold input
        // Current = 150. Equilibrium = 150 * 16 = 2400 (Above 1000)
        $display("Applying input: 150 (Expect spikes)");
        i_in = 16'd150;
        #2000;

        // Test 3: Burst input
        $display("Applying input: 500 (Expect rapid spikes)");
        i_in = 16'd500;
        #500;

        $display("Simulation complete. Use 'gtkwave lif_sim.vcd' to visualize.");
        $finish;
    end

endmodule