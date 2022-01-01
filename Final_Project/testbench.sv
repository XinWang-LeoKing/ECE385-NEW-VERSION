
module testbench();
	
	timeunit 10ns;
	timeprecision 1ns;

	// Set variables and instance.
	logic CLK;
	logic [9:0] DrawX, DrawY, chara_left, chara_top;
	logic is_chara;
	logic [23:0] spriteColor_tracer;
	
	
	tracerROM tracer_rom_instance_1(.chara_direction(0), 
											  .DrawX(DrawX),
											  .DrawY(DrawY), 
											  .chara_left(chara_left), 
											  .chara_top(chara_top),
											  .is_chara(is_chara),
											  .moving_left(0),
											  .moving_right(0),
											  .moving_up(0),
											  .moving_down(0),
											  .Clk(CLK),
											  
											  .spriteColor(spriteColor_tracer) 
	);

	
	logic [13:0] read_address;
	
	// Clock Generation and Initialization.
always begin : CLOCK_GENERATION 
		#1 CLK = ~CLK;
end 
initial begin: CLOCK_INITIALIZATION 
		CLK = 0;
end


always begin
	#1
	read_address = tracer_rom_instance_1.read_address;
end
	
initial begin: TEST_VECTORS
	// Starting Settings
	is_chara = 1'b1;

	// Prepare to start by stop resetting.
	#4 chara_top = 0;
		chara_left = 0;
		DrawX = 2;
		DrawY = 2;
	
	//#4

end
	 
endmodule
