
module  pulse_bomb (input Reset,              // Active-high reset signal
                          frame_clk,          // The clock indicating a new frame (~60Hz)
					 input on_ground, on_build, // whether the character is on the ground or on the building
					 input [1:0] chara_id,
					 input full_energy, press_u, chara_direction,
					 input [9:0] chara_left, chara_right, chara_top, DrawX, DrawY, bias,
					 input [9:0] opponent_left, opponent_right, opponent_top, opponent_bot,
					 input deflect_left, deflect_right,
					 
					 output logic [23:0] bomb_color, 
					 output logic [9:0] left, right, top, bot,
					 output logic [9:0] speed_y, count_boom,
					 output logic BOMB_hit, BOOM_hit
                );
	enum logic [2:0] {HIDDEN, MOVE, ON_GROUND, HIT, BOOM} state, next_state;
	
	logic [9:0] opponent_left_before, opponent_top_before, X_Step, X_Step_before, left_in, top_in;
	logic counter_boom_reset, bomb_hit, boom_hit;
	
	
	assign right = left + 10'd6;
	assign bot = top + 10'd6;
	assign hit = 0; // ???

always_ff @ (posedge frame_clk) begin
	state <= next_state;
	opponent_left_before <= opponent_left;
	opponent_top_before <= opponent_top;
	left <= left_in;
	top <= top_in;
	X_Step_before <= X_Step;
	if (Reset) begin
		state <= HIDDEN;
	end
	
end

always_comb begin
	left_in = left;
	top_in = top;
	counter_boom_reset = 0;
	speed_y = 10'd6;
	X_Step = X_Step_before;
	next_state = state;
	BOOM_hit = 0;
	BOMB_hit = 0;
	unique case (state)
		HIDDEN: begin
			if (chara_id==0&&press_u&&full_energy) begin
				next_state = MOVE;
				top_in = chara_top + 10'd10;
				if (~chara_direction) begin
					left_in = chara_left - 10'd7; // not consider boundary condition!!!
					X_Step = 10'b1111111010; // -6
				end
				else begin
					left_in = chara_right + 10'd1;
					X_Step = 10'd6;
				end
			end
		end
		
		MOVE: begin
			left_in = left + X_Step;
			top_in = top + speed_y + bias;
			if (on_ground||on_build) begin // on the ground
				next_state = ON_GROUND;
				counter_boom_reset = 1'b1;
			end
			if (bomb_hit) begin // hit
				if (X_Step==10'd6&&deflect_left) begin
					X_Step = 10'b1111110100;
				end
				else if (X_Step==10'b1111111010&&deflect_right) begin
					X_Step = 10'd12;
				end
				else begin
					next_state = HIT;
					counter_boom_reset = 1'b1;
				end
			end
		end
		
		ON_GROUND: begin
			if (bomb_hit) begin
				next_state = HIT;
			end
			if (count_boom==10'd60) begin
				next_state = BOOM;
			end
		end
		
		HIT: begin
			if (count_boom==10'd60) begin
				next_state = BOOM;
			end
			// moving with the opponent
			left_in = left + opponent_left - opponent_left_before;
			top_in = top + opponent_top - opponent_top_before;
		end
		
		BOOM: begin
			next_state = HIDDEN;
			if (bomb_hit) begin
				BOMB_hit = 1'b1;
			end
			else if (boom_hit)begin
				BOOM_hit = 1'b1;
			end
		end
		
		default:;
	endcase
	
	if (DrawX<=left_in+6&&DrawX>=left_in&&DrawY<=top_in+6&&DrawY+1>=top_in&&state!=HIDDEN) begin
		if (DrawX==left_in+2&&DrawY==top_in+1||DrawX==left_in+4&&DrawY==top_in+1) begin
			bomb_color = 24'h000000; // black
		end
		else if(DrawY+1==top_in&&(DrawX==left_in+1||DrawX==left_in+5)) begin
			bomb_color = 24'hffffff; // white
		end
		else if (DrawY==top_in+6&&DrawX>=left_in+2&&DrawX<=left_in+4) begin
			bomb_color = 24'hffa500; // orange
		end
		else if ((DrawX==left_in||DrawX==left_in+6)&&(DrawY==top_in+4)) begin
			bomb_color = 24'hffa500; // orange
		end
		else if ((DrawX==left_in||DrawX==left_in+6)&&(DrawY==top_in+2||DrawY==top_in+3)) begin
			bomb_color = 24'hffffff; // white
		end
		else if (DrawY+1==top_in||DrawY==top_in+6||DrawX==left_in||DrawX==left_in+6) begin
			bomb_color = 24'h0f0f0f; // abstract
		end
		else if ((DrawY==top_in+3&&(DrawX==left_in+2||DrawX==left_in+4))||(DrawY<=top_in+2)) begin
			bomb_color = 24'hffffff; //white
		end
		else begin
			bomb_color = 24'hffa500;
		end
	end else begin
		bomb_color = 24'h0f0f0f;
	end

		
end

counter counter_boom(.reset(counter_boom_reset), .frame_clk(frame_clk), .count(count_boom), .start(0));
is_hit bomb_hit_instance(.left(left), .right(right), .bot(bot), .top(top), .chara_left(opponent_left+10'd8), .chara_right(opponent_right-10'd8), .chara_top(opponent_top-10'd4), .chara_bot(opponent_bot+10'd4), .is_hit(bomb_hit));
is_hit boom_hit_instance(.left(left-10'd50), .right(right+10'd50), .bot(bot+10'd50), .top(top-10'd50), .chara_left(opponent_left+10'd8), .chara_right(opponent_right-10'd8), .chara_top(opponent_top-10'd4), .chara_bot(opponent_bot+10'd4), .is_hit(boom_hit));
endmodule	