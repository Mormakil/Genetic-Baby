require_relative "tree"

class Programme
	
	attr_reader :idprogramme
	attr_reader :nbpatientsok
	attr_reader :nbpatientstestes
	attr_reader :arbre
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
		@idprogramme = {"version" => version, "numero" => numero}
	end

	def copie
		programmecopie = Programme.new(@arbre.copieArbre,@idprogramme["version"],@idprogramme["numero"])
		programmecopie.score = @score
		return programmecopie
	end
	
	def generationSpontaneeGrowth(mode,profondeur,operateurs,terminaux)
		@arbre = Tree.new(nil)
		Tree.genererArbreIncomplet(profondeur,operateurs,terminaux,@arbre)
	end
	
	def generationSpontaneeFull(mode,profondeur,operateurs,terminaux)
		@arbre = Tree.new(nil)
		Tree.genererArbreComplet(profondeur,operateurs,terminaux,@arbre)
	end
	
	def generationSpontaneeRamped(mode,profondeur,operateurs,terminaux,i)
		@arbre = Tree.new(nil)
		if ((i % 2) == 0)
			Tree.genererArbreComplet(profondeur,operateurs,terminaux,@arbre)
		else
			Tree.genererArbreIncomplet(profondeur,operateurs,terminaux,@arbre)
		end
	end
	
	def crossmatch(prog2)
		arbretemp = @arbre.copieArbre
		arbretemp2 = prog2.arbre.copieArbre
		s = arbretemp.parser
		s2 = arbretemp2.parser
		print(s)
		print(s2)
		arbretemp.classicCrossover(arbretemp2)
		s = arbretemp.parser
		puts("crossover en " + s)
		prog3 = Programme.new(arbretemp,0, donnerIdNumero)
		return prog3
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
	end

	def evaluerMonPatient(monpatient,monprog)
		#mon prog est une chaine de caractère issue de Tree.parser
		# ceci évite de refaire le parsing de l'arbre pour chaque évaluation de patient
		b = monpatient.get_binding
		resultat = eval(monprog,b)
		return resultat
	end
	
	def EvaluerLesPatients(tabpatient)
		n = (tabpatient.size) - 1
		s = @arbre.parser
		puts(s)
		0.upto n do |i|
			begin
				resultat = evaluerMonPatient(tabpatient[i],s)
			rescue ZeroDivisionError
				resultat = 0
			end
			comparerResultats(resultat,tabpatient[i].resultat)
			@resultats.push(resultat)
			i += 1
			increasePatientTestes
		end
	end
	
	def calculerScore(s)
		b = get_binding
		@score = eval(s,b)
	end
	
	def ecrireFichierResultat(fichier)
		fichier.puts("******************************")
		fichier.puts("Resultat du programme : " + String(@idprogramme["version"]) + "." + String(@idprogramme["numero"]))
		fichier.puts("Fonction : " + @arbre.parser)
		fichier.puts("Score donné par la fonction fitness: " + String(self.score))
	end
	
##############Fin de Classe############
end