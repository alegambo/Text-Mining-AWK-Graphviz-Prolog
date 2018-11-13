###############################################################
#   Universidad Nacional de Costa Rica
#   Curso EIF-400  Paradigmas de Pogramación
#   Profesor: Dr. Carlos Loría-Sáenz
#
#   Grupo 05-1pm.
#   1) Nombre: Juan Alfonso Miranda Bonilla ID: 111950373 
#        correo: juan.miranda.hr9@gmail.com HORARIO: 1pm
#   2) Nombre: Marco Trigueros Soto ID: 402270078 
#        correo: mrctrgrst@gmail.com  HORARIO: 1pm
#   3) Nombre:  Alejandro Gamboa Barahona  ID: 115790444 
#        correo: alegamboaba.17@gmail.com  HORARIO: 10am
#   4) Nombre David Morales Hidalgo  ID: 116300616 
#        correo: davmohi@gmail.com HORARIO: 10am
##############################################################

function rankOptativas() {
    optativasLevelStr = "";
    cantidadDeCursosPorCadaOptitivaEnElplan = int(optativasDispoblesCount/optativasACursarCount)+1;
    for(i in optativasNiveles){
        optativasLevelStr = optativasLevelStr optativasNiveles[i] substr(optativasTempLevelStr,((i-1)*cantidadDeCursosPorCadaOptitivaEnElplan*10)+1,(cantidadDeCursosPorCadaOptitivaEnElplan*10)) "}";
    }
    return optativasLevelStr;
}

BEGIN{
    outNoreqRelations = ""; 
    outRelations = "";
    tempLevelStr = "";
    outRank =  "ranksep=.25; { node [shape=plaintext]; \"Ingreso\" ->"; 
    outRankData = "{ rank = same; \"Ingreso\"; \"Ingreso a Carrera \"; ";
    outColorsLeaf = "{ \n node [style=filled] \n \"Ingreso a Carrera \" [fillcolor=darkgreen  fontcolor=white  shape=invtriangle fontsize=16]";
    nivel = "I";
    ciclo = "I";
    optativasACursarCount = 0;
    optativasDispoblesCount = 0;

    optativasTempLevelStr;
    canRankCurso = 1;
   
    print "digraph beesleyfig1 {";
}  
$1~/Optativa/ {
    optativasACursarCount++;
    optativasNiveles[optativasACursarCount] =  "\n{ rank = same; \"" nivel "-" ciclo "\";";
}
$1~/^OPTATIVOS DISCIPLINARIOS/ {
  #  print "OPTATIVOS DISCIPLINARIOS";
    canRankCurso = 0;
}
$1~/^EIF|^EIG|^MA|^LIX/{ 
    gsub(/ |-/, "", $0); 
   hasPrereq = 1;
    for(i=2;i<=NF;i++){
        if($i~/^EIF[0-9]{3}O/){
             $i = substr($i,1,7);
        } else {
             $i = substr($i,1,6);
        }
        if($i ~ /^EIF|^MA|^LIX/ || $i ~ /Ingreso/){
            outRelations =  outRelations " \n\"" $i "\" -> \"" $1 "\"";
            hasPrereq = 0;
        }
    }
    if(hasPrereq) {
            outNoreqRelations = outNoreqRelations "\n\"Ingreso a Carrera \" -> \"" $1 "\"";
    } else if(canRankCurso){
        tempLevelStr = tempLevelStr "\"" $1 "\";";
   }
}
/ Ciclo/{
    ciclo =  substr($1,1,index($1, " ")-1) ;
    outRankData = outRankData tempLevelStr "}";
    tempLevelStr = "\n{ rank = same; \"" nivel "-" ciclo "\";";
    outRank = outRank "\"" nivel "-" ciclo "\" -> ";
}
/ Nivel/{
    nivel = substr($1,1,index($1, " ")-1) ;
}

/^EI\wF[0-9]{3}O/{
     $0=substr($0,1,7);
} 

/^EI\w[0-9]{3}!0|^MAY|^LIX/{
     $0=substr($0,1,6);
} 

$1~/^EI\w[0-9]{3}O/ {
    optativasDispoblesCount++;
    optativasTempLevelStr = optativasTempLevelStr "\"" $1 "\";";
}

END{
    optativasLevelString = rankOptativas();
  
    print outColorsLeaf "\n}";
    print outRank "\"end\";} { rank = same; \"end\"};";
    print outRankData tempLevelStr "}";
    print optativasLevelString; 
    
    print outNoreqRelations;
    print outRelations;
    print "}";
}