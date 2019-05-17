@shardizard = ARGV.first.to_i # taking a single variable from the command prompt to get the shard value
system('color 0F')
@shards = 6                   # total number of shards

require 'discordrb'                    # Download link: https://github.com/meew0/discordrb
require 'open-uri'                     # pre-installed with Ruby in Windows
require 'net/http'                     # pre-installed with Ruby in Windows
require 'certified'
require 'tzinfo/data'                  # Downloaded with active_support below, but the require must be above active_support's require
require 'rufus-scheduler'              # Download link: https://github.com/jmettraux/rufus-scheduler
require 'active_support/core_ext/time' # Download link: https://rubygems.org/gems/activesupport/versions/5.0.0
require_relative 'rot8er_functs'       # functions I use commonly in bots
load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'

system("color 0#{shard_data(4)[@shardizard,1]}") # command prompt color and title determined by the shard
system("title loading #{shard_data(2)[@shardizard]} EliseBot")

# this is required to get her to change her avatar on certain holidays
ENV['TZ'] = 'America/Chicago'
@scheduler = Rufus::Scheduler.new

# All the possible command prefixes
@prefixes={}
load 'C:/Users/Mini-Matt/Desktop/devkit/FEHPrefix.rb'

prefix_proc = proc do |message|
  next pseudocase(message.text[4..-1]) if message.text.downcase.start_with?('feh!')
  next pseudocase(message.text[4..-1]) if message.text.downcase.start_with?('feh?')
  next pseudocase(message.text[2..-1]) if message.text.downcase.start_with?('f?')
  next pseudocase(message.text[2..-1]) if message.text.downcase.start_with?('e?')
  next pseudocase(message.text[2..-1]) if message.text.downcase.start_with?('h?')
  load 'C:/Users/Mini-Matt/Desktop/devkit/FEHPrefix.rb'
  next if message.channel.server.nil? || @prefixes[message.channel.server.id].nil? || @prefixes[message.channel.server.id].length<=0
  prefix = @prefixes[message.channel.server.id]
  # We use [prefix.size..-1] so we can handle prefixes of any length
  next pseudocase(message.text[prefix.size..-1]) if message.text.downcase.start_with?(prefix.downcase)
end

# The bot's token is basically their password, so is censored for obvious reasons
if @shardizard==4
  bot = Discordrb::Commands::CommandBot.new token: '>Debug Token<', client_id: 431895561193390090, prefix: prefix_proc
elsif @shardizard<4
  bot = Discordrb::Commands::CommandBot.new token: '>Main Token<', shard_id: @shardizard, num_shards: 6, client_id: 312451658908958721, prefix: prefix_proc
else
  bot = Discordrb::Commands::CommandBot.new token: '>Main Token<', shard_id: (@shardizard-1), num_shards: 6, client_id: 312451658908958721, prefix: prefix_proc
end
bot.gateway.check_heartbeat_acks = false

# initialize global variables
@units=[]
@skills=[]
@structures=[]
@accessories=[]
@itemus=[]
@aliases=[]
@aliases2=[]
@groups=[]
@embedless=[]
@ignored=[]
@banner=[]
@server_data=[[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
@server_markers=[]
@x_markers=[]
@max_rarity_merge=[5,10,5]
@dev_waifus=[]
@dev_somebodies=[]
@dev_nobodies=[]
@dev_units=[]
@bonus_units=[]
@avvie_info=['Elise','*Fire Emblem Heroes*','N/A']
@stored_event=nil
@zero_by_four=[0,0,0,'']
@last_multi_reload=[0,0,0]
@headpats=[0,0,0]
@rarity_stars=['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>',
               '<:Icon_Rarity_4:448266418459377684>','<:Icon_Rarity_5:448266417553539104>','<:Icon_Rarity_6:491487784650145812>']
@summon_servers=[330850148261298176,389099550155079680,256291408598663168,271642342153388034,285663217261477889,280125970252431360,356146569239855104,
                 393775173095915521,341729526767681549,380013135576432651,383563205894733824,374991726139670528,338856743553597440,297459718249512961,
                 283833293894582272,305889949574496257,214552543835979778,332249772180111360,334554496434700289,306213252625465354,197504651472535552,
                 347491426852143109,392557615177007104,295686580528742420,412303462764773376,442465051371372544,353997181193289728,462100851864109056,
                 337397338823852034,446111983155150875,295001062790660097,328109510449430529,483437489021911051,513061112896290816,327599133210705923]
@summon_rate=[0,0,3]
@summon_rate_2=[0,0,3]
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
     'legends','legendarys','item','accessory','acc','accessorie','alias','s2s','dailies','tomorrow','tommorrow','tomorow','tommorow','aoe','area','prf','prfs',
     'prefix','shards','hero','aliashift','fu','pairup','pair','cleanupaliases','sendmessage','ignoreuser','removefrommulti','removefromdualunitalias','backup',
     'removefrommultiunitalias','removefromdualalias','removefrommultialias','skilload']
  if permissions==0
    k=all_commands(false)-all_commands(false,1)-all_commands(false,2)
  elsif permissions==1
    k=['addalias','deletealias','removealias','addgroup','deletegroup','removegroup','removemember','removefromgroup','prefix']
  elsif permissions==2
    k=['reboot','addmultialias','adddualalias','addualalias','addmultiunitalias','adddualunitalias','addualunitalias','multialias','dualalias','addmulti',
       'deletemultialias','deletedualalias','deletemultiunitalias','deletedualunitalias','deletemulti','removemultialias','removedualalias','dev_edit','devedit',
       'removemultiunitalias','removedualunitalias','removemulti','removefrommultialias','removefromdualalias','removefrommultiunitalias','backup',
       'removefromdualunitalias','removefrommulti','sendpm','ignoreuser','sendmessage','leaveserver','cleanupaliases','setmarker','snagchannels','reload']
  end
  k.uniq!
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
    bob4[4]=bob4[4].split(', ')
    bob4[5]=bob4[5].split(', ')
    for j in 0...5 # growth rates and level 40 stats should be stored as numbers, not strings
      bob4[4][j]=bob4[4][j].to_i
      bob4[5][j]=bob4[5][j].to_i
    end
    if bob4[7].length<=0
      bob4[7]=['','']
    elsif !bob4[7].include?(';; ')
      bob4[7]=[bob4[7],'']
    else
      bob4[7]=bob4[7].split(';; ')
    end
    bob4[8]=bob4[8].to_i
    # the list of games should be spliced into an array of game abbreviations
    if bob4[9].length>1
      bob4[9]=bob4[9].split(', ')
    else
      bob4[9]=['-']
    end
    # the list of games should be spliced into an array of game abbreviations
    if bob4[11].length>1
      bob4[11]=bob4[11].split(', ')
    else
      bob4[11]=[' ']
    end
    if bob4[13].nil? # server-specific units' markers should be split into two pieces - the server(s) they are allowed in, and the ID of the user whose avatar to use
      bob4[13]=[]
    else
      bob4[13]=[bob4[13].scan(/[[:alpha:]]+?/).join, bob4[13].gsub(bob4[13].scan(/[[:alpha:]]+?/).join,'').to_i]
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
    bob4[0]=bob4[0].to_i                     # SP cost should be stored as a number...
    bob4[3]=bob4[3].to_i                     # SP cost should be stored as a number...
    bob4[4]=bob4[4].to_i unless bob4[4]=='-' || !['Weapon','Assist','Special'].include?(bob4[6]) # ...as should the Might or Cooldown
    bob4[11]=bob4[11].split('; ')   # the list of units that know a skill by default should be split into lists based on rarity...
    bob4[12]=bob4[12].split('; ') # ...as should the list of units who can learn a skill without inheritance
    bob4[13]=bob4[13].split(', ') # the list of tags should be split by tag
    bob4[14]=bob4[14].split(',').map{|q| q.to_i} if bob4[6]=='Weapon' # stats affected by the weapon, split into a list and turned from strings into numbers
    bob4[15]=nil unless bob4[15].nil? || bob4[15].length>0 # tag for server-specific skills
    bob4[16]=nil unless bob4[16].nil? || bob4[16].length>0 # this entry is used by weapons to store their evolutions, and by healing staves to store their healing formula
    bob4[17]=nil unless bob4[17].nil? || bob4[17].length>0 # this entry is used by weapons to store their refinement data
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

def prefixes_save()
  x=@prefixes
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHPrefix.rb', 'w') { |f|
    f.puts x.to_s.gsub('=>',' => ').gsub(', ',",\n  ").gsub('{',"@prefixes = {\n  ").gsub('}',"\n}")
  }
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
  t=Time.now
  @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
  if t-@last_multi_reload[2]<=10*60 || (@shardizard==4 && t-@last_multi_reload[2]<=60)
    @last_multi_reload[2]=t
    puts 'reloading and checking Alias list'
    if !@aliases[-1][2].is_a?(String) || @aliases[-1][2]<'Verdant Shard'
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt').each_line do |line|
          b.push(eval line)
        end
      else
        b=[]
      end
      b=b.reject{|q| q.nil? || q[1].nil?}.uniq
      b.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
      if !b[-1][2].is_a?(String) || b[-1][2]<'Verdant Shard'
        puts 'Last backup of the alias list has been corrupted.  Restoring from manually-created backup.'
        if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames3.txt')
          b=[]
          File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames3.txt').each_line do |line|
            b.push(eval line)
          end
        else
          b=[]
        end
        b=b.reject{|q| q.nil? || q[1].nil?}.uniq
      else
        puts 'Last backup of the alias list being used.'
      end
      open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
        for i in 0...b.length
          f.puts "#{b[i].to_s}"
        end
      }
      puts 'Alias list has been restored from backup.'
    end
  end
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
    b=[[],[],[0,0],[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]],[0,0,0],[],[],[]]
  end
  @embedless=b[0]
  @embedless=[168592191189417984, 256379815601373184] if @embedless.nil?
  @ignored=b[1]
  @ignored=[] if @ignored.nil?
  @summon_rate=b[2]
  @summon_rate=[0,0,3] if @summon_rate.nil?
  @server_data=b[3]
  @server_data=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] if @server_data.nil?
  if @server_data[0].length<@shards+1
    for i in 0...@shards+1
      @server_data[0][i]=0 if @server_data[0][i].nil?
    end
  end
  if @server_data[1].length<@shards+1
    for i in 0...@shards+1
      @server_data[1][i]=0 if @server_data[1][i].nil?
    end
  end
  @headpats=b[4] unless b[4].nil?
  @server_markers=b[5] unless b[5].nil?
  @x_markers=b[6] unless b[6].nil?
  @spam_channels=b[7]
  @spam_channels=[407149643923849218] if @spam_channels.nil?
end

def metadata_save() # saves the metadata
  if @server_data[0].length<@shards+1
    for i in 0...@shards+1
      @server_data[0][i]=0 if @server_data[0][i].nil?
    end
  end
  if @server_data[1].length<@shards+1
    for i in 0...@shards+1
      @server_data[1][i]=0 if @server_data[1][i].nil?
    end
  end
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
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return load_devunits()
end

def devunits_save() # used by the devedit command to save the devunits
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return save_devunits()
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

def lookout_load(sheet='StatSkills',types=[],mode=0)
  lookout=[]
  if File.exist?("C:/Users/Mini-Matt/Desktop/devkit/FEH#{sheet}.txt")
    File.open("C:/Users/Mini-Matt/Desktop/devkit/FEH#{sheet}.txt").each_line do |line|
      lookout.push(eval line)
    end
    if mode==1
      lookout=lookout.reject{|q| !types.include?(q[3][0,q[3].length-2])} if types.length>0
    else
      lookout=lookout.reject{|q| !types.include?(q[3])} if types.length>0
    end
  end
  return lookout
end

bot.command([:help,:commands,:command_list,:commandlist,:Help]) do |event, command, subcommand| # used to show tooltips regarding each command.  If no command name is given, shows a list of all commands
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  return true if event.user.id==167657750971547648 && event.message.text.split(' ').include?('RCX')
  return false if event.message.text.downcase.split(' ').include?('smol') && @shardizard==4
  return true if [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388].include?(event.server.id) # it is safe to spam in the emoji servers
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
      str=remove_prefix(str,event)
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
      if !get_donor_list().reject{|q| q[2][0]<3}.map{|q| q[0]}.include?(f[-1][1])
        f[-1]=nil
        f.compact!
      elsif !get_donor_list().reject{|q| q[2][0]<4}.map{|q| q[0]}.include?(f[-1][1])
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

def donor_unit_list(uid,mode=0)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  load_donorunits(uid,mode)
end

def donor_unit_save(uid,table) # used by the edit command to save the donorunits
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  save_donorunits(uid,table)
end

def overlap_prevent(event) # used to prevent servers with both Elise and her debug form from receiving two replies
  if event.server.nil? # failsafe code catching PMs as not a server
    return false
  elsif event.message.text.downcase.split(' ').include?('debug') && [443172595580534784,443704357335203840,443181099494146068,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,572792502159933440].include?(event.server.id)
    return @shardizard != 4 # the debug bot can be forced to be used in the emoji servers by including the word "debug" in your message
  elsif [443172595580534784,443704357335203840,443181099494146068,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,572792502159933440].include?(event.server.id) # emoji servers will use default Elise otherwise
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
    s=remove_prefix(s,event)
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

def get_stats(event,name,level=40,rarity=5,merges=0,boon='',bane='',flowers=0) # used by multiple commands to calculate a unit's stats
  data_load()
  # find neutral five-star level 40 stats
  unit=@units.map{|q| q}
  if name=='Robin'
    f=unit[unit.find_index{|q| q[0]=='Robin(F)'}]
  else
    f=unit[unit.find_index{|q| q[0]==name}]
  end
  flowers=[flowers,@max_rarity_merge[2]].min unless f[9][0].include?('PF') && f[3]=='Infantry'
  sttz=['hp','attack','speed','defense','resistance']
  for i in 0...sttz.length
    sttz[i]=1 if boon.downcase==sttz[i]
    sttz[i]=-1 if bane.downcase==sttz[i] && merges==0
    sttz[i]=0 if sttz[i].is_a?(String)
  end
  if rarity>=@mods[0].length
    for i in 0...@mods.length
      @mods[i][rarity]=(0.39*((((i-4)*5+20)*(0.79+(0.07*rarity))).to_i)).to_i
    end
  end
  # find neutral 5* level 1 stats based on rarity
  rates=f[4].map{|q| q}                                                     # rate numbers
  m=rates.map{|q| (0.39*(((q*5+20)*(0.79+(0.07*5))).to_i)).to_i}            # growth rates
  unit=[f[0]]
  for i in 0...5
    unit.push(f[5][i]-m[i])                                                 # apply the difference in the step above
  end
  s=[[unit[2],2],[unit[3],3],[unit[4],4],[unit[5],5]]                       # all non-HP stats
  s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}  # sort the stats based on amount
  # apply the level 1 rarity difference between 5* and 1*
  unit[1]-=2
  unit[2]-=2
  unit[3]-=2
  unit[4]-=2
  unit[5]-=2
  # Every odd rarity increases all stats by 1 compared to the previous odd rarity
  unit[1]+=((rarity-1)/2)
  unit[2]+=((rarity-1)/2)
  unit[3]+=((rarity-1)/2)
  unit[4]+=((rarity-1)/2)
  unit[5]+=((rarity-1)/2)
  # store current stats
  s2=unit.map{|q| q}
  # if rarity is even, increase the two highest non-HP stats by 1 each
  if rarity%2==0
    unit[s[0][1]]+=1
    unit[s[1][1]]+=1
  end
  # find level 1 stats and growth rates based on boon and bane
  for i in 0...5
    unit[i+1]+=sttz[i]
    s2[i+1]+=sttz[i] # adjust even the odd-locked stats
    rates[i]+=sttz[i]
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
    m=rates.map{|q| (0.39*(((q*5+20)*(0.79+(0.07*rarity))).to_i)).to_i}
    unit=[unit[0],unit[1]+m[0],unit[2]+m[1],unit[3]+m[2],unit[4]+m[3],unit[5]+m[4],rates[0],rates[1],rates[2],rates[3],rates[4],m[0],m[1],m[2],m[3],m[4]]
    # apply the difference above
  end
  if merges>0 || flowers>0
    # every five merges results in +2 to each stat
    # every five flowers results in +1 to each stat
    unit[1]+=2*(merges/5)+(flowers/5)
    unit[2]+=2*(merges/5)+(flowers/5)
    unit[3]+=2*(merges/5)+(flowers/5)
    unit[4]+=2*(merges/5)+(flowers/5)
    unit[5]+=2*(merges/5)+(flowers/5)
    # beyond that, two stats per merge, order determined above
    if (merges%5)>0
      for i in 0...2*(merges%5)
        unit[s[i][1]]+=1
      end
    end
    # one stat per flower, order same as merges
    if (flowers%5)>0
      for i in 0...(flowers%5)
        unit[s[i][1]]+=1
      end
    end
  end
  if merges>0 && bane=='' && boon=='' # neutral-natured units with merges get +1 to each of the first three stats in the same calculation above
    for i in 0...3
      unit[s[i][1]]+=1
    end
  end
  return unit
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

def find_unit(name,event,ignore=false,ignore2=false) # used to find a unit's data entry based on their name
  ks=0
  ks=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if name.nil?
  data_load()
  name=normalize(name.gsub('!',''))
  if name.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    buff=name.split(':')[1]
    buff=buff[3,buff.length-3] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,3].downcase=='gp_'
    buff=buff[2,buff.length-2] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,2].downcase=='gp'
    name=buff if find_unit(buff,event,ignore).length>0
  end
  name=name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','') unless ignore2
  untz=@units.map{|q| q}
  nicknames_load()
  b=@aliases.map{|q| q}
  b.reject!{|q| !q[3].nil? && !q[3].include?(ks)}
  b.reject!{|q| q[0]!='Unit'}
  b.sort!{|a,c| supersort(a,c,1,nil,1)}
  k=b.bsearch_index{|q| name.downcase<=>q[1].downcase}
  unless k.nil?
    if b[k][2].is_a?(Array)
      return b[k][2].map{|q| untz[untz.find_index{|q2| q2[8]==q}]}
    elsif b[k][2]<1000
      return untz[b[k][2]]
    else
      m=untz[untz.find_index{|q| q[8]==b[k][2]}]
      return m if has_any?(g, m[13][0])
    end
  end
  k=b.bsearch_index{|q| name.downcase<=>q[1].gsub('||','').downcase}
  unless k.nil?
    if b[k][2].is_a?(Array)
      return b[k][2].map{|q| untz[untz.find_index{|q2| q2[8]==q}]}
    elsif b[k][2]<1000
      return untz[b[k][2]]
    else
      m=untz[untz.find_index{|q| q[8]==b[k][2]}]
      return m if has_any?(g, m[13][0])
    end
  end
  unless name.length<2 || ignore || ['blade','blad','bla'].include?(name.downcase)
    b.reject!{|q| q[1].length<name.length}
    k=b.find_index{|q| name.downcase==q[1][0,name.length].downcase}
    unless k.nil?
      if b[k][2].is_a?(Array)
        return b[k][2].map{|q| untz[untz.find_index{|q2| q2[8]==q}]}
      elsif b[k][2]<1000
        return untz[b[k][2]]
      else
        m=untz[untz.find_index{|q| q[8]==b[k][2]}]
        return m if has_any?(g, m[13][0])
      end
    end
    k=b.find_index{|q| name.downcase==q[1].gsub('||','')[0,name.length].downcase}
    unless k.nil?
      if b[k][2].is_a?(Array)
        return b[k][2].map{|q| untz[untz.find_index{|q2| q2[8]==q}]}
      elsif b[k][2]<1000
        return untz[b[k][2]]
      else
        m=untz[untz.find_index{|q| q[8]==b[k][2]}]
        return m if has_any?(g, m[13][0])
      end
    end
  end
  unless ignore2 || !name.downcase.include?('launch')
    name2=name.downcase.gsub('launch','')
    b.reject!{|q| q[1].length<name2.length}
    k=b.bsearch_index{|q| name2.downcase<=>q[1].downcase}
    unless k.nil?
      return untz[b[k][2]] if !b[k][2].is_a?(Array) && b[k][2]<100 && untz[b[k][2]][9][0].include?('LU')
    end
    k=b.bsearch_index{|q| q[1].gsub('||','').downcase<=>name2.downcase}
    unless k.nil?
      return untz[b[k][2]] if !b[k][2].is_a?(Array) && b[k][2]<100 && untz[b[k][2]][9][0].include?('LU')
    end
  end
  return []
end

def find_skill(name,event,ignore=false,ignore2=false,untz=nil)
  data_load()
  nicknames_load()
  ks=0
  ks=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if name.nil? || name.length<=0
  name=normalize(name.gsub('!','').gsub('.','').gsub('?',''))
  if name.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    buff=name.split(':')[1]
    buff=buff[3,buff.length-3] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,3].downcase=='gp_'
    buff=buff[2,buff.length-2] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,2].downcase=='gp'
    name=buff if find_skill(buff,event,ignore,ignore2).length>0
  end
  name=name.gsub(' ','').gsub('_','').gsub('(','').gsub(')','') unless ignore2
  untz=@skills.map{|q| q} if untz.nil? || untz.length<=0
  untz=untz.sort{|a,b| a[0]<=>b[0]}.uniq
  nicknames_load()
  b=@aliases.reject{|q| q[0]!='Skill' || q[2].is_a?(String)}
  u=untz.map{|q| q[0]}
  b.reject!{|q| !u.include?(q[2])}
  b.reject!{|q| !q[3].nil? && !q[3].include?(ks)}
  b.reject!{|q| q[0]!='Skill'}
  b.sort!{|a,c| supersort(a,c,1,nil,1)}
  k=b.bsearch_index{|q| name.gsub(' ','').downcase<=>q[1].gsub(' ','').downcase}
  unless k.nil?
    m=b[k]
    m2=untz.bsearch_index{|q| m[2]<=>q[0]}
    unless m2.nil?
      m=untz[m2]
      if m[2]=='example'
        return untz.reject{|q| "#{'-' if q[0]<0}#{q[0].abs/10}"!="#{'-' if m[0]<0}#{m[0].abs/10}"}
      else
        return m
      end
    end
  end
  if name[name.length-1,1].to_i.to_s==name[name.length-1,1] || name[name.length-1,1]=='w'
    name2=name[0,name.length-1]
    lvl=name[name.length-1,1]
    if name2[name2.length-1,1].to_i.to_s==name2[name2.length-1,1] || name2[name2.length-1,1]=='w'
      name2=name[0,name.length-2]
      lvl=name[name.length-2,2]
    end
    k=b.bsearch_index{|q| name2.gsub(' ','').downcase<=>q[1].gsub(' ','').downcase}
    unless k.nil?
      m=b[k]
      m2=untz.bsearch_index{|q| m[2]<=>q[0]}
      unless m2.nil?
        m=untz[m2]
        if m[2]=='example'
          m=untz.reject{|q| "#{'-' if q[0]<0}#{q[0].abs/10}"!="#{'-' if m[0]<0}#{m[0].abs/10}"}
          m2=m.reject{|q| q[2].downcase != lvl}
          return m2[0] if m2.length>0
          return []
        else
          return []
        end
      end
    end
  end
  k=b.find_index{|q| q[1].gsub(' ','').downcase==name.gsub(' ','').downcase}
  unless k.nil?
    m=b[k]
    m2=untz.bsearch_index{|q| m[2]<=>q[0]}
    unless m2.nil?
      m=untz[m2]
      if m[2]=='example'
        return untz.reject{|q| "#{'-' if q[0]<0}#{q[0].abs/10}"!="#{'-' if m[0]<0}#{m[0].abs/10}"}
      else
        return m
      end
    end
  end
  b=b.reject{|q| q[1].gsub(' ','').length<name.gsub(' ','').length || q[1][q[1].length-1,1].to_i.to_s==q[1][q[1].length-1,1]}
  k=b.find_index{|q| name.gsub(' ','').downcase==q[1].gsub(' ','')[0,name.gsub(' ','').length].downcase}
  unless k.nil?
    m=b[k]
    m2=untz.bsearch_index{|q| m[2]<=>q[0]}
    unless m2.nil?
      m=untz[m2]
      if m[2]=='example'
        return untz.reject{|q| "#{'-' if q[0]<0}#{q[0].abs/10}"!="#{'-' if m[0]<0}#{m[0].abs/10}"}
      else
        return m
      end
    end
  end
  return []
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
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name && (q[2].nil? || q[2].include?(g))}
  unless k.nil?
    m=strct.find_index{|q| "#{q[0]} #{q[1]}"==alz[k][1]}
    return [m] unless m.nil?
    s=strct.reject{|q| q[0]!=alz[k][1]}
    return s.map{|q| strct.find_index{|q2| q==q2}}
  end
  return [] if fullname || name.length<=2
  return [] if name.length<3
  k=strct.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name}
  s=[]
  s=strct.reject{|q| q[0]!=strct[k][0] || q[2]!=strct[k][2]} unless k.nil?
  return s.map{|q| strct.find_index{|q2| q==q2}} if s.length>0
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
  s=[]
  s=strct.reject{|q| q[0]!=strct[k][0] || q[2]!=strct[k][2]} unless k.nil?
  return s.map{|q| strct.find_index{|q2| q==q2}} if s.length>0
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
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
  return [] if fullname || name.length<=2
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
  return itmu[k] unless k.nil?
  nicknames_load()
  alz=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q[0]==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q[0]==alz[k][1]}] unless k.nil?
  return [] if fullname || name.length<3
  k=itmu.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name}
  return itmu[k] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q[0]==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q[0]==alz[k][1]}] unless k.nil?
  return []
end

def find_accessory(name,event,fullname=false)
  data_load()
  itmu=@accessories.map{|q| q}
  name=name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  k=itmu.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name}
  return itmu[k] unless k.nil?
  nicknames_load()
  alz=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q[0]==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==name && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q[0]==alz[k][1]}] unless k.nil?
  return [] if fullname || name.length<3
  k=itmu.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name}
  return itmu[k] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q[0]==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,name.length]==name && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q[0]==alz[k][1]}] unless k.nil?
  return []
end

def find_data_ex(callback,name,event,fullname=false,mode=0)
  if [:find_unit,:find_skill,:find_skill,:find_accessory,:find_item_feh].include?(callback)
    k=method(callback).call(name,event,true)
    return [k,name] if k.length>0 && mode==1
    return k if k.length>0
    args=name.split(' ')
    for i in 0...args.length
      for i2 in 0...args.length-i
        k=method(callback).call(args[i,args.length-i-i2].join(' '),event,true)
        return [k,args[i,args.length-i-i2].join(' ')] if k.length>0 && args[i,args.length-i-i2].length>0 && mode==1
        return k if k.length>0 && args[i,args.length-i-i2].length>0
      end
    end
    return [] if fullname || name.length<=2
    k=method(callback).call(name,event)
    return [k,name] if k.length>0 && mode==1
    return k if k.length>0
    args=name.split(' ')
    for i in 0...args.length
      for i2 in 0...args.length-i
        k=method(callback).call(args[i,args.length-i-i2].join(' '),event)
        return [k,args[i,args.length-i-i2].join(' ')] if k.length>0 && args[i,args.length-i-i2].length>0 && mode==1
        return k if k.length>0 && args[i,args.length-i-i2].length>0
      end
    end
    return []
  else
    k=method(callback).call(name,event,true)
    return [k,name] if k>=0 && mode==1
    return k if k>=0
    args=name.split(' ')
    for i in 0...args.length
      for i2 in 0...args.length-i
        k=method(callback).call(args[i,args.length-i-i2].join(' '),event,true)
        return [k,args[i,args.length-i-i2].join(' ')] if k>=0 && args[i,args.length-i-i2].length>0 && mode==1
        return k if k>=0 && args[i,args.length-i-i2].length>0
      end
    end
    return -1 if fullname || name.length<=2
    k=method(callback).call(name,event)
    return [k,name] if k>=0 && mode==1
    return k if k>=0
    args=name.split(' ')
    for i in 0...args.length
      for i2 in 0...args.length-i
        k=method(callback).call(args[i,args.length-i-i2].join(' '),event)
        return [k,args[i,args.length-i-i2].join(' ')] if k>=0 && args[i,args.length-i-i2].length>0 && mode==1
        return k if k>=0 && args[i,args.length-i-i2].length>0
      end
    end
    return -1
  end
end

def find_promotions(j,event) # finds the promotions of a given skill.  Input is given in the skill's entry number, not name
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if j.length<=0
  data_load()
  p=[]
  sklz=@skills.reject{|q| q[2]=='example'}
  sklz=sklz.reject{|q| q[6]!=j[6]} if ['Weapon','Assist','Special'].include?(j[6])
  sklz=sklz.reject{|q| ['Weapon','Assist','Special'].include?(q[6])} unless ['Weapon','Assist','Special'].include?(j[6])
  checkstr="#{j[1]}#{' ' unless j[1][-1,1]=='+'}#{j[2]}"
  checkstr=j[1] if j[2]=='-' || ['Weapon','Assist','Special'].include?(j[6])
  for i in 0...sklz.length
    unless sklz[i].nil? || sklz[i][8].nil?
      if sklz[i][10].include?("*#{checkstr}*") && has_any?(g, sklz[i][15])
        p.push(sklz[i][1]) if sklz[i][2]=='-' || ['Weapon','Assist','Special'].include?(sklz[i][6])
        p.push("#{sklz[i][1]}#{' ' if sklz[i][1][-1,1]!='+'}#{sklz[i][2]}") unless sklz[i][2]=='-' || ['Weapon','Assist','Special'].include?(sklz[i][6])
      end
    end
  end
  p=p.sort{|a,b| a.downcase <=> b.downcase}
  p=p.reject{|q| q[0,10]=='Falchion (' || ['Ragnarok+','Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(q)}
  return p
end

def find_prevolutions(j,event) # finds any "pre-evolutions" of evolved weapons.  Input is given in the weapon's entry number, not name
  g=get_markers(event)
  return [] if j.length<0
  data_load()
  p=[]
  sklz=@skills.reject{|q| q[6]!='Weapon'}
  for i in 0...sklz.length
    unless sklz[i][16].nil?
      k=sklz[i][16].split(', ')
      for i2 in 0...k.length
        if k[i2].include?('!') # this is currently-unused code that allows for character-specific evolutions
          z=k[i2].split('!')
          z2=sklz[i].map{|q| q}
          for i3 in 0...@max_rarity_merge[0]
            if z2[12][i3].include?(z[0])
              z2[12][i3]=z[0]
            else
              z2[12][i3]='-'
            end
          end
          p.push([z2,'but only when on']) if z[1]==j[1] && has_any?(g, sklz[i][15])
        else # used code starts back here.
          p.push([sklz[i],'which is learned by']) if k[i2]==j[1] && has_any?(g, sklz[i][15])
        end
      end
    end
  end
  p=p.sort {|a,b| a[0][0] <=> b[0][0]}
  return p
end

def find_effect_name(x,event,shorten=0) # used to find the name of the Effect Mode refine of a weapon.  Input is given in the weapon's entire entry, not name.
  g=get_markers(event)
  return [] if x.nil?
  data_load()
  p=[]
  f=''
  sklz=@skills.map{|q| q}
  for i in 0...sklz.length
    unless sklz[i][6]=='Weapon' || sklz[i][14].nil? || sklz[i][14]==''
      if sklz[i][2]!='example' && sklz[i][14].split(', ').include?(x[1]) && has_any?(g, sklz[i][15])
        f="#{sklz[i][1]}#{" #{sklz[i][2]}" unless sklz[i][2]=='-'}"
        f=sklz[i][1] if shorten==1
        f="#{sklz[i][1]}#{" W" unless sklz[i][2]=='-'}" if shorten==2
        return f
      end
    end
  end
  return f
end

def find_weapon(name,event,ignore=false,ignore2=false,mode=0) # used by the `get_weapon` function
  sklz=@skills.map{|q| q}
  sklz=@skills.reject{|q| q[6]!='Weapon'} unless mode==0
  return find_skill(name,event,ignore,ignore2,sklz)
end

def get_weapon(str,event,mode=0) # used by the `stats` command and many derivations to find a weapon's name in the inputs that remain after the unit is decided
  return [] if str.gsub(' ','').length<=0
  skz=@skills.map{|q| q}
  args=str.gsub('(','').gsub(')','').split(' ')
  args=args.reject{|q| q.gsub('*','').gsub('+','').to_i.to_s==q.gsub('*','').gsub('+','') || skz.reject{|q2| ['Weapon','Assist','Special'].include?(q2[4])}.map{|q2| (stat_buffs(q2[1]).downcase.gsub(' ','') rescue "\u0F8F")}.include?((stat_buffs(q,nil,2).downcase rescue "\u0653")) || skz.reject{|q2| ['Weapon','Assist','Special'].include?(q2[6])}.map{|q2| q2[1].gsub('/','').downcase.gsub(' ','')}.include?(q.downcase) || ['+','-'].include?(q[0,1])} if args.length>1
  args2=args.join(' ').split(' ')
  args4=args.join(' ').split(' ')
  name=args.join(' ')
  args3=args.join(' ').split(' ')
  # try full-name matches first...
  if find_weapon(name,event,true,false,mode).length<=0
    for i in 0...args.length-1
      args.pop
      if find_weapon(name,event,true,false,mode).length<=0 && find_weapon(args.join('').downcase,event,true,false,mode).length>0
        args3=args.join(' ').split(' ') 
        name=find_weapon(args.join('').downcase,event,true,false,mode)[1]
      end
    end
    if find_weapon(name,event,true,false,mode).length<=0
      for j in 0...args2.length-1
        args2.shift
        args=args2.join(' ').split(' ')
        if find_weapon(name,event,true,false,mode).length<=0 && find_weapon(args.join('').downcase,event,true,false,mode).length>0
          args3=args.join(' ').split(' ') 
          name=find_weapon(args.join('').downcase,event,true,false,mode)[1]
        end
        for i in 0...args.length-1
          args.pop
          if find_weapon(name,event,true,false,mode).length<=0 && find_weapon(args.join('').downcase,event,true,false,mode).length>0
            args3=args.join(' ').split(' ') 
            name=find_weapon(args.join('').downcase,event,true,false,mode)[1]
          end
        end
      end
    end
  end
  args2=args4.join(' ').split(' ')
  # ...then try partial name matches
  if find_weapon(name,event,false,false,mode).length<=0
    for i in 0...args.length-1
      args.pop
      if find_weapon(name,event,false,false,mode).length<=0 && find_weapon(args.join('').downcase,event,false,false,mode).length>0
        args3=args.join(' ').split(' ') 
        name=find_weapon(args.join('').downcase,event,false,false,mode)[1]
      end
    end
    if find_weapon(name,event,false,false,mode).length<=0
      for j in 0...args2.length-1
        args2.shift
        args=args2.join(' ').split(' ')
        if find_weapon(name,event,false,false,mode).length<=0 && find_weapon(args.join('').downcase,event,false,false,mode).length>0
          args3=args.join(' ').split(' ') 
          name=find_weapon(args.join('').downcase,event,false,false,mode)[1]
        end
        for i in 0...args.length-1
          args.pop
          if find_weapon(name,event,false,false,mode).length<=0 && find_weapon(args.join('').downcase,event,false,false,mode).length>0
            args3=args.join(' ').split(' ') 
            name=find_weapon(args.join('').downcase,event,false,false,mode)[1]
          end
        end
      end
    end
  end
  return [find_weapon(name,event)[1],args3.join(' ')] if find_weapon(name,event).length>0
  return []
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
  name='Picnic' if ['picnic','lunch'].include?(name.downcase)
  name='Bathing' if ['bathers','bathhouse','bathouse','bath','bathing'].include?(name.downcase)
  name="Valentine's" if ['valentines',"valentine's"].include?(name.downcase)
  name="NewYear's" if ['newyears',"newyear's",'newyear'].include?(name.downcase)
  name='Wedding' if ['brides','grooms','bride','groom','wedding'].include?(name.downcase)
  name='Falchion_Users' if ['falchionusers'].include?(name.downcase.gsub('-','').gsub('_',''))
  name='Dancers&Singers' if ['dancers','singers'].include?(name.downcase)
  name='Helspawn' if ['hellspawn'].include?(name.downcase)
  name='Daily_Rotation' if ['daily_rotation','dailyrotation','daily'].include?(name.downcase)
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

def stat_modify(x,includerefines=false,includeduel=false) # used to find all stat names regardless of format and turn them into their proper format
  x='HP' if ['hp','health'].include?(x.downcase)
  x='Attack' if ['attack','atk','att','strength','str','magic','mag'].include?(x.downcase)
  x='Speed' if ['spd','speed'].include?(x.downcase)
  x='Defense' if ['defense','def','defence'].include?(x.downcase)
  x='Resistance' if ['res','resistance'].include?(x.downcase)
  x='PairUp' if ['duel','dual','pairup','pair','pair-up'].include?(x.downcase) && includeduel
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
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=stringx if all_commands().include?(a[0])
  nicknames_load()
  unless @aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array)}.map{|q| q[1].downcase}.include?(s)
    if name.nil?
      s=(first_sub(s,find_data_ex(:find_unit,s,event,false,1)[1],'') rescue s)
    else
      s=(first_sub(s,name,'') rescue s)
    end
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
  flowers=nil
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
      end
      transformed=true if ['t','transformed','transform'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
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
      elsif args[i][0,1].downcase=='f' && args[i][1,args[i].length-1].to_i.to_s==args[i][1,args[i].length-1]
        flowers=args[i][1,args[i].length-1].to_i if flowers.nil?
        args[i]=nil
      elsif args[i][0,6].downcase=='flower' && args[i][6,args[i].length-6].to_i.to_s==args[i][6,args[i].length-6]
        flowers=args[i][6,args[i].length-6].to_i if flowers.nil?
        args[i]=nil
      elsif args[i][0,3]=='(+)' # stat names preceeded by a plus sign in parentheses automatically fill the refinement variable
        x=stat_modify(args[i][3,args[i].length-3])
        if ['Attack','Speed','Defense','Resistance'].include?(x)
          refinement=x if refinement.nil?
          args[i]=nil
        end
      elsif args[i].length>9 && (args[i].gsub('(','').gsub(')','')[0,9].downcase=='blessing2' || args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-9,9].downcase=='blessing2')
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing2',''),false,true)
        if ['Attack','Speed','Defense','Resistance','PairUp'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>15 && (['blessingmythical','mythicalblessing'].include?(args[i].gsub('(','').gsub(')','')[0,15].downcase) || ['blessingmythical','mythicalblessing'].include?(args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-15,15].downcase))
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing','').gsub('mythical',''),false,true)
        if ['Attack','Speed','Defense','Resistance','PairUp'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>13 && (['blessingmythic','mythicblessing'].include?(args[i].gsub('(','').gsub(')','')[0,13].downcase) || ['blessingmythic','mythicblessing'].include?(args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-13,13].downcase))
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing','').gsub('mythic',''),false,true)
        if ['Attack','Speed','Defense','Resistance','PairUp'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>8 && (args[i].gsub('(','').gsub(')','')[0,8].downcase=='blessing' || args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-8,8].downcase=='blessing')
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing',''),false,true)
        if ['Attack','Speed','Defense','Resistance','PairUp'].include?(x)
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
        elsif ['flower','flowers'].include?(args[i].gsub('(','').gsub(')','').downcase) && args[i-1].gsub('(','').gsub(')','').to_i.to_s==args[i-1].gsub('(','').gsub(')','') && flowers.nil?
          # the word "flower", if preceeded by a number, will automatically fill the flowers variable with that number
          flowers=args[i-1].gsub('(','').gsub(')','').to_i
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
        elsif flowers.nil?
          flowers=x
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
    flowers=2*@max_rarity_merge[2] if has_any?(args.map{|q| q.downcase},['flower','flowers']) && flowers.nil?
  end
  blessing=[] if blessing.nil?
  if args.map{|q| q.downcase}.include?('duel')
    if blessing.length>0
      x="Duel(#{blessing[0].split('(')[1]}"
    else
      x='Duel(Legendary)'
    end
    blessing.push(x) unless blessing.include?(x)
  end
  blessing=blessing.reject{|q| q.split('(')[1]!=blessing[0].split('(')[1]} if blessing.length>0
  unless mode==1
    rarity=5 if rarity.nil?
    merges=0 if merges.nil?
    flowers=0 if flowers.nil?
    boon='' if boon.nil?
    bane='' if bane.nil?
    summoner='-' if summoner.nil?
    refinement='' if refinement.nil?
  end
  rarity=@max_rarity_merge[0] if !rarity.nil? && rarity>@max_rarity_merge[0]
  merges=@max_rarity_merge[1] if !merges.nil? && merges>@max_rarity_merge[1]
  flowers=2*@max_rarity_merge[1] if !flowers.nil? && flowers>2*@max_rarity_merge[2]
  return [rarity,merges,boon,bane,summoner,refinement,blessing,transformed,flowers]
