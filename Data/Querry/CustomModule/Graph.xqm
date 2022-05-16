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
declare function graph:SpiderChart($data,$r,$step,$x,$y){
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
   .Poly{{
     stroke:black;
     stroke-width:1;
     opacity:0.3;
    fill:red;
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
  return <text class="label" x="{array:get($s[$i],1)}" y="{array:get($s[$i],2)}" text-anchor="middle">{$keys[$i]}</text>
  
}
  </g>
   <g class='data'>
   {
    array:for-each(
  $data,
  function($i) { 
   let $p:= graph:NonRegularVertex(moremap:Values($i('data')),$r,$x,$y)
   return graph:Vertex2SVG($p,"Poly",$i('label'))})}
   
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
      <rect x="{$imap('x')}%" y="{$before}%" width="10%" height="{$now}%" style=" fill:{$colors[$i]}" />
      <text  x="{$imap('x') +10}%" y="{$before}%" font-size="12" fill="transparent" > {map:keys($dataGraph)[$i],':',$now,'%'} </text>
      </g>
}</g>})}</svg>};

declare function graph:GraphCircularNetwork($node,$link,$r,$x,$y){

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