/*********************************************
 * OPL 12.9.0.0 Model
 
 * Author: Client
 * Creation Date: 4 mai 2020 at 02:08:49
 *********************************************/
 
 //Les nouveaux  structures 
 
 
 tuple point {//structure d�finissant un point dans un syst�me de coordonn�e cart�sien
  float x;//abscisse 
  float y;//ordonn�e
  float z;// hauteur   
 }
 
  tuple accesspt{ // structure d�finissant un point d'acc�s
  
  int ida;//  identifiant nom d'un AP
  point position;// position d'un AP dans l'espace
  int type;// type de point d'acc�s  
  
  }
  
  tuple user{//station
  int idu;// identifiant de l'utilisateur'
 point position ;
 
  } 
 
//les variables 

int n=30;// nombre de users
int napl=16; //nombre d'ap LIFI
int napw=1;// nombre d'ap wifi
int nap=napl+napw; //nombre d'ap total
float Pdl=0.8;// proportion de wifi en downlink
int T=10*n; // TDMA********T selon l'article est �gal k(=10 dans l'article') fois le nombre de users donc T=20 
range temps=1..T;  //intervalle d'entier associ� au temps d'association
float debit_phy[0..n-1][0..nap-1];// le d�bit physique
{accesspt} APwifi={<0,<7.5,7.5,1.5>,2>};
{user} users={<i,<rand(15),rand(15),rand(3)>>|i in 1..n};
{accesspt} APlifi={<4*i+j-4,<3.75*i,3.75*j,0>,1>|i,j in 1..4};//AP lifi en grille
{accesspt} AP=APlifi union APwifi; //les aps totals
float D[u in  0..n-1][ap in 0 ..nap-1]=sqrt(pow(item(users,u).position.x-item(AP,ap).position.x,2)+pow(item(users,u).position.y-item(AP,ap).position.y,2)+pow(item(users,u).position.z-item(AP,ap).position.z,2));//matrice de distance 

execute calcul_debit {// d�pend de la distance 
  
  var debit ;

for (var u = 0; u <= n-1; u++)
{
         for (var ap = 0; ap <= nap-1; ap++)
        
      {
      if(D[u][ap] <=1)      
        debit =800;
    else  if( 1<D[u][ap] && 2>=D[u][ap])
         debit=600;
     else  if (D[u][ap]<=4 && D[u][ap]>2)
          debit=400;
     else
         debit=0.00001;
         
    debit_phy[u][ap]=debit;    
       }
          
}
      }   



  
/************************************************************************************/
//d�clarer les variables de d�cisions

dvar boolean y[AP][users][temps];// la sortie de l'algorithme est une matrice binaire � 3 dimensions 
//qui donne les associations entre AP et utilisateur qui auront lieu

//model 

 
 

         maximize 
sum(u in 0..n-1) sum(ap in 0..nap-1) sum(t in temps ) y[item(AP,ap)][item(users,u)][t]*log(debit_phy[u][ap]*(t/T));//debit_atteint=debit_phy.t/T
                                                      
                                               
  //les contraintes � satisfaire 
  
  
  
subject to {
 
 //un utilisateur ne peut pas etre associ� � plus q'un AP
 forall(u in 0..n-1)
          ( sum(ap in 0..nap-1) sum(t in temps) y[item(AP,ap)][item(users,u)][t])==1;
          
          
//le temps d'allocation d'un AP lifi ne peut pas d�passer l'intervalle de TDMA T ***cette contrainte doit etre valable pour tous les APs lifi
 forall(ap in 0..napl-1)
 
     (sum(u in 0..n-1) sum(t in temps)y[item(APlifi,ap)][item(users,u)][t]*(t/T))<=1;
     
     
 
// le temps l'allocation d'un APwifi ne peut pas  d�passer l'intervalle de TDMA T *****cette contrainte doit etre valable pour tous les APswifi
forall(ap in 0..napw-1)
  (sum(u in 0..n-1) sum(t in temps) y[item(APwifi,ap)][item(users,u)][t]*(t/T))<=Pdl;
   
    }
    
    execute Display{
      
      
   
 
      
      for (var u in users ){
        
      
          for (var ap in AP){
          
          
                 for(var t=1 ;t<=T; t++){
            
                   if(y[ap][u][t]==1){
                            
                            
                            
                           writeln("l'utilisateur",u," est associ� au point d'acc�s ",ap, " pendant ",t," intervalles de T")  ;                              
                                                           }              
             
                                                    
                                           }
                                               
            
                                               }
        
        
                                        }
      
       }
       
       
       
       
       
      /* main{
  thisOplModel.generate();
  cplex.solve();
  var ofile = new IloOplOutputFile("modelRun.txt");
  //ofile.writeln(thisOplModel.printExternalData());
 // ofile.writeln(thisOplModel.printInternalData());
  ofile.writeln(thisOplModel.printSolution());
  ofile.close();
}*/
       
                                       