#  operations.rb
#  
#  Copyright 2013 Eroneiffson <eroneiffson@eroneiffson-Inspiron-5420>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

class Operations


  def self.translate(operations)
  @@map = self.translations
 # $assembly << ".data"
  @@label_counter = 1
  @@end_operation = []
  @@finalisar_para = false
  @@finalisar_se = false
  @@last_label = []
  @@variaveis=[]
  block = false
  
  
  operations.each_with_index do |o, i|
  
    if o
      case o[:code]
        when :se then self.se(operations, o, i)
      	when :para then self.para(operations, o, i)
      	when :var then self.declarar
      	when :fim then self.finalizar
      	when :escreva then self.imprimir(operations, o, i)
      	when :atribuicao then self.atribuir(operations, o, i)
      	when :algoritmo then self.algoritmo
      	when :seja then self.seja(operations, o, i)
      	when :leia then self.leia(operations, o, i)
      	  
      else $erro = $erro + 1
      puts "Erro codigo nao encontrado: #{o[:code]} em: #{o[:exp]}"
        
      end
    end
  
  # END
  end
  
  $assembly.join("\n")
  
  end
  
  def self.leia(operation, o, i)
    verificador1 = false   
    for j in 0..(@@variaveis.length-1) 
       if (@@variaveis[j] == o[:value1])
         verificador1 = true
       end
    end 

    if (verificador1)
      $assembly << "\t addi $2, $0, 5"
      $assembly << "\t sw $4, #{o[:value1]}"
      $assembly << "\t syscall"
      $assembly << "\t sw $2, #{o[:value1]}"
    else
      $erro += 1
      puts "Variavel nao declarada: #{o[:value1]} em: #{o[:exp]}"  
    end
    
  end
  
  def self.declarar
    $assembly << ".data"
  end
  
   def self.algoritmo
  $assembly << ".text"
  end
  
  
  def self.translations
  {
  op: {
  '<' => 'bge',
  '>' => 'ble',
  '==' => 'bne'
  }
  }
  end
  
  def self.atribuir(operations, o, i)
    verificador2 = false
    for j in 0..(@@variaveis.length-1) 
       if (@@variaveis[j] == o[:value2])
         verificador2 = true
       end
    end 
    
    if (verificador2)
      $assembly << "\t lw $14, #{o[:value1]}"
      $assembly << "\t sw $14, #{o[:value2]}"
    else
      $assembly << "\t addi $14, $0, #{o[:value2]}"
      $assembly << "\t sw $14, #{o[:value1]}"
    end
    
    
  end
  
  def self.seja(operations, o, i)

  $assembly << "\t #{o[:value1]}: .word 0"
  @@variaveis << o[:value1]
 
  end
  
  def self.se(operations, o, i)
    pilha = Stack.saveRegisters(8)
    pilha = Stack.saveRegisters(9)
    # Coment�rio para saber qual a express�o
    $assembly << "\t # #{o[:exp]}"
      # Insere valores nos registradores
    verificador1 = false   
for j in 0..(@@variaveis.length-1) 
   if (@@variaveis[j] == o[:value1])
     verificador1 = true
   end
end 

if (verificador1)
  $assembly << "\t lw $8, #{o[:value1]}"
else
  $assembly << "\t addi $8, $0, #{o[:value1]}"
end

verificador2 = false
for j in 0..(@@variaveis.length-1) 
   if (@@variaveis[j] == o[:value2])
     verificador2 = true
   end
end 

if (verificador2)
  $assembly << "\t lw $9, #{o[:value2]}"
else
  $assembly << "\t addi $9, $0, #{o[:value2]}"
end
    # Condi��o
    # Se true, n�o entrar� no if, pois o teste � feito ao contr�rio
    # Ex: op "se 1 < 2" torna-se "se 1 >= 10"
    $assembly << "\t #{@@map[:op][o[:op]]} $8, $9, lbl#{@@label_counter}" 
    @@last_label << @@label_counter
    @@label_counter += 1
    @@end_operation<<0
   @@finalisar_se = true
  #leituraProximaLinha
  end
  
  def self.finalizar
    no = @@end_operation.size-1
    co = @@last_label.size-1
    
    if @@end_operation.last == 0
    # Label que sera usado para n�o entrar no IF
    pilha = Stack.loadRegisters(8)
    pilha = Stack.loadRegisters(9)
    $assembly << "lbl#{@@last_label.last}:"
    @@end_operation.delete_at(no)
    @@last_label.delete_at(co)
    elsif @@end_operation.last == 1
      # Condi��o
    $assembly << nil
    $assembly << "\t # Enquanto for menor que $11, volta pra lbl#{@@last_label.last}"
    $assembly << "\t ble $10, $11, lbl#{@@last_label.last}"
    pilha = Stack.loadRegisters(11)
    pilha2 = Stack.loadRegisters(10)
    pilha = Stack.loadRegisters(11)
    pilha2 = Stack.loadRegisters(10)
    @@end_operation.delete_at(no)
    @@last_label.delete_at(co)
    end
    @@finalisar_para = false
    @@finalisar_para = false
    
    
  #leituraProximaLinha
  end
  
  def self.imprimir(operations, o, i)
    
  $assembly << nil
  $assembly << "\t # #{o[:exp]}"
  verificador = false 
  for j in 0..(@@variaveis.length-1) 
   if (@@variaveis[j] == o[:value1])
     verificador = true
   end
end 
     
  
  if (!verificador)
  $assembly << "\t addi $4, $0, #{o[:value1]}"
  else
  $assembly << "\t lw $4, #{o[:value1]}"
  end
  
  $assembly << "\t addi $2, $0, 1"
  $assembly << "\t syscall"
 
  #leituraProximaLinha
  end
  
  def self.para(operations, o, i)
    # Coment�rio para saber qual a express�o
    $assembly << "\t # #{o[:exp]}"

    
    # Label de controle do for
    
    
    $assembly << "lbl#{@@label_counter}:"
    pilha = Stack.saveRegisters(10)
    pilha2 = Stack.saveRegisters(11)
    @@label_counter += 1
    @@end_operation << 1
    
  verificador1 = false   
for j in 0..(@@variaveis.length-1) 
   if (@@variaveis[j] == o[:value1])
     verificador1 = true
   end
end 

if (verificador1)
  $assembly << "\t lw $10, #{o[:value1]}"
else
  $assembly << "\t addi $10, $0, #{o[:value1]}"
end

verificador2 = false
for j in 0..(@@variaveis.length-1) 
   if (@@variaveis[j] == o[:value2])
     verificador2 = true
   end
end 

if (verificador2)
  $assembly << "\t lw $11, #{o[:value2]}"
else
  $assembly << "\t addi $11, $0, #{o[:value2]}"
end

    
    $assembly << "lbl#{@@label_counter}:"
    pilha = Stack.saveRegisters(10)
    pilha2 = Stack.saveRegisters(11)
    @@last_label << @@label_counter
    # Insere valores nos registradores
    $assembly << "\t lw $10, 0x#{pilha.to_s(16)}"
    $assembly << "\t lw $11, 0x#{pilha2.to_s(16)}"
  
    # Incremento
    $assembly << nil
    $assembly << "\t # Incremento"
    $assembly << "\t addi $10, $10, 1"
    $assembly << "\t sw $10, #{o[:value1]}"
    
  
    # Incrementa o label para n�o repetir
    @@label_counter += 1
    @@end_operation << 1
    @@finalisar_para = true

  end

end
