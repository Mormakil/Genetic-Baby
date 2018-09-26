require "csv"


#### La minimaliste classe patient ######
class Patient

	
	####### 1 : les attributs, pour lire les données du patient #######
	######## On ne modifie pas le données d'un patient          #######
	attr_reader :age
	attr_reader :poids
	attr_reader :sexe
	attr_reader :gemellite
	attr_reader :cardiopathie
	attr_reader :malfo
	attr_reader :rciu
	attr_reader :outborn
	attr_reader :cure
	attr_reader :cesarienne
	attr_reader :apgar
	attr_reader :amines
	attr_reader :respi
	attr_reader :neuro
	attr_reader :chorio
	attr_reader :crp
	attr_reader :hemoc
	attr_reader :coag
	attr_reader :resultat
	
	def initialize (age,poids,sexe,gemellite,cardiopathie,malfo,rciu,outborn,cure,cesarienne,apgar,amines,respi,neuro,chorio,crp,hemoc,coag,result)
		@age = age
		@poids = poids
		@sexe = sexe
		@gemellite = gemellite
		@cardiopathie = cardiopathie
		@malfo = malfo
		@rciu = rciu
		@outborn = outborn
		@cure = cure
		@cesarienne = cesarienne
		@apgar = apgar
		@amines = amines
		@respi = respi
		@neuro = neuro
		@chorio = chorio
		@crp = crp
		@hemoc = hemoc
		@coag = coag
		@resultat = result
	end
	
	def get_binding
		return binding()	
	end



	####### 2 : méthode de classe pour lire un CSV #######
	############### Prend un chemin en paramètre   #######
	#### et renvoie un tableau de patients         #######
	
	def Patient.lireCsv(chemin)
		
		tabpatient = Array.new
		begin
			puts "Chargement des patients \n"	
			
			CSV.foreach(chemin,{ encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
				monhash = row.to_hash # il est bon, mon hash
				tabpatient.push(Patient.new(monhash[:age],monhash[:poids],monhash[:sexe],monhash[:gemellite],monhash[:cardiopathie],monhash[:malfo],monhash[:rciu],monhash[:outborn],monhash[:cure],monhash[:cesarienne],monhash[:apgar],monhash[:amines],monhash[:respi],monhash[:neuro],monhash[:chorio],monhash[:crp],monhash[:hemoc],monhash[:coag],monhash[:deces]))
			end
			
			puts(chemin)
			puts ".csv opened successfully \n"
			puts "array loaded \n"
		rescue
			print(chemin)
			puts " not found\n"
			puts "we create random patients \n"
			tabpatient = Array.new(100)
			0.upto 99 do |i|
				tabpatient[i] = Patient.new(i,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)
				i += 1
			end
		end
		return tabpatient
	end

end

########## Une sous-classe visant à évaluer le remplissage chez des patients ###########

class Pressionpatient < Patient

	
	####### 1 : les attributs, pour lire les données du patient #######
	######## On ne modifie pas le données d'un patient          #######
	attr_reader :age
	attr_reader :pression
	attr_reader :hepatomegalie
	attr_reader :pressionmin
	
	def initialize (id,age,pression,hepatomegalie,result)
		super
		@age = age
		@pression = pression
		@hepatomegalie = hepatomegalie
		@pressionmin = 45 + pression * 1.5
	end
	
	def existeHepatomegalie
		return (@hepatomegalie == 1)
	end
	
	
	####### 2 : méthode de classe pour lire un CSV #######
	############### Prend un chemin en paramètre   #######
	#### et renvoie un tableau de patients         #######
	
	def agerandom
		rand(14..20)
	end

	def pressionrandom
		rand(50..110)
	end

	def hepatorandom
		rand(0..1)
	end
	
	def Pressionpatient.lireCsv(chemin)
		begin
			puts "on y est \n"
			tabpatient = Array.new
			CSV.foreach(chemin,{ encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
				
				monhash = row.to_hash # il est bon, mon hash
				tabpatient.push(Pressionpatient.new(monhash[:id],monhash[:age],monhash[:pression],monhash[:hepatomegalie],monhash[:resultat]))
				puts(monhash[:age])
			end
			if tabpatient[0] != nil
				puts chemin + " opened successfully"
				puts "array loaded \n"
			end
		rescue
			puts "patients.csv not found\n"
			puts "we create random patients \n"
			tabpatient = Array.new(100)
			0.upto 99 do |i|
				tabpatient[i] = Pressionpatient.new(i,agerandom,pressionrandom,hepatorandom,'true')
				i += 1
			end
		end
		return tabpatient
	end
################ Fin de Classe ##################@
end





#####################Fin de fichier###############@