module keycode_reader(input [47:0] keycode,

							 output logic press_w, press_a, press_d, press_s, press_j, press_k, press_l, press_u,
							 output logic press_up, press_left, press_down, press_right, press_1, press_2, press_3, press_4
							 );
	assign press_w = (keycode[47:40] == 8'h1A) || (keycode[39:32] == 8'h1A) || (keycode[31:24] == 8'h1A) || (keycode[23:16] == 8'h1A) || (keycode[15:8] == 8'h1A) || (keycode[7:0] == 8'h1A);
	assign press_a = (keycode[47:40] == 8'h04) || (keycode[39:32] == 8'h04) || (keycode[31:24] == 8'h04) || (keycode[23:16] == 8'h04) || (keycode[15:8] == 8'h04) || (keycode[7:0] == 8'h04);
	assign press_d = (keycode[47:40] == 8'h07) || (keycode[39:32] == 8'h07) || (keycode[31:24] == 8'h07) || (keycode[23:16] == 8'h07) || (keycode[15:8] == 8'h07) || (keycode[7:0] == 8'h07);
	assign press_s = (keycode[47:40] == 8'h16) || (keycode[39:32] == 8'h16) || (keycode[31:24] == 8'h16) || (keycode[23:16] == 8'h16) || (keycode[15:8] == 8'h16) || (keycode[7:0] == 8'h16);
	assign press_j = (keycode[47:40] == 8'h0D) || (keycode[39:32] == 8'h0D) || (keycode[31:24] == 8'h0D) || (keycode[23:16] == 8'h0D) || (keycode[15:8] == 8'h0D) || (keycode[7:0] == 8'h0D);
	assign press_k = (keycode[47:40] == 8'h0E) || (keycode[39:32] == 8'h0E) || (keycode[31:24] == 8'h0E) || (keycode[23:16] == 8'h0E) || (keycode[15:8] == 8'h0E) || (keycode[7:0] == 8'h0E);
	assign press_l = (keycode[47:40] == 8'h0F) || (keycode[39:32] == 8'h0F) || (keycode[31:24] == 8'h0F) || (keycode[23:16] == 8'h0F) || (keycode[15:8] == 8'h0F) || (keycode[7:0] == 8'h0F);
	assign press_u = (keycode[47:40] == 8'h0C) || (keycode[39:32] == 8'h0C) || (keycode[31:24] == 8'h0C) || (keycode[23:16] == 8'h0C)|| (keycode[15:8] == 8'h0C) || (keycode[7:0] == 8'h0C);
	
	assign press_up = (keycode[47:40] == 8'h52) || (keycode[39:32] == 8'h52) || (keycode[31:24] == 8'h52) || (keycode[23:16] == 8'h52) || (keycode[15:8] == 8'h52) || (keycode[7:0] == 8'h52);
	assign press_left = (keycode[47:40] == 8'h50) || (keycode[39:32] == 8'h50) || (keycode[31:24] == 8'h50) || (keycode[23:16] == 8'h50)|| (keycode[15:8] == 8'h50) || (keycode[7:0] == 8'h50);
	assign press_right = (keycode[47:40] == 8'h4f) || (keycode[39:32] == 8'h4f) || (keycode[31:24] == 8'h4f) || (keycode[23:16] == 8'h4f) || (keycode[15:8] == 8'h4f) || (keycode[7:0] == 8'h4f);
	assign press_down = (keycode[47:40] == 8'h51) || (keycode[39:32] == 8'h51) || (keycode[31:24] == 8'h51) || (keycode[23:16] == 8'h51) || (keycode[15:8] == 8'h51) || (keycode[7:0] == 8'h51);
	assign press_1 = (keycode[47:40] == 8'h59) || (keycode[39:32] == 8'h59) || (keycode[31:24] == 8'h59) || (keycode[23:16] == 8'h59)|| (keycode[15:8] == 8'h59) || (keycode[7:0] == 8'h59);
	assign press_2 = (keycode[47:40] == 8'h5A) || (keycode[39:32] == 8'h5A) || (keycode[31:24] == 8'h5A) || (keycode[23:16] == 8'h5A)|| (keycode[15:8] == 8'h5A) || (keycode[7:0] == 8'h5A);
	assign press_3 = (keycode[47:40] == 8'h5B) || (keycode[39:32] == 8'h5B) || (keycode[31:24] == 8'h5B) || (keycode[23:16] == 8'h5B)|| (keycode[15:8] == 8'h5B) || (keycode[7:0] == 8'h5B);
	assign press_4 = (keycode[47:40] == 8'h5D) || (keycode[39:32] == 8'h5D) || (keycode[31:24] == 8'h5D) || (keycode[23:16] == 8'h5D)|| (keycode[15:8] == 8'h5D) || (keycode[7:0] == 8'h5D);
endmodule