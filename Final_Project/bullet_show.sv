module bullet_show (	 input frame_clk,       	  
							 input [1:0] bullet_state [30],
							 input [9:0] DrawX, DrawY,
							 input [1:0] chara_id,
							 input pl,
							 
							 output logic [23:0] bullet_show_color
							 );
	 
	/*always_ff @ (posedge frame_clk) begin
		
		
	end*/
	
	 always_comb begin
		bullet_show_color = 0;
		unique case (chara_id)
			2'b00: begin
				if (~pl) begin
					//healthbar and energybar
					if (((DrawY>=9&&DrawY<=10)||(DrawY>=39&&DrawY<=40)||DrawY>=59&&DrawY<=60)&&(DrawX>=9&&DrawX<=162)) begin
						bullet_show_color = 24'hffa500;
					end
					if ((DrawY>=9&&DrawY<=60)&&(DrawX>=9&&DrawX<=10||DrawX>=161&&DrawX<=162)) begin
						bullet_show_color = 24'hffa500;
					end
					//bullet
					for (int i=19; i>=10; i--) begin
						if (bullet_state[i]==0) begin
							if (DrawX==234-8*i&&DrawY==440) begin // first line 
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX>=233-8*i&&DrawX<=235-8*i&&(DrawY==441||DrawY==442)) begin //second and third line
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX>=232-8*i&&DrawX<=236-8*i&&DrawY>=443&&DrawY<=451) begin
								bullet_show_color = 24'hffffff;
							end
							if (DrawX>=232-8*i&&DrawX<=236-8*i&&DrawY>=444&&DrawY<=449) begin
								bullet_show_color = 24'hffa500;
							end
						end
					end
					for (int i=9; i>=0; i--) begin
						if (bullet_state[i]==0) begin
							if (DrawX==154-8*i&&DrawY==458) begin // first line 
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX>=153-8*i&&DrawX<=155-8*i&&(DrawY==459||DrawY==460)) begin //second and third line
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX>=152-8*i&&DrawX<=156-8*i&&DrawY>=461&&DrawY<=469) begin
								bullet_show_color = 24'hffffff;
							end
							if (DrawX>=152-8*i&&DrawX<=156-8*i&&DrawY>=462&&DrawY<=467) begin
								bullet_show_color = 24'hffa500;
							end
						end
					end
				end
				else begin // the right player
					if (((DrawY>=9&&DrawY<=10)||(DrawY>=39&&DrawY<=40)||DrawY>=59&&DrawY<=60)&&(DrawX<=630&&DrawX>=477)) begin
						bullet_show_color = 24'hffa500;
					end
					if ((DrawY>=9&&DrawY<=60)&&(DrawX>=629&&DrawX<=630||DrawX>=477&&DrawX<=478)) begin
						bullet_show_color = 24'hffa500;
					end
					for (int i=19; i>=10; i--) begin
						if (bullet_state[i]==0) begin
							if (DrawX==405+8*i&&DrawY==440) begin // first line 
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX<=406+8*i&&DrawX>=404+8*i&&(DrawY==441||DrawY==442)) begin //second and third line
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX<=407+8*i&&DrawX>=403+8*i&&DrawY>=443&&DrawY<=451) begin
								bullet_show_color = 24'hffffff;
							end
							if (DrawX<=407+8*i&&DrawX>=403+8*i&&DrawY>=444&&DrawY<=449) begin
								bullet_show_color = 24'hffa500;
							end
						end
					end
					for (int i=9; i>=0; i--) begin
						if (bullet_state[i]==0) begin
							if (DrawX==485+8*i&&DrawY==458) begin // first line 
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX<=486+8*i&&DrawX>=484+8*i&&(DrawY==459||DrawY==460)) begin //second and third line
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX<=487+8*i&&DrawX>=483+8*i&&DrawY>=461&&DrawY<=469) begin
								bullet_show_color = 24'hffffff;
							end
							if (DrawX<=487+8*i&&DrawX>=483+8*i&&DrawY>=462&&DrawY<=467) begin
								bullet_show_color = 24'hffa500;
							end
						end
					end
				end
			end
			2'b01: begin
				if (~pl) begin
					//draw bar
					if (((DrawY>=9&&DrawY<=10)||(DrawY>=39&&DrawY<=40))&&(DrawX>=9&&DrawX<=212)) begin
						bullet_show_color = 24'hffa500;
					end
					if ((DrawY>=59&&DrawY<=60)&&(DrawX>=9&&DrawX<=162)) begin
						bullet_show_color = 24'hffa500;
					end
					if ((DrawY>=9&&DrawY<=40)&&(DrawX>=9&&DrawX<=10||DrawX>=211&&DrawX<=212)) begin
						bullet_show_color = 24'hffa500;
					end
					if ((DrawY>=40&&DrawY<=60)&&(DrawX>=9&&DrawX<=10||DrawX>=161&&DrawX<=162)) begin
						bullet_show_color = 24'hffa500;
					end
					//draw bullet
					for (int i=29; i>=15; i--) begin
						if (bullet_state[i]==0) begin
							if (DrawX==314-8*i&&DrawY==440) begin // first line 
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX>=313-8*i&&DrawX<=315-8*i&&(DrawY==441||DrawY==442)) begin //second and third line
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX>=312-8*i&&DrawX<=316-8*i&&DrawY>=443&&DrawY<=451) begin
								bullet_show_color = 24'hffffff;
							end
							if (DrawX>=312-8*i&&DrawX<=316-8*i&&DrawY>=444&&DrawY<=449) begin
								bullet_show_color = 24'h2e8b57;
							end
						end
					end
					for (int i=14; i>=0; i--) begin
						if (bullet_state[i]==0) begin
							if (DrawX==194-8*i&&DrawY==458) begin // first line 
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX>=193-8*i&&DrawX<=195-8*i&&(DrawY==459||DrawY==460)) begin //second and third line
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX>=192-8*i&&DrawX<=196-8*i&&DrawY>=461&&DrawY<=469) begin
								bullet_show_color = 24'hffffff;
							end
							if (DrawX>=192-8*i&&DrawX<=196-8*i&&DrawY>=462&&DrawY<=467) begin
								bullet_show_color = 24'h2e8b57;
							end
						end
					end
				end
				else begin // the right player
					if (((DrawY>=9&&DrawY<=10)||(DrawY>=39&&DrawY<=40))&&(DrawX<=630&&DrawX>=427)) begin
						bullet_show_color = 24'hffa500;
					end
					if ((DrawY>=59&&DrawY<=60)&&(DrawX<=630&&DrawX>=477)) begin
						bullet_show_color = 24'hffa500;
					end
					if ((DrawY>=9&&DrawY<=40)&&(DrawX<=630&&DrawX>=629||DrawX<=428&&DrawX>=427)) begin
						bullet_show_color = 24'hffa500;
					end
					if ((DrawY>=40&&DrawY<=60)&&(DrawX<=630&&DrawX>=629||DrawX<=478&&DrawX>=477)) begin
						bullet_show_color = 24'hffa500;
					end
					for (int i=29; i>=15; i--) begin
						if (bullet_state[i]==0) begin
							if (DrawX==325+8*i&&DrawY==440) begin // first line 
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX<=326+8*i&&DrawX>=324+8*i&&(DrawY==441||DrawY==442)) begin //second and third line
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX<=327+8*i&&DrawX>=323+8*i&&DrawY>=443&&DrawY<=451) begin
								bullet_show_color = 24'hffffff;
							end
							if (DrawX<=327+8*i&&DrawX>=323+8*i&&DrawY>=444&&DrawY<=449) begin
								bullet_show_color = 24'h2e8b57;
							end
						end
					end
					for (int i=14; i>=0; i--) begin
						if (bullet_state[i]==0) begin
							if (DrawX==445+8*i&&DrawY==458) begin // first line 
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX<=446+8*i&&DrawX>=444+8*i&&(DrawY==459||DrawY==460)) begin //second and third line
								bullet_show_color = 24'hffffff;
							end
							else if (DrawX<=447+8*i&&DrawX>=443+8*i&&DrawY>=461&&DrawY<=469) begin
								bullet_show_color = 24'hffffff;
							end
							if (DrawX<=447+8*i&&DrawX>=443+8*i&&DrawY>=462&&DrawY<=467) begin
								bullet_show_color = 24'h2e8b57;
							end
						end
					end
				end
			end
			default:;
		endcase
	 end	
endmodule

	