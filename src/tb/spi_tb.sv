module spi_tb;
   parameter int clk_rate = 400000;
   time		 period = 1s/clk_rate;

   wire		 sclk;
   wire		 mosi;
   wire		 miso;
   wire		 ss;

   // Read output
   logic [15:0] wr_data = 16'h74;
   logic [15:0] rd_data = 16'h35;


   initial begin
      // Writes
      dut_master.m_write_data(.wr_data(wr_data), .rd_data(rd_data));

      repeat(10) #(period);

      $display("============================");
      $display("======= TEST PASSED! =======");
      $display("============================");
      $finish;
   end


   initial begin
      #(1000*period)

      $display("============================");
      $display("======= TEST FAILED! =======");
      $display("============================");
      $finish;
   end


   // DUTs
   spi_master_bfm #(.clk_polarity(0), .clk_phase(0), .clk_freq(clk_rate)) dut_master(.sclk(sclk), .mosi(mosi), .miso(miso), .ss(ss));
   spi_slave_bfm #(.clk_polarity(0), .clk_phase(0), .clk_freq(clk_rate)) dut_slave(.sclk(sclk), .mosi(mosi), .miso(miso), .ss(ss));
endmodule // spi_tb
