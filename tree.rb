################################## Arbres ##########################
#Il n'y a pas d'évaluation stricto sensu de l'arbre.################
#On construit des  chaines de caractères qu'on évalue ensuite#######
####################################################################
require_relative "operateur"
class Tree
     
     PROFONDEURMAXIMALE = 100
     attr_accessor :valeur
     attr_accessor :fils
     
     def initialize(valeur)
          @valeur = valeur  #il n'y a pas d'évaluation stricto sensu de l'arbre. On construit des  chaines de caractères qu'on évalue ensuite
          @fils = nil
     end
     
     def estFeuille?
          @fils == nil
     end
     
     def estRacine?
          @fils != nil
     end
     
     def ajouterFils(valeur)
          f = Tree.new(valeur)
          if (@fils == nil)
               @fils = Array.new
               @fils.push(f)
          else
               @fils.push(f)
          end
     end
     
     def  accesFils(numero)
          @fils[numero]
     end
     
     def nombreFils
          if self.estRacine?
               @fils.size
          else
               0
          end
     end

     # débute à 1, fonctionne
     def profondeur
          maxp = 0
          if estFeuille?
               0
          else
               0.upto ((nombreFils) -1) do |i|
                    lefils = accesFils(i)
                    maxfils = lefils.profondeur
                    maxp = [maxp, maxfils].max
               end   
          end
          return (1 + maxp)
     end

     # On prend très rarement des feuilles et on ne prend jamais l'arbre dans son intégralité
     def hasardProfondeurPonderee(pourcentage,profondeurmax)
          hasard = rand(1..100)
          if ((hasard > pourcentage) or (profondeurmax < 3))
               return 1
          else
               tbloc = pourcentage/(profondeurmax - 2)
               return ((hasard / tbloc) + 2) 
          end
     end

     # retoune au hasard un sous-arbre de profondeur donnée
     def noeudProfondeurPonderee(pourcentage)
          prof = profondeur
          prof = hasardProfondeurPonderee(pourcentage,prof)
          tableau = Array.new
          remplirSousArbreProfondeurParcoursMainGauche(prof,tableau)
          taille = ((tableau.size) - 1)
          hasard = rand(0..taille)
          return (tableau[hasard])
     end

     def remplirSousArbreProfondeurParcoursMainGauche(notreprofondeur,tableau)
          prof = self.profondeur
          if (prof == notreprofondeur)
               #tableau.push(self.copieArbre)
               tableau.push(self)
          else
               0.upto ((nombreFils) -1) do |i|
                    lefils = accesFils(i)
                    lefils.remplirSousArbreProfondeurParcoursMainGauche(notreprofondeur,tableau)
               end   
          end
     end

     def nombrelElements
          if self.estFeuille?
               return 1
          else
               n = nombreFils - 1
               m = 1
               0.upto n do |i|
                    m = m + (@fils[i].nombrelElements)
               end
               return m
          end
     end

     def copieArbre
          t = Tree.new(self.valeur)

          if estFeuille?
               return t
          else
               t.fils = Array.new
               0.upto ((fils.size) - 1) do |i|
                    t.fils.push(@fils[i].copieArbre)
               end
               return t
          end
     end

     def rechercherEtRemplacerNoeud(ad1,ad2)
          0.upto ((nombreFils) -1) do |i|
              # lefils = accesFils(i)
               if (@fils[i] == ad1)
                    @fils[i] = ad2.copieArbre
                    puts(@fils[i].parser)
                    i = nombreFils
               else
                    @fils[i].rechercherEtRemplacerNoeud(ad1,ad2)
               end
          end
     end
     
     def parcoursMainGauche(*arguments) #0 position dans l'arbre,#1 l'element recherché, #2 ce que l'on souhaite mettre a la place
          begin
               arguments[0] -=1
               if (arguments[0] == 0)
                    if (arguments.size == 2)
                         # code pour retourner le nimeme élément
                         return  [0,self]
                    else
                         # code pour aller remplacer au nieme element
                         elt = self
                         self.valeur = arguments[2].valeur
                         self.fils = arguments[2].fils
                         return [0,elt]
                    end
               else
                    #je lance une nouvelle itération jusqu'à trouver le nieme élément
                    n = nombreFils
                    i = 0
                     
                    # code pour retourner le nimeme élément
                    while ((i < n) & (arguments[0] >= 1)) do
                         if (arguments.size == 2)
                              t = @fils[i].parcoursMainGauche(arguments[0],arguments[1])
                              arguments[0] = t[0]
                              arguments[1] = t[1]
                         else
                              t = @fils[i].parcoursMainGauche(arguments[0],arguments[1],arguments[2])
                              arguments[0] = t[0]
                              arguments[1] = t[1]
                         end
                         i += 1
                    end
                    return[arguments[0],arguments[1]]
               end
               
          rescue   
               puts "problème d'argument"
               return self
          end
     end

     def parser
          n = self.nombreFils
          case n
          when 0 #on est sur une feuille
               self.valeur
          when 1 #cas de la négativisation de valeur
               self.valeur + @fils[0].parser 
          when 2 #comparaison, opérations arithmétiques ... il faut blinder avec les parenthèses
               "(" + @fils[0].parser + self.valeur + @fils[1].parser + ")"
          when 3 #cas du if then else principalement (à écrire)
          "You passed a string"
          else
          "You gave me #{x} -- I have no idea what to do with that."
          end
     end
     
     
     # pour l'instant génère un arbre binaire. réfléchir aux terminaux et modifier en conséquence
     # ici la profondeur est fixe i.e si au début donnée à 2 finira à 2
     # donc si on veut une profondeur au hasard, randomiser profondeur lors de l'appel de la méthode
     def Tree.genererArbreComplet(maprofondeur,operateurs,terminaux,arbre)
          if maprofondeur == 1
               # prendre au hasard un terminal
               n = rand(0..(terminaux.tableau.size) -1)
               arbre.valeur = String(terminaux.tableau[n].valeur)
               # on est tout à la feuille, on ne relance pas en dessous
          else
               # prendre au hasard un opérateur
               n = rand(0..(operateurs.tableau.size) -1)
               arbre.valeur = operateurs.tableau[n].valeur 
               # et relancer sur deux fils
               maprofondeur -= 1
               arbre.ajouterFils(nil)
               Tree.genererArbreComplet(maprofondeur,operateurs,terminaux,arbre.accesFils(0))
               arbre.ajouterFils(nil)
               Tree.genererArbreComplet(maprofondeur,operateurs,terminaux,arbre.accesFils(1))
          end
     end
     
     # on donne une profondeur max ... mais pas sur qu'elle soit atteinte
     def Tree.genererArbreIncomplet(profondeurmax,operateurs,terminaux,arbre)
          maprofondeur = rand(1..profondeurmax)
          if maprofondeur <= 1
               # prendre au hasard un terminal
               n = rand(0..(terminaux.tableau.size) -1)
               arbre.valeur = String(terminaux.tableau[n].valeur)
               # on est tout à la feuille, on ne relance pas en dessous
          else
               # prendre au hasard un opérateur
               # vérifier l'application de l'opérateur
               n = rand(0..(operateurs.tableau.size) -1)
               arbre.valeur = operateurs.tableau[n].valeur 
               # et relancer sur un, deux ou trois fils
               maprofondeur -= 1
               case operateurs.tableau[n].combien
               when 1
                    arbre.ajouterFils(nil)
                    Tree.genererArbreIncomplet(maprofondeur,operateurs,terminaux,arbre.accesFils(0))
               when 2
                    arbre.ajouterFils(nil)
                    arbre.ajouterFils(nil)
                    Tree.genererArbreIncomplet(maprofondeur,operateurs,terminaux,arbre.accesFils(0))
                    Tree.genererArbreIncomplet(maprofondeur,operateurs,terminaux,arbre.accesFils(1))
               when 3
                    0.upto(rand(0..1)) do |i|
                         arbre.ajouterFils(nil)
                         Tree.genererArbreIncomplet(maprofondeur,operateurs,terminaux,arbre.accesFils(i))
                    end
               else
                    raise "Le masque sur le nombre d'opérandes que prend l'opérateur n'est pas défini"
               end
          end
     end


