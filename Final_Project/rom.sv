/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
 
// rom contains the color of background
/*
module  frameROM
(
        input [16:0] read_address,
        input Clk,

        output logic [12:0] spriteColor
);

// mem has width of 12 bits and a total of 320*240 addresses
logic [15:0] mem [76800];

initial
begin
       $readmemh("graph/Hollywood_8000.txt", mem);
end

//always_comb begin
	//spriteColor <= mem[read_address][12:0];
//end

always_ff @ (posedge Clk) begin
    spriteColor <= mem[read_address][12:0];
end

endmodule*/


/*
module  koROM
(
        input Clk,
		  input KO,
		  input [9:0] DrawX, DrawY,
        output logic [11:0] spriteColor
);


// mem has width of 12 bits and a total of 320*240 addresses
logic [11:0] mem [12800];
logic [11:0] read_address;
logic [9:0] drawx, drawy;

assign drawx = DrawX[9:1];
assign drawy = DrawY[9:1];

initial
begin
       $readmemh("graph/KO.txt", mem);
end

always_comb begin
	read_address = 0;
	spriteColor=0;
	if (KO&&DrawX>=160&&DrawX<=479&&DrawY>=160&&DrawY<=319) begin
		read_address = drawx-9'd80 + (drawy-9'd80)*160;
	end
end


always_ff @ (posedge Clk) begin
    spriteColor <= mem[read_address];
end

endmodule
*/


// rom contains the color of tracer
module tracerROM
(
        //input [11:0] read_address,
		  input chara_direction, is_chara,// moving_left, moving_right, moving_up, moving_down,
		  input [9:0] DrawX, DrawY, 
		  input [9:0] chara_left, chara_top,
		  input [2:0] figure,
        input Clk,
		  input [9:0] count_s, count_k, count_l,
		  input [1:0] chara_id,

        output logic [7:0] spriteColor
);

// mem has width of 14 bits and a total of 40*44*5 addresses
logic [7:0] mem [26400];
logic [7:0] spriteColor_in;

initial
begin
       $readmemh("graph/Tracer_Jan2.txt", mem);
		 //$readmemh("graph/Genji_Jan3.txt", mem);
end

	 logic [14:0] read_address;	
	 
