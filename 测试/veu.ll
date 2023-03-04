; Check DSP Dialect VEU Operation ---> LLVM Dialect Operation
; RUN : DspCompiler %s -emit=mlir-llvm 2>&1 | FileCheck %s

; Check dsp.veu_set_ctrl0
; CHECK: {{%[0-9]+}} = llvm.riscv.get.cr({{%[0-9]+}} : i64) : (i64) -> (i64)
; CHECK: {{%[0-9]+}} = llvm.shl({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> (i64)
; CHECK: {{%[0-9]+}} = llvm.or({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> (i64)
; CHECK: {{%[0-9]+}} = llvm.and({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> (i64)
; CHECK: {{%[0-9]+}} = llvm.riscv.set.cr({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> ()

; Check dsp.veu_set_ctrl1
; CHECK: {{%[0-9]+}} = llvm.riscv.get.cr({{%[0-9]+}} : i64) : (i64) -> (i64)
; CHECK: {{%[0-9]+}} = llvm.shl({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> (i64)
; CHECK: {{%[0-9]+}} = llvm.or({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> (i64)
; CHECK: {{%[0-9]+}} = llvm.and({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> (i64)
; CHECK: {{%[0-9]+}} = llvm.riscv.set.cr({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> ()

; Check dsp.veu_set_vl
; CHECK: {{%[0-9]+}} = llvm.riscv.set.cr({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> ()

; Check dsp.veu_set_iter
; CHECK: {{%[0-9]+}} = llvm.riscv.set.cr({{%[0-9]+}} : i64, {{%[0-9]+}} : i64) : (i64, i64) -> ()

; CHECK: llvm.inline_asm has_side_effects "vmadd [0].int, [1].int, [2].int", "" : () -> !llvm.void
; CHECK: llvm.inline_asm has_side_effects "vmadd [0].int, [1].int, [2].char", "" : () -> !llvm.void
; CHECK: llvm.inline_asm has_side_effects "vmadd [0].int, [1].char, [2].int", "" : () -> !llvm.void
; CHECK: llvm.inline_asm has_side_effects "vmadd [0].char, [1].int, [2].int", "" : () -> !llvm.void
...
; CHECK: llvm.inline_asm has_side_effects "vmadd [0].char, [1].char, [2].char", "" : () -> !llvm.void
...
; CHECK: llvm.inline_asm has_side_effects "vmadd [0].char, [1].char, [2].char, [3].char", "" : () -> !llvm.void



func @test() {
	dsp.veu_set_ctrl0(0,1,0,0)
	dsp.veu_set_ctrl1(1,1)
	dsp.veu_set_vl(200)
	dsp.veu_set_iter(1)

	dsp.veu_addiii(0,1,2)
	dsp.veu_addiic(0,1,2)
	dsp.veu_addici(0,1,2)
	dsp.veu_addcii(0,1,2)
	...
	dsp.veu_addccc(0,1,2)
	...
	dsp.veu_submulccc(0,1,2,3)

	dsp.return 
}
