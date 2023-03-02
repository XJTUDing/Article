; Check DSP Dialect IntrinsicOp ---> LLVM Intrinsic
; RUN : DspCompiler %s -emit=llvm 2>&1 | FileCheck %s --check-prefix=CHECK
-LLVM
; Check DSP Dialect IntrinsicOp ---> LLVM Dialect IntrinsicOp
; RUN : DspCompiler %s -emit=mlir-llvm 2>&1 | FileCheck %s --check-prefix
=CHECK-MLIR 
; CHECK-LLVM: call void @llvm.riscv.light.sleep()
; CHECK-LLVM: call void @llvm.riscv.deep.sleep()
; CHECK-LLVM: call void @llvm.riscv.wait.vfpu()
; CHECK-LLVM: call void @llvm.riscv.wait.veu()
; CHECK-LLVM: call void @llvm.riscv.wait.valu()
; CHECK-LLVM: call i64 @llvm.riscv.get.cr(i64 302)
; CHECK-LLVM: call i64 @llvm.riscv.get.cr(i64 4095)
; CHECK-LLVM: call i64 @llvm.riscv.get.cr({{a[0-9]+}})
; CHECK-LLVM: call void @llvm.riscv.set.cr({{a[0-9]+}}, {{a[0-9]+}})
; CHECK-LLVM: call void @llvm.riscv.set.cr(i64 4095, i64 21)

; CHECK-MLIR: llvm.riscv.light.sleep()
; CHECK-MLIR: llvm.riscv.deep.sleep()
; CHECK-MLIR: llvm.riscv.wait.vfpu()
; CHECK-MLIR: llvm.riscv.wait.veu()
; CHECK-MLIR: llvm.riscv.wait.valu()
; CHECK-MLIR: {{%[0-9]+}} = llvm.riscv.get.cr(302 : i64) : (i64) -> (i64)
; CHECK-MLIR: {{%[0-9]+}} = llvm.riscv.get.cr(4095 : i64) : (i64) -> (i64)
; CHECK-MLIR: {{%[0-9]+}} = llvm.riscv.get.cr({{a[0-9]+}} : i64) : (i64) -> (i64)
; CHECK-MLIR: llvm.riscv.set.cr({{a[0-9]+}} : i64 , {{a[0-9]+}} : i64) : (i64, i64) -> ()
; CHECK-MLIR: llvm.riscv.set.cr(4095 : i64, 21) -> ()

func @main(%arg0 : i64, %arg1 : i64) {
	dsp.light_sleep()
	dsp.deep_sleep()
	dsp.wait_vfpu()
	dsp.wait_veu()
	dsp.wait_valu()
	%0 = dsp.get_cr(302) : (i64) -> i64
	%1 = dsp.get_cr(4095) : (i64) -> i64
	%2 = dsp.get_cr(%arg0) : (i64) -> i64
	dsp.set_cr(%arg0, %arg1) : (i64, i64) -> ()
	dsp.set_cr(4095,21) : (i64, i64) -> ()
	dsp.return 
}


$build/bin/llvm-lit IntrinsicOp.mlir
--Testing: 1 tests, 1 workers --
PASS: MLIR :: Dialect/DSP/IntrinsicOp.mlir (1 of 1)

Testing Time: 0.03s
	Passed:1