always_comb begin
	if (chara_id!=0) begin
		read_address=0;
		spriteColor=0;
	end
	else begin
		read_address = (DrawX-chara_left) + (DrawY-chara_top)*40; // left
		if (chara_direction)
			read_address = 39-(DrawX-chara_left) + (DrawY-chara_top)*40; // right
		if (figure==3'b100) // jump
			read_address = read_address + 7040; // 40*44*4
		else if (figure==3'b001) // run
			read_address = read_address + 1760;
		else if (figure==3'b010)
			read_address = read_address + 3520;
		else if (figure==3'b011)
			read_address = read_address + 5280;
		if (count_l>=0&&count_l<=10'd74)
			read_address = read_address + 17600;
		else if (count_s>=0&&count_s<=10'd7) 
			read_address = read_address + 8800;
		if (is_chara)
			spriteColor = spriteColor_in;
		else
			spriteColor = 0;
	end
end

always_ff @ (posedge Clk) begin
		spriteColor_in <= mem[read_address];
end

endmodule



module genjiROM
(
        //input [11:0] read_address,
		  input chara_direction, is_chara,// moving_left, moving_right, moving_up, moving_down,
		  input [9:0] DrawX, DrawY, 
		  input [9:0] chara_left, chara_top,
		  input [2:0] figure,
        input Clk,
		  input [9:0] count_dragon,
		  input dragon, deflect,
		  input [1:0] chara_id,
		  input swift,

        output logic [7:0] spriteColor
);


logic [7:0] mem [36000];
logic [7:0] spriteColor_in;

initial
begin
       $readmemh("graph/Genji_Jan3.txt", mem);
		 //$readmemh("graph/Tracer_Jan2.txt", mem);
end

	 logic [15:0] read_address;	

always_comb begin
	if (chara_id!=2'b01) begin
		read_address=0;
		spriteColor=0;
	end
	else begin
		read_address = (DrawX-chara_left) + (DrawY-chara_top)*50; // left
		if (chara_direction)
			read_address = 49-(DrawX-chara_left) + (DrawY-chara_top)*50; // right
		if (figure==3'b100) // jump
			read_address = read_address + 6750; // 45*50*3
		else if (figure==3'b001) // run
			read_address = read_address + 2250;
		else if (figure==3'b010)
			read_address = read_address + 4500;
		else if (figure==3'b011)
			read_address = read_address + 2250;
			
			
		if (count_dragon<=10'd11||swift)
			read_address = read_address + 27000;
		else if (deflect) 
			read_address = read_address + 9000;
		else if (dragon)
			read_address = read_address + 18000;
			
		if (is_chara)
			spriteColor = spriteColor_in;
		else
			spriteColor = 0;
	end
end

always_ff @ (posedge Clk) begin
		spriteColor_in <= mem[read_address];
end

endmodule



// rom contains the color of skill
module skillROM
(
		  input [9:0] DrawX, DrawY, 
		  input [1:0] chara_id_1, chara_id_2,
        input Clk,
		  input [9:0] count_k_1, count_l_1, count_k_2, count_l_2,
		  input [1:0] blink_charge_1, blink_charge_2,

        output logic [7:0] spriteColor
);

// mem has width of 14 bits and a total of 40*44*5 addresses
logic [7:0] mem [28830];
logic [7:0] spriteColor_in;

initial
begin
       $readmemh("graph/Skill.txt", mem);
end

	 logic [14:0] read_address;
	 logic [2:0] skill_position;
	 
always_comb begin
	skill_position = 0;
	read_address = 0;
	if (DrawX>=10'd10&&DrawX<=10'd40&&DrawY>=10'd440&&DrawY<=10'd469) begin
		read_address = (DrawX-10'd10) + (DrawY-10'd440)*31;
		skill_position = 3'b001;
	end else if (DrawX>=10'd45&&DrawX<=10'd75&&DrawY>=10'd440&&DrawY<=10'd469) begin
		read_address = (DrawX-10'd45) + (DrawY-10'd440)*31;
		skill_position = 3'b010;
	end else if (DrawX>=10'd564&&DrawX<=10'd594&&DrawY>=10'd440&&DrawY<=10'd469) begin
		read_address = (DrawX-10'd564) + (DrawY-10'd440)*31;
		skill_position = 3'b011;
	end else if (DrawX>=10'd599&&DrawX<=10'd629&&DrawY>=10'd440&&DrawY<=10'd469) begin
		read_address = (DrawX-10'd599) + (DrawY-10'd440)*31;
		skill_position = 3'b100;
	end
	
	if (skill_position==3'b001) begin // p1-k (L shift)
		if (chara_id_1==2'b00) begin
			if (blink_charge_1==2'b01) begin
				read_address = read_address + 15'd930;
			end else if (blink_charge_1==2'b10) begin
				read_address = read_address + 15'd1860;
			end else if (blink_charge_1==2'b11) begin
				read_address = read_address + 15'd2790;
			end
		end
		else begin // genji
			read_address = read_address + 15'd12090;
			if (count_k_1>=60&&count_k_1<=119) begin
				read_address = read_address + 15'd6510;
			end else if (count_k_1>=120&&count_k_1<=179) begin
				read_address = read_address + 15'd5580;
			end else if (count_k_1>=180&&count_k_1<=239) begin
				read_address = read_address + 15'd4650;
			end else if (count_k_1>=240&&count_k_1<=299) begin
				read_address = read_address + 15'd3720;
			end else if (count_k_1>=300&&count_k_1<=359) begin
				read_address = read_address + 15'd2790;
			end else if (count_k_1>=360&&count_k_1<=419) begin
				read_address = read_address + 15'd1860;
			end else if (count_k_1>=420&&count_k_1<=479) begin
				read_address = read_address + 15'd930;
			end else if (count_k_1<=60) begin
				read_address = read_address + 15'd7440;
			end
		end
		
	end else if (skill_position==3'b010) begin // p1-l (E)
		if (chara_id_1==2'b00) begin
			read_address = read_address + 15'd3720;
			if (count_l_1>=90&&count_l_1<=179) begin
				read_address = read_address + 15'd6510;
			end else if (count_l_1>=180&&count_l_1<=269) begin
				read_address = read_address + 15'd5580;
			end else if (count_l_1>=270&&count_l_1<=359) begin
				read_address = read_address + 15'd4650;
			end else if (count_l_1>=360&&count_l_1<=449) begin
				read_address = read_address + 15'd3720;
			end else if (count_l_1>=450&&count_l_1<=539) begin
				read_address = read_address + 15'd2790;
			end else if (count_l_1>=540&&count_l_1<=629) begin
				read_address = read_address + 15'd1860;
			end else if (count_l_1>=630&&count_l_1<=719) begin
				read_address = read_address + 15'd930;
			end else if (count_l_1<=90) begin
				read_address = read_address + 15'd7440;
			end
		end
		else begin // genji
			read_address = read_address + 15'd20460;
			if (count_l_1>=60&&count_l_1<=119) begin
				read_address = read_address + 15'd6510;
			end else if (count_l_1>=120&&count_l_1<=179) begin
				read_address = read_address + 15'd5580;
			end else if (count_l_1>=180&&count_l_1<=239) begin
				read_address = read_address + 15'd4650;
			end else if (count_l_1>=240&&count_l_1<=299) begin
				read_address = read_address + 15'd3720;
			end else if (count_l_1>=300&&count_l_1<=359) begin
				read_address = read_address + 15'd2790;
			end else if (count_l_1>=360&&count_l_1<=419) begin
				read_address = read_address + 15'd1860;
			end else if (count_l_1>=420&&count_l_1<=479) begin
				read_address = read_address + 15'd930;
			end else if (count_l_1<=60) begin
				read_address = read_address + 15'd7440;
			end
		end
		 
	end else if (skill_position==3'b011) begin// p2-k (L shift)
		if (chara_id_2==2'b00) begin
			if (blink_charge_2==2'b01) begin
				read_address = read_address + 15'd930;
			end else if (blink_charge_2==2'b10) begin
				read_address = read_address + 15'd1860;
			end else if (blink_charge_2==2'b11) begin
				read_address = read_address + 15'd2790;
			end
		end
		else begin // genji
			read_address = read_address + 15'd12090;
			if (count_k_2>=60&&count_k_2<=119) begin
				read_address = read_address + 15'd6510;
			end else if (count_k_2>=120&&count_k_2<=179) begin
				read_address = read_address + 15'd5580;
			end else if (count_k_2>=180&&count_k_2<=239) begin
				read_address = read_address + 15'd4650;
			end else if (count_k_2>=240&&count_k_2<=299) begin
				read_address = read_address + 15'd3720;
			end else if (count_k_2>=300&&count_k_2<=359) begin
				read_address = read_address + 15'd2790;
			end else if (count_k_2>=360&&count_k_2<=419) begin
				read_address = read_address + 15'd1860;
			end else if (count_k_2>=420&&count_k_2<=479) begin
				read_address = read_address + 15'd930;
			end else if (count_k_2<=60) begin
				read_address = read_address + 15'd7440;
			end
		end
		
	end else if (skill_position==3'b100) begin // p2-l (E)
		if (chara_id_2==2'b00) begin
			read_address = read_address + 15'd3720;
			if (count_l_2>=90&&count_l_2<=179) begin
				read_address = read_address + 15'd6510;
			end else if (count_l_2>=180&&count_l_2<=269) begin
				read_address = read_address + 15'd5580;
			end else if (count_l_2>=270&&count_l_2<=359) begin
				read_address = read_address + 15'd4650;
			end else if (count_l_2>=360&&count_l_2<=449) begin
				read_address = read_address + 15'd3720;
			end else if (count_l_2>=450&&count_l_2<=539) begin
				read_address = read_address + 15'd2790;
			end else if (count_l_2>=540&&count_l_2<=629) begin
				read_address = read_address + 15'd1860;
			end else if (count_l_2>=630&&count_l_2<=719) begin
				read_address = read_address + 15'd930;
			end else if (count_l_2<=90) begin
				read_address = read_address + 15'd7440;
			end
		end
		else begin // genji
			read_address = read_address + 15'd20460;
			if (count_l_2>=60&&count_l_2<=119) begin
				read_address = read_address + 15'd6510;
			end else if (count_l_2>=120&&count_l_2<=179) begin
				read_address = read_address + 15'd5580;
			end else if (count_l_2>=180&&count_l_2<=239) begin
				read_address = read_address + 15'd4650;
			end else if (count_l_2>=240&&count_l_2<=299) begin
				read_address = read_address + 15'd3720;
			end else if (count_l_2>=300&&count_l_2<=359) begin
				read_address = read_address + 15'd2790;
			end else if (count_l_2>=360&&count_l_2<=419) begin
				read_address = read_address + 15'd1860;
			end else if (count_l_2>=420&&count_l_2<=479) begin
				read_address = read_address + 15'd930;
			end else if (count_l_2<=60) begin
				read_address = read_address + 15'd7440;
			end
		end
		 
	end
	
	if (skill_position!=0)
		spriteColor = spriteColor_in;
	else
		spriteColor = 8'hff; // outside
end

always_ff @ (posedge Clk) begin
		spriteColor_in <= mem[read_address];
end

endmodule



module bomb_warningROM
(
		  input [9:0] DrawX, DrawY, 
		  input [1:0] chara_id,
        input Clk,
		  input [9:0] bomb_left, bomb_top,
		  input [9:0] count_bomb,

        output logic  spriteColor
);

// mem has width of 14 bits and a total of 40*44*5 addresses
logic [3:0] mem [480];
logic  spriteColor_in;

initial
begin
       $readmemh("graph/BOMB.txt", mem);
end

	 logic [8:0] read_address;
	 
always_comb begin
	read_address = 0;
	spriteColor = 0;
	// for test
	//if (DrawX+10'd9>=10'd300&&DrawX<=10'd300+10'd14&&DrawY+10'd27>=10'd300&&DrawY+10'd8<=10'd300)
		//spriteColor = 1'b1;
	
	if (chara_id==0&&(DrawX+10'd9>=bomb_left&&DrawX<=bomb_left+10'd14&&DrawY+10'd27>=bomb_top&&DrawY+10'd8<=bomb_top)) begin
		// for test
		//spriteColor=1'b1;
		
		read_address = (DrawX+10'd9-bomb_left) + (DrawY+10'd27-bomb_top)*24;
		if (count_bomb>=0&&count_bomb<=19||count_bomb>=40&&count_bomb<=59) begin
			spriteColor = spriteColor_in;
		end
	end
	else
		spriteColor = 0; // outside
end

always_ff @ (posedge Clk) begin
		spriteColor_in <= mem[read_address][0];
end

endmodule


/*
module dragonROM
(
		  input [9:0] DrawX, DrawY, 
		  input dragon,
        input Clk,
		  input pl,
		  input [9:0] chara_left, chara_top,
		  input [9:0] count_dragon,

        output logic  [3:0] spriteColor
);

// mem has width of 14 bits and a total of 40*44*5 addresses
logic [3:0] mem [360];
logic  [3:0] spriteColor_in;

initial
begin
       $readmemh("graph/dragon.txt", mem);
end

	 logic [8:0] read_address;
	 
always_comb begin
	read_address = 0;
	spriteColor = 0;
	if (dragon) begin
		if (count_dragon<=14&&DrawX<=chara_left+34&&DrawX>=chara_left+15&&DrawY<=chara_top+8&&DrawY>=chara_top-9) begin // show dragon
			read_address = (DrawX-10'd15-chara_left) + (DrawY+10'9-chara_top)*20;
		end
		//read_address = (DrawX+10'd9-bomb_left) + (DrawY+10'd27-bomb_top)*24;
		/*else if (count_dragon<=&&DrawX<=chara_left+34&&DrawX>=chara_left+15&&DrawY<=chara_top+8&&DrawY>=chara_top-9) begin
			spriteColor = spriteColor_in;
		end else if 
		
		end
	end
	else
		spriteColor = 0; // outside
end

always_ff @ (posedge Clk) begin
		spriteColor_in <= mem[read_address];
end

endmodule
*/