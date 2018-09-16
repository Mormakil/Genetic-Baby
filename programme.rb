require_relative "tree"

class Programme
	
	attr_reader :idprogramme
	attr_reader :nbpatientsok
	attr_reader :nbpatientstestes
	attr_reader :arbre
	attr_reader :erreurrms
	attr_accessor :score
	
	def initialize(arbre,version,numero)
		@arbre = arbre
		@nbpatientstestes = 0
		@nbpatientsok = 0
		@tauxpatientsok = 0.0
		@nbfauxnegatifs = 0
		@nbfauxpositifs = 0
		@resultats = Array.new
		@score = 0.0
		@erreurrms = 0.0 ##optionnel gauss
		@idprogramme = {"version" => version, "numero" => numero}
	end

	def copie
		programmecopie = Programme.new(@arbre.copieArbre,@idprogramme["version"],@idprogramme["numero"])
		programmecopie.score = @score
		return programmecopie
	end
	
	def generationSpontaneeGrowth(profondeur,operateurs,terminaux)
		@arbre = Tree.new(nil)
		Tree.genererArbreIncomplet(profondeur,operateurs,terminaux,@arbre)
	end
	
	def generationSpontaneeFull(profondeur,operateurs,terminaux)
		@arbre = Tree.new(nil)
		Tree.genererArbreComplet(profondeur,operateurs,terminaux,@arbre)
	end
	
	def generationSpontaneeRamped(profondeur,operateurs,terminaux,i)
		@arbre = Tree.new(nil)
		if ((i % 2) == 0)
			Tree.genererArbreComplet(profondeur,operateurs,terminaux,@arbre)
		else
			Tree.genererArbreIncomplet(profondeur,operateurs,terminaux,@arbre)
		end
	end
	
	# crossover de l'arbre actuel et d'un deuxième arbre
	# penser à faire de même avec arbre 2 et arbre actuel 2 arbres =  2 offsprings
	# retourne les 2 nouveaux programmes dans un tableau
	def crossmatch(prog2)
		tab = @arbre.classicCrossover(prog2.arbre)
		prog3 = Programme.new(tab[0],0, donnerIdNumero)
		prog4 = Programme.new(tab[1],0, donnerIdNumero)
		return [prog3,prog4]
	end

	def mutation(profondeur,operateurs,terminaux)
		arbretemp = @arbre.copieArbre
		s = arbretemp.parser
		print(s)
		arbretemp.muter(profondeur,operateurs,terminaux)
		s = arbretemp.parser
		puts("amuté en " + s)
		@arbre = arbretemp.copieArbre
		s = @arbre.parser
		puts(" est devenu " + s)
	end

	def get_binding
		return binding()
	end
	
	def donnerprogramme
		@arbre.parser
	end
	
	def afficherprogramme(sortie)
		sortie.puts(@arbre.parser)
	end
	
	def donnerIdNumero
		@idprogramme[1]
	end

	def donnerIdVersion
		@idprogramme[0]
	end
	
	def ecrireNbPatientsTestes(nbpatient)
		@nbpatientstestes = nbpatient
	end
	
	def increasePatientTestes
		@nbpatientstestes += 1
	end
	
	def increaseFauxNegatifs
		@nbfauxnegatifs += 1
	end
	
	def increaseFauxPositifs
		@nbfauxpositifs += 1
	end
	
	def increasePatientOk
		@nbpatientsok += 1
	end
	
	def calculetauxPatientOk
	#	@tauxpatientsok = (@nbpatientsok / @nbpatientstestes)
	end
	
	def comparerResultats(res,respatient)
		if res == respatient
			increasePatientOk
		else
			if res > respatient #faux positif
				increaseFauxPositifs
			else
				increaseFauxNegatifs
			end
		end
		return (res - respatient)**2 #optionnel run Gauss
	end

###### Applique la fonction créée dans l'arbre sur les paramètres données par le patient #########
	def evaluerMonPatient(monpatient,monprog)
		#mon prog est une chaine de caractère issue de Tree.parser
		# ceci évite de refaire le parsing de l'arbre pour chaque évaluation de patient
		b = monpatient.get_binding
		resultat = eval(monprog,b)
		return resultat
	end

####### Pour chaque patient d'un tableau, applique la fonction, stocke le résultat et affirme si les deux résultats sont égaux ########	
	def EvaluerLesPatients(tabpatient)
		ecartpatient = 0
		n = (tabpatient.size) - 1
		s = @arbre.parser
		puts(s)
		0.upto n do |i|
			begin
				resultat = evaluerMonPatient(tabpatient[i],s)
			rescue ZeroDivisionError
				resultat = 0
			end
			ecartpatient += comparerResultats(resultat,tabpatient[i].resultat)
			@resultats.push(resultat)
			i += 1
			increasePatientTestes
		end
		@erreurrms = Math.sqrt(ecartpatient.to_f / n.to_f) #optionnel run Gauss
	end

####### Permet d'appliquer la fonction fitness au programme et de donner le score du programma ######	
	def calculerScore(s)
		b = get_binding
		@score = eval(s,b)
	end
	
	def ecrireFichierResultat(fichier)
		fichier.puts("******************************")
		fichier.puts("Resultat du programme : " + String(@idprogramme["version"]) + "." + String(@idprogramme["numero"]))
		fichier.puts("Fonction : " + @arbre.parser)
		fichier.puts("Score donné par la fonction fitness: " + String(self.score))
		fichier.puts("******************************")
	end
	
##############Fin de Classe############
end