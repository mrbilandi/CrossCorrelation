`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:35:22 08/18/2015 
// Design Name: 
// Module Name:    ComplexADD 
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
module ComplexADD(
		input clk,
		input rst,
		input en,
		input [31:0]data1_in_re,
		input [31:0]data1_in_im,
		input [31:0]data2_in_re,
		input [31:0]data2_in_im,
		output [31:0]cplx_add_re,
		output [31:0]cplx_add_im

    );
		
	reg [31:0]cplx_add_re_reg;
	reg [31:0]cplx_add_im_reg;
	
	initial 
		begin 
			cplx_add_re_reg<=0;
			cplx_add_im_reg<=0;
		end	
		
		
		always @(posedge clk)
			begin 
				if(rst)
					begin 
						cplx_add_re_reg <= 0;
						cplx_add_im_reg <= 0;
					end
				else
					begin
						if(en)
							begin 
								cplx_add_re_reg <= data1_in_re+data2_in_re;
								cplx_add_im_reg <= data1_in_im+data2_in_im;
							end	
					end 
			end 
			
			assign cplx_add_re = cplx_add_re_reg;
			assign cplx_add_im = cplx_add_im_reg;
		
endmodule
