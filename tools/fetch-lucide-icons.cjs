// Sources are pinned so future rebuilds cannot silently change the icon set.
const fs=require('node:fs'),path=require('node:path');
const commit='55782beff3a0133df79c417eb68f96e8f19e2404';
const icons={Home:'house',QB:'crosshair',Catching:'hand',Kicker:'footprints',Player:'user-round',Physics:'atom',Visual:'eye',Defense:'shield',Automatics:'zap',Trolling:'cat',Misc:'boxes',World:'globe',Settings:'settings-2',Search:'search',Close:'x',Minimize:'minus',Chevron:'chevron-right',Paw:'paw-print',Scripts:'code-xml',Combat:'swords',Players:'users',Visuals:'scan-eye',Movement:'person-standing',Teleport:'navigation',ESP:'scan-eye',Main:'house',Config:'sliders-horizontal',Info:'info',Favorites:'heart',Active:'activity',CatchingAssist:'hand',Kicking:'footprints'};
const dir=path.resolve(__dirname,'../assets/icons/lucide');
async function main(){
 fs.mkdirSync(dir,{recursive:true});
 await Promise.all([...new Set(Object.values(icons))].map(async name=>{
  const url=`https://raw.githubusercontent.com/lucide-icons/lucide/${commit}/icons/${name}.svg`;
  const res=await fetch(url);if(!res.ok)throw Error(`${name}: ${res.status}`);
  const svg=await res.text();if(!svg.includes('<svg'))throw Error('Invalid SVG '+name);
  fs.writeFileSync(path.join(dir,name+'.svg'),svg);
 }));
 const license=await fetch(`https://raw.githubusercontent.com/lucide-icons/lucide/${commit}/LICENSE`);
 if(!license.ok)throw Error('License unavailable');
 fs.writeFileSync(path.join(dir,'LICENSE'),await license.text());
 fs.writeFileSync(path.join(dir,'manifest.json'),JSON.stringify({source:'https://lucide.dev/icons/',repository:'lucide-icons/lucide',commit,columns:8,cellSize:64,icons},null,2)+'\n');
 console.log('Downloaded pinned Lucide SVGs and license for '+Object.keys(icons).length+' icon slots.');
}
main().catch(e=>{console.error(e);process.exitCode=1;});