end

def apply_stat_skills(event,skillls,stats,tempest='',summoner='-',weapon='',refinement='',blessing=[],transformed=false,ignoremax=false) # used to add skill stat increases to a unit's stats
  skillls=skillls.map{|q| q}
  if weapon.nil? || weapon=='' || weapon==' ' || weapon=='-'
  else # this is the weapon's stat effect
    s2=find_skill(weapon,event)
    if !s2.nil? && s2[6]=='Weapon' && !s2[17].nil? && !refinement.nil? && refinement.length>0 && (s2[7]!='Staff Users Only' || refinement=='Effect')
      # weapon refinement...
      if find_effect_name(s2,event).length>0
        zzz2=find_effect_name(s2,event,1)
        lookout=lookout_load('StatSkills',['Stat-Affecting 1','Stat-Affecting 2'])
        if refinement=='Effect' && find_effect_name(s2,event,1).length>0 && lookout.map{|q| q[0]}.include?(zzz2) # ...including any stat-based Effect Modes
          x=find_effect_name(s2,event,1)
          skillls.push("#{x[1]}#{' ' unless x[1][-1,1]=='+'}#{x[2]}")
        end
      end
      sttz=[]
      inner_skill=s2[17]
      mt=[0,0,0,0,0]
      mt[1]=1 if s2[11].include?('Silver')
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
    s2=find_skill(weapon,event)
    s2[14]=[0,0,0,0,0] if s2[14].nil? || !s2.is_a?(Array) || s2[14].length<=0
    stats[1]+=sttz[ks][0]
    stats[2]+=s2[14][1]+sttz[ks][1]
    stats[3]+=s2[14][2]+sttz[ks][2]
    stats[4]+=s2[14][3]+sttz[ks][3]
    stats[5]+=s2[14][4]+sttz[ks][4]
    if s2[7].include?('Beasts Only') && transformed
      stats[2]+=s2[14][6]
      stats[3]+=s2[14][7]
      stats[4]+=s2[14][8]
      stats[5]+=s2[14][9]
    end
  end
  negative=[0,0,0,0,0]
  rally=[0,0,0,0,0]
  if skillls.length>0
    lookout=lookout_load('StatSkills',['Stat-Affecting','Stat-Buffing','Stat-Nerfing'],1)
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
    if blessing[i].include?('PairUp')
    else
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
  if skillls.include?('Chaos Named')
    kxs=[[stats[2]-15,2],[stats[3],3],[stats[4],4],[stats[5],5]]
    kxs.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}
    kxs=kxs.reject{|q| q[0]!=kxs[0][0]}.map{|q| q[1]}
    for i in 0...kxs.length
      stats[kxs[i]]-=5
    end
  end
  return stats
end

def apply_combat_buffs(event,skillls,stats,phase) # used to apply in-combat buffs
  k=0
  k=event.server.id unless event.server.nil?
  skillls=skillls.map{|q| q}
  close=[0,0,0,0,0,0]
  distant=[0,0,0,0,0,0]
  lookout=lookout_load('StatSkills',['Enemy Phase','Player Phase','In-Combat Buffs 1','In-Combat Buffs 2'])
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
  lookout=lookout_load('StatSkills',['Stat-Affecting 1'])
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
  lookout=lookout_load('StatSkills',['Stat-Affecting 2'])
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
      a=@dev_units[dv][10].reject{|q| q.include?('~~')}
      x=[a[a.length-1],@dev_units[dv][13]]
      for i in 0...x.length
        stat_skills.push(x[i]) if lokoout.include?(x[i])
      end
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    return stat_skills if x2.nil?
    a=x[x2][10].reject{|q| q.include?('~~')}
    xa=[a[a.length-1],x[x2][13]]
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
  lookout=lookout_load('StatSkills',['Stat-Buffing 1','Stat-Nerfing 1'])
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
      a=@dev_units[dv][10].reject{|q| q.include?('~~')}
      x=[a[a.length-1],@dev_units[dv][13]]
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
  lookout=lookout_load('StatSkills',['Stat-Buffing 2','Stat-Nerfing 2'])
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
  end
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil? || (lookout[skl][5] && j[1][1]!=lookout[skl][1].split(' ')[1][0,6].gsub('s',''))
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
  lookout=lookout_load('StatSkills',['Stat-Buffing 3','Stat-Nerfing 3'])
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
  lookout=lookout_load('StatSkills',['Enemy Phase','Player Phase','In-Combat Buffs 1'])
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
      a=@dev_units[dv][10].reject{|q| q.include?('~~')}
      x=[a[a.length-1],@dev_units[dv][13]]
      for i in 0...x.length
        stat_skills_3.push(x[i]) if lokoout.include?(x[i])
      end
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    unless x2.nil?
      a=x[x2][10].reject{|q| q.include?('~~')}
      xa=[a[a.length-1],x[x2][13]]
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
  lookout=lookout_load('StatSkills',['In-Combat Buffs 2'])
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
  end
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil? || (lookout[skl][5] && j[1][1]!=lookout[skl][1].split(' ')[1][0,6].gsub('s',''))
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
  d=@units[j] unless j.is_a?(Array)
  d=j.map{|q| q} if j.is_a?(Array)
  return nil if d.nil?
  return 'http://vignette.wikia.nocookie.net/fireemblem/images/0/04/Kiran.png' if d[0]=='Kiran'
  return bot.user(d[13][1]).avatar_url if d.length>13 && !d[13].nil? && !d[13][1].nil? && d[13][1].is_a?(Integer) && !bot.user(d[13][1]).nil?
  if event.message.text.downcase.include?('face') || rand(1000).zero?
    return 'https://cdn.discordapp.com/emojis/418140222530912256.png' if d[0]=='Nino(Launch)'
    return 'https://cdn.discordapp.com/emojis/420339780421812227.png' if d[0]=='Amelia'
  elsif event.message.text.downcase.include?('face') || rand(100).zero?
    return 'https://cdn.discordapp.com/emojis/418140222530912256.png' if d[0]=='Nino(Launch)'
  elsif event.message.text.downcase.include?('creep') || event.message.text.downcase.include?('grin') || rand(100).zero?
    return 'https://cdn.discordapp.com/emojis/420339781524783114.png' if d[0]=='Reinhardt(Bonds)'
    return 'https://cdn.discordapp.com/emojis/437515327652364288.png' if d[0]=='Reinhardt(World)'
  end
  return 'https://cdn.discordapp.com/emojis/437519293240836106.png' if d[0]=='Arden' && (event.message.text.downcase.include?('woke') || rand(100).zero?)
  return 'https://cdn.discordapp.com/emojis/420360385862828052.png' if d[0]=='Sakura' && event.message.text.downcase.include?("mathoo's")
  dd=d[0].gsub(' ','_')
  args=event.message.text.downcase.split(' ')
  if has_any?(args,['battle','attacking'])
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/BtlFace_BU.png"
  elsif has_any?(args,['damage','damaged','lowhealth','lowhp','low_health','low_hp','injured'])
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/BtlFace_BU_D.png"
  end
  return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/Face_FC.png"
end

def unit_color(event,j,name=nil,mode=0,m=false,chain=false) # used to choose the color of the sidebar used by must embeds including units.
  xcolor=0xFFD800
  jj=@units[j] unless j.is_a?(Array)
  jj=j.map{|q| q} if j.is_a?(Array)
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
  return false
end

def unit_clss(bot,event,j,name=nil) # used by almost every command involving a unit to figure out how to display their weapon and movement class
  jj=@units[j] unless j.is_a?(Array)
  jj=j.map{|q| q} if j.is_a?(Array)
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
  moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_#{clr}_#{wpn}"} if jj[11][0]=='DL' && clr != 'Gold' && wpn != 'Unknown'
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
  elsif ['Tome', 'Dragon', 'Bow', 'Dagger'].include?(w) || (w=='Healer' && alter_classes(event,'Colored Healers')) || jj[1][1]=='Beast'
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
  moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_Mov_#{mov}"} if jj[11][0]=='DL'
  memote=''
  memote=moji[0].mention unless moji.length<=0
  lemote1=''
  lemote2=''
  dancer=''
  sklz=@skills.map{|q| q}
  dancer="\n<:Assist_Music:454462054959415296> *Dancer*" if !sklz.find_index{|q| q[1]=='Dance'}.nil? && sklz[sklz.find_index{|q| q[1]=='Dance'}][11].map{|q| q.split(', ').include?(jj[0])}.include?(true)
  dancer="\n<:Assist_Music:454462054959415296> *Singer*" if !sklz.find_index{|q| q[1]=='Sing'}.nil? && sklz[sklz.find_index{|q| q[1]=='Sing'}][11].map{|q| q.split(', ').include?(jj[0])}.include?(true)
  if !jj[2].nil? && jj[2][0]!=' '
    element='Unknown'
    element=jj[2][0] if ['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima'].include?(jj[2][0])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
    moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_LElement_#{element}"} if jj[11][0]=='DL'
    lemote1=moji[0].mention unless moji.length<=0
    stat='Spectrum'
    stat=jj[2][1] if ['Attack','Speed','Defense','Resistance','Duel'].include?(jj[2][1])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{stat}"}
    moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_LBoost_#{stat}"} if jj[11][0]=='DL'
    lemote2=moji[0].mention unless moji.length<=0
  end
  lm='Legendary/Mythic'
  lm='Legendary' if ['Fire','Water','Wind','Earth'].include?(jj[2][0])
  lm='Mythic' if ['Light','Dark','Astra','Anima'].include?(jj[2][0])
  return "#{wemote} #{w}\n#{memote} *#{m}*#{dancer}#{"\n#{lemote1}*#{jj[2][0]}* / #{lemote2}*#{jj[2][1].gsub('Duel','Pair-Up')}* #{lm} Hero" unless jj[2][0]==" "}#{"\n<:Current_Arena_Bonus:498797967042412544> Current Arena Bonus unit" if get_bonus_units('Arena').include?(jj[0])}#{"\n<:Current_Tempest_Bonus:498797966740422656> Current Tempest Bonus unit" if get_bonus_units('Tempest').include?(jj[0])}#{"\n<:Current_Aether_Bonus:510022809741950986> Current Aether Bonus unit" if get_bonus_units('Aether').include?(jj[0])}"
end

def unit_moji(bot,event,j=-1,name=nil,m=false,mode=0,uuid=-1) # used primarily by the BST and Alt commands to display a unit's weapon and movement classes as emojis
  return '' if was_embedless_mentioned?(event) && mode%4<2
  if j.is_a?(Array)
    jj=j.map{|q| q}
  else
    return '' if name.nil? && j<0
    j=@units.find_index{|q| q[0]==name} if j<0
    return '' if j.nil?
    jj=@units[j]
  end
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
  moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_#{clr}_#{wpn}"} if jj[11][0]=='DL' && clr != 'Gold' && wpn != 'Unknown'
  wemote=moji[0].mention unless moji.length<=0
  unless jj[1][2].nil? || name=='Robin (Shared stats)'
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{jj[1][2]}_#{wpn}"}
    wemote=moji[0].mention unless moji.length<=0
  end
  return wemote if mode%2==1
  mov='Unknown'
  mov=jj[3] if ['Infantry','Armor','Flier','Cavalry'].include?(jj[3])
  moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{mov}"}
  moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_Mov_#{mov}"} if jj[11][0]=='DL'
  memote=''
  memote=moji[0].mention unless moji.length<=0
  dancer=''
  data_load()
  sklz=@skills.map{|q| q}
  dancer='<:Assist_Music:454462054959415296>' if !sklz.find_index{|q| q[1]=='Dance'}.nil? && sklz[sklz.find_index{|q| q[1]=='Dance'}][11].map{|q| q.split(', ').include?(jj[0])}.include?(true)
  dancer='<:Assist_Music:454462054959415296>' if !sklz.find_index{|q| q[1]=='Sing'}.nil? && sklz[sklz.find_index{|q| q[1]=='Sing'}][11].map{|q| q.split(', ').include?(jj[0])}.include?(true)
  lemote1=''
  lemote2=''
  if !jj[2].nil? && jj[2][0]!=' '
    element='Unknown'
    element=jj[2][0] if ['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima'].include?(jj[2][0])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
    moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_LElement_#{element}"} if jj[11][0]=='DL'
    lemote1=moji[0].mention unless moji.length<=0
    stat='Spectrum'
    stat=jj[2][1] if ['Attack','Speed','Defense','Resistance','Duel'].include?(jj[2][1])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{stat}"}
    moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_LBoost_#{stat}"} if jj[11][0]=='DL'
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
  semoji=''
  semoji='<:class_beast_gold:562413138356731905>' if jj[11][0]=='FGO'
  semoji='<:Tribe_Dragon:549947361745567754>' if jj[11][0]=='DL'
  return "#{wemote}#{memote}#{dancer}#{lemote1}#{lemote2}#{semoji}#{"<:Current_Arena_Bonus:498797967042412544>" if get_bonus_units('Arena').include?(jj[0]) && mode%8<4}#{"<:Current_Tempest_Bonus:498797966740422656>" if get_bonus_units('Tempest').include?(jj[0]) && mode%8<4}#{"<:Current_Aether_Bonus:510022809741950986>" if get_bonus_units('Aether').include?(jj[0]) && mode%8<4}#{semote}"
end

def skill_moji(k,event,bot)
  m=''
  if k[6]=='Weapon'
    m="#{m}<:Skill_Weapon:444078171114045450>"
    m="#{m}<:Red_Blade:443172811830198282>" if k[7]=='Sword Users Only'
    m="#{m}<:Blue_Blade:467112472768151562>" if k[7]=='Lance Users Only'
    m="#{m}<:Green_Blade:467122927230386207>" if k[7]=='Axe Users Only'
    m="#{m}<:Red_Tome:443172811826003968>" if k[7]=='Red Tome Users Only'
    m="#{m}<:Blue_Tome:467112472394858508>" if k[7]=='Blue Tome Users Only'
    m="#{m}<:Green_Tome:467122927666593822>" if k[7]=='Green Tome Users Only'
    m="#{m}<:Gold_Dragon:443172811641454592>" if k[7]=='Dragons Only'
    m="#{m}<:Gold_Bow:443172812492898314>" if k[7]=='Bow Users Only'
    m="#{m}<:Gold_Dagger:443172811461230603>" if k[7]=='Dagger Users Only'
    m="#{m}<:Gold_Staff:443172811628871720>" if k[7]=='Staff Users Only' && alter_classes(event,'Colored Healers')
    m="#{m}<:Colorless_Staff:443692132323295243>" if k[7]=='Staff Users Only' && !alter_classes(event,'Colored Healers')
    if k[7].split(', ')[0]=='Beasts Only'
      m="#{m}<:Gold_Beast:532854442299752469>"
      m2=k[7].split(', ')[1].split(' ').map{|q| q.gsub('s','')}.reject{|q| !['Infantry','Armor','Flier','Cavalry'].include?(q)}
      for i in 0...m2.length
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{m2[i]}"}
        m="#{m}#{moji[0].mention}" if moji.length>0
      end
    end
  elsif k[6]=='Assist'
    m="#{m}<:Skill_Assist:444078171025965066>"
    m="#{m}<:Assist_Music:454462054959415296>" if k[13].include?('Music')
    m="#{m}<:Assist_Rally:454462054619807747>" if k[13].include?('Rally')
    m="#{m}<:Assist_Staff:454451496831025162>" if k[7]=='Staff Users Only'
  elsif k[6]=='Special'
    m="#{m}<:Skill_Special:444078170665254929>"
    m="#{m}<:Special_Offensive:454460020793278475>" if k[13].include?('Offensive')
    m="#{m}<:Special_Defensive:454460020591951884>" if k[13].include?('Defensive')
    m="#{m}<:Special_AoE:454460021665693696>" if k[13].include?('AoE')
    m="#{m}<:Special_Healer:454451451805040640>" if k[7]=='Staff Users Only'
  else
    m="#{m}<:Passive_A:443677024192823327>" if k[6].split(', ').include?('Passive(A)')
    m="#{m}<:Passive_B:443677023257493506>" if k[6].split(', ').include?('Passive(B)')
    m="#{m}<:Passive_C:443677023555026954>" if k[6].split(', ').include?('Passive(C)')
    m="#{m}<:Passive_S:443677023626330122>" if k[6].split(', ').include?('Passive(S)') || k[6].split(', ').include?('Seal')
    m="#{m}<:Passive_W:443677023706152960>" if k[6].split(', ').include?('Passive(W)')
  end
  return m
end

def skill_tier(name,event) # used by the "used a non-plus version of a weapon that has a + form" tooltip in the stats command to figure out the tier of the weapon
  data_load()
  s=@skills.map{|q| q}
  j=s[s.find_index{|q| q[1]==name}]
  return 1 if j[10]=='-'
  return 1+skill_tier(j[10].gsub(' or ',' ').gsub('*','').split(', ')[0],event) if j[10].include?(', or ')
  return 1+skill_tier(j[10].gsub('*','').split(' or ')[0],event) if j[10].include?(' or ')
  return 1+skill_tier(j[10].gsub('*','').split(', ')[0],event) if j[10].include?(', ')
  return 1+skill_tier(j[10].gsub('*',''),event)
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
  j=@units[j] unless j.is_a?(Array)
  blessing=[] if blessing.nil?
  stat_skills=[] if stat_skills.nil?
  for i in 0...stat_skills.length
    if stat_skills[i][0,20]=='Color Duel Movement '
      if j[1][0]=='Gold'
        stat_skills[i]=stat_skills[i].gsub('Color',j[1][0][0,2]).gsub('Movement',j[3].gsub('Flier','Flying'))
      else
        stat_skills[i]=stat_skills[i].gsub('Color',j[1][0][0,1]).gsub('Movement',j[3].gsub('Flier','Flying'))
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
    stat_skills_2[i]="Hone #{j[3].gsub('Flier','Fliers')}" if stat_skills_2[i]=='Hone Movement'
    stat_skills_2[i]="Fortify #{j[3].gsub('Flier','Fliers')}" if stat_skills_2[i]=='Fortify Movement'
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
  lookout=lookout_load('StatSkills',['Stat-Buffing 1','Stat-Nerfing 1'])
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
    stat_skills_3[i]="Goad #{j[3].gsub('Flier','Fliers')}" if stat_skills_3[i]=='Goad Movement'
    stat_skills_3[i]="Ward #{j[3].gsub('Flier','Fliers')}" if stat_skills_3[i]=='Ward Movement'
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
  return "#{str}Equipped weapon: #{weapon}\nForm: #{j[1][2]} (transformed)\n" if transformed && j[1][1]=='Beast'
  return "#{str}Equipped weapon: #{weapon}\nForm: Humanoid\n" if !transformed && j[1][1]=='Beast'
  return "#{str}Equipped weapon: #{weapon}\n"
end

def display_stars(bot,event,rarity,merges,support='-',flowers=['Infantry',0],expandedmode=false,game='FEH',mathoos=false) # used to determine which star emojis should be used, based on the rarity, merge count, and whether the unit is Summoner Supported
  if game=='DL'
    emo="#{['','<:Rarity_1:532086056594440231>','<:Rarity_2:532086056254963713>','<:Rarity_3:532086056519204864>','<:Rarity_4:532086056301101067>','<:Rarity_5:532086056737177600>'][rarity]*rarity}#{['','<:Rarity_1_Blank:555459856476274691>','<:Rarity_2_Blank:555459856400908299>','<:Rarity_3_Blank:555459856568418314>','<:Rarity_4_Blank:555459856497246218>','<:Rarity_5_Blank:555459856190930955>'][rarity]*(5-rarity)}"
    return "**#{rarity}-star#{" +#{merges}" unless merges.zero? && !expandedmode}**#{"  \u00B7  <:Lovewhistle:575233033024569365>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}#{"  \u00B7  <:Clover:575230371587948568>**x#{flowers[1]}**" unless flowers[1]<=0 && !expandedmode}" if rarity>@rarity_stars.length
    return "#{emo}#{"**+#{merges}**" unless merges.zero? && !expandedmode}#{"  \u00B7  <:Lovewhistle:575233033024569365>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}#{"  \u00B7  <:Clover:575230371587948568>**x#{flowers[1]}**" unless flowers[1]<=0 && !expandedmode}"
  elsif game=='FGO'
    emo=['','<:FGO_icon_rarity_dark:571937156981981184>','<:FGO_icon_rarity_sickly:571937157095227402>','<:FGO_icon_rarity_rust:523903558928826372>','<:FGO_icon_rarity_mono:523903551144198145>','<:FGO_icon_rarity_gold:523858991571533825>'][rarity]*rarity
    return "**#{rarity}-star#{" +#{merges}" unless merges.zero? && !expandedmode}**#{"  \u00B7  <:heart_of_the_foreign_god:523843133247848450>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}#{"  \u00B7  <:Final_Fragment:575255136012730368>**x#{flowers[1]}**" unless flowers[1]<=0 && !expandedmode}" if rarity>@rarity_stars.length
    return "#{emo}#{"**+#{merges}**" unless merges.zero? && !expandedmode}#{"  \u00B7  <:heart_of_the_foreign_god:523843133247848450>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}#{"  \u00B7  <:Final_Fragment:575255136012730368>**x#{flowers[1]}**" unless flowers[1]<=0 && !expandedmode}"
  end
  emo=@rarity_stars[rarity-1]
  if merges==@max_rarity_merge[1]
    emo='<:Icon_Rarity_4p10:448272714210476033>' if rarity==4
    emo='<:Icon_Rarity_5p10:448272715099406336>' if rarity==5
    emo='<:Icon_Rarity_6p10:491487784822112256>' if rarity>5
  end
  devunits_load()
  if event.message.text.downcase.split(' ').include?("mathoo's") && mathoos
    emo='<:FEH_rarity_M:577779126891577355>'
    emo='<:FEH_rarity_Mp10:577779126853959681>' if rarity>=5 && merges==@max_rarity_merge[1]
  end
  emo='<:Icon_Rarity_S:448266418035621888>' unless support=='-'
  emo='<:Icon_Rarity_Sp10:448272715653054485>' if rarity>=5 && merges==@max_rarity_merge[1] && support != '-'
  femote='<:Dragonflower_Infantry:541170819980722176>'
  moji=bot.server(449988713330769920).emoji.values.reject{|q| q.name != "Dragonflower_#{flowers[0]}"}
  femote=moji[0].mention if moji.length>0
  return "**#{rarity}-star#{" +#{merges}" unless merges.zero? && !expandedmode}**#{"  \u00B7  <:Icon_Support:448293527642701824>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}#{"  \u00B7  #{femote}**x#{flowers[1]}**" unless flowers[1]<=0 && !expandedmode}" if rarity>@rarity_stars.length
  return "#{emo*rarity}#{"**+#{merges}**" unless merges.zero? && !expandedmode}#{"  \u00B7  <:Icon_Support:448293527642701824>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}#{"  \u00B7  #{femote}**x#{flowers[1]}**" unless flowers[1]<=0 && !expandedmode}"
end

