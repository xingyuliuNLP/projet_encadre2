# coding: utf-8
# --------BAO3 Version: Python-RegEx----------------
# Le programme prend en entrée :
# 1. le nom du fichier de sortie Talismane issu de BAO2
# 2. le patron cible
# Le programme construit en sortie :
# 1. un fichier texte brut avec des formes classees et triees
# Ce script est lancé de la manière suivante
# python3 BAO3.py
# >>> nomDufichier
# >>> NOM/ADJ
# ---------------------------------------

from re import findall

# ex. sortie_talismane_3208
filename = input('Saisissez un fichier de sortie Talismane:\n> ')
# ex. NOM/ADJ 
patterns = input('Saisissez les patrons (séparés par un /):\n> ')

# on récupère les patrons saisis
patterns_list_input = patterns.split('/')
# on nettoie les saisies pour corriger les potentielles erreurs de frappe
patterns_list = list(map(lambda x: findall(r'\w+', x), patterns_list_input))

# on initialise les deux dictionnaires
patterns_dico = {}
patrons_dico = {}

for pattern in patterns_list:
    patrons_dico[' '.join(pattern)] = []
    try:
        # s'il existe déjà un patron qui commence par le même POS tag, on met à jour la liste
        patterns_dico[pattern[0]].append(pattern)
    except KeyError:
        # sinon on crée une entrée
        patterns_dico[pattern[0]] = [pattern]

# on récupère le contenu du fichier
with open(filename, 'r', encoding='utf-8', newline='\n') as fichier:
    contenu = fichier.read()

# on sépare les phrases 
sentence_list = contenu.split('\n\n')
sentence_list.pop()

# on traite phrase par phrase
for sentence in sentence_list:
    lines = sentence.split('\n')
    # on filtre les commentaires
    words = list(filter(lambda x: x and x.startswith("#") is False, lines))

    # on ignore les phrases à un token
    if len(words) == 1:
        continue
        
    # on génère les listes de tokens et de tags
    tokens = []
    tags = []
    
    # on lit chaque ligne de tableau et on récupère les champs qui nous intéressent
    for word in words:
        champs = word.split('\t')
        tokens.append(champs[1])
        tags.append(champs[3])
    
    # on parcourt la liste de tags
    for i, tag in enumerate(tags):
        
        # pour chaque tag, on regarde s'il est présent dans la liste des POS tags initiaux des patrons
        if tag in patterns_dico.keys():
            # si oui on récupère les patrons correspondants
            pat_list = patterns_dico[tag]
            
            # pour chaque patron on calcule sa longueur et on choppe une suite de même longueur dans tags 
            for ele in pat_list:
                pat_leng = len(ele)
                
                # si le patron est identique à la suite, on récupère le n-gram et on l'ajoute dans le dictionnaire
                if tags[i:i+pat_leng] == ele:
                    n_gram = ' '.join(tokens[i:i+pat_leng])
                    key = ' '.join(ele)
                    patrons_dico[key].append(n_gram)

# on ouvre le fichier de sortie
with open('sortie_non_trie.txt', 'w', encoding='utf-8', newline='\n') as sortie:
    # on parcourt le dictionnaire
    for pattern, patrons in patrons_dico.items():
        for patron in patrons:
            # on écrit les patrons
            sortie.write(patron + '\n')
					
# on initialise le compteur
# à noter qu'il compte le nombre total des patrons trouvés, sans distinction entre les patterns
countresult = 0

# pour chaque entrée dans patrons_dico
for pattern, patrons in patrons_dico.items():
    # on inisitalise un dictionnaire temporaire
    tmp = {}
    for patron in patrons:
        # on compte le nombre d'occurrences de chaque patron
        try:
            tmp[patron] += 1
        except KeyError:
            tmp[patron] = 1

    # on trie les entrées
    tmplist = sorted(tmp.items(), key=lambda x: x[1], reverse=True)
    # on met à jour le compteur
    countresult += len(patrons)
    # on met à jour le dictionnaire
    patrons_dico[pattern] = tmplist

# on écrit le résultat dans un fichier
with open('sortie_trie.txt', 'w', encoding='utf-8', newline='\n') as sortie:
    sortie.write('{} éléments trouvés\n'.format(countresult))
    for pattern, patrons in patrons_dico.items():
        sortie.write("Type de pattern: {}\n\n".format(pattern))
        tmp = list(map(lambda x: sortie.write("{0}\t{1}\n".format(x[1], x[0])), patrons))
        sortie.write('\n\n')

