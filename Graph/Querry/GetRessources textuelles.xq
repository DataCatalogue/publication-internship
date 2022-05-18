declare namespace mxc="info:lc/xmlns/marcxchange-v2";
import module namespace functx = 'http://www.functx.com';
import module namespace graph= 'http://basex.org/modules/graph' at '../Module/Graph.xqm';
import module namespace tools= 'http://basex.org/modules/tools' at '../Module/tools.xqm';
import module namespace moremap= 'http://basex.org/modules/moremap' at '../Module/MoreMap.xqm';



declare function local:Reseigner($data){
  for $i in $data
  let $rslt := switch ($i)
        case ' ' return '0'
        case '|' return '0'
        default return '1'
  return $rslt
  
};
declare function local:Reseigner2($data){
  let $t:='data'
  return if(tools:SeqContains(local:Reseigner($data),'1')='true')then(1)else(0)
  
};



declare function local:GetListItem($u){
for $i in $u
  let $c := $i//subfield[@code='a']/text()|$i//mxc:subfield[@code='a'][1]/text()
    for $d in $c
        return 
          
        
        
        map:merge((
          map:entry('Illustration',local:Reseigner2(tools:betweenPosition(functx:chars($d),1,4))),
          map:entry('Nature',local:Reseigner2(tools:betweenPosition(functx:chars($d),5,8))),
          map:entry('Congres',local:Reseigner(functx:chars($d)[9])),
          map:entry('Mélanges',local:Reseigner(functx:chars($d)[10])),
          map:entry('Index',local:Reseigner(functx:chars($d)[11])),
          map:entry('genre',local:Reseigner(functx:chars($d)[12])),
          map:entry('Biographie',local:Reseigner(functx:chars($d)[13]))
      ))
    };

declare function local:test($data){
  let $s := map:merge($data,map{'duplicates': 'combine'})
    return map:merge(
    for $i in map:keys($s)
       let $d:= $s($i)
       return map{$i: string((sum(for $o in $d
         return number($o)) div count(for $o in $d
         return number($o)))*100)})
};

declare function local:sommet($map,$r,$x,$y){
  let $nbs := count(map:keys($map))
  for $i in 0 to $nbs - 1
   let $sommet := [$r * math:cos(2 * math:pi() * $i div $nbs) + $x,$r * math:sin(2 * math:pi() * $i div $nbs) + $y]
   return $sommet
  
  
};
declare function local:sommetdata($map,$r,$x,$y){
  let $nbs := count(map:keys($map))
  let $sl := map:keys($map)
  for $i in 0 to $nbs - 1
   let $p := ($r * number($map?(map:keys($map)[$i+1]))) div 100
   let $sommet := [$p  * math:cos(2 * math:pi() * $i div $nbs) + $x,$p * math:sin(2 * math:pi() * $i div $nbs) + $y]
   return $sommet
  
  
};

declare function local:branch($s,$r,$x,$y){
  for$i in $s
  return <line x1="{$x}" y1="{$y}" x2="{array:get($i,1)}" y2="{array:get($i,2)}" style="stroke:black" />
  
};


declare function local:star($s,$r,$x,$y,$color){
  let $s:= $s
  return <path d="{concat('M ',string-join( string-join(
  for$i in $s
  let $a := (array:get($i,1),' ', array:get($i,2),' ')
  return string-join($a))),' Z')}" fill="{$color}" stroke="black" opacity="0.5" />
 
};

declare function local:Label($s,$keys){
  
  
  for $i in 1 to count($keys)
  return <text xmlns="http://www.w3.org/2000/svg" x="{array:get($s[$i],1)}" y="{array:get($s[$i],2)}" text-anchor="middle" font-family="Verdana"  font-size="10" >{$keys[$i]}</text>
  
};


declare function local:grap($data,$r,$x,$y){
  let $map := map:find($data(1),'data')(1)
  let $s:= local:sommet($map,$r,$x,$y)
  
  return  <svg xmlns="http://www.w3.org/2000/svg" width= "100%" height="100%">{(local:Label(local:sommet($map,$r+30,$x,$y),map:keys($map)),local:branch($s,$r,$x,$y),local:star($s,$r,$x,$y,'transparent'),
  array:for-each(
  $data,
  function($i) { 
   let $p:= local:sommetdata(map:find($i,'data')(1),$r,$x,$y)
   return local:star($p,$r,$x,$y,map:find($i,'color'))}
)
)}</svg>
 
};






let $bnf := doc("../../FouilleData/Exp1/output.xml")//bnf//record//datafield[@tag='105'] 
let $inha := doc("../../FouilleData/Exp1/output.xml")//inha//record//datafield[@tag='105']
let $all := ($bnf,$inha)
let $databnf := map:merge((
  map{'label':'bnf'},
                map:entry('data',local:test(local:GetListItem($bnf))),
                map:entry('style','fill:green;opacity:0.3')
              ))
let $datainha := map:merge((
  map{'label':'inha'},
                map:entry('data',local:test(local:GetListItem($inha))),
                map:entry('style','fill:blue;opacity:0.3')
              ))
let $all := map:merge((
                map{'label':'all'},
                map:entry('data',local:test(local:GetListItem($all))),
                map:entry('style','fill:red;opacity:0.3')
              ))

return graph:SpiderChart([$databnf,$datainha,$all],150,25,300,300,'Graph des données textuelle')
(:local:grap([$databnf,$datainha,$all],100,1000,500):)

(:<svg xmlns="http://www.w3.org/2000/svg" width= "100%" height="100%"> <path d="{
concat('M ',string-join(local:grap(local:test(local:GetListItem($all)),100,100,100)),'Z')}" fill="transparent" stroke="black"/> </svg> :)