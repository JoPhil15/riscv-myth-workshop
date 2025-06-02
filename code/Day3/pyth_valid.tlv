\m5_TLV_version 1d: tl-x.org
\m5
   
   // ============================================
   // Welcome, new visitors! Try the "Learn" menu.
   // ============================================
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
	`include "sqrt32.v";
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   
   |calc
      ?$valid
         @1
            $a_sq[31:0] = $a * $a;
            $b_sq[31:0] = $b * $b;
         @2
            $c_sq[31:0] = $a_sq + $b_sq;
         @3
            $c[31:0] = sqrt($c_sq);
   
   // Assert these to end simulation (before the cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
