module namespace color= 'http://basex.org/modules/color';

declare function color:RGBGradient($nbColor,$type)
  {let $c:= 255 div $nbColor
  for $i in 0 to $nbColor 
    let $k := $i * $c
    (:return if($type ='red')then(concat('rgb(',$k,',0',',0)')):)
    return switch ($type)
       case 'green' return concat('rgb(','0,',$k,',0)')
       case 'red' return concat('rgb(',$k,',0',',0)')
       case 'blue' return concat('rgb(','0',',0,',$k,')')
       case 'cyan' return concat('rgb(','0,',$k,',',$k,')')
       case 'yellow'return concat('rgb(',$k,',',$k,',0)')
       case 'magenta' return concat('rgb(',$k,',0,',$k,')')
       default return concat('rgb(',$k,',',$k,',',$k,')')
  };


