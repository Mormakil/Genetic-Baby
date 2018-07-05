################################## Arbres ##########################
#Il n'y a pas d'évaluation stricto sensu de l'arbre.################
#On construit des  chaines de caractères qu'on évalue ensuite#######
####################################################################
require_relative "operateur"
class Tree
     
     attr_accessor :valeur
     
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
          if profondeur == 0
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
          maprofondeur = rand(0..profondeurmax)
          if maprofondeur <= 0
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


monarbredeux = Tree.new(nil)
Tree.genererArbreIncomplet(2,operateurs,terminaux,monarbredeux)
s = monarbredeux.parser
print(s)
puts "\n"
puts(eval(s))



monarbre = Tree.new("+")
puts(monarbre.estFeuille?)
monarbre.ajouterFils("3")
monarbre.ajouterFils("4")
s = monarbre.parser
print(s)
puts "\n"
puts(eval(s))
=end