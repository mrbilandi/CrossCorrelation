`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:50 12/28/2014 
// Design Name: 
// Module Name:    abs 
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
module abs
	#( parameter width = 18,
		parameter stage = 8
	  )
	 (	input 		[width-1:0]x,
		input 		[width-1:0]y,
		output 		[width+1:0]z,	
		input 		clk,
		input 		rst	
    );
	
	reg [width+1:0]x_temp[stage-2:0];
	reg [width+1:0]y_temp[stage-2:0];
	
	integer k;
	initial begin 
		for(k=0;k<stage-1;k=k+1)
			begin
				x_temp[k] <= 0;
				y_temp[k] <= 0;
			end
	end 
	
	wire [width+1:0]x_pos[stage-2:0];	
	wire [width+1:0]y_pos[stage-2:0];	
	wire [width+1:0]z_temp;
	////////////////////////////////////////////////////////////////////////////
	assign x_pos[0] = (x[width-1])? {2'b0,-(x)}:{2'b0,(x)};//{2'b0,-(x<<2)}:{2'b0,(x<<2)};
	assign y_pos[0] = (y[width-1])? {2'b0,-(y)}:{2'b0,(y)};//{2'b0,-(y<<2)}:{2'b0,(y<<2)};
	//////////////////////////////////////////////////////////////////////////////
	genvar j;
   generate
      for (j=1; j< (stage-1); j= j+1) 
      begin: u1
         	assign x_pos[j] = (x_temp[j-1][width])? -x_temp[j-1]:x_temp[j-1];
				assign y_pos[j] = (y_temp[j-1][width])? -y_temp[j-1]:y_temp[j-1];
      end
   endgenerate
	/////////////////////////////////////////////////////////////////////////////
	genvar i;
   generate
      for (i=0; i< (stage-1); i= i+1) 
			begin: u2
				always@(posedge clk)
					if(rst)
						begin
							x_temp[i] 	<= 0;
							y_temp[i]	<= 0;
						end	
					else
						begin
							x_temp[i]	<= x_pos[i]+(y_pos[i]>>i);
							y_temp[i]	<= y_pos[i]-(x_pos[i]>>i);
						end
		end	
	endgenerate		

	//assign z_temp = x_temp[stage-2]>>2;		
	assign z = x_temp[stage-2];	//z_temp + x_temp[stage-2][0]; 

endmodule
