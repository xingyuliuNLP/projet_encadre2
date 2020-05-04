<corpus>
    (: nom propre + verb + det + nom commun :)
    <patron_NVDN>
        {
            for $p in collection("sortieTalismane-3208.xml")//p
            for $item in $p//item
            let $nextitem := $item/following-sibling::item[1]
            let $nextitem2 := $item/following-sibling::item[2]
            let $nextitem3 := $item/following-sibling::item[3]
                
                where $item/a[4]/text()[matches(., "NPP")] and $nextitem/a[4]/text()[matches(., "V")] and $nextitem2/a[4]/text()[matches(., "DET")] and $nextitem3/a[4]/text()[matches(., "NC")]
            return
                <NP_V_DET_NC>{$item/a[2]/text(), " ", $nextitem/a[2]/text(), " ", $nextitem2/a[2]/text(), " ", $nextitem3/a[2]/text()}</NP_V_DET_NC>
        }
    </patron_NVDN>
    (: nom commun + prep + nom commun :)
    <patron_NPN>
        {
            for $p in collection("sortieTalismane-3208.xml")//p
            for $item in $p//item
            let $nextitem := $item/following-sibling::item[1]
            let $nextitem2 := $item/following-sibling::item[2]
                where $item/a[4]/text()[matches(., "NC")] and $nextitem/a[4]/text()[matches(., "^P$")] and $nextitem2/a[4]/text()[matches(., "NC")]
            return
                <NC_PREP_NC>{$item/a[2]/text(), " ", $nextitem/a[2]/text(), " ", $nextitem2/a[2]/text()}</NC_PREP_NC>
        }
    </patron_NPN>
    (: nom commun + adj :)
    <patron_NA>
        {
            for $p in collection("sortieTalismane-3208.xml")//p
            for $item in $p//item
            let $nextitem := $item/following-sibling::item[1]
                where $item/a[4][contains(text(), "NC")] and $nextitem/a[4][contains(text(), "ADJ")]
            return
                <NOM_ADJ>{concat($item/a[2]/text(), " ", $nextitem/a[2]/text())}</NOM_ADJ>
        }
    </patron_NA>

</corpus>