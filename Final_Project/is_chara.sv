module  is_chara ( input [9:0]   DrawX, DrawY,       // Current pixel coordinates
						 input [9:0]   left, right, top, bot,
					
						 output logic  is_chara             // Whether current pixel belongs to ball or background
						);
	
	 // this block for judging whether the pixel belongs to the character
	 always_comb 
	 begin
			if (DrawX>=left&&DrawX<=right&&DrawY>=top&&DrawY<=bot)
				is_chara = 1'b1; // the pixel belongs to the character
			else
				is_chara = 1'b0;
	 end

endmodule	