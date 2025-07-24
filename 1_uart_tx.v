
// UART transmitter it has 1 start bit, 8 data bits and 1 stop bit



module #(parameter clk_per_bit) uart_tx( input i_clk,                // clk_per_bit is basically master clock divided by BAUD rate
                                             i_tx_dv,                // this tells UART THAT THERE IS A VALID INPUT
                                      input [7:0] i_tx_byte,        // THIS IS 8 BIT data
                                      output reg o_tx_serial,         // serial output from UART
                                      output o_tx_active,             // tells UART is in active mode and work not completed yet
                                      o_tx_done);                     // tells UART function done.

reg [7:0] r_clk_count =0;     // will start counting clk per bit when tx ready 
reg [2:0] r_data_bit =0;      // this count no of bits of data 
reg [2:0] r_state =0;         // state or fsm manager 
reg[7:0] r_tx_data = 0;       // this register will hold input 8 bits data
reg r_tx_active =0;           // indicates the a valid data recieved
reg r_tx_done =0;             // register becomes 1 when transfer complete


parameter s_IDLE = 3'b000;            // we used a 3 bit register to declare 5 states. the basic function inside of UART will occur as FSM
parameter s_start_bit = 3'b001;
parameter s_data_bit = 3'b010;
parameter s_stop_bit = 3'b011;
parameter s_cleanup = 3'b100;


// MAIN MODE OF UART is about different FSM states being controlled by r_state register
always@( posedge i_clk)
begin
    case(r_state)

    s_IDLE: begin
           o_tx_serial <= 1'b1;   // for idle output remains high
            
            r_clk_count<= 1'b0;
            r_data_bit<=1'b0;
            r_tx_done <=1'b0;

            if( i_tx_dv)                // if a valid input recieved make UART into active stage
            begin
                r_tx_active<=1'b1;
                r_tx_data<= i_tx_byte;           // data is loaded inside  register of UART and we would not use i_tx_byte further 
                r_state<= s_start_bit;
            end

            else
            begin
            r_state<= s_IDLE;
            end
    end

    s_start_bit: begin
        o_tx_serial <= 1'b0;    // makes start bit low - makes it 0

        if( r_clk_count< clk_per_bit -1  )
        begin 
            r_clk_count<= r_clk_count +1;              // each bit will take a particular time so keep a counter // for example clk_per_bit comes 87
            r_state<= s_start_bit;

        end
        else
        begin
        r_clk_count<= 1'b0;
            r_state<= s_data_bit;
        end
    end

    s_data_bit: begin
        o_tx_serial<= r_tx_data[r_data_bit];               // data bit is shifted on serial output 
                                                           // r_tx_data has all 8 data bits pick them bit by bit
        if(r_clk_count< clk_per_bit-1)
            begin
                r_clk_count<= r_clk_count+1;
                r_state<= s_data_bit;
            end
        else
        begin
            r_clk_count<= 1'b0;

            if(r_data_bit<7)
            begin
                r_data_bit<= r_data_bit+1;
                r_state<= s_data_bit;
            end
            else
            begin
            r_data_bit<= 1'b0;
                r_state<= s_stop_bit;
            end
        end
    end

    s_stop_bit: begin
        o_tx_serial<= 1'b1;

        if(r_clk_count< clk_per_bit-1)            // stop bit again will stay until 87 cl_per_bits not over
        begin
            r_clk_count <= r_clk_count+1;
            r_state<= s_stop_bit;

        end

        else
        begin
            r_tx_done<=1'b1;                       // now make tx_done= 1 and tx_active as 0 
            r_clk_count <=1'b0;
            r_state<= s_cleanup;                   // start cleanup
            r_tx_active <=1'b0; 

        end
    end

    s_cleanup: begin
        r_tx_done<=1'b1;
        r_state<= s_IDLE;
        r_tx_data<= 8'b0;
    end

    default: r_state<= s_IDLE;

    endcase
end

assign o_tx_active <= r_tx_active;
assign o_tx_done <= r_tx_done;

endmodule



       

        
    







