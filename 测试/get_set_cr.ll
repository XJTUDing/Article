; Tests mapping from get_cr/set_cr intrinsics to instructions
; RUN: llc -mcpu=ask50-rv -o - %s | FileCheck %s


; ModuleID = "test_set_get_cr.c"
source_filename = "test_set_get_cr.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"

; Read from (constant) CSR address: use csrr instruction
; CHECK-LABEL: csrr {{a[0-9]+}}, 1000

; Write register to (constant) CSR address:
; CHECK-LABEL: csrw 1001, {{a[0-9]+}}

; Write (small)  constant to (constant) CSR address:
; CHECK-LABEL: csrwi 1001, 31

; Too big constant to CSRWI address:
; CHECK-LABEL: csrwi 1001, {{a[0-9]+}}

; Read from 280+16*reg (computed) CSR address:
; CHECK-LABEL: csrrx {{a[0-9]+}}, 280, {{a[0-9]+}}

; Write zero to 295+16*reg (computed) CSR address:
; CHECK-LABEL: csrwx 295, {{a[0-9]+}}, zero

; Read from maximum constant address (4095):
; CHECK-LABEL: csrr {{a[0-9]+}}, 4095

; Write to maximum constant address (4095):
; CHECK-LABEL: csrw {{a[0-9]+}}, 4095

; Write to maximum constant address (4095):
; CHECK-LABEL: csrwi 4095,2

; wait valu
; CHECK-LABEL: wait 2

; wait veu
; CHECK-LABEL: wait 1

; wait vfpu
; CHECK-LABEL: wait 0

; light sleep
; CHECK-LABEL: slp 2

; deep sleep
; CHECK-LABEL: slp 3

; Function Attrs: nounwind
define dso_local signext i64 @test_allspark_builtins(i64 %p, i64 %val) local_unnamed_addr #0 {
entry:
	%0 = call i64 @llvm.riscv.get.cr(i64 1000)
	call void @llvm.riscv.set.cr(i64 1001, i64 %val)
	call void @llvm.riscv.set.cr(i64 1001, i64 31)
	call void @llvm.riscv.set.cr(i64 1001, i64 32)
	%mul = shl i64 %p, 4
	%add = add i64 %mul, 280
	%1 = call i64 @llvm.riscv.get.cr(i64 %add)
	%add2 = add i64 %mul, 295
	call void @llvm.riscv.set.cr(i64 %add2, i64 0)
	%2 = call i64 @llvm.riscv.get.cr(i64 4095)
	call void @llvm.riscv.set.cr(i64 4095, i64 %2)
	call void @llvm.riscv.set.cr(i64 4095, i64 2)
	call void @llvm.riscv.wait.valu()
	call void @llvm.riscv.wait.veu()
	call void @llvm.riscv.wait.vfpu()
	call void @llvm.riscv.light.sleep()
	call void @llvm.riscv.deep.sleep()
	ret i64 %2
}

; Function Attr: nounwind
declare i64 @llvm.riscv.get.cr(i64) #1

; Function Attr: nounwind
declare i64 @llvm.riscv.set.cr(i64, i64) #1

attributes #0 = {nounwind}
attributes #1 = {nounwind}

$~/build/bin/llvm-lit get_set_cr.ll
-- Testing: 1 tests, 1 workers --
PASS: LLVM :: CodeGen/RISCV/allspark/get_set_cr.ll (1 of 1)

Testing Time: 0.04s
	Passed: 1