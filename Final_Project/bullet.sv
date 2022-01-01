module bullet_controller (//input Reset,              // Active-high reset signal
              input frame_clk,          // The clock indicating a new frame (~60Hz)			  
				  //input [9:0] X_Step,
				  //input [9:0] fire_range,
				  input chara_direction,
			     input [9:0] show_x, show_y, // the initial position of bullet
				  input [9:0] chara_left, chara_right, chara_top, chara_bot, // another character
				  input press_j,
							 
							 //input [9:0] fire_period,
							 //input [9:0] reload_period,
							 input [9:0] DrawX, DrawY,
							 
							 input [1:0]chara_id,
							 
							 output logic [23:0] bullet_color,
							 output logic [23:0] dart_color_center, dart_color_body,
							 output logic [1:0] bullet_state [20],
							 output logic [19:0] hit
							 );
							 
	//enum logic [1:0] {WAIT, SHOOT} state,  next_state;

	logic [9:0] X_Step,fire_range,fire_period,reload_period,gengi_period;
   logic [9:0] bullet_x [20];
	logic [9:0] bullet_y [20];
	logic [19:0] shoot;
	logic [1:0] acc;

	//logic [19:0] hit;
	//logic [1:0] bullet_state [20];
	logic [19:0] bullet_reset;
	logic counter_reset;
	logic [9:0] count;
	
	logic [9:0] delay, delay_in;
	logic [9:0] gengi_delay, gengi_delay_in;
	
	logic [9:0] dart_shape_it[20];
	logic [9:0] dart_shape_ib[20];
	logic [9:0] dart_shape_il[20];
	logic [9:0] dart_shape_ir[20];
	
	logic [9:0] dart_shape_ot[20];
	logic [9:0] dart_shape_ob[20];
	logic [9:0] dart_shape_ol[20];
	logic [9:0] dart_shape_or[20];
	
	
	bullet bullet_0 (.*, .Reset(bullet_reset[0]), .press_j(shoot[0]), .hit(hit[0]), .bullet_x(bullet_x[0]), .bullet_y(bullet_y[0]), .bullet_state(bullet_state[0]));
	bullet bullet_1 (.*, .Reset(bullet_reset[1]), .press_j(shoot[1]), .hit(hit[1]), .bullet_x(bullet_x[1]), .bullet_y(bullet_y[1]), .bullet_state(bullet_state[1]));
	bullet bullet_2 (.*, .Reset(bullet_reset[2]), .press_j(shoot[2]), .hit(hit[2]), .bullet_x(bullet_x[2]), .bullet_y(bullet_y[2]), .bullet_state(bullet_state[2]));
	bullet bullet_3 (.*, .Reset(bullet_reset[3]), .press_j(shoot[3]), .hit(hit[3]), .bullet_x(bullet_x[3]), .bullet_y(bullet_y[3]), .bullet_state(bullet_state[3]));
	bullet bullet_4 (.*, .Reset(bullet_reset[4]), .press_j(shoot[4]), .hit(hit[4]), .bullet_x(bullet_x[4]), .bullet_y(bullet_y[4]), .bullet_state(bullet_state[4]));
	bullet bullet_5 (.*, .Reset(bullet_reset[5]), .press_j(shoot[5]), .hit(hit[5]), .bullet_x(bullet_x[5]), .bullet_y(bullet_y[5]), .bullet_state(bullet_state[5]));
	bullet bullet_6 (.*, .Reset(bullet_reset[6]), .press_j(shoot[6]), .hit(hit[6]), .bullet_x(bullet_x[6]), .bullet_y(bullet_y[6]), .bullet_state(bullet_state[6]));
	bullet bullet_7 (.*, .Reset(bullet_reset[7]), .press_j(shoot[7]), .hit(hit[7]), .bullet_x(bullet_x[7]), .bullet_y(bullet_y[7]), .bullet_state(bullet_state[7]));
	bullet bullet_8 (.*, .Reset(bullet_reset[8]), .press_j(shoot[8]), .hit(hit[8]), .bullet_x(bullet_x[8]), .bullet_y(bullet_y[8]), .bullet_state(bullet_state[8]));
	bullet bullet_9 (.*, .Reset(bullet_reset[9]), .press_j(shoot[9]), .hit(hit[9]), .bullet_x(bullet_x[9]), .bullet_y(bullet_y[9]), .bullet_state(bullet_state[9]));
	bullet bullet_10 (.*, .Reset(bullet_reset[10]), .press_j(shoot[10]), .hit(hit[10]), .bullet_x(bullet_x[10]), .bullet_y(bullet_y[10]), .bullet_state(bullet_state[10]));
	bullet bullet_11 (.*, .Reset(bullet_reset[11]), .press_j(shoot[11]), .hit(hit[11]), .bullet_x(bullet_x[11]), .bullet_y(bullet_y[11]), .bullet_state(bullet_state[11]));
	bullet bullet_12 (.*, .Reset(bullet_reset[12]), .press_j(shoot[12]), .hit(hit[12]), .bullet_x(bullet_x[12]), .bullet_y(bullet_y[12]), .bullet_state(bullet_state[12]));
	bullet bullet_13 (.*, .Reset(bullet_reset[13]), .press_j(shoot[13]), .hit(hit[13]), .bullet_x(bullet_x[13]), .bullet_y(bullet_y[13]), .bullet_state(bullet_state[13]));
	bullet bullet_14 (.*, .Reset(bullet_reset[14]), .press_j(shoot[14]), .hit(hit[14]), .bullet_x(bullet_x[14]), .bullet_y(bullet_y[14]), .bullet_state(bullet_state[14]));
	bullet bullet_15 (.*, .Reset(bullet_reset[15]), .press_j(shoot[15]), .hit(hit[15]), .bullet_x(bullet_x[15]), .bullet_y(bullet_y[15]), .bullet_state(bullet_state[15]));
	bullet bullet_16 (.*, .Reset(bullet_reset[16]), .press_j(shoot[16]), .hit(hit[16]), .bullet_x(bullet_x[16]), .bullet_y(bullet_y[16]), .bullet_state(bullet_state[16]));
	bullet bullet_17 (.*, .Reset(bullet_reset[17]), .press_j(shoot[17]), .hit(hit[17]), .bullet_x(bullet_x[17]), .bullet_y(bullet_y[17]), .bullet_state(bullet_state[17]));
	bullet bullet_18 (.*, .Reset(bullet_reset[18]), .press_j(shoot[18]), .hit(hit[18]), .bullet_x(bullet_x[18]), .bullet_y(bullet_y[18]), .bullet_state(bullet_state[18]));
	bullet bullet_19 (.*, .Reset(bullet_reset[19]), .press_j(shoot[19]), .hit(hit[19]), .bullet_x(bullet_x[19]), .bullet_y(bullet_y[19]), .bullet_state(bullet_state[19]));  
		
	counter counter_69 (.frame_clk(frame_clk), .reset(counter_reset), .count(count), .start(0));	
			
