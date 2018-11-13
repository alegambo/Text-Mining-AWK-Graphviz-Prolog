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

BEGIN{
	cont=1;
	optativa=1;
	creditos=0;#dipl 88, bsc 140
}
$1~/^EIF|^EIG|^MA|^LIX/{ 
   fase=1;#1=codigo, 2=nombre, 3=creditos, 4=requisitos
   linea = cont++;
    for(i=1;i<=NF;i++){
        if($i ~ /^EIF|^EIG|^MA|^LIX/){ 
			gsub(/O/, "0", $i);
			if(fase==1){#si es el codigo
				gsub(/ |-/, "", $i);
				linea=linea "::" $i;
				fase++;
			}
			else if(fase>3){#si es requisito
				gsub(/ |-/, "", $i);
				linea=linea "::" substr($i,1,6);
				fase++;
			}
			else if(fase==3){#si debian venir los creditos pero no los trae
				creditos+=3;
				gsub(/ |-/, "", $i);
				linea=linea "::3::" substr($i,1,6);
				fase++;
				fase++;
			}
        }   
		else if($i ~ /Ingreso/ && fase==4){
			linea=linea "::Admission";
			fase++;
		}
		else if($i ~ /EIF 425 O/){
			linea=linea "::3::EIF4250";
			fase=5;
		}
		else{
			if(fase==3) creditos+=$i;
			linea=linea "::" $i;
			fase++;
		}
    } 
	if(fase==3){#si no tiene los creditos
		creditos+=3;
		linea=linea "::3";
		fase++;
	}
	if(fase==4){#si no tiene requisitos
		linea=linea "::Admission";
	}
	completar(linea);
} 
$1~/^Optativa/{ 
	linea = cont++ "::" $1 romano(optativa++) "::" $1 "::" $2 "::Admission" ;
	completar(linea);
	creditos+=3;
	
}
$1~/^Estudios Generales/{ 
	linea = cont++ "::" $1 "::" $1 "::" $2 "::Admission" ;
	completar(linea);
	creditos+=3;
	
}
function completar(linea){
	if(creditos<89)
		linea= linea "::dipl";
	else
		linea= linea "::bsc";
		
		
	
	for(i=1;i<=7;i++){#para calcular el nivel
		if((cont/10)<=(i+0.1)){ 
			linea= linea "::" romano(i);
			break;
		}
	}
	if(((cont-1)%10)<6&&((cont-1)%10)!=0) #para calcular el ciclo
		linea= linea "::" romano(1);
	else
		linea= linea "::" romano(2);
	print linea "\r\n";
}
function romano(n){ # pasa a numero romano
	switch(n){
		case 1:
			if(creditos<141)
				return "I"
			else
				return "_"
			break;
		case 2:
			if(creditos<141)
				return "II"
			else
				return "_"
			break;
		case 3:
			return "III"
			break;
		case 4:
			return "IV"
			break;
		default:
			return "_"
			break;
	}	
}

