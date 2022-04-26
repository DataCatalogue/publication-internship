module namespace moremap= 'http://basex.org/modules/moremap';


declare function moremap:Values($map as map(*))
{
  for $index in map:keys($map)
  let $rslt:=map:find($map,$index)
  return $rslt
  
};


declare function moremap:Percent($map as map(*))
{
   let $sum := sum(moremap:Values($map))
   return map:merge(
   for $index in map:keys($map)
   let $rslt:=(map:find($map,$index) div $sum )*100
   return map{$index:$rslt} )
};

declare function moremap:CountSeq($liste)
{
   
  for $item in  $liste
    let $type:= $item
    group by $type
    order by $type
    let $compte:= count($item)
    
  return map{$item[1]:$compte}
  
};





