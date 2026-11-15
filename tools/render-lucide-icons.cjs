const fs=require('node:fs'),path=require('node:path');
const {Resvg}=require('@resvg/resvg-js');
const dir=path.resolve(__dirname,'../assets/icons/lucide');
const data=JSON.parse(fs.readFileSync(path.join(dir,'manifest.json'),'utf8'));
const keys=Object.keys(data.icons),cell=data.cellSize,columns=data.columns;
const width=columns*cell,height=Math.ceil(keys.length/columns)*cell;
const tiles=keys.map((key,index)=>{
 let svg=fs.readFileSync(path.join(dir,data.icons[key]+'.svg'),'utf8');
 svg=svg.replace(/\s(?:width|height)="[^"]*"/g,'').replace(/currentColor/g,'#ffffff');
 return svg.replace('<svg',`<svg x="${index%columns*cell+8}" y="${Math.floor(index/columns)*cell+8}" width="48" height="48"`);
});
const atlas=`<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}">${tiles.join('')}</svg>`;
fs.writeFileSync(path.resolve(__dirname,'../assets/mochi-lucide-v2.png'),new Resvg(atlas).render().asPng());
let paw=fs.readFileSync(path.join(dir,'paw-print.svg'),'utf8').replace(/currentColor/g,'#e88cb7');
paw=paw.replace(/width="24"/,'width="64"').replace(/height="24"/,'height="64"');
fs.writeFileSync(path.resolve(__dirname,'../assets/mochi-paw-v2.png'),new Resvg(paw).render().asPng());
console.log(`Rendered ${keys.length} Lucide icon slots into ${width}×${height} PNG atlas.`);
