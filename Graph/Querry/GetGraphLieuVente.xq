import module namespace graph= 'http://basex.org/modules/graph' at '../Module/Graph.xqm';


declare function local:GetListItem($u){
for $i in $u
  let $b := if ($i//subfield[@code='a'][text()='Vente']) then ($i)
  let $c := $b//subfield[@code='m']/text()
  return $c
};

let $bnf := local:GetListItem(doc("../../FouilleData/Exp1/output.xml")//bnf//record//datafield[@tag='503'])
let $inha := local:GetListItem(doc("../../FouilleData/Exp1/output.xml")//inha//record//datafield[@tag='503'])
let $all := ($bnf,$inha)
let $bnfNUM := local:GetListItem(doc("../../FouilleData/Exp2/output.xml")//datafield[@tag='503'])
 
let $test := array{map{"data":$bnf,"label":'EXP2 bnf',"x":0,"color":'green'},map{"data":$inha,"label":'EXP2 inha',"x":20,"color":'blue'},map{"data":$all,"label":'EXP1 inha+bnf',"x":40,"color":'red'},map{"data":$bnfNUM,"label":'EXP2 bnf',"x":60,"color":'magenta'}}

return graph:GraphBar($test,'Répartition des langues par corpus')