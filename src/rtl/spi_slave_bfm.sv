module spi_slave_bfm(sclk, mosi, miso, ss);
   input logic sclk;
   input logic mosi;
   inout logic miso;
   input logic ss;

   parameter int clk_polarity;
   parameter int clk_phase;

   event	 sample_ev;
   event	 change_ev;

   logic	 miso_r;
   logic [15:0]  rd_data;

   assign miso = (ss == '1) ? 'Z : miso_r;


   // Write output data onto the MISO
   // TODO: Allow variable bit width data to be supplied
   task write_data;
      input [15:0] data;

      begin
	 if(clk_phase == 1) begin
	    @(change_ev);
	 end

	 // Output MSB
	 miso_r <= data[$bits(data)-1];

	 // Output the rest of the data on the MISO line
	 for(int x=$bits(data)-2; x>=0; x--) begin
	    @(change_ev);
	    // Output bit
	    miso_r <= data[x];
	 end

	 $timeformat(-9, 2, " ns", 20);
	 $display("%t: SPI Slave - Write Data - '%x'", $time, data);

      end
   endtask


   // Read data from the MOSI
   // TODO: Allow variable bit width data to be supplied
   task read_data;
      output [15:0] data;

      begin
	 if(clk_phase == 1) begin
	    @(change_ev);
	 end

	 // Output the rest of the data on the MOSI line
	 for(int x=0; x<$bits(data); x++) begin
	    @(sample_ev);
	    // Read bit
	    data <= {data[$bits(data)-2:0], mosi};
	 end

	 $timeformat(-9, 2, " ns", 20);
	 $display("%t: SPI Slave - Read Data - '%x'", $time, data);
      end
   endtask


   // Sample event
   initial begin
      forever begin
	 if(clk_phase == 0) begin
	    if(clk_polarity == 0) begin
	       @(posedge sclk) ->sample_ev;

	    end else begin
	       @(negedge sclk) ->sample_ev;

	    end
	 end else begin
	    if(clk_polarity == 0) begin
	       @(negedge sclk) ->sample_ev;

	    end else begin
	       @(posedge sclk) ->sample_ev;

	    end
	 end
      end
   end


   // Data change event
   initial begin
      forever begin
	 if(clk_phase == 0) begin
	    if(clk_polarity == 0) begin
	       @(negedge sclk) ->change_ev;

	    end else begin
	       @(posedge sclk) ->change_ev;

	    end
	 end else begin
	    if(clk_polarity == 0) begin
	       @(posedge sclk) ->change_ev;

	    end else begin
	       @(negedge sclk) ->change_ev;

	    end
	 end
      end
   end


   initial begin
      forever begin
	 fork
	    write_data(16'hBABE);
	    read_data(rd_data);
	 join
      end
   end


endmodule // spi_slave_bfm
