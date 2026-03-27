module lif_neuron #(
    parameter WIDTH = 16,        // Bit width of the membrane potential
    parameter THRESHOLD = 16'd1000, // Firing threshold
    parameter LEAK_SHIFT = 4     // Decay factor (v = v - (v >> LEAK_SHIFT))
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [WIDTH-1:0]     i_in,   // Input current/synaptic weight
    output reg                  spike   // Output spike signal
);

    reg [WIDTH-1:0] v_mem; // Membrane potential register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v_mem <= 0;
            spike <= 0;
        end else begin
            if (v_mem >= THRESHOLD) begin
                // FIRE: Reset potential and trigger spike
                v_mem <= 0; 
                spike <= 1'b1;
            end else begin
                // LEAK & INTEGRATE:
                // v = v - (v >> LEAK_SHIFT) + i_in
                v_mem <= v_mem - (v_mem >> LEAK_SHIFT) + i_in;
                spike <= 1'b0;
            end
        end
    end

endmodule