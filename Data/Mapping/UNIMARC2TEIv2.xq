import module namespace functx = 'http://www.functx.com';
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare function local:datafield($data,$datafield,$subfield)
{
  let $data :=$data
  return $data//datafield[@tag=$datafield]//subfield[@code=$subfield]/text()
};

declare function local:autority($data,$datafield,$subfield)
{
  try{
  let $data := $data//datafield[@tag=$datafield]//subfield[@code=$subfield]
  let $authority := doc('E:\users\jules\Documents\GitHub\publication-internship\Data\Mapping\ZoneCode\authority.xml')
  for $i in $authority//tag[@id=$datafield]//code[@id=$subfield]
  for $p in $i/position
  let $map := map:merge(for $p in $p/node()
  return map{name($p):$p/text()})
  let $list := functx:chars($data/text())
  let $c := $list[$p/@start to $p/@end ]
  for $t in $c
  return map:find($map,$t)
}catch * {} };
(:let $bnf := db:open("Database")/bnf//record
let $inha := db:open("Database")/inha//record
let $all := ($bnf,$inha):)
declare function local:RCN($string){
  let $text := file:read-text('E:\users\jules\Documents\GitHub\publication-internship\Data\Mapping\listrcrisil4.csv')
return csv:parse($text, map { 'header': true() ,'separator':'semicolon'})//RCR[text()=$string]//ancestor::record//LIBELLE/text()
};

let $all :=  doc('E:\users\jules\Documents\GitHub\publication-internship\Data2\BnfDataNUM.xml')//record

for $i in $all
return 
<TEI xmlns="http://www.tei-c.org/ns/1.0">
    <teiHeader>
        <fileDesc>
            <titleStmt>
                <title type="main">{local:datafield($i,'200','a')}</title>
                {for $l in 1 to count(local:datafield($i,'503','a'))
                return  
             <title type="alt">
                <label>{local:datafield($i,'503','a')[$l]}</label>,
                <tag>{local:datafield($i,'503','b')[$l]}</tag>,
                <date>{local:datafield($i,'503','d')[$l],local:datafield($i,'503','j')[$l]}</date>,
                <persName>
                <forename>{local:datafield($i,'503','e')[$l]}</forename>
                <surname>{local:datafield($i,'503','f')[$l]}</surname>
                <date>{local:datafield($i,'503','g')[$l]}</date>
                <roleName>{local:datafield($i,'503','h')[$l]}</roleName>
                </persName>
                <placeName>{local:datafield($i,'503','m')[$l]}</placeName>
              </title>}
            </titleStmt>
            <publicationStmt>
               <!-- (: information sur la notice:) -->
            </publicationStmt>
         <sourceDesc>
                <bibl>
                     <author>
                         <persName>{local:datafield($i,'604','a')}</persName>
                     </author>
                     <availability>
  <idno type="PaysdépotLégal">{local:datafield($i,'021','a')}</idno>
  <idno type="dépotLégal">{local:datafield($i,'021','b')}</idno>
</availability>
                     <publisher>{local:datafield($i,'214','c')}</publisher>
                     <pubPlace>{local:datafield($i,'214','a')}</pubPlace>
                     <idno type="ISBN">{local:datafield($i,'010','a')}</idno>
                     <idno type="EAN">{local:datafield($i,'073','a')}</idno>
                     <idno type="ISSN">{local:datafield($i,'011','a')}</idno>
                     <idno type="BNF">{local:datafield($i,'020','a')}</idno>            
                     <series>
                         <title>{local:datafield($i,'225','a')}</title>
                     </series>
                     {for $l in 1 to count(local:datafield($i,'930','a'))
                     return <location>
                     <idno>{local:datafield($i,'930','a')[$l]}</idno>
                     
                     {local:datafield($i,'930','c')[$l]}-
                     <orgName>{local:RCN(local:datafield($i,'930','b')[$l])}</orgName>
                     </location>}
                     <extent>
                         <measure >{local:datafield($i,'215','a')}</measure>
                         <measure >{local:datafield($i,'215','d')}</measure>
                         <measure >{local:datafield($i,'215','c')}</measure>
                </extent>
                </bibl>
                <listPerson>
                     {for $l in 1 to count(local:datafield($i,'700','a'))
                        return  <person>
                        <persname>
                        <forname>
                        {local:datafield($i,'700','a')[$l]}
                        </forname>
                        <surname>
                        {local:datafield($i,'700','b')[$l]}
                        </surname>
                        <roleName>{local:datafield($i,'700','c')[$l]}</roleName> 
                        </persname>
                        <date>
                        {local:datafield($i,'700','f')[$l]}
                        </date>                   
                        <idno type="IdRefID ">{local:datafield($i,'700','3')[$l]}
                        </idno> 
                        </person>
                        }
                        
                        {for $l in 1 to count(local:datafield($i,'700','a'))
                        return  <person>
                        <persName >
                        <forname>
                        {local:datafield($i,'702','a')[$l]}
                        </forname>
                        <surname>
                        {local:datafield($i,'702','b')[$l]}
                        </surname> 
                        <roleName>{local:datafield($i,'702','c')[$l]}</roleName> 
                        </persName>
                        <date>
                        {local:datafield($i,'702','f')[$l]}
                        </date>
                        
                        <idno type="IdRefID ">{local:datafield($i,'700','3')[$l]}</idno> 
                        </person>
                        }
                    </listPerson> 
            </sourceDesc>
            </fileDesc>
         <profileDesc>
                <langUsage>
                   <language ident="{local:datafield($i,'101','a')}"/>
                </langUsage>
                <textDesc>
                  <channel>{local:autority($i,'106','a')}</channel>
                              <constitution></constitution>
                              <derivation></derivation>
                              <domain></domain>
                              <factuality></factuality>
                              <interaction></interaction>
                              <preparedness></preparedness>
                              <purpose></purpose>
                </textDesc>
                <textClass>
                  <keywords>
                   {for $l in 1 to count(local:datafield($i,'606','a')) return <term><idno type="{local:datafield($i,'606','2')[$l]}">{local:datafield($i,'606','3')[$l]}</idno>  {local:datafield($i,'606','a')[$l]} </term>}
                  </keywords>
                  <keywords>
                  {for $l in 1 to count(local:datafield($i,'608','a')) return <term><idno type="{local:datafield($i,'608','2')[$l]}">{local:datafield($i,'608','3')[$l]}</idno>  {local:datafield($i,'608','a')[$l]} </term>}
                  </keywords>
                </textClass>
           </profileDesc>
        
    </teiHeader>
</TEI>



