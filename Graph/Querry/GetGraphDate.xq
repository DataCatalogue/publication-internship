import module namespace functx = 'http://www.functx.com';
import module namespace graph= 'http://basex.org/modules/graph' at '../Module/Graph.xqm';


declare function local:GetListItem($u){
for $i in $u
  let $b := if ($i//subfield[@code='a']='Vente') then ($i)
  let $c := $b//subfield[@code='j'][1]/text()
  let $d := number(functx:get-matches($c,"[0-9]{4}")[1])
  let $s := if (functx:is-a-number($d)= true()) then ( $d)
  return $s
};



let $bnfNUM := doc('../../FouilleData/Exp2/output.xml')//datafield[@tag='503']
let $bnf := doc('../../FouilleData/Exp1/output.xml')/bnf//record//datafield[@tag='503']
let $inha := doc('../../FouilleData/Exp1/output.xml')/inha//record//datafield[@tag='503']
let $all := ($bnf,$inha)

return graph:PointChart(array{
  map{'data':local:GetListItem($bnf),'svg':<circle xmlns="http://www.w3.org/2000/svg" r="3" fill="red"/>,'label':'Bnf'},
  map{'data':local:GetListItem($inha),'svg':<circle xmlns="http://www.w3.org/2000/svg" r="3" fill="green"/>,'label':'G'},
  map{'data':local:GetListItem($all),'svg':<path xmlns="http://www.w3.org/2000/svg" d="
M15.0 0.0 4.635254915624212 14.265847744427303 -12.13525491562421 8.816778784387099 -12.135254915624213 -8.816778784387095 4.635254915624208 -14.265847744427305 Z"/>,'label':'F'},
  map{'data':local:GetListItem($bnfNUM),'svg':<rect xmlns="http://www.w3.org/2000/svg" x="-5" y='-5' height="10" width="10" style="fill:magenta"/>,'label':'bnfNUM'}},
  ('2000','2020'),('0','auto'),1,100,'Je suis un titre')

