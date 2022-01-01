//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------

// original file is ball.sv

module  tracer (input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					 input press_w, press_a, press_s, press_d, // keyboard input
					 input on_ground, on_build, // whether the character is on the ground or on the building
					
					 output logic tracer_direction, // the character face left or face right
					 output logic moving_left, moving_right, moving_up, moving_down // whether the character is moving left/right/up
					 output logic [9:0] top, bot, left, right
                );

	// this two parameters are related with the background
	 parameter [9:0] left_initial = 10'd145;  // initial position on the X axis (left)
    parameter [9:0] top_initial = 10'd398;  // initial position on the Y axis (top)
	 
    parameter [9:0] X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Y_Max = 10'd439;     // Bottommost point on the Y axis
    parameter [9:0] X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Y_Step = 10'd1;      // Step size on the Y axis

    
	logic [9:0] left_in, top_in; // input of register 
	logic [9:0] X_Motion, Y_Motion, X_Motion_in, Y_Motion_in;
	logic frame_clk_delayed, frame_clk_rising_edge;
	
	assign bot = top + 41; assign right = left + 30; // the character has a size 31*42
	assign moving_up = 0;
	// line inside
	//logic Xcoo,Ycoo
	
// generating the signal frame_clk_rising_edge
always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end
		
// Update registers
always_ff @ (posedge Clk) begin
		if (Reset)
		begin
            left <= left_initial;
            top <= top_initial;
            X_Motion <= 10'd0; // initial still
            Y_Motion <= 10'd0;
		end
		else
		begin
            left <= left_in;
            top <= top_in;
            X_Motion <= X_Motion_in;
            Y_Motion <= Y_Motion_in;
		end
end
	 
	 
	 
always_comb  begin
        // By default, keep motion and position unchanged
        left_in = left;				
		  top_in = top;
        X_Motion_in = X_Motion;	
		  Y_Motion_in = Y_Motion;
		  moving_left = 1'b0;		
		  moving_right = 1'b0;
        
		  
		  

		if( bot >= Y_Max )  // Ball is at the bottom edge, BOUNCE!
			Y_Motion_in = 1'b0;  // 2's complement.  
      else if ( top <= Y_Min )  // Ball is at the top edge, BOUNCE!
         Y_Motion_in = 1'b0;

            // TODO: Add other boundary detections and handle keypress here.
		if (right >= X_Max) //Ball is at right edge. BOUNCE!
			X_Motion_in = 1'b0;
		else if ( left <= X_Min )  // Ball is at the left edge, BOUNCE!
         X_Motion_in = 1'b0;


		  
        // Update position and motion only at rising edge of frame clock
		if (frame_clk_rising_edge)
		begin
				if (moving_up)// up
				begin
						 Y_Motion_in = (~(Y_Step) + 1'b1);
						 X_Motion_in = 10'h000;
				end
				else if (moving_down) //down
				begin
						 Y_Motion_in = Y_Step;
						 X_Motion_in = 10'h000;
				end
				if (press_a) //left
				begin
						 X_Motion_in = (~(X_Step) + 1'b1);
						 Y_Motion_in = 10'h000;
						 tracer_direction = 1'b0; // face left
						 moving_left = 1'b1;
				end
				else if (press_d) //right
				begin
						 X_Motion_in = X_Step;
						 Y_Motion_in = 10'h000;
						 tracer_direction = 1'b1; // face right
						 moving_right = 1'b1;
				end
				left_in = left + X_Motion;
				top_in = top + Y_Motion;
		end
end

is_moving_up (	.press_w(press_w), 
					.Clk(clk), 
					.on_ground(on_ground), 
					.on_build(on_build),
					.moving_up(moving_up)
);

is_moving_down (.press_s(press_s), 
					 .Clk(clk), 
					 .on_ground(on_ground), 
					 .on_build(on_build),
					 .moving_down(moving_up)
);
endmodule		
		
		
		
		
		
		
module  is_charc ( input [9:0]   DrawX, DrawY,       // Current pixel coordinates
						 input [9:0]   left, right, top, bot,
					
						 output logic  is_charc             // Whether current pixel belongs to ball or background
						);
	
	 // this block for judging whether the pixel belongs to the character
	 always_comb 
	 begin
			if (DrawX>=left&&DrawX<=right&&DrawY>=top&&DrawY<=bot)
				is_charc = 1'b1; // the pixel belongs to the character
			else
				is_charc = 1'b0;
	 end

endmodule		



module is_moving_up (input press_w, Clk, on_ground, on_build,
							output logic moving_up
							);
	
	logic count_1s;
always_comb begin
		if(press_w&&(on_ground||on_build)) begin
			moving_up = 1'b1;
			count_1s = 1'b1;
		end
		else if (count_1s==1'b0)
			moving_up = 1'b0;
end

//counting for 1 second, and moving up becomes 0
counter ();
endmodule



module is_moving_down (input press_s, Clk, on_ground, on_build,
							output logic moving_down
							);
	
always_comb begin
		if(on_ground) begin
			moving_down = 1'b0;
		end
		else if(press_s&&on_build) begin // on the building, but the player press s to jump down
			moving_down = 1'b1;
		end
		else if(~press_s&&on_build) begin // on the building
			moving_down = 1'b0;
		end
		else if (~on_ground&&~on_build) // not on the bulding or on the ground, drop down
			moving_down = 1'b1;
end
endmodule
		
		
		
		
		
		