module bullet_controller (input Reset,              // Active-high reset signal
              input frame_clk,          // The clock indicating a new frame (~60Hz)			  
				  //input [9:0] X_Step,
				  //input [9:0] fire_range,
				  input chara_direction,
			     input [9:0] show_x, show_y, // the initial position of bullet
				  input [9:0] chara_left, chara_right, chara_top, chara_bot, // another character
				  input press_j, dragon, deflect, deflect_left, deflect_right, 
							 
							 //input [9:0] fire_period,
							 //input [9:0] reload_period,
							 input [9:0] DrawX, DrawY,
							 
							 input [1:0]chara_id,
							 input deflect_color,
							 
							 output logic [23:0] bullet_color,
							 output logic [1:0] bullet_state [30],
							 output logic [29:0] hit,
							 output logic  DEFLECT_HIT,
							 output logic test
							 );
							 
	//enum logic [1:0] {WAIT, SHOOT} state,  next_state;

	logic [9:0] X_Step,fire_range,fire_period,reload_period,genji_period;
   logic [9:0] bullet_x [30];
	logic [9:0] bullet_y [30];
	logic [29:0] shoot;
	logic [29:0] deflect_hit;
	logic counter_genji_reset;
	logic [9:0] count_genji;

	//logic [19:0] hit;
	//logic [1:0] bullet_state [20];
	logic [29:0] bullet_reset;
	logic counter_reset;
	logic [9:0] count;
	
	logic [9:0] delay, delay_in;
	logic [9:0] genji_delay, genji_delay_in;
	logic [1:0] acc, acc_in;
	
	logic [9:0] dart_shape_it[30];
	logic [9:0] dart_shape_ib[30];
	logic [9:0] dart_shape_il[30];
	logic [9:0] dart_shape_ir[30];
	
	logic [9:0] dart_shape_ot[30];
	logic [9:0] dart_shape_ob[30];
	logic [9:0] dart_shape_ol[30];
	logic [9:0] dart_shape_or[30];
	
	
	bullet bullet_0 (.*, .Reset(bullet_reset[0]), .press_j(shoot[0]), .hit(hit[0]), .bullet_x(bullet_x[0]), .bullet_y(bullet_y[0]), .bullet_state(bullet_state[0]), .deflect_hit(deflect_hit[0]));
	bullet bullet_1 (.*, .Reset(bullet_reset[1]), .press_j(shoot[1]), .hit(hit[1]), .bullet_x(bullet_x[1]), .bullet_y(bullet_y[1]), .bullet_state(bullet_state[1]), .deflect_hit(deflect_hit[1]));
	bullet bullet_2 (.*, .Reset(bullet_reset[2]), .press_j(shoot[2]), .hit(hit[2]), .bullet_x(bullet_x[2]), .bullet_y(bullet_y[2]), .bullet_state(bullet_state[2]), .deflect_hit(deflect_hit[2]));
	bullet bullet_3 (.*, .Reset(bullet_reset[3]), .press_j(shoot[3]), .hit(hit[3]), .bullet_x(bullet_x[3]), .bullet_y(bullet_y[3]), .bullet_state(bullet_state[3]), .deflect_hit(deflect_hit[3]));
	bullet bullet_4 (.*, .Reset(bullet_reset[4]), .press_j(shoot[4]), .hit(hit[4]), .bullet_x(bullet_x[4]), .bullet_y(bullet_y[4]), .bullet_state(bullet_state[4]), .deflect_hit(deflect_hit[4]));
	bullet bullet_5 (.*, .Reset(bullet_reset[5]), .press_j(shoot[5]), .hit(hit[5]), .bullet_x(bullet_x[5]), .bullet_y(bullet_y[5]), .bullet_state(bullet_state[5]), .deflect_hit(deflect_hit[5]));
	bullet bullet_6 (.*, .Reset(bullet_reset[6]), .press_j(shoot[6]), .hit(hit[6]), .bullet_x(bullet_x[6]), .bullet_y(bullet_y[6]), .bullet_state(bullet_state[6]), .deflect_hit(deflect_hit[6]));
	bullet bullet_7 (.*, .Reset(bullet_reset[7]), .press_j(shoot[7]), .hit(hit[7]), .bullet_x(bullet_x[7]), .bullet_y(bullet_y[7]), .bullet_state(bullet_state[7]), .deflect_hit(deflect_hit[7]));
	bullet bullet_8 (.*, .Reset(bullet_reset[8]), .press_j(shoot[8]), .hit(hit[8]), .bullet_x(bullet_x[8]), .bullet_y(bullet_y[8]), .bullet_state(bullet_state[8]), .deflect_hit(deflect_hit[8]));
	bullet bullet_9 (.*, .Reset(bullet_reset[9]), .press_j(shoot[9]), .hit(hit[9]), .bullet_x(bullet_x[9]), .bullet_y(bullet_y[9]), .bullet_state(bullet_state[9]), .deflect_hit(deflect_hit[9]));
	bullet bullet_10 (.*, .Reset(bullet_reset[10]), .press_j(shoot[10]), .hit(hit[10]), .bullet_x(bullet_x[10]), .bullet_y(bullet_y[10]), .bullet_state(bullet_state[10]), .deflect_hit(deflect_hit[10]));
	bullet bullet_11 (.*, .Reset(bullet_reset[11]), .press_j(shoot[11]), .hit(hit[11]), .bullet_x(bullet_x[11]), .bullet_y(bullet_y[11]), .bullet_state(bullet_state[11]), .deflect_hit(deflect_hit[11]));
	bullet bullet_12 (.*, .Reset(bullet_reset[12]), .press_j(shoot[12]), .hit(hit[12]), .bullet_x(bullet_x[12]), .bullet_y(bullet_y[12]), .bullet_state(bullet_state[12]), .deflect_hit(deflect_hit[12]));
	bullet bullet_13 (.*, .Reset(bullet_reset[13]), .press_j(shoot[13]), .hit(hit[13]), .bullet_x(bullet_x[13]), .bullet_y(bullet_y[13]), .bullet_state(bullet_state[13]), .deflect_hit(deflect_hit[13]));
	bullet bullet_14 (.*, .Reset(bullet_reset[14]), .press_j(shoot[14]), .hit(hit[14]), .bullet_x(bullet_x[14]), .bullet_y(bullet_y[14]), .bullet_state(bullet_state[14]), .deflect_hit(deflect_hit[14]));
	bullet bullet_15 (.*, .Reset(bullet_reset[15]), .press_j(shoot[15]), .hit(hit[15]), .bullet_x(bullet_x[15]), .bullet_y(bullet_y[15]), .bullet_state(bullet_state[15]), .deflect_hit(deflect_hit[15]));
	bullet bullet_16 (.*, .Reset(bullet_reset[16]), .press_j(shoot[16]), .hit(hit[16]), .bullet_x(bullet_x[16]), .bullet_y(bullet_y[16]), .bullet_state(bullet_state[16]), .deflect_hit(deflect_hit[16]));
	bullet bullet_17 (.*, .Reset(bullet_reset[17]), .press_j(shoot[17]), .hit(hit[17]), .bullet_x(bullet_x[17]), .bullet_y(bullet_y[17]), .bullet_state(bullet_state[17]), .deflect_hit(deflect_hit[17]));
	bullet bullet_18 (.*, .Reset(bullet_reset[18]), .press_j(shoot[18]), .hit(hit[18]), .bullet_x(bullet_x[18]), .bullet_y(bullet_y[18]), .bullet_state(bullet_state[18]), .deflect_hit(deflect_hit[18]));
	bullet bullet_19 (.*, .Reset(bullet_reset[19]), .press_j(shoot[19]), .hit(hit[19]), .bullet_x(bullet_x[19]), .bullet_y(bullet_y[19]), .bullet_state(bullet_state[19]), .deflect_hit(deflect_hit[19]));
	bullet bullet_20 (.*, .Reset(bullet_reset[20]), .press_j(shoot[20]), .hit(hit[20]), .bullet_x(bullet_x[20]), .bullet_y(bullet_y[20]), .bullet_state(bullet_state[20]), .deflect_hit(deflect_hit[20]));
	bullet bullet_21 (.*, .Reset(bullet_reset[21]), .press_j(shoot[21]), .hit(hit[21]), .bullet_x(bullet_x[21]), .bullet_y(bullet_y[21]), .bullet_state(bullet_state[21]), .deflect_hit(deflect_hit[21]));
	bullet bullet_22 (.*, .Reset(bullet_reset[22]), .press_j(shoot[22]), .hit(hit[22]), .bullet_x(bullet_x[22]), .bullet_y(bullet_y[22]), .bullet_state(bullet_state[22]), .deflect_hit(deflect_hit[22]));
	bullet bullet_23 (.*, .Reset(bullet_reset[23]), .press_j(shoot[23]), .hit(hit[23]), .bullet_x(bullet_x[23]), .bullet_y(bullet_y[23]), .bullet_state(bullet_state[23]), .deflect_hit(deflect_hit[23]));
	bullet bullet_24 (.*, .Reset(bullet_reset[24]), .press_j(shoot[24]), .hit(hit[24]), .bullet_x(bullet_x[24]), .bullet_y(bullet_y[24]), .bullet_state(bullet_state[24]), .deflect_hit(deflect_hit[24]));
	bullet bullet_25 (.*, .Reset(bullet_reset[25]), .press_j(shoot[25]), .hit(hit[25]), .bullet_x(bullet_x[25]), .bullet_y(bullet_y[25]), .bullet_state(bullet_state[25]), .deflect_hit(deflect_hit[25]));
	bullet bullet_26 (.*, .Reset(bullet_reset[26]), .press_j(shoot[26]), .hit(hit[26]), .bullet_x(bullet_x[26]), .bullet_y(bullet_y[26]), .bullet_state(bullet_state[26]), .deflect_hit(deflect_hit[26]));
	bullet bullet_27 (.*, .Reset(bullet_reset[27]), .press_j(shoot[27]), .hit(hit[27]), .bullet_x(bullet_x[27]), .bullet_y(bullet_y[27]), .bullet_state(bullet_state[27]), .deflect_hit(deflect_hit[27]));
	bullet bullet_28 (.*, .Reset(bullet_reset[28]), .press_j(shoot[28]), .hit(hit[28]), .bullet_x(bullet_x[28]), .bullet_y(bullet_y[28]), .bullet_state(bullet_state[28]), .deflect_hit(deflect_hit[28]));
	bullet bullet_29 (.*, .Reset(bullet_reset[29]), .press_j(shoot[29]), .hit(hit[29]), .bullet_x(bullet_x[29]), .bullet_y(bullet_y[29]), .bullet_state(bullet_state[29]), .deflect_hit(deflect_hit[29])); 
		
	counter counter_reload (.frame_clk(frame_clk), .reset(counter_reset), .count(count), .start(0));
	counter counter_genji (.frame_clk(frame_clk), .reset(counter_genji_reset), .count(count_genji), .start(0));	
			
