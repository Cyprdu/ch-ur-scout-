# Chants — Chorale Scouts d'Europe Lyon 2026

Site statique pour répéter les chants de la chorale : partitions regravées en PDF et lecteur synchronisé (lecture voix par voix ou toutes ensemble, tempo, métronome, boucle, choix des couplets, paroles surlignées). Chaque chant peut aussi s'écouter avec son **enregistrement original** (copie MP3 dans `chants/<id>/enregistrement.mp3`) : la partition et les paroles suivent le chant.

## Structure

- `index.html` : liste des chants.
- `chant.html?c=<id>` : lecteur (`&mode=video` : directement sur l'enregistrement original).
- `synchro.html` : studio de synchronisation des enregistrements.
- `chants/<id>/` : PDF de la partition, données du lecteur (`data.js`) et, s'il existe, `synchro.json` (enregistrement YouTube calé sur la partition).
- `assets/` : styles, scripts, logo, Tone.js et sons de piano (Salamander Grand Piano, CC BY 3.0).
- `sources/` : sources LilyPond et scripts de génération.

## Publication (GitHub Pages)

Settings → Pages → *Deploy from a branch* → `main` / `(root)`.

## Régénérer les partitions

1. Installer LilyPond 2.24 (si `lilypond` n'est pas dans le PATH, renseigner la variable d'environnement `LILYPOND`) et Python avec `PyMuPDF`.
2. Modifier `sources/<chant>.ly` ou `sources/chants.json` (titre, auteurs, voix, tempo, structure des couplets et reprises `structure`).
3. Lancer `python build.py` depuis `sources/`.

`build.py` grave chaque chant deux fois avec le moteur Cairo : un PDF propre à télécharger, puis une seule mise en page qui produit à la fois le SVG affiché et un PDF annoté (chaque tête de note y porte un lien invisible avec sa voix, son temps et sa hauteur). Les notes rouges du lecteur sont des copies exactes des têtes de notes affichées, placées d'après ces liens.

`chorale.ily` annote aussi chaque syllabe des paroles (voix, couplet, instant, traits d'union et de prolongation, vocalises « _ ») : le lecteur allume la syllabe chantée, en prenant au besoin les paroles de la ligne du dessus quand celle du couplet est vide.

## Synchroniser un enregistrement

Double-cliquer sur `serveur-local.bat` (ou `python sources/studio.py`), puis ouvrir `http://localhost:8000/synchro.html` : choisir le chant et la vidéo YouTube, indiquer les couplets chantés, taper `→` à chaque mesure, à chaque mot ou à chaque note d'un pupitre pendant la lecture, vérifier, corriger dans la frise, puis « Publier » (écrit `chants/<id>/synchro.json` et télécharge l'enregistrement en MP3). La forme d'onde et l'aimant sur les attaques demandent `yt-dlp` et `ffmpeg`.

En mode enregistrement, le lecteur peut jouer une ou plusieurs voix au piano par-dessus l'enregistrement ; chaque voix suit ses propres repères de notes, et deux curseurs (Enreg. / Piano) règlent l'équilibre.
