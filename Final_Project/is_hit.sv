module  is_hit   ( input [9:0]   left, right, top, bot,
						 input [9:0]   chara_left, chara_right, chara_top, chara_bot,
					
						 output logic  is_hit             // Whether current pixel belongs to ball or background
						);
	
	 // this block for judging whether the pixel belongs to the character
	 always_comb 
	 begin
			if ((top<=chara_top&&bot>=chara_top||top<=chara_bot&&bot>=chara_bot||top>=chara_top&&bot<=chara_bot)
				&& (left<=chara_left&&right>=chara_left||left<=chara_right&&right>=chara_right||left>=chara_left&&right<=chara_right))
				is_hit = 1'b1; // the pixel belongs to the character
			else
				is_hit = 1'b0;
	 end

endmodule	