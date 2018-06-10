#!/usr/bin/env ruby
require_relative "patient"


#savoir où on est
# initier les bons répertoires

puts Dir.pwd
printf("Bonjour beau gosse\n");

# créer un ensemble de patients random

def agerandom
	rand(14..20)
end

def pressionrandom
	rand(50..110)
end

def hepatorandom
	rand(0..1)
end

i= 0

tabpatient = Array.new(100) 

0.upto 99 do |i|
	tabpatient[i] = Patient.new(agerandom,pressionrandom,hepatorandom)
	i += 1
end
	


# Evaluer cet ensemble de patients random
# Mettre les résultats dans un fichier texte

mafonction = "if (((@age * 1.5 + 45) > @pression) && not(@hepatomegalie)) then 'true'  else 'false' end"

0.upto 99 do |i|
	b = tabpatient[i].get_binding
	resultat = eval(mafonction,b)
	puts resultat
	i += 1
end




