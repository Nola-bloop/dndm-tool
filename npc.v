import rand

fn chr_get_appearance() string {
  return rand.element([
    "Porte un bijou qui se remarque bien (boucles d'oreille, colier, diadème, bracelet...)."
    "Porte des piercings."
    "Porte des vêtements bizarres, mais uniques."
    "Porte des vêtements propres et formels."
    "Porte des vêtements déchirés et sales."
    "A une très grosse cicatrice."
    "Manque une dent."
    "Manque un doigt."
    "A une couleur d'yeux unique (possible hétérochromie)."
    "A des tattoos."
    "A une tache de naissance."
    "A une couleur de peau non-naturelle."
    "Est chauve."
    "A les cheveux ou la barbe tressée."
    "A une couleur de cheveux non-naturelle."
    "Cligne nerveusement des yeux."
    "A une forme de nez bizarre."
    "Évaché ou droit (un extrème)."
    "Physiquement magnifique."
    "Physiquement dégeulasse."
  ]) or {""}
}

fn chr_get_abilities() string {
  return rand.element([
    "Physiquement très fort(e)."
    "Très agile ou rapide."
    "(constitution++)."
    "Très studieux(se)."
    "Très perceptif(ve)."
    "Très charismatique."
  ]) or {""} + " " + rand.element([
    "Mauvaise force musculaire."
    "Balbutie ou est gauche."
    "Lent(e) ou juste stupide."
    "Ne comprends pas les blagues, prends tout au premier degré."
    "Une personalité un peu plate."
  ]) or {""}
}

fn chr_get_talents() string {
  return rand.element([
    "Joue d'un instrument."
    "Parle plusieurs langages."
    "Très chanceux(se)."
    "Mémoire parfaite."
    "Très bon(ne) avec les animaux."
    "Très bon(ne) avec les enfants."
    "Très bon(ne) avec les casse-têtes."
    "Très bon(ne) à un jeu."
    "Très bon(ne) à faire des imitations."
    "Dessine très bien."
    "Peinture très bien."
    "Chante très bien."
    "Boit tout le monde en dessous de la table."
    "Maçon expert(e)."
    "Cuisinier expert(e)."
    "Joueur(se) de dart expert(e) ou lance les roches sur l'eau avec plusieurs bonds."
    "Jongleur(se) expert(e)"
    "Acteur(trice) talentueux(euse) et maitre des déguisements."
    "Danceur(euse) hors-pair."
    "Connait le langage des voleurs."
  ]) or {""}
}

fn chr_get_traits() string {
  return rand.element([
    "Argumente beaucoup."
    "Arrogant(e)."
    "Vantard(e)."
    "Rude."
    "Curieux(se)."
    "Amical(e)."
    "Honnête."
    "Gros tempérament."
    "Irritable."
    "Pensif(ve)."
    "Silencieux(se)."
    "Suspect."
  ]) or {""}
}

fn chr_get_mannerism() string {
  return rand.element([
    "Chante de temps en temps. Un sifle, fredonnage, etc."
    "Parle d'une façon particulière. Ex: en rhymes."
    "Voix particulièrement haute."
    "Voix particulièrement basse."
    "Utilise beaucoup de gros mots."
    "Balbutie beaucoup."
    "Énonce beaucoup trop clairement."
    "Parle fort."
    "Chuchotes."
    "Utilises des mots particulièrement longs."
    "Utilises souvent le mauvais mot."
    "Fait tout le temps des blagues, souvent mauvaises."
    "Péssimiste."
    "Tout le temps entrain de gosser après quelque chose."
    "Tout le temps entrain de plisser des yeux."
    "Fixe le décor, ce qui est loin."
    "Tout le temps entrain de manger."
    "Tout le temps entrain de marcher."
    "Tout le temps entrain de faire du bruit avec ses doigts."
    "Tout le temps entrain de ronger ses ongles."
    "Tout le temps entrain de frotter sa barbe ou de rouler ses cheveux."
  ]) or {""}
}

fn chr_get_ideals() string {
  return "Idéaux: " + rand.element([
    //good
    "[+]Beauté"
    "[+]Charité"
    "[+]Greater good"
    "[+]Vie"
    "[+]Respect"
    "[+]Sacrifice de soi"

    //evil
    "[-]Dominer"
    "[-]Avarisme"
    "[-]Pouvoir"
    "[-]Mal physique"
    "[-]Vengeance"
    "[-]Massacre"

    //Neutral 1
    "[N]Balance"
    "[N]Savoir"
    "[N]Vivre et laisser vivre"
    "[N]Modération"
    "[N]Neutralité"
    "[N]Le peuple"
  ]) or {""} + " | " + rand.element([
    //lawful
    "[L]Communeauté"
    "[L]Équité"
    "[L]Honeur"
    "[L]Logique"
    "[L]Responsabilité"
    "[L]Tradition"

    //chaotic
    "[C]Changement"
    "[C]Créativité"
    "[C]Liberté"
    "[C]Indépendance"
    "[C]Sans limite"
    "[C]Caprices"

    //Neutre 2
    "[N]Aspiration"
    "[N]Découvertes"
    "[N]Gloire"
    "[N]Nation"
    "[N]Rédemption"
    "[N]Savoir de soi"
  ]) or {""}
}

fn get_character() string {
  return '${chr_get_appearance()} ${chr_get_abilities()} ${chr_get_talents()} ${chr_get_traits()} ${chr_get_mannerism()} ${chr_get_ideals()}'
}
