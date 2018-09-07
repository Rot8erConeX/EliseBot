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

# this is required to get her to change her avatar on certain holidays
ENV['TZ'] = 'America/Chicago'
@scheduler = Rufus::Scheduler.new

# All the possible command prefixes, not case insensitive so I have to fake it by including every combination of lower- and upper-case
@prefix = ['FEH!','FEh!','FeH!','Feh!','fEH!','fEh!','feH!','feh!',
           'FEH?','FEh?','FeH?','Feh?','fEH?','fEh?','feH?','feh?',
           'f?','F?','e?','E?','h?','H?']

# The bot's token is basically their password, so is censored for obvious reasons
if @shardizard==4
  bot = Discordrb::Commands::CommandBot.new token: '>Debug Token<', client_id: >Debug ID<, prefix: @prefix
else
  bot = Discordrb::Commands::CommandBot.new token: '>Main Token<', shard_id: @shardizard, num_shards: 4, client_id: 312451658908958721, prefix: @prefix
end
bot.gateway.check_heartbeat_acks = false

# initialize global variables
@units=[]
@skills=[]
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
@avvie_info=['Elise','*Fire Emblem Heroes*','N/A']
@stored_event=nil
@zero_by_four=[0,0,0,'']
@headpats=[0,0,0]
@rarity_stars=['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>',
               '<:Icon_Rarity_4:448266418459377684>','<:Icon_Rarity_5:448266417553539104>','<:Icon_Rarity_5:448266417553539104>']
@summon_servers=[330850148261298176,389099550155079680,256291408598663168,271642342153388034,285663217261477889,280125970252431360,356146569239855104,
                 393775173095915521,341729526767681549,380013135576432651,383563205894733824,374991726139670528,338856743553597440,297459718249512961,
                 283833293894582272,305889949574496257,214552543835979778,332249772180111360,334554496434700289,306213252625465354,197504651472535552,
                 347491426852143109,392557615177007104,295686580528742420,412303462764773376,442465051371372544,353997181193289728,462100851864109056,
                 337397338823852034,446111983155150875,295001062790660097,328109510449430529,483437489021911051]
@summon_rate=[0,0,3]
@spam_channels=[]
@mods=[[ 0, 0, 0, 0, 0, 0],
       [ 1, 1, 1, 1, 1, 1],
       [ 2, 3, 3, 3, 3, 4],
       [ 4, 4, 5, 5, 6, 6],
       [ 5, 6, 7, 7, 8, 8], # this is a translation of the graphic displayed in the "growths" command.
       [ 7, 8, 8, 9,10,10],
       [ 8, 9,10,11,12,13],
       [10,11,12,13,14,15],
       [12,13,14,15,16,17],
       [13,14,15,17,18,19],
       [15,16,17,19,20,22],
       [16,18,19,21,22,24],
       [18,19,21,23,24,26],
       [19,21,23,25,26,28],
       [21,23,25,27,28,30],
       [23,24,26,29,31,33],
       [24,26,28,31,33,35],
       [26,28,30,33,35,37],
       [27,30,32,35,37,39],
       [29,31,34,37,39,42],
       [30,33,36,39,41,44]]
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
     'whyelise','random','bestin','bestamong','bestatats','stat','merges','setmarker','backup','studystat','studystats','restore','higheststats','worstamong',
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
     'longreplies','sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist','sortstats','statssort',
     'sortstat','statsort','liststats','statslist']
  if permissions==0
    k=all_commands(false)-all_commands(false,1)-all_commands(false,2)
  elsif permissions==1
    k=['addalias','deletealias','removealias','addgroup','deletegroup','removegroup','removemember','removefromgroup']
  elsif permissions==2
    k=['reboot','addmultialias','adddualalias','addualalias','addmultiunitalias','adddualunitalias','addualunitalias','multialias','dualalias','addmulti',
       'deletemultialias','deletedualalias','deletemultiunitalias','deletedualunitalias','deletemulti','removemultialias','removedualalias','dev_edit','devedit',
       'removemultiunitalias','removedualunitalias','removemulti','removefrommultialias','removefromdualalias','removefrommultiunitalias','restore','backup',
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
end

def nicknames_load() # laods the nickname list
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  @aliases=b.reject{|q| q.nil? || q[1].nil?}.uniq
  if @aliases[@aliases.length-1][1]<'Zephiel'
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt')
      b=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt').each_line do |line|
        b.push(eval line)
      end
    else
      b=[]
    end
    nzzzzz=b.reject{|q| q.nil? || q[1].nil?}.uniq
    if nzzzzz[nzzzzz.length-1][1]<'Zephiel'
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
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
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

bot.command([:help,:commands,:command_list,:commandlist]) do |event, command, subcommand| # used to show tooltips regarding each command.  If no command name is given, shows a list of all commands
  return nil if overlap_prevent(event)
  command='' if command.nil?
  k=0
  k=event.server.id unless event.server.nil?
  if ['help','commands','command_list','commandlist'].include?(command.downcase)
    event.respond "The `#{command.downcase}` command displays this message:"
    command=''
  end
  if command.downcase=='reboot'
    create_embed(event,'**reboot**',"Reboots this shard of the bot, installing any updates.\n\n**This command is only able to be used by Rot8er_ConeX**",0x008b8b)
  elsif command.downcase=='sendmessage'
    create_embed(event,'**sendmessage** __channel id__ __*message__',"Sends the message `message` to the channel with id `channel`\n\n**This command is only able to be used by Rot8er_ConeX**, and only in PM.",0x008b8b)
  elsif command.downcase=='leaveserver'
    create_embed(event,'**leaveserver** __server id number__',"Forces me to leave the server with the id `server id`.\n\n**This command is only able to be used by Rot8er_ConeX**, and only in PM.",0x008b8b)
  elsif command.downcase=='snagstats'
    subcommand='' if subcommand.nil?
    if ['server','servers','member','members','shard','shards','users','user'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**",'Returns the number of servers and unique members each shard reaches.',0x40C0F0)
    elsif ['alts','alt','alternate','alternates','alternative','alternatives'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**",'Returns the number of units within each type of alt, as well as specifics about characters with the most alts.',0x40C0F0)
    elsif ['unit','char','character','units','chars','charas','chara'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of units sorted in each of the following ways:\nObtainability\nColor\nWeapon type\nMovement type\nGame of origin (in PM)",0x40C0F0)
    elsif ['skills','skill','weapon','weapons','assist','assists','special','specials','passive','passives'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**",'Returns the number of skills, as well as numbers condensing them into branches (same name with different number) and trees (all skills that promote into/from each other are a single entry).',0x40C0F0)
    elsif ['alias','aliases','name','names','nickname','nicknames'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of aliases in each of the three categories - global single-unit, server-specific [single-unit], and [global] multi-unit.\nAlso returns specifics about the most frequent instances of each category",0x40C0F0)
    elsif ['groups','group','groupings','grouping'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of groups in each of the two categories - global and server-specific.\nAlso returns specifics about the dynamically-created global groups.",0x40C0F0)
    elsif ['code','lines','line','sloc'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the specifics about my code, including number of commands and functions, as well as - if in PM - loops, statements, and conditionals.",0x40C0F0)
    else
      create_embed(event,"**#{command.downcase}**","Returns:\n- the number of servers I'm in\n- the numbers of units and skills in the game\n- the numbers of aliases I keep track of\n- the numbers of groups I keep track of\n- how long of a file I am.\n\nYou can also include the following words to get more specialized data:\nServer(s), Member(s), Shard(s), User(s)\nUnit(s), Character(s), Char(a)(s)\nAlt(s)\nSkill(s)\nAlias(es), Name(s), Nickname(s)\nCode, Line(s), SLOC#{"\n\nAs the bot developer, you can also include a server ID number to snag the shard number, owner, and my nickname in the specified server." if event.user.id==167657750971547648}",0x40C0F0)
    end
  elsif command.downcase=='shard'
    create_embed(event,'**shard**','Returns the shard that this server is served by.',0x40C0F0)
  elsif ['bugreport','suggestion','feedback'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*message__",'PMs my developer with your username, the server, and the contents of the message `message`',0x40C0F0)
  elsif command.downcase=='invite'
    create_embed(event,'**invite**','PMs the invoker with a link to invite me to their server.',0x40C0F0)
  elsif command.downcase=='addalias'
    create_embed(event,'**addalias** __new alias__ __unit__',"Adds `new alias` to `unit`'s aliases.\nIf the arguments are listed in the opposite order, the command will auto-switch them.\n\nInforms you if the alias already belongs to someone.\nAlso informs you if the unit you wish to give the alias to does not exist.",0xC31C19)
  elsif ['allinheritance','allinherit','allinheritable','skillinheritance','skillinherit','skillinheritable','skilllearn','skilllearnable','skillsinheritance','skillsinherit','skillsinheritable','skillslearn','skillslearnable','inheritanceskills','inheritskill','inheritableskill','learnskill','learnableskill','inheritanceskills','inheritskills','inheritableskills','learnskills','learnableskills','all_inheritance','all_inherit','all_inheritable','skill_inheritance','skill_inherit','skill_inheritable','skill_learn','skill_learnable','skills_inheritance','skills_inherit','skills_inheritable','skills_learn','skills_learnable','inheritance_skills','inherit_skill','inheritable_skill','learn_skill','learnable_skill','inheritance_skills','inherit_skills','inheritable_skills','learn_skills','learnable_skills','inherit','learn','inheritance','learnable','inheritable','skillearn','skillearnable'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows all the skills that `name`can learn.\n\nIn servers, will only show the weapons, assists, and specials.\nIn PM, will also show the passive skills.",0xD49F61)
  elsif ['safe','spam','safetospam','safe2spam','long','longreplies'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __toggle__","Responds with whether or not the channel the command is invoked in is one in which I can send extremely long replies.\n\nIf the channel does not fill one of the many molds for acceptable channels, server mods can toggle the ability with the words \"on\" and \"off\".",0xD49F61)
  elsif ['data','unit'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats, and skills.",0xD49F61)
  elsif ['attackicon','attackcolor','attackcolors','attackcolour','attackcolours','atkicon','atkcolor','atkcolors','atkcolour','atkcolours','atticon','attcolor','attcolors','attcolour','attcolours','staticon','statcolor','statcolors','statcolour','statcolours','iconcolor','iconcolors','iconcolour','iconcolours'].include?(command.downcase) || (['stats','stat'].include?(command.downcase) && ['color','colors','colour','colours'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['color','colors','colour','colours'].include?("#{subcommand}".downcase)}**","Explains the reasoning behind the multiple Attack stat icons - <:StrengthS:467037520484630539> <:MagicS:467043867611627520> <:FreezeS:467043868148236299>",0xD49F61)
  elsif ['skillrarity','onestar','twostar','threestar','fourstar','fivestar','skill_rarity','one_star','two_star','three_star','four_star','five_star'].include?(command.downcase) || (['skill'].include?(command.downcase) && ['rarity','rarities'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['rarity','rarities'].include?("#{subcommand}".downcase)}**",'Explains why some units have skills listed at lower rarities than they are available at.',0xD49F61)
  elsif ['color','colors','colour','colours'].include?(command.downcase) || (['skill'].include?(command.downcase) && ['color','colors','colour','colours'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['color','colors','colour','colours'].include?("#{subcommand}".downcase)}** __name__","Shows data on the skill `name`.\n\nIf the skill is a weapon that can be refined, also shows all possible refinements.\nIncluding the word \"default\" or \"base\" in these cases will make this command only show the default weapon.\nOn the flip side, including the word \"refined\" will make this command only show data on the refinements.\n\nThis version of the command causes the display to sort the units by color instead of rarity, allowing users to see what color they should summon when looking for a particular skill.",0xD49F61)
  elsif ['skill'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows data on the skill `name`.\n\nIf the skill is a weapon that can be refined, also shows all possible refinements.\nIncluding the word \"default\" or \"base\" in these cases will make this command only show the default weapon.\nOn the flip side, including the word \"refined\" will make this command only show data on the refinements.\n\nFollowing the command with the word \"colo(u)rs\" will cause the display to sort the units by color instead of rarity, allowing users to see what color they should summon when looking for a particular skill.",0xD49F61)
  elsif ['tinystats','smallstats','smolstats','microstats','squashedstats','sstats','statstiny','statssmall','statssmol','statsmicro','statssquashed','statss','stattiny','statsmall','statsmol','statmicro','statsquashed','sstat','tinystat','smallstat','smolstat','microstat','squashedstat','tiny','small','micro','smol','squashed','littlestats','littlestat','statslittle','statlittle','little'].include?(command.downcase) || (['stat','stats'].include?(command.downcase) && ['tiny','small','micro','smol','squashed','little'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['stat','stats'].include?(command.downcase)}** __name__","Shows `name`'s stats.",0xD49F61)
    disp_more_info(event,-2) if safe_to_spam?(event)
  elsif ['giant','big','tol','macro','large','huge','massive','giantstats','bigstats','tolstats','macrostats','largestats','hugestats','massivestats','giantstat','bigstat','tolstat','macrostat','largestat','hugestat','massivestat','statsgiant','statsbig','statstol','statsmacro','statslarge','statshuge','statsmassive','statgiant','statbig','stattol','statmacro','statlarge','stathuge','statmassive','statol'].include?(command.downcase) || (['stat','stats'].include?(command.downcase) && ['giant','big','tol','macro','large','huge','massive'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['stat','stats'].include?(command.downcase)}** __name__","Shows `name`'s weapon color/type, movement type, stats, skills, and all possible modifiers.",0xD49F61)
    disp_more_info(event) if safe_to_spam?(event)
  elsif ['stats','stat'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats.",0xD49F61)
    disp_more_info(event) if safe_to_spam?(event)
  elsif ['healstudy','studyheal','heal_study','study_heal'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine how much is healed with each healing staff.',0xD49F61)
  elsif ['procstudy','studyproc','proc_study','study_proc'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine how much extra damage is dealt when each Special skill procs.',0xD49F61)
  elsif ['phasestudy','studyphase','phase_study','study_phase'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine the actual stats the unit has during combat.',0xD49F61)
    disp_more_info(event,-1) if safe_to_spam?(event)
  elsif ['study'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the level 40 stats for the unit `name` for a combination of multiple rarities with 0, 5, and 10 merges.',0xD49F61)
  elsif ['summonpool','summon_pool','pool'].include?(command.downcase) || (['summon'].include?(command.downcase) && "#{subcommand}".downcase=='pool')
    create_embed(event,"**#{command.downcase}#{" pool" if command.downcase=='summon'}** __*colors__","Shows the summon pool for the listed color.\n\nIn PM, all colors listed will be displayed, or all colors if none are specified.\nIn servers, only the first color listed will be displayed.",0xD49F61)
  elsif @summon_servers.include?(k) && ['summon'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*colors__","Simulates summoning on a randomly-chosen banner.\n\nIf given `colors`, auto-cracks open any orbs of said colors.\nOtherwise, requires a follow-up response of numbers.\n\nYou can include the word \"current\" or \"now\" to force me to choose a banner that is currently available in-game.\nThe words \"upcoming\" and \"future\" allow you to force a banner that will be available in the future.\nYou can also include one or more of the words below to force the banner to fit into those categories.\n\n**This command is only available in certain servers**.",0x9E682C)
    lookout=[]
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt')
      lookout=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt').each_line do |line|
        lookout.push(eval line)
      end
    end
    w=lookout.reject{|q| q[2]!='Banner' || ['Current','Upcoming'].include?(q[0])}.map{|q| q[0]}.sort
    create_embed(event,'Banner types','',0x40C0F0,nil,nil,triple_finish(w))
  elsif ['effhp','eff_hp'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the effective HP data for the unit `name`.',0xD49F61)
    disp_more_info(event) if safe_to_spam?(event)
  elsif ['natures'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a chart with my nature names.',0xD49F61)
  elsif ['growths','growth','gps','gp'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a chart and explanation on how growths work, and how this creates what the fandom has dubbed "superboons" and "superbanes".',0xD49F61)
  elsif ['merges'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with an explanation on how stats are affected by merging units.',0xD49F61)
  elsif ['flowers','flower'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a link to a page with a random flower.',0xD49F61)
  elsif ['donation','donate'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with information regarding potential donations to my developer.',0xD49F61)
  elsif ['headpat'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Causes the invoker to try to headpat me.',0xD49F61)
  elsif ['tools','links'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a list of links useful to players of *Fire Emblem Heroes*.',0xD49F61)
  elsif ['alts','alt'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Responds with a list of alts that the character has in *Fire Emblem Heroes*.',0xD49F61)
  elsif ['skills','fodder'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and skills.\nYou can also include a rarity to show the skills that the unit learns at that rarity.",0xD49F61)
  elsif ['embed','embeds'].include?(command.downcase)
    event << '**embed**'
    event << ''
    event << 'Toggles whether I post as embeds or plaintext when the invoker triggers a response from me.  By default, I display embeds for everyone.'
    event << 'This command is useful for people who, in an attempt to conserve phone data, disable the automatic loading of images, as this setting also affects their ability to see embeds.'
    unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event << ''
      event << 'This help window is not in an embed so that people who need this command can see it.'
    end
    return nil
  elsif ['aliases','checkaliases','seealiases'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __unit__","Responds with a list of all `unit`'s aliases.\nIf no unit is listed, responds with a list of all aliases and who they are for.\n\nPlease note that if more than 50 aliases are to be listed, I will - for the sake of the sanity of other server members - only allow you to use the command in PM.",0xD49F61)
  elsif ['daily','today','todayinfeh','today_in_feh'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Shows the day's in-game daily events.\nIf in PM, will also show tomorrow's.",0xD49F61)
  elsif ['next','schedule'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __type__","Shows the next time in-game daily events of the type `type` will happen.\nIf in PM and `type` is unspecified, shows the entire schedule.\n\n__*Accepted Inputs*__\nTower, Training_Tower, Color, Shard, Crystal\nFree, 1\\*, 2\\*, F2P, FreeHero\nSpecial, Special_Training\nGHB\nGHB2\nRival, Domain(s), RD, Rival_Domain(s)\nBlessed, Garden(s), Blessing, Blessed_Garden(s)\nTactics_Drills, Tactic(s), Drill(s)\nBanner(s), Summon(ing)(s)\nEvent(s)\nLegendary/Legendaries, Legend(s)",0xD49F61)
  elsif ['deletealias','removealias'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __alias__",'Removes `alias` from the list of aliases, regardless of who it was for.',0xC31C19)
  elsif ['addmultialias','adddualalias','addualalias','addmultiunitalias','adddualunitalias','addualunitalias','multialias','dualalias','addmulti'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__ __\*members__","If there is already a multi-unit alias named `name`, adds `members` to it.\nIf there is not already a multi-unit alias with the name `name`, makes one and adds `members` to it.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['addgroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__ __\*members__","If there is already a group named `name`, adds `members` to it.\nIf there is not already a group with the name `name`, makes one and adds `members` to it.",0xC31C19)
  elsif ['seegroups','groups','checkgroups'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Shows all the existing groups, and their members.',0xD49F61)
  elsif ['deletemultialias','deletedualalias','deletemultiunitalias','deletedualunitalias','deletemulti','removemultialias','removedualalias','removemultiunitalias','removedualunitalias','removemulti'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Removes the multi-unit alias with the name `name`\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['deletegroup','removegroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Removes the group with the name `name`',0xC31C19)
  elsif ['removemember','removefromgroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __group__ __unit__","Removes the unit `unit` from the group with the name `group`.\nIf this causes `group` to have no members, it will also delete it.",0xC31C19)
  elsif ['bst'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*allies__","Shows the BST of the units listed in `allies`.  If more than four characters are listed, I show both the BST of all those listed and the BST of the first four listed.\n\n#{disp_more_info(event,1)}",0xD49F61)
  elsif ['effect'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Lists all weapons that can be refined to obtain an Effect Mode in the weapon refinery.',0xD49F61)
  elsif ['refinery','refine'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Lists all weapons that can be refined or evolved in the weapon refinery, organized by whether they use Divine Dew or Refining Stones.\n\nYou can also include the word \"Effect\" in your message to show only weapons that get Effect Mode refines.",0xD49F61)
  elsif ['legendary','legendaries'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Lists all of the legendary heroes, sorted by up to three defined filters.\nBy default, will sort by Legendary __Element__ and then the non-HP __stat__ boost given by the hero.\n\nPossible filters (in order of priority when applied) :\nElement(s), Flavor(s), Affinity/Affinities\nStat(s), Boost(s)\nWeapon(s)\nColo(u)r(s)\nMove(s), Movement(s)\nNext, Time, Future, Month(s)",0xD49F61)
  elsif ['games'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows a list of games that the unit `name` is in.',0xD49F61)
  elsif ['banners','banner'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows a list of banners that the unit `name` has been a focus unit on.',0xD49F61)
  elsif ['rand','random'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__",'Generates a random unit with random, but still valid, stats.',0xD49F61)
  elsif ['compare','comparison'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*allies__","Compares the units listed in `allies`.  Shows each set of stats, as well as an analysis.\nThis command can compare anywhere between two and ten units.\n\n#{disp_more_info(event,1)}",0xD49F61)
  elsif ['compareskills','compareskill','skillcompare','skillscompare','comparisonskills','comparisonskill','skillcomparison','skillscomparison','compare_skills','compare_skill','skill_compare','skills_compare','comparison_skills','comparison_skill','skill_comparison','skills_comparison','skillsincommon','skills_in_common','commonskills','common_skills'].include?(command.downcase)
    u=random_dev_unit_with_nature(event,false)
    create_embed(event,"**#{command.downcase}** __*allies__","Compares the units listed in `allies`.  Shows the skills that the units have in common.\nThis command can compare exactly two units.\n\n#{disp_more_info(event,1)}",0xD49F61)
  elsif ['average','mean'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then calculates their average in each stat.\n\n#{disp_more_info(event,2)}",0xD49F61)
  elsif ['art'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __unit__ __art type__","Displays `unit`'s character art.  Defaults to their normal portrait, but can be adjusted to other portraits with the following words:\n*Default Attacking Image:* Battle/Battling, Attack/Atk/Att\n*Special Proc Image:* Critical/Crit, Special, Proc\n*Damaged Art:* Damage/Damaged, LowHP/LowHealth",0xD49F61)
  elsif ['bestamong','bestin','beststats','higheststats'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the best in each stat.\n\n#{disp_more_info(event,2)}",0xD49F61)
  elsif ['worstamong','worstin','worststats','loweststats'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the worst in each stat.\n\n#{disp_more_info(event,2)}",0xD49F61)
  elsif ['find','search'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['unit','char','character','person','units','chars','charas','chara','people'].include?(subcommand.downcase)
      lookout=[]
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHGames.txt')
        lookout=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHGames.txt').each_line do |line|
          lookout.push(eval line)
        end
      end
      lookout=lookout.reject{|q| q[0].length>4 && q[0][0,4]=='FE14'}
      d=[]
      for i in 0...lookout.length
        d.push("**#{lookout[i][2].gsub("#{lookout[i][0]} - ",'').gsub(" (All paths)",'')}**\n#{lookout[i][1].join(', ')}")
      end
      if d.join("\n\n").length>=1900 || !safe_to_spam?(event)
        d=lookout.map{|q| q[0]}
        if d.length>50 && !safe_to_spam?(event)
          create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list.\n\n#{disp_more_info(event,2)}\n\nYou can also search for units by gender.\nYou can search by game as well, and game options can be displayed if you use this command in PM.",0xD49F61)
        else
          create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list.\n\n#{disp_more_info(event,2)}\n\nYou can also search for units by gender.\nYou can search by game as well, by using the words below.",0xD49F61)
          create_embed(event,'Games','',0x40C0F0,nil,nil,triple_finish(d))
        end
      else
        create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list.\n\n#{disp_more_info(event,2)}\n\nYou can also search for units by gender.\nYou can search by game as well, by using the words below.",0xD49F61)
        create_embed(event,'Games',d.join("\n\n"),0x40C0F0)
      end
    elsif ['skill','skills'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list.\n\n#{disp_more_info(event,3)}#{"\n\nI also have tags for weapon and passive \"flavors\".  Use this command in PM to see them." unless safe_to_spam?(event)}",0xD49F61)
      if safe_to_spam?(event)
        lookout=[]
        if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt')
          lookout=[]
          File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt').each_line do |line|
            lookout.push(eval line)
          end
        end
        w=lookout.reject{|q| q[2]!='Weapon' || !q[4].nil?}.map{|q| q[0]}.sort
        p=lookout.reject{|q| q[2]!='Passive' || !q[4].nil?}.map{|q| q[0]}.sort
        w=w.reject{|q| q=='Hogtome'} unless !event.server.nil? && event.server.id==330850148261298176
        if w.join("\n").length+p.join("\n").length>=1950 || !safe_to_spam?(event)
          create_embed(event,'Weapon Flavors','',0x40C0F0,nil,nil,triple_finish(w))
          create_embed(event,'Passive Flavors','',0x40C0F0,nil,nil,triple_finish(p))
        else
          create_embed(event,'','',0x40C0F0,nil,nil,[['Weapon Flavors',w.join("\n")],['Passive Flavors',p.join("\n")]])
        end
      end
    else
      create_embed(event,"**#{command.downcase}** __\*filters__","Combines the results of `FEH!find unit` and `FEH!find skill`, showing them in a single embed.  This combined form is particularly useful when looking at weapon types, so you can see all the weapons *and* all the units that can use them side-by-side.\n\n#{disp_more_info(event,4)}",0xD49F61)
    end
  elsif ['setmarker'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __letter__","Sets the server's \"marker\", allowing for server-specific custom units and skills.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['backup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __item__","Backs up the alias list or the group list, depending on the word used as `item`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['restore'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __item__","Restores the the alias list or the group list, depending on the word used as `item`, from last backup.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['reload'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Reloads the unit and skill data, based on the remote entries stored on GitHub.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['status','avatar','avvie'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Shows my current avatar, status, and reason for such.\n\nWhen used by my developer with a message following it, sets my status to that message.",0xD49F61)
  elsif ['devedit','dev_edit'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['create'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*stats__","Allows me to create a new devunit with the character `unit` and stats described in `stats`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['promote','rarity','feathers'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","Causes me to promote the devunit with the name `unit`.\n\nIf `number` is defined, I will promote the devunit that many times.\nIf not, I will promote them once.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['newwaifu','newaifu','addwaifu','new_waifu','add_waifu','waifu'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Adds a new unit to the list of the developer waifus.\n\nThis adds them to the [hidden] \"Mathoo'sWaifus\" searchable group.\nIt also causes me to congratulate my developer when he summons the unit.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['newsomebody','newsomeone','newsomebodies','addsomebody','addsomeone','addsomebodies','new_somebody','new_someone','new_somebodies','add_somebody','add_someone','add_somebodies','somebody','somebodies','someone'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Adds a new unit to the list of the developer \"somebodies\".\nThese are units he wants but doesn't consider waifu material.\n\nThis causes me to congratulate my developer when he summons the unit.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['newnobody','newnoone','newnobodies','addnobody','addnoone','addnobodies','new_nobody','new_noone','new_nobodies','add_nobody','add_noone','add_nobodies','nobody','nobodies','noone'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Adds a new unit to the list of the developer \"nobodies\".\nThese are units that he does not care for but keeps in his barracks for one reason or another.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['remove','delete','send_home','sendhome','fodder'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Removes a unit from either the developer \"nobodies\" list or the devunits.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['merge','combine'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","Causes me to merge the devunit with the name `unit`.\n\nIf `number` is defined, I will merge the devunit that many times.\nIf not, I will merge them once.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['nature','ivs'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*effects__","Causes me to change the nature of the devunit with the name `unit`\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['learn','teach'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill types__","Causes me to teach the skills in slots `skill types` to the devunit with the name `unit`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    else
      create_embed(event,"**#{command.downcase}** __subcommand__ __unit__ __\*effects__","Allows me to create and edit the devunits.\n\nAvailable subcommands include:\n`FEH!#{command.downcase} create` - creates a new devunit\n`FEH!#{command.downcase} promote` - promotes an existing devunit (*also `rarity` and `feathers`*)\n`FEH!#{command.downcase} merge` - increases a devunit's merge count (*also `combine`*)\n`FEH!#{command.downcase} nature` - changes a devunit's nature (*also `ivs`*)\n`FEH!#{command.downcase} teach` - teaches a new skill to a devunit (*also `learn`*)\n\n`FEH!#{command.downcase} new_waifu` - adds a dev waifu (*also `add_waifu`*)\n`FEH!#{command.downcase} new_somebody` - adds a dev \"somebody\" (*also `add_somebody`*)\n`FEH!#{command.downcase} new_nobody` - adds a dev \"nobody\" (*also `add_nobody`*)\n\n`FEH!#{command.downcase} send_home` - removes the unit from either the devunits or the \"nobodies\" list (*also `fodder` or `remove` or `delete`*)\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    end
  elsif ['sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list in order based on their SP cost.\n\n#{disp_more_info(event,3)}",0xD49F61)
    if safe_to_spam?(event)
      lookout=[]
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt')
        lookout=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt').each_line do |line|
          lookout.push(eval line)
        end
      end
      w=lookout.reject{|q| q[2]!='Weapon' || !q[4].nil?}.map{|q| q[0]}.sort
      p=lookout.reject{|q| q[2]!='Passive' || !q[4].nil?}.map{|q| q[0]}.sort
      w=w.reject{|q| q=='Hogtome'} unless !event.server.nil? && event.server.id==330850148261298176
      if w.join("\n").length+p.join("\n").length>=1950 || !safe_to_spam?(event)
        create_embed(event,'Weapon Flavors','',0x40C0F0,nil,nil,triple_finish(w))
        create_embed(event,'Passive Flavors','',0x40C0F0,nil,nil,triple_finish(p))
      else
        create_embed(event,'','',0x40C0F0,nil,nil,[['Weapon Flavors',w.join("\n")],['Passive Flavors',p.join("\n")]])
      end
    end
  elsif ['sortstats','statssort','sortstat','statsort','liststats','statslist','statlist','liststat','sortunits','unitssort','sortunit','unitsort','listunits','unitslist','unitlist','listunit'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list in order based on the stats you include.\n\n#{disp_more_info(event,2)}",0xD49F61)
  elsif ['sort','list'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['groups','group'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Sorts the groups list alphabetically by group name.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['alias','aliases'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Sorts the alias list alphabetically by unit the alias is for.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['stat','stats','unit','units'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list in order based on the stats you include.\n\n#{disp_more_info(event,2)}",0xD49F61)
    elsif ['skills','skill'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list in order based on their SP cost.\n\n#{disp_more_info(event,3)}",0xD49F61)
      if safe_to_spam?(event)
        lookout=[]
        if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt')
          lookout=[]
          File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSkillSubsets.txt').each_line do |line|
            lookout.push(eval line)
          end
        end
        w=lookout.reject{|q| q[2]!='Weapon' || !q[4].nil?}.map{|q| q[0]}.sort
        p=lookout.reject{|q| q[2]!='Passive' || !q[4].nil?}.map{|q| q[0]}.sort
        w=w.reject{|q| q=='Hogtome'} unless !event.server.nil? && event.server.id==330850148261298176
        if w.join("\n").length+p.join("\n").length>=1950 || !safe_to_spam?(event)
          create_embed(event,'Weapon Flavors','',0x40C0F0,nil,nil,triple_finish(w))
          create_embed(event,'Passive Flavors','',0x40C0F0,nil,nil,triple_finish(p))
        else
          create_embed(event,'','',0x40C0F0,nil,nil,[['Weapon Flavors',w.join("\n")],['Passive Flavors',p.join("\n")]])
        end
      end
    else
      create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list in order based on the stats you include.\n\n#{disp_more_info(event,2)}\n\n\nIn addition, you can use `FEH!sort skill` to sort skills by their SP cost.",0xD49F61)
    end
  else
    x=0
    x=1 unless safe_to_spam?(event)
    if command.downcase=='here'
      x=0
      command=''
    end
    event.respond "#{command.downcase} is not a command" if command!='' && command.downcase != 'devcommands'
    create_embed([event,x],"Command Prefixes: #{@prefix.map{|q| q.upcase}.uniq.map {|s| "`#{s}`"}.join(', ')}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n__**Elise Bot help**__","__**Unit/Character Data**__\n\n`data` __unit__ - shows both stats and skills (*also `unit`*)\n`stats` __unit__ - shows only the stats\n`smolstats` __unit__ - shows ths stats in a condensed format (*also `tinystats` and `microstats`*)\n`skills` __unit__ - shows only the skills (*also `fodder`*)\n`study` __unit__ - for a study of the unit at multiple rarities and merges\n`effHP` __unit__ - for a study of the unit's bulkiness (*also `bulk`*)\n`aliases` __unit__ - show all aliases for the unit (*also `checkaliases` or `seealiases`*)\n`serveraliases` __unit__ - show server-specific aliases for the unit\n`healstudy` __unit__ - to see what how much each healing staff does (*also `studyheal`*)\n`procstudy` __unit__ - to see what how much each damaging Special does (*also `studyproc`*)\n`phasestudy` __unit__ - to see what the actual stats the unit has during combat (*also `studyphase`*)\n`banners` __unit__ - for a list of banners the unit has been a focus unit on\n`art` __unit__ __art type__ - for the character's art\n`learnable` __unit__ - for a list of all learnable skills (*also `inheritable`*)\n\n`games` __character__ - for a list of games the character is in\n`alts` __character__ - for a list of all units this character has",0xD49F61)
    create_embed([event,x],"","__**Other Data**__\n`bst` __\\*allies__\n`find` __\\*filters__ - used to generate a list of applicable units and/or skills (*also `search`*)\n`summonpool` \\*colors - for a list of summonable units sorted by rarity (*also `pool`*)\n`legendaries` \\*filters - for a sorted list of all legendaries. (*also `legendary`*)\n`refinery` - used to show a list of refineable weapons (*also `refine`*)\n`sort` __\\*filters__ - used to create a list of applicable units and sort them based on specified stats\n`skill` __skill name__ - used to show data on a specific skill\n`average` __\\*filters__ - used to find the average stats of applicable units (*also `mean`*)\n`bestamong` __\\*filters__ - used to find the best stats among applicable units (*also `bestin`, `beststats`, or `higheststats`*)\n`worstamong` __\\*filters__ - used to find the worst stats among applicable units (*also `worstin`, `worststats`, or `loweststats`*)\n`compare` __\\*allies__ - compares units' stats (*also `comparison`*)\n`compareskills` __\\*allies__ - compares units' skills",0xD49F61)
    create_embed([event,x],"","__**Meta data**__\n`groups` (*also `checkgroups` or `seegroups`*) - for a list of all unit groups\n`tools` - for a list of tools aside from me that may aid you\n`natures` - for help understanding my nature names\n`growths` - for help understanding how growths work (*also `gps`*)\n`merges` - for help understanding how merges work\n`invite` - for a link to invite me to your server\n`random` - generates a random unit (*also `rand`*)\n`daily` - shows the current day's in-game daily events (*also `today` or `todayInFEH`*)\n`next` __type__ - to see a schedule of the next time in-game daily events will happen (*also `schedule`*)\n\n__**Developer Information**__\n`avatar` - to see why my avatar is different from the norm\n\n`bugreport` __\\*message__ - to send my developer a bug report\n`suggestion` __\\*message__ - to send my developer a feature suggestion\n`feedback` __\\*message__ - to send my developer other kinds of feedback\n~~the above three commands are actually identical, merely given unique entries to help people find them~~\n\n`donation` (*also `donate`*) - for information on how to donate to my developer\n`whyelise` - for an explanation as to how Elise was chosen as the face of the bot\n`skillrarity` (*also `skill_rarity`*)\n`attackcolor` - for a reason for multiple Atk icons (*also `attackicon`*)\n`snagstats` __type__ - to receive relevant bot stats\n`spam` - to determine if the current location is safe for me to send long replies to (*also `safetospam` or `safe2spam`*)#{"\n\n__**Server-specific command**__\n`summon` \\*colors - to simulate summoning on a randomly-chosen banner" if !event.server.nil? && @summon_servers.include?(event.server.id)}",0xD49F61)
    create_embed([event,x],"__**Server Admin Commands**__","__**Unit Aliases**__\n`addalias` __new alias__ __unit__ - Adds a new server-specific alias\n~~`aliases` __unit__ (*also `checkaliases` or `seealiases`*)~~\n`deletealias` __alias__ (*also `removealias`*) - deletes a server-specific alias\n\n__**Groups**__\n`addgroup` __name__ __\\*members__ - adds a server-specific group\n~~`groups` (*also `checkgroups` or `seegroups`*)~~\n`deletegroup` __name__ (*also `removegroup`*) - Deletes a server-specific group\n`removemember` __group__ __unit__ (*also `removefromgroup`*) - removes a single member from a server-specific group\n\n",0xC31C19) if is_mod?(event.user,event.server,event.channel)
    create_embed([event,x],"__**Bot Developer Commands**__","`devedit` __subcommand__ __unit__ __\\*effect__\n\n__**Mjolnr, the Hammer**__\n`ignoreuser` __user id number__ - makes me ignore a user\n`leaveserver` __server id number__ - makes me leave a server\n\n__**Communication**__\n`status` __\\*message__ - sets my status\n`sendmessage` __channel id__ __\\*message__ - sends a message to a specific channel\n`sendpm` __user id number__ __\\*message__ - sends a PM to a user\n\n__**Server Info**__\n`snagstats` - snags relevant bot stats\n`setmarker` __letter__\n\n__**Shards**__\n`reboot` - reboots this shard\n\n__**Meta Data Storage**__\n`reload` - reloads the unit and skill data\n`backup` __item__ - backs up the (alias/group) list\n`restore` __item__ - restores the (alias/group) list from last backup\n`sort aliases` - sorts the alias list alphabetically by unit\n`sort groups` - sorts the group list alphabetically by group name\n\n__**Multi-unit Aliases**__\n`addmulti` __name__ __\\*units__ - to create a multi-unit alias\n`deletemulti` __name__ (*also `removemulti`*) - Deletes a multi-unit alias",0x008b8b) if (event.server.nil?|| event.channel.id==283821884800499714 || @shardizard==4 || command.downcase=='devcommands') && event.user.id==167657750971547648
    event.respond "If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nCommand Prefixes: #{@prefix.map{|q| q.upcase}.uniq.map {|s| "`#{s}`"}.join(', ')}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n\nWhen looking up a character or skill, you also have the option of @ mentioning me in a message that includes that character/skill's name" unless x==1
    event.user.pm("If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nCommand Prefixes: #{@prefix.map{|q| q.upcase}.uniq.map {|s| "`#{s}`"}.join(', ')}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n\nWhen looking up a character or skill, you also have the option of @ mentioning me in a message that includes that character/skill's name") if x==1
    event.respond "A PM has been sent to you.\nIf you would like to show the help list in this channel, please use the command `FEH!help here`." if x==1
  end
end

bot.command(:reboot, from: 167657750971547648) do |event| # reboots Elise
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  puts 'FEH!reboot'
  exec "cd C:/Users/Mini-Matt/Desktop/devkit && PriscillaBot.rb #{@shardizard}"
end

def attack_icon(event) # this is used by the attaccolor command to display all info
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event.respond "__**Why are the Attack stat icons colored weird?**__\n\n*1.) The Def/Res icons*\n<:DefenseS:467037520249487372> <:ResistanceS:467037520379641858>\nIf one looks carefully, the icons for Defense and Resistance are the same design, but with different color backgrounds.\n\n*2.) The official Attack icon*\n<:StrengthS:467037520484630539> <:DefenseS:467037520249487372>\nLikewise, the Attack and Defense icons have the same color background.  Defense looks slightly redder, but that's because it has a large swatch of yellow inside it whereas Attack has a slightly smaller swatch of blue-white in it.\n\n*3.) The original patent for FEH's summoning system*\n<:Orb_Red:455053002256941056> <:Orb_Blue:455053001971859477> <:Orb_Green:455053002311467048> <:Orb_Colorless:455053002152083457>\nIf one looks at the original patent for FEH's summoning system, they learn that at some point during FEH's development, units had the possibility for simultaneously having two weapon types.  The patent specifically says that if the two weapon types (refered to as \"character attributes\") are different, the orb used to hide the character (refered to as \"the mask\") would be a hybrid of the two colors, akin to tye-dye or a Yin-Yang symbol."
    event.respond "Taking these three facts into consideration, I believe that at some point in development, units were going to have six stats: <:HP_S:467037520538894336>HP, <:StrengthS:467037520484630539>Strength, <:MagicS:467043867611627520>Magic, <:SpeedS:467037520534962186>Speed, <:DefenseS:467037520249487372>Defense, and <:ResistanceS:467037520379641858>Resistance.\nThat what we now know as the attack icon would be used for Strength and a similar icon with a blue background would be used for Magic.\nThis would mean that when viewing stats, the red swords <:StrengthS:467037520484630539> would attack the enemy's red shield <:DefenseS:467037520249487372>, and the blue swords <:MagicS:467043867611627520> would attack the blue shield <:ResistanceS:467037520379641858>.\nThey then ran into issues with a proper control scheme on phones that allowed for this to be easy to understand for newcomers, so they reduced each character to a single weapon, and thus a single attacking stat.  Said stat was then reduced to a single color to prevent it from conflicting with the gradients of the \"dual stat\" icons.\n\nAll I am doing is acting on this theory and showing icons for each individual type of attacking stat:\n<:StrengthS:467037520484630539> Sword/Lance/Axe users, Archers, and Thieves have Strength\n<:MagicS:467043867611627520> Mages and Healers have Magic\n<:FreezeS:467043868148236299> And Dragons have a stat that is a hybrid of the two (because it attacks the lower defensive stat in certain conditions)\nCertain commands that deal with multiple units also have this symbol <:GenericAttackS:467065089598423051> for use when the units involved have different attacking stats."
  else
    create_embed(event,"__**Why are the Attack stat icons colored weird?**__","**1.) The Def/Res icons**\n<:DefenseS:467037520249487372> <:ResistanceS:467037520379641858>\nIf one looks carefully, the icons for Defense and Resistance are the same design, but with different color backgrounds.\n\n**2.) The official Attack icon**\n<:StrengthS:467037520484630539> <:DefenseS:467037520249487372>\nLikewise, the Attack and Defense icons have the same color background.  Defense looks slightly redder, but that's because it has a large swatch of yellow inside it whereas Attack has a slightly smaller swatch of blue-white in it.\n\n**3.) The original patent for FEH's summoning system**\n<:Orb_Red:455053002256941056> <:Orb_Blue:455053001971859477> <:Orb_Green:455053002311467048> <:Orb_Colorless:455053002152083457>\nIf one looks at the original patent for FEH's summoning system, they learn that at some point during FEH's development, units had the possibility for simultaneously having two weapon types.  The patent specifically says that if the two weapon types (refered to as \"character attributes\") are different, the orb used to hide the character (refered to as \"the mask\") would be a hybrid of the two colors, akin to tye-dye or a Yin-Yang symbol.",0xC9304A)
    create_embed(event,'',"Taking these three facts into consideration, I believe that at some point in development, units were going to have six stats: <:HP_S:467037520538894336>HP, <:StrengthS:467037520484630539>Strength, <:MagicS:467043867611627520>Magic, <:SpeedS:467037520534962186>Speed, <:DefenseS:467037520249487372>Defense, and <:ResistanceS:467037520379641858>Resistance.\nThat what we now know as the attack icon would be used for Strength and a similar icon with a blue background would be used for Magic.\nThis would mean that when viewing stats, the red swords <:StrengthS:467037520484630539> would attack the enemy's red shield <:DefenseS:467037520249487372>, and the blue swords <:MagicS:467043867611627520> would attack the blue shield <:ResistanceS:467037520379641858>.\nThey then ran into issues with a proper control scheme on phones that allowed for this to be easy to understand for newcomers, so they reduced each character to a single weapon, and thus a single attacking stat.  Said stat was then reduced to a single color to prevent it from conflicting with the gradients of the \"dual stat\" icons.\n\nAll I am doing is acting on this theory and showing icons for each individual type of attacking stat:\n<:StrengthS:467037520484630539> Sword/Lance/Axe users, Archers, and Thieves have Strength\n<:MagicS:467043867611627520> Mages and Healers have Magic\n<:FreezeS:467043868148236299> And Dragons have a stat that is a hybrid of the two (because it attacks the lower defensive stat in certain conditions)\nCertain commands that deal with multiple units also have this symbol <:GenericAttackS:467065089598423051> for use when the units involved have different attacking stats.",0x3B659F)
  end
end

def skill_rarity(event) # this is used by the skillrarity command to display all info
  xcolor=[0x4A7572,0x575758,0x79422A,0x6C898E,0x9B7423].sample
  r="Y rarity"
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  s=s.split(' ')[0].gsub('_','')
  if s=='onestar'
    xcolor=0x4A7572
    r="1\\*"
  elsif s=='twostar'
    xcolor=0x575758
    r="2\\*"
  elsif s=='threestar'
    xcolor=0x79422A
    r="3\\*"
  elsif s=='fourstar'
    xcolor=0x6C898E
    r="4\\*"
  elsif s=='fivestar'
    xcolor=0x9B7423
    r="5\\*"
  elsif rand(100).zero?
    xcolor=0xDC3461
  end
  if " #{event.message.text.downcase} ".include?(' progression ')
    create_embed(event,"__**Non-healers**__","",xcolor,"Most non-healer units have at least one Scenario X passive and at least one Scenario Y passive",nil,[["__<:Skill_Weapon:444078171114045450> **Weapons**__","Tier 1 (*Iron, basic magic*) - Default at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*Steel, El- magic, Fire Breath+*) - Default at 2<:Icon_Rarity_2:448266417872044032>\nTier 3 (*Silver, super magic*) - Available at 3<:Icon_Rarity_3:448266417934958592> ~~Kana(M) has his unavailable until 4\\*~~, default at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 (*+ weapons other than Fire Breath+, Prf weapons*) - default at 5<:Icon_Rarity_5:448266417553539104>\nRetro-Prfs (*Felicia's Plate*) - Available at 5<:Icon_Rarity_5:448266417553539104>, promotes from nothing",1],["__<:Skill_Assist:444078171025965066> **Assists**__","Tier 1 (*Rallies, Dance/Sing, etc.*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 4<:Icon_Rarity_4:448266418459377684> ~~Sharena has hers default at 2\\*~~\nTier 2 (*Double Rallies*) - Available at 4<:Icon_Rarity_4:448266418459377684>\nPrf Assists (*Sacrifice*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Skill_Special:444078170665254929> **Specials**__","Miracle - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 1 (*Daylight, New Moon, etc.*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 4<:Icon_Rarity_4:448266418459377684> ~~Alfonse and Anna have theirs default at 2\\*~~\nTier 2 (*Sol, Luna, etc.*) - Available at 4<:Icon_Rarity_4:448266418459377684> ~~Jaffar and Saber have theirs also default at 5\\*~~\nTier 3 (*Galeforce, Aether, Prf Specials*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1]],2)
    create_embed(event,"__**Healers**__","",0x64757D,"Most healers have a Scenario Y passive",nil,[["__#{"<:Colorless_Staff:443692132323295243>" unless alter_classes(event,'Colored Healers')}#{"<:Gold_Staff:443172811628871720>" if alter_classes(event,'Colored Healers')} **Damaging Staves**__","Tier 1 (*only Assault*) - Available at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*non-plus staves*) - Available at 3<:Icon_Rarity_3:448266417934958592> ~~Lyn(Bride) has hers default when summoned~~\nTier 3 (*+ staves, Prf weapons*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Assist_Staff:454451496831025162> **Healing Staves**__","Tier 1 (*Heal*) - Default at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*Mend, Reconcile*) - Available at 2<:Icon_Rarity_2:448266417872044032>, default at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 (*all other non-plus staves*) - Available at 4<:Icon_Rarity_4:448266418459377684>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 4 (*+ staves, Prf staves if healers got them*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Special_Healer:454451451805040640> **Healer Specials**__","Miracle - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 1 (*Imbue*) - Available at 2<:Icon_Rarity_2:448266417872044032>, default at 3<:Icon_Rarity_3:448266417934958592>\nTier 2 (*single-stat Balms, Heavenly Light*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 3 (*double-stat Balms*) - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 (*+ Balms*) - Available at 5<:Icon_Rarity_5:448266417553539104>\nPrf Specials (*no examples yet, but they may come*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1]],2)
    create_embed(event,"__**Passives**__","",0x245265,nil,nil,[["__<:Passive_X:444078170900135936> **Scenario X**__","Tier 1 - Available at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 - Available at 2<:Icon_Rarity_2:448266417872044032> or 3<:Icon_Rarity_3:448266417934958592>\nTier 3 - Available at 4<:Icon_Rarity_4:448266418459377684>"],["__<:Passive_Y:444078171113914368> **Scenario Y**__","Tier 1 - Available at 3<:Icon_Rarity_3:448266417934958592>\nTier 2 - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 3 - Available at 5<:Icon_Rarity_5:448266417553539104>"],["__<:Passive_Prf:444078170887553024> **Prf Passives**__","Available at 5<:Icon_Rarity_5:448266417553539104>"],["__<:Passive_Z:481922026903437312> **Scenario Z**__","Tier 1 - Available at 2<:Icon_Rarity_2:448266417872044032>\nTier 2 - Available at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 - Available at 5<:Icon_Rarity_5:448266417553539104>"]],2)
  else
    create_embed(event,"**Supposed Bug: X character, despite not being available at #{r}, has skills listed for #{r.gsub('Y','that')} in the `skill` command.**\n\nA word from my developer","By observing the skill lists of the Daily Hero Battle units - the only units we have available at 1\\* - I have learned that there is a set progression for which characters learn skills.  Only six units directly contradict this observation - and three of those units are the Askrians, who were likely given their Assists and Tier 1 Specials (depending on the character) at 2\\* in order to make them useable in the early story maps when the player has limited orbs and therefore limited unit choices.  One is Lyn(Bride), who as the only seasonal healer so far, may be the start of a new pattern.  The other two are Jaffar and Saber, who - for unknown reasons - have their respective Tier 2 Specials available right out of the box as 5\\*s.\n\nThe information as it is is not useless.  In fact, as seen quite recently as of the time of this writing, IntSys is willing to demote some units out of the 4-5\\* pool into the 3-4\\* one. This information allows us to predict which skills the new 3\\* versions of these characters will have.\n\nAs for units unlikely to demote, Paralogue maps will have lower-rarity versions of units with their base kits.  Training Tower and Tempest Trials attempt to build units according to recorded trends in Arena, but will use default base kits at lower difficulties.  Obviously you can't fodder a 4* Siegbert for Death Blow 3, but you can still encounter him in Tempest.",xcolor)
    event.respond "To see the progression I have discovered, please use the command `FEH!skillrarity progression`."
  end
end

def triple_finish(list,forcetwo=false) # used to split a list into three roughly-equal parts for use in embeds
  return [['.',list.join("\n")]] if list.length<5
  if list.length<10 || forcetwo
    l=0
    l=1 if list.length%2==1
    p1=list[0,list.length/2+l].join("\n")
    p2=list[list.length/2+l,list.length/2].join("\n")
    return [['.',p1],['.',p2]]
  end
  l=0
  l=1 if list.length%3==2
  m=0
  m=1 if list.length%3==1
  p1=list[0,list.length/3+l].join("\n")
  p2=list[list.length/3+l,list.length/3+m].join("\n")
  p3=list[2*(list.length/3)+l+m,list.length/3+l].join("\n")
  return [['.',p1],['.',p2],['.',p3]]
end

def safe_to_spam?(event) # determines whether or not it is safe to send extremely long messages
  return true if event.server.nil? # it is safe to spam in PM
  return true if [443172595580534784,443181099494146068,443704357335203840,449988713330769920].include?(event.server.id) # it is safe to spam in the emoji servers
  return true if @shardizard==4 # it is safe to spam during debugging
  return true if ['bots','bot'].include?(event.channel.name.downcase) # channels named "bots" are safe to spam in
  return true if event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('spam') # it is safe to spam in any bot spam channel
  return true if event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('command') # it is safe to spam in any bot spam channel
  return true if event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('channel') # it is safe to spam in any bot spam channel
  return true if event.channel.name.downcase.include?('elisebot')  # it is safe to spam in channels designed specifically for EliseBot
  return true if event.channel.name.downcase.include?('elise-bot')
  return true if event.channel.name.downcase.include?('elise_bot')
  return true if @spam_channels.include?(event.channel.id)
  return false
end

def is_mod?(user,server,channel,mode=0) # used by certain commands to determine if a user can use them
  return true if user.id==167657750971547648 # bot developer is always an EliseMod
  return false if server.nil? # no one is a EliseMod in PMs
  return true if user.id==server.owner.id # server owners are EliseMods by default
  for i in 0...user.roles.length # certain role names will count as EliseMods even if they don't have legitimate mod powers
    return true if ['mod','mods','moderator','moderators','admin','admins','administrator','administrators','owner','owners'].include?(user.roles[i].name.downcase.gsub(' ',''))
  end
  return true if user.permission?(:manage_messages,channel) # legitimate mod powers also confer EliseMod powers
  return false if mode>0
  return true if [188781153589657600,238644800994279424,210900237823246336,175150098357944330,183976699367522304,193956706223521793,185935665152786432,323487356172763137,256659145107701760,78649866577780736,189235935563481088].include?(user.id) # people who donate to the laptop fund will always be EliseMods
  return false
end

bot.command([:safe,:spam,:safetospam,:safe2spam,:long,:longreplies]) do |event, f|
  return nil if overlap_prevent(event)
  f='' if f.nil?
  if event.server.nil?
    event.respond 'It is safe for me to send long replies here because this is my PMs with you.'
  elsif [443172595580534784,443181099494146068,443704357335203840,449988713330769920].include?(event.server.id)
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

def overlap_prevent(event) # used to prevent servers with both Elise and her debug form from receiving two replies
  if event.server.nil? # failsafe code catching PMs as not a server
    return false
  elsif event.message.text.downcase.split(' ').include?('debug') && [443172595580534784,443704357335203840,443181099494146068,449988713330769920].include?(event.server.id)
    return @shardizard != 4 # the debug bot can be forced to be used in the emoji servers by including the word "debug" in your message
  elsif [443172595580534784,443704357335203840,443181099494146068,449988713330769920].include?(event.server.id) # emoji servers will use default Elise otherwise
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

def disp_more_info(event, mode=0) # used by the `help` command to display info that repeats in multiple help descriptions.
  if mode<1
    create_embed(event,"","You can modify the unit by including any of the following in your message:\n\n**Rarity**\nProper format: #{rand(@max_rarity_merge[0])+1}\\*\n~~Alternatively, the first number not given proper context will be set as the rarity value unless the rarity value is already defined~~\nDefault: 5\\* unit\n\n**Merges**\nProper format: +#{rand(@max_rarity_merge[1])+1}\n~~Alternatively, the second number not given proper context will be set as the merges value unless the merges value is already defined~~\nDefault: +0\n\n**Boon**\nProper format: +#{['Atk','Spd','Def','Res','HP'].sample}\n~~Alternatively, the first stat name not given proper context will be set as the boon unless the boon is already defined~~\nDefault: No boon\n\n**Bane**\nProper format: -#{['Atk','Spd','Def','Res','HP'].sample}\n~~Alternatively, the second stat name not given proper context will be set as the bane unless the bane is already defined~~\nDefault: No bane#{"\n\n**Weapon**\nProper format: Silver Dagger+ ~~just the weapon's name~~\nDefault: No weapon\n\n**Arena/Tempest Bonus Unit Buff**\nProper format: Bonus\nSecondary format: Tempest, Arena\nDefault: Not applied\n\n**Summoner Support**\nProper format: #{['C','B','A','S'].sample} ~~Just a single letter~~\nDefault: No support" unless mode==-2}",0x40C0F0)
    create_embed(event,"","**Refined Weapon**\nProper format: Falchion (+) #{['Atk','Spd','Def','Res','Effect'].sample}\nSecondary format: Falchion #{['Atk','Spd','Def','Res','Effect'].sample} Mode\nTertiary format: Falchion (#{['Atk','Spd','Def','Res','Effect'].sample})\n~~Alternatively, the third stat name not given proper context, or the second stat given a + in front of it, will be set as the refinement for the weapon if one is equipped and it can be refined~~\n\n**Stat-affecting skills**\nOptions: HP+, Atk+, Spd+, Def+, Res+, LifeAndDeath/LnD/LaD, Fury, FortressDef, FortressRes\n~~LnD, Fury, and the Fortress skills default to tier 3, but other tiers can be applied by including numbers like so: LnD1~~\nDefault: No skills applied\n\n**Stat-buffing skills**\nOptions: Rally skills, Defiant skills, Hone/Fortify skills, Balm skills, Even/Odd Atk/Spd/Def/Res Wave\n~~please note that the skill name must be written out without spaces~~\nDefault: No skills applied\n\n**Stat-nerfing skills**\nOptions: Smoke skills, Seal skills, Threaten skills, Chill skills, Ploy skills\n~~please note that the skill name must be written out without spaces~~\nDefault: No skills applied#{"\n\n**In-combat buffs**\nOptions: Blow skills, Stance/Breath skills, Bond skills, Brazen skills, Close/Distant Def, Fire/Wind/Earth/Water Boost\n~~please note that the skill name must be written out without spaces~~\nDefault: No skills applied\n\n**Defensive Terrain boosts**\nProper format: DefTile\nDefault: Not applied" if mode==-1}\n\n**Stat buffs from Legendary Hero/Blessing interaction**\nProper format: #{['Atk','Spd','Def','Res'].sample} Blessing ~~following the stat buffed by the word \"blessing\"~~\nSecondary format: #{['Atk','Spd','Def','Res'].sample}Blessing ~~no space~~, Blessing#{['Atk','Spd','Def','Res'].sample}\nDefault: No blessings applied\n\nThese can be listed in any order.",0x40C0F0) unless mode==-2
  elsif mode==1
    u=random_dev_unit_with_nature(event)
    return "**IMPORRTANT NOTE**\nUnlike my other commands, this one is heavily context based.  Please format all allies like the example below:\n`#{u[1]}* #{u[0]} +#{u[2]} +#{u[3]} -#{u[4]}`\nAny field with the exception of unit name can be ignored, but unlike my other commands the order is important."
  elsif [2,3,4].include?(mode)
    str="__**Allowed#{" unit" if mode==2}#{" skill" if mode==3} descriptions**__"
    str="#{str}\n*Colors*: Red(s), Blue(s), Green(s), Colo(u)rless(es), Gray(s), Grey(s)"
    str="#{str}\n*Weapon Types*: Physical, Blade(s), Tome(s), Mage(s), Spell(s), Dragon(s), Manakete(s), Breath, Bow(s), Arrow(s), Archer(s), Dagger(s), Shuriken, Knive(s), Ninja(s), Thief/Thieves, Healer(s), Cleric(s), Staff/Staves#{', Beast(s), Laguz' if alter_classes(event,'Beasts')}"
    str="#{str}\n*Combined color and weapon type*: Sword(s), Katana, Spear(s), Lance(s), Naginata, Axe(s), Ax, Club(s), Redtome(s), Redmage(s), Bluetome(s), Bluemage(s), Greentome(s), Greenmage(s)"
    str="#{str}\n\n*Movement*: Flier(s), Flyer(s), Flying, Pegasus/Pegasi, Wyvern(s), Cavalry, Cavalier(s), Cav(s), Horse(s), Pony/Ponies, Horsie(s), Infantry, Foot/Feet, Armo(u)r(s), Armo(u)red" if mode==2
    str="#{str}\n\n*Assists*: Health, HP, Move, Movement, Moving, Arrangement, Positioning, Position(s), Healer(s), Staff/Staves, Cleric(s), Rally/Rallies, Stat(s), Buff(s)" if mode==3
    str="#{str}\n\n*Specials*: Healer(s), Staff/Staves, Cleric(s), Balm(s), Defense/Defence, Defensive/Defencive, Damage, Damaging, Proc, AoE, Area, Spread" if mode==3
    str="#{str}\n\n*Passive*: A, B, C, S, W, Seal(s)" if mode==3
    return str
  end
  return nil
end

def random_dev_unit_with_nature(event,x=true) # used by `disp_more_info()` to randomly display a non-neutral dev unit as an example on how to format units
  devunits_load()
  u=@dev_units.sample
  if x
    # try again if the randomly-chosen unit is neutral or server-specific to another server
    return random_dev_unit_with_nature(event) if u[3]==' ' || u[4]==' ' || find_unit(u[0],event,true)<0
  end
  return u
end

def get_stats(event,name,level=40,rarity=5,merges=0,boon='',bane='') # used by multiple commands to calculate a unit's stats
  data_load()
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
    sttz[i]=-1 if bane.downcase==sttz[i]
    sttz[i]=0 if sttz[i].is_a?(String)
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
  end
  return u
end

def make_stats_string(event,name,rarity,boon='',bane='',hm=@max_rarity_merge[1]) # used by the `study` command to create the stat arrangement shown in it
  k=''
  hm=[hm.to_i, hm.to_i]
  args=sever(event.message.text.downcase).split(' ')
  hm[0]=@max_rarity_merge[1] if hm[0]<0 || args.include?('full') || args.include?('merges')
  hm[1]=0-hm[1] if hm[1]<0
  for i in 0...hm[0]+1
    u=get_stats(event,name,40,rarity,i,boon,bane)
    u=['Kiran',0,0,0,0,0] if u[0]=='Kiran'
    k="#{k}\n**#{i} merge#{'s' unless i==1}:** #{u[1]} / #{u[2]} / #{u[3]} / #{u[4]} / #{u[5]}    (BST: #{u[1]+u[2]+u[3]+u[4]+u[5]})" if i%5==0 || i==hm[1] || args.include?('full') || args.include?('merges')
  end
  return k
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
      e << "Orb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1]}**#{unit_moji(bot,event,-1,@banner[i][1])} (*#{@banner[i][2]}*)"
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

def normalize(str) # used by the majority of commands that accept input, to replace all non-ASCII characters with their ASCII counterparts
  str=str.gsub(/\s+/,' ').gsub(/[[:space:]]+/,' ').gsub(/[[:cntrl:]]/,' ')
  str=str.gsub("\u2019","'").gsub("`","'").gsub("\u2018","'")
  str=str.gsub("\u{1F1E6}","A").gsub("\u{1F1E7}","B").gsub("\u{1F1E8}","C").gsub("\u{1F1E9}","D").gsub("\u{1F1EA}","E").gsub("\u{1F1EB}","F").gsub("\u{1F1EC}","G").gsub("\u{1F1ED}","H").gsub("\u{1F1EE}","I").gsub("\u{1F1EF}","J").gsub("\u{1F1F0}","K").gsub("\u{1F1F1}","L").gsub("\u{1F1F2}","M").gsub("\u{1F1F3}","N").gsub("\u{1F1F4}","O").gsub("\u{1F1F5}","P").gsub("\u{1F1F6}","Q").gsub("\u{1F1F7}","R").gsub("\u{1F1F8}","S").gsub("\u{1F1F9}","T").gsub("\u{1F1FA}","U").gsub("\u{1F1FB}","V").gsub("\u{1F1FC}","W").gsub("\u{1F1FD}","X").gsub("\u{1F1FE}","Y").gsub("\u{1F1FF}","Z")
  str=str.gsub("\u{1F170}",'A').gsub("\u{1F171}",'B').gsub("\u{1F18E}",'AB').gsub("\u{1F191}",'CL').gsub("\u2B55",'O').gsub("\u{1F17E}",'O').gsub("\u{1F198}",'SOS')
  str=str.gsub("\u00E1",'a').gsub("\u00C1",'a').gsub("\u0103",'a').gsub("\u01CE",'a').gsub("\u00C2",'a').gsub("\u00E2",'a').gsub("\u00C4",'a').gsub("\u00E4",'a').gsub("\u0227",'a').gsub("\u1EA1",'a').gsub("\u0201",'a').gsub("\u00C0",'a').gsub("\u00E0",'a').gsub("\u1EA3",'a').gsub("\u0203",'a').gsub("\u0101",'a').gsub("\u0105",'a').gsub("\u1E9A",'a').gsub("\u00C5",'a').gsub("\u00E5",'a').gsub("\u1E01",'a').gsub("\u023A",'a').gsub("\u00C3",'a').gsub("\u00E3",'a').gsub("\u0363",'a').gsub("\u1D00",'a').gsub("\u0251",'a').gsub("\u0250",'a').gsub("\u0252",'a').gsub("\u22C0",'a')
  str=str.gsub("\u00C6",'ae').gsub("\u1D01",'ae').gsub("\u00E6",'ae').gsub("\u1D02",'ae')
  str=str.gsub("\u1E03",'b').gsub("\u1E05",'b').gsub("\u0181",'b').gsub("\u0253",'b').gsub("\u1E07",'b').gsub("\u0243",'b').gsub("\u0180",'b').gsub("\u0183",'b').gsub("\u0299",'b').gsub("\u1D03",'b').gsub("\u212C",'b').gsub("\u0185",'b')
  str=str.gsub("\u0107",'c').gsub("\u010D",'c').gsub("\u00C7",'c').gsub("\u00E7",'c').gsub("\u0109",'c').gsub("\u0255",'c').gsub("\u010B",'c').gsub("\u0189",'c').gsub("\u023B",'c').gsub("\u023C",'c').gsub("\u2183",'c').gsub("\u212D",'c').gsub("\u0368",'c').gsub("\u2102",'c').gsub("\u1D04",'c').gsub("\u0297",'c').gsub("\u2184",'c')
  str=str.gsub("\u212D",'d').gsub("\u0256",'d').gsub("\u010F",'d').gsub("\u1E11",'d').gsub("\u1E13",'d').gsub("\u0221",'d').gsub("\u1E0B",'d').gsub("\u1E0D",'d').gsub("\u018A",'d').gsub("\u0257",'d').gsub("\u1E0F",'d').gsub("\u0111",'d').gsub("\u0256",'d').gsub("\u018C",'d').gsub("\u0369",'d').gsub("\u2145",'d').gsub("\u2146",'d').gsub("\u0189",'d').gsub("\u1D05",'d')
  str=str.gsub("\u00C9",'e').gsub("\u00E9",'e').gsub("\u0115",'e').gsub("\u011B",'e').gsub("\u0229",'e').gsub("\u1E19",'e').gsub("\u00CA",'e').gsub("\u00EA",'e').gsub("\u00CB",'e').gsub("\u00EB",'e').gsub("\u0117",'e').gsub("\u1EB9",'e').gsub("\u0205",'e').gsub("\u00C8",'e').gsub("\u00E8",'e').gsub("\u1EBB",'e').gsub("\u025D",'e').gsub("\u0207",'e').gsub("\u0113",'e').gsub("\u0119",'e').gsub("\u0246",'e').gsub("\u0247",'e').gsub("\u1E1B",'e').gsub("\u1EBD",'e').gsub("\u0364",'e').gsub("\u2147",'e').gsub("\u0190",'e').gsub("\u018E",'e').gsub("\u1D07",'e').gsub("\u029A",'e').gsub("\u025E",'e').gsub("\u0153",'e').gsub("\u025B",'e').gsub("\u0258",'e').gsub("\u025C",'e').gsub("\u01DD",'e').gsub("\u1D08",'e').gsub("\u2130",'e').gsub("\u212F",'e').gsub("\u0259",'e').gsub("\u018F",'e').gsub("\u22FF",'e')
  str=str.gsub("\u1E1F",'f').gsub("\u0192",'f').gsub("\u2131",'f').gsub("\u2132",'f').gsub("\u214E",'f')
  str=str.gsub("\u2640",'(f)')
  str=str.gsub("\u01F5",'g').gsub("\u011F",'g').gsub("\u01E7",'g').gsub("\u0123",'g').gsub("\u011D",'g').gsub("\u0121",'g').gsub("\u0193",'g').gsub("\u029B",'g').gsub("\u0260",'g').gsub("\u1E21",'g').gsub("\u01E5",'g').gsub("\u0262",'g').gsub("\u0261",'g').gsub("\u210A",'g').gsub("\u2141",'g')
  str=str.gsub("\u210C",'h').gsub("\u1E2B",'h').gsub("\u021F",'h').gsub("\u1E29",'h').gsub("\u0125",'h').gsub("\u1E27",'h').gsub("\u1E23",'h').gsub("\u1E25",'h').gsub("\u02AE",'h').gsub("\u0266",'h').gsub("\u1E96",'h').gsub("\u0127",'h').gsub("\u210C",'h').gsub("\u036A",'h').gsub("\u210D",'h').gsub("\u029C",'h').gsub("\u0265",'h').gsub("\u2095",'h').gsub("\u02B0",'h').gsub("\u210B",'h')
  str=str.gsub("\u2111",'i').gsub("\u0197",'i').gsub("\u0130",'i').gsub("\u00CD",'i').gsub("\u00ED",'i').gsub("\u012D",'i').gsub("\u01D0",'i').gsub("\u00CE",'i').gsub("\u00EE",'i').gsub("\u00CF",'i').gsub("\u00EF",'i').gsub("\u0130",'i').gsub("\u1CEB",'i').gsub("\u0209",'i').gsub("\u00CC",'i').gsub("\u00EC",'i').gsub("\u1EC9",'i').gsub("\u020B",'i').gsub("\u012B",'i').gsub("\u012F",'i').gsub("\u0197",'i').gsub("\u0268",'i').gsub("\u1E2D",'i').gsub("\u0129",'i').gsub("\u2111",'i').gsub("\u0365",'i').gsub("\u2148",'i').gsub("\u026A",'i').gsub("\u0131",'i').gsub("\u1D09",'i').gsub("\u1D62",'i').gsub("\u2110",'i').gsub("\u2071",'i').gsub("\u2139",'i').gsub("\uFE0F",'i').gsub("\u1FBE",'i').gsub("\u03B9",'i').gsub("\u0399",'i')
  str=str.gsub("\u0133",'ij')
  str=str.gsub("\u01F0",'j').gsub("\u0135",'j').gsub("\u029D",'j').gsub("\u0248",'j').gsub("\u0249",'j').gsub("\u025F",'j').gsub("\u2149",'j').gsub("\u1D0A",'j').gsub("\u0237",'j').gsub("\u02B2",'j')
  str=str.gsub("\u1E31",'k').gsub("\u01E9",'k').gsub("\u0137",'k').gsub("\u1E33",'k').gsub("\u0199",'k').gsub("\u1E35",'k').gsub("\u1D0B",'k').gsub("\u029E",'k').gsub("\u2096",'k').gsub("\u212A",'k').gsub("\u0138",'k')
  str=str.gsub("\u013A",'l').gsub("\u023D",'l').gsub("\u019A",'l').gsub("\u026C",'l').gsub("\u013E",'l').gsub("\u013C",'l').gsub("\u1E3D",'l').gsub("\u0234",'l').gsub("\u1E37",'l').gsub("\u1E3B",'l').gsub("\u0140",'l').gsub("\u026B",'l').gsub("\u026D",'l').gsub("\u1D0C",'l').gsub("\u0142",'l').gsub("\u029F",'l').gsub("\u2097",'l').gsub("\u02E1",'l').gsub("\u2143",'l').gsub("\u2112",'l').gsub("\u2113",'l').gsub("\u2142",'l')
  str=str.gsub("\u2114",'lb')
  str=str.gsub("\u264C",'leo')
  str=str.gsub("\u1E3F",'m').gsub("\u1E41",'m').gsub("\u1E43",'m').gsub("\u0271",'m').gsub("\u0270",'m').gsub("\u036B",'m').gsub("\u019C",'m').gsub("\u1D0D",'m').gsub("\u1D1F",'m').gsub("\u026F",'m').gsub("\u2098",'m').gsub("\u2133",'m')
  str=str.gsub("\u2642",'(m)')
  str=str.gsub("\u0144",'n').gsub("\u0148",'n').gsub("\u0146",'n').gsub("\u1E4B",'n').gsub("\u0235",'n').gsub("\u1E45",'n').gsub("\u1E47",'n').gsub("\u01F9",'n').gsub("\u019D",'n').gsub("\u0272",'n').gsub("\u1E49",'n').gsub("\u0220",'n').gsub("\u019E",'n').gsub("\u0273",'n').gsub("\u00D1",'n').gsub("\u00F1",'n').gsub("\u2115",'n').gsub("\u0274",'n').gsub("\u1D0E",'n').gsub("\u2099",'n').gsub("\u22C2",'n').gsub("\u220F",'n')
  str=str.gsub("\u00F3",'o').gsub("\u00F0",'o').gsub("\u00D3",'o').gsub("\u014F",'o').gsub("\u01D2",'o').gsub("\u00D4",'o').gsub("\u00F4",'o').gsub("\u00D6",'o').gsub("\u00F6",'o').gsub("\u022F",'o').gsub("\u1ECD",'o').gsub("\u0151",'o').gsub("\u020D",'o').gsub("\u00D2",'o').gsub("\u00F2",'o').gsub("\u1ECF",'o').gsub("\u01A1",'o').gsub("\u020F",'o').gsub("\u014D",'o').gsub("\u019F",'o').gsub("\u01EB",'o').gsub("\u00D8",'o').gsub("\u00F8",'o').gsub("\u1D13",'o').gsub("\u00D5",'o').gsub("\u00F5",'o').gsub("\u0366",'o').gsub("\u019F",'o').gsub("\u0186",'o').gsub("\u1D0F",'o').gsub("\u1D10",'o').gsub("\u0275",'o').gsub("\u1D11",'o').gsub("\u2134",'o').gsub("\u25CB",'o').gsub("\u00A4",'o')
  str=str.gsub("\u1D14",'oe').gsub("\u0153",'oe').gsub("\u0276",'oe')
  str=str.gsub("\u01A3",'oi')
  str=str.gsub("\u0223",'ou').gsub("\u1D15",'ou')
  str=str.gsub("\u1E55",'p').gsub("\u1E57",'p').gsub("\u01A5",'p').gsub("\u2119",'p').gsub("\u1D18",'p').gsub("\u209A",'p').gsub("\u2118",'p').gsub("\u214C",'p')
  str=str.gsub("\u024A",'q').gsub("\u024B",'q').gsub("\u02A0",'q').gsub("\u211A",'q').gsub("\u213A",'q')
  str=str.gsub("\u0239",'qp')
  str=str.gsub("\u211C",'r').gsub("\u0155",'r').gsub("\u0159",'r').gsub("\u0157",'r').gsub("\u1E59",'r').gsub("\u1E5B",'r').gsub("\u0211",'r').gsub("\u027E",'r').gsub("\u027F",'r').gsub("\u027B",'r').gsub("\u0213",'r').gsub("\u1E5F",'r').gsub("\u027C",'r').gsub("\u027A",'r').gsub("\u024C",'r').gsub("\u024D",'r').gsub("\u027D",'r').gsub("\u036C",'r').gsub("\u211D",'r').gsub("\u0280",'r').gsub("\u0281",'r').gsub("\u1D19",'r').gsub("\u1D1A",'r').gsub("\u0279",'r').gsub("\u1D63",'r').gsub("\u02B3",'r').gsub("\u02B6",'r').gsub("\u02B4",'r').gsub("\u211B",'r').gsub("\u01A6",'r')
  str=str.gsub("\u301C",'roy')
  str=str.gsub("\u015B",'s').gsub("\u0161",'s').gsub("\u015F",'s').gsub("\u015D",'s').gsub("\u0219",'s').gsub("\u1E61",'s').gsub("\u1E63",'s').gsub("\u0282",'s').gsub("\u023F",'s').gsub("\u209B",'s').gsub("\u02E2",'s').gsub("\u1E9B",'s').gsub("\u223E",'s').gsub("\u017F",'s').gsub("\u00DF",'s')
  str=str.gsub("\u0165",'t').gsub("\u0163",'t').gsub("\u1E71",'t').gsub("\u021B",'t').gsub("\u0236",'t').gsub("\u1E97",'t').gsub("\u023E",'t').gsub("\u1E6B",'t').gsub("\u1E6D",'t').gsub("\u01AD",'t').gsub("\u1E6F",'t').gsub("\u01AB",'t').gsub("\u01AE",'t').gsub("\u0288",'t').gsub("\u0167",'t').gsub("\u036D",'t').gsub("\u1D1B",'t').gsub("\u0287",'t').gsub("\u209C",'t')
  str=str.gsub("\u00FE",'th')
  str=str.gsub("\u00FA",'u').gsub("\u028A",'u').gsub("\u22C3",'u').gsub("\u0244",'u').gsub("\u0289",'u').gsub("\u00DA",'u').gsub("\u1E77",'u').gsub("\u016D",'u').gsub("\u01D4",'u').gsub("\u00DB",'u').gsub("\u00FB",'u').gsub("\u1E73",'u').gsub("\u00DC",'u').gsub("\u00FC",'u').gsub("\u1EE5",'u').gsub("\u0171",'u').gsub("\u0215",'u').gsub("\u00D9",'u').gsub("\u00F9",'u').gsub("\u1EE7",'u').gsub("\u01B0",'u').gsub("\u0217",'u').gsub("\u016B",'u').gsub("\u0173",'u').gsub("\u016F",'u').gsub("\u1E75",'u').gsub("\u0169",'u').gsub("\u0367",'u').gsub("\u1D1C",'u').gsub("\u1D1D",'u').gsub("\u1D1E",'u').gsub("\u1D64",'u')
  str=str.gsub("\u22C1",'v').gsub("\u030C",'v').gsub("\u1E7F",'v').gsub("\u01B2",'v').gsub("\u028B",'v').gsub("\u1E7D",'v').gsub("\u036E",'v').gsub("\u01B2",'v').gsub("\u0245",'v').gsub("\u1D20",'v').gsub("\u028C",'v').gsub("\u1D65",'v')
  str=str.gsub("\u1E83",'w').gsub("\u0175",'w').gsub("\u1E85",'w').gsub("\u1E87",'w').gsub("\u1E89",'w').gsub("\u1E81",'w').gsub("\u1E98",'w').gsub("\u1D21",'w').gsub("\u028D",'w').gsub("\u02B7",'w')
  str=str.gsub("\u2715",'x').gsub("\u2716",'x').gsub("\u2A09",'x').gsub("\u033D",'x').gsub("\u0353",'x').gsub("\u1E8D",'x').gsub("\u1E8B",'x').gsub("\u2717",'x').gsub("\u036F",'x').gsub("\u2718",'x').gsub("\u2A09",'x').gsub("\u02E3",'x').gsub("\u2A09",'x')
  str=str.gsub("\u00DD",'y').gsub("\u00FD",'y').gsub("\u0177",'y').gsub("\u0178",'y').gsub("\u00FF",'y').gsub("\u1E8F",'y').gsub("\u1EF5",'y').gsub("\u1EF3",'y').gsub("\u1EF7",'y').gsub("\u01B4",'y').gsub("\u0233",'y').gsub("\u1E99",'y').gsub("\u024E",'y').gsub("\u024F",'y').gsub("\u1EF9",'y').gsub("\u028F",'y').gsub("\u028E",'y').gsub("\u02B8",'y').gsub("\u2144",'y').gsub("\u00A5",'y')
  str=str.gsub("\u01B6",'z').gsub("\u017A",'z').gsub("\u017E",'z').gsub("\u1E91",'z').gsub("\u0291",'z').gsub("\u017C",'z').gsub("\u1E93",'z').gsub("\u0225",'z').gsub("\u1E95",'z').gsub("\u0290",'z').gsub("\u01B6",'z').gsub("\u0240",'z').gsub("\u2128",'z').gsub("\u2124",'z').gsub("\u1D22",'z')
  return str
end

def has_any?(arr1,arr2) # used to determine if two arrays share any members
  return true if arr1.nil? && arr2.nil?
  return true if arr1.nil? && !arr2.nil? && arr2.include?(nil)
  return true if arr2.nil? && !arr1.nil? && arr1.include?(nil)
  return false if arr1.nil? || arr2.nil?
  if arr1.is_a?(String)
    arr1=arr1.downcase.chars
  elsif arr1.is_a?(Array)
    arr1=arr1.map{|q| q.downcase rescue q}
  end
  if arr2.is_a?(String)
    arr2=arr2.downcase.chars
  elsif arr2.is_a?(Array)
    arr2=arr2.map{|q| q.downcase rescue q}
  end
  return true if (arr1 & arr2).length>0
  return false
end

def find_unit(name,event,ignore=false,ignore2=false) # used to find a unit's data entry based on their name
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return -1 if name.nil?
  return -1 if name.length<2 && name.downcase != 'bk'
  data_load()
  nicknames_load()
  name=normalize(name.gsub('!',''))
  if name.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    buff=name.split(':')[1]
    buff=buff[3,buff.length-3] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,3].downcase=='gp_'
    buff=buff[2,buff.length-2] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,2].downcase=='gp'
    name=buff if find_unit(buff,event,ignore)>=0
  end
  untz=@units.map{|q| q}
  unless ignore2
    for i in 0...@aliases.length # replace any unit aliases with the actual unit name, if possible
      unless @aliases[i].nil?
        name=@aliases[i][1] if @aliases[i][0].downcase==name.gsub('(','').gsub(')','').downcase && (@aliases[i][2].nil? || @aliases[i][2].include?(k))
      end
    end
  end
  j=-1
  name=name.gsub('!','')
  name=name.gsub('(','').gsub(')','').gsub('_','') unless ignore2
  for i in 0...untz.length # try exact unit names
    unless untz[i].nil?
      m=untz[i][0]
      m=m.gsub('(','').gsub(')','') unless ignore2
      j=i if m.downcase==name.downcase && j<0
    end
  end
  return j if j>=0 && !untz[j].nil? && has_any?(g, untz[j][13][0])
  return -1 if ignore || name.downcase=='blade' || name.downcase=='blad' || name.downcase=='bla'
  for i in 0...untz.length # try the portion of a exact unit names that is exactly as long as the input string
    unless untz[i].nil?
      m=untz[i][0][0,name.length]
      m=m.gsub('(','').gsub(')','') unless ignore2
      j=i if m.downcase==name.downcase && j<0
    end
  end
  return j if j>=0 && !untz[j].nil? && has_any?(g, untz[j][13][0])
  unless ignore2
    for i in 0...@aliases.length # try the portion of any alias names that is exactly as long as the input string
      unless @aliases[i].nil?
        name=@aliases[i][1] if @aliases[i][0][0,name.length].downcase==name.downcase && (@aliases[i][2].nil? || @aliases[i][2].include?(k)) && find_unit(name,event,true)<0
      end
    end
  end
  for i in 0...untz.length
    unless untz[i].nil?
      m=untz[i][0]
      m=m.gsub('(','').gsub(')','') unless ignore2
      j=i if m.downcase==name.downcase && j<0
    end
  end
  return j if j>=0 && !untz[j].nil? && has_any?(g, untz[j][13][0])
  unless ignore2 || !name.downcase.include?('launch')
    name=name.downcase.gsub('launch','') # if the name includes the word "launch", remove it from consideration
    for i in 0...untz.length # try exact unit names
      unless untz[i].nil?
        m=untz[i][0]
        j=i if m.downcase==name.downcase && !m.include?('(') && untz[i][9][0].include?('LU') && j<0 # only units without modifiers in their names, and who are marked as launch units, are considered
      end
    end
    return j if j>=0 && !untz[j].nil? && has_any?(g, untz[j][13][0])
    alz=@aliases.reject{|q| q[1].include?('(') || !q[2].nil?}
    for i in 0...alz.length
      unless alz[i].nil?
        name=alz[i][1] if alz[i][0].downcase==name.downcase && untz.find_index{|q| q[0].downcase==name.downcase}.nil?
      end
    end
    for i in 0...untz.length
      unless untz[i].nil?
        m=untz[i][0]
        j=i if m.downcase==name.downcase && !m.include?('(') && untz[i][9][0].include?('LU') && j<0
      end
    end
    return j if j>=0 && !untz[j].nil? && has_any?(g, untz[j][13][0])
  end
  return -1
end

def find_skill(name,event,ignore=false,ignore2=false,m=false) # one of two functions used to find a skill's data entry based on its name
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
  x3=x3.sort{|a,b| b[1]<=>a[1]}
  return x3[0][0]
end

def x_find_skill(name,event,sklz,ignore=false,ignore2=false,m=false) # one of two functions used to find a skill's data entry based on its name
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return -1 if name.nil? || name.length<2
  name=normalize(name.gsub('!','').gsub('.','').gsub('?',''))
  if name.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    name=name.split(':')[1] if x_find_skill(name.split(':')[1],event,sklz,ignore,ignore2)>=0
  end
  # certain common skill aliases work
  return find_skill('Yato',event) if ['yatogami','yatokami','yatonogami','yatonokami'].include?(name.downcase.gsub(' ',''))
  return find_skill('Bladeblade',event) if name.downcase.gsub(' ','')=='laevatein'
  return find_skill('Eckesachs',event) if ['exaccus','exesack','exsack','eggsacks'].include?(name.downcase.gsub(' ',''))
  return find_skill('Uror',event) if name.downcase.gsub(' ','')=='urdr'
  return find_skill('Hlidskjalf',event) if ['hlioskjalf',"roni'sstick",'ronisstick','staffkatz'].include?(name.downcase.gsub(' ',''))
  return find_skill('Giga Excalibur',event) if name.downcase.gsub(' ','')=='gigascalibur'
  return find_skill('Gae Bolg',event) if name.downcase.gsub(' ','')=='gayborg'
  return find_skill('Recover Ring',event) if name.downcase.gsub(' ','')=='renewal4'
  return find_skill('Loptous',event) if name.downcase.gsub(' ','')=='loptyr'
  return find_skill('Thokk',event) if name.downcase.gsub(' ','')=='sekku'
  return find_skill('Draconic Poleax',event) if name.downcase.gsub(' ','')=='draconicpoleaxe'
  return find_skill("Tannenboom!#{'+' if name.include?('+')}",event) if name.downcase.gsub(' ','').gsub('+','')=='tanenboom'
  return find_skill("Sack o' Gifts#{'+' if name.include?('+')}",event) if name.downcase.gsub(' ','').gsub('+','')=='sackofgifts'
  return find_skill("Killing Edge#{'+' if name.include?('+')}",event) if ['killersword','killeredge','killingsword'].include?(name.downcase.gsub(' ','').gsub('+',''))
  return find_skill("Slaying Edge#{'+' if name.include?('+')}",event) if ['slayersword','slayeredge','slayingsword'].include?(name.downcase.gsub(' ','').gsub('+',''))
  return find_skill(name.downcase.gsub(' ','').gsub('redtome','r tome'),event) if name.downcase.gsub(' ','').include?('redtome')
  return find_skill(name.downcase.gsub(' ','').gsub('bluetome','b tome'),event) if name.downcase.gsub(' ','').include?('bluetome')
  return find_skill(name.downcase.gsub(' ','').gsub('greentome','g tome'),event) if name.downcase.gsub(' ','').include?('greentome')
  return find_skill(name.downcase.gsub('rauor','raudr'),event) if name.downcase.include?('rauor')
  j=-1
  # use the `stat_buffs` function so that "Atk" and "Attack", for example, are treated the same
  # try with only replacing spaces and underscores first...
  x2=stat_buffs(name.gsub(' ','').gsub('_',''),name,2)
  for i in 0...sklz.length
    unless sklz[i].nil?
      j=i if stat_buffs(sklz[i][0].gsub('.','').gsub('!',''),name,2).gsub('?','').gsub(' ','').gsub('_','')==x2 && j<0
    end
  end
  return j if j>=0 && !sklz[j].nil? && has_any?(g, sklz[j][13])
  # ...if that fails, try removing quotes, slashes, and hyphens as well
  x2=stat_buffs(name.gsub(' ','').gsub('_','').gsub("'",'').gsub('/','').gsub("-",''),name,2)
  for i in 0...sklz.length
    unless sklz[i].nil?
      j=i if stat_buffs(sklz[i][0].gsub('.','').gsub('!','').gsub('?','').gsub('/','').gsub("'",'').gsub("-",''),name,2).gsub(' ','').gsub('_','')==x2 && j<0
    end
  end
  return j if j>=0 && !sklz[j].nil? && has_any?(g, sklz[j][13])
  return -1 if ignore
  # more common skill aliases...
  return find_skill(name.downcase.gsub('spooky','spectral'),event,true) if name.downcase.include?('spooky') && find_skill(name.downcase.gsub('spooky','spectral'),event,true)>=0
  return find_skill(name.downcase.gsub('killing','killer'),event,true) if name.downcase.include?('killing') && find_skill(name.downcase.gsub('killing','killer'),event,true)>=0
  return find_skill(name.downcase.gsub('killer','killing'),event,true) if name.downcase.include?('killer') && find_skill(name.downcase.gsub('killer','killing'),event,true)>=0
  return find_skill(name.downcase.gsub('slaying','slayer'),event,true) if name.downcase.include?('slaying') && find_skill(name.downcase.gsub('slaying','slayer'),event,true)>=0
  return find_skill(name.downcase.gsub('slayer','slaying'),event,true) if name.downcase.include?('slayer') && find_skill(name.downcase.gsub('slayer','slaying'),event,true)>=0
  return find_skill(name.downcase.gsub('angery','fury'),event,true) if name.downcase.include?('angery') && find_skill(name.downcase.gsub('angery','fury'),event,true)>=0
  return find_skill(name.downcase.gsub('lnd','lifeanddeath'),event,true) if name.downcase.include?('lnd') && find_skill(name.downcase.gsub('lnd','lifeanddeath'),event,true)>=0
  return find_skill(name.downcase.gsub('l&d','lifeanddeath'),event,true) if name.downcase.include?('lnd') && find_skill(name.downcase.gsub('l&d','lifeanddeath'),event,true)>=0
  return find_skill(name.downcase.gsub('berserker','berserk'),event,true) if name.downcase.include?('berserker') && find_skill(name.downcase.gsub('berserker','berserk'),event,true)>=0
  return find_skill("the#{name.downcase.gsub(' ','')}",event) if find_skill("the#{name.downcase.gsub(' ','')}",event,true)>=0 && @skills[find_skill("the#{name.downcase.gsub(' ','')}",event,true)][0][0,4]=='The '
  return find_skill("a#{name.downcase.gsub(' ','')}",event) if find_skill("a#{name.downcase.gsub(' ','')}",event,true)>=0 && @skills[find_skill("a#{name.downcase.gsub(' ','')}",event,true)][0][0,2]=='A '
  return find_skill("an#{name.downcase.gsub(' ','')}",event) if find_skill("an#{name.downcase.gsub(' ','')}",event,true)>=0 && @skills[find_skill("an#{name.downcase.gsub(' ','')}",event,true)][0][0,3]=='An '
  # ...including non-American spellings of official words
  return find_skill(name.downcase.gsub('defence','defense'),event,true) if name.downcase.include?('defence') && find_skill(name.downcase.gsub('defence','defense'),event,true)>=0
  return find_skill(name.downcase.gsub('armour','armor'),event,true) if name.downcase.include?('armour') && find_skill(name.downcase.gsub('armour','armor'),event,true)>=0
  return find_skill(name.downcase.gsub('honour','honor'),event,true) if name.downcase.include?('honour') && find_skill(name.downcase.gsub('honour','honor'),event,true)>=0
  return -1 if ignore2
  # try everything again, but this time matching the portion of the skill name that is exactly as long as the input string.
  x2=stat_buffs(name.gsub(' ','').gsub('_',''),name,2)
  for i in 0...sklz.length
    unless sklz[i].nil?
      unless sklz[i][0].nil?
        j=i if stat_buffs(sklz[i][0].gsub('.','').gsub('!','').gsub('?',''),name,2).gsub(' ','').gsub('_','')[0,name.length]==x2 && j<0
      end
    end
  end
  return j if j>=0 && !sklz[j].nil? && has_any?(g, sklz[j][13])
  return -1 if name.length<4
  namex=name.gsub(' ','').downcase
  return find_skill('Yato',event) if ['yatogami','yatokami','yatonogami','yatonokami'].map{|q| q[0,namex.length]}.include?(namex)
  return find_skill('Bladeblade',event) if namex=='laevatein'[0,namex.length]
  return find_skill('Eckesachs',event) if ['exaccus','exesack','exsack','eggsacks'].map{|q| q[0,namex.length]}.include?(name.downcase.gsub(' ',''))
  return find_skill("Sack o' Gifts",event) if namex=='sackofgifts'[0,namex.length]
  return find_skill('Giga Excalibur',event) if namex=='gigascalibur'[0,namex.length]
  return find_skill('Gae Bolg',event) if namex=='gayborg'[0,namex.length]
  return find_skill('Loptous',event) if namex=='loptyr'[0,namex.length]
  return find_skill('Thokk',event) if namex=='sekku'[0,namex.length]
  return find_skill('Hlidskjalf',event) if ['hlioskjalf',"roni'sstick",'ronisstick','staffkatz'].map{|q| q[0,namex.length]}.include?(namex)
  return find_skill("Killing Edge",event) if ['killersword','killeredge','killingsword'].map{|q| q[0,namex.length]}.include?(namex)
  return find_skill("Slaying Edge",event) if ['slayersword','slayeredge','slayingsword'].map{|q| q[0,namex.length]}.include?(namex)
  return find_skill(name.downcase.gsub(' ','').gsub('redt','r t'),event) if namex.downcase=='redtome'[0,namex.length]
  return find_skill(name.downcase.gsub(' ','').gsub('bluet','b t'),event) if namex=='bluetome'[0,namex.length]
  return find_skill(name.downcase.gsub(' ','').gsub('greent','g t'),event) if namex=='greentome'[0,namex.length]
  return find_skill(name.downcase.gsub('_',' '),event) if name.include?('_')
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
  p=p.reject{|q| q[0,10]=='Falchion ('}
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

def find_weapon(name,event,ignore=false,ignore2=false) # used by the `get_weapon` function
  sklz=@skills.reject{|q| q[4]!='Weapon'}
  return x_find_skill(name,event,sklz,ignore,ignore2)
end

def get_weapon(str,event) # used by the `stats` command and many derivations to find a weapon's name in the inputs that remain after the unit is decided
  return nil if str.gsub(' ','').length<=0
  skz=@skills.map{|q| q}
  args=str.gsub('(','').gsub(')','').split(' ')
  args=args.reject{|q| q.gsub('*','').gsub('+','').to_i.to_s==q.gsub('*','').gsub('+','') || skz.reject{|q2| ['Weapon','Assist','Special'].include?(q2[4])}.map{|q2| stat_buffs(q2[0]).downcase.gsub(' ','')}.include?(stat_buffs(q,nil,2).downcase) || skz.reject{|q2| ['Weapon','Assist','Special'].include?(q2[4])}.map{|q2| q2[0].gsub('/','').downcase.gsub(' ','')}.include?(q.downcase) || ['+','-'].include?(q[0,1])} if args.length>1
  args2=args.join(' ').split(' ')
  args4=args.join(' ').split(' ')
  name=args.join(' ')
  args3=args.join(' ').split(' ')
  # try full-name matches first...
  if find_weapon(name,event)<0
    for i in 0...args.length-1
      args.pop
      if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event,true)>=0
        args3=args.join(' ').split(' ') 
        name=skz[find_weapon(args.join('').downcase,event,true)][0]
      end
    end
    if find_weapon(name,event)<0
      for j in 0...args2.length-1
        args2.shift
        args=args2.join(' ').split(' ')
        if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event,true)>=0
          args3=args.join(' ').split(' ') 
          name=skz[find_weapon(args.join('').downcase,event,true)][0]
        end
        for i in 0...args.length-1
          args.pop
          if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event,true)>=0
            args3=args.join(' ').split(' ') 
            name=skz[find_weapon(args.join('').downcase,event,true)][0]
          end
        end
      end
    end
  end
  args2=args4.join(' ').split(' ')
  # ...then try partial name matches
  if find_weapon(name,event)<0
    for i in 0...args.length-1
      args.pop
      if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event)>=0
        args3=args.join(' ').split(' ') 
        name=skz[find_weapon(args.join('').downcase,event)][0]
      end
    end
    if find_weapon(name,event)<0
      for j in 0...args2.length-1
        args2.shift
        args=args2.join(' ').split(' ')
        if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event)>=0
          args3=args.join(' ').split(' ') 
          name=skz[find_weapon(args.join('').downcase,event)][0]
        end
        for i in 0...args.length-1
          args.pop
          if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event)>=0
            args3=args.join(' ').split(' ') 
            name=skz[find_weapon(args.join('').downcase,event)][0]
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
  name='Bunnies' if ['bunnies','bunny','spring'].include?(name.downcase)
  name="Valentine's" if ['valentines',"valentine's"].include?(name.downcase)
  name="NewYear's" if ['newyears',"newyear's",'newyear'].include?(name.downcase)
  name='Wedding' if ['brides','grooms','bride','groom','wedding'].include?(name.downcase)
  name='Falchion_Users' if ['falchionusers'].include?(name.downcase.gsub('-','').gsub('_',''))
  name='Dancers&Singers' if ['dancers','singers'].include?(name.downcase)
  name='Legendaries' if ['legendary','legend','legends'].include?(name.downcase)
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
  name='Bunnies' if ['bunnies','bunny','spring'].map{|q| q[0,name.length]}.include?(name.downcase)
  name="Valentine's" if ['valentines',"valentine's"].map{|q| q[0,name.length]}.include?(name.downcase)
  name="NewYear's" if ['newyears',"newyear's",'newyear'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Wedding' if name.length<6 && ['brides','grooms','bride','groom','wedding'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Falchion_Users' if ['falchionusers'].map{|q| q[0,name.gsub('-','').gsub('_','').length]}.include?(name.downcase.gsub('-','').gsub('_',''))
  name='Dancers&Singers' if ['dancers','singers'].map{|q| q[0,name.length]}.include?(name.downcase)
  name='Legendaries' if ['legendary','legend','legends'].map{|q| q[0,name.length]}.include?(name.downcase)
  for i in 0...g.length
    j=i if g[i][0][0,name.length].downcase==name.downcase && (g[i][2].nil? || g[i][2].include?(k))
  end
  return j if j>=0
  return -1
end

def was_embedless_mentioned?(event) # used to detect if someone who wishes to see responses as plaintext is relevent to the information being displayed
  for i in 0...@embedless.length
    return true if event.user.id==@embedless[i]
    return true if event.message.text.include?("<@#{@embedless[i].to_s}>")
    return true if event.message.text.include?("<@!#{@embedless[i].to_s}>")
  end
  return false
end

def create_embed(event,header,text,xcolor=nil,xfooter=nil,xpic=nil,xfields=nil,mode=0) # used by most commands to display embeds or plaintext, based on the results of the above function
  ftrlnth=0
  ftrlnth=xfooter.length unless xfooter.nil?
  ch_id=0
  if event.is_a?(Array)
    ch_id=event[1]
    event=event[0]
  end
  if @embedless.include?(event.user.id) || (was_embedless_mentioned?(event) && ch_id==0)
    str=''
    if header.length>0
      if header.include?('*') || header.include?('_')
        str=header
      else
        str="__**#{header.gsub('!','')}**__"
      end
    end
    unless text.length<=0
      str="#{str}\n" unless text[0,2]=='<:'
      str="#{str}\n#{text}"
      str="#{str}\n" unless [text[text.length-1,1],text[text.length-2,2]].include?("\n")
    end
    unless xfields.nil?
      if mode.zero?
        for i in 0...xfields.length
          k="__#{xfields[i][0]}:__ #{xfields[i][1].gsub("\n",' / ')}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      elsif [-1,1].include?(mode)
        if mode==-1
          last_field=xfields[xfields.length-1][1].split("\n").join("\n")
          last_field_name=xfields[xfields.length-1][0].split("\n").join("\n")
          xfields.pop
        end
        atk=xfields[0][1].split("\n")[1].split(': ')[0]
        statnames=['<:HP_S:467037520538894336> HP: ',"#{atk}: ",'<:SpeedS:467037520534962186> Speed: ','<:DefenseS:467037520249487372> Defense: ','<:ResistanceS:467037520379641858> Resistance: ','BST: ']
        fields=[[],['**<:HP_S:467037520538894336> HP:**'],["**#{atk}:**"],['**<:SpeedS:467037520534962186> Speed:**'],['**<:DefenseS:467037520249487372> Defense:**'],['**<:ResistanceS:467037520379641858> Resistance:**'],['**BST:**']]
        for i in 0...xfields.length
          fields[0].push(xfields[i][0])
          flumb=xfields[i][1].split("\n")
          flumb[5]=nil
          flumb.compact!
          for j in 0...flumb.length
            if i.zero?
              fields[j+1][0]="#{fields[j+1][0]}  #{flumb[j].gsub(statnames[j],'').gsub('GPT: ','')}"
            else
              fields[j+1].push(flumb[j].gsub(statnames[j],'').gsub('GPT: ',''))
            end
          end
        end
        str="#{str}\n"
        for i in 0...fields.length
          k=fields[i].join(' / ')
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
        if mode==-1
          k="\n__**#{last_field_name.gsub('**','')}**__\n#{last_field}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      elsif mode==-2
        last_field=xfields[xfields.length-1][1].split("\n").join("\n")
        last_field_name=xfields[xfields.length-1][0].split("\n").join("\n")
        emo=last_field.split("\n")[1].split(' ')[0]
        xfields.pop
        atk=xfields[0][1].split("\n")[2].split(': ')[0]
        statnames=['HP: ',"#{atk}: ",'Speed: ','Defense: ','Resistance: ','BST: ']
        fields=[[],['**<:HP_S:467037520538894336> HP:**'],["**#{emo} #{atk}:**"],['**<:SpeedS:467037520534962186> Speed:**'],['**<:DefenseS:467037520249487372> Defense:**'],['**<:ResistanceS:467037520379641858> Resistance:**'],['**BST:**']]
        for i in 0...xfields.length
          fields[0].push(xfields[i][0])
          flumb=xfields[i][1].split("\n")
          flumb.shift
          flumb[5]=nil
          flumb.compact!
          for j in 0...flumb.length
            if i.zero?
              fields[j+1][0]="#{fields[j+1][0]}  #{flumb[j].gsub(statnames[j],'').gsub('GPT: ','')}"
            else
              fields[j+1].push(flumb[j].gsub(statnames[j],'').gsub('GPT: ',''))
            end
          end
        end
        str="#{str}\n"
        for i in 0...fields.length
          k=fields[i].join(' / ')
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
        str="#{str}\n"
        k="__**#{last_field_name.gsub('**','')}**__\n#{last_field}"
        if str.length+k.length>=1900
          if ch_id==1
            event.user.pm(str)
          else
            event.channel.send_message(str)
          end
          str=k
        else
          str="#{str}\n#{k}"
        end
      elsif mode==3
        for i in 0...xfields.length
          k="__#{xfields[i][0]}:__ #{xfields[i][1].gsub("\n",', ')}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      elsif mode==4
        for i in 0...xfields.length
          k="**#{xfields[i][0]}:** #{xfields[i][1].gsub("\n",', ')}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      elsif mode==5
        for i in 0...xfields.length-1
          k="**#{xfields[i][0]}:** #{xfields[i][1].gsub("\n",' / ')}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
        i=xfields.length-1
        str="#{str}\n**#{xfields[i][0]}:**"
        m=xfields[i][1].split("\n\n").map{|q| q.split("\n")}
        for i in 0...m.length
          if m[i].length<=1
            k="*#{m[i][0]}*"
          else
            k="*#{m[i][0]}*: #{m[i][1,m[i].length-1].join(' / ')}"
          end
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      else
        for i in 0...xfields.length
          k="\n#{xfields[i][0]}\n#{xfields[i][1]}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      end
    end
    k=''
    k="\n#{xfooter}" unless xfooter.nil?
    if str.length+k.length>=1900
      if ch_id==1
        event.user.pm(str)
        event.user.pm(k)
      else
        event.channel.send_message(str)
        event.channel.send_message(k)
      end
    elsif ch_id==1
      event.user.pm("#{str}\n#{k}")
    else
      event.channel.send_message("#{str}\n#{k}")
    end
  elsif !xfields.nil? && ftrlnth+header.length+text.length+xfields.map{|q| "#{q[0]}\n\n#{q[1]}"}.length>=1950 && ch_id==1
    event.user.pm.send_embed(header) do |embed|
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
    end
    event.user.pm.send_embed('') do |embed|
      embed.description=''
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil?
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0].gsub('**',''), value: xfields[i][1], inline: xfields[i][2].nil?)
        end
      end
    end
  elsif !xfields.nil? && ftrlnth+header.length+text.length+xfields.map{|q| "#{q[0]}\n\n#{q[1]}"}.length>=1950
    event.channel.send_embed(header) do |embed|
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
    end
    event.channel.send_embed('') do |embed|
      embed.description=''
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil?
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0].gsub('**',''), value: xfields[i][1], inline: xfields[i][2].nil?)
        end
      end
    end
  elsif ch_id==1
    event.user.pm.send_embed(header) do |embed|
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0].gsub('**',''), value: xfields[i][1], inline: xfields[i][2].nil?)
        end
      end
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil?
    end
  else
    event.channel.send_embed(header) do |embed|
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0].gsub('**',''), value: xfields[i][1], inline: xfields[i][2].nil?)
        end
      end
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil?
    end
  end
  return nil
end

def reshape_unit_into_multi(name,args3) # used by the find_unit_in_string function to switch a unit match into a relevant multi-unit
  if name.include?('(M)') || name.include?('(F)')
    if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
      if ['robin','reflet','daraen'].include?(args3[0].downcase)
        name='Robin'
      elsif ['morgan','marc','linfan'].include?(args3[0].downcase)
        name='Morgan'
      elsif ['kana','kanna'].include?(args3[0].downcase)
        name='Kana'
      else
        name=args3[0]
      end
    end
  elsif name=='Tiki(Young)' || name=='Tiki(Adult)'
    if args3.length==1
      if ['tiki','chiki'].include?(args3[0].downcase)
        name='Tiki'
      else
        name=args3[0]
      end
    end
  elsif name=='Tiki(Young)(Summer)' || name=='Tiki(Adult)(Summer)'
    if args3.reject{|q| ['summer','beach','swimsuit'].include?(q.downcase)}.length==1
      if ['tiki','chiki'].include?(args3[0].downcase)
        name='TikiSummer'
      else
        name=args3[0]
      end
    end
  elsif name=='Eirika(Bonds)' || name=='Eirika(Memories)'
    if args3.length==1
      if ['eirika','eirik','eiriku','erika'].include?(args3[0].downcase)
        name='Eirika'
      else
        name=args3[0]
      end
    end
  elsif name=='Olivia(Launch)' || name=='Olivia(Traveler)'
    if args3.length==1
      if ['olivia','olivie','olive'].include?(args3[0].downcase)
        name='Olivia'
      else
        name=args3[0]
      end
    end
  elsif name=='Hinoka(Launch)' || name=='Hinoka(Wings)'
    if args3.length==1
      if ['hinoka'].include?(args3[0].downcase)
        name='Hinoka'
      else
        name=args3[0]
      end
    end
  elsif name=='Nino(Launch)' || name=='Nino(Fangs)'
    if args3.length==1
      if ['nino'].include?(args3[0].downcase)
        name='nino'
      else
        name=args3[0]
      end
    end
  elsif name=='Chrom(Launch)' || name=='Chrom(Branded)'
    if args3.length==1
      if ['chrom'].include?(args3[0].downcase)
        name='Chrom'
      else
        name=args3[0]
      end
    end
  elsif name=='Reinhardt(Bonds)' || name=='Reinhardt(World)'
    if args3.length==1
      if ['reinhardt','rainharuto'].include?(args3[0].downcase)
        name='Reinhardt'
      else
        name=args3[0]
      end
    end
  elsif name=='Olwen(Bonds)' || name=='Olwen(World)'
    if args3.length==1
      if ['olwen','oruen'].include?(args3[0].downcase)
        name='Olwen'
      else
        name=args3[0]
      end
    end
  end
  return name
end

def find_name_in_string(event,stringx=nil,mode=0) # used to find not only a unit based on the input string, but also the portion of said input string that matched the unit - name, alias, multi-unit alias, etc.
  data_load()
  stringx=event.message.text if stringx.nil?
  s=stringx
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(stringx.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(stringx.downcase[0,4])
  a=s.gsub('.','').split(' ')
  s=stringx if all_commands().include?(a[0])
  args=sever(s,true).split(' ')
  args2=sever(s,true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.reject{ |a| ['+','-'].include?(a[0,1]) &&  ['hp','attack','speed','defense','resistance','atk','att','spd','def','defence','res','health','strength','str','magic','mag'].include?(a[1,a.length-1].downcase)}
  args=args.reject{ |a| ['hp','attack','speed','defense','resistance','atk','att','spd','def','defence','res','health','strength','str','magic','mag'].include?(a.downcase)}
  args=args.reject{ |a| a[0,1]=='+' && a[1,a.length-1].to_i.to_s==a[1,a.length-1] }
  args=args.reject{ |a| a[0,a.length-1].to_i.to_s==a[0,a.length-1] && a[a.length-1,1]=='*'}
  args=args.reject{ |a| a.to_i.to_s==a}
  args=args.reject{ |a| find_skill(a,event,true)>-1 }
  args.compact!
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(stringx.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(stringx.downcase[0,4])
  a=s.split(' ')
  args.shift if all_commands().include?(a[0])
  args2=args.join(' ').split(' ')
  args4=args.join(' ').split(' ')
  name=args.join('')
  data_load()
  # Find the most accurate unit name among the remaining inputs
  if find_unit(name,event)>=0
    args3=args.join(' ').split(' ')
    name=@units[find_unit(name,event)][0]
    name=reshape_unit_into_multi(name,args3)
  else
    for i in 0...args.length-1
      args.pop
      if find_unit(name,event)<0 && find_unit(args.join('').downcase,event,true)>=0
        args3=args.join(' ').split(' ') 
        name=@units[find_unit(args.join('').downcase,event,true)][0]
      end
    end
    if find_unit(name,event)<0
      for j in 0...args2.length-1
        args2.shift
        args=args2.join(' ').split(' ')
        if find_unit(name,event)<0 && find_unit(args.join('').downcase,event,true)>=0
          args3=args.join(' ').split(' ') 
          name=@units[find_unit(args.join('').downcase,event,true)][0]
        end
        for i in 0...args.length-1
          args.pop
          if find_unit(name,event)<0 && find_unit(args.join('').downcase,event,true)>=0
            args3=args.join(' ').split(' ') 
            name=@units[find_unit(args.join('').downcase,event,true)][0]
          end
        end
      end
    end
    name=reshape_unit_into_multi(name,args3)
  end
  args2=args4.join(' ').split(' ')
  if find_unit(name,event)<0
    for i in 0...args.length-1
      args.pop
      if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
        args3=args.join(' ').split(' ') 
        name=@units[find_unit(args.join('').downcase,event)][0]
      end
    end
    if find_unit(name,event)<0
      for j in 0...args2.length-1
        args2.shift
        args=args2.join(' ').split(' ')
        if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
          args3=args.join(' ').split(' ') 
          name=@units[find_unit(args.join('').downcase,event)][0]
        end
        for i in 0...args.length-1
          args.pop
          if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
            args3=args.join(' ').split(' ') 
            name=@units[find_unit(args.join('').downcase,event)][0]
          end
        end
      end
    end
    name=reshape_unit_into_multi(name,args3)
  end
  return nil if args3.nil?
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
    x='Effect' if ['effect','special'].include?(x.downcase)
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
  args=sever(s,true).gsub('.','').split(' ')
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
      if args[i].gsub('(','').gsub(')','').downcase=='s'
        summoner='S' if summoner.nil?
      elsif args[i].gsub('(','').gsub(')','').downcase=='a'
        summoner='A' if summoner.nil?
      elsif args[i].gsub('(','').gsub(')','').downcase=='b'
        summoner='B' if summoner.nil?
      elsif args[i].gsub('(','').gsub(')','').downcase=='c'
        summoner='C' if summoner.nil?
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
      elsif args[i].length>8 && (args[i].gsub('(','').gsub(')','')[0,8].downcase=='blessing' || args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-8,8].downcase=='blessing')
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing',''))
        if ['Attack','Speed','Defense','Resistance'].include?(x)
          blessing.push(x)
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
          blessing.push(x)
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
        refinement='Effect' if ['effect','special'].include?(args[i].gsub('(','').gsub(')','').downcase) && refinement.nil?
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
  return [rarity,merges,boon,bane,summoner,refinement,blessing]
end

def apply_stat_skills(event,skillls,stats,tempest='',summoner='-',weapon='',refinement='',blessing=[],ignoremax=false) # used to add skill stat increases to a unit's stats
  skillls=skillls.map{|q| q}
  if weapon.nil? || weapon=='' || weapon==' ' || weapon=='-'
  else # this is the weapon's stat effect
    s2=@skills[find_skill(weapon,event)]
    if !s2.nil? && !s2[15].nil? && !refinement.nil? && refinement.length>0 && (s2[5]!='Staff Users Only' || refinement=='Effect')
      # weapon refinement...
      skillls.push(find_effect_name(s2,event,1)) if refinement=='Effect' && find_effect_name(s2,event,1).length>0 # ...including any stat-based Effect Modes
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
    s2[12]=[0,0,0,0,0] if s2[12].nil?
    stats[1]+=sttz[ks][0]
    stats[2]+=s2[12][1]+sttz[ks][1]
    stats[3]+=s2[12][2]+sttz[ks][2]
    stats[4]+=s2[12][3]+sttz[ks][3]
    stats[5]+=s2[12][4]+sttz[ks][4]
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
    if blessing[i]=='Attack'
      stats[2]+=2
    elsif blessing[i]=='Speed'
      stats[3]+=3
    elsif blessing[i]=='Defense'
      stats[4]+=4
    elsif blessing[i]=='Resistance'
      stats[5]+=4
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

def count_in(arr,str) # used to count the number of times a skill is mentioned
  if str.is_a?(Array)
    return arr.count{|x| str.map{|y| y.downcase}.include?(x.downcase)}
  elsif arr.is_a?(String)
    return arr.chars.count{|x| x.downcase==str.downcase}
  end
  return arr.count{|x| x.downcase==str.downcase}
end

def make_stat_skill_list_1(name,event,args) # this is for yellow-stat skills
  args=sever(event.message.text,true).split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.downcase.gsub('(','').gsub(')','')}
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
  end
  return stat_skills
end

def make_stat_skill_list_2(name,event,args) # this is for blue- and red- stat skills.  Character name is needed to know which movement Hone/Fortify to apply
  args=sever(event.message.text,true).split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.gsub('(','').gsub(')','').downcase}
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
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil? || (lookout[skl][5] && @units[j][1][1]!='Dragon')
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
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil? || (lookout[skl][5] && @units[j][1][1]!='Dragon')
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
  return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{d[0]}/Face_FC.png"
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
    xcolor=0xF2463A if jj[2][0]=='Fire'
    xcolor=0x66DAFA if jj[2][0]=='Water'
    xcolor=0x7AE970 if jj[2][0]=='Wind'
    xcolor=0xDE5F09 if jj[2][0]=='Earth'
    xcolor=0x5000A0 if jj[2][0]=='Dark'
  end
  # Special colors
  xcolor=0xFFABAF if jj[0]=='Sakura' && m
  xcolor=0x9400D3 if jj[0]=='Kiran'
  xcolor=avg_color([[39,100,222],[9,170,36]]) if name=='Robin' || name=='Robin (Shared stats)'
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
  wpn='Unknown'
  wpn=jj[1][1].gsub('Healer','Staff') if ['Blade','Tome','Dragon','Beast','Bow','Dagger','Healer'].include?(jj[1][1])
  wemote=''
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clr}_#{wpn}"}
  wemote=moji[0].mention unless moji.length<=0
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
    element=jj[2][0] if ['Fire','Water','Wind','Earth','Dark'].include?(jj[2][0])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
    lemote1=moji[0].mention unless moji.length<=0
    stat='Spectrum'
    stat=jj[2][1] if ['Attack','Speed','Defense','Resistance'].include?(jj[2][1])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{stat}"}
    lemote2=moji[0].mention unless moji.length<=0
  end
  return "#{wemote} #{w}\n#{memote} *#{m}*#{dancer}#{"\n#{lemote1}*#{jj[2][0]}*/#{lemote2}*#{jj[2][1]}* Legendary Hero" unless jj[2][0]==" "}"
end

def unit_moji(bot,event,j=-1,name=nil,m=false,mode=0) # used primarilally by the BST and Alt commands to display a unit's weapon and movement classes as emojis
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
  wpn='Unknown'
  wpn=jj[1][1].gsub('Healer','Staff') if ['Blade','Tome','Dragon','Beast','Bow','Dagger','Healer'].include?(jj[1][1])
  wemote=''
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clr}_#{wpn}"}
  wemote=moji[0].mention unless moji.length<=0
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
    element=jj[2][0] if ['Fire','Water','Wind','Earth','Dark'].include?(jj[2][0])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
    lemote1=moji[0].mention unless moji.length<=0
    stat='Spectrum'
    stat=jj[2][1] if ['Attack','Speed','Defense','Resistance'].include?(jj[2][1])
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{stat}"}
    lemote2=moji[0].mention unless moji.length<=0
  end
  return "#{wemote}#{memote}#{dancer}#{lemote1}#{lemote2}#{'<:Icon_Support:448293527642701824>' if jj[0]=='Sakura' && m}"
end

def skill_tier(name,event) # used by the "used a non-plus version of a weapon that has a + form" tooltip in the stats command to figure out the tier of the weapon
  data_load()
  s=@skills.map{|q| q}
  j=s[s.find_index{|q| q[0]==name}]
  return 1 if j[8]=='-'
  return 1+skill_tier(j[8].gsub('*','').split(' or ')[0],event) if j[8].include?(' or ')
  return 1+skill_tier(j[8].gsub('*','').split(', ')[0],event) if j[8].include?(', ')
  return 1+skill_tier(j[8].gsub('*',''),event)
end

def get_bonus_type(event) # used to determine if the embed header should say Tempest or Arena bonus unit
  if event.message.text.downcase.split(' ').include?('bonus')
    if event.message.text.downcase.split(' ').include?('tempest') && !event.message.text.downcase.split(' ').include?('arena')
      return 'Tempest'
    elsif event.message.text.downcase.split(' ').include?('arena') && !event.message.text.downcase.split(' ').include?('tempest')
      return 'Arena'
    else
      return 'Tempest/Arena'
    end
  elsif event.message.text.downcase.split(' ').include?('tempest') && event.message.text.downcase.split(' ').include?('arena')
    return 'Tempest/Arena'
  elsif event.message.text.downcase.split(' ').include?('tempest')
    return 'Tempest'
  elsif event.message.text.downcase.split(' ').include?('arena')
    return 'Arena'
  end
  return ''
end

def display_stat_skills(j,stat_skills=nil,stat_skills_2=nil,stat_skills_3=nil,tempest='',blessing=nil,weapon='-',expandedmode=false) # used by the stats command and any derivatives to display which skills are affecting the stats being displayed
  blessing=[] if blessing.nil?
  stat_skills=[] if stat_skills.nil?
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
  return "#{str}Equipped weapon: #{weapon}\n"
end

def display_stars(rarity,merges,support='-',expandedmode=false) # used to determine which star emojis should be used, based on the rarity, merge count, and whether the unit is Summoner Supported
  emo=@rarity_stars[rarity-1]
  if merges==@max_rarity_merge[1]
    emo='<:Icon_Rarity_4p10:448272714210476033>' if rarity==4
    emo='<:Icon_Rarity_5p10:448272715099406336>' if rarity==5
  end
  emo='<:Icon_Rarity_S:448266418035621888>' unless support=='-'
  emo='<:Icon_Rarity_Sp10:448272715653054485>' if rarity==5 && merges==@max_rarity_merge[1] && support != '-'
  return "**#{rarity}-star#{" +#{merges}" unless merges.zero? && !expandedmode}**#{"  \u00B7  <:Icon_Support:448293527642701824>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}" if rarity>@rarity_stars.length-1
  return "#{emo*rarity}#{"**+#{merges}**" unless merges.zero? && !expandedmode}#{"  \u00B7  <:Icon_Support:448293527642701824>**#{support}**" unless support =='-'}#{"\nNo Summoner Support" if support =='-' && expandedmode}"
end

def micronumber(n)
  m=["\u2080","\u2081","\u2082","\u2083","\u2084","\u2085","\u2086","\u2087","\u2088","\u2089"]
  return "\uFE63#{micronumber(0-n)}" if n<0
  return "#{micronumber(n/10)}#{m[n%10]}" if n>9
  return m[n]
end

def disp_stats(bot,name,weapon,event,ignore=false,skillstoo=false,expandedmode=nil) # displays stats
  expandedmode=false if expandedmode.nil?
  if " #{event.message.text.downcase} ".include?(' tiny ') || " #{event.message.text.downcase} ".include?(' small ') || " #{event.message.text.downcase} ".include?(' smol ') || " #{event.message.text.downcase} ".include?(' micro ') || " #{event.message.text.downcase} ".include?(' little ')
    disp_tiny_stats(bot,name,weapon,event,ignore)
    return nil
  elsif " #{event.message.text.downcase} ".include?(' giant ') || " #{event.message.text.downcase} ".include?(' big ') || " #{event.message.text.downcase} ".include?(' tol ') || " #{event.message.text.downcase} ".include?(' macro ') || " #{event.message.text.downcase} ".include?(' large ') || " #{event.message.text.downcase} ".include?(' huge ') || " #{event.message.text.downcase} ".include?(' massive ')
    expandedmode=true
  end
  if expandedmode && !safe_to_spam?(event)
    event.respond "I will not wipe the chat completely clean.  Please use this command in PM.\nIn the meantime, I will show the standard form of this command."
    expandedmode=false
  end
  if name.is_a?(Array)
    g=get_markers(event)
    u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
    name=name.reject{|q| !u.include?(q) && 'Robin'!=q}
    for i in 0...name.length
      disp_stats(bot,name[i],weapon,event,ignore,skillstoo,expandedmode)
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
  unless ignore || (!name.nil? && name != '')
    args2=args.join(' ').split(' ')
    name=args.join('')
    data_load()
    # Find the most accurate unit name among the remaining inputs
    if find_unit(name,event)<0
      for i in 0...args.length-1
        args.pop
        name=untz[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
      end
      if find_unit(name,event)<0
        for j in 0...args2.length-1
          args2.shift
          args=args2.join(' ').split(' ')
          name=untz[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
          for i in 0...args.length-1
            args.pop
            name=untz[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
          end
        end
      end
    end
  end
  flurp=find_stats_in_string(event,nil,0,name)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  blessing=[] if name != 'Robin' && untz[untz.find_index{|q| q[0]==name}][2][0].length>1
  blessing.compact!
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  tempest=get_bonus_type(event)
  diff_num=[0,'','']
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
      weapon=uskl[uskl.length-1] if uskl.length>0
    end
    summoner='-'
    tempest=''
    stat_skills=[]
    stat_skills_2=[]
    refinement=nil
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
  refinement=nil if w2[5]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[5]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  unitz=untz[find_unit(name,event)]
  spec_wpn=false
  if name=='Robin'
    if " #{event.message.text.downcase} ".include?(' summoned ') || args.map{|q| q.downcase}.include?('summoned')
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
  unless spec_wpn
    wl=weapon_legality(event,unitz[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  if find_unit(name,event)<0
    event.respond 'No unit was included' unless ignore
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
    flds=[["**Level 1#{" +#{merges}" if merges>0}**","<:HP_S:467037520538894336> HP: 0\n<:StrengthS:467037520484630539> Attack: 0\n<:SpeedS:467037520534962186> Speed: 0\n<:DefenseS:467037520249487372> Defense: 0\n<:ResistanceS:467037520379641858> Resistance: 0\n\nBST: 0"],["**Level 40#{" +#{merges}" if merges>0}**","<:HP_S:467037520538894336> HP: 0\n<:StrengthS:467037520484630539> Attack: 0\n<:SpeedS:467037520534962186> Speed: 0\n<:DefenseS:467037520249487372> Defense: 0\n<:ResistanceS:467037520379641858> Resistance: 0\n\nBST: 0"]]
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
    create_embed(event,"__**#{untz[j][0].gsub('Lavatain','Laevatein')}**__","#{display_stars(rarity,merges,'-',expandedmode)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{unit_clss(bot,event,j)}\n",0x9400D3,"Please note that the Attack stat displayed here does not include weapon might.  The Attack stat in-game does.",pick_thumbnail(event,j,bot),flds,1)
    return nil
  elsif unitz[4].nil? || (unitz[4].max.zero? && unitz[5].max.zero?) # unknown stats
    data_load()
    j=find_unit(name,event)
    xcolor=unit_color(event,j,untz[j][0],0,mu)
    create_embed(event,"__**#{untz[j][0].gsub('Lavatain','Laevatein')}**__","#{unit_clss(bot,event,j)}",xcolor,'Stats currently unknown',pick_thumbnail(event,j,bot))
    disp_unit_skills(bot,untz[j][0],event) if skillstoo || Expandedmode
    return nil
  elsif unitz[4].max.zero? # level 40 stats are known but not level 1
    data_load()
    merges=0 if merges.nil?
    j=find_unit(name,event)
    xcolor=unit_color(event,j,untz[j][0],0,mu)
    atk='<:StrengthS:467037520484630539> Attack'
    atk='<:MagicS:467043867611627520> Magic' if ['Tome','Dragon','Healer'].include?(untz[j][1][1])
    atk='<:StrengthS:467037520484630539> Strength' if ['Blade','Bow','Dagger'].include?(untz[j][1][1])
    zzzl=@skills[find_weapon(weapon,event)]
    if zzzl[11].split(', ').include?('Frostbite') || (zzzl[11].split(', ').include?('(R)Frostbite') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)Frostbite') && refinement=='Effect')
      atk='<:FreezeS:467043868148236299> Freeze'
    end
    n=nature_name(boon,bane)
    unless n.nil?
      n=n[0] if atk=='<:StrengthS:467037520484630539> Strength'
      n=n[n.length-1] if atk=='<:MagicS:467043867611627520> Magic'
      n=n.join(' / ') if ['<:StrengthS:467037520484630539> Attack','<:FreezeS:467043868148236299> Freeze'].include?(atk)
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
    u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
    cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing)
    blu40=u40.map{|a| a}
    crblu40=cru40.map{|a| a}
    blu40=apply_stat_skills(event,stat_skills_2,blu40)
    crblu40=apply_stat_skills(event,stat_skills_2,crblu40)
    u40=make_stat_string_list(u40,blu40)
    cru40=make_stat_string_list(cru40,crblu40)
    u40=make_stat_string_list(u40,cru40,2) if wl.include?('~~')
    ftr="Please note that the #{atk.split('> ')[1]} stat displayed here does not include weapon might.  The Attack stat in-game does."
    ftr=nil if weapon != '-'
    flds=[["**Level 1#{" +#{merges}" if merges>0}**","<:HP_S:467037520538894336> HP: unknown\n#{atk}: unknown\n<:SpeedS:467037520534962186> Speed: unknown\n<:DefenseS:467037520249487372> Defense: unknown\n<:ResistanceS:467037520379641858> Resistance: unknown\n\nBST: unknown"],["**Level 40#{" +#{merges}" if merges>0}**","<:HP_S:467037520538894336> HP: #{u40[1]}\n#{atk}: #{u40[2]}#{"(#{diff_num[1]}) / #{u40[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}\n<:SpeedS:467037520534962186> Speed: #{u40[3]}\n<:DefenseS:467037520249487372> Defense: #{u40[4]}\n<:ResistanceS:467037520379641858> Resistance: #{u40[5]}\n\nBST: #{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]}#{"(#{diff_num[1]}) / #{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}"]]
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
      flds.push(["<:Skill_Weapon:444078171114045450> **Weapons**",uskl[0].reject{|q| ['Falchion','**Falchion**'].include?(q)}.join("\n")])
      flds.push(["<:Skill_Assist:444078171025965066> **Assists**",uskl[1].join("\n")])
      flds.push(["<:Skill_Special:444078170665254929> **Specials**",uskl[2].join("\n")])
      flds.push(["<:Passive_A:443677024192823327> **A Passives**",uskl[3].join("\n")])
      flds.push(["<:Passive_B:443677023257493506> **B Passives**",uskl[4].join("\n")])
      flds.push(["<:Passive_C:443677023555026954> **C Passives**",uskl[5].join("\n")])
      flds.push(["<:Passive_S:443677023626330122> **Sacred Seal**",uskl[6].join("\n")]) if uskl.length>6
    end
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{"<:Icon_Rarity_5:448266417553539104>"*5}#{"**+#{merges}**" if merges>0 || expandedmode}#{"  \u2764 **#{summoner}**" unless summoner=='-'}#{"\nNo Summoner Support" if summoner =='-' && expandedmode}\n*Neutral Nature only so far*\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl,expandedmode)}\n#{unit_clss(bot,event,j)}",xcolor,ftr,pick_thumbnail(event,j,bot),flds,1)
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
  u1=get_stats(event,name,1,rarity,merges,boon,bane)
  j=find_unit(name,event)
  atk='<:StrengthS:467037520484630539> Attack'
  atk='<:MagicS:467043867611627520> Magic' if ['Tome','Dragon','Healer'].include?(untz[j][1][1])
  atk='<:StrengthS:467037520484630539> Strength' if ['Blade','Bow','Dagger'].include?(untz[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  if zzzl[11].split(', ').include?('Frostbite') || (zzzl[11].split(', ').include?('(R)Frostbite') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)Frostbite') && refinement=='Effect')
    atk='<:FreezeS:467043868148236299> Freeze'
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='<:StrengthS:467037520484630539> Strength'
    n=n[n.length-1] if atk=='<:MagicS:467043867611627520> Magic'
    n=n.join(' / ') if ['<:StrengthS:467037520484630539> Attack','<:FreezeS:467043868148236299> Freeze'].include?(atk)
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
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing)
  blu40=u40.map{|a| a}
  crblu40=cru40.map{|a| a}
  blu40=apply_stat_skills(event,stat_skills_2,blu40) if stat_skills_2.length>0
  crblu40=apply_stat_skills(event,stat_skills_2,crblu40) if stat_skills_2.length>0
  u40=make_stat_string_list(u40,blu40)
  cru40=make_stat_string_list(cru40,crblu40)
  u40=make_stat_string_list(u40,cru40,2) if wl.include?('~~')
  cru1=u1.map{|a| a}
  u1=apply_stat_skills(event,stat_skills,u1,tempest,summoner,weapon,refinement,blessing)
  cru1=apply_stat_skills(event,stat_skills,cru1,tempest,summoner,'-','',blessing)
  blu1=u1.map{|a| a}
  crblu1=cru1.map{|a| a}
  blu1=apply_stat_skills(event,stat_skills_2,blu1) if stat_skills_2.length>0
  crblu1=apply_stat_skills(event,stat_skills_2,crblu1) if stat_skills_2.length>0
  u1=make_stat_string_list(u1,blu1)
  cru1=make_stat_string_list(cru1,crblu1)
  u1=make_stat_string_list(u1,cru1,2) if wl.include?('~~')
  ftr="Please note that the #{atk.split('> ')[1]} stat displayed here does not include weapon might.  The Attack stat in-game does."
  if weapon != '-'
    ftr=nil
    tr=skill_tier(weapon,event)
    ftr="You equipped the Tier #{tr} version of the weapon.  Perhaps you want #{wl.gsub('~~','').split(' (+) ')[0]}+ ?" unless weapon[weapon.length-1,1]=='+' || !find_promotions(find_weapon(weapon,event),event).uniq.reject{|q| @skills[find_skill(q,event,true,true)][4]!="Weapon"}.include?("#{weapon}+") || " #{event.message.text.downcase} ".include?(' summoned ') || " #{event.message.text.downcase} ".include?(" mathoo's ")
  end
  flds=[["**Level 1#{" +#{merges}" if merges>0}**",["<:HP_S:467037520538894336> HP: #{u1[1]}","#{atk}: #{u1[2]}#{"(#{diff_num[1]}) / #{u1[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}","<:SpeedS:467037520534962186> Speed: #{u1[3]}","<:DefenseS:467037520249487372> Defense: #{u1[4]}","<:ResistanceS:467037520379641858> Resistance: #{u1[5]}","","BST: #{u1[6]}"]]]
  if args.map{|q| q.downcase}.include?('gps') || args.map{|q| q.downcase}.include?('gp') || args.map{|q| q.downcase}.include?('growths') || args.map{|q| q.downcase}.include?('growth') || expandedmode
    flds.push(["**Growth Rates**",["<:HP_S:467037520538894336> HP: #{micronumber(u40[6])} / #{u40[6]*5+20}%","#{atk}: #{micronumber(u40[7])} / #{u40[7]*5+20}%","<:SpeedS:467037520534962186> Speed: #{micronumber(u40[8])} / #{u40[8]*5+20}%","<:DefenseS:467037520249487372> Defense: #{micronumber(u40[9])} / #{u40[9]*5+20}%","<:ResistanceS:467037520379641858> Resistance: #{micronumber(u40[10])} / #{u40[10]*5+20}%","","\u0262\u1D18\u1D1B #{micronumber(u40[6]+u40[7]+u40[8]+u40[9]+u40[10])} / GRT: #{(u40[6]+u40[7]+u40[8]+u40[9]+u40[10])*5+100}%"]])
  end
  flds.push(["**Level 40#{" +#{merges}" if merges>0}**",["<:HP_S:467037520538894336> HP: #{u40[1]}","#{atk}: #{u40[2]}#{"(#{diff_num[1]}) / #{u40[2]-diff_num[0]}(#{diff_num[2]})" unless diff_num[0]<=0}","<:SpeedS:467037520534962186> Speed: #{u40[3]}","<:DefenseS:467037520249487372> Defense: #{u40[4]}","<:ResistanceS:467037520379641858> Resistance: #{u40[5]}","","BST: #{u40[16]}"]])
  superbaan=['','','','','','']
  if boon=="" && bane=="" && !mu && ((stat_skills_2.length<=0 && !wl.include?('~~')) || flds.length==3)
    for i in 6...11
      superbaan[i-5]='(+)' if [-3,1,5,10,14].include?(u40[i]) && rarity==5
      superbaan[i-5]='(-)' if [-2,2,6,11,15].include?(u40[i]) && rarity==5
      superbaan[i-5]='(+)' if [-2,10].include?(u40[i]) && rarity==4
      superbaan[i-5]='(-)' if [-1,11].include?(u40[i]) && rarity==4
    end
    if superbaan.include?('(+)') || superbaan.include?('(-)')
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
    end
  end
  for i in 0...5
    flds[1][1][i]="#{flds[1][1][i]} #{superbaan[i+1]}"
  end
  for i in 0...flds.length
    flds[i][1]=flds[i][1].join("\n")
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
    end
    flds.push(["<:Skill_Weapon:444078171114045450> **Weapons**",uskl[0].reject{|q| ['Falchion','**Falchion**'].include?(q)}.join("\n")])
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
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(rarity,merges,summoner,expandedmode)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl,expandedmode)}\n#{unit_clss(bot,event,j,u40[0])}",xcolor,ftr,img,flds,xtype)
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

def disp_tiny_stats(bot,name,weapon,event,ignore=false) # displays stats
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
  weapon='-'
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
  unless ignore || (!name.nil? && name != '')
    args2=args.join(' ').split(' ')
    name=args.join('')
    data_load()
    # Find the most accurate unit name among the remaining inputs
    if find_unit(name,event)<0
      for i in 0...args.length-1
        args.pop
        name=untz[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
      end
      if find_unit(name,event)<0
        for j in 0...args2.length-1
          args2.shift
          args=args2.join(' ').split(' ')
          name=untz[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
          for i in 0...args.length-1
            args.pop
            name=untz[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
          end
        end
      end
    end
  end
  flurp=find_stats_in_string(event,nil,0,name)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  mu=false
  tempest=get_bonus_type(event)
  diff_num=[0,'','']
  summoner='-'
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
      end
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
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
      weapon=uskl[uskl.length-1] if uskl.length>0
    end
  end
  w2=@skills[find_skill(weapon,event)]
  unitz=untz[find_unit(name,event)]
  spec_wpn=false
  if name=='Robin'
    if " #{event.message.text.downcase} ".include?(' summoned ') || args.map{|q| q.downcase}.include?('summoned')
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
  unless spec_wpn
    wl=weapon_legality(event,unitz[0],weapon,nil)
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
    create_embed(event,"__**#{untz[j][0].gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,j,u40[0],mu,2)}**__","#{display_stars(rarity,merges)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{unit_clss(bot,event,j)}\n**<:HP_S:467037520538894336>0 | <:StrengthS:467037520484630539>0 | <:SpeedS:467037520534962186>0 | <:DefenseS:467037520249487372>0 | <:ResistanceS:467037520379641858>0**",0x9400D3,nil,pick_thumbnail(event,j,bot),nil,1)
    return nil
  elsif unitz[4].nil? || (unitz[4].max.zero? && unitz[5].max.zero?) # unknown stats
    data_load()
    j=find_unit(name,event)
    xcolor=unit_color(event,j,untz[j][0],0,mu)
    create_embed(event,"__**#{untz[j][0].gsub('Lavatain','Laevatein')}**__","#{unit_clss(bot,event,j)}",xcolor,'Stats currently unknown',pick_thumbnail(event,j,bot))
    return nil
  elsif unitz[4].max.zero? # level 40 stats are known but not level 1
    data_load()
    merges=0 if merges.nil?
    j=find_unit(name,event)
    xcolor=unit_color(event,j,untz[j][0],0,mu)
    atk='<:StrengthS:467037520484630539>*'
    atk='<:MagicS:467043867611627520>' if ['Tome','Dragon','Healer'].include?(untz[j][1][1])
    atk='<:StrengthS:467037520484630539>' if ['Blade','Bow','Dagger'].include?(untz[j][1][1])
    zzzl=@skills[find_weapon(weapon,event)]
    if zzzl[11].split(', ').include?('Frostbite')
      atk='<:FreezeS:467043868148236299>'
    end
    n=nature_name(boon,bane)
    unless n.nil?
      n=n[0] if atk=='<:StrengthS:467037520484630539>'
      n=n[n.length-1] if atk=='<:MagicS:467043867611627520>'
      n=n.join(' / ') if ['<:StrengthS:467037520484630539>*','<:FreezeS:467043868148236299>'].include?(atk)
    end
    atk=atk.gsub('*','')
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
      wl=weapon_legality(event,unitz[0],weapon,nil)
      weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
    end
    u40=apply_stat_skills(event,[],u40,'',summoner,weapon)
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,j,u40[0],mu,2)}**__","#{display_stars(5,merges,summoner)}\n*Neutral Nature only so far*\n#{display_stat_skills(j,[],[],nil,'',[],wl) unless wl=='-'}\n**<:HP_S:467037520538894336>#{u40[1]} | #{atk}#{u40[2]} | <:SpeedS:467037520534962186>#{u40[3]} | <:DefenseS:467037520249487372>#{u40[4]} | <:ResistanceS:467037520379641858>#{u40[5]}** (#{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]} BST)",xcolor,nil,pick_thumbnail(event,j,bot),nil,1)
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
  u40=apply_stat_skills(event,[],u40,'',summoner,weapon)
  u1=get_stats(event,name,1,rarity,merges,boon,bane)
  u1=apply_stat_skills(event,[],u1,'',summoner,weapon)
  j=find_unit(name,event)
  atk='<:StrengthS:467037520484630539>*'
  atk='<:MagicS:467043867611627520>' if ['Tome','Dragon','Healer'].include?(untz[j][1][1])
  atk='<:StrengthS:467037520484630539>' if ['Blade','Bow','Dagger'].include?(untz[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  if zzzl[11].split(', ').include?('Frostbite')
    atk='<:FreezeS:467043868148236299>'
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='<:StrengthS:467037520484630539>'
    n=n[n.length-1] if atk=='<:MagicS:467043867611627520>'
    n=n.join(' / ') if ['<:StrengthS:467037520484630539>*','<:FreezeS:467043868148236299>'].include?(atk)
  end
  atk=atk.gsub('*','')
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
  end
  xcolor=unit_color(event,j,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,nil)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  flds=[["**Level 1#{" +#{merges}" if merges>0}**",["#{' ' if u1[1]<10}#{u1[1]}","#{' ' if u1[2]<10}#{u1[2]}","#{' ' if u1[3]<10}#{u1[3]}","#{' ' if u1[4]<10}#{u1[4]}","#{' ' if u1[5]<10}#{u1[5]}"]],["**Level 40#{" +#{merges}" if merges>0}**",["#{u40[1]}","#{u40[2]}","#{u40[3]}","#{u40[4]}","#{u40[5]}"]]]
  superbaan=["\u00A0","\u00A0","\u00A0","\u00A0","\u00A0","\u00A0"]
  if boon=="" && bane=="" && !mu
    for i in 6...11
      superbaan[i-5]='+' if [-3,1,5,10,14].include?(u40[i]) && rarity==5
      superbaan[i-5]='-' if [-2,2,6,11,15].include?(u40[i]) && rarity==5
      superbaan[i-5]='+' if [-2,10].include?(u40[i]) && rarity==4
      superbaan[i-5]='-' if [-1,11].include?(u40[i]) && rarity==4
    end
  end
  for i in 0...5
    flds[1][1][i]="#{flds[1][1][i]}#{superbaan[i+1]}"
  end
  j=find_unit(name,event)
  img=pick_thumbnail(event,j,bot)
  img='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  xtype=1
  ftr=nil
  ftr="Attack displayed is for #{u40[0].split(' ')[0]}(#{diff_num[1]}).  #{u40[0].split(' ')[0]}(#{diff_num[2]})'s Attack is #{diff_num[0]} point#{'s' unless diff_num[0]==1} lower." if !diff_num.nil? && diff_num[0]>0
  ftr="Attack displayed is for #{u40[0].split(' ')[0]}(#{diff_num[1]}).  #{u40[0].split(' ')[0]}(#{diff_num[2]})'s Attack is #{0-diff_num[0]} point#{'s' unless diff_num[0]==-1} higher." if !diff_num.nil? && diff_num[0]<0
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,j,u40[0],mu,2)}**__","#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,[],[],nil,'',[],wl) unless wl=='-'}\n<:HP_S:467037520538894336>\u00A0\u00B7\u00A0#{atk}\u00A0\u00B7\u00A0<:SpeedS:467037520534962186>\u00A0\u00B7\u00A0<:DefenseS:467037520249487372>\u00A0\u00B7\u00A0<:ResistanceS:467037520379641858>\u00A0\u00B7\u00A0#{u40[1]+u40[2]+u40[3]+u40[4]+u40[5]}\u00A0BST\u2084\u2080```#{flds[0][1].join("\u00A0|")}\n#{flds[1][1].join('|')}```",xcolor,ftr,img,nil)
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
    return 'Gronn' if (x[0].include?('Gronn') || (x[11].include?('Seasonal') && !x[11].include?('Legendary'))) && x[8].include?('*Elwind*')
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
  unless ignore || find_skill(name,event,false,false,true)>=0
    args2=args.join(' ').split(' ')
    name=args.join('')
    data_load()
    # Find the most accurate skill name among the remaining inputs
    if find_skill(name,event,true)<0
      for i in 0...args.length-1
        args.pop
        name=@skills[find_skill(args.join('').downcase,event,true)][0] if find_skill(name,event,true)<0 && find_skill(args.join('').downcase,event,true)>=0
      end
      if find_skill(name,event,true)<0
        for j in 0...args2.length-1
          args2.shift
          args=args2.join(' ').split(' ')
          name=@skills[find_skill(args.join('').downcase,event,true)][0] if find_skill(name,event,true)<0 && find_skill(args.join('').downcase,event,true)>=0
          for i in 0...args.length-1
            args.pop
            name=@skills[find_skill(args.join('').downcase,event,true)][0] if find_skill(name,event,true)<0 && find_skill(args.join('').downcase,event,true)>=0
          end
        end
      end
    end
    if find_skill(name,event)<0
      for i in 0...args.length-1
        args.pop
        name=@skills[find_skill(args.join('').downcase,event)][0] if find_skill(name,event)<0 && find_skill(args.join('').downcase,event)>=0
      end
      if find_skill(name,event)<0
        for j in 0...args2.length-1
          args2.shift
          args=args2.join(' ').split(' ')
          name=@skills[find_skill(args.join('').downcase,event)][0] if find_skill(name,event)<0 && find_skill(args.join('').downcase,event)>=0
          for i in 0...args.length-1
            args.pop
            name=@skills[find_skill(args.join('').downcase,event)][0] if find_skill(name,event)<0 && find_skill(args.join('').downcase,event)>=0
          end
        end
      end
    end
  end
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
      untz[i2]="~~#{untz[i2]}~~" unless untz[i2]=='Laevatein' || untz[i2][0,4].downcase=='all ' || untz[i2]=='-' || unitz[unitz.find_index{|q| q[0]==untz[i2]}][13][0].nil? || !skill[13].nil?
    end
    skill[9][i]=untz.join(', ')
    untz=skill[10][i].split(', ')
    untz=untz.map {|u| u.gsub('[Retro]','')}
    untz=untz.reject {|u| u[0,4].downcase != 'all ' && u != '-' && unitz.find_index{|q| q[0]==u}.nil?}
    untz=untz.map {|u| u.gsub('Lavatain','Laevatein')}
    untz=untz.sort {|a,b| a.downcase <=> b.downcase}
    for i2 in 0...untz.length
      untz[i2]="~~#{untz[i2]}~~" unless untz[i2]=='Laevatein' || untz[i2][0,4].downcase=='all ' || untz[i2]=='-' || unitz[unitz.find_index{|q| q[0]==untz[i2]}][13][0].nil? || !skill[13].nil?
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
    xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Weapons/#{skill[0].gsub(' ','_').gsub('/','_').gsub('+','').gsub('!','')}.png?raw=true"
    if skill[5]=='Red Tome Users Only'
      s=find_base_skill(skill,event)
      xfooter='Dark Mages can still learn this skill, it just takes more SP.'
      if s=="Rau\u00F0r"
        xfooter=nil
      elsif s=='Flux'
        s='Dark'
        xfooter=xfooter.gsub('Dark','Fire')
      end
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Red_Tome:443172811826003968> **Weapon Type:** #{s} Magic (Red Tome)\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=='Blue Tome Users Only'
      s=find_base_skill(skill,event)
      xfooter='Light Mages can still learn this skill, it just takes more SP.'
      if s=="Bl\u00E1r"
        xfooter=nil
      elsif s=='Light'
        xfooter=xfooter.gsub('Light','Thunder')
      end
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Blue_Tome:467112472394858508> **Weapon Type:** #{s} Magic (Blue Tome)\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=='Green Tome Users Only'
      s=find_base_skill(skill,event)
      if s=='Gronn'
        xfooter=nil
      end
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Green_Tome:467122927666593822> **Weapon Type:** #{s} Magic (Green Tome)\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=='Bow Users Only'
      effective.push('<:Icon_Move_Flier:443331186698354698>')
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Bow:443172812492898314> **Weapon Type:** Bow\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
    elsif skill[5]=='Dagger Users Only'
      skill[7]=skill[7].split(' *** ')
      xfooter="Debuff is applied at end of combat if unit attacks, and lasts until the foes' next actions."
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Dagger:443172811461230603> **Weapon Type:** Dagger\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
    elsif skill[5]=='Staff Users Only'
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n#{"<:Gold_Staff:443172811628871720>" if alter_classes(event,'Colored Healers')}#{"<:Colorless_Staff:443692132323295243>" unless alter_classes(event,'Colored Healers')} **Weapon Type:** Staff\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
    elsif skill[5]=='Dragons Only'
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Dragon:443172811641454592> **Weapon Type:** Breath (Dragons)\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
    elsif skill[5]=='Beasts Only'
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n<:Gold_Beast:443172811608162324> **Weapon Type:** Beaststone (Beasts)\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
    else
      s=skill[5]
      s=s[0,s.length-11]
      s='<:Red_Blade:443172811830198282> / Sword (Red Blade)' if s=='Sword'
      s='<:Blue_Blade:467112472768151562> / Lance (Blue Blade)' if s=='Lance'
      s='<:Green_Blade:467122927230386207> / Axe (Green Blade)' if s=='Axe'
      s='<:Summon_Gun:453639908968628229> / Summon Gun' if s=='Summon Gun'
      s="<:Gold_Unknown:443172811499110411> / #{s}" unless s.include?(' / ')
      str="<:Skill_Weapon:444078171114045450> **Skill Slot:** #{skill[4]}\n#{s.split(' / ')[0]} **Weapon Type:** #{s.split(' / ')[1]}\n**Might:** #{skill[2]}  \u00B7  **Range:** #{skill[3]}"
    end
    for i in 0...lookout2.length
      effective.push(lookout2[i][3]) if skill[11].split(', ').include?(lookout2[i][0])
    end
    str="#{str}\n**Effective against:** #{effective.join('')}" if effective.length>0
    if skill[7].is_a?(Array)
      if skill[7][1].nil?
        str="#{str}\n**Debuff:**  \u00B7  *None*"
      else
        eff=skill[7][1].split(', ')
        str="#{str}\n**Debuff:**  \u00B7  *Effect:* #{eff[0,eff.length-1].join(', ')}  \u00B7  *Affects:* #{eff[eff.length-1]}"
      end
      unless skill[7][2].nil?
        eff=skill[7][2].split(', ')
        str="#{str}\n**Buff:**  \u00B7  *Effect:* #{eff[0,eff.length-1].join(', ')}  \u00B7  *Affects:* #{eff[eff.length-1]}"
      end
      str="#{str}\n**Additional Effect:**  \u00B7  #{skill[7][0]}" unless skill[7][0]=='-'
    else
      str="#{str}\n**Effect:** #{skill[7]}" unless skill[7]=='-'
    end
    str="#{str}\n**Stats affected:** 0/#{'+' if skill[12][1]>0}#{skill[12][1]}/#{'+' if skill[12][2]>0}#{skill[12][2]}/#{'+' if skill[12][3]>0}#{skill[12][3]}/#{'+' if skill[12][4]>0}#{skill[12][4]}"
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
    xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Assists/#{skill[0].gsub(' ','_').gsub('/','_').gsub('+','').gsub('!','')}.png?raw=true"
    str="<:Skill_Assist:444078171025965066> **Skill Slot:** #{skill[4]}\n**Range:** #{skill[3]}\n**Effect:** #{skill[7]}"
    str="#{str}\n**Heals:** #{skill[14]}" if skill[5]=="Staff Users Only"
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
    cumul=cumulative_sp_cost(skill,event)
    cumul2=cumul+skill[1]/2
    if skill[0][skill[0].length-1,1]=='+' && skill[5]=="Staff Users Only"
      cumul2+=sklz[sklz.find_index{|q| q[0]==skill[0].gsub('+','')}][1]/2
    end
    str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul2}-#{cumul*3/2} when inherited)" if skill[6]=='-'}" unless cumul==skill[1]
  elsif skill[4]=='Special'
    sklslt=['Special']
    xcolor=0xF67EF8
    xpic="https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Specials/#{skill[0].gsub(' ','_').gsub('/','_').gsub('+','').gsub('!','')}.png?raw=true"
    str="<:Skill_Special:444078170665254929> **Skill Slot:** #{skill[4]}\n**Cooldown:** #{skill[2]}\n**Effect:** #{skill[7]}#{"\n**Range:** ```\n#{skill[3].gsub("n","\n")}```" if skill[3]!="-"}"
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
    cumul=cumulative_sp_cost(skill,event)
    str="#{str}\n**Cumulative SP Cost:** #{cumul} #{"(#{cumul+skill[1]/2}-#{cumul*3/2} when inherited)" if skill[6]=='-'}" unless cumul==skill[1]
  else
    xcolor=0xFDDC7E
    sklimg=skill[0].gsub(' ','_').gsub('/','_').gsub('!','')
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
      p[i2]="~~#{p[i2]}~~" unless p[i2]=='Laevatein' || sklz[sklz.find_index{|q2| q2[0]==p[i2]}][13].nil? || !skill[13].nil?
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
      p2=p.reject{|q| q.gsub('~~','')=='Laevatein' || sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][6]!='-'}
      p=list_lift(p.map{|q| "*#{q}*"},"or")
      p3=p2.map{|q| sklz[sklz.find_index{|q2| q2[0]==q.gsub('~~','')}][10].reject{|q2| q2=='-'}.join(', ')}.join(', ').split(', ').uniq
    else
      p=list_lift(p.map{|q| "*#{q}*"},"or")
    end
  end
  str="#{str}#{"\n**Restrictions on inheritance:** #{skill[5]}" if skill[6]=='-' && skill[4]!='Weapon'}#{"\n**Exclusive to:** #{skill[6].split(', ').reject {|u| find_unit(u,event,false,true)<0 && u != '-'}.join(', ').gsub('Lavatain','Laevatein')}" unless skill[6]=='-'}#{"\n**Promotes from:** #{skill[8]}" unless skill[8]=='-'}#{"\n**Promotes into:** #{p}" unless p.nil?}"
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
    str="#{str}#{"\n" unless x}\n#{str2}" unless str2=='**Heroes who know it out of the box:**'
    x=true unless str2=='**Heroes who know it out of the box:**'
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
  str="#{str}#{"\n" unless x}\n#{str2}" unless str2=='**Heroes who can learn without inheritance:**'
  x=true unless str2=='**Heroes who can learn without inheritance:**'
  prev=find_prevolutions(f,event)
  if prev.length>0
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
    for i4 in 0...statskill[4].length
      if statskill[4][i4]==0
      elsif statskill[3]=='Stat-Nerfing'
        statskill[4][i4]="-#{statskill[4][i4]}"
      else
        statskill[4][i4]="+#{statskill[4][i4]}"
      end
    end
    statskill[4]=statskill[4].join('/')
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
    w=w.map{|q| q[0]}
    create_embed(event,'',"The following skills are triggered when their holder uses #{skill[0]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[4]=="Assist" && skill[11].split(', ').include?('Move') && skill[11].split(', ').include?('Rally')
    w=sklz.reject{|q| !(q[11].split(', ').include?('Link') || q[11].split(', ').include?('Feint')) || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| q[0]}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[0]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[4]=="Assist" && skill[11].split(', ').include?('Move')
    w=sklz.reject{|q| !q[11].split(', ').include?('Link') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| q[0]}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[0]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif skill[4]=="Assist" && skill[11].split(', ').include?('Rally')
    w=sklz.reject{|q| !q[11].split(', ').include?('Feint') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| q[0]}
    create_embed(event,'',"The following skills are triggered when their holder uses or is targeted by #{skill[0]}:",0x40C0F0,nil,nil,triple_finish(w))
  elsif !['Weapon','Assist','Special'].include?(skill[4]) && skill[11].split(', ').include?('Link')
    w=sklz.reject{|q| q[4]!='Assist' || !q[11].split(', ').include?('Move') || q[11].split(', ').include?('Music') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| q[0]}
    create_embed(event,'',"The following skills, when used on or by the unit holding #{skill[0]}, will trigger it:",0x40C0F0,nil,nil,triple_finish(w))
  elsif !['Weapon','Assist','Special'].include?(skill[4]) && skill[11].split(', ').include?('Feint')
    w=sklz.reject{|q| q[4]!='Assist' || !q[11].split(', ').include?('Rally') || !has_any?(g, q[13])}
    w=collapse_skill_list(w)
    w=w.map{|q| q[0]}
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
        zzz=apply_stat_skills(event,[find_effect_name(skill,event,1)],zzz,'','-','','',[],true)
      end
      skill[12][10]=zzz[2]
      sttz.push([zzz[1],0,zzz[3],zzz[4],zzz[5],'Effect'])
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
      puts k2.to_s
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
      str="#{str}\nMight: #{skill[2]+sttz[i][1]+k2[0]}  \u00B7  Range: #{skill[3]}"
      str="#{str}  \u00B7  HP +#{sttz[i][0]+k2[1]}" if sttz[i][0]+k2[1]>0
      atk=mt[1]+k2[2]
      atk+=skill[12][10] if sttz[i][5]=="Effect"
      str="#{str}  \u00B7  Attack #{'+' if atk>0}#{atk}" if atk != 0
      str="#{str}  \u00B7  Speed #{'+' if skill[12][2]+sttz[i][2]+k2[3]>0}#{skill[12][2]+sttz[i][2]+k2[3]}" if skill[12][2]+sttz[i][2]+k2[3]!=0
      str="#{str}  \u00B7  Defense #{'+' if skill[12][3]+sttz[i][3]+k2[4]>0}#{skill[12][3]+sttz[i][3]+k2[4]}" if skill[12][3]+sttz[i][3]+k2[4]!=0
      str="#{str}  \u00B7  Resistance #{'+' if skill[12][4]+sttz[i][4]+k2[5]>0}#{skill[12][4]+sttz[i][4]+k2[5]}" if skill[12][4]+sttz[i][4]+k2[5]!=0
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
        str="#{str}\n*Debuff*:  \u00B7  Effect: #{d[0,d.length-1].join(', ')}  \u00B7  Affects: #{d[d.length-1]}"
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
  if skill[0][0,15]=='Wrathful Staff '
    p=''
    p="\nSince #{bot.user(170070293493186561).distinct} is a fun-sucker, I guess I'll mention other healers.  It's still monsterous to feed Genny to them.  Almost more so, since I'm one of the healers who do the most attacking." if !event.server.nil? && !bot.user(170070293493186561).on(event.server.id).nil?
    p="\nSince you're a fun-sucker, I guess I'll mention other healers.  It's still monsterous to feed Genny to them.  Almost more so, since I'm one of the healers who do the most attacking." if event.user.id==206993446223872002
    event.respond "#{"#{event.user.mention}\n" unless event.user.id==206993446223872002}Anyone who feeds me a Genny is a monster. <:nobully:443331186618793984> It's not my fault the game mechanics prevent me from protesting!\nHeck, now that the Weapon Refinery exists, you can just give my staff the Wrathful Mode upgrade, it pairs well with my high Magic stat.\nOf course, if you *must* give me the B skill, getting rid of Veronica is the better option.  She *is* our enemy, after all.  She *says* she's from a different Outrealm, but does that really make a difference?#{p}"
  elsif skill[0][0,15]=='Dazzling Staff ' && ((event.server.nil? && event.user.id==206993446223872002) || (!event.server.nil? && !bot.user(170070293493186561).on(event.server.id).nil?))
    g=get_markers(event)
    p=unitz.reject{|q| !has_any?(g, q[13][0]) || q[12].gsub('*','').split(', ')[0]!='Lyn'}.uniq
    event.respond "Go ahead, give the skill to whoever you want.  There's #{p} Lyns in the game, who would miss one?"
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
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    namehere=str
    namehere=name unless name.nil? || name.length.zero?
    dv=find_in_dev_units(namehere)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1]
      txt=display_stars(rarity,@dev_units[dv][2],@dev_units[dv][5]).split('  ')[0]
      sklz2=[@dev_units[dv][6],@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],[@dev_units[dv][12]]]
    elsif @dev_nobodies.include?(@units[j][0])
      event.respond "Mathoo has this character but doesn't care enough about including their skills.  Showing default skills." unless chain
    elsif @dev_waifus.include?(@units[j][0]) || @dev_somebodies.include?(@units[j][0])
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing default skills.' unless chain
    else
      event.respond 'Mathoo does not have that character.  Showing default skills.' unless chain
    end
  end
  xcolor=unit_color(event,j,@units[j][0],0,mu,chain)
  f=chain
  f=false if doubleunit
  sklz2[0]=sklz2[0].reject {|a| ['Falchion','**Falchion**'].include?(a)}
  txt="#{txt}\n#{unit_clss(bot,event,j)}\n"
  txt=' ' if f
  flds=[["<:Skill_Weapon:444078171114045450> **Weapons**",sklz2[0].join("\n")],["<:Skill_Assist:444078171025965066> **Assists**",sklz2[1].join("\n")],["<:Skill_Special:444078170665254929> **Specials**",sklz2[2].join("\n")],["<:Passive_A:443677024192823327> **A Passives**",sklz2[3].join("\n")],["<:Passive_B:443677023257493506> **B Passives**",sklz2[4].join("\n")],["<:Passive_C:443677023555026954> **C Passives**",sklz2[5].join("\n")]]
  flds.push(["<:Passive_S:443677023626330122> **Sacred Seal**",sklz2[6][0]]) unless sklz2[6].nil? || sklz2[6][0].length.zero? || sklz2[6][0]==" "
  create_embed(event,"#{"__#{"Mathoo's " if mu}**#{@units[j][0]}**__" unless f}",txt,xcolor,nil,pick_thumbnail(event,j,bot),flds)
end

def extend_message(msg1,msg2,event,enters=1,sym="\n")
  if "#{msg1}#{sym*enters}#{msg2}".length>=2000
    event.respond msg1
    return msg2
  else
    return "#{msg1}#{sym*enters}#{msg2}"
  end
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

def remove_format(s,format)
  if format.length==1
    s=s.gsub("#{'\\'[0,1]}#{format}",'')
  else
    s=s.gsub("#{'\\'[0,1]}#{format}",format[1,format.length-1])
  end
  for i in 0...[s.length,25].min
    f=s.index(format)
    unless f.nil?
      f2=s.index(format,f+format.length)
      unless f2.nil?
        s="#{s[0,f]}|#{s[f2+format.length,s.length-f2-format.length+1]}"
      end
    end
  end
  return s
end

def sever(str,sklz=false)
  str=str.split('/').join(' / ')
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
      if i==0
      elsif k[i-1][0,5].downcase=='rally'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif ['HP','Attack','Speed','Defense','Resistance'].map{|q| q.downcase}.include?(k[i-1].downcase) && i==k.length-1
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      end
    elsif i>1 && !k[i-1].nil? && k[i][0,1]=='+' && k[i][1,k[i].length-1].to_i.to_s==k[i][1,k[i].length-1]
      k[i-1]=stat_modify(k[i-1].downcase)
      if k[i-1][0,5].downcase=='rally'
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

def first_sub(master,str1,str2,mode=0)
  master=master.gsub('!','') if mode==0
  posit=master.downcase.index(str1.downcase)
  return master if posit.nil?
  return "#{master[0,posit] if posit>0}#{str2}#{master[posit+str1.length,master.length] if posit+str1.length<master.length}"
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
        b.push(u2[j].gsub('Lavatain','Laevatein')) unless b.include?(u2[j]) || u2[j].include?('-') || !has_any?(g, untz[untz.find_index{|q| q[0]==u[j]}][13][0])
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
  elsif ['bunnies'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0]) || !q[0].include?('(Spring)')}
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
  elsif ['seasonal','seasonals'].include?(name.downcase)
    l=untz.reject{|q| q[2][0]!=' ' || !q[9][0].include?('s') || !has_any?(g, q[13][0])}
    return ['Seasonals',l.map{|q| q[0]}]
  elsif ['legendary','legendaries','legends','legend'].include?(name.downcase)
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
    return ['Falchion_Users',k2.map{|q| q[10]}.join(', ').split(', ').reject{|q| q=='-' || !has_any?(g, untz[untz.find_index{|q2| q2[0]==q}][13][0])}.uniq.sort]
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
  list=list.uniq
  newlist=[]
  for i in 0...list.length
    unless list[i].nil? || (list[i][0][0,10]=='Falchion (' && skill_include?(list,'Falchion')>0)
      if skill_include?(list,"#{list[i][0]}+")>=0
        list[i][0]="#{list[i][0]}[+]"
        if list[i][0]=='Fire Breath[+]' && skill_include?(list,'Flametongue')>=0 && (mode/2)%2==1
          if skill_include?(list,'Flametongue+')>=0
            list[i][0]='Fire Breath[+]/Flametongue[+]'
            list[i][1]=300
            list[i][15]=list[skill_include?(list,'Flametongue+')][15]
            list[skill_include?(list,'Flametongue+')]=nil if skill_include?(list,'Flametongue+')>=0
            newlist[skill_include?(newlist,'Flametongue+')]=nil if skill_include?(newlist,'Flametongue+')>=0
          else
            list[i][0]='Fire Breath[+]/Flametongue'
            list[i][1]=200
          end
          list[skill_include?(list,'Fire Breath+')]=nil if skill_include?(list,'Fire Breath+')>=0
          newlist[skill_include?(newlist,'Fire Breath+')]=nil if skill_include?(newlist,'Fire Breath+')>=0
          list[skill_include?(list,'Flametongue')]=nil if skill_include?(list,'Flametongue')>=0
          newlist[skill_include?(newlist,'Flametongue')]=nil if skill_include?(newlist,'Flametongue')>=0
        elsif list[i][0]=='Fire Breath[+]' && skill_include?(list,'Flametongue[+]')>=0 && (mode/2)%2==1
          list[i][0]='Fire Breath[+]/Flametongue[+]'
          list[i][1]=300
          list[i][15]=list[skill_include?(list,'Flametongue+')][15]
          list[skill_include?(list,'Fire Breath+')]=nil if skill_include?(list,'Fire Breath+')>=0
          newlist[skill_include?(newlist,'Fire Breath+')]=nil if skill_include?(newlist,'Fire Breath+')>=0
          list[skill_include?(list,'Flametongue[+]')]=nil if skill_include?(list,'Flametongue[+]')>=0
          newlist[skill_include?(newlist,'Flametongue[+]')]=nil if skill_include?(newlist,'Flametongue[+]')>=0
        elsif list[i][0]=='Fire Breath[+]'
          list[i][1]=100
        else
          list[i][1]=300
          list[i][15]=list[skill_include?(list,"#{list[i][0].gsub('[+]','')}+")][15]
        end
        list[skill_include?(list,"#{list[i][0].gsub('[+]','')}+")]=nil if skill_include?(list,"#{list[i][0].gsub('[+]','')}+")>=0
      elsif list[i][0].include?('Iron ') && skill_include?(list,"#{list[i][0].gsub('Iron','Steel')}")>=0 && (mode/2)%2==1
        if skill_include?(list,"#{list[i][0].gsub('Iron','Silver')}")>=0
          if skill_include?(list,"#{list[i][0].gsub('Iron','Silver')}+")>=0
            list[i][1]=300
            list[i][15]=list[skill_include?(list,"#{list[i][0].gsub('Iron','Silver')}+")][15]
            list[skill_include?(list,"#{list[i][0].gsub('Iron','Steel')}")]=nil if skill_include?(list,"#{list[i][0].gsub('Iron','Steel')}")>=0
            newlist[skill_include?(newlist,"#{list[i][0].gsub('Iron','Steel')}")]=nil if skill_include?(newlist,"#{list[i][0].gsub('Iron','Steel')}")>=0
            list[skill_include?(list,"#{list[i][0].gsub('Iron','Silver')}")]=nil if skill_include?(list,"#{list[i][0].gsub('Iron','Silver')}")>=0
            newlist[skill_include?(newlist,"#{list[i][0].gsub('Iron','Silver')}")]=nil if skill_include?(newlist,"#{list[i][0].gsub('Iron','Silver')}")>=0
            list[skill_include?(list,"#{list[i][0].gsub('Iron','Silver')}+")]=nil if skill_include?(list,"#{list[i][0].gsub('Iron','Silver')}+")>=0
            newlist[skill_include?(newlist,"#{list[i][0].gsub('Iron','Silver')}+")]=nil if skill_include?(newlist,"#{list[i][0].gsub('Iron','Silver')}+")>=0
            newlist[skill_include?(newlist,"#{list[i][0].gsub('Iron','Silver')}[+]")]=nil if skill_include?(newlist,"#{list[i][0].gsub('Iron','Silver')}[+]")>=0
            list[i][0]="#{list[i][0].gsub('Iron','Iron/Steel/Silver[+]')}"
          else
            list[skill_include?(list,"#{list[i][0].gsub('Iron','Steel')}")]=nil
            newlist[skill_include?(newlist,"#{list[i][0].gsub('Iron','Steel')}")]=nil if skill_include?(newlist,"#{list[i][0].gsub('Iron','Steel')}")>=0
            list[skill_include?(list,"#{list[i][0].gsub('Iron','Silver')}")]=nil
            newlist[skill_include?(newlist,"#{list[i][0].gsub('Iron','Silver')}")]=nil if skill_include?(newlist,"#{list[i][0].gsub('Iron','Silver')}")>=0
            list[i][0]="#{list[i][0].gsub('Iron','Iron/Steel/Silver')}"
            list[i][1]=200
          end
        else
          list[skill_include?(list,"#{list[i][0].gsub('Iron','Steel')}")]=nil if skill_include?(list,"#{list[i][0].gsub('Iron','Steel')}")>=0
          newlist[skill_include?(newlist,"#{list[i][0].gsub('Iron','Steel')}")]=nil if skill_include?(newlist,"#{list[i][0].gsub('Iron','Steel')}")>=0
          list[i][0]="#{list[i][0].gsub('Iron','Iron/Steel')}"
          list[i][1]=100
        end
      elsif skill_include?(list,"El#{list[i][0].downcase}")>=0 && list[i][5].include?('Tome Users Only') && list[i][4]=='Weapon' && (mode/2)%2==1
        v2=list[i][0].downcase
        list[i][0]="[El]#{list[i][0]}"
        list[i][1]=100
        if list[i][0]=='[El]Fire'
          if skill_include?(list,'Bolganone')>=0
            if skill_include?(list,'Bolganone+')>=0
              list[i][0]='[El]Fire/Bolganone[+]'
              list[i][1]=300
              list[i][15]=list[skill_include?(list,'Bolganone+')][15]
              list[skill_include?(list,'Bolganone+')]=nil if skill_include?(list,'Bolganone+')>=0
              newlist[skill_include?(newlist,'Bolganone+')]=nil if skill_include?(newlist,'Bolganone+')>=0
            else
              list[i][0]='[El]Fire/Bolganone'
              list[i][1]=200
            end
            list[skill_include?(list,'Bolganone')]=nil if skill_include?(list,'Bolganone')>=0
            newlist[skill_include?(newlist,'Bolganone')]=nil if skill_include?(newlist,'Bolganone')>=0
          elsif skill_include?(list,'Bolganone[+]')>=0
            list[i][0]='[El]Fire/Bolganone[+]'
            list[i][1]=300
            list[i][15]=list[skill_include?(list,'Bolganone[+]')][15]
            list[skill_include?(list,'Bolganone[+]')]=nil if skill_include?(list,'Bolganone[+]')>=0
            newlist[skill_include?(newlist,'Bolganone[+]')]=nil if skill_include?(newlist,'Bolganone[+]')>=0
          end
        elsif list[i][0]=='[El]Thunder'
          if skill_include?(list,'Thoron')>=0
            if skill_include?(list,'Thoron+')>=0
              list[i][0]='[El]Thunder/Thoron[+]'
              list[i][1]=300
              list[i][15]=list[skill_include?(list,'Thoron+')][15]
              list[skill_include?(list,'Thoron+')]=nil if skill_include?(list,'Thoron+')>=0
              newlist[skill_include?(newlist,'Thoron+')]=nil if skill_include?(newlist,'Thoron+')>=0
            else
              list[i][0]='[El]Thunder/Thoron'
              list[i][1]=200
            end
            list[skill_include?(list,'Thoron')]=nil if skill_include?(list,'Thoron')>=0
            newlist[skill_include?(newlist,'Thoron')]=nil if skill_include?(newlist,'Thoron')>=0
          elsif skill_include?(list,'Thoron[+]')>=0
            list[i][0]='[El]Thunder/Thoron[+]'
            list[i][1]=300
            list[i][15]=list[skill_include?(list,'Thoron[+]')][15]
            list[skill_include?(list,'Thoron[+]')]=nil if skill_include?(list,'Thoron[+]')>=0
            newlist[skill_include?(newlist,'Thoron[+]')]=nil if skill_include?(newlist,'Thoron[+]')>=0
          end
        elsif list[i][0]=='[El]Light'
          if skill_include?(list,'Shine')>=0
            if skill_include?(list,'Shine+')>=0
              list[i][0]='[El]Light/Shine[+]'
              list[i][1]=300
              list[i][15]=list[skill_include?(list,'Shine+')][15]
              list[skill_include?(list,'Shine+')]=nil if skill_include?(list,'Shine+')>=0
              newlist[skill_include?(newlist,'Shine+')]=nil if skill_include?(newlist,'Shine+')>=0
            else
              list[i][0]='[El]Light/Shine'
              list[i][1]=200
            end
            list[skill_include?(list,'Shine')]=nil if skill_include?(list,'Shine')>=0
            newlist[skill_include?(newlist,'Shine')]=nil if skill_include?(newlist,'Shine')>=0
          elsif skill_include?(list,'Shine[+]')>=0
            list[i][0]='[El]Light/Shine[+]'
            list[i][1]=300
            list[i][15]=list[skill_include?(list,'Shine[+]')][15]
            list[skill_include?(list,'Shine[+]')]=nil if skill_include?(list,'Shine[+]')>=0
            newlist[skill_include?(newlist,'Shine[+]')]=nil if skill_include?(newlist,'Shine[+]')>=0
          end
        elsif list[i][0]=='[El]Wind'
          if skill_include?(list,'Rexcalibur')>=0
            if skill_include?(list,'Rexcalibur+')>=0
              list[i][0]='[El]Wind/Rexcalibur[+]'
              list[i][1]=300
              list[i][15]=list[skill_include?(list,'Rexcalibur+')][15]
              list[skill_include?(list,'Rexcalibur+')]=nil if skill_include?(list,'Rexcalibur+')>=0
              newlist[skill_include?(newlist,'Rexcalibur+')]=nil if skill_include?(newlist,'Rexcalibur+')>=0
            else
              list[i][0]='[El]Wind/Rexcalibur'
              list[i][1]=200
            end
            list[skill_include?(list,'Rexcalibur')]=nil if skill_include?(list,'Rexcalibur')>=0
            newlist[skill_include?(newlist,'Rexcalibur')]=nil if skill_include?(newlist,'Rexcalibur')>=0
          elsif skill_include?(list,'Rexcalibur[+]')>=0
            list[i][0]='[El]Wind/Rexcalibur[+]'
            list[i][1]=300
            list[i][15]=list[skill_include?(list,'Rexcalibur[+]')][15]
            list[skill_include?(list,'Rexcalibur[+]')]=nil if skill_include?(list,'Rexcalibur[+]')>=0
            newlist[skill_include?(newlist,'Rexcalibur[+]')]=nil if skill_include?(newlist,'Rexcalibur[+]')>=0
          end
        end
        list[skill_include?(list,"El#{v2}")]=nil
        newlist[skill_include?(newlist,"El#{v2}")]=nil if skill_include?(newlist,"El#{v2}")
      elsif list[i][0]=='Flux' && skill_include?(list,'Ruin')>=0 && (mode/2)%2==1
        if skill_include?(list,'Fenrir')>=0
          if skill_include?(list,'Fenrir+')>=0
            list[i][0]='Flux/Ruin/Fenrir[+]'
            list[i][1]=300
            list[i][15]=list[skill_include?(list,'Fenrir+')][15]
            list[skill_include?(list,'Fenrir+')]=nil if skill_include?(list,'Fenrir+')>=0
            newlist[skill_include?(newlist,'Fenrir+')]=nil if skill_include?(newlist,'Fenrir+')>=0
          else
            list[i][0]='Flux/Ruin/Fenrir'
            list[i][1]=200
          end
          list[skill_include?(list,'Fenrir')]=nil if skill_include?(list,'Fenrir')>=0
          newlist[skill_include?(newlist,'Fenrir')]=nil if skill_include?(newlist,'Fenrir')>=0
        elsif skill_include?(list,'Fenrir[+]')>=0
          list[i][0]='Flux/Ruin/Fenrir[+]'
          list[i][1]=300
          list[i][15]=list[skill_include?(list,'Fenrir[+]')][15]
          list[skill_include?(list,'Fenrir[+]')]=nil if skill_include?(list,'Fenrir[+]')>=0
          newlist[skill_include?(newlist,'Fenrir[+]')]=nil if skill_include?(newlist,'Fenrir[+]')>=0
        else
          list[i][0]='Flux/Ruin'
          list[i][1]=100
        end
        list[skill_include?(list,'Ruin')]=nil
        newlist[skill_include?(newlist,'Ruin')]=nil if skill_include?(newlist,'Ruin')>=0
      elsif list[i][0][list[i][0].length-1,1].to_i.to_s==list[i][0][list[i][0].length-1,1]
        v=list[i][0].gsub(list[i][0].scan(/([^0-9])+?/).join,"").to_i
        v2=list[i][0].scan(/([^0-9])+?/).join
        if skill_include?(list,"#{v2}#{v+1}")>=0
          if skill_include?(list,"#{v2}#{v+2}")>=0
            if skill_include?(list,"#{v2}#{v+3}")>=0
              if skill_include?(list,"#{v2}#{v+4}")>=0
                if skill_include?(list,"#{v2}#{v+5}")>=0
                  if skill_include?(list,"#{v2}#{v+6}")>=0
                    if skill_include?(list,"#{v2}#{v+7}")>=0
                      if skill_include?(list,"#{v2}#{v+8}")>=0
                        if skill_include?(list,"#{v2}#{v+9}")>=0
                          list[i][0]="#{v2}#{v}/#{v+1}/#{v+2}/#{v+3}/#{v+4}/#{v+5}/#{v+6}/#{v+7}/#{v+8}/#{v+9}"
                          list[i][1]=list[skill_include?(list,"#{v2}#{v+9}")][1]*1
                          list[skill_include?(list,"#{v2}#{v+9}")]=nil if skill_include?(list,"#{v2}#{v+9}")>=0
                        else
                          list[i][0]="#{v2}#{v}/#{v+1}/#{v+2}/#{v+3}/#{v+4}/#{v+5}/#{v+6}/#{v+7}/#{v+8}"
                          list[i][1]=list[skill_include?(list,"#{v2}#{v+8}")][1]*1
                        end
                        list[skill_include?(list,"#{v2}#{v+8}")]=nil if skill_include?(list,"#{v2}#{v+8}")>=0
                      else
                        list[i][0]="#{v2}#{v}/#{v+1}/#{v+2}/#{v+3}/#{v+4}/#{v+5}/#{v+6}/#{v+7}"
                        list[i][1]=list[skill_include?(list,"#{v2}#{v+7}")][1]*1
                      end
                      list[skill_include?(list,"#{v2}#{v+7}")]=nil if skill_include?(list,"#{v2}#{v+7}")>=0
                    else
                      list[i][0]="#{v2}#{v}/#{v+1}/#{v+2}/#{v+3}/#{v+4}/#{v+5}/#{v+6}"
                      list[i][1]=list[skill_include?(list,"#{v2}#{v+6}")][1]*1
                    end
                    list[skill_include?(list,"#{v2}#{v+6}")]=nil if skill_include?(list,"#{v2}#{v+6}")>=0
                  else
                    list[i][0]="#{v2}#{v}/#{v+1}/#{v+2}/#{v+3}/#{v+4}/#{v+5}"
                    list[i][1]=list[skill_include?(list,"#{v2}#{v+5}")][1]*1
                  end
                  list[skill_include?(list,"#{v2}#{v+5}")]=nil if skill_include?(list,"#{v2}#{v+5}")>=0
                else
                  list[i][0]="#{v2}#{v}/#{v+1}/#{v+2}/#{v+3}/#{v+4}"
                  list[i][1]=list[skill_include?(list,"#{v2}#{v+4}")][1]*1
                end
                list[skill_include?(list,"#{v2}#{v+4}")]=nil if skill_include?(list,"#{v2}#{v+4}")>=0
              else
                list[i][0]="#{v2}#{v}/#{v+1}/#{v+2}/#{v+3}"
                list[i][1]=list[skill_include?(list,"#{v2}#{v+3}")][1]*1
              end
              list[skill_include?(list,"#{v2}#{v+3}")]=nil if skill_include?(list,"#{v2}#{v+3}")>=0
            else
              list[i][0]="#{v2}#{v}/#{v+1}/#{v+2}"
              list[i][1]=list[skill_include?(list,"#{v2}#{v+2}")][1]*1
            end
            list[skill_include?(list,"#{v2}#{v+2}")]=nil if skill_include?(list,"#{v2}#{v+2}")>=0
          else
            list[i][0]="#{v2}#{v}/#{v+1}"
            list[i][1]=list[skill_include?(list,"#{v2}#{v+1}")][1]*1
          end
          list[skill_include?(list,"#{v2}#{v+1}")]=nil if skill_include?(list,"#{v2}#{v+1}")>=0
        end
      end
      newlist.push(list[i].map{|q| q})
      newlist.push(list[i].map{|q| q}) if list[i][0][0,4]=='[El]'
    end
  end
  newlist.compact!
  newlist.uniq!
  unless (mode/4)%2==1
    data_load()
    u=@units.map{|q| q}
    for i in 0...newlist.length
      newlist[i][0]=newlist[i][0].gsub('Bladeblade','Laevatein')
      newlist[i][0]="~~#{newlist[i][0]}~~" if !newlist[i][13].nil? && newlist[i][13].length>0 && mode%2==1
      m=[]
      if newlist[i][4]=='Weapon' && newlist[i][6]!='-'
        m=newlist[i][6].split(', ').reject{|q| !u.map{|q2| q2[0]}.include?(q) || u[u.find_index{|q2| q2[0]==q}][9][0]=='-'}
        newlist[i][0]="*#{newlist[i][0]}*" if m.length==0
      end
    end
  end
  if (mode/8)%2==1
    for i in 0...newlist.length
      if newlist[i][0].include?('Iron/Steel/Silver[+] ')
        m=newlist[i][0].gsub('Iron/Steel/Silver[+] ','')
        newlist[i][0]=["Iron #{m}","Steel #{m}","Silver #{m}","Silver #{m}+"]
      else
        newlist[i][0]=newlist[i][0].split('/')
        for i2 in 0...newlist[i][0].length
          newlist[i][0][i2]="#{newlist[i][0][i2].gsub('[El]','')}/El#{newlist[i][0][i2].gsub('[El]','').downcase}" if newlist[i][0][i2].include?('[El]')
          newlist[i][0][i2]="#{newlist[i][0][i2].gsub('[+]','')}/#{newlist[i][0][i2].gsub('[+]','')}+" if newlist[i][0][i2].include?('[+]')
        end
      end
      newlist[i][0]=newlist[i][0].join('/').split('/')
      if !newlist[i][0][1].nil? && newlist[i][0][1].length<=1
        m=newlist[i][0][0][0,newlist[i][0][0].length-1]
        for i2 in 1...newlist[i][0].length
          newlist[i][0][i2]="#{m}#{newlist[i][0][i2]}"
        end
      end
      if newlist[i][8].include?('*, *')
        newlist[i][8]=newlist[i][8].gsub('*','').split(', ')
      elsif newlist[i][8].include?('* or *')
        newlist[i][8]=newlist[i][8].split('* or *').map{|q| q.gsub('*','')}
      elsif newlist[i][8].include?('*')
        newlist[i][8]=[newlist[i][8].gsub('*','')]
      else
        newlist[i][8]=[]
      end
    end
    for i in 0...newlist.length
      m=false
      for i2 in 0...newlist.length
        if i != i2 && !newlist[i2].nil? && has_any?(newlist[i][8],newlist[i2][0])
          m=true
          for i3 in 0...newlist[i][0].length
            newlist[i2][0].push(newlist[i][0][i3])
          end
        end
      end
      newlist[i]=nil if m
    end
    newlist.compact!
    for i in 0...newlist.length
      for i2 in 0...newlist.length
        if i != i2 && !newlist[i].nil? && !newlist[i2].nil? && has_any?(newlist[i][0],newlist[i2][0])
          for i3 in 0...newlist[i][0].length
            newlist[i2][0].push(newlist[i][0][i3])
          end
          newlist[i2][0].uniq!
          newlist[i2][0]=newlist[i2][0].sort{|a,b| a <=> b}
          newlist[i]=nil
        end
      end
    end
    newlist.compact!
  end
  newlist=newlist.sort {|a,b| a[0].gsub('~~','').gsub('*','').gsub('[El]','').downcase <=> b[0].gsub('~~','').gsub('*','').gsub('[El]','').downcase} unless (mode/8)%2==1
  return newlist
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
  tier=[]
  group=[]
  unitz=[]
  genders=[]
  games=[]
  supernatures=[]
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
    weapons.push('Blade') if ['physical','blade','blades'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','spell','tomes','mages','spells'].include?(args[i].downcase)
    weapons.push('Dragon') if ['dragon','dragons','breath','manakete','manaketes'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thiefs','thieves'].include?(args[i].downcase)
    weapons.push('Healer') if ['healer','staff','cleric','healers','clerics','staves'].include?(args[i].downcase)
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
    group.push(@groups[find_group(args[i].downcase,event)]) if find_group(args[i].downcase,event)>=0 && args[i].length>=3
  end
  colors=colors.uniq
  weapons=weapons.uniq
  movement=movement.uniq
  genders=genders.uniq
  games=games.uniq
  tier=tier.uniq
  group=group.uniq
  supernatures=supernatures.uniq
  # prune based on inputs
  matches1=[]
  g=get_markers(event)
  matches0=@units.reject{|q| !has_any?(g, q[13][0])}
  for i in 0...matches0.length
    matches0[i][0]=matches0[i][0].gsub('Lavatain','Laevatein')
  end
  if supernatures.length.zero? && colors.length.zero? && weapons.length.zero? && color_weapons.length.zero? && movement.length.zero? && genders.length.zero? && games.length.zero? && group.length.zero?
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
    if colors.length.zero? && weapons.length.zero? && color_weapons.length.zero? && movement.length.zero? && genders.length.zero? && games.length.zero? && group.length.zero?
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
      if movement.length.zero? && genders.length.zero? && games.length.zero? && group.length.zero?
        return matches1.map{|q| q}.uniq if mode==3
        matches5=matches1.map{|q| q}.sort {|a,b| a[0].downcase <=> b[0].downcase}.uniq
      else
        matches2=[]
        if movement.length>0
          matches2=matches1.reject{|q| !movement.include?(q[3])}
        else
          matches2=matches1.map{|q| q}
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
              for i in 0...matches3.length
                for j in 0...games.length
                  if matches3[i][11].map{|q| q.downcase}.include?(games[j].downcase)
                    matches4.push(matches3[i])
                  elsif matches3[i][11].map{|q| q.downcase.gsub('(a)','')}.include?(games[j].downcase)
                    matches3[i][0]="#{matches3[i][0]} *[Amiibo]*"
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
  elsif matches5.length.zero?
    event.respond 'There were no units that matched your request.' unless paired
    return -2
  elsif matches5.map{|k| k[0]}.join("\n").length>=1900 && !safe_to_spam?(event) && !ignore_limit
    event.respond 'There were so many unit matches that I would prefer you use the command in PM.' unless paired
    return -2
  elsif mode==2
    return matches5
  elsif mode==1
    f=matches5.map{|k| k[0]}
    return f
  else
    matches5=matches5.uniq
    if matches5.length.zero?
      event.respond 'No matches found.'
      return false
    elsif matches5.length==1
      event.respond "#{matches5[0][0]} is your only result."
      return false
    else
      f=[]
      matches5.sort! {|a,b| a[0] <=> b[0]}
      for i in 0...matches5.length
        matches5[i][0]="__**#{matches5[i][0]}**__" if unitz.length>0 && unitz.include?(matches5[i][0])
        f.push(matches5[i][0])
      end
      return f if mode==1
      t=f[0]
      c=', '
      c="\n" if event.server.nil?
      if f.length>1
        for i in 1...f.length
          if "#{t}#{c}#{f[i]}".length>=2000
            event.respond t
            t=f[i]
          else
            t="#{t}#{c}#{f[i]}"
          end
        end
      end
      event.respond t
    end
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
    weapons.push('Blade') if ['physical','blade','blades'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','magic','spell','tomes','mages','spells'].include?(args[i].downcase)
    weapons.push('Breath') if ['dragon','dragons','breath','manakete','manaketes'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thiefs','thieves'].include?(args[i].downcase)
    weapons.push('Staff') if ['healer','staff','cleric','healers','clerics','staves'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz'].include?(args[i].downcase)
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
                matches3.push(matches2[i]) if matches2[i][5]=='Bow Users Only' || matches2[i][11].split(', ').include?(weapon_subsets[j])
              elsif matches2[i][4]=='Weapon' && matches2[i][11].split(', ').include?(weapon_subsets[j])
                matches3.push(matches2[i])
              elsif matches2[i][4]=='Weapon' && matches2[i][11].split(', ').include?("(R)#{weapon_subsets[j]}")
                matches2[i][0]="#{matches2[i][0]} *(+) All*"
                matches3.push(matches2[i])
              elsif matches2[i][4]=='Weapon' && matches2[i][11].split(', ').include?("(E)#{weapon_subsets[j]}")
                matches2[i][0]="#{matches2[i][0]} *(+) Effect*"
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
    matches4=split_list(event,matches4,['Sword','Red Tome','Dragon','Bow','Dagger','Staff'],5)
  elsif colors==['Blue'] && weapons.length<=0 && color_weapons.length<=0
    # Blue is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Lance','Blue Tome','Dragon','Bow','Dagger','Staff'],5)
  elsif colors==['Green'] && weapons.length<=0 && color_weapons.length<=0
    # Green is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Axe','Green Tome','Dragon','Bow','Dagger','Staff'],5)
  elsif colors==['Colorless'] && weapons.length<=0 && color_weapons.length<=0
    # Colorless is the only color requested but no other restrictions are given
    matches4=split_list(event,matches4,['Rod','Colorless Tome','Dragon','Bow','Dagger','Staff'],5)
  elsif matches4.map{|q| q[0]}.join("\n").length<=1800 && matches4.map{|q| q[4]}.uniq.length==1 && matches4.map{|q| q[4]}.uniq[0]=='Weapon' && matches4.map{|q| q[11]}.uniq.length>1
    matches4=split_list(event,matches4,['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Rod','Colorless Tome','Dragon','Bow','Dagger','Staff'],5)
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
  if matches4.length>=microskills.length && !(args.nil? || args.length.zero?) && !safe_to_spam?(event)
    event.respond 'Your request is gibberish.' if ['skill','skills'].include?(args[0].downcase)
    return -1
  elsif matches4.length.zero?
    event.respond 'There were no skills that matched your request.' unless paired
    return -2
  elsif matches4.map{|k| k[0]}.join("\n").length>=1900 && !safe_to_spam?(event)
    event.respond '\* \* \*' if !brk.is_a?(Array)
    event.respond 'There were so many skill matches that I would prefer you use the command in PM.' unless paired
    return -2
  elsif mode==1
    f=matches4.map{|k| k[0].gsub('Bladeblade','Laevatein')}
    return f
  elsif mode==2
    return matches4
  else
    event.respond '\* \* \*' if !brk.is_a?(Array)
    t=matches4[0][0]
    c=', '
    c="\n" if event.server.nil?
    if matches4.length>1
      for i in 1...matches4.length
        if "#{t}#{c}#{matches4[i][0]}".length>=2000
          event.respond t
          t=matches4[i][0].gsub('Bladeblade','Laevatein')
        else
          t="#{t}#{c}#{matches4[i][0].gsub('Bladeblade','Laevatein')}"
        end
      end
    end
    event.respond t
  end
  return 1
end

def display_units(event, mode)
  k=find_in_units(event,1)
  if k.is_a?(Array)
    data_load()
    untz=@units.map{|q| q}
    for i in 0...k.length
      m=''
      m='*' if ['Laevatein'].include?(k[i])
      unless ['Laevatein','- - -'].include?(k[i])
        m2=untz[untz.find_index{|q2| q2[0]==k[i].gsub(' *[Amiibo]*','')}]
        m='~~' unless m2[13][0].nil?
        m='*' if m2[9][0].downcase.gsub('0s','')=='-'
      end
      m='' if m=='*' && k.reject{|q| !q.include?(' *[Amiibo]*')}.length>0
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
        wpn1=p1[i].map{|q| untz[untz.find_index{|q2| q2[0]==q.gsub('Laevatein','Lavatain').gsub('~~','').gsub(' *[Amiibo]*','').gsub('*','')}][1]}
        h='.'
        if wpn1.uniq.length==1
          # blade type
          h='<:Red_Blade:443172811830198282> Swords' if p1[i].include?('Alfonse') || (wpn1[0]==['Red', 'Blade'])
          h='<:Blue_Blade:467112472768151562> Lances' if p1[i].include?('Sharena') || (wpn1[0]==['Blue', 'Blade'])
          h='<:Green_Blade:467122927230386207> Axes' if p1[i].include?('Anna') || (wpn1[0]==['Green', 'Blade'])
          h='<:Colorless_Blade:443692132310712322> Rods' if wpn1[0]==['Colorless', 'Blade']
          # Magic types
          h='<:Red_Tome:443172811826003968> Fire Mages' if p1[i].include?('Lilina') || (wpn1[0]==['Red', 'Tome', 'Fire'])
          h='<:Red_Tome:443172811826003968> Dark Mages' if p1[i].include?('Raigh') || (wpn1[0]==['Red', 'Tome', 'Dark'])
          h='<:Blue_Tome:467112472394858508> Thunder Mages' if p1[i].include?('Odin') || (wpn1[0]==['Red', 'Tome', 'Thunder'])
          h='<:Blue_Tome:467112472394858508> Light Mages' if p1[i].include?('Micaiah') || (wpn1[0]==['Red', 'Tome', 'Light'])
          h='<:Green_Tome:467122927666593822> Wind Mages' if p1[i].include?('Cecilia') || (wpn1[0]==['Green', 'Tome', 'Wind'])
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
          h='<:Red_Beast:443172811599773734> Red Beasts' if (wpn1[0]==['Red', 'Beast'])
          h='<:Blue_Beast:467112472990580747> Blue Beasts' if (wpn1[0]==['Blue', 'Beast'])
          h='<:Green_Beast:467122926630731806> Green Beasts' if (wpn1[0]==['Green', 'Beast'])
          h='<:Colorless_Beast:443692132423958529> Colorless Beasts' if (wpn1[0]==['Colorless', 'Beast'])
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
            h=untz[untz.find_index{|q2| q2[0]==p1[i][l].gsub(' *[Amiibo]*','').gsub('*','')}][1][0] if h != untz[untz.find_index{|q2| q2[0]==p1[i][l]}][1][2]
          end
          h="#{h} Mages"
        end
        p1[i]=[h,p1[i]]
      end
      if p1.map{|q| q[0]}.uniq.length<=1
        for i in 0...p1.length
          mov=p1[i][1].map{|q| untz[untz.find_index{|q2| q2[0]==q.gsub('Laevatein','Lavatain').gsub('~~','').gsub(' *[Amiibo]*','').gsub('*','')}][3]}.uniq
          if mov.length<=1
            p1[i][0]='<:Icon_Move_Infantry:443331187579289601> Infantry' if mov[0]=='Infantry'
            p1[i][0]='<:Icon_Move_Armor:443331186316673025> Armor' if mov[0]=='Armor'
            p1[i][0]='<:Icon_Move_Flier:443331186698354698> Flying' if mov[0]=='Flier'
            p1[i][0]='<:Icon_Move_Cavalry:443331186530451466> Cavalry' if mov[0]=='Cavalry'
          end
        end
      end
      if mode==1
        create_embed(event,'Results','',0x9400D3,nil,nil,p1.map{|q| [q[0],q[1].join("\n")]})
      else
        msg=''
        for i in 0...p1.length
          msg=extend_message(msg,"**#{p1[i][0]}** - #{p1[i][1].join(', ')}",event,2)
        end
        event.respond msg
      end
    else
      if k.join("\n").length<=1900
        create_embed(event,'Results','',0x9400D3,nil,nil,triple_finish(k))
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
  data_load()
  sklz=@skills.map{|q| q}
  if k.is_a?(Array)
    if k.include?('- - -')
      p1=[[]]
      p2=0
      typesx=[]
      for i in 0...k.length
        unless k[i]=='- - -'
          f=k[i].gsub('~~','').gsub(' *(+) All*','').gsub(' *(+) Effect*','').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','').gsub('[El]','').gsub('Flux/Ruin/Fenrir[+]','Flux').gsub('Flux/Ruin/Fenrir','Flux').gsub('Flux/Ruin','Flux').gsub('Iron/Steel/Silver[+]','Iron').gsub('[+]','+').gsub('Iron/Steel/Silver','Iron').gsub('Iron/Steel','Iron').gsub('Laevatein','Bladeblade').gsub('*','')
          f=f.split('/')[0] if sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}.nil?
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
      emotes=['<:Gold_Staff:443172811628871720>','<:Gold_Dagger:443172811461230603>','<:Gold_Dragon:443172811641454592>','<:Gold_Bow:443172812492898314>','<:Gold_Beast:443172811608162324>']
      emotes[0]='<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')
      emotes=['<:Red_Staff:443172812455280640>','<:Red_Dagger:443172811490721804>','<:Red_Dragon:443172811796774932>','<:Red_Bow:443172812455280641>','<:Red_Beast:443172811599773734>'] if colors.length==1 && colors[0]=='Red'
      emotes=['<:Blue_Staff:467112472407703553>','<:Blue_Dagger:467112472625545217>','<:Blue_Dragon:467112473313542144>','<:Blue_Bow:467112473313542155>','<:Blue_Beast:467112472990580747>'] if colors.length==1 && colors[0]=='Blue'
      emotes=['<:Green_Staff:467122927616262144>','<:Green_Dagger:467122926655897610>','<:Green_Dragon:467122926718550026>','<:Green_Bow:467122927536570380>','<:Green_Beast:467122926630731806>'] if colors.length==1 && colors[0]=='Green'
      emotes=['<:Colorless_Staff:443692132323295243>','<:Colorless_Dagger:443692132683743232>','<:Colorless_Dragon:443692132415438849>','<:Colorless_Bow:443692132616896512>','<:Colorless_Beast:443692132423958529>'] if colors.length==1 && colors[0]=='Colorless'
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
            f=p1[i][i2].gsub('~~','').gsub(' *(+) All*','').gsub(' *(+) Effect*','').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','').gsub('[El]','').gsub('Flux/Ruin/Fenrir[+]','Flux').gsub('Flux/Ruin/Fenrir','Flux').gsub('Flux/Ruin','Flux').gsub('Iron/Steel/Silver[+]','Iron').gsub('[+]','+').gsub('Iron/Steel/Silver','Iron').gsub('Iron/Steel','Iron').gsub('Laevatein','Bladeblade').gsub('*','')
            f=f.split('/')[0] if sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}.nil?
            typesx.push(sklz[sklz.find_index{|q| stat_buffs(q[0])==stat_buffs(f)}])
          end
        end
        types=typesx.map{|q| [q[4],q[5],find_base_skill(q,event)]}.uniq
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
            h='<:Red_Tome:443172811826003968> Fire Magic' if p1[i].include?('Fire') || p1[i].include?('[El]Fire') || p1[i].include?('[El]Fire/Bolganone') || p1[i].include?('[El]Fire/Bolganone[+]') || types[0][2]=='Fire'
            h='<:Red_Tome:443172811826003968> Dark Magic' if p1[i].include?('Flux') || p1[i].include?('Flux/Ruin') || p1[i].include?('Flux/Ruin/Fenrir') || p1[i].include?('Flux/Ruin/Fenrir[+]') || types[0][2]=='Flux'
            h="<:Red_Tome:443172811826003968> Rau\u00F0r Magic" if p1[i].include?('Raudrblade[+]') || types[0][2]=="Rau\u00F0r"
            h='<:Blue_Tome:467112472394858508> Thunder Magic' if p1[i].include?('Thunder') || p1[i].include?('[El]Thunder') || p1[i].include?('[El]Thunder/Thoron') || p1[i].include?('[El]Thunder/Thoron[+]') || types[0][2]=='Thunder'
            h='<:Blue_Tome:467112472394858508> Light Magic' if p1[i].include?('Light') || p1[i].include?('[El]Light') || p1[i].include?('[El]Light/Shine') || p1[i].include?('[El]Light/Shine[+]') || types[0][2]=='Light'
            h="<:Blue_Tome:467112472394858508> Bl\u00E1r Magic" if p1[i].include?('Blarblade[+]') || types[0][2]=="Bl\u00E1r"
            h='<:Green_Tome:467122927666593822> Wind Magic' if p1[i].include?('Wind') || p1[i].include?('[El]Wind') || p1[i].include?('[El]Wind/Rexcalibur') || p1[i].include?('[El]Wind/Rexcalibur[+]') || types[0][2]=='Wind'
            h='<:Green_Tome:467122927666593822> Gronn Magic' if p1[i].include?('Gronnblade[+]') || types[0][2]=='Gronn'
            # Breaths
            h="#{emotes[2]} Dragon Breaths" if p1[i].include?('Fire Breath[+]') || types[0][1]=='Dragons Only'
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
          h="#{emotes[3]} Bows" if p1[i].include?('Iron Bow') || p1[i].include?('Iron/Steel Bow') || p1[i].include?('Iron/Steel/Silver Bow') || p1[i].include?('Iron/Steel/Silver[+] Bow') || types[0][1]=='Bow Users Only'
          h="#{emotes[1]} Daggers" if p1[i].include?('Iron Dagger') || p1[i].include?('Iron/Steel Dagger') || p1[i].include?('Iron/Steel/Silver Dagger') || p1[i].include?('Iron/Steel/Silver[+] Dagger') || types[0][1]=='Dagger Users Only'
        end
        p1[i]=[h,p1[i].join("\n")]
      end
      if mode==1
        create_embed(event,'Results','',0x9400D3,nil,nil,p1)
      else
        msg=''
        for i in 0...p1.length
          msg=extend_message(msg,"**#{p1[i][0]}** - #{p1[i][1].gsub("\n",', ')}",event,2)
        end
        event.respond msg
      end
    else
      if k.join("\n").length<=1900
        create_embed(event,'Results','',0x9400D3,nil,nil,triple_finish(k))
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
  f=[0,0,0,0,0,0,0,0,0]
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
  if args.map{|q| q.downcase}.include?('stats')
    f.push(1) unless f.include?(1)
    f.push(2) unless f.include?(2)
    f.push(3) unless f.include?(3)
    f.push(4) unless f.include?(4)
    f.push(5) unless f.include?(5)
  end
  k2=find_in_units(event,3,false,true) # Narrow the list of units down based on the defined parameters
  event.channel.send_temporary_message('Units found, sorting now...',3)
  g=get_markers(event)
  u=@units.map{|q| q}
  k=k2.reject{|q| !has_any?(g, q[13][0])}.uniq if k2.is_a?(Array)
  k=u.reject{|q| !has_any?(g, q[13][0])}.sort{|a,b| a[0]<=>b[0]}.uniq unless k2.is_a?(Array)
  if k.length>=u.reject{|q| !has_any?(g, q[13][0])}.length && !safe_to_spam?(event)
    event.respond "Too much data is trying to be displayed.  Please use this command in PM.\n\nHere is what you typed: ```#{event.message.text}```\nYou can also make things easier by making the list shorter with words like `top#{rand(10)+1}` or `bottom#{rand(10)+1}`"
    return nil
  end
  for i in 0...k.length # remove any units who don't have known stats yet
    k[i]=nil if k[i][5].nil? || k[i][5].max.zero?
  end
  s=['','HP','Attack','Speed','Defense','Resistance','BST','FrzProtect','Photon Points']
  k.compact!
  k=k.reject {|q| find_unit(q[0],event)<0}
  if f.include?(6) || f.include?(7) || f.include?(8)
    for i in 0...k.length
      k[i][5][5]=k[i][5][0]+k[i][5][1]+k[i][5][2]+k[i][5][3]+k[i][5][4]
      k[i][5][6]=[k[i][5][3],k[i][5][4]].min
      k[i][5][7]=k[i][5][3]-k[i][5][4]
    end
  end
  t=0
  b=0
  for i in 0...args.length
    if args[i].downcase[0,3]=='top' && t.zero?
      t=[args[i][3,args[i].length-3].to_i,k.length].min
    elsif args[i].downcase[0,6]=='bottom' && b.zero?
      b=[args[i][6,args[i].length-6].to_i,k.length].min
    end
  end
  k=k.reject{|q| !q[13][0].nil?} if t>0 || b>0
  k.sort! {|b,a| (supersort(a,b,5,f[0]-1)) == 0 ? ((supersort(a,b,5,f[1]-1)) == 0 ? ((supersort(a,b,5,f[2]-1)) == 0 ? ((supersort(a,b,5,f[3]-1)) == 0 ? ((supersort(a,b,5,f[4]-1)) == 0 ? ((supersort(a,b,5,f[5]-1)) == 0 ? ((supersort(a,b,5,f[6]-1)) == 0 ? ((supersort(a,b,5,f[7]-1)) == 0 ? (supersort(a,b,0)) : (supersort(a,b,5,f[7]-1))) : (supersort(a,b,5,f[6]-1))) : (supersort(a,b,5,f[5]-1))) : (supersort(a,b,5,f[4]-1))) : (supersort(a,b,5,f[3]-1))) : (supersort(a,b,5,f[2]-1))) : (supersort(a,b,5,f[1]-1))) : (supersort(a,b,5,f[0]-1))}
  m="Please note that the stats listed are for neutral-nature units without stat-affecting skills.\n"
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
    event.respond "Sorry, but you must specify filters.  I will not sort the entire roster as that would be spam.\nInstead, have the stats of the character whose name in Japanese means \"sort\"."
    disp_stats(bot,'Stahl',nil,event,true)
    return false
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
      if f[j]<6 && !(k[i][4].nil? || k[i][4].max.zero?)
        sfn='(+) ' if [-3,1,5,10,14].include?(k[i][4][f[j]-1])
        sfn='(-) ' if [-2,2,6,11,15].include?(k[i][4][f[j]-1])
      end
      if k[i][5][f[j]-1]<0 && sf.length>0
        k[i][5][f[j]-1]=0-k[i][5][f[j]-1]
        sf="Anti#{sf[0,1].downcase}#{sf[1,sf.length-1]}"
        ls.push("#{k[i][5][f[j]-1]} #{sfn}#{sf}")
      elsif f[j]==8 && k[i][5][f[j]-1]>=5
        ls.push("*#{k[i][5][f[j]-1]} #{sfn}#{sf}*") if sf.length>0
      else
        ls.push("#{k[i][5][f[j]-1]} #{sfn}#{sf}") if sf.length>0
      end
    end
    m2.push("#{'~~' if !k[i][13][0].nil?}**#{k[i][0]}**#{unit_moji(bot,event,-1,k[i][0])} - #{ls.join(', ')}#{'~~' if !k[i][13][0].nil?}")
  end
  if (f.include?(1) || f.include?(2) || f.include?(3) || f.include?(4) || f.include?(5)) && m2.join("\n").include?("(+)") && m2.join("\n").include?("(-)")
    m="#{m}\n(+) and (-) mark units for whom a nature would increase or decrease a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  elsif (f.include?(1) || f.include?(2) || f.include?(3) || f.include?(4) || f.include?(5)) && m2.join("\n").include?("(+)")
    m="#{m}\n(+) marks units for whom a boon would increase a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  elsif (f.include?(1) || f.include?(2) || f.include?(3) || f.include?(4) || f.include?(5)) && m2.join("\n").include?("(-)")
    m="#{m}\n(-) marks units for whom a bane would decrease a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  end
  if f.include?(7) || f.include?(8)
    m="#{m}\nFrzProtect is the lower of the units' Defense and Resistance stats, used by dragonstones when attacking ranged units and by Felicia's Plate all the time." if f.include?(7)
    m="#{m}\nLight Brand deals +7 damage to units with at least 5 Photon Points." if f.include?(8)
    m="#{m}\nThe order of units listed here can be affected by natures that affect a unit's Defense and/or Resistance.\n"
  end
  if "#{m}\n#{m2.join("\n")}".length>2000 && !safe_to_spam?(event)
    event.respond "Too much data is trying to be displayed.  Please use this command in PM.\n\nHere is what you typed: ```#{event.message.text}```\nYou can also make things easier by making the list shorter with words like `top#{rand(10)+1}` or `bottom#{rand(10)+1}`"
    return nil
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
    str="All SP costs are without accounting for increased inheritance costs (1.5x the SP costs listed below)"
    for i in 0...k.length
      k[i][0]="**#{k[i][0]}** "
      if k[i][4]=='Weapon'
        k[i][0]="#{k[i][0]}<:Skill_Weapon:444078171114045450>"
        k[i][0]="#{k[i][0]}<:Red_Blade:443172811830198282>" if k[i][5]=='Sword Users Only'
        k[i][0]="#{k[i][0]}<:Blue_Blade:467112472768151562>" if k[i][5]=='Lance Users Only'
        k[i][0]="#{k[i][0]}<:Green_Blade:467122927230386207>" if k[i][5]=='Axe Users Only'
        k[i][0]="#{k[i][0]}<:Red_Tome:443172811826003968>" if k[i][5]=='Red Tome Users Only'
        k[i][0]="#{k[i][0]}<:Blue_Tome:467112472394858508>" if k[i][5]=='Blue Tome Users Only'
        k[i][0]="#{k[i][0]}<:Green_Tome:467122927666593822>" if k[i][5]=='Green Tome Users Only'
        k[i][0]="#{k[i][0]}<:Gold_Dragon:443172811641454592>" if k[i][5]=='Dragons Only'
        k[i][0]="#{k[i][0]}<:Gold_Bow:443172812492898314>" if k[i][5]=='Bow Users Only'
        k[i][0]="#{k[i][0]}<:Gold_Dagger:443172811461230603>" if k[i][5]=='Dagger Users Only'
        k[i][0]="#{k[i][0]}<:Gold_Staff:443172811628871720>" if k[i][5]=='Staff Users Only' && alter_classes(event,'Colored Healers')
        k[i][0]="#{k[i][0]}<:Colorless_Staff:443692132323295243>" if k[i][5]=='Staff Users Only' && !alter_classes(event,'Colored Healers')
        k[i][0]="#{k[i][0]}<:Gold_Beast:443172811608162324>" if k[i][5]=='Beasts Only'
      elsif k[i][4]=='Assist'
        k[i][0]="#{k[i][0]}<:Skill_Assist:444078171025965066>"
        k[i][0]="#{k[i][0]}<:Assist_Music:454462054959415296>" if k[i][11].split(', ').include?('Music')
        k[i][0]="#{k[i][0]}<:Assist_Rally:454462054619807747>" if k[i][11].split(', ').include?('Rally')
        k[i][0]="#{k[i][0]}<:Assist_Staff:454451496831025162>" if k[i][5]=='Staff Users Only'
      elsif k[i][4]=='Special'
        k[i][0]="#{k[i][0]}<:Skill_Special:444078170665254929>"
        k[i][0]="#{k[i][0]}<:Special_Offensive:454460020793278475>" if k[i][11].split(', ').include?('Offensive')
        k[i][0]="#{k[i][0]}<:Special_Defensive:454460020591951884>" if k[i][11].split(', ').include?('Defensive')
        k[i][0]="#{k[i][0]}<:Special_AoE:454460021665693696>" if k[i][11].split(', ').include?('AoE')
        k[i][0]="#{k[i][0]}<:Special_Healer:454451451805040640>" if k[i][5]=='Staff Users Only'
      else
        k[i][0]="#{k[i][0]}<:Passive_A:443677024192823327>" if k[i][4].split(', ').include?('Passive(A)')
        k[i][0]="#{k[i][0]}<:Passive_B:443677023257493506>" if k[i][4].split(', ').include?('Passive(B)')
        k[i][0]="#{k[i][0]}<:Passive_C:443677023555026954>" if k[i][4].split(', ').include?('Passive(C)')
        k[i][0]="#{k[i][0]}<:Passive_S:443677023626330122>" if k[i][4].split(', ').include?('Passive(S)') || k[i][4].split(', ').include?('Seal')
        k[i][0]="#{k[i][0]}<:Passive_W:443677023706152960>" if k[i][4].split(', ').include?('Passive(W)')
      end
      k[i][0]="#{k[i][0]} - #{k[i][1]} SP"
      if k[i][15]>k[i][1] && k[i][1]>0 && k[i][4]=='Weapon'
        k[i][0]="#{k[i][0]} (#{k[i][15]} SP when refined)"
      elsif k[i][15]==k[i][1] && k[i][1]>0 && k[i][4]=='Weapon'
        k[i][0]="#{k[i][0]} (refinement possible)"
      end
      k[i][0]="#{k[i][0]} - Prf to #{k[i][6]}" unless k[i][6]=='-' || k[i][6].split(', ').length.zero?
    end
    if k.map{|q| q[0]}.join("\n").length+str.length>1950 && !safe_to_spam?(event)
      event.respond "There are too many skills to list.  Please try this command in PM."
      return nil
    end
    for i in 0...k.length
      str=extend_message(str,"#{"\n" if i==0}#{k[i][0]}",event)
    end
    event.respond str
  end
end

def supersort(a,b,m,n=nil)
  unless n.nil?
    return supersort(a,b,0) if n<0
    if a[m][n].is_a?(String) && b[m][n].is_a?(String)
      return b[m][n].downcase <=> a[m][n].downcase
    elsif a[m][n].is_a?(String)
      return -1
    elsif b[m][n].is_a?(String)
      return 1
    else
      return a[m][n] <=> b[m][n]
    end
  end
  if a[m].is_a?(String) && b[m].is_a?(String)
    return b[m].downcase <=> a[m].downcase
  elsif a[m].is_a?(String)
    return -1
  elsif b[m].is_a?(String)
    return 1
  else
    return a[m] <=> b[m]
  end
end

def list_lift(a,c)
  if a.length==1
    return a[0]
  elsif a.length==2
    return "#{a[0]} #{c} #{a[1]}"
  else
    b=a[a.length-1]
    a.pop
    a.uniq!
    return "#{a.join(', ')}, #{c} #{b}"
  end
end

def avg_color(c,mode=0)
  m=[0,0,0]
  for i in 0...c.length
    m[0]+=c[i][0]
    m[1]+=c[i][1]
    m[2]+=c[i][2]
  end
  m[0]/=c.length
  m[1]/=c.length
  m[2]/=c.length
  return m if mode==1
  return 256*256*m[0]+256*m[1]+m[2]
end

def div_100(x)
  return "#{x/100}.#{'0' if x%100<10}#{x%100}"
end

def longFormattedNumber(number,cardinal=false)
  if cardinal
    k='th'
    unless (number%100)/10==1
      k='st' if number%10==1
      k='nd' if number%10==2
      k='rd' if number%10==3
    end
    return "#{longFormattedNumber(number,false)}#{k}"
  end
  return "#{number}" if number<1000
  if number<1000
    bob="#{number%1000}"
  elsif number%1000<10
    bob="00#{number%1000}"
  elsif number%1000<100
    bob="0#{number%1000}"
  elsif number%1000<1000
    bob="#{number%1000}"
  end
  while number>1000
    number=number/1000
    if number<1000
      bob="#{number%1000},#{bob}"
    elsif number%1000<10
      bob="00#{number%1000},#{bob}"
    elsif number%1000<100
      bob="0#{number%1000},#{bob}"
    elsif number%1000<1000
      bob="#{number%1000},#{bob}"
    end
  end
  return bob
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
    if k[i].downcase=="mathoo's"
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
  for i in 0...k.length
    if find_name_in_string(event,sever(k[i]))!=nil
      r=find_stats_in_string(event,sever(k[i]))
      u=@units[find_unit(find_name_in_string(event,sever(k[i])),event)]
      name=u[0]
      if m && find_in_dev_units(name)>=0
        dv=@dev_units[find_in_dev_units(name)]
        r[0]=dv[1]
        r[1]=dv[2]
        r[2]=dv[3].gsub(' ','')
        r[3]=dv[4].gsub(' ','')
        r[2]='' if r[2].nil?
        r[3]='' if r[3].nil?
      end
      st=get_stats(event,name,40,r[0],r[1],r[2],r[3])
      st[0]=st[0].gsub('Lavatain','Laevatein')
      b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]}#{' ' unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}#{name}#{unit_moji(bot,event,-1,name,m,2) if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}",(m && find_in_dev_units(name)>=0),r[0]])
      c.push(unit_color(event,find_unit(find_name_in_string(event,sever(k[i])),event),nil,1,m))
      atkstat.push('Strength') if ['Blade','Bow','Dagger'].include?(u[1][1])
      atkstat.push('Magic') if ['Tome','Healer'].include?(u[1][1])
      atkstat.push('Freeze') if ['Dragon'].include?(u[1][1])
    elsif k[i].downcase=="mathoo's"
      m=true
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
    stemoji=['','<:HP_S:467037520538894336>','<:GenericAttackS:467065089598423051>','<:SpeedS:467037520534962186>','<:DefenseS:467037520249487372>','<:ResistanceS:467037520379641858>']
    if atkstat.uniq.length==1
      stemoji[2]='<:StrengthS:467037520484630539>' if atkstat.uniq[0]=='Strength'
      stemoji[2]='<:MagicS:467043867611627520>' if atkstat.uniq[0]=='Magic'
      stemoji[2]='<:FreezeS:467043868148236299>' if atkstat.uniq[0]=='Freeze'
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
      dzz.push(["**#{b[iz][1].gsub('Lavatain','Laevatein')}**",[unit_moji(bot,event,-1,b[iz][0][0].gsub('Laevatein','Lavatain'),b[iz][2])],0])
      czz.push(c[iz])
      for jz in 1...6
        stz=b[iz][0][jz]
        dzz[iz][2]+=stz
        s=''
        s=' (+)' if [-3,1,5,10,14].include?(b[iz][0][jz+5]) && b[iz][3]==5
        s=' (-)' if [-2,2,6,11,15].include?(b[iz][0][jz+5]) && b[iz][3]==5
        s=' (+)' if [-2,10].include?(b[iz][0][jz+5]) && b[iz][3]==4
        s=' (-)' if [-1,11].include?(b[iz][0][jz+5]) && b[iz][3]==4
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
  stemoji=['','<:HP_S:467037520538894336>','<:GenericAttackS:467065089598423051>','<:SpeedS:467037520534962186>','<:DefenseS:467037520249487372>','<:ResistanceS:467037520379641858>']
  if atkstat.uniq.length==1
    stemoji[2]='<:StrengthS:467037520484630539>' if atkstat.uniq[0]=='Strength'
    stemoji[2]='<:MagicS:467043867611627520>' if atkstat.uniq[0]=='Magic'
    stemoji[2]='<:FreezeS:467043868148236299>' if atkstat.uniq[0]=='Freeze'
  end
  d1=[b[0][1].gsub('Lavatain','Laevatein'),[unit_moji(bot,event,-1,b[0][0][0].gsub('Laevatein','Lavatain'),b[0][2])],0]
  d2=[b[1][1].gsub('Lavatain','Laevatein'),[unit_moji(bot,event,-1,b[1][0][0].gsub('Laevatein','Lavatain'),b[1][2])],0]
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
    s='' unless b[0][1][b[0][1].length-10,10]==' (neutral)' && b[1][1][b[1][1].length-10,10]==' (neutral)' && !names[0].include?("Mathoo's ")
    d1[1].push("#{stzzz[i]}: #{b[0][0][i]}#{s}")
    s=''
    s=' (+)' if [-3,1,5,10,14].include?(b[1][0][i+5]) && b[1][3]==5
    s=' (-)' if [-2,2,6,11,15].include?(b[1][0][i+5]) && b[1][3]==5
    s=' (+)' if [-2,10].include?(b[1][0][i+5]) && b[1][3]==4
    s=' (-)' if [-1,11].include?(b[1][0][i+5]) && b[1][3]==4
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
  str1=str1.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  if ['f?','e?','h?'].include?(str1.downcase[0,2]) || ['feh!','feh?'].include?(str1.downcase[0,4])
    s=event.message.text.downcase
    s=s[2,s.length-2] if ['f?','e?','h?'].include?(str1.downcase[0,2])
    s=s[4,s.length-4] if ['feh!','feh?'].include?(str1.downcase[0,4])
    a=s.split(' ')
    a.shift if all_commands(true).include?(a[0])
    str1=a.join(' ').gsub('!','')
  end
  nicknames_load()
  for i in 0...@multi_aliases.length
    m=@multi_aliases[i][1].map{|q| q}
    m=['Robin'] if m==['Robin(M)', 'Robin(F)'] || m==['Robin(F)', 'Robin(M)']
    return [str1, m, @multi_aliases[i][0].downcase] if @multi_aliases[i][0].downcase==str1
  end
  return nil if robinmode==3 # only allow actual multi-unit aliases without context clues
  k=0
  k=event.server.id unless event.server.nil?
  data_load()
  g=get_markers(event)
  u=@units.reject{|q| !has_any?(g, q[13][0])}
  for i in 0...u.length
    return [str1, [u[i][0]], str1] if str1.downcase==u[i][0].downcase.gsub('(','').gsub(')','')
  end
  for i in 0...@aliases.length
    return [str1, [@aliases[i][1]], @aliases[i][0].downcase] if @aliases[i][0].downcase==str1 && (@aliases[i][2].nil? || @aliases[i][2].include?(k))
  end
  str3=str2.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  str2=str2.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  if /blu(e(-|)|)cina/ =~ str1 || /bluc(i|y)/ =~ str1
    str='blucina'
    str='bluecina' if str2.include?('bluecina')
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Lucina(Spring)','Lucina(Brave)','Lucina(Glorious)'],[str]]
  elsif /ax(e|)(-|)(z|)ura/ =~ str1
    str='ax'
    str="#{str}e" if str2.include?('axe')
    str="#{str}-" if str2.gsub('e','').include?('ax-')
    str="#{str}z" if str2.gsub('e','').gsub('-','').include?('axz')
    str="#{str}ura"
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Azura(Performing)','Azura(Winter)'],[str]]
  elsif /(ephr(ai|ia)m|efuramu)/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='ephraim'
    str='efuramu' if str2.include?('efuramu')
    str='ephriam' if str2.include?('ephriam')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('legendary') || str2.include?('fire')
      return [str,['Ephraim(Fire)'],["legendary#{str}","#{str}legendary","fire#{str}","#{str}fire"]]
    elsif str2.include?('brave') || str2.include?('cyl')
      return [str,['Ephraim(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
    end
    return [str,['Ephraim(Fire)','Ephraim(Brave)'],[str]]
  elsif /(hector|kektor|heckutoru)/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='hector'
    str='kektor' if str2.include?('kektor')
    str='heckutoru' if str2.include?('heckutoru')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('legendary') || str2.include?('marquess') || str2.include?('ostia')
      return [str,['Hector(Marquess)'],["legendary#{str}","#{str}legendary","marquess#{str}","#{str}marquess","ostia#{str}","#{str}ostia"]]
    elsif str2.include?('brave') || str2.include?('cyl')
      return [str,['Hector(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
    end
    return [str,['Hector(Marquess)','Hector(Brave)'],[str]]
  elsif /(ike|aiku)/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='ike'
    str='akiu' if str2.include?('aiku')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('legendary') || str2.include?('radiant') || str2.include?('rd') || str2.include?('vanguard')
      return [str,['Ike(Vanguard)'],["legendary#{str}","#{str}legendary","radiant#{str}","#{str}radiant","rd#{str}","#{str}rd","vanguard#{str}","#{str}vanguard","radiantdawn#{str}","#{str}radiantdawn"]]
    elsif str2.include?('brave') || str2.include?('cyl') || str2.include?('bh')
      return [str,['Ike(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
    end
    return [str,['Ike(Vanguard)','Ike(Brave)'],[str]]
  elsif /(luc(ina|i|y)|rukina)/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='lucina'
    str='rukina' if str2.include?('rukina')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('legendary') || str2.include?('glorious') || str2.include?('ga') || str2.include?('archer')
      return [str,['Lucina(Glorious)'],["legendary#{str}","#{str}legendary","glorious#{str}","#{str}glorious","archer#{str}","#{str}archer","gloriousarcher#{str}","#{str}gloriousarcher","ga#{str}","#{str}ga"]]
    elsif str2.include?('brave') || str2.include?('cyl') || str2.include?('bh')
      return [str,['Lucina(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
    end
    return [str,['Lucina(Glorious)','Lucina(Brave)'],[str]]
  elsif /(eirika|eirik|eiriku|erika)/ =~ str1
    str='eirik'
    str='eiriku' if str2.include?('eiriku')
    str='eirika' if str2.include?('eirika')
    str='erika' if str2.include?('erika')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('bonds') || str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?("#{str}b") || str2.include?("b#{str}") || str2.include?("fb")
      return [str,['Eirika(Bonds)'],["vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","bonds#{str}","b#{str}","fb#{str}","#{str}bonds","#{str}b","#{str}fb"]]
    elsif str2.include?('memories') || str2.include?("#{str}m") || str2.include?("m#{str}") || str2.include?("sm") || str2.include?("mage#{str}") || str2.include?("#{str}mage") || str2.include?("#{str}2")
      return [str,['Eirika(Memories)'],["memories#{str}","mage#{str}","m#{str}","sm#{str}","#{str}memories","#{str}mage","#{str}m","#{str}sm","#{str}2"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Eirika(Bonds)','Eirika(Memories)'],[str]]
  elsif /oliv(ia|ie|e)/ =~ str1
    str='olivia'
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch')
      return [str,['Olivia(Launch)'],["vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","launch#{str}","#{str}launch"]]
    elsif str2.include?('traveler') || str2.include?('travel') || str2.include?('skyhigh') || str2.include?('sky') || str2.include?("#{str}2")
      return [str,['Olivia(Traveler)'],["traveler#{str}","#{str}traveler","travel#{str}","#{str}travel","skyhigh#{str}","#{str}skyhigh","sky#{str}","#{str}sky","#{str}2"]]
    elsif str2.include?('performing') || str2.include?('performance') || str2.include?('arts') || str2.include?('pa')
      return [str,['Olivia(Performing)'],["performing#{str}","#{str}performing","performance#{str}","#{str}performance","arts#{str}","#{str}arts","pa#{str}","#{str}pa"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Olivia(Launch)','Olivia(Traveler)'],[str]]
  elsif /hinoka/ =~ str1
    str='hinoka'
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch')
      return [str,['Hinoka(Launch)'],["vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","launch#{str}","#{str}launch"]]
    elsif str2.include?('wings') || str2.include?('kinshi') || str2.include?('winged') || str2.include?("#{str}2")
      return [str,['Hinoka(Wings)'],["wings#{str}","#{str}wings","kinshi#{str}","#{str}kinshi","winged#{str}","#{str}winged","#{str}2"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Hinoka(Launch)','Hinoka(Wings)'],[str]]
  elsif /nino/ =~ str1
    str='nino'
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch')
      return [str,['Nino(Launch)'],["vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","launch#{str}","#{str}launch"]]
    elsif str2.include?('fangs') || str2.include?('fanged') || str2.include?('fang') || str2.include?('sf') || str2.include?('pegasus')
      return [str,['Nino(Fangs)'],["wings#{str}","#{str}wings","kinshi#{str}","#{str}kinshi","winged#{str}","#{str}winged","#{str}2","#{str}sf","sf#{str}","#{str}pegasus","pegasus#{str}"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Nino(Launch)','Nino(Fangs)'],[str]]
  elsif /(chrom|kuromu)/ =~ str1
    str='chrom'
    str='kuromu' if str2.include?('kuromu')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('winter') || str2.include?('christmas') || str2.include?('holiday') || str2.include?('we')
      return [str,['Chrom(Winter)'],["winter#{str}","#{str}winter","christmas#{str}","#{str}christmas","holiday#{str}","#{str}holiday","we#{str}","#{str}we"]]
    elsif str2.include?('bunny') || str2.include?('spring') || str2.include?('easter') || str2.include?('sf')
      return [str,['Chrom(Spring)'],["bunny#{str}","#{str}bunny","spring#{str}","#{str}spring","easter#{str}","#{str}easter","sf#{str}","#{str}sf"]]
    elsif str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch') || str2.include?('prince')
      return [str,['Chrom(Launch)'],["launch#{str}","#{str}launch","vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","prince#{str}","#{str}prince"]]
    elsif str2.include?('branded') || str2.include?('brand') || str2.include?('exalted') || str2.include?('exalt') || str2.include?('king') || str2.include?('sealed') || str2.include?('horse') || str2.include?('knight')
      return [str,['Chrom(Branded)'],["branded#{str}","#{str}branded","brand#{str}","#{str}brand","exalted#{str}","#{str}exalted","exalt#{str}","#{str}exalt","king#{str}","#{str}king","sealed#{str}","#{str}sealed","horse#{str}","#{str}horse","knight#{str}","#{str}knight"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Chrom(Launch)','Chrom(Branded)'],[str]]
  elsif /(reinhardt|rainharuto)/ =~ str1
    str='reinhardt'
    str='rainharuto' if str2.include?('rainharuto')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('bonds') || str2.include?("#{str}b") || str2.include?("b#{str}") || str2.include?("sb") || str2.include?("mage#{str}") || str2.include?("#{str}mage")
      return [str,['Reinhardt(Bonds)'],["bonds#{str}","#{str}bonds","b#{str}","#{str}b","sb#{str}","#{str}sb","mage#{str}","#{str}mage"]]
    elsif str2.include?('world') || str2.include?('warudo') || str2.include?("#{str}w") || str2.include?("w#{str}") || str2.include?('wot') || str2.include?('wt') || str2.include?("#{str}2")
      return [str,['Reinhardt(World)'],["world#{str}","#{str}world","warudo#{str}","#{str}warudo","w#{str}","#{str}w","wot#{str}","#{str}wot","wt#{str}","#{str}wt","#{str}2"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Reinhardt(Bonds)','Reinhardt(World)'],[str]]
  elsif /(olwen|oruen)/ =~ str1
    str='olwen'
    str='oruen' if str2.include?('oruen')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('bonds') || str2.include?("#{str}b") || str2.include?("b#{str}") || str2.include?("sb")
      return [str,['Olwen(Bonds)'],["bonds#{str}","#{str}bonds","b#{str}","#{str}b","sb#{str}","#{str}sb"]]
    elsif str2.include?('world') || str2.include?('warudo') || str2.include?('Wind') || str2.include?("#{str}w") || str2.include?("w#{str}") || str2.include?('wot') || str2.include?('wt') || str2.include?("#{str}2")
      return [str,['Olwen(World)'],["world#{str}","#{str}world","warudo#{str}","#{str}warudo","w#{str}","#{str}w","wot#{str}","#{str}wot","wt#{str}","#{str}wt","#{str}2"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Olwen(Bonds)','Olwen(World)'],[str]]
  elsif /(tiki|chiki)/ =~ str1
    str="tiki"
    str="chiki" if str2.include?("chiki")
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    if str2.include?("summer") || str2.include?("beach") || str2.include?("swimsuit")
      strx='summer'
      strx='beach' if str2.include?('beach')
      strx='swimsuit' if str2.include?('swimsuit')
      str2=str3.gsub(strx,'').gsub("#{str} ",str).gsub(" #{str}",str)
      m=["#{strx}#{str}","#{str}#{strx}","#{strx} #{str}","#{str} #{strx}"]
      if str2.include?('adult') || str2.include?('old') || str2.include?('bae') || str2.include?("#{str}a") || str2.include?("a#{str}")
        for i in 0...m.length
          return [m[i],['Tiki(Adult)(Summer)'],m] if event.message.text.downcase.include?(m[i])
        end
        return [str,['Tiki(Adult)(Summer)'],m]
      elsif str2.include?('young') || str2.include?('child') || str2.include?('loli') || str2.include?("#{str}c") || str2.include?("c#{str}") || str2.include?("#{str}y") || str2.include?("y#{str}")
        for i in 0...m.length
          return [m[i],['Tiki(Young)(Summer)'],m] if event.message.text.downcase.include?(m[i])
        end
        return [str,['Tiki(Young)(Summer)'],m]
      end
      for i in 0...m.length
        return [m[i],['Tiki(Adult)(Summer)','Tiki(Young)(Summer)'],m] if event.message.text.downcase.include?(m[i])
      end
      return [str,['Tiki(Adult)(Summer)','Tiki(Young)(Summer)'],m]
    end
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("#{str}ys") || str2.include?("ys#{str}")
      return [str,['Tiki(Adult)(Summer)'],["ys#{str}","#{str}ys"]]
    elsif str2.include?("#{str}ss") || str2.include?("ss#{str}")
      return [str,['Tiki(Young)(Summer)'],["ss#{str}","#{str}ss"]]
    elsif str2.include?('young') || str2.include?('child') || str2.include?('loli') || str2.include?("#{str}c") || str2.include?("c#{str}") || str2.include?("#{str}y") || str2.include?("y#{str}")
      return [str,['Tiki(Young)'],["#{str}young","#{str}child","#{str}loli","#{str}y","#{str}c","young#{str}","child#{str}","loli#{str}","y#{str}","c#{str}"]]
    elsif str2.include?('adult') || str2.include?('old') || str2.include?('bae') || str2.include?("#{str}a") || str2.include?("a#{str}")
      return [str,['Tiki(Adult)'],["#{str}adult","#{str}bae","#{str}a","adult#{str}","bae#{str}","a#{str}"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Tiki(Young)','Tiki(Adult)'],[str]]
  elsif /(robin|reflet|daraen)/ =~ str1
    str='robin'
    str='reflet' if str2.include?('reflet')
    str='daraen' if str2.include?('daraen')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    if str=='robin' && (str2.include?('gaiden') || str2.include?('sov'))
      return [str,['Tobin'],['robingaiden','robinsov','gaidenrobin','sovrobin']]
    elsif str2.include?('summer') || str2.include?('beach') || str2.include?('swimsuit') || str2.include?('ys')
      return [str,['Robin(F)(Summer)'],["summer#{str}","beach#{str}","swimsuit#{str}","ys#{str}","#{str}summer","#{str}beach","#{str}swimsuit","#{str}ys"]]
    elsif str2.include?('winter') || str2.include?('christmas') || str2.include?('holiday') || str2.include?('we')
      return [str,['Robin(M)(Winter)'],["winter#{str}","christmas#{str}","holiday#{str}","we#{str}","#{str}winter","#{str}christmas","#{str}holiday","#{str}we"]]
    elsif str2.include?('fallen') || str2.include?('evil') || str2.include?('dark') || str2.include?('alter') || str2.include?('fh') || str2.include?('grima')
      strx='fallen'
      strx='evil' if str2.include?('evil')
      strx='dark' if str2.include?('dark')
      strx='alter' if str2.include?('alter')
      strx='fh' if str2.include?('fh')
      strx='grima' if str2.include?('grima')
      str2=str3.gsub(strx,'').gsub("#{str} ",str).gsub(" #{str}",str)
      m=["#{strx}#{str}","#{str}#{strx}","#{strx} #{str}","#{str} #{strx}"]
      if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}") || str2.include?("legendary") || str2.include?("#{str}lh") || str2.include?("lh#{str}")
        for i in 0...m.length
          return [m[i],['Robin(F)(Fallen)'],m] if event.message.text.downcase.include?(m[i])
        end
        return [str,['Robin(F)(Fallen)'],m]
      elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
        for i in 0...m.length
          return [m[i],['Robin(M)(Fallen)'],m] if event.message.text.downcase.include?(m[i])
        end
        return [str,['Robin(M)(Fallen)'],m]
      end
      for i in 0...m.length
        return [m[i],['Robin(M)(Fallen)','Robin(F)(Fallen)'],m] if event.message.text.downcase.include?(m[i])
      end
      return [str,['Robin(M)(Fallen)','Robin(F)(Fallen)'],m]
    elsif str2.include?('legendary')
      return [str,['Robin(F)(Fallen)'],["legendary#{str}","#{str}legendary"]]
    end
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Robin(F)'],["female#{str}","f#{str}","#{str}female","#{str}f"]]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Robin(M)'],["male#{str}","m#{str}","#{str}male","#{str}m"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Robin'],[str]] if robinmode.zero?
    return [str,['Robin(M)','Robin(F)'],[str]] if robinmode==1
  elsif /grima/ =~ str1
    str='grima'
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}") || str2.include?('legendary') || str2.include?("#{str}lh") || str2.include?("lh#{str}")
      return [str,['Robin(F)(Fallen)'],["legendary#{str}","#{str}legendary","female#{str}","f#{str}","#{str}female","#{str}f","lh#{str}","#{str}lh"]]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Robin(M)(Fallen)'],["male#{str}","m#{str}","#{str}male","#{str}m"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Robin(M)(Fallen)','Robin(F)(Fallen)'],[str]]
  elsif /(corrin|kamui)/ =~ str1
    str='corrin'
    str='kamui' if str1.include?('kamui')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    if str=='kamui' && (str2.include?('gaiden') || str2.include?('sov')) && find_unit('Kamui',event,true)>-1
      return [str,['Kamui'],['kamuigaiden','kamuisov','gaidenkamui','sovkamui']]
    elsif str2.include?('summer') || str2.include?('beach') || str2.include?('swimsuit') || str2.include?('ns')
      return [str,['Corrin(F)(Summer)']]
    elsif str2.include?('winter') || str2.include?('newyear') || str2.include?('holiday') || str2.include?('ny')
      return [str,['Corrin(M)(Winter)']]
    end
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('female') || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Corrin(F)'],["female#{str}","f#{str}","#{str}female","#{str}f"]]
    elsif str2.include?('male') || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Corrin(M)'],["male#{str}","m#{str}","#{str}male","#{str}m"]]
    end
    return [str,['Kamui'],[str]] if str=='kamui' && find_unit('Kamui',event,true)>-1
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Corrin(M)','Corrin(F)'],[str]]
  elsif /(morgan|marc|linfan)/ =~ str1
    str='morgan'
    str='marc' if str2.include?('marc')
    str='linfan' if str2.include?('linfan')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("lass#{str}") || str2.include?("#{str}lass") || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Morgan(F)'],["female#{str}","f#{str}","#{str}female","#{str}f"]]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("lad#{str}") || str2.include?("#{str}lad") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Morgan(M)'],["male#{str}","m#{str}","#{str}male","#{str}m"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Morgan(M)','Morgan(F)'],[str]]
  elsif /kan(n|)a/ =~ str1
    str='kana'
    str='kanna' if str2.include?('kanna')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Kana(F)'],["female#{str}","f#{str}","#{str}female","#{str}f"]]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Kana(M)'],["male#{str}","m#{str}","#{str}male","#{str}m"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Kana(M)','Kana(F)'],[str]]
  elsif /(lyn(dis||)|rin(disu|))/ =~ str1
    return nil if find_name_in_string(event,str1)
    str='lyn'
    str='rin' if str2.include?('rin')
    str='lyndis' if str2.include?('lyndis')
    str='rindisu' if str2.include?('rindisu')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('ethlyn')
      return [str,['Ethlyn'],[str]]
    elsif str2.include?("bb#{str}") || str2.include?("#{str}bb") || str2.include?('bride') || str2.include?('bridal') || str2.include?('wedding')
      return [str,['Lyn(Bride)'],["bb#{str}","#{str}bb","#{str}bride","#{str}bridal","#{str}wedding","bride#{str}","bridal#{str}","wedding#{str}"]]
    elsif str2.include?('brave') || str2.include?('cyl') || str2.include?('nomad') || str2.include?("bh#{str}") || str2.include?("#{str}bh")
      return [str,['Lyn(Brave)'],["brave#{str}","nomad#{str}","cyl#{str}","bh#{str}","#{str}nomad","#{str}brave","#{str}cyl","#{str}bh"]]
    elsif str2.include?('abounds') || str2.include?('valentines') || str2.include?("valentine's") || str2.include?("la#{str}") || str2.include?("#{str}la") || str2.include?("v#{str}") || str2.include?("#{str}v")
      return [str,['Lyn(Valentines)'],["love#{str}","abounds#{str}","valentines#{str}","valentine's#{str}","#{str}love","#{str}abounds","#{str}valentines","#{str}valentine's","la#{str}","#{str}la"]]
    elsif str2.include?('winds') || str2.include?('wind') || str2.include?('bladelord') || str2.include?('legendary') || str2.include?("#{str}lh") || str2.include?("lh#{str}")
      return [str,['Lyn(Wind)'],["wind#{str}","#{str}wind","bladelord#{str}","#{str}bladelord","#{str}legendary","legendary#{str}","lh#{str}","#{str}lh"]]
    elsif str2.include?('love')
      return [str,['Lyn(Bride)','Lyn(Valentines)'],["love#{str}","#{str}love"]]
    elsif str2.include?('bow') || str2.include?('archer')
      return [str,['Lyn(Brave)','Lyn(Wind)'],["#{str}bow","#{str}archer","bow#{str}","archer#{str}"]]
    elsif str2.include?("b#{str}") || str2.include?("br#{str}")
      return [str,['Lyn(Bride)','Lyn(Brave)'],["b#{str}","br#{str}"]]
    elsif str2.include?('eth')
      return [str,['Ethlyn'],[str]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Lyn'],[str]]
  end
  return nil
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

def prio(arr,o)
  x=[]
  for i in 0...o.length
    x.push(o[i]) if arr.include?(o[i])
  end
  return x
end

def disp_unit_stats_and_skills(event,args,bot)
  event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) if event.message.text.length>90
  k=find_name_in_string(event,nil,1)
  w=nil
  if k.nil?
    if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
      event.respond "Steel's waifu is not in the game."
    elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
      event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
    elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
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
    elsif k[i].downcase=="mathoo's"
      k2.push(str)
    end
  end
  k=k2.map{|q| q}
  b=[]
  c=[]
  m=false
  for i in 0...k.length
    if find_name_in_string(event,sever(k[i]))!=nil
      r=find_stats_in_string(event,sever(k[i]))
      u=@units[find_unit(find_name_in_string(event,sever(k[i])),event)]
      name=u[0]
      if m && find_in_dev_units(name)>=0
        dv=@dev_units[find_in_dev_units(name)]
        r[0]=dv[1]
      end
      st=[]
      st=unit_skills(name,event,false,r[0]) if i<=1
      b.push([st,"#{r[0]}#{@rarity_stars[r[0]-1]} #{name} #{unit_moji(bot,event,-1,name,m)}",name])
      c.push(unit_color(event,find_unit(find_name_in_string(event,sever(k[i])),event),nil,1,m))
    elsif k[i].downcase=="mathoo's"
      m=true
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
  u=@units[@units.find_index{|q| q[0]==name}]
  w=@skills[@skills.find_index{|q| q[0]==weapon}]
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
  end
  w2="#{weapon}"
  w2="#{weapon} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  return "~~#{w2}~~" if w[6]!='-' && !w[6].split(', ').include?(u[0]) # prf weapons are illegal on anyone but their holders
  u2=weapon_clss(u[1],event)
  u2='Bow' if u2.include?('Bow')
  u2='Dagger' if u2.include?('Dagger')
  u2="#{u2.gsub('Healer','Staff')} Users Only"
  u2='Dragons Only' if u[1][1]=='Dragon'
  u2='Beasts Only' if u[1][1]=='Beast'
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
  end
  return "~~#{w2}~~"
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
  p=[['1<:Icon_Rarity_1:448266417481973781> exclusive',[]],['1<:Icon_Rarity_1:448266417481973781>-2<:Icon_Rarity_2:448266417872044032>',[]],['2<:Icon_Rarity_2:448266417872044032> exclusive',[]],['2<:Icon_Rarity_2:448266417872044032>-3<:Icon_Rarity_3:448266417934958592>',[]],['3<:Icon_Rarity_3:448266417934958592> exclusive',[]],['3<:Icon_Rarity_3:448266417934958592>-4<:Icon_Rarity_4:448266418459377684>',[]],['4<:Icon_Rarity_4:448266418459377684> exclusive',[]],['4<:Icon_Rarity_4:448266418459377684>-5<:Icon_Rarity_5:448266417553539104>',[]],['5<:Icon_Rarity_5:448266417553539104> exclusive',[]],['Other',[]]]
  for i in 0...clr.length
    if clr[i][9][0].include?('1p')
      if clr[i][9][0].include?('2p')
        p[1][1].push(clr[i][0])
      elsif clr[i][9][0].include?('3p') || clr[i][9][0].include?('4p') || clr[i][9][0].include?('5p')
        p[9][0][1].push("#{clr[i][0]} - 1#{'/3' if clr[i][9][0].include?('3p')}#{'/4' if clr[i][9][0].include?('4p')}#{'/5' if clr[i][9][0].include?('5p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[0][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('2p')
      if clr[i][9][0].include?('3p')
        p[3][1].push(clr[i][0])
      elsif clr[i][9][0].include?('4p') || clr[i][9][0].include?('5p')
        p[9][0][1].push("#{clr[i][0]} - 2#{'/4' if clr[i][9][0].include?('4p')}#{'/5' if clr[i][9][0].include?('5p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[2][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('3p')
      if clr[i][9][0].include?('4p')
        p[5][1].push(clr[i][0])
      elsif clr[i][9][0].include?('5p')
        p[9][0][1].push("#{clr[i][0]} - 3/5<:Icon_Rarity_S:448266418035621888>")
      else
        p[4][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('4p')
      if clr[i][9][0].include?('5p')
        p[7][1].push(clr[i][0])
      else
        p[6][1].push(clr[i][0])
      end
    elsif clr[i][9][0].include?('5p')
      p[8][1].push(clr[i][0])
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

def sort_legendaries(event,bot,mode=0)
  data_load()
  nicknames_load()
  g=get_markers(event)
  k=@units.reject{|q| !has_any?(g, q[13][0]) || q[2].nil? || q[2][0]==' ' || q[2].length<3}.uniq
  c=[]
  for i in 0...k.length
    c.push([102,218,250]) if k[i][2][0]=='Water'
    c.push([222,95,9]) if k[i][2][0]=='Earth'
    c.push([122,233,112]) if k[i][2][0]=='Wind'
    c.push([242,70,58]) if k[i][2][0]=='Fire'
    c.push([64,0,128]) if k[i][2][0]=='Dark'
    k[i][2][2]=k[i][2][2].split('/').map{|q| q.to_i}.reverse
    k[i][1][1]=1 if k[i][1][0]=='Red'
    k[i][1][1]=2 if k[i][1][0]=='Blue'
    k[i][1][1]=3 if k[i][1][0]=='Green'
    k[i][1][1]=4 if k[i][1][0]=='Colorless'
    k[i][1][1]=5 if k[i][1][1].is_a?(String)
  end
  k=k.sort{|a,b| ((a[2][2]<=>b[2][2]) == 0 ? ((a[1][1]<=>b[1][1]) == 0 ? a[0]<=>b[0] : a[1][1]<=>b[1][1]) : a[2][2]<=>b[2][2])}
  for i in 0...k.length
    m=k[i][2][2].reverse
    k[i][1][2]=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Orb_#{['','Red','Blue','Green','Colorless','Gold'][k[i][1][1]]}"}[0].mention
    if m[0]<11
      m[0]='Early '
    elsif m[0]<21
      m[0]='Mid-'
    else
      m[0]='Late '
    end
    m[1]=['','January','February','March','April','May','June','July','August','September','October','November','December'][m[1]]
    k[i][2][2]="#{m[0]}#{m[1]} #{m[2]}"
  end
  m=0
  k2=[[k[0][2][2],[[k[0][1][1],"#{k[0][1][2]} - #{k[0][0]}"]]]]
  for i in 1...k.length
    if k[i][2][2]==k2[m][0]
      k2[m][1].push([k[i][1][1],"#{k[i][1][2]} - #{k[i][0]}"])
    else
      m+=1
      k2.push([k[i][2][2],[[k[i][1][1],"#{k[i][1][2]} - #{k[i][0]}"]]])
    end
  end
  for i in 0...k2.length
    k2[i][1].push([1,'<:Orb_Red:455053002256941056> - *unknown*']) unless k2[i][1].reject{|q| q[0]!=1}.length>0
    k2[i][1].push([2,'<:Orb_Blue:455053001971859477> - *unknown*']) unless k2[i][1].reject{|q| q[0]!=2}.length>0
    k2[i][1].push([3,'<:Orb_Green:455053002311467048> - *unknown*']) unless k2[i][1].reject{|q| q[0]!=3}.length>0
    k2[i][1].push([4,'<:Orb_Colorless:455053002152083457> - *unknown*']) unless k2[i][1].reject{|q| q[0]!=4}.length>0
    k2[i][1]=k2[i][1].sort{|a,b| a[0]<=>b[0]}.map{|q| q[1]}.join("\n")
  end
  t=Time.now
  timeshift=8
  t-=60*60*timeshift
  tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
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
    b[i]=nil if b[i][2][0]=='-' && b[i][4].nil?
  end
  b.compact!
  b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i<=tm || q[5].nil? || !q[5].split(', ').include?('Legendary') || q[2][0]=='-' || q[2].length<4}
  if b2.length>0
    m=[]
    for i in 0...b2.length
      for j in 0...b2[i][2].length
        m.push(b2[i][2][j])
      end
    end
    m.uniq!
    data_load()
    k=@units.reject{|q| !has_any?(g, q[13][0]) || q[2].nil? || q[2][0]==' ' || q[2].length<2}.uniq
    m=m.reject{|q| !k.map{|q2| q2[0]}.include?(q)}
    k=k.reject{|q| !m.include?(q[0])}
    for i in 0...k.length
      k[i][1][1]=1 if k[i][1][0]=='Red'
      k[i][1][1]=2 if k[i][1][0]=='Blue'
      k[i][1][1]=3 if k[i][1][0]=='Green'
      k[i][1][1]=4 if k[i][1][0]=='Colorless'
      k[i][1][1]=5 if k[i][1][1].is_a?(String)
      k[i][1][2]=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Orb_#{['','Red','Blue','Green','Colorless','Gold'][k[i][1][1]]}"}[0].mention
    end
    k=k.sort{|a,b| ((a[1][1]<=>b[1][1]) == 0 ? a[0]<=>b[0] : a[1][1]<=>b[1][1])}.map{|q| "#{q[1][2]} - #{q[0]}"}.join("\n")
    k2.unshift(['Upcoming banner',k]) unless k==k2[0][1]
  end
  b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i>tm || q[4].split(', ')[1].split('/').reverse.join('').to_i<tm || q[5].nil? || !q[5].split(', ').include?('Legendary')}
  if b2.length>0
    m=[]
    for i in 0...b2.length
      for j in 0...b2[i][2].length
        m.push(b2[i][2][j])
      end
    end
    m.uniq!
    data_load()
    k=@units.reject{|q| !has_any?(g, q[13][0]) || q[2].nil? || q[2][0]==' ' || q[2].length<2}.uniq
    m=m.reject{|q| !k.map{|q2| q2[0]}.include?(q)}
    k=k.reject{|q| !m.include?(q[0])}
    for i in 0...k.length
      k[i][1][1]=1 if k[i][1][0]=='Red'
      k[i][1][1]=2 if k[i][1][0]=='Blue'
      k[i][1][1]=3 if k[i][1][0]=='Green'
      k[i][1][1]=4 if k[i][1][0]=='Colorless'
      k[i][1][1]=5 if k[i][1][1].is_a?(String)
      k[i][1][2]=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Orb_#{['','Red','Blue','Green','Colorless','Gold'][k[i][1][1]]}"}[0].mention
    end
    k=k.sort{|a,b| ((a[1][1]<=>b[1][1]) == 0 ? a[0]<=>b[0] : a[1][1]<=>b[1][1])}.map{|q| "#{q[1][2]} - #{q[0]}"}.join("\n")
    k2.unshift(['Current banner',k])
  end
  if mode==1
    return k2.map{|q| "*#{q[0]}*: #{q[1].gsub("\n",', ').gsub(' - ','')}"}.join("\n")
  else
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond k2.map{|q| "__#{q[0]}__\n#{q[1]}"}.join("\n\n")
    else
      create_embed(event,"__**Legendary Heroes' Appearances**__",'',avg_color(c),nil,nil,k2,2)
    end
    if safe_to_spam?(event)
      b2=b.reject{|q| q[5].nil? || !q[5].split(', ').include?('Legendary')}
      m=[]
      for i in 0...b2.length
        for j in 0...b2[i][2].length
          m.push(b2[i][2][j])
        end
      end
      m.uniq!
      data_load()
      k=@units.reject{|q| !q[13][0].nil? || q[2].nil? || q[2][0]!=' ' || q[9][0]!='5s' || m.include?(q[0])}.uniq
      m2=[['<:Orb_Red:455053002256941056>Red',[]],['<:Orb_Blue:455053001971859477>Blue',[]],['<:Orb_Green:455053002311467048>Green',[]],['<:Orb_Colorless:455053002152083457>Colorless',[]],['<:Orb_Pink:466196714513235988>Gold',[]]]
      for i in 0...k.length
        m2[0][1].push(k[i][0]) if k[i][1][0]=='Red'
        m2[1][1].push(k[i][0]) if k[i][1][0]=='Blue'
        m2[2][1].push(k[i][0]) if k[i][1][0]=='Green'
        m2[3][1].push(k[i][0]) if k[i][1][0]=='Colorless'
        m2[4][1].push(k[i][0]) unless ['Red','Blue','Green','Colorless'].include?(k[i][1][0])
      end
      m2=m2.reject{|q| q[1].length<=0}
      j="\n"
      j=', ' if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      for i in 0...m2.length
        m2[i][1]=m2[i][1].join(j)
      end
      if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        event.respond "__**Seasonal units that have not yet been on a Legendary Banner**__\n#{m2.map{|q| "*#{q[0]}*: #{q[1]}"}}"
      else
        create_embed(event,"__**Seasonal units that have not yet been on a Legendary Banner**__",'',0x9400D3,nil,nil,m2,2)
      end
      data_load()
      k=@units.reject{|q| !q[13][0].nil? || q[2].nil? || q[2][0]!=' ' || q[9][0]!='5p' || m.include?(q[0])}.uniq
      m2=[['<:Orb_Red:455053002256941056>Red',[]],['<:Orb_Blue:455053001971859477>Blue',[]],['<:Orb_Green:455053002311467048>Green',[]],['<:Orb_Colorless:455053002152083457>Colorless',[]],['<:Orb_Gold:455053002911514634>Gold',[]]]
      for i in 0...k.length
        m2[0][1].push(k[i][0]) if k[i][1][0]=='Red'
        m2[1][1].push(k[i][0]) if k[i][1][0]=='Blue'
        m2[2][1].push(k[i][0]) if k[i][1][0]=='Green'
        m2[3][1].push(k[i][0]) if k[i][1][0]=='Colorless'
        m2[4][1].push(k[i][0]) unless ['Red','Blue','Green','Colorless'].include?(k[i][1][0])
      end
      m2=m2.reject{|q| q[1].length<=0}
      j="\n"
      j=', ' if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      for i in 0...m2.length
        m2[i][1]=m2[i][1].join(j)
      end
      if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        event.respond "__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units that have not yet been on a Legendary Banner**__\n#{m2.map{|q| "*#{q[0]}*: #{q[1]}"}}"
      else
        create_embed(event,"__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units that have not yet been on a Legendary Banner**__",'',0x9400D3,nil,nil,m2,2)
      end
    end
  end
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
    weapons.push('Blade') if ['physical','blade','blades'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','magic','spell','tomes','mages','spells'].include?(args[i].downcase)
    weapons.push('Breath') if ['dragon','dragons','breath','manakete','manaketes'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thieves'].include?(args[i].downcase)
    weapons.push('Healer') if ['healer','staff','cleric','healers','clerics','staves'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz'].include?(args[i].downcase) && event.server.id==256291408598663168
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
    color_weapons=[['Red', 'Blade'],     ['Red', 'Tome'],     ['Red', 'Breath'],      ['Red', 'Bow'],         ['Red', 'Dagger'],
                   ['Blue', 'Blade'],    ['Blue', 'Tome'],    ['Blue', 'Breath'],     ['Blue', 'Bow'],        ['Blue', 'Dagger'],
                   ['Green', 'Blade'],   ['Green', 'Tome'],   ['Green', 'Breath'],    ['Green', 'Bow'],       ['Green', 'Dagger'],
                                                              ['Colorless', 'Breath'],['Colorless', 'Bow'],   ['Colorless', 'Dagger']]
    color_weapons.push(['Colorless', 'Blade']) if alter_classes(event,'Colorless Blades')
    color_weapons.push(['Colorless', 'Tome']) if alter_classes(event,'Colorless Tomes')
    unless event.message.text.downcase.split(' ').include?('singer') || event.message.text.downcase.split(' ').include?('dancer')
      color_weapons.push(['Red', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Blue', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Green', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Colorless', 'Healer'])
    end
    unless event.server.nil?
      color_weapons.push(['Gold', 'Beast']) if event.server.id==256291408598663168
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
  gps[0]=rand(@mods.length-3)+1 if gps[0]<2 || gps[0]>14
  gps[0]=rand(@mods.length-3)+1 if gps[0]<2 || gps[0]>14
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
    gps[1]=min_possible+rand(max_possible-min_possible+1) if gps[1]<2 || gps[1]>14
    gps[1]=min_possible+rand(max_possible-min_possible+1) if gps[1]<2 || gps[1]>14
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
    gps[2]=min_possible+rand(max_possible-min_possible+1) if gps[2]<2 || gps[2]>14
    gps[2]=min_possible+rand(max_possible-min_possible+1) if gps[2]<2 || gps[2]>14
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
    gps[3]=min_possible+rand(max_possible-min_possible+1) if gps[3]<2 || gps[3]>14
    gps[3]=min_possible+rand(max_possible-min_possible+1) if gps[3]<2 || gps[3]>14
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
    gps[i]-=2
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
  if w=='*Red Tome*'
    w="*#{['Fire','Dark'].sample} Mage* (Red Tome)"
  elsif w=='*Green Tome*'
    w="*#{['Wind'].sample} Mage* (Green Tome)"
  elsif w=='*Blue Tome*'
    w="*#{['Thunder','Light'].sample} Mage* (Blue Tome)"
  end
  atk='<:GenericAttackS:467065089598423051> Attack'
  atk='<:MagicS:467043867611627520> Magic' if ['Tome','Healer'].include?(clazz[1])
  atk='<:FreezeS:467043868148236299> Magic' if ['Dragon'].include?(clazz[1])
  atk='<:StrengthS:467037520484630539> Strength' if ['Blade','Bow','Dagger','Beast'].include?(clazz[1])
  r='<:Icon_Rarity_5:448266417553539104>'*5
  flds=[['**Level 1**',"<:HP_S:467037520538894336> HP: #{stats[0]}\n#{atk}: #{stats[1]}\n<:SpeedS:467037520534962186> Speed: #{stats[2]}\n<:DefenseS:467037520249487372> Defense: #{stats[3]}\n<:ResistanceS:467037520379641858> Resistance: #{stats[4]}\n\nBST: #{stats[10]}"]]
  args=args.map{|q| q.downcase}
  if args.include?('gps') || args.include?('gp') || args.include?('growths') || args.include?('growth')
    flds.push(['**Growth Rates**',"<:HP_S:467037520538894336> HP: #{micronumber(gps[0])} / #{gps[0]*5+20}%\n#{atk}: #{micronumber(gps[1])} / #{gps[1]*5+20}%\n<:SpeedS:467037520534962186> Speed: #{micronumber(gps[2])} / #{gps[2]*5+20}%\n<:DefenseS:467037520249487372> Defense: #{micronumber(gps[3])} / #{gps[3]*5+20}%\n<:ResistanceS:467037520379641858> Resistance: #{micronumber(gps[4])} / #{gps[4]*5+20}%\n\n\u0262\u1D18\u1D1B #{micronumber(gps[0]+gps[1]+gps[2]+gps[3]+gps[4])} / GRT: #{(gps[0]+gps[1]+gps[2]+gps[3]+gps[4])*5+100}%"])
  end
  flds.push(['**Level 40**',"<:HP_S:467037520538894336> HP: #{stats[5]}\n#{atk}: #{stats[6]}\n<:SpeedS:467037520534962186> Speed: #{stats[7]}\n<:DefenseS:467037520249487372> Defense: #{stats[8]}\n<:ResistanceS:467037520379641858> Resistance: #{stats[9]}\n\nBST: #{stats[11]}"])
  img=nil
  ftr=nil
  unless event.server.nil?
    imgx=event.server.users.sample
    imgx=event.user if rand(100).zero? && event.server.users.length>100
    img=imgx.avatar_url
    ftr="Unit profile provided by #{imgx.distinct}"
  end
  wemote=''
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clazz[0]}_#{clazz[1].gsub('Healer','Staff')}"}
  wemote=moji[0].mention unless moji.length<=0
  memote=''
  moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{mov}"}
  memote=moji[0].mention unless moji.length<=0
  clazz3=clazz2.reject{|q| ['Dancer','Singer'].include?(q)}
  create_embed(event,"__**#{name}**__","#{r}\nNeutral nature\n#{wemote} #{w}\n#{memote} *#{mov}*#{"\n<:Assist_Music:454462054959415296> *Dancer*" if clazz2.include?('Dancer')}#{"\n<:Assist_Music:454462054959415296> *Singer*" if clazz2.include?('Singer')}\n#{"Additional Modifier#{'s' if clazz3.length>1}: #{clazz3.map{|q| "*#{q}*"}.join(', ')}" if clazz3.length>0}",xcolor,ftr,img,flds,1)
  return nil
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
    m.push('community-voted') if @aliases.reject{|q| q[1]!=k[i][0] || !q[2].nil?}.map{|q| q[0]}.include?("#{k[i][0].split('(')[0]}CYL")
    m.push('Legendary') if !k[i][2].nil? && !k[i][2][0].nil? && k[i][2][0].length>1 && !m.include?('default')
    m.push('Fallen') if k[i][0].include?('(Fallen)')
    m.push('out-of-left-field') if m.length<=0
    n=''
    unless k[i][0]==k[i][12] || k[i][12][k[i][12].length-1,1]=='*'
      k2=k.reject{|q| q[12].gsub('*','').split(', ')[0]!=k[i][12].gsub('*','').split(', ')[0] || q[0]==k[i][0] || !(q[0]==q[12].split(', ')[0] || q[12].split(', ')[0].include?('*'))}
      n='x' if k2.length<=0
    end
    untz2.push(["#{k[i][0]}#{unit_moji(bot,event,-1,k[i][0])} - #{m.uniq.join(', ')}",k[i][12].gsub('*','').split(', '),k[i][13]])
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

def list_unit_aliases(event,args,bot,mode=0)
  event.channel.send_temporary_message('Calculating data, please wait...',2)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load()
  nicknames_load()
  unless args.length.zero?
    unit=@units[find_unit(args.join(''),event)][0]
    if !detect_multi_unit_alias(event,args.join(''),event.message.text.downcase,1).nil?
      x=detect_multi_unit_alias(event,args.join(''),event.message.text.downcase,1)
      unit=x[1]
      unit=[unit] unless unit.is_a?(Array)
      g=get_markers(event)
      u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
      unit=unit.reject{|q| !u.include?(q)}
    elsif find_unit(args.join(''),event)==-1
      event.respond "#{args.join(' ')} is not a unit name or an alias."
      return nil
    end
  end
  unless unit.nil? || unit.is_a?(Array)
    unit=nil if find_unit(unit,event)<0
  end
  f=[]
  n=@aliases.map{|a| a}
  m=@multi_aliases.map{|a| a}
  h=''
  if unit.nil?
    if safe_to_spam?(event) || mode==1
      n=n.reject{|q| q[2].nil?} if mode==1
      unless event.server.nil?
        n=n.reject{|q| !q[2].nil? && !q[2].include?(event.server.id)}
        if n.length>25
          event.respond "There are so many aliases that I don't want to spam the server.  Please use the command in PM."
          return nil
        end
        msg=''
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event)
        end
        unless mode==1
          msg=extend_message(msg,'**Multi-unit aliases**',event,2)
          for i in 0...m.length
            msg=extend_message(msg,"#{m[i][0]} = #{m[i][1].join(', ')}",event)
          end
        end
        event.respond msg
        return nil
      end
      for i in 0...n.length
        if n[i][2].nil?
          f.push("#{n[i][0].gsub('_','\_')} = #{n[i][1].gsub('_','\_')}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0].gsub('_','\_')} = #{n[i][1].gsub('_','\_')}#{" *(in this server only)*" unless mode==1}")
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0].gsub('_','\_')} = #{n[i][1].gsub('_','\_')} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
    else
      event.respond 'Please either specify a unit name or use this command in PM.'
      return nil
    end
  else
    k=0
    k=event.server.id unless event.server.nil?
    unit=[unit] unless unit.is_a?(Array)
    h=' that contain this unit'
    h=' that contain both of these units' if unit.length>1
    h=' that contain all of these units' if unit.length>2
    for i1 in 0...unit.length
      u=@units[find_unit(unit[i1],event)][0]
      m=m.reject{|q| !q[1].include?(u)}
      f.push("#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u.gsub('Lavatain','Laevatein')}**#{"'s server-specific aliases__" if mode==1}")
      f.push(u) if u=='Lavatain'
      f.push(u.gsub('(','').gsub(')','')) if u.include?('(') || u.include?(')')
      for i in 0...n.length
        if n[i][1].downcase==u.downcase
          if event.server.nil? && !n[i][2].nil?
            a=[]
            for j in 0...n[i][2].length
              srv=(bot.server(n[i][2][j]) rescue nil)
              unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
                a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
              end
            end
            f.push("#{n[i][0].gsub('_','\\_')} (in the following servers: #{list_lift(a,'and')})") if a.length>0
          elsif n[i][2].nil?
            f.push(n[i][0].gsub('_','\\_')) unless mode==1
          else
            f.push("#{n[i][0].gsub('_','\\_')}#{" *(in this server only)*" unless mode==1}") if n[i][2].include?(k)
          end
        end
      end
    end
  end
  if m.length>0 && mode != 1
    f.push("\n**Multi-unit aliases#{h}**")
    for i in 0...m.length
      f.push("#{m[i][0]}#{" = #{m[i][1].join(', ')}" if unit.nil?}")
    end
  end
  f.uniq!
  if f.length>50 && !safe_to_spam?(event)
    event.respond "There are so many aliases that I don't want to spam the server.  Please use the command in PM."
    return nil
  end
  msg=''
  for i in 0...f.length
    msg=extend_message(msg,f[i],event)
  end
  event.respond msg
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
      timeshift=8
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
  blessing=[] if @units[@units.find_index{|q| q[0]==u40x[0]}][2][0].length>1
  blessing.compact!
  args.compact!
  if u40x[4].nil? || (u40x[4].max.zero? && u40x[5].max.zero?)
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
  if zzzl[11].split(', ').include?('Frostbite') || (zzzl[11].split(', ').include?('(R)Frostbite') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)Frostbite') && refinement=='Effect')
    atk='Freeze'
  end
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
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing)
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
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,ftr,pic,x,5)
end

def unit_study(event,name,bot,weapon=nil)
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
  if u40x[4].nil? || (u40x[4].max.zero? && u40x[5].max.zero?)
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
  summoner=flurp[4]
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
  end
  rardata=u40x[9][0].downcase.gsub('0s','')
  highest_merge=0
  if rardata.include?('p') || rardata.include?('s')
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
    rx="#{i+1}-star" if i>4
    rar.push([rx,r[i]]) if (lowest_rarity<=i+1 && ((boon=="" && bane=="") || i>=3)) || args.include?('full') || args.include?('rarities') || i==@max_rarity_merge[0]-1
  end
  pic=pick_thumbnail(event,j,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","**Available rarities:** #{summon_type}#{"\n**Highest available merge:** #{highest_merge}" unless highest_merge==@max_rarity_merge[1]}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,rar,2)
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
  if u40x[4].nil? || (u40x[4].max.zero? && u40x[5].max.zero?)
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
  blessing=[] if @units[@units.find_index{|q| q[0]==u40x[0]}][2][0].length>1
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
  if zzzl[11].split(', ').include?('Frostbite') || (zzzl[11].split(', ').include?('(R)Frostbite') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)Frostbite') && refinement=='Effect')
    atk='Freeze'
  end
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
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing) if wl.include?('~~')
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
  k="__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all") || k.length+staves.join("\n").length>=1950
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}"
    event.respond staves.join("\n")
  else
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,[["Staves",staves.join("\n")]])
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
  if u40x[4].nil? || (u40x[4].max.zero? && u40x[5].max.zero?)
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
  blessing=[] if @units[@units.find_index{|q| q[0]==u40x[0]}][2][0].length>1
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
  if zzzl[11].split(', ').include?('Frostbite') || (zzzl[11].split(', ').include?('(R)Frostbite') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)Frostbite') && refinement=='Effect')
    atk='Freeze'
  end
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
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing) if wl.include?('~~')
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
  if event.message.text.downcase.gsub('wrathful','').include?(' wrath')
    wdamage+=10
    wdamage2+=10
    stat_skills.push('Wrath')
  end
  if event.message.text.downcase.include?(' bushido') && u40[0]=='Ryoma(Supreme)'
    wdamage+=10
    wdamage2+=10
    stat_skills.push('Bushido')
  end
  tags=sklz[ww2][11].split(', ')
  wdamage+=10 if tags.include?('WoDao')
  wdamage2+=10 if tags.include?('WoDao') && !wl.include?('~~')
  wdamage+=10 if tags.include?('(R)WoDao') && !refinement.nil? && refinement.length>0
  wdamage2+=10 if tags.include?('(R)WoDao') && !refinement.nil? && refinement.length>0 && !wl.include?('~~')
  wdamage+=10 if tags.include?('(E)WoDao') && refinement=='Effect'
  wdamage2+=10 if tags.include?('(E)WoDao') && refinement=='Effect' && !wl.include?('~~')
  cdwn=0
  cdwn-=1 if tags.include?('Killer')
  cdwn+=1 if tags.include?('SlowSpecial') || tags.include?('SpecialSlow')
  cdwn-=1 if tags.include?('(R)Killer') && !refinement.nil? && refinement.length>0
  cdwn+=1 if (tags.include?('(R)SlowSpecial') || tags.include?('(R)SpecialSlow')) && !refinement.nil? && refinement.length>0
  cdwn-=1 if tags.include?('(E)Killer') && refinement=='Effect'
  cdwn+=1 if (tags.include?('(E)SlowSpecial') || tags.include?('(E)SpecialSlow')) && refinement=='Effect'
  cdwn2=0
  cdwn2=cdwn unless wl.include?('~~')
  cdwns=cdwn
  cdwns="~~#{cdwn}~~ #{cdwn2}" unless cdwn2==cdwn
  staves=[[],[],[],[],[],[],[],[]]
  g=get_markers(event) 
  procs=@skills.reject{|q| !has_any?(g, q[13]) || q[4]!='Special'}
  c=add_number_to_string(get_match_in_list(procs, 'Night Sky')[2],cdwns)
  d="`dmg /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`dmg /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Night Sky - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Astra')[2],cdwns)
  d="`3* dmg /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`3* dmg /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Astra - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Regnal Astra')[2],cdwns)
  d="#{spdd*2/5+wdamage}#{" (#{blspdd*2/5+wdamage})" unless spdd*2/5==blspdd*2/5}"
  cd="#{crspdd*2/5+wdamage2}#{" (#{crblspdd*2/5+wdamage2})" unless crspdd*2/5==crblspdd*2/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[0].push("**Regnal Astra - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Regnal Astra')[6].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Glimmer')[2],cdwns)
  d="`dmg /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`dmg /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Glimmer - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'New Moon')[2],cdwns)
  d="`3* eDR /10#{" +#{wdamage}" if wdamage>0}`"
  d2="`3* eDR /10#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("New Moon - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Luna')[2],cdwns)
  d="`eDR /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`eDR /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("Luna - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Black Luna')[2],cdwns)
  d="`4* eDR /5#{" +#{wdamage}" if wdamage>0}`"
  d2="`4* eDR /5#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("**Black Luna - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Black Luna')[6].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Moonbow')[2],cdwns)
  d="`3* eDR /10#{" +#{wdamage}" if wdamage>0}`"
  d2="`3* eDR /10#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("Moonbow - #{d}, cooldown of #{c}")
  wd="#{"#{wdamage}, " if wdamage>0}"
  wd="~~#{wdamage}~~ #{wdamage2}, " unless wdamage==wdamage2
  c=add_number_to_string(get_match_in_list(procs, 'Daylight')[2],cdwns)
  d="`3* #{"(" if wdamage>0}dmg#{" +#{wdamage})" if wdamage>0} /10`"
  d2="`3* #{"(" if wdamage2>0}dmg#{" +#{wdamage2})" if wdamage2>0} /10`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Daylight - #{wd}heals for #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Noontime')[2],cdwns)
  d="`3* #{"(" if wdamage>0}dmg#{" +#{wdamage})" if wdamage>0} /10`"
  d2="`3* #{"(" if wdamage2>0}dmg#{" +#{wdamage2})" if wdamage2>0} /10`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Noontime - #{wd}heals for #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Sol')[2],cdwns)
  d="`#{"(" if wdamage>0}dmg#{" +#{wdamage})" if wdamage>0} /2`"
  d2="`#{"(" if wdamage2>0}dmg#{" +#{wdamage2})" if wdamage2>0} /2`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Sol - #{wd}heals for #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Aether')[2],cdwns)
  d="`eDR /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`eDR /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  h="`#{"(" if wdamage>0}dmg#{" +#{wdamage})" if wdamage>0} /2 + eDR /4`"
  h2="`#{"(" if wdamage2>0}dmg#{" +#{wdamage2})" if wdamage2>0} /2 + eDR /4`"
  h="~~#{h}~~ #{h2}" unless h==h2
  staves[3].push("Aether - #{d}, heals for #{h}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Radiant Aether')[2],cdwns)
  staves[3].push("**Radiant Aether - `#{d}, heals for #{h}, cooldown of #{c}**") if get_match_in_list(procs, 'Radiant Aether')[6].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Glowing Ember')[2],cdwns)
  d="#{deff/2+wdamage}#{" (#{bldeff/2+wdamage})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2}#{" (#{crbldeff/2+wdamage2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Glowing Ember - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Bonfire')[2],cdwns)
  d="#{deff/2+wdamage}#{" (#{bldeff/2+wdamage})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2}#{" (#{crbldeff/2+wdamage2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Bonfire - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Ignis')[2],cdwns)
  d="#{deff*4/5+wdamage}#{" (#{bldeff*4/5+wdamage})" unless deff*4/5==bldeff*4/5}"
  cd="#{crdeff*4/5+wdamage2}#{" (#{crbldeff*4/5+wdamage2})" unless crdeff*4/5==crbldeff*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Ignis - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Chilling Wind')[2],cdwns)
  d="#{ress/2+wdamage}#{" (#{blress/2+wdamage})" unless ress/2==blress/2}"
  cd="#{crress/2+wdamage2}#{" (#{crblress/2+wdamage2})" unless crress/2==crblress/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Chilling Wind - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Glacies')[2],cdwns)
  d="#{ress*4/5+wdamage}#{" (#{blress*4/5+wdamage})" unless ress*4/5==blress*4/5}"
  cd="#{crress*4/5+wdamage2}#{" (#{crblress*4/5+wdamage2})" unless crress*4/5==crblress*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Glacies - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Iceberg')[2],cdwns)
  d="#{ress/2+wdamage}#{" (#{blress/2+wdamage})" unless ress/2==blress/2}"
  cd="#{crress/2+wdamage2}#{" (#{crblress/2+wdamage2})" unless crress/2==crblress/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Iceberg - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Dragon Gaze')[2],cdwns)
  d="#{atkk*3/10+wdamage}#{" (#{blatkk*3/10+wdamage})" unless atkk*3/10==blatkk*3/10}"
  cd="#{cratkk*3/10+wdamage2}#{" (#{crblatkk*3/10+wdamage2})" unless cratkk*3/10==crblatkk*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[6].push("Dragon Gaze - Up to #{d} when against color-neutral, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Draconic Aura')[2],cdwns)
  d="#{atkk*3/10+wdamage}#{" (#{blatkk*3/10+wdamage})" unless atkk*3/10==blatkk*3/10}"
  cd="#{cratkk*3/10+wdamage2}#{" (#{crblatkk*3/10+wdamage2})" unless cratkk*3/10==crblatkk*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[6].push("Draconic Aura - Up to #{d} when against color-neutral, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Fire Emblem')[2],cdwns)
  d="#{spdd*3/10+wdamage}#{" (#{blspdd*3/10+wdamage})" unless spdd*3/10==blspdd*3/10}"
  cd="#{crspdd*3/10+wdamage2}#{" (#{crblspdd*3/10+wdamage2})" unless crspdd*3/10==crblspdd*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[6].push("**Fire Emblem - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Fire Emblem')[6].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Dragon Fang')[2],cdwns)
  d="#{atkk/2+wdamage}#{" (#{blatkk/2+wdamage})" unless atkk/2==blatkk/2}"
  cd="#{cratkk/2+wdamage2}#{" (#{crblatkk/2+wdamage2})" unless cratkk/2==crblatkk/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[6].push("Dragon Fang - Up to #{d} when against color-neutral, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Retribution')[2],cdwns)
  d="#{3*hppp/10+wdamage}#{" (#{3*blhppp/10+wdamage})" if 3*hppp/10!=3*blhppp/10}"
  cd="#{3*crhppp/10+wdamage2}#{" (#{3*crblhppp/10+wdamage2})" if 3*crhppp/10!=3*crblhppp/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Retribution - Up to #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Reprisal')[2],cdwns)
  d="#{3*hppp/10+wdamage}#{" (#{3*blhppp/10+wdamage})" if 3*hppp/10!=3*blhppp/10}"
  cd="#{3*crhppp/10+wdamage2}#{" (#{3*crblhppp/10+wdamage2})" if 3*crhppp/10!=3*crblhppp/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Reprisal - Up to #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Vengeance')[2],cdwns)
  d="#{hppp/2+wdamage}#{" (#{blhppp/2+wdamage})" if hppp/2!=blhppp/2}"
  cd="#{crhppp/2+wdamage2}#{" (#{crblhppp/2+wdamage2})" if crhppp/2!=crblhppp/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Vengeance - Up to #{d}, cooldown of #{c}")
  pic=pick_thumbnail(event,j,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  k="__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n\neDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all") || k.length+staves.map{|q| q.join("\n")}.join("\n\n").length>=1950
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n\neDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations"
    s=""
    for i in 0...staves.length
      s=extend_message(s,staves[i].join("\n"),event,2)
    end
    event.respond s
  else
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,nil,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,"eDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations",pic,[["<:Special_Offensive_Star:454473651396542504>Star",staves[0].join("\n"),1],["<:Special_Offensive_Moon:454473651345948683>Moon",staves[1].join("\n")],["<:Special_Offensive_Sun:454473651429965834>Sun",staves[2].join("\n")],["<:Special_Offensive_Eclipse:454473651308199956>Eclipse",staves[3].join("\n"),1],["<:Special_Offensive_Fire:454473651861979156>Fire",staves[4].join("\n")],["<:Special_Offensive_Ice:454473651291422720>Ice",staves[5].join("\n")],["<:Special_Offensive_Dragon:454473651186696192>Dragon",staves[6].join("\n"),1],["<:Special_Offensive_Darkness:454473651010535435>Darkness",staves[7].join("\n")]])
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
  if u40x[4].nil? || (u40x[4].max.zero? && u40x[5].max.zero?)
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
  blessing=[] if @units[@units.find_index{|q| q[0]==u40x[0]}][2][0].length>1
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
  atk='<:StrengthS:467037520484630539> Attack'
  atk='<:MagicS:467043867611627520> Magic' if ['Tome','Healer','Dragon'].include?(u40x[1][1])
  atk='<:StrengthS:467037520484630539> Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  if zzzl[11].split(', ').include?('Frostbite') || (zzzl[11].split(', ').include?('(R)Frostbite') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)Frostbite') && refinement=='Effect')
    atk='<:FreezeS:467043868148236299> Freeze'
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='<:StrengthS:467037520484630539> Strength'
    n=n[n.length-1] if atk=='<:MagicS:467043867611627520> Magic'
    n=n.join(' / ') if ['<:StrengthS:467037520484630539> Attack','Freeze'].include?(atk)
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
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing)
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
  if zzzl[11].split(', ').include?('BuffStuffer') || (zzzl[11].split(', ').include?('(R)BuffStuffer') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)BuffStuffer') && refinement=='Effect')
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
  if zzzl[11].split(', ').include?('CloseDef') || (zzzl[11].split(', ').include?('(R)CloseDef') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)CloseDef') && refinement=='Effect')
    close[4]+=6
    close[5]+=6
  end
  if zzzl[11].split(', ').include?('CloseAtk') || (zzzl[11].split(', ').include?('(R)CloseAtk') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)CloseAtk') && refinement=='Effect')
    close[2]+=6
  end
  if zzzl[11].split(', ').include?('CloseSpd') || (zzzl[11].split(', ').include?('(R)CloseSpd') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)CloseSpd') && refinement=='Effect')
    close[3]+=6
  end
  if zzzl[11].split(', ').include?('DistantDef') || (zzzl[11].split(', ').include?('(R)DistantDef') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)DistantDef') && refinement=='Effect')
    distant[4]+=6
    distant[5]+=6
  end
  if zzzl[11].split(', ').include?('DistantAtk') || (zzzl[11].split(', ').include?('(R)DistantAtk') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)DistantAtk') && refinement=='Effect')
    distant[2]+=6
  end
  if zzzl[11].split(', ').include?('DistantSpd') || (zzzl[11].split(', ').include?('(R)DistantSpd') && !refinement.nil? && refinement.length>0) || (zzzl[11].split(', ').include?('(E)DistantSpd') && refinement=='Effect')
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
  pic=pick_thumbnail(event,j,bot)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(' all')
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(j,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}"
    event.respond "**Displayed stats:**  #{u40[1]} / #{u40[2]} / #{u40[3]} / #{u40[4]} / #{u40[5]}\n**#{"Player Phase" unless ppu40==epu40}#{"In-combat Stats" if ppu40==epu40}:**  #{ppu40[1]} / #{ppu40[2]} / #{ppu40[3]} / #{ppu40[4]} / #{ppu40[5]}  (#{ppu40[16]} BST)#{"\n**Enemy Phase:**  #{epu40[1]} / #{epu40[2]} / #{epu40[3]} / #{epu40[4]} / #{epu40[5]}  (#{epu40[16]} BST)" unless ppu40==epu40}"
  elsif ppu40==epu40
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense TIle\n" if deftile}#{display_stat_skills(j,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,[["Displayed stats","<:HP_S:467037520538894336> HP: #{u40[1]}\n#{atk}: #{u40[2]}\n<:SpeedS:467037520534962186> Speed: #{u40[3]}\n<:DefenseS:467037520249487372> Defense: #{u40[4]}\n<:ResistanceS:467037520379641858> Resistance: #{u40[5]}\n\nBST: #{u40[16]}"],["In-combat Stats","<:HP_S:467037520538894336> HP: #{ppu40[1]}\n#{atk}: #{ppu40[2]}\n<:SpeedS:467037520534962186> Speed: #{ppu40[3]}\n<:DefenseS:467037520249487372> Defense: #{ppu40[4]}\n<:ResistanceS:467037520379641858> Resistance: #{ppu40[5]}\n\nBST: #{ppu40[16]}"]])
  elsif event.user.id==167657750971547648
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense TIle\n" if deftile}#{display_stat_skills(j,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,[["Displayed stats","<:HP_S:467037520538894336> HP: #{u40[1]}\n#{atk}: #{u40[2]}\n<:SpeedS:467037520534962186> Speed: #{u40[3]}\n<:DefenseS:467037520249487372> Defense: #{u40[4]}\n<:ResistanceS:467037520379641858> Resistance: #{u40[5]}\n\nBST: #{u40[16]}"],["Player Phase","<:HP_S:467037520538894336> HP: #{ppu40[1]}\n<:Death_Blow:472211986625593345> Attack: #{ppu40[2]}\n<:Darting_Blow:472211986705547264> Speed: #{ppu40[3]}\n<:Armored_Blow:472211986688638976> Defense: #{ppu40[4]}\n<:Warding_Blow:472211986822856705> Resistance: #{ppu40[5]}\n\nBST: #{ppu40[16]}"],["Enemy Phase","<:HP_S:467037520538894336> HP: #{epu40[1]}\n<:Fierce_Stance:472211986621661195> Attack: #{epu40[2]}\n<:Darting_Stance:472211986772393994> Speed: #{epu40[3]}\n<:Steady_Stance:472211986642501633> Defense: #{epu40[4]}\n<:Warding_Stance:472211986651021333> Resistance: #{epu40[5]}\n\nBST: #{epu40[16]}"]])
  else
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{display_stars(rarity,merges,summoner)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense TIle\n" if deftile}#{display_stat_skills(j,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,wl)}\n#{unit_clss(bot,event,j,u40[0])}\n",xcolor,nil,pic,[["Displayed stats","<:HP_S:467037520538894336> HP: #{u40[1]}\n#{atk}: #{u40[2]}\n<:SpeedS:467037520534962186> Speed: #{u40[3]}\n<:DefenseS:467037520249487372> Defense: #{u40[4]}\n<:ResistanceS:467037520379641858> Resistance: #{u40[5]}\n\nBST: #{u40[16]}",1],["Player Phase","<:HP_S:467037520538894336> HP: #{ppu40[1]}\n<:Death_Blow:472211986625593345> Attack: #{ppu40[2]}\n<:Darting_Blow:472211986705547264> Speed: #{ppu40[3]}\n<:Armored_Blow:472211986688638976> Defense: #{ppu40[4]}\n<:Warding_Blow:472211986822856705> Resistance: #{ppu40[5]}\n\nBST: #{ppu40[16]}"],["Enemy Phase","<:HP_S:467037520538894336> HP: #{epu40[1]}\n<:Fierce_Stance:472211986621661195> Attack: #{epu40[2]}\n<:Darting_Stance:472211986772393994> Speed: #{epu40[3]}\n<:Steady_Stance:472211986642501633> Defense: #{epu40[4]}\n<:Warding_Stance:472211986651021333> Resistance: #{epu40[5]}\n\nBST: #{epu40[16]}"]])
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
  artype='BtlFace_D' if args.include?('damage') || args.include?('damaged') || (args.include?('low') && (args.include?('health') || args.include?('hp'))) || args.include?('lowhealth') || args.include?('lowhp') || args.include?('low_health') || args.include?('low_hp')
  artype='BtlFace_C' if args.include?('critical') || args.include?('special') || args.include?('crit') || args.include?('proc')
  art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{j[0]}/#{artype}.png"
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
    unless x[6].nil? || x[6].length<=0
      m=x[6].split(' as ')
      charsx[0].push(x[0].gsub('Lavatain','Laevatein')) if m[0]==nammes[0]
    end
    unless x[7].nil? || x[7].length<=0
      m=x[7].split(' as ')
      charsx[1].push(x[0].gsub('Lavatain','Laevatein')) if m[0]==nammes[1]
    end
    unless x[8].nil? || x[8].length<=0
      m=x[8].split(' as ')
      charsx[2].push(x[0].gsub('Lavatain','Laevatein')) if m[0]==nammes[2]
    end
  end
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    disp="#{disp}\n" if charsx.map{|q| q.length}.max>0
    disp="#{disp}\n**Same artist:** #{charsx[0].join(', ')}" if charsx[0].length>0
    disp="#{disp}\n**Same VA(EN):** #{charsx[1].join(', ')}" if charsx[1].length>0
    disp="#{disp}\n**Same VA(JP):** #{charsx[2].join(', ')}" if charsx[2].length>0
    disp='>No information<' if disp.length<=0
    event.respond "#{disp}\n\n#{art}"
  else
    disp='>No information<' if disp.length<=0
    flds=[]
    flds.push(['Same Artist',charsx[0].join("\n"),1]) if charsx[0].length>0
    flds.push(['Same VA (English)',charsx[1].join("\n")]) if charsx[1].length>0
    flds.push(['Same VA (Japanese)',charsx[2].join("\n")]) if charsx[2].length>0
    if flds.length.zero?
      flds=nil
    else
      flds[0][2]=nil if flds.length<3
      flds[0].compact!
    end
    event.channel.send_embed("__**#{j[0].gsub('Lavatain','Laevatein')}**__") do |embed|
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
    return nil
  elsif p1[3].length+p1[4].length+p1[5].length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    msg=''
    msg=extend_message(msg,"<:Passive_A:443677024192823327> *Passives(A):* #{p1[3].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"<:Passive_B:443677023257493506> *Passives(B):* #{p1[4].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"<:Passive_C:443677023555026954> *Passives(C):* #{p1[5].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"<:Passive_S:443677023626330122> *Passives(S):* #{p1[6].gsub("\n",', ')}",event,2) unless p1[6].nil?
    event.respond msg
  else
    create_embed(event,'','',unit_color(event,j),nil,nil,[['<:Passive_A:443677024192823327> Passives(A)',p1[3]],['<:Passive_B:443677023257493506> Passives(B)',p1[4]],['<:Passive_C:443677023555026954> Passives(C)',p1[5]]],4)
    create_embed(event,"__<:Passive_S:443677023626330122> Seals **#{untz[j][0].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,j)} can equip__",'',unit_color(event,j),nil,nil,triple_finish(p1[6].split("\n")),4)
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
    non_focus[0].push("5<:Icon_Rarity_5:448266417553539104> Non-Focus - #{len % (five_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (five_star[0]/k.length)}% (Actual)") unless five_star[0]<=0
      non_focus[1].push("5<:Icon_Rarity_5:448266417553539104> Non-Focus (Hero Fest only) - #{len % (five_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (five_star[1]/k.length)}% (Actual)") unless five_star[1]<=0
    end
  if j[9][0].include?('4p')
    k=untz.reject{|q| !q[9][0].include?('4p') || !q[13][0].nil?}
    non_focus[0].push("4<:Icon_Rarity_4:448266418459377684> (standard banner) - #{len % (four_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (four_star[0]/k.length)}% (Actual)") unless four_star[0]<=0
    non_focus[0].push("4<:Icon_Rarity_4:448266418459377684> Non-Focus - #{len % ((four_star[0]/2)/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % ((four_star[0]/2)/k.length)}% (Actual)") unless four_star[0]<=0
    non_focus[1].push("4<:Icon_Rarity_4:448266418459377684> all the time - #{len % (four_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (four_star[1]/k.length)}% (Actual)") unless four_star[1]<=0
  end
  if j[9][0].include?('3p')
    k=untz.reject{|q| !q[9][0].include?('3p') || !q[13][0].nil?}
    non_focus[0].push("3<:Icon_Rarity_3:448266417934958592> all the time - #{len % (three_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (three_star[0]/k.length)}% (Actual)") unless three_star[0]<=0
    non_focus[1].push("3<:Icon_Rarity_3:448266417934958592> all the time - #{len % (three_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (three_star[1]/k.length)}% (Actual)") unless three_star[1]<=0
  end
  if j[9][0].include?('2p')
    k=untz.reject{|q| !q[9][0].include?('2p') || !q[13][0].nil?}
    non_focus[0].push("2<:Icon_Rarity_2:448266417872044032> all the time - #{len % (two_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (two_star[0]/k.length)}% (Actual)") unless two_star[0]<=0
    non_focus[1].push("2<:Icon_Rarity_2:448266417872044032> all the time - #{len % (two_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (two_star[1]/k.length)}% (Actual)") unless two_star[1]<=0
  end
  if j[9][0].include?('1p')
    k=untz.reject{|q| !q[9][0].include?('1p') || !q[13][0].nil?}
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
  name='Robin' if name==['Robin(M)','Robin(F)'] || name==['Robin(F)','Robin(M)']
  name='Azura' if name==['Azura(Performing)','Azura(Winter)']
  name='Lucina' if name==['Lucina(Spring)','Lucina(Brave)']
  name='Hector' if name==['Hector(Marquess)','Hector(Brave)']
  name='Lyn' if name==['Lyn(Bride)','Lyn(Brave)'] || name==['Lyn(Brave)','Lyn(Wind)'] || name==['Lyn(Bride)','Lyn(Valentines)']
  name=name[0].gsub('(M)','(F)') if name.is_a?(Array) && name.length==2 && name[0].gsub('(M)','').gsub('(F)','')!=name[0] && name[0].gsub('(M)','').gsub('(F)','')==name[0].gsub('(F)','').gsub('(M)','')
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
  j=find_unit(name,event)
  name='Robin(M)(Fallen)' if name.downcase.include?('grima') && j<0
  j=find_unit(name,event)
  if j<0
    event.respond 'No unit was included'
    return nil
  end
  untz=@units.map{|q| q}
  rg=untz[j][11].reject{|q| q[0,3]=='(a)'}
  ag=untz[j][11].reject{|q| q[0,3]!='(a)'}.map{|q| q[3,q.length-3]}
  g=get_games_list(rg)
  ga=get_games_list(ag,false)
  mu=(event.message.text.downcase.include?("mathoo's"))
  xcolor=unit_color(event,j,nil,0,mu)
  pic=pick_thumbnail(event,j,bot)
  g2="#{g[0]}"
  g.shift
  name="#{untz[j][0].gsub('Lavatain','Laevatein')}"
  if ['Robin(F)','Robin(M)'].include?(untz[j][0])
    pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png'
    name='Robin'
    xcolor=avg_color([[39,100,222],[9,170,36]])
  elsif ['Morgan(F)','Morgan(M)'].include?(untz[j][0])
    pic='https://orig00.deviantart.net/97f6/f/2018/068/a/c/morgan_by_rot8erconex-dc5drdn.png'
    name='Morgan'
    xcolor=avg_color([[39,100,222],[226,33,65]])
  elsif ['Kana(F)','Kana(M)'].include?(untz[j][0])
    name='Kana'
    xcolor=avg_color([[39,100,222],[9,170,36]])
  elsif ['Robin(F)(Fallen)','Robin(M)(Fallen)'].include?(untz[j][0])
    pic='https://orig00.deviantart.net/33ea/f/2018/104/2/7/grimleal_by_rot8erconex-dc8svax.png'
    name='Grima: Robin(Fallen)'
    xcolor=avg_color([[9,170,36],[222,95,9]])
  elsif ['Corrin(F)','Corrin(M)'].include?(untz[j][0])
    pic='https://orig00.deviantart.net/d8ce/f/2018/051/1/a/corrin_by_rot8erconex-dc3tj34.png'
    name='Corrin'
    xcolor=avg_color([[226,33,65],[39,100,222]])
  elsif 'Chrom(Branded)'==untz[j][0] && !args.join('').downcase.include?('brand') && !args.join('').downcase.include?('exalt') && !args.join('').downcase.include?('sealed') && !args.join('').downcase.include?('branded') && !args.join('').downcase.include?('exalted') && !args.join('').downcase.include?('knight')
    pic=pick_thumbnail(event,find_unit('Chrom(Launch)',event),bot)
    name='Chrom(Launch)'
  elsif 'Tiki(Adult)'==untz[j][0] && !args.join('').downcase.gsub('games','gmes').include?('a')
    pic='https://orig00.deviantart.net/6c50/f/2018/051/9/e/tiki_by_rot8erconex-dc3tkzq.png'
    name='Tiki'
    m=untz[untz.find_index{|q| q[0]=='Tiki(Young)'}]
    rx=m[11].reject{|q| q[0,3]=='(a)'}
    ax=m[11].reject{|q| q[0,3]!='(a)'}.map{|q| q[3,q.length-3]}
    x=get_games_list(rx)
    xa=get_games_list(ax,false)
    g2="#{x[0]}\n#{g2}"
    x.shifr
    for i in 0...g.length
      x.push(g[i])
    end
    for i in 0...ga.length
      xa.push(ga[i])
    end
    g=x.uniq
    ga=xa.uniq
  end
  ga=ga.reject{|q| q.downcase=='no games'}
  create_embed(event,"__#{"Mathoo's " if mu}**#{name}**__","#{"**Credit in FEH**\n" unless g2=="No games"}#{g2}#{"\n\n**Other games**\n#{g.join("\n")}" unless g.length<1}#{"\n\n**#{"Male a" if ["Robin(F)","Robin(M)"].include?(untz[j][0])}#{"A" unless ["Robin(F)","Robin(M)"].include?(untz[j][0])}lso appears via Amiibo functionality in**\n#{ga.join("\n")}" unless ga.length<1}",xcolor,nil,pic)
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
    timeshift=8
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

bot.command(:art) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  parse_function(:disp_art,event,args,bot)
  return nil
end

bot.command([:legendary,:legendaries]) do |event, *args|
  return nil if overlap_prevent(event)
  args=[] if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  args=args.map{|q| q.downcase}
  data_load()
  g=get_markers(event)
  l=@units.reject{|q| q[2][0]==' ' || !has_any?(g, q[13][0])}
  l.sort!{|a,b| a[0]<=>b[0]}
  c=[]
  for i in 0...l.length
    c.push([102,218,250]) if l[i][2][0]=='Water'
    c.push([222,95,9]) if l[i][2][0]=='Earth'
    c.push([122,233,112]) if l[i][2][0]=='Wind'
    c.push([242,70,58]) if l[i][2][0]=='Fire'
    c.push([64,0,128]) if l[i][2][0]=='Dark'
  end
  l.uniq!
  x=[]
  if has_any?(args,['time','next','future','month','months'])
    sort_legendaries(event,bot)
    return nil
  end
  x.push('Element') if has_any?(args,['element','flavor','elements','flavors','affinity','affinities','affinitys'])
  x.push('Stat') if has_any?(args,['stat','boost','stats','boosts'])
  x.push('Weapon') if has_any?(args,['weapon','weapons'])
  x.push('Color') if has_any?(args,['color','colour','colors','colours'])
  x.push('Movement') if has_any?(args,['move','movement','moves','movements'])
  x.push('Element') if x.length<=1
  x.push('Stat') if x.length<=1
  l2=l.map{|q| q}
  pri=''
  sec=''
  tri=''
  for i in 0...l.length
    l[i][15]=weapon_clss(l[i][1],event,1)
  end
  x=prio(x,['Element','Stat','Color','Weapon','Movement'])
  pri=x[0]
  sec=x[1]
  tri=x[2] if x.length>=3
  if pri=='Element'
    l2=split_list(event,l,['Fire','Water','Wind','Earth','Dark'],-5)
  elsif pri=='Stat'
    l2=split_list(event,l,['Attack','Speed','Defense','Resistance'],-6)
  elsif pri=='Color'
    l2=split_list(event,l,['Red','Blue','Green','Colorless'],-2)
  elsif pri=='Weapon'
    l2=split_list(event,l,['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Dragon','Bow','Dagger','Healer'],15)
  elsif pri=='Movement'
    l2=split_list(event,l,['Infantry','Armor','Cavalry','Flier'],3)
  end
  p1=[[]]
  p2=0
  for i in 0...l2.length
    if l2[i][0]=='- - -'
      p2+=1
      p1.push([])
    else
      p1[p2].push(l2[i])
    end
  end
  for i in 0...p1.length
    x2='.'
    if pri=='Element'
      x2=p1[i][0][2][0]
      element='Unknown'
      element=x2 if ['Fire','Water','Wind','Earth','Dark'].include?(x2)
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      x2="#{moji[0].mention} #{x2}" if moji.length>0
    elsif pri=='Stat'
      x2=p1[i][0][2][1]
      element='Spectrum'
      element=x2 if ['Attack','Speed','Defense','Resistance'].include?(x2)
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{element}"}
      x2="#{moji[0].mention} #{x2}" if moji.length>0
    elsif pri=='Color'
      x2=p1[i][0][1][0]
      element='Gold'
      element=x2 if ['Red','Blue','Green','Colorless'].include?(x2)
      moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{element}_Unknown"}
      x2="#{moji[0].mention} #{x2}" if moji.length>0
    elsif pri=='Movement'
      x2=p1[i][0][3]
      element='Unknown'
      element=x2 if ['Infantry','Flier','Cavalry','Armor'].include?(x2)
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{element}"}
      x2="#{moji[0].mention} #{x2}" if moji.length>0
    elsif pri=='Weapon'
      x2="#{unit_moji(bot,event,-1,p1[i][0][0],false,1)} #{weapon_clss(p1[i][0][1],event,1)}"
    end
    if sec=='Stat'
      l2=split_list(event,p1[i],['Attack','Speed','Defense','Resistance'],-6)
    elsif sec=='Color'
      l2=split_list(event,p1[i],['Red','Blue','Green','Colorless'],-2)
    elsif sec=='Weapon'
      l2=split_list(event,p1[i],['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Dragon','Bow','Dagger','Healer'],15)
    elsif sec=='Movement'
      l2=split_list(event,p1[i],['Infantry','Armor','Cavalry','Flier'],3)
    end
    p2=[[]]
    p3=0
    for j in 0...l2.length
      if l2[j][0]=='- - -'
        p3+=1
        p2.push([])
      else
        p2[p3].push(l2[j])
      end
    end
    for j in 0...p2.length
      x3='.'
      if sec=='Element'
        x3=p2[j][0][2][0]
        element='Unknown'
        element=x3 if ['Fire','Water','Wind','Earth','Dark'].include?(x3)
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
        x3="#{moji[0].mention} #{x3}" if moji.length>0
      elsif sec=='Stat'
        x3=p2[j][0][2][1]
        element='Spectrum'
        element=x3 if ['Attack','Speed','Defense','Resistance'].include?(x3)
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{element}"}
        x3="#{moji[0].mention} #{x3}" if moji.length>0
      elsif sec=='Color'
        x3=p2[j][0][1][0]
        element='Gold'
        element=x3 if ['Red','Blue','Green','Colorless'].include?(x3)
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{element}_Unknown"}
        x3="#{moji[0].mention} #{x3}" if moji.length>0
      elsif sec=='Movement'
        x3=p2[j][0][3]
        element='Unknown'
        element=x3 if ['Infantry','Flier','Cavalry','Armor'].include?(x3)
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{element}"}
        x3="#{moji[0].mention} #{x3}" if moji.length>0
      elsif sec=='Weapon'
        x3="#{unit_moji(bot,event,-1,p2[j][0][0],false,1)} #{weapon_clss(p2[j][0][1],event,1)}"
      end
      p2[j]="__*#{x3}*__\n#{p2[j].map{|q| "#{'~~' unless q[13][0].nil?}#{q[0]}#{" - *#{weapon_clss(q[1],event,1) if tri=='Weapon'}#{q[1][0] if tri=='Color'}#{q[3] if tri=='Movement'}*" unless tri==''}#{'~~' unless q[13][0].nil?}"}.join("\n")}" unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      p2[j]="*#{x3}*: #{p2[j].map{|q| "#{'~~' unless q[13][0].nil?}#{q[0]}#{" - *#{weapon_clss(q[1],event,1) if tri=='Weapon'}#{q[1][0] if tri=='Color'}#{q[3] if tri=='Movement'}*" unless tri==''}#{'~~' unless q[13][0].nil?}"}.join(", ")}" if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    end
    p1[i]=[x2,p2.join("\n\n")] unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    p1[i]=[x2,p2.join("\n")] if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
  end
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event << '__**All Legendary Heroes**__'
    for i in 0...p1.length
      event << ''
      event << "__*#{p1[i][0]}*__"
      event << p1[i][1]
    end
  else
    create_embed(event,'__**All Legendary Heroes**__','',avg_color(c),nil,nil,p1)
  end
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
  skkz=@skills.map{|q| q}.reject{|q| q[0]=='Falchion' || q[0]=='Breidablik' || q[4]!='Weapon' || !has_any?(g, q[13])}
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:443172811608162324> Beaststones',[]]]
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:443172811608162324> Beaststones',[]]]
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:443172811608162324> Beaststones',[]]]
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:443172811608162324> Beaststones',[]]]
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:443172811608162324> Beaststones',[]]]
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:443172811608162324> Beaststones',[]]]
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

bot.command([:donation, :donate]) do |event|
  return nil if overlap_prevent(event)
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?('mobile') || event.message.text.downcase.include?('phone')
    event.respond "__A word from my developer__\nI made EliseBot, as she is now, as a free service.  During development, I never once considered making people pay to add her to their servers, or anything of the sort.  The creation of Elise's core functionality, the `stats` function, was mainly a way for me to better understand the mechanics behind FEH's growths, because how games work is one of my interests.\n\nDespite this, people in at least two servers have asked me about possibly creating a Patreon or Paypal donation button to allow users to show their support.  I am humbled to know that EliseBot's information-dump-and-stat-calculation functionality is something people are willing to pay for, especially considering there are many other methods users can obtain this data.\n\nConsidering how adamant some people were about wanting to support me, it seems almost rude not to start a Patreon...but I, unfortunately, must toss the idea aside.  Due to certain insurance regulations regarding places like the one I live in, I would only be allowed to keep a small portion of any secondary income I receive.  Starting a Patreon only to have only a third or even less reach my hands seems dishonest to my supporters, and that is something I do not wish to have hanging over my head.  Since they were spending that money with the intention of supporting the development of EliseBot, they may not wish to have their money go to a corporation that may or may not spend that money to increase my quality of life."
    event.respond "However, there is a roundabout solution for those who wish to support me: Gift cards - such as those for the Nintendo eShop or Google Play - do not count as secondary income, and as such I get to keep the full amount of any I receive.  As such, if you wish to support me, and only if you really wish to support me, the best way to do so is acquire a gift card and email the code to **rot8er.conex@gmail.com**.  There is also, if there are items on it, my Amazon wish list, linked below.  I recently learned that I can have items purchased from that list delivered to me without giving out my address.\n\n~~Please note that supporting me means indirectly enabling my addiction to pretzels and pizza rolls.~~\n\nhttp://a.co/0p3sBec"
  else
    create_embed(event,"__A word from my developer__","I made EliseBot, as she is now, as a free service.  During development, I never once considered making people pay to add her to their servers, or anything of the sort.  The creation of Elise's core functionality, the `stats` function, was mainly a way for me to better understand the mechanics behind FEH's growths, because how games work is one of my interests.\n\nDespite this, people in at least two servers have asked me about possibly creating a Patreon or Paypal donation button to allow users to show their support.  I am humbled to know that EliseBot's information-dump-and-stat-calculation functionality is something people are willing to pay for, especially considering there are many other methods users can obtain this data.\n\nConsidering how adamant some people were about wanting to support me, it seems almost rude not to start a Patreon...but I, unfortunately, must toss the idea aside.  Due to certain insurance regulations regarding places like the one I live in, I would only be allowed to keep a small portion of any secondary income I receive.  Starting a Patreon only to have only a third or even less reach my hands seems dishonest to my supporters, and that is something I do not wish to have hanging over my head.  Since they were spending that money with the intention of supporting the development of EliseBot, they may not wish to have their money go to a corporation that may or may not spend that money to increase my quality of life.",0x008b8b)
    create_embed(event,"","\n\nHowever, there is a roundabout solution for those who wish to support me: Gift cards - such as those for the Nintendo eShop or Google Play - do not count as secondary income, and as such I get to keep the full amount of any I receive.  As such, if you wish to support me, and only if you really wish to support me, the best way to do so is acquire a gift card and email the code to **rot8er.conex@gmail.com**.  There is also, if there are items on it, [my Amazon wish list](http://a.co/0p3sBec).  I recently learned that I can have items purchased from that list delivered to me without giving out my address.",0x008b8b,"Please note that supporting me means indirectly enabling my addiction to pretzels and pizza rolls.")
    event.respond "If you are on a mobile device and cannot click the links in the embed above, type `FEH!donate mobile` to receive this message as plaintext."
  end
  return nil
end

bot.command([:random,:rand]) do |event, *args|
  return nil if overlap_prevent(event)
  generate_random_unit(event,args,bot)
  return nil
end

bot.command(:whyelise) do |event|
  return nil if overlap_prevent(event)
  if (!event.message.text.downcase.include?('full') && !event.message.text.downcase.include?('long')) && !safe_to_spam?(event)
    create_embed(event,"__A word from my developer__","When people learn that my main waifu is Sakura, almost invariably, the next question that springs to their mind is: \"If that's the case, then why does your bot take after the **opposite** *Fates* imouto healer?\"\n\nThe short answer is: I already had a SakuraBot for another server at the time of writing the bot, and lost a vote that would have made the bot be Priscilla.\n\nFor the full story, please use the command `FEH!whyelise full` or use the command in PM.",0x008b8b)
  elsif @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event.respond "When people learn that my main waifu is Sakura, almost invariably, the next question that springs to their mind is: \"If that's the case, then why does your bot take after the **opposite** *Fates* imouto healer?\"\n\nThe short answer is: I already had a SakuraBot for another server at the time of writing the bot, and lost a vote that would have made the bot be Priscilla.\n\nThe long answer is:\n\nBack when the bot that would become EliseBot was created, she was an entirely different beast.  At the time, all the tier lists were quite horrible - ten times worse than everyone says the DefPloy iteration of the Gamepedia list was.  So one of the servers I was in made their own tier list, and the bot that would become Elise was intended to be a server-specific bot to look up information on their custom tier list.\n\nAt this time, the server had a few other bots, and they were all named after *Fire Emblem* characters: Lucina was a mod bot, NinoBot was NinoBot, and Robin(M) was a bot for looking up information in *Awakening* and *Fates*.  In *Heroes* mechanics, that was a red character, a green character, and a blue character.  So the admin of the server suggested that I name the bot after a colorless character so the bots formed a color-balanced team."
    event.respond "When it got time to actually name the bot, a friend on the server suggested Priscilla, and this idea appealed to me because I had been trying to summon for Priscilla for over three months with no success.  \"If the game isn't gonna give me a Priscilla, I'll just make one.\"  So she was coded with the name PriscillaBot - and in fact, that's still the filename of her source code.\n\nThe next day, I wake up to a message from the admin of the server, basically saying \"I like Priscilla as well, but shouldn't we make the bot someone the casual FEH player will recognize?\"  He, knowing my waifuism, suggested Sakura, and I had to turn him down.  So the two of us put the bot's identity up for a vote in the server, and PriscillaBot lost 6-7 in favor of EliseBot.\n\nEventually, Gamepedia started seeing things similarly to the server in question, and the server-specific tier list was depricated.  But by this point, I had already started experimenting with what would become her `stats` command, so Elise, rather than dying off, evolved into the community resource that you know her as today.\n\nAnd yes, during the healer gauntlet, her original server was tossing jokes around left and right that it was a battle for the bot's true identity."
  else
    create_embed(event,"__A word from my developer__","When people learn that my main waifu is Sakura, almost invariably, the next question that springs to their mind is: \"If that's the case, then why does your bot take after the **opposite** *Fates* imouto healer?\"\n\nThe short answer is: I already had a SakuraBot for another server at the time of writing the bot, and lost a vote that would have made the bot be Priscilla.\n\nThe long answer is:\n\nBack when the bot that would become EliseBot was created, she was an entirely different beast.  At the time, all the tier lists were quite horrible - ten times worse than everyone says the DefPloy iteration of the Gamepedia list was.  So one of the servers I was in made their own tier list, and the bot that would become Elise was intended to be a server-specific bot to look up information on their custom tier list.\n\nAt this time, the server had a few other bots, and they were all named after *Fire Emblem* characters: Lucina was a mod bot, NinoBot was NinoBot, and Robin(M) was a bot for looking up information in *Awakening* and *Fates*.  In *Heroes* mechanics, that was a red character, a green character, and a blue character.  So the admin of the server suggested that I name the bot after a colorless character so the bots formed a color-balanced team.",0x008b8b)
    create_embed(event,'',"When it got time to actually name the bot, a friend on the server suggested Priscilla, and this idea appealed to me because I had been trying to summon for Priscilla for over three months with no success.  \"If the game isn't gonna give me a Priscilla, I'll just make one.\"  So she was coded with the name PriscillaBot - and in fact, that's still the filename of her source code.\n\nThe next day, I wake up to a message from the admin of the server, basically saying \"I like Priscilla as well, but shouldn't we make the bot someone the casual FEH player will recognize?\"  He, knowing my waifuism, suggested Sakura, and I had to turn him down.  So the two of us put the bot's identity up for a vote in the server, and PriscillaBot lost 6-7 in favor of EliseBot.\n\nEventually, Gamepedia started seeing things similarly to the server in question, and the server-specific tier list was depricated.  But by this point, I had already started experimenting with what would become her `stats` command, so Elise, rather than dying off, evolved into the community resource that you know her as today.",0xCF4030,"And yes, during the healer gauntlet, her original server was tossing jokes around left and right that it was a battle for the bot's true identity.")
  end
  return nil
end

bot.command([:skillrarity,:onestar,:twostar,:threestar,:fourstar,:fivestar,:skill_rarity,:one_star,:two_star,:three_star,:four_star,:five_star]) do |event|
  return nil if overlap_prevent(event)
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
      k[0].push(bnr[2][i]) if k2=='Red'
      k[1].push(bnr[2][i]) if k2=='Blue'
      k[2].push(bnr[2][i]) if k2=='Green'
      k[3].push(bnr[2][i]) if k2=='Colorless'
      k[4].push(bnr[2][i]) unless ['Red','Blue','Green','Colorless'].include?(k2)
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
        str="#{str}\nOrb ##{cracked_orbs[i][1]} contained a #{cracked_orbs[i][0][0]} **#{cracked_orbs[i][0][1]}**#{unit_moji(bot,event,-1,cracked_orbs[i][0][1])} (*#{cracked_orbs[i][0][2]}*)"
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
  event.channel.send_temporary_message('Calculating data, please wait...',8)
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
  u=0
  n=0
  au=0
  b=[]
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
  for i in 0...k.length
    x=detect_multi_unit_alias(event,k[i],k[i],1)
    name=nil
    if k[i].downcase=="mathoo's"
      m=true
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
          event << "Ambiguous Unit #{au}: #{x[0]} - #{list_lift(x[1].map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"},'or')}"
        else
          name=@units[find_unit(find_name_in_string(event,x[1][0]),event)][0]
          summon_type=@units[find_unit(find_name_in_string(event,x[1][0]),event)][9][0].downcase
        end
      else
        au+=1
        event << "Ambiguous Unit #{au}: #{x[0]} - #{list_lift(x[1].map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"},'or')}"
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
        event << "Nonsense term #{n}: #{k[i]}"
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
      if m && find_in_dev_units(name)>=0
        dv=@dev_units[find_in_dev_units(name)]
        r[0]=dv[1]
        r[1]=dv[2]
        r[2]=dv[3].gsub(' ','')
        r[3]=dv[4].gsub(' ','')
      end
      st=get_stats(event,name,40,r[0],r[1],r[2],r[3])
      b.push(st[1]+st[2]+st[3]+st[4]+st[5])
      event << "Unit #{u}: #{r[0]}#{@rarity_stars[r[0]-1]} #{name.gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,-1,name,m)} +#{r[1]} #{"(+#{r[2]}, -#{r[3]})" if !['',' '].include?(r[2]) || !['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}     BST: #{b[b.length-1]}"
    end
  end
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
      if colors[i2].max==i2 && b.length>=i2*4
        if emblem_name[i2].length>0
          emblem_name[i2]="Color-balanced #{emblem_name[i2]}"
        else
          emblem_name[i2]='Color-balanced'
        end
      end
    end
    b2=b.inject(0){|sum,x| sum + x }
    if b.length==1
    elsif b.length<=4
      if emblem_name[1].length>0
        event << "**#{emblem_name[1]} team BST: #{b2}**"
      else
        event << "**Team BST: #{b2}**"
      end
    elsif b.length<=8
      event << "**Team BST of first four listed#{", which constitutes a #{emblem_name[1]} team" if emblem_name[1].length>0}: #{b[0]+b[1]+b[2]+b[3]}**"
      event << "*Team BST of all listed units#{", which constitutes a #{emblem_name[2]} team" if emblem_name[2].length>0}: #{b[0]+b[1]+b[2]+b[3]+b[4]+b[5]+b[6]+b[7]}*"
    else
      event << "**Team BST of first four listed#{", which constitutes a #{emblem_name[1]} team" if emblem_name[1].length>0}: #{b[0]+b[1]+b[2]+b[3]}**"
      event << "*Team BST of first eight listed#{", which constitutes a #{emblem_name[2]} team" if emblem_name[2].length>0}: #{b[0]+b[1]+b[2]+b[3]+b[4]+b[5]+b[6]+b[7]}*"
      event << "Total BST of all listed units: #{b2}"
    end
  end
  event << ""
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

bot.command(:skill) do |event, *args|
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

bot.command([:skills,:fodder]) do |event, *args|
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
    if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
      event.respond "Steel's waifu is not in the game."
    elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
      event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
    elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
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
  elsif event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
    event.respond "Steel's waifu is not in the game."
  elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
    event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
  else
    event.respond "No matches found.  If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s."
  end
  return nil
end

bot.command([:stats,:stat]) do |event, *args|
  return nil if overlap_prevent(event)
  if ['compare','comparison'].include?(args[0].downcase)
    args.shift
    k=comparison(event,args,bot)
    return nil unless k<1
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
  elsif ['skill','skills'].include?(args[0].downcase)
    args.shift
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  elsif ['tiny','small','smol','micro','squashed','little'].include?(args[0].downcase)
    sze=args[0]
    args.shift
    k=find_name_in_string(event,nil,1)
    if k.nil?
      w=nil
      if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
        event.respond "Steel's waifu is not in the game."
      elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
        event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
      elsif !detect_multi_unit_alias(event,event.message.text.downcase.gsub(sze.downcase,''),event.message.text.downcase.gsub(sze.downcase,'')).nil?
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
    if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
      event.respond "Steel's waifu is not in the game."
    elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
      event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
    elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
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
    if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
      event.respond "Steel's waifu is not in the game."
    elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
      event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
    elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
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

bot.command([:giant,:big,:tol,:macro,:large,:huge,:massive,:giantstats,:bigstats,:tolstats,:macrostats,:largestats,:hugestats,:massivestats,:giantstat,:bigstat,:tolstat,:macrostat,:largestat,:hugestat,:massivestat,:statsgiant,:statsbig,:statstol,:statsmacro,:statslarge,:statshuge,:statsmassive,:statgiant,:statbig,:stattol,:statmacro,:statlarge,:stathuge,:statmassive,:statol]) do |event, *args|
  return nil if overlap_prevent(event)
  k=find_name_in_string(event,nil,1)
  if k.nil?
    w=nil
    if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
      event.respond "Steel's waifu is not in the game."
    elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
      event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
    elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
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

bot.command([:unit, :data, :statsskills, :statskills, :stats_skills, :stat_skills, :statsandskills, :statandskills, :stats_and_skills, :stat_and_skills, :statsskill, :statskill, :stats_skill, :stat_skill, :statsandskill, :statandskill, :stats_and_skill, :stat_and_skill]) do |event, *args|
  return nil if overlap_prevent(event)
  if ['compare','comparison'].include?(args[0].downcase)
    args.shift
    k=comparison(event,args,bot)
    return nil unless k<1
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
  data_load()
  nicknames_load()
  if newname.nil? || unit.nil?
    event.respond 'You must specify both a new alias and a unit to give the alias to.'
    return nil
  elsif event.user.id != 167657750971547648 && event.server.nil?
    event.respond 'Only my developer is allowed to use this command in PM.'
    return nil
  elsif !is_mod?(event.user,event.server,event.channel) && ![368976843883151362,195303206933233665].include?(event.user.id)
    event.respond 'You are not a mod.'
    return nil
  elsif newname.include?('"') || newname.include?("\n")
    event.respond 'Full stop.  " is not allowed in an alias.'
    return nil
  elsif find_unit(newname,event)>=0
    if find_unit(unit,event)>=0
      event.respond "Someone already has the name #{newname}"
      return nil
    elsif [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?
    else
      x=newname
      newname=unit
      unit=x
    end
  elsif find_unit(unit,event)<0
    event.respond "#{unit} is not a unit."
    return nil
  end
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  newname=newname.gsub('!','').gsub('(','').gsub(')','').gsub('_','')
  srv=0
  srv=event.server.id unless event.server.nil?
  srv=modifier.to_i if event.user.id==167657750971547648 && modifier.to_i.to_s==modifier
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  checkstr=normalize(newname)
  k=event.message.emoji
  for i in 0...k.length
    checkstr=checkstr.gsub("<:#{k[i].name}:#{k[i].id}>",k[i].name)
  end
  unt=@units[find_unit(unit,event)]
  checkstr2=checkstr.downcase.gsub(unt[12].split(', ')[0].gsub('*','').downcase,'')
  cck=nil
  cck=unt[12].split(', ')[1][0,1].downcase if unt[12].split(', ').length>1
  if find_skill(checkstr,event,false,true)>=0
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nThat is the name of a skill, and I do not want confusion when people in this server attempt `FEH!#{newname}`"
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** #{newname} is a skill name.")
    return nil
  elsif checkstr2.length<=1 && checkstr2 != cck && event.user.id != 167657750971547648
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nOne need look no farther than BLucina and BLyn to understand why single-letter alias differentiation is a bad idea."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Single-letter differentiation.")
    return nil
  elsif unt[0]=="Odin" && checkstr.downcase.include?("owain")
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nYes, the two are the same character, but eventually Swordmaster Owain will join the game, and this alias will conflict."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif ["Lyn(Wind)","Lyn(Valentines)","Lyn(Bride)","Lyn(Brave)"].include?(unt[0]) && ['llyn','lynl'].include?(checkstr.downcase)
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\n\"L\" could stand for \"Love\", which describes both Lyn(Bride) and Lyn(Valentines); or it could stand for \"Legend\", which not only applies to the Legendary Hero Lyn(Wind), but Lyn(Brave) as well, since she was the result of Lyn winning the Choose Your *Legends* poll for 2017."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Confusion prevention.")
    return nil
  elsif unt[0]=="Laslow" && checkstr.downcase.include?("inigo")
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nYes, the two are the same character, but eventually Inigo will join the game, and this alias will conflict."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif unt[0]=="Selena" && checkstr.downcase.include?("severa")
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nYes, the two are the same character, but eventually Severa will join the game, and this alias will conflict."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif unt[0]=="Charlotte(Bride)" && checkstr.downcase.include?("charlotte")
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nYes, she is Charlotte, but eventually, she will join the game as a non-seaonal unit."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif unt[0]=="Inigo(Performing)" && checkstr.downcase.include?("inigo")
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nYes, he is #{unt[0].gsub('(performing)','')}, but eventually, he will join the game as a non-seaonal unit."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif !detect_multi_unit_alias(event,checkstr.downcase,checkstr.downcase,2).nil?
    x=detect_multi_unit_alias(event,checkstr.downcase,checkstr.downcase,2)
    if checkstr.downcase==x[0] || (!x[2].nil? && x[2].include?(checkstr.downcase))
      event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nThis is a multi-unit alias."
      bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Confusion prevention.")
      return nil
    end
  elsif checkstr.downcase =~ /(7|t)+?h+?(o|0)+?(7|t)+?/
    event.respond "That name has __***NOT***__ been added to #{unt[0]}'s aliases."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  elsif checkstr.downcase =~ /n+?(i|1)+?(b|g|8)+?(a|4|(e|3)+?r+?)+?/
    event.respond "That name has __***NOT***__ been added to #{unt[0]}'s aliases."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** >Censored< for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  end
  newname=normalize(newname)
  m=nil
  m=[event.server.id] unless event.server.nil?
  srv=0
  srv=event.server.id unless event.server.nil?
  srv=modifier.to_i if event.user.id==167657750971547648 && modifier.to_i.to_s==modifier
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  if event.user.id==167657750971547648 && modifier.to_i.to_s==modifier
    m=[modifier.to_i]
    modifier=nil
  end
  chn=event.channel.id
  chn=modifier2.to_i if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
  m=nil if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?
  unit=unt[0]
  double=false
  for i in 0...@aliases.length
    if @aliases[i][2].nil?
    elsif @aliases[i][0].downcase==newname.downcase && @aliases[i][1].downcase==unit.downcase
      if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?
        @aliases[i][2]=nil
        @aliases[i][3]=nil
        @aliases[i].compact!
        bot.channel(chn).send_message("The alias #{newname} for #{unit.gsub('Lavatain','Laevatein')} exists in a server already.  Making it global now.")
        event.respond "The alias #{newname} for #{unit.gsub('Lavatain','Laevatein')} exists in a server already.  Making it global now.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit} - gone global.")
        double=true
      else
        @aliases[i][2].push(srv)
        bot.channel(chn).send_message("The alias #{newname} for #{unit.gsub('Lavatain','Laevatein')} exists in another server already.  Adding this server to those that can use it.")
        event.respond "The alias #{newname} for #{unit.gsub('Lavatain','Laevatein')} exists in another server already.  Adding this server to those that can use it.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        bot.user(167657750971547648).pm("The alias **#{@aliases[i][0]}** for the character **#{@aliases[i][1]}** is used in quite a few servers.  It might be time to make this global") if @aliases[i][2].length >= bot.servers.length / 20 && @aliases[i][3].nil?
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit} - gained a new server that supports it.")
        double=true
      end
    end
  end
  unless double
    @aliases.push([newname,unit,m].compact)
    @aliases.sort! {|a,b| (a[1].downcase <=> b[1].downcase) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].downcase <=> b[1].downcase)}
    bot.channel(chn).send_message("#{newname} has been added to #{unit}'s aliases#{" globally" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?}.\nPlease test to be sure that the alias stuck.")
    event.respond "#{newname} has been added to #{unit}'s aliases#{" globally" if event.user.id==167657750971547648 && !modifier.nil?}." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}#{" - global alias" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?}")
  end
  @aliases.uniq!
  nzzz=@aliases.map{|a| a}
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...nzzz.length
      f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
    end
  }
  nicknames_load()
  nzzz=@aliases.map{|a| a}
  if nzzz[nzzz.length-1].length>1 && nzzz[nzzz.length-1][1]>='Zephiel'
    bot.channel(logchn).send_message('Alias list saved.')
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
      for i in 0...nzzz.length
        f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
      end
    }
    bot.channel(logchn).send_message('Alias list has been backed up.')
  end
  return nil
end

bot.command([:checkaliases,:aliases,:seealiases]) do |event, *args|
  return nil if overlap_prevent(event)
  list_unit_aliases(event,args,bot)
  return nil
end

bot.command([:serveraliases,:saliases]) do |event, *args|
  return nil if overlap_prevent(event)
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
  elsif find_unit(name,event)<0
    event.respond "#{name} is not anyone's alias, silly!"
    return nil
  end
  j=find_unit(name,event)
  k=0
  k=event.server.id unless event.server.nil?
  for izzz in 0...@aliases.length
    if @aliases[izzz][0].downcase==name.downcase
      if @aliases[izzz][2].nil? && event.user.id != 167657750971547648
        event.respond 'You cannot remove a global alias'
        return nil
      elsif @aliases[izzz][2].nil? || @aliases[izzz][2].include?(k)
        unless @aliases[izzz][2].nil?
          for izzz2 in 0...@aliases[izzz][2].length
            @aliases[izzz][2][izzz2]=nil if @aliases[izzz][2][izzz2]==k
          end
          @aliases[izzz][2].compact!
        end
        @aliases[izzz]=nil if @aliases[izzz][2].nil? || @aliases[izzz][2].length<=0
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
  bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n~~**Alias:** #{name} for #{@units[j][0]}~~ **DELETED**.")
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...@aliases.length
      f.puts "#{@aliases[i].to_s}#{"\n" if i<@aliases.length-1}"
    end
  }
  nicknames_load()
  event.respond "#{name} has been removed from #{@units[j][0].gsub('Lavatain','Laevatein')}'s aliases."
  nzzz=@aliases.map{|a| a}
  if nzzz[nzzz.length-1].length>1 && nzzz[nzzz.length-1][1]>="Zephiel"
    bot.channel(logchn).send_message("Alias list saved.")
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
      for i in 0...nzzz.length
        f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
      end
    }
    bot.channel(logchn).send_message("Alias list has been backed up.")
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
        if @groups[i][1].length<=0
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
  elsif find_group(groupname,event)>-1 && @groups[find_group(groupname,event)][2].nil? && event.user.id != 167657750971547648
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
    p1=find_in_units(event,mode,true)
    p1=p1.map{|q| "#{'~~' if !["Laevatein","- - -"].include?(q) && !@units[find_unit(q,event,false,true)][13][0].nil?}#{q}#{'~~' if !["Laevatein","- - -"].include?(q) && !@units[find_unit(q,event,false,true)][13][0].nil?}"}
    p2=find_in_skills(event,mode,true,p1)
    if !p1.is_a?(Array) && !p2.is_a?(Array)
      event.respond 'Your request is gibberish.'
    elsif !p1.is_a?(Array)
      display_skills(event, mode)
    elsif !p2.is_a?(Array)
      display_units(event, mode)
    elsif p1.join("\n").length+p2.join("\n").length<=1950
      create_embed(event,"Results",'',0x9400D3,nil,nil,[['**Units**',p1.join("\n")],['**Skills**',p2.join("\n")]],2)
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
    @aliases.sort! {|a,b| (a[1].downcase <=> b[1].downcase) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].downcase <=> b[1].downcase)}
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
  atk='<:GenericAttackS:467065089598423051>'
  if atkstat.uniq.length==1
    atk='<:StrengthS:467037520484630539>' if atkstat.uniq[0]=='Strength'
    atk='<:MagicS:467043867611627520>' if atkstat.uniq[0]=='Magic'
    atk='<:FreezeS:467043868148236299>' if atkstat.uniq[0]=='Freeze'
  end
  create_embed(event,"__**Average among #{k222.length} units**__","<:HP_S:467037520538894336> HP: #{div_100(f2[1]*100/k222.length)}\n#{atk} Attack: #{div_100(f2[2]*100/k222.length)}\n<:SpeedS:467037520534962186> Speed: #{div_100(f2[3]*100/k222.length)}\n<:DefenseS:467037520249487372> Defense: #{div_100(f2[4]*100/k222.length)}\n<:ResistanceS:467037520379641858> Resistance: #{div_100(f2[5]*100/k222.length)}\n\nBST: #{div_100((f2[1]+f2[2]+f2[3]+f2[4]+f2[5])*100/k222.length)}",ccz)
  return nil
end

bot.command([:bestamong,:bestin,:beststats,:higheststats]) do |event, *args|
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
  stemoji=['','<:HP_S:467037520538894336>','<:GenericAttackS:467065089598423051>','<:SpeedS:467037520534962186>','<:DefenseS:467037520249487372>','<:ResistanceS:467037520379641858>']
  if atkstat.uniq.length==1
    stemoji[2]='<:StrengthS:467037520484630539>' if atkstat.uniq[0]=='Strength'
    stemoji[2]='<:MagicS:467043867611627520>' if atkstat.uniq[0]=='Magic'
    stemoji[2]='<:FreezeS:467043868148236299>' if atkstat.uniq[0]=='Freeze'
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

bot.command([:worstamong,:worstin,:worststats,:loweststats]) do |event, *args|
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
  stemoji=['','<:HP_S:467037520538894336>','<:GenericAttackS:467065089598423051>','<:SpeedS:467037520534962186>','<:DefenseS:467037520249487372>','<:ResistanceS:467037520379641858>']
  if atkstat.uniq.length==1
    stemoji[2]='<:StrengthS:467037520484630539>' if atkstat.uniq[0]=='Strength'
    stemoji[2]='<:MagicS:467043867611627520>' if atkstat.uniq[0]=='Magic'
    stemoji[2]='<:FreezeS:467043868148236299>' if atkstat.uniq[0]=='Freeze'
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
  metadata_load()
  if @embedless.include?(event.user.id)
    for i in 0...@embedless.length
      @embedless[i]=nil if @embedless[i]==event.user.id
    end
    @embedless.compact!
    event.respond 'You will now see my replies as embeds again.'
  else
    @embedless.push(event.user.id)
    event.respond 'You will now see my replies as plaintext.'
  end
  metadata_save()
  return nil
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
  event << "1.) Look for your unit's rarity in the top row."
  event << ''
  event << "2.) Look for the value of your unit's GP in the leftmost column."
  event << "- If you don't know the growth points, you can find them on the wiki or by including the word `growths` in your message when using the `FEH!stats` command."
  event << ''
  event << "3.) Where the two intersect is the character's actual growth value."
  event << "- This is how many points the unit's stat increases by when they go from Level 1 to Level 40."
  event << ''
  event << "4.) In addition to the level 1 stats, a unit's nature affects their GPs."
  event << "- A boon in a stat increases that stat's GP by 1 compared to a neutral version of the unit."
  event << "- Likewise, a bane in a stat decreases the stat's GP by 1 compared to neutral."
  event << ''
  event << '5.) "Superboons" and "Superbanes" are marked by the thick blue and red arrows, respectively.'
  event << '- A superboon is when a stat increases by 4 instead of the usual 3.'
  event << '- Likewise, a superbane is when a stat decreases by 4 instead of the usual 3.'
  event << '- (This chart shows supernatures as increasing/decreasing by 3 instead of 2, but this does not account for the +1/-1 on the level 1 stats.)'
  event << ''
  event << '6.) If 1<:Icon_Rarity_1:448266417481973781>-2<:Icon_Rarity_2:448266417872044032> units could get natures, then they would have the possibility for "microboons" and "microbanes", where a stat increases or decreases by 2 instead of the usual 3.'
  event << '- These are marked by the thin blue and red arrows.'
  event << ''
  event << 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Growths.png'
end

bot.command(:merges) do |event|
  return nil if overlap_prevent(event)
  event << '__**How to predict what stats will increase by a merge**__'
  event << "1.) Look at the original unit's level 1 stats at 5<:Icon_Rarity_5:448266417553539104>."
  event << '- The stats must be at 5<:Icon_Rarity_5:448266417553539104> regardless of the rarity of the unit being merged.'
  event << ''
  event << '2.) Sort them by value, highest first and lowest last.'
  event << '- in the case of two stats being equal, the stat listed higher in game goes first'
  event << '- thus, if all five stats were equal, the order would be HP, Attack, Speed, Defense, Resistance...exactly as displayed in game.'
  event << ''
  event << '3.) The resulting list is the order in which stats increase, and each merge increases the next two stats on the list, which loops.'
  event << ''
  event << "4.) This does mean that the base unit's nature can affect the order in which stats increase."
  event << "- For example, Sakura(Halloween)'s level 1 neutral stats are 16/8/8/4/8.  This means under normal circumstances, her stats increase in the following order: HP->Atk->Spd->Res->Def."
  event << "- However, consider a +Res -Spd Sakura(Halloween); her level 1 stats are 16/8/7/4/9.  This changes the order stats increase to HP->Res->Atk->Spd->Def."
end

bot.command(:invite) do |event, user|
  return nil if overlap_prevent(event)
  usr=event.user
  txt="To invite me to your server: <https://goo.gl/HEuQK2>\nTo look at my source code: <https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/PriscillaBot.rb>\nTo follow my creator's development Twitter and learn of updates: <https://twitter.com/EliseBotDev>\nIf you suggested me to server mods and they ask what I do, copy this image link to them: https://orig00.deviantart.net/cd2d/f/2018/047/e/0/marketing___elise_by_rot8erconex-dbxj4mq.png"
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
  s5=event.message.text.downcase
  s5=s5[2,s5.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s5=s5[4,s5.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s5.split(' ')
  s3='Bug Report'
  s3='Suggestion' if a[0]=='suggestion'
  s3='Feedback' if a[0]=='feedback'
  if event.server.nil?
    s="**#{s3} sent by PM**"
  else
    s="**Server:** #{event.server.name} (#{event.server.id}) - #{["<:Shard_Colorless:443733396921909248> Transparent","<:Shard_Red:443733396842348545> Scarlet","<:Shard_Blue:443733396741554181> Azure","<:Shard_Green:443733397190344714> Verdant"][(event.server.id >> 22) % 4]} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})"
  end
  f=event.message.text.split(' ')
  f="#{f[0]} "
  bot.user(167657750971547648).pm("#{s}\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{s3}:** #{first_sub(event.message.text,f,'',1)}")
  s3='Bug' if s3=='Bug Report'
  t=Time.now
  event << "Your #{s3.downcase} has been logged."
  return nil
end

bot.command([:tools,:links]) do |event|
  return nil if overlap_prevent(event)
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?('mobile') || event.message.text.downcase.include?('phone')
    event << '**Useful tools for players of** ***Fire Emblem Heroes***'
    event << '__Download the game__'
    event << 'Google Play: <https://play.google.com/store/apps/details?id=com.nintendo.zaba&hl=en>'
    event << 'Apple App Store: <https://itunes.apple.com/app/id1181774280>'
    event << ''
    event << '__Wikis and Databases__'
    event << 'Gamepedia FEH wiki: <https://feheroes.gamepedia.com/>'
    event << 'Gamepress FEH database: <https://fireemblem.gamepress.gg/>'
    event << ''
    event << '__Simulators__'
    event << 'Summon Simulator: <https://feh-stuff.github.io/summon-simulator/>'
    event << 'Inheritance tracker: <https://arghblargh.github.io/feh-inheritance-tool/>'
    event << 'Visual unit builder: <https://feh-stuff.github.io/unit-builder/>'
    event << ''
    event << '__Damage Calculators__'
    event << "ASFox's mass duel simulator: <http://arcticsilverfox.com/feh_sim/>"
    event << "Andu2's mass duel simulator fork: <https://andu2.github.io/FEH-Mass-Simulator/>"
    event << ''
    event << 'FEHKeeper: <https://www.fehkeeper.com/>'
    event << ''
    event << 'Arena Score Calculator: <http://www.arcticsilverfox.com/score_calc/>'
    event << ''
    event << 'Glimmer vs. Moonbow: <https://i.imgur.com/kDKPMp7.png>'
  else
    create_embed(event,'**Useful tools for players of** ***Fire Emblem Heroes***',"__Download the game__\n[Google Play](https://play.google.com/store/apps/details?id=com.nintendo.zaba&hl=en)\n[Apple App Store](https://itunes.apple.com/app/id1181774280)\n\n__Wikis and Databases__\n[Gamepedia FEH wiki](https://feheroes.gamepedia.com/)\n[Gamepress FEH database](https://fireemblem.gamepress.gg/)\n\n__Simulators__\n[Summon Simulator](https://feh-stuff.github.io/summon-simulator/)\n[Inheritance tracker](https://arghblargh.github.io/feh-inheritance-tool/)\n[Visual unit builder](https://feh-stuff.github.io/unit-builder/)\n\n__Damage Calculators__\n[ASFox's mass duel simulator](http://arcticsilverfox.com/feh_sim/)\n[Andu2's mass duel simulator fork](https://andu2.github.io/FEH-Mass-Simulator/)\n\n[FEHKeeper](https://www.fehkeeper.com/)\n\n[Arena Score Calculator](http://www.arcticsilverfox.com/score_calc/)\n\n[Glimmer vs. Moonbow](https://i.imgur.com/kDKPMp7.png)",0xD49F61,nil,'https://lh3.googleusercontent.com/4ziItIIQ0pMqlUigjosG05YC5VkHKNy3ps26F5Hfi2lt0Zs3yB7dyi9bUQ4q1GgEPSE=w300-rw')
    event.respond 'If you are on a mobile device and cannot click the links in the embed above, type `FEH!tools mobile` to receive this message as plaintext.'
  end
  event << ''
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

bot.command([:today,:todayinfeh,:todayInFEH,:today_in_feh,:today_in_FEH,:daily]) do |event|
  return nil if overlap_prevent(event)
  t=Time.now
  timeshift=8
  t-=60*60*timeshift
  str="Time elapsed since today's reset: #{"#{t.hour} hours, " if t.hour>0}#{"#{'0' if t.min<10}#{t.min} minutes, " if t.hour>0 || t.min>0}#{'0' if t.sec<10}#{t.sec} seconds"
  str="#{str}\nTime until tomorrow's reset: #{"#{23-t.hour} hours, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds"
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  str="#{str}\nThe Arena season ends in #{"#{15-t.hour} hours, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete your daily Arena-related quests before then!" if date%7==4 && 15-t.hour>=0
  colors=['Green <:Shard_Green:443733397190344714><:Crystal_Verdant:445510676845166592><:Badge_Verdant:445510676056899594><:Great_Badge_Verdant:443704780943261707>',
          'Colorless <:Shard_Colorless:443733396921909248><:Crystal_Transparent:445510676295843870><:Badge_Transparent:445510675976945664><:Great_Badge_Transparent:443704781597573120>',
          'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Red <:Shard_Red:443733396842348545><:Crystal_Scarlet:445510676350500897><:Badge_Scarlet:445510676060962816><:Great_Badge_Scarlet:443704781001850910>',
          'Blue <:Shard_Blue:443733396741554181><:Crystal_Azure:445510676434124800><:Badge_Azure:445510675352125441><:Great_Badge_Azure:443704780783616016>']
  dhb=['Sophia <:Red_Tome:443172811826003968><:Icon_Move_Infantry:443331187579289601>',
       'Virion <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
       'Hana <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601>',
       'Subaki <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
       'Donnel <:Blue_Blade:467112472768151562><:Icon_Move_Infantry:443331187579289601>',
       'Lissa <:Colorless_Staff:443692132323295243><:Icon_Move_Infantry:443331187579289601>',
       'Gunter <:Green_Blade:467122927230386207><:Icon_Move_Cavalry:443331186530451466>',
       'Cecilia <:Green_Tome:467122927666593822><:Icon_Move_Cavalry:443331186530451466>',
       'Felicia <:Colorless_Dagger:443692132683743232><:Icon_Move_Infantry:443331187579289601>',
       'Wrys <:Colorless_Staff:443692132323295243><:Icon_Move_Infantry:443331187579289601>',
       'Olivia <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601>',
       'Stahl <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466>']
  ghb=['Ursula <:Blue_Tome:467112472394858508><:Icon_Move_Cavalry:443331186530451466> / Clarisse <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
       'Lloyd <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Berkut <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Michalis <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Valter <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
       'Xander <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466> / Arvis <:Red_Tome:443172811826003968><:Icon_Move_Infantry:443331187579289601>',
       'Narcian <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Zephiel <:Red_Blade:443172811830198282><:Icon_Move_Armor:443331186316673025>',
       'Navarre <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Camus <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Robin(F) <:Green_Tome:467122927666593822><:Icon_Move_Infantry:443331187579289601> / Legion <:Green_Blade:467122927230386207><:Icon_Move_Infantry:443331187579289601>']
  rd=['Cavalry <:Icon_Move_Cavalry:443331186530451466>',
      'Flying <:Icon_Move_Flier:443331186698354698>',
      'Infantry <:Icon_Move_Infantry:443331187579289601>',
      'Armored <:Icon_Move_Armor:443331186316673025>']
  garden=['Earth <:Legendary_Effect_Earth:443331186392170508>',
          'Fire <:Legendary_Effect_Fire:443331186480119808>',
          'Water <:Legendary_Effect_Water:443331186534776832>',
          'Wind <:Legendary_Effect_Wind:443331186467536896>']
  str="#{str}\n"
  str="#{str}\nDate assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
  str="#{str}\nDays since game release: #{longFormattedNumber(date)}"
  if event.user.id==167657750971547648 && @shardizard==4
    str="#{str}\nDaycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12"
    str="#{str}\nWeekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%4+1}/4(Saturday) - #{week_from(date,0)%12+1}/12(Thursday)"
  end
  str2='__**Today in** ***Fire Emblem Heroes***__'
  str2="#{str2}\nTraining Tower color: #{colors[date%7]}"
  str2="#{str2}\nDaily Hero Battle: #{dhb[date%12]}"
  str2="#{str2}\nWeekend SP bonus!" if [1,2].include?(date%7)
  str2="#{str2}\nSpecial Training map: #{['Magic','The Workout','Melee','Ranged','Bows'][date%5]}"
  str2="#{str2}\nGrand Hero Battle revival: #{ghb[date%7].split(' / ')[0]}"
  str2="#{str2}\nGrand Hero Battle revival 2: #{ghb[date%7].split(' / ')[1]}"
  if (date)%7==3
    str2="#{str2}\nNew Blessed Gardens addition: #{garden[week_from(date,3)%4]}"
  else
    str2="#{str2}\nNewest Blessed Gardens addition: #{garden[week_from(date,3)%4]}"
  end
  str2="#{str2}\nRival Domains movement preference: #{rd[week_from(date,2)%4]}"
  if (date)%7==0
    str2="#{str2}\nNew Tactics Drills addition: #{['Skill Studies','Grandmaster'][week_from(date,0)%2]}"
  else
    str2="#{str2}\nNewest Tactics Drills addition: #{['Skill Studies','Grandmaster'][week_from(date,0)%2]}"
  end
  if [10,11].include?(week_from(date,0)%12)
    str2="#{str2}, 1<:Orb_Rainbow:471001777622351872> reward"
  else
    str2="#{str2}, 300<:Hero_Feather:471002465542602753> reward"
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
    b[i]=nil if b[i][2][0]=='-' && b[i][4].nil?
  end
  b.compact!
  c=[]
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHEvents.txt')
    c=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHEvents.txt').each_line do |line|
      c.push(line.gsub("\n",''))
    end
  else
    c=[]
  end
  for i in 0...c.length
    c[i]=c[i].split('\\'[0])
    c[i][1]='Voting Gauntlet' if c[i][1]=='VG'
    c[i][1]='Bound Hero Battle' if c[i][1]=='BHB'
    c[i][1]='Grand Hero Battle' if c[i][1]=='GHB'
    c[i][1]='Grand Conquests' if c[i][1]=='GC'
    c[i][1]='Tempest Trials' if c[i][1]=='TT' || c[i][1]=='Tempest'
    c[i][1]='Tap Battle' if c[i][1]=='Illusory Dungeon'
    c[i][1]='Log-In Bonus' if c[i][1]=='Log-In' || c[i][1]=='Login'
    c[i][2]=c[i][2].split(', ')
  end
  str=extend_message(str,str2,event,2)
  if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(' tomorrow ') || " #{event.message.text.downcase} ".include?(' next ')
    str2=disp_current_events(1)
    str=extend_message(str,str2,event,2)
    str2=disp_current_events(2)
    str=extend_message(str,str2,event,2)
    str2='__**Tomorrow in** ***Fire Emblem Heroes***__'
    str2="#{str2}\nTraining Tower color: #{colors[(date+1)%7]}"
    str2="#{str2}\nDaily Hero Battle: #{dhb[(date+1)%12]}"
    str2="#{str2}\nWeekend SP bonus!" if [1,2].include?((date+1)%7)
    str2="#{str2}\nSpecial Training map: #{['Magic','The Workout','Melee','Ranged','Bows'][(date+1)%5]}"
    str2="#{str2}\nGrand Hero Battle revival: #{ghb[(date+1)%7].split(' / ')[0]}"
    str2="#{str2}\nGrand Hero Battle revival 2: #{ghb[(date+1)%7].split(' / ')[1]}"
    str2="#{str2}\nNew Blessed Gardens addition: #{garden[week_from(date+1,3)%4]}" if (date+1)%7==3
    str2="#{str2}\nRival Domains movement preference: #{rd[week_from(date+1,2)%4]}" if (date+1)%7==2
    if (date+1)%7==0
      str2="#{str2}\nNew Tactics Drills addition: #{['Skill Studies','Grandmaster'][week_from(date+1,0)%2]}"
      if [10,11].include?(week_from(date+1,0)%12)
        str2="#{str2}, 1<:Orb_Rainbow:471001777622351872> reward"
      else
        str2="#{str2}, 300<:Hero_Feather:471002465542602753> reward"
      end
    end
    t3=t+24*60*60
    tm="#{'0' if t3.day<10}#{t3.day}/#{'0' if t3.month<10}#{t3.month}/#{t3.year}"
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0]!=tm}
    c2=c.reject{|q| q[2].nil? || q[2][0]!=tm}
    str2="#{str2}\nNew Banners: #{b2.map{|q| "*#{q[0]}*"}.join('; ')}" if b2.length>0
    str2="#{str2}\nNew Events: #{c2.map{|q| "*#{q[0]} (#{q[1]})*"}.join('; ')}" if c2.length>0
    str=extend_message(str,str2,event,2)
  else
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i>tm || q[4].split(', ')[1].split('/').reverse.join('').to_i<tm}
    c2=c.reject{|q| q[2].nil? || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    str="#{str}\nCurrent Banners: #{b2.map{|q| "*#{q[0]}*"}.join('; ')}"
    str="#{str}\nCurrent Events: #{c2.map{|q| "*#{q[0]} (#{q[1]})*"}.join('; ')}"
  end
  str=extend_message(str,"Please note that I cannot predict the following: Arena/Tempest bonus heroes, Elemental season",event,2)
  event.respond str
end

bot.command([:next,:schedule]) do |event, type|
  return nil if overlap_prevent(event)
  type='' if type.nil?
  idx=-1
  idx=1 if ['trainingtower','training_tower','tower','color','shard','crystal'].include?(type.downcase)
  idx=2 if ['free','1*','2*','f2p','freehero','free_hero'].include?(type.downcase)
  idx=3 if ['special','specialtraining','special_training'].include?(type.downcase)
  idx=4 if ['ghb'].include?(type.downcase)
  idx=5 if ['ghb2'].include?(type.downcase)
  idx=6 if ['rival','domains','domain','rd','rivaldomains','rival_domains','rivaldomain','rival_domain'].include?(type.downcase)
  idx=7 if ['blessed','blessing','garden','gardens','blessedgarden','blessed_garden','blessedgardens','blessed_gardens','blessinggarden','blessing_garden','blessinggardens','blessing_gardens'].include?(type.downcase)
  idx=8 if ['banners','summoning','summon','banner','summonings','summons'].include?(type.downcase)
  idx=9 if ['event','events'].include?(type.downcase)
  idx=10 if ['legendary','legendaries','legend','legends'].include?(type.downcase)
  idx=11 if ['tactics','tactic','drills','drill','tacticsdrills','tactics_drills','tacticsdrill','tactics_drill','tacticdrills','tactic_drills','tacticdrill','tactic_drill'].include?(type.downcase)
  if idx<0 && !safe_to_spam?(event)
    event.respond "I will not show everything at once.  Please use this command in PM, or narrow your search using one of the following terms:\nTower, Training_Tower, Color, Shard, Crystal\nFree, 1\\*, 2\\*, F2P, FreeHero\nSpecial, Special_Training\nGHB\nGHB2\nRival, Domain(s), RD, Rival_Domain(s)\nBlessed, Garden(s), Blessing, Blessed_Garden(s)\nTactics_Drills, Tactic(s), Drill(s)\nBanner(s), Summon(ing)(s)\nEvent(s)\nLegendary/Legendaries, Legend(s)"
    return nil
  end
  t=Time.now
  timeshift=8
  t-=60*60*timeshift
  msg="Date assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  msg=extend_message(msg,"Days since game release: #{longFormattedNumber(date)}",event)
  if event.user.id==167657750971547648 && @shardizard==4
    msg=extend_message(msg,"Daycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12",event)
    msg=extend_message(msg,"Weekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%4+1}/4(Saturday) - #{week_from(date,0)%12+1}/12(Thursday)",event)
  end
  if [-1,1].include?(idx)
    colors=['Green <:Shard_Green:443733397190344714><:Crystal_Verdant:445510676845166592><:Badge_Verdant:445510676056899594><:Great_Badge_Verdant:443704780943261707>',
            'Colorless <:Shard_Colorless:443733396921909248><:Crystal_Transparent:445510676295843870><:Badge_Transparent:445510675976945664><:Great_Badge_Transparent:443704781597573120>',
            'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Red <:Shard_Red:443733396842348545><:Crystal_Scarlet:445510676350500897><:Badge_Scarlet:445510676060962816><:Great_Badge_Scarlet:443704781001850910>',
            'Blue <:Shard_Blue:443733396741554181><:Crystal_Azure:445510676434124800><:Badge_Azure:445510675352125441><:Great_Badge_Azure:443704780783616016>']
    colors=colors.rotate(date%7)
    msg2='__**Training Tower colors**__'
    for i in 0...colors.length
      if i==0
        msg2="#{msg2}\n#{colors[i]} - Today"
      elsif colors[i]!=colors[i-1]
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{colors[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    unless colors[0]==colors[colors.length-1]
      t2=t+24*60*60*7
      msg2="#{msg2}\n#{colors[0]} - 7 days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    end
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,2].include?(idx)
    dhb=['Sophia <:Red_Tome:443172811826003968><:Icon_Move_Infantry:443331187579289601>',
         'Virion <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
         'Hana <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601>',
         'Subaki <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
         'Donnel <:Blue_Blade:467112472768151562><:Icon_Move_Infantry:443331187579289601>',
         'Lissa <:Colorless_Staff:443692132323295243><:Icon_Move_Infantry:443331187579289601>',
         'Gunter <:Green_Blade:467122927230386207><:Icon_Move_Cavalry:443331186530451466>',
         'Cecilia <:Green_Tome:467122927666593822><:Icon_Move_Cavalry:443331186530451466>',
         'Felicia <:Colorless_Dagger:443692132683743232><:Icon_Move_Infantry:443331187579289601>',
         'Wrys <:Colorless_Staff:443692132323295243><:Icon_Move_Infantry:443331187579289601>',
         'Olivia <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601>',
         'Stahl <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466>']
    dhb=dhb.rotate(date%12)
    msg2='__**Daily Hero Battles**__'
    for i in 0...dhb.length
      if i==0
        msg2="#{msg2}\n#{dhb[i]} - Today"
      else
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{dhb[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    t2=t+24*60*60*12
    msg2="#{msg2}\n#{dhb[0]} - 12 days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,3].include?(idx)
    spec=['Magic','The Workout','Melee','Ranged','Bows'].rotate(date%5)
    msg2="__**Special Training Maps**__"
    for i in 0...spec.length
      if i==0
        msg2="#{msg2}\n#{spec[i]} - Today"
      else
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{spec[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    t2=t+24*60*60*5
    msg2="#{msg2}\n#{spec[0]} - 5 days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    msg=extend_message(msg,msg2,event,2)
  end
  ghb=['Ursula <:Blue_Tome:467112472394858508><:Icon_Move_Cavalry:443331186530451466> / Clarisse <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
       'Lloyd <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Berkut <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Michalis <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Valter <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
       'Xander <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466> / Arvis <:Red_Tome:443172811826003968><:Icon_Move_Infantry:443331187579289601>',
       'Narcian <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Zephiel <:Red_Blade:443172811830198282><:Icon_Move_Armor:443331186316673025>',
       'Navarre <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Camus <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Robin(F) <:Green_Tome:467122927666593822><:Icon_Move_Infantry:443331187579289601> / Legion <:Green_Blade:467122927230386207><:Icon_Move_Infantry:443331187579289601>']
  ghb=ghb.rotate(date%7)
  msg2='__**GHB Revival**__'
  msg3='__**GHB Revival 2**__'
  for i in 0...ghb.length
    if i==0
      msg2="#{msg2}\n#{ghb[i].split(' / ')[0]} - Today"
      msg3="#{msg3}\n#{ghb[i].split(' / ')[1]} - Today"
    else
      t2=t+24*60*60*i
      msg2="#{msg2}\n#{ghb[i].split(' / ')[0]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      msg3="#{msg3}\n#{ghb[i].split(' / ')[1]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    end
  end
  t2=t+24*60*60*7
  msg2="#{msg2}\n#{ghb[0].split(' / ')[0]} - 7 days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
  msg3="#{msg3}\n#{ghb[0].split(' / ')[1]} - 7 days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
  msg=extend_message(msg,msg2,event,2) if [-1,4].include?(idx)
  msg=extend_message(msg,msg3,event,2) if [-1,5].include?(idx)
  msg=extend_message(msg,"Try the command again with \"GHB2\" if you're looking for the second set of Grand Hero Battles.\nYou may also want to try \"Events\" if you're looking for non-cyclical GHBs.",event,2) if [4].include?(idx)
  if [-1,6].include?(idx)
    rd=['Flying <:Icon_Move_Flier:443331186698354698>',
        'Infantry <:Icon_Move_Infantry:443331187579289601>',
        'Armored <:Icon_Move_Armor:443331186316673025>',
        'Cavalry <:Icon_Move_Cavalry:443331186530451466>']
    rd=rd.rotate(week_from(date,2)%4)
    rd=rd.rotate(-1) if t.wday==6
    msg2='__**Rival Domains Prefered Movement Type**__'
    for i in 0...rd.length
      if i==0
        t2=t-24*60*60*t.wday+6*24*60*60
        t2+=7*24*60*60 if t.wday==6
        msg2="#{msg2}\n#{rd[i]} - This week until #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (Saturday)"
      else
        t2=t-24*60*60*t.wday+7*24*60*60*i-24*60*60
        t2+=7*24*60*60 if t.wday==6
        msg2="#{msg2}\n#{rd[i]} - #{"#{i} weeks from now" if i>1}#{"Next week" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}"
      end
    end
    t2=t-24*60*60*t.wday+7*24*60*60*4-24*60*60
    t2+=7*24*60*60 if t.wday==6
    msg2="#{msg2}\n#{rd[0]} - 4 weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}"
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,7].include?(idx)
    garden=['Earth <:Legendary_Effect_Earth:443331186392170508>',
            'Fire <:Legendary_Effect_Fire:443331186480119808>',
            'Water <:Legendary_Effect_Water:443331186534776832>',
            'Wind <:Legendary_Effect_Wind:443331186467536896>']
    garden=garden.rotate(week_from(date,3)%4)
    garden=garden.rotate(-1) if t.wday==0
    msg2='__**Next Blessed Gardens**__'
    for i in 0...garden.length
      if i==0
        t2=t-24*60*60*t.wday+7*24*60*60
        t2+=7*24*60*60 if t.wday==0
        msg2="#{msg2}\n#{garden[i]} - This week until #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (Sunday)"
      else
        t2=t-24*60*60*t.wday+7*24*60*60*i
        t2+=7*24*60*60 if t.wday==0
        msg2="#{msg2}\n#{garden[i]} - #{"#{i} weeks from now" if i>1}#{"Next week" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}"
      end
    end
    t2=t-24*60*60*t.wday+7*24*60*60*4
    t2+=7*24*60*60 if t.wday==0
    msg2="#{msg2}\n#{garden[0]} - 4 weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}"
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,11].include?(idx)
    drill=['Skill Studies','Grandmaster']
    drill=drill.rotate(week_from(date,0)%2)
    drill=drill.rotate(-1) if t.wday==4
    msg2='__**Next Tactics Drills**__'
    for i in 0...drill.length
      if i==0
        t2=t-24*60*60*t.wday+4*24*60*60
        t2+=7*24*60*60 if t.wday==4
        msg2="#{msg2}\n#{drill[i]} - This week until #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (Thursday)"
      else
        t2=t-24*60*60*t.wday+7*24*60*60*i-72*60*60
        t2+=7*24*60*60 if t.wday==4
        msg2="#{msg2}\n#{drill[i]} - #{"#{i} weeks from now" if i>1}#{"Next week" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}"
      end
    end
    t2=t-24*60*60*t.wday+7*24*60*60*2-72*60*60
    t2+=7*24*60*60 if t.wday==4
    msg2="#{msg2}\n#{'__' if idx==-1}#{drill[0]} - 2 weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}#{'__' if idx==-1}#{"\n" if idx==11}"
    drill=['300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','1<:Orb_Rainbow:471001777622351872>','1<:Orb_Rainbow:471001777622351872>']
    drill=drill.rotate(week_from(date,0)%12)
    drill=drill.rotate(-1) if t.wday==4
    msg2="#{msg2}\nThis week's reward: #{drill[0]}"
    drill[0]=''
    if drill[1]=='1<:Orb_Rainbow:471001777622351872>'
      t2=t-24*60*60*t.wday+4*24*60*60
      t2+=7*24*60*60 if t.wday==4
      msg2="#{msg2}\nNext #{'<:Orb_Rainbow:471001777622351872>' if idx==-1}orb reward: Next week - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (Thursday)"
    else
      m=drill.find_index{|q| q=='1<:Orb_Rainbow:471001777622351872>'}
      t2=t-24*60*60*t.wday+4*24*60*60+7*24*60*60*m
      t2+=7*24*60*60 if t.wday==4
      msg2="#{msg2}\nNext #{'<:Orb_Rainbow:471001777622351872>' if idx==-1}orb reward: #{m} weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (Thursday)"
    end
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,8].include?(idx)
    str2=disp_current_events(1)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_events(-1)
    msg=extend_message(msg,str2,event,2)
  end
  if [-1,9].include?(idx)
    str2=disp_current_events(2)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_events(-2)
    msg=extend_message(msg,str2,event,2)
  end
  if [-1].include?(idx)
    msg=extend_message(msg,"__**Legendary Heroes' Appearances**__\n#{sort_legendaries(event,bot,1)}",event,2)
  elsif [10].include?(idx)
    sort_legendaries(event,bot)
  end
  event.respond msg unless [10].include?(idx)
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
    create_embed(event,'',"Unit in avatar: #{@avvie_info[0]}\n\nCurrent status:\n[Playing] #{@avvie_info[1]}#{"\n\nReason: #{@avvie_info[2]}" unless @avvie_info[2].length.zero?}",(t.day*7+t.month*21*256+(t.year-2000)*10*256*256),"Dev's timezone: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]}) | #{'0' if t.hour<10}#{t.hour}:#{'0' if t.min<10}#{t.min}",bot.user(312451658908958721).avatar_url)
  end
  return nil
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
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  f=event.message.text.split(' ')
  f="#{f[0]} #{f[1]} "
  bot.user(user_id.to_i).pm(first_sub(event.message.text,f,'',1))
  event.respond 'Message sent.'
end

bot.command(:ignoreuser, from: 167657750971547648) do |event, user_id| # causes Elise to ignore the specified user
  return nil if overlap_prevent(event)
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  metadata_load()
  bot.ignore_user(user_id.to_i)
  event.respond "#{bot.user(user_id.to_i).distinct} is now being ignored."
  @ignored.push(bot.user(user_id.to_i).id)
  bot.user(user_id.to_i).pm('You have been added to my ignore list.')
  metadata_save()
  return nil
end

bot.command(:sendmessage, from: 167657750971547648) do |event, channel_id, *args| # sends a message to a specific channel
  return nil if overlap_prevent(event)
  return nil unless event.server.nil? || [443172595580534784,443181099494146068,443704357335203840,449988713330769920].include?(event.server.id)
  if event.user.id==167657750971547648
  else
    event.respond 'Are you trying to use the `bugreport`, `suggestion`, or `feedback` command?'
    bot.user(167657750971547648).pm("#{event.user.distinct} (#{event.user.id}) tried to use the `sendmessage` command.")
    return nil
  end
  f=event.message.text.split(' ')
  f="#{f[0]} #{f[1]} "
  bot.channel(channel_id).send_message(first_sub(event.message.text,f,'',1))
  event.respond 'Message sent.'
  return nil
end

bot.command(:leaveserver, from: 167657750971547648) do |event, server_id| # forces Elise to leave a server
  return nil if overlap_prevent(event)
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  chn=bot.server(server_id.to_i).general_channel
  if chn.nil?
    chnn=[]
    for i in 0...bot.server(server_id.to_i).channels.length
      chnn.push(bot.server(server_id.to_i).channels[i]) if bot.user(bot.profile.id).on(event.server.id).permission?(:send_messages,bot.server(server_id.to_i).channels[i]) && bot.server(server_id.to_i).channels[i].type.zero?
    end
    chn=chnn[0] if chnn.length>0
  end
  if server_id.to_i==271642342153388034
    chn.send_message("It is the end of a major era.  I'm sorry.  The cord has been completely severed.  If you would like me back, please take it up with Roman.") rescue nil
  else
    chn.send_message("My coder would rather that I not associate with you guys.  I'm sorry.  If you would like me back, please take it up with him.") rescue nil
  end
  bot.server(server_id.to_i).leave
  return nil
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
    unless nmz[i][2].nil?
      for i2 in 0...nmz[i][2].length
        unless nmz[i][2][i2]==285663217261477889
          srv=(bot.server(nmz[i][2][i2]) rescue nil)
          if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
            k+=1
            nmz[i][2][i2]=nil
          end
        end
      end
      nmz[i][2].compact!
      nmz[i]=nil if nmz[i][2].length<=0
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
    @aliases.sort! {|a,b| (a[1].downcase <=> b[1].downcase) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].downcase <=> b[1].downcase)}
    if @aliases[@aliases.length-1].length<=1 || @aliases[@aliases.length-1][1]<'Zephiel'
      event.respond 'Alias list has __***NOT***__ been backed up, as alias list has been corrupted.'
      bot.gateway.check_heartbeat_acks = true
      event.respond 'FEH!restorealiases'
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

bot.command(:restore, from: 167657750971547648) do |event, trigger|
  return nil if overlap_prevent(event)
  return nil unless [167657750971547648,bot.profile.id].include?(event.user.id) || event.channel.id==386658080257212417
  bot.gateway.check_heartbeat_acks = false
  if trigger.nil?
    event.respond 'Restore what?'
  elsif ['aliases','alias'].include?(trigger.downcase)
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt')
      b=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt').each_line do |line|
        b.push(eval line)
      end
    else
      b=[]
    end
    nzzzzz=b.uniq
    if nzzzzz[nzzzzz.length-1][1]<'Zephiel'
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
      event << 'Last backup of the alias list being used.'
    end
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event << 'Alias list has been restored from backup.'
  elsif ['groupes','group'].include?(trigger.downcase)
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
      event << 'Last backup of the group list has been corrupted.  Restoring from manually-created backup.'
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
      event << 'Last backup of the group list being used.'
    end
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event << 'Group list has been restored from backup.'
  else
    event.respond 'Restore what?'
  end
end

bot.command([:devedit, :dev_edit], from: 167657750971547648) do |event, cmd, *args|
  return nil if overlap_prevent(event)
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

bot.command(:snagchannels, from: 167657750971547648) do |event, server_id|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648
  if server_id.to_i==285663217261477889 && @shardizard != 4
    event.respond 'That is the testing server.  Please run this command in the testing server for this information.'
    return nil
  elsif server_id.to_i != 285663217261477889 && @shardizard == 4
    event.respond "The debug version of the bot can only see the debug server.  Please run this command in another server for the desired information.\nThat server ID (#{server_id}) is in the #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(server_id.to_i >> 22) % 4]} Shard, that is likely your best bet."
    return nil
  elsif @shardizard == 4
  elsif (bot.server(server_id.to_i) rescue nil).nil? || bot.user(bot.profile.id).on(server_id.to_i).nil?
    event.respond 'I am not in that server.'
    return nil
  elsif @shardizard != (server_id.to_i >> 22) % 4
    event.respond "This shard is unable to read the channel set of that server.  Perhaps it would be best to use the #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(server_id.to_i >> 22) % 4]} Shard."
    return nil
  end
  msg="__**#{bot.server(server_id.to_i).name}**__\n\n__*Text Channels*__"
  srv=bot.server(server_id.to_i)
  for i in 0...srv.channels.length
    chn=srv.channels[i]
    msg=extend_message(msg,"*#{chn.name}* (#{chn.id})#{' - can post' if bot.user(bot.profile.id).on(srv.id).permission?(:send_messages,chn)}",event) if chn.type.zero?
  end
  event.respond msg
end

bot.command(:snagstats) do |event, f, f2|
  return nil if overlap_prevent(event)
  nicknames_load()
  groups_load()
  g=get_markers(event)
  data_load()
  metadata_load()
  f='' if f.nil?
  f2='' if f2.nil?
  bot.servers.values(&:members)
  k=bot.servers.length
  k=1 if @shardizard==4 # Debug shard shares the three emote servers with the main account
  @server_data[0][@shardizard]=k
  @server_data[1][@shardizard]=bot.users.size
  metadata_save()
  all_units=@units.reject{|q| !has_any?(g, q[13][0])}
  all_units=@units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
  legal_units=@units.reject{|q| !q[13][0].nil?}
  all_skills=@skills.reject{|q| !has_any?(g, q[13])}
  all_skills=@skills.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
  legal_skills=@skills.reject{|q| !q[13].nil?}
  b=[]
  File.open('C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb').each_line do |line|
    l=line.gsub(' ','').gsub("\n",'')
    b.push(l) unless l.length<=0
  end
  if ['servers','server','members','member','shard','shards','user','users'].include?(f.downcase)
    event << "**I am in #{longFormattedNumber(@server_data[0].inject(0){|sum,x| sum + x })} servers, reaching #{longFormattedNumber(@server_data[1].inject(0){|sum,x| sum + x })} unique members.**"
    event << "The <:Shard_Colorless:443733396921909248> Transparent Shard is in #{longFormattedNumber(@server_data[0][0])} server#{"s" if @server_data[0][0]!=1}, reaching #{longFormattedNumber(@server_data[1][0])} unique members."
    event << "The <:Shard_Red:443733396842348545> Scarlet Shard is in #{longFormattedNumber(@server_data[0][1])} server#{"s" if @server_data[0][1]!=1}, reaching #{longFormattedNumber(@server_data[1][1])} unique members."
    event << "The <:Shard_Blue:443733396741554181> Azure Shard is in #{longFormattedNumber(@server_data[0][2])} server#{"s" if @server_data[0][2]!=1}, reaching #{longFormattedNumber(@server_data[1][2])} unique members."
    event << "The <:Shard_Green:443733397190344714> Verdant Shard is in #{longFormattedNumber(@server_data[0][3])} server#{"s" if @server_data[0][3]!=1}, reaching #{longFormattedNumber(@server_data[1][3])} unique members."
    event << "The <:Shard_Gold:443733396913520640> Golden Shard is in #{longFormattedNumber(@server_data[0][4])} server#{"s" if @server_data[0][4]!=1}, reaching #{longFormattedNumber(@server_data[1][4])} unique members." if event.user.id==167657750971547648
    return nil
  elsif ['alts','alt','alternate','alternates','alternative','alternatives'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3)
    g=get_markers(event)
    data_load()
    nicknames_load()
    untz=@units.map{|q| q}
    untz2=[]
    for i in 0...untz.length
      m=[]
      m.push('default') if untz[i][0]==untz[i][12].split(', ')[0] || untz[i][12].split(', ')[0][untz[i][12].split(', ')[0].length-1,1]=='*'
      m.push('faceted') if untz[i][12].split(', ')[0][0,1]=='*' && untz[i][12].split(', ').length>1
      m.push('sensible') if untz[i][12].split(', ')[0][0,1]=='*' && untz[i][12].split(', ').length<2
      m.push('seasonal') if untz[i][9][0].include?('s') && !(!untz[i][2].nil? && !untz[i][2][0].nil? && untz[i][2][0].length>1)
      m.push('community-voted') if @aliases.reject{|q| q[1]!=untz[i][0] || !q[2].nil?}.map{|q| q[0]}.include?("#{untz[i][0].split('(')[0]}CYL")
      m.push('Legendary') if !untz[i][2].nil? && !untz[i][2][0].nil? && untz[i][2][0].length>1 && !m.include?('default')
      m.push('Fallen') if untz[i][0].include?('(Fallen)')
      m.push('out-of-left-field') if m.length<=0
      n=''
      unless untz[i][0]==untz[i][12] || untz[i][12][untz[i][12].length-1,1]=='*'
        k=untz.reject{|q| q[12].gsub('*','').split(', ')[0]!=untz[i][12].gsub('*','').split(', ')[0] || q[0]==untz[i][0] || !(q[0]==q[12].split(', ')[0] || q[12].split(', ')[0].include?('*'))}
        n="x" if k.length<=0
      end
      untz2.push([untz[i][0],untz[i][12].gsub('*','').split(', '),m,n,untz[i][13]])
    end
    untz2.uniq!
    all_units=untz2.reject{|q| !has_any?(g, q[4][0])}
    all_units=untz2.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    legal_units=untz2.reject{|q| !q[4][0].nil?}
    a2=all_units.reject{|q| q[1][1].nil?}.map{|q| q[1][0]}.uniq
    l2=legal_units.reject{|q| q[1][1].nil?}.map{|q| q[1][0]}.uniq
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'default',1)} characters in their default form, alongside #{l2.length}#{" (#{a2.length})" unless l2.length==a2.length} sets of character facets *(Tiki, dual-gendered characters, etc.)*"
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'sensible',1)} sensible alts *(Masked Marth, Dark Azura, etc.)*"
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'seasonal',1)} seasonal alts"
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'community-voted',1)} community-voted alts *(CYL winners)*"
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'Legendary',1)} Legendary alts"
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'Fallen',1)} Fallen alts"
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'out-of-left-field',1)} out-of-left-field alts *(Eirika, Reinhardt, Hinoka, etc.)*"
    k=[]
    for i in 0...all_units.length
      x="#{'~~' unless all_units[i][4][0].nil? || all_units[i][4][0].length.zero?}"
      k.push("#{x}#{all_units[i][1][0]}#{x}") if all_units[i][3].length>0
    end
    k.uniq!
    if k.length>0
      event << ''
      event << "The following characters have alts but not default units in FEH: #{list_lift(k.map{|q| "*#{q}*"},"and")}."
    end
    k=legal_units.map{|q| [q[1][0],0]}.uniq
    for i in 0...k.length
      k[i][1]=legal_units.reject{|q| q[1][0]!=k[i][0]}.uniq.length
    end
    k=k.sort{|b,a| supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)}
    k=k.reject{|q| q[1]!=k[0][1]}
    event << "#{list_lift(k.map{|q| "*#{q[0]}*"},'and')} #{"is" if k.length==1}#{"are" unless k.length==1} the character#{"s" unless k.length==1} with the most alts, with #{k[0][1]} alts (including the default)#{" each" unless k.length==1}."
    k=legal_units.map{|q| [q[1],0]}.uniq
    for i in 0...k.length
      k[i][1]=legal_units.reject{|q| q[1]!=k[i][0]}.uniq.length
      if k[i][0].length>1
        k[i][0]="#{k[i][0][0]}(#{k[i][0][1]})"
      else
        k[i][0]=k[i][0][0]
      end
    end
    k=k.sort{|b,a| supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)}
    k=k.reject{|q| q[1]!=k[0][1]}
    event << "#{list_lift(k.map{|q| "*#{q[0]}*"},'and')} #{"is" if k.length==1}#{"are" unless k.length==1} the character facet#{"s" unless k.length==1} with the most alts, with #{k[0][1]} alts (including the default)#{" each" unless k.length==1}."
    return nil
  elsif ['units','characters','unit','character','charas','chara','chars','char'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',1)
    event << "**There are #{filler(legal_units,all_units,-1)} units, including:**"
    event << ''
    event << "#{filler(legal_units,all_units,9,0,'p',1)} summonable units"
    event << "#{filler(legal_units,all_units,9,0,'g',1)} Grand Hero Battle reward units"
    event << "#{filler(legal_units,all_units,9,0,'t',1)} Tempest Trials reward units"
    event << "#{filler(legal_units,all_units,[9,2],[0,0],['s',2],[1,-2])} seasonal units"
    event << "#{filler(legal_units,all_units,2,0,2,2)} legendary units"
    event << "#{filler(legal_units,all_units,9,0,'-',1)} unobtainable units"
    event << ''
    event << "#{filler(legal_units,all_units,1,0,'Red')} red units,   with #{filler(legal_units,all_units,[1,9],[0,0],['Red','p'],[0,1])} in the main summon pool"
    event << "#{filler(legal_units,all_units,1,0,'Blue')} blue units,   with #{filler(legal_units,all_units,[1,9],[0,0],['Blue','p'],[0,1])} in the main summon pool"
    event << "#{filler(legal_units,all_units,1,0,'Green')} green units,   with #{filler(legal_units,all_units,[1,9],[0,0],['Green','p'],[0,1])} in the main summon pool"
    event << "#{filler(legal_units,all_units,1,0,'Colorless')} colorless units,   with #{filler(legal_units,all_units,[1,9],[0,0],['Colorless','p'],[0,1])} in the main summon pool"
    event << ''
    event << "#{filler(legal_units,all_units,1,1,'Blade')} blade users:   #{filler(legal_units,all_units,1,-1,['Red','Blade'])} swords, #{filler(legal_units,all_units,1,-1,['Blue','Blade'])} lances, and #{filler(legal_units,all_units,1,-1,['Green','Blade'])} axes"
    event << "#{filler(legal_units,all_units,1,1,'Tome')} tome users:   #{filler(legal_units,all_units,1,-1,[['Red','Tome','Fire'],['Red','Tome','Dark']],-3)} red, #{filler(legal_units,all_units,1,-1,[['Blue','Tome','Thunder'],['Blue','Tome','Light']],-3)} blue, and #{filler(legal_units,all_units,1,-1,[['Green','Tome','Wind'],['Green','Tome','Wind']],-3)} green"
    event << "#{filler(legal_units,all_units,1,1,'Dragon')} dragon units"
    event << "#{filler(legal_units,all_units,1,1,'Bow')} bow users"
    event << "#{filler(legal_units,all_units,1,1,'Dagger')} dagger users"
    event << "#{filler(legal_units,all_units,1,1,'Healer')} staff users"
    event << "#{filler(legal_units,all_units,1,1,'Beast')} beast units"
    event << ''
    event << "#{filler(legal_units,all_units,3,-1,'Infantry')} infantry units"
    event << "#{filler(legal_units,all_units,3,-1,'Cavalry')} cavalry units"
    event << "#{filler(legal_units,all_units,3,-1,'Flier')} flying units"
    event << "#{filler(legal_units,all_units,3,-1,'Armor')} armored units"
    if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
      event << ''
      event << "#{filler(legal_units,all_units,11,-1,'FE1',1)} units from *FE1*,    #{filler(legal_units,all_units,11,0,'FE1')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE2',1)} units from *FE2*,    #{filler(legal_units,all_units,11,0,'FE2')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE3',1)} units from *FE3*,    #{filler(legal_units,all_units,11,0,'FE3')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE4',1)} units from *FE4*,    #{filler(legal_units,all_units,11,0,'FE4')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE5',1)} units from *FE5*,    #{filler(legal_units,all_units,11,0,'FE5')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE6',1)} units from *FE6*,    #{filler(legal_units,all_units,11,0,'FE6')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE7',1)} units from *FE7*,    #{filler(legal_units,all_units,11,0,'FE7')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE8',1)} units from *FE8*,    #{filler(legal_units,all_units,11,0,'FE8')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE9',1)} units from *FE9*,    #{filler(legal_units,all_units,11,0,'FE9')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE10',1)} units from *FE10*,    #{filler(legal_units,all_units,11,0,'FE10')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE11',1)} units from *FE11*,    #{filler(legal_units,all_units,11,0,'FE11')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE12',1)} units from *FE12*,    #{filler(legal_units,all_units,11,0,'FE12')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE13',1)} units from *FE13*,    #{filler(legal_units,all_units,11,0,'FE13')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,['FE14','FE14B','FE14C','FE14R','FE14g'],4)} units from *FE14*,  #{filler(legal_units,all_units,11,0,['FE14','FE14B','FE14C','FE14R','FE14g'],-3)} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE15',1)} units from *FE15*,    #{filler(legal_units,all_units,11,0,'FE15')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FE16',1)} units from *FE16*,    #{filler(legal_units,all_units,11,0,'FE16')} of which are credited"
      event << "#{filler(legal_units,all_units,11,-1,'FEH',1)} units from *FEH* itself,    #{filler(legal_units,all_units,11,0,'FEH')} of which are credited"
    end
    return nil
  elsif ['skill','skills','weapon','weapons','assist','assists','special','specials','passive','passives'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3)
    msg=skill_data(legal_skills,all_skills,event,0)
    data_load()
    legal_skills=@skills.reject{|q| !q[13].nil? || q[0].include?('Initiate Seal ') || q[0].include?('Squad Ace ')}
    legal_skills=collapse_skill_list(legal_skills,6)
    data_load()
    all_skills=@skills.reject{|q| !has_any?(g, q[13]) || q[0].include?('Initiate Seal ') || q[0].include?('Squad Ace ')}
    all_skills=@skills.reject{|q| q[0].include?('Initiate Seal ') || q[0].include?('Squad Ace ')} if event.server.nil? && event.user.id==167657750971547648
    all_skills=collapse_skill_list(all_skills,6)
    msg=extend_message(msg,skill_data(legal_skills,all_skills,event,1),event,2)
    data_load()
    legal_skills=@skills.reject{|q| !q[13].nil? || q[0].include?('Initiate Seal ') || q[0].include?('Squad Ace ')}
    legal_skills=collapse_skill_list(legal_skills,14)
    data_load()
    all_skills=@skills.reject{|q| !has_any?(g, q[13]) || q[0].include?('Initiate Seal ') || q[0].include?('Squad Ace ')}
    all_skills=@skills.reject{|q| q[0].include?('Initiate Seal ') || q[0].include?('Squad Ace ')} if event.server.nil? && event.user.id==167657750971547648
    all_skills=collapse_skill_list(all_skills,14)
    msg=extend_message(msg,skill_data(legal_skills,all_skills,event,2),event,2)
    event.respond msg
    return nil
  elsif ['alias','aliases','name','names','nickname','nicknames'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',1)
    glbl=@aliases.reject{|q| !q[2].nil?}
    srv_spec=@aliases.reject{|q| q[2].nil?}
    all_units=@units.reject{|q| !has_any?(g, q[13][0])}
    all_units=@units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    all_units=all_units.map{|q| [q[0],0,0]}
    srv_spec=srv_spec.reject{|q| !all_units.map{|q| q[0]}.include?(q[1])}
    for j in 0...all_units.length
      all_units[j][1]+=glbl.reject{|q| q[1]!=all_units[j][0]}.length
      all_units[j][2]+=srv_spec.reject{|q| q[1]!=all_units[j][0]}.length
    end
    event << "**There are #{longFormattedNumber(glbl.length)} global single-unit aliases.**"
    all_units=all_units.sort{|b,a| supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)}
    k=all_units.reject{|q| q[1]!=all_units[0][1]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}*"}
    event << "The unit#{"s" unless k.length==1} with the most global aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][1]} global aliases#{" each" unless k.length==1}."
    k=all_units.reject{|q| q[1]!=0}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}*"}
    if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
      if k.length.zero?
        all_units=all_units.sort{|a,b| supersort(a,b,1).zero? ? supersort(b,a,0) : supersort(a,b,1)}
        k=all_units.reject{|q| q[1]!=all_units[0][1]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}*"}
        event << "The unit#{"s" unless k.length==1} with the fewest global aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][1]} global alias#{"es" unless all_units[0][1]==1}#{" each" unless k.length==1}."
      else
        event << "The following unit#{"s" unless k.length==1} have no global aliases: #{list_lift(k,"and")}"
      end
    end
    event << ''
    event << "**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-unit] aliases.**"
    if event.server.nil? && @shardizard==4
      event << "Due to being the debug version, I cannot show more information."
    elsif event.server.nil?
      event << "Servers you and I share account for #{@aliases.reject{|q| q[2].nil? || q[2].reject{|q2| bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      event << "This server accounts for #{@aliases.reject{|q| q[2].nil? || !q[2].include?(event.server.id)}.length} of those."
    end
    all_units=all_units.sort{|b,a| supersort(a,b,2).zero? ? supersort(a,b,0) : supersort(a,b,2)}
    k=all_units.reject{|q| q[2]!=all_units[0][2]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}*"}
    event << "The unit#{"s" unless k.length==1} with the most server-specific aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][2]} server-specific aliases#{" each" unless k.length==1}."
    for i in 0...srv_spec.length
      srv_spec[i][2]=srv_spec[i][2].length
    end
    srv_spec=srv_spec.sort{|b,a| supersort(a,b,2).zero? ? (supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)) : supersort(a,b,2)}
    k=srv_spec.reject{|q| q[2]!=srv_spec[0][2]}.map{|q| "*#{q[0]} = #{q[1]}*"}
    event << "The most agreed-upon server-specific alias#{"es are" unless k.length==1}#{" is" if k.length==1} #{list_lift(k,"and")}.  #{srv_spec[0][2]} servers agree on #{"them" unless k.length==1}#{"it" if k.length==1}." if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
    k=srv_spec.map{|q| q[2]}.inject(0){|sum,x| sum + x }
    event << "Counting each alias/server combo as a unique alias, there are #{longFormattedNumber(k)} server-specific aliases"
    event << ''
    event << "**There are #{longFormattedNumber(@multi_aliases.length)} [global] multi-unit aliases, covering #{@multi_aliases.map{|q| q[1]}.uniq.length} groups of units.**"
    m=@multi_aliases.map{|q| [q[1],0]}.uniq
    for i in 0...m.length
      m[i][1]+=@multi_aliases.reject{|q| q[1]!=m[i][0]}.length
      m[i][0]=m[i][0].join('/')
    end
    m=m.sort{|b,a| supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)}
    k=m.reject{|q| q[1]!=m[0][1]}.map{|q| "*#{q[0]}*"}
    event << "#{list_lift(k,"and")} #{"is" if k.length==1}#{"are" unless k.length==1} the group#{"s" unless k.length==1} of units with the most multi-unit aliases, with #{m[0][1]} multi-unit aliases#{" each" unless k.length==1}."
    m=m.sort{|a,b| supersort(a,b,1).zero? ? supersort(b,a,0) : supersort(a,b,1)}
    k=m.reject{|q| q[1]!=m[0][1]}.map{|q| "*#{q[0]}*"}
    event << "#{list_lift(k,"and")} #{"is" if k.length==1}#{"are" unless k.length==1} the group#{"s" unless k.length==1} of units with the fewest multi-unit aliases (among those that have them), with #{m[0][1]} multi-unit alias#{"es" unless m[0][1]==1}#{" each" unless k.length==1}." if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
    return nil
  elsif ['groups','group','groupings','grouping'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3)
    event << "**There are #{longFormattedNumber(@groups.reject{|q| !q[2].nil?}.length-1)} global groups**, including the following dynamic ones:"
    gg=@groups.reject{|q| !q[2].nil? || q[1].length>0}.map{|q| [q[0],get_group(q[0],event)[1].reject{|q2| all_units.find_index{|q3| q3[0]==q2}.nil?}]}
    event << "*Brave Heroes* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='BraveHeroes'}][1].length)} current members) - Any unit with the phrase *(Brave)* in their internal name."
    event << "*Daily Rotation* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Daily_Rotation'}][1].length)} current members) - Any unit that can be obtained via the twelve rotating Daily Hero Battle maps."
    event << "*Dancers/Singers* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Dancers&Singers'}][1].length)} current members) - Any unit that can learn the skill Dance or the skill Sing."
    event << "*Falchion Users* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Falchion_Users'}][1].length)} current members) - Any unit that can use one of the three Falchions, or any of their evolutions."
    event << "*Fallen Heroes* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='FallenHeroes'}][1].length)} current members) - Any unit with the phrase *(Fallen)* in their internal name."
    event << "*GHB* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='GHB'}][1].length)} current members) - Any unit that can obtained via a Grand Hero Battle map."
    event << "*Legendaries* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Legendaries'}][1].length)} current members) - Any unit that gives a Legendary Hero Boost to blessed allies during specific seasons."
    event << "*Retro-Prfs* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Retro-Prfs'}][1].length)} current members) - Any unit that has access to a Prf weapon that does not promote from anything."
    event << "*Seasonals* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Seasonals'}][1].length)} current members) - Any unit that is limited summonable (or related to such an event), but does not give a Legendary Hero boost."
    event << "    The following subsets of the Seasonals group are also dynamic: *Valentine's* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=="Valentine's"}][1].length)}), *Spring* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Bunnies'}][1].length)}), *Wedding* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Wedding'}][1].length)}), *Summer* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Summer'}][1].length)}), *Halloween* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Halloween'}][1].length)}), *Winter* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Winter'}][1].length)})"
    event << "*Tempest* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Tempest'}][1].length)} current members) - Any unit that can be obtained via a Tempest Trials event."
    display=false
    display=true if event.user.id==167657750971547648
    display=true if !event.server.nil? && !bot.user(167657750971547648).on(event.server.id).nil? && rand(100).zero?
    display=true if !event.server.nil? && bot.user(167657750971547648).on(event.server.id).nil? && rand(10000).zero?
    event << "*Mathoo's Waifus* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=="Mathoo'sWaifus"}][1].length)} current members) - Any unit that my developer would enjoy cuddling." if display
    event << ''
    event << "**There are #{longFormattedNumber(@groups.reject{|q| q[2].nil?}.length)} server-specific groups.**"
    if event.server.nil? && @shardizard==4
      event << "Due to being the debug version, I cannot show more information."
    elsif event.server.nil?
      event << "Servers you and I share account for #{@groups.reject{|q| q[2].nil? || q[2].reject{|q2| bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      event << "This server accounts for #{@groups.reject{|q| q[2].nil? || !q[2].include?(event.server.id)}.length} of those."
    end
    return nil
  elsif ['code','lines','line','sloc'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3)
    b=[[],[]]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb').each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[1].push(l) unless l.length<=0
    end
    event << "**I am #{longFormattedNumber(File.foreach("C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} lines of code long.**"
    event << "Of those, #{longFormattedNumber(b[1].length)} are SLOC (non-empty)."
    event << "~~When fully collapsed, I appear to be #{longFormattedNumber(b[0].reject{|q| q.length>0 && (q[0,2]=='  ' || q[0,3]=='end' || q[0,4]=='else')}.length)} lines of code long.~~"
    event << ''
    event << "**There are #{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command('}.length)} commands, invoked with #{longFormattedNumber(all_commands().length)} different phrases.**"
    event << 'This includes:'
    event << "#{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command(' || q.include?('from: 167657750971547648')}.length-b[0].reject{|q| q.gsub('  ','')!="event.respond 'You are not a mod.'"}.length)} global commands, invoked with #{longFormattedNumber(all_commands(false,0).length)} different phrases."
    event << "#{longFormattedNumber(b[0].reject{|q| q.gsub('  ','')!="event.respond 'You are not a mod.'"}.length)} mod-only commands, invoked with #{longFormattedNumber(all_commands(false,1).length)} different phrases."
    event << "#{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command(' || !q.include?('from: 167657750971547648')}.length)} dev-only commands, invoked with #{longFormattedNumber(all_commands(false,2).length)} different phrases."
    event << ''
    event << "**There are #{longFormattedNumber(@prefix.map{|q| q.downcase}.uniq.length)} command prefixes**, but because I am faking case-insensitivity it's actually #{longFormattedNumber(@prefix.length)} prefixes."
    event << ''
    event << "**There are #{longFormattedNumber(b[0].reject{|q| q[0,4]!='def '}.length)} functions the commands use.**"
    if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
      b=b[0].map{|q| q.gsub('  ','')}.reject{|q| q.length<=0}
      for i in 0...b.length
        b[i]=b[i][1,b[i].length-1] if b[i][0,1]==' '
      end
      event << ''
      event << 'There are:'
      event << "#{longFormattedNumber(b.reject{|q| q[0,4]!='for '}.length)} `for` loops."
      event << "#{longFormattedNumber(b.reject{|q| q[0,6]!='while '}.length)} `while` loops."
      event << "#{longFormattedNumber(b.reject{|q| q[0,3]!='if '}.length)} `if` trees, along with #{longFormattedNumber(b.reject{|q| q[0,6]!='elsif '}.length)} `elsif` branches and #{longFormattedNumber(b.reject{|q| q[0,4]!='else'}.length)} `else` branches."
      event << "#{longFormattedNumber(b.reject{|q| q[0,7]!='unless '}.length)} `unless` trees."
      event << "#{longFormattedNumber(b.reject{|q| count_in(q,'[')<=count_in(q,']')}.length)} multi-line arrays."
      event << "#{longFormattedNumber(b.reject{|q| count_in(q,'{')<=count_in(q,'}')}.length)} multi-line hashes."
      event << "#{longFormattedNumber(b.reject{|q| q[0,3]=='if ' || !remove_format(remove_format(q,"'"),'"').include?(' if ')}.length)} single-line `if` conditionals."
      event << "#{longFormattedNumber(b.reject{|q| q[0,7]=='unless ' || !remove_format(remove_format(q,"'"),'"').include?(' unless ')}.length)} single-line `unless` conditionals."
      event << "#{longFormattedNumber(b.reject{|q| q[0,7]!='return '}.length)} `return` lines."
    end
    return nil
  elsif event.user.id==167657750971547648 && !f.nil? && f.to_i.to_s==f
    if @shardizard==4
      s2="That server uses/would use #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(f.to_i >> 22) % 4]} Shards."
    else
      srv=(bot.server(f.to_i) rescue nil)
      if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
        s2="I am not in that server, but it would use #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(f.to_i >> 22) % 4]} Shards."
      else
        s2="__**#{srv.name}** (#{srv.id})__\n*Owner:* #{srv.owner.distinct} (#{srv.owner.id})\n*Shard:* #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(srv.id >> 22) % 4]}\n*My nickname:* #{bot.user(312451658908958721).on(srv.id).display_name}"
      end
    end
    event.respond s2
    return nil
  end
  bot.servers.values(&:members)
  event << "**I am in #{longFormattedNumber(@server_data[0].inject(0){|sum,x| sum + x })} *servers*, reaching #{longFormattedNumber(@server_data[1].inject(0){|sum,x| sum + x })} unique members.**"
  event << "This shard is in #{longFormattedNumber(@server_data[0][@shardizard])} server#{"s" unless @server_data[0][@shardizard]==1}, reaching #{longFormattedNumber(bot.users.size)} unique members."
  event << ''
  event << "#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{filler(legal_units,all_units,-1)} *units*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    event << "#{filler(legal_units,all_units,9,0,'p',1)} summonable units"
    event << "#{filler(legal_units,all_units,9,0,'g',1)} Grand Hero Battle reward units"
    event << "#{filler(legal_units,all_units,9,0,'t',1)} Tempest Trials reward units"
    event << "#{filler(legal_units,all_units,[9,2],[0,0],['s',2],[1,-2])} seasonal units"
    event << "#{filler(legal_units,all_units,2,0,2,2)} legendary units"
    event << "#{filler(legal_units,all_units,9,0,'-',1)} unobtainable units"
    event << ''
  end
  event << "#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{filler(legal_skills,all_skills,-1)} *skills*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    event << "#{filler(legal_skills,all_skills,4,-1,'Weapon')} Weapons"
    event << "#{filler(legal_skills,all_skills,4,-1,'Assist')} Assists"
    event << "#{filler(legal_skills,all_skills,4,-1,'Special')} Specials"
    event << "#{filler(legal_skills,all_skills,4,-1,['Weapon','Assist','Special'],3)} Passives"
  end
  glbl=@aliases.reject{|q| !q[2].nil?}
  srv_spec=@aliases.reject{|q| q[2].nil?}
  all_units=@units.reject{|q| !has_any?(g, q[13][0])}
  all_units=@units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
  all_units=all_units.map{|q| q[0]}
  srv_spec=srv_spec.reject{|q| !all_units.include?(q[1])}
  event << ''
  event << "There are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-unit] *aliases*."
  event << "There are #{longFormattedNumber(@multi_aliases.length)} [global] multi-unit aliases."
  event << ''
  event << "There are #{longFormattedNumber(@groups.reject{|q| !q[2].nil?}.length-1)} global and #{longFormattedNumber(@groups.reject{|q| q[2].nil?}.length)} server-specific *groups*."
  event << ''
  event << "I am #{longFormattedNumber(File.foreach("C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} lines of *code* long."
  event << "Of those, #{longFormattedNumber(b.length)} are SLOC (non-empty)."
  return nil
end

bot.command(:reload, from: 167657750971547648) do |event|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648
  event.channel.send_temporary_message('Loading.  Please wait 5 seconds...',3)
  to_reload=['Units','Skills','StatSkills','SkillSubsets','EmblemTeams','Banners','Events','Games']
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
  event.respond 'New data loaded.'
end

def skill_data(legal_skills,all_skills,event,mode=0)
  str="**There are #{filler(legal_skills,all_skills,-1)} #{['skills','skill branches','skill trees'][mode]}, including:**"
  if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
    ls2=legal_skills.reject{|q| q[4]!='Weapon'}
    as2=all_skills.reject{|q| q[4]!='Weapon'}
    str="#{str}\n#{filler(ls2,as2,5,-1,['Sword Users Only','Lance Users Only','Axe Users Only'],-3)} blades   #{filler(ls2,as2,5,-1,'Sword Users Only')} swords, #{filler(ls2,as2,5,-1,'Lance Users Only')} lances, #{filler(ls2,as2,5,-1,'Axe Users Only')} axes"
    str="#{str}\n#{filler(ls2,as2,5,-1,['Red Tome Users Only','Blue Tome Users Only','Green Tome Users Only'],-3)} tomes   #{filler(ls2,as2,5,-1,'Red Tome Users Only')} red, #{filler(ls2,as2,5,-1,'Blue Tome Users Only')} blue, #{filler(ls2,as2,5,-1,'Green Tome Users Only')} green"
    str="#{str}\n#{filler(ls2,as2,5,-1,'Dragons Only')} dragonstones"
    str="#{str}\n#{filler(ls2,as2,5,-1,'Bow Users Only')} bows"
    str="#{str}\n#{filler(ls2,as2,5,-1,'Dagger Users Only')} daggers"
    str="#{str}\n#{filler(ls2,as2,5,-1,'Staff Users Only')} damaging staves"
    str="#{str}\n__#{filler(ls2,as2,5,-1,'Beasts Only')} beaststones__"
    ls2=legal_skills.reject{|q| q[4]!='Assist'}
    as2=all_skills.reject{|q| q[4]!='Assist'}
    str="#{str}\n#{filler(ls2,as2,11,-1,'Rally',1)} rally assists"
    str="#{str}\n#{filler(ls2,as2,11,[-1,-1],['Move','Music'],[1,-1])} movement assists"
    str="#{str}\n#{filler(ls2,as2,11,-1,'Music',1)} musical assists"
    str="#{str}\n#{filler(ls2,as2,11,[-1,-1],['Health','Staff'],[1,-1])} health-based assists"
    str="#{str}\n#{filler(ls2,as2,11,-1,'Staff',1)} healing staves"
    str="#{str}\n__#{filler(ls2,as2,11,-3,['Rally','Move','Health','Music','Staff'],-4)} misc. assists__"
    ls2=legal_skills.reject{|q| q[4]!='Special'}
    as2=all_skills.reject{|q| q[4]!='Special'}
    str="#{str}\n#{filler(ls2,as2,11,[-1,-1],['Offensive','Defensive'],[1,-1])} offensive specials"
    str="#{str}\n#{filler(ls2,as2,11,-1,'Defensive',1)} defensive specials"
    str="#{str}\n#{filler(ls2,as2,11,-1,'AoE',1)} Area-of-Effect specials"
    str="#{str}\n#{filler(ls2,as2,11,-1,'Staff',1)} healer specials"
    str="#{str}\n__#{filler(ls2,as2,11,-3,['Damage','Defense','AoE','Staff'],-4)} misc. specials__"
  else
    str="#{str}\n#{filler(legal_skills,all_skills,4,-1,'Weapon')} Weapons"
    str="#{str}\n#{filler(legal_skills,all_skills,4,-1,'Assist')} Assists"
    str="#{str}\n#{filler(legal_skills,all_skills,4,-1,'Special')} Specials"
  end
  ls2=legal_skills.reject{|q| q[4]!='Seal' && !q[4].include?('Passive')}
  as2=all_skills.reject{|q| q[4]!='Seal' && !q[4].include?('Passive')}
  str="#{str}\n#{filler(ls2,as2,4,-1,'Passive(A)',1)} A Passives"
  str="#{str}\n#{filler(ls2,as2,4,-1,'Passive(B)',1)} B Passives"
  str="#{str}\n#{filler(ls2,as2,4,-1,'Passive(C)',1)} C Passives"
  if mode==2
    str="#{str}\n#{filler(ls2,as2,4,-1,'Seal')} Passive Seals"
  else
    str="#{str}\n#{filler(ls2,as2,4,-1,'Seal',1)} Passive Seals   #{filler(ls2,as2,4,-1,'Seal')} of which are exclusive to the Seal slot"
  end
  return str
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
  if ![285663217261477889,443172595580534784,443181099494146068,443704357335203840,449988713330769920].include?(event.server.id) && @shardizard==4
    (chn.send_message("I am Mathoo's personal debug bot.  As such, I do not belong here.  You may be looking for one of my two facets, so I'll drop both their invite links here.\n\n**EliseBot** allows you to look up stats and skill data for characters in *Fire Emblem: Heroes*\nHere's her invite link: <https://goo.gl/HEuQK2>\n\n**FEIndex**, also known as **RobinBot**, is for *Fire Emblem: Awakening* and *Fire Emblem Fates*.\nHere's her invite link: <https://goo.gl/v3ADBG>") rescue nil)
    event.server.leave
  else
    bot.user(167657750971547648).pm("Joined server **#{event.server.name}** (#{event.server.id})\nOwner: #{event.server.owner.distinct} (#{event.server.owner.id})\nAssigned to use #{['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant'][(event.server.id >> 22) % 4]} Shards")
    metadata_load()
    @server_data[0][((event.server.id >> 22) % 4)] += 1
    metadata_save()
    chn.send_message("<a:zeldawave:464974581434679296> I'm here to deliver the happiest of hellos - as well as data for heroes and skills in *Fire Emblem: Heroes*!  So, here I am!") rescue nil
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
    else
      event.respond 'I am not Robin right now.  Please use `FE!reboot` to turn me into Robin.'
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
    elsif !all_commands(true).include?(a[0])
      str=find_name_in_string(event,nil,1)
      data_load()
      if find_skill(s,event,false,true)>=0
        disp_skill(bot,s,event,true)
      elsif str.nil?
        if find_skill(s,event)>=0
          disp_skill(bot,s,event,true)
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
  if ['f?','e?','h?'].include?(event.message.text.downcase[0,2]) || ['feh!','feh?'].include?(event.message.text.downcase[0,4])
    k=3
  elsif s.gsub(' ','').downcase=='laevatein'
    disp_stats(bot,'Lavatain',nil,event,true,true)
    disp_skill(bot,'Bladeblade',event,true)
    k=3
  elsif ['random','rand'].include?(a[0].downcase)
    generate_random_unit(event,a,bot)
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
      timeshift=8
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
        if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
          event.respond "Steel's waifu is not in the game."
        elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
          event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
        elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
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
  elsif ['skills','fodder'].include?(a[0].downcase)
    a.shift
    if ['sort','list'].include?(a[0].downcase)
      a.shift
      sort_skills(bot,event,a)
    else
      k=find_name_in_string(event,nil,1)
      k2=0
      if k.nil?
        if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
          event.respond "Steel's waifu is not in the game."
        elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
          event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
        elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
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
      elsif event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
        event.respond "Steel's waifu is not in the game."
      elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
        event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
      else
        event.respond "No matches found.  If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s."
      end
    end
    k=1
  elsif ['skill'].include?(a[0].downcase)
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
    if ['skill','skills'].include?(a[0].downcase)
      a.shift
      sort_skills(bot,event,a)
    else
      sort_units(bot,event,a)
    end
    k=1
  elsif ['sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist'].include?(a[0].downcase)
    a.shift
    sort_skills(bot,event,a)
    k=1
  elsif ['smol','small','tiny','little','squashed'].include?(a[0].downcase)
    a.shift
    k=find_name_in_string(event,nil,1)
    if k.nil?
      w=nil
      if event.message.text.downcase.include?('flora') && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
        event.respond "Steel's waifu is not in the game."
      elsif event.message.text.downcase.include?('flora') && !event.server.nil? && event.server.id==332249772180111360
        event.respond 'If I may borrow from my summer self...**Oooh, hot!**  Too hot for me to see stats.'
      elsif !detect_multi_unit_alias(event,event.message.text.downcase,event.message.text.downcase).nil?
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
    elsif str.nil?
      if find_skill(s,event)>=0
        disp_skill(bot,s,event,true)
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
    end
  end
end

def disp_current_events(mode=0)
  t=Time.now
  timeshift=8
  t-=60*60*timeshift
  tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
  mdfr='left'
  mdfr='from now' if mode<0
  m=mode*1
  m=0-m if m<0
  str2="__**#{'Current' if mode>0}#{'Future' if mode<0} #{['','Banners','Events'][m]}**__"
  if [1,-1].include?(mode) # current/future banners
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
      b[i]=nil if b[i][2][0]=='-' && b[i][4].nil?
    end
    b.compact!
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i>tm || q[4].split(', ')[1].split('/').reverse.join('').to_i<tm}
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i<=tm}.reverse if mode<0
    for i in 0...b2.length
      t2=b2[i][4].split(', ')[[mode,0].max].split('/').map{|q| q.to_i}
      t2=Time.new(t2[2],t2[1],t2[0])+24*60*60*([0,mode].min+1)
      t2=t2-t
      if t2/(24*60*60)>1
        str2="#{str2}\n#{b2[i][0]} - #{(t2/(24*60*60)).floor} days #{mdfr}"
      elsif t2/(60*60)>1
        str2="#{str2}\n#{b2[i][0]} - #{(t2/(60*60)).floor} hours #{mdfr}"
      elsif t2/60>1
        str2="#{str2}\n#{b2[i][0]} - #{(t2/60).floor} minutes #{mdfr}"
      elsif t2>1
        str2="#{str2}\n#{b2[i][0]} - #{(t2).floor} seconds #{mdfr}"
      end
    end
  elsif [2,-2].include?(mode) # current/future events
    mode/=2
    c=[]
    if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHEvents.txt')
      c=[]
      File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHEvents.txt').each_line do |line|
        c.push(line.gsub("\n",''))
      end
    else
      c=[]
    end
    for i in 0...c.length
      c[i]=c[i].split('\\'[0])
      c[i][1]='Voting Gauntlet' if c[i][1]=='VG'
      c[i][1]='Bound Hero Battle' if c[i][1]=='BHB'
      c[i][1]='Grand Hero Battle' if c[i][1]=='GHB'
      c[i][1]='Legendary Hero Battle' if c[i][1]=='LHB'
      c[i][1]='Daily Reward Battle' if ['DRM','Daily Reward Maps','DRB'].include?(c[i][1])
      c[i][1]='Grand Conquests' if c[i][1]=='GC'
      c[i][1]='Tempest Trials' if ['TT','Tempest'].include?(c[i][1])
      c[i][1]='Forging Bonds' if ['FB','Bonds','Bond Trials'].include?(c[i][1])
      c[i][1]='Tap Battle' if c[i][1]=='Illusory Dungeon'
      c[i][1]='Log-In Bonus' if c[i][1]=='Log-In' || c[i][1]=='Login'
      c[i][2]=c[i][2].split(', ')
    end
    c2=c.reject{|q| q[2].nil? || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    c2=c.reject{|q| q[2].nil? || q[2][0].split('/').reverse.join('').to_i<=tm} if mode<0
    for i in 0...c2.length
      t2=c2[i][2][[mode,0].max].split('/').map{|q| q.to_i}
      t2=Time.new(t2[2],t2[1],t2[0])+24*60*60*([0,mode].min+1)
      t2=t2-t
      n=c2[i][0]
      if ['Voting Gauntlet','Tempest Trials','Forging Bonds','Quests','Log-In Bonus'].include?(c2[i][1])
        n="\"#{n}\" #{c2[i][1]}"
      elsif ['Bound Hero Battle','Grand Hero Battle','Legendary Hero Battle','Daily Reward Battle','Special Maps'].include?(c2[i][1])
        n="#{c2[i][1]}: *#{n}*"
      elsif c2[i][1]=='Grand Conquests'
        n="Grand Conquests"
      elsif c2[i][1]=='Tap Battle'
        n="Illusory Dungeon: #{n}"
      elsif c2[i][1]=='Update'
        n="#{n} Update"
      elsif c2[i][1]=='Orb Promo'
        n="#{c2[i][1]} (#{n})"
      else
        n="#{n} (#{c2[i][1]})"
      end
      if t2/(24*60*60)>1
        str2="#{str2}\n#{n} - #{(t2/(24*60*60)).floor} days #{mdfr}"
      elsif t2/(60*60)>1
        str2="#{str2}\n#{n} - #{(t2/(60*60)).floor} hours #{mdfr}"
      elsif t2/60>1
        str2="#{str2}\n#{n} - #{(t2/60).floor} minutes #{mdfr}"
      elsif t2>1
        str2="#{str2}\n#{n} - #{(t2).floor} seconds #{mdfr}"
      end
      if c2[i][1]=='Log-In Bonus' && mode>0
        t2=c2[i][2][0].split('/').map{|q| q.to_i}
        t2=Time.new(t2[2],t2[1],t2[0])+24*60*60
        t3=Time.new(t.year,t.month,t.day)+24*60*60
        t2=t3-t2
        t2=t2/(24*60*60)
        if 10-t2>0
          str2="#{str2} - #{(10-t2).floor} gifts remain for daily players"
        else
          str2="#{str2} - no gifts remain for daily players"
        end
      elsif c2[i][1]=='Grand Conquests' && mode>0
        t4=c2[i][2][0].split('/').map{|q| q.to_i}
        t4=Time.new(t4[2],t4[1],t4[0])+24*60*60
        t3=Time.new(t.year,t.month,t.day)+24*60*60
        t4=t3-t4
        t4=t4/(24*60*60)
        t4=t4.floor
        t2=c2[i][2][0].split('/').map{|q| q.to_i}
        t2=Time.new(t2[2],t2[1],t2[0])+24*60*60
        t2+=24*60*60*(2*(t4/2+1)-1)
        t2=t2-t
        if t2/(60*60)>44
          str2="#{str2} - waiting until Battle #{t4/2+1}"
        elsif t2/(60*60)>1
          str2="#{str2} - #{(t2/(60*60)).floor} hours remain in Battle #{t4/2+1}"
          str2="#{str2} (Round #{(11-(t2/(60*60)).floor/4).floor} currently ongoing)"
        elsif t2/60>1
          str2="#{str2} - #{(t2/60).floor} minutes remain in Battle #{t4/2+1}"
          str2="#{str2} (Round #{(11-(t2/(60*60)).floor/4).floor} currently ongoing)"
        elsif t2>1
          str2="#{str2} - #{t2.floor} seconds remain in Battle #{t4/2+1}"
          str2="#{str2} (Round #{(1-(t2/(60*60)).floor/4).floor} currently ongoing)"
        elsif t2.floor<=0
          str2="#{str2} - waiting until Battle #{t4/2+2}"
        end
      elsif c2[i][1]=='Voting Gauntlet' && mode>0
        t4=c2[i][2][0].split('/').map{|q| q.to_i}
        t4=Time.new(t4[2],t4[1],t4[0])+24*60*60
        t3=Time.new(t.year,t.month,t.day)+24*60*60
        t4=t3-t4
        t4=t4/(24*60*60)
        t4=t4.floor
        t2=c2[i][2][0].split('/').map{|q| q.to_i}
        t2=Time.new(t2[2],t2[1],t2[0],21,0)
        t2+=24*60*60*(2*(t4/2+1)-1)
        t2=t2-t
        if t2/(60*60)>1
          str2="#{str2} - #{(t2/(60*60)).floor} hours remain in Round #{t4/2+1}"
        elsif t2/60>1
          str2="#{str2} - #{(t2/60).floor} minutes remain in Round #{t4/2+1}"
        elsif t2>1
          str2="#{str2} - #{t2.floor} seconds remain in Round #{t4/2+1}"
        elsif t4/2<2
          str2="#{str2} - waiting until Round #{t4/2+2}"
        else
          str2="#{str2} - post-gauntlet buffer period"
        end
      end
    end
  end
  return str2
end

def week_from(d,dow)
  m=d*1
  m-=m%7
  m/=7
  return m+1 if d%7>=dow
  return m
end

def calc_easter()
  t = Time.now
  y = t.year
  c1 = y / 100
  n1 = y - 19 * (y / 19)
  k = (c1 - 17) / 25
  i1 = c1 - c1 / 4 - (c1 - k) / 3 + 19 * n1 + 15
  i1 = i1 - 30 * (i1 / 30)
  i1 = i1 - (i1 / 28) * (1 - (i1 / 28) * (29 / (i1 + 1)) * ((21 - n1) / 11))
  l1 = y + y / 4 + i1 + 2 - c1 + c1 / 4
  l1 = l1 - 7 * (l1 / 7)
  l1 = i1 - l1
  m = 3 + (l1 + 40) / 44
  d = l1 + 28 - 31 * (m / 4)
  if t.month>m || (t.month==m && t.day>d)
    y += 1
    c1 = y / 100
    n1 = y - 19 * (y / 19)
    k = (c1 - 17) / 25
    i1 = c1 - c1 / 4 - (c1 - k) / 3 + 19 * n1 + 15
    i1 = i1 - 30 * (i1 / 30)
    i1 = i1 - (i1 / 28) * (1 - (i1 / 28) * (29 / (i1 + 1)) * ((21 - n1) / 11))
    l1 = y + y / 4 + i1 + 2 - c1 + c1 / 4
    l1 = l1 - 7 * (l1 / 7)
    l1 = i1 - l1
    m = 3 + (l1 + 40) / 44
    d = l1 + 28 - 31 * (m / 4)
  end
  return [y,m,d]
end

def next_holiday(bot,mode=0)
  t=Time.now
  t-=60*60*6
  holidays=[[0,1,1,'Tiki(Young)','as Babby New Year',"New Year's Day"],
            [0,2,2,'Feh','the best gacha game ever!','Game Release Anniversary'],
            [0,2,14,'Cordelia(Bride)','with your heartstrings.',"Valentine's Day"],
            [0,3,17,'Ephraim','in recognition of AcePower#1000',"Donator's birthday"],
            [0,3,28,'Faye','in recognition of MiniMytch#0155',"Donator's birthday"],
            [0,4,1,'Priscilla','tribute to Xander for making this possible.',"April Fool's Day"],
            [0,4,24,'Sakura(BDay)','dressup as my best friend.',"Coder's birthday"],
            [0,4,29,'Anna',"with all the money you're giving me",'Golden Week'],
            [0,7,4,'Arthur','for freedom and justice.','Independance Day'],
            [0,7,22,'Nowi(Halloween)','in recognition of Shaq#7647',"Donator's birthday"],
            [0,8,6,'Zelgius','in recognition of DullahansXMark#9036',"Donator's birthday"],
            [0,9,16,'Genny','in recognition of Straynine#3480',"Donator's birthday"],
            [0,10,31,'Henry(Halloween)','with a dead Emblian. Nyahaha!','Halloween'],
            [0,12,6,'Lilina','in recognition of TimDiamond#6094',"Donator's birthday"],
            [0,12,12,'Soleil','in recognition of DeepDarkDad#2070',"Donator's birthday"],
            [0,12,25,'Robin(M)(Winter)','as Santa Claus for Askr.','Christmas'],
            [0,12,31,'Tiki(Adult)','as Mother Time',"New Year's Eve"]]
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
  holidays.sort! {|a,b| supersort(a,b,0) == 0 ? (supersort(a,b,1) == 0 ? (supersort(a,b,2) == 0 ? supersort(a,b,6) : supersort(a,b,2)) : supersort(a,b,1)) : supersort(a,b,0)}
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
      @avvie_data=[k[0][3],k[0][4],k[0][5]]
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
        @avvie_data=[k[k.length-1][3],k[k.length-1][4],k[k.length-1][5]]
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
        @avvie_data=[k[j][3],k[j][4],k[j][5]]
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
    @scheduler.at "#{k[0][0]}/#{k[0][1]}/#{k[0][2]} 0000" do
      next_holiday(bot,1)
    end
  end
end

bot.ready do |event|
  if @shardizard==4
    for i in 0...bot.servers.values.length
      if ![285663217261477889,443172595580534784,443181099494146068,443704357335203840,449988713330769920].include?(bot.servers.values[i].id)
        bot.servers.values[i].general_channel.send_message("I am Mathoo's personal debug bot.  As such, I do not belong here.  You may be looking for one of my two facets, so I'll drop both their invite links here.\n\n**EliseBot** allows you to look up stats and skill data for characters in *Fire Emblem: Heroes*\nHere's her invite link: <https://goo.gl/Hf9RNj>\n\n**FEIndex**, also known as **RobinBot**, is for *Fire Emblem: Awakening* and *Fire Emblem Fates*.\nHere's her invite link: <https://goo.gl/f1wSGd>") rescue nil
        bot.servers.values[i].leave
      end
    end
  end
  system("color 5#{"7CBAE"[@shardizard,1]}")
  system("title loading #{['Transparent','Scarlet','Azure','Verdant','Golden'][@shardizard]} EliseBot")
  bot.game="Loading, please wait..." if @shardizard.zero?
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  @aliases=b
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
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
  system("color e#{"04126"[@shardizard,1]}")
  system("title #{['Transparent','Scarlet','Azure','Verdant','Golden'][@shardizard]} EliseBot")
  bot.game='Fire Emblem Heroes' if [0,4].include?(@shardizard)
  if @shardizard==4
    bot.user(bot.profile.id).on(285663217261477889).nickname='EliseBot (Debug)'
    bot.profile.avatar=(File.open('C:/Users/Mini-Matt/Desktop/devkit/DebugElise.png','r'))
  else
    next_holiday(bot)
    puts 'Avatar loaded' if @shardizard.zero?
  end
end

bot.run
