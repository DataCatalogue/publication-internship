import module namespace graph= 'http://basex.org/modules/graph' at 'CustomModule/Graph.xqm';

let $node := ('Jules','Julien','Janine','Jean','Julie','Jordan','Jeanne')
let $link := array{map{'source':'Jules','target':'Janine'},map{'source':'Jules','target':'Julien'},map{'source':'Jean','target':'Julie'},map{'source':'Julie','target':'Janine'},map{'source':'Jules','target':'Julie'},map{'source':'Jules','target':'Jean'},map{'source':'Jules','target':'Jeanne'}}

return graph:GraphCircularNetwork($node,$link,300,500,500)