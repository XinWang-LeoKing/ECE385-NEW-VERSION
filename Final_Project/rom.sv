/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
 
// rom contains the color of background

/*module  frameROM
(
        input [16:0] read_address,
        input Clk,

        output logic [11:0] spriteColor
);

// mem has width of 12 bits and a total of 320*240 addresses
logic [11:0] mem [76799];

initial
begin
       $readmemh("graph/Hollywood_4088color.txt", mem);
end

always_ff @ (posedge Clk) begin
    spriteColor <= mem[read_address];
end

endmodule*/



// rom contains the color of tracer
/*module tracerROM
(
        input [10:0] read_address,
        input Clk,

        output logic [23:0] spriteColor
);

// mem has width of 12 bits and a total of 31*42 addresses
logic [23:0] mem [1302];

initial
begin
       $readmemh("graph/tracer_LR.txt", mem);
end


always_comb begin
    spriteColor <= mem[read_address]; // why not use combinational logic here?
end

endmodule*/

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

        output logic [7:0] spriteColor
);

// mem has width of 14 bits and a total of 40*44*5 addresses
logic [7:0] mem [17600];
logic [7:0] spriteColor_in;

initial
begin
       $readmemh("graph/Tracer_Jan1.txt", mem);
end

	 logic [13:0] read_address;	
	 
always_comb begin
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
	if ((count_s>=0&&count_s<=10'd7)||(count_l>=0&&count_l<=10'd74))
		read_address = read_address + 8800;
		
	if (is_chara)
		spriteColor = spriteColor_in;
	else
		spriteColor = 0;
end

always_ff @ (posedge Clk) begin
		spriteColor_in <= mem[read_address];
end

endmodule