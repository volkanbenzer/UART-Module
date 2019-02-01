`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Volkan Benzer
// 
// Create Date:    
// Design Name: 
// Module Name:    Uart_Rx 
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
module Uart_Rx_Module(clk_input, rx_pin, data_output, rx_complete, baudRate);

	input clk_input;		
	input rx_pin;
	input[31:0] baudRate;
	
	output reg[7:0] data_output;
	output reg rx_complete = 1;
	
	reg[1:0] rxCaseIndex = 2'h0;
	reg[9:0] rxData = 10'h0;
	reg[3:0] recvCnt = 0;	

	reg[31:0] rxBaudTimer = 0;
	
	always@(negedge clk_input) begin

		case(rxCaseIndex)

			0: begin
				recvCnt = 0;
				rxData <= 9'h0;
				rxBaudTimer = (baudRate / 2); 		//the sampling should be middle of received bits
				rx_complete <= 1;
				
				if(!rx_pin) begin
					rxCaseIndex = 1;
					
				end
			end
			
			1: begin				
				
				if(rxBaudTimer > baudRate) begin
					rxBaudTimer = 31'h0;

					rxData[recvCnt] <= rx_pin;
					
					rxCaseIndex = 2;
					recvCnt = recvCnt + 1;
				end
			end
				
			2:	begin
				
				if(recvCnt == 10) begin
					rxCaseIndex = 0;
					data_output <= ((rxData >> 1) & 9'h0FF);
					rx_complete <= 0;
				end
				else
					rxCaseIndex = 1;
			end
			
		endcase	
		
		rxBaudTimer = rxBaudTimer + 1;
	end

endmodule
