<collection>
{
  let $i := file:list('data/Output2')
 for $f in $i
     return <doc href="Output2/{$f}"/>

}
{
  let $i := file:list('data/Output')
 for $f in $i
     return <doc href="Output/{$f}"/>

}


</collection>
