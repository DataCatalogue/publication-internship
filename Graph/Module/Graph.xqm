module namespace graph= 'http://basex.org/modules/graph';
import module namespace color= 'http://basex.org/modules/color' at 'ColorFunction.xqm';
import module namespace moremap= 'http://basex.org/modules/moremap' at 'MoreMap.xqm';

(:~
 : Return regular vertex of regular Polygone
 :
 : @author  Jules Nuguet
 : @version 0.1 
 : @see     mysite.fr 
 : @param   $nbv number vertex
 : @param   $r radius size
 : @param   $x vertical position of the center
 : @praam   $y horizontal vertical position of the center
 :)
 
declare function graph:RegularVertex($nbv as xs:decimal ,$r as xs:decimal,$x as xs:decimal ,$y as xs:decimal){
  for $i in 0 to $nbv - 1
  let $vertex := [$r * math:cos(2 * math:pi() * $i div $nbv) + $x,$r * math:sin(2 * math:pi() * $i div $nbv) + $y]
  return $vertex};
  
(:~
 : Return Non regular vertex of regular Polygone
 :
 : @author  Jules Nuguet
 : @version 0.1 
 : @see     mysite.fr 
 : @param   $sqv pourcentage vertex sequence
 : @param   $r radius size
 : @param   $x vertical position of the center
 : @praam   $y horizontal vertical position of the center
 :)
declare function graph:NonRegularVertex($sqv,$r,$x,$y){
  let $nbv := count($sqv)
  for $i in 0 to $nbv - 1
   let $p := ($r * number($sqv[$i+1])) div 100
   let $vertex := [$p  * math:cos(2 * math:pi() * $i div $nbv) + $x,$p * math:sin(2 * math:pi() * $i div $nbv) + $y]
   return $vertex };
   

(:~
 : Return Non regular vertex of regular Polygone
 :
 : @author  Jules Nuguet
 : @version 0.1 
 : @see     mysite.fr 
 : @param   $sqv vertex sequence
 : @param   $class 
 : @param   $id
 :)
declare function graph:Vertex2SVG($sqv,$class,$id){
  <path class="{$class}" id="{$id}" d="{concat('M ',string-join( string-join( for $i in $sqv let $a := (array:get($i,1),' ', array:get($i,2),' ')return string-join($a))),' Z')}"/>
};


(:~
 : Return Non regular vertex of regular Polygone
 :
 : @author  Jules Nuguet
 : @version 0.1 
 : @see     mysite.fr 
 : @param   $data map with a specific scheme
 : @param   $r size radius
 : @param   $step grid
 : @param   $x vertical position of the center
 : @praam   $y position of center horizontal axe
 :)
declare function graph:SpiderChart($data,$r as xs:decimal ,$step as xs:decimal ,$x as xs:decimal,$y as xs:decimal,$title as xs:string){
  let $keys :=map:keys(map:find($data(1),'data')(1))
  let $nbv := count($keys)
  
  return
   <svg xmlns="http://www.w3.org/2000/svg" width= "100%" height="100%">
   <style>
   
   .back{{
     fill:transparent;
     stroke:black;
     stroke-width:1;
     stroke-dasharray:4;
   }}
   text{{
     fill:black;
     font-size:15 px;
     stroke:transparent;
     stroke-width:0;
     }}
   #n100{{
     stroke-dasharray:0;
   }}
   
   </style>
   <g class='back'>
   {for $i in 1 to 100
   let $ut := $r div 100   
   return if ($i mod $step=0)then(
    graph:Vertex2SVG(graph:RegularVertex($nbv,$i*$ut,$x,$y),'background',concat('n',$i)),<text class="LabelY" x="{$x}" y="{$y+$i*$ut}">{$i} %</text>
 )},
   {
   for $i in graph:RegularVertex($nbv,$r,$x,$y) 
   return <line class="branch" x1="{$x}" y1="{$y}" x2="{array:get($i,1)}" y2="{array:get($i,2)}" />}
{
     let $s := graph:RegularVertex($nbv,$r+30,$x,$y)
     for $i in 1 to $nbv
  return  <a href="https://www.google.fr/search?q={$keys[$i]}"><text class="label" x="{array:get($s[$i],1)}" y="{array:get($s[$i],2)}" text-anchor="middle">{$keys[$i]}</text></a>
  
}
  </g>
   <g class='data'>
   {array:for-each(
  $data,
  function($i) { 
   let $p:= graph:NonRegularVertex(moremap:Values($i('data')),$r,$x,$y)
   return (<style>
   #{$i('label')}{{
     {$i('style')}
   }}
   </style>,<a href="https://www.google.fr/search?q={$i('label')}">{graph:Vertex2SVG($p,"Poly",$i('label'))}</a>
)})}
   </g>  
   <g class="legend">
   <text y="{$r+$y+50}" x="{$x}" text-anchor="middle">{$title}</text>
   </g>
   </svg>
  
};



