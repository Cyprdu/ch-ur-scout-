# Chants — Chorale Scouts d'Europe Lyon 2026

Site statique pour répéter les chants de la chorale : partitions regravées en PDF et lecteur synchronisé (lecture voix par voix ou toutes ensemble, tempo, métronome, boucle).

## Structure

- `index.html` : liste des chants.
- `chant.html?c=<id>` : lecteur.
- `chants/<id>/` : PDF de la partition et données du lecteur (`data.js`).
- `assets/` : styles, scripts, logo, Tone.js et sons de piano (Salamander Grand Piano, CC BY 3.0).
- `sources/` : sources LilyPond et scripts de génération.

## Publication (GitHub Pages)

Settings → Pages → *Deploy from a branch* → `main` / `(root)`.

## Régénérer les partitions

1. Installer LilyPond 2.24 (si `lilypond` n'est pas dans le PATH, renseigner la variable d'environnement `LILYPOND`) et Python avec `PyMuPDF`.
2. Modifier `sources/<chant>.ly` ou `sources/chants.json` (titre, auteurs, voix, tempo, ordre de lecture `order` pour les reprises).
3. Lancer `python build.py` depuis `sources/`.

`build.py` grave chaque chant deux fois avec le moteur Cairo : un PDF propre à télécharger, puis une seule mise en page qui produit à la fois le SVG affiché et un PDF annoté (chaque tête de note y porte un lien invisible avec sa voix, son temps et sa hauteur). Les notes rouges du lecteur sont des copies exactes des têtes de notes affichées, placées d'après ces liens.
