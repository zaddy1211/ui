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
  const normalized=slice(block.start,block.end).replace(/BackgroundTransparency = 0\.\d+/g,'BackgroundTransparency = VISUAL').replace(/TextColor3 = T\.(Accent|MainBG|TextMain)\b/g,'TextColor3 = TEXT').replace(/Enum\.EasingStyle\.(Back|Quint)/g,'EASING').replace(/[ \t]+\n/g,'\n').replaceAll('KZ Scripts','Mochi Hub');
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
assert(source.includes('Scale.Scale = targetScale * (c.Reduced and 1 or .22)'));
assert(!source.includes('SpeechBubble')&&!source.includes('quick-love-v1'),'old talking loader or downloaded font override returned');
assert(source.includes('BackgroundColor3 = T.MainBG, BackgroundTransparency = .96,'),'global cream wash obscures the cat');
assert(source.includes('ArtworkVignette.BackgroundTransparency = .98'),'dark wash obscures the artwork');
assert(!source.includes('CornerRadius = UDim.new(1, 0)})\n__KZ_Cozy.OpenLogo'),'round mask returned on the cat silhouette');
assert(!slice('function __KZ_BackgroundMotion.Build()','function __KZ_BackgroundMotion.Start()').includes('while not destroyed'),'background particle loop returned');
for(const file of ['mochi-logo-v1.png','mochi-mark-v2.png','mochi-dreamscape-v1.png','mochi-paw-v2.png','mochi-lucide-v2.png']) {
  const png=fs.readFileSync(path.join(root,'assets',file));
  assert(png.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10])),'invalid PNG '+file);
  assert(png.readUInt32BE(16)>0&&png.readUInt32BE(20)>0);
}
for(const match of source.matchAll(/(?:File = |Asset\(|DownloadThemeArt\(|= )"(mochi-[\w-]+\.png)"/g))
  assert(fs.existsSync(path.join(root,'assets',match[1])),'missing referenced asset '+match[1]);
const lucide=JSON.parse(fs.readFileSync(path.join(root,'assets/icons/lucide/manifest.json'),'utf8'));
for(const name of Object.values(lucide.icons)) assert(fs.readFileSync(path.join(root,'assets/icons/lucide',name+'.svg'),'utf8').includes('<svg'),'missing SVG source '+name);
assert(fs.readFileSync(path.join(root,'assets/icons/lucide/LICENSE'),'utf8').includes('ISC License'),'missing icon license');
const atlas=fs.readFileSync(path.join(root,'assets/mochi-lucide-v2.png'));
assert(atlas.readUInt32BE(16)===512&&atlas.readUInt32BE(20)===256,'icon atlas cell layout differs');
console.log('PASS entry aliases, '+fields.length+' inherited API fields, dimensions, branding boundaries, five PNG assets and static decorations');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'mochi-tests-'));
try {
  const syncStart=source.indexOf('function __KZ_Cozy.SyncBrandLogo()'),syncEnd=source.indexOf('\nend',syncStart)+4;
  const clickStart=source.indexOf('OpenButton.MouseButton1Click:Connect(function()'),clickEnd=source.indexOf('\nend)',clickStart)+5;
  const reopen=fs.readFileSync(path.join(__dirname,'reopen-cases.luau'),'utf8').replace('-- INSERT REOPEN HANDLERS',
    slice('local openButtonDragging = false','\nlocal DropdownLayer =')+'\n'+source.slice(clickStart,clickEnd));
  const bundle=path.join(temp,'lifecycle.luau');
  fs.writeFileSync(bundle,fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8')+'\n'+
    slice('-- Mochi loading host.','\n__KZ_Cozy.Begin()\n__KZ_Cozy.UIFont.Start()')+'\n'+source.slice(syncStart,syncEnd)+'\n'+
    slice('function __KZ_Cozy.GetDockRect(targetScale)','table.insert(connections, RunService.RenderStepped:Connect(__KZ_Cozy.SyncBrandLogo))')+'\n'+
    fs.readFileSync(path.join(__dirname,'intro-cases.luau'),'utf8')+'\n'+reopen);
  const configBundle=path.join(temp,'migration.luau');
  fs.writeFileSync(configBundle,fs.readFileSync(path.join(__dirname,'migration-cases.luau'),'utf8')
    .replace('-- INSERT MIGRATION',slice('    local function ensureTree()','    local function sanitize('))
    .replace('-- INSERT THEME NORMALIZER',slice('function __KZ_Cozy.ThemeName(value)','\ndo\n    local c = __KZ_Cozy')));
  const motionBundle=path.join(temp,'motion.luau');
  fs.writeFileSync(motionBundle,fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8')+'\n'+
    fs.readFileSync(path.join(__dirname,'motion-cases.luau'),'utf8')
      .replace('-- INSERT TWEEN ENGINE',slice('__KZ_Cozy.Tweens = setmetatable','-- Keep UI out of PlayerGui'))
      .replace('-- INSERT TAB HANDLER',slice('local function __KZ_SelectPage(name)','NavScroll:GetPropertyChangedSignal'))
      .replace('-- INSERT WINDOW HANDLER',slice('local function __KZ_SetOpen(open)','MinimizeButton.MouseButton1Click')));
  const typographyBundle=path.join(temp,'typography.luau');
  fs.writeFileSync(typographyBundle,fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8')+'\n'+
    fs.readFileSync(path.join(__dirname,'typography-cases.luau'),'utf8')
      .replace('-- INSERT NATIVE TYPOGRAPHY',slice('-- UI-local native typography;','local function New(')));
  const visualBundle=path.join(temp,'visuals.luau');
  fs.writeFileSync(visualBundle,fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8')+'\n'+
    fs.readFileSync(path.join(__dirname,'visual-cases.luau'),'utf8')
      .replace('-- INSERT PALETTES',slice('local ICONS = {','\ndo\n    local c = __KZ_Cozy'))
      .replace('-- INSERT ICON ALIASES',slice('local __KZ_IconAliases = {','local function __KZ_UpdateNavSelectionGlow'))
      .replace('-- INSERT TAB ICON RESOLVER',slice('function __KZ_Cozy.ResolveTabIcon(name, icon)','local function __KZ_AddNav'))
      .replace('-- INSERT ICON CELLS',slice('__KZ_Cozy.NavIcons, __KZ_Cozy.IconLookup = {}, {}','__KZ_AddNav("Home"')));
  const sessionBundle=path.join(temp,'sessions.luau');
  fs.writeFileSync(sessionBundle,fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8')+'\n'+
    fs.readFileSync(path.join(__dirname,'session-cases.luau'),'utf8')
      .replace('-- INSERT SERIALIZATION',slice('    local function encode(value)','    function CM.Register('))
      .replace('-- INSERT SESSION CONFIG',slice('    -- Session snapshots contain feature values only','    ensureTree()\n    return CM'))
      .replace('-- INSERT CONFIG LIST',slice('    function CM.List()','    function CM.Save('))
      .replace('-- INSERT SESSION CONTROLLER',slice('-- Previous-session consent.','local __KZ_WindowGui = Window')));
  const homeBundle=path.join(temp,'home.luau');
  fs.writeFileSync(homeBundle,fs.readFileSync(path.join(__dirname,'intro-harness.luau'),'utf8')+'\n'+
    fs.readFileSync(path.join(__dirname,'home-cases.luau'),'utf8')
      .replace('-- INSERT INFO ROW',slice('local function HomeInfoRow(','local function HomeStatCard('))
      .replace('-- INSERT FAVORITES',slice('-- Home favorites and reminders share','-- Active features'))
      .replace('-- INSERT REGISTRATION',slice('    function CM.Register(','    function CM.List(')));
  for(const file of [bundle,configBundle,motionBundle,typographyBundle,visualBundle,sessionBundle,homeBundle]) {
    const run=cp.spawnSync(process.env.LUAU_BIN||'luau',[file],{encoding:'utf8'});
    process.stdout.write(run.stdout||''); process.stderr.write(run.stderr||'');
    if(run.error) throw run.error;
    assert.equal(run.status,0,'Luau behavioral tests failed');
  }
} finally {fs.rmSync(temp,{recursive:true,force:true});}
