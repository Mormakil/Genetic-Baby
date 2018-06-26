require_relative "patient"
require_relative "programme"
require_relative "population"

puts "Hi Master\n"

#on récupère les terminaux, les opérateurs contenus dans les fichiers txt
begin
	operateurs = File.open("operateurs.gb","r")
	if operateurs
      	puts "operateurs.gb opened successfully"

   	end
rescue
		puts "operateurs.gb not found"
end
print Population.operateurs

begin
	terminaux = File.open("terminaux.gb","r")
	if terminaux
      	puts "terminaux.gb opened successfully"

   	end
rescue
		puts "terminaux.gb not found"
end
print Population.terminaux

###################################################################################
#                            Ici on créée                                      ####
# Une base de patients prêts à être passé en paramètre des différents          ####
# programmes composant la population pour évaluer le meilleure d'entre eux     ####
###################################################################################
tabpatient = Patient.lireCsv("patients2.csv")
Population.ecrire_nbpatients(tabpatient.size)
####################################################################################

notredate = Time.now
puts notredate

puts "Nombre de générations ? \n"
Population.ecrire_nbgene

puts "Taille de la population ? \n"
Population.ecrire_taillepopu

mapopulation = Population.new

################ Ici débute le "main" ###############
# On lance l'algo pour obtenir l'alfa programme   ###
# Après "darwinisme"                              ###
#####################################################


#------ Init du Log -------------#

log = File.open("log.txt","a")
	

log.print(notredate)
log.print("\n")
log.print("Nombre de générations maximales : "+ String(Population.nbgene) + " \n")
log.print("Nombre de patients testés à chaque génération : ")
log.print(Population.nbpatients)
log.print("\n")


#------ Fin Init du log ---------#

###################################################
# La population est crée, les patients sont dispos#
# On peut enfin faire tourner et générer des      #
# fonctions. Que la meilleure gagne               #
###################################################

# on génère
# mapopulation.genererPopulation(i,mode,log)

# on fit : penser au multithreading
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