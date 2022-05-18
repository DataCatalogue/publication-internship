import module namespace functx = 'http://www.functx.com';
import module namespace graph= 'http://basex.org/modules/graph' at '../Module/Graph.xqm';


declare function local:GetListItem($u,$value){
for $i in $u
  let $c := $i//subfield[@code='j'][1]/text()
  let $d := number(functx:get-matches($c,"[0-9]{4}")[1])
  let $s := if (functx:is-a-number($d)= true()) then ( $d)
  return if($i//subfield[@code='b']/text()=$value)then($s)
};

declare function local:TypeVente($u){
for $i in $u
  let $b := if ($i//subfield[@code='a'][text()='Vente']) then ($i)
  let $c := $b//subfield[@code='b']/text()
  return $c
};
let $bnfNUM := doc('../../FouilleData/Exp2/output.xml')//datafield[@tag='503']

let $lvente := for $i in local:TypeVente($bnfNUM) group by $i return $i

let $vlist :=  map:merge(for $l in $lvente
return map{$l : local:GetListItem($bnfNUM,$l)})


return graph:PointChart(
  array{
  map{'data':$vlist('Art'),'svg':<path xmlns="http://www.w3.org/2000/svg" d="M7.0 0.0 -3.4999999999999982 6.062177826491071 -3.500000000000003 -6.0621778264910695 Z" style="fill:red"/>,'label':'Art'},
  map{'data':$vlist('Numismatique'),'svg':<circle xmlns="http://www.w3.org/2000/svg" r="3" fill="green"/>,'label':'Numismatique'},
  map{'data':$vlist('Livres'),'svg':<path xmlns="http://www.w3.org/2000/svg" d="M7.0 0.0 2.163118960624632 6.657395614066075 -5.663118960624631 4.114496766047313 -5.663118960624632 -4.114496766047311 2.1631189606246304 -6.6573956140660755 Z"/>,'label':'Livres'},
  map{'data':$vlist('Musique'),'svg':<rect xmlns="http://www.w3.org/2000/svg" x="-5" y='-5' height="10" width="10" style="fill:magenta"/>,'label':'Musique'},
  map{'data':$vlist('Estampes'),'svg':<rect xmlns="http://www.w3.org/2000/svg" x="-5" y='-5' height="10" width="10" style="fill:black"/>,'label':'Estampes'},
  map{'data':$vlist('Autographes'),'svg':<rect xmlns="http://www.w3.org/2000/svg" x="-5" y='-5' height="10" width="10" style="fill:orange"/>,'label':'Autographes'},
  map{'data':$vlist('art'),'svg':<rect xmlns="http://www.w3.org/2000/svg" x="-5" y='-5' height="10" width="10" style="fill:aqua"/>,'label':'art'},
  map{'data':$vlist('Manuscrits'),'svg':<rect xmlns="http://www.w3.org/2000/svg" x="-5" y='-5' height="10" width="10" style="fill:blue"/>,'label':'Manuscrits'},
  map{'data':$vlist('livres'),'svg':<rect xmlns="http://www.w3.org/2000/svg" x="-5" y='-5' height="10" width="10" style="fill:yellow"/>,'label':'livres'},
  map{'data':$vlist('Bruxelles'),'svg':<rect xmlns="http://www.w3.org/2000/svg" x="-5" y='-5' height="10" width="10" style="fill:grey"/>,'label':'Bruxelles'}
  
},('auto','auto'),('0','auto'),50,1,'Frise Chronologique en fonction des type de vente')

