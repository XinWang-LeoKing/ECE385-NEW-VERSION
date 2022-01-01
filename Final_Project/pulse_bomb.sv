
module  pulse_bomb (input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					 input press_w, press_a, press_s, press_d, press_k, press_l, press_i, // keyboard input
					 input on_ground, on_build, // whether the character is on the ground or on the building
					 input [6:0] width, height,
					 input [9:0] left_initial, bot_initial, bias,
					 input [1:0] chara_num,
					 input is_ready,
					 
					 input full_energy, press_i,
					 input [9:0] chara_left, chara_right, chara_top, 
					
					 output logic chara_direction, // the character face left or face right
					 output logic moving_left, moving_right, moving_up, moving_down, // whether the character is moving left/right/up
					 output logic [2:0] figure,
					 output logic [9:0] top, bot, left, right, speed_y,
					 output logic [9:0] count_k,
					 output logic reset_energy
                );
	 
    parameter [9:0] X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Y_Max = 10'd439;     // Bottommost point on the Y axis
    //parameter [9:0] X_Step = 10'd2;      // Step size on the X axis
    //parameter [9:0] Y_Step = 10'd3;      // Step size on the Y axis
	 
	logic [9:0] X_Step;
    
	logic [9:0] left_in, top_in; // input of register 
	
	logic moving_left_in, moving_right_in, chara_direction_in;
	
	logic [9:0] speed_y_before;
	
	logic [9:0] count_y, count_l, count_figure;
	logic counter_y_reset, counter_k_reset, counter_l_reset, counter_s_reset, counter_figure_reset;
	logic [2:0] figure_before;
	logic [9:0] left_recall [180];
	logic [9:0] top_recall [180];
	logic [2:0] figure_recall [180];
	
	assign bot = top + height; assign right = left + width; // the character has a size (height+1)*(width+1)
	assign reset_energy = 0;
	enum logic [2:0] {HIDEN, MOVE, ON_GROUND, HIT, BOOM} state, next_state;
		
// Update registers
always_ff @ (posedge frame_clk) begin
		moving_left <= moving_left_in;
		moving_right <= moving_right_in;
		chara_direction <= chara_direction_in;
		speed_y_before <= speed_y;
		state <= next_state;
		figure_before <= figure;
		
		top_recall[count_recall] <= top_in;
		figure_recall[count_recall] <= figure;
	
	if (Reset) begin
		left <= left_initial;
		top <= bot_initial - height;
		state <= HIDEN;
		figure_before <= 0;
	end
	else if ((right>X_Max-X_Step&&chara_direction)||(left<X_Min+X_Step&&~chara_direction)) begin // out of left or right boundary
		top <= top_in;
		left_recall[count_recall] <= left;
	end
	else begin
		left <= left_in;
		top <= top_in;
		left_recall[count_recall] <= left_in;
	end
end

always_comb begin
		// default case
		X_Step = 10'd2;
		
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
	

	
	// moving up and down
	unique case (state)
		HIDEN: begin
			if (press_i&&full_energy) begin
				next_state = MOVE;
				y_in = chara_top - 10'd10;
				if (~direction)
					x_in = chara_left - 10'd3; // not consider boundary condition!!!
					speed_x = 10'b1111111010; // -6
				else
					x_in = chara_right + 10'd3;
					speed_x = 10'd6;
			end
			
			
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
		
		MOVE: begin
			x_in = x + speed_x;
			y_in = y + 10'd6;
			
			// on the ground
			if (hit) // hit
			
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
			
			
			/*if (press_a) //left
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
	end*/
		end
		
		ON_GROUND: begin
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
		
		HIT: begin
			
		end
		
		BOOM: begin
		
		end
		
		
		default:;
	endcase
	
	// calculate the top position
	top_in = top + speed_y + bias;
	
	
	counter_k_reset = 0;
	counter_l_reset = 0;
	counter_recall_reset = 0;
	
	unique case (chara_num)
		2'b00: begin // tracer
			// blink
			if (press_k&&count_k>=180) begin // cd is 180 frame clks
				counter_k_reset = 1'b1;
			end
			if (count_k==10'd3) begin
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
			if (count_recall>=179)
				counter_recall_reset = 1'b1;
			if (press_l&&count_l>=720) begin
				counter_l_reset = 1'b1;
			end
			if (count_l>=0&&count_l<=10'd29) begin
				if (count_recall >= count_l*7) begin
					left_in = left_recall[count_recall-count_l*7];
					top_in = top_recall[count_recall-count_l*7];
					figure = figure_recall[count_recall-count_l*7];
				end
				else begin
					left_in = left_recall[count_recall-count_l*7+180];
					top_in = top_recall[count_recall-count_l*7+180];
					figure = figure_recall[count_recall-count_l*7+180];
				end
			end
		end
		
		2'b01: begin
			//shift

			if (press_k&&count_k>=540)begin
				counter_k_reset = 1'b1;
				counter_s_reset = 1'b1;
			end
			if (count_s<=10'd30) begin
				if(chara_direction == 1'b0)
					chara_direction_in = 1'b0;
				else if(chara_direction == 1'b1)
					chara_direction_in = 1'b1;
				X_Step = X_Step + 10'd10;
				
			end
		end

		default:;
	endcase
	

		
end

counter counter_y(.reset(counter_y_reset), .frame_clk(frame_clk), .count(count_y));
counter counter_k(.reset(counter_k_reset), .frame_clk(frame_clk), .count(count_k));
counter counter_l(.reset(counter_l_reset), .frame_clk(frame_clk), .count(count_l));
counter counter_s(.reset(counter_s_reset), .frame_clk(frame_clk), .count(count_s));
counter counter_figure(.reset(counter_figure_reset), .frame_clk(frame_clk), .count(count_figure));
counter counter_recall(.reset(counter_recall_reset), .frame_clk(frame_clk), .count(count_recall));


endmodule	