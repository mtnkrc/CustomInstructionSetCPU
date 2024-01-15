module projectCPU2022(
  clk,
  rst,
  wrEn,
  data_fromRAM,
  addr_toRAM,
  data_toRAM,
  PC,
  W
);

input clk, rst;

input wire [15:0] data_fromRAM;
output reg [15:0] data_toRAM;
output reg wrEn;
output reg [12:0] addr_toRAM;
output reg [12:0] PC; // This has been added as an output for TB purposes
output reg [15:0] W; // This has been added as an output for TB purposes

reg [12:0] PCNext;
reg [2:0] opcode, opcodeNext;
reg [12:0] operand, operandNext;
reg [15:0] num, numNext;
reg [2:0] state, stateNext;
reg [15:0] WNext;
// Your design goes in here


always @(posedge clk)begin
	state    <= #1 stateNext;
	PC       <= #1 PCNext;
	opcode   <= #1 opcodeNext;
	operand  <= #1 operandNext;
	W        <= #1 WNext;
	num      <= #1 numNext;
end

always @*begin
	stateNext    = state;
	PCNext       = PC;
	opcodeNext   = opcode;
	operandNext  = operand;
	numNext      = num;
	WNext        = W;
	addr_toRAM   = 0;
	wrEn         = 0;
	data_toRAM   = 0;
if(rst)
	begin
	stateNext    = 0;
	PCNext       = 0;
	opcodeNext   = 0;
	operandNext  = 0;
	WNext        = 0;
	numNext      = 0;
	addr_toRAM   = 0;
	wrEn         = 0;
	data_toRAM   = 0;
	end
else 
	case(state)
		0: begin
			PCNext      = PC;
			opcodeNext  = opcode;
			operandNext = 0;
			addr_toRAM  = PC;
			numNext     = 0;
			WNext       = W;
			wrEn        = 0;
			data_toRAM  = 0;
			stateNext   = 1;
		end
		
		
		1: begin
			PCNext      = PC;
			opcodeNext  = data_fromRAM[15:13];
			operandNext = data_fromRAM[12:0];
			numNext     = num;
			WNext       = W;
			wrEn        = 0;
			addr_toRAM  = data_fromRAM[12:0];
			stateNext   = 3;
			if(operandNext == 0) begin
				addr_toRAM  = 4;
				stateNext   = 2;
			end
		end
		
		 
		2: begin
			PCNext      = PC;
			opcodeNext  = opcode;
			operandNext = data_fromRAM;
			WNext       = W;
			addr_toRAM  = data_fromRAM;
			numNext     = 0;
			wrEn        = 0;
			data_toRAM  = 0;
			stateNext   = 3;
		end 
		
		
		3: begin
			PCNext      = PC;
			opcodeNext  = opcode;
			operandNext = operand;
			addr_toRAM  = operand;
			numNext     = 0;
			WNext       = W;
			wrEn        = 0;
			data_toRAM  = 0;
			if(opcodeNext == 3'b000) begin
				stateNext = 4;
			end
			if(opcodeNext == 3'b001) begin
				stateNext = 4;
			end
			if(opcodeNext == 3'b010) begin
				stateNext = 4;
			end
			if(opcodeNext == 3'b011) begin
				stateNext = 4;
			end
			if(opcodeNext == 3'b100) begin
				stateNext = 4;
			end
			if(opcodeNext == 3'b101) begin
				stateNext = 4;
			end
			if(opcodeNext == 3'b110) begin
				stateNext = 4;
			end
			if(opcodeNext == 3'b111) begin
				stateNext = 4;
			end	
		end
		
		
		4: begin
			PCNext       = PC + 1;
			opcodeNext   = opcode;
			operandNext  = operand;
			addr_toRAM   = operand;
			numNext      = data_fromRAM;
			wrEn         = 1;
			WNext        = W;
			if(opcode == 3'b000) begin
				wrEn      = 0;
				WNext     = W + data_fromRAM;
				stateNext = 0;
			end
			
			if(opcode == 3'b001) begin
				wrEn      = 0;
				WNext     = ~(W | data_fromRAM);
				stateNext = 0;
			end
			
			if(opcode == 3'b010) begin
				wrEn      = 0;
				stateNext = 0;
				if(data_fromRAM < 16) begin
					WNext = W >> data_fromRAM;
				end
				else begin
					WNext = W << data_fromRAM[3:0];
				end
			end 
			 
			if(opcode == 3'b011) begin
				wrEn        = 0;
				stateNext   = 0;
				if(data_fromRAM < 16) begin
					WNext = (W >> data_fromRAM) | (W << (16-data_fromRAM));
				end
				else begin
					WNext = (W << data_fromRAM[3:0]) | (W >> (16-data_fromRAM[3:0]));
				end
			end
			
			if(opcode == 3'b100) begin
				wrEn      = 0;
				stateNext = 0;
				if(W < data_fromRAM) begin
					WNext  = 16'hFFFF; 
				end
				else if (W == data_fromRAM) begin
					WNext  = 16'h0000;
				end
				else begin
					WNext  = 16'h0001;
				end
			end
			
			if(opcode == 3'b101) begin
				stateNext = 0;
				if(data_fromRAM == 0) begin
					wrEn   = 0;
					PCNext = W;
				end
				else begin
					wrEn   = 0;
					PCNext = PC + 1;
				end
			end
			
			if(opcode == 3'b110) begin
				wrEn      = 0;
				stateNext = 0;
				WNext     = data_fromRAM;
			end
			
			if(opcode == 3'b111) begin
				data_toRAM = W;
				stateNext  = 0;
			end
		end
		
		
		default: begin
			stateNext    = 0;
			PCNext       = 0;
			opcodeNext   = 0;
			operandNext  = 0;
			WNext        = 0;
			numNext      = 0;
			addr_toRAM   = 0;
			wrEn         = 0; 
			data_toRAM   = 0;
		end
	endcase
	
end

endmodule

