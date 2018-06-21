require_relative "patient"
require_relative "programme"
require_relative "programmationgene"


nbgene = 0
taillepopu = 0
nbpatients = 0

def agerandom
	rand(14..20)
end

def pressionrandom
	rand(50..110)
end

def hepatorandom
	rand(0..1)
end


puts "Hi Master\n"

#on récupère les terminaux, les opérateurs contenus dans les fichiers txt

begin
	operateurs = File.open("operateurs.gb","r")
	if operateurs
      	puts "operateurs.gb opened successfully"

   	end
rescue
		puts "operateurs.gb not found"
      	mesoperateurs = ['+','-','<','>','*']
end
print mesoperateurs




begin
	terminaux = File.open("terminaux.gb","r")
	if terminaux
      	puts "terminaux.gb opened successfully"

   	end
rescue
		puts "terminaux.gb not found"
      	mesterminaux = [65,1]
end
print mesterminaux

###################################################################################
#                            Ici on créée                                      ####
# Une base de patients prêts à être passé en paramètre des différents          ####
# programmes composant la population pour évaluer le meilleure d'entre eux     ####
###################################################################################
begin
	patients = File.open("patients.csv","r")
	if patients
      	puts "patients.csv opened successfully"

   	end
rescue
		puts "patients.csv not found\n"
		puts "we create random patients \n"
      	
      	tabpatient = Array.new(100)
      	nbpatients = 100
      	
      	0.upto 99 do |i|
			tabpatient[i] = Patient.new(agerandom,pressionrandom,hepatorandom)
			i += 1
		end
end
####################################################################################

notredate = Time.now
puts notredate

puts "Nombre de générations ? \n"
nbgene = Integer(gets)

puts "Taille de la population ? \n"
taillepopu = Integer(gets)

mapopulation = Population.new(nbpatients,taillepopu,mesterminaux,mesoperateurs,nbgene)

################ Ici débute le "main" ###############
# On lance l'algo pour obtenir l'alfa programme   ###
# Après "darwinisme"                              ###
#####################################################


#------ Init du Log -------------#

log = File.open("log.txt","a")
	

log.print(notredate)
log.print("\n")
log.print("Nombre de générations maximales : "+ String(nbgene) + " \n")
log.print("Nombre de patients testés à chaque génération : ")
log.print(nbpatients)
log.print("\n")


#------ Fin Init du log ---------#

###################################################
# La population est crée, les patients sont dispos#
# On peut enfin faire tourner et générer des      #
# fonctions. Que la meilleure gagne               #
###################################################

# on génère
# mapopulation.genererPopulation(i,mode,log)

# on fit
mapopulation.fitness(tabpatient,nil)

#  on trie
# mapopulation.sort

# on logge
mapopulation.decrirepopulation(log)

# on continue si on n'atteint pas le nombre de générations maximales
# ou si le cut-off de fit est atteint

# while cutoff or geneact < maxgene


#----------- on finit le log ------------------#

log.print(" L'élu est : \n")
# On sauve le meilleur
mapopulation.inscritElu(log)
log.print("-------------------------------------------------\n")
log.print("                   Fin                           \n")
log.print("-------------------------------------------------\n")

log.close


################################THE END#################################