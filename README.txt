Pourquoi un README en txt et en Français ?
==========================================

Parce que quand j'ai commencé l'info, tant que je ne connaissais pas l'anglais
ça a été quasi impossible d'avoir de la doc, et que j'aimerais encourager les
gens à écrire dans leurs langues.

Et aussi, j'ai installé ma première slackware à 19 ans.

J'ai profité des HOWTO de qualité dans /usr/doc/ en format text, avec 
l'essentiel : le message.

Facile à lire, facile à écrire nécessitant aucun outil pour être lu.

L'idée derrière ce dépôt
========================

Je déteste l'idée du « hello world » comme premier code : il est bourré
de magie qui est faite par des librairies qui font le plus gros du travail.

J'imagine faire un dépôt pour permettre aux gens d'afficher eux même
chaque lettre en comprenant comment marche tout ce qui est le plus important
dans le code :
- que les matrices sont des abstractions (le framebuffer est linéaire) ;
- ouvrir, fermer, écrire, lire, se déplacer, coder, décoder des fichiers ;
- l'importance de la documentation ;
- savoir coder avec le minimum ;
- ouvrir la porte à s'améliorer (ex fb.sh est .... LENT).

Perl5
=====

Je code aussi en python, js, C, tcl/tk ... mais là Perl a un avantage unique.

Vous allez vouloir des aller-retours rapide en mode console entre
ce que vous faîtes et ce que vous coder.

Vous allez peut être vouloir accéder aux docs sans avoir de brouteur web.

perldoc, man perlsyn et autres font de Perl le seul langage utilisable
raisonnablement en console quand on a pas internet sous le nez.


Le Framebuffer
==============

Le framebuffer de linux est un « char device » accessible par /dev/fb0

Son API est simple : on peut se déplacer dans ce périphérique avec une
granularité à l'octet et lire ou écrire des valeurs.

La magie des drivers fait que cette mémoire contigüe est ensuite utilisée
pour actuellement dessiner à l'écran.

Pour l'embarqué surtout quand aucun accélérateur graphique n'est nécessaire
cela présente la possibilité donné qu'on a peu de complexité une manière de
se passer d'une grosse pile graphique pour afficher des choses à l'écran.
Genre, c'est parfait pour un oscilloscope.

Les choses compliquées commencent quand on se pose la question de quoi
écrire dedans.

Des pixels ?

Bien.

La mémoire c'est des pixels, côte à côte, chaque pixel est encodée en
fonction des spécificité de la carte graphique utilisée.

Ça peut être du rouge vert bleu alpha, parfois d'autres espaces de colorimétrie.

Ça dépend du driver, de la carte graphique.

Le futur
========

Comment je vais continuer ce README ?

Déjà en précisant que pour que ça marche 

- que le serveur X exclus l'accès brut à /dev/fb0 donc on ne peut pas faire
  tourner ce code avec un serveur X qui tourne 
  cf https://www.linuxuprising.com/2020/01/how-to-boot-to-console-text-mode-in.html,
- il faut installer la lib slurp de Perl,
- fim une visionneuse d'image en framebuffer qui ne supporte pas tout les ppm
  (portable pixmaps. Faire man ppm)
- convert (image magick) pour contourner le bug
- ffmpeg
- probablement vim (ou emacs, ou joe ...) un éditeur confortable en mode console
- être sûr d'avoir perldoc (debian ADORE casser les distributions de langages)
- bash
- les pages de manuel


Aucune idée, probablement sphinx, peut être du POD ?
Un code de démo pour aider.

vérifiez fb.pl qui écrit dans le framebuffer et en parallèle écrit sur la sortie
standard le résultat en ppm (sans alpha). man ppm

Ensuite afficher fb_out.jpg

snap.pl prend un instantanné d'un framebuffer pour en faire un ppm

snap.sh utilise ffmpeg.

convert2gif.sh a sert à explorer les espaces de colorimétrie en faisant faire
le boulot par ffmpeg

bref ... réinventons le Hello World !

