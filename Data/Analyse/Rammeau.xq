declare namespace sparql='http://www.w3.org/2005/sparql-results#';
import module namespace functx = 'http://www.functx.com';


declare function local:getLink($i){
let $url := concat('https://data.bnf.fr/sparql?query=Prefix%20skos:%20%3Chttp://www.w3.org/2004/02/skos/core%23%3E%0ASELECT%20DISTINCT%20?Source%20?Target%20?Label%0AWHERE%20%7B%0A%20%20%09%0A%3C',$i,'%3E%20skos:prefLabel%20?Source;%0A%20skos:related%20?Target.%0A%20?Target%20skos:prefLabel%20?Label%0A%20%0A%7D%20&amp;format=application/xml')
return try{http:send-request(<http:request method='get' timeout='10'/>,$url)//sparql:binding[@name='Target']//text()}catch*{}
};

declare function local:forlink($starter){
  let $starter :=$starter
  return distinct-values(for $i in  $starter
let $add:= local:getLink($i)
return functx:value-union($starter,$add))
};


declare function local:node($starter){
for $i in local:forlink(local:forlink(local:forlink(local:forlink($starter))))
let $url := concat('https://data.bnf.fr/sparql?query=Prefix%20skos:%20%3Chttp://www.w3.org/2004/02/skos/core%23%3E%0ASELECT%20DISTINCT%20?Source%20?Target%20?Label%0AWHERE%20%7B%0A%20%20%09%0A%3C',$i,'%3E%20skos:prefLabel%20?Source;%0A%20skos:related%20?Target.%0A%20?Target%20skos:prefLabel%20?Label%0A%20%0A%7D%20&amp;format=application/xml')
return 
  let $info := http:send-request(<http:request method='get' timeout='10'/>,$url)//sparql:binding[@name='Source']//text()
  
  return concat($i,';',$info[1])
};

declare function local:link($starter){
for $i in local:forlink(local:forlink(local:forlink(local:forlink($starter))))
let $url := concat('https://data.bnf.fr/sparql?query=Prefix%20skos:%20%3Chttp://www.w3.org/2004/02/skos/core%23%3E%0ASELECT%20DISTINCT%20?Source%20?Target%20?Label%0AWHERE%20%7B%0A%20%20%09%0A%3C',$i,'%3E%20skos:prefLabel%20?Source;%0A%20skos:related%20?Target.%0A%20?Target%20skos:prefLabel%20?Label%0A%20%0A%7D%20&amp;format=application/xml')
return 
  let $info := http:send-request(<http:request method='get' timeout='10'/>,$url)//sparql:binding[@name='Target']//text()
  for $p in $info
  return concat($i,';',$p)
};

let $starter :='http://data.bnf.fr/ark:/12148/cb121430454'
return local:link($starter)