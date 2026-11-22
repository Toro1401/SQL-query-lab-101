const path=require('node:path');
process.chdir(__dirname);
const fs=require('node:fs'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {DatabaseSync}=require('node:sqlite');
const {S}=require('./solutions.cjs');
require('./checks.cjs');
require('./checks-II.cjs');
const {rnd,bitcount}=require('./random.cjs');
const fixtures=JSON.parse(fs.readFileSync('fixtures.json'));
const q=x=>'"'+x.replaceAll('"','""')+'"';
function make(f){const db=new DatabaseSync(':memory:');db.exec('PRAGMA foreign_keys=ON;');db.function('forbid_star',()=>{throw new Error('Explicit columns required');});db.function('rnd',{deterministic:true},rnd);db.function('bitcount',{deterministic:true},bitcount);db.function('sha256',x=>crypto.createHash('sha256').update(x).digest('hex'));db.function('crc32',x=>{let c=0xffffffff;for(const v of Buffer.from(x)){c^=v;for(let i=0;i<8;i++)c=(c>>>1)^((c&1)?0xedb88320:0);}return (c^0xffffffff)>>>0;});db.exec(fs.readFileSync(path.join(__dirname,'setup',f.id+'.sql'),'utf8'));return db;}
function run(db,sql){const out=[];for(const statement of sql.trim().split(/;\r?\n/)){if(!statement.trim())continue;const st=db.prepare(statement);if(st.columns().length){st.setReturnArrays(true);out.push(st.all());}else st.run();}return out;}
function norm(v){if(Array.isArray(v))return v.map(norm);return typeof v==='number'?Math.round(v*1e6)/1e6:v;}
const bag=r=>r.map(x=>JSON.stringify(norm(x))).sort();
function eq(actual,expected,ordered=false){assert.deepEqual(ordered?norm(actual):bag(actual),ordered?norm(expected):bag(expected));}
const overrides={
 'I-10':[[[342/11,14,10,85]]],
 'I-26':[[[352645,420219,523111]]],
 'I-31':[[[3762]],[[3762]],[[3762]],[[150000]]],
 'I-46':[[[2002]],[[2002]]],
 'II-10':[[[1,6],[8,12],[16,26],[36,51]],[[38]],[['Even Numbers',7],['Odd Numbers',9]]]
};
overrides['II-22']=[fixtures['II-22'].expected[0].concat([[1,3,'(1,5),(2,6),(3,4)'],[1,3,'(1,6),(2,5),(3,4)']])];
const notes={
 'I-26':"Source correction: 159521 + 251696 + 111894 = 523111 for 2016. The expected value of 411217 omits 111894.",
 'II-10':"Source correction: the 16 occupied seats include 7 even and 9 odd. The source lists 8 even seats. I-18 gives the same corrected count.",
 'II-22':"The expected table omits two valid optimal solutions for order 1: (1,5),(2,6),(3,4) and (1,6),(2,5),(3,4). Both have three disjoint groups, with a cost of at least 10 and at most two items per group. The corrected comparison includes both. For order 5, each solution has one group, while the source comment says two."
};
let report=[];
const selected=process.argv[2];
if(selected&&!S[selected])throw new Error('Unknown exercise: '+selected);
for(const [id,s] of Object.entries(S)){
 if(selected&&selected!==id)continue;
 const part='part-'+id.split('-')[0].toLowerCase();
 const entry=fs.readFileSync(path.join(__dirname,'exercises',part,id+'.md'),'utf8').replaceAll('\r\n','\n');
 const embedded=entry?.match(/```sql\n([\s\S]*?)\n```/)?.[1];
 assert.equal(embedded?.trim(),s.sql.trim(),'Exercise page/SQL mismatch: '+id);
 const f=fixtures[id];if(!f)throw new Error('fixture missing '+id);
 let db=make(f),rec={id,status:'FAIL'};
 try{
 const actual=run(db,s.sql);const expected=overrides[id]??f.expected;
 if(expected.length){assert.equal(actual.length,expected.length,'result sets');for(let i=0;i<actual.length;i++)eq(actual[i],expected[i],id==='I-40');}
 else if(!s.validate)throw new Error('Missing independent acceptance check');
 if(s.validate)s.validate(db,actual,assert,eq);
 rec.actual=actual;rec.sourceNote=notes[id]??s.note??null;
 if(s.edge){const edb=make(f);edb.exec(s.edge);const edge=run(edb,s.sql);if(!s.checkEdge)throw new Error('Missing edge acceptance check');s.checkEdge(edge,edb,assert,eq,actual);rec.edgeActual=edge;rec.edge=s.edge;edb.close();}
 else if(!s.validate)throw new Error('Missing edge case');
 rec.status='PASS';
 }catch(e){rec.error=e.message;}
 db.close();report.push(rec);console.log(id,rec.status,rec.error?.slice(0,450)??'');
}
const probe=new DatabaseSync(':memory:');
const engine=probe.prepare('SELECT sqlite_version() v').get().v;probe.close();
const result={engine:'SQLite '+engine,node:process.version,verifiedAtUtc:new Date().toISOString(),passed:report.filter(x=>x.status==='PASS').length,total:report.length,exercises:report};
fs.writeFileSync('verification/'+(selected?selected+'-results':'results')+'.json',JSON.stringify(result,null,2));
console.log(`${report.filter(x=>x.status==='PASS').length}/${report.length} passed`);
if(report.some(x=>x.status!=='PASS'))process.exitCode=1;
module.exports={make,run,eq,report,notes};