# profondeur initiale = profondeur max de la mutation
# et puis on donne les opérateurs et les terminaux
     def muter(profondeurinitiale, operateurs, terminaux)
          profarbre = self.profondeur
          
          # déterminer à quelle profondeur on greffera en respectant la profondeur de l'arbre
          haut = profarbre
          bas = 1
          temp = PROFONDEURMAXIMALE - profarbre 
          if (temp <= profondeurinitiale)
               bas = temp
               proftaillechoisie = rand(1..temp)
          else
               bas = 1
               proftaillechoisie = rand(1..profondeurinitiale)
          end

          profougreffer = rand(bas..haut)
          
          #déterminer au hasard le type d'arbre qui sied à la mutation
          i = rand(1..2)
          nouvellemutation = Tree.new(nil)
          if ((i % 2) == 0)
               Tree.genererArbreComplet(proftaillechoisie,operateurs,terminaux,nouvellemutation)
          else
               Tree.genererArbreIncomplet(proftaillechoisie,operateurs,terminaux,nouvellemutation)
          end
          
          #prendre un noeud au hasard à cette profondeur
          tableaunoeud = Array.new()
          remplirSousArbreProfondeurParcoursMainGauche(profougreffer,tableaunoeud)
          taille = ((tableaunoeud.size) - 1)
          hasard = rand(0..taille)
          noeuddetermine = tableaunoeud[hasard]
          
          #remplacer ce noeud par celui créer lors de la mutation.
          rechercherEtRemplacerNoeud(noeuddetermine,nouvellemutation)
     end

     # problème ici
     # 1) s'assurer du crossover sur un noeud
     # 2) s'assurer que la porfondeur ne sera pas trop profonde
     # 3) 2 parents = 2 enfant = 1 point de crossover
     # copie arbre : la fonction fonctionne

     def classicCrossover(arbre2) #Penser multithreading
          # Je fais une copie de mes arbres
          copiearbre2 = arbre2.copieArbre
          copiearbre1 = self.copieArbre
     
          #Extraction de deux sous-arbres de profondeur prise au hasard
          sousarbre2 = copiearbre2.noeudProfondeurPonderee(80) #pourcentage : 80
          sousarbre1 = copiearbre1.noeudProfondeurPonderee(80) #pourcentage : 80
          # swap des adresses
          copiearbre2.rechercherEtRemplacerNoeud(sousarbre2,sousarbre1)
          copiearbre1.rechercherEtRemplacerNoeud(sousarbre1,sousarbre2)
          tableau = Array.new
          tableau.push(copiearbre1)
          tableau.push(copiearbre2)
          return tableau
     end
    
