require_relative "patient"
require_relative "programme"
require_relative "population"
require_relative "operateur"

puts "Hi Master\n"

#on récupère les terminaux, les opérateurs contenus dans les fichiers txt
Population.ecrire_operateurs(Operateurs.new("operateurs.csv"))
Population.operateurs.afficherValeurs(STDOUT)

Population.ecrire_terminaux(Terminaux.new("terminaux.csv"))
Population.terminaux.afficherValeurs(STDOUT)

###################################################################################
#                            Ici on créée                                      ####
# Une base de patients prêts à être passé en paramètre des différents          ####
# programmes composant la population pour évaluer le meilleure d'entre eux     ####
###################################################################################
tabpatient = Patient.lireCsv("patients4.csv")
Population.ecrire_nbpatients(tabpatient.size)
####################################################################################

notredate = Time.now
puts notredate

puts "Nombre de générations ? \n"
Population.ecrire_nbgene

puts "Score attendu pour l'élu ? \n"
Population.ecrire_scoreelu

puts "Taille de la population ? \n"
Population.ecrire_taillepopu

##ici demander la taille de la fonction fitness
Population.ecrireFonctionFitness("fitness.txt")

mapopulation = Population.new(1)

################ Ici débute le "main" ###############
# On lance l'algo pour obtenir l'alfa programme   ###
# Après "darwinisme"                              ###
#####################################################


#------ Init du Log -------------#

log = File.open("darwin.log","a")
	
notredate = Time.now
log.print(notredate)
log.print("\n")
log.print("Nombre de générations maximales : "+ String(Population.nbgene) + " \n")
log.print("Nombre de patients testés à chaque génération : ")
log.puts(Population.nbpatients)
log.puts("Score attendu pour l'élu : " + String(Population.scoreelu))
Population.operateurs.afficherValeurs(log)
Population.terminaux.afficherValeurs(log)
log.print("\n")


#------ Fin Init du log ---------#

###################################################
# La population est crée, les patients sont dispos#
# On peut enfin faire tourner et générer des      #
# fonctions. Que la meilleure gagne               #
###################################################

# on génère
# mapopulation.genererPopulation(i,mode,log)
mapopulation.premiereGeneration(6,"ramped")

# on fit
while (mapopulation.fitness(tabpatient,log)) do |i|
		
end

# on continue si on n'atteint pas le nombre de générations maximales
# ou si le cut-off de fit est atteint

# while cutoff or geneact < maxgene


#----------- on finit le log ------------------#

log.print("-------------------------------------------------\n")
log.print("                   Fin                           \n")
log.print("-------------------------------------------------\n")

log.close


################################THE END#################################