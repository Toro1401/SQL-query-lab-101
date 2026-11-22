const fs=require('node:fs'),path=require('node:path');
const S=require('./solutions.json');
for(const [id,s] of Object.entries(S))s.sql=fs.readFileSync(path.join(__dirname,'sql',id+'.sql'),'utf8').replaceAll('\r\n','\n').trim();
module.exports={S};
