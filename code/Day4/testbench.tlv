\m4_TLV_version 1d: tl-x.org
\SV
m4_include_lib(['https://raw.githubusercontent.com/BalaDhinesh/RISC-V_MYTH_Workshop/master/tlv_lib/risc-v_shell_lib.tlv'])

m4_makerchip_module

\TLV
   // /====================\
   // | Sum 1 to 9 Program |
   // \====================/
   //
   // Regs:
   //  r10 (a0): In: 0, Out: final sum
   //  r12 (a2): 10
   //  r13 (a3): 1..10
   //  r14 (a4): Sum

   // External to function:
   m4_asm(ADD, r10, r0, r0)
   // Function:
   m4_asm(ADD, r14, r10, r0)
   m4_asm(ADDI, r12, r10, 1010)
   m4_asm(ADD, r13, r10, r0)
   // Loop:
   m4_asm(ADD, r14, r13, r14)
   m4_asm(ADDI, r13, r13, 1)
   m4_asm(BLT, r13, r12, 13'b1111111111000)
   m4_asm(ADD, r10, r14, r0)

   m4_define_hier(['M4_IMEM'], M4_NUM_INSTRS)

   |cpu
      @0
         $reset = *reset;
         $pc[31:0] = >>1$reset ? 32'b0 :
                     >>1$taken_br ? >>1$br_tgt_pc :
                     >>1$pc + 32'd4;
         $imem_rd_en = !$reset;
         $imem_rd_addr[M4_IMEM_INDEX_CNT - 1:0] = $pc[M4_IMEM_INDEX_CNT + 1:2];
         $imem_rd_addr[2:0] = $pc[4:2];  // corrected bit range

      @1
         $instr = $imem_rd_data[31:0];
         $is_i_instr = $instr[6:2] ==? 5'b0000x ||
                       $instr[6:2] ==? 5'b001x0 ||
                       $instr[6:2] ==? 5'b11001;
         $is_u_instr = $instr[6:2] ==? 5'b0x101;
         $is_s_instr = $instr[6:2] ==? 5'b0100x;
         $is_r_instr = $instr[6:2] ==? 5'b01011 || 5'b011x0 || 5'b10100;
         $is_j_instr = $instr[6:2] ==? 5'b11011;
         $is_b_instr = $instr[6:2] ==? 5'b11000;

         $imm[31:0] = $is_i_instr ? { {21{$instr[31]}}, $instr[30:20] } :
                      $is_s_instr ? { {21{$instr[31]}}, $instr[30:25], $instr[11:7] } :
                      $is_b_instr ? { {19{$instr[31]}}, $instr[7], $instr[30:25], $instr[11:8], 1'd0 } :
                      $is_u_instr ? { $instr[31], $instr[30:20], $instr[19:12], 12{1'd0} } :
                      $is_j_instr ? { 11{$instr[31]}, $instr[19:12], $instr[20], $instr[30:25], $instr[24:21], 1'd0 };

         $func7_valid = $is_r_instr;
         ?$func7_valid
            $func7[6:0] = $instr[31:25];

         $rs2_valid = $is_r_instr || $is_s_instr || $is_b_instr;
         ?$rs2_valid
            $rs2[4:0] = $instr[24:20];

         $rs1_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         ?$rs1_valid
            $rs1[4:0] = $instr[19:15];

         $func3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         ?$func3_valid
            $func3[2:0] = $instr[14:12];

         $rd_valid = $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
         ?$rd_valid
            $rd[4:0] = $instr[11:7];

         $opcode[6:0] = $instr[6:0];
         $dec_bits[10:0] = { $func7[5], $func3, $opcode };

         $is_beq  = $dec_bits ==? 11'bx_000_1100011;
         $is_bne  = $dec_bits ==? 11'bx_001_1100011;
         $is_blt  = $dec_bits ==? 11'bx_010_1100011;
         $is_bge  = $dec_bits ==? 11'bx_101_1100011;
         $is_bltu = $dec_bits ==? 11'bx_110_1100011;
         $is_bgeu = $dec_bits ==? 11'bx_111_1100011;
         $is_addi = $dec_bits ==? 11'bx_000_0010011;
         $is_add  = $dec_bits ==? 11'b0_000_0110011;

         `BOGUS_USE($is_beq $is_bne $is_blt $is_bge $is_bltu $is_bgeu $is_addi $is_add);

         $rf_rd_en1 = $rs1_valid;
         $rf_rd_en2 = $rs2_valid;
         $rf_rd_index1 = $rs1;
         $rf_rd_index2 = $rs2;

         $src1_value = $rf_rd_data1;
         $src2_value = $rf_rd_data2;

         $result[31:0] = $is_addi ? $src1_value + $imm :
                         $is_add  ? $src1_value + $src2_value :
                         32'bx;

         $rf_wr_en = $rd_valid && $rd != 5'b0;
         $rf_wr_index[4:0] = $rd;
         $rf_wr_data[31:0] = $result;

         $taken_br =
            $is_beq  ? ($src1_value == $src2_value) :
            $is_bne  ? ($src1_value != $src2_value) :
            $is_blt  ? ((($src1_value < $src2_value) ^ ($src1_value[31] != $src2_value[31]))) :
            $is_bge  ? ((($src1_value >= $src2_value) ^ ($src1_value[31] != $src2_value[31]))) :
            $is_bltu ? ($src1_value < $src2_value) :
            $is_bgeu ? ($src1_value >= $src2_value) :
            1'b0;

         $br_tgt_pc[31:0] = $pc + $imm;
         *passed = |cpu/xreg[10]>>5$value == (1+2+3+4+5+6+7+8+9);
   
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   |cpu
      m4+imem(@1)
      m4+rf(@1, @1)  
      m4+cpu_viz(@4)


\SV
endmodule