def get_unit_prf(name)
  if name=='Robin'
    return [get_unit_prf('Robin(M)')[0],get_unit_prf('Robin(F)')[0]]
  end
  prfs=@skills.reject{|q| !q[8].split(', ').include?(name) || q[6]!='Weapon' || ['Ragnarok+','Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(q[1])}
  if prfs.length>1
    prfs2=prfs.reject{|q| q[10]!='-'}
    prfs2=prfs.reject{|q| q[11].reject{|q2| !q2.split(', ').include?(name)}.length<=0} if prfs2.length<=0
    prfs2=prfs.reject{|q| q[12].reject{|q2| !q2.split(', ').include?(name)}.length<=0} if prfs2.length<=0
    prfs=[prfs2[0]]
  elsif prfs.length<=0 
    # include the same code as the summoned modifier
  end
  return [prfs[0][1]] if prfs.length>0
  return ['-']
end

def has_weapon_tag?(tag,wpn,refinement=nil,transformed=false)
  return false if wpn.nil? || wpn.length<=0
  return true if wpn[11].include?(tag)
  return true if wpn[11].include?("(E)#{tag}") && refinement=='Effect'
  return true if wpn[11].include?("(R)#{tag}") && !refinement.nil? && refinement.length>0
  return true if wpn[11].include?("(T)#{tag}") && transformed
  return true if wpn[11].include?("(TE)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[11].include?("(ET)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[11].include?("(T)(E)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[11].include?("(E)(T)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[11].include?("(TR)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[11].include?("(RT)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[11].include?("(T)(R)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[11].include?("(R)(T)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return false
end

def has_weapon_tag2?(tag,wpn,refinement=nil,transformed=false)
  return false if wpn.nil? || wpn.length<=0
  return true if wpn[13].include?(tag)
  return true if wpn[13].include?("(E)#{tag}") && refinement=='Effect'
  return true if wpn[13].include?("(R)#{tag}") && !refinement.nil? && refinement.length>0
  return true if wpn[13].include?("(T)#{tag}") && transformed
  return true if wpn[13].include?("(TE)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[13].include?("(ET)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[13].include?("(T)(E)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[13].include?("(E)(T)#{tag}") && transformed && refinement=='Effect'
  return true if wpn[13].include?("(TR)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[13].include?("(RT)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[13].include?("(T)(R)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return true if wpn[13].include?("(R)(T)#{tag}") && transformed && !refinement.nil? && refinement.length>0
  return false
end

def smol_err(event,ignore=false,smol=false)
  if !smol || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
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

def disp_stats(bot,name,weapon,event,sizex='smol',ignore=false,skillstoo=false) # displays stats
  args=event.message.text.downcase.split(' ')
  if has_any?(args,['tiny','small','smol','micro','little'])
    sizex='xsmol'
  elsif has_any?(args,['big','tol','macro','large'])
    sizex='medium'
  elsif has_any?(args,['huge','massive'])
    sizex='giant'
  end
  if sizex=='giant' && !safe_to_spam?(event)
    event.respond "I will not wipe the chat completely clean.  Please use this command in PM.\nIn the meantime, I will show the standard form of this command."
    sizex='medium'
  end
  name='Robin' if name==['Robin(M)', 'Robin(F)'] || name==['Robin(F)', 'Robin(M)']
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      disp_stats(bot,name[i],weapon,event,sizex,ignore,skillstoo)
    end
    return nil
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args.compact!
  if name.nil?
    if args.nil? || args.length<1
      smol_err(event,ignore,['smol','xsmol'].include?(sizex))
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
  flowers=flurp[8]
  unitz=find_unit(name,event)
  if name=='Robin' && unitz[0].is_a?(Array)
    unitz=unitz[0]
    unitz[0]='Robin (Shared stats)'
    unitz[1][0]='Cyan'
  end
  if unitz[0].is_a?(Array)
    for i in 0...name.length
      disp_stats(bot,unitz[i][0],weapon,event,sizex,ignore,skillstoo)
    end
    return nil
  elsif unitz.length<=0
    smol_err(event,ignore,['smol','xsmol'].include?(sizex))
    return nil
  elsif untz.find_index{|q| q[0]==name}.nil?
  elsif name=='Robin'
  elsif ['Fire','Earth','Water','Wind'].include?(unitz[2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Legendary','Mythical') unless blessing[i][0,5]=='Duel('
    end
  elsif ['Light','Dark','Astra','Anima'].include?(unitz[2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Mythical','Legendary') unless blessing[i][0,5]=='Duel('
    end
  end
  blessing.compact!
  flowers=[@max_rarity_merge[2],flowers].min unless name=='Robin' || (unitz[9][0].include?('PF') && unitz[3]=='Infantry')
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  tempest=get_bonus_type(event)
  diff_num=[0,'','']
  sp=0
  spec_wpn=false
  pair_up=[]
  if event.message.text.downcase.split(' ').include?("mathoo's")
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
      flowers=@dev_units[dv][6]
      weaponz=@dev_units[dv][7].reject{|q| q.include?('~~')}
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
      sp=400 unless @skills[@skills.find_index{|q| q[1]==weapon}][8]=='-'
      for i in 8...13
        zzzzz=@dev_units[dv][i].reject{|q| q.include?('~~')}[-1]
        sp+=@skills[@skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==zzzzz}][3] unless zzzzz.nil? || @skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==zzzzz}.nil?
      end
      zzzzz=@dev_units[dv][13]
      sp+=@skills[@skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==zzzzz}][3] unless zzzzz.nil? || @skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==zzzzz}.nil?
      unless @dev_units[dv][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        pair_up=[@dev_units[dv][14]]
        dv2=find_in_dev_units(pair_up[0])
        if dv2>=0
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],true,2)}",'Pair-Up cohort']
          pair_up[0][2]='Pocket companion' if pair_up[0][0].include?('Sakura')
          pair_up.push(@dev_units[dv2][1])
          pair_up.push(@dev_units[dv2][2])
          pair_up.push(@dev_units[dv2][3].gsub(' ',''))
          pair_up.push(@dev_units[dv2][4].gsub(' ',''))
          pair_up.push(@dev_units[dv2][5])
          pair_up.push(@dev_units[dv2][6])
          weaponz=@dev_units[dv2][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=@dev_units[dv2][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],@dev_units[dv2][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
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
      flowers=x[x2][6]
      weaponz=x[x2][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        spec_wpn=true
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
        sp=350
        sp=400 unless @skills[@skills.find_index{|q| q[1]==weapon}][8]=='-'
      else
        spec_wpn=true
        refinement=nil
        sp=300
        sp=400 unless @skills[@skills.find_index{|q| q[1]==weapon}][8]=='-'
      end
      for i in 8...13
        zzzzz=x[x2][i].reject{|q| q.include?('~~')}[-1]
        sp+=@skills[@skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==zzzzz}][3] unless zzzzz.nil? || @skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==zzzzz}.nil?
      end
      zzzzz=x[x2][13]
      sp+=@skills[@skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==zzzzz}][3] unless zzzzz.nil? || @skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==zzzzz}.nil?
      unless x[x2][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        x3=x.find_index{|q| q[0]==x[x2][14]}
        unless x3.nil?
          pair_up=[x[x2][14]]
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],false,2,uid)}",'Pair-Up cohort']
          pair_up.push(x[x3][1])
          pair_up.push(x[x3][2])
          pair_up.push(x[x3][3].gsub(' ',''))
          pair_up.push(x[x3][4].gsub(' ',''))
          pair_up.push(x[x3][5])
          pair_up.push(x[x3][6])
          weaponz=x[x3][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=x[x3][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],x[x3][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    end
  elsif args.map{|q| q.downcase}.include?('summoned')
    if name=='Robin'
      uskl=unit_skills('Robin(M)',event,true,rarity,false,true)[0].reject{|q| q.include?('~~')}
      uskl2=unit_skills('Robin(F)',event,true,rarity,false,true)[0].reject{|q| q.include?('~~')}
      weapon='-'
      weapon2='-'
      weapon=uskl[uskl.length-1] if uskl.length>0
      weapon2=uskl2[uskl2.length-1] if uskl2.length>0
      w2=find_skill(weapon,event)
      w22=find_skill(weapon2,event)
      diff_num=[w2[4]-w22[4],'M','F']
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
  elsif args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0,0,0]
      else
        spec_wpn=true
        w2=find_skill(weapon,event)
      end
      if weapon2=='-'
        w22=['-',0,0,0,0]
      else
        spec_wpn=true
        w22=find_skill(weapon2,event)
      end
      diff_num=[w2[4]-w22[4],'M','F']
    end
  end
  w2=find_skill(weapon,event)
  if w2[17].nil?
    refinement=nil
  elsif w2[17].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[17][0,1].to_i.to_s==w2[17][0,1] && refinement=='Effect'
    refinement=nil if w2[17][1,1]=='*'
  elsif w2[17][0,1]=='-' && w2[17][1,1].to_i.to_s==w2[17][1,1] && refinement=='Effect'
    refinement=nil if w2[17][2,1]=='*'
  end
  refinement=nil if w2[7]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[7]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
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
  if sizex=='xsmol'
    stat_skills_2=[]
    if wl.include?('~~')
      weapon=''
      wl=''
    end
  end
  dispgps=false
  dispgps=true if has_any?(args.map{|q| q.downcase},['gps','gp','growths','growth'])
  sizex='smol' if sizex != 'medium' && !wl.include?('~~') && (stat_skills_2.length<=0 || unitz[0]=='Kiran') && !dispgps && !(event.server.nil? || event.server.id==238059616028590080) && event.channel.id != 362017071862775810
  sizex='medium' if (wl.include?('~~') || (stat_skills_2.length>0 && unitz[0]!='Kiran') || dispgps) && sizex != 'xsmol'
  if unitz.length<=0
    smol_err(event,ignore,['smol','xsmol'].include?(sizex))
    return nil
  elsif (unitz[4].nil? || (unitz[4].max<=0 && unitz[5].max<=0)) && unitz[0]!='Kiran' # unknown stats
    data_load()
    xcolor=unit_color(event,unitz,unitz[0],0,mu)
    create_embed(event,["__**#{unitz[0]}**__",unit_clss(bot,event,unitz)],'',xcolor,'Stats currently unknown',pick_thumbnail(event,unitz,bot))
    disp_unit_skills(bot,unitz[0],event) if skillstoo || sizex=='giant'
    return nil
  elsif unitz[0]=='Kiran'
    data_load()
    j=untz[0]
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
    if ['smol','xsmol'].include?(sizex)
      create_embed(event,["__**#{j[0]}**__",unit_clss(bot,event,j)],"#{display_stars(bot,event,rarity,merges,'-',[j[3],flowers],false,j[11][0])}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{unit_clss(bot,event,j2)}\n**<:HP_S:514712247503945739>0 | <:StrengthS:514712248372166666>0 | <:SpeedS:514712247625580555>0 | <:DefenseS:514712247461871616>0 | <:ResistanceS:514712247574986752>0** (0 BST, Score: #{115+2*merges})",0x9400D3,nil,pick_thumbnail(event,j,bot),nil,1)
    else
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
      create_embed(event,["__**#{untz[j][0]}**__",unit_clss(bot,event,j)],"#{display_stars(bot,event,rarity,merges,'-',[untz[j][3],flowers],sizex=='giant',j[11][0])}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n",0x9400D3,"Please note that the Attack stat displayed here does not include weapon might.  The Attack stat in-game does.",pick_thumbnail(event,j,bot),flds,1)
    end
    return nil
  elsif unitz[4].max<=0 # level 40 stats are known but not level 1
    data_load()
    merges=0 if merges.nil?
    xcolor=unit_color(event,untz.find_index{|q| q[0]==unitz[0]},unitz[0],0,mu)
    atk='<:StrengthS:514712248372166666> Attack'
    atk='<:MagicS:514712247289774111> Magic' if ['Tome','Dragon','Healer'].include?(unitz[1][1])
    atk='<:StrengthS:514712248372166666> Strength' if ['Blade','Bow','Dagger','Beast'].include?(unitz[1][1])
    zzzl=find_weapon(weapon,event)
    atk='<:FreezeS:514712247474585610> Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
    if unitz[11][0]=='DL'
      atk='<:Strength:573344931205349376> Attack'
      atk='<:Strength:573344931205349376> Magic' if ['Tome','Dragon','Healer'].include?(unitz[1][1])
      atk='<:Strength:573344931205349376> Strength' if ['Blade','Bow','Dagger','Beast'].include?(unitz[1][1])
      atk='<:Strength:573344931205349376> Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
    end
    n=nature_name(boon,bane)
    unless n.nil?
      n=n[0] if atk=='<:StrengthS:514712248372166666> Strength'
      n=n[n.length-1] if atk=='<:MagicS:514712247289774111> Magic'
      n=n.unitzoin(' / ') if ['<:StrengthS:514712248372166666> Attack','<:FreezeS:514712247474585610> Freeze'].include?(atk)
    end
    atk=atk.gsub(' Freeze',' Attack').gsub(' Strength',' Attack').gsub(' Magic',' Attack') if weapon != '-'
    u40=[unitz[0],unitz[5][0],unitz[5][1],unitz[5][2],unitz[5][3],unitz[5][4]]
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
    wl=weapon_legality(event,unitz[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
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
    mergetext=''
    if unitz[1][1]=='Beast' && !transformed && !wl.include?('~~') && !['-','',' '].include?(wl) && !w2.nil?
      wlr=wl.split(' (+) ')[0]
      www2=w2[14][5,5]
      www3=www2.reject{|q| q==0}
      sttttz=[]
      if www3.length<=0
      elsif www3.min==www3.max
        sttttz.push('HP') unless www2[0]==0
        sttttz.push('Atk') unless www2[1]==0
        sttttz.push('Spd') unless www2[2]==0
        sttttz.push('Def') unless www2[3]==0
        sttttz.push('Res') unless www2[4]==0
        mergetext="#{mergetext}\n\nWhen transformed: #{'+' if www3[0]>0}#{www3[0]} #{sttttz.join('/')}\nInclude the word \"Transformed\" to apply this directly."
      else
        sttttz.push("#{'+' if www2[0]>0}#{www2[0]} HP") unless www2[0]==0
        sttttz.push("#{'+' if www2[1]>0}#{www2[1]} Atk") unless www2[1]==0
        sttttz.push("#{'+' if www2[2]>0}#{www2[2]} Spd") unless www2[2]==0
        sttttz.push("#{'+' if www2[3]>0}#{www2[3]} Def") unless www2[3]==0
        sttttz.push("#{'+' if www2[4]>0}#{www2[4]} Res") unless www2[4]==0
        mergetext="#{mergetext}\n\nWhen transformed: #{sttttz.join(', ')}\nInclude the word \"Transformed\" to apply this directly."
      end
    end
    ftr=nil
    staticons=['<:HP_S:514712247503945739>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
    staticons=['<:HP:573344832307593216>','<:Speed:573366907357495296>','<:FEHDefense:574702109325262878>','<:Defense:573344832282689567>'] if unitz[11][0]=='DL'
    if ['smol','xsmol'].include?(sizex)
      bb=0
      bb=3 if merges>0
      create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0]}#{unit_moji(bot,event,unitz,u40[0],mu,2)}**__","#{display_stars(bot,event,5,merges,summoner,[unitz[3],flowers],false,unitz[11][0],mu)}\n*Neutral Nature only so far*\n#{display_stat_skills(unitz,stat_skills,[],nil,tempest,blessing,transformed,wl,false,true)}\n**#{staticons[0]}#{u40[1]} | #{atk}#{u40[2]} | #{staticons[1]}#{u40[3]} | #{staticons[2]}#{u40[4]} | #{staticons[3]}#{u40[5]}** (#{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]} BST, Score: #{(u40x2[1]+u40x2[2]+u40x2[3]+u40x2[4]+u40x2[5]+bb)/5+25+merges*2+90+blessing.length*4})#{mergetext}",xcolor,nil,pick_thumbnail(event,unitz,bot),nil,1)
    else
      ftr="Please note that the #{atk.split('> ')[1]} stat displayed here does not include weapon might.  The Attack stat in-game does."
      ftr=nil if weapon != '-'
      flds=[["**Level 1#{" +#{merges}" if merges>0}**","#{staticons[0]} HP: unknown\n#{atk}: unknown\n#{staticons[1]} Speed: unknown\n#{staticons[2]} Defense: unknown\n#{staticons[3]} Resistance: unknown\n\nBST: unknown"],["**Level 40#{" +#{merges}" if merges>0}**","#{staticons[0]} HP: #{u40[1]}\n#{atk}: #{u40[2]}#{"(#{diff_num[1]}) / #{u40[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}\n#{staticons[1]} Speed: #{u40[3]}\n#{staticons[2]} Defense: #{u40[4]}\n#{staticons[3]} Resistance: #{u40[5]}\n\nBST: #{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]}#{"(#{diff_num[1]}) / #{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}"]]
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
      end
      j=untz.find_index{|q| q[0]==unitz[0]}
      create_embed(event,["__#{"Mathoo's " if mu}**#{u40[0]}**__",unit_clss(bot,event,j)],"#{"<:Icon_Rarity_5:448266417553539104>"*5}#{"**+#{merges}**" if merges>0 || sizex=='giant'}#{"  \u2764 **#{summoner}**" unless summoner=='-'}#{"\nNo Summoner Support" if summoner =='-' && sizex=='giant'}\n*Neutral Nature only so far*\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,sizex=='giant')}\n#{mergetext}",xcolor,ftr,pick_thumbnail(event,j,bot),flds,1)
    end
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
  u40=get_stats(event,name,40,rarity,merges,boon,bane,flowers)
  bane2="#{bane}"
  bane2='' if merges>0
  u40x2=get_stats(event,name,40,5,0,boon,bane2)
  u1=get_stats(event,name,1,rarity,merges,boon,bane,flowers)
  if !pair_up.nil? && pair_up.length>0
    u40cu=get_stats(event,pair_up[0][0],40,pair_up[1],pair_up[2],pair_up[3],pair_up[4],pair_up[6])
    u1cu=get_stats(event,pair_up[0][0],1,pair_up[1],pair_up[2],pair_up[3],pair_up[4],pair_up[6])
    m=pair_up[9,pair_up.length-9]
    m=[] if m.nil?
    u1cu=apply_stat_skills(event,m,u1cu,'',pair_up[5],pair_up[7],pair_up[8])
    u40cu=apply_stat_skills(event,m,u40cu,'',pair_up[5],pair_up[7],pair_up[8])
    u1[2]+=(u1cu[2]-25)/10
    u1[3]+=(u1cu[3]-10)/10
    u1[4]+=(u1cu[4]-10)/10
    u1[5]+=(u1cu[5]-10)/10
    u40[2]+=(u40cu[2]-25)/10
    u40[3]+=(u40cu[3]-10)/10
    u40[4]+=(u40cu[4]-10)/10
    u40[5]+=(u40cu[5]-10)/10
  end
  atk='<:StrengthS:514712248372166666> Attack'
  atk='<:MagicS:514712247289774111> Magic' if ['Tome','Dragon','Healer'].include?(unitz[1][1])
  atk='<:StrengthS:514712248372166666> Strength' if ['Blade','Bow','Dagger','Beast'].include?(unitz[1][1])
  zzzl=find_weapon(weapon,event)
  atk='<:FreezeS:514712247474585610> Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='<:StrengthS:514712248372166666> Strength'
    n=n[n.length-1] if atk=='<:MagicS:514712247289774111> Magic'
    n=n.join(' / ') if ['<:StrengthS:514712248372166666> Attack','<:FreezeS:514712247474585610> Freeze'].include?(atk)
  end
  if unitz[11][0]=='DL'
    atk='<:Strength:573344931205349376> Attack'
    atk='<:Strength:573344931205349376> Magic' if ['Tome','Dragon','Healer'].include?(unitz[1][1])
    atk='<:Strength:573344931205349376> Strength' if ['Blade','Bow','Dagger','Beast'].include?(unitz[1][1])
    atk='<:Strength:573344931205349376> Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
  end
  atk=atk.gsub(' Freeze',' Attack').gsub(' Strength',' Attack').gsub(' Magic',' Attack') if weapon != '-'
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
  end
  xcolor=unit_color(event,unitz,u40[0],0,mu)
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
  ftr="Score does not include SP from skills." if rand(10)<5 || ['smol','xsmol'].include?(sizex)
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
    ftr="You equipped the Tier #{tr} version of the weapon.  Perhaps you want #{wl.gsub('~~','').split(' (+) ')[0]}+ ?" unless weapon[weapon.length-1,1]=='+' || @skills.find_index{|q| q[1]=="#{weapon}+"}.nil? || " #{event.message.text.downcase} ".include?(' summoned ') || " #{event.message.text.downcase} ".include?(" mathoo's ") || donate_trigger_word(event)>0
  end
  flds=[]
  mergetext=''
  bb=0
  bb=3 if ['',' ',nil].include?(boon) && merges>0
  bin=((u40x2[1]+u40x2[2]+u40x2[3]+u40x2[4]+u40x2[5]+bb)/5)*5
  staticons=['<:HP_S:514712247503945739>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
  staticons=['<:HP:573344832307593216>','<:Speed:573366907357495296>','<:FEHDefense:574702109325262878>','<:Defense:573344832282689567>'] if unitz[11][0]=='DL'
  if ['smol','xsmol'].include?(sizex)
    ftr="Attack displayed is for #{u40[0].split(' ')[0]}(#{diff_num[1]}).  #{u40[0].split(' ')[0]}(#{diff_num[2]})'s Attack is #{diff_num[0]} point#{'s' unless diff_num[0]==1} lower." if !diff_num.nil? && diff_num[0]>0
    ftr="Attack displayed is for #{u40[0].split(' ')[0]}(#{diff_num[1]}).  #{u40[0].split(' ')[0]}(#{diff_num[2]})'s Attack is #{0-diff_num[0]} point#{'s' unless diff_num[0]==-1} higher." if !diff_num.nil? && diff_num[0]<0
    superbaan=["\u00A0","\u00A0","\u00A0","\u00A0","\u00A0","\u00A0"]
    if boon=="" && bane=="" && !mu && merges==0
      for i in 6...11
        superbaan[i-5]='+' if [-3,1,5,10,14].include?(u40[i]) && rarity==5
        superbaan[i-5]='-' if [-2,2,6,11,15].include?(u40[i]) && rarity==5
        superbaan[i-5]='+' if [-2,10].include?(u40[i]) && rarity==4
        superbaan[i-5]='-' if [-1,11].include?(u40[i]) && rarity==4
      end
    end
    flp=u1[1,5].map{|q| "#{' ' if q<10}#{q}"}.join("\u00A0|")
    flp2=u40[1,5].map{|q| "#{' ' if q<10}#{q}"}
    for i in 0...flp2.length
      flp2[i]="#{flp2[i]}#{superbaan[i+1]}"
    end
    flp2=flp2.join('|')
    bin=[bin,175].max if unitz[2].length>0 && unitz[2][1]=='Duel' && rarity>=5
    mergetext="\u200B\u00A0#{staticons[0]}\u00A0\u200B\u00A0\u200B\u00A0#{atk.split('>')[0]}>\u00A0\u200B\u00A0\u200B\u00A0#{staticons[1]}\u00A0\u200B\u00A0\u200B\u00A0#{staticons[2]}\u00A0\u200B\u00A0\u200B\u00A0#{staticons[3]}\u00A0\u200B\u00A0\u200B\u00A0#{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]}\u00A0BST\u2084\u2080\u00A0\u200B\u00A0\u200B\u00A0Score:\u00A0#{bin/5+merges*2+rarity*5+blessing.length*4+90+sp/100}```#{flp}\n#{flp2}```"
  else
    flds.push(["**Level 1#{" +#{merges}" if merges>0}**",["#{staticons[0]} HP: #{u1[1]}","#{atk}: #{u1[2]}#{"(#{diff_num[1]}) / #{u1[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}","#{staticons[1]} Speed: #{u1[3]}","#{staticons[2]} Defense: #{u1[4]}","#{staticons[3]} Resistance: #{u1[5]}","","BST: #{u1[6]}","Score: #{bin/5+merges*2+rarity*5+blessing.length*4+2+sp/100}#{"+`SP`/100" unless sp>0}"]])
    if rarity>=5 && !stat_skills.nil? && !stat_skills.length.zero?
      lookout=lookout_load('StatSkills',['Stat-Affecting'],1)
      for i in 0...stat_skills.length
        unless lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5].nil?
          bin=[bin,lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5]].max
        end
      end
    end
    if unitz[2].length>0 && unitz[2][1]=='Duel' && rarity>=5
      bin=[bin,175].max
    end
    if dispgps || sizex=='giant'
      flds.push(["**Growth Rates**",["#{staticons[0]} HP: #{micronumber(u40[6])} / #{u40[6]*5+20}%","#{atk}: #{micronumber(u40[7])} / #{u40[7]*5+20}%","#{staticons[1]} Speed: #{micronumber(u40[8])} / #{u40[8]*5+20}%","#{staticons[2]} Defense: #{micronumber(u40[9])} / #{u40[9]*5+20}%","#{staticons[3]} Resistance: #{micronumber(u40[10])} / #{u40[10]*5+20}%","","\u0262\u1D18\u1D1B #{micronumber(u40[6]+u40[7]+u40[8]+u40[9]+u40[10])} / GRT: #{(u40[6]+u40[7]+u40[8]+u40[9]+u40[10])*5+100}%"]])
    end
    flds.push(["**Level 40#{" +#{merges}" if merges>0}**",["#{staticons[0]} HP: #{u40[1]}","#{atk}: #{u40[2]}#{"(#{diff_num[1]}) / #{u40[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}","#{staticons[1]} Speed: #{u40[3]}","#{staticons[2]} Defense: #{u40[4]}","#{staticons[3]} Resistance: #{u40[5]}","","BST: #{u40[16]}","Score: #{bin/5+merges*2+rarity*5+blessing.length*4+90+sp/100}#{"+`SP`/100" unless sp>0}"]])
    superbaan=['','','','','','']
    if boon=="" && bane=="" && !mu && ((stat_skills_2.length<=0 && !wl.include?('~~')) || flds.length==3)
      for i in 6...11
        superbaan[i-5]='(+)' if [-3,1,5,10,14].include?(u40[i]) && rarity==5
        superbaan[i-5]='(-)' if [-2,2,6,11,15].include?(u40[i]) && rarity==5
        superbaan[i-5]='(+)' if [-2,10].include?(u40[i]) && rarity==4
        superbaan[i-5]='(-)' if [-1,11].include?(u40[i]) && rarity==4
        superbaan[i-5]='~~()~~' if superbaan[i-5]=='(-)' && merges>0
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
        if merges>0 && bane==x[i]
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
  end
  if unitz[1][1]=='Beast' && !transformed && !wl.include?('~~') && !['-','',' '].include?(wl) && !w2.nil?
    wlr=wl.split(' (+) ')[0]
    www2=w2[14][5,5]
    www3=www2.reject{|q| q==0}
    sttttz=[]
    chrr="\n"
    chrr='' if ['smol','xsmol'].include?(sizex)
    if www3.length<=0
    elsif www3.min==www3.max
      sttttz.push('HP') unless www2[0]==0
      sttttz.push('Atk') unless www2[1]==0
      sttttz.push('Spd') unless www2[2]==0
      sttttz.push('Def') unless www2[3]==0
      sttttz.push('Res') unless www2[4]==0
      mergetext="#{mergetext}#{chrr}\nWhen transformed: #{'+' if www3[0]>0}#{www3[0]} #{sttttz.join('/')}\nInclude the word \"Transformed\" to apply this directly."
    else
      sttttz.push("#{'+' if www2[0]>0}#{www2[0]} HP") unless www2[0]==0
      sttttz.push("#{'+' if www2[1]>0}#{www2[1]} Atk") unless www2[1]==0
      sttttz.push("#{'+' if www2[2]>0}#{www2[2]} Spd") unless www2[2]==0
      sttttz.push("#{'+' if www2[3]>0}#{www2[3]} Def") unless www2[3]==0
      sttttz.push("#{'+' if www2[4]>0}#{www2[4]} Res") unless www2[4]==0
      mergetext="#{mergetext}#{chrr}\nWhen transformed: #{sttttz.join(', ')}\nInclude the word \"Transformed\" to apply this directly."
    end
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
        sklz2=[@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],@dev_units[dv][12],[@dev_units[dv][13]]]
        uskl=sklz2.map{|q| q.reject{|q2| q2.include?('~~')}}.map{|q| q[q.length-1]}
      end
    elsif donate_trigger_word(event)>0
      uid=donate_trigger_word(event)
      x=donor_unit_list(uid)
      x2=x.find_index{|q| q[0]==name}
      unless x2.nil?
        sklz2=[x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],x[x2][12],[x[x2][13]]]
        uskl=sklz2.map{|q| q.reject{|q2| q2.include?('~~')}}.map{|q| q[q.length-1]}
      end
    end
    flds.push(['Skills',"<:Skill_Weapon:444078171114045450> #{uskl[0]}\n<:Skill_Assist:444078171025965066> #{uskl[1]}\n<:Skill_Special:444078170665254929> #{uskl[2]}\n<:Passive_A:443677024192823327> #{uskl[3]}\n<:Passive_B:443677023257493506> #{uskl[4]}\n<:Passive_C:443677023555026954> #{uskl[5]}#{"\n<:Passive_S:443677023626330122> #{uskl[6]}" unless uskl[6].nil?}"])
  elsif sizex=='giant' && u40[0]!='Robin (Shared stats)'
    uskl=unit_skills(name,event)
    if event.message.text.downcase.include?("mathoo's")
      devunits_load()
      dv=find_in_dev_units(name)
      if dv>=0
        mu=true
        uskl=[@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],@dev_units[dv][12],[@dev_units[dv][13]]]
      end
    elsif donate_trigger_word(event)>0
      uid=donate_trigger_word(event)
      x=donor_unit_list(uid)
      x2=x.find_index{|q| q[0]==name}
      unless x2.nil?
        uskl=[x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],x[x2][12],[x[x2][13]]]
      end
    end
    flds.push(["<:Skill_Weapon:444078171114045450> **Weapons**",uskl[0].reject{|q| ['Falchion','**Falchion**','Missiletainn','**Missiletainn**','Whelp (All)','**Whelp (All)**','Yearling (All)','**Yearling (All)**','Adult (All)','**Adult (All)**'].include?(q)}.join("\n")])
    flds.push(["<:Skill_Assist:444078171025965066> **Assists**",uskl[1].join("\n")])
    flds.push(["<:Skill_Special:444078170665254929> **Specials**",uskl[2].join("\n")])
    flds.push(["<:Passive_A:443677024192823327> **A Passives**",uskl[3].join("\n")])
    flds.push(["<:Passive_B:443677023257493506> **B Passives**",uskl[4].join("\n")])
    flds.push(["<:Passive_C:443677023555026954> **C Passives**",uskl[5].join("\n")])
    flds.push(["<:Passive_S:443677023626330122> **Sacred Seal**",uskl[6].join("\n")]) if uskl.length>6
  end
  img=pick_thumbnail(event,unitz,bot)
  img='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  xtype=1
  xtype=-1 if skillstoo && u40[0]!='Robin (Shared stats)'
  if skillstoo && mu && flds.length<=3
    flds.shift
  end
  flds=nil if flds.length<=0
  create_embed(event,["__#{"Mathoo's " if mu}**#{u40[0]}**__",unit_clss(bot,event,unitz,u40[0])],"#{display_stars(bot,event,rarity,merges,summoner,[unitz[3],flowers],sizex=='giant',unitz[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(unitz,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,sizex=='giant')}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n#{mergetext}",xcolor,ftr,img,flds,xtype)
  if (skillstoo || sizex=='giant') && u40[0]=='Robin (Shared stats)' # due to the two Robins having different skills, a second embed is displayed with both their skills
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

def cumulative_sp_cost(x,event,mode=0)
  if mode==1
    return ['',0,0,0] if ['Weapon','Assist','Special'].include?(x[6]) || x[5]=='-' || x[5].split(' ').length<4
    m=x[5].split(' ')
    for i in 1...m.length
      m[i]=m[i].to_i
    end
    return m if x[10]=='-'
    if x[10].include?('*, *')
      k=x[10].gsub('*','').split(', ')
    elsif x[10].include?('* or *')
      k=x[10].gsub('*','').split(' or ')
    else
      k=[x[10].gsub('*','')]
    end
    k=k.reject{|q| q.scan(/[[:alpha:]]+?/).join != x[1].scan(/[[:alpha:]]+?/).join}
    return m if k.length<=0
    k=k[0]
    n=cumulative_sp_cost(find_skill(k,event),event,1)
    return [m[0],m[1]+n[1],m[2]+n[2],m[3]+n[3]]
  end
  return 0 if x.nil?
  return x[3] if x[10]=='-'
  if x[10].include?('*, *')
    k=find_skill(x[10].gsub('*','').split(', ')[0],event)
  elsif x[10].include?('* or *')
    k=find_skill(x[10].gsub('*','').split(' or ')[0],event)
  else
    k=find_skill(x[10].gsub('*',''),event)
  end
  return x[3]+cumulative_sp_cost(k,event)
end

def remove_prefix(s,event)
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  s=s[@prefixes[event.server.id].length,s.length-@prefixes[event.server.id].length] if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0 && [@prefixes[event.server.id].downcase].include?(s.downcase[0,@prefixes[event.server.id].length])
  return s
end

def disp_skill(bot,name,event,ignore=false,dispcolors=false)
  data_load()
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=sever(s,true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  f=find_data_ex(:find_skill,name,event)
  lookout=lookout_load('SkillSubsets')
  lookout2=lookout.reject{|q| q[2]!='Weapon' || q[3].nil?}
  if f.length<=0
    if event.message.text.downcase.include?('psychic')
      event.respond 'No matches found.  Might you be looking for the skill **Physic** or its upgrade **Physic+**?' unless ignore
    else
      event.respond "No matches found.  If you are looking for data on the skills a character learns, try ```#{first_sub(event.message.text,'skill','skills',1)}```, with an s." unless ignore
    end
    return false
  end
  skill=f.map{|q| q}
  sklz=@skills.map{|q| q}
  g=get_markers(event)
  unitz=@units.reject{|q| !has_any?(g, q[13][0])}
  if skill[0].is_a?(Array)
  elsif skill[6]=='Weapon' && has_any?(event.message.text.downcase.split(' '),['refinement','refinements','(w)'])
    if skill[1]=='Falchion'
      disp_skill_2(bot,'Drive Spectrum',event,ignore)
      disp_skill_2(bot,'Brave Falchion',event,ignore)
      disp_skill_2(bot,'Spectrum Bond',event,ignore)
      return true
    elsif skill[1]=='Missiletainn'
      k=@skills[@skills.find_index{|q| q[1]=='Missiletainn (Dark)'}]
      k2=@skills[@skills.find_index{|q| q[1]=='Missiletainn (Dusk)'}]
      k[17]=nil if !k[17].nil? && k[17].length<=0
      k2[17]=nil if !k2[17].nil? && k2[17].length<=0
      disp_skill_2(bot,find_effect_name(k,event),event,ignore) unless k[17].nil?
      disp_skill_2(bot,find_effect_name(k2,event),event,ignore) unless k2[17].nil?
      event.respond "#{skill[1]} does not have an Effect Mode.  Showing #{skill[1]}'s default data." if !k[17].nil? && !k2[17].nil?
      return true if k[17].nil? && k2[17].nil?
    elsif find_effect_name(skill,event).length>0
      disp_skill_2(bot,find_effect_name(skill,event),event,ignore)
      return true
    elsif !skill[17].nil?
      event.respond "#{skill[1]} does not have an Effect Mode.  Showing #{skill[1]}'s default data."
    else
      event.respond "#{skill[1]} cannot be refined.  Showing #{skill[1]}'s default data."
    end
  end
  skill=skill[0] if skill[0].is_a?(Array)
  f2=f.map{|q| q}
  f2=f.reject{|q| q[2].to_i.to_s != q[2]} unless skill==f
  str=''
  title=nil
  hdr="__**#{skill[1]}**__"
  xfooter=nil
  unless skill[6]=='Weapon' && event.message.text.downcase.split(' ').include?('refined') && !has_any?(event.message.text.downcase.split(' '),['default','base'])
    if skill[6]=='Weapon'
      xcolor=0xF4728C
      sklslt=['Weapon']
      effective=[]
      dispname=skill[1].gsub(' ','_').gsub('.','').gsub('/','_').gsub('+','').gsub('!','')
      xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Weapons/#{dispname}.png?raw=true"
      if skill[7]=='Red Tome Users Only'
        s=skill[2]
        xfooter='Dark Mages can still learn this skill, it just takes more SP.'
        if s=="Raudr"
          s="Rau\u00F0r"
          xfooter=nil
        elsif s=='Dark'
          xfooter=xfooter.gsub('Dark','Fire')
        end
        emote='<:Red_Tome:443172811826003968>'
        moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{s}_Tome"}
        emote=moji[0].mention unless moji.length<=0
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}\n#{emote}**Weapon Type:** #{s} Magic (Red Tome)"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}"
        xfooter=nil unless skill[8]=='-'
      elsif skill[7]=='Blue Tome Users Only'
        s=skill[2]
        xfooter='Light Mages can still learn this skill, it just takes more SP.'
        if s=="Blar"
          s="Bl\u00E1r"
          xfooter=nil
        elsif s=='Light'
          xfooter=xfooter.gsub('Light','Thunder')
        end
        emote='<:Blue_Tome:467112472394858508>'
        moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{s}_Tome"}
        emote=moji[0].mention unless moji.length<=0
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}\n#{emote}**Weapon Type:** #{s} Magic (Blue Tome)"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}"
        xfooter=nil unless skill[8]=='-'
      elsif skill[7]=='Green Tome Users Only'
        s=skill[2]
        if s=='Gronn'
          xfooter=nil
        end
        emote='<:Green_Tome:467122927666593822>'
        moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{s}_Tome"}
        emote=moji[0].mention unless moji.length<=0
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}\n#{emote}**Weapon Type:** #{s} Magic (Green Tome)"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}"
        xfooter=nil unless skill[8]=='-'
      elsif skill[7]=='Bow Users Only'
        effective.push('<:Icon_Move_Flier:443331186698354698>') unless skill[13].include?('UnBow')
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}\n<:Gold_Bow:443172812492898314>**Weapon Type:** Bow"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}"
      elsif skill[7]=='Dagger Users Only'
        skill[9]=skill[9].split(' *** ')
        xfooter="Debuff is applied at end of combat if unit attacks, and lasts until the foes' next actions."
        title="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[6]}\n<:Gold_Dagger:443172811461230603>**Weapon Type:** Dagger"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}"
      elsif skill[7]=='Staff Users Only'
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}\n#{"<:Gold_Staff:443172811628871720>" if alter_classes(event,'Colored Healers')}#{"<:Colorless_Staff:443692132323295243>" unless alter_classes(event,'Colored Healers')}**Weapon Type:** Staff"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}"
      elsif skill[7]=='Dragons Only'
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[4]}\n<:Gold_Dragon:443172811641454592>**Weapon Type:** Breath (Dragons)"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}"
      elsif ['Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[1])
        m=skill[1].split(' (')[0]
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}\n<:Gold_Beast:532854442299752469>**Weapon Type:** Beast Damage"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}\n**Beast Mechanics:** At start of turn, if unit is either not adjacent to any allies, or adjacent to only beast and dragon allies, unit transforms.  Otherwise, unit reverts back to humanoid form."
        skzz=sklz.reject{|q| q[1]=="#{m} (All)" || (q[1][0,m.length+2]!="#{m} (" && !((q[1]=='Hatchling (Flier)' && m=='Whelp') || (q[1]=='Fledgling (Flier)' && m=='Yearling')))}
        for i in 0...skzz.length
          m=skzz[i][7].split(', ')[1].split(' ').map{|q| q.gsub('s','')}.reject{|q| !['Infantry','Armor','Flier','Cavalry'].include?(q)}
          movemoji=''
          for i2 in 0...m.length
            moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{m[i2]}"}
            movemoji="#{movemoji}#{moji[0].mention}" if moji.length>0
          end
          str="#{str}\n\n#{movemoji} __**#{skzz[i][1]}**__"
          str="#{str}\n**Effect:** #{skzz[i][9]}" unless skzz[i][9]=='-'
          str="#{str}\n**Promotes from:** #{skzz[i][10]}" if skzz[i][10]!='-'
          p=find_promotions(skzz[i],event)
          p=p.uniq
          p3=unitz.map{|q| q}
          unless p.length.zero?
            for i2 in 0...p.length
              p[i2]="~~#{p[i2]}~~" unless sklz[sklz.find_index{|q2| "#{q2[1]}#{"#{' ' unless q2[1][-1,1]=='+'}#{q2[2]}" unless q2[2]=='-' || ['Weapon','Assist','Special'].include?(q2[6])}"==p[i2]}][15].nil? || !skzz[i][15].nil?
            end
            if p.length>8 && !event.message.text.downcase.split(' ').include?('expanded')
              xfooter='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
              p2=p.reject{|q| sklz[sklz.find_index{|q2| q2[1]==q.gsub('~~','')}][8]!='-'}
              if p==p2
                p=list_lift(p.map{|q| "*#{q}*"},"or")
              else
                p="#{"#{p2.map{|q| "*#{q}*"}.join(', ')}, and " unless p2.length<0}#{p.length-p2.length} Prf weapons"
              end
              p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[1]==q.gsub('~~','')}][12].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
            else
              p2=p.reject{|q| sklz[sklz.find_index{|q2| q2[1]==q.gsub('~~','')}][8]!='-'}
              p=list_lift(p.map{|q| "*#{q}*"},"or")
              p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[1]==q.gsub('~~','')}][12].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
            end
            str="#{str}\n**Promotes into:** #{p}"
          end
        end
        str="#{str}\n"
        skill[9]='-'
      elsif skill[7].split(', ')[0]=='Beasts Only'
        m=skill[7].split(', ')[1].split(' ').map{|q| q.gsub('s','')}.reject{|q| !['Infantry','Armor','Flier','Cavalry'].include?(q)}
        movemoji=''
        for i in 0...m.length
          moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{m[i]}"}
          movemoji="#{movemoji}#{moji[0].mention}" if moji.length>0
        end
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}\n<:Gold_Beast:532854442299752469>**Weapon Type:** Beast Damage"
        str="#{movemoji}**Movement Type:** #{skill[7].split(', ')[1]}\n**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}\n**Beast Mechanics:** At start of turn, if unit is either not adjacent to any allies, or adjacent to only beast and dragon allies, unit transforms.  Otherwise, unit reverts back to humanoid form."
      elsif skill[1]=='Missiletainn'
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}"
        str="__**Missiletainn (Dark)**__\n<:Red_Blade:443172811830198282>**Weapon Type:** Sword (Red Blade)\n**Might:** #{skill[4]+1}  \u200B  \u200B  \u200B  **Range:** 1\n**Effect:** #{skill[9].split(' *** ')[0]}\n**<:Prf_Sparkle:490307608973148180>Prf to:** Owain\n**Promotes from:** *Silver Sword*\n\n__**Missiletainn (Dusk)**__\n<:Light_Tome:499760605381787650>**Weapon Type:** Light Magic (Blue Tome)\n**Might:** #{skill[4]-1}  \u200B  \u200B  \u200B  **Range:** 2\n**Effect:** #{skill[9].split(' *** ')[1]}\n**<:Prf_Sparkle:490307608973148180>Prf to:** Ophelia\n**Promotes from:** *Shine*"
        skill[9]='-'
      else
        s=skill[7]
        s=s[0,s.length-11]
        s='<:Red_Blade:443172811830198282> / Sword (Red Blade)' if s=='Sword'
        s='<:Blue_Blade:467112472768151562> / Lance (Blue Blade)' if s=='Lance'
        s='<:Green_Blade:467122927230386207> / Axe (Green Blade)' if s=='Axe'
        s='<:Summon_Gun:453639908968628229> / Summon Gun' if s=='Summon Gun'
        s="<:Gold_Unknown:443172811499110411> / #{s}" unless s.include?(' / ')
        title="<:Skill_Weapon:444078171114045450>**Skill Slot:** #{skill[6]}\n#{s.split(' / ')[0]}**Weapon Type:** #{s.split(' / ')[1]}"
        str="**Might:** #{skill[4]}  \u200B  \u200B  \u200B  **Range:** #{skill[5]}"
      end
      for i in 0...lookout2.length
        effective.push(lookout2[i][3]) if skill[13].include?(lookout2[i][0])
      end
      str="#{str}\n**Effective against:** #{effective.join('')}" if effective.length>0 && skill[1]!='Mana Cat'
      if skill[9].is_a?(Array)
        if skill[9][1].nil?
          str="#{str}\n**Debuff:**  \u200B  \u200B  \u200B  *None*"
        else
          eff=skill[9][1].split(', ')
          str="#{str}\n**Debuff:**  \u200B  \u200B  \u200B  *Effect:* #{eff[0,eff.length-1].join(', ')}  \u200B  \u200B  \u200B  *Affects:* #{eff[eff.length-1]}"
        end
        unless skill[9][2].nil?
          eff=skill[9][2].split(', ')
          str="#{str}\n**Buff:**  \u200B  \u200B  \u200B  *Effect:* #{eff[0,eff.length-1].join(', ')}  \u200B  \u200B  \u200B  *Affects:* #{eff[eff.length-1]}"
        end
        str="#{str}\n**Additional Effect:**  \u200B  \u200B  \u200B  #{skill[9][0]}" unless skill[9][0]=='-'
      elsif ['Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[0])
      else
        str="#{str}\n**Effect:** #{skill[9]}" unless skill[9]=='-'
      end
      str="#{str}\n**Stats affected#{' (humanoid)' if skill[7].split(', ')[0]=='Beasts Only'}:** #{skill[14][0,5].map{|q| "#{'+' if q>0}#{q}"}.join('/')}" unless skill[1]=='Missiletainn'
      if skill[7].split(', ')[0]=='Beasts Only'
        for i in 0...5
          skill[14][i]+=skill[14][i+5]
        end
        str="#{str}\n**Stats affected (transformed):** #{skill[14][0,5].map{|q| "#{'+' if q>0}#{q}"}.join('/')}"
      end
      str="#{str}\n\n**SP required:** #{skill[3]} #{"(#{skill[3]*3/2} when inherited)" if skill[8]=='-'}"
      cumul=cumulative_sp_cost(skill,event)
      cumul2=cumul+skill[3]/2
      if skill[1][skill[1].length-1,1]=='+' && skill[13].include?("Seasonal")
        # seasonal + weapons come bundled with their non-plus selves, so their minimum inherited SP cost has to include the non-plus version as inherited as well
        cumul2+=sklz[sklz.find_index{|q| q[1]==skill[1].gsub('+','')}][3]/2
      elsif skill[1][skill[1].length-1,1]=='+' && skill[7]=="Staff Users Only"
        # staff + weapons come bundled with their non-plus selves, so their minimum inherited SP cost has to include the non-plus version as inherited as well
        cumul2+=sklz[sklz.find_index{|q| q[1]==skill[1].gsub('+','')}][3]/2
      end
      str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul2}-#{cumul*3/2} when inherited)" if skill[8]=='-'}" unless cumul==skill[3]
    elsif skill[6]=='Assist'
      xcolor=0x07DFBB
      sklslt=['Assist']
      effective=[]
      dispname=skill[1].gsub(' ','_').gsub('.','').gsub('/','_').gsub('+','').gsub('!','')
      xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Assists/#{dispname}.png?raw=true"
      title="<:Skill_Assist:444078171025965066>**Skill Slot:** #{skill[6]}"
      str="**Range:** #{skill[5]}\n**Effect:** #{skill[9]}"
      str="#{str}\n**Heals:** #{skill[16]}" if skill[7]=="Staff Users Only"
      str="#{str}\n\n**SP required:** #{skill[3]} #{"(#{skill[3]*3/2} when inherited)" if skill[8]=='-'}"
      cumul=cumulative_sp_cost(skill,event)
      cumul2=cumul+skill[3]/2
      if skill[1][skill[1].length-1,1]=='+' && skill[7]=="Staff Users Only"
        # staff + assists come bundled with their non-plus selves, so their minimum inherited SP cost has to include the non-plus version as inherited as well
        cumul2+=sklz[sklz.find_index{|q| q[1]==skill[1].gsub('+','')}][3]/2
      end
      str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul2}-#{cumul*3/2} when inherited)" if skill[8]=='-'}" unless cumul==skill[3]
      xfooter="You may be looking for the reload command." if skill[1][0,7]=='Restore' && !event.message.text.downcase.include?('skill') && (event.user.id==167657750971547648 || event.channel.id==386658080257212417)
    elsif skill[6]=='Special'
      xcolor=0xF67EF8
      sklslt=['Special']
      effective=[]
      dispname=skill[1].gsub(' ','_').gsub('.','').gsub('/','_').gsub('+','').gsub('!','')
      xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Specials/#{dispname}.png?raw=true"
      title="<:Skill_Special:444078170665254929>**Skill Slot:** #{skill[6]}"
      str="**Cooldown:** #{skill[4]}\n**Effect:** #{skill[9]}#{"\n**Range:** ```\n#{skill[5].gsub("n","\n")}```" if skill[5]!="-"}"
      str="#{str}#{"\n" if skill[5]=="-"}\n**SP required:** #{skill[3]} #{"(#{skill[3]*3/2} when inherited)" if skill[8]=='-'}"
      cumul=cumulative_sp_cost(skill,event)
      cumul2=cumul+skill[3]/2
      if skill[1][skill[1].length-1,1]=='+' && skill[7]=="Staff Users Only"
        # staff + specials come bundled with their non-plus selves, so their minimum inherited SP cost has to include the non-plus version as inherited as well
        cumul2+=sklz[sklz.find_index{|q| q[1]==skill[1].gsub('+','')}][3]/2
      end
      str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul2}-#{cumul*3/2} when inherited)" if skill[8]=='-'}" unless cumul==skill[3]
    else
      xcolor=0xFDDC7E
      sklslt=skill[6].split(', ')
      if skill==f
        hdr="#{skill[1]} #{skill[2]}"
        hdr="#{skill[1]}#{skill[2]}" if skill[1][-1,1]=='+'
        hdr="#{skill[1]}" if skill[2]=='-'
        hdr="__**#{hdr}**__"
      else
        hdr="__**#{skill[1]}** #{f2.map{|q| q[2]}.join('/')}__"
        hdr="__**#{skill[1]}**#{f2.map{|q| q[2]}.join('/')}__" if skill[1][-1,1]=='+'
      end
      sklimg="#{skill[1].gsub(' ','_').gsub('/','_').gsub('!','').gsub('.','')}_#{skill[2]}"
      if skill[2]=='example' || skill[1][0,10]=='Squad Ace '
        skill2=skill.map{|q| q}
        skill2=f2[-1] if f != skill
        sklimg="#{skill2[1].gsub(' ','_').gsub('.','').gsub('/','_').gsub('!','')}_#{skill2[2]}"
        sklimg="#{skill2[1].gsub(' ','_').gsub('.','').gsub('/','_').gsub('!','')}#{skill2[2]}" if skill2[1][-1,1]=='+'
        sklimg="#{skill2[1].gsub(' ','_').gsub('.','').gsub('/','_').gsub('!','')}" if skill2[2]=='-'
        sklimg="#{skill2[1].gsub(' ','_').gsub('.','').gsub('/','_').gsub('!','')}_W" if skill2[2][0,1]=='W' || has_any?(event.message.text.downcase.split(' '),['refinement','refinements','(w)'])
        sklimg="Squad_Ace_#{"ABCDE"["ABCDEFGHIJKLMNOPQRSTUVWXYZ".split(skill2[1][10,1])[0].length%5,1]}_#{skill2[2]}" if skill2[1][0,10]=='Squad Ace '
      else
        sklimg="#{skill[1].gsub(' ','_').gsub('.','').gsub('/','_').gsub('+','').gsub('!','')}_W" if skill[2][0,1]=='W' || has_any?(event.message.text.downcase.split(' '),['refinement','refinements','(w)'])
      end
      xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/skills/#{sklimg}.png?raw=true"
      sklslt=skill[6].split(', ')
      if !skill[14].nil? && skill[14]!='' && skill[6].include?('Passive(W)')
        eff=skill[14].split(', ')
        for i in 0...eff.length
          eff[i]=nil unless find_skill(eff[i],event,true).length>0
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
      title="#{emo.join('')}**Skill Slot:** #{sklslt.join(', ')}" if safe_to_spam?(event)
      str="**Effect:** #{skill[9]}"
      if skill[1]=='Distant Counter'
        str="#{str}\n**Secondary effect:** Breaks consecutiveness of enemy mage/bow/dagger/staff attacks"
      elsif skill[1]=='Close Counter'
        str="#{str}\n**Secondary effect:** Breaks consecutiveness of enemy sword/axe/lance/breath attacks"
      end
      if skill==f
        str="#{str}\n\n**SP required:** #{skill[3]} #{"(#{skill[3]*3/2} when inherited)" if skill[8]=='-'}"
        cumul=cumulative_sp_cost(skill,event)
        str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul+skill[3]/2}-#{cumul*3/2} when inherited)" if skill[8]=='-'}" unless cumul==skill[3]
        if skill[6].split(', ').include?('Seal') && skill[5]!="-" && skill[5][0,1].downcase != skill[5][0,1]
          floop=skill[5].split(' ')
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
      else
        str="#{str}\n\n**SP required:** #{f2.map{|q| q[3]}.join('/')} #{"(#{f2.map{|q| q[3]*3/2}.join('/')} when inherited)" if skill[8]=='-'}"
        cumul=cumulative_sp_cost(f2[-1],event)
        str="#{str}\n**Total SP required:** #{f2.map{|q| q[3]}.inject(0){|sum,x| sum + x }} #{"(#{f2.map{|q| q[3]*3/2}.inject(0){|sum,x| sum + x }} when inherited)" if skill[8]=='-'}"
        str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul+skill[3]/2}-#{cumul*3/2} when inherited)" if skill[8]=='-'}" unless cumul==f2[-1][3]
        if skill[6].split(', ').include?('Seal') && skill[5]!="-"
          floop=skill[5].split(' ')
          seals=f.reject{|q| q[2].to_i.to_s != q[2] || q[5]=='-'}.map{|q| q[5].split(' ')}
          floop[0]='<:Great_Badge_Transparent:443704781597573120> <:Badge_Transparent:445510675976945664>' if floop[0].downcase=='transparent'
          floop[0]='<:Great_Badge_Scarlet:443704781001850910> <:Badge_Scarlet:445510676060962816>' if floop[0].downcase=='scarlet'
          floop[0]='<:Great_Badge_Azure:443704780783616016> <:Badge_Azure:445510675352125441>' if floop[0].downcase=='azure'
          floop[0]='<:Great_Badge_Verdant:443704780943261707> <:Badge_Verdant:445510676056899594>' if floop[0].downcase=='verdant'
          str="#{str}\n**Seal Cost:** #{seals.map{|q| q[1]}.join('/')}#{floop[0].split(' ')[0]} #{seals.map{|q| q[2]}.join('/')}#{floop[0].split(' ')[1]} #{seals.map{|q| q[3]}.join('/')}<:Sacred_Coin:453618312996323338>"
          mxm=[0,0,0]
          for i in 0...seals.length
            mxm[0]+=seals[i][1].to_i
            mxm[1]+=seals[i][2].to_i
            mxm[2]+=seals[i][3].to_i
          end
          str="#{str}\n**Cumulative Seal Cost:** #{mxm[0]}#{floop[0].split(' ')[0]} #{mxm[1]}#{floop[0].split(' ')[1]} #{mxm[2]}<:Sacred_Coin:453618312996323338>" if mxm != [floop[1],floop[2],floop[3]]
        end
      end
    end
    if skill[8]=='-' && skill[6]!='Weapon'
      str="#{str}\n\n**Restrictions on inheritance:** #{skill[7].gsub('Excludes Tome Users, Excludes Staff Users, Excludes Dragons','Physical Weapon Users Only')}"
      if skill != f && f2.reject{|q| q[7]==skill[7]}.length>0
        str="#{str}\n#{f2.reject{|q| q[7]==skill[7]}.map{|q| "*Level #{q[2]}:* #{q[7]}"}.join("\n")}"
      end
    elsif skill[8]=='-'
    elsif !['Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[1])
      m=skill[8].split(', ').reject{|u| find_unit(u,event,false,true).length<=0}
      if m.length>0
        str="#{str}\n\n**<:Prf_Sparkle:490307608973148180>Prf to:** #{m.join(', ')}"
      else
        str="#{str}\n\n~~Unobtainable~~"
      end
    end
    str="#{str}\n**Promotes from:** #{skill[10]}" unless skill[10]=='-' || ['Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[1])
    if ['Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[1])
    elsif (skill==f || (skill[6]=='Weapon' && skill[7]=='Dagger Users Only')) && safe_to_spam?(event)
      p=find_promotions(f,event)
      p=p.uniq
      p3=unitz.map{|q| q}
      unless p.length.zero?
        for i2 in 0...p.length
          p[i2]="~~#{p[i2]}~~" unless sklz[sklz.find_index{|q2| "#{q2[1]}#{"#{' ' unless q2[1][-1,1]=='+'}#{q2[2]}" unless q2[2]=='-' || ['Weapon','Assist','Special'].include?(q2[6])}"==p[i2]}][15].nil? || !skill[15].nil?
        end
        if p.length>8 && skill[6]=='Weapon' && !event.message.text.downcase.split(' ').include?('expanded')
          xfooter='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
          p2=p.reject{|q| sklz[sklz.find_index{|q2| q2[1]==q.gsub('~~','')}][8]!='-'}
          if p==p2
            p=list_lift(p.map{|q| "*#{q}*"},"or")
          else
            p="#{p2.map{|q| "*#{q}*"}.join(', ')}, and #{p.length-p2.length} Prf weapons"
          end
          p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[1]==q.gsub('~~','')}][12].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
        elsif skill[6]=='Weapon'
          p2=p.reject{|q| sklz[sklz.find_index{|q2| q2[1]==q.gsub('~~','')}][8]!='-'}
          p=list_lift(p.map{|q| "*#{q}*"},"or")
          p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[1]==q.gsub('~~','')}][12].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
        else
          p=list_lift(p.map{|q| "*#{q}*"},"or")
        end
        str="#{str}\n**Promotes into:** #{p}"
      end
    elsif safe_to_spam?(event)
      f3=f2.map{|q| "#{q[1]} #{q[2]}"}
      p=[]
      for i in 0...f2.length-1
        p2=find_promotions(f2[i],event)
        for i2 in 0...p2.length
          unless f3.include?(p2[i2])
            p2[i2]="~~#{p2[i2]}~~" unless sklz[sklz.find_index{|q2| "#{q2[1]}#{"#{' ' unless q2[1][-1,1]=='+'}#{q2[2]}" unless q2[2]=='-' || ['Weapon','Assist','Special'].include?(q2[6])}"==p2[i2]}][15].nil? || !skill[15].nil?
            p.push(p2[i2])
          end
        end
      end
      str="#{str}\n**Branching lines:** #{list_lift(p.uniq.sort.map{|q| "*#{q}*"},"or")}" if p.length>0
      p=find_promotions(f2[-1],event)
      p=p.uniq
      unless p.length.zero?
        for i2 in 0...p.length
          p[i2]="~~#{p[i2]}~~" unless sklz[sklz.find_index{|q2| "#{q2[1]}#{"#{' ' unless q2[1][-1,1]=='+'}#{q2[2]}" unless q2[2]=='-' || ['Weapon','Assist','Special'].include?(q2[6])}"==p[i2]}][15].nil? || !skill[15].nil?
        end
        str="#{str}\n**Promotes into:** #{list_lift(p.map{|q| "*#{q}*"},"or")}"
      end
    end
    if !skill[16].nil? && skill[16].length>0 && skill[6]=='Weapon'
      prm=skill[16].split(', ')
      for i in 0...prm.length
        sklll=prm[i].split('!')
        if sklll.length==1
          prm[i]=nil if find_skill(sklll[1],event,sklz.map{|q| q}).length<=0
        else
          prm[i]="#{sklll[1]} (#{sklll[0]})"
          prm[i]=nil if find_skill(sklll[1],event,sklz.map{|q| q}).length<=0
          prm[i]=nil if find_unit(sklll[0],event,false,true).length<=0
        end
      end
      str="#{str}\n**Evolves into:** #{list_lift(prm.map{|q| "*#{q}*"},"or")}"
    elsif skill[1]=='Falchion'
      sklz2=sklz.reject{|q| q[6]!='Weapon' || q[7]!='Sword Users Only' || q[0]<=0}
      sk1=sklz2[sklz2.find_index{|q| q[0]==skill[0]+1}]
      sk2=sklz2[sklz2.find_index{|q| q[0]==skill[0]+3}]
      sk3=sklz2[sklz2.find_index{|q| q[0]==skill[0]+2}]
      str="#{str}\n**#{sk1[1]} evolves into:** #{list_lift(sk1[16].split(', ').map{|q| "*#{q}*"},"or")}" if !sk1[16].nil? && sk1[16].length>0 && sk1[6]=='Weapon'
      str="#{str}\n**#{sk2[1]} evolves into:** #{list_lift(sk2[16].split(', ').map{|q| "*#{q}*"},"or")}" if !sk2[16].nil? && sk2[16].length>0 && sk2[6]=='Weapon'
      str="#{str}\n**#{sk3[1]} evolves into:** #{list_lift(sk3[16].split(', ').map{|q| "*#{q}*"},"or")}" if !sk3[16].nil? && sk3[16].length>0 && sk3[6]=='Weapon'
    elsif skill[1]=='Missiletainn'
      sk1=find_skill('Missiletainn (Dark)',event,true,true)
      sk2=find_skill('Missiletainn (Dusk)',event,true,true)
      str="#{str}\n**Missiletainn(Dark) evolves into:** #{list_lift(sk1[16].split(', ').map{|q| "*#{q}*"},"or")}" if !sk1[16].nil? && sk1[16].length>0 && sk1[6]=='Weapon'
      str="#{str}\n**Missiletainn(Dusk) evolves into:** #{list_lift(sk2[16].split(', ').map{|q| "*#{q}*"},"or")}" if !sk2[16].nil? && sk2[16].length>0 && sk2[6]=='Weapon'
    end
    x=false
    can_also=true
    for i in 0...5
      untz=skill[11][i].split(', ')
      untz=untz.reject {|u| u[0,4].downcase != 'all ' && u != '-' && unitz.find_index{|q| q[0]==u}.nil?}
      untz=untz.sort {|a,b| a.downcase <=> b.downcase}
      for i2 in 0...untz.length
        untz[i2]="~~#{untz[i2]}~~" unless untz[i2][0,4].downcase=='all ' || untz[i2]=='-' || unitz[unitz.find_index{|q| q[0]==untz[i2]}][13][0].nil? || !skill[15].nil?
      end
      skill[11][i]=untz.join(', ')
      untz=skill[12][i].split(', ')
      untz=untz.map {|u| u.gsub('[Retro]','')}
      untz=untz.reject {|u| u[0,4].downcase != 'all ' && u != '-' && unitz.find_index{|q| q[0]==u}.nil?}
      untz=untz.sort {|a,b| a.downcase <=> b.downcase}
      for i2 in 0...untz.length
        untz[i2]="~~#{untz[i2]}~~" unless untz[i2][0,4].downcase=='all ' || untz[i2]=='-' || unitz[unitz.find_index{|q| q[0]==untz[i2]}][13][0].nil? || !skill[15].nil?
      end
      skill[12][i]=untz.join(', ')
    end
    unless dispcolors || ['Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[1])
      str2='**Heroes who know it out of the box:**'
      for i in 0...@max_rarity_merge[0]
        if skill[11][i]=='-' || skill[11][i]==''
        elsif skill[6]=='Weapon' && skill[11][i].split(', ').length>8 && !event.message.text.downcase.split(' ').include?('expanded')
          xfooter='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
          m=skill[11][i].split(', ').reject{|q| !p3.include?(q)}.join(', ')
          str2="#{str2}\n*#{i+1}#{@rarity_stars[i]}:* #{m}, and #{skill[11][i].split(', ').length-m.split(', ').length} units who end up having Prf weapons."
        else
          str2="#{str2}\n*#{i+1}#{@rarity_stars[i]}:* #{skill[11][i]}"
        end
      end
      unless str2=='**Heroes who know it out of the box:**' || ['Missiletainn'].include?(skill[1])
        str="#{str}\n\n#{str2}"
        x=true
      end
    end
    unitz=@units.map{|q| q}
    if ['Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[1])
    elsif safe_to_spam?(event) && !(skill==f || (skill[6]=='Weapon' && skill[7]=='Dagger Users Only'))
      str2='**Heroes who can learn part of this line without inheritance:**'
      f4=skill[12].join(', ').split(', ').reject{|q| q=='-'}
      f3=f2.map{|q| q[12]}.join(', ').split(', ').reject{|q| q=='-' || f4.include?(q) || unitz.find_index{|q2| q2[0]==q}.nil?}
      for i in 0...f3.length
        u=unitz[unitz.find_index{|q| q[0]==f3[i]}]
        f3[i]="~~#{f3[i]}~~" unless u[13][0].nil?
        f3[i]=nil if !has_any?(u[13][0], g)
      end
      f4=f3.compact.uniq
      f5=[]
      for i in 0...f4.length
        f5.push([f4[i],f3.reject{|q| f4[i]!=q}.length]) 
      end
      for i in 0...f2.length
        f3=f5.reject{|q| q[1]!=i+1}.map{|q| q[0]}.sort{|a,b| a.gsub('~~','').downcase<=>b.gsub('~~','').downcase}.uniq
        str2="#{str2}\n*To Level #{i+1}:* #{f3.join(', ')}" if f3.length>0
      end
      unless str2=='**Heroes who can learn part of this line without inheritance:**'
        str="#{str}\n\n#{str2}"
        x=true
      end
    end
    str2="**Heroes who can learn#{' the final skill in this line' unless skill==f} without inheritance:**"
    clrz=[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    for i in 0...@max_rarity_merge[0]
      if skill[12][i]=='-' || skill[12][i]=='' || ['Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[1])
      elsif skill[6]=='Weapon' && skill[12][i].split(', ').length>8 && !event.message.text.downcase.split(' ').include?('expanded')
        xfooter='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
        m=skill[12][i].split(', ').reject{|q| !p3.include?(q)}.join(', ')
        str2="#{str2}\n*#{i+1}#{@rarity_stars[i]}:* #{m}, and #{skill[12][i].split(', ').length-m.split(', ').length} units who end up having Prf weapons."
      elsif dispcolors
        m=skill[12][i].split(', ')
        for i2 in 0...m.length
          m2=unitz[unitz.find_index{|q| q[0]==m[i2].gsub('~~','')}]
          m3=i+1
          m4=[]
          m2[9][0].each_char{|q| m4.push(q.to_i)}
          m3=([m4.reject{|q| q==0}.min,m3].max rescue 5)
          m3="#{m[i2]} (#{m3}#{@rarity_stars[m3-1]})"
          if m2[9][0].include?('p') && m2[9][0].include?('TD')
            clrz[5].push(m3) if m2[1][0]=='Red'
            clrz[6].push(m3) if m2[1][0]=='Blue'
            clrz[7].push(m3) if m2[1][0]=='Green'
            clrz[8].push(m3) if m2[1][0]=='Colorless'
            clrz[9].push(m3) unless ['Red','Blue','Green','Colorless'].include?(m2[1][0])
          elsif m2[9][0].include?('p')
            clrz[0].push(m3) if m2[1][0]=='Red'
            clrz[1].push(m3) if m2[1][0]=='Blue'
            clrz[2].push(m3) if m2[1][0]=='Green'
            clrz[3].push(m3) if m2[1][0]=='Colorless'
            clrz[4].push(m3) unless ['Red','Blue','Green','Colorless'].include?(m2[1][0])
          elsif m2[9][0].gsub('0s','').include?('s')
            clrz[10].push(m3) if m2[1][0]=='Red'
            clrz[11].push(m3) if m2[1][0]=='Blue'
            clrz[12].push(m3) if m2[1][0]=='Green'
            clrz[13].push(m3) if m2[1][0]=='Colorless'
            clrz[14].push(m3) unless ['Red','Blue','Green','Colorless'].include?(m2[1][0])
          elsif m2[9][0]=='-'
          else
            clrz[15].push(m3)
          end
        end
      else
        str2="#{str2}\n*#{i+1}#{@rarity_stars[i]}:* #{skill[12][i]}"
      end
    end
    str2="#{str2}\n*<:Orb_Red:455053002256941056> Red Summonables:* #{clrz[0].join(', ')}" unless clrz[0].length<=0
    str2="#{str2}\n*<:Orb_Blue:455053001971859477> Blue Summonables:* #{clrz[1].join(', ')}" unless clrz[1].length<=0
    str2="#{str2}\n*<:Orb_Green:455053002311467048> Green Summonables:* #{clrz[2].join(', ')}" unless clrz[2].length<=0
    str2="#{str2}\n*<:Orb_Colorless:455053002152083457> Colorless Summonables:* #{clrz[3].join(', ')}" unless clrz[3].length<=0
    str2="#{str2}\n*<:Orb_Gold:455053002911514634> Summonables:* #{clrz[4].join(', ')}" unless clrz[4].length<=0
    str2="#{str2}\n*<:Orb_Red:455053002256941056> Red PartSummons:* #{clrz[5].join(', ')}" unless clrz[5].length<=0
    str2="#{str2}\n*<:Orb_Blue:455053001971859477> Blue PartSummons:* #{clrz[6].join(', ')}" unless clrz[6].length<=0
    str2="#{str2}\n*<:Orb_Green:455053002311467048> Green PartSummons:* #{clrz[7].join(', ')}" unless clrz[7].length<=0
    str2="#{str2}\n*<:Orb_Colorless:455053002152083457> Colorless PartSummons:* #{clrz[8].join(', ')}" unless clrz[8].length<=0
    str2="#{str2}\n*<:Orb_Gold:455053002911514634> PartSummons:* #{clrz[9].join(', ')}" unless clrz[9].length<=0
    str2="#{str2}\n*<:Orb_Red:455053002256941056> Red Limited:* #{clrz[10].join(', ')}" unless clrz[10].length<=0
    str2="#{str2}\n*<:Orb_Blue:455053001971859477> Blue Limited:* #{clrz[11].join(', ')}" unless clrz[11].length<=0
    str2="#{str2}\n*<:Orb_Green:455053002311467048> Green Limited:* #{clrz[12].join(', ')}" unless clrz[12].length<=0
    str2="#{str2}\n*<:Orb_Colorless:455053002152083457> Colorless Limited:* #{clrz[13].join(', ')}" unless clrz[13].length<=0
    str2="#{str2}\n*<:Orb_Gold:455053002911514634> Limited:* #{clrz[14].join(', ')}" unless clrz[14].length<=0
    str2="#{str2}\n*<:Orb_Pink:549339019318788175> Free units:* #{clrz[15].join(', ')}" unless clrz[15].length<=0
    clrz=[[],[],[],[],[],[],[],[],[],[],[]]
    unless str2=="**Heroes who can learn#{' the final skill in this line' unless skill==f} without inheritance:**"
      str="#{str}\n\n#{str2}"
      x=true
    end
    if skill[6]=='Weapon' && !['Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(skill[1])
      prev=find_prevolutions(f,event)
      if prev.length>0
        for i in 0...prev.length
          skill2=prev[i][0]
          for i2 in 0...@max_rarity_merge[0]
            untz=skill2[12][i2].split(', ')
            untz=untz.reject {|u| find_unit(u,event,false,true).length<=0 && u[0,4].downcase != 'all ' && u != '-'}
            untz=untz.sort {|a,b| a.downcase <=> b.downcase}
            skill2[12][i2]=untz.join(', ')
          end
          str2="**It#{' also' if x} evolves from #{skill2[1]}, #{prev[i][1]} the following heroes:**"
          unitz=@units.map{|q| q}
          for i2 in 0...@max_rarity_merge[0]
            if skill2[12][i2]=='-' || skill2[12][i2]==''
            elsif dispcolors
              m=skill2[12][i2].split(', ')
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
              str2="#{str2}\n*#{i2+1}#{@rarity_stars[i2]}:* #{skill2[12][i2]}"
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
          str2="#{str2}\n*<:Orb_Pink:549339019318788175> Free units:* #{clrz[10].join(', ')}" unless clrz[10].length<=0
          if str2=="**It#{' also' if x} evolves from #{skill2[0]}, #{prev[i][1]} the following heroes:**"
            str="#{str}\n\n**It#{' also' if x} evolves from #{skill2[0]}**"
          else
            str="#{str}\n\n#{str2}"
          end
        end
        str2='**Evolution cost:** 300 SP (450 if inherited), 200<:Arena_Medal:453618312446738472> 20<:Refining_Stone:453618312165720086>'
        str2='**Evolution cost:** 300 SP (450 if inherited), 100<:Arena_Medal:453618312446738472> 10<:Refining_Stone:453618312165720086>' if skill[1]=='Candlelight+'
        str2='**Evolution cost:** 400 SP, 375<:Arena_Medal:453618312446738472> 150<:Divine_Dew:453618312434417691>' if skill[8]!='-'
        str2='**Evolution cost:** 1 story-gift Gunnthra<:Green_Tome:467122927666593822><:Icon_Move_Cavalry:443331186530451466><:Legendary_Effect_Wind:443331186467536896><:Ally_Boost_Resistance:443331185783865355>' if skill[1]=='Chill Breidablik'
        str="#{str}\n#{"\n" if prev.length>1}#{str2}"
      end
    end
    if !skill[14].nil? && skill[14]!='' && skill[6].include?('Passive(W)')
      if skill==f
        eff=skill[14].split(', ')
        for i in 0...eff.length
          eff[i]=nil unless find_skill(eff[i],event,true).length>0
        end
        eff.compact!
        str="#{str}\n\n**Gained via Effect Mode on:** #{eff.join(', ')}" if eff.length>0
      else
        str2=''
        for i in 0...f2.length
          eff=f2[i][14].split(', ')
          for i2 in 0...eff.length
            m=sklz[sklz.find_index{|q| q[1]==eff[i2]}]
            eff[i2]=nil unless has_any?(m[15],g)
          end
          eff.compact!
          str2="#{str2}\n**Level #{f2[i][2]} gained via Effect Mode on:** #{eff.join(', ')}" if eff.length>0
        end
        str="#{str}\n#{str2}" if str2.length>0
      end
    end
    lookoutx=[]
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt')
      lookoutx=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHStatSkills.txt').each_line do |line|
        lookoutx.push(eval line)
      end
    end
    unless ['Weapon','Assist','Special'].include?(skill[6]) || !safe_to_spam?(event)
      checkskl=skill.map{|q| q}
      checkskl=f2[-1].map{|q| q} if skill != f
      checkstr="#{checkskl[1]}#{" #{checkskl[2]}" unless checkskl[2]=='-'}"
      if lookoutx.map{|q| q[0]}.include?(checkstr) || skill[1]=='Panic Ploy'
        statskill=lookoutx.find_index{|q| q[0]==checkstr}
        statskill=lookoutx.find_index{|q| q[0]=='Panic Ploy'} if statskill.nil? || skill[1]=='Panic Ploy'
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
    end
    m=str.length+hdr.length
    m+=xfooter.length unless xfooter.nil?
    if m>=1900
      str=str.split("\n\n")
      disp=[]
      str2="#{str[0]}"
      for i in 1...str.length
        if "#{str2}\n\n#{str[i]}".length>=1900
          disp.push("#{str2}")
          str2="#{str[i]}"
        else
          str2="#{str2}\n\n#{str[i]}"
        end
      end
      disp.push("#{str2}")
      for i in 0...disp.length
        create_embed(event,[hdr,title],disp[i],xcolor,nil,xpic) if i==0
        create_embed(event,'',disp[i],xcolor) unless i==0 || i==disp.length-1
        create_embed(event,'',disp[i],xcolor,xfooter) if i==disp.length-1
      end
    else
      create_embed(event,[hdr,title],str,xcolor,xfooter,xpic)
    end
  end
  if skill[6]=="Assist" && skill[13].include?('Music')
    w=sklz.reject{|q| !q[13].include?('DanceRally') || !has_any?(g, q[15])}
    w=collapse_skill_list_2(w)
    w=w.map{|q| "#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}#{q[1]}#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}"}
    create_embed(event,'',"The following skills are triggered when their holder uses #{skill[1]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[6]=="Assist" && skill[13].include?('Move') && skill[13].include?('Rally')
    w=sklz.reject{|q| !(q[13].include?('Link') || q[13].include?('Feint')) || !has_any?(g, q[15])}
    w=collapse_skill_list_2(w)
    w=w.map{|q| "#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}#{q[1]}#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}"}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[1]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[6]=="Assist" && skill[13].include?('Move')
    w=sklz.reject{|q| !q[13].include?('Link') || !has_any?(g, q[15])}
    w=collapse_skill_list_2(w)
    w=w.map{|q| "#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}#{q[1]}#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}"}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[1]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[6]=="Assist" && skill[13].include?('Rally')
    w=sklz.reject{|q| !q[13].include?('Feint') || !has_any?(g, q[15])}
    w=collapse_skill_list_2(w)
    w=w.map{|q| "#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}#{q[1]}#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}"}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[1]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif !['Weapon','Assist','Special'].include?(skill[6]) && skill[13].include?('Link')
    w=sklz.reject{|q| q[4]!='Assist' || !q[13].include?('Move') || q[13].include?('Music') || !has_any?(g, q[15])}
    w=collapse_skill_list_2(w)
    w=w.map{|q| "#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}#{q[1]}#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}"}
    create_embed(event,'',"The following skills, when used on or by the unit holding #{skill[1]}, will trigger it:",0x40C0F0,nil,nil,triple_finish(w))
  elsif !['Weapon','Assist','Special'].include?(skill[6]) && skill[13].include?('Feint')
    w=sklz.reject{|q| q[4]!='Assist' || !q[13].include?('Rally') || !has_any?(g, q[15])}
    w=collapse_skill_list_2(w)
    w=w.map{|q| "#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}#{q[1]}#{'~~' unless q[15].nil? || q[15][0].nil? || q[15][0].length.zero?}"}
    create_embed(event,'',"The following skills, when used on or by the unit holding #{skill[1]}, will trigger it:",0x40C0F0,nil,nil,triple_finish(w))
  elsif event.message.text.downcase.split(' ').include?('refined') && (skill[17].nil? || skill[17].length<=0) && skill[6]=="Weapon"
    event.respond "#{skill[1]} does not have any refinements."
    return nil
  elsif !skill[17].nil? && skill[17].length>0 && !(has_any?(event.message.text.downcase.split(' '),['default','base']) && !event.message.text.downcase.split(' ').include?('refined'))
    sttz=[]
    inner_skill=skill[17]
    mt=[0,0,0,0,0]
    skill[14][1]+=1 if skill[13].include?('Silver')
    skill[4]+=1 if skill[13].include?('Silver')
    if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
      skill[14][1]+=inner_skill[0,1].to_i
      skill[4]+=inner_skill[0,1].to_i
      inner_skill=inner_skill[1,inner_skill.length-1]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
    elsif inner_skill[0,1]=='-' && inner_skill.length>1
      skill[14][1]-=inner_skill[1,1].to_i
      skill[4]-=inner_skill[0,1].to_i
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
    overides=[[0,0,0,0,0,0,'e'],[0,0,0,0,0,0,'w'],[0,0,0,0,0,0,'d']] if skill[7]=='Staff Users Only'
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
    if skill[7]=='Staff Users Only'
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
    skill[9]=skill[9].split(' *** ') if skill[6]=='Weapon' && skill[7]=='Dagger Users Only' && !skill[9].is_a?(Array)
    if skill[9].is_a?(Array)
      debuff=skill[9][1] unless skill[9][1].nil?
      buff=skill[9][2] unless skill[9][2].nil?
      skill[9]=skill[9][0]
    end
    if outer_skill.nil?
    elsif outer_skill.include?(' *** ')
      x=outer_skill.split(' *** ')
      debuff=x[1] unless x[1].nil?
      buff=x[2] unless x[2].nil?
      outer_skill=x[0]
      outer_skill=nil if outer_skill==' ' || outer_skill.length<=0
    end
    if skill[8]=='Nebby'
      inner_skill=inner_skill.split('  ')
      sttz.push([3,0,0,0,0,'Full Metal',inner_skill[0]])
      sttz.push([3,0,0,0,0,'Shadow',inner_skill[1]])
      inner_skill=''
    elsif inner_skill.length>1
      zzz=[skill[1],3,0,0,0,0]
      zzz=[skill[1],0,0,0,0,0] if skill[7].include?('Tome Users Only') || ['Staff Users Only','Bow Users Only','Dagger Users Only'].include?(skill[7])
      if find_effect_name(skill,event).length>0
        zzz2=find_effect_name(skill,event,1)
        lookout=lookout_load('StatSkills',['Stat-Affecting 1','Stat-Affecting 2'])
        zzz=apply_stat_skills(event,[find_effect_name(skill,event,1)],zzz,'','-','','',[],false,true) if lookout.map{|q| q[0]}.include?(zzz2)
      end
      skill[14][10]=zzz[2]
      sttz.push([zzz[1],0,zzz[3],zzz[4],zzz[5],'Effect'])
    elsif skill[1]=='Missiletainn'
      sk1=find_skill('Missiletainn (Dark)',event,true,true)
      sk2=find_skill('Missiletainn (Dusk)',event,true,true)
      refinements=[]
      refinements.push(['Dark',sk1[17],nil,0]) unless sk1[17].nil?
      refinements.push(['Dusk',sk2[17],nil,0]) unless sk2[17].nil?
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
    elsif skill[1]=='Falchion'
      sklz2=sklz.reject{|q| q[6]!='Weapon' || q[7]!='Sword Users Only' || q[0]<=0}
      sk1=sklz2[sklz2.find_index{|q| q[0]==skill[0]+1}]
      sk2=sklz2[sklz2.find_index{|q| q[0]==skill[0]+3}]
      sk3=sklz2[sklz2.find_index{|q| q[0]==skill[0]+2}]
      refinements=[]
      refinements.push(['Mystery',sk1[17],nil,0]) unless sk1[17].nil?
      refinements.push(['Echoes',sk2[17],nil,0]) unless sk2[17].nil?
      refinements.push(['Awakening',sk3[17],nil,0]) unless sk3[17].nil?
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
      sttz.push([3,refinements[0][3],0,0,0,"**Falchion(Mystery) (+) Effect Mode**#{" - #{find_effect_name(sk1,event)}" unless find_effect_name(sk1,event).length<=0}",refinements[0][1]]) unless refinements[0][1].nil?
      sttz.push([3,refinements[1][3],0,0,0,"**Falchion(Valentia) (+) Effect Mode**#{" - #{find_effect_name(sk2,event)}" unless find_effect_name(sk2,event).length<=0}",refinements[1][1]]) unless refinements[1][1].nil?
      sttz.push([3,refinements[2][3],0,0,0,"**Falchion(Awakening) (+) Effect Mode**#{" - #{find_effect_name(sk3,event)}" unless find_effect_name(sk3,event).length<=0}",refinements[2][1]]) unless refinements[2][1].nil?
    end
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Strength.png'
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Magic.png' if skill[7].include?('Tome Users Only') || skill[5]=='Dragons Only'
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Freeze.png' if skill[13].include?('Frostbite') || skill[13].include?('(R)Frostbite')
    if skill[7]=='Staff Users Only' && (skill[9].include?("This weapon's damage is calculated the same as other weapons.") || skill[9].include?('Damage from staff calculated like other weapons.'))
      xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Dazzling_W.png'
      sttzx=[[0,0,0,0,0,'Dazzling','The foe cannot counterattack.']]
    elsif skill[7]=='Staff Users Only' && (skill[9].include?('The foe cannot counterattack.') || skill[9].include?('Foe cannot counterattack.'))
      xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Wrathful_W.png'
      sttzx=[[0,0,0,0,0,'Wrathful',"This weapon's damage is calculated the same as other weapons."]]
    elsif skill[7]=='Staff Users Only'
      xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Staff_Default_Refine.png'
      sttzx=[[0,0,0,0,0,'Wrathful',"This weapon's damage is calculated the same as other weapons."],[0,0,0,0,0,'Dazzling','The foe cannot counterattack.']]
    elsif skill[7].include?('Tome Users Only') || ['Bow Users Only','Dagger Users Only'].include?(skill[7])
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
        emo='<:MagicW:449999580835086337>' if skill[7].include?('Tome Users Only') || skill[7]=='Dragons Only' || skill[7]=='Staff Users Only'
        emo='<:FreezeW:449999580864708618>' if skill[13].include?('Frostbite') || skill[13].include?('(R)Frostbite')
      end
      emo='<:SpeedW:449999580868640798>' if k=='Speed'
      emo='<:DefenseW:449999580793274408>' if k=='Defense'
      emo='<:ResistanceW:449999580864446514>' if k=='Resistance'
      emo='<:Wrathful:449999580650668033>' if k=='Wrathful'
      emo='<:Dazzling:449999580411592705>' if k=='Dazzling'
      if emo=='<:EffectMode:450002917269831701>'
        if sttz[i][5].include?('(+)')
          str="#{str}\n\n#{emo} #{sttz[i][5]}"
        else
          str="#{str}\n\n#{emo} **#{skill[1]} (+) #{sttz[i][5]} Mode**"
        end
        if sttz[i][5]=='Effect' && find_effect_name(skill,event).length>0
          xpix=find_effect_name(skill,event,2).gsub(' ','_').gsub('/','_')
          xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/#{xpix}.png"
          str="#{str} - #{find_effect_name(skill,event,1)}"
        end
        str="#{str}\nMight: #{skill[4]+sttz[i][1]+k2[0]}  \u200B  \u200B  \u200B  Range: #{skill[5]}"
        str="#{str}  \u200B  \u200B  \u200B  HP +#{sttz[i][0]+k2[1]}" if sttz[i][0]+k2[1]>0
        atk=mt[1]+k2[2]
        atk+=skill[14][10] if sttz[i][5]=="Effect"
        str="#{str}  \u200B  \u200B  \u200B  Attack #{'+' if atk>0}#{atk}" if atk != 0
        str="#{str}  \u200B  \u200B  \u200B  Speed #{'+' if skill[14][2]+sttz[i][2]+k2[3]>0}#{skill[14][2]+sttz[i][2]+k2[3]}" if skill[14][2]+sttz[i][2]+k2[3]!=0
        str="#{str}  \u200B  \u200B  \u200B  Defense #{'+' if skill[14][3]+sttz[i][3]+k2[4]>0}#{skill[14][3]+sttz[i][3]+k2[4]}" if skill[14][3]+sttz[i][3]+k2[4]!=0
        str="#{str}  \u200B  \u200B  \u200B  Resistance #{'+' if skill[14][4]+sttz[i][4]+k2[5]>0}#{skill[14][4]+sttz[i][4]+k2[5]}" if skill[14][4]+sttz[i][4]+k2[5]!=0
        effective=[]
        effective.push('<:Icon_Move_Flier:443331186698354698>') if skill[5]=="Bow Users Only"
        for i2 in 0...lookout2.length
          effective.push(lookout2[i2][3]) if skill[13].include?(lookout2[i2][0])
          effective.push(lookout2[i2][3]) if skill[13].include?("(R)#{lookout2[i2][0]}")
          effective.push(lookout2[i2][3]) if skill[13].include?("(E)#{lookout2[i2][0]}")
        end
        str="#{str}\n*Effective against*: #{effective.join('')}" if effective.length>0
        unless debuff.nil?
          d=debuff.split(', ')
          str="#{str}\n*Debuff*:  \u200B  \u200B  \u200B  Effect: #{d[0,d.length-1].join(', ')}  \u200B  \u200B  \u200B  Affects: #{d[d.length-1]}"
        end
        unless buff.nil?
          d=buff.split(', ')
          str="#{str}\n*Buff*:  \u200B  \u200B  \u200B  Effect: #{d[0,d.length-1].join(', ')}  \u200B  \u200B  \u200B  Affects: #{d[d.length-1]}"
        end
        if outer_skill.nil? || !sttz[i][7].nil?
          str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{skill[9]}" unless skill[9]=='-'
        else
          str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{outer_skill}"
        end
        str="#{str}\nIf foe's Range = 2, damage calculated using the lower of foe's Def or Res." if skill[13].include?("(R)Frostbite") || skill[13].include?("(E)Frostbite")
        str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{sttz[i][6]}" unless sttz[i][6].nil?
        str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{inner_skill}" if inner_skill.length>1
      elsif safe_to_spam?(event)
        str="#{str}#{"\n" if i>0 && (sttz[i-1][5].include?('Effect') || sttz[i][5]=='Attack')}\n#{emo} **#{k} Mode**"
        str="#{str}  \u200B  \u200B  \u200B  Might: #{skill[4]+sttz[i][1]+k2[0]}  \u200B  \u200B  \u200B  Range: #{skill[5]}"
        str="#{str}  \u200B  \u200B  \u200B  HP +#{sttz[i][0]+k2[1]}" if sttz[i][0]+k2[1]>0
        atk=mt[1]+k2[2]
        atk+=skill[14][10] if sttz[i][5]=="Effect"
        str="#{str}  \u200B  \u200B  \u200B  Attack #{'+' if atk>0}#{atk}" if atk != 0
        str="#{str}  \u200B  \u200B  \u200B  Speed #{'+' if skill[14][2]+sttz[i][2]+k2[3]>0}#{skill[14][2]+sttz[i][2]+k2[3]}" if skill[14][2]+sttz[i][2]+k2[3]!=0
        str="#{str}  \u200B  \u200B  \u200B  Defense #{'+' if skill[14][3]+sttz[i][3]+k2[4]>0}#{skill[14][3]+sttz[i][3]+k2[4]}" if skill[14][3]+sttz[i][3]+k2[4]!=0
        str="#{str}  \u200B  \u200B  \u200B  Resistance #{'+' if skill[14][4]+sttz[i][4]+k2[5]>0}#{skill[14][4]+sttz[i][4]+k2[5]}" if skill[14][4]+sttz[i][4]+k2[5]!=0
      end
    end
    if safe_to_spam?(event) || ['Attack','Wrathful','Dazzling'].include?(sttz[0][5])
      str="#{str}\n\n<:Refine_Unknown:455609031701299220>**All #{'Stat' unless skill[7]=='Staff Users Only'}#{'Default' if skill[7]=='Staff Users Only'} Refinements**"
      effective=[]
      effective.push('<:Icon_Move_Flier:443331186698354698>') if skill[5]=="Bow Users Only"
      for i2 in 0...lookout2.length
        effective.push(lookout2[i2][3]) if skill[13].include?(lookout2[i2][0])
        effective.push(lookout2[i2][3]) if skill[13].include?("(R)#{lookout2[i2][0]}")
      end
      str="#{str}\n*Effective against*: #{effective.join('')}" if effective.length>0
      unless debuff.nil?
        d=debuff.split(', ')
        str="#{str}\n*Debuff*:  \u200B  \u200B  \u200B  Effect: #{d[0,d.length-1].join(', ')}  \u200B  \u200B  \u200B  Affects: #{d[d.length-1]}"
      end
      unless buff.nil?
        d=buff.split(', ')
        str="#{str}\n*Buff*:  \u200B  \u200B  \u200B  Effect: #{d[0,d.length-1].join(', ')}  \u200B  \u200B  \u200B  Affects: #{d[d.length-1]}"
      end
      if outer_skill.nil? || !sttz[i][7].nil?
        str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{skill[9]}" unless skill[9]=='-'
      else
        str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{outer_skill}"
      end
      str="#{str}\nIf foe's Range = 2, damage calculated using the lower of foe's Def or Res." if skill[13].include?("(R)Frostbite")
    end
    ftr='All refinements cost: 350 SP (525 if inherited), 500<:Arena_Medal:453618312446738472> 50<:Refining_Stone:453618312165720086>'
    ftr='All refinements cost: 400 SP, 500<:Arena_Medal:453618312446738472> 200<:Divine_Dew:453618312434417691>' if skill[8]!='-'
    str="#{str}\n\n#{ftr}"
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Falchion_Refines.png' if skill[1]=='Falchion'
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Missiletainn_Refines.png' if skill[1]=='Missiletainn'
    xpic='https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Adult_Refines.png' if skill[1]=='Adult (All)'
    if str.length>=1900
      str=str.split("\n\n")
      if str[-3,3].join("\n\n").length<1900
        str[-3]=str[-3,3].join("\n\n")
        str[-2]=nil
        str[-1]=nil
        str.compact!
      elsif str[-3,2].join("\n\n").length<1900
        str[-3]=str[-3,2].join("\n\n")
        str[-2]=nil
        str.compact!
      end
      disp=[]
      str2="#{str[0]}"
      for i in 1...str.length
        if "#{str2}\n\n#{str[i]}".length>=1900
          disp.push("#{str2}")
          str2="#{str[i]}"
        else
          str2="#{str2}\n\n#{str[i]}"
        end
      end
      disp.push("#{str2}")
      for i in 0...disp.length
        create_embed(event,'__**Refinery Options**__',disp[i],0x688C68,nil,xpic) if i==0
        create_embed(event,'',disp[i],0x688C68) unless i==0
      end
    else
      create_embed(event,'__**Refinery Options**__',str,0x688C68,nil,xpic)
    end
  end
  if has_any?(event.message.text.downcase.split(' '),['tags','tag'])
    str=''
    xcolor=0xFDDC7E
    xcolor=0xF4728C if skill[6]=='Weapon'
    xcolor=0x07DFBB if skill[6]=='Assist'
    xcolor=0xF67EF8 if skill[6]=='Special'
    k=skill[13]
    if k[0]=='Weapon'
      str="#{str}\n**Slot:**  <:Skill_Weapon:444078171114045450> Weapon"
      k.shift
      clrs=k.reject{|q| !['Red','Blue','Green','Colorless','Purple'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clrs[i]}_Unknown"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Color#{'s' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['Red','Blue','Green','Colorless','Purple'].include?(q)}
      clrs=k.reject{|q| !['Blade','Tome','Breath','Bow','Dagger','Staff','Beast','Gun'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{clrs[i]}"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Type#{'s' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['Blade','Tome','Breath','Bow','Dagger','Staff','Beast','Gun'].include?(q)}
      if k.reject{|q| q.include?('(E)') || q.include?('(R)') || q.include?('(T)') || q.include?('(TE)') || q.include?('(TR)') || q.include?('(ET)') || q.include?('(RT)') || q.include?('(T)(E)') || q.include?('(T)(R)') || q.include?('(E)(T)') || q.include?('(R)(T)')}.length<k.length
        flds=[['Base weapon',[]],['All refinements',[]],['Effect Mode refinement',[]],['Transformed base',[]],['Refined Transformation',[]],['Effect Transformation',[]]]
        for i in 0...k.length
          if k[i][0,3]=='(R)'
            flds[1][1].push(k[i][3,k[i].length-3])
          elsif k[i][0,3]=='(E)'
            flds[2][1].push(k[i][3,k[i].length-3])
          elsif k[i][0,3]=='(T)'
            flds[3][1].push(k[i][3,k[i].length-3])
          elsif ['(TR)','(RT)'].include?(k[i][0,4])
            flds[4][1].push(k[i][4,k[i].length-4])
          elsif ['(TE)','(ET)'].include?(k[i][0,4])
            flds[5][1].push(k[i][4,k[i].length-4])
          elsif ['(T)(R)','(R)(T)'].include?(k[i][0,6])
            flds[4][1].push(k[i][6,k[i].length-6])
          elsif ['(T)(E)','(E)(T)'].include?(k[i][0,6])
            flds[5][1].push(k[i][6,k[i].length-6])
          else
            flds[0][1].push(k[i])
          end
        end
        flds=flds.reject{|q| q[1].length<=0}.map{|q| [q[0],q[1].join("\n")]}
        flds=nil if flds.length<=0
        create_embed(event,'Searchable tags',str,xcolor,nil,nil,flds)
        return nil
      end
    elsif k[0]=='Assist'
      str="#{str}\n**Slot:** <:Skill_Assist:444078171025965066> Assist"
      k.shift
    elsif k[0]=='Special'
      str="#{str}\n**Slot:** <:Skill_Special:444078170665254929> Special"
      k.shift
    elsif k[0]=='Passive'
      str="#{str}\n**Type:** <:Passive:544139850677485579> Passive"
      k.shift
      clrs=k.reject{|q| !['A','B','C','Seal','W'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Passive_#{clrs[i].gsub('Seal','S')}"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Slot#{'s' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['A','B','C','Seal','W'].include?(q)}
    end
    if k.length<=0
      create_embed(event,'Searchable tags',str,xcolor)
    else
      create_embed(event,'Searchable tags',str,xcolor,nil,nil,triple_finish(k))
    end
  end
end

def unit_skills(name,event,justdefault=false,r=0,ignoretro=false,justweapon=false)
  data_load()
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  if name.nil? || name.length.zero?
    char=find_data_ex(:find_unit,event.message.text,event)
    char=char[0] if char[0].is_a?(Array)
  else
    char=find_unit(name,event)
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
  skllz=skllz.reject{|q| q[2]=='example' || !q[12].map{|q2| q2.split(', ').include?(char[0]) || q2.split(', ').include?("All #{clss}")}.include?(true)}
  skllz=skllz.reject{|q| q[6]!='Weapon'} if justweapon
  for i in 0...skllz.length
    for j in 0...rarity
      if skllz[i][11][j].split(', ').include?(char[0]) || skllz[i][11][j]=="All #{clss}"
        box[0].push(skllz[i]) if skllz[i][6]=='Weapon'
        box[1].push(skllz[i]) if skllz[i][6]=='Assist'
        box[2].push(skllz[i]) if skllz[i][6]=='Special'
        box[3].push(skllz[i]) if skllz[i][6].include?('Passive(A)')
        box[4].push(skllz[i]) if skllz[i][6].include?('Passive(B)')
        box[5].push(skllz[i]) if skllz[i][6].include?('Passive(C)')
      end
    end
    for j in 0...rarity
      if skllz[i][12][j].split(', ').include?(char[0]) || skllz[i][12][j]=="All #{clss}"
        sklz[0].push(skllz[i]) if skllz[i][6]=='Weapon'
        sklz[1].push(skllz[i]) if skllz[i][6]=='Assist'
        sklz[2].push(skllz[i]) if skllz[i][6]=='Special'
        sklz[3].push(skllz[i]) if skllz[i][6].include?('Passive(A)')
        sklz[4].push(skllz[i]) if skllz[i][6].include?('Passive(B)')
        sklz[5].push(skllz[i]) if skllz[i][6].include?('Passive(C)')
      elsif skllz[i][12][j].split(', ').include?("[Retro]#{char[0]}") || skllz[i][12][j].split(', ').include?("#{char[0]}[Retro]") || skllz[i][12][j].split(', ').include?("[Retro] #{char[0]}") || skllz[i][12][j].split(', ').include?("#{char[0]} [Retro]")
        retroprf.push(skllz[i][1])
      end
    end
    if skllz[i][8].split(', ').include?(char[0]) && rarity>5
      sklz[0].push(skllz[i]) if skllz[i][6]=='Weapon'
      sklz[1].push(skllz[i]) if skllz[i][6]=='Assist'
      sklz[2].push(skllz[i]) if skllz[i][6]=='Special'
      sklz[3].push(skllz[i]) if skllz[i][6].include?('Passive(A)')
      sklz[4].push(skllz[i]) if skllz[i][6].include?('Passive(B)')
      sklz[5].push(skllz[i]) if skllz[i][6].include?('Passive(C)')
      box[0].push(skllz[i]) if skllz[i][6]=='Weapon'
      box[1].push(skllz[i]) if skllz[i][6]=='Assist'
      box[2].push(skllz[i]) if skllz[i][6]=='Special'
    end
  end
  sklz=sklz.map{|q| q.uniq}
  box=box.map{|q| q.uniq}
  box2=[[],[],[],[],[],[]]
  sklz2=[[],[],[],[],[],[]]
  for i in 0...6
    box[i]=box[i].reject{|q| ['Missiletainn','Whelp (All)','Yearling (All)','Adult (All)','Falchion'].include?(q[1])}.sort{|a,b| a[0]<=>b[0]}
    box2[i].push('~~Unknown base~~') if box[i].length>0 && box[i][0][10]!='-'
    for j in 0...box[i].length
      checkstr="#{box[i][j][1]}#{' ' unless box[i][j][1][-1,1]=='+'}#{box[i][j][2]}"
      checkstr="#{box[i][j][1]}" if box[i][j][2]=='-' || ['Weapon','Assist','Special'].include?(box[i][j][6])
      box2[i].push(box[i][j][1])
    end
    sklz[i]=sklz[i].reject{|q| ['Missiletainn','Whelp (All)','Yearling (All)','Adult (All)','Falchion'].include?(q[1])}.sort{|a,b| a[0]<=>b[0]}
    sklz2[i].push('~~Unknown base~~') if sklz[i].length>0 && sklz[i][0][10]!='-'
    for j in 0...sklz[i].length
      checkstr="#{sklz[i][j][1]}#{' ' unless sklz[i][j][1][-1,1]=='+'}#{sklz[i][j][2]}"
      checkstr="#{sklz[i][j][1]}" if sklz[i][j][2]=='-' || ['Weapon','Assist','Special'].include?(sklz[i][j][6])
      sklz2[i].push(checkstr) if sklz[i][j][10]=='-' && !(i.zero? && sklz[i][j][8]!='-')
      retroprf.push(checkstr) if sklz[i][j][10]=='-' && i.zero? && sklz[i][j][8]!='-'
      sklz2[i].push(checkstr) if sklz[i][j][10]!='-'
    end
  end
  for i in 0...retroprf.length
    retroprf[i]="**#{retroprf[i]}**" if box2[0].include?(retroprf[i])
  end
  for i in 0...6
    box2[i].uniq!
    sklz2[i].uniq!
  end
  if char[12].split(', ')[0].gsub('*','')=='Hector' && char[1]==['Green', 'Blade'] && !justweapon
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
    s=find_skill(sklz2[0][sklz2[0].length-1].gsub('**',''),event)
    if !s[16].nil? && s[16].length>0 && s[6]=='Weapon'
      s2=s[16].split(', ')
      for i in 0...s2.length
        if s2[i].include?('!')
          s3=s2[i].split('!')
          sklz2[0].push("~~#{s3[1]}~~") if s3[0]==name && find_skill(s3[1],event,false,true).length>0
        else
          sklz2[0].push("~~#{s2[i]}~~") if find_skill(s2[i],event,false,true).length>0
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
        s=find_skill(sklz2[0][sklz2[0].length-1].gsub('**',''),event)
        if !s[16].nil? && s[16].length>0 && s[6]=='Weapon'
          s2=s[16].split(', ')
          for i in 0...s2.length
            if s2[i].include?('!')
              s3=s2[i].split('!')
              sklz2[0].push("~~#{s3[1]}~~") if s3[0]==name && find_skill(s3[1],event,false,true).length>0
            else
              sklz2[0].push("~~#{s2[i]}~~") if find_skill(s2[i],event,false,true).length>0
            end
          end
        end
      end
    end
  end
  unless r>0
    if has_any?(event.message.text.downcase.split(' '),['weaponless','zelgiused',"zelgius'd"]) || (name.downcase != 'zelgius' && event.message.text.downcase.split(' ').include?('zelgius'))
      sklz2[0]=['~~none~~']
      s=find_skill(sklz2[1][sklz2[1].length-1].gsub('**','').gsub('~~',''),event)
      if !s.nil? && s[8]!='-'
        sklz2[1].pop
        sklz2[1]=['~~none~~'] if sklz2[1].length<=0
      end
      s=find_skill(sklz2[2][sklz2[2].length-1].gsub('**','').gsub('~~',''),event)
      if !s.nil? && s[8]!='-'
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
  n=find_data_ex(:find_unit,event.message.text,event)
  if n=='Kiran'
    sklz2=[['**Breidablik**','~~Chill Breidablik~~'],['~~none~~'],['~~none~~'],['~~none~~'],['~~none~~'],['~~none~~']]
  else
    sklz2=unit_skills(name,event)
  end
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  if name.nil? || name.length.zero?
    char=find_data_ex(:find_unit,event.message.text,event)
    char=char[0] if char[0].is_a?(Array)
  else
    char=find_unit(name,event)
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  rarity=flurp[0]
  j=find_unit(name,event) unless name.nil? || name.length.zero?
  mu=false
  txt="#{@rarity_stars[rarity.to_i-1]*rarity.to_i}"
  ftrtoggles=[false,false,false,false]
  sklz2[0]=sklz2[0].reject {|a| ['Falchion','**Falchion**','Missiletainn','**Missiletainn**','Whelp (All)','**Whelp (All)**','Yearling (All)','**Yearling (All)**','Adult (All)','**Adult (All)**'].include?(a)}
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1]
      txt=display_stars(bot,event,rarity,@dev_units[dv][2],@dev_units[dv][5],['Infantry',0],false,j[11][0],true).split('  ')[0]
      sklz2=[@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],@dev_units[dv][12],[@dev_units[dv][13]]]
    elsif @dev_nobodies.include?(j[0])
      event.respond "Mathoo has this character but doesn't care enough about including their skills.  Showing default skills." unless chain
    elsif @dev_waifus.include?(j[0]) || @dev_somebodies.include?(j[0])
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing default skills.' unless chain
    else
      event.respond 'Mathoo does not have that character.  Showing default skills.' unless chain
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral skills."
    else
      rarity=x[x2][1]
      txt=display_stars(bot,event,rarity,x[x2][2],x[x2][5],['Infantry',0],false,j[11][0]).split('  ')[0]
      sklz2=[x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],x[x2][12],[x[x2][13]]]
    end
  else
    untz=@units.map{|q| q}
    sklz=@skills.map{|q| q}
    for mmm in 0...6
      unless sklz2[mmm][0]=='~~none~~'
        for i in 0...sklz2[mmm].length
          tmp=sklz2[mmm][i].gsub('~~','').gsub('*','').gsub('__','')
          unless tmp.downcase=='unknown base'
            tmp2=sklz[sklz.find_index{|q| q[2]!='example' && "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless q[2]=='-' || ['Weapon','Assist','Special'].include?(q[6])}"==tmp}]
            if tmp2[8]!='-' && tmp2[8].split(', ').include?(j[0])
              sklz2[mmm][i]="#{sklz2[mmm][i]}<:Prf_Sparkle:490307608973148180>"
              ftrtoggles[0]=true
            elsif !j[13][0].nil?
            else
              tmtmp=tmp2[12].reject{|q| q=='-' || q[0,4]=='All '}.join(', ').split(', ').reject{|q| untz[untz.find_index{|q2| q2[0]==q}][13][0]!=nil}
              if tmp2[6]=='Weapon' && tmtmp.length>0 && find_prevolutions(tmp2,event).length>0
                kxd=find_prevolutions(tmp2,event)
                for i2 in 0...kxd.length
                  tmtmp2=kxd[i2][0][12].reject{|q| q=='-' || q[0,4]=='All '}.join(', ').split(', ').reject{|q| untz[untz.find_index{|q2| q2[0]==q}][13][0]!=nil}
                  tmtmp="#{tmtmp.join(', ')}, #{tmtmp2.join(', ')}".split(', ')
                end
              end
              if tmtmp.length==0 && sklz2[mmm][i-1].include?('<')
                tmtmp2=tmp2[12].reject{|q| q=='-'}.join(', ').split(', ')
                for i2 in 0...tmtmp2.length
                  if tmtmp2[i2][0,4]=='All '
                  elsif untz[untz.find_index{|q2| q2[0]==tmtmp2[i2]}][13][0]!=nil
                    tmtmp2[i2]=nil
                  end
                end
                tmtmp2.compact!
                sklz2[mmm][i]="#{sklz2[mmm][i]}<#{sklz2[mmm][i-1].split('<')[1].gsub("  \u200B  ",'')}" if tmtmp2.length==0
              elsif tmtmp.length==0
              elsif tmtmp[0]==j[0] && tmtmp.length==1
                sklz2[mmm][i]="#{sklz2[mmm][i]}<:Arena_Crown:490334177124810772>"
                ftrtoggles[1]=true
              else
                tmtmp2=tmtmp.reject{|q| !untz[untz.find_index{|q2| q2[0]==q}][9][0].include?('p')}
                tmtmp=tmtmp.reject{|q| !untz[untz.find_index{|q2| q2[0]==q}][9][0].include?('p') || untz[untz.find_index{|q2| q2[0]==q}][9][0].include?('TD')}
                if tmtmp2[0]==j[0] && tmtmp2.length==1
                  sklz2[mmm][i]="#{sklz2[mmm][i]}<:Orb_Rainbow:471001777622351872>"
                  ftrtoggles[2]=true
                elsif tmtmp[0]==j[0] && tmtmp.length==1
                  sklz2[mmm][i]="#{sklz2[mmm][i]}<:Orb_Gold:549338084102111250>"
                  ftrtoggles[3]=true
                end
              end
            end
            tmp=tmp2[12]
            moji=''
            for i2 in 0...tmp.length
              if tmp[i2].split(', ').include?(j[0]) || (!tmp[i2].include?(', ') && tmp[i2][0,4]=='All ')
                moji="#{moji}#{@rarity_stars[i2]}"
              end
            end
            sklz2[mmm][i]="#{sklz2[mmm][i]}  \u200B  #{moji}" if moji.length>0
          end
        end
      end
    end
  end
  xcolor=unit_color(event,j,j[0],0,mu,chain)
  f=chain
  f=false if doubleunit
  txt="#{txt}\n"
  txt=' ' if f
  ftr=nil
  if ftrtoggles[1]
    ftr='Crowns mark inheritable skills only this unit has.'
    ftr='Purple sparkles mark Prf skills.  Crowns mark unique inheritable skills.' if ftrtoggles[0]
    ftr='Unique inheritable skills:  Crown = overall,   Gold orb = within Book 2-3 summon pool.' if ftrtoggles[3]
    ftr='Unique inheritable skills:  Crown = overall,   Orb = within non-limited summon pool.' if ftrtoggles[2]
  elsif ftrtoggles[0]
    ftr='Purple sparkles mark skills Prf to this unit.'
    ftr='Purple sparkles mark Prf skills.  Gold orbs mark semi-unique inheritable skills.' if ftrtoggles[3]
    ftr='Purple sparkles mark Prf skills.  Orbs mark semi-unique inheritable skills.' if ftrtoggles[2]
  elsif ftrtoggles[2]
    ftr='Orbs mark inheritable skills that within the non-limited summon pool, only this unit has.'
    ftr='Unique inheritable skills:  Gold orb = within Book 2-3 summon pool,  Rainbow orb = within non-limited summon pool.' if ftrtoggles[3]
  elsif ftrtoggles[3]
    ftr='Gold orbs mark inheritable skills that within the Book 2-3 summon pool, only this unit has.'
  end
  ftr='"Pandering to the minority gets you nowhere." - Shylock#2166' if event.user.id==198201016984797184
  flds=[["<:Skill_Weapon:444078171114045450> **Weapons**",sklz2[0].join("\n")],["<:Skill_Assist:444078171025965066> **Assists**",sklz2[1].join("\n")],["<:Skill_Special:444078170665254929> **Specials**",sklz2[2].join("\n")],["<:Passive_A:443677024192823327> **A Passives**",sklz2[3].join("\n")],["<:Passive_B:443677023257493506> **B Passives**",sklz2[4].join("\n")],["<:Passive_C:443677023555026954> **C Passives**",sklz2[5].join("\n")]]
  flds.push(["<:Passive_S:443677023626330122> **Sacred Seal**",sklz2[6][0]]) unless sklz2[6].nil? || sklz2[6][0].length.zero? || sklz2[6][0]==" "
  title=unit_clss(bot,event,j)
  title=nil if chain
  create_embed(event,["#{"__#{"Mathoo's " if mu}**#{j[0]}**__" unless f}",title],txt,xcolor,ftr,pick_thumbnail(event,j,bot),flds)
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
  s=remove_prefix(s,event)
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
  title=''
  x2='Effect'
  if k[0][2]=='Offensive/Defensive'
    xcolor=0x8CAA7B
    title="<:Battle_Structure:565064414454349843>**Type:** Offensive/Defensive"
  elsif k[0][2]=='Offensive'
    xcolor=0xF0631E
    title="<:Offensive_Structure:510774545997758464>**Type:** Offensive"
  elsif k[0][2]=='Defensive'
    xcolor=0x27F2D8
    title="<:Defensive_Structure:510774545108566016>**Type:** Defensive"
  elsif k[0][2]=='Trap'
    xcolor=0xB950E9
    title="<:Trap_Structure:510774545179869194>**Type:** Trap"
  elsif k[0][2]=='Resources'
    xcolor=0xD3DADC
    title="<:Resource_Structure:510774545154572298>**Type:** Resource"
  elsif k[0][2]=='Ornament'
    xcolor=0xFEE257
    title="<:Ornamental_Structure:510774545150640128>**Type:** Ornament"
    x2='Description'
  elsif k[0][2]=='Resort'
    xcolor=0xFEE257
    title="<:Resort_Structure:565064414521196561>**Type:** Resort"
    x2='Description'
  else
    title="**Type:** Unknown"
  end
  title="#{title}\n**#{x2}:** #{k[0][3]}" if k.map{|q| q[3]}.uniq.length<2
  title="#{title}\n<:Current_Aether_Bonus:510022809741950986>**Offense/Defense Aether Bonus Structure**" if b[0][3][0]==k[0][0] && b[0][3][1]==k[0][0]
  title="#{title}\n<:Current_Aether_Bonus:510022809741950986>**Offense Aether Bonus Structure**" if b[0][3][0]==k[0][0] && b[0][3][1]!=k[0][0]
  title="#{title}\n<:Current_Aether_Bonus:510022809741950986>**Defense Aether Bonus Structure**" if b[0][3][0]!=k[0][0] && b[0][3][1]==k[0][0]
  text=''
  if k.length>1
    for i in 0...k.length
      x=' '
      x="\n" if k.map{|q| q[3]}.uniq.length>1 || k.map{|q| q[4]}.uniq.length>1 || k.map{|q| q[7]}.uniq.length>1
      text="#{text}\n" if k.map{|q| q[3]}.uniq.length>1 || k.map{|q| q[4]}.uniq.length>1 || k.map{|q| q[7]}.uniq.length>1 || i.zero?
      text="#{text}\n**Level #{k[i][1]}:**"
      text="#{text}#{x}*Cost:* "
      text="#{text}#{k[i][5][0]}<:RRAffinity:565064751780986890>" if k[i][5][0]>0
      text="#{text}#{k[i][5][1]}<:Aether_Stone:510776805746278421>" if k[i][5][1]>0
      text="#{text}#{k[i][5][2]}<:Heavenly_Dew:510776806396395530>" if k[i][5][2]>0
      text="#{text}#{k[i][5][3]}<:Aether_Stone_SP:513982883560423425>" if k[i][5][3]>0
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
    text="#{text}#{k.map{|q| q[5][0]}.inject(0){|sum,x| sum + x }}<:RRAffinity:565064751780986890>" if k.map{|q| q[5][0]}.inject(0){|sum,x| sum + x }>0
    text="#{text}#{k.map{|q| q[5][1]}.inject(0){|sum,x| sum + x }}<:Aether_Stone:510776805746278421>" if k.map{|q| q[5][1]}.inject(0){|sum,x| sum + x }>0
    text="#{text}#{k.map{|q| q[5][2]}.inject(0){|sum,x| sum + x }}<:Heavenly_Dew:510776806396395530>" if k.map{|q| q[5][2]}.inject(0){|sum,x| sum + x }>0
    text="#{text}#{k.map{|q| q[5][3]}.inject(0){|sum,x| sum + x }}<:Aether_Stone_SP:513982883560423425>" if k.map{|q| q[5][3]}.inject(0){|sum,x| sum + x }>0
    text="#{text} (Requires reaching AR Tier #{k.map{|q| q[6]}.max})" if k.map{|q| q[6]}.max>0
  else
    text="#{text}\n\n**Cost:** " if k[0][5].max>0
    text="#{text}#{k[0][5][0]}<:RRAffinity:565064751780986890>" if k[0][5][0]>0
    text="#{text}#{k[0][5][1]}<:Aether_Stone:510776805746278421>" if k[0][5][1]>0
    text="#{text}#{k[0][5][2]}<:Heavenly_Dew:510776806396395530>" if k[0][5][2]>0
    text="#{text}#{k[0][5][3]}<:Aether_Stone_SP:513982883560423425>" if k[0][5][3]>0
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
  create_embed(event,["__**#{k[0][0]}#{" #{k[0][1]}" unless k.length>1 || k[0][1]=='-'}**__",title],text,xcolor,nil,xpic)
end

def disp_accessory(bot,name,event,ignore=false)
  data_load()
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ').reject{ |q| q.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=s.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  k=find_data_ex(:find_accessory,args.join(' '),event)
  if k.length<=0
    event.respond 'No matches found.' unless ignore
    return nil
  end
  xcolor=0xFF47FF
  title=''
  title="<:Accessory_Type_Hair:531733124741201940>**Accessory Type:** Hair" if k[1]=='Hair'
  title="<:Accessory_Type_Hat:531733125227741194>**Accessory Type:** Hat" if k[1]=='Hat'
  title="<:Accessory_Type_Mask:531733125064163329>**Accessory Type:** Mask" if k[1]=='Mask'
  title="<:Accessory_Type_Tiara:531733130734731284>**Accessory Type:** Tiara" if k[1]=='Tiara'
  str="**Description:** #{k[2]}"
  str="#{str}\n\n**To obtain:** #{k[3]}" unless k[3].nil?
  str="#{str}\n\n**Additional Info:** #{k[4]}" unless k[4].nil?
  xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Accessories/#{k[0].gsub(' ','_')}.png"
  create_embed(event,["__**#{k[0]}**__",title],str,xcolor,nil,xpic)
end

def disp_itemu(bot,name,event,ignore=false)
  data_load()
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ').reject{ |q| q.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=s.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  k=find_data_ex(:find_item_feh,args.join(' '),event)
  if k.length<=0
    event.respond 'No matches found.' unless ignore
    return nil
  end
  title="**Item Type:** #{k[1]}\n**Maximum:** #{k[2]}"
  str=''
  xcolor=0x5BACB9
  if ['Main','Event'].include?(k[1])
    str="**Effect/Description:** #{k[3]}"
  elsif k[1]=='Implied'
    xcolor=0x3B474D
    str="**Effect:** #{k[3]}"
  elsif k[1]=='Blessing'
    xcolor=0xF98281 if k[0].include?('Fire')
    xcolor=0x91F4FF if k[0].include?('Water')
    xcolor=0x97FF99 if k[0].include?('Wind')
    xcolor=0xFFAF7E if k[0].include?('Earth')
    xcolor=0xFDF39D if k[0].include?('Light')
    xcolor=0xBE83FE if k[0].include?('Dark')
    xcolor=0xF5A4DA if k[0].include?('Astra')
    xcolor=0xE1DACF if k[0].include?('Anima')
    str="**Description:** #{k[3]}"
  elsif k[1]=='Growth'
    xcolor=0xBD9843
    xcolor=0xE22141 if k[0].include?('Scarlet')
    xcolor=0x2764DE if k[0].include?('Azure')
    xcolor=0x09AA24 if k[0].include?('Verdant')
    xcolor=0x64757D if k[0].include?('Transparent')
    str="**Description:** #{k[3]}"
  elsif k[1]=='Assault'
    xcolor=0x332559
    title="**Type:** Arena Assault\n**Maximum:** #{k[2]}"
    str="**Effect:** #{k[3]}"
  else
    str="**Effect/Description:** #{k[3]}"
  end
  str="#{str}\n\n**Additional Info:** #{k[4]}" unless k[4].nil?
  xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Items/#{k[0].gsub(' ','_')}.png"
  create_embed(event,["__**#{k[0]}**__",title],str,xcolor,nil,xpic)
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
    k=sklz[sklz.find_index{|q| q[1]=='Dance'}]
    k2=sklz[sklz.find_index{|q| q[1]=='Sing'}]
    b=[]
    for i in 0...@max_rarity_merge[0]
      u=k[12][i].split(', ')
      for j in 0...u.length
        b.push(u[j]) unless b.include?(u[j]) || u[j].include?('-') || !has_any?(g, untz[untz.find_index{|q| q[0]==u[j]}][13][0])
      end
      u2=k2[12][i].split(', ')
      for j in 0...u2.length
        b.push(u2[j]) unless b.include?(u2[j]) || u2[j].include?('-') || !has_any?(g, untz[untz.find_index{|q| q[0]==u2[j]}][13][0])
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
  elsif ['bathing'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || !q[0].include?('(Bath)')}
    return ['Bathing',l.map{|q| q[0]}]
  elsif ['bunnies'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || (!q[0].include?('(Spring)') && !q[0].include?('(Bunny)'))}
    return ['Bunnies',l.map{|q| q[0]}]
  elsif ['picnic','lunch'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || (!q[0].include?('(Picnic)'))}
    return ['Picnic',l.map{|q| q[0]}]
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
    r=sklz.reject{|q| !(q[10]=='-' && q[6]=='Weapon' && q[8]!='-')}
    b=[]
    for i in 0...r.length
      u=r[i][8].split(', ')
      for j in 0...u.length
        b.push(u[j]) unless b.include?(u[j]) || u[j]=='Kiran' || !has_any?(g, untz[untz.find_index{|q| q[0]==u[j]}][13][0])
      end
    end
    r=sklz.reject{|q| q[6]!='Weapon'}.map{|q| q[12]}.map{|q| q.map{|q2| q2.split(', ').reject{|q3| !q3.include?('[Retro]')}.map{|q3| q3.gsub('[Retro]','')}}.reject{|q2| q2.length<=0}}.reject{|q| q.length<=0}
    for i in 0...r.length
      for i2 in 0...r[i].length
        for i3 in 0...r[i][i2].length
          b.push(r[i][i2][i3]) unless b.include?(r[i][i2][i3]) || r[i][i2][i3]=='Kiran' || !has_any?(g, untz[untz.find_index{|q| q[0]==r[i][i2][i3]}][13][0])
        end
      end
    end
    return ['Retro-Prfs',b.uniq]
  elsif ['falchion_users','falchionusers','falchion-users'].include?(name.downcase)
    k=sklz.reject{|q| q[1][0,10]!='Falchion ('}
    k2=[]
    for i in 0...k.length
      k2.push(k[i].map{|q| q})
      if !k[i][16].nil? && k[i][16].length>0
        m=k[i][16].split(', ')
        for i2 in 0...m.length
          k2.push(sklz[sklz.find_index{|q| q[1]==m[i2]}])
        end
      end
    end
    falusrs=k2.map{|q| q[12]}.join(', ').split(', ').reject{|q| q=='-' || !has_any?(g, untz[untz.find_index{|q2| q2[0]==q}][13][0])}.uniq.sort
    k=sklz.reject{|q| !has_any?(q[8].split(', '), falusrs) || q[6]!='Weapon'}
    return ['Falchion_Users',k.map{|q| q[8].split(', ')}.join(', ').split(', ').uniq.sort]
  elsif name.downcase=="mathoo'swaifus"
    metadata_load()
    return ["Mathoo'sWaifus",@dev_waifus]
  elsif name.downcase=='ghb'
    b=[]
    for i in 0...untz.length
      b.push(untz[i][0]) if untz[i][9][0].include?('g') && has_any?(g, untz[i][13][0])
    end
    return ['GHB',b]
  elsif name.downcase=='tempest'
    b=[]
    for i in 0...untz.length
      b.push(untz[i][0]) if untz[i][9][0].include?('t') && has_any?(g, untz[i][13][0])
    end
    return ['Tempest',b]
  elsif ['daily_rotation','dailyrotation','daily'].include?(name.downcase)
    b=[]
    for i in 0...untz.length
      b.push(untz[i][0]) if untz[i][9][0].include?('d') && has_any?(g, untz[i][13][0])
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
      f2.push(f[1][i]) if has_any?(g, untz[i][13][0])
    end
    return [f[0],f2]
  else
    return nil
  end
end

def split_list(event,list,headers,mode=0,x=true,loads='Units')
  spli=[]
  for i in 0...headers.length
    spli.push([])
  end
  if headers[0].is_a?(Array)
    for i2 in 0...headers.map{|q| q[1]}.max
      for i in 0...list.length
        mips=list[i][mode]
        mips=list[i][1][0] if mode==-2
        mips=list[i][1][1] if mode==-3
        mips=list[i][1][2] if mode==-4
        mips=list[i][2][0] if mode==-5
        mips=list[i][2][1] if mode==-6
        mips=list[i][7].split(', ')[1].gsub(' Only','') if mode==-9
        mips=weapon_clss(list[i][1],event) if mode==-7
        mips=list[i][5].split(' ')[0] if mode==-8
        mips=mips.split(', ') unless mips.is_a?(Array)
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
      mips=list[i][1][0] if mode==-2
      mips=list[i][1][1] if mode==-3
      mips=list[i][1][2] if mode==-4
      mips=list[i][2][0] if mode==-5
      mips=list[i][2][1] if mode==-6
      mips=list[i][7].split(', ')[1].gsub(' Only','') if mode==-9
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
      if loads=='Units'
        list[list.length-1][0]='- - -'
        list[list.length-1][13]=nil if loads=='Units'
      elsif loads=='Skills'
        list[list.length-1][0]+=1000000
        list[list.length-1][1]='- - -'
        list[list.length-1][15]=nil
      end
    end
  end
  return list.uniq
end

def collapse_skill_list_2(list,mode=0)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return list_collapse(list,mode)
end

def find_in_units(event,mode=0,paired=false,ignore_limit=false,args=nil)
  data_load()
  groups_load()
  srv=0
  srv=event.server.id unless event.server.nil?
  if args.nil?
    args=event.message.text.gsub(',','').split(' ')
    args.shift
  end
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
  lookout=lookout_load('Games')
  for i in 0...args.length
    args[i]=args[i].downcase.gsub('user','') if args[i].length>4 && args[i][args[i].length-4,4].downcase=='user'
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens','grean','greans'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','colorlesses','colourlesses','clear','clears'].include?(args[i].downcase)
    color_weapons.push(['Red','Blade']) if ['sword','swords','katana'].include?(args[i].downcase)
    color_weapons.push(['Blue','Blade']) if ['lance','lances','lancer','lancers','spear','spears','naginata'].include?(args[i].downcase)
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
    event.respond 'Your request is gibberish.' if ['hero','heroes','heros','unit','char','character','person','units','chars','charas','chara','people'].include?(args[0].downcase)
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
  args=event.message.text.gsub(',','').split(' ')
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
  lookout=lookout_load('SkillSubsets')
  for i in 0...args.length
    for i2 in 0...lookout.length
      if lookout[i2][1].include?(args[i].downcase)
        skill_types.push(lookout[i2][0]) if lookout[i2][2]=='Type'
        colors.push(lookout[i2][0]) if lookout[i2][2]=='Color'
        weapons.push(lookout[i2][0]) if lookout[i2][2]=='Class'
        weapon_subsets.push(lookout[i2][0]) if lookout[i2][2]=='Weapon'
        assists.push(lookout[i2][0]) if lookout[i2][2]=='Assist'
        specials.push(lookout[i2][0]) if lookout[i2][2]=='Special'
        passives.push(lookout[i2][0]) if lookout[i2][2]=='Slot'
        passive_subsets.push(lookout[i2][0]) if lookout[i2][2]=='Passive'
      end
    end
    color_weapons.push(['Red','Blade']) if ['sword','swords','katana'].include?(args[i].downcase)
    color_weapons.push(['Blue','Blade']) if ['lance','lances','lancer','lancers','spear','spears','naginata'].include?(args[i].downcase)
    color_weapons.push(['Green','Blade']) if ['axe','axes','ax','club','clubs'].include?(args[i].downcase)
    color_weapons.push(['Red','Tome']) if ['redtome','redtomes','redmage','redmages'].include?(args[i].downcase)
    color_weapons.push(['Blue','Tome']) if ['bluetome','bluetomes','bluemage','bluemages'].include?(args[i].downcase)
    color_weapons.push(['Green','Tome']) if ['greentome','greentomes','greenmage','greenmages'].include?(args[i].downcase)
  end
  for i in 0...args.length
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
  if passive_subsets.include?('Debuff') && !has_any?(['Damage','UnAtk','UnSpd','UnDef','UnRes'],passive_subsets)
    k=0
    for i in 0...passive_subsets.length
      if passive_subsets[i]=='HP'
        k+=1
        passive_subsets[i]='Damage'
      elsif passive_subsets[i]=='Atk'
        k+=1
        passive_subsets[i]='UnAtk'
      elsif passive_subsets[i]=='Spd'
        k+=1
        passive_subsets[i]='UnSpd'
      elsif passive_subsets[i]=='Def'
        k+=1
        passive_subsets[i]='UnDef'
      elsif passive_subsets[i]=='Res'
        k+=1
        passive_subsets[i]='UnRes'
      end
    end
    if k>0
      for i in 0...passive_subsets.length
        passive_subsets[i]=nil if passive_subsets[i]=='Debuff'
      end
      passive_subsets.compact!
    end
  end
  passive_subsets=passive_subsets.uniq
  # prune based on inputs
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  matches0=[]
  all_skills=@skills.reject{|q| !has_any?(g, q[15]) || (q[6].split(', ').include?('Passive(W)') && !q[6].split(', ').include?('Passive(S)') && !q[6].split(', ').include?('Seal') && q[12].map{|q2| q2.length}.max<2)}
  for i in 0...all_skills.length
    all_skills[i][6]=all_skills[i][6].gsub(', Passive(W)','')
  end
  data_load()
  tmp=@skills.reject{|q| !has_any?(g, q[15]) || !q[6].include?(', Passive(W)')}.reject{|q| q[14].split(', ').reject{|q2| find_skill(q2,event).length<=0}.length<=0}
  for i in 0...tmp.length
    x=1
    x=-1 if tmp[i][0]<0
    tmp[i][0]*=x
    tmp[i][0]=tmp[i][0]%100000+600000
    tmp[i][0]*=x
    tmp[i][6]='Passive(W)'
    all_skills.push(tmp[i])
  end
  skill_types.push('Weapon') if (!colors.length.zero? || !weapons.length.zero? || !color_weapons.length.zero?) && assists.length.zero? && specials.length.zero? && passives.length.zero? && weapon_subsets.length.zero? && passive_subsets.length.zero?
  if skill_types.length.zero? && colors.length.zero? && weapons.length.zero? && color_weapons.length.zero? && assists.length.zero? && specials.length.zero? && passives.length.zero? && weapon_subsets.length.zero? && passive_subsets.length.zero?
    matches3=all_skills.map{|q| q}.uniq
  else
    if skill_types.length>0
      for i in 0...all_skills.length
        for j in 0...skill_types.length
          matches0.push(all_skills[i]) if all_skills[i][13].include?(skill_types[j])
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
              matches1.push(matches0[i]) if matches0[i][6]=='Weapon' && matches0[i][13].include?(weapons[j]) && matches0[i][13].include?(colors[j])
            end
          end
        end
      elsif colors.length>0
        for i in 0...matches0.length
          for j in 0...colors.length
            matches1.push(matches0[i]) if matches0[i][6]=='Weapon' && matches0[i][13].include?(colors[j])
          end
        end
      elsif weapons.length>0
        for i in 0...matches0.length
          for j in 0...weapons.length
            matches1.push(matches0[i]) if matches0[i][6]=='Weapon' && matches0[i][13].include?(weapons[j])
          end
        end
      elsif color_weapons.length>0
        for i in 0...matches0.length
          for j in 0...color_weapons.length
            matches1.push(matches0[i]) if matches0[i][6]=='Weapon' && matches0[i][13].include?(color_weapons[j][1]) && matches0[i][13].include?(color_weapons[j][0])
          end
        end
        cwc=true
      else
        matches1=matches0.reject{|q| q[6]!='Weapon'}.map{|q| q}
      end
      if color_weapons.length>0 && !cwc
        matches1=[] if matches1.reject{|q| !has_any?(g, q[15])}==all_skills.reject{|q| q[6]!='Weapon'}
        for i in 0...all_skills.length
          for j in 0...color_weapons.length
            p1=all_skills[i][13]
            matches1.push(all_skills[i]) if " #{p1},".include?(" #{color_weapons[j][0]},") && " #{p1},".include?(" #{color_weapons[j][1]},") && all_skills[i][6]=='Weapon'
          end
        end
      end
      # Specific types
      matches2=matches1.map{|q| q}
      if assists.length>0
        for i in 0...matches0.length
          for j in 0...assists.length
            matches2.push(matches0[i]) if matches0[i][6]=='Assist' && matches0[i][13].include?(assists[j])
          end
        end
      else
        for i in 0...matches0.length
          matches2.push(matches0[i]) if matches0[i][6]=='Assist' && (skill_types.reject{|q| q.include?('*')}.length.zero? || skill_types.map{|q| q.gsub('*','')}.include?('Assist'))
        end
      end
      if specials.length>0
        for i in 0...matches0.length
          for j in 0...specials.length
            matches2.push(matches0[i]) if matches0[i][6]=='Special' && matches0[i][13].include?(specials[j])
          end
        end
      else
        for i in 0...matches0.length
          matches2.push(matches0[i]) if matches0[i][6]=='Special' && (skill_types.reject{|q| q.include?('*')}.length.zero? || skill_types.map{|q| q.gsub('*','')}.include?('Special'))
        end
      end
      if passives.length>0
        for i in 0...matches0.length
          matches2.push(matches0[i]) if matches0[i][6].include?('Passive(A)') && passives.include?('A')
          matches2.push(matches0[i]) if matches0[i][6].include?('Passive(B)') && passives.include?('B')
          matches2.push(matches0[i]) if matches0[i][6].include?('Passive(C)') && passives.include?('C')
          matches2.push(matches0[i]) if matches0[i][6].include?('Seal') && passives.include?('Seal')
          matches2.push(matches0[i]) if matches0[i][6].include?('Passive(W)') && passives.include?('W')
        end
      else
        for i in 0...matches0.length
          if matches0[i][13].include?('Passive')
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
              if matches2[i][6]=='Weapon' && weapon_subsets[j]=='Inheritable'
                matches3.push(matches2[i]) if matches2[i][8]=='-'
              elsif matches2[i][6]=='Weapon' && weapon_subsets[j]=='Prf'
                matches3.push(matches2[i]) unless matches2[i][8]=='-'
              elsif matches2[i][6]=='Weapon' && weapon_subsets[j]=='Pega-killer' && !weapon_subsets.include?('Effective')
                matches3.push(matches2[i]) if (matches2[i][7]=='Bow Users Only' && !matches2[i][13].include?('UnBow')) || matches2[i][11].include?(weapon_subsets[j])
              elsif matches2[i][6]=='Weapon' && weapon_subsets[j]=='Retro-Prf'
                matches3.push(matches2[i]) if matches2[i][6]=='Weapons' && matches2[i][8]!='-' && matches2[i][10]=='-'
              elsif matches2[i][6]=='Weapon' && matches2[i][13].include?(weapon_subsets[j])
                matches3.push(matches2[i])
              elsif matches2[i][6]=='Weapon' && has_any?(matches2[i][13],["(TR)#{weapon_subsets[j]}","(RT)#{weapon_subsets[j]}","(T)(R)#{weapon_subsets[j]}","(R)(T)#{weapon_subsets[j]}"])
                matches2[i][1]="#{matches2[i][1]} *(+) [Tsfrm]All*"
                matches3.push(matches2[i])
              elsif matches2[i][6]=='Weapon' && has_any?(matches2[i][11],["(TE)#{weapon_subsets[j]}","(ET)#{weapon_subsets[j]}","(T)(E)#{weapon_subsets[j]}","(E)(T)#{weapon_subsets[j]}"])
                matches2[i][1]="#{matches2[i][1]} *(+) [Tsfrm]Effect*"
                matches3.push(matches2[i])
              elsif matches2[i][6]=='Weapon' && matches2[i][13].include?("(R)#{weapon_subsets[j]}")
                matches2[i][1]="#{matches2[i][1]} *(+) All*"
                matches3.push(matches2[i])
              elsif matches2[i][6]=='Weapon' && matches2[i][13].include?("(E)#{weapon_subsets[j]}")
                matches2[i][1]="#{matches2[i][1]} *(+) Effect*"
                matches3.push(matches2[i])
              elsif matches2[i][6]=='Weapon' && matches2[i][13].include?("(T)#{weapon_subsets[j]}")
                matches2[i][1]="#{matches2[i][1]} *- Transformed*"
                matches3.push(matches2[i])
              end
            end
          end
        elsif weapons.length>0 || colors.length>0 || color_weapons.length>0 || skill_types.map{|q| q.gsub('*','')}.include?('Weapon')
          for i in 0...matches2.length
            matches3.push(matches2[i]) if matches2[i][6]=='Weapon'
          end
        end
        if assists.length>0 || skill_types.include?('Assist')
          for i in 0...matches2.length
            matches3.push(matches2[i]) if matches2[i][6]=='Assist'
          end
        end
        if specials.length>0 || skill_types.include?('Special')
          for i in 0...matches2.length
            matches3.push(matches2[i]) if matches2[i][6]=='Special'
          end
        end
        if passive_subsets.length>0
          for i in 0...matches2.length
            for j in 0...passive_subsets.length
              matches3.push(matches2[i]) if (matches2[i][6].include?('Passive') || matches2[i][6]=='Seal') && matches2[i][13].include?(passive_subsets[j])
            end
          end
        elsif passives.length>0 || skill_types.include?('Passive')
          for i in 0...matches2.length
            matches3.push(matches2[i]) if matches2[i][6].include?('Passive') || matches2[i][6]=='Seal'
          end
        end
      end
    end
  end
  g=get_markers(event)
  matches4=collapse_skill_list_2(matches3.reject{|q| !has_any?(g, q[15])},3)
  skill_types=skill_types.reject{|q| q.include?('*')}
  if mode==2
  elsif skill_types.length<=0 && weapons==['Staff'] && assists==['Staff'] && specials==['Staff']
    # Staff skills are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Weapons','Assists','Specials','Passives'],6,true,'Skills')
  elsif (weapons==['Blade'] && colors.length<=0 && color_weapons.length<=0) || (color_weapons.length>0 && color_weapons.map{|q| q[1]}.reject{|q| q=='Blade'}.length<=0 && weapons.length<=0 && colors.length<=0)
    # Blades are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Sword','Lance','Axe','Rod'],7,true,'Skills')
  elsif weapons==['Beast'] || (color_weapons.length>0 && color_weapons.map{|q| q[1]}.reject{|q| q=='Beast'}.length<=0 && weapons.length<=0 && colors.length<=0)
    # beast weapons are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Infantry','Fliers','Cavalry','Armor'],-9,true,'Skills')
  elsif (weapons==['Tome'] && colors==['Red'] && color_weapons.length<=0) || (colors.length<=0 && weapons.length<=0 && color_weapons==[['Red','Tome']])
    # Red Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Fire','Raudr','Dark'],2,true,'Skills')
  elsif (weapons==['Tome'] && colors==['Blue'] && color_weapons.length<=0) || (colors.length<=0 && weapons.length<=0 && color_weapons==[['Blue','Tome']])
    # Blue Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Thunder','Blar','Light'],2,true,'Skills')
  elsif (weapons==['Tome'] && colors==['Green'] && color_weapons.length<=0) || (colors.length<=0 && weapons.length<=0 && color_weapons==[['Green','Tome']])
    # Green Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Wind','Gronn'],2,true,'Skills')
  elsif (weapons==['Tome'] && colors.length<=0 && color_weapons.length<=0) || (color_weapons.length>0 && color_weapons.map{|q| q[1]}.reject{|q| q=='Tome'}.length<=0 && weapons.length<=0 && colors.length<=0)
    # Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Red Tome','Blue Tome','Green Tome'],7,true,'Skills')
  elsif colors==['Red'] && weapons.length<=0 && color_weapons.length<=0
    # Red is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Sword','Red Tome','Dragon','Beast','Bow','Dagger','Staff'],7,true,'Skills')
  elsif colors==['Blue'] && weapons.length<=0 && color_weapons.length<=0
    # Blue is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Lance','Blue Tome','Dragon','Beast','Bow','Dagger','Staff'],7,true,'Skills')
  elsif colors==['Green'] && weapons.length<=0 && color_weapons.length<=0
    # Green is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Axe','Green Tome','Dragon','Beast','Bow','Dagger','Staff'],7,true,'Skills')
  elsif colors==['Colorless'] && weapons.length<=0 && color_weapons.length<=0
    # Colorless is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Rod','Colorless Tome','Dragon','Beast','Bow','Dagger','Staff'],7,true,'Skills')
  elsif matches4.map{|q| q[1]}.join("\n").length<=1800 && matches4.map{|q| q[6]}.uniq.length==1 && matches4.map{|q| q[6]}.uniq[0]=='Weapon' && matches4.map{|q| q[13]}.uniq.length>1
    matches4=split_list(event,matches4,['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Rod','Colorless Tome','Dragon','Beast','Bow','Dagger','Staff'],7,true,'Skills')
  elsif matches4.map{|q| q[1]}.join("\n").length<=1800 && matches4.map{|q| q[6]}.uniq.length==1 && matches4.map{|q| q[6]}.uniq[0]=='Assist' && matches4.map{|q| q[7]}.uniq.length>1
    matches4=split_list(event,matches4,[['Rally',1],['Move',2],['Music',1],['Health',2],['Staff',1]],13,true,'Skills')
  elsif matches4.map{|q| q[0]}.join("\n").length<=1800 && matches4.map{|q| q[6]}.uniq.length==1 && matches4.map{|q| q[6]}.uniq[0]=='Special'
    if matches4.reject{|q| q[13].include?('Offensive')}.length.zero? && matches4[0][13].include?('Offensive')
      matches4=split_list(event,matches4,[['StarSpecial',2],['MoonSpecial',2],['SunSpecial',2],['EclipseSpecial',1],['FireSpecial',2],['IceSpecial',2],['DragonSpecial',2],['DarkSpecial',2],['RendSpecial',2]],13,true,'Skills')
    elsif matches4.reject{|q| q[13].include?('Defensive')}.length.zero? && matches4[0][13].include?('Defensive')
      matches4=split_list(event,matches4,[['MiracleSpecial',2],['SupershieldSpecial',1],['AegisSpecial',2],['PaviseSpecial',2]],13,true,'Skills')
    elsif matches4.map{|q| q[7]}.uniq.length>1
      matches4=split_list(event,matches4,[['Offensive',1],['Defensive',1],['AoE',1],['Staff',1]],13,true,'Skills')
    end
  elsif !has_any?(matches4.map{|q| q[6]}.uniq, ['Weapon', 'Assist', 'Special'])
    ptypes=matches4.map{|q| q[6]}.uniq
    if passives==['Seal'] || ptypes==ptypes.reject{|q| !q.split(', ').include?('Seal')} # when only seals are listed, sort by color.
      matches4=split_list(event,matches4,['Scarlet','Azure','Verdant','Transparent','Gold','-'],-8,true,'Skills')
    elsif passives==['W'] || ptypes==ptypes.reject{|q| !q.split(', ').include?('Passive(W)')} # when only weapon passives are listed, ignore sorting
    elsif passives.length<=0 # otherwise, sort by passive type
      matches4=split_list(event,matches4,['Passive(A)','Passive(B)','Passive(C)','Passive(S)','Passive(W)'],6,true,'Skills')
    end
  end
  data_load()
  microskills=collapse_skill_list_2(@skills.map{|q| q},4)
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  matches4=matches4.reject{|q| !has_any?(g, q[15])}
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
  m.push("*Passive slots:* #{passives.join(', ')}") if passives.length>0
  m.push("*Passive subtypes:* #{passive_subsets.join(', ')}") if passive_subsets.length>0
  if matches4.length>=microskills.length && !(args.nil? || args.length.zero?) && !safe_to_spam?(event)
    event.respond 'Your request is gibberish.' if ['skill','skills'].include?(args[0].downcase)
    return -1
  elsif matches4.length.zero?
    event.respond 'There were no skills that matched your request.' unless paired
    return -2
  elsif mode==1
    f=matches4.map{|k| k[1]}
    return [m,f]
  elsif mode==2 || mode==3
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
      unless ['- - -'].include?(k[i])
        m2=untz[untz.find_index{|q2| q2[0]==k[i].gsub(' *[Amiibo]*','').gsub(' *[Assist Trophy]*','').gsub(' *[Mii Costume]*','').gsub(' *[Trophy]*','').gsub(' *[Sticker]*','').gsub(' *[Spirit]*','')}]
        m='~~' unless m2[13][0].nil?
        m='*' if m2[9][0].downcase.gsub('0s','')=='-'
      end
      m='' if m=='*' && k.reject{|q| !q.include?(' *[')}.length>0
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
        wpn1=p1[i].map{|q| untz[untz.find_index{|q2| q2[0]==q.gsub('~~','').gsub(' *[Amiibo]*','').gsub(' *[Assist Trophy]*','').gsub(' *[Mii Costume]*','').gsub(' *[Trophy]*','').gsub(' *[Sticker]*','').gsub(' *[Spirit]*','').gsub('*','')}][1]}
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
          mov=p1[i][1].map{|q| untz[untz.find_index{|q2| q2[0]==q.gsub('~~','').gsub(' *[Amiibo]*','').gsub(' *[Assist Trophy]*','').gsub(' *[Mii Costume]*','').gsub(' *[Trophy]*','').gsub(' *[Sticker]*','').gsub(' *[Spirit]*','').gsub('*','')}][3]}.uniq
          if mov.length<=1
            p1[i][0]='<:Icon_Move_Infantry:443331187579289601> Infantry' if mov[0]=='Infantry'
            p1[i][0]='<:Icon_Move_Armor:443331186316673025> Armor' if mov[0]=='Armor'
            p1[i][0]='<:Icon_Move_Flier:443331186698354698> Flying' if mov[0]=='Flier'
            p1[i][0]='<:Icon_Move_Cavalry:443331186530451466> Cavalry' if mov[0]=='Cavalry'
          end
        end
      end
      if mode==1
        create_embed(event,"#{"__**Unit Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__",'',0x9400D3,"#{p1.map{|q| q[1].length}.inject(0){|sum,x| sum + x }} total",nil,p1.map{|q| [q[0],q[1].join("\n")]})
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
          event.respond "#{"__**Unit Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__\n#{k.join(jchar)}\n\n#{k.length} total"
        else
          create_embed(event,"#{"__**Unit Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__",'',0x9400D3,"#{k.length} total",nil,triple_finish(k))
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
  k=find_in_skills(event,3)
  if k.is_a?(Array)
    mk=k[0]
    k=k[1]
  end
  data_load()
  if k.is_a?(Array)
    data_load()
    untz=@units.map{|q| q}
    for i in 0...k.length
      m=''
      unless ['- - -'].include?(k[i][1])
        m='~~' if !k[i][15].nil? && k[i][15].length>0
        unless k[i][8]=='-'
          m2=k[i][8].split(', ').reject{|q| untz.find_index{|q2| q2[0]==q}.nil? || untz[untz.find_index{|q2| q2[0]==q}][9][0].gsub('0s','').downcase=='-'}
          m='*' if m2.length<=0
        end
      end
      k[i][1]="#{m}#{k[i][1]}#{m}"
      if k[i][1]!='- - -' && k[i][12].join(', ').split(', ').reject{|q| q=='-' || untz.find_index{|q2| q2[0]==q}.nil? || untz[untz.find_index{|q2| q2[0]==q}][8]>=1000}.length<=0
        if k[i][6]=='Weapon'
          k2=k[i].map{|q| q}
          k2[1]=k2[1].gsub('[+]','+')
          k[i][1]="#{k[i][1]} - *unavailable*" unless find_prevolutions(k2,event).length>0 || k[i][12].join(', ').split(', ').reject{|q| q[0,4]!='All '}.length>0
        elsif ['Assist','Special'].include?(k[i][6])
          k[i][1]="#{k[i][1]} - *unavailable*" unless k[i][12].join(', ').split(', ').reject{|q| q[0,4]!='All '}.length>0
        else
          k[i][1]="#{k[i][1]} - *unavailable*" if !has_any?(k[i][6].split(', '),['Passive(S)','Seal','Passive(W)'])
        end
      end
    end
    if k.map{|q| q[1]}.include?('- - -')
      p1=[['.',[]]]
      p2=0
      for i in 0...k.length
        if k[i][1]=='- - -'
          p2+=1
          p1.push(['.',[]])
        else
          p1[p2][1].push(k[i])
        end
      end
      colorsx=k.reject{|q| q[1]=='- - -' || q[6]!='Weapon'}.map{|q| q[13].reject{|q2| !['Red','Blue','Green','Colorless','Gold'].include?(q2)}}
      colors=[]
      colors.push('Red') if colorsx.reject{|q| q.include?('Red')}.length<=0
      colors.push('Blue') if colorsx.reject{|q| q.include?('Blue')}.length<=0
      colors.push('Green') if colorsx.reject{|q| q.include?('Green')}.length<=0
      colors.push('Colorless') if colorsx.reject{|q| q.include?('Colorless')}.length<=0
      colors.push('Gold') if colorsx.reject{|q| q.include?('Gold')}.length<=0
      emotes=['<:Gold_Staff:443172811628871720>','<:Gold_Dagger:443172811461230603>','<:Gold_Dragon:443172811641454592>','<:Gold_Bow:443172812492898314>','<:Gold_Beast:532854442299752469>']
      emotes[0]='<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')
      emotes=['<:Red_Staff:443172812455280640>','<:Red_Dagger:443172811490721804>','<:Red_Dragon:443172811796774932>','<:Red_Bow:443172812455280641>','<:Red_Beast:532853459444170753>'] if colors.length==1 && colors[0]=='Red'
      emotes=['<:Blue_Staff:467112472407703553>','<:Blue_Dagger:467112472625545217>','<:Blue_Dragon:467112473313542144>','<:Blue_Bow:467112473313542155>','<:Blue_Beast:532853459842629642>'] if colors.length==1 && colors[0]=='Blue'
      emotes=['<:Green_Staff:467122927616262144>','<:Green_Dagger:467122926655897610>','<:Green_Dragon:467122926718550026>','<:Green_Bow:467122927536570380>','<:Green_Beast:532853459779846154>'] if colors.length==1 && colors[0]=='Green'
      emotes=['<:Colorless_Staff:443692132323295243>','<:Colorless_Dagger:443692132683743232>','<:Colorless_Dragon:443692132415438849>','<:Colorless_Bow:443692132616896512>','<:Colorless_Beast:532853459804749844>'] if colors.length==1 && colors[0]=='Colorless'
      emotes[0]='<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')
      ftr=''
      for i in 0...p1.length
        if k.reject{|q| q[6]=='Weapon'}.length<=0 # only weapons
          p1[i][0]='<:Skill_Weapon:444078171114045450> Weapons'
          if k.reject{|q| q[7]=='Red Tome Users Only'}.length<=0
            p1[i][0]='<:Red_Tome:443172811826003968> Red Tomes'
            p1[i][0]='<:Red_Tome:443172811826003968> Raudr Magic' if p1[i][1].reject{|q| q[2]=='Raudr'}.length<=0
            p1[i][0]='<:Fire_Tome:499760605826252800> Fire Magic' if p1[i][1].reject{|q| q[2]=='Fire'}.length<=0
            p1[i][0]='<:Dark_Tome:499958772073103380> Dark Magic' if p1[i][1].reject{|q| q[2]=='Dark'}.length<=0
          elsif k.reject{|q| q[7]=='Blue Tome Users Only'}.length<=0
            p1[i][0]='<:Blue_Tome:467112472394858508> Blue Tomes'
            p1[i][0]='<:Blue_Tome:467112472394858508> Blar Magic' if p1[i][1].reject{|q| q[2]=='Blar'}.length<=0
            p1[i][0]='<:Light_Tome:499760605381787650> Light Magic' if p1[i][1].reject{|q| q[2]=='Light'}.length<=0
            p1[i][0]='<:Thunder_Tome:499790911178539009> Thunder Magic' if p1[i][1].reject{|q| q[2]=='Thunder'}.length<=0
          elsif k.reject{|q| q[7]=='Green Tome Users Only'}.length<=0
            p1[i][0]='<:Green_Tome:467122927666593822> Green Tomes'
            p1[i][0]='<:Green_Tome:467122927666593822> Gronn Magic' if p1[i][1].reject{|q| q[2]=='Gronn'}.length<=0
            p1[i][0]='<:Wind_Tome:499760605713137664> Wind Magic' if p1[i][1].reject{|q| q[2]=='Wind'}.length<=0
          elsif k.reject{|q| q[7].include?('Beasts Only')}.length<=0
            p1[i][0]="#{emotes[4]} Beast Damage"
            if p1[i][1].reject{|q| q[7]=='Beasts Only, Infantry Only'}.length<=0
              p1[i][0]="#{emotes[4]}<:Icon_Move_Infantry:443331187579289601> Infantry Beast weapons"
            elsif p1[i][1].reject{|q| q[7]=='Beasts Only, Fliers Only'}.length<=0
              p1[i][0]="#{emotes[4]}<:Icon_Move_Flier:443331186698354698> Flying Beast weapons"
            elsif p1[i][1].reject{|q| q[7]=='Beasts Only, Cavalry Only'}.length<=0
              p1[i][0]="#{emotes[4]}<:Icon_Move_Cavalry:443331186530451466> Cavalry Beast weapons"
            elsif p1[i][1].reject{|q| q[7]=='Beasts Only, Armor Only'}.length<=0
              p1[i][0]="#{emotes[4]}<:Icon_Move_Armor:443331186316673025> Armor Beast weapons"
            end
          elsif p1[i][1].reject{|q| q[7]=='Sword Users Only'}.length<=0
            p1[i][0]='<:Red_Blade:443172811830198282> Swords'
          elsif p1[i][1].reject{|q| q[7]=='Red Tome Users Only'}.length<=0
            p1[i][0]='<:Red_Tome:443172811826003968> Red Tomes'
          elsif p1[i][1].reject{|q| q[7]=='Lance Users Only'}.length<=0
            p1[i][0]='<:Blue_Blade:467112472768151562> Lances'
          elsif p1[i][1].reject{|q| q[7]=='Blue Tome Users Only'}.length<=0
            p1[i][0]='<:Blue_Tome:467112472394858508> Blue Tomes'
          elsif p1[i][1].reject{|q| q[7]=='Axe Users Only'}.length<=0
            p1[i][0]='<:Green_Blade:467122927230386207> Axes'
          elsif p1[i][1].reject{|q| q[7]=='Green Tome Users Only'}.length<=0
            p1[i][0]='<:Green_Tome:467122927666593822> Green Tomes'
          elsif p1[i][1].reject{|q| q[7]=='Dragons Only'}.length<=0
            p1[i][0]="#{emotes[2]} Dragon Breaths"
          elsif p1[i][1].reject{|q| q[7]=='Bow Users Only'}.length<=0
            p1[i][0]="#{emotes[3]} Bows"
          elsif p1[i][1].reject{|q| q[7]=='Dagger Users Only'}.length<=0
            p1[i][0]="#{emotes[1]} Daggers"
          elsif p1[i][1].reject{|q| q[7].include?('Beasts Only')}.length<=0
            p1[i][0]="#{emotes[4]} Beast Damage"
          elsif p1[i][1].reject{|q| q[7]=='Staff Users Only'}.length<=0
            p1[i][0]="#{emotes[0]} Damaging Staves"
          end
        elsif k.reject{|q| q[6]=='Assist'}.length<=0 # only assists
          p1[i][0]='<:Skill_Assist:444078171025965066> Assists'
          if p1[i][1].reject{|q| q[13].include?('Music')}.length<=0
            p1[i][0]='<:Assist_Music:454462054959415296> Musical Assists'
          elsif p1[i][1].reject{|q| q[13].include?('Staff')}.length<=0
            p1[i][0]='<:Assist_Staff:454451496831025162> Healing Staves'
          elsif p1[i][1].reject{|q| q[13].include?('Move')}.length<=0
            p1[i][0]='<:Assist_Move:454462055479508993> Movement Assists'
          elsif p1[i][1].reject{|q| q[13].include?('Health')}.length<=0
            p1[i][0]='<:Assist_Health:454462054636584981> Health Assists'
          elsif p1[i][1].reject{|q| q[13].include?('Rally')}.length<=0
            p1[i][0]='<:Assist_Rally:454462054619807747> Rally Assists'
          elsif p1[i][1].map{|q| q[13]}.uniq.length<=1
            p1[i][0]='<:Assist_Unknown:454451496482897921> Misc. Assists'
          end
        elsif k.reject{|q| q[6]=='Special'}.length<=0 # only specials
          p1[i][0]='<:Skill_Special:444078170665254929> Specials'
          if k.reject{|q| q[13].include?('Offensive')}.length<=0
            p1[i][0]='<:Special_Offensive:454460020793278475> Offensive Specials'
            if p1[i][1].reject{|q| q[13].include?('EclipseSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Eclipse:454473651308199956> Eclipse Specials'
            elsif p1[i][1].reject{|q| q[13].include?('StarSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Star:454473651396542504> Star Specials'
            elsif p1[i][1].reject{|q| q[13].include?('MoonSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Moon:454473651345948683> Moon Specials'
            elsif p1[i][1].reject{|q| q[13].include?('SunSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Sun:454473651429965834> Sun Specials'
            elsif p1[i][1].reject{|q| q[13].include?('FireSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Fire:454473651861979156> Fire Specials'
            elsif p1[i][1].reject{|q| q[13].include?('IceSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Ice:454473651291422720> Ice Specials'
            elsif p1[i][1].reject{|q| q[13].include?('DragonSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Dragon:454473651186696192> Dragon Specials'
            elsif p1[i][1].reject{|q| q[13].include?('DarkSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Darkness:454473651010535435> Darkness Specials'
            elsif p1[i][1].reject{|q| q[13].include?('RendSpecial')}.length<=0
              p1[i][0]='<:Special_Offensive_Rend:454473651119718401> Rend Specials'
            end
          elsif k.reject{|q| q[13].include?('Defensive')}.length<=0
            p1[i][0]='<:Special_Defensive:454460020591951884> Defensive Specials'
            if p1[i][1].reject{|q| q[13].include?('SupershieldSpecial')}.length<=0
              p1[i][0]='<:Special_Defensive_Supershield:454460021066170378> Supershield Specials'
            elsif p1[i][1].reject{|q| q[13].include?('AegisSpecial')}.length<=0
              p1[i][0]='<:Special_Defensive_Aegis:454460020625768470> Aegis Specials'
            elsif p1[i][1].reject{|q| q[13].include?('PaviseSpecial')}.length<=0
              p1[i][0]='<:Special_Defensive_Pavise:454460020801929237> Pavise Specials'
            elsif p1[i][1].reject{|q| q[13].include?('MiracleSpecial')}.length<=0
              p1[i][0]='<:Special_Defensive_Miracle:454460020973764610> Miracle Specials'
            end
          elsif p1[i][1].reject{|q| q[13].include?('Offensive')}.length<=0
            p1[i][0]='<:Special_Offensive:454460020793278475> Offensive Specials'
          elsif p1[i][1].reject{|q| q[13].include?('Defensive')}.length<=0
            p1[i][0]='<:Special_Defensive:454460020591951884> Defensive Specials'
          elsif p1[i][1].reject{|q| q[13].include?('AoE')}.length<=0
            p1[i][0]='<:Special_AoE:454460021665693696> Area-of-Effect Specials'
          elsif p1[i][1].reject{|q| q[13].include?('Staff')}.length<=0
            p1[i][0]='<:Special_Healer:454451451805040640> Healer Specials'
          elsif p1[i][1].map{|q| q[13]}.uniq.length<=1
            p1[i][0]='<:Special_Unknown:454451451603976192> Misc. Specials'
          end
        elsif k.reject{|q| !['Weapon','Assist','Special'].include?(q[6])}.length<=0 # only passives
          p1[i][0]='<:Passive:544139850677485579> Passives'
          if k.reject{|q| q[6].include?('Passive(A)')}.length<=0
            p1[i][0]='<:Passive_A:443677024192823327> A Passives'
          elsif k.reject{|q| q[6].include?('Passive(B)')}.length<=0
            p1[i][0]='<:Passive_B:443677023257493506> B Passives'
          elsif k.reject{|q| q[6].include?('Passive(C)')}.length<=0
            p1[i][0]='<:Passive_C:443677023555026954> C Passives'
          elsif k.reject{|q| has_any?(k[1][6].split(', '),['Passive(S)','Seal'])}.length<=0
            p1[i][0]='<:Passive_S:443677023626330122> Sacred Seals'
            if p1[i][1].reject{|q| q[5].split(' ')[0].downcase=='scarlet'}.length<=0
              p1[i][0]='<:Great_Badge_Scarlet:443704781001850910> Scarlet Seals'
            elsif p1[i][1].reject{|q| q[5].split(' ')[0].downcase=='azure'}.length<=0
              p1[i][0]='<:Great_Badge_Azure:443704780783616016> Azure Seals'
            elsif p1[i][1].reject{|q| q[5].split(' ')[0].downcase=='verdant'}.length<=0
              p1[i][0]='<:Great_Badge_Verdant:443704780943261707> Verdant Seals'
            elsif p1[i][1].reject{|q| q[5].split(' ')[0].downcase=='transparent'}.length<=0
              p1[i][0]='<:Great_Badge_Transparent:443704781597573120> Transparent Seals'
            elsif p1[i][1].reject{|q| q[5].split(' ')[0].downcase=='gold'}.length<=0
              p1[i][0]='<:Great_Badge_Golden:443704781068959744> Golden Seals'
            elsif p1[i][1].reject{|q| q[5].split(' ')[0].downcase=='-'}.length<=0
              p1[i][0]='<:Great_Badge_Unknown:443704780754255874> Seals of unknown color'
            end
          elsif k.reject{|q| q[6].include?('Passive(W)')}.length<=0
            p1[i][0]='<:Passive_W:443677023706152960> Weapon Effects'
          elsif p1[i][1].reject{|q| q[6].include?('Passive(A)')}.length<=0
            p1[i][0]='<:Passive_A:443677024192823327> A Passives'
          elsif p1[i][1].reject{|q| q[6].include?('Passive(B)')}.length<=0
            p1[i][0]='<:Passive_B:443677023257493506> B Passives'
          elsif p1[i][1].reject{|q| q[6].include?('Passive(C)')}.length<=0
            p1[i][0]='<:Passive_C:443677023555026954> C Passives'
          elsif p1[i][1].reject{|q| has_any?(k[1][6].split(', '),['Passive(S)','Seal'])}.length<=0
            p1[i][0]='<:Passive_S:443677023626330122> Sacred Seals'
          elsif p1[i][1].reject{|q| q[6].include?('Passive(W)')}.length<=0
            p1[i][0]='<:Passive_W:443677023706152960> Weapon Effects'
          end
        elsif p1[i][1].reject{|q| q[6]=='Weapon'}.length<=0 # only weapons
          p1[i][0]='<:Skill_Weapon:444078171114045450> Weapons'
          p1[i][0]="#{emotes[0]} Damaging Staves" if k.reject{|q| q[7].include?('Staff Users Only')}.length<=0
        elsif p1[i][1].reject{|q| q[6]=='Assist'}.length<=0 # only assists
          p1[i][0]='<:Skill_Assist:444078171025965066> Assists'
          p1[i][0]='<:Assist_Staff:454451496831025162> Healing Staves' if k.reject{|q| q[7].include?('Staff Users Only')}.length<=0
        elsif p1[i][1].reject{|q| q[6]=='Special'}.length<=0 # only specials
          p1[i][0]='<:Skill_Special:444078170665254929> Specials'
          p1[i][0]='<:Special_Healer:454451451805040640> Healer Specials' if k.reject{|q| q[7].include?('Staff Users Only')}.length<=0
        elsif p1[i][1].reject{|q| !['Weapon','Assist','Special'].include?(q[6])}.length<=0 # only passives
          p1[i][0]='<:Passive:544139850677485579> Passives'
          p1[i][0]='<:Passive_Staff:443677023848890388> Healer Passives' if k.reject{|q| q[7].include?('Staff Users Only')}.length<=0
        end
        p1[i][1]=p1[i][1].map{|q| q[1]}.sort.uniq.join("\n")
      end
      p1=p1.reject{|q| q[1].length<=0}
      if "#{"__**Skill Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__".length+p1.map{|q| "__**#{q[0]}**__\n#{q[1]}"}.join("\n\n").length>=1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        str="#{"__**Skill Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__"
        for i in 0...p1.length
          if "**#{p1[i][0]}:** #{p1[i][1].gsub("\n",', ')}".length>=1900
            str=extend_message(str,"**#{p1[i][0]}:**",event) unless p1[i][0]=='.'
            str="#{str}\n" if p1[i][0]=='.'
            m=p1[i][1].split("\n")
            for i2 in 0...m.length
              str=extend_message(str,m[i2],event,1,sym=', ')
            end
          else
            str=extend_message(str,"**#{p1[i][0]}:** #{p1[i][1].gsub("\n",', ')}",event) unless p1[i][0]=='.'
            str=extend_message(str,"#{p1[i][1].gsub("\n",', ')}",event) if p1[i][0]=='.'
          end
        end
        event.respond str
        event.respond ftr if ftr.length>0
      else
        create_embed(event,"#{"__**Skill Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__",'',0x9400D3,"#{k.reject{|q| q[1]=='- - -'}.length} total.#{"  #{ftr}" if ftr.length>0}",nil,p1)
      end
    elsif "#{"__**Skill Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__".length+k.map{|q| q[1]}.join("\n").length>=1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      m=k.map{|q| q[1]}
      str="#{"__**Skill Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__"
      for i in 0...m.length
        str=extend_message(str,m[i],event)
      end
      event.respond str
    else
      create_embed(event,"#{"__**Skill Search**__\n#{mk.join("\n")}\n\n" if mk.length>0}__**Results**__",'',0x9400D3,"#{k.length} total.",nil,triple_finish(k.map{|q| q[1]}))
    end
  end
end

def display_units_and_skills(event,bot,args)
  args=event.message.text.split(' ') if args.nil?
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
  elsif ['hero','heroes','heros','unit','char','character','person','units','chars','charas','chara','people'].include?(args[0].downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
    display_units(event, mode)
  elsif ['skill','skills'].include?(args[0].downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',(event.message.text.length/30).floor+1)
    display_skills(event, mode)
  else
    event.channel.send_temporary_message('Calculating data, please wait...',(event.message.text.length/30).floor+2)
    p1=find_in_units(event,1,true)
    m=[p1[0]]
    p1=p1[1].map{|q| "#{'~~' if !["- - -"].include?(q) && !find_unit(q,event,false,true)[13][0].nil?}#{q}#{'~~' if !["- - -"].include?(q) && !find_unit(q,event,false,true)[13][0].nil?}"}
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
  k=k.reject {|q| find_unit(q[0],event).length<=0}
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
    m2.push("#{'~~' if !k[i][13][0].nil?}**#{k[i][0]}**#{unit_moji(bot,event,-1,k[i][0])}#{' - ' if ls.length>0}#{ls.join(', ')}#{'~~' if !k[i][13][0].nil?}")
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
    untz=@units.map{|q| q}
    k=k.reject{|q| q[1][0,14]=='Initiate Seal ' || q[1][0,10]=='Squad Ace '}
    for i in 0...k.length
      if k[i][17].nil? || !k[i][17].is_a?(String) || k[i][17].length.zero?
        k[i][17]=0
      elsif k[i][8]=='-' || k[i][8].split(', ').length.zero?
        k[i][17]=350
      else
        k[i][17]=400
      end
      if k[i][1].include?("*(+) Effect*") || k[i][1].include?("*(+) All*")
        k[i][1]=k[i][17]*1
        k[i][17]=0
      end
    end
    k.sort! {|b,a| ((a[3] <=> b[3]) == 0 ? ((a[17] <=> b[17]) == 0 ? (b[1] <=> a[1]) : (a[17] <=> b[17])) : (a[3] <=> b[3]))}
    str="#{"__**Search**__\n#{mk.join("\n")}\n\n__**Additional Notes**__\n" if mk.length>0}All SP costs are without accounting for increased inheritance costs (1.5x the SP costs listed below)"
    for i in 0...k.length
      k[i][1]="**#{k[i][1]}** #{skill_moji(k[i],event,bot)}"
      k[i][1]="#{k[i][1]} - #{k[i][3]} SP"
      if k[i][17]>k[i][3] && k[i][3]>0 && k[i][6]=='Weapon'
        k[i][1]="#{k[i][1]} (#{k[i][17]} SP when refined)"
      elsif k[i][17]==k[i][3] && k[i][3]>0 && k[i][6]=='Weapon'
        k[i][1]="#{k[i][1]} (refinement possible)"
      end
      unless k[i][8]=='-' || k[i][8].split(', ').length.zero?
        k[i][8]=k[i][8].split(', ').reject{|q| untz.find_index{|q2| q2[0]==q}.nil? || untz[untz.find_index{|q2| q2[0]==q}][8]>1000}.join(', ')
        k[i][1]="#{k[i][1]} - Prf to #{k[i][8]}"
      end
      k[i][1]="~~#{k[i][1]}~~" unless k[i][15].nil? || k[i][15].length<=0
    end
    if k.map{|q| q[1]}.join("\n").length+str.length>1950 && !safe_to_spam?(event)
      str="#{str}\n\nThere are too many skills to list.  Please try this command in PM.\nShowing top ten results."
      k=k[0,10]
    end
    for i in 0...k.length
      str=extend_message(str,"#{"\n" if i==0}#{k[i][1]}",event)
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
  return get_bond_name(event) if find_unit(k,event,true).length>0 # filter out actual names of units
  return k
end

def get_games_list(arr,includefeh=true)
  g=[]
  lookout=lookout_load('Games')
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
  event.channel.send_temporary_message('Parsing message, please wait...',3)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  s1=args.join(' ').gsub(',','').gsub('/','').downcase
  s2=args.join(' ').gsub(',','').gsub('/','').downcase
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
          u=find_unit(name,event)
          st=get_stats(event,name,40,r[0],r[1],r[2],r[3])
          m=false
          uemoji=unit_moji(bot,event,-1,name,m,2,f[i])
          b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}",(m && find_in_dev_units(name)>=0),r[0],uemoji])
          c.push(unit_color(event,find_unit(name,event),nil,1,m))
          atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(u[1][1])
          atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
          atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
        end
      elsif find_data_ex(:find_unit,f[i],event).length>0
        name=find_data_ex(:find_unit,f[i],event)
        name=name[0] if name[0].is_a?(Array)
        name=name[0] if name.is_a?(Array)
        r=find_stats_in_string(event,f[i])
        u=find_unit(name,event)
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
        uemoji=unit_moji(bot,event,-1,name,m,2,uid)
        b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}",(m && find_in_dev_units(name)>=0),r[0],uemoji,r[1]])
        c.push(unit_color(event,-1,name,1,m))
        atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(u[1][1])
        atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
        atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
      end
    end
  else
    for i in 0...args.length
      unless s1.split(' ').nil? || s1.gsub(' ','').length<=0
        k=find_data_ex(:find_unit,s1,event,false,1)
        unless k.nil?
          if k[0].is_a?(Array)
            if k[0][0].is_a?(Array)
              k[0]=k[0].map{|q| q[0]}.join(' ')
            else
              k[0]=k[0][0]
            end
          end
          s1=first_sub(s1,k[1],'')
          s2=first_sub(s2,k[1].gsub(' ',''),k[0])
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
          x[0]=x[0].downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','')
          str=str.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','')
          if x[1].is_a?(Array) && x[1].length>1
            for i in 0...x[1].length
              k2.push(str.gsub(x[0],x[1][i]))
            end
          else
            k2.push(str.gsub(x[0],x[1][0]))
          end
        end
      elsif find_data_ex(:find_unit,k[i],event).length>0
        x=find_data_ex(:find_unit,sever(str),event)
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
    event.channel.send_temporary_message('Message parsed, calculating units...',3)
    for i in 0...k.length
      if find_data_ex(:find_unit,sever(k[i]),event).length>0
        r=find_stats_in_string(event,sever(k[i]))
        u=find_data_ex(:find_unit,sever(k[i]),event)
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
        uemoji=unit_moji(bot,event,-1,name,m,2,did)
        rstar=@rarity_stars[r[0]-1]
        rstar=['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>','<:Icon_Rarity_4p10:448272714210476033>','<:Icon_Rarity_5p10:448272715099406336>','<:Icon_Rarity_6p10:491487784822112256>'][r[0]-1] if r[1]>=10
        rstar='<:Icon_Rarity_S:448266418035621888>' unless sup=='-'
        rstar='<:Icon_Rarity_Sp10:448272715653054485>' if sup != '-' && r[1]>=10
        b.push([st,"#{r[0]}#{rstar}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}",(m && find_in_dev_units(name)>=0),r[0],uemoji,r[1]])
        c.push(unit_color(event,find_data_ex(:find_unit,sever(k[i]),event),nil,1,m))
        atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(u[1][1])
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
  if b.length==1 && !['hero','unit','stats'].include?(event.message.text.downcase.split(' ')[0].gsub('feh!','').gsub('feh?','').gsub('f?','').gsub('e?','').gsub('h?',''))
    event.respond "I need at least two units in order to compare anything.\nInstead, I will show you the results of the `study` command, which is similar to `compare` but for one unit."
    unit_study(event,name,bot)
    return 1
  elsif b.length<2
    event.respond 'I need at least two units in order to compare anything.'
    return 0
  elsif b.length>2
    event.channel.send_temporary_message('Units calculated, generating comparison...',3)
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
    bse=b.map{|q| uu[uu.find_index{|q2| q2[0]==q[0][0]}][12].split(', ')[0].gsub('*','')}.uniq
    for iz in 0...b.length
      dzz.push(["**#{b[iz][1]}**",[b[iz][4]],0])
      czz.push(c[iz])
      for jz in 1...6
        stz=b[iz][0][jz]
        dzz[iz][2]+=stz
        s=''
        s=' (+)' if [-3,1,5,10,14].include?(b[iz][0][jz+5]) && b[iz][3]==5
        s=' (-)' if [-2,2,6,11,15].include?(b[iz][0][jz+5]) && b[iz][3]==5
        s=' (+)' if [-2,10].include?(b[iz][0][jz+5]) && b[iz][3]==4
        s=' (-)' if [-1,11].include?(b[iz][0][jz+5]) && b[iz][3]==4
        s='' if s==' (-)' && b[iz][5]>0
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
  d1=[b[0][1],[b[0][4]],0]
  d2=[b[1][1],[b[1][4]],0]
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
    s='' if s==' (-)' && b[0][5]>0
    s='' unless b[0][1][b[0][1].length-10,10]==' (neutral)' && b[1][1][b[1][1].length-10,10]==' (neutral)' && !names[0].include?("Mathoo's ")
    d1[1].push("#{stzzz[i]}: #{b[0][0][i]}#{s}")
    s=''
    s=' (+)' if [-3,1,5,10,14].include?(b[1][0][i+5]) && b[1][3]==5
    s=' (-)' if [-2,2,6,11,15].include?(b[1][0][i+5]) && b[1][3]==5
    s=' (+)' if [-2,10].include?(b[1][0][i+5]) && b[1][3]==4
    s=' (-)' if [-1,11].include?(b[1][0][i+5]) && b[1][3]==4
    s='' if s==' (-)' && b[1][5]>0
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
  bse.push(@units[@units.find_index{|q| q[0]==b[0][0][0]}][12].split(', ')[0].gsub('*',''))
  bse.push(@units[@units.find_index{|q| q[0]==b[1][0][0]}][12].split(', ')[0].gsub('*',''))
  if bse.include?('Elise') && bse.include?('Nino')
    metadata_load()
    ftr="Heyday Coefficient: #{(@server_data[0].inject(0){|sum,x| sum + x }/701.0).round(4)}"
  end
  create_embed(event,"**Comparing #{names[0]} and #{names[1]}**",'',avg_color([c[0],c[1]]),ftr,xpic,[d1,d2,d3],-2)
  return 2
end

def detect_multi_unit_alias(event,str1,str2,robinmode=0)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
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
  k=find_data_ex(:find_unit,event.message.text,event,false,1)
  w=nil
  if k.length<=0
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.length<=0
      disp_stats(bot,x[1],w,event,'smol',true,true)
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.length<=0
  data_load()
  if str.is_a?(Array)
    disp_stats(bot,str.map{|q| q[0]},w,event,'smol',false,true) if str[0].is_a?(Array)
    disp_stats(bot,str[0],w,event,'smol',false,true) unless str[0].is_a?(Array)
  elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,'smol',true,true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,'smol',true,true)
  elsif find_unit(str,event).length>0
    disp_stats(bot,str,w,event,'smol',false,true)
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
          u=find_unit(name,event)
          st=unit_skills(name,event,false,r[0])
          m=false
          uemoji=unit_moji(bot,event,-1,name,m,2,f[i])
          b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}",(m && find_in_dev_units(name)>=0),r[0],uemoji])
          c.push(unit_color(event,find_unit(name,event),nil,1,m))
          atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(u[1][1])
          atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
          atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
        end
      elsif find_data_ex(:find_unit,f[i],event).length>0
        name=find_data_ex(:find_unit,f[i],event)
        name=name[0] if name[0].is_a?(Array)
        name=name[0] if name.is_a?(Array)
        r=find_stats_in_string(event,f[i])
        u=find_unit(name,event)
        st=unit_skills(name,event,false,r[0])
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
          st=[dv[7],dv[8],dv[9],dv[10],dv[11],dr[12]]
        elsif donate_trigger_word(event,f[i])>0
          uid=donate_trigger_word(event,f[i])
          x=donor_unit_list(uid)
          x2=x.find_index{|q| q[0]==name}
          unless x2.nil?
            st=[x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],x[x2][12]]
          end
        end
        uemoji=unit_moji(bot,event,-1,name,m,2,uid)
        b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0}",name,r[0],uemoji,r[1]])
        c.push(unit_color(event,-1,name,1,m))
        atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(u[1][1])
        atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
        atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
      end
    end
  else
    for i in 0...args.length
      unless s1.split(' ').nil? || s1.gsub(' ','').length<=0
        k=find_data_ex(:find_unit,s1,event,false,1)
        unless k.nil?
          if k[0].is_a?(Array)
            if k[0][0].is_a?(Array)
              k[0]=k[0].map{|q| q[0]}.join(' ')
            else
              k[0]=k[0][0]
            end
          end
          s1=first_sub(s1,k[1],'')
          s2=first_sub(s2,k[1].gsub(' ',''),k[0])
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
          x[0]=x[0].downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','')
          str=str.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','')
          if x[1].is_a?(Array) && x[1].length>1
            for i in 0...x[1].length
              k2.push(str.gsub(x[0],x[1][i]))
            end
          else
            k2.push(str.gsub(x[0],x[1][0]))
          end
        end
      elsif find_data_ex(:find_unit,k[i],event).length>0
        x=find_data_ex(:find_unit,sever(str),event)
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
    event.channel.send_temporary_message('Message parsed, calculating units...',3)
    for i in 0...k.length
      if find_data_ex(:find_unit,sever(k[i]),event).length>0
        r=find_stats_in_string(event,sever(k[i]))
        u=find_data_ex(:find_unit,sever(k[i]),event)
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
            st=[x[x2][7],x[x2][8],x[x2][9],x[x2][10],x[x2][11],x[x2][12]]
          end
        end
        st=unit_skills(name,event,false,r[0])
        uemoji=unit_moji(bot,event,-1,name,m,2,did)
        rstar=@rarity_stars[r[0]-1]
        rstar=['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>','<:Icon_Rarity_4p10:448272714210476033>','<:Icon_Rarity_5p10:448272715099406336>','<:Icon_Rarity_6p10:491487784822112256>'][r[0]-1] if r[1]>=10
        rstar='<:Icon_Rarity_S:448266418035621888>' unless sup=='-'
        rstar='<:Icon_Rarity_Sp10:448272715653054485>' if sup != '-' && r[1]>=10
        b.push([st,"#{r[0]}#{rstar}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{uemoji if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0}",name,r[0],uemoji,r[1]])
        c.push(unit_color(event,find_data_ex(:find_unit,sever(k[i]),event),nil,1,m))
        atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(u[1][1])
        atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
        atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
      elsif k[i].downcase=="mathoo's"
        m=true
      elsif donate_trigger_word(event,k[i])>0
        did=donate_trigger_word(event,k[i])
      end
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
  create_embed(event,"**Skills #{b[0][1]} and #{b[1][1]} have in common**",'',avg_color([c[0],c[1]]),nil,"https://cdn.discordapp.com/emojis/448304646814171136.png",[["<:Skill_Weapon:444078171114045450> **Weapons**",b2[0].join("\n")],["<:Skill_Assist:444078171025965066> **Assists**",b2[1].join("\n")],["<:Skill_Special:444078170665254929> **Specials**",b2[2].join("\n")],["<:Passive_A:443677024192823327> **A Passives**",b2[3].join("\n")],["<:Passive_B:443677023257493506> **B Passives**",b2[4].join("\n")],["<:Passive_C:443677023555026954> **C Passives**",b2[5].join("\n")]],-1)
  return 2
end

def weapon_legality(event,name,weapon,refinement='-',recursion=false)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return legal_weapon(event,name,weapon,refinement,recursion)
end

def skill_legality(event,unit,skill)
  u=@units[@units.find_index{|q| q[0]==unit}]
  s=@skills[@skills.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==skill}]
  k3=true
  k22=s[7].split(', ')
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
            b.push(u[j2]) unless b.include?(u[j2]) || u[j2].include?('-')
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
            b.push(u[j2]) unless b.include?(u[j2]) || u[j2].include?('-')
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

def create_summon_list(clr,mainpool=nil)
  p=[['1<:Icon_Rarity_1:448266417481973781> exclusive',[]],['1<:Icon_Rarity_1:448266417481973781>-2<:Icon_Rarity_2:448266417872044032>',[]],['2<:Icon_Rarity_2:448266417872044032> exclusive',[]],['2<:Icon_Rarity_2:448266417872044032>-3<:Icon_Rarity_3:448266417934958592>',[]],['3<:Icon_Rarity_3:448266417934958592> exclusive',[]],['3<:Icon_Rarity_3:448266417934958592>-4<:Icon_Rarity_4:448266418459377684>',[]],['4<:Icon_Rarity_4:448266418459377684> exclusive',[]],['4<:Icon_Rarity_4:448266418459377684>-5<:Icon_Rarity_5:448266417553539104>',[]],['5<:Icon_Rarity_5:448266417553539104> exclusive',[]],['5<:Icon_Rarity_5:448266417553539104>-6<:Icon_Rarity_6:491487784650145812>',[]],['6<:Icon_Rarity_6:491487784650145812> exclusive',[]],['Other',[]]]
  for i in 0...clr.length
    clr[i][0]="~~#{clr[i][0]}~~" if clr[i][9][0].include?('TD')
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
      p[11][0][1].push("#{clr[i][0]} - weird")
    end
  end
  p2=[]
  for i in 0...p.length
    if p[i][1].length<=0
    elsif p[i][1].reject{|q| !q.include?('~~')}.length>0 && mainpool.nil?
      p2.push([p[i][0],"__**Main Pool**__\n#{p[i][1].reject{|q| q.include?('~~')}.sort.uniq.join("\n")}\n\n__**Partial Pool**__\n#{p[i][1].reject{|q| !q.include?('~~')}.map{|q| q.gsub('~~','')}.sort.uniq.join("\n")}"])
    elsif p[i][1].reject{|q| !q.include?('~~')}.length>0 && mainpool==true
      p[i][1]=p[i][1].reject{|q| q.include?('~~')}.sort.uniq.join("\n")
      p2.push(p[i])
    else
      p[i][1]=p[i][1].map{|q| q.gsub('~~','')}.sort.uniq.join("\n")
      p2.push(p[i])
    end
  end
  p2.compact!
  return p2
end

def disp_summon_pool(event,args)
  data_load()
  k=@units.reject{|q| !q[9][0].include?('p') || !q[13][0].nil?}
  k=k.reject{|q| !q[9][0].include?('LU')} if event.message.text.downcase.split(' ').include?('launch')
  colors=[]
  pooltype=nil
  for i in 0...args.length
    args[i]=args[i].downcase.gsub('user','') if args[i].length>4 && args[i][args[i].length-4,4].downcase=='user'
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','clear','clears'].include?(args[i].downcase)
    pooltype=true if ['new','special','seasonal','main'].include?(args[i].downcase)
    pooltype=false if ['old','part','partial'].include?(args[i].downcase)
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
    r=create_summon_list(r,pooltype)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0xE22141,nil,nil,r,4)
    end
  end
  if colors.include?('Blue')
    r=k.reject{|q| q[1][0]!='Blue'}
    r=create_summon_list(r,pooltype)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x2764DE,nil,nil,r,4)
    end
  end
  if colors.include?('Green')
    r=k.reject{|q| q[1][0]!='Green'}
    r=create_summon_list(r,pooltype)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x09AA24,nil,nil,r,4)
    end
  end
  if colors.include?('Colorless')
    r=k.reject{|q| q[1][0]!='Colorless'}
    r=create_summon_list(r,pooltype)
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

def get_match_in_list(list, str, m=0)
  return list[list.find_index{|q| q[m].downcase==str.downcase}] unless list.find_index{|q| q[m].downcase==str.downcase}.nil?
  return nil
end

def generate_random_unit(event,args,bot)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return make_random_unit(event,args,bot)
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
  staticons=['<:HP_S:514712247503945739>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
  if unt[11][0]=='DL'
    atk='<:Strength:573344931205349376> Attack'
    atk='<:Strength:573344931205349376> Magic' if ['Tome','Dragon','Healer'].include?(unt[1][1])
    atk='<:Strength:573344931205349376> Strength' if ['Blade','Bow','Dagger','Beast'].include?(unt[1][1])
    staticons=['<:HP:573344832307593216>','<:Speed:573366907357495296>','<:FEHDefense:574702109325262878>','<:Defense:573344832282689567>']
  end
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
  create_embed(event,"__**#{u40[0]}#{unit_moji(bot,event,j,u40[0],false,2)}**__","#{display_stars(bot,event,5,0,'-',['Infantry',0],false,j[11][0])}\n\n#{staticons[0]}\u00A0\u200B\u00A0\u200B\u00A0#{atk}\u00A0\u200B\u00A0\u200B\u00A0#{staticons[1]}\u00A0\u200B\u00A0\u200B\u00A0#{staticons[2]}\u00A0\u200B\u00A0\u200B\u00A0#{staticons[3]}\u00A0\u200B\u00A0\u200B\u00A0#{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]}\u00A0BST\u2084\u2080```#{flds[0][1].join("\u00A0|")}\n#{flds[1][1].join('|')}```",xcolor,nil,img,[['Skills',"<:Skill_Weapon:444078171114045450> #{uskl[0]}\n<:Skill_Assist:444078171025965066> #{uskl[1]}\n<:Skill_Special:444078170665254929> #{uskl[2]}\n<:Passive_A:443677024192823327> #{uskl[3]}\n<:Passive_B:443677023257493506> #{uskl[4]}\n<:Passive_C:443677023555026954> #{uskl[5]}"]])
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
  k=find_data_ex(:find_unit,event.message.text,event,false,1)
  if k.length<=0
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.length<=0
      xx=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        xx.push(j2[12].gsub('*','').split(', ')[0])
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
    weapon=k2[0] unless k2.length<=0
    name=find_data_ex(:find_unit,event.message.text,event,false,1)
    if name.is_a?(Array)
      xx=[]
      if name[0].is_a?(Array)
        for i in 0...name[0].length
          xx.push(name[0][i][12].gsub('*','').split(', ')[0])
        end
      else
        for i in 0...name[0].length
          j2=find_unit(name[0][i],event)
          xx.push(j[12].gsub('*','').split(', ')[0])
        end
      end
      method(callback).call(event,xx.uniq,bot) if xx.length>0
    elsif !detect_multi_unit_alias(event,name.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,name.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.nil?
      xx=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        xx.push(j2[12].gsub('*','').split(', ')[0])
      end
      method(callback).call(event,xx.uniq,bot) if xx.length>0
    elsif !detect_multi_unit_alias(event,name.downcase,name.downcase).nil?
      x=detect_multi_unit_alias(event,name.downcase,name.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.length<=0
      xx=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        xx.push(j2[12].gsub('*','').split(', ')[0])
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
  k=find_data_ex(:find_unit,event.message.text,event,false,1)
  if k.length<=0
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.length<=0
      xx=[]
      xn=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        if j2[1][1]!='Healer' && healers==true
          xn.push(x[1][i])
        elsif j2[1][1]=='Healer' && healers==false
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
      if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
      t=Time.now
      if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
        puts 'reloading EliseText'
        load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
        @last_multi_reload[1]=t
      end
      disp_generic_art(event,'',bot)
    else
      event.respond 'No unit was included'
      return -1
    end
  elsif ['red','reds','blue','blues','green','greens','grean','greans','colorless','colourless','colorlesses','colourlesses','clear','clears','physical','blade','blades','tome','mage','spell','tomes','mages','spells','dragon','dragons','breath','manakete','manaketes','beast','beasts','laguz','bow','arrow','bows','arrows','archer','archers','dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thiefs','thieves','healer','staff','cleric','healers','clerics','staves','sword','swords','katana','lance','lances','spear','spears','naginata','axe','axes','ax','club','clubs','redtome','redtomes','redmage','redmages','bluetome','bluetomes','bluemage','bluemages','greentome','greentomes','greenmage','greenmages','flier','flying','flyer','fly','pegasus','fliers','flyers','pegasi','wyvern','wyverns','cavalry','horse','pony','horsie','horses','horsies','ponies','cavalier','cavaliers','cav','cavs','infantry','foot','feet','armor','armour','armors','armours','armored','armoured'].include?(k[1]) && callback==:disp_art
    t=Time.now
    if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
      puts 'reloading EliseText'
      load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
      @last_multi_reload[1]=t
    end
    disp_generic_art(event,'',bot)
  else
    str=k[0]
    k2=get_weapon(first_sub(event.message.text,k[1],''),event)
    weapon='-'
    weapon=k2[0] unless k2.length<=0
    name=find_data_ex(:find_unit,event.message.text,event)
    if name.is_a?(Array)
      xx=[]
      xn=[]
      if name[0].is_a?(Array)
        for i in 0...name.length
          if name[i][1][1]!='Healer' && healers==true
            xn.push(name[i][0])
          elsif name[i][1][1]=='Healer' && healers==false
            xn.push(name[i][0])
          else
            xx.push(name[i][0])
          end
        end
      else
        if name[1][1]!='Healer' && healers==true
          xn.push(name[0])
        elsif name[1][1]=='Healer' && healers==false
          xn.push(name[0])
        else
          xx.push(name[0])
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
    elsif !detect_multi_unit_alias(event,name.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,name.downcase,event.message.text.downcase)
      x[1]=[x[1]] unless x[1].is_a?(Array)
      xx=[]
      xn=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        if j2[1][1]!='Healer' && healers==true
          xn.push(x[1][i])
        elsif j2[1][1]=='Healer' && healers==false
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
        if j2[1][1]!='Healer' && healers==true
          xn.push(x[1][i])
        elsif j2[1][1]=='Healer' && healers==false
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
    elsif find_unit(name,event)[1][1]!='Healer' && healers==true
      event.respond "#{name} is not a healer so cannot equip staves."
    elsif find_unit(name,event)[1][1]=='Healer' && healers==false
      event.respond "#{name} is a healer so cannot equip these skills."
    else
      method(callback).call(event,name,bot,weapon)
    end
  end
  return 0
end

def calculate_effective_HP(event,name,bot,weapon=nil)
  name='Robin' if name==['Robin(M)', 'Robin(F)'] || name==['Robin(F)', 'Robin(M)']
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      calculate_effective_HP(event,name[i],bot,weapon)
    end
    return nil
  end
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return get_effHP(event,name,bot,weapon)
end

def pair_up(event,name,bot,weapon=nil)
  name='Robin' if name==['Robin(M)', 'Robin(F)'] || name==['Robin(F)', 'Robin(M)']
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      pair_up(event,name[i],bot,weapon)
    end
    return nil
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  flurp[5]='' if flurp[5].nil?
  u40x=find_unit(name,event)
  if name=='Robin' && u40x[0].is_a?(Array)
    u40x=u40x[0]
    u40x[0]='Robin (Shared stats)'
    u40x[1][0]='Cyan'
  end
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  flowers=flurp[8]
  untz=@units.map{|q| q}
  blessing=[]
  unless name=='Robin'
    flowers=[@max_rarity_merge[2],flowers].min unless untz[untz.find_index{|q| q[0]==name}][9][0].include?('PF') && untz[untz.find_index{|q| q[0]==name}][3]=='Infantry'
  end
  args.compact!
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study #{'his' if u40x[10]=='M'}#{'her' if u40x[10]=='F'}#{'their' unless ['M','F'].include?(u40x[10])} pair-up stats."
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
      flowers=@dev_units[dv][6]
      weaponz=@dev_units[dv][7].reject{|q| q.include?('~~')}
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
      flowers=x[x2][6]
      weaponz=x[x2][7].reject{|q| q.include?('~~')}
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
        w2=['-',0,0,0,0]
      else
        w2=find_skill(weapon,event)
      end
      if weapon2=='-'
        w22=['-',0,0,0,0]
      else
        w22=find_skill(weapon2,event)
      end
      diff_num=[w2[4]-w22[4],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=''
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[1]==weapon}
  ww2=-1 if ww2.nil?
  w2=sklz[ww2]
  if w2[17].nil?
    refinement=nil
  elsif w2[17].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[17][0,1].to_i.to_s==w2[17][0,1] && refinement=='Effect'
    refinement=nil if w2[17][1,1]=='*'
  elsif w2[17][0,1]=='-' && w2[17][1,1].to_i.to_s==w2[17][1,1] && refinement=='Effect'
    refinement=nil if w2[17][2,1]=='*'
  end
  refinement=nil if w2[7]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[7]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  atk='Attack'
  atk='Magic' if ['Tome','Dragon','Healer'].include?(u40x[1][1])
  atk='Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  atk='Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='Strength'
    n=n[n.length-1] if atk=='Magic'
    n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
  end
  atk='Attack'
  u40=get_stats(event,name,40,rarity,merges,boon,bane,flowers)
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,u40x,u40[0],0,mu)
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
  u40[2]=[(u40[2]-25)/10,4].min
  u40[3]=[(u40[3]-10)/10,4].min
  u40[4]=[(u40[4]-10)/10,4].min
  u40[5]=[(u40[5]-10)/10,4].min
  cru40[2]=[(cru40[2]-25)/10,4].min
  cru40[3]=[(cru40[3]-10)/10,4].min
  cru40[4]=[(cru40[4]-10)/10,4].min
  cru40[5]=[(cru40[5]-10)/10,4].min
  for i in 2...6
    u40[i]="#{"~~#{cru40[i]}~~ " unless cru40[i]==u40[i] || !wl.include?('~~')}#{u40[i]}"
  end
  pic=pick_thumbnail(event,u40x,bot)
  staticons=['<:StrengthS:514712248372166666>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
  staticons=['<:Strength:573344931205349376>','<:Speed:573366907357495296>','<:FEHDefense:574702109325262878>','<:Defense:573344832282689567>'] if u40x[11][0]=='DL'
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0]}#{unit_moji(bot,event,-1,u40[0],mu,6)}** as cohort unit__","#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(u40x,stat_skills,[],nil,'',blessing,transformed,wl)}\n#{staticons[0]}Attack: #{u40[2]}\n#{staticons[1]}Speed: #{u40[3]}\n#{staticons[2]}Defense: #{u40[4]}\n#{staticons[3]}Resistance: #{u40[5]}",xcolor,nil,pic,nil,5)
end

def unit_study(event,name,bot,weapon=nil)
  name='Robin' if name==['Robin(M)', 'Robin(F)'] || name==['Robin(F)', 'Robin(M)']
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      unit_study(event,name[i],bot)
    end
    return nil
  end
  u40x=find_unit(name,event)
  if name=='Robin' && u40x[0].is_a?(Array)
    u40x=u40x[1]
    u40x[0]='Robin (Shared stats)'
    u40x[1][0]='Cyan'
  end
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
  rardata=u40x[9][0].gsub('0s','').gsub('PF','')
  highest_merge=0
  if rardata.include?('p') || rardata.include?('s') || rardata.include?('r')
    highest_merge=@max_rarity_merge[1]
  elsif rardata.include?('-')
    highest_merge=0
  else
    highest_merge=[@max_rarity_merge[1],rardata.gsub('2y','').length/2-1].min
  end
  rardata=rardata.downcase
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
  summon_type[6].push("~~Unavailable on New/Special Heroes banners~~") if rardata.include?('td')
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
  if u40x.length<=0
    event.respond 'No unit was included'
    return nil
  end
  atk='Attack'
  atk='Magic' if ['Tome','Dragon','Healer'].include?(u40x[1][1])
  atk='Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
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
  xcolor=unit_color(event,u40x,u40[0],0,mu)
  xcolor=0x9400D3 if u40[0]=='Kiran'
  rar=[]
  for i in 0...@max_rarity_merge[0]
    rx=@rarity_stars[i]*(i+1)
    rx="#{i+1}-star" if i>@rarity_stars.length-1
    rar.push([rx,r[i]]) if (lowest_rarity<=i+1 && ((boon=="" && bane=="") || i>=3)) || args.include?('full') || args.include?('rarities') || i==@max_rarity_merge[0]-1
  end
  pic=pick_thumbnail(event,u40,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  create_embed(event,["__#{"Mathoo's " if mu}**#{u40[0]}**__",unit_clss(bot,event,u40x,u40[0])],"**Available rarities:** #{summon_type}#{"\n**Highest available merge:** #{highest_merge}" unless highest_merge==@max_rarity_merge[1]}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n",xcolor,nil,pic,rar,2)
end

def heal_study(event,name,bot,weapon=nil)
  if name.nil?
    name=find_data_ex(:find_unit,event.message.text,event)
    name=name[0]
  end
  name='Robin' if name==['Robin(M)', 'Robin(F)'] || name==['Robin(F)', 'Robin(M)']
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      heal_study(event,name[i],bot,weapon)
    end
    return nil
  end
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return study_of_healing(event,name,bot,weapon)
end

def proc_study(event,name,bot,weapon=nil)
  if name.nil?
    name=find_data_ex(:find_unit,event.message.text,event)
    name=name[0]
  end
  name='Robin' if name==['Robin(M)', 'Robin(F)'] || name==['Robin(F)', 'Robin(M)']
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      proc_study(event,name[i],bot,weapon)
    end
    return nil
  end
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return study_of_procs(event,name,bot,weapon)
end

def phase_study(event,name,bot,weapon=nil)
  if name.nil?
    name=find_data_ex(:find_unit,event.message.text,event)
    name=name[0]
  end
  name='Robin' if name==['Robin(M)', 'Robin(F)'] || name==['Robin(F)', 'Robin(M)']
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      phase_study(event,name[i],bot,weapon)
    end
    return nil
  end
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return study_of_phases(event,name,bot,weapon)
end

def disp_art(event,name,bot,weapon=nil)
  if name.nil?
    name=find_data_ex(:find_unit,event.message.text,event)
    name=name[0]
  end
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
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  return disp_unit_art(event,name,bot)
end

def learnable_skills(event,name,bot,weapon=nil)
  if name.nil?
    name=find_data_ex(:find_unit,event.message.text,event)
    name=name[0]
  end
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
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  return disp_learnable_skills(event,name,bot)
end

def banner_list(event,name,bot,weapon=nil)
  name=['Robin(M)','Robin(F)'] if name=='Robin'
  if name.nil?
    name=find_data_ex(:find_unit,event.message.text,event)
    name=name[0]
  end
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      banner_list(event,name[i],bot)
    end
    return nil
  end
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  return study_of_banners(event,name,bot)
end

def games_list(event,name,bot,weapon=nil)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
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
  name=find_data_ex(:find_unit,event.message.text,event)[0]
  name=name[0] if name.is_a?(Array)
  name='grima' if name.nil? && event.message.text.downcase.gsub(' ','').include?('grima')
  name='tiki' if name.nil? && event.message.text.downcase.gsub(' ','').include?('tiki')
  j=find_unit(name,event)
  name='Robin(M)(Fallen)' if name.downcase.include?('grima') && j.length<=0
  j=find_unit(name,event)
  if j.length<=0
    event.respond 'No unit was included'
    return nil
  end
  untz=@units.map{|q| q}
  rg=j[11].reject{|q| ['(a)','(m)','(t)','(t)'].include?(q[0,3]) || ['(at)','(st)'].include?(q[0,4])}
  ag=j[11].reject{|q| q[0,3]!='(a)'}.map{|q| q[3,q.length-3]}
  mg=j[11].reject{|q| q[0,3]!='(m)'}.map{|q| q[3,q.length-3]}
  sg=j[11].reject{|q| q[0,3]!='(s)'}.map{|q| q[3,q.length-3]}
  tg=j[11].reject{|q| q[0,3]!='(t)'}.map{|q| q[3,q.length-3]}
  atg=j[11].reject{|q| q[0,4]!='(at)'}.map{|q| q[4,q.length-4]}
  stg=j[11].reject{|q| q[0,4]!='(st)'}.map{|q| q[4,q.length-4]}
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
  name="#{j[0]}"
  if game_hybrid(j[0],event,bot).length>0
    mmm=game_hybrid(j[0],event,bot)
    pic=mmm[0]
    name=mmm[1]
    xcolor=mmm[2] if mmm.length>2
  elsif 'Tiki(Adult)'==j[0] && !args.join('').downcase.gsub('games','gmes').include?('a')
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
  elsif [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388].include?(event.server.id)
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
    if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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

bot.command([:mythic,:mythical,:mythics,:mythicals,:mystic,:mystical,:mystics,:mysticals]) do |event, *args|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  disp_legendary_mythical(event,bot,args,'Mythic')
  return nil
end

bot.command([:legendary,:legendaries,:legendarys,:legend,:legends]) do |event, *args|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  disp_legendary_mythical(event,bot,args,'Legendary')
  return nil
end

bot.command([:refinery,:refine,:effect]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  disp_all_refines(event,bot)
end

bot.command([:prf,:prfs,:PRF]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  disp_all_prfs(event,bot)
end

bot.command([:attackicon, :attackcolor, :attackcolors, :attackcolour, :attackcolours, :atkicon, :atkcolor, :atkcolors, :atkcolour, :atkcolours, :atticon, :attcolor, :attcolors, :attcolour, :attcolours, :staticon, :statcolor, :statcolors, :statcolour, :statcolours, :iconcolor, :iconcolors, :iconcolour, :iconcolours]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  attack_icon(event)
  return nil
end

bot.command([:random,:rand]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length.zero?
  elsif ['hero','unit','real'].include?(args[0].downcase)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  summon_sim(bot,event,colors)
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

bot.command([:pairup,:pair_up,:pair]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:pair_up,event,args,bot)
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
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  combined_BST(event,args,bot)
  return nil
end

bot.command(:bonus) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
    if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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

bot.command(:skilload) do |event, *args|
  return nil if overlap_prevent(event)
  return nil unless [167657750971547648].include?(event.user.id)
  return nil unless @shardizard==4
  x=disp_skill(bot,args.join(' '),event)
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
  s=remove_prefix(s,event)
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
  k=find_data_ex(:find_unit,event.message.text,event,false,1)
  if k.length<=0
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
  elsif str.is_a?(Array)
    disp_unit_skills(bot,str.map{|q| q[0]},event) if str[0].is_a?(Array)
    disp_unit_skills(bot,str[0],event) unless str[0].is_a?(Array)
  elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_unit_skills(bot,x[1],event)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_unit_skills(bot,x[1],event)
  elsif find_unit(str,event).length>0
    disp_unit_skills(bot,str,event)
  else
    event.respond "No matches found.  #{"If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s." if s[0,6]=='skills'}"
  end
  return nil
end

bot.command([:stats,:stat]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<=0
  elsif ['compare','comparison'].include?(args[0].downcase)
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
    k=find_data_ex(:find_unit,event.message.text,event,false,1)
    if k.length<=0
      w=nil
      if !detect_multi_unit_alias(event,event.message.text.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,'')).nil?
        x=detect_multi_unit_alias(event,event.message.text.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,''))
        k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
        w=k2[0] unless k2.length<=0
        disp_stats(bot,x[1],w,event,'xsmol',true)
      else
        event.respond 'No matches found.'
      end
      return nil
    end
    str=k[0]
    k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
    w=nil
    w=k2[0] unless k2.length<=0
    data_load()
    if !detect_multi_unit_alias(event,str.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,'')).nil?
      x=detect_multi_unit_alias(event,str.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,''))
      disp_stats(bot,x[1],w,event,'xsmol',true)
    elsif !detect_multi_unit_alias(event,str.downcase.gsub(sze.downcase,''),str.downcase.gsub(sze.downcase,'')).nil?
      x=detect_multi_unit_alias(event,str.downcase.gsub(sze.downcase,''),str.downcase.gsub(sze.downcase,''))
      disp_stats(bot,x[1],w,event,'xsmol',true)
    elsif find_unit(str,event)>=0
      disp_stats(bot,str,w,event,'xsmol')
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
  k=find_data_ex(:find_unit,event.message.text,event,false,1)
  if k.length<=0
    w=nil
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.length<=0
      disp_stats(bot,x[1],w,event,'smol',true)
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.length<=0
  data_load()
  if str.is_a?(Array)
    disp_stats(bot,str.map{|q| q[0]},w,event,'smol') if str[0].is_a?(Array)
    disp_stats(bot,str[0],w,event,'smol') unless str[0].is_a?(Array)
  elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,'smol',true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,'smol',true)
  elsif find_unit(str,event).length>0
    disp_stats(bot,str,w,event,'smol')
  else
    event.respond 'No matches found'
  end
  return nil
end

bot.command([:tinystats,:smallstats,:smolstats,:microstats,:squashedstats,:sstats,:statstiny,:statssmall,:statssmol,:statsmicro,:statssquashed,:statss,:stattiny,:statsmall,:statsmol,:statmicro,:statsquashed,:sstat,:tinystat,:smallstat,:smolstat,:microstat,:squashedstat,:tiny,:small,:micro,:smol,:squashed,:littlestats,:littlestat,:statslittle,:statlittle,:little]) do |event, *args|
  return nil if overlap_prevent(event)
  k=find_data_ex(:find_unit,event.message.text,event,false,1)
  if k.length<=0
    w=nil
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.length<=0
      disp_stats(bot,x[1],w,event,'xsmol',true)
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
  w=k2[0] unless k2.length<=0
  data_load()
  if str.is_a?(Array)
    disp_stats(bot,str.map{|q| q[0]},w,event,'xsmol') if str[0].is_a?(Array)
    disp_stats(bot,str[0],w,event,'xsmol') unless str[0].is_a?(Array)
  elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,'xsmol',true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,'xsmol',true)
  elsif find_unit(str,event).length>0
    disp_stats(bot,str,w,event,'xsmol')
  else
    event.respond 'No matches found'
  end
end

bot.command([:big,:tol,:macro,:large,:bigstats,:tolstats,:macrostats,:largestats,:bigstat,:tolstat,:macrostat,:largestat,:statsbig,:statstol,:statsmacro,:statslarge,:statbig,:stattol,:statmacro,:statlarge,:statol]) do |event, *args|
  return nil if overlap_prevent(event)
  k=find_data_ex(:find_unit,event.message.text,event,false,1)
  if k.length<=0
    w=nil
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.length<=0
      disp_stats(bot,x[1],w,event,'medium',true)
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.length<=0
  data_load()
  if str.is_a?(Array)
    disp_stats(bot,str.map{|q| q[0]},w,event,'medium') if str[0].is_a?(Array)
    disp_stats(bot,str[0],w,event,'medium') unless str[0].is_a?(Array)
  elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,'medium',true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,'medium',true)
  elsif find_unit(str,event).length>0
    disp_stats(bot,str,w,event,'medium',false)
  else
    event.respond 'No matches found'
  end
end

bot.command([:huge,:massive,:giantstats,:hugestats,:massivestats,:giantstat,:hugestat,:massivestat,:statsgiant,:statshuge,:statsmassive,:statgiant,:stathuge,:statmassive]) do |event, *args|
  return nil if overlap_prevent(event)
  k=find_data_ex(:find_unit,event.message.text,event,false,1)
  if k.length<=0
    w=nil
    if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.length<=0
      disp_stats(bot,x[1],w,event,'giant',true)
    else
      event.respond 'No matches found.'
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.length<=0
  data_load()
  if str.is_a?(Array)
    disp_stats(bot,str.map{|q| q[0]},w,event,'giant') if str[0].is_a?(Array)
    disp_stats(bot,str[0],w,event,'giant') unless str[0].is_a?(Array)
  elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,'giant',true)
  elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
    x=detect_multi_unit_alias(event,str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,'giant',true)
  elsif find_unit(str,event).length>0
    disp_stats(bot,str,w,event,'giant')
  else
    event.respond 'No matches found'
  end
end

bot.command([:hero, :unit, :data, :statsskills, :statskills, :stats_skills, :stat_skills, :statsandskills, :statandskills, :stats_and_skills, :stat_and_skills, :statsskill, :statskill, :stats_skill, :stat_skill, :statsandskill, :statandskill, :stats_and_skill, :stat_and_skill, :statsskils, :statskils, :stats_skils, :stat_skils, :statsandskils, :statandskils, :stats_and_skils, :stat_and_skils, :statsskil, :statskil, :stats_skil, :stat_skil, :statsandskil, :statandskil, :stats_and_skil, :stat_and_skil]) do |event, *args|
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
  event << "<:Dragonflower_Infantry:541170819980722176><:Dragonflower_Orange:552648156790390796><:Dragonflower_Cavalry:541170819955556352><:Dragonflower_Armor:541170820001824778><:Dragonflower_Cyan:552648156202926097><:Dragonflower_Flier:541170820089774091><:Dragonflower_Purple:552648232673607701><:Dragonflower_Pink:552648232510160897>"
  event << 'Look at all the pretty flowers!'
  event << "https://www.getrandomthings.com/list-flowers.php"
end

bot.command(:prefix) do |event, prefix|
  return nil if overlap_prevent(event)
  if prefix.nil?
    event.respond 'No prefix was defined.  Try again'
    return nil
  elsif event.server.nil?
    event.respond 'This command is not available in PM.'
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.'
    return nil
  elsif ['feh!','feh?','f?','e?','h?','fgo!','fgo?','fg0!','fg0?','liz!','liz?','iiz!','iiz?','fate!','fate?','dl!','dl?','fe!','fe14!','fef!','fe13!','fea!','fe?','fe14?','fef?','fe13?','fea?'].include?(prefix.downcase)
    event.respond "That is a prefix that would conflict with either myself or another one of my developer's bots."
    return nil
  end
  @prefixes[event.server.id]=prefix
  prefixes_save()
  event.respond "This server's prefix has been saved as **#{prefix}**"
end

bot.command(:addalias) do |event, newname, unit, modifier, modifier2|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
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
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
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
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
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
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
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
  if j.length<=0
    j=find_skill(name,event)
    if j.length<=0
      j=find_structure(name,event)
      if j.length<=0
        j=find_accessory(name,event)
        if j.length<=0
          j=find_item_feh(name,event)
          if j.length<=0
            event.respond "#{name} is not an alias, silly!"
            return nil
          else
            jjj='Item'
          end
        else
          jjj='Accessory'
        end
      else
        j=j[0] if j[0].is_a?(Array)
        jjj='Structure'
      end
    else
      j=j[0] if j[0].is_a?(Array)
      jjj='Skill'
    end
  else
    jjj='Unit'
  end
  k=0
  k=event.server.id unless event.server.nil?
  for izzz in 0...@aliases.length
    if @aliases[izzz][1].downcase==name.downcase
      if @aliases[izzz][3].nil? && event.user.id != 167657750971547648
        event.respond 'You cannot remove a global alias'
        return nil
      elsif @aliases[izzz][0]=='Unit' && @aliases[izzz][2].is_a?(Array)
        event.respond 'That is a multi-unit alias.  Please use the `deletemulti` command to delete it.'
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
  baseunt=j[0]
  baseunt="#{j[1]}#{"#{' ' unless j[1][-1,1]=='+'}#{j[2]}" unless ['-','example'].include?(j[2]) || ['Weapon','Assist','Special'].include?(j[6])}" if jjj=='Skill'
  bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**#{jjj} Alias:** #{name} for #{baseunt}~~ **DELETED**.")
  @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...@aliases.length
      f.puts "#{@aliases[i].to_s}#{"\n" if i<@aliases.length-1}"
    end
  }
  nicknames_load()
  event.respond "#{name} has been removed from #{baseunt}'s aliases."
  unless !@aliases[-1][2].is_a?(String) || @aliases[-1][2]<'Verdant Shard'
    bot.channel(logchn).send_message('Alias list saved.')
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
      for i in 0...@aliases.length
        f.puts "#{@aliases[i].to_s}"
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
  elsif find_skill(groupname,event,false,true).length>0
    event.respond "This is not allowed as a group name as it's a skill name."
    return nil
  elsif find_unit(groupname,event,true).length>0
    event.respond "This is not allowed as a group name as it's a unit name."
    return nil
  end
  data_load()
  groups_load()
  for i in 0...args.length
    if !detect_multi_unit_alias(event,args[i].downcase,args[i].downcase,3).nil?
      args[i]=detect_multi_unit_alias(event,args[i].downcase,args[i].downcase,3)[1].join(' ')
    elsif find_unit(args[i].downcase,event).length<=0
      args[i]=nil
    else
      args[i]=find_unit(args[i].downcase,event)[0]
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
    event.respond "A new #{"global " if event.user.id==167657750971547648 && " #{event.message.text.downcase} ".include?(' global ')}group **#{groupname}** has been created with the members #{args.join(', ')}"
  else
    event.respond "The existing #{"global " if event.user.id==167657750971547648 && " #{event.message.text.downcase} ".include?(' global ')}group **#{groupname}** has been updated to include the members #{args.join(', ')}"
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
      msg=extend_message(msg,"**Dancers/Singers**\n#{get_group('dancers&singers',event)[1].sort.join(', ')}",event,2)
    elsif @groups[i][2].nil?
      display=true
      display=false if @groups[i][0].downcase=="mathoo'swaifus"
      display=true if event.user.id==167657750971547648
      display=true if !event.server.nil? && !bot.user(167657750971547648).on(event.server.id).nil? && rand(100).zero?
      if display
        if get_group(@groups[i][0],event)[1].length>50
          msg=extend_message(msg,"**#{@groups[i][0]}** (#{get_group(@groups[i][0],event)[1].length} members)",event,2) if event.user.id==167657750971547648 || @groups[i][0].downcase != "mathoo'swaifus"
        elsif @groups[i][1].length<=0
          msg=extend_message(msg,"**#{@groups[i][0]}**\n#{get_group(@groups[i][0],event)[1]}.sort.join(', ')}",event,2) if event.user.id==167657750971547648 || @groups[i][0].downcase != "mathoo'swaifus"
        else
          msg=extend_message(msg,"**#{@groups[i][0]}**\n#{@groups[i][1].sort.join(', ')}",event,2)
        end
      end
    elsif @groups[i][2].include?(k)
      msg=extend_message(msg,"**#{@groups[i][0]}**\n#{@groups[i][1].sort.join(', ')}\n~~server exclusive~~",event,2)
    elsif event.server.nil?
      srvs=[]
      for j in 0...@groups[i][2].length
        srvs.push("*#{bot.server(@groups[i][2][j]).name}*") unless event.user.on(@groups[i][2][j]).nil?
      end
      msg=extend_message(msg,"**#{@groups[i][0]}**\n#{@groups[i][1].sort.join(', ')}\n~~In the following servers: #{list_lift(srvs,"and")}~~",event,2) if srvs.length>0
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
  elsif find_group(group.downcase,event)<0 || find_unit(unit.downcase,event).length<=0
    event << "The group #{group} doesn't even exist in the first place, silly!" if find_group(group.downcase)<0
    event << "The unit #{unit} doesn't even exist in the first place, silly!" if find_unit(unit.downcase).length<=0
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
    if @groups[j][1][k].downcase==i[0].downcase
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
    event << "#{i[0]} has been removed from the group #{@groups[j][0]}"
    if @groups[j][1].length<=0
      event << "The group #{@groups[j][0]} now has 0 members, so I'm deleting it."
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**Group:** #{@groups[j][0]}~~\n**DELETED**")
      @groups[j]=nil
      @groups.compact!
    else
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Group:** #{@groups[j][0]}\n**Units removed:** #{i[0]}")
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
    event << "#{i[0]} wasn't even in the group #{@groups[j][0]}, silly!"
  end
  return nil
end

bot.command([:find,:search,:lookup]) do |event, *args|
  return nil if overlap_prevent(event)
  display_units_and_skills(event,bot,args)
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
    @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
      for i in 0...@aliases.length
        f.puts "#{@aliases[i].to_s}#{"\n" if i<@aliases.length-1}"
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
    ccz.push(unit_color(event,u.find_index{|q| q[0]==k222[i2][0]},k222[i2][0],1))
    atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(k222[i2][1][1])
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
    d=u[u.find_index{|q| q[0]==k222[i][0]}]
    ccz.push(unit_color(event,u.find_index{|q| q[0]==k222[i][0]},k222[i][0],1))
    atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(k222[i][1][1])
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
    d=u[u.find_index{|q| q[0]==k222[i][0]}]
    ccz.push(unit_color(event,u.find_index{|q| q[0]==k222[i][0]},k222[i][0],1))
    atkstat.push('Strength') if ['Blade','Bow','Dagger','Beast'].include?(k222[i][1][1])
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

bot.command([:aoe,:AOE,:AoE,:area]) do |event, *args|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  aoe(event,bot,args)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
    w=k2[0] unless k2.length<=0
    disp_stats(bot,'Oregano',w,event,'smol',false,true)
    return nil
  end
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  oregano_explain(event,bot)
end

bot.command([:whoisoregano, :whoIsOregano, :whoisOregano]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseTexts'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  oregano_explain(event,bot)
end

bot.command(:merges) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  merge_explain(event,bot)
end

bot.command(:score) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  bug_report(bot,event,args,@shards,shard_data(0,true),'Shard',['feh!','feh?','f?','e?','h?'])
end

bot.command([:tools,:links,:tool,:link,:resources,:resources]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
    puts 'reloading EliseText'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb'
    @last_multi_reload[1]=t
  end
  show_tools(event,bot)
end

bot.command(:shard) do |event, i, j|
  return nil if overlap_prevent(event)
  if j.to_i.to_s==j
    j=j.to_i
    if j>256*256 && i.to_i.to_s==i && i.to_i<=256*256
      k=j*1
      j=i.to_i
      i=k*1
    end
  else
    j=@shards*1
  end
  if (i.to_i.to_s==i || i.to_i==i) && i.to_i>256*256
    srv=(bot.server(i.to_i) rescue nil)
    if @shardizard ==4 && j != @shards
      event.respond "In a system of #{j} shards, that server would use #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards."
    elsif @shardizard ==4
      event.respond "That server uses/would use #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards."
    elsif srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
      event.respond "I am not in that server, but it would use #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards #{"(in a system of #{j} shards)" if j != @shards}."
    elsif j != @shards
      event.respond "In a system of #{j} shards, *#{srv.name}* would use #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards."
    else
      event.respond "*#{srv.name}* uses #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards."
    end
    return nil
  elsif i.to_i.to_s==i
    j=i.to_i*1
    i=0
  end
  event.respond "This is the debug mode, which uses #{shard_data(0,false,j)[4]} Shards." if @shardizard==4
  event.respond "PMs always use #{shard_data(0,true,j)[0]} Shards." if event.server.nil? && @shardizard != 4
  event.respond "In a system of #{j} shards, this server would use #{shard_data(0,true,j)[(event.server.id >> 22) % j]} Shards." unless event.server.nil? || @shardizard==4 || j == @shards
  event.respond "This server uses #{shard_data(0,true,j)[(event.server.id >> 22) % j]} Shards." unless event.server.nil? || @shardizard==4 || j != @shards
end

bot.command([:today,:todayinfeh,:todayInFEH,:today_in_feh,:today_in_FEH,:daily,:now]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
    str="**Tier 1:** Ability to give server-specific aliases in any server\n\u2713 Given" if g[2].max>=1
    if g[2][0]>=2
      if g[3].nil? || g[3].length.zero? || g[4].nil? || g[4].length.zero?
        str="#{str}\n\n**Tier 2:** Birthday avatar\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      elsif g[4][0]=='-'
        str="#{str}\n\n**Tier 2:** Birthday avatar\n\u2713 May be given via another bot."
      elsif !File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseImages/#{g[4][0]}.png")
        str="#{str}\n\n**Tier 2:** Birthday avatar\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected.\n*Birthday:* #{g[3][1]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][g[3][0]]}\n*Character:* #{g[4][0]}"
      else
        str="#{str}\n\n**Tier 2:** Birthday avatar\n\u2713 Given\n*Birthday:* #{g[3][1]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][g[3][0]]}\n*Character:* #{g[4][0]}"
      end
    end
    if g[2][0]>=3
      if !File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt")
        str="#{str}\n\n**Tier 3:** Unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      else
        str="#{str}\n\n**Tier 3:** Unit tracking\n\u2713 Given\n*Trigger word:* #{donor_unit_list(uid,1)[0].split('\\'[0])[0]}'s"
      end
    end
    if g[2][0]>=4
      if !File.exist?("C:/Users/Mini-Matt/Desktop/devkit/EliseUserSaves/#{uid}.txt")
        str="#{str}\n\n**Tier 4:** __*Colored*__ unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      elsif donor_unit_list(uid,1)[0].split('\\'[0])[1].nil?
        str="#{str}\n\n**Tier 4:** __*Colored*__ unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      else
        str="#{str}\n\n**Tier 4:** __*Colored*__ unit tracking\n\u2713 Given\n*Color of choice:* #{donor_unit_list(uid,1)[0].split('\\'[0])[1]}"
        color=donor_unit_list(uid,1)[0].split('\\'[0])[1].hex
      end
    end
    create_embed(event,"__**#{n} a Tier #{g[2][0]} donor.**__",str,color)
  end
  donor_embed(bot,event)
  return nil
end

bot.command(:edit) do |event, cmd, *args|
  return nil if overlap_prevent(event)
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  donor_edit(bot,event,args,cmd)
end

def backwards_skill_tree(j, sklz=nil, table=nil)
  if sklz.nil?
    data_load()
    sklz=@skills.map{|q| q}
  end
  s=j
  s=sklz[j] unless j.is_a?(Array)
  q2="#{s[1]}#{"#{' ' unless s[1][-1,1]=='+'}#{s[2]}" unless ['Weapon','Assist','Special'].include?(s[6]) || ['-','example'].include?(s[2])}"
  if s[10]=='-'
    return [[q2]]
  elsif s[10].gsub(',','').include?("* or *")
    m=s[10].gsub('*, *','* or *').split('* or *').map{|q| q.gsub('*','')}
    unless table.nil?
      for i in 0...m.length
        if table.include?(m[i])
          j2=sklz.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==m[i]}
          p2=backwards_skill_tree(j2, sklz, table)
          p2[0].push(q2)
          return [p2[0],m[i]]
        end
      end
    end
    return [['~~Unknown base~~',q2],'~~Unknown base~~']
  else
    j2=sklz.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==s[10].gsub('*','')}
    p2=backwards_skill_tree(j2, sklz)
    p2[0].push(q2)
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
    elsif find_unit(args[i].downcase,event).length<=0
      args[i]=nil
    else
      args[i]=find_unit(args[i].downcase,event)
      if args[i][0].is_a?(Array)
        args[i]=args[i].map{|q| q[0]}.join(' ')
      else
        args[i]=args[i][0]
      end
    end
  end
  args=args.join(' ').split(' ')
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  args2=[]
  for i in 0...args.length
    m=find_unit(args[i].downcase,event)
    args2.push(m[8]) if m.length>0
    args[i]=nil if m.length<=0
  end
  args.compact!
  args2.compact!
  alz=@aliases.map{|q| q}
  if !detect_multi_unit_alias(event,multi.downcase,multi.downcase,3).nil?
    j=-1
    for i in 0...alz.length
      j=i if alz[i][0]=='Unit' && alz[i][2].is_a?(Array) && alz[i][1].downcase==multi.downcase && j<0
    end
    if j<0
      alz.push(['Unit',multi,args2])
      event.respond "A new multi-unit alias **#{multi}** has been created with the members #{args.join(', ')}"
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Multi-unit alias:** #{multi}\n**Units included:** #{args.join(', ')}")
    elsif args.reject{|q| alz[j][2].include?(q)}.length<=0
      event.respond "#{list_lift(args,"and")} #{['','is','are both','are all'][[args.length,3].min]} already included in that multi-unit alias."
      return nil
    else
      for i in 0...args.length
        alz[j][2].push(args2[i]) unless alz[j][2].include?(args2[i])
      end
      event.respond "The existing multi-unit alias **#{multi}** was updated to include the members #{args.join(', ')}"
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Multi-unit alias:** #{multi}\n**Units added:** #{args.join(', ')}")
    end
  else
    if args.length<=1
      event.respond "There is only one unit listed.  You may want to instead use a global alias."
      return nil
    end
    alz.push(['Unit',multi,args2])
    event.respond "A new multi-unit alias **#{multi}** has been created with the members #{args.join(', ')}"
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Multi-unit alias:** #{multi}\n**Units included:** #{args.join(', ')}")
  end
  alz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
  alz.uniq!
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...alz.length
      f.puts "#{alz[i].to_s}#{"\n" if i<alz.length-1}"
    end
  }
  nicknames_load()
  nzzz=@aliases.map{|q| q}
  if nzzz[-1].length>1 && nzzz[-1][2].is_a?(String) && nzzz[-1][2]>='Verdant Shard'
    bot.channel(logchn).send_message('Alias list saved.')
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
      for i in 0...nzzz.length
        f.puts "#{nzzz[i].to_s}"
      end
    }
    bot.channel(logchn).send_message('Alias list has been backed up.')
  end
end

bot.command([:deletemultialias,:deletedualalias,:deletemultiunitalias,:deletedualunitalias,:deletemulti,:removemultialias,:removedualalias,:removemultiunitalias,:removedualunitalias,:removemulti], from: 167657750971547648) do |event, multi|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  if multi.nil? || multi.length<=0
    event.respond 'No name was included.'
    return nil
  end
  nicknames_load()
  alz=@aliases.map{|q| q}
  for i in 0...alz.length
    alz[i]=nil if alz[i][0]=='Unit' && alz[i][2].is_a?(Array) && alz[i][1].downcase==multi.downcase
  end
  alz.compact!
  event.respond "The multi-unit alias **#{multi}** was deleted."
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**Multi-unit alias:** #{multi}~~\n**DELETED**")
  alz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
  alz.uniq!
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...alz.length
      f.puts "#{alz[i].to_s}#{"\n" if i<alz.length-1}"
    end
  }
  nicknames_load()
  nzzz=@aliases.map{|q| q}
  if nzzz[-1].length>1 && nzzz[-1][2].is_a?(String) && nzzz[-1][2]>='Verdant Shard'
    bot.channel(logchn).send_message('Alias list saved.')
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
      for i in 0...nzzz.length
        f.puts "#{nzzz[i].to_s}"
      end
    }
    bot.channel(logchn).send_message('Alias list has been backed up.')
  end
  return nil
end

bot.command([:removefrommultialias,:removefromdualalias,:removefrommultiunitalias,:removefromdualunitalias,:removefrommulti], from: 167657750971547648) do |event, multi, unit|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  if unit.nil?
    event.respond 'No units were included.'
    return nil
  elsif multi.nil? || multi.length<=0
    event.respond 'No name was included.'
    return nil
  end
  nicknames_load()
  alz=@aliases.map{|q| q}
  j=alz.find_index{|q| q[0]=='Unit' && q[2].is_a?(Array) && q[1].downcase==multi.downcase}
  if j.nil?
    event.respond "#{multi} is not a multi-unit alias."
    return nil
  end
  i=find_unit(unit.downcase,event)
  r=false
  for k in 0...alz[j][2].length
    if alz[j][2][k]==i[8]
      alz[j][2][k]=nil
      r=true
    end
  end
  alz[j][2].compact!
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  if r
    event << "#{i[0]} has been removed from the multi-unit alias #{alz[j][1]}"
    if alz[j][2].length==1
      event << "The multi-unit alias #{alz[j][1]} now has one member, so I'm deleting it.\nIt may be a good idea to turn it into a global [single-unit] alias."
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**Multi-unit alias:** #{alz[j][1]}~~\n**DELETED**")
      alz[j]=nil
      alz.compact!
    else
      bot.channel(logchn).send_message("**Server:** #{srvname} (#{k})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Multi_unit aliase:** #{alz[j][1]}\n**Units removed:** #{i[0]}")
    end
    alz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    alz.uniq!
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
      for i in 0...alz.length
        f.puts "#{alz[i].to_s}#{"\n" if i<alz.length-1}"
      end
    }
    nicknames_load()
    nzzz=@aliases.map{|q| q}
    if nzzz[-1].length>1 && nzzz[-1][2].is_a?(String) && nzzz[-1][2]>='Verdant Shard'
      bot.channel(logchn).send_message('Alias list saved.')
      open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
        for i in 0...nzzz.length
          f.puts "#{nzzz[i].to_s}"
        end
      }
      bot.channel(logchn).send_message('Alias list has been backed up.')
    end
  else
    event << "#{i[0]} wasn't even in the multi-unit alias #{alz[j][1]}, silly!"
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
  nmz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
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
    @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    if !@aliases[-1][2].is_a?(String) || @aliases[-1][2]<'Verdant Shard'
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
  t=Time.now
  if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[0]<=60)
    puts 'reloading EliseMulti1'
    load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
    @last_multi_reload[0]=t
  end
  dev_edit(bot,event,args,cmd)
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
  if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
      if !nzzzzz[-1][2].is_a?(String) || nzzzzz[-1][2]<'Verdant Shard'
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
      nzzzzz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
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

bot.command(:aliashift) do |event|
  return nil if overlap_prevent(event)
  return nil unless [167657750971547648].include?(event.user.id)
  return nil unless @shardizard==4
  nicknames_load()
  data_load()
  untz=@skills.map{|q| q}
  alz=@aliases.reject{|q| q[0]!='Skill'}
  for i in 0...alz.length
    alz[i][1]=alz[i][1].gsub('1','').gsub('2','').gsub('3','').gsub('4','').gsub('5','').gsub('6','').gsub('7','').gsub('8','').gsub('9','').gsub('0','')
    alz[i][1]=alz[i][1][0,alz[i][1].length-1] if alz[i][1][alz[i][1].length-1,1]==' '
    alz[i][2]=alz[i][2].gsub('1','').gsub('2','').gsub('3','').gsub('4','').gsub('5','').gsub('6','').gsub('7','').gsub('8','').gsub('9','').gsub('0','')
    alz[i][2]=alz[i][2][0,alz[i][2].length-1] if alz[i][2][alz[i][2].length-1,1]==' '
  end
  alz.uniq!
  for i in 0...alz.length
    x=untz.find_index{|q| q[1].downcase==alz[i][2].downcase}
    if x.nil?
      x=untz.find_index{|q| "#{q[1]}#{q[2]}".downcase.gsub(' ','')==alz[i][2].gsub(' ','').downcase}
      alz[i][2]=untz[x][0] unless x.nil?
    else
      alz[i][2]=untz[x][0]
    end
  end
  for i in 0...untz.length
    alz.push(['Skill',untz[i][1].gsub('!','').gsub('.','').gsub('(','').gsub(')','').gsub('_','').gsub(' ',''),untz[i][0]]) if untz[i][0]%10==0 || ['Weapon','Assist','Special'].include?(untz[i][6])
    alz.push(['Skill',"#{untz[i][1].gsub('!','').gsub('.','').gsub('(','').gsub(')','').gsub('_','').gsub(' ','')}#{untz[i][2]}",untz[i][0]]) unless ['Weapon','Assist','Special'].include?(untz[i][6]) || ['-','example'].include?(untz[i][2])
    alz.push(['Skill',untz[i][1],untz[i][0]]) if has_any?(['!','.','(',')','_',' '],untz[i][1]) && (untz[i][0]%10==0 || ['Weapon','Assist','Special'].include?(untz[i][6]))
    alz.push(['Skill',"#{untz[i][1]} #{untz[i][2]}",untz[i][0]]) unless ['Weapon','Assist','Special'].include?(untz[i][6]) || ['-','example'].include?(untz[i][2])
  end
  alz.sort!{|a,b| (supersort(a,b,2) == 0 ? supersort(a,b,1) : supersort(a,b,2))}
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNamesX.txt', 'w') { |f|
    for i in 0...alz.length
      f.puts alz[i].to_s
    end
  }
  event.respond 'done'
end

bot.command(:boop) do |event|
  return nil if overlap_prevent(event)
  return nil unless [167657750971547648].include?(event.user.id)
  return nil unless safe_to_spam?(event)
  data_load()
  tagz=@skills.map{|q| q[13]}.join(', ').split(', ').map{|q| q.split(')')[-1]}.uniq
  lookout=lookout_load('SkillSubsets')
  lookout=lookout.reject{|q| q[2]=='Banner' || q[2]=='Art'}
  k=tagz.reject{|q| !lookout.map{|q2| q2[0]}.include?(q)}
  str="__**Sortable tags**__"
  for i in 0...k.length
    str=extend_message(str,k[i],event)
  end
  str=extend_message(str,"__**Un-sortable tags**__",event,2)
  k=tagz.reject{|q| lookout.map{|q2| q2[0]}.include?(q)}
  for i in 0...k.length
    str=extend_message(str,k[i],event)
  end
  event.respond str
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
  if ![285663217261477889,443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,572792502159933440].include?(event.server.id) && @shardizard==4
    (chn.send_message(get_debug_leave_message()) rescue nil)
    event.server.leave
  else
    bot.user(167657750971547648).pm("Joined server **#{event.server.name}** (#{event.server.id})\nOwner: #{event.server.owner.distinct} (#{event.server.owner.id})\nAssigned to use #{shard_data(0,true)[(event.server.id >> 22) % @shards]} Shards")
    metadata_load()
    @server_data[0][((event.server.id >> 22) % @shards)] += 1
    metadata_save()
    chn.send_message("<a:zeldawave:464974581434679296> I'm here to deliver the happiest of hellos - as well as data for heroes and skills in *Fire Emblem: Heroes*!  So, here I am!  Summon me with messages that start with `FEH!`.") rescue nil
  end
end

bot.server_delete do |event|
  unless @shardizard==4
    bot.user(167657750971547648).pm("Left server **#{event.server.name}**")
    metadata_load()
    @server_data[0][((event.server.id >> 22) % @shards)] -= 1
    metadata_save()
  end
end

bot.message do |event|
  data_load()
  str=event.message.text.downcase
  load 'C:/Users/Mini-Matt/Desktop/devkit/FEHPrefix.rb'
  if @shardizard==4 && (['fea!','fef!','fea?','fef?'].include?(str[0,4]) || ['fe13!','fe14!','fe13?','fe14?'].include?(str[0,5]) || ['fe!','fe?'].include?(str[0,3])) && (event.server.nil? || event.server.id==285663217261477889)
    str=str[4,str.length-4] if ['fea!','fef!','fea?','fef?'].include?(str[0,4])
    str=str[5,str.length-5] if ['fe13!','fe14!','fe13?','fe14?'].include?(str[0,5])
    str=str[3,str.length-3] if ['fe!','fe?'].include?(str[0,3])
    a=str.split(' ')
    if a[0].downcase=='reboot'
      event.respond 'Becoming Robin.  Please wait approximately ten seconds...'
      exec 'cd C:/Users/Mini-Matt/Desktop/devkit && feindex.rb 4'
    elsif event.server.nil? || event.server.id==285663217261477889
      event.respond 'I am not Robin right now.  Please use `FE!reboot` to turn me into Robin.'
    end
  elsif (['fgo!','fgo?','liz!','liz?'].include?(str[0,4]) || ['fate!','fate?'].include?(str[0,5])) && @shardizard==4 && (event.server.nil? || event.server.id==285663217261477889)
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
  elsif ['dl!','dl?'].include?(str[0,3]) && @shardizard==4 && (event.server.nil? || event.server.id==285663217261477889)
    s=event.message.text.downcase
    s=s[3,s.length-3]
    a=s.split(' ')
    if a[0].downcase=='reboot'
      event.respond "Becoming Botan.  Please wait approximately ten seconds..."
      exec "cd C:/Users/Mini-Matt/Desktop/devkit && BotanBot.rb 4"
    elsif event.server.nil? || event.server.id==285663217261477889
      event.respond "I am not Botan right now.  Please use `DL!reboot` to turn me into Botan."
    end
  elsif (['!weak '].include?(str[0,6]) || ['!weakness '].include?(str[0,10]))
    if event.server.nil? || event.server.id==264445053596991498
    elsif !bot.user(304652483299377182).on(event.server.id).nil? # Robin
    elsif !bot.user(543373018303299585).on(event.server.id).nil? # Botan
    elsif !bot.user(502288364838322176).on(event.server.id).nil? # Liz
    elsif !bot.user(206147275775279104).on(event.server.id).nil? || @shardizard==4 || event.server.id==330850148261298176 # Pokedex
      triple_weakness(bot,event)
    end
  elsif overlap_prevent(event)
  elsif ['f?','e?','h?'].include?(event.message.text.downcase[0,2]) || ['feh!','feh?'].include?(event.message.text.downcase[0,4]) || (!event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0 && @prefixes[event.server.id].downcase==event.message.text.downcase[0,@prefixes[event.server.id].length])
    puts event.message.text
    s=event.message.text.downcase
    s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
    s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
    s=s[@prefixes[event.server.id].length,s.length-@prefixes[event.server.id].length] if (!event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0 && @prefixes[event.server.id].downcase==event.message.text.downcase[0,@prefixes[event.server.id].length])
    s=s[1,s.length-1] if s[0,1]==' '
    s=s[2,s.length-2] if s[0,2]=='5*'
    a=s.split(' ')
    if s.gsub(' ','').downcase=='laevatein'
      disp_stats(bot,'Laevatein',nil,event,'smol',true,true)
      disp_skill(bot,'Laevatein',event,true)
    elsif s.gsub(' ','').gsub('?','').gsub('!','').length<2
    elsif !all_commands(true).include?(a[0])
      str=find_data_ex(:find_unit,event.message.text,event,false,1)
      str[0]=str[0][0] if str[0].is_a?(Array)
      data_load()
      if str.length>0 && (find_unit(str[0],event,true).length>0 || str[0].downcase.gsub(' ','').gsub('(','').gsub(')','')==str[1].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':',''))
        x=str[0].downcase.gsub(' ','').gsub('(','').gsub(')','')
        if !detect_multi_unit_alias(event,x,x).nil?
          x=detect_multi_unit_alias(event,x,x)
          event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
          k2=get_weapon(first_sub(str[1],x[0],''),event)
          w=nil
          w=k2[0] unless k2.length<=0
          disp_stats(bot,x[1],w,event,'smol',true,true)
        elsif find_unit(str[0],event,true).length>0
          event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
          k=find_data_ex(:find_unit,event.message.text,event,false,1)
          str=k[0]
          str=str[0] if str.is_a?(Array)
          k2=get_weapon(first_sub(s,k[1],''),event)
          w=nil
          w=k2[0] unless k2.length<=0
          disp_stats(bot,str,w,event,'smol',event.server.nil?,true)
        end
      elsif find_skill(s,event,false,true).length>0
        disp_skill(bot,s,event,true)
      elsif find_structure_ex(s,event,true).length>0
        disp_struct(bot,s,event,true)
      elsif find_data_ex(:find_accessory,s,event,true).length>0
        disp_accessory(bot,s,event,true)
      elsif find_data_ex(:find_item_feh,s,event,true).length>0
        disp_itemu(bot,s,event,true)
      elsif str.length<=0
        if find_skill(s,event).length>0
          disp_skill(bot,s,event,true)
        elsif find_structure_ex(s,event).length>0
          disp_struct(bot,s,event,true)
        elsif find_data_ex(:find_accessory,s,event).length>0
          disp_accessory(bot,s,event,true)
        elsif find_data_ex(:find_item_feh,s,event).length>0
          disp_itemu(bot,s,event,true)
        elsif !detect_multi_unit_alias(event,s.downcase,event.message.text.downcase).nil?
          x=detect_multi_unit_alias(event,s.downcase,event.message.text.downcase)
          event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
          k2=get_weapon(first_sub(s,x[0],''),event)
          w=nil
          w=k2[0] unless k2.length<=0
          disp_stats(bot,x[1],w,event,'smol',true,true)
        elsif !detect_multi_unit_alias(event,s.downcase,s.downcase).nil?
          x=detect_multi_unit_alias(event,s.downcase,s.downcase)
          event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
          k2=get_weapon(first_sub(s,x[0],''),event)
          w=nil
          w=k2[0] unless k2.length<=0
          disp_stats(bot,x[1],w,event,'smol',true,true)
        end
      elsif !detect_multi_unit_alias(event,str[0].downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,str[0].downcase,event.message.text.downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.length<=0
        disp_stats(bot,x[1],w,event,'smol',true,true)
      elsif !detect_multi_unit_alias(event,str[0].downcase,str[0].downcase).nil?
        x=detect_multi_unit_alias(event,str[0].downcase,str[0].downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.length<=0
        disp_stats(bot,x[1],w,event,'smol',true,true)
      elsif find_unit(str[0],event).length>0
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k=find_data_ex(:find_unit,event.message.text,event,false,1)
        if k.length<=0
          str=nil
        else
          str=k[0]
          str=str[0] if str.is_a?(Array)
          k2=get_weapon(first_sub(s,k[1],''),event)
          w=nil
          w=k2[0] unless k2.length<=0
        end
        disp_stats(bot,str,w,event,'smol',event.server.nil?,true)
      elsif find_skill(s,event).length>0
        disp_skill(bot,s,event,true)
      elsif find_structure_ex(s,event).length>0
        disp_struct(bot,s,event,true)
      elsif find_data_ex(:find_accessory,s,event).length>0
        disp_accessory(bot,s,event,true)
      elsif find_data_ex(:find_item_feh,s,event).length>0
        disp_itemu(bot,s,event,true)
      elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.length<=0
        disp_stats(bot,x[1],w,event,'smol',true,true)
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
    s=remove_format(s,'||')               # remove spoiler tags
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
  elsif ['f?','e?','h?'].include?(event.message.text.downcase[0,2]) || ['feh!','feh?'].include?(event.message.text.downcase[0,4]) || (!event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0 && @prefixes[event.server.id].downcase==event.message.text.downcase[0,@prefixes[event.server.id].length])
    k=3
  elsif s.gsub(' ','').downcase=='laevatein'
    disp_stats(bot,'Laevatein',nil,event,'smol',true,true)
    disp_skill(bot,'Laevatein',event,true)
    k=3
  elsif ['help','commands','command_list','commandlist'].include?(a[0].downcase)
    a.shift
    help_text(event,bot,a[0],a[1])
    k=1
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
    if ['hero','unit','real'].include?(a[0].downcase)
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
  elsif ['bst'].include?(a[0].downcase)
    t=Time.now
    if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
      puts 'reloading EliseMulti1'
      load 'C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb'
      @last_multi_reload[0]=t
    end
    a.shift
    combined_BST(event,a,bot)
    k=1
  elsif ['checkaliases','seealiases','aliases'].include?(a[0].downcase)
    t=Time.now
    if t-@last_multi_reload[0]>5*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
      if t-@last_multi_reload[1]>60*60 || (@shardizard==4 && t-@last_multi_reload[1]<=60)
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
  elsif ['aoe','area'].include?(a[0].downcase)
    a.shift
    aoe(event,bot,a)
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
    elsif ['pairup','pair'].include?(a[0].downcase)
      a.shift
      k=parse_function(:pair_up,event,a,bot,true)
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
  elsif ['pairup','pair'].include?(a[0].downcase)
    a.shift
    k=parse_function(:pair_up,event,a,bot)
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
      k=find_data_ex(:find_unit,event.message.text,event,false,1)
      k23=0
      if k.length<=0
        w=nil
        if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
          x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
          k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
          w=k2[0] unless k2.length<=0
          disp_stats(bot,x[1],w,event,'smol',true)
        else
          event.respond 'No matches found.'
        end
        k23=1
      end
      str=k[0]
      k2=get_weapon(first_sub(a.join(' '),k[1],''),event)
      w=nil
      w=k2[0] unless k2.length<=0
      data_load()
      if k23>0
      elsif str.is_a?(Array)
        disp_stats(bot,str.map{|q| q[0]},w,event,'smol',true) if str[0].is_a?(Array)
        disp_stats(bot,str[0],w,event,'smol',true) unless str[0].is_a?(Array)
      elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
        disp_stats(bot,x[1],w,event,'smol',true)
      elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
        x=detect_multi_unit_alias(event,str.downcase,str.downcase)
        disp_stats(bot,x[1],w,event,'smol',true)
      elsif find_unit(str,event).length>0
        disp_stats(bot,str,w,event,'smol')
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
      k=find_data_ex(:find_unit,event.message.text,event,false,1)
      k2=0
      if k.length<=0
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
      elsif str.is_a?(Array)
        disp_unit_skills(bot,str.map{|q| q[0]},event) if str[0].is_a?(Array)
        disp_unit_skills(bot,str[0],event) unless str[0].is_a?(Array)
      elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
        disp_unit_skills(bot,x[1],event)
      elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
        x=detect_multi_unit_alias(event,str.downcase,str.downcase)
        disp_unit_skills(bot,x[1],event)
      elsif find_unit(str,event).length>0
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
  elsif ['find','search'].include?(a[0].downcase)
    a.shift
    display_units_and_skills(event,bot,a)
    k=1
  elsif ['sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist','sortskil','skilsort','sortskils','skilssort','listskil','skilist','skilist','listskils','skilslist'].include?(a[0].downcase)
    a.shift
    sort_skills(bot,event,a)
    k=1
  elsif ['smol','small','tiny','little','squashed'].include?(a[0].downcase)
    a.shift
    k=find_data_ex(:find_unit,event.message.text,event,false,1)
    if k.length<=0
      w=nil
      if !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
        k2=get_weapon(first_sub(a.join(' '),x[0],''),event)
        w=k2[0] unless k2.length<=0
        disp_stats(bot,x[1],w,event,'xsmol',true)
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
    w=k2[0] unless k2.length<=0
    data_load()
    if str.is_a?(Array)
      disp_stats(bot,str.map{|q| q[0]},w,event,'xsmol',true) if str[0].is_a?(Array)
      disp_stats(bot,str[0],w,event,'xsmol',true) unless str[0].is_a?(Array)
    elsif !detect_multi_unit_alias(event,str.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,str.downcase,event.message.text.downcase)
      disp_stats(bot,x[1],w,event,'xsmol',true)
    elsif !detect_multi_unit_alias(event,str.downcase,str.downcase).nil?
      x=detect_multi_unit_alias(event,str.downcase,str.downcase)
      disp_stats(bot,x[1],w,event,'xsmol',true)
    elsif find_unit(str,event).length>0
      disp_stats(bot,str,w,event,'xsmol')
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
    str=find_data_ex(:find_unit,event.message.text,event,false,1)
    str[0]=str[0][0] if str[0].is_a?(Array)
    data_load()
    if !str.nil? && (find_unit(str[0],event,true).length>0 || str[0].downcase.gsub(' ','').gsub('(','').gsub(')','')==str[1].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':',''))
      x=str[0].downcase.gsub(' ','').gsub('(','').gsub(')','')
      if !detect_multi_unit_alias(event,x,x).nil?
        x=detect_multi_unit_alias(event,x,x)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(str[1],x[0],''),event)
        w=nil
        w=k2[0] unless k2.length<=0
        disp_stats(bot,x[1],w,event,'smol',true,true)
      elsif find_unit(str[0],event,true).length>0
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k=find_data_ex(:find_unit,event.message.text,event,false,1)
        str=k[0]
        k2=get_weapon(first_sub(s,k[1],''),event)
        w=nil
        w=k2[0] unless k2.length<=0
        if str.is_a?(Array)
          disp_stats(bot,str.map{|q| q[0]},w,event,'smol',event.server.nil?,true) if str[0].is_a?(Array)
          disp_stats(bot,str[0],w,event,'smol',event.server.nil?,true) unless str[0].is_a?(Array)
        else
          disp_stats(bot,str,w,event,'smol',event.server.nil?,true)
        end
      end
    elsif find_skill(s,event,false,true).length>0
      disp_skill(bot,s,event,true)
    elsif find_structure_ex(s,event,true).length>0
      disp_struct(bot,s,event,true)
    elsif find_data_ex(:find_accessory,s,event,true).length>0
      disp_accessory(bot,s,event,true)
    elsif find_data_ex(:find_item_feh,s,event,true).length>0
      disp_itemu(bot,s,event,true)
    elsif str.nil?
      if find_skill(s,event).length>0
        disp_skill(bot,s,event,true)
      elsif find_structure_ex(s,event).length>0
        disp_struct(bot,s,event,true)
      elsif find_data_ex(:find_accessory,s,event).length>0
        disp_accessory(bot,s,event,true)
      elsif find_data_ex(:find_item_feh,s,event).length>0
        disp_itemu(bot,s,event,true)
      elsif !detect_multi_unit_alias(event,s.downcase,event.message.text.downcase).nil?
        x=detect_multi_unit_alias(event,s.downcase,event.message.text.downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.length<=0
        disp_stats(bot,x[1],w,event,'smol',true,true)
      elsif !detect_multi_unit_alias(event,s.downcase,s.downcase).nil?
        x=detect_multi_unit_alias(event,s.downcase,s.downcase)
        event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.length<=0
        disp_stats(bot,x[1],w,event,'smol',true,true)
      end
    elsif str[1].downcase=='ploy' && find_skill(stat_buffs(s,s),event).length>0
      disp_skill(bot,stat_buffs(s,s),event,true)
    elsif !detect_multi_unit_alias(event,str[0].downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,str[0].downcase,event.message.text.downcase)
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k2=get_weapon(first_sub(s,x[0],''),event)
      w=nil
      w=k2[0] unless k2.length<=0
      disp_stats(bot,x[1],w,event,'smol',true,true)
    elsif !detect_multi_unit_alias(event,str[0].downcase,str[0].downcase).nil?
      x=detect_multi_unit_alias(event,str[0].downcase,str[0].downcase)
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k2=get_weapon(first_sub(s,x[0],''),event)
      w=nil
      w=k2[0] unless k2.length<=0
      disp_stats(bot,x[1],w,event,'smol',true,true)
    elsif find_unit(str[0],event).length>0
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k=find_data_ex(:find_unit,event.message.text,event,false,1)
      if k.length<=0
        str=nil
      else
        str=k[0]
        k2=get_weapon(first_sub(s,k[1],''),event)
        w=nil
        w=k2[0] unless k2.length<=0
      end
      disp_stats(bot,str,w,event,'smol',event.server.nil?,true)
    elsif find_skill(s,event).length>0
      disp_skill(bot,s,event,true)
    elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase)
      event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
      k2=get_weapon(first_sub(s,x[0],''),event)
      w=nil
      w=k2[0] unless k2.length<=0
      disp_stats(bot,x[1],w,event,'smol',true,true)
    elsif find_structure_ex(s,event).length>0
      disp_struct(bot,s,event,true)
    elsif find_data_ex(:find_accessory,s,event).length>0
      disp_accessory(bot,s,event,true)
    elsif find_data_ex(:find_item_feh,s,event).length>0
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
  d=d.reject{|q| q[2][0]<2 || q[4][0]=='-'}
  for i in 0...d.length
    if d[i][4][0]!='-'
      holidays.push([0,d[i][3][0],d[i][3][1],d[i][4][0],"in recognition of #{bot.user(d[i][0]).distinct}","Donator's birthday"])
      holidays[-1][5]="Donator's Day" if d[i][0]==189235935563481088
    end
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
    bot.game='Fire Emblem Heroes (FEH!help for info)'
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
      if ![285663217261477889,443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,572792502159933440].include?(bot.servers.values[i].id)
        bot.servers.values[i].general_channel.send_message(get_debug_leave_message()) rescue nil
        bot.servers.values[i].leave
      end
    end
  end
  system("color #{'4' if shard_data(4)[@shardizard,1]=='5'}#{'5' unless shard_data(4)[@shardizard,1]=='5'}#{shard_data(4)[@shardizard,1]}")
  system("title loading #{shard_data(2)[@shardizard]} EliseBot")
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
  system("color e#{shard_data(3)[@shardizard,1]}")
  system("title #{shard_data(2)[@shardizard]} EliseBot")
  bot.game='Fire Emblem Heroes (FEH!help for info)'
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
