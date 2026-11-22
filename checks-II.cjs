const {S}=require('./solutions.cjs');
const {rnd,bitcount}=require('./random.cjs');
const check=(id,desc,fn)=>{S[id].edgeDescription=desc;S[id].checkEdge=fn;};
check('II-01','n=1: una riga (1,1).',(e,d,a,eq)=>eq(e[0],[[1,1]]));
check('II-02','n=1: unica permutazione 1.',(e,d,a,eq)=>eq(e[0],[[1,'1']]));
check('II-03','n=1: unico prefisso testuale 1.',(e,d,a,eq)=>eq(e[0],[['1']]));
check('II-04','n=3: nessuna permutazione valida.',(e,d,a)=>a.equal(e[0].length,0));
check('II-05','n=1: nessun operatore, valore 1.',(e,d,a,eq)=>eq(e[0],[['1',1]]));
check('II-06','Lunghezza zero: una stringa vuota.',(e,d,a,eq)=>eq(e[0],[['']]));
check('II-07','n=3,k=2: tutte le sei coppie ordinate senza ripetizioni.',(e,d,a,eq)=>eq(e[0],[['1,2'],['1,3'],['2,1'],['2,3'],['3,1'],['3,2']]));
S['II-08'].validate=(d,e,a)=>{a.equal(e[0].length,7200);a.equal(new Set(e[0].map(r=>r[0])).size,7200);for(const [s] of e[0]){const p=s.split(',').map(Number);a.equal(new Set(p).size,10);a.ok(p.slice(0,4).every(x=>x<=5));a.ok(p[5]<p[6]&&p[7]<p[8]&&p[8]<p[9]);}};
check('II-08','Solo tre adulti per quattro mezzi: zero disposizioni.',(e,d,a)=>a.equal(e[0].length,0));
check('II-09','Stringa ONE: un token, nessuno spazio successivo e totale spazi zero.',(e,d,a)=>a.deepEqual(e[0].find(r=>r[1]===3),[1,3,'ONE',1,null,'ONE',0]));
S['II-10'].checkEdge=S['I-18'].checkEdge;S['II-10'].edgeDescription=S['I-18'].edgeDescription;
S['II-11'].checkEdge=S['I-29'].checkEdge;S['II-11'].edgeDescription=S['I-29'].edgeDescription;
S['II-12'].validate=(d,e,a)=>a.deepEqual(e[0].map(r=>r[0]),[1,2,4,8,16,32,...Array.from({length:47},(_,i)=>64+i)]);
check('II-12','Limite 1: solo il seme iniziale.',(e,d,a,eq)=>eq(e[0],[[1]]));
S['II-13'].validate=(d,e,a,eq)=>eq(e[0],[[10]]);
check('II-13','C(5,0)=1.',(e,d,a,eq)=>eq(e[0],[[1]]));
S['II-14'].validate=(d,e,a,eq)=>{const q=Array.from({length:7},(_,i)=>i+1);let p=0;while(q.length>1){p=(p+2)%q.length;q.splice(p,1);}eq(e[0],[[q[0]]]);};
check('II-14','Una sola persona: superstite 1.',(e,d,a,eq)=>eq(e[0],[[1]]));
function cards(d,e,a){const seed=d.prepare('SELECT seed FROM t1').get().seed;const deck=Array.from({length:52},(_,i)=>i+1).sort((x,y)=>rnd(x+seed)-rnd(y+seed)||x-y);a.equal(e[0].length,51);for(let i=0;i<51;i++){const rank=x=>2+(x-1)%13,hi=deck.slice(i+1).filter(x=>rank(x)>rank(deck[i])).length,lo=deck.slice(i+1).filter(x=>rank(x)<rank(deck[i])).length;const guess=hi>lo?'Higher':lo>hi?'Lower':rnd(i+1+seed+1000)%2===0?'Higher':'Lower';a.deepEqual(e[0][i],[i+1,deck[i],rank(deck[i]),deck[i+1],rank(deck[i+1]),hi,lo,guess]);}}
S['II-15'].validate=(d,e,a)=>cards(d,e,a);check('II-15','Seme 42: nuovo mazzo con 52 carte uniche, conteggi residui e 51 previsioni confrontati con implementazione JS indipendente.',(e,d,a)=>cards(d,e,a));
function monty(d,e,a){const p=d.prepare('SELECT * FROM t1').get();let stay=0,change=0;for(let i=1;i<=p.trials;i++){const prize=1+rnd(i*2+p.seed)%3,choice=1+rnd(i*2+1+p.seed)%3;const available=[1,2,3].filter(x=>x!==prize&&x!==choice);const host=available[0];stay+=prize===choice;change+=prize===6-choice-host;}a.deepEqual(e[0],[[p.trials,stay,change,0]]);if(p.trials===10000)a.ok(change/p.trials>0.64&&change/p.trials<0.69);}
S['II-16'].validate=(d,e,a)=>monty(d,e,a);check('II-16','Una sola prova: le strategie sono complementari, host apre una porta valida.',(e,d,a)=>monty(d,e,a));
function dice(d,e,a){const p=d.prepare('SELECT * FROM t1').get();let total=0,min=Infinity,max=0;for(let trial=1;trial<=p.trials;trial++){let score=0,penalty=false,step=0;while(score<p.target&&step<10000){const die=1+rnd(p.seed+trial*100000+step)%6;step++;if(penalty)score=Math.max(0,score-die);else if(die!==6)score+=die;penalty=die===6;}a.ok(score>=p.target);total+=step;min=Math.min(min,step);max=Math.max(max,step);}a.deepEqual(e[0],[[p.trials,total/p.trials,min,max]]);}
S['II-17'].validate=(d,e,a)=>dice(d,e,a);check('II-17','Obiettivo 1, 100 partite: media/min/max confrontati con simulatore JS delle medesime estrazioni, nessuna partita troncata.',(e,d,a)=>dice(d,e,a));
function birthdays(d,e,a){const p=d.prepare('SELECT * FROM t1').get();let hits=0;for(let trial=1;trial<=p.trials;trial++){let days=new Set;for(let k=1;k<=p.people;k++)days.add(rnd(p.seed+trial*1000+k)%365);hits+=days.size<p.people;}a.deepEqual(e[0],[[p.trials,hits,hits/p.trials]]);if(p.people===23)a.ok(hits/p.trials>0.48&&hits/p.trials<0.54);}
S['II-18'].validate=(d,e,a)=>birthdays(d,e,a);check('II-18','Una persona: zero compleanni condivisi in 100 prove.',(e,d,a)=>birthdays(d,e,a));
function walk(d,e,a,eq){const p=d.prepare('SELECT * FROM t1').get();let counts=new Map;for(let trial=1;trial<=p.trials;trial++){let pos=0,visited=new Set([0]),step=0;while(visited.size<p.people-1&&step<10000){pos=(pos+(rnd(p.seed+trial*100000+step)%2===0?1:-1)+p.people)%p.people;visited.add(pos);step++;}a.equal(visited.size,p.people-1);const winner=Array.from({length:p.people},(_,i)=>i).find(x=>!visited.has(x));counts.set(winner,(counts.get(winner)||0)+1);}eq(e[0],[...counts]);a.ok(!counts.has(0));if(p.people===8)a.ok([...counts.values()].every(v=>v/p.trials>0.12&&v/p.trials<0.17));}
S['II-19'].validate=(d,e,a,eq)=>walk(d,e,a,eq);check('II-19','Due persone: il solo non host vince tutte le 100 prove.',(e,d,a,eq)=>walk(d,e,a,eq));
function markov(d,e,a){const p=d.prepare('SELECT * FROM t1').get();let rain=false,hits=0;for(let day=2;day<=p.days;day++){rain=rnd(p.seed+day-1)%100<(rain?70:50);hits+=rain;}a.deepEqual(e[0],[[p.days,hits,hits/p.days]]);if(p.days===100000)a.ok(Math.abs(hits/p.days-0.625)<0.015);}
S['II-20'].validate=(d,e,a)=>markov(d,e,a);check('II-20','Un solo giorno iniziale soleggiato: zero pioggia.',(e,d,a)=>markov(d,e,a));
function prisoners(d,e,a){const p=d.prepare('SELECT * FROM t1').get();let success=0;for(let t=1;t<=p.trials;t++){const perm=Array.from({length:p.prisoners},(_,i)=>i+1).sort((x,y)=>rnd(p.seed+t*1000+x)-rnd(p.seed+t*1000+y)||x-y);let seen=new Set,max=0;for(let i=1;i<=p.prisoners;i++){if(seen.has(i))continue;let cur=i,len=0;do{seen.add(cur);cur=perm[cur-1];len++;}while(cur!==i);max=Math.max(max,len);}success+=max<=Math.floor(p.prisoners/2);}a.deepEqual(e[0],[[p.trials,success,success/p.trials,p.prisoners]]);if(p.prisoners===100)a.ok(Math.abs(success/p.trials-0.3118278207)<0.03);}
S['II-21'].validate=(d,e,a)=>prisoners(d,e,a);check('II-21','Quattro prigionieri, 100 prove: confronto esatto con decomposizione JS dei cicli e limite due scatole.',(e,d,a)=>prisoners(d,e,a));
check('II-22','Nuovo ordine con solo costo 9: massimo zero set, combinazione NULL.',(e,d,a)=>a.deepEqual(e[0].find(r=>r[0]===6),[6,0,null]));
S['II-23'].validate=(d,e,a,eq)=>eq(e[0],[['5B'],['3B'],['6C'],['2C'],['6E'],['2E'],['5F'],['3F']]);
check('II-23','Dall’angolo 1A solo 2C e 3B.',(e,d,a,eq)=>eq(e[0],[['2C'],['3B']]));
