#!/usr/bin/env ruby
require_relative "patient"

puts Dir.pwd
printf("Bonjour beau gosse\n");

patientcourant = Patient.new(14,65,false)
print patientcourant.quelage
print '\n'
commande = File.open('fonction.txt').gets
print(eval(commande))


