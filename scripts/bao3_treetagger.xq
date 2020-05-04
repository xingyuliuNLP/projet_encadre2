<corpus>
<patron1>
    {
        for $item in collection("sortie_treetagger_3208.xml")//item
        for $elt in $item//article/element
        let $nextElt := $elt/following-sibling::element[1]
        let $nextElt2 := $elt/following-sibling::element[2]
            where $elt/data[1][contains(text(), "VER")] and $nextElt/data[1][contains(text(), "DET")] and $nextElt2/data[1][contains(text(), "NOM")]
        return
            <item><VERB_DET_NOM>{$elt/data[3]/text(), " ", $nextElt/data[3]/text(), " ", $nextElt2/data[3]/text()}</VERB_DET_NOM></item>
    }
    </patron1>
<patron2>
    {
        for $item in collection("sortie_treetagger_3208.xml")//item
        for $elt in $item//article/element
        let $nextElt := $elt/following-sibling::element[1]
            where $elt/data[1][contains(text(), "NOM")] and $nextElt/data[1][contains(text(), "ADJ")]
        return
            <item><NOM_ADJ>{$elt/data[3]/text(), " ", $nextElt/data[3]/text()}</NOM_ADJ></item>
    }
    </patron2>
</corpus>