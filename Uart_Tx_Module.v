`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Volkan Benzer
// 
// Create Date:    
// Design Name: 
// Module Name:    Uart_Tx_Module 
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
module Uart_Tx_Module(clk_input, tx_pin, data_input, data_load,
							 tx_complete, baudRate );

	input[7:0] data_input;	
	input data_load;
	input clk_input;	
	output reg tx_pin = 1;
	output reg tx_complete = 1;
	
	input[31:0] baudRate;
	
	reg[1:0] caseIndex = 0;
	reg[8:0] txData = 9'h0;
	reg[3:0] sendCnt = 0;
	
	reg[31:0] baudTimer = 0;
	
	always@(negedge clk_input) begin
	
		case (caseIndex)
			 
			0: begin
				tx_pin <= 1;			
				tx_complete <= 1;	
				
				if(!data_load)
					caseIndex = 1;
			end
			
			1: begin
				txData <= {data_input, 1'h0}; //stop bit + data + start bit
				sendCnt <= 0;
				baudTimer = 0;
				//tx_complete <= 1;
				caseIndex = 2;
			end
			
			2: begin
				
				tx_pin <= txData[sendCnt];
				
				if(baudTimer > baudRate) begin
					baudTimer = 0;
					sendCnt <= (sendCnt + 1);
					caseIndex = 3;			
				end
			end
			
			3: begin
			
				if(sendCnt == 9) begin
					caseIndex = 0;
					tx_complete <= 0;			
				end
				else begin
					//if(sendCnt == 9)
						//tx_complete <= 0;
					//else
						//tx_complete <= 1;
						
					caseIndex = 2;
				end
				
			end
		
		endcase
	
	baudTimer = baudTimer + 1;
	
end

endmodule
