import module namespace moremap= 'http://basex.org/modules/moremap' at '../Module/MoreMap.xqm';
import module namespace functx = 'http://www.functx.com';
declare namespace sparql='http://www.w3.org/2005/sparql-results#';

let $bnfNUM := doc('E:\users\jules\Documents\GitHub\publication-internship\Data2\BnfDataNUM.xml')//datafield[@tag='503']


let $data := map:merge(for $i in $bnfNUM
  
  let $b := if ($i//subfield[@code='a'][text()='Vente']) then ($i)
  let $c := $b//subfield[@code='m']/text()
  let $n:= replace(functx:capitalize-first(lower-case($c)),' ','_')
  let $n1 := if(contains($n,'.'))then(substring-before($n, '.'))else($n)
  let $n15:= if(contains($n1,','))then(substring-before($n1, ','))else($n1)
 
  let $c2 := $n15
  group by $n15
  let $cptC2:= count($c2)
  return map{$n15: $cptC2})
  
  
return json:serialize(map:merge(
 for $i in 2 to count(map:keys($data))
   let $label :=map:keys($data)[$i]
   let $url:= concat('https://www.wikidata.org/w/api.php?action=wbsearchentities&amp;search=',encode-for-uri($label),'&amp;language=fr&amp;format=xml')
   let $wikiQ := replace(replace(http:send-request(<http:request method='get' timeout='10'/>,$url)//entity[1]/@title,'title="',''),'"','')
   let $sparqlurl := concat('https://query.wikidata.org/sparql?query=SELECT%20DISTINCT%20%3Flat%20%3Flon%20WHERE%20%7B%0A%20%20wd%3A',$wikiQ,'%20p%3AP625%20_%3Ab65.%0A%20%20_%3Ab65%20psv%3AP625%20_%3Ab64.%0A%20%20_%3Ab64%20wikibase%3AgeoLatitude%20%3Flat%3B%0A%20%20%20%20wikibase%3AgeoLongitude%20%3Flon.%0A%7D')
   let $rslt := http:send-request(<http:request method='get' timeout='10'/>,$sparqlurl)
   let $lat := $rslt//*[@name='lat'][1]//sparql:literal//text()
   let $lon := $rslt//*[@name='lon'][1]//sparql:literal//text()
   return map{$label: map{"count":$data($label), "lat":$lat, "lgn":$lon}}))