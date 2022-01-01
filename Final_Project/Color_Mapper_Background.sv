//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// This color mapper is for the background

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (input [9:0] DrawX, DrawY, // Current pixel coordinates
                      input [7:0] spriteColor, // for background
							 input [23:0] spriteColor_tracer, // for tracer
							 input is_tracer, // current pixel belongs to tracer or not
                      
                      output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
							 );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    // Assign color based on the coordinate
    always_comb
    begin
			if (is_tracer&&spriteColor_tracer!=24'hffffff)// draw tracer
			begin
					Red   = spriteColor_tracer[23:16];
					Green = spriteColor_tracer[15:8];
					Blue  = spriteColor_tracer[7:0];
			end
			else // draw background
			begin
				  Red   = 8'h00;
				  Green = 8'hff;
				  Blue  = 8'hff;/*
				  case(spriteColor)
8'h0:
begin
    Red = 8'hdc;
    Green = 8'h60;
    Blue = 8'h38;
end
8'h1:
begin
    Red = 8'hf2;
    Green = 8'h78;
    Blue = 8'h4b;
end
8'h2:
begin
    Red = 8'hef;
    Green = 8'h69;
    Blue = 8'h38;
end
8'h3:
begin
    Red = 8'hf4;
    Green = 8'h96;
    Blue = 8'h5f;
end
8'h4:
begin
    Red = 8'hf9;
    Green = 8'hac;
    Blue = 8'h80;
end
8'h5:
begin
    Red = 8'hc2;
    Green = 8'h4f;
    Blue = 8'h31;
end
8'h6:
begin
    Red = 8'haa;
    Green = 8'h42;
    Blue = 8'h2a;
end
8'h7:
begin
    Red = 8'hd3;
    Green = 8'hd5;
    Blue = 8'hd9;
end
8'h8:
begin
    Red = 8'hd1;
    Green = 8'hbf;
    Blue = 8'hc8;
end
8'h9:
begin
    Red = 8'he5;
    Green = 8'h83;
    Blue = 8'h5e;
end
8'ha:
begin
    Red = 8'hd2;
    Green = 8'h91;
    Blue = 8'h87;
end
8'hb:
begin
    Red = 8'hd1;
    Green = 8'h7f;
    Blue = 8'h70;
end
8'hc:
begin
    Red = 8'ha0;
    Green = 8'h37;
    Blue = 8'h16;
end
8'hd:
begin
    Red = 8'hce;
    Green = 8'h76;
    Blue = 8'h5a;
end
8'he:
begin
    Red = 8'hd5;
    Green = 8'h4c;
    Blue = 8'h23;
end
8'hf:
begin
    Red = 8'hfc;
    Green = 8'hdc;
    Blue = 8'h6e;
end
8'h10:
begin
    Red = 8'hed;
    Green = 8'hb9;
    Blue = 8'h4d;
end
8'h11:
begin
    Red = 8'hdf;
    Green = 8'ha6;
    Blue = 8'h3d;
end
8'h12:
begin
    Red = 8'hfc;
    Green = 8'hc4;
    Blue = 8'h63;
end
8'h13:
begin
    Red = 8'hdc;
    Green = 8'h74;
    Blue = 8'h36;
end
8'h14:
begin
    Red = 8'hd9;
    Green = 8'h4c;
    Blue = 8'h37;
end
8'h15:
begin
    Red = 8'ha6;
    Green = 8'h72;
    Blue = 8'h1c;
end
8'h16:
begin
    Red = 8'h33;
    Green = 8'h1d;
    Blue = 8'h1d;
end
8'h17:
begin
    Red = 8'h46;
    Green = 8'h27;
    Blue = 8'h1f;
end
8'h18:
begin
    Red = 8'h5f;
    Green = 8'h44;
    Blue = 8'h37;
end
8'h19:
begin
    Red = 8'hf6;
    Green = 8'hd6;
    Blue = 8'hb0;
end
8'h1a:
begin
    Red = 8'h6b;
    Green = 8'h8e;
    Blue = 8'h88;
end
8'h1b:
begin
    Red = 8'h81;
    Green = 8'h93;
    Blue = 8'h8e;
end
8'h1c:
begin
    Red = 8'hf6;
    Green = 8'he4;
    Blue = 8'hca;
end
8'h1d:
begin
    Red = 8'h99;
    Green = 8'ha7;
    Blue = 8'h9d;
end
8'h1e:
begin
    Red = 8'hf5;
    Green = 8'hc4;
    Blue = 8'h91;
end
8'h1f:
begin
    Red = 8'h60;
    Green = 8'h9c;
    Blue = 8'ha8;
end
8'h20:
begin
    Red = 8'hcd;
    Green = 8'hc2;
    Blue = 8'ha7;
end
8'h21:
begin
    Red = 8'hb1;
    Green = 8'hb0;
    Blue = 8'h9c;
end
8'h22:
begin
    Red = 8'he2;
    Green = 8'hcb;
    Blue = 8'haf;
end
8'h23:
begin
    Red = 8'he9;
    Green = 8'h51;
    Blue = 8'h1d;
end
8'h24:
begin
    Red = 8'h0d;
    Green = 8'hb3;
    Blue = 8'hff;
end
8'h25:
begin
    Red = 8'h57;
    Green = 8'h8f;
    Blue = 8'h95;
end
8'h26:
begin
    Red = 8'hf0;
    Green = 8'hc1;
    Blue = 8'h76;
end
8'h27:
begin
    Red = 8'hb7;
    Green = 8'h9f;
    Blue = 8'h81;
end
8'h28:
begin
    Red = 8'h9e;
    Green = 8'h89;
    Blue = 8'h75;
end
8'h29:
begin
    Red = 8'hd1;
    Green = 8'h95;
    Blue = 8'h6b;
end
8'h2a:
begin
    Red = 8'ha5;
    Green = 8'h5c;
    Blue = 8'h41;
end
8'h2b:
begin
    Red = 8'hb7;
    Green = 8'h80;
    Blue = 8'h64;
end
8'h2c:
begin
    Red = 8'he5;
    Green = 8'h97;
    Blue = 8'h72;
end
8'h2d:
begin
    Red = 8'hd9;
    Green = 8'h37;
    Blue = 8'h14;
end
8'h2e:
begin
    Red = 8'h88;
    Green = 8'h29;
    Blue = 8'h14;
end
8'h2f:
begin
    Red = 8'h0e;
    Green = 8'h33;
    Blue = 8'h7d;
end
8'h30:
begin
    Red = 8'h0d;
    Green = 8'h83;
    Blue = 8'h58;
end
8'h31:
begin
    Red = 8'hbb;
    Green = 8'h38;
    Blue = 8'h14;
end
8'h32:
begin
    Red = 8'h0a;
    Green = 8'h72;
    Blue = 8'hde;
end
8'h33:
begin
    Red = 8'h0a;
    Green = 8'h63;
    Blue = 8'h0f;
end
8'h34:
begin
    Red = 8'h0a;
    Green = 8'h93;
    Blue = 8'h1f;
end
8'h35:
begin
    Red = 8'h0b;
    Green = 8'h03;
    Blue = 8'h0f;
end
8'h36:
begin
    Red = 8'h74;
    Green = 8'h29;
    Blue = 8'h16;
end
8'h37:
begin
    Red = 8'hf8;
    Green = 8'h99;
    Blue = 8'h47;
end
8'h38:
begin
    Red = 8'h5b;
    Green = 8'h25;
    Blue = 8'h11;
end
8'h39:
begin
    Red = 8'h07;
    Green = 8'h41;
    Blue = 8'hd0;
end
8'h3a:
begin
    Red = 8'h06;
    Green = 8'he1;
    Blue = 8'hf8;
end
8'h3b:
begin
    Red = 8'h07;
    Green = 8'h51;
    Blue = 8'he5;
end
8'h3c:
begin
    Red = 8'h06;
    Green = 8'hb2;
    Blue = 8'h09;
end
8'h3d:
begin
    Red = 8'h06;
    Green = 8'he2;
    Blue = 8'h3d;
end
8'h3e:
begin
    Red = 8'h06;
    Green = 8'hc1;
    Blue = 8'hda;
end
8'h3f:
begin
    Red = 8'h06;
    Green = 8'hd2;
    Blue = 8'h09;
end
8'h40:
begin
    Red = 8'h0c;
    Green = 8'h03;
    Blue = 8'h4f;
end
8'h41:
begin
    Red = 8'h0a;
    Green = 8'h83;
    Blue = 8'h3e;
end
8'h42:
begin
    Red = 8'h07;
    Green = 8'ha1;
    Blue = 8'hb2;
end
8'h43:
begin
    Red = 8'h06;
    Green = 8'hd1;
    Blue = 8'hb6;
end
8'h44:
begin
    Red = 8'h06;
    Green = 8'ha1;
    Blue = 8'hd9;
end
8'h45:
begin
    Red = 8'h08;
    Green = 8'h72;
    Blue = 8'hbe;
end
8'h46:
begin
    Red = 8'h0c;
    Green = 8'h83;
    Blue = 8'h7e;
end
8'h47:
begin
    Red = 8'ha2;
    Green = 8'h76;
    Blue = 8'h5b;
end
8'h48:
begin
    Red = 8'h90;
    Green = 8'h5d;
    Blue = 8'h27;
end
8'h49:
begin
    Red = 8'h95;
    Green = 8'h43;
    Blue = 8'h2a;
end
8'h4a:
begin
    Red = 8'hd1;
    Green = 8'h89;
    Blue = 8'h3e;
end
8'h4b:
begin
    Red = 8'hc7;
    Green = 8'h70;
    Blue = 8'h2f;
end
8'h4c:
begin
    Red = 8'h64;
    Green = 8'h2d;
    Blue = 8'h2a;
end
8'h4d:
begin
    Red = 8'h79;
    Green = 8'h2c;
    Blue = 8'h35;
end
8'h4e:
begin
    Red = 8'hb9;
    Green = 8'h71;
    Blue = 8'h4f;
end
8'h4f:
begin
    Red = 8'hbd;
    Green = 8'h8b;
    Blue = 8'h38;
end
8'h50:
begin
    Red = 8'h76;
    Green = 8'h40;
    Blue = 8'h31;
end
8'h51:
begin
    Red = 8'h0a;
    Green = 8'h42;
    Blue = 8'h23;
end
8'h52:
begin
    Red = 8'hb4;
    Green = 8'h25;
    Blue = 8'h12;
end
8'h53:
begin
    Red = 8'h08;
    Green = 8'h72;
    Blue = 8'h26;
end
8'h54:
begin
    Red = 8'h07;
    Green = 8'ha1;
    Blue = 8'h59;
end
8'h55:
begin
    Red = 8'h07;
    Green = 8'hd1;
    Blue = 8'h8a;
end
8'h56:
begin
    Red = 8'h08;
    Green = 8'h11;
    Blue = 8'hce;
end
8'h57:
begin
    Red = 8'h08;
    Green = 8'h22;
    Blue = 8'h5e;
end
8'h58:
begin
    Red = 8'hf2;
    Green = 8'h7c;
    Blue = 8'h36;
end
8'h59:
begin
    Red = 8'h0c;
    Green = 8'h03;
    Blue = 8'h2e;
end
8'h5a:
begin
    Red = 8'h03;
    Green = 8'hef;
    Blue = 8'h1a;
end
8'h5b:
begin
    Red = 8'hf4;
    Green = 8'had;
    Blue = 8'h38;
end
8'h5c:
begin
    Red = 8'hfb;
    Green = 8'hdb;
    Blue = 8'h5a;
end
8'h5d:
begin
    Red = 8'h08;
    Green = 8'hf2;
    Blue = 8'haf;
end
8'h5e:
begin
    Red = 8'hd0;
    Green = 8'ha0;
    Blue = 8'h50;
end
8'h5f:
begin
    Red = 8'ha4;
    Green = 8'h55;
    Blue = 8'h5d;
end
8'h60:
begin
    Red = 8'hb4;
    Green = 8'h67;
    Blue = 8'h71;
end
8'h61:
begin
    Red = 8'h0c;
    Green = 8'h73;
    Blue = 8'h9f;
end
8'h62:
begin
    Red = 8'he4;
    Green = 8'h92;
    Blue = 8'h42;
end
8'h63:
begin
    Red = 8'hef;
    Green = 8'h53;
    Blue = 8'h33;
end
8'h64:
begin
    Red = 8'haa;
    Green = 8'h68;
    Blue = 8'h86;
end
8'h65:
begin
    Red = 8'h0b;
    Green = 8'h63;
    Blue = 8'h3c;
end
8'h66:
begin
    Red = 8'h08;
    Green = 8'h11;
    Blue = 8'hfb;
end
8'h67:
begin
    Red = 8'h00;
    Green = 8'h72;
    Blue = 8'hf7;
end
8'h68:
begin
    Red = 8'h8d;
    Green = 8'h2f;
    Blue = 8'h37;
end
8'h69:
begin
    Red = 8'had;
    Green = 8'h57;
    Blue = 8'h29;
end
8'h6a:
begin
    Red = 8'h07;
    Green = 8'h11;
    Blue = 8'he8;
end
8'h6b:
begin
    Red = 8'h0c;
    Green = 8'h52;
    Blue = 8'hfe;
end
8'h6c:
begin
    Red = 8'h92;
    Green = 8'h4b;
    Blue = 8'h48;
end
8'h6d:
begin
    Red = 8'h00;
    Green = 8'h5a;
    Blue = 8'hb0;
end
8'h6e:
begin
    Red = 8'h00;
    Green = 8'h5c;
    Blue = 8'h90;
end
8'h6f:
begin
    Red = 8'h00;
    Green = 8'h59;
    Blue = 8'hc4;
end
8'h70:
begin
    Red = 8'h05;
    Green = 8'h31;
    Blue = 8'h10;
end
8'h71:
begin
    Red = 8'hb9;
    Green = 8'h57;
    Blue = 8'h4d;
end
8'h72:
begin
    Red = 8'h00;
    Green = 8'h33;
    Blue = 8'h9c;
end
8'h73:
begin
    Red = 8'h00;
    Green = 8'h37;
    Blue = 8'hee;
end
8'h74:
begin
    Red = 8'h9e;
    Green = 8'h88;
    Blue = 8'h2e;
end
8'h75:
begin
    Red = 8'h4d;
    Green = 8'h12;
    Blue = 8'h1b;
end
8'h76:
begin
    Red = 8'hbe;
    Green = 8'h7b;
    Blue = 8'h81;
end
8'h77:
begin
    Red = 8'hd0;
    Green = 8'h91;
    Blue = 8'h9c;
end
8'h78:
begin
    Red = 8'h0f;
    Green = 8'h64;
    Blue = 8'h4f;
end
8'h79:
begin
    Red = 8'h0f;
    Green = 8'h22;
    Blue = 8'hb0;
end
8'h7a:
begin
    Red = 8'heb;
    Green = 8'hab;
    Blue = 8'h61;
end
8'h7b:
begin
    Red = 8'hfc;
    Green = 8'h45;
    Blue = 8'h1d;
end
8'h7c:
begin
    Red = 8'h0e;
    Green = 8'he3;
    Blue = 8'h5a;
end
8'h7d:
begin
    Red = 8'h0f;
    Green = 8'h43;
    Blue = 8'h4e;
end
8'h7e:
begin
    Red = 8'h04;
    Green = 8'h11;
    Blue = 8'h9d;
end
8'h7f:
begin
    Red = 8'h04;
    Green = 8'h11;
    Blue = 8'h8a;
end
8'h80:
begin
    Red = 8'h04;
    Green = 8'hf1;
    Blue = 8'hdf;
end
8'h81:
begin
    Red = 8'hdc;
    Green = 8'haa;
    Blue = 8'h77;
end
8'h82:
begin
    Red = 8'h88;
    Green = 8'h62;
    Blue = 8'h4c;
end
8'h83:
begin
    Red = 8'h0d;
    Green = 8'hb3;
    Blue = 8'h2f;
end
8'h84:
begin
    Red = 8'ha8;
    Green = 8'h44;
    Blue = 8'h41;
end
8'h85:
begin
    Red = 8'hd3;
    Green = 8'hb1;
    Blue = 8'h8a;
end
8'h86:
begin
    Red = 8'h0d;
    Green = 8'h43;
    Blue = 8'h3a;
end
8'h87:
begin
    Red = 8'h0d;
    Green = 8'h62;
    Blue = 8'h68;
end
8'h88:
begin
    Red = 8'h0d;
    Green = 8'h12;
    Blue = 8'h76;
end
8'h89:
begin
    Red = 8'ha3;
    Green = 8'h71;
    Blue = 8'h37;
end
8'h8a:
begin
    Red = 8'hdf;
    Green = 8'haf;
    Blue = 8'h9d;
end
8'h8b:
begin
    Red = 8'h0d;
    Green = 8'h23;
    Blue = 8'h4a;
end
8'h8c:
begin
    Red = 8'hc4;
    Green = 8'hab;
    Blue = 8'hac;
end
8'h8d:
begin
    Red = 8'h00;
    Green = 8'h0f;
    Blue = 8'h63;
end
8'h8e:
begin
    Red = 8'h0f;
    Green = 8'h43;
    Blue = 8'hb9;
end
8'h8f:
begin
    Red = 8'h0c;
    Green = 8'hc1;
    Blue = 8'ha0;
end
8'h90:
begin
    Red = 8'h54;
    Green = 8'h47;
    Blue = 8'h57;
end
8'h91:
begin
    Red = 8'he5;
    Green = 8'h94;
    Blue = 8'h8e;
end
8'h92:
begin
    Red = 8'hf9;
    Green = 8'hd8;
    Blue = 8'h9c;
end
8'h93:
begin
    Red = 8'h64;
    Green = 8'h5a;
    Blue = 8'h5d;
end
8'h94:
begin
    Red = 8'h6e;
    Green = 8'ha1;
    Blue = 8'h95;
end
8'h95:
begin
    Red = 8'h1e;
    Green = 8'h15;
    Blue = 8'h14;
end
8'h96:
begin
    Red = 8'h0d;
    Green = 8'h43;
    Blue = 8'h69;
end
8'h97:
begin
    Red = 8'h57;
    Green = 8'h8f;
    Blue = 8'h7c;
end
8'h98:
begin
    Red = 8'h25;
    Green = 8'h53;
    Blue = 8'h6d;
end
8'h99:
begin
    Red = 8'h38;
    Green = 8'h52;
    Blue = 8'h66;
end
8'h9a:
begin
    Red = 8'h8f;
    Green = 8'h75;
    Blue = 8'h6f;
end
8'h9b:
begin
    Red = 8'h4f;
    Green = 8'h68;
    Blue = 8'h74;
end
8'h9c:
begin
    Red = 8'h6a;
    Green = 8'h7c;
    Blue = 8'h75;
end
8'h9d:
begin
    Red = 8'h0c;
    Green = 8'hf2;
    Blue = 8'h8e;
end
8'h9e:
begin
    Red = 8'hf0;
    Green = 8'h7e;
    Blue = 8'h1c;
end
8'h9f:
begin
    Red = 8'h73;
    Green = 8'h51;
    Blue = 8'h47;
end
8'ha0:
begin
    Red = 8'hab;
    Green = 8'h8c;
    Blue = 8'h8f;
end
8'ha1:
begin
    Red = 8'h7b;
    Green = 8'h60;
    Blue = 8'h61;
end
8'ha2:
begin
    Red = 8'hdf;
    Green = 8'h68;
    Blue = 8'h21;
end
8'ha3:
begin
    Red = 8'ha1;
    Green = 8'h22;
    Blue = 8'h11;
end
8'ha4:
begin
    Red = 8'h0a;
    Green = 8'hf1;
    Blue = 8'hc5;
end
8'ha5:
begin
    Red = 8'ha2;
    Green = 8'hc6;
    Blue = 8'hbf;
end
8'ha6:
begin
    Red = 8'he6;
    Green = 8'hd0;
    Blue = 8'hc5;
end
8'ha7:
begin
    Red = 8'hfc;
    Green = 8'hc3;
    Blue = 8'ha5;
end
8'ha8:
begin
    Red = 8'h79;
    Green = 8'h76;
    Blue = 8'h60;
end
8'ha9:
begin
    Red = 8'h7f;
    Green = 8'h89;
    Blue = 8'h77;
end
8'haa:
begin
    Red = 8'h5a;
    Green = 8'h9a;
    Blue = 8'hc1;
end
8'hab:
begin
    Red = 8'ha4;
    Green = 8'ha0;
    Blue = 8'h89;
end
8'hac:
begin
    Red = 8'h78;
    Green = 8'ha2;
    Blue = 8'hbc;
end
8'had:
begin
    Red = 8'ha1;
    Green = 8'hae;
    Blue = 8'hb3;
end
8'hae:
begin
    Red = 8'ha3;
    Green = 8'he1;
    Blue = 8'hd1;
end
8'haf:
begin
    Red = 8'h3a;
    Green = 8'h73;
    Blue = 8'ha0;
end
8'hb0:
begin
    Red = 8'h1f;
    Green = 8'h70;
    Blue = 8'haf;
end
8'hb1:
begin
    Red = 8'hb0;
    Green = 8'hc5;
    Blue = 8'hac;
end
8'hb2:
begin
    Red = 8'h35;
    Green = 8'h41;
    Blue = 8'h4a;
end
8'hb3:
begin
    Red = 8'h82;
    Green = 8'h3d;
    Blue = 8'h1c;
end
8'hb4:
begin
    Red = 8'hc7;
    Green = 8'h24;
    Blue = 8'h17;
end
8'hb5:
begin
    Red = 8'h20;
    Green = 8'h25;
    Blue = 8'h27;
end
8'hb6:
begin
    Red = 8'h00;
    Green = 8'h16;
    Blue = 8'h16;
end
8'hb7:
begin
    Red = 8'he1;
    Green = 8'h92;
    Blue = 8'h22;
end
8'hb8:
begin
    Red = 8'h32;
    Green = 8'h47;
    Blue = 8'h35;
end
8'hb9:
begin
    Red = 8'h0e;
    Green = 8'h59;
    Blue = 8'h23;
end
8'hba:
begin
    Red = 8'h4f;
    Green = 8'h60;
    Blue = 8'h4d;
end
8'hbb:
begin
    Red = 8'h0d;
    Green = 8'hf9;
    Blue = 8'h60;
end
8'hbc:
begin
    Red = 8'h4c;
    Green = 8'h3e;
    Blue = 8'h30;
end
8'hbd:
begin
    Red = 8'h0e;
    Green = 8'he9;
    Blue = 8'h02;
end
8'hbe:
begin
    Red = 8'h0e;
    Green = 8'h08;
    Blue = 8'hb5;
end
8'hbf:
begin
    Red = 8'h6f;
    Green = 8'h8a;
    Blue = 8'h5e;
end
8'hc0:
begin
    Red = 8'h34;
    Green = 8'h6f;
    Blue = 8'h63;
end
8'hc1:
begin
    Red = 8'h08;
    Green = 8'ha3;
    Blue = 8'h6f;
end
8'hc2:
begin
    Red = 8'h48;
    Green = 8'h74;
    Blue = 8'h60;
end
8'hc3:
begin
    Red = 8'h84;
    Green = 8'h77;
    Blue = 8'h4c;
end
8'hc4:
begin
    Red = 8'hf2;
    Green = 8'h67;
    Blue = 8'h19;
end
8'hc5:
begin
    Red = 8'h85;
    Green = 8'ha7;
    Blue = 8'h94;
end
8'hc6:
begin
    Red = 8'h34;
    Green = 8'h59;
    Blue = 8'h4e;
end
8'hc7:
begin
    Red = 8'h36;
    Green = 8'h34;
    Blue = 8'h36;
end
8'hc8:
begin
    Red = 8'h62;
    Green = 8'h68;
    Blue = 8'h46;
end
8'hc9:
begin
    Red = 8'hd3;
    Green = 8'h47;
    Blue = 8'h4c;
end
8'hca:
begin
    Red = 8'h5b;
    Green = 8'h74;
    Blue = 8'h5b;
end
8'hcb:
begin
    Red = 8'hc8;
    Green = 8'hca;
    Blue = 8'h74;
end
8'hcc:
begin
    Red = 8'h76;
    Green = 8'h67;
    Blue = 8'h18;
end
8'hcd:
begin
    Red = 8'h54;
    Green = 8'h8b;
    Blue = 8'h61;
end
8'hce:
begin
    Red = 8'hb2;
    Green = 8'hbb;
    Blue = 8'h86;
end
8'hcf:
begin
    Red = 8'hfc;
    Green = 8'hd7;
    Blue = 8'h85;
end
8'hd0:
begin
    Red = 8'h7b;
    Green = 8'h68;
    Blue = 8'h2c;
end
8'hd1:
begin
    Red = 8'h49;
    Green = 8'h46;
    Blue = 8'h43;
end
8'hd2:
begin
    Red = 8'he6;
    Green = 8'h98;
    Blue = 8'ha1;
end
8'hd3:
begin
    Red = 8'hc5;
    Green = 8'h39;
    Blue = 8'h2b;
end
8'hd4:
begin
    Red = 8'h03;
    Green = 8'h91;
    Blue = 8'h93;
end
8'hd5:
begin
    Red = 8'h84;
    Green = 8'h91;
    Blue = 8'h61;
end
8'hd6:
begin
    Red = 8'h0c;
    Green = 8'h64;
    Blue = 8'h7c;
end
8'hd7:
begin
    Red = 8'hc0;
    Green = 8'h4f;
    Blue = 8'h18;
end
8'hd8:
begin
    Red = 8'hcd;
    Green = 8'h89;
    Blue = 8'h54;
end
8'hd9:
begin
    Red = 8'hcd;
    Green = 8'h7d;
    Blue = 8'h97;
end
8'hda:
begin
    Red = 8'hd8;
    Green = 8'hcc;
    Blue = 8'h3e;
end
8'hdb:
begin
    Red = 8'hc9;
    Green = 8'h9f;
    Blue = 8'h37;
end
8'hdc:
begin
    Red = 8'hd6;
    Green = 8'hb9;
    Blue = 8'h28;
end
8'hdd:
begin
    Red = 8'heb;
    Green = 8'hc1;
    Blue = 8'h3a;
end
8'hde:
begin
    Red = 8'hf6;
    Green = 8'ha1;
    Blue = 8'hb4;
end
8'hdf:
begin
    Red = 8'hd2;
    Green = 8'hb9;
    Blue = 8'h5d;
end
8'he0:
begin
    Red = 8'hf9;
    Green = 8'he0;
    Blue = 8'h40;
end
8'he1:
begin
    Red = 8'ha0;
    Green = 8'h9b;
    Blue = 8'h2b;
end
8'he2:
begin
    Red = 8'h01;
    Green = 8'hc1;
    Blue = 8'h6f;
end
8'he3:
begin
    Red = 8'h00;
    Green = 8'hd1;
    Blue = 8'h1e;
end
8'he4:
begin
    Red = 8'hb5;
    Green = 8'h99;
    Blue = 8'h6e;
end
8'he5:
begin
    Red = 8'hba;
    Green = 8'h94;
    Blue = 8'h5a;
end
8'he6:
begin
    Red = 8'h91;
    Green = 8'h61;
    Blue = 8'h66;
end

                default: ;
        endcase*/
			end
	 end
    
endmodule
