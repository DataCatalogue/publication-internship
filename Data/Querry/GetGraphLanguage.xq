import module namespace graph= 'http://basex.org/modules/graph' at 'CustomModule/Graph.xqm';


let $bnf := db:open("Database")/bnf//record//datafield[@tag='101']//subfield[@code='a']/text()
let $inha := db:open("Database")/inha//record//datafield[@tag='101']//subfield[@code='a']/text()
let $all := ($bnf,$inha)
let $bnfNUM := doc('E:\users\jules\Documents\GitHub\publication-internship\Data2\BnfDataNUM.xml')//datafield[@tag='101']//subfield[@code='a']/text()
 
let $test := array{map{"data":$bnf,"label":'bnf',"x":0,"color":'green'},map{"data":$inha,"label":'inha',"x":20,"color":'blue'},map{"data":$all,"label":'inha+bnf',"x":40,"color":'red'},map{"data":$bnfNUM,"label":'inha+bnf',"x":60,"color":'magenta'}}

return graph:GraphBar($test,'Répartition des langues par corpus')