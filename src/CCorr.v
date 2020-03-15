`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:38:48 08/16/2015 
// Design Name: 
// Module Name:    CCorr 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CCorr
	#( parameter stage =4)
	(
		input clk,
		input rst,
		input en,
		input [31:0]data1_in_re,
		input [31:0]data1_in_im,
		input [31:0]data2_in_re,
		input [31:0]data2_in_im,
		
		output [31:0]data_out_re0,
		output [31:0]data_out_re1,
		output [31:0]data_out_re2,
		output [31:0]data_out_re3,
//		output [31:0]data_out_re4,
//		output [31:0]data_out_re5,
//		output [31:0]data_out_re6,
//		output [31:0]data_out_re7,
//		output [31:0]data_out_re8,
		
		output [31:0]data_out_im0,
		output [31:0]data_out_im1,
		output [31:0]data_out_im2,
		output [31:0]data_out_im3,
//		output [31:0]data_out_im4,
//		output [31:0]data_out_im5,
//		output [31:0]data_out_im6,
//		output [31:0]data_out_im7,
//		output [31:0]data_out_im8,
		
		output ready
//		output [31:0]max_phi,
//		output [15:0]max_index_out
    );
	 
	 		wire [31:0]max_phi;
		wire [15:0]max_index_out;
	 reg [31:0]data1_d_re[0:(stage/2)-1];
	 reg [31:0]data1_d_im[0:(stage/2)-1];
	 reg [31:0]data2_d_re[0:(stage/2)-1];
	 reg [31:0]data2_d_im[0:(stage/2)-1];
	 
	 integer i;
	 initial 
	 begin
		for(i=0;i<stage/2;i=i+1)
			begin
				data1_d_re[i]=0;
				data1_d_im[i]=0;
				data2_d_re[i]=0;
				data2_d_im[i]=0;
			end	
	 end
	
	always @(posedge clk)
		begin	
			if(rst)
				begin
					data1_d_re[0] <=0;
					data1_d_im[0] <=0;
					data2_d_re[0] <=0;
					data2_d_im[0] <=0;
				end
			else
				begin 
					data1_d_re[0]		  <= data1_in_re;
					data1_d_im[0]		  <= data1_in_im;
					data2_d_re[0]		  <= data2_in_re;
					data2_d_im[0]		  <= data2_in_im;
				end					
		end
		
	genvar gvar0;
	
	generate 
		for(gvar0=0; gvar0<((stage/2)-1); gvar0 = gvar0+1)
			begin: u0
				always @(posedge clk)
				begin	
					if(rst)
						begin
							data1_d_re[gvar0+1] <=0;
							data1_d_im[gvar0+1] <=0;
							data2_d_re[gvar0+1] <=0;
							data2_d_im[gvar0+1] <=0;
						end
					else
						begin 
							data1_d_re[gvar0+1] <= data1_d_re[gvar0];
							data1_d_im[gvar0+1] <= data1_d_im[gvar0];
							data2_d_re[gvar0+1] <= data2_d_re[gvar0];
							data2_d_im[gvar0+1] <= data2_d_im[gvar0];
						end
				end		
			end
	endgenerate
	
	wire [31:0]cplx_phi_re_net[0:stage-1];
	wire [31:0]cplx_phi_im_net[0:stage-1];
	
	reg [31:0]cplx_phi_re[0:stage-1];
	reg [31:0]cplx_phi_im[0:stage-1];
	 
	integer k;
	initial 
		begin 
			for(k=0; k <stage-1; k=k+1)begin
				cplx_phi_re[k]<=0;
				cplx_phi_im[k]<=0;
			end	
		end
	
	wire [31:0]cplx_lag_re[0:stage-1];
	wire [31:0]cplx_lag_im[0:stage-1];
	
	 wire phi_rst;
	 assign phi_rst = 1'b0;
	 
	 genvar gvar1;
	 
	 generate 
		for (gvar1=0; gvar1 < ((stage/2)-1); gvar1 = gvar1+1)
			begin:u1
				ComplexMUL ComplexMUL_inst0 (
							.clk(clk), 
							.rst(rst), 
							.en(en), 
							.data1_in_re(data1_d_re[(stage/2)-1-gvar1]), 
							.data1_in_im(data1_d_im[(stage/2)-1-gvar1]), 
							.data2_in_re(data2_d_re[0]), 
							.data2_in_im(data2_d_im[0]), 
							.cplx_mul_re(cplx_lag_re[gvar1]), 
							.cplx_mul_im(cplx_lag_im[gvar1])
							);
	
							
				ComplexMUL ComplexMUL_inst2 (
							.clk(clk), 
							.rst(rst), 
							.en(en), 
							.data1_in_re(data1_d_re[0]), 
							.data1_in_im(data1_d_im[0]), 
							.data2_in_re(data2_d_re[gvar1+1]), 
							.data2_in_im(data2_d_im[gvar1+1]), 
							.cplx_mul_re(cplx_lag_re[(stage/2)+gvar1]), 
							.cplx_mul_im(cplx_lag_im[(stage/2)+gvar1])
							);					
				end				
	 endgenerate

					ComplexMUL ComplexMUL_inst1 (
							.clk(clk), 
							.rst(rst), 
							.en(en), 
							.data1_in_re(data1_d_re[0]), 
							.data1_in_im(data1_d_im[0]), 
							.data2_in_re(data2_d_re[0]), 
							.data2_in_im(data2_d_im[0]), 
							.cplx_mul_re(cplx_lag_re[(stage/2)-1]), 
							.cplx_mul_im(cplx_lag_im[(stage/2)-1])
							);	

	 genvar gvar2;
	 
	 generate 
		for (gvar2=0; gvar2 < ((stage/2)-1); gvar2 = gvar2+1)
			begin:u2
				ComplexADD ComplexADD_inst0 (
							.clk(clk), 
							.rst(rst), 
							.en(en), 
							.data1_in_re(cplx_phi_re_net[gvar2]), 
							.data1_in_im(cplx_phi_im_net[gvar2]), 
							.data2_in_re(cplx_lag_re[gvar2]), 
							.data2_in_im(cplx_lag_im[gvar2]), 
							.cplx_add_re(cplx_phi_re_net[gvar2]), 
							.cplx_add_im(cplx_phi_im_net[gvar2])
							);
			
							
				ComplexADD ComplexADD_inst2 (
							.clk(clk), 
							.rst(rst), 
							.en(en), 
							.data1_in_re(cplx_phi_re_net[(stage/2)+gvar2]), 
							.data1_in_im(cplx_phi_im_net[(stage/2)+gvar2]), 
							.data2_in_re(cplx_lag_re[(stage/2)+gvar2]), 
							.data2_in_im(cplx_lag_im[(stage/2)+gvar2]), 
							.cplx_add_re(cplx_phi_re_net[(stage/2)+gvar2]), 
							.cplx_add_im(cplx_phi_im_net[(stage/2)+gvar2])
							);			
				end				
	 endgenerate
	 
	 				ComplexADD ComplexADD_inst1 (
							.clk(clk), 
							.rst(rst), 
							.en(en), 
							.data1_in_re(cplx_phi_re_net[(stage/2)-1]), 
							.data1_in_im(cplx_phi_im_net[(stage/2)-1]), 
							.data2_in_re(cplx_lag_re[(stage/2)-1]), 
							.data2_in_im(cplx_lag_im[(stage/2)-1]), 
							.cplx_add_re(cplx_phi_re_net[(stage/2)-1]), 
							.cplx_add_im(cplx_phi_im_net[(stage/2)-1])
							);
	 
	 genvar gvar3;
	 
	 generate 
		for (gvar3=0; gvar3 < stage-1; gvar3 = gvar3+1)
			begin:u3
				always@(posedge clk)
					begin 
						if(rst)
							begin 
								cplx_phi_re[gvar3] <= 0;
								cplx_phi_im[gvar3] <= 0;
							end
						else
							begin 
								cplx_phi_re[gvar3] <= cplx_phi_re_net[gvar3];
								cplx_phi_im[gvar3] <= cplx_phi_im_net[gvar3];
							end
					end 	
			end
	endgenerate

 // Absolut 
	wire [33:0]abs_phi_net[0:stage-1];
	reg [33:0]abs_phi[0:stage-1];
	genvar gvar7;
	 
	 generate 
		for (gvar7=0; gvar7 < stage; gvar7 = gvar7+1)
			begin:u7
				abs 
				#( .width(32),
					.stage(8)
					)
				abs_inst (
					.x(cplx_phi_re[gvar7]), 
					.y(cplx_phi_im[gvar7]), 
					.z(abs_phi_net[gvar7]), 
					.clk(clk), 
					.rst(rst)
					);
			always @(posedge clk)
				begin
					if(rst)
						abs_phi[gvar7] <= 0;
					else	
						abs_phi[gvar7] <= abs_phi_net[gvar7];
				end		
			end
	endgenerate			
	

	// Bineary search 
	reg [31:0]max_phi_re[0:10/*log(stage)*/][0:stage/2];
	
	reg [15:0]max_index[0:10][0:stage/2];
	integer i0,i1;
	
	initial begin 
		for (i0=0; i0<11/*log(stage)+1*/; i0=i0+1)
			for (i1=0; i1<((stage/2)+1); i1=i1+1)
				begin 
					max_phi_re[i0][i1] <= 0;
					max_index[i0][i1]  <= 0;
				end	
	end 
	
	genvar gvar4;
	generate 
		for (gvar4=0; gvar4< stage-2; gvar4 = gvar4 +2)
			begin: u4
				always @(posedge clk)
					begin
						if(rst)
							begin
								max_phi_re[0][gvar4/2] <= 0;
								max_index [0][gvar4/2] <= 0;
							end
						else
							begin 
								if(en)
									begin
										max_phi_re[0][gvar4/2] <= (abs_phi[gvar4]>abs_phi[gvar4+1])? abs_phi[gvar4] : abs_phi[gvar4+1];	
										max_index [0][gvar4/2] <=  (abs_phi[gvar4]>abs_phi[gvar4+1])? gvar4 : gvar4+1;	
									end
							end
					end
			end
	endgenerate 
	
	genvar gvar5, gvar6;
   generate
      for (gvar5=1; gvar5 < 10/*log(stage)*/; gvar5= gvar5+1) 
      begin: u5
         for (gvar6=0; gvar6 < (stage/(2**gvar5)); gvar6= gvar6 +2) 
         begin: u6
            always @(posedge clk)
					begin 
						if(rst)
							begin
								max_phi_re[gvar5][gvar6/2] <= 0;
								max_index [gvar5][gvar6/2] <= 0;
							end
						else
							begin
								if(en)
									begin
										max_phi_re[gvar5][gvar6/2] <= (max_phi_re[gvar5-1][gvar6]>max_phi_re[gvar5-1][gvar6+1])? max_phi_re[gvar5-1][gvar6]: max_phi_re[gvar5-1][gvar6+1];
										max_index[gvar5][gvar6/2] <= (max_phi_re[gvar5-1][gvar6]>max_phi_re[gvar5-1][gvar6+1])? max_index[gvar5-1][gvar6]: max_index[gvar5-1][gvar6+1];
									end	
							end	
					end
			end
      end
   endgenerate
	
	
	assign max_phi = max_phi_re[2/*log(stage)*/][0];
	//assign max_phi = max_phi_re[2/*log(stage)*/][0]; 
	assign max_index_out = max_index[2/*log(stage)*/][0]; 
	

	 
	// Step Counter
	reg [31:0]count=0;
	always @(posedge clk)
	begin 
		if(rst)
			count <= 0;
		else
			count <= count +1;
			//$stop;
	end 
	
	
	integer output_file_re;
	integer output_file_im;
	integer h;
	
	initial begin
		// Initialize Inputs
		output_file_re = $fopen("data_out_re.dat", "w");
		output_file_im = $fopen("data_out_im.dat", "w");
		wait(count == 1005);
		for(h=0; h<stage-1; h = h+1) begin
			$fwrite(output_file_re,"%d\n", cplx_phi_re[h]);
			$fwrite(output_file_im,"%d\n", cplx_phi_im[h]);
			//$stop;
		end 	
		$fclose(output_file_re);
		$fclose(output_file_im);
		wait(count == 1005);
		$display("max_lag = %d", max_index[9/*log(stage)*/][0]);
		$stop;
		// Wait 100 ns for global reset to finish
		//#100;
        
		// Add stimulus here

	end
	
	// Output assignment
//	assign data_out_re0 = abs_phi_net[0]; 
//	assign data_out_re1 = abs_phi_net[1]; 
//	assign data_out_re2 = abs_phi_net[2]; 
//	assign data_out_re3 = abs_phi_net[3]; 
//	assign data_out_re4 = abs_phi_net[4]; 
//	assign data_out_re5 = abs_phi_net[5]; 
//	assign data_out_re6 = abs_phi_net[6]; 
//	assign data_out_re7 = abs_phi_net[7]; 
	
	assign data_out_re0 = abs_phi[0];//max_index[0/*log(stage)*/][0];//cplx_phi_re[0];//&cplx_phi_re[1];// & cplx_phi_re[2]) &cplx_phi_re[3]) &cplx_phi_re[4]) &cplx_phi_re[5] )&cplx_phi_re[6]) &cplx_phi_re[7]); 
	assign data_out_re1 = abs_phi[1];//max_index[1/*log(stage)*/][0];//cplx_phi_re[1];//&cplx_phi_re[3]; 
	assign data_out_re2 = abs_phi[2];//max_index[2/*log(stage)*/][0];//cplx_phi_re[2];//&cplx_phi_re[5]; 
	assign data_out_re3 = abs_phi[3];//max_index[3/*log(stage)*/][0];//cplx_phi_re[3];//&cplx_phi_re[7]; 
//	assign data_out_re4 = cplx_phi_re[4]; 
//	assign data_out_re5 = cplx_phi_re[5]; 
//	assign data_out_re6 = cplx_phi_re[6]; 
//	assign data_out_re7 = cplx_phi_re[7]; 
//	
	assign data_out_im0 = max_phi_re[0/*log(stage)*/][0];//cplx_phi_im[0];//&cplx_phi_im[1];// &cplx_phi_im[2]) &cplx_phi_im[3]) &cplx_phi_im[4]) &cplx_phi_im[5]) &cplx_phi_im[6]) &cplx_phi_im[7]); 
	assign data_out_im1 = max_phi_re[1/*log(stage)*/][0];//cplx_phi_im[1];//&cplx_phi_im[3]; 
	assign data_out_im2 = max_phi_re[2/*log(stage)*/][0];//cplx_phi_im[2];//&cplx_phi_im[5]; 
	assign data_out_im3 = max_phi_re[3/*log(stage)*/][0];//cplx_phi_im[3];//&cplx_phi_im[7]; 
//	assign data_out_im4 = cplx_phi_im[4]; 
//	assign data_out_im5 = cplx_phi_im[5]; 
//	assign data_out_im6 = cplx_phi_im[6]; 
//	assign data_out_im7 = cplx_phi_im[7]; 
	
	
	
endmodule
