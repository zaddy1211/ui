const fs=require('node:fs'), os=require('node:os'), path=require('node:path'), assert=require('node:assert/strict'), cp=require('node:child_process');
const root=path.resolve(__dirname,'..');
const source=fs.readFileSync(path.join(root,'UniversalUI.lua'),'utf8').replace(/\r\n/g,'\n');
function slice(start,end) {
  const a=source.indexOf(start),b=source.indexOf(end,a+start.length);
  assert(a>=0&&b>a,'missing implementation boundary: '+start);
  return source.slice(a,b);
}
const crypto=require('node:crypto');
const preserved=JSON.parse(fs.readFileSync(path.join(__dirname,'behavior-baseline.json'),'utf8'));
for(const block of preserved.blocks) {
  const normalized=slice(block.start,block.end).replace(/BackgroundTransparency = 0\.\d+/g,'BackgroundTransparency = VISUAL').replace(/TextColor3 = T\.(Accent|MainBG|TextMain)\b/g,'TextColor3 = TEXT').replace(/[ \t]+\n/g,'\n').replaceAll('KZ Scripts','Mochi Hub');
  assert.equal(crypto.createHash('sha256').update(normalized).digest('hex'),block.sha256,'working behavior changed: '+block.name);
}
console.log('PASS '+preserved.blocks.length+' inherited behavior blocks preserved (only presentation and whitespace normalized)');
assert.equal(source,fs.readFileSync(path.join(root,'universal ui'),'utf8').replace(/\r\n/g,'\n'),'entry aliases differ');
const fields=JSON.parse(fs.readFileSync(path.join(__dirname,'api-baseline.json'),'utf8')).publicFields;
for(const name of fields) assert(source.includes(name+' ='),'public API removed: '+name);
assert(source.includes('UDim2.fromOffset(900, 540)'),'window dimensions changed');
assert(source.includes('Root = "MochiHub"')&&source.includes('local ASSET_ROOT = "MochiHub"'));
assert(!source.includes('test-ui-thing/main/'),'source repository asset dependency');
assert(!/kz-[\w-]+\.(png|jpg)/i.test(source),'legacy artwork returned');
assert(!/Text = "KZ|KZ Scripts  [|/]/.test(source),'legacy visible branding returned');
assert(source.includes('welcome to Mochi Hub <3\\ngetting everything cozy for you.'));
assert(source.includes('Scale.Scale = GetTargetScale() * (__KZ_Cozy.Reduced and 1 or .97)'));
assert(!slice('function __KZ_BackgroundMotion.Build()','function __KZ_BackgroundMotion.Start()').includes('while not destroyed'),'background particle loop returned');
for(const file of ['mochi-logo-v1.png','mochi-mascot-v1.png','mochi-compact-v1.png','mochi-dreamscape-v1.png','mochi-paw-v1.png','mochi-icons-v1.png']) {
  const png=fs.readFileSync(path.join(root,'assets',file));
  assert(png.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10])),'invalid PNG '+file);
  assert(png.readUInt32BE(16)>0&&png.readUInt32BE(20)>0);
}
for(const match of source.matchAll(/(?:File = |Asset\(|DownloadThemeArt\(|= )"(mochi-[\w-]+\.png)"/g))
  assert(fs.existsSync(path.join(root,'assets',match[1])),'missing referenced asset '+match[1]);
console.log('PASS entry aliases, '+fields.length+' inherited API fields, dimensions, branding boundaries, six PNG assets and static decorations');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'mochi-tests-'));
try {
  const syncStart=source.indexOf('function __KZ_Cozy.SyncBrandLogo()'),syncEnd=source.indexOf('\nend',syncStart)+4;
  const clickStart=source.indexOf('OpenButton.MouseButton1Click:Connect(function()'),clickEnd=source.indexOf('\nend)',clickStart)+5;
  const reopen=fs.readFileSync(path.join(__dirname,'reopen-cases.luau'),'utf8').replace('-- INSERT REOPEN HANDLERS',
    slice('local openButtonDragging = false','\nlocal DropdownLayer =')+'\n'+source.slice(clickStart,clickEnd));
  const bundle=path.join(temp,'lifecycle.luau');
  fs.writeFileSync(bundle,fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8')+'\n'+
    slice('-- Mochi loading host.','\n__KZ_Cozy.Begin()\n__KZ_Cozy.UIFont.Start()')+'\n'+source.slice(syncStart,syncEnd)+'\n'+
    fs.readFileSync(path.join(__dirname,'intro-cases.luau'),'utf8')+'\n'+reopen);
  const configBundle=path.join(temp,'migration.luau');
  fs.writeFileSync(configBundle,fs.readFileSync(path.join(__dirname,'migration-cases.luau'),'utf8')
    .replace('-- INSERT MIGRATION',slice('    local function ensureTree()','    local function sanitize('))
    .replace('-- INSERT THEME NORMALIZER',slice('function __KZ_Cozy.ThemeName(value)','\ndo\n    local c = __KZ_Cozy')));
  for(const file of [bundle,configBundle]) {
    const run=cp.spawnSync(process.env.LUAU_BIN||'luau',[file],{encoding:'utf8'});
    process.stdout.write(run.stdout||''); process.stderr.write(run.stderr||'');
    if(run.error) throw run.error;
    assert.equal(run.status,0,'Luau behavioral tests failed');
  }
} finally {fs.rmSync(temp,{recursive:true,force:true});}
