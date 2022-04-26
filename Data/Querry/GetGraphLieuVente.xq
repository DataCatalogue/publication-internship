declare namespace mxc="info:lc/xmlns/marcxchange-v2";
import module namespace functx = 'http://www.functx.com';

declare function local:GetListItem($u){
for $i in $u
  let $b := if ($i//subfield[@code='a'][text()='Vente']|$i//mxc:subfield[@code='a'][text()='Vente']) then ($i)
  let $c := $b//subfield[@code='m']/text()|$b//mxc:subfield[@code='m'][1]/text()
  return $c
};
declare function local:GetListCount($liste){
  for $item in  $liste
    let $type:= $item
    group by $type
    order by $type
    let $compte:= count($item)
    
  return map:entry($item[1],$compte)
};

declare function local:Values($map)
{
  let $s:=0
  for $i in map:keys($map)
    let $s:=$s+map:find($map,$i)
    return $s
  
};

declare function local:Pct($map,$sum)
{
  let $s:=0
    for $i in map:keys($map)
    let $s:=(map:find($map,$i) div $sum )*100
  return map{$i:$s}
};



declare function local:Graph($data,$x)
{
  let $mapBnf := map:merge(local:GetListCount(local:GetListItem($data)))
  let $sumBnf :=sum(local:Values($mapBnf))
  let $dataGraph := map:merge(local:Pct($mapBnf,$sumBnf))
  
  for $i in 1 to map:size($dataGraph)
    
   
    
    let $before:= sum(local:Values($dataGraph) [position () < $i])
    
    let $now:=map:find($dataGraph, map:keys($dataGraph)[$i])
    
    return   (<rect x="{$x}%" y="{$before}%" width="10%" height="{$now}%" style="stroke:black; fill:white;stroke-width:1px" />,
    if ($now >4 ) then(
  <text x="{$x +10}%" y="{$before}%" font-family="Verdana" font-size="10"> {map:keys($dataGraph)[$i],':',$now,'%'} </text>))
};
let $bnf := db:open("publication-internship")//mxc:record//mxc:datafield[@tag='503'] 
let $inha := db:open("publication-internship")//record/controlfield[@tag='006'][text()='751025206']/parent::record//datafield[@tag='503']
let $all := ($bnf,$inha)
 
return <svg xmlns="http://www.w3.org/2000/svg" width= "100%" height="100%">{local:Graph($bnf,0),local:Graph($inha,20),local:Graph($all,40)}</svg>