always_ff @ (posedge frame_clk) begin
	//if(Reset) begin
		//state <= WAIT;
	//end
	//else begin
		delay <= delay_in;
		gengi_delay <= gengi_delay_in;
	//end
	
end

//integer i, j, k, l;

always_comb begin
	if (chara_id == 2'b00) begin//tracer 
		X_Step = 10'd6;
		fire_range = 10'd160;
		fire_period = 10'b11;
		reload_period = 10'd69;
		gengi_period = 10'd3;
	end else if (chara_id == 2'b01)begin//gengi
		X_Step = 10'd3;
		fire_range = 10'd320;
		fire_period = 10'b10;
		reload_period = 10'd100;
		gengi_period = 10'd30;
	end else begin //gengi for def
		X_Step = 10'd3;
		fire_range = 10'd320;
		fire_period = 10'b10;
		reload_period = 10'd100;
		gengi_period = 10'd30;
	end
	

	//set default case
	delay_in = delay;
	gengi_delay_in = 0;
	acc = 2'b0;

	counter_reset = 1'b0;
	bullet_color = 24'hffffff;
	dart_color_center = 24'hffffff;
	dart_color_body = 24'hffffff;
	
	for (int l = 0; l < 20; l++) begin
		bullet_reset[l] = 1'b0;
		shoot[l] = 1'b0;
	end
	
	if (delay!=10'b0) // count after shooting
		delay_in = delay + 10'b1;
	if (delay_in==fire_period) // count finish
		delay_in = 10'b0;
		
	
	// shoot
	if (delay==10'b0&&press_j) begin
		for (int i = 0; i < 20; i++) begin
			if (bullet_state[i]==2'b00) begin
				shoot[i] = 1'b1;
				counter_reset = 1'b1;
				delay_in = 1'b1;
				//if gengi
				acc = acc + 2'b01;
				break;
			end
		end
	end
	
	if (acc==2'b11)begin
		delay_in = 10'b1;
		if (gengi_delay==10'b0) // count after shooting
			gengi_delay_in = gengi_delay + 10'b1;
		if (gengi_delay_in==gengi_period) // count finish
			gengi_delay_in = 10'b0;
			acc = 2'b0;
			
		
	end
	// reload the bullets
	if (count==reload_period) begin
		for (int j = 0; j < 20; j++) begin
			bullet_reset[j] = 1'b1;
		end
	end
	
	
	// draw the bullet0.
	for (int k = 0; k < 20; k++) begin
		if (bullet_x[k]<=DrawX+1&&bullet_x[k]+1>=DrawX&&bullet_y[k]<=DrawY+1&&bullet_y[k]+1>=DrawY&&(bullet_state[k]==2'b01||bullet_state[k]==2'b10)) begin
			bullet_color = 24'hffffff;
			break;
		end
		else
			bullet_color = 24'h000000;
	end
	//gengi 12*12 pixel dart version
	
	if (chara_id == 2'b01)begin
		for (int k = 0; k < 20; k++) begin //calculate all joint points
			 dart_shape_it[k] = bullet_y[k] - 1;
			 dart_shape_ib[k] = bullet_y[k] + 1;
			 dart_shape_il[k] = bullet_x[k] - 1;
			 dart_shape_ir[k] = bullet_x[k] + 1;
			
			 dart_shape_ot[k] = bullet_y[k] - 4;
			 dart_shape_ob[k] = bullet_y[k] + 4;
			 dart_shape_ol[k] = bullet_x[k] - 4;
			 dart_shape_or[k] = bullet_x[k] + 4;
			
			 if (dart_shape_ir[k]>=DrawX&&dart_shape_il[k]<=DrawX&&dart_shape_it[k]<=DrawY&&dart_shape_ib[k]>=DrawY&&(bullet_state[k]==2'b01||bullet_state[k]==2'b10))begin
				 bullet_color = 24'hffffff;
			 end else if (
								  (dart_shape_it[k]> DrawY)&&(dart_shape_ot[k]<=DrawY)&&(dart_shape_ir[k]>=DrawX)&&(dart_shape_il[k]<=DrawX)
								||(dart_shape_ib[k]< DrawY)&&(dart_shape_ob[k]>=DrawY)&&(dart_shape_ir[k]>=DrawX)&&(dart_shape_il[k]<=DrawX)
								||(dart_shape_it[k]<=DrawY)&&(dart_shape_ib[k]>=DrawY)&&(dart_shape_il[k]> DrawX)&&(dart_shape_ol[k]<=DrawX)
								||(dart_shape_ir[k]< DrawX)&&(dart_shape_or[k]>=DrawX)&&(dart_shape_it[k]<=DrawY)&&(dart_shape_ib[k]>=DrawY)
								&&(bullet_state[k]==2'b01||bullet_state[k]==2'b10))begin
				 bullet_color = 24'hffff00;
			 end else begin
				 bullet_color = 0;
			 end
		end
		
	end else if (chara_id == 2'b00)begin //tracer
			for (int k = 0; k < 20; k++) begin
				if (bullet_x[k]<=DrawX+1&&bullet_x[k]+1>=DrawX&&bullet_y[k]<=DrawY+1&&bullet_y[k]+1>=DrawY&&(bullet_state[k]==2'b01||bullet_state[k]==2'b10)) begin
					bullet_color = 24'hffffff;
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
					 
				  output logic hit,		 
				  output logic [9:0] bullet_x, bullet_y,
				  output logic [1:0] bullet_state // 00:wait	01:moving_left 10:moving_right 11:cd
                );
	 
	 enum logic [1:0] {WAIT, MOVING_LEFT, MOVING_RIGHT, CD} state, next_state;
	 
    parameter [9:0] X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] X_Max = 10'd639;     // Rightmost point on the X axis
	
	logic [9:0] bullet_x_in, bullet_y_in; // buffer
	logic [9:0] init_x; // for range of fire

	// hit
	is_chara is_chara_instance(.DrawX(bullet_x), .DrawY(bullet_y), .left(chara_left), .right(chara_right), .top(chara_top), .bot(chara_bot), .is_chara(hit));

always_ff @ (posedge frame_clk) begin
	if(Reset) begin
		state <= WAIT;
	end
	else begin
		state <= next_state;
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
			if(hit||
			(bullet_x_in+fire_range<=init_x||bullet_x_in>=init_x+fire_range)|| // out of fire range
			(bullet_x<X_Min+X_Step&&bullet_x!=bullet_x_in)) // out of boundary
			begin
				next_state = CD;
			end
		end
		
		MOVING_RIGHT: begin
			bullet_state = 2'b10;
			bullet_x_in = bullet_x + X_Step;
			if(hit||
			(bullet_x_in+fire_range<=init_x||bullet_x_in>=init_x+fire_range)|| // out of fire range
			(bullet_x>X_Max-X_Step&&bullet_x!=bullet_x_in)) // out of boundary
			begin
				next_state = CD;
			end
		end
		
		CD: begin
			bullet_state = 2'b11;
		end
		
		default:;
	endcase
end
endmodule	
