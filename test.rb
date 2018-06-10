require_relative "patient"

puts "Hello World\n"

patient1 = Patient.new(14,80,1)
patient2 = Patient.new(8,50,0)

p=patient1
b = p.get_binding
s = "if (((@age * 1.5 + 45) > @pression) && not(@hepatomegalie)) then 'true'  else 'false' end"
eval(s,b)
resultat = eval(s,b)
puts "pour le patient 1"
puts resultat

p=patient2
b = p.get_binding
resultat = eval(s,b)

puts "pour le patient 2"
puts resultat