(:~
 : create SVG bar Chart 
 :
 : @author  Jules Nuguet
 : @version 0.1 
 : @see     mysite.fr 
 : @param   $array composed map('label': xs:string,'data': sequence of data ,'x': xs:integer, 'color':: ref of color module)
 : @param   $title title of graph 
 :)
declare function graph:GraphBar($array ,$title as xs:string){
<svg xmlns="http://www.w3.org/2000/svg" width= "100%" height="100%"> 
 (:CSS style:) 
<style>
  .pie:hover text {{
    fill:goldenrod;
  }}
  .pie:hover rect{{
    stroke:goldenrod;;
    stroke-width:5
  }}
</style>
<text  x="50%" y="1%" text-anchor="middle">{$title}</text>
{
  array:for-each($array, function($imap){
     <text x="{$imap('x')}%" y="98%" fill="black">{$imap("label")}</text>,
      <g class="bar"  transform="translate(0 50)scale(1 0.9)"> {
   (:FR Transforme en pourcentage une map qui compte les valeur data:) 
  let $dataGraph := moremap:Percent(moremap:CountSeq($imap("data")))
  (:FR Génére une séquence de coulor en fonction de la taille de map de pourcentage :) 
  let $colors := color:RGBGradient(map:size($dataGraph),$imap("color"))
  for $i in 1 to map:size($dataGraph) 
   (: FR  Récupére la somme des positions du précédentes pour pouvoir placer un rectangle en fonction :)
    let $before:= sum(moremap:Values($dataGraph) [position () < $i])
    let $now:=map:find($dataGraph, map:keys($dataGraph)[$i])
    return   
      <g  class="pie">
      
      <a href="https://www.google.fr/search?q={map:keys($dataGraph)[$i]}"><rect x="{$imap('x')}%" y="{$before}%" width="10%" height="{$now}%" style=" fill:{$colors[$i]}" /></a>
      <text  x="{$imap('x') +10}%" y="{$before}%" font-size="12" fill="transparent" > {map:keys($dataGraph)[$i],':',$now,'%'} </text>
      </g>
}</g>})}</svg>};


(:~
 : Create Circular Network Graph
 :
 : @author  Jules Nuguet
 : @version 0.1 
 : @see     mysite.fr 
 : @param   $node node sequence
 : @param   $link array of map contains traget ans source
 : @param   $r size radius
 : @param   $x vertical position of the center
 : @praam   $y position of center horizontal axe
 :)

declare function graph:GraphCircularNetwork($node,$link,$r as xs:decimal,$x as xs:decimal,$y as xs:decimal){

let $v := graph:RegularVertex(count($node),$r,$x,$y)
let $vl := graph:RegularVertex(count($node),$r+30,$x,$y)
return 

<svg xmlns="http://www.w3.org/2000/svg" width= "100%" height="100%"> 
<style>
path{{
  stroke:black ;
  stroke-width:3;
  fill:transparent; 
}}
.link:hover{{
  stroke:red ;
  stroke-width:3;
}}

</style>
{graph:Vertex2SVG($v,'back','1')}
{
  for $l in $node
  return <text x="{$vl[index-of($node,$l)](1)}" y="{$vl[index-of($node,$l)](2)}" text-anchor='middle'>{$l}</text>
}
{
array:for-each(
  $link ,
  function ($i) {
    <path class="link" d="M{$v[index-of($node,$i('source'))]} Q {$x} {$y} {$v[index-of($node,$i('target'))]} Q {$x} {$y} {$v[index-of($node,$i('source'))]}" />
  }
)}
</svg> 
};
(:~
 : Create Grid
 :
 : @author  Jules Nuguet
 : @version 0.1 
 : @see     mysite.fr 
 : @param   $option  map with minX,maxX,utX,minY,minY,utY
 : :)
