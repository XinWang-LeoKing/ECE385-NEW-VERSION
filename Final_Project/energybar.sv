module energybar (	 input frame_clk,
							 input [19:0]hit,          	  
							 input [1:0] bullet_state [20],
							 input [9:0] DrawX, DrawY,
							 input reset,
							 input [9:0]damageUnit,
							 input [9:0]full_energy,
							 input reset_energy,
							 
							 output logic is_energybar,
							 output logic is_ready
							 );
    parameter [9:0] X_Min = 10'd10;       // Leftmost point on the X axis
    parameter [9:0] Y_Min = 10'd50;       // Topmost point on the Y axis
    parameter [9:0] Y_Max = 10'd70;     // Bottommost point on the Y axis

	 logic [9:0]current_len;
	 logic [9:0]total_energy, total_energy_in;
	 logic [9:0]current_position;
	 logic [9:0]count_e;
	 logic counter_e_reset;
	 
	 
	always_ff @ (posedge frame_clk) begin
		if (reset||reset_energy) begin
			total_energy <= 0;

		end
		else
			total_energy <= total_energy_in;

	end
	
	 always_comb begin
			is_ready = 0;
			total_energy_in = total_energy;
			
			current_position = total_energy + X_Min;
			
			for(int i=0; i<20; i++)begin // calculate damage
					if(hit[i]&&((bullet_state[i]==2'b01)||(bullet_state[i]==2'b10)))begin
							total_energy_in = total_energy_in + 2*damageUnit;
					end
			end

			if (count_e==10'd11) begin
				 total_energy_in = total_energy_in + 1'b1;
				 counter_e_reset = 1'b1;
			end
			else
				 counter_e_reset = 0;

			if (DrawX>=X_Min&&DrawX<=current_position&&DrawY>=Y_Min&&DrawY<=Y_Max) // draw
				is_energybar = 1'b1; // the pixel belongs to the character
			else
				is_energybar = 1'b0;
				
			if (total_energy_in>=full_energy) begin
				is_ready = 1'b1;
				total_energy_in = full_energy;
			end
	 end
counter counter_e(.reset(counter_e_reset), .frame_clk(frame_clk), .count(count_e));		
endmodule

	