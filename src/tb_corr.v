`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:56:30 08/17/2015
// Design Name:   CCorr
// Module Name:   D:/SaberinProject/Cross-Correlation/ISE/Cross-Correlation/CCorr/tb_corr.v
// Project Name:  CCorr
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CCorr
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_corr;

	// Inputs
	reg clk;
	reg rst;
	reg en;
	reg [31:0] data1_in_re;
	reg [31:0] data1_in_im;
	reg [31:0] data2_in_re;
	reg [31:0] data2_in_im;

	// Outputs
	wire [31:0] data_out;
	wire ready;
	
	wire [31:0]max_phi;
	wire [15:0]max_index_out;
		
	wire [31:0]data_out_re0;
	wire [31:0]data_out_re1;
	wire [31:0]data_out_re2;
	wire [31:0]data_out_re3;
	
	wire [31:0]data_out_im0;
	wire [31:0]data_out_im1;
	wire [31:0]data_out_im2;
	wire [31:0]data_out_im3;

	// Instantiate the Unit Under Test (UUT)
	CCorr 
	//#(.stage(32)) 
	uut
	(
		.clk(clk), 
		.rst(rst), 
		.en(en), 
		.data1_in_re(data1_in_re), 
		.data1_in_im(data1_in_im), 
		.data2_in_re(data2_in_re), 
		.data2_in_im(data2_in_im), 
		
		.data_out_re0(data_out_re0),
		.data_out_re1(data_out_re1),
		.data_out_re2(data_out_re2),
		.data_out_re3(data_out_re3),
		
		.data_out_im0(data_out_im0),
		.data_out_im1(data_out_im1),
		.data_out_im2(data_out_im2),
		.data_out_im3(data_out_im3),
		
		//.data_out(data_out), 
		.ready(ready)
//		.max_phi(max_phi),
//		.max_index_out(max_index_out)
	);
	
	
	always begin 
		clk <= 1;
		#200;
		clk <= 0;
		#200;
	end
	
	integer input_file1_re;
	integer input_file1_im;
	integer input_file2_re;
	integer input_file2_im;
	integer output_file;
	
	reg [31:0]data1_re[0:1000];
	reg [31:0]data1_im[0:1000];
	reg [31:0]data2_re[0:1000];
	reg [31:0]data2_im[0:1000];
	
	integer i=0;
	integer j=0;
	
	initial begin 
		input_file1_re = $fopen("data1_re.dat", "r");
		input_file1_im = $fopen("data1_im.dat", "r");
		input_file2_re = $fopen("data2_re.dat", "r");
		input_file2_im = $fopen("data2_im.dat", "r");
		for(i=0; i<1001; i=i+1) begin
			$fscanf(input_file1_re, "%d", data1_re[i]);
			$fscanf(input_file1_im, "%d", data1_im[i]);
			$fscanf(input_file2_re, "%d", data2_re[i]);
			$fscanf(input_file2_im, "%d", data2_im[i]);
		end	
	end	
	
	integer h;
	
	initial begin
		// Initialize Inputs
		//output_file = $fopen("data_out.dat", "r");
		rst = 1;
		en = 0;
		#600;
		rst =0;
		en =1;
		
		for(h=0; h<1001; h = h+1) begin
			data1_in_re = data1_re[h];
			data1_in_im = data1_im[h];
			data2_in_re = data2_re[h];
			data2_in_im = -data2_im[h];
			//$fwrite(output_file,"%d\n", data_out[h]);
			#400;
		end 	

		// Wait 100 ns for global reset to finish
		//#100;
        
		// Add stimulus here

	end
      
endmodule

