################################## Arbres ##########################
#Il n'y a pas d'évaluation stricto sensu de l'arbre.################
#On construit des  chaines de caractères qu'on évalue ensuite#######
####################################################################
require_relative "operateur"
class Tree
     
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

     def profondeur
          maxp = 0
          if estFeuille?
               0
          else
               0.upto ((nombreFils) -1) do |i|
                    fils = accesFils(i)
                    maxfils = fils.profondeur
                    maxp = [maxp, maxfils].max
               end   
          end
          return (1 + maxp)
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

     def parcoursMainGauche(*arguments)
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
     def Tree.genererArbreComplet(profondeur,operateurs,terminaux,arbre)
          if profondeur == 1
               # prendre au hasard un terminal
               n = rand(0..(terminaux.tableau.size) -1)
               arbre.valeur = String(terminaux.tableau[n].valeur)
               # on est tout à la feuille, on ne relance pas en dessous
          else
               # prendre au hasard un opérateur
               n = rand(0..(operateurs.tableau.size) -1)
               arbre.valeur = operateurs.tableau[n].valeur 
               # et relancer sur deux fils
               profondeur -= 1
               arbre.ajouterFils(nil)
               Tree.genererArbreComplet(profondeur,operateurs,terminaux,arbre.accesFils(0))
               arbre.ajouterFils(nil)
               Tree.genererArbreComplet(profondeur,operateurs,terminaux,arbre.accesFils(1))
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
                    Tree.genererArbreIncomplet(maprofondeur,operateurs,terminaux,arbre.accesFils(i))
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


     def muter(profondeurmax,operateurs,terminaux)

          # Décider de où muter
          ouca = rand(1..nombrelElements)

          # se rendre à l'élément en parcours main gauche
          t = parcoursMainGauche(ouca,nil)
          elt = t[1]
          pos = self.profondeur - elt.profondeur + 1
          # Puis créer une branche à greffer ni trop grande ni trop petite
          profondeurbranche = rand(1..((profondeurmax - pos) + 1))
          i = rand(1..2) # au hasard, branche complete ou incomplete
          branche = Tree.new(nil)
          if ((i % 2) == 0)
               Tree.genererArbreComplet(profondeurbranche,operateurs,terminaux,branche)
          else
               Tree.genererArbreIncomplet(profondeurbranche,operateurs,terminaux,branche)
          end
          # ok, on a une branche prête à être greffée
          # maintenant il faut parcourir l'arbre pour aller se mettre à la profondeur requise
          # et appliquer la greffe
          parcoursMainGauche(ouca,nil,branche)
     end

     def crossover(arbre2) #à revoir. Penser multithreading
          ouca1 = rand(1..nombrelElements)
          ouca2 = rand(1..arbre2.nombrelElements)
          t1 = parcoursMainGauche(ouca1,nil)
          t2 = arbre2.parcoursMainGauche(ouca,nil)
          arbredestination2 = t1[1]
          arbredestination1 = t2[1]
          parcoursMainGauche(ouca1,nil,arbredestination1)
          arbre2.parcoursMainGauche(ouca2,nil,arbredestination2)
     end
    
# ---------- Fin de classe ----------#   
end


=begin
terminaux = [65,1]
operateurs = Operateurs.new("operateurs.csv")
monarbre = Tree.new(nil)
Tree.genererArbreComplet(2,operateurs,terminaux,monarbre)
s = monarbre.parser
print(s)
puts "\n"
puts(eval(s))
=end

operateurs = Operateurs.new('jexistepas')
terminaux = Terminaux.new('jexistepas')

monarbredeux = Tree.new(nil)
Tree.genererArbreComplet(4,operateurs,terminaux,monarbredeux)
t = monarbredeux.nombrelElements
s = monarbredeux.parser
puts("résultats du parsing " + s)
puts("nombres d éléments " + String(t))
puts(eval(s))
puts("la profondeur  " + String(monarbredeux.profondeur))
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
monarbredeux.muter(6,operateurs,terminaux)
s = monarbredeux.parser
prout = monarbredeux.profondeur
puts(s)
puts(prout)
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