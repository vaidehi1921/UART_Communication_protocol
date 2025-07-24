
module uart_rx_tb();
  
  reg i_rx_serial =1'b1;
  reg i_clk= 0;
  wire o_rx_dv;
  wire [7:0]o_rx_byte;
  
  uart_rx #(.clk_per_bit (87)) uut( .i_rx_serial(i_rx_serial), .i_clk(i_clk) , .o_rx_dv(o_rx_dv) , .o_rx_byte(o_rx_byte));
                                 
always #5 i_clk = ~i_clk;
                                   
 initial 
   begin 
     $dumpfile( "uart_rx_tb.vcd");
     $dumpvars(0, uart_rx_tb);
 
                                 
#100;
     i_rx_serial =  0  ;
     #(87*10);
     
    i_rx_serial = 1; #(87 * 10);  // Bit 0
    i_rx_serial = 0; #(87 * 10);  // Bit 1
    i_rx_serial = 1; #(87 * 10);  // Bit 2
    i_rx_serial = 0; #(87 * 10);  // Bit 3
    i_rx_serial = 0; #(87 * 10);  // Bit 4
    i_rx_serial = 1; #(87 * 10);  // Bit 5
    i_rx_serial = 0; #(87 * 10);  // Bit 6
    i_rx_serial = 1; #(87 * 10);  // Bit 7
                 
     i_rx_serial = 1;
     #(87*10);
    
#1000;
     $finish;
   end
  
  initial begin 
    $monitor("Time=%0t | rx_serial=%b | rx_dv=%b | rx_byte=0x%h",
           $time, i_rx_serial, o_rx_dv, o_rx_byte);
  end
                                 
  endmodule
                