# ---------- Fin de classe ----------#   
end

=begin
operateurs = Operateurs.new('jexistepas')
terminaux = Terminaux.new('jexistepas')

monarbre = Tree.new(nil)
Tree.genererArbreIncomplet(4,operateurs,terminaux,monarbre)
t = monarbre.nombrelElements
s = monarbre.parser
puts("résultats du parsing arbre 1 : " + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbre.profondeur))

monarbre.muter(4,operateurs,terminaux)
s = monarbre.parser
prout = monarbre.profondeur
puts(s)
puts(prout)
=begin
monarbredeux = Tree.new(nil)
Tree.genererArbreComplet(4,operateurs,terminaux,monarbredeux)
t = monarbredeux.nombrelElements
s = monarbredeux.parser
puts("résultats du parsing arbre 2 : " + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbredeux.profondeur))

tab = monarbre.classicCrossover(monarbredeux)

monarbretrois = tab[0]
t = monarbretrois.nombrelElements
s = monarbretrois.parser
puts("résultats du parsing arbre 3 : " + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbretrois.profondeur))

monarbrecinq = tab[1]
t = monarbrecinq.nombrelElements
s = monarbrecinq.parser
puts("résultats du parsing arbre 5 : " + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbrecinq.profondeur))

monarbresix = monarbre.noeudProfondeurPonderee(80)
t = monarbresix.nombrelElements
s = monarbresix.parser
puts("résultats du parsing arbre 6 : " + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbresix.profondeur))
monarbresix.valeur = "+"
s = monarbre.parser
puts("résultats du parsing arbre 1 : " + s)

monarbrecinq = monarbresix
t = monarbrecinq.nombrelElements
s = monarbrecinq.parser
puts("résultats du parsing arbre 5 : " + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbrecinq.profondeur))

monarbrequatre = monarbretrois.copieArbre
t = monarbrequatre.nombrelElements
s = monarbrequatre.parser
puts("résultats du parsing arbre 4" + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbrequatre.profondeur))

t = monarbredeux.nombrelElements
s = monarbredeux.parser
puts("résultats du parsing arbre 2" + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbredeux.profondeur))

t = monarbre.nombrelElements
s = monarbre.parser
puts("résultats du parsing arbre 1" + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbre.profondeur))
=end
=begin
monarbredeux.parcoursMainGauche(3,nil)
monarbredeux.parcoursMainGauche(7,nil)
monarbretrois = Tree.new(nil)
Tree.genererArbreIncomplet(3,operateurs,terminaux,monarbretrois)
t = monarbretrois.nombrelElements
s = monarbretrois.parser
puts("résultats du parsing " + s)
puts("nombres d éléments " + String(t))
monarbredeux.parcoursMainGauche(3,nil,monarbretrois)
t = monarbredeux.nombrelElements
s = monarbredeux.parser
puts("résultats du parsing " + s)
puts("nombres d éléments " + String(t))
 #puts(x.valeur)
=end
=begin

=end
=begin
monarbre = Tree.new("+")
puts(monarbre.estFeuille?)
monarbre.ajouterFils("3")
monarbre.ajouterFils("4")
s = monarbre.parser
print(s)
puts "\n"
puts(eval(s))
=end