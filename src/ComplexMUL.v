`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:35:43 08/18/2015 
// Design Name: 
// Module Name:    ComplexMUL 
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
module ComplexMUL(
		input clk,
		input rst,
		input en,
		input [31:0]data1_in_re,
		input [31:0]data1_in_im,
		input [31:0]data2_in_re,
		input [31:0]data2_in_im,
		output reg[31:0]cplx_mul_re,
		output reg[31:0]cplx_mul_im
    );
	 
	 initial 
		begin 
			cplx_mul_re<=0;
			cplx_mul_im<=0;
	end	
		
	 reg [31:0]mid[0:7];
	 
	initial 
		begin 
			mid[0] <= 0;
			mid[1] <= 0;
			mid[2] <= 0;
			mid[3] <= 0;
			mid[4] <= 0;
			mid[5] <= 0;
			mid[6] <= 0;
			mid[7] <= 0;
	end	
	 
	 always @( posedge clk)
	 begin
		if(rst) 
			begin
				mid[0] <= 0;
				mid[1] <= 0;
				mid[2] <= 0;
				mid[3] <= 0;
				mid[4] <= 0;
				mid[5] <= 0;
				mid[6] <= 0;
				mid[7] <= 0;
				
			end
		else
			begin
				if(en)
					begin 
						mid[0]<= data1_in_re*data2_in_re;
						mid[1]<= data1_in_re*data2_in_im;
						mid[2]<= data1_in_im*data2_in_re;
						mid[4]<= data1_in_im*data2_in_im;
					end	
			end	
	 end
	 
	 always@(posedge clk)
	 begin 
		if(rst)
			begin 
				cplx_mul_re <= 0;
				cplx_mul_im <= 0;
			end
		else
			begin 
				if(en)
					begin 
						cplx_mul_re <= mid[0]-mid[4];
						cplx_mul_im <= mid[1]+mid[2];
					end	
			end
	 end 
	 


endmodule
