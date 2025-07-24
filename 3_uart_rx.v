// UART reciever 
module uart_rx #(parameter clk_per_bit = 87)( input i_rx_serial, input i_clk,
                                             output reg o_rx_dv, output reg [7:0] o_rx_byte);

reg r_rx_data_0 =1'b1;
reg r_rx_data_1 = 1'b1;

reg [7:0] r_rx_byte;
reg [2:0] r_rx_bit;
reg [7:0] r_clock_count;
reg r_rx_dv = 1'b0;
reg [2:0] r_state;

parameter s_IDLE = 3'b000;
parameter s_start_bit = 3'b001 ;
parameter s_data_bit = 3'b010;
parameter s_stop_bit = 3'b011;
parameter s_cleanup = 3'b100;


always @( posedge i_clk)
begin
    r_rx_data_0<= i_rx_serial;
    r_rx_data_1<= r_rx_data_0;
end

always@( posedge i_clk)
begin
    case(r_state)
    
        s_IDLE:
        begin 
          
            o_rx_dv <= 1'b0;
        r_clock_count <= 0;
        r_rx_bit <= 0;

            if (r_rx_data_1 == 1'b1  )
            begin
            r_clock_count<= 0;
            r_state <= s_IDLE;
            end

            else
            r_state <= s_start_bit;
        end

        s_start_bit:
        begin
            if ( r_clock_count ==  (clk_per_bit -1)/2 )
             begin 
               if( r_rx_data_1 == 1'b0)
               begin
               r_clock_count<=0;
               r_state<= s_data_bit;
               end

               else
               begin
               r_clock_count<=1'b0;
               r_state<= s_IDLE;
             end
             end

             else
             begin
             r_clock_count<= r_clock_count+1;
             r_state<= s_start_bit;
             end

        end
    



        s_data_bit:
        begin 
            if ( r_clock_count< clk_per_bit - 1)
            begin
                r_clock_count <= r_clock_count+1;
                r_state<= s_data_bit;

            end

            else
            begin
                r_clock_count <= 0;
                r_rx_byte [r_rx_bit]<= r_rx_data_1;

                if ( r_rx_bit< 7)
                begin 
                    r_rx_bit <= r_rx_bit+1;
                    r_state<= s_data_bit;
                end

                else
                begin
                    r_rx_bit<= 1'b0;
                    r_state<= s_stop_bit;
                end
            end
        end

        s_stop_bit:
        begin 
            if ( r_clock_count < clk_per_bit - 1)
            begin 
                r_clock_count<= r_clock_count +1;
                r_state<= s_stop_bit;
            end
            else
            begin 
                r_clock_count <= 1'b0;
                o_rx_byte <= r_rx_byte;
                o_rx_dv<= r_rx_byte;
                r_state<= s_cleanup;
                r_rx_dv<= 1'b1;

            end
        end

        s_cleanup:
        begin 
         r_state<= s_IDLE;
         r_rx_dv<= 1'b0;
        end

        default: r_state<= s_IDLE;
    
    endcase

  end
endmodule



















