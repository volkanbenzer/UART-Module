`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Volkan Benzer
//
// Create Date:   
// Design Name:   uart_main
// Module Name:   G:/Projeler/Spartan3E/Uart_uygulama/UART_RxTx/UART_RxTx/UART_RxTx_TB.v
// Project Name:  UART_RxTx
// Target Device:  
// Tool versions:  
// Description: The send data byte is [sendData = 8'b11001001]. we expect that receive data should be equal the send data
//					 This text file comfirm the our UART_main code. The Simulation takes time more than 8-9us. Please adjust it to min 10us
//					 If there is no problem, Isim console will show that:
//					 "Test Result=> Sent Data:11001001,  Received Data:11001001, Time:       xxxx"
// Verilog Test Fixture created by ISE for module: uart_main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module UART_RxTx_TB;

	// Inputs
	reg clkInput;
	reg rxInput;
	reg [7:0] sendData;
	reg sendStart;

	// Outputs
	wire [7:0] recvData;
	wire recvCompFlag;
	wire txOutput;
	wire sendCompFlag;

	// Instantiate the Unit Under Test (UUT)
	uart_main uut (
		.clkInput(clkInput), 
		.rxInput(rxInput), 
		.recvData(recvData), 
		.recvCompFlag(recvCompFlag), 
		.txOutput(txOutput), 
		.sendData(sendData), 
		.sendStart(sendStart), 
		.sendCompFlag(sendCompFlag)
	);

	integer i;

	initial begin
		// Initialize Inputs
		clkInput = 1;		
		sendData = 8'b11001001;			//send data byte 
		sendStart = 1;

		// Wait 100 ns for global reset to finish
		#100;
		$display("Test has been started");        
        
		for(i = 0; i < 1000000; i = i +1) 
		begin
			#1 clkInput = 0;
			#1 clkInput = 1;
			
			if(i == 10)
				sendStart = 0;			
			else
				sendStart = 1;	
			
	 
			if(recvCompFlag == 0) begin			// if data receiving is completed, the loop is finish 
				$display("Test Result=> Sent Data:%b,  Received Data:%b, Time:%d", sendData, recvData, i);
				i = 1000000;
			end
		end		
		
		
		

	end
      
endmodule