declare function graph:Grid($option as map(*))
{
  <g>
  <g>{
  for $item in $option('minX') to $option('maxX')
  
    let $value := ($item - $option('minX')) * $option('utX')

    return 
    if ($item mod $option('stepX')= 0) then(
      <text class="GridX" x="{$value}%" y="98%" > {$item} </text>,
      <line x1="{$value}%" y1="0%" x2="{$value}%" y2="100%"/>)
  }
  </g>
  <g>{
  for $item in $option('minY') to $option('maxY')
    let $value := 100 - ($item - $option('minY')) * $option('utY')
    return if ($item mod $option('stepY')= 0) then(
      <text class="GridY" x="98%" y="{$value}%"> {$item} </text>,
      <line x1="0%" y1="{$value}%" x2="100%" y2="{$value}%"/>)}
  </g>
  </g>};
  
(:~
 : Create PointChart
 :
 : @author  Jules Nuguet
 : @version 0.1 
 : @see     mysite.fr 
 : @param   $data  map with title, svg, sequence de data
 : @param   $minmaxX (min,max)
 : @param   $minmaxY (min,max)
 : @param   $stepX vertical position of the center
 : @praam   $stepY position of center horizontal axe
 : @praam   $title  position of center horizontal axe
 :)

declare function graph:PointChart($data,$minmaxX as item()*,$minmaxY as item()*,$stepX as xs:integer,$stepY as xs:integer,$title as xs:string){
  let $dataItem := array:flatten(array:for-each( $data,function ($i) {$i('data')}))
  let $maxX := if($minmaxX[2]='auto')then(xs:integer(max($dataItem)[1]))else(xs:integer($minmaxX[2]))
let $minX := if($minmaxX[1]='auto')then(xs:integer(min($dataItem)[1]))else(xs:integer($minmaxX[1]))
let $maxY := if($minmaxY[2]='auto')then(if($minmaxX[1]='auto')then(max(moremap:Values(map:merge(moremap:CountSeq($dataItem)))))else(max(moremap:Values(map:merge(moremap:DataFilter($minX, $maxX ,map:merge(moremap:CountSeq($dataItem))))))))else(xs:integer($minmaxY[2]))
let $minY := if($minmaxY[1]='auto')then(if($minmaxX[1]='auto')then(min(moremap:Values(map:merge(moremap:CountSeq($dataItem)))))else(min(moremap:Values(map:merge(moremap:DataFilter($minX, $maxX ,map:merge(moremap:CountSeq($dataItem))))))))else(xs:integer($minmaxY[1]))
let $ecX := $maxX - $minX
let $utX :=  100 div $ecX
let $ecY := ($maxY - $minY) div 2
let $utY :=  100 div $ecY
let $opt := map{'maxX':$maxX,'minX':$minX,'ecX':$ecX,'utX':$utX,'ecY':$ecY,'utY':$utY,'maxY':$maxY,'minY':$minY,"stepX":$stepX,"stepY":$stepY}
return

<svg xmlns="http://www.w3.org/2000/svg" width= "100%" height="100%"> 
<style>line{{stroke:black}}.legend rect{{fill:white;opacity:0.8}}</style>
{graph:Grid($opt)}
<defs>{array:for-each( $data,function ($value) {<g id="{$value('label')}">{$value('svg')}</g>})}</defs>
<g>
{
array:for-each( $data,function ($value) {
  for $item in  $value('data')
  let $itemid:= $item
  group by $itemid
  order by $itemid
  let $i := ($itemid[1]- $opt('minX'))*$opt('utX')
  let $g := (count($item)-$opt('minY'))* $opt('utY')
  return <a href="https://www.google.fr/search?q={$itemid[1]}&amp;{$value('label')}"><use x="{$i}%" y="{100 - $g}%" href="#{$value('label')}" /></a>
})}
</g>


<g class="legend">
<rect x="0%" y="0%" width="20%" height="25%"/>
<text x="1%" y="2.5%">{$title}</text>
{ 
  array:for-each-pair(
  $data,
  array { 1 to array:size($data)},
  function($value,$index) { 
  let $y := 5+ (($index * 15)div array:size($data))
  
  return (<use x="1%" y="{$y}%" href="#{$value('label')}" />,
  <text x="3%" y="{$y}%">{$value('label')}</text>)})}</g>
</svg>

};
