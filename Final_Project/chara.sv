//
module  chara (input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					 input press_w, press_a, press_s, press_d, press_k, press_l, press_u, press_j,  // keyboard input
					 input on_ground, on_build, // whether the character is on the ground or on the building
					 //input [6:0] width, height,
					 input [9:0] left_initial, bot_initial, bias,
					 input [1:0] chara_id,
					 input is_ready,
					 input [9:0] opponent_left, opponent_right, opponent_top, opponent_bot,
					 input pl,
					
					 output logic chara_direction, // the character face left or face right
					 output logic moving_left, moving_right, moving_up, moving_down, // whether the character is moving left/right/up
					 output logic [2:0] figure,
					 output logic [9:0] top, bot, left, right, speed_y,
					 output logic [9:0] count_k, count_l, count_s, count_u, count_dragon, count_recall,
					 output logic reset_energy, dragon, DRAGON_hit, SWIFT_hit,
					 output logic recall, deflect, deflect_left, deflect_right,
					 output logic [1:0] blink_charge,
					 output logic swift,
					 output logic test
                );
	 
    parameter [9:0] X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Y_Max = 10'd439;     // Bottommost point on the Y axis
    //parameter [9:0] X_Step = 10'd2;      // Step size on the X axis
    //parameter [9:0] Y_Step = 10'd3;      // Step size on the Y axis
	 
	logic [9:0] X_Step, index_recall;
	logic COUNTER_START;
	logic press_k_before;
	logic K_START;
	
	logic [6:0] width, height; 
    
	logic [9:0] left_in, top_in; // input of register 
	
	logic moving_left_in, moving_right_in, chara_direction_in;
	
	logic [9:0] speed_y_before;
	
	logic [9:0] count_y, count_figure;
	logic counter_y_reset, counter_k_reset, counter_l_reset, counter_s_reset, counter_figure_reset, counter_recall_reset, counter_u_reset, counter_dragon_reset;
	logic [2:0] figure_before;
	logic [9:0] left_recall [300];
	logic [9:0] top_recall [300];
	logic [2:0] figure_recall [300];
	logic [1:0] blink_charge_in;
	logic dragon_left_hit, dragon_right_hit, swift_hit;
	
	assign bot = top + height; assign right = left + width; // the character has a size (height+1)*(width+1)
	assign reset_energy = 0;
	enum logic [1:0] {STAND, MOVING_UP, MOVING_DOWN} state_y, next_state_y;
	enum logic [1:0] {WAIT, DEFLECT} state_deflect, next_state_deflect;
	enum logic [1:0] {DRAGON_WAIT, DRAGON_PREPARED, DRAGON_CD} state_dragon , next_state_dragon;
		
// Update registers
always_ff @ (posedge frame_clk) begin
		moving_left <= moving_left_in;
		moving_right <= moving_right_in;
		chara_direction <= chara_direction_in;
		speed_y_before <= speed_y;
		state_y <= next_state_y;
		figure_before <= figure;
		blink_charge <= blink_charge_in;
		press_k_before <= press_k;
		state_dragon <= next_state_dragon;
		state_deflect <= next_state_deflect;

		COUNTER_START <= 0;
	
	if (Reset) begin
		left <= left_initial;
		top <= bot_initial - height;
		state_y <= STAND;
		figure_before <= 0;
		COUNTER_START <= 1'b1;
		blink_charge <= 2'b1;
		test <= 0;
		state_dragon <= DRAGON_WAIT;
		state_deflect <= WAIT;
		if (~pl)
			chara_direction <= 1'b1;
		else
			chara_direction <= 0;
	end
	else if (count_l<=74&&chara_id==0) begin
		left <= left_in;
		top <= top_in;
	end
	else if ((right>X_Max-X_Step&&chara_direction)||(left<X_Min+X_Step&&~chara_direction)) begin // out of left or right boundary
		top <= top_in;
	end
	else begin
		left <= left_in;
		top <= top_in;
	end
	
	// recall, tracer
	if (count_l>=75) begin
		top_recall[count_recall] <= top_in;
		figure_recall[count_recall] <= figure;
		left_recall[count_recall] <= left;
	end
	// test
	if (state_dragon!=DRAGON_WAIT)
		test <= 1'b1;
