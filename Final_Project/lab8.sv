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
	 logic [1:0] chara_id_1, chara_id_2;
    logic [7:0] keycode,keycode0,keycode1,keycode2,keycode3,keycode4;
	 logic [9:0] DrawX, DrawY;
    //logic is_ball;
	 logic [7:0] led;
	 assign chara_id_1 = 2'b01;
	 assign chara_id_2 = 2'b00;
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        //Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  Reset_chara <= ~(KEY[0]);
		  /*if (~KEY[1]) begin
			 chara_id_1 = 2'b00;
			 chara_id_2 = 2'b01;
		  end
		  if (~KEY[2]) begin
			 chara_id_1 = 2'b01;
		  end
		  if (~KEY[3]) begin
			 chara_id_2 = 2'b00;
		  end*/
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
	
    
	 logic [12:0] spriteColor; 
	 logic [16:0] read_address;	
	 
	 logic [7:0] spriteColor_tracer_1, spriteColor_tracer_2;
	 logic [2:0] figure_1, figure_2;
	 logic [23:0] bomb_color_1, bomb_color_2;
	 //logic [11:0] read_address_tracer_1, read_address_tracer_2;
	 
	 logic is_chara_1, is_chara_2;
	 logic [1:0] blink_charge_1, blink_charge_2;
	 
	 assign read_address = DrawX/2 + DrawY*160;
	 /*
		 frameROM rom_instance(.read_address(read_address),
								  .Clk(Clk),
								  
								  .spriteColor(spriteColor) // output
	); */
	
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
											  .chara_id(chara_id_1),
											  
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
											  .chara_id(chara_id_2),
								  
								     .spriteColor(spriteColor_tracer_2) 
	);
	
	logic [7:0] sprigeColor_genji_1, sprigeColor_genji_2;
	
	genjiROM genji_rom_instance_1(.chara_direction(chara_direction_1), 
											  .DrawX(DrawX),
											  .DrawY(DrawY), 
											  .chara_left(chara_left_1), 
											  .chara_top(chara_top_1),
											  .is_chara(is_chara_1),
											  .figure(figure_1),
											  .Clk(Clk),
											  .count_dragon(count_dragon_1),
											  .dragon(dragon_1),
											  .deflect(deflect_1),
											  .chara_id(chara_id_1),
											  .swift(swift_1),
								  
								     .spriteColor(spriteColor_genji_1) 
	);
	
	genjiROM genji_rom_instance_2(.chara_direction(chara_direction_2), 
											  .DrawX(DrawX),
											  .DrawY(DrawY), 
											  .chara_left(chara_left_2), 
											  .chara_top(chara_top_2),
											  .is_chara(is_chara_2),
											  .figure(figure_2),
											  .Clk(Clk),
											  .count_dragon(count_dragon_2),
											  .dragon(dragon_2),
											  .deflect(deflect_2),
											  .chara_id(chara_id_2),
											  .swift(swift_2),
								  
								     .spriteColor(spriteColor_genji_2) 
	);
	
	logic [7:0] spriteColor_skill;
	skillROM skillROM_instance (.DrawX(DrawX),
										 .DrawY(DrawY),
										 .chara_id_1(chara_id_1),
										 .chara_id_2(chara_id_2),
										 .Clk(Clk),
										 .count_k_1(count_k_1),
										 .count_k_2(count_k_2),
										 .count_l_1(count_l_1),
										 .count_l_2(count_l_2),
										 .blink_charge_1(blink_charge_1),
										 .blink_charge_2(blink_charge_2),
										 
										 .spriteColor(spriteColor_skill)
										 );
										 
	bomb_warningROM warningrom_instance_1(.DrawX(DrawX),
						 .DrawY(DrawY),
						 .chara_id(chara_id_1),
						 .Clk(Clk),
						 .bomb_left(bomb_left_1),
						 .bomb_top(bomb_top_1),
						 .count_bomb(bomb_count_1),
						 
						 .spriteColor(bomb_warning_color_1)
						 );
						 
	bomb_warningROM warningrom_instance_2(.DrawX(DrawX),
						 .DrawY(DrawY),
						 .chara_id(chara_id_2),
						 .Clk(Clk),
						 .bomb_left(bomb_left_2),
						 .bomb_top(bomb_top_2),
						 .count_bomb(bomb_count_2),
						 
						 .spriteColor(bomb_warning_color_2)
						 );
										
	
	logic [23:0] bullet_show_color_1, bullet_show_color_2;
	
	bullet_show bullet_show_1 (.frame_clk(VGA_VS),
										.bullet_state(bullet_state_1),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.chara_id(chara_id_1),
										.pl(0),
										
										.bullet_show_color(bullet_show_color_1)
										);
	
	bullet_show bullet_show_2 (.frame_clk(VGA_VS),
										.bullet_state(bullet_state_2),
										.DrawX(DrawX),
										.DrawY(DrawY),
										.chara_id(chara_id_2),
										.pl(1'b1),
										
										.bullet_show_color(bullet_show_color_2)
										);
	
	
	logic[9:0] chara_top_1, chara_bot_1, chara_left_1, chara_right_1, chara_top_2, chara_bot_2, chara_left_2, chara_right_2;
	logic on_ground_1, on_build_1, on_ground_2, on_build_2, DRAGON_hit_1, DRAGON_hit_2;
	logic moving_left_1,moving_right_1, moving_up_1, moving_down_1, moving_left_2,moving_right_2, moving_up_2, moving_down_2;
	logic chara_direction_1, chara_direction_2;
	logic [9:0] count_u_1, count_u_2, count_dragon_1, count_dragon_2;
	logic press_a, press_s, press_d, press_w, press_j, press_k, press_l, press_u, dragon_1, dragon_2;
	logic press_up, press_down, press_left, press_right, press_1, press_2, press_3, press_4;
	logic [9:0] speed_y_1, bias_1, speed_y_2, bias_2, count_k_1, count_k_2, count_l_1, count_l_2, count_s_1, count_s_2;
	logic [9:0] count_recall_1, count_recall_2;
	logic deflect_1, deflect_2, deflect_left_2, deflect_left_1, deflect_right_1, deflect_right_2;
	logic swift_1, swift_2;
	
	chara chara_1_instance (         .Clk(Clk),                 
												.Reset(Reset_chara),               
												.frame_clk(VGA_VS),           
												.press_w(press_w), 
												.press_a(press_a), 
												.press_s(press_s), 
												.press_d(press_d),
												.press_k(press_k), 
												.press_l(press_l), 
												.press_u(press_u),
												.press_j(press_j),
												.on_ground(on_ground_1), 
												.on_build(on_build_1),
												//.width(6'd39),
												//.height(6'd43), // this means 40*44
												.left_initial(10'd145),
												.bot_initial(10'd439),
												.bias(bias_1),
												.chara_id(chara_id_1),
												.is_ready(is_ready_1),
												.opponent_left(chara_left_2),
												.opponent_right(chara_right_2),
												.opponent_top(chara_top_2),
												.opponent_bot(chara_bot_2),
												.pl(0),
												
												
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
												.count_u(count_u_1),
												.count_dragon(count_dragon_1),
												.count_recall(count_recall_1),
												.reset_energy(reset_energy_1),
												.speed_y(speed_y_1),
												.dragon(dragon_1),
												.DRAGON_hit(DRAGON_hit_1),
												.SWIFT_hit(swift_hit_1),
												.recall(recall_1),
												.deflect(deflect_1),
												.deflect_left(deflect_left_1),
												.deflect_right(deflect_right_1),
												.blink_charge(blink_charge_1),
												.swift(swift_1),
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
												.press_u(press_4),
												.press_j(press_1),
												.on_ground(on_ground_2), 
												.on_build(on_build_2),
												//.width(6'd39),
												//.height(6'd43), // this means 40*44
												.left_initial(10'd464),
												.bot_initial(10'd439),
												.bias(bias_2),
												.chara_id(chara_id_2),
												.is_ready(is_ready_2),
												.opponent_left(chara_left_1),
												.opponent_right(chara_right_1),
												.opponent_top(chara_top_1),
												.opponent_bot(chara_bot_1),
												.pl(1'b1),
												
												
												
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
												.count_u(count_u_2),
												.count_dragon(count_dragon_2),
												.count_recall(count_recall_2),
												.reset_energy(reset_energy_2),
												.speed_y(speed_y_2),
												.dragon(dragon_2),
												.DRAGON_hit(DRAGON_hit_2),
												.SWIFT_hit(swift_hit_2),
												.recall(recall_2),
												.deflect(deflect_2),
												.deflect_left(deflect_left_2),
												.deflect_right(deflect_right_2),
												.blink_charge(blink_charge_2),
												.swift(swift_2),
												.test(test_2)
   );
	

	logic [9:0] show_x_1, show_y_1, show_x_2, show_y_2;
	logic [1:0] bullet_state_1[30];
	logic [1:0] bullet_state_2[30];
	logic [23:0] bullet_color_1, bullet_color_2;
	logic [29:0] hit_1, hit_2;
	logic is_healthbar_1, is_healthbar_2;
	logic is_energybar_1, is_energybar_2;
	logic is_ready_1, is_ready_2;
   logic reset_energy_1;
	logic reset_energy_2;
	logic gameover_1, gameover_2;
	logic recall_1, recall_2;
	logic deflect_hit_1, deflect_hit_2;
	logic [9:0] damageUnit_1, damageUnit_2;
	
	always_comb begin
		if (chara_id_1==0)
			show_y_1 = chara_top_1 + 4'd10;
		else 
			show_y_1 = chara_top_1 + 10'd24;
		if (~chara_direction_1)
			show_x_1 = chara_left_1 - 1'b1;
		else
			show_x_1 = chara_right_1 + 1'b1;
		
		if (chara_id_2==0)
			show_y_2 = chara_top_2 + 4'd10;
		else 
			show_y_2 = chara_top_2 + 10'd24;
		if (~chara_direction_2)
			show_x_2 = chara_left_2 - 1'b1;
		else
			show_x_2 = chara_right_2 + 1'b1;	
		if (chara_id_1==0)
			damageUnit_1 = 10'd6;
		else
			damageUnit_1 = 10'd14;
		if (chara_id_2==0)
			damageUnit_2 = 10'd6;
		else
			damageUnit_2 = 10'd14;
	end
	
	energybar energybar_1( 
							 .frame_clk(VGA_VS),
							 .hit(hit_2),          	  
							 .bullet_state(bullet_state_2),
							 .DrawX(DrawX), 
							 .DrawY(DrawY),
							 .reset(Reset_chara),
							 .damageUnit(damageUnit_2),
							 .full_energy(10'd150),
							 .reset_energy(press_u),
							 .pl(1'b0),
							 
							 .is_energybar(is_energybar_1),
							 .is_ready(is_ready_1)
	
								);
	
	energybar energybar_2( 
							 .frame_clk(VGA_VS),
							 .hit(hit_1),          	  
							 .bullet_state(bullet_state_1),
							 .DrawX(DrawX), 
							 .DrawY(DrawY),
							 .reset(Reset_chara),
							 .damageUnit(damageUnit_1),
							 .full_energy(10'd150),
							 .reset_energy(press_4),
							 .pl(1'b1),
							 
							 .is_energybar(is_energybar_2),
							 .is_ready(is_ready_2)
	
								);
	
	healthbar healthbar_1(			 
							 .frame_clk(VGA_VS),
							 .hit(hit_2),          	  
							 .bullet_state(bullet_state_2),
							 .deflect_hit(hit_4),
							 .deflect_bullet_state(bullet_state_4),
							 .DrawX(DrawX), 
							 .DrawY(DrawY),
							 .reset(Reset_chara),
							 .damageUnit_1(damageUnit_2),
							 .damageUnit_2(damageUnit_1),
							 //.len_init(10'd150),
							 .chara_id(chara_id_1),
							 .pl(0),
							 .bomb_hit(bomb_hit_2),
							 .boom_hit(boom_hit_2),
							 .dragon_hit(DRAGON_hit_2),
							 .swift_hit(swift_hit_2),
							 .count_recall(count_recall_1),
							 .recall(recall_1),
							 .deflect(deflect_1),
							 .KO(gameover_1||gameover2),
							 
							 .is_healthbar(is_healthbar_1),
							 .gameover(gameover_1)
							 );
	
	healthbar healthbar_2(			 
							 .frame_clk(VGA_VS),
							 .hit(hit_1),          	  
							 .bullet_state(bullet_state_1),
							 .deflect_hit(hit_3),
							 .deflect_bullet_state(bullet_state_3),
							 .DrawX(DrawX), 
							 .DrawY(DrawY),
							 .reset(Reset_chara),
							 .damageUnit_1(damageUnit_1),
							 .damageUnit_2(damageUnit_2),
							 //.len_init(10'd150),
							 .chara_id(chara_id_2),
							 .pl(1'b1),
							 .bomb_hit(bomb_hit_1),
							 .boom_hit(boom_hit_1),
							 .dragon_hit(DRAGON_hit_1),
							 .swift_hit(swift_hit_1),
							 .count_recall(count_recall_2),
							 .recall(recall_2),
							 .deflect(deflect_2),
							 .KO(gameover_1||gameover2),
							 
							 .is_healthbar(is_healthbar_2),
							 .gameover(gameover_2)
							 );
							 
	logic test1, test2, test3, test4;						 
	bullet_controller bullet_controller_1 (.Reset(Reset_chara),
                         .frame_clk(VGA_VS),
								 .chara_direction(chara_direction_1),
								 .show_x(show_x_1), .show_y(show_y_1),
								 .chara_left(chara_left_2), .chara_right(chara_right_2), .chara_top(chara_top_2), .chara_bot(chara_bot_2), // another character
								 .press_j(press_j),
								 .DrawX(DrawX),
								 .DrawY(DrawY),
								 .chara_id(chara_id_1),
								 .dragon(dragon_1),
								 .deflect(deflect_1),
								 .deflect_left(deflect_left_2),
								 .deflect_right(deflect_right_2),
								 .deflect_color(0),
					 
								 .bullet_color(bullet_color_1),
								 .bullet_state(bullet_state_1),
								 .hit(hit_1),
								 .DEFLECT_HIT(deflect_hit_2),
								 .test(test1)
								 );
								 
	bullet_controller bullet_controller_2 (.Reset(Reset_chara),
                         .frame_clk(VGA_VS),
								 .chara_direction(chara_direction_2),
								 .show_x(show_x_2), .show_y(show_y_2),
								 .chara_left(chara_left_1), .chara_right(chara_right_1), .chara_top(chara_top_1), .chara_bot(chara_bot_1), // another character
								 .press_j(press_1),
								 .DrawX(DrawX),
								 .DrawY(DrawY),
								 .chara_id(chara_id_2),
								 .dragon(dragon_2),
								 .deflect(deflect_2),
								 .deflect_left(deflect_left_1),
								 .deflect_right(deflect_right_1),
								 .deflect_color(0),
					 
								 .bullet_color(bullet_color_2),
								 .bullet_state(bullet_state_2),
								 .hit(hit_2),
								 .DEFLECT_HIT(deflect_hit_1),
								 .test(test2)
								 );
								 
	logic [23:0] bullet_color_3, bullet_color_4;
	logic [1:0] bullet_state_3 [30];
	logic [1:0] bullet_state_4 [30];
	logic [29:0] hit_3, hit_4;
	logic deflect_hit_3, deflect_hit_4;
	bullet_controller deflect_controller_1 (.Reset(Reset_chara),
                         .frame_clk(VGA_VS),
								 .chara_direction(chara_direction_1),
								 .show_x(show_x_1), .show_y(show_y_1),
								 .chara_left(chara_left_2), .chara_right(chara_right_2), .chara_top(chara_top_2), .chara_bot(chara_bot_2), // another character
								 .press_j(deflect_hit_1||deflect_hit_4),
								 //.press_j(press_j),
								 .DrawX(DrawX),
								 .DrawY(DrawY),
								 .chara_id(chara_id_2),
								 .dragon(0),
								 .deflect(0),
								 .deflect_left(deflect_left_2),
								 .deflect_right(deflect_right_2),
								 .deflect_color(1'b1),
					 
								 .bullet_color(bullet_color_3),
								 .bullet_state(bullet_state_3),
								 .hit(hit_3),
								 .DEFLECT_HIT(deflect_hit_3),
								 .test(test3)
								 );
	
	bullet_controller deflect_controller_2 (.Reset(Reset_chara),
                         .frame_clk(VGA_VS),
								 .chara_direction(chara_direction_2),
								 .show_x(show_x_2), .show_y(show_y_2),
								 .chara_left(chara_left_1), .chara_right(chara_right_1), .chara_top(chara_top_1), .chara_bot(chara_bot_1), // another character
								 .press_j(deflect_hit_2||deflect_hit_3),
								 //.press_j(press_1),
								 .DrawX(DrawX),
								 .DrawY(DrawY),
								 .chara_id(chara_id_1),
								 .dragon(0),
								 .deflect(0),
								 .deflect_left(deflect_left_1),
								 .deflect_right(deflect_right_1),
								 .deflect_color(1'b1),
					 
								 .bullet_color(bullet_color_4),
								 .bullet_state(bullet_state_4),
								 .hit(hit_4),
								 .DEFLECT_HIT(deflect_hit_4),
								 .test(test4)
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

	logic [9:0] bomb_left_1, bomb_left_2, bomb_right_1, bomb_right_2, bomb_bot_1, bomb_bot_2, bomb_speed_y_1, bomb_speed_y_2, bomb_top_1, bomb_top_2;
	logic bomb_on_ground_1, bomb_on_ground_2, bomb_on_build_1, bomb_on_build_2;
	logic [9:0] bomb_bias_1, bomb_bias_2;
	terrChecker terrChecker_bomb_1(   .left(bomb_left_1), 
													.right(bomb_right_1), 
													.bot(bomb_bot_1), 
													.speed_y(bomb_speed_y_1),
						   
													.on_build(bomb_on_build_1),            
													.on_ground(bomb_on_ground_1),
													.bias(bomb_bias_1)
	);
	
	terrChecker terrChecker_bomb_2(   .left(bomb_left_2), 
													.right(bomb_right_2), 
													.bot(bomb_bot_2), 
													.speed_y(bomb_speed_y_2),
						   
													.on_build(bomb_on_build_2),            
													.on_ground(bomb_on_ground_2),
													.bias(bomb_bias_2)
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
	
	logic bomb_hit_1, bomb_hit_2, boom_hit_1, boom_hit_2, swift_hit_1, swift_hit_2;
	
	pulse_bomb bomb_1_instance (.Reset(Reset_chara),
										 .frame_clk(VGA_VS),
										 .on_ground(bomb_on_ground_1),
										 .on_build(bomb_on_build_1),
										 .chara_id(chara_id_1),
										 .full_energy(is_ready_1),
										 .press_u(press_u),
										 .bias(bomb_bias_1),
										 .chara_direction(chara_direction_1),
										 .chara_left(chara_left_1),
										 .chara_right(chara_right_1),
										 .chara_top(chara_top_1),
										 .DrawX(DrawX),
										 .DrawY(DrawY),
										 .opponent_left(chara_left_2),
										 .opponent_right(chara_right_2),
										 .opponent_bot(chara_bot_2),
										 .opponent_top(chara_top_2),
										 .deflect_left(deflect_left_2),
										 .deflect_right(deflect_right_2),
										 
										 .bomb_color(bomb_color_1),
										 .left(bomb_left_1),
										 .right(bomb_right_1),
										 .top(bomb_top_1),
										 .bot(bomb_bot_1),
										 .speed_y(bomb_speed_y_1),
										 .BOMB_hit(bomb_hit_1),
										 .BOOM_hit(boom_hit_1),
										 .count_boom(bomb_count_1)
	);
	
	pulse_bomb bomb_2_instance (.Reset(Reset_chara),
										 .frame_clk(VGA_VS),
										 .on_ground(bomb_on_ground_2),
										 .on_build(bomb_on_build_2),
										 .chara_id(chara_id_2),
										 .full_energy(is_ready_2),
										 .press_u(press_4),
										 .bias(bomb_bias_2),
										 .chara_direction(chara_direction_2),
										 .chara_left(chara_left_2),
										 .chara_right(chara_right_2),
										 .chara_top(chara_top_2),
										 .DrawX(DrawX),
										 .DrawY(DrawY),
										 .opponent_left(chara_left_1),
										 .opponent_right(chara_right_1),
										 .opponent_bot(chara_bot_1),
										 .opponent_top(chara_top_1),
										 .deflect_left(deflect_left_1),
										 .deflect_right(deflect_right_1),
										 
										 .bomb_color(bomb_color_2),
										 .left(bomb_left_2),
										 .right(bomb_right_2),
										 .top(bomb_top_2),
										 .bot(bomb_bot_2),
										 .speed_y(bomb_speed_y_2),
										 .BOMB_hit(bomb_hit_2),
										 .BOOM_hit(boom_hit_2),
										 .count_boom(bomb_count_2)
	);
	
	logic bomb_warning_color_1, bomb_warning_color_2;
	logic [9:0] bomb_count_1, bomb_count_2;
	logic [7:0] spriteColor_genji_1, spriteColor_genji_2;
	
	 color_mapper color_instance(.DrawX(DrawX),
                                .DrawY(DrawY),
										  .spriteColor(spriteColor),
										  .spriteColor_tracer_1(spriteColor_tracer_1),
										  .spriteColor_tracer_2(spriteColor_tracer_2),
										  .spriteColor_genji_1(spriteColor_genji_1),
										  .spriteColor_genji_2(spriteColor_genji_2),
										  .is_healthbar_1(is_healthbar_1),
										  .is_healthbar_2(is_healthbar_2),
										  .is_energybar_1(is_energybar_1),
										  .is_energybar_2(is_energybar_2),
										  .bullet_color_1(bullet_color_1),
										  .bullet_color_2(bullet_color_2),
										  .bullet_color_3(bullet_color_3),
										  .bullet_color_4(bullet_color_4),
										  .is_tracer_1(is_chara_1),
										  .is_tracer_2(is_chara_2),
										  .chara_id_1(chara_id_1),
										  .chara_id_2(chara_id_2),
										  .count_k_1(count_k_1),
										  .count_k_2(count_k_2),
										  .count_l_1(count_l_1),
										  .count_l_2(count_l_2),
										  .bomb_color_1(bomb_color_1),
										  .bomb_color_2(bomb_color_2),
										  .bullet_show_color_1(bullet_show_color_1),
										  .bullet_show_color_2(bullet_show_color_2),
										  .spriteColor_skill(spriteColor_skill),
										  .bomb_warning_color_1(bomb_warning_color_1),
										  .bomb_warning_color_2(bomb_warning_color_2),
										  .bomb_count_1(bomb_count_1),
										  .bomb_count_2(bomb_count_2),
										  
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
														.press_u(press_u),
														.press_up(press_up),
														.press_left(press_left), 
														.press_right(press_right),
													   .press_down(press_down),
														.press_1(press_1),
														.press_2(press_2),
														.press_3(press_3),
														.press_4(press_4)
	);
    
    // Display keycode on hex display
	 
    HexDriver hex_inst_0 ({4{test_1}}, HEX0);
    HexDriver hex_inst_1 ({4{test_2}}, HEX1);
	 HexDriver hex_inst_2 ({4{test1}}, HEX2);
    HexDriver hex_inst_3 ({4{test2}}, HEX3);
	 HexDriver hex_inst_4 ({4{test3}}, HEX4);
    HexDriver hex_inst_5 ({4{test4}}, HEX5); 
	 HexDriver hex_inst_6 (keycode[3:0], HEX6);
    HexDriver hex_inst_7 (keycode[7:4], HEX7);
	 
//	 HexDriver hex_inst_8 (keycode3[3:0], HEX2);
//    HexDriver hex_inst_9 (keycode3[7:4], HEX3);
//	 HexDriver hex_inst_10 (keycode4[3:0], HEX4);
//    HexDriver hex_inst_11 (keycode4[7:4], HEX5);
    
	 assign led = keycode3;

endmodule
