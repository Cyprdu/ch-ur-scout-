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

« Le lion » est généré à partir de `Lion/Le-lion.json` par `sources/lion_gen.py`, qui lit aussi les paroles dans le PDF d'origine `partitions/LE_LION.pdf` (non versionné).
