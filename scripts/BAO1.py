# coding: utf-8

# --------BAO1 Version: Python-RegEx----------------
# Le programme prend en entrée :
# 1. le nom du répertoire contenant les fichiers xml à traiter
# 2. le nom de rubrique
# Le programme extrait le texte dans des balises <title> et <description> et construit en sortie :
# 1. un fichier texte brut 
# 2. un fichier xml structuré
# Ce script est lancé de la manière suivante
# python3 BAO1.py repertoire_corpus(./2019) rubrique(cinema)
# ---------------------------------------

# on essaie d'utiliser le moins de bibliotheque possible
import sys, os, re


def nettoyage(s):
    s1 = re.sub("&lt;.+?&gt;", "", s)
    s2 = re.sub("&#38;&#34;", "\"", s1)
    s3 = re.sub("&#38;&#39;", "'", s2)
    s4 = re.sub("\\xa0", " ", s3)
    return s4

def extr_contenu(input):
    with open(input, 'r') as f:
        contenu = f.read()
    # chercher le pattern ciblé
    # "." correspond a n'importe quel caractere grace a l'option re.DOTALL
    pattern = re.compile(r"<item>.*?<title>.+?</title>.+?<description>.+?</description>", re.DOTALL)
    pattern_group = re.compile(r"<title>(.+?)</title>.+?<description>(.+?)</description>", re.DOTALL)
    # la methode findall ne peut pas etre utilisee avec group()
    # mais il est obligatoire de stocker les contenus entre parentheses pour faire correspondre le titre et la description
    list_contenu = re.findall(pattern, contenu)
    # on l'utilise pour faire boucler le processus de recherche
    for item in list_contenu:
        # capturer respectivement le contenu dans les parentheses
        match = re.search(pattern_group, item)
        titre_raw = match.group(1)
        description_raw = match.group(2)
        titre = nettoyage(titre_raw) + '.'
        description = nettoyage(description_raw)
        if titre not in tit_des:
            tit_des[titre] = []
            tit_des[titre].append(description)
        else:
            tit_des[titre].append(description)

def par_rep(nom_rep, rub_code):
    pattern_rub = re.compile(rf'{rub_code}')
    # parcourir le contenu dans ce repertoire
    for i in os.listdir(nom_rep):
        # print(os.path.join(nom_rep,i))
        # s'il existe des repertoire -> entrer et parcourir le contenu dans ce repertoire
        # if os.path.isdir(i):
        if os.path.isdir(os.path.join(nom_rep,i)):
            par_rep(os.path.join(nom_rep,i), rub_code)
        # pour les fichiers, s'il est fichier xml, on extrait le contenu dans les balises title et description
        elif os.path.isfile(os.path.join(nom_rep,i)):
            if os.path.join(nom_rep,i).endswith('.xml') and re.match(pattern_rub, i):
                print(i)
                extr_contenu(os.path.join(nom_rep,i))

def ecrire_txt(contenu_dico, output):
    with open(output, "a") as f:
        for item in contenu_dico.items():
            f.write(item[0] + "\n")
            for des in item[1]:
                f.write(des + "\n")
            f.write("---------------\n")

def ecrire_xml(contenu_dico, output):
    with open(output, "a") as f:
        f.write("<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n")
        f.write("<corpusMonde>\n")
        for item in contenu_dico.items():
            f.write("<item>\n")
            f.write("<titre>" + item[0] + "</titre>\n")
            for des in item[1]:
                f.write("<description>" + des + "</description>\n")
            f.write("</item>\n")
        f.write("</corpusMonde>\n")

def rubiconv(nom): #conversion du nom de rubrique en indicatif chiffré
	corres = {'tout':'0,2-(.*),0|0,57-0,64-823353,0|env_sciences','une':'0,2-3208,1-0,0', 'international':'0,2-3210,1-0,0', 'europe':'0,2-3214,1-0,0', 'societe':'0,2-3224,1-0,0', 'idees':'0,2-3232,1-0,0', 'economie':'0,2-3234,1-0,0', 'actualite-medias':'0,2-3236,1-0,0', 'sport':'0,2-3242,1-0,0', 'planete':'0,2-3244,1-0,0', 'culture':'0,2-3246,1-0,0', 'livres':'0,2-3260,1-0,0', 'cinema':'0,2-3476,1-0,0', 'technologies':'0,2-3546,1-0,0', 'politique':'0,57-0,64-823353,0', 'sciences':'env_sciences'}
	return(corres.get(nom))

if __name__ == "__main__":
    # recevoir 2 arguments dans la ligne de commande
    rep = sys.argv[1]
    rubrique = rubiconv(sys.argv[2])
    # le dictionnaire {titre:[description]} comme variable globale
    tit_des = {}
    # parcourrir le repertoire et extraire le contenu cible dans les fichiers xml
    par_rep(rep, rubrique)
    # ecrire le contenu dans un fichier txt
    ecrire_txt(tit_des, 'sortie_tout.txt')
    # ecrire le contenu dans un fichier xml
    ecrire_xml(tit_des, 'sortie_tout.xml')

