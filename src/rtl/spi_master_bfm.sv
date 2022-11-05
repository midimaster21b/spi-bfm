module spi_master_bfm(sclk, mosi, miso, ss);
   output logic sclk;
   output logic mosi;
   input  logic miso;
   output logic ss;

   parameter int clk_polarity;
   parameter int clk_phase;
   parameter int clk_freq;

   time		 period = 1s/(clk_freq);

   event	 sample_ev;
   event	 change_ev;

   logic	 int_clk = '0;


   always int_clk <= #(period/2) ~int_clk;


   // Write output data onto the MOSI
   // TODO: Allow variable bit width data to be supplied
   task write_data;
      input [15:0] data;

      begin
	 if(clk_phase == 1) begin
	    @(change_ev);
	 end

	 // Output MSB
	 mosi <= data[$bits(data)-1];

	 // Output the rest of the data on the MOSI line
	 for(int x=$bits(data)-2; x>=0; x--) begin
	    @(change_ev);
	    // Output bit
	    mosi <= data[x];
	 end
      end
   endtask


   // Read data from the MISO
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
	    data <= {data[$bits(data)-2:0], MISO};
	 end
      end
   endtask


   task clock_n_ctrl;
      int num_data_bits;

      begin
	 @(posedge int_clk);
	 ss <= '0;

	 for(int x=0; x<num_data_bits; x++) begin
	    @(posedge int_clk);
	    sclk <= ~sclk;
	    @(negedge int_clk);
	    sclk <= ~sclk;
	 end

	 @(posedge int_clk);
	 @(posedge int_clk);
	 ss <= '1;
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


   // Main master BFM operation
   initial begin
      // Clock initial
      if(clk_polarity == 0) begin
	 sclk <= '0;

      end else begin
	 sclk <= '1;

      end

      ss <= '1;
   end // initial begin


endmodule // spi_master_bfm
