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

tabpatient = Array.new(100) { |i|
	tabpatient[i] = Patient.new(agerandom,pressionrandom,hepatorandom)  }


# Evaluer cet ensemble de patients random
# Mettre les résultats dans un fichier texte

def mafonction

0.upto 99 do |i|
	b = tabpatient[i].get_binding
	resultat = eval(mafonction,b)
	puts resultat
end

print patientcourant.quelage
print '\n'
commande = File.open('fonction.txt').gets
print(eval(commande))


