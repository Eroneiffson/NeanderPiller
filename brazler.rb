#  brazler.rb
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


module Brazler

def self.get_operations(code_lines)
operacoes = []


code_lines.each do |line|
code = self.get_operation(line)
if code != nil
operacoes << code
else 
$erro = $erro + 1
puts "Erro brazler.rb[31]: operation line == nil"
end
end


operacoes
end


private

def self.get_operation(text)
operations = self.operations

operations.each do |code, regex|
vars = regex.match(text)

next if vars == nil

return case code
when :se then {code: code, value1: vars[1], op: vars[2], value2: vars[3], exp: vars[0]}
when :para then {code: code, value1: vars[1], value2: vars[2], exp: vars[0]}
when :seja then {code: code, value1: vars[1], exp: vars[0]}
when :fim then {code: code, exp: vars[0]}
when :escreva then {code: code, value1: vars[1], exp: vars[0]}
when :atribuicao then {code: code, value1: vars[1], value2: vars[2], exp: vars[0]}
when :var_com_atribuicao then {code: code, exp: vars[0]}
when :algoritmo then {code: code, exp: vars[0]}
when :var then {code: code, exp: vars[0]}
when :leia then {code: code, value1: vars[1], exp: vars[0]}

# DEBUG
else puts ("Code: #{code} ; Text: #{text} ; Regex: #{regex}")
end

end

return nil
end

# só está aceitando numeros como valores
# declaração de variavel apenas do tipo inteiro
def self.operations
{
:se => /^se\s+(\d+|\w)\s*(<|>|==)\s*(\d+|\w)\s+(entao)$/i,
:para => /^para\s+(\d+|\w)\s+ate\s+(\d+|\w)$/i,
:seja => /^seja\s+(\w)$/,
:atribuicao => /^(\w)\s*\=\s*(\d+|\w)$/,
:var_com_atribuicao => /^int\s+(\w)\s*\=\s*(\d+)$/,
:escreva => /^escreva\s+(\d+|\w)$/,
:algoritmo => /^algoritmo$/,
:fim => /^fim$/,
:var => /^var$/,
:leia => /^leia\s+(\w)$/
}
end

end