end

always_comb begin
		// default case
		width = 7'd39;
		height = 7'd43;
		if (chara_id==0) begin
			width = 7'd39;
			height = 7'd43;
		end if (chara_id==2'b01) begin
			width = 7'd49;
			height = 7'd44;
		end
		
		if (COUNTER_START) begin
			K_START = 1'b1;
		end
		else begin
			K_START = 0;
		end
		left_in = left;
		chara_direction_in = chara_direction;
		moving_left_in = moving_left;
		moving_right_in = moving_right;
		speed_y = speed_y_before;
		counter_y_reset = 0;
		counter_s_reset = 0;
		next_state_y = state_y;
		moving_down = 0;
		moving_up = 0;
		figure = figure_before;
		counter_figure_reset = 1'b0;
		
	
	// moving left and right
	if (press_a) //left
	begin
		left_in = left + (~(X_Step) + 1'b1);
		chara_direction_in = 1'b0; // face left
		moving_left_in = 1'b1;
	end
	else if (press_d) //right
	begin
		left_in = left + X_Step;
		chara_direction_in = 1'b1; // face right
		moving_right_in = 1'b1;
	end
	
	//decide which figure
	if (left_in!=left) begin
		if (count_figure==10'b000) begin
			if (figure==3'b000)
				figure = 3'b001;
			else
				figure = 3'b011;
		end
		else if (count_figure==10'b1000) begin
			if (figure==3'b001)
				figure = 3'b010;
			else
				figure = 3'b000;
		end
		else if (count_figure==10'b1110)
			counter_figure_reset = 1'b1;
	end
	else begin
		counter_figure_reset = 1'b1;
		if (chara_id==0) begin
			if (figure==3'b001)
				figure = 3'b010;
			if (figure==3'b011)
				figure = 3'b000;
		end
		else if (chara_id==2'b01) begin
			figure = 3'b000;
		end
	end
	
	index_recall = 0;
	// moving up and down
	unique case (state_y)
		STAND: begin
			if(press_w&&(on_ground||on_build)) begin
				counter_y_reset = 1'b1;
				speed_y = 10'b1111111010; // initial speed in y-direction is -6
				next_state_y = MOVING_UP;
			end
			else if (press_s&&on_build) begin // press s and drop down
				next_state_y = MOVING_DOWN;
				speed_y = 10'b1;
				counter_y_reset = 1'b1;
			end
			else if (~on_ground&&~on_build) begin // no ground below and drop down
				next_state_y = MOVING_DOWN;
				speed_y = 10'b1;
				counter_y_reset = 1'b1;
			end
			else
				speed_y = 0;
		end
		
		MOVING_UP: begin
			moving_up = 1;
			figure = 3'b100;
			if (speed_y==0) begin // from up to down
				speed_y = 10'b1; // initial speed in y-direction is 1
				next_state_y = MOVING_DOWN;
				counter_y_reset = 1'b1;
			end
			else if (count_y==10'd3) begin // speed down per 4 frame clk
				speed_y = speed_y_before + 1'b1;
				counter_y_reset = 1'b1;
			end
			else begin
				counter_y_reset = 1'b0;
			end
		end
		
		MOVING_DOWN: begin
			moving_down = 1;
			figure = 3'b100;
			if (on_ground||(on_build&&~press_s)) begin// touch the ground
				next_state_y = STAND;
				figure = 0;
				speed_y = 0;
			end
			else if (count_y==10'd3) begin // speed up per 4 frame clk
				speed_y = speed_y_before + 1'b1;
				counter_y_reset = 1'b1;
			end
			else begin
				counter_y_reset = 1'b0;
			end
		end
		default:;
	endcase
	
	// calculate the top position
	top_in = top + speed_y + bias;
	
	
	counter_k_reset = 0;
	counter_l_reset = 0;
	counter_recall_reset = 0;
	counter_u_reset = 0;
	counter_dragon_reset = 0;
	X_Step = 10'd2;
	blink_charge_in = blink_charge;
	next_state_dragon = state_dragon;
	next_state_deflect = state_deflect;
	dragon = 0;
	DRAGON_hit = 0;
	SWIFT_hit = 0;
	recall = 0;
	deflect = 0;
	deflect_left = 0;
	deflect_right = 0;
	swift = 0;
	
	unique case (chara_id)
		2'b00: begin // tracer
			// blink
			if (press_k&&~press_k_before&&blink_charge!=0&&count_s>=10'd6) begin
				counter_s_reset = 1'b1;
				blink_charge_in = blink_charge - 2'b01;
			end
			if (blink_charge==2'b11) // do not charge when have 3 charges
				counter_k_reset = 1'b1;
			else if (blink_charge!=2'b11&&count_k>=180) begin // cd is 180 frame clks
				counter_k_reset = 1'b1;
				blink_charge_in = blink_charge + 2'b01;
			end
			if (count_s==10'd3) begin
				if (~chara_direction&&left_in>=10'd75) begin
					left_in = left - 10'd75; // displacement is 75
				end
				else if (~chara_direction) begin // left boundary
					left_in = 0;
				end
				else if (chara_direction&&left_in+width<=10'd564) begin // 639-75=564
					left_in = left + 10'd75;
				end
				else begin // right boundary
					left_in = 10'd639 - width;
				end
			end
			
			//recall
			if (count_recall>=299)
				counter_recall_reset = 1'b1;
			if (press_l&&count_l>=720) begin //cd is 12sec
				counter_l_reset = 1'b1;
			end
			
			if (count_l>=10'd0&&count_l<=10'd9) begin // 1frames/frame
				if (count_recall >= (count_l+1'b1)*2) begin
					index_recall = count_recall-(count_l+1'b1)*2;
				end
				else begin
					index_recall = count_recall-(count_l+1'b1)*2+300;
				end
			end
			if (count_l>=10'd10&&count_l<=10'd19) begin // 2frames/frame
				if (count_recall+10 >= (count_l+1'b1)*3) begin
					index_recall = count_recall-(count_l+1'b1)*3+10;
				end
				else begin
					index_recall = count_recall-(count_l+1'b1)*3+310;
				end
			end
			if (count_l>=10'd20&&count_l<=10'd29) begin // 3frames/frame
				if (count_recall+30 >= (count_l+1'b1)*4) begin
					index_recall = count_recall-(count_l+1'b1)*4+30;
				end
				else begin
					index_recall = count_recall-(count_l+1'b1)*4+330;
				end
			end
			if (count_l>=10'd30&&count_l<=10'd44) begin // 4frames/frame
				if (count_recall+60 >= (count_l+1'b1)*5) begin
					index_recall = count_recall-(count_l+1'b1)*5+60;
				end
				else begin
					index_recall = count_recall-(count_l+1'b1)*5+360;
				end
			end
			if (count_l>=10'd45&&count_l<=10'd54) begin // 3frames/frame
				if (count_recall+15 >= (count_l+1'b1)*4) begin
					index_recall = count_recall-(count_l+1'b1)*4+15;
				end
				else begin
					index_recall = count_recall-(count_l+1'b1)*4+315;
				end
			end
			if (count_l>=10'd55&&count_l<=10'd64) begin // 2frames/frame
				if (count_recall >= (count_l+1'b1)*3+40) begin
					index_recall = count_recall-(count_l+1'b1)*3-40;
				end
				else begin
					index_recall = count_recall-(count_l+1'b1)*3+260;
				end
			end
			if (count_l>=10'd65&&count_l<=10'd74) begin // 1frames/frame
				if (count_recall >= (count_l+1'b1)*2+105) begin
					index_recall = count_recall-(count_l+1'b1)*2-105;
				end
				else begin
					index_recall = count_recall-(count_l+1'b1)*2+195;
				end
			end
			if (count_l<=10'd74) begin
				left_in = left_recall[index_recall];
				top_in = top_recall[index_recall];
				figure = figure_recall[index_recall];
			end
			if (count_l==10'd74) begin
				recall = 1'b1;
			end
		end
		
		2'b01: begin
			//swift (L shift)
			if (press_k&&count_k>=480)begin
				counter_k_reset = 1'b1;
				next_state_deflect = WAIT;
				//counter_s_reset = 1'b1;
			end
			if (count_k<=10'd29) begin
				swift = 1'b1;
				X_Step = 10'd8;
				if(chara_direction == 1'b0) begin
					chara_direction_in = 1'b0;
					left_in = left + (~X_Step) + 1'b1;
				end
				else if(chara_direction == 1'b1) begin
					chara_direction_in = 1'b1;
					left_in = left + X_Step;
				end
				if (swift_hit) begin
					SWIFT_hit = 1'b1;
				end
			end
			
			//deflect
			unique case (state_deflect)
				WAIT: begin
					if (press_l&&count_l>=480&&count_k>=10'd30) begin // cannot deflect when swift
						next_state_deflect = DEFLECT;
						counter_l_reset = 1'b1;
					end
				end
				DEFLECT: begin
					deflect = 1'b1;
					if (~chara_direction) begin
						deflect_left = 1'b1;
					end
					else begin
						deflect_right = 1'b1;
					end
					if (~press_l||count_l>=120) begin // deflect 2sec
						next_state_deflect = WAIT;
					end
				end
				default:;
			endcase
			
			//dragonblade
			unique case (state_dragon)
				DRAGON_WAIT: begin
					if (press_u&&is_ready) begin
						next_state_dragon = DRAGON_PREPARED;
						counter_u_reset = 1'b1;
						dragon = 1'b1;
						K_START = 1'b1; // refresh L shift
					end
				end
				DRAGON_PREPARED: begin
					X_Step = 10'd3;
					dragon = 1'b1;
					if (count_u>=10'd359) begin // 6sec
						next_state_dragon = DRAGON_WAIT;
					end
					if (press_j) begin // attack
						next_state_dragon = DRAGON_CD;
						counter_dragon_reset = 1'b1;
						if ((dragon_left_hit&&~chara_direction)||(dragon_right_hit&&chara_direction)) begin
							DRAGON_hit = 1'b1;
						end
					end
				end
				DRAGON_CD: begin
					X_Step = 10'd3;
					dragon = 1'b1;
					if (count_u>=10'd359) begin // 6sec
						next_state_dragon = DRAGON_WAIT;
					end
					if (count_dragon>=48) begin
						next_state_dragon = DRAGON_PREPARED;
					end
				end
				default:;
			endcase
			
		end

		default:;
	endcase
		
end

counter counter_y(.reset(counter_y_reset), .frame_clk(frame_clk), .count(count_y), .start(COUNTER_START));
counter counter_k(.reset(counter_k_reset), .frame_clk(frame_clk), .count(count_k), .start(K_START));
counter counter_l(.reset(counter_l_reset), .frame_clk(frame_clk), .count(count_l), .start(COUNTER_START));
counter counter_s(.reset(counter_s_reset), .frame_clk(frame_clk), .count(count_s), .start(COUNTER_START));
counter counter_u(.reset(counter_u_reset), .frame_clk(frame_clk), .count(count_u), .start(COUNTER_START));
counter counter_dragon(.reset(counter_dragon_reset), .frame_clk(frame_clk), .count(count_dragon), .start(COUNTER_START));
counter counter_figure(.reset(counter_figure_reset), .frame_clk(frame_clk), .count(count_figure), .start(0));
counter counter_recall(.reset(counter_recall_reset), .frame_clk(frame_clk), .count(count_recall), .start(0));
is_hit dragon_left_hit_instance(.left(left-10'd40), .right(right), .bot(bot), .top(top-10'd20), .chara_left(opponent_left+10'd8), .chara_right(opponent_right-10'd8), .chara_top(opponent_top-10'd4), .chara_bot(opponent_bot+10'd4), .is_hit(dragon_left_hit));
is_hit dragon_right_hit_instance(.left(left), .right(right+10'd40), .bot(bot), .top(top-10'd20), .chara_left(opponent_left+10'd8), .chara_right(opponent_right-10'd8), .chara_top(opponent_top-10'd4), .chara_bot(opponent_bot+10'd4), .is_hit(dragon_right_hit));
is_hit swift_hit_instance(.left(left), .right(right), .bot(bot), .top(top), .chara_left(opponent_left+10'd8), .chara_right(opponent_right-10'd8), .chara_top(opponent_top-10'd4), .chara_bot(opponent_bot+10'd4), .is_hit(swift_hit));

endmodule	