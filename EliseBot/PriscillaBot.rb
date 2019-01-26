@shardizard = ARGV.first.to_i              # taking a single variable from the command prompt to get the shard value
system("color 0#{"7CBAE"[@shardizard,1]}") # command prompt color and title determined by the shard
system("title loading #{['Transparent','Scarlet','Azure','Verdant','Golden'][@shardizard]} EliseBot")

require 'discordrb'                    # Download link: https://github.com/meew0/discordrb
require 'open-uri'                     # pre-installed with Ruby in Windows
require 'net/http'                     # pre-installed with Ruby in Windows
require 'certified'
require 'tzinfo/data'                  # Downloaded with active_support below, but the require must be above active_support's require
require 'rufus-scheduler'              # Download link: https://github.com/jmettraux/rufus-scheduler
require 'active_support/core_ext/time' # Download link: https://rubygems.org/gems/activesupport/versions/5.0.0
require_relative 'rot8er_functs'       # functions I use commonly in bots
load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'

# this is required to get her to change her avatar on certain holidays
ENV['TZ'] = 'America/Chicago'
@scheduler = Rufus::Scheduler.new

# All the possible command prefixes, not case insensitive so I have to fake it by including every combination of lower- and upper-case
@prefix = ['FEH!','FEh!','FeH!','Feh!','fEH!','fEh!','feH!','feh!',
           'FEH?','FEh?','FeH?','Feh?','fEH?','fEh?','feH?','feh?',
           'f?','F?','e?','E?','h?','H?']

# The bot's token is basically their password, so is censored for obvious reasons
if @shardizard==4
  bot = Discordrb::Commands::CommandBot.new token: '>Debug Token<', client_id: 431895561193390090, prefix: @prefix
else
  bot = Discordrb::Commands::CommandBot.new token: '>Main Token<', shard_id: @shardizard, num_shards: 4, client_id: 312451658908958721, prefix: @prefix
end
bot.gateway.check_heartbeat_acks = false

# initialize global variables
@units=[]
@skills=[]
@structures=[]
@accessories=[]
@itemus=[]
@aliases=[]
@multi_aliases=[]
@groups=[]
@embedless=[]
@ignored=[]
@banner=[]
@server_data=[[0,0,0,0],[0,0,0,0]]
@server_markers=[]
@x_markers=[]
@max_rarity_merge=[5,10]
@dev_waifus=[]
@dev_somebodies=[]
@dev_nobodies=[]
@dev_units=[]
@bonus_units=[]
@avvie_info=['Elise','*Fire Emblem Heroes*','N/A']
@stored_event=nil
@zero_by_four=[0,0,0,'']
@last_multi_reload=[0,0]
@headpats=[0,0,0]
@rarity_stars=['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>',
               '<:Icon_Rarity_4:448266418459377684>','<:Icon_Rarity_5:448266417553539104>','<:Icon_Rarity_6:491487784650145812>']
@summon_servers=[330850148261298176,389099550155079680,256291408598663168,271642342153388034,285663217261477889,280125970252431360,356146569239855104,
                 393775173095915521,341729526767681549,380013135576432651,383563205894733824,374991726139670528,338856743553597440,297459718249512961,
                 283833293894582272,305889949574496257,214552543835979778,332249772180111360,334554496434700289,306213252625465354,197504651472535552,
                 347491426852143109,392557615177007104,295686580528742420,412303462764773376,442465051371372544,353997181193289728,462100851864109056,
                 337397338823852034,446111983155150875,295001062790660097,328109510449430529,483437489021911051,513061112896290816,327599133210705923]
@summon_rate=[0,0,3]
@spam_channels=[]
@mods=[[ 0, 0, 0, 0, 0, 0, 0],
       [ 1, 1, 1, 1, 1, 1, 2],
       [ 2, 3, 3, 3, 3, 4, 4],
       [ 4, 4, 5, 5, 6, 6, 7],
       [ 5, 6, 7, 7, 8, 8, 9], # this is a translation of the graphic displayed in the "growths" command.
       [ 7, 8, 8, 9,10,10,11],
       [ 8, 9,10,11,12,13,14],
       [10,11,12,13,14,15,16],
       [12,13,14,15,16,17,18],
       [13,14,15,17,18,19,21],
       [15,16,17,19,20,22,23],
       [16,18,19,21,22,24,25],
       [18,19,21,23,24,26,28],
       [19,21,23,25,26,28,30],
       [21,23,25,27,28,30,32],
       [23,24,26,29,31,33,35],
       [24,26,28,31,33,35,37],
       [26,28,30,33,35,37,39],
       [27,30,32,35,37,39,42],
       [29,31,34,37,39,42,44],
       [30,33,36,39,41,44,47]]
@natures=[['Gentle','Resistance','Defense'], # this is a list of all the nature names that can be displayed, with the affected stats
          ['Bold','Defense','Attack'],
          ['Timid','Speed','Attack'],
          ['Lonely','Attack','Defense'],
          ['Mild','Attack','Defense'],
          ['Hasty','Speed','Defense'],
          ['Impish','Defense','Attack'],       # entries with "true" at the end cannot be typed in by end users but can be displayed, other entries can do both
          ['Calm','Resistance','Attack',true], # "Calm" cannot be typed in due to it meaning something different between FE and Pokemon (where the nature names come from)
          ['Careful','Resistance','Attack'],
          ['Jolly','Speed','Attack'],
          ['Naive','Speed','Resistance'],
          ['Naughty','Attack','Resistance'],
          ['Lax','Defense','Resistance'],
          ['Rash','Attack','Resistance'],
          ['Relaxed','Defense','Speed'],
          ['Brave','Attack','Speed',true], # "Brave" cannot be typed due to it being both a unit classification and a weapon classification
          ['Quiet','Attack','Speed'],
          ['Sassy','Resistance','Speed'],
          ["`\u22C0`Strong",'Attack','HP',true],
          ["`\u22C0`Clever",'Attack','HP',true],
          ["`\u22C0`Quick",'Speed','HP',true],
          ["`\u22C0`Sturdy",'Defense','HP',true],
          ["`\u22C0`Robust",'Resistance','HP',true],
          ["`\u22C1`Weak",'HP','Attack',true],
          ["`\u22C1`Dull",'HP','Attack',true],
          ["`\u22C1`Sluggish",'HP','Speed',true],
          ["`\u22C1`Fragile",'HP','Defense',true],
          ["`\u22C1`Excitable",'HP','Resistance',true]]

def all_commands(include_nil=false,permissions=-1) # a list of all the command names.  Used by Nino Mode to ignore messages that are commands, so responses do not double up.
  k=['stat','unit','sort','data','find','wiki','tier','help','addalias','skill','aliases','flowers','seealiases','checkaliases','sendmessage','addgroup','next',
     'effect','commands','sendpm','search','bugreport','skills','stats','flowers','flower','deletealias','removealias','seegroups','checkgroups','groups','long',
     'deletegroup','commandlist','command_list','removegroup','removemember','removefromgroup','embeds','embed','natures','invite','sendpm','ignoreuser','gp',
     'leaveserver','snagstats','reboot','stats','today_in_feh','todayinfeh','devedit','dev_edit','summon','study','list','bst','effHP','effhp','eff_hp','bulk',
     'eff_HP','refine','refinery','average','mean','tools','compare','comparison','today','daily','fodder','status','growths','growth','gps','serveraliases',
     'whyelise','random','bestin','bestamong','bestatats','stat','merges','setmarker','backup','studystat','studystats','higheststats','worstamong','score',
     'worstin','worststats','loweststats','healstudy','studyheal','heal_study','study_heal','games','feedback','statstudy','dualalias','suggestion','statlist',
     'legendary','legendaries','patpat','pat','statsskills','statskills','stats_skills','stat_skills','statsandskills','statandskills','snagchannels','color',
     'removemulti','stats_and_skills','stat_and_skills','statsskill','statskill','stats_skill','stat_skill','statsandskill','statandskill','stats_and_skill',
     'removedualunitalias','addmulti','stat_and_skill','shard','procstudy','studyproc','proc_study','study_proc','phasestudy','studyphase','phase_study','huge',
     'study_phase','compareskills','removemultiunitalias','compareskill','skillcompare','skillscompare','comparisonskills','comparisonskill','skillcomparison',
     'skillscomparison','compare_skills','compare_skill','removedualalias','skill_compare','skills_compare','comparison_skills','comparison_skill','listunit',
     'skill_comparison','skills_comparison','skillsincommon','skills_in_common','removemultialias','commonskills','common_skills','locate','locateshard','big',
     'links','art','skillrarity','onestar','twostar','threestar','fourstar','fivestar','deletemulti','skill_rarity','one_star','two_star','three_star','colors',
     'four_star','five_star','summonpool','summon_pool','pool','allinheritance','allinherit','deletedualunitalias','multialias','allinheritable','avatar','safe',
     'skillinheritance','skillinherit','skillinheritable','skilllearn','skilllearnable','skillsinheritance','skillsinherit','deletemultiunitalias','avvie','tol',
     'addualunitalias','skillsinheritable','skillslearn','skillslearnable','inheritanceskills','inheritskill','inheritableskill','learnskill','learnableskill',
     'deletedualalias','adddualunitalias','inheritanceskills','inheritskills','inheritableskills','learnskills','learnableskills','all_inheritance','sortunit',
     'all_inherit','all_inheritable','deletemultialias','addmultiunitalias','skill_inheritance','skill_inherit','skill_inheritable','skill_learn','unitlist',
     'skill_learnable','skills_inheritance','skills_inherit','skills_inheritable','addualalias','adddualalias','skills_learn','skills_learnable','saliases',
     'inheritance_skills','inherit_skill','inheritable_skill','learn_skill','learnable_skill','inheritance_skills','addmultialias','schedule','inherit_skills',
     'inheritable_skills','learn_skills','learnable_skills','inherit','learn','inheritance','learnable','inheritable','skillearn','banners','banner','unitsort',
     'skillearnable','alts','alt','reload','colours','colour','tinystats','smallstats','smolstats','microstats','squashedstats','sstats','unitslist','macro',
     'statstiny','statssmall','statssmol','statsmicro','statssquashed','statss','stattiny','statsmall','statsmol','statmicro','statsquashed','sstat','tinystat',
     'smallstat','smolstat','microstat','squashedstat','tiny','small','micro','smol','squashed','littlestats','littlestat','statslittle','statlittle','little',
     'giantstats','bigstats','tolstats','macrostats','largestats','hugestats','massivestats','giantstat','bigstat','tolstat','macrostat','largestat','hugestat',
     'massivestat','statsgiant','statsbig','statstol','statsmacro','statslarge','statshuge','statsmassive','statgiant','statbig','stattol','statmacro','large',
     'statlarge','stathuge','statmassive','statol','giant','massive','spam','safetospam','safe2spam','listunits','sortunits','unitssort','liststat','rand',
     'longreplies','sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist','sortstats','statssort','worst',
     'sortstat','statsort','liststats','statslist','highest','best','highestamong','highestin','lowest','lowestamong','lowestin','manual','book','combatmanual',
     'headpat','pat','patpat','randomunit','randunit','unitrandom','unitrand','randomstats','statsrand','statsrandom','randstats','edit','bonus','arena','tt',
     'arenabonus','arena_bonus','bonusarena','bonus_arena','tempest','tempestbonus','tempest_bonus','bonustempest','bonus_tempest','ttbonus','tt_bonus','skils',
     'bonustt','bonus_tt','oregano','whoisoregano','statsskils','statskils','stats_skils','stat_skils','statsandskils','statandskils','stats_and_skils','skil',
     'stat_and_skils','statsskil','statskil','stats_skil','stat_skil','statsandskil','statandskil','stats_and_skil','stat_and_skil','sortskil','skilsort',
     'sortskils','skilssort','listskil','skilist','skilist','listskils','skilslist','artist','channellist','chanelist','spamchannels','spamlist','aetherbonus',
     'aether_bonus','aethertempest','aether_tempest','raid','raidbonus','raid_bonus','bonusraid','bonus_raid','raids','raidsbonus','raids_bonus','bonusraids',
     'aether','bonus_raids','structure','struct','tool','link','resources','resources','mythical','mythic','mythicals','mythics','mystic','mystics','legend',
     'legends','legendarys','item','accessory','acc','accessorie','alias','s2s','dailies','tomorrow','tommorrow','tomorow','tommorow'].uniq
  if permissions==0
    k=all_commands(false)-all_commands(false,1)-all_commands(false,2)
  elsif permissions==1
    k=['addalias','deletealias','removealias','addgroup','deletegroup','removegroup','removemember','removefromgroup']
  elsif permissions==2
    k=['reboot','addmultialias','adddualalias','addualalias','addmultiunitalias','adddualunitalias','addualunitalias','multialias','dualalias','addmulti',
       'deletemultialias','deletedualalias','deletemultiunitalias','deletedualunitalias','deletemulti','removemultialias','removedualalias','dev_edit','devedit',
       'removemultiunitalias','removedualunitalias','removemulti','removefrommultialias','removefromdualalias','removefrommultiunitalias','backup',
       'removefromdualunitalias','removefrommulti','sendpm','ignoreuser','sendmessage','leaveserver','cleanupaliases','setmarker','snagchannels','reload']
  end
  k.unshift(nil) if include_nil
  return k
end

def data_load() # loads the character and skill data from the files on my computer
  # UNIT DATA
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHUnits.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHUnits.txt').each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  bob4=[]
  @units=[]
  for i in 0...b.length
    bob4=[]
    b[i].each_line('\\'[0,1]) {|s| bob4.push(s[0,s.length-1])}
    bob4[1]=bob4[1].split(', ') # weapon classification is actually a two-part entry (three-part for mages)
    if bob4[2].length>1 # Legendary Hero type is a two-part entry
      bob4[2]=bob4[2].split(', ')
    else
      bob4[2]=[' ',' ']
    end
    if bob4.length>4
      bob4[4]=bob4[4].split(', ')
      bob4[5]=bob4[5].split(', ')
      for j in 0...5 # growth rates and level 40 stats should be stored as numbers, not strings
        bob4[4][j]=bob4[4][j].to_i
        bob4[5][j]=bob4[5][j].to_i
      end
    end
    if bob4.length>8 # the list of games should be spliced into an array of game abbreviations
      if bob4[9].length>1
        bob4[9]=bob4[9].split(', ')
      else
        bob4[9]=['-']
      end
    end
    if bob4.length>10 # the list of games should be spliced into an array of game abbreviations
      if bob4[11].length>1
        bob4[11]=bob4[11].split(', ')
      else
        bob4[11]=[' ']
      end
    end
    if bob4.length>12
      if bob4[13].nil? # server-specific units' markers should be split into two pieces - the server(s) they are allowed in, and the ID of the user whose avatar to use
        bob4[13]=[]
      else
        bob4[13]=[bob4[13].scan(/[[:alpha:]]+?/).join, bob4[13].gsub(bob4[13].scan(/[[:alpha:]]+?/).join,'').to_i]
      end
    end
    @units.push(bob4)
  end
  # SKILL DATA
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkills.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkills.txt').each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  bob4=[]
  @skills=[]
  for i in 0...b.length
    bob4=[]
    b[i].each_line('\\'[0,1]) {|s| bob4.push(s[0,s.length-1])}
    bob4[1]=bob4[1].to_i                     # SP cost should be stored as a number...
    bob4[2]=bob4[2].to_i unless bob4[2]=='-' # ...as should the Might or Cooldown
    bob4[9]=bob4[9].split('; ')   # the list of units that know a skill by default should be split into lists based on rarity...
    bob4[10]=bob4[10].split('; ') # ...as should the list of units who can learn a skill without inheritance
    bob4[12]=bob4[12].split(',').map{|q| q.to_i} if bob4[4]=='Weapon' # stats affected by the weapon, split into a list and turned from strings into numbers
    bob4[13]=nil unless bob4[13].nil? || bob4[13].length>0 # tag for server-specific skills
    bob4[14]=nil unless bob4[14].nil? || bob4[14].length>0 # this entry is used by weapons to store their evolutions, and by healing staves to store their healing formula
    bob4[15]=nil unless bob4[15].nil? || bob4[15].length>0 # this entry is used by weapons to store their refinement data
    @skills.push(bob4)
  end
  # STRUCTURE DATA
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStructures.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStructures.txt').each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  for i in 0...b.length
    b[i]=b[i].gsub("\n",'').split('\\'[0])
    b[i][1]=b[i][1].to_i unless b[i][1]=='-'
    b[i][5]=b[i][5].split(', ').map{|q| q.to_i}
    b[i][6]=b[i][6].to_i
  end
  @structures=b.map{|q| q}
  # ACCESSORY DATA
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHAccessories.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHAccessories.txt').each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  for i in 0...b.length
    b[i]=b[i].gsub("\n",'').split('\\'[0])
  end
  @accessories=b.map{|q| q}
  # ITEM DATA
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHItems.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHItems.txt').each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  for i in 0...b.length
    b[i]=b[i].gsub("\n",'').split('\\'[0])
    b[i][2]=longFormattedNumber(b[i][2].to_i) if b[i][2].to_i.to_s==b[i][2]
  end
  @itemus=b.map{|q| q}
end

def nicknames_load() # loads the nickname list
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  @aliases=b.reject{|q| q.nil? || q[1].nil?}.uniq
  nzzzz=b.reject{|q| q.nil? || q[2].nil? || q[0]!='Unit'}.uniq
  nzzzz2=b.reject{|q| q.nil? || q[2].nil? || q[0]!='Skill'}.uniq
  nzzzz3=b.reject{|q| q.nil? || q[2].nil? || q[0]!='Structure'}.uniq
  if nzzzz[nzzzz.length-1][2]<'Zephiel' || nzzzz2[nzzzz2.length-1][2]<'Yato' || nzzzz3[nzzzz3.length-1][2]<'Armor School'
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt')
      b=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt').each_line do |line|
        b.push(eval line)
      end
    else
      b=[]
    end
    nzzzzz=b.reject{|q| q.nil? || q[2].nil? || q[0]!='Unit'}.uniq
    nzzzzz2=b.reject{|q| q.nil? || q[2].nil? || q[0]!='Skill'}.uniq
    nzzzzz3=b.reject{|q| q.nil? || q[2].nil? || q[0]!='Structure'}.uniq
    nzzzzz4=b.reject{|q| q.nil? || q[2].nil? || ['Unit','Skill','Structure'].include?(q[0])}.uniq
    if nzzzzz[nzzzzz.length-1][2]<'Zephiel' || nzzzzz2[nzzzzz2.length-1][2]<'Yato' || nzzzzz3[nzzzzz3.length-1][2]<'Armor School'
      puts 'Last backup of the alias list has been corrupted.  Restoring from manually-created backup.'
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames3.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames3.txt').each_line do |line|
          b.push(eval line)
        end
      else
        b=[]
      end
      nzzzzz=b.reject{|q| q.nil? || q[1].nil?}.uniq
    else
      puts 'Last backup of the alias list being used.'
    end
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}"
      end
      for i in 0...nzzzzz2.length
        f.puts "#{nzzzzz2[i].to_s}#{"\n" if i<nzzzzz2.length-1}"
      end
      for i in 0...nzzzzz3.length
        f.puts "#{nzzzzz3[i].to_s}#{"\n" if i<nzzzzz3.length-1}"
      end
      for i in 0...nzzzzz4.length
        f.puts "#{nzzzzz4[i].to_s}#{"\n" if i<nzzzzz4.length-1}"
      end
    }
    puts 'Alias list has been restored from backup.'
  end
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHMultiNames.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHMultiNames.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  @multi_aliases=b.uniq
end

def groups_load() # loads the groups list
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  @groups=b.uniq
end

def metadata_load() # loads the metadata - users who choose to see plaintext over embeds, data regarding each shard's server count, number of headpats received, etc.
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSave.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSave.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[[],[],[0,0],[[0,0,0,0,0],[0,0,0,0,0]],[0,0,0],[],[],[]]
  end
  @embedless=b[0]
  @embedless=[168592191189417984, 256379815601373184] if @embedless.nil?
  @ignored=b[1]
  @ignored=[] if @ignored.nil?
  @summon_rate=b[2]
  @summon_rate=[0,0,3] if @summon_rate.nil?
  @server_data=b[3]
  @server_data=[[0,0,0,0,0],[0,0,0,0,0]] if @server_data.nil?
  @headpats=b[4] unless b[4].nil?
  @server_markers=b[5] unless b[5].nil?
  @x_markers=b[6] unless b[6].nil?
  @spam_channels=b[7]
  @spam_channels=[407149643923849218] if @spam_channels.nil?
end

def metadata_save() # saves the metadata
  x=[@embedless.map{|q| q}, @ignored.map{|q| q}, @summon_rate.map{|q| q}, @server_data.map{|q| q}, @headpats.map{|q| q}, @server_markers.map{|q| q}, @x_markers.map{|q| q}, @spam_channels.map{|q| q}]
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHSave.txt', 'w') { |f|
    f.puts x[0].to_s
    f.puts x[1].to_s
    f.puts x[2].to_s
    f.puts x[3].to_s
    f.puts x[4].to_s
    f.puts x[5].to_s
    f.puts x[6].to_s
    f.puts x[7].to_s
    f.puts "\n"
  }
end

def devunits_load() # loads information regarding the devunits
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHDevUnits.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHDevUnits.txt').each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  @dev_waifus=b[0].split('\\'[0])
  @dev_somebodies=b[1].split('\\'[0])
  @dev_nobodies=b[2].split('\\'[0])
  b.shift
  b.shift
  b.shift
  b.shift
  @dev_units=[]
  for i in 0...b.length/10
    @dev_units[i]=[]
    @dev_units[i].push(b[i*10])
    k=b[i*10+1].split('\\'[0])
    @dev_units[i].push(k[0].to_i)
    @dev_units[i].push(k[1].to_i)
    @dev_units[i].push(k[2])
    @dev_units[i].push(k[3])
    @dev_units[i].push(k[4])
    @dev_units[i].push(b[i*10+2].split('\\'[0]))
    @dev_units[i].push(b[i*10+3].split('\\'[0]))
    @dev_units[i].push(b[i*10+4].split('\\'[0]))
    @dev_units[i].push(b[i*10+5].split('\\'[0]))
    @dev_units[i].push(b[i*10+6].split('\\'[0]))
    @dev_units[i].push(b[i*10+7].split('\\'[0]))
    @dev_units[i].push(b[i*10+8])
  end
end

def devunits_save() # used by the devedit command to save the devunits
  # sort the waifu list alphabetically, but move Sakura to the front of the list
  k=@dev_waifus.map{|q| q}
  for i in 0...k.length
    k[i]=nil if k[i]=='Sakura'
  end
  k.compact!
  k=k.sort{|a,b| a<=>b}
  w=['Sakura']
  for i in 0...k.length
    w.push(k[i])
  end
  # sort the "somebodies" and "nobodies" lists alphabetically
  sb=@dev_somebodies.sort{|a,b| a<=>b}
  nb=@dev_nobodies.sort{|a,b| a<=>b}
  # remove units from the "somebody" ist if they're also in the waifu list.
  for i in 0...sb.length
    sb[i]=nil if w.include?(sb[i])
  end
  sb.compact!
  # remove units from the "nobody" list if they're also in the waifu or "somebody" list, or if they're listed as a normal devunit.
  for i in 0...nb.length
    nb[i]=nil if w.include?(nb[i]) || sb.include?(nb[i]) || @dev_units.map{|q| q[0]}.include?(nb[i])
  end
  nb.compact!
  # sort the unit list alphabetically, but move Sakura to the front of the line
  k=@dev_units.map{|q| q}
  saku=nil
  for i in 0...k.length
    if k[i][0]=='Sakura' && saku.nil?
      saku=k[i].map{|q| q}
      k[i]=nil
    end
  end
  k.compact!
  k=k.sort{|a,b| a[0]<=>b[0]}
  untz=[saku.map{|q| q}]
  for i in 0...k.length
    untz.push(k[i].map{|q| q})
  end
  s="#{w.join('\\'[0])}\n#{sb.join('\\'[0])}\n#{nb.join('\\'[0])}"
  for i in 0...untz.length
    s="#{s}\n\n#{untz[i][0]}\n#{untz[i][1]}\\#{untz[i][2]}\\#{untz[i][3]}\\#{untz[i][4]}\\#{untz[i][5]}\n#{untz[i][6].join('\\'[0])}\n#{untz[i][7].join('\\'[0])}\n#{untz[i][8].join('\\'[0])}\n#{untz[i][9].join('\\'[0])}\n#{untz[i][10].join('\\'[0])}\n#{untz[i][11].join('\\'[0])}\n#{untz[i][12]}"
  end
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHDevUnits.txt', 'w') { |f|
    f.puts s
    f.puts "\n"
  }
  return nil
end

def bonus_load()
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHArenaTempest.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHArenaTempest.txt').each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  for i in 0...b.length
    b[i]=b[i].split('\\'[0])
    b[i][0]=b[i][0].split(', ')
    b[i][2]=b[i][2].split(', ')
    b[i][3]=b[i][3].split(', ') unless b[i][3].nil?
    b[i][4]=b[i][4].split(', ') unless b[i][4].nil?
  end
  @bonus_units=b.map{|q| q}
end

bot.command([:help,:commands,:command_list,:commandlist,:Help]) do |event, command, subcommand| # used to show tooltips regarding each command.  If no command name is given, shows a list of all commands
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  help_text(event,bot,command,subcommand)
  return nil
end

bot.command(:reboot, from: 167657750971547648) do |event| # reboots Elise
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  puts 'FEH!reboot'
  exec "cd C:/Users/Mini-Matt/Desktop/devkit && PriscillaBot.rb #{@shardizard}"
end

def safe_to_spam?(event,chn=nil) # determines whether or not it is safe to send extremely long messages
  return true if event.server.nil? # it is safe to spam in PM
  return true if [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579].include?(event.server.id) # it is safe to spam in the emoji servers
  return true if @shardizard==4 # it is safe to spam during debugging
  chn=event.channel if chn.nil?
  return true if ['bots','bot'].include?(chn.name.downcase) # channels named "bots" are safe to spam in
  return true if chn.name.downcase.include?('bot') && chn.name.downcase.include?('spam') # it is safe to spam in any bot spam channel
  return true if chn.name.downcase.include?('bot') && chn.name.downcase.include?('command') # it is safe to spam in any bot spam channel
  return true if chn.name.downcase.include?('bot') && chn.name.downcase.include?('channel') # it is safe to spam in any bot spam channel
  return true if chn.name.downcase.include?('elisebot')  # it is safe to spam in channels designed specifically for EliseBot
  return true if chn.name.downcase.include?('elise-bot')
  return true if chn.name.downcase.include?('elise_bot')
  return true if @spam_channels.include?(chn.id)
  return false
end

def donate_trigger_word(event,str=nil,mode=0)
  if !str.is_a?(String) && File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{str}.txt")
    b=[]
    File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{str}.txt").each_line do |line|
      b.push(line.gsub("\n",''))
    end
    f=[b[0].split('\\'[0])[0],str,b[0].split('\\'[0])[1],b[0].split('\\'[0])[2]]
    return f[mode+1]
  else
    if str.nil?
      str=event.message.text
      str=str.downcase
      str=str[2,str.length-2] if ['f?','e?','h?'].include?(str[0,2])
      str=str[4,str.length-4] if ['feh?','feh!'].include?(str[0,4])
    end
    str=str.downcase
    d=Dir["C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/*.txt"]
    f=[]
    for i in 0...d.length
      b=[]
      File.open(d[i]).each_line do |line|
        b.push(line.gsub("\n",''))
      end
      f.push([b[0].split('\\'[0])[0],d[i].gsub("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/",'').gsub('.txt','').to_i,b[0].split('\\'[0])[1],b[0].split('\\'[0])[2]])
      f[-1][2]=f[-1][2].hex unless f[-1][2].nil?
      if !get_donor_list().reject{|q| q[2]<3}.map{|q| q[0]}.include?(f[-1][1])
        f[-1]=nil
        f.compact!
      elsif !get_donor_list().reject{|q| q[2]<4}.map{|q| q[0]}.include?(f[-1][1])
        f[-1][2]=nil
        f[-1][3]=nil
        f[-1].compact!
      end
    end
  end
  for i in 0...f.length
    return f[i][2] if str.split(' ').include?("#{f[i][0].downcase}'s") && mode==1
    return f[i][3] if str.split(' ').include?("#{f[i][0].downcase}'s") && mode==2
    return f[i][1] if str.split(' ').include?("#{f[i][0].downcase}'s")
  end
  return -1
end

def donor_unit_list(uid, mode=0)
  return [] unless File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt")
  b=[]
  File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt").each_line do |line|
    b.push(line.gsub("\n",''))
  end
  m=b[0]
  b.shift
  b.shift
  untz=[]
  return untz if b.length<10
  for i in 0...b.length/10
    untz[i]=[]
    untz[i].push(b[i*10])
    k=b[i*10+1].split('\\'[0])
    untz[i].push(k[0].to_i)
    untz[i].push(k[1].to_i)
    untz[i].push(k[2])
    untz[i].push(k[3])
    untz[i].push(k[4])
    untz[i].push(b[i*10+2].split('\\'[0]))
    untz[i].push(b[i*10+3].split('\\'[0]))
    untz[i].push(b[i*10+4].split('\\'[0]))
    untz[i].push(b[i*10+5].split('\\'[0]))
    untz[i].push(b[i*10+6].split('\\'[0]))
    untz[i].push(b[i*10+7].split('\\'[0]))
    untz[i].push(b[i*10+8])
  end
  untz.unshift(m) if mode==1
  return untz
end

def donor_unit_save(uid,table) # used by the edit command to save the donorunits
  return nil unless File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt")
  # snag the username
  b=[]
  File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt").each_line do |line|
    b.push(line.gsub("\n",''))
  end
  # sort the unit list alphabetically
  k=table.map{|q| q}
  k.compact!
  k=k.sort{|a,b| a[0]<=>b[0]}
  untz=[]
  for i in 0...k.length
    untz.push(k[i].map{|q| q})
  end
  s="#{b[0]}"
  for i in 0...untz.length
    s="#{s}\n\n#{untz[i][0]}\n#{untz[i][1]}\\#{untz[i][2]}\\#{untz[i][3]}\\#{untz[i][4]}\\#{untz[i][5]}\n#{untz[i][6].join('\\'[0])}\n#{untz[i][7].join('\\'[0])}\n#{untz[i][8].join('\\'[0])}\n#{untz[i][9].join('\\'[0])}\n#{untz[i][10].join('\\'[0])}\n#{untz[i][11].join('\\'[0])}\n#{untz[i][12]}"
  end
  open("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt", 'w') { |f|
    f.puts s
    f.puts "\n"
  }
  return nil
end

def overlap_prevent(event) # used to prevent servers with both Elise and her debug form from receiving two replies
  if event.server.nil? # failsafe code catching PMs as not a server
    return false
  elsif event.message.text.downcase.split(' ').include?('debug') && [443172595580534784,443704357335203840,443181099494146068,449988713330769920,497429938471829504,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579].include?(event.server.id)
    return @shardizard != 4 # the debug bot can be forced to be used in the emoji servers by including the word "debug" in your message
  elsif [443172595580534784,443704357335203840,443181099494146068,449988713330769920,497429938471829504,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579].include?(event.server.id) # emoji servers will use default Elise otherwise
    return @shardizard == 4
  elsif event.server.id==332249772180111360 # two identical commands cannot be used in the same minute in the FEHKeeper server
    canpost=true
    post=Time.now
    if (post - @zero_by_four[2]).to_f > 60
      @zero_by_four[2]=post
    else
      canpost=false
    end
    s=event.message.text.downcase
    s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
    s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
    return true if !canpost && s==@zero_by_four[3]
    @zero_by_four[3]=s
    return false
  end
  return false
end

def get_markers(event) # used to determine whether a server-specific unit/skill is safe to display
  metadata_load()
  k=0
  k=event.server.id unless event.server.nil?
  g=[nil]
  for i in 0...@server_markers.length
    g.push(@server_markers[i][0]) if k==@server_markers[i][1]
    g.push(@server_markers[i][0].downcase) if k==@server_markers[i][1]
  end
  g.push('X') if @x_markers.include?(k)
  g.push('x') if @x_markers.include?(k)
  return g
end

def get_stats(event,name,level=40,rarity=5,merges=0,boon='',bane='') # used by multiple commands to calculate a unit's stats
  data_load()
  newmerge=false
  args=event.message.text.downcase.gsub('(','').gsub(')','').split(' ')
  newmerge=true if args.include?('feb') || args.include?('february')
  t=Time.now
  newmerge=true if t.year>2019
  newmerge=true if t.year==2019 && t.month>2
  newmerge=true if t.year==2019 && t.month==2 && t.day>8
  # find neutral five-star level 40 stats
  u=@units.map{|q| q}
  if name=='Robin'
    f=u[u.find_index{|q| q[0]=='Robin(F)'}]
  else
    f=u[u.find_index{|q| q[0]==name}]
  end
  sttz=['hp','attack','speed','defense','resistance']
  for i in 0...sttz.length
    sttz[i]=1 if boon.downcase==sttz[i]
    sttz[i]=-1 if bane.downcase==sttz[i] && (merges==0 || !newmerge)
    sttz[i]=0 if sttz[i].is_a?(String)
  end
  if rarity>=@mods[0].length
    for i in 0...@mods.length
      @mods[i][rarity]=(0.39*((((i-4)*5+20)*(0.79+(0.07*rarity))).to_i)).to_i
    end
  end
  if rarity<@max_rarity_merge[0]+1 && rarity%2==1 && merges%5==0 && f[4].reject{|q| q==q.to_i}.length.zero?
    if level==40
      u=[f[0]]
      for i in 0...f[5].length
        u.push(f[5][i]+sttz[i]-@mods[f[4][i]+4][5]+@mods[f[4][i]+sttz[i]+4][rarity]+2*(merges/5)-(5-rarity)/2)
      end
      for i in 0...f[4].length
        u.push(f[4][i]+sttz[i])
      end
      for i in 0...f[4].length
        u.push(@mods[f[4][i]+sttz[i]+4][5])
      end
    else
      u=[f[0]]
      for i in 0...f[5].length
        u.push(f[5][i]+sttz[i]-@mods[f[4][i]+4][5]+2*(merges/5)-(5-rarity)/2)
      end
      u.push(u[1]+u[2]+u[3]+u[4]+u[5])
      for i in 0...f[4].length
        u.push(f[4][i]+sttz[i])
      end
      for i in 0...f[4].length
        u.push(@mods[f[4][i]+sttz[i]+4][rarity])
      end
    end
    if merges>0 && bane=='' && boon=='' && newmerge
      s2=u.map{|q| q}
      s=[[s2[1],1],[s2[2],2],[s2[3],3],[s2[4],4],[s2[5],5]]
      s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}
      for i in 0...3
        u[s[i][1]]+=1
      end
    end
  elsif rarity<@max_rarity_merge[0]+1 && rarity%2==0 && merges%5==0 && f[4].reject{|q| q==q.to_i}.length.zero?
    u=[f[0]]
    for i in 0...f[5].length
      u.push(f[5][i]+sttz[i]-@mods[f[4][i]+4][5]+2*(merges/5)-(6-rarity)/2)
    end
    s=[[u[2],2],[u[3],3],[u[4],4],[u[5],5]]                                   # all non-HP stats
    s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}  # sort the stats based on amount
    u[s[0][1]]+=1
    u[s[1][1]]+=1
    u.push(u[1]+u[2]+u[3]+u[4]+u[5]) if level==1
    for i in 0...f[4].length
      u.push(f[4][i]+sttz[i])
    end
    for i in 0...f[4].length
      u.push(@mods[f[4][i]+sttz[i]+4][rarity])
    end
    if level==40
      for i in 0...f[5].length
        u[i+1]+=@mods[f[4][i]+sttz[i]+4][rarity]
      end
    end 
    if merges>0 && bane=='' && boon=='' && newmerge
      s2=u.map{|q| q}
      s=[[s2[1],1],[s2[2],2],[s2[3],3],[s2[4],4],[s2[5],5]]
      s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}
      for i in 0...3
        u[s[i][1]]+=1
      end
    end
  else
    # find neutral level 1 stats based on rarity
    r=f[4].map{|q| q}                                                         # rate numbers
    m=r.map{|q| (0.39*(((q*5+20)*(0.79+(0.07*5))).to_i)).to_i}                # growth rates
    u=[f[0]]
    for i in 0...5
      u.push(f[5][i]-m[i])                                                    # apply the difference in the step above
    end
    s=[[u[2],2],[u[3],3],[u[4],4],[u[5],5]]                                   # all non-HP stats
    s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}  # sort the stats based on amount
    # apply the level 1 rarity difference between 5* and 1*
    u[1]-=2
    u[2]-=2
    u[3]-=2
    u[4]-=2
    u[5]-=2
    # Every odd rarity increases all stats by 1 compared to the previous odd rarity
    u[1]+=((rarity-1)/2)
    u[2]+=((rarity-1)/2)
    u[3]+=((rarity-1)/2)
    u[4]+=((rarity-1)/2)
    u[5]+=((rarity-1)/2)
    # find level 1 stats and growth rates based on boon and bane
    for i in 0...5
      u[i+1]+=sttz[i]
      r[i]+=sttz[i]
    end
    s2=u.map{|q| q}
    # if rarity is even, increase the two highest non-HP stats by 1 each
    if rarity%2==0
      u[s[0][1]]+=1
      u[s[1][1]]+=1
    end
    # find stats based on merges
    s=[[s2[1],1],[s2[2],2],[s2[3],3],[s2[4],4],[s2[5],5]]                                                        # all stats
    s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}                                     # sort the stats based on amount
    s.push(s[0],s[1],s[2],s[3],s[4])                                                                             # loop the list for use with multiple merges
    s.push(s[0],s[1],s[2],s[3],s[4])
    s.push(s[0],s[1],s[2],s[3],s[4])
    if level==40
      # find level 40 stats based on growth rates and level 1 stats
      # growth rates
      m=r.map{|q| (0.39*(((q*5+20)*(0.79+(0.07*rarity))).to_i)).to_i}
      u=[u[0],u[1]+m[0],u[2]+m[1],u[3]+m[2],u[4]+m[3],u[5]+m[4],r[0],r[1],r[2],r[3],r[4],m[0],m[1],m[2],m[3],m[4]]
      # apply the difference above
    end
    if merges>0                                                                                                  # apply merges, two stats per merge
      # every five merges results in +2 to each stat
      u[1]+=2*(merges/5)
      u[2]+=2*(merges/5)
      u[3]+=2*(merges/5)
      u[4]+=2*(merges/5)
      u[5]+=2*(merges/5)
      # beyond that, two stats per merge, order determined above
      if (merges%5)>0
        for i in 0...2*(merges%5)
          u[s[i][1]]+=1
        end
      end
    end
    if merges>0 && bane=='' && boon=='' && newmerge
      for i in 0...3
        u[s[i][1]]+=1
      end
    end
  end
  return u
end

def make_stats_string(event,name,rarity,boon='',bane='',hm=@max_rarity_merge[1]) # used by the `study` command to create the stat arrangement shown in it
  k=''
  hm=[hm.to_i, hm.to_i]
  args=sever(event.message.text.downcase).split(' ')
  hm[0]=@max_rarity_merge[1] if hm[0]<0 || args.include?('full') || args.include?('merges')
  hm[1]=0-hm[1] if hm[1]<0
  u=get_stats(event,name,40,5,0,boon,bane)
  u2=(u[1]+u[2]+u[3]+u[4]+u[5])/5
  for i in 0...hm[0]+1
    u=get_stats(event,name,40,rarity,i,boon,bane)
    u=['Kiran',0,0,0,0,0] if u[0]=='Kiran'
    k="#{k}\n**#{i} merge#{'s' unless i==1}:** #{u[1]} / #{u[2]} / #{u[3]} / #{u[4]} / #{u[5]}  \u200B  \u200B  BST: #{u[1]+u[2]+u[3]+u[4]+u[5]}  \u200B  \u200B  Score: #{u2+rarity*5+i*2+90}" if i%5==0 || i==hm[1] || args.include?('full') || args.include?('merges')
  end
  return k
end

def get_bonus_units(type='Arena',mode=0)
  bonus_load()
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
  b=@bonus_units.map{|q| q}
  b=b.reject{|q| q[1]!=type} if type.length>0
  return [] if b.length<=0
  b=b.reject{|q| q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm} if mode==0
  b=b.reject{|q| q[2][0].split('/').reverse.join('').to_i<=tm} if mode>=1
  return [] if b.length<=0
  return b[mode-1][0] if mode>=1
  return b.map{|q| q[0]}.join(', ').split(', ')
end

def make_banner(event) # used by the `summon` command to pick a random banner and choose which units are on it.
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHBanners.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHBanners.txt').each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  for i in 0...b.length
    b[i]=b[i].split('\\'[0])
    b[i][1]=b[i][1].to_i
    b[i][2]=b[i][2].gsub(' ','').split(',')
    b[i][2]=[] if b[i][2][0]=='-'
    b[i][4]=nil if !b[i][4].nil? && b[i][4].length<=0
  end
  b=b.reject{|q| q[2].length==0 && !q[0].include?('GHB') && !q[0].include?('TT')}
  args=event.message.text.downcase.gsub("\n",' ').split(' ')
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt').each_line do |line|
      lookout.push(eval line)
    end
  end
  banner_types=[]
  for i in 0...args.length
    for i2 in 0...lookout.length
      if lookout[i2][1].include?(args[i].downcase)
        banner_types.push(lookout[i2][0]) if lookout[i2][2]=='Banner'
      end
    end
  end
  b2=b.map{|q| q}
  b2=b2.reject{|q| q[5].nil? || !has_any?(q[5].split(', '),banner_types.reject{|q2| ['Current','Upcoming'].include?(q2)})} if banner_types.reject{|q2| ['Current','Upcoming'].include?(q2)}.length>0
  b2=b.map{|q| q} if b2.length==0
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
  b3=b2.map{|q| q}
  b3=b2.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i>tm || q[4].split(', ')[1].split('/').reverse.join('').to_i<tm} if banner_types.include?('Current')
  b3=b2.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i<=tm} if banner_types.include?('Upcoming')
  b3=b2.reject{|q| q[4].nil? || q[4].split(', ')[1].split('/').reverse.join('').to_i<tm} if banner_types.include?('Current') && banner_types.include?('Upcoming')
  b3=b2.map{|q| q} if b2.length==0
  bnr=b3.sample
  data_load()
  x=false
  y=false
  z=false
  w=false
  unless bnr[3].nil?
    x=true if bnr[3].include?('4') # banner has 4* Focus Units
    y=true if bnr[3].include?('3') # banner has 3* Focus Units
    z=true if bnr[3].include?('2') # banner has 2* Focus Units
    w=true if bnr[3].include?('1') # banner has 1* Focus Units
    bnr[3]=nil
  end
  bnr[0]=[bnr[0],bnr[4]]
  bnr[4]=nil
  bnr[5]=nil
  bnr.compact!
  bnr.push([])
  bnr.push([])
  bnr.push([])
  bnr.push([])
  bnr.push([])
  data_load()
  u=@units.map{|q| q}
  for i in 0...u.length
    bnr[2].push(u[i][0]) if u[i][9][0].downcase.include?('g') && bnr[0][0]=='GHB Units' && u[i][13][0].nil? # the fake GHB Unit banner
    bnr[2].push(u[i][0]) if u[i][9][0].downcase.include?('t') && bnr[0][0]=='TT Units' && u[i][13][0].nil?  # the fake Tempest Unit banner
  end
  if x # 4* Focus Units
    bnr.push(bnr[2].map{|q| q}) # clone the list of 5* Focus Units
  else
    bnr.push(nil)
  end
  if y # 3* Focus Units
    bnr.push(bnr[2].map{|q| q}) # clone the list of 5* Focus Units
  else
    bnr.push(nil)
  end
  if z # 2* Focus Units
    bnr.push(bnr[2].map{|q| q}) # clone the list of 5* Focus Units
  else
    bnr.push(nil)
  end
  if w # 1* Focus Units
    bnr.push(bnr[2].map{|q| q}) # clone the list of 5* Focus Units
  else
    bnr.push(nil)
  end
  for i in 0...u.length # non-focus units
    bnr[3].push(u[i][0]) if u[i][9][0].include?('5p') && u[i][13][0].nil?
    bnr[4].push(u[i][0]) if u[i][9][0].include?('4p') && u[i][13][0].nil?
    bnr[5].push(u[i][0]) if u[i][9][0].include?('3p') && u[i][13][0].nil?
    bnr[6].push(u[i][0]) if u[i][9][0].include?('2p') && u[i][13][0].nil?
    bnr[7].push(u[i][0]) if u[i][9][0].include?('1p') && u[i][13][0].nil?
  end
  return bnr
end

def crack_orbs(bot,event,e,user,list) # used by the `summon` command to wait for a reply
  summons=0
  five_star=false
  for i in 1...6
    if list.include?(i)
      e << "Orb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,-1,@banner[i][1],false,4)} (*#{@banner[i][2]}*)"
      summons+=1
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5:448266417553539104>')
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5p10:448272715099406336>')
    end
  end
  e << ''
  e << "In this current summoning session, you fired Breidablik #{summons} time#{'s' unless summons==1}, expending #{[0,5,9,13,17,20][summons]} orbs."
  metadata_load()
  @summon_rate[0]+=summons
  @summon_rate[1]+=[0,5,9,13,17,20][summons]
  e << "Since the last 5\* summons, Breidablik has been fired #{@summon_rate[0]} time#{'s' unless @summon_rate[0]==1} and #{@summon_rate[1]} orbs have been expended."
  if @summon_rate[2]>2
    @summon_rate=[0,0,(@summon_rate[2]+1)%3+3] if five_star
  else
    @summon_rate=[0,0,@summon_rate[2]] if five_star
  end
  metadata_save()
  @banner=[]
end

def find_unit(name,event,ignore=false,ignore2=false) # used to find a unit's data entry based on their name
  ks=0
  ks=event.server.id unless event.server.nil?
  g=get_markers(event)
  return -1 if name.nil?
  data_load()
  name=normalize(name.gsub('!',''))
  if name.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    buff=name.split(':')[1]
    buff=buff[3,buff.length-3] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,3].downcase=='gp_'
    buff=buff[2,buff.length-2] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,2].downcase=='gp'
    name=buff if find_unit(buff,event,ignore)>=0
  end
  name=name.gsub('(','').gsub(')','') unless ignore2
  untz=@units.map{|q| q}
  k=untz.find_index{|q| q[0].downcase==name.downcase}
  k=untz.find_index{|q| q[0].gsub('(','').gsub(')','').downcase==name.downcase} unless ignore2
  return k unless k.nil? || !has_any?(g, untz[k][13][0])
  nicknames_load()
  unless ignore2
    alz=@aliases.reject{|q| q[0]!='Unit'}
    k=alz.find_index{|q| q[1].downcase==name.downcase && (q[3].nil? || q[3].include?(ks))}
    return untz.find_index{|q| q[0]==alz[k][2]} unless k.nil? || !has_any?(g, untz[untz.find_index{|q| q[0]==alz[k][2]}][13][0])
  end
  return -1 if name.length<2
  return -1 if ignore || ['blade','blad','bla'].include?(name.downcase)
  untz=@units.map{|q| q}
  k=untz.find_index{|q| q[0][0,name.length].downcase==name.downcase}
  k=untz.find_index{|q| q[0][0,name.length].gsub('(','').gsub(')','').downcase==name.downcase} unless ignore2
  return k unless k.nil? || !has_any?(g, untz[k][13][0])
  unless ignore2
    alz=@aliases.map{|q| q}
    k=alz.find_index{|q| q[0][0,name.length].downcase==name.downcase && (q[2].nil? || q[2].include?(ks))}
    return untz.find_index{|q| q[0]==alz[k][2]} unless k.nil? || !has_any?(g, untz[untz.find_index{|q| q[0]==alz[k][1]}][13][0])
  end
  unless ignore2 || !name.downcase.include?('launch')
    name=name.downcase.gsub('launch','') # if the name includes the word "launch", remove it from consideration
    untz=@units.map{|q| q}
    k=untz.find_index{|q| q[0].downcase==name.downcase}
    k=untz.find_index{|q| q[0].downcase==name.downcase && q[9][0].include?('LU')} unless ignore2
    return k unless k.nil? || !has_any?(g, untz[k][13][0])
    alz=@aliases.reject{|q| q[0]!='Unit' || q[2].include?('(') || !q[3].nil?}
    k=alz.find_index{|q| q[0][0,name.length].downcase==name.downcase}
    return untz.find_index{|q| q[0]==alz[k][1]} unless k.nil? || !has_any?(g, untz[k][13][0])
  end
  return -1
end

def find_skill(name,event,ignore=false,ignore2=false,m=false,mode=0) # one of two functions used to find a skill's data entry based on its name
  return find_skill('Recover Ring',event) if name.downcase.gsub(' ','')=='renewal4' # Recover Ring is essentially Renewal 4 so I allow this alias
  data_load()
  sklz=@skills.map{|q| q}
  x=x_find_skill(name,event,sklz,ignore,ignore2,m) # find the skill that matches.
  return x if x<0 # if no skill matches, skip more
  return -1 if sklz[x].nil?
  return x if ['weapon','assist','special'].include?(sklz[x][4].downcase) # weapons and such do not need weird calculations
  return x if sklz[x][0].downcase==name.downcase # exact matches do not need weird calculations
  if name[name.length-1,1].to_i.to_s==name[name.length-1,1]
    return x if sklz[x][0][sklz[x][0].length-1,1].to_i.to_s == sklz[x][0][sklz[x][0].length-1,1] # skills with numbers do not need weird calculations
  else
    return x if sklz[x][0][sklz[x][0].length-1,1].to_i.to_s != sklz[x][0][sklz[x][0].length-1,1] # skills with numbers do not need weird calculations
  end
  n=sklz[x][0].gsub(' ','').gsub('_','')
  name=name.gsub(' ','').gsub('_','')
  xx=sklz[x][0].reverse.scan(/\d+/)[0].reverse
  # removing any numbers that weren't part of the original input
  for j in 0..xx.length
    for i in 0...10 # find the highest tier skill with a matching name
      n=n[0,n.length-2] if n[n.length-2,2]=="+#{i}" && name[name.length-2,2]!="+#{i}"
      n=n[0,n.length-1] if n[n.length-1,1]==i.to_s && name[name.length-1,1]!=i.to_s
    end
  end
  return x_find_skill(n,event,sklz) if n[n.length-1,1].to_i.to_s==n[n.length-1,1] # if the skill already has a match with a name that ends in a number, return that value
  x2=first_sub(sklz[x][0].reverse,xx.reverse,'').reverse
  x3=[]
  # find any skills with the same name but different values...
  for i in 0...sklz.length
    if sklz[i][0][sklz[i][0].length-1].to_i.to_s==sklz[i][0][sklz[i][0].length-1]
      m2=sklz[i][0].reverse.scan(/\d+/)[0].reverse
      x3.push([i,m2.to_i,sklz[i][0]]) if first_sub(sklz[i][0].reverse,m2.reverse,'').reverse==x2
    end
  end
  # ...and return the one at the end of the list (which is the beginning of the list after the sorting)
  g=get_markers(event)
  x3=x3.reject{|q| !has_any?(g, sklz[q[0]][13])}.sort{|a,b| b[1]<=>a[1]}
  return x3.reverse.map{|q| q[0]} if mode==1
  return x3[0][0]
end

def x_find_skill(name,event,sklz,ignore=false,ignore2=false,m=false) # one of two functions used to find a skill's data entry based on its name
  ks=0
  ks=event.server.id unless event.server.nil?
  g=get_markers(event)
  return -1 if name.nil?
  name=normalize(name.gsub('!','').gsub('.','').gsub('?',''))
  if name.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    name=name.split(':')[1] if x_find_skill(name.split(':')[1],event,sklz,ignore,ignore2)>=0
  end
  # use the `stat_buffs` function so that "Atk" and "Attack", for example, are treated the same
  # try with only replacing spaces and underscores first...
  x2=stat_buffs(name.gsub(' ','').gsub('_',''),name,2)
  k=sklz.find_index{|q| stat_buffs(q[0].gsub('.','').gsub('!',''),name,2).gsub('?','').gsub(' ','').gsub('_','')==x2}
  return k unless k.nil? || sklz[k].nil? || !has_any?(g, sklz[k][13])
  # ...if that fails, try removing quotes, slashes, and hyphens as well
  x2=stat_buffs(name.gsub(' ','').gsub('_','').gsub("'",'').gsub('/','').gsub("-",''),name,2)
  k=sklz.find_index{|q| stat_buffs(q[0].gsub('.','').gsub('!','').gsub('?','').gsub('/','').gsub("'",'').gsub("-",''),name,2).gsub(' ','').gsub('_','')==x2}
  return k unless k.nil? || sklz[k].nil? || !has_any?(g, sklz[k][13])
  # skill aliases...
  unless ignore2
    alz=@aliases.reject{|q| q[0]!='Skill'}
    k=alz.find_index{|q| q[1].downcase==name.downcase && (q[3].nil? || q[3].include?(ks))}
    return sklz.find_index{|q| q[0]==alz[k][2]} unless k.nil? || !has_any?(g, sklz[sklz.find_index{|q| q[0]==alz[k][2]}][13])
  end
  return -1 if ignore
  return find_skill("the#{name.downcase.gsub(' ','')}",event) if find_skill("the#{name.downcase.gsub(' ','')}",event,true)>=0 && @skills[find_skill("the#{name.downcase.gsub(' ','')}",event,true)][0][0,4]=='The '
  return find_skill("a#{name.downcase.gsub(' ','')}",event) if find_skill("a#{name.downcase.gsub(' ','')}",event,true)>=0 && @skills[find_skill("a#{name.downcase.gsub(' ','')}",event,true)][0][0,2]=='A '
  return find_skill("an#{name.downcase.gsub(' ','')}",event) if find_skill("an#{name.downcase.gsub(' ','')}",event,true)>=0 && @skills[find_skill("an#{name.downcase.gsub(' ','')}",event,true)][0][0,3]=='An '
  return -1 if name.length<2
  # try everything again, but this time matching the portion of the skill name that is exactly as long as the input string.
  x2=stat_buffs(name.gsub(' ','').gsub('_',''),name,2)
  k=sklz.find_index{|q| stat_buffs(q[0].gsub('.','').gsub('!','').gsub('?',''),name,2).gsub(' ','').gsub('_','')[0,name.length]==x2}
  return k unless k.nil? || sklz[k].nil? || !has_any?(g, sklz[k][13])
  k=sklz.find_index{|q| stat_buffs(q[0].gsub('.','').gsub('!','').gsub('?',''),name,2).gsub(' ','').gsub('_','')[0,x2.length]==x2}
  return k unless k.nil? || sklz[k].nil? || !has_any?(g, sklz[k][13])
  return -1 if name.length<4
  namex=name.gsub(' ','').downcase
  unless ignore2
    alz=@aliases.reject{|q| q[0]!='Skill'}
    k=alz.find_index{|q| q[1][0,namex.length].downcase==namex.downcase && (q[3].nil? || q[3].include?(ks))}
    return sklz.find_index{|q| q[0]==alz[k][2]} unless k.nil? || !has_any?(g, sklz[sklz.find_index{|q| q[0]==alz[k][2]}][13])
  end
  return find_skill(name.downcase.gsub('_',' '),event) if name.include?('_')
  return -1
end

def find_structure(name,event,fullname=false)
  data_load()
  strct=@structures.map{|q| q}
  name=name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  k=strct.find_index{|q| "#{q[0]} #{q[1]}".downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name}
  return [k] unless k.nil?
  s=strct.reject{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')!=name}
  return s.map{|q| strct.find_index{|q2| q==q2}} if s.length>0
  nicknames_load()
  alz=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name && (q[2].nil? || q[2].include?(g))}
  unless k.nil?
    m=strct.find_index{|q| "#{q[0]} #{q[1]}"==alz[k][1]}
    return [m] unless m.nil?
    s=strct.reject{|q| q[0]!=alz[k][1]}
    return s.map{|q| strct.find_index{|q2| q==q2}}
  end
  return [] if fullname
  return [] if name.length<3
  k=strct.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name}
  s=[]
  s=strct.reject{|q| q[0]!=strct[k][0] || q[2]!=strct[k][2]} unless k.nil?
  return s.map{|q| strct.find_index{|q2| q==q2}} if s.length>0
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
  s=[]
  s=strct.reject{|q| q[0]!=strct[k][0] || q[2]!=strct[k][2]} unless k.nil?
  return s.map{|q| strct.find_index{|q2| q==q2}} if s.length>0
  return []
end

def find_structure_ex(name,event,fullname=false)
  k=find_structure(name,event,true)
  return k if k.length>0
  args=name.split(' ')
  for i in 0...args.length-1
    for i2 in 0...args.length-i
      k=find_structure(args[i,args.length-1-i-i2].join(' '),event,true)
      return k if k.length>0 && args[i,args.length-1-i-i2].length>0
    end
  end
  return [] if fullname
  k=find_structure(name,event)
  return k if k.length>0
  args=name.split(' ')
  for i in 0...args.length-1
    for i2 in 0...args.length-i
      k=find_structure(args[i,args.length-1-i-i2].join(' '),event)
      return k if k.length>0 && args[i,args.length-1-i-i2].length>0
    end
  end
  return []
end

def find_item_feh(name,event,fullname=false)
  data_load()
  itmu=@itemus.map{|q| q}
  name=name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  k=itmu.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name}
  return k unless k.nil?
  nicknames_load()
  alz=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name && (q[2].nil? || q[2].include?(g))}
  return itmu.find_index{|q| q[0]==alz[k][1]} unless k.nil?
  return -1 if fullname
  return -1 if name.length<3
  k=itmu.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name}
  return k unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
  return itmu.find_index{|q| q[0]==alz[k][1]} unless k.nil?
  return -1
end

def find_accessory(name,event,fullname=false)
  data_load()
  itmu=@accessories.map{|q| q}
  name=name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  k=itmu.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name}
  return k unless k.nil?
  nicknames_load()
  alz=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name && (q[2].nil? || q[2].include?(g))}
  return itmu.find_index{|q| q[0]==alz[k][1]} unless k.nil?
  return -1 if fullname
  return -1 if name.length<3
  k=itmu.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name}
  return k unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
  return itmu.find_index{|q| q[0]==alz[k][1]} unless k.nil?
  return -1
end

def find_data_ex(callback,name,event,fullname=false)
  k=method(callback).call(name,event,true)
  return k if k>=0
  args=name.split(' ')
  for i in 0...args.length-1
    for i2 in 0...args.length-i
      k=method(callback).call(args[i,args.length-1-i-i2].join(' '),event,true)
      return k if k>=0 && args[i,args.length-1-i-i2].length>0
    end
  end
  return -1 if fullname
  k=method(callback).call(name,event)
  return k if k>=0
  args=name.split(' ')
  for i in 0...args.length-1
    for i2 in 0...args.length-i
      k=method(callback).call(args[i,args.length-1-i-i2].join(' '),event)
      return k if k>=0 && args[i,args.length-1-i-i2].length>0
    end
  end
  return -1
end

def find_promotions(j,event) # finds the promotions of a given skill.  Input is given in the skill's entry number, not name
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if j<0
  data_load()
  p=[]
  sklz=@skills.map{|q| q}
  for i in 0...sklz.length
    unless sklz[i].nil? || sklz[i][8].nil?
      p.push(sklz[i][0].gsub('Bladeblade','Laevatein')) if sklz[i][8].include?("*#{sklz[j][0]}*") && has_any?(g, sklz[i][13])
    end
  end
  p=p.sort{|a,b| a.downcase <=> b.downcase}
  p=p.reject{|q| q[0,10]=='Falchion (' || q=='Missiletainn' || q=='Adult (All)'}
  return p
end

def find_prevolutions(j,event) # finds any "pre-evolutions" of evolved weapons.  Input is given in the weapon's entry number, not name
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if j<0
  data_load()
  p=[]
  sklz=@skills.map{|q| q}
  for i in 0...sklz.length
    unless sklz[i][14].nil?
      k=sklz[i][14].split(', ')
      for i2 in 0...k.length
        if k[i2].include?('!') # this is currently-unused code that allows for character-specific evolutions
          z=k[i2].split('!')
          z2=sklz[i].map{|q| q}
          for i3 in 0...@max_rarity_merge[0]
            if z2[10][i3].include?(z[0])
              z2[10][i3]=z[0]
            else
              z2[10][i3]='-'
            end
          end
          p.push([z2,'but only when on']) if z[1]==sklz[j][0] && has_any?(g, sklz[i][13])
        else # used code starts back here.
          p.push([sklz[i],'which is learned by']) if k[i2]==sklz[j][0] && has_any?(g, sklz[i][13])
        end
      end
    end
  end
  for i in 0...p.length
    p[i][0][0]=p[i][0][0].gsub('Bladeblade','Laevatein')
  end
  p=p.sort {|a,b| a[0][0].downcase <=> b[0][0].downcase}
  return p
end

def find_effect_name(x,event,shorten=0) # used to find the name of the Effect Mode refine of a weapon.  Input is given in the weapon's entire entry, not name.
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if x.nil?
  data_load()
  p=[]
  f=''
  sklz=@skills.map{|q| q}
  for i in 0...sklz.length
    unless sklz[i][4]=='Weapon' || sklz[i][12].nil? || sklz[i][12]==''
      f=sklz[i][0] if sklz[i][12].split(', ').include?(x[0]) && has_any?(g, sklz[i][13])
    end
  end
  if f.length>0 && shorten%2==0
    f=f.split(' ')
    if f[f.length-1].length<2 || f[f.length-1].to_i.to_s==f[f.length-1] || ['W1','W2','W3','W4','W5','W6','W7','W8','W9'].include?(f[f.length-1])
      # shorten value of 0 means to just remove the "W" or number at the end of a skill name
      # used when displaying the name in the refinement section of the `skill` command
      f[f.length-1]=nil if shorten.zero?
      # shorten value of 2 means to, if a skill name ends in a single "W" or number, to replace that with a "W"
      # used when searching for the icon of a weapon's refinement
      f[f.length-1]='W' if shorten==2
    end
    f.compact!
    f=f.join(' ')
  end
  return f
end

def find_weapon(name,event,ignore=false,ignore2=false,mode=0) # used by the `get_weapon` function
  sklz=@skills.map{|q| q}
  sklz=@skills.reject{|q| q[4]!='Weapon'} unless mode==0
  return x_find_skill(name,event,sklz,ignore,ignore2)
end

def get_weapon(str,event,mode=0) # used by the `stats` command and many derivations to find a weapon's name in the inputs that remain after the unit is decided
  return nil if str.gsub(' ','').length<=0
  skz=@skills.map{|q| q}
  args=str.gsub('(','').gsub(')','').split(' ')
  args=args.reject{|q| q.gsub('*','').gsub('+','').to_i.to_s==q.gsub('*','').gsub('+','') || skz.reject{|q2| ['Weapon','Assist','Special'].include?(q2[4])}.map{|q2| stat_buffs(q2[0]).downcase.gsub(' ','')}.include?(stat_buffs(q,nil,2).downcase) || skz.reject{|q2| ['Weapon','Assist','Special'].include?(q2[4])}.map{|q2| q2[0].gsub('/','').downcase.gsub(' ','')}.include?(q.downcase) || ['+','-'].include?(q[0,1])} if args.length>1
  args2=args.join(' ').split(' ')
  args4=args.join(' ').split(' ')
  name=args.join(' ')
  args3=args.join(' ').split(' ')
  # try full-name matches first...
  if find_weapon(name,event,false,false,mode)<0
    for i in 0...args.length-1
      args.pop
      if find_weapon(name,event,false,false,mode)<0 && find_weapon(args.join('').downcase,event,true,false,mode)>=0
        args3=args.join(' ').split(' ') 
        name=skz[find_weapon(args.join('').downcase,event,true,false,mode)][0]
      end
    end
    if find_weapon(name,event,false,false,mode)<0
      for j in 0...args2.length-1
        args2.shift
        args=args2.join(' ').split(' ')
        if find_weapon(name,event,false,false,mode)<0 && find_weapon(args.join('').downcase,event,true,false,mode)>=0
          args3=args.join(' ').split(' ') 
          name=skz[find_weapon(args.join('').downcase,event,true,false,mode)][0]
        end
        for i in 0...args.length-1
          args.pop
          if find_weapon(name,event,false,false,mode)<0 && find_weapon(args.join('').downcase,event,true,false,mode)>=0
            args3=args.join(' ').split(' ') 
            name=skz[find_weapon(args.join('').downcase,event,true,false,mode)][0]
          end
        end
      end
    end
  end
  args2=args4.join(' ').split(' ')
  # ...then try partial name matches
  if find_weapon(name,event,false,false,mode)<0
    for i in 0...args.length-1
      args.pop
      if find_weapon(name,event,false,false,mode)<0 && find_weapon(args.join('').downcase,event,false,false,mode)>=0
        args3=args.join(' ').split(' ') 
        name=skz[find_weapon(args.join('').downcase,event,false,false,mode)][0]
      end
    end
    if find_weapon(name,event,false,false,mode)<0
      for j in 0...args2.length-1
        args2.shift
        args=args2.join(' ').split(' ')
        if find_weapon(name,event,false,false,mode)<0 && find_weapon(args.join('').downcase,event,false,false,mode)>=0
          args3=args.join(' ').split(' ') 
          name=skz[find_weapon(args.join('').downcase,event,false,false,mode)][0]
        end
        for i in 0...args.length-1
          args.pop
          if find_weapon(name,event,false,false,mode)<0 && find_weapon(args.join('').downcase,event,false,false,mode)>=0
            args3=args.join(' ').split(' ') 
            name=skz[find_weapon(args.join('').downcase,event,false,false,mode)][0]
          end
        end
      end
    end
  end
  return [skz[find_weapon(name,event)][0],args3.join(' ')] if find_weapon(name,event)>-1
  return nil
end

def find_in_dev_units(name) # used by the `stats` command and many derivations to determine if the bot developer has recorded owning a listed unit
  return -1 if name.nil?
  devunits_load()
  j=-1
  # try full-name matches first...
  for i in 0...@dev_units.length
    j=i if @dev_units[i][0].downcase==name.downcase && j<0
  end
  return j if j>-1
  # ...then try partial-name matches
  for i in 0...@dev_units.length
    j=i if @dev_units[i][0][0,name.length].downcase==name.downcase && j<0
  end
  return j if j>-1
  return -1
end

def stat_buffs(str,name=nil,mode=0) # used by almost all commands to be sure that end users can type all common abbreviations for stats and not worry about input
  name=str.split(' ').join(' ') if name.nil?
  x=str.downcase.gsub('/',' ').gsub('+',' +').gsub('  ',' ')
  x=x.gsub('hone','hone ').gsub('fortify','fortify ').gsub('goad','goad ').gsub('ward','ward ')
  x=x.split(' ')
  for i in 0...x.length # replacing common stat aliases with the names that are used in the majority of the code
    x[i]='hp' if ['health'].include?(x[i])
    x[i]='attack' if ['atk','att'].include?(x[i])
    x[i]='speed' if ['spd'].include?(x[i])
    x[i]='defense' if ['def','defence'].include?(x[i])
    x[i]='resistance' if ['res'].include?(x[i])
  end
  for i in 0...x.length-1 # making sure that Hones/Fortifies still work even if one includes the wrong skill class / stat combination
    x[i]='fortify' if ['hone'].include?(x[i]) && ['defense','resistance'].include?(x[i+1])
    x[i]='hone' if ['fortify'].include?(x[i]) && ['attack','speed'].include?(x[i+1])
  end
  n=x.join('')
  if mode==2
    n=n.gsub('health','hp')
    n=n.gsub('atk','attack').gsub('att','attack').gsub('attackack','attack')
    n=n.gsub('spd','speed')
    n=n.gsub('def','defense').gsub('defence','defense').gsub('defenseense','defense')
    n=n.gsub('res','resistance').gsub('resistanceistance','resistance')
  end
  nn=name.reverse.scan(/\d+/)[0]
  nn=' ' if nn.nil?
  for i in 0...nn.length # removing ending numbers from the resulting skill, unless the input also includes ending numbers
    for i in 0...10
      n=n[0,n.length-2] if n[n.length-2,2]=="+#{i}" && name[name.length-2,2]!="+#{i}"
      n=n[0,n.length-1] if n[n.length-1,1]==i.to_s && name[name.length-1,1]!=i.to_s
    end
  end
  return n
end

def find_group(name,event) # used to find a group's data entry based on their name
  k=0
  k=event.server.id unless event.server.nil?
  groups_load()
  name='BraveHeroes' if ['braveheroes','brave','cyl'].include?(name.downcase)
  name='FallenHeroes' if ['fallenheroes','fallen','dark','evil','alter'].include?(name.downcase)
  name='Winter' if ['winter','holiday'].include?(name.downcase)
  name='WorseThanLiki' if ['worsethanliki','liki'].include?(name.downcase)
  name='Bunnies' if ['bunnies','bunny','spring'].include?(name.downcase)
  name='Bathing' if ['bathers','bathhouse','bathouse','bath','bathing'].include?(name.downcase)
  name="Valentine's" if ['valentines',"valentine's"].include?(name.downcase)
  name="NewYear's" if ['newyears',"newyear's",'newyear'].include?(name.downcase)
  name='Wedding' if ['brides','grooms','bride','groom','wedding'].include?(name.downcase)
  name='Falchion_Users' if ['falchionusers'].include?(name.downcase.gsub('-','').gsub('_',''))
  name='Dancers&Singers' if ['dancers','singers'].include?(name.downcase)
  name='Helspawn' if ['hellspawn'].include?(name.downcase)
  name='Legendaries' if ['legendary','legend','legends','mythic','mythicals','mythics','mythicals','mystics','mystic','mysticals','mystical'].include?(name.downcase)
  name='Retro-Prfs' if ['retroprf','retro-prf','retroactive','f2prfs','f2prf','retroprfs','retro-prfs'].include?(name.downcase)
  j=-1
  # try full-name matches first...
  g=@groups.map{|q| q}
  for i in 0...g.length
    j=i if g[i][0].downcase==name.downcase && (g[i][2].nil? || g[i][2].include?(k))
  end
  return j if j>=0
  # ...then try partial-name matches
  name='BraveHeroes' if ['braveheroes','brave','cyl'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='FallenHeroes' if ['fallenheroes','fallen','dark','evil','alter'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Winter' if ['winter','holiday'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='WorseThanLiki' if ['worsethanliki','wtl'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Bunnies' if ['bunnies','bunny','spring'].map{|q| q[0,name.length]}.include?(name.downcase)
  name="Valentine's" if ['valentines',"valentine's"].map{|q| q[0,name.length]}.include?(name.downcase)
  name="NewYear's" if ['newyears',"newyear's",'newyear'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Wedding' if name.length<6 && ['brides','grooms','bride','groom','wedding'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Falchion_Users' if ['falchionusers'].map{|q| q[0,name.gsub('-','').gsub('_','').length]}.include?(name.downcase.gsub('-','').gsub('_',''))
  name='Dancers&Singers' if ['dancers','singers'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Helspawn' if ['hellspawn'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Legendaries' if ['legendary','legend','legends'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Retro-Prfs' if ['retroprf','retro-prf','retroactive','f2prfs','f2prf','retroprfs','retro-prfs'].map{|q| q[0,name.length]}.include?(name.downcase)
  for i in 0...g.length
    j=i if g[i][0][0,name.length].downcase==name.downcase && (g[i][2].nil? || g[i][2].include?(k))
  end
  return j if j>=0
  return -1
end

def reshape_unit_into_multi(name,args3) # used by the find_unit_in_string function to switch a unit match into a relevant multi-unit
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || @shardizard==4
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return unit_into_multi(name,args3)
end

def find_name_in_string(event,stringx=nil,mode=0) # used to find not only a unit based on the input string, but also the portion of said input string that matched the unit - name, alias, multi-unit alias, etc.
  data_load()
  stringx=event.message.text if stringx.nil?
  s=stringx
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(stringx.downcase[0,2]) && s.length>1
  s=s[4,s.length-4] if ['feh!','feh?'].include?(stringx.downcase[0,4]) && s.length>3
  s=s[0,s.length-2] if ["``"].include?(stringx.downcase[stringx.length-2,2]) && s.length>1
  a=s.gsub('.','').split(' ')
  s=stringx if all_commands().include?(a[0])
  args=sever(s,true).split(' ')
  args2=sever(s,true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.reject{ |a| ['+','-'].include?(a[0,1]) && ['hp','attack','speed','defense','resistance','atk','att','spd','def','defence','res','health','strength','str','magic','mag'].include?(a[1,a.length-1].downcase)}
  args=args.reject{ |a| ['hp','attack','speed','defense','resistance','atk','att','spd','def','defence','res','health','strength','str','magic','mag'].include?(a.downcase)}
  args=args.reject{ |a| a[0,1]=='+' && a[1,a.length-1].to_i.to_s==a[1,a.length-1] }
  args=args.reject{ |a| a[0,a.length-1].to_i.to_s==a[0,a.length-1] && a[a.length-1,1]=='*'}
  args=args.reject{ |a| a.to_i.to_s==a}
  args=args.reject{ |a| find_skill(a,event,true)>-1 }
  args=args.reject{ |a| a=="``"}
  args.compact!
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(stringx.downcase[0,2]) && s.length>1 && ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(stringx.downcase[0,4]) && s.length>3 && ['feh!','feh?'].include?(s.downcase[0,2])
  a=s.split(' ')
  args.shift if all_commands().include?(a[0])
  args2=args.join(' ').split(' ')
  args4=args.join(' ').split(' ')
  name=args.join('')
  data_load()
  args3=args.join(' ').split(' ')
  # Find the most accurate unit name among the remaining inputs
  if find_unit(name,event)>=0
    args3=args.join(' ').split(' ')
    name=@units[find_unit(name,event)][0]
    name=reshape_unit_into_multi(name,args3)
  else
    for i in 0...args.length
      for i2 in 0...args.length-i
        if find_unit(name,event)<0 && find_unit(args[i,args.length-i-i2].join('').downcase,event,true)>=0
          args3=args[i,args.length-i-i2]
          name=@units[find_unit(args[i,args.length-i-i2].join('').downcase,event,true)][0]
        end
      end
    end
    name=reshape_unit_into_multi(name,args3)
  end
  n="#{name}"
  if find_unit(name,event)<0
    for i in 0...args.length
      for i2 in 0...args.length-i
        if find_unit(name,event)<0 && find_unit(args[i,args.length-i-i2].join('').downcase,event)>=0
          args3=args[i,args.length-i-i2]
          name=@units[find_unit(args[i,args.length-i-i2].join('').downcase,event)][0]
        end
      end
    end
    n="#{name}"
    name=reshape_unit_into_multi(name,args3)
  end
  return nil if args3.nil? || (find_unit(name,event)<0 && n==name)
  return [name,args3.join(' ')] if mode==1
  return name
end

def stat_modify(x,includerefines=false) # used to find all stat names regardless of format and turn them into their proper format
  x='HP' if ['hp','health'].include?(x.downcase)
  x='Attack' if ['attack','atk','att','strength','str','magic','mag'].include?(x.downcase)
  x='Speed' if ['spd','speed'].include?(x.downcase)
  x='Defense' if ['defense','def','defence'].include?(x.downcase)
  x='Resistance' if ['res','resistance'].include?(x.downcase)
  if includerefines
    x='Effect' if ['effect','special','eff'].include?(x.downcase)
    x='Wrathful' if ['wrazzle','wrathful'].include?(x.downcase)
    x='Dazzling' if ['dazzle','dazzling'].include?(x.downcase)
  end
  return x
end

def find_stats_in_string(event,stringx=nil,mode=0,name=nil) # used to find the rarity, merge count, nature, weapon refinement, and any blessings within the inputs
  stringx=event.message.text if stringx.nil?
  s=stringx
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(stringx.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(stringx.downcase[0,4])
  a=s.split(' ')
  s=stringx if all_commands().include?(a[0])
  nicknames_load()
  if name.nil?
    s=(first_sub(s,find_name_in_string(event,s,1)[1],'') rescue s) unless @multi_aliases.map{|q| q[0].downcase}.include?(s)
  else
    s=(first_sub(s,name,'') rescue s) unless @multi_aliases.map{|q| q[0].downcase}.include?(s)
  end
  if s.gsub(' ','').length.zero?
    args=[]
  else
    args=sever(s,true).gsub('.','').split(' ')
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args2=args.reject{ |q| ['feh!','feh?'].include?(q.downcase[0,4]) || ['f?','e?','h?'].include?(q.downcase[0,2]) }
  unless args2.length<=0
    args2.shift if ['feh'].include?(args2[0].downcase[0,3]) || ['f?','e?','h?'].include?(args2[0].downcase[0,2])
  end
  merges=nil
  rarity=nil
  boon=nil
  bane=nil
  summoner=nil
  refinement=nil
  blessing=[]
  transformed=false
  if args2.length>0
    cornatures=[['HP','Robust','Sickly'],
                ['Attack','Strong','Weak'],
                ['Attack','Clever','Dull'],
                ['Speed','Quick','Sluggish'],
                ['Defense','Sturdy','Fragile'],
                ['Resistance','Calm','Excitable']]
    # first pass through inputs, searching for anything that has self-contained context clues as for what variable it should fill
    for i in 0...args.length
      for j in 0...cornatures.length
        if args[i].downcase==cornatures[j][1].downcase
          args[i]="+#{cornatures[j][0]}"
        elsif args[i].downcase==cornatures[j][2].downcase
          args[i]="-#{cornatures[j][0]}"
        end
      end
      if ['s','ssupport','supports','support'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        summoner='S' if summoner.nil?
      elsif ['a','asupport','supporta'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        summoner='A' if summoner.nil?
      elsif ['b','bsupport','supportb'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        summoner='B' if summoner.nil?
      elsif ['c','csupport','supportc'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        summoner='C' if summoner.nil?
      elsif ['t','transformed','transform'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        transformed=true
      end
      if args[i][0,1]=='+'
        x=args[i].gsub('(','').gsub(')','')[1,args[i].gsub('(','').gsub(')','').length-1]
        if x.to_i.to_s==x && merges.nil? # numbers preceeded by a plus sign automatically fill the merges variable
          merges=x.to_i
          args[i]=nil
        else # stat names preceeded by a plus sign automatically fill the boon variable
          x=stat_modify(x)
          if ['HP','Attack','Speed','Defense','Resistance'].include?(x) && boon.nil?
            boon=x
            args[i]=nil
          end
        end
      elsif args[i][0,3]=='(+)' # stat names preceeded by a plus sign in parentheses automatically fill the refinement variable
        x=stat_modify(args[i][3,args[i].length-3])
        if ['Attack','Speed','Defense','Resistance'].include?(x)
          refinement=x if refinement.nil?
          args[i]=nil
        end
      elsif args[i].length>9 && (args[i].gsub('(','').gsub(')','')[0,9].downcase=='blessing2' || args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-9,9].downcase=='blessing2')
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing2',''))
        if ['Attack','Speed','Defense','Resistance'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>15 && (['blessingmythical','mythicalblessing'].include?(args[i].gsub('(','').gsub(')','')[0,15].downcase) || ['blessingmythical','mythicalblessing'].include?(args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-15,15].downcase))
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing','').gsub('mythical',''))
        if ['Attack','Speed','Defense','Resistance'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>13 && (['blessingmythic','mythicblessing'].include?(args[i].gsub('(','').gsub(')','')[0,13].downcase) || ['blessingmythic','mythicblessing'].include?(args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-13,13].downcase))
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing','').gsub('mythic',''))
        if ['Attack','Speed','Defense','Resistance'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>8 && (args[i].gsub('(','').gsub(')','')[0,8].downcase=='blessing' || args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-8,8].downcase=='blessing')
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing',''))
        if ['Attack','Speed','Defense','Resistance'].include?(x)
          blessing.push("#{x}(Legendary)")
          args[i]=nil
        end
      elsif args[i][0,1]=='(' && args[i][args[i].length-1,1]==')'
        x=stat_modify(args[i][1,args[i].length-2],true)
        if ['Attack','Speed','Defense','Resistance','Effect','Wrathful','Dazzling'].include?(x)
          refinement=x if refinement.nil?
          args[i]=nil
        end
      elsif args[i].gsub('(','').gsub(')','')[0,1]=='-' # stat names preceeded by a minus sign automatically fill the bane variable
        x=stat_modify(args[i].gsub('(','').gsub(')','')[1,args[i].gsub('(','').gsub(')','').length-1])
        if ['HP','Attack','Speed','Defense','Resistance'].include?(x) && bane.nil?
          bane=x
          args[i]=nil
        end
      elsif args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-1,1]=='*' # numbers followed by an asterisk automatically fill the rarity variable
        x=args[i].gsub('(','').gsub(')','')[0,args[i].gsub('(','').gsub(')','').length-1]
        if x.to_i.to_s==x && rarity.nil?
          rarity=x.to_i
          args[i]=nil
        end
      elsif args[i].gsub('(','').gsub(')','').length>5 && args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-5,5].downcase=='-star' # numbers followed by the word "star" automatically fill the rarity variable
        x=args[i].gsub('(','').gsub(')','')[0,args[i].gsub('(','').gsub(')','').length-5]
        if x.to_i.to_s==x && rarity.nil?
          rarity=x.to_i
          args[i]=nil
        end
      elsif args[i].gsub('(','').gsub(')','').length>4 && args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-4,4].downcase=='star' # numbers followed by the word "star" automatically fill the rarity variable
        x=args[i].gsub('(','').gsub(')','')[0,args[i].gsub('(','').gsub(')','').length-4]
        if x.to_i.to_s==x && rarity.nil?
          rarity=x.to_i
          args[i]=nil
        end
      elsif !find_nature(args[i].gsub('(','').gsub(')','')).nil? && (boon.nil? || bane.nil?) # Certain Pokemon nature names will fill both the boon and bane variables
        boon=find_nature(args[i].gsub('(','').gsub(')',''))[1] if boon.nil?
        bane=find_nature(args[i].gsub('(','').gsub(')',''))[2] if bane.nil?
        args[i]=nil
      end
      if i>0 && !args[i-1].nil? && !args[i].nil?
        x=stat_modify(args[i-1].gsub('(','').gsub(')',''))
        y=stat_modify(args[i].gsub('(','').gsub(')',''))
        if args[i].gsub('(','').gsub(')','').downcase=='star' && args[i-1].gsub('(','').gsub(')','').to_i.to_s==args[i-1].gsub('(','').gsub(')','') && rarity.nil?
          # the word "star", if preceeded by a number, will automatically fill the rarity variable with that number
          rarity=args[i-1].gsub('(','').gsub(')','').to_i
          args[i]=nil
          args[i-1]=nil
        elsif args[i].gsub('(','').gsub(')','').downcase=='mode' && ['Attack','Speed','Defense','Resistance'].include?(x) && refinement.nil?
          # the word "mode", if preceeded by a stat name other than HP, will turn that stat into the refinement of the weapon the unit is equipping
          refinement=x
          args[i]=nil
          args[i-1]=nil
        elsif args[i].gsub('(','').gsub(')','').downcase=='blessing' && ['Attack','Speed','Defense','Resistance'].include?(x)
          # the word "blessing", if preceeded by a stat name other than HP, will turn that stat into a blessing to be applied to the character
          bbb='Legendary'
          bbb=blessing[0].split('(')[1] if blessing.length>0
          blessing.push("#{x}(#{bbb}")
          args[i]=nil
          args[i-1]=nil
        elsif args[i-1].gsub('(','').gsub(')','').downcase=='(+)' && ['Attack','Speed','Defense','Resistance'].include?(y) && refinement.nil?
          # the character arrangement "(+)", if followed by a stat name other than HP, will turn that stat into the refinement of the weapon the unit is equipping
          refinement=y
          args[i]=nil
          args[i-1]=nil
        elsif args[i-1].gsub('(','').gsub(')','').downcase=='plus' && ['HP','Attack','Speed','Defense','Resistance'].include?(y) && boon.nil?
          # the word "plus", if followed by a stat name, will turn that stat into the unit's boon
          boon=y
          args[i]=nil
          args[i-1]=nil
        elsif args[i-1].gsub('(','').gsub(')','').downcase=='minus' && ['HP','Attack','Speed','Defense','Resistance'].include?(y) && bane.nil?
          # the word "minus", if followed by a stat name, will turn that stat into the unit's bane
          bane=y
          args[i]=nil
          args[i-1]=nil
        elsif args[i].gsub('(','').gsub(')','').downcase=='boon' && ['HP','Attack','Speed','Defense','Resistance'].include?(x) && boon.nil?
          # the word "boon", if preceeded by a stat name, will turn that stat into the unit's boon
          boon=x
          args[i]=nil
          args[i-1]=nil
        elsif args[i].gsub('(','').gsub(')','').downcase=='bane' && ['HP','Attack','Speed','Defense','Resistance'].include?(x) && bane.nil?
          # the word "minus", if preceeded by a stat name, will turn that stat into the unit's bane
          bane=x
          args[i]=nil
          args[i-1]=nil
        end
      end
      unless args[i].nil?
        refinement='Effect' if ['effect','special','eff'].include?(args[i].gsub('(','').gsub(')','').downcase) && refinement.nil?
        refinement='Wrathful' if ['wrazzle','wrathful'].include?(args[i].gsub('(','').gsub(')','').downcase) && refinement.nil?
        refinement='Dazzling' if ['dazzle','dazzling'].include?(args[i].gsub('(','').gsub(')','').downcase) && refinement.nil?
      end
    end
    args.compact!
    # second pass through arguments, literally only searching for remaining stats with a plus sign in front of them
    # applicable moments will fill the refinement variable if empty
    if refinement.nil? && args.length>0
      for i in 0...args.length
        if args[i][0,1]=='+'
          x=stat_modify(args[i].gsub('(','').gsub(')','')[1,args[i].gsub('(','').gsub(')','').length-1])
          if ['HP','Attack','Speed','Defense','Resistance'].include?(x) && refinement.nil?
            refinement=x
            args[i]=nil
          end
        end
        if i>0 && !args[i-1].gsub('(','').gsub(')','').nil? && !args[i].gsub('(','').gsub(')','').nil?
          x=stat_modify(args[i-1].gsub('(','').gsub(')',''))
          y=stat_modify(args[i].gsub('(','').gsub(')',''))
          if args[i-1].gsub('(','').gsub(')','').downcase=='plus' && ['Attack','Speed','Defense','Resistance'].include?(y) && refinement.nil?
            refinement=y
            args[i]=nil
            args[i-1]=nil
          end
        end
      end
    end
    args.compact!
    # final pass through inputs, searching for numbers and stat names without self-contained context clues
    # numbers will prioritize filling the rarity variable if empty, fall back trying to fill the merges variable if empty
    # stat names will priotitize filling the boon variable if empty, fall back trying to fill the bane variable if empty, double fall back to weapon refinement if applicable
    for i in 0...args.length
      x=stat_modify(args[i].gsub('(','').gsub(')',''))
      if x.to_i.to_s==x
        x=x.to_i
        if x<0 || x>@max_rarity_merge[1]
        elsif rarity.nil? && !x.zero? && x<@max_rarity_merge[0]
          rarity=x
          args[i]=nil
        elsif merges.nil?
          merges=x
          args[i]=nil
        end
      elsif ['HP','Attack','Speed','Defense','Resistance'].include?(x)
        if boon.nil?
          boon=x
          args[i]=nil
        elsif bane.nil?
          bane=x
          args[i]=nil
        elsif refinement.nil? && x != 'HP'
          refinement=x
          args[i]=nil
        end
      end
    end
    args.compact!
  end
  blessing=blessing.reject{|q| q.split('(')[1]!=blessing[0].split('(')[1]} if blessing.length>0
  blessing=[] if blessing.nil?
  unless mode==1
    rarity=5 if rarity.nil?
    merges=0 if merges.nil?
    boon='' if boon.nil?
    bane='' if bane.nil?
    summoner='-' if summoner.nil?
    refinement='' if refinement.nil?
  end
  rarity=@max_rarity_merge[0] if !rarity.nil? && rarity>@max_rarity_merge[0]
  merges=@max_rarity_merge[1] if !merges.nil? && merges>@max_rarity_merge[1]
  return [rarity,merges,boon,bane,summoner,refinement,blessing,transformed]
end

def apply_stat_skills(event,skillls,stats,tempest='',summoner='-',weapon='',refinement='',blessing=[],transformed=false,ignoremax=false) # used to add skill stat increases to a unit's stats
  skillls=skillls.map{|q| q}
  if weapon.nil? || weapon=='' || weapon==' ' || weapon=='-'
  else # this is the weapon's stat effect
    s2=@skills[find_skill(weapon,event)]
    if !s2.nil? && s2[4]=='Weapon' && !s2[15].nil? && !refinement.nil? && refinement.length>0 && (s2[5]!='Staff Users Only' || refinement=='Effect')
      # weapon refinement...
      if find_effect_name(s2,event).length>0
        zzz2=find_effect_name(s2,event,1)
        lookout=[]
        if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
          lookout=[]
          File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
            lookout.push(eval line)
          end
          lookout=lookout.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}
        end
        skillls.push(find_effect_name(s2,event,1)) if refinement=='Effect' && find_effect_name(s2,event,1).length>0 && lookout.map{|q| q[0]}.include?(zzz2) # ...including any stat-based Effect Modes
      end
      sttz=[]
      inner_skill=s2[15]
      mt=[0,0,0,0,0]
      mt[1]=1 if s2[11].split(', ').include?('Silver')
      if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
        mt[1]+=inner_skill[0,1].to_i
        inner_skill=inner_skill[1,inner_skill.length-1]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      elsif inner_skill[0,1]=='-' && inner_skill.length>1
        mt[1]-=inner_skill[1,1].to_i
        inner_skill=inner_skill[2,inner_skill.length-2]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      end
      for i in 0...5
        if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
          mt[i]+=inner_skill[0,1].to_i
          inner_skill=inner_skill[1,inner_skill.length-1]
          inner_skill='y' if inner_skill.nil? || inner_skill.length<1
        elsif inner_skill[0,1]=='-' && inner_skill.length>1
          mt[i]-=inner_skill[1,1].to_i
          inner_skill=inner_skill[2,inner_skill.length-2]
          inner_skill='y' if inner_skill.nil? || inner_skill.length<1
        end
      end
      overides=[[0,0,0,0,0,0,'e'],[0,0,0,0,0,0,'a'],[0,0,0,0,0,0,'s'],[0,0,0,0,0,0,'d'],[0,0,0,0,0,0,'r']]
      for i in 0...overides.length
        if inner_skill[0,3]=="(#{overides[i][6]})"
          inner_skill=inner_skill[3,inner_skill.length-3]
          for i2 in 0...6
            if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
              overides[i][i2]+=inner_skill[0,1].to_i
              inner_skill=inner_skill[1,inner_skill.length-1]
              inner_skill='y' if inner_skill.nil? || inner_skill.length<1
            elsif inner_skill[0,1]=='-' && inner_skill.length>1
              overides[i][i2]-=inner_skill[1,1].to_i
              inner_skill=inner_skill[2,inner_skill.length-2]
              inner_skill='y' if inner_skill.nil? || inner_skill.length<1
            end
          end
        end
      end
      overides[0][6]='Effect'
      overides[1][6]='Attack'
      overides[2][6]='Speed'
      overides[3][6]='Defense'
      overides[4][6]='Resistance'
      if s2[5].include?('Tome Users Only') || ['Bow Users Only','Dagger Users Only'].include?(s2[5])
        sttz.push([0,0,0,0,0,'Effect']) if inner_skill.length>1
        sttzx=[[2,1,0,0,0,'Attack'],[2,0,2,0,0,'Speed'],[2,0,0,3,0,'Defense'],[2,0,0,0,3,'Resistance']]
      else
        sttz.push([3,0,0,0,0,'Effect']) if inner_skill.length>1
        sttzx=[[5,2,0,0,0,'Attack'],[5,0,3,0,0,'Speed'],[5,0,0,4,0,'Defense'],[5,0,0,0,4,'Resistance']]
      end
      for i in 0...sttzx.length
        sttz.push(sttzx[i])
      end
      for i in 0...sttz.length
        k=overides[overides.find_index{|q| q[6]==sttz[i][5]}]
        sttz[i][0]+=k[1]
        sttz[i][1]+=mt[1]+k[0]+k[2]
        sttz[i][2]+=mt[2]+k[3]
        sttz[i][3]+=mt[3]+k[4]
        sttz[i][4]+=mt[4]+k[5]
      end
      sttz.push([0,0,0,0,0,'unrefined'])
      ks=sttz.length-1
      ks=0 if refinement==sttz[0][5]
      ks=1 if refinement==sttz[1][5]
      ks=2 if refinement==sttz[2][5]
      ks=3 if refinement==sttz[3][5]
      ks=4 if refinement==sttz[4][5]
    else
      sttz=[[0,0,0,0,0]]
      ks=0
    end
    s2=@skills[find_skill(weapon,event)]
    s2[12]=[0,0,0,0,0] if s2[12].nil? || !s2.is_a?(Array) || s2[12].length<=0
    stats[1]+=sttz[ks][0]
    stats[2]+=s2[12][1]+sttz[ks][1]
    stats[3]+=s2[12][2]+sttz[ks][2]
    stats[4]+=s2[12][3]+sttz[ks][3]
    stats[5]+=s2[12][4]+sttz[ks][4]
    if s2[5].include?('Beasts Only') && transformed
      stats[2]+=s2[12][6]
      stats[3]+=s2[12][7]
      stats[4]+=s2[12][8]
      stats[5]+=s2[12][9]
    end
  end
  negative=[0,0,0,0,0]
  rally=[0,0,0,0,0]
  if skillls.length>0
    lookout=[]
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
      lookout=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
        lookout.push(eval line)
      end
      lookout=lookout.reject{|q| !['Stat-Affecting','Stat-Buffing','Stat-Nerfing'].include?(q[3][0,q[3].length-2])}
    end
    for i in 0...skillls.length
      statskl=lookout.find_index{|q| q[0]==skillls[i]}
      unless statskl.nil?
        if lookout[statskl][3].include?('Stat-Nerfing')
          statskl=lookout[statskl][4]
          # only the strongest nerf is applied
          negative[1]=[negative[1],-statskl[1]].min
          negative[2]=[negative[2],-statskl[2]].min
          negative[3]=[negative[3],-statskl[3]].min
          negative[4]=[negative[4],-statskl[4]].min
        elsif lookout[statskl][3].include?('Stat-Buffing')
          statskl=lookout[statskl][4]
          # only the strongest buff is applied
          rally[1]=[rally[1],statskl[1]].max
          rally[2]=[rally[2],statskl[2]].max
          rally[3]=[rally[3],statskl[3]].max
          rally[4]=[rally[4],statskl[4]].max
        else
          # all stat-affecting skills are applied
          statskl=lookout[statskl][4]
          stats[1]+=statskl[0]
          stats[2]+=statskl[1]
          stats[3]+=statskl[2]
          stats[4]+=statskl[3]
          stats[5]+=statskl[4]
        end
      end
    end
    # Harsh Command will turn all nerfs into buffs
    if skillls.include?('Harsh Command')
      for i in 0...negative.length
        rally[i]=[rally[i],0-negative[i]].max
        negative[i]=0
      end
    end
    # Panic Ploy reverses all buffs (negative buffs are not the same as debuffs)
    if skillls.include?('Panic Ploy')
      for i in 0...rally.length
        rally[i]=0-rally[i]
      end
    end
  end
  # Tempest/Arena bonus unit buff: +10 HP, +4 to all other stats
  if tempest.length>0
    stats[1]+=10
    stats[2]+=4
    stats[3]+=4
    stats[4]+=4
    stats[5]+=4
  end
  # Summoner Support buffs
  stats[1]+=5 if summoner=='S'
  stats[1]+=4 if ['A','B'].include?(summoner)
  stats[1]+=3 if summoner=='C'
  stats[2]+=2 if summoner=='S'
  stats[3]+=2 if ['S','A'].include?(summoner)
  stats[4]+=2 if ['S','A','B'].include?(summoner)
  stats[5]+=2 if ['S','A','B','C'].include?(summoner)
  # Blessing buffs
  for i in 0...[blessing.length,7].min
    stats[1]+=3
    stats[1]+=2 if blessing[i].include?('Mythical')
    if blessing[i].include?('Attack')
      stats[2]+=2
      stats[2]+=1 if blessing[i].include?('Mythical')
    elsif blessing[i].include?('Speed')
      stats[3]+=3
      stats[3]+=1 if blessing[i].include?('Mythical')
    elsif blessing[i].include?('Defense')
      stats[4]+=4
      stats[4]+=1 if blessing[i].include?('Mythical')
    elsif blessing[i].include?('Resistance')
      stats[5]+=4
      stats[5]+=1 if blessing[i].include?('Mythical')
    end
  end
  stats[2]+=rally[1]+negative[1]
  stats[3]+=rally[2]+negative[2]
  stats[4]+=rally[3]+negative[3]
  stats[5]+=rally[4]+negative[4]
  stats[1]=[[stats[1],1].max,99].min
  unless ignoremax
    stats[2]=[stats[2],0].max
    stats[3]=[stats[3],0].max
    stats[4]=[stats[4],0].max
    stats[5]=[stats[5],0].max
  end
  return stats
end

def apply_combat_buffs(event,skillls,stats,phase) # used to apply in-combat buffs
  k=0
  k=event.server.id unless event.server.nil?
  skillls=skillls.map{|q| q}
  close=[0,0,0,0,0,0]
  distant=[0,0,0,0,0,0]
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| !['Enemy Phase','Player Phase','In-Combat Buffs 1','In-Combat Buffs 2'].include?(q[3])}
  end
  for i in 0...skillls.length
    statskl=lookout.find_index{|q| q[0]==skillls[i]}
    unless statskl.nil?
      statskl=lookout[statskl]
      if statskl[3]=='Player Phase' && phase=='Enemy'
      elsif statskl[3]=='Enemy Phase' && phase=='Player'
      else
        stats[1]+=statskl[4][0]
        stats[2]+=statskl[4][1]
        stats[3]+=statskl[4][2]
        stats[4]+=statskl[4][3]
        stats[5]+=statskl[4][4]
      end
    end
  end
  stats[2]+=[close[2],distant[2]].min
  stats[3]+=[close[3],distant[3]].min
  stats[4]+=[close[4],distant[4]].min
  stats[5]+=[close[5],distant[5]].min
  return stats
end

def make_stat_skill_list_1(name,event,args) # this is for yellow-stat skills
  args=sever(event.message.text,true).split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.downcase.gsub('(','').gsub(')','')}
  nicknames_load()
  k=0
  k=event.server.id unless event.server.nil?
  alz=@aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(k)}.map{|q| [q[1],q[2]]}
  stat_skills=[]
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| q[3]!='Stat-Affecting 1'}
  end
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
    for i2 in 0...lookout[i][2]
      stat_skills.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  lokoout=lookout.map{|q| q[0]}
  args=event.message.text.downcase.split(' ') # reobtain args without the reformatting caused by the sever function
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }.map{|q| q.gsub('(','').gsub(')','')} # remove any mentions included in the inputs
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| q[3]!='Stat-Affecting 2'}
  end
  for i in 0...lookout.length
    lokoout.push(lookout[i][0])
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
    for i2 in 0...lookout[i][2]
      stat_skills.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      stat_skills=[]
      a=@dev_units[dv][9].reject{|q| q.include?('~~')}
      x=[a[a.length-1],@dev_units[dv][12]]
      for i in 0...x.length
        stat_skills.push(x[i]) if lokoout.include?(x[i])
      end
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    return stat_skills if x2.nil?
    a=x[x2][9].reject{|q| q.include?('~~')}
    xa=[a[a.length-1],x[x2][12]]
    stat_skills=[]
    for i in 0...xa.length
      stat_skills.push(xa[i]) if lokoout.include?(xa[i])
    end
  end
  return stat_skills
end

def make_stat_skill_list_2(name,event,args) # this is for blue- and red- stat skills.  Character name is needed to know which movement Hone/Fortify to apply
  args=sever(event.message.text,true).split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.gsub('(','').gsub(')','').downcase}
  nicknames_load()
  k=0
  k=event.server.id unless event.server.nil?
  alz=@aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(k)}.map{|q| [q[1],q[2]]}
  stat_skills_2=[]
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| q[3]!='Stat-Buffing 1' && q[3]!='Stat-Nerfing 1'}
  end
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
    for i2 in 0...lookout[i][2]
      stat_skills_2.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  lokoout=lookout.map{|q| q[0]}
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      stat_skills=[]
      a=@dev_units[dv][9].reject{|q| q.include?('~~')}
      x=[a[a.length-1],@dev_units[dv][12]]
      for i in 0...x.length
        stat_skills.push(x[i]) if lokoout.include?(x[i])
      end
    end
  end
  hf=[]
  hf2=[]
  j=find_unit(name,event)
  # Only the first eight - was six until Rival Domains was released - Hone/Fortify skills are allowed, as that's the most that can apply to the unit at once.
  # Tactic skills stack with this list's limit, but allow up to fourteen to be applied
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| q[3]!='Stat-Buffing 2' && q[3]!='Stat-Nerfing 2'}
  end
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
  end
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil? || (lookout[skl][5] && @units[j][1][1]!=lookout[skl][1].split(' ')[1][0,6].gsub('s',''))
      skl=lookout[skl]
      if skl[2]==1
        hf.push(skl[0])
      elsif skl[2]==2
        hf2.push(skl[0])
      end
    end
  end
  for i in 0...8
    stat_skills_2.push(hf[i]) if hf.length>i
  end
  for i in 0...14-[8,hf.length].min
    stat_skills_2.push(hf2[i]) if hf2.length>i
  end
  # Rally skills not stacking with themselves is handled in the apply_stat_skills function, so 'unaccepted' duplication is allowed.
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| q[3]!='Stat-Buffing 3' && q[3]!='Stat-Nerfing 3'}
  end
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
  end
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil?
      stat_skills_2.push(lookout[skl][0])
    end
  end
  return stat_skills_2
end

def make_combat_skill_list(name,event,args) # this is for skills that apply in-combat buffs.  Character name is needed to know which movement Goad/Ward to apply
  args=sever(event.message.text,true).split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.gsub('(','').gsub(')','').downcase}
  nicknames_load()
  k=0
  k=event.server.id unless event.server.nil?
  alz=@aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(k)}.map{|q| [q[1],q[2]]}
  stat_skills_3=[]
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| q[3]!='Enemy Phase' && q[3]!='Player Phase' && q[3]!='In-Combat Buffs 1'}
  end
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
    for i2 in 0...lookout[i][2]
      stat_skills_3.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  lokoout=lookout.map{|q| q[0]}
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      stat_skills_3=[]
      a=@dev_units[dv][9].reject{|q| q.include?('~~')}
      x=[a[a.length-1],@dev_units[dv][12]]
      for i in 0...x.length
        stat_skills_3.push(x[i]) if lokoout.include?(x[i])
      end
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    unless x2.nil?
      a=x[x2][9].reject{|q| q.include?('~~')}
      xa=[a[a.length-1],x[x2][12]]
      stat_skills_3=[]
      for i in 0...xa.length
        stat_skills_3.push(xa[i]) if lokoout.include?(xa[i])
      end
    end
  end
  hf=[]
  hf2=[]
  j=find_unit(name,event)
  # Only the first eight Spur/Goad/Ward skills are allowed, as that's the most that can apply to the unit at once.
  # Tactic skills stack with this list's limit, but allow up to fourteen to be applied
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| q[3]!='In-Combat Buffs 2'}
  end
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
  end
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil? || (lookout[skl][5] && @units[j][1][1]!=lookout[skl][1].split(' ')[1][0,6].gsub('s',''))
      skl=lookout[skl]
      if skl[2]==1
        hf.push(skl[0])
      elsif skl[2]==2
        hf2.push(skl[0])
      end
    end
  end
  for i in 0...8
    stat_skills_3.push(hf[i]) if hf.length>i
  end
  for i in 0...14-[8,hf.length].min
    stat_skills_3.push(hf2[i]) if hf2.length>i
  end
  return stat_skills_3
end

def pick_thumbnail(event,j,bot) # used to choose the thumbnail used by most embeds involving units
  data_load()
  d=@units[j]
  return nil if d.nil?
  return 'http://vignette.wikia.nocookie.net/fireemblem/images/0/04/Kiran.png' if d[0]=='Kiran'
  return bot.user(d[13][1]).avatar_url if d.length>13 && !d[13].nil? && !d[13][1].nil? && d[13][1].is_a?(Integer) && !bot.user(d[13][1]).nil?
  return 'https://cdn.discordapp.com/emojis/418140222530912256.png' if d[0]=='Nino(Launch)' && (event.message.text.downcase.include?('face') || rand(100).zero?)
  return 'https://cdn.discordapp.com/emojis/420339780421812227.png' if d[0]=='Amelia' && (event.message.text.downcase.include?('face') || rand(1000).zero?)
  return 'https://cdn.discordapp.com/emojis/420339781524783114.png' if d[0]=='Reinhardt(Bonds)' && (event.message.text.downcase.include?('grin') || rand(100).zero?)
  return 'https://cdn.discordapp.com/emojis/437515327652364288.png' if d[0]=='Reinhardt(World)' && (event.message.text.downcase.include?('grin') || rand(100).zero?)
  return 'https://cdn.discordapp.com/emojis/437519293240836106.png' if d[0]=='Arden' && (event.message.text.downcase.include?('woke') || rand(100).zero?)
  return 'https://cdn.discordapp.com/emojis/420360385862828052.png' if d[0]=='Sakura' && event.message.text.downcase.include?("mathoo's")
  return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{d[0].gsub(' ','_')}/Face_FC.png"
end

def unit_color(event,j,name=nil,mode=0,m=false,chain=false) # used to choose the color of the sidebar used by must embeds including units.
  xcolor=0xFFD800
  jj=@units[j]
  # Weapon colors
  xcolor=0xE22141 if jj[1][0]=='Red'
  xcolor=0x2764DE if jj[1][0]=='Blue'
  xcolor=0x09AA24 if jj[1][0]=='Green'
  xcolor=0x64757D if jj[1][0]=='Colorless'
  unless chain
    # Elemental colors - unused after the first embed
    xcolor=0xF98281 if jj[2][0]=='Fire'
    xcolor=0x91F4FF if jj[2][0]=='Water'
    xcolor=0x97FF99 if jj[2][0]=='Wind'
    xcolor=0xFFAF7E if jj[2][0]=='Earth'
    xcolor=0xFDF39D if jj[2][0]=='Light'
    xcolor=0xBE83FE if jj[2][0]=='Dark'
    xcolor=0xF5A4DA if jj[2][0]=='Astra'
    xcolor=0xE1DACF if jj[2][0]=='Anima'
  end
  # Special colors
  xcolor=0x00DAFA if m && find_in_dev_units(jj[0])>0
  xcolor=0xFFABAF if jj[0]=='Sakura' && m
  xcolor=0x9400D3 if jj[0]=='Kiran'
  xcolor=0x64757D if event.user.id==198201016984797184
  xcolor=avg_color([[39,100,222],[9,170,36]]) if name=='Robin' || name=='Robin (Shared stats)'
  if donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==jj[0]}
    unless x2.nil?
      x=donate_trigger_word(event,nil,1)
      xcolor=x unless x.nil? || x<0
    end
  end
  return [xcolor/256/256, (xcolor/256)%256, xcolor%256] if mode==1 # in mode 1, return as three single-channel numbers - used when averaging colors
  return xcolor
end

def alter_classes(event,str) # used to see if weapon classes that didn't exist at the time of coding this function do exist now
  data_load()
  g=get_markers(event)
  return @units.reject{|q| !has_any?(g, q[13][0]) || q[1][1]!='Healer'}.map{|q| q[1][0]}.reject{|q| q=='Colorless'}.uniq.length>0 if str=='Colored Healers'
  return @units.reject{|q| !has_any?(g, q[13][0]) || q[1][1]!='Blade'}.map{|q| q[1][0]}.reject{|q| q !='Colorless'}.uniq.length>0 if str=='Colorless Blades' || str=='Rods'
  return @units.reject{|q| !has_any?(g, q[13][0]) || q[1][1]!='Tome'}.map{|q| q[1][0]}.reject{|q| q != 'Colorless'}.uniq.length>0 if str=='Colorless Tomes'
  return @units.reject{|q| !has_any?(g, q[13][0]) || q[1][1]!='Beast'}.map{|q| q[1][0]}.uniq.length>0 if str=='Beasts'
  return false
end

def unit_clss(bot,event,j,name=nil) # used by almost every command involving a unit to figure out how to display their weapon and movement class
  jj=@units[j]
  return "<:Summon_Gun:467557566050861074> *Summon Gun*\n<:Icon_Move_Unknown:443332226478768129> *Summoning Gates*" if jj[0]=='Kiran' || name=='Kiran'
  w=jj[1][1]
  clr='Gold'
  clr=jj[1][0] if ['Red','Blue','Green','Colorless'].include?(jj[1][0])
  clr='Cyan' if name=='Robin (Shared stats)'
  clr='Gold' if event.user.id==198201016984797184
  wpn='Unknown'
  wpn=jj[1][1].gsub('Healer','Staff') if ['Blade','Tome','Dragon','Beast','Bow','Dagger','Healer'].include?(jj[1][1])
  wemote=''
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clr}_#{wpn}"}
  wemote=moji[0].mention unless moji.length<=0
  unless jj[1][2].nil? || name=='Robin (Shared stats)'
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{jj[1][2]}_#{wpn}"}
    wemote=moji[0].mention unless moji.length<=0
  end
  w='Sword' if jj[1][0]=='Red' && w=='Blade'
  w='Lance' if jj[1][0]=='Blue' && w=='Blade'
  w='Axe' if jj[1][0]=='Green' && w=='Blade'
  w='Rod' if jj[1][0]=='Colorless' && w=='Blade'
  if jj[1][1]!=w
    w="*#{w}* (#{jj[1][0]} #{jj[1][1]})"
  elsif ['Tome', 'Dragon', 'Bow', 'Dagger'].include?(w) || (w=='Healer' && alter_classes(event,'Colored Healers'))
    w="*#{jj[1][0]} #{jj[1][1]}*"
  elsif jj[1][0]=='Gold'
    w="*#{w}*"
  else
    w="*#{w}* (#{jj[1][0]})"
  end
  w="*#{jj[1][2]} Mage* (#{jj[1][0]} Tome)" if w[w.length-6,6]==" Tome*" && !jj[1][2].nil?
  w="*#{jj[1][0]} Mage* (#{jj[1][0]} Tome)" if w[w.length-6,6]==" Tome*" && jj[1][2].nil?
  w='*>Unknown<*' if jj[1].nil? || jj[1][0].nil? || jj[1][0].length<=0
  w='*Mage* (Tome)' if name=='Robin (Shared stats)'
  w=jj[1][1] if jj[0]=='Kiran'
  m=jj[3]
  m='>Unknown<' if jj[3].nil? || jj[3].length<=0
  mov='Unknown'
  mov=jj[3] if ['Infantry','Armor','Flier','Cavalry'].include?(jj[3])
  moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{mov}"}
  memote=''
  memote=moji[0].mention unless moji.length<=0
  lemote1=''
  lemote2=''
  dancer=''
  sklz=@skills.map{|q| q}
  dancer="\n<:Assist_Music:454462054959415296> *Dancer*" if !sklz.find_index{|q| q[0]=='Dance'}.nil? && sklz[sklz.find_index{|q| q[0]=='Dance'}][9].map{|q| q.split(', ').include?(jj[0])}.include?(true)
  dancer="\n<:Assist_Music:454462054959415296> *Singer*" if !sklz.find_index{|q| q[0]=='Sing'}.nil? && sklz[sklz.find_index{|q| q[0]=='Sing'}][9].map{|q| q.split(', ').include?(jj[0])}.include?(true)
  if !jj[2].nil? && jj[2][0]!=' '
    element='Unknown'
    element=jj[2][0] if ['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima'].include?(jj[2][0])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
    lemote1=moji[0].mention unless moji.length<=0
    stat='Spectrum'
    stat=jj[2][1] if ['Attack','Speed','Defense','Resistance'].include?(jj[2][1])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{stat}"}
    lemote2=moji[0].mention unless moji.length<=0
  end
  lm='Legendary/Mythic'
  lm='Legendary' if ['Fire','Water','Wind','Earth'].include?(jj[2][0])
  lm='Mythic' if ['Light','Dark','Astra','Anima'].include?(jj[2][0])
  return "#{wemote} #{w}\n#{memote} *#{m}*#{dancer}#{"\n#{lemote1}*#{jj[2][0]}*/#{lemote2}*#{jj[2][1]}* #{lm} Hero" unless jj[2][0]==" "}#{"\n<:Current_Arena_Bonus:498797967042412544> Current Arena Bonus unit" if get_bonus_units('Arena').include?(jj[0])}#{"\n<:Current_Tempest_Bonus:498797966740422656> Current Tempest Bonus unit" if get_bonus_units('Tempest').include?(jj[0])}#{"\n<:Current_Aether_Bonus:510022809741950986> Current Aether Bonus unit" if get_bonus_units('Aether').include?(jj[0])}"
end

def unit_moji(bot,event,j=-1,name=nil,m=false,mode=0,uuid=-1) # used primarily by the BST and Alt commands to display a unit's weapon and movement classes as emojis
  return '' if was_embedless_mentioned?(event) && mode%4<2
  return '' if name.nil? && j<0
  j=@units.find_index{|q| q[0]==name} if j<0
  return '' if j.nil?
  jj=@units[j]
  clr='Gold'
  clr=jj[1][0] if ['Red','Blue','Green','Colorless'].include?(jj[1][0])
  clr='Cyan' if name=='Robin (Shared stats)'
  if mode%2==1
    clr='Gold' if ['Dragon','Bow','Dagger'].include?(jj[1][1])
    clr='Gold' if jj[1][1]=='Healer' && alter_classes(event,'Colored Healers')
  end
  clr='Gold' if event.user.id==198201016984797184
  wpn='Unknown'
  wpn=jj[1][1].gsub('Healer','Staff') if ['Blade','Tome','Dragon','Beast','Bow','Dagger','Healer'].include?(jj[1][1])
  wemote=''
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clr}_#{wpn}"}
  wemote=moji[0].mention unless moji.length<=0
  unless jj[1][2].nil? || name=='Robin (Shared stats)'
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{jj[1][2]}_#{wpn}"}
    wemote=moji[0].mention unless moji.length<=0
  end
  return wemote if mode%2==1
  mov='Unknown'
  mov=jj[3] if ['Infantry','Armor','Flier','Cavalry'].include?(jj[3])
  moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{mov}"}
  memote=''
  memote=moji[0].mention unless moji.length<=0
  dancer=''
  data_load()
  sklz=@skills.map{|q| q}
  dancer='<:Assist_Music:454462054959415296>' if !sklz.find_index{|q| q[0]=='Dance'}.nil? && sklz[sklz.find_index{|q| q[0]=='Dance'}][9].map{|q| q.split(', ').include?(jj[0])}.include?(true)
  dancer='<:Assist_Music:454462054959415296>' if !sklz.find_index{|q| q[0]=='Sing'}.nil? && sklz[sklz.find_index{|q| q[0]=='Sing'}][9].map{|q| q.split(', ').include?(jj[0])}.include?(true)
  lemote1=''
  lemote2=''
  if !jj[2].nil? && jj[2][0]!=' '
    element='Unknown'
    element=jj[2][0] if ['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima'].include?(jj[2][0])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
    lemote1=moji[0].mention unless moji.length<=0
    stat='Spectrum'
    stat=jj[2][1] if ['Attack','Speed','Defense','Resistance'].include?(jj[2][1])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{stat}"}
    lemote2=moji[0].mention unless moji.length<=0
  end
  semote=''
  semote='<:Icon_Support_Cyan:497430896249405450>' if m && find_in_dev_units(jj[0])>0
  semote="<:Icon_Support_Cyan:497430896249405450><:Icon_Support:448293527642701824>" if jj[0]=='Sakura' && m
  if donate_trigger_word(event)>0 || uuid>-1
    uid=donate_trigger_word(event)
    if uuid.is_a?(String)
      uid=donate_trigger_word(event,uuid)
    elsif uuid<=0
      uuid=nil
    else
      uid=uuid unless uuid.nil? || uuid<=0
    end
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==jj[0]}
    unless x2.nil?
      x=donate_trigger_word(event,uuid,2)
      moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "Icon_Support_#{x}"}
      semote=moji[0].mention unless moji.length<=0
      semote="#{semote}<:Icon_Support:448293527642701824>" unless donor_unit_list(uid)[x2][5]=='-'
    end
  end
  return "#{wemote}#{memote}#{dancer}#{lemote1}#{lemote2}#{"<:Current_Arena_Bonus:498797967042412544>" if get_bonus_units('Arena').include?(jj[0]) && mode%8<4}#{"<:Current_Tempest_Bonus:498797966740422656>" if get_bonus_units('Tempest').include?(jj[0]) && mode%8<4}#{"<:Current_Aether_Bonus:510022809741950986>" if get_bonus_units('Aether').include?(jj[0]) && mode%8<4}#{semote}"
end

def skill_moji(k,event,bot)
  if k[4]=='Weapon'
    m="#{m}<:Skill_Weapon:444078171114045450>"
    m="#{m}<:Red_Blade:443172811830198282>" if k[5]=='Sword Users Only'
    m="#{m}<:Blue_Blade:467112472768151562>" if k[5]=='Lance Users Only'
    m="#{m}<:Green_Blade:467122927230386207>" if k[5]=='Axe Users Only'
    m="#{m}<:Red_Tome:443172811826003968>" if k[5]=='Red Tome Users Only'
    m="#{m}<:Blue_Tome:467112472394858508>" if k[5]=='Blue Tome Users Only'
    m="#{m}<:Green_Tome:467122927666593822>" if k[5]=='Green Tome Users Only'
    m="#{m}<:Gold_Dragon:443172811641454592>" if k[5]=='Dragons Only'
    m="#{m}<:Gold_Bow:443172812492898314>" if k[5]=='Bow Users Only'
    m="#{m}<:Gold_Dagger:443172811461230603>" if k[5]=='Dagger Users Only'
    m="#{m}<:Gold_Staff:443172811628871720>" if k[5]=='Staff Users Only' && alter_classes(event,'Colored Healers')
    m="#{m}<:Colorless_Staff:443692132323295243>" if k[5]=='Staff Users Only' && !alter_classes(event,'Colored Healers')
    if k[5].split(', ')[0]=='Beasts Only'
      m="#{m}<:Gold_Beast:532854442299752469>"
      m2=k[5].split(', ')[1].split(' ').map{|q| q.gsub('s','')}.reject{|q| !['Infantry','Armor','Flier','Cavalry'].include?(q)}
      for i in 0...m2.length
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{m2[i]}"}
        m="#{m}#{moji[0].mention}" if moji.length>0
      end
    end
  elsif k[4]=='Assist'
    m="#{m}<:Skill_Assist:444078171025965066>"
    m="#{m}<:Assist_Music:454462054959415296>" if k[11].split(', ').include?('Music')
    m="#{m}<:Assist_Rally:454462054619807747>" if k[11].split(', ').include?('Rally')
    m="#{m}<:Assist_Staff:454451496831025162>" if k[5]=='Staff Users Only'
  elsif k[4]=='Special'
    m="#{m}<:Skill_Special:444078170665254929>"
    m="#{m}<:Special_Offensive:454460020793278475>" if k[11].split(', ').include?('Offensive')
    m="#{m}<:Special_Defensive:454460020591951884>" if k[11].split(', ').include?('Defensive')
    m="#{m}<:Special_AoE:454460021665693696>" if k[11].split(', ').include?('AoE')
    m="#{m}<:Special_Healer:454451451805040640>" if k[5]=='Staff Users Only'
  else
    m="#{m}<:Passive_A:443677024192823327>" if k[4].split(', ').include?('Passive(A)')
    m="#{m}<:Passive_B:443677023257493506>" if k[4].split(', ').include?('Passive(B)')
    m="#{m}<:Passive_C:443677023555026954>" if k[4].split(', ').include?('Passive(C)')
    m="#{m}<:Passive_S:443677023626330122>" if k[4].split(', ').include?('Passive(S)') || k[4].split(', ').include?('Seal')
    m="#{m}<:Passive_W:443677023706152960>" if k[4].split(', ').include?('Passive(W)')
  end
  return m
end

def skill_tier(name,event) # used by the "used a non-plus version of a weapon that has a + form" tooltip in the stats command to figure out the tier of the weapon
  data_load()
  s=@skills.map{|q| q}
  j=s[s.find_index{|q| q[0]==name.gsub('Laevatein','Bladeblade')}]
  return 1 if j[8]=='-'
  return 1+skill_tier(j[8].gsub(' or ',' ').gsub('*','').split(', ')[0],event) if j[8].include?(', or ')
  return 1+skill_tier(j[8].gsub('*','').split(' or ')[0],event) if j[8].include?(' or ')
  return 1+skill_tier(j[8].gsub('*','').split(', ')[0],event) if j[8].include?(', ')
  return 1+skill_tier(j[8].gsub('*',''),event)
end

def get_bonus_type(event) # used to determine if the embed header should say Tempest or Arena bonus unit
  x=event.message.text.downcase.split(' ')
  x2=[]
  x2.push('Tempest') if x.include?('tempest')
  x2.push('Arena') if x.include?('arena')
  x2.push('Aether') if x.include?('aether') || x.include?('raid')
  x2.push('Tempest/Arena/Aether') if x.include?('bonus') && x2.length<=0
  return x2.join('/')
end

def display_stat_skills(j,stat_skills=nil,stat_skills_2=nil,stat_skills_3=nil,tempest='',blessing=nil,transformed=false,weapon='-',expandedmode=false,modemode=false) # used by the stats command and any derivatives to display which skills are affecting the stats being displayed
  blessing=[] if blessing.nil?
  stat_skills=[] if stat_skills.nil?
  for i in 0...stat_skills.length
    if stat_skills[i][0,20]=='Color Duel Movement '
      if @units[j][1][0]=='Gold'
        stat_skills[i]=stat_skills[i].gsub('Color',@units[j][1][0][0,2]).gsub('Movement',@units[j][3].gsub('Flier','Flying'))
      else
        stat_skills[i]=stat_skills[i].gsub('Color',@units[j][1][0][0,1]).gsub('Movement',@units[j][3].gsub('Flier','Flying'))
      end
    end
  end
  k=[]
  for i in 0...stat_skills.length
    k2=-1
    for i2 in 0...k.length
      k2=i2 if k[i2][0]==stat_skills[i]
    end
    if k2==-1
      k.push([stat_skills[i],1])
    else
      k[k2][1]+=1
    end
  end
  stat_skills=k.map{|q| "#{q[0]}#{" (x#{q[1]})" if q[1]>1}"}
  stat_skills_2=[] if stat_skills_2.nil?
  for i in 0...stat_skills_2.length
    stat_skills_2[i]="Hone #{@units[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=='Hone Movement'
    stat_skills_2[i]="Fortify #{@units[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=='Fortify Movement'
  end
  k=[]
  for i in 0...stat_skills_2.length
    k2=-1
    for i2 in 0...k.length
      k2=i2 if k[i2][0]==stat_skills_2[i]
    end
    if k2==-1
      k.push([stat_skills_2[i],1])
    else
      k[k2][1]+=1
    end
  end
  stat_skills_2=k.map{|q| "#{q[0]}#{" (x#{q[1]})" if q[1]>1}"}
  stat_buffers=[]
  stat_nerfers=[]
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookout.push(eval line)
    end
    lookout=lookout.reject{|q| q[3]!='Stat-Buffing 1' && q[3]!='Stat-Nerfing 1'}
  end
  for i in 0...stat_skills_2.length
    if lookout.find_index{|q| q[0]==stat_skills_2[i]}.nil?
      stat_buffers.push(stat_skills_2[i])
    elsif lookout[lookout.find_index{|q| q[0]==stat_skills_2[i]}][3]=='Stat-Nerfing 1'
      stat_nerfers.push(stat_skills_2[i])
    else
      stat_buffers.push(stat_skills_2[i])
    end
  end
  stat_skills_3=[] if stat_skills_3.nil?
  for i in 0...stat_skills_3.length
    stat_skills_3[i]="Goad #{@units[j][3].gsub('Flier','Fliers')}" if stat_skills_3[i]=='Goad Movement'
    stat_skills_3[i]="Ward #{@units[j][3].gsub('Flier','Fliers')}" if stat_skills_3[i]=='Ward Movement'
  end
  k=[]
  for i in 0...stat_skills_3.length
    k2=-1
    for i2 in 0...k.length
      k2=i2 if k[i2][0]==stat_skills_3[i]
    end
    if k2==-1
      k.push([stat_skills_3[i],1])
    else
      k[k2][1]+=1
    end
  end
  stat_skills_3=k.map{|q| "#{q[0]}#{" (x#{q[1]})" if q[1]>1}"}
  str=''
  str="#{tempest} Bonus unit\n" if tempest.length>0
  str="Not a bonus unit\n" if tempest.length<=0 && expandedmode
  str="#{str}Blessings applied: #{blessing.join(', ')}\n" if blessing.length>0
  str="#{str}No Blessings applied\n" if blessing.length<=0 && expandedmode
  str="#{str}Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0
  str="#{str}Stat-affecting skills: -\n" if stat_skills.length<=0 && expandedmode
  str="#{str}Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0
  str="#{str}Stat-buffing skills: -\n" if stat_buffers.length<=0 && expandedmode
  str="#{str}Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0
  str="#{str}Stat-nerfing skills: -\n" if stat_nerfers.length<=0 && expandedmode
  str="#{str}In-combat buffs: #{stat_skills_3.join(', ')}\n" if stat_skills_3.length>0
  str="#{str}In-combat buffs: -\n" if stat_skills_3.length<=0 && expandedmode
  return "#{str}" if modemode && (weapon=='-' || weapon.include?('~~'))
  return "#{str}Equipped weapon: #{weapon.gsub('Bladeblade','Laevatein')}\nForm: #{@units[j][1][2]} (transformed)\n" if transformed && @units[j][1][1]=='Beast'
  return "#{str}Equipped weapon: #{weapon.gsub('Bladeblade','Laevatein')}\nForm: Humanoid\n" if !transformed && @units[j][1][1]=='Beast'
  return "#{str}Equipped weapon: #{weapon.gsub('Bladeblade','Laevatein')}\n"
end

def display_stars(event,rarity,merges,support='-',expandedmode=false) # used to determine which star emojis should be used, based on the rarity, merge count, and whether the unit is Summoner Supported
  newmerge=false
  newmerge=true if event.message.text.downcase.split(' ').include?('feb') || event.message.text.downcase.split(' ').include?('february')
  t=Time.now
  newmerge=nil if t.year>2019
  newmerge=nil if t.year==2019 && t.month>2
  newmerge=nil if t.year==2019 && t.month==2 && t.day>8
  emo=@rarity_stars[rarity-1]
  if merges==@max_rarity_merge[1]
    emo='<:Icon_Rarity_4p10:448272714210476033>' if rarity==4
    emo='<:Icon_Rarity_5p10:448272715099406336>' if rarity==5
    emo='<:Icon_Rarity_6p10:491487784822112256>' if rarity>5
  end
  emo='<:Icon_Rarity_S:448266418035621888>' unless support=='-'
  emo='<:Icon_Rarity_Sp10:448272715653054485>' if rarity>=5 && merges==@max_rarity_merge[1] && support != '-'
  return "**#{rarity}-star#{" +#{merges}#{' (Feb)' if newmerge}#{' (current)' if newmerge==false}" unless merges.zero? && !expandedmode}**#{"  \u00B7  <:Icon_Support:448293527642701824>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}" if rarity>@rarity_stars.length
  return "#{emo*rarity}#{"**+#{merges}#{' (Feb)' if newmerge}#{' (current)' if newmerge==false}**" unless merges.zero? && !expandedmode}#{"  \u00B7  <:Icon_Support:448293527642701824>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}"
end

def get_unit_prf(name)
  if name=='Robin'
    return [get_unit_prf('Robin(M)')[0],get_unit_prf('Robin(F)')[0]]
  end
  prfs=@skills.reject{|q| !q[6].split(', ').include?(name) || q[4]!='Weapon' || q[0]=='Falchion' || q[0]=='Missiletainn' || q[0]=='Adult (All)'}
  if prfs.length>1
    prfs2=prfs.reject{|q| q[8]!='-'}
    prfs2=prfs.reject{|q| q[9].reject{|q2| !q2.split(', ').include?(name)}.length<=0} if prfs2.length<=0
    prfs2=prfs.reject{|q| q[10].reject{|q2| !q2.split(', ').include?(name)}.length<=0} if prfs2.length<=0
    prfs=[prfs2[0]]
  elsif prfs.length<=0 
    # include the same code as the summoned modifier
  end
  return [prfs[0][0]] if prfs.length>0
  return ['-']
end

def has_weapon_tag?(tag,wpn,refinement=nil,transformed=false)
  return true if wpn[11].split(', ').include?(tag)
  return true if wpn[11].split(', ').include?("(E)#{tag}") && refinement=='Effect'
  return true if wpn[11].split(', ').include?("(R)#{tag}") && !refinement.nil? && refinement.length>0
  return true if wpn[11].split(', ').include?("(T)#{tag}") && transformed
  return true if wpn[11].split(', ').include?("(TE)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[11].split(', ').include?("(ET)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[11].split(', ').include?("(T)(E)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[11].split(', ').include?("(E)(T)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[11].split(', ').include?("(TR)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[11].split(', ').include?("(RT)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[11].split(', ').include?("(T)(R)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[11].split(', ').include?("(R)(T)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return false
end

def disp_stats(bot,name,weapon,event,ignore=false,skillstoo=false,expandedmode=nil,expandedmodex=nil) # displays stats
  newmerge=false
  newmerge=true if event.message.text.downcase.split(' ').include?('feb') || event.message.text.downcase.split(' ').include?('february')
  t=Time.now
  newmerge=nil if t.year>2019
  newmerge=nil if t.year==2019 && t.month>2
  newmerge=nil if t.year==2019 && t.month==2 && t.day>8
  expandedmode=false if expandedmode.nil?
  expandedmodex=!(!expandedmode) if expandedmodex.nil?
  dispstr=" #{event.message.text.downcase} "
  if dispstr.include?(' tiny ') || dispstr.include?(' small ') || dispstr.include?(' smol ') || dispstr.include?(' micro ') || dispstr.include?(' little ')
    disp_tiny_stats(bot,name,weapon,event,ignore)
    return nil
  elsif dispstr.include?(' big ') || dispstr.include?(' tol ') || dispstr.include?(' macro ') || dispstr.include?(' large ')
    expandedmodex=true
  elsif dispstr.include?(' huge ') || dispstr.include?(' massive ')
    expandedmode=true
    expandedmodex=true
  end
  if expandedmode && !safe_to_spam?(event)
    event.respond "I will not wipe the chat completely clean.  Please use this command in PM.\nIn the meantime, I will show the standard form of this command."
    expandedmode=false
    expandedmodex=true
  end
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      disp_stats(bot,name[i],weapon,event,ignore,skillstoo,expandedmode,expandedmodex)
    end
    return nil
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args.compact!
  if name.nil?
    if args.nil? || args.length<1
      event.respond 'No unit was included' unless ignore
      return nil
    end
  end
  untz=@units.map{|q| q}
  flurp=find_stats_in_string(event,nil,0,name)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Legendary','Mythical')}
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Mythical','Legendary')}
  end
  blessing.compact!
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  tempest=get_bonus_type(event)
  diff_num=[0,'','']
  sp=0
  spec_wpn=false
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      spec_wpn=true
      rarity=@dev_units[dv][1]
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      weaponz=@dev_units[dv][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
        sp=350
      else
        refinement=nil
        sp=300
      end
      sp=400 unless @skills[@skills.find_index{|q| q[0]==weapon}][6]=='-'
      for i in 7...12
        zzzzz=@dev_units[dv][i].reject{|q| q.include?('~~')}[-1]
        sp+=@skills[@skills.find_index{|q| q[0]==zzzzz}][1] unless zzzzz.nil? || @skills.find_index{|q| q[0]==zzzzz}.nil?
      end
      zzzzz=@dev_units[dv][12]
      sp+=@skills[@skills.find_index{|q| q[0]==zzzzz}][1] unless zzzzz.nil? || @skills.find_index{|q| q[0]==zzzzz}.nil?
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1]
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      weaponz=x[x2][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        spec_wpn=true
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
        sp=350
        sp=400 unless @skills[@skills.find_index{|q| q[0]==weapon}][6]=='-'
      else
        spec_wpn=true
        refinement=nil
        sp=300
        sp=400 unless @skills[@skills.find_index{|q| q[0]==weapon}][6]=='-'
      end
      for i in 7...12
        zzzzz=x[x2][i].reject{|q| q.include?('~~')}[-1]
        sp+=@skills[@skills.find_index{|q| q[0]==zzzzz}][1] unless zzzzz.nil? || @skills.find_index{|q| q[0]==zzzzz}.nil?
      end
      zzzzz=x[x2][12]
      sp+=@skills[@skills.find_index{|q| q[0]==zzzzz}][1] unless zzzzz.nil? || @skills.find_index{|q| q[0]==zzzzz}.nil?
    end
  elsif " #{event.message.text.downcase} ".include?(' summoned ') || args.map{|q| q.downcase}.include?('summoned')
    if name=='Robin'
      uskl=unit_skills('Robin(M)',event,true,rarity,false,true)[0].reject{|q| q.include?('~~')}
      uskl2=unit_skills('Robin(F)',event,true,rarity,false,true)[0].reject{|q| q.include?('~~')}
      weapon='-'
      weapon2='-'
      weapon=uskl[uskl.length-1] if uskl.length>0
      weapon2=uskl2[uskl2.length-1] if uskl2.length>0
      w2=@skills[find_skill(weapon,event)]
      w22=@skills[find_skill(weapon2,event)]
      diff_num=[w2[2]-w22[2],'M','F']
    else
      uskl=unit_skills(name,event,true,rarity,false,true)[0].reject{|q| q.include?('~~')}
      weapon='-'
      spec_wpn=true if uskl.length>0
      weapon=uskl[uskl.length-1] if uskl.length>0
    end
    spec_wpn=true
    summoner='-'
    tempest=''
    stat_skills=[]
    stat_skills_2=[]
    refinement=nil
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0]
      else
        spec_wpn=true
        w2=@skills[find_skill(weapon,event)]
      end
      if weapon2=='-'
        w22=['-',0,0]
      else
        spec_wpn=true
        w22=@skills[find_skill(weapon2,event)]
      end
      diff_num=[w2[2]-w22[2],'M','F']
    end
  end
  w2=@skills[find_skill(weapon,event)]
  if w2[15].nil?
    refinement=nil
    transformed=false
  elsif w2[15].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[15][0,1].to_i.to_s==w2[15][0,1] && refinement=='Effect'
    refinement=nil if w2[15][1,1]=='*'
  elsif w2[0,1]=='-' && w2[15][1,1].to_i.to_s==w2[15][1,1] && refinement=='Effect'
    refinement=nil if w2[15][2,1]=='*'
  end
  refinement=nil if w2[5]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[5]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  unitz=untz[find_unit(name,event)]
  if name=='Robin'
    if (" #{event.message.text.downcase} ".include?(' summoned ') || args.map{|q| q.downcase}.include?('summoned') || " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')) && !weapon2.nil?
      spec_wpn=true
      wl=weapon_legality(event,'Robin(M)',weapon)
      wl2=weapon_legality(event,'Robin(F)',weapon2)
      wl="#{wl}(M) / #{wl2}(F)"
    else
      spec_wpn=true
      wl=weapon_legality(event,'Robin(M)',weapon)
      wl2=weapon_legality(event,'Robin(F)',weapon)
      wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
    end
  end
  if !spec_wpn
    wl=weapon_legality(event,unitz[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  elsif !refinement.nil? && refinement.length>0
    wl="#{weapon} (+) #{refinement} Mode"
  elsif name != 'Robin'
    wl=weapon
  end
  if find_unit(name,event)<0
    event.respond 'No unit was included' unless ignore
    return nil
  elsif (unitz[4].nil? || (unitz[4].max<=0 && unitz[5].max<=0)) && unitz[0]!='Kiran' # unknown stats
    data_load()
    j=find_unit(name,event)
    xcolor=unit_color(event,j,untz[j][0],0,mu)
    create_embed(event,"__**#{untz[j][0].gsub('Lavatain','Laevatein')}**__","#{unit_clss(bot,event,j)}",xcolor,'Stats currently unknown',pick_thumbnail(event,j,bot))
    disp_unit_skills(bot,untz[j][0],event) if skillstoo || expandedmode
    return nil
  elsif !wl.include?('~~') && (stat_skills_2.length<=0 || unitz[0]=='Kiran') && !expandedmodex && !(args.map{|q| q.downcase}.include?('gps') || args.map{|q| q.downcase}.include?('gp') || args.map{|q| q.downcase}.include?('growths') || args.map{|q| q.downcase}.include?('growth')) && !(event.server.nil? || event.server.id==238059616028590080) && event.channel.id != 362017071862775810
    weapon=wl if name=='Robin'
    disp_tiny_stats(bot,name,weapon,event,ignore,skillstoo,true)
    return nil
  elsif unitz[0]=='Kiran'
    data_load()
    j=find_unit(name,event)
    merges=@max_rarity_merge[1] if merges>@max_rarity_merge[1]
    merges=0 if merges<0
    if merges>10000000
      event.respond "I can't merge that high"
      merges=10000000
    end
    rarity=@max_rarity_merge[0] if rarity>@max_rarity_merge[0]
    rarity=1 if rarity<1
    if rarity>10000000
      event.respond "I can't do rarities that high"
      rarity=10000000
    end
    n=nature_name(boon,bane)
    unless n.nil?
      n=n.join(' / ')
    end
    flds=[["**Level 1#{" +#{merges}" if merges>0}**","<:HP_S:514712247503945739> HP: 0\n<:StrengthS:514712248372166666> Attack: 0\n<:SpeedS:514712247625580555> Speed: 0\n<:DefenseS:514712247461871616> Defense: 0\n<:ResistanceS:514712247574986752> Resistance: 0\n\nBST: 0\nScore: #{27+2*merges}"],["**Level 40#{" +#{merges}" if merges>0}**","<:HP_S:514712247503945739> HP: 0\n<:StrengthS:514712248372166666> Attack: 0\n<:SpeedS:514712247625580555> Speed: 0\n<:DefenseS:514712247461871616> Defense: 0\n<:ResistanceS:514712247574986752> Resistance: 0\n\nBST: 0\nScore: #{115+2*merges}"]]
    if skillstoo
      uskl=unit_skills(name,event).map{|q| q.reject{|q2| q2.include?('Unknown base')}}
      for i in 0...3
        if uskl[i][0].include?('**') && uskl[i]!=uskl[i].reject{|q| !q.include?('**')}
          uskl[i][-1]="#{uskl[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{uskl[i][-1]}"
        end
      end
      uskl=uskl.map{|q| q[q.length-1]}
      flds.push(['Skills',"<:Skill_Weapon:444078171114045450> #{uskl[0]}\n<:Skill_Assist:444078171025965066> #{uskl[1]}\n<:Skill_Special:444078170665254929> #{uskl[2]}\n<:Passive_A:443677024192823327> #{uskl[3]}\n<:Passive_B:443677023257493506> #{uskl[4]}\n<:Passive_C:443677023555026954> #{uskl[5]}#{"\n<:Passive_S:443677023626330122> #{uskl[6]}" unless uskl[6].nil?}"])
    end
    create_embed(event,"__**#{untz[j][0].gsub('Lavatain','Laevatein')}**__","#{display_stars(event,rarity,merges,'-',expandedmode)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{unit_clss(bot,event,j)}\n",0x9400D3,"Please note that the Attack stat displayed here does not include weapon might.  The Attack stat in-game does.",pick_thumbnail(event,j,bot),flds,1)
    return nil
  elsif unitz[4].max<=0 # level 40 stats are known but not level 1
    data_load()
    merges=0 if merges.nil?
    j=find_unit(name,event)
    xcolor=unit_color(event,j,untz[j][0],0,mu)
    atk='<:StrengthS:514712248372166666> Attack'
    atk='<:MagicS:514712247289774111> Magic' if ['Tome','Dragon','Healer'].include?(untz[j][1][1])
    atk='<:StrengthS:514712248372166666> Strength' if ['Blade','Bow','Dagger'].include?(untz[j][1][1])
    zzzl=@skills[find_weapon(weapon,event)]
    atk='<:FreezeS:514712247474585610> Freeze' if has_weapon_tag?('Frostbite',zzzl,refinement,transformed)
    n=nature_name(boon,bane)
    unless n.nil?
      n=n[0] if atk=='<:StrengthS:514712248372166666> Strength'
      n=n[n.length-1] if atk=='<:MagicS:514712247289774111> Magic'
      n=n.join(' / ') if ['<:StrengthS:514712248372166666> Attack','<:FreezeS:514712247474585610> Freeze'].include?(atk)
    end
    atk=atk.gsub(' Freeze',' Attack').gsub(' Strength',' Attack').gsub(' Magic',' Attack') if weapon != '-'
    u40=[untz[j][0],untz[j][5][0],untz[j][5][1],untz[j][5][2],untz[j][5][3],untz[j][5][4]]
    # find stats based on merges
    s=[[u40[1],1],[u40[2],2],[u40[3],3],[u40[4],4],[u40[5],5]]                # all stats
    s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}  # sort the stats based on amount
    s.push(s[0],s[1],s[2],s[3],s[4])                                          # loop the list for use with multiple merges
    m=merges/5                                                                # apply merges, two stats per merge
    if m>0
      for i in 1...6
        u40[i]+=2*m
      end
    end
    m=merges%5
    if m>0
      for i in 0...2*m
        u40[s[i][1]]+=1
      end
    end
    spec_wpn=false
    if name=='Robin'
      spec_wpn=true
      wl=weapon_legality(event,'Robin(M)',weapon)
      wl2=weapon_legality(event,'Robin(F)',weapon)
      wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
    end
    unless spec_wpn
      wl=weapon_legality(event,unitz[0],weapon,refinement)
      weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
    end
    tempest=get_bonus_type(event)
    cru40=u40.map{|a| a}
    u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
    cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed)
    blu40=u40.map{|a| a}
    crblu40=cru40.map{|a| a}
    blu40=apply_stat_skills(event,stat_skills_2,blu40)
    crblu40=apply_stat_skills(event,stat_skills_2,crblu40)
    u40=make_stat_string_list(u40,blu40)
    cru40=make_stat_string_list(cru40,crblu40)
    u40=make_stat_string_list(u40,cru40,2) if wl.include?('~~')
    ftr="Please note that the #{atk.split('> ')[1]} stat displayed here does not include weapon might.  The Attack stat in-game does."
    ftr=nil if weapon != '-'
    flds=[["**Level 1#{" +#{merges}" if merges>0}**","<:HP_S:514712247503945739> HP: unknown\n#{atk}: unknown\n<:SpeedS:514712247625580555> Speed: unknown\n<:DefenseS:514712247461871616> Defense: unknown\n<:ResistanceS:514712247574986752> Resistance: unknown\n\nBST: unknown"],["**Level 40#{" +#{merges}" if merges>0}**","<:HP_S:514712247503945739> HP: #{u40[1]}\n#{atk}: #{u40[2]}#{"(#{diff_num[1]}) / #{u40[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}\n<:SpeedS:514712247625580555> Speed: #{u40[3]}\n<:DefenseS:514712247461871616> Defense: #{u40[4]}\n<:ResistanceS:514712247574986752> Resistance: #{u40[5]}\n\nBST: #{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]}#{"(#{diff_num[1]}) / #{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}"]]
    if skillstoo
      uskl=unit_skills(name,event).map{|q| q.reject{|q2| q2.include?('Unknown base')}}
      for i in 0...3
        if uskl[i][0].include?('**') && uskl[i]!=uskl[i].reject{|q| !q.include?('**')}
          uskl[i][-1]="#{uskl[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{uskl[i][-1]}"
        end
      end
      uskl=uskl.map{|q| q[q.length-1]}
      flds.push(['Skills',"<:Skill_Weapon:444078171114045450> #{uskl[0]}\n<:Skill_Assist:444078171025965066> #{uskl[1]}\n<:Skill_Special:444078170665254929> #{uskl[2]}\n<:Passive_A:443677024192823327> #{uskl[3]}\n<:Passive_B:443677023257493506> #{uskl[4]}\n<:Passive_C:443677023555026954> #{uskl[5]}#{"\n<:Passive_S:443677023626330122> #{uskl[6]}" unless uskl[6].nil?}"])
      flds.shift
    elsif expandedmode && u40[0]!='Robin (Shared stats)'
      uskl=unit_skills(name,event)
      if event.message.text.downcase.include?("mathoo's")
        devunits_load()
        dv=find_in_dev_units(name)
        if dv>=0
          mu=true
          uskl=[@dev_units[dv][6],@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],[@dev_units[dv][12]]]
        end
      end
      flds.push(["<:Skill_Weapon:444078171114045450> **Weapons**",uskl[0].reject{|q| ['Falchion','**Falchion**','Missiletainn','**Missiletainn**','Adult (All)','**Adult (All)**'].include?(q)}.join("\n")])
      flds.push(["<:Skill_Assist:444078171025965066> **Assists**",uskl[1].join("\n")])
      flds.push(["<:Skill_Special:444078170665254929> **Specials**",uskl[2].join("\n")])
      flds.push(["<:Passive_A:443677024192823327> **A Passives**",uskl[3].join("\n")])
      flds.push(["<:Passive_B:443677023257493506> **B Passives**",uskl[4].join("\n")])
      flds.push(["<:Passive_C:443677023555026954> **C Passives**",uskl[5].join("\n")])
      flds.push(["<:Passive_S:443677023626330122> **Sacred Seal**",uskl[6].join("\n")]) if uskl.length>6
    end
    mergetext=''
    if unitz[1][1]=='Beast' && !transformed && !wl.include?('~~') && !['-','',' '].include?(wl) && !w2.nil?
      wlr=wl.split(' (+) ')[0]
      www2=w2[12][5,5]
      www3=www2.reject{|q| q==0}
      sttttz=[]
      if www3.length<=0
      elsif www3.min==www3.max
        sttttz.push('HP') unless www2[0]==0
        sttttz.push('Atk') unless www2[1]==0
        sttttz.push('Spd') unless www2[2]==0
        sttttz.push('Def') unless www2[3]==0
        sttttz.push('Res') unless www2[4]==0
        mergetext="\n\nWhen transformed: #{'+' if www3[0]>0}#{www3[0]} #{sttttz.join('/')}\nInclude the word \"Transformed\" to apply this directly."
      else
        sttttz.push("#{'+' if www2[0]>0}#{www2[0]} HP") unless www2[0]==0
        sttttz.push("#{'+' if www2[1]>0}#{www2[1]} Atk") unless www2[1]==0
        sttttz.push("#{'+' if www2[2]>0}#{www2[2]} Spd") unless www2[2]==0
        sttttz.push("#{'+' if www2[3]>0}#{www2[3]} Def") unless www2[3]==0
        sttttz.push("#{'+' if www2[4]>0}#{www2[4]} Res") unless www2[4]==0
        mergetext="\n\nWhen transformed: #{sttttz.join(', ')}\nInclude the word \"Transformed\" to apply this directly."
      end
    end
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{"<:Icon_Rarity_5:448266417553539104>"*5}#{"**+#{merges}**" if merges>0 || expandedmode}#{"  \u2764 **#{summoner}**" unless summoner=='-'}#{"\nNo Summoner Support" if summoner =='-' && expandedmode}\n*Neutral Nature only so far*\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,expandedmode)}\n#{unit_clss(bot,event,j)}#{mergetext}",xcolor,ftr,pick_thumbnail(event,j,bot),flds,1)
    return nil
  end
  # units for whom both level 40 and level 1 stats are known
  data_load()
  merges=@max_rarity_merge[1] if merges>@max_rarity_merge[1]
  merges=0 if merges<0
  rarity=@max_rarity_merge[0] if rarity>@max_rarity_merge[0]
  rarity=1 if rarity<1
  if merges>10000000
    event.respond "I can't merge that high"
    merges=10000000
  end
  if rarity>10000000
    event.respond "I can't do rarities that high"
    rarity=10000000
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  u40x2=get_stats(event,name,40,5,0,boon,bane)
  u1=get_stats(event,name,1,rarity,merges,boon,bane)
  j=find_unit(name,event)
  atk='<:StrengthS:514712248372166666> Attack'
  atk='<:MagicS:514712247289774111> Magic' if ['Tome','Dragon','Healer'].include?(untz[j][1][1])
  atk='<:StrengthS:514712248372166666> Strength' if ['Blade','Bow','Dagger'].include?(untz[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  atk='<:FreezeS:514712247474585610> Freeze' if has_weapon_tag?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='<:StrengthS:514712248372166666> Strength'
    n=n[n.length-1] if atk=='<:MagicS:514712247289774111> Magic'
    n=n.join(' / ') if ['<:StrengthS:514712248372166666> Attack','<:FreezeS:514712247474585610> Freeze'].include?(atk)
  end
  atk=atk.gsub(' Freeze',' Attack').gsub(' Strength',' Attack').gsub(' Magic',' Attack') if weapon != '-'
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
  end
  xcolor=unit_color(event,j,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|a| a}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed)
  blu40=u40.map{|a| a}
  crblu40=cru40.map{|a| a}
  blu40=apply_stat_skills(event,stat_skills_2,blu40) if stat_skills_2.length>0
  crblu40=apply_stat_skills(event,stat_skills_2,crblu40) if stat_skills_2.length>0
  u40=make_stat_string_list(u40,blu40)
  cru40=make_stat_string_list(cru40,crblu40)
  u40=make_stat_string_list(u40,cru40,2) if wl.include?('~~')
  cru1=u1.map{|a| a}
  u1=apply_stat_skills(event,stat_skills,u1,tempest,summoner,weapon,refinement,blessing,transformed)
  cru1=apply_stat_skills(event,stat_skills,cru1,tempest,summoner,'-','',blessing,transformed)
  blu1=u1.map{|a| a}
  crblu1=cru1.map{|a| a}
  blu1=apply_stat_skills(event,stat_skills_2,blu1) if stat_skills_2.length>0
  crblu1=apply_stat_skills(event,stat_skills_2,crblu1) if stat_skills_2.length>0
  u1[6]=u1[1]+u1[2]+u1[3]+u1[4]+u1[5]
  blu1[6]=blu1[1]+blu1[2]+blu1[3]+blu1[4]+blu1[5]
  cru1[6]=cru1[1]+cru1[2]+cru1[3]+cru1[4]+cru1[5]
  crblu1[6]=crblu1[1]+crblu1[2]+crblu1[3]+crblu1[4]+crblu1[5]
  u1=make_stat_string_list(u1,blu1)
  cru1=make_stat_string_list(cru1,crblu1)
  u1=make_stat_string_list(u1,cru1,2) if wl.include?('~~')
  ftr="Please note that the #{atk.split('> ')[1]} stat displayed here does not include weapon might.  The Attack stat in-game does."
  ggg=''
  ggg='Arena' if get_bonus_units('Arena').include?(u40[0])
  ggg='Tempest' if get_bonus_units('Tempest').include?(u40[0])
  ggg='Aether' if get_bonus_units('Aether').include?(u40[0])
  ggg='Bonus' if get_bonus_units('Tempest').include?(u40[0]) && get_bonus_units('Arena').include?(u40[0])
  ggg='Bonus' if get_bonus_units('Tempest').include?(u40[0]) && get_bonus_units('Aether').include?(u40[0])
  ggg='Bonus' if get_bonus_units('Aether').include?(u40[0]) && get_bonus_units('Arena').include?(u40[0])
  ggg='' if tempest.length>0
  ftr="Include the word \"#{ggg}\" to apply bonus unit buffs" if ggg.length>0
  if weapon != '-'
    ftr=nil if ftr[0,6]=='Please'
    tr=skill_tier(weapon,event)
    ftr="You equipped the Tier #{tr} version of the weapon.  Perhaps you want #{wl.gsub('~~','').split(' (+) ')[0]}+ ?" unless weapon[weapon.length-1,1]=='+' || !find_promotions(find_weapon(weapon,event),event).uniq.reject{|q| @skills[find_skill(q,event,true,true)][4]!="Weapon"}.include?("#{weapon}+") || " #{event.message.text.downcase} ".include?(' summoned ') || " #{event.message.text.downcase} ".include?(" mathoo's ") || donate_trigger_word(event)>0
  end
  ftr='"Pandering to the minority gets you nowhere." - Shylock#2166' if event.user.id==198201016984797184
  bin=((u40x2[1]+u40x2[2]+u40x2[3]+u40x2[4]+u40x2[5])/5)*5
  if rarity>=5 && !stat_skills.nil? && !stat_skills.length.zero?
    lookout=[]
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
      lookout=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
        lookout.push(eval line)
      end
      lookout=lookout.reject{|q| !['Stat-Affecting'].include?(q[3][0,q[3].length-2])}
    end
    for i in 0...stat_skills.length
      unless lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5].nil?
        bin=[bin,lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5]].max
      end
    end
  end
  flds=[["**Level 1#{" +#{merges}" if merges>0}**",["<:HP_S:514712247503945739> HP: #{u1[1]}","#{atk}: #{u1[2]}#{"(#{diff_num[1]}) / #{u1[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}","<:SpeedS:514712247625580555> Speed: #{u1[3]}","<:DefenseS:514712247461871616> Defense: #{u1[4]}","<:ResistanceS:514712247574986752> Resistance: #{u1[5]}","","BST: #{u1[6]}","Score: #{bin/5+merges*2+rarity*5+blessing.length*4+2+sp/100}#{"+`SP`/100" unless sp>0}"]]]
  if args.map{|q| q.downcase}.include?('gps') || args.map{|q| q.downcase}.include?('gp') || args.map{|q| q.downcase}.include?('growths') || args.map{|q| q.downcase}.include?('growth') || expandedmode
    flds.push(["**Growth Rates**",["<:HP_S:514712247503945739> HP: #{micronumber(u40[6])} / #{u40[6]*5+20}%","#{atk}: #{micronumber(u40[7])} / #{u40[7]*5+20}%","<:SpeedS:514712247625580555> Speed: #{micronumber(u40[8])} / #{u40[8]*5+20}%","<:DefenseS:514712247461871616> Defense: #{micronumber(u40[9])} / #{u40[9]*5+20}%","<:ResistanceS:514712247574986752> Resistance: #{micronumber(u40[10])} / #{u40[10]*5+20}%","","\u0262\u1D18\u1D1B #{micronumber(u40[6]+u40[7]+u40[8]+u40[9]+u40[10])} / GRT: #{(u40[6]+u40[7]+u40[8]+u40[9]+u40[10])*5+100}%"]])
  end
  flds.push(["**Level 40#{" +#{merges}" if merges>0}**",["<:HP_S:514712247503945739> HP: #{u40[1]}","#{atk}: #{u40[2]}#{"(#{diff_num[1]}) / #{u40[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}","<:SpeedS:514712247625580555> Speed: #{u40[3]}","<:DefenseS:514712247461871616> Defense: #{u40[4]}","<:ResistanceS:514712247574986752> Resistance: #{u40[5]}","","BST: #{u40[16]}","Score: #{bin/5+merges*2+rarity*5+blessing.length*4+90+sp/100}#{"+`SP`/100" unless sp>0}"]])
  superbaan=['','','','','','']
  if boon=="" && bane=="" && !mu && ((stat_skills_2.length<=0 && !wl.include?('~~')) || flds.length==3)
    for i in 6...11
      superbaan[i-5]='(+)' if [-3,1,5,10,14].include?(u40[i]) && rarity==5
      superbaan[i-5]='(-)' if [-2,2,6,11,15].include?(u40[i]) && rarity==5
      superbaan[i-5]='(+)' if [-2,10].include?(u40[i]) && rarity==4
      superbaan[i-5]='(-)' if [-1,11].include?(u40[i]) && rarity==4
      superbaan[i]='~~()~~' if newmerge != false && superbaan[i]=='(-)' && merges>0
    end
    if ggg.length>0
    elsif superbaan.include?('(+)') || superbaan.include?('(-)')
      if ftr.nil?
        ftr='Please note that stats marked with (+)/(-) increase/decrease by 4, not the usual 3, with a boon/bane.'
      elsif weapon == '-'
        ftr='Attack stat in-game has weapon might included.  (+)/(-) marks a "super" boon/bane.'
      end
    end
  elsif (stat_skills_2.length<=0 && !wl.include?('~~')) || flds.length==3
    x=['','HP','Attack','Speed','Defense','Resistance']
    for i in 1...6
      superbaan[i]='(Superboon)' if boon==x[i] && [-2,2,6,11,15].include?(u40[i+5]) && rarity==5
      superbaan[i]='(Superbane)' if bane==x[i] && [-3,1,5,10,14].include?(u40[i+5]) && rarity==5
      superbaan[i]='(Superboon)' if boon==x[i] && [-1,11].include?(u40[i+5]) && rarity==4
      superbaan[i]='(Superbane)' if bane==x[i] && [-2,10].include?(u40[i+5]) && rarity==4
      if newmerge != false && merges>0 && bane==x[i]
        superbaan[i]='~~(Superbane)~~' if [-2,2,6,11,15].include?(u40[i+5]) && rarity==5
        superbaan[i]='~~(Superbane)~~' if [-1,11].include?(u40[i+5]) && rarity==4
      end
    end
  end
  for i in 0...5
    flds[1][1][i]="#{flds[1][1][i]} #{superbaan[i+1]}"
  end
  for i in 0...flds.length
    flds[i][1]=flds[i][1].join("\n")
  end
  if unitz[1][1]=='Beast' && !transformed && !wl.include?('~~') && !['-','',' '].include?(wl) && !w2.nil?
    wlr=wl.split(' (+) ')[0]
    www2=w2[12][5,5]
    www3=www2.reject{|q| q==0}
    sttttz=[]
    if www3.length<=0
    elsif www3.min==www3.max
      sttttz.push('HP') unless www2[0]==0
      sttttz.push('Atk') unless www2[1]==0
      sttttz.push('Spd') unless www2[2]==0
      sttttz.push('Def') unless www2[3]==0
      sttttz.push('Res') unless www2[4]==0
      mergetext="\n\nWhen transformed: #{'+' if www3[0]>0}#{www3[0]} #{sttttz.join('/')}\nInclude the word \"Transformed\" to apply this directly."
    else
      sttttz.push("#{'+' if www2[0]>0}#{www2[0]} HP") unless www2[0]==0
      sttttz.push("#{'+' if www2[1]>0}#{www2[1]} Atk") unless www2[1]==0
      sttttz.push("#{'+' if www2[2]>0}#{www2[2]} Spd") unless www2[2]==0
      sttttz.push("#{'+' if www2[3]>0}#{www2[3]} Def") unless www2[3]==0
      sttttz.push("#{'+' if www2[4]>0}#{www2[4]} Res") unless www2[4]==0
      mergetext="\n\nWhen transformed: #{sttttz.join(', ')}\nInclude the word \"Transformed\" to apply this directly."
    end
  end
  if merges>0 && newmerge==false
    mergetextx=''
    if bane=='' && boon==''
      s2=u1.map{|q| q}
      s=[[s2[1],1,'HP'],[s2[2],2,'Atk'],[s2[3],3,'Spd'],[s2[4],4,'Def'],[s2[5],5,'Res']]
      s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}
      s=s[0,3]
      s.sort!{|b,a| b[1] <=> a[1]}
      mergetextx="+1 #{s[0][2]}/#{s[1][2]}/#{s[2][2]}"
    elsif bane != ''
      s=[6,'HP'] if bane=='HP'
      s=[7,'Atk'] if bane=='Attack'
      s=[8,'Spd'] if bane=='Speed'
      s=[9,'Def'] if bane=='Defense'
      s=[10,'Res'] if bane=='Resistance'
      baan=3
      baan=4 if [-3,1,5,10,14].include?(u40[s[0]]) && rarity==5
      baan=4 if [-2,10].include?(u40[s[0]]) && rarity==4
      baan=2 if [0,4,10].include?(u40[s[0]]) && rarity==2
      baan=2 if [-2,1,4,7,10,14].include?(u40[s[0]]) && rarity==1
      mergetextx="+#{baan} #{s[1]}"
    end
    mergetext="#{mergetext}\n\nAfter February update: #{mergetextx}\nInclude the word \"Feb\" to apply this directly."
  end
  if skillstoo && u40[0]!='Robin (Shared stats)' # when invoked any way except the main stats command, will also display the unit's top level skills
    uskl=unit_skills(name,event)
    for i in 0...3
      if uskl[i][0].include?('**') && uskl[i]!=uskl[i].reject{|q| !q.include?('**')}
        uskl[i][-1]="#{uskl[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{uskl[i][-1]}"
      end
    end
    uskl=uskl.map{|q| q[q.length-1]}
    if event.message.text.downcase.include?("mathoo's")
      devunits_load()
      dv=find_in_dev_units(name)
      if dv>=0
        mu=true
        sklz2=[@dev_units[dv][6],@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],[@dev_units[dv][12]]]
        uskl=sklz2.map{|q| q.reject{|q2| q2.include?('~~')}}.map{|q| q[q.length-1]}
      end
    elsif donate_trigger_word(event)>0
      uid=donate_trigger_word(event)
      x=donor_unit_list(uid)
      x2=x.find_index{|q| q[0]==name}
      unless x2.nil?
        sklz2=[x[x2][6],x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],[x[x2][12]]]
        uskl=sklz2.map{|q| q.reject{|q2| q2.include?('~~')}}.map{|q| q[q.length-1]}
      end
    end
    flds.push(['Skills',"<:Skill_Weapon:444078171114045450> #{uskl[0]}\n<:Skill_Assist:444078171025965066> #{uskl[1]}\n<:Skill_Special:444078170665254929> #{uskl[2]}\n<:Passive_A:443677024192823327> #{uskl[3]}\n<:Passive_B:443677023257493506> #{uskl[4]}\n<:Passive_C:443677023555026954> #{uskl[5]}#{"\n<:Passive_S:443677023626330122> #{uskl[6]}" unless uskl[6].nil?}"])
  elsif expandedmode && u40[0]!='Robin (Shared stats)'
    uskl=unit_skills(name,event)
    if event.message.text.downcase.include?("mathoo's")
      devunits_load()
      dv=find_in_dev_units(name)
      if dv>=0
        mu=true
        uskl=[@dev_units[dv][6],@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],[@dev_units[dv][12]]]
      end
    elsif donate_trigger_word(event)>0
      uid=donate_trigger_word(event)
      x=donor_unit_list(uid)
      x2=x.find_index{|q| q[0]==name}
      unless x2.nil?
        uskl=[x[x2][6],x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],[x[x2][12]]]
      end
    end
    flds.push(["<:Skill_Weapon:444078171114045450> **Weapons**",uskl[0].reject{|q| ['Falchion','**Falchion**','Missiletainn','**Missiletainn**','Adult (All)','**Adult (All)**'].include?(q)}.join("\n")])
    flds.push(["<:Skill_Assist:444078171025965066> **Assists**",uskl[1].join("\n")])
    flds.push(["<:Skill_Special:444078170665254929> **Specials**",uskl[2].join("\n")])
    flds.push(["<:Passive_A:443677024192823327> **A Passives**",uskl[3].join("\n")])
    flds.push(["<:Passive_B:443677023257493506> **B Passives**",uskl[4].join("\n")])
    flds.push(["<:Passive_C:443677023555026954> **C Passives**",uskl[5].join("\n")])
    flds.push(["<:Passive_S:443677023626330122> **Sacred Seal**",uskl[6].join("\n")]) if uskl.length>6
  end
  j=find_unit(name,event)
  img=pick_thumbnail(event,j,bot)
  img='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  xtype=1
  xtype=-1 if skillstoo && u40[0]!='Robin (Shared stats)'
  if skillstoo && mu && flds.length<=3
    flds.shift
  end
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(event,rarity,merges,summoner,expandedmode)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,expandedmode)}\n#{unit_clss(bot,event,j,u40[0])}#{mergetext}",xcolor,ftr,img,flds,xtype)
  if (skillstoo || expandedmode) && u40[0]=='Robin (Shared stats)' # due to the two Robins having different skills, a second embed is displayed with both their skills
    usklm=unit_skills('Robin(M)',event)
    usklf=unit_skills('Robin(F)',event)
    for i in 0...3
      if usklm[i][0].include?('**') && usklm[i]!=usklm[i].reject{|q| !q.include?('**')}
        usklm[i][-1]="#{usklm[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{usklm[i][-1]}"
      end
      if usklf[i][0].include?('**') && usklf[i]!=usklf[i].reject{|q| !q.include?('**')}
        usklf[i][-1]="#{usklf[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{usklf[i][-1]}"
      end
    end
    usklm=usklm.map{|q| q[q.length-1]}
    usklf=usklf.map{|q| q[q.length-1]}
    create_embed(event,'','',xcolor,nil,img,[['Robin(M)<:Blue_Tome:467112472394858508><:Icon_Move_Infantry:443331187579289601>',"<:Skill_Weapon:444078171114045450> #{usklm[0]}\n<:Skill_Assist:444078171025965066> #{usklm[1]}\n<:Skill_Special:444078170665254929> #{usklm[2]}\n<:Passive_A:443677024192823327> #{usklm[3]}\n<:Passive_B:443677023257493506> #{usklm[4]}\n<:Passive_C:443677023555026954> #{usklm[5]}"],['Robin(F)<:Green_Tome:467122927666593822><:Icon_Move_Infantry:443331187579289601>',"<:Skill_Weapon:444078171114045450> #{usklf[0]}\n<:Skill_Assist:444078171025965066> #{usklf[1]}\n<:Skill_Special:444078170665254929> #{usklf[2]}\n<:Passive_A:443677024192823327> #{usklf[3]}\n<:Passive_B:443677023257493506> #{usklf[4]}\n<:Passive_C:443677023555026954> #{usklf[5]}"]])
  end
  return nil
end

def disp_tiny_stats(bot,name,weapon,event,ignore=false,skillstoo=false,loaded=false) # displays stats
  newmerge=false
  newmerge=true if event.message.text.downcase.split(' ').include?('feb') || event.message.text.downcase.split(' ').include?('february')
  t=Time.now
  newmerge=nil if t.year>2019
  newmerge=nil if t.year==2019 && t.month>2
  newmerge=nil if t.year==2019 && t.month==2 && t.day>8
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      disp_tiny_stats(bot,name[i],weapon,event,ignore)
    end
    return nil
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args.compact!
  if name.nil?
    if args.nil? || args.length<1
      if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        event.respond 'No unit was included' unless ignore
        return nil
      else
        event.channel.send_embed("__**No unit was included.  Have a smol me instead.**__") do |embed|
          embed.color = 0xD49F61
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Smol_Elise.jpg")
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "image source", url: "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=58900377")
        end
      end
    end
  end
  untz=@units.map{|q| q}
  flurp=find_stats_in_string(event,nil,0,name)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Legendary','Mythical')}
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Mythical','Legendary')}
  end
  blessing.compact!
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  tempest=get_bonus_type(event)
  diff_num=[0,'','']
  sp=0
  spec_wpn=false
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      spec_wpn=true
      mu=true
      rarity=@dev_units[dv][1]
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      weaponz=@dev_units[dv][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
        sp=350
      else
        refinement=nil
        sp=300
      end
      sp=400 unless @skills[@skills.find_index{|q| q[0]==weapon}][6]=='-'
      for i in 7...12
        zzzzz=@dev_units[dv][i].reject{|q| q.include?('~~')}[-1]
        sp+=@skills[@skills.find_index{|q| q[0]==zzzzz}][1] unless zzzzz.nil? || @skills.find_index{|q| q[0]==zzzzz}.nil?
      end
      zzzzz=@dev_units[dv][12]
      sp+=@skills[@skills.find_index{|q| q[0]==zzzzz}][1] unless zzzzz.nil? || @skills.find_index{|q| q[0]==zzzzz}.nil?
    elsif loaded
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1]
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      weaponz=x[x2][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        spec_wpn=true
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
        sp=350
        sp=400 unless @skills[@skills.find_index{|q| q[0]==weapon}][6]=='-'
      else
        spec_wpn=true
        refinement=nil
        sp=300
        sp=400 unless @skills[@skills.find_index{|q| q[0]==weapon}][6]=='-'
      end
      for i in 7...12
        zzzzz=x[x2][i].reject{|q| q.include?('~~')}[-1]
        sp+=@skills[@skills.find_index{|q| q[0]==zzzzz}][1] unless zzzzz.nil? || @skills.find_index{|q| q[0]==zzzzz}.nil?
      end
      zzzzz=x[x2][12]
      sp+=@skills[@skills.find_index{|q| q[0]==zzzzz}][1] unless zzzzz.nil? || @skills.find_index{|q| q[0]==zzzzz}.nil?
    end
  elsif loaded
    if name=='Robin' && (" #{event.message.text.downcase} ".include?(' summoned ') || args.map{|q| q.downcase}.include?('summoned') || " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')) && !weapon.nil?
      wwww=weapon.split(' / ').map{|q| q.split('(')[0]}
      weapon=wwww[0]
      weapon2=wwww[1]
      wwww=wwww.map{|q| @skills[@skills.find_index{|q2| q2[0]==q}][2]}
      diff_num=[wwww[0]-wwww[1],'M','F']
    end
  elsif " #{event.message.text.downcase} ".include?(' summoned ') || args.map{|q| q.downcase}.include?('summoned')
    if name=='Robin'
      uskl=unit_skills('Robin(M)',event,true,rarity,false,true)[0].reject{|q| q.include?('~~')}
      uskl2=unit_skills('Robin(F)',event,true,rarity,false,true)[0].reject{|q| q.include?('~~')}
      weapon='-'
      weapon2='-'
      weapon=uskl[uskl.length-1] if uskl.length>0
      weapon2=uskl2[uskl2.length-1] if uskl2.length>0
      w2=@skills[find_skill(weapon,event)]
      w22=@skills[find_skill(weapon2,event)]
      diff_num=[w2[2]-w22[2],'M','F']
    else
      uskl=unit_skills(name,event,true,rarity,false,true)[0].reject{|q| q.include?('~~')}
      weapon='-'
      spec_wpn=true if uskl.length>0
      weapon=uskl[uskl.length-1] if uskl.length>0
    end
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0]
      else
        spec_wpn=true
        w2=@skills[find_skill(weapon,event)]
      end
      if weapon2=='-'
        w22=['-',0,0]
      else
        spec_wpn=true
        w22=@skills[find_skill(weapon2,event)]
      end
      diff_num=[w2[2]-w22[2],'M','F']
    end
  end
  w2=@skills[find_skill(weapon,event)]
  if w2[15].nil?
    refinement=nil
  elsif w2[15].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[15][0,1].to_i.to_s==w2[15][0,1] && refinement=='Effect'
    refinement=nil if w2[15][1,1]=='*'
  elsif w2[0,1]=='-' && w2[15][1,1].to_i.to_s==w2[15][1,1] && refinement=='Effect'
    refinement=nil if w2[15][2,1]=='*'
  end
  unitz=untz[find_unit(name,event)]
  if name=='Robin'
    if (" #{event.message.text.downcase} ".include?(' summoned ') || args.map{|q| q.downcase}.include?('summoned') || " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')) && !weapon2.nil?
      spec_wpn=true
      wl=weapon_legality(event,'Robin(M)',weapon)
      wl2=weapon_legality(event,'Robin(F)',weapon2)
      wl="#{wl}(M) / #{wl2}(F)"
      w2=@skills[find_skill(weapon,event)]
      w22=@skills[find_skill(weapon2,event)]
      diff_num=[w2[2]-w22[2],'M','F']
    else
      spec_wpn=true
      wl=weapon_legality(event,'Robin(M)',weapon)
      wl2=weapon_legality(event,'Robin(F)',weapon)
      wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
    end
  end
  if !spec_wpn
    wl=weapon_legality(event,unitz[0],weapon,refinement)
  elsif !refinement.nil? && refinement.length>0
    wl="#{weapon} (+) #{refinement} Mode"
  elsif name != 'Robin'
    wl=weapon
  end
  if find_unit(name,event)<0
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond 'No unit was included' unless ignore
      return nil
    else
      event.channel.send_embed("__**No unit was included.  Have a smol me instead.**__") do |embed|
        embed.color = 0xD49F61
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Smol_Elise.jpg")
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "image source", url: "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=58900377")
      end
    end
    return nil
  elsif unitz[0]=='Kiran'
    data_load()
    j=find_unit(name,event)
    merges=@max_rarity_merge[1] if merges>@max_rarity_merge[1]
    merges=0 if merges<0
    if merges>10000000
      event.respond "I can't merge that high"
      merges=10000000
    end
    rarity=@max_rarity_merge[0] if rarity>@max_rarity_merge[0]
    rarity=1 if rarity<1
    if rarity>10000000
      event.respond "I can't do rarities that high"
      rarity=10000000
    end
    n=nature_name(boon,bane)
    unless n.nil?
      n=n.join(' / ')
    end
    create_embed(event,"__**#{untz[j][0].gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,j,untz[0],mu,2)}**__","#{display_stars(event,rarity,merges)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{unit_clss(bot,event,j)}\n**<:HP_S:514712247503945739>0 | <:StrengthS:514712248372166666>0 | <:SpeedS:514712247625580555>0 | <:DefenseS:514712247461871616>0 | <:ResistanceS:514712247574986752>0** (0 BST, Score: #{115+2*merges})",0x9400D3,nil,pick_thumbnail(event,j,bot),nil,1)
    return nil
  elsif unitz[4].nil? || (unitz[4].max<=0 && unitz[5].max<=0) # unknown stats
    data_load()
    j=find_unit(name,event)
    xcolor=unit_color(event,j,untz[j][0],0,mu)
    create_embed(event,"__**#{untz[j][0].gsub('Lavatain','Laevatein')}**__","#{unit_clss(bot,event,j)}",xcolor,'Stats currently unknown',pick_thumbnail(event,j,bot))
    return nil
  elsif unitz[4].max<=0 # level 40 stats are known but not level 1
    data_load()
    merges=0 if merges.nil?
    j=find_unit(name,event)
    xcolor=unit_color(event,j,untz[j][0],0,mu)
    atk='<:StrengthS:514712248372166666>*'
    atk='<:MagicS:514712247289774111>' if ['Tome','Dragon','Healer'].include?(untz[j][1][1])
    atk='<:StrengthS:514712248372166666>' if ['Blade','Bow','Dagger'].include?(untz[j][1][1])
    zzzl=@skills[find_weapon(weapon,event)]
    if zzzl[11].split(', ').include?('Frostbite')
      atk='<:FreezeS:514712247474585610>'
    end
    n=nature_name(boon,bane)
    unless n.nil?
      n=n[0] if atk=='<:StrengthS:514712248372166666>'
      n=n[n.length-1] if atk=='<:MagicS:514712247289774111>'
      n=n.join(' / ') if ['<:StrengthS:514712248372166666>*','<:FreezeS:514712247474585610>'].include?(atk)
    end
    atk=atk.gsub('*','')
    u40=[untz[j][0],untz[j][5][0],untz[j][5][1],untz[j][5][2],untz[j][5][3],untz[j][5][4]]
    u40x2=u40.map{|q| q}
    # find stats based on merges
    s=[[u40[1],1],[u40[2],2],[u40[3],3],[u40[4],4],[u40[5],5]]                # all stats
    s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}  # sort the stats based on amount
    s.push(s[0],s[1],s[2],s[3],s[4])                                          # loop the list for use with multiple merges
    m=merges/5                                                                # apply merges, two stats per merge
    if m>0
      for i in 1...6
        u40[i]+=2*m
      end
    end
    m=merges%5
    if m>0
      for i in 0...2*m
        u40[s[i][1]]+=1
      end
    end
    spec_wpn=false
    if name=='Robin'
      spec_wpn=true
      wl=weapon_legality(event,'Robin(M)',weapon)
      wl2=weapon_legality(event,'Robin(F)',weapon)
      wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
    end
    unless spec_wpn
      wl=weapon_legality(event,unitz[0],weapon,nil)
      weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
    end
    u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
    mergetext=''
    if unitz[1][1]=='Beast' && !transformed && !wl.include?('~~') && !['-','',' '].include?(wl) && !w2.nil?
      wlr=wl.split(' (+) ')[0]
      www2=w2[12][5,5]
      www3=www2.reject{|q| q==0}
      sttttz=[]
      if www3.length<=0
      elsif www3.min==www3.max
        sttttz.push('HP') unless www2[0]==0
        sttttz.push('Atk') unless www2[1]==0
        sttttz.push('Spd') unless www2[2]==0
        sttttz.push('Def') unless www2[3]==0
        sttttz.push('Res') unless www2[4]==0
        mergetext="\n\nWhen transformed: #{'+' if www3[0]>0}#{www3[0]} #{sttttz.join('/')}\nInclude the word \"Transformed\" to apply this directly."
      else
        sttttz.push("#{'+' if www2[0]>0}#{www2[0]} HP") unless www2[0]==0
        sttttz.push("#{'+' if www2[1]>0}#{www2[1]} Atk") unless www2[1]==0
        sttttz.push("#{'+' if www2[2]>0}#{www2[2]} Spd") unless www2[2]==0
        sttttz.push("#{'+' if www2[3]>0}#{www2[3]} Def") unless www2[3]==0
        sttttz.push("#{'+' if www2[4]>0}#{www2[4]} Res") unless www2[4]==0
        mergetext="\n\nWhen transformed: #{sttttz.join(', ')}\nInclude the word \"Transformed\" to apply this directly."
      end
    end
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,j,u40[0],mu,2)}**__","#{display_stars(event,5,merges,summoner)}\n*Neutral Nature only so far*\n#{display_stat_skills(j,stat_skills,[],nil,tempest,blessing,transformed,wl,false,true)}\n**<:HP_S:514712247503945739>#{u40[1]} | #{atk}#{u40[2]} | <:SpeedS:514712247625580555>#{u40[3]} | <:DefenseS:514712247461871616>#{u40[4]} | <:ResistanceS:514712247574986752>#{u40[5]}** (#{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]} BST, Score: #{(u40x2[1]+u40x2[2]+u40x2[3]+u40x2[4]+u40x2[5])/5+25+merges*2+90+blessing.length*4})#{mergetext}",xcolor,nil,pick_thumbnail(event,j,bot),nil,1)
    return nil
  end
  # units for whom both level 40 and level 1 stats are known
  data_load()
  merges=@max_rarity_merge[1] if merges>@max_rarity_merge[1]
  merges=0 if merges<0
  rarity=@max_rarity_merge[0] if rarity>@max_rarity_merge[0]
  rarity=1 if rarity<1
  if merges>10000000
    event.respond "I can't merge that high"
    merges=10000000
  end
  if rarity>10000000
    event.respond "I can't do rarities that high"
    rarity=10000000
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  u40x2=get_stats(event,name,40,5,0,boon,bane)
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  u1=get_stats(event,name,1,rarity,merges,boon,bane)
  u1=apply_stat_skills(event,stat_skills,u1,tempest,summoner,weapon,refinement,blessing,transformed)
  j=find_unit(name,event)
  atk='<:StrengthS:514712248372166666>*'
  atk='<:MagicS:514712247289774111>' if ['Tome','Dragon','Healer'].include?(untz[j][1][1])
  atk='<:StrengthS:514712248372166666>' if ['Blade','Bow','Dagger'].include?(untz[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  if zzzl[11].split(', ').include?('Frostbite')
    atk='<:FreezeS:514712247474585610>'
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='<:StrengthS:514712248372166666>'
    n=n[n.length-1] if atk=='<:MagicS:514712247289774111>'
    n=n.join(' / ') if ['<:StrengthS:514712248372166666>*','<:FreezeS:514712247474585610>'].include?(atk)
  end
  atk=atk.gsub('*','')
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
  end
  xcolor=unit_color(event,j,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  w1='-' if wl.include?('~~')
  flds=[["**Level 1#{" +#{merges}" if merges>0}**",["#{' ' if u1[1]<10}#{u1[1]}","#{' ' if u1[2]<10}#{u1[2]}","#{' ' if u1[3]<10}#{u1[3]}","#{' ' if u1[4]<10}#{u1[4]}","#{' ' if u1[5]<10}#{u1[5]}"]],["**Level 40#{" +#{merges}" if merges>0}**",["#{' ' if u40[1]<10}#{u40[1]}","#{' ' if u40[2]<10}#{u40[2]}","#{' ' if u40[3]<10}#{u40[3]}","#{' ' if u40[4]<10}#{u40[4]}","#{' ' if u40[5]<10}#{u40[5]}"]]]
  superbaan=["\u00A0","\u00A0","\u00A0","\u00A0","\u00A0","\u00A0"]
  mergetext=''
  if boon=="" && bane=="" && !mu && (merges==0 || newmerge==false)
    for i in 6...11
      superbaan[i-5]='+' if [-3,1,5,10,14].include?(u40[i]) && rarity==5
      superbaan[i-5]='-' if [-2,2,6,11,15].include?(u40[i]) && rarity==5
      superbaan[i-5]='+' if [-2,10].include?(u40[i]) && rarity==4
      superbaan[i-5]='-' if [-1,11].include?(u40[i]) && rarity==4
    end
  end
  if unitz[1][1]=='Beast' && !transformed && !wl.include?('~~') && !['-','',' '].include?(wl) && !w2.nil?
    wlr=wl.split(' (+) ')[0]
    www2=w2[12][5,5]
    www3=www2.reject{|q| q==0}
    sttttz=[]
    if www3.length<=0
    elsif www3.min==www3.max
      sttttz.push('HP') unless www2[0]==0
      sttttz.push('Atk') unless www2[1]==0
      sttttz.push('Spd') unless www2[2]==0
      sttttz.push('Def') unless www2[3]==0
      sttttz.push('Res') unless www2[4]==0
      mergetext="\n\nWhen transformed: #{'+' if www3[0]>0}#{www3[0]} #{sttttz.join('/')}\nInclude the word \"Transformed\" to apply this directly."
    else
      sttttz.push("#{'+' if www2[0]>0}#{www2[0]} HP") unless www2[0]==0
      sttttz.push("#{'+' if www2[1]>0}#{www2[1]} Atk") unless www2[1]==0
      sttttz.push("#{'+' if www2[2]>0}#{www2[2]} Spd") unless www2[2]==0
      sttttz.push("#{'+' if www2[3]>0}#{www2[3]} Def") unless www2[3]==0
      sttttz.push("#{'+' if www2[4]>0}#{www2[4]} Res") unless www2[4]==0
      mergetext="\n\nWhen transformed: #{sttttz.join(', ')}\nInclude the word \"Transformed\" to apply this directly."
    end
  end
  if merges>0 && newmerge==false
    mergetextx=''
    if bane=='' && boon==''
      s2=u1.map{|q| q}
      s=[[s2[1],1,'HP'],[s2[2],2,'Atk'],[s2[3],3,'Spd'],[s2[4],4,'Def'],[s2[5],5,'Res']]
      s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}
      s=s[0,3]
      s.sort!{|b,a| b[1] <=> a[1]}
      mergetextx="+1 #{s[0][2]}/#{s[1][2]}/#{s[2][2]}"
    elsif bane != ''
      s=[6,'HP'] if bane=='HP'
      s=[7,'Atk'] if bane=='Attack'
      s=[8,'Spd'] if bane=='Speed'
      s=[9,'Def'] if bane=='Defense'
      s=[10,'Res'] if bane=='Resistance'
      baan=3
      baan=4 if [-3,1,5,10,14].include?(u40[s[0]]) && rarity==5
      baan=4 if [-2,10].include?(u40[s[0]]) && rarity==4
      baan=2 if [0,4,10].include?(u40[s[0]]) && rarity==2
      baan=2 if [-2,1,4,7,10,14].include?(u40[s[0]]) && rarity==1
      mergetextx="+#{baan} #{s[1]}"
    end
    mergetext="#{mergetext}\n\nAfter February update: #{mergetextx}\nInclude the word \"Feb\" to apply this directly."
  end
  for i in 0...5
    flds[1][1][i]="#{flds[1][1][i]}#{superbaan[i+1]}"
  end
  j=find_unit(name,event)
  img=pick_thumbnail(event,j,bot)
  img='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  xtype=1
  ftr=''
  ftr='Score does not include SP from skills' unless sp>0
  ggg=''
  ggg='Arena' if get_bonus_units('Arena').include?(u40[0])
  ggg='Tempest' if get_bonus_units('Tempest').include?(u40[0])
  ggg='Aether' if get_bonus_units('Aether').include?(u40[0])
  ggg='Bonus' if get_bonus_units('Tempest').include?(u40[0]) && get_bonus_units('Arena').include?(u40[0])
  ggg='Bonus' if get_bonus_units('Tempest').include?(u40[0]) && get_bonus_units('Aether').include?(u40[0])
  ggg='Bonus' if get_bonus_units('Aether').include?(u40[0]) && get_bonus_units('Arena').include?(u40[0])
  ggg='' if tempest.length>0
  ftr="Include the word \"#{ggg}\" to apply bonus unit buffs" if ggg.length>0 && (sp>0 || rand(2)==0)
  if weapon != '-'
    tr=skill_tier(weapon,event)
    ftr="You equipped the Tier #{tr} version of the weapon.  Perhaps you want #{wl.gsub('~~','').split(' (+) ')[0]}+ ?" unless weapon[weapon.length-1,1]=='+' || !find_promotions(find_weapon(weapon,event),event).uniq.reject{|q| @skills[find_skill(q,event,true,true)][4]!="Weapon"}.include?("#{weapon}+") || " #{event.message.text.downcase} ".include?(' summoned ') || " #{event.message.text.downcase} ".include?(" mathoo's ") || donate_trigger_word(event)>0
  end
  ftr="Attack displayed is for #{u40[0].split(' ')[0]}(#{diff_num[1]}).  #{u40[0].split(' ')[0]}(#{diff_num[2]})'s Attack is #{diff_num[0]} point#{'s' unless diff_num[0]==1} lower." if !diff_num.nil? && diff_num[0]>0
  ftr="Attack displayed is for #{u40[0].split(' ')[0]}(#{diff_num[1]}).  #{u40[0].split(' ')[0]}(#{diff_num[2]})'s Attack is #{0-diff_num[0]} point#{'s' unless diff_num[0]==-1} higher." if !diff_num.nil? && diff_num[0]<0
  ftr='"Pandering to the minority gets you nowhere." - Shylock#2166' if event.user.id==198201016984797184
  realflds=nil
  if skillstoo && u40[0]!='Robin (Shared stats)' # when invoked any way except the main stats command, will also display the unit's top level skills
    uskl=unit_skills(name,event)
    for i in 0...3
      if uskl[i][0].include?('**') && uskl[i]!=uskl[i].reject{|q| !q.include?('**')}
        uskl[i][-1]="#{uskl[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{uskl[i][-1]}"
      end
    end
    uskl=uskl.map{|q| q[q.length-1]}
    if event.message.text.downcase.include?("mathoo's")
      devunits_load()
      dv=find_in_dev_units(name)
      if dv>=0
        mu=true
        sklz2=[@dev_units[dv][6],@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],[@dev_units[dv][12]]]
        uskl=sklz2.map{|q| q.reject{|q2| q2.include?('~~')}}.map{|q| q[q.length-1]}
      end
    elsif donate_trigger_word(event)>0
      uid=donate_trigger_word(event)
      x=donor_unit_list(uid)
      x2=x.find_index{|q| q[0]==name}
      unless x2.nil?
        sklz2=[x[x2][6],x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],[x[x2][12]]]
        uskl=sklz2.map{|q| q.reject{|q2| q2.include?('~~')}}.map{|q| q[q.length-1]}
      end
    end
    realflds=[['Skills',"<:Skill_Weapon:444078171114045450> #{uskl[0]}\n<:Skill_Assist:444078171025965066> #{uskl[1]}\n<:Skill_Special:444078170665254929> #{uskl[2]}\n<:Passive_A:443677024192823327> #{uskl[3]}\n<:Passive_B:443677023257493506> #{uskl[4]}\n<:Passive_C:443677023555026954> #{uskl[5]}#{"\n<:Passive_S:443677023626330122> #{uskl[6]}" unless uskl[6].nil?}"]]
  end
  bin=((u40x2[1]+u40x2[2]+u40x2[3]+u40x2[4]+u40x2[5])/5)*5
  if rarity>=5 && !stat_skills.nil? && !stat_skills.length.zero?
    lookout=[]
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
      lookout=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
        lookout.push(eval line)
      end
      lookout=lookout.reject{|q| !['Stat-Affecting'].include?(q[3][0,q[3].length-2])}
    end
    for i in 0...stat_skills.length
      unless lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5].nil?
        bin=[bin,lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5]].max
      end
    end
  end
  xtype=1
  xtype=6 if skillstoo && u40[0]!='Robin (Shared stats)'
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,j,u40[0],mu,2)}**__","#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,[],nil,tempest,blessing,transformed,wl,false,true)}\n\u200B\u00A0<:HP_S:514712247503945739>\u00A0\u200B\u00A0\u200B\u00A0#{atk}\u00A0\u200B\u00A0\u200B\u00A0<:SpeedS:514712247625580555>\u00A0\u200B\u00A0\u200B\u00A0<:DefenseS:514712247461871616>\u00A0\u200B\u00A0\u200B\u00A0<:ResistanceS:514712247574986752>\u00A0\u200B\u00A0\u200B\u00A0#{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]}\u00A0BST\u2084\u2080\u00A0\u200B\u00A0\u200B\u00A0Score:\u00A0#{bin/5+merges*2+rarity*5+blessing.length*4+90+sp/100}```#{flds[0][1].join("\u00A0|")}\n#{flds[1][1].join('|')}```#{mergetext}",xcolor,ftr,img,realflds,xtype)
  if skillstoo && u40[0]=='Robin (Shared stats)' # due to the two Robins having different skills, a second embed is displayed with both their skills
    usklm=unit_skills('Robin(M)',event)
    usklf=unit_skills('Robin(F)',event)
    for i in 0...3
      if usklm[i][0].include?('**') && usklm[i]!=usklm[i].reject{|q| !q.include?('**')}
        usklm[i][-1]="#{usklm[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{usklm[i][-1]}"
      end
      if usklf[i][0].include?('**') && usklf[i]!=usklf[i].reject{|q| !q.include?('**')}
        usklf[i][-1]="#{usklf[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{usklf[i][-1]}"
      end
    end
    usklm=usklm.map{|q| q[q.length-1]}
    usklf=usklf.map{|q| q[q.length-1]}
    create_embed(event,'','',xcolor,nil,img,[['Robin(M)<:Blue_Tome:467112472394858508><:Icon_Move_Infantry:443331187579289601>',"<:Skill_Weapon:444078171114045450> #{usklm[0]}\n<:Skill_Assist:444078171025965066> #{usklm[1]}\n<:Skill_Special:444078170665254929> #{usklm[2]}\n<:Passive_A:443677024192823327> #{usklm[3]}\n<:Passive_B:443677023257493506> #{usklm[4]}\n<:Passive_C:443677023555026954> #{usklm[5]}"],['Robin(F)<:Green_Tome:467122927666593822><:Icon_Move_Infantry:443331187579289601>',"<:Skill_Weapon:444078171114045450> #{usklf[0]}\n<:Skill_Assist:444078171025965066> #{usklf[1]}\n<:Skill_Special:444078170665254929> #{usklf[2]}\n<:Passive_A:443677024192823327> #{usklf[3]}\n<:Passive_B:443677023257493506> #{usklf[4]}\n<:Passive_C:443677023555026954> #{usklf[5]}"]])
  end
  return nil
end

def make_stat_string_list(a,b,n=1)
  if n==2
    for i in 1...a.length
      a[i]="~~#{a[i]}~~ #{b[i]}" unless a[i]==b[i]
    end
    return a
  end
  for i in 1...6
    a[i]=[a[i],0].max
  end
  a.push(a[1]+a[2]+a[3]+a[4]+a[5])
  for i in 1...6
    b[i]=[b[i],0].max
  end
  b.push(b[1]+b[2]+b[3]+b[4]+b[5])
  for i in 1...a.length
    a[i]="#{a[i]} (#{b[i]})" unless a[i]==b[i]
  end
  return a
end

def find_base_skill(x,event)
  return 'Flux' if x[0][0,5]=='Flux/'
  return x[0].gsub('[El]','').split('/')[0] if x[0][0,4]=='[El]'
  return x[0].gsub('/Steel','').gsub('/Silver[+]','').gsub('/Silver','') if x[0][0,5]=='Iron/'
  return x[0].split('/')[0] if x[0].include?('/')
  if x[5].include?('Tome Users Only') && x[4]=='Weapon' && x[8]=='-' && x[6]!='-' # retro-prf tomes
    k=x[6].split(', ')
    k=k.map{|q| @units[find_unit(q,event)][1][2]}
    k=k.uniq
    k=k.join(', ')
    return "Rau\u00F0r" if k=='*Fire*, *Flux*'
    return "Bl\u00E1r" if k=='*Thunder*, *Light*'
    return k
  end
  return x[0] if x[8]=='-'
  unless x[0].length<5
    return 'Gronn' if (x[0].include?('Gronn') || (x[11].include?('Seasonal') && !x[11].include?('Prf'))) && x[8].include?('*Elwind*')
  end
  if x[8].include?('*, *')
    k=x[8].gsub('*','').split(', ')
    k=k.map{|q| find_base_skill(@skills[find_skill(q,event)],event)}
    k=k.uniq
    k=k.map{|q| "*#{q}*"}
    k=k.join(', ')
    return "Rau\u00F0r" if k=='*Fire*, *Flux*'
    return "Bl\u00E1r" if k=='*Thunder*, *Light*'
    return k
  elsif x[8].include?('* or *')
    k=x[8].gsub('*','').split(' or ')
    k=[find_base_skill(@skills[find_skill(k[0],event)],event),find_base_skill(@skills[find_skill(k[1],event)],event)]
    k=k.uniq
    k=k.map{|q| "*#{q}*"}
    k=k.join(' or ')
    return "Rau\u00F0r" if k=='*Fire* or *Flux*'
    return "Bl\u00E1r" if k=='*Thunder* or *Light*'
    return k
  end
  return find_base_skill(@skills[find_skill(x[8][1,x[8].length-2],event)],event)
end

def cumulative_sp_cost(x,event,mode=0)
  if mode==1
    return ['',0,0,0] if ['Weapon','Assist','Special'].include?(x[4]) || x[3]=='-' || x[3].split(' ').length<4
    m=x[3].split(' ')
    for i in 1...m.length
      m[i]=m[i].to_i
    end
    return m if x[8]=='-'
    if x[8].include?('*, *')
      k=x[8].gsub('*','').split(', ')
    elsif x[8].include?('* or *')
      k=x[8].gsub('*','').split(' or ')
    else
      k=[x[8].gsub('*','')]
    end
    k=k.reject{|q| q.scan(/[[:alpha:]]+?/).join != x[0].scan(/[[:alpha:]]+?/).join}
    return m if k.length<=0
    k=k[0]
    n=cumulative_sp_cost(@skills[find_skill(k,event)],event,1)
    return [m[0],m[1]+n[1],m[2]+n[2],m[3]+n[3]]
  end
  return 0 if x.nil?
  return x[1] if x[8]=='-'
  if x[8].include?('*, *')
    k=@skills[find_skill(x[8].gsub('*','').split(', ')[0],event)]
  elsif x[8].include?('* or *')
    k=@skills[find_skill(x[8].gsub('*','').split(' or ')[0],event)]
  else
    k=@skills[find_skill(x[8].gsub('*',''),event)]
  end
  return x[1]+cumulative_sp_cost(k,event)
end

def disp_skill_line(bot,name,event,ignore=false,dispcolors=false)
  data_load()
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  a=s.split(' ')
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=sever(s,true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  name=stat_buffs(name,name)
  k=find_skill(name,event,false,false,true,1)
  if k.nil? || !k.is_a?(Array)
    event.respond "No matches found.  If you are looking for data on the skills a character learns, try ```#{first_sub(event.message.text,'skill','skills',1)}```, with an s." unless ignore
    return false
  end
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt').each_line do |line|
      lookout.push(eval line)
    end
  end
  lookout2=lookout.reject{|q| q[2]!='Weapon' || q[3].nil?}
  skill=k.map{|q| @skills[q]}.uniq
  sklz=@skills.map{|q| q}
  g=get_markers(event)
  unitz=@units.reject{|q| !has_any?(g, q[13][0])}
  xcolor=0xFDDC7E
  sklimg=skill[-1][0].gsub(' ','_').gsub('/','_').gsub('!','').gsub('.','')
  sklimg="Squad_Ace_#{"ABCDE"["ABCDEFGHIJKLMNOPQRSTUVWXYZ".split(skill[-1][0][10,1])[0].length%5,1]}_#{skill[-1][0][12,skill[0].length-12]}" if skill[-1][0][0,10]=='Squad Ace '
  xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/skills/#{sklimg}.png?raw=true"
  sklslt=skill.map{|q| q[4].split(', ')}.join("\n").split("\n").uniq
  m=false
  for i in 0...skill.length
    m=true if !skill[i][12].nil? && skill[i][12]!=''
  end
  if m && sklslt.include?('Passive(W)')
    eff=skill.map{|q| q[12].split(', ')}.join("\n").split("\n").uniq
    for i in 0...eff.length
      eff[i]=nil unless find_skill(eff[i],event,true)>1
    end
    eff.compact!
    if eff.length<=0
      for i in 0...sklslt.length
        sklslt[i]=nil if sklslt[i]=='Passive(W)'
      end
      sklslt.compact!
    end
  end
  emo=[]
  for i in 0...sklslt.length
    emo.push('<:Passive_A:443677024192823327>') if sklslt[i]=='Passive(A)'
    emo.push('<:Passive_B:443677023257493506>') if sklslt[i]=='Passive(B)'
    emo.push('<:Passive_C:443677023555026954>') if sklslt[i]=='Passive(C)'
    emo.push('<:Passive_S:443677023626330122>') if sklslt[i]=='Passive(S)' || sklslt[i]=='Seal'
    emo.push('<:Passive_W:443677023706152960>') if sklslt[i]=='Passive(W)'
  end
  str="#{emo.join('')} **Skill Slot:** #{sklslt.join(', ')}"
  str="#{str}\n**Effect:**"
  for i in 0...skill.length
    str="#{str}\n*Level #{i+1}:* #{skill[i][7]}"
  end
  if skill[0][0]=='Distant Counter'
    str="#{str}\n**Secondary effect:** Breaks consecutiveness of enemy mage/bow/dagger/staff attacks"
  elsif skill[0][0]=='Close Counter'
    str="#{str}\n**Secondary effect:** Breaks consecutiveness of enemy sword/axe/lance/breath attacks"
  end
  str="#{str}\n\n**SP required:** #{skill.map{|q| q[1]}.join('/')} #{"(#{skill.map{|q| q[1]*3/2}.join('/')} when inherited)" if skill[-1][6]=='-'}"
  str="#{str}\n**Total SP required:** #{skill.map{|q| q[1]}.inject(0){|sum,x| sum + x }} #{"(#{skill.map{|q| q[1]*3/2}.inject(0){|sum,x| sum + x }} when inherited)" if skill[-1][6]=='-'}"
  cumul=cumulative_sp_cost(skill[-1],event)
  str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul+skill[-1][1]/2}-#{cumul*3/2} when inherited)" if skill[-1][6]=='-'}" unless cumul==skill[-1][1] || cumul==skill.map{|q| q[1]}.inject(0){|sum,x| sum + x }
  if skill[-1][4].split(', ').include?('Seal') && skill[3]!="-" && skill[-1][3][0,1].downcase!=skill[-1][3][0,1]
    floop=[]
    for i2 in 0...skill.length
      floop.push(skill[i2][3].split(' '))
      floop[-1][0]='<:Great_Badge_Transparent:443704781597573120> <:Badge_Transparent:445510675976945664>' if floop[-1][0].downcase=='transparent'
      floop[-1][0]='<:Great_Badge_Scarlet:443704781001850910> <:Badge_Scarlet:445510676060962816>' if floop[-1][0].downcase=='scarlet'
      floop[-1][0]='<:Great_Badge_Azure:443704780783616016> <:Badge_Azure:445510675352125441>' if floop[-1][0].downcase=='azure'
      floop[-1][0]='<:Great_Badge_Verdant:443704780943261707> <:Badge_Verdant:445510676056899594>' if floop[-1][0].downcase=='verdant'
      for i in 1...floop[-1].length
        floop[-1][i]=floop[-1][i].to_i
      end
    end
    str="#{str}\n**Seal Cost:** #{floop.map{|q| q[1]}.join('/')}#{floop[0][0].split(' ')[0]} #{floop.map{|q| q[2]}.join('/')}#{floop[0][0].split(' ')[1]} #{floop.map{|q| q[3]}.join('/')}<:Sacred_Coin:453618312996323338>"
    cumul=cumulative_sp_cost(skill[-1],event,1)
    str="#{str}\n**Total Seal Cost:** #{cumul[1]}#{floop[-1][0].split(' ')[0]} #{cumul[2]}#{floop[-1][0].split(' ')[1]} #{cumul[3]}<:Sacred_Coin:453618312996323338>" if [cumul[1],cumul[2],cumul[3]]!=[floop[-1][1],floop[-1][2],floop[-1][3]]
  end
  p=find_promotions(sklz.find_index{|q| q[0]==skill[-1][0]},event)
  p=p.uniq
  if skill[-1][4].include?('Passive') || skill[-1][4]=='Seal'
    p=p.reject{|q| ['Weapon', 'Assist', 'Special'].include?(sklz[find_skill(q,event,true,true)][4])}
    p=p.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(A)')} if skill[-1][4].include?('(A)')
    p=p.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(B)')} if skill[-1][4].include?('(B)')
    p=p.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(C)')} if skill[-1][4].include?('(C)')
  else
    p=p.reject{|q| !has_any?(sklslt, sklz[find_skill(q,event,true,true)][4].split(', '))}
  end
  if p.length.zero?
    p=nil
  else
    for i2 in 0...p.length
      p[i2]="~~#{p[i2]}~~" unless p[i2]=='Laevatein' || sklz[sklz.find_index{|q2| q2[0]==p[i2]}][13].nil? || !skill[-1][13].nil?
    end
    p=list_lift(p.map{|q| "*#{q}*"},"or")
  end
  p2=[]
  for i in 0...skill.length-1
    p3=find_promotions(sklz.find_index{|q| q[0]==skill[i][0]},event)
    p3=p3.uniq
    if skill[i][4].include?('Passive') || skill[i][4]=='Seal'
      p3=p3.reject{|q| ['Weapon', 'Assist', 'Special'].include?(sklz[find_skill(q,event,true,true)][4])}
      p3=p3.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(A)')} if skill[i][4].include?('(A)')
      p3=p3.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(B)')} if skill[i][4].include?('(B)')
      p3=p3.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(C)')} if skill[i][4].include?('(C)')
    else
      p3=p3.reject{|q| !has_any?(sklslt, sklz[find_skill(q,event,true,true)][4].split(', '))}
    end
    if p3.length.zero?
      p3=nil
    else
      for i2 in 0...p3.length
        p2.push(p3[i2]) if p3[i2]=='Laevatein' || sklz[sklz.find_index{|q2| q2[0]==p3[i2]}][13].nil? || !skill[i][13].nil?
        p2.push("~~#{p3[i2]}~~") unless p3[i2]=='Laevatein' || sklz[sklz.find_index{|q2| q2[0]==p3[i2]}][13].nil? || !skill[i][13].nil?
      end
    end
  end
  p2=p2.reject{|q| skill.map{|q2| q2[0]}.include?(q)}
  if p2.length<=0
    p2=nil
  else
    p2=list_lift(p2.map{|q| "*#{q}*"},"or")
  end
  str="#{str}#{"\n" unless skill[0][8]=='-' && p.nil? && skill[-1][6]!='-'}#{"\n**Restrictions on inheritance:** #{skill[-1][5].gsub('Excludes Tome Users, Excludes Staff Users, Excludes Dragons','Physical Weapon Users Only')}" if skill[-1][6]=='-' && skill[-1][4]!='Weapon'}#{"\n**<:Prf_Sparkle:490307608973148180>Prf to:** #{skill[-1][6].split(', ').reject {|u| find_unit(u,event,false,true)<0 && u != '-'}.join(', ').gsub('Lavatain','Laevatein')}" unless ['Missiletainn','Adult (All)'].include?(skill[-1][0]) || skill[-1][6]=='-' || skill[-1][6].split(', ').reject {|u| find_unit(u,event,false,true)<0 && u != '-'}.length.zero?}#{"\n**Promotes from:** #{skill[0][8]}" unless skill[0][8]=='-'}#{"\n**Branching lines:** #{p2}" unless p2.nil?}#{"\n**Promotes into:** #{p}" unless p.nil?}"
  usklz=[]
  for i in 0...skill.length
    for i2 in 0...skill[i][10].length
      m=skill[i][10][i2].split(', ').reject{|q| unitz.find_index{|q2| q2[0]==q}.nil?}
      unless m.length<=0 || m[0]=='-'
        for i3 in 0...m.length
          usklz.push([m[i3],i+1,i2+1]) # unit name, skill tier, rarity
        end
      end
    end
  end
  usklz=usklz.uniq.sort{|a,b| (supersort(a,b,0)==0 ? (supersort(a,b,1)==0 ? supersort(a,b,2) : supersort(a,b,1)) : supersort(a,b,0))}
  for i in 0...usklz.length
    usklz[i][2]="#{usklz[i][2]}#{@rarity_stars[usklz[i][2]-1]}"
  end
  if usklz.length>0
    usklz2=[]
    usklz2.push([usklz[0][0],usklz[0][2]]) if usklz[0][1]==1
    usklz2.push([usklz[0][0],"Otherstart/#{usklz[0][2]}"]) unless usklz[0][1]==1
    usklz.shift
    for i in 0...usklz.length
      if usklz[i][0]==usklz2[-1][0]
        usklz2[-1][1]="#{usklz2[-1][1].split('<:')[0]}/#{usklz[i][2]}"
      else
        usklz2[-1][1]="#{usklz2[-1][1]}/Incomplete" if usklz2[-1][1].split('/').length<skill.length
        usklz2.push([usklz[i][0],usklz[i][2]]) if usklz[i][1]==1
        usklz2.push([usklz[i][0],"OStrt#{micronumber(usklz[i][1])} /#{usklz[i][2]}"]) unless usklz[i][1]==1
      end
    end
    usklz2[-1][1]="#{usklz2[-1][1]}/Incomplete" if usklz2[-1][1].split('/').length<skill.length
    usklz2=usklz2.uniq.sort{|a,b| (supersort(a,b,1)==0 ? -supersort(a,b,0) : -supersort(a,b,1))}
    usklz=[]
    usklz.push(usklz2[0].reverse)
    usklz2.shift
    for i in 0...usklz2.length
      if usklz[-1][0]==usklz2[i][1]
        usklz[-1][1]="#{usklz[-1][1]}, #{usklz2[i][0]}"
      else
        usklz.push(usklz2[i].reverse)
      end
    end
    usklz2=[[],[]]
    for i in 0...usklz.length
      usklz2[0].push([usklz[i][0].gsub('/Incomplete',''),usklz[i][1]]) if usklz[i][0].include?('/Incomplete')
      usklz2[1].push(usklz[i]) unless usklz[i][0].include?('/Incomplete')
    end
    usklz2[0]=usklz2[0].uniq.sort{|a,b| (supersort(a,b,0)==0 ? -supersort(a,b,1) : -supersort(a,b,0))}
    for x in 0...2
      for i in 0...usklz2[x].length
        m=usklz2[x][i][1].split(', ')
        for i2 in 0...m.length
          u=unitz[unitz.find_index{|q| q[0]==m[i2]}]
          m[i2]="~~#{m[i2]}~~" if !u[13].nil? && !u[13][0].nil? && u[13][0].length>0
        end
        usklz2[x][i][1]=m.join(', ')
      end
    end
  else
    usklz2=[[],[]]
  end
  if dispcolors
    for i in 0...usklz2.length
      clrz=[['<:Orb_Red:455053002256941056> Red Summonables',[]],['<:Orb_Blue:455053001971859477> Blue Summonables',[]],
            ['<:Orb_Green:455053002311467048> Green Summonables',[]],['<:Orb_Colorless:455053002152083457> Colorless Summonables',[]],
            ['<:Orb_Gold:455053002911514634> Summonables',[]],['<:Orb_Red:455053002256941056> Red Limited',[]],
            ['<:Orb_Blue:455053001971859477> Blue Limited',[]],['<:Orb_Green:455053002311467048> Green Limited',[]],
            ['<:Orb_Colorless:455053002152083457> Colorless Limited',[]],['<:Orb_Gold:455053002911514634> Limited',[]],
            ['<:Orb_Pink:466196714513235988> Free units',[]]]
      for i3 in 0...usklz2[i].length
        unless usklz2[i][i3][1].nil? || usklz2[i][i3][0].nil?
          k=usklz2[i][i3][1].split(', ')
          for i2 in 0...k.length
            u=unitz[unitz.find_index{|q| q[0]==k[i2].gsub('~~','')}]
            if u[9][0].include?('p')
              clrz[0][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") if u[1][0]=='Red'
              clrz[1][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") if u[1][0]=='Blue'
              clrz[2][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") if u[1][0]=='Green'
              clrz[3][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") if u[1][0]=='Colorless'
              clrz[4][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") unless ['Red','Blue','Green','Colorless'].include?(u[1][0])
            elsif u[9][0].gsub('0s','').include?('s')
              clrz[5][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") if u[1][0]=='Red'
              clrz[6][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") if u[1][0]=='Blue'
              clrz[7][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") if u[1][0]=='Green'
              clrz[8][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") if u[1][0]=='Colorless'
              clrz[9][1].push("#{k[i2]} (#{usklz2[i][i3][0]})") unless ['Red','Blue','Green','Colorless'].include?(u[1][0])
            else
              clrz[10][1].push("#{k[i2]} (#{usklz2[i][i3][0]})")
            end
          end
        end
      end
      for i2 in 0...clrz.length
        clrz[i2][1]=clrz[i2][1].join(', ')
        clrz[i2]=nil if clrz[i2][1].length<=0
      end
      clrz.compact!
      usklz2[i]=clrz.map{|q| q}
    end
  end
  str="#{str}\n\n**Heroes who learn part of the line, without inheritance**\n#{usklz2[0].map{|q| "*#{q[0]}:* #{q[1]}"}.join("\n")}" if usklz2[0].length>0
  str="#{str}\n\n**Heroes who learn the final skill of the line, without inheritance**\n#{usklz2[1].map{|q| "*#{q[0]}:* #{q[1]}"}.join("\n")}" if usklz2[1].length>0
  m=false
  for i in 0...skill.length
    if !skill[i][12].nil? && skill[i][12]!='' && skill[i][4].include?('Passive(W)')
      eff=skill[i][12].split(', ')
      for i2 in 0...eff.length
        eff[i2]=nil unless find_skill(eff[i2],event,true)>1
      end
      eff.compact!
      str="#{str}\n" if eff.length>0 && !m
      m=true if eff.length>0 && !m
      str="#{str}\n**Level #{i+1} gained via Effect Mode on:** #{eff.join(', ')}" if eff.length>0
    end
  end
  lookoutx=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookoutx=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookoutx.push(eval line)
    end
  end
  if lookoutx.map{|q| q[0]}.include?(skill[-1][0]) || skill[-1][0][0,11]=='Panic Ploy '
    statskill=lookoutx.find_index{|q| q[0]==skill[-1][0]}
    statskill=lookoutx.find_index{|q| q[0]=='Panic Ploy'} if statskill.nil?
    statskill=lookoutx[statskill]
    statskill[3]=statskill[3].gsub(' 1','').gsub(' 2','').gsub(' 3','').gsub(' 4','').gsub(' 5','').gsub(' 6','').gsub(' 7','').gsub(' 8','').gsub(' 9','')
    if ['Enemy Phase','Player Phase'].include?(statskill[3])
      str="#{str}\n\n**This skill can be applied to units in the `phasestudy` command.**\nInclude the word \"#{statskill[0].gsub(" #{statskill[0].reverse.scan(/\d+/)[0].reverse}",'').gsub('/','').gsub(' ','')}\" in your message\n*Skill type:* #{statskill[3]}"
    elsif 'In-Combat Buffs'==statskill[3]
      str="#{str}\n\n**This skill can be applied to units in the `phasestudy` command.**\nInclude the word \"#{statskill[0].gsub(" #{statskill[0].reverse.scan(/\d+/)[0].reverse}",'').gsub('/','').gsub(' ','')}\" in your message\n*Skill type:* In-Combat Buff"
    else
      str="#{str}\n\n**This skill can be applied to units in the `stats` command and any derivatives.**\nInclude the word \"#{statskill[0].gsub(" #{statskill[0].reverse.scan(/\d+/)[0].reverse}",'').gsub('/','').gsub(' ','')}\" in your message\n*Skill type:* #{statskill[3]}"
    end
    for i4 in 0...5
      if statskill[4][i4]==0
      elsif statskill[3]=='Stat-Nerfing'
        statskill[4][i4]="-#{statskill[4][i4]}"
      elsif statskill[4][i4]<0
        statskill[4][i4]="+#{0-statskill[4][i4]}" if statskill[3]=='Stat-Nerfing'
      else
        statskill[4][i4]="+#{statskill[4][i4]}"
      end
    end
    statskill[4]="#{statskill[4][0,5].join('/')}#{"\nBin adjusted to ##{statskill[4][5]/5} (BST range #{statskill[4][5]}-#{statskill[4][5]+4}) minimum" if statskill[4].length>5}"
    if statskill[4]=='0/0/0/0/0'
      str="#{str}\n~~*Stat alterations*~~ *Complex interactions with other skills*"
    else
      str="#{str}\n*Stat alterations:* #{statskill[4]}"
    end
  end
  xfooter=nil
  x=0
  x=xfooter.length unless xfooter.nil?
  if "__**#{skill[-1][0].gsub('Bladeblade','Laevatein')}**__".length+str.length+x>=1900
    str=str.split("\n\n")
    m=str.find_index{|q| q[0,8]=='**Heroes'}
    str=[str[0,m].join("\n\n"),str[m,str.length-m].join("\n\n")]
    if "__**#{skill[-1][0].gsub('Bladeblade','Laevatein')}**__".length+str[0].length>=1900
      str[0]=str[0].split('**Promotes into:**')
      create_embed(event,"__**#{skill[-1][0].gsub(" #{skill[-1][0].reverse.scan(/\d+/)[0].reverse}",'')}**__","#{str[0][0]}#{"**Promotes into a lot of things**" if str[0].length>0}",xcolor,nil,xpic)
    else
      create_embed(event,"__**#{skill[-1][0].gsub(" #{skill[-1][0].reverse.scan(/\d+/)[0].reverse}",'')}**__",str[0],xcolor,nil,xpic)
    end
    if str[1].length+x>=1900
      str=str[1].split("\n\n")
      str2=[str[0]]
      if str[0].length>=1900 || str.length==1
        str2=str[0].split("\n**Heroes")
        str2[1]="**Heroes#{str2[1]}"
      end
      for i in 1...str.length
        str2.push(str[i])
      end
      skipfooter=false
      skipfooter=true if xfooter.nil?
      skipfooter=true if !xfooter.nil? && str2[str2.length-1].length+xfooter.length>=1900
      for i in 0...str2.length
        create_embed(event,"",str2[i],xcolor) unless i==str2.length-1 && !skipfooter
        create_embed(event,"",str2[i],xcolor,xfooter) if i==str2.length-1 && !skipfooter
      end
      event.respond xfooter if !xfooter.nil? && skipfooter
    else
      create_embed(event,"",str[1],xcolor,xfooter)
    end
  else
    create_embed(event,"__**#{skill[-1][0].gsub(" #{skill[-1][0].reverse.scan(/\d+/)[0].reverse}",'')}**__",str,xcolor,xfooter,xpic)
  end
  if !['Weapon','Assist','Special'].include?(skill[0][4]) && skill[0][11].split(', ').include?('Link')
    w=sklz.reject{|q| q[4]!='Assist' || !q[11].split(', ').include?('Move') || q[11].split(', ').include?('Music') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| "#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}#{q[0]}#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}"}
    create_embed(event,'',"The following skills, when used on or by the unit holding #{skill[0][0]}, will trigger it:",0x40C0F0,nil,nil,triple_finish(w))
  elsif !['Weapon','Assist','Special'].include?(skill[0][4]) && skill[0][11].split(', ').include?('Feint')
    w=sklz.reject{|q| q[4]!='Assist' || !q[11].split(', ').include?('Rally') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| "#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}#{q[0]}#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}"}
    create_embed(event,'',"The following skills, when used on or by the unit holding #{skill[0][0]}, will trigger it:",0x40C0F0,nil,nil,triple_finish(w))
  end
end

def disp_skill(bot,name,event,ignore=false,dispcolors=false)
  data_load()
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  a=s.split(' ')
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=sever(s,true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  name=stat_buffs(name,name)
  return disp_skill_line(bot,name,event,ignore,dispcolors) if find_skill(name,event,false,false,true,1).is_a?(Array)
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt').each_line do |line|
      lookout.push(eval line)
    end
  end
  lookout2=lookout.reject{|q| q[2]!='Weapon' || q[3].nil?}
  f=find_skill(name,event)
  if f<0
    if event.message.text.downcase.include?('psychic')
      event.respond 'No matches found.  Might you be looking for the skill **Physic** or its upgrade **Physic+**?' unless ignore
    else
      event.respond "No matches found.  If you are looking for data on the skills a character learns, try ```#{first_sub(event.message.text,'skill','skills',1)}```, with an s." unless ignore
    end
    return false
  end
  skill=@skills[f]
  sklz=@skills.map{|q| q}
  g=get_markers(event)
  unitz=@units.reject{|q| !has_any?(g, q[13][0])}
  if skill[4]=='Weapon' && (" #{event.message.text.downcase} ".include?(' refinement ') || " #{event.message.text.downcase} ".include?(' refinements ') || " #{event.message.text.downcase} ".include?(' (w) '))
    if skill[0]=='Falchion'
      disp_skill(bot,'Drive Spectrum',event,ignore)
      disp_skill(bot,'Brave Falchion',event,ignore)
      disp_skill(bot,'Spectrum Bond',event,ignore)
      return true
    elsif skill[0]=='Missiletainn'
      k=@skills[@skills.find_index{|q| q[0]=='Missiletainn (Dark)'}]
      k2=@skills[@skills.find_index{|q| q[0]=='Missiletainn (Dusk)'}]
      disp_skill(bot,find_effect_name(k,event),event,ignore) unless k[15].nil?
      disp_skill(bot,find_effect_name(k2,event),event,ignore) unless k2[15].nil?
      event.respond "#{skill[0]} does not have an Effect Mode.  Showing #{skill[0]}'s default data." if !k[15].nil? && !k2[15].nil?
      return true if !k[15].nil? && !k2[15].nil?
    elsif find_effect_name(skill,event).length>0
      disp_skill(bot,find_effect_name(skill,event),event,ignore)
      return true
    elsif !skill[15].nil?
      event.respond "#{skill[0]} does not have an Effect Mode.  Showing #{skill[0]}'s default data."
    else
      event.respond "#{skill[0]} cannot be refined.  Showing #{skill[0]}'s default data."
    end
  end
  for i in 0...5
    untz=skill[9][i].split(', ')
    untz=untz.reject {|u| u[0,4].downcase != 'all ' && u != '-' && unitz.find_index{|q| q[0]==u}.nil?}
    untz=untz.map {|u| u.gsub('Lavatain','Laevatein')}
    untz=untz.sort {|a,b| a.downcase <=> b.downcase}
    for i2 in 0...untz.length
      untz[i2]="~~#{untz[i2]}~~" unless ['Laevatein','Laevatein(Winter)'].include?(untz[i2]) || untz[i2][0,4].downcase=='all ' || untz[i2]=='-' || unitz[unitz.find_index{|q| q[0]==untz[i2]}][13][0].nil? || !skill[13].nil?
    end
    skill[9][i]=untz.join(', ')
    untz=skill[10][i].split(', ')
    untz=untz.map {|u| u.gsub('[Retro]','')}
    untz=untz.reject {|u| u[0,4].downcase != 'all ' && u != '-' && unitz.find_index{|q| q[0]==u}.nil?}
    untz=untz.map {|u| u.gsub('Lavatain','Laevatein')}
    untz=untz.sort {|a,b| a.downcase <=> b.downcase}
    for i2 in 0...untz.length
      untz[i2]="~~#{untz[i2]}~~" unless ['Laevatein','Laevatein(Winter)'].include?(untz[i2]) || untz[i2][0,4].downcase=='all ' || untz[i2]=='-' || unitz[unitz.find_index{|q| q[0]==untz[i2]}][13][0].nil? || !skill[13].nil?
    end
    skill[10][i]=untz.join(', ')
  end
  str=''
  xcolor=0x02010a
  xfooter=nil
  xpic=nil
  sklslt=['']
  if skill[4]=='Weapon'
    xcolor=0xF4728C
    effective=[]
    xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Weapons/#{skill[0].gsub(' ','_').gsub('.','').gsub('/','_').gsub('+','').gsub('!','')}.png?raw=true"
    if skill[5]=='Red Tome Users Only'
      s=find_base_skill(skill,event)
      xfooter='Dark Mages can still learn this skill, it just takes more SP.'
      if s=="Rau\u00F0r"
        xfooter=nil
      elsif s=='Flux'
        s='Dark'
        xfooter=xfooter.gsub('Dark','Fire')
      end
      emote='<:Red_Tome:443172811826003968>'
      moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{s}_Tome"}
      emote=moji[0].mention unless moji.length<=0
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n#{emote} **Weapon Type:** #{s} Magic (Red Tome)\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=='Blue Tome Users Only'
      s=find_base_skill(skill,event)
      xfooter='Light Mages can still learn this skill, it just takes more SP.'
      if s=="Bl\u00E1r"
        xfooter=nil
      elsif s=='Light'
        xfooter=xfooter.gsub('Light','Thunder')
      end
      emote='<:Blue_Tome:467112472394858508>'
      moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{s}_Tome"}
      emote=moji[0].mention unless moji.length<=0
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n#{emote} **Weapon Type:** #{s} Magic (Blue Tome)\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=='Green Tome Users Only'
      s=find_base_skill(skill,event)
      if s=='Gronn'
        xfooter=nil
      end
      emote='<:Green_Tome:467122927666593822>'
      moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{s}_Tome"}
      emote=moji[0].mention unless moji.length<=0
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n#{emote} **Weapon Type:** #{s} Magic (Green Tome)\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=='Bow Users Only'
      effective.push('<:Icon_Move_Flier:443331186698354698>') unless skill[11].split(', ').include?('UnBow')
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Bow:443172812492898314> **Weapon Type:** Bow\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}"
    elsif skill[5]=='Dagger Users Only'
      skill[7]=skill[7].split(' *** ')
      xfooter="Debuff is applied at end of combat if unit attacks, and lasts until the foes' next actions."
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Dagger:443172811461230603> **Weapon Type:** Dagger\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}"
    elsif skill[5]=='Staff Users Only'
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n#{"<:Gold_Staff:443172811628871720>" if alter_classes(event,'Colored Healers')}#{"<:Colorless_Staff:443692132323295243>" unless alter_classes(event,'Colored Healers')} **Weapon Type:** Staff\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}"
    elsif skill[5]=='Dragons Only'
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Dragon:443172811641454592> **Weapon Type:** Breath (Dragons)\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}"
    elsif skill[0]=='Adult (All)'
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Beast:532854442299752469> **Weapon Type:** Beast Damage\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}\n**Beast Mechanics:** At start of turn, if unit is either not adjacent to any allies, or adjacent to only beast and dragon allies, unit transforms.  Otherwise, unit reverts back to humanoid form."
      skzz=sklz.reject{|q| q[0]=='Adult (All)' || q[0][0,7]!='Adult ('}
      for i in 0...skzz.length
        m=skzz[i][5].split(', ')[1].split(' ').map{|q| q.gsub('s','')}.reject{|q| !['Infantry','Armor','Flier','Cavalry'].include?(q)}
        movemoji=''
        for i2 in 0...m.length
          moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{m[i2]}"}
          movemoji="#{movemoji}#{moji[0].mention}" if moji.length>0
        end
        str="#{str}\n\n#{movemoji} __**#{skzz[i][0]}**__"
        str="#{str}\n**Effect:** #{skzz[i][7]}" unless skzz[i][7]=='-'
        str="#{str}\n**Promotes from:** #{skzz[i][8]}"
        fz=sklz.find_index{|q| q[0]==skzz[i][0]}
        p=find_promotions(fz,event)
        p=p.uniq
        unless p.length.zero?
          for i2 in 0...p.length
            p[i2]="~~#{p[i2]}~~" unless ['Laevatein','Laevatein(Winter)'].include?(p[i2]) || sklz[sklz.find_index{|q2| q2[0]==p[i2]}][13].nil? || !skill[13].nil?
          end
          if p.length>8 && !event.message.text.downcase.split(' ').include?('expanded')
            xfooter='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
            p2=p.reject{|q| q.gsub('~~','')=='Laevatein' || sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][6]!='-'}
            if p==p2
              p=list_lift(p.map{|q| "*#{q}*"},"or")
            else
              p="#{p2.map{|q| "*#{q}*"}.join(', ')}, and #{p.length-p2.length} Prf weapons"
            end
            p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][10].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
          else
            p2=p.reject{|q| ['Laevatein','Laevatein(Winter)'].include?(q.gsub('~~','')) || sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][6]!='-'}
            p=list_lift(p.map{|q| "*#{q}*"},"or")
            p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][10].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
          end
          str="#{str}\n**Promotes into:** #{p}"
        end
      end
      str="#{str}\n"
    elsif skill[5].split(', ')[0]=='Beasts Only'
      m=skill[5].split(', ')[1].split(' ').map{|q| q.gsub('s','')}.reject{|q| !['Infantry','Armor','Flier','Cavalry'].include?(q)}
      movemoji=''
      for i in 0...m.length
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{m[i]}"}
        movemoji="#{movemoji}#{moji[0].mention}" if moji.length>0
      end
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Beast:532854442299752469> **Weapon Type:** Beast Damage\n#{movemoji} **Movement Type:** #{skill[5].split(', ')[1]}\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}\n**Beast Mechanics:** At start of turn, if unit is either not adjacent to any allies, or adjacent to only beast and dragon allies, unit transforms.  Otherwise, unit reverts back to humanoid form."
    elsif skill[0]=='Missiletainn'
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n\n__**Missiletainn (Dark)**__\n<:Red_Blade:443172811830198282> **Weapon Type:** Sword (Red Blade)\n**Might:** #{skill[2]+1}  \u200B  \u200B  \u200B  **Range:** 1\n**Effect:** #{skill[7].split(' *** ')[0]}\n**<:Prf_Sparkle:490307608973148180>Prf to:** Owain\n**Promotes from:** *Silver Sword*\n\n__**Missiletainn (Dusk)**__\n<:Light_Tome:499760605381787650> **Weapon Type:** Light Magic (Blue Tome)\n**Might:** #{skill[2]-1}  \u200B  \u200B  \u200B  **Range:** 2"
      skill[7]=skill[7].split(' *** ')[1]
    else
      s=skill[5]
      s=s[0,s.length-11]
      s='<:Red_Blade:443172811830198282> / Sword (Red Blade)' if s=='Sword'
      s='<:Blue_Blade:467112472768151562> / Lance (Blue Blade)' if s=='Lance'
      s='<:Green_Blade:467122927230386207> / Axe (Green Blade)' if s=='Axe'
      s='<:Summon_Gun:453639908968628229> / Summon Gun' if s=='Summon Gun'
      s="<:Gold_Unknown:443172811499110411> / #{s}" unless s.include?(' / ')
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n#{s.split(' / ')[0]} **Weapon Type:** #{s.split(' / ')[1]}\n**Might:** #{skill[2]}  \u200B  \u200B  \u200B  **Range:** #{skill[3]}"
    end
    for i in 0...lookout2.length
      effective.push(lookout2[i][3]) if skill[11].split(', ').include?(lookout2[i][0])
    end
    str="#{str}\n**Effective against:** #{effective.join('')}" if effective.length>0 && skill[0]!='Mana Cat'
    if skill[7].is_a?(Array)
      if skill[7][1].nil?
        str="#{str}\n**Debuff:**  \u200B  \u200B  \u200B  *None*"
      else
        eff=skill[7][1].split(', ')
        str="#{str}\n**Debuff:**  \u200B  \u200B  \u200B  *Effect:* #{eff[0,eff.length-1].join(', ')}  \u200B  \u200B  \u200B  *Affects:* #{eff[eff.length-1]}"
      end
      unless skill[7][2].nil?
        eff=skill[7][2].split(', ')
        str="#{str}\n**Buff:**  \u200B  \u200B  \u200B  *Effect:* #{eff[0,eff.length-1].join(', ')}  \u200B  \u200B  \u200B  *Affects:* #{eff[eff.length-1]}"
      end
      str="#{str}\n**Additional Effect:**  \u200B  \u200B  \u200B  #{skill[7][0]}" unless skill[7][0]=='-'
    elsif skill[0]=='Adult (All)'
    else
      str="#{str}\n**Effect:** #{skill[7]}" unless skill[7]=='-'
    end
    str="#{str}\n**<:Prf_Sparkle:490307608973148180>Prf to:** Ophelia\n**Promotes from:** *Shine*" if skill[0]=='Missiletainn'
    str="#{str}\n**Stats affected:** 0/#{'+' if skill[12][1]>0}#{skill[12][1]}/#{'+' if skill[12][2]>0}#{skill[12][2]}/#{'+' if skill[12][3]>0}#{skill[12][3]}/#{'+' if skill[12][4]>0}#{skill[12][4]}" unless skill[0]=='Missiletainn' || skill[5].split(', ')[0]=='Beasts Only'
    str="#{str}\n**Stats affected (humanoid):** 0/#{'+' if skill[12][1]>0}#{skill[12][1]}/#{'+' if skill[12][2]>0}#{skill[12][2]}/#{'+' if skill[12][3]>0}#{skill[12][3]}/#{'+' if skill[12][4]>0}#{skill[12][4]}" if skill[5].split(', ')[0]=='Beasts Only'
    str="#{str}\n**Stats affected (transformed):** 0/#{'+' if skill[12][1]+skill[12][6]>0}#{skill[12][1]+skill[12][6]}/#{'+' if skill[12][2]+skill[12][7]>0}#{skill[12][2]+skill[12][7]}/#{'+' if skill[12][3]+skill[12][8]>0}#{skill[12][3]+skill[12][8]}/#{'+' if skill[12][4]+skill[12][9]>0}#{skill[12][4]+skill[12][9]}" if skill[5].split(', ')[0]=='Beasts Only'
    sklslt=['Weapon']
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
    cumul=cumulative_sp_cost(skill,event)
    cumul2=cumul+skill[1]/2
    if skill[0][skill[0].length-1,1]=='+' && skill[11].split(', ').include?("Seasonal")
      # seasonal + weapons come bundled with their non-plus selves, so their minimum inherited SP cost has to include the non-plus version as inherited as well
      cumul2+=sklz[sklz.find_index{|q| q[0]==skill[0].gsub('+','')}][1]/2
    elsif skill[0][skill[0].length-1,1]=='+' && skill[5]=="Staff Users Only"
      # seasonal + weapons come bundled with their non-plus selves, so their minimum inherited SP cost has to include the non-plus version as inherited as well
      cumul2+=sklz[sklz.find_index{|q| q[0]==skill[0].gsub('+','')}][1]/2
    end
    str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul2}-#{cumul*3/2} when inherited)" if skill[6]=='-'}" unless cumul==skill[1]
  elsif skill[4]=='Assist'
    sklslt=['Assist']
    xcolor=0x07DFBB
    xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Assists/#{skill[0].gsub(' ','_').gsub('/','_').gsub('.','').gsub('+','').gsub('!','')}.png?raw=true"
    str="<:Skill_Assist:444078171025965066> **Skill Slot:** #{skill[4]}\n**Range:** #{skill[3]}\n**Effect:** #{skill[7]}"
    str="#{str}\n**Heals:** #{skill[14]}" if skill[5]=="Staff Users Only"
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
    cumul=cumulative_sp_cost(skill,event)
    cumul2=cumul+skill[1]/2
    if skill[0][skill[0].length-1,1]=='+' && skill[5]=="Staff Users Only"
      cumul2+=sklz[sklz.find_index{|q| q[0]==skill[0].gsub('+','')}][1]/2
    end
    str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul2}-#{cumul*3/2} when inherited)" if skill[6]=='-'}" unless cumul==skill[1]
    xfooter="You may be looking for the reload command." if skill[0][0,7]=='Restore' && !event.message.text.downcase.include?('skill') && (event.user.id==167657750971547648 || event.channel.id==386658080257212417)
  elsif skill[4]=='Special'
    sklslt=['Special']
    xcolor=0xF67EF8
    xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Specials/#{skill[0].gsub(' ','_').gsub('/','_').gsub('.','').gsub('+','').gsub('!','')}.png?raw=true"
    str="<:Skill_Special:444078170665254929> **Skill Slot:** #{skill[4]}\n**Cooldown:** #{skill[2]}\n**Effect:** #{skill[7]}#{"\n**Range:** ```\n#{skill[3].gsub("n","\n")}```" if skill[3]!="-"}"
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
    cumul=cumulative_sp_cost(skill,event)
    str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul+skill[1]/2}-#{cumul*3/2} when inherited)" if skill[6]=='-'}" unless cumul==skill[1]
  else
    xcolor=0xFDDC7E
    sklimg=skill[0].gsub(' ','_').gsub('/','_').gsub('!','').gsub('.','')
    sklimg="Squad_Ace_#{"ABCDE"["ABCDEFGHIJKLMNOPQRSTUVWXYZ".split(skill[0][10,1])[0].length%5,1]}_#{skill[0][12,skill[0].length-12]}" if skill[0][0,10]=='Squad Ace '
    xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/skills/#{sklimg}.png?raw=true"
    if " #{event.message.text.downcase} ".include?(' refinement ') || " #{event.message.text.downcase} ".include?(' refinements ') || " #{event.message.text.downcase} ".include?(' (w) ')
      s=skill[0].gsub('/','_').split(' ')
      s[s.length-1]='W' if s[s.length-1].length<2
      xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/skills/#{s.join('_')}.png?raw=true"
    end
    sklslt=skill[4].split(', ')
    if !skill[12].nil? && skill[12]!='' && skill[4].include?('Passive(W)')
      eff=skill[12].split(', ')
      for i in 0...eff.length
        eff[i]=nil unless find_skill(eff[i],event,true)>1
      end
      eff.compact!
      if eff.length<=0
        for i in 0...sklslt.length
          sklslt[i]=nil if sklslt[i]=='Passive(W)'
        end
        sklslt.compact!
      end
    end
    emo=[]
    for i in 0...sklslt.length
      emo.push('<:Passive_A:443677024192823327>') if sklslt[i]=='Passive(A)'
      emo.push('<:Passive_B:443677023257493506>') if sklslt[i]=='Passive(B)'
      emo.push('<:Passive_C:443677023555026954>') if sklslt[i]=='Passive(C)'
      emo.push('<:Passive_S:443677023626330122>') if sklslt[i]=='Passive(S)' || sklslt[i]=='Seal'
      emo.push('<:Passive_W:443677023706152960>') if sklslt[i]=='Passive(W)'
    end
    str="#{emo.join('')} **Skill Slot:** #{sklslt.join(', ')}"
    str="#{str}\n**Effect:** #{skill[7]}"
    if skill[0]=='Distant Counter'
      str="#{str}\n**Secondary effect:** Breaks consecutiveness of enemy mage/bow/dagger/staff attacks"
    elsif skill[0]=='Close Counter'
      str="#{str}\n**Secondary effect:** Breaks consecutiveness of enemy sword/axe/lance/breath attacks"
    end
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
    cumul=cumulative_sp_cost(skill,event)
    str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul+skill[1]/2}-#{cumul*3/2} when inherited)" if skill[6]=='-'}" unless cumul==skill[1]
    if skill[4].split(', ').include?('Seal') && skill[3]!="-" && skill[3][0,1].downcase!=skill[3][0,1]
      floop=skill[3].split(' ')
      floop[0]='<:Great_Badge_Transparent:443704781597573120> <:Badge_Transparent:445510675976945664>' if floop[0].downcase=='transparent'
      floop[0]='<:Great_Badge_Scarlet:443704781001850910> <:Badge_Scarlet:445510676060962816>' if floop[0].downcase=='scarlet'
      floop[0]='<:Great_Badge_Azure:443704780783616016> <:Badge_Azure:445510675352125441>' if floop[0].downcase=='azure'
      floop[0]='<:Great_Badge_Verdant:443704780943261707> <:Badge_Verdant:445510676056899594>' if floop[0].downcase=='verdant'
      for i in 1...floop.length
        floop[i]=floop[i].to_i
      end
      str="#{str}\n**Seal Cost:** #{floop[1]}#{floop[0].split(' ')[0]} #{floop[2]}#{floop[0].split(' ')[1]} #{floop[3]}<:Sacred_Coin:453618312996323338>"
      cumul=cumulative_sp_cost(skill,event,1)
      str="#{str}\n**Cumulative Seal Cost:** #{cumul[1]}#{floop[0].split(' ')[0]} #{cumul[2]}#{floop[0].split(' ')[1]} #{cumul[3]}<:Sacred_Coin:453618312996323338>" if [cumul[1],cumul[2],cumul[3]]!=[floop[1],floop[2],floop[3]]
    end
  end
  p=find_promotions(f,event)
  p=p.uniq
  if skill[4].include?('Passive') || skill[4]=='Seal'
    p=p.reject{|q| ['Weapon', 'Assist', 'Special'].include?(sklz[find_skill(q,event,true,true)][4])}
    p=p.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(A)')} if skill[4].include?('(A)')
    p=p.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(B)')} if skill[4].include?('(B)')
    p=p.reject{|q| !sklz[find_skill(q,event,true,true)][4].include?('(C)')} if skill[4].include?('(C)')
  else
    p=p.reject{|q| !has_any?(sklslt, sklz[find_skill(q,event,true,true)][4].split(', '))}
  end
  p3=unitz.map{|q| q}
  if p.length.zero?
    p=nil
  else
    for i2 in 0...p.length
      p[i2]="~~#{p[i2]}~~" unless ['Laevatein','Laevatein(Winter)'].include?(p[i2]) || sklz[sklz.find_index{|q2| q2[0]==p[i2]}][13].nil? || !skill[13].nil?
    end
    if p.length>8 && skill[4]=='Weapon' && !event.message.text.downcase.split(' ').include?('expanded')
      xfooter='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
      p2=p.reject{|q| q.gsub('~~','')=='Laevatein' || sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][6]!='-'}
      if p==p2
        p=list_lift(p.map{|q| "*#{q}*"},"or")
      else
        p="#{p2.map{|q| "*#{q}*"}.join(', ')}, and #{p.length-p2.length} Prf weapons"
      end
      p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][10].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
    elsif skill[4]=='Weapon'
      p2=p.reject{|q| ['Laevatein','Laevatein(Winter)'].include?(q.gsub('~~','')) || sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][6]!='-'}
      p=list_lift(p.map{|q| "*#{q}*"},"or")
      p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][10].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
    else
      p=list_lift(p.map{|q| "*#{q}*"},"or")
    end
  end
  str="#{str}#{"\n**Restrictions on inheritance:** #{skill[5].gsub('Excludes Tome Users, Excludes Staff Users, Excludes Dragons','Physical Weapon Users Only')}" if skill[6]=='-' && skill[4]!='Weapon'}#{"\n**<:Prf_Sparkle:490307608973148180>Prf to:** #{skill[6].split(', ').reject {|u| find_unit(u,event,false,true)<0 && u != '-'}.join(', ').gsub('Lavatain','Laevatein')}" unless ['Missiletainn','Adult (All)'].include?(skill[0]) || skill[6]=='-' || skill[6].split(', ').reject {|u| find_unit(u,event,false,true)<0 && u != '-'}.length.zero?}#{"\n**Promotes from:** #{skill[8]}" unless ['Missiletainn','Adult (All)'].include?(skill[0]) || skill[8]=='-'}#{"\n**Promotes into:** #{p}" unless p.nil?}"
  if !skill[14].nil? && skill[14].length>0 && skill[4]=='Weapon'
    prm=skill[14].split(', ')
    for i in 0...prm.length
      sklll=prm[i].split('!')
      if sklll.length==1
        prm[i]=nil if x_find_skill(sklll[0],event,sklz.map{|q| q})<0
      else
        prm[i]="#{sklll[1]} (#{sklll[0]})"
        prm[i]=nil if x_find_skill(sklll[1],event,sklz.map{|q| q})<0
        prm[i]=nil if find_unit(sklll[0],event,false,true)<0
      end
    end
    str="#{str}\n**Evolves into:** #{list_lift(prm.map{|q| "*#{q}*"},"or")}"
  elsif skill[0]=='Falchion'
    sk1=sklz[find_skill('Falchion (Mystery)',event,true,true)]
    sk2=sklz[find_skill('Falchion (Valentia)',event,true,true)]
    sk3=sklz[find_skill('Falchion (Awakening)',event,true,true)]
    str="#{str}\n**Falchion(Mystery) evolves into:** #{list_lift(sk1[14].split(', ').map{|q| "*#{q}*"},"or")}" if !sk1[14].nil? && sk1[14].length>0 && sk1[4]=='Weapon'
    str="#{str}\n**Falchion(Valentia) evolves into:** #{list_lift(sk2[14].split(', ').map{|q| "*#{q}*"},"or")}" if !sk2[14].nil? && sk2[14].length>0 && sk2[4]=='Weapon'
    str="#{str}\n**Falchion(Awakening) evolves into:** #{list_lift(sk3[14].split(', ').map{|q| "*#{q}*"},"or")}" if !sk3[14].nil? && sk3[14].length>0 && sk3[4]=='Weapon'
  elsif skill[0]=='Missiletainn'
    sk1=sklz[find_skill('Missiletainn (Dark)',event,true,true)]
    sk2=sklz[find_skill('Missiletainn (Dusk)',event,true,true)]
    str="#{str}\n**Missiletainn(Dark) evolves into:** #{list_lift(sk1[14].split(', ').map{|q| "*#{q}*"},"or")}" if !sk1[14].nil? && sk1[14].length>0 && sk1[4]=='Weapon'
    str="#{str}\n**Missiletainn(Dusk) evolves into:** #{list_lift(sk2[14].split(', ').map{|q| "*#{q}*"},"or")}" if !sk2[14].nil? && sk2[14].length>0 && sk2[4]=='Weapon'
  end
  x=false
  can_also=true
  unless dispcolors
    str2='**Heroes who know it out of the box:**'
    for i in 0...@max_rarity_merge[0]
      if skill[9][i]=='-' || skill[9][i]==''
      elsif skill[4]=='Weapon' && skill[9][i].split(', ').length>8 && !event.message.text.downcase.split(' ').include?('expanded')
        xfooter='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
        m=skill[9][i].split(', ').reject{|q| !p3.include?(q)}.join(', ')
        str2="#{str2}\n*#{i+1}#{@rarity_stars[i]}:* #{m}, and #{skill[9][i].split(', ').length-m.split(', ').length} units who end up having Prf weapons."
      else
        str2="#{str2}\n*#{i+1}#{@rarity_stars[i]}:* #{skill[9][i]}"
      end
    end
    str="#{str}#{"\n" unless x}\n#{str2}" unless str2=='**Heroes who know it out of the box:**' || ['Missiletainn','Adult (All)'].include?(skill[0])
    x=true unless str2=='**Heroes who know it out of the box:**' || ['Missiletainn','Adult (All)'].include?(skill[0])
  end
  str2='**Heroes who can learn without inheritance:**'
  clrz=[[],[],[],[],[],[],[],[],[],[],[]]
  unitz=@units.map{|q| q}
  for i in 0...@max_rarity_merge[0]
    if skill[10][i]=='-' || skill[10][i]==''
    elsif skill[4]=='Weapon' && skill[10][i].split(', ').length>8 && !event.message.text.downcase.split(' ').include?('expanded')
      xfooter='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
      m=skill[10][i].split(', ').reject{|q| !p3.include?(q)}.join(', ')
      str2="#{str2}\n*#{i+1}#{@rarity_stars[i]}:* #{m}, and #{skill[10][i].split(', ').length-m.split(', ').length} units who end up having Prf weapons."
    elsif dispcolors
      m=skill[10][i].split(', ')
      for i2 in 0...m.length
        m2=unitz[unitz.find_index{|q| q[0]==m[i2].gsub('~~','')}]
        m3=i+1
        m4=[]
        m2[9][0].each_char{|q| m4.push(q.to_i)}
        m3=[m4.reject{|q| q==0}.min,m3].max
        m3="#{m[i2]} (#{m3}#{@rarity_stars[m3-1]})"
        if m2[9][0].include?('p')
          clrz[0].push(m3) if m2[1][0]=='Red'
          clrz[1].push(m3) if m2[1][0]=='Blue'
          clrz[2].push(m3) if m2[1][0]=='Green'
          clrz[3].push(m3) if m2[1][0]=='Colorless'
          clrz[4].push(m3) unless ['Red','Blue','Green','Colorless'].include?(m2[1][0])
        elsif m2[9][0].gsub('0s','').include?('s')
          clrz[5].push(m3) if m2[1][0]=='Red'
          clrz[6].push(m3) if m2[1][0]=='Blue'
          clrz[7].push(m3) if m2[1][0]=='Green'
          clrz[8].push(m3) if m2[1][0]=='Colorless'
          clrz[9].push(m3) unless ['Red','Blue','Green','Colorless'].include?(m2[1][0])
        else
          clrz[10].push(m3)
        end
      end
    else
      str2="#{str2}\n*#{i+1}#{@rarity_stars[i]}:* #{skill[10][i]}"
    end
  end
  str2="#{str2}\n*<:Orb_Red:455053002256941056> Red Summonables:* #{clrz[0].join(', ')}" unless clrz[0].length<=0
  str2="#{str2}\n*<:Orb_Blue:455053001971859477> Blue Summonables:* #{clrz[1].join(', ')}" unless clrz[1].length<=0
  str2="#{str2}\n*<:Orb_Green:455053002311467048> Green Summonables:* #{clrz[2].join(', ')}" unless clrz[2].length<=0
  str2="#{str2}\n*<:Orb_Colorless:455053002152083457> Colorless Summonables:* #{clrz[3].join(', ')}" unless clrz[3].length<=0
  str2="#{str2}\n*<:Orb_Gold:455053002911514634> Summonables:* #{clrz[4].join(', ')}" unless clrz[4].length<=0
  str2="#{str2}\n*<:Orb_Red:455053002256941056> Red Limited:* #{clrz[5].join(', ')}" unless clrz[5].length<=0
  str2="#{str2}\n*<:Orb_Blue:455053001971859477> Blue Limited:* #{clrz[6].join(', ')}" unless clrz[6].length<=0
  str2="#{str2}\n*<:Orb_Green:455053002311467048> Green Limited:* #{clrz[7].join(', ')}" unless clrz[7].length<=0
  str2="#{str2}\n*<:Orb_Colorless:455053002152083457> Colorless Limited:* #{clrz[8].join(', ')}" unless clrz[8].length<=0
  str2="#{str2}\n*<:Orb_Gold:455053002911514634> Limited:* #{clrz[9].join(', ')}" unless clrz[9].length<=0
  str2="#{str2}\n*<:Orb_Pink:466196714513235988> Free units:* #{clrz[10].join(', ')}" unless clrz[10].length<=0
  clrz=[[],[],[],[],[],[],[],[],[],[],[]]
  unitz=@units.map{|q| q}
  str="#{str}#{"\n" unless x}\n#{str2}" unless str2=='**Heroes who can learn without inheritance:**' || ['Missiletainn','Adult (All)'].include?(skill[0])
  x=true unless str2=='**Heroes who can learn without inheritance:**' || ['Missiletainn','Adult (All)'].include?(skill[0])
  prev=find_prevolutions(f,event)
  if prev.length>0 && skill[0]!=['Missiletainn','Adult (All)'].include?(skill[0])
    for i in 0...prev.length
      skill2=prev[i][0]
      for i2 in 0...@max_rarity_merge[0]
        untz=skill2[10][i2].split(', ')
        untz=untz.reject {|u| find_unit(u,event,false,true)<0 && u[0,4].downcase != 'all ' && u != '-'}
        untz=untz.map {|u| u.gsub('Lavatain','Laevatein')}
        untz=untz.sort {|a,b| a.downcase <=> b.downcase}
        skill2[10][i2]=untz.join(', ')
      end
      str2="**It#{' also' if x} evolves from #{skill2[0]}, #{prev[i][1]} the following heroes:**"
      unitz=@units.map{|q| q}
      for i2 in 0...@max_rarity_merge[0]
        if skill2[10][i2]=='-' || skill2[10][i2]==''
        elsif dispcolors
          m=skill2[10][i2].split(', ')
          for i3 in 0...m.length
            m2=unitz[unitz.find_index{|q| q[0]==m[i3].gsub('~~','')}]
            m3=i2+1
            m4=[]
            m2[9][0].each_char{|q| m4.push(q.to_i)}
            m3=[m4.reject{|q| q==0}.min,m3].max
            m3="#{m[i3]} (#{m3}#{@rarity_stars[m3-1]})"
            if m2[9][0].include?('p')
              clrz[0].push(m3) if m2[1][0]=='Red'
              clrz[1].push(m3) if m2[1][0]=='Blue'
              clrz[2].push(m3) if m2[1][0]=='Green'
              clrz[3].push(m3) if m2[1][0]=='Colorless'
              clrz[4].push(m3) unless ['Red','Blue','Green','Colorless'].include?(m2[1][0])
            elsif m2[9][0].gsub('0s','').include?('s')
              clrz[5].push(m3) if m2[1][0]=='Red'
              clrz[6].push(m3) if m2[1][0]=='Blue'
              clrz[7].push(m3) if m2[1][0]=='Green'
              clrz[8].push(m3) if m2[1][0]=='Colorless'
              clrz[9].push(m3) unless ['Red','Blue','Green','Colorless'].include?(m2[1][0])
            else
              clrz[10].push(m3)
            end
          end
        else
          str2="#{str2}\n*#{i2+1}#{@rarity_stars[i2]}:* #{skill2[10][i2]}"
        end
      end
      str2="#{str2}\n*<:Orb_Red:455053002256941056> Red Summonables:* #{clrz[0].join(', ')}" unless clrz[0].length<=0
      str2="#{str2}\n*<:Orb_Blue:455053001971859477> Blue Summonables:* #{clrz[1].join(', ')}" unless clrz[1].length<=0
      str2="#{str2}\n*<:Orb_Green:455053002311467048> Green Summonables:* #{clrz[2].join(', ')}" unless clrz[2].length<=0
      str2="#{str2}\n*<:Orb_Colorless:455053002152083457> Colorless Summonables:* #{clrz[3].join(', ')}" unless clrz[3].length<=0
      str2="#{str2}\n*<:Orb_Gold:455053002911514634> Summonables:* #{clrz[4].join(', ')}" unless clrz[4].length<=0
      str2="#{str2}\n*<:Orb_Red:455053002256941056> Red Limited:* #{clrz[5].join(', ')}" unless clrz[5].length<=0
      str2="#{str2}\n*<:Orb_Blue:455053001971859477> Blue Limited:* #{clrz[6].join(', ')}" unless clrz[6].length<=0
      str2="#{str2}\n*<:Orb_Green:455053002311467048> Green Limited:* #{clrz[7].join(', ')}" unless clrz[7].length<=0
      str2="#{str2}\n*<:Orb_Colorless:455053002152083457> Colorless Limited:* #{clrz[8].join(', ')}" unless clrz[8].length<=0
      str2="#{str2}\n*<:Orb_Gold:455053002911514634> Limited:* #{clrz[9].join(', ')}" unless clrz[9].length<=0
      str2="#{str2}\n*<:Orb_Pink:466196714513235988> Free units:* #{clrz[10].join(', ')}" unless clrz[10].length<=0
      if str2=="**It#{' also' if x} evolves from #{skill2[0]}, #{prev[i][1]} the following heroes:**"
        str="#{str}\n\n**It#{' also' if x} evolves from #{skill2[0]}**"
      else
        str="#{str}\n\n#{str2}"
      end
    end
    str2='**Evolution cost:** 300 SP (450 if inherited), 200<:Arena_Medal:453618312446738472> 20<:Refining_Stone:453618312165720086>'
    str2='**Evolution cost:** 300 SP (450 if inherited), 100<:Arena_Medal:453618312446738472> 10<:Refining_Stone:453618312165720086>' if skill[0]=='Candlelight+'
    str2='**Evolution cost:** 400 SP, 375<:Arena_Medal:453618312446738472> 150<:Divine_Dew:453618312434417691>' if skill[6]!='-'
    str2='**Evolution cost:** 1 story-gift Gunnthra<:Green_Tome:467122927666593822><:Icon_Move_Cavalry:443331186530451466><:Legendary_Effect_Wind:443331186467536896><:Ally_Boost_Resistance:443331185783865355>' if skill[0]=='Chill Breidablik'
    str="#{str}\n#{"\n" if prev.length>1}#{str2}"
  end
  if !skill[12].nil? && skill[12]!='' && skill[4].include?('Passive(W)')
    eff=skill[12].split(', ')
    for i in 0...eff.length
      eff[i]=nil unless find_skill(eff[i],event,true)>1
    end
    eff.compact!
    str="#{str}\n\n**Gained via Effect Mode on:** #{eff.join(', ')}" if eff.length>0
  end
  lookoutx=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
    lookoutx=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
      lookoutx.push(eval line)
    end
  end
  if lookoutx.map{|q| q[0]}.include?(skill[0]) || skill[0][0,11]=='Panic Ploy '
    statskill=lookoutx.find_index{|q| q[0]==skill[0]}
    statskill=lookoutx.find_index{|q| q[0]=='Panic Ploy'} if statskill.nil?
    statskill=lookoutx[statskill]
    statskill[3]=statskill[3].gsub(' 1','').gsub(' 2','').gsub(' 3','').gsub(' 4','').gsub(' 5','').gsub(' 6','').gsub(' 7','').gsub(' 8','').gsub(' 9','')
    if ['Enemy Phase','Player Phase'].include?(statskill[3])
      str="#{str}\n\n**This skill can be applied to units in the `phasestudy` command.**\nInclude the word \"#{statskill[0].gsub('/','').gsub(' ','')}\" in your message\n*Skill type:* #{statskill[3]}"
    elsif 'In-Combat Buffs'==statskill[3]
      str="#{str}\n\n**This skill can be applied to units in the `phasestudy` command.**\nInclude the word \"#{statskill[0].gsub('/','').gsub(' ','')}\" in your message\n*Skill type:* In-Combat Buff"
    else
      str="#{str}\n\n**This skill can be applied to units in the `stats` command and any derivatives.**\nInclude the word \"#{statskill[0].gsub('/','').gsub(' ','')}\" in your message\n*Skill type:* #{statskill[3]}"
    end
    for i4 in 0...5
      if statskill[4][i4]==0
      elsif statskill[3]=='Stat-Nerfing'
        statskill[4][i4]="-#{statskill[4][i4]}"
      elsif statskill[4][i4]<0
        statskill[4][i4]="+#{0-statskill[4][i4]}" if statskill[3]=='Stat-Nerfing'
      else
        statskill[4][i4]="+#{statskill[4][i4]}"
      end
    end
    statskill[4]="#{statskill[4][0,5].join('/')}#{"\nBin adjusted to ##{statskill[4][5]/5} (BST range #{statskill[4][5]}-#{statskill[4][5]+4}) minimum" if statskill[4].length>5}"
    if statskill[4]=='0/0/0/0/0'
      str="#{str}\n~~*Stat alterations*~~ *Complex interactions with other skills*"
    else
      str="#{str}\n*Stat alterations:* #{statskill[4]}"
    end
  end
  unless (" #{event.message.text.downcase} ".include?(' refined ') && !" #{event.message.text.downcase} ".include?(' default ') && !" #{event.message.text.downcase} ".include?(' base ')) && skill[4]=="Weapon"
    x=0
    x=xfooter.length unless xfooter.nil?
    if "__**#{skill[0].gsub('Bladeblade','Laevatein')}**__".length+str.length+x>=1900
      str=str.split("\n\n")
      m=str.find_index{|q| q[0,8]=='**Heroes'}
      str=[str[0,m].join("\n\n"),str[m,str.length-m].join("\n\n")]
      if "__**#{skill[0].gsub('Bladeblade','Laevatein')}**__".length+str[0].length>=1900
        str[0]=str[0].split('**Promotes into:**')
        create_embed(event,"__**#{skill[0].gsub('Bladeblade','Laevatein')}**__","#{str[0][0]}#{"**Promotes into a lot of things**" if str[0].length>0}",xcolor,nil,xpic)
      else
        create_embed(event,"__**#{skill[0].gsub('Bladeblade','Laevatein')}**__",str[0],xcolor,nil,xpic)
      end
      if str[1].length+x>=1900
        str=str[1].split("\n\n")
        str2=[str[0]]
        if str[0].length>=1900 || str.length==1
          str2=str[0].split("\n**Heroes")
          str2[1]="**Heroes#{str2[1]}"
        end
        for i in 1...str.length
          str2.push(str[i])
        end
        skipfooter=false
        skipfooter=true if xfooter.nil?
        skipfooter=true if !xfooter.nil? && str2[str2.length-1].length+xfooter.length>=1900
        for i in 0...str2.length
          create_embed(event,"",str2[i],xcolor) unless i==str2.length-1 && !skipfooter
          create_embed(event,"",str2[i],xcolor,xfooter) if i==str2.length-1 && !skipfooter
        end
        event.respond xfooter if !xfooter.nil? && skipfooter
      else
        create_embed(event,"",str[1],xcolor,xfooter)
      end
    else
      create_embed(event,"__**#{skill[0].gsub('Bladeblade','Laevatein')}**__",str,xcolor,xfooter,xpic)
    end
  end
  g=get_markers(event)
  if skill[4]=="Assist" && skill[11].split(', ').include?('Music')
    w=sklz.reject{|q| !q[11].split(', ').include?('DanceRally') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| "#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}#{q[0]}#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}"}
    create_embed(event,'',"The following skills are triggered when their holder uses #{skill[0]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[4]=="Assist" && skill[11].split(', ').include?('Move') && skill[11].split(', ').include?('Rally')
    w=sklz.reject{|q| !(q[11].split(', ').include?('Link') || q[11].split(', ').include?('Feint')) || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| "#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}#{q[0]}#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}"}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[0]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[4]=="Assist" && skill[11].split(', ').include?('Move')
    w=sklz.reject{|q| !q[11].split(', ').include?('Link') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| "#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}#{q[0]}#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}"}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[0]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[4]=="Assist" && skill[11].split(', ').include?('Rally')
    w=sklz.reject{|q| !q[11].split(', ').include?('Feint') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| "#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}#{q[0]}#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}"}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[0]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif !['Weapon','Assist','Special'].include?(skill[4]) && skill[11].split(', ').include?('Link')
    w=sklz.reject{|q| q[4]!='Assist' || !q[11].split(', ').include?('Move') || q[11].split(', ').include?('Music') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| "#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}#{q[0]}#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}"}
    create_embed(event,'',"The following skills, when used on or by the unit holding #{skill[0]}, will trigger it:",0x40C0F0,nil,nil,triple_finish(w))
  elsif !['Weapon','Assist','Special'].include?(skill[4]) && skill[11].split(', ').include?('Feint')
    w=sklz.reject{|q| q[4]!='Assist' || !q[11].split(', ').include?('Rally') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| "#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}#{q[0]}#{'~~' unless q[13].nil? || q[13][0].nil? || q[13][0].length.zero?}"}
    create_embed(event,'',"The following skills, when used on or by the unit holding #{skill[0]}, will trigger it:",0x40C0F0,nil,nil,triple_finish(w))
  elsif " #{event.message.text.downcase} ".include?(' refined ') && skill[15].nil? && skill[4]=="Weapon"
    event.respond "#{skill[0].gsub('Bladeblade','Laevatein')} does not have any refinements."
    return nil
  elsif !skill[15].nil? && !((" #{event.message.text.downcase} ".include?(' default ') || " #{event.message.text.downcase} ".include?(' base ')) && !" #{event.message.text.downcase} ".include?(' refined '))
    sttz=[]
    inner_skill=skill[15]
    mt=[0,0,0,0,0]
    skill[12][1]+=1 if skill[11].split(', ').include?('Silver')
    skill[2]+=1 if skill[11].split(', ').include?('Silver')
    if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
      skill[12][1]+=inner_skill[0,1].to_i
      skill[2]+=inner_skill[0,1].to_i
      inner_skill=inner_skill[1,inner_skill.length-1]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
    elsif inner_skill[0,1]=='-' && inner_skill.length>1
      skill[12][1]-=inner_skill[1,1].to_i
      skill[2]-=inner_skill[0,1].to_i
      inner_skill=inner_skill[2,inner_skill.length-2]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
    end
    for i in 0...5
      if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
        mt[i]+=inner_skill[0,1].to_i
        inner_skill=inner_skill[1,inner_skill.length-1]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      elsif inner_skill[0,1]=='-' && inner_skill.length>1
        mt[i]-=inner_skill[1,1].to_i
        inner_skill=inner_skill[2,inner_skill.length-2]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      end
    end
    overides=[[0,0,0,0,0,0,'e'],[0,0,0,0,0,0,'a'],[0,0,0,0,0,0,'s'],[0,0,0,0,0,0,'d'],[0,0,0,0,0,0,'r']]
    overides=[[0,0,0,0,0,0,'e'],[0,0,0,0,0,0,'w'],[0,0,0,0,0,0,'d']] if skill[5]=='Staff Users Only'
    for i in 0...overides.length
      if inner_skill[0,3]=="(#{overides[i][6]})"
        inner_skill=inner_skill[3,inner_skill.length-3]
        for i2 in 0...6
          if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
            overides[i][i2]+=inner_skill[0,1].to_i
            inner_skill=inner_skill[1,inner_skill.length-1]
            inner_skill='y' if inner_skill.nil? || inner_skill.length<1
          elsif inner_skill[0,1]=='-' && inner_skill.length>1
            overides[i][i2]-=inner_skill[1,1].to_i
            inner_skill=inner_skill[2,inner_skill.length-2]
            inner_skill='y' if inner_skill.nil? || inner_skill.length<1
          end
        end
      end
    end
    overides[0][6]='Effect'
    if skill[5]=='Staff Users Only'
      overides[1][6]='Wrathful'
      overides[2][6]='Dazzling'
    else
      overides[1][6]='Attack'
      overides[2][6]='Speed'
      overides[3][6]='Defense'
      overides[4][6]='Resistance'
    end
    outer_skill=nil
    if inner_skill[0,1]=='*'
      outer_skill=inner_skill[1,inner_skill.length-1]
      inner_skill='y'
    elsif inner_skill.include?(' ** ')
      x=inner_skill.split(' ** ')
      inner_skill=x[0]
      outer_skill=x[1]
    end
    debuff=nil
    buff=nil
    if skill[7].is_a?(Array)
      debuff=skill[7][1] unless skill[7][1].nil?
      buff=skill[7][2] unless skill[7][2].nil?
      skill[7]=skill[7][0]
    end
    if outer_skill.nil?
    elsif outer_skill.include?(' *** ')
      x=outer_skill.split(' *** ')
      debuff=x[1] unless x[1].nil?
      buff=x[2] unless x[2].nil?
      outer_skill=x[0]
      outer_skill=nil if outer_skill==' ' || outer_skill.length<=0
    end
    if skill[6]=='Nebby'
      inner_skill=inner_skill.split('  ')
      sttz.push([3,0,0,0,0,'Full Metal',inner_skill[0]])
      sttz.push([3,0,0,0,0,'Shadow',inner_skill[1]])
      inner_skill=''
    elsif inner_skill.length>1
      zzz=[skill[0],3,0,0,0,0]
      zzz=[skill[0],0,0,0,0,0] if skill[5].include?('Tome Users Only') || ['Staff Users Only','Bow Users Only','Dagger Users Only'].include?(skill[5])
      if find_effect_name(skill,event).length>0
        zzz2=find_effect_name(skill,event,1)
        lookout=[]
        if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
          lookout=[]
          File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
            lookout.push(eval line)
          end
          lookout=lookout.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}
        end
        zzz=apply_stat_skills(event,[find_effect_name(skill,event,1)],zzz,'','-','','',[],false,true) if lookout.map{|q| q[0]}.include?(zzz2)
      end
      skill[12][10]=zzz[2]
      sttz.push([zzz[1],0,zzz[3],zzz[4],zzz[5],'Effect'])
    elsif skill[0]=='Missiletainn'
      sk1=sklz[find_skill('Missiletainn (Dark)',event,true,true)]
      sk2=sklz[find_skill('Missiletainn (Dusk)',event,true,true)]
      refinements=[]
      refinements.push(['Dark',sk1[15],nil,0]) unless sk1[15].nil?
      refinements.push(['Dusk',sk2[15],nil,0]) unless sk2[15].nil?
      for i in 0...refinements.length
        if refinements[i][1][0,1].to_i.to_s==refinements[i][1][0,1]
          refinements[i][3]+=refinements[i][1][0,1].to_i
          refinements[i][1]=refinements[i][1,refinements[i][1].length-1]
          refinements[i][1]=nil if refinements[i][1].nil? || refinements[i][1].length<1
        elsif refinements[i][1][0,1]=='-' && refinements[i][1].length>1
          refinements[i][3]-=refinements[i][1][1,1].to_i
          refinements[i][1]=refinements[i][1][2,refinements[i][1].length-2]
          refinements[i][1]=nil if refinements[i][1].nil? || refinements[i][1].length<1
        end
        if refinements[i][1][0,1]=='*'
          refinements[i][2]=refinements[i][1][1,refinements[i][1].length-1]
          refinements[i][1]=nil
        elsif refinements[i][1].include?(' ** ')
          x=refinements[i][1].split(' ** ')
          refinements[i][1]=x[0]
          refinements[i][2]=x[1]
        end
      end
      if refinements[0][2]==refinements[1][2]
        outer_skill=refinements[0][2]
      elsif !refinements[0][1].nil? || !refinements[1][1].nil? || !refinements[2][1].nil?
        sksk=[]
        sksk.push("*Dark:* #{refinements[0][1]}") unless refinements[0][1].nil?
        sksk.push("*Dusk:* #{refinements[1][1]}") unless refinements[1][1].nil?
        for i in 0...refinements.length
          refinements[i][1]="#{refinements[i][1]}\n#{refinements[i][2]}" unless refinements[i][2].nil?
        end
        outer_skill=sksk.join("\n")
      end
      sttz.push([3,refinements[0][3],0,0,0,"**Missiletainn(Dark) (+) Effect Mode**#{" - #{find_effect_name(sk1,event)}" unless find_effect_name(sk1,event).length<=0}",refinements[0][1]]) unless refinements[0][1].nil?
      sttz.push([3,refinements[1][3],0,0,0,"**Missiletainn(Dark) (+) Effect Mode**#{" - #{find_effect_name(sk2,event)}" unless find_effect_name(sk2,event).length<=0}",refinements[1][1]]) unless refinements[1][1].nil?
    elsif skill[0]=='Falchion'
      sk1=sklz[find_skill('Falchion (Mystery)',event,true,true)]
      sk2=sklz[find_skill('Falchion (Valentia)',event,true,true)]
      sk3=sklz[find_skill('Falchion (Awakening)',event,true,true)]
      refinements=[]
      refinements.push(['Mystery',sk1[15],nil,0]) unless sk1[15].nil?
      refinements.push(['Echoes',sk2[15],nil,0]) unless sk2[15].nil?
      refinements.push(['Awakening',sk3[15],nil,0]) unless sk3[15].nil?
      for i in 0...refinements.length
        if refinements[i][1][0,1].to_i.to_s==refinements[i][1][0,1]
          refinements[i][3]+=refinements[i][1][0,1].to_i
          refinements[i][1]=refinements[i][1,refinements[i][1].length-1]
          refinements[i][1]=nil if refinements[i][1].nil? || refinements[i][1].length<1
        elsif refinements[i][1][0,1]=='-' && refinements[i][1].length>1
          refinements[i][3]-=refinements[i][1][1,1].to_i
          refinements[i][1]=refinements[i][1][2,refinements[i][1].length-2]
          refinements[i][1]=nil if refinements[i][1].nil? || refinements[i][1].length<1
        end
        if refinements[i][1][0,1]=='*'
          refinements[i][2]=refinements[i][1][1,refinements[i][1].length-1]
          refinements[i][1]=nil
        elsif refinements[i][1].include?(' ** ')
          x=refinements[i][1].split(' ** ')
          refinements[i][1]=x[0]
          refinements[i][2]=x[1]
        end
      end
      if refinements[0][2]==refinements[1][2] && refinements[0][2]==refinements[2][2]
        outer_skill=refinements[0][2]
      elsif refinements[0][1]==refinements[1][1]
        outer_skill="#{"*Mystery, Echoes:* #{refinements[0][2]}" unless refinements[0][2].nil?}#{"\n" unless refinements[0][2].nil? || refinements[2][2].nil?}#{"*Awakening:* #{refinements[2][2]}" unless refinements[2][2].nil?}"
      elsif refinements[0][1]==refinements[2][1]
        outer_skill="#{"*Mystery, Awakening:* #{refinements[0][2]}" unless refinements[0][2].nil?}#{"\n" unless refinements[0][2].nil? || refinements[1][2].nil?}#{"*Echoes:* #{refinements[1][2]}" unless refinements[1][2].nil?}"
      elsif refinements[1][1]==refinements[2][1]
        outer_skill="#{"*Mystery:* #{refinements[0][2]}" unless refinements[0][2].nil?}#{"\n" unless refinements[0][2].nil? || refinements[2][2].nil?}#{"*Echoes, Awakening:* #{refinements[2][2]}" unless refinements[2][2].nil?}"
      elsif !refinements[0][1].nil? || !refinements[1][1].nil? || !refinements[2][1].nil?
        sksk=[]
        sksk.push("*Mystery:* #{refinements[0][1]}") unless refinements[0][1].nil?
        sksk.push("*Echoes:* #{refinements[1][1]}") unless refinements[1][1].nil?
        sksk.push("*Awakening:* #{refinements[2][1]}") unless refinements[2][1].nil?
        for i in 0...refinements.length
          refinements[i][1]="#{refinements[i][1]}\n#{refinements[i][2]}" unless refinements[i][2].nil?
        end
        outer_skill=sksk.join("\n")
      end
      sttz.push([3,refinements[0][3],0,0,0,"**Falchion(Mystery) (+) Effect Mode**#{" - #{find_effect_name(sk1,event)}" unless find_effect_name(sk1,event).length<=0}",refinements[0][1]]) unless refinements[0][1].nil?
      sttz.push([3,refinements[1][3],0,0,0,"**Falchion(Valentia) (+) Effect Mode**#{" - #{find_effect_name(sk2,event)}" unless find_effect_name(sk2,event).length<=0}",refinements[1][1]]) unless refinements[1][1].nil?
      sttz.push([3,refinements[2][3],0,0,0,"**Falchion(Awakening) (+) Effect Mode**#{" - #{find_effect_name(sk3,event)}" unless find_effect_name(sk3,event).length<=0}",refinements[2][1]]) unless refinements[2][1].nil?
    end
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Strength.png'
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Magic.png' if skill[5].include?('Tome Users Only') || skill[5]=='Dragons Only'
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Freeze.png' if skill[11].split(', ').include?('Frostbite') || skill[11].split(', ').include?('(R)Frostbite')
    if skill[5]=='Staff Users Only' && (skill[7].include?("This weapon's damage is calculated the same as other weapons.") || skill[7].include?('Damage from staff calculated like other weapons.'))
      xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Dazzling_W.png'
      sttzx=[[0,0,0,0,0,'Dazzling','The foe cannot counterattack.']]
    elsif skill[5]=='Staff Users Only' && (skill[7].include?('The foe cannot counterattack.') || skill[7].include?('Foe cannot counterattack.'))
      xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Wrathful_W.png'
      sttzx=[[0,0,0,0,0,'Wrathful',"This weapon's damage is calculated the same as other weapons."]]
    elsif skill[5]=='Staff Users Only'
      xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Staff_Default_Refine.png'
      sttzx=[[0,0,0,0,0,'Wrathful',"This weapon's damage is calculated the same as other weapons."],[0,0,0,0,0,'Dazzling','The foe cannot counterattack.']]
    elsif skill[5].include?('Tome Users Only') || ['Bow Users Only','Dagger Users Only'].include?(skill[5])
      sttzx=[[2,1,0,0,0,'Attack'],[2,0,2,0,0,'Speed'],[2,0,0,3,0,'Defense'],[2,0,0,0,3,'Resistance']]
    else
      sttzx=[[5,2,0,0,0,'Attack'],[5,0,3,0,0,'Speed'],[5,0,0,4,0,'Defense'],[5,0,0,0,4,'Resistance']]
    end
    for i in 0...sttzx.length
      sttz.push(sttzx[i])
    end
    for i in 0...sttz.length
      sttz[i][0]+=mt[0]
      sttz[i][2]+=mt[2]
      sttz[i][3]+=mt[3]
      sttz[i][4]+=mt[4]
    end
    str=''
    for i in 0...sttz.length
      k=sttz[i][5].split(' (+) ')
      k=k[k.length-1].gsub(' Mode','')
      k=k.split('**')[0]
      k='Effect' if ['Full Metal','Shadow'].include?(k)
      k2=overides[overides.find_index{|q| q[6]==k}]
      emo='<:EffectMode:450002917269831701>'
      if k=='Attack'
        emo='<:StrengthW:449999580948463617>'
        emo='<:MagicW:449999580835086337>' if skill[5].include?('Tome Users Only') || skill[5]=='Dragons Only' || skill[5]=='Staff Users Only'
        emo='<:FreezeW:449999580864708618>' if skill[11].split(', ').include?('Frostbite') || skill[11].split(', ').include?('(R)Frostbite')
      end
      emo='<:SpeedW:449999580868640798>' if k=='Speed'
      emo='<:DefenseW:449999580793274408>' if k=='Defense'
      emo='<:ResistanceW:449999580864446514>' if k=='Resistance'
      emo='<:Wrathful:449999580650668033>' if k=='Wrathful'
      emo='<:Dazzling:449999580411592705>' if k=='Dazzling'
      if sttz[i][5].include?('(+)')
        str="#{str}\n\n#{emo} #{sttz[i][5]}"
      else
        str="#{str}\n\n#{emo} **#{skill[0]} (+) #{sttz[i][5]} Mode**"
      end
      if sttz[i][5]=='Effect' && find_effect_name(skill,event).length>0
        xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/#{find_effect_name(skill,event,2).gsub(' ','_').gsub('/','_')}.png"
        str="#{str} - #{find_effect_name(skill,event)}"
      end
      str="#{str}\nMight: #{skill[2]+sttz[i][1]+k2[0]}  \u200B  \u200B  \u200B  Range: #{skill[3]}"
      str="#{str}  \u200B  \u200B  \u200B  HP +#{sttz[i][0]+k2[1]}" if sttz[i][0]+k2[1]>0
      atk=mt[1]+k2[2]
      atk+=skill[12][10] if sttz[i][5]=="Effect"
      str="#{str}  \u200B  \u200B  \u200B  Attack #{'+' if atk>0}#{atk}" if atk != 0
      str="#{str}  \u200B  \u200B  \u200B  Speed #{'+' if skill[12][2]+sttz[i][2]+k2[3]>0}#{skill[12][2]+sttz[i][2]+k2[3]}" if skill[12][2]+sttz[i][2]+k2[3]!=0
      str="#{str}  \u200B  \u200B  \u200B  Defense #{'+' if skill[12][3]+sttz[i][3]+k2[4]>0}#{skill[12][3]+sttz[i][3]+k2[4]}" if skill[12][3]+sttz[i][3]+k2[4]!=0
      str="#{str}  \u200B  \u200B  \u200B  Resistance #{'+' if skill[12][4]+sttz[i][4]+k2[5]>0}#{skill[12][4]+sttz[i][4]+k2[5]}" if skill[12][4]+sttz[i][4]+k2[5]!=0
      effective=[]
      effective.push('<:Icon_Move_Flier:443331186698354698>') if skill[5]=="Bow Users Only"
      for i2 in 0...lookout2.length
        effective.push(lookout2[i2][3]) if skill[11].split(', ').include?(lookout2[i2][0])
        effective.push(lookout2[i2][3]) if skill[11].split(', ').include?("(R)#{lookout2[i2][0]}")
        effective.push(lookout2[i2][3]) if sttz[i][5]=="Effect" && skill[11].split(', ').include?("(E)#{lookout2[i2][0]}")
      end
      str="#{str}\n*Effective against*: #{effective.join('')}" if effective.length>0
      unless debuff.nil?
        d=debuff.split(', ')
        str="#{str}\n*Debuff*:  \u200B  \u200B  \u200B  Effect: #{d[0,d.length-1].join(', ')}  \u200B  \u200B  \u200B  Affects: #{d[d.length-1]}"
      end
      if outer_skill.nil? || !sttz[i][7].nil?
        str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{skill[7]}" unless skill[7]=='-'
      else
        str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{outer_skill}"
      end
      str="#{str}\nIf foe's Range = 2, damage calculated using the lower of foe's Def or Res." if skill[11].split(', ').include?("(R)Frostbite") || (sttz[i][5]=="Effect" && skill[11].split(', ').include?("(E)Frostbite"))
      str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{sttz[i][6]}" unless sttz[i][6].nil?
      str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{inner_skill}" if inner_skill.length>1 && sttz[i][5]=="Effect"
    end
    ftr='All refinements cost: 350 SP (525 if inherited), 500<:Arena_Medal:453618312446738472> 50<:Refining_Stone:453618312165720086>'
    ftr='All refinements cost: 400 SP, 500<:Arena_Medal:453618312446738472> 200<:Divine_Dew:453618312434417691>' if skill[6]!='-'
    str="#{str}\n\n#{ftr}"
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Falchion_Refines.png' if skill[0]=='Falchion'
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Missiletainn_Refines.png' if skill[0]=='Missiletainn'
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Adult_Refines.png' if skill[0]=='Adult (All)'
    str=str.split("\n\n")
    str.shift if str[0].nil? || str[0].length.zero?
    str1=[]
    str2=[]
    str3=[]
    for i in 0...str.length
      if str[i].include?('All refinements cost:')
        str3.push(str[i])
      elsif str[i].include?(' (+) Dazzling Mode') || str[i].include?(' (+) Wrathful Mode')
        str[i]=str[i].split("\n")
        str2.push("#{str[i][0].gsub("#{skill[0]} (+) ",'')} - #{str[i][str[i].length-1]}")
        str3.push("<:Refine_Unknown:455609031701299220>**All Default Refinements**\n#{str[i][1,str[i].length-2].join("\n")}") unless str[i].length<=2 || str3.length>0
      elsif str[i].include?(' (+) Attack Mode') || str[i].include?(' (+) Speed Mode') || str[i].include?(' (+) Defense Mode') || str[i].include?(' (+) Resistance Mode')
        str[i]=str[i].split("\n")
        str2.push("#{str[i][0].gsub("#{skill[0]} (+) ",'')} - #{str[i][1]}")
        str3.push("<:Refine_Unknown:455609031701299220>**All Stat Refinements**\n#{str[i][2,str[i].length-2].join("\n")}") unless str[i].length<=2 || str3.length>0
      else
        str1.push(str[i])
      end
    end
    str=[str1.join("\n\n"),"#{str2.join("\n")}\n\n#{str3.join("\n\n")}"]
    str.shift if str[0].length<=0
    str=["#{str[0]}\n\n#{str[1]}"] if str.length>1 && str[0].length+str[1].length<1900
    for i in 0...str.length
      create_embed(event,'__**Refinery Options**__',str[i],0x688C68,nil,xpic) if i==0
      create_embed(event,'',str[i],0x688C68) unless i==0
    end
  end
end

def unit_skills(name,event,justdefault=false,r=0,ignoretro=false,justweapon=false)
  data_load()
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  if name.nil? || name.length.zero?
    str=find_name_in_string(event)
    char=@units[find_unit(str,event)]
  else
    char=@units[find_unit(name,event)]
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  rarity=flurp[0]
  rarity=r unless r<1 || r>@max_rarity_merge[0]
  rarity=5 if rarity.nil?
  sklz=[[],[],[],[],[],[]]
  box=[[],[],[],[],[],[]]
  clss="#{char[1][0]} #{char[1][1]}"
  clss="#{char[1][1]}" if char[1][0]=='Colorless' || char[1][1]=='Bow' || char[1][1]=='Dagger'
  clss="#{char[1][2]} Tome" if clss=='Red Tome' || clss=='Blue Tome' || clss=='Green Tome'
  clss='Staff' if clss=='Healer'
  if char[1][1]=='Blade'
    clss='Sword' if char[1][0]=='Red'
    clss='Lance' if char[1][0]=='Blue'
    clss='Axe' if char[1][0]=='Green'
  end
  clss="#{clss} Users"
  clss='Dragons' if char[1][1]=='Dragon'
  clss='Beasts' if char[1][1]=='Beast'
  retroprf=[]
  skllz=@skills.map{|q| q}
  skllz=skllz.reject{|q| !q[10].map{|q2| q2.split(', ').include?(char[0]) || q2.split(', ').include?("All #{clss}")}.include?(true)}
  skllz=skllz.reject{|q| q[4]!='Weapon'} if justweapon
  for i in 0...skllz.length
    for j in 0...rarity
      if skllz[i][9][j].split(', ').include?(char[0]) || skllz[i][9][j]=="All #{clss}"
        box[0].push(skllz[i]) if skllz[i][4]=='Weapon'
        box[1].push(skllz[i]) if skllz[i][4]=='Assist'
        box[2].push(skllz[i]) if skllz[i][4]=='Special'
        box[3].push(skllz[i]) if skllz[i][4].include?('Passive(A)')
        box[4].push(skllz[i]) if skllz[i][4].include?('Passive(B)')
        box[5].push(skllz[i]) if skllz[i][4].include?('Passive(C)')
      end
    end
    for j in 0...rarity
      if skllz[i][10][j].split(', ').include?(char[0]) || skllz[i][10][j]=="All #{clss}"
        sklz[0].push(skllz[i]) if skllz[i][4]=='Weapon'
        sklz[1].push(skllz[i]) if skllz[i][4]=='Assist'
        sklz[2].push(skllz[i]) if skllz[i][4]=='Special'
        sklz[3].push(skllz[i]) if skllz[i][4].include?('Passive(A)')
        sklz[4].push(skllz[i]) if skllz[i][4].include?('Passive(B)')
        sklz[5].push(skllz[i]) if skllz[i][4].include?('Passive(C)')
      elsif skllz[i][10][j].split(', ').include?("[Retro]#{char[0]}") || skllz[i][10][j].split(', ').include?("#{char[0]}[Retro]") || skllz[i][10][j].split(', ').include?("[Retro] #{char[0]}") || skllz[i][10][j].split(', ').include?("#{char[0]} [Retro]")
        retroprf.push(skllz[i][0])
      end
    end
    if skllz[i][6].split(', ').include?(char[0]) && rarity>5
      sklz[0].push(skllz[i]) if skllz[i][4]=='Weapon'
      sklz[1].push(skllz[i]) if skllz[i][4]=='Assist'
      sklz[2].push(skllz[i]) if skllz[i][4]=='Special'
      sklz[3].push(skllz[i]) if skllz[i][4].include?('Passive(A)')
      sklz[4].push(skllz[i]) if skllz[i][4].include?('Passive(B)')
      sklz[5].push(skllz[i]) if skllz[i][4].include?('Passive(C)')
      box[0].push(skllz[i]) if skllz[i][4]=='Weapon'
      box[1].push(skllz[i]) if skllz[i][4]=='Assist'
      box[2].push(skllz[i]) if skllz[i][4]=='Special'
    end
  end
  sklz=sklz.map{|q| q.uniq}
  box=box.map{|q| q.uniq}
  box2=[[],[],[],[],[],[]]
  sklz2=[[],[],[],[],[],[]]
  for i in 0...6
    for j in 0...box[i].length
      box2[i].push(box[i][j][0]) if box[i][j][8]=='-'
    end
    for j in 0...sklz[i].length
      sklz2[i].push(sklz[i][j][0]) if sklz[i][j][8]=='-' && !(i.zero? && sklz[i][j][6]!='-')
      retroprf.push(sklz[i][j][0]) if sklz[i][j][8]=='-' && i.zero? && sklz[i][j][6]!='-'
    end
  end
  for i in 0...retroprf.length
    retroprf[i]="**#{retroprf[i]}**" if box2[0].include?(retroprf[i])
  end
  for k in 0...7
    for i in 0...6
      for j in 0...box[i].length
        box2[i].push(box[i][j][0].gsub('Bladeblade','Laevatein')) if box[i][j][8].include?("*#{box2[i][k]}*")
      end
      for j in 0...sklz[i].length
        sklz2[i].push(sklz[i][j][0].gsub('Bladeblade','Laevatein')) if sklz[i][j][8].include?("*#{sklz2[i][k]}*")
      end
    end
  end
  for i in 0...6
    if box[i].length>0 && box2[i].length.zero?
      box2[i].push('~~Unknown base~~')
      for j in 0...box[i].length
        box2[i].push(box[i][j][0].gsub('Bladeblade','Laevatein')) if box[i][j][8].include?('* or *') || box[i][j][8].include?('*, *')
      end
      for k in 0...3
        for j in 0...box[i].length
          box2[i].push(box[i][j][0].gsub('Bladeblade','Laevatein')) if box[i][j][8].include?("*#{box2[i][box2[i].length-1]}*")
        end
      end
    end
    if sklz[i].length>0 && sklz2[i].length.zero?
      sklz2[i].push('~~Unknown base~~')
      for j in 0...sklz[i].length
        sklz2[i].push(sklz[i][j][0].gsub('Bladeblade','Laevatein')) if sklz[i][j][8].include?('* or *') || sklz[i][j][8].include?('*, *')
      end
      for k in 0...3
        for j in 0...sklz[i].length
          sklz2[i].push(sklz[i][j][0].gsub('Bladeblade','Laevatein')) if sklz[i][j][8].include?("*#{sklz2[i][sklz2[i].length-1]}*")
        end
      end
    end
  end
  for i in 0...6
    box2[i].uniq!
    sklz2[i].uniq!
  end
  if char[12].split(', ')[0].gsub('*','')=='Hector' && !justweapon
    if sklz2[0].length<3
      sklz2[0].push('Silver Axe') if rarity==3
      sklz2[0].push('**Silver Axe**') if rarity>3
    end
    sklz2[0].push('Some variation on **Armads**') if sklz2[0].length<4 && rarity>4
    sklz2[3].push('Distant Counter') if sklz2[3].length.zero? && (sklz2[4].length.zero? || sklz2[5].length.zero?) && rarity>4
  end
  if justdefault
    for i in 0...6
      sklz2[i]=['~~none~~'] if sklz2[i].length.zero?
      for j in 0...sklz2[i].length
        sklz2[i][j]="~~#{sklz2[i][j]}~~" unless box2[i].include?(sklz2[i][j]) || sklz2[i][j].include?('~~')
      end
    end
  else
    for i in 0...6
      sklz2[i]=['~~none~~'] if sklz2[i].length.zero?
      for j in 0...sklz2[i].length
        sklz2[i][j]="**#{sklz2[i][j]}**" if box2[i].include?(sklz2[i][j])
      end
    end
    s=@skills[find_skill(sklz2[0][sklz2[0].length-1].gsub('**',''),event)]
    if !s[14].nil? && s[14].length>0 && s[4]=='Weapon'
      s2=s[14].split(', ')
      for i in 0...s2.length
        if s2[i].include?('!')
          s3=s2[i].split('!')
          sklz2[0].push("~~#{s3[1]}~~") if s3[0]==name && find_skill(s3[1],event,false,true)>-1
        else
          sklz2[0].push("~~#{s2[i]}~~") if find_skill(s2[i],event,false,true)>-1
        end
      end
    end
    if retroprf.length>0
      for i in 0...retroprf.length
        if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
          sklz2[0].push('    ')
        elsif !ignoretro
          sklz2[0][sklz2[0].length-1]="__#{sklz2[0][sklz2[0].length-1]}__"
        end
        sklz2[0].push(retroprf[i])
        s=@skills[find_skill(sklz2[0][sklz2[0].length-1].gsub('**',''),event)]
        if !s[14].nil? && s[14].length>0 && s[4]=='Weapon'
          s2=s[14].split(', ')
          for i in 0...s2.length
            if s2[i].include?('!')
              s3=s2[i].split('!')
              sklz2[0].push("~~#{s3[1]}~~") if s3[0]==name && find_skill(s3[1],event,false,true)>-1
            else
              sklz2[0].push("~~#{s2[i]}~~") if find_skill(s2[i],event,false,true)>-1
            end
          end
        end
      end
    end
  end
  unless r>0
    if " #{event.message.text.downcase} ".include?(' weaponless ') || (" #{event.message.text.downcase} ".include?(' zelgius ') && name.downcase != 'zelgius') || " #{event.message.text.downcase} ".include?(' zelgiused ') || " #{event.message.text.downcase} ".include?(" zelgius'd ")
      sklz2[0]=['~~none~~']
      s=@skills[find_skill(sklz2[1][sklz2[1].length-1].gsub('**','').gsub('~~',''),event)]
      if !s.nil? && s[6]!='-'
        sklz2[1].pop
        sklz2[1]=['~~none~~'] if sklz2[1].length<=0
      end
      s=@skills[find_skill(sklz2[2][sklz2[2].length-1].gsub('**','').gsub('~~',''),event)]
      if !s.nil? && s[6]!='-'
        sklz2[2].pop
        sklz2[2]=['~~none~~'] if sklz2[2].length<=0
      end
    end
  end
  return sklz2
end

def disp_unit_skills(bot,name,event,chain=false,doubleunit=false)
  name=['Robin(M)','Robin(F)'] if name=='Robin'
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      disp_unit_skills(bot,name[i],event,chain,(name.length>1))
    end
    return nil
  end
  n=find_name_in_string(event)
  if n=='Kiran'
    sklz2=[['**Breidablik**','~~Chill Breidablik~~'],['~~none~~'],['~~none~~'],['~~none~~'],['~~none~~'],['~~none~~']]
  else
    sklz2=unit_skills(name,event)
  end
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  if name.nil? || name.length.zero?
    str=find_name_in_string(event)
    char=@units[find_unit(str,event)]
  else
    char=@units[find_unit(name,event)]
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  rarity=flurp[0]
  j=find_unit(find_name_in_string(event),event)
  j=find_unit(name,event) unless name.nil? || name.length.zero?
  mu=false
  txt="#{@rarity_stars[rarity.to_i-1]*rarity.to_i}"
  ftrtoggles=[false,false,false]
  sklz2[0]=sklz2[0].reject {|a| ['Falchion','**Falchion**','Missiletainn','**Missiletainn**','Adult (All)','**Adult (All)**'].include?(a)}
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    namehere=str
    namehere=name unless name.nil? || name.length.zero?
    dv=find_in_dev_units(namehere)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1]
      txt=display_stars(event,rarity,@dev_units[dv][2],@dev_units[dv][5]).split('  ')[0]
      sklz2=[@dev_units[dv][6],@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],[@dev_units[dv][12]]]
    elsif @dev_nobodies.include?(@units[j][0])
      event.respond "Mathoo has this character but doesn't care enough about including their skills.  Showing default skills." unless chain
    elsif @dev_waifus.include?(@units[j][0]) || @dev_somebodies.include?(@units[j][0])
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing default skills.' unless chain
    else
      event.respond 'Mathoo does not have that character.  Showing default skills.' unless chain
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1]
      txt=display_stars(event,rarity,x[x2][2],x[x2][5]).split('  ')[0]
      sklz2=[x[x2][6],x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],[x[x2][12]]]
    end
  else
    untz=@units.map{|q| q}
    sklz=@skills.map{|q| q}
    for mmm in 0...6
      unless sklz2[mmm][0]=='~~none~~'
        for i in 0...sklz2[mmm].length
          tmp=sklz2[mmm][i].gsub('~~','').gsub('*','').gsub('__','')
          unless tmp.downcase=='unknown base'
            tmp2=sklz[sklz.find_index{|q| q[0].gsub('Bladeblade','Laevatein')==tmp}]
            if tmp2[6]!='-' && tmp2[6].split(', ').include?(@units[j][0])
              sklz2[mmm][i]="#{sklz2[mmm][i]}<:Prf_Sparkle:490307608973148180>"
              ftrtoggles[0]=true
            elsif !@units[j][13][0].nil?
            else
              tmtmp=tmp2[10].reject{|q| q=='-' || q[0,4]=='All '}.join(', ').split(', ').reject{|q| untz[untz.find_index{|q2| q2[0]==q}][13][0]!=nil}
              if tmp2[4]=='Weapon' && tmtmp.length>0 && find_prevolutions(@skills.find_index{|q| q[0]==tmp2[0]},event).length>0
                kxd=find_prevolutions(@skills.find_index{|q| q[0]==tmp2[0]},event)
                for i2 in 0...kxd.length
                  tmtmp2=kxd[i2][0][10].reject{|q| q=='-' || q[0,4]=='All '}.join(', ').split(', ').reject{|q| untz[untz.find_index{|q2| q2[0]==q}][13][0]!=nil}
                  tmtmp="#{tmtmp.join(', ')}, #{tmtmp2.join(', ')}".split(', ')
                end
              end
              if tmtmp.length==0 && sklz2[mmm][i-1].include?('<')
                tmtmp2=tmp2[10].reject{|q| q=='-'}.join(', ').split(', ')
                for i2 in 0...tmtmp2.length
                  if tmtmp2[i2][0,4]=='All '
                  elsif untz[untz.find_index{|q2| q2[0]==tmtmp2[i2]}][13][0]!=nil
                    tmtmp2[i2]=nil
                  end
                end
                tmtmp2.compact!
                sklz2[mmm][i]="#{sklz2[mmm][i]}<#{sklz2[mmm][i-1].split('<')[1].gsub("  \u200B  ",'')}" if tmtmp2.length==0
              elsif tmtmp.length==0
              elsif tmtmp[0]==@units[j][0] && tmtmp.length==1
                sklz2[mmm][i]="#{sklz2[mmm][i]}<:Arena_Crown:490334177124810772>"
                ftrtoggles[1]=true
              else
                tmtmp=tmtmp.reject{|q| !untz[untz.find_index{|q2| q2[0]==q}][9][0].include?('p')}
                if tmtmp[0]==@units[j][0] && tmtmp.length==1
                  sklz2[mmm][i]="#{sklz2[mmm][i]}<:Orb_Rainbow:471001777622351872>"
                  ftrtoggles[2]=true
                end
              end
            end
            tmp=tmp2[10]
            moji=''
            for i2 in 0...tmp.length
              if tmp[i2].split(', ').include?(@units[j][0]) || (!tmp[i2].include?(', ') && tmp[i2][0,4]=='All ')
                moji="#{moji}#{@rarity_stars[i2]}"
              end
            end
            sklz2[mmm][i]="#{sklz2[mmm][i]}  \u200B  #{moji}" if moji.length>0
          end
        end
      end
    end
  end
  xcolor=unit_color(event,j,@units[j][0],0,mu,chain)
  f=chain
  f=false if doubleunit
  txt="#{txt}\n#{unit_clss(bot,event,j)}\n"
  txt=' ' if f
  ftr=nil
  ftr='Purple sparkles mark skills Prf to this unit.' if ftrtoggles[0]
  ftr='Crowns mark inheritable skills only this unit has.' if ftrtoggles[1]
  ftr='Purple sparkles mark Prf skills.  Crowns mark unique inheritable skills.' if ftrtoggles[0] && ftrtoggles[1]
  ftr='Orbs mark inheritable skills that within the main summon pool, only this unit has.' if ftrtoggles[2]
  ftr='Purple sparkles mark Prf skills.  Orbs mark semi-unique inheritable skills.' if ftrtoggles[0] && ftrtoggles[2]
  ftr='Unique inheritable skills:  Crown = overall,   Orb = within main summon pool.' if ftrtoggles[1] && ftrtoggles[2]
  ftr='"Pandering to the minority gets you nowhere." - Shylock#2166' if event.user.id==198201016984797184
  flds=[["<:Skill_Weapon:444078171114045450> **Weapons**",sklz2[0].join("\n")],["<:Skill_Assist:444078171025965066> **Assists**",sklz2[1].join("\n")],["<:Skill_Special:444078170665254929> **Specials**",sklz2[2].join("\n")],["<:Passive_A:443677024192823327> **A Passives**",sklz2[3].join("\n")],["<:Passive_B:443677023257493506> **B Passives**",sklz2[4].join("\n")],["<:Passive_C:443677023555026954> **C Passives**",sklz2[5].join("\n")]]
  flds.push(["<:Passive_S:443677023626330122> **Sacred Seal**",sklz2[6][0]]) unless sklz2[6].nil? || sklz2[6][0].length.zero? || sklz2[6][0]==" "
  create_embed(event,"#{"__#{"Mathoo's " if mu}**#{@units[j][0].gsub('Lavatain','Laevatein')}**__" unless f}",txt,xcolor,ftr,pick_thumbnail(event,j,bot),flds)
end

def disp_struct(bot,name,event,ignore=false)
  data_load()
  bonus_load()
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
  b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  a=s.split(' ').reject{ |q| q.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=s.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  k=find_structure_ex(args.join(' '),event)
  if k.length<=0
    event.respond 'No matches found.' unless ignore
    return nil
  end
  k=k.map{|q| @structures[q]}
  xcolor=0x54C571
  text=''
  x2='Effect'
  if k[0][2]=='Offensive/Defensive'
    xcolor=0x8CAA7B
    text="<:Offensive_Structure:510774545997758464><:Defensive_Structure:510774545108566016>**Type:** Offensive/Defensive"
  elsif k[0][2]=='Offensive'
    xcolor=0xF0631E
    text="<:Offensive_Structure:510774545997758464>**Type:** Offensive"
  elsif k[0][2]=='Defensive'
    xcolor=0x27F2D8
    text="<:Defensive_Structure:510774545108566016>**Type:** Defensive"
  elsif k[0][2]=='Trap'
    xcolor=0xB950E9
    text="<:Trap_Structure:510774545179869194>**Type:** Trap"
  elsif k[0][2]=='Resources'
    xcolor=0xD3DADC
    text="<:Resource_Structure:510774545154572298>**Type:** Resource"
  elsif k[0][2]=='Ornament'
    xcolor=0xFEE257
    text="<:Ornamental_Structure:510774545150640128>**Type:** Ornament"
    x2='Description'
  else
    text="**Type:** Unknown"
  end
  text="#{text}\n**#{x2}:** #{k[0][3]}" if k.map{|q| q[3]}.uniq.length<2
  text="#{text}\n**This structure is currently a bonus structure for both Offense and Defense**" if b[0][3][0]==k[0][0] && b[0][3][1]==k[0][0]
  text="#{text}\n**This structure is currently a bonus structure for both Offense**" if b[0][3][0]==k[0][0] && b[0][3][1]!=k[0][0]
  text="#{text}\n**This structure is currently a bonus structure for both Defense**" if b[0][3][0]!=k[0][0] && b[0][3][1]==k[0][0]
  if k.length>1
    for i in 0...k.length
      x=' '
      x="\n" if k.map{|q| q[3]}.uniq.length>1 || k.map{|q| q[4]}.uniq.length>1 || k.map{|q| q[7]}.uniq.length>1
      text="#{text}\n" if k.map{|q| q[3]}.uniq.length>1 || k.map{|q| q[4]}.uniq.length>1 || k.map{|q| q[7]}.uniq.length>1 || i.zero?
      text="#{text}\n**Level #{k[i][1]}:**"
      text="#{text}#{x}*Cost:* "
      text="#{text}#{k[i][5][0]}<:Aether_Stone:510776805746278421>" if k[i][5][0]>0
      text="#{text}#{k[i][5][1]}<:Heavenly_Dew:510776806396395530>" if k[i][5][1]>0
      text="#{text}#{k[i][5][2]}<:Aether_Stone_SP:513982883560423425>" if k[i][5][2]>0
      text="#{text} (Requires reaching AR Tier #{k[i][6]})" if k[i][6]>0
      text="#{text}~~nothing~~" if k[i][6]<=0 && k[i][5].max<=0
      text="#{text}\n*#{x2}:* #{k[i][3]}" unless k.map{|q| q[3]}.uniq.length<2
      unless k.map{|q| q[4]}.uniq.length<2
        if ['yes','no'].include?(k[i][4].downcase)
          text="#{text}\n*Destructible?:* #{k[i][4]}"
        elsif k[0][2]=='Trap'
          text="#{text}\n*Traps are triggered by standing on them*"
        else
          text="#{text}\n*Destructible?:* #{k[i][4]}"
        end
      end
      text="#{text}\n*Additional Note:* #{k[i][7]}" unless k.map{|q| q[7]}.uniq.length<2 || k[i][7].nil? || k[i][7].length<=0
    end
    text="#{text}\n\n**Cumulative Cost:** "
    text="#{text}#{k.map{|q| q[5][0]}.inject(0){|sum,x| sum + x }}<:Aether_Stone:510776805746278421>" if k.map{|q| q[5][0]}.inject(0){|sum,x| sum + x }>0
    text="#{text}#{k.map{|q| q[5][1]}.inject(0){|sum,x| sum + x }}<:Heavenly_Dew:510776806396395530>" if k.map{|q| q[5][1]}.inject(0){|sum,x| sum + x }>0
    text="#{text}#{k.map{|q| q[5][2]}.inject(0){|sum,x| sum + x }}<:Aether_Stone_SP:513982883560423425>" if k.map{|q| q[5][2]}.inject(0){|sum,x| sum + x }>0
    text="#{text} (Requires reaching AR Tier #{k.map{|q| q[6]}.max})" if k.map{|q| q[6]}.max>0
  else
    text="#{text}\n\n**Cost:** " if k[0][5].max>0
    text="#{text}#{k[0][5][0]}<:Aether_Stone:510776805746278421>" if k[0][5][0]>0
    text="#{text}#{k[0][5][1]}<:Heavenly_Dew:510776806396395530>" if k[0][5][1]>0
    text="#{text}#{k[0][5][2]}<:Aether_Stone_SP:513982883560423425>" if k[0][5][2]>0
    text="#{text}\n**AR Tier:** #{k[0][6]}" if k[0][6]>0
  end
  text="#{text}\n"
  if k.map{|q| q[4]}.uniq.length<2
    if ['yes','no'].include?(k[0][4].downcase)
      text="#{text}\n**Destructible?:** #{k[0][4]}"
    elsif k[0][2]=='Trap'
      text="#{text}\n**Traps are triggered by standing on them**"
    else
      text="#{text}\n**Destructible?:** #{k[0][4]}"
    end
    text="#{text}\n"
  end
  xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Structures/#{k[0][0].gsub('False ','').gsub(' ','_').gsub('.','').gsub('/','_').gsub('+','').gsub('!','')}.png?raw=true"
  text="#{text}\n**Additional Note:** #{k[0][7]}" unless k.map{|q| q[7]}.uniq.length>1 || k[0][7].nil? || k[0][7].length<=0
  create_embed(event,"__**#{k[0][0]}#{" #{k[0][1]}" unless k.length>1 || k[0][1]=='-'}**__#{'<:Current_Aether_Bonus:510022809741950986>' if b[0][3].include?(k[0][0])}",text,xcolor,nil,xpic)
end

def disp_accessory(bot,name,event,ignore=false)
  data_load()
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  a=s.split(' ').reject{ |q| q.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=s.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  k=find_data_ex(:find_accessory,args.join(' '),event)
  if k<0
    event.respond 'No matches found.' unless ignore
    return nil
  end
  k=@accessories[k]
  xcolor=0xFF47FF
  str=''
  str="<:Accessory_Type_Hair:531733124741201940>**Accessory Type:** Hair" if k[1]=='Hair'
  str="<:Accessory_Type_Hat:531733125227741194>**Accessory Type:** Hat" if k[1]=='Hat'
  str="<:Accessory_Type_Mask:531733125064163329>**Accessory Type:** Mask" if k[1]=='Mask'
  str="<:Accessory_Type_Tiara:531733130734731284>**Accessory Type:** Tiara" if k[1]=='Tiara'
  str="#{str}\n\n**Description:** #{k[2]}"
  str="#{str}\n\n**To obtain:** #{k[3]}" unless k[3].nil?
  str="#{str}\n\n**Additional Info:** #{k[4]}" unless k[4].nil?
  xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Accessories/#{k[0].gsub(' ','_')}.png"
  create_embed(event,"__**#{k[0]}**__",str,xcolor,nil,xpic)
end

def disp_itemu(bot,name,event,ignore=false)
  data_load()
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  a=s.split(' ').reject{ |q| q.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=s.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  k=find_data_ex(:find_item_feh,args.join(' '),event)
  if k<0
    event.respond 'No matches found.' unless ignore
    return nil
  end
  k=@itemus[k]
  str="**Item Type:** #{k[1]}\n**Maximum:** #{k[2]}"
  xcolor=0x5BACB9
  if ['Main','Event'].include?(k[1])
    str="#{str}\n\n**Effect/Description:** #{k[3]}"
  elsif k[1]=='Implied'
    xcolor=0x3B474D
    str="#{str}\n\n**Effect:** #{k[3]}"
  elsif k[1]=='Blessing'
    xcolor=0xF98281 if k[0].include?('Fire')
    xcolor=0x91F4FF if k[0].include?('Water')
    xcolor=0x97FF99 if k[0].include?('Wind')
    xcolor=0xFFAF7E if k[0].include?('Earth')
    xcolor=0xFDF39D if k[0].include?('Light')
    xcolor=0xBE83FE if k[0].include?('Dark')
    xcolor=0xF5A4DA if k[0].include?('Astra')
    xcolor=0xE1DACF if k[0].include?('Anima')
    str="#{str}\n\n**Description:** #{k[3]}"
  elsif k[1]=='Growth'
    xcolor=0xBD9843
    xcolor=0xE22141 if k[0].include?('Scarlet')
    xcolor=0x2764DE if k[0].include?('Azure')
    xcolor=0x09AA24 if k[0].include?('Verdant')
    xcolor=0x64757D if k[0].include?('Transparent')
    str="#{str}\n\n**Description:** #{k[3]}"
  elsif k[1]=='Assault'
    xcolor=0x332559
    str="**Type:** Arena Assault\n**Maximum:** #{k[2]}\n\n**Effect:** #{k[3]}"
  else
    str="#{str}\n\n**Effect/Description:** #{k[3]}"
  end
  str="#{str}\n\n**Additional Info:** #{k[4]}" unless k[4].nil?
  xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Items/#{k[0].gsub(' ','_')}.png"
  create_embed(event,"__**#{k[0]}**__",str,xcolor,nil,xpic)
end

def reverse_stat(stat)
  return "-#{stat[1,stat.length-1]}" if stat[0,1]=='+'
  return "+#{stat[1,stat.length-1]}" if stat[0,1]=='-'
  return 'robust' if stat.downcase=='sickly'
  return 'strong' if stat.downcase=='weak'
  return 'clever' if stat.downcase=='dull'
  return 'deft' if stat.downcase=='clumsy'
  return 'quick' if stat.downcase=='sluggish'
  return 'lucky' if stat.downcase=='unlucky'
  return 'sturdy' if stat.downcase=='fragile'
  return 'calm' if stat.downcase=='excitable'
  return 'sickly' if stat.downcase=='robust'
  return 'weak' if stat.downcase=='strong'
  return 'dull' if stat.downcase=='clever'
  return 'clumsy' if stat.downcase=='deft'
  return 'sluggish' if stat.downcase=='quick'
  return 'unlucky' if stat.downcase=='lucky'
  return 'fragile' if stat.downcase=='sturdy'
  return 'fragile' if stat.downcase=='defensive'
  return 'excitable' if stat.downcase=='calm'
  return stat
end

def find_nature(name)
  for j in 0...@natures.length
    return @natures[j] if @natures[j][0].downcase==name.downcase && @natures[j][3].nil?
  end
  return nil
end

def nature_name(boon,bane)
  boon='' if boon.nil?
  bane='' if bane.nil?
  b=[]
  for j in 0...@natures.length
    b.push(@natures[j][0]) if @natures[j][1].downcase==boon.downcase && @natures[j][2].downcase==bane.downcase
  end
  return b
  return nil
end

def skill_include?(table, skill)
  for j in 0...table.length
    unless table[j].nil?
      return j if table[j][0]==skill && table[j][4]!='Passive(W)'
    end
  end
  return -1
end

def sever(str,sklz=false)
  str="#{str.split('/').join(' / ')}#{" ``" if ['+','-','*'].include?(str[str.length-1,1])}"
  s=str.split(' ').join(' ')
  k=str.split('*')
  k2=1
  k2=0 if k.length==1 && k[0][0,1].to_i.to_s==k[0][0,1]
  if k.length==1 && k[0].include?(' ')
    k3=k[0].split(' ')
    k3=k3[k3.length-1]
    k2=0 if k3[0,1].to_i.to_s==k3[0,1]
  end
  for i in 0...k.length-k2
    k[i]="#{k[i]}*"
  end
  str=k.join(' ')
  str=str.gsub('(+)','(``)')
  k=str.split('+')
  for i in 1...k.length
    k[i]="+#{k[i]}"
  end
  str=k.join(' ')
  str=str.gsub('(``)','(+)')
  k=str.split(' ')
  for i in 1...k.length
    if k[i]=='+'
      if i==0 || k[i-1].length<2
      elsif k[i-1][0,7].downcase=='rallyup'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif k[i-1][0,5].downcase=='rally'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif k[i-1][k[i-1].length-4,4].downcase=='balm'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif ['windfire','earthwater','firewater','earthfire','earthwind','waterwind','waterearth','windearth','windwater','waterearth','waterfire'].include?(k[i-1].downcase.gsub('-',''))
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif ['HP','Attack','Speed','Defense','Resistance'].map{|q| q.downcase}.include?(k[i-1].downcase) && i==k.length-1
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      end
    elsif i>1 && !k[i-1].nil? && k[i][0,1]=='+' && k[i][1,k[i].length-1].to_i.to_s==k[i][1,k[i].length-1]
      k[i-1]=stat_modify(k[i-1].downcase)
      if k[i-1][0,7].downcase=='rallyup'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif k[i-1][0,5].downcase=='rally'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif ['HP','Attack','Speed','Defense','Resistance'].map{|q| q.downcase}.include?(k[i-1].downcase) && i==k.length-1
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif !sklz
      elsif ['HP','Attack','Speed','Defense','Resistance'].include?(k[i-1]) || ['attackspeed','atkspeed','attspeed','attackspd','atkspd','attspd','speedattack','speedatk','speedatt','spdattack','spdatk','spdatt','attackdefense','atkdefense','attdefense','attackdefence','atkdefence','attdefence','attackdef','atkdef','attdef','defenseattack','defenseatk','defenseatt','defenceattack','defenceatk','defenceatt','defattack','defatk','defatt','attackresistance','atkresistance','attresistance','attackres','atkres','attres','resistanceattack','resistanceatk','resistanceatt','resattack','resatk','resatt','speeddefense','spddefense','speeddefence','spddefence','speeddef','spddef','defensespeed','defensespd','defencespeed','defencespd','defspeed','defspd','speedresistance','spdresistance','speedres','spdres','resistancespeed','resistancespd','resspeed','resspd','defenseresistance','defenceresistance','defresistance','defenseres','defenceres','defres','resistancedefense','resistancedefence','resistancedef','resdefense','resdefence','resdef'].include?(k[i-1].downcase)
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      end
    elsif !sklz
    elsif k[i]=='(+)'
    elsif k[i-1]=='(+)'
      k[i]=stat_modify(k[i].downcase)
      if ['HP','Attack','Speed','Defense','Resistance'].include?(k[i])
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      end
    end
  end
  k.compact!
  str=k.join(' ')
  str=str.gsub('-star','``star')
  k=str.split('-')
  for i in 1...k.length
    k[i]="-#{k[i]}"
  end
  str=k.join(' ')
  str=str.gsub('``star','-star')
  str="#{str} +" if s[s.length-1,1]=='+'
  str="#{str} -" if s[s.length-1,1]=='-'
  str="* #{str}" if s[0,1]=='*'
  return str
end

def splice(str)
  s=sever(str).split(' ')
  for i in 0...s.length
    if s[i][s[i].length-1,1]=='*' && i<s.length-1
      s[i+1]="#{s[i]}#{s[i+1]}"
      s[i]=nil
    elsif ['+','-'].include?(s[i][0,1]) && i>0
      k=0
      for j in 0...i
        k=j unless s[j].nil?
      end
      s[k]="#{s[k]}#{s[i]}"
      s[i]=nil
    end
  end
  s.compact!
  return s
end

def get_group(name,event)
  data_load()
  groups_load()
  srv=0
  srv=event.server.id unless event.server.nil?
  g=get_markers(event)
  sklz=@skills.map{|q| q}
  untz=@units.map{|q| q}
  if ['dancer','singer','refresher','dancers','singers','refreshers','dancers&singers'].include?(name.downcase)
    k=sklz[sklz.find_index{|q| q[0]=='Dance'}]
    k2=sklz[sklz.find_index{|q| q[0]=='Sing'}]
    b=[]
    for i in 0...@max_rarity_merge[0]
      u=k[10][i].split(', ')
      for j in 0...u.length
        b.push(u[j].gsub('Lavatain','Laevatein')) unless b.include?(u[j]) || u[j].include?('-') || !has_any?(g, untz[untz.find_index{|q| q[0]==u[j]}][13][0])
      end
      u2=k2[10][i].split(', ')
      for j in 0...u2.length
        b.push(u2[j].gsub('Lavatain','Laevatein')) unless b.include?(u2[j]) || u2[j].include?('-') || !has_any?(g, untz[untz.find_index{|q| q[0]==u2[j]}][13][0])
      end
    end
    return ['Dancer/Singer',b]
  elsif ['braveheroes','brave','cyl'].include?(name.downcase)
    l=untz.reject{|q| !has_any?(g, q[13][0]) || !q[0].include?('(Brave)')}
    return ['BraveHeroes',l.map{|q| q[0]}]
  elsif ['fallenheroes','fallen','dark','evil','alter'].include?(name.downcase)
    l=untz.reject{|q| !has_any?(g, q[13][0]) || !q[0].include?('(Fallen)')}
    return ['FallenHeroes',l.map{|q| q[0]}]
  elsif ['valentines',"valentine's"].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || !q[0].include?('(Valentines)')}
    return ["Valentine's",l.map{|q| q[0]}]
  elsif ['Bathing'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || !q[0].include?('(Bath)')}
    return ['Bathing',l.map{|q| q[0]}]
  elsif ['bunnies'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || (!q[0].include?('(Spring)') && !q[0].include?('(Bunny)'))}
    return ['Bunnies',l.map{|q| q[0]}]
  elsif ['wedding','bride','brides','groom','grooms'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || !(q[0].include?('(Bride)') || q[0].include?('(Groom)'))}
    return ['Wedding',l.map{|q| q[0]}]
  elsif ['summer'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || !q[0].include?('(Summer)')}
    return ['Summer',l.map{|q| q[0]}]
  elsif ['halloween'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || !q[0].include?('(Halloween)')}
    return ['Halloween',l.map{|q| q[0]}]
  elsif ['winter','holiday'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || !q[0].include?('(Winter)')}
    return ['Winter',l.map{|q| q[0]}]
  elsif ['worsethanliki','wtl'].include?(name.downcase)
    liki=untz[untz.find_index{|q| q[0]=='Tiki(Young)(Earth)'}]
    l=untz.reject{|q| q[0]=='Tiki(Young)(Earth)' || q[1][0]=='Purple' || !has_any?(g, q[13][0])}
    for i in 0...liki[5].length
      l=l.reject{|q| q[5][i]>liki[5][i]}
    end
    return ['WorseThanLiki',l.map{|q| q[0]}]
  elsif ['seasonal','seasonals'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0])}
    return ['Seasonals',l.map{|q| q[0]}]
  elsif ['legendary','legendaries','legends','legend','mythic','mythicals','mythics','mythicals','mystics','mystic','mysticals','mystical'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]==' ' || !has_any?(g, q[13][0])}
    return ['Legendaries',l.map{|q| q[0]}]
  elsif ['retro-prfs'].include?(name.downcase)
    r=sklz.reject{|q| !(q[8]=='-' && q[4]=='Weapon' && q[6]!='-')}
    b=[]
    for i in 0...r.length
      u=r[i][6].split(', ')
      for j in 0...u.length
        b.push(u[j].gsub('Lavatain','Laevatein')) unless b.include?(u[j]) || u[j]=='Kiran' || !has_any?(g, untz[untz.find_index{|q| q[0]==u[j]}][13][0])
      end
    end
    r=sklz.reject{|q| q[4]!='Weapon'}.map{|q| q[10]}.map{|q| q.map{|q2| q2.split(', ').reject{|q3| !q3.include?('[Retro]')}.map{|q3| q3.gsub('[Retro]','')}}.reject{|q2| q2.length<=0}}.reject{|q| q.length<=0}
    for i in 0...r.length
      for i2 in 0...r[i].length
        for i3 in 0...r[i][i2].length
          b.push(r[i][i2][i3].gsub('Lavatain','Laevatein')) unless b.include?(r[i][i2][i3]) || r[i][i2][i3]=='Kiran' || !has_any?(g, untz[untz.find_index{|q| q[0]==r[i][i2][i3]}][13][0])
        end
      end
    end
    return ['Retro-Prfs',b.uniq]
  elsif ['falchion_users','falchionusers','falchion-users'].include?(name.downcase)
    k=sklz.reject{|q| q[0][0,10]!='Falchion ('}
    k2=[]
    for i in 0...k.length
      k2.push(k[i].map{|q| q})
      if !k[i][14].nil? && k[i][14].length>0
        m=k[i][14].split(', ')
        for i2 in 0...m.length
          k2.push(sklz[sklz.find_index{|q| q[0]==m[i2]}])
        end
      end
    end
    falusrs=k2.map{|q| q[10]}.join(', ').split(', ').reject{|q| q=='-' || !has_any?(g, untz[untz.find_index{|q2| q2[0]==q}][13][0])}.uniq.sort
    k=sklz.reject{|q| !has_any?(q[6].split(', '), falusrs) || q[4]!='Weapon'}
    return ['Falchion_Users',k.map{|q| q[6].split(', ')}.join(', ').split(', ').uniq.sort]
  elsif name.downcase=="mathoo'swaifus"
    metadata_load()
    return ["Mathoo'sWaifus",@dev_waifus]
  elsif name.downcase=='ghb'
    b=[]
    for i in 0...untz.length
      b.push(untz[i][0].gsub('Lavatain','Laevatein')) if untz[i][9][0].downcase.include?('g') && has_any?(g, untz[i][13][0])
    end
    return ['GHB',b]
  elsif name.downcase=='tempest'
    b=[]
    for i in 0...untz.length
      b.push(untz[i][0].gsub('Lavatain','Laevatein')) if untz[i][9][0].downcase.include?('t') && has_any?(g, untz[i][13][0])
    end
    return ['Tempest',b]
  elsif name.downcase=='daily_rotation'
    b=[]
    for i in 0...untz.length
      b.push(untz[i][0].gsub('Lavatain','Laevatein')) if untz[i][9][0].downcase.include?('d') && has_any?(g, untz[i][13][0])
    end
    return ['Daily_Rotation',b]
  elsif name.downcase=='bannerless'
    b=[]
    b2=[]
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHBanners.txt')
      b2=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHBanners.txt').each_line do |line|
        b2.push(line.gsub("\n",''))
      end
    else
      b2=[]
    end
    for i in 0...b2.length
      b2[i]=b2[i].split('\\'[0])
      b2[i][1]=b2[i][1].to_i
      b2[i][2]=b2[i][2].split(', ')
      b2[i][4]=nil if !b2[i][4].nil? && b2[i][4].length<=0
      b2[i]=nil if b2[i][2][0]=='-' && b2[i][4].nil?
    end
    b2.compact!
    if b2.length>0
      m=[]
      for i in 0...b2.length
        for j in 0...b2[i][2].length
          m.push(b2[i][2][j])
        end
      end
      m.uniq!
      data_load()
      k=@units.reject{|q| !(q[13].nil? || q[13][0].nil? || q[13][0].length.zero?) || !q[9][0].include?('p') || m.include?(q[0])}.uniq
    end
    return ['Bannerless',k.map{|q| q[0]}]
  elsif find_group(name,event)>0
    f=@groups[find_group(name,event)]
    f2=[]
    for i in 0...f[1].length
      f2.push(f[1][i].gsub('Lavatain','Laevatein')) if has_any?(g, untz[i][13][0])
    end
    return [f[0],f2]
  else
    return nil
  end
end

def split_list(event,list,headers,mode=0,x=true)
  spli=[]
  for i in 0...headers.length
    spli.push([])
  end
  if headers[0].is_a?(Array)
    for i2 in 0...headers.map{|q| q[1]}.max
      for i in 0...list.length
        mips=list[i][mode]
        mips=find_base_skill(list[i],event) if mode==-1
        mips=list[i][1][0] if mode==-2
        mips=list[i][1][1] if mode==-3
        mips=list[i][1][2] if mode==-4
        mips=list[i][2][0] if mode==-5
        mips=list[i][2][1] if mode==-6
        mips=weapon_clss(list[i][1],event) if mode==-7
        mips=list[i][3].split(' ')[0] if mode==-8
        mips=mips.split(', ')
        f=list[i].map{|q| q}
        for j in 0...headers.length
          unless headers[j][1]!=i2+1
            if mips.include?(headers[j][0])
              spli[j].push(f)
              list[i]=nil
            end
          end
        end
      end
      list.compact!
    end
    spli.push(list.map{|q| q})
  else
    for i in 0...list.length
      mips=list[i][mode]
      mips=find_base_skill(list[i],event) if mode==-1
      mips=list[i][1][0] if mode==-2
      mips=list[i][1][1] if mode==-3
      mips=list[i][1][2] if mode==-4
      mips=list[i][2][0] if mode==-5
      mips=list[i][2][1] if mode==-6
      mips=weapon_clss(list[i][1],event) if mode==-7
      mips=list[i][3].split(' ')[0] if mode==-8
      for j in 0...headers.length
        if mode==-8 && mips.downcase==headers[j].downcase
          spli[j].push(list[i])
        elsif mips==headers[j] || mips=="#{headers[j]} Users Only" || mips=="#{headers[j]}s Only" || mips=="#{headers[j]} Only"
          spli[j].push(list[i])
        elsif mips.split(', ')[0]=="#{headers[j]} Users Only" || mips.split(', ')[0]=="#{headers[j]}s Only" || mips.split(', ')[0]=="#{headers[j]} Only"
          spli[j].push(list[i])
        elsif headers[j][headers[j].length-1,1]=='s' && mips==headers[j][0,headers[j].length-1]
          spli[j].push(list[i])
        elsif ['Passive','Passives'].include?(headers[j]) && /Passive\((A|B|C)\)/ =~ mips
          spli[j].push(list[i])
        elsif ['Passive(S)'].include?(headers[j]) && mips.include?('Seal')
          spli[j].push(list[i])
        elsif ['Passive(A)','Passive(B)','Passive(C)','Passive(S)','Passive(W)'].include?(headers[j]) && mips.include?(headers[j])
          spli[j].push(list[i])
        end
      end
    end
  end
  list=[]
  for j in 0...spli.length
    spli[j]=nil if spli[j].length<=0
  end
  spli.compact!
  return spli unless x
  for j in 0...spli.length
    for i in 0...spli[j].length
      list.push(spli[j][i])
    end
    if j<spli.length-1 && spli[j].length>0
      list.push(list[list.length-1].map{|q| q})
      list[list.length-1][0]='- - -'
      list[list.length-1][13]=nil
    end
  end
  return list
end

def collapse_skill_list(list,mode=0)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || @shardizard==4
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return list_collapse(list,mode)
end

def find_in_units(event, mode=0, paired=false, ignore_limit=false)
  data_load()
  groups_load()
  srv=0
  srv=event.server.id unless event.server.nil?
  args=event.message.text.split(' ')
  args.shift
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  colors=[]
  weapons=[]
  color_weapons=[]
  movement=[]
  group=[]
  unitz=[]
  clzz=[]
  genders=[]
  games=[]
  supernatures=[]
  statlimits=[[-100,100],[-100,100],[-100,100],[-100,100],[-100,100]]
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHGames.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHGames.txt').each_line do |line|
      lookout.push(eval line)
    end
  end
  for i in 0...args.length
    args[i]=args[i].downcase.gsub('user','') if args[i].length>4 && args[i][args[i].length-4,4].downcase=='user'
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens','grean','greans'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','colorlesses','colourlesses','clear','clears'].include?(args[i].downcase)
    color_weapons.push(['Red','Blade']) if ['sword','swords','katana'].include?(args[i].downcase)
    color_weapons.push(['Blue','Blade']) if ['lance','lances','spear','spears','naginata'].include?(args[i].downcase)
    color_weapons.push(['Green','Blade']) if ['axe','axes','ax','club','clubs'].include?(args[i].downcase)
    color_weapons.push(['Red','Tome']) if ['redtome','redtomes','redmage','redmages'].include?(args[i].downcase)
    color_weapons.push(['Blue','Tome']) if ['bluetome','bluetomes','bluemage','bluemages'].include?(args[i].downcase)
    color_weapons.push(['Green','Tome']) if ['greentome','greentomes','greenmage','greenmages'].include?(args[i].downcase)
    clzz.push(['Troubadour', nil, 'Healer', 'Cavalry']) if ['troubadour', 'trobadour', 'troubador', 'trobador'].include?(args[i].downcase)
    clzz.push(["F\u00E1fnir", nil, 'Dragon', 'Flier']) if ['fafnir'].include?(args[i].downcase)
    weapons.push('Blade') if ['physical','blade','blades','close','closerange'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','spell','tomes','mages','spells','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Dragon') if ['dragon','dragons','breath','manakete','manaketes','close','closerange'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz','close','closerange'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thiefs','thieves','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Healer') if ['healer','staff','cleric','healers','clerics','staves','range','ranged','distance','distant'].include?(args[i].downcase)
    movement.push('Flier') if ['flier','flying','flyer','fly','pegasus','wyvern','fliers','flyers','wyverns','pegasi'].include?(args[i].downcase)
    movement.push('Cavalry') if ['cavalry','horse','pony','horsie','horses','horsies','ponies','cavalier','cavaliers','cav','cavs'].include?(args[i].downcase)
    movement.push('Infantry') if ['infantry','foot','feet'].include?(args[i].downcase)
    movement.push('Armor') if ['armor','armour','armors','armours','armored','armoured'].include?(args[i].downcase)
    genders.push('M') if ['male','man','boy'].include?(args[i].downcase)
    genders.push('F') if ['female','woman','girl'].include?(args[i].downcase)
    for i2 in 0...lookout.length
      games.push(lookout[i2][0]) if lookout[i2][1].map{|q| q.downcase}.include?(args[i].downcase)
    end
    supernatures.push('+HP') if ['hpboon','healthboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('+Atk') if ['atkboon','attboon','attackboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('+Spd') if ['spdboon','speedboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('+Def') if ['defboon','defenseboon','defenceboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('+Res') if ['resboon','resistanceboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-HP') if ['hpbane','healthbane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-Atk') if ['atkbane','attbane','attackbane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-Spd') if ['spdbane','speedbane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-Def') if ['defbane','defensebane','defencebane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-Res') if ['resbane','resistancebane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    if ['>','<','='].include?(args[i][0,1]) || ['>','<','='].include?(args[i][args[i].length-1,1])
    elsif args[i].include?('>=') || args[i].include?('<=') || args[i].include?('>') || args[i].include?('<')
      spl=[]
      if args[i].include?('>=')
        spl=args[i].downcase.split('>=')
        spl.push('>=')
      elsif args[i].include?('<=')
        spl=args[i].downcase.split('<=')
        spl.push('<=')
      elsif args[i].include?('>')
        spl=args[i].downcase.split('>')
        spl.push('>')
      elsif args[i].include?('<')
        spl=args[i].downcase.split('<')
        spl.push('<')
      end
      spl[1]=spl[1].to_i
      if spl[1]==0 && args[i][args[i].length-1,1]!='0'
      elsif spl[2]=='>='
        spl[1]-=1
        spl[2]='>'
      elsif spl[2]=='<='
        spl[1]+=1
        spl[2]='<'
      end
      v=-1
      v=0 if ['hp','health'].include?(spl[0].downcase)
      v=1 if ['str','strength','strong','mag','magic','atk','att','attack'].include?(spl[0].downcase)
      v=2 if ['spd','speed'].include?(spl[0].downcase)
      v=3 if ['def','defense','defence','defensive','defencive'].include?(spl[0].downcase)
      v=4 if ['res','resistance'].include?(spl[0].downcase)
      if spl[1]==0 && args[i][args[i].length-1,1]!='0'
      elsif v<0
      elsif spl[2]=='>'
        statlimits[v][0]=spl[1] unless statlimits[v][0]>spl[1]
      elsif spl[2]=='<'
        statlimits[v][1]=spl[1] unless statlimits[v][1]<spl[1]
      end
    end
    group.push(@groups[find_group(args[i].downcase,event)]) if find_group(args[i].downcase,event)>=0 && args[i].length>=3
  end
  colors=colors.uniq
  colors2=colors.map{|q| q}
  weapons=weapons.uniq
  movement=movement.uniq
  genders=genders.uniq
  games=games.uniq
  group=group.uniq
  clzz=clzz.uniq
  supernatures=supernatures.uniq
  # prune based on inputs
  matches1=[]
  g=get_markers(event)
  matches0=@units.reject{|q| !has_any?(g, q[13][0])}
  for i in 0...matches0.length
    matches0[i][0]=matches0[i][0].gsub('Lavatain','Laevatein')
  end
  stt=['HP','Atk','Spd','Def','Res']
  for i in 0...statlimits.length
    matches0=matches0.reject{|q| q[5][i]<=statlimits[i][0] || q[5][i]>=statlimits[i][1]}
    if statlimits[i][0]>statlimits[i][1]
      tmp=statlimits[i][0]*1
      statlimits[i][0]=statlimits[i][1]*1
      statlimits[i][1]=tmp*1
    end
    if statlimits[i][0]>-100 && statlimits[i][1]<100
      statlimits[i]="#{stt[i]} between #{statlimits[i][0]} and #{statlimits[i][1]}"
    elsif statlimits[i][0]>-100
      statlimits[i]="#{stt[i]} above #{statlimits[i][0]}"
    elsif statlimits[i][1]<100
      statlimits[i]="#{stt[i]} below #{statlimits[i][1]}"
    else
      statlimits[i]=nil
    end
  end
  statlimits.compact!
  if supernatures.length.zero? && colors.length.zero? && weapons.length.zero? && color_weapons.length.zero? && movement.length.zero? && genders.length.zero? && games.length.zero? && group.length.zero? && clzz.length.zero?
    return matches0.map{|q| q}.uniq if mode==3
    matches5=matches0.map{|q| q}.sort {|a,b| a[0].downcase <=> b[0].downcase}.uniq
  else
    if supernatures.include?('+HP') && supernatures.include?('-HP')
      matches0=matches0.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q[4][0])}
    elsif supernatures.include?('+HP')
      matches0=matches0.reject{|q| ![-3,1,5,10,14].include?(q[4][0])}
    elsif supernatures.include?('-HP')
      matches0=matches0.reject{|q| ![-2,2,6,11,15].include?(q[4][0])}
    end
    if supernatures.include?('+Atk') && supernatures.include?('-Atk')
      matches0=matches0.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q[4][1])}
    elsif supernatures.include?('+Atk')
      matches0=matches0.reject{|q| ![-3,1,5,10,14].include?(q[4][1])}
    elsif supernatures.include?('-Atk')
      matches0=matches0.reject{|q| ![-2,2,6,11,15].include?(q[4][1])}
    end
    if supernatures.include?('+Spd') && supernatures.include?('-Spd')
      matches0=matches0.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q[4][2])}
    elsif supernatures.include?('+Spd')
      matches0=matches0.reject{|q| ![-3,1,5,10,14].include?(q[4][2])}
    elsif supernatures.include?('-Spd')
      matches0=matches0.reject{|q| ![-2,2,6,11,15].include?(q[4][2])}
    end
    if supernatures.include?('+Def') && supernatures.include?('-Def')
      matches0=matches0.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q[4][3])}
    elsif supernatures.include?('+Def')
      matches0=matches0.reject{|q| ![-3,1,5,10,14].include?(q[4][3])}
    elsif supernatures.include?('-Def')
      matches0=matches0.reject{|q| ![-2,2,6,11,15].include?(q[4][3])}
    end
    if supernatures.include?('+Res') && supernatures.include?('-Res')
      matches0=matches0.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q[4][4])}
    elsif supernatures.include?('+Res')
      matches0=matches0.reject{|q| ![-3,1,5,10,14].include?(q[4][4])}
    elsif supernatures.include?('-Res')
      matches0=matches0.reject{|q| ![-2,2,6,11,15].include?(q[4][4])}
    end
    if colors.length.zero? && weapons.length.zero? && color_weapons.length.zero? && movement.length.zero? && genders.length.zero? && games.length.zero? && group.length.zero? && clzz.length.zero?
      return matches0.map{|q| q}.uniq if mode==3
      matches5=matches0.map{|q| q}.sort {|a,b| a[0].downcase <=> b[0].downcase}.uniq
    else
      if colors.length>0 && weapons.length>0
        matches1=matches0.reject{|q| !colors.include?(q[1][0]) || !weapons.include?(q[1][1])}
      elsif colors.length>0
        matches1=matches0.reject{|q| !colors.include?(q[1][0])}
      elsif weapons.length>0
        matches1=matches0.reject{|q| !weapons.include?(q[1][1])}
      else
        matches1=matches0.map{|q| q}
      end
      if color_weapons.length>0
        matches1=[] if matches1==matches0
        for i in 0...matches0.length
          for j in 0...color_weapons.length
            matches1.push(matches0[i]) if matches0[i][1][0]==color_weapons[j][0] && matches0[i][1][1]==color_weapons[j][1]
          end
        end
      end
      for i in 0...color_weapons.length
        colors.push(color_weapons[i][0])
      end
      matches1=matches1.uniq
      if movement.length.zero? && genders.length.zero? && games.length.zero? && group.length.zero? && clzz.length.zero?
        return matches1.map{|q| q}.uniq if mode==3
        matches5=matches1.map{|q| q}.sort {|a,b| a[0].downcase <=> b[0].downcase}.uniq
      else
        matches2=[]
        if movement.length>0
          matches2=matches1.reject{|q| !movement.include?(q[3])}
        else
          matches2=matches1.map{|q| q}
        end
        if clzz.length>0
          matches2=[] if matches2==matches0
          for i in 0...matches0.length
            for j in 0...clzz.length
              matches2.push(matches0[i]) if (clzz[j][1].nil? || matches0[i][1][0]==clzz[j][1]) && matches0[i][1][1]==clzz[j][2] && matches0[i][3]==clzz[j][3]
            end
          end
          for i in 0...clzz.length
            colors.push(clzz[i][1]) unless clzz[i][1].nil?
          end
        end
        if genders.length.zero? && games.length.zero? && group.length.zero?
          return matches2.map{|q| q} if mode==3
          matches5=matches2.map{|q| q}.sort {|a,b| a[0].downcase <=> b[0].downcase}.uniq
        else
          matches3=[]
          if genders.length>0
            matches3=matches2.reject{|q| !genders.include?(q[10])}
          else
            matches3=matches2.map{|q| q}
          end
          if games.length.zero? && group.length.zero?
            return matches3.map{|q| q}.uniq if mode==3
            matches5=matches3.map{|q| q}.sort {|a,b| a[0].downcase <=> b[0].downcase}.uniq
          else
            matches4=[]
            if games.length>0
              t=Time.now
              timeshift=8
              timeshift-=1 unless t.dst?
              t-=60*60*timeshift
              for i in 0...matches3.length
                for j in 0...games.length
                  if matches3[i][11].map{|q| q.downcase}.include?(games[j].downcase)
                    matches4.push(matches3[i])
                  elsif matches3[i][11].map{|q| q.downcase.gsub('(a)','')}.include?(games[j].downcase)
                    matches3[i][0]="#{matches3[i][0]} *[Amiibo]*"
                    matches4.push(matches3[i])
                  elsif t.year*1000000+t.month*10000+t.day*100+t.hour<2018120623 && @shardizard != 4
                  elsif matches3[i][11].map{|q| q.downcase.gsub('(at)','')}.include?(games[j].downcase)
                    matches3[i][0]="#{matches3[i][0]} *[Assist Trophy]*"
                    matches4.push(matches3[i])
                  elsif matches3[i][11].map{|q| q.downcase.gsub('(m)','')}.include?(games[j].downcase)
                    matches3[i][0]="#{matches3[i][0]} *[Mii Costume]*"
                    matches4.push(matches3[i])
                  elsif matches3[i][11].map{|q| q.downcase.gsub('(t)','')}.include?(games[j].downcase)
                    matches3[i][0]="#{matches3[i][0]} *[Trophy]*"
                    matches4.push(matches3[i])
                  elsif matches3[i][11].map{|q| q.downcase.gsub('(s)','')}.include?(games[j].downcase)
                    matches3[i][0]="#{matches3[i][0]} *[Spirit]*"
                    matches4.push(matches3[i])
                  elsif matches3[i][11].map{|q| q.downcase.gsub('(st)','')}.include?(games[j].downcase)
                    matches3[i][0]="#{matches3[i][0]} *[Sticker]*"
                    matches4.push(matches3[i])
                  end
                end
              end
            else
              matches4=matches3.map{|q| q}
            end
            matches4=matches4.uniq
            if group.length.zero?
              return matches4.map{|q| q}.uniq if mode==3
              matches5=matches4.map{|q| q}.sort {|a,b| a[0].downcase <=> b[0].downcase}.uniq
            else
              matches5=[]
              if group.length>0
                for j in 0...group.length
                  gg=get_group(group[j][0],event)
                  for i in 0...matches4.length
                    matches5.push(matches4[i]) if gg[1].include?(matches4[i][0])
                  end
                end
              else
                matches5=matches4.map{|q| q}
              end
              matches5=matches5.uniq
              matches5.compact!
              matches5=matches5.sort {|a,b| a[0].downcase <=> b[0].downcase}
            end
          end
        end
      end
    end
  end
  for i in 0...matches5.length
    matches5[i][0]=matches5[i][0].gsub('Lavatain','Laevatein')
  end
  return matches5.map{|q| q}.uniq if mode==3
  if mode<2
    if (weapons==['Blade'] && colors.length<=0 && color_weapons.length<=0) || (color_weapons.length>0 && color_weapons.map{|q| q[1]}.reject{|q| q=='Blade'}.length<=0 && weapons.length<=0 && colors.length<=0)
      # Blades are the only type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Red','Blue','Green','Colorless'],-2)
    elsif (weapons==['Tome'] && colors.length<=0 && color_weapons.length<=0) || (color_weapons.length>0 && color_weapons.map{|q| q[1]}.reject{|q| q=='Tome'}.length<=0 && weapons.length<=0 && colors.length<=0)
      # Tomes are the only type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Red','Blue','Green','Colorless'],-2)
    elsif weapons.length==1 && ['Dragon','Bow','Dagger','Healer'].include?(weapons[0]) && colors.length<=0 && color_weapons.length<=0
      # Only one weapon type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Red','Blue','Green','Colorless'],-2)
    elsif colors.length==1 && weapons.length<=0 && color_weapons.length<=0
      # Only one color requested but no other restrictions are given
      matches5=split_list(event,matches5,['Blade','Tome','Dragon','Bow','Dagger','Healer'],-3)
    elsif (weapons==['Tome'] && colors==['Red'] && color_weapons.length<=0) || (color_weapons==[['Red', 'Tome']] && (colors==['Red'] || colors.length<=0) && weapons.length<=0)
      # Red Tomes are the only type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Fire','Dark'],-4)
    elsif (weapons==['Tome'] && colors==['Blue'] && color_weapons.length<=0) || (color_weapons==[['Blue', 'Tome']] && (colors==['Blue'] || colors.length<=0) && weapons.length<=0)
      # Blue Tomes are the only type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Thunder','Light'],-4)
    elsif (weapons==['Tome'] && colors==['Green'] && color_weapons.length<=0) || (color_weapons==[['Green', 'Tome']] && (colors==['Green'] || colors.length<=0)  && weapons.length<=0)
      # Blue Tomes are the only type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Wind'],-4)
    elsif matches5.map{|q| q[0]}.join("\n").length<=1800
      matches5=split_list(event,matches5,['Red','Blue','Green','Colorless','Gold','Purple'],-2)
      matches5=split_list(event,matches5,['Infantry','Armor','Flier','Cavalry'],3) unless matches5.map{|q| q[0]}.include?('- - -')
    end
  end
  g=get_markers(event)
  if matches5.length==@units.reject{|q| has_any?(g, q[13][0])}.compact.length && !(args.nil? || args.length.zero?) && !safe_to_spam?(event) && mode != 3
    event.respond 'Your request is gibberish.' if ['unit','char','character','person','units','chars','charas','chara','people'].include?(args[0].downcase)
    return -1
  elsif mode==3
    return matches5
  elsif matches5.length.zero? && mode != 13
    event.respond 'There were no units that matched your request.' unless paired
    return -2
  elsif matches5.map{|k| k[0]}.join("\n").length>=1900 && !safe_to_spam?(event) && !ignore_limit && mode != 13
    event.respond 'There were so many unit matches that I would prefer you use the command in PM.' unless paired
    return -2
  elsif mode==2
    return matches5
  elsif mode==1 || mode==13
    f=matches5.map{|k| k[0]}
    m=[]
    m.push("*Weapon colors:* #{colors2.join(', ')}") if colors2.length>0
    m.push("*Weapon types:* #{weapons.map{|q| q.gsub('Healer','Staff').gsub('Dragon','Breath')}.join(', ')}") if weapons.length>0
    for i in 0...color_weapons.length
      color_weapons[i]=color_weapons[i].join(' ').gsub('Healer','Staff')
      color_weapons[i]='Sword (Red Blade)' if color_weapons[i]=='Red Blade'
      color_weapons[i]='Lance (Blue Blade)' if color_weapons[i]=='Blue Blade'
      color_weapons[i]='Axe (Green Blade)' if color_weapons[i]=='Green Blade'
      color_weapons[i]='Rod (Colorless Blade)' if color_weapons[i]=='Colorless Blade'
    end
    m.push("*Complete weapons:* #{color_weapons.join(', ').gsub('Healer','Staff').gsub('Dragon','Breath')}") if color_weapons.length>0
    m.push("*Movement:* #{movement.join(', ')}") if movement.length>0
    m.push("*Complete classes:* #{clzz.map{|q| "#{q[0]} (#{q[1,q.length-1].compact.join(' ').gsub('Healer','Staff').gsub('Dragon','Breath')})"}.join(', ')}") if clzz.length>0
    m.push("*Genders:* #{genders.map{|q| "#{q}#{'ale' if q=='M'}#{'emale' if q=='F'}"}.join(', ')}") if genders.length>0
    m.push("*Games:* #{games.join(', ')}") if games.length>0
    m.push("*Groups:* #{group.map{|q| q[0]}.join(', ')}") if group.length>0
    m.push("*Stats:* #{statlimits.join(', ')}") if statlimits.length>0
    m.push("*Supernatures:* #{supernatures.map{|q| "#{q[1,q.length-1]} #{q[0].gsub('+','boon').gsub('-','bane')}"}.join(', ')}") if supernatures.length>0
    return [m,matches5] if mode==13
    return [m,f]
  end
  return 1
end

def find_in_skills(event, mode=0, paired=false, brk=false)
  data_load()
  args=event.message.text.split(' ')
  args.shift
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  colors=[]
  weapons=[]
  skill_types=[]
  color_weapons=[]
  assists=[]
  specials=[]
  passives=[]
  weapon_subsets=[]
  passive_subsets=[]
  for i in 0...args.length
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens','grean','greans'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','colorlesses','colourlesses','clear','clears'].include?(args[i].downcase)
    color_weapons.push(['Red','Blade']) if ['sword','swords','katana'].include?(args[i].downcase)
    color_weapons.push(['Blue','Blade']) if ['lance','lances','spear','spears','naginata'].include?(args[i].downcase)
    color_weapons.push(['Green','Blade']) if ['axe','axes','ax','club','clubs'].include?(args[i].downcase)
    color_weapons.push(['Red','Tome']) if ['redtome','redtomes','redmage','redmages'].include?(args[i].downcase)
    color_weapons.push(['Blue','Tome']) if ['bluetome','bluetomes','bluemage','bluemages'].include?(args[i].downcase)
    color_weapons.push(['Green','Tome']) if ['greentome','greentomes','greenmage','greenmages'].include?(args[i].downcase)
    skill_types.push('Weapon') if ['weapon','weapons'].include?(args[i].downcase)
    skill_types.push('Assist') if ['assist','assists'].include?(args[i].downcase)
    skill_types.push('Special') if ['special','specials'].include?(args[i].downcase)
    skill_types.push('Passive') if ['passive','passives','apassives','apassive','passivea','passivesa','a_passives','a_passive','passive_a','passives_a','bpassives','bpassive','passiveb','passivesb','b_passives','b_passive','passive_b','passives_b','cpassives','cpassive','passivec','passivesc','c_passives','c_passive','passive_c','passives_c','spassives','spassive','passives','passivess','s_passives','s_passive','passive_s','passives_s','sealpassives','sealpassive','passiveseal','passivesseal','seal_passives','seal_passive','passive_seal','passives_seal','sealspassives','sealspassive','passiveseals','passivesseals','seals_passives','seals_passive','passive_seals','passives_seals','wpassives','wpassive','passivew','passivesw','w_passives','w_passive','passive_w','passives_w'].include?(args[i].downcase)
    weapons.push('Blade') if ['physical','blade','blades','close','closerange'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','magic','spell','tomes','mages','spells','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Breath') if ['dragon','dragons','breath','manakete','manaketes','close','closerange'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers','close','closerange'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thiefs','thieves','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Staff') if ['healer','staff','cleric','healers','clerics','staves','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz','close','closerange'].include?(args[i].downcase)
    assists.push('Health') if ['health','hp'].include?(args[i].downcase)
    assists.push('Move') if ['move','movement','moving','arrangement','positioning','positions','position'].include?(args[i].downcase)
    assists.push('Staff') if ['healer','staff','cleric','healers','clerics','staves'].include?(args[i].downcase)
    assists.push('Rally') if ['rally','rallys','rallies','buff','buffs'].include?(args[i].downcase)
    specials.push('Staff') if ['healer','staff','cleric','healers','clerics','staves','balm','balms'].include?(args[i].downcase)
    specials.push('Defensive') if ['defense','defence','defensive','defencive','proc'].include?(args[i].downcase)
    specials.push('Offensive') if ['offense','offence','offensive','offencive','damage','damaging','proc'].include?(args[i].downcase)
    specials.push('AoE') if ['aoe','area','spread','area_of_effect'].include?(args[i].downcase)
    passives.push('A') if ['a','apassives','apassive','passivea','passivesa','a_passives','a_passive','passive_a','passives_a'].include?(args[i].downcase)
    passives.push('B') if ['b','bpassives','bpassive','passiveb','passivesb','b_passives','b_passive','passive_b','passives_b'].include?(args[i].downcase)
    passives.push('C') if ['c','cpassives','cpassive','passivec','passivesc','c_passives','c_passive','passive_c','passives_c'].include?(args[i].downcase)
    passives.push('Seal') if ['s','seal','seals','spassives','spassive','passives','passivess','s_passives','s_passive','passive_s','passives_s','sealpassives','sealpassive','passiveseal','passivesseal','seal_passives','seal_passive','passive_seal','passives_seal','sealspassives','sealspassive','passiveseals','passivesseals','seals_passives','seals_passive','passive_seals','passives_seals'].include?(args[i].downcase)
    passives.push('W') if ['w','wpassives','wpassive','passivew','passivesw','w_passives','w_passive','passive_w','passives_w'].include?(args[i].downcase)
  end
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt').each_line do |line|
      lookout.push(eval line)
    end
  end
  for i in 0...args.length
    for i2 in 0...lookout.length
      if lookout[i2][1].include?(args[i].downcase)
        weapon_subsets.push(lookout[i2][0]) if lookout[i2][2]=='Weapon'
        passive_subsets.push(lookout[i2][0]) if lookout[i2][2]=='Passive'
      end
    end
    passive_subsets.push('Breathskill') if ['breath'].include?(args[i].downcase) && !skill_types.include?('weapon') && skill_types.length>0
    passive_subsets.push('Bladeskill') if ['blade'].include?(args[i].downcase) && !skill_types.include?('weapon') && skill_types.length>0
  end
  colors=colors.uniq
  colors2=colors.map{|q| q}
  weapons=weapons.uniq
  color_weapons=color_weapons.uniq
  skill_types=skill_types.uniq
  assists=assists.uniq
  specials=specials.uniq
  weapon_subsets=weapon_subsets.uniq
  passive_subsets=passive_subsets.uniq
  # prune based on inputs
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  matches0=[]
  all_skills=@skills.reject{|q| !has_any?(g, q[13]) || (q[4].split(', ').include?('Passive(W)') && !q[4].split(', ').include?('Passive(S)') && !q[4].split(', ').include?('Seal') && q[10].map{|q2| q2.length}.max<2)}
  for i in 0...all_skills.length
    all_skills[i][4]=all_skills[i][4].gsub(', Passive(W)','')
  end
  data_load()
  tmp=@skills.reject{|q| !has_any?(g, q[13]) || !q[4].include?(', Passive(W)')}.reject{|q| q[12].split(', ').reject{|q2| find_skill(q2,event)<0}.length<=0}
  for i in 0...tmp.length
    tmp[i][4]='Passive(W)'
    all_skills.push(tmp[i])
  end
  skill_types.push('Weapon') if (!colors.length.zero? || !weapons.length.zero? || !color_weapons.length.zero?) && assists.length.zero? && specials.length.zero? && passives.length.zero? && weapon_subsets.length.zero? && passive_subsets.length.zero?
  if skill_types.length.zero? && colors.length.zero? && weapons.length.zero? && color_weapons.length.zero? && assists.length.zero? && specials.length.zero? && passives.length.zero? && weapon_subsets.length.zero? && passive_subsets.length.zero?
    matches3=all_skills.map{|q| q}.uniq
  else
    if skill_types.length>0
      for i in 0...all_skills.length
        for j in 0...skill_types.length
          matches0.push(all_skills[i]) if all_skills[i][11].split(', ').include?(skill_types[j])
        end
      end
    else
      matches0=@skills.map{|q| q}
    end
    # weapon-only inputs
    if colors.length.zero? && weapons.length.zero? && color_weapons.length.zero? && assists.length.zero? && specials.length.zero? && passives.length.zero? && weapon_subsets.length.zero? && passive_subsets.length.zero?
      matches3=matches0.map{|q| q}.uniq
    else
      skill_types.push('Weapon*') unless colors.length.zero? && weapons.length.zero? && color_weapons.length.zero?
      matches1=[]
      cwc=false
      if colors.length>0 && weapons.length>0
        for i in 0...matches0.length
          for j in 0...weapons.length
            for j2 in 0...colors.length
              matches1.push(matches0[i]) if matches0[i][4]=='Weapon' && matches0[i][11].split(', ').include?(weapons[j]) && matches0[i][11].split(', ').include?(colors[j])
            end
          end
        end
      elsif colors.length>0
        for i in 0...matches0.length
          for j in 0...colors.length
            matches1.push(matches0[i]) if matches0[i][4]=='Weapon' && matches0[i][11].split(', ').include?(colors[j])
          end
        end
      elsif weapons.length>0
        for i in 0...matches0.length
          for j in 0...weapons.length
            matches1.push(matches0[i]) if matches0[i][4]=='Weapon' && matches0[i][11].split(', ').include?(weapons[j])
          end
        end
      elsif color_weapons.length>0
        for i in 0...matches0.length
          for j in 0...color_weapons.length
            matches1.push(matches0[i]) if matches0[i][4]=='Weapon' && matches0[i][11].split(', ').include?(color_weapons[j][1]) && matches0[i][11].split(', ').include?(color_weapons[j][0])
          end
        end
        cwc=true
      else
        matches1=matches0.reject{|q| q[4]!='Weapon'}.map{|q| q}
      end
      if color_weapons.length>0 && !cwc
        matches1=[] if matches1.reject{|q| !has_any?(g, q[13])}==all_skills.reject{|q| q[4]!='Weapon'}
        for i in 0...all_skills.length
          for j in 0...color_weapons.length
            p1=all_skills[i][11]
            matches1.push(all_skills[i]) if " #{p1},".include?(" #{color_weapons[j][0]},") && " #{p1},".include?(" #{color_weapons[j][1]},") && all_skills[i][4]=='Weapon'
          end
        end
      end
      # Specific types
      matches2=matches1.map{|q| q}
      if assists.length>0
        for i in 0...matches0.length
          for j in 0...assists.length
            matches2.push(matches0[i]) if matches0[i][4]=='Assist' && matches0[i][11].split(', ').include?(assists[j])
          end
        end
      else
        for i in 0...matches0.length
          matches2.push(matches0[i]) if matches0[i][4]=='Assist' && (skill_types.reject{|q| q.include?('*')}.length.zero? || skill_types.map{|q| q.gsub('*','')}.include?('Assist'))
        end
      end
      if specials.length>0
        for i in 0...matches0.length
          for j in 0...specials.length
            matches2.push(matches0[i]) if matches0[i][4]=='Special' && matches0[i][11].split(', ').include?(specials[j])
          end
        end
      else
        for i in 0...matches0.length
          matches2.push(matches0[i]) if matches0[i][4]=='Special' && (skill_types.reject{|q| q.include?('*')}.length.zero? || skill_types.map{|q| q.gsub('*','')}.include?('Special'))
        end
      end
      if passives.length>0
        for i in 0...matches0.length
          matches2.push(matches0[i]) if matches0[i][4].include?('Passive(A)') && passives.include?('A')
          matches2.push(matches0[i]) if matches0[i][4].include?('Passive(B)') && passives.include?('B')
          matches2.push(matches0[i]) if matches0[i][4].include?('Passive(C)') && passives.include?('C')
          matches2.push(matches0[i]) if matches0[i][4].include?('Seal') && passives.include?('Seal')
          matches2.push(matches0[i]) if matches0[i][4].include?('Passive(W)') && passives.include?('W')
        end
      else
        for i in 0...matches0.length
          if matches0[i][11].split(', ').include?('Passive')
            matches2.push(matches0[i]) if skill_types.length.zero? || skill_types.include?('Passive')
            matches2.push(matches0[i]) if skill_types.reject{|q| q.include?('*')}.length.zero? && weapons==['Staff'] && assists==['Staff'] && specials==['Staff']
          end
        end
      end
      matches2=matches2.uniq
      if weapon_subsets.length.zero? && passive_subsets.length.zero?
        matches3=matches2.map{|q| q}.uniq
      else
        # subsets
        matches3=[]
        if weapon_subsets.length>0
          for i in 0...matches2.length
            for j in 0...weapon_subsets.length
              if matches2[i][4]=='Weapon' && weapon_subsets[j]=='Inheritable'
                matches3.push(matches2[i]) unless matches2[i][11].split(', ').include?('Prf')
              elsif matches2[i][4]=='Weapon' && weapon_subsets[j]=='Pega-killer' && !weapon_subsets.include?('Effective')
                matches3.push(matches2[i]) if (matches2[i][5]=='Bow Users Only' && !matches2[i][11].split(', ').include?('UnBow')) || matches2[i][11].split(', ').include?(weapon_subsets[j])
              elsif matches2[i][4]=='Weapon' && weapon_subsets[j]=='Retro-Prf'
                matches3.push(matches2[i]) if matches2[i][11].split(', ').include?('Prf') && matches2[i][8]=='-'
              elsif matches2[i][4]=='Weapon' && matches2[i][11].split(', ').include?(weapon_subsets[j])
                matches3.push(matches2[i])
              elsif matches2[i][4]=='Weapon' && has_any?(matches2[i][11].split(', '),["(TR)#{weapon_subsets[j]}","(RT)#{weapon_subsets[j]}","(T)(R)#{weapon_subsets[j]}","(R)(T)#{weapon_subsets[j]}"])
                matches2[i][0]="#{matches2[i][0]} *(+) [Tsfrm]All*"
                matches3.push(matches2[i])
              elsif matches2[i][4]=='Weapon' && has_any?(matches2[i][11].split(', '),["(TE)#{weapon_subsets[j]}","(ET)#{weapon_subsets[j]}","(T)(E)#{weapon_subsets[j]}","(E)(T)#{weapon_subsets[j]}"])
                matches2[i][0]="#{matches2[i][0]} *(+) [Tsfrm]Effect*"
                matches3.push(matches2[i])
              elsif matches2[i][4]=='Weapon' && matches2[i][11].split(', ').include?("(R)#{weapon_subsets[j]}")
                matches2[i][0]="#{matches2[i][0]} *(+) All*"
                matches3.push(matches2[i])
              elsif matches2[i][4]=='Weapon' && matches2[i][11].split(', ').include?("(E)#{weapon_subsets[j]}")
                matches2[i][0]="#{matches2[i][0]} *(+) Effect*"
                matches3.push(matches2[i])
              elsif matches2[i][4]=='Weapon' && matches2[i][11].split(', ').include?("(T)#{weapon_subsets[j]}")
                matches2[i][0]="#{matches2[i][0]} *- Transformed*"
                matches3.push(matches2[i])
              end
            end
          end
        elsif weapons.length>0 || colors.length>0 || color_weapons.length>0 || skill_types.map{|q| q.gsub('*','')}.include?('Weapon')
          for i in 0...matches2.length
            matches3.push(matches2[i]) if matches2[i][4]=='Weapon'
          end
        end
        if assists.length>0 || skill_types.include?('Assist')
          for i in 0...matches2.length
            matches3.push(matches2[i]) if matches2[i][4]=='Assist'
          end
        end
        if specials.length>0 || skill_types.include?('Special')
          for i in 0...matches2.length
            matches3.push(matches2[i]) if matches2[i][4]=='Special'
          end
        end
        if passive_subsets.length>0
          for i in 0...matches2.length
            for j in 0...passive_subsets.length
              matches3.push(matches2[i]) if (matches2[i][4].include?('Passive') || matches2[i][4]=='Seal') && matches2[i][11].split(', ').include?(passive_subsets[j])
            end
          end
        elsif passives.length>0 || skill_types.include?('Passive')
          for i in 0...matches2.length
            matches3.push(matches2[i]) if matches2[i][4].include?('Passive') || matches2[i][4]=='Seal'
          end
        end
      end
    end
  end
  g=get_markers(event)
  matches4=collapse_skill_list(matches3.reject{|q| !has_any?(g, q[13])},3)
  skill_types=skill_types.reject{|q| q.include?('*')}
  if mode==2
  elsif skill_types.length<=0 && weapons==['Staff'] && assists==['Staff'] && specials==['Staff']
    # Staff skills are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Weapons','Assists','Specials','Passives'],4)
  elsif (weapons==['Blade'] && colors.length<=0 && color_weapons.length<=0) || (color_weapons.length>0 && color_weapons.map{|q| q[1]}.reject{|q| q=='Blade'}.length<=0 && weapons.length<=0 && colors.length<=0)
    # Blades are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Sword','Lance','Axe','Rod'],5)
  elsif (weapons==['Tome'] && colors==['Red'] && color_weapons.length<=0) || (colors.length<=0 && weapons.length<=0 && color_weapons==[['Red','Tome']])
    # Red Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Fire',"Rau\u00F0r",'Flux'],-1)
  elsif (weapons==['Tome'] && colors==['Blue'] && color_weapons.length<=0) || (colors.length<=0 && weapons.length<=0 && color_weapons==[['Blue','Tome']])
    # Blue Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Thunder',"Bl\u00E1r",'Light'],-1)
  elsif (weapons==['Tome'] && colors==['Green'] && color_weapons.length<=0) || (colors.length<=0 && weapons.length<=0 && color_weapons==[['Green','Tome']])
    # Green Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Wind','Gronn'],-1)
  elsif (weapons==['Tome'] && colors.length<=0 && color_weapons.length<=0) || (color_weapons.length>0 && color_weapons.map{|q| q[1]}.reject{|q| q=='Tome'}.length<=0 && weapons.length<=0 && colors.length<=0)
    # Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Red Tome','Blue Tome','Green Tome'],5)
  elsif colors==['Red'] && weapons.length<=0 && color_weapons.length<=0
    # Red is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Sword','Red Tome','Dragon','Beast','Bow','Dagger','Staff'],5)
  elsif colors==['Blue'] && weapons.length<=0 && color_weapons.length<=0
    # Blue is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Lance','Blue Tome','Dragon','Beast','Bow','Dagger','Staff'],5)
  elsif colors==['Green'] && weapons.length<=0 && color_weapons.length<=0
    # Green is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Axe','Green Tome','Dragon','Beast','Bow','Dagger','Staff'],5)
  elsif colors==['Colorless'] && weapons.length<=0 && color_weapons.length<=0
    # Colorless is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Rod','Colorless Tome','Dragon','Beast','Bow','Dagger','Staff'],5)
  elsif matches4.map{|q| q[0]}.join("\n").length<=1800 && matches4.map{|q| q[4]}.uniq.length==1 && matches4.map{|q| q[4]}.uniq[0]=='Weapon' && matches4.map{|q| q[11]}.uniq.length>1
    matches4=split_list(event,matches4,['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Rod','Colorless Tome','Dragon','Beast','Bow','Dagger','Staff'],5)
  elsif matches4.map{|q| q[0]}.join("\n").length<=1800 && matches4.map{|q| q[4]}.uniq.length==1 && matches4.map{|q| q[4]}.uniq[0]=='Assist' && matches4.map{|q| q[5]}.uniq.length>1
    matches4=split_list(event,matches4,[['Rally',1],['Move',2],['Music',1],['Health',2],['Staff',1]],11)
  elsif matches4.map{|q| q[0]}.join("\n").length<=1800 && matches4.map{|q| q[4]}.uniq.length==1 && matches4.map{|q| q[4]}.uniq[0]=='Special'
    if matches4.reject{|q| q[11].split(', ').include?('Damage')}.length.zero? && matches4[0][11].split(', ').include?('Damage')
      matches4=split_list(event,matches4,[['StarSpecial',2],['MoonSpecial',2],['SunSpecial',2],['EclipseSpecial',1],['FireSpecial',2],['IceSpecial',2],['DragonSpecial',2],['DarkSpecial',2],['RendSpecial',2]],11)
    elsif matches4.reject{|q| q[11].split(', ').include?('Defense')}.length.zero? && matches4[0][11].split(', ').include?('Defense')
      matches4=split_list(event,matches4,[['MiracleSpecial',2],['SupershieldSpecial',1],['AegisSpecial',2],['PaviseSpecial',2]],11)
    elsif matches4.map{|q| q[5]}.uniq.length>1
      matches4=split_list(event,matches4,[['Damage',1],['Defense',1],['AoE',1],['Staff',1]],11)
    end
  elsif !has_any?(matches4.map{|q| q[4]}.uniq, ['Weapon', 'Assist', 'Special'])
    ptypes=matches4.map{|q| q[4]}.uniq
    if passives==['Seal'] || ptypes==ptypes.reject{|q| !q.split(', ').include?('Seal')} # when only seals are listed, sort by color.
      matches4=split_list(event,matches4,['Scarlet','Azure','Verdant','Transparent','Gold','-'],-8)
    elsif passives==['W'] || ptypes==ptypes.reject{|q| !q.split(', ').include?('Passive(W)')} # when only weapon passives are listed, ignore sorting
    elsif passives.length<=0 # otherwise, sort by passive type
      matches4=split_list(event,matches4,['Passive(A)','Passive(B)','Passive(C)','Passive(S)','Passive(W)'],4)
    end
  end
  data_load()
  microskills=collapse_skill_list(@skills.map{|q| q},4)
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  matches4=matches4.reject{|q| !has_any?(g, q[13])}
  data_load()
  m=[]
  m.push("*Skill types:* #{skill_types.join(', ')}") if skill_types.reject{|q| q=='Weapon'}.length>0
  m.push("*Weapon colors:* #{colors2.join(', ')}") if colors2.length>0
  m.push("*Weapon types:* #{weapons.map{|q| q.gsub('Healer','Staff')}.join(', ')}") if weapons.length>0
  for i in 0...color_weapons.length
    color_weapons[i]=color_weapons[i].join(' ').gsub('Healer','Staff')
    color_weapons[i]='Sword (Red Blade)' if color_weapons[i]=='Red Blade'
    color_weapons[i]='Lance (Blue Blade)' if color_weapons[i]=='Blue Blade'
    color_weapons[i]='Axe (Green Blade)' if color_weapons[i]=='Green Blade'
    color_weapons[i]='Rod (Colorless Blade)' if color_weapons[i]=='Colorless Blade'
  end
  m.push("*Complete weapons:* #{color_weapons.join(', ')}") if color_weapons.length>0
  m.push("*Weapon subtypes:* #{weapon_subsets.join(', ')}") if weapon_subsets.length>0
  m.push("*Assist subtypes:* #{assists.join(', ')}") if assists.length>0
  m.push("*Special subtypes:* #{specials.join(', ')}") if specials.length>0
  m.push("*Passive subtypes:* #{passive_subsets.join(', ')}") if passive_subsets.length>0
  if matches4.length>=microskills.length && !(args.nil? || args.length.zero?) && !safe_to_spam?(event)
    event.respond 'Your request is gibberish.' if ['skill','skills'].include?(args[0].downcase)
    return -1
  elsif matches4.length.zero?
    event.respond 'There were no skills that matched your request.' unless paired
    return -2
  elsif mode==1
    f=matches4.map{|k| k[0].gsub('Bladeblade','Laevatein')}
    return [m,f]
  elsif mode==2
    return [m,matches4]
  end
  return 1
end

def display_units(event, mode)
  k=find_in_units(event,1)
  if k.is_a?(Array)
    mk=k[0]
    k=k[1]
  end
  if k.is_a?(Array)
    data_load()
    untz=@units.map{|q| q}
    for i in 0...k.length
      m=''
      m='*' if ['Laevatein','Laevatein(Winter)'].include?(k[i])
      unless ['Laevatein','Laevatein(Winter)','- - -'].include?(k[i])
        m2=untz[untz.find_index{|q2| q2[0]==k[i].gsub(' *[Amiibo]*','').gsub(' *[Assist Trophy]*','').gsub(' *[Mii Costume]*','').gsub(' *[Trophy]*','').gsub(' *[Sticker]*','').gsub(' *[Spirit]*','')}]
        m='~~' unless m2[13][0].nil?
        m='*' if m2[9][0].downcase.gsub('0s','')=='-'
      end
      m='' if m=='*' && k.reject{|q| q.split(' *[').length>1}.length>0
      k[i]="#{m}#{k[i]}#{m}"
    end
    if k.include?('- - -')
      p1=[[]]
      p2=0
      for i in 0...k.length
        if k[i]=='- - -'
          p2+=1
          p1.push([])
        else
          p1[p2].push(k[i])
        end
      end
      for i in 0...p1.length
        wpn1=p1[i].map{|q| untz[untz.find_index{|q2| q2[0]==q.gsub('Laevatein','Lavatain').gsub('~~','').gsub(' *[Amiibo]*','').gsub(' *[Assist Trophy]*','').gsub(' *[Mii Costume]*','').gsub(' *[Trophy]*','').gsub(' *[Sticker]*','').gsub(' *[Spirit]*','').gsub('*','')}][1]}
        wpn1=wpn1.map{|q| [q[0],q[1]]} if wpn1.map{|q| q[1]}.uniq.length==1 && wpn1.map{|q| q[1]}[0]=='Beast'
        h='.'
        if wpn1.uniq.length==1
          # blade type
          h='<:Red_Blade:443172811830198282> Swords' if p1[i].include?('Alfonse') || (wpn1[0]==['Red', 'Blade'])
          h='<:Blue_Blade:467112472768151562> Lances' if p1[i].include?('Sharena') || (wpn1[0]==['Blue', 'Blade'])
          h='<:Green_Blade:467122927230386207> Axes' if p1[i].include?('Anna') || (wpn1[0]==['Green', 'Blade'])
          h='<:Colorless_Blade:443692132310712322> Rods' if wpn1[0]==['Colorless', 'Blade']
          # Magic types
          h='<:Fire_Tome:499760605826252800> Fire Mages' if p1[i].include?('Lilina') || (wpn1[0]==['Red', 'Tome', 'Fire'])
          h='<:Dark_Tome:499958772073103380> Dark Mages' if p1[i].include?('Raigh') || (wpn1[0]==['Red', 'Tome', 'Dark'])
          h='<:Thunder_Tome:499790911178539009> Thunder Mages' if p1[i].include?('Odin') || (wpn1[0]==['Red', 'Tome', 'Thunder'])
          h='<:Light_Tome:499760605381787650> Light Mages' if p1[i].include?('Micaiah') || (wpn1[0]==['Red', 'Tome', 'Light'])
          h='<:Wind_Tome:499760605713137664> Wind Mages' if p1[i].include?('Cecilia') || (wpn1[0]==['Green', 'Tome', 'Wind'])
          # Dragon colors
          h='<:Red_Dragon:443172811796774932> Red Dragons' if p1[i].include?('Tiki(Young)') || (wpn1[0]==['Red', 'Dragon'])
          h='<:Blue_Dragon:467112473313542144> Blue Dragons' if p1[i].include?('Nowi') || (wpn1[0]==['Blue', 'Dragon'])
          h='<:Green_Dragon:467122926718550026> Green Dragons' if p1[i].include?('Fae') || (wpn1[0]==['Green', 'Dragon'])
          h='<:Colorless_Dragon:443692132415438849> Colorless Dragons' if p1[i].include?('Robin(F)(Fallen)') || (wpn1[0]==['Colorless', 'Dragon'])
          # archer colors
          h='<:Red_Bow:443172812455280641> Red Archers' if (wpn1[0]==['Red', 'Bow'])
          h='<:Blue_Bow:467112473313542155> Blue Archers' if (wpn1[0]==['Blue', 'Bow'])
          h='<:Green_Bow:467122927536570380> Green Archers' if p1[i].include?('Lyn(Wind)') || (wpn1[0]==['Green', 'Bow'])
          h='<:Colorless_Bow:443692132616896512> Colorless Archers' if p1[i].include?('Takumi') || (wpn1[0]==['Colorless', 'Bow'])
          # dagger colors
          h='<:Red_Dagger:443172811490721804> Red Thieves' if wpn1[0]==['Red', 'Dagger']
          h='<:Blue_Dagger:467112472625545217> Blue Thieves' if wpn1[0]==['Blue', 'Dagger']
          h='<:Green_Dagger:467122926655897610> Green Thieves' if wpn1[0]==['Green', 'Dagger']
          h='<:Colorless_Dagger:443692132683743232> Colorless Thieves' if p1[i].include?('Matthew') || (wpn1[0]==['Colorless', 'Dagger'])
          # healer colors
          h='<:Red_Staff:443172812455280640> Red Healers' if wpn1[0]==['Red', 'Healer']
          h='<:Blue_Staff:467112472407703553> Blue Healers' if wpn1[0]==['Blue', 'Healer']
          h='<:Green_Staff:467122927616262144> Green Healers' if wpn1[0]==['Green', 'Healer']
          h="<:Colorless_Staff:443692132323295243> #{'Colorless ' if alter_classes(event,'Colored Healers')}Healers" if p1[i].include?('Sakura') || (wpn1[0]==['Colorless', 'Healer'])
          # Beast colors
          h='<:Red_Beast:532853459444170753> Red Beasts' if (wpn1[0]==['Red', 'Beast'])
          h='<:Blue_Beast:532853459842629642> Blue Beasts' if (wpn1[0]==['Blue', 'Beast'])
          h='<:Green_Beast:532853459779846154> Green Beasts' if (wpn1[0]==['Green', 'Beast'])
          h='<:Colorless_Beast:532853459804749844> Colorless Beasts' if (wpn1[0]==['Colorless', 'Beast'])
        elsif wpn1.length>1 && wpn1.map{|q| [q[0],q[1]]}.uniq.length==1
          h='<:Red_Tome:443172811826003968> Red Mages' if (p1[i].include?('Lilina') && p1[i].include?('Raigh')) || (wpn1.map{|q| [q[0],q[1]]}.include?(['Red', 'Tome']))
          h='<:Blue_Tome:467112472394858508> Blue Mages' if (p1[i].include?('Odin') && p1[i].include?('Micaiah')) || (wpn1.map{|q| [q[0],q[1]]}.include?(['Blue', 'Tome']))
          h='<:Green_Tome:467122927666593822> Green Mages' if p1[i].include?('Cecilia') || (wpn1.map{|q| [q[0],q[1]]}.include?(['Green', 'Tome']))
          h='<:Colorless_Tome:443692133317345290> Colorless Mages' if (wpn1.map{|q| [q[0],q[1]]}.include?(['Colorless', 'Tome']))
        elsif wpn1.length>1 && wpn1.map{|q| q[0]}.uniq.length==1
          h='<:Red_Unknown:443172811486396417> Red' if (wpn1.map{|q| q[0]}.include?('Red'))
          h='<:Blue_Unknown:467112473980305418> Blue' if (wpn1.map{|q| q[0]}.include?('Blue'))
          h='<:Green_Unknown:467122926785921044> Green' if (wpn1.map{|q| q[0]}.include?('Green'))
          h='<:Colorless_Unknown:443692132738531328> Colorless' if (wpn1.map{|q| q[0]}.include?('Colorless'))
        end
        if h=='.' && wpn1[0]=='Tome'
          h=wpn1[0][2]
          for l in 0...p1[i].length
            h=untz[untz.find_index{|q2| q2[0]==p1[i][l].gsub(' *[Amiibo]*','').gsub(' *[Assist Trophy]*','').gsub(' *[Mii Costume]*','').gsub(' *[Trophy]*','').gsub(' *[Sticker]*','').gsub(' *[Spirit]*','').gsub('*','')}][1][0] if h != untz[untz.find_index{|q2| q2[0]==p1[i][l]}][1][2]
          end
          h="#{h} Mages"
        end
        p1[i]=[h,p1[i]]
      end
      if p1.map{|q| q[0]}.uniq.length<=1 || p1.map{|q| q[0]}.length>p1.map{|q| q[0]}.uniq.length
        for i in 0...p1.length
          mov=p1[i][1].map{|q| untz[untz.find_index{|q2| q2[0]==q.gsub('Laevatein','Lavatain').gsub('~~','').gsub(' *[Amiibo]*','').gsub(' *[Assist Trophy]*','').gsub(' *[Mii Costume]*','').gsub(' *[Trophy]*','').gsub(' *[Sticker]*','').gsub(' *[Spirit]*','').gsub('*','')}][3]}.uniq
          if mov.length<=1
            p1[i][0]='<:Icon_Move_Infantry:443331187579289601> Infantry' if mov[0]=='Infantry'
            p1[i][0]='<:Icon_Move_Armor:443331186316673025> Armor' if mov[0]=='Armor'
            p1[i][0]='<:Icon_Move_Flier:443331186698354698> Flying' if mov[0]=='Flier'
            p1[i][0]='<:Icon_Move_Cavalry:443331186530451466> Cavalry' if mov[0]=='Cavalry'
          end
        end
      end
      if mode==1
        create_embed(event,"#{"__**Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__",'',0x9400D3,"#{p1.map{|q| q[1].length}.inject(0){|sum,x| sum + x }} total",nil,p1.map{|q| [q[0],q[1].join("\n")]})
      else
        msg=''
        for i in 0...p1.length
          msg=extend_message(msg,"**#{p1[i][0]}** - #{p1[i][1].join(', ')}",event,2)
        end
        event.respond msg
      end
    else
      if k.join("\n").length+mk.join("\n").length<=1900
        if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
          jchar="\n"
          jchar=', ' if k.length>20 && !safe_to_spam?(event)
          event.respond "#{"__**Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__\n#{k.join(jchar)}\n\n#{k.length} total"
        else
          create_embed(event,"#{"__**Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__",'',0x9400D3,"#{k.length} total",nil,triple_finish(k))
        end
      elsif !safe_to_spam?(event)
        event.respond 'There are so many unit results that I would prefer that you post this in PM.'
      else
        t=k[0]
        if k.length>1
          for i in 1...k.length
            t=extend_message(t,k[i],event)
          end
        end
        event.respond t
      end
    end
  end
end

def display_skills(event, mode)
  k=find_in_skills(event,1)
  if k.is_a?(Array)
    mk=k[0]
    k=k[1]
  end
  data_load()
  sklz=@skills.map{|q| q}
  if k.is_a?(Array)
    if k.include?('- - -')
      p1=[[]]
      p2=0
      typesx=[]
      for i in 0...k.length
        unless k[i]=='- - -'
          f=k[i].gsub('~~','').gsub(' *(+) All*','').gsub(' *(+) Effect*','').gsub(' *(+) [Tsfrm]All*','').gsub(' *(+) [Tsfrm]Effect*','').gsub(' *- Transformed*','').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','').gsub('[El]','').gsub('Flux/Ruin/Fenrir[+]','Flux').gsub('Flux/Ruin/Fenrir','Flux').gsub('Flux/Ruin','Flux').gsub('Iron/Steel/Silver[+]','Iron').gsub('[+]','+').gsub('Iron/Steel/Silver','Iron').gsub('Iron/Steel','Iron').gsub('Laevatein','Bladeblade').gsub('*','')
          f=f.split('/')[0] if sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}.nil?
          f=f.split('/')[-1] if sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}.nil?
          typesx.push(sklz[sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}])
        end
      end
      colors=[]
      if typesx.reject{|q| q[4]!='Weapon'}==typesx
        colors.push('Red') if typesx.reject{|q| !q[11].split(', ').include?('Red')}==typesx
        colors.push('Blue') if typesx.reject{|q| !q[11].split(', ').include?('Blue')}==typesx
        colors.push('Green') if typesx.reject{|q| !q[11].split(', ').include?('Green')}==typesx
        colors.push('Colorless') if typesx.reject{|q| !q[11].split(', ').include?('Colorless')}==typesx
      end
      emotes=['<:Gold_Staff:443172811628871720>','<:Gold_Dagger:443172811461230603>','<:Gold_Dragon:443172811641454592>','<:Gold_Bow:443172812492898314>','<:Gold_Beast:532854442299752469>']
      emotes[0]='<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')
      emotes=['<:Red_Staff:443172812455280640>','<:Red_Dagger:443172811490721804>','<:Red_Dragon:443172811796774932>','<:Red_Bow:443172812455280641>','<:Red_Beast:532853459444170753>'] if colors.length==1 && colors[0]=='Red'
      emotes=['<:Blue_Staff:467112472407703553>','<:Blue_Dagger:467112472625545217>','<:Blue_Dragon:467112473313542144>','<:Blue_Bow:467112473313542155>','<:Blue_Beast:532853459842629642>'] if colors.length==1 && colors[0]=='Blue'
      emotes=['<:Green_Staff:467122927616262144>','<:Green_Dagger:467122926655897610>','<:Green_Dragon:467122926718550026>','<:Green_Bow:467122927536570380>','<:Green_Beast:532853459779846154>'] if colors.length==1 && colors[0]=='Green'
      emotes=['<:Colorless_Staff:443692132323295243>','<:Colorless_Dagger:443692132683743232>','<:Colorless_Dragon:443692132415438849>','<:Colorless_Bow:443692132616896512>','<:Colorless_Beast:532853459804749844>'] if colors.length==1 && colors[0]=='Colorless'
      for i in 0...k.length
        if k[i]=='- - -'
          p2+=1
          p1.push([])
        else
          p1[p2].push(k[i])
        end
      end
      for i in 0...p1.length
        typesx=[]
        for i2 in 0...p1[i].length
          unless p1[i][i2]=='- - -'
            f=p1[i][i2].gsub('~~','').gsub(' *(+) All*','').gsub(' *(+) Effect*','').gsub(' *(+) [Tsfrm]All*','').gsub(' *(+) [Tsfrm]Effect*','').gsub(' *- Transformed*','').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','').gsub('[El]','').gsub('Flux/Ruin/Fenrir[+]','Flux').gsub('Flux/Ruin/Fenrir','Flux').gsub('Flux/Ruin','Flux').gsub('Iron/Steel/Silver[+]','Iron').gsub('[+]','+').gsub('Iron/Steel/Silver','Iron').gsub('Iron/Steel','Iron').gsub('Laevatein','Bladeblade').gsub('*','')
            f=f.split('/')[0] if sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}.nil?
            f=f.split('/')[-1] if sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}.nil?
            typesx.push(sklz[sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}])
          end
        end
        types=typesx.map{|q| [q[4],q[5].split(', ')[0],find_base_skill(q,event)]}.uniq
        types2=typesx.map{|q| q[4]}.uniq
        types3=typesx.map{|q| q[3].split(' ')[0].downcase}.uniq
        for j in 0...types.length
          types[j][0]='Passive' if types[j][0].include?('Passive') || types[j][0]=='Seal'
          types[j][2]=nil if ['Passive','Assist','Special'].include?(types[j][0])
          types[j].compact!
        end
        types.uniq!
        h='.'
        if types2.length==1 && types2[0]=='Special'
          m=typesx.map{|q| q[11].split(', ')}
          if m.reject{|q| !q.include?('SupershieldSpecial')}.length>0 && m.reject{|q| !q.include?('SupershieldSpecial')}.length==m.length
            h='<:Special_Defensive_Supershield:454460021066170378> Supershield Specials'
          elsif m.reject{|q| !q.include?('AegisSpecial')}.length>0 && m.reject{|q| !q.include?('AegisSpecial')}.length==m.length
            h='<:Special_Defensive_Aegis:454460020625768470> Aegis Specials'
          elsif m.reject{|q| !q.include?('PaviseSpecial')}.length>0 && m.reject{|q| !q.include?('PaviseSpecial')}.length==m.length
            h='<:Special_Defensive_Pavise:454460020801929237> Pavise Specials'
          elsif m.reject{|q| !q.include?('MiracleSpecial')}.length>0 && m.reject{|q| !q.include?('MiracleSpecial')}.length==m.length
            h='<:Special_Defensive_Miracle:454460020973764610> Miracle Specials'
          elsif m.reject{|q| !q.include?('EclipseSpecial')}.length>0 && m.reject{|q| !q.include?('EclipseSpecial')}.length==m.length
            h='<:Special_Offensive_Eclipse:454473651308199956> Eclipse Specials'
          elsif m.reject{|q| !q.include?('SunSpecial')}.length>0 && m.reject{|q| !q.include?('SunSpecial')}.length==m.length
            h='<:Special_Offensive_Sun:454473651429965834> Sun Specials'
          elsif m.reject{|q| !q.include?('MoonSpecial')}.length>0 && m.reject{|q| !q.include?('MoonSpecial')}.length==m.length
            h='<:Special_Offensive_Moon:454473651345948683> Moon Specials'
          elsif m.reject{|q| !q.include?('StarSpecial')}.length>0 && m.reject{|q| !q.include?('StarSpecial')}.length==m.length
            h='<:Special_Offensive_Star:454473651396542504> Star Specials'
          elsif m.reject{|q| !q.include?('FireSpecial')}.length>0 && m.reject{|q| !q.include?('FireSpecial')}.length==m.length
            h='<:Special_Offensive_Fire:454473651861979156> Fire Specials'
          elsif m.reject{|q| !q.include?('IceSpecial')}.length>0 && m.reject{|q| !q.include?('IceSpecial')}.length==m.length
            h='<:Special_Offensive_Ice:454473651291422720> Ice Specials'
          elsif m.reject{|q| !q.include?('DragonSpecial')}.length>0 && m.reject{|q| !q.include?('DragonSpecial')}.length==m.length
            h='<:Special_Offensive_Dragon:454473651186696192> Dragon Specials'
          elsif m.reject{|q| !q.include?('DarkSpecial')}.length>0 && m.reject{|q| !q.include?('DarkSpecial')}.length==m.length
            h='<:Special_Offensive_Darkness:454473651010535435> Darkness Specials'
          elsif m.reject{|q| !q.include?('RendSpecial')}.length>0 && m.reject{|q| !q.include?('RendSpecial')}.length==m.length
            h='<:Special_Offensive_Rend:454473651119718401> Rend Specials'
          elsif m.reject{|q| !q.include?('Damage')}.length>0 && m.reject{|q| !q.include?('Damage')}.length==m.length
            h='<:Special_Offensive:454460020793278475> Offensive Specials'
          elsif m.reject{|q| !q.include?('Defense')}.length>0 && m.reject{|q| !q.include?('Defense')}.length==m.length
            h='<:Special_Defensive:454460020591951884> Defensive Specials'
          elsif m.reject{|q| !q.include?('AoE')}.length>0 && m.reject{|q| !q.include?('AoE')}.length==m.length
            h='<:Special_AoE:454460021665693696> AoE Specials'
          elsif m.reject{|q| !q.include?('Staff')}.length>0 && m.reject{|q| !q.include?('Staff')}.length==m.length
            h='<:Special_Healer:454451451805040640> Healer Specials'
          else
            h='<:Special_Unknown:454451451603976192> Misc. Specials'
          end
        elsif types2.length==1 && types2[0]=='Assist'
          m=typesx.map{|q| q[11].split(', ')}
          if m.reject{|q| !q.include?('Staff')}.length>0 && m.reject{|q| !q.include?('Staff')}.length==m.length
            h='<:Assist_Staff:454451496831025162> Healing Staves'
          elsif m.reject{|q| !q.include?('Health')}.length>0 && m.reject{|q| !q.include?('Health')}.length==m.length
            h='<:Assist_Health:454462054636584981> Health Assists'
          elsif m.reject{|q| !q.include?('Music')}.length>0 && m.reject{|q| !q.include?('Music')}.length==m.length
            h='<:Assist_Music:454462054959415296> Musical Assists'
          elsif m.reject{|q| !q.include?('Move')}.length>0 && m.reject{|q| !q.include?('Move')}.length==m.length
            h='<:Assist_Move:454462055479508993> Movement Assists'
          elsif m.reject{|q| !q.include?('Rally')}.length>0 && m.reject{|q| !q.include?('Rally')}.length==m.length
            h='<:Assist_Rally:454462054619807747> Rally Assists'
          else
            h='<:Assist_Unknown:454451496482897921> Misc. Assists'
          end
        elsif types2.reject{|q| !q.include?('Passive(S)') && !q.include?('Seal')}==types2 && types3.length==1
          h='<:Great_Badge_Scarlet:443704781001850910> Scarlet Seals' if types3[0]=='scarlet'
          h='<:Great_Badge_Azure:443704780783616016> Azure Seals' if types3[0]=='azure'
          h='<:Great_Badge_Verdant:443704780943261707> Verdant Seals' if types3[0]=='verdant'
          h='<:Great_Badge_Transparent:443704781597573120> Transparent Seals' if types3[0]=='transparent'
          h='<:Great_Badge_Enemy:443704780775227403> Enemy-exclusive Seals' if types3[0]=='gold'
          h='<:Great_Badge_Unknown:443704780754255874> Unknwon Color' if types3[0]=='-'
        elsif (types.length>1 && types.map{|q| q[0]}.uniq.length==1 && types.map{|q| q[0]}.uniq[0]=='Passive') || (types.map{|q| q[0]}.uniq.length==1 && types.map{|q| q[0]}.uniq[0]=='Passive' && (types.map{|q| q[1]}.uniq.length>1 || types[0][1]!='Staff Users Only'))
          h='<:Passive_A:443677024192823327> A Passives' if types2.reject{|q| !q.include?('Passive(A)')}==types2
          h='<:Passive_B:443677023257493506> B Passives' if types2.reject{|q| !q.include?('Passive(B)')}==types2
          h='<:Passive_C:443677023555026954> C Passives' if types2.reject{|q| !q.include?('Passive(C)')}==types2
          h='<:Passive_S:443677023626330122> Passive Seals' if types2.reject{|q| !q.include?('Passive(S)') && !q.include?('Seal')}==types2
          h='<:Passive_W:443677023706152960> Refinement Effects' if types2.reject{|q| !q.include?('Passive(W)')}==types2
        elsif types.length==1
          # staff type
          if types[0][1]=='Staff Users Only'
            h="#{emotes[0]} Damaging Staves" if p1[i].include?('Assault') || types[0][0]=='Weapon'
            h='<:Assist_Staff:454451496831025162> Healing Staves' if p1[i].include?('Heal') || types[0][0]=='Assist'
            h='<:Special_Healer:454451451805040640> Healer Specials' if p1[i].include?('Imbue') || types[0][0]=='Special'
            h='<:Passive_Staff:443677023848890388> Healer Passives' if p1[i].include?('Live to Serve 1/2/3') || types[0][0]=='Passive'
          end
          # weapons
          if types[0][0]=='Weapon'
            # blade type
            h='<:Red_Blade:443172811830198282> Swords' if p1[i].include?('Iron Sword') || p1[i].include?('Iron/Steel Sword') || p1[i].include?('Iron/Steel/Silver Sword') || p1[i].include?('Iron/Steel/Silver[+] Sword') || types[0][1]=='Sword Users Only'
            h='<:Blue_Blade:467112472768151562> Lances' if p1[i].include?('Iron Lance') || p1[i].include?('Iron/Steel Lance') || p1[i].include?('Iron/Steel/Silver Lance') || p1[i].include?('Iron/Steel/Silver[+] Lance') || types[0][1]=='Lance Users Only'
            h='<:Green_Blade:467122927230386207> Axes' if p1[i].include?('Iron Axe') || p1[i].include?('Iron/Steel Axe') || p1[i].include?('Iron/Steel/Silver Axe') || p1[i].include?('Iron/Steel/Silver[+] Axe') || types[0][1]=='Axe Users Only'
            # tome type
            h='<:Fire_Tome:499760605826252800> Fire Magic' if p1[i].include?('Fire') || p1[i].include?('[El]Fire') || p1[i].include?('[El]Fire/Bolganone') || p1[i].include?('[El]Fire/Bolganone[+]') || types[0][2]=='Fire'
            h='<:Dark_Tome:499958772073103380> Dark Magic' if p1[i].include?('Flux') || p1[i].include?('Flux/Ruin') || p1[i].include?('Flux/Ruin/Fenrir') || p1[i].include?('Flux/Ruin/Fenrir[+]') || types[0][2]=='Flux'
            h="<:Red_Tome:443172811826003968> Rau\u00F0r Magic" if p1[i].include?('Raudrblade[+]') || types[0][2]=="Rau\u00F0r"
            h='<:Thunder_Tome:499790911178539009> Thunder Magic' if p1[i].include?('Thunder') || p1[i].include?('[El]Thunder') || p1[i].include?('[El]Thunder/Thoron') || p1[i].include?('[El]Thunder/Thoron[+]') || types[0][2]=='Thunder'
            h='<:Light_Tome:499760605381787650> Light Magic' if p1[i].include?('Light') || p1[i].include?('[El]Light') || p1[i].include?('[El]Light/Shine') || p1[i].include?('[El]Light/Shine[+]') || types[0][2]=='Light'
            h="<:Blue_Tome:467112472394858508> Bl\u00E1r Magic" if p1[i].include?('Blarblade[+]') || types[0][2]=="Bl\u00E1r"
            h='<:Wind_Tome:499760605713137664> Wind Magic' if p1[i].include?('Wind') || p1[i].include?('[El]Wind') || p1[i].include?('[El]Wind/Rexcalibur') || p1[i].include?('[El]Wind/Rexcalibur[+]') || types[0][2]=='Wind'
            h='<:Green_Tome:467122927666593822> Gronn Magic' if p1[i].include?('Gronnblade[+]') || types[0][2]=='Gronn'
            # Breaths
            h="#{emotes[2]} Dragon Breaths" if p1[i].include?('Fire Breath[+]') || types[0][1]=='Dragons Only'
            # Beasts
            h="#{emotes[4]} Beast Damage" if types[0][1]=='Beasts Only'
            # Bows
            h="#{emotes[3]} Bows" if p1[i].include?('Iron Bow') || p1[i].include?('Iron/Steel Bow') || p1[i].include?('Iron/Steel/Silver Bow') || p1[i].include?('Iron/Steel/Silver[+] Bow') || types[0][1]=='Bow Users Only'
            # daggers
            h="#{emotes[1]} Daggers" if p1[i].include?('Iron Dagger') || p1[i].include?('Iron/Steel Dagger') || p1[i].include?('Iron/Steel/Silver Dagger') || p1[i].include?('Iron/Steel/Silver[+] Dagger') || types[0][1]=='Dagger Users Only'
          end
        elsif types.length>1 && types.map{|q| [q[0],q[1]]}.uniq.length==1
          h='<:Red_Blade:443172811830198282> Swords' if p1[i].include?('Iron Sword') || p1[i].include?('Iron/Steel Sword') || p1[i].include?('Iron/Steel/Silver Sword') || p1[i].include?('Iron/Steel/Silver[+] Sword') || types[0][1]=='Sword Users Only'
          h='<:Blue_Blade:467112472768151562> Lances' if p1[i].include?('Iron Lance') || p1[i].include?('Iron/Steel Lance') || p1[i].include?('Iron/Steel/Silver Lance') || p1[i].include?('Iron/Steel/Silver[+] Lance') || types[0][1]=='Lance Users Only'
          h='<:Green_Blade:467122927230386207> Axes' if p1[i].include?('Iron Axe') || p1[i].include?('Iron/Steel Axe') || p1[i].include?('Iron/Steel/Silver Axe') || p1[i].include?('Iron/Steel/Silver[+] Axe') || types[0][1]=='Axe Users Only'
          h='<:Red_Tome:443172811826003968> Red Tomes' if types.map{|q| q[2]}.include?('Fire') && types.map{|q| q[2]}.include?('Flux')
          h='<:Blue_Tome:467112472394858508> Blue Tomes' if types.map{|q| q[2]}.include?('Thunder') && types.map{|q| q[2]}.include?('Light')
          h='<:Green_Tome:467122927666593822> Green Tomes' if types.map{|q| q[2]}.include?('Wind') && types.map{|q| q[2]}.include?('Gronn')
          h='<:Red_Tome:443172811826003968> Red Tomes' if types[0][1]=='Red Tome Users Only'
          h='<:Blue_Tome:467112472394858508> Blue Tomes' if types[0][1]=='Blue Tome Users Only'
          h='<:Green_Tome:467122927666593822> Green Tomes' if types[0][1]=='Green Tome Users Only'
          h="#{emotes[2]} Dragon Breaths" if p1[i].include?('Fire Breath[+]') || types[0][1]=='Dragons Only'
          h="#{emotes[4]} Beast Damage" if types[0][1]=='Beasts Only'
          h="#{emotes[3]} Bows" if p1[i].include?('Iron Bow') || p1[i].include?('Iron/Steel Bow') || p1[i].include?('Iron/Steel/Silver Bow') || p1[i].include?('Iron/Steel/Silver[+] Bow') || types[0][1]=='Bow Users Only'
          h="#{emotes[1]} Daggers" if p1[i].include?('Iron Dagger') || p1[i].include?('Iron/Steel Dagger') || p1[i].include?('Iron/Steel/Silver Dagger') || p1[i].include?('Iron/Steel/Silver[+] Dagger') || types[0][1]=='Dagger Users Only'
        end
        p1[i]=[h,p1[i].join("\n")]
      end
      if mode==1
        create_embed(event,"#{"__**Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__",'',0x9400D3,"#{p1.map{|q| q[1].split("\n")}.join("\n").split("\n").uniq.length} total",nil,p1)
      else
        msg=''
        for i in 0...p1.length
          msg=extend_message(msg,"**#{p1[i][0]}** - #{p1[i][1].gsub("\n",', ')}",event,2)
        end
        event.respond msg
      end
    else
      if k.join("\n").length<=1900
        if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
          jchar="\n"
          jchar=', ' if k.length>20 && !safe_to_spam?(event)
          event.respond "#{"__**Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__\n#{k.join(jchar)}\n\n#{k.length} total"
        else
          create_embed(event,"#{"__**Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__",'',0x9400D3,"#{k.length} total",nil,triple_finish(k))
        end
      else
        t=k[0]
        if k.length>1
          for i in 1...k.length
            t=extend_message(t,k[i],event)
          end
        end
        event.respond t
      end
    end
  elsif !safe_to_spam?(event)
  else
    t=k[0]
    if k.is_a?(Array) && k.length>1
      for i in 1...k.length
        st=extend_message(t,k[i],event)
      end
    end
    event.respond t
  end
end

def sort_units(bot,event,args=[])
  args=event.message.text.downcase.split(' ') if args.nil? || args.length.zero?
  event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  f=[0,0,0,0,0,0,0,0,0,0]
  supernatures=[]
  for i in 0...args.length # find stat names, retain the order in which they're listed.
    supernatures.push('+HP') if ['hpboon','healthboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('+Atk') if ['atkboon','attboon','attackboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('+Spd') if ['spdboon','speedboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('+Def') if ['defboon','defenseboon','defenceboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('+Res') if ['resboon','resistanceboon'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-HP') if ['hpbane','healthbane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-Atk') if ['atkbane','attbane','attackbane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-Spd') if ['spdbane','speedbane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-Def') if ['defbane','defensebane','defencebane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    supernatures.push('-Res') if ['resbane','resistancebane'].include?(args[i].downcase.gsub('+','').gsub('-',''))
    v=0
    v=1 if ['hp','health'].include?(args[i].downcase)
    v=2 if ['str','strength','strong','mag','magic','atk','att','attack'].include?(args[i].downcase)
    v=3 if ['spd','speed'].include?(args[i].downcase)
    v=4 if ['def','defense','defence','defensive','defencive'].include?(args[i].downcase)
    v=5 if ['res','resistance'].include?(args[i].downcase)
    v=6 if ['bst','base','total'].include?(args[i].downcase)
    v=7 if ['chill','frostbite','freeze','cold','frz','antifreeze','antifrz','frzprotect','lower','lowerdefres','lowerdefenseresistance','lowerdefenceresistance','lowerdef','lowerres','loweres'].include?(args[i].downcase)
    v=8 if ['photon','light','shine','defresdifference','defenseresistancedifference','defenceresistancedifference','defresdiff','defenseresistancediff','defenceresistancediff'].include?(args[i].downcase)
    v=9 if ['bin','score','arena'].include?(args[i].downcase)
    if v>0 && !f.include?(v)
      v2=0
      for i2 in 0...f.length
        if f[i2].zero? && v2.zero? && !f.include?(v)
          f[i2]=v
          v2=i2
        end
      end
    end
  end
  if supernatures.include?('+HP') || supernatures.include?('-HP')
    f.push(1) unless f.include?(1)
  end
  if supernatures.include?('+Atk') || supernatures.include?('-Atk')
    f.push(2) unless f.include?(2)
  end
  if supernatures.include?('+Spd') || supernatures.include?('-Spd')
    f.push(3) unless f.include?(3)
  end
  if supernatures.include?('+Def') || supernatures.include?('-Def')
    f.push(4) unless f.include?(4)
  end
  if supernatures.include?('+Res') || supernatures.include?('-Res')
    f.push(5) unless f.include?(5)
  end
  k2=find_in_units(event,13,false,true) # Narrow the list of units down based on the defined parameters
  if k2.is_a?(Array)
    mk=k2[0]
    k2=k2[1]
  end
  mk.push("*Sorted by:* #{f[0,10].uniq.map{|q| ['Name','HP','Atk','Spd','Def','Res','BST','FrzProtect','Photon Points',nil][q]}.compact.join(', ')}")
  v=mk.find_index{|q| q[0,8]=='*Stats:*'}
  unless v.nil?
    v=mk[v]
    if v.include?('HP')
      f.push(1) unless f.include?(1)
    end
    if v.include?('Atk')
      f.push(2) unless f.include?(2)
    end
    if v.include?('Spd')
      f.push(3) unless f.include?(3)
    end
    if v.include?('Def')
      f.push(4) unless f.include?(4)
    end
    if v.include?('Res')
      f.push(5) unless f.include?(5)
    end
  end
  if args.map{|q| q.downcase}.include?('stats')
    f.push(1) unless f.include?(1)
    f.push(2) unless f.include?(2)
    f.push(3) unless f.include?(3)
    f.push(4) unless f.include?(4)
    f.push(5) unless f.include?(5)
  end
  event.channel.send_temporary_message('Units found, sorting now...',3)
  g=get_markers(event)
  u=@units.map{|q| q}
  k=k2.reject{|q| !has_any?(g, q[13][0])}.uniq if k2.is_a?(Array)
  k=u.reject{|q| !has_any?(g, q[13][0])}.sort{|a,b| a[0]<=>b[0]}.uniq unless k2.is_a?(Array)
  t=0
  b=0
  for i in 0...args.length
    if args[i].downcase[0,3]=='top' && t.zero?
      t=[args[i][3,args[i].length-3].to_i,k.length].min
    elsif args[i].downcase[0,6]=='bottom' && b.zero?
      b=[args[i][6,args[i].length-6].to_i,k.length].min
    end
  end
  for i in 0...k.length # remove any units who don't have known stats yet
    k[i]=nil if k[i][5].nil? || k[i][5].max<=0
  end
  s=['','HP','Attack','Speed','Defense','Resistance','BST','FrzProtect','Photon Points','Bin']
  k.compact!
  k=k.reject {|q| find_unit(q[0],event)<0}
  if f.include?(6) || f.include?(7) || f.include?(8) || f.include?(9)
    for i in 0...k.length
      k[i][5][5]=k[i][5][0]+k[i][5][1]+k[i][5][2]+k[i][5][3]+k[i][5][4]
      k[i][5][6]=[k[i][5][3],k[i][5][4]].min
      k[i][5][7]=k[i][5][3]-k[i][5][4]
      k[i][5][8]=k[i][5][5]/5
    end
  end
  k=k.reject{|q| !q[13][0].nil?} if t>0 || b>0
  k.sort! {|b,a| (supersort(a,b,5,f[0]-1)) == 0 ? ((supersort(a,b,5,f[1]-1)) == 0 ? ((supersort(a,b,5,f[2]-1)) == 0 ? ((supersort(a,b,5,f[3]-1)) == 0 ? ((supersort(a,b,5,f[4]-1)) == 0 ? ((supersort(a,b,5,f[5]-1)) == 0 ? ((supersort(a,b,5,f[6]-1)) == 0 ? ((supersort(a,b,5,f[7]-1)) == 0 ? (((supersort(a,b,5,f[8]-1)) == 0 ? (supersort(a,b,0)) : (supersort(a,b,5,f[8]-1)))) : (supersort(a,b,5,f[7]-1))) : (supersort(a,b,5,f[6]-1))) : (supersort(a,b,5,f[5]-1))) : (supersort(a,b,5,f[4]-1))) : (supersort(a,b,5,f[3]-1))) : (supersort(a,b,5,f[2]-1))) : (supersort(a,b,5,f[1]-1))) : (supersort(a,b,5,f[0]-1))}
  m="#{"__**Search**__\n#{mk.join("\n")}\n\n__**Additional Notes**__\n" if mk.length>0}Please note that the stats listed are for neutral-nature units without stat-affecting skills.\n"
  if f.include?(2)
    m="#{m}The Strength/Magic stat also does not account for weapon might.\n"
  end
  display=[0,k.length]
  if t>0
    display=[0,t]
  elsif b>0
    display=[k.length-b,k.length]
  end
  if safe_to_spam?(event)
  elsif k2==-1 && display[0].zero? && display[1]==k.length
    m="#{m}The Strength/Magic stat also does not account for weapon might.\n"
  elsif !k2.is_a?(Array) && display[0].zero? && display[1]==k.length
    return false
  end
  m2=[]
  for i in display[0]...display[1]
    ls=[]
    for j in 0...f.length
      sf=s[f[j]]
      if f[j]==2 # give the proper attack stat name
        if ['Healer','Tome'].include?(k[i][1][1])
          sf='Magic'
        elsif ['Dragon'].include?(k[i][1][1])
          sf='Magic'
        elsif ['Blade','Dagger','Bow'].include?(k[i][1][1])
          sf='Strength'
        end
      end
      sfn=''
      if f[j]<6 && !(k[i][4].nil? || k[i][4].max<=0)
        sfn='(+) ' if [-3,1,5,10,14].include?(k[i][4][f[j]-1])
        sfn='(-) ' if [-2,2,6,11,15].include?(k[i][4][f[j]-1])
      end
      if k[i][5][f[j]-1]<0 && sf.length>0
        k[i][5][f[j]-1]=0-k[i][5][f[j]-1]
        sf="Anti#{sf[0,1].downcase}#{sf[1,sf.length-1]}"
        ls.push("#{k[i][5][f[j]-1]} #{sfn}#{sf}")
      elsif f[j]==9
        ls.push("#{sf} ##{k[i][5][f[j]-1]} (#{k[i][5][f[j]-1]*5}-#{k[i][5][f[j]-1]*5+4})")
      elsif f[j]==8 && k[i][5][f[j]-1]>=5
        ls.push("*#{k[i][5][f[j]-1]} #{sfn}#{sf}*") if sf.length>0
      else
        ls.push("#{k[i][5][f[j]-1]} #{sfn}#{sf}") if sf.length>0
      end
    end
    m2.push("#{'~~' if !k[i][13][0].nil?}**#{k[i][0]}**#{unit_moji(bot,event,-1,k[i][0])} - #{ls.join(', ')}#{'~~' if !k[i][13][0].nil?}")
  end
  if (f.include?(1) || f.include?(2) || f.include?(3) || f.include?(4) || f.include?(5)) && m2.join("\n").include?("(+)") && m2.join("\n").include?("(-)")
    m="#{m}\n(+) and (-) mark units for whom a boon or unmerged bane would increase or decrease a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  elsif (f.include?(1) || f.include?(2) || f.include?(3) || f.include?(4) || f.include?(5)) && m2.join("\n").include?("(+)")
    m="#{m}\n(+) marks units for whom a boon would increase a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  elsif (f.include?(1) || f.include?(2) || f.include?(3) || f.include?(4) || f.include?(5)) && m2.join("\n").include?("(-)")
    m="#{m}\n(-) marks units for whom an unmerged bane would decrease a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  end
  if f.include?(7) || f.include?(8) || f.include?(9)
    m="#{m}\nFrzProtect is the lower of the units' Defense and Resistance stats, used by dragonstones when attacking ranged units and by Felicia's Plate all the time." if f.include?(7)
    m="#{m}\nLight Brand deals +7 damage to units with at least 5 Photon Points." if f.include?(8)
    m="#{m}\nThe order of units listed here can be affected by natures#{" that affect a unit's Defense and/or Resistance" unless f.include?(9)}.\n"
  end
  if "#{m}\n#{m2.join("\n")}".length>2000 && !safe_to_spam?(event)
    m="#{m}\nToo much data is trying to be displayed.  Showing top ten results.\nYou can also make things easier by making the list shorter with words like `top#{rand(10)+1}` or `bottom#{rand(10)+1}`\nAlternatively, you can narrow by specific stats with words like `#{['HP','Atk','Spd','Def','Res'].sample}#{['>','<'].sample}#{rand(20)+15}`\n"
    m2=m2[0,10]
  end
  for i in 0...m2.length
    m=extend_message(m,m2[i],event)
  end
  event.respond m
  return nil
end

def sort_skills(bot,event,args=[])
  args=event.message.text.downcase.split(' ') if args.nil? || args.length.zero?
  event.channel.send_temporary_message('Calculating data, please wait...',5)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k=find_in_skills(event, 2, false)
  if k.is_a?(Array)
    mk=k[0]
    k=k[1]
  end
  if k.is_a?(Array)
    k=k.reject{|q| q[0][0,14]=='Initiate Seal ' || q[0][0,10]=='Squad Ace '}
    for i in 0...k.length
      if k[i][15].nil? || !k[i][15].is_a?(String) || k[i][15].length.zero?
        k[i][15]=0
      elsif k[i][6]=='-' || k[i][6].split(', ').length.zero?
        k[i][15]=350
      else
        k[i][15]=400
      end
      if k[i][0].include?("*(+) Effect*") || k[i][0].include?("*(+) All*")
        k[i][1]=k[i][15]*1
        k[i][15]=0
      end
    end
    k.sort! {|b,a| ((a[1] <=> b[1]) == 0 ? ((a[15] <=> b[15]) == 0 ? (b[0] <=> a[0]) : (a[15] <=> b[15])) : (a[1] <=> b[1]))}
    str="#{"__**Search**__\n#{mk.join("\n")}\n\n__**Additional Notes**__\n" if mk.length>0}All SP costs are without accounting for increased inheritance costs (1.5x the SP costs listed below)"
    for i in 0...k.length
      k[i][0]="**#{k[i][0]}** #{skill_moji(k[i],event,bot)}"
      k[i][0]="#{k[i][0]} - #{k[i][1]} SP"
      if k[i][15]>k[i][1] && k[i][1]>0 && k[i][4]=='Weapon'
        k[i][0]="#{k[i][0]} (#{k[i][15]} SP when refined)"
      elsif k[i][15]==k[i][1] && k[i][1]>0 && k[i][4]=='Weapon'
        k[i][0]="#{k[i][0]} (refinement possible)"
      end
      k[i][0]="#{k[i][0]} - Prf to #{k[i][6]}" unless k[i][6]=='-' || k[i][6].split(', ').length.zero?
    end
    if k.map{|q| q[0]}.join("\n").length+str.length>1950 && !safe_to_spam?(event)
      str="#{str}\n\nThere are too many skills to list.  Please try this command in PM.\nShowing top ten results."
      k=k[0,10]
    end
    for i in 0...k.length
      str=extend_message(str,"#{"\n" if i==0}#{k[i][0]}",event)
    end
    event.respond str
  end
end

def get_bond_name(event)
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHBondNames.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHBondNames.txt').each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  k=b.sample
  return get_bond_name(event) if find_unit(k,event,true)>=0 # filter out actual names of units
  return k
end

def get_games_list(arr,includefeh=true)
  g=[]
  lookout=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHGames.txt')
    lookout=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHGames.txt').each_line do |line|
      lookout.push(eval line)
    end
  end
  for i in 0...arr.length
    for i2 in 0...lookout.length
      g.push(lookout[i2][2]) if lookout[i2][0]==arr[i]
    end
  end
  g.push('FEH - *Fire Emblem: Heroes* (obviously)') if !g.include?('FEH - *Fire Emblem: Heroes*') && includefeh && g.length>0
  g.push('No games') if g.length<=0
  return g
end

def comparison(event,args,bot)
  newmerge=false
  newmerge=true if event.message.text.downcase.split(' ').include?('feb') || event.message.text.downcase.split(' ').include?('february')
  t=Time.now
  newmerge=nil if t.year>2019
  newmerge=nil if t.year==2019 && t.month>2
  newmerge=nil if t.year==2019 && t.month==2 && t.day>8
  event.channel.send_temporary_message('Calculating data, please wait...',3)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  s1=args.join(' ').gsub(',','').gsub('/','').downcase.gsub('laevatein','lavatain')
  s2=args.join(' ').gsub(',','').gsub('/','').downcase.gsub('laevatein','lavatain')
  if s1.include?('|')
    f=s1.gsub(' |','|').gsub('| ','|').split('|')
    b=[]
    c=[]
    atkstat=[]
    for i in 0...f.length
      x=detect_multi_unit_alias(event,f[i],f[i],1)
      if !x.nil? && x[1].length>1
        r=find_stats_in_string(event,f[i])
        for i2 in 0...x[1].length
          name=x[1][i2]
          u=@units[find_unit(name,event)]
          st=get_stats(event,name,40,r[0],r[1],r[2],r[3])
          st[0]=st[0].gsub('Lavatain','Laevatein')
          m=false
          uemoji=unit_moji(bot,event,-1,name,m,2,f[i])
          b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}",(m && find_in_dev_units(name)>=0),r[0],uemoji])
          c.push(unit_color(event,find_unit(name,event),nil,1,m))
          atkstat.push('Strength') if ['Blade','Bow','Dagger'].include?(u[1][1])
          atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
          atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
        end
      elsif find_name_in_string(event,f[i])!=nil
        name=find_name_in_string(event,f[i])
        r=find_stats_in_string(event,f[i])
        u=@units[find_unit(find_name_in_string(event,f[i]),event)]
        m=false
        uid=-1
        if f[i].downcase.split(' ').include?("mathoo's") && find_in_dev_units(name)>=0
          m=true
          dv=@dev_units[find_in_dev_units(name)]
          r[0]=dv[1]
          r[1]=dv[2]
          r[2]=dv[3].gsub(' ','')
          r[3]=dv[4].gsub(' ','')
          r[2]='' if r[2].nil?
          r[3]='' if r[3].nil?
        elsif donate_trigger_word(event,f[i])>0
          uid=donate_trigger_word(event,f[i])
          x=donor_unit_list(uid)
          x2=x.find_index{|q| q[0]==name}
          unless x2.nil?
            r[0]=x[x2][1]
            r[1]=x[x2][2]
            r[2]=x[x2][3].gsub(' ','')
            r[3]=x[x2][4].gsub(' ','')
            r[2]='' if r[2].nil?
            r[3]='' if r[3].nil?
          end
        end
        st=get_stats(event,name,40,r[0],r[1],r[2],r[3])
        st[0]=st[0].gsub('Lavatain','Laevatein')
        uemoji=unit_moji(bot,event,-1,name,m,2,uid)
        b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}",(m && find_in_dev_units(name)>=0),r[0],uemoji])
        c.push(unit_color(event,find_unit(find_name_in_string(event,f[i]),event),nil,1,m))
        atkstat.push('Strength') if ['Blade','Bow','Dagger'].include?(u[1][1])
        atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
        atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
      end
    end
  else
    for i in 0...args.length
      unless s1.split(' ').nil? || s1.gsub(' ','').length<=0
        k=find_name_in_string(event,s1,1)
        unless k.nil?
          s1=first_sub(s1,k[1],'')
          s2=first_sub(s2,k[1],k[0])
        end
      end
    end
    k=splice(s2)
    k2=[]
    for i in 0...k.length
      x=detect_multi_unit_alias(event,k[i],k[i],1)
      str=k[i]
      if k[i].downcase=="mathoo's" || donate_trigger_word(event,k[i])>0
        k2.push(str)
      elsif !x.nil? && x[1].is_a?(Array) && x[1].length>1
        if (i>0 && !detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]}",1).nil?) || (i<k.length-1 && !detect_multi_unit_alias(event,k[i],"#{k[i]} #{k[i+1]}",1).nil?) || (i>0 && i<k.length-1 && !detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}",1).nil?) || !detect_multi_unit_alias(event,k[i],"#{k[i]}",1).nil?
          if i>0 && i<k.length-1 && !detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}",1).nil?
            x=detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}",1)
          elsif i>0 && !detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]}",1).nil?
            x=detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]}",1)
          elsif i<k.length-1 && !detect_multi_unit_alias(event,k[i],"#{k[i]} #{k[i+1]}",1).nil?
            x=detect_multi_unit_alias(event,k[i],"#{k[i]} #{k[i+1]}",1)
          elsif !detect_multi_unit_alias(event,k[i],"#{k[i]}",1).nil?
            x=detect_multi_unit_alias(event,k[i],"#{k[i]}",1)
          end
          if x[1].is_a?(Array) && x[1].length>1
            for i in 0...x[1].length
              k2.push(str.downcase.gsub(x[0],x[1][i]))
            end
          else
            k2.push(str.downcase.gsub(x[0],x[1][0]))
          end
        end
      elsif find_name_in_string(event,sever(k[i]))!=nil
        x=find_name_in_string(event,sever(str),1)
        k2.push(str)
      elsif !x.nil? && !x[1].is_a?(Array)
        k2.push(str)
      end
    end
    k=k2.map{|q| q}
    b=[]
    c=[]
    atkstat=[]
    m=false
    did=-1
    for i in 0...k.length
      if find_name_in_string(event,sever(k[i]))!=nil
        r=find_stats_in_string(event,sever(k[i]))
        u=@units[find_unit(find_name_in_string(event,sever(k[i])),event)]
        name=u[0]
        sup='-'
        if m && find_in_dev_units(name)>=0
          dv=@dev_units[find_in_dev_units(name)]
          r[0]=dv[1]
          r[1]=dv[2]
          r[2]=dv[3].gsub(' ','')
          r[3]=dv[4].gsub(' ','')
          sup=dv[5]
          r[2]='' if r[2].nil?
          r[3]='' if r[3].nil?
        elsif did>0
          x=donor_unit_list(did)
          x2=x.find_index{|q| q[0]==name}
          unless x2.nil?
            r[0]=x[x2][1]
            r[1]=x[x2][2]
            r[2]=x[x2][3].gsub(' ','')
            r[3]=x[x2][4].gsub(' ','')
            sup=x[x2][5]
            r[2]='' if r[2].nil?
            r[3]='' if r[3].nil?
          end
        end
        st=get_stats(event,name,40,r[0],r[1],r[2],r[3])
        st[0]=st[0].gsub('Lavatain','Laevatein')
        uemoji=unit_moji(bot,event,-1,name.gsub('Laevatein','Lavatain'),m,2,did)
        rstar=@rarity_stars[r[0]-1]
        rstar=['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>','<:Icon_Rarity_4p10:448272714210476033>','<:Icon_Rarity_5p10:448272715099406336>','<:Icon_Rarity_6p10:491487784822112256>'][r[0]-1] if r[1]>=10
        rstar='<:Icon_Rarity_S:448266418035621888>' unless sup=='-'
        rstar='<:Icon_Rarity_Sp10:448272715653054485>' if sup != '-' && r[1]>=10
        b.push([st,"#{r[0]}#{rstar}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}",(m && find_in_dev_units(name)>=0),r[0],uemoji,r[1]])
        c.push(unit_color(event,find_unit(find_name_in_string(event,sever(k[i])),event),nil,1,m))
        atkstat.push('Strength') if ['Blade','Bow','Dagger'].include?(u[1][1])
        atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
        atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
      elsif k[i].downcase=="mathoo's"
        m=true
      elsif donate_trigger_word(event,k[i])>0
        did=donate_trigger_word(event,k[i])
      end
    end
  end
  if b.uniq.length != b.length
    event.channel.send_temporary_message('Duplicate units found, removing duplicates..',3)
    sleep 1
    b.uniq!
  end
  if b.length==1 && !['unit','stats'].include?(event.message.text.downcase.split(' ')[0].gsub('feh!','').gsub('feh?','').gsub('f?','').gsub('e?','').gsub('h?',''))
    event.respond "I need at least two units in order to compare anything.\nInstead, I will show you the results of the `study` command, which is similar to `compare` but for one unit."
    unit_study(event,name,bot)
    return 1
  elsif b.length<2
    event.respond 'I need at least two units in order to compare anything.'
    return 0
  elsif b.length>2
    stzzz=['BST','HP','Attack','Speed','Defense','Resistance']
    stemoji=['','<:HP_S:514712247503945739>','<:GenericAttackS:514712247587569664>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
    if atkstat.uniq.length==1
      stemoji[2]='<:StrengthS:514712248372166666>' if atkstat.uniq[0]=='Strength'
      stemoji[2]='<:MagicS:514712247289774111>' if atkstat.uniq[0]=='Magic'
      stemoji[2]='<:FreezeS:514712247474585610>' if atkstat.uniq[0]=='Freeze'
    end
    dzz=[]
    czz=[]
    hstats=[[0,[]],[0,[]],[0,[]],[0,[]],[0,[]],[0,[]]]
    event.respond "I detect #{b.length} names.\nUnfortunately, due to embed limits, I can only compare ten names\nand due to the formatting of this command, plaintext is not an answer." if b.length>10
    b=b[0,10] if b.length>10
    data_load()
    uu=@units.map{|q| q}
    bse=b.map{|q| uu[uu.find_index{|q2| q2[0].gsub('Lavatain','Laevatein')==q[0][0]}][12].split(', ')[0].gsub('*','')}.uniq
    for iz in 0...b.length
      dzz.push(["**#{b[iz][1].gsub('Lavatain','Laevatein')}**",[b[iz][4]],0])
      czz.push(c[iz])
      for jz in 1...6
        stz=b[iz][0][jz]
        dzz[iz][2]+=stz
        s=''
        s=' (+)' if [-3,1,5,10,14].include?(b[iz][0][jz+5]) && b[iz][3]==5
        s=' (-)' if [-2,2,6,11,15].include?(b[iz][0][jz+5]) && b[iz][3]==5
        s=' (+)' if [-2,10].include?(b[iz][0][jz+5]) && b[iz][3]==4
        s=' (-)' if [-1,11].include?(b[iz][0][jz+5]) && b[iz][3]==4
        s='' if s==' (-)' && newmerge != false && b[iz][5]>0
        s='' unless b.reject{|q| q[1][q[1].length-10,10]==' (neutral)'}.length<=0
        dzz[iz][1].push("#{stzzz[jz]}: #{stz}#{s}")
        if stz>hstats[jz][0]
          hstats[jz][0]=stz
          hstats[jz][1]=[b[iz][0][0]]
        elsif stz==hstats[jz][0]
          hstats[jz][1].push(b[iz][0][0])
        end
      end
      dzz[iz][1]="#{dzz[iz][1].join("\n")}\n\nBST: #{dzz[iz][2]}"
      if dzz[iz][2]>hstats[0][0]
        hstats[0][0]=dzz[iz][2]
        hstats[0][1]=[b[iz][0][0]]
      elsif dzz[iz][2]==hstats[0][0]
        hstats[0][1].push(b[iz][0][0])
      end
      dzz[iz][2]=nil
      dzz[iz].compact!
    end
    dzz.push(['<:Ally_Boost_Spectrum:443337604054646804> Analysis',[]])
    for iz in 1...6
      if hstats[iz][1].length>=[b.length, 10].min
        dzz[dzz.length-1][1].push("#{stemoji[iz]} Constant #{stzzz[iz]}: #{hstats[iz][0]}")
      else
        dzz[dzz.length-1][1].push("#{stemoji[iz]} Highest #{stzzz[iz]}: #{hstats[iz][0]} (#{hstats[iz][1].join(', ')})")
      end
    end
    dzz[dzz.length-1][1].push('')
    if hstats[0][1].length>=[b.length, 10].min
      dzz[dzz.length-1][1].push("Constant BST: #{hstats[0][0]}")
    else
      dzz[dzz.length-1][1].push("Highest BST: #{hstats[0][0]} (#{hstats[0][1].join(', ')})")
    end
    dzz[dzz.length-1][1].push("BST of highest stats: #{hstats[1][0]+hstats[2][0]+hstats[3][0]+hstats[4][0]+hstats[5][0]}")
    dzz[dzz.length-1][1]=dzz[dzz.length-1][1].join("\n")
    ftr=nil
    if bse.include?('Elise') && bse.include?('Nino') && bse.reject{|q| ['Elise','Nino'].include?(q)}.length<=0
      metadata_load()
      ftr="Heyday Coefficient: #{(@server_data[0].inject(0){|sum,x| sum + x }/701.0).round(4)}"
    end
    create_embed(event,'**Comparing units**','',avg_color(czz),ftr,nil,dzz,-2)
    return b.length
  end
  stzzz=['','HP','Attack','Speed','Defense','Resistance']
  stemoji=['','<:HP_S:514712247503945739>','<:GenericAttackS:514712247587569664>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
  if atkstat.uniq.length==1
    stemoji[2]='<:StrengthS:514712248372166666>' if atkstat.uniq[0]=='Strength'
    stemoji[2]='<:MagicS:514712247289774111>' if atkstat.uniq[0]=='Magic'
    stemoji[2]='<:FreezeS:514712247474585610>' if atkstat.uniq[0]=='Freeze'
  end
  d1=[b[0][1].gsub('Lavatain','Laevatein'),[b[0][4]],0]
  d2=[b[1][1].gsub('Lavatain','Laevatein'),[b[1][4]],0]
  d3=['<:Ally_Boost_Spectrum:443337604054646804> Analysis',[]]
  names=["#{b[0][0][0]}","#{b[1][0][0]}"]
  xpic=nil
  if names.uniq.length<=1
    xpic=pick_thumbnail(event,find_unit(b[0][0][0],event),bot)
    mll=[b[0][1].split(' '), b[1][1].split(' ')]
    if mll[0][mll[0].length-1][mll[0][mll[0].length-1].length-1,1]==')' && mll[0][mll[0].length-1][0,1]!='('
      mll[0][mll[0].length-2]="#{mll[0][mll[0].length-2]} #{mll[0][mll[0].length-1]}"
      mll[0].pop
    end
    if mll[1][mll[1].length-1][mll[1][mll[1].length-1].length-1,1]==')' && mll[1][mll[1].length-1][0,1]!='('
      mll[1][mll[1].length-2]="#{mll[1][mll[1].length-2]} #{mll[1][mll[1].length-1]}"
      mll[1].pop
    end
    if mll[0][0]==mll[1][0]
      mll[0][0]=nil
      mll[1][0]=nil
    end
    if mll[0][2]==mll[1][2]
      mll[0][2]=nil
      mll[1][2]=nil
    end
    if mll[0][3]==mll[1][3]
      mll[0][3]=nil
      mll[1][3]=nil
    end
    names=["#{mll[0].compact.join(' ')}","#{mll[1].compact.join(' ')}"]
    if b[0][2] && !b[1][2]
      names[0]="Mathoo's #{b[0][0][0]}"
      names[1]="Neutral #{b[1][0][0]}" if names[1]=="#{b[1][0][0]} (neutral)"
    end
    if !b[0][2] && b[1][2]
      names[1]="Mathoo's #{b[1][0][0]}" if b[1][2]
      names[0]="Neutral #{b[0][0][0]}" if names[0]=="#{b[0][0][0]} (neutral)"
    end
  end
  for i in 1...6
    s=''
    s=' (+)' if [-3,1,5,10,14].include?(b[0][0][i+5]) && b[0][3]==5
    s=' (-)' if [-2,2,6,11,15].include?(b[0][0][i+5]) && b[0][3]==5
    s=' (+)' if [-2,10].include?(b[0][0][i+5]) && b[0][3]==4
    s=' (-)' if [-1,11].include?(b[0][0][i+5]) && b[0][3]==4
    s='' if s==' (-)' && newmerge != false && b[0][5]>0
    s='' unless b[0][1][b[0][1].length-10,10]==' (neutral)' && b[1][1][b[1][1].length-10,10]==' (neutral)' && !names[0].include?("Mathoo's ")
    d1[1].push("#{stzzz[i]}: #{b[0][0][i]}#{s}")
    s=''
    s=' (+)' if [-3,1,5,10,14].include?(b[1][0][i+5]) && b[1][3]==5
    s=' (-)' if [-2,2,6,11,15].include?(b[1][0][i+5]) && b[1][3]==5
    s=' (+)' if [-2,10].include?(b[1][0][i+5]) && b[1][3]==4
    s=' (-)' if [-1,11].include?(b[1][0][i+5]) && b[1][3]==4
    s='' if s==' (-)' && newmerge != false && b[1][5]>0
    s='' unless b[0][1][b[0][1].length-10,10]==' (neutral)' && b[1][1][b[1][1].length-10,10]==' (neutral)' && !names[1].include?("Mathoo's ")
    d2[1].push("#{stzzz[i]}: #{b[1][0][i]}#{s}")
    d1[2]+=b[0][0][i]
    d2[2]+=b[1][0][i]
    if b[0][0][i]==b[1][0][i]
      d3[1].push("#{stemoji[i]} Equal #{stzzz[i]}")
    elsif b[0][0][i]>b[1][0][i]
      d3[1].push("#{stemoji[i]} #{names[0]} has #{b[0][0][i]-b[1][0][i]} more #{stzzz[i]}")
    elsif b[0][0][i]<b[1][0][i]
      d3[1].push("#{stemoji[i]} #{names[1]} has #{b[1][0][i]-b[0][0][i]} more #{stzzz[i]}")
    else
      d3[1].push("#{stemoji[i]} #{stzzz[i]} calculation error")
    end
  end
  d1[1].push('')
  d2[1].push('')
  d3[1].push('')
  d1[1].push("BST: #{d1[2]}")
  d2[1].push("BST: #{d2[2]}")
  if d1[2]==d2[2]
    d3[1].push('Equal BST')
  elsif d1[2]>d2[2]
    d3[1].push("#{names[0]} has #{d1[2]-d2[2]} more BST")
  elsif d1[2]<d2[2]
    d3[1].push("#{names[1]} has #{d2[2]-d1[2]} more BST")
  else
    d3[1].push("BST calculation error")
  end
  d1[1]=d1[1].join("\n")
  d2[1]=d2[1].join("\n")
  d3[1]=d3[1].join("\n")
  d1[2]=nil
  d2[2]=nil
  d1.compact!
  d2.compact!
  ftr=nil
  data_load()
  bse=[]
  bse.push(@units[@units.find_index{|q| q[0].gsub('Lavatain','Laevatein')==b[0][0][0]}][12].split(', ')[0].gsub('*',''))
  bse.push(@units[@units.find_index{|q| q[0].gsub('Lavatain','Laevatein')==b[1][0][0]}][12].split(', ')[0].gsub('*',''))
  if bse.include?('Elise') && bse.include?('Nino')
    metadata_load()
    ftr="Heyday Coefficient: #{(@server_data[0].inject(0){|sum,x| sum + x }/701.0).round(4)}"
  end
  create_embed(event,"**Comparing #{names[0]} and #{names[1]}**",'',avg_color([c[0],c[1]]),ftr,xpic,[d1,d2,d3],-2)
  return 2
end

def detect_multi_unit_alias(event,str1,str2,robinmode=0)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || @shardizard==4
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return multi_for_units(event,str1,str2,robinmode)
end

def weapon_clss(arr,event,mode=0)
  x="#{arr[0]} #{arr[1]}"
  return 'Healer' if x=='Colorless Healer' && !alter_classes(event,'Colored Healers')
  return 'Sword' if x=='Red Blade'
  return 'Lance' if x=='Blue Blade'
  return 'Axe' if x=='Green Blade'
  return 'Rod' if x=='Colorless Blade'
  return x if arr[1]=='Tome'
  return arr[1] if mode==1
  return x
end

def disp_unit_stats_and_skills(event,args,bot)
  event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
  k=find_name_in_string(event,nil,1)
  w=nil
  if k.nil?
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true,true)
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.nil?
  data_load()
  if !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,true,true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,true,true)
  elsif find_unit(str,event)>=0
    disp_stats(bot,str,w,event,false,true)
  else
    event.respond 'No matches found'
  end
  return nil
end

def skill_comparison(event,args,bot)
  event.channel.send_temporary_message('Calculating data, please wait...',3)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  s1=args.join(' ').gsub(',','').gsub('/','')
  s2=args.join(' ').gsub(',','').gsub('/','')
  for i in 0...args.length
    unless s1.split(' ').nil? || s1.gsub(' ','').length<=0
      k=find_name_in_string(event,s1,1)
      unless k.nil?
        s1=first_sub(s1,k[1],'')
        s2=first_sub(s2,k[1],k[0])
      end
    end
  end
  k=splice(s2)
  k2=[]
  for i in 0...k.length
    x=detect_multi_unit_alias(event,k[i],k[i],1)
    str=k[i]
    if !x.nil? && x[1].is_a?(Array)
      if x[1].is_a?(Array)
        for i in 0...x[1].length
          k2.push(str.downcase.gsub(x[0],x[1][i]))
        end
      else
        k2.push(str.downcase.gsub(x[0],x[1]))
      end
    elsif find_name_in_string(event,sever(str),1)!=nil
      x=find_name_in_string(event,sever(str),1)
      k2.push(str)
    elsif k[i].downcase=="mathoo's" || donate_trigger_word(event,k[i])>0
      k2.push(str)
    end
  end
  k=k2.map{|q| q}
  b=[]
  c=[]
  m=false
  did=-1
  for i in 0...k.length
    if find_name_in_string(event,sever(k[i]))!=nil
      r=find_stats_in_string(event,sever(k[i]))
      u=@units[find_unit(find_name_in_string(event,sever(k[i])),event)]
      name=u[0]
      if m && find_in_dev_units(name)>=0
        dv=@dev_units[find_in_dev_units(name)]
        r[0]=dv[1]
      elsif did>0
        x=donor_unit_list(did)
        x2=x.find_index{|q| q[0]==name}
        unless x2.nil?
          r[0]=x[x2][1]
        end
      end
      st=[]
      st=unit_skills(name,event,false,r[0])
      if m && find_in_dev_units(name)>=0
        dv=@dev_units[find_in_dev_units(name)]
        st=[dv[6],dv[7],dv[8],dv[9],dv[10],dv[11]]
      elsif did>0
        x=donor_unit_list(did)
        x2=x.find_index{|q| q[0]==name}
        unless x2.nil?
          st=[x[x2][6],x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11]]
        end
      end
      b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]} #{name} #{unit_moji(bot,event,-1,name,m,0,did)}",name])
      c.push(unit_color(event,find_unit(find_name_in_string(event,sever(k[i])),event),nil,1,m))
    elsif k[i].downcase=="mathoo's"
      m=true
    elsif donate_trigger_word(event,k[i])>0
      did=donate_trigger_word(event,k[i])
    end
  end
  if b.length<2
    event.respond 'I need at least two units in order to compare anything.'
    return 0
  elsif b.length>2
    event.respond "I detect #{b.length} names.\nUnfortunately, due to embed limits, I can only compare two units' skillsets."
  end
  b2=[[],[],[],[],[],[]]
  b[1][0]=b[1][0].map{|q| q.map{|q2| q2.gsub('__','')}}
  b[0][0]=b[0][0].map{|q| q.map{|q2| q2.gsub('__','')}}
  for i in 0...b[0][0].length
    if b[0][0][i]==b[1][0][i]
      b2[i]=b[0][0][i]
    elsif b[0][0][i].map{|q| q.gsub('**','')}==b[1][0][i].map{|q| q.gsub('**','')}
      for i2 in 0...b[0][0][i].length
        if b[0][0][i][i2]==b[1][0][i][i2]
          b2[i].push(b[0][0][i][i2])
        else
          b2[i].push("*#{b[0][0][i][i2].gsub("**",'')}*")
        end
      end
    elsif b[0][0][i]==['~~none~~']
      b2[i]=["~~only #{b[1][2]}~~"]
    elsif b[1][0][i]==['~~none~~']
      b2[i]=["~~only #{b[0][2]}~~"]
    elsif has_any?(b[0][0][i],b[1][0][i])
      b2[i].push('~~different starts~~') if b[0][0][i][0].gsub('**','').gsub('~~','').gsub('__','')!=b[1][0][i][0].gsub('**','').gsub('~~','').gsub('__','')
      for i2 in 0...b[0][0][i].length
        if b[1][0][i].include?(b[0][0][i][i2])
          b2[i].push(b[0][0][i][i2])
        elsif b[1][0][i].map{|q| q.gsub('**','')}.include?(b[0][0][i][i2].gsub('**',''))
          b2[i].push("*#{b[0][0][i][i2].gsub('**','')}*")
        elsif b[1][0][i].map{|q| q.gsub('~~','')}.include?(b[0][0][i][i2].gsub('~~',''))
          b2[i].push("~#{b[0][0][i][i2].gsub('~~','')}~")
        elsif b[1][0][i].map{|q| q.gsub('~~','').gsub('**','')}.include?(b[0][0][i][i2].gsub('~~','').gsub('**',''))
          b2[i].push("*~#{b[0][0][i][i2].gsub('**','').gsub('~~','')}~*")
        end
      end
      if b[0][0][i][b[0][0][i].length-1].gsub('**','').gsub('~~','')!=b[1][0][i][b[1][0][i].length-1].gsub('**','').gsub('~~','')
        if b[0][0][i][b[0][0][i].length-1].gsub('**','').gsub('~~','')==b2[i][b2[i].length-1].gsub('*','').gsub('~','')
          b2[i].push("~~#{b[1][2]} has promotion~~")
        elsif b[1][0][i][b[1][0][i].length-1].gsub('**','').gsub('~~','')==b2[i][b2[i].length-1].gsub('*','').gsub('~','')
          b2[i].push("~~#{b[0][2]} has promotion~~")
        else
          b2[i].push('~~different ends~~')
        end
      end
    else
      b2[i]=['~~nothing in common~~']
    end
  end
  create_embed(event,"**Skills #{b[0][1].gsub('Lavatain','Laevatein')} and #{b[1][1].gsub('Lavatain','Laevatein')} have in common**",'',avg_color([c[0],c[1]]),nil,"https://cdn.discordapp.com/emojis/448304646814171136.png",[["<:Skill_Weapon:444078171114045450> **Weapons**",b2[0].join("\n")],["<:Skill_Assist:444078171025965066> **Assists**",b2[1].join("\n")],["<:Skill_Special:444078170665254929> **Specials**",b2[2].join("\n")],["<:Passive_A:443677024192823327> **A Passives**",b2[3].join("\n")],["<:Passive_B:443677023257493506> **B Passives**",b2[4].join("\n")],["<:Passive_C:443677023555026954> **C Passives**",b2[5].join("\n")]],-1)
  return 2
end

def weapon_legality(event,name,weapon,refinement='-',recursion=false)
  return '-' if weapon=='-'
  u=@units[@units.find_index{|q| q[0]==name.gsub('Laevatein','Lavatain')}]
  w=@skills[@skills.find_index{|q| q[0]==weapon.gsub('Laevatein','Bladeblade')}]
  unless w[0].split(' ')[0].length>u[0].length
    return '-' if w[0][0,u[0].length].downcase==u[0].downcase && count_in(event.message.text.downcase.split(' '),u[0].downcase,1)<=1
  end
  return '-' if w[4]!='Weapon'
  if weapon=='Falchion'
    if ['FE13'].include?(u[11][0])
      weapon='Falchion (Awakening)'
    elsif ['FE2','FE15'].include?(u[11][0])
      weapon='Falchion (Valentia)'
    elsif ['FE1','FE3','FE11','FE12'].include?(u[11][0])
      weapon='Falchion (Mystery)'
    elsif u[11].include?('FE13')
      weapon='Falchion (Awakening)'
    elsif u[11].include?('FE2') || u[11].include?('FE15')
      weapon='Falchion (Valentia)'
    elsif u[11].include?('FE1') || u[11].include?('FE3') || u[11].include?('FE11') || u[11].include?('FE12')
      weapon='Falchion (Mystery)'
    elsif u[11].map{|q| q[0,4]}.include?('FE14')
      weapon='Falchion (Awakening)'
    end
  elsif weapon=='Missiletainn'
    if ['FE14'].include?(u[11][0][0,4])
      weapon='Missiletainn (Dusk)'
    elsif ['FE13'].include?(u[11][0])
      weapon='Missiletainn (Dark)'
    elsif ['Red Blade'].include?("#{u[1][0]} #{u[1][1]}")
      weapon='Missiletainn (Dusk)'
    elsif ['Blue Tome'].include?("#{u[1][0]} #{u[1][1]}")
      weapon='Missiletainn (Dusk)'
    elsif u[11].map{|q| q[0,4]}.include?('FE14')
      weapon='Missiletainn (Dusk)'
    elsif u[11].include?('FE13')
      weapon='Missiletainn (Dark)'
    elsif ['Blade','Dragon','Beast'].include?(u[1][1])
      weapon='Missiletainn (Dusk)'
    elsif ['Tome','Bow','Dagger','Healer'].include?(u[1][1])
      weapon='Missiletainn (Dusk)'
    end
    w=@skills[@skills.find_index{|q| q[0]==weapon.gsub('Laevatein','Bladeblade')}]
  elsif weapon=='Adult (All)'
    weapon="Adult (#{u[3]})"
    w=@skills[@skills.find_index{|q| q[0]==weapon.gsub('Laevatein','Bladeblade')}]
  end
  w2="#{weapon}"
  w2="#{weapon} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  return "~~#{w2}~~" if w[6]!='-' && !w[6].split(', ').include?(u[0]) # prf weapons are illegal on anyone but their holders
  u2=weapon_clss(u[1],event)
  u2='Bow' if u2.include?('Bow')
  u2='Dagger' if u2.include?('Dagger')
  u2="#{u2.gsub('Healer','Staff')} Users Only"
  u2='Dragons Only' if u[1][1]=='Dragon'
  u2="Beasts Only, #{u[3].gsub('Flier','Fliers')} Only" if u[1][1]=='Beast'
  return w2 if u2==w[5]
  return "~~#{w2}~~" if recursion
  if 'Raudr'==w[0][0,5] || 'Blar'==w[0][0,4] || 'Gronn'==w[0][0,5] || 'Keen Raudr'==w[0][0,10] || 'Keen Blar'==w[0][0,9] || 'Keen Gronn'==w[0][0,10]
    return weapon_legality(event,name,weapon.gsub('Blar','Raudr').gsub('Gronn','Raudr'),refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,weapon.gsub('Raudr','Blar').gsub('Gronn','Blar'),refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,weapon.gsub('Raudr','Gronn').gsub('Blar','Gronn'),refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Colorless'
    w2="#{weapon.gsub('Raudr','Hoss').gsub('Blar','Hoss').gsub('Gronn','Hoss')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Ruby Sword','Sapphire Lance','Emerald Axe'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Ruby Sword#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Sapphire Lance#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Emerald Axe#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Hibiscus Tome','Sealife Tome','Tomato Tome'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Tomato Tome#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Sealife Tome#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Hibiscus Tome#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ["Dancer's Ring","Dancer's Score"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Dancer's Score#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Dancer's Ring#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Red'
    w2="Dancer's Ribbon#{'+' if w[0].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Kadomatsu','Hagoita'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Kadomatsu#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Hagoita#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Blue'
    w2="Sushi Sticks#{'+' if w[0].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Tannenboom!',"Sack o' Gifts",'Handbell'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Tannenboom!#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"#{["Sack o' Gifts",'Handbell'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green' && w[0].gsub('+','')=='Tannenboom!'
    return "~~#{w2}~~" unless u[1][0]=='Red'
    w2="Santa's Sword#{'+' if w[0].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Carrot Lance','Carrot Axe'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Carrot Lance#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Carrot Axe#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless','Red'].include?(u[1][0])
    w2="Carrot#{'+' if w[0].include?('+')}...just a carrot#{'+' if w[0].include?('+')}"
    w2="Carrot Sword#{'+' if w[0].include?('+')}" if u[1][0]=='Red'
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Blue Egg','Green Egg','Blue Gift','Green Gift'].include?(w[0].gsub('+',''))
    t='Egg'
    t='Gift' if ['Blue Gift','Green Gift'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Blue #{t}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Green #{t}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless','Red'].include?(u[1][0])
    w2="Empty #{t}#{'+' if w[0].include?('+')}"
    w2="Red #{t}#{'+' if w[0].include?('+')}" if u[1][0]=='Red'
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Melon Crusher','Deft Harpoon'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Deft Harpoon#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Melon Crusher#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Red'].include?(u[1][0])
    w2="Ylissian Summer Sword#{'+' if w[0].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Iron Sword','Iron Lance','Iron Axe','Steel Sword','Steel Lance','Steel Axe','Silver Sword','Silver Lance','Silver Axe','Brave Sword','Brave Lance','Brave Axe','Firesweep Sword','Firesweep Lance','Firesweep Axe'].include?(w[0].gsub('+',''))
    t='Iron'
    t='Steel' if 'Steel '==w[0][0,6]
    t='Silver' if 'Silver '==w[0][0,7]
    t='Brave' if 'Brave '==w[0][0,6]
    t='Firesweep' if 'Firesweep '==w[0][0,10]
    if event.message.text.downcase.include?('sword') || event.message.text.downcase.include?('edge')
    elsif event.message.text.downcase.include?('lance')
    elsif event.message.text.downcase.include?('axe')
    elsif (['Iron','Steel','Silver'].include?(t) && u[1][1]=='Dagger') || u[1][1]=='Bow'
      return weapon_legality(event,name,"#{t} Dagger#{'+' if w[0].include?('+')}",refinement,true) if u[1][1]=='Dagger'
      return weapon_legality(event,name,"#{t} Bow#{'+' if w[0].include?('+')}",refinement,true) if u[1][1]=='Bow'
    end
    return weapon_legality(event,name,"#{t} Sword#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"#{t} Lance#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"#{t} Axe#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Colorless'
    w2="#{t} Rod"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Killing Edge','Killer Lance','Killer Axe','Slaying Edge','Slaying Lance','Slaying Axe'].include?(w[0].gsub('+',''))
    t='Killer'
    t='Killing' if u[1][0]=='Red'
    t='Slaying' if 'Slaying '==w[0][0,8]
    if event.message.text.downcase.include?('sword') || event.message.text.downcase.include?('edge')
    elsif event.message.text.downcase.include?('lance')
    elsif event.message.text.downcase.include?('axe')
    elsif u[1][1]=='Bow'
      return weapon_legality(event,name,"#{t} Bow#{'+' if w[0].include?('+')}",refinement,true) if u[1][1]=='Bow'
    end
    return weapon_legality(event,name,"#{t} Edge#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"#{t} Lance#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"#{t} Axe#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Colorless'
    w2="#{t} Rod"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Fire','Flux','Thunder','Light','Wind'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Fire#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Fire'
    return weapon_legality(event,name,"Flux#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Dark'
    return weapon_legality(event,name,"#{['Fire','Flux'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Thunder#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Thunder'
    return weapon_legality(event,name,"Light#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Light'
    return weapon_legality(event,name,"#{['Thunder','Light'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Wind#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Wind'
    return weapon_legality(event,name,"#{['Wind'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Elfire','Ruin','Elthunder','Ellight','Elwind'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Elfire#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Fire'
    return weapon_legality(event,name,"Ruin#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Dark'
    return weapon_legality(event,name,"#{['Elfire','Ruin'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Elthunder#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Thunder'
    return weapon_legality(event,name,"Ellight#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Light'
    return weapon_legality(event,name,"#{['Elthunder','Ellight'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Elwind#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Wind'
    return weapon_legality(event,name,"#{['Elwind'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Bolganone','Fenrir','Thoron','Shine','Rexcalibur'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Bolganone#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Fire'
    return weapon_legality(event,name,"Fenrir#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Dark'
    return weapon_legality(event,name,"#{['Bolganone','Fenrir'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Thoron#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Thunder'
    return weapon_legality(event,name,"Shine#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Light'
    return weapon_legality(event,name,"#{['Thoron','Shine'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Rexcalibur#{'+' if w[0].include?('+')}",refinement,true) if u[1][2]=='Wind'
    return weapon_legality(event,name,"#{['Rexcalibur'].sample}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Armorslayer','Heavy Spear','Hammer'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Armorslayer#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Heavy Spear#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Hammer#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Armorsmasher','Slaying Spear','Slaying Hammer'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Armorsmasher#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Slaying Spear#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Slaying Hammer#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Zanbato','Ridersbane','Poleaxe'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Zanbato#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Ridersbane#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Poleaxe#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Wo Dao','Harmonic Lance','Giant Spoon','Wo Gun'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Wo Dao#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Harmonic Lance#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Wo Gun#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Whelp (Infantry)','Hatchling (Flier)'].include?(w[0])
    return weapon_legality(event,name,"Whelp (Infantry)",refinement,true) if u[3]=='Infantry'
    return weapon_legality(event,name,"Hatchling (Flier)",refinement,true) if u[3]=='Flier'
  elsif ['Yearling (Infantry)','Fledgeling (Flier)'].include?(w[0])
    return weapon_legality(event,name,"Yearling (Infantry)",refinement,true) if u[3]=='Infantry'
    return weapon_legality(event,name,"Fledgeling (Flier)",refinement,true) if u[3]=='Flier'
  elsif ['Adult (Infantry)','Adult (Flier)'].include?(w[0])
    return weapon_legality(event,name,"Adult (Infantry)",refinement,true) if u[3]=='Infantry'
    return weapon_legality(event,name,"Adult (Flier)",refinement,true) if u[3]=='Flier'
  end
  return "~~#{w2}~~"
end

def skill_legality(event,unit,skill)
  u=@units[@units.find_index{|q| q[0]==unit.gsub('Laevatein','Lavatain')}]
  s=@skills[@skills.find_index{|q| q[0]==skill.gsub('Laevatein','Bladeblade')}]
  k3=true
  k22=s[5].split(', ')
  for i2 in 0...k22.length
    k3=false if k22[i2]=='No one'
    if k22[i2].include?('Excludes')
      k4=true
      if k22[i2].include?('Weapon Users')
        k4=false if k22[i2].include?(u[1][0])
      elsif k22[i2].include?('Users')
        k4=false if k22[i2].include?('Excludes Tome') && u[1][1]=='Tome'
        k4=false if k22[i2].include?('and Tome') && u[1][1]=='Tome'
        k4=false if k22[i2].include?('Excludes Bow') && u[1][1]=='Bow'
        k4=false if k22[i2].include?('and Bow') && u[1][1]=='Bow'
        k4=false if k22[i2].include?('Excludes Dagger') && u[1][1]=='Dagger'
        k4=false if k22[i2].include?('and Dagger') && u[1][1]=='Dagger'
        k4=false if k22[i2].include?(weapon_clss(u[1],event).gsub('Healer','Staff'))
      else
        k4=false if k22[i2].include?('Dragons') && u[1][1]=='Dragon'
        k4=false if k22[i2].include?('Beasts') && u[1][1]=='Beast'
        k4=false if k22[i2].include?(u[3].gsub('Flier','Fliers')) || k22[i2].include?(u[3].gsub('Armor','Armored'))
      end
      k3=(k3 && k4)
    end
    if k22[i2].include?('Only')
      k4=false
      k4=true if k22[i2]=='Dragons Only' && u[1][1]=='Dragon'
      k4=true if k22[i2]=='Beasts Only' && u[1][1]=='Beast'
      k4=true if k22[i2]=='Tome Users Only' && u[1][1]=='Tome'
      k4=true if k22[i2]=='Bow Users Only' && u[1][1]=='Bow'
      k4=true if k22[i2]=='Dagger Users Only' && u[1][1]=='Dagger'
      k4=true if k22[i2]=='Melee Weapon Users Only' && ['Blade','Dragon','Beast'].include?(u[1][1])
      k4=true if k22[i2]=='Ranged Weapon Users Only' && ['Tome','Bow','Dagger','Healer'].include?(u[1][1])
      k4=true if k22[i2].include?(u[3].gsub('Flier','Fliers')) || k22[i2].include?(u[3].gsub('Armor','Armored'))
      k4=true if k22[i2]=="#{weapon_clss(u[1],event).gsub('Healer','Staff')} Users Only"
      k4=true if k22[i2]=="#{u[1][0]} Weapon Users Only"
      k4=true if k22[i2]=='Summon Gun Users Only' && u[0]=='Kiran'
      if k22[i2].include?('Dancers')
        u2=sklz[sklz.find_index{|q| q[0]=='Dance'}]
        b=[]
        for i3 in 0...@max_rarity_merge[0]
          u=u2[9][i3].split(', ')
          for j2 in 0...u.length
            b.push(u[j2].gsub('Lavatain','Laevatein')) unless b.include?(u[j2]) || u[j2].include?('-')
          end
        end
        k4=true if b.include?(u[0])
      end
      if k22[i2].include?('Singers')
        u2=sklz[sklz.find_index{|q| q[0]=='Sing'}]
        b=[]
        for i3 in 0...@max_rarity_merge[0]
          u=u2[9][i3].split(', ')
          for j2 in 0...u.length
            b.push(u[j2].gsub('Lavatain','Laevatein')) unless b.include?(u[j2]) || u[j2].include?('-')
          end
        end
        k4=true if b.include?(u[0])
      end
      k3=(k3 && k4)
    end
  end
  return k3
end

def add_number_to_string(a,b)
  return 0 if a.is_a?(String) && /[[:alpha:]]/ =~ a
  return 0 if b.is_a?(String) && /[[:alpha:]]/ =~ b
  return a+b if a.is_a?(Integer) && b.is_a?(Integer)
  return a.to_i+b if a.is_a?(String) && b.is_a?(Integer) && a.to_i.to_s==a
  return a+b.to_i if a.is_a?(Integer) && b.is_a?(String) && b.to_i.to_s==b
  return a.to_i+b.to_i if a.is_a?(String) && a.to_i.to_s==a && b.is_a?(String) && b.to_i.to_s==b
  x=[]
  if a.is_a?(Integer) || (a.is_a?(String) && a.to_i.to_s==a)
    if b.include?('(') && !b.include?('~~')
      x=b.split(' (').map{|q| q.gsub('(','').gsub(')','')}
      x=x.map{|q| q.to_i+a.to_i}
      return "#{x[0]} (#{x[1]})"
    end
    x=b.split('~~ ').map{|q| q.gsub('~~','')}
    x=x.map{|q| add_number_to_string(q,a)}
  elsif b.is_a?(Integer) || (b.is_a?(String) && b.to_i.to_s==b)
    if a.include?('(') && !a.include?('~~')
      x=a.split(' (').map{|q| q.gsub('(','').gsub(')','')}
      x=x.map{|q| q.to_i+b.to_i}
      return "#{x[0]} (#{x[1]})"
    end
    x=a.split('~~ ').map{|q| q.gsub('~~','')}
    x=x.map{|q| add_number_to_string(q,b)}
  elsif a.include?('~~') && b.include?('~~')
    xa=a.split('~~ ').map{|q| q.gsub('~~','')}
    xb=b.split('~~ ').map{|q| q.gsub('~~','')}
    return "~~#{add_number_to_string(xa[0],xb[0])}~~ #{add_number_to_string(xa[1],xb[1])}"
  elsif a.include?('(') && b.include?(')')
    xa=a.split(' (').map{|q| q.gsub('(','').gsub(')','')}
    xb=b.split(' (').map{|q| q.gsub('(','').gsub(')','')}
    return "#{add_number_to_string(xa[0],xb[0])} (#{add_number_to_string(xa[1],xb[1])})"
  elsif a.include?('~~')
    xa=a.split('~~ ').map{|q| q.gsub('~~','')}
    x=xa.map{|q| add_number_to_string(q,b)}
  elsif b.include?('~~')
    xa=b.split('~~ ').map{|q| q.gsub('~~','')}
    x=xa.map{|q| add_number_to_string(q,a)}
  end
  return "~~#{x[0]}~~ #{x[1]}"
end

def create_summon_list(clr)
  p=[['1<:Icon_Rarity_1:448266417481973781> exclusive',[]],['1<:Icon_Rarity_1:448266417481973781>-2<:Icon_Rarity_2:448266417872044032>',[]],['2<:Icon_Rarity_2:448266417872044032> exclusive',[]],['2<:Icon_Rarity_2:448266417872044032>-3<:Icon_Rarity_3:448266417934958592>',[]],['3<:Icon_Rarity_3:448266417934958592> exclusive',[]],['3<:Icon_Rarity_3:448266417934958592>-4<:Icon_Rarity_4:448266418459377684>',[]],['4<:Icon_Rarity_4:448266418459377684> exclusive',[]],['4<:Icon_Rarity_4:448266418459377684>-5<:Icon_Rarity_5:448266417553539104>',[]],['5<:Icon_Rarity_5:448266417553539104> exclusive',[]],['5<:Icon_Rarity_5:448266417553539104>-6<:Icon_Rarity_6:491487784650145812>',[]],['6<:Icon_Rarity_6:491487784650145812> exclusive',[]],['Other',[]]]
  for i in 0...clr.length
    clr[i][0]=clr[i][0].gsub('Lavatain','Laevatein')
    if clr[i][9][0].include?('1p')
      if clr[i][9][0].include?('2p')
        p[1][1].push(clr[i][0])
      elsif clr[i][9][0].include?('3p') || clr[i][9][0].include?('4p') || clr[i][9][0].include?('5p')
        p[11][0][1].push("#{clr[i][0]} - 1#{'/3' if clr[i][9][0].include?('3p')}#{'/4' if clr[i][9][0].include?('4p')}#{'/5' if clr[i][9][0].include?('5p')}#{'/6' if clr[i][9][0].include?('6p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[0][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('2p')
      if clr[i][9][0].include?('3p')
        p[3][1].push(clr[i][0])
      elsif clr[i][9][0].include?('4p') || clr[i][9][0].include?('5p')
        p[11][0][1].push("#{clr[i][0]} - 2#{'/4' if clr[i][9][0].include?('4p')}#{'/5' if clr[i][9][0].include?('5p')}#{'/6' if clr[i][9][0].include?('6p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[2][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('3p')
      if clr[i][9][0].include?('4p')
        p[5][1].push(clr[i][0])
      elsif clr[i][9][0].include?('5p') || clr[i][9][0].include?('6p')
        p[11][0][1].push("#{clr[i][0]} - 3#{'/5' if clr[i][9][0].include?('5p')}#{'/6' if clr[i][9][0].include?('6p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[4][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('4p')
      if clr[i][9][0].include?('5p')
        p[7][1].push(clr[i][0])
      elsif clr[i][9][0].include?('6p')
        p[11][0][1].push("#{clr[i][0]} - 4#{'/6' if clr[i][9][0].include?('6p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[6][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('5p')
      if clr[i][9][0].include?('6p')
        p[9][1].push(clr[i][0])
      else
        p[8][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('6p')
      p[10][1].push(clr[i][0])
    else
      p[9][0][1].push("#{clr[i][0]} - weird")
    end
  end
  for i in 0...p.length
    if p[i][1].length<=0
      p[i]=nil
    else
      p[i][1]=p[i][1].uniq.join("\n")
    end
  end
  p.compact!
  return p
end

def disp_summon_pool(event,args)
  data_load()
  k=@units.reject{|q| !q[9][0].include?('p') || !q[13][0].nil?}
  k=k.reject{|q| !q[9][0].include?('LU')} if event.message.text.downcase.split(' ').include?('launch')
  colors=[]
  for i in 0...args.length
    args[i]=args[i].downcase.gsub('user','') if args[i].length>4 && args[i][args[i].length-4,4].downcase=='user'
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','clear','clears'].include?(args[i].downcase)
  end
  colors=colors.uniq
  if safe_to_spam?(event)
    colors=['Red','Blue','Green','Colorless'] if colors.length<=0
  elsif colors.length<=0
    event.respond 'I will not show the entire summon pool as that would be spam.  Please specify a single color or use this command in PM.'
    return nil
  else
    colors=[colors[0]]
  end
  if colors.include?('Red')
    r=k.reject{|q| q[1][0]!='Red'}
    r=create_summon_list(r)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0xE22141,nil,nil,r,4)
    end
  end
  if colors.include?('Blue')
    r=k.reject{|q| q[1][0]!='Blue'}
    r=create_summon_list(r)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x2764DE,nil,nil,r,4)
    end
  end
  if colors.include?('Green')
    r=k.reject{|q| q[1][0]!='Green'}
    r=create_summon_list(r)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x09AA24,nil,nil,r,4)
    end
  end
  if colors.include?('Colorless')
    r=k.reject{|q| q[1][0]!='Colorless'}
    r=create_summon_list(r)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x64757D,nil,nil,r,4)
    end
  end
end

def filler(list1,list2,n,m=-1,key='',type=0,mode='||',mode2='')
  return "#{longFormattedNumber(list1.length)}#{" (#{longFormattedNumber(list2.length)})" unless list1.length==list2.length}" if n==-1
  if n.is_a?(Array)
    y=''
    for i in 0...key.length
      key[i]="'#{key[i]}'" if key[i].is_a?(String)
    end
    type=[type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type] unless type.is_a?(Array)
    for i in 0...n.length
      x="q[#{n[i]}][#{m[i]}]"
      x="q[#{n[i]}].split(', ')[0]" if m[i]==-2
      x="q[#{n[i]}]" if m[i]==-1
      x="#{x}.split(', ').include?(#{key[i]})" if type[i]==-4
      x="!#{key[i]}.include?(#{x})" if type[i]==-3
      x="#{x}.length>=#{0-key[i]}" if type[i]==-2 && key[i]<0
      x="#{x}.length>#{key[i]}" if type[i]==-2
      x="#{x}.include?(#{key[i]})" if type[i]==-1
      x="!#{x}.split(', ').include?(#{key[i]})" if type[i]==4
      x="#{key[i]}.include?(#{x})" if type[i]==3
      x="#{x}.length<=#{0-key[i]}" if type[i]==2 && key[i]<0
      x="#{x}.length<#{key[i]}" if type[i]==2
      x="!#{x}.include?(#{key[i]})" if type[i]==1
      x="#{x}==#{key[i]}" if type[i]==10
      x="#{x}!=#{key[i]}" if type[i].zero?
      if y.length>=1
        y="#{y} #{mode} #{x}"
      else
        y="#{x}"
      end
    end
    y="#{mode2}(#{y})"
    return "#{longFormattedNumber(list1.reject{|q| eval(y)}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(y)}.length)})" unless list1.reject{|q| eval(y)}.length==list2.reject{|q| eval(y)}.length}"
  elsif m.is_a?(Array)
    y=""
    for i in 0...key.length
      key[i]="'#{key[i]}'" if key[i].is_a?(String)
    end
    type=[type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type,type] unless type.is_a?(Array)
    for i in 0...m.length
      x="q[#{n}][#{m[i]}]"
      x="q[#{n[i]}].split(', ')[0]" if m[i]==-2
      x="q[#{n[i]}].split(', ')" if m[i]==-3
      x="q[#{n}]" if m[i]==-1
      x="has_any?(#{x},#{key[i]})" if type[i]==-4
      x="!#{key[i]}.include?(#{x})" if type[i]==-3
      x="#{x}.length>=#{0-key[i]}" if type[i]==-2 && key[i]<0
      x="#{x}.length>#{key[i]}" if type[i]==-2
      x="#{x}.include?(#{key[i]})" if type[i]==-1
      x="!has_any?(#{x},#{key[i]})" if type[i]==4
      x="#{key[i]}.include?(#{x})" if type[i]==3
      x="#{x}.length<=#{0-key[i]}" if type[i]==2 && key[i]<0
      x="#{x}.length<#{key[i]}" if type[i]==2
      x="!#{x}.include?(#{key[i]})" if type[i]==1
      x="#{x}==#{key[i]}" if type[i]==10
      x="#{x}!=#{key[i]}" if type[i].zero?
      if y.length>=1
        y="#{y} #{mode} #{x}"
      else
        y="#{x}"
      end
    end
    y="#{mode2}(#{y})"
    return "#{longFormattedNumber(list1.reject{|q| eval(y)}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(y)}.length)})" unless list1.reject{|q| eval(y)}.length==list2.reject{|q| eval(y)}.length}"
  end
  x="q[#{n}][#{m}]"
  x="q[#{n}].split(', ')" if m==-3
  x="q[#{n}].split(', ')[0]" if m==-2
  x="q[#{n}]" if m==-1
  return "#{longFormattedNumber(list1.reject{|q| !has_any?(eval(x),key)}.length)}#{" (#{longFormattedNumber(list2.reject{|q| !has_any?(eval(x),key)}.length)})" unless list1.reject{|q| !has_any?(eval(x),key)}.length==list2.reject{|q| !has_any?(eval(x),key)}.length}" if type==4
  return "#{longFormattedNumber(list1.reject{|q| has_any?(eval(x),key)}.length)}#{" (#{longFormattedNumber(list2.reject{|q| has_any?(eval(x),key)}.length)})" unless list1.reject{|q| has_any?(eval(x),key)}.length==list2.reject{|q| has_any?(eval(x),key)}.length}" if type==-4
  return "#{longFormattedNumber(list1.reject{|q| key.include?(eval(x))}.length)}#{" (#{longFormattedNumber(list2.reject{|q| key.include?(eval(x))}.length)})" unless list1.reject{|q| key.include?(eval(x))}.length==list2.reject{|q| key.include?(eval(x))}.length}" if type==3
  return "#{longFormattedNumber(list1.reject{|q| !key.include?(eval(x))}.length)}#{" (#{longFormattedNumber(list2.reject{|q| !key.include?(eval(x))}.length)})" unless list1.reject{|q| !key.include?(eval(x))}.length==list2.reject{|q| !key.include?(eval(x))}.length}" if type==-3
  return "#{longFormattedNumber(list1.reject{|q| eval(x).length<=0-key}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(x).length<=0-key}.length)})" unless list1.reject{|q| eval(x).length<=0-key}.length==list2.reject{|q| eval(x).length<=0-key}.length}" if type==2 && key<0
  return "#{longFormattedNumber(list1.reject{|q| eval(x).length<key}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(x).length<key}.length)})" unless list1.reject{|q| eval(x).length<key}.length==list2.reject{|q| eval(x).length<key}.length}" if type==2
  return "#{longFormattedNumber(list1.reject{|q| eval(x).length>=0-key}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(x).length>=0-key}.length)})" unless list1.reject{|q| eval(x).length>=0-key}.length==list2.reject{|q| eval(x).length>=0-key}.length}" if type==-2 && key<0
  return "#{longFormattedNumber(list1.reject{|q| eval(x).length>key}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(x).length>key}.length)})" unless list1.reject{|q| eval(x).length>key}.length==list2.reject{|q| eval(x).length>key}.length}" if type==-2
  return "#{longFormattedNumber(list1.reject{|q| !eval(x).include?(key)}.length)}#{" (#{longFormattedNumber(list2.reject{|q| !eval(x).include?(key)}.length)})" unless list1.reject{|q| !eval(x).include?(key)}.length==list2.reject{|q| !eval(x).include?(key)}.length}" if type==1
  return "#{longFormattedNumber(list1.reject{|q| eval(x).include?(key)}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(x).include?(key)}.length)})" unless list1.reject{|q| eval(x).include?(key)}.length==list2.reject{|q| eval(x).include?(key)}.length}" if type==-1
  return "#{longFormattedNumber(list1.reject{|q| eval(x)==key}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(x)==key}.length)})" unless list1.reject{|q| eval(x)==key}.length==list2.reject{|q| eval(x)==key}.length}" if type==10
  return "#{longFormattedNumber(list1.reject{|q| eval(x)!=key}.length)}#{" (#{longFormattedNumber(list2.reject{|q| eval(x)!=key}.length)})" unless list1.reject{|q| eval(x)!=key}.length==list2.reject{|q| eval(x)!=key}.length}"
end

def get_match_in_list(list, str)
  return list[list.find_index{|q| q[0].downcase==str.downcase}] unless list.find_index{|q| q[0].downcase==str.downcase}.nil?
  return nil
end

def generate_random_unit(event,args,bot)
  colors=[]
  weapons=[]
  movement=[]
  clazzez=[]
  color_weapons=[]
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  for i in 0...args.length
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','clear','clears'].include?(args[i].downcase)
    weapons.push('Blade') if ['physical','blade','blades','close','closerange','melee'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','magic','spell','tomes','mages','spells','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Breath') if ['dragon','dragons','breath','manakete','manaketes','close','closerange','melee'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thieves','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Healer') if ['healer','staff','cleric','healers','clerics','staves','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz','close','closerange','melee'].include?(args[i].downcase)
    color_weapons.push(['Red','Blade']) if ['sword','swords','katana'].include?(args[i].downcase)
    color_weapons.push(['Blue','Blade']) if ['lance','lances','spear','spears','naginata'].include?(args[i].downcase)
    color_weapons.push(['Green','Blade']) if ['axe','axes','ax','club','clubs'].include?(args[i].downcase)
    color_weapons.push(['Red','Tome']) if ['redtome','redtomes','redmage','redmages'].include?(args[i].downcase)
    color_weapons.push(['Blue','Tome']) if ['bluetome','bluetomes','bluemage','bluemages'].include?(args[i].downcase)
    color_weapons.push(['Green','Tome']) if ['greentome','greentomes','greenmage','greenmages'].include?(args[i].downcase)
    movement.push('Flier') if ['flier','flying','flyer','fly','pegasus','wyvern','fliers','flyers','wyverns','pegasi'].include?(args[i].downcase)
    movement.push('Cavalry') if ['cavalry','horse','pony','horsie','horses','horsies','ponies','cavalier','cavaliers'].include?(args[i].downcase)
    movement.push('Infantry') if ['infantry','foot','feet'].include?(args[i].downcase)
    movement.push('Armor') if ['armor','armour','armors','armours','armored','armoured'].include?(args[i].downcase)
    clazzez.push('Trainee') if ['trainee','villager','young'].include?(args[i].downcase)
    clazzez.push('Veteran') if ['veteran','vet','elder','jagen'].include?(args[i].downcase)
    clazzez.push('Standard') if ['standard'].include?(args[i].downcase)
  end
  colors=['Red', 'Blue', 'Green', 'Colorless'] if colors.length<=0 && weapons.length>0
  if colors.length>0 && weapons.length<=0
    weapons=['Blade', 'Tome', 'Breath', 'Bow', 'Dagger']
    weapons.push('Healer') unless event.message.text.downcase.split(' ').include?('singer') || event.message.text.downcase.split(' ').include?('dancer')
  end
  for i in 0...colors.length
    for j in 0...weapons.length
      if colors[i]=='Colorless'
        color_weapons.push([colors[i],weapons[j]]) unless (weapons[j]=='Blade' && !alter_classes(event,'Colorless Blades')) || (weapons[j]=='Tome' && !alter_classes(event,'Colorless Tomes'))
      elsif weapons[j]=='Healer' && !alter_classes(event,'Colored Healers')
      else
        color_weapons.push([colors[i],weapons[j]])
      end
    end
  end
  if color_weapons.length<=0
    color_weapons=[['Red', 'Blade'],  ['Red', 'Tome'],  ['Red', 'Breath'],      ['Red', 'Bow'],      ['Red', 'Dagger'],      ['Red','Beast'],
                   ['Blue', 'Blade'], ['Blue', 'Tome'], ['Blue', 'Breath'],     ['Blue', 'Bow'],     ['Blue', 'Dagger'],     ['Blue','Beast'],
                   ['Green', 'Blade'],['Green', 'Tome'],['Green', 'Breath'],    ['Green', 'Bow'],    ['Green', 'Dagger'],    ['Green','Beast'],
                                                        ['Colorless', 'Breath'],['Colorless', 'Bow'],['Colorless', 'Dagger'],['Colorless','Beast']]
    color_weapons.push(['Colorless', 'Blade']) if alter_classes(event,'Colorless Blades')
    color_weapons.push(['Colorless', 'Tome']) if alter_classes(event,'Colorless Tomes')
    unless event.message.text.downcase.split(' ').include?('singer') || event.message.text.downcase.split(' ').include?('dancer')
      color_weapons.push(['Red', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Blue', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Green', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Colorless', 'Healer'])
    end
    color_weapons=color_weapons.reject{|q| !colors.include?(q[0])} unless colors.length<=0
    color_weapons=color_weapons.reject{|q| !weapons.include?(q[1])} unless weapons.length<=0
  end
  color_weapons.uniq!
  clazz=color_weapons.sample
  movement=['Infantry', 'Flier', 'Cavalry', 'Armor'] if movement.length<=0
  movement.uniq!
  mov=movement.sample
  l1_total=47
  gp_total=31
  if ['Tome', 'Bow', 'Dagger', 'Healer'].include?(clazz[1])
    l1_total-=3
    gp_total-=3
  end
  if mov=='Cavalry'
    l1_total-=1
    gp_total-=1
  elsif mov=='Armor'
    l1_total+=7
    gp_total+=6
  end
  clazzez=['Trainee','Veteran','Standard','Standard','Standard','Standard','Standard','Standard','Standard','Standard'] if clazzez.length<=0
  clazz2=[]
  zzz=clazzez.sample
  if zzz=='Trainee'
    clazz2.push('Trainee')
    l1_total-=8
    gp_total+=6
  elsif zzz=='Veteran'
    clazz2.push('Veteran')
    l1_total+=8
    gp_total-=6
  end
  if event.message.text.downcase.split(' ').include?('singer')
    clazz2.push('Singer')
    l1_total-=8
  elsif event.message.text.downcase.split(' ').include?('dancer')
    clazz2.push('Dancer')
    l1_total-=8
  elsif event.message.text.downcase.split(' ').include?('music') || event.message.text.downcase.split(' ').include?('musical')
    clazz2.push(['Dancer','Singer'].sample)
    l1_total-=8
  elsif event.message.text.downcase.split(' ').include?('nonmusical')
  elsif event.message.text.downcase.split(' ').include?('non-musical')
  elsif clazz[1]!='Healer' && rand(10).zero?
    clazz2.push(['Dancer','Singer'].sample)
    l1_total-=8
  end
  zzz=rand(100)
  zzz=rand(1000) if clazz2.include?('Trainee') || clazz2.include?('Veteran')
  if args.include?('Gen2')
    clazz2.push('Gen 2')
    l1_total+=1
    l1_total-=1 if ['Cavalry','Flier'].include?(mov)
    l1_total-=1 if ['Dancer','Singer'].include?(clazz2) && 'Flier'!=mov
    gp_total+=2
    gp_total-=1 if ['Cavalry'].include?(mov)
    gp_total-=1 if ['Tome', 'Bow', 'Dagger', 'Healer'].include?(clazz[1]) && 'Armor'!=mov
    gp_total-=2 if ['Dancer','Singer'].include?(clazz2)
  elsif args.include?('Gen1')
  elsif zzz<50
    clazz2.push('Gen 2')
    l1_total+=1
    l1_total-=1 if ['Cavalry','Flier'].include?(mov)
    l1_total-=1 if ['Dancer','Singer'].include?(clazz2) && 'Flier'!=mov
    gp_total+=2
    gp_total-=1 if ['Cavalry'].include?(mov)
    gp_total-=1 if ['Tome', 'Bow', 'Dagger', 'Healer'].include?(clazz[1]) && 'Armor'!=mov
    gp_total-=2 if ['Dancer','Singer'].include?(clazz2)
  end
  gp_total+=15
  name=get_bond_name(event)
  stats=[0,0,0,0,0]
  gps=[0,0,0,0,0]
  stats[0]=10+rand(16)
  gps[0]=rand(@mods.length-3)+1
  gps[0]=rand(@mods.length-3)+1 if gps[0]<3 || gps[0]>14
  gps[0]=rand(@mods.length-3)+1 if gps[0]<3 || gps[0]>14
  l1_total-=stats[0]
  gp_total-=gps[0]
  min_possible=[l1_total-40,2].max
  max_possible=[l1_total-8,14].min
  if max_possible<=min_possible
    stats[1]=min_possible
  else
    stats[1]=min_possible+rand(max_possible-min_possible+1)
  end
  min_possible=[gp_total-3*(@mods.length-3),1].max
  max_possible=[gp_total-3,(@mods.length-3)].min
  if max_possible<=min_possible
    gps[1]=min_possible
  else
    gps[1]=min_possible+rand(max_possible-min_possible+1)
    gps[1]=min_possible+rand(max_possible-min_possible+1) if gps[1]<3 || gps[1]>14
    gps[1]=min_possible+rand(max_possible-min_possible+1) if gps[1]<3 || gps[1]>14
  end
  l1_total-=stats[1]
  gp_total-=gps[1]
  min_possible=[l1_total-26,2].max
  max_possible=[l1_total-6,14].min
  if max_possible<=min_possible
    stats[2]=min_possible
  else
    stats[2]=min_possible+rand(max_possible-min_possible+1)
  end
  min_possible=[gp_total-2*(@mods.length-3),1].max
  max_possible=[gp_total-2,(@mods.length-3)].min
  if max_possible<=min_possible
    gps[2]=min_possible
  else
    gps[2]=min_possible+rand(max_possible-min_possible+1)
    gps[2]=min_possible+rand(max_possible-min_possible+1) if gps[2]<3 || gps[2]>14
    gps[2]=min_possible+rand(max_possible-min_possible+1) if gps[2]<3 || gps[2]>14
  end
  l1_total-=stats[2]
  gp_total-=gps[2]
  min_possible=[l1_total-13,3].max
  max_possible=[l1_total-3,13].min
  if max_possible<=min_possible
    stats[3]=min_possible
  else
    stats[3]=min_possible+rand(max_possible-min_possible+1)
  end
  min_possible=[gp_total-(@mods.length-3),1].max
  max_possible=[gp_total-1,(@mods.length-3)].min
  if max_possible<=min_possible
    gps[3]=min_possible
  else
    gps[3]=min_possible+rand(max_possible-min_possible+1)
    gps[3]=min_possible+rand(max_possible-min_possible+1) if gps[3]<3 || gps[3]>14
    gps[3]=min_possible+rand(max_possible-min_possible+1) if gps[3]<3 || gps[3]>14
  end
  l1_total-=stats[3]
  gp_total-=gps[3]
  stats[4]=l1_total
  gps[4]=gp_total
  stats.push(stats[0]+@mods[gps[0]][5])
  stats.push(stats[1]+@mods[gps[1]][5])
  stats.push(stats[2]+@mods[gps[2]][5])
  stats.push(stats[3]+@mods[gps[3]][5])
  stats.push(stats[4]+@mods[gps[4]][5])
  for i in 0...gps.length
    gps[i]-=3
  end
  stats.push(stats[0]+stats[1]+stats[2]+stats[3]+stats[4])
  stats.push(stats[5]+stats[6]+stats[7]+stats[8]+stats[9])
  stat_names=['HP','Attack','Speed','Defense','Resistance']
  for i in 0...5
    stats[i+5]=stats[i+5].to_s
    stats[i+5]="#{stats[i+5]} (+)" if [-3,1,5,10,14].include?(gps[i])
    stats[i+5]="#{stats[i+5]} (-)" if [-2,2,6,11,15].include?(gps[i])
  end
  xcolor=0xFFD800
  xcolor=0xE22141 if clazz[0]=='Red'
  xcolor=0x2764DE if clazz[0]=='Blue'
  xcolor=0x09AA24 if clazz[0]=='Green'
  xcolor=0x64757D if clazz[0]=='Colorless'
  clazz[1]=clazz[1].gsub('Breath','Dragon')
  w=clazz[1]
  w='Sword' if clazz[0]=='Red' && w=='Blade'
  w='Lance' if clazz[0]=='Blue' && w=='Blade'
  w='Axe' if clazz[0]=='Green' && w=='Blade'
  w='Rod' if clazz[0]=='Colorless' && w=='Blade'
  if clazz[1]!=w
    w="*#{w}* (#{clazz[0]} #{clazz[1]})"
  elsif ['Tome', 'Dragon', 'Bow', 'Dagger'].include?(w) || (w=='Healer' && alter_classes(event,'Colored Healers'))
    w="*#{clazz[0]} #{clazz[1]}*"
  elsif clazz[0]=='Gold'
    w="*#{w}*"
  else
    w="*#{w}* (#{clazz[0]})"
  end
  wx=nil
  if w=='*Red Tome*'
    wx=['Fire','Dark'].sample
    w="*#{wx} Mage* (Red Tome)"
  elsif w=='*Green Tome*'
    wx=['Wind'].sample
    w="*#{wx} Mage* (Green Tome)"
  elsif w=='*Blue Tome*'
    wx=['Thunder','Light'].sample
    w="*#{wx} Mage* (Blue Tome)"
  end
  atk='<:GenericAttackS:514712247587569664> Attack'
  atk='<:MagicS:514712247289774111> Magic' if ['Tome','Healer'].include?(clazz[1])
  atk='<:FreezeS:514712247474585610> Magic' if ['Dragon'].include?(clazz[1])
  atk='<:StrengthS:514712248372166666> Strength' if ['Blade','Bow','Dagger','Beast'].include?(clazz[1])
  r='<:Icon_Rarity_5:448266417553539104>'*5
  flds=[['**Level 1**',"<:HP_S:514712247503945739> HP: #{stats[0]}\n#{atk}: #{stats[1]}\n<:SpeedS:514712247625580555> Speed: #{stats[2]}\n<:DefenseS:514712247461871616> Defense: #{stats[3]}\n<:ResistanceS:514712247574986752> Resistance: #{stats[4]}\n\nBST: #{stats[10]}"]]
  args=args.map{|q| q.downcase}
  if args.include?('gps') || args.include?('gp') || args.include?('growths') || args.include?('growth')
    flds.push(['**Growth Rates**',"<:HP_S:514712247503945739> HP: #{micronumber(gps[0])} / #{gps[0]*5+20}%\n#{atk}: #{micronumber(gps[1])} / #{gps[1]*5+20}%\n<:SpeedS:514712247625580555> Speed: #{micronumber(gps[2])} / #{gps[2]*5+20}%\n<:DefenseS:514712247461871616> Defense: #{micronumber(gps[3])} / #{gps[3]*5+20}%\n<:ResistanceS:514712247574986752> Resistance: #{micronumber(gps[4])} / #{gps[4]*5+20}%\n\n\u0262\u1D18\u1D1B #{micronumber(gps[0]+gps[1]+gps[2]+gps[3]+gps[4])} / GRT: #{(gps[0]+gps[1]+gps[2]+gps[3]+gps[4])*5+100}%"])
  end
  flds.push(['**Level 40**',"<:HP_S:514712247503945739> HP: #{stats[5]}\n#{atk}: #{stats[6]}\n<:SpeedS:514712247625580555> Speed: #{stats[7]}\n<:DefenseS:514712247461871616> Defense: #{stats[8]}\n<:ResistanceS:514712247574986752> Resistance: #{stats[9]}\n\nBST: #{stats[11]}"])
  img=nil
  ftr=nil
  unless event.server.nil?
    imgx=event.server.users.sample
    imgx=event.user if rand(100).zero? && event.server.users.length>100
    img=imgx.avatar_url
    ftr="Unit profile provided by #{imgx.distinct}"
  end
  if event.message.mentions.length>0 && rand(100)<[event.message.mentions.length*10,50].min
    imgx=event.message.mentions.sample
    img=imgx.avatar_url
    ftr="Unit profile provided by #{imgx.distinct}"
  end
  wemote=''
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clazz[0]}_#{clazz[1].gsub('Healer','Staff')}"}
  wemote=moji[0].mention unless moji.length<=0
  unless wx.nil?
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{wx}_#{clazz[1].gsub('Healer','Staff')}"}
    wemote=moji[0].mention unless moji.length<=0
  end
  memote=''
  moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{mov}"}
  memote=moji[0].mention unless moji.length<=0
  clazz3=clazz2.reject{|q| ['Dancer','Singer'].include?(q)}
  create_embed(event,"__**#{name}**__","#{r}\nNeutral nature\n#{wemote} #{w}\n#{memote} *#{mov}*#{"\n<:Assist_Music:454462054959415296> *Dancer*" if clazz2.include?('Dancer')}#{"\n<:Assist_Music:454462054959415296> *Singer*" if clazz2.include?('Singer')}\n#{"Additional Modifier#{'s' if clazz3.length>1}: #{clazz3.map{|q| "*#{q}*"}.join(', ')}" if clazz3.length>0}",xcolor,ftr,img,flds,1)
  return nil
end

def pick_random_unit(event,args,bot)
  event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k22=find_in_units(event,3) # Narrow the list of units down based on the defined parameters
  g=get_markers(event)
  data_load()
  k222=k22.reject{|q| !has_any?(g, q[13][0]) || q[5][0].nil? || q[5][0].to_i.zero?} if k22.is_a?(Array)
  k222=@units.reject{|q| !has_any?(g, q[13][0]) || q[5][0].nil? || q[5][0].to_i.zero?} unless k22.is_a?(Array)
  k222=k222.reject{|q| !q[13][0].nil?} unless " #{event.message.text.downcase} ".include?(' all ')
  k222.compact!
  unt=k222.sample
  atk='<:StrengthS:514712248372166666>*'
  atk='<:MagicS:514712247289774111>' if ['Tome','Dragon','Healer'].include?(unt[1][1])
  atk='<:StrengthS:514712248372166666>' if ['Blade','Bow','Dagger'].include?(unt[1][1])
  u40=get_stats(event,unt[0],40)
  u1=get_stats(event,unt[0],1)
  superbaan=["\u00A0","\u00A0","\u00A0","\u00A0","\u00A0","\u00A0"]
  for i in 6...11
    superbaan[i-5]='+' if [-3,1,5,10,14].include?(u40[i])
    superbaan[i-5]='-' if [-2,2,6,11,15].include?(u40[i])
  end
  flds=[["**Level 1**",["#{' ' if u1[1]<10}#{u1[1]}","#{' ' if u1[2]<10}#{u1[2]}","#{' ' if u1[3]<10}#{u1[3]}","#{' ' if u1[4]<10}#{u1[4]}","#{' ' if u1[5]<10}#{u1[5]}"]],["**Level 40**",["#{' ' if u40[1]<10}#{u40[1]}","#{' ' if u40[2]<10}#{u40[2]}","#{' ' if u40[3]<10}#{u40[3]}","#{' ' if u40[4]<10}#{u40[4]}","#{' ' if u40[5]<10}#{u40[5]}"]]]
  for i in 0...5
    flds[1][1][i]="#{flds[1][1][i]}#{superbaan[i+1]}"
  end
  j=@units.find_index{|q| q[0]==unt[0]}
  img=pick_thumbnail(event,j,bot)
  xcolor=unit_color(event,j,u40[0],0)
  uskl=unit_skills(unt[0],event)
  for i in 0...3
    if uskl[i][0].include?('**') && uskl[i]!=uskl[i].reject{|q| !q.include?('**')}
      uskl[i][-1]="#{uskl[i].reject{|q| !q.include?('**')}[-1].gsub('__','')} / #{uskl[i][-1]}"
    end
  end
  uskl=uskl.map{|q| q[q.length-1]}
  create_embed(event,"__**#{u40[0].gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,j,u40[0],false,2)}**__","#{display_stars(event,5,0)}\n\n<:HP_S:514712247503945739>\u00A0\u200B\u00A0\u200B\u00A0#{atk}\u00A0\u200B\u00A0\u200B\u00A0<:SpeedS:514712247625580555>\u00A0\u200B\u00A0\u200B\u00A0<:DefenseS:514712247461871616>\u00A0\u200B\u00A0\u200B\u00A0<:ResistanceS:514712247574986752>\u00A0\u200B\u00A0\u200B\u00A0#{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]}\u00A0BST\u2084\u2080```#{flds[0][1].join("\u00A0|")}\n#{flds[1][1].join('|')}```",xcolor,nil,img,[['Skills',"<:Skill_Weapon:444078171114045450> #{uskl[0]}\n<:Skill_Assist:444078171025965066> #{uskl[1]}\n<:Skill_Special:444078170665254929> #{uskl[2]}\n<:Passive_A:443677024192823327> #{uskl[3]}\n<:Passive_B:443677023257493506> #{uskl[4]}\n<:Passive_C:443677023555026954> #{uskl[5]}"]])
end

def spaceship_order(x)
  return 1 if x=='Unit'
  return 2 if x=='Skill'
  return 3 if x=='Structure'
  return 4 if x=='Accessory'
  return 5 if x=='Item'
  return 600
end

def parse_function_alts(callback,event,args,bot)
  event.channel.send_temporary_message('Calculating data, please wait...',3)
  k=find_name_in_string(event,nil,1)
  if k.nil?
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.nil?
      xx=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        xx.push(@units[j2][12].gsub('*','').split(', ')[0])
      end
      method(callback).call(event,xx.uniq,bot) if xx.length>0
      return 0
    else
      event.respond 'No unit was included'
      return -1
    end
  else
    str=k[0]
    k2=get_weapon(first_sub(event.message.text,k[1],''),event)
    weapon='-'
    weapon=k2[0] unless k2.nil?
    name=find_name_in_string(event)
    if !detect_multi_unit_alias(event,name.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,name.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.nil?
      xx=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        xx.push(@units[j2][12].gsub('*','').split(', ')[0])
      end
      method(callback).call(event,xx.uniq,bot) if xx.length>0
    elsif !detect_multi_unit_alias(event,name.downcase,name.downcase).nil?
      x=detect_multi_unit_alias(event,name.downcase,name.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.nil?
      xx=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        xx.push(@units[j2][12].gsub('*','').split(', ')[0])
      end
      method(callback).call(event,xx.uniq,bot) if xx.length>0
    else
      j2=@units[@units.find_index{|q| q[0]==name}][12].gsub('*','').split(', ')[0]
      method(callback).call(event,j2,bot)
    end
  end
  return 0
end

def find_alts(event,name,bot)
  if name.is_a?(Array)
    for i in 0...name.length
      find_alts(event,name[i],bot)
    end
    return nil
  end
  data_load()
  nicknames_load()
  g=get_markers(event)
  k=@units.reject{|q| !has_any?(g, q[13][0]) || q[12].gsub('*','').split(', ')[0]!=name}.uniq
  untz2=[]
  color=[]
  for i in 0...k.length
    color.push(unit_color(event,find_unit(k[i][0],event),nil,1))
    m=[]
    m.push('default') if k[i][0]==k[i][12].split(', ')[0] || k[i][12].split(', ')[0][k[i][12].split(', ')[0].length-1,1]=='*'
    m.push('default') if k[i][12].split(', ')[0][0,1]=='*' && k[i][12].split(', ').length>1
    m.push('sensible') if k[i][12].split(', ')[0][0,1]=='*' && k[i][12].split(', ').length<2
    m.push('seasonal') if k[i][9][0].include?('s') && !(!k[i][2].nil? && !k[i][2][0].nil? && k[i][2][0].length>1)
    m.push('community-voted') if @aliases.reject{|q| q[2]!=k[i][0] || !q[3].nil?}.map{|q| q[1]}.include?("#{k[i][0].split('(')[0]}CYL")
    m.push('Legendary/Mythic') if !k[i][2].nil? && !k[i][2][0].nil? && k[i][2][0].length>1 && !m.include?('default')
    m.push('Fallen') if k[i][0].include?('(Fallen)')
    m.push('out-of-left-field') if m.length<=0
    n=''
    unless k[i][0]==k[i][12] || k[i][12][k[i][12].length-1,1]=='*'
      k2=k.reject{|q| q[12].gsub('*','').split(', ')[0]!=k[i][12].gsub('*','').split(', ')[0] || q[0]==k[i][0] || !(q[0]==q[12].split(', ')[0] || q[12].split(', ')[0].include?('*'))}
      n='x' if k2.length<=0
    end
    untz2.push(["#{k[i][0]}#{unit_moji(bot,event,-1,k[i][0],false,4)} - #{m.uniq.join(', ')}",k[i][12].gsub('*','').split(', '),k[i][13]])
  end
  if color.length.zero?
    color=0xFFD800
  else
    color=avg_color(color)
  end
  k2=k.map{|q| q[12].split(', ').length}
  if k2.max>1
    k2=k.map{|q| q[12].split(', ')[1]}.uniq.map{|q| ["#{name}(#{q})",[],q]}
    for i in 0...untz2.length
      for j in 0...k2.length
        k2[j][1].push("#{'~~' unless untz2[i][2].nil? || untz2[i][2].length.zero?}#{untz2[i][0]}#{'~~' unless untz2[i][2].nil? || untz2[i][2].length.zero?}") if k2[j][2]==untz2[i][1][1]
      end
    end
    for i in 0...k2.length
      k2[i][0]="**Facet #{i+1}: #{k2[i][0]}**"
      k2[i][1]=k2[i][1].join("\n")
      k2[i][2]=nil
      k2[i].compact!
      k2[i]=nil if k2[i][1].length<=0
    end
    k2.compact!
  else
    k2=[[".",untz2.map{|q| "#{'~~' unless q[2].nil? || q[2].length.zero?}#{q[0]}#{'~~' unless q[2].nil? || q[2].length.zero?}"}.join("\n")]]
  end
  create_embed(event,"__**#{name}**__",'',color,nil,nil,k2,2)
  return nil
end

def parse_function(callback,event,args,bot,healers=nil)
  event.channel.send_temporary_message('Calculating data, please wait...',3)
  k=find_name_in_string(event,nil,1)
  if k.nil?
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.nil?
      xx=[]
      xn=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        if @units[j2][1][1]!='Healer' && healers==true
          xn.push(x[1][i])
        elsif @units[j2][1][1]=='Healer' && healers==false
          xn.push(x[1][i])
        else
          xx.push(x[1][i])
        end
      end
      if healers==true
        event.respond "#{xn[0]} is not a healer so cannot equip staves." if xn.length==1
        event.respond "The following units are not healers so cannot equip staves:\n#{list_lift(xn,"and")}" if xn.length>1
      elsif healers==false
        event.respond "#{xn[0]} is a healer so cannot equip these skills." if xn.length==1
        event.respond "The following units are healers so cannot equip these skills:\n#{list_lift(xn,"and")}" if xn.length>1
      end
      method(callback).call(event,xx,bot,weapon) if xx.length>0
      return 0
    elsif callback==:banner_list
      t=Time.now
      if t-@last_multi_reload[1]>60*60 || @shardizard==4
        puts 'reloading EliseText'
        load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
        @last_multi_reload[1]=t
      end
      timeshift=8
      timeshift-=1 unless t.dst?
      t-=60*60*timeshift
      msg="No unit was included.  Showing current and upcoming banners.\n\nDate assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
      t2=Time.new(2017,2,2)-60*60
      t2=t-t2
      date=(((t2.to_i/60)/60)/24)
      msg=extend_message(msg,"Days since game release: #{longFormattedNumber(date)}",event)
      if event.user.id==167657750971547648 && @shardizard==4
        msg=extend_message(msg,"Daycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12",event)
        msg=extend_message(msg,"Weekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%4+1}/4(Saturday) - #{week_from(date,0)%12+1}/12(Thursday)",event)
      end
      str2=disp_current_events(1)
      msg=extend_message(msg,str2,event,2)
      str2=disp_current_events(-1)
      msg=extend_message(msg,str2,event,2)
      event.respond msg
      return -1
    elsif callback==:disp_art
      disp_generic_art(event,'',bot)
    else
      event.respond 'No unit was included'
      return -1
    end
  elsif ['red','reds','blue','blues','green','greens','grean','greans','colorless','colourless','colorlesses','colourlesses','clear','clears','physical','blade','blades','tome','mage','spell','tomes','mages','spells','dragon','dragons','breath','manakete','manaketes','beast','beasts','laguz','bow','arrow','bows','arrows','archer','archers','dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thiefs','thieves','healer','staff','cleric','healers','clerics','staves','sword','swords','katana','lance','lances','spear','spears','naginata','axe','axes','ax','club','clubs','redtome','redtomes','redmage','redmages','bluetome','bluetomes','bluemage','bluemages','greentome','greentomes','greenmage','greenmages','flier','flying','flyer','fly','pegasus','fliers','flyers','pegasi','wyvern','wyverns','cavalry','horse','pony','horsie','horses','horsies','ponies','cavalier','cavaliers','cav','cavs','infantry','foot','feet','armor','armour','armors','armours','armored','armoured'].include?(k[1]) && callback==:disp_art
    disp_generic_art(event,'',bot)
  else
    str=k[0]
    k2=get_weapon(first_sub(event.message.text,k[1],''),event)
    weapon='-'
    weapon=k2[0] unless k2.nil?
    name=find_name_in_string(event)
    if !detect_multi_unit_alias(event,name.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,name.downcase,event.message.text.downcase)
      x[1]=[x[1]] unless x[1].is_a?(Array)
      xx=[]
      xn=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        if @units[j2][1][1]!='Healer' && healers==true
          xn.push(x[1][i])
        elsif @units[j2][1][1]=='Healer' && healers==false
          xn.push(x[1][i])
        else
          xx.push(x[1][i])
        end
      end
      if healers==true
        event.respond "#{xn[0]} is not a healer so cannot equip staves." if xn.length==1
        event.respond "The following units are not healers so cannot equip staves:\n#{list_lift(xn,"and")}" if xn.length>1
      elsif healers==false
        event.respond "#{xn[0]} is a healer so cannot equip these skills." if xn.length==1
        event.respond "The following units are healers so cannot equip these skills:\n#{list_lift(xn,"and")}" if xn.length>1
      end
      method(callback).call(event,xx,bot,weapon) if xx.length>0
    elsif !detect_multi_unit_alias(event,name.downcase,name.downcase).nil?
      x=detect_multi_unit_alias(event,name.downcase,name.downcase)
      x[1]=[x[1]] unless x[1].is_a?(Array)
      xx=[]
      xn=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        if @units[j2][1][1]!='Healer' && healers==true
          xn.push(x[1][i])
        elsif @units[j2][1][1]=='Healer' && healers==false
          xn.push(x[1][i])
        else
          xx.push(x[1][i])
        end
      end
      if healers==true
        event.respond "#{xn[0]} is not a healer so cannot equip staves." if xn.length==1
        event.respond "The following units are not healers so cannot equip staves:\n#{list_lift(xn,"and")}" if xn.length>1
      elsif healers==false
        event.respond "#{xn[0]} is a healer so cannot equip these skills." if xn.length==1
        event.respond "The following units are healers so cannot equip these skills:\n#{list_lift(xn,"and")}" if xn.length>1
      end
      method(callback).call(event,xx,bot,weapon) if xx.length>0
    elsif @units[find_unit(name,event)][1][1]!='Healer' && healers==true
      event.respond "#{name} is not a healer so cannot equip staves."
    elsif @units[find_unit(name,event)][1][1]=='Healer' && healers==false
      event.respond "#{name} is a healer so cannot equip these skills."
    else
      method(callback).call(event,name,bot,weapon)
    end
  end
  return 0
end

def calculate_effective_HP(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      calculate_effective_HP(event,name[i],bot,weapon)
    end
    return nil
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  flurp[5]='' if flurp[5].nil?
  j=find_unit(name,event)
  u40x=@units[j]
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  untz=@units.map{|q| q}
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Legendary','Mythical')}
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Mythical','Legendary')}
  end
  blessing.compact!
  args.compact!
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study #{'his' if u40x[10]=='M'}#{'her' if u40x[10]=='F'}#{'their' unless ['M','F'].include?(u40x[10])} effective HP."
      return nil
    end
  end
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1]
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      weaponz=@dev_units[dv][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1]
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      weaponz=x[x2][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
    end
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0]
      else
        w2=@skills[find_skill(weapon,event)]
      end
      if weapon2=='-'
        w22=['-',0,0]
      else
        w22=@skills[find_skill(weapon2,event)]
      end
      diff_num=[w2[2]-w22[2],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=get_bonus_type(event)
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[0]==weapon}
  ww2=-1 if ww2.nil?
  w2=sklz[ww2]
  if w2[15].nil?
    refinement=nil
  elsif w2[15].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[15][0,1].to_i.to_s==w2[15][0,1] && refinement=='Effect'
    refinement=nil if w2[15][1,1]=='*'
  elsif w2[0,1]=='-' && w2[15][1,1].to_i.to_s==w2[15][1,1] && refinement=='Effect'
    refinement=nil if w2[15][2,1]=='*'
  end
  refinement=nil if w2[5]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[5]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  atk='Attack'
  atk='Magic' if ['Tome','Dragon','Healer'].include?(@units[j][1][1])
  atk='Strength' if ['Blade','Bow','Dagger'].include?(@units[j][1][1])
  zzzl=sklz[ww2]
  atk='Freeze' if has_weapon_tag?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='Strength'
    n=n[n.length-1] if atk=='Magic'
    n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,j,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|a| a}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed)
  if u40[0]=='Kiran'
    u40[1]=0
    u40[2]=0
    u40[3]=0
    u40[4]=0
    u40[5]=0
    mu=false
    tempest=false
    xcolor=0x9400D3
    stat_skills=[]
    stat_skills_2=[]
  end
  blu40=apply_stat_skills(event,stat_skills_2,u40.map{|a| a})
  crblu40=apply_stat_skills(event,stat_skills_2,cru40.map{|a| a})
  photon=[u40[4]>=u40[5]+5,blu40[4]>=blu40[5]+5,cru40[4]>=cru40[5]+5,crblu40[4]>=crblu40[5]+5]
  for i in 0...photon.length
    if photon[i]
      photon[i]=7
    else
      photon[i]=0
    end
  end
  photon[0]="#{photon[0]}#{" (#{photon[1]})" if photon[0]!=photon[1]}"
  if wl.include?('~~')
    photon[1]="#{photon[2]}#{" (#{photon[3]})" if photon[2]!=photon[3]}"
    photon[0]="~~#{photon[0]}~~ #{photon[1]}" unless photon[0]==photon[1]
  end
  photon=photon[0]
  rp=[u40[1]+u40[4],(u40[1]/2.0).ceil+u40[4],(u40[1]/4.0).ceil+u40[4],blu40[1]+blu40[4],(blu40[1]/2.0).ceil+blu40[4],(blu40[1]/4.0).ceil+blu40[4]]
  rm=[u40[1]+u40[5],(u40[1]/2.0).ceil+u40[5],(u40[1]/4.0).ceil+u40[5],blu40[1]+blu40[5],(blu40[1]/2.0).ceil+blu40[5],(blu40[1]/4.0).ceil+blu40[5]]
  rd=[u40[1]+[u40[4],u40[5]].min,(u40[1]/2.0).ceil+[u40[4],u40[5]].min,(u40[1]/4.0).ceil+[u40[4],u40[5]].min,blu40[1]+[blu40[4],blu40[5]].min,(blu40[1]/2.0).ceil+[blu40[4],blu40[5]].min,(blu40[1]/4.0).ceil+[blu40[4],blu40[5]].min]
  rdr="#{u40[4]+u40[5]}#{" (#{blu40[4]+blu40[5]})" if blu40[4]+blu40[5]!=u40[4]+u40[5]}"
  rmg="#{5*u40[2]/8}#{" (#{5*blu40[2]/8})" if 5*blu40[5]/8!=5*u40[5]/8}"
  rs="#{u40[3]+5}+#{" (#{blu40[3]+5}+)" if u40[3]!=blu40[3]}"
  if wl.include?('~~')
    rpc=[cru40[1]+cru40[4],(cru40[1]/2.0).ceil+cru40[4],(cru40[1]/4.0).ceil+cru40[4],crblu40[1]+crblu40[4],(crblu40[1]/2.0).ceil+crblu40[4],(crblu40[1]/4.0).ceil+crblu40[4]]
    rmc=[cru40[1]+cru40[5],(cru40[1]/2.0).ceil+cru40[5],(cru40[1]/4.0).ceil+cru40[5],crblu40[1]+crblu40[5],(crblu40[1]/2.0).ceil+crblu40[5],(crblu40[1]/4.0).ceil+crblu40[5]]
    rdc=[cru40[1]+[cru40[4],cru40[5]].min,(cru40[1]/2.0).ceil+[cru40[4],cru40[5]].min,(cru40[1]/4.0).ceil+[cru40[4],cru40[5]].min,crblu40[1]+[crblu40[4],crblu40[5]].min,(crblu40[1]/2.0).ceil+[crblu40[4],crblu40[5]].min,(crblu40[1]/4.0).ceil+[crblu40[4],crblu40[5]].min]
    rdrc="#{cru40[4]+cru40[5]}#{" (#{crblu40[4]+crblu40[5]})" if crblu40[4]+crblu40[5]!=cru40[4]+cru40[5]}"
    rmgc="#{5*cru40[2]/8}#{" (#{5*crblu40[2]/8})" if 5*crblu40[5]/8!=5*cru40[5]/8}"
    rsc="#{cru40[3]+5}+#{" (#{crblu40[3]+5}+)" if cru40[3]!=crblu40[3]}"
    rdr="~~#{rdr}~~ #{rdrc}" unless rdr==rdrc
    rmg="~~#{rmg}~~ #{rmgc}" unless rmg==rmgc
    rs="~~#{rs}~~ #{rsc}" unless rs==rsc
  else
    rpc=rp.map{|q| q}
    rmc=rm.map{|q| q}
    rdc=rd.map{|q| q}
    rdrc=rdr.split(' ').join(' ')
    rmgc=rmg.split(' ').join(' ')
    rsc=rs.split(' ').join(' ')
  end
  rs="#{rs} Speed"
  rp=["#{rp[0]}#{" (#{rp[3]})" if rp[0]!=rp[3]}","#{rp[1]}#{" (#{rp[4]})" if rp[1]!=rp[4]}","#{rp[2]}#{" (#{rp[5]})" if rp[2]!=rp[5]}"]
  rpc=["#{rpc[0]}#{" (#{rpc[3]})" if rpc[0]!=rpc[3]}","#{rpc[1]}#{" (#{rpc[4]})" if rpc[1]!=rpc[4]}","#{rpc[2]}#{" (#{rpc[5]})" if rpc[2]!=rpc[5]}"]
  rm=["#{rm[0]}#{" (#{rm[3]})" if rm[0]!=rm[3]}","#{rm[1]}#{" (#{rm[4]})" if rm[1]!=rm[4]}","#{rm[2]}#{" (#{rm[5]})" if rm[2]!=rm[5]}"]
  rmc=["#{rmc[0]}#{" (#{rmc[3]})" if rmc[0]!=rmc[3]}","#{rmc[1]}#{" (#{rmc[4]})" if rmc[1]!=rmc[4]}","#{rmc[2]}#{" (#{rmc[5]})" if rmc[2]!=rmc[5]}"]
  rd=["#{rd[0]}#{" (#{rd[3]})" if rd[0]!=rd[3]}","#{rd[1]}#{" (#{rd[4]})" if rd[1]!=rd[4]}","#{rd[2]}#{" (#{rd[5]})" if rd[2]!=rd[5]}"]
  rdc=["#{rdc[0]}#{" (#{rdc[3]})" if rdc[0]!=rdc[3]}","#{rdc[1]}#{" (#{rdc[4]})" if rdc[1]!=rdc[4]}","#{rdc[2]}#{" (#{rdc[5]})" if rdc[2]!=rdc[5]}"]
  for i in 0...3
    rp[i]="~~#{rp[i]}~~ #{rpc[i]}" unless rp[i]==rpc[i]
    rm[i]="~~#{rm[i]}~~ #{rmc[i]}" unless rm[i]==rmc[i]
    rd[i]="~~#{rd[i]}~~ #{rdc[i]}" unless rd[i]==rdc[i]
  end
  rp="Single-hit: #{rp[0]}\nDouble-hit: #{rp[1]}\nQuad-hit: #{rp[2]}"
  rm="Single-hit: #{rm[0]}\nDouble-hit: #{rm[1]}\nQuad-hit: #{rm[2]}"
  rd="Single-hit: #{rd[0]}\nDouble-hit: #{rd[1]}\nQuad-hit: #{rd[2]}"
  x=[['Physical',rp],['Magical',rm]]
  if rd==rp && rd==rm
    x[0][0]='Physical / Magical / Frostbite'
    x[1]=nil
    x.compact!
  elsif rd==rp
    x[0][0]='Physical / Frostbite'
  elsif rd==rm
    x[1][0]='Magical / Frostbite'
  else
    x.push(['Frostbite',rd])
  end
  x.push(['Misc.',"Defense + Resistance = #{rdr}#{"\n\n#{u40[0].gsub('Lavatain','Laevatein')} will take #{photon} extra Photon damage" unless photon=="0"}\n\nRequired to double #{u40[0].gsub('Lavatain','Laevatein')}:\n#{rs}#{"\n#{u40[4]+5}+#{" (#{blu40[4]+5}+)" if blu40[4]!=u40[4]} Defense" if weapon=='Great Flame'}#{"\nOutnumber #{u40[0].gsub('Lavatain','Laevatein')}'s allies within 2 spaces" if weapon=='Thunder Armads'}#{"\n\nMoonbow becomes better than Glimmer when:\nThe enemy has #{rmg} #{'Defense' if atk=="Strength"}#{'Resistance' if atk=="Magic"}#{'as the lower of Def/Res' if atk=="Freeze"}#{'as their targeted defense stat' if atk=="Attack"}" unless @units[j][1][1]=='Healer'}",1])
  ftr="\"Frostbite\" is weapons like Felicia's Plate"
  ftr="#{ftr} and refined dragonstones" if ['Healer','Tome','Bow','Dagger'].include?(@units[j][1][1])
  if photon=="0"
    ftr="#{ftr} that deal damage based on lower of Def and Res."
  else
    ftr="#{ftr}.  \"Photon\" is weapons like Light Brand."
  end
  pic=pick_thumbnail(event,j,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,ftr,pic,x,5)
end

def unit_study(event,name,bot,weapon=nil)
  newmerge=false
  newmerge=true if event.message.text.downcase.split(' ').include?('feb') || event.message.text.downcase.split(' ').include?('february')
  t=Time.now
  newmerge=nil if t.year>2019
  newmerge=nil if t.year==2019 && t.month>2
  newmerge=nil if t.year==2019 && t.month==2 && t.day>8
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      unit_study(event,name[i],bot)
    end
    return nil
  end
  j=find_unit(name,event)
  u40x=@units[j]
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study #{'him' if u40x[10]=='M'}#{'her' if u40x[10]=='F'}#{'them' unless ['M','F'].include?(u40x[10])} at multiple rarities."
      return nil
    end
  end
  args=sever(event.message.text.downcase).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  args.compact!
  mu=false
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    unless x2.nil?
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
    end
  end
  rardata=u40x[9][0].downcase.gsub('0s','')
  highest_merge=0
  if rardata.include?('p') || rardata.include?('s') || rardata.include?('r')
    highest_merge=@max_rarity_merge[1]
  elsif rardata.include?('-')
    highest_merge=0
  else
    highest_merge=[@max_rarity_merge[1],rardata.gsub('2y','').length/2-1].min
  end
  r=[]
  for i in 0...@max_rarity_merge[0]
    r.push(make_stats_string(event,name,i+1,boon,bane,0-highest_merge))
  end
  lowest_rarity=@max_rarity_merge[0]
  summon_type=[[],[],[],[],[],[],[]]
  for m in 1...@max_rarity_merge[0]+1
    lowest_rarity=[m,lowest_rarity].min if has_any?(rardata.scan(/.{1,2}/),["#{m}p","#{m}d","#{m}g","#{m}f","#{m}q","#{m}t","#{m}s","#{m}y","#{m}b"])
    summon_type[0].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}p") # Summon Pool
    summon_type[1].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}d") # Daily Rotation Heroes
    summon_type[2].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}g") # Grand Hero Battles
    summon_type[3].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}f") # free heroes
    summon_type[4].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}q") # quest rewards
    summon_type[5].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}t") # Tempest Trials rewards
    summon_type[6].push("Seasonal #{m}#{@rarity_stars[m-1]} summon") if rardata.include?("#{m}s")
    summon_type[6].push("Story unit starting at #{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}y")
    summon_type[6].push("Purchasable at #{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}b")
    summon_type[6].push("Grail summon at #{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}r")
  end
  if summon_type[6].include?('Story unit starting at 2<:Icon_Rarity_2:448266417872044032>') && summon_type[6].include?('Story unit starting at 4<:Icon_Rarity_4:448266418459377684>')
    for i in 0...summon_type[6].length
      if summon_type[6][i]=='Story unit starting at 2<:Icon_Rarity_2:448266417872044032>'
        summon_type[6][i]='Story unit starting at 2<:Icon_Rarity_2:448266417872044032> (prior to version 2.5.0)'
      elsif summon_type[6][i]=='Story unit starting at 4<:Icon_Rarity_4:448266418459377684>'
        summon_type[6][i]='Story unit starting at 4<:Icon_Rarity_4:448266418459377684> (after version 2.5.0)'
      end
    end
  end
  for m in 0...5
    summon_type[m]=summon_type[m].sort{|a,b| a <=> b}
  end
  mz=['summon','daily rotation battles','Grand Hero Battle','free hero','quest reward','Tempest Trial reward']
  for m in 0...6
    if summon_type[m].length>0
      summon_type[m]="#{summon_type[m].join('/')} #{mz[m]}"
    else
      summon_type[m]=nil
    end
  end
  if summon_type[6].length>0
    summon_type[6]=summon_type[6].join(', ')
  else
    summon_type[6]=nil
  end
  summon_type.compact!
  if summon_type.nil? || summon_type.length.zero?
    summon_type=['Unobtainable']
    lowest_rarity=1
  end
  summon_type=summon_type.join(', ')
  if j<0
    event.respond 'No unit was included'
    return nil
  end
  atk='Attack'
  atk='Magic' if ['Tome','Dragon','Healer'].include?(u40x[1][1])
  atk='Strength' if ['Blade','Bow','Dagger'].include?(u40x[1][1])
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='Strength'
    n=n[n.length-1] if atk=='Magic'
    n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,5,0,boon,bane)
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    summon_type="\n*Female:* #{summon_type}\n*Male:* 3<:Icon_Rarity_3:448266417934958592>/4<:Icon_Rarity_4:448266418459377684> summon"
    unless highest_merge==@max_rarity_merge[1]
      r=[]
      for i in 0...@max_rarity_merge[0]
        r.push(make_stats_string(event,name,i+1,boon,bane,0-highest_merge))
      end
      highest_merge="\n*Female:* #{highest_merge}\n*Male:* #{@max_rarity_merge[1]}\n"
    end
  end
  xcolor=unit_color(event,j,u40[0],0,mu)
  xcolor=0x9400D3 if u40[0]=='Kiran'
  rar=[]
  for i in 0...@max_rarity_merge[0]
    rx=@rarity_stars[i]*(i+1)
    rx="#{i+1}-star" if i>@rarity_stars.length-1
    rar.push([rx,r[i]]) if (lowest_rarity<=i+1 && ((boon=="" && bane=="") || i>=3)) || args.include?('full') || args.include?('rarities') || i==@max_rarity_merge[0]-1
  end
  pic=pick_thumbnail(event,j,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","**Available rarities:** #{summon_type}#{"\n**Highest available merge:** #{highest_merge}" unless highest_merge==@max_rarity_merge[1]}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\n**Merge calculation formula:** #{'Current (use the word "Feb" to see the new one)' unless newmerge}#{'Feb' if newmerge}" unless newmerge.nil?}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,rar,2)
end

def heal_study(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      heal_study(event,name[i],bot,weapon)
    end
    return nil
  end
  name=find_name_in_string(event) if name.nil?
  j=find_unit(name,event)
  u40x=@units[j]
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[10]=='M'}#{'she does' if u40x[10]=='F'}#{'they do' unless ['M','F'].include?(u40x[10])} with each healing staff."
      return nil
    end
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  flurp[5]='' if flurp[5].nil?
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  untz=@units.map{|q| q}
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Legendary','Mythical')}
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Mythical','Legendary')}
  end
  blessing.compact!
  args.compact!
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  weapon='-' if weapon.nil?
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1]
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      weaponz=@dev_units[dv][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1]
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      weaponz=x[x2][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
    end
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0]
      else
        w2=@skills[find_skill(weapon,event)]
      end
      if weapon2=='-'
        w22=['-',0,0]
      else
        w22=@skills[find_skill(weapon2,event)]
      end
      diff_num=[w2[2]-w22[2],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=get_bonus_type(event)
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[0]==weapon}
  ww2=-1 if ww2.nil?
  w2=sklz[ww2]
  if w2[15].nil?
    refinement=nil
  elsif w2[15].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[15][0,1].to_i.to_s==w2[15][0,1] && refinement=='Effect'
    refinement=nil if w2[15][1,1]=='*'
  elsif w2[0,1]=='-' && w2[15][1,1].to_i.to_s==w2[15][1,1] && refinement=='Effect'
    refinement=nil if w2[15][2,1]=='*'
  end
  refinement=nil if w2[5]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[5]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  atk='Attack'
  atk='Magic' if ['Tome','Dragon','Healer'].include?(u40x[1][1])
  atk='Strength' if ['Blade','Bow','Dagger'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  atk='Freeze' if has_weapon_tag?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='Strength'
    n=n[n.length-1] if atk=='Magic'
    n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,j,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|q| q}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed) if wl.include?('~~')
  cru40=u40.map{|q| q} unless wl.include?('~~')
  if u40[0]=='Kiran'
    u40[1]=0
    u40[2]=0
    u40[3]=0
    u40[4]=0
    u40[5]=0
    mu=false
    tempest=false
    xcolor=0x9400D3
    stat_skills=[]
    stat_skills_2=[]
  end
  blu40=u40.map{|a| a}
  crblu40=cru40.map{|a| a}
  blu40=apply_stat_skills(event,stat_skills_2,blu40)
  crblu40=apply_stat_skills(event,stat_skills_2,crblu40)
  atkk=u40[2]
  hppp=u40[1]
  blatkk=blu40[2]
  blhppp=blu40[1]
  cratkk=cru40[2]
  crhppp=cru40[1]
  crblatkk=crblu40[2]
  crblhppp=crblu40[1]
  staves=[]
  staves.push("**Heal:** heals target for 5 HP, 15 HP when Imbue triggers\n\n**Mend:** heals target for 10 HP, 20 HP when Imbue triggers\n\n**Physic:** heals target for 8 HP, 18 HP when Imbue triggers") if event.message.text.downcase.include?(' all')
  d=[atkk/2,8].max
  d2=[blatkk/2,8].max
  cd=[cratkk/2,8].max
  cd2=[crblatkk/2,8].max
  i="#{d+10}#{" (#{d2+10})" unless d==d2}"
  ci="#{cd+10}#{" (#{cd2+10})" unless cd==cd2}"
  i="~~#{i}~~ #{ci}" unless i==ci
  d="#{d}#{" (#{d2})" unless d==d2}"
  cd="#{cd}#{" (#{cd2})" unless cd==cd2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves.push("**Physic+:** heals target for #{d} HP, #{i} HP when Imbue triggers")
  staves.push('~~Phsyic[+] has a range of 2~~')
  staves.push(' ')
  staves.push('**Recover:** heals target for 15 HP, 25 HP when Imbue triggers') if event.message.text.downcase.include?(' all')
  d=[atkk/2+10,15].max
  d2=[blatkk/2+10,15].max
  cd=[cratkk/2+10,15].max
  cd2=[crblatkk/2+10,15].max
  i="#{d+10}#{" (#{d2+10})" unless d==d2}"
  ci="#{cd+10}#{" (#{cd2+10})" unless cd==cd2}"
  i="~~#{i}~~ #{ci}" unless i==ci
  d="#{d}#{" (#{d2})" unless d==d2}"
  cd="#{cd}#{" (#{cd2})" unless cd==cd2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves.push("**Recover+:** heals target for #{d} HP, #{i} HP when Imbue triggers")
  staves.push(' ')
  staves.push('**Restore:** heals target for 8 HP, 18 HP when Imbue triggers') if event.message.text.downcase.include?(' all')
  d=[atkk/2,8].max
  d2=[blatkk/2,8].max
  cd=[cratkk/2,8].max
  cd2=[crblatkk/2,8].max
  i="#{d+10}#{" (#{d2+10})" unless d==d2}"
  ci="#{cd+10}#{" (#{cd2+10})" unless cd==cd2}"
  i="~~#{i}~~ #{ci}" unless i==ci
  d="#{d}#{" (#{d2})" unless d==d2}"
  cd="#{cd}#{" (#{cd2})" unless cd==cd2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves.push("**Restore+:** heals target for #{d} HP, #{i} HP when Imbue triggers")
  staves.push('~~Restore[+] will also remove any negative status effects placed on the target.~~')
  staves.push(' ')
  d=hppp-1
  d2=blhppp-1
  cd=crhppp-1
  cd2=crblhppp-1
  s="0-#{d}#{" (0-#{d2})" unless d==d2}"
  cs="0-#{cd}#{" (0-#{cd2})" unless cd==cd2}"
  i="17-#{d+17}#{" (17-#{d2+17})" unless d==d2}"
  ci="17-#{cd+17}#{" (17-#{cd2+17})" unless cd==cd2}"
  d="7-#{d+7}#{" (7-#{d2+7})" unless d==d2}"
  cd="7-#{cd+7}#{" (7-#{cd2+7})" unless cd==cd2}"
  s="~~#{s}~~ #{cs}" unless s==cs
  i="~~#{i}~~ #{ci}" unless i==ci
  d="~~#{d}~~ #{cd}" unless d==cd
  staves.push("**Reconcile:** heals target for 7 HP, 17 HP when Imbue triggers, also heals #{u40[0].gsub('Lavatain','Laevatein')} for 7 HP\n\n**Martyr:** heals target for #{d} HP, #{i} HP when Imbue triggers, also heals #{u40[0].gsub('Lavatain','Laevatein')} for #{s} HP") if event.message.text.downcase.include?(" all")
  d=[hppp-1,[atkk/2,7].max]
  d2=[blhppp-1,[blatkk/2,7].max]
  cd=[crhppp-1,[cratkk/2,7].max]
  cd2=[crblhppp-1,[crblatkk/2,7].max]
  s="0-#{d[0]}#{" (0-#{d2[0]})" unless d[0]==d2[0]}"
  cs="0-#{cd[0]}#{" (0-#{cd2[0]})" unless cd[0]==cd2[0]}"
  i="#{d[1]+10}-#{d[0]+d[1]+10}#{" (#{d2[1]+10}-#{d2[0]+d2[1]+10})" unless d==d2}"
  ci="#{cd[1]+10}-#{cd[0]+cd[1]+10}#{" (#{cd2[1]+10}-#{cd2[0]+cd2[1]+10})" unless cd==cd2}"
  d="#{d[1]}-#{d[0]+d[1]}#{" (#{d2[1]}-#{d2[0]+d2[1]})" unless d==d2}"
  cd="#{cd[1]}-#{cd[0]+cd[1]}#{" (#{cd2[1]}-#{cd2[0]+cd2[1]})" unless cd==cd2}"
  i="~~#{i}~~ #{ci}" unless i==ci
  s="~~#{s}~~ #{cs}" unless s==cs
  d="~~#{d}~~ #{cd}" unless d==cd
  staves.push("**Martyr+:** heals target for #{d} HP, #{i} HP when Imbue triggers, also heals #{u40[0].gsub('Lavatain','Laevatein')} for #{s} HP")
  staves.push("~~How much Martyr[+] heals is based on how much damage *#{u40[0].gsub('Lavatain','Laevatein')}* has taken.~~")
  staves.push(" ")
  staves.push("**Rehabilitate:** heals target for 7-105 HP, 17-115 HP when Imbue triggers") if event.message.text.downcase.include?(" all")
  d=[atkk/2-10,7].max
  d2=[blatkk/2-10,7].max
  cd=[cratkk/2-10,7].max
  cd2=[crblatkk/2-10,7].max
  i="#{d+10}-#{d+108}#{" (#{d2+10}-#{d2+108})" unless d==d2}"
  ci="#{cd+10}-#{cd+108}#{" (#{cd2+10}-#{cd2+108})" unless cd==cd2}"
  d="#{d}-#{d+98}#{" (#{d2}-#{d2+98})" unless d==d2}"
  cd="#{cd}-#{cd+98}#{" (#{cd2}-#{cd2+98})" unless cd==cd2}"
  i="~~#{i}~~ #{ci}" unless i==ci
  d="~~#{d}~~ #{cd}" unless d==cd
  staves.push("**Rehabilitate+:** heals target for #{d} HP, #{i} HP when Imbue triggers")
  staves.push("~~How much Rehabilitate[+] heals is based on how much damage the target has taken.~~\n~~If they are above 50% HP, the lower end of the range is how much is healed.~~")
  pic=pick_thumbnail(event,j,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  k="__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all") || k.length+staves.join("\n").length>=1950
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}"
    event.respond staves.join("\n")
  else
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,[["Staves",staves.join("\n")]])
  end
end

def proc_study(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      proc_study(event,name[i],bot,weapon)
    end
    return nil
  end
  name=find_name_in_string(event) if name.nil?
  j=find_unit(name,event)
  u40x=@units[j]
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[10]=='M'}#{'she does' if u40x[10]=='F'}#{'they do' unless ['M','F'].include?(u40x[10])} with each proc skill."
      return nil
    end
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  flurp[5]='' if flurp[5].nil?
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  untz=@units.map{|q| q}
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Legendary','Mythical')}
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Mythical','Legendary')}
  end
  blessing.compact!
  args.compact!
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  weapon='-' if weapon.nil?
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  wrathcount=0
  wrathcount+=1 if has_any?(event.message.text.downcase.split(' '),['wrath','wrath1','wrath2','wrath3'])
  wrathcount+=1 if count_in(event.message.text.downcase.split(' '),['wrath','wrath1','wrath2','wrath3'])>=2
  wrathsub=''
  wrathsub='Bushido' if event.message.text.downcase.split(' ').include?('bushido') && u40[0]=='Ryoma(Supreme)'
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      wrathcount=0
      wrathsub=''
      rarity=@dev_units[dv][1]
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      weaponz=@dev_units[dv][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      wrathcount+=1 if ['Wrath','Wrath 1','Wrath 2','Wrath 3'].include?(@dev_units[dv][10][-1])
      wrathcount+=1 if ['Wrath','Wrath 1','Wrath 2','Wrath 3'].include?(@dev_units[dv][12])
      wrathsub='Bushido' if 'Bushido'==@dev_units[dv][10][-1]
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      wrathcount=0
      rarity=x[x2][1]
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      weaponz=x[x2][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      wrathcount+=1 if ['Wrath','Wrath 1','Wrath 2','Wrath 3'].include?(x[x2][10][-1])
      wrathcount+=1 if ['Wrath','Wrath 1','Wrath 2','Wrath 3'].include?(x[x2][12])
      wrathsub='Bushido' if 'Bushido'==x[x2][10][-1]
    end
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0]
      else
        w2=@skills[find_skill(weapon,event)]
      end
      if weapon2=='-'
        w22=['-',0,0]
      else
        w22=@skills[find_skill(weapon2,event)]
      end
      diff_num=[w2[2]-w22[2],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=get_bonus_type(event)
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[0]==weapon}
  ww2=-1 if ww2.nil?
  w2=sklz[ww2]
  if w2[15].nil?
    refinement=nil
  elsif w2[15].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[15][0,1].to_i.to_s==w2[15][0,1] && refinement=='Effect'
    refinement=nil if w2[15][1,1]=='*'
  elsif w2[0,1]=='-' && w2[15][1,1].to_i.to_s==w2[15][1,1] && refinement=='Effect'
    refinement=nil if w2[15][2,1]=='*'
  end
  refinement=nil if w2[5]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[5]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  mergetext=''
  if refinement.nil? || refinement.length==0
    m=w2[11].split(', ')
    m=m.map{|q| q.gsub(/\(T\)\(E\)|\(TE\)|\(E\)\(T\)|\(ET\)/,'(E)').gsub(/\(T\)\(R\)|\(TR\)|\(R\)\(T\)|\(RT\)/,'(R)')} if w2[5].split(', ')[0]=='Beasts Only' && transformed
    m=m.reject{|q| !['(E)','(R)'].include?(q[0,3])}.reject{|q| q[3,5]!='WoDao' && q[3,6]!='Killer' && !['SlowSpecial','SpecialSlow'].include?(q[3,11])}
    mx=['Atk','Spd','Def','Res']
    mx=['Wrathful','Dazzling'] if w2[5]=='Staff Users Only'
    if m.length<=0
    elsif m.length==1 && m[0][0,3]=='(R)'
      mergetext="#{mergetext}\n\n#{w2[0]} has a *#{m[0][3,m[0].length-3]}* effect when refined.  This can affect the proc calculations.\nTo include a refinement, try typing the weapon as \"#{w2[0]} (+) #{mx.sample} Mode\" instead."
    elsif m.length==1 && m[0][0,3]=='(E)'
      mergetext="#{mergetext}\n\n#{w2[0]} has a *#{m[0][3,m[0].length-3]}* effect when refined into its Effect Mode.  This can affect the proc calculations.\nTo include a refinement, try typing the weapon as \"#{w2[0]} (+) Effect Mode\" instead."
    else
      mx.unshift('Effect')
      mergetext="#{mergetext}\n\nThe following effects can be applied to #{w2[0]} via Weapon Refinement.  This can affect the proc calculations."
      m2=m.reject{|q| q[0,3]=='(E)'}.map{|q| q[3,q.length-3]}
      mergetext="#{mergetext}\nAll refinements: #{m2.join(',')}" if m2.length>0
      m2=m.reject{|q| q[0,3]=='(R)'}.map{|q| q[3,q.length-3]}
      mergetext="#{mergetext}\nEffect Mode only: #{m2.join(',')}" if m2.length>0
      mergetext="#{mergetext}\nTo include a refinement, try typing the weapon as \"#{w2[0]} (+) #{mx.sample} Mode\" instead."
    end
  end
  if w2[5].split(', ')[0]=='Beasts Only' && !transformed
    m=w2[11].split(', ')
    unless refinement.nil? || refinement.length==0
      m=m.map{|q| q.gsub(/\(T\)\(R\)|\(TR\)|\(R\)\(T\)|\(RT\)/,'(T)')}
      m=m.map{|q| q.gsub(/\(T\)\(E\)|\(TE\)|\(E\)\(T\)|\(ET\)/,'(T)')} if refinement=='Effect'
    end
    m=m.reject{|q| q[0,3]!='(T)'}.reject{|q| q[3,5]!='WoDao' && q[3,6]!='Killer' && !['SlowSpecial','SpecialSlow'].include?(q[3,11])}
    if m.length<=0
    elsif m.length==1
      mergetext="#{mergetext}\n\n#{w2[0]} has a *#{m[0][3,m[0].length-3]}* effect when #{u40x[0]} is transformed.\nTo show #{u40x[0]}'s data when transformed, include the word \"Transformed\" in your message."
    else
      mergetext="#{mergetext}\n\nWhen #{u40x[0]} is transformed, #{w2[0]} also has the following effects:\n#{m.join(', ')}\nTo show #{u40x[0]}'s data when transformed, include the word \"Transformed\" in your message."
    end
  end
  atk='Attack'
  atk='Magic' if ['Tome','Dragon','Healer'].include?(u40x[1][1])
  atk='Strength' if ['Blade','Bow','Dagger'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  atk='Freeze' if has_weapon_tag?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='Strength'
    n=n[n.length-1] if atk=='Magic'
    n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,j,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|q| q}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed) if wl.include?('~~')
  cru40=u40.map{|q| q} unless wl.include?('~~')
  if u40[0]=='Kiran'
    u40[1]=0
    u40[2]=0
    u40[3]=0
    u40[4]=0
    u40[5]=0
    mu=false
    tempest=false
    xcolor=0x9400D3
    stat_skills=[]
    stat_skills_2=[]
  end
  blu40=apply_stat_skills(event,stat_skills_2,u40.map{|a| a})
  crblu40=apply_stat_skills(event,stat_skills_2,cru40.map{|a| a})
  hppp=u40[1]-1
  atkk=u40[2]
  spdd=u40[3]
  deff=u40[4]
  ress=u40[5]
  blhppp=blu40[1]-1
  blatkk=blu40[2]
  blspdd=blu40[3]
  bldeff=blu40[4]
  blress=blu40[5]
  crhppp=cru40[1]-1
  cratkk=cru40[2]
  crspdd=cru40[3]
  crdeff=cru40[4]
  crress=cru40[5]
  crblhppp=crblu40[1]-1
  crblatkk=crblu40[2]
  crblspdd=crblu40[3]
  crbldeff=crblu40[4]
  crblress=crblu40[5]
  wdamage=0
  wdamage2=0
  if wrathcount>=1
    wdamage+=10
    wdamage2+=10
    stat_skills.push('Wrath')
  end
  if wrathcount>=2
    wdamage+=10
    wdamage2+=10
    stat_skills.push('Wrath')
  end
  if wrathsub.length>0
    wdamage+=10
    wdamage2+=10
    stat_skills.push(wrathsub)
  end
  wdamage+=10 if has_weapon_tag?('WoDao',sklz[ww2],refinement,transformed)
  wdamage2+=10 if has_weapon_tag?('WoDao',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  cdwn=0
  cdwn-=1 if has_weapon_tag?('Killer',sklz[ww2],refinement,transformed)
  cdwn+=1 if has_weapon_tag?('SlowSpecial',sklz[ww2],refinement,transformed) || has_weapon_tag?('SpecialSlow',sklz[ww2],refinement,transformed)
  cdwn2=0
  cdwn2=cdwn unless wl.include?('~~')
  cdwns=cdwn
  cdwns="~~#{cdwn}~~ #{cdwn2}" unless cdwn2==cdwn
  staves=[[],[],[],[],[],[],[],[],[]]
  g=get_markers(event) 
  procs=@skills.reject{|q| !has_any?(g, q[13]) || q[4]!='Special'}
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Star',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag?('WoDao_Star',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Night Sky')[2],cdwns)
  d="`dmg /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`dmg /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Night Sky - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Astra')[2],cdwns)
  d="`3* dmg /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`3* dmg /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Astra - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Regnal Astra')[2],cdwns)
  d="#{spdd*2/5+wdamage+czz}#{" (#{blspdd*2/5+wdamage+czz})" unless spdd*2/5==blspdd*2/5}"
  cd="#{crspdd*2/5+wdamage2+czz2}#{" (#{crblspdd*2/5+wdamage2+czz2})" unless crspdd*2/5==crblspdd*2/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[0].push("**Regnal Astra - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Regnal Astra')[6].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Glimmer')[2],cdwns)
  d="`dmg /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`dmg /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Glimmer - #{d}, cooldown of #{c}")
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Moon',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag?('WoDao_Moon',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'New Moon')[2],cdwns)
  d="`3* eDR /10#{" +#{wdamage+czz}" if wdamage+czz2>0}`"
  d2="`3* eDR /10#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("New Moon - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Luna')[2],cdwns)
  d="`eDR /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`eDR /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("Luna - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Black Luna')[2],cdwns)
  d="`4* eDR /5#{" +#{wdamage+czz}" if wdamage+czz2>0}`"
  d2="`4* eDR /5#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("**Black Luna - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Black Luna')[6].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Moonbow')[2],cdwns)
  d="`3* eDR /10#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`3* eDR /10#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("Moonbow - #{d}, cooldown of #{c}")
  wd="#{"#{wdamage}, " if wdamage>0}"
  wd="~~#{wdamage}~~ #{wdamage2}, " unless wdamage==wdamage2
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Sun',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag?('WoDao_Sun',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Daylight')[2],cdwns)
  d="`3* #{"(" if wdamage+czz>0}dmg#{" +#{wdamage+czz})" if wdamage+czz>0} /10`"
  d2="`3* #{"(" if wdamage2+czz2>0}dmg#{" +#{wdamage2+czz2})" if wdamage2+czz2>0} /10`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Daylight - #{wd}heals for #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Sol')[2],cdwns)
  d="`#{"(" if wdamage+czz>0}dmg#{" +#{wdamage+czz})" if wdamage+czz>0} /2`"
  d2="`#{"(" if wdamage2+czz2>0}dmg#{" +#{wdamage2+czz2})" if wdamage2+czz2>0} /2`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Sol - #{wd}heals for #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Noontime')[2],cdwns)
  d="`3* #{"(" if wdamage+czz>0}dmg#{" +#{wdamage+czz})" if wdamage+czz>0} /10`"
  d2="`3* #{"(" if wdamage2+czz2>0}dmg#{" +#{wdamage2+czz2})" if wdamage2+czz2>0} /10`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Noontime - #{wd}heals for #{d}, cooldown of #{c}")
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Sun',sklz[ww2],refinement,transformed) || has_weapon_tag?('WoDao_Moon',sklz[ww2],refinement,transformed) || has_weapon_tag?('WoDao_Eclipse',sklz[ww2],refinement,transformed)
  czz2+=10 if (has_weapon_tag?('WoDao_Sun',sklz[ww2],refinement,transformed) || has_weapon_tag?('WoDao_Moon',sklz[ww2],refinement,transformed) || has_weapon_tag?('WoDao_Eclipse',sklz[ww2],refinement,transformed)) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Aether')[2],cdwns)
  d="`eDR /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`eDR /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  h="`#{"(" if wdamage+czz>0}dmg#{" +#{wdamage+czz})" if wdamage+czz>0} /2 + eDR /4`"
  h2="`#{"(" if wdamage2+czz2>0}dmg#{" +#{wdamage2+czz2})" if wdamage2+czz2>0} /2 + eDR /4`"
  h="~~#{h}~~ #{h2}" unless h==h2
  staves[3].push("Aether - #{d}, heals for #{h}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Radiant Aether')[2],cdwns)
  staves[3].push("**Radiant Aether - `#{d}, heals for #{h}, cooldown of #{c}**") if get_match_in_list(procs, 'Radiant Aether')[6].split(', ').include?(u40[0])
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Fire',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag?('WoDao_Fire',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Glowing Ember')[2],cdwns)
  d="#{deff/2+wdamage+czz}#{" (#{bldeff/2+wdamage+czz})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2+czz2}#{" (#{crbldeff/2+wdamage2+czz2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Glowing Ember - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Ignis')[2],cdwns)
  d="#{deff*4/5+wdamage+czz}#{" (#{bldeff*4/5+wdamage+czz})" unless deff*4/5==bldeff*4/5}"
  cd="#{crdeff*4/5+wdamage2+czz2}#{" (#{crbldeff*4/5+wdamage2+czz2})" unless crdeff*4/5==crbldeff*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Ignis - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Bonfire')[2],cdwns)
  d="#{deff/2+wdamage+czz}#{" (#{bldeff/2+wdamage+czz})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2+czz2}#{" (#{crbldeff/2+wdamage2+czz2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Bonfire - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Blue Flame')[2],cdwns)
  d="#{wdamage+czz}-#{10+wdamage+czz}"
  cd="#{wdamage2+czz2}-#{10+wdamage2+czz2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  dx="#{d}"
  d="#{wdamage+czz}-#{25+wdamage+czz}"
  cd="#{wdamage2+czz2}-#{25+wdamage2+czz2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Blue Flame - #{dx} (#{d} when adjacent to an ally), cooldown of #{c}")
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Ice',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag?('WoDao_Ice',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Chilling Wind')[2],cdwns)
  d="#{ress/2+wdamage+czz}#{" (#{blress/2+wdamage+czz})" unless ress/2==blress/2}"
  cd="#{crress/2+wdamage2+czz2}#{" (#{crblress/2+wdamage2+czz2})" unless crress/2==crblress/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Chilling Wind - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Glacies')[2],cdwns)
  d="#{ress*4/5+wdamage+czz}#{" (#{blress*4/5+wdamage+czz})" unless ress*4/5==blress*4/5}"
  cd="#{crress*4/5+wdamage2+czz2}#{" (#{crblress*4/5+wdamage2+czz2})" unless crress*4/5==crblress*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Glacies - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Iceberg')[2],cdwns)
  d="#{ress/2+wdamage+czz}#{" (#{blress/2+wdamage+czz})" unless ress/2==blress/2}"
  cd="#{crress/2+wdamage2+czz2}#{" (#{crblress/2+wdamage2+czz2})" unless crress/2==crblress/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Iceberg - #{d}, cooldown of #{c}")
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Fire',sklz[ww2],refinement,transformed) || has_weapon_tag?('WoDao_Ice',sklz[ww2],refinement,transformed) || has_weapon_tag?('WoDao_Freezeflame',sklz[ww2],refinement,transformed)
  czz2+=10 if (has_weapon_tag?('WoDao_Fire',sklz[ww2],refinement,transformed) || has_weapon_tag?('WoDao_Ice',sklz[ww2],refinement,transformed) || has_weapon_tag?('WoDao_Freezeflame',sklz[ww2],refinement,transformed)) && !wl.include?('~~')
  if procs.map{|q| q[0]}.include?('Freezeflame')
    c=add_number_to_string(get_match_in_list(procs, 'Freezeflame')[2],cdwns)
    d="#{deff/2+ress/2+wdamage+czz}#{" (#{bldeff/2+blress/2+wdamage+czz})" unless ress/2==blress/2}"
    cd="#{crdeff/2+crress/2+wdamage2+czz2}#{" (#{crbldeff/2+crblress/2+wdamage2+czz2})" unless crress/2==crblress/2}"
    d="~~#{d}~~ #{cd}" unless d==cd
    staves[6].push("Freezeflame - #{d}, cooldown of #{c}") if get_match_in_list(procs, 'Freezeflame')[6].split(', ').include?(u40[0])
  end
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Dragon',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag?('WoDao_Dragon',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Dragon Gaze')[2],cdwns)
  d="#{atkk*3/10+wdamage+czz}#{" (#{blatkk*3/10+wdamage+czz})" unless atkk*3/10==blatkk*3/10}"
  cd="#{cratkk*3/10+wdamage2+czz2}#{" (#{crblatkk*3/10+wdamage2+czz2})" unless cratkk*3/10==crblatkk*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Dragon Gaze - Up to #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Dragon Fang')[2],cdwns)
  d="#{atkk/2+wdamage+czz}#{" (#{blatkk/2+wdamage+czz})" unless atkk/2==blatkk/2}"
  cd="#{cratkk/2+wdamage2+czz2}#{" (#{crblatkk/2+wdamage2+czz2})" unless cratkk/2==crblatkk/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Dragon Fang - Up to #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Draconic Aura')[2],cdwns)
  d="#{atkk*3/10+wdamage+czz}#{" (#{blatkk*3/10+wdamage+czz})" unless atkk*3/10==blatkk*3/10}"
  cd="#{cratkk*3/10+wdamage2+czz2}#{" (#{crblatkk*3/10+wdamage2+czz2})" unless cratkk*3/10==crblatkk*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Draconic Aura - Up to #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Fire Emblem')[2],cdwns)
  d="#{spdd*3/10+wdamage+czz}#{" (#{blspdd*3/10+wdamage+czz})" unless spdd*3/10==blspdd*3/10}"
  cd="#{crspdd*3/10+wdamage2+czz2}#{" (#{crblspdd*3/10+wdamage2+czz2})" unless crspdd*3/10==crblspdd*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("**Fire Emblem - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Fire Emblem')[6].split(', ').include?(u40[0])
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag?('WoDao_Darkness',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag?('WoDao_Darkness',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Dragon Gaze')[2],cdwns)
  c=add_number_to_string(get_match_in_list(procs, 'Retribution')[2],cdwns)
  d="#{wdamage+czz}-#{3*hppp/10+wdamage+czz}#{" (#{wdamage+czz}-#{3*blhppp/10+wdamage+czz}) based on HP lost" if 3*hppp/10!=3*blhppp/10}"
  cd="#{wdamage2+czz2}-#{3*crhppp/10+wdamage2+czz2}#{" (#{wdamage2+czz2}-#{3*crblhppp/10+wdamage2+czz2}) based on HP lost" if 3*crhppp/10!=3*crblhppp/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[8].push("Retribution - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Vengeance')[2],cdwns)
  d="#{wdamage+czz}-#{hppp/2+wdamage+czz}#{" (#{wdamage+czz}-#{blhppp/2+wdamage+czz}) based on HP lost" if hppp/2!=blhppp/2}"
  cd="#{wdamage2+czz2}-#{crhppp/2+wdamage2+czz2}#{" (#{wdamage2+czz2}-#{crblhppp/2+wdamage2+czz2}) based on HP lost" if crhppp/2!=crblhppp/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[8].push("Vengeance - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Reprisal')[2],cdwns)
  d="#{wdamage+czz}-#{3*hppp/10+wdamage+czz}#{" (#{wdamage+czz}-#{3*blhppp/10+wdamage+czz}) based on HP lost" if 3*hppp/10!=3*blhppp/10}"
  cd="#{wdamage2+czz2}-#{3*crhppp/10+wdamage2+czz2}#{" (#{wdamage2+czz2}-#{3*crblhppp/10+wdamage2+czz2}) based on HP lost" if 3*crhppp/10!=3*crblhppp/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[8].push("Reprisal - #{d}, cooldown of #{c}")
  pic=pick_thumbnail(event,j,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  k="__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}#{mergetext}\n\neDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all") || k.length+staves.map{|q| q.join("\n")}.join("\n\n").length>=1950
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}#{mergetext}\n\neDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations"
    s=""
    for i in 0...staves.length
      s=extend_message(s,staves[i].join("\n"),event,2) unless staves[i].length.zero?
    end
    event.respond s
  else
    flds=[["<:Special_Offensive_Star:454473651396542504>Star",staves[0],1],["<:Special_Offensive_Moon:454473651345948683>Moon",staves[1]],["<:Special_Offensive_Sun:454473651429965834>Sun",staves[2]],["<:Special_Offensive_Eclipse:454473651308199956>Eclipse",staves[3],1],["<:Special_Offensive_Fire:454473651861979156>Fire",staves[4]],["<:Special_Offensive_Ice:454473651291422720>Ice",staves[5]],["<:Special_Offensive_Fire:454473651861979156><:Special_Offensive_Ice:454473651291422720>Freezeflame",staves[6]],["<:Special_Offensive_Dragon:454473651186696192>Dragon",staves[7],1],["<:Special_Offensive_Darkness:454473651010535435>Darkness",staves[8]]]
    for i in 0...flds.length
      if flds[i][1].length.zero?
        flds[i]=nil
      else
        flds[i][1]=flds[i][1].join("\n")
      end
    end
    flds.compact!
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}#{mergetext}\n",xcolor,"eDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations",pic,flds)
  end
end

def phase_study(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      phase_study(event,name[i],bot,weapon)
    end
    return nil
  end
  name=find_name_in_string(event) if name.nil?
  j=find_unit(name,event)
  u40x=@units[j]
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[10]=='M'}#{'she does' if u40x[10]=='F'}#{'they do' unless ['M','F'].include?(u40x[10])} in each phase."
      return nil
    end
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  flurp[5]='' if flurp[5].nil?
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  untz=@units.map{|q| q}
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Legendary','Mythical')}
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    blessing=blessing.map{|q| q.gsub('Mythical','Legendary')}
  end
  blessing.compact!
  args.compact!
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  weapon='-' if weapon.nil?
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1]
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      weaponz=@dev_units[dv][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1]
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      weaponz=x[x2][6].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
    end
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0]
      else
        w2=@skills[find_skill(weapon,event)]
      end
      if weapon2=='-'
        w22=['-',0,0]
      else
        w22=@skills[find_skill(weapon2,event)]
      end
      diff_num=[w2[2]-w22[2],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=get_bonus_type(event)
  deftile=false
  deftile=true if event.message.text.downcase.split(' ').include?('defensetile')
  deftile=true if event.message.text.downcase.split(' ').include?('defencetile')
  deftile=true if event.message.text.downcase.split(' ').include?('deftile')
  deftile=true if event.message.text.downcase.split(' ').include?('defensivetile')
  deftile=true if event.message.text.downcase.split(' ').include?('defencivetile')
  deftile=true if event.message.text.downcase.split(' ').include?('defenseterrain')
  deftile=true if event.message.text.downcase.split(' ').include?('defenceterrain')
  deftile=true if event.message.text.downcase.split(' ').include?('defterrain')
  deftile=true if event.message.text.downcase.split(' ').include?('defensiveterrain')
  deftile=true if event.message.text.downcase.split(' ').include?('defenciveterrain')
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[0]==weapon}
  ww2=-1 if ww2.nil?
  w2=sklz[ww2]
  if w2[15].nil?
    refinement=nil
  elsif w2[15].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[15][0,1].to_i.to_s==w2[15][0,1] && refinement=='Effect'
    refinement=nil if w2[15][1,1]=='*'
  elsif w2[0,1]=='-' && w2[15][1,1].to_i.to_s==w2[15][1,1] && refinement=='Effect'
    refinement=nil if w2[15][2,1]=='*'
  end
  refinement=nil if w2[5]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[5]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  atk='<:StrengthS:514712248372166666> Attack'
  atk='<:MagicS:514712247289774111> Magic' if ['Tome','Healer','Dragon'].include?(u40x[1][1])
  atk='<:StrengthS:514712248372166666> Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  atk='<:FreezeS:514712247474585610> Freeze' if has_weapon_tag?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='<:StrengthS:514712248372166666> Strength'
    n=n[n.length-1] if atk=='<:MagicS:514712247289774111> Magic'
    n=n.join(' / ') if ['<:StrengthS:514712248372166666> Attack','<:FreezeS:514712247474585610> Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  u40x2=get_stats(event,name,40,5,0,boon,bane)
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,j,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|a| a}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed)
  blu40=u40.map{|a| a}
  crblu40=cru40.map{|a| a}
  blu40=apply_stat_skills(event,stat_skills_2,blu40)
  crblu40=apply_stat_skills(event,stat_skills_2,crblu40)
  u40=make_stat_string_list(u40,blu40)
  cru40=make_stat_string_list(cru40,crblu40)
  u40=make_stat_string_list(u40,cru40,2) if wl.include?('~~')
  if u40[0]=='Kiran'
    u40[1]=0
    u40[2]=0
    u40[3]=0
    u40[4]=0
    u40[5]=0
    mu=false
    tempest=false
    xcolor=0x9400D3
    stat_skills=[]
    stat_skills_2=[]
  end
  stat_skills_3=make_combat_skill_list(name,event,args)
  ppu40=blu40.map{|q| q}
  ppu40=apply_combat_buffs(event,stat_skills_3,ppu40,'Player')
  epu40=blu40.map{|q| q}
  epu40=apply_combat_buffs(event,stat_skills_3,epu40,'Enemy')
  ppu40xw=crblu40.map{|q| q}
  ppu40xw=apply_combat_buffs(event,stat_skills_3,ppu40xw,'Player')
  epu40xw=crblu40.map{|q| q}
  epu40xw=apply_combat_buffs(event,stat_skills_3,epu40xw,'Enemy')
  if has_weapon_tag?('Buffstuffer',zzzl,refinement,transformed)
    m=apply_stat_skills(event,stat_skills_2,[u40[0],0,0,0,0,0])
    for i in 2...6
      ppu40[i]+=m[i] if m[i]>0
      epu40[i]+=m[i] if m[i]>0
    end
  end
  unless weapon.nil? || weapon=='-'
    desc = /((((I|i)f|(w|W)hen) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (attack|combat)))|during combat(| (if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (the |)(attack|combat))))), |)((G|g)rants|((T|t)he u|U|u)nit receives) ((Atk|Spd|Def|Res)(\/|))+?\+\d ((if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (attack|combat)))|during combat(| (if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (the |)(attack|combat)))))/
    desc2 = /((G|g)rants|((T|t)he u|U|u)nit receives) ((Atk|Spd|Def|Res)(\/|))+?\+\d during combat (if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (the |)(attack|combat)))/
    desc3 = /((i|I)f|(W|w)hen) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (the |)(attack|combat))), (grants|((T|t)he u|U|u)nit receives) ((Atk|Spd|Def|Res)(\/|))+?\+\d during combat/
    wpnnn=sklz[ww2][7]
    wpnnn=wpnnn.split(' *** ')[0] if sklz[ww2][5]=='Dagger Users Only'
    x=desc.match(wpnnn).to_s
    x=desc2.match(wpnnn).to_s unless desc2.match(sklz[ww2][7]).nil?
    x=desc3.match(wpnnn).to_s unless desc3.match(sklz[ww2][7]).nil?
    x=nil if !x.nil? && x.include?('to allies') # remove any matches that include "to allies", which were caught in the prior line so they weren't considered non-phase-based
    x=nil if sklz[ww2][7].include?(", #{x}") && (sklz[ww2][7].include?('If foe uses') || sklz[ww2][7].include?('If foe initiates combat and uses'))
    x=nil if sklz[ww2][11].split(', ').include?('(R)Overwrite') && !refinement.nil? && refinement.length>0
    x3=[0,0,0,0,0,0]
    x3pp=[0,0,0,0,0,0]
    x3ep=[0,0,0,0,0,0]
    unless x.nil?
      x2=x.scan(/\d+?/)[0].to_i
      x3[2]+=x2 if x.include?('Atk')
      x3[3]+=x2 if x.include?('Spd')
      x3[4]+=x2 if x.include?('Def')
      x3[5]+=x2 if x.include?('Res')
      x3pp=x3.map{|q| q} unless x.include?('foe initiates') || x.include?('is attacked') || x.include?('is under attack') || x.include?('foe attacks')
      x3ep=x3.map{|q| q} unless x.include?('unit initiates') || x.include?('unit attacks')
    end
    unless refinement.nil? || refinement.length<=1 || sklz[ww2][15].nil?
      inner_skill=sklz[ww2][15]
      if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
        inner_skill=inner_skill[1,inner_skill.length-1]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      elsif inner_skill[0,1]=='-' && inner_skill.length>1
        inner_skill=inner_skill[2,inner_skill.length-2]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      end
      outer_skill='y'
      if inner_skill[0,1]=='*'
        outer_skill=inner_skill[1,inner_skill.length-1]
        inner_skill='y'
      elsif inner_skill.include?(' ** ')
        x=inner_skill.split(' ** ')
        inner_skill=x[0]
        outer_skill=x[1]
      end
      outer_skill=outer_skill.split(' *** ')[0] if sklz[ww2][5]=='Dagger Users Only'
      x=desc.match(outer_skill).to_s
      x=desc2.match(outer_skill).to_s unless desc2.match(outer_skill).nil?
      x=desc3.match(outer_skill).to_s unless desc3.match(outer_skill).nil?
      x=nil if outer_skill.include?(", #{x}") && (outer_skill.include?('If foe uses') || outer_skill.include?('If foe initiates combat and uses'))
      x=nil if !x.nil? && x.include?('to allies')
      unless x.nil?
        x2=x.scan(/\d+?/)[0].to_i
        x3=[0,0,0,0,0,0]
        x3[2]+=x2 if x.include?('Atk')
        x3[3]+=x2 if x.include?('Spd')
        x3[4]+=x2 if x.include?('Def')
        x3[5]+=x2 if x.include?('Res')
        unless x.include?('foe initiates') || x.include?('is attacked') || x.include?('is under attack') || x.include?('foe attacks')
          for i in 0...x3pp.length
            x3pp[i]=[x3pp[i],x3[i]].max
          end
        end
        unless x.include?('unit initiates') || x.include?('unit attacks')
          for i in 0...x3ep.length
            x3ep[i]=[x3ep[i],x3[i]].max
          end
        end
      end
      x=desc.match(inner_skill).to_s
      x=desc2.match(inner_skill).to_s unless desc2.match(inner_skill).nil?
      x=desc3.match(inner_skill).to_s unless desc3.match(inner_skill).nil?
      x=nil if inner_skill.include?(", #{x}") && (inner_skill.include?('If foe uses') || inner_skill.include?('If foe initiates combat and uses'))
      x=nil if !x.nil? && x.include?('to allies')
      unless x.nil? || refinement != 'Effect'
        x2=x.scan(/\d+?/)[0].to_i
        x3=[0,0,0,0,0,0]
        x3[2]+=x2 if x.include?('Atk')
        x3[3]+=x2 if x.include?('Spd')
        x3[4]+=x2 if x.include?('Def')
        x3[5]+=x2 if x.include?('Res')
        unless x.include?('foe initiates') || x.include?('is attacked') || x.include?('is under attack') || x.include?('foe attacks')
          for i in 0...x3pp.length
            x3pp[i]=[x3pp[i],x3[i]].max
          end
        end
        unless x.include?('unit initiates') || x.include?('unit attacks')
          for i in 0...x3ep.length
            x3ep[i]=[x3ep[i],x3[i]].max
          end
        end
      end
    end
    for i in 1...x3pp.length
      ppu40[i]+=x3pp[i]
      epu40[i]+=x3ep[i]
    end
  end
  close=[0,0,0,0,0,0,0,0,0,0,0]
  distant=[0,0,0,0,0,0,0,0,0,0,0]
  for i in 0...stat_skills_3.length
    if stat_skills_3[i]=='Close Spectrum'
      close[2]+=4
      close[3]+=4
      close[4]+=4
      close[5]+=4
    elsif stat_skills_3[i]=='Close Stance'
      close[2]+=4
      close[3]+=4
      close[4]+=4
      close[5]+=4
    elsif stat_skills_3[i][0,12]=='Close Guard '
      close[4]+=stat_skills_3[i].scan(/\d+?/)[0].to_i+1
      close[5]+=stat_skills_3[i].scan(/\d+?/)[0].to_i+1
      close[9]+=stat_skills_3[i].scan(/\d+?/)[0].to_i+1
      close[10]+=stat_skills_3[i].scan(/\d+?/)[0].to_i+1
    elsif stat_skills_3[i][0,6]=='Close '
      close[2]+=2*stat_skills_3[i].scan(/\d+?/)[0].to_i if stat_skills_3[i].include?('Atk')
      close[3]+=2*stat_skills_3[i].scan(/\d+?/)[0].to_i if stat_skills_3[i].include?('Spd')
      close[4]+=2*stat_skills_3[i].scan(/\d+?/)[0].to_i if stat_skills_3[i].include?('Def')
      close[5]+=2*stat_skills_3[i].scan(/\d+?/)[0].to_i if stat_skills_3[i].include?('Def')
    end
    if stat_skills_3[i]=='Distant Spectrum'
      distant[2]+=4
      distant[3]+=4
      distant[4]+=4
      distant[5]+=4
    elsif stat_skills_3[i]=='Distant Stance'
      distant[2]+=4
      distant[3]+=4
      distant[4]+=4
      distant[5]+=4
    elsif stat_skills_3[i][0,14]=='Distant Guard '
      distant[4]+=stat_skills_3[i].scan(/\d+?/)[0].to_i+1
      distant[5]+=stat_skills_3[i].scan(/\d+?/)[0].to_i+1
      distant[9]+=stat_skills_3[i].scan(/\d+?/)[0].to_i+1
      distant[10]+=stat_skills_3[i].scan(/\d+?/)[0].to_i+1
    elsif stat_skills_3[i][0,8]=='Distant '
      distant[2]+=2*stat_skills_3[i].scan(/\d+?/)[0].to_i if stat_skills_3[i].include?('Atk')
      distant[3]+=2*stat_skills_3[i].scan(/\d+?/)[0].to_i if stat_skills_3[i].include?('Spd')
      distant[4]+=2*stat_skills_3[i].scan(/\d+?/)[0].to_i if stat_skills_3[i].include?('Def')
      distant[5]+=2*stat_skills_3[i].scan(/\d+?/)[0].to_i if stat_skills_3[i].include?('Def')
    end
  end
  unless weapon.nil? || weapon=='-'
    tags=zzzl[11].split(', ')
    for i in 0...tags.length
      if tags[i][0,1]=='(' && tags[i][3,1]==')'
        if tags[i][1,2]=='cP'
          close[7]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Atk'
          close[8]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Spd'
          close[9]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Def'
          close[10]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Res'
        elsif tags[i][1,2]=='dP'
          distant[7]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Atk'
          distant[8]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Spd'
          distant[9]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Def'
          distant[10]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Res'
        elsif tags[i][1,2]=='cE'
          close[2]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Atk'
          close[3]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Spd'
          close[4]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Def'
          close[5]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Res'
        elsif tags[i][1,2]=='dE'
          distant[2]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Atk'
          distant[3]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Spd'
          distant[4]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Def'
          distant[5]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Res'
        end
      end
    end
  end
  for i in 1...close.length
    m=[close[i],distant[i]].min
    if i<6
      epu40xw[i]+=m
    else
      ppu40xw[i-5]+=m
    end
    epu40[i]+=m
    close[i]-=m
    distant[i]-=m
  end
  ppu40xw[16]=ppu40xw[1]+ppu40xw[2]+ppu40xw[3]+ppu40xw[4]+ppu40xw[5]
  epu40xw[16]=epu40xw[1]+epu40xw[2]+epu40xw[3]+epu40xw[4]+epu40xw[5]
  for i in 1...6
    ppu40xw[i]="#{ppu40xw[i]}#{" (+#{close[i+5]} against melee)" if close[i+5]>0}#{" (+#{distant[i+5]} against ranged)" if distant[i+5]>0}"
    epu40xw[i]="#{epu40xw[i]}#{" (+#{close[i]} against melee)" if close[i]>0}#{" (+#{distant[i]} against ranged)" if distant[i]>0}"
  end
  ppu40[16]=ppu40[1]+ppu40[2]+ppu40[3]+ppu40[4]+ppu40[5]
  epu40[16]=epu40[1]+epu40[2]+epu40[3]+epu40[4]+epu40[5]
  zzzl=sklz[ww2]
  if has_weapon_tag?('CloseStance',zzzl,refinement,transformed)
    close[2]+=4
    close[3]+=4
    close[4]+=4
    close[5]+=4
  end
  if has_weapon_tag?('CloseDef',zzzl,refinement,transformed)
    close[4]+=6
    close[5]+=6
  end
  if has_weapon_tag?('CloseAtk',zzzl,refinement,transformed)
    close[2]+=6
  end
  if has_weapon_tag?('CloseSpd',zzzl,refinement,transformed)
    close[3]+=6
  end
  if has_weapon_tag?('DistantStance',zzzl,refinement,transformed)
    distant[2]+=4
    distant[3]+=4
    distant[4]+=4
    distant[5]+=4
  end
  if has_weapon_tag?('DistantDef',zzzl,refinement,transformed)
    distant[4]+=6
    distant[5]+=6
  end
  if has_weapon_tag?('DistantAtk',zzzl,refinement,transformed)
    distant[2]+=6
  end
  if has_weapon_tag?('DistantSpd',zzzl,refinement,transformed)
    distant[3]+=6
  end
  for i in 1...close.length
    m=[close[i],distant[i]].min
    if i<6
      epu40[i]+=m
    else
      ppu40[i-5]+=m
    end
    close[i]-=m
    distant[i]-=m
  end
  if deftile
    ppu40[4]=(ppu40[4]*1.3).to_i
    epu40[4]=(epu40[4]*1.3).to_i
    ppu40xw[4]=(ppu40xw[4]*1.3).to_i
    epu40xw[4]=(epu40xw[4]*1.3).to_i
    close[4]=(close[4]*1.3).to_i
    distant[4]=(distant[4]*1.3).to_i
    close[9]=(close[9]*1.3).to_i
    distant[9]=(distant[9]*1.3).to_i
    ppu40[5]=(ppu40[5]*1.3).to_i
    epu40[5]=(epu40[5]*1.3).to_i
    ppu40xw[5]=(ppu40xw[5]*1.3).to_i
    epu40xw[5]=(epu40xw[5]*1.3).to_i
    close[5]=(close[5]*1.3).to_i
    distant[5]=(distant[5]*1.3).to_i
    close[10]=(close[10]*1.3).to_i
    distant[10]=(distant[10]*1.3).to_i
  end
  for i in 1...6
    ppu40[i]="#{ppu40[i]}#{" (+#{close[i+5]} against melee)" if close[i+5]>0}#{" (+#{distant[i+5]} against ranged)" if distant[i+5]>0}"
    epu40[i]="#{epu40[i]}#{" (+#{close[i]} against melee)" if close[i]>0}#{" (+#{distant[i]} against ranged)" if distant[i]>0}"
  end
  for i in 0...ppu40.length
    ppu40[i]="~~#{ppu40[i]}~~ #{ppu40xw[i]}" if ppu40[i]!=ppu40xw[i] && wl.include?('~~')
  end
  for i in 0...epu40.length
    epu40[i]="~~#{epu40[i]}~~ #{epu40xw[i]}" if epu40[i]!=epu40xw[i] && wl.include?('~~')
  end
  bin=((u40x2[1]+u40x2[2]+u40x2[3]+u40x2[4]+u40x2[5])/5)*5
  if rarity>=5 && !stat_skills.nil? && !stat_skills.length.zero?
    lookout=[]
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
      lookout=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
        lookout.push(eval line)
      end
      lookout=lookout.reject{|q| !['Stat-Affecting'].include?(q[3][0,q[3].length-2])}
    end
    for i in 0...stat_skills.length
      unless lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5].nil?
        bin=[bin,lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5]].max
      end
    end
  end
  pic=pick_thumbnail(event,j,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(' all')
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense Tile\n" if deftile}#{display_stat_skills(j,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}"
    event.respond "**Displayed stats:**  #{u40[1]} / #{u40[2]} / #{u40[3]} / #{u40[4]} / #{u40[5]} - Score: #{bin/5+merges*2+rarity*5+blessing.length*4+90}+`SP`/100\n**#{"Player Phase" unless ppu40==epu40}#{"In-combat Stats" if ppu40==epu40}:**  #{ppu40[1]} / #{ppu40[2]} / #{ppu40[3]} / #{ppu40[4]} / #{ppu40[5]}  (#{ppu40[16]} BST)#{"\n**Enemy Phase:**  #{epu40[1]} / #{epu40[2]} / #{epu40[3]} / #{epu40[4]} / #{epu40[5]}  (#{epu40[16]} BST)" unless ppu40==epu40}"
  elsif ppu40==epu40
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense Tile\n" if deftile}#{display_stat_skills(j,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,[["Displayed stats","<:HP_S:514712247503945739> HP: #{u40[1]}\n#{atk}: #{u40[2]}\n<:SpeedS:514712247625580555> Speed: #{u40[3]}\n<:DefenseS:514712247461871616> Defense: #{u40[4]}\n<:ResistanceS:514712247574986752> Resistance: #{u40[5]}\n\nBST: #{u40[16]}\nScore: #{bin/5+merges*2+rarity*5+blessing.length*4+90}+`SP`/100"],["In-combat Stats","<:HP_S:514712247503945739> HP: #{ppu40[1]}\n#{atk}: #{ppu40[2]}\n<:SpeedS:514712247625580555> Speed: #{ppu40[3]}\n<:DefenseS:514712247461871616> Defense: #{ppu40[4]}\n<:ResistanceS:514712247574986752> Resistance: #{ppu40[5]}\n\nBST: #{ppu40[16]}"]])
  else
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(event,rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense Tile\n" if deftile}#{display_stat_skills(j,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,transformed,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,[["Displayed stats","<:HP_S:514712247503945739> HP: #{u40[1]}\n#{atk}: #{u40[2]}\n<:SpeedS:514712247625580555> Speed: #{u40[3]}\n<:DefenseS:514712247461871616> Defense: #{u40[4]}\n<:ResistanceS:514712247574986752> Resistance: #{u40[5]}\n\nBST: #{u40[16]}\nScore: #{bin/5+merges*2+rarity*5+blessing.length*4+90}+`SP`/100",1],["Player Phase","<:HP_S:514712247503945739> HP: #{ppu40[1]}\n<:Death_Blow:514719899868856340> Attack: #{ppu40[2]}\n<:Darting_Blow:514719899910668298> Speed: #{ppu40[3]}\n<:Armored_Blow:514719899927576578> Defense: #{ppu40[4]}\n<:Warding_Blow:514719900607053824> Resistance: #{ppu40[5]}\n\nBST: #{ppu40[16]}"],["Enemy Phase","<:HP_S:514712247503945739> HP: #{epu40[1]}\n<:Fierce_Stance:514719899873050624> Attack: #{epu40[2]}\n<:Darting_Stance:514719899919056926> Speed: #{epu40[3]}\n<:Steady_Stance:514719899856273408> Defense: #{epu40[4]}\n<:Warding_Stance:514719899562672138> Resistance: #{epu40[5]}\n\nBST: #{epu40[16]}"]])
  end
end

def disp_art(event,name,bot,weapon=nil)
  name=['Robin(M)','Robin(F)'] if name=='Robin'
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      disp_art(event,name[i],bot)
    end
    return nil
  end
  name=find_name_in_string(event) if name.nil?
  untz=@units.map{|q| q}
  j=untz[untz.find_index{|q| q[0]==name}]
  data_load()
  args=event.message.text.downcase.split(' ')
  artype='Face'
  artype='BtlFace' if args.include?('battle') || args.include?('attack') || args.include?('att') || args.include?('atk') || args.include?('attacking')
  artype='BtlFace_D' if args.include?('damage') || args.include?('damaged') || (args.include?('low') && (args.include?('health') || args.include?('hp'))) || args.include?('lowhealth') || args.include?('lowhp') || args.include?('low_health') || args.include?('low_hp') || args.include?('injured')
  artype='BtlFace_C' if args.include?('critical') || args.include?('special') || args.include?('crit') || args.include?('proc')
  art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{j[0].gsub(' ','_')}/#{artype}.png"
  if args.include?('just') || args.include?('justart') || args.include?('blank') || args.include?('noinfo')
    charsx=[[],[],[]]
    disp=''
  else
    if j[0]=='Reinhardt(World)' && (rand(100).zero? || event.message.text.downcase.include?('zelda') || event.message.text.downcase.include?('link') || event.message.text.downcase.include?('master sword'))
      art='https://i.redd.it/pdeqrncp21r01.png'
      j[6]="u/ZachminSSB (ft. #{j[6]})"
    elsif j[0]=='Arden' && (rand(1000).zero? || event.message.text.downcase.include?('infinity'))
      art='https://pbs.twimg.com/media/DcEh5jRWsAAYofz.png'
      j[6]='@_DJSaturn (twitter)'
    end
    disp=''
    nammes=['','','']
    unless j[6].nil? || j[6].length<=0
      m=j[6].split(' as ')
      nammes[0]=m[0]
      disp="#{disp}\n**Artist:** #{m[m.length-1]}"
    end
    unless j[7].nil? || j[7].length<=0
      m=j[7].split(' as ')
      nammes[1]=m[0]
      disp="#{disp}\n**VA (English):** #{m[m.length-1]}"
    end
    unless j[8].nil? || j[8].length<=0
      m=j[8].split(' as ')
      nammes[2]=m[0]
      disp="#{disp}\n**VA (Japanese):** #{m[m.length-1]}"
    end
    g=get_markers(event)
    chars=untz.reject{|q| q[0]==j[0] || !has_any?(g, q[13][0]) || ((q[6].nil? || q[6].length<=0) && (q[7].nil? || q[7].length<=0) && (q[8].nil? || q[8].length<=0))}
    charsx=[[],[],[]]
    for i in 0...chars.length
      x=chars[i]
      unless x[6].nil? || x[6].length<=0 || x[7].nil? || x[7].length<=0 || x[8].nil? || x[8].length<=0
        m=x[6].split(' as ')
        m2=x[7].split(' as ')
        m3=x[8].split(' as ')
        charsx[2].push("#{x[0].gsub('Lavatain','Laevatein')}") if m[0]==nammes[0] && m2[0]==nammes[1] && m3[0]==nammes[2]
      end
      unless x[6].nil? || x[6].length<=0
        m=x[6].split(' as ')
        charsx[0].push(x[0].gsub('Lavatain','Laevatein')) if m[0]==nammes[0] && !charsx[2].include?(x[0].gsub('Lavatain','Laevatein'))
      end
      unless x[7].nil? || x[7].length<=0 || x[8].nil? || x[8].length<=0
        m=x[7].split(' as ')
        m2=x[8].split(' as ')
        charsx[1].push("#{x[0].gsub('Lavatain','Laevatein')} *[Both]*") if m[0]==nammes[1] && m2[0]==nammes[2] && !charsx[2].include?(x[0].gsub('Lavatain','Laevatein'))
      end
      unless x[7].nil? || x[7].length<=0
        m=x[7].split(' as ')
        charsx[1].push("#{x[0].gsub('Lavatain','Laevatein')} *[English]*") if m[0]==nammes[1] && !charsx[1].include?("#{x[0].gsub('Lavatain','Laevatein')} *[Both]*") && !charsx[2].include?(x[0].gsub('Lavatain','Laevatein'))
      end
      unless x[8].nil? || x[8].length<=0
        m=x[8].split(' as ')
        charsx[1].push("#{x[0].gsub('Lavatain','Laevatein')} *[Japanese]*") if m[0]==nammes[2] && !charsx[1].include?("#{x[0].gsub('Lavatain','Laevatein')} *[Both]*") && !charsx[2].include?(x[0].gsub('Lavatain','Laevatein'))
      end
    end
    if event.server.nil? || !bot.user(502288364838322176).on(event.server.id).nil? || @shardizard==4
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FGOServants.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FGOServants.txt').each_line do |line|
          b.push(line)
        end
      else
        b=[]
      end
      for i in 0...b.length
        b[i]=b[i].gsub("\n",'').split('\\'[0])
        unless nammes[0].nil? || nammes[0].length<=0 || b[i][24].nil? || b[i][24].length<=0
          charsx[0].push("FGO Srv-#{b[i][0]}#{"#{'.' if b[i][0].to_i>=2}) #{b[i][1]}" unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}") if b[i][24]==nammes[0]
        end
        unless nammes[2].nil? || nammes[2].length<=0 || b[i][25].nil? || b[i][25].length<=0
          charsx[1].push("FGO Srv-#{b[i][0]}#{"#{'.' if b[i][0].to_i>=2}) #{b[i][1]}" unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} *[Japanese]*") if b[i][25].split(' & ').include?(nammes[2])
        end
      end
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FGOCraftEssances.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FGOCraftEssances.txt').each_line do |line|
          b.push(line)
        end
      else
        b=[]
      end
      for i in 0...b.length
        b[i]=b[i].gsub("\n",'').split('\\'[0])
        unless nammes[0].nil? || nammes[0].length<=0 || b[i][9].nil? || b[i][9].length<=0
          charsx[0].push("FGO CE-#{b[i][0]}#{".) #{b[i][1]}" unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}") if b[i][9]==nammes[0]
        end
      end
    end
    disp='>No information<' if disp.length<=0
  end
  dispx="#{disp}"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    disp="#{disp}\n" if charsx.map{|q| q.length}.max>0
    disp="#{disp}\n**Same artist:** #{charsx[0].join(', ')}" if charsx[0].length>0
    if charsx[1].length>0
      disp="#{disp}\n**Same VA:**"
      disp2=""
      c=charsx[1].reject{|q| !q.include?('*[English]*')}.map{|q| q.gsub(' *[English]*','')}
      disp2="#{disp2}\n*English only:* #{c.join(', ')}" if c.length>0
      c=charsx[1].reject{|q| !q.include?('*[Japanese]*')}.map{|q| q.gsub(' *[Japanese]*','')}
      disp2="#{disp2}\n*Japanese only:* #{c.join(', ')}" if c.length>0
      c=charsx[1].reject{|q| !q.include?('*[Both]*')}.map{|q| q.gsub(' *[Both]*','')}
      disp2="#{disp2}\n*Both languages:* #{c.join(', ')}" if c.length>0
      disp2=disp2[1,disp2.length-1]
      if disp2.include?("\n")
        disp="#{disp}\n#{disp2}"
      else
        disp="#{disp} #{disp2}"
      end
    end
    disp="#{disp}\n**Same __everything__:** #{charsx[2].join(', ')}" if charsx[2].length>0
    disp=dispx if disp.length>=1900
    event.respond "#{disp}\n\n#{art}"
  else
    flds=[]
    flds.push(['Same Artist',charsx[0].join("\n")]) if charsx[0].length>0
    if charsx[1].length>0
      if charsx[1].length==charsx[1].reject{|q| !q.include?('*[English]*')}.length
        flds.push(['Same VA (English)',charsx[1].map{|q| q.gsub(' *[English]*','')}.join("\n")])
      elsif charsx[1].length==charsx[1].reject{|q| !q.include?('*[Japanese]*')}.length
        flds.push(['Same VA (Japanese)',charsx[1].map{|q| q.gsub(' *[Japanese]*','')}.join("\n")])
      elsif charsx[1].length==charsx[1].reject{|q| !q.include?('*[Both]*')}.length
        flds.push(['Same VA (Both)',charsx[1].map{|q| q.gsub(' *[Both]*','')}.join("\n")])
      else
        flds.push(['Same VA',charsx[1].join("\n")])
      end
    end
    flds.push(['Same everything',charsx[2].join("\n"),1]) if charsx[2].length>0
    if flds.length.zero?
      flds=nil
    elsif flds.map{|q| q.join("\n")}.join("\n\n").length>=1500 && safe_to_spam?(event)
      event.channel.send_embed("__**#{j[0].gsub('Lavatain','Laevatein')}**__") do |embed|
        embed.description=disp
        embed.color=unit_color(event,find_unit(j[0],event),j[0],0)
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: art)
      end
      if flds.map{|q| q.join("\n")}.join("\n\n").length>=1900
        for i in 0...flds.length
          event.channel.send_embed('') do |embed|
            embed.color=unit_color(event,find_unit(j[0],event),j[0],0)
            embed.add_field(name: flds[i][0], value: flds[i][1], inline: true)
          end
        end
      else
        event.channel.send_embed('') do |embed|
          embed.color=unit_color(event,find_unit(j[0],event),j[0],0)
          unless flds.nil?
            for i in 0...flds.length
              embed.add_field(name: flds[i][0], value: flds[i][1], inline: true)
            end
          end
        end
      end
      return nil
    elsif flds.map{|q| q.join("\n")}.join("\n\n").length>=1800
      disp="#{disp}\nThe list of units with the same artist and/or VA is so long that I cannot fit it into a single embed. Please use this command in PM."
      flds=nil
    else
      flds[-1][2]=nil if flds.length<3
      flds[-1].compact!
    end
    event.channel.send_embed("__**#{j[0].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,-1,j[0])}__") do |embed|
      embed.description=disp
      embed.color=unit_color(event,find_unit(j[0],event),j[0],0)
      unless flds.nil?
        for i in 0...flds.length
          embed.add_field(name: flds[i][0], value: flds[i][1], inline: flds[i][2].nil?)
        end
      end
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: art)
    end
  end
  return nil
end

def disp_generic_art(event,name,bot)
  args=event.message.text.downcase.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  colors=[]
  weapons=[]
  color_weapons=[]
  movement=[]
  for i in 0...args.length
    args[i]=args[i].downcase.gsub('user','') if args[i].length>4 && args[i][args[i].length-4,4].downcase=='user'
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens','grean','greans'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','colorlesses','colourlesses','clear','clears'].include?(args[i].downcase)
    weapons.push('Blade') if ['physical','blade','blades'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','spell','tomes','mages','spells'].include?(args[i].downcase)
    weapons.push('Dragon') if ['dragon','dragons','breath','manakete','manaketes'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thiefs','thieves'].include?(args[i].downcase)
    weapons.push('Staff') if ['healer','staff','cleric','healers','clerics','staves'].include?(args[i].downcase)
    color_weapons.push('Sword') if ['sword','swords','katana'].include?(args[i].downcase)
    color_weapons.push('Lance') if ['lance','lances','spear','spears','naginata'].include?(args[i].downcase)
    color_weapons.push('Axe') if ['axe','axes','ax','club','clubs'].include?(args[i].downcase)
    color_weapons.push('Red_Tome') if ['redtome','redtomes','redmage','redmages'].include?(args[i].downcase)
    color_weapons.push('Blue_Tome') if ['bluetome','bluetomes','bluemage','bluemages'].include?(args[i].downcase)
    color_weapons.push('Green_Tome') if ['greentome','greentomes','greenmage','greenmages'].include?(args[i].downcase)
    movement.push('Pegasus') if ['flier','flying','flyer','fly','pegasus','fliers','flyers','pegasi'].include?(args[i].downcase)
    movement.push('Wyvern') if ['wyvern','wyverns'].include?(args[i].downcase)
    movement.push('Cavalry') if ['cavalry','horse','pony','horsie','horses','horsies','ponies','cavalier','cavaliers','cav','cavs'].include?(args[i].downcase)
    movement.push('Infantry') if ['infantry','foot','feet'].include?(args[i].downcase)
    movement.push('Armor') if ['armor','armour','armors','armours','armored','armoured'].include?(args[i].downcase)
  end
  if colors.length<=0
    colors=['Red']
    colors=['Colorless'] if weapons.length>0 && ['Dagger','Staff','Bow'].include?(weapons[0])
  end
  weapons=['Tome'] if weapons.length<=0
  color_weapons=["#{colors[0]}_#{weapons[0]}".gsub('Red_Blade','Sword').gsub('Blue_Blade','Lance').gsub('Green_Blade','Axe')] if color_weapons.length<=0
  movement=['Infantry'] if movement.length<=0
  movement[0]='Flier' if color_weapons[0][color_weapons[0].length-6,6]=='Dragon' && ['Pegasus','Wyvern'].include?(movement[0])
  art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/GENERICS/#{color_weapons[0]}_#{movement[0]}/BtlFace.png"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event.respond art
  else
    event.channel.send_embed("__**#{color_weapons[0]}_#{movement[0]}**__") do |embed|
      embed.color=0x800000
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: art)
    end
  end
end

def learnable_skills(event,name,bot,weapon=nil)
  name=['Robin(M)','Robin(F)'] if name=='Robin'
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      learnable_skills(event,name[i],bot)
    end
    return nil
  end
  data_load()
  name=find_name_in_string(event) if name.nil?
  untz=@units.map{|q| q}
  sklz=@skills.map{|q| q}
  j=untz[untz.find_index{|q| q[0]==name}]
  k=sklz.reject{|q| q[4]=='Passive(W)'}.map{|q| q[5]}.uniq
  bbb=[]
  for i in 0...k.length
    k3=true
    k2=k[i].split(', ')
    for i2 in 0...k2.length
      k3=false if k2[i2]=='No one'
      if k2[i2].include?('Excludes')
        k4=true
        if k2[i2].include?('Weapon Users')
          k4=false if k2[i2].include?(j[1][0])
        elsif k2[i2].include?('Users')
          k4=false if k2[i2].include?('Excludes Tome') && j[1][1]=='Tome'
          k4=false if k2[i2].include?('and Tome') && j[1][1]=='Tome'
          k4=false if k2[i2].include?('Excludes Bow') && j[1][1]=='Bow'
          k4=false if k2[i2].include?('and Bow') && j[1][1]=='Bow'
          k4=false if k2[i2].include?('Excludes Dagger') && j[1][1]=='Dagger'
          k4=false if k2[i2].include?('and Dagger') && j[1][1]=='Dagger'
          k4=false if k2[i2].include?(weapon_clss(j[1],event).gsub('Healer','Staff'))
        else
          k4=false if k2[i2].include?('Dragons') && j[1][1]=='Dragon'
          k4=false if k2[i2].include?('Beasts') && j[1][1]=='Beast'
          k4=false if k2[i2].include?(j[3].gsub('Flier','Fliers')) || k2[i2].include?(j[3].gsub('Armor','Armored'))
        end
        k3=(k3 && k4)
      end
      if k2[i2].include?('Only')
        k4=false
        k4=true if k2[i2]=='Dragons Only' && j[1][1]=='Dragon'
        k4=true if k2[i2]=='Beasts Only' && j[1][1]=='Beast'
        k4=true if k2[i2]=='Tome Users Only' && j[1][1]=='Tome'
        k4=true if k2[i2]=='Bow Users Only' && j[1][1]=='Bow'
        k4=true if k2[i2]=='Dagger Users Only' && j[1][1]=='Dagger'
        k4=true if k2[i2]=='Melee Weapon Users Only' && ['Blade','Dragon','Beast'].include?(j[1][1])
        k4=true if k2[i2]=='Ranged Weapon Users Only' && ['Tome','Bow','Dagger','Healer'].include?(j[1][1])
        k4=true if k2[i2].include?(j[3].gsub('Flier','Fliers')) || k2[i2].include?(j[3].gsub('Armor','Armored'))
        k4=true if k2[i2]=="#{weapon_clss(j[1],event).gsub('Healer','Staff')} Users Only"
        k4=true if k2[i2]=="#{j[1][0]} Weapon Users Only"
        k4=true if k2[i2]=='Summon Gun Users Only' && j[0]=='Kiran'
        if k2[i2].include?('Dancers')
          u2=sklz[sklz.find_index{|q| q[0]=='Dance'}]
          b=[]
          for i3 in 0...@max_rarity_merge[0]
            u=u2[9][i3].split(', ')
            for j2 in 0...u.length
              b.push(u[j2].gsub('Lavatain','Laevatein')) unless b.include?(u[j2]) || u[j2].include?('-')
            end
          end
          k4=true if b.include?(j[0])
        end
        if k2[i2].include?('Singers')
          u2=sklz[sklz.find_index{|q| q[0]=='Sing'}]
          b=[]
          for i3 in 0...@max_rarity_merge[0]
            u=u2[9][i3].split(', ')
            for j2 in 0...u.length
              b.push(u[j2].gsub('Lavatain','Laevatein')) unless b.include?(u[j2]) || u[j2].include?('-')
            end
          end
          k4=true if b.include?(j[0])
        end
        k3=(k3 && k4)
      end
    end
    bbb.push(k[i]) if k3
  end
  g=get_markers(event)
  matches3=sklz.reject{|q| !bbb.include?(q[5]) || !has_any?(g, q[13]) || (q[6]!='-' && !q[6].split(', ').include?(j[0])) || q[0].include?('Squad Ace ') || q[0].include?('Initiate Seal ') || (q[4].split(', ').include?('Passive(W)') && !q[4].split(', ').include?('Passive(S)') && !q[4].split(', ').include?('Seal') && q[10].map{|q2| q2.split(', ').length}.max<2)}
  q=sklz[sklz.length-1]
  matches4=collapse_skill_list(matches3,3)
  matches4=split_list(event,matches4,['Weapon','Assist','Special','Passive(A)','Passive(B)','Passive(C)','Passive(S)'],4)
  p1=[[]]
  p2=0
  for i in 0...matches4.length
    if matches4[i][0]=='- - -'
      p1.push([])
      p2+=1
    else
      p1[p2].push(matches4[i][0])
    end
  end
  j=untz.find_index{|q| q[0]==j[0]}
  p1=p1.map{|q| q.join("\n")}
  if p1[0].length+p1[1].length+p1[2].length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    msg="__Skills **#{untz[j][0].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,j)} can learn__"
    msg=extend_message(msg,"<:Skill_Weapon:444078171114045450> *Weapons:* #{p1[0].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"<:Skill_Assist:444078171025965066> *Assists:* #{p1[1].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"<:Skill_Special:444078170665254929> *Specials:* #{p1[2].gsub("\n",', ')}",event,2)
    event.respond msg
  else
    create_embed(event,"__Skills **#{untz[j][0].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,j)} can learn__",'',unit_color(event,j),nil,pick_thumbnail(event,j,bot),[["<:Skill_Weapon:444078171114045450> Weapons",p1[0]],["<:Skill_Assist:444078171025965066> Assists",p1[1]],["<:Skill_Special:444078170665254929> Specials",p1[2]]],4)
  end
  if !safe_to_spam?(event)
    event.respond 'For the passive skills this unit can learn, please use this command in PM.'
    event.respond 'Any undisplayed skill categories have too many applicable skills to display.' if p1.map{|q| q.gsub("\n",', ').length}.max>1900
    return nil
  elsif p1[3].length+p1[4].length+p1[5].length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    msg=''
    msg=extend_message(msg,"<:Passive_A:443677024192823327> *Passives(A):* #{p1[3].gsub("\n",', ')}",event,2) unless p1[3].gsub("\n",', ').length>1900
    msg=extend_message(msg,"<:Passive_B:443677023257493506> *Passives(B):* #{p1[4].gsub("\n",', ')}",event,2) unless p1[4].gsub("\n",', ').length>1900
    msg=extend_message(msg,"<:Passive_C:443677023555026954> *Passives(C):* #{p1[5].gsub("\n",', ')}",event,2) unless p1[5].gsub("\n",', ').length>1900
    msg=extend_message(msg,"<:Passive_S:443677023626330122> *Passives(S):* #{p1[6].gsub("\n",', ')}",event,2) unless p1[6].nil? || p1[6].gsub("\n",', ').length>1900
    msg=extend_message(msg,'Any undisplayed skill categories have too many applicable skills to display.',event,2) if p1.map{|q| q.gsub("\n",', ').length}.max>1900
    event.respond msg
  else
    create_embed(event,'','',unit_color(event,j),nil,nil,[['<:Passive_A:443677024192823327> Passives(A)',p1[3]],['<:Passive_B:443677023257493506> Passives(B)',p1[4]],['<:Passive_C:443677023555026954> Passives(C)',p1[5]]],4)
    create_embed(event,"__<:Passive_S:443677023626330122> Seals **#{untz[j][0].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,j)} can equip__",'',unit_color(event,j),nil,nil,triple_finish(p1[6].split("\n")),4) unless p1[6].nil?
    event.respond 'Any undisplayed skill categories have too many applicable skills to display.' if p1.map{|q| q.gsub("\n",', ').length}.max>1900
  end
  return nil
end

def banner_list(event,name,bot,weapon=nil)
  name=['Robin(M)','Robin(F)'] if name=='Robin'
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      banner_list(event,name[i],bot)
    end
    return nil
  end
  b=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHBanners.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHBanners.txt').each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  for i in 0...b.length
    b[i]=b[i].split('\\'[0])
    b[i][1]=b[i][1].to_i
    b[i][2]=b[i][2].split(', ')
    b[i][4]=nil if !b[i][4].nil? && b[i][4].length<=0
    b[i]=nil if b[i][2][0]=='-'
  end
  justnames=true
  if !safe_to_spam?(event)
    justnames=false if event.message.text.downcase.split(' ').include?('rates') || event.message.text.downcase.split(' ').include?('details') || event.message.text.downcase.split(' ').include?('specifics')
  else
    justnames=false
    justnames=true if event.message.text.downcase.split(' ').include?('justnames') || event.message.text.downcase.split(' ').include?('just_names') || " #{event.message.text.downcase} ".include?(' just names ')
  end
  star_buff=nil
  args=event.message.text.downcase.split(' ').reject{ |a| a.match(/<@!?(?:\d+)>/) }
  for i in 0...args.length
    if args[i].to_i.to_s==args[i]
      star_buff=args[i].to_i if star_buff.nil?
    elsif args[i][0,1]=='+' && args[i][1,args[i].length-1].to_i.to_s==args[i][1,args[i].length-1]
      star_buff=args[i][1,args[i].length-1].to_i if star_buff.nil?
    elsif args[i][0,1]=="-" && args[i][1,args[i].length-1].to_i.to_s==args[i][1,args[i].length-1]
      star_buff=0-args[i][1,args[i].length-1].to_i if star_buff.nil?
    end
  end
  star_buff=0 if star_buff.nil?
  b.compact!
  b.reverse!
  data_load()
  name=find_name_in_string(event) if name.nil?
  untz=@units.map{|q| q}
  j=untz[untz.find_index{|q| q[0]==name}]
  banners=[]
  banner_count=0
  len='%.2f'
  len='%.4f' if @shardizard==4
  if j[9][0].include?('LU')
    banners.push('*Launch Unit*')
    banner_count=-1
  end
  metadata_load()
  fail_mode=@summon_rate[2]%3
  for i in 0...b.length
    percentage=b[i][1]
    percentage=0-percentage if percentage<0
    disperc=percentage*1.0+star_buff*0.5
    disperc=percentage*1.0+star_buff*percentage/(percentage+3.00) if b[i][1]>0
    five_star=3+star_buff*3/(percentage+3)
    if star_buff>=24 && fail_mode==2
      if b[i][1]>0
        disperc=100.00*percentage/(percentage+3.00)
        five_star=300.00/(percentage+3.00)
      else
        disperc=100.00
        five_star=0.00
      end
    end
    four_star=(100.00 - disperc - five_star) * 58.00 / (100.00 - percentage - 3)
    if star_buff>=24 && fail_mode==1
      disperc=50.00
      five_star=50.00
      four_star=0.00
    end
    shared_color=[]
    other_color=[]
    if b[i][2].include?(j[0])
      for i2 in 0...b[i][2].length
        u=untz[untz.find_index{|q| q[0]==b[i][2][i2]}]
        if u[0]==j[0]
        elsif u[1][0]==j[1][0]
          shared_color.push(u[0])
        else
          other_color.push(u[0])
        end
      end
      if justnames
        str=b[i][0]
      else
        tm=''
        unless b[i][4].nil?
          mo=['','January','February','March','April','May','June','July','August','September','October','November','December']
          t=b[i][4].split(', ').map{|q| q.split('/').map{|q2| q2.to_i}}
          tm="\n*Duration:* #{t[0][0]} #{mo[t[0][1]]} #{t[0][2]} - #{t[1][0]} #{mo[t[1][1]]} #{t[1][2]}"
        end
        if !b[i][3].nil? && b[i][3].include?('0')
          str="__*#{b[i][0]}*__#{tm}\n*Multi-banner hybrid with #{shared_color.length+other_color.length+1} total focus units*\n*Starting Focus Chance:* #{len % percentage}% (5<:Icon_Rarity_5p10:448272715099406336>) each banner#{"\n*Current Focus Chance:* #{len % disperc}% (5<:Icon_Rarity_5p10:448272715099406336>) each banner" if star_buff>0}"
        else
          str="__*#{b[i][0]}*__#{tm}#{"\n*Shared Focus Color:* #{shared_color.join(', ')}" if shared_color.length>0}#{"\n*Other Focus Color:* #{other_color.join(', ')}" if other_color.length>0}\n*Starting Focus Chance:* #{len % percentage}% (5<:Icon_Rarity_5p10:448272715099406336>)#{"\n*Current Focus Chance:* #{len % disperc}% (5<:Icon_Rarity_5p10:448272715099406336>)" if star_buff>0}"
        end
        if !b[i][3].nil? && b[i][3].include?('0')
        elsif !b[i][3].nil? && b[i][3].include?('4')
          str="#{str}#{", #{len % (four_star/2)}% (4<:Icon_Rarity_4p10:448272714210476033>)\n*5<:Icon_Rarity_5p10:448272715099406336>#{" Start" unless star_buff>0} Chance:* #{len % (disperc*1.00/(shared_color.length+1))}% (Perceived), #{len % (disperc*1.00/(shared_color.length+other_color.length+1))}% (Actual)" if shared_color.length+other_color.length>0}"
          str="#{str}#{"\n*4<:Icon_Rarity_4p10:448272714210476033>#{" Start" unless star_buff>0} Chance:* #{len % ((four_star/2)/(shared_color.length+1))}% (Perceived), #{len % ((four_star/2)/(shared_color.length+other_color.length+1))}% (Actual)" if shared_color.length+other_color.length>0}"
        else
          str="#{str}#{"\n5<:Icon_Rarity_5p10:448272715099406336> *#{"Start " unless star_buff>0}Chance:* #{len % (disperc*1.00/(shared_color.length+1))}% (Perceived), #{len % (disperc*1.00/(shared_color.length+other_color.length+1))}% (Actual)" if shared_color.length+other_color.length>0}"
        end
      end
      banners.push(str)
    end
  end
  banner_count+=banners.length
  ftr="Banner count: #{banner_count}"
  banners=['>Fake unit<'] if !j[13][0].nil? && banners.length<=0
  five_star=[3+star_buff*3.00/(8.00),3+star_buff*3.00/(6.00)]
  four_star=[(97.00-star_buff*0.5-five_star[0])*58.00/(94.00),(95.00-star_buff*0.5-five_star[0])*58.00/(92.00)]
  three_star=[100.00-2*five_star[0]-four_star[0],100.00-(8+star_buff*0.5)-four_star[1]]
  two_star=[0.0,0.0]
  one_star=[0.0,0.0]
  if star_buff>=24 && fail_mode==1
    five_star=[50.0,50.0]
    four_star=[0.0,0.0]
    three_star=[0.0,0.0]
    two_star=[0.0,0.0]
    one_star=[0.0,0.0]
  elsif star_buff>=24 && fail_mode==2
    five_star=[50.0,37.5]
    four_star=[0.0,0.0]
    three_star=[0.0,0.0]
    two_star=[0.0,0.0]
    one_star=[0.0,0.0]
  end
  non_focus=[[],[]]
  if j[9][0].include?('5p')
    k=untz.reject{|q| !q[9][0].include?('5p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
    non_focus[0].push("5<:Icon_Rarity_5:448266417553539104> Non-Focus - #{len % (five_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (five_star[0]/k.length)}% (Actual)") unless five_star[0]<=0
      non_focus[1].push("5<:Icon_Rarity_5:448266417553539104> Non-Focus (Hero Fest only) - #{len % (five_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (five_star[1]/k.length)}% (Actual)") unless five_star[1]<=0
    end
  if j[9][0].include?('4p')
    k=untz.reject{|q| !q[9][0].include?('4p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
    non_focus[0].push("4<:Icon_Rarity_4:448266418459377684> (standard banner) - #{len % (four_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (four_star[0]/k.length)}% (Actual)") unless four_star[0]<=0
    non_focus[0].push("4<:Icon_Rarity_4:448266418459377684> Non-Focus - #{len % ((four_star[0]/2)/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % ((four_star[0]/2)/k.length)}% (Actual)") unless four_star[0]<=0
    non_focus[1].push("4<:Icon_Rarity_4:448266418459377684> all the time - #{len % (four_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (four_star[1]/k.length)}% (Actual)") unless four_star[1]<=0
  end
  if j[9][0].include?('3p')
    k=untz.reject{|q| !q[9][0].include?('3p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
    non_focus[0].push("3<:Icon_Rarity_3:448266417934958592> all the time - #{len % (three_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (three_star[0]/k.length)}% (Actual)") unless three_star[0]<=0
    non_focus[1].push("3<:Icon_Rarity_3:448266417934958592> all the time - #{len % (three_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (three_star[1]/k.length)}% (Actual)") unless three_star[1]<=0
  end
  if j[9][0].include?('2p')
    k=untz.reject{|q| !q[9][0].include?('2p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
    non_focus[0].push("2<:Icon_Rarity_2:448266417872044032> all the time - #{len % (two_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (two_star[0]/k.length)}% (Actual)") unless two_star[0]<=0
    non_focus[1].push("2<:Icon_Rarity_2:448266417872044032> all the time - #{len % (two_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (two_star[1]/k.length)}% (Actual)") unless two_star[1]<=0
  end
  if j[9][0].include?('1p')
    k=untz.reject{|q| !q[9][0].include?('1p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
    non_focus[0].push("1<:Icon_Rarity_1:448266417481973781> all the time - #{len % (one_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (one_star[0]/k.length)}% (Actual)") unless one_star[0]<=0
    non_focus[1].push("1<:Icon_Rarity_1:448266417481973781> all the time - #{len % (one_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (one_star[1]/k.length)}% (Actual)") unless one_star[1]<=0
  end
  unless j[9][1].nil?
    rardata=j[9][0].downcase.gsub('0s','').split('p')[0]
    summon_type=[[],[],[],[],[],[],[]]
    for m in 1...@max_rarity_merge[0]+1
      summon_type[0].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}p") # Summon Pool
      summon_type[1].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}d") # Daily Rotation Heroes
      summon_type[2].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}g") # Grand Hero Battles
      summon_type[3].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}f") # free heroes
      summon_type[4].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}q") # quest rewards
      summon_type[5].push("#{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}t") # Tempest Trials rewards
      summon_type[6].push("Seasonal #{m}#{@rarity_stars[m-1]} summon") if rardata.include?("#{m}s")
      summon_type[6].push("Story unit starting at #{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}y")
      summon_type[6].push("Purchasable at #{m}#{@rarity_stars[m-1]}") if rardata.include?("#{m}b")
    end
    if summon_type[6].include?('Story unit starting at 2<:Icon_Rarity_2:448266417872044032>') && summon_type[6].include?('Story unit starting at 4<:Icon_Rarity_4:448266418459377684>')
      for i in 0...summon_type[6].length
        if summon_type[6][i]=='Story unit starting at 2<:Icon_Rarity_2:448266417872044032>'
          summon_type[6][i]='Story unit starting at 2<:Icon_Rarity_2:448266417872044032> (prior to version 2.5.0)'
        elsif summon_type[6][i]=='Story unit starting at 4<:Icon_Rarity_4:448266418459377684>'
          summon_type[6][i]='Story unit starting at 4<:Icon_Rarity_4:448266418459377684> (after version 2.5.0)'
        end
      end
    end
    for m in 0...5
      summon_type[m]=summon_type[m].sort{|a,b| a <=> b}
    end
    mz=['summon','daily rotation battles','Grand Hero Battle','free hero','quest reward','Tempest Trial reward']
    for m in 0...6
      if summon_type[m].length>0
        summon_type[m]="#{summon_type[m].join('/')} #{mz[m]}"
      else
        summon_type[m]=nil
      end
    end
    if summon_type[6].length>0
      summon_type[6]=summon_type[6].join(', ')
    else
      summon_type[6]=nil
    end
    summon_type.compact!
    summon_type=['Unobtainable'] if summon_type.nil? || summon_type.length.zero?
    summon_type=summon_type.join("\n")
    banners.unshift(summon_type)
  end
  if banners.length>0
    banners[0]="__**Debut:**__\n#{banners[0]}"
    banners[0]="#{banners[0]}\n\n\n__**Joined the summon pool during:**__\n#{j[9][1]}" unless j[9][1].nil?
    banners[1]="\n__**Other Banners:**__#{"\n" unless justnames}\n#{banners[1]}" if banners.length>1
    if justnames && !safe_to_spam?(event)
      banners.push("\n\n#{ftr}")
      ftr='You can see more details about these banners by using this command in PM or by including the word "specifics" in the command.'
    else
      banners.push("\n__**Starting Non-Focus Chances:**__#{"\n\n__*Standard 3% banners*__\n#{non_focus[0].join("\n")}" if non_focus[0].length>0}#{"\n\n__*Hero Fests and Legendary banners*__\n#{non_focus[1].join("\n")}" if non_focus[1].length>0}") if non_focus[0].length>0 || non_focus[1].length>0
    end
  else
    banners=[">No banners found<"]
    banners.push("\n__**Starting Non-Focus Chances:**__#{"\n\n__*Standard 3% banners*__\n#{non_focus[0].join("\n")}" if non_focus[0].length>0}#{"\n\n__*Hero Fests and Legendary banners*__\n#{non_focus[1].join("\n")}" if non_focus[1].length>0}") if (non_focus[0].length>0 || non_focus[1].length>0) && !justnames && safe_to_spam?(event)
  end
  hdr="__Banners **#{j[0].gsub('Lavatain','Laevatein')}** has been on__#{"\nBanners in **+#{star_buff}** form (after #{star_buff*5} to #{star_buff*5+4} failures to get a 5<:Icon_Rarity_5:448266417553539104>)" if star_buff>0}"
  hdr="__Banners **#{j[0].gsub('Lavatain','Laevatein')}** has been on__\nBanners in **Omega** form (after 120 failures to get a 5<:Icon_Rarity_5:448266417553539104>)" if star_buff>=24
  if banners.join("\n#{"\n" unless justnames}").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    msg=hdr.split(' ').join(' ')
    for i in 0...banners.length
      msg=extend_message(msg,banners[i],event,1,"\n#{"\n" unless justnames}")
    end
    event.respond msg
  else
    j=find_unit(j[0],event)
    create_embed(event,hdr,banners.join("\n#{"\n" unless justnames}"),unit_color(event,j),ftr,pick_thumbnail(event,j,bot),nil,4)
  end
  return nil
end

def games_list(event,name,bot,weapon=nil)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || @shardizard==4
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  name=game_adjust(name)
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      games_list(event,name[i],bot)
    end
    return nil
  end
  data_load()
  args=sever(event.message.text.downcase).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=find_name_in_string(event)
  name='grima' if name.nil? && event.message.text.downcase.gsub(' ','').include?('grima')
  name='tiki' if name.nil? && event.message.text.downcase.gsub(' ','').include?('tiki')
  j=find_unit(name,event)
  name='Robin(M)(Fallen)' if name.downcase.include?('grima') && j<0
  j=find_unit(name,event)
  if j<0
    event.respond 'No unit was included'
    return nil
  end
  untz=@units.map{|q| q}
  rg=untz[j][11].reject{|q| ['(a)','(m)','(t)','(t)'].include?(q[0,3]) || ['(at)','(st)'].include?(q[0,4])}
  ag=untz[j][11].reject{|q| q[0,3]!='(a)'}.map{|q| q[3,q.length-3]}
  mg=untz[j][11].reject{|q| q[0,3]!='(m)'}.map{|q| q[3,q.length-3]}
  sg=untz[j][11].reject{|q| q[0,3]!='(s)'}.map{|q| q[3,q.length-3]}
  tg=untz[j][11].reject{|q| q[0,3]!='(t)'}.map{|q| q[3,q.length-3]}
  atg=untz[j][11].reject{|q| q[0,4]!='(at)'}.map{|q| q[4,q.length-4]}
  stg=untz[j][11].reject{|q| q[0,4]!='(st)'}.map{|q| q[4,q.length-4]}
  g=get_games_list(rg)
  ga=get_games_list(ag,false)
  gm=get_games_list(mg,false)
  gs=get_games_list(sg,false)
  gt=get_games_list(tg,false)
  gat=get_games_list(atg,false)
  gst=get_games_list(stg,false)
  mu=(event.message.text.downcase.include?("mathoo's"))
  xcolor=unit_color(event,j,nil,0,mu)
  pic=pick_thumbnail(event,j,bot)
  g2="#{g[0]}"
  g.shift
  name="#{untz[j][0].gsub('Lavatain','Laevatein')}"
  if game_hybrid(untz[j][0],event,bot).length>0
    mmm=game_hybrid(untz[j][0],event,bot)
    pic=mmm[0]
    name=mmm[1]
    xcolor=mmm[2] if mmm.length>2
  elsif 'Tiki(Adult)'==untz[j][0] && !args.join('').downcase.gsub('games','gmes').include?('a')
    pic='https://orig00.deviantart.net/6c50/f/2018/051/9/e/tiki_by_rot8erconex-dc3tkzq.png'
    name='Tiki'
    m=untz[untz.find_index{|q| q[0]=='Tiki(Young)'}]
    rx=m[11].reject{|q| ['(a)','(m)','(t)','(t)'].include?(q[0,3]) || '(at)'==q[0,4]}
    ax=m[11].reject{|q| q[0,3]!='(a)'}.map{|q| q[3,q.length-3]}
    mx=m[11].reject{|q| q[0,3]!='(m)'}.map{|q| q[3,q.length-3]}
    sx=m[11].reject{|q| q[0,3]!='(s)'}.map{|q| q[3,q.length-3]}
    tx=m[11].reject{|q| q[0,3]!='(t)'}.map{|q| q[3,q.length-3]}
    atx=m[11].reject{|q| q[0,4]!='(at)'}.map{|q| q[3,q.length-3]}
    stx=m[11].reject{|q| q[0,4]!='(st)'}.map{|q| q[3,q.length-3]}
    x=get_games_list(rx)
    xa=get_games_list(ax,false)
    xm=get_games_list(mx,false)
    xs=get_games_list(sx,false)
    xt=get_games_list(tx,false)
    xat=get_games_list(atx,false)
    xst=get_games_list(stx,false)
    g2="#{x[0]}\n#{g2}"
    x.shift
    for i in 0...g.length
      x.push(g[i])
    end
    for i in 0...ga.length
      xa.push(ga[i])
    end
    for i in 0...gm.length
      xm.push(gm[i])
    end
    for i in 0...gs.length
      xs.push(gs[i])
    end
    for i in 0...gt.length
      xt.push(gt[i])
    end
    for i in 0...gat.length
      xat.push(gat[i])
    end
    for i in 0...gst.length
      xst.push(gst[i])
    end
    g=x.uniq
    ga=xa.uniq
    gm=xm.uniq
    gt=xt.uniq
    gat=xat.uniq
  end
  ga=ga.reject{|q| q.downcase=='no games'}
  gm=gm.reject{|q| q.downcase=='no games'}
  gs=gs.reject{|q| q.downcase=='no games'}
  gt=gt.reject{|q| q.downcase=='no games'}
  gat=gat.reject{|q| q.downcase=='no games'}
  gst=gst.reject{|q| q.downcase=='no games'}
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  create_embed(event,"__#{"Mathoo's " if mu}**#{name}**__","#{"**Credit in FEH**\n" unless g2=="No games"}#{g2}#{"\n\n**Other games**\n#{g.join("\n")}" unless g.length<1}#{"\n\n**Also appears via Amiibo functionality in**\n#{ga.join("\n")}" unless ga.length<1}#{"\n\n**Appears as an Assist Trophy in**\n#{gat.join("\n")}" unless gat.length<1}#{"\n\n**Appears as a Mii Costume in**\n#{gm.join("\n")}" unless gm.length<1}#{"\n\n**Appears as a Spirit in**\n#{gs.join("\n")}" unless gs.length<1}#{"\n\n**Appears as a standard Trophy in**\n#{gt.join("\n")}" unless gt.length<1}#{"\n\n**Appears as a Sticker in**\n#{gst.join("\n")}" unless gst.length<1}",xcolor,nil,pic)
end

bot.command([:structure,:struct]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_struct(bot,args.join(' '),event)
end

bot.command([:acc,:accessory,:accessorie]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_accessory(bot,args.join(' '),event)
end

bot.command([:item]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_itemu(bot,args.join(' '),event)
end

bot.command([:safe,:spam,:safetospam,:safe2spam,:long,:longreplies]) do |event, f|
  return nil if overlap_prevent(event)
  f='' if f.nil?
  if event.server.nil?
    event.respond 'It is safe for me to send long replies here because this is my PMs with you.'
  elsif [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579].include?(event.server.id)
    event.respond 'It is safe for me to send long replies here because this is one of my emoji servers.'
  elsif @shardizard==4
    event.respond 'It is safe for me to send long replies here because this is my debug mode.'
  elsif ['bots','bot'].include?(event.channel.name.downcase)
    event.respond "It is safe for me to send long replies here because the channel is named `#{event.channel.name.downcase}`."
  elsif event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('spam')
    event.respond 'It is safe for me to send long replies here because the channel name includes both the word "bot" and the word "spam".'
  elsif event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('command')
    event.respond 'It is safe for me to send long replies here because the channel name includes both the word "bot" and the word "command".'
  elsif event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('channel')
    event.respond 'It is safe for me to send long replies here because the channel name includes both the word "bot" and the word "channel".'
  elsif event.channel.name.downcase.include?('elisebot') || event.channel.name.downcase.include?('elise-bot') || event.channel.name.downcase.include?('elise_bot')
    event.respond 'It is safe for me to send long replies here because the channel name specifically calls attention to the fact that it is made for me.'
  elsif @spam_channels.include?(event.channel.id)
    if is_mod?(event.user,event.server,event.channel) && ['off','no','false'].include?(f.downcase)
      metadata_load()
      @spam_channels.delete(event.channel.id)
      metadata_save()
      event.respond 'This channel is no longer marked as safe for me to send long replies to.'
    else
      event << 'This channel has been specifically designated for me to be safe to send long replies to.'
      event << ''
      event << 'If you wish to change that, ask a server mod to type `FEH!spam off` in this channel.'
    end
  elsif is_mod?(event.user,event.server,event.channel,1) && ['on','yes','true'].include?(f.downcase)
    metadata_load()
    @spam_channels.push(event.channel.id)
    metadata_save()
    event.respond 'This channel is now marked as safe for me to send long replies to.'
  else
    event << 'It is not safe for me to send long replies here.'
    event << ''
    event << 'If you wish to change that, try one of the following:'
    event << '- Change the channel name to "bots".'
    event << '- Change the channel name to include the word "bot" and one of the following words: "spam", "command(s)", "channel".'
    event << '- Have a server mod type `FEH!spam on` in this channel.'
  end
end

bot.command([:channellist,:chanelist,:spamchannels,:spamlist]) do |event|
  if event.server.nil?
    event.respond "Yes, it is safe to spam here."
    return nil
  end
  sfe=[[],[]]
  for i in 0...event.server.channels.length
    chn=event.server.channels[i]
    if safe_to_spam?(event,chn)
      sfe[0].push(chn.mention)
    end
  end
  event << '__**All long replies are safe**__'
  event << sfe[0].join("\n")
  event << 'In PM with any user'
end

bot.command([:alts,:alt]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function_alts(:find_alts,event,args,bot)
  return nil
end

bot.command([:banners, :banner]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1 || ['next','schedule'].include?(args[0].downcase)
    t=Time.now
    if t-@last_multi_reload[1]>60*60 || @shardizard==4
      puts 'reloading EliseText'
      load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
      @last_multi_reload[1]=t
    end
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    msg="No unit was included.  Showing current and upcoming banners.\n\nDate assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
    t2=Time.new(2017,2,2)-60*60
    t2=t-t2
    date=(((t2.to_i/60)/60)/24)
    msg=extend_message(msg,"Days since game release: #{longFormattedNumber(date)}",event)
    if event.user.id==167657750971547648 && @shardizard==4
      msg=extend_message(msg,"Daycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12",event)
      msg=extend_message(msg,"Weekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%4+1}/4(Saturday) - #{week_from(date,0)%12+1}/12(Thursday)",event)
    end
    str2=disp_current_events(1)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_events(-1)
    msg=extend_message(msg,str2,event,2)
    event.respond msg
    return nil
  end
  parse_function(:banner_list,event,args,bot)
  return nil
end

bot.command([:allinheritance,:allinherit,:allinheritable,:skillinheritance,:skillinherit,:skillinheritable,:skilllearn,:skilllearnable,:skillsinheritance,:skillsinherit,:skillsinheritable,:skillslearn,:skillslearnable,:inheritanceskills,:inheritskill,:inheritableskill,:learnskill,:learnableskill,:inheritanceskills,:inheritskills,:inheritableskills,:learnskills,:learnableskills,:all_inheritance,:all_inherit,:all_inheritable,:skill_inheritance,:skill_inherit,:skill_inheritable,:skill_learn,:skill_learnable,:skills_inheritance,:skills_inherit,:skills_inheritable,:skills_learn,:skills_learnable,:inheritance_skills,:inherit_skill,:inheritable_skill,:learn_skill,:learnable_skill,:inheritance_skills,:inherit_skills,:inheritable_skills,:learn_skills,:learnable_skills,:inherit,:learn,:inheritance,:learnable,:inheritable,:skillearn,:skillearnable]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:learnable_skills,event,args,bot)
  return nil
end

bot.command([:summonpool,:summon_pool,:pool]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_summon_pool(event,args)
  return nil
end

bot.command([:art,:artist]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:disp_art,event,args,bot)
  return nil
end

bot.command([:mythic,:mythical,:mythics,:mythicals]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_legendary_mythical(event,bot,args,'Mythic')
  return nil
end

bot.command([:legendary,:legendaries,:legendarys,:legend,:legends]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_legendary_mythical(event,bot,args,'Legendary')
  return nil
end

bot.command([:refinery,:refine,:effect]) do |event|
  return nil if overlap_prevent(event)
  if !safe_to_spam?(event)
    event.respond "There is a lot of data being displayed.  Please use this command in PM."
    return nil
  end
  event.channel.send_temporary_message('Calculating data, please wait...',1)
  srv=0
  srv=event.server.id unless event.server.nil?
  data_load()
  stones=[]
  dew=[]
  g=get_markers(event)
  skkz=@skills.map{|q| q}.reject{|q| ['Falchion','Missiletainn','Breidablik','Adult (All)'].include?(q[0]) || q[4]!='Weapon' || !has_any?(g, q[13])}
  if event.message.text.downcase.include?('effect')
    for i in 0...skkz.length
      eff=false
      unless skkz[i][15].nil? || skkz[i][15].length.zero?
        str=skkz[i][15].split(' ').join(' ')
        for i2 in 0...6
          if str[0,1]=='-' && str[1,1].to_i.to_s==str[1,1]
            str=str[2,str.length-2]
          elsif str[0,1].to_i.to_s==str[0,1]
            str=str[1,str.length-1]
          end
        end
        eff=true if str[0,1]!='*' && str != 'y'
      end
      if eff
        if skkz[i][6]=='-'
          stones.push("#{'~~' unless skkz[i][13].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} (->) #{find_effect_name(skkz[i],event,1)}#{'~~' unless skkz[i][13].nil?}")
        else
          dew.push("#{'~~' unless skkz[i][13].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} (->) #{find_effect_name(skkz[i],event,1)}#{'~~' unless skkz[i][13].nil?}")
        end
      end
    end
    stones.uniq!
    dew.uniq!
    if stones.join("\n").length+dew.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      if dew.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg='__**Weapon Refines with Effect Modes: Divine Dew <:Divine_Dew:453618312434417691>**__'
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...dew.length
          k2="#{skkz[skkz.find_index{|q| q[0]==stat_buffs(dew[i].gsub('~~','').split(' (->) ')[0])}][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
          for j in 0...k.length
            k[j][1].push(dew[i]) if k2==k[j][0].split('> ')[1]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        create_embed(event,'__**Weapon Refines with Effect Modes: Divine Dew <:Divine_Dew:453618312434417691>**__','',0x9BFFFF,nil,nil,triple_finish(dew,true),3)
      end
      if stones.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg='__**Weapon Refines with Effect Modes: Refining Stones <:Refining_Stone:453618312165720086>**__'
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...stones.length
          k2="#{skkz[skkz.find_index{|q| q[0]==stat_buffs(stones[i].gsub('~~','').split(' (->) ')[0])}][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
          for j in 0...k.length
            k[j][1].push(stones[i]) if k2==k[j][0].split('> ')[1]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        create_embed(event,'__**Weapon Refines with Effect Modes: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x688C68,nil,nil,triple_finish(stones,true),3)
      end
    else
      dew2=dew[dew.length/2+dew.length%2,dew.length/2].join("\n")
      dew=dew[0,dew.length/2+3*dew.length%2].join("\n")
      create_embed(event,'__**Weapon Refines with Effect Modes**__','',0x688C68,nil,nil,[['<:Divine_Dew:453618312434417691> Divine Dew',dew],['<:Divine_Dew:453618312434417691> Divine Dew',dew2],['<:Refining_Stone:453618312165720086> Refining Stones',stones.join("\n"),1]],3)
    end
    return nil
  end
  for i in 0...skkz.length
    if !skkz[i][15].nil?
      if skkz[i][6]=='-'
        stones.push("#{'~~' unless skkz[i][13].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')}#{'~~' unless skkz[i][13].nil?}")
      else
        dew.push("#{'~~' unless skkz[i][13].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')}#{'~~' unless skkz[i][13].nil?}")
      end
    end
  end
  dew2=[]
  stones2=[]
  for i in 0...skkz.length
    unless skkz[i].nil?
      if !skkz[i][14].nil?
        s=skkz[i][14].split(', ')
        for j in 0...s.length
          if s[j].include?('!')
            s[j]=s[j].split('!')
            s2=skkz[skkz.find_index{|q| q[0]==s[j][1]}]
            if s2[6]=='-'
              stones2.push("#{'~~' unless skkz[i][13].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} -> #{s[j][1].gsub('Bladeblade','Laevatein')} (#{s[j][0].gsub('Lavatain','Laevatein')})#{'~~' unless skkz[i][13].nil?}")
            else
              dew2.push("#{'~~' unless skkz[i][13].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} -> #{s[j][1].gsub('Bladeblade','Laevatein')} (#{s[j][0].gsub('Lavatain','Laevatein')})#{'~~' unless skkz[i][13].nil?}")
            end
          else
            s2=skkz[skkz.find_index{|q| q[0]==s[j]}]
            if s2[6]=='-'
              stones2.push("#{'~~' unless skkz[i][13].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} -> #{s[j].gsub('Bladeblade','Laevatein')}#{'~~' unless skkz[i][13].nil?}")
            else
              dew2.push("#{'~~' unless skkz[i][13].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} -> #{s[j].gsub('Bladeblade','Laevatein')}#{'~~' unless skkz[i][13].nil?}")
            end
          end
        end
      end
    end
  end
  stones.uniq!
  dew.uniq!
  stones2.uniq!
  dew2.uniq!
  if stones.join("\n").length+dew.join("\n").length+stones2.join("\n").length+dew2.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    if dew2.join("\n").length+stones2.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      if dew2.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg='__**Weapon Evolution: Divine Dew <:Divine_Dew:453618312434417691>**__'
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...dew2.length
          k2="#{skkz[skkz.find_index{|q| q[0]==stat_buffs(dew2[i].gsub('~~',''))}][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
          for j in 0...k.length
            k[j][1].push(dew2[i]) if k2==k[j][0].split('> ')[1]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        create_embed(event,'__**Weapon Evolution: Divine Dew <:Divine_Dew:453618312434417691>**__','',0x9BFFFF,nil,nil,triple_finish(dew2),3)
      end
      if stones2.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg='__**Weapon Evolution: Refining Stones <:Refining_Stone:453618312165720086>**__'
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...stones2.length
          k2="#{skkz[skkz.find_index{|q| q[0]==stat_buffs(stones2[i].gsub('~~',''))}][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
          for j in 0...k.length
            k[j][1].push(stones2[i]) if k2==k[j][0].split('> ')[1]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        create_embed(event,'__**Weapon Evolution: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x9BFFFF,nil,nil,triple_finish(stones2),3)
      end
    else
      create_embed(event,'__**Weapon Evolution**__','',0x9BFFFF,nil,nil,[['**Divine Dew** <:Divine_Dew:453618312434417691>',dew2.join("\n")],['**Refining Stones** <:Refining_Stone:453618312165720086>',stones2.join("\n")]],3)
    end
    if stones.join("\n").length+dew.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      if dew.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg='__**Weapon Refines: Divine Dew <:Divine_Dew:453618312434417691>**__'
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...dew.length
          k2="#{skkz[skkz.find_index{|q| q[0]==stat_buffs(dew[i].gsub('~~',''))}][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
          for j in 0...k.length
            k[j][1].push(dew[i]) if k2==k[j][0].split('> ')[1]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        create_embed(event,'__**Weapon Refines: Divine Dew <:Divine_Dew:453618312434417691>**__','',0x688C68,nil,nil,triple_finish(dew),3)
      end
      if stones.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg='__**Weapon Refines: Refining Stones <:Refining_Stone:453618312165720086>**__'
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...stones.length
          k2="#{skkz[skkz.find_index{|q| q[0]==stat_buffs(stones[i].gsub('~~',''))}][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
          for j in 0...k.length
            k[j][1].push(stones[i]) if k2==k[j][0].split('> ')[1]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        create_embed(event,'__**Weapon Refines: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x688C68,nil,nil,triple_finish(stones),3)
      end
    else
      stones2=stones[stones.length/2+stones.length%2,stones.length/2]
      stones=stones[0,stones.length/2+3*stones.length%2]
      create_embed(event,'__**Weapon Refines**__','',0x688C68,nil,nil,[['**Divine Dew** <:Divine_Dew:453618312434417691>',dew.join("\n")],['**Refining Stones** <:Refining_Stone:453618312165720086>',stones.join("\n")],['**Refining Stones** <:Refining_Stone:453618312165720086>',stones2.join("\n")]],3)
    end
    return nil
  else
    dew3=['__**Refinement**__']
    stones3=['__**Refinement**__']
    for i in 0...dew.length
      dew3.push(dew[i])
    end
    for i in 0...stones.length
      stones3.push(stones[i])
    end
    stones=stones3.map{|q| q}
    dew=dew3.map{|q| q}
    dew.push('- - -')
    dew.push('__**Evolution**__')
    stones.push('- - -')
    stones.push('__**Evolution**__')
    for i in 0...dew2.length
      dew.push(dew2[i])
    end
    for i in 0...stones2.length
      stones.push(stones2[i])
    end
    stones2=stones[stones.length/2+stones.length%2,stones.length/2]
    stones=stones[0,stones.length/2+3*stones.length%2]
    create_embed(event,'Weapon Refinery','',0x688C68,nil,nil,[['**Divine Dew** <:Divine_Dew:453618312434417691>',dew.join("\n")],['**Refining Stones** <:Refining_Stone:453618312165720086>',stones.join("\n")],['**Refining Stones** <:Refining_Stone:453618312165720086>',stones2.join("\n")]],3)
  end
end

bot.command([:attackicon, :attackcolor, :attackcolors, :attackcolour, :attackcolours, :atkicon, :atkcolor, :atkcolors, :atkcolour, :atkcolours, :atticon, :attcolor, :attcolors, :attcolour, :attcolours, :staticon, :statcolor, :statcolors, :statcolour, :statcolours, :iconcolor, :iconcolors, :iconcolour, :iconcolours]) do |event|
  return nil if overlap_prevent(event)
  attack_icon(event)
  return nil
end

bot.command([:random,:rand]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length.zero?
  elsif ['unit','real'].include?(args[0].downcase)
    pick_random_unit(event,args,bot)
    return nil
  end
  generate_random_unit(event,args,bot)
  return nil
end

bot.command([:randomunit,:randunit,:unitrandom,:unitrand,:randomstats,:statsrand,:statsrandom,:randstats]) do |event, *args|
  return nil if overlap_prevent(event)
  pick_random_unit(event,args,bot)
  return nil
end

bot.command(:whyelise) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  why_elise(event,bot)
  return nil
end

bot.command([:skillrarity,:onestar,:twostar,:threestar,:fourstar,:fivestar,:skill_rarity,:one_star,:two_star,:three_star,:four_star,:five_star]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  skill_rarity(event)
  return nil
end

bot.command(:summon) do |event, *colors|
  return nil if overlap_prevent(event)
  if colors.nil? || colors.length<=0
  elsif colors[0].downcase=='pool'
    args=colors.map{|q| q}
    args.shift
    disp_summon_pool(event,args)
    return nil
  end
  if event.server.nil?
    event.respond 'This command in unavailable in PM.'
  elsif event.server.id==238770788272963585
    event.respond 'This command is unavailable in this server.  If you wish to fix that, take it up with the mod team.'
  elsif !@summon_servers.include?(event.server.id)
    event.respond 'This command is unavailable in this server.'
  elsif event.server.id==238770788272963585 && event.channel.id != 377526015939051520
    event.respond 'This command is unavailable in this channel.  Please go to <#377526015939051520>.'
  elsif event.server.id==330850148261298176 && event.channel.id != 330851389104455680
    event.respond 'This command is unavailable in this channel.  Please go to <#330851389104455680>.'
  elsif event.server.id==328109510449430529 && event.channel.id != 328136987804565504
    event.respond 'This command is unavailable in this channel.  Please go to <#328136987804565504>.'
  elsif event.server.id==305889949574496257 && event.channel.id != 460903186773835806
    event.respond 'This command is unavailable in this channel.  Please go to <#460903186773835806>.'
  elsif event.server.id==271642342153388034 && event.channel.id != 312736133203361792
    event.respond 'This command is unavailable in this channel.  Please go to <#312736133203361792>.'
  else
    if !@banner[0].nil?
      post=Time.now
      if (post - @banner[0][1]).to_f < 300
        if event.server.id==@banner[0][2]
          event.respond "<@#{@banner[0][0]}>, please choose your summons as others would like to use this command"
        else
          event.respond 'Please wait, as another server is using this command.'
        end
        return nil
      else
        @banner=[]
      end
    end
    metadata_load()
    bnr=make_banner(event)
    n=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res','+Def -HP',
       '+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral']
    n=['Neutral'] if bnr[0][0]=='TT Units' || bnr[0][0]=='GHB Units'
    str="**Summoner:** #{event.user.distinct}"
    str="#{str}\n"
    str="#{str}\n**Banner:** #{bnr[0][0]}"
    unless bnr[0][1].nil? || bnr[0][1].length.zero?
      b=bnr[0][1].split(', ').map{|q| q.split('/')}
      m=['','January','February','March','April','May','June','July','August','September','October','November','December']
      str="#{str}\n*Real world run:* #{b[0][0]} #{m[b[0][1].to_i]} #{b[0][2]} - #{b[1][0]} #{m[b[1][1].to_i]} #{b[1][2]}"
    end
    str="#{str}\n"
    k=[[],[],[],[],[]]
    untz=@units.map{|q| q}
    for i in 0...bnr[2].length
      k2=untz[untz.find_index{|q| q[0]==bnr[2][i]}][1][0]
      k[0].push(bnr[2][i].gsub('Lavatain','Laevatein')) if k2=='Red'
      k[1].push(bnr[2][i].gsub('Lavatain','Laevatein')) if k2=='Blue'
      k[2].push(bnr[2][i].gsub('Lavatain','Laevatein')) if k2=='Green'
      k[3].push(bnr[2][i].gsub('Lavatain','Laevatein')) if k2=='Colorless'
      k[4].push(bnr[2][i].gsub('Lavatain','Laevatein')) unless ['Red','Blue','Green','Colorless'].include?(k2)
    end
    str="#{str}\n**Focus Heroes:**"
    str="#{str}\n<:Orb_Red:455053002256941056> *Red*:  #{k[0].join(', ')}" if k[0].length>0
    str="#{str}\n<:Orb_Blue:455053001971859477> *Blue*:  #{k[1].join(', ')}" if k[1].length>0
    str="#{str}\n<:Orb_Green:455053002311467048> *Green*:  #{k[2].join(', ')}" if k[2].length>0
    str="#{str}\n<:Orb_Colorless:455053002152083457> *Colorless*:  #{k[3].join(', ')}" if k[3].length>0
    str="#{str}\n<:Orb_Gold:455053002911514634> *Gold*:  #{k[4].join(', ')}" if k[4].length>0
    str="#{str}\n"
    str="#{str}\n**Summon rates:**"
    @banner=[[event.user.id,Time.now,event.server.id]]
    if bnr[1]<0 # negative "starting focus" numbers indicate there is no non-focus rate
      sr=(@summon_rate[0]/5)*0.5
      sr=100.00 + bnr[1] if @summon_rate[0]>=120 && @summon_rate[2]%3==2
      b= 0 - bnr[1]
      focus = b + sr
      five_star = 0.00
      if @summon_rate[0]>=120 && @summon_rate[2]%3==1
        focus = 50.00
        five_star = 50.00
      end
      four_star = (100.00 - focus - five_star) * 58.00 / (100.00 - b)
      three_star = 100.00 - focus - five_star - four_star
      two_star = 0
      one_star = 0
    else
      sr=(@summon_rate[0]/5)*0.5
      sr=97.00 - bnr[1] if @summon_rate[0]>=120 && @summon_rate[2]%3==2
      focus = bnr[1] + sr * bnr[1] / (bnr[1] + 3.00)
      five_star = 3.00 + sr * 3.00 / (bnr[1] + 3.00)
      if @summon_rate[0]>=120 && @summon_rate[2]%3==1
        focus = 50.00
        five_star = 50.00
      end
      four_star = (100.00 - focus - five_star) * 58.00 / (100.00 - bnr[1] - 3)
      three_star = 100.00 - focus - five_star - four_star
      two_star = 0
      one_star = 0
    end
    fakes=false
    fakes=true if @summon_rate[0]>=120 && @summon_rate[2]%3==0
    str="#{str}\n5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % focus}%"
    str="#{str}\nOther 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % five_star}%" unless five_star.zero?
    if fakes
      if bnr[8].nil?
        str="#{str}\n~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % four_star}%" unless four_star.zero?
      elsif four_star>0
        str="#{str}\n~~4\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (four_star/2)}%"
        str="#{str}\nOther ~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (four_star/2)}%"
      end
      if bnr[9].nil?
        str="#{str}\n~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % three_star}%" unless three_star.zero?
      elsif three_star>0
        str="#{str}\n~~3\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (three_star/2)}%"
        str="#{str}\nOther ~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (three_star/2)}%"
      end
      if bnr[10].nil?
        str="#{str}\n~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % two_star}%" unless two_star.zero?
      elsif two_star>0
        str="#{str}\n~~2\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (two_star/2)}%"
        str="#{str}\nOther ~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (two_star/2)}%"
      end
      if bnr[11].nil?
        str="#{str}\n~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % one_star}%" unless one_star.zero?
      elsif two_star>0
        str="#{str}\n~~1\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (one_star/2)}%"
        str="#{str}\nOther ~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (one_star/2)}%"
      end
    else
      if bnr[8].nil?
        str="#{str}\n4<:Icon_Rarity_4:448266418459377684> Unit:  #{'%.2f' % four_star}%" unless four_star.zero?
      elsif four_star>0
        str="#{str}\n4<:Icon_Rarity_4p10:448272714210476033> Focus:  #{'%.2f' % (four_star/2)}%"
        str="#{str}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % (four_star/2)}%"
      end
      if bnr[9].nil?
        str="#{str}\n3<:Icon_Rarity_3:448266417934958592> Unit:  #{'%.2f' % three_star}%" unless three_star.zero?
      elsif three_star>0
        str="#{str}\n3<:Icon_Rarity_3p10:448294378293952513> Focus:  #{'%.2f' % (three_star/2)}%"
        str="#{str}\nOther 3<:Icon_Rarity_3:448266417934958592>:  #{'%.2f' % (three_star/2)}%"
      end
      if bnr[10].nil?
        str="#{str}\n2<:Icon_Rarity_2:448266417872044032> Unit:  #{'%.2f' % two_star}%" unless two_star.zero?
      elsif two_star>0
        str="#{str}\n2<:Icon_Rarity_2p10:448294378205872130> Focus:  #{'%.2f' % (two_star/2)}%"
        str="#{str}\nOther 2<:Icon_Rarity_2:448266417872044032>:  #{'%.2f' % (two_star/2)}%"
      end
      if bnr[11].nil?
        str="#{str}\n1<:Icon_Rarity_1:448266417481973781> Unit:  #{'%.2f' % one_star}%" unless one_star.zero?
      elsif two_star>0
        str="#{str}\n1<:Icon_Rarity_1p10:448294377878716417> Focus:  #{'%.2f' % (one_star/2)}%"
        str="#{str}\nOther 1<:Icon_Rarity_1:448266417481973781>:  #{'%.2f' % (one_star/2)}%"
      end
    end
    str="#{str}\n"
    for i in 1...6
      k=rand(10000)
      if k<focus*100
        hx=bnr[2].sample
        rx='5<:Icon_Rarity_5p10:448272715099406336>'
        nr=n.sample
      elsif k<focus*100+five_star*100
        hx=bnr[3].sample
        rx='5<:Icon_Rarity_5:448266417553539104>'
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      elsif !bnr[8].nil? && k<focus*100+five_star*100+four_star*50
        hx=bnr[8].sample
        rx='4<:Icon_Rarity_4p10:448272714210476033>'
        rx='~~4\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100
        hx=bnr[4].sample
        rx='4<:Icon_Rarity_4:448266418459377684>'
        rx='~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      elsif !bnr[9].nil? && k<focus*100+five_star*100+four_star*100+three_star*50
        hx=bnr[9].sample
        rx='3<:Icon_Rarity_3p10:448294378293952513>'
        rx='~~3\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100+three_star*100
        hx=bnr[5].sample
        rx='3<:Icon_Rarity_3:448266417934958592>'
        rx='~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      elsif !bnr[10].nil? && k<focus*100+five_star*100+four_star*100+three_star*100+two_star*50
        hx=bnr[10].sample
        rx='2<:Icon_Rarity_2p10:448294378205872130>'
        rx='~~2\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100+three_star*100+two_star*100
        hx=bnr[6].sample
        rx='2<:Icon_Rarity_2:448266417872044032>'
        rx='~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      elsif !bnr[11].nil? && k<focus*100+five_star*100+four_star*100+three_star*100+two_star*100+one_star*50
        hx=bnr[11].sample
        rx='1<:Icon_Rarity_1p10:448294377878716417>'
        rx='~~1\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=n.sample
      else
        hx=bnr[7].sample
        rx='1<:Icon_Rarity_1:448266417481973781>'
        rx='~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      end
      @banner.push([rx,hx,nr])
    end
    cracked_orbs=[]
    if colors.nil? || colors.length.zero?
      str="#{str}\n**Orb options:**"
    else
      trucolors=[]
      for i in 0...colors.length
        trucolors.push('Red') if ['red','reds','all'].include?(colors[i].downcase)
        trucolors.push('Blue') if ['blue','blues','all'].include?(colors[i].downcase)
        trucolors.push('Green') if ['green','greens','all'].include?(colors[i].downcase)
        trucolors.push('Colorless') if ['colorless','colourless','clear','clears','all'].include?(colors[i].downcase)
      end
      if trucolors.length>0
        for i in 1...@banner.length
          cracked_orbs.push([@banner[i],i]) if trucolors.include?(@units[find_unit(@banner[i][1],event)][1][0])
        end
        str="#{str}\nNone of the colors you requested appeared.  Here are your **Orb options:**" if cracked_orbs.length.zero?
      else
        str="#{str}\n**Orb options:**"
      end
    end
    if cracked_orbs.length>0
      summons=0
      five_star=false
      str="#{str}\n**Summoning Results:**"
      for i in 0...cracked_orbs.length
        str="#{str}\nOrb ##{cracked_orbs[i][1]} contained a #{cracked_orbs[i][0][0]} **#{cracked_orbs[i][0][1].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,-1,cracked_orbs[i][0][1],false,4)} (*#{cracked_orbs[i][0][2]}*)"
        summons+=1
        five_star=true if cracked_orbs[i][0][0].include?('5<:Icon_Rarity_5:448266417553539104>')
        five_star=true if cracked_orbs[i][0][0].include?('5<:Icon_Rarity_5p10:448272715099406336>')
      end
      str="#{str}\n"
      str="#{str}\nIn this current summoning session, you fired Breidablik #{summons} time#{'s' unless summons==1}, expending #{[0,5,9,13,17,20][summons]} orbs."
      metadata_load()
      @summon_rate[0]+=summons
      @summon_rate[1]+=[0,5,9,13,17,20][summons]
      str="#{str}\nSince the last 5\* summons, Breidablik has been fired #{@summon_rate[0]} time#{"s" unless @summon_rate[0]==1} and #{@summon_rate[1]} orbs have been expended."
      event.respond str
      if @summon_rate[2]>2
        @summon_rate=[0,0,(@summon_rate[2]+1)%3+3] if five_star
      else
        @summon_rate=[0,0,@summon_rate[2]] if five_star
      end
      metadata_save()
      @banner=[]
    else
      for i in 1...@banner.length
        k=untz[untz.find_index{|q| q[0]==@banner[i][1]}][1][0]
        str="#{str}\n#{i}.) <:Orb_Red:455053002256941056> *Red*" if k=='Red'
        str="#{str}\n#{i}.) <:Orb_Blue:455053001971859477> *Blue*" if k=='Blue'
        str="#{str}\n#{i}.) <:Orb_Green:455053002311467048> *Green*" if k=='Green'
        str="#{str}\n#{i}.) <:Orb_Colorless:455053002152083457> *Colorless*" if k=='Colorless'
        str="#{str}\n#{i}.) <:Orb_Gold:455053002911514634> *Gold*" unless ['Red','Blue','Green','Colorless'].include?(k)
      end
      str="#{str}\n"
      str="#{str}\nTo open orbs, please respond - in a single message - with the number of each orb you want to crack."
      str="#{str}\nYou can also just say \"Summon all\" to open all orbs."
      event.respond str
      event.channel.await(:bob, from: event.user.id) do |e|
        if @banner[0].nil?
        elsif e.user.id == @banner[0][0] && e.message.text.downcase.include?('summon all')
          crack_orbs(bot,event,e,e.user.id,[1,2,3,4,5])
        elsif e.user.id == @banner[0][0] && e.message.text =~ /1|2|3|4|5/
          l=[]
          for i in 1...6
            l.push(i) if e.message.text.include?(i.to_s)
          end
          crack_orbs(bot,event,e,e.user.id,l)
        else
          return false
        end
      end
    end
  end
  return nil
end

bot.command([:effhp,:effHP,:eff_hp,:eff_HP,:bulk]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:calculate_effective_HP,event,args,bot)
  return nil
end

bot.command([:heal_study,:healstudy,:studyheal,:study_heal]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:heal_study,event,args,bot,true)
  return nil
end

bot.command([:proc_study,:procstudy,:studyproc,:study_proc]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:proc_study,event,args,bot,false)
  return nil
end

bot.command([:phase_study,:phasestudy,:studyphase,:study_phase]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:phase_study,event,args,bot)
  return nil
end

bot.command([:study,:statstudy,:studystats]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  if ['effhp','eff_hp','bulk'].include?(args[0].downcase)
    args.shift
    k=parse_function(:calculate_effective_HP,event,args,bot)
    return nil unless k<0
  elsif ['heal'].include?(args[0].downcase)
    args.shift
    k=parse_function(:heal_study,event,args,bot,true)
    return nil unless k<0
  elsif ['proc'].include?(args[0].downcase)
    args.shift
    k=parse_function(:proc_study,event,args,bot,false)
    return nil unless k<0
  elsif ['phase'].include?(args[0].downcase)
    args.shift
    k=parse_function(:phase_study,event,args,bot)
    return nil unless k<0
  end
  parse_function(:unit_study,event,args,bot)
  return nil
end

bot.command(:games) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:games_list,event,args,bot)
  return nil
end

bot.command([:bst, :BST]) do |event, *args|
  return nil if overlap_prevent(event)
  event.channel.send_temporary_message('Parsing message, please wait...',8)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  s1=args.join(' ').gsub(',','').gsub('/','').downcase.gsub('laevatein','lavatain')
  s2=args.join(' ').gsub(',','').gsub('/','').downcase.gsub('laevatein','lavatain')
  if s1.include?('|')
    k=[]
    f=s1.gsub(' |','|').gsub('| ','|').split('|')
    for i in 0...f.length
      x=detect_multi_unit_alias(event,f[i],f[i],1)
      if !x.nil? && x[1].length>1
        r=find_stats_in_string(event,f[i])
        k.push("#{r[0]}*#{x[0]}+#{r[1]}#{"+#{r[2]}" if r[2].length>0}#{"-#{r[3]}" if r[3].length>0}")
      elsif find_name_in_string(event,f[i])!=nil
        name=find_name_in_string(event,f[i])
        r=find_stats_in_string(event,f[i])
        u=@units[find_unit(find_name_in_string(event,f[i]),event)]
        m=false
        if f[i].downcase.split(' ').include?("mathoo's") && find_in_dev_units(name)>=0
          m=true
          dv=@dev_units[find_in_dev_units(name)]
          r[0]=dv[1]
          r[1]=dv[2]
          r[2]=dv[3].gsub(' ','')
          r[3]=dv[4].gsub(' ','')
          r[2]='' if r[2].nil?
          r[3]='' if r[3].nil?
        elsif donate_trigger_word(event,f[i])>0
          uid=donate_trigger_word(event,f[i])
          x=donor_unit_list(uid)
          x2=x.find_index{|q| q[0]==name}
          unless x2.nil?
            r[0]=x[x2][1]
            r[1]=x[x2][2]
            r[2]=x[x2][3].gsub(' ','')
            r[3]=x[x2][4].gsub(' ','')
            r[2]='' if r[2].nil?
            r[3]='' if r[3].nil?
          end
        end
        k.push("#{r[0]}*#{u[0]}+#{r[1]}#{"+#{r[2]}" if r[2].length>0}#{"-#{r[3]}" if r[3].length>0}")
      end
    end
  else
    for i in 0...args.length
      unless s1.split(' ').nil? || s1.gsub(' ','').length<=0
        k=find_name_in_string(event,s1,1)
        unless k.nil?
          s1=first_sub(s1,k[1],'')
          s2=first_sub(s2,k[1],k[0])
        end
      end
    end
    k=splice(s2)
  end
  u=0
  n=0
  au=0
  b=[]
  scr=[]
  counters=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHEmblemTeams.txt')
    counters=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHEmblemTeams.txt').each_line do |line|
      counters.push(eval line)
    end
  end
  if counters.length<=0
    counters=[['Infantry',0,0],['Horse',0,0],['Armor',0,0],['Flier',0,0],
              ['Magic',0,0],['Dragon',0,0],['Melee',0,0],['Healer',0,0],['Dagger',0,0],['Archer',0,0],
              ['Red',0,0],['Blue',0,0],['Green',0,0],['Colorless',0,0],
              [['','F2P','F2P'],0,0],
              ['Story',0,0],['GHB',0,0],['Tempest',0,0]]
  end
  colors=[[],[0,0,0,0,0],[0,0,0,0,0]]
  braves=[[],[0,0],[0,0]]
  m=false
  did=-1
  msg=""
  event.channel.send_temporary_message("Message parsed, calculating units...",2)
  for i in 0...k.length
    x=detect_multi_unit_alias(event,k[i],k[i],1)
    name=nil
    if k[i].downcase=="mathoo's"
      m=true
    elsif donate_trigger_word(event,k[i])>0
      did=donate_trigger_word(event,k[i])
    elsif !x.nil? && x[1].is_a?(Array) && x[1].length>1
      if (i>0 && !detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]}",1).nil?) || (i<k.length-1 && !detect_multi_unit_alias(event,k[i],"#{k[i]} #{k[i+1]}",1).nil?) || (i>0 && i<k.length-1 && !detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}",1).nil?) || !detect_multi_unit_alias(event,k[i],"#{k[i]}",1).nil?
        if i>0 && i<k.length-1 && !detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}",1).nil?
          x=detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}",1)
        elsif i>0 && !detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]}",1).nil?
          x=detect_multi_unit_alias(event,k[i],"#{k[i-1]} #{k[i]}",1)
        elsif i<k.length-1 && !detect_multi_unit_alias(event,k[i],"#{k[i]} #{k[i+1]}",1).nil?
          x=detect_multi_unit_alias(event,k[i],"#{k[i]} #{k[i+1]}",1)
        elsif !detect_multi_unit_alias(event,k[i],"#{k[i]}",1).nil?
          x=detect_multi_unit_alias(event,k[i],"#{k[i]}",1)
        end
        if x[1].is_a?(Array) && x[1].length>1
          au+=1
          msg=extend_message(msg,"Ambiguous Unit #{au}: #{x[0]} - #{list_lift(x[1].map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"},'or')}",event)
        else
          name=@units[find_unit(find_name_in_string(event,x[1][0]),event)][0]
          summon_type=@units[find_unit(find_name_in_string(event,x[1][0]),event)][9][0].downcase
        end
      else
        au+=1
        msg=extend_message(msg,"Ambiguous Unit #{au}: #{x[0]} - #{list_lift(x[1].map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"},'or')}",event)
      end
    elsif find_name_in_string(event,sever(k[i]))!=nil
      name=@units[find_unit(find_name_in_string(event,sever(k[i])),event)][0]
      summon_type=@units[find_unit(find_name_in_string(event,sever(k[i])),event)][9][0].downcase
    elsif !x.nil? && !x[1].is_a?(Array)
      name=@units[find_unit(find_name_in_string(event,x[1]),event)][0]
      summon_type=@units[find_unit(find_name_in_string(event,x[1]),event)][9][0].downcase
    elsif x.nil?
      if i>1 && !detect_multi_unit_alias(event,k[i-2],"#{k[i-2]} #{k[i-1]} #{k[i]}",1).nil?
      elsif i>0 && !detect_multi_unit_alias(event,k[i-1],"#{k[i-1]} #{k[i]}",1).nil?
      elsif i<k.length-2 && !detect_multi_unit_alias(event,k[i+2],"#{k[i]} #{k[i+1]} #{k[i+2]}",1).nil?
      elsif i<k.length-1 && !detect_multi_unit_alias(event,k[i+1],"#{k[i]} #{k[i+1]}",1).nil?
      else
        n+=1
        msg=extend_message(msg,"Nonsense term #{n}: #{k[i]}",event)
      end
    end
    if !name.nil?
      u+=1
      r=find_stats_in_string(event,sever(k[i]))
      j=@units[find_unit(name,event)]
      for i2 in 1...3
        if i<4*i2
          counters[0][i2]+=1 if j[3]=='Infantry'
          counters[1][i2]+=1 if j[3]=='Cavalry'
          counters[2][i2]+=1 if j[3]=='Armor'
          counters[3][i2]+=1 if j[3]=='Flier'
          counters[4][i2]+=1 if j[1][1]=='Tome'
          counters[5][i2]+=1 if j[1][1]=='Dragon'
          counters[6][i2]+=1 if j[1][1]=='Blade'
          counters[7][i2]+=1 if j[1][1]=='Healer'
          counters[8][i2]+=1 if j[1][1]=='Dagger'
          counters[9][i2]+=1 if j[1][1]=='Bow'
          counters[10][i2]+=1 if j[1][0]=='Red'
          counters[11][i2]+=1 if j[1][0]=='Blue'
          counters[12][i2]+=1 if j[1][0]=='Green'
          counters[13][i2]+=1 if j[1][0]=='Colorless'
          if ['',' '].include?(r[2]) && ['',' '].include?(r[3])
            counters[14][i2]+=1 if summon_type.include?('y') || summon_type.include?('g') || summon_type.include?('t') || summon_type.include?('d') || summon_type.include?('f')
            braves[i2][0]+=1 if ['Ike(Brave)','Lucina(Brave)','Lyn(Brave)','Roy(Brave)'].include?(name)
            braves[i2][1]+=1 if ['Celica(Brave)','Ephraim(Brave)','Hector(Brave)','Veronica(Brave)'].include?(name)
          end
          counters[15][i2]+=1 if [summon_type].include?('y')
          counters[16][i2]+=1 if [summon_type].include?('g')
          counters[17][i2]+=1 if [summon_type].include?('t')
          if counters.length>18
            for i3 in 18...counters.length
              counters[i3][i2]+=1 if counters[i3][3].include?(name)
            end
          end
          colors[i2][0]+=1 if j[1][0]=='Red'
          colors[i2][1]+=1 if j[1][0]=='Blue'
          colors[i2][2]+=1 if j[1][0]=='Green'
          colors[i2][3]+=1 if j[1][0]=='Colorless'
          colors[i2][4]+=1 unless ['Red','Blue','Green','Colorless'].include?(j[1][0])
        end
      end
      sup='-'
      if m && find_in_dev_units(name)>=0
        dv=@dev_units[find_in_dev_units(name)]
        r[0]=dv[1]
        r[1]=dv[2]
        r[2]=dv[3].gsub(' ','')
        r[3]=dv[4].gsub(' ','')
        sup=dv[5]
      elsif did>0
        x=donor_unit_list(did)
        x2=x.find_index{|q| q[0]==name}
        unless x2.nil?
          r[0]=x[x2][1]
          r[1]=x[x2][2]
          r[2]=x[x2][3].gsub(' ','')
          r[3]=x[x2][4].gsub(' ','')
          sup=x[x2][5]
        end
      end
      st=get_stats(event,name,40,r[0],r[1],r[2],r[3])
      b.push(st[1]+st[2]+st[3]+st[4]+st[5])
      st=get_stats(event,name,40,5,0,r[2],r[3])
      scr.push(((st[1]+st[2]+st[3]+st[4]+st[5])/5)+r[0]*5+r[1]*2+90)
      rstar=@rarity_stars[r[0]-1]
      rstar=['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>','<:Icon_Rarity_4p10:448272714210476033>','<:Icon_Rarity_5p10:448272715099406336>','<:Icon_Rarity_6p10:491487784822112256>'][r[0]-1] if r[1]>=10
      rstar='<:Icon_Rarity_S:448266418035621888>' unless sup=='-'
      rstar='<:Icon_Rarity_Sp10:448272715653054485>' if sup != '-' && r[1]>=10
      msg=extend_message(msg,"Unit #{u}: #{r[0]}#{rstar} #{name.gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,-1,name,m)} +#{r[1]} #{"(+#{r[2]}, -#{r[3]})" if !['',' '].include?(r[2]) || !['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}  \u200B  \u200B  BST: #{b[b.length-1]}  \u200B  \u200B  Score: #{scr[scr.length-1]}+`SP`/100",event)
    end
  end
  event.channel.send_temporary_message("#{event.user.mention} Units found, calculating BST and arena score...",8)
  if braves[1].max==1
    counters[14][1]+=braves[1][1]+braves[1][0]
    counters[14][0][1]='Pseudo-F2P'
  end
  if braves[2].max==1
    counters[14][2]+=braves[2][1]+braves[2][0]
    counters[14][0][2]='Pseudo-F2P'
  end
  event << ''
  emblem_name=['','','']
  for i in 0...counters.length
    cname=counters[i][0]
    for i2 in 1...3
      cname=counters[i][0][i2] if i==14 # F2P marker
      if counters[i][i2]>=[[i2*4,k.length].min,2].max
        if emblem_name[i2].length>0 && i>3 && i<10 && emblem_name[i2].split(' ').length<=2
          emblem_name[i2]="#{cname} #{emblem_name[i2]}"
        elsif emblem_name[i2].length>0 && i>9 && i<14 && emblem_name[i2].split(' ').length<=3
          emblem_name[i2]="#{cname} #{emblem_name[i2]}"
        else
          emblem_name[i2]="#{cname} Emblem"
        end
      end
    end
  end
  emblem_name[1]=emblem_name[1].gsub('Red Melee','Sword').gsub('Blue Melee','Lance').gsub('Green Melee','Axe')
  emblem_name[2]=emblem_name[2].gsub('Red Melee','Sword').gsub('Blue Melee','Lance').gsub('Green Melee','Axe')
  if b.length<=0
    event << 'No units listed'
  else
    for i2 in 1...3
      if counters[0,4].map{|q| q[i2]}.max<=2
        if emblem_name[i2].length>0
          emblem_name[i2]="#{emblem_name[i2]} Tactics"
        else
          emblem_name[i2]='Tactics'
        end
      end
      if colors[i2].max==i2 && b.length>=i2*4
        if emblem_name[i2].length>0
          emblem_name[i2]="Color-balanced #{emblem_name[i2]}"
        else
          emblem_name[i2]='Color-balanced'
        end
      end
    end
    b2=b.inject(0){|sum,x| sum + x }
    s2=scr.inject(0){|sum,x| sum + x }
    xy=[155,2]
    if b.length<=4
      if emblem_name[1].length>0
        msg2="__**#{emblem_name[1]} team**__"
      else
        msg2="__**Team**__"
      end
      msg2="#{msg2}\n**BST: #{b2}**\n**Advanced Arena Score: #{'%.1f' % (s2*1.0/b.length+7*b.length+xy[0])}+`SP`/#{b.length*100}**, #{'%.1f' % ((s2*1.0/b.length+7*b.length+xy[0])*2)}+`SP`/#{b.length*50} with bonus"
      msg=extend_message(msg,msg2,event,2)
    elsif b.length<=8
      msg=extend_message(msg,"__**First four listed#{", which constitutes a #{emblem_name[1]} team" if emblem_name[1].length>0}**__\n**BST: #{(b[0]+b[1]+b[2]+b[3])}**\n**Advanced Arena Score: #{'%.1f' % ((scr[0]+scr[1]+scr[2]+scr[3])/4.0+28+xy[0])}+`SP`/400**, #{'%.1f' % (((scr[0]+scr[1]+scr[2]+scr[3])/4.0+28+xy[0])*2)}+`SP`/200 with bonus",event,2)
      msg=extend_message(msg,"__*All listed units#{", which constitutes a #{emblem_name[2]} team" if emblem_name[2].length>0}*__\n*BST: #{b2}*\n*Advanced (pseudo)Arena Score: #{'%.1f' % (s2*1.0/b.length+7*b.length+xy[0])}+`SP`/#{b.length*100}*, #{'%.1f' % ((s2*1.0/b.length+7*b.length+xy[0])*2)}+`SP`/#{b.length*50} with bonus",event,2)
    else
      msg=extend_message(msg,"__**First four listed#{", which constitutes a #{emblem_name[1]} team" if emblem_name[1].length>0}**__\n**BST: #{b[0]+b[1]+b[2]+b[3]}**\n**Advanced Arena Score: #{'%.1f' % ((scr[0]+scr[1]+scr[2]+scr[3])/4.0+28+xy[0])}+`SP`/400**, #{'%.1f' % (((scr[0]+scr[1]+scr[2]+scr[3])/4.0+28+xy[0])*2)}+`SP`/200 with bonus",event,2)
      msg=extend_message(msg,"__*First eight listed#{", which constitutes a #{emblem_name[2]} team" if emblem_name[2].length>0}*__\n*BST: #{b[0]+b[1]+b[2]+b[3]+b[4]+b[5]+b[6]+b[7]}*\n*Advanced (pseudo)Arena Score: #{'%.1f' % ((scr[0]+scr[1]+scr[2]+scr[3]+scr[4]+scr[5]+scr[6]+scr[7])/8.0+56+xy[0])}+`SP`/800*, #{'%.1f' % (((scr[0]+scr[1]+scr[2]+scr[3]+scr[4]+scr[5]+scr[6]+scr[7])/8.0+56+xy[0])*2)}+`SP`/400 with bonus",event,2)
      msg=extend_message(msg,"__All listed units__\nBST: #{b2}\nAdvanced (pseudo)Arena Score: #{'%.1f' % (s2*1.0/b.length+7*b.length+xy[0])}+`SP`/#{b.length*100}, #{'%.1f' % ((s2*1.0/b.length+7*b.length+xy[0])*2)}+`SP`/#{b.length*50} with bonus",event,2)
    end
  end
  msg=extend_message(msg,"Please note that activated blessings will add 2 points to this score, or 4 points with bonus.",event,2)
  event.respond msg
end

bot.command(:bonus) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  x=event.message.text.downcase.split(' ')
  if x.include?('arena') && (x.include?('tempest') || x.include?('tt')) && (x.include?('aether') || x.include?('raid') || x.include?('raids'))
    show_bonus_units(event,'',bot)
  elsif x.include?('arena')
    show_bonus_units(event,'Arena',bot)
  elsif x.include?('tempest') || x.include?('tt')
    show_bonus_units(event,'Tempest',bot)
  elsif x.include?('aether') || x.include?('raid') || x.include?('raids')
    show_bonus_units(event,'Aether',bot)
  else
    show_bonus_units(event,'',bot)
  end
  return nil
end

bot.command([:arena,:arenabonus,:arena_bonus,:bonusarena,:bonus_arena]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  show_bonus_units(event,'Arena',bot)
  return nil
end

bot.command([:tempest,:tempestbonus,:tempest_bonus,:bonustempest,:bonus_tempest,:tt,:ttbonus,:tt_bonus,:bonustt,:bonus_tt]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  show_bonus_units(event,'Tempest',bot)
  return nil
end

bot.command([:aether,:aetherbonus,:aether_bonus,:aethertempest,:aether_tempest,:raid,:raidbonus,:raid_bonus,:bonusraid,:bonus_raid,:raids,:raidsbonus,:raids_bonus,:bonusraids,:bonus_raids]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  show_bonus_units(event,'Aether',bot)
  return nil
end

bot.command([:compare, :comparison]) do |event, *args|
  return nil if overlap_prevent(event)
  if ['skills','skill'].include?(args[0].downcase)
    args.shift
    skill_comparison(event,args,bot)
    return nil
  end
  k=comparison(event,args,bot)
  return nil
end

bot.command([:compareskills,:compareskill,:skillcompare,:skillscompare,:comparisonskills,:comparisonskill,:skillcomparison,:skillscomparison,:compare_skills,:compare_skill,:skill_compare,:skills_compare,:comparison_skills,:comparison_skill,:skill_comparison,:skills_comparison,:skillsincommon,:skills_in_common,:commonskills,:common_skills]) do |event, *args|
  return nil if overlap_prevent(event)
  skill_comparison(event,args,bot)
  return nil
end

bot.command([:skill,:skil]) do |event, *args|
  return nil if overlap_prevent(event)
  if ['stat','stats'].include?(args[0].downcase)
    args.shift
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  elsif ['and','n','&'].include?(args[0].downcase) && ['stat','stat'].include?(args[1].downcase)
    args.shift
    args.shift
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  elsif ['compare','comparison'].include?(args[0].downcase)
    args.shift
    skill_comparison(event,args,bot)
    return nil
  elsif ['rarity','rarities'].include?(args[0].downcase)
    t=Time.now
    if t-@last_multi_reload[1]>60*60 || @shardizard==4
      puts 'reloading EliseText'
      load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
      @last_multi_reload[1]=t
    end
    skill_rarity(event)
    return nil
  elsif ['color','colors','colour','colours'].include?(args[0].downcase)
    args.shift
    args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
    data_load()
    disp_skill(bot,args.join(' '),event,false,true)
    return nil
  elsif ['sort','list'].include?(args[0].downcase)
    args.shift
    sort_skills(bot,event,args)
    return nil
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load()
  disp_skill(bot,args.join(' '),event)
  return nil
end

bot.command([:colors,:color,:colours,:colour]) do |event, *args|
  return nil if overlap_prevent(event)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load()
  disp_skill(bot,args.join(' '),event,false,true)
  return nil
end

bot.command([:skills,:skils,:fodder,:manual,:book,:combatmanual]) do |event, *args|
  return nil if overlap_prevent(event)
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  if s.downcase[0,6]=='skills'
    if ['stat','stats'].include?(args[0].downcase)
      args.shift
      disp_unit_stats_and_skills(event,args,bot)
      return nil
    elsif ['and','n','&'].include?(args[0].downcase) && ['stat','stat'].include?(args[1].downcase)
      args.shift
      args.shift
      disp_unit_stats_and_skills(event,args,bot)
      return nil
    elsif ['compare','comparison'].include?(args[0].downcase)
      args.shift
      skill_comparison(event,args,bot)
      return nil
    elsif ['learn','learnable','inherit','inheritance','inheritable'].include?(args[0].downcase)
      args.shift
      k=parse_function(:learnable_skills,event,args,bot,true)
      return nil unless k<0
    elsif ['sort','list'].include?(args[0].downcase)
      args.shift
      sort_skills(bot,event,args)
      return nil
    end
  end
  k=find_name_in_string(event,nil,1)
  if k.nil?
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      disp_unit_skills(bot,x[1],event)
    elsif s.downcase[0,6]=='skills'
      event.respond "No matches found.  If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill',1)}```, without the s."
    else
      event.respond 'No matches found.  Please note that the `fodder` command is for listing the skills you can fodder a **unit** for, not the units you need to fodder to get a skill.'
    end
    return nil
  end
  str=k[0]
  data_load()
  if str.nil?
  elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_unit_skills(bot,x[1],event)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_unit_skills(bot,x[1],event)
  elsif find_unit(str,event)>=0
    disp_unit_skills(bot,str,event)
  else
    event.respond "No matches found.  #{"If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s." if s[0,6]=='skills'}"
  end
  return nil
end

bot.command([:stats,:stat]) do |event, *args|
  return nil if overlap_prevent(event)
  if ['compare','comparison'].include?(args[0].downcase)
    args.shift
    k=comparison(event,args,bot)
    return nil unless k<1
  elsif ['rand','random'].include?(args[0].downcase)
    pick_random_unit(event,args,bot)
    return nil
  elsif ['study'].include?(args[0].downcase)
    args.shift
    if ['effhp','eff_hp','bulk'].include?(args[0].downcase)
      args.shift
      k=parse_function(:calculate_effective_HP,event,args,bot)
      return nil unless k<0
    elsif ['heal'].include?(args[0].downcase)
      args.shift
      k=parse_function(:heal_study,event,args,bot,true)
      return nil unless k<0
    elsif ['proc'].include?(args[0].downcase)
      args.shift
      k=parse_function(:proc_study,event,args,bot,false)
      return nil unless k<0
    elsif ['phase'].include?(args[0].downcase)
      args.shift
      k=parse_function(:phase_study,event,args,bot)
      return nil unless k<0
    end
    k=parse_function(:unit_study,event,args,bot)
    return nil unless k<0
  elsif ['effhp','eff_hp','bulk'].include?(args[0].downcase)
    args.shift
    k=parse_function(:calculate_effective_HP,event,args,bot)
    return nil unless k<0
  elsif ['heal_study','healstudy','studyheal','study_heal'].include?(args[0].downcase)
    args.shift
    k=parse_function(:heal_study,event,args,bot,true)
    return nil unless k<0
  elsif ['proc_study','procstudy','studyproc','study_proc'].include?(args[0].downcase)
    args.shift
    k=parse_function(:proc_studyevent,args,bot,false)
    return nil unless k<0
  elsif ['icon','color','colors'].include?(args[0].downcase)
    attack_icon(event)
    return nil
  elsif ['skill','skills','skil','skils'].include?(args[0].downcase)
    args.shift
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  elsif ['tiny','small','smol','micro','squashed','little'].include?(args[0].downcase)
    sze=args[0]
    args.shift
    k=find_name_in_string(event,nil,1)
    if k.nil?
      w=nil
      if !detect_multi_unit_alias(event,event.message.text.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,'')).nil?
        x=detect_multi_unit_alias(event,event.message.text.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,''))
        k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
        w=k2[0] unless k2.nil?
        disp_tiny_stats(bot,x[1],w,event,true)
      else
        event.respond 'No matches found.'
      end
      return nil
    end
    str=k[0]
    k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
    w=nil
    w=k2[0] unless k2.nil?
    data_load()
    if !detect_multi_unit_alias(event,str.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,'')).nil?
      x=detect_multi_unit_alias(event,str.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,''))
      disp_tiny_stats(bot,x[1],w,event,true)
    elsif !detect_multi_unit_alias(event,str.downcase.gsub(sze.downcase,''),str.downcase.gsub(sze.downcase,'')).nil?
      x=detect_multi_unit_alias(event,str.downcase.gsub(sze.downcase,''),str.downcase.gsub(sze.downcase,''))
      disp_tiny_stats(bot,x[1],w,event,true)
    elsif find_unit(str,event)>=0
      disp_tiny_stats(bot,str,w,event)
    else
      event.respond 'No matches found'
    end
    return nil
  elsif ['and','n','&'].include?(args[0].downcase) && ['skill','skills'].include?(args[1].downcase)
    args.shift
    args.shift
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  elsif ['sort','list'].include?(args[0].downcase)
    args.shift
    sort_units(bot,event,args)
    return nil
  end
  event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
  k=find_name_in_string(event,nil,1)
  if k.nil?
    w=nil
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true)
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.nil?
  data_load()
  if !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,true)
  elsif find_unit(str,event)>=0
    disp_stats(bot,str,w,event)
  else
    event.respond 'No matches found'
  end
  return nil
end

bot.command([:tinystats,:smallstats,:smolstats,:microstats,:squashedstats,:sstats,:statstiny,:statssmall,:statssmol,:statsmicro,:statssquashed,:statss,:stattiny,:statsmall,:statsmol,:statmicro,:statsquashed,:sstat,:tinystat,:smallstat,:smolstat,:microstat,:squashedstat,:tiny,:small,:micro,:smol,:squashed,:littlestats,:littlestat,:statslittle,:statlittle,:little]) do |event, *args|
  return nil if overlap_prevent(event)
  k=find_name_in_string(event,nil,1)
  if k.nil?
    w=nil
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.nil?
      disp_tiny_stats(bot,x[1],w,event,true)
    elsif !@embedless.include?(event.user.id) && !was_embedless_mentioned?(event)
      event.channel.send_embed("__**No matches found.  Have a smol me instead.**__") do |embed|
        embed.color = 0xD49F61
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Smol_Elise.jpg")
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "image source", url: "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=58900377")
      end
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.nil?
  data_load()
  if !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_tiny_stats(bot,x[1],w,event,true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_tiny_stats(bot,x[1],w,event,true)
  elsif find_unit(str,event)>=0
    disp_tiny_stats(bot,str,w,event)
  else
    event.respond 'No matches found'
  end
end

bot.command([:big,:tol,:macro,:large,:bigstats,:tolstats,:macrostats,:largestats,:bigstat,:tolstat,:macrostat,:largestat,:statsbig,:statstol,:statsmacro,:statslarge,:statbig,:stattol,:statmacro,:statlarge,:statol]) do |event, *args|
  return nil if overlap_prevent(event)
  k=find_name_in_string(event,nil,1)
  if k.nil?
    w=nil
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true,false,false,true)
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.nil?
  data_load()
  if !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,true,false,false,true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,true,false,false,true)
  elsif find_unit(str,event)>=0
    disp_stats(bot,str,w,event,false,false,false,true)
  else
    event.respond 'No matches found'
  end
end

bot.command([:huge,:massive,:giantstats,:hugestats,:massivestats,:giantstat,:hugestat,:massivestat,:statsgiant,:statshuge,:statsmassive,:statgiant,:stathuge,:statmassive]) do |event, *args|
  return nil if overlap_prevent(event)
  k=find_name_in_string(event,nil,1)
  if k.nil?
    w=nil
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true,false,true)
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.nil?
  data_load()
  if !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,true,false,true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,true,false,true)
  elsif find_unit(str,event)>=0
    disp_stats(bot,str,w,event,false,false,true)
  else
    event.respond 'No matches found'
  end
end

bot.command([:unit, :data, :statsskills, :statskills, :stats_skills, :stat_skills, :statsandskills, :statandskills, :stats_and_skills, :stat_and_skills, :statsskill, :statskill, :stats_skill, :stat_skill, :statsandskill, :statandskill, :stats_and_skill, :stat_and_skill, :statsskils, :statskils, :stats_skils, :stat_skils, :statsandskils, :statandskils, :stats_and_skils, :stat_and_skils, :statsskil, :statskil, :stats_skil, :stat_skil, :statsandskil, :statandskil, :stats_and_skil, :stat_and_skil]) do |event, *args|
  return nil if overlap_prevent(event)
  if ['compare','comparison'].include?(args[0].downcase)
    args.shift
    k=comparison(event,args,bot)
    return nil unless k<1
  elsif ['rand','random'].include?(args[0].downcase)
    pick_random_unit(event,args,bot)
    return nil
  elsif ['study'].include?(args[0].downcase)
    args.shift
    if ['effhp','eff_hp','bulk'].include?(args[0].downcase)
      args.shift
      k=parse_function(:calculate_effective_HP,event,args,bot)
      return nil unless k<0
    elsif ['heal'].include?(args[0].downcase)
      args.shift
      k=parse_function(:heal_study,event,args,bot,true)
      return nil unless k<0
    elsif ['proc'].include?(args[0].downcase)
      args.shift
      k=parse_function(:proc_studyevent,args,bot,false)
      return nil unless k<0
    elsif ['phase'].include?(args[0].downcase)
      args.shift
      k=parse_function(:phase_study,event,args,bot)
      return nil unless k<0
    end
    k=parse_function(:unit_study,event,args,bot)
    return nil unless k<0
  elsif ['effhp','eff_hp','bulk'].include?(args[0].downcase)
    args.shift
    k=parse_function(:calculate_effective_HP,event,args,bot)
    return nil unless k<0
  elsif ['phase_study','phasestudy','studyphase','study_phase','phase'].include?(args[0].downcase)
    a.shift
    k=parse_function(:phase_study,event,a,bot,true)
  elsif ['heal_study','healstudy','studyheal','study_heal'].include?(args[0].downcase)
    args.shift
    k=parse_function(:heal_study,event,args,bot,true)
    return nil unless k<0
  elsif ['proc_study','procstudy','studyproc','study_proc','proc'].include?(args[0].downcase)
    args.shift
    k=parse_function(:proc_study,event,args,bot)
    return nil unless k<0
  elsif ['sort','list'].include?(args[0].downcase)
    args.shift
    sort_units(bot,event,args)
    return nil
  end
  disp_unit_stats_and_skills(event,args,bot)
end

bot.command([:flowers,:flower]) do |event|
  return nil if overlap_prevent(event)
  event << 'Look at all the pretty flowers!'
  event << "https://www.getrandomthings.com/list-flowers.php"
end

bot.command(:addalias) do |event, newname, unit, modifier, modifier2|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || @shardizard==4
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  add_new_alias(bot,event,newname,unit,modifier,modifier2)
  return nil
end

bot.command(:alias) do |event, newname, unit, modifier, modifier2|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || @shardizard==4
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  add_new_alias(bot,event,newname,unit,modifier,modifier2,1)
  return nil
end

bot.command([:checkaliases,:aliases,:seealiases]) do |event, *args|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || @shardizard==4
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  list_unit_aliases(event,args,bot)
  return nil
end

bot.command([:serveraliases,:saliases]) do |event, *args|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || @shardizard==4
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  list_unit_aliases(event,args,bot,1)
  return nil
end

bot.command([:deletealias,:removealias]) do |event, name|
  return nil if overlap_prevent(event)
  nicknames_load()
  if name.nil?
    event.respond "I can't delete nothing, silly!" if name.nil?
    return nil
  elsif event.user.id != 167657750971547648 && event.server.nil?
    event.respond 'Only my developer is allowed to use this command in PM.'
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.'
    return nil
  end
  j=find_unit(name,event)
  if j<0
    j=find_skill(name,event)
    if j<0
      j=find_structure(name,event)
      if j.length<=0
        j=find_accessory(name,event)
        if j<0
          j=find_item_feh(name,event)
          if j<0
            event.respond "#{name} is not an alias, silly!"
            return nil
          else
            j=@itemus[j]
            jjj='Item'
          end
        else
          j=@accessories[j]
          jjj='Accessory'
        end
      else
        j=j[0] if j[0].is_a?(Array)
        jjj='Structure'
      end
    else
      j=@skills[j]
      jjj='Skill'
    end
  else
    j=@units[j]
    jjj='Unit'
  end
  k=0
  k=event.server.id unless event.server.nil?
  for izzz in 0...@aliases.length
    if @aliases[izzz][1].downcase==name.downcase
      if @aliases[izzz][3].nil? && event.user.id != 167657750971547648
        event.respond 'You cannot remove a global alias'
        return nil
      elsif @aliases[izzz][3].nil? || @aliases[izzz][3].include?(k)
        unless @aliases[izzz][3].nil?
          for izzz2 in 0...@aliases[izzz][3].length
            @aliases[izzz][3][izzz2]=nil if @aliases[izzz][3][izzz2]==k
          end
          @aliases[izzz][3].compact!
        end
        @aliases[izzz]=nil if @aliases[izzz][3].nil? || @aliases[izzz][3].length<=0
      end
    end
  end
  @aliases.uniq!
  @aliases.compact!
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**#{jjj} Alias:** #{name} for #{j[0]}~~ **DELETED**.")
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...@aliases.length
      f.puts "#{@aliases[i].to_s}#{"\n" if i<@aliases.length-1}"
    end
  }
  nicknames_load()
  event.respond "#{name} has been removed from #{j[0].gsub('Lavatain','Laevatein').gsub('Bladeblade','Laevatein')}'s aliases."
  nzzz=@aliases.reject{|q| q[0]!='Unit'}
  nzzz2=@aliases.reject{|q| q[0]!='Skill'}
  nzzz3=@aliases.reject{|q| q[0]!='Structure'}
  nzzz4=@aliases.reject{|q| ['Unit','Skill','Structure'].include?(q[0])}
  if nzzz[nzzz.length-1].length>1 && nzzz[nzzz.length-1][2]>='Zephiel' || nzzz2[nzzz2.length-1].length>1 && nzzz2[nzzz2.length-1][2]>='Yato' || nzzz3[nzzz3.length-1].length>1 && nzzz3[nzzz3.length-1][2]>='Armor School'
    bot.channel(logchn).send_message('Alias list saved.')
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
      for i in 0...nzzz.length
        f.puts "#{nzzz[i].to_s}"
      end
      for i in 0...nzzz2.length
        f.puts "#{nzzz2[i].to_s}#{"\n" if i<nzzz2.length-1}"
      end
      for i in 0...nzzz3.length
        f.puts "#{nzzz3[i].to_s}#{"\n" if i<nzzz3.length-1}"
      end
      for i in 0...nzzz4.length
        f.puts "#{nzzz4[i].to_s}#{"\n" if i<nzzz4.length-1}"
      end
    }
    bot.channel(logchn).send_message('Alias list has been backed up.')
  end
  return nil
end

bot.command(:addgroup) do |event, groupname, *args|
  return nil if overlap_prevent(event)
  groups_load()
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  if groupname.nil?
    event.respond "I can't add a group with no name, silly!"
    return nil
  elsif args.nil? || args.length<=0
    event << "I can't add a group with no members, silly!"
    event << '...well, actually, I could, but what would be the point?'
    return nil
  elsif event.server.nil? && event.user.id != 167657750971547648
    event.respond 'Only my developer is allowed to use this command in PM.'
    return nil
  elsif ![167657750971547648,208905989619974144,168592191189417984].include?(event.user.id) && !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.'
    return nil
  elsif find_group(groupname,event)>-1 && @groups[find_group(groupname,event)][2].nil? && event.user.id != 167657750971547648
    event.respond 'You do not have the privileges to edit this global group.'
    return nil
  elsif find_group(groupname,event)>-1 && @groups[find_group(groupname,event)][1].length<=0
    event.respond 'This group is dynamic, automatically updating when a new unit that fits the criteria appears.'
    return nil
  elsif find_skill(groupname,event,false,true)>=0
    event.respond "This is not allowed as a group name as it's a skill name."
    return nil
  elsif find_unit(groupname,event,true)>=0
    event.respond "This is not allowed as a group name as it's a unit name."
    return nil
  end
  data_load()
  groups_load()
  for i in 0...args.length
    if !detect_multi_unit_alias(event,args[i].downcase,args[i].downcase,3).nil?
      args[i]=detect_multi_unit_alias(event,args[i].downcase,args[i].downcase,3)[1].join(' ')
    elsif find_unit(args[i].downcase,event)<0
      args[i]=nil
    else
      args[i]=@units[find_unit(args[i].downcase,event)][0]
    end
  end
  args=args.compact.join(' ').split(' ')
  newgroup=false
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  k=0
  k=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=event.server.name unless event.server.nil?
  if find_group(groupname,event)<0 && event.user.id==167657750971547648 && " #{event.message.text.downcase} ".include?(' global ')
    @groups.push([groupname,args])
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{"Global " if event.message.text.downcase.include?(' global ')}Group Created:** #{groupname}\n**Units:** #{args.join(', ')}")
    newgroup=true
  elsif find_group(groupname,event)<0
    @groups.push([groupname,args,[event.server.id]])
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Group Created:** #{groupname}\n**Units:** #{args.join(', ')}")
    newgroup=true
  else
    j=find_group(groupname,event)
    for i in 0...args.length
      f=@groups[j][1].map {|s| s.downcase}
      args[i]=nil if f.include?(args[i].downcase)
    end
    args.compact!
    for i in 0...args.length
      @groups[j][1].push(args[i])
    end
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Group:** #{groupname}\n**Units Added:** #{args.join(', ')}")
  end
  @groups.uniq!
  @groups.sort! {|a,b| (a[0].downcase <=> b[0].downcase) == 0 ? (a[2][0] <=> b[2][0]) : (a[0].downcase <=> b[0].downcase)}
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt', 'w') { |f|
    for i in 0...@groups.length
      f.puts "#{@groups[i].to_s}#{"\n" if i<@groups.length-1}"
    end
  }
  if newgroup
    event.respond "A new #{"global " if event.user.id==167657750971547648 && " #{event.message.text.downcase} ".include?(' global ')}group **#{groupname}** has been created with the members #{args.map{|q| q.gsub('Lavatain','Laevatein')}.join(', ')}"
  else
    event.respond "The existing #{"global " if event.user.id==167657750971547648 && " #{event.message.text.downcase} ".include?(' global ')}group **#{groupname}** has been updated to include the members #{args.map{|q| q.gsub('Lavatain','Laevatein')}.join(', ')}"
  end
  groups_load()
  nzzz=@groups.map{|a| a}
  if nzzz[nzzz.length-1].length>0 && nzzz[nzzz.length-1][0]>='Tempest'
    bot.channel(logchn).send_message('Group list saved.')
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups2.txt', 'w') { |f|
      for i in 0...nzzz.length
        f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
      end
    }
    bot.channel(logchn).send_message('Group list has been backed up.')
  end
  return nil
end

bot.command([:seegroups,:checkgroups,:groups]) do |event|
  return nil if overlap_prevent(event)
  groups_load()
  k=0
  k=event.server.id unless event.server.nil?
  unless safe_to_spam?(event)
    g1=@groups.reject{|q| !q[2].nil? || q[1].length>0}
    g1=g1.reject{|q| q[0]=="Mathoo'sWaifus"} unless event.user.id==167657750971547648
    g2=@groups.reject{|q| !q[2].nil? || q[1].length<=0}
    g3=@groups.reject{|q| q[2].nil? || !q[2].include?(k)}
    for i in 0...g1.length
      g1[i][1]=get_group(g1[i][0],event)[1]
    end
    g=[['**Dynamic Global**',g1.map{|q| "#{q[0].gsub('&','/')} (#{q[1].length} members)"}.join("\n")],['**Manually Global**',g2.map{|q| "#{q[0].gsub('&','/')} (#{q[1].length} members)"}.join("\n")]]
    g.push(['**Server-specific**',g3.map{|q| "#{q[0].gsub('&','/')} (#{q[1].length} members)"}.join("\n")]) if g3.length>0
    create_embed(event,"__**Available Groups**__",'',0x9400D3,nil,nil,g,2)
    return nil
  end
  msg=''
  for i in 0...@groups.length
    if @groups[i][0].downcase=='dancers&singers'
      msg=extend_message(msg,"**Dancers/Singers**\n#{get_group('dancers&singers',event)[1].map{|q| q.gsub('Lavatain','Laevatein')}.sort.join(', ')}",event,2)
    elsif @groups[i][2].nil?
      display=true
      display=false if @groups[i][0].downcase=="mathoo'swaifus"
      display=true if event.user.id==167657750971547648
      display=true if !event.server.nil? && !bot.user(167657750971547648).on(event.server.id).nil? && rand(100).zero?
      if display
        if get_group(@groups[i][0],event)[1].length>50
          msg=extend_message(msg,"**#{@groups[i][0]}** (#{get_group(@groups[i][0],event)[1].length} members)",event,2) if event.user.id==167657750971547648 || @groups[i][0].downcase != "mathoo'swaifus"
        elsif @groups[i][1].length<=0
          msg=extend_message(msg,"**#{@groups[i][0]}**\n#{get_group(@groups[i][0],event)[1].map{|q| q.gsub('Lavatain','Laevatein')}.sort.join(', ')}",event,2) if event.user.id==167657750971547648 || @groups[i][0].downcase != "mathoo'swaifus"
        else
          msg=extend_message(msg,"**#{@groups[i][0]}**\n#{@groups[i][1].map{|q| q.gsub('Lavatain','Laevatein')}.sort.join(', ')}",event,2)
        end
      end
    elsif @groups[i][2].include?(k)
      msg=extend_message(msg,"**#{@groups[i][0]}**\n#{@groups[i][1].map{|q| q.gsub('Lavatain','Laevatein')}.sort.join(', ')}\n~~server exclusive~~",event,2)
    elsif event.server.nil?
      srvs=[]
      for j in 0...@groups[i][2].length
        srvs.push("*#{bot.server(@groups[i][2][j]).name}*") unless event.user.on(@groups[i][2][j]).nil?
      end
      msg=extend_message(msg,"**#{@groups[i][0]}**\n#{@groups[i][1].map{|q| q.gsub('Lavatain','Laevatein')}.sort.join(', ')}\n~~In the following servers: #{list_lift(srvs,"and")}~~",event,2) if srvs.length>0
    end
  end
  event.respond msg
end

bot.command([:deletegroup,:removegroup]) do |event, name|
  return nil if overlap_prevent(event)
  groups_load()
  if event.server.nil? && event.user.id != 167657750971547648
    event.respond 'Only my developer is allowed to use this command in PM.'
    return nil
  elsif find_group(name.downcase,event)<0
    event.respond "The group #{name} doesn't even exist in the first place, silly!"
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.'
    return nil
  elsif find_group(name,event)>-1 && @groups[find_group(name,event)][2].nil? && event.user.id != 167657750971547648
    event.respond 'You do not have the privileges to edit this global group.'
    return nil
  end
  j=find_group(name.downcase,event)
  if @groups[j][1].length<=0 && @groups[j][2].nil?
    event.respond 'This group is dynamic, automatically updating when a new unit that fits the criteria appears.'
    return nil
  end
  if @groups[j][2].nil?
    @groups[j]=nil
  else
    for i in 0...@groups[j][2].length
      @groups[j][2][i]=nil if @groups[j][2][i]==event.server.id
    end
    @groups[j][2].compact!
    @groups[j]=nil if @groups[j][2].length<=0
  end
  event.respond "The group #{name} has been deleted."
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**Group:** #{name}~~\n**DELETED**")
  @groups.compact!
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt', 'w') { |f|
    for i in 0...@groups.length
      f.puts "#{@groups[i].to_s}#{"\n" if i<@groups.length-1}"
    end
  }
  groups_load()
  nzzz=@groups.map{|a| a}
  if nzzz[nzzz.length-1].length>0 && nzzz[nzzz.length-1][0]>='Tempest'
    bot.channel(logchn).send_message('Group list saved.')
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups2.txt', 'w') { |f|
      for i in 0...nzzz.length
        f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
      end
    }
    bot.channel(logchn).send_message('Group list has been backed up.')
  end
  return nil
end

bot.command([:removemember,:removefromgroup]) do |event, group, unit|
  return nil if overlap_prevent(event)
  data_load()
  groups_load()
  if event.server.nil? && event.user.id != 167657750971547648
    event.respond 'Only my developer is allowed to use this command in PM.'
    return nil
  elsif unit.nil? || group.nil?
    event.respond 'You must list a group and a unit to remove from it.'
    return nil
  elsif find_group(group.downcase,event)<0 || find_unit(unit.downcase,event)<0
    event << "The group #{group} doesn't even exist in the first place, silly!" if find_group(group.downcase)<0
    event << "The unit #{unit} doesn't even exist in the first place, silly!" if find_unit(unit.downcase)<0
    return nil
  elsif ![167657750971547648,208905989619974144,168592191189417984].include?(event.user.id) && !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.'
    return nil
  elsif find_group(groupname,event)>-1 && @groups[find_group(groupname,event)][2].nil? && event.user.id != 167657750971547648
    event.respond 'You do not have the privileges to edit this global group.'
    return nil
  end
  j=find_group(group.downcase,event)
  if @groups[j][1].length<=0 && @groups[j][2].nil?
    event.respond 'This group is dynamic, automatically updating when a new unit that fits the criteria appears.'
    return nil
  end
  i=find_unit(unit.downcase,event)
  r=false
  for k in 0...@groups[j][1].length
    if @groups[j][1][k].downcase==@units[i][0].downcase
      @groups[j][1][k]=nil
      r=true
    end
  end
  @groups[j][1].compact!
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  if r
    event << "#{@units[i][0].gsub('Lavatain','Laevatein')} has been removed from the group #{@groups[j][0]}"
    if @groups[j][1].length<=0
      event << "The group #{@groups[j][0]} now has 0 members, so I'm deleting it."
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**Group:** #{@groups[j][0]}~~\n**DELETED**")
      @groups[j]=nil
      @groups.compact!
    else
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Group:** #{@groups[j][0]}\n**Units removed:** #{@units[i][0]}")
    end
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt', 'w') { |f|
      for i in 0...@groups.length
        f.puts "#{@groups[i].to_s}#{"\n" if i<@groups.length-1}"
      end
    }
    groups_load()
    nzzz=@groups.map{|a| a}
    if nzzz[nzzz.length-1].length>0 && nzzz[nzzz.length-1][0]>='Tempest'
      bot.channel(logchn).send_message('Group list saved.')
      open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups2.txt', 'w') { |f|
        for i in 0...nzzz.length
          f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
        end
      }
      bot.channel(logchn).send_message('Group list has been backed up.')
    end
  else
    event << "#{@units[i][0]} wasn't even in the group #{@groups[j][0]}, silly!"
  end
  return nil
end

bot.command([:find,:search]) do |event, *args|
  return nil if overlap_prevent(event)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  metadata_load()
  mode=1
  mode=0 if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
  if args.nil? || args.length.zero?
    p1=find_in_units(event,mode,true)
    p2=find_in_skills(event,mode,true,p1)
    if !p1.is_a?(Array) && !p2.is_a?(Array)
      event.respond 'Your request is gibberish.'
    elsif !p1.is_a?(Array)
      display_skills(event, mode)
    elsif !p2.is_a?(Array)
      display_units(event, mode)
    else
      event.respond "I'm not displaying all units *and* all skills!"
    end
  elsif ['unit','char','character','person','units','chars','charas','chara','people'].include?(args[0].downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
    display_units(event, mode)
  elsif ['skill','skills'].include?(args[0].downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',(event.message.text.length/30).floor+1)
    display_skills(event, mode)
  else
    event.channel.send_temporary_message('Calculating data, please wait...',(event.message.text.length/30).floor+2)
    p1=find_in_units(event,1,true)
    m=[p1[0]]
    p1=p1[1].map{|q| "#{'~~' if !["Laevatein","- - -"].include?(q) && !@units[find_unit(q,event,false,true)][13][0].nil?}#{q}#{'~~' if !["Laevatein","- - -"].include?(q) && !@units[find_unit(q,event,false,true)][13][0].nil?}"}
    p2=find_in_skills(event,1,true)
    m.push(p2[0])
    p2=p2[1]
    if !p1.is_a?(Array) && !p2.is_a?(Array)
      event.respond 'Your request is gibberish.'
    elsif !p1.is_a?(Array)
      display_skills(event, mode)
    elsif !p2.is_a?(Array)
      display_units(event, mode)
    elsif p1.join("\n").length+p2.join("\n").length+m.join("\n").length<=1950
      create_embed(event,"#{"__**Unit search**__\n#{m[0].join("\n")}\n\n" if m[0].length>0}#{"__**Skill search**__\n#{m[1].join("\n")}\n\n" if m[1].length>0}__**Results**__",'',0x9400D3,"Totals: #{p1.reject{|q| q=='- - -'}.uniq.length} units, #{p2.reject{|q| q=='- - -'}.uniq.length} skills",nil,[['**Units**',p1.join("\n")],['**Skills**',p2.join("\n")]],2)
    elsif !safe_to_spam?(event)
      event.respond 'My response would be so long that I would prefer you ask me in PM.'
    else
      t="**Units:** #{p1[0]}"
      if p1.length>1
        for i in 1...p1.length
          t=extend_message(t,p1[i],event)
        end
      end
      t=extend_message(t,"**Skills:** #{p2[0]}",event,3)
      if p2.length>1
        for i in 1...p2.length
          t=extend_message(t,p2[i],event)
        end
      end
      event.respond t
    end
  end
  return nil
end

bot.command([:sort,:list]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args[0].nil?
  elsif (event.user.id==167657750971547648 || event.channel.id==386658080257212417) && ['group','groups'].include?(args[0].downcase)
    data_load()
    groups_load()
    @groups.uniq!
    @groups.sort! {|a,b| (a[0].downcase <=> b[0].downcase) == 0 ? (a[2][0] <=> b[2][0]) : (a[0].downcase <=> b[0].downcase)}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt', 'w') { |f|
      for i in 0...@aliases.length
        f.puts "#{@aliases[i].to_s}#{"\n" if i<@aliases.length-1}"
      end
    }
    event.respond 'The groups list has been sorted alphabetically'
    return nil
  elsif (event.user.id==167657750971547648 || event.channel.id==386658080257212417) && ['alias','aliases'].include?(args[0].downcase)
    data_load()
    nicknames_load()
    @aliases.uniq!
    @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? ((a[2].downcase <=> b[2].downcase) == 0 ? (a[1].downcase <=> b[1].downcase) : (a[2].downcase <=> b[2].downcase)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
      for i in 0...@aliases.length
        f.puts "#{@aliases[i].to_s}#{"\n" if i<@aliases.length-1}"
      end
    }
    @multi_aliases.uniq!
    @multi_aliases.sort! {|a,b| (a[1].map{|q| q.downcase} <=> b[1].map{|q| q.downcase}) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].map{|q| q.downcase} <=> b[1].map{|q| q.downcase})}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHMultiNames.txt', 'w') { |f|
      for i in 0...@multi_aliases.length
        f.puts "#{@multi_aliases[i].to_s}#{"\n" if i<@multi_aliases.length-1}"
      end
    }
    event.respond 'The alias list has been sorted alphabetically'
    return nil
  elsif ['skill','skills'].include?(args[0].downcase)
    args.shift
    sort_skills(bot,event,args)
    return nil
  end
  sort_units(bot,event,args)
end

bot.command([:sortskill, :skillsort, :sortskills, :skillssort, :listskill, :skillist, :skillist, :listskills, :skillslist]) do |event, *args|
  return nil if overlap_prevent(event)
  sort_skills(bot,event,args)
end

bot.command([:sortstats, :statssort, :sortstat, :statsort, :liststats, :statslist, :statlist, :liststat, :sortunits, :unitssort, :sortunit, :unitsort, :listunits, :unitslist, :unitlist, :listunit]) do |event, *args|
  return nil if overlap_prevent(event)
  sort_units(bot,event,args)
end

bot.command([:average,:mean]) do |event, *args|
  return nil if overlap_prevent(event)
  event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  f2=[0,0,0,0,0,0,0]
  k22=find_in_units(event,3) # Narrow the list of units down based on the defined parameters
  g=get_markers(event)
  data_load()
  k222=k22.reject{|q| !has_any?(g, q[13][0]) || q[5][0].nil? || q[5][0].to_i.zero?} if k22.is_a?(Array)
  k222=@units.reject{|q| !has_any?(g, q[13][0]) || q[5][0].nil? || q[5][0].to_i.zero?} unless k22.is_a?(Array)
  k222=k222.reject{|q| !q[13][0].nil?} unless " #{event.message.text.downcase} ".include?(' all ')
  k222.compact!
  ccz=[]
  atkstat=[]
  event.channel.send_temporary_message('Units found, finding average stats now...',2)
  data_load()
  u=@units.map{|q| q}
  for i2 in 0...k222.length
    ccz.push(unit_color(event,u.find_index{|q| q[0]==k222[i2][0].gsub('Laevatein','Lavatain')},k222[i2][0],1))
    atkstat.push('Strength') if ['Blade','Bow','Dagger'].include?(k222[i2][1][1])
    atkstat.push('Magic') if ['Tome','Healer'].include?(k222[i2][1][1])
    atkstat.push('Freeze') if ['Dragon'].include?(k222[i2][1][1])
    f2[1]+=k222[i2][5][0]
    f2[2]+=k222[i2][5][1]
    f2[3]+=k222[i2][5][2]
    f2[4]+=k222[i2][5][3]
    f2[5]+=k222[i2][5][4]
  end
  if ccz.length.zero?
    ccz=0xFFD800
  else
    ccz=avg_color(ccz)
  end
  atk='<:GenericAttackS:514712247587569664>'
  if atkstat.uniq.length==1
    atk='<:StrengthS:514712248372166666>' if atkstat.uniq[0]=='Strength'
    atk='<:MagicS:514712247289774111>' if atkstat.uniq[0]=='Magic'
    atk='<:FreezeS:514712247474585610>' if atkstat.uniq[0]=='Freeze'
  end
  create_embed(event,"__**Average among #{k222.length} units**__","<:HP_S:514712247503945739> HP: #{div_100(f2[1]*100/k222.length)}\n#{atk} Attack: #{div_100(f2[2]*100/k222.length)}\n<:SpeedS:514712247625580555> Speed: #{div_100(f2[3]*100/k222.length)}\n<:DefenseS:514712247461871616> Defense: #{div_100(f2[4]*100/k222.length)}\n<:ResistanceS:514712247574986752> Resistance: #{div_100(f2[5]*100/k222.length)}\n\nBST: #{div_100((f2[1]+f2[2]+f2[3]+f2[4]+f2[5])*100/k222.length)}",ccz)
  return nil
end

bot.command([:bestamong,:bestin,:beststats,:higheststats,:highest,:best,:highestamong,:highestin]) do |event, *args|
  return nil if overlap_prevent(event)
  event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k22=find_in_units(event,3) # Narrow the list of units down based on the defined parameters
  g=get_markers(event)
  data_load()
  k222=k22.reject{|q| !has_any?(g, q[13][0]) || q[5][0].nil? || q[5][0].to_i.zero?} if k22.is_a?(Array)
  k222=@units.reject{|q| !has_any?(g, q[13][0]) || q[5][0].nil? || q[5][0].to_i.zero?} unless k22.is_a?(Array)
  k222=k222.reject{|q| !q[13][0].nil?} unless " #{event.message.text.downcase} ".include?(' all ')
  k222.compact!
  ccz=[]
  atkstat=[]
  event.channel.send_temporary_message('Units found, finding highest stats now...',2)
  hstats=[[0,[]],[0,[]],[0,[]],[0,[]],[0,[]],[0,[]]]
  data_load()
  u=@units.map{|q| q}
  for i in 0...k222.length
    d=u[u.find_index{|q| q[0]==k222[i][0].gsub('Laevatein','Lavatain')}]
    ccz.push(unit_color(event,u.find_index{|q| q[0]==k222[i][0].gsub('Laevatein','Lavatain')},k222[i][0],1))
    atkstat.push('Strength') if ['Blade','Bow','Dagger'].include?(k222[i][1][1])
    atkstat.push('Magic') if ['Tome','Healer'].include?(k222[i][1][1])
    atkstat.push('Freeze') if ['Dragon'].include?(k222[i][1][1])
    for j in 0...6
      stz=d[5][j-1]
      stz=d[5][0]+d[5][1]+d[5][2]+d[5][3]+d[5][4] if j.zero?
      if stz==hstats[j][0]
        hstats[j][1].push(d[0])
      elsif stz>hstats[j][0]
        hstats[j]=[stz,[d[0]]]
      end
    end
  end
  if ccz.length.zero?
    ccz=0xFFD800
  else
    ccz=avg_color(ccz)
  end
  stzzz=['BST','HP','Attack','Speed','Defense','Resistance']
  stemoji=['','<:HP_S:514712247503945739>','<:GenericAttackS:514712247587569664>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
  if atkstat.uniq.length==1
    stemoji[2]='<:StrengthS:514712248372166666>' if atkstat.uniq[0]=='Strength'
    stemoji[2]='<:MagicS:514712247289774111>' if atkstat.uniq[0]=='Magic'
    stemoji[2]='<:FreezeS:514712247474585610>' if atkstat.uniq[0]=='Freeze'
  end
  hbst=0
  for iz in 0...hstats.length
    hbst+=hstats[iz][0] if iz != 0
    if hstats[iz][1].length>=k222.length
      hstats[iz]="#{stemoji[iz]} Constant #{stzzz[iz]}: #{hstats[iz][0]}"
    else
      hstats[iz]="#{stemoji[iz]} Highest #{stzzz[iz]}: #{hstats[iz][0]} (#{hstats[iz][1].join(', ')})"
    end
  end
  create_embed(event,"__**Best among #{k222.length} units**__","#{hstats[1]}\n#{hstats[2]}\n#{hstats[3]}\n#{hstats[4]}\n#{hstats[5]}\n\n#{hstats[0]}\nBST of highest stats: #{hbst}",ccz)
  return nil
end

bot.command([:worstamong,:worstin,:worststats,:loweststats,:lowest,:worst,:lowestamong,:lowestin]) do |event, *args|
  return nil if overlap_prevent(event)
  event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k22=find_in_units(event,3) # Narrow the list of units down based on the defined parameters
  g=get_markers(event)
  data_load()
  k222=k22.reject{|q| !has_any?(g, q[13][0]) || q[5][0].nil? || q[5][0].to_i.zero?} if k22.is_a?(Array)
  k222=@units.reject{|q| !has_any?(g, q[13][0]) || q[5][0].nil? || q[5][0].to_i.zero?} unless k22.is_a?(Array)
  k222=k222.reject{|q| !q[13][0].nil?} unless " #{event.message.text.downcase} ".include?(' all ')
  k222.compact!
  ccz=[]
  atkstat=[]
  event.channel.send_temporary_message('Units found, finding lowest stats now...',2)
  hstats=[[1000,[]],[1000,[]],[1000,[]],[1000,[]],[1000,[]],[1000,[]]]
  data_load()
  u=@units.map{|q| q}
  for i in 0...k222.length
    d=u[u.find_index{|q| q[0]==k222[i][0].gsub('Laevatein','Lavatain')}]
    ccz.push(unit_color(event,u.find_index{|q| q[0]==k222[i][0].gsub('Laevatein','Lavatain')},k222[i][0],1))
    atkstat.push('Strength') if ['Blade','Bow','Dagger'].include?(k222[i][1][1])
    atkstat.push('Magic') if ['Tome','Healer'].include?(k222[i][1][1])
    atkstat.push('Freeze') if ['Dragon'].include?(k222[i][1][1])
    for j in 0...6
      stz=d[5][j-1]
      stz=d[5][0]+d[5][1]+d[5][2]+d[5][3]+d[5][4] if j.zero?
      if stz==hstats[j][0]
        hstats[j][1].push(d[0])
      elsif stz<hstats[j][0]
        hstats[j]=[stz,[d[0]]]
      end
    end
  end
  if ccz.length.zero?
    ccz=0xFFD800
  else
    ccz=avg_color(ccz)
  end
  stzzz=['BST','HP','Attack','Speed','Defense','Resistance']
  stemoji=['','<:HP_S:514712247503945739>','<:GenericAttackS:514712247587569664>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
  if atkstat.uniq.length==1
    stemoji[2]='<:StrengthS:514712248372166666>' if atkstat.uniq[0]=='Strength'
    stemoji[2]='<:MagicS:514712247289774111>' if atkstat.uniq[0]=='Magic'
    stemoji[2]='<:FreezeS:514712247474585610>' if atkstat.uniq[0]=='Freeze'
  end
  hbst=0
  for iz in 0...hstats.length
    hbst+=hstats[iz][0] if iz != 0
    if hstats[iz][1].length>=k222.length
      hstats[iz]="#{stemoji[iz]} Constant #{stzzz[iz]}: #{hstats[iz][0]}"
    else
      hstats[iz]="#{stemoji[iz]} Lowest #{stzzz[iz]}: #{hstats[iz][0]} (#{hstats[iz][1].join(', ')})"
    end
  end
  create_embed(event,"__**Worst among #{k222.length} units**__","#{hstats[1]}\n#{hstats[2]}\n#{hstats[3]}\n#{hstats[4]}\n#{hstats[5]}\n\n#{hstats[0]}\nBST of lowest stats: #{hbst}",ccz)
  return nil
end

bot.command([:embeds,:embed]) do |event|
  return nil if overlap_prevent(event)
  embedless_swap(bot,event)
end

bot.command([:headpat,:patpat,:pat]) do |event|
  return nil if overlap_prevent(event)
  canpost=true
  if event.server.nil?
  elsif event.server.id==271642342153388034
    post=Time.now
    if (post - @zero_by_four[1]).to_f > 1800
      @zero_by_four[1]=post
    else
      return nil
    end
  elsif event.channel.id==330850148261298176
    return nil
  end
  p=[['Corrin','she'],['Sakura','she'],['Camilla','she'],['my friends','they'],['Kiran','they'],['Mathoo','he']]
  if (event.server.nil? && event.user.id==270372601107447808) || (!event.server.nil? && !bot.user(270372601107447808).on(event.server.id).nil?)
    hubbyid=270372601107447808
    p.push([bot.user(270372601107447808).name,'he'])
    p[6]=['you','you'] if event.user.id==270372601107447808
  elsif (event.server.nil? && event.user.id==261321388344868867) || (!event.server.nil? && !bot.user(261321388344868867).on(event.server.id).nil?)
    hubbyid=261321388344868867
    p.push([bot.user(261321388344868867).name,'he'])
    p[6]=['you','you'] if event.user.id==261321388344868867
  end
  p2=p.sample
  r=[["Please don't, #{p2[0]} just did my hair. Do you know how much time #{p2[1]} spent on these drills?",false],
     ["^-^",true],["That feels good.",true],["Hee hee hee, yay!",true],
     ["\\*purrs\\* ...wait, why am *I* purring?  Sakura's the one who dressed up as a cat!",true]]
  r.push(["My husband wouldn't appreciate you doing this.",(rand(2).zero?)]) unless event.user.id==hubbyid
  r.push(["\\*pulls away* Don't do that, please!",false]) unless event.user.id==hubbyid
  r.push(['\\*hums happily*',true]) if event.user.id==hubbyid
  r.push(['Aww, thanks, honey!  I have the bestest hubby ever!',true]) if event.user.id==hubbyid
  can_joseph=true
  if event.server.nil?
    can_joseph=false if event.user.id==170070293493186561
  else
    can_joseph=false if !bot.user(170070293493186561).on(event.server.id).nil?
    can_joseph=true if !bot.user(256502173788143626).on(event.server.id).nil?
  end
  r.push(["Do I remind you of Joseph? He's the cutest puppy that ever was!",true]) if can_joseph
  r2=r.sample
  if r2[1] && rand(10).zero?
    if event.user.id==270372601107447808
      event << "Elise: #{r2[0]}"
      event << 'Leo: \\*spies the two, grumbles\\*'
      event << "Elise: Go away, Leo.  #{bot.user(270372601107447808).name.split(' | ')[0]} and I can do whatever we want; we're married.  \\*sticks out tongue* "
    elsif event.user.id==261321388344868867
      event << "Elise: #{r2[0]}"
      event << 'Leo: \\*spies the two, grumbles\\*'
      event << "Elise: Go away, Leo.  #{bot.user(261321388344868867).name} and I can do whatever we want; we're married.  \\*sticks out tongue* "
    else
      event << "Elise: #{r2[0]}"
      event << 'Leo: Please stop, you need to treat her like the adult that she technically is.'
      event << "Elise: \\*sticks out tongue* You're no fun."
    end
  else
    event << r2[0]
  end
  event << ''
  metadata_load()
  z=0
  z=1 if event.user.id==270372601107447808
  z=2 if event.user.id==261321388344868867
  @headpats[z]+=1
  if @headpats[z]>=1000000000
    event << '~~resetting counter~~'
    @headpats[z]=1
  end
  metadata_save()
  if event.user.id==167657750971547648 || event.message.text.downcase.split(' ').include?('stats')
    event << "~~This is the #{longFormattedNumber(@headpats[0]+@headpats[1]+@headpats[2],true)} time someone has tried to give me a headpat.~~"
    event << ""
    if event.server.nil? && event.user.id==167657750971547648
      z=(@headpats[1]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
      z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
      event << "~~Moosie has headpatted me #{longFormattedNumber(@headpats[1])} time#{"s" unless @headpats[1]==1}, which is #{z}% of the headpats I've received~~"
      z=(@headpats[2]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
      z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
      event << "~~ExpiredJellyBean has headpatted me #{longFormattedNumber(@headpats[2])} time#{"s" unless @headpats[2]==1}, which is #{z}% of the headpats I've received~~"
      z=(@headpats[0]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
      z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
      event << "~~Other people have headpatted me #{longFormattedNumber(@headpats[0])} time#{"s" unless @headpats[0]==1}, which is #{z}% of the headpats I've received~~"
    elsif event.server.nil?
      z=(@headpats[1]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
      z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
      event << "~~Moosie has headpatted me #{longFormattedNumber(@headpats[1])} time#{"s" unless @headpats[1]==1}, which is #{z}% of the headpats I've received.~~"
      z=(@headpats[0]*10000+@headpats[2]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
      z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
      event << "~~Other people have headpatted me #{longFormattedNumber(@headpats[0]+@headpats[2])} time#{"s" unless @headpats[0]+@headpats[2]==1}, which is #{z}% of the headpats I've received.~~"
    else
      moosiebean=[false,false]
      if !bot.user(270372601107447808).on(event.server.id).nil?
        z=(@headpats[1]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
        z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
        event << "~~Moosie has headpatted me #{longFormattedNumber(@headpats[1])} time#{"s" unless @headpats[1]==1}, which is #{z}% of the headpats I've received.~~"
        moosiebean[0]=true
      end
      if !bot.user(261321388344868867).on(event.server.id).nil?
        z=(@headpats[2]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
        z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
        event << "~~ExpiredJellyBean has headpatted me #{longFormattedNumber(@headpats[2])} time#{"s" unless @headpats[2]==1}, which is #{z}% of the headpats I've received.~~"
        moosiebean[1]=true
      end
      if moosiebean[0] && moosiebean[1]
        z=(@headpats[0]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
        z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
        event << "~~Other people have headpatted me #{longFormattedNumber(@headpats[0])} time#{"s" unless @headpats[0]==1}, which is #{z}% of the headpats I've received.~~"
      elsif moosiebean[0]
        z=(@headpats[0]*10000+@headpats[2]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
        z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
        event << "~~Other people have headpatted me #{longFormattedNumber(@headpats[0]+@headpats[2])} time#{"s" unless @headpats[0]+@headpats[2]==1}, which is #{z}% of the headpats I've received.~~"
      elsif moosiebean[1]
        z=(@headpats[0]*10000+@headpats[1]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
        z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
        event << "~~Other people have headpatted me #{longFormattedNumber(@headpats[0]+@headpats[1])} time#{"s" unless @headpats[0]+@headpats[1]==1}, which is #{z}% of the headpats I've received.~~"
      end
    end
  elsif event.user.id==270372601107447808
    event << "~~This is the #{longFormattedNumber(@headpats[1],true)} time you have given me a headpat.~~"
    z=(@headpats[1]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
    z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
    event << "~~#{z}% of the attempted headpats were performed by you.~~"
  elsif event.user.id==261321388344868867
    event << "~~This is the #{longFormattedNumber(@headpats[2],true)} time you have given me a headpat.~~"
    z=(@headpats[2]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
    z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
    event << "~~#{z}% of the attempted headpats were performed by you.~~"
  elsif event.server.nil?
    event << "~~This is the #{longFormattedNumber(@headpats[0]+@headpats[1]+@headpats[2],true)} time someone has tried to give me a headpat.~~"
  elsif !bot.user(270372601107447808).on(event.server.id).nil?
    event << "~~This is the #{longFormattedNumber(@headpats[0]+@headpats[2],true)} time someone other than my husband has tried to give me a headpat.~~"
  elsif !bot.user(261321388344868867).on(event.server.id).nil?
    event << "~~This is the #{longFormattedNumber(@headpats[0]+@headpats[1],true)} time someone other than my husband has tried to give me a headpat.~~"
  else
    event << "~~This is the #{longFormattedNumber(@headpats[0]+@headpats[1]+@headpats[2],true)} time someone has tried to give me a headpat.~~"
  end
  return nil
end

bot.command(:natures) do |event|
  return nil if overlap_prevent(event)
  event << 'A guide to nature names.  Though things like `+Atk` and `-Def` still work'
  event << 'https://orig00.deviantart.net/d88e/f/2018/047/9/2/nature_names_by_rot8erconex-dc3e1fj.png'
end

bot.command([:growths, :gps, :growth, :gp]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  growth_explain(event,bot)
end

bot.command([:oregano, :Oregano]) do |event|
  return nil if overlap_prevent(event)
  if event.server.nil?
  elsif [256291408598663168,462100851864109056].include?(event.server.id)
    k2=get_weapon(event.message.text.downcase.gsub('feh!oregano','').gsub('feh?oregano','').gsub('f?oregano','').gsub('e?oregano','').gsub('h?oregano',''),event)
    w=nil
    w=k2[0] unless k2.nil?
    disp_stats(bot,'Oregano',w,event,false,true)
    return nil
  end
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  oregano_explain(event,bot)
end

bot.command([:whoisoregano, :whoIsOregano, :whoisOregano]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  oregano_explain(event,bot)
end

bot.command(:merges) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  merge_explain(event,bot)
end

bot.command(:score) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  score_explain(event,bot)
end

bot.command(:invite) do |event, user|
  return nil if overlap_prevent(event)
  usr=event.user
  txt="**To invite me to your server: <https://goo.gl/HEuQK2>**\nTo look at my source code: <https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/PriscillaBot.rb>\nTo follow my creator's development Twitter and learn of updates: <https://twitter.com/EliseBotDev>\nIf you suggested me to server mods and they ask what I do, copy this image link to them: https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/MarketingElise.png"
  user_to_name='you'
  unless user.nil?
    if /<@!?(?:\d+)>/ =~ user
      usr=event.message.mentions[0]
      txt="This message was sent to you at the request of #{event.user.distinct}.\n\n#{txt}"
      user_to_name=usr.distinct
    else
      usr=bot.user(user.to_i)
      txt="This message was sent to you at the request of #{event.user.distinct}.\n\n#{txt}"
      user_to_name=usr.distinct
    end
  end
  usr.pm(txt)
  event.respond "A PM was sent to #{user_to_name}." unless event.server.nil? && user_to_name=="you"
end

bot.command([:bugreport, :suggestion, :feedback]) do |event, *args|
  return nil if overlap_prevent(event)
  bug_report(bot,event,args,4,["<:Shard_Colorless:443733396921909248> Transparent","<:Shard_Red:443733396842348545> Scarlet","<:Shard_Blue:443733396741554181> Azure","<:Shard_Green:443733397190344714> Verdant"],'Shard',@prefix)
end

bot.command([:tools,:links,:tool,:link,:resources,:resources]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  show_tools(event,bot)
end

bot.command(:shard) do |event, i|
  return nil if overlap_prevent(event)
  if i.to_i.to_s==i && i.to_i.is_a?(Integer) && @shardizard != 4
    srv=(bot.server(i.to_i) rescue nil)
    if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
      event.respond "I am not in that server, but it would use #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(i.to_i >> 22) % 4]} Shards."
    else
      event.respond "#{srv.name} uses #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(i.to_i >> 22) % 4]} Shards."
    end
    return nil
  end
  event.respond 'This is the debug mode, which uses <:Shard_Gold:443733396913520640> Golden Shards.' if @shardizard==4
  event.respond 'PMs always use <:Shard_Colorless:443733396921909248> Transparent Shards.' if event.server.nil?
  event.respond "This server uses #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(event.server.id >> 22) % 4]} Shards." unless event.server.nil? || @shardizard==4
end

bot.command([:today,:todayinfeh,:todayInFEH,:today_in_feh,:today_in_FEH,:daily,:now]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  today_in_feh(event,bot)
  return nil
end

bot.command([:tomorrow,:tomorow,:tommorrow,:tommorow]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  today_in_feh(event,bot,true)
  return nil
end

bot.command([:next,:schedule]) do |event, type|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  next_events(event,bot,type)
  return nil
end

bot.command([:status, :avatar, :avvie]) do |event, *args|
  return nil if overlap_prevent(event)
  t=Time.now
  timeshift=6
  t-=60*60*timeshift
  if event.user.id==167657750971547648 && !args.nil? && args.length>0 # only work when used by the developer
    bot.game=args.join(' ')
    event.respond 'Status set.'
    return nil
  end
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event << "Current avatar: #{bot.user(312451658908958721).avatar_url}"
    event << "Unit in avatar: #{@avvie_info[0]}"
    event << ''
    event << "Current status:"
    event << "[Playing] #{@avvie_info[1]}"
    event << ''
    event << "Reason: #{@avvie_info[2]}" unless @avvie_info[2].length.zero?
    event << ''
    event << "Dev's timezone: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]}) | #{'0' if t.hour<10}#{t.hour}:#{'0' if t.min<10}#{t.min}"
  else
    create_embed(event,'',"Unit in avatar: #{@avvie_info[0]}\n\nCurrent status:\n[Playing] #{@avvie_info[1]}#{"\n\nReason: #{@avvie_info[2]}" unless @avvie_info[2].length.zero?}\n\n[For a full calendar of avatars, click here](https://docs.google.com/spreadsheets/d/1j-tdpotMO_DcppRLNnT8DN8Ftau-rdQ-ZmZh5rZkZP0/edit?usp=sharing)",(t.day*7+t.month*21*256+(t.year-2000)*10*256*256),"Dev's timezone: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]}) | #{'0' if t.hour<10}#{t.hour}:#{'0' if t.min<10}#{t.min}",bot.user(312451658908958721).avatar_url)
  end
  return nil
end

bot.command([:donation, :donate]) do |event, uid|
  return nil if overlap_prevent(event)
  uid="#{event.user.id}" if uid.nil? || uid.length.zero?
  if /<@!?(?:\d+)>/ =~ uid
    uid=event.message.mentions[0].id
  else
    uid=uid.to_i
    uid=event.user.id if uid==0
  end
  g=get_donor_list()
  if uid==167657750971547648
    n=["#{bot.user(uid).distinct} is","He"]
    n=["You are","You"] if uid==event.user.id
    create_embed(event,"#{n[0]} my developer.","#{n[1]} can have whatever permissions #{n[1].downcase} want#{'s' unless uid==event.user.id} to have.",0x00DAFA)
  elsif g.map{|q| q[0]}.include?(uid)
    n="#{bot.user(uid).distinct} is"
    n="You are" if uid==event.user.id
    g=g[g.find_index{|q| q[0]==uid}]
    str=""
    n4=bot.user(uid).name
    n4=n4[0,[3,n4.length].min]
    n4=" #{n4}" if n4.length<2
    n2=n4.downcase
    n3=[]
    for i in 0...n2.length
      if "abcdefghijklmnopqrstuvwxyz".include?(n2[i])
        n3.push(9*("abcdefghijklmnopqrstuvwxyz".split(n2[i])[0].length)+25)
        n3[i]+=5 if n4[i]!=n2[i]
      elsif n2[i].to_i.to_s==n2[i]
        n3.push(n2[i].to_i*2+1)
      else
        n3.push(0)
      end
    end
    color=n3[0]*256*256+n3[1]*256+n3[2]
    str="**Tier 1:** Ability to give server-specific aliases in any server\n\u2713 Given" if g[2]>=1
    if g[2]>=2
      if g[3].nil? || g[3].length.zero? || g[4].nil? || g[4].length.zero?
        str="#{str}\n\n**Tier 2:** Birthday avatar\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      elsif !File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseImages/#{g[4]}.png")
        str="#{str}\n\n**Tier 2:** Birthday avatar\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected.\n*Birthday:* #{g[3][1]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][g[3][0]]}\n*Character:* #{g[4]}"
      else
        str="#{str}\n\n**Tier 2:** Birthday avatar\n\u2713 Given\n*Birthday:* #{g[3][1]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][g[3][0]]}\n*Character:* #{g[4]}"
      end
    end
    if g[2]>=3
      if !File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt")
        str="#{str}\n\n**Tier 3:** Unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      else
        str="#{str}\n\n**Tier 3:** Unit tracking\n\u2713 Given\n*Trigger word:* #{donor_unit_list(uid,1)[0].split('\\'[0])[0]}'s"
      end
    end
    if g[2]>=4
      if !File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt")
        str="#{str}\n\n**Tier 4:** __*Colored*__ unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      elsif donor_unit_list(uid,1)[0].split('\\'[0])[1].nil?
        str="#{str}\n\n**Tier 4:** __*Colored*__ unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      else
        str="#{str}\n\n**Tier 4:** __*Colored*__ unit tracking\n\u2713 Given\n*Color of choice:* #{donor_unit_list(uid,1)[0].split('\\'[0])[1]}"
        color=donor_unit_list(uid,1)[0].split('\\'[0])[1].hex
      end
    end
    create_embed(event,"__**#{n} a Tier #{g[2]} donor.**__",str,color)
  end
  donor_embed(bot,event)
  return nil
end

bot.command(:edit) do |event, cmd, *args|
  return nil if overlap_prevent(event)
  uid=event.user.id
  if uid==167657750971547648
    event.respond "This command is for the donors.  Your version of the command is `FEH!devedit`."
    return nil
    uid=244073468981805056
  elsif !get_donor_list().reject{|q| q[2]<3}.map{|q| q[0]}.include?(uid)
    event.respond "You do not have permission to use this command."
    return nil
  elsif !File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt")
    event.respond "Please wait until my developer makes your storage file."
    return nil
  elsif cmd.downcase=='help' || ((cmd.nil? || cmd.length.zero?) && (args.nil? || args.length.zero?))
    subcommand=nil
    subcommand=args[0] unless args.nil? || args.length.zero?
    subcommand='' if subcommand.nil?
    if ['create'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __\*stats__","Allows me to create a new donor unit with the character `unit` and stats described in `stats`.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['promote','rarity','feathers'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __number__","Causes me to promote the donor unit with the name `unit`.\n\nIf `number` is defined, I will promote the donor unit that many times.\nIf not, I will promote them once.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['remove','delete','send_home','sendhome','fodder'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__","Removes a unit from the donor units attached to the invoker.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['merge','combine'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __number__","Causes me to merge the donor unit with the name `unit`.\n\nIf `number` is defined, I will merge the donor unit that many times.\nIf not, I will merge them once.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['nature','ivs'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __\*effects__","Causes me to change the nature of the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['equip','skill'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __\*skill name__","Equips the skill `skill name` on the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['seal'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __\*skill name__","Equips the skill seal `skill name` on the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['refine','refinery','refinement'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __\*refinement__","Refines the weapon equipped by the donor unit with the name `unit`, using the refinement `refinement`\n\nIf no refinement is defined and the equipped weapon has an Effect Mode, defaults to that.\nOtherwise, throws an error message if no refinement is defined.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['support','marry'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__","Causes me to change the support rank of the donor unit with the name `unit`.  If the donor unit has no rank, will wipe the other donor unit that has support.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    else
      create_embed(event,"**edit** __subcommand__ __unit__ __\*effects__","Allows me to create and edit the donor units.\n\nAvailable subcommands include:\n`FEH!edit create` - creates a new donor unit\n`FEH!edit promote` - promotes an existing donor unit (*also `rarity` and `feathers`*)\n`FEH!edit merge` - increases a donor unit's merge count (*also `combine`*)\n`FEH!edit nature` - changes a donor unit's nature (*also `ivs`*)\n`FEH!edit support` - causes me to change support ranks of donor units (*also `marry`*)\n\n`FEH!edit equip` - equip skill (*also `skill`*)\n`FEH!edit seal` - equip seal\n`FEH!edit refine` - refine weapon\n\n`FEH!edit send_home` - removes the unit from the donor units attached to the invoker (*also `fodder` or `remove` or `delete`*)\n\n**This command is only able to be used by certain people**.",0x9E682C)
    end
    return nil
  end
  str=find_name_in_string(event)
  data_load()
  j=find_unit(str,event)
  if j<0
    event.respond 'There is no unit by that name.'
    return nil
  end
  donor_units=donor_unit_list(uid)
  j2=donor_units.find_index{|q| q[0]==@units[j][0]}
  if j2.nil?
    args=event.message.text.downcase.split(' ')
    if cmd.downcase=='create'
      jn=@units[find_unit(find_name_in_string(event),event)][0]
      sklz2=unit_skills(jn,event,true)
      flurp=find_stats_in_string(event)
      donor_units=donor_unit_list(uid)
      donor_units.push([jn,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5],' '])
      donor_unit_save(uid,donor_units)
      event.respond "You have added a #{flurp[0]}#{@rarity_stars[flurp[0]-1]}#{"+#{flurp[1]}" if flurp[0]>0} #{jn} to your collection."
    elsif ['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase
      event.respond 'You never had that unit in the first place.'
      return nil
    else
      @stored_event=event
      event.respond "You do not have this unit.  Do you wish to add them to your collection?\nYes/No"
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          jn=@units[find_unit(find_name_in_string(@stored_event),@stored_event)][0]
          sklz2=unit_skills(jn,@stored_event,true)
          flurp=find_stats_in_string(e)
          donor_units=donor_unit_list(uid)
          donor_units.push([jn,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5],' '])
          donor_unit_save(uid,donor_units)
          event.respond "You have added a #{flurp[0]}#{@rarity_stars[flurp[0]-1]}#{"+#{flurp[1]}" if flurp[0]>0} #{jn} to your collection."
        end
      end
    end
  elsif ['support','marry'].include?(cmd.downcase)
    donor_units=donor_unit_list(uid)
    if donor_units[j2][5]=='S'
      event.respond "You've already married #{donor_units[j2][0]}."
    elsif donor_units[j2][5]=='A'
      donor_units[j2][5]='S'
      donor_unit_save(uid,donor_units)
      event.respond "You've married #{donor_units[j2][0]}!  (Support rank #{donor_units[j2][5]})"
    elsif donor_units[j2][5]=='B'
      donor_units[j2][5]='A'
      donor_unit_save(uid,donor_units)
      event.respond "You've proposed to #{donor_units[j2][0]}!  (Support rank #{donor_units[j2][5]})"
    elsif donor_units[j2][5]=='C'
      donor_units[j2][5]='B'
      donor_unit_save(uid,donor_units)
      event.respond "You've started dating #{donor_units[j2][0]}!  (Support rank #{donor_units[j2][5]})"
    elsif donor_units[j2][5]=='-'
      d=''
      for i in 0...donor_units.length
        d="#{donor_units[i][0]}" unless donor_units[i][5]=='-'
        donor_units[i][5]='-'
      end
      donor_units[j2][5]='C'
      donor_unit_save(uid,donor_units)
      event.respond "You've #{"divorced #{d} and " unless d==''}befriended #{donor_units[j2][0]}!  (Support rank #{donor_units[j2][5]})"
    end
  elsif ['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase
    @stored_event=event
    event.respond "I have a unit stored for your #{donor_units[j2][0]}.  Do you wish me to delete this build?\nYes/No"
    event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
      if e.message.text.downcase.include?('no')
        e.respond 'Okay.'
      else
        jn=@units[find_unit(find_name_in_string(@stored_event),@stored_event)][0]
        donor_units=donor_unit_list(uid)
        donor_units=donor_units.reject{|q| q[0]==jn}
        donor_unit_save(uid,donor_units)
        e.respond "#{jn} has been removed from your collection."
      end
    end
  elsif ['refine','refinement','refinery'].include?(cmd.downcase)
    jn=@units[find_unit(find_name_in_string(event),event)][0]
    sklzz=@skills.map{|q| q}
    m=donor_units[j2][6]
    m.pop if m[m.length-1].include?(' (+) ')
    w=sklzz[sklzz.index{|q| q[0]==m[m.length-1]}]
    if w[15].nil?
      event.respond "#{m[m.length-1]} cannot be refined."
      return nil
    end
    inner_skill=w[15]
    if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
      inner_skill=inner_skill[1,inner_skill.length-1]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
    elsif inner_skill[0,1]=='-' && inner_skill.length>1
      inner_skill=inner_skill[2,inner_skill.length-2]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
    end
    for i in 0...5
      if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
        inner_skill=inner_skill[1,inner_skill.length-1]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      elsif inner_skill[0,1]=='-' && inner_skill.length>1
        inner_skill=inner_skill[2,inner_skill.length-2]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      end
    end
    overides=['e','a','s','d','r']
    overides=['e','w','d'] if w[5]=='Staff Users Only'
    for i in 0...overides.length
      if inner_skill[0,3]=="(#{overides[i]})"
        inner_skill=inner_skill[3,inner_skill.length-3]
        for i2 in 0...6
          if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
            inner_skill=inner_skill[1,inner_skill.length-1]
            inner_skill='y' if inner_skill.nil? || inner_skill.length<1
          elsif inner_skill[0,1]=='-' && inner_skill.length>1
            inner_skill=inner_skill[2,inner_skill.length-2]
            inner_skill='y' if inner_skill.nil? || inner_skill.length<1
          end
        end
      end
    end
    words=[]
    words.push('Effect') unless inner_skill=='y'
    if w[5]=='Staff Users Only'
      words.push('Wrathful') unless w[7].include?("This weapon's damage is calculated the same as other weapons.") || w[7].include?('Damage from staff calculated like other weapons.')
      words.push('Dazzling') unless w[7].include?('The foe cannot counterattack.') || w[7].include?('Foe cannot counterattack.')
    else
      words.push('Attack')
      words.push('Speed')
      words.push('Defense')
      words.push('Resistance')
    end
    refine=''
    for i in 0...args.length
      if refine.length.zero?
        refine='Effect' if ['effect','special','eff','+effect','+special','+eff'].include?(args[i].downcase) && words.include?('Effect')
        refine='Wrathful' if ['wrazzle','wrathful','+wrazzle','+wrathful','=w'].include?(args[i].downcase) && words.include?('Wrathful')
        refine='Dazzling' if ['dazzle','dazzling','+dazzle','+dazzling','+d'].include?(args[i].downcase) && words.include?('Dazzling')
        refine='Attack' if ['attack','atk','att','strength','str','magic','mag','+attack','+atk','+att','+strength','+str','+magic','+mag'].include?(args[i].downcase) && words.include?('Attack')
        refine='Speed' if ['spd','speed','+spd','+speed'].include?(args[i].downcase) && words.include?('Speed')
        refine='Defense' if ['defense','def','defence','+defense','+def','+defence'].include?(args[i].downcase) && words.include?('Defense')
        refine='Resistance' if ['res','resistance','+res','+resistance'].include?(args[i].downcase) && words.include?('Resistance')
      end
    end
    refine='Effect' if refine.length.zero? && words.include?('Effect')
    refine=words[0] if refine.length.zero? && words.length==1
    if refine.length.zero?
      event.respond "No refinement was defined.  Your options are:\n#{words.join("\n")}"
      return nil
    end
    m.push("#{m[m.length-1]} (+) #{refine} Mode")
    donor_units[j2][6]=m
    donor_unit_save(uid,donor_units)
    event.respond "Your #{donor_units[j2][0]}'s #{m[m.length-2]} has been given the #{refine} Mode refinement!"
  elsif ['seal'].include?(cmd.downcase)
    jn=@units[find_unit(find_name_in_string(event),event)][0]
    sklzz=@skills.map{|q| q}
    k222=find_name_in_string(event,nil,1)
    k2=get_weapon(first_sub(args.join(' '),k222[1],''),event,1)
    unless k2[0][k2[0].length-1,1]!=k2[0][k2[0].length-1,1].to_i.to_s || k2[1][k2[1].length-1,1]==k2[1][k2[1].length-1,1].to_i.to_s
      skls=sklzz.reject{|q| q[0][0,q[0].length-1]!=k2[0][0,k2[0].length-1]}.map{|q| q[0]}.sort!
      k2[0]=skls[-1]
    end
    js=sklzz.find_index{|q| q[0]==k2[0]}
    if !sklzz[js][4].split(', ').include?('Passive(S)') && !sklzz[js][4].split(', ').include?('Seal')
      event.respond "#{sklzz[js][0]} cannot be equipped in the Seal slot.  Please use the `FEH!edit equip` command to equip this skill."
      return nil
    elsif !skill_legality(event,donor_units[j2][0],sklzz[js][0])
      event.respond "#{donor_units[j2][0]} cannot equip the #{sklzz[js][0]} seal."
      return nil
    end
    donor_units[j2][12]=sklzz[js][0]
    donor_unit_save(uid,donor_units)
    event.respond "The #{sklzz[js][0]} seal has been given to your #{donor_units[j2][0]}!"
  elsif ['equip','skill'].include?(cmd.downcase)
    jn=@units[find_unit(find_name_in_string(event),event)][0]
    k222=find_name_in_string(event,nil,1)
    sklzz=@skills.map{|q| q}
    k2=get_weapon(first_sub(args.join(' '),k222[1],''),event,1)
    unless k2[0][k2[0].length-1,1]!=k2[0][k2[0].length-1,1].to_i.to_s || k2[1][k2[1].length-1,1]==k2[1][k2[1].length-1,1].to_i.to_s
      skls=sklzz.reject{|q| q[0][0,q[0].length-1]!=k2[0][0,k2[0].length-1]}.map{|q| q[0]}.sort!
      k2[0]=skls[-1]
    end
    js=sklzz.find_index{|q| q[0]==k2[0]}
    x=backwards_skill_tree(js)
    m=0
    if sklzz[js][4]!='Weapon' && !skill_legality(event,donor_units[j2][0],sklzz[js][0])
      event.respond "#{donor_units[j2][0]} cannot equip #{sklzz[js][0]}."
      return nil
    end
    if sklzz[js][4]=='Weapon'
      w=weapon_legality(event,donor_units[j2][0],sklzz[js][0])
      if w.include?('~~')
        event.respond "#{donor_units[j2][0]} cannot equip #{sklzz[js][0]}."
        return nil
      end
      js=sklzz.find_index{|q| q[0]==w}
      m=6
    elsif sklzz[js][4]=='Assist'
      m=7
    elsif sklzz[js][4]=='Special'
      m=8
    elsif sklzz[js][4].split(', ').include?('Passive(A)')
      m=9
    elsif sklzz[js][4].split(', ').include?('Passive(B)')
      m=10
    elsif sklzz[js][4].split(', ').include?('Passive(C)')
      m=11
    else
      event.respond "#{sklzz[js][0]} cannot be equipped.#{"\nUse the `FEH!edit seal` command to equip a seal." if sklzz[js][4].split(', ').include?('Passive(S)') || sklzz[js][4].split(', ').include?('Seal')}"
      return nil
    end
    x=backwards_skill_tree(js, nil, donor_units[j2][m])
    donor_units[j2][m]=x[0].map{|q| q}
    donor_unit_save(uid,donor_units)
    dispstr=''
    unless x[1].nil?
      dispstr="#{x[1]} has been used as the base because your #{donor_units[j2][0]} already knows it."
      dispstr="#{donor_units[j2][0]} doesn't officially know any of the prerequisites so I marked it as \"Unknown base\"." if dispstr.include?('~~')
    end
    event.respond "#{sklzz[js][0]} has been given to your #{donor_units[j2][0]}!#{"\n#{dispstr}" unless dispstr.length.zero?}#{"\nPlease use the `FEH!edit refine` command to refine the weapon." if sklzz[js][4]=='Weapon'}"
  elsif cmd.downcase=='create'
    event.respond "You already have a #{donor_units[j2][0]}."
    return nil
  elsif ['promote','rarity','feathers'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    donor_units[j2][1]=flurp[0] unless flurp[0].nil?
    donor_units[j2][1]+=1 if flurp[0].nil?
    donor_units[j2][1]=[donor_units[j2][1],5].min
    donor_units[j2][2]=0
    donor_unit_save(uid,donor_units)
    event.respond "You have promoted your #{donor_units[j2][0]} to #{donor_units[j2][1]}#{@rarity_stars[donor_units[j2][1]-1]}!"
  elsif ['merge','combine'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    donor_units[j2][2]+=flurp[1] unless flurp[1].nil?
    donor_units[j2][2]+=1 if flurp[1].nil?
    donor_units[j2][2]=[donor_units[j2][2],@max_rarity_merge[1]].min
    donor_unit_save(uid,donor_units)
    event.respond "You have merged your #{donor_units[j2][0]} to +#{donor_units[j2][2]}!"
  elsif ['nature','ivs'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    n=''
    if flurp[2].nil? && flurp[3].nil?
      donor_units[j2][3]=' '
      donor_units[j2][4]=' '
      donor_unit_save(uid,donor_units)
      event.respond "You have changed your #{donor_units[j2][0]}'s nature to neutral!"
    elsif flurp[2].nil? || flurp[3].nil?
      @stored_event=event
      event.respond "You cannot have a boon without a bane.  Set stats to neutral?\nYes/No" if flurp[3].nil?
      event.respond "You cannot have a bane without a boon.  Set stats to neutral?\nYes/No" if flurp[2].nil?
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          j2=@units[find_unit(find_name_in_string(@stored_event),@stored_event)][0]
          j2=donor_units.find_index{|q| q[0]==@units[j2][0]}
          donor_units[j2][3]=' '
          donor_units[j2][4]=' '
          donor_unit_save(uid,donor_units)
          event.respond "You have changed your #{donor_units[j2][0]}'s nature to neutral!"
        end
      end
    else
      donor_units[j2][3]=flurp[2]
      donor_units[j2][4]=flurp[3]
      atk='Attack'
      atk='Magic' if ['Tome','Dragon','Healer'].include?(@units[j][1][1])
      atk='Strength' if ['Blade','Bow','Dagger'].include?(@units[j][1][1])
      n=nature_name(flurp[2],flurp[3])
      unless n.nil?
        n=n[0] if atk=='Strength'
        n=n[n.length-1] if atk=='Magic'
        n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
      end
      donor_unit_save(uid,donor_units)
      event.respond "You have changed your #{donor_units[j2][0]}'s nature to +#{flurp[2]}, -#{flurp[3]} (#{n})!"
    end
  else
    event.respond 'Edit mode was not specified.'
  end
  return nil
end

def backwards_skill_tree(j, sklz=nil, table=nil)
  if sklz.nil?
    data_load()
    sklz=@skills.map{|q| q}
  end
  s=sklz[j]
  if s[8]=='-'
    return [[s[0]]]
  elsif s[8].gsub(',','').include?("* or *")
    m=s[8].gsub('*, *','* or *').split('* or *').map{|q| q.gsub('*','')}
    unless table.nil?
      for i in 0...m.length
        if table.include?(m[i])
          j2=sklz.find_index{|q| q[0]==m[i]}
          p2=backwards_skill_tree(j2, sklz, table)
          p2[0].push(s[0])
          return [p2[0],m[i]]
        end
      end
    end
    return [['~~Unknown base~~',s[0]],'~~Unknown base~~']
  else
    j2=sklz.find_index{|q| q[0]==s[8].gsub('*','')}
    p2=backwards_skill_tree(j2, sklz)
    p2[0].push(s[0])
    return p2
  end
end

bot.command([:addmultialias,:adddualalias,:addualalias,:addmultiunitalias,:adddualunitalias,:addualunitalias,:multialias,:dualalias,:addmulti], from: 167657750971547648) do |event, multi, *args|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  if args.nil? || args.length.zero?
    event.respond 'No units were included.'
    return nil
  elsif multi.nil? || multi.length<=0
    event.respond 'No name was included.'
    return nil
  end
  data_load()
  nicknames_load()
  for i in 0...args.length
    if !detect_multi_unit_alias(event,args[i].downcase,args[i].downcase,3).nil?
      args[i]=detect_multi_unit_alias(event,args[i].downcase,args[i].downcase,3)[1].join(' ')
    elsif find_unit(args[i].downcase,event)<0
      args[i]=nil
    else
      args[i]=@units[find_unit(args[i].downcase,event)][0]
    end
  end
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  args=args.compact.join(' ').split(' ')
  if !detect_multi_unit_alias(event,multi.downcase,multi.downcase,3).nil?
    j=-1
    for i in 0...@multi_aliases.length
      j=i if @multi_aliases[i][0].downcase==multi.downcase && j<0
    end
    if j<0
      @multi_aliases.push([multi,args])
      event.respond "A new multi-unit alias **#{multi}** has been created with the members #{args.map{|q| q.gsub('Lavatain','Laevatein')}.join(', ')}"
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Multi-unit alias:** #{multi}\n**Units included:** #{args.join(', ')}")
    elsif args.reject{|q| @multi_aliases[j][1].include?(q)}.length<=0
      event.respond "#{list_lift(args,"and")} #{['','is','are both','are all'][[args.length,3].min]} already included in that multi-unit alias."
      return nil
    else
      for i in 0...args.length
        @multi_aliases[j][1].push(args[i]) unless @multi_aliases[j][1].include?(args[i])
      end
      event.respond "The existing multi-unit alias **#{multi}** was updated to include the members #{args.map{|q| q.gsub('Lavatain','Laevatein')}.join(', ')}"
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Multi-unit alias:** #{multi}\n**Units added:** #{args.join(', ')}")
    end
  else
    if args.length<=1
      event.respond "There is only one unit listed.  You may want to instead use a global alias."
      return nil
    end
    @multi_aliases.push([multi,args])
    event.respond "A new multi-unit alias **#{multi}** has been created with the members #{args.join(', ')}"
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Multi-unit alias:** #{multi}\n**Units included:** #{args.join(', ')}")
  end
  @multi_aliases.uniq!
  @multi_aliases.sort! {|a,b| (a[1].map{|q| q.downcase} <=> b[1].map{|q| q.downcase}) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].map{|q| q.downcase} <=> b[1].map{|q| q.downcase})}
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHMultiNames.txt', 'w') { |f|
    for i in 0...@multi_aliases.length
      f.puts "#{@multi_aliases[i].to_s}#{"\n" if i<@multi_aliases.length-1}"
    end
  }
  bot.channel(logchn).send_message("Multi-unit alias list saved.\n\nNo backup needed.")
end

bot.command([:deletemultialias,:deletedualalias,:deletemultiunitalias,:deletedualunitalias,:deletemulti,:removemultialias,:removedualalias,:removemultiunitalias,:removedualunitalias,:removemulti], from: 167657750971547648) do |event, multi|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  if multi.nil? || multi.length<=0
    event.respond 'No name was included.'
    return nil
  end
  nicknames_load()
  for i in 0...@multi_aliases.length
    @multi_aliases[i]=nil if @multi_aliases[i][0].downcase==multi.downcase
  end
  event.respond "The multi-unit alias **#{multi}** was deleted."
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**Multi-unit alias:** #{multi}~~\n**DELETED**")
  @multi_aliases.uniq!
  @multi_aliases.sort! {|a,b| (a[1].map{|q| q.downcase} <=> b[1].map{|q| q.downcase}) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].map{|q| q.downcase} <=> b[1].map{|q| q.downcase})}
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHMultiNames.txt', 'w') { |f|
    for i in 0...@multi_aliases.length
      f.puts "#{@multi_aliases[i].to_s}#{"\n" if i<@multi_aliases.length-1}"
    end
  }
  bot.channel(logchn).send_message("Multi-unit alias list saved.\n\nNo backup needed.")
end

bot.command([:removefrommultialias,:removefromdualalias,:removefrommultiunitalias,:removefromdualunitalias,:removefrommulti], from: 167657750971547648) do |event, multi, unit|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  if args.nil? || args.length.zero?
    event.respond 'No units were included.'
    return nil
  elsif multi.nil? || multi.length<=0
    event.respond 'No name was included.'
    return nil
  end
  nicknames_load()
  j=-1
  for i in 0...@multi_aliases.length
    j=i if @multi_aliases[i][0].downcase==multi.downcase && j<0
  end
  if j<0
    event.respond "#{multi} is not a multi-unit alias."
    return nil
  end
  i=find_unit(unit.downcase,event)
  r=false
  for k in 0...@multi_aliases[j][1].length
    if @multi_aliases[j][1][k].downcase==@units[i][0].downcase
      @multi_aliases[j][1][k]=nil
      r=true
    end
  end
  @multi_aliases[j][1].compact!
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  if r
    event << "#{@units[i][0].gsub('Lavatain','Laevatein')} has been removed from the multi-unit alias #{@multi_aliases[j][0]}"
    if @multi_aliases[j][1].length==1
      event << "The multi-unit alias #{@multi_aliases[j][0]} now has one member, so I'm deleting it.\nIt may be a good idea to turn it into a global [single-unit] alias."
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**Multi-unit alias:** #{@multi_aliases[j][0]}~~\n**DELETED**")
      @multi_aliases[j]=nil
      @multi_aliases.compact!
    else
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Multi_unit aliase:** #{@multi_aliases[j][0]}\n**Units removed:** #{@units[i][0]}")
    end
    @multi_aliases.uniq!
    @multi_aliases.sort! {|a,b| (a[1].map{|q| q.downcase} <=> b[1].map{|q| q.downcase}) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].map{|q| q.downcase} <=> b[1].map{|q| q.downcase})}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHMultiNames.txt', 'w') { |f|
      for i in 0...@multi_aliases.length
        f.puts "#{@multi_aliases[i].to_s}#{"\n" if i<@multi_aliases.length-1}"
      end
    }
    bot.channel(logchn).send_message("Multi-unit alias list saved.\n\nNo backup needed.")
  else
    event << "#{@units[i][0]} wasn't even in the multi-unit alias #{@multi_aliases[j][0]}, silly!"
  end
  return nil
end

bot.command(:sendpm, from: 167657750971547648) do |event, user_id, *args| # sends a PM to a specific user
  return nil if overlap_prevent(event)
  dev_pm(bot,event,user_id)
end

bot.command(:ignoreuser, from: 167657750971547648) do |event, user_id| # causes Elise to ignore the specified user
  return nil if overlap_prevent(event)
  bliss_mode(bot,event,user_id)
end

bot.command(:sendmessage, from: 167657750971547648) do |event, channel_id, *args| # sends a message to a specific channel
  return nil if overlap_prevent(event)
  dev_message(bot,event,channel_id)
end

bot.command(:leaveserver, from: 167657750971547648) do |event, server_id| # forces Elise to leave a server
  return nil if overlap_prevent(event)
  walk_away(bot,event,server_id)
end

bot.command(:cleanupaliases, from: 167657750971547648) do |event|
  return nil if overlap_prevent(event)
  event.channel.send_temporary_message('Please wait...',10)
  if @shardizard==4
    event.respond 'This command cannot be used by the debug version of me.  Please run this command in another server.'
    return nil
  end
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  nicknames_load()
  nmz=@aliases.map{|q| q}
  k=0
  for i in 0...nmz.length
    unless nmz[i][3].nil?
      for i2 in 0...nmz[i][3].length
        unless nmz[i][3][i2]==285663217261477889
          srv=(bot.server(nmz[i][3][i2]) rescue nil)
          if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
            k+=1
            nmz[i][3][i2]=nil
          end
        end
      end
      nmz[i][3].compact!
      nmz[i]=nil if nmz[i][3].length<=0
    end
  end
  nmz.compact!
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...nmz.length
      f.puts "#{nmz[i].to_s}#{"\n" if i<nmz.length-1}"
    end
  }
  event.respond "#{k} aliases were removed due to being from servers I'm no longer in."
end

bot.command(:backup, from: 167657750971547648) do |event, trigger|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 || event.channel.id==386658080257212417
  if trigger.nil?
    event.respond 'Backup what?'
  elsif ['aliases','alias'].include?(trigger.downcase)
    nicknames_load()
    @aliases.uniq!
    @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? ((a[2].downcase <=> b[2].downcase) == 0 ? (a[1].downcase <=> b[1].downcase) : (a[2].downcase <=> b[2].downcase)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    zunits=@aliases.reject{|q| q[0]!='Unit'}
    zskills=@aliases.reject{|q| q[0]!='Skill'}
    zstructs=@aliases.reject{|q| q[0]!='Structure'}
    if zunits[zunits.length-1].length<=1 || zunits[zunits.length-1][2]<'Zephiel' || zskills[zskills.length-1].length<=1 || zskills[zskills.length-1][2]<'Yato' || zstructs[zstructs.length-1].length<=1 || zstructs[zstructs.length-1][2]<'Armor School'
      event.respond 'Alias list has __***NOT***__ been backed up, as alias list has been corrupted.'
      return nil
    end
    nzzzzz=@aliases.map{|a| a}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event.respond 'Alias list has been backed up.'
  elsif ['groups','group'].include?(trigger.downcase)
    groups_load()
    nzzzzz=@groups.map{|a| a}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups2.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event.respond 'Groups list has been backed up.'
  else
    event.respond 'Backup what?'
  end
  return nil
end

bot.command([:devedit, :dev_edit], from: 167657750971547648) do |event, cmd, *args|
  return nil if overlap_prevent(event)
  if File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{event.user.id}.txt")
    event.respond "This command is to allow the developer to edit his units.  Your version of the command is `FEH!edit`"
  end
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  str=find_name_in_string(event)
  data_load()
  j=find_unit(str,event)
  if j<0
    event.respond 'There is no unit by that name.'
    return nil
  end
  if ['newwaifu','newaifu','addwaifu','new_waifu','add_waifu','waifu'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && args[0].downcase=='waifu')
    if @dev_waifus.include?(@units[j][0])
      event.respond "#{@units[j][0]} is already listed among your waifus."
    else
      @dev_waifus.push(@units[j][0])
      rfs=false
      ren=false
      for i in 0...@dev_somebodies.length
        if @dev_somebodies[i]==@units[j][0]
          rfs=true
          @dev_somebodies[i]=nil
        end
      end
      @dev_somebodies.compact!
      for i in 0...@dev_nobodies.length
        if @dev_nobodies[i]==@units[j][0]
          rfn=true
          @dev_nobodies[i]=nil
        end
      end
      @dev_nobodies.compact!
      devunits_save()
      event.respond "#{@units[j][0]} has been added to the list of your waifus.#{"\nI have also taken the liberty of removing #{@units[j][0]} from your #{"\"somebodies\"" if rfs}#{" and " if rfs && rfn}#{'"nobodies"' if rfn} list#{'s' if rfs && rfn}." if rfs || rfn}"
    end
    return nil
  elsif ['newsomebody','newsomeone','newsomebodies','addsomebody','addsomeone','addsomebodies','new_somebody','new_someone','new_somebodies','add_somebody','add_someone','add_somebodies','somebody','somebodies','someone'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && ['somebody','somebodies','someone'].include?(args[0].downcase))
    if @dev_waifus.include?(@units[j][0])
      event.respond "#{@units[j][0]} is already listed among your waifus."
    elsif @dev_somebodies.include?(@units[j][0])
      event.respond "#{@units[j][0]} is already listed among your \"somebodies\" list."
    else
      @dev_somebodies.push(@units[j][0])
      ren=false
      for i in 0...@dev_nobodies.length
        if @dev_nobodies[i]==@units[j][0]
          rfn=true
          @dev_nobodies[i]=nil
        end
      end
      @dev_nobodies.compact!
      devunits_save()
      event.respond "#{@units[j][0]} has been added to your \"somebodies\" list.#{"\nI have also taken the liberty of removing #{@units[j][0]} from your \"nobodies\" list." if rfn}"
    end
    return nil
  elsif ['newnobody','newnoone','newnobodies','addnobody','addnoone','addnobodies','new_nobody','new_noone','new_nobodies','add_nobody','add_noone','add_nobodies','nobody','nobodies','noone'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && ['nobody','nobodies','noone'].include?(args[0].downcase))
    if @dev_waifus.include?(@units[j][0])
      event.respond "#{@units[j][0]} is already listed among your waifus."
    elsif @dev_somebodies.include?(@units[j][0])
      event.respond "#{@units[j][0]} is already listed among your \"somebodies\" list."
    elsif @dev_nobodies.include?(@units[j][0])
      event.respond "#{@units[j][0]} is already listed among your \"nobodies\" list."
    else
      @dev_nobodies.push(@units[j][0])
      devunits_save()
      event.respond "#{@units[j][0]} has been added to your \"nobodies\" list."
    end
    return nil
  end
  j2=find_in_dev_units(@units[j][0])
  if j2<0
    args=event.message.text.downcase.split(' ')
    if cmd.downcase=='create'
      jn=@units[find_unit(find_name_in_string(event),event)][0]
      sklz2=unit_skills(jn,event,true)
      flurp=find_stats_in_string(event)
      @dev_units.push([jn,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5],' '])
      for i in 0...@dev_nobodies.length
        @dev_nobodies[i]=nil if @dev_nobodies[i]==jn
      end
      @dev_nobodies.compact!
      devunits_save()
      congrate=false
      congrats=true if @dev_waifus.include?(jn) || @dev_somebodies.include?(jn)
      event.respond "You have added a #{flurp[0]}#{@rarity_stars[flurp[0]-1]}#{"+#{flurp[1]}" if flurp[0]>0} #{jn} to your collection.  #{'Congrats!' if congrats}"
    elsif ['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase
      if @dev_waifus.include?(@units[j][0])
        event.respond "Woah, you're getting rid of one of your waifus?!?  Who hacked your Discord and/or FEH account?"
      elsif @dev_somebodies.include?(@units[j][0])
        @stored_event=event
        event.respond "You're getting rid of one of your somebodies?  Should I remove them from the \"somebodies\" list?"
        event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
          if e.message.text.downcase.include?('no')
            e.respond 'Okay.'
          else
            jn=@units[find_unit(find_name_in_string(@stored_event),@stored_event)][0]
            for i in 0...@dev_somebodies.length
              @dev_somebodies[i]=nil if @dev_somebodies[i]==jn
            end
            @dev_somebodies.compact!
            devunits_save()
            e.respond "#{jn} has been removed from your \"somebodies\" list."
          end
        end
      elsif @dev_nobodies.include?(@units[j][0])
        for i in 0...@dev_nobodies.length
          @dev_nobodies[i]=nil if @dev_nobodies[i]==@units[j][0]
        end
        @dev_nobodies.compact!
        devunits_save()
        e.respond "#{@units[j][0]} has been removed from your \"nobodies\" list."
      else
        event.respond 'You never had that unit in the first place.'
      end
      return nil
    else
      @stored_event=event
      event.respond 'You do not have this unit.  Do you wish to add them to your collection?' unless @dev_nobodies.include?(@units[j][0])
      event.respond "You Have this unit but previously stated you don't want to input their data.  Do you wish to add them to your collection?" if @dev_nobodies.include?(@units[j][0])
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          jn=@units[find_unit(find_name_in_string(@stored_event),@stored_event)][0]
          sklz2=unit_skills(jn,@stored_event,true)
          flurp=find_stats_in_string(e)
          @dev_units.push([jn,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5]])
          for i in 0...@dev_nobodies.length
            @dev_nobodies[i]=nil if @dev_nobodies[i]==jn
          end
          @dev_nobodies.compact!
          devunits_save()
          congrate=false
          congrats=true if @dev_waifus.include?(jn) || @dev_somebodies.include?(jn)
          e.respond "You have added a #{flurp[0]}#{@rarity_stars[flurp[0]-1]}#{"+#{flurp[1]}" if flurp[0]>0} #{jn} to your collection.  #{"Congrats!" if congrats}"
        end
      end
    end
  elsif ['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase
    @stored_event=event
    event.respond "I have a devunit stored for #{@dev_units[j2][0]}.  Do you wish me to delete this build?"
    event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
      if e.message.text.downcase.include?('no')
        e.respond 'Okay.'
      else
        jn=@units[find_unit(find_name_in_string(@stored_event),@stored_event)][0]
        @dev_units[find_in_dev_units(jn)]=nil
        @dev_units.compact!
        devunits_save()
        e.respond "#{jn} has been removed from the devunits."
      end
    end
  elsif cmd.downcase=='create'
    event.respond "You already have a #{@dev_units[j2][0]}."
    return nil
  elsif ['promote','rarity','feathers'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    @dev_units[j2][1]=flurp[0] unless flurp[0].nil?
    @dev_units[j2][1]+=1 if flurp[0].nil?
    @dev_units[j2][1]=[@dev_units[j2][1],5].min
    @dev_units[j2][2]=0
    devunits_save()
    event.respond "You have promoted your #{@dev_units[j2][0]} to #{@dev_units[j2][1]}#{@rarity_stars[@dev_units[j2][1]-1]}!"
  elsif ['merge','combine'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    @dev_units[j2][2]+=flurp[1] unless flurp[1].nil?
    @dev_units[j2][2]+=1 if flurp[1].nil?
    @dev_units[j2][2]=[@dev_units[j2][2],@max_rarity_merge[1]].min
    devunits_save()
    event.respond "You have merged your #{@dev_units[j2][0]} to +#{@dev_units[j2][2]}!"
  elsif ['nature','ivs'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    n=''
    if flurp[2].nil? && flurp[3].nil?
      @dev_units[j2][3]=' '
      @dev_units[j2][4]=' '
      devunits_save()
      event.respond "You have changed your #{@dev_units[j2][0]}'s nature to neutral!"
    elsif flurp[2].nil? || flurp[3].nil?
      @stored_event=event
      event.respond 'You cannot have a boon without a bane.  Set stats to neutral?' if flurp[3].nil?
      event.respond 'You cannot have a bane without a boon.  Set stats to neutral?' if flurp[2].nil?
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          j2=find_in_dev_units(@units[find_unit(find_name_in_string(@stored_event),@stored_event)][0])
          @dev_units[j2][3]=' '
          @dev_units[j2][4]=' '
          devunits_save()
          event.respond "You have changed your #{@dev_units[j2][0]}'s nature to neutral!"
        end
      end
    else
      @dev_units[j2][3]=flurp[2]
      @dev_units[j2][4]=flurp[3]
      atk='Attack'
      atk='Magic' if ['Tome','Dragon','Healer'].include?(@units[j][1][1])
      atk='Strength' if ['Blade','Bow','Dagger'].include?(@units[j][1][1])
      n=nature_name(flurp[2],flurp[3])
      unless n.nil?
        n=n[0] if atk=='Strength'
        n=n[n.length-1] if atk=='Magic'
        n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
      end
      devunits_save()
      event.respond "You have changed your #{@dev_units[j2][0]}'s nature to +#{flurp[2]}, -#{flurp[3]} (#{n})!"
    end
  elsif ['learn','teach'].include?(cmd.downcase)
    skill_types=[]
    for i in 0...args.length
      skill_types.push(6) if ['weapon','weapons'].include?(args[i].downcase)
      skill_types.push(7) if ['assist','assists'].include?(args[i].downcase)
      skill_types.push(8) if ['special','specials'].include?(args[i].downcase)
      skill_types.push(9) if ['a','apassives','apassive','passivea','passivesa','a_passives','a_passive','passive_a','passives_a'].include?(args[i].downcase)
      skill_types.push(10) if ['b','bpassives','bpassive','passiveb','passivesb','b_passives','b_passive','passive_b','passives_b'].include?(args[i].downcase)
      skill_types.push(11) if ['c','cpassives','cpassive','passivec','passivesc','c_passives','c_passive','passive_c','passives_c'].include?(args[i].downcase)
      skill_types.push(12) if ['s','seal','seals','spassives','spassive','passives','passivess','s_passives','s_passive','passive_s','passives_s','sealpassives','sealpassive','passiveseal','passivesseal','seal_passives','seal_passive','passive_seal','passives_seal','sealspassives','sealspassive','passiveseals','passivesseals','seals_passives','seals_passive','passive_seals','passives_seals'].include?(args[i].downcase)
    end
    if skill_types.length<=0
      event.respond "Please include the type of skill your #{@dev_units[j2][0]} will be learning."
      return nil
    end
    s='that type'
    s='those types' if skill_types.uniq.length>1
    for i in 0...skill_types.length
      k=false
      for j in 0...@dev_units[j2][skill_types[i]].length
        if skill_types[i]==12
          seel=@dev_units[j2][skill_types[i]].scan(/\d+?/)[0].to_i
          seel=@dev_units[j2][skill_types[i]].gsub(seel.to_s,(seel+1).to_s)
          k=true if find_skill(seel,event,true)>=0
        else
          k=true if @dev_units[j2][skill_types[i]][j][0,2]=='~~' && @dev_units[j2][skill_types[i]][j]!='~~none~~'
        end
      end
      skill_types[i]=nil unless k
    end
    skill_types.compact!
    if skill_types.length<=0
      event.respond "Your #{@dev_units[j2][0]} has no unlearned skills of #{s}."
      return nil
    end
    skills_learned=[]
    for i in 0...skill_types.length
      k=true
      if skill_types[i]==12 # skill seals
        seel=@dev_units[j2][skill_types[i]].scan(/\d+?/)[0].to_i
        seel=@dev_units[j2][skill_types[i]].gsub(seel.to_s,(seel+1).to_s)
        if find_skill(seel,event,true)>=0
          @dev_units[j2][skill_types[i]]=seel
          skills_learned.push("#{@dev_units[j2][skill_types[i]]} (seal)")
        else
          skills_learned.push("#{@dev_units[j2][skill_types[i]]} (seal already maximized)")
        end
      else # other skills
        for j in 0...@dev_units[j2][skill_types[i]].length
          if @dev_units[j2][skill_types[i]][j][0,2]=='~~' && k
            k=false
            @dev_units[j2][skill_types[i]][j]=@dev_units[j2][skill_types[i]][j].gsub('~~','')
            skills_learned.push(@dev_units[j2][skill_types[i]][j])
          end
        end
      end
    end
    devunits_save()
    event.respond "__Your **#{@dev_units[j2][0]}** has learned the following skills__\n#{skills_learned.join("\n")}"
  else
    event.respond 'Edit mode was not specified.'
  end
  return nil
end

bot.command(:setmarker, from: 167657750971547648) do |event, letter|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  return nil if event.server.nil?
  return nil if letter.nil?
  letter=letter[0,1].upcase
  metadata_load()
  if letter=='X'
    @x_markers=[] if @x_markers.nil?
    if @x_markers.include?(event.server.id)
      event.respond 'This server can already see entries marked with X.'
      return nil
    end
    @x_markers.push(event.server.id)
  else
    for i in 0...@server_markers.length
      if @server_markers[i][0].downcase==letter.downcase
        event.respond "#{letter} is already another server's marker."
        return nil
      elsif @server_markers[i][1]==event.server.id
        event.respond "This server already has a marker: #{@server_markers[i][0]}"
        return nil
      end
    end
    @server_markers.push([letter, event.server.id])
  end
  metadata_save()
  event.respond "This server's marker has been set as #{letter}." unless letter=='X'
  event.respond "This server has been added to those that can see entries marked with #{letter}." if letter=='X'
end

bot.command(:snagstats) do |event, f, f2|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || @shardizard==4
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  snagstats(event,bot,f,f2)
  return nil
end

bot.command(:reload, from: 167657750971547648) do |event|
  return nil if overlap_prevent(event)
  return nil unless [167657750971547648].include?(event.user.id) || event.channel.id==386658080257212417
  bot.gateway.check_heartbeat_acks = false
  event.respond "Reload what?\n1.) Aliases, from backups\n2.) Groups, from backups#{"\n3.) Data, from GitHub\n4.) Libraries, from code" if event.user.id==167657750971547648}\nYou can include multiple numbers to load multiple things."
  event.channel.await(:bob, from: event.user.id) do |e|
    reload=false
    if e.message.text.include?('1')
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt').each_line do |line|
          b.push(eval line)
        end
      else
        b=[]
      end
      nzzzzz=b.uniq
      zunits=nzzzzz.reject{|q| q[0]!='Unit'}
      zskills=nzzzzz.reject{|q| q[0]!='Skill'}
      zstructs=nzzzzz.reject{|q| q[0]!='Structure'}
      if zunits[zunits.length-1].length<=1 || zunits[zunits.length-1][2]<'Zephiel' || zskills[zskills.length-1].length<=1 || zskills[zskills.length-1][2]<'Yato' || zstructs[zstructs.length-1].length<=1 || zstructs[zstructs.length-1][2]<'Armor School'
        event << 'Last backup of the alias list has been corrupted.  Restoring from manually-created backup.'
        if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames3.txt')
          b=[]
          File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames3.txt').each_line do |line|
            b.push(eval line)
          end
        else
          b=[]
        end
        nzzzzz=b.uniq
      else
        e << 'Last backup of the alias list being used.'
      end
      open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
        for i in 0...nzzzzz.length
          f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
        end
      }
      e << 'Alias list has been restored from backup.'
      reload=true
    end
    if e.message.text.include?('2')
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups2.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups2.txt').each_line do |line|
          b.push(eval line)
        end
      else
        b=[]
      end
      nzzzzz=b.uniq
      if nzzzzz.length<10
        e << 'Last backup of the group list has been corrupted.  Restoring from manually-created backup.'
        if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups3.txt')
          b=[]
          File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups3.txt').each_line do |line|
            b.push(eval line)
          end
        else
          b=[]
        end
        nzzzzz=b.uniq
      else
        e << 'Last backup of the group list being used.'
      end
      open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt', 'w') { |f|
        for i in 0...nzzzzz.length
          f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
        end
      }
      e << 'Group list has been restored from backup.'
      reload=true
    end
    if e.message.text.include?('3') && e.user.id==167657750971547648
      event.channel.send_temporary_message('Loading.  Please wait 5 seconds...',3)
      to_reload=['Units','Skills','Structures','StatSkills','SkillSubsets','EmblemTeams','Banners','Events','Games','ArenaTempest']
      for i in 0...to_reload.length
        download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEH#{to_reload[i]}.txt")
        IO.copy_stream(download, "FEHTemp.txt")
        if File.size("FEHTemp.txt")>100
          b=[]
          File.open("FEHTemp.txt").each_line.with_index do |line, idx|
            b.push(line)
          end
          open("FEH#{to_reload[i]}.txt", 'w') { |f|
            f.puts b.join('')
          }
        end
      end
      e.respond 'New data loaded.'
      reload=true
    end
    if e.message.text.include?('4') && e.user.id==167657750971547648
      puts 'reloading EliseMulti1'
      load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
      puts 'reloading EliseTexts'
      load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
      t=Time.now
      @last_multi_reload[0]=t
      @last_multi_reload[1]=t
      e.respond 'Libraries force-reloaded'
      reload=true
    end
    e.respond 'Nothing reloaded.  If you meant to use the command, please try it again.' unless reload
  end
  return nil
end

bot.server_create do |event|
  chn=event.server.general_channel
  if chn.nil?
    chnn=[]
    for i in 0...event.server.channels.length
      chnn.push(event.server.channels[i]) if bot.user(bot.profile.id).on(event.server.id).permission?(:send_messages,event.server.channels[i]) && event.server.channels[i].type.zero?
    end
    chn=chnn[0] if chnn.length>0
  end
  if ![285663217261477889,443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579].include?(event.server.id) && @shardizard==4
    (chn.send_message(get_debug_leave_message()) rescue nil)
    event.server.leave
  else
    bot.user(167657750971547648).pm("Joined server **#{event.server.name}** (#{event.server.id})\nOwner: #{event.server.owner.distinct} (#{event.server.owner.id})\nAssigned to use #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(event.server.id >> 22) % 4]} Shards")
    metadata_load()
    @server_data[0][((event.server.id >> 22) % 4)] += 1
    metadata_save()
    chn.send_message("<a:zeldawave:464974581434679296> I'm here to deliver the happiest of hellos - as well as data for heroes and skills in *Fire Emblem: Heroes*!  So, here I am!  Summon me with messages that start with `FEH!`.") rescue nil
  end
end

bot.server_delete do |event|
  unless @shardizard==4
    bot.user(167657750971547648).pm("Left server **#{event.server.name}**")
    metadata_load()
    @server_data[0][((event.server.id >> 22) % 4)] -= 1
    metadata_save()
  end
end

bot.message do |event|
  data_load()
  str=event.message.text.downcase
  if @shardizard==4 && (['fea!','fef!'].include?(str[0,4]) || ['fe13!','fe14!'].include?(str[0,5]) || ['fe!'].include?(str[0,3]))
    str=str[4,str.length-4] if ['fea!','fef!'].include?(str[0,4])
    str=str[5,str.length-5] if ['fe13!','fe14!'].include?(str[0,5])
    str=str[3,str.length-3] if ['fe!'].include?(str[0,3])
    a=str.split(' ')
    if a[0].downcase=='reboot'
      event.respond 'Becoming Robin.  Please wait approximately ten seconds...'
      exec 'cd C:/Users/Mini-Matt/Desktop/devkit && feindex.rb 4'
    elsif event.server.nil? || event.server.id==285663217261477889
      event.respond 'I am not Robin right now.  Please use `FE!reboot` to turn me into Robin.'
    end
  elsif (['fgo!','fgo?','liz!','liz?'].include?(str[0,4]) || ['fate!','fate?'].include?(str[0,5])) && @shardizard==4
    s=event.message.text.downcase
    s=s[5,s.length-5] if ['fate!','fate?'].include?(event.message.text.downcase[0,5])
    s=s[4,s.length-4] if ['fgo!','fgo?','liz!','liz?'].include?(event.message.text.downcase[0,4])
    a=s.split(' ')
    if a[0].downcase=='reboot'
      event.respond "Becoming Liz.  Please wait approximately ten seconds..."
      exec "cd C:/Users/Mini-Matt/Desktop/devkit && LizBot.rb 4"
    elsif event.server.nil? || event.server.id==285663217261477889
      event.respond "I am not Liz right now.  Please use `FGO!reboot` to turn me into Liz."
    end
  elsif ['dl!','dl?'].include?(str[0,3]) && @shardizard==4
    s=event.message.text.downcase
    s=s[3,s.length-3]
    a=s.split(' ')
    if a[0].downcase=='reboot'
      event.respond "Becoming Botan.  Please wait approximately ten seconds..."
      exec "cd C:/Users/Mini-Matt/Desktop/devkit && BotanBot.rb 4"
    elsif event.server.nil? || event.server.id==285663217261477889
      event.respond "I am not Botan right now.  Please use `DL!reboot` to turn me into Botan."
    end
  elsif overlap_prevent(event)
  elsif ['f?','e?','h?'].include?(event.message.text.downcase[0,2]) || ['feh!','feh?'].include?(event.message.text.downcase[0,4])
    puts event.message.text
    s=event.message.text.downcase
    s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
    s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
    s=s[1,s.length-1] if s[0,1]==' '
    s=s[2,s.length-2] if s[0,2]=='5*'
    a=s.split(' ')
    if s.gsub(' ','').downcase=='laevatein'
      disp_stats(bot,'Lavatain',nil,event,true,true)
      disp_skill(bot,'Bladeblade',event,true)
    elsif s.gsub(' ','').gsub('?','').gsub('!','').length<2
    elsif !all_commands(true).include?(a[0])
      str=find_name_in_string(event,nil,1)
      data_load()
      if find_skill(s,event,false,true)>=0
        disp_skill(bot,s,event,true)
      elsif find_structure_ex(s,event,true).length>0
        disp_struct(bot,s,event,true)
      elsif find_data_ex(:find_accessory,s,event,true)>=0
        disp_accessory(bot,s,event,true)
      elsif find_data_ex(:find_item_feh,s,event,true)>=0
        disp_itemu(bot,s,event,true)
      elsif str.nil?
        if find_skill(s,event)>=0
          disp_skill(bot,s,event,true)
        elsif find_structure_ex(s,event).length>0
          disp_struct(bot,s,event,true)
        elsif find_data_ex(:find_accessory,s,event)>=0
          disp_accessory(bot,s,event,true)
        elsif find_data_ex(:find_item_feh,s,event)>=0
          disp_itemu(bot,s,event,true)
        elsif !detect_multi_unit_alias(event,s.downcase,event.message.text.downcase).nil?
          x=detect_multi_unit_alias(event,s.downcase,event.message.text.downcase)
          event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
          k2=get_weapon(first_sub(s,x[0],''),event)
          w=nil
          w=k2[0] unless k2.nil?
          disp_stats(bot,x[1],w,event,true,true)
        elsif !detect_multi_unit_alias(event,s.downcase,s.downcase).nil?
          x=detect_multi_unit_alias(event,s.downcase,s.downcase)
          event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
          k2=get_weapon(first_sub(s,x[0],''),event)
          w=nil
          w=k2[0] unless k2.nil?
          disp_stats(bot,x[1],w,event,true,true)
        end
      elsif str[1].downcase=='ploy' && find_skill(stat_buffs(s,s),event)>=0
        disp_skill(bot,stat_buffs(s,s),event,true)
      elsif !detect_multi_unit_alias(event,str[0].downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,str[0].downcase,event.message.text.downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.nil?
        disp_stats(bot,x[1],w,event,true,true)
      elsif !detect_multi_unit_alias(event,str[0].downcase,str[0].downcase).nil?
        x=detect_multi_unit_alias(event,str[0].downcase,str[0].downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.nil?
        disp_stats(bot,x[1],w,event,true,true)
      elsif find_unit(str[0],event)>=0
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k=find_name_in_string(event,nil,1)
        if k.nil?
          str=nil
        else
          str=k[0]
          k2=get_weapon(first_sub(s,k[1],''),event)
          w=nil
          w=k2[0] unless k2.nil?
        end
        disp_stats(bot,str,w,event,event.server.nil?,true)
      elsif find_skill(s,event)>0
        disp_skill(bot,s,event,true)
      elsif find_structure_ex(s,event).length>0
        disp_struct(bot,s,event,true)
      elsif find_data_ex(:find_accessory,s,event)>=0
        disp_accessory(bot,s,event,true)
      elsif find_data_ex(:find_item_feh,s,event)>=0
        disp_itemu(bot,s,event,true)
      elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.nil?
        disp_stats(bot,x[1],w,event,true,true)
      end
    end
  elsif event.message.text.downcase.include?('owo') && !event.user.bot_account?
    s=event.message.text
    s=remove_format(s,'```')              # remove large code blocks
    s=remove_format(s,'`')                # remove small code blocks
    s=remove_format(s,'~~')               # remove crossed-out text
    s=s.gsub("\n",' ').gsub("  ",'')
    if s.split(' ').include?('owo') || s.split(' ').include?('OwO')
      k=0
      k=event.server.id unless event.server.nil?
      if k==271642342153388034
      elsif rand(1000)<13
        puts 'responded to OwO'
        event.respond "What's this?"
      else
        puts 'saw OwO, did not respond'
      end
    end
  elsif event.message.text.include?('0x4') && !event.user.bot_account?
    s=event.message.text
    s=remove_format(s,'```')              # remove large code blocks
    s=remove_format(s,'`')                # remove small code blocks
    s=remove_format(s,'~~')               # remove crossed-out text
    s=s.gsub("\n",' ').gsub("  ",'')
    if s.split(' ').include?('0x4')
      canpost=true
      k=0
      k=event.server.id unless event.server.nil?
      if k==271642342153388034
        post=Time.now
        if (post - @zero_by_four[0]).to_f > 3600*3
          @zero_by_four[0]=post
        else
          canpost=false
        end
      elsif event.channel.id==330850148261298176
      elsif canpost
        puts s
        event.respond "#{"#{event.user.mention} " unless event.server.nil?}#{["Be sure to use Galeforce for 0x8.  #{['','Pair it with a Breath skill to get 0x8 even faster.'].sample}",'Be sure to include Astra to increase damage by 150%.','Be sure to use a dancer for 0x8.',"Be sure to use Sol, so you can heal for half of that.  #{['','Peck, Ephraim(Fire) heals for 80% with his Solar Brace.','Pair it with a Breath skill to get even more healing!'].sample}","#{['Be sure to use Galeforce for 0x8.','Be sure to use a dancer for 0x8.'].sample}  Or combine a dancer and Galeforce for a whopping 0x12!"].sample}"
      end
    end
  end
end

bot.mention do |event|
  data_load()
  puts event.message.text
  s=event.message.text.downcase
  a=s.split(' ')
  a=a.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  s=a.join(' ')
  k=-1
  k=1 if event.user.bot_account?
  if k>0
  elsif ['f?','e?','h?'].include?(event.message.text.downcase[0,2]) || ['feh!','feh?'].include?(event.message.text.downcase[0,4])
    k=3
  elsif s.gsub(' ','').downcase=='laevatein'
    disp_stats(bot,'Lavatain',nil,event,true,true)
    disp_skill(bot,'Bladeblade',event,true)
    k=3
  elsif ['today','daily','dailies','now'].include?(a[0].downcase)
    a.shift
    today_in_feh(event,bot)
    k=1
  elsif ['tomorrow','tommorrow','tomorow','tommorow'].include?(a[0].downcase)
    a.shift
    today_in_feh(event,bot,true)
    k=1
  elsif ['next','schedule'].include?(a[0].downcase)
    a.shift
    next_events(event,bot,a[0])
    k=1
  elsif ['random','rand'].include?(a[0].downcase)
    a.shift
    if ['unit','real'].include?(a[0].downcase)
      pick_random_unit(event,a,bot)
    else
      generate_random_unit(event,a,bot)
    end
    k=1
  elsif ['compare','comparison'].include?(a[0].downcase)
    a.shift
    k=comparison(event,a,bot)
    k-=1
  elsif ['serveraliases','saliases'].include?(a[0].downcase)
    a.shift
    k=list_unit_aliases(event,a,bot,1)
    k=1
  elsif ['checkaliases','seealiases','aliases'].include?(a[0].downcase)
    t=Time.now
    if t-@last_multi_reload[0]>5*60 || @shardizard==4
      puts 'reloading EliseMulti1'
      load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
      @last_multi_reload[0]=t
    end
    a.shift
    k=list_unit_aliases(event,a,bot)
    k=1
  elsif ['alts','alt'].include?(a[0].downcase)
    a.shift
    k=parse_function_alts(:find_alts,event,a,bot)
    k=1
  elsif ['banners','banner'].include?(a[0].downcase)
    a.shift
    if a.length.zero? || ['next','schedule'].include?(a[0].downcase)
      t=Time.now
      if t-@last_multi_reload[1]>60*60 || @shardizard==4
        puts 'reloading EliseText'
        load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
        @last_multi_reload[1]=t
      end
      timeshift=8
      timeshift-=1 unless t.dst?
      t-=60*60*timeshift
      msg="No unit was included.  Showing current and upcoming banners.\n\nDate assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
      t2=Time.new(2017,2,2)-60*60
      t2=t-t2
      date=(((t2.to_i/60)/60)/24)
      msg=extend_message(msg,"Days since game release: #{longFormattedNumber(date)}",event)
      if event.user.id==167657750971547648 && @shardizard==4
        msg=extend_message(msg,"Daycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12",event)
        msg=extend_message(msg,"Weekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%4+1}/4(Saturday) - #{week_from(date,0)%12+1}/12(Thursday)",event)
      end
      str2=disp_current_events(1)
      msg=extend_message(msg,str2,event,2)
      str2=disp_current_events(-1)
      msg=extend_message(msg,str2,event,2)
      event.respond msg
    else
      k=parse_function(:banner_list,event,a,bot)
    end
    k=1
  elsif ['art'].include?(a[0].downcase)
    a.shift
    k=parse_function(:disp_art,event,a,bot)
    k=1
  elsif ['struct','structure'].include?(a[0].downcase)
    a.shift
    disp_struct(bot,a.join(' '),event)
    k=1
  elsif ['item'].include?(a[0].downcase)
    a.shift
    disp_itemu(bot,a.join(' '),event)
    k=1
  elsif ['allinheritance','allinherit','allinheritable','skillinheritance','skillinherit','skillinheritable','skilllearn','skilllearnable','skillsinheritance','skillsinherit','skillsinheritable','skillslearn','skillslearnable','inheritanceskills','inheritskill','inheritableskill','learnskill','learnableskill','inheritanceskills','inheritskills','inheritableskills','learnskills','learnableskills','all_inheritance','all_inherit','all_inheritable','skill_inheritance','skill_inherit','skill_inheritable','skill_learn','skill_learnable','skills_inheritance','skills_inherit','skills_inheritable','skills_learn','skills_learnable','inheritance_skills','inherit_skill','inheritable_skill','learn_skill','learnable_skill','inheritance_skills','inherit_skills','inheritable_skills','learn_skills','learnable_skills','inherit','learn','inheritance','learnable','inheritable','skillearn','skillearnable'].include?(a[0].downcase)
    a.shift
    k=parse_function(:learnable_skills,event,a,bot)
    k=1
  elsif ['study'].include?(a[0].downcase)
    a.shift
    if ['effhp','eff_hp','bulk'].include?(a[0].downcase)
      a.shift
      k=parse_function(:calculate_effective_HP,event,a,bot)
    elsif ['heal'].include?(a[0].downcase)
      a.shift
      k=parse_function(:heal_study,event,a,bot,true)
    elsif ['proc'].include?(a[0].downcase)
      a.shift
      k=parse_function(:proc_studyevent,a,bot,false)
    elsif ['phase'].include?(a[0].downcase)
      a.shift
      k=parse_function(:phase_study,event,a,bot)
    end
    k=parse_function(:unit_study,event,a,bot)
  elsif ['effhp','eff_hp','bulk'].include?(a[0].downcase)
    a.shift
    k=parse_function(:calculate_effective_HP,event,a,bot)
  elsif ['phase_study','phasestudy','studyphase','study_phase','phase'].include?(a[0].downcase)
    a.shift
    k=parse_function(:phase_study,event,a,bot)
  elsif ['heal_study','healstudy','studyheal','study_heal'].include?(a[0].downcase)
    a.shift
    k=parse_function(:heal_study,event,a,bot,true)
  elsif ['proc_study','procstudy','studyproc','study_proc','proc'].include?(a[0].downcase)
    a.shift
    k=parse_function(:proc_study,event,a,bot,false)
  elsif ['color','colors','colour','colours'].include?(a[0].downcase)
    a.shift
    a=a.reject{ |a| a.match(/<@!?(?:\d+)>/) }
    data_load()
    disp_skill(bot,a.join(' '),event,false,true)
    k=1
  elsif ['stats','stat'].include?(a[0].downcase)
    a.shift
    if ['sort','list'].include?(a[0].downcase)
      a.shift
      sort_units(bot,event,a)
    else
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k=find_name_in_string(event,nil,1)
      k23=0
      if k.nil?
        w=nil
        if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
          x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
          k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
          w=k2[0] unless k2.nil?
          disp_stats(bot,x[1],w,event,true)
        else
          event.respond 'No matches found.'
        end
        k23=1
      end
      str=k[0]
      k2=get_weapon(first_sub(a.join(' '),k[1],''),event)
      w=nil
      w=k2[0] unless k2.nil?
      data_load()
      if k23>0
      elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
        disp_stats(bot,x[1],w,event,true)
      elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
        x=detect_multi_unit_alias(event,str.downcase,str.downcase)
        disp_stats(bot,x[1],w,event,true)
      elsif find_unit(str,event)>=0
        disp_stats(bot,str,w,event)
      else
        event.respond 'No matches found'
      end
    end
    k=1
  elsif ['skills','skils','fodder','manual','book','combatmanual'].include?(a[0].downcase)
    aa=a[0].downcase
    a.shift
    if ['sort','list'].include?(a[0].downcase)
      a.shift
      sort_skills(bot,event,a)
    else
      k=find_name_in_string(event,nil,1)
      k2=0
      if k.nil?
        if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
          x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
          disp_unit_skills(bot,x[1],event)
        elsif s.downcase[0,6]=='skills'
          event.respond "No matches found.  If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill',1)}```, without the s."
        else
          event.respond 'No matches found.  Please note that the `fodder` command is for listing the skills you can fodder a **unit** for, not the units you need to fodder to get a skill.'
        end
        k2=1
      end
      str=k[0]
      data_load()
      if str.nil? || k2>0
      elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
        disp_unit_skills(bot,x[1],event)
      elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
        x=detect_multi_unit_alias(event,str.downcase,str.downcase)
        disp_unit_skills(bot,x[1],event)
      elsif find_unit(str,event)>=0
        disp_unit_skills(bot,str,event)
      else
        event.respond "No matches found.  #{"If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s." if aa=='skills'}"
      end
    end
    k=1
  elsif ['skill','skil'].include?(a[0].downcase)
    a.shift
    if ['sort','list'].include?(a[0].downcase)
      a.shift
      sort_skills(bot,event,a)
    elsif ['learnable','inheritance'].include?(a[0].downcase)
      a.shift
      k=parse_function(:learnable_skills,event,a,bot)
    else
      data_load()
      disp_skill(bot,a.join(' '),event)
    end
    k=1
  elsif ['sort','list'].include?(a[0].downcase)
    a.shift
    if ['skill','skil','skills','skils'].include?(a[0].downcase)
      a.shift
      sort_skills(bot,event,a)
    else
      sort_units(bot,event,a)
    end
    k=1
  elsif ['sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist','sortskil','skilsort','sortskils','skilssort','listskil','skilist','skilist','listskils','skilslist'].include?(a[0].downcase)
    a.shift
    sort_skills(bot,event,a)
    k=1
  elsif ['smol','small','tiny','little','squashed'].include?(a[0].downcase)
    a.shift
    k=find_name_in_string(event,nil,1)
    if k.nil?
      w=nil
      if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
        k2=get_weapon(first_sub(a.join(' '),x[0],''),event)
        w=k2[0] unless k2.nil?
        disp_tiny_stats(bot,x[1],w,event,true)
      elsif !@embedless.include?(event.user.id) && !was_embedless_mentioned?(event)
        event.channel.send_embed("__**No matches found.  Have a smol me instead.**__") do |embed|
          embed.color = 0xD49F61
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Smol_Elise.jpg")
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "image source", url: "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=58900377")
        end
      else
        event.respond 'No matches found.'
      end
    end
    str=k[0]
    k2=get_weapon(first_sub(a.join(' '),k[1],''),event)
    w=nil
    w=k2[0] unless k2.nil?
    data_load()
    if !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
      disp_tiny_stats(bot,x[1],w,event,true)
    elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
      x=detect_multi_unit_alias(event,str.downcase,str.downcase)
      disp_tiny_stats(bot,x[1],w,event,true)
    elsif find_unit(str,event)>=0
      disp_tiny_stats(bot,str,w,event)
    elsif !@embedless.include?(event.user.id) && !was_embedless_mentioned?(event)
      event.channel.send_embed("__**No matches found.  Have a smol me instead.**__") do |embed|
        embed.color = 0xD49F61
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Smol_Elise.jpg")
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "image source", url: "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=58900377")
      end
    else
      event.respond 'No matches found'
    end
    k=1
  elsif ['sortstats','statssort','sortstat','statsort','liststats','statslist','statlist','liststat','sortunits','unitssort','sortunit','unitsort','listunits','unitslist','unitlist','listunit'].include?(a[0].downcase)
    a.shift
    sort_units(bot,event,a)
    k=1
  end
  if k<0
    str=find_name_in_string(event,nil,1)
    data_load()
    if find_skill(s,event,false,true)>=0
      disp_skill(bot,s,event,true)
    elsif find_structure_ex(s,event,true).length>0
      disp_struct(bot,s,event,true)
    elsif find_data_ex(:find_accessory,s,event,true)>=0
      disp_accessory(bot,s,event,true)
    elsif find_data_ex(:find_item_feh,s,event,true)>=0
      disp_itemu(bot,s,event,true)
    elsif str.nil?
      if find_skill(s,event)>=0
        disp_skill(bot,s,event,true)
      elsif find_structure_ex(s,event).length>0
        disp_struct(bot,s,event,true)
      elsif find_data_ex(:find_accessory,s,event)>=0
        disp_accessory(bot,s,event,true)
      elsif find_data_ex(:find_item_feh,s,event)>=0
        disp_itemu(bot,s,event,true)
      elsif !detect_multi_unit_alias(event,s.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,s.downcase,event.message.text.downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.nil?
        disp_stats(bot,x[1],w,event,true,true)
      elsif !detect_multi_unit_alias(event,s.downcase,s.downcase).nil?
        x=detect_multi_unit_alias(event,s.downcase,s.downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.nil?
        disp_stats(bot,x[1],w,event,true,true)
      end
    elsif str[1].downcase=='ploy' && find_skill(stat_buffs(s,s),event)>=0
      disp_skill(bot,stat_buffs(s,s),event,true)
    elsif !detect_multi_unit_alias(event,str[0].downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,str[0].downcase,event.message.text.downcase)
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k2=get_weapon(first_sub(s,x[0],''),event)
      w=nil
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true,true)
    elsif !detect_multi_unit_alias(event,str[0].downcase,str[0].downcase).nil?
      x=detect_multi_unit_alias(event,str[0].downcase,str[0].downcase)
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k2=get_weapon(first_sub(s,x[0],''),event)
      w=nil
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true,true)
    elsif find_unit(str[0],event)>=0
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k=find_name_in_string(event,nil,1)
      if k.nil?
        str=nil
      else
        str=k[0]
        k2=get_weapon(first_sub(s,k[1],''),event)
        w=nil
        w=k2[0] unless k2.nil?
      end
      disp_stats(bot,str,w,event,event.server.nil?,true)
    elsif find_skill(s,event)>0
      disp_skill(bot,s,event,true)
    elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k2=get_weapon(first_sub(s,x[0],''),event)
      w=nil
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true,true)
    elsif find_structure_ex(s,event).length>0
      disp_struct(bot,s,event,true)
    elsif find_data_ex(:find_accessory,s,event)>=0
      disp_accessory(bot,s,event,true)
    elsif find_data_ex(:find_item_feh,s,event)>=0
      disp_itemu(bot,s,event,true)
    end
  end
end

def next_holiday(bot,mode=0)
  t=Time.now
  t-=60*60*6
  puts 'reloading EliseText'
  load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
  @last_multi_reload[1]=t
  holidays=[[0,1,1,'Tiki(Young)','as Babby New Year',"New Year's Day"],
            [0,2,2,'Feh','the best gacha game ever!','Game Release Anniversary'],
            [0,2,14,'Cordelia(Bride)','with your heartstrings.',"Valentine's Day"],
            [0,4,1,'Priscilla','tribute to Xander for making this possible.',"April Fool's Day"],
            [0,4,24,'Sakura(BDay)','dressup as my best friend.',"Coder's birthday"],
            [0,4,29,'Anna',"with all the money you're giving me",'Golden Week'],
            [0,7,4,'Arthur','for freedom and justice.','Independance Day'],
            [0,7,20,'Celica(Fallen)','in the darkest timeline',"...let's just say that this is a sad day for my dev"],
            [0,10,31,'Henry(Halloween)','with a dead Emblian. Nyahaha!','Halloween'],
            [0,12,25,'Robin(M)(Winter)','as Santa Claus for Askr.','Christmas'],
            [0,12,31,'Tiki(Adult)','as Mother Time',"New Year's Eve"]]
  d=get_donor_list()
  d=d.reject{|q| q[2]<2}
  for i in 0...d.length
    holidays.push([0,d[i][3][0],d[i][3][1],d[i][4],"in recognition of #{bot.user(d[i][0]).distinct}","Donator's birthday"])
    holidays[-1][5]="Donator's Day" if d[i][0]==189235935563481088
  end
  for i in 0...holidays.length
    if t.month>holidays[i][1] || (t.month==holidays[i][1] && t.day>holidays[i][2])
      holidays[i][0]=t.year+1
    else
      holidays[i][0]=t.year
    end
  end
  e=calc_easter()
  holidays.push([e[0],e[1],e[2],'Lucina(Bunny)','with your expectations on where I hid the eggs.','Easter'])
  t=Time.now
  t-=60*60*6
  y8=t.year
  j8=Time.new(y8,6,8)
  fsij=8-j8.wday
  fsij-=7 if j8.sunday?
  fd=fsij+14
  if (t.month==6 && t.day>fd) || t.month>6
    y8+=1
    j8=Time.new(y8,6,8)
    fsij=8-j8.wday
    fsij-=7 if j8.sunday?
    fd=fsij+14
  end
  holidays.push([y8,6,fd,'Ike(Brave)',"with my father's keepsake, Urvan.","Father's Day"])
  t=Time.now
  t-=60*60*6
  y8=t.year
  m8=Time.new(y8,5,8)
  fsim=8-m8.wday
  fsim-=7 if m8.sunday?
  md=fsim+7
  if (t.month==5 && t.day>md) || t.month>5
    y8+=1
    m8=Time.new(y8,5,8)
    fsim=8-m8.wday
    fsim-=7 if m8.sunday?
    md=fsim+14
  end
  holidays.push([y8,5,md,'Deirdre','favorites.',"Mother's Day"])
  holidays.sort! {|a,b| supersort(a,b,0) == 0 ? (supersort(a,b,1) == 0 ? (supersort(a,b,2) == 0 ? (supersort(a,b,6) == 0 ? supersort(a,b,4) : supersort(a,b,6)) : supersort(a,b,2)) : supersort(a,b,1)) : supersort(a,b,0)}
  k=[]
  for i in 0...holidays.length
    k.push(holidays[i]) if holidays[i][0]==holidays[0][0] && holidays[i][1]==holidays[0][1] && holidays[i][2]==holidays[0][2]
  end
  div=[[],
       [[0,0]],
       [[0,0],[12,0]],
       [[0,0],[8,0],[16,0]],
       [[0,0],[6,0],[12,0],[18,0]],
       [[0,0],[4,48],[9,36],[14,24],[19,12]],
       [[0,0],[4,0],[8,0],[12,0],[16,0],[20,0]],
       [[0,0],[3,26],[6,52],[10,17],[13,43],[17,8],[18,34]],
       [[0,0],[3,0],[6,0],[9,0],[12,0],[15,0],[18,0],[21,0]]]
  t=Time.now
  t-=60*60*6
  if t.year==k[0][0] && t.month==k[0][1] && t.day==k[0][2]
    if k.length==1
      # Only one holiday is today.  Display new avatar, and set another check for midnight
      bot.game=k[0][4]
      if @shardizard.zero?
        bot.profile.avatar=(File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseImages/#{k[0][3]}.png",'r')) rescue nil
      end
      @avvie_info=[k[0][3],k[0][4],k[0][5]]
      t2= Time.now + 18*60*60
      t=Time.now
      @scheduler.at "#{t2.year}/#{t2.month}/#{t2.day} 0000" do
        next_holiday(bot,1)
      end
    else
      # multiple holidays are today.  Change avatar based on time of day, using div as a reference
      fcod=div[k.length][k.length-1]
      if t.hour>fcod[0] || (t.hour==fcod[0] && t.min>=fcod[1])
        # in last area of day.  Set avatar to the last one for the day, then set a check for tomorrow at midnight
        bot.game=k[k.length-1][4]
        if @shardizard.zero?
          bot.profile.avatar=(File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseImages/#{k[k.length-1][3]}.png",'r')) rescue nil
        end
        @avvie_info=[k[k.length-1][3],k[k.length-1][4],k[k.length-1][5]]
        t2= Time.now + 18*60*60
        t=Time.now
        @scheduler.at "#{t2.year}/#{t2.month}/#{t2.day} 0000" do
          next_holiday(bot,1)
        end
      else
        # find when in the day it is and...
        j=0
        t=Time.now
        t-=60*60*6
        for i in 0...div[k.length].length-1
          j=i if t.hour<div[k.length][i+1][0] || (t.hour==div[k.length][i+1][0] && t.min<div[k.length][i+1][1])
        end
        # ...set avatar properly and set check for the beginning of the next chunk of the day
        bot.game=k[j][4]
        if @shardizard.zero?
          bot.profile.avatar=(File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseImages/#{k[j][3]}.png",'r')) rescue nil
        end
        @avvie_info=[k[j][3],k[j][4],k[j][5]]
        t=Time.now
        t-=60*60*6
        @scheduler.at "#{t.year}/#{t.month}/#{t.day} #{div[k.length][j+1][0].to_s.rjust(2, '0')}#{div[k.length][j+1][1].to_s.rjust(2, '0')}" do
          next_holiday(bot,1)
        end
      end
    end
  else
    t=Time.now
    t-=60*60*6
    bot.game='Fire Emblem Heroes'
    if [6,7,8].include?(t.month)
      bot.profile.avatar=(File.open('C:/Users/Mini-Matt/Desktop/devkit/Elise(Summer).png','r')) rescue nil if @shardizard.zero?
      @avvie_info=['Elise(Summer)','*Fire Emblem Heroes*','']
    else
      bot.profile.avatar=(File.open('C:/Users/Mini-Matt/Desktop/devkit/BaseElise.jpg','r')) rescue nil if @shardizard.zero?
      @avvie_info=['Elise','*Fire Emblem Heroes*','']
    end
    t+=24*60*60
    @scheduler.at "#{t.year}/#{t.month}/#{t.day} 0000" do
      next_holiday(bot,1)
    end
  end
end

bot.ready do |event|
  if @shardizard==4
    for i in 0...bot.servers.values.length
      if ![285663217261477889,443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579].include?(bot.servers.values[i].id)
        bot.servers.values[i].general_channel.send_message(get_debug_leave_message()) rescue nil
        bot.servers.values[i].leave
      end
    end
  end
  system("color 5#{"7CBAE"[@shardizard,1]}")
  system("title loading #{['Transparent','Scarlet','Azure','Verdant','Golden'][@shardizard]} EliseBot")
  bot.game="Loading, please wait..."
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  @aliases=b
  groups_load()
  @groups=b
  metadata_load()
  if @ignored.length>0
    for i in 0...@ignored.length
      bot.ignore_user(@ignored[i].to_i)
    end
  end
  metadata_save()
  metadata_load()
  devunits_load()
  data_load()
  bonus_load()
  @last_multi_reload[0]=Time.now
  system("color e#{"04126"[@shardizard,1]}")
  system("title #{['Transparent','Scarlet','Azure','Verdant','Golden'][@shardizard]} EliseBot")
  bot.game='Fire Emblem Heroes' if [0,4].include?(@shardizard)
  if @shardizard==4
    next_holiday(bot)
    bot.user(bot.profile.id).on(285663217261477889).nickname='EliseBot (Debug)'
    bot.profile.avatar=(File.open('C:/Users/Mini-Matt/Desktop/devkit/DebugElise.png','r'))
  else
    next_holiday(bot)
    puts 'Avatar loaded' if @shardizard.zero?
  end
end

bot.run
