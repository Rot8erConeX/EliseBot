shardizard = ARGV.first.to_i             # taking a single variable from the command prompt to get the shard value
system("color 0#{"7CBAE"[shardizard,1]}") # command prompt color and title determined by the shard
system("title loading #{['Transparent','Scarlet','Azure','Verdant','Golden'][shardizard]} EliseBot")

require 'discordrb'                    # Download link: https://github.com/meew0/discordrb
require 'open-uri'                     # pre-installed with Ruby in Windows
require 'net/http'                     # pre-installed with Ruby in Windows
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
if shardizard==4
  bot = Discordrb::Commands::CommandBot.new token: '>Debug Token<', client_id: >Debug ID<, prefix: @prefix
else
  bot = Discordrb::Commands::CommandBot.new token: '>Main Token<', shard_id: shardizard, num_shards: 4, client_id: 312451658908958721, prefix: @prefix
end
bot.gateway.check_heartbeat_acks = false

# initialize global variables
@data=[]
@skills=[]
@names=[]
@groups=[]
@embedless=[]
@ignored=[]
@banner=[]
@server_data=[[0,0,0,0],[0,0,0,0]]
@server_markers=[]
@x_markers=[]
@dev_waifus=[]
@dev_lowlifes=[]
@dev_units=[]
@stored_event=nil
@announcement=''
@zero_by_four=[0,0]
@headpats=[0,0,0]
@summon_servers=[330850148261298176,389099550155079680,256291408598663168,271642342153388034,285663217261477889,280125970252431360,
                 341729526767681549,393775173095915521,380013135576432651]
@summon_rate=[0,0]
@mods=[[0, 6, 7, 7, 8, 8], # this is a translation of the graphic displayed in the "growths" command.
       [0, 8, 8, 9,10,10],
       [0, 9,10,11,12,13],
       [0,11,12,13,14,15],
       [0,13,14,15,16,17],
       [0,14,15,17,18,19],
       [0,16,17,19,20,22],
       [0,18,19,21,22,24],
       [0,19,21,23,24,26],
       [0,21,23,25,26,28],
       [0,23,25,27,28,30],
       [0,24,26,29,31,33],
       [0,26,28,31,33,35],
       [0,28,30,33,35,37]]
@natures=[["Gentle","Resistance","Defense"], # this is a list of all the nature names that can be displayed, with the affected stats
          ["Bold","Defense","Attack"],
          ["Timid","Speed","Attack"],
          ["Lonely","Attack","Defense"],
          ["Mild","Attack","Defense"],
          ["Hasty","Speed","Defense"],
          ["Impish","Defense","Attack"],       # entries with "true" at the end cannot be typed in by end users but can be displayed, other entries can do both
          ["Calm","Resistance","Attack",true], # "Calm" cannot be typed in due to it meaning something different between FE and Pokemon (where the nature names come from)
          ["Careful","Resistance","Attack"],
          ["Jolly","Speed","Attack"],
          ["Naive","Speed","Resistance"],
          ["Naughty","Attack","Resistance"],
          ["Lax","Defense","Resistance"],
          ["Rash","Attack","Resistance"],
          ["Relaxed","Defense","Speed"],
          ["Brave","Attack","Speed",true], # "Brave" cannot be typed due to it being both a unit classification and a weapon classification
          ["Quiet","Attack","Speed"],
          ["Sassy","Resistance","Speed"],
          ["`\u22C0`Strong","Attack","HP",true],
          ["`\u22C0`Clever","Attack","HP",true],
          ["`\u22C0`Quick","Speed","HP",true],
          ["`\u22C0`Sturdy","Defense","HP",true],
          ["`\u22C0`Robust","Resistance","HP",true],
          ["`\u22C1`Weak","HP","Attack",true],
          ["`\u22C1`Dull","HP","Attack",true],
          ["`\u22C1`Sluggish","HP","Speed",true],
          ["`\u22C1`Fragile","HP","Defense",true],
          ["`\u22C1`Excitable","HP","Resistance",true]]

def all_commands(include_nil=false) # a list of all the command names.  Used by Nino Mode to ignore messages that are commands, so responses do not double up.
  k=['stat','unit','sort','data','find','wiki','tier','help','addalias','skill','aliases','flowers','seealiases','checkaliases','sendmessage','addgroup','sendpm','search','bugreport','skills','stats','flowers','flower','deletealias','removealias','seegroups','checkgroups','groups','deletegroup','removegroup','removemember','removefromgroup','embeds','embed','natures','invite','sendpm','ignoreuser','leaveserver','snagstats','reboot','stats','devedit','dev_edit','summon','study','list','bst','effHP','effhp','eff_hp','eff_HP','refine','refinery','average','mean','tools','compare','comparison','fodder','status','growths','growth','gps','gp','bulk','whyelise','random','bestin','bestamong','bestatats','stat','merges','setmarker','backup','restore','higheststats','worstamong','worstin','worststats','loweststats','healstudy','studyheal','heal_study','study_heal','games','rand','feedback','suggestion','legendary','legendaries','patpat','pat','statsskills','statskills','stats_skills','stat_skills','statsandskills','statandskills','stats_and_skills','stat_and_skills','statsskill','statskill','stats_skill','stat_skill','statsandskill','statandskill','stats_and_skill','stat_and_skill','shard','procstudy','studyproc','proc_study','study_proc','phasestudy','studyphase','phase_study','study_phase','compareskills','compareskill','skillcompare','skillscompare','comparisonskills','comparisonskill','skillcomparison','skillscomparison','compare_skills','compare_skill','skill_compare','skills_compare','comparison_skills','comparison_skill','skill_comparison','skills_comparison','skillsincommon','skills_in_common','commonskills','common_skills','locate','locateshard','locateshards','links','art','skillrarity','onestar','twostar','threestar','fourstar','fivestar','skill_rarity','one_star','two_star','three_star','four_star','five_star','summonpool','summon_pool','pool','allinheritance','allinherit','allinheritable','skillinheritance','skillinherit','skillinheritable','skilllearn','skilllearnable','skillsinheritance','skillsinherit','skillsinheritable','skillslearn','skillslearnable','inheritanceskills','inheritskill','inheritableskill','learnskill','learnableskill','inheritanceskills','inheritskills','inheritableskills','learnskills','learnableskills','all_inheritance','all_inherit','all_inheritable','skill_inheritance','skill_inherit','skill_inheritable','skill_learn','skill_learnable','skills_inheritance','skills_inherit','skills_inheritable','skills_learn','skills_learnable','inheritance_skills','inherit_skill','inheritable_skill','learn_skill','learnable_skill','inheritance_skills','inherit_skills','inheritable_skills','learn_skills','learnable_skills','inherit','learn','inheritance','learnable','inheritable','skillearn','skillearnable']
  k[0]=nil if include_nil
  return k
end

def data_load() # loads the character and skill data from the files on my computer
  # UNIT DATA
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHData.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHData.txt').each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  bob4=[]
  @data=[]
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
      for j in 4...14 # growth rates and level 40 stats should be stored as numbers, not strings
        bob4[j]=bob4[j].to_i
      end
    end
    if bob4.length>20 # the list of games should be spliced into an array of game abbreviations
      if bob4[21].length>1
        bob4[21]=bob4[21].split(', ')
      else
        bob4[21]=[' ']
      end
    end
    if bob4.length>21
      unless bob4[22].nil? # server-specific units' markers should be split into two pieces - the server(s) they are allowed in, and the ID of the user whose avatar to use
        bob4[23]=bob4[22].gsub(bob4[22].scan(/[[:alpha:]]+?/).join,'').to_i
        bob4[22]=bob4[22].scan(/[[:alpha:]]+?/).join
      end
    end
    @data.push(bob4)
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
    bob4[1]=bob4[1].to_i # SP cost should be stored as a number...
    bob4[2]=bob4[2].to_i unless bob4[2]=='-' # ...as should the Might or Cooldown
    bob4[20]=bob4[20].split(',').map{|q| q.to_i} if bob4[4]=="Weapon" # stats affected by the weapon, split into a list and turned from strings into numbers
    bob4[21]=nil unless bob4[21].nil? || bob4[21].length>0 # tag for server-specific skills
    bob4[22]=nil unless bob4[22].nil? || bob4[22].length>0 # this entry is used by weapons to store their evolutions, and by healing staves to store their healing formula
    bob4[23]=nil unless bob4[23].nil? || bob4[23].length>0 # this entry is used by weapons to store their refinement data
    @skills.push(bob4)
  end
end

def nicknames_load() # this function laods the nickname list
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  @names=b.uniq
end

def groups_load() # this function loads the groups list
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

def metadata_load() # this function loads the metadata - users who choose to see plaintext over embeds, data regarding each shard's server count, number of headpats received, etc.
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHSave.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHSave.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[[],[],[0,0],[[0,0,0,0,0],[0,0,0,0,0]],[0,0,0],[],[]]
  end
  @embedless=b[0]
  @embedless=[168592191189417984, 235527416901009410] if @embedless.nil?
  @ignored=b[1]
  @ignored=[] if @ignored.nil?
  @summon_rate=b[2]
  @summon_rate=[0,0] if @summon_rate.nil?
  @server_data=b[3]
  @server_data=[[0,0,0,0,0],[0,0,0,0,0]] if @server_data.nil?
  @headpats=b[4] unless b[4].nil?
  @server_markers=b[5] unless b[5].nil?
  @x_markers=b[6] unless b[6].nil?
end

def metadata_save() # this function saves the metadata
  x=[@embedless.map{|q| q}, @ignored.map{|q| q}, @summon_rate.map{|q| q}, @server_data.map{|q| q}, @headpats.map{|q| q}, @server_markers.map{|q| q}, @x_markers.map{|q| q}]
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHSave.txt', 'w') { |f|
    f.puts x[0].to_s
    f.puts x[1].to_s
    f.puts x[2].to_s
    f.puts x[3].to_s
    f.puts x[4].to_s
    f.puts x[5].to_s
    f.puts x[6].to_s
    f.puts "\n"
  }
end

def devunits_load() # this function loads information regarding the devunits
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHDevUnits.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHDevUnits.txt').each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  @dev_waifus=b[0].split('\\'[0])
  @dev_lowlifes=b[1].split('\\'[0])
  b[0]=nil
  b[1]=nil
  b[2]=nil
  b.compact!
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

def devunits_save() # this function is used by the devedit command to save the devunits
  s="#{@dev_waifus.join('\\'[0])}\n#{@dev_lowlifes.join('\\'[0])}"
  for i in 0...@dev_units.length
    s="#{s}\n\n#{@dev_units[i][0]}\n#{@dev_units[i][1]}\\#{@dev_units[i][2]}\\#{@dev_units[i][3]}\\#{@dev_units[i][4]}\\#{@dev_units[i][5]}\n#{@dev_units[i][6].join('\\'[0])}\n#{@dev_units[i][7].join('\\'[0])}\n#{@dev_units[i][8].join('\\'[0])}\n#{@dev_units[i][9].join('\\'[0])}\n#{@dev_units[i][10].join('\\'[0])}\n#{@dev_units[i][11].join('\\'[0])}\n#{@dev_units[i][12]}"
  end
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHDevUnits.txt', 'w') { |f|
    f.puts s
    f.puts "\n"
  }
  return nil
end

bot.command(:help) do |event, command, subcommand|
  command='' if command.nil?
  k=0
  k=event.server.id unless event.server.nil?
  if command.downcase=='help'
    event.respond 'The `help` command displays this message:'
    command=''
  end
  if command.downcase=='reboot'
    create_embed(event,'**reboot**',"Reboots this shard of the bot, installing any updates.\n\n**This command is only able to be used by Rot8er_ConeX**",0x008b8b)
  elsif command.downcase=='sendmessage'
    create_embed(event,'**sendmessage** __channel id__ __*message__',"Sends the message `message` to the channel with id `channel`\n\n**This command is only able to be used by Rot8er_ConeX**, and only in PM.",0x008b8b)
  elsif command.downcase=='leaveserver'
    create_embed(event,'**leaveserver** __server id number__',"Forces me to leave the server with the id `server id`.\n\n**This command is only able to be used by Rot8er_ConeX**, and only in PM.",0x008b8b)
  elsif command.downcase=='snagstats'
    create_embed(event,'**snagstats**',"Returns:\n- the number of servers I'm in\n- the numbers of units and skills in the game\n- the numbers of aliases and groups I keep track of\n- how long of a file I am.",0x40C0F0)
  elsif command.downcase=='shard'
    create_embed(event,'**shard**',"Returns the shard that this server is served by.",0x40C0F0)
  elsif ['bugreport','suggestion','feedback'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*message__","PMs my developer with your username, the server, and the contents of the message `message`",0x40C0F0)
  elsif command.downcase=='invite'
    create_embed(event,'**invite**',"PMs the invoker with a link to invite me to their server.",0x40C0F0)
  elsif command.downcase=='addalias'
    create_embed(event,'**addalias** __new alias__ __unit__',"Adds `new alias` to `unit`'s aliases.\nIf the arguments are listed in the opposite order, the command will auto-switch them.\n\nInforms you if the alias already belongs to someone.\nAlso informs you if the unit you wish to give the alias to does not exist.",0xC31C19)
  elsif ['allinheritance','allinherit','allinheritable','skillinheritance','skillinherit','skillinheritable','skilllearn','skilllearnable','skillsinheritance','skillsinherit','skillsinheritable','skillslearn','skillslearnable','inheritanceskills','inheritskill','inheritableskill','learnskill','learnableskill','inheritanceskills','inheritskills','inheritableskills','learnskills','learnableskills','all_inheritance','all_inherit','all_inheritable','skill_inheritance','skill_inherit','skill_inheritable','skill_learn','skill_learnable','skills_inheritance','skills_inherit','skills_inheritable','skills_learn','skills_learnable','inheritance_skills','inherit_skill','inheritable_skill','learn_skill','learnable_skill','inheritance_skills','inherit_skills','inheritable_skills','learn_skills','learnable_skills','inherit','learn','inheritance','learnable','inheritable','skillearn','skillearnable'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows all the skills that `name`can learn.\n\nIn servers, will only show the weapons, assists, and specials.\nIn PM, will also show the passive skills.",0xD49F61)
  elsif ['data','unit'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats, and skills.\n\nTyping in the names \"Robin\", \"Corrin\", and \"Tiki\" without any descriptors will display data on both variations of the named character, though only the stats and not the skills, due to not wanting to flood the channel with four embeds.",0xD49F61)
  elsif ['skill'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows data on the skill `name`.\n\nIf the skill is a weapon that can be refined, also shows all possible refinements.\nIncluding the word \"default\" or \"base\" in these cases will make this command only show the default weapon.\nOn the flip side, including the word \"refined\" will make this command only show data on the refinements.",0xD49F61)
  elsif ['stats'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats.\n\nTyping in the names \"Robin\", \"Corrin\", and \"Tiki\" without any descriptors will display data on both variations of the named character.",0xD49F61)
    disp_more_info(event)
  elsif ['healstudy','studyheal','heal_study','study_heal'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Takes the stats of the unit `name` and uses them to determine how much is healed with each healing staff.",0xD49F61)
  elsif ['procstudy','studyproc','proc_study','study_proc'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Takes the stats of the unit `name` and uses them to determine how much extra damage is dealt when each Special skill procs.",0xD49F61)
  elsif ['phasestudy','studyphase','phase_study','study_phase'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Takes the stats of the unit `name` and uses them to determine The actual stats the unit has during combat.",0xD49F61)
  elsif ['study'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows the level 40 stats for the unit `name` for a combination of multiple rarities with 0, 5, and 10 merges.",0xD49F61)
  elsif ['summonpool','summon_pool','pool'].include?(command.downcase) || (['summon'].include?(command.downcase) && "#{subcommand}".downcase=='pool')
    create_embed(event,"**#{command.downcase}#{" pool" if command.downcase=='summon'}** __*colors__","Shows the summon pool for the listed color.\n\nIn PM, all colors listed will be displayed, or all colors if none are specified.\nIn servers, only the first color listed will be displayed.",0x9E682C)
  elsif @summon_servers.include?(k) && ['summon'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*colors__","Simulates summoning on a randomly-chosen banner.\n\nIf given `colors`, auto-cracks open any orbs of said colors.\nOtherwise, requires a follow-up response of numbers.\n\n**This command is only available in certain servers**.",0x9E682C)
  elsif ['effhp','eff_hp'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows the effective HP data for the unit `name`.",0xD49F61)
    disp_more_info(event)
  elsif ['natures'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Responds with a chart with my nature names.",0xD49F61)
  elsif ['growths','growth','gps','gp'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Responds with a chart and explanation on how growths work, and how this creates what the fandom has dubbed \"superboons\" and \"superbanes\".",0xD49F61)
  elsif ['merges'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Responds with an explanation on how stats are affected by merging units.",0xD49F61)
  elsif ['flowers','flower'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Responds with a link to a page with a random flower.",0xD49F61)
  elsif ['donation','donate'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Responds with information regarding potential donations to my developer.",0xD49F61)
  elsif ['headpat'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Causes the invoker to try to headpat me.",0xD49F61)
  elsif ['tools','links'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Responds with a list of links useful to players of *Fire Emblem Heroes*.",0xD49F61)
  elsif ['skills','fodder'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and skills.\nYou can also include a rarity to show the skills that the unit learns at that rarity.\n\nTyping in the names \"Robin\", \"Corrin\", and \"Tiki\" without any descriptors will display data on both variations of the named character.",0xD49F61)
  elsif ['embed','embeds'].include?(command.downcase)
    event << "**embed**"
    event << ''
    event << "Toggles whether I post as embeds or plaintext when the invoker triggers a response from me.  By default, I display embeds for everyone."
    event << "This command is useful for people who, in an attempt to conserve phone data, disable the automatic loading of images, as this setting also affects their ability to see embeds."
    unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event << ''
      event << "This help window is not in an embed so that people who need this command can see it."
    end
    return nil
  elsif ['aliases','checkaliases','seealiases'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __unit__","Responds with a list of all `unit`'s aliases.\nIf no unit is listed, responds with a list of all aliases and who they are for.\n\nPlease note that if more than 50 aliases are to be listed, I will - for the sake of the sanity of other server members - only allow you to use the command in PM.",0xD49F61)
  elsif ['deletealias','removealias'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __alias__","Removes `alias` from the list of aliases, regardless of who it was for.",0xC31C19)
  elsif ['addgroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__ __\*members__","If there is already a group named `name`, adds `members` to it.\nIf there is not already a group with the name `name`, makes one and adds `members` to it.",0xC31C19)
  elsif ['seegroups','groups','checkgroups'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Shows all the existing groups, and their members.",0xD49F61)
  elsif ['deletegroup','removegroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Removes the group with the name `name`",0xC31C19)
  elsif ['removemember','removefromgroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __group__ __unit__","Removes the unit `unit` from the group with the name `group`.\nIf this causes `group` to have no members, it will also delete it.",0xC31C19)
  elsif ['bst'].include?(command.downcase)
    u=random_dev_unit_with_nature(event)
    create_embed(event,"**#{command.downcase}** __*allies__","Shows the BST of the units listed in `allies`.  If more than four characters are listed, I show both the BST of all those listed and the BST of the first four listed.\n\n**IMPORRTANT NOTE**\nUnlike my other commands, this one is heavily context based.  Please format all allies like the example below:\n`#{u[1]}* #{u[0]} +#{u[2]} +#{u[3]} -#{u[4]}`\nAny field with the exception of unit name can be ignored, but unlike my other commands the order is important.",0xD49F61)
  elsif ['refinery','refine'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Lists all weapons that can be refined or evolved in the weapon refinery, organized by whether they use Divine Dew or Refining Stones.",0xD49F61)
  elsif ['legendary','legendaries'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Lists all of the legendary heroes, sorted by up to three defined filters.\nBy default, will sort by Legendary __Element__ and then the non-HP __stat__ boost given by the hero.\n\nPossible filters (in order of priority when applied) :\nElement(s), Flavor(s), Affinity/Affinities\nStat(s), Boost(s)\nWeapon(s)\nColo(u)r(s)\nMove(s), Movement(s)",0xD49F61)
  elsif ['games'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows a list of games that the unit `name` is in.",0xD49F61)
  elsif ['rand','random'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Generates a random unit with random, but still valid, stats.",0xD49F61)
  elsif ['compare','comparison'].include?(command.downcase)
    u=random_dev_unit_with_nature(event)
    create_embed(event,"**#{command.downcase}** __*allies__","Compares the units listed in `allies`.  Shows each set of stats, as well as an analysis.\nThis command can compare anywhere between two and ten units.\n\n**IMPORRTANT NOTE**\nUnlike my other commands, this one is heavily context based.  Please format all allies like the example below:\n`#{u[1]}* #{u[0]} +#{u[2]} +#{u[3]} -#{u[4]}`\nAny field with the exception of unit name can be ignored, but unlike my other commands the order is important.",0xD49F61)
  elsif ['compareskills','compareskill','skillcompare','skillscompare','comparisonskills','comparisonskill','skillcomparison','skillscomparison','compare_skills','compare_skill','skill_compare','skills_compare','comparison_skills','comparison_skill','skill_comparison','skills_comparison','skillsincommon','skills_in_common','commonskills','common_skills'].include?(command.downcase)
    u=random_dev_unit_with_nature(event,false)
    create_embed(event,"**#{command.downcase}** __*allies__","Compares the units listed in `allies`.  Shows the skills that the units have in common.\nThis command can compare exactly two units.\n\n**IMPORRTANT NOTE**\nUnlike my other commands, this one is heavily context based.  Please format all allies like the example below:\n`#{u[1]}\* #{u[0]}`\nThe rarity can be ignored (and thus assumed to be 5\\*), but if you include it, it must be before the name.",0xD49F61)
  elsif ['average','mean'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then calculates their average in each stat.\n\n__**Allowed unit descriptions**__\n*Colors*: Red(s), Blue(s), Green(s), Colo(u)rless, Gray(s), Grey(s)\n*Weapon Types*: Physical, Blade(s), Tome(s), Mage(s), Spell(s), Dragon(s), Manakete(s), Breath, Bow(s), Arrow(s), Archer(s), Dagger(s), Shuriken, Knive(s), Ninja(s), Thief/Thieves, Healer(s), Cleric(s), Staff/Staves\n*Combined color and weapon type*: Sword(s), Katana, Spear(s), Lance(s), Naginata, Axe(s), Ax, Club(s)\n*Movement*: Flier(s), Flyer(s), Flying, Pegasus/Pegasi, Wyvern(s), Cavalry, Horse(s), Pony/Ponies, Horsie(s), Infantry, Foot/Feet, Armo(u)r(s), Armo(u)red",0xD49F61)
  elsif ['art'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __unit__ __art type__","Displays `unit`'s character art.  Defaults to their normal portrait, but can be adjusted to other portraits with the following words:\n*Default Attacking Image:* Battle/Battling, Attack/Atk/Att\n*Special Proc Image:* Critical/Crit, Special, Proc\n*Damaged Art:* Damage/Damaged, LowHP/LowHealth",0xD49F61)
  elsif ['bestamong','bestin','beststats','higheststats'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the best in each stat.\n\n__**Allowed unit descriptions**__\n*Colors*: Red(s), Blue(s), Green(s), Colo(u)rless, Gray(s), Grey(s)\n*Weapon Types*: Physical, Blade(s), Tome(s), Mage(s), Spell(s), Dragon(s), Manakete(s), Breath, Bow(s), Arrow(s), Archer(s), Dagger(s), Shuriken, Knive(s), Ninja(s), Thief/Thieves, Healer(s), Cleric(s), Staff/Staves\n*Combined color and weapon type*: Sword(s), Katana, Spear(s), Lance(s), Naginata, Axe(s), Ax, Club(s)\n*Movement*: Flier(s), Flyer(s), Flying, Pegasus/Pegasi, Wyvern(s), Cavalry, Horse(s), Pony/Ponies, Horsie(s), Infantry, Foot/Feet, Armo(u)r(s), Armo(u)red",0xD49F61)
  elsif ['worstamong','worstin','worststats','loweststats'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the worst in each stat.\n\n__**Allowed unit descriptions**__\n*Colors*: Red(s), Blue(s), Green(s), Colo(u)rless, Gray(s), Grey(s)\n*Weapon Types*: Physical, Blade(s), Tome(s), Mage(s), Spell(s), Dragon(s), Manakete(s), Breath, Bow(s), Arrow(s), Archer(s), Dagger(s), Shuriken, Knive(s), Ninja(s), Thief/Thieves, Healer(s), Cleric(s), Staff/Staves\n*Combined color and weapon type*: Sword(s), Katana, Spear(s), Lance(s), Naginata, Axe(s), Ax, Club(s)\n*Movement*: Flier(s), Flyer(s), Flying, Pegasus/Pegasi, Wyvern(s), Cavalry, Horse(s), Pony/Ponies, Horsie(s), Infantry, Foot/Feet, Armo(u)r(s), Armo(u)red",0xD49F61)
  elsif ['find','search'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['unit','char','character','person','units','chars','charas','chara','people'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, includes any units you name that don't fit into those filters, then displays the resulting list in alphabetical order.\n\n__**Allowed words**__\n*Colors*: Red(s), Blue(s), Green(s), Colo(u)rless, Gray(s), Grey(s)\n*Weapon Types*: Physical, Blade(s), Tome(s), Mage(s), Spell(s), Dragon(s), Manakete(s), Breath, Bow(s), Arrow(s), Archer(s), Dagger(s), Shuriken, Knive(s), Ninja(s), Thief/Thieves, Healer(s), Cleric(s), Staff/Staves\n*Combined color and weapon type*: Sword(s), Katana, Spear(s), Lance(s), Naginata, Axe(s), Ax, Club(s)\n*Movement*: Flier(s), Flyer(s), Flying, Pegasus/Pegasi, Wyvern(s), Cavalry, Horse(s), Pony/Ponies, Horsie(s), Infantry, Foot/Feet, Armo(u)r(s), Armo(u)red",0xD49F61)
    elsif ['skill','skills'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list.\nIf you specifically name one or more characters, their names will be underlined in the result.\n\n__**Allowed words**__\n*Colors*: Red(s), Blue(s), Green(s), Colo(u)rless, Gray(s), Grey(s)\n*Weapon Types*: Physical, Blade(s), Tome(s), Mage(s), Spell(s), Magic, Dragon(s), Manakete(s), Breath, Bow(s), Arrow(s), Archer(s), Dagger(s), Shuriken, Knive(s), Ninja(s), Thief/Thieves, Healer(s), Cleric(s), Staff/Staves\n*Combined color and weapon type*: Sword(s), Katana, Spear(s), Lance(s), Naginata, Axe(s), Ax, Club(s)\n\n*Assists*: Health, Hp, Move, Movement, Moving, Arrangement, Positioning, Position(s), Healer(s), Staff/Staves, Cleric(s), Rally/Rallies, Stat(s), Buff(s)\n\n*Specials*: Healer(s), Staff/Staves, Cleric(s), Balm(s), Defense/Defence, Defensive/Defencive, Damage, Damaging, Proc, AoE, Area, Spread\n\n*Passive*: A, B, C, S, Seal(s)",0xD49F61)
    else
      create_embed(event,"**#{command.downcase}** __\*filters__","Combines the results of `FEH!find unit` and `FEH!find skill`, showing them in a single embed.  This combined form is particularly useful when looking at weapon types, so you can see all the weapons *and* all the units that can use them side-by-side.",0xD49F61)
    end
  elsif ['setmarker'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __letter__","Sets the server's \"marker\", allowing for server-specific custom units and skills.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['backup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __item__","Backs up the alias list or the group list, depending on the word used as `item`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['restore'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Restores the the alias list or the group list, depending on the word used as `item`, from last backup.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['status'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*message__","Sets my status message to `message`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['locateshards','locateshard','locate'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** #{"shard#{['','s'].sample}" if command.downcase=='locate'}","Informs you of one server you and I share for each kind of shard.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['devedit'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['create'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*stats__","Allows me to create a new devunit with the character `unit` and stats described in `stats`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['promote','rarity','feathers'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","Causes me to promote the devunit with the name `unit`.\n\nIf `number` is defined, I will promote the devunit that many times.\nIf not, I will promote them once.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['merge','combine'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['nature','ivs'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*effects__","\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['learn','teach'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill types__","\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    else
      create_embed(event,"**#{command.downcase}** __subcommand__ __unit__ __\*effects__","Allows me to create and edit the devunits.\n\nAvailable subcommands include:\n`FEH!#{command.downcase} create` - creates a new devunit\n`FEH!#{command.downcase} promote` - promotes an existing devunit (*also `rarity` and `feathers`*)\n`FEH!#{command.downcase} merge` - increases a devunit's merge count (*also `combine`*)\n`FEH!#{command.downcase} nature` - changes a devunit's nature (*also `ivs`*)\n`FEH!#{command.downcase} teach` - teaches a new skill to a devunit (*also `learn`*)\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    end
  elsif ['skillrarity','onestar','twostar','threestar','fourstar','fivestar','skill_rarity','one_star','two_star','three_star','four_star','five_star'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Explains why some units have skills listed at lower rarities than they are available at.",0xD49F61)
  elsif ['sort'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['groups','group'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Sorts the groups list alphabetically by group name.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['alias','aliases'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Sorts the alias list alphabetically by unit the alias is for.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    else
      create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units which match your defined filters, includes any units you name that don't fit into those filters, then displays the resulting list in order based on the stats you include.\n\n__**Allowed unit descriptions**__\n*Colors*: Red(s), Blue(s), Green(s), Colo(u)rless, Gray(s), Grey(s)\n*Weapon Types*: Physical, Blade(s), Tome(s), Mage(s), Spell(s), Dragon(s), Manakete(s), Breath, Bow(s), Arrow(s), Archer(s), Dagger(s), Shuriken, Knive(s), Ninja(s), Thief/Thieves, Healer(s), Cleric(s), Staff/Staves\n*Combined color and weapon type*: Sword(s), Katana, Spear(s), Lance(s), Naginata, Axe(s), Ax, Club(s)\n*Movement*: Flier(s), Flyer(s), Flying, Pegasus/Pegasi, Wyvern(s), Cavalry, Horse(s), Pony/Ponies, Horsie(s), Infantry, Foot/Feet, Armo(u)r(s), Armo(u)red\n\n__**Allowed stat descriptions**__\nHP, Health, STR, Strength, MAG, Magic, ATK, Att, Attack, SPD, Speed, DEF, Defense/Defence, RES, Resistance",0xD49F61)
    end
  else
    event.respond "#{command.downcase} is not a command" if command!='' && command.downcase != 'devcommands'
    create_embed(event,"Command Prefixes: #{@prefix.map{|q| q.upcase}.uniq.map {|s| "`#{s}`"}.join(', ')}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n__**Elise Bot help**__","__**Unit Data**__\n`data` __name__ - shows both stats and skills (*also `unit`*)\n`stats` __name__ - shows only the stats\n`skills` __name__ - shows only the skills (*also `fodder`*)\n`study` __name__ - for a study of the unit at multiple rarities and merges\n`effHP` __name__ - for a study of the unit's bulkiness (*also `bulk`*)\n`aliases` __name__ - show all aliases for the unit (*also `checkaliases` or `seealiases`*)\n`healstudy` __name__ - to see what how much each healing staff does (*also `studyheal`*)\n`procstudy` __name__ - to see what how much each damaging Special does (*also `studyproc`*)\n`phasestudy` __name__ - to see what the actual stats the unit has during combat (*also `studyphase`*)\n`games` __unit__ - for a list of games the unit is in\n`art` __unit__ __art type__ - for the character's art\n`learnable` __name__ - for a list of all learnable skills (*also `inheritable`*)\n\n__**Other Data**__\n`bst` __\\*allies__\n`find` __\\*filters__ - used to generate a list of applicable units and/or skills (*also `search`*)\n`summonpool` \\*colors - for a list of summonable units sorted by rarity (*also `pool`*)\n`legendaries` \\*filters - for a sorted list of all legendaries. (*also `legendary`*)\n`refinery` - used to show a list of refineable weapons (*also `refine`*)\n`sort` __\\*filters__ - used to create a list of applicable units and sort them based on specified stats\n`skill` __skill name__ - used to show data on a specific skill\n`average` __\\*filters__ - used to find the average stats of applicable units (*also `mean`*)\n`bestamong` __\\*filters__ - used to find the best stats among applicable units (*also `bestin`, `beststats`, or `higheststats`*)\n`worstamong` __\\*filters__ - used to find the worst stats among applicable units (*also `worstin`, `worststats`, or `loweststats`*)\n`compare` __\\*allies__ - compares units' stats (*also `comparison`*)\n`compareskills` __\\*allies__ - compares units' skills",0xD49F61)
    create_embed(event,"","__**Meta data**__\n`groups` (*also `checkgroups` or `seegroups`*) - for a list of all unit groups\n`tools` - for a list of tools aside from me that may aid you\n`natures` - for help understanding my nature names\n`growths` - for help understanding how growths work (*also `gps`*)\n`merges` - for help understanding how merges work\n`invite` - for a link to invite me to your server\n`random` - generates a random unit (*also `rand`*)\n\n__**Developer Information**__\n`bugreport` __\\*message__\n`suggestion` __\\*message__\n`feedback` __\\*message__\n`donation` (*also `donate`*)\n`whyelise`\n`skillrarity` (*also `skill_rarity`*)#{"\n\n__**Server-specific command**__\n`summon` \\*colors - to simulate summoning on a randomly-chosen banner" if !event.server.nil? && @summon_servers.include?(event.server.id)}",0xD49F61)
    create_embed(event,"__**Server Admin Commands**__","__**Unit Aliases**__\n`addalias` __new alias__ __unit__ - Adds a new server-specific alias\n~~`aliases` __unit__ (*also `checkaliases` or `seealiases`*)~~\n`deletealias` __alias__ (*also `removealias`*) - deletes a server-specific alias\n\n__**Groups**__\n`addgroup` __name__ __\\*members__ - adds a server-specific group\n~~`groups` (*also `checkgroups` or `seegroups`*)~~\n`deletegroup` __name__ (*also `removegroup`*) - Deletes a server-specific group\n`removemember` __group__ __unit__ (*also `removefromgroup`*) - removes a single member from a server-specific group\n\n",0xC31C19) if is_mod?(event.user,event.server,event.channel)
    create_embed(event,"__**Bot Developer Commands**__","`devedit` __subcommand__ __unit__ __\\*effect__\n\n`ignoreuser` __user id number__ - makes me ignore a user\n`leaveserver` __server id number__ - makes me leave a server\n\n`sendpm` __user id number__ __\\*message__ - sends a PM to a user\n`sendmessage` __channel id__ __\\*message__ - sends a message to a specific channel\n\n`snagstats` - snags server stats for multiple servers\n`setmarker` __letter__\n\n`reboot` - reboots this shard\n\n`backup` __item__ - backs up the (alias/group) list\n`restore` __item__ - restores the (alias/group) list from last backup\n`sort aliases` - sorts the alias list alphabetically by unit\n`sort groups` - sorts the group list alphabetically by group name\n\n`status` __\\*message__ - sets my status\n\n`locateshards` - lists one server you are in for each color of shard.",0x008b8b) if (event.server.nil? || command.downcase=='devcommands') && event.user.id==167657750971547648
    event.respond "If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nCommand Prefixes: #{@prefix.map{|q| q.upcase}.uniq.map {|s| "`#{s}`"}.join(', ')}\nYou can also use `FEH!help CommandName` to learn more on a particular command."
  end
end

bot.command(:reboot, from: 167657750971547648) do |event| # reboots Elise
  return nil unless event.user.id==167657750971547648
  exec "cd C:/Users/Mini-Matt/Desktop/devkit && PriscillaBot.rb #{@shardizard}"
end

def get_markers(event)
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

def disp_more_info(event)
  create_embed(event,"","You can modify the unit by including any of the following in your message:\n\n**Rarity**\nProper format: #{rand(5)+1}\\*\n~~Alternatively, the first number not given proper context will be set as the rarity value unless the rarity value is already defined~~\nDefault: 5\\* unit\n\n**Merges**\nProper format: +#{rand(10)+1}\n~~Alternatively, the second number not given proper context will be set as the merges value unless the merges value is already defined~~\nDefault: +0\n\n**Boon**\nProper format: +#{['Atk','Spd','Def','Res','HP'].sample}\n~~Alternatively, the first stat name not given proper context will be set as the boon unless the boon is already defined~~\nDefault: No boon\n\n**Bane**\nProper format: -#{['Atk','Spd','Def','Res','HP'].sample}\n~~Alternatively, the second stat name not given proper context will be set as the bane unless the bane is already defined~~\nDefault: No bane\n\n**Weapon**\nProper format: Silver Dagger+ ~~just the weapon's name~~\nDefault: No weapon\n\n**Refined Weapon**\nProper format: Falchion (+) #{['Atk','Spd','Def','Res','Effect'].sample}\nSecondary format: Falchion #{['Atk','Spd','Def','Res','Effect'].sample} Mode\nTertiary format: Falchion (#{['Atk','Spd','Def','Res','Effect'].sample})\n~~Alternatively, the third stat name not given proper context, or the second stat given a + in front of it, will be set as the refinement for the weapon if one is equipped and it can be refined~~\n\n**Tempest Bonus Unit Buff**\nProper format: Tempest\nDefault: Not applied\n\n**Summoner Support**\nProper format: #{['C','B','A','S'].sample} ~~Just a single letter~~\nDefault: No support\n\n**Stat-affecting Skills**\nOptions: HP+, Atk+, Spd+, Def+, Res+, LifeAndDeath/LnD/LaD, Fury, FortressDef, FortressRes\n~~LnD, Fury, and the Fortress skills default to tier 3, but other tiers can be applied by including numbers like so: LnD1~~\nDefault: No skills applied\n\n**Stat-buffing Skills**\nOptions: Rally skills, Defiant skills, Hone/Fortify skills, Balm skills\n~~please note that the skill name must be written out without spaces~~\nDefault: No skills applied\n\nThese can be listed in any order.",0x40C0F0)
end

def random_dev_unit_with_nature(event,x=true)
  devunits_load()
  u=@dev_units.sample
  if x
    return random_dev_unit_with_nature(event) if u[3]==' ' || u[4]==' ' || find_unit(u[0],event,true)<0
  end
  return u
end

def get_stats(event,name,level=40,rarity=5,merges=0,boon='',bane='')
  data_load()
  # find neutral five-star level 40 stats
  f=@data[find_unit(name,event)]
  # find neutral level 1 stats based on rarity
  r=[f[4],f[5],f[6],f[7],f[8]]                                                                                 # rate numbers
  m=[@mods[r[0]],@mods[r[1]],@mods[r[2]],@mods[r[3]],@mods[r[4]]]                                              # growth rates
  m=[m[0][5],m[1][5],m[2][5],m[3][5],m[4][5]]                                                                  # difference between stats in level 1 and level 40
  u=[f[0],f[9]-m[0],f[10]-m[1],f[11]-m[2],f[12]-m[3],f[13]-m[4]]                                               # apply the difference in the step above
  s=[[u[2],2],[u[3],3],[u[4],4],[u[5],5]]                                                                      # all non-HP stats
  s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}                                     # sort the stats based on amount
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
  # find level 1 stats based on boon and bane
  u[1]+=1 if boon.downcase=="hp"
  u[2]+=1 if boon.downcase=="attack"
  u[3]+=1 if boon.downcase=="speed"
  u[4]+=1 if boon.downcase=="defense"
  u[5]+=1 if boon.downcase=="resistance"
  u[1]-=1 if bane.downcase=="hp"
  u[2]-=1 if bane.downcase=="attack"
  u[3]-=1 if bane.downcase=="speed"
  u[4]-=1 if bane.downcase=="defense"
  u[5]-=1 if bane.downcase=="resistance"
  s2=u.map{|q| q}
  # if rarity is even, increase the two highest non-HP stats by 1 each
  if rarity%2==0
    u[s[0][1]]+=1
    u[s[1][1]]+=1
  end
  # find growth rates based on boon and bane
  r[0]+=1 if boon.downcase=="hp"
  r[1]+=1 if boon.downcase=="attack"
  r[2]+=1 if boon.downcase=="speed"
  r[3]+=1 if boon.downcase=="defense"
  r[4]+=1 if boon.downcase=="resistance"
  r[0]-=1 if bane.downcase=="hp"
  r[1]-=1 if bane.downcase=="attack"
  r[2]-=1 if bane.downcase=="speed"
  r[3]-=1 if bane.downcase=="defense"
  r[4]-=1 if bane.downcase=="resistance"
  # find stats based on merges
  s=[[s2[1],1],[s2[2],2],[s2[3],3],[s2[4],4],[s2[5],5]]                                                        # all stats
  s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}                                     # sort the stats based on amount
  s.push(s[0],s[1],s[2],s[3],s[4])                                                                             # loop the list for use with multiple merges
  s.push(s[0],s[1],s[2],s[3],s[4])
  s.push(s[0],s[1],s[2],s[3],s[4])
  if level==40
    # find level 40 stats based on growth rates and level 1 stats
    # growth rates
    if rarity <= @mods[0].length && r.max <= @mods.length # difference between stats in level 1 and level 40
      m=[@mods[r[0]][rarity],@mods[r[1]][rarity],@mods[r[2]][rarity],@mods[r[3]][rarity],@mods[r[4]][rarity]]
    else
      m2=[r[0],r[1],r[2],r[3],r[4]]
      m=[0,0,0,0,0]
      for i in 0...m.length
        if m2[i] == 0
          m[i] = 6 + 2*m2[i] + (rarity/2)
        elsif m2[i] == 1
          m[i] = 6 + 2*m2[i] + (rarity/3) + (rarity/4)
        elsif m2[i] <= 4
          m[i] = 4 + 2*m2[i] + rarity
        elsif m2[i] == 5
          m[i] = 3 + 2*m2[i] + rarity + (rarity/3)
        elsif m2[i] <= 7
          m[i] = 9 + 1*m2[i] + rarity + ((rarity-1)/2)
        elsif m2[i] <= 10
          m[i] = 1 + 2*m2[i] + 2*rarity - (rarity/4)
        else
          m[i] = 2*m2[i] + 2*rarity + (rarity/3)
        end
      end
    end
    u=[u[0],u[1]+m[0],u[2]+m[1],u[3]+m[2],u[4]+m[3],u[5]+m[4],r[0],r[1],r[2],r[3],r[4],m[0],m[1],m[2],m[3],m[4]]
    # apply the difference above
  end
  if merges>0                                                                                                  # apply merges, two stats per merge
    m=2*(merges/5)
    u[1]+=2*(merges/5)
    u[2]+=2*(merges/5)
    u[3]+=2*(merges/5)
    u[4]+=2*(merges/5)
    u[5]+=2*(merges/5)
    if (merges%5)>0
      for i in 0...2*(merges%5)
        u[s[i][1]]+=1
      end
    end
  end
  return u
end

def make_stats_string(event,name,rarity,boon='',bane='',hm=10)
  k=""
  hm=[hm.to_i, hm.to_i]
  args=sever(event.message.text.downcase).split(" ")
  hm[0]=10 if hm[0]<0 || args.include?('full') || args.include?('merges')
  hm[1]=0-hm[1] if hm[1]<0
  for i in 0...hm[0]+1
    u=get_stats(event,name,40,rarity,i,boon,bane)
    u=["Kiran",0,0,0,0,0] if u[0]=="Kiran"
    k="#{k}\n**#{i} merge#{'s' unless i==1}:** #{u[1]} / #{u[2]} / #{u[3]} / #{u[4]} / #{u[5]}		(BST: #{u[1]+u[2]+u[3]+u[4]+u[5]})" if i%5==0 || i==hm[1] || args.include?('full') || args.include?('merges')
  end
  return k
end

def is_mod?(user,server,channel)
  return true if user.id==167657750971547648
  return false if server.nil?
  return true if user.id==server.owner.id
  for i in 0...user.roles.length
    return true if ['mod','mods','moderator','moderators','admin','admins','administrator','administrators','owner','owners'].include?(user.roles[i].name.downcase.gsub(' ',''))
  end
  return true if user.permission?(:manage_messages,channel)
  return false
end

def make_banner()
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
  end
  data_load()
  bnr=b.sample
  x=false
  y=false
  z=false
  w=false
  unless bnr[3].nil?
    x=true if bnr[3].include?('4')
    y=true if bnr[3].include?('3')
    z=true if bnr[3].include?('2')
    w=true if bnr[3].include?('1')
    bnr[3]=nil
  end
  bnr.compact!
  bnr.push([])
  bnr.push([])
  bnr.push([])
  bnr.push([])
  bnr.push([])
  for i in 0...@data.length
    bnr[2].push(@data[i][0]) if @data[i][19].downcase.include?('g') && bnr[0]=='GHB Units' && @data[i][22].nil?
    bnr[2].push(@data[i][0]) if @data[i][19].downcase.include?('t') && bnr[0]=='TT Units' && @data[i][22].nil?
  end
  if x
    bnr.push(bnr[2].map{|q| q})
  else
    bnr.push(nil)
  end
  if y
    bnr.push(bnr[2].map{|q| q})
  else
    bnr.push(nil)
  end
  if z
    bnr.push(bnr[2].map{|q| q})
  else
    bnr.push(nil)
  end
  if w
    bnr.push(bnr[2].map{|q| q})
  else
    bnr.push(nil)
  end
  for i in 0...@data.length
    bnr[3].push(@data[i][0]) if @data[i][19].include?('5p') && !bnr[2].include?(@data[i][0]) && @data[i][22].nil?
    bnr[4].push(@data[i][0]) if @data[i][19].include?('4p') && @data[i][22].nil? && (!bnr[2].include?(@data[i][0]) || !x)
    bnr[5].push(@data[i][0]) if @data[i][19].include?('3p') && @data[i][22].nil? && (!bnr[2].include?(@data[i][0]) || !y)
    bnr[6].push(@data[i][0]) if @data[i][19].include?('2p') && @data[i][22].nil? && (!bnr[2].include?(@data[i][0]) || !z)
    bnr[7].push(@data[i][0]) if @data[i][19].include?('1p') && @data[i][22].nil? && (!bnr[2].include?(@data[i][0]) || !w)
  end
  return bnr
end

def crack_orbs(event,e,user,list)
  summons=0
  five_star=false
  cutscene=true
  for i in 1...6
    if list.include?(i)
      if cutscene && ["Camilla","Lyn","Roy","Takumi","Lucina","Marth","Tiki(Young)","Robin(M)"].include?(@banner[i][1])
        event.respond "OH!  Cutscene!  Cutscene!"
        sleep 5
        cutscene=false
      end
      e << "Orb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1]}** (*#{@banner[i][2]}*)"
      summons+=1
      five_star=true if @banner[i][0][0].to_i==5
    end
  end
  e << ""
  e << "In this current summoning session, you fired Breidablik #{summons} time#{"s" unless summons==1}, expending #{[0,5,9,13,17,20][summons]} orbs."
  metadata_load()
  @summon_rate[0]+=summons
  @summon_rate[1]+=[0,5,9,13,17,20][summons]
  e << "Since the last 5\* summons, Breidablik has been fired #{@summon_rate[0]} time#{"s" unless @summon_rate[0]==1} and #{@summon_rate[1]} orbs have been expended."
  @summon_rate=[0,0] if five_star
  metadata_save()
  @banner=[]
end

def normalize(str)
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
  str=str.gsub("\u2111",'i').gsub("\u0197",'i').gsub("\u0130",'i').gsub("\u00CD",'i').gsub("\u00ED",'i').gsub("\u012D",'i').gsub("\u01D0",'i').gsub("\u00CE",'i').gsub("\u00EE",'i').gsub("\u00CF",'i').gsub("\u00EF",'i').gsub("\u0130",'i').gsub("\u1CEB",'i').gsub("\u0209",'i').gsub("\u00CC",'i').gsub("\u00EC",'i').gsub("\u1EC9",'i').gsub("\u020B",'i').gsub("\u012B",'i').gsub("\u012F",'i').gsub("\u0197",'i').gsub("\u0268",'i').gsub("\u1E2D",'i').gsub("\u0129",'i').gsub("\u2111",'i').gsub("\u0365",'i').gsub("\u2148",'i').gsub("\u026A",'i').gsub("\u0131",'i').gsub("\u1D09",'i').gsub("\u1D62",'i').gsub("\u2110",'i').gsub("\u2071",'i')
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
  str=str.gsub("\u1E55",'p').gsub("\u1E57",'p').gsub("\u01A5",'p').gsub("\u2119",'p').gsub("\u1D18",'p').gsub("\u209A",'p').gsub("\u2118",'p')
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

def has_any?(arr1,arr2)
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
  for i in 0...arr1.length
    return true if arr2.include?(arr1[i])
  end
  return false
end

def find_unit(name,event,ignore=false,ignore2=false)
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return -1 if name.nil?
  return -1 if name.length<2 && name.downcase != "bk"
  data_load()
  nicknames_load()
  name=normalize(name.gsub('!',''))
  if name.downcase.gsub(' ','').gsub('_','')[0,2]=="<:"
    name=name.split(':')[1] if find_unit(name.split(':')[1],event,ignore,ignore2)>=0
  end
  unless ignore2
    for i in 0...@names.length
      unless @names[i].nil?
        name=@names[i][1] if @names[i][0].downcase==name.gsub('(','').gsub(')','').downcase && (@names[i][2].nil? || @names[i][2].include?(k))
      end
    end
  end
  j=-1
  name=name.gsub('!','')
  name=name.gsub('(','').gsub(')','').gsub('_','') unless ignore2
  for i in 0...@data.length
    unless @data[i].nil?
      m=@data[i][0]
      m=m.gsub('(','').gsub(')','') unless ignore2
      j=i if m.downcase==name.downcase && j<0
    end
  end
  return j if j>=0 && !@data[j].nil? && has_any?(g, @data[j][22])
  return -1 if ignore || name.downcase=='blade' || name.downcase=='blad' || name.downcase=='bla'
  for i in 0...@data.length
    unless @data[i].nil?
      m=@data[i][0][0,name.length]
      m=m.gsub('(','').gsub(')','') unless ignore2
      j=i if m.downcase==name.downcase && j<0
    end
  end
  return j if j>=0 && !@data[j].nil? && has_any?(g, @data[j][22])
  unless ignore2
    for i in 0...@names.length
      unless @names[i].nil?
        name=@names[i][1] if @names[i][0][0,name.length].downcase==name.downcase && (@names[i][2].nil? || @names[i][2].include?(k)) && find_unit(name,event,true)<0
      end
    end
  end
  data_load()
  for i in 0...@data.length
    unless @data[i].nil?
      m=@data[i][0]
      m=m.gsub('(','').gsub(')','') unless ignore2
      j=i if m.downcase==name.downcase && j<0
    end
  end
  return j if j>=0 && !@data[j].nil? && has_any?(g, @data[j][22])
  return -1
end

def find_skill(name,event,ignore=false,ignore2=false,m=false)
  return find_skill('Recover Ring',event) if name.downcase.gsub(' ','')=='renewal4'
  data_load()
  sklz=@skills.map{|q| q}
  x=x_find_skill(name,event,sklz,ignore,ignore2,m)
  return x if x<0
  return -1 if sklz[x].nil?
  return x if ["weapon","assist","special"].include?(sklz[x][4].downcase) # weapons and such do not need weird calculations
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
    for i in 0...10
      n=n[0,n.length-2] if n[n.length-2,2]=="+#{i}" && name[name.length-2,2]!="+#{i}"
      n=n[0,n.length-1] if n[n.length-1,1]==i.to_s && name[name.length-1,1]!=i.to_s
    end
  end
  return x_find_skill(n,event,sklz) if n[n.length-1,1].to_i.to_s==n[n.length-1,1]
  x2=first_sub(sklz[x][0].reverse,xx.reverse,'').reverse
  x3=[]
  for i in 0...sklz.length
    if sklz[i][0][sklz[i][0].length-1].to_i.to_s==sklz[i][0][sklz[i][0].length-1]
      m2=sklz[i][0].reverse.scan(/\d+/)[0].reverse
      x3.push([i,m2.to_i,sklz[i][0]]) if first_sub(sklz[i][0].reverse,m2.reverse,'').reverse==x2
    end
  end
  x3=x3.sort{|a,b| b[1]<=>a[1]}
  return x3[0][0]
end

def x_find_skill(name,event,sklz,ignore=false,ignore2=false,m=false)
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return -1 if name.nil?
  name=normalize(name.gsub('!','').gsub('.','').gsub('?',''))
  if name.downcase.gsub(' ','').gsub('_','')[0,2]=="<:"
    name=name.split(':')[1] if x_find_skill(name.split(':')[1],event,sklz,ignore,ignore2)>=0
  end
  return find_skill('Bladeblade',event) if name.downcase.gsub(' ','')=='laevatein'
  return find_skill('Uror',event) if name.downcase.gsub(' ','')=='urdr'
  return find_skill('Recover Ring',event) if name.downcase.gsub(' ','')=='renewal4'
  return find_skill("Tannenboom!#{"+" if name.include?('+')}",event) if name.downcase.gsub(' ','').gsub('+','')=='tanenboom'
  return find_skill("Sack o' Gifts#{"+" if name.include?('+')}",event) if name.downcase.gsub(' ','').gsub('+','')=='sackofgifts'
  return find_skill("Killing Edge#{"+" if name.include?('+')}",event) if ['killersword','killeredge','killingsword'].include?(name.downcase.gsub(' ','').gsub('+',''))
  return find_skill("Slaying Edge#{"+" if name.include?('+')}",event) if ['slayersword','slayeredge','slayingsword'].include?(name.downcase.gsub(' ','').gsub('+',''))
  return find_skill(name.downcase.gsub(' ','').gsub('redtome','r tome'),event) if name.downcase.gsub(' ','').include?('redtome')
  return find_skill(name.downcase.gsub(' ','').gsub('bluetome','b tome'),event) if name.downcase.gsub(' ','').include?('bluetome')
  return find_skill(name.downcase.gsub(' ','').gsub('greentome','g tome'),event) if name.downcase.gsub(' ','').include?('greentome')
  return find_skill(name.downcase.gsub('rauor','raudr'),event) if name.downcase.include?('rauor')
  j=-1
  x2=stat_buffs(name.gsub(' ','').gsub('_',''),name)
  for i in 0...sklz.length
    unless sklz[i].nil?
      j=i if stat_buffs(sklz[i][0].gsub('.','').gsub('!',''),name).gsub('?','').gsub(' ','').gsub('_','')==x2 && j<0
    end
  end
  return j if j>=0 && !sklz[j].nil? && has_any?(g, sklz[j][21])
  x2=stat_buffs(name.gsub(' ','').gsub('_','').gsub("'",'').gsub('/','').gsub("-",''),name)
  for i in 0...sklz.length
    unless sklz[i].nil?
      j=i if stat_buffs(sklz[i][0].gsub('.','').gsub('!','').gsub('?','').gsub('/','').gsub("'",'').gsub("-",''),name).gsub(' ','').gsub('_','')==x2 && j<0
    end
  end
  return j if j>=0 && !sklz[j].nil? && has_any?(g, sklz[j][21])
  return -1 if ignore
  return find_skill(name.downcase.gsub('killing','killer'),event,true) if name.downcase.include?('killing') && find_skill(name.downcase.gsub('killing','killer'),event,true)>=0
  return find_skill(name.downcase.gsub('killer','killing'),event,true) if name.downcase.include?('killer') && find_skill(name.downcase.gsub('killer','killing'),event,true)>=0
  return find_skill(name.downcase.gsub('slaying','slayer'),event,true) if name.downcase.include?('slaying') && find_skill(name.downcase.gsub('slaying','slayer'),event,true)>=0
  return find_skill(name.downcase.gsub('slayer','slaying'),event,true) if name.downcase.include?('slayer') && find_skill(name.downcase.gsub('slayer','slaying'),event,true)>=0
  return find_skill(name.downcase.gsub('defence','defense'),event,true) if name.downcase.include?('defence') && find_skill(name.downcase.gsub('defence','defense'),event,true)>=0
  return find_skill(name.downcase.gsub('armour','armor'),event,true) if name.downcase.include?('armour') && find_skill(name.downcase.gsub('armour','armor'),event,true)>=0
  return find_skill(name.downcase.gsub('honour','honor'),event,true) if name.downcase.include?('honour') && find_skill(name.downcase.gsub('honour','honor'),event,true)>=0
  return find_skill(name.downcase.gsub('angery','fury'),event,true) if name.downcase.include?('angery') && find_skill(name.downcase.gsub('angery','fury'),event,true)>=0
  return find_skill(name.downcase.gsub('lnd','lifeanddeath'),event,true) if name.downcase.include?('lnd') && find_skill(name.downcase.gsub('lnd','lifeanddeath'),event,true)>=0
  return find_skill(name.downcase.gsub('l&d','lifeanddeath'),event,true) if name.downcase.include?('lnd') && find_skill(name.downcase.gsub('l&d','lifeanddeath'),event,true)>=0
  return find_skill(name.downcase.gsub('berserker','berserk'),event,true) if name.downcase.include?('berserker') && find_skill(name.downcase.gsub('berserker','berserk'),event,true)>=0
  return -1 if ignore2
  x2=stat_buffs(name.gsub(' ','').gsub('_',''),name)
  for i in 0...sklz.length
    unless sklz[i].nil?
      unless sklz[i][0].nil?
        j=i if stat_buffs(sklz[i][0].gsub('.','').gsub('!','').gsub('?',''),name).gsub(' ','').gsub('_','')[0,name.length]==x2 && j<0
      end
    end
  end
  return j if j>=0 && !sklz[j].nil? && has_any?(g, sklz[j][21])
  return -1 if name.length<4
  namex=name.gsub(' ','').downcase
  return find_skill('Laevatein',event) if namex=='bladeblade'[0,namex.length]
  return find_skill("Sack o' Gifts",event) if namex=='sackofgifts'[0,namex.length]
  return find_skill("Killing Edge",event) if ['killersword','killeredge','killingsword'].map{|q| q[0,namex.length]}.include?(namex)
  return find_skill("Slaying Edge",event) if ['slayersword','slayeredge','slayingsword'].map{|q| q[0,namex.length]}.include?(namex)
  return find_skill(name.downcase.gsub(' ','').gsub('redt','r t'),event) if namex.downcase=='redtome'[0,namex.length]
  return find_skill(name.downcase.gsub(' ','').gsub('bluet','b t'),event) if namex=='bluetome'[0,namex.length]
  return find_skill(name.downcase.gsub(' ','').gsub('greent','g t'),event) if namex=='greentome'[0,namex.length]
  return find_skill(name.downcase.gsub('_',' '),event) if name.include?('_')
  return -1
end

def find_promotions(j,event)
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if j<0
  data_load()
  p=[]
  for i in 0...@skills.length
    p.push(@skills[i][0].gsub('Bladeblade','Laevatein')) if @skills[i][8].include?("*#{@skills[j][0]}*") && has_any?(g, @skills[i][21])
  end
  p=p.sort {|a,b| a.downcase <=> b.downcase}
  p=p.reject{|q| q[1,10]=="Falchion ("}
  return p
end

def find_prevolutions(j,event)
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if j<0
  data_load()
  p=[]
  for i in 0...@skills.length
    unless @skills[i][22].nil?
      k=@skills[i][22].split(', ')
      for i2 in 0...k.length
        if k[i2].include?('!')
          z=k[i2].split('!')
          z2=@skills[i].map{|q| q}
          for i3 in 14...19
            if z2[i3].include?(z[0])
              z2[i3]=z[0]
            else
              z2[i3]="-"
            end
          end
          p.push([z2,"but only when on"]) if z[1]==@skills[j][0] && has_any?(g, @skills[i][21])
        else
          p.push([@skills[i],"which is learned by"]) if k[i2]==@skills[j][0] && has_any?(g, @skills[i][21])
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

def find_effect_name(x,event,shorten=0)
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return [] if x.nil?
  data_load()
  p=[]
  f=""
  for i in 0...@skills.length
    unless @skills[i][4]=="Weapon" || @skills[i][20].nil? || @skills[i][20]==''
      f=@skills[i][0] if ", #{@skills[i][20]},".include?(", #{x[0]},") && has_any?(g, @skills[i][21])
    end
  end
  if f.length>0 && shorten==0
    f=f.split(' ')
    f[f.length-1]=nil if f[f.length-1].length<2
    f.compact!
    f=f.join(' ')
  elsif f.length>0 && shorten==2
    f=f.split(' ')
    f[f.length-1]="W" if f[f.length-1].length<2
    f=f.join(' ')
  end
  return f
end

def find_weapon(name,event,ignore=false,ignore2=false)
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  return -1 if name.nil?
  return -1 if name.gsub(' ','').length<=3
  name=normalize(name.gsub('!',''))
  unless ignore2
    return find_weapon('Bladeblade',event) if name.downcase=='laevatein'
    return find_weapon('Uror',event) if name.downcase=='urdr'
    return find_weapon("Sack o' Gifts#{"+" if name.include?('+')}",event) if name.downcase.gsub(' ','').gsub('+','')=='sackofgifts'
    return find_weapon("Killing Edge#{"+" if name.include?('+')}",event) if ['killersword','killeredge','killingsword'].include?(name.downcase.gsub(' ','').gsub('+',''))
    return find_weapon("Slaying Edge#{"+" if name.include?('+')}",event) if ['slayersword','slayeredge','slayingsword'].include?(name.downcase.gsub(' ','').gsub('+',''))
    return find_weapon(name.downcase.gsub('rauor','raudr'),event) if name.downcase.include?('rauor')
  end
  j=-1
  data_load()
  for i in 0...@skills.length
    unless @skills[i].nil?
      j=i if @skills[i][0].downcase==name.downcase && j<0 && @skills[i][4]=="Weapon"
    end
  end
  return j if j>=0 && has_any?(g, @skills[j][21])
  return -1 if ignore2
  for i in 0...@skills.length
    unless @skills[i].nil?
      j=i if @skills[i][0].downcase.gsub(' ','').gsub('/','').gsub("'",'')==name.downcase.gsub(' ','').gsub("'",'') && j<0 && @skills[i][4]=="Weapon"
    end
  end
  return j if j>=0 && has_any?(g, @skills[j][21])
  return -1 if ignore
  return find_weapon(name.downcase.gsub('berserker','berserk'),event,true) if name.downcase.include?('berserker') && find_weapon(name.downcase.gsub('berserker','berserk'),event,true)>=0
  return find_weapon(name.downcase.gsub('killing','killer'),event,true) if name.downcase.include?('killing') && find_weapon(name.downcase.gsub('killing','killer'),event,true)>=0
  return find_weapon(name.downcase.gsub('killer','killing'),event,true) if name.downcase.include?('killer') && find_weapon(name.downcase.gsub('killer','killing'),event,true)>=0
  return find_weapon(name.downcase.gsub('slaying','slayer'),event,true) if name.downcase.include?('slaying') && find_weapon(name.downcase.gsub('slaying','slayer'),event,true)>=0
  return find_weapon(name.downcase.gsub('slayer','slaying'),event,true) if name.downcase.include?('slayer') && find_weapon(name.downcase.gsub('slayer','slaying'),event,true)>=0
  for i in 0...@skills.length
    unless @skills[i].nil? || @skills[i][0].nil?
      j=i if @skills[i][0][0,name.length].downcase==name.downcase && j<0 && @skills[i][4]=="Weapon"
    end
  end
  return j if j>=0 && has_any?(g, @skills[j][21])
  for i in 0...@skills.length
    unless @skills[i].nil? || @skills[i][0].nil?
      j=i if @skills[i][0][0,name.length].downcase.gsub(' ','').gsub('/','').gsub("'",'')==name.downcase.gsub(' ','').gsub("'",'') && j<0 && @skills[i][4]=="Weapon"
    end
  end
  return j if j>=0 && has_any?(g, @skills[j][21])
  return -1
end

def get_weapon(str,event)
  return nil if str.gsub(' ','').length<=0
  args=str.split(' ')
  args2=args.join(' ').split(' ')
  args4=args.join(' ').split(' ')
  name=args.join(' ')
  args3=args.join(' ').split(' ')
  if find_weapon(name,event)<0
    for i in 0...args.length-1
      args[args.length-1]=nil
      args.compact!
      if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event,true)>=0
        args3=args.join(' ').split(' ') 
        name=@skills[find_weapon(args.join('').downcase,event,true)][0]
      end
    end
    if find_weapon(name,event)<0
      for j in 0...args2.length-1
        args2[0]=nil
        args2.compact!
        args=args2.join(' ').split(' ')
        if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event,true)>=0
          args3=args.join(' ').split(' ') 
          name=@skills[find_weapon(args.join('').downcase,event,true)][0]
        end
        for i in 0...args.length-1
          args[args.length-1]=nil
          args.compact!
          if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event,true)>=0
            args3=args.join(' ').split(' ') 
            name=@skills[find_weapon(args.join('').downcase,event,true)][0]
          end
        end
      end
    end
  end
  args2=args4.join(' ').split(' ')
  if find_weapon(name,event)<0
    for i in 0...args.length-1
      args[args.length-1]=nil
      args.compact!
      if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event)>=0
        args3=args.join(' ').split(' ') 
        name=@skills[find_weapon(args.join('').downcase,event)][0]
      end
    end
    if find_weapon(name,event)<0
      for j in 0...args2.length-1
        args2[0]=nil
        args2.compact!
        args=args2.join(' ').split(' ')
        if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event)>=0
          args3=args.join(' ').split(' ') 
          name=@skills[find_weapon(args.join('').downcase,event)][0]
        end
        for i in 0...args.length-1
          args[args.length-1]=nil
          args.compact!
          if find_weapon(name,event)<0 && find_weapon(args.join('').downcase,event)>=0
            args3=args.join(' ').split(' ') 
            name=@skills[find_weapon(args.join('').downcase,event)][0]
          end
        end
      end
    end
  end
  return [@skills[find_weapon(name,event)][0],args3.join(' ')] if find_weapon(name,event)>-1
  return nil
end

def find_in_dev_units(name)
  return -1 if name.nil?
  devunits_load()
  j=-1
  for i in 0...@dev_units.length
    j=i if @dev_units[i][0].downcase==name.downcase && j<0
  end
  return j if j>-1
  for i in 0...@dev_units.length
    j=i if @dev_units[i][0][0,name.length].downcase==name.downcase && j<0
  end
  return j if j>-1
  return -1
end

def stat_buffs(str,name=nil)
  name=str.split(' ').join(' ') if name.nil?
  x=str.downcase.gsub('/',' ').gsub('+',' +').gsub('  ',' ')
  x=x.gsub('hone','hone ').gsub('fortify','fortify ').gsub('goad','goad ').gsub('ward','ward ')
  x=x.split(' ')
  for i in 0...x.length
    x[i]='hp' if ['health'].include?(x[i])
    x[i]='attack' if ['atk','att'].include?(x[i])
    x[i]='speed' if ['spd'].include?(x[i])
    x[i]='defense' if ['def','defence'].include?(x[i])
    x[i]='resistance' if ['res'].include?(x[i])
  end
  for i in 0...x.length-1
    x[i]='fortify' if ['hone'].include?(x[i]) && ['defense','resistance'].include?(x[i+1])
    x[i]='hone' if ['fortify'].include?(x[i]) && ['attack','speed'].include?(x[i+1])
  end
  n=x.join('')
  nn=name.reverse.scan(/\d+/)[0]
  nn=' ' if nn.nil?
  for i in 0...nn.length
    for i in 0...10
      n=n[0,n.length-2] if n[n.length-2,2]=="+#{i}" && name[name.length-2,2]!="+#{i}"
      n=n[0,n.length-1] if n[n.length-1,1]==i.to_s && name[name.length-1,1]!=i.to_s
    end
  end
  return n
end

def find_group(name,event)
  k=0
  k=event.server.id unless event.server.nil?
  groups_load()
  j=-1
  for i in 0...@groups.length
    j=i if @groups[i][0].downcase==name.downcase && (@groups[i][2].nil? || @groups[i][2].include?(k))
  end
  return j if j>=0
  for i in 0...@groups.length
    j=i if @groups[i][0][0,name.length].downcase==name.downcase && (@groups[i][2].nil? || @groups[i][2].include?(k))
  end
  return j if j>=0
  return -1
end

def was_embedless_mentioned?(event)
  for i in 0...@embedless.length
    return true if event.message.text.include?("<@#{@embedless[i].to_s}>")
    return true if event.message.text.include?("<@!#{@embedless[i].to_s}>")
  end
  return false
end

def create_embed(event,header,text,xcolor=nil,xfooter=nil,xpic=nil,xfields=nil,mode=0)
  ftrlnth=0
  ftrlnth=xfooter.length unless xfooter.nil?
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    if header.length>0
      if header.include?('*') || header.include?('_')
        event << header
      else
        event << "__**#{header.gsub('!','')}**__"
      end
    end
    event << ""
    event << text
    unless xfields.nil?
      if mode==0
        event << ""
        for i in 0...xfields.length
          event << "__#{xfields[i][0]}:__ #{xfields[i][1].gsub("\n"," / ")}"
        end
      elsif [-1,1].include?(mode)
        if mode==-1
          last_field=xfields[xfields.length-1][1].split("\n").join("\n")
          last_field_name=xfields[xfields.length-1][0].split("\n").join("\n")
          xfields[xfields.length-1]=nil
          xfields.compact!
        end
        atk=xfields[0][1].split("\n")[1].split(": ")[0]
        statnames=["HP: ","#{atk}: ","Speed: ","Defense: ","Resistance: ","BST: "]
        fields=[[],["__**HP:**__"],["__**#{atk}:**__"],["__**Speed:**__"],["__**Defense:**__"],["__**Resistance:**__"],["__**BST:**__"]]
        for i in 0...xfields.length
          fields[0].push(xfields[i][0])
          flumb=xfields[i][1].split("\n")
          flumb[5]=nil
          flumb.compact!
          for j in 0...flumb.length
            if i==0
              fields[j+1][0]="#{fields[j+1][0]}	#{flumb[j].gsub(statnames[j],"").gsub("GPT: ","")}"
            else
              fields[j+1].push(flumb[j].gsub(statnames[j],"").gsub("GPT: ",""))
            end
          end
        end
        event << ""
        for i in 0...fields.length
          event << fields[i].join(' / ')
        end
        if mode==-1
          event << ""
          event << "__**#{last_field_name.gsub("**",'')}**__"
          event << last_field
        end
      elsif mode==3
        for i in 0...xfields.length
          event << "__#{xfields[i][0]}:__ #{xfields[i][1].gsub("\n",", ")}"
        end
      elsif mode==4
        for i in 0...xfields.length
          event << "**#{xfields[i][0]}:** #{xfields[i][1].gsub("\n",", ")}"
        end
      else
        for i in 0...xfields.length
          event << ""
          event << xfields[i][0]
          event << xfields[i][1]
        end
      end
    end
    event << "" unless xfooter.nil?
    event << xfooter unless xfooter.nil?
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
          embed.add_field(name: xfields[i][0], value: xfields[i][1], inline: true)
        end
      end
    end
  else
    event.channel.send_embed(header) do |embed|
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0], value: xfields[i][1], inline: true)
        end
      end
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil?
    end
  end
  return nil
end

def find_name_in_string(event,stringx=nil,mode=0)
  data_load()
  stringx=event.message.text if stringx.nil?
  s=stringx
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(stringx.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(stringx.downcase[0,4])
  a=s.split(' ')
  s=stringx if all_commands().include?(a[0])
  args=sever(s,true).split(" ")
  args2=sever(s,true).split(" ")
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
  if all_commands().include?(a[0])
    args[0]=nil
    args.compact!
  end
  args2=args.join(' ').split(' ')
  args4=args.join(' ').split(' ')
  name=args.join('')
  data_load()
  # Find the most accurate unit name among the remaining inputs
  if find_unit(name,event)>=0
    args3=args.join(' ').split(' ')
    name=@data[find_unit(name,event)][0]
    if name=="Robin(M)" || name=="Robin(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['robin','reflet','daraen'].include?(args3[0].downcase)
          name="Robin"
        else
          name=args3[0]
        end
      end
    elsif name=="Morgan(M)" || name=="Morgan(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['morgan','marc','linfan'].include?(args3[0].downcase)
          name="Morgan"
        else
          name=args3[0]
        end
      end
    elsif name=="Kana(M)" || name=="Kana(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['kana','kanna'].include?(args3[0].downcase)
          name="Kana"
        else
          name=args3[0]
        end
      end
    elsif name=="Corrin(M)" || name=="Corrin(F)"
      name=args3[0] if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
    elsif name=="Tiki(Young)" || name=="Tiki(Adult)"
      if args3.length==1
        if ['tiki','chiki'].include?(args3[0].downcase)
          name="Tiki"
        else
          name=args3[0]
        end
      end
    elsif name=="Eirika(Bonds)" || name=="Eirika(Memories)"
      if args3.length==1
        if ['eirika','eirik','eiriku','erika'].include?(args3[0].downcase)
          name="Eirika"
        else
          name=args3[0]
        end
      end
    elsif name=="Hinoka(Launch)" || name=="Hinoka(Wings)"
      if args3.length==1
        if ['hinoka'].include?(args3[0].downcase)
          name="Hinoka"
        else
          name=args3[0]
        end
      end
    elsif name=="Chrom(Launch)" || name=="Chrom(Branded)"
      if args3.length==1
        if ['chrom'].include?(args3[0].downcase)
          name="Chrom"
        else
          name=args3[0]
        end
      end
    elsif name=="Reinhardt(Bonds)" || name=="Reinhardt(World)"
      if args3.length==1
        if ['reinhardt','rainharuto'].include?(args3[0].downcase)
          name="Reinhardt"
        else
          name=args3[0]
        end
      end
    elsif name=="Olwen(Bonds)" || name=="Olwen(World)"
      if args3.length==1
        if ['olwen','oruen'].include?(args3[0].downcase)
          name="Olwen"
        else
          name=args3[0]
        end
      end
    end
  else
    for i in 0...args.length-1
      args[args.length-1]=nil
      args.compact!
      if find_unit(name,event)<0 && find_unit(args.join('').downcase,event,true)>=0
        args3=args.join(' ').split(' ') 
        name=@data[find_unit(args.join('').downcase,event,true)][0]
      end
    end
    if find_unit(name,event)<0
      for j in 0...args2.length-1
        args2[0]=nil
        args2.compact!
        args=args2.join(' ').split(' ')
        if find_unit(name,event)<0 && find_unit(args.join('').downcase,event,true)>=0
          args3=args.join(' ').split(' ') 
          name=@data[find_unit(args.join('').downcase,event,true)][0]
        end
        for i in 0...args.length-1
          args[args.length-1]=nil
          args.compact!
          if find_unit(name,event)<0 && find_unit(args.join('').downcase,event,true)>=0
            args3=args.join(' ').split(' ') 
            name=@data[find_unit(args.join('').downcase,event,true)][0]
          end
        end
      end
    end
    if name=="Robin(M)" || name=="Robin(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['robin','reflet','daraen'].include?(args3[0].downcase)
          name="Robin"
        else
          name=args3[0]
        end
      end
    elsif name=="Morgan(M)" || name=="Morgan(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['morgan','marc','linfan'].include?(args3[0].downcase)
          name="Morgan"
        else
          name=args3[0]
        end
      end
    elsif name=="Kana(M)" || name=="Kana(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['kana','kanna'].include?(args3[0].downcase)
          name="Kana"
        else
          name=args3[0]
        end
      end
    elsif name=="Corrin(M)" || name=="Corrin(F)"
      name=args3[0] if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
    elsif name=="Tiki(Young)" || name=="Tiki(Adult)"
      if args3.length==1
        if ['tiki','chiki'].include?(args3[0].downcase)
          name="Tiki"
        else
          name=args3[0]
        end
      end
    elsif name=="Eirika(Bonds)" || name=="Eirika(Memories)"
      if args3.length==1
        if ['eirika','eirik','eiriku','erika'].include?(args3[0].downcase)
          name="Eirika"
        else
          name=args3[0]
        end
      end
    elsif name=="Hinoka(Launch)" || name=="Hinoka(Wings)"
      if args3.length==1
        if ['hinoka'].include?(args3[0].downcase)
          name="Hinoka"
        else
          name=args3[0]
        end
      end
    elsif name=="Chrom(Launch)" || name=="Chrom(Branded)"
      if args3.length==1
        if ['chrom'].include?(args3[0].downcase)
          name="Chrom"
        else
          name=args3[0]
        end
      end
    elsif name=="Reinhardt(Bonds)" || name=="Reinhardt(World)"
      if args3.length==1
        if ['reinhardt','rainharuto'].include?(args3[0].downcase)
          name="Reinhardt"
        else
          name=args3[0]
        end
      end
    elsif name=="Olwen(Bonds)" || name=="Olwen(World)"
      if args3.length==1
        if ['olwen','oruen'].include?(args3[0].downcase)
          name="Olwen"
        else
          name=args3[0]
        end
      end
    end
  end
  args2=args4.join(' ').split(' ')
  if find_unit(name,event)<0
    for i in 0...args.length-1
      args[args.length-1]=nil
      args.compact!
      if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
        args3=args.join(' ').split(' ') 
        name=@data[find_unit(args.join('').downcase,event)][0]
      end
    end
    if find_unit(name,event)<0
      for j in 0...args2.length-1
        args2[0]=nil
        args2.compact!
        args=args2.join(' ').split(' ')
        if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
          args3=args.join(' ').split(' ') 
          name=@data[find_unit(args.join('').downcase,event)][0]
        end
        for i in 0...args.length-1
          args[args.length-1]=nil
          args.compact!
          if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
            args3=args.join(' ').split(' ') 
            name=@data[find_unit(args.join('').downcase,event)][0]
          end
        end
      end
    end
    if name=="Robin(M)" || name=="Robin(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['robin','reflet','daraen'].include?(args3[0].downcase)
          name="Robin"
        else
          name=args3[0]
        end
      end
    elsif name=="Morgan(M)" || name=="Morgan(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['morgan','marc','linfan'].include?(args3[0].downcase)
          name="Morgan"
        else
          name=args3[0]
        end
      end
    elsif name=="Kana(M)" || name=="Kana(F)"
      if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
        if ['kana','kanna'].include?(args3[0].downcase)
          name="Kana"
        else
          name=args3[0]
        end
      end
    elsif name=="Corrin(M)" || name=="Corrin(F)"
      name=args3[0] if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
    elsif name=="Tiki(Young)" || name=="Tiki(Adult)"
      if args3.length==1
        if ['tiki','chiki'].include?(args3[0].downcase)
          name="Tiki"
        else
          name=args3[0]
        end
      end
    elsif name=="Eirika(Bonds)" || name=="Eirika(Memories)"
      if args3.length==1
        if ['eirika','eirik','eiriku','erika'].include?(args3[0].downcase)
          name="Eirika"
        else
          name=args3[0]
        end
      end
    elsif name=="Hinoka(Launch)" || name=="Hinoka(Wings)"
      if args3.length==1
        if ['hinoka'].include?(args3[0].downcase)
          name="Hinoka"
        else
          name=args3[0]
        end
      end
    elsif name=="Chrom(Launch)" || name=="Chrom(Branded)"
      if args3.length==1
        if ['chrom'].include?(args3[0].downcase)
          name="Chrom"
        else
          name=args3[0]
        end
      end
    elsif name=="Reinhardt(Bonds)" || name=="Reinhardt(World)"
      if args3.length==1
        if ['reinhardt','rainharuto'].include?(args3[0].downcase)
          name="Reinhardt"
        else
          name=args3[0]
        end
      end
    elsif name=="Olwen(Bonds)" || name=="Olwen(World)"
      if args3.length==1
        if ['olwen','oruen'].include?(args3[0].downcase)
          name="Olwen"
        else
          name=args3[0]
        end
      end
    end
  end
  return nil if args3.nil?
  return [name,args3.join(' ')] if mode==1
  return name
end

def find_stats_in_string(event,stringx=nil,mode=0)
  stringx=event.message.text if stringx.nil?
  s=stringx
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(stringx.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(stringx.downcase[0,4])
  a=s.split(' ')
  s=stringx if all_commands().include?(a[0])
  s=(first_sub(s,find_name_in_string(event,s,1)[1],'') rescue s) unless s.downcase=='laevatein' || s.downcase.include?('blucina') || s.downcase.include?('bluecina') || s.downcase.include?('blyn') || s.downcase.include?('brlyn') || s.downcase.include?('axeura') || s.downcase.include?('axura') || s.downcase.include?('axezura') || s.downcase.include?('axzura') || s.downcase.include?('axe-ura') || s.downcase.include?('ax-ura') || s.downcase.include?('axe-zura') || s.downcase.include?('ax-zura') || s.downcase.include?('corrin') || s.downcase.include?('robin') || s.downcase.include?('kamui') || s.downcase.include?('tiki') || s.downcase.include?('chiki') || s.downcase.include?('reflet') || s.downcase.include?('daraen') || s.downcase.include?('eirika') || s.downcase.include?('eirik') || s.downcase.include?('eiriku') || s.downcase.include?('erika') || s.downcase.include?('morgan') || s.downcase.include?('marc') || s.downcase.include?('linfan') || s.downcase.include?('grima') || s.downcase.include?('kana') || s.downcase.include?('kanna') || s.downcase.include?('hinoka') || s.downcase.include?('chrom')
  args=sever(s,true).split(" ")
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  merges=nil
  rarity=nil
  boon=nil
  bane=nil
  summoner=nil
  refinement=nil
  blessing=[]
  cornatures=[["HP","Robust","Sickly"],
              ["Attack","Strong","Weak"],
              ["Attack","Clever","Dull"],
              ["Speed","Quick","Sluggish"],
              ["Defense","Sturdy","Fragile"],
              ["Resistance","Calm","Excitable"]]
  # first pass through inputs, searching for anything that has self-contained context clues as for what variable it should fill
  for i in 0...args.length
    for j in 0...cornatures.length
      if args[i].downcase==cornatures[j][1].downcase
        args[i]="+#{cornatures[j][0]}"
      elsif args[i].downcase==cornatures[j][2].downcase
        args[i]="-#{cornatures[j][0]}"
      end
    end
    if args[i].downcase=='s'
      summoner='S' if summoner.nil?
    elsif args[i].downcase=='a'
      summoner='A' if summoner.nil?
    elsif args[i].downcase=='b'
      summoner='B' if summoner.nil?
    elsif args[i].downcase=='c'
      summoner='C' if summoner.nil?
    end
    if args[i][0,1]=="+"
      x=args[i][1,args[i].length-1]
      if x.to_i.to_s==x && merges.nil? # numbers preceeded by a plus sign automatically fill the merges variable
        merges=x.to_i
        args[i]=nil
      else # stat names preceeded by a plus sign automatically fill the boon variable
        x="HP" if ["hp","health"].include?(x.downcase)
        x="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(x.downcase)
        x="Speed" if ["spd","speed"].include?(x.downcase)
        x="Defense" if ["defense","def","defence"].include?(x.downcase)
        x="Resistance" if ["res","resistance"].include?(x.downcase)
        if ["HP","Attack","Speed","Defense","Resistance"].include?(x) && boon.nil?
          boon=x
          args[i]=nil
        end
      end
    elsif args[i][0,3]=="(+)" # stat names preceeded by a plus sign in parentheses automatically fill the refinement variable
      x=args[i][3,args[i].length-3]
      x="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(x.downcase)
      x="Speed" if ["spd","speed"].include?(x.downcase)
      x="Defense" if ["defense","def","defence"].include?(x.downcase)
      x="Resistance" if ["res","resistance"].include?(x.downcase)
      if ["Attack","Speed","Defense","Resistance"].include?(x)
        refinement=x if refinement.nil?
        args[i]=nil
      end
    elsif args[i][0,1]=="(" && args[i][args[i].length-1,1]==")"
      x=args[i][1,args[i].length-2]
      x="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(x.downcase)
      x="Speed" if ["spd","speed"].include?(x.downcase)
      x="Defense" if ["defense","def","defence"].include?(x.downcase)
      x="Resistance" if ["res","resistance"].include?(x.downcase)
      x="Effect" if ["effect","special"].include?(x.downcase)
      x="Wrathful" if ["wrazzle","wrathful"].include?(x.downcase)
      x="Dazzling" if ["dazzle","dazzling"].include?(x.downcase)
      if ["Attack","Speed","Defense","Resistance","Effect","Wrathful","Dazzling"].include?(x)
        refinement=x if refinement.nil?
        args[i]=nil
      end
    elsif args[i][0,1]=="-" # stat names preceeded by a minus sign automatically fill the bane variable
      x=args[i][1,args[i].length-1]
      x="HP" if ["hp","health"].include?(x.downcase)
      x="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(x.downcase)
      x="Speed" if ["spd","speed"].include?(x.downcase)
      x="Defense" if ["defense","def","defence"].include?(x.downcase)
      x="Resistance" if ["res","resistance"].include?(x.downcase)
      if ["HP","Attack","Speed","Defense","Resistance"].include?(x) && bane.nil?
        bane=x
        args[i]=nil
      end
    elsif args[i][args[i].length-1,1]=="*" # numbers followed by an asterisk automatically fill the rarity variable
      x=args[i][0,args[i].length-1]
      if x.to_i.to_s==x && rarity.nil?
        rarity=x.to_i
        args[i]=nil
      end
    elsif args[i].length>5 && args[i][args[i].length-4,4].downcase=="-star" # numbers followed by the word "star" automatically fill the rarity variable
      x=args[i][0,args[i].length-4]
      if x.to_i.to_s==x && rarity.nil?
        rarity=x.to_i
        args[i]=nil
      end
    elsif !find_nature(args[i]).nil? && (boon.nil? || bane.nil?) # Certain Pokemon nature names will fill both the boon and bane variables
      boon=find_nature(args[i])[1] if boon.nil?
      bane=find_nature(args[i])[2] if bane.nil?
      args[i]=nil
    end
    if i>0 && !args[i-1].nil? && !args[i].nil?
      x=args[i-1]
      x="HP" if ["hp","health"].include?(x.downcase)
      x="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(x.downcase)
      x="Speed" if ["spd","speed"].include?(x.downcase)
      x="Defense" if ["defense","def","defence"].include?(x.downcase)
      x="Resistance" if ["res","resistance"].include?(x.downcase)
      y=args[i]
      y="HP" if ["hp","health"].include?(y.downcase)
      y="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(y.downcase)
      y="Speed" if ["spd","speed"].include?(y.downcase)
      y="Defense" if ["defense","def","defence"].include?(y.downcase)
      y="Resistance" if ["res","resistance"].include?(y.downcase)
      if args[i].downcase=="star" && args[i-1].to_i.to_s==args[i-1] && rarity.nil?
        # the word "star", if preceeded by a number, will automatically fill the rarity variable with that number
        rarity=args[i-1].to_i
        args[i]=nil
        args[i-1]=nil
      elsif args[i].downcase=="mode" && ["Attack","Speed","Defense","Resistance"].include?(x) && refinement.nil?
        # the word "mode", if preceeded by a stat name other than HP, will turn that stat into the refinement of the weapon the unit is equipping
        refinement=x
        args[i]=nil
        args[i-1]=nil
      elsif args[i].downcase=="blessing" && ["Attack","Speed","Defense","Resistance"].include?(x)
        # the word "blessing", if preceeded by a stat name other than HP, will turn that stat into a blessing to be applied to the character
        blessing.push(x)
        args[i]=nil
        args[i-1]=nil
      elsif args[i-1].downcase=="(+)" && ["Attack","Speed","Defense","Resistance"].include?(y) && refinement.nil?
        # the character arrangement "(+)", if followed by a stat name other than HP, will turn that stat into the refinement of the weapon the unit is equipping
        refinement=y
        args[i]=nil
        args[i-1]=nil
      elsif args[i-1].downcase=="plus" && ["HP","Attack","Speed","Defense","Resistance"].include?(y) && boon.nil?
        # the word "plus", if followed by a stat name, will turn that stat into the unit's boon
        boon=y
        args[i]=nil
        args[i-1]=nil
      elsif args[i-1].downcase=="minus" && ["HP","Attack","Speed","Defense","Resistance"].include?(y) && bane.nil?
        # the word "minus", if followed by a stat name, will turn that stat into the unit's bane
        bane=y
        args[i]=nil
        args[i-1]=nil
      elsif args[i].downcase=="boon" && ["HP","Attack","Speed","Defense","Resistance"].include?(x) && boon.nil?
        # the word "boon", if preceeded by a stat name, will turn that stat into the unit's boon
        boon=x
        args[i]=nil
        args[i-1]=nil
      elsif args[i].downcase=="bane" && ["HP","Attack","Speed","Defense","Resistance"].include?(x) && bane.nil?
        # the word "minus", if preceeded by a stat name, will turn that stat into the unit's bane
        bane=x
        args[i]=nil
        args[i-1]=nil
      end
    end
    unless args[i].nil?
      refinement="Effect" if ["effect","special"].include?(args[i].downcase) && refinement.nil?
      refinement="Wrathful" if ["wrazzle","wrathful"].include?(args[i].downcase) && refinement.nil?
      refinement="Dazzling" if ["dazzle","dazzling"].include?(args[i].downcase) && refinement.nil?
    end
  end
  args.compact!
  # second pass through arguments, literally only searching for remaining stats with a plus sign in front of them
  # applicable moments will fill the refinement variable if empty
  if refinement.nil?
    for i in 0...args.length
      if args[i][0,1]=="+"
        x=args[i][1,args[i].length-1]
        x="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(x.downcase)
        x="Speed" if ["spd","speed"].include?(x.downcase)
        x="Defense" if ["defense","def","defence"].include?(x.downcase)
        x="Resistance" if ["res","resistance"].include?(x.downcase)
        if ["HP","Attack","Speed","Defense","Resistance"].include?(x) && refinement.nil?
          refinement=x
          args[i]=nil
        end
      end
      if i>0 && !args[i-1].nil? && !args[i].nil?
        x=args[i-1]
        x="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(x.downcase)
        x="Speed" if ["spd","speed"].include?(x.downcase)
        x="Defense" if ["defense","def","defence"].include?(x.downcase)
        x="Resistance" if ["res","resistance"].include?(x.downcase)
        y=args[i]
        y="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(y.downcase)
        y="Speed" if ["spd","speed"].include?(y.downcase)
        y="Defense" if ["defense","def","defence"].include?(y.downcase)
        y="Resistance" if ["res","resistance"].include?(y.downcase)
        if args[i-1].downcase=="plus" && ["Attack","Speed","Defense","Resistance"].include?(y) && refinement.nil?
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
    x=args[i]
    x="HP" if ["hp","health"].include?(x.downcase)
    x="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(x.downcase)
    x="Speed" if ["spd","speed"].include?(x.downcase)
    x="Defense" if ["defense","def","defence"].include?(x.downcase)
    x="Resistance" if ["res","resistance"].include?(x.downcase)
    if x.to_i.to_s==x
      x=x.to_i
      if x<0 || x>10
      elsif rarity.nil? && !x.zero? && x<@mods[0].length
        rarity=x
        args[i]=nil
      elsif merges.nil?
        merges=x
        args[i]=nil
      end
    elsif ["HP","Attack","Speed","Defense","Resistance"].include?(x)
      if boon.nil?
        boon=x
        args[i]=nil
      elsif bane.nil?
        bane=x
        args[i]=nil
      elsif refinement.nil? && x != "HP"
        refinement=x
        args[i]=nil
      end
    end
  end
  args.compact!
  unless mode==1
    rarity=5 if rarity.nil?
    merges=0 if merges.nil?
    boon='' if boon.nil?
    bane='' if bane.nil?
    summoner='-' if summoner.nil?
    refinement='' if refinement.nil?
  end
  return [rarity,merges,boon,bane,summoner,refinement,blessing]
end

def apply_stat_skills(event,skillls,stats,tempest=false,summoner='-',weapon='',refinement='',blessing=[])
  k=0
  k=event.server.id unless event.server.nil?
  skillls=skillls.map{|q| q}
  if weapon.nil?
  elsif weapon=='' || weapon==' ' || weapon=='-'
  else
    s2=@skills[find_skill(weapon,event)]
    if !s2[23].nil? && !refinement.nil? && refinement.length>0 && s2[5]!="Staff Users Only"
      skillls.push(find_effect_name(s2,event,1)) if refinement=='Effect' && find_effect_name(s2,event,1).length>0
      sttz=[]
      inner_skill=s2[23]
      mt=0
      mt=1 if s2[7]=="-" || s2[5]=="Dragons Only"
      if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
        mt+=inner_skill[0,1].to_i
      elsif inner_skill[0,1]=='-' && inner_skill.length>1
        mt-=inner_skill[1,1].to_i
      end
      if s2[5].include?("Tome Users Only") || ["Bow Users Only","Dagger Users Only"].include?(s2[5])
        sttz.push([0,0,0,0,0,"Effect"]) if inner_skill.length>1
        sttzx=[[2,1,0,0,0,"Attack"],[2,0,2,0,0,"Speed"],[2,0,0,3,0,"Defense"],[2,0,0,0,3,"Resistance"]]
      else
        sttz.push([3,0,0,0,0,"Effect"]) if inner_skill.length>1
        sttzx=[[5,2,0,0,0,"Attack"],[5,0,3,0,0,"Speed"],[5,0,0,4,0,"Defense"],[5,0,0,0,4,"Resistance"]]
      end
      for i in 0...sttzx.length
        sttz.push(sttzx[i])
      end
      for i in 0...sttz.length
        sttz[i][1]+=mt
      end
      sttz.push([0,0,0,0,0,"unrefined"])
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
    stats[1]+=sttz[ks][0]
    stats[2]+=s2[20][1]+sttz[ks][1]
    stats[3]+=s2[20][2]+sttz[ks][2]
    stats[4]+=s2[20][3]+sttz[ks][3]
    stats[5]+=s2[20][4]+sttz[ks][4]
  end
  for i in 0...skillls.length
    stats[1]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,4]=="HP +"
    stats[2]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,8]=="Attack +"
    stats[3]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,7]=="Speed +"
    stats[4]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,9]=="Defense +"
    stats[5]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,12]=="Resistance +"
    if ["HP Atk ","HP Spd ","HP Def ","HP Res "].include?(skillls[i].gsub('/',' ').gsub('+','')[0,7])
      stats[1]+=skillls[i].scan(/\d+?/)[0].to_i+2
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,7].include?("Atk")
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,7].include?("Spd")
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,7].include?("Def")
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,7].include?("Res")
    end
    if ["Attack Spd ","Attack Def ","Attack Res "].include?(skillls[i].gsub('/',' ').gsub('+','')[0,11])
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,11].include?("Spd")
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,11].include?("Def")
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,11].include?("Res")
    end
    if ["Atk Spd ","Atk Def ","Atk Res ","Spd Def ","Spd Res ","Def Res "].include?(skillls[i].gsub('/',' ').gsub('+','')[0,8])
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,8].include?("Atk")
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,8].include?("Spd")
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,8].include?("Def")
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i if skillls[i][0,8].include?("Res")
    end
    if skillls[i][0,5]=="Fury "
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i
    end
    if skillls[i][0,15]=="Life and Death " || skillls[i][0,15]=="Life And Death "
      stats[2]+=(skillls[i].scan(/\d+?/)[0].to_i+2)
      stats[3]+=(skillls[i].scan(/\d+?/)[0].to_i+2)
      stats[4]-=(skillls[i].scan(/\d+?/)[0].to_i+2)
      stats[5]-=(skillls[i].scan(/\d+?/)[0].to_i+2)
    end
    stats[2]+=(2*skillls[i].scan(/\d+?/)[0].to_i) if skillls[i][0,14]=="Attack Tactic "
    stats[2]+=(2*skillls[i].scan(/\d+?/)[0].to_i) if skillls[i][0,13]=="Speed Tactic "
    stats[2]+=(2*skillls[i].scan(/\d+?/)[0].to_i) if skillls[i][0,15]=="Defense Tactic "
    stats[2]+=(2*skillls[i].scan(/\d+?/)[0].to_i) if skillls[i][0,18]=="Resistance Tactic "
    stats[2]+=(skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,12]=="Hone Attack "
    stats[3]+=(skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,11]=="Hone Speed "
    stats[4]+=(skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,16]=="Fortify Defense "
    stats[5]+=(skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,19]=="Fortify Resistance "
    stats[4]+=(skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,12]=="Fortify Def "
    stats[5]+=(skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,12]=="Fortify Res "
    stats[2]+=(2*skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,15]=="Defiant Attack "
    stats[3]+=(2*skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,14]=="Defiant Speed "
    stats[4]+=(2*skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,16]=="Defiant Defense "
    stats[5]+=(2*skillls[i].scan(/\d+?/)[0].to_i+1) if skillls[i][0,19]=="Defiant Resistance "
    if skillls[i]=="Hone Movement" || skillls[i]=="Hone Dragons"
      stats[2]+=6
      stats[3]+=6
    end
    if skillls[i]=="Fortify Movement" || skillls[i]=="Fortify Dragons"
      stats[4]+=6
      stats[5]+=6
    end
    if skillls[i][0,17]=="Fortress Defense " || skillls[i][0,13]=="Fortress Def "
      stats[2]-=3
      stats[4]+=(skillls[i].scan(/\d+?/)[0].to_i+2)
    end
    if skillls[i][0,20]=="Fortress Resistance " || skillls[i][0,13]=="Fortress Res "
      stats[2]-=3
      stats[5]+=(skillls[i].scan(/\d+?/)[0].to_i+2)
    end
  end
  if tempest
    stats[1]+=10
    stats[2]+=4
    stats[3]+=4
    stats[4]+=4
    stats[5]+=4
  end
  stats[1]+=5 if summoner=='S'
  stats[1]+=4 if ['A','B'].include?(summoner)
  stats[1]+=3 if summoner=='C'
  stats[2]+=2 if summoner=='S'
  stats[3]+=2 if ['S','A'].include?(summoner)
  stats[4]+=2 if ['S','A','B'].include?(summoner)
  stats[5]+=2 if ['S','A','B','C'].include?(summoner)
  for i in 0...blessing.length
    if blessing[i]=="Attack"
      stats[1]+=3
      stats[2]+=2
    elsif blessing[i]=="Speed"
      stats[1]+=3
      stats[3]+=3
    elsif blessing[i]=="Defense"
      stats[1]+=3
      stats[4]+=4
    elsif blessing[i]=="Resistance"
      stats[1]+=3
      stats[5]+=4
    end
  end
  negative=[0,0,0,0,0]
  rally=[0,0,0,0,0]
  for i in 0...skillls.length
    if skillls[i]=="Rally Attack" || skillls[i]=="Kindled-Fire Balm"
      rally[1]=[rally[1],4].max
    elsif skillls[i]=="Rally Speed" || skillls[i]=="Swift-Winds Balm"
      rally[2]=[rally[2],4].max
    elsif skillls[i]=="Rally Defense" || skillls[i]=="Solid-Earth Balm"
      rally[3]=[rally[3],4].max
    elsif skillls[i]=="Rally Resistance" || skillls[i]=="Still-Water Balm"
      rally[4]=[rally[4],4].max
    elsif skillls[i][0,6]=="Rally "
      rally[1]=[rally[1],3].max if skillls[i].include?("Attack")
      rally[2]=[rally[2],3].max if skillls[i].include?("Speed")
      rally[3]=[rally[3],3].max if skillls[i].include?("Defense")
      rally[4]=[rally[4],3].max if skillls[i].include?("Resistance")
    elsif skillls[i]=="Rainbow Balm" && k==330850148261298176
      rally[1]=[rally[1],2].max
      rally[2]=[rally[2],2].max
      rally[3]=[rally[3],2].max
      rally[4]=[rally[4],2].max
    end
    rally[2]=[rally[2],skillls[i].scan(/\d+?/)[0].to_i+1].max if skillls[i][0,12]=="Blaze Dance "
    rally[3]=[rally[3],skillls[i].scan(/\d+?/)[0].to_i+1].max if skillls[i][0,11]=="Gale Dance "
    rally[4]=[rally[4],skillls[i].scan(/\d+?/)[0].to_i+1].max if skillls[i][0,12]=="Earth Dance "
    rally[5]=[rally[5],skillls[i].scan(/\d+?/)[0].to_i+1].max if skillls[i][0,14]=="Torrent Dance "
    if skillls[i][0,13]=="Geyser Dance "
      rally[4]=[rally[4],skillls[i].scan(/\d+?/)[0].to_i+2].max
      rally[5]=[rally[5],skillls[i].scan(/\d+?/)[0].to_i+2].max
    end
    if skillls[i].include?(" Ploy ")
      negative[1]-=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Atk")
      negative[2]-=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Spd")
      negative[3]-=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Def")
      negative[4]-=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Res")
    end
    if skillls[i][0,5]=="Seal "
      negative[1]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Atk")
      negative[2]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Spd")
      negative[3]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Def")
      negative[4]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Res")
    end
    if skillls[i][0,9]=="Threaten "
      negative[1]-=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Atk")
      negative[2]-=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Spd")
      negative[3]-=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Def")
      negative[4]-=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Res")
    end
    if skillls[i][0,6]=="Chill "
      negative[1]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Atk")
      negative[2]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Spd")
      negative[3]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Def")
      negative[4]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Res")
    end
    if skillls[i]=="Chilling Seal"
      negative[1]-=6
      negative[2]-=6
    end
    if skillls[i].include?(" Smoke ")
      negative[1]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Atk")
      negative[2]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Spd")
      negative[3]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Def")
      negative[4]-=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Res")
    end
  end
  stats[2]+=rally[1]+[negative[1],-7].max
  stats[3]+=rally[2]+[negative[2],-7].max
  stats[4]+=rally[3]+[negative[3],-7].max
  stats[5]+=rally[4]+[negative[4],-7].max
  stats[1]=[[stats[1],1].max,99].min
  stats[2]=[stats[2],0].max
  stats[3]=[stats[3],0].max
  stats[4]=[stats[4],0].max
  stats[5]=[stats[5],0].max
  return stats
end

def apply_combat_buffs(event,skillls,stats,phase)
  k=0
  k=event.server.id unless event.server.nil?
  skillls=skillls.map{|q| q}
  for i in 0...skillls.length
    if skillls[i][0,12]=="Spur Attack " || skillls[i][0,13]=="Drive Attack "
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i+1
    elsif skillls[i][0,11]=="Spur Speed " || skillls[i][0,12]=="Drive Speed "
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i+1
    elsif skillls[i][0,13]=="Spur Defense " || skillls[i][0,14]=="Drive Defense "
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i+1
    elsif skillls[i][0,16]=="Spur Resistance " || skillls[i][0,17]=="Drive Resistance "
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i+1
    elsif skillls[i]=="Spur Spectrum"
      stats[2]+=3
      stats[3]+=3
      stats[4]+=3
      stats[5]+=3
    elsif skillls[i]=="Drive Spectrum"
      stats[2]+=2
      stats[3]+=2
      stats[4]+=2
      stats[5]+=2
    elsif skillls[i][0,5]=="Spur " || skillls[i][0,6]=="Drive "
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Atk")
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Spd")
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Def")
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Res")
    end
    if skillls[i]=="Goad Movement" || skillls[i]=="Goad Dragons"
      stats[2]+=4
      stats[3]+=4
    end
    if skillls[i]=="Ward Movement" || skillls[i]=="Ward Dragons"
      stats[4]+=4
      stats[5]+=4
    end
    if skillls[i]=="Spectrum Bond"
      stats[2]+=4
      stats[3]+=4
      stats[4]+=4
      stats[5]+=4
    elsif skillls[i][7,6]==" Bond "
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Atk")
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Spd")
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Def")
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i+2 if skillls[i].include?("Res")
    end
    if skillls[i]=="Brazen Spectrul"
      stats[2]+=5
      stats[3]+=5
      stats[4]+=5
      stats[5]+=5
    elsif skillls[i][0,7]=="Brazen "
      stats[2]+=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Atk")
      stats[3]+=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Spd")
      stats[4]+=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Def")
      stats[5]+=2*skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i].include?("Res")
    end
    stats[2]+=skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i][0,11]=="Fire Boost "
    stats[3]+=skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i][0,11]=="Wind Boost "
    stats[4]+=skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i][0,12]=="Earth Boost "
    stats[5]+=skillls[i].scan(/\d+?/)[0].to_i+1 if skillls[i][0,12]=="Water Boost "
    if phase=="Player"
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i*2 if skillls[i][0,11]=="Death Blow "
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i*2 if skillls[i][0,13]=="Darting Blow "
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i*2 if skillls[i][0,13]=="Armored Blow "
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i*2 if skillls[i][0,13]=="Warding Blow "
      if skillls[i][0,14]=="Swift Sparrow " # Atk/Spd
        stats[2]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[3]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,12]=="Sturdy Blow " # Atk/Def
        stats[2]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[4]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,14]=="Mirror Strike " # Atk/Res
        stats[2]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[5]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,12]=="Steady Blow " # Spd/Def
        stats[3]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[4]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,13]=="Swift Strike " # Spd/Res
        stats[3]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[5]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,13]=="Bracing Blow " # Def/Res
        stats[4]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[5]+=skillls[i].scan(/\d+?/)[0].to_i*2
      end
    elsif phase=="Enemy"
      stats[2]+=skillls[i].scan(/\d+?/)[0].to_i*2 if skillls[i][0,14]=="Fierce Stance "
      stats[3]+=skillls[i].scan(/\d+?/)[0].to_i*2 if skillls[i][0,15]=="Darting Stance "
      stats[4]+=skillls[i].scan(/\d+?/)[0].to_i*2 if skillls[i][0,14]=="Steady Stance "
      stats[5]+=skillls[i].scan(/\d+?/)[0].to_i*2 if skillls[i][0,15]=="Warding Stance "
      if skillls[i][0,15]=="Sparrow Stance " # Atk/Spd
        stats[2]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[3]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,14]=="Sturdy Stance " # Atk/Def
        stats[2]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[4]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,14]=="Mirror Stance " # Atk/Res
        stats[2]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[5]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,15]=="Spd/Def Stance " # Spd/Def
        stats[3]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[4]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,13]=="Swift Stance " # Spd/Res
        stats[3]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[5]+=skillls[i].scan(/\d+?/)[0].to_i*2
      elsif skillls[i][0,15]=="Bracing Stance " # Def/Res
        stats[4]+=skillls[i].scan(/\d+?/)[0].to_i*2
        stats[5]+=skillls[i].scan(/\d+?/)[0].to_i*2
      end
      if skillls[i]=="Dragonskin"
        stats[4]+=4
        stats[5]+=4
      end
      stats[2]+=4 if skillls[i]=="Fierce Breath"
      stats[3]+=4 if skillls[i]=="Darting Breath"
      stats[4]+=4 if skillls[i]=="Steady Breath"
      stats[5]+=4 if skillls[i]=="Warding Breath"
      if skillls[i]=="Sparrow Breath" # Atk/Spd
        stats[2]+=2
        stats[3]+=2
      elsif skillls[i]=="Sturdy Breath" # Atk/Def
        stats[2]+=2
        stats[4]+=2
      elsif skillls[i]=="Mirror Breath" # Atk/Res
        stats[2]+=2
        stats[5]+=2
      elsif skillls[i]=="Spd/Def Breath" # Spd/Def
        stats[3]+=2
        stats[4]+=2
      elsif skillls[i]=="Swift Breath" # Spd/Res
        stats[3]+=2
        stats[5]+=2
      elsif skillls[i]=="Bracing Breath" # Def/Res
        stats[4]+=2
        stats[5]+=2
      end
    end
  end
  return stats
end

def count_in(arr,str)
  if str.is_a?(Array)
    return arr.count{|x| str.map{|y| y.downcase}.include?(x.downcase)}
  end
  return arr.count{|x| x.downcase==str.downcase}
end

def make_stat_skill_list_1(name,event,args) # this is for yellow-stat skills
  args=sever(event.message.text,true).split(" ") if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.downcase}
  stat_skills=[]
           # skill name, list of ways to trigger skill, limit of copies
  lookout=[['HP +5',['hp+5','hp5','health5'],2],
           ['HP +4',['hp+4','hp4','health4'],2],
           ['HP +3',['hp+3','hp3','health3'],2],
           ['Attack +3',['attack+3','attack3','atk3','att3'],2],
           ['Attack +2',['attack+2','attack2','atk2','att2'],2],
           ['Attack +1',['attack+1','attack1','atk1','att1'],2],
           ['Speed +3',['speed+3','speed3','spd3'],2],
           ['Speed +2',['speed+2','speed2','spd2'],2],
           ['Speed +1',['speed+1','speed1','spd1'],2],
           ['Defense +3',['defense+3','defense3','defence3','def3'],2],
           ['Defense +2',['defense+2','defense2','defence2','def2'],2],
           ['Defense +1',['defense+1','defense1','defence1','def1'],2],
           ['Resistance +3',['resistance+3','resistance3','res3'],2],
           ['Resistance +2',['resistance+2','resistance2','res2'],2],
           ['Resistance +1',['resistance+1','resistance1','res1'],2],
           ['HP Atk 2',['hpatk2','hpatk+2','hpatt2','hpatt+2','hpattack2','hpattack+2','healthatk2','healthatk+2','healthatt2','healthatt+2','healthattack2','healthattack+2','hpatk','hpatt','hpattack','healthatk','healthatt','healthattack','atkhp+2','atkhealth+2','atthp+2','atthealth+2','attackhp+2','attackhealth+2','atkhp2','atkhealth2','atthp2','atthealth2','attackhp2','attackhealth2','atkhp','atkhealth','atthp','atthealth','attackhp','attackhealth'],2],
           ['HP Atk 1',['hpatk1','hpatk+1','hpatt1','hpatt+1','hpattack1','hpattack+1','healthatk1','healthatk+1','healthatt1','healthatt+1','healthattack1','healthattack+1','atkhp+1','atkhealth+1','atthp+1','atthealth+1','attackhp+1','attackhealth+1','atkhp1','atkhealth1','atthp1','atthealth1','attackhp1','attackhealth1'],2],
           ['HP Spd 2',['hpspd2','hpspd+2','hpspeed2','hpspeed+2','healthspd2','healthspd+2','healthspeed2','healthspeed+2','hpspd','hpspeed','healthspd','healthspeed','spdhp+2','spdhealth+2','speedhp+2','speedhealth+2','spdhp2','spdhealth2','speedhp2','speedhealth2','spdhp','spdhealth','speedhp','speedhealth'],2],
           ['HP Spd 1',['hpspd1','hpspd+1','hpspeed1','hpspeed+1','healthspd1','healthspd+1','healthspeed1','healthspeed+1','spdhp+1','spdhealth+1','speedhp+1','speedhealth+1','spdhp1','spdhealth1','speedhp1','speedhealth1'],2],
           ['HP Def 2',['hpdef2','hpdef+2','hpdefense2','hpdefense+2','hpdefence2','hpdefence+2','healthdef2','healthdef+2','healthdefense2','healthdefense+2','healthdefence2','healthdefence+2','hpdef','hpdefense','hpdefence','healthdef','healthdefense','healthdefence','defhp+2','defhealth+2','defensehp+2','defensehealth+2','defencehp+2','defencehealth+2','defhp2','defhealth2','defensehp2','defensehealth2','defencehp2','defencehealth2','defhp','defhealth','defensehp','defensehealth','defencehp','defencehealth'],2],
           ['HP Def 1',['hpdef1','hpdef+1','hpdefense1','hpdefense+1','hpdefence1','hpdefence+1','healthdef1','healthdef+1','healthdefense1','healthdefense+1','healthdefence1','healthdefence+1','defhp+1','defhealth+1','defensehp+1','defensehealth+1','defencehp+1','defencehealth+1','defhp1','defhealth1','defensehp1','defensehealth1','defencehp1','defencehealth1'],2],
           ['HP Res 2',['hpres2','hpres+2','hpresistance2','hpresistance+2','healthres2','healthres+2','healthresistance2','healthresistance+2','hpres','hpresistance','healthres','healthresistance','reshp+2','reshealth+2','resistancehp+2','resistancehealth+2','reshp2','reshealth2','resistancehp2','resistancehealth2','reshp','reshealth','resistancehp','resistancehealth'],2],
           ['HP Res 1',['hpres1','hpres+1','hpresistance1','hpresistance+1','healthres1','healthres+1','healthresistance1','healthresistance+1','reshp+1','reshealth+1','resistancehp+1','resistancehealth+1','reshp1','reshealth1','resistancehp1','resistancehealth1'],2],
           ['Attack/Spd +2',['attackspeed+2','attackspd+2','attspeed+2','attspd+2','atkspeed+2','atkspd+2','attackspeed2','attackspd2','attspeed2','attspd2','atkspeed2','atkspd2','attackspeed','attackspd','attspeed','attspd','atkspeed','atkspd','speedattack+2','speedatk+2','speedatt+2','spdattack+2','spdatk+2','spdatt+2','speedattack2','speedatk2','speedatt2','spdattack2','spdatk2','spdatt2','speedattack','speedatk','speedatt','spdattack','spdatk','spdatt'],2],
           ['Attack/Spd +1',['attackspeed+1','attackspd+1','attspeed+1','attspd+1','atkspeed+1','atkspd+1','attackspeed1','attackspd1','attspeed1','attspd1','atkspeed1','atkspd1','speedattack+1','speedatk+1','speedatt+1','spdattack+1','spdatk+1','spdatt+1','speedattack1','speedatk1','speedatt1','spdattack1','spdatk1','spdatt1'],2],
           ['Attack/Def +2',['defenseattack+2','defenseatk+2','defenseatt+2','defenceattack+2','defenceatk+2','defenceatt+2','defattack+2','defatk+2','defatt+2','defenseattack2','defenseatk2','defenseatt2','defenceattack2','defenceatk2','defenceatt2','defattack2','defatk2','defatt2','defenseattack','defenseatk','defenseatt','defenceattack','defenceatk','defenceatt','defattack','defatk','defatt','attackdefense+2','attackdefence+2','attackdef+2','atkdefense+2','atkdefence+2','atkdef+2','attdefense+2','attdefence+2','attdef+2','attackdefense2','attackdefence2','attackdef2','atkdefense2','atkdefence2','atkdef2','attdefense2','attdefence2','attdef2','attackdefense','attackdefence','attackdef','atkdefense','atkdefence','atkdef','attdefense','attdefence','attdef'],2],
           ['Attack/Def +1',['defenseattack+1','defenseatk+1','defenseatt+1','defenceattack+1','defenceatk+1','defenceatt+1','defattack+1','defatk+1','defatt+1','defenseattack1','defenseatk1','defenseatt1','defenceattack1','defenceatk1','defenceatt1','defattack1','defatk1','defatt1','attackdefense+1','attackdefence+1','attackdef+1','atkdefense+1','atkdefence+1','atkdef+1','attdefense+1','attdefence+1','attdef+1','attackdefense1','attackdefence1','attackdef1','atkdefense1','atkdefence1','atkdef1','attdefense1','attdefence1','attdef1'],2],
           ['Attack/Res +2',['attackresistance+2','attackres+2','atkresistance+2','atkres+2','attresistance+2','attres+2','attackresistance2','attackres2','atkresistance2','atkres2','attresistance2','attres2','attackresistance','attackres','atkresistance','atkres','attresistance','attres','resistanceattack+2','resistanceatk+2','resistanceatt+2','resattack+2','resatk+2','resatt+2','resistanceattack2','resistanceatk2','resistanceatt2','resattack2','resatk2','resatt2','resistanceattack','resistanceatk','resistanceatt','resattack','resatk','resatt'],2],
           ['Attack/Res +1',['attackresistance+1','attackres+1','atkresistance+1','atkres+1','attresistance+1','attres+1','attackresistance1','attackres1','atkresistance1','atkres1','attresistance1','attres1','resistanceattack+1','resistanceatk+1','resistanceatt+1','resattack+1','resatk+1','resatt+1','resistanceattack1','resistanceatk1','resistanceatt1','resattack1','resatk1','resatt1'],2],
           ['Spd/Def +2',['speeddefense+2','speeddefence+2','speeddef+2','spddefense+2','spddefence+2','spddef+2','speeddefense2','speeddefence2','speeddef2','spddefense2','spddefence2','spddef2','speeddefense','speeddefence','speeddef','spddefense','spddefence','spddef','defensespeed+2','defensespd+2','defencespeed+2','defencespd+2','defspeed+2','defspd+2','defensespeed2','defensespd2','defencespeed2','defencespd2','defspeed2','defspd2','defensespeed','defensespd','defencespeed','defencespd','defspeed','defspd'],2],
           ['Spd/Def +1',['speeddefense+1','speeddefence+1','speeddef+1','spddefense+1','spddefence+1','spddef+1','speeddefense1','speeddefence1','speeddef1','spddefense1','spddefence1','spddef1','defensespeed+1','defensespd+1','defencespeed+1','defencespd+1','defspeed+1','defspd+1','defensespeed1','defensespd1','defencespeed1','defencespd1','defspeed1','defspd1'],2],
           ['Spd/Res +2',['resistancespeed+2','resistancespd+2','resspeed+2','resspd+2','resistancespeed2','resistancespd2','resspeed2','resspd2','resistancespeed','resistancespd','resspeed','resspd','speedresistance+2','speedres+2','spdresistance+2','spdres+2','speedresistance2','speedres2','spdresistance2','spdres2','speedresistance','speedres','spdresistance','spdres'],2],
           ['Spd/Res +1',['resistancespeed+1','resistancespd+1','resspeed+1','resspd+1','resistancespeed1','resistancespd1','resspeed1','resspd1','speedresistance+1','speedres+1','spdresistance+1','spdres+1','speedresistance1','speedres1','spdresistance1','spdres1'],2],
           ['Def/Res +2',['defenseresistance+2','defenseres+2','defenceresistance+2','defenceres+2','defresistance+2','defres+2','defenseresistance2','defenseres2','defenceresistance2','defenceres2','defresistance2','defres2','defenseresistance','defenseres','defenceresistance','defenceres','defresistance','defres','resistancedefense+2','resistancedefence+2','resistancedef+2','resdefense+2','resdefence+2','resdef+2','resistancedefense2','resistancedefence2','resistancedef2','resdefense2','resdefence2','resdef2','resistancedefense','resistancedefence','resistancedef','resdefense','resdefence','resdef'],2],
           ['Def/Res +1',['defenseresistance+1','defenseres+1','defenceresistance+1','defenceres+1','defresistance+1','defres+1','defenseresistance1','defenseres1','defenceresistance1','defenceres1','defresistance1','defres1','defresistance','defres','resistancedefense+1','resistancedefence+1','resistancedef+1','resdefense+1','resdefence+1','resdef+1','resistancedefense1','resistancedefence1','resistancedef1','resdefense1','resdefence1','resdef1'],2]]
  for i in 0...lookout.length
    for i2 in 0...lookout[i][2]
      stat_skills.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  lokoout=lookout.map{|q| q[0]}
  args=event.message.text.downcase.split(" ") # reobtain args without the reformatting caused by the sever function
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  lookout=[['Fury 3',['fury3','angery3','fury','angery'],2],
           ['Fury 2',['fury2','angery2'],2],
           ['Fury 1',['fury1','angery1'],2],
           ['Life and Death 3',['lnd3','lad3','l&d3','lifeanddeath3','life&death3','lnd','lad','l&d','lifeanddeath','life&death'],2],
           ['Life and Death 2',['lnd2','lad2','l&d2','lifeanddeath2','life&death2'],2],
           ['Life and Death 1',['lnd1','lad1','l&d1','lifeanddeath1','life&death1'],2],
           ['Fortress Def 3',['fortressdef3','fortressdefense3','fortressdefence3','fortdef3','fortdefense3','fortdefence3','fortressdef','fortressdefense','fortressdefence','fortdef','fortdefense','fortdefence'],2],
           ['Fortress Def 2',['fortressdef2','fortressdefense2','fortressdefence2','fortdef2','fortdefense2','fortdefence2'],2],
           ['Fortress Def 1',['fortressdef1','fortressdefense1','fortressdefence1','fortdef1','fortdefense1','fortdefence1'],2],
           ['Fortress Res 3',['fortressres3','fortressresistance3','fortres3','fortresistance3','fortressres','fortressresistance','fortres','fortresistance'],2],
           ['Fortress Res 2',['fortressres2','fortressresistance2','fortres2','fortresistance2'],2],
           ['Fortress Res 1',['fortressres1','fortressresistance1','fortres1','fortresistance1'],2]]
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
      a=@dev_units[dv][9].reject{|q| q.include?("~~")}
      x=[a[a.length-1],@dev_units[dv][12]]
      for i in 0...x.length
        stat_skills.push(x[i]) if lokoout.include?(x[i])
      end
    end
  end
  return stat_skills
end

def make_stat_skill_list_2(name,event,args) # this is for blue- and red- stat skills.  Character name is needed to know which movement Hone/Fortify to apply
  args=sever(event.message.text,true).split(" ") if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.downcase}
  stat_skills_2=[]
  lookout=[['Defiant Attack 3',['defiantatk3','defiantatt3','defiantattack3','defiantatk','defiantatt','defiantattack'],2],
           ['Defiant Attack 2',['defiantatk2','defiantatt2','defiantattack2'],2],
           ['Defiant Attack 1',['defiantatk1','defiantatt1','defiantattack1'],2],
           ['Defiant Speed 3',['defiantspd3','defiantspeed3','defiantspd','defiantspeed'],2],
           ['Defiant Speed 2',['defiantspd2','defiantspeed2'],2],
           ['Defiant Speed 1',['defiantspd1','defiantspeed1'],2],
           ['Defiant Defense 3',['defiantdef3','defiantdefense3','defiantdefence3','defiantdef','defiantdefense','defiantdefence'],2],
           ['Defiant Defense 2',['defiantdef2','defiantdefense2','defiantdefence2'],2],
           ['Defiant Defense 1',['defiantdef1','defiantdefense1','defiantdefence1'],2],
           ['Defiant Resistance 3',['defiantres3','defiantresistance3','defiantres','defiantresistance'],2],
           ['Defiant Resistance 2',['defiantres2','defiantresistance2'],2],
           ['Defiant Resistance 1',['defiantres1','defiantresistance1'],2],
           ['Atk Ploy 3',['attackploy','atkploy','attploy','attackploy3','atkploy3','attploy3'],2],
           ['Atk Ploy 2',['attackploy2','atkploy2','attploy2'],2],
           ['Atk Ploy 1',['attackploy1','atkploy1','attploy1'],3],
           ['Spd Ploy 3',['speedploy','spdploy','speedploy3','spdploy3'],2],
           ['Spd Ploy 2',['speedploy2','spdploy2'],2],
           ['Spd Ploy 1',['speedploy1','spdploy1'],3],
           ['Def Ploy 3',['defenseploy','defenceploy','defploy','defenseploy3','defenceploy3','defploy3'],2],
           ['Def Ploy 2',['defenseploy2','defenceploy2','defploy2'],2],
           ['Def Ploy 1',['defenseploy1','defenceploy1','defploy1'],3],
           ['Res Ploy 3',['resistanceploy','resploy','resistanceploy3','resploy3'],2],
           ['Res Ploy 2',['resistanceploy2','resploy2'],2],
           ['Res Ploy 1',['resistanceploy1','resploy1'],3],
           ['Atk/Spd Ploy 2',['attackspeedploy','atkspeedploy','attspeedploy','attackspdploy','atkspdploy','attspdploy','speedattackploy','speedatkploy','speedattploy','spdattackploy','spdatkploy','spdattploy','attackspeedploy2','atkspeedploy2','attspeedploy2','attackspdploy2','atkspdploy2','attspdploy2','speedattackploy2','speedatkploy2','speedattploy2','spdattackploy2','spdatkploy2','spdattploy2'],2],
           ['Atk/Spd Ploy 1',['attackspeedploy1','atkspeedploy1','attspeedploy1','attackspdploy1','atkspdploy1','attspdploy1','speedattackploy1','speedatkploy1','speedattploy1','spdattackploy1','spdatkploy1','spdattploy1'],3],
           ['Atk/Def Ploy 2',['attackdefenseploy','atkdefenseploy','attdefenseploy','attackdefenceploy','atkdefenceploy','attdefenceploy','attackdefploy','atkdefploy','attdefploy','defenseattackploy','defenseatkploy','defenseattploy','defenceattackploy','defenceatkploy','defenceattploy','defattackploy','defatkploy','defattploy','attackdefenseploy2','atkdefenseploy2','attdefenseploy2','attackdefenceploy2','atkdefenceploy2','attdefenceploy2','attackdefploy2','atkdefploy2','attdefploy2','defenseattackploy2','defenseatkploy2','defenseattploy2','defenceattackploy2','defenceatkploy2','defenceattploy2','defattackploy2','defatkploy2','defattploy2'],2],
           ['Atk/Def Ploy 1',['attackdefenseploy1','atkdefenseploy1','attdefenseploy1','attackdefenceploy1','atkdefenceploy1','attdefenceploy1','attackdefploy1','atkdefploy1','attdefploy1','defenseattackploy1','defenseatkploy1','defenseattploy1','defenceattackploy1','defenceatkploy1','defenceattploy1','defattackploy1','defatkploy1','defattploy1'],3],
           ['Atk/Res Ploy 2',['attackresistanceploy','atkresistanceploy','attresistanceploy','attackresploy','atkresploy','attresploy','resistanceattackploy','resistanceatkploy','resistanceattploy','resattackploy','resatkploy','resattploy','attackresistanceploy2','atkresistanceploy2','attresistanceploy2','attackresploy2','atkresploy2','attresploy2','resistanceattackploy2','resistanceatkploy2','resistanceattploy2','resattackploy2','resatkploy2','resattploy2'],2],
           ['Atk/Res Ploy 1',['attackresistanceploy1','atkresistanceploy1','attresistanceploy1','attackresploy1','atkresploy1','attresploy1','resistanceattackploy1','resistanceatkploy1','resistanceattploy1','resattackploy1','resatkploy1','resattploy1'],3],
           ['Spd/Def Ploy 2',['speeddefenseploy','spddefenseploy','speeddefenceploy','spddefenceploy','speeddefploy','spddefploy','defensespeedploy','defensespdploy','defencespeedploy','defencespdploy','defspeedploy','defspdploy','speeddefenseploy2','spddefenseploy2','speeddefenceploy2','spddefenceploy2','speeddefploy2','spddefploy2','defensespeedploy2','defensespdploy2','defencespeedploy2','defencespdploy2','defspeedploy2','defspdploy2'],2],
           ['Spd/Def Ploy 1',['speeddefenseploy1','spddefenseploy1','speeddefenceploy1','spddefenceploy1','speeddefploy1','spddefploy1','defensespeedploy1','defensespdploy1','defencespeedploy1','defencespdploy1','defspeedploy1','defspdploy1'],3],
           ['Spd/Res Ploy 2',['speedresistanceploy','spdresistanceploy','speedresploy','spdresploy','resistancespeedploy','resistancespdploy','resspeedploy','resspdploy','speedresistanceploy2','spdresistanceploy2','speedresploy2','spdresploy2','resistancespeedploy2','resistancespdploy2','resspeedploy2','resspdploy2'],2],
           ['Spd/Res Ploy 1',['speedresistanceploy1','spdresistanceploy1','speedresploy1','spdresploy1','resistancespeedploy1','resistancespdploy1','resspeedploy1','resspdploy1'],3],
           ['Def/Res Ploy 2',['defenseresistanceploy','defenceresistanceploy','defresistanceploy','defenseresploy','defenceresploy','defresploy','resistancedefenseploy','resistancedefenceploy','resistancedefploy','resdefenseploy','resdefenceploy','resdefploy','defenseresistanceploy2','defenceresistanceploy2','defresistanceploy2','defenseresploy2','defenceresploy2','defresploy2','resistancedefenseploy2','resistancedefenceploy2','resistancedefploy2','resdefenseploy2','resdefenceploy2','resdefploy2'],2],
           ['Def/Res Ploy 1',['defenseresistanceploy1','defenceresistanceploy1','defresistanceploy1','defenseresploy1','defenceresploy1','defresploy1','resistancedefenseploy1','resistancedefenceploy1','resistancedefploy1','resdefenseploy1','resdefenceploy1','resdefploy1'],3],
           ['Seal Atk 3',['sealattack','sealatk','sealatt','sealattack3','sealatk3','sealatt3'],2],
           ['Seal Atk 2',['sealattack2','sealatk2','sealatt2'],2],
           ['Seal Atk 1',['sealattack1','sealatk1','sealatt1'],3],
           ['Seal Spd 3',['sealspeed','sealspd','sealspeed3','sealspd3'],2],
           ['Seal Spd 2',['sealspeed2','sealspd2'],2],
           ['Seal Spd 1',['sealspeed1','sealspd1'],3],
           ['Seal Def 3',['sealdefense','sealdefence','sealdef','sealdefense3','sealdefence3','sealdef3'],2],
           ['Seal Def 2',['sealdefense2','sealdefence2','sealdef2'],2],
           ['Seal Def 1',['sealdefense1','sealdefence1','sealdef1'],3],
           ['Seal Res 3',['sealresistance','sealres','sealresistance3','sealres3'],2],
           ['Seal Res 2',['sealresistance2','sealres2'],2],
           ['Seal Res 1',['sealresistance1','sealres1'],3],
           ['Seal Atk/Spd 2',['sealattackspeed','sealatkspeed','sealattspeed','sealattackspd','sealatkspd','sealattspd','sealspeedattack','sealspeedatk','sealspeedatt','sealspdattack','sealspdatk','sealspdatt','sealattackspeed2','sealatkspeed2','sealattspeed2','sealattackspd2','sealatkspd2','sealattspd2','sealspeedattack2','sealspeedatk2','sealspeedatt2','sealspdattack2','sealspdatk2','sealspdatt2'],2],
           ['Seal Atk/Spd 1',['sealattackspeed1','sealatkspeed1','sealattspeed1','sealattackspd1','sealatkspd1','sealattspd1','sealspeedattack1','sealspeedatk1','sealspeedatt1','sealspdattack1','sealspdatk1','sealspdatt1'],3],
           ['Seal Atk/Def 2',['sealattackdefense','sealatkdefense','sealattdefense','sealattackdefence','sealatkdefence','sealattdefence','sealattackdef','sealatkdef','sealattdef','sealdefenseattack','sealdefenseatk','sealdefenseatt','sealdefenceattack','sealdefenceatk','sealdefenceatt','sealdefattack','sealdefatk','sealdefatt','sealattackdefense2','sealatkdefense2','sealattdefense2','sealattackdefence2','sealatkdefence2','sealattdefence2','sealattackdef2','sealatkdef2','sealattdef2','sealdefenseattack2','sealdefenseatk2','sealdefenseatt2','sealdefenceattack2','sealdefenceatk2','sealdefenceatt2','sealdefattack2','sealdefatk2','sealdefatt2'],2],
           ['Seal Atk/Def 1',['sealattackdefense1','sealatkdefense1','sealattdefense1','sealattackdefence1','sealatkdefence1','sealattdefence1','sealattackdef1','sealatkdef1','sealattdef1','sealdefenseattack1','sealdefenseatk1','sealdefenseatt1','sealdefenceattack1','sealdefenceatk1','sealdefenceatt1','sealdefattack1','sealdefatk1','sealdefatt1'],3],
           ['Seal Atk/Res 2',['sealattackresistance','sealatkresistance','sealattresistance','sealattackres','sealatkres','sealattres','sealresistanceattack','sealresistanceatk','sealresistanceatt','sealresattack','sealresatk','sealresatt','sealattackresistance2','sealatkresistance2','sealattresistance2','sealattackres2','sealatkres2','sealattres2','sealresistanceattack2','sealresistanceatk2','sealresistanceatt2','sealresattack2','sealresatk2','sealresatt2'],2],
           ['Seal Atk/Res 1',['sealattackresistance1','sealatkresistance1','sealattresistance1','sealattackres1','sealatkres1','sealattres1','sealresistanceattack1','sealresistanceatk1','sealresistanceatt1','sealresattack1','sealresatk1','sealresatt1'],3],
           ['Seal Spd/Def 2',['sealspeeddefense','sealspddefense','sealspeeddefence','sealspddefence','sealspeeddef','sealspddef','sealdefensespeed','sealdefensespd','sealdefencespeed','sealdefencespd','sealdefspeed','sealdefspd','sealspeeddefense2','sealspddefense2','sealspeeddefence2','sealspddefence2','sealspeeddef2','sealspddef2','sealdefensespeed2','sealdefensespd2','sealdefencespeed2','sealdefencespd2','sealdefspeed2','sealdefspd2'],2],
           ['Seal Spd/Def 1',['sealspeeddefense1','sealspddefense1','sealspeeddefence1','sealspddefence1','sealspeeddef1','sealspddef1','sealdefensespeed1','sealdefensespd1','sealdefencespeed1','sealdefencespd1','sealdefspeed1','sealdefspd1'],3],
           ['Seal Spd/Res 2',['sealspeedresistance','sealspdresistance','sealspeedres','sealspdres','sealresistancespeed','sealresistancespd','sealresspeed','sealresspd','sealspeedresistance2','sealspdresistance2','sealspeedres2','sealspdres2','sealresistancespeed2','sealresistancespd2','sealresspeed2','sealresspd2'],2],
           ['Seal Spd/Res 1',['sealspeedresistance1','sealspdresistance1','sealspeedres1','sealspdres1','sealresistancespeed1','sealresistancespd1','sealresspeed1','sealresspd1'],3],
           ['Seal Def/Res 2',['sealdefenseresistance','sealdefenceresistance','sealdefresistance','sealdefenseres','sealdefenceres','sealdefres','sealresistancedefense','sealresistancedefence','sealresistancedef','sealresdefense','sealresdefence','sealresdef','sealdefenseresistance2','sealdefenceresistance2','sealdefresistance2','sealdefenseres2','sealdefenceres2','sealdefres2','sealresistancedefense2','sealresistancedefence2','sealresistancedef2','sealresdefense2','sealresdefence2','sealresdef2'],2],
           ['Seal Def/Res 1',['sealdefenseresistance1','sealdefenceresistance1','sealdefresistance1','sealdefenseres1','sealdefenceres1','sealdefres1','sealresistancedefense1','sealresistancedefence1','sealresistancedef1','sealresdefense1','sealresdefence1','sealresdef1'],3],
           ['Threaten Atk 3',['threatenattack','threatenatk','threatenatt','threatenattack3','threatenatk3','threatenatt3'],2],
           ['Threaten Atk 2',['threatenattack2','threatenatk2','threatenatt2'],2],
           ['Threaten Atk 1',['threatenattack1','threatenatk1','threatenatt1'],3],
           ['Threaten Spd 3',['threatenspeed','threatenspd','threatenspeed3','threatenspd3'],2],
           ['Threaten Spd 2',['threatenspeed2','threatenspd2'],2],
           ['Threaten Spd 1',['threatenspeed1','threatenspd1'],3],
           ['Threaten Def 3',['threatendefense','threatendefence','threatendef','threatendefense3','threatendefence3','threatendef3'],2],
           ['Threaten Def 2',['threatendefense2','threatendefence2','threatendef2'],2],
           ['Threaten Def 1',['threatendefense1','threatendefence1','threatendef1'],3],
           ['Threaten Res 3',['threatenresistance','threatenres','threatenresistance3','threatenres3'],2],
           ['Threaten Res 2',['threatenresistance2','threatenres2'],2],
           ['Threaten Res 1',['threatenresistance1','threatenres1'],3],
           ['Threaten Atk/Spd 2',['threatenattackspeed','threatenatkspeed','threatenattspeed','threatenattackspd','threatenatkspd','threatenattspd','threatenspeedattack','threatenspeedatk','threatenspeedatt','threatenspdattack','threatenspdatk','threatenspdatt','threatenattackspeed2','threatenatkspeed2','threatenattspeed2','threatenattackspd2','threatenatkspd2','threatenattspd2','threatenspeedattack2','threatenspeedatk2','threatenspeedatt2','threatenspdattack2','threatenspdatk2','threatenspdatt2'],2],
           ['Threaten Atk/Spd 1',['threatenattackspeed1','threatenatkspeed1','threatenattspeed1','threatenattackspd1','threatenatkspd1','threatenattspd1','threatenspeedattack1','threatenspeedatk1','threatenspeedatt1','threatenspdattack1','threatenspdatk1','threatenspdatt1'],3],
           ['Threaten Atk/Def 2',['threatenattackdefense','threatenatkdefense','threatenattdefense','threatenattackdefence','threatenatkdefence','threatenattdefence','threatenattackdef','threatenatkdef','threatenattdef','threatendefenseattack','threatendefenseatk','threatendefenseatt','threatendefenceattack','threatendefenceatk','threatendefenceatt','threatendefattack','threatendefatk','threatendefatt','threatenattackdefense2','threatenatkdefense2','threatenattdefense2','threatenattackdefence2','threatenatkdefence2','threatenattdefence2','threatenattackdef2','threatenatkdef2','threatenattdef2','threatendefenseattack2','threatendefenseatk2','threatendefenseatt2','threatendefenceattack2','threatendefenceatk2','threatendefenceatt2','threatendefattack2','threatendefatk2','threatendefatt2'],2],
           ['Threaten Atk/Def 1',['threatenattackdefense1','threatenatkdefense1','threatenattdefense1','threatenattackdefence1','threatenatkdefence1','threatenattdefence1','threatenattackdef1','threatenatkdef1','threatenattdef1','threatendefenseattack1','threatendefenseatk1','threatendefenseatt1','threatendefenceattack1','threatendefenceatk1','threatendefenceatt1','threatendefattack1','threatendefatk1','threatendefatt1'],3],
           ['Threaten Atk/Res 2',['threatenattackresistance','threatenatkresistance','threatenattresistance','threatenattackres','threatenatkres','threatenattres','threatenresistanceattack','threatenresistanceatk','threatenresistanceatt','threatenresattack','threatenresatk','threatenresatt','threatenattackresistance2','threatenatkresistance2','threatenattresistance2','threatenattackres2','threatenatkres2','threatenattres2','threatenresistanceattack2','threatenresistanceatk2','threatenresistanceatt2','threatenresattack2','threatenresatk2','threatenresatt2'],2],
           ['Threaten Atk/Res 1',['threatenattackresistance1','threatenatkresistance1','threatenattresistance1','threatenattackres1','threatenatkres1','threatenattres1','threatenresistanceattack1','threatenresistanceatk1','threatenresistanceatt1','threatenresattack1','threatenresatk1','threatenresatt1'],3],
           ['Threaten Spd/Def 2',['threatenspeeddefense','threatenspddefense','threatenspeeddefence','threatenspddefence','threatenspeeddef','threatenspddef','threatendefensespeed','threatendefensespd','threatendefencespeed','threatendefencespd','threatendefspeed','threatendefspd','threatenspeeddefense2','threatenspddefense2','threatenspeeddefence2','threatenspddefence2','threatenspeeddef2','threatenspddef2','threatendefensespeed2','threatendefensespd2','threatendefencespeed2','threatendefencespd2','threatendefspeed2','threatendefspd2'],2],
           ['Threaten Spd/Def 1',['threatenspeeddefense1','threatenspddefense1','threatenspeeddefence1','threatenspddefence1','threatenspeeddef1','threatenspddef1','threatendefensespeed1','threatendefensespd1','threatendefencespeed1','threatendefencespd1','threatendefspeed1','threatendefspd1'],3],
           ['Threaten Spd/Res 2',['threatenspeedresistance','threatenspdresistance','threatenspeedres','threatenspdres','threatenresistancespeed','threatenresistancespd','threatenresspeed','threatenresspd','threatenspeedresistance2','threatenspdresistance2','threatenspeedres2','threatenspdres2','threatenresistancespeed2','threatenresistancespd2','threatenresspeed2','threatenresspd2'],2],
           ['Threaten Spd/Res 1',['threatenspeedresistance1','threatenspdresistance1','threatenspeedres1','threatenspdres1','threatenresistancespeed1','threatenresistancespd1','threatenresspeed1','threatenresspd1'],3],
           ['Threaten Def/Res 2',['threatendefenseresistance','threatendefenceresistance','threatendefresistance','threatendefenseres','threatendefenceres','threatendefres','threatenresistancedefense','threatenresistancedefence','threatenresistancedef','threatenresdefense','threatenresdefence','threatenresdef','threatendefenseresistance2','threatendefenceresistance2','threatendefresistance2','threatendefenseres2','threatendefenceres2','threatendefres2','threatenresistancedefense2','threatenresistancedefence2','threatenresistancedef2','threatenresdefense2','threatenresdefence2','threatenresdef2'],2],
           ['Threaten Def/Res 1',['threatendefenseresistance1','threatendefenceresistance1','threatendefresistance1','threatendefenseres1','threatendefenceres1','threatendefres1','threatenresistancedefense1','threatenresistancedefence1','threatenresistancedef1','threatenresdefense1','threatenresdefence1','threatenresdef1'],3],
           ['Chill Atk 3',['chillattack','chillatk','chillatt','chillattack3','chillatk3','chillatt3'],2],
           ['Chill Atk 2',['chillattack2','chillatk2','chillatt2'],2],
           ['Chill Atk 1',['chillattack1','chillatk1','chillatt1'],3],
           ['Chill Spd 3',['chillspeed','chillspd','chillspeed3','chillspd3'],2],
           ['Chill Spd 2',['chillspeed2','chillspd2'],2],
           ['Chill Spd 1',['chillspeed1','chillspd1'],3],
           ['Chill Def 3',['chilldefense','chilldefence','chilldef','chilldefense3','chilldefence3','chilldef3'],2],
           ['Chill Def 2',['chilldefense2','chilldefence2','chilldef2'],2],
           ['Chill Def 1',['chilldefense1','chilldefence1','chilldef1'],3],
           ['Chill Res 3',['chillresistance','chillres','chillresistance3','chillres3'],2],
           ['Chill Res 2',['chillresistance2','chillres2'],2],
           ['Chill Res 1',['chillresistance1','chillres1'],3],
           ['Chill Atk/Spd 2',['chillattackspeed','chillatkspeed','chillattspeed','chillattackspd','chillatkspd','chillattspd','chillspeedattack','chillspeedatk','chillspeedatt','chillspdattack','chillspdatk','chillspdatt','chillattackspeed2','chillatkspeed2','chillattspeed2','chillattackspd2','chillatkspd2','chillattspd2','chillspeedattack2','chillspeedatk2','chillspeedatt2','chillspdattack2','chillspdatk2','chillspdatt2'],2],
           ['Chill Atk/Spd 1',['chillattackspeed1','chillatkspeed1','chillattspeed1','chillattackspd1','chillatkspd1','chillattspd1','chillspeedattack1','chillspeedatk1','chillspeedatt1','chillspdattack1','chillspdatk1','chillspdatt1'],3],
           ['Chill Atk/Def 2',['chillattackdefense','chillatkdefense','chillattdefense','chillattackdefence','chillatkdefence','chillattdefence','chillattackdef','chillatkdef','chillattdef','chilldefenseattack','chilldefenseatk','chilldefenseatt','chilldefenceattack','chilldefenceatk','chilldefenceatt','chilldefattack','chilldefatk','chilldefatt','chillattackdefense2','chillatkdefense2','chillattdefense2','chillattackdefence2','chillatkdefence2','chillattdefence2','chillattackdef2','chillatkdef2','chillattdef2','chilldefenseattack2','chilldefenseatk2','chilldefenseatt2','chilldefenceattack2','chilldefenceatk2','chilldefenceatt2','chilldefattack2','chilldefatk2','chilldefatt2'],2],
           ['Chill Atk/Def 1',['chillattackdefense1','chillatkdefense1','chillattdefense1','chillattackdefence1','chillatkdefence1','chillattdefence1','chillattackdef1','chillatkdef1','chillattdef1','chilldefenseattack1','chilldefenseatk1','chilldefenseatt1','chilldefenceattack1','chilldefenceatk1','chilldefenceatt1','chilldefattack1','chilldefatk1','chilldefatt1'],3],
           ['Chill Atk/Res 2',['chillattackresistance','chillatkresistance','chillattresistance','chillattackres','chillatkres','chillattres','chillresistanceattack','chillresistanceatk','chillresistanceatt','chillresattack','chillresatk','chillresatt','chillattackresistance2','chillatkresistance2','chillattresistance2','chillattackres2','chillatkres2','chillattres2','chillresistanceattack2','chillresistanceatk2','chillresistanceatt2','chillresattack2','chillresatk2','chillresatt2'],2],
           ['Chill Atk/Res 1',['chillattackresistance1','chillatkresistance1','chillattresistance1','chillattackres1','chillatkres1','chillattres1','chillresistanceattack1','chillresistanceatk1','chillresistanceatt1','chillresattack1','chillresatk1','chillresatt1'],3],
           ['Chill Spd/Def 2',['chillspeeddefense','chillspddefense','chillspeeddefence','chillspddefence','chillspeeddef','chillspddef','chilldefensespeed','chilldefensespd','chilldefencespeed','chilldefencespd','chilldefspeed','chilldefspd','chillspeeddefense2','chillspddefense2','chillspeeddefence2','chillspddefence2','chillspeeddef2','chillspddef2','chilldefensespeed2','chilldefensespd2','chilldefencespeed2','chilldefencespd2','chilldefspeed2','chilldefspd2'],2],
           ['Chill Spd/Def 1',['chillspeeddefense1','chillspddefense1','chillspeeddefence1','chillspddefence1','chillspeeddef1','chillspddef1','chilldefensespeed1','chilldefensespd1','chilldefencespeed1','chilldefencespd1','chilldefspeed1','chilldefspd1'],3],
           ['Chill Spd/Res 2',['chillspeedresistance','chillspdresistance','chillspeedres','chillspdres','chillresistancespeed','chillresistancespd','chillresspeed','chillresspd','chillspeedresistance2','chillspdresistance2','chillspeedres2','chillspdres2','chillresistancespeed2','chillresistancespd2','chillresspeed2','chillresspd2'],2],
           ['Chill Spd/Res 1',['chillspeedresistance1','chillspdresistance1','chillspeedres1','chillspdres1','chillresistancespeed1','chillresistancespd1','chillresspeed1','chillresspd1'],3],
           ['Chill Def/Res 2',['chilldefenseresistance','chilldefenceresistance','chilldefresistance','chilldefenseres','chilldefenceres','chilldefres','chillresistancedefense','chillresistancedefence','chillresistancedef','chillresdefense','chillresdefence','chillresdef','chilldefenseresistance2','chilldefenceresistance2','chilldefresistance2','chilldefenseres2','chilldefenceres2','chilldefres2','chillresistancedefense2','chillresistancedefence2','chillresistancedef2','chillresdefense2','chillresdefence2','chillresdef2'],2],
           ['Chill Def/Res 1',['chilldefenseresistance1','chilldefenceresistance1','chilldefresistance1','chilldefenseres1','chilldefenceres1','chilldefres1','chillresistancedefense1','chillresistancedefence1','chillresistancedef1','chillresdefense1','chillresdefence1','chillresdef1'],3],
           ['Chilling Seal',['chillseal','chillingseal'],2],
           ['Atk Smoke 3',['attacksmoke','atksmoke','attsmoke','attacksmoke3','atksmoke3','attsmoke3'],2],
           ['Atk Smoke 2',['attacksmoke2','atksmoke2','attsmoke2'],2],
           ['Atk Smoke 1',['attacksmoke1','atksmoke1','attsmoke1'],3],
           ['Spd Smoke 3',['speedsmoke','spdsmoke','speedsmoke3','spdsmoke3'],2],
           ['Spd Smoke 2',['speedsmoke2','spdsmoke2'],2],
           ['Spd Smoke 1',['speedsmoke1','spdsmoke1'],3],
           ['Def Smoke 3',['defensesmoke','defencesmoke','defsmoke','defensesmoke3','defencesmoke3','defsmoke3'],2],
           ['Def Smoke 2',['defensesmoke2','defencesmoke2','defsmoke2'],2],
           ['Def Smoke 1',['defensesmoke1','defencesmoke1','defsmoke1'],3],
           ['Res Smoke 3',['resistancesmoke','ressmoke','resistancesmoke3','ressmoke3'],2],
           ['Res Smoke 2',['resistancesmoke2','ressmoke2'],2],
           ['Res Smoke 1',['resistancesmoke1','ressmoke1'],3],
           ['Atk/Spd Smoke 2',['attackspeedsmoke','atkspeedsmoke','attspeedsmoke','attackspdsmoke','atkspdsmoke','attspdsmoke','speedattacksmoke','speedatksmoke','speedattsmoke','spdattacksmoke','spdatksmoke','spdattsmoke','attackspeedsmoke2','atkspeedsmoke2','attspeedsmoke2','attackspdsmoke2','atkspdsmoke2','attspdsmoke2','speedattacksmoke2','speedatksmoke2','speedattsmoke2','spdattacksmoke2','spdatksmoke2','spdattsmoke2'],2],
           ['Atk/Spd Smoke 1',['attackspeedsmoke1','atkspeedsmoke1','attspeedsmoke1','attackspdsmoke1','atkspdsmoke1','attspdsmoke1','speedattacksmoke1','speedatksmoke1','speedattsmoke1','spdattacksmoke1','spdatksmoke1','spdattsmoke1'],3],
           ['Atk/Def Smoke 2',['attackdefensesmoke','atkdefensesmoke','attdefensesmoke','attackdefencesmoke','atkdefencesmoke','attdefencesmoke','attackdefsmoke','atkdefsmoke','attdefsmoke','defenseattacksmoke','defenseatksmoke','defenseattsmoke','defenceattacksmoke','defenceatksmoke','defenceattsmoke','defattacksmoke','defatksmoke','defattsmoke','attackdefensesmoke2','atkdefensesmoke2','attdefensesmoke2','attackdefencesmoke2','atkdefencesmoke2','attdefencesmoke2','attackdefsmoke2','atkdefsmoke2','attdefsmoke2','defenseattacksmoke2','defenseatksmoke2','defenseattsmoke2','defenceattacksmoke2','defenceatksmoke2','defenceattsmoke2','defattacksmoke2','defatksmoke2','defattsmoke2'],2],
           ['Atk/Def Smoke 1',['attackdefensesmoke1','atkdefensesmoke1','attdefensesmoke1','attackdefencesmoke1','atkdefencesmoke1','attdefencesmoke1','attackdefsmoke1','atkdefsmoke1','attdefsmoke1','defenseattacksmoke1','defenseatksmoke1','defenseattsmoke1','defenceattacksmoke1','defenceatksmoke1','defenceattsmoke1','defattacksmoke1','defatksmoke1','defattsmoke1'],3],
           ['Atk/Res Smoke 2',['attackresistancesmoke','atkresistancesmoke','attresistancesmoke','attackressmoke','atkressmoke','attressmoke','resistanceattacksmoke','resistanceatksmoke','resistanceattsmoke','resattacksmoke','resatksmoke','resattsmoke','attackresistancesmoke2','atkresistancesmoke2','attresistancesmoke2','attackressmoke2','atkressmoke2','attressmoke2','resistanceattacksmoke2','resistanceatksmoke2','resistanceattsmoke2','resattacksmoke2','resatksmoke2','resattsmoke2'],2],
           ['Atk/Res Smoke 1',['attackresistancesmoke1','atkresistancesmoke1','attresistancesmoke1','attackressmoke1','atkressmoke1','attressmoke1','resistanceattacksmoke1','resistanceatksmoke1','resistanceattsmoke1','resattacksmoke1','resatksmoke1','resattsmoke1'],3],
           ['Spd/Def Smoke 2',['speeddefensesmoke','spddefensesmoke','speeddefencesmoke','spddefencesmoke','speeddefsmoke','spddefsmoke','defensespeedsmoke','defensespdsmoke','defencespeedsmoke','defencespdsmoke','defspeedsmoke','defspdsmoke','speeddefensesmoke2','spddefensesmoke2','speeddefencesmoke2','spddefencesmoke2','speeddefsmoke2','spddefsmoke2','defensespeedsmoke2','defensespdsmoke2','defencespeedsmoke2','defencespdsmoke2','defspeedsmoke2','defspdsmoke2'],2],
           ['Spd/Def Smoke 1',['speeddefensesmoke1','spddefensesmoke1','speeddefencesmoke1','spddefencesmoke1','speeddefsmoke1','spddefsmoke1','defensespeedsmoke1','defensespdsmoke1','defencespeedsmoke1','defencespdsmoke1','defspeedsmoke1','defspdsmoke1'],3],
           ['Spd/Res Smoke 2',['speedresistancesmoke','spdresistancesmoke','speedressmoke','spdressmoke','resistancespeedsmoke','resistancespdsmoke','resspeedsmoke','resspdsmoke','speedresistancesmoke2','spdresistancesmoke2','speedressmoke2','spdressmoke2','resistancespeedsmoke2','resistancespdsmoke2','resspeedsmoke2','resspdsmoke2'],2],
           ['Spd/Res Smoke 1',['speedresistancesmoke1','spdresistancesmoke1','speedressmoke1','spdressmoke1','resistancespeedsmoke1','resistancespdsmoke1','resspeedsmoke1','resspdsmoke1'],3],
           ['Def/Res Smoke 2',['defenseresistancesmoke','defenceresistancesmoke','defresistancesmoke','defenseressmoke','defenceressmoke','defressmoke','resistancedefensesmoke','resistancedefencesmoke','resistancedefsmoke','resdefensesmoke','resdefencesmoke','resdefsmoke','defenseresistancesmoke2','defenceresistancesmoke2','defresistancesmoke2','defenseressmoke2','defenceressmoke2','defressmoke2','resistancedefensesmoke2','resistancedefencesmoke2','resistancedefsmoke2','resdefensesmoke2','resdefencesmoke2','resdefsmoke2'],2],
           ['Def/Res Smoke 1',['defenseresistancesmoke1','defenceresistancesmoke1','defresistancesmoke1','defenseressmoke1','defenceressmoke1','defressmoke1','resistancedefensesmoke1','resistancedefencesmoke1','resistancedefsmoke1','resdefensesmoke1','resdefencesmoke1','resdefsmoke1'],3]]
  for i in 0...lookout.length
    for i2 in 0...lookout[i][2]
      stat_skills_2.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  hf=[]
  hf2=[]
  j=find_unit(name,event)
  # Only the first eight - was six until Rival Domains was released - Hone/Fortify skills are allowed, as that's the most that can apply to the unit at once.
  # Tactic skills stack with this list's limit, but allow up to fourteen to be applied
  for i in 0...args.length
    hf.push("Hone Attack 3") if ["honeattack","honeatk","honeatk","honeattack3","honeatk3","honeatk3","fortifyattack","fortifyatk","fortifyatk","fortifyattack3","fortifyatk3","fortifyatk3"].include?(args[i].downcase)
    hf.push("Hone Attack 2") if ["honeattack2","honeatk2","honeatk2","fortifyattack2","fortifyatk2","fortifyatk2"].include?(args[i].downcase)
    hf.push("Hone Attack 1") if ["honeattack1","honeatk1","honeatk1","fortifyattack1","fortifyatk1","fortifyatk1"].include?(args[i].downcase)
    hf.push("Hone Speed 3") if ["honespeed","honespd","honespeed3","honespd3","fortifyspeed","fortifyspd","fortifyspeed3","fortifyspd3"].include?(args[i].downcase)
    hf.push("Hone Speed 2") if ["honespeed2","honespd2","fortifyspeed2","fortifyspd2"].include?(args[i].downcase)
    hf.push("Hone Speed 1") if ["honespeed1","honespd1","fortifyspeed1","fortifyspd1"].include?(args[i].downcase)
    hf.push("Hone Movement") if ["honecavalry","honecav","honehorse","honeflier","honefliers","honearmor","honearmour","honearmors","honearmours"].include?(args[i].downcase)
    hf.push("Hone Dragons") if ["honedragonns","honewyrms","honedragon","honeserpents","honewyrm","honeserpent","honemanaketes","honedrakes","honemanakete","honedrake"].include?(args[i].downcase) && @data[j][1][1]=="Dragon"
    hf.push("Fortify Defense 3") if ["fortifydefense","fortifydefence","fortifydef","fortifydefense3","fortifydefence3","fortifydef3","honedefense","honedefence","honedef","honedefense3","honedefence3","honedef3"].include?(args[i].downcase)
    hf.push("Fortify Defense 2") if ["fortifydefense2","fortifydefence2","fortifydef2","honedefense2","honedefence2","honedef2"].include?(args[i].downcase)
    hf.push("Fortify Defense 1") if ["fortifydefense1","fortifydefence1","fortifydef1","honedefense1","honedefence1","honedef1"].include?(args[i].downcase)
    hf.push("Fortify Resistance 3") if ["fortifyresistance","fortifyres","fortifyresistance3","fortifyres3","honeresistance","honeres","honeresistance3","honeres3"].include?(args[i].downcase)
    hf.push("Fortify Resistance 2") if ["fortifyresistance2","fortifyres2","honeresistance2","honeres2"].include?(args[i].downcase)
    hf.push("Fortify Resistance 1") if ["fortifyresistance1","fortifyres1","honeresistance1","honeres1"].include?(args[i].downcase)
    hf.push("Fortify Movement") if ["fortifycavalry","fortifycav","fortifyhorse","fortifyflier","fortifyfliers","fortifyarmor","fortifyarmour","fortifyarmors","fortifyarmours"].include?(args[i].downcase)
    hf.push("Fortify Dragons") if ["fortifydragonns","fortifywyrms","fortifydragon","fortifyserpents","fortifywyrm","fortifyserpent","fortifymanaketes","fortifydrakes","fortifymanakete","fortifydrake"].include?(args[i].downcase) && @data[j][1][1]=="Dragon"
    hf2.push("Attack Tactic 3") if ["attacktactic","attacktic","attactic","atttactic","attactic","atktactic","attacktactic3","attacktic3","attactic3","atttactic3","attactic3","atktactic3"].include?(args[i].downcase)
    hf2.push("Attack Tactic 2") if ["attacktactic2","attacktic2","attactic2","atttactic2","attactic2","atktactic2"].include?(args[i].downcase)
    hf2.push("Attack Tactic 1") if ["attacktactic1","attacktic1","attactic1","atttactic1","attactic1","atktactic1"].include?(args[i].downcase)
    hf2.push("Speed Tactic 3") if ["speedtactic","spdtactic","speedtactic3","spdtactic3"].include?(args[i].downcase)
    hf2.push("Speed Tactic 2") if ["speedtactic2","spdtactic2"].include?(args[i].downcase)
    hf2.push("Speed Tactic 1") if ["speedtactic1","spdtactic1"].include?(args[i].downcase)
    hf2.push("Defense Tactic 3") if ["defensetactic","defencetactic","deftactic","defensetactic3","defencetactic3","deftactic3"].include?(args[i].downcase)
    hf2.push("Defense Tactic 2") if ["defensetactic2","defencetactic2","deftactic2"].include?(args[i].downcase)
    hf2.push("Defense Tactic 1") if ["defensetactic1","defencetactic1","deftactic1"].include?(args[i].downcase)
    hf2.push("Resistance Tactic 3") if ["resistancetactic","restactic","resistancetactic3","restactic3"].include?(args[i].downcase)
    hf2.push("Resistance Tactic 2") if ["resistancetactic2","restactic2"].include?(args[i].downcase)
    hf2.push("Resistance Tactic 1") if ["resistancetactic1","restactic1"].include?(args[i].downcase)
  end
  for i in 0...8
    stat_skills_2.push(hf[i]) if hf.length>i
  end
  for i in 0...14-[8,hf.length].min
    stat_skills_2.push(hf2[i]) if hf2.length>i
  end
  # Rally skills not stacking with themselves is handled in the apply_stat_skills function, so "unaccepted" duplication is allowed.
  for i in 0...args.length
    stat_skills_2.push("Rally Attack") if ["rallyattack","rallyatt","rallyatk"].include?(args[i].downcase)
    stat_skills_2.push("Rally Speed") if ["rallyspeed","rallyspd"].include?(args[i].downcase)
    stat_skills_2.push("Rally Defense") if ["rallydefense","rallydefence","rallydef"].include?(args[i].downcase)
    stat_skills_2.push("Rally Resistance") if ["rallyresistance","rallyres"].include?(args[i].downcase)
    stat_skills_2.push("Rally Attack/Speed") if ["rallyattackspeed","rallyattackspd","rallyatkspeed","rallyatkspd","rallyattspeed","rallyattspd","rallyspeedattack","rallyspdattack","rallyspeedatk","rallyspdatk","rallyspeedatt","rallyspdatt"].include?(args[i].downcase)
    stat_skills_2.push("Rally Attack/Defense") if ["rallyattackdefense","rallyattackdefence","rallyattackdef","rallyatkdefense","rallyatkdefence","rallyatkdef","rallyattdefense","rallyattdefence","rallyattdef","rallydefenseattack","rallydefenceattack","rallydefattack","rallydefenseatk","rallydefenceatk","rallydefatk","rallydefenseatt","rallydefenceatt","rallydefatt"].include?(args[i].downcase)
    stat_skills_2.push("Rally Attack/Resistance") if ["rallyattackresistance","rallyattackres","rallyatkresistance","rallyatkres","rallyattresistance","rallyattres","rallyresistanceattack","rallyresattack","rallyresistanceatk","rallyresatk","rallyresistanceatt","rallyresatt"].include?(args[i].downcase)
    stat_skills_2.push("Rally Speed/Defense") if ["rallyspeeddefense","rallyspeeddefence","rallyspeeddef","rallyspddefense","rallyspddefence","rallyspddef","rallydefensespeed","rallydefencespeed","rallydefspeed","rallydefensespd","rallydefencespd","rallydefspd"].include?(args[i].downcase)
    stat_skills_2.push("Rally Speed/Resistance") if ["rallyspeedresistance","rallyspeedres","rallyspdresistance","rallyspdres","rallyresistancespeed","rallyresspeed","rallyresistancespd","rallyresspd"].include?(args[i].downcase)
    stat_skills_2.push("Rally Defense/Resistance") if ["rallydefenseresistance","rallydefenseres","rallydefenceresistance","rallydefenceres","rallydefresistance","rallydefres","rallyresistancedefense","rallyresdefense","rallyresistancedefence","rallyresdefence","rallyresistancedef","rallyresdef"].include?(args[i].downcase)
    stat_skills_2.push('Blaze Dance 3') if ['firedance3','blazedance3','attackdance3','atkdance3','attdance3','firedance','blazedance','attackdance','atkdance','attdance'].include?(args[i].downcase)
    stat_skills_2.push('Blaze Dance 2') if ['firedance2','blazedance2','attackdance2','atkdance2','attdance2'].include?(args[i].downcase)
    stat_skills_2.push('Blaze Dance 1') if ['firedance1','blazedance1','attackdance1','atkdance1','attdance1'].include?(args[i].downcase)
    stat_skills_2.push('Gale Dance 3') if ['winddance3','galedance3','speeddance3','spddance3','winddance','galedance','speeddance','spddance'].include?(args[i].downcase)
    stat_skills_2.push('Gale Dance 2') if ['winddance2','galedance2','speeddance2','spddance2'].include?(args[i].downcase)
    stat_skills_2.push('Gale Dance 1') if ['winddance1','galedance1','speeddance1','spddance1'].include?(args[i].downcase)
    stat_skills_2.push('Earth Dance 3') if ['earthdance3','defensedance3','defencedance3','defdance3','earthdance','defensedance','defencedance','defdance'].include?(args[i].downcase)
    stat_skills_2.push('Earth Dance 2') if ['earthdance2','defensedance2','defencedance2','defdance2'].include?(args[i].downcase)
    stat_skills_2.push('Earth Dance 1') if ['earthdance1','defensedance1','defencedance1','defdance1'].include?(args[i].downcase)
    stat_skills_2.push('Torrent Dance 3') if ['waterdance3','torrentdance3','resistancedance3','resdance3','waterdance','torrentdance','resistancedance','resdance'].include?(args[i].downcase)
    stat_skills_2.push('Torrent Dance 2') if ['waterdance2','torrentdance2','resistancedance2','resdance2'].include?(args[i].downcase)
    stat_skills_2.push('Torrent Dance 1') if ['waterdance1','torrentdance1','resistancedance1','resdance1'].include?(args[i].downcase)
    stat_skills_2.push('Geyser Dance 2') if ['geyserdance2','defenseresistancedance2','defenceresistancedance2','defresistancedance2','defenseresdance2','defenceresdance2','defresdance2','resistancedefensedance2','resistancedefencedance2','resistancedefdance2','resdefensedance2','resdefencedance2','resdefdance2','geyserdance','defenseresistancedance','defenceresistancedance','defresistancedance','defenseresdance','defenceresdance','defresdance','resistancedefensedance','resistancedefencedance','resistancedefdance','resdefensedance','resdefencedance','resdefdance'].include?(args[i].downcase)
    stat_skills_2.push('Geyser Dance 1') if ['geyserdance1','defenseresistancedance1','defenceresistancedance1','defresistancedance1','defenseresdance1','defenceresdance1','defresdance1','resistancedefensedance1','resistancedefencedance1','resistancedefdance1','resdefensedance1','resdefencedance1','resdefdance1'].include?(args[i].downcase)
    k=0
    k=event.server.id unless event.server.nil?
    stat_skills_2.push("Rainbow Balm") if ["rainbowbalm","spectrumbalm","omnibalm"].include?(args[i].downcase) && k==330850148261298176
    stat_skills_2.push("Swift-Winds Balm") if ["swift-winds","swift-windsbalm","swiftwinds","swiftwindsbalm"].include?(args[i].downcase)
    stat_skills_2.push("Kindled-Fire Balm") if ["kindled-fire","kindled-firebalm","kindledfire","kindledfirebalm"].include?(args[i].downcase)
    stat_skills_2.push("Solid-Earth Balm") if ["solid-earth","solid-earthbalm","solidearth","solidearthbalm"].include?(args[i].downcase)
    stat_skills_2.push("Still-Water Balm") if ["still-water","still-waterbalm","stillwater","stillwaterbalm"].include?(args[i].downcase)
  end
  return stat_skills_2
end

def make_combat_skill_list(name,event,args) # this is for skills that apply in-combat buffs.  Character name is needed to know which movement Goad/Ward to apply
  args=sever(event.message.text,true).split(" ") if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.downcase}
  stat_skills_3=[]
  lookout=[['Death Blow 3',['deathblow3','fierceblow3','attackblow3','atkblow3','attblow3','deathblow','fierceblow','attackblow','atkblow','attblow'],2],
           ['Death Blow 2',['deathblow2','fierceblow2','attackblow2','atkblow2','attblow2'],2],
           ['Death Blow 1',['deathblow1','fierceblow1','attackblow1','atkblow1','attblow1'],2],
           ['Darting Blow 3',['dartingblow3','sparrowblow3','speedblow3','spdblow3','dartingblow','sparrowblow','speedblow','spdblow'],2],
           ['Darting Blow 2',['dartingblow2','sparrowblow2','speedblow2','spdblow2'],2],
           ['Darting Blow 1',['dartingblow1','sparrowblow1','speedblow1','spdblow1'],2],
           ['Armored Blow 3',['armoredblow3','armouredblow3','defenseblow3','defenceblow3','defblow3','armoredblow','armouredblow','defenseblow','defenceblow','defblow'],2],
           ['Armored Blow 2',['armoredblow2','armouredblow2','defenseblow2','defenceblow2','defblow2'],2],
           ['Armored Blow 1',['armoredblow1','armouredblow1','defenseblow1','defenceblow1','defblow1'],2],
           ['Warding Blow 3',['wardingblow3','resistanceblow3','resblow3','wardedblow3','wardingblow','resistanceblow','resblow','wardedblow'],2],
           ['Warding Blow 2',['wardingblow2','resistanceblow2','resblow2','wardedblow2'],2],
           ['Warding Blow 1',['wardingblow1','resistanceblow1','resblow1','wardedblow1'],2],
           ['Swift Sparrow 2',['swiftsparrow2','attackspeedblow2','atkspeedblow2','attspeedblow2','attackspdblow2','atkspdblow2','attspdblow2','speedattackblow2','spdattackblow2','speedatkblow2','spdatkblow2','speedattblow2','spdattblow2','swiftsparrow','attackspeedblow','atkspeedblow','attspeedblow','attackspdblow','atkspdblow','attspdblow','speedattackblow','spdattackblow','speedatkblow','spdatkblow','speedattblow','spdattblow'],2],
           ['Swift Sparrow 1',['swiftsparrow1','attackspeedblow1','atkspeedblow1','attspeedblow1','attackspdblow1','atkspdblow1','attspdblow1','speedattackblow1','spdattackblow1','speedatkblow1','spdatkblow1','speedattblow1','spdattblow1'],2],
           ['Sturdy Blow 2',['sturdyblow2','attackdefenseblow2','atkdefenseblow2','attdefenseblow2','attackdefenceblow2','atkdefenceblow2','attdefenceblow2','attackdefblow2','atkdefblow2','attdefblow2','defenseattackblow2','defenceattackblow2','defattackblow2','defenseatkblow2','defenceatkblow2','defatkblow2','defenseattblow2','defenceattblow2','defattblow2','sturdyblow','attackdefenseblow','atkdefenseblow','attdefenseblow','attackdefenceblow','atkdefenceblow','attdefenceblow','attackdefblow','atkdefblow','attdefblow','defenseattackblow','defenceattackblow','defattackblow','defenseatkblow','defenceatkblow','defatkblow','defenseattblow','defenceattblow','defattblow'],2],
           ['Sturdy Blow 1',['sturdyblow1','attackdefenseblow1','atkdefenseblow1','attdefenseblow1','attackdefenceblow1','atkdefenceblow1','attdefenceblow1','attackdefblow1','atkdefblow1','attdefblow1','defenseattackblow1','defenceattackblow1','defattackblow1','defenseatkblow1','defenceatkblow1','defatkblow1','defenseattblow1','defenceattblow1','defattblow1'],2],
           ['Mirror Strike 2',['mirrorstrike2','mirrorblow2','attackresistanceblow2','atkresistanceblow2','attresistanceblow2','attackresblow2','atkresblow2','attresblow2','resistanceattackblow2','resattackblow2','resistanceatkblow2','resatkblow2','resistanceattblow2','resattblow2','mirrorstrike','mirrorblow','attackresistanceblow','atkresistanceblow','attresistanceblow','attackresblow','atkresblow','attresblow','resistanceattackblow','resattackblow','resistanceatkblow','resatkblow','resistanceattblow','resattblow'],2],
           ['Mirror Strike 1',['mirrorstrike1','mirrorblow1','attackresistanceblow1','atkresistanceblow1','attresistanceblow1','attackresblow1','atkresblow1','attresblow1','resistanceattackblow1','resattackblow1','resistanceatkblow1','resatkblow1','resistanceattblow1','resattblow1'],2],
           ['Steady Blow 2',['steadyblow2','speeddefenseblow2','spddefenseblow2','speeddefenceblow2','spddefenceblow2','speeddefblow2','spddefblow2','defensespeedblow2','defencespeedblow2','defspeedblow2','defensespdblow2','defencespdblow2','defspdblow2','steadyblow','speeddefenseblow','spddefenseblow','speeddefenceblow','spddefenceblow','speeddefblow','spddefblow','defensespeedblow','defencespeedblow','defspeedblow','defensespdblow','defencespdblow','defspdblow'],2],
           ['Steady Blow 1',['steadyblow1','speeddefenseblow1','spddefenseblow1','speeddefenceblow1','spddefenceblow1','speeddefblow1','spddefblow1','defensespeedblow1','defencespeedblow1','defspeedblow1','defensespdblow1','defencespdblow1','defspdblow1'],2],
           ['Swift Strike 2',['swiftstrike2','swiftblow2','speedresistanceblow2','spdresistanceblow2','speedresblow2','spdresblow2','swiftstrike','swiftblow','speedresistanceblow','spdresistanceblow','speedresblow','spdresblow'],2],
           ['Swift Strike 1',['swiftstrike1','swiftblow1','speedresistanceblow1','spdresistanceblow1','speedresblow1','spdresblow1'],2],
           ['Bracing Blow 2',['bracingblow2','defenseresistanceblow2','defenceresistanceblow2','defresistanceblow2','defenseresblow2','defenceresblow2','defresblow2','resistancedefenseblow2','resdefenseblow2','resistancedefenceblow2','resdefenceblow2','resistancedefblow2','resdefblow2','bracingblow','defenseresistanceblow','defenceresistanceblow','defresistanceblow','defenseresblow','defenceresblow','defresblow','resistancedefenseblow','resdefenseblow','resistancedefenceblow','resdefenceblow','resistancedefblow','resdefblow'],2],
           ['Bracing Blow 1',['bracingblow1','defenseresistanceblow1','defenceresistanceblow1','defresistanceblow1','defenseresblow1','defenceresblow1','defresblow1','resistancedefenseblow1','resdefenseblow1','resistancedefenceblow1','resdefenceblow1','resistancedefblow1','resdefblow1'],2],
           ['Fierce Stance 3',['deathstance3','fiercestance3','attackstance3','atkstance3','attstance3','deathstance','fiercestance','attackstance','atkstance','attstance'],2],
           ['Fierce Stance 2',['deathstance2','fiercestance2','attackstance2','atkstance2','attstance2'],2],
           ['Fierce Stance 1',['deathstance1','fiercestance1','attackstance1','atkstance1','attstance1'],2],
           ['Fierce Breath',['deathbreath','fiercebreath','attackbreath','atkbreath','attbreath'],2],
           ['Darting Stance 3',['dartingstance3','speedstance3','spdstance3','dartingstance','speedstance','spdstance'],2],
           ['Darting Stance 2',['dartingstance2','speedstance2','spdstance2'],2],
           ['Darting Stance 1',['dartingstance1','speedstance1','spdstance1'],2],
           ['Darting Breath',['dartingbreath','speedbreath','spdbreath'],2],
           ['Steady Stance 3',['steadystance3','armouredstance3','armoredstance3','defensestance3','defencestance3','defstance3','armoredstance','armouredstance','armouredstance','defensestance','defencestance','defstance'],2],
           ['Steady Stance 2',['steadystance2','armouredstance2','armoredstance2','defensestance2','defencestance2','defstance2'],2],
           ['Steady Stance 1',['steadystance1','armouredstance1','armoredstance1','defensestance1','defencestance1','defstance1'],2],
           ['Steady Breath',['steadybreath','armouredbreath','armoredbreath','defensebreath','defencebreath','defbreath'],2],
           ['Warding Stance 3',['wardingstance3','resistancestance3','resstance3','wardedstance3','wardingstance','resistancestance','resstance','wardedstance'],2],
           ['Warding Stance 2',['wardingstance2','resistancestance2','resstance2','wardedstance2'],2],
           ['Warding Stance 1',['wardingstance1','resistancestance1','resstance1','wardedstance1'],2],
           ['Warding Breath',['wardingbreath','resistancebreath','resbreath','wardedbreath'],2],
           ['Sparrow Stance 2',['sparrowstance2','attackspeedstance2','atkspeedstance2','attspeedstance2','attackspdstance2','atkspdstance2','attspdstance2','speedattackstance2','spdattackstance2','speedatkstance2','spdatkstance2','speedattstance2','spdattstance2','sparrowstance','attackspeedstance','atkspeedstance','attspeedstance','attackspdstance','atkspdstance','attspdstance','speedattackstance','spdattackstance','speedatkstance','spdatkstance','speedattstance','spdattstance'],2],
           ['Sparrow Stance 1',['sparrowstance1','attackspeedstance1','atkspeedstance1','attspeedstance1','attackspdstance1','atkspdstance1','attspdstance1','speedattackstance1','spdattackstance1','speedatkstance1','spdatkstance1','speedattstance1','spdattstance1'],2],
           ['Sparrow Breath',['sparrowbreath','attackspeedbreath','atkspeedbreath','attspeedbreath','attackspdbreath','atkspdbreath','attspdbreath','speedattackbreath','spdattackbreath','speedatkbreath','spdatkbreath','speedattbreath','spdattbreath'],2],
           ['Sturdy Stance 2',['sturdystance2','attackdefensestance2','atkdefensestance2','attdefensestance2','attackdefencestance2','atkdefencestance2','attdefencestance2','attackdefstance2','atkdefstance2','attdefstance2','defenseattackstance2','defenceattackstance2','defattackstance2','defenseatkstance2','defenceatkstance2','defatkstance2','defenseattstance2','defenceattstance2','defattstance2','sturdystance','attackdefensestance','atkdefensestance','attdefensestance','attackdefencestance','atkdefencestance','attdefencestance','attackdefstance','atkdefstance','attdefstance','defenseattackstance','defenceattackstance','defattackstance','defenseatkstance','defenceatkstance','defatkstance','defenseattstance','defenceattstance','defattstance'],2],
           ['Sturdy Stance 1',['sturdystance1','attackdefensestance1','atkdefensestance1','attdefensestance1','attackdefencestance1','atkdefencestance1','attdefencestance1','attackdefstance1','atkdefstance1','attdefstance1','defenseattackstance1','defenceattackstance1','defattackstance1','defenseatkstance1','defenceatkstance1','defatkstance1','defenseattstance1','defenceattstance1','defattstance1'],2],
           ['Sturdy Breath',['sturdybreath','attackdefensebreath','atkdefensebreath','attdefensebreath','attackdefencebreath','atkdefencebreath','attdefencebreath','attackdefbreath','atkdefbreath','attdefbreath','defenseattackbreath','defenceattackbreath','defattackbreath','defenseatkbreath','defenceatkbreath','defatkbreath','defenseattbreath','defenceattbreath','defattbreath'],2],
           ['Mirror Stance 2',['mirrorstance2','attackresistancestance2','atkresistancestance2','attresistancestance2','attackresstance2','atkresstance2','attresstance2','resistanceattackstance2','resattackstance2','resistanceatkstance2','resatkstance2','resistanceattstance2','resattstance2','mirrorstance','attackresistancestance','atkresistancestance','attresistancestance','attackresstance','atkresstance','attresstance','resistanceattackstance','resattackstance','resistanceatkstance','resatkstance','resistanceattstance','resattstance'],2],
           ['Mirror Stance 1',['mirrorstance1','attackresistancestance1','atkresistancestance1','attresistancestance1','attackresstance1','atkresstance1','attresstance1','resistanceattackstance1','resattackstance1','resistanceatkstance1','resatkstance1','resistanceattstance1','resattstance1'],2],
           ['Mirror Breath',['mirrorbreath','attackresistancebreath','atkresistancebreath','attresistancebreath','attackresbreath','atkresbreath','attresbreath','resistanceattackbreath','resattackbreath','resistanceatkbreath','resatkbreath','resistanceattbreath','resattbreath'],2],
           ['Spd/Def Stance 2',['speeddefensestance2','spddefensestance2','speeddefencestance2','spddefencestance2','speeddefstance2','spddefstance2','defensespeedstance2','defencespeedstance2','defspeedstance2','defensespdstance2','defencespdstance2','defspdstance2','speeddefensestance','spddefensestance','speeddefencestance','spddefencestance','speeddefstance','spddefstance','defensespeedstance','defencespeedstance','defspeedstance','defensespdstance','defencespdstance','defspdstance'],2],
           ['Spd/Def Stance 1',['speeddefensestance1','spddefensestance1','speeddefencestance1','spddefencestance1','speeddefstance1','spddefstance1','defensespeedstance1','defencespeedstance1','defspeedstance1','defensespdstance1','defencespdstance1','defspdstance1'],2],
           ['Spd/Def Breath',['speeddefensebreath','spddefensebreath','speeddefencebreath','spddefencebreath','speeddefbreath','spddefbreath','defensespeedbreath','defencespeedbreath','defspeedbreath','defensespdbreath','defencespdbreath','defspdbreath'],2],
           ['Swift Stance 2',['swiftstance2','speedresistancestance2','spdresistancestance2','speedresstance2','spdresstance2','swiftstance','speedresistancestance','spdresistancestance','speedresstance','spdresstance'],2],
           ['Swift Stance 1',['swiftstance1','speedresistancestance1','spdresistancestance1','speedresstance1','spdresstance1'],2],
           ['Swift Breath',['swiftbreath','speedresistancebreath','spdresistancebreath','speedresbreath','spdresbreath'],2],
           ['Bracing Stance 2',['bracingstance2','defenseresistancestance2','defenceresistancestance2','defresistancestance2','defenseresstance2','defenceresstance2','defresstance2','resistancedefensestance2','resdefensestance2','resistancedefencestance2','resdefencestance2','resistancedefstance2','resdefstance2','bracingstance','defenseresistancestance','defenceresistancestance','defresistancestance','defenseresstance','defenceresstance','defresstance','resistancedefensestance','resdefensestance','resistancedefencestance','resdefencestance','resistancedefstance','resdefstance'],2],
           ['Bracing Stance 1',['bracingstance1','defenseresistancestance1','defenceresistancestance1','defresistancestance1','defenseresstance1','defenceresstance1','defresstance1','resistancedefensestance1','resdefensestance1','resistancedefencestance1','resdefencestance1','resistancedefstance1','resdefstance1'],2],
           ['Bracing Breath',['bracingbreath','defenseresistancebreath','defenceresistancebreath','defresistancebreath','defenseresbreath','defenceresbreath','defresbreath','resistancedefensebreath','resdefensebreath','resistancedefencebreath','resdefencebreath','resistancedefbreath','resdefbreath'],2],
           ['Atk/Spd Bond 3',['attackspeedbond3','atkspeedbond3','attspeedbond3','attackspdbond3','atkspdbond3','attspdbond3','speedattackbond3','speedatkbond3','speedattbond3','spdattackbond3','spdatkbond3','spdattbond3','attackspeedbond','atkspeedbond','attspeedbond','attackspdbond','atkspdbond','attspdbond','speedattackbond','speedatkbond','speedattbond','spdattackbond','spdatkbond','spdattbond'],2],
           ['Atk/Spd Bond 2',['attackspeedbond2','atkspeedbond2','attspeedbond2','attackspdbond2','atkspdbond2','attspdbond2','speedattackbond2','speedatkbond2','speedattbond2','spdattackbond2','spdatkbond2','spdattbond2'],2],
           ['Atk/Spd Bond 1',['attackspeedbond1','atkspeedbond1','attspeedbond1','attackspdbond1','atkspdbond1','attspdbond1','speedattackbond1','speedatkbond1','speedattbond1','spdattackbond1','spdatkbond1','spdattbond1'],2],
           ['Atk/Def Bond 3',['attackdefensebond3','atkdefensebond3','attdefensebond3','attackdefencebond3','atkdefencebond3','attdefencebond3','attackdefbond3','atkdefbond3','attdefbond3','defenseattackbond3','defenseatkbond3','defenseattbond3','defenceattackbond3','defenceatkbond3','defenceattbond3','defattackbond3','defatkbond3','defattbond3','attackdefensebond','atkdefensebond','attdefensebond','attackdefencebond','atkdefencebond','attdefencebond','attackdefbond','atkdefbond','attdefbond','defenseattackbond','defenseatkbond','defenseattbond','defenceattackbond','defenceatkbond','defenceattbond','defattackbond','defatkbond','defattbond'],2],
           ['Atk/Def Bond 2',['attackdefensebond2','atkdefensebond2','attdefensebond2','attackdefencebond2','atkdefencebond2','attdefencebond2','attackdefbond2','atkdefbond2','attdefbond2','defenseattackbond2','defenseatkbond2','defenseattbond2','defenceattackbond2','defenceatkbond2','defenceattbond2','defattackbond2','defatkbond2','defattbond2'],2],
           ['Atk/Def Bond 1',['attackdefensebond1','atkdefensebond1','attdefensebond1','attackdefencebond1','atkdefencebond1','attdefencebond1','attackdefbond1','atkdefbond1','attdefbond1','defenseattackbond1','defenseatkbond1','defenseattbond1','defenceattackbond1','defenceatkbond1','defenceattbond1','defattackbond1','defatkbond1','defattbond1'],2],
           ['Atk/Res Bond 3',['attackresistancebond3','atkresistancebond3','attresistancebond3','attackresbond3','atkresbond3','attresbond3','resistanceattackbond3','resistanceatkbond3','resistanceattbond3','resattackbond3','resatkbond3','resattbond3','attackresistancebond','atkresistancebond','attresistancebond','attackresbond','atkresbond','attresbond','resistanceattackbond','resistanceatkbond','resistanceattbond','resattackbond','resatkbond','resattbond'],2],
           ['Atk/Res Bond 2',['attackresistancebond2','atkresistancebond2','attresistancebond2','attackresbond2','atkresbond2','attresbond2','resistanceattackbond2','resistanceatkbond2','resistanceattbond2','resattackbond2','resatkbond2','resattbond2','flyingattackresistancebond','flyingatkresistancebond','flyingattresistancebond','flyingattackresbond','flyingatkresbond','flyingattresbond','flyingresistanceattackbond','flyingresistanceatkbond','flyingresistanceattbond','flyingresattackbond','flyingresatkbond','flyingresattbond'],2],
           ['Atk/Res Bond 1',['attackresistancebond1','atkresistancebond1','attresistancebond1','attackresbond1','atkresbond1','attresbond1','resistanceattackbond1','resistanceatkbond1','resistanceattbond1','resattackbond1','resatkbond1','resattbond1'],2],
           ['Spd/Def Bond 3',['speeddefensebond3','spddefensebond3','speeddefencebond3','spddefencebond3','speeddefbond3','spddefbond3','defensespeedbond3','defensespdbond3','defencespeedbond3','defencespdbond3','defspeedbond3','defspdbond3','speeddefensebond','spddefensebond','speeddefencebond','spddefencebond','speeddefbond','spddefbond','defensespeedbond','defensespdbond','defencespeedbond','defencespdbond','defspeedbond','defspdbond'],2],
           ['Spd/Def Bond 2',['speeddefensebond2','spddefensebond2','speeddefencebond2','spddefencebond2','speeddefbond2','spddefbond2','defensespeedbond2','defensespdbond2','defencespeedbond2','defencespdbond2','defspeedbond2','defspdbond2'],2],
           ['Spd/Def Bond 1',['speeddefensebond1','spddefensebond1','speeddefencebond1','spddefencebond1','speeddefbond1','spddefbond1','defensespeedbond1','defensespdbond1','defencespeedbond1','defencespdbond1','defspeedbond1','defspdbond1'],2],
           ['Spd/Res Bond 3',['speedresistancebond3','spdresistancebond3','speedresbond3','spdresbond3','resistancespeedbond3','resistancespdbond3','resspeedbond3','resspdbond3','speedresistancebond','spdresistancebond','speedresbond','spdresbond','resistancespeedbond','resistancespdbond','resspeedbond','resspdbond'],2],
           ['Spd/Res Bond 2',['speedresistancebond2','spdresistancebond2','speedresbond2','spdresbond2','resistancespeedbond2','resistancespdbond2','resspeedbond2','resspdbond2'],2],
           ['Spd/Res Bond 1',['speedresistancebond1','spdresistancebond1','speedresbond1','spdresbond1','resistancespeedbond1','resistancespdbond1','resspeedbond1','resspdbond1'],2],
           ['Def/Res Bond 3',['defenseresistancebond3','defenceresistancebond3','defresistancebond3','defenseresbond3','defenceresbond3','defresbond3','resistancedefensebond3','resistancedefencebond3','resistancedefbond3','resdefensebond3','resdefencebond3','resdefbond3','defenseresistancebond','defenceresistancebond','defresistancebond','defenseresbond','defenceresbond','defresbond','resistancedefensebond','resistancedefencebond','resistancedefbond','resdefensebond','resdefencebond','resdefbond'],2],
           ['Def/Res Bond 2',['defenseresistancebond2','defenceresistancebond2','defresistancebond2','defenseresbond2','defenceresbond2','defresbond2','resistancedefensebond2','resistancedefencebond2','resistancedefbond2','resdefensebond2','resdefencebond2','resdefbond2'],2],
           ['Def/Res Bond 1',['defenseresistancebond1','defenceresistancebond1','defresistancebond1','defenseresbond1','defenceresbond1','defresbond1','resistancedefensebond1','resistancedefencebond1','resistancedefbond1','resdefensebond1','resdefencebond1','resdefbond1'],2],
           ['Spectrum Bond',['spectrumbond','allbond','bondspectrum','bondall'],2],
           ['Brazen Atk/Spd 3',['brazenattackspeed3','brazenatkspeed3','brazenattspeed3','brazenattackspd3','brazenatkspd3','brazenattspd3','brazenspeedattack3','brazenspeedatk3','brazenspeedatt3','brazenspdattack3','brazenspdatk3','brazenspdatt3','brazenattackspeed','brazenatkspeed','brazenattspeed','brazenattackspd','brazenatkspd','brazenattspd','brazenspeedattack','brazenspeedatk','brazenspeedatt','brazenspdattack','brazenspdatk','brazenspdatt'],2],
           ['Brazen Atk/Spd 2',['brazenattackspeed2','brazenatkspeed2','brazenattspeed2','brazenattackspd2','brazenatkspd2','brazenattspd2','brazenspeedattack2','brazenspeedatk2','brazenspeedatt2','brazenspdattack2','brazenspdatk2','brazenspdatt2'],2],
           ['Brazen Atk/Spd 1',['brazenattackspeed1','brazenatkspeed1','brazenattspeed1','brazenattackspd1','brazenatkspd1','brazenattspd1','brazenspeedattack1','brazenspeedatk1','brazenspeedatt1','brazenspdattack1','brazenspdatk1','brazenspdatt1'],2],
           ['Brazen Atk/Def 3',['brazenattackdefense3','brazenatkdefense3','brazenattdefense3','brazenattackdefence3','brazenatkdefence3','brazenattdefence3','brazenattackdef3','brazenatkdef3','brazenattdef3','brazendefenseattack3','brazendefenseatk3','brazendefenseatt3','brazendefenceattack3','brazendefenceatk3','brazendefenceatt3','brazendefattack3','brazendefatk3','brazendefatt3','brazenattackdefense','brazenatkdefense','brazenattdefense','brazenattackdefence','brazenatkdefence','brazenattdefence','brazenattackdef','brazenatkdef','brazenattdef','brazendefenseattack','brazendefenseatk','brazendefenseatt','brazendefenceattack','brazendefenceatk','brazendefenceatt','brazendefattack','brazendefatk','brazendefatt'],2],
           ['Brazen Atk/Def 2',['brazenattackdefense2','brazenatkdefense2','brazenattdefense2','brazenattackdefence2','brazenatkdefence2','brazenattdefence2','brazenattackdef2','brazenatkdef2','brazenattdef2','brazendefenseattack2','brazendefenseatk2','brazendefenseatt2','brazendefenceattack2','brazendefenceatk2','brazendefenceatt2','brazendefattack2','brazendefatk2','brazendefatt2'],2],
           ['Brazen Atk/Def 1',['brazenattackdefense1','brazenatkdefense1','brazenattdefense1','brazenattackdefence1','brazenatkdefence1','brazenattdefence1','brazenattackdef1','brazenatkdef1','brazenattdef1','brazendefenseattack1','brazendefenseatk1','brazendefenseatt1','brazendefenceattack1','brazendefenceatk1','brazendefenceatt1','brazendefattack1','brazendefatk1','brazendefatt1'],2],
           ['Brazen Atk/Res 3',['brazenattackresistance3','brazenatkresistance3','brazenattresistance3','brazenattackres3','brazenatkres3','brazenattres3','brazenresistanceattack3','brazenresistanceatk3','brazenresistanceatt3','brazenresattack3','brazenresatk3','brazenresatt3','brazenattackresistance','brazenatkresistance','brazenattresistance','brazenattackres','brazenatkres','brazenattres','brazenresistanceattack','brazenresistanceatk','brazenresistanceatt','brazenresattack','brazenresatk','brazenresatt'],2],
           ['Brazen Atk/Res 2',['brazenattackresistance2','brazenatkresistance2','brazenattresistance2','brazenattackres2','brazenatkres2','brazenattres2','brazenresistanceattack2','brazenresistanceatk2','brazenresistanceatt2','brazenresattack2','brazenresatk2','brazenresatt2'],2],
           ['Brazen Atk/Res 1',['brazenattackresistance1','brazenatkresistance1','brazenattresistance1','brazenattackres1','brazenatkres1','brazenattres1','brazenresistanceattack1','brazenresistanceatk1','brazenresistanceatt1','brazenresattack1','brazenresatk1','brazenresatt1'],2],
           ['Brazen Spd/Def 3',['brazenspeeddefense3','brazenspddefense3','brazenspeeddefence3','brazenspddefence3','brazenspeeddef3','brazenspddef3','brazendefensespeed3','brazendefensespd3','brazendefencespeed3','brazendefencespd3','brazendefspeed3','brazendefspd3','brazenspeeddefense','brazenspddefense','brazenspeeddefence','brazenspddefence','brazenspeeddef','brazenspddef','brazendefensespeed','brazendefensespd','brazendefencespeed','brazendefencespd','brazendefspeed','brazendefspd'],2],
           ['Brazen Spd/Def 2',['brazenspeeddefense2','brazenspddefense2','brazenspeeddefence2','brazenspddefence2','brazenspeeddef2','brazenspddef2','brazendefensespeed2','brazendefensespd2','brazendefencespeed2','brazendefencespd2','brazendefspeed2','brazendefspd2'],2],
           ['Brazen Spd/Def 1',['brazenspeeddefense1','brazenspddefense1','brazenspeeddefence1','brazenspddefence1','brazenspeeddef1','brazenspddef1','brazendefensespeed1','brazendefensespd1','brazendefencespeed1','brazendefencespd1','brazendefspeed1','brazendefspd1'],2],
           ['Brazen Spd/Res 3',['brazenspeedresistance3','brazenspdresistance3','brazenspeedres3','brazenspdres3','brazenresistancespeed3','brazenresistancespd3','brazenresspeed3','brazenresspd3','brazenspeedresistance','brazenspdresistance','brazenspeedres','brazenspdres','brazenresistancespeed','brazenresistancespd','brazenresspeed','brazenresspd'],2],
           ['Brazen Spd/Res 2',['brazenspeedresistance2','brazenspdresistance2','brazenspeedres2','brazenspdres2','brazenresistancespeed2','brazenresistancespd2','brazenresspeed2','brazenresspd2'],2],
           ['Brazen Spd/Res 1',['brazenspeedresistance1','brazenspdresistance1','brazenspeedres1','brazenspdres1','brazenresistancespeed1','brazenresistancespd1','brazenresspeed1','brazenresspd1'],2],
           ['Brazen Def/Res 3',['brazendefenseresistance3','brazendefenceresistance3','brazendefresistance3','brazendefenseres3','brazendefenceres3','brazendefres3','brazenresistancedefense3','brazenresistancedefence3','brazenresistancedef3','brazenresdefense3','brazenresdefence3','brazenresdef3','brazendefenseresistance','brazendefenceresistance','brazendefresistance','brazendefenseres','brazendefenceres','brazendefres','brazenresistancedefense','brazenresistancedefence','brazenresistancedef','brazenresdefense','brazenresdefence','brazenresdef'],2],
           ['Brazen Def/Res 2',['brazendefenseresistance2','brazendefenceresistance2','brazendefresistance2','brazendefenseres2','brazendefenceres2','brazendefres2','brazenresistancedefense2','brazenresistancedefence2','brazenresistancedef2','brazenresdefense2','brazenresdefence2','brazenresdef2'],2],
           ['Brazen Def/Res 1',['brazendefenseresistance1','brazendefenceresistance1','brazendefresistance1','brazendefenseres1','brazendefenceres1','brazendefres1','brazenresistancedefense1','brazenresistancedefence1','brazenresistancedef1','brazenresdefense1','brazenresdefence1','brazenresdef1'],2],
           ['Brazen Spectrum',['brazenspectrum','brazenall','allbrazen','spectrumbrazen'],2],
           ['Dragonskin',['dragonskin','wyrmskin','dracoskin'],2],
           ['Fire Boost 3',['fireboost3','blazeboost3','attackboost3','atkboost3','attboost3','fireboost','blazeboost','attackboost','atkboost','attboost'],2],
           ['Fire Boost 2',['fireboost2','blazeboost2','attackboost2','atkboost2','attboost2'],2],
           ['Fire Boost 1',['fireboost1','blazeboost1','attackboost1','atkboost1','attboost1'],2],
           ['Wind Boost 3',['windboost3','galeboost3','speedboost3','spdboost3','windboost','galeboost','speedboost','spdboost'],2],
           ['Wind Boost 2',['windboost2','galeboost2','speedboost2','spdboost2'],2],
           ['Wind Boost 1',['windboost1','galeboost1','speedboost1','spdboost1'],2],
           ['Earth Boost 3',['earthboost3','defenseboost3','defenceboost3','defboost3','earthboost','defenseboost','defenceboost','defboost'],2],
           ['Earth Boost 2',['earthboost2','defenseboost2','defenceboost2','defboost2'],2],
           ['Earth Boost 1',['earthboost1','defenseboost1','defenceboost1','defboost1'],2],
           ['Water Boost 3',['waterboost3','torrentboost3','resistanceboost3','resboost3','waterboost','torrentboost','resistanceboost','resboost'],2],
           ['Water Boost 2',['waterboost2','torrentboost2','resistanceboost2','resboost2'],2],
           ['Water Boost 1',['waterboost1','torrentboost1','resistanceboost1','resboost1'],2]]
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
      a=@dev_units[dv][9].reject{|q| q.include?("~~")}
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
  for i in 0...args.length
    hf.push("Spur Attack 3") if ["spurattack","spuratk","spuratk","spurattack3","spuratk3","spuratk3"].include?(args[i].downcase)
    hf.push("Spur Attack 2") if ["spurattack2","spuratk2","spuratk2"].include?(args[i].downcase)
    hf.push("Spur Attack 1") if ["spurattack1","spuratk1","spuratk1"].include?(args[i].downcase)
    hf.push("Spur Speed 3") if ["spurspeed","spurspd","spurspeed3","spurspd3"].include?(args[i].downcase)
    hf.push("Spur Speed 2") if ["spurspeed2","spurspd2"].include?(args[i].downcase)
    hf.push("Spur Speed 1") if ["spurspeed1","spurspd1"].include?(args[i].downcase)
    hf.push("Spur Defense 3") if ["spurdefense","spurdefence","spurdef","spurdefense3","spurdefence3","spurdef3"].include?(args[i].downcase)
    hf.push("Spur Defense 2") if ["spurdefense2","spurdefence2","spurdef2"].include?(args[i].downcase)
    hf.push("Spur Defense 1") if ["spurdefense1","spurdefence1","spurdef1"].include?(args[i].downcase)
    hf.push("Spur Resistance 3") if ["spurresistance","spurres","spurresistance3","spurres3"].include?(args[i].downcase)
    hf.push("Spur Resistance 2") if ["spurresistance2","spurres2"].include?(args[i].downcase)
    hf.push("Spur Resistance 1") if ["spurresistance1","spurres1"].include?(args[i].downcase)
    hf.push("Spur Atk Spd 2") if ["spurattackspeed2","spuratkspeed2","spuratkspeed2","spurattackspd2","spuratkspd2","spuratkspd2","spurspeedattack2","spurspdattack2","spurspeedatk2","spurspdatk2","spurspeedatt2","spurspdatt2","spurattackspeed","spuratkspeed","spuratkspeed","spurattackspd","spuratkspd","spuratkspd","spurspeedattack","spurspdattack","spurspeedatk","spurspdatk","spurspeedatt","spurspdatt"].include?(args[i].downcase)
    hf.push("Spur Atk Spd 1") if ["spurattackspeed1","spuratkspeed1","spuratkspeed1","spurattackspd1","spuratkspd1","spuratkspd1","spurspeedattack1","spurspdattack1","spurspeedatk1","spurspdatk1","spurspeedatt1","spurspdatt1"].include?(args[i].downcase)
    hf.push("Spur Atk Def 2") if ["spurattackdefense2","spuratkdefense2","spuratkdefense2","spurattackdefence2","spuratkdefence2","spuratkdefence2","spurattackdef2","spuratkdef2","spuratkdef2","spurdefenseattack2","spurdefenceattack2","spurdefattack2","spurdefenseatk2","spurdefenceatk2","spurdefatk2","spurdefenseatt2","spurdefenceatt2","spurdefatt2","spurattackdefense","spuratkdefense","spuratkdefense","spurattackdefence","spuratkdefence","spuratkdefence","spurattackdef","spuratkdef","spuratkdef","spurdefenseattack","spurdefenceattack","spurdefattack","spurdefenseatk","spurdefenceatk","spurdefatk","spurdefenseatt","spurdefenceatt","spurdefatt"].include?(args[i].downcase)
    hf.push("Spur Atk Def 1") if ["spurattackdefense1","spuratkdefense1","spuratkdefense1","spurattackdefence1","spuratkdefence1","spuratkdefence1","spurattackdef1","spuratkdef1","spuratkdef1","spurdefenseattack1","spurdefenceattack1","spurdefattack1","spurdefenseatk1","spurdefenceatk1","spurdefatk1","spurdefenseatt1","spurdefenceatt1","spurdefatt1"].include?(args[i].downcase)
    hf.push("Spur Atk Res 2") if ["spurattackresistance2","spuratkresistance2","spuratkresistance2","spurattackres2","spuratkres2","spuratkres2","spurresistanceattack2","spurresattack2","spurresistanceatk2","spurresatk2","spurresistanceatt2","spurresatt2","spurattackresistance","spuratkresistance","spuratkresistance","spurattackres","spuratkres","spuratkres","spurresistanceattack","spurresattack","spurresistanceatk","spurresatk","spurresistanceatt","spurresatt"].include?(args[i].downcase)
    hf.push("Spur Atk Res 1") if ["spurattackresistance1","spuratkresistance1","spuratkresistance1","spurattackres1","spuratkres1","spuratkres1","spurresistanceattack1","spurresattack1","spurresistanceatk1","spurresatk1","spurresistanceatt1","spurresatt1"].include?(args[i].downcase)
    hf.push("Spur Spd Def 2") if ["spurspeeddefense2","spurspddefense2","spurspeeddefence2","spurspddefence2","spurspeeddef2","spurspddef2","spurdefensespeed2","spurdefencespeed2","spurdefspeed2","spurdefensespd2","spurdefencespd2","spurdefspd2","spurspeeddefense","spurspddefense","spurspeeddefence","spurspddefence","spurspeeddef","spurspddef","spurdefensespeed","spurdefencespeed","spurdefspeed","spurdefensespd","spurdefencespd","spurdefspd"].include?(args[i].downcase)
    hf.push("Spur Spd Def 1") if ["spurspeeddefense1","spurspddefense1","spurspeeddefence1","spurspddefence1","spurspeeddef1","spurspddef1","spurdefensespeed1","spurdefencespeed1","spurdefspeed1","spurdefensespd1","spurdefencespd1","spurdefspd1"].include?(args[i].downcase)
    hf.push("Spur Spd Res 2") if ["spurspeedresistance2","spurspdresistance2","spurspeedres2","spurspdres2","spurresistancespeed2","spurresspeed2","spurresistancespd2","spurresspd2","spurspeedresistance","spurspdresistance","spurspeedres","spurspdres","spurresistancespeed","spurresspeed","spurresistancespd","spurresspd"].include?(args[i].downcase)
    hf.push("Spur Spd Res 1") if ["spurspeedresistance1","spurspdresistance1","spurspeedres1","spurspdres1","spurresistancespeed1","spurresspeed1","spurresistancespd1","spurresspd1"].include?(args[i].downcase)
    hf.push("Spur Def Res 2") if ["spurdefenseresistance2","spurdefenceresistance2","spurdefresistance2","spurdefenseres2","spurdefenceres2","spurdefres2","spurresistancedefense2","spurresdefense2","spurresistancedefence2","spurresdefence2","spurresistancedef2","spurresdef2","spurdefenseresistance","spurdefenceresistance","spurdefresistance","spurdefenseres","spurdefenceres","spurdefres","spurresistancedefense","spurresdefense","spurresistancedefence","spurresdefence","spurresistancedef","spurresdef"].include?(args[i].downcase)
    hf.push("Spur Def Res 1") if ["spurdefenseresistance1","spurdefenceresistance1","spurdefresistance1","spurdefenseres1","spurdefenceres1","spurdefres1","spurresistancedefense1","spurresdefense1","spurresistancedefence1","spurresdefence1","spurresistancedef1","spurresdef1"].include?(args[i].downcase)
    hf.push("Goad Movement") if ["goadcavalry","goadcav","goadhorse","goadflier","goadfliers","goadarmor","goadarmour","goadarmors","goadarmours"].include?(args[i].downcase)
    hf.push("Goad Dragons") if ["goaddragonns","goadwyrms","goaddragon","goadserpents","goadwyrm","goadserpent","goadmanaketes","goaddrakes","goadmanakete","goaddrake"].include?(args[i].downcase) && @data[j][1][1]=="Dragon"
    hf.push("Ward Movement") if ["wardcavalry","wardcav","wardhorse","wardflier","wardfliers","wardarmor","wardarmour","wardarmors","wardarmours"].include?(args[i].downcase)
    hf.push("Ward Dragons") if ["warddragonns","wardwyrms","warddragon","wardserpents","wardwyrm","wardserpent","wardmanaketes","warddrakes","wardmanakete","warddrake"].include?(args[i].downcase) && @data[j][1][1]=="Dragon"
    hf.push("Spur Spectrum") if ["spurspectrum","spurall","spectrumspur","allspur"].include?(args[i].downcase)
    hf2.push("Drive Attack 2") if ["driveattack","driveatk","driveatk","driveattack2","driveatk2","driveatk2"].include?(args[i].downcase)
    hf2.push("Drive Attack 1") if ["driveattack1","driveatk1","driveatk1"].include?(args[i].downcase)
    hf2.push("Drive Speed 2") if ["drivespeed","drivespd","drivespeed2","drivespd2"].include?(args[i].downcase)
    hf2.push("Drive Speed 1") if ["drivespeed1","drivespd1"].include?(args[i].downcase)
    hf2.push("Drive Defense 2") if ["drivedefense","drivedefence","drivedef","drivedefense2","drivedefence2","drivedef2"].include?(args[i].downcase)
    hf2.push("Drive Defense 1") if ["drivedefense1","drivedefence1","drivedef1"].include?(args[i].downcase)
    hf2.push("Drive Resistance 2") if ["driveresistance","driveres","driveresistance2","driveres2"].include?(args[i].downcase)
    hf2.push("Drive Resistance 1") if ["driveresistance1","driveres1"].include?(args[i].downcase)
    hf2.push("Drive Atk Spd 1") if ["driveattackspeed1","driveatkspeed1","driveatkspeed1","driveattackspd1","driveatkspd1","driveatkspd1","drivespeedattack1","drivespdattack1","drivespeedatk1","drivespdatk1","drivespeedatt1","drivespdatt1","driveattackspeed","driveatkspeed","driveatkspeed","driveattackspd","driveatkspd","driveatkspd","drivespeedattack","drivespdattack","drivespeedatk","drivespdatk","drivespeedatt","drivespdatt"].include?(args[i].downcase)
    hf2.push("Drive Atk Def 1") if ["driveattackdefense1","driveatkdefense1","driveatkdefense1","driveattackdefence1","driveatkdefence1","driveatkdefence1","driveattackdef1","driveatkdef1","driveatkdef1","drivedefenseattack1","drivedefenceattack1","drivedefattack1","drivedefenseatk1","drivedefenceatk1","drivedefatk1","drivedefenseatt1","drivedefenceatt1","drivedefatt1","driveattackdefense","driveatkdefense","driveatkdefense","driveattackdefence","driveatkdefence","driveatkdefence","driveattackdef","driveatkdef","driveatkdef","drivedefenseattack","drivedefenceattack","drivedefattack","drivedefenseatk","drivedefenceatk","drivedefatk","drivedefenseatt","drivedefenceatt","drivedefatt"].include?(args[i].downcase)
    hf2.push("Drive Atk Res 1") if ["driveattackresistance1","driveatkresistance1","driveatkresistance1","driveattackres1","driveatkres1","driveatkres1","driveresistanceattack1","driveresattack1","driveresistanceatk1","driveresatk1","driveresistanceatt1","driveresatt1","driveattackresistance","driveatkresistance","driveatkresistance","driveattackres","driveatkres","driveatkres","driveresistanceattack","driveresattack","driveresistanceatk","driveresatk","driveresistanceatt","driveresatt"].include?(args[i].downcase)
    hf2.push("Drive Spd Def 1") if ["drivespeeddefense1","drivespddefense1","drivespeeddefence1","drivespddefence1","drivespeeddef1","drivespddef1","drivedefensespeed1","drivedefencespeed1","drivedefspeed1","drivedefensespd1","drivedefencespd1","drivedefspd1","drivespeeddefense","drivespddefense","drivespeeddefence","drivespddefence","drivespeeddef","drivespddef","drivedefensespeed","drivedefencespeed","drivedefspeed","drivedefensespd","drivedefencespd","drivedefspd"].include?(args[i].downcase)
    hf2.push("Drive Spd Res 1") if ["drivespeedresistance1","drivespdresistance1","drivespeedres1","drivespdres1","driveresistancespeed1","driveresspeed1","driveresistancespd1","driveresspd1","drivespeedresistance","drivespdresistance","drivespeedres","drivespdres","driveresistancespeed","driveresspeed","driveresistancespd","driveresspd"].include?(args[i].downcase)
    hf2.push("Drive Def Res 1") if ["drivedefenseresistance1","drivedefenceresistance1","drivedefresistance1","drivedefenseres1","drivedefenceres1","drivedefres1","driveresistancedefense1","driveresdefense1","driveresistancedefence1","driveresdefence1","driveresistancedef1","driveresdef1","drivedefenseresistance","drivedefenceresistance","drivedefresistance","drivedefenseres","drivedefenceres","drivedefres","driveresistancedefense","driveresdefense","driveresistancedefence","driveresdefence","driveresistancedef","driveresdef"].include?(args[i].downcase)
    hf2.push("Drive Spectrum") if ["drivespectrum","driveall","spectrumdrive","alldrive"].include?(args[i].downcase)
  end
  for i in 0...8
    stat_skills_3.push(hf[i]) if hf.length>i
  end
  for i in 0...14-[8,hf.length].min
    stat_skills_3.push(hf2[i]) if hf2.length>i
  end
  return stat_skills_3
end

def pick_thumbnail(event,j,bot)
  data_load()
  d=@data[j]
  return "http://vignette.wikia.nocookie.net/fireemblem/images/0/04/Kiran.png" if d[0]=='Kiran'
  return bot.user(d[23]).avatar_url if d.length>23 && !d[23].nil? && d[23].is_a?(Bignum)
  return "https://cdn.discordapp.com/emojis/418140222530912256.png" if d[0]=="Nino" && (event.message.text.downcase.include?('face') || rand(100)==0)
  return "https://cdn.discordapp.com/emojis/420339780421812227.png" if d[0]=="Amelia" && (event.message.text.downcase.include?('face') || rand(1000)==0)
  return "https://cdn.discordapp.com/emojis/420339781524783114.png" if d[0]=="Reinhardt(Bonds)" && (event.message.text.downcase.include?('grin') || rand(100)==0)
  return "https://cdn.discordapp.com/emojis/437515327652364288.png" if d[0]=="Reinhardt(World)" && (event.message.text.downcase.include?('grin') || rand(100)==0)
  return "https://cdn.discordapp.com/emojis/437519293240836106.png" if d[0]=="Arden" && (event.message.text.downcase.include?('woke') || rand(100)==0)
  return "https://cdn.discordapp.com/emojis/420360385862828052.png" if d[0]=="Sakura" && event.message.text.downcase.include?("mathoo's")
  return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{d[0]}/Face_FC.png"
end

def unit_color(event,j,mode=0,m=false,chain=false)
  xcolor=0xFFD800
  # Weapon colors
  xcolor=0xB32400 if @data[j][1][0]=='Red'
  xcolor=0x208EFB if @data[j][1][0]=='Blue'
  xcolor=0x01AD00 if @data[j][1][0]=='Green'
  xcolor=0xC1CCD6 if @data[j][1][0]=='Colorless'
  unless chain
    # Elemental colors
    xcolor=0xF2463A if @data[j][2][0]=='Fire'
    xcolor=0x66DAFA if @data[j][2][0]=='Water'
    xcolor=0x7AE970 if @data[j][2][0]=='Wind'
    xcolor=0xDE5F09 if @data[j][2][0]=='Earth'
    xcolor=0x5000A0 if @data[j][2][0]=='Dark'
  end
  # Special colors
  xcolor=0xFFABAF if @data[j][0]=='Sakura' && m
  xcolor=0x9400D3 if @data[j][0]=='Kiran'
  return [xcolor/256/256, (xcolor/256)%256, xcolor%256] if mode==1
  return xcolor
end

def colored_healers?(event)
  data_load()
  g=get_markers(event)
  return @data.reject{|q| !has_any?(g, q[22]) || q[1][1]!='Healer'}.map{|q| q[1][0]}.uniq.length>1
end

def colored_daggers?(event)
  data_load()
  g=get_markers(event)
  return @data.reject{|q| !has_any?(g, q[22]) || q[1][1]!='Dagger'}.map{|q| q[1][0]}.uniq.length>1
end

def colorless_blades?(event)
  data_load()
  g=get_markers(event)
  return @data.reject{|q| !has_any?(g, q[22]) || q[1][1]!='Blade'}.map{|q| q[1][0]}.uniq.length>3
end

def colorless_tomes?(event)
  data_load()
  g=get_markers(event)
  return @data.reject{|q| !has_any?(g, q[22]) || q[1][1]!='Tome'}.map{|q| q[1][0]}.uniq.length>3
end

def unit_clss(event,j,name=nil)
  w=@data[j][1][1]
  w='Sword' if @data[j][1][0]=='Red' && w=='Blade'
  w='Lance' if @data[j][1][0]=='Blue' && w=='Blade'
  w='Axe' if @data[j][1][0]=='Green' && w=='Blade'
  w='Rod' if @data[j][1][0]=='Colorless' && w=='Blade'
  if @data[j][1][1]!=w
    w="*#{w}* (#{@data[j][1][0]} #{@data[j][1][1]})"
  elsif ['Tome', 'Dragon', 'Bow'].include?(w) || (w=='Healer' && colored_healers?(event)) || (w=='Dagger' && colored_daggers?(event))
    w="*#{@data[j][1][0]} #{@data[j][1][1]}*"
  elsif @data[j][1][0]=='Gold'
    w="*#{w}*"
  else
    w="*#{w}* (#{@data[j][1][0]})"
  end
  w="*#{@data[j][1][2]} Mage* (#{@data[j][1][0]} Tome)" if w[w.length-6,6]==" Tome*" && !@data[j][1][2].nil?
  w="*#{@data[j][1][0]} Mage* (#{@data[j][1][0]} Tome)" if w[w.length-6,6]==" Tome*" && @data[j][1][2].nil?
  w="*>Unknown<*" if @data[j][1].nil? || @data[j][1][0].nil? || @data[j][1][0].length<=0
  w="*Mage* (Tome)" if name=='Robin (Shared stats)'
  m=@data[j][3]
  m=">Unknown<" if @data[j][3].nil? || @data[j][3].length<=0
  return "Weapon type: #{w}\nMovement type: *#{m}*"
end

def skill_tier(name,event)
  data_load()
  j=find_skill(name,event)
  return 1 if @skills[j][8]=='-'
  return 1+skill_tier(@skills[j][8].gsub('*','').split(' or ')[0],event) if @skills[j][8].include?(' or ')
  return 1+skill_tier(@skills[j][8].gsub('*','').split(', ')[0],event) if @skills[j][8].include?(', ')
  return 1+skill_tier(@skills[j][8].gsub('*',''),event)
end

def disp_stats(bot,name,weapon,event,ignore=false)
  if name.is_a?(Array)
    for i in 0...name.length
      disp_stats(bot,name[i],weapon,event,ignore)
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
  args=sever(s.gsub(',','').gsub('/',''),true).split(" ")
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  for i in 0...blessing.length
    blessing[i]=nil if i>=3
  end
  blessing.compact!
  args.compact!
  if name.nil?
    if args.nil? || args.length<1
      event.respond "No unit was included" unless ignore
      return nil
    end
  end
  unless ignore || (!name.nil? && name != '')
    args2=args.join(' ').split(' ')
    name=args.join('')
    data_load()
    # Find the most accurate unit name among the remaining inputs
    if find_unit(name,event)<0
      for i in 0...args.length-1
        args[args.length-1]=nil
        args.compact!
        name=@data[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
      end
      if find_unit(name,event)<0
        for j in 0...args2.length-1
          args2[0]=nil
          args2.compact!
          args=args2.join(' ').split(' ')
          name=@data[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
          for i in 0...args.length-1
            args[args.length-1]=nil
            args.compact!
            name=@data[find_unit(args.join('').downcase,event)][0] if find_unit(name,event)<0 && find_unit(args.join('').downcase,event)>=0
          end
        end
      end
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
      weaponz=@dev_units[dv][6].reject{|q| q.include?("~~")}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(" (+) ")
        w=weapon.split(" (+) ")
        weapon=w[0]
        refinement=w[1].gsub(" Mode","")
      else
        refinement=nil
      end
    elsif @dev_lowlifes.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name)
      event.respond "Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats."
    else
      event.respond "Mathoo does not have that character.  Showing neutral stats."
    end
  end
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  tempest=(args.map{|q| q.downcase}.include?('tempest'))
  if " #{event.message.text.downcase} ".include?(" summoned ")
    uskl=unit_skills(name,event,true)[0].reject{|q| q.include?("~~")}
    weapon='-'
    weapon=uskl[uskl.length-1] if uskl.length>0
    summoner='-'
    tempest=false
    stat_skills=[]
    stat_skills2=[]
    refinement=nil
  end
  w2=@skills[find_skill(weapon,event)]
  if w2[23].nil?
    refinement=nil
  elsif w2[23].length<2 && refinement=="Effect"
    refinement=nil
  elsif w2[23][0,1].to_i.to_s==w2[23][0,1] && refinement=="Effect"
    refinement=nil if w2[23][1,1]=="*"
  elsif w2[0,1]=="-" && w2[23][1,1].to_i.to_s==w2[23][1,1] && refinement=="Effect"
    refinement=nil if w2[23][2,1]=="*"
  end
  refinement=nil if w2[5]!="Staff Users Only" && ["Wrathful","Dazzling"].include?(refinement)
  refinement=nil if w2[5]=="Staff Users Only" && !["Wrathful","Dazzling"].include?(refinement)
  unitz=@data[find_unit(name,event)]
  wl=weapon_legality(event,unitz[0],weapon,refinement)
  if find_unit(name,event)<0
    event.respond "No unit was included" unless ignore
    return nil
  elsif unitz[0]=="Kiran"
    data_load()
    j=find_unit(name,event)
    merges=10 if merges>10
    merges=0 if merges<0
    if merges>10000000
      event.respond "I can't merge that high"
      merges=10000000
    end
    rarity=@mods[0].length-1 if rarity>@mods[0].length-1
    rarity=1 if rarity<1
    if rarity>10000000
      event.respond "I can't do rarities that high"
      rarity=10000000
    end
    atk="Attack"
    n=nature_name(boon,bane)
    unless n.nil?
      n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
    end
    create_embed(event,"__**#{@data[j][0].gsub('Lavatain','Laevatein')}**__","#{"<:star:322905655730241547>"*rarity.to_i}#{"**+#{merges}**" if merges>0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\nWeapon type: *#{@data[j][1][1]}*\nMovement type: *#{@data[j][3]}*#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n",0x9400D3,"Please note that the #{atk} stat displayed here does not include weapon might.  The Attack stat in-game does.",pick_thumbnail(event,j,bot),[["**Level 1#{" +#{merges}" if merges>0}**","HP: 0\n#{atk}: 0\nSpeed: 0\nDefense: 0\nResistance: 0\n\nBST: 0"],["**Level 40#{" +#{merges}" if merges>0}**","HP: 0\n#{atk}: 0\nSpeed: 0\nDefense: 0\nResistance: 0\n\nBST: 0"]],1)
    return nil
  elsif unitz[4].nil? || (unitz[4].zero? && unitz[9].zero?)
    data_load()
    j=find_unit(name,event)
    xcolor=unit_color(event,j,0,mu)
    create_embed(event,"__**#{@data[j][0].gsub('Lavatain','Laevatein')}**__","#{unit_clss(event,j)}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}",xcolor,"Stats currently unknown",pick_thumbnail(event,j,bot))
    return nil
  elsif unitz[4].zero?
    data_load()
    merges=0 if merges.nil?
    j=find_unit(name,event)
    xcolor=unit_color(event,j,0,mu)
    atk="Attack"
    atk="Magic" if ['Tome','Dragon','Healer'].include?(@data[j][1][1])
    atk="Strength" if ['Blade','Bow','Dagger'].include?(@data[j][1][1])
    zzzl=@skills[find_weapon(weapon,event)]
    if zzzl[7].include?("amage calculated using the lower of foe's Def or Res") || (zzzl[4]=="Weapon" && zzzl[5]=="Dragons Only" && !refinement.nil? && refinement.length>0)
      atk="Freeze"
    end
    n=nature_name(boon,bane)
    unless n.nil?
      n=n[0] if atk=="Strength"
      n=n[n.length-1] if atk=="Magic"
      n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
    end
    atk="Attack" if weapon != '-'
    u40=[@data[j][0],@data[j][9],@data[j][10],@data[j][11],@data[j][12],@data[j][13]]
    # find stats based on merges
    s=[[u40[1],1],[u40[2],2],[u40[3],3],[u40[4],4],[u40[5],5]]                                                   # all stats
    s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}                                     # sort the stats based on amount
    s.push(s[0],s[1],s[2],s[3],s[4])                                                                             # loop the list for use with multiple merges
    if merges>0                                                                                                  # apply merges, two stats per merge
      for i in 0...2*merges
        u40[s[i][1]]+=1
      end
    end
    wl=weapon_legality(event,u40[0],weapon,refinement)
    tempest=(args.map{|q| q.downcase}.include?('tempest'))
    cru40=u40.map{|a| a}
    u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
    cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing)
    blu40=u40.map{|a| a}
    crblu40=cru40.map{|a| a}
    blu40=apply_stat_skills(event,stat_skills_2,blu40)
    crblu40=apply_stat_skills(event,stat_skills_2,crblu40)
    u40=make_stat_string_list(u40,blu40)
    cru40=make_stat_string_list(cru40,crblu40)
    u40=make_stat_string_list_2(u40,cru40) if wl.include?('~~')
    for i in 0...stat_skills_2.length
      stat_skills_2[i]="Hone #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2=="Hone Movement"
      stat_skills_2[i]="Fortify #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2=="Fortify Movement"
    end
    ftr="Please note that the #{atk} stat displayed here does not include weapon might.  The Attack stat in-game does."
    ftr=nil if weapon != '-'
    stat_buffers=[]
    stat_nerfers=[]
    for i in 0...stat_skills_2.length
      if stat_skills_2[i].include?(" Ploy ") || stat_skills_2[i].include?("Seal ") || stat_skills_2[i].include?("Threaten ") || stat_skills_2[i].include?("Chill ") || stat_skills_2[i].include?(" Smoke ")
        stat_nerfers.push(stat_skills_2[i])
      else
        stat_buffers.push(stat_skills_2[i])
      end
    end
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{"<:star:322905655730241547>"*5}#{"**+#{merges}**" if merges>0}#{"	\u2764 **#{summoner}**" unless summoner=='-'}\n*Neutral Nature only so far*#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}Equipped weapon: #{wl}\n\n#{unit_clss(event,j)}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}",xcolor,ftr,pick_thumbnail(event,j,bot),[["**Level 1#{" +#{merges}" if merges>0}**","HP: unknown\n#{atk}: unknown\nSpeed: unknown\nDefense: unknown\nResistance: unknown\n\nBST: unknown"],["**Level 40#{" +#{merges}" if merges>0}**","HP: #{u40[1]}\n#{atk}: #{u40[2]}\nSpeed: #{u40[3]}\nDefense: #{u40[4]}\nResistance: #{u40[5]}\n\nBST: #{u40[16]}"]],1)
    return nil
  end
  data_load()
  merges=10 if merges>10
  merges=0 if merges<0
  rarity=@mods[0].length-1 if rarity>@mods[0].length-1
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
  xcolor=unit_color(event,j,0,mu)
  atk="Attack"
  atk="Magic" if ['Tome','Dragon','Healer'].include?(@data[j][1][1])
  atk="Strength" if ['Blade','Bow','Dagger'].include?(@data[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  if zzzl[7].include?("amage calculated using the lower of foe's Def or Res") || (zzzl[4]=="Weapon" && zzzl[5]=="Dragons Only" && !refinement.nil? && refinement.length>0)
    atk="Freeze"
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=="Strength"
    n=n[n.length-1] if atk=="Magic"
    n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
  end
  atk="Attack" if weapon != '-'
  if name=='Robin'
    u40[0]="Robin (Shared stats)"
    xcolor=avg_color([[32,142,251],[1,173,0]])
    w="*Tome*"
  end
  wl=weapon_legality(event,u40[0],weapon,refinement)
  cru40=u40.map{|a| a}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing)
  blu40=u40.map{|a| a}
  crblu40=cru40.map{|a| a}
  blu40=apply_stat_skills(event,stat_skills_2,blu40)
  crblu40=apply_stat_skills(event,stat_skills_2,crblu40)
  u40=make_stat_string_list(u40,blu40)
  cru40=make_stat_string_list(cru40,crblu40)
  u40=make_stat_string_list_2(u40,cru40) if wl.include?('~~')
  cru1=u1.map{|a| a}
  u1=apply_stat_skills(event,stat_skills,u1,tempest,summoner,weapon,refinement,blessing)
  cru1=apply_stat_skills(event,stat_skills,cru1,tempest,summoner,'-','',blessing)
  blu1=u1.map{|a| a}
  crblu1=cru1.map{|a| a}
  blu1=apply_stat_skills(event,stat_skills_2,blu1)
  crblu1=apply_stat_skills(event,stat_skills_2,crblu1)
  u1=make_stat_string_list(u1,blu1)
  cru1=make_stat_string_list(cru1,crblu1)
  u1=make_stat_string_list_2(u1,cru1) if wl.include?('~~')
  for i in 0...stat_skills_2.length
    stat_skills_2[i]="Hone #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Hone Movement"
    stat_skills_2[i]="Fortify #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Fortify Movement"
  end
  r="<:star:322905655730241547>"*rarity.to_i
  r="**#{rarity} star**" if r.length>=500
  r="#{r}**+#{merges}**" if merges>0
  ftr="Please note that the #{atk} stat displayed here does not include weapon might.  The Attack stat in-game does."
  if weapon != '-'
    ftr=nil
    tr=skill_tier(weapon,event)
    ftr="You equipped the Tier #{tr} version of the weapon.  Perhaps you want #{weapon}+ ?" unless weapon[weapon.length-1,1]=='+' || find_promotions(find_weapon(weapon,event),event).uniq.reject{|q| @skills[find_skill(q,event,true,true)][4]!="Weapon"}.length<=0 || " #{event.message.text.downcase} ".include?(' summoned ') || " #{event.message.text.downcase} ".include?(" mathoo's ")
  end
  flds=[["**Level 1#{" +#{merges}" if merges>0}**",["HP: #{u1[1]}","#{atk}: #{u1[2]}","Speed: #{u1[3]}","Defense: #{u1[4]}","Resistance: #{u1[5]}","","BST: #{u1[6]}"]]]
  if args.include?('gps') || args.include?('gp') || args.include?('growths') || args.include?('growth')
    flds.push(["**Growth Points**",["HP: #{u40[6]}","#{atk}: #{u40[7]}","Speed: #{u40[8]}","Defense: #{u40[9]}","Resistance: #{u40[10]}","","GPT: #{u40[6]+u40[7]+u40[8]+u40[9]+u40[10]}"]])
  end
  flds.push(["**Level 40#{" +#{merges}" if merges>0}**",["HP: #{u40[1]}","#{atk}: #{u40[2]}","Speed: #{u40[3]}","Defense: #{u40[4]}","Resistance: #{u40[5]}","","BST: #{u40[16]}"]])
  superbaan=['','','','','','']
  if boon=="" && bane=="" && ((stat_skills_2.length<=0 && !wl.include?('~~')) || flds.length==3)
    for i in 6...11
      superbaan[i-5]='(+)' if [1,5,10].include?(u40[i]) && rarity==5
      superbaan[i-5]='(-)' if [2,6,11].include?(u40[i]) && rarity==5
      superbaan[i-5]='(+)' if [10].include?(u40[i]) && rarity==4
      superbaan[i-5]='(-)' if [11].include?(u40[i]) && rarity==4
    end
    if superbaan.include?('(+)') || superbaan.include?('(-)')
      if ftr.nil?
        ftr="Please note that stats marked with (+)/(-) increase/decrease by 4, not the usual 3, with a boon/bane."
      elsif weapon == '-'
        ftr='Attack stat in-game has weapon might included.  (+)/(-) marks a "super" boon/bane.'
      end
    end
  elsif (stat_skills_2.length<=0 && !wl.include?('~~')) || flds.length==3
    x=["","HP","Attack","Speed","Defense","Resistance"]
    for i in 1...6
      superbaan[i]='(Superboon)' if boon==x[i] && [2,6,11].include?(u40[i+5]) && rarity==5
      superbaan[i]='(Superbane)' if bane==x[i] && [1,5,10].include?(u40[i+5]) && rarity==5
      superbaan[i]='(Superboon)' if boon==x[i] && [11].include?(u40[i+5]) && rarity==4
      superbaan[i]='(Superbane)' if bane==x[i] && [10].include?(u40[i+5]) && rarity==4
    end
  end
  for i in 0...5
    flds[1][1][i]="#{flds[1][1][i]} #{superbaan[i+1]}"
  end
  for i in 0...flds.length
    flds[i][1]=flds[i][1].join("\n")
  end
  j=find_unit(name,event)
  img=pick_thumbnail(event,j,bot)
  stat_buffers=[]
  stat_nerfers=[]
  for i in 0...stat_skills_2.length
    if stat_skills_2[i].include?(" Ploy ") || stat_skills_2[i].include?("Seal ") || stat_skills_2[i].include?("Threaten ") || stat_skills_2[i].include?("Chill ") || stat_skills_2[i].include?(" Smoke ")
      stat_nerfers.push(stat_skills_2[i])
    else
      stat_buffers.push(stat_skills_2[i])
    end
  end
  img="https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png" if u40[0]=="Robin (Shared stats)"
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}Equipped weapon: #{wl}\n\n#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}",xcolor,ftr,img,flds,1)
  return nil
end

def make_stat_string_list(a,b)
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

def make_stat_string_list_2(a,b)
  for i in 1...a.length
    a[i]="~~#{a[i]}~~ #{b[i]}" unless a[i]==b[i]
  end
  return a
end

def find_base_skill(x,event)
  if x[5].include?('Tome Users Only') && x[4]=='Weapon' && x[8]=="-" && x[6]!='-' # retro-prf tomes
    k=x[6].split(', ')
    k=k.map{|q| @data[find_unit(q,event)][1][2]}
    k=k.uniq
    k=k.join(', ')
    return "Rau\u00F0r" if k=="*Fire*, *Flux*"
    return "Bl\u00E1r" if k=="*Thunder*, *Light*"
    return k
  end
  return x[0] if x[8]=="-"
  unless x[0].length<5
    return "Gronn" if (x[0].include?("Gronn") || (x[19].include?("Seasonal") && !x[19].include?("Legendary"))) && x[8].include?("*Elwind*")
  end
  if x[8].include?("*, *")
    k=x[8].gsub('*','').split(', ')
    k=k.map{|q| find_base_skill(@skills[find_skill(q,event)],event)}
    k=k.uniq
    k=k.map{|q| "*#{q}*"}
    k=k.join(', ')
    return "Rau\u00F0r" if k=="*Fire*, *Flux*"
    return "Bl\u00E1r" if k=="*Thunder*, *Light*"
    return k
  elsif x[8].include?("* or *")
    k=x[8].gsub('*','').split(' or ')
    k=[find_base_skill(@skills[find_skill(k[0],event)],event),find_base_skill(@skills[find_skill(k[1],event)],event)]
    k=k.uniq
    k=k.map{|q| "*#{q}*"}
    k=k.join(' or ')
    return "Rau\u00F0r" if k=="*Fire* or *Flux*"
    return "Bl\u00E1r" if k=="*Thunder* or *Light*"
    return k
  end
  return find_base_skill(@skills[find_skill(x[8][1,x[8].length-2],event)],event)
end

def disp_skill(name,event,ignore=false)
  data_load()
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  a=s.split(' ')
  if all_commands().include?(a[0])
    a[0]=nil
    a.compact!
    s=a.join(' ')
  end
  args=sever(s,true).split(" ")
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
        args[args.length-1]=nil
        args.compact!
        name=@skills[find_skill(args.join('').downcase,event,true)][0] if find_skill(name,event,true)<0 && find_skill(args.join('').downcase,event,true)>=0
      end
      if find_skill(name,event,true)<0
        for j in 0...args2.length-1
          args2[0]=nil
          args2.compact!
          args=args2.join(' ').split(' ')
          name=@skills[find_skill(args.join('').downcase,event,true)][0] if find_skill(name,event,true)<0 && find_skill(args.join('').downcase,event,true)>=0
          for i in 0...args.length-1
            args[args.length-1]=nil
            args.compact!
            name=@skills[find_skill(args.join('').downcase,event,true)][0] if find_skill(name,event,true)<0 && find_skill(args.join('').downcase,event,true)>=0
          end
        end
      end
    end
    if find_skill(name,event)<0
      for i in 0...args.length-1
        args[args.length-1]=nil
        args.compact!
        name=@skills[find_skill(args.join('').downcase,event)][0] if find_skill(name,event)<0 && find_skill(args.join('').downcase,event)>=0
      end
      if find_skill(name,event)<0
        for j in 0...args2.length-1
          args2[0]=nil
          args2.compact!
          args=args2.join(' ').split(' ')
          name=@skills[find_skill(args.join('').downcase,event)][0] if find_skill(name,event)<0 && find_skill(args.join('').downcase,event)>=0
          for i in 0...args.length-1
            args[args.length-1]=nil
            args.compact!
            name=@skills[find_skill(args.join('').downcase,event)][0] if find_skill(name,event)<0 && find_skill(args.join('').downcase,event)>=0
          end
        end
      end
    end
  end
  f=find_skill(name,event)
  if f<0
    if event.message.text.downcase.include?("psychic")
      event.respond "No matches found.  Might you be looking for the skill **Physic** or its upgrade **Physic+**?" unless ignore
    else
      event.respond "No matches found.  If you are looking for data on the skills a character learns, try ```#{first_sub(event.message.text,'skill','skills')}```, with an s." unless ignore
    end
    return false
  end
  skill=@skills[f]
  if skill[4]=="Weapon" && (" #{event.message.text.downcase} ".include?(' refinement ') || " #{event.message.text.downcase} ".include?(' (w) '))
    if skill[0]=="Falchion"
      disp_skill("Drive Spectrum",event,ignore)
      disp_skill("Double Lions",event,ignore)
      disp_skill("Spectrum Bond",event,ignore)
      return true
    elsif find_effect_name(skill,event).length>0
      disp_skill(find_effect_name(skill,event),event,ignore)
      return true
    elsif !skill[23].nil?
      event.respond "#{skill[0]} does not have an Effect Mode.  Showing #{skill[0]}'s default data."
    else
      event.respond "#{skill[0]} cannot be refined.  Showing #{skill[0]}'s default data."
    end
  end
  for i in 9...19
    untz=skill[i].split(', ')
    untz=untz.reject {|u| find_unit(u,event,false,true)<0 && u[0,4].downcase != 'all ' && u != '-'}
    untz=untz.map {|u| u.gsub('Lavatain','Laevatein')}
    untz=untz.sort {|a,b| a.downcase <=> b.downcase}
    for i2 in 0...untz.length
      untz[i2]="~~#{untz[i2]}~~" unless untz[i2][0,4].downcase=='all ' || untz[i2]=='-' || @data[find_unit(untz[i2],event,false,true)][22].nil? || !skill[21].nil?
    end
    skill[i]=untz.join(', ')
  end
  str=''
  xcolor=0x02010a
  xfooter=nil
  xpic=nil
  sklslt=['']
  if skill[4]=="Weapon"
    xcolor=0xF4728C
    if skill[5]=="Red Tome Users Only"
      s=find_base_skill(skill,event)
      xfooter="Dark Mages can still learn this skill, it just takes more SP."
      if s=="Rau\u00F0r"
        xfooter=nil
      elsif s=="Flux"
        s="Dark"
        xfooter=xfooter.gsub('Dark','Fire')
      end
      str="**Skill Slot:** #{skill[4]}\n**Weapon Type:** #{s} Magic (Red Tome)\n**Might:** #{skill[2]}\n**Range:** #{skill[3]}#{"\n**Effect:** #{skill[7]}" unless skill[7]=='-'}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=="Blue Tome Users Only"
      s=find_base_skill(skill,event)
      xfooter="Light Mages can still learn this skill, it just takes more SP."
      if s=="Bl\u00E1r"
        xfooter=nil
      elsif s=="Light"
        xfooter=xfooter.gsub('Light','Thunder')
      end
      str="**Skill Slot:** #{skill[4]}\n**Weapon Type:** #{s} Magic (Blue Tome)\n**Might:** #{skill[2]}\n**Range:** #{skill[3]}#{"\n**Effect:** #{skill[7]}" unless skill[7]=='-'}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=="Green Tome Users Only"
      s=find_base_skill(skill,event)
      if s=="Gronn"
        xfooter=nil
      end
      str="**Skill Slot:** #{skill[4]}\n**Weapon Type:** #{s} Magic (Green Tome)\n**Might:** #{skill[2]}\n**Range:** #{skill[3]}#{"\n**Effect:** #{skill[7]}" unless skill[7]=='-'}"
      xfooter=nil unless skill[6]=='-'
    elsif skill[5]=="Bow Users Only"
      xfooter="All bows deal effective damage against flying units"
      str="**Skill Slot:** #{skill[4]}\n**Weapon Type:** Bow\n**Might:** #{skill[2]}\n**Range:** #{skill[3]}#{"\n**Effect:** #{skill[7]}" unless skill[7]=='-'}"
    elsif skill[5]=="Dragons Only"
      str="**Skill Slot:** #{skill[4]}\n**Weapon Type:** Breath (Dragons)\n**Might:** #{skill[2]}\n**Range:** #{skill[3]}#{"\n**Effect:** #{skill[7]}" unless skill[7]=='-'}"
    elsif skill[5]=="Beasts Only"
      str="**Skill Slot:** #{skill[4]}\n**Weapon Type:** Beaststone (Beasts)\n**Might:** #{skill[2]}\n**Range:** #{skill[3]}#{"\n**Effect:** #{skill[7]}" unless skill[7]=='-'}"
    else
      s=skill[5]
      s=s[0,s.length-11]
      s="Sword (Red Blade)" if s=="Sword"
      s="Lance (Blue Blade)" if s=="Lance"
      s="Axe (Green Blade)" if s=="Axe"
      str="**Skill Slot:** #{skill[4]}\n**Weapon Type:** #{s}\n**Might:** #{skill[2]}\n**Range:** #{skill[3]}#{"\n**Effect:** #{skill[7]}" unless skill[7]=='-'}"
    end
    str="#{str}\n**Stats affected:** #{"+" if skill[20][1]>0}#{skill[20][1]}/#{"+" if skill[20][2]>0}#{skill[20][2]}/#{"+" if skill[20][3]>0}#{skill[20][3]}/#{"+" if skill[20][4]>0}#{skill[20][4]}"
    sklslt=['Weapon']
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
  elsif skill[4]=="Assist"
    sklslt=['Assist']
    xcolor=0x07DFBB
    str="**Skill Slot:** #{skill[4]}\n**Range:** #{skill[3]}\n**Effect:** #{skill[7]}"
    str="#{str}\n**Heals:** #{skill[22]}" if skill[5]=="Staff Users Only"
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
  elsif skill[4]=="Special"
    sklslt=['Special']
    xcolor=0xF67EF8
    str="**Skill Slot:** #{skill[4]}\n**Cooldown:** #{skill[2]}\n**Effect:** #{skill[7]}#{"\n**Range:** ```\n#{skill[3].gsub("n","\n")}```" if skill[3]!="-"}"
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
  else
    xcolor=0xFDDC7E
    xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/#{skill[0].gsub(' ','_').gsub('/','_')}.png"
    if " #{event.message.text.downcase} ".include?(' refinement ') || " #{event.message.text.downcase} ".include?(' (w) ')
      s=skill[0].gsub('/','_').split(' ')
      s[s.length-1]='W' if s[s.length-1].length<2
      xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/#{s.join('_')}.png"
    end
    sklslt=skill[4].split(', ')
    if !skill[20].nil? && skill[20]!='' && skill[4].include?("Passive(W)")
      eff=skill[20].split(', ')
      for i in 0...eff.length
        eff[i]=nil unless find_skill(eff[i],event,true)>1
      end
      eff.compact!
      if eff.length<=0
        for i in 0...sklslt.length
          sklslt[i]=nil if sklslt[i]=="Passive(W)"
        end
        sklslt.compact!
      end
    end
    str="**Skill Slot:** #{sklslt.join(', ')}"
    str="#{str}\n**Effect:** #{skill[7]}"
    if skill[0]=="Distant Counter"
      str="#{str}\n**Secondary effect:** Breaks consecutiveness of enemy mage/bow/dagger/staff attacks"
    elsif skill[0]=="Close Counter"
      str="#{str}\n**Secondary effect:** Breaks consecutiveness of enemy sword/axe/lance/breath attacks"
    end
    str="#{str}\n\n**SP required:** #{skill[1]} #{"(#{skill[1]*3/2} when inherited)" if skill[6]=='-'}"
    if skill[3]!="-"
      floop=skill[3].split(' ')
      str="#{str}\n**Seal Cost:** #{floop[1]} Great #{floop[0]} Badges, #{floop[2]} #{floop[0]} Badges, #{"and " if skill[8]=='-'}#{floop[3]} Sacred Coins#{", and a #{skill[8].gsub('*','')} seal" unless skill[8]=='-' || skill[0][0,skill[0].length-2] != skill[8][0,skill[8].length-2]}"
    end
  end
  p=find_promotions(f,event)
  p=p.uniq
  p=p.reject{|q| !has_any?(sklslt, @skills[find_skill(q,event,true,true)][4].split(', '))}
  if p.length==0
    p=nil
  else
    for i2 in 0...p.length
      p[i2]="~~#{p[i2]}~~" unless @skills[find_skill(p[i2],event,true,true)][21].nil? || !skill[21].nil?
    end
    p=list_lift(p.map{|q| "*#{q}*"},"or")
  end
  str="#{str}\n#{"**Restrictions on inheritance:** #{skill[5]}" if skill[6]=='-'}#{"**Exclusive to:** #{skill[6].split(', ').reject {|u| find_unit(u,event,false,true)<0 && u != '-'}.join(', ').gsub('Lavatain','Laevatein')}" unless skill[6]=='-'}#{"\n**Promotes from:** #{skill[8]}" unless skill[8]=='-'}#{"\n**Promotes into:** #{p}" unless p.nil?}"
  if !skill[22].nil? && skill[22].length>0 && skill[4]=="Weapon"
    prm=skill[22].split(', ')
    for i in 0...prm.length
      sklll=prm[i].split('!')
      if sklll.length==1
        prm[i]=nil if x_find_skill(sklll[0],event,@skills.map{|q| q})<0
      else
        prm[i]="#{sklll[1]} (#{sklll[0]})"
        prm[i]=nil if x_find_skill(sklll[1],event,@skills.map{|q| q})<0
        prm[i]=nil if find_unit(sklll[0],event,false,true)<0
      end
    end
    str="#{str}\n**Evolves into:** #{list_lift(prm,"or")}"
  elsif skill[0]=="Falchion"
    sk1=@skills[find_skill("Falchion (Mystery)",event,true,true)]
    sk2=@skills[find_skill("Falchion (Echoes)",event,true,true)]
    sk3=@skills[find_skill("Falchion (Awakening)",event,true,true)]
    str="#{str}\n**Falchion(Mystery) evolves into:** #{sk1[22]}" if !sk1[22].nil? && sk1[22].length>0 && sk1[4]=="Weapon"
    str="#{str}\n**Falchion(Echoes) evolves into:** #{sk2[22]}" if !sk2[22].nil? && sk2[22].length>0 && sk2[4]=="Weapon"
    str="#{str}\n**Falchion(Awakening) evolves into:** #{sk3[22]}" if !sk3[22].nil? && sk3[22].length>0 && sk3[4]=="Weapon"
  end
  x=false
  can_also=true
  str2="**Heroes who know it out of the box:**"
  str2="#{str2}\n*1-star:* #{skill[9]}" unless skill[9]=='-' || skill[9]==''
  str2="#{str2}\n*2-star:* #{skill[10]}" unless skill[10]=='-' || skill[10]==''
  str2="#{str2}\n*3-star:* #{skill[11]}" unless skill[11]=='-' || skill[11]==''
  str2="#{str2}\n*4-star:* #{skill[12]}" unless skill[12]=='-' || skill[12]==''
  str2="#{str2}\n*5-star:* #{skill[13]}" unless skill[13]=='-' || skill[13]==''
  str="#{str}#{"\n" unless x}\n#{str2}" unless str2=="**Heroes who know it out of the box:**"
  x=true unless str2=="**Heroes who know it out of the box:**"
  str2="**Heroes who can learn without inheritance:**"
  str2="#{str2}\n*1-star:* #{skill[14]}" unless skill[14]=='-' || skill[14]==''
  str2="#{str2}\n*2-star:* #{skill[15]}" unless skill[15]=='-' || skill[15]==''
  str2="#{str2}\n*3-star:* #{skill[16]}" unless skill[16]=='-' || skill[16]==''
  str2="#{str2}\n*4-star:* #{skill[17]}" unless skill[17]=='-' || skill[17]==''
  str2="#{str2}\n*5-star:* #{skill[18]}" unless skill[18]=='-' || skill[18]==''
  str="#{str}#{"\n" unless x}\n#{str2}" unless str2=="**Heroes who can learn without inheritance:**"
  x=true unless str2=="**Heroes who can learn without inheritance:**"
  if !skill[20].nil? && skill[20]!='' && skill[4].include?("Passive(W)")
    eff=skill[20].split(', ')
    for i in 0...eff.length
      eff[i]=nil unless find_skill(eff[i],event,true)>1
    end
    eff.compact!
    str="#{str}\n\n**Gained via Effect Mode on:** #{eff.join(', ')}" if eff.length>0
  end
  prev=find_prevolutions(f,event).length
  if prev>0
    for i in 0...prev
      skill2=find_prevolutions(f,event)[i][0]
      for i2 in 14...19
        untz=skill2[i2].split(', ')
        untz=untz.reject {|u| find_unit(u,event,false,true)<0 && u[0,4].downcase != 'all ' && u != '-'}
        untz=untz.map {|u| u.gsub('Lavatain','Laevatein')}
        untz=untz.sort {|a,b| a.downcase <=> b.downcase}
        skill2[i2]=untz.join(', ')
      end
      str2="**It#{" also" if x} evolves from #{skill2[0]}, #{find_prevolutions(f,event)[i][1]} the following heroes:**"
      str2="#{str2}\n*1-star:* #{skill2[14]}" unless skill2[14]=='-' || skill2[14]==''
      str2="#{str2}\n*2-star:* #{skill2[15]}" unless skill2[15]=='-' || skill2[15]==''
      str2="#{str2}\n*3-star:* #{skill2[16]}" unless skill2[16]=='-' || skill2[16]==''
      str2="#{str2}\n*4-star:* #{skill2[17]}" unless skill2[17]=='-' || skill2[17]==''
      str2="#{str2}\n*5-star:* #{skill2[18]}" unless skill2[18]=='-' || skill2[18]==''
      if str2=="**It#{" also" if x} evolves from #{skill2[0]}, #{find_prevolutions(f,event)[i][1]} the following heroes:**"
        str="#{str}\n\n**It#{" also" if x} evolves from #{skill2[0]}**"
      else
        str="#{str}\n\n#{str2}"
      end
    end
    str2="**Evolution cost:** 300 SP (450 if inherited), 200 Arena Medals, 20 Refining Stones"
    str2="**Evolution cost:** 300 SP (450 if inherited), 100 Arena Medals, 10 Refining Stones" if skill[0]=="Candlelight+"
    str2="**Evolution cost:** 400 SP, 375 Arena Medals, 150 Divine Dew" if skill[6]!="-"
    str2="**Evolution cost:** 1 story-gift Gunnthra" if skill[0]=="Chill Breidablik"
    str="#{str}\n#{"\n" if prev>1}#{str2}"
  end
  create_embed(event,"__**#{skill[0].gsub('Bladeblade','Laevatein')}**__",str,xcolor,xfooter,xpic) unless (" #{event.message.text.downcase} ".include?(' refined ') && !" #{event.message.text.downcase} ".include?(' default ') && !" #{event.message.text.downcase} ".include?(' base ')) && skill[4]=="Weapon"
  if " #{event.message.text.downcase} ".include?(' refined ') && skill[23].nil? && skill[4]=="Weapon"
    event.respond "#{skill[0].gsub('Bladeblade','Laevatein')} does not have any refinements."
    return nil
  elsif !skill[23].nil? && !((" #{event.message.text.downcase} ".include?(' default ') || " #{event.message.text.downcase} ".include?(' base ')) && !" #{event.message.text.downcase} ".include?(' refined '))
    sttz=[]
    inner_skill=skill[23]
    mt=0
    mt=1 if skill[7]=="-" || skill[5]=="Dragons Only"
    if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
      mt+=inner_skill[0,1].to_i
      inner_skill=inner_skill[1,inner_skill.length-1]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
    elsif inner_skill[0,1]=='-' && inner_skill.length>1
      mt-=inner_skill[1,1].to_i
      inner_skill=inner_skill[2,inner_skill.length-2]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
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
    if skill[6]=="Nebby"
      inner_skill=inner_skill.split('  ')
      sttz.push([0,0,0,0,0,"Full Metal",inner_skill[0]])
      sttz.push([0,0,0,0,0,"Shadow",inner_skill[1]])
      inner_skill=''
    elsif inner_skill.length>1
      zzz=[0,0,0,0,0,0]
      if find_effect_name(skill,event).length>0
        zzz=apply_stat_skills(event,[find_effect_name(skill,event,1)],zzz)
      end
      sttz.push([zzz[1],zzz[2],zzz[3],zzz[4],zzz[5],"Effect"])
    elsif skill[0]=="Falchion"
      sk1=@skills[find_skill("Falchion (Mystery)",event,true,true)]
      sk2=@skills[find_skill("Falchion (Echoes)",event,true,true)]
      sk3=@skills[find_skill("Falchion (Awakening)",event,true,true)]
      refinements=[]
      refinements.push(["Mystery",sk1[23],nil,0]) unless sk1[23].nil?
      refinements.push(["Echoes",sk2[23],nil,0]) unless sk2[23].nil?
      refinements.push(["Awakening",sk3[23],nil,0]) unless sk3[23].nil?
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
      sttz.push([3,refinements[1][3],0,0,0,"**Falchion(Echoes) (+) Effect Mode**#{" - #{find_effect_name(sk2,event)}" unless find_effect_name(sk2,event).length<=0}",refinements[1][1]]) unless refinements[1][1].nil?
      sttz.push([3,refinements[2][3],0,0,0,"**Falchion(Awakening) (+) Effect Mode**#{" - #{find_effect_name(sk3,event)}" unless find_effect_name(sk3,event).length<=0}",refinements[2][1]]) unless refinements[2][1].nil?
    end
    if skill[5]=="Staff Users Only" && (skill[7].include?("This weapon's damage is calculated the same as other weapons.") || skill[7].include?("Damage from staff calculated like other weapons."))
      xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Dazzling_W.png"
      sttzx=[[0,0,0,0,0,"Dazzling","The foe cannot counterattack."]]
    elsif skill[5]=="Staff Users Only" && (skill[7].include?("The foe cannot counterattack."))
      xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Wrathful_W.png"
      sttzx=[[0,0,0,0,0,"Wrathful","This weapon's damage is calculated the same as other weapons."]]
    elsif skill[5]=="Staff Users Only"
      xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Staff_Default_Refine.png"
      sttzx=[[0,0,0,0,0,"Wrathful","This weapon's damage is calculated the same as other weapons."],[0,0,0,0,0,"Dazzling","The foe cannot counterattack."]]
    elsif skill[5].include?("Tome Users Only") || ["Bow Users Only","Dagger Users Only"].include?(skill[5])
      xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine.png"
      sttzx=[[2,1,0,0,0,"Attack"],[2,0,2,0,0,"Speed"],[2,0,0,3,0,"Defense"],[2,0,0,0,3,"Resistance"]]
    else
      xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine.png"
      sttzx=[[5,2,0,0,0,"Attack"],[5,0,3,0,0,"Speed"],[5,0,0,4,0,"Defense"],[5,0,0,0,4,"Resistance"]]
    end
    for i in 0...sttzx.length
      sttz.push(sttzx[i])
    end
    for i in 0...sttz.length
      sttz[i][1]+=mt
    end
    str=""
    for i in 0...sttz.length
      if sttz[i][5].include?("(+)")
        str="#{str}\n\n#{sttz[i][5]}"
      else
        str="#{str}\n\n**#{skill[0]} (+) #{sttz[i][5]} Mode**"
      end
      if sttz[i][5]=="Effect" && find_effect_name(skill,event).length>0
        xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/#{find_effect_name(skill,event,2).gsub(' ','_').gsub('/','_')}.png"
        str="#{str} - #{find_effect_name(skill,event)}"
      end
      str="#{str}\nMight: #{skill[2]+sttz[i][1]}	Range: #{skill[3]}"
      str="#{str}	HP +#{sttz[i][0]}" if sttz[i][0]>0
      str="#{str}	Attack #{"+" if skill[20][1]-skill[2]>0}#{skill[20][1]-skill[2]}" if skill[20][1]-skill[2]!=0
      str="#{str}	Speed #{"+" if skill[20][2]+sttz[i][2]>0}#{skill[20][2]+sttz[i][2]}" if skill[20][2]+sttz[i][2]!=0
      str="#{str}	Defense #{"+" if skill[20][3]+sttz[i][3]>0}#{skill[20][3]+sttz[i][3]}" if skill[20][3]+sttz[i][3]!=0
      str="#{str}	Resistance #{"+" if skill[20][4]+sttz[i][4]>0}#{skill[20][4]+sttz[i][4]}" if skill[20][4]+sttz[i][4]!=0
      str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{inner_skill}" if inner_skill.length>1 && sttz[i][5]=="Effect"
      str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{sttz[i][6]}" unless sttz[i][6].nil?
      str="#{str}#{"\n" unless [str[str.length-1,1],str[str.length-2,2]].include?("\n")}#{outer_skill}" unless outer_skill.nil? || !sttz[i][7].nil?
      str="#{str}\nIf foe's Range = 2, damage calculated using the lower of foe's Def or Res." if skill[5]=="Dragons Only"
    end
    ftr="All refinements cost: 350 SP (525 if inherited), 500 Arena Medals, 50 Refining Stones"
    ftr="All refinements cost: 400 SP, 500 Arena Medals, 200 Divine Dew" if skill[6]!="-"
    xpic="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Falchion_Refines.png" if skill[0]=="Falchion"
    create_embed(event,"__**Refinery Options**__",str,0x688C68,ftr,xpic)
  end
  if skill[0][0,14]=="Wrathful Staff"
    event.respond "#{event.user.mention}\nAnyone who feeds me a Genny is a monster. <:nobully:380601407767838721> It's not my fault the game mechanics prevent me from protesting!\nHeck, now that the Weapon Refinery exists, you can just give my staff the Wrathful Mode upgrade, it pairs well with my high Magic stat."
  end
end

def unit_skills(name,event,justdefault=false,r=0)
  data_load()
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(" ")
  if name.nil? || name.length==0
    str=find_name_in_string(event)
    char=@data[find_unit(str,event)]
  else
    char=@data[find_unit(name,event)]
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  rarity=flurp[0]
  rarity=r unless r<1 || r>5
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
  for i in 0...@skills.length
    for j in 9...9+rarity
      if "#{@skills[i][j]},".include?("#{char[0]},") || @skills[i][j]=="All #{clss}"
        box[0].push(@skills[i]) if @skills[i][4]=='Weapon'
        box[1].push(@skills[i]) if @skills[i][4]=='Assist'
        box[2].push(@skills[i]) if @skills[i][4]=='Special'
        box[3].push(@skills[i]) if @skills[i][4].include?('Passive(A)')
        box[4].push(@skills[i]) if @skills[i][4].include?('Passive(B)')
        box[5].push(@skills[i]) if @skills[i][4].include?('Passive(C)')
      end
    end
    for j in 14...14+rarity
      if "#{@skills[i][j]},".include?("#{char[0]},") || @skills[i][j]=="All #{clss}"
        sklz[0].push(@skills[i]) if @skills[i][4]=='Weapon'
        sklz[1].push(@skills[i]) if @skills[i][4]=='Assist'
        sklz[2].push(@skills[i]) if @skills[i][4]=='Special'
        sklz[3].push(@skills[i]) if @skills[i][4].include?('Passive(A)')
        sklz[4].push(@skills[i]) if @skills[i][4].include?('Passive(B)')
        sklz[5].push(@skills[i]) if @skills[i][4].include?('Passive(C)')
      end
    end
    if "#{@skills[i][6]},".include?("#{char[0]},") && rarity>5
      sklz[0].push(@skills[i]) if @skills[i][4]=='Weapon'
      sklz[1].push(@skills[i]) if @skills[i][4]=='Assist'
      sklz[2].push(@skills[i]) if @skills[i][4]=='Special'
      sklz[3].push(@skills[i]) if @skills[i][4].include?('Passive(A)')
      sklz[4].push(@skills[i]) if @skills[i][4].include?('Passive(B)')
      sklz[5].push(@skills[i]) if @skills[i][4].include?('Passive(C)')
      box[0].push(@skills[i]) if @skills[i][4]=='Weapon'
      box[1].push(@skills[i]) if @skills[i][4]=='Assist'
      box[2].push(@skills[i]) if @skills[i][4]=='Special'
      box[3].push(@skills[i]) if @skills[i][4].include?('Passive(A)')
      box[4].push(@skills[i]) if @skills[i][4].include?('Passive(B)')
      box[5].push(@skills[i]) if @skills[i][4].include?('Passive(C)')
    end
  end
  sklz=sklz.map{|q| q.uniq}
  box=box.map{|q| q.uniq}
  box2=[[],[],[],[],[],[]]
  sklz2=[[],[],[],[],[],[]]
  retroprf=''
  for i in 0...6
    for j in 0...box[i].length
      box2[i].push(box[i][j][0]) if box[i][j][8]=='-'
    end
    for j in 0...sklz[i].length
      sklz2[i].push(sklz[i][j][0]) if sklz[i][j][8]=='-' && !(i==0 && sklz[i][j][6]!='-')
      retroprf=sklz[i][j][0] if sklz[i][j][8]=='-' && i==0 && sklz[i][j][6]!='-'
    end
  end
  retroprf="**#{retroprf}**" if box2[0].include?(retroprf)
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
    if box[i].length>0 && box2[i].length==0
      box2[i].push("~~Unknown base~~")
      for j in 0...box[i].length
        box2[i].push(box[i][j][0].gsub('Bladeblade','Laevatein')) if box[i][j][8].include?("* or *") || box[i][j][8].include?("*, *")
      end
      for k in 0...3
        for j in 0...box[i].length
          box2[i].push(box[i][j][0].gsub('Bladeblade','Laevatein')) if box[i][j][8].include?("*#{box2[i][box2[i].length-1]}*")
        end
      end
    end
    if sklz[i].length>0 && sklz2[i].length==0
      sklz2[i].push("~~Unknown base~~")
      for j in 0...sklz[i].length
        sklz2[i].push(sklz[i][j][0].gsub('Bladeblade','Laevatein')) if sklz[i][j][8].include?("* or *") || sklz[i][j][8].include?("*, *")
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
  if justdefault
    for i in 0...6
      sklz2[i]=["~~none~~"] if sklz2[i].length.zero?
      for j in 0...sklz2[i].length
        sklz2[i][j]="~~#{sklz2[i][j]}~~" unless box2[i].include?(sklz2[i][j]) || sklz2[i][j].include?('~~')
      end
    end
  else
    for i in 0...6
      sklz2[i]=["~~none~~"] if sklz2[i].length.zero?
      for j in 0...sklz2[i].length
        sklz2[i][j]="**#{sklz2[i][j]}**" if box2[i].include?(sklz2[i][j])
      end
    end
    s=@skills[find_skill(sklz2[0][sklz2[0].length-1].gsub('**',''),event)]
    if !s[22].nil? && s[22].length>0 && s[4]=="Weapon"
      s2=s[22].split(', ')
      for i in 0...s2.length
        if s2[i].include?('!')
          s3=s2[i].split('!')
          sklz2[0].push("~~#{s3[1]}~~") if s3[0]==name && find_skill(s3[1],event,false,true)>-1
        else
          sklz2[0].push("~~#{s2[i]}~~") if find_skill(s2[i],event,false,true)>-1
        end
      end
    end
    if retroprf != ''
      if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        sklz2[0].push('    ')
      else
        sklz2[0][sklz2[0].length-1]="__#{sklz2[0][sklz2[0].length-1]}__"
      end
      sklz2[0].push(retroprf)
      s=@skills[find_skill(sklz2[0][sklz2[0].length-1].gsub('**',''),event)]
      if !s[22].nil? && s[22].length>0 && s[4]=="Weapon"
        s2=s[22].split(', ')
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
  unless r>0
    if " #{event.message.text.downcase} ".include?(' weaponless ') || (" #{event.message.text.downcase} ".include?(' zelgius ') && name.downcase != 'zelgius') || " #{event.message.text.downcase} ".include?(' zelgiused ') || " #{event.message.text.downcase} ".include?(" zelgius'd ")
      sklz2[0]=["~~none~~"]
      s=@skills[find_skill(sklz2[1][sklz2[1].length-1].gsub('**','').gsub('~~',''),event)]
      if !s.nil? && s[6]!='-'
        sklz2[1][sklz2[1].length-1]=nil
        sklz2[1].compact!
        sklz2[1]=["~~none~~"] if sklz2[1].length<=0
      end
      s=@skills[find_skill(sklz2[2][sklz2[2].length-1].gsub('**','').gsub('~~',''),event)]
      if !s.nil? && s[6]!='-'
        sklz2[2][sklz2[2].length-1]=nil
        sklz2[2].compact!
        sklz2[2]=["~~none~~"] if sklz2[2].length<=0
      end
    end
  end
  return sklz2
end

def disp_unit_skills(bot,name,event,ignore=false,chain=false,doubleunit=false)
  name=['Robin(M)','Robin(F)'] if name=='Robin'
  if name.is_a?(Array)
    for i in 0...name.length
      disp_unit_skills(bot,name[i],event,ignore,chain,true)
    end
    return nil
  end
  n=find_name_in_string(event)
  if n=="Kiran"
    sklz2=[["**Breidablik**","~~Chill Breidablik~~"],["~~none~~"],["~~none~~"],["~~none~~"],["~~none~~"],["~~none~~"]]
  else
    sklz2=unit_skills(name,event)
  end
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(" ")
  if name.nil? || name.length==0
    str=find_name_in_string(event)
    char=@data[find_unit(str,event)]
  else
    char=@data[find_unit(name,event)]
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  j=find_unit(find_name_in_string(event),event)
  j=find_unit(name,event) unless name.nil? || name.length==0
  xcolor=unit_color(event,j,0,false,chain)
  mu=false
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    namehere=str
    namehere=name unless name.nil? || name.length.zero?
    dv=find_in_dev_units(namehere)
    if dv>=0
      mu=true
      xcolor=0xFFABAF if @data[j][0]=='Sakura'
      rarity=@dev_units[dv][1]
      sklz2=[@dev_units[dv][6],@dev_units[dv][7],@dev_units[dv][8],@dev_units[dv][9],@dev_units[dv][10],@dev_units[dv][11],[@dev_units[dv][12]]]
    elsif @dev_lowlifes.include?(@data[j][0])
      event.respond "Mathoo has this character but doesn't care enough about including their skills.  Showing default skills." unless chain
    elsif @dev_waifus.include?(@data[j][0])
      event.respond "Mathoo does not have that character...but not for a lack of wanting.  Showing default skills." unless chain
    else
      event.respond "Mathoo does not have that character.  Showing default skills." unless chain
    end
  end
  f=chain
  f=false if doubleunit
  xfooter=nil
  xfooter="Sacred Seal: #{sklz2[6][0]}" unless sklz2[6].nil? || sklz2[6][0].length.zero? || sklz2[6][0]==" "
  sklz2[0]=sklz2[0].reject {|a| ["Falchion","**Falchion**"].include?(a)}
  txt="#{"<:star:322905655730241547>"*rarity.to_i}\n#{unit_clss(event,j)}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n"
  txt=" " if f
  create_embed(event,"#{"__#{"Mathoo's " if mu}**#{@data[j][0]}**__" unless f}",txt,xcolor,xfooter,pick_thumbnail(event,j,bot),[["**Weapons**",sklz2[0].join("\n")],["**Assists**",sklz2[1].join("\n")],["**Specials**",sklz2[2].join("\n")],["**A Passives**",sklz2[3].join("\n")],["**B Passives**",sklz2[4].join("\n")],["**C Passives**",sklz2[5].join("\n")]])
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
  return "-#{stat[1,stat.length-1]}" if stat[0,1]=="+"
  return "+#{stat[1,stat.length-1]}" if stat[0,1]=="-"
  return "robust" if stat.downcase=="sickly"
  return "strong" if stat.downcase=="weak"
  return "clever" if stat.downcase=="dull"
  return "deft" if stat.downcase=="clumsy"
  return "quick" if stat.downcase=="sluggish"
  return "lucky" if stat.downcase=="unlucky"
  return "sturdy" if stat.downcase=="fragile"
  return "calm" if stat.downcase=="excitable"
  return "sickly" if stat.downcase=="robust"
  return "weak" if stat.downcase=="strong"
  return "dull" if stat.downcase=="clever"
  return "clumsy" if stat.downcase=="deft"
  return "sluggish" if stat.downcase=="quick"
  return "unlucky" if stat.downcase=="lucky"
  return "fragile" if stat.downcase=="sturdy"
  return "fragile" if stat.downcase=="defensive"
  return "excitable" if stat.downcase=="calm"
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
      return j if table[j][0]==skill
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
  for i in 0...k.length-1
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
  if sklz
    k=str.split(' ')
    for i in 1...k.length
      if k[i]=="+"
      elsif i>1 && !k[i-1].nil? && k[i][0,1]=="+" && k[i][1,k[i].length-1].to_i.to_s==k[i][1,k[i].length-1]
        k[i-1]="HP" if ["hp","health"].include?(k[i-1].downcase)
        k[i-1]="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(k[i-1].downcase)
        k[i-1]="Speed" if ["spd","speed"].include?(k[i-1].downcase)
        k[i-1]="Defense" if ["defense","def","defence"].include?(k[i-1].downcase)
        k[i-1]="Resistance" if ["res","resistance"].include?(k[i-1].downcase)
        if ["HP","Attack","Speed","Defense","Resistance"].include?(k[i-1]) || ['attackspeed','atkspeed','attspeed','attackspd','atkspd','attspd','speedattack','speedatk','speedatt','spdattack','spdatk','spdatt','attackdefense','atkdefense','attdefense','attackdefence','atkdefence','attdefence','attackdef','atkdef','attdef','defenseattack','defenseatk','defenseatt','defenceattack','defenceatk','defenceatt','defattack','defatk','defatt','attackresistance','atkresistance','attresistance','attackres','atkres','attres','resistanceattack','resistanceatk','resistanceatt','resattack','resatk','resatt','speeddefense','spddefense','speeddefence','spddefence','speeddef','spddef','defensespeed','defensespd','defencespeed','defencespd','defspeed','defspd','speedresistance','spdresistance','speedres','spdres','resistancespeed','resistancespd','resspeed','resspd','defenseresistance','defenceresistance','defresistance','defenseres','defenceres','defres','resistancedefense','resistancedefence','resistancedef','resdefense','resdefence','resdef'].include?(k[i-1].downcase)
          k[i-1]="#{k[i-1]}#{k[i]}"
          k[i]=nil
        end
      elsif k[i]=="(+)"
      elsif k[i-1]=="(+)"
        k[i]="HP" if ["hp","health"].include?(k[i].downcase)
        k[i]="Attack" if ["attack","atk","att","strength","str","magic","mag"].include?(k[i].downcase)
        k[i]="Speed" if ["spd","speed"].include?(k[i].downcase)
        k[i]="Defense" if ["defense","def","defence"].include?(k[i].downcase)
        k[i]="Resistance" if ["res","resistance"].include?(k[i].downcase)
        if ["HP","Attack","Speed","Defense","Resistance"].include?(k[i])
          k[i-1]="#{k[i-1]}#{k[i]}"
          k[i]=nil
        end
      end
    end
    k.compact!
    str=k.join(' ')
  end
  k=str.split('-')
  for i in 1...k.length
    k[i]="-#{k[i]}"
  end
  str=k.join(' ')
  str="#{str} +" if s[s.length-1,1]=="+"
  str="#{str} -" if s[s.length-1,1]=="-"
  str="* #{str}" if s[0,1]=="*"
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

def first_sub(master,str1,str2)
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
  if ["dancer","singer","dancers","singers"].include?(name.downcase)
    k=@skills[find_skill("Dance",event)]
    k2=@skills[find_skill("Sing",event)]
    b=[]
    for i in 14...19
      u=k[i].split(', ')
      for j in 0...u.length
        b.push(u[j].gsub('Lavatain','Laevatein')) unless b.include?(u[j]) || u[j].include?("-") || !has_any?(g, @data[find_unit(u[j],event)][22])
      end
      u2=k2[i].split(', ')
      for j in 0...u2.length
        b.push(u2[j].gsub('Lavatain','Laevatein')) unless b.include?(u2[j]) || u2[j].include?("-") || !has_any?(g, @data[find_unit(u[j],event)][22])
      end
    end
    return ["Dancer/Singer",b]
  elsif ["legendary","legendaries","legends"].include?(name.downcase)
    l=@data.reject{|q| q[2][0]==' ' || !has_any?(g, q[22])}
    return ["Legendaries",l.map{|q| q[0]}]
  elsif ["retro-prfs"].include?(name.downcase)
    r=@skills.reject{|q| !(q[8]=='-' && q[4]=='Weapon' && q[6]!='-')}
    b=[]
    for i in 0...r.length
      u=r[i][6].split(', ')
      for j in 0...u.length
        b.push(u[j].gsub('Lavatain','Laevatein')) unless b.include?(u[j]) || !has_any?(g, @data[find_unit(u[j],event)][22])
      end
    end
    return ["Retro-Prfs",b.uniq]
  elsif ["falchionusers"].include?(name.downcase)
    k=@skills[find_skill("Falchion",event)]
    b=[]
    for i in 14...19
      u=k[i].split(', ')
      for j in 0...u.length
        b.push(u[j].gsub('Lavatain','Laevatein')) unless b.include?(u[j]) || u[j].include?("-") || !has_any?(g, @data[find_unit(u[j],event)][22])
      end
    end
    return ["FalchionUsers",b.uniq]
  elsif name.downcase=="mathoo'swaifus"
    metadata_load()
    metadata_load()
    return ["Mathoo'sWaifus",@dev_waifus]
  elsif name.downcase=="ghb"
    b=[]
    for i in 0...@data.length
      b.push(@data[i][0].gsub('Lavatain','Laevatein')) if @data[i][19].downcase.include?('g') && has_any?(g, @data[i][22])
    end
    return ["GHB",b]
  elsif name.downcase=="tempest"
    b=[]
    for i in 0...@data.length
      b.push(@data[i][0].gsub('Lavatain','Laevatein')) if @data[i][19].downcase.include?('t') && has_any?(g, @data[i][22])
    end
    return ["Tempest",b]
  elsif name.downcase=="daily_rotation"
    b=[]
    for i in 0...@data.length
      b.push(@data[i][0].gsub('Lavatain','Laevatein')) if @data[i][19].downcase.include?('d') && has_any?(g, @data[i][22])
    end
    return ["Daily_Rotation",b]
  elsif find_group(name,event)>0
    f=@groups[find_group(name,event)]
    f2=[]
    for i in 0...f[1].length
      f2.push(f[1][i].gsub('Lavatain','Laevatein')) if has_any?(g, @data[i][22])
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
  for i in 0...list.length
    mips=list[i][mode]
    mips=find_base_skill(list[i],event) if mode==-1
    mips=list[i][1][0] if mode==-2
    mips=list[i][1][1] if mode==-3
    mips=list[i][1][2] if mode==-4
    mips=list[i][2][0] if mode==-5
    mips=list[i][2][1] if mode==-6
    mips=weapon_clss(list[i][1],event) if mode==-7
    for j in 0...headers.length
      if mips==headers[j] || mips=="#{headers[j]} Users Only" || mips=="#{headers[j]}s Only" || mips=="#{headers[j]} Only"
        spli[j].push(list[i])
      elsif headers[j][headers[j].length-1,1]=="s" && mips==headers[j][0,headers[j].length-1]
        spli[j].push(list[i])
      elsif ["Passive","Passives"].include?(headers[j]) && /Passive\((A|B|C)\)/ =~ mips
        spli[j].push(list[i])
      elsif ["Passive(S)"].include?(headers[j]) && mips.include?('Seal')
        spli[j].push(list[i])
      elsif ["Passive(A)","Passive(B)","Passive(C)","Passive(S)""Passive(W)"].include?(headers[j]) && mips.include?(headers[j])
        spli[j].push(list[i])
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
      list[list.length-1][0]="- - -"
      list[list.length-1][21]=nil
    end
  end
  return list
end

def find_in_units(event, mode=0, paired=false, ignore_limit=false)
  data_load()
  groups_load()
  srv=0
  srv=event.server.id unless event.server.nil?
  args=event.message.text.split(" ")
  args[0]=nil
  args.compact!
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  colors=[]
  weapons=[]
  color_weapons=[]
  movement=[]
  tier=[]
  group=[]
  units=[]
  genders=[]
  games=[]
  for i in 0...args.length
    args[i]=args[i].downcase.gsub('user','') if args[i].length>4 && args[i][args[i].length-4,4].downcase=='user'
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens'].include?(args[i].downcase)
    color_weapons.push(['Red','Blade']) if ['sword','swords','katana'].include?(args[i].downcase)
    color_weapons.push(['Blue','Blade']) if ['lance','lances','spear','spears','naginata'].include?(args[i].downcase)
    color_weapons.push(['Green','Blade']) if ['axe','axes','ax','club','clubs'].include?(args[i].downcase)
    color_weapons.push(['Red','Tome']) if ['redtome','redtomes','redmage','redmages'].include?(args[i].downcase)
    color_weapons.push(['Blue','Tome']) if ['bluetome','bluetomes','bluemage','bluemages'].include?(args[i].downcase)
    color_weapons.push(['Green','Tome']) if ['greentome','greentomes','greenmage','greenmages'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','clear','clears'].include?(args[i].downcase)
    weapons.push('Blade') if ['physical','blade','blades'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','spell','tomes','mages','spells'].include?(args[i].downcase)
    weapons.push('Dragon') if ['dragon','dragons','breath','manakete','manaketes'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thiefs','thieves'].include?(args[i].downcase)
    weapons.push('Healer') if ['healer','staff','cleric','healers','clerics','staves'].include?(args[i].downcase)
    movement.push('Flier') if ['flier','flying','flyer','fly','pegasus','wyvern','fliers','flyers','wyverns','pegasi'].include?(args[i].downcase)
    movement.push('Cavalry') if ['cavalry','horse','pony','horsie','horses','horsies','ponies'].include?(args[i].downcase)
    movement.push('Infantry') if ['infantry','foot','feet'].include?(args[i].downcase)
    movement.push('Armor') if ['armor','armour','armors','armours','armored','armoured'].include?(args[i].downcase)
    genders.push('M') if ['male','man','boy'].include?(args[i].downcase)
    genders.push('F') if ['female','woman','girl'].include?(args[i].downcase)
    games.push('FE1') if ['fe1','bladeoflight'].include?(args[i].downcase)
    games.push('FE2') if ['fe2','gaiden'].include?(args[i].downcase)
    games.push('FE3') if ['fe3','mystery','mote','mysteryoftheemblem'].include?(args[i].downcase)
    games.push('FE4') if ['fe4','genealogy','gothw','ghw','genealogyoftheholywar'].include?(args[i].downcase)
    games.push('FE5') if ['fe5','thracia','776','thracia776'].include?(args[i].downcase)
    games.push('FE6') if ['fe6','binding',"roy'sgame","theonewithroy",'bindingblade'].include?(args[i].downcase)
    games.push('FE7') if ['fe7','blazing',"firstoneinthewest",'blazingblade'].include?(args[i].downcase)
    games.push('FE8') if ['fe8','sacred','sacredstones'].include?(args[i].downcase)
    games.push('FE9') if ['fe9','por','pathofradiance'].include?(args[i].downcase)
    games.push('FE10') if ['fe10','radiantdawn'].include?(args[i].downcase)
    games.push('FE11') if ['fe11','shadowdragon'].include?(args[i].downcase)
    games.push('FE12') if ['fe12','newmystery','newmysteryoftheemblem'].include?(args[i].downcase)
    games.push('FE13') if ['fe13','awakening','fea'].include?(args[i].downcase)
    games.push('FE15') if ['fe15','feesov','sov','shadowsofvalentia'].include?(args[i].downcase)
    games.push('FE14') if ['fe14','if','feif','fef','fates','fe14b','fe14c','birthright','conquest','fe14r','revelation'].include?(args[i].downcase)
    games.push('FE14B') if ['fe14','if','feif','fef','fates','fe14b','birthright'].include?(args[i].downcase)
    games.push('FE14C') if ['fe14','if','feif','fef','fates','fe14c','conquest'].include?(args[i].downcase)
    games.push('FE14R') if ['fe14','if','feif','fef','fates','fe14r','revelation'].include?(args[i].downcase)
    games.push('FE14g') if ['fe14g','gates'].include?(args[i].downcase)
    games.push('FE15') if ['fe15','sov'].include?(args[i].downcase)
    games.push('FEH') if ['feh','heroes'].include?(args[i].downcase)
    games.push('FEW') if ['few','warriors'].include?(args[i].downcase)
    games.push('SSBM') if ['ssbm','melee'].include?(args[i].downcase)
    games.push('SSBB') if ['ssbb','brawl'].include?(args[i].downcase)
    games.push('SSB4') if ['ssb4','sm4sh','smish'].include?(args[i].downcase)
    games.push('PXZ2') if ['projextxzone','projextxzone2','xzone','x-zone'].include?(args[i].downcase)
    games.push('STEAM') if ['codename','steam','s.t.e.a.m','codenamesteam','codename:steam','codenames.t.e.a.m.','codename:s.t.e.a.m.'].include?(args[i].downcase)
    group.push(@groups[find_group(args[i].downcase,event)]) if find_group(args[i].downcase,event)>=0 && args[i].length>=3
    unless ['red','reds','blue','blues','green','greens','sword','swords','katana','lance','lances','spear','spears','naginata','axe','axes','ax','club','clubs','axe','axes','ax','club','clubs','colorless','colourless','clear','clears','physical','blade','blades','tome','mage','magic','spell','tomes','mages','spells','dragon','dragons','manakete','manaketes','breath','bow','arrow','bows','arrows','archer','archers','dagger','shuriken','knife','daggers','knives','ninja','ninjas','thief','thieves','healer','staff','cleric','healers','clerics','staves','flier','flying','flyer','fly','pegasus','wyvern','fliers','flyers','wyverns','pegasi','cavalry','horse','pony','horsie','horses','horsies','ponies','infantry','foot','feet','armor','armour','armors','armours','armored','armoured','male','man','boy','female','woman','girl'].include?(args[i].downcase)
      units.push(@data[find_unit(args[i].downcase,event)][0]) if find_unit(args[i].downcase,event)>=0 && args[i].length>=3
      units.push("Tiki(Young)") if args[i].downcase=="tiki"
      units.push("Tiki(Adult)") if args[i].downcase=="tiki"
      units.push("Eirika(Bonds)") if args[i].downcase=="eirika"
      units.push("Eirika(Memories)") if args[i].downcase=="eirika"
      units.push("Hinoka(Launch)") if args[i].downcase=="hinoka"
      units.push("Hinoka(Wings)") if args[i].downcase=="hinoka"
      units.push("Chrom(Launch)") if args[i].downcase=="chrom"
      units.push("Chrom(Branded)") if args[i].downcase=="chrom"
      units.push("Reinhardt(Bonds)") if args[i].downcase=="reinhardt"
      units.push("Reinhardt(World)") if args[i].downcase=="reinhardt"
      units.push("Olwen(Bonds)") if args[i].downcase=="olwen"
      units.push("Olwen(World)") if args[i].downcase=="olwen"
      units.push("#{args[i][0,1].upcase}#{args[i][1,args[i].length-1].downcase}(F)") if ['robin','corrin','morgan','kana'].include?(args[i].downcase)
      units.push("#{args[i][0,1].upcase}#{args[i][1,args[i].length-1].downcase}(M)") if ['robin','corrin','morgan','kana'].include?(args[i].downcase)
    end
  end
  colors=colors.uniq
  weapons=weapons.uniq
  movement=movement.uniq
  genders=genders.uniq
  games=games.uniq
  tier=tier.uniq
  # prune based on inputs
  matches1=[]
  if colors.length>0 && weapons.length>0
    matches1=@data.reject{|q| !colors.include?(q[1][0]) || !weapons.include?(q[1][1])}
  elsif colors.length>0
    matches1=@data.reject{|q| !colors.include?(q[1][0])}
  elsif weapons.length>0
    matches1=@data.reject{|q| !weapons.include?(q[1][1])}
  else
    matches1=@data
  end
  if color_weapons.length>0
    matches1=[] if matches1==@data
    for i in 0...@data.length
      for j in 0...color_weapons.length
        matches1.push(@data[i]) if @data[i][1][0]==color_weapons[j][0] && @data[i][1][1]==color_weapons[j][1]
      end
    end
  end
  for i in 0...color_weapons.length
    colors.push(color_weapons[i][0])
  end
  matches1=matches1.uniq
  matches2=[]
  if movement.length>0
    matches2=matches1.reject{|q| !movement.include?(q[3])}
  else
    matches2=matches1
  end
  matches3=[]
  if genders.length>0
    matches3=matches2.reject{|q| !genders.include?(q[20])}
  else
    matches3=matches2
  end
  matches4=[]
  if games.length>0
    for i in 0...matches3.length
      for j in 0...games.length
        matches4.push(matches3[i]) if "#{matches3[i][21].join(',').downcase},".include?("#{games[j].downcase},")
        matches4.push(matches3[i]) if games[j]=="FE14R" && (matches3[i][21].join(',').include?("FE14C") || matches3[i][21].join(',').include?("FE14B"))
      end
    end
  else
    matches4=matches3
  end
  matches4=matches4.uniq
  matches5=[]
  if group.length>0
    for j in 0...group.length
      gg=get_group(group[j][0],event)
      for i in 0...matches4.length
        matches5.push(matches4[i]) if gg[1].include?(matches4[i][0])
      end
    end
  else
    matches5=matches4
  end
  matches5=[] if matches5==@data && units.length>0
  if units.length>0
    for i in 0...units.length
      matches5.push(@data[find_unit(units[i].downcase,event)])
    end
  end
  matches5=matches5.uniq
  g=get_markers(event)
  matches5=matches5.reject {|a| !has_any?(g, a[22])}.compact
  for i in 0...matches5.length
    matches5[i][0]=matches5[i][0].gsub('Lavatain','Laevatein')
  end
  matches5=matches5.sort {|a,b| a[0].downcase <=> b[0].downcase}
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
    elsif weapons==['Tome'] && colors==['Red'] && color_weapons.length<=0
      # Red Tomes are the only type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Fire','Dark'],-4)
    elsif weapons==['Tome'] && colors==['Blue'] && color_weapons.length<=0
      # Blue Tomes are the only type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Thunder','Light'],-4)
    elsif weapons==['Tome'] && colors==['Green'] && color_weapons.length<=0
      # Blue Tomes are the only type requested but no other restrictions are given
      matches5=split_list(event,matches5,['Wind'],-4)
    elsif matches5.length<=25
      matches5=split_list(event,matches5,['Red','Blue','Green','Colorless'],-2)
    end
  end
  if matches5.length==@data.reject{|q| find_unit(q[0],event)<0}.compact.length && !(args.nil? || args.length.zero?) && @shardizard != 4 && !event.server.nil? && event.channel.id != 283821884800499714 && mode != 3
    event.respond "Your request is gibberish." if ['unit','char','character','person','units','chars','charas','chara','people'].include?(args[0].downcase)
    return -1
  elsif mode==3
    return [matches5,colors]
  elsif matches5.length.zero?
    event.respond "There were no units that matched your request." unless paired
    return -2
  elsif matches5.map{|k| k[0]}.join("\n").length>=1900 && !event.server.nil? && !ignore_limit
    event.respond "There were so many unit matches that I would prefer you use the command in PM." unless paired
    return -2
  elsif mode==2
    return matches5
  elsif mode==1
    f=matches5.map{|k| k[0]}
    return f
  else
    matches5=matches5.uniq
    if matches5.length==0
      event.respond "No matches found."
      return false
    elsif matches5.length==1
      event.respond "#{matches5[0][0]} is your only result."
      return false
    else
      f=[]
      matches5.sort! {|a,b| a[0] <=> b[0]}
      for i in 0...matches5.length
        matches5[i][0]="__**#{matches5[i][0]}**__" if units.length>0 && units.include?(matches5[i][0])
        f.push(matches5[i][0])
      end
      return f if mode==1
      t=f[0]
      c=", "
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
  args=event.message.text.split(" ")
  args[0]=nil
  args.compact!
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
    colors.push('Green') if ['green','greens'].include?(args[i].downcase)
    color_weapons.push(['Red','Blade']) if ['sword','swords','katana'].include?(args[i].downcase)
    color_weapons.push(['Blue','Blade']) if ['lance','lances','spear','spears','naginata'].include?(args[i].downcase)
    color_weapons.push(['Green','Blade']) if ['axe','axes','ax','club','clubs'].include?(args[i].downcase)
    color_weapons.push(['Red','Tome']) if ['redtome','redtomes','redmage','redmages'].include?(args[i].downcase)
    color_weapons.push(['Blue','Tome']) if ['bluetome','bluetomes','bluemage','bluemages'].include?(args[i].downcase)
    color_weapons.push(['Green','Tome']) if ['greentome','greentomes','greenmage','greenmages'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','clear','clears'].include?(args[i].downcase)
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
    assists.push('Rally') if ['rally','rallys','rallies','stat','stats','buff','buffs'].include?(args[i].downcase)
    specials.push('Staff') if ['healer','staff','cleric','healers','clerics','staves','balm','balms'].include?(args[i].downcase)
    specials.push('Defense') if ['defense','defence','defensive','defencive','proc'].include?(args[i].downcase)
    specials.push('Damage') if ['damage','damaging','proc'].include?(args[i].downcase)
    specials.push('AoE') if ['aoe','area','spread','area_of_effect'].include?(args[i].downcase)
    passives.push('A') if ['a','apassives','apassive','passivea','passivesa','a_passives','a_passive','passive_a','passives_a'].include?(args[i].downcase)
    passives.push('B') if ['b','bpassives','bpassive','passiveb','passivesb','b_passives','b_passive','passive_b','passives_b'].include?(args[i].downcase)
    passives.push('C') if ['c','cpassives','cpassive','passivec','passivesc','c_passives','c_passive','passive_c','passives_c'].include?(args[i].downcase)
    passives.push('W') if ['w','wpassives','wpassive','passivew','passivesw','w_passives','w_passive','passive_w','passives_w'].include?(args[i].downcase)
    passives.push('Seal') if ['s','seal','seals','spassives','spassive','passives','passivess','s_passives','s_passive','passive_s','passives_s','sealpassives','sealpassive','passiveseal','passivesseal','seal_passives','seal_passive','passive_seal','passives_seal','sealspassives','sealspassive','passiveseals','passivesseals','seals_passives','seals_passive','passive_seals','passives_seals'].include?(args[i].downcase)
  end
  for i in 0...args.length
    weapon_subsets.push("Legendary") if ['legendary', 'legend', 'prf'].include?(args[i].downcase)
    weapon_subsets.push("DC") if ['dc', 'distantcounter', 'distant-counter', 'counter'].include?(args[i].downcase)
    weapon_subsets.push("Killer") if ['killer', 'killing', 'slaying', 'slayer'].include?(args[i].downcase)
    weapon_subsets.push("Effective") if ['effective'].include?(args[i].downcase)
    weapon_subsets.push("Harsh") if ['harsh'].include?(args[i].downcase)
    weapon_subsets.push("Frostbite") if ['levin', 'bolt', 'ice', 'frost', 'cold', 'frostbite'].include?(args[i].downcase)
    weapon_subsets.push("Silver") if ['silver', 'vanilla'].include?(args[i].downcase)
    weapon_subsets.push("Firesweep") if ['firesweep', 'anti-counter', 'anticounter'].include?(args[i].downcase)
    weapon_subsets.push("Life-Giver") if ['life-giver', 'lifegiver', 'bol', 'breath-of-life', 'breathoflife'].include?(args[i].downcase)
    weapon_subsets.push("WoDao") if ['wodao', 'wo-dao'].include?(args[i].downcase)
    weapon_subsets.push("Bladetome") if ['bladetome'].include?(args[i].downcase)
    weapon_subsets.push("Hogtome") if ['hogtome', 'hog'].include?(args[i].downcase)
    weapon_subsets.push("Serpenttome") if ['serpenttome', 'serpentome', 'snaketome', 'snektome', 'serpent', 'snake', 'snek'].include?(args[i].downcase)
    weapon_subsets.push("Owltome") if ['owltome', 'owl'].include?(args[i].downcase)
    weapon_subsets.push("Raventome") if ['raventome', 'raven'].include?(args[i].downcase)
    weapon_subsets.push("Wolftome") if ['wolftome', 'wolf', 'horse-killer', 'horsekiller', 'anti-horse', 'antihorse', 'cavalry-killer', 'cavalrykiller', 'anti-cavalry', 'anticavalry', 'horse-killing', 'horsekiling', 'cavalry-killing', 'cavalrykilling', 'horse-effective', 'horseeffective', 'cavalry-effective', 'cavalryeffective', 'cav-killer', 'cavkiller', 'anti-cav', 'anticav', 'cav-killing', 'cavkilling', 'cav-effective', 'caveffective', 'pony-killer', 'ponykiller', 'anti-pony', 'antipony', 'pony-killing', 'ponykilling', 'pony-effective', 'ponyeffective', 'effective'].include?(args[i].downcase)
    weapon_subsets.push("Gem") if ['gem', 'triangle', 'ta', 'triangleadept', 'triangle-adept', 'adept', 'ruby', 'sapphire', 'emerald', 'crystal'].include?(args[i].downcase)
    weapon_subsets.push("Brave") if ['brave', 'twohit', 'two-hit', 'double-hit', 'doublehit', '2-hit', '2hit', 'hit-twice', 'hittwice', 'hits-twice', 'hitstwice'].include?(args[i].downcase)
    weapon_subsets.push("Armor-killer") if ['armor-killer', 'armorkiller', 'anti-armor', 'antiarmor', 'armour-killer', 'armourkiller', 'anti-armour', 'antiarmour', 'armor-killing', 'armorkiling', 'armour-killing', 'armourkilling', 'armor-effective', 'armoreffective', 'armour-effective', 'armoureffective', 'effective'].include?(args[i].downcase)
    weapon_subsets.push("Horse-killer") if ['horse-killer', 'horsekiller', 'anti-horse', 'antihorse', 'cavalry-killer', 'cavalrykiller', 'anti-cavalry', 'anticavalry', 'horse-killing', 'horsekiling', 'cavalry-killing', 'cavalrykilling', 'horse-effective', 'horseeffective', 'cavalry-effective', 'cavalryeffective', 'cav-killer', 'cavkiller', 'anti-cav', 'anticav', 'cav-killing', 'cavkilling', 'cav-effective', 'caveffective', 'pony-killer', 'ponykiller', 'anti-pony', 'antipony', 'pony-killing', 'ponykilling', 'pony-effective', 'ponyeffective', 'effective'].include?(args[i].downcase)
    passive_subsets.push("Blow") if ['blow'].include?(args[i].downcase)
    passive_subsets.push("Bond") if ['bond'].include?(args[i].downcase)
    passive_subsets.push("Stats") if ['stats', 'stat', '+'].include?(args[i].downcase)
    passive_subsets.push("Counter") if ['counter'].include?(args[i].downcase)
    passive_subsets.push("Defense") if ['defense', 'defence', 'defensive', 'defencive'].include?(args[i].downcase)
    passive_subsets.push("Defiant") if ['defiant'].include?(args[i].downcase)
    passive_subsets.push("Brazen") if ['brazen'].include?(args[i].downcase)
    passive_subsets.push("Boost") if ['boost'].include?(args[i].downcase)
    passive_subsets.push("Chill") if ['chill'].include?(args[i].downcase)
    passive_subsets.push("Dull") if ['dull','nullify'].include?(args[i].downcase)
    passive_subsets.push("Stance") if ['stance'].include?(args[i].downcase)
    passive_subsets.push("Bladeskill") if ['bladeskill'].include?(args[i].downcase)
    passive_subsets.push("Bladeskill") if ['blade'].include?(args[i].downcase) && !skill_types.include?('weapon') && skill_types.length>0
    passive_subsets.push("Fortress") if ['fortress'].include?(args[i].downcase)
    passive_subsets.push("Shield") if ['shield'].include?(args[i].downcase)
    passive_subsets.push("Cooldown") if ['cooldown'].include?(args[i].downcase)
    passive_subsets.push("Breaker") if ['breaker'].include?(args[i].downcase)
    passive_subsets.push("Blessing") if ['blessing'].include?(args[i].downcase)
    passive_subsets.push("DanceRally") if ['dancerally', 'dance-rally', 'rally'].include?(args[i].downcase)
    passive_subsets.push("Follow-up") if ['follow-up', 'followup'].include?(args[i].downcase)
    passive_subsets.push("Fighter") if ['fighter'].include?(args[i].downcase)
    passive_subsets.push("Deflect") if ['deflect'].include?(args[i].downcase)
    passive_subsets.push("Move") if ['movement', 'move', 'moving'].include?(args[i].downcase)
    passive_subsets.push("Flight") if ['flight', 'warp', 'warping'].include?(args[i].downcase)
    passive_subsets.push("Staff") if ['staff', 'staves'].include?(args[i].downcase)
    passive_subsets.push("Damage") if ['damage'].include?(args[i].downcase)
    passive_subsets.push("StatDrops") if ['stat-drops', 'statdrops'].include?(args[i].downcase)
    passive_subsets.push("Sweep") if ['sweep', 'elementsweep'].include?(args[i].downcase)
    passive_subsets.push("Ploy") if ['ploy'].include?(args[i].downcase)
    passive_subsets.push("Smoke") if ['smoke'].include?(args[i].downcase)
    passive_subsets.push("Tactic") if ['tactic'].include?(args[i].downcase)
    passive_subsets.push("Exp") if ['exp', 'exp.', 'experience'].include?(args[i].downcase)
    passive_subsets.push("Valor") if ['valor', 'sp'].include?(args[i].downcase)
    passive_subsets.push("Spur") if ['spur', 'drive', 'goad', 'ward'].include?(args[i].downcase)
    passive_subsets.push("Fortify/Hone") if ['fortify/hone', 'fortify', 'hone'].include?(args[i].downcase)
    passive_subsets.push("Threaten") if ['threaten', 'threatening', 'threat'].include?(args[i].downcase)
    passive_subsets.push("Priority") if ['priority', 'order', 'attackorder', 'attack-order', 'attackpriority', 'attack-priority'].include?(args[i].downcase)
    passive_subsets.push("Enemy") if ['enemy', 'enemies'].include?(args[i].downcase)
  end
  colors=colors.uniq
  weapons=weapons.uniq
  skill_types=skill_types.uniq
  assists=assists.uniq
  specials=specials.uniq
  weapon_subsets=weapon_subsets.uniq
  passive_subsets=passive_subsets.uniq
  # prune based on inputs
  matches0=[]
  if skill_types.length>0
    for i in 0...@skills.length
      for j in 0...skill_types.length
        matches0.push(@skills[i]) if "#{@skills[i][19]},".include?("#{skill_types[j]},")
      end
    end
  else
    matches0=@skills.map{|q| q}
  end
  # weapon-only inputs
  matches1=[]
  if colors.length>0 && weapons.length>0
    for i in 0...matches0.length
      for j in 0...weapons.length
        for j2 in 0...colors.length
          matches1.push(matches0[i]) if matches0[i][4]=="Weapon" && "#{matches0[i][19]},".include?("#{weapons[j]},") && "#{matches0[i][19]},".include?("#{colors[j2]},")
        end
      end
    end
  elsif colors.length>0
    for i in 0...matches0.length
      for j in 0...colors.length
        matches1.push(matches0[i]) if matches0[i][4]=="Weapon" && "#{matches0[i][19]},".include?("#{colors[j]},")
      end
    end
  elsif weapons.length>0
    for i in 0...matches0.length
      for j in 0...weapons.length
        matches1.push(matches0[i]) if matches0[i][4]=="Weapon" && "#{matches0[i][19]},".include?("#{weapons[j]},")
      end
    end
  else
    matches1=matches0.reject{|q| q[4]!='Weapon'}.map{|q| q}
  end
  if color_weapons.length>0
    matches1=[] if matches1==@skills.reject{|q| q[4]!='Weapon'}
    for i in 0...@skills.length
      for j in 0...color_weapons.length
        p1=@skills[i][19]
        matches1.push(@skills[i]) if "#{p1},".include?("#{color_weapons[j][0]},") && "#{p1},".include?("#{color_weapons[j][1]},") && @skills[i][4]=="Weapon"
      end
    end
  end
  # Specific types
  matches2=matches1.map{|q| q}
  if assists.length>0
    for i in 0...matches0.length
      for j in 0...assists.length
        matches2.push(matches0[i]) if matches0[i][4]=="Assist" && "#{matches0[i][19]},".include?("#{assists[j]},")
      end
    end
  else
    for i in 0...matches0.length
      matches2.push(matches0[i]) if matches0[i][4]=="Assist"
    end
  end
  if specials.length>0
    for i in 0...matches0.length
      for j in 0...specials.length
        matches2.push(matches0[i]) if matches0[i][4]=="Special" && "#{matches0[i][19]},".include?("#{specials[j]},")
      end
    end
  else
    for i in 0...matches0.length
      matches2.push(matches0[i]) if matches0[i][4]=="Special"
    end
  end
  if passives.length>0
    for i in 0...matches0.length
      matches2.push(matches0[i]) if matches0[i][4].include?("Passive(A)") && passives.include?('A')
      matches2.push(matches0[i]) if matches0[i][4].include?("Passive(B)") && passives.include?('B')
      matches2.push(matches0[i]) if matches0[i][4].include?("Passive(C)") && passives.include?('C')
      matches2.push(matches0[i]) if matches0[i][4].include?("Seal") && passives.include?('Seal')
      matches2.push(matches0[i]) if matches0[i][4].include?("Passive(W)") && passives.include?('W')
    end
  else
    for i in 0...matches0.length
      matches2.push(matches0[i]) if "#{matches0[i][19]},".include?("Passive,")
    end
  end
  matches2=matches2.uniq
  # subsets
  matches3=[]
  if weapon_subsets.length>0
    for i in 0...matches2.length
      for j in 0...weapon_subsets.length
        matches3.push(matches2[i]) if matches2[i][4]=="Weapon" && "#{matches2[i][19]},".include?("#{weapon_subsets[j]},")
      end
    end
  elsif weapons.length>0 || colors.length>0 || color_weapons.length>0 || skill_types.include?('Weapon')
    for i in 0...matches2.length
      matches3.push(matches2[i]) if matches2[i][4]=="Weapon"
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
        matches3.push(matches2[i]) if (matches2[i][4].include?("Passive") || matches2[i][4]=="Seal") && "#{matches2[i][19]},".include?("#{passive_subsets[j]},")
      end
    end
  elsif passives.length>0 || skill_types.include?('Passive')
    for i in 0...matches2.length
      matches3.push(matches2[i]) if matches2[i][4].include?("Passive") || matches2[i][4]=="Seal"
    end
  end
  matches3=matches3.uniq
  matches4=[]
  for i in 0...matches3.length
    unless matches3[i].nil? || matches3[i][0][0,10]=="Falchion ("
      if skill_include?(matches3,"#{matches3[i][0]}+")>=0
        matches3[skill_include?(matches3,"#{matches3[i][0]}+")]=nil
        matches3[i][0]="#{matches3[i][0]}(+)"
      elsif matches3[i][0][matches3[i][0].length-1,1].to_i.to_s==matches3[i][0][matches3[i][0].length-1,1]
        v=matches3[i][0][matches3[i][0].length-1,1].to_i
        if skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+1}")>=0
          matches3[skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+1}")]=nil
          if skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+2}")>=0
            matches3[skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+2}")]=nil
            if skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+3}")>=0
              matches3[skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+3}")]=nil
              if skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+4}")>=0
                matches3[skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+4}")]=nil
                matches3[i][0]="#{matches3[i][0][0,matches3[i][0].length-1]}#{v}/#{v+1}/#{v+2}/#{v+3}/#{v+4}"
              else
                matches3[i][0]="#{matches3[i][0][0,matches3[i][0].length-1]}#{v}/#{v+1}/#{v+2}/#{v+3}"
              end
            else
              matches3[i][0]="#{matches3[i][0][0,matches3[i][0].length-1]}#{v}/#{v+1}/#{v+2}"
            end
          else
            matches3[i][0]="#{matches3[i][0][0,matches3[i][0].length-1]}#{v}/#{v+1}"
          end
        end
      end
      matches4.push(matches3[i])
    end
  end
  for i in 0...matches4.length
    matches4[i][0]=matches4[i][0].gsub('Bladeblade','Laevatein')
  end
  matches4=matches4.sort {|a,b| a[0].downcase <=> b[0].downcase}
  if skill_types.length<=0 && weapons==['Staff'] && assists==['Staff'] && specials==['Staff']
    # Staff skills are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Weapons','Assists','Specials','Passives'],4)
  elsif (weapons==['Blade'] && colors.length<=0 && color_weapons.length<=0) || (color_weapons.length>0 && color_weapons.map{|q| q[1]}.reject{|q| q=='Blade'}.length<=0 && weapons.length<=0 && colors.length<=0)
    # Blades are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Sword','Lance','Axe','Rod'],5)
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
  elsif weapons==['Tome'] && colors==['Red'] && color_weapons.length<=0
    # Red Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Fire',"Rau\u00F0r",'Flux'],-1)
  elsif weapons==['Tome'] && colors==['Blue'] && color_weapons.length<=0
    # Blue Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Thunder',"Bl\u00E1r",'Light'],-1)
  elsif weapons==['Tome'] && colors==['Green'] && color_weapons.length<=0
    # Green Tomes are the only type requested but no other restrictions are given
    matches4=split_list(event,matches4,['Wind',"Gronn"],-1)
  elsif matches4.length<=25 && matches4.map{|q| q[4]}.uniq.length==1 && matches4.map{|q| q[4]}.uniq[0]=="Weapon"
    matches4=split_list(event,matches4,['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Rod','Colorless Tome','Dragon','Bow','Dagger','Staff'],5)
  end
  data_load()
  miniskills=@skills.map{|q| q}
  microskills=[]
  k=0
  k=event.server.id unless event.server.nil?
  g=get_markers(event)
  for i in 0...miniskills.length
    unless miniskills[i].nil?
      if skill_include?(miniskills,"#{miniskills[i][0]}+")>=0
        miniskills[skill_include?(miniskills,"#{miniskills[i][0]}+")]=nil
        miniskills[i][0]="#{miniskills[i][0]}(+)"
      elsif miniskills[i][0][miniskills[i][0].length-1,1].to_i.to_s==miniskills[i][0][miniskills[i][0].length-1,1]
        v=miniskills[i][0][miniskills[i][0].length-1,1].to_i
        if skill_include?(miniskills,"#{miniskills[i][0][0,miniskills[i][0].length-1]}#{v+1}")>=0
          miniskills[skill_include?(miniskills,"#{miniskills[i][0][0,miniskills[i][0].length-1]}#{v+1}")]=nil
          if skill_include?(miniskills,"#{miniskills[i][0][0,miniskills[i][0].length-1]}#{v+2}")>=0
            miniskills[skill_include?(miniskills,"#{miniskills[i][0][0,miniskills[i][0].length-1]}#{v+2}")]=nil
            miniskills[i][0]="#{miniskills[i][0][0,miniskills[i][0].length-1]}#{v}/#{v+1}/#{v+2}"
          else
            miniskills[i][0]="#{miniskills[i][0][0,miniskills[i][0].length-1]}#{v}/#{v+1}"
          end
        end
      end
      microskills.push(miniskills[i]) if has_any?(g, miniskills[i][21])
    end
  end
  matches4=matches4.reject{|q| !has_any?(g, q[21])}
  data_load()
  if matches4.length==microskills.length && !(args.nil? || args.length.zero?) && !event.server.nil?
    event.respond "Your request is gibberish." if ['skill','skills'].include?(args[0].downcase)
    return -1
  elsif matches4.length.zero?
    event.respond "There were no skills that matched your request." unless paired
    return -2
  elsif matches4.map{|k| k[0]}.join("\n").length>=1900 && !event.server.nil?
    event.respond "\* \* \*" if !brk.is_a?(Array)
    event.respond "There were so many skill matches that I would prefer you use the command in PM." unless paired
    return -2
  elsif mode==1
    f=matches4.map{|k| k[0].gsub('Bladeblade','Laevatein')}
    return f
  else
    event.respond "\* \* \*" if !brk.is_a?(Array)
    t=matches4[0][0]
    c=", "
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
  k=find_in_units(event,mode)
  if mode==1 && k.is_a?(Array)
    k=k.map{|q| "#{"~~" if !["Laevatein","- - -"].include?(q) && !@data[find_unit(q,event,false,true)][22].nil?}#{q}#{"~~" if !["Laevatein","- - -"].include?(q) && !@data[find_unit(q,event,false,true)][22].nil?}"}
    if k.include?("- - -")
      p1=[[]]
      p2=0
      for i in 0...k.length
        if k[i]=="- - -"
          p2+=1
          p1.push([])
        else
          p1[p2].push(k[i])
        end
      end
      for i in 0...p1.length
        wpn1=p1[i].map{|q| @data[find_unit(q,event,false,true)][1]}
        h="."
        if wpn1.uniq.length==1
          # blade type
          h="Swords" if p1[i].include?("Alfonse") || (wpn1[0]==["Red", "Blade"])
          h="Lances" if p1[i].include?("Sharena") || (wpn1[0]==["Blue", "Blade"])
          h="Axes" if p1[i].include?("Anna") || (wpn1[0]==["Green", "Blade"])
          h="Rods" if wpn1.uniq==0 && wpn1[0]==["Colorless", "Blade"]
          # Magic types
          h="Fire Mages" if p1[i].include?("Lilina") || (wpn1[0]==["Red", "Tome", "Fire"])
          h="Dark Mages" if p1[i].include?("Raigh") || (wpn1[0]==["Red", "Tome", "Dark"])
          h="Thunder Mages" if p1[i].include?("Odin") || (wpn1[0]==["Red", "Tome", "Thunder"])
          h="Light Mages" if p1[i].include?("Micaiah") || (wpn1[0]==["Red", "Tome", "Light"])
          h="Wind Mages" if p1[i].include?("Cecilia") || (wpn1[0]==["Green", "Tome", "Wind"])
          # Dragon colors
          h="Red Dragons" if p1[i].include?("Tiki(Young)") || (wpn1[0]==["Red", "Dragon"])
          h="Blue Dragons" if p1[i].include?("Nowi") || (wpn1[0]==["Blue", "Dragon"])
          h="Green Dragons" if p1[i].include?("Fae") || (wpn1[0]==["Green", "Dragon"])
          h="Colorless Dragons" if p1[i].include?("Robin(F)(Fallen)") || (wpn1.uniq==0 && wpn1[0]==["Colorless", "Dragon"])
          # archer colors
          h="Red Archers" if (wpn1[0]==["Red", "Bow"])
          h="Blue Archers" if (wpn1[0]==["Blue", "Bow"])
          h="Green Archers" if (wpn1[0]==["Green", "Bow"])
          h="Colorless Archers" if p1[i].include?("Takumi") || (wpn1[0]==["Colorless", "Bow"])
          # dagger colors
          h="Red Thieves" if wpn1[0]==["Red", "Dagger"]
          h="Blue Thieves" if wpn1[0]==["Blue", "Dagger"]
          h="Green Thieves" if wpn1[0]==["Green", "Dagger"]
          h="#{"Colorless " if colored_daggers?(event)}Thieves" if p1[i].include?("Matthew") || (wpn1[0]==["Colorless", "Dagger"])
          # healer colors
          h="Red Healers" if wpn1[0]==["Red", "Healer"]
          h="Blue Healers" if wpn1[0]==["Blue", "Healer"]
          h="Green Healers" if wpn1[0]==["Green", "Healer"]
          h="#{"Colorless " if colored_healers?(event)}Healers" if p1[i].include?("Sakura") || (wpn1[0]==["Colorless", "Healer"])
        elsif wpn1.length>1 && wpn1.map{|q| [q[0],q[1]]}.uniq.length==1
          h="Red Mages" if (p1[i].include?("Lilina") && p1[i].include?("Raigh")) || (wpn1.map{|q| [q[0],q[1]]}.include?(["Red", "Tome"]))
          h="Blue Mages" if (p1[i].include?("Odin") && p1[i].include?("Micaiah")) || (wpn1.map{|q| [q[0],q[1]]}.include?(["Blue", "Tome"]))
          h="Green Mages" if p1[i].include?("Cecilia") || (wpn1.map{|q| [q[0],q[1]]}.include?(["Green", "Tome"]))
          h="Colorless Mages" if (wpn1.map{|q| [q[0],q[1]]}.include?(["Colorless", "Tome"]))
        elsif wpn1.length>1 && wpn1.map{|q| q[0]}.uniq.length==1
          h="Red" if (wpn1.map{|q| q[0]}.include?("Red"))
          h="Blue" if (wpn1.map{|q| q[0]}.include?("Blue"))
          h="Green" if (wpn1.map{|q| q[0]}.include?("Green"))
          h="Colorless" if (wpn1.map{|q| q[0]}.include?("Colorless"))
        end
        if h=="." && wpn1[0]=="Tome"
          h=wpn1[0][2]
          for l in 0...p1[i].length
            h=@data[find_unit(p1[i][l],event,false,true)][1][0] if h != @data[find_unit(p1[i][l],event,false,true)][1][2]
          end
          h="#{h} Mages"
        end
        p1[i]=[h,p1[i].join("\n")]
      end
      create_embed(event,"Results",'',0x9400D3,nil,nil,p1)
    else
      l=0
      l=1 if k.length%3==2
      m=0
      m=1 if k.length%3==1
      p1=k[0,k.length/3+l].join("\n")
      p2=k[k.length/3+l,k.length/3+m].join("\n")
      p3=k[2*(k.length/3)+l+m,k.length/3+l].join("\n")
      if p1.length+p2.length+p3.length<=1900
        if p2.length==0
          create_embed(event,"Results",'',0x9400D3,nil,nil,[['.',p1],['.',p3]])
        elsif p1.length==0
          create_embed(event,"Results",p2,0x9400D3)
        else
          create_embed(event,"Results",'',0x9400D3,nil,nil,[['.',p1],['.',p2],['.',p3]])
        end
      elsif !event.server.nil?
        event.respond "There are so many unit results that I would prefer that you post this in PM."
      else
        t=k[0]
        if k.length>1
          for i in 1...k.length
            if "#{t}\n#{k[i]}".length>=2000
              event.respond t
              t=k[i]
            else
              t="#{t}\n#{k[i]}"
            end
          end
        end
        event.respond t
      end
    end
  end
end

def display_skills(event, mode)
  k=find_in_skills(event,mode)
  if mode==1 && k.is_a?(Array)
    k=k.map{|q| "#{"~~" if !["Laevatein","- - -"].include?(q) && !@skills[find_skill(stat_buffs(q.gsub('(+)','+').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','')),event,false,true)][21].nil?}#{q}#{"~~" if !["Laevatein","- - -"].include?(q) && !@skills[find_skill(stat_buffs(q.gsub('(+)','+').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','')),event,false,true)][21].nil?}"}
    if k.include?("- - -")
      p1=[[]]
      p2=0
      for i in 0...k.length
        if k[i]=="- - -"
          p2+=1
          p1.push([])
        else
          p1[p2].push(k[i])
        end
      end
      for i in 0...p1.length
        types=p1[i].map{|q| @skills[find_skill(stat_buffs(q.gsub('~~','').gsub('(+)','+').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','')),event)]}
        types=types.map{|q| [q[4],q[5],find_base_skill(q,event)]}.uniq
        for j in 0...types.length
          types[j][0]="Passive" if types[j][0].include?("Passive") || types[j][0]=="Seal"
          types[j][2]=nil if ["Passive","Assist","Special"].include?(types[j][0])
          types[j].compact!
        end
        types.uniq!
        h="."
        if types.length==1
          # staff type
          if types[0][1]=="Staff Users Only"
            h="Damaging Staves" if p1[i].include?("Assault") || types[0][0]=="Weapon"
            h="Healing Staves" if p1[i].include?("Heal") || types[0][0]=="Assist"
            h="Healer Specials" if p1[i].include?("Imbue") || types[0][0]=="Special"
            h="Healer Passives" if p1[i].include?("Live to Serve 1/2/3") || types[0][0]=="Passive"
          end
          # weapons
          if types[0][0]=="Weapon"
            # blade type
            h="Swords" if p1[i].include?("Iron Sword") || types[0][1]=="Sword Users Only"
            h="Lances" if p1[i].include?("Iron Lance") || types[0][1]=="Lance Users Only"
            h="Axes" if p1[i].include?("Iron Axe") || types[0][1]=="Axe Users Only"
            # tome type
            h="Fire Magic" if p1[i].include?("Fire") || types[0][2]=="Fire"
            h="Dark Magic" if p1[i].include?("Flux") || types[0][2]=="Flux"
            h="Rau\u00F0r Magic" if p1[i].include?("Raudrblade(+)") || types[0][2]=="Rau\u00F0r"
            h="Thunder Magic" if p1[i].include?("Thunder") || types[0][2]=="Thunder"
            h="Light Magic" if p1[i].include?("Light") || types[0][2]=="Light"
            h="Bl\u00E1r Magic" if p1[i].include?("Blarblade(+)") || types[0][2]=="Bl\u00E1r"
            h="Wind Magic" if p1[i].include?("Wind") || types[0][2]=="Wind"
            h="Gronn Magic" if p1[i].include?("Gronnblade(+)") || types[0][2]=="Gronn"
            # Breaths
            h="Dragon Breaths" if p1[i].include?("Fire Breath(+)") || types[0][1]=="Dragons Only"
            # Bows
            h="Bows" if p1[i].include?("Iron Bow") || types[0][1]=="Bow Users Only"
            # daggers
            h="Daggers" if p1[i].include?("Iron Dagger") || types[0][1]=="Dagger Users Only"
          end
        elsif types.length>1 && types.map{|q| [q[0],q[1]]}.uniq.length==1
          h="Red Tomes" if types.map{|q| q[2]}.include?("Fire") && types.map{|q| q[2]}.include?("Flux")
          h="Blue Tomes" if types.map{|q| q[2]}.include?("Thunder") && types.map{|q| q[2]}.include?("Light")
          h="Green Tomes" if types.map{|q| q[2]}.include?("Wind") && types.map{|q| q[2]}.include?("Gronn")
        end
        p1[i]=[h,p1[i].join("\n")]
      end
      create_embed(event,"Results",'',0x9400D3,nil,nil,p1)
    else
      l=0
      l=1 if k.length%3==2
      m=0
      m=1 if k.length%3==1
      p1=k[0,k.length/3+l].join("\n")
      p2=k[k.length/3+l,k.length/3+m].join("\n")
      p3=k[2*(k.length/3)+l+m,k.length/3+l].join("\n")
      if p1.length+p2.length+p3.length<=1900
        if p2.length==0
          create_embed(event,"Results",'',0x9400D3,nil,nil,[['.',p1],['.',p3]])
        elsif p1.length==0
          create_embed(event,"Results",p2,0x9400D3)
        else
          create_embed(event,"Results",'',0x9400D3,nil,nil,[['.',p1],['.',p2],['.',p3]])
        end
      else
        t=k[0]
        if k.length>1
          for i in 1...k.length
            if "#{t}\n#{k[i]}".length>=2000
              event.respond t
              t=k[i]
            else
              t="#{t}\n#{k[i]}"
            end
          end
        end
        event.respond t
      end
    end
  elsif !event.server.nil?
  else
    t=k[0]
    if k.length>1
      for i in 1...k.length
        if "#{t}\n#{k[i]}".length>=2000
          event.respond t
          t=k[i]
        else
          t="#{t}\n#{k[i]}"
        end
      end
    end
    event.respond t
  end
end

def supersort(a,b,m)
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
    a[a.length-1]=nil
    a.uniq!
    a.compact!
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
    k="th"
    unless (number%100)/10==1
      k="st" if number%10==1
      k="nd" if number%10==2
      k="rd" if number%10==3
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
  for i in 0...arr.length
    g.push("FE1 - *Fire Emblem: Shadow Dragon and the Blade of Light*") if arr[i]=="FE1"
    g.push("FE2 - *Fire Emblem: Gaiden*") if arr[i]=="FE2"
    g.push("FE3 - *Fire Emblem: Mystery of the Emblem*") if arr[i]=="FE3"
    g.push("FE4 - *Fire Emblem: Genealogy of the Holy War*") if arr[i]=="FE4"
    g.push("FE5 - *Fire Emblem: Thracia 776*") if arr[i]=="FE5"
    g.push("FE6 - *Fire Emblem: The Binding Blade*") if arr[i]=="FE6"
    g.push("FE7 - *Fire Emblem: [The Blazing Blade]*") if arr[i]=="FE7"
    g.push("FE8 - *Fire Emblem: The Sacred Stones*") if arr[i]=="FE8"
    g.push("FE9 - *Fire Emblem: Path of Radiance*") if arr[i]=="FE9"
    g.push("FE10 - *Fire Emblem: Radiant Dawn*") if arr[i]=="FE10"
    g.push("FE11 - *Fire Emblem: Shadow Dragon*") if arr[i]=="FE11"
    g.push("FE12 - *Fire Emblem: New Mystery of the Emblem*") if arr[i]=="FE12"
    g.push("FE13 - *Fire Emblem: Awakening*") if arr[i]=="FE13"
    if arr[i]=="FE14"
      g.push("FE14 - *Fire Emblem: Fates* (All paths)")
    elsif arr[i].include?("FE14")
      g.push("FE14 - *Fire Emblem: Fates: Birthright*") if arr[i][4,1].downcase=='b'
      g.push("FE14 - *Fire Emblem: Fates: Conquest*") if arr[i][4,1].downcase=='c'
      g.push("FE14 - *Fire Emblem: Fates: Revelation*") if arr[i][4,1].downcase=='r' || arr[i][4,1]!=arr[i][4,1].downcase
      g.push("FE14x - *Fire Emblem: Gates*") if arr[i][4,1].downcase=='g'
    end
    g.push("FE15 - *Fire Emblem Echoes: Shadows of Valentia*") if arr[i]=="FE15"
    g.push("FEH - *Fire Emblem: Heroes*") if arr[i]=="FEH"
    g.push("FEW - *Fire Emblem Warriors*") if arr[i]=="FEW"
    g.push("*Super Smash Bros.: Melee*") if arr[i]=="SSBM"
    g.push("*Super Smash Bros.: Brawl*") if arr[i]=="SSBB"
    g.push("*Super Smash Bros. for 3DS and Wii U*") if arr[i]=="SSB4"
    g.push("*Project X Zone 2*") if arr[i]=="PXZ2"
    g.push("*Codename: S.T.E.A.M.*") if arr[i]=="STEAM"
  end
  g.push("FEH - *Fire Emblem: Heroes* (obviously)") if !g.include?("FEH - *Fire Emblem: Heroes*") && includefeh && g.length>0
  g.push("No games") if g.length<=0
  return g
end

def comparison(event,args)
  event.channel.send_temporary_message("Calculating data, please wait...",3)
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
    x=detect_dual_unit_alias(k[i],k[i],1)
    str=k[i]
    if k[i].downcase=="mathoo's"
      k2.push(str)
    elsif !x.nil? && x[1].is_a?(Array) && x[1].length>1
      if (i>0 && !detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]}}",1).nil?) || (i<k.length-1 && !detect_dual_unit_alias(k[i],"#{k[i]} #{k[i+1]}}",1).nil?) || (i>0 && i<k.length-1 && !detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}}",1).nil?)
        if i>0 && i<k.length-1 && !detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}}",1).nil?
          x=detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}",1)
        elsif i>0 && !detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]}}",1).nil?
          x=detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]}}",1)
        elsif i<k.length-1 && !detect_dual_unit_alias(k[i],"#{k[i]} #{k[i+1]}}",1).nil?
          x=detect_dual_unit_alias(k[i],"#{k[i]} #{k[i+1]}",1)
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
  m=false
  for i in 0...k.length
    if find_name_in_string(event,sever(k[i]))!=nil
      r=find_stats_in_string(event,sever(k[i]))
      u=@data[find_unit(find_name_in_string(event,sever(k[i])),event)]
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
      b.push([st,"#{r[0]}\\* #{name} #{"+#{r[1]}" if r[1]>0} #{"(+#{r[2]}, -#{r[3]})" unless ['',' '].include?(r[2]) && ['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}"])
      c.push(unit_color(event,find_unit(find_name_in_string(event,sever(k[i])),event),1,m))
    elsif k[i].downcase=="mathoo's"
      m=true
    end
  end
  if b.length<2
    event.respond "I need at least two units in order to compare anything."
    return 0
  elsif b.length>2
    stzzz=['BST','HP','Attack','Speed','Defense','Resistance']
    dzz=[]
    czz=[]
    hstats=[[0,[]],[0,[]],[0,[]],[0,[]],[0,[]],[0,[]]]
    event.respond "I detect #{b.length} names.\nUnfortunately, due to embed limits, I can only compare ten names\nand due to the formatting of this command, plaintext is not an answer." if b.length>10
    for iz in 0...[b.length, 10].min
      dzz.push(["**#{b[iz][1]}**",[],0])
      czz.push(c[iz])
      for jz in 1...6
        stz=b[iz][0][jz]
        dzz[iz][2]+=stz
        dzz[iz][1].push("#{stzzz[jz]}: #{stz}")
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
    dzz.push(["Analysis",[]])
    for iz in 1...6
      if hstats[iz][1].length>=[b.length, 10].min
        dzz[dzz.length-1][1].push("Constant #{stzzz[iz]}: #{hstats[iz][0]}")
      else
        dzz[dzz.length-1][1].push("Highest #{stzzz[iz]}: #{hstats[iz][0]} (#{hstats[iz][1].join(', ')})")
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
    create_embed(event,"**Comparing units**",'',avg_color(czz),nil,nil,dzz,-1)
    return b.length
  end
  stzzz=['','HP','Attack','Speed','Defense','Resistance']
  d1=[b[0][1],[],0]
  d2=[b[1][1],[],0]
  d3=["Analysis",[]]
  for i in 1...6
    d1[1].push("#{stzzz[i]}: #{b[0][0][i]}")
    d2[1].push("#{stzzz[i]}: #{b[1][0][i]}")
    d1[2]+=b[0][0][i]
    d2[2]+=b[1][0][i]
    if b[0][0][i]==b[1][0][i]
      d3[1].push("Equal #{stzzz[i]}")
    elsif b[0][0][i]>b[1][0][i]
      d3[1].push("#{b[0][0][0]} has #{b[0][0][i]-b[1][0][i]} more #{stzzz[i]}")
    elsif b[0][0][i]<b[1][0][i]
      d3[1].push("#{b[1][0][0]} has #{b[1][0][i]-b[0][0][i]} more #{stzzz[i]}")
    else
      d3[1].push("#{stzzz[i]} calculation error")
    end
  end
  d1[1].push('')
  d2[1].push('')
  d3[1].push('')
  d1[1].push("BST: #{d1[2]}")
  d2[1].push("BST: #{d2[2]}")
  if d1[2]==d2[2]
    d3[1].push("Equal BST")
  elsif d1[2]>d2[2]
    d3[1].push("#{b[0][0][0]} has #{d1[2]-d2[2]} more BST")
  elsif d1[2]<d2[2]
    d3[1].push("#{b[1][0][0]} has #{d2[2]-d1[2]} more BST")
  else
    d3[1].push("#{stzzz[i]} calculation error")
  end
  d1[1]=d1[1].join("\n")
  d2[1]=d2[1].join("\n")
  d3[1]=d3[1].join("\n")
  d1[2]=nil
  d2[2]=nil
  d1.compact!
  d2.compact!
  create_embed(event,"**Comparing #{b[0][0][0]} and #{b[1][0][0]}**",'',avg_color([c[0],c[1]]),nil,nil,[d1,d2,d3],-1)
  return 2
end

def detect_dual_unit_alias(str1,str2,robinmode=0)
  str1=str1.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  return [str1,'Robin(F)(Fallen)'] if str1=='lobin'
  str3=str2.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  str2=str2.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  if /blu(e|)cina/ =~ str1
    str="blucina"
    str="bluecina" if str2.include?('bluecina')
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Lucina(Spring)','Lucina(Brave)']]
  elsif /b(r|)lyn/ =~ str1
    str="blyn"
    str="brlyn" if str2.include?('brlyn')
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Lyn(Bride)','Lyn(Brave)']]
  elsif /ax(e|)(-|)(z|)ura/ =~ str1
    str="axura"
    str="axeura" if str2.include?("axeura")
    str="ax-ura" if str2.include?("ax-ura")
    str="axe-ura" if str2.include?("axe-ura")
    str="axzura" if str2.include?("axzura")
    str="axezura" if str2.include?("axezura")
    str="ax-zura" if str2.include?("ax-zura")
    str="axe-zura" if str2.include?("axe-zura")
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Azura(Performing)','Azura(Winter)']]
  elsif /(eirika|eirik|eiriku|erika)/ =~ str1
    str="eirik"
    str="eiriku" if str2.include?("eiriku")
    str="eirika" if str2.include?("eirika")
    str="erika" if str2.include?("erika")
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("bonds") || str2.include?("#{str}b") || str2.include?("b#{str}") || str2.include?("fb")
      return [str,['Eirika(Bonds)']]
    elsif str2.include?("memories") || str2.include?("#{str}m") || str2.include?("m#{str}") || str2.include?("sm") || str2.include?("mage#{str}") || str2.include?("#{str}mage")
      return [str,['Eirika(Memories)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Eirika(Bonds)','Eirika(Memories)']]
  elsif /hinoka/ =~ str1
    str="hinoka"
    if str2.include?("launch")
      return [str,['Hinoka(Launch)']]
    elsif str2.include?("wings") || str2.include?("kinshi") || str2.include?("winged")
      return [str,['Hinoka(Wings)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Hinoka(Launch)','Hinoka(Wings)']]
  elsif /(chrom|kuromu)/ =~ str1
    str="chrom"
    str="kuromu" if str2.include?("kuromu")
    if str2.include?("winter") || str2.include?("christmas") || str2.include?("holiday") || str2.include?("we")
      return [str,['Chrom(Winter)']]
    elsif str2.include?("bunny") || str2.include?("spring") || str2.include?("easter") || str2.include?("sf")
      return [str,['Chrom(Spring)']]
    elsif str2.include?("launch") || str2.include?("prince")
      return [str,['Chrom(Launch)']]
    elsif str2.include?("branded") || str2.include?("brand") || str2.include?("exalted") || str2.include?("exalt") || str2.include?("king") || str2.include?("sealed") || str2.include?("horse")
      return [str,['Chrom(Branded)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Chrom(Launch)','Chrom(Branded)']]
  elsif /(reinhardt|rainharuto)/ =~ str1
    str="reinhardt"
    str="rainharuto" if str2.include?("rainharuto")
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("bonds") || str2.include?("#{str}b") || str2.include?("b#{str}") || str2.include?("sb") || str2.include?("mage#{str}") || str2.include?("#{str}mage")
      return [str,['Reinhardt(Bonds)']]
    elsif str2.include?("world") || str2.include?("warudo") || str2.include?("#{str}w") || str2.include?("w#{str}") || str2.include?("wot") || str2.include?("wt")
      return [str,['Reinhardt(World)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Reinhardt(Bonds)','Reinhardt(World)']]
  elsif /(olwen|oruen)/ =~ str1
    str="olwen"
    str="oruen" if str2.include?("oruen")
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("bonds") || str2.include?("#{str}b") || str2.include?("b#{str}") || str2.include?("sb") || str2.include?("mage#{str}") || str2.include?("#{str}mage")
      return [str,['Olwen(Bonds)']]
    elsif str2.include?("world") || str2.include?("warudo") || str2.include?("wind") || str2.include?("#{str}w") || str2.include?("w#{str}") || str2.include?("wot") || str2.include?("wt")
      return [str,['Olwen(World)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Olwen(Bonds)','Olwen(World)']]
  elsif /(corrin|kamui)/ =~ str1
    str="corrin"
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    if str2.include?("summer") || str2.include?("beach") || str2.include?("swimsuit") || str2.include?("ns")
      return [str,['Corrin(F)(Summer)']]
    elsif str2.include?("winter") || str2.include?("newyear") || str2.include?("holiday") || str2.include?("ny")
      return [str,['Corrin(M)(Winter)']]
    end
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female") || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Corrin(F)']]
    elsif str2.include?("male") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Corrin(M)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Corrin(M)','Corrin(F)']]
  elsif /(tiki|chiki)/ =~ str1
    str="tiki"
    str="chiki" if str2.include?("chiki")
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    if str2.include?("summer") || str2.include?("beach") || str2.include?("swimsuit") || str2.include?("ys")
      return [str,['Tiki(Adult)(Summer)']]
    end
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('young') || str2.include?('child') || str2.include?('loli') || str2.include?("#{str}c") || str2.include?("c#{str}") || str2.include?("#{str}y") || str2.include?("y#{str}")
      return [str,['Tiki(Young)']]
    elsif str2.include?('adult') || str2.include?('old') || str2.include?("#{str}a") || str2.include?("a#{str}")
      return [str,['Tiki(Adult)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Tiki(Young)','Tiki(Adult)']]
  elsif /(robin|reflet|daraen)/ =~ str1
    str="robin"
    str="reflet" if str2.include?("reflet")
    str="daraen" if str2.include?("daraen")
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    if str=="robin" && (str2.include?("gaiden") || str2.include?("sov"))
      return [str,['Tobin']]
    elsif str2.include?("summer") || str2.include?("beach") || str2.include?("swimsuit") || str2.include?("ys")
      return [str,['Robin(F)(Summer)']]
    elsif str2.include?("winter") || str2.include?("christmas") || str2.include?("holiday") || str2.include?("we")
      return [str,['Robin(M)(Winter)']]
    elsif str2.include?("fallen") || str2.include?("evil") || str2.include?("dark") || str2.include?("alter") || str2.include?("fh") || str2.include?("grima")
      strx="fallen"
      strx="evil" if str2.include?("evil")
      strx="dark" if str2.include?("dark")
      strx="alter" if str2.include?("alter")
      strx="fh" if str2.include?("fh")
      strx="grima" if str2.include?("grima")
      str2=str3.gsub(strx,'').gsub("#{str} ",str).gsub(" #{str}",str)
      if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}") || str2.include?("legendary")
        return [str,['Robin(F)(Fallen)']]
      elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
        return [str,['Robin(M)(Fallen)']]
      end
      return [str,['Robin(M)(Fallen)','Robin(F)(Fallen)']]
    elsif str2.include?("legendary")
      return [str,['Robin(F)(Fallen)']]
    end
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Robin(F)']]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Robin(M)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Robin']] if robinmode==0
    return [str,['Robin(M)','Robin(F)']] if robinmode==1
  elsif /grima/ =~ str1
    str="grima"
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}") || str2.include?("legendary")
      return [str,['Robin(F)(Fallen)']]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Robin(M)(Fallen)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Robin(M)(Fallen)','Robin(F)(Fallen)']]
  elsif /(morgan|marc|linfan)/ =~ str1
    str="morgan"
    str="marc" if str2.include?("marc")
    str="linfan" if str2.include?("linfan")
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Morgan(F)']]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Morgan(M)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Morgan(M)','Morgan(F)']]
  elsif /kan(n|)a/ =~ str1
    str="kana"
    str="kanna" if str2.include?("kanna")
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Kana(F)']]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Kana(M)']]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Kana(M)','Kana(F)']]
  end
  return nil
end

def weapon_clss(arr,event,mode=0)
  x="#{arr[0]} #{arr[1]}"
  return 'Healer' if x=='Colorless Healer' && !colored_healers?(event)
  return 'Dagger' if x=='Colorless Dagger' && !colored_daggers?(event)
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
  event.channel.send_temporary_message("Calculating data, please wait...",event.message.text.length/30-1) if event.message.text.length>90
  k=find_name_in_string(event,nil,1)
  w=nil
  if k.nil?
    if event.message.text.downcase.include?("flora") && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
      event.respond "Steel's waifu is not in the game."
    elsif !detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true)
      disp_unit_skills(bot,x[1],event,true,true) unless x[1].is_a?(Array) && x[1].length>1
      event.respond "For these characters' skills, please use the command `FEH!skills #{x[0]}`." if x[1].is_a?(Array) && x[1].length>1
    else
      event.respond "No matches found."
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.nil?
  data_load()
  if !detect_dual_unit_alias(str.downcase,event.message.text.downcase).nil?
    x=detect_dual_unit_alias(str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,true)
    disp_unit_skills(bot,x[1],event,true,true) unless x[1].is_a?(Array) && x[1].length>1
    event.respond "For these characters' skills, please use the command `FEH!skills #{x[0]}`." if x[1].is_a?(Array) && x[1].length>1
  elsif !detect_dual_unit_alias(str.downcase,str.downcase).nil?
    x=detect_dual_unit_alias(str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,true)
    disp_unit_skills(bot,x[1],event,true,true) unless x[1].is_a?(Array) && x[1].length>1
    event.respond "For these characters' skills, please use the command `FEH!skills #{x[0]}`." if x[1].is_a?(Array) && x[1].length>1
  elsif find_unit(str,event)>=0
    disp_stats(bot,str,w,event)
    disp_unit_skills(bot,str,event,true,true)
  else
    event.respond "No matches found"
  end
  return nil
end

def skill_comparison(event,args)
  event.channel.send_temporary_message("Calculating data, please wait...",3)
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
    x=detect_dual_unit_alias(k[i],k[i],1)
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
      u=@data[find_unit(find_name_in_string(event,sever(k[i])),event)]
      name=u[0]
      if m && find_in_dev_units(name)>=0
        dv=@dev_units[find_in_dev_units(name)]
        r[0]=dv[1]
      end
      st=[]
      st=unit_skills(name,event,false,r[0]) if i<=1
      b.push([st,"#{r[0]}\\* #{name}",name])
      c.push(unit_color(event,find_unit(find_name_in_string(event,sever(k[i])),event),1,m))
    elsif k[i].downcase=="mathoo's"
      m=true
    end
  end
  if b.length<2
    event.respond "I need at least two units in order to compare anything."
    return 0
  elsif b.length>2
    event.respond "I detect #{b.length} names.\nUnfortunately, due to embed limits, I can only compare two units' skillsets."
  end
  b2=[[],[],[],[],[],[]]
  for i in 0...b[0][0].length
    if b[0][0][i]==b[1][0][i]
      b2[i]=b[0][0][i]
    elsif b[0][0][i].map{|q| q.gsub("**",'')}==b[1][0][i].map{|q| q.gsub("**",'')}
      for i2 in 0...b[0][0][i].length
        if b[0][0][i][i2]==b[1][0][i][i2]
          b2[i].push(b[0][0][i][i2])
        else
          b2[i].push("*#{b[0][0][i][i2].gsub("**",'')}*")
        end
      end
    elsif b[0][0][i]==["~~none~~"]
      b2[i]=["~~only #{b[1][2]}~~"]
    elsif b[1][0][i]==["~~none~~"]
      b2[i]=["~~only #{b[0][2]}~~"]
    elsif has_any?(b[0][0][i],b[1][0][i])
      b2[i].push("~~different starts~~") if b[0][0][i][0].gsub("**",'').gsub("~~",'')!=b[1][0][i][0].gsub("**",'').gsub("~~",'')
      for i2 in 0...b[0][0][i].length
        if b[1][0][i].include?(b[0][0][i][i2])
          b2[i].push(b[0][0][i][i2])
        elsif b[1][0][i].map{|q| q.gsub("**",'')}.include?(b[0][0][i][i2].gsub("**",''))
          b2[i].push("*#{b[0][0][i][i2].gsub("**",'')}*")
        elsif b[1][0][i].map{|q| q.gsub("~~",'')}.include?(b[0][0][i][i2].gsub("~~",''))
          b2[i].push("~#{b[0][0][i][i2].gsub("~~",'')}~")
        elsif b[1][0][i].map{|q| q.gsub("~~",'').gsub("**",'')}.include?(b[0][0][i][i2].gsub("~~",'').gsub("**",''))
          b2[i].push("*~#{b[0][0][i][i2].gsub("**",'').gsub("~~",'')}~*")
        end
      end
      if b[0][0][i][b[0][0][i].length-1].gsub("**",'').gsub("~~",'')!=b[1][0][i][b[1][0][i].length-1].gsub("**",'').gsub("~~",'')
        if b[0][0][i][b[0][0][i].length-1].gsub("**",'').gsub("~~",'')==b2[i][b2[i].length-1].gsub("*",'').gsub("~",'')
          b2[i].push("~~#{b[1][2]} has promotion~~")
        elsif b[1][0][i][b[1][0][i].length-1].gsub("**",'').gsub("~~",'')==b2[i][b2[i].length-1].gsub("*",'').gsub("~",'')
          b2[i].push("~~#{b[0][2]} has promotion~~")
        else
          b2[i].push("~~different ends~~")
        end
      end
    else
      b2[i]=["~~nothing in common~~"]
    end
  end
  create_embed(event,"**Skills #{b[0][1]} and #{b[1][1]} have in common**",'',avg_color([c[0],c[1]]),nil,nil,[["Weapons",b2[0].join("\n")],["Assists",b2[1].join("\n")],["Specials",b2[2].join("\n")],["A Passives",b2[3].join("\n")],["B Passives",b2[4].join("\n")],["C Passives",b2[5].join("\n")]],-1)
  return 2
end

def weapon_legality(event,name,weapon,refinement,recursion=false)
  return '-' if weapon=='-'
  u=@data[find_unit(name,event)]
  w=@skills[find_weapon(weapon,event)]
  w2="#{weapon}"
  w2="#{weapon} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  return "~~#{w2}~~" if w[6]!='-' && !w[6].split(', ').include?(u[0]) # prf weapons are illegal on anyone but their holders
  u2=weapon_clss(u[1],event)
  u2='Bow' if u2.include?('Bow')
  u2='Dagger' if u2.include?('Dagger')
  u2="#{u2.gsub('Healer','Staff')} Users Only"
  u2="Dragons Only" if u[1][1]=='Dragon'
  u2="Beasts Only" if u[1][1]=='Beast'
  return w2 if u2==w[5]
  return "~~#{w2}~~" if recursion
  if "Raudr"==w[0][0,5] || "Blar"==w[0][0,4] || "Gronn"==w[0][0,5] || "Keen Raudr"==w[0][0,10] || "Keen Blar"==w[0][0,9] || "Keen Gronn"==w[0][0,10]
    return weapon_legality(event,name,weapon.gsub('Blar','Raudr').gsub('Gronn','Raudr'),refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,weapon.gsub('Raudr','Blar').gsub('Gronn','Blar'),refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,weapon.gsub('Raudr','Gronn').gsub('Blar','Gronn'),refinement,true) if u[1][0]=="Green"
    return "~~#{w2}~~" unless u[1][0]=="Colorless"
    w2="#{weapon.gsub('Raudr','Hoss').gsub('Blar','Hoss').gsub('Gronn','Hoss')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ["Ruby Sword","Sapphire Lance","Emerald Axe"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Ruby Sword#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Sapphire Lance#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Emerald Axe#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Hibiscus Tome","Sealife Tome","Tomato Tome"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Tomato Tome#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Sealife Tome#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Hibiscus Tome#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Dancer's Ring","Dancer's Score"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Dancer's Score#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Dancer's Ring#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
    return "~~#{w2}~~" unless u[1][0]=="Red"
    w2="Dancer's Ribbon#{"+" if w[0].include?("+")}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ["Kadomatsu","Hagoita"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Kadomatsu#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Hagoita#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
    return "~~#{w2}~~" unless u[1][0]=="Blue"
    w2="Sushi Sticks#{"+" if w[0].include?("+")}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ["Tannenboom","Sack o' Gifts","Handbell"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Tannenboom#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"#{["Sack o' Gifts","Handbell"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green" && w[0].gsub('+','')=="Tannenboom"
    return "~~#{w2}~~" unless u[1][0]=="Red"
    w2="Santa's Sword#{"+" if w[0].include?("+")}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ["Carrot Lance","Carrot Axe"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Carrot Lance#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Carrot Axe#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
    return "~~#{w2}~~" unless ["Colorless","Red"].include?(u[1][0])
    w2="Carrot#{"+" if w[0].include?("+")}...just a carrot#{"+" if w[0].include?("+")}"
    w2="Carrot Sword#{"+" if w[0].include?("+")}" if u[1][0]=="Red"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ["Blue Egg","Green Egg","Blue Gift","Green Gift"].include?(w[0].gsub('+',''))
    t="Egg"
    t="Gift" if ["Blue Gift","Green Gift"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Blue #{t}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Green #{t}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
    return "~~#{w2}~~" unless ["Colorless","Red"].include?(u[1][0])
    w2="Empty #{t}#{"+" if w[0].include?("+")}"
    w2="Red #{t}#{"+" if w[0].include?("+")}" if u[1][0]=="Red"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ["Melon Crusher","Deft Harpoon"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Deft Harpoon#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Melon Crusher#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
    return "~~#{w2}~~" unless ["Red"].include?(u[1][0])
    w2="Ylissian Summer Sword#{"+" if w[0].include?("+")}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ["Iron Sword","Iron Lance","Iron Axe","Steel Sword","Steel Lance","Steel Axe","Silver Sword","Silver Lance","Silver Axe","Brave Sword","Brave Lance","Brave Axe","Firesweep Sword","Firesweep Lance","Firesweep Axe"].include?(w[0].gsub('+',''))
    t="Iron"
    t="Steel" if "Steel "==w[0][0,6]
    t="Silver" if "Silver "==w[0][0,7]
    t="Brave" if "Brave "==w[0][0,6]
    t="Firesweep" if "Firesweep "==w[0][0,10]
    return weapon_legality(event,name,"#{t} Sword#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"#{t} Lance#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"#{t} Axe#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Killing Edge","Killer Lance","Killer Axe","Slaying Edge","Slaying Lance","Slaying Axe"].include?(w[0].gsub('+',''))
    t="Killer"
    t="Killing" if u[1][0]=="Red"
    t="Slaying" if "Slaying "==w[0][0,8]
    return weapon_legality(event,name,"#{t} Edge#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"#{t} Lance#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"#{t} Axe#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Fire","Flux","Thunder","Light","Wind"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Fire#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Fire"
    return weapon_legality(event,name,"Flux#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Dark"
    return weapon_legality(event,name,"#{["Fire","Flux"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Thunder#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Thunder"
    return weapon_legality(event,name,"Light#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Light"
    return weapon_legality(event,name,"#{["Thunder","Light"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Wind#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Wind"
    return weapon_legality(event,name,"#{["Wind"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Elfire","Ruin","Elthunder","Ellight","Elwind"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Elfire#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Fire"
    return weapon_legality(event,name,"Ruin#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Dark"
    return weapon_legality(event,name,"#{["Elfire","Ruin"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Elthunder#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Thunder"
    return weapon_legality(event,name,"Ellight#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Light"
    return weapon_legality(event,name,"#{["Elthunder","Ellight"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Elwind#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Wind"
    return weapon_legality(event,name,"#{["Elwind"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Bolganone","Fenrir","Thoron","Shine","Rexcalibur"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Bolganone#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Fire"
    return weapon_legality(event,name,"Fenrir#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Dark"
    return weapon_legality(event,name,"#{["Bolganone","Fenrir"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Thoron#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Thunder"
    return weapon_legality(event,name,"Shine#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Light"
    return weapon_legality(event,name,"#{["Thoron","Shine"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Rexcalibur#{"+" if w[0].include?("+")}",refinement,true) if u[1][2]=="Wind"
    return weapon_legality(event,name,"#{["Rexcalibur"].sample}#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Armorslayer","Heavy Spear","Hammer"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Armorslayer#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Heavy Spear#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Hammer#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Armorsmasher","Slaying Spear","Slaying Hammer"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Armorsmasher#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Slaying Spear#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Slaying Hammer#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Zanbato","Ridersbane","Poleaxe"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Zanbato#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Ridersbane#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Poleaxe#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  elsif ["Wo Dao","Harmonic Lance","Giant Spoon"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Wo Dao#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Red"
    return weapon_legality(event,name,"Harmonic Lance#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Blue"
    return weapon_legality(event,name,"Giant Spoon#{"+" if w[0].include?("+")}",refinement,true) if u[1][0]=="Green"
  end
  return "~~#{w2}~~"
end

def add_number_to_string(a,b)
  return 0 if a.is_a?(String) && /[[:alpha:]]/ =~ a
  return 0 if b.is_a?(String) && /[[:alpha:]]/ =~ b
  return a+b if a.is_a?(Fixnum) && b.is_a?(Fixnum)
  return a.to_i+b if a.is_a?(String) && b.is_a?(Fixnum) && a.to_i.to_s==a
  return a+b.to_i if a.is_a?(Fixnum) && b.is_a?(String) && b.to_i.to_s==b
  return a.to_i+b.to_i if a.is_a?(String) && a.to_i.to_s==a && b.is_a?(String) && b.to_i.to_s==b
  x=[]
  if a.is_a?(Fixnum) || (a.is_a?(String) && a.to_i.to_s==a)
    if b.include?('(') && !b.include?('~~')
      x=b.split(' (').map{|q| q.gsub('(','').gsub(')','')}
      x=x.map{|q| q.to_i+a.to_i}
      return "#{x[0]} (#{x[1]})"
    end
    x=b.split('~~ ').map{|q| q.gsub('~~','')}
    x=x.map{|q| add_number_to_string(q,a)}
  elsif b.is_a?(Fixnum) || (b.is_a?(String) && b.to_i.to_s==b)
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
  p=[["1\\* exclusive",[]],["1-2\\*",[]],["2\\* exclusive",[]],["2-3\\*",[]],["3\\* exclusive",[]],["3-4\\*",[]],["4\\* exclusive",[]],["4-5\\*",[]],["5\\* exclusive",[]],["Other",[]]]
  for i in 0...clr.length
    if clr[i][19].include?('1p')
      if clr[i][19].include?('2p')
        p[1][1].push(clr[i][0])
      elsif clr[i][19].include?('3p') || clr[i][19].include?('4p') || clr[i][19].include?('5p')
        p[9][1].push("#{clr[i][0]} - 1#{"/3" if clr[i][19].include?('3p')}#{"/4" if clr[i][19].include?('4p')}#{"/5" if clr[i][19].include?('5p')}\\*")
      else
        p[0][1].push(clr[i][0])
      end
    elsif clr[i][19].include?('2p')
      if clr[i][19].include?('3p')
        p[3][1].push(clr[i][0])
      elsif clr[i][19].include?('4p') || clr[i][19].include?('5p')
        p[9][1].push("#{clr[i][0]} - 2#{"/4" if clr[i][19].include?('4p')}#{"/5" if clr[i][19].include?('5p')}\\*")
      else
        p[2][1].push(clr[i][0])
      end
    elsif clr[i][19].include?('3p')
      if clr[i][19].include?('4p')
        p[5][1].push(clr[i][0])
      elsif clr[i][19].include?('5p')
        p[9][1].push("#{clr[i][0]} - 3/5\\*")
      else
        p[4][1].push(clr[i][0])
      end
    elsif clr[i][19].include?('4p')
      if clr[i][19].include?('5p')
        p[7][1].push(clr[i][0])
      else
        p[6][1].push(clr[i][0])
      end
    elsif clr[i][19].include?('5p')
      p[8][1].push(clr[i][0])
    else
      p[9][1].push("#{clr[i][0]} - weird")
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
  k=@data.reject{|q| !q[19].include?('p') || !q[22].nil?}
  colors=[]
  for i in 0...args.length
    args[i]=args[i].downcase.gsub('user','') if args[i].length>4 && args[i][args[i].length-4,4].downcase=='user'
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','clear','clears'].include?(args[i].downcase)
  end
  colors=colors.uniq
  if event.server.nil? || event.channel.id==283821884800499714 || @shardizard==4
    colors=['Red','Blue','Green','Colorless'] if colors.length<=0
  elsif colors.length<=0
    event.respond "I will not show the entire summon pool as that would be spam.  Please specify a single color or use this command in PM."
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
      create_embed(event,"",'',0xB32400,"4-5\* availability can be affected by banner focus.",nil,r,4)
    end
  end
  if colors.include?('Blue')
    r=k.reject{|q| q[1][0]!='Blue'}
    r=create_summon_list(r)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x208EFB,"4-5\* availability can be affected by banner focus.",nil,r,4)
    end
  end
  if colors.include?('Green')
    r=k.reject{|q| q[1][0]!='Green'}
    r=create_summon_list(r)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x01AD00,"4-5\* availability can be affected by banner focus.",nil,r,4)
    end
  end
  if colors.include?('Colorless')
    r=k.reject{|q| q[1][0]!='Colorless'}
    r=create_summon_list(r)
    if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0xC1CCD6,"4-5\* availability can be affected by banner focus.",nil,r,4)
    end
  end
end

def parse_function(callback,event,args,bot,healers=nil)
  event.channel.send_temporary_message("Calculating data, please wait...",3)
  k=find_name_in_string(event,nil,1)
  if k.nil?
    if !detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(event.message.text,x[0],''),event)
      weapon='-'
      weapon=k2[0] unless k2.nil?
      xx=[]
      xn=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        if @data[j2][1][1]!="Healer" && healers==true
          xn.push(x[1][i])
        elsif @data[j2][1][1]=="Healer" && healers==false
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
    else
      event.respond "No unit was included"
      return -1
    end
  else
    str=k[0]
    k2=get_weapon(first_sub(event.message.text,k[1],''),event)
    weapon='-'
    weapon=k2[0] unless k2.nil?
    name=find_name_in_string(event)
    if !detect_dual_unit_alias(name.downcase,event.message.text.downcase).nil?
      x=detect_dual_unit_alias(name.downcase,event.message.text.downcase)
      x[1]=[x[1]] unless x[1].is_a?(Array)
      xx=[]
      xn=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        if @data[j2][1][1]!="Healer" && healers==true
          xn.push(x[1][i])
        elsif @data[j2][1][1]=="Healer" && healers==false
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
    elsif !detect_dual_unit_alias(name.downcase,name.downcase).nil?
      x=detect_dual_unit_alias(name.downcase,name.downcase)
      x[1]=[x[1]] unless x[1].is_a?(Array)
      xx=[]
      xn=[]
      for i in 0...x[1].length
        j2=find_unit(x[1][i],event)
        if @data[j2][1][1]!="Healer" && healers==true
          xn.push(x[1][i])
        elsif @data[j2][1][1]=="Healer" && healers==false
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
    elsif @data[find_unit(name,event)][1][1]!="Healer" && healers==true
      event.respond "#{name} is not a healer so cannot equip staves."
    elsif @data[find_unit(name,event)][1][1]=="Healer" && healers==false
      event.respond "#{name} is a healer so cannot equip these skills."
    else
      method(callback).call(event,name,bot,weapon)
    end
  end
  return 0
end

def calculate_effective_HP(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    for i in 0...name.length
      calculate_effective_HP(event,name[i],weapon=nil)
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
  args=sever(s.gsub(',','').gsub('/',''),true).split(" ")
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
  for i in 0...blessing.length
    blessing[i]=nil if i>=3
  end
  blessing.compact!
  args.compact!
  j=find_unit(name,event)
  u40x=@data[j]
  if u40x[4].nil? || (u40x[4].zero? && u40x[9].zero?)
    unless u40x[0]=="Kiran"
      event.respond "#{u40x[0]} does not have official stats.  I cannot study #{'his' if u40x[20]=='M'}#{'her' if u40x[20]=='F'}#{'their' unless ['M','F'].include?(u40x[20])} effective HP."
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
      weaponz=@dev_units[dv][6].reject{|q| q.include?("~~")}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(" (+) ")
        w=weapon.split(" (+) ")
        weapon=w[0]
        refinement=w[1].gsub(" Mode","")
      else
        refinement=nil
      end
    elsif @dev_lowlifes.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name)
      event.respond "Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats."
    else
      event.respond "Mathoo does not have that character.  Showing neutral stats."
    end
  end
  tempest=(args.map{|q| q.downcase}.include?('tempest'))
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  w2=@skills[find_skill(weapon,event)]
  if w2[23].nil?
    refinement=nil
  elsif w2[23].length<2 && refinement=="Effect"
    refinement=nil
  elsif w2[23][0,1].to_i.to_s==w2[23][0,1] && refinement=="Effect"
    refinement=nil if w2[23][1,1]=="*"
  elsif w2[0,1]=="-" && w2[23][1,1].to_i.to_s==w2[23][1,1] && refinement=="Effect"
    refinement=nil if w2[23][2,1]=="*"
  end
  refinement=nil if w2[5]!="Staff Users Only" && ["Wrathful","Dazzling"].include?(refinement)
  refinement=nil if w2[5]=="Staff Users Only" && !["Wrathful","Dazzling"].include?(refinement)
  r="<:star:322905655730241547>"*rarity.to_i
  r="**#{rarity} star**" if r.length>=500
  xcolor=unit_color(event,j,0,mu)
  atk="Attack"
  atk="Magic" if ['Tome','Dragon','Healer'].include?(@data[j][1][1])
  atk="Strength" if ['Blade','Bow','Dagger'].include?(@data[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  if zzzl[7].include?("amage calculated using the lower of foe's Def or Res") || (zzzl[4]=="Weapon" && zzzl[5]=="Dragons Only" && !refinement.nil? && refinement.length>0)
    atk="Freeze"
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=="Strength"
    n=n[n.length-1] if atk=="Magic"
    n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  wl=weapon_legality(event,u40[0],weapon,refinement)
  if name=='Robin'
    u40[0]="Robin (Shared stats)"
    xcolor=avg_color([[32,142,251],[1,173,0]])
    w="*Tome*"
  end
  cru40=u40.map{|a| a}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing)
  if u40[0]=="Kiran"
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
  for i in 0...stat_skills_2.length
    stat_skills_2[i]="Hone #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Hone Movement"
    stat_skills_2[i]="Fortify #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Fortify Movement"
  end
  photon=[u40[4]>=u40[5]+5,blu40[4]>=blu40[5]+5,cru40[4]>=cru40[5]+5,crblu40[4]>=crblu40[5]+5]
  for i in 0...photon.length
    if photon[i]
      photon[i]=7
    else
      photon[i]=0
    end
  end
  photon[0]="#{photon[0]}#{" (#{photon[1]})" if photon[0]!=photon[1]}"
  if wl.include?("~~")
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
  if wl.include?("~~")
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
  x=[["Physical",rp],["Magical",rm]]
  if rd==rp && rd==rm
    x[0][0]="Physical / Magical / Frostbite"
    x[1]=nil
    x.compact!
  elsif rd==rp
    x[0][0]="Physical / Frostbite"
  elsif rd==rm
    x[1][0]="Magical / Frostbite"
  else
    x.push(["Frostbite",rd])
  end
  x.push(["Misc.","Defense + Resistance = #{rdr}#{"\n\n#{u40[0]} will take #{photon} extra Photon damage" unless photon=="0"}\n\nRequired to double #{u40[0]}:\n#{rs}#{"\n#{u40[4]+5}+#{" (#{blu40[4]+5}+)" if blu40[4]!=u40[4]} Defense" if weapon=='Great Flame'}#{"\n\nMoonbow becomes better than Glimmer when:\nThe enemy has #{rmg} #{'Defense' if atk=="Strength"}#{'Resistance' if atk=="Magic"}#{'as the lower of Def/Res' if atk=="Freeze"}#{'as their targeted defense stat' if atk=="Attack"}" unless @data[j][1][1]=='Healer'}"])
  pic=pick_thumbnail(event,j,bot)
  pic="https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png" if u40[0]=="Robin (Shared stats)"
  stat_buffers=[]
  stat_nerfers=[]
  for i in 0...stat_skills_2.length
    if stat_skills_2[i].include?(" Ploy ") || stat_skills_2[i].include?("Seal ") || stat_skills_2[i].include?("Threaten ") || stat_skills_2[i].include?("Chill ") || stat_skills_2[i].include?(" Smoke ")
      stat_nerfers.push(stat_skills_2[i])
    else
      stat_buffers.push(stat_skills_2[i])
    end
  end
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"Equipped weapon: #{wl}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n",xcolor,'"Frostbite" is weapons like Felicia\'s Plate.  "Photon" is weapons like Light Brand.',pic,x)
end

def unit_study(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    for i in 0...name.length
      unit_study(event,name[i],bot)
    end
    return nil
  end
  j=find_unit(name,event)
  u40x=@data[j]
  if u40x[4].nil? || (u40x[4].zero? && u40x[9].zero?)
    unless u40x[0]=="Kiran"
      event.respond "#{u40x[0]} does not have official stats.  I cannot study #{'him' if u40x[20]=='M'}#{'her' if u40x[20]=='F'}#{'them' unless ['M','F'].include?(u40x[20])} at multiple rarities."
      return nil
    end
  end
  args=sever(event.message.text.downcase).split(" ")
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
  rardata=@data[j][19].downcase
  highest_merge=0
  if rardata.include?('p') || rardata.include?('s')
    highest_merge=10
  elsif rardata.include?('-')
    highest_merge=0
  else
    highest_merge=[10,rardata.length/2-1].min
  end
  r1=make_stats_string(event,name,1,boon,bane,highest_merge)
  r2=make_stats_string(event,name,2,boon,bane,highest_merge)
  r3=make_stats_string(event,name,3,boon,bane,highest_merge)
  r4=make_stats_string(event,name,4,boon,bane,highest_merge)
  r5=make_stats_string(event,name,5,boon,bane,highest_merge)
  lowest_rarity=5
  summon_type=[[],[],[],[],[],[],[]]
  for m in 1...6
    if rardata.include?("#{m}p")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[0].push(m.to_s) # Summon Pool
    end
    if rardata.include?("#{m}d")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[1].push(m.to_s) # Daily Rotation Heroes
    end
    if rardata.include?("#{m}g")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[2].push(m.to_s) # Grand Hero Battles
    end
    if rardata.include?("#{m}f")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[3].push(m.to_s) # free heroes
    end
    if rardata.include?("#{m}q")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[4].push(m.to_s) # quest rewards
    end
    if rardata.include?("#{m}t")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[5].push(m.to_s) # Tempest Trials rewards
    end
    if rardata.include?("#{m}s")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[6].push("Seasonal #{m}\\* summon")
    end
    if rardata.include?("#{m}y")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[6].push("Story unit starting at #{m}\\*")
    end
    if rardata.include?("#{m}b")
      lowest_rarity=[m,lowest_rarity].min
      summon_type[6].push("Purchasable at #{m}\\*")
    end
  end
  for m in 0...5
    summon_type[m]=summon_type[m].sort{|a,b| a <=> b}
  end
  mz=["summon","daily rotation battles","Grand Hero Battle","free hero","quest reward","Tempest Trial reward"]
  for m in 0...6
    if summon_type[m].length>0
      summon_type[m]="#{summon_type[m].join('/')}\\* #{mz[m]}"
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
  summon_type=["Unobtainable"] if summon_type.nil? || summon_type.length==0
  summon_type=summon_type.join(', ')
  if j<0
    event.respond "No unit was included"
    return nil
  end
  xcolor=unit_color(event,j,0,mu)
  atk="Attack"
  atk="Magic" if ['Tome','Dragon','Healer'].include?(@data[j][1][1])
  atk="Strength" if ['Blade','Bow','Dagger'].include?(@data[j][1][1])
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=="Strength"
    n=n[n.length-1] if atk=="Magic"
    n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
  end
  u40=get_stats(event,name,40,5,0,boon,bane)
  if name=='Robin'
    u40[0]="Robin (Shared stats)"
    xcolor=avg_color([[32,142,251],[1,173,0]])
    w="*Tome*"
    summon_type="\n*Female:* #{summon_type}\n*Male:* 3/4\\* summon"
    unless highest_merge==10
      r1=make_stats_string(event,name,1,boon,bane,0-highest_merge)
      r2=make_stats_string(event,name,2,boon,bane,0-highest_merge)
      r3=make_stats_string(event,name,3,boon,bane,0-highest_merge)
      r4=make_stats_string(event,name,4,boon,bane,0-highest_merge)
      r5=make_stats_string(event,name,5,boon,bane,0-highest_merge)
      highest_merge="\n*Female: #{highest_merge}*\n*Male:* 10\n"
    end
  end
  xcolor=0x9400D3 if u40[0]=="Kiran"
  rar=[]
  rar.push(["<:star:322905655730241547>"*1,r1]) if (lowest_rarity<=1 && boon=="" && bane=="") || args.include?('full') || args.include?('rarities')
  rar.push(["<:star:322905655730241547>"*2,r2]) if (lowest_rarity<=2 && boon=="" && bane=="") || args.include?('full') || args.include?('rarities')
  rar.push(["<:star:322905655730241547>"*3,r3]) if lowest_rarity<=3 || args.include?('full') || args.include?('rarities')
  rar.push(["<:star:322905655730241547>"*4,r4]) if lowest_rarity<=4 || args.include?('full') || args.include?('rarities')
  rar.push(["<:star:322905655730241547>"*5,r5])
  pic=pick_thumbnail(event,j,bot)
  pic="https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png" if u40[0]=="Robin (Shared stats)"
  create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","**Available rarities:** #{summon_type}#{"\n**Highest available merge:** #{highest_merge}" unless highest_merge==10}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n",xcolor,nil,pic,rar,2)
end

def heal_study(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    for i in 0...name.length
      heal_study(event,name[i],bot,weapon)
    end
    return nil
  end
  name=find_name_in_string(event) if name.nil?
  j=find_unit(name,event)
  u40x=@data[j]
  if u40x[4].nil? || (u40x[4].zero? && u40x[9].zero?)
    unless u40x[0]=="Kiran"
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[20]=='M'}#{'she does' if u40x[20]=='F'}#{'they do' unless ['M','F'].include?(u40x[20])} with each healing staff."
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
  args=sever(s.gsub(',','').gsub('/',''),true).split(" ")
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
  for i in 0...blessing.length
    blessing[i]=nil if i>=3
  end
  blessing.compact!
  args.compact!
  if args.nil? || args.length<1
    event.respond "No unit was included"
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
      weaponz=@dev_units[dv][6].reject{|q| q.include?("~~")}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(" (+) ")
        w=weapon.split(" (+) ")
        weapon=w[0]
        refinement=w[1].gsub(" Mode","")
      else
        refinement=nil
      end
    elsif @dev_lowlifes.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name)
      event.respond "Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats."
    else
      event.respond "Mathoo does not have that character.  Showing neutral stats."
    end
  end
  tempest=(args.map{|q| q.downcase}.include?('tempest'))
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  w2=@skills[find_skill(weapon,event)]
  if w2[23].nil?
    refinement=nil
  elsif w2[23].length<2 && refinement=="Effect"
    refinement=nil
  elsif w2[23][0,1].to_i.to_s==w2[23][0,1] && refinement=="Effect"
    refinement=nil if w2[23][1,1]=="*"
  elsif w2[0,1]=="-" && w2[23][1,1].to_i.to_s==w2[23][1,1] && refinement=="Effect"
    refinement=nil if w2[23][2,1]=="*"
  end
  refinement=nil if w2[5]!="Staff Users Only" && ["Wrathful","Dazzling"].include?(refinement)
  refinement=nil if w2[5]=="Staff Users Only" && !["Wrathful","Dazzling"].include?(refinement)
  r="<:star:322905655730241547>"*rarity.to_i
  r="**#{rarity} star**" if r.length>=500
  xcolor=unit_color(event,j,0,mu)
  atk="Attack"
  atk="Magic" if ['Tome','Dragon','Healer'].include?(@data[j][1][1])
  atk="Strength" if ['Blade','Bow','Dagger'].include?(@data[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  if zzzl[7].include?("amage calculated using the lower of foe's Def or Res") || (zzzl[4]=="Weapon" && zzzl[5]=="Dragons Only" && !refinement.nil? && refinement.length>0)
    atk="Freeze"
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=="Strength"
    n=n[n.length-1] if atk=="Magic"
    n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  wl=weapon_legality(event,u40[0],weapon,refinement)
  if name=='Robin'
    u40[0]="Robin (Shared stats)"
    xcolor=avg_color([[32,142,251],[1,173,0]])
    w="*Tome*"
  end
  cru40=u40.map{|q| q}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing) if wl.include?("~~")
  cru40=u40.map{|q| q} unless wl.include?("~~")
  if u40[0]=="Kiran"
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
  for i in 0...stat_skills_2.length
    stat_skills_2[i]="Hone #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Hone Movement"
    stat_skills_2[i]="Fortify #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Fortify Movement"
  end
  atkk=u40[2]
  hppp=u40[1]
  blatkk=blu40[2]
  blhppp=blu40[1]
  cratkk=cru40[2]
  crhppp=cru40[1]
  crblatkk=crblu40[2]
  crblhppp=crblu40[1]
  staves=[]
  staves.push("**Heal:** heals target for 5 HP, 15 HP when Imbue triggers\n\n**Mend:** heals target for 10 HP, 20 HP when Imbue triggers\n\n**Physic:** heals target for 8 HP, 18 HP when Imbue triggers") if event.message.text.downcase.include?(" all")
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
  staves.push("~~Phsyic(+) has a range of 2~~")
  staves.push(" ")
  staves.push("**Recover:** heals target for 15 HP, 25 HP when Imbue triggers") if event.message.text.downcase.include?(" all")
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
  staves.push(" ")
  staves.push("**Restore:** heals target for 8 HP, 18 HP when Imbue triggers") if event.message.text.downcase.include?(" all")
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
  staves.push("~~Restore(+) will also remove any negative status effects placed on the target.~~")
  staves.push(" ")
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
  staves.push("~~How much Martyr(+) heals is based on how much damage *#{u40[0].gsub('Lavatain','Laevatein')}* has taken.~~")
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
  staves.push("~~How much Rehabilitate(+) heals is based on how much damage the target has taken.~~\n~~If they are above 50% HP, the lower end of the range is how much is healed.~~")
  pic=pick_thumbnail(event,j,bot)
  pic="https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png" if u40[0]=="Robin (Shared stats)"
  stat_buffers=[]
  stat_nerfers=[]
  for i in 0...stat_skills_2.length
    if stat_skills_2[i].include?(" Ploy ") || stat_skills_2[i].include?("Seal ") || stat_skills_2[i].include?("Threaten ") || stat_skills_2[i].include?("Chill ") || stat_skills_2[i].include?(" Smoke ")
      stat_nerfers.push(stat_skills_2[i])
    else
      stat_buffers.push(stat_skills_2[i])
    end
  end
  k="__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"Equipped weapon: #{wl}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all") || k.length+staves.join("\n").length>=1950
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"Equipped weapon: #{wl}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}"
    event.respond staves.join("\n")
  else
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"Equipped weapon: #{wl}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n",xcolor,nil,pic,[["Staves",staves.join("\n")]])
  end
end

def proc_study(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    for i in 0...name.length
      proc_study(event,name[i],bot,weapon)
    end
    return nil
  end
  name=find_name_in_string(event) if name.nil?
  j=find_unit(name,event)
  u40x=@data[j]
  if u40x[4].nil? || (u40x[4].zero? && u40x[9].zero?)
    unless u40x[0]=="Kiran"
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[20]=='M'}#{'she does' if u40x[20]=='F'}#{'they do' unless ['M','F'].include?(u40x[20])} with each proc skill."
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
  args=sever(s.gsub(',','').gsub('/',''),true).split(" ")
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
  for i in 0...blessing.length
    blessing[i]=nil if i>=3
  end
  blessing.compact!
  args.compact!
  if args.nil? || args.length<1
    event.respond "No unit was included"
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
      weaponz=@dev_units[dv][6].reject{|q| q.include?("~~")}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(" (+) ")
        w=weapon.split(" (+) ")
        weapon=w[0]
        refinement=w[1].gsub(" Mode","")
      else
        refinement=nil
      end
    elsif @dev_lowlifes.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name)
      event.respond "Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats."
    else
      event.respond "Mathoo does not have that character.  Showing neutral stats."
    end
  end
  tempest=(args.map{|q| q.downcase}.include?('tempest'))
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  w2=@skills[find_skill(weapon,event)]
  if w2[23].nil?
    refinement=nil
  elsif w2[23].length<2 && refinement=="Effect"
    refinement=nil
  elsif w2[23][0,1].to_i.to_s==w2[23][0,1] && refinement=="Effect"
    refinement=nil if w2[23][1,1]=="*"
  elsif w2[0,1]=="-" && w2[23][1,1].to_i.to_s==w2[23][1,1] && refinement=="Effect"
    refinement=nil if w2[23][2,1]=="*"
  end
  refinement=nil if w2[5]!="Staff Users Only" && ["Wrathful","Dazzling"].include?(refinement)
  refinement=nil if w2[5]=="Staff Users Only" && !["Wrathful","Dazzling"].include?(refinement)
  r="<:star:322905655730241547>"*rarity.to_i
  r="**#{rarity} star**" if r.length>=500
  xcolor=unit_color(event,j,0,mu)
  atk="Attack"
  atk="Magic" if ['Tome','Dragon','Healer'].include?(@data[j][1][1])
  atk="Strength" if ['Blade','Bow','Dagger'].include?(@data[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  if zzzl[7].include?("amage calculated using the lower of foe's Def or Res") || (zzzl[4]=="Weapon" && zzzl[5]=="Dragons Only" && !refinement.nil? && refinement.length>0)
    atk="Freeze"
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=="Strength"
    n=n[n.length-1] if atk=="Magic"
    n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  wl=weapon_legality(event,u40[0],weapon,refinement)
  if name=='Robin'
    u40[0]="Robin (Shared stats)"
    xcolor=avg_color([[32,142,251],[1,173,0]])
    w="*Tome*"
  end
  cru40=u40.map{|q| q}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing) if wl.include?("~~")
  cru40=u40.map{|q| q} unless wl.include?("~~")
  if u40[0]=="Kiran"
    u40[1]=0
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
  for i in 0...stat_skills_2.length
    stat_skills_2[i]="Hone #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Hone Movement"
    stat_skills_2[i]="Fortify #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Fortify Movement"
  end
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
  wdamage+=10 if @skills[find_skill(weapon,event)][19].split(', ').include?('WoDao')
  wdamage2+=10 if @skills[find_skill(weapon,event)][19].split(', ').include?('WoDao') && !wl.include?("~~")
  cdwn=0
  cdwn-=1 if @skills[find_skill(weapon,event)][19].split(', ').include?('Killer')
  cdwn+=1 if @skills[find_skill(weapon,event)][19].split(', ').include?('SlowSpecial') || @skills[find_skill(weapon,event)][19].split(', ').include?('SpecialSlow')
  cdwn2=0
  cdwn2=cdwn unless wl.include?("~~")
  cdwns=cdwn
  cdwns="~~#{cdwn}~~ #{cdwn2}" unless cdwn2==cdwn
  staves=[[],[],[],[],[],[],[],[]]
  c=add_number_to_string(@skills[find_skill("Night Sky",event)][2],cdwns)
  d="`dmg /2#{" +#{wdamage}`" if wdamage>0}"
  d2="`dmg /2#{" +#{wdamage2}`" if wdamage2>0}"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Night Sky - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(@skills[find_skill("Astra",event)][2],cdwns)
  d="`3* dmg /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`3* dmg /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Astra - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Regnal Astra",event)][2],cdwns)
  d="#{spdd*2/5+wdamage}#{" (#{blspdd*2/5+wdamage})" unless spdd*4/5==blspdd*4/5}"
  cd="#{crspdd*2/5+wdamage2}#{" (#{crblspdd*2/5+wdamage2})" unless crspdd*4/5==crblspdd*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[0].push("**Regnal Astra - #{d}, cooldown of #{c}**") if @skills[find_skill("Regnal Astra",event)][6].split(', ').include?(u40[0])
  c=add_number_to_string(@skills[find_skill("Glimmer",event)][2],cdwns)
  d="`dmg /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`dmg /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Glimmer - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("New Moon",event)][2],cdwns)
  d="`3* eDR /10#{" +#{wdamage}" if wdamage>0}`"
  d2="`3* eDR /10#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("New Moon - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(@skills[find_skill("Luna",event)][2],cdwns)
  d="`eDR /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`eDR /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("Luna - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Black Luna",event)][2],cdwns)
  d="`4* eDR /5#{" +#{wdamage}" if wdamage>0}`"
  d2="`4* eDR /5#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("**Black Luna - #{d}, cooldown of #{c}**") if @skills[find_skill("Black Luna",event)][6].split(', ').include?(u40[0])
  c=add_number_to_string(@skills[find_skill("Moonbow",event)][2],cdwns)
  d="`3* eDR /10#{" +#{wdamage}" if wdamage>0}`"
  d2="`3* eDR /10#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("Moonbow - #{d}, cooldown of #{c}")
  wd="#{"#{wdamage}, " if wdamage>0}"
  wd="~~#{wdamage}~~ #{wdamage2}, " unless wdamage==wdamage2
  c=add_number_to_string(@skills[find_skill("Daylight",event)][2],cdwns)
  d="`3* #{"(" if wdamage>0}dmg#{" +#{wdamage})" if wdamage>0} /10`"
  d2="`3* #{"(" if wdamage2>0}dmg#{" +#{wdamage2})" if wdamage2>0} /10`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Daylight - #{wd}heals for #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(@skills[find_skill("Noontime",event)][2],cdwns)
  d="`3* #{"(" if wdamage>0}dmg#{" +#{wdamage})" if wdamage>0} /10`"
  d2="`3* #{"(" if wdamage2>0}dmg#{" +#{wdamage2})" if wdamage2>0} /10`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Noontime - #{wd}heals for #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Sol",event)][2],cdwns)
  d="`#{"(" if wdamage>0}dmg#{" +#{wdamage})" if wdamage>0} /2`"
  d2="`#{"(" if wdamage2>0}dmg#{" +#{wdamage2})" if wdamage2>0} /2`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Sol - #{wd}heals for #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Aether",event)][2],cdwns)
  d="`eDR /2#{" +#{wdamage}" if wdamage>0}`"
  d2="`eDR /2#{" +#{wdamage2}" if wdamage2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  h="`#{"(" if wdamage>0}dmg#{" +#{wdamage})" if wdamage>0} /2 + eDR /4`"
  h2="`#{"(" if wdamage2>0}dmg#{" +#{wdamage2})" if wdamage2>0} /2 + eDR /4`"
  h="~~#{h}~~ #{h2}" unless h==h2
  staves[3].push("Aether - #{d}, heals for #{h}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Radiant Aether",event)][2],cdwns)
  staves[3].push("**Radiant Aether - `#{d}, heals for #{h}, cooldown of #{c}**") if @skills[find_skill("Radiant Aether",event)][6].split(', ').include?(u40[0])
  c=add_number_to_string(@skills[find_skill("Glowing Ember",event)][2],cdwns)
  d="#{deff/2+wdamage}#{" (#{bldeff/2+wdamage})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2}#{" (#{crbldeff/2+wdamage2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Glowing Ember - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(@skills[find_skill("Bonfire",event)][2],cdwns)
  d="#{deff/2+wdamage}#{" (#{bldeff/2+wdamage})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2}#{" (#{crbldeff/2+wdamage2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Bonfire - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Ignis",event)][2],cdwns)
  d="#{deff*4/5+wdamage}#{" (#{bldeff*4/5+wdamage})" unless deff*4/5==bldeff*4/5}"
  cd="#{crdeff*4/5+wdamage2}#{" (#{crbldeff*4/5+wdamage2})" unless crdeff*4/5==crbldeff*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Ignis - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Chilling Wind",event)][2],cdwns)
  d="#{ress/2+wdamage}#{" (#{blress/2+wdamage})" unless ress/2==blress/2}"
  cd="#{crress/2+wdamage2}#{" (#{crblress/2+wdamage2})" unless crress/2==crblress/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Chilling Wind - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(@skills[find_skill("Glacies",event)][2],cdwns)
  d="#{ress*4/5+wdamage}#{" (#{blress*4/5+wdamage})" unless ress*4/5==blress*4/5}"
  cd="#{crress*4/5+wdamage2}#{" (#{crblress*4/5+wdamage2})" unless crress*4/5==crblress*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Glacies - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Iceberg",event)][2],cdwns)
  d="#{ress/2+wdamage}#{" (#{blress/2+wdamage})" unless ress/2==blress/2}"
  cd="#{crress/2+wdamage2}#{" (#{crblress/2+wdamage2})" unless crress/2==crblress/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Iceberg - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Dragon Gaze",event)][2],cdwns)
  d="#{atkk*3/10+wdamage}#{" (#{blatkk*3/10+wdamage})" unless atkk*3/10==blatkk*3/10}"
  cd="#{cratkk*3/10+wdamage2}#{" (#{crblatkk*3/10+wdamage2})" unless cratkk*3/10==crblatkk*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[6].push("Dragon Gaze - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(@skills[find_skill("Draconic Aura",event)][2],cdwns)
  d="#{atkk*3/10+wdamage}#{" (#{blatkk*3/10+wdamage})" unless atkk*3/10==blatkk*3/10}"
  cd="#{cratkk*3/10+wdamage2}#{" (#{crblatkk*3/10+wdamage2})" unless cratkk*3/10==crblatkk*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[6].push("Draconic Aura - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Dragon Fang",event)][2],cdwns)
  d="#{atkk/2+wdamage}#{" (#{blatkk/2+wdamage})" unless atkk/2==blatkk/2}"
  cd="#{cratkk/2+wdamage2}#{" (#{crblatkk/2+wdamage2})" unless cratkk/2==crblatkk/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[6].push("Dragon Fang - #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Retribution",event)][2],cdwns)
  d="#{3*hppp/10+wdamage}#{" (#{3*blhppp/10+wdamage})" if 3*hppp/10!=3*blhppp/10}"
  cd="#{3*crhppp/10+wdamage2}#{" (#{3*crblhppp/10+wdamage2})" if 3*crhppp/10!=3*crblhppp/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Retribution - Up to #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(@skills[find_skill("Reprisal",event)][2],cdwns)
  d="#{3*hppp/10+wdamage}#{" (#{3*blhppp/10+wdamage})" if 3*hppp/10!=3*blhppp/10}"
  cd="#{3*crhppp/10+wdamage2}#{" (#{3*crblhppp/10+wdamage2})" if 3*crhppp/10!=3*crblhppp/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Reprisal - Up to #{d}, cooldown of #{c}")
  c=add_number_to_string(@skills[find_skill("Vengeance",event)][2],cdwns)
  d="#{hppp/2+wdamage}#{" (#{blhppp/2+wdamage})" if hppp/2!=blhppp/2}"
  cd="#{crhppp/2+wdamage2}#{" (#{crblhppp/2+wdamage2})" if crhppp/2!=crblhppp/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Vengeance - Up to #{d}, cooldown of #{c}")
  pic=pick_thumbnail(event,j,bot)
  pic="https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png" if u40[0]=="Robin (Shared stats)"
  stat_buffers=[]
  stat_nerfers=[]
  for i in 0...stat_skills_2.length
    if stat_skills_2[i].include?(" Ploy ") || stat_skills_2[i].include?("Seal ") || stat_skills_2[i].include?("Threaten ") || stat_skills_2[i].include?("Chill ") || stat_skills_2[i].include?(" Smoke ")
      stat_nerfers.push(stat_skills_2[i])
    else
      stat_buffers.push(stat_skills_2[i])
    end
  end
  k="__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"Equipped weapon: #{wl}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n\neDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all") || k.length+staves.map{|q| q.join("\n")}.join("\n\n").length>=1950
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"Equipped weapon: #{wl}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n\neDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations"
    s=""
    for i in 0...staves.length
      s=extend_message(s,staves[i].join("\n"),event,2)
    end
    event.respond s
  else
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"Equipped weapon: #{wl}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n",xcolor,"eDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations",pic,[["Star",staves[0].join("\n")],["Moon",staves[1].join("\n")],["Sun",staves[2].join("\n")],["Eclipse",staves[3].join("\n")],["Fire",staves[4].join("\n")],["Ice",staves[5].join("\n")],["Dragon",staves[6].join("\n")],["Darkness",staves[7].join("\n")]])
  end
end

def phase_study(event,name,bot,weapon=nil)
  if name.is_a?(Array)
    for i in 0...name.length
      phase_study(event,name[i],bot,weapon)
    end
    return nil
  end
  name=find_name_in_string(event) if name.nil?
  j=find_unit(name,event)
  u40x=@data[j]
  if u40x[4].nil? || (u40x[4].zero? && u40x[9].zero?)
    unless u40x[0]=="Kiran"
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[20]=='M'}#{'she does' if u40x[20]=='F'}#{'they do' unless ['M','F'].include?(u40x[20])} in each phase."
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
  args=sever(s.gsub(',','').gsub('/',''),true).split(" ")
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
  for i in 0...blessing.length
    blessing[i]=nil if i>=3
  end
  blessing.compact!
  args.compact!
  if args.nil? || args.length<1
    event.respond "No unit was included"
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
      weaponz=@dev_units[dv][6].reject{|q| q.include?("~~")}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(" (+) ")
        w=weapon.split(" (+) ")
        weapon=w[0]
        refinement=w[1].gsub(" Mode","")
      else
        refinement=nil
      end
    elsif @dev_lowlifes.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name)
      event.respond "Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats."
    else
      event.respond "Mathoo does not have that character.  Showing neutral stats."
    end
  end
  tempest=(args.map{|q| q.downcase}.include?('tempest'))
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  w2=@skills[find_skill(weapon,event)]
  if w2[23].nil?
    refinement=nil
  elsif w2[23].length<2 && refinement=="Effect"
    refinement=nil
  elsif w2[23][0,1].to_i.to_s==w2[23][0,1] && refinement=="Effect"
    refinement=nil if w2[23][1,1]=="*"
  elsif w2[0,1]=="-" && w2[23][1,1].to_i.to_s==w2[23][1,1] && refinement=="Effect"
    refinement=nil if w2[23][2,1]=="*"
  end
  refinement=nil if w2[5]!="Staff Users Only" && ["Wrathful","Dazzling"].include?(refinement)
  refinement=nil if w2[5]=="Staff Users Only" && !["Wrathful","Dazzling"].include?(refinement)
  r="<:star:322905655730241547>"*rarity.to_i
  r="**#{rarity} star**" if r.length>=500
  xcolor=unit_color(event,j,0,mu)
  atk="Attack"
  atk="Magic" if ['Tome','Dragon','Healer'].include?(@data[j][1][1])
  atk="Strength" if ['Blade','Bow','Dagger'].include?(@data[j][1][1])
  zzzl=@skills[find_weapon(weapon,event)]
  if zzzl[7].include?("amage calculated using the lower of foe's Def or Res") || (zzzl[4]=="Weapon" && zzzl[5]=="Dragons Only" && !refinement.nil? && refinement.length>0)
    atk="Freeze"
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=="Strength"
    n=n[n.length-1] if atk=="Magic"
    n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane)
  if name=='Robin'
    u40[0]="Robin (Shared stats)"
    xcolor=avg_color([[32,142,251],[1,173,0]])
    w="*Tome*"
  end
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing)
  if u40[0]=="Kiran"
    u40[1]=0
    u40[4]=0
    u40[5]=0
    mu=false
    tempest=false
    xcolor=0x9400D3
    stat_skills=[]
    stat_skills_2=[]
  end
  blu40=u40.map{|a| a}
  blu40=apply_stat_skills(event,stat_skills_2,blu40)
  for i in 0...stat_skills_2.length
    stat_skills_2[i]="Hone #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Hone Movement"
    stat_skills_2[i]="Fortify #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_2[i]=="Fortify Movement"
  end
  stat_skills_3=make_combat_skill_list(name,event,args)
  ppu40=blu40.map{|q| q}
  ppu40=apply_combat_buffs(event,stat_skills_3,ppu40,'Player')
  epu40=blu40.map{|q| q}
  epu40=apply_combat_buffs(event,stat_skills_3,epu40,'Enemy')
  for i in 0...stat_skills_3.length
    stat_skills_3[i]="Goad #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_3[i]=="Goad Movement"
    stat_skills_3[i]="Ward #{@data[j][3].gsub('Flier','Fliers')}" if stat_skills_3[i]=="Ward Movement"
  end
  unless weapon.nil? || weapon=='-'
    desc = /((G|g)rants|((T|t)he u|U|u)nit receives) ((Atk|Spd|Def|Res)(\/|))+?\+\d ((if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (attack|combat)))|during combat(| (if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (attack|combat)))))/
    desc2 = /((G|g)rants|((T|t)he u|U|u)nit receives) ((Atk|Spd|Def|Res)(\/|))+?\+\d during combat (if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (attack|combat)))/
    x=desc.match(@skills[find_skill(weapon,event)][7]).to_s
    x=desc2.match(@skills[find_skill(weapon,event)][7]).to_s unless desc2.match(@skills[find_skill(weapon,event)][7]).nil?
    x=nil if !x.nil? && x.include?("to allies") # remove any matches that include "to allies", which were caught in the prior line so they weren't considered non-phase-based
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
    unless refinement.nil? || refinement.length<=1 || @skills[find_skill(weapon,event)][23].nil?
      inner_skill=@skills[find_skill(weapon,event)][23]
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
      x=desc.match(outer_skill).to_s
      x=desc2.match(outer_skill).to_s unless desc2.match(outer_skill).nil?
      x=nil if !x.nil? && x.include?("to allies")
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
      x=nil if !x.nil? && x.include?("to allies")
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
  ppu40[16]=ppu40[1]+ppu40[2]+ppu40[3]+ppu40[4]+ppu40[5]
  epu40[16]=epu40[1]+epu40[2]+epu40[3]+epu40[4]+epu40[5]
  pic=pick_thumbnail(event,j,bot)
  pic="https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png" if u40[0]=="Robin (Shared stats)"
  stat_buffers=[]
  stat_nerfers=[]
  for i in 0...stat_skills_2.length
    if stat_skills_2[i].include?(" Ploy ") || stat_skills_2[i].include?("Seal ") || stat_skills_2[i].include?("Threaten ") || stat_skills_2[i].include?("Chill ") || stat_skills_2[i].include?(" Smoke ")
      stat_nerfers.push(stat_skills_2[i])
    else
      stat_buffers.push(stat_skills_2[i])
    end
  end
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all")
    event.respond "__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__\n\n#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"In-combat skills: #{stat_skills_3.join(', ')}\n" if stat_skills_3.length>0}#{"Equipped weapon: #{weapon}#{" (+) #{refinement} Mode" if !refinement.nil? && refinement.length>0}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n\n**Basic stats:** #{u40[1]} / #{u40[2]} / #{u40[3]} / #{u40[4]} / #{u40[5]}  (#{u40[16]} BST)\n**Displayed stats:** #{blu40[1]} / #{blu40[2]} / #{blu40[3]} / #{blu40[4]} / #{blu40[5]}  (#{blu40[16]} BST)"
  else
    u40=make_stat_string_list(u40,blu40)
    create_embed(event,"__#{"Mathoo's " if mu}**#{u40[0].gsub('Lavatain','Laevatein')}**__","#{r}#{"	\u2764 **#{summoner}**" unless summoner=='-'}#{"+#{merges}" unless merges<=0}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}#{"\nTempest Bonus unit" if tempest}#{"\nBlessings applied: #{blessing.join(', ')}" if blessing.length>0}\n#{"Stat-affecting skills: #{stat_skills.join(', ')}\n" if stat_skills.length>0}#{"Stat-buffing skills: #{stat_buffers.join(', ')}\n" if stat_buffers.length>0}#{"Stat-nerfing skills: #{stat_nerfers.join(', ')}\n" if stat_nerfers.length>0}#{"In-combat skills: #{stat_skills_3.join(', ')}\n" if stat_skills_3.length>0}#{"Equipped weapon: #{weapon}#{" (+) #{refinement} Mode" if !refinement.nil? && refinement.length>0}\n\n" unless u40[0]=="Kiran"}#{unit_clss(event,j,u40[0])}#{"\nLegendary Hero type: *#{@data[j][2][0]}*/*#{@data[j][2][1]}*" unless @data[j][2][0]==" "}\n",xcolor,nil,pic,[["Displayed stats","HP: #{u40[1]}\n#{atk}: #{u40[2]}\nSpeed: #{u40[3]}\nDefense: #{u40[4]}\nResistance: #{u40[5]}\n\nBST: #{u40[16]}"],["Player Phase","HP: #{ppu40[1]}\n#{atk}: #{ppu40[2]}\nSpeed: #{ppu40[3]}\nDefense: #{ppu40[4]}\nResistance: #{ppu40[5]}\n\nBST: #{ppu40[16]}"],["Enemy Phase","HP: #{epu40[1]}\n#{atk}: #{epu40[2]}\nSpeed: #{epu40[3]}\nDefense: #{epu40[4]}\nResistance: #{epu40[5]}\n\nBST: #{epu40[16]}"]])
  end
end

def disp_art(event,name,bot,weapon=nil)
  name=['Robin(M)','Robin(F)'] if name=='Robin'
  if name.is_a?(Array)
    for i in 0...name.length
      disp_art(event,name[i],bot)
    end
    return nil
  end
  name=find_name_in_string(event) if name.nil?
  j=@data[find_unit(name,event)]
  data_load()
  args=event.message.text.downcase.split(' ')
  artype="Face"
  artype="BtlFace" if args.include?('battle') || args.include?('attack') || args.include?('att') || args.include?('atk') || args.include?('attacking')
  artype="BtlFace_D" if args.include?('damage') || args.include?('damaged') || (args.include?('low') && (args.include?('health') || args.include?('hp'))) || args.include?('lowhealth') || args.include?('lowhp') || args.include?('low_health') || args.include?('low_hp')
  artype="BtlFace_C" if args.include?('critical') || args.include?('special') || args.include?('crit') || args.include?('proc')
  art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{j[0]}/#{artype}.png"
  if j[0]=="Reinhardt(World)" && (rand(100)==0 || event.message.text.downcase.include?('zelda'))
    art="https://i.redd.it/pdeqrncp21r01.png"
    j[15]="u/ZachminSSB (ft. #{j[15]})"
  end
  disp=""
  nammes=['','','']
  unless j[15].nil? || j[15].length<=0
    m=j[15].split(" as ")
    nammes[0]=m[0]
    disp="#{disp}\n**Artist:** #{m[m.length-1]}"
  end
  unless j[16].nil? || j[16].length<=0
    m=j[16].split(" as ")
    nammes[1]=m[0]
    disp="#{disp}\n**VA (English):** #{m[m.length-1]}"
  end
  unless j[17].nil? || j[17].length<=0
    m=j[17].split(" as ")
    nammes[2]=m[0]
    disp="#{disp}\n**VA (Japanese):** #{m[m.length-1]}"
  end
  g=get_markers(event)
  chars=@data.reject{|q| q[0]==j[0] || !has_any?(g, q[22]) || ((q[15].nil? || q[15].length<=0) && (q[16].nil? || q[16].length<=0) && (q[17].nil? || q[17].length<=0))}
  charsx=[[],[],[]]
  for i in 0...chars.length
    x=chars[i]
    unless x[15].nil? || x[15].length<=0
      m=x[15].split(" as ")
      charsx[0].push(x[0]) if m[0]==nammes[0]
    end
    unless x[16].nil? || x[16].length<=0
      m=x[16].split(" as ")
      charsx[1].push(x[0]) if m[0]==nammes[1]
    end
    unless x[17].nil? || x[17].length<=0
      m=x[17].split(" as ")
      charsx[2].push(x[0]) if m[0]==nammes[2]
    end
  end
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    disp="#{disp}\n" if charsx.map{|q| q.length}.max>0
    disp="#{disp}\n**Same artist:** #{charsx[0].join(', ')}" if charsx[0].length>0
    disp="#{disp}\n**Same VA(EN):** #{charsx[1].join(', ')}" if charsx[1].length>0
    disp="#{disp}\n**Same VA(JP):** #{charsx[2].join(', ')}" if charsx[2].length>0
    disp=">No information<" if disp.length<=0
    event.respond "#{disp}\n\n#{art}"
  else
    disp=">No information<" if disp.length<=0
    flds=[]
    flds.push(['Same Artist',charsx[0].join("\n")]) if charsx[0].length>0
    flds.push(['Same VA (English)',charsx[1].join("\n")]) if charsx[1].length>0
    flds.push(['Same VA (Japanese)',charsx[2].join("\n")]) if charsx[2].length>0
    event.channel.send_embed("__**#{j[0]}**__") do |embed|
      embed.description=disp
      embed.color=unit_color(event,find_unit(j[0],event),0)
      unless flds.nil?
        for i in 0...flds.length
          embed.add_field(name: flds[i][0], value: flds[i][1], inline: true)
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
    for i in 0...name.length
      learnable_skills(event,name[i],bot)
    end
    return nil
  end
  data_load()
  name=find_name_in_string(event) if name.nil?
  j=@data[find_unit(name,event)]
  k=@skills.reject{|q| q[4]=="Passive(W)"}.map{|q| q[5]}.uniq
  bbb=[]
  for i in 0...k.length
    k3=true
    k2=k[i].split(', ')
    for i2 in 0...k2.length
      k3=false if k2[i2]=="No one"
      if k2[i2].include?("Excludes")
        k4=true
        if k2[i2].include?("Weapon Users")
          k4=false if k2[i2].include?(j[1][0])
        elsif k2[i2].include?("Users")
          k4=false if k2[i2].include?("Excludes Tome") && j[1][1]=="Tome"
          k4=false if k2[i2].include?("and Tome") && j[1][1]=="Tome"
          k4=false if k2[i2].include?("Excludes Bow") && j[1][1]=="Bow"
          k4=false if k2[i2].include?("and Bow") && j[1][1]=="Bow"
          k4=false if k2[i2].include?("Excludes Dagger") && j[1][1]=="Dagger"
          k4=false if k2[i2].include?("and Dagger") && j[1][1]=="Dagger"
          k4=false if k2[i2].include?(weapon_clss(j[1],event).gsub('Healer','Staff'))
        else
          k4=false if k2[i2].include?("Dragons") && j[1][1]=="Dragon"
          k4=false if k2[i2].include?("Beasts") && j[1][1]=="Beast"
          k4=false if k2[i2].include?(j[3].gsub('Flier','Fliers')) || k2[i2].include?(j[3].gsub('Armor','Armored'))
        end
        k3=(k3 && k4)
      end
      if k2[i2].include?("Only")
        k4=false
        k4=true if k2[i2]=="Dragons Only" && j[1][1]=="Dragon"
        k4=true if k2[i2]=="Beasts Only" && j[1][1]=="Beast"
        k4=true if k2[i2]=="Tome Users Only" && j[1][1]=="Tome"
        k4=true if k2[i2]=="Bow Users Only" && j[1][1]=="Bow"
        k4=true if k2[i2]=="Dagger Users Only" && j[1][1]=="Dagger"
        k4=true if k2[i2]=="Melee Weapon Users Only" && ["Blade","Dragon","Beast"].include?(j[1][1])
        k4=true if k2[i2]=="Ranged Weapon Users Only" && ["Tome","Bow","Dagger","Healer"].include?(j[1][1])
        k4=true if k2[i2].include?(j[3].gsub('Flier','Fliers')) || k2[i2].include?(j[3].gsub('Armor','Armored'))
        k4=true if k2[i2]=="#{weapon_clss(j[1],event).gsub('Healer','Staff')} Users Only"
        k4=true if k2[i2]=="#{j[1][0]} Weapon Users Only"
        k4=true if k2[i2]=="Summon Gun Users Only" && j[0]=="Kiran"
        if k2[i2].include?("Dancers")
          u2=@skills[find_skill("Dance",event)]
          b=[]
          for i3 in 14...19
            u=u2[i3].split(', ')
            for j2 in 0...u.length
              b.push(u[j2].gsub('Lavatain','Laevatein')) unless b.include?(u[j2]) || u[j2].include?("-")
            end
          end
          k4=true if b.include?(j[0])
        end
        if k2[i2].include?("Singers")
          u2=@skills[find_skill("Sing",event)]
          b=[]
          for i3 in 14...19
            u=u2[i3].split(', ')
            for j2 in 0...u.length
              b.push(u[j2].gsub('Lavatain','Laevatein')) unless b.include?(u[j2]) || u[j2].include?("-")
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
  matches4=[]
  matches3=@skills.reject{|q| !bbb.include?(q[5]) || !has_any?(g, q[21]) || (q[6]!='-' && !q[6].split(', ').include?(j[0])) || q[0].include?('Squad Ace ') || q[0].include?('Initiate Seal ') || (q[4].split(', ').include?('Passive(W)') && !q[4].split(', ').include?('Passive(S)') && !q[4].split(', ').include?('Seal') && [q[14].length,q[15].length,q[16].length,q[17].length,q[18].length].max<2)}
  q=@skills[@skills.length-1]
  puts [q[14].length,q[15].length,q[16].length,q[17].length,q[18].length].to_s
  puts 
  for i in 0...matches3.length
    unless matches3[i].nil? || matches3[i][0][0,10]=="Falchion ("
      if skill_include?(matches3,"#{matches3[i][0]}+")>=0
        matches3[skill_include?(matches3,"#{matches3[i][0]}+")]=nil
        matches3[i][0]="#{matches3[i][0]}(+)"
      elsif matches3[i][0][matches3[i][0].length-1,1].to_i.to_s==matches3[i][0][matches3[i][0].length-1,1]
        v=matches3[i][0][matches3[i][0].length-1,1].to_i
        if skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+1}")>=0
          matches3[skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+1}")]=nil
          if skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+2}")>=0
            matches3[skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+2}")]=nil
            if skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+3}")>=0
              matches3[skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+3}")]=nil
              if skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+4}")>=0
                matches3[skill_include?(matches3,"#{matches3[i][0][0,matches3[i][0].length-1]}#{v+4}")]=nil
                matches3[i][0]="#{matches3[i][0][0,matches3[i][0].length-1]}#{v}/#{v+1}/#{v+2}/#{v+3}/#{v+4}"
              else
                matches3[i][0]="#{matches3[i][0][0,matches3[i][0].length-1]}#{v}/#{v+1}/#{v+2}/#{v+3}"
              end
            else
              matches3[i][0]="#{matches3[i][0][0,matches3[i][0].length-1]}#{v}/#{v+1}/#{v+2}"
            end
          else
            matches3[i][0]="#{matches3[i][0][0,matches3[i][0].length-1]}#{v}/#{v+1}"
          end
        end
      end
      matches4.push(matches3[i])
    end
  end
  for i in 0...matches4.length
    matches4[i][0]=matches4[i][0].gsub('Bladeblade','Laevatein')
  end
  matches4=split_list(event,matches4,['Weapon','Assist','Special','Passive(A)','Passive(B)','Passive(C)','Passive(S)'],4)
  p1=[[]]
  p2=0
  for i in 0...matches4.length
    if matches4[i][0]=="- - -"
      p1.push([])
      p2+=1
    else
      p1[p2].push(matches4[i][0])
    end
  end
  j=find_unit(j[0],event)
  p1=p1.map{|q| q.join("\n")}
  if p1[0].length+p1[1].length+p1[2].length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    msg="__Skills **#{@data[j][0]}** can learn__"
    msg=extend_message(msg,"*Weapons:* #{p1[0].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"*Assists:* #{p1[1].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"*Specials:* #{p1[2].gsub("\n",', ')}",event,2)
    event.respond msg
  else
    create_embed(event,"__Skills **#{@data[j][0]}** can learn__",'',unit_color(event,j),nil,pick_thumbnail(event,j,bot),[['Weapons',p1[0]],['Assists',p1[1]],['Specials',p1[2]]],4)
  end
  if !event.server.nil? && event.channel.id != 283821884800499714 && @shardizard != 4
    event.respond "For the passive skills this unit can learn, please use this command in PM."
    return nil
  elsif p1[3].length+p1[4].length+p1[5].length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    msg=""
    msg=extend_message(msg,"*Passives(A):* #{p1[3].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"*Passives(B):* #{p1[4].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"*Passives(C):* #{p1[5].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"*Passives(S):* #{p1[6].gsub("\n",', ')}",event,2) unless p1[6].nil?
    event.respond msg
  else
    create_embed(event,"",'',unit_color(event,j),nil,nil,[['Passives(A)',p1[3]],['Passives(B)',p1[4]],['Passives(C)',p1[5]]],4)
    p1[6]=p1[6].split("\n")
    l=0
    l=1 if p1[6].length%3==2
    m=0
    m=1 if p1[6].length%3==1
    p11=p1[6][0,p1[6].length/3+l].join("\n")
    p2=p1[6][p1[6].length/3+l,p1[6].length/3+m].join("\n")
    p3=p1[6][2*(p1[6].length/3)+l+m,p1[6].length/3+l].join("\n")
    create_embed(event,"__Seals **#{@data[j][0]}** can equip__",'',unit_color(event,j),nil,nil,[['.',p11],['.',p2],['.',p3]],4)
  end
  return nil
end

bot.command([:allinheritance,:allinherit,:allinheritable,:skillinheritance,:skillinherit,:skillinheritable,:skilllearn,:skilllearnable,:skillsinheritance,:skillsinherit,:skillsinheritable,:skillslearn,:skillslearnable,:inheritanceskills,:inheritskill,:inheritableskill,:learnskill,:learnableskill,:inheritanceskills,:inheritskills,:inheritableskills,:learnskills,:learnableskills,:all_inheritance,:all_inherit,:all_inheritable,:skill_inheritance,:skill_inherit,:skill_inheritable,:skill_learn,:skill_learnable,:skills_inheritance,:skills_inherit,:skills_inheritable,:skills_learn,:skills_learnable,:inheritance_skills,:inherit_skill,:inheritable_skill,:learn_skill,:learnable_skill,:inheritance_skills,:inherit_skills,:inheritable_skills,:learn_skills,:learnable_skills,:inherit,:learn,:inheritance,:learnable,:inheritable,:skillearn,:skillearnable]) do |event, *args|
  if args.nil? || args.length<1
    event.respond "No unit was included"
    return nil
  end
  parse_function(:learnable_skills,event,args,bot)
  return nil
end

bot.command([:summonpool,:summon_pool,:pool]) do |event, *args|
  disp_summon_pool(event,args)
  return nil
end

bot.command(:art) do |event, *args|
  if args.nil? || args.length<1
    event.respond "No unit was included"
    return nil
  end
  parse_function(:disp_art,event,args,bot)
  return nil
end

bot.command([:legendary,:legendaries]) do |event, *args|
  args=[] if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  args=args.map{|q| q.downcase}
  data_load()
  g=get_markers(event)
  l=@data.reject{|q| q[2][0]==' ' || !has_any?(g, q[22])}
  l.sort!{|a,b| a[0]<=>b[0]}
  c=[]
  for i in 0...l.length
    c.push([102,218,250]) if l[i][2][0]=="Water"
    c.push([222,95,9]) if l[i][2][0]=="Earth"
    c.push([122,233,112]) if l[i][2][0]=="Wind"
    c.push([242,70,58]) if l[i][2][0]=="Fire"
    c.push([64,0,128]) if l[i][2][0]=="Dark"
  end
  l.uniq!
  x=[]
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
  x=prio(x,['Element','Stat','Weapon','Color','Movement'])
  pri=x[0]
  sec=x[1]
  tri=x[2] if x.length>=3
  if pri=='Element'
    l2=split_list(event,l,['Fire','Water','Wind','Earth','Dark'],-5)
  elsif pri=='Stat'
    l2=split_list(event,l,['Attack','Speed','Defense','Resistance'],-6)
  elsif pri=='Weapon'
    l2=split_list(event,l,['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Dragon','Bow','Dagger','Healer'],15)
  elsif pri=='Color'
    l2=split_list(event,l,['Red','Blue','Green','Colorless'],-2)
  elsif pri=='Movement'
    l2=split_list(event,l,['Infantry','Armor','Cavalry','Flier'],3)
  end
  p1=[[]]
  p2=0
  for i in 0...l2.length
    if l2[i][0]=="- - -"
      p2+=1
      p1.push([])
    else
      p1[p2].push(l2[i])
    end
  end
  for i in 0...p1.length
    x2='.'
    x2=p1[i][0][2][0] if pri=='Element'
    x2=p1[i][0][2][1] if pri=='Stat'
    x2=weapon_clss(p1[i][0][1],event,1) if pri=='Weapon'
    x2=p1[i][0][1][0] if pri=='Color'
    x2=p1[i][0][3] if pri=='Movement'
    if sec=='Stat'
      l2=split_list(event,p1[i],['Attack','Speed','Defense','Resistance'],-6)
    elsif sec=='Weapon'
      l2=split_list(event,p1[i],['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Dragon','Bow','Dagger','Healer'],15)
    elsif sec=='Color'
      l2=split_list(event,p1[i],['Red','Blue','Green','Colorless'],-2)
    elsif sec=='Movement'
      l2=split_list(event,p1[i],['Infantry','Armor','Cavalry','Flier'],3)
    end
    p2=[[]]
    p3=0
    for j in 0...l2.length
      if l2[j][0]=="- - -"
        p3+=1
        p2.push([])
      else
        p2[p3].push(l2[j])
      end
    end
    for j in 0...p2.length
      x3='.'
      x3=p2[j][0][2][0] if sec=='Element'
      x3=p2[j][0][2][1] if sec=='Stat'
      x3=weapon_clss(p2[j][0][1],event,1) if sec=='Weapon'
      x3=p2[j][0][1][0] if sec=='Color'
      x3=p2[j][0][3] if sec=='Movement'
      p2[j]="__*#{x3}*__\n#{p2[j].map{|q| "#{"~~" unless q[23].nil?}#{q[0]}#{" - *#{weapon_clss(q[1],event,1) if tri=='Weapon'}#{q[1][0] if tri=='Color'}#{q[3] if tri=='Movement'}*" unless tri==''}#{"~~" unless q[23].nil?}"}.join("\n")}" unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      p2[j]="*#{x3}*: #{p2[j].map{|q| "#{"~~" unless q[23].nil?}#{q[0]}#{" - *#{weapon_clss(q[1],event,1) if tri=='Weapon'}#{q[1][0] if tri=='Color'}#{q[3] if tri=='Movement'}*" unless tri==''}#{"~~" unless q[23].nil?}"}.join(", ")}" if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    end
    p1[i]=[x2,p2.join("\n\n")] unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    p1[i]=[x2,p2.join("\n")] if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
  end
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event << "__**All Legendary Heroes**__"
    for i in 0...p1.length
      event << ""
      event << "__*#{p1[i][0]}*__"
      event << p1[i][1]
    end
  else
    create_embed(event,"__**All Legendary Heroes**__",'',avg_color(c),nil,nil,p1)
  end
  return nil
end

bot.command([:refinery,:refine]) do |event|
  event.channel.send_temporary_message("Calculating data, please wait...",1)
  srv=0
  srv=event.server.id unless event.server.nil?
  data_load()
  stones=[]
  dew=[]
  g=get_markers(event)
  skkz=@skills.map{|q| q}
  for i in 0...skkz.length
    if skkz[i][4]=="Weapon" && skkz[i][0]!="Falchion" && skkz[i][0]!="Breidablik" && !skkz[i][23].nil? && has_any?(g, skkz[i][21])
      if skkz[i][6]=="-"
        stones.push("#{"~~" unless skkz[i][21].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')}#{"~~" unless skkz[i][21].nil?}")
      else
        dew.push("#{"~~" unless skkz[i][21].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')}#{"~~" unless skkz[i][21].nil?}")
      end
    end
  end
  dew2=[]
  stones2=[]
  for i in 0...skkz.length
    unless skkz[i].nil?
      if skkz[i][4]=="Weapon" && skkz[i][0]!="Falchion" && skkz[i][0]!="Breidablik" && !skkz[i][22].nil? && has_any?(g, skkz[i][21])
        s=skkz[i][22].split(', ')
        for j in 0...s.length
          if s[j].include?('!')
            s[j]=s[j].split('!')
            s2=skkz[find_skill(s[j][1],event)]
            if s2[6]=="-"
              stones2.push("#{"~~" unless skkz[i][21].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} -> #{s[j][1].gsub('Bladeblade','Laevatein')} (#{s[j][0].gsub('Lavatain','Laevatein')})#{"~~" unless skkz[i][21].nil?}")
            else
              dew2.push("#{"~~" unless skkz[i][21].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} -> #{s[j][1].gsub('Bladeblade','Laevatein')} (#{s[j][0].gsub('Lavatain','Laevatein')})#{"~~" unless skkz[i][21].nil?}")
            end
          else
            s2=skkz[find_skill(s[j],event)]
            if s2[6]=="-"
              stones2.push("#{"~~" unless skkz[i][21].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} -> #{s[j].gsub('Bladeblade','Laevatein')}#{"~~" unless skkz[i][21].nil?}")
            else
              dew2.push("#{"~~" unless skkz[i][21].nil?}#{skkz[i][0].gsub('Bladeblade','Laevatein')} -> #{s[j].gsub('Bladeblade','Laevatein')}#{"~~" unless skkz[i][21].nil?}")
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
  if stones.join("\n").length+dew.join("\n").length+stones2.join("\n").length+dew2.join("\n").length>1950 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    if dew2.join("\n").length+stones2.join("\n").length>1950 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      if dew2.join("\n").length>1950 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg="__**Weapon Evolution: Divine Dew**__"
        k=[["Swords",[]],["Red Tomes",[]],["Lances",[]],["Blue Tomes",[]],["Axes",[]],["Green Tomes",[]],["Dragonstones",[]],["Bows",[]],["Daggers",[]],["Staves",[]]]
        for i in 0...dew2.length
          k2="#{@skills[find_skill(stat_buffs(dew2[i].gsub('~~','').split(' -> ')[0]),event,false,true)][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone')}s"
          for j in 0...k.length
            k[j][1].push(dew2[i]) if k2==k[j][0]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        l=0
        l=1 if dew2.length%3==2
        m=0
        m=1 if dew2.length%3==1
        p1=dew2[0,dew2.length/3+l].join("\n")
        p2=dew2[dew2.length/3+l,dew2.length/3+m].join("\n")
        p3=dew2[2*(dew2.length/3)+l+m,dew2.length/3+l].join("\n")
        create_embed(event,"__**Weapon Evolution: Divine Dew**__",'',0x9BFFFF,nil,nil,[['.',p1],['.',p2],['.',p3]],3)
      end
      if stones2.join("\n").length>1950 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg="__**Weapon Evolution: Refining Stones**__"
        k=[["Swords",[]],["Red Tomes",[]],["Lances",[]],["Blue Tomes",[]],["Axes",[]],["Green Tomes",[]],["Dragonstones",[]],["Bows",[]],["Daggers",[]],["Staves",[]]]
        for i in 0...stones2.length
          k2="#{@skills[find_skill(stat_buffs(stones2[i].gsub('~~','').split(' -> ')[0]),event,false,true)][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone')}s"
          for j in 0...k.length
            k[j][1].push(stones2[i]) if k2==k[j][0]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        l=0
        l=1 if stones2.length%3==2
        m=0
        m=1 if stones2.length%3==1
        p1=stones2[0,stones2.length/3+l].join("\n")
        p2=stones2[stones2.length/3+l,stones2.length/3+m].join("\n")
        p3=stones2[2*(stones2.length/3)+l+m,stones2.length/3+l].join("\n")
        create_embed(event,"__**Weapon Evolution: Refining Stones**__",'',0x9BFFFF,nil,nil,[['.',p1],['.',p2],['.',p3]],3)
      end
    else
      create_embed(event,"__**Weapon Evolution**__",'',0x9BFFFF,nil,nil,[['**Divine Dew**',dew2.join("\n")],['**Refining Stones**',stones2.join("\n")]],3)
    end
    if stones.join("\n").length+dew.join("\n").length>1950 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      if dew.join("\n").length>1950 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg="__**Weapon Refines: Divine Dew**__"
        k=[["Swords",[]],["Red Tomes",[]],["Lances",[]],["Blue Tomes",[]],["Axes",[]],["Green Tomes",[]],["Dragonstones",[]],["Bows",[]],["Daggers",[]],["Staves",[]]]
        for i in 0...dew.length
          k2="#{@skills[find_skill(stat_buffs(dew[i].gsub('~~','')),event,false,true)][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone')}s"
          for j in 0...k.length
            k[j][1].push(dew[i]) if k2==k[j][0]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        l=0
        l=1 if dew.length%3==2
        m=0
        m=1 if dew.length%3==1
        p1=dew[0,dew.length/3+l].join("\n")
        p2=dew[dew.length/3+l,dew.length/3+m].join("\n")
        p3=dew[2*(dew.length/3)+l+m,dew.length/3+l].join("\n")
        create_embed(event,"__**Weapon Refines: Divine Dew**__",'',0x688C68,nil,nil,[['.',p1],['.',p2],['.',p3]],3)
      end
      if stones.join("\n").length>1950 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg="__**Weapon Refines: Refining Stones**__"
        k=[["Swords",[]],["Red Tomes",[]],["Lances",[]],["Blue Tomes",[]],["Axes",[]],["Green Tomes",[]],["Dragonstones",[]],["Bows",[]],["Daggers",[]],["Staves",[]]]
        for i in 0...stones.length
          k2="#{@skills[find_skill(stat_buffs(stones[i].gsub('~~','')),event,false,true)][5].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone')}s"
          for j in 0...k.length
            k[j][1].push(stones[i]) if k2==k[j][0]
          end
        end
        for i in 0...k.length
          msg=extend_message(msg,"*#{k[i][0]}:* #{k[i][1].join(', ')}",event) if k[i][1].length>0
        end
        event.respond msg
      else
        l=0
        l=1 if stones.length%3==2
        m=0
        m=1 if stones.length%3==1
        p1=stones[0,stones.length/3+l].join("\n")
        p2=stones[stones.length/3+l,stones.length/3+m].join("\n")
        p3=stones[2*(stones.length/3)+l+m,stones.length/3+l].join("\n")
        create_embed(event,"__**Weapon Refines: Refining Stones**__",'',0x688C68,nil,nil,[['.',p1],['.',p2],['.',p3]],3)
      end
    else
      stones2=stones[stones.length/2+stones.length%2,stones.length/2]
      stones=stones[0,stones.length/2+3*stones.length%2]
      create_embed(event,"__**Weapon Refines**__",'',0x688C68,nil,nil,[['**Divine Dew**',dew.join("\n")],['**Refining Stones**',stones.join("\n")],['**Refining Stones**',stones2.join("\n")]],3)
    end
    return nil
  else
    dew3=["__**Refinement**__"]
    stones3=["__**Refinement**__"]
    for i in 0...dew.length
      dew3.push(dew[i])
    end
    for i in 0...stones.length
      stones3.push(stones[i])
    end
    stones=stones3.map{|q| q}
    dew=dew3.map{|q| q}
    dew.push("- - -")
    dew.push("__**Evolution**__")
    stones.push("- - -")
    stones.push("__**Evolution**__")
    for i in 0...dew2.length
      dew.push(dew2[i])
    end
    for i in 0...stones2.length
      stones.push(stones2[i])
    end
    stones2=stones[stones.length/2+stones.length%2,stones.length/2]
    stones=stones[0,stones.length/2+3*stones.length%2]
    create_embed(event,"Weapon Refinery",'',0x688C68,nil,nil,[['**Divine Dew**',dew.join("\n")],['**Refining Stones**',stones.join("\n")],['**Refining Stones**',stones2.join("\n")]],3)
  end
end

bot.command([:donation, :donate]) do |event|
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.user.id==195303206933233665 || event.message.text.include?('<@195303206933233665>') || event.message.text.downcase.include?('mobile') || event.message.text.downcase.include?('phone')
    event << "__A word from my developer__\nI made EliseBot, as she is now, as a free service.  During development, I never once considered making people pay to add her to their servers, or anything of the sort.  The creation of Elise's core functionality, the `stats` function, was mainly a way for me to better understand the mechanics behind FEH's growths, because how games work is one of my interests.\n\nDespite this, people in at least two servers have asked me about possibly creating a Patreon or Paypal donation button to allow users to show their support.  I am humbled to know that EliseBot's information-dump-and-stat-calculation functionality is something people are willing to pay for, especially considering there are many other methods users can obtain this data.\n\nConsidering how adamant some people were about wanting to support me, it seems almost rude not to start a Patreon...but I, unfortunately, must toss the idea aside.  Due to certain insurance regulations regarding places like the one I live in, I would only be allowed to keep a small portion of any secondary income I receive.  Starting a Patreon only to have only a third or even less reach my hands seems dishonest to my supporters, and that is something I do not wish to have hanging over my head.  Since they were spending that money with the intention of supporting the development of EliseBot, they may not wish to have their money go to a corporation that may or may not spend that money to increase my quality of life."
    event.respond "However, there is a roundabout solution for those who wish to support me: Gift cards - such as those for the Nintendo eShop or Google Play - do not count as secondary income, and as such I get to keep the full amount of any I receive.  As such, if you wish to support me, and only if you really wish to support me, the best way to do so is acquire a gift card and email the code to **rot8er.conex@gmail.com**.  There is also, if there are items on it, my Amazon wish list, linked below.  I recently learned that I can have items purchased from that list delivered to me without giving out my address.\n\n~~Please note that supporting me means indirectly enabling my addiction to pretzels and pizza rolls.~~\n\nhttp://a.co/0p3sBec"
  else
    create_embed(event,"__A word from my developer__","I made EliseBot, as she is now, as a free service.  During development, I never once considered making people pay to add her to their servers, or anything of the sort.  The creation of Elise's core functionality, the `stats` function, was mainly a way for me to better understand the mechanics behind FEH's growths, because how games work is one of my interests.\n\nDespite this, people in at least two servers have asked me about possibly creating a Patreon or Paypal donation button to allow users to show their support.  I am humbled to know that EliseBot's information-dump-and-stat-calculation functionality is something people are willing to pay for, especially considering there are many other methods users can obtain this data.\n\nConsidering how adamant some people were about wanting to support me, it seems almost rude not to start a Patreon...but I, unfortunately, must toss the idea aside.  Due to certain insurance regulations regarding places like the one I live in, I would only be allowed to keep a small portion of any secondary income I receive.  Starting a Patreon only to have only a third or even less reach my hands seems dishonest to my supporters, and that is something I do not wish to have hanging over my head.  Since they were spending that money with the intention of supporting the development of EliseBot, they may not wish to have their money go to a corporation that may or may not spend that money to increase my quality of life.",0x008b8b)
    create_embed(event,"","\n\nHowever, there is a roundabout solution for those who wish to support me: Gift cards - such as those for the Nintendo eShop or Google Play - do not count as secondary income, and as such I get to keep the full amount of any I receive.  As such, if you wish to support me, and only if you really wish to support me, the best way to do so is acquire a gift card and email the code to **rot8er.conex@gmail.com**.  There is also, if there are items on it, [my Amazon wish list](http://a.co/0p3sBec).  I recently learned that I can have items purchased from that list delivered to me without giving out my address.",0x008b8b,"Please note that supporting me means indirectly enabling my addiction to pretzels and pizza rolls.")
    event.respond "If you are on a mobile device and cannot click the links in the embed above, type `FEH!donate mobile` to receive this message as plaintext."
  end
  return nil
end

bot.command([:random,:rand]) do |event, *args|
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
    movement.push('Cavalry') if ['cavalry','horse','pony','horsie','horses','horsies','ponies'].include?(args[i].downcase)
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
        color_weapons.push([colors[i],weapons[j]]) unless (weapons[j]=='Blade' && !colorless_blades?(event)) || (weapons[j]=='Tome' && !colorless_tomes?(event))
      elsif weapons[j]=='Healer' && !colored_healers?(event)
      else
        color_weapons.push([colors[i],weapons[j]])
      end
    end
  end
  if color_weapons.length<=0
    color_weapons=[['Red', 'Blade'],     ['Red', 'Tome'],     ['Red', 'Breath'],      ['Red', 'Bow'],
                   ['Blue', 'Blade'],    ['Blue', 'Tome'],    ['Blue', 'Breath'],     ['Blue', 'Bow'],
                   ['Green', 'Blade'],   ['Green', 'Tome'],   ['Green', 'Breath'],    ['Green', 'Bow'],
                                                              ['Colorless', 'Breath'],['Colorless', 'Bow'],   ['Colorless', 'Dagger']]
    if colored_daggers?(event)
      color_weapons.push(['Red', 'Dagger'])
      color_weapons.push(['Blue', 'Dagger'])
      color_weapons.push(['Green', 'Dagger'])
    end
    color_weapons.push(['Colorless', 'Blade']) if colorless_blades?(event)
    color_weapons.push(['Colorless', 'Tome']) if colorless_tomes?(event)
    unless event.message.text.downcase.split(' ').include?('singer') || event.message.text.downcase.split(' ').include?('dancer')
      color_weapons.push(['Red', 'Healer']) if colored_healers?(event)
      color_weapons.push(['Blue', 'Healer']) if colored_healers?(event)
      color_weapons.push(['Green', 'Healer']) if colored_healers?(event)
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
  elsif event.message.text.downcase.split(' ').include?('nonmusical')
  elsif event.message.text.downcase.split(' ').include?('non-musical')
  elsif clazz[1]!='Healer' && rand(10)==0
    clazz2.push(['Dancer','Singer'].sample)
    l1_total-=8
  end
  zzz=rand(100)
  zzz=rand(1000) if clazz2.include?('Trainee') || clazz2.include?('Veteran')
  if args.include?('+1/2')
    clazz2.push('+1/2')
    l1_total+=1
    gp_total+=2
  elsif args.include?('+1/1')
    clazz2.push('+1/1')
    l1_total+=1
    gp_total+=1
  elsif args.include?('+0/2') || event.message.text.downcase.split(' ').include?('cyl')
    clazz2.push('+0/2')
    gp_total+=2
  elsif args.include?('+0/1')
    clazz2.push('+0/1')
    gp_total+=1
  elsif event.message.text.downcase.split(' ').include?('starter')
  elsif zzz<5
    clazz2.push('+1/2')
    l1_total+=1
    gp_total+=2
  elsif zzz<8
    clazz2.push('+1/1')
    l1_total+=1
    gp_total+=1
  elsif zzz<10
    clazz2.push('+0/2')
    gp_total+=2
  elsif zzz<11
    clazz2.push('+0/1')
    gp_total+=1
  end
  name=get_bond_name(event)
  stats=[0,0,0,0,0]
  gps=[0,0,0,0,0]
  stats[0]=10+rand(16)
  gps[0]=1+rand(@mods.length-1)
  l1_total-=stats[0]
  gp_total-=gps[0]
  min_possible=[l1_total-40,2].max
  max_possible=[l1_total-8,14].min
  if max_possible<=min_possible
    stats[1]=min_possible
  else
    stats[1]=min_possible+rand(max_possible-min_possible+1)
  end
  min_possible=[gp_total-3*(@mods.length-2),1].max
  max_possible=[gp_total-3,(@mods.length-2)].min
  if max_possible<=min_possible
    gps[1]=min_possible
  else
    gps[1]=min_possible+rand(max_possible-min_possible+1)
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
  min_possible=[gp_total-2*(@mods.length-2),1].max
  max_possible=[gp_total-2,(@mods.length-2)].min
  if max_possible<=min_possible
    gps[2]=min_possible
  else
    gps[2]=min_possible+rand(max_possible-min_possible+1)
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
  min_possible=[gp_total-(@mods.length-2),1].max
  max_possible=[gp_total-1,(@mods.length-2)].min
  if max_possible<=min_possible
    gps[3]=min_possible
  else
    gps[3]=min_possible+rand(max_possible-min_possible+1)
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
  stats.push(stats[0]+stats[1]+stats[2]+stats[3]+stats[4])
  stats.push(stats[5]+stats[6]+stats[7]+stats[8]+stats[9])
  stat_names=['HP','Attack','Speed','Defense','Resistance']
  for i in 0...5
    stats[i+5]=stats[i+5].to_s
    stats[i+5]="#{stats[i+5]} (+)" if [1,5,10].include?(gps[i])
    stats[i+5]="#{stats[i+5]} (-)" if [2,6,11].include?(gps[i])
  end
  xcolor=0xFFD800
  xcolor=0xB32400 if clazz[0]=='Red'
  xcolor=0x208EFB if clazz[0]=='Blue'
  xcolor=0x01AD00 if clazz[0]=='Green'
  xcolor=0xC1CCD6 if clazz[0]=='Colorless'
  clazz[1]=clazz[1].gsub('Breath','Dragon')
  w=clazz[1]
  w='Sword' if clazz[0]=='Red' && w=='Blade'
  w='Lance' if clazz[0]=='Blue' && w=='Blade'
  w='Axe' if clazz[0]=='Green' && w=='Blade'
  w='Rod' if clazz[0]=='Colorless' && w=='Blade'
  if clazz[1]!=w
    w="*#{w}* (#{clazz[0]} #{clazz[1]})"
  elsif ['Tome', 'Dragon', 'Bow'].include?(w) || (w=='Healer' && colored_healers?(event)) || (w=='Dagger' && colored_daggers?(event))
    w="*#{clazz[0]} #{clazz[1]}*"
  elsif clazz[0]=='Gold'
    w="*#{w}*"
  else
    w="*#{w}* (#{clazz[0]})"
  end
  if w=="*Red Tome*"
    w="*#{['Fire','Dark'].sample} Mage* (Red Tome)"
  elsif w=="*Green Tome*"
    w="*#{['Wind'].sample} Mage* (Green Tome)"
  elsif w=="*Blue Tome*"
    w="*#{['Thunder','Light'].sample} Mage* (Blue Tome)"
  end
  atk="Attack"
  atk="Magic" if ['Tome','Dragon','Healer'].include?(clazz[1])
  atk="Strength" if ['Blade','Bow','Dagger'].include?(clazz[1])
  r="<:star:322905655730241547>"*5
  flds=[["**Level 1**","HP: #{stats[0]}\n#{atk}: #{stats[1]}\nSpeed: #{stats[2]}\nDefense: #{stats[3]}\nResistance: #{stats[4]}\n\nBST: #{stats[10]}"]]
  args=args.map{|q| q.downcase}
  if args.include?('gps') || args.include?('gp') || args.include?('growths') || args.include?('growth')
    flds.push(["**Growth Points**","HP: #{gps[0]}\n#{atk}: #{gps[1]}\nSpeed: #{gps[2]}\nDefense: #{gps[3]}\nResistance: #{gps[4]}\n\nGPT: #{gps[0]+gps[1]+gps[2]+gps[3]+gps[4]}"])
  end
  flds.push(["**Level 40**","HP: #{stats[5]}\n#{atk}: #{stats[6]}\nSpeed: #{stats[7]}\nDefense: #{stats[8]}\nResistance: #{stats[9]}\n\nBST: #{stats[11]}"])
  img=nil
  ftr=nil
  unless event.server.nil?
    imgx=event.server.users.sample
    imgx=event.user if rand(100)==0 && event.server.users.length>100
    img=imgx.avatar_url
    ftr="Unit profile provided by #{imgx.distinct}"
  end
  create_embed(event,"__**#{name}**__","#{r}\nNeutral nature\nWeapon type: #{w}\nMovement type: *#{mov}*\n#{"Additional Modifier#{'s' if clazz2.length>1}: #{clazz2.map{|q| "*#{q}*"}.join(', ')}" if clazz2.length>0}",xcolor,ftr,img,flds,1)
  return nil
end

bot.command(:whyelise) do |event|
  if (!event.message.text.downcase.include?('full') && !event.message.text.downcase.include?('long')) && !event.server.nil?
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
  elsif rand(100)==0
    xcolor=0xDC3461
  end
  if " #{event.message.text.downcase} ".include?(' progression ')
    create_embed(event,"__**Non-healers**__","",xcolor,"Most non-healer units have one Scenario X passive and one Scenario Y passive",nil,[["__**Weapons**__","Tier 1 (*Iron, basic magic*) - Default at 1\\*\nTier 2 (*Steel, El- magic, Fire Breath+*) - Default at 2\\*\nTier 3 (*Silver, super magic*) - Available to 3\\*, default at 4\\*\nTier 4 (*+ weapons other than Fire Breath+, Prf weapons*) - default at 5\\*\nRetro-Prfs (*Felicia's Plate*) - Available at 5\\*, promotes from nothing"],["__**Assists**__","Tier 1 (*Rallies, Dance/Sing, etc.*) - Available at 3\\*, default at 4\\* ~~Sharena has hers default at 2\\*~~\nTier 2 (*Double Rallies*) - Available at 4\\*\nPrf Assists (*Sacrifice*) - Available at 5\\*"],["__**Specials**__","Miracle - Available at 3\\*, default at 5\\*\nTier 1 (*Daylight, New Moon, etc.*) - Available at 3\\*, default at 4\\* ~~Alfonse and Anna have theirs default at 2\\*~~\nTier 2 (*Sol, Luna, etc.*) - Available at 4\\* ~~Jaffar and Saber have theirs also default at 5\\*~~\nTier 3 (*Galeforce, Aether, Prf Specials*) - Available at 5\\*"],["__**Passives (scenario X)**__","Tier 1 - Available at 1\\*\nTier 2 - Available at 2\\*\nTier 3 - Available at 4\\*"],["__**Passives (scenario Y)**__","Tier 1 - Available at 3\\*\nTier 2 - Available at 4\\*\nTier 3 - Available at 5\\*"],["__**Prf Passives**__","Available at 5\\*"]],2)
    create_embed(event,"__**Healers**__","",0xC1CCD6,"Most healers have a Scenario Y passive",nil,[["__**Damaging Staves**__","Tier 1 (*only Assault*) - Available at 1\\*\nTier 2 (*non-plus staves*) - Available at 3\\* ~~Lyn(Bride) has hers default at 5\\*~~\nTier 3 (*+ staves, Prf weapons*) - Available at 5\\*"],["__**Healing Staves**__","Tier 1 (*Heal*) - Default at 1\\*\nTier 2 (*Mend, Reconcile*) - Available at 2\\*, default at 3\\*\nTier 3 (*all other non-plus staves*) - Available at 4\\*, default at 5\\*\nTier 4 (*+ staves*) - Available at 5\\*"],["__**Healer Specials**__","Miracle - Available at 3\\*, default at 5\\*\nTier 1 (*Imbue*) - Available at 2\\*, default at 3\\*\nTier 2 (*Balms, Heavenly Light*) - Available at 3\\*, default at 5\\*"],["__**Passives (scenario X)**__","Tier 1 - Available at 1\\*\nTier 2 - Available at 2\\*\nTier 3 - Available at 4\\*"],["__**Passives (scenario Y)**__","Tier 1 - Available at 3\\*\nTier 2 - Available at 4\\*\nTier 3 - Available at 5\\*"],["__**Prf Passives**__","Available at 5\\*"]],2)
  else
    create_embed(event,"**Supposed Bug: X character, despite not being available at #{r}, has skills listed for #{r.gsub('Y','that')} in the `skill` command.**\n\nA word from my developer","By observing the skill lists of the Daily Hero Battle units - the only units we have available at 1\\* - I have learned that there is a set progression for which characters learn skills.  Only six units directly contradict this observation - and three of those units are the Askrians, who were likely given their Assists and Tier 1 Specials (depending on the character) at 2\\* in order to make them useable in the early story maps when the player has limited orbs and therefore limited unit choices.  One is Lyn(Bride), who as the only seasonal healer so far, may be the start of a new pattern.  The other two are Jaffar and Saber, who - for unknown reasons - have their respective Tier 2 Specials available right out of the box as 5\\*s.\n\nThe information as it is is not useless.  In fact, as seen quite recently as of the time of this writing, IntSys is willing to demote some units out of the 4-5\\* pool into the 3-4\\* one. This information allows us to predict which skills the new 3\\* versions of these characters will have.\n\nAs for units unlikely to demote, Paralogue maps will have lower-rarity versions of units with their base kits.  Training Tower and Tempest Trials attempt to build units according to recorded trends in Arena, but will use default base kits at lower difficulties.  Obviously you can't fodder a 4* Siegbert for Death Blow 3, but you can still encounter him in Tempest.",xcolor)
    event.respond "To see the progression I have discovered, please use the command `FEH!skillrarity progression`."
  end
end

bot.command(:summon) do |event, *colors|
  if colors.nil? || colors.length<=0
  elsif colors[0].downcase=='pool'
    args=colors.map{|q| q}
    args[0]=nil
    args.compact!
    disp_summon_pool(event,args)
    return nil
  end
  if event.server.nil?
    event.respond "This command in unavailable in PM."
  elsif !@summon_servers.include?(event.server.id)
    event.respond "This command is unavailable in this server."
  else
    if !@banner[0].nil?
      post=Time.now
      if (post - @banner[0][1]).to_f < 600
        if event.server.id==@banner[0][2]
          event.respond "<@#{@banner[0][0]}>, please choose your summons as others would like to use this command"
        else
          event.respond "Please wait, as another server is using this command."
        end
        return nil
      else
        @banner=[]
      end
    end
    metadata_load()
    bnr=make_banner()
    n=["+HP -Atk","+HP -Spd","+HP -Def","+HP -Res","+Atk -HP","+Atk -Spd","+Atk -Def","+Atk -Res","+Spd -HP","+Spd -Atk","+Spd -Def","+Spd -Res","+Def -HP",
       "+Def -Atk","+Def -Spd","+Def -Res","+Res -HP","+Res -Atk","+Res -Spd","+Res -Def","Neutral"]
    n=["Neutral"] if bnr[0]=="TT Units" || bnr[0]=="GHB Units"
    event << "**Banner:** #{bnr[0]}"
    event << ""
    k=[[],[],[],[]]
    for i in 0...bnr[2].length
      k2=@data[find_unit(bnr[2][i],event)][1][0]
      k[0].push(bnr[2][i]) if k2=="Red"
      k[1].push(bnr[2][i]) if k2=="Blue"
      k[2].push(bnr[2][i]) if k2=="Green"
      k[3].push(bnr[2][i]) if k2=="Colorless"
    end
    event << "**Focus Heroes:**"
    event << "*Red*:	#{k[0].join(', ')}" if k[0].length>0
    event << "*Blue*:	#{k[1].join(', ')}" if k[1].length>0
    event << "*Green*:	#{k[2].join(', ')}" if k[2].length>0
    event << "*Colorless*:	#{k[3].join(', ')}" if k[3].length>0
    event << ""
    event << "**Summon rates:**"
    @banner=[[event.user.id,Time.now,event.server.id]]
    if bnr[1]<0
      sr=(@summon_rate[0]/5)*0.5
      b= 0 - bnr[1]
      focus = b + sr
      five_star = 0
      four_star = (100.00 - focus - five_star) * 58.00 / (100.00 - b)
      three_star = 100.00 - focus - five_star - four_star
      two_star = 0
      one_star = 0
    else
      sr=(@summon_rate[0]/5)*0.5
      focus = bnr[1] + sr * bnr[1] / (bnr[1] + 3.00)
      five_star = 3.00 + sr * 3.00 / (bnr[1] + 3.00)
      four_star = (100.00 - focus - five_star) * 58.00 / (100.00 - bnr[1] - 3)
      three_star = 100.00 - focus - five_star - four_star
      two_star = 0
      one_star = 0
    end
    event << "5\\* Focus:	#{'%.2f' % focus}%"
    event << "Other 5\\*:	#{'%.2f' % five_star}%" unless five_star==0
    if bnr[8].nil?
      event << "4\\* Unit:	#{'%.2f' % four_star}%" unless four_star==0
    elsif four_star>0
      event << "4\\* Focus:	#{'%.2f' % (four_star/2)}%"
      event << "Other 4\\*:	#{'%.2f' % (four_star/2)}%"
    end
    if bnr[9].nil?
      event << "3\\* Unit:	#{'%.2f' % three_star}%" unless three_star==0
    elsif three_star>0
      event << "3\\* Focus:	#{'%.2f' % (three_star/2)}%"
      event << "Other 3\\*:	#{'%.2f' % (three_star/2)}%"
    end
    if bnr[10].nil?
      event << "2\\* Unit:	#{'%.2f' % two_star}%" unless two_star==0
    elsif two_star>0
      event << "2\\* Focus:	#{'%.2f' % (two_star/2)}%"
      event << "Other 2\\*:	#{'%.2f' % (two_star/2)}%"
    end
    if bnr[11].nil?
      event << "1\\* Unit:	#{'%.2f' % one_star}%" unless one_star==0
    elsif two_star>0
      event << "1\\* Focus:	#{'%.2f' % (one_star/2)}%"
      event << "Other 1\\*:	#{'%.2f' % (one_star/2)}%"
    end
    event << ""
    for i in 1...6
      k=rand(10000)
      if k<focus*100
        hx=bnr[2].sample
        rx="5\\*"
        nr=n.sample
      elsif k<focus*100+five_star*100
        hx=bnr[3].sample
        rx="5\\*"
        nr=["+HP -Atk","+HP -Spd","+HP -Def","+HP -Res","+Atk -HP","+Atk -Spd","+Atk -Def","+Atk -Res","+Spd -HP","+Spd -Atk","+Spd -Def","+Spd -Res","+Def -HP","+Def -Atk","+Def -Spd","+Def -Res","+Res -HP","+Res -Atk","+Res -Spd","+Res -Def","Neutral"].sample
      elsif !bnr[8].nil? && k<focus*100+five_star*100+four_star*50
        hx=bnr[8].sample
        rx="4\\*"
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100
        hx=bnr[4].sample
        rx="4\\*"
        nr=["+HP -Atk","+HP -Spd","+HP -Def","+HP -Res","+Atk -HP","+Atk -Spd","+Atk -Def","+Atk -Res","+Spd -HP","+Spd -Atk","+Spd -Def","+Spd -Res","+Def -HP","+Def -Atk","+Def -Spd","+Def -Res","+Res -HP","+Res -Atk","+Res -Spd","+Res -Def","Neutral"].sample
      elsif !bnr[9].nil? && k<focus*100+five_star*100+four_star*100+three_star*50
        hx=bnr[9].sample
        rx="3\\*"
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100+three_star*100
        hx=bnr[5].sample
        rx="3\\*"
        nr=["+HP -Atk","+HP -Spd","+HP -Def","+HP -Res","+Atk -HP","+Atk -Spd","+Atk -Def","+Atk -Res","+Spd -HP","+Spd -Atk","+Spd -Def","+Spd -Res","+Def -HP","+Def -Atk","+Def -Spd","+Def -Res","+Res -HP","+Res -Atk","+Res -Spd","+Res -Def","Neutral"].sample
      elsif !bnr[10].nil? && k<focus*100+five_star*100+four_star*100+three_star*100+two_star*50
        hx=bnr[10].sample
        rx="3\\*"
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100+three_star*100+two_star*100
        hx=bnr[6].sample
        rx="3\\*"
        nr=["+HP -Atk","+HP -Spd","+HP -Def","+HP -Res","+Atk -HP","+Atk -Spd","+Atk -Def","+Atk -Res","+Spd -HP","+Spd -Atk","+Spd -Def","+Spd -Res","+Def -HP","+Def -Atk","+Def -Spd","+Def -Res","+Res -HP","+Res -Atk","+Res -Spd","+Res -Def","Neutral"].sample
      elsif !bnr[11].nil? && k<focus*100+five_star*100+four_star*100+three_star*100+two_star*100+one_star*50
        hx=bnr[11].sample
        rx="3\\*"
        nr=n.sample
      else
        hx=bnr[7].sample
        rx="3\\*"
        nr=["+HP -Atk","+HP -Spd","+HP -Def","+HP -Res","+Atk -HP","+Atk -Spd","+Atk -Def","+Atk -Res","+Spd -HP","+Spd -Atk","+Spd -Def","+Spd -Res","+Def -HP","+Def -Atk","+Def -Spd","+Def -Res","+Res -HP","+Res -Atk","+Res -Spd","+Res -Def","Neutral"].sample
      end
      @banner.push([rx,hx,nr])
    end
    cracked_orbs=[]
    if colors.nil?
      event << "**Orb options:**"
    elsif colors.length==0
      event << "**Orb options:**"
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
          cracked_orbs.push([@banner[i],i]) if trucolors.include?(@data[find_unit(@banner[i][1],event)][1][0])
        end
        event << "None of the colors you requested appeared.  Here are your **Orb options:**" if cracked_orbs.length==0
      else
        event << "**Orb options:**"
      end
    end
    if cracked_orbs.length>0
      summons=0
      five_star=false
      cutscene=true
      event << "**Summoning Results:**"
      for i in 0...cracked_orbs.length
        if cutscene && ["Camilla","Lyn","Roy","Takumi","Lucina","Marth","Tiki(Young)","Robin(M)"].include?(cracked_orbs[i][0][1])
          event.respond "OH!  Cutscene!  Cutscene!"
          sleep 5
          cutscene=false
        end
        event << "Orb ##{cracked_orbs[i][1]} contained a #{cracked_orbs[i][0][0]} **#{cracked_orbs[i][0][1]}** (*#{cracked_orbs[i][0][2]}*)"
        summons+=1
        five_star=true if cracked_orbs[i][0][0][0].to_i==5
      end
      event << ""
      event << "In this current summoning session, you fired Breidablik #{summons} time#{"s" unless summons==1}, expending #{[0,5,9,13,17,20][summons]} orbs."
      metadata_load()
      @summon_rate[0]+=summons
      @summon_rate[1]+=[0,5,9,13,17,20][summons]
      event << "Since the last 5\* summons, Breidablik has been fired #{@summon_rate[0]} time#{"s" unless @summon_rate[0]==1} and #{@summon_rate[1]} orbs have been expended."
      @summon_rate=[0,0] if five_star
      metadata_save()
      @banner=[]
    else
      for i in 1...@banner.length
        event << "#{i}.) #{@data[find_unit(@banner[i][1],event)][1][0]}"
      end
      event << ""
      event << "To open orbs, please respond - in a single message - with the number of each orb you want to crack."
      event << "You can also just say \"Summon all\" to open all orbs."
      event.channel.await(:bob, from: event.user.id) do |e|
        if @banner[0].nil?
        elsif e.user.id == @banner[0][0] && e.message.text.downcase.include?('summon all')
          crack_orbs(event,e,e.user.id,[1,2,3,4,5])
        elsif e.user.id == @banner[0][0] && e.message.text =~ /1|2|3|4|5/
          l=[]
          for i in 1...6
            l.push(i) if e.message.text.include?(i.to_s)
          end
          crack_orbs(event,e,e.user.id,l)
        else
          return false
        end
      end
      event << ""
    end
  end
  event << ""
end

bot.command([:effhp,:effHP,:eff_hp,:eff_HP,:bulk]) do |event, *args|
  if args.nil? || args.length<1
    event.respond "No unit was included"
    return nil
  end
  parse_function(:calculate_effective_HP,event,args,bot)
  return nil
end

bot.command([:heal_study,:healstudy,:studyheal,:study_heal]) do |event, *args|
  if args.nil? || args.length<1
    event.respond "No unit was included"
    return nil
  end
  parse_function(:heal_study,event,args,bot,true)
  return nil
end

bot.command([:proc_study,:procstudy,:studyproc,:study_proc]) do |event, *args|
  if args.nil? || args.length<1
    event.respond "No unit was included"
    return nil
  end
  parse_function(:proc_study,event,args,bot,false)
  return nil
end

bot.command([:phase_study,:phasestudy,:studyphase,:study_phase]) do |event, *args|
  if args.nil? || args.length<1
    event.respond "No unit was included"
    return nil
  end
  parse_function(:phase_study,event,args,bot)
  return nil
end

bot.command(:study) do |event, *args|
  if args.nil? || args.length<1
    event.respond "No unit was included"
    return nil
  end
  if ['effhp','eff_hp','bulk'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:calculate_effective_HP,event,args,bot)
    return nil unless k<0
  elsif ['heal'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:heal_study,event,args,bot,true)
    return nil unless k<0
  elsif ['proc'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:proc_study,event,args,bot,false)
    return nil unless k<0
  elsif ['phase'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:phase_study,event,args,bot)
    return nil unless k<0
  end
  parse_function(:unit_study,event,args,bot)
  return nil
end

bot.command(:games) do |event, *args|
  data_load()
  args=sever(event.message.text.downcase).split(" ")
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=find_name_in_string(event)
  j=find_unit(name,event)
  if j<0
    if args.join('').downcase =~ /ax(e|)(-|)(z|)ura/
      j=find_unit("Azura",event)
    elsif args.join('').downcase =~ /blu(e|)cina/
      j=find_unit("Lucina",event)
    elsif args.join('').downcase =~ /b(r|)lyn/
      j=find_unit("Lyn",event)
    elsif args.join('').downcase =~ /grima/
      j=find_unit("Robin(M)(Fallen)",event)
    end
  elsif args.join('').downcase =~ /(robin|reflet|daraen)/ && args.join('').downcase =~ /(fallen|evil|alter)/
    j=find_unit("Robin(M)(Fallen)",event)
  elsif args.join('').downcase =~ /(robin|reflet|daraen)/ && !["Robin(F)(Fallen)","Robin(M)(Fallen)"].include?(@data[j][0])
    j=find_unit("Robin(M)",event)
  elsif args.join('').downcase =~ /(robin|reflet|daraen)/
    j=find_unit("Robin(M)(Fallen)",event)
  end
  if j<0
    event.respond "No unit was included"
    return nil
  end
  rg=@data[j][21].reject{|q| q[0,3]=="(a)"}
  ag=@data[j][21].reject{|q| q[0,3]!="(a)"}.map{|q| q[3,q.length-3]}
  g=get_games_list(rg)
  ga=get_games_list(ag,false)
  mu=(event.message.text.downcase.include?("mathoo's"))
  xcolor=unit_color(event,j,0,mu)
  pic=pick_thumbnail(event,j,bot)
  g2="#{g[0]}"
  g[0]=nil
  g.compact!
  name="#{@data[j][0].gsub('Lavatain','Laevatein')}"
  if ["Robin(F)","Robin(M)"].include?(@data[j][0])
    pic="https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png"
    name="Robin"
    xcolor=avg_color([[32,142,251],[1,173,0]])
  elsif ["Morgan(F)","Morgan(M)"].include?(@data[j][0])
    pic="https://orig00.deviantart.net/97f6/f/2018/068/a/c/morgan_by_rot8erconex-dc5drdn.png"
    name="Morgan"
    xcolor=avg_color([[32,142,251],[179,36,0]])
  elsif ["Kana(F)","Kana(M)"].include?(@data[j][0])
    name="Kana"
    xcolor=avg_color([[32,142,251],[1,173,0]])
  elsif ["Robin(F)(Fallen)","Robin(M)(Fallen)"].include?(@data[j][0])
    pic="https://orig00.deviantart.net/33ea/f/2018/104/2/7/grimleal_by_rot8erconex-dc8svax.png"
    name="Grima: Robin(Fallen)"
    xcolor=avg_color([[1,173,0],[222,95,9]])
  elsif ["Corrin(F)","Corrin(M)"].include?(@data[j][0])
    pic="https://orig00.deviantart.net/d8ce/f/2018/051/1/a/corrin_by_rot8erconex-dc3tj34.png"
    name="Corrin"
    xcolor=avg_color([[179,36,0],[32,142,251]])
  elsif "Tiki(Adult)"==@data[j][0] && !args.join('').downcase.gsub('games','gmes').include?('a')
    pic="https://orig00.deviantart.net/6c50/f/2018/051/9/e/tiki_by_rot8erconex-dc3tkzq.png"
    name="Tiki"
    rx=@data[find_unit("Tiki(Young)",event)][21].reject{|q| q[0,3]=="(a)"}
    ax=@data[find_unit("Tiki(Young)",event)][21].reject{|q| q[0,3]!="(a)"}.map{|q| q[3,q.length-3]}
    x=get_games_list(rx)
    xa=get_games_list(ax,false)
    g2="#{x[0]}\n#{g2}"
    x[0]=nil
    x.compact!
    for i in 0...g.length
      x.push(g[i])
    end
    for i in 0...ga.length
      xa.push(ga[i])
    end
    g=x.uniq
    ga=xa.uniq
  end
  ga=ga.reject{|q| q.downcase=="no games"}
  create_embed(event,"__#{"Mathoo's " if mu}**#{name}**__","#{"**Credit in FEH**\n" unless g2=="No games"}#{g2}#{"\n\n**Other games**\n#{g.join("\n")}" unless g.length<1}#{"\n\n**#{"Male a" if ["Robin(F)","Robin(M)"].include?(@data[j][0])}#{"A" unless ["Robin(F)","Robin(M)"].include?(@data[j][0])}lso appears via Amiibo functionality in**\n#{ga.join("\n")}" unless ga.length<1}",xcolor,nil,pic)
end

bot.command([:bst, :BST]) do |event, *args|
  event.channel.send_temporary_message("Calculating data, please wait...",8)
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
  counters=[["Infantry",0,0],["Horse",0,0],["Armor",0,0],["Flier",0,0],                              # Movement Emblem
            ["Magic",0,0],["Dragon",0,0],["Melee",0,0],["Healer",0,0],["Dagger",0,0],["Archer",0,0], # Weapon Emblem
            ["Red",0,0],["Blue",0,0],["Green",0,0],["Colorless",0,0],                                # Color Emblem
            [["","F2P","F2P"],0,0],["Story",0,0],["GHB",0,0],["Tempest",0,0],                        # Game Mode Emblem
            ["Yandere",0,0],
            ["Lucina",0,0],["Robin",0,0],["Corrin",0,0],["Xander",0,0],["Tiki",0,0],["Lyn",0,0],["Chrom",0,0],["Azura",0,0],["Camilla",0,0],
            ["Ike",0,0],["Roy",0,0],["Hector",0,0],["Celica",0,0],["Takumi",0,0],["Ephraim",0,0]]    # Character emblems
  colors=[[],[0,0,0,0,0],[0,0,0,0,0]]
  braves=[[],[0,0],[0,0]]
  m=false
  for i in 0...k.length
    x=detect_dual_unit_alias(k[i],k[i],1)
    name=nil
    if k[i].downcase=="mathoo's"
      m=true
    elsif !x.nil? && x[1].is_a?(Array) && x[1].length>1
      if (i>0 && !detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]}}",1).nil?) || (i<k.length-1 && !detect_dual_unit_alias(k[i],"#{k[i]} #{k[i+1]}}",1).nil?) || (i>0 && i<k.length-1 && !detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}}",1).nil?)
        if i>0 && i<k.length-1 && !detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}}",1).nil?
          x=detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]} #{k[i+1]}",1)
        elsif i>0 && !detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]}}",1).nil?
          x=detect_dual_unit_alias(k[i],"#{k[i-1]} #{k[i]}}",1)
        elsif i<k.length-1 && !detect_dual_unit_alias(k[i],"#{k[i]} #{k[i+1]}}",1).nil?
          x=detect_dual_unit_alias(k[i],"#{k[i]} #{k[i+1]}",1)
        end
        if x[1].is_a?(Array) && x[1].length>1
          au+=1
          event << "Ambiguous Unit #{au}: #{x[0]} - #{list_lift(x[1],'or')}"
        else
          name=@data[find_unit(find_name_in_string(event,x[1][0]),event)][0]
          summon_type=@data[find_unit(find_name_in_string(event,x[1][0]),event)][19].downcase
        end
      else
        au+=1
        event << "Ambiguous Unit #{au}: #{x[0]} - #{list_lift(x[1],'or')}"
      end
    elsif find_name_in_string(event,sever(k[i]))!=nil
      name=@data[find_unit(find_name_in_string(event,sever(k[i])),event)][0]
      summon_type=@data[find_unit(find_name_in_string(event,sever(k[i])),event)][19].downcase
    elsif !x.nil? && !x[1].is_a?(Array)
      name=@data[find_unit(find_name_in_string(event,x[1]),event)][0]
      summon_type=@data[find_unit(find_name_in_string(event,x[1]),event)][19].downcase
    elsif x.nil?
      if i>1 && !detect_dual_unit_alias(k[i-2],"#{k[i-2]} #{k[i-1]} #{k[i]}",1).nil?
      elsif i>0 && !detect_dual_unit_alias(k[i-1],"#{k[i-1]} #{k[i]}",1).nil?
      elsif i<k.length-2 && !detect_dual_unit_alias(k[i+2],"#{k[i]} #{k[i+1]} #{k[i+2]}",1).nil?
      elsif i<k.length-1 && !detect_dual_unit_alias(k[i+1],"#{k[i]} #{k[i+1]}",1).nil?
      else
        n+=1
        event << "Nonsense term #{n}: #{k[i]}"
      end
    end
    if !name.nil?
      u+=1
      r=find_stats_in_string(event,sever(k[i]))
      j=@data[find_unit(name,event)]
      for i2 in 1...3
        if i<4*i2
          counters[0][i2]+=1 if j[3]=="Infantry"
          counters[1][i2]+=1 if j[3]=="Cavalry"
          counters[2][i2]+=1 if j[3]=="Armor"
          counters[3][i2]+=1 if j[3]=="Flier"
          counters[4][i2]+=1 if j[1][1]=="Tome"
          counters[5][i2]+=1 if j[1][1]=="Dragon"
          counters[6][i2]+=1 if j[1][1]=="Blade"
          counters[7][i2]+=1 if j[1][1]=="Healer"
          counters[8][i2]+=1 if j[1][1]=="Dagger"
          counters[9][i2]+=1 if j[1][1]=="Bow"
          counters[10][i2]+=1 if j[1][0]=="Red"
          counters[11][i2]+=1 if j[1][0]=="Blue"
          counters[12][i2]+=1 if j[1][0]=="Green"
          counters[13][i2]+=1 if j[1][0]=="Colorless"
          if ['',' '].include?(r[2]) && ['',' '].include?(r[3])
            counters[14][i2]+=1 if summon_type.include?("y") || summon_type.include?("g") || summon_type.include?("t") || summon_type.include?("d") || summon_type.include?("f")
            braves[i2][0]+=1 if ["Ike(Brave)","Lucina(Brave)","Lyn(Brave)","Roy(Brave)"].include?(name)
            braves[i2][1]+=1 if ["Celica(Brave)","Ephraim(Brave)","Hector(Brave)","Veronica(Brave)"].include?(name)
          end
          counters[15][i2]+=1 if [summon_type].include?("y")
          counters[16][i2]+=1 if [summon_type].include?("g")
          counters[17][i2]+=1 if [summon_type].include?("t")
          counters[18][i2]+=1 if ["Valter","Tharja","Rhajat","Camilla","Faye","Tharja(Winter)"].include?(name)
          counters[19][i2]+=1 if ["Lucina","Lucina(Spring)","Lucina(Brave)","Marth(Masked)"].include?(name)
          counters[20][i2]+=1 if ["Robin(M)","Robin(M)(Winter)","Robin(F)","Robin(F)(Summer)","Tobin","Robin(M)(Fallen)","Robin(F)(Fallen)"].include?(name)
          counters[21][i2]+=1 if ["Corrin(M)","Corrin(F)","Corrin(F)(Summer)","Corrin(M)(Winter)"].include?(name)
          counters[22][i2]+=1 if ["Xander","Xander(Spring)","Xander(Summer)"].include?(name)
          counters[23][i2]+=1 if ["Tiki(Young)","Tiki(Adult)","Tiki(Adult)(Summer)"].include?(name)
          counters[24][i2]+=1 if ["Lyn","Lyn(Bride)","Lyn(Brave)","Lyn(Love)"].include?(name)
          counters[25][i2]+=1 if ["Chrom(Launch)","Chrom(Spring)","Chrom(Winter)","Chrom(Branded)"].include?(name)
          counters[26][i2]+=1 if ["Azura","Azura(Performing)","Azura(Winter)"].include?(name)
          counters[27][i2]+=1 if ["Camilla","Camilla(Spring)","Camilla(Winter)"].include?(name)
          counters[28][i2]+=1 if ["Ike","Ike(Vanguard)","Ike(Brave)"].include?(name)
          counters[29][i2]+=1 if ["Roy","Roy(Love)","Roy(Brave)"].include?(name)
          counters[30][i2]+=1 if ["Hector","Hector(Love)","Hector(Brave)"].include?(name)
          counters[31][i2]+=1 if ["Celica","Celica(Fallen)","Celica(Brave)"].include?(name)
          counters[32][i2]+=1 if ["Takumi","Takumi(Fallen)","Takumi(Winter)"].include?(name)
          counters[33][i2]+=1 if ["Ephraim","Ephraim(Fire)","Ephraim(Brave)"].include?(name)
          colors[i2][0]+=1 if j[1][0]=="Red"
          colors[i2][1]+=1 if j[1][0]=="Blue"
          colors[i2][2]+=1 if j[1][0]=="Green"
          colors[i2][3]+=1 if j[1][0]=="Colorless"
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
      event << "Unit #{u}: #{r[0]}\\* #{name.gsub('Lavatain','Laevatein')} +#{r[1]} #{"(+#{r[2]}, -#{r[3]})" if !['',' '].include?(r[2]) || !['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}     BST: #{b[b.length-1]}"
    end
  end
  if braves[1].max==1
    counters[14][1]+=braves[1][1]+braves[1][0]
    counters[14][0][1]="Pseudo-F2P"
  end
  if braves[2].max==1
    counters[14][2]+=braves[2][1]+braves[2][0]
    counters[14][0][2]="Pseudo-F2P"
  end
  event << ""
  emblem_name=["","",""]
  for i in 0...counters.length
    cname=counters[i][0]
    for i2 in 1...3
      cname=counters[i][0][i2] if i==14 # F2P marker
      if counters[i][i2]>=[[4,k.length].min,2].max
        if emblem_name[i2].length>0 && i>3 && i<10 && emblem_name[i2].split(' ').length<=2
          emblem_name[i2]="#{cname} #{emblem_name[i2]}"
        elsif emblem_name[i2].length>0 && i>9 && i<14 && emblem_name[i2].split(' ').length<=3
          emblem_name[i2]="#{cname} #{emblem_name[i2]}" unless cname=="Colorless" && (emblem_name[i2].include?("Healer") || emblem_name[i2].include?("Dagger") || emblem_name[i2].include?("Archer"))
        else
          emblem_name[i2]="#{cname} Emblem"
        end
      end
    end
  end
  emblem_name[1]=emblem_name[1].gsub("Red Melee",'Sword').gsub("Blue Melee",'Lance').gsub("Green Melee",'Axe')
  emblem_name[2]=emblem_name[2].gsub("Red Melee",'Sword').gsub("Blue Melee",'Lance').gsub("Green Melee",'Axe')
  if b.length<=0
    event << "No units listed"
  else
    for i2 in 1...3
      if colors[i2].max==i2 && b.length>=i2*4
        if emblem_name[i2].length>0
          emblem_name[i2]="Color-balanced #{emblem_name[i2]}"
        else
          emblem_name[i2]="Color-balanced"
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
  if ['skills','skill'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    skill_comparison(event,args)
    return nil
  end
  k=comparison(event,args)
  return nil
end

bot.command([:compareskills,:compareskill,:skillcompare,:skillscompare,:comparisonskills,:comparisonskill,:skillcomparison,:skillscomparison,:compare_skills,:compare_skill,:skill_compare,:skills_compare,:comparison_skills,:comparison_skill,:skill_comparison,:skills_comparison,:skillsincommon,:skills_in_common,:commonskills,:common_skills]) do |event, *args|
  skill_comparison(event,args)
  return nil
end

bot.command(:skill) do |event, *args|
  if ['stat','stats'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  elsif ['and','n','&'].include?(args[0].downcase) && ['stat','stat'].include?(args[1].downcase)
    args[0]=nil
    args[1]=nil
    args.compact!
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  elsif ['compare','comparison'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    skill_comparison(event,args)
    return nil
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load()
  disp_skill(args.join(' '),event)
  return nil
end

bot.command([:skills,:fodder]) do |event, *args|
  s=event.message.text
  s=s[2,s.length-2] if ['f?','e?','h?'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  if s.downcase[0,6]=='skills'
    if ['stat','stats'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      disp_unit_stats_and_skills(event,args,bot)
      return nil
    elsif ['and','n','&'].include?(args[0].downcase) && ['stat','stat'].include?(args[1].downcase)
      args[0]=nil
      args[1]=nil
      args.compact!
      disp_unit_stats_and_skills(event,args,bot)
      return nil
    elsif ['compare','comparison'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      skill_comparison(event,args)
      return nil
    elsif ['learn','learnable','inherit','inheritance','inheritable'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:learnable_skills,event,args,bot,true)
      return nil unless k<0
    end
  end
  k=find_name_in_string(event,nil,1)
  if k.nil?
    if event.message.text.downcase.include?("flora") && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
      event.respond "Steel's waifu is not in the game."
    elsif !detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase)
      disp_unit_skills(bot,x[1],event,true,true,true)
    elsif s.downcase[0,6]=='skills'
      event.respond "No matches found.  If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s."
    else
      event.respond "No matches found.  Please note that the `fodder` command is for listing the skills you can fodder a **unit** for, not the units you need to fodder to get a skill."
    end
    return nil
  end
  str=k[0]
  data_load()
  if str.nil?
  elsif !detect_dual_unit_alias(str.downcase,event.message.text.downcase).nil?
    x=detect_dual_unit_alias(str.downcase,event.message.text.downcase)
    disp_unit_skills(bot,x[1],event,true)
  elsif !detect_dual_unit_alias(str.downcase,str.downcase).nil?
    x=detect_dual_unit_alias(str.downcase,str.downcase)
    disp_unit_skills(bot,x[1],event,true)
  elsif find_unit(str,event)>=0
    disp_unit_skills(bot,str,event)
  elsif event.message.text.downcase.include?("flora") && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
    event.respond "Steel's waifu is not in the game."
  else
    event.respond "No matches found.  If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s."
  end
  return nil
end

bot.command([:stats,:stat]) do |event, *args|
  if ['compare','comparison'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=comparison(event,args)
    return nil unless k<1
  elsif ['study'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    if ['effhp','eff_hp','bulk'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:calculate_effective_HP,event,args,bot)
      return nil unless k<0
    elsif ['heal'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:heal_study,event,args,bot,true)
      return nil unless k<0
    elsif ['proc'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:proc_study,event,args,bot,false)
      return nil unless k<0
    elsif ['phase'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:phase_study,event,args,bot)
      return nil unless k<0
    end
    k=parse_function(:unit_study,event,args,bot)
    return nil unless k<0
  elsif ['effhp','eff_hp','bulk'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:calculate_effective_HP,event,args,bot)
    return nil unless k<0
  elsif ['heal_study','healstudy','studyheal','study_heal'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:heal_study,event,args,bot,true)
    return nil unless k<0
  elsif ['proc_study','procstudy','studyproc','study_proc'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:proc_studyevent,args,bot,false)
    return nil unless k<0
  elsif ['skill','skills'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  elsif ['and','n','&'].include?(args[0].downcase) && ['skill','skills'].include?(args[1].downcase)
    args[0]=nil
    args[1]=nil
    args.compact!
    disp_unit_stats_and_skills(event,args,bot)
    return nil
  end
  event.channel.send_temporary_message("Calculating data, please wait...",event.message.text.length/30-1) if event.message.text.length>90
  k=find_name_in_string(event,nil,1)
  if k.nil?
    w=nil
    if event.message.text.downcase.include?("flora") && ((event.server.nil? && event.user.id==170070293493186561) || !bot.user(170070293493186561).on(event.server.id).nil?)
      event.respond "Steel's waifu is not in the game."
    elsif !detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase).nil?
      x=detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase)
      k2=get_weapon(first_sub(args.join(' '),x[0],''),event)
      w=k2[0] unless k2.nil?
      disp_stats(bot,x[1],w,event,true)
    else
      event.respond "No matches found."
    end
    return nil
  end
  str=k[0]
  k2=get_weapon(first_sub(args.join(' '),k[1],''),event)
  w=nil
  w=k2[0] unless k2.nil?
  data_load()
  if !detect_dual_unit_alias(str.downcase,event.message.text.downcase).nil?
    x=detect_dual_unit_alias(str.downcase,event.message.text.downcase)
    disp_stats(bot,x[1],w,event,true)
  elsif !detect_dual_unit_alias(str.downcase,str.downcase).nil?
    x=detect_dual_unit_alias(str.downcase,str.downcase)
    disp_stats(bot,x[1],w,event,true)
  elsif find_unit(str,event)>=0
    disp_stats(bot,str,w,event)
  else
    event.respond "No matches found"
  end
  return nil
end

bot.command([:unit, :data, :statsskills, :statskills, :stats_skills, :stat_skills, :statsandskills, :statandskills, :stats_and_skills, :stat_and_skills, :statsskill, :statskill, :stats_skill, :stat_skill, :statsandskill, :statandskill, :stats_and_skill, :stat_and_skill]) do |event, *args|
  if ['compare','comparison'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=comparison(event,args)
    return nil unless k<1
  elsif ['study'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    if ['effhp','eff_hp','bulk'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:calculate_effective_HP,event,args,bot)
      return nil unless k<0
    elsif ['heal'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:heal_study,event,args,bot,true)
      return nil unless k<0
    elsif ['proc'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:proc_studyevent,args,bot,false)
      return nil unless k<0
    elsif ['phase'].include?(args[0].downcase)
      args[0]=nil
      args.compact!
      k=parse_function(:phase_study,event,args,bot)
      return nil unless k<0
    end
    k=parse_function(:unit_study,event,args,bot)
    return nil unless k<0
  elsif ['effhp','eff_hp','bulk'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:calculate_effective_HP,event,args,bot)
    return nil unless k<0
  elsif ['heal_study','healstudy','studyheal','study_heal'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:heal_study,event,args,bot,true)
    return nil unless k<0
  elsif ['proc_study','procstudy','studyproc','study_proc'].include?(args[0].downcase)
    args[0]=nil
    args.compact!
    k=parse_function(:proc_studyevent,args,bot,false)
    return nil unless k<0
  end
  disp_unit_stats_and_skills(event,args,bot)
end

bot.command([:flowers,:flower]) do |event|
  event.respond "http://dailyflower.yakohl.com/pop15.php?pid=#{rand(3430)+1}"
end

bot.command(:addalias) do |event, newname, unit, modifier, modifier2|
  data_load()
  nicknames_load()
  if newname.nil? || unit.nil?
    event.respond "You must specify both a new alias and a unit to give the alias to."
    return nil
  elsif event.user.id != 167657750971547648 && event.server.nil?
    event.respond "Only my developer is allowed to use this command in PM."
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond "You are not a mod."
    return nil
  elsif newname.include?('"') || newname.include?("\n")
    event.respond "Full stop.  \" is not allowed in an alias."
    return nil
  elsif find_unit(newname,event)>=0
    if find_unit(unit,event)>=0
      event.respond "Someone already has the name #{newname}"
      return nil
    elsif event.user.id==167657750971547648 && !modifier.nil?
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
  srvname="PM with dev"
  srvname=bot.server(srv).name unless event.server.nil? && srv==0
  checkstr=normalize(newname)
  k=event.message.emoji
  for i in 0...k.length
    checkstr=checkstr.gsub("<:#{k[i].name}:#{k[i].id}>",k[i].name)
  end
  if find_skill(checkstr,event,false,true)>=0
    event.respond "#{newname} has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases.\nThat is the name of a skill, and I do not want confusion when people in this server attempt `FEH!#{newname}`"
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** #{newname} is a skill name.")
    return nil
  elsif @data[find_unit(unit,event)][0]=="Odin" && checkstr.downcase.include?("owain")
    event.respond "#{newname} has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases.\nYes, the two are the same character, but eventually Swordmaster Owain will join the game, and this alias will conflict."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif @data[find_unit(unit,event)][0]=="Laslow" && checkstr.downcase.include?("inigo")
    event.respond "#{newname} has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases.\nYes, the two are the same character, but eventually Inigo will join the game, and this alias will conflict."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif @data[find_unit(unit,event)][0]=="Selena" && checkstr.downcase.include?("severa")
    event.respond "#{newname} has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases.\nYes, the two are the same character, but eventually Severa will join the game, and this alias will conflict."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif @data[find_unit(unit,event)][0]=="Charlotte(Bride)" && checkstr.downcase.include?("charlotte")
    event.respond "#{newname} has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases.\nYes, she is Charlotte, but eventually, she will join the game as a non-seaonal unit."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif (@data[find_unit(unit,event)][0]=="Shigure(Performing)" && checkstr.downcase.include?("shigure")) ||
        (@data[find_unit(unit,event)][0]=="Inigo(Performing)" && checkstr.downcase.include?("inigo"))
    event.respond "#{newname} has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases.\nYes, he is #{@data[find_unit(unit,event)][0].gsub('(performing)','')}, but eventually, he will join the game as a non-seaonal unit."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Pre-emptive confusion prevention.")
    return nil
  elsif !detect_dual_unit_alias(checkstr.downcase,checkstr.downcase,2).nil?
    event.respond "#{newname} has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases.\nThis is a multi-unit alias."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Confusion prevention.")
    return nil
  elsif checkstr.downcase =~ /(7|t)+?h+?(o|0)+?(7|t)+?/
    event.respond "That name has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  elsif checkstr.downcase =~ /n+?(i|1)+?(b|g|8)+?(a|4|(e|3)+?r+?)+?/
    event.respond "That name has __***NOT***__ been added to #{@data[find_unit(unit,event)][0]}'s aliases."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** >Censored< for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  end
  newname=normalize(newname)
  m=nil
  m=[event.server.id] unless event.server.nil?
  srv=0
  srv=event.server.id unless event.server.nil?
  srv=modifier.to_i if event.user.id==167657750971547648 && modifier.to_i.to_s==modifier
  srvname="PM with dev"
  srvname=bot.server(srv).name unless event.server.nil? && srv==0
  if event.user.id==167657750971547648 && modifier.to_i.to_s==modifier
    m=[modifier.to_i]
    modifier=nil
  end
  chn=event.channel.id
  chn=modifier2.to_i if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
  m=nil if event.user.id==167657750971547648 && !modifier.nil?
  unit=@data[find_unit(unit,event)][0]
  double=false
  for i in 0...@names.length
    if @names[i][2].nil?
    elsif @names[i][0].downcase==newname.downcase && @names[i][1].downcase==unit.downcase
      if event.user.id==167657750971547648 && !modifier.nil?
        @names[i][2]=nil
        @names[i].compact!
        bot.channel(chn).send_message("The alias #{newname} for #{unit} exists in a server already.  Making it global now.")
        event.respond "The alias #{newname} for #{unit} exists in a server already.  Making it global now.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        bot.channel(logchn).send_message("#{newname} for #{unit} has gone global.  #{event.channel.id}")
        double=true
      else
        @names[i][2].push(srv)
        bot.channel(chn).send_message("The alias #{newname} exists in another server already.  Adding this server to those that can use it.")
        event.respond "The alias #{newname} exists in another server already.  Adding this server to those that can use it.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        bot.user(167657750971547648).pm("The alias **#{@names[i][0]}** for the character **#{@names[i][1]}** is used in quite a few servers.  It might be time to make this global") if @names[i][2].length >= bot.servers.length / 20 && @names[i][3].nil?
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit} - gained a new server that supports it.")
        double=true
      end
    end
  end
  unless double
    @names.push([newname,unit,m].compact)
    @names.sort! {|a,b| (a[1].downcase <=> b[1].downcase) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].downcase <=> b[1].downcase)}
    bot.channel(chn).send_message("#{newname} has been added to #{unit}'s aliases#{" globally" if event.user.id==167657750971547648 && !modifier.nil?}.\nPlease test to be sure that the alias stuck.")
    event.respond "#{newname} has been added to #{unit}'s aliases#{" globally" if event.user.id==167657750971547648 && !modifier.nil?}." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**Alias:** #{newname} for #{unit}")
  end
  @names.uniq!
  nzzz=@names.map{|a| a}
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...nzzz.length
      f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
    end
  }
  nicknames_load()
  nzzz=@names.map{|a| a}
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

bot.command([:checkaliases,:aliases,:seealiases]) do |event, *args|
  event.channel.send_temporary_message("Calculating data, please wait...",2)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load()
  nicknames_load()
  unless args.length==0
    unit=@data[find_unit(args.join(''),event)][0]
    if !detect_dual_unit_alias(args.join(''),event.message.text.downcase,1).nil?
      x=detect_dual_unit_alias(args.join(''),event.message.text.downcase,1)
      unit=x[1]
    elsif find_unit(args.join(''),event)==-1
      event.respond "#{args.join(' ')} is not a unit name or an alias."
      return nil
    end
  end
  unless unit.nil? || unit.is_a?(Array)
    unit=nil if find_unit(unit,event)<0
  end
  f=[]
  n=@names.map{|a| a}
  if unit.nil?
    if event.server.nil? || event.channel.id == 283821884800499714 || @shardizard==4
      for i in 0...n.length
        if n[i][2].nil?
          f.push("#{n[i][0].gsub('_','\_')} = #{n[i][1].gsub('_','\_')}")
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0].gsub('_','\_')} = #{n[i][1].gsub('_','\_')} (in the following servers: #{list_lift(a,"and")})") if a.length>0
        end
      end
    else
      event.respond "Please either specify a unit name or use this command in PM."
      return nil
    end
  else
    k=0
    k=event.server.id unless event.server.nil?
    unit=[unit] unless unit.is_a?(Array)
    for i1 in 0...unit.length
      u=@data[find_unit(unit[i1],event)][0]
      f.push("**#{u.gsub('_','\\_')}**")
      f.push(u.gsub('_','\\_').gsub('(','').gsub(')','')) if u.include?('(') || u.include?(')')
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
            f.push("#{n[i][0].gsub('_','\\_')} (in the following servers: #{list_lift(a,"and")})") if a.length>0
          elsif n[i][2].nil?
            f.push(n[i][0].gsub('_','\\_'))
          else
            f.push("#{n[i][0].gsub('_','\\_')} (in this server only)") if n[i][2].include?(k)
          end
        end
      end
      f.push("")
    end
  end
  f.uniq!
  if f.length>50 && !event.server.nil? && event.channel.id != 283821884800499714 && @shardizard != 4
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

bot.command([:deletealias,:removealias]) do |event, name|
  nicknames_load()
  if name.nil?
    event.respond "I can't delete nothing, silly!" if name.nil?
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond "You are not a mod."
    return nil
  elsif find_unit(name,event)<0
    event.respond "#{name} is not anyone's alias, silly!"
    return nil
  end
  j=find_unit(name,event)
  k=0
  k=event.server.id unless event.server.nil?
  for izzz in 0...@names.length
    if @names[izzz][0].downcase==name.downcase
      if @names[izzz][2].nil? && event.user.id != 167657750971547648
        event.respond "You cannot remove a global alias"
        return nil
      elsif @names[izzz][2].nil? || @names[izzz][2].include?(k)
        unless @names[izzz][2].nil?
          for izzz2 in 0...@names[izzz][2].length
            @names[izzz][2][izzz2]=nil if @names[izzz][2][izzz2]==k
          end
          @names[izzz][2].compact!
        end
        @names[izzz]=nil if @names[izzz][2].nil? || @names[izzz][2].length<=0
      end
    end
  end
  @names.uniq!
  @names.compact!
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...@names.length
      f.puts "#{@names[i].to_s}#{"\n" if i<@names.length-1}"
    end
  }
  event.respond "#{name} has been removed from #{@data[j][0]}'s aliases."
end

bot.command(:addgroup) do |event, groupname, *args|
  groups_load()
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  if groupname.nil?
    event.respond "I can't add a group with no name, silly!"
    return nil
  elsif args.nil? || args.length<=0
    event << "I can't add a group with no members, silly!"
    event << "...well, actually, I could, but what would be the point?"
    return nil
  elsif event.server.nil? && event.user.id != 167657750971547648
    event.respond "Only my developer is allowed to use this command in PM."
    return nil
  elsif ["dancers","singers","ghb","tempest","daily_rotation","falchionusers","mathoo'swaifus","legendary","legendaries","legends","retro-prfs"].include?(groupname.downcase)
    event.respond "This group is dynamic, automatically updating when a new unit that fits the criteria appears."
    return nil
  elsif ![167657750971547648,208905989619974144,168592191189417984].include?(event.user.id) && !is_mod?(event.user,event.server,event.channel)
    event.respond "You do not have the privileges to use this command."
    return nil
  elsif find_group(groupname,event)>-1 && @groups[find_group(groupname,event)][2].nil? && event.user.id != 167657750971547648
    event.respond "You do not have the privileges to edit this global group."
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
    if find_unit(args[i].downcase,event)<0
      args[i]=nil
    else
      args[i]=@data[find_unit(args[i].downcase,event)][0]
    end
  end
  args.compact!
  newgroup=false
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  k=0
  k=event.server.id unless event.server.nil?
  srvname="PM with dev"
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
    event.respond "A new #{"global " if event.message.text.downcase.include?(' global ')}group **#{groupname}** has been created with the members #{args.join(', ')}"
  else
    event.respond "The existing #{"global " if event.message.text.downcase.include?(' global ')}group **#{groupname}** has been updated to include the members #{args.join(', ')}"
  end
  groups_load()
  nzzz=@groups.map{|a| a}
  if nzzz[nzzz.length-1].length>0 && nzzz[nzzz.length-1][0]>="Tempest"
    bot.channel(logchn).send_message("Group list saved.")
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups2.txt', 'w') { |f|
      for i in 0...nzzz.length
        f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
      end
    }
    bot.channel(logchn).send_message("Group list has been backed up.")
  end
  return nil
end

bot.command([:seegroups,:checkgroups,:groups]) do |event|
  groups_load()
  k=0
  k=event.server.id unless event.server.nil?
  msg=""
  for i in 0...@groups.length
    if @groups[i][0].downcase=="dancers"
      msg=extend_message(msg,"**Dancers/Singers**\n#{get_group("Dancer",event)[1].sort.join(', ')}",event,2)
    elsif @groups[i][0].downcase=="singers"
    elsif @groups[i][2].nil?
      if @groups[i][1].length<=0
        msg=extend_message(msg,"**#{@groups[i][0]}**\n#{get_group(@groups[i][0],event)[1].sort.join(', ')}",event,2) if event.user.id==167657750971547648 || @groups[i][0].downcase != "mathoo'swaifus"
      else
        msg=extend_message(msg,"**#{@groups[i][0]}**\n#{@groups[i][1].sort.join(', ')}",event,2) if event.user.id==167657750971547648 || @groups[i][0].downcase != "mathoo'swaifus"
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
  groups_load()
  if event.server.nil? && event.user.id != 167657750971547648
    event.respond "Only my developer is allowed to use this command in PM."
    return nil
  elsif find_group(name.downcase,event)<0
    event.respond "The group #{name} doesn't even exist in the first place, silly!"
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond "You do not have the privileges to use this command."
    return nil
  elsif find_group(groupname,event)>-1 && @groups[find_group(groupname,event)][2].nil? && event.user.id != 167657750971547648
    event.respond "You do not have the privileges to edit this global group."
    return nil
  end
  j=find_group(name.downcase,event)
  if ["dancers","singers","ghb","tempest","daily_rotation","falchionusers","mathoo'swaifus","legendary","legendaries","legends","retro-prfs"].include?(@groups[j][0].downcase)
    event.respond "This group is dynamic, automatically updating when a new unit that fits the criteria appears."
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
  @groups.compact!
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt', 'w') { |f|
    for i in 0...@groups.length
      f.puts "#{@groups[i].to_s}#{"\n" if i<@groups.length-1}"
    end
  }
  event.respond "The group #{name} has been deleted."
end

bot.command([:removemember,:removefromgroup]) do |event, group, unit|
  data_load()
  groups_load()
  if event.server.nil? && event.user.id != 167657750971547648
    event.respond "Only my developer is allowed to use this command in PM."
    return nil
  elsif unit.nil? || group.nil?
    event.respond "You must list a group and a unit to remove from it."
    return nil
  elsif find_group(group.downcase,event)<0 || find_unit(unit.downcase,event)<0
    event << "The group #{group} doesn't even exist in the first place, silly!" if find_group(group.downcase)<0
    event << "The unit #{unit} doesn't even exist in the first place, silly!" if find_unit(unit.downcase)<0
    return nil
  elsif ![167657750971547648,208905989619974144,168592191189417984].include?(event.user.id) && !is_mod?(event.user,event.server,event.channel)
    event.respond "You do not have the privileges to use this command."
    return nil
  elsif find_group(groupname,event)>-1 && @groups[find_group(groupname,event)][2].nil? && event.user.id != 167657750971547648
    event.respond "You do not have the privileges to edit this global group."
    return nil
  end
  j=find_group(group.downcase,event)
  if ["dancers","singers","ghb","tempest","daily_rotation","falchionusers","mathoo'swaifus","legendary","legendaries","legends","retro-prfs"].include?(@groups[j][0].downcase)
    event.respond "This group is dynamic, automatically updating when a new unit that fits the criteria appears."
    return nil
  end
  i=find_unit(unit.downcase,event)
  r=false
  for k in 0...@groups[j][1].length
    if @groups[j][1][k].downcase==@data[i][0].downcase
      @groups[j][1][k]=nil
      r=true
    end
  end
  @groups[j][1].compact!
  event << "#{@data[i][0]} has been removed from the group #{@groups[j][0]}" if r
  if @groups[j][1].length<=0
    event << "The group #{@groups[j][0]} now has 0 members, so I'm deleting it." if r
    @groups[j]=nil
    @groups.compact!
  end
  event << "#{@data[i][0]} wasn't even in the group #{@groups[j][0]}, silly!" unless r
  return nil
end

bot.command([:find,:search]) do |event, *args|
  event.channel.send_temporary_message("Calculating data, please wait...",5)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  metadata_load()
  mode=1
  mode=0 if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
  if args.nil? || args.length.zero?
    p1=find_in_units(event,mode,true)
    p2=find_in_skills(event,mode,true,p1)
    if !p1.is_a?(Array) && !p2.is_a?(Array)
      event.respond "Your request is gibberish."
    elsif !p1.is_a?(Array)
      display_skills(event, mode)
    elsif !p2.is_a?(Array)
      display_units(event, mode)
    else
      event.respond "I'm not displaying all units *and* all skills!"
    end
  elsif ['unit','char','character','person','units','chars','charas','chara','people'].include?(args[0].downcase)
    display_units(event, mode)
  elsif ['skill','skills'].include?(args[0].downcase)
    display_skills(event, mode)
  else
    p1=find_in_units(event,mode,true)
    p1=p1.map{|q| "#{"~~" if !["Laevatein","- - -"].include?(q) && !@data[find_unit(q,event,false,true)][22].nil?}#{q}#{"~~" if !["Laevatein","- - -"].include?(q) && !@data[find_unit(q,event,false,true)][22].nil?}"}
    p2=find_in_skills(event,mode,true,p1)
    p2=p2.map{|q| "#{"~~" if !["Laevatein","- - -"].include?(q) && !@skills[find_skill(stat_buffs(q.gsub('(+)','+').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','')),event,false,true)][21].nil?}#{q}#{"~~" if !["Laevatein","- - -"].include?(q) && !@skills[find_skill(stat_buffs(q.gsub('(+)','+').gsub('/2','').gsub('/3','').gsub('/4','').gsub('/5','').gsub('/6','').gsub('/7','').gsub('/8','').gsub('/9','')),event,false,true)][21].nil?}"}
    if !p1.is_a?(Array) && !p2.is_a?(Array)
      event.respond "Your request is gibberish."
    elsif !p1.is_a?(Array)
      display_skills(event, mode)
    elsif !p2.is_a?(Array)
      display_units(event, mode)
    elsif p1.join("\n").length+p2.join("\n").length<=1900
      create_embed(event,"Results",'',0x9400D3,nil,nil,[['**Units**',p1.join("\n")],['**Skills**',p2.join("\n")]],2)
    elsif !event.server.nil? && event.channel.id != 283821884800499714 && @shardizard != 4
      event.respond "My response would be so long that I would prefer you ask me in PM."
    else
      t="**Units:** #{p1[0]}"
      if p1.length>1
        for i in 1...p1.length
          if "#{t}\n#{p1[i]}".length>=2000
            event.respond t
            t=p1[i]
          else
            t="#{t}\n#{p1[i]}"
          end
        end
      end
      event.respond t
      t="**Skills:** #{p2[0]}"
      if p2.length>1
        for i in 1...p2.length
          if "#{t}\n#{p2[i]}".length>=2000
            event.respond t
            t=p2[i]
          else
            t="#{t}\n#{p2[i]}"
          end
        end
      end
      event.respond t
    end
  end
  return nil
end

bot.command([:sort,:list]) do |event, *args|
  if args.nil? || args[0].nil?
  elsif (event.user.id==167657750971547648 || event.channel.id==386658080257212417) && ['group','groups'].include?(args[0].downcase)
    data_load()
    groups_load()
    @groups.uniq!
    @groups.sort! {|a,b| (a[0].downcase <=> b[0].downcase) == 0 ? (a[2][0] <=> b[2][0]) : (a[0].downcase <=> b[0].downcase)}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
      for i in 0...@names.length
        f.puts "#{@names[i].to_s}#{"\n" if i<@names.length-1}"
      end
    }
    event.respond "The groups list has been sorted alphabetically"
    return nil
  elsif (event.user.id==167657750971547648 || event.channel.id==386658080257212417) && ['alias','aliases'].include?(args[0].downcase)
    data_load()
    nicknames_load()
    @names.uniq!
    @names.sort! {|a,b| (a[1].downcase <=> b[1].downcase) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].downcase <=> b[1].downcase)}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
      for i in 0...@names.length
        f.puts "#{@names[i].to_s}#{"\n" if i<@names.length-1}"
      end
    }
    event.respond "The alias list has been sorted alphabetically"
    return nil
  end
  event.channel.send_temporary_message("Calculating data, please wait...",10)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  f=[0,0,0,0,0,0,0,0]
  for i in 0...args.length # find stat names, retain the order in which they're listed.
    if f[0]==0
      f[0]=9 if ["hp","health"].include?(args[i].downcase)
      f[0]=10 if ["str","strength","strong","mag","magic","atk","att","attack"].include?(args[i].downcase)
      f[0]=11 if ["spd","speed"].include?(args[i].downcase)
      f[0]=12 if ["def","defense","defence","defensive","defencive"].include?(args[i].downcase)
      f[0]=13 if ["res","resistance"].include?(args[i].downcase)
      f[0]=14 if ["bst","base","total"].include?(args[i].downcase)
      f[0]=15 if ["chill","frostbite","freeze","cold","frz","frzprotect","lower","lowerdefres","lowerdefenseresistance","lowerdef"].include?(args[i].downcase)
    elsif f[1]==0
      f[1]=9 if ["hp","health"].include?(args[i].downcase) && !f.include?(9)
      f[1]=10 if ["str","strength","strong","mag","magic","atk","att","attack"].include?(args[i].downcase) && !f.include?(10)
      f[1]=11 if ["spd","speed"].include?(args[i].downcase) && !f.include?(11)
      f[1]=12 if ["def","defense","defence","defensive","defencive"].include?(args[i].downcase) && !f.include?(12)
      f[1]=13 if ["res","resistance"].include?(args[i].downcase) && !f.include?(13)
      f[1]=14 if ["bst","base","total"].include?(args[i].downcase) && !f.include?(14)
      f[1]=15 if ["chill","frostbite","freeze","cold","frz","frzprotect","lower","lowerdefres","lowerdefenseresistance","lowerdef"].include?(args[i].downcase) && !f.include?(15)
    elsif f[2]==0
      f[2]=9 if ["hp","health"].include?(args[i].downcase) && !f.include?(9)
      f[2]=10 if ["str","strength","strong","mag","magic","atk","att","attack"].include?(args[i].downcase) && !f.include?(10)
      f[2]=11 if ["spd","speed"].include?(args[i].downcase) && !f.include?(11)
      f[2]=12 if ["def","defense","defence","defensive","defencive"].include?(args[i].downcase) && !f.include?(12)
      f[2]=13 if ["res","resistance"].include?(args[i].downcase) && !f.include?(13)
      f[2]=14 if ["bst","base","total"].include?(args[i].downcase) && !f.include?(14)
      f[2]=15 if ["chill","frostbite","freeze","cold","frz","frzprotect","lower","lowerdefres","lowerdefenseresistance","lowerdef"].include?(args[i].downcase) && !f.include?(15)
    elsif f[3]==0
      f[3]=9 if ["hp","health"].include?(args[i].downcase) && !f.include?(9)
      f[3]=10 if ["str","strength","strong","mag","magic","atk","att","attack"].include?(args[i].downcase) && !f.include?(10)
      f[3]=11 if ["spd","speed"].include?(args[i].downcase) && !f.include?(11)
      f[3]=12 if ["def","defense","defence","defensive","defencive"].include?(args[i].downcase) && !f.include?(12)
      f[3]=13 if ["res","resistance"].include?(args[i].downcase) && !f.include?(13)
      f[3]=14 if ["bst","base","total"].include?(args[i].downcase) && !f.include?(14)
      f[3]=15 if ["chill","frostbite","freeze","cold","frz","frzprotect","lower","lowerdefres","lowerdefenseresistance","lowerdef"].include?(args[i].downcase) && !f.include?(15)
    elsif f[4]==0
      f[4]=9 if ["hp","health"].include?(args[i].downcase) && !f.include?(9)
      f[4]=10 if ["str","strength","strong","mag","magic","atk","att","attack"].include?(args[i].downcase) && !f.include?(10)
      f[4]=11 if ["spd","speed"].include?(args[i].downcase) && !f.include?(11)
      f[4]=12 if ["def","defense","defence","defensive","defencive"].include?(args[i].downcase) && !f.include?(12)
      f[4]=13 if ["res","resistance"].include?(args[i].downcase) && !f.include?(13)
      f[4]=14 if ["bst","base","total"].include?(args[i].downcase) && !f.include?(14)
      f[4]=15 if ["chill","frostbite","freeze","cold","frz","frzprotect","lower","lowerdefres","lowerdefenseresistance","lowerdef"].include?(args[i].downcase) && !f.include?(15)
    elsif f[5]==0
      f[5]=9 if ["hp","health"].include?(args[i].downcase) && !f.include?(9)
      f[5]=10 if ["str","strength","strong","mag","magic","atk","att","attack"].include?(args[i].downcase) && !f.include?(10)
      f[5]=11 if ["spd","speed"].include?(args[i].downcase) && !f.include?(11)
      f[5]=12 if ["def","defense","defence","defensive","defencive"].include?(args[i].downcase) && !f.include?(12)
      f[5]=13 if ["res","resistance"].include?(args[i].downcase) && !f.include?(13)
      f[5]=14 if ["bst","base","total"].include?(args[i].downcase) && !f.include?(14)
      f[5]=15 if ["chill","frostbite","freeze","cold","frz","frzprotect","lower","lowerdefres","lowerdefenseresistance","lowerdef"].include?(args[i].downcase) && !f.include?(15)
    elsif f[6]==0
      f[6]=9 if ["hp","health"].include?(args[i].downcase) && !f.include?(9)
      f[6]=10 if ["str","strength","strong","mag","magic","atk","att","attack"].include?(args[i].downcase) && !f.include?(10)
      f[6]=11 if ["spd","speed"].include?(args[i].downcase) && !f.include?(11)
      f[6]=12 if ["def","defense","defence","defensive","defencive"].include?(args[i].downcase) && !f.include?(12)
      f[6]=13 if ["res","resistance"].include?(args[i].downcase) && !f.include?(13)
      f[6]=14 if ["bst","base","total"].include?(args[i].downcase) && !f.include?(14)
      f[6]=15 if ["chill","frostbite","freeze","cold","frz","frzprotect","lower","lowerdefres","lowerdefenseresistance","lowerdef"].include?(args[i].downcase) && !f.include?(15)
    end
  end
  for i in 0...args.length
    args[i]=args[i].downcase
  end
  if args.include?('stats')
    f.push(9) unless f.include?(9)
    f.push(10) unless f.include?(10)
    f.push(11) unless f.include?(11)
    f.push(12) unless f.include?(12)
    f.push(13) unless f.include?(13)
  end
  k2=find_in_units(event,2,false,true) # Narrow the list of units down based on the defined parameters
  event.channel.send_temporary_message("Units found, sorting now...",3)
  k=k2.reject{|q| find_unit(q[0],event)<0} if k2.is_a?(Array)
  k=@data.reject{|q| find_unit(q[0],event)<0}.sort{|a,b| a[0]<=>b[0]} unless k2.is_a?(Array)
  for i in 0...k.length # remove any units who don't have known stats yet
    k[i]=nil if k[i][9].nil? || k[i][9]==0
  end
  s=['','','','','','','','','','HP','Attack','Speed','Defense','Resistance','BST','FrzProtect']
  k.compact!
  k=k.reject {|q| find_unit(q[0],event)<0}
  if f.include?(14) || f.include?(15)
    for i in 0...k.length
      k[i][14]=k[i][9]+k[i][10]+k[i][11]+k[i][12]+k[i][13] if f.include?(14)
      k[i][15]=[k[i][12],k[i][13]].min if f.include?(15)
    end
  end
  t=0
  b=0
  for i in 0...args.length
    if args[i].downcase[0,3]=='top' && t==0
      t=[args[i][3,args[i].length-3].to_i,k.length].min
    elsif args[i].downcase[0,6]=='bottom' && b==0
      b=[args[i][6,args[i].length-6].to_i,k.length].min
    end
  end
  k=k.reject{|q| !q[22].nil?} if t>0 || b>0
  k.sort! {|b,a| (supersort(a,b,f[0])) == 0 ? ((supersort(a,b,f[1])) == 0 ? ((supersort(a,b,f[2])) == 0 ? ((supersort(a,b,f[3])) == 0 ? ((supersort(a,b,f[4])) == 0 ? ((supersort(a,b,f[5])) == 0 ? ((supersort(a,b,f[6])) == 0 ? (supersort(a,b,0)) : (supersort(a,b,f[6]))) : (supersort(a,b,f[5]))) : (supersort(a,b,f[4]))) : (supersort(a,b,f[3]))) : (supersort(a,b,f[2]))) : (supersort(a,b,f[1]))) : (supersort(a,b,f[0]))}
  m="Please note that the stats listed are for neutral-nature units without stat-affecting skills.\n"
  if f.include?(10)
    m="#{m}The Strength/Magic stat also does not account for weapon might.\n"
  end
  display=[0,k.length]
  if t>0
    display=[0,t]
  elsif b>0
    display=[k.length-b,k.length]
  end
  if event.server.nil? || event.channel.id==283821884800499714 || @shardizard==4
  elsif k2==-1 && display[0]==0 && display[1]==k.length
    event.respond "Sorry, but you must specify filters.  I will not sort the entire roster as that would be spam.\nInstead, have the stats of the character whose name in Japanese means \"sort\"."
    disp_stats(bot,"Stahl",nil,event,true)
    return false
  elsif !k2.is_a?(Array) && display[0]==0 && display[1]==k.length
    return false
  end
  m2=[]
  for i in display[0]...display[1]
    ls=[]
    for j in 0...f.length
      sf=s[f[j]]
      if f[j]==10 # give the proper attack stat name
        if ['Staff','Tome','Dragon'].include?(k[i][1][1])
          sf='Magic'
        elsif ['Blade','Dagger','Bow'].include?(k[i][1][1])
          sf='Strength'
        end
      end
      sfn=""
      sfn="(+) " if [1,5,10].include?(k[i][f[j]-5]) && f[j]<14
      sfn="(-) " if [2,6,11].include?(k[i][f[j]-5]) && f[j]<14
      ls.push("#{k[i][f[j]]} #{sfn}#{sf}") if sf.length>0
    end
    m2.push("#{"~~" if !k[i][22].nil?}**#{k[i][0]}** - #{ls.join(', ')}#{"~~" if !k[i][22].nil?}")
  end
  if (f.include?(9) || f.include?(10) || f.include?(11) || f.include?(12) || f.include?(13)) && m2.join("\n").include?("(+)") && m2.join("\n").include?("(-)")
    m="#{m}\n(+) and (-) mark units for whom a nature would increase or decrease a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  elsif (f.include?(9) || f.include?(10) || f.include?(11) || f.include?(12) || f.include?(13)) && m2.join("\n").include?("(+)")
    m="#{m}\n(+) marks units for whom a boon would increase a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  elsif (f.include?(9) || f.include?(10) || f.include?(11) || f.include?(12) || f.include?(13)) && m2.join("\n").include?("(-)")
    m="#{m}\n(-) marks units for whom a bane would decrease a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.\n"
  end
  if f.include?(15)
    m="#{m}\nThe order of units listed here can also be affected by natures if a unit's Defense and Resistance are quite close.\n"
  end
  if "#{m}\n#{m2.join("\n")}".length>2000 && !(event.server.nil? || event.channel.id==283821884800499714 || @shardizard==4)
    event.respond "Too much data is trying to be displayed.  Please use this command in PM.\n\nHere is what you typed: ```#{event.message.text}```\nYou can also make things easier by making the list shorter with words like `top#{rand(10)+1}` or `bottom#{rand(10)+1}`"
    return nil
  end
  for i in 0...m2.length
    m=extend_message(m,m2[i],event)
  end
  event.respond m
  return nil
end

bot.command([:average,:mean]) do |event, *args|
  event.channel.send_temporary_message("Calculating data, please wait...",5)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  f2=[0,0,0,0,0,0,0]
  k22=find_in_units(event,3) # Narrow the list of units down based on the defined parameters
  colorz=k22[1]
  k22=k22[0]
  k222=k22.reject{|q| find_unit(q[0],event)<0} if k22.is_a?(Array)
  k222=@data.reject{|q| find_unit(q[0],event)<0} unless k22.is_a?(Array)
  k222=k222.reject{|q| q[9].nil? || q[9]==0}
  k222=k222.reject{|q| !q[22].nil?} unless " #{event.message.text.downcase} ".include?(' all ')
  k222.compact!
  ccz=[]
  for i2 in 0...k222.length
    ccz.push(unit_color(event,find_unit(k222[i2][0],event),1))
    f2[1]+=k222[i2][9]
    f2[2]+=k222[i2][10]
    f2[3]+=k222[i2][11]
    f2[4]+=k222[i2][12]
    f2[5]+=k222[i2][13]
  end
  if ccz.length==0
    ccz=0xFFD800
  else
    ccz=avg_color(ccz)
  end
  create_embed(event,"__**Average among #{k222.length} units**__","HP: #{div_100(f2[1]*100/k222.length)}\nAttack: #{div_100(f2[2]*100/k222.length)}\nSpeed: #{div_100(f2[3]*100/k222.length)}\nDefense: #{div_100(f2[4]*100/k222.length)}\nResistance: #{div_100(f2[5]*100/k222.length)}\n\nBST: #{div_100((f2[1]+f2[2]+f2[3]+f2[4]+f2[5])*100/k222.length)}",ccz)
  return nil
end

bot.command([:bestamong,:bestin,:beststats,:higheststats]) do |event, *args|
  event.channel.send_temporary_message("Calculating data, please wait...",5)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k22=find_in_units(event,3) # Narrow the list of units down based on the defined parameters
  colorz=k22[1]
  k22=k22[0]
  k222=k22.reject{|q| find_unit(q[0],event)<0} if k22.is_a?(Array)
  k222=@data.reject{|q| find_unit(q[0],event)<0} unless k22.is_a?(Array)
  k222=k222.reject{|q| q[9].nil? || q[9]==0}
  k222=k222.reject{|q| !q[22].nil?} unless " #{event.message.text.downcase} ".include?(' all ')
  k222.compact!
  ccz=[]
  event.channel.send_temporary_message("Units found, finding highest stats now...",5)
  hstats=[[0,[]],[0,[]],[0,[]],[0,[]],[0,[]],[0,[]]]
  for i in 0...k222.length
    d=@data[find_unit(k222[i][0],event)]
    ccz.push(unit_color(event,find_unit(k222[i][0],event),1))
    for j in 0...6
      stz=d[8+j]
      stz=d[9]+d[10]+d[11]+d[12]+d[13] if j==0
      if stz==hstats[j][0]
        hstats[j][1].push(d[0])
      elsif stz>hstats[j][0]
        hstats[j]=[stz,[d[0]]]
      end
    end
  end
  if ccz.length==0
    ccz=0xFFD800
  else
    ccz=avg_color(ccz)
  end
  stzzz=['BST','HP','Attack','Speed','Defense','Resistance']
  hbst=0
  for iz in 0...hstats.length
    hbst+=hstats[iz][0] if iz != 0
    if hstats[iz][1].length>=k222.length
      hstats[iz]="Constant #{stzzz[iz]}: #{hstats[iz][0]}"
    else
      hstats[iz]="Highest #{stzzz[iz]}: #{hstats[iz][0]} (#{hstats[iz][1].join(', ')})"
    end
  end
  create_embed(event,"__**Best among #{k222.length} units**__","#{hstats[1]}\n#{hstats[2]}\n#{hstats[3]}\n#{hstats[4]}\n#{hstats[5]}\n\n#{hstats[0]}\nBST of highest stats: #{hbst}",ccz)
  return nil
end

bot.command([:worstamong,:worstin,:worststats,:loweststats]) do |event, *args|
  event.channel.send_temporary_message("Calculating data, please wait...",5)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k22=find_in_units(event,3) # Narrow the list of units down based on the defined parameters
  colorz=k22[1]
  k22=k22[0]
  k222=k22.reject{|q| find_unit(q[0],event)<0} if k22.is_a?(Array)
  k222=@data.reject{|q| find_unit(q[0],event)<0} unless k22.is_a?(Array)
  k222=k222.reject{|q| q[9].nil? || q[9]==0}
  k222=k222.reject{|q| !q[22].nil?} unless " #{event.message.text.downcase} ".include?(' all ')
  k222.compact!
  ccz=[]
  event.channel.send_temporary_message("Units found, finding lowest stats now...",5)
  hstats=[[1000,[]],[1000,[]],[1000,[]],[1000,[]],[1000,[]],[1000,[]]]
  for i in 0...k222.length
    d=@data[find_unit(k222[i][0],event)]
    ccz.push(unit_color(event,find_unit(k222[i][0],event),1))
    for j in 0...6
      stz=d[8+j]
      stz=d[9]+d[10]+d[11]+d[12]+d[13] if j==0
      if stz==hstats[j][0]
        hstats[j][1].push(d[0])
      elsif stz<hstats[j][0]
        hstats[j]=[stz,[d[0]]]
      end
    end
  end
  if ccz.length==0
    ccz=0xFFD800
  else
    ccz=avg_color(ccz)
  end
  stzzz=['BST','HP','Attack','Speed','Defense','Resistance']
  hbst=0
  for iz in 0...hstats.length
    hbst+=hstats[iz][0] if iz != 0
    if hstats[iz][1].length>=k222.length
      hstats[iz]="Constant #{stzzz[iz]}: #{hstats[iz][0]}"
    else
      hstats[iz]="Lowest #{stzzz[iz]}: #{hstats[iz][0]} (#{hstats[iz][1].join(', ')})"
    end
  end
  create_embed(event,"__**Worst among #{k222.length} units**__","#{hstats[1]}\n#{hstats[2]}\n#{hstats[3]}\n#{hstats[4]}\n#{hstats[5]}\n\n#{hstats[0]}\nBST of lowest stats: #{hbst}",ccz)
  return nil
end

bot.command([:embeds,:embed]) do |event|
  metadata_load()
  if @embedless.include?(event.user.id)
    for i in 0...@embedless.length
      @embedless[i]=nil if @embedless[i]==event.user.id
    end
    @embedless.compact!
    event.respond "You will now see my replies as embeds again."
  else
    @embedless.push(event.user.id)
    event.respond "You will now see my replies as plaintext."
  end
  metadata_save()
  return nil
end

bot.command([:headpat,:patpat,:pat]) do |event|
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
  r.push(["My husband wouldn't appreciate you doing this.",(rand(2)==0)]) unless event.user.id==hubbyid
  r.push(["\\*pulls away* Don't do that, please!",false]) unless event.user.id==hubbyid
  r.push(["\\*hums happily*",true]) if event.user.id==hubbyid
  r.push(["Aww, thanks, honey!  I have the bestest hubby ever!",true]) if event.user.id==hubbyid
  can_joseph=true
  if event.server.nil?
    can_joseph=false if event.user.id==170070293493186561
  else
    can_joseph=false if !bot.user(170070293493186561).on(event.server.id).nil?
    can_joseph=true if !bot.user(256502173788143626).on(event.server.id).nil?
  end
  r.push(["Do I remind you of Joseph? He's the cutest puppy that ever was!",true]) if can_joseph
  r2=r.sample
  if r2[1] && rand(10)==0
    if event.user.id==270372601107447808
      event << "Elise: #{r2[0]}"
      event << "Leo: \\*spies the two, grumbles\\*"
      event << "Elise: Go away, Leo.  #{bot.user(270372601107447808).name.split(' | ')[0]} and I can do whatever we want; we're married.  \\*sticks out tongue* "
    elsif event.user.id==261321388344868867
      event << "Elise: #{r2[0]}"
      event << "Leo: \\*spies the two, grumbles\\*"
      event << "Elise: Go away, Leo.  #{bot.user(261321388344868867).name} and I can do whatever we want; we're married.  \\*sticks out tongue* "
    else
      event << "Elise: #{r2[0]}"
      event << "Leo: Please stop, you need to treat her like the adult that she technically is."
      event << "Elise: \\*sticks out tongue* You're no fun."
    end
  else
    event << r2[0]
  end
  event << ""
  metadata_load()
  z=0
  z=1 if event.user.id==270372601107447808
  z=2 if event.user.id==261321388344868867
  @headpats[z]+=1
  if @headpats[z]>=1000000000
    event << "~~resetting counter~~"
    @headpats[z]=1
  end
  metadata_save()
  if event.user.id==270372601107447808
    event << "~~This is the #{longFormattedNumber(@headpats[1],true)} time you have given me a headpat.~~"
    z=(@headpats[1]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
    z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
    event << "~~#{z}% of the attempted headpats were performed by you.~~"
  elsif event.user.id==261321388344868867
    event << "~~This is the #{longFormattedNumber(@headpats[2],true)} time you have given me a headpat.~~"
    z=(@headpats[2]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
    z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
    event << "~~#{z}% of the attempted headpats were performed by you.~~"
  elsif event.user.id==167657750971547648
    event << "~~This is the #{longFormattedNumber(@headpats[0]+@headpats[1]+@headpats[2],true)} time someone has tried to give me a headpat.~~"
    event << ""
    if event.server.nil?
      z=(@headpats[1]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
      z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
      event << "~~Moosie has headpatted me #{longFormattedNumber(@headpats[1])} time#{"s" unless @headpats[1]==1}, which is #{z}% of the headpats I've received~~"
      z=(@headpats[2]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
      z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
      event << "~~ExpiredJellyBean has headpatted me #{longFormattedNumber(@headpats[2])} time#{"s" unless @headpats[2]==1}, which is #{z}% of the headpats I've received~~"
      z=(@headpats[0]*10000)/(@headpats[0]+@headpats[1]+@headpats[2])
      z="#{z/100}#{".#{"0" if z%100<10}#{z%100}" unless z%100==0}"
      event << "~~Other people have headpatted me #{longFormattedNumber(@headpats[0])} time#{"s" unless @headpats[0]==1}, which is #{z}% of the headpats I've received~~"
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
  event << "A guide to nature names.  Though things like `+Atk` and `-Def` still work"
  event << "https://orig00.deviantart.net/d88e/f/2018/047/9/2/nature_names_by_rot8erconex-dc3e1fj.png"
end

bot.command([:growths, :gps, :growth, :gp]) do |event|
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
  event << '6.) If 1-2\\* units could get natures, then they would have the possibility for "microboons" and "microbanes", where a stat increases or decreases by 2 instead of the usual 3.'
  event << '- These are marked by the thin blue and red arrows.'
  event << ''
  event << 'https://orig00.deviantart.net/2212/f/2017/356/2/c/gps_by_rot8erconex-dbwvkcx.png'
end

bot.command(:merges) do |event|
  event << '__**How to predict what stats will increase by a merge**__'
  event << "1.) Look at the original unit's level 1 stats at 5\\*."
  event << '- The stats must be at 5\\* regardless of the rarity of the unit being merged.'
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
  usr=event.user
  txt="To invite me to your server: <https://goo.gl/Hf9RNj>\nTo look at my source code: <https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/PriscillaBot.rb>\nIf you suggested me to server mods and they ask what I do, copy this image link to them: https://orig00.deviantart.net/cd2d/f/2018/047/e/0/marketing___elise_by_rot8erconex-dbxj4mq.png"
  user_to_name="you"
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
  s5=event.message.text.downcase
  s5=s5[2,s5.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
  s5=s5[4,s5.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
  a=s5.split(' ')
  s3="Bug Report"
  s3="Suggestion" if a[0]=='suggestion'
  s3="Feedback" if a[0]=='feedback'
  s2=""
  if event.server.nil?
    s="**#{s3} sent by PM**"
  else
    s="**Server:** #{event.server.name} (#{event.server.id}) - #{['Transparent','Scarlet','Azure','Verdant'][(event.server.id >> 22) % 4]} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})"
  end
  bot.user(167657750971547648).pm("#{s}\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{s3}:** #{args.join(' ')}#{s2}")
  s3="Bug" if s3=="Bug Report"
  t=Time.now
  event << "Your #{s3.downcase} has been logged."
  return nil
end

bot.command([:tools,:links]) do |event|
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.user.id==195303206933233665 || event.message.text.include?('<@195303206933233665>') || event.message.text.downcase.include?('mobile') || event.message.text.downcase.include?('phone')
    event << "**Useful tools for players of** ***Fire Emblem Heroes***"
    event << "__Download the game__"
    event << "Google Play: <https://play.google.com/store/apps/details?id=com.nintendo.zaba&hl=en>"
    event << "Apple App Store: <https://itunes.apple.com/app/id1181774280>"
    event << ""
    event << "__Wikis and Databases__"
    event << "Gamepedia FEH wiki: <https://feheroes.gamepedia.com/>"
    event << "Gamepress FEH database: <https://fireemblem.gamepress.gg/>"
    event << ""
    event << "__Simulators__"
    event << "Summon Simulator: <https://feh-stuff.github.io/>"
    event << "Inheritance tracker: <https://arghblargh.github.io/feh-inheritance-tool/>"
    event << "Visual unit builder: <https://feh-stuff.github.io/unit-builder.html>"
    event << ""
    event << "__Damage Calculators__"
    event << "ASFox's mass duel simulator: <http://arcticsilverfox.com/feh_sim/>"
    event << "KageroChart's damage calculator: <https://kagerochart.com/damage-calc>"
    event << "Andu2's mass duel simulator fork: <https://andu2.github.io/FEH-Mass-Simulator/>"
    event << ""
    event << "FEHKeeper: <https://www.fehkeeper.com/>"
    event << ""
    event << "Arena Score Calculator: <http://www.arcticsilverfox.com/score_calc/>"
    event << ""
    event << "Glimmer vs. Moonbow: <https://i.imgur.com/kDKPMp7.png>"
  else
    create_embed(event,"**Useful tools for players of** ***Fire Emblem Heroes***","__Download the game__\n[Google Play](https://play.google.com/store/apps/details?id=com.nintendo.zaba&hl=en)\n[Apple App Store](https://itunes.apple.com/app/id1181774280)\n\n__Wikis and Databases__\n[Gamepedia FEH wiki](https://feheroes.gamepedia.com/)\n[Gamepress FEH database](https://fireemblem.gamepress.gg/)\n\n__Simulators__\n[Summon Simulator](https://feh-stuff.github.io/)\n[Inheritance tracker](https://arghblargh.github.io/feh-inheritance-tool/)\n[Visual unit builder](https://feh-stuff.github.io/unit-builder.html)\n\n__Damage Calculators__\n[ASFox's mass duel simulator](http://arcticsilverfox.com/feh_sim/)\n[KageroChart's damage calculator](https://kagerochart.com/damage-calc)\n[Andu2's mass duel simulator fork](https://andu2.github.io/FEH-Mass-Simulator/)\n\n[FEHKeeper](https://www.fehkeeper.com/)\n\n[Arena Score Calculator](http://www.arcticsilverfox.com/score_calc/)\n\n[Glimmer vs. Moonbow](https://i.imgur.com/kDKPMp7.png)",0xD49F61,nil,"https://lh3.googleusercontent.com/4ziItIIQ0pMqlUigjosG05YC5VkHKNy3ps26F5Hfi2lt0Zs3yB7dyi9bUQ4q1GgEPSE=w300-rw")
    event.respond "If you are on a mobile device and cannot click the links in the embed above, type `FEH!tools mobile` to receive this message as plaintext."
  end
  event << ""
end

bot.command(:sendpm, from: 167657750971547648) do |event, user_id, *args| # sends a PM to a specific user
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648
  f=event.message.text.split(' ')
  f="#{f[0]} #{f[1]} "
  bot.user(user_id.to_i).pm(event.message.text.gsub(f,''))
  event.respond "Message sent."
end

bot.command(:ignoreuser, from: 167657750971547648) do |event, user_id| # causes Elise to ignore the specified user
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648
  metadata_load()
  bot.ignore_user(user_id.to_i)
  event.respond "#{bot.user(user_id.to_i).distinct} is now being ignored."
  @ignored.push(bot.user(user_id.to_i).id)
  bot.user(user_id.to_i).pm("You have been added to my ignore list.")
  metadata_save()
  return nil
end

bot.command(:sendmessage, from: 167657750971547648) do |event, channel_id, *args| # sends a message to a specific channel
  return nil unless event.server.nil?
  if event.user.id==167657750971547648
  else
    event.respond "Are you trying to use the `bugreport`, `suggestion`, or `feedback` command?"
    bot.user(167657750971547648).pm("#{event.user.distinct} (#{event.user.id}) tried to use the `sendmessage` command.")
    return nil
  end
  f=event.message.text.split(' ')
  f="#{f[0]} #{f[1]} "
  bot.channel(channel_id).send_message(event.message.text.gsub(f,''))
  event.respond "Message sent."
  return nil
end

bot.command(:leaveserver, from: 167657750971547648) do |event, server_id| # forces Elise to leave a server
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648
  chn=bot.server(server_id.to_i).general_channel
  if chn.nil?
    chnn=[]
    for i in 0...bot.server(server_id.to_i).channels.length
      chnn.push(bot.server(server_id.to_i).channels[i]) if bot.user(bot.profile.id).on(event.server.id).permission?(:send_messages,bot.server(server_id.to_i).channels[i]) && bot.server(server_id.to_i).channels[i].type==0
    end
    chn=chnn[0] if chnn.length>0
  end
  chn.general_channel.send_message("My coder would rather that I not associate with you guys.  I'm sorry.  If you would like me back, please take it up with him.") rescue nil
  bot.server(server_id.to_i).leave
  return nil
end

bot.command(:snagstats) do |event, f| # snags the number of members in each of the servers Elise is in
  nicknames_load()
  groups_load()
  g=get_markers(event)
  data_load()
  metadata_load()
  bot.servers.values(&:members)
  @server_data[0][@shardizard]=bot.servers.length
  @server_data[1][@shardizard]=bot.users.size
  metadata_save()
  unless event.user.id==167657750971547648 && !f.nil? && @shardizard<4
    bot.servers.values(&:members)
    event << "I am in #{longFormattedNumber(@server_data[0].inject(0){|sum,x| sum + x })} servers, reaching #{longFormattedNumber(@server_data[1].inject(0){|sum,x| sum + x })} unique members."
    event << "This shard is in #{longFormattedNumber(@server_data[0][@shardizard])} servers, reaching #{longFormattedNumber(@server_data[1][@shardizard])} unique members."
    event << ''
    event << "There are #{longFormattedNumber(@data.reject{|q| !has_any?(g, q[22])}.length)} units and #{longFormattedNumber(@skills.reject{|q| !has_any?(g, q[21])}.length)} skills#{" if you include ones specific to this server." unless g.length<2}"
    event << "There are #{longFormattedNumber(@data.length)} units and #{longFormattedNumber(@skills.length)} skills if you include all the ones I can see." if event.server.nil? && event.user.id==167657750971547648
    event << "There are #{longFormattedNumber(@data.reject{|q| !q[22].nil?}.length)} units and #{longFormattedNumber(@skills.reject{|q| !q[21].nil?}.length)} skills if you only include the official ones" unless g.length<2
    event << ''
    event << "I keep track of #{longFormattedNumber(@names.length)} aliases and #{longFormattedNumber(@groups.length)} groups."
    event << ''
    event << "I am #{longFormattedNumber(File.foreach("C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} lines of code long."
    return nil
  end
  if f.to_i.to_s==f
    srv=(bot.server(f.to_i) rescue nil)
    if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
      s2="I am not in that server."
    else
      s2="__**#{srv.name}** (#{srv.id})__\n*Owner:* #{srv.owner.distinct} (#{srv.owner.id})\n*Shard:* #{(srv.id >> 22) % 4}\n*My nickname:* #{bot.user(312451658908958721).on(srv.id).display_name}"
    end
    event.respond s2
    return nil
  end
  bot.servers.values(&:members)
  event << "I am in #{longFormattedNumber(@server_data[0].inject(0){|sum,x| sum + x })} servers, reaching #{longFormattedNumber(@server_data[1].inject(0){|sum,x| sum + x })} unique members."
  event << "This shard is in #{longFormattedNumber(bot.servers.length)} servers, reaching #{longFormattedNumber(bot.users.size)} unique members."
  event << ''
  event << "There are #{longFormattedNumber(@data.reject{|q| !has_any?(g, q[22])}.length)} units and #{longFormattedNumber(@skills.reject{|q| !has_any?(g, q[21])}.length)} skills#{" if you include ones specific to this server." unless g.length<2}"
  event << "There are #{longFormattedNumber(@data.length)} units and #{longFormattedNumber(@skills.length)} skills if you include all the ones I can see." if event.server.nil? && event.user.id==167657750971547648
  event << "There are #{longFormattedNumber(@data.reject{|q| !q[22].nil?}.length)} units and #{longFormattedNumber(@skills.reject{|q| !q[21].nil?}.length)} skills if you only include the official ones" unless g.length<2
  event << ''
  event << "I keep track of #{longFormattedNumber(@names.length)} aliases and #{longFormattedNumber(@groups.length)} groups."
  event << ''
  event << "I am #{longFormattedNumber(File.foreach("C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} lines of code long."
  return nil
end

bot.command(:shard) do |event, i|
  if i.to_i.to_s==i && i.to_i.is_a?(Bignum) && @shardizard != 4
    srv=(bot.server(i.to_i) rescue nil)
    if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
      event.respond "I am not in that server, but it would use #{['Transparent','Scarlet','Azure','Verdant'][(i.to_i >> 22) % 4]} Shards."
    else
      event.respond "#{srv.name} uses #{['Transparent','Scarlet','Azure','Verdant'][(i.to_i >> 22) % 4]} Shards."
    end
    return nil
  end
  event.respond "This is the debug mode, which uses Golden Shards." if @shardizard==4
  event.respond "PMs always use Colorless Shards." if event.server.nil?
  event.respond "This server uses #{['Transparent','Scarlet','Azure','Verdant'][(event.server.id >> 22) % 4]} Shards." unless event.server.nil? || @shardizard==4
end

bot.command([:locateshards, :locate, :locateshards], from: 167657750971547648) do |event|
  return nil unless event.user.id==167657750971547648
  if @shardizard==4
    event.respond "This command cannot be used by the debug version of me.  Please run this command in another server."
    return nil
  end
  bot.channel(403998870327132171).send_message("Verdant Shards are used here, <@167657750971547648>")
  event << "Transparent Shards are used in PMs and in server C-137."
  event << "Scarlet Shards are used in your testing server."
  event << "Azure Shards are used in Penumbra."
  event << "I have pinged you in a server that uses Verdant Shards."
end

bot.command(:cleanupaliases) do |event|
  event.channel.send_temporary_message("Please wait...",10)
  if @shardizard==4
    event.respond "This command cannot be used by the debug version of me.  Please run this command in another server."
    return nil
  end
  return nil unless event.user.id==167657750971547648
  nicknames_load()
  nmz=@names.map{|q| q}
  k=0
  for i in 0...nmz.length
    unless nmz[i][2].nil?
      for i2 in 0...nmz[i][2].length
        srv=(bot.server(nmz[i][2][i2]) rescue nil)
        if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
          k+=1
          nmz[i][2][i2]=nil
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

bot.command(:backup) do |event, trigger|
  return nil unless event.user.id==167657750971547648 || event.channel.id==386658080257212417
  if trigger.nil?
    event.respond "Backup what?"
  elsif ['aliases','alias'].include?(trigger.downcase)
    nicknames_load()
    @names.uniq!
    @names.sort! {|a,b| (a[1].downcase <=> b[1].downcase) == 0 ? (a[0].downcase <=> b[0].downcase) : (a[1].downcase <=> b[1].downcase)}
    if @names[@names.length-1].length<=1 || @names[@names.length-1][1]<"Zephiel"
      event.respond "Alias list has __***NOT***__ been backed up, as alias list has been corrupted."
      bot.gateway.check_heartbeat_acks = true
      event.respond "FEH!restorealiases"
      return nil
    end
    nzzzzz=@names.map{|a| a}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames2.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event.respond "Alias list has been backed up."
  elsif ['groups','group'].include?(trigger.downcase)
    groups_load()
    nzzzzz=@groups.map{|a| a}
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups2.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event.respond "Groups list has been backed up."
  else
    event.respond "Backup what?"
  end
  return nil
end

bot.command(:restore) do |event, trigger|
  return nil unless [167657750971547648,bot.profile.id].include?(event.user.id) || event.channel.id==386658080257212417
  bot.gateway.check_heartbeat_acks = false
  if trigger.nil?
    event.respond "Restore what?"
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
    if nzzzzz[nzzzzz.length-1][1]<"Zephiel"
      event << "Last backup of the alias list has been corrupted.  Restoring from manually-created backup."
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
      event << "Last backup of the alias list being used."
    end
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event << "Alias list has been restored from backup."
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
      event << "Last backup of the group list has been corrupted.  Restoring from manually-created backup."
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
      event << "Last backup of the group list being used."
    end
    open('C:/Users/Mini-Matt/Desktop/devkit/FEHGroups.txt', 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event << "Group list has been restored from backup."
  else
    event.respond "Restore what?"
  end
end

bot.command([:devedit, :dev_edit], from: 167657750971547648) do |event, cmd, *args|
  return nil unless event.user.id==167657750971547648
  str=find_name_in_string(event)
  data_load()
  j=find_unit(str,event)
  if j<0
    event.respond "There is no unit by that name."
    return nil
  end
  j2=find_in_dev_units(@data[j][0])
  if j2<0
    args=event.message.text.downcase.split(" ")
    if cmd.downcase=="create"
      sklz2=unit_skills(@data[find_unit(find_name_in_string(event),event)][0],event,true)
      flurp=find_stats_in_string(event)
      @dev_units.push([@data[find_unit(find_name_in_string(event),event)][0],flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5],' '])
      devunits_save()
      congrate=false
      congrats=true if @dev_waifus.include?(@data[find_unit(find_name_in_string(event),event)][0])
      event.respond "You have added a #{flurp[0]}* #{@data[find_unit(find_name_in_string(event),event)][0]} to your collection.  #{"Congrats!" if congrats}"
    else
      @stored_event=event
      event.respond "You do not have this unit.  Do you wish to add them to your collection?" unless @dev_lowlifes.include?(@data[j][0])
      event.respond "You Have this unit but previously stated you don't want to input their data.  Do you wish to add them to your collection?" if @dev_lowlifes.include?(@data[j][0])
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond "Okay."
        else
          jn=@data[find_unit(find_name_in_string(@stored_event),@stored_event)][0]
          sklz2=unit_skills(jn,@stored_event,true)
          flurp=find_stats_in_string(e)
          @dev_units.push([jn,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5]])
          devunits_save()
          congrate=false
          congrats=true if @dev_waifus.include?(jn)
          e.respond "You have added a 3* #{jn} to your collection.  #{"Congrats!" if congrats}"
        end
      end
    end
  elsif ['promote','rarity','feathers'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    @dev_units[j2][1]=flurp[0] unless flurp[0].nil?
    @dev_units[j2][1]+=1 if flurp[0].nil?
    @dev_units[j2][1]=[@dev_units[j2][1],5].min
    @dev_units[j2][2]=0
    devunits_save()
    event.respond "You have promoted your #{@dev_units[j2][0]} to #{@dev_units[j2][1]}*!"
  elsif ['merge','combine'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    @dev_units[j2][2]+=flurp[1] unless flurp[1].nil?
    @dev_units[j2][2]+=1 if flurp[1].nil?
    @dev_units[j2][2]=[@dev_units[j2][2],10].min
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
      event.respond "You cannot have a boon without a bane.  Set stats to neutral?" if flurp[3].nil?
      event.respond "You cannot have a bane without a boon.  Set stats to neutral?" if flurp[2].nil?
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond "Okay."
        else
          j2=find_in_dev_units(@data[find_unit(find_name_in_string(@stored_event),@stored_event)][0])
          @dev_units[j2][3]=' '
          @dev_units[j2][4]=' '
          devunits_save()
          event.respond "You have changed your #{@dev_units[j2][0]}'s nature to neutral!"
        end
      end
    else
      @dev_units[j2][3]=flurp[2]
      @dev_units[j2][4]=flurp[3]
      atk="Attack"
      atk="Magic" if ['Tome','Dragon','Healer'].include?(@data[j][1][1])
      atk="Strength" if ['Blade','Bow','Dagger'].include?(@data[j][1][1])
      n=nature_name(flurp[2],flurp[3])
      unless n.nil?
        n=n[0] if atk=="Strength"
        n=n[n.length-1] if atk=="Magic"
        n=n.join(' / ') if ["Attack","Freeze"].include?(atk)
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
    s="that type"
    s="those types" if skill_types.uniq.length>1
    for i in 0...skill_types.length
      k=false
      for j in 0...@dev_units[j2][skill_types[i]].length
        if skill_types[i]==12
          seel=@dev_units[j2][skill_types[i]].scan(/\d+?/)[0].to_i
          seel=@dev_units[j2][skill_types[i]].gsub(seel.to_s,(seel+1).to_s)
          k=true if find_skill(seel,event,true)>=0
        else
          k=true if @dev_units[j2][skill_types[i]][j][0,2]=="~~" && @dev_units[j2][skill_types[i]][j]!="~~none~~"
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
          if @dev_units[j2][skill_types[i]][j][0,2]=="~~" && k
            k=false
            @dev_units[j2][skill_types[i]][j]=@dev_units[j2][skill_types[i]][j].gsub("~~",'')
            skills_learned.push(@dev_units[j2][skill_types[i]][j])
          end
        end
      end
    end
    devunits_save()
    event.respond "__Your **#{@dev_units[j2][0]}** has learned the following skills__\n#{skills_learned.join("\n")}"
  else
    event.respond "Edit mode was not specified."
  end
  return nil
end

bot.command(:status, from: 167657750971547648) do |event, *args|
  return nil unless event.user.id==167657750971547648
  bot.game=args.join(' ')
  event.respond "Status set."
end

bot.command(:setmarker, from: 167657750971547648) do |event, letter|
  return nil unless event.user.id==167657750971547648
  return nil if event.server.nil?
  return nil if letter.nil?
  letter=letter[0,1].upcase
  metadata_load()
  if letter=="X"
    @x_markers=[] if @x_markers.nil?
    if @x_markers.include?(event.server.id)
      event.respond "This server can already see entries marked with X."
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
  event.respond "This server's marker has been set as #{letter}." unless letter=="X"
  event.respond "This server has been added to those that can see entries marked with #{letter}." if letter=="X"
end

bot.server_create do |event|
  chn=event.server.general_channel
  if chn.nil?
    chnn=[]
    for i in 0...event.server.channels.length
      chnn.push(event.server.channels[i]) if bot.user(bot.profile.id).on(event.server.id).permission?(:send_messages,event.server.channels[i]) && event.server.channels[i].type==0
    end
    chn=chnn[0] if chnn.length>0
  end
  if event.server.id != 285663217261477889 && @shardizard==4
    (chn.send_message("I am Mathoo's personal debug bot.  As such, I do not belong here.  You may be looking for one of my two facets, so I'll drop both their invite links here.\n\n**EliseBot** allows you to look up stats and skill data for characters in *Fire Emblem: Heroes*\nHere's her invite link: <https://goo.gl/Hf9RNj>\n\n**FEIndex**, also known as **RobinBot**, is for *Fire Emblem: Awakening* and *Fire Emblem Fates*.\nHere's her invite link: <https://goo.gl/f1wSGd>") rescue nil)
    event.server.leave
  else
    bot.user(167657750971547648).pm("Joined server **#{event.server.name}** (#{event.server.id})\nOwner: #{event.server.owner.distinct} (#{event.server.owner.id})\nAssigned to use #{['Transparent','Scarlet','Azure','Verdant'][(event.server.id >> 22) % 4]} Shards")
    metadata_load()
    @server_data[0][((event.server.id >> 22) % 4)] += 1
    metadata_save()
    chn.send_message("I'm here to deliver the happiest of hellos - as well as data for heroes and skills in *Fire Emblem: Heroes*!  So, here I am!") rescue nil
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
      event.respond "Becoming Robin.  Please wait approximately ten seconds..."
      exec "cd C:/Users/Mini-Matt/Desktop/devkit/FEIndex && feindex.rb 4"
    else
      event.respond "I am not Robin right now.  Please use `FE!reboot` to turn me into Robin."
    end
  elsif ['f?','e?','h?'].include?(event.message.text.downcase[0,2]) || ['feh!','feh?'].include?(event.message.text.downcase[0,4])
    s=event.message.text.downcase
    puts s if @shardizard==3
    s=s[2,s.length-2] if ['f?','e?','h?'].include?(event.message.text.downcase[0,2])
    s=s[4,s.length-4] if ['feh!','feh?'].include?(event.message.text.downcase[0,4])
    a=s.split(' ')
    if s.gsub(' ','').downcase=="laevatein"
      disp_stats(bot,"Lavatain",nil,event,true)
      disp_skill("Bladeblade",event,true)
    elsif !all_commands(true).include?(a[0])
      str=find_name_in_string(event,nil,1)
      data_load()
      if find_skill(s,event,false,true)>=0
        disp_skill(s,event,true)
      elsif str.nil?
        if find_skill(s,event)>=0
          disp_skill(s,event,true)
        elsif !detect_dual_unit_alias(s.downcase,event.message.text.downcase).nil?
          x=detect_dual_unit_alias(s.downcase,event.message.text.downcase)
          event.channel.send_temporary_message("Calculating data, please wait...",event.message.text.length/30-1) if event.message.text.length>90
          k2=get_weapon(first_sub(s,x[0],''),event)
          w=nil
          w=k2[0] unless k2.nil?
          disp_stats(bot,x[1],w,event,true)
          disp_unit_skills(bot,x[1],event,true,true) unless x[1].is_a?(Array) && x[1].length>1
          event.respond "For these characters' skills, please use the command `FEH!skills #{x[0]}`." if x[1].is_a?(Array) && x[1].length>1
        elsif !detect_dual_unit_alias(s.downcase,s.downcase).nil?
          x=detect_dual_unit_alias(s.downcase,s.downcase)
          event.channel.send_temporary_message("Calculating data, please wait...",event.message.text.length/30-1) if event.message.text.length>90
          k2=get_weapon(first_sub(s,x[0],''),event)
          w=nil
          w=k2[0] unless k2.nil?
          disp_stats(bot,x[1],w,event,true)
          disp_unit_skills(bot,x[1],event,true,true) unless x[1].is_a?(Array) && x[1].length>1
          event.respond "For these characters' skills, please use the command `FEH!skills #{x[0]}`." if x[1].is_a?(Array) && x[1].length>1
        end
      elsif str[1].downcase=='ploy' && find_skill(stat_buffs(s,s),event)>=0
        disp_skill(stat_buffs(s,s),event,true)
      elsif !detect_dual_unit_alias(str[0].downcase,event.message.text.downcase).nil?
        x=detect_dual_unit_alias(str[0].downcase,event.message.text.downcase)
        event.channel.send_temporary_message("Calculating data, please wait...",event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.nil?
        disp_stats(bot,x[1],w,event,true)
        disp_unit_skills(bot,x[1],event,true,true) unless x[1].is_a?(Array) && x[1].length>1
        event.respond "For these characters' skills, please use the command `FEH!skills #{x[0]}`." if x[1].is_a?(Array) && x[1].length>1
      elsif !detect_dual_unit_alias(str[0].downcase,str[0].downcase).nil?
        x=detect_dual_unit_alias(str[0].downcase,str[0].downcase)
        event.channel.send_temporary_message("Calculating data, please wait...",event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.nil?
        disp_stats(bot,x[1],w,event,true)
        disp_unit_skills(bot,x[1],event,true,true) unless x[1].is_a?(Array) && x[1].length>1
        event.respond "For these characters' skills, please use the command `FEH!skills #{x[0]}`." if x[1].is_a?(Array) && x[1].length>1
      elsif find_unit(str[0],event)>=0
        event.channel.send_temporary_message("Calculating data, please wait...",event.message.text.length/30-1) if event.message.text.length>90
        k=find_name_in_string(event,nil,1)
        if k.nil?
          str=nil
        else
          str=k[0]
          k2=get_weapon(first_sub(s,k[1],''),event)
          w=nil
          w=k2[0] unless k2.nil?
        end
        disp_stats(bot,str,w,event,event.server.nil?)
        disp_unit_skills(bot,str,event,event.server.nil?,true)
      elsif find_skill(s,event)>0
        disp_skill(bot,s,event,true)
      elsif !detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase).nil?
        x=detect_dual_unit_alias(event.message.text.downcase,event.message.text.downcase)
        event.channel.send_temporary_message("Calculating data, please wait...",event.message.text.length/30-1) if event.message.text.length>90
        k2=get_weapon(first_sub(s,x[0],''),event)
        w=nil
        w=k2[0] unless k2.nil?
        disp_stats(bot,x[1],w,event,true)
        disp_unit_skills(bot,x[1],event,true,true) unless x[1].is_a?(Array) && x[1].length>1
        event.respond "For these characters' skills, please use the command `FEH!skills #{x[0]}`." if x[1].is_a?(Array) && x[1].length>1
      end
    end
  elsif event.message.text.include?('0x4') && !event.user.bot_account?
    s=event.message.text
    s=remove_format(s,'```')              # remove large code blocks
    s=remove_format(s,'`')                # remove small code blocks
    s=remove_format(s,'~~')               # remove crossed-out text
    if s=='0x4' || s[0,4]=='0x4 ' || s[s.length-4,4]==' 0x4' || s.include?(' 0x4 ')
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
      else
       event.respond "#{"#{event.user.mention} " unless event.server.nil?}#{["Be sure to use Galeforce for 0x8.  #{["","Pair it with a Breath skill to get 0x8 even faster."].sample}","Be sure to include Astra to increase damage by 150%.","Be sure to use a dancer for 0x8.","Be sure to use Sol, so you can heal for half of that.  #{["","Peck, Ephraim(Fire) heals for 80% with his Solar Brace.","Pair it with a Breath skill to get even more healing!"].sample}","#{["Be sure to use Galeforce for 0x8.","Be sure to use a dancer for 0x8."].sample}  Or combine a dancer and Galeforce for a whopping 0x12!"].sample}" if canpost
      end
    end
  end
end

bot.ready do |event|
  if @shardizard==4
    for i in 0...bot.servers.values.length
      if bot.servers.values[i].id != 285663217261477889
        bot.servers.values[i].general_channel.send_message("I am Mathoo's personal debug bot.  As such, I do not belong here.  You may be looking for one of my two facets, so I'll drop both their invite links here.\n\n**EliseBot** allows you to look up stats and skill data for characters in *Fire Emblem: Heroes*\nHere's her invite link: <https://goo.gl/Hf9RNj>\n\n**FEIndex**, also known as **RobinBot**, is for *Fire Emblem: Awakening* and *Fire Emblem Fates*.\nHere's her invite link: <https://goo.gl/f1wSGd>") rescue nil
        bot.servers.values[i].leave
      end
    end
  end
  system("color 5#{"7CBAE"[@shardizard,1]}")
  system("title loading #{['Transparent','Scarlet','Azure','Verdant','Golden'][@shardizard]} EliseBot")
  bot.game="Loading, please wait..." if @shardizard==0
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt').each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  @names=b
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
  bot.game="Fire Emblem Heroes" if [0,4].include?(@shardizard)
  bot.user(bot.profile.id).on(285663217261477889).nickname="EliseBot (Debug)" if @shardizard==4
  bot.profile.avatar=(File.open('C:/Users/Mini-Matt/Desktop/devkit/DebugElise.png','r')) if @shardizard==4
  next_holiday(bot) if @shardizard==0
  metadata_load()
  devunits_load()
  system("color e#{"04126"[@shardizard,1]}")
  system("title #{['Transparent','Scarlet','Azure','Verdant','Golden'][@shardizard]} EliseBot")
end

def calc_easter()
  t = Time.now
  y = t.year
  y += 1 if t.month >= 5
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
  return [y,m,d]
end

def next_holiday(bot,mode=0)
  t=Time.now
  t-=60*60*6
  holidays=[[0,1,1,'Tiki(Young)','as Babby New Year',"New Year's Day"],
            [0,2,2,'Feh','the best gacha game ever!','Game Release Anniversary'],
            [0,2,14,'Cordelia(Bride)','with your heartstrings.',"Valentine's Day"],
            [0,4,1,'Priscilla','tribute to Xander for making this possible.',"April Fool's Day"],
            [0,4,24,'Sakura(BDay)','dressup as my best friend.',"Coder's birthday"],
            [0,7,4,'Arthur','for freedom and justice.','Independance Day'],
            [0,10,31,'Henry(Halloween)','with a dead Emblian. Nyahaha!','Halloween'],
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
      bot.profile.avatar=(File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseImages/#{k[0][3]}.png",'r')) rescue nil
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
        bot.profile.avatar=(File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseImages/#{k[k.length-1][3]}.png",'r')) rescue nil
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
        bot.profile.avatar=(File.open("C:/Users/Mini-Matt/Desktop/devkit/EliseImages/#{k[j][3]}.png",'r')) rescue nil
        t=Time.now
        t-=60*60*6
        @scheduler.at "#{t.year}/#{t.month}/#{t.day} #{div[k.length][j+1][0].to_s.rjust(2, "0")}#{div[k.length][j+1][1].to_s.rjust(2, "0")}" do
          next_holiday(bot,1)
        end
      end
    end
  else
    bot.game="Fire Emblem Heroes"
    t=Time.now
    t-=60*60*6
    if [6,7,8].include?(t.month)
      bot.profile.avatar=(File.open('C:/Users/Mini-Matt/Desktop/devkit/Elise(Summer).png','r')) rescue nil
    else
      bot.profile.avatar=(File.open('C:/Users/Mini-Matt/Desktop/devkit/BaseElise.jpg','r')) rescue nil
    end
    @scheduler.at "#{k[0][0]}/#{k[0][1]}/#{k[0][2]} 0000" do
      next_holiday(bot,1)
    end
  end
end

bot.run
