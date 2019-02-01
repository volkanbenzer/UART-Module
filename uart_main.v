`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Volkan Benzer	/ email: volkan.benzer@gmail.com
// 				
// Create Date:    
// Design Name: 
// Module Name:    uart_main 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This Verilog code is useful to understanding Uart Communication in FPGA
//						You can find two code block in below. One of them is suitable for simulation. Other of them can run in a development board
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_main(clkInput, rxInput, recvData, recvCompFlag, //bitCnt, rxBaudTimerOut);
					  txOutput, sendData, sendStart, sendCompFlag);
						
						
	input clkInput;
	
	input rxInput;	
	output [7:0] recvData;
	output recvCompFlag;
	
	output txOutput;
	input[7:0] sendData;	
	input sendStart;		
	output sendCompFlag;
	
	wire ecoWire;
	
	wire[7:0] dataWire;
	wire txrxwire;
	
	parameter baudRateWanted = 115200;	//baudrate = 115200
	parameter xtall_freq = 50*1000000;	//for 50 MHz
	parameter baudRateVal = xtall_freq / baudRateWanted; //so (1/baudRateWanted) / (1/xtall_freq);
	
	
	//This block is used for simulation. Rx_pin and Tx_pin are connected by a wire (its name is ecoWire) for eco.  
	//If you want to view in real environment (SPARTAN-3E etc.), close this block and make synthesize than generate programmin File
	Uart_Rx_Module Uart_Rx(.clk_input(clkInput), .rx_pin(ecoWire), .data_output(recvData), 
								  .rx_complete(recvCompFlag), .baudRate(baudRateVal));
	
	Uart_Tx_Module Uart_Tx(.clk_input(clkInput), .tx_pin(ecoWire), .data_input(sendData), 
								  .tx_complete(sendCompFlag), .data_load(sendStart) , .baudRate(baudRateVal));

	assign txOutput = ecoWire; 	// you can check send data that output of Uart_Tx_Module with this output. It is not required


	//This block is used for real application. It was tested on Spartan-3E board with a serial communication tool that runs on PC
	//SPARTAN 3E connects DB9 (J9) connector with PC. a Serial tool that names is Hercules used on PC. BaudRate value is 115200
	
	/*Uart_Rx_Module Uart_Rx(.clk_input(clkInput), .rx_pin(rxInput), .data_output(dataWire), 
								  .rx_complete(txrxwire), .baudRate(baudRateVal));
	
	Uart_Tx_Module Uart_Tx(.clk_input(clkInput), .tx_pin(txOutput), .data_input(dataWire), 
								  .tx_complete(sendCompFlag), .data_load(txrxwire) , .baudRate(baudRateVal));

	assign recvData = dataWire;*/		//This wire is used for eco. 

endmodule