always_ff @ (posedge frame_clk) begin
	if(Reset) begin
		acc <= 0;
		test <= 0;
	end
	else begin
		delay <= delay_in;
		acc <= acc_in;
	end
	
	if (DEFLECT_HIT) begin
		test <= 1'b1;
	end
	
end

//integer i, j, k, l;

always_comb begin
	DEFLECT_HIT = 0;
	for (int i = 0; i<30; i++) begin
		if (deflect_hit[i]) begin
			DEFLECT_HIT = 1'b1;
			break;
		end
	end
	if (chara_id == 2'b00) begin//tracer 
		X_Step = 10'd6;
		fire_range = 10'd160;
		fire_period = 10'd3;
		reload_period = 10'd69;
		//genji_period = 10'd3;
	end else if (chara_id == 2'b01)begin//genji
		X_Step = 10'd4;
		fire_range = 10'd320;
		fire_period = 10'd6;
		reload_period = 10'd100;
		//genji_period = 10'd60;
	end else begin //genji for def
		X_Step = 10'd3;
		fire_range = 10'd320;
		fire_period = 10'd100;
		reload_period = 10'd100;
		//genji_period = 10'd60;
	end
	

	//set default case
	delay_in = delay;
	//genji_delay_in = 0;
	acc_in = acc;

	counter_reset = 1'b0;
	counter_genji_reset = 1'b0;
	bullet_color = 24'hffffff;
	
	for (int l = 0; l < 30; l++) begin
		bullet_reset[l] = 1'b0;
		shoot[l] = 1'b0;
	end
	
	if (delay!=10'b0) // count after shooting
		delay_in = delay + 10'b1;
	if (delay_in==fire_period) // count finish
		delay_in = 10'b0;
		
	// shoot
	if (delay==10'b0&&press_j&&~deflect) begin
		//tracer
		if (chara_id==0) begin
			for (int i = 0; i < 20; i++) begin
				if (bullet_state[i]==2'b00) begin
					shoot[i] = 1'b1;
					counter_reset = 1'b1; // reload period counter
					delay_in = 10'b1;
					break;
				end
			end
		end
		
		//genji
		else if (chara_id==1'b01) begin
			for (int i = 0; i < 30; i++) begin
				if (bullet_state[i]==2'b00) begin
					shoot[i] = 1'b1;
					counter_reset = 1'b1; // reload period counter
					delay_in = 10'b1;
					//if genji
					acc_in = acc + 2'b01;
					break;
				end
			end
		end
		
	end
	
	// wait 35 frame clks after shooting 3 bullets, for genji
	if (acc_in!=2'b11&&chara_id==1'b01) begin
		counter_genji_reset = 1'b1;
	end
	else if (acc_in==2'b11&&chara_id==1'b01) begin
		delay_in = 10'b1;
		if (count_genji==10'd35&&chara_id==1'b01) begin
			acc_in = 0;
			delay_in = 0;
		end
	end
	
	// reload the bullets
	if (count==reload_period) begin
		for (int j = 0; j < 30; j++) begin
			bullet_reset[j] = 1'b1;
		end
	end
	
	// draw the bullet
	if (chara_id == 2'b01)begin
		for (int k = 0; k < 30; k++) begin //calculate all joint points
			 dart_shape_it[k] = bullet_y[k] - 1;
			 dart_shape_ib[k] = bullet_y[k] + 1;
			 dart_shape_il[k] = bullet_x[k] - 1;
			 dart_shape_ir[k] = bullet_x[k] + 1;
			
			 dart_shape_ot[k] = bullet_y[k] - 4;
			 dart_shape_ob[k] = bullet_y[k] + 4;
			 dart_shape_ol[k] = bullet_x[k] - 4;
			 dart_shape_or[k] = bullet_x[k] + 4;
			
			 if (dart_shape_ir[k]>=DrawX&&dart_shape_il[k]<=DrawX&&dart_shape_it[k]<=DrawY&&dart_shape_ib[k]>=DrawY&&(bullet_state[k]==2'b01||bullet_state[k]==2'b10))begin
				 bullet_color = 24'hf8f8ff;
					if (deflect_color) begin
						bullet_color = 24'h181818;
					end
				 break;
			 end else if (
								  ((dart_shape_it[k]> DrawY)&&(dart_shape_ot[k]<=DrawY)&&(dart_shape_ir[k]>=DrawX)&&(dart_shape_il[k]<=DrawX)
								||(dart_shape_ib[k]< DrawY)&&(dart_shape_ob[k]>=DrawY)&&(dart_shape_ir[k]>=DrawX)&&(dart_shape_il[k]<=DrawX)
								||(dart_shape_it[k]<=DrawY)&&(dart_shape_ib[k]>=DrawY)&&(dart_shape_il[k]> DrawX)&&(dart_shape_ol[k]<=DrawX)
								||(dart_shape_ir[k]< DrawX)&&(dart_shape_or[k]>=DrawX)&&(dart_shape_it[k]<=DrawY)&&(dart_shape_ib[k]>=DrawY))
								&&(bullet_state[k]==2'b01||bullet_state[k]==2'b10))begin
				 bullet_color = 24'h808080;
				 break;
			 end else begin
				 bullet_color = 0;
			 end
		end
		
	end else if (chara_id == 2'b00)begin //tracer
			for (int k = 0; k < 20; k++) begin
				if (bullet_x[k]<=DrawX+1&&bullet_x[k]+2>=DrawX&&bullet_y[k]<=DrawY+1&&bullet_y[k]>=DrawY&&(bullet_state[k]==2'b01||bullet_state[k]==2'b10)) begin
					bullet_color = 24'h00ffff; // color is cyan
					if (deflect_color) begin
						bullet_color = 24'hff0000;
					end
					break;
				end
				else
					bullet_color = 24'h000000;
			end
	end
	
	
end
endmodule


								 
								 
								 
								 
module bullet(//input Clk,                // 50 MHz clock
              input Reset,              // Active-high reset signal
              input frame_clk,          // The clock indicating a new frame (~60Hz)			  
				  input [9:0] X_Step,
				  input [9:0] fire_range,
				  input chara_direction,
			     input [9:0] show_x, show_y, // the initial position of bullet
				  input [9:0] chara_left, chara_right, chara_top, chara_bot, // another character
				  input press_j, // different from press_j in top-level
				  input dragon,
				  input deflect_left, deflect_right,
					 
				  output logic hit,		 
				  output logic [9:0] bullet_x, bullet_y,
				  output logic [1:0] bullet_state, // 00:wait	01:moving_left 10:moving_right 11:cd
				  output logic deflect_hit
                );
	 
	 enum logic [1:0] {WAIT, MOVING_LEFT, MOVING_RIGHT, CD} state, next_state;
	 
    parameter [9:0] X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] X_Max = 10'd639;     // Rightmost point on the X axis
	
	logic [9:0] bullet_x_in, bullet_y_in; // buffer
	logic [9:0] init_x; // for range of fire
	logic dragon_before;
	logic bullet_hit;
	// hit
	is_chara is_chara_instance(.DrawX(bullet_x), .DrawY(bullet_y), .left(chara_left), .right(chara_right), .top(chara_top), .bot(chara_bot), .is_chara(bullet_hit));

always_ff @ (posedge frame_clk) begin
	state <= next_state;
	dragon_before <= dragon;
	if (dragon) begin
		state <= CD;
	end
	else if(Reset) begin
		state <= WAIT;
		dragon_before <= 1'b0;
	end
	else if (dragon_before&&~dragon) begin
		state <= WAIT;
	end
	else begin
		bullet_x <= bullet_x_in;
		bullet_y <= bullet_y_in;
	end
end

always_comb begin
		next_state = state;
		bullet_x_in = bullet_x;
		init_x = show_x;
		bullet_y_in = bullet_y;
		bullet_state = 2'b11;
		hit = 0;
		deflect_hit = 0;
	
	unique case(state) // case or unique case
		WAIT: begin
			bullet_state = 2'b0;
			if(press_j&&~chara_direction) begin // WAIT->MOVING_LEFT
				next_state = MOVING_LEFT;
				bullet_x_in = show_x;
				init_x = show_x;
				bullet_y_in = show_y;
			end
			else if (press_j&&chara_direction) begin // WAIT->MOVING_RIGHT
				next_state = MOVING_RIGHT;
				bullet_x_in = show_x;
				init_x = show_x;
				bullet_y_in = show_y;
			end
		end
		
		MOVING_LEFT: begin
			bullet_state = 2'b01;
			bullet_x_in = bullet_x + (~(X_Step) + 1'b1);
			if(bullet_hit||
			(bullet_x_in+fire_range<=init_x||bullet_x_in>=init_x+fire_range)|| // out of fire range
			(bullet_x<X_Min+X_Step&&bullet_x!=bullet_x_in)) // out of boundary
			begin
				next_state = CD;
				if (bullet_hit&&~deflect_right) begin
					hit = 1'b1;
				end
				else if (bullet_hit) begin
					deflect_hit = 1'b1;
				end
			end
		end
		
		MOVING_RIGHT: begin
			bullet_state = 2'b10;
			bullet_x_in = bullet_x + X_Step;
			if(bullet_hit||
			(bullet_x_in+fire_range<=init_x||bullet_x_in>=init_x+fire_range)|| // out of fire range
			(bullet_x>X_Max-X_Step&&bullet_x!=bullet_x_in)) // out of boundary
			begin
				next_state = CD;
				if (bullet_hit&&~deflect_left) begin
					hit = 1'b1;
				end
				else if (bullet_hit) begin
					deflect_hit = 1'b1;
				end
			end
		end
		
		CD: begin
			bullet_state = 2'b11;
		end
		
		default:;
	endcase
	
	if (dragon) begin
		next_state = CD;
	end
	
end
endmodule	
