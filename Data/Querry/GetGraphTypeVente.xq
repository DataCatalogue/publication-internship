import module namespace graph= 'http://basex.org/modules/graph' at 'CustomModule/Graph.xqm';


declare function local:GetListItem($u){
for $i in $u
  let $b := if ($i//subfield[@code='a'][text()='Vente']) then ($i)
  let $c := $b//subfield[@code='b']/text()
  return $c
};

let $bnf := local:GetListItem(db:open("Database")/bnf//record//datafield[@tag='503'])
let $inha := local:GetListItem(db:open("Database")/inha//record//datafield[@tag='503'])
let $all := ($bnf,$inha)
let $bnfNUM := local:GetListItem(doc('E:\users\jules\Documents\GitHub\publication-internship\Data2\BnfDataNUM.xml')//datafield[@tag='503'])
 
let $test := array{map{"data":$bnf,"label":'bnf',"x":0,"color":'green'},map{"data":$inha,"label":'inha',"x":20,"color":'blue'},map{"data":$all,"label":'inha+bnf',"x":40,"color":'red'},map{"data":$bnfNUM,"label":'inha+bnf',"x":60,"color":'magenta'}}

return graph:GraphBar($test,'Répartition des types de ventes par corpus')
