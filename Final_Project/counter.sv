
//count from 0 to 719, 12 seconds
module counter(input frame_clk, reset, start,

					output logic [9:0] count
					);
	logic [9:0] count_in;
	assign count = count_in;

always_ff @ (posedge frame_clk) begin
	if(reset)
		count_in <= 0;
	else if (start)
		count_in <= 10'd1023;
	else if(count_in <= 10'd1022)
		count_in <= count_in + 10'b1;
end

endmodule