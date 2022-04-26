declare function local:GetListItem(){

let $u := db:open("publication-internship")//controlfield[@tag='006']/text()
for $i in $u
  let $j :=$i
  group by $i
  return try{
     <i id='{$i}' n='{count($j)}'> {fetch:xml(concat('https://www.idref.fr/services/rcr2iln/',$i))//shortname/text()} </i>
  }
  catch *{
    <i id='{$i}' n='{count($j)}'> error </i>
  }

};
let $s:= local:GetListItem()

return $s