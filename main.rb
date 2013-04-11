#  main.rb
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


require './brazler.rb'
require './operations.rb'
require './parser.rb'
require './stack.rb'
$erro = 0
$assembly = []
code = Parser.parse_file('brazler_code.txt')

operations = Brazler.get_operations(code)

assembly = Operations.translate(operations)
if $erro == 0
File.open("out.asm", 'w+') {|f| f.write(assembly) }
puts ("Deu certo!!")
else
puts (" #{$erro} erro(s)")
puts ("Deu errado!!")
end
