.data
   i: .word 0
	 a: .word 0
.text
	 addi $2, $0, 5
	 sw $4, i
	 syscall
	 sw $2, i
	 addi $2, $0, 5
	 sw $4, a
	 syscall
	 sw $2, a
	 # para a ate i
lbl1:

	 sw $10, 0x7fffeffc  #salva o $10 na pilha

	 sw $11, 0x7ffff000  #salva o $11 na pilha
	 lw $10, a
	 lw $11, i
lbl2:

	 sw $10, 0x7ffff004  #salva o $10 na pilha

	 sw $11, 0x7ffff008  #salva o $11 na pilha
	 lw $10, 0x7ffff004
	 lw $11, 0x7ffff008

	 # Incremento
	 addi $10, $10, 1
	 sw $10, a

	 # escreva a
	 lw $4, a
	 addi $2, $0, 1
	 syscall

	 # Enquanto for menor que $11, volta pra lbl2
	 ble $10, $11, lbl2

	 lw $11, 0x7ffff008  #carrega o $11 na pilha

	 lw $10, 0x7ffff004  #carrega o $10 na pilha

	 lw $11, 0x7ffff000  #carrega o $11 na pilha

	 lw $10, 0x7fffeffc  #carrega o $10 na pilha
