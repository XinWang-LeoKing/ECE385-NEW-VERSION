module healthbar (	 input frame_clk,
							 input [29:0]hit,          	  
							 input [1:0] bullet_state [30],
							 input [29:0] deflect_hit,
							 input [1:0] deflect_bullet_state [30],
							 input [9:0] DrawX, DrawY,
							 input reset,
							 input [9:0]damageUnit_1, damageUnit_2,
							 input [1:0] chara_id,
							 input pl,
							 input bomb_hit, boom_hit, dragon_hit, swift_hit,
							 input [9:0] count_recall,
							 input recall, deflect,
							 input KO,
							 
							 output logic is_healthbar,
							 output logic gameover
							 );
    logic [9:0] X_init;       // Leftmost point on the X axis
    parameter [9:0] Y_Min = 10'd10;       // Topmost point on the Y axis
    parameter [9:0] Y_Max = 10'd39;     // Bottommost point on the Y axis

	 logic [9:0]current_len;
	 logic [9:0]total_damage, total_damage_in;
	 logic [9:0]current_position;
	 logic bomb_hit_before, boom_hit_before, dragon_hit_before, swift_hit_before;
	 logic [9:0] damage_recall [300];
	 logic [9:0] len_init;
	
	always_ff @ (posedge frame_clk) begin
		bomb_hit_before <= bomb_hit;
		boom_hit_before <= boom_hit;
		dragon_hit_before <= dragon_hit;
		swift_hit_before <= swift_hit;
		damage_recall[count_recall] <= total_damage_in;
		if (reset) begin
			total_damage <= 0;
			current_len <= len_init;
		end
		else
			total_damage <= total_damage_in;
			current_len <= len_init - total_damage;
	end
	
	 always_comb begin
			gameover = 0;
			
			if (total_damage_in>=len_init) begin
				gameover = 1'b1;
				total_damage_in = len_init;
			end
			
			total_damage_in = total_damage;
			len_init = 10'd200;
			
			if (chara_id==0) begin
				len_init = 10'd150;
			end
			else if (chara_id==2'b01) begin
				len_init = 10'd200;
			end
			
			if (~pl) begin
				X_init = 10'd10;
				current_position = X_init + current_len;
			end
			else begin
				X_init = 10'd629;
				current_position = X_init - current_len;
			end
			
			//current_len = current_len - total_damage;
			
			
			for(int i=0; i<30; i++)begin // calculate damage
					if(hit[i]&&((bullet_state[i]==2'b01)||(bullet_state[i]==2'b10)))begin
							total_damage_in = total_damage_in + damageUnit_1;
					end
			end
			for(int i=0; i<30; i++)begin // calculate damage
					if(deflect_hit[i]&&((deflect_bullet_state[i]==2'b01)||(deflect_bullet_state[i]==2'b10)))begin
							total_damage_in = total_damage_in + damageUnit_2;
					end
			end
			
			if (~bomb_hit_before&&bomb_hit&&~deflect) begin
				total_damage_in = total_damage_in + 10'd175;
			end
			if (~boom_hit_before&&boom_hit&&~deflect) begin
				total_damage_in = total_damage_in + 10'd35;
			end
			if (~dragon_hit_before&&dragon_hit&&~deflect) begin
				total_damage_in = total_damage_in + 10'd55;
			end
			if (~swift_hit_before&&swift_hit&&~deflect) begin
				total_damage_in = total_damage_in + 10'd25;
			end
			if (recall) begin
				if (count_recall>=10'd255) begin
					total_damage_in = damage_recall[count_recall-10'd255];
				end else begin
					total_damage_in = damage_recall[count_recall+10'd45];
				end
			end

			//if(current_len<=0)
					//gameover = 1;

			if ((~pl&&(DrawX>=X_init&&DrawX<=current_position&&DrawY>=Y_Min&&DrawY<=Y_Max)) // draw
				||(pl&&(DrawX<=X_init&&DrawX>=current_position&&DrawY>=Y_Min&&DrawY<=Y_Max)))
				is_healthbar = 1'b1; // the pixel belongs to the character
			else
				is_healthbar = 1'b0;
				
			
			
			if (KO) begin
				total_damage_in = total_damage;
			end
	 end
endmodule

