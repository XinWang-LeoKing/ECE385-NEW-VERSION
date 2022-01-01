module  terrChecker ( input [9:0]   left, right, bot, speed_y,  
						   
						    output logic  on_build,            
							 output logic  on_ground,
							 output logic [9:0] bias
						  );

	 always_comb 
	 begin
			on_ground = 0;
			on_build = 0;
			bias = 0;
			
			if (bot==439) // bot =439
				on_ground = 1'b1; 
			else if ((bot==397&&left>=11&&right<=91)||(bot==317&&left>=28&&right<=267)) // bot1 = 397, bot2 = 316
				on_build = 1'b1;
			
			// speed down near the ground
			if (bot<=439&&bot+speed_y>10'd439)
				bias = 10'd439-bot-speed_y;
			else if (bot<397&&bot+speed_y>10'd397&&left>=11&&right<=91)
				bias = 10'd397-bot-speed_y;
			else if (bot<317&&bot+speed_y>10'd317&&left>=28&&right<=267)
				bias = 10'd317-bot-speed_y;
			else
				bias = 0;
	 end

endmodule	