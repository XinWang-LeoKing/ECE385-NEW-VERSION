//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------

module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				 output logic [7:0]  LEDG
                    );
    
    logic Reset_h, Reset_chara, Clk, test_1, test_2;
    logic [7:0] keycode,keycode0,keycode1,keycode2,keycode3,keycode4;
	 logic [9:0] DrawX, DrawY;
    //logic is_ball;
	 logic [7:0] led;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        //Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  Reset_chara <= ~(KEY[1]);
		  //LEDG <= led
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
									  .keycode0_export(keycode0),
									  .keycode1_export(keycode1),
									  .keycode2_export(keycode2),  
									  .keycode3_export(keycode3),
									  .keycode4_export(keycode4),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance( .Clk(Clk),
                                            .Reset(Reset_h),
														  .VGA_CLK(VGA_CLK),
														  
                                            .VGA_HS(VGA_HS), // output
                                            .VGA_VS(VGA_VS), // output
                                            
                                            .VGA_BLANK_N(VGA_BLANK_N), // output
                                            .VGA_SYNC_N(VGA_SYNC_N), // output
                                            .DrawX(DrawX), // output
                                            .DrawY(DrawY) // output
	 );
	
    
	 logic [11:0] spriteColor; 
	 logic [16:0] read_address;	
	 
	 logic [7:0] spriteColor_tracer_1, spriteColor_tracer_2;
	 logic [2:0] figure_1, figure_2;
	 //logic [11:0] read_address_tracer_1, read_address_tracer_2;
	 
	 logic is_chara_1, is_chara_2;
	 
	 assign read_address = DrawX[9:1] + DrawY[9:1]*320;
	 
	 /*always_comb begin
			read_address_tracer_1 = (DrawX-chara_left_1) + (DrawY-chara_top_1)*31;
			read_address_tracer_2 = (DrawX-chara_left_2) + (DrawY-chara_top_2)*31;
			if (chara_direction_1)
					read_address_tracer_1 = (DrawX-chara_left_1) + (DrawY-chara_top_1)*31 + 12'd1302;
			if (chara_direction_2)
					read_address_tracer_2 = (DrawX-chara_left_2) + (DrawY-chara_top_2)*31 + 12'd1302;
	 end*/
	 
	 /*frameROM rom_instance(.read_address(read_address),
								  .Clk(Clk),
								  
								  .spriteColor(spriteColor) // output
	);*/
	
	
	tracerROM tracer_rom_instance_1(.chara_direction(chara_direction_1), 
											  .DrawX(DrawX),
											  .DrawY(DrawY), 
											  .chara_left(chara_left_1), 
											  .chara_top(chara_top_1),
											  .is_chara(is_chara_1),
											  .figure(figure_1),
											  .Clk(Clk),
											  .count_k(count_k_1),
											  .count_l(count_l_1),
											  .count_s(count_s_1),
											  
											  .spriteColor(spriteColor_tracer_1) 
	);
	
	tracerROM tracer_rom_instance_2(.chara_direction(chara_direction_2), 
											  .DrawX(DrawX),
											  .DrawY(DrawY), 
											  .chara_left(chara_left_2), 
											  .chara_top(chara_top_2),
											  .is_chara(is_chara_2),
											  .figure(figure_2),
											  .Clk(Clk),
											  .count_k(count_k_2),
											  .count_l(count_l_2),
											  .count_s(count_s_2),
								  
								     .spriteColor(spriteColor_tracer_2) 
	);
	
	
	logic[9:0] chara_top_1, chara_bot_1, chara_left_1, chara_right_1, chara_top_2, chara_bot_2, chara_left_2, chara_right_2;
	logic on_ground_1, on_build_1, on_ground_2, on_build_2;
	logic moving_left_1,moving_right_1, moving_up_1, moving_down_1, moving_left_2,moving_right_2, moving_up_2, moving_down_2;
	logic chara_direction_1, chara_direction_2;
	logic press_a, press_s, press_d, press_w, press_j, press_k, press_l, press_i;
	logic press_up, press_down, press_left, press_right, press_1, press_2, press_3, press_5;
	logic [9:0] speed_y_1, bias_1, speed_y_2, bias_2, count_k_1, count_k_2, count_l_1, count_l_2, count_s_1, count_s_2;
	
	chara chara_1_instance (         .Clk(Clk),                 
												.Reset(Reset_chara),               
												.frame_clk(VGA_VS),           
												.press_w(press_w), 
												.press_a(press_a), 
												.press_s(press_s), 
												.press_d(press_d),
												.press_k(press_k), 
												.press_l(press_l), 
												.press_i(press_i),
												.on_ground(on_ground_1), 
												.on_build(on_build_1),
												.width(6'd39),
												.height(6'd43), // this means 40*44
												.left_initial(10'd145),
												.bot_initial(10'd439),
												.bias(bias_1),
												.chara_id(2'b00),
												.is_ready(is_ready),
									
												
												
												.chara_direction(chara_direction_1),  
												.moving_left(moving_left_1), 
												.moving_right(moving_right_1), 
												.moving_up(moving_up_1), 
												.moving_down(moving_down_1),  
												.top(chara_top_1), 
												.bot(chara_bot_1), 
												.left(chara_left_1), 
												.right(chara_right_1),
												.figure(figure_1),
												.count_k(count_k_1),
												.count_l(count_l_1),
												.count_s(count_s_1),
												.reset_energy(reset_energy_1),
												.speed_y(speed_y_1),
												.test(test_1)
   );
	
	chara chara_2_instance (         .Clk(Clk),                 
												.Reset(Reset_chara),               
												.frame_clk(VGA_VS),           
												.press_w(press_up), 
												.press_a(press_left), 
												.press_s(press_down), 
												.press_d(press_right),
												.press_k(press_2),
												.press_l(press_3),
												.press_i(press_5),
												.on_ground(on_ground_2), 
												.on_build(on_build_2),
												.width(6'd39),
												.height(6'd43), // this means 40*44
												.left_initial(10'd464),
												.bot_initial(10'd439),
												.bias(bias_2),
												.chara_id(2'b01),
												.is_ready(is_ready),
												
												
												.chara_direction(chara_direction_2),  
												.moving_left(moving_left_2), 
												.moving_right(moving_right_2), 
												.moving_up(moving_up_2), 
												.moving_down(moving_down_2),  
												.top(chara_top_2), 
												.bot(chara_bot_2), 
												.left(chara_left_2), 
												.right(chara_right_2),
												.figure(figure_2),
												.count_k(count_k_2),
												.count_l(count_l_2),
												.count_s(count_s_2),
												.reset_energy(reset_energy_2),
												.speed_y(speed_y_2),
												.test(test_2)
   );
	

	logic [9:0] show_x, show_y;
	logic [1:0] bullet_state[20];
	logic [23:0] bullet_color, dart_color_center, dart_color_body;
	logic [19:0] hit;
	logic is_healthbar;
	logic is_energybar;
	logic is_ready;
   logic reset_energy_1;
	logic reset_energy_2;
	logic gameover;
	
	always_comb begin
		show_y = chara_top_1 + 4'd10;
		if (~chara_direction_1)
			show_x = chara_left_1 - 1'b1;
		else
			show_x = chara_right_1 + 1'b1;	
	end
	
	energybar energybar_1( 
							 .frame_clk(VGA_VS),
							 .hit(hit),          	  
							 .bullet_state(bullet_state),
							 .DrawX(DrawX), 
							 .DrawY(DrawY),
							 .reset(Reset_chara),
							 .damageUnit(10'd6),
							 .full_energy(10'd150),
							 .reset_energy(reset_energy_1),
							 
							 .is_energybar(is_energybar),
							 .is_ready(is_ready)
	
								);
	
	healthbar healthbar_2(			 
							 .frame_clk(VGA_VS),
							 .hit(hit),          	  
							 .bullet_state(bullet_state),
							 .DrawX(DrawX), 
							 .DrawY(DrawY),
							 .reset(Reset_chara),
							 .damageUnit(10'd6),
							 .len_init(10'd150),
							 
							 .is_healthbar(is_healthbar),
							 .gameover(gameover)
							 );
							 
							 
	bullet_controller bullet_controller_1 (//.Clk(Clk),
                         //.Reset(Reset_chara),
                         .frame_clk(VGA_VS),
								 //.X_Step(10'd6),
								 //.fire_range(10'd160),
								 .chara_direction(chara_direction_1),
								 .show_x(show_x), .show_y(show_y),
								 .chara_left(chara_left_2), .chara_right(chara_right_2), .chara_top(chara_top_2), .chara_bot(chara_bot_2), // another character
								 .press_j(press_j),
								 //.fire_period(10'b11),
								 //.reload_period(10'd69),
								 .DrawX(DrawX),
								 .DrawY(DrawY),
								 .chara_id(2'b01),
					 
								 .bullet_color(bullet_color),
								 .bullet_state(bullet_state),
								 .dart_color_center(dart_color_center), 
								 .dart_color_body(dart_color_body),
								 .hit(hit)
								 );
								 

	terrChecker terrChecker_chara_1(   .left(chara_left_1), 
													.right(chara_right_1), 
													.bot(chara_bot_1), 
													.speed_y(speed_y_1),
						   
													.on_build(on_build_1),            
													.on_ground(on_ground_1),
													.bias(bias_1)
	);	
	
	terrChecker terrChecker_chara_2(   .left(chara_left_2), 
													.right(chara_right_2), 
													.bot(chara_bot_2), 
													.speed_y(speed_y_2),
						   
													.on_build(on_build_2),            
													.on_ground(on_ground_2),
													.bias(bias_2)
	);	

	
	is_chara is_chara_1_instance  (
										  .left(chara_left_1),
										  .right(chara_right_1),
										  .top(chara_top_1),
										  .bot(chara_bot_1),
										  .DrawX(DrawX), 
										  .DrawY(DrawY),
										
										  .is_chara(is_chara_1) 
	);
	
	is_chara is_chara_2_instance  (
										  .left(chara_left_2),
										  .right(chara_right_2),
										  .top(chara_top_2),
										  .bot(chara_bot_2),
										  .DrawX(DrawX), 
										  .DrawY(DrawY),
										
										  .is_chara(is_chara_2) 
	);
	
	 color_mapper color_instance(.DrawX(DrawX),
                                .DrawY(DrawY),
										  .spriteColor(spriteColor),
										  .spriteColor_tracer_1(spriteColor_tracer_1),
										  .spriteColor_tracer_2(spriteColor_tracer_2),
										  .is_healthbar(is_healthbar),
										  .is_energybar(is_energybar),
										  .bullet_color(bullet_color),
										  .is_tracer_1(is_chara_1),
										  .is_tracer_2(is_chara_2),
										  .chara_id_1(0),
										  .chara_id_2(0),
										  .count_k_1(count_k_1),
										  .count_k_2(count_k_2),
										  .count_l_1(count_l_1),
										  .count_l_2(count_l_2),
										  
                                .VGA_R(VGA_R), 
                                .VGA_G(VGA_G), 
                                .VGA_B(VGA_B) 
	 );
				  
	keycode_reader keycode_reader_instance(.keycode({keycode, keycode0, keycode1, keycode2, keycode3, keycode4}),

														.press_w(press_w),
														.press_a(press_a), 
														.press_d(press_d),
													   .press_s(press_s),
														.press_j(press_j),
														.press_k(press_k), 
														.press_l(press_l),
														.press_i(press_i),
														.press_up(press_up),
														.press_left(press_left), 
														.press_right(press_right),
													   .press_down(press_down),
														.press_1(press_1),
														.press_2(press_2),
														.press_3(press_3),
														.press_5(press_5)
	);
    
    // Display keycode on hex display
	 
    HexDriver hex_inst_0 ({4{test_1}}, HEX0);
    HexDriver hex_inst_1 ({4{test_2}}, HEX1);
	 HexDriver hex_inst_2 ({4{press_w}}, HEX2);
    HexDriver hex_inst_3 ({4{press_j}}, HEX3);
	 HexDriver hex_inst_4 ({4{hit}}, HEX4);
    //HexDriver hex_inst_5 ({4{bullet_state}}, HEX5); 
	 HexDriver hex_inst_6 (keycode[3:0], HEX6);
    HexDriver hex_inst_7 (keycode[7:4], HEX7);
	 
//	 HexDriver hex_inst_8 (keycode3[3:0], HEX2);
//    HexDriver hex_inst_9 (keycode3[7:4], HEX3);
//	 HexDriver hex_inst_10 (keycode4[3:0], HEX4);
//    HexDriver hex_inst_11 (keycode4[7:4], HEX5);
    
	 assign led = keycode3;

endmodule
