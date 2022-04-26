declare namespace mxc="info:lc/xmlns/marcxchange-v2";
import module namespace functx = 'http://www.functx.com';

declare function local:GetListItem($u){
for $i in $u
  let $b := if ($i//subfield[@code='a']|$i//mxc:subfield[@code='a'] ='Vente') then ($i)
  let $c := $b//subfield[@code='j'][1]/text()|$b//mxc:subfield[@code='j'][1]/text()
  let $d := number(functx:get-matches($c,"[0-9]{4}")[1])
  let $s := if (functx:is-a-number($d)= true()) then ( $d)
  return $s
};

declare function local:GetListCount($liste){
  for $item in  $liste
    let $annee:= $item
    group by $annee
    order by $annee
    let $compte:= count($item)
    return map:entry(string($annee),$compte)
};

declare function local:GetLineX($map,$pas){
  for $item in $map('min') to $map('max')
    let $value := ($item - $map('min')) * $map('ut')
    return if ($item mod $pas= 0) then(
      <text x="{$value}%" y="2%" font-family="Verdana" font-size="10"> {$item} </text>,
    <line x1="{$value}%" y1="0%" x2="{$value}%" y2="100%" stroke="black" />
  )};
  
declare function local:GetLineY($map,$pas){
  for $item in 0 to $map('maxy')
    let $value := 100 - ($item*100 div $map('maxy'))
    return if ($item mod $pas= 0) then(
      <text x="2%" y="{$value}%" font-family="Verdana" font-size="10"> {$item} </text>,
    <line x1="0%" y1="{$value}%" x2="100%" y2="{$value}%" stroke="black" />
  )};
  
  
  
declare function local:Point($value,$map,$color){
for $item in  $value
  let $itemid:= $item
  group by $itemid
  order by $itemid
  let $i := ($itemid[1]- $map('min'))*$map('ut')
  let $g := count($item)*100 div $map('maxy')
  return <circle cx="{$i}%" cy="{100 - $g}%" r="3" fill="{$color}" />
};

declare function local:DataFilter($min,$max,$liste){
  for $i in map:keys($liste)
  let $s := map:find($liste,$i)
  
  return if ($min < number($i))then(if( number($i) < $max )then(map:entry($i, map:find($liste,$i))))
 
};

declare function local:Values($map)
{
  let $s:=0
  for $i in map:keys($map)
    let $s:=$s+map:find($map,$i)
    return $s
  
};

declare function local:Data($all,$minmax){
let $allItem :=local:GetListItem($all)
let $max := if($minmax[2]='auto')then(xs:integer(max($allItem)[1]))else(xs:integer($minmax[2]))
let $min := if($minmax[1]='auto')then(xs:integer(min($allItem)[1]))else(xs:integer($minmax[1]))
let $ec := $max - $min
let $ut :=  100 div $ec
let $maxy:= if($minmax[1]='auto')then(max(local:Values(map:merge(local:GetListCount($allItem)))))else(max(local:Values(map:merge(local:DataFilter($min, $max ,map:merge(local:GetListCount(local:GetListItem($all))))))))

let $rslt := map{'max':$max,'min':$min,'ec':$ec,'ut':$ut,'maxy':$maxy}
return $rslt
};



let $bnf := db:open("publication-internship")//mxc:record//mxc:datafield[@tag='503'] 
let $inha := db:open("publication-internship")//record/controlfield[@tag='006'][text()='751025206']/parent::record//datafield[@tag='503']
let $all := ($bnf,$inha)
let $map := local:Data($all,('2000','2020'))


return <svg xmlns="http://www.w3.org/2000/svg" width= "100%" height="100%">{(local:GetLineX($map,5),local:GetLineY($map,100),local:Point(local:GetListItem($all),$map,'red'),local:Point(local:GetListItem($inha),$map,'blue'),local:Point(local:GetListItem($bnf),$map,'green'))}</svg>



(:local:GetListCount(local:GetListItem($all)):)
