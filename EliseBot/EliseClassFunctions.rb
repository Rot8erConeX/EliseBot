$stored_event=[]
@zero_by_four=[0,0,0]

def help_text(event,bot,command=nil,subcommand=nil)
  command='' if command.nil?
  k=0
  k=event.server.id unless event.server.nil?
  if ['help','commands','command_list','commandlist'].include?(command.downcase)
    event.respond "The `#{command.downcase}` command displays this message:"
    command=''
  end
  if command.downcase=='reboot'
    create_embed(event,'**reboot**',"Reboots this shard of the bot, installing any updates.\n\n**This command is only able to be used by Rot8er_ConeX**",0x008b8b)
  elsif ['update'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Shows my data input person how to remotely update for during the period where my developer is gone.',0xED619A)
  elsif command.downcase=='sendmessage'
    create_embed(event,'**sendmessage** __channel id__ __*message__',"Sends the message `message` to the channel with id `channel`\n\n**This command is only able to be used by Rot8er_ConeX**, and only in PM.",0x008b8b)
  elsif command.downcase=='sendpm'
    create_embed(event,'**sendpm** __user id__ __*message__',"Sends the message `message` to the user with id `user`\n\n**This command is only able to be used by Rot8er_ConeX**, and only in PM.",0x008b8b)
  elsif command.downcase=='ignoreuser'
    create_embed(event,'**ignoreuser** __user id__',"Causes me to ignore the user with id `user`\n\n**This command is only able to be used by Rot8er_ConeX**, and only in PM.",0x008b8b)
  elsif command.downcase=='leaveserver'
    create_embed(event,'**leaveserver** __server id number__',"Forces me to leave the server with the id `server id`.\n\n**This command is only able to be used by Rot8er_ConeX**, and only in PM.",0x008b8b)
  elsif command.downcase=='snagstats'
    subcommand='' if subcommand.nil?
    if ['server','servers','member','members','shard','shards','users','user'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**",'Returns the number of servers and unique members each shard reaches.',0x40C0F0)
    elsif ['alts','alt','alternate','alternates','alternative','alternatives'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**",'Returns the number of units within each type of alt, as well as specifics about characters with the most alts.',0x40C0F0)
    elsif ['hero','heroes','heros','unit','char','character','units','chars','charas','chara'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of units sorted in each of the following ways:\n- Obtainability\n- Color\n- Weapon type\n- Movement type\n- Game of origin (in PM)",0x40C0F0)
    elsif ['skills','skill','weapon','weapons','assist','assists','special','specials','passive','passives'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**",'Returns the number of skills, as well as numbers condensing them into branches (same name with different number) and trees (all skills that promote into/from each other are a single entry).',0x40C0F0)
    elsif ['structures','structure','structs','struct'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of structures, as well as the number of structure-levels, in each of the main categories:\n- Offensive\n- Defensive\n- Trap\n- Resource\n- Ornament",0x40C0F0)
    elsif ['accessories','accessorie','accessorys','accessory'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of accessories, sorted in each of the following ways:\n- Position of placement on units who equip it\n- Methods of obtainment",0x40C0F0)
    elsif ['item','items'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of items, sorted by type of item.",0x40C0F0)
    elsif ['alias','aliases','name','names','nickname','nicknames'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of aliases in each of the main categories:\n- Unit (global single-unit, server-specific [single], and [global] multi)\n- Skill (global single-skill, server-specific [single], and [global] multi)\n- Structure (global and server-specific)\n- Accessory (global and server-specific)\n- Item (global and server-specific)\n\nAlso returns specifics about the most frequent instances of each category",0x40C0F0)
    elsif ['groups','group','groupings','grouping'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the number of groups in each of the two categories - global and server-specific.\nAlso returns specifics about the dynamically-created global groups.",0x40C0F0)
    elsif ['code','lines','line','sloc'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Returns the specifics about my code, including number of commands and functions, as well as - if in PM - loops, statements, and conditionals.",0x40C0F0)
    else
      create_embed(event,"**#{command.downcase}**","Returns:\n- the number of servers I'm in\n- the numbers of units, skills, structures, accessories, and items in the game\n- the numbers of aliases of each type I keep track of\n- the numbers of groups I keep track of\n- how long of a file I am.\n\nYou can also include the following words to get more specialized data:\nServer(s), Member(s), Shard(s), User(s)\nUnit(s), Character(s), Char(a)(s)\nAlt(s)\nSkill(s)\nStructure(s), Struct(s)\nAccessory, Accessories\nItem(s)\nAlias(es), Name(s), Nickname(s)\nGroup(s), Grouping(s)\nCode, Line(s), SLOC#{"\n\nAs the bot developer, you can also include a server ID number to snag the shard number, owner, and my nickname in the specified server." if event.user.id==167657750971547648}",0x40C0F0)
    end
  elsif ['randomunit','randunit','unitrandom','unitrand','randomstats','statsrand','statsrandom','randstats'].include?(command.downcase) || (['random','rand'].include?(command.downcase) && ['hero','unit','stats'].include?("#{subcommand}".downcase)) || (['unit','stats'].include?(command.downcase) && ['random','rand'].include?("#{subcommand}".downcase))
    lookout=$origames.reject{|q| q[0].length>4 && q[0][0,4]=='FE14'}
    d=[]
    for i in 0...lookout.length
      d.push("**#{lookout[i][2].gsub("#{lookout[i][0]} - ",'').gsub(" (All paths)",'')}**\n#{lookout[i][1].join(', ')}")
    end
    if d.join("\n\n").length>=1900 || !safe_to_spam?(event)
      d=lookout.map{|q| q[0]}
      if d.length>50 && !safe_to_spam?(event)
        create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','hero','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_more_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, and game options can be displayed if you use this command in PM.",0xD49F61)
      else
        create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','hero','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_more_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, by using the words below.",0xD49F61)
        create_embed(event,'Games','',0x40C0F0,nil,nil,triple_finish(d))
      end
    else
      create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','hero','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_more_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, by using the words below.",0xD49F61)
      create_embed(event,'Games',d.join("\n\n"),0x40C0F0)
    end
  elsif command.downcase=='shard'
    create_embed(event,'**shard**','Returns the shard that this server is served by.',0x40C0F0)
  elsif ['bugreport','suggestion','feedback'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*message__",'PMs my developer with your username, the server, and the contents of the message `message`',0x40C0F0)
  elsif command.downcase=='invite'
    create_embed(event,'**invite**','PMs the invoker with a link to invite me to their server.',0x40C0F0)
  elsif command.downcase=='addalias'
    create_embed(event,'**addalias** __new alias__ __name__',"Adds `new alias` to `name`'s aliases.\nIf the arguments are listed in the opposite order, the command will auto-switch them.\n\nAliases can be added to:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- Structures\n- Accessories\n- Items\n\nInforms you if the alias already belongs to someone/something.\nAlso informs you if the unit you wish to give the alias to does not exist.\n\n**This command can only be used by server mods.**",0xC31C19)
  elsif command.downcase=='prefix'
    create_embed(event,'**prefix** __new prefix__',"Sets the server's custom prefix to `prefix`.\n\n**This command can only be used by server mods.**",0xC31C19)
  elsif ['oregano','whoisoregano','whyoregano'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Answers the question of who Oregano is.",0xD49F61)
  elsif ['allinheritance','allinherit','allinheritable','skillinheritance','skillinherit','skillinheritable','skilllearn','skilllearnable','skillsinheritance','skillsinherit','skillsinheritable','skillslearn','skillslearnable','inheritanceskills','inheritskill','inheritableskill','learnskill','learnableskill','inheritanceskills','inheritskills','inheritableskills','learnskills','learnableskills','all_inheritance','all_inherit','all_inheritable','skill_inheritance','skill_inherit','skill_inheritable','skill_learn','skill_learnable','skills_inheritance','skills_inherit','skills_inheritable','skills_learn','skills_learnable','inheritance_skills','inherit_skill','inheritable_skill','learn_skill','learnable_skill','inheritance_skills','inherit_skills','inheritable_skills','learn_skills','learnable_skills','inherit','learn','inheritance','learnable','inheritable','skillearn','skillearnable'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows all the skills that `name`can learn.\n\nIn servers, will only show the weapons, assists, and specials.\nIn PM, will also show the passive skills.",0xD49F61)
  elsif ['safe','spam','safetospam','safe2spam','long','longreplies'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __toggle__","Responds with whether or not the channel the command is invoked in is one in which I can send extremely long replies.\n\nIf the channel does not fill one of the many molds for acceptable channels, server mods can toggle the ability with the words \"on\" and \"off\".",0xD49F61)
  elsif ['data','hero','unit'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats, and skills.",0xD49F61)
  elsif ['attackicon','attackcolor','attackcolors','attackcolour','attackcolours','atkicon','atkcolor','atkcolors','atkcolour','atkcolours','atticon','attcolor','attcolors','attcolour','attcolours','staticon','statcolor','statcolors','statcolour','statcolours','iconcolor','iconcolors','iconcolour','iconcolours'].include?(command.downcase) || (['stats','stat'].include?(command.downcase) && ['color','colors','colour','colours'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['color','colors','colour','colours'].include?("#{subcommand}".downcase)}**","Explains the reasoning behind the multiple Attack stat icons - <:StrengthS:514712248372166666> <:MagicS:514712247289774111> <:FreezeS:514712247474585610>",0xD49F61)
  elsif ['divine','devine','code','path'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows all Divine Code paths that the unit named `name` can be found on.',0xD49F61)
  elsif ['struct','struncture'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows data on the Aether Raids or Mjolnir Strike structure named `name`.',0xD49F61)
  elsif ['aoe','area'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __type__","Shows the range of all AoE specials of the type `type`.\nIf `type` is unspecified in PM, shows the range of all AoE specials.",0xD49F61)
  elsif ['item'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows data on the item named `name`.',0xD49F61)
  elsif ['accessory','acc','accessorie'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows data on the accessory named `name`.',0xD49F61)
  elsif ['arena','arenabonus','arena_bonus','bonusarena','bonus_arena'].include?(command.downcase) || (['bonus'].include?(command.downcase) && ['arena'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['arena'].include?("#{subcommand}".downcase)}**",'Displays current and future Arena Bonus Units',0xD49F61)
  elsif ['tempest','tempestbonus','tempest_bonus','bonustempest','bonus_tempest','tt','ttbonus','tt_bonus','bonustt','bonus_tt'].include?(command.downcase) || (['bonus'].include?(command.downcase) && ['tempest','tt'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['tempest','tt'].include?("#{subcommand}".downcase)}**",'Displays current and future Tempest Trials Bonus Units',0xD49F61)
  elsif ['aetherbonus','aether_bonus','aethertempest','aether_tempest','raid','raidbonus','raid_bonus','bonusraid','bonus_raid','raids','raidsbonus','raids_bonus','bonusraids','aether','bonus_raids'].include?(command.downcase) || (['bonus'].include?(command.downcase) && ['aether','raid','raids'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['aether','raid','raids'].include?("#{subcommand}".downcase)}**",'Displays current and future Aether Raids Bonus Units',0xD49F61)
  elsif ['bonus'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Displays current and future Bonus Units for Arena, Tempest Trials, and Aether Raids.',0xD49F61)
  elsif ['skillrarity','skilrarity','onestar','twostar','threestar','fourstar','fivestar','skill_rarity','one_star','two_star','three_star','four_star','five_star'].include?(command.downcase) || (['skill'].include?(command.downcase) && ['rarity','rarities'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['rarity','rarities'].include?("#{subcommand}".downcase)}**",'Explains why some units have skills listed at lower rarities than they are available at.',0xD49F61)
  elsif ['color','colors','colour','colours'].include?(command.downcase) || (['skill'].include?(command.downcase) && ['color','colors','colour','colours'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['color','colors','colour','colours'].include?("#{subcommand}".downcase)}** __name__","Shows data on the skill `name`.\n\nIf the skill is a weapon that can be refined, also shows all possible refinements.\nIncluding the word \"default\" or \"base\" in these cases will make this command only show the default weapon.\nOn the flip side, including the word \"refined\" will make this command only show data on the refinements.\n\nThis version of the command causes the display to sort the units by color instead of rarity, allowing users to see what color they should summon when looking for a particular skill.",0xD49F61)
  elsif ['skill','skil'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows data on the skill `name`.\n\nIf the skill is a weapon that can be refined, also shows all possible refinements.\nIncluding the word \"default\" or \"base\" in these cases will make this command only show the default weapon.\nOn the flip side, including the word \"refined\" will make this command only show data on the refinements.\n\nFollowing the command with the word \"colo(u)rs\" will cause the display to sort the units by color instead of rarity, allowing users to see what color they should summon when looking for a particular skill.",0xD49F61)
  elsif ['tinystats','smallstats','smolstats','microstats','squashedstats','sstats','statstiny','statssmall','statssmol','statsmicro','statssquashed','statss','stattiny','statsmall','statsmol','statmicro','statsquashed','sstat','tinystat','smallstat','smolstat','microstat','squashedstat','tiny','small','micro','smol','squashed','littlestats','littlestat','statslittle','statlittle','little'].include?(command.downcase) || (['stat','stats'].include?(command.downcase) && ['tiny','small','micro','smol','squashed','little'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['stat','stats'].include?(command.downcase)}** __name__","Shows `name`'s stats.",0xD49F61)
    disp_more_info(event,-2) if safe_to_spam?(event)
  elsif ['big','tol','macro','large','huge','massive','giantstats','bigstats','tolstats','macrostats','largestats','hugestats','massivestats','giantstat','bigstat','tolstat','macrostat','largestat','hugestat','massivestat','statsgiant','statsbig','statstol','statsmacro','statslarge','statshuge','statsmassive','statgiant','statbig','stattol','statmacro','statlarge','stathuge','statmassive','statol'].include?(command.downcase) || (['stat','stats'].include?(command.downcase) && ['giant','big','tol','macro','large','huge','massive'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['stat','stats'].include?(command.downcase)}** __name__","Shows `name`'s weapon color/type, movement type, stats, skills, and all possible modifiers.",0xD49F61)
    disp_more_info(event) if safe_to_spam?(event)
  elsif ['stats','stat'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats.",0xD49F61)
    disp_more_info(event) if safe_to_spam?(event)
  elsif ['healstudy','studyheal','heal_study','study_heal','heal'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine how much is healed with each healing staff.',0xD49F61)
  elsif ['procstudy','studyproc','proc_study','study_proc','proc'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine how much extra damage is dealt when each Special skill procs.',0xD49F61)
  elsif ['phasestudy','studyphase','phase_study','study_phase','phase'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine the actual stats the unit has during combat.',0xD49F61)
    disp_more_info(event,-1) if safe_to_spam?(event)
  elsif ['study','statstudy','statsstudy','studystats'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the level 40 stats for the unit `name` for a combination of multiple rarities with 0, 5, and 10 merges.',0xD49F61)
  elsif ['summonpool','summon_pool','pool'].include?(command.downcase) || (['summon'].include?(command.downcase) && "#{subcommand}".downcase=='pool')
    create_embed(event,"**#{command.downcase}#{" pool" if command.downcase=='summon'}** __*colors__","Shows the summon pool for the listed color.\n\nIn PM, all colors listed will be displayed, or all colors if none are specified.\nIn servers, only the first color listed will be displayed.",0xD49F61)
  elsif (Summon_servers.include?(k) || [-1,4].include?(Shardizard)) && ['summon'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*colors__","Simulates summoning on a randomly-chosen banner.\n\nIf given `colors`, auto-cracks open any orbs of said colors.\nOtherwise, requires a follow-up response of numbers.\n\nYou can include the word \"current\" or \"now\" to force me to choose a banner that is currently available in-game.\nThe words \"upcoming\" and \"future\" allow you to force a banner that will be available in the future.\nYou can also include one or more of the words below to force the banner to fit into those categories.\n\n**This command is only available in certain servers**.",0x9E682C)
    w=$skilltags.reject{|q| q[2]!='Banner' || ['Current','Upcoming'].include?(q[0])}.map{|q| q[0]}.sort
    create_embed(event,'Banner types','',0x40C0F0,nil,nil,triple_finish(w)) if safe_to_spam?(event) || w.length<=50
  elsif ['effhp','eff_hp'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the effective HP data for the unit `name`.',0xD49F61)
  elsif ['pair','pairup','pair_up','pocket'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the stats the unit `name` gives to the main unit when `name` is the cohort in a Pair-Up pair.',0xD49F61)
    disp_more_info(event,-3) if safe_to_spam?(event)
  elsif ['natures'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a chart with my nature names.',0xD49F61)
  elsif ['growths','growth','gps','gp'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a chart and explanation on how growths work, and how this creates what the fandom has dubbed "superboons" and "superbanes".',0xD49F61)
  elsif ['merges'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with an explanation on how stats are affected by merging units.',0xD49F61)
  elsif ['score'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Responds with an explanation on how a unit's Arena Score is calculated.",0xD49F61)
  elsif ['flowers','flower'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a link to a page with a random flower.',0xD49F61)
  elsif ['donation','donate'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with information regarding potential donations to my developer.',0xD49F61)
  elsif ['headpat'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Causes the invoker to try to headpat me.',0xD49F61)
  elsif ['tools','links','tool','link','resources','resources'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a list of links useful to players of *Fire Emblem Heroes*.',0xD49F61)
  elsif ['alts','alt'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Responds with a list of alts that the character has in *Fire Emblem Heroes*.',0xD49F61)
  elsif ['skills','skils','fodder','manual','book','combatmanual'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and skills.\nYou can also include a rarity to show the skills that the unit learns at that rarity.",0xD49F61)
  elsif ['embed','embeds'].include?(command.downcase)
    event << '**embed**'
    event << ''
    event << 'Toggles whether I post as embeds or plaintext when the invoker triggers a response from me.  By default, I display embeds for everyone.'
    event << 'This command is useful for people who, in an attempt to conserve phone data, disable the automatic loading of images, as this setting also affects their ability to see embeds.'
    unless $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event << ''
      event << 'This help window is not in an embed so that people who need this command can see it.'
    end
    return nil
  elsif ['aliases','checkaliases','seealiases','alias'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Responds with a list of all `names`'s aliases.\nIf no name is listed, responds with a list of all aliases and who/what they are for.\n\nAliases can be added to:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- Structures\n- Accessories\n- Items\n\nPlease note that if more than 50 aliases are to be listed, I will - for the sake of the sanity of other server members - only allow you to use the command in PM.",0xD49F61)
  elsif ['saliases','serveraliases'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Responds with a list of all `names`'s server-specific aliases.\nIf no name is listed, responds with a list of all server-specific aliases and who/what they are for.\n\nAliases can be added to:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- Structures\n- Accessories\n- Items\n\nPlease note that if more than 50 aliases are to be listed, I will - for the sake of the sanity of other server members - only allow you to use the command in PM.",0xD49F61)
  elsif ['daily','dailies','today','todayinfeh','today_in_feh','now'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Shows the day's in-game daily events.\nIf in PM, will also show tomorrow's.",0xD49F61)
  elsif ['next','schedule'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __type__","Shows the next time in-game daily events of the type `type` will happen.\nIf in PM and `type` is unspecified, shows the entire schedule.\n\n__*Accepted Inputs*__\nTower, Training_Tower, Color, Shard, Crystal\nFree, 1\\*, 2\\*, F2P, FreeHero\nSpecial, Special_Training\nGHB\nGHB2\nRival, Domain(s), RD, Rival_Domain(s)\nBlessed, Garden(s), Blessing, Blessed_Garden(s)\nTactics_Drills, Tactic(s), Drill(s)\nBanner(s), Summon(ing)(s)\nEvent(s)\nLegendary/Legendaries, Legend(s)\nArena, ArenaBonus, Arena_Bonus\nTempest, TempestBonus, Tempest_Bonus\nBonus\nBook1, Book1Revival\nDivine, Path, Ephemura",0xD49F61)
  elsif ['deletealias','removealias'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __alias__","Removes `alias` from the list of aliases, regardless of who/what it was for.\n\n**This command can only be used by server mods.**",0xC31C19)
  elsif ['addmultialias','adddualalias','addualalias','addmultiunitalias','adddualunitalias','addualunitalias','multialias','dualalias','addmulti'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__ __\*members__","If there is already a multi-unit alias named `name`, adds `members` to it.\nIf there is not already a multi-unit alias with the name `name`, makes one and adds `members` to it.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['addgroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__ __\*members__","If there is already a group named `name`, adds `members` to it.\nIf there is not already a group with the name `name`, makes one and adds `members` to it.\n\n**This command can only be used by server mods.**",0xC31C19)
  elsif ['seegroups','groups','checkgroups'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Shows all the existing groups, and their members.',0xD49F61)
  elsif ['deletegroup','removegroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Removes the group with the name `name`\n\n**This command can only be used by server mods.**",0xC31C19)
  elsif ['removemember','removefromgroup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __group__ __unit__","Removes the unit `unit` from the group with the name `group`.\nIf this causes `group` to have no members, it will also delete it.\n\n**This command can only be used by server mods.**",0xC31C19)
  elsif ['bst'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*allies__","Shows the BST of the units listed in `allies`.  If more than four characters are listed, I show both the BST of all those listed and the BST of the first four listed.\n\n#{disp_more_info(event,1)}",0xD49F61)
  elsif ['effect'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Lists all weapons that can be refined to obtain an Effect Mode in the weapon refinery.',0xD49F61)
  elsif ['refinery','refine'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Lists all weapons that can be refined or evolved in the weapon refinery, organized by whether they use Divine Dew or Refining Stones.\n\nYou can also include the word \"Effect\" in your message to show only weapons that get Effect Mode refines.",0xD49F61)
  elsif ['prf','prfs'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Lists all skills that are PRF to one or more units.",0xD49F61)
  elsif ['legendary','legendaries','mythic','mythicals','mythics','mythicals','mystics','mystic','mysticals','mystical','legend','legends','legendarys'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Lists all of the Legendary and Mythic heroes, sorted by up to three defined filters.\nBy default, will sort by __Element__ and then the non-HP __stat__ boost given by the hero.\n\nPossible filters (in order of priority when applied) :\nElement(s), Flavor(s), Affinity/Affinities\nStat(s), Boost(s)\nWeapon(s)\nColo(u)r(s)\nMove(s), Movement(s)\nNext, Time, Future, Month(s)",0xD49F61)
  elsif ['games'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows a list of games that the unit `name` is in.',0xD49F61)
  elsif ['banners','banner'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows a list of banners that the unit `name` has been a focus unit on.',0xD49F61)
  elsif ['rand','random'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__",'Generates a random unit with random, but still valid, stats.',0xD49F61)
  elsif ['compare','comparison'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*allies__","Compares the units listed in `allies`.  Shows each set of stats, as well as an analysis.\nThis command can compare anywhere between two and ten units.\n\n#{disp_more_info(event,1)}",0xD49F61)
  elsif ['compareskills','compareskill','skillcompare','skillscompare','comparisonskills','comparisonskill','skillcomparison','skillscomparison','compare_skills','compare_skill','skill_compare','skills_compare','comparison_skills','comparison_skill','skill_comparison','skills_comparison','skillsincommon','skills_in_common','commonskills','common_skills'].include?(command.downcase)
    # u=random_dev_unit_with_nature(event,false)
    create_embed(event,"**#{command.downcase}** __*allies__","Compares the units listed in `allies`.  Shows the skills that the units have in common.\nThis command can compare exactly two units.\n\n#{disp_more_info(event,1)}",0xD49F61)
  elsif ['average','mean'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then calculates their average in each stat.\n\n#{disp_more_info(event,2)}",0xD49F61)
  elsif ['art','artist'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __unit__ __art type__","Displays `unit`'s character art.  Defaults to their normal portrait, but can be adjusted to other portraits with the following words:\n*Default Attacking Image:* Battle/Battling, Attack/Atk/Att\n*Special Proc Image:* Critical/Crit, Special, Proc\n*Damaged Art:* Damage/Damaged, LowHP/LowHealth, Injured\n*In-game Sprite:* Sprite (only available for units who have profiles on the official website)",0xD49F61)
  elsif ['bestamong','bestin','beststats','higheststats','highest','best','highestamong','highestin'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the best in each stat.\n\n#{disp_more_info(event,2)}",0xD49F61)
  elsif ['worstamong','worstin','worststats','loweststats','lowest','lowestamong','lowestin','worst'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the worst in each stat.\n\n#{disp_more_info(event,2)}",0xD49F61)
  elsif ['find','search','lookup'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['hero','heroes','heros','unit','char','character','person','units','chars','charas','chara','people'].include?(subcommand.downcase)
      lookout=$origames.reject{|q| q[0].length>4 && q[0][0,4]=='FE14'}
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
        lookout=$skilltags.map{|q| q}
        w=lookout.reject{|q| q[2]!='Weapon' || !q[4].nil?}.map{|q| q[0]}.sort
        w.push('Slaying')
        w.sort!
        p=lookout.reject{|q| q[2]!='Passive' || !q[4].nil?}.map{|q| q[0]}.sort
        w=w.reject{|q| q=='Hogtome'} unless !event.server.nil? && event.server.id==330850148261298176
        p=p.reject{|q| q=='Command'} unless !event.server.nil? && event.server.id==167657750971547648
        if w.join("\n").length+p.join("\n").length>=1950 || !safe_to_spam?(event)
          create_embed(event,'Weapon Flavors','',0x40C0F0,nil,nil,triple_finish(w))
          create_embed(event,'Passive Flavors','',0x40C0F0,nil,nil,triple_finish(p))
        else
          create_embed(event,'','',0x40C0F0,nil,nil,[['Weapon Flavors',w.join("\n")],['Passive Flavors',p.join("\n")]])
        end
      end
    elsif ['summon','summons','banner','banners'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all banners which match your defined filters, then displays the resulting list.",0xD49F61)
      w=$skilltags.reject{|q| q[2]!='Banner' || ['Current','Upcoming'].include?(q[0])}.map{|q| q[0]}.sort
      create_embed(event,'Banner types','',0x40C0F0,nil,nil,triple_finish(w)) if safe_to_spam?(event) || w.length<=50
    else
      create_embed(event,"**#{command.downcase}** __\*filters__","Combines the results of `FEH!find unit` and `FEH!find skill`, showing them in a single embed.  This combined form is particularly useful when looking at weapon types, so you can see all the weapons *and* all the units that can use them side-by-side.\n\n#{disp_more_info(event,4)}",0xD49F61)
    end
  elsif ['setmarker'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __letter__","Sets the server's \"marker\", allowing for server-specific custom units and skills.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['backup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __item__","Backs up the alias list or the group list, depending on the word used as `item`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['reload'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Reloads specified data.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['status','avatar','avvie'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Shows my current avatar, status, and reason for such.\n\nWhen used by my developer with a message following it, sets my status to that message.",0xD49F61)
  elsif ['edit'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['create'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*stats__","Allows me to create a new donor unit with the character `unit` and stats described in `stats`.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['promote','rarity','feathers'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","Causes me to promote the donor unit with the name `unit`.\n\nIf `number` is defined, I will promote the donor unit that many times.\nIf not, I will promote them once.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['remove','delete','send_home','sendhome','fodder'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Removes a unit from the donor units attached to the invoker.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['merge','combine'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","Causes me to merge the donor unit with the name `unit`.\n\nIf `number` is defined, I will merge the donor unit that many times.\nIf not, I will merge them once.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['flower','flowers','dragonflower','dragonflowers'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __number__","Causes me to equip the donor unit with the name `unit`, with an additional dragonflower.\n\nIf `number` is defined, I will equip that many dragonflowers.\nIf not, I will equip one.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['nature','ivs'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*effects__","Causes me to change the nature of the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['equip','skill'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill name__","Equips the skill `skill name` on the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['seal'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill name__","Equips the skill seal `skill name` on the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['refine','refinery','refinement'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*refinement__","Refines the weapon equipped by the donor unit with the name `unit`, using the refinement `refinement`\n\nIf no refinement is defined and the equipped weapon has an Effect Mode, defaults to that.\nOtherwise, throws an error message if no refinement is defined.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['unsupport','unmarry','unmarriage','divorce'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to remove the support rank of the donor unit with the name `unit`.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['support','marry','marriage'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to change the support rank of the donor unit with the name `unit`.  More than three donor units cannot have support.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['pairup','pair','pair-up','paired'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit1__ __unit2__","Allows me to pair up the two listed donor units.  This can be shown when looking up either unit alongside the term \"pairup\".\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['resplendant','resplendent','ascension','ascend','resplend'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to Resplendently Ascend the donor unit with the name `unit`.\nIf the donor unit cannot do so, I inform you of this.\nIf the donor unit is already Resplendently Ascended, toggles off their art but keeps their stats.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['kiranface','kiran','face','summoner','summonerface'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to edit the face used by the donor unit based on the summoner.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['forma'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to toggle the donor unit with the name `unit` into or out of being a Forma Unit.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    else
      create_embed(event,"**#{command.downcase}** __subcommand__ __unit__ __\*effects__","Allows me to create and edit the donor units.\n\nAvailable subcommands include:\n`FEH!#{command.downcase} create` - creates a new donor unit\n`FEH!#{command.downcase} promote` - promotes an existing donor unit (*also `rarity` and `feathers`*)\n`FEH!#{command.downcase} merge` - increases a donor unit's merge count (*also `combine`*)\n`FEH!#{command.downcase} nature` - changes a donor unit's nature (*also `ivs`*)\n`FEH!#{command.downcase} support` - causes me to change support ranks of donor units (*also `marry`*)\n`FEH!#{command.downcase} unsupport` - causes me to remove the support ranks of donor units (*also `divorce`*)\n\n`FEH!#{command.downcase} equip` - equip skill (*also `skill`*)\n`FEH!#{command.downcase} seal` - equip seal\n`FEH!#{command.downcase} refine` - refine weapon\n`FEH!#{command.downcase} flower` - increases a donor unit's dragonflower count\n`FEH!#{command.downcase} pairup` - pairs one donor unit up as another's cohort\n`FEH!#{command.downcase} resplendent` - Resplendently Ascends a donor unit\n`FEH!#{command.downcase} kiranface` - Edits the Kiran donor unit's face\n`FEH!#{command.downcase} forma` - gives a donor unit a Forma Soul\n\n`FEH!#{command.downcase} send_home` - removes the unit from the donor units attached to the invoker (*also `fodder` or `remove` or `delete`*)\n\n**This command is only able to be used by certain people**.",0x9E682C)
    end
  elsif ['devedit','dev_edit'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['create'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*stats__","Allows me to create a new devunit with the character `unit` and stats described in `stats`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['resplendant','resplendent','ascension','ascend','resplend'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to Resplendently Ascend the devunit with the name `unit`.\nIf the devunit cannot do so, I inform you of this.\nIf the devunit is already Resplendently Ascended, toggles off their art but keeps their stats.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['forma'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to toggle the devunit with the name `unit` into or out of being a Forma Unit.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['pairup','pair','pair-up','paired'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit1__ __unit2__","Allows me to pair up the two listed devunits.  This can be shown when looking up either unit alongside the term \"pairup\".\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
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
    elsif ['flower','flowers','dragonflower','dragonflowers'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","Causes me to equip the devunit with the name `unit`, with an additional dragonflower.\n\nIf `number` is defined, I will equip that many dragonflowers.\nIf not, I will equip one.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['nature','ivs'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*effects__","Causes me to change the nature of the devunit with the name `unit`\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['learn','teach'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill types__","Causes me to teach the skills in slots `skill types` to the devunit with the name `unit`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['kiranface','kiran','face','summoner','summonerface'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to edit the face used by the dev unit based on the summoner.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    else
      create_embed(event,"**#{command.downcase}** __subcommand__ __unit__ __\*effects__","Allows me to create and edit the devunits.\n\nAvailable subcommands include:\n`FEH!#{command.downcase} create` - creates a new devunit\n`FEH!#{command.downcase} promote` - promotes an existing devunit (*also `rarity` and `feathers`*)\n`FEH!#{command.downcase} merge` - increases a devunit's merge count (*also `combine`*)\n`FEH!#{command.downcase} nature` - changes a devunit's nature (*also `ivs`*)\n`FEH!#{command.downcase} teach` - teaches a new skill to a devunit (*also `learn`*)\n`FEH!#{command.downcase} flower` - increases a dev unit's dragonflower count\n`FEH!#{command.downcase} pairup` - pairs one devunit up as another's cohort\n`FEH!#{command.downcase} resplendent` - Resplendently Ascends a devunit\n`FEH!#{command.downcase} kiranface` - Edits the Kiran devunit's face\n`FEH!#{command.downcase} forma` - gives a devunit a Forma Soul\n\n`FEH!#{command.downcase} new_waifu` - adds a dev waifu (*also `add_waifu`*)\n`FEH!#{command.downcase} new_somebody` - adds a dev \"somebody\" (*also `add_somebody`*)\n`FEH!#{command.downcase} new_nobody` - adds a dev \"nobody\" (*also `add_nobody`*)\n\n`FEH!#{command.downcase} send_home` - removes the unit from either the devunits or the \"nobodies\" list (*also `fodder` or `remove` or `delete`*)\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    end
  elsif ['sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list in order based on their SP cost.\n\n#{disp_more_info(event,3)}",0xD49F61)
    if safe_to_spam?(event)
      lookout=$skilltags.map{|q| q}
      w=lookout.reject{|q| q[2]!='Weapon' || !q[4].nil?}.map{|q| q[0]}.sort
      w.push('Slaying')
      w.sort!
      p=lookout.reject{|q| q[2]!='Passive' || !q[4].nil?}.map{|q| q[0]}.sort
      w=w.reject{|q| q=='Hogtome'} unless !event.server.nil? && event.server.id==330850148261298176
      p=p.reject{|q| q=='Command'} unless !event.server.nil? && event.server.id==167657750971547648
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
    elsif ['stat','stats','hero','unit','units'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list in order based on the stats you include.\n\n#{disp_more_info(event,2)}",0xD49F61)
    elsif ['skills','skill'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list in order based on their SP cost.\n\n#{disp_more_info(event,3)}",0xD49F61)
      if safe_to_spam?(event)
        lookout=$skilltags.map{|q| q}
        w=lookout.reject{|q| q[2]!='Weapon' || !q[4].nil?}.map{|q| q[0]}.sort
        w.push('Slaying')
        w.sort!
        p=lookout.reject{|q| q[2]!='Passive' || !q[4].nil?}.map{|q| q[0]}.sort
        w=w.reject{|q| q=='Hogtome'} unless !event.server.nil? && event.server.id==330850148261298176
        p=p.reject{|q| q=='Command'} unless !event.server.nil? && event.server.id==167657750971547648
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
    str="__**Unit/Character Data**__"
    str="#{str}\n`data` __unit__ - shows both stats and skills (*also `unit`*)"
    str="#{str}\n`stats` __unit__ - shows only the stats"
    str="#{str}\n`bigstats` __unit__ - shows ths stats in a larger format (*also `macrostats`*)"
    str="#{str}\n`skills` __unit__ - shows only the skills (*also `fodder`*)"
    str="#{str}\n\n`aliases` __unit__ - show all aliases for the unit (*also `checkaliases` or `seealiases`*)"
    str="#{str}\n`serveraliases` __unit__ - show server-specific aliases for the unit"
    str="#{str}\n\n`study` __unit__ - for a study of the unit at multiple rarities and merges"
    str="#{str}\n`effHP` __unit__ - for a study of the unit's bulkiness (*also `bulk`*)"
    str="#{str}\n`healstudy` __unit__ - to see what how much each healing staff does (*also `studyheal`*)"
    str="#{str}\n`procstudy` __unit__ - to see what how much each damaging Special does (*also `studyproc`*)"
    str="#{str}\n`phasestudy` __unit__ - to see what the actual stats the unit has during combat (*also `studyphase`*)"
    str="#{str}\n`pairup` __unit__ - to see the stats the unit gives during pair-up (*also `pair`*)"
    str="#{str}\n~~The above commands are collectively referred to as \"the `study` suite\"~~"
    str="#{str}\n\n`banners` __unit__ - for a list of banners the unit has been a focus unit on"
    str="#{str}\n`art` __unit__ __art type__ - for the character's art"
    str="#{str}\n`learnable` __unit__ - for a list of all learnable skills (*also `inheritable`*)"
    str="#{str}\n\n`games` __character__ - for a list of games the character is in"
    str="#{str}\n`alts` __character__ - for a list of all units this character has"
    str="#{str}\n`path` __unit__ - for a list of all Divine Code paths the unit can be found in (*also `divine`*)"
    str="#{str}\n\n\n__**Skill Data**__"
    str="#{str}\n`skill` __skill name__ - used to show data on a specific skill"
    str="#{str}\n`AoE` __type__ - to show the range of all AoE skills (*also `area`*)"
    create_embed([event,x],"Global Command Prefixes: `FEH!` `FEH?` `F?` `E?` `H?`#{"\nServer Command Prefix: `#{@prefixes[event.server.id]}`" if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n__**Elise Bot help**__",str,0xD49F61)
    str="__**Additional Index Data**__"
    str="#{str}\n`structure` __structure name__ - used to show data on a specific structure"
    str="#{str}\n`accessory` __accessory name__ - used to show data on a specific accessory"
    str="#{str}\n`item` __item name__ - used to show data on a specific item"
    str="#{str}\n\n__**Current Events**__"
    str="#{str}\n`bonus` - used to list all Arena and TT bonus units (*also `arena`, `tt`, or `aether`*)"
    str="#{str}\n`today` - shows the current day's in-game daily events (*also `daily` or `todayInFEH`*)"
    str="#{str}\n`next` __type__ - to see a schedule of the next time in-game daily events will happen (*also `schedule`*)"
    str="#{str}\n\n__**Lists**__"
    str="#{str}\n`summonpool` __\\*colors__ - for a list of summonable units sorted by rarity (*also `pool`*)"
    str="#{str}\n`legendaries` __\\*filters__ - for a sorted list of all legendaries. (*also `legendary`*)"
    str="#{str}\n`mythics` __\\*filters__ - for a sorted list of all legendaries. (*also `mythic`, `mythical`, or `mythicals`*)"
    str="#{str}\n`refinery` - used to show a list of refineable weapons (*also `refine`*)"
    str="#{str}\n`prf` - used to show a list of PRF skills"
    str="#{str}\n\n__**Searches**__"
    str="#{str}\n`find` __\\*filters__ - used to generate a list of applicable units and/or skills (*also `search`*)"
    str="#{str}\n`sort` __\\*filters__ - used to create a list of applicable units and sort them based on specified stats"
    str="#{str}\n`average` __\\*filters__ - used to find the average stats of applicable units (*also `mean`*)"
    str="#{str}\n`bestamong` __\\*filters__ - used to find the best stats among applicable units (*also `bestin`, `beststats`, or `higheststats`*)"
    str="#{str}\n`worstamong` __\\*filters__ - used to find the worst stats among applicable units (*also `worstin`, `worststats`, or `loweststats`*)"
    str="#{str}\n\n__**Comparisons**__"
    str="#{str}\n`compare` __\\*allies__ - compares units' stats (*also `comparison`*)"
    str="#{str}\n`compareskills` __\\*allies__ - compares units' skills"
    str="#{str}\n\n__**Other Data**__"
    str="#{str}\n`bst` __\\*allies__"
    create_embed([event,x],"",str,0xD49F61)
    str="__**Meta data**__"
    str="#{str}\n`tools` - for a list of tools aside from me that may aid you"
    str="#{str}\n\n`aliases` - show all aliases (*also `checkaliases` or `seealiases`*)"
    str="#{str}\n`serveraliases` - show server-specific aliases"
    str="#{str}\n`groups` (*also `checkgroups` or `seegroups`*) - for a list of all unit groups"
    str="#{str}\n\n`natures` - for help understanding my nature names"
    str="#{str}\n`growths` - for help understanding how growths work (*also `gps`*)"
    str="#{str}\n`merges` - for help understanding how merges work"
    str="#{str}\n`score` - for help understanding how Arena Score is calculated"
    str="#{str}\n`skillrarity` - explains why characters have skills at lower than expected rarities (*also `skill_rarity`*)"
    str="#{str}\n`attackcolor` - for a reason for multiple Atk icons (*also `attackicon`*)"
    str="#{str}\n\n`invite` - for a link to invite me to your server"
    str="#{str}\n\n`random` - generates a random unit (*also `rand`*)"
    str="#{str}\n\n\n__**Developer Information**__"
    str="#{str}\n`avatar` - to see why my avatar is different from the norm"
    str="#{str}\n\n`bugreport` __\\*message__ - to send my developer a bug report"
    str="#{str}\n`suggestion` __\\*message__ - to send my developer a feature suggestion"
    str="#{str}\n`feedback` __\\*message__ - to send my developer other kinds of feedback"
    str="#{str}\n~~the above three commands are actually identical, merely given unique entries to help people find them~~"
    str="#{str}\n\n`donation` (*also `donate`*) - for information on how to donate to my developer"
    str="#{str}\n`whyelise` - for an explanation as to how Elise was chosen as the face of the bot"
    str="#{str}\n`snagstats` __type__ - to receive relevant bot stats"
    str="#{str}\n`spam` - to determine if the current location is safe for me to send long replies to (*also `safetospam` or `safe2spam`*)"
    str="#{str}\n\n__**Server-specific command**__\n`summon` \\*colors - to simulate summoning on a randomly-chosen banner" if !event.server.nil? && Summon_servers.include?(event.server.id)
    create_embed([event,x],"",str,0xD49F61)
    str="__**Aliases**__"
    str="#{str}\n`addalias` __new alias__ __target__ - Adds a new server-specific alias"
    str="#{str}\n~~`aliases` __target__ (*also `checkaliases` or `seealiases`*)~~"
    str="#{str}\n~~`serveraliases` __target__ (*also `saliases`*)~~"
    str="#{str}\n`deletealias` __alias__ (*also `removealias`*) - deletes a server-specific alias"
    str="#{str}\n\n__**Groups**__"
    str="#{str}\n`addgroup` __name__ __\\*members__ - adds a server-specific group"
    str="#{str}\n~~`groups` (*also `checkgroups` or `seegroups`*)~~"
    str="#{str}\n`deletegroup` __name__ (*also `removegroup`*) - Deletes a server-specific group"
    str="#{str}\n`removemember` __group__ __unit__ (*also `removefromgroup`*) - removes a single member from a server-specific group"
    str="#{str}\n\n__**Channels**__"
    str="#{str}\n`spam` __toggle__ - to allow the current channel to be safe to send long replies to (*also `safetospam` or `safe2spam`*)"
    str="#{str}\n\n__**Customization**__"
    str="#{str}\n`prefix` __chars__ - to create or edit the server's custom command prefix"
    create_embed([event,x],"__**Server Admin Commands**__",str,0xC31C19) if is_mod?(event.user,event.server,event.channel)
    str="`devedit` __subcommand__ __unit__ __\\*effect__"
    str="#{str}\n\n__**Mjolnr, the Hammer**__"
    str="#{str}\n`ignoreuser` __user id number__ - makes me ignore a user"
    str="#{str}\n`leaveserver` __server id number__ - makes me leave a server"
    str="#{str}\n\n__**Communication**__"
    str="#{str}\n`status` __\\*message__ - sets my status"
    str="#{str}\n`sendmessage` __channel id__ __\\*message__ - sends a message to a specific channel"
    str="#{str}\n`sendpm` __user id number__ __\\*message__ - sends a PM to a user"
    str="#{str}\n\n__**Server Info**__"
    str="#{str}\n`snagstats` - snags relevant bot stats"
    str="#{str}\n`setmarker` __letter__"
    str="#{str}\n\n__**Shards**__"
    str="#{str}\n`reboot` - reboots this shard"
    str="#{str}\n\n__**Meta Data Storage**__"
    str="#{str}\n`reload` - reloads the unit and skill data"
    str="#{str}\n`backup` __item__ - backs up the (alias/group) list"
    str="#{str}\n`sort aliases` - sorts the alias list alphabetically by unit"
    str="#{str}\n`sort groups` - sorts the group list alphabetically by group name"
    str="#{str}\n\n__**Multi-unit Aliases**__"
    str="#{str}\n`addmulti` __name__ __\\*units__ - to create a multi-unit alias"
    create_embed([event,x],"__**Bot Developer Commands**__",str,0x008b8b) if event.user.id==167657750971547648 && (x==1 || safe_to_spam?(event))
    event.respond "If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nGlobal Command Prefixes: `FEH!` `FEH?` `F?` `E?` `H?`#{"\nServer Command Prefix: `#{@prefixes[event.server.id]}`" if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n\nWhen looking up a character or skill, you also have the option of @ mentioning me in a message that includes that character/skill's name" unless x==1
    event.user.pm("If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nGlobal Command Prefixes: `FEH!` `FEH?` `F?` `E?` `H?`#{"\nServer Command Prefix: `#{@prefixes[event.server.id]}`" if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n\nWhen looking up a character or skill, you also have the option of @ mentioning me in a message that includes that character/skill's name") if x==1
    event.respond "A PM has been sent to you.\nIf you would like to show the help list in this channel, please use the command `FEH!help here`." if x==1
  end
end

def disp_more_info(event,mode=0) # used by the `help` command to display info that repeats in multiple help descriptions.
  if mode<1
    str="You can modify the unit by including any of the following in your message:"
    str="#{str}\n\n**Rarity**"
    str="#{str}\nProper format: #{rand(Max_rarity_merge[0])+1}\\*"
    str="#{str}\n~~Alternatively, the first number not given proper context will be set as the rarity value unless the rarity value is already defined~~"
    str="#{str}\nDefault: 5\\* unit"
    str="#{str}\n\n**Merges**"
    str="#{str}\nProper format: +#{rand(Max_rarity_merge[1])+1}"
    str="#{str}\n~~Alternatively, the second number not given proper context will be set as the merges value unless the merges value is already defined~~"
    str="#{str}\nDefault: +0"
    str="#{str}\n\n**Boon**"
    str="#{str}\nProper format: +#{['Atk','Spd','Def','Res','HP'].sample}"
    str="#{str}\n~~Alternatively, the first stat name not given proper context will be set as the boon unless the boon is already defined~~"
    str="#{str}\nDefault: No boon"
    str="#{str}\n\n**Bane**"
    str="#{str}\nProper format: -#{['Atk','Spd','Def','Res','HP'].sample}"
    str="#{str}\n~~Alternatively, the second stat name not given proper context will be set as the bane unless the bane is already defined~~"
    str="#{str}\nDefault: No bane"
    unless mode==-2
      str="#{str}\n\n**Weapon**"
      str="#{str}\nProper format: Silver Dagger+ ~~just the weapon's name~~"
      str="#{str}\nDefault: No weapon"
      unless mode==-3
        str="#{str}\n\n**Arena/Aether Raids/Tempest Trials+ Bonus Unit Buff**"
        str="#{str}\nProper format: Bonus"
        str="#{str}\nSecondary format: Arena, Aether, Tempest"
        str="#{str}\nDefault: Not applied"
      end
      str="#{str}\n\n**Summoner Support**"
      str="#{str}\nProper format: #{['C','B','A','S'].sample} ~~Just a single letter~~"
      str="#{str}\nDefault: No support"
      str="#{str}\n\n**Dragonflower stats**"
      str="#{str}\nProper format: Flower#{rand(5)+1}"
      str="#{str}\nSecondary format: F#{rand(5)+1}"
      str="#{str}\nTertiary format: +#{rand(5)+1} ~~If merges are already accounted for~~"
      str="#{str}\nDefault: No flower stats"
      str="#{str}\nNote: The string \"Df\" will automatically equip the maximum number of flowers, as will the long word \"Dragonflower\".  The word \"Flower\" used to work, but then Peony<:Light_Tome:499760605381787650><:Icon_Move_Flier:443331186698354698><:Legendary_Effect_Light:521910176870039552><:Ally_Boost_Speed:443331186253889546><:Assist_Music:454462054959415296> and her weapon happened."
      create_embed(event,"",str,0x40C0F0)
      str="**Beast transformation**"
      str="#{str}\nBeast units, when equipped with a weapon, can take two forms."
      str="#{str}\nProper format: transformed ~~just include the word~~"
      str="#{str}\nSecondary format: (T)"
      str="#{str}\nDefault: Not applied, resulting in humanoid form"
      str="#{str}\n\n**Refined Weapon**"
      str="#{str}\nProper format: Falchion (+) #{['Atk','Spd','Def','Res','Effect'].sample}"
      str="#{str}\nSecondary format: Falchion #{['Atk','Spd','Def','Res','Effect'].sample} Mode"
      str="#{str}\nTertiary format: Falchion (#{['Atk','Spd','Def','Res','Effect'].sample})"
      str="#{str}\n~~Alternatively, the third stat name not given proper context, or the second stat given a + in front of it, will be set as the refinement for the weapon if one is equipped and it can be refined~~"
      str="#{str}\n\n**Stat-affecting skills**"
      str="#{str}\nOptions: HP+, Atk+, Spd+, Def+, Res+, LifeAndDeath/LnD/LaD, Fury, FortressDef, FortressRes"
      str="#{str}\n~~LnD, Fury, and the Fortress skills default to tier 3, but other tiers can be applied by including numbers like so: LnD1~~"
      str="#{str}\nDefault: No skills applied"
      unless mode==-3
        str="#{str}\n\n**Stat-buffing skills**"
        str="#{str}\nOptions: Rally skills, Defiant skills, Hone/Fortify skills, Balm skills, Even/Odd Atk/Spd/Def/Res Wave"
        str="#{str}\n~~please note that the skill name must be written out without spaces~~"
        str="#{str}\nDefault: No skills applied"
        str="#{str}\n\n**Stat-nerfing skills**"
        str="#{str}\nOptions: Smoke skills, Seal skills, Threaten skills, Chill skills, Ploy skills"
        str="#{str}\n~~please note that the skill name must be written out without spaces~~"
        str="#{str}\nDefault: No skills applied"
      end
      if mode==-1
        str="#{str}\n\n**In-combat buffs**"
        str="#{str}\nOptions: Blow skills, Stance/Breath skills, Bond skills, Brazen skills, Close/Distant Def, Fire/Wind/Earth/Water Boost"
        str="#{str}\n~~please note that the skill name must be written out without spaces~~"
        str="#{str}\nDefault: No skills applied"
        str="#{str}\n\n**Defensive Terrain boosts**"
        str="#{str}\nProper format: DefTile"
        str="#{str}\nDefault: Not applied"
      end
      unless mode==-3
        create_embed(event,"",str,0x40C0F0)
        str="**Stat buffs from Legendary Hero/Blessing interaction**"
        str="#{str}\nProper format: #{['Atk','Spd','Def','Res'].sample} Blessing ~~following the stat buffed by the word \"blessing\"~~"
        str="#{str}\nSecondary format: #{['Atk','Spd','Def','Res'].sample}Blessing ~~no space~~, Blessing#{['Atk','Spd','Def','Res'].sample}"
        str="#{str}\nDefault: No blessings applied"
        str="#{str}\n**Stat buffs from Mythic Hero/Blessing interaction**"
        str="#{str}\nProper format: #{['Atk','Spd','Def','Res'].sample} Blessing2 ~~following the stat buffed by the word \"blessing\"~~"
        str="#{str}\nSecondary format: #{['Atk','Spd','Def','Res'].sample}Blessing2 ~~no space~~, Blessing#{['Atk','Spd','Def','Res'].sample}2"
        str="#{str}\nDefault: No blessings applied"
        str="#{str}\n**The above two cannot be applied simultaneously.  All blessings will convert to whichever type is the first one listed in your message.**"
      end
      str="#{str}\n\nThese can be listed in any order."
    end
    create_embed(event,"",str,0x40C0F0)
  elsif mode==1
    u=[$dev_units,$donor_units].flatten.reject{|q| q.boon==' ' || q.bane==' ' || q.boon=='' || q.bane==''}.sample.clone
    return "**IMPORRTANT NOTE**\nUnlike my other commands, this one is heavily context based.  Please format all allies like the example below:\n```#{u.rarity}* #{u.name} +#{u.merge_count} +#{u.boon} -#{u.bane} +#{u.dragonflowers}``` (first +# is merges, second is dragonflowers)\nAny field with the exception of unit name can be ignored, but unlike my other commands the order is important."
  elsif [2,3,4].include?(mode)
    str="__**Allowed#{" unit" if mode==2}#{" skill" if mode==3} descriptions**__"
    str="#{str}\n*Colors*: Red(s), Blue(s), Green(s), Colo(u)rless(es), Gray(s), Grey(s)"
    str="#{str}\n*Weapon Types*: Physical, Blade(s), Tome(s), Mage(s), Spell(s), Dragon(s), Manakete(s), Breath, Bow(s), Arrow(s), Archer(s), Dagger(s), Shuriken, Knive(s), Ninja(s), Thief/Thieves, Healer(s), Cleric(s), Staff/Staves, Beast(s), Laguz"
    str="#{str}\n*Combined color and weapon type*: Sword(s), Katana, Spear(s), Lance(s), Naginata, Axe(s), Ax, Club(s), Redtome(s), Redmage(s), Bluetome(s), Bluemage(s), Greentome(s), Greenmage(s)"
    str="#{str}\n\n*Movement*: Flier(s), Flyer(s), Flying, Pegasus/Pegasi, Wyvern(s), Cavalry, Cavalier(s), Cav(s), Horse(s), Pony/Ponies, Horsie(s), Infantry, Foot/Feet, Armo(u)r(s), Armo(u)red" if mode==2
    str="#{str}\n\n*Assists*: Health, HP, Move, Movement, Moving, Arrangement, Positioning, Position(s), Healer(s), Staff/Staves, Cleric(s), Rally/Rallies, Stat(s), Buff(s)" if mode==3
    str="#{str}\n\n*Specials*: Healer(s), Staff/Staves, Cleric(s), Balm(s), Defense/Defence, Defensive/Defencive, Damage, Damaging, Proc, AoE, Area, Spread" if mode==3
    str="#{str}\n\n*Passive*: A, B, C, S, W, Seal(s)" if mode==3
    return str
  end
  return nil
end

class FEHUnit
  def dragonflowerMax
    return 15 if !@fake.nil? && @id>=1200 && @movement=='Infantry' # Penumbra units are counted as Book 1-2
    return 10 unless @fake.nil? # All other fake units are counted as Book 3+
    return 5 if @id>560 || @availability[0].include?('XF')
    return 15 if @availability[0].include?('PF') && @movement=='Infantry'
    return 10
  end
  
  def dragonflowerEmote
    flwr='<:Dragonflower_Purple:552648232673607701>'
    flwr='<:Dragonflower_Infantry:541170819980722176>' if @movement=='Infantry'
    flwr='<:Dragonflower_Flier:541170820089774091>' if @movement=='Flier'
    flwr='<:Dragonflower_Cavalry:541170819955556352>' if @movement=='Cavalry'
    flwr='<:Dragonflower_Armor:541170820001824778>' if @movement=='Armor'
    flwr='<:Clover:575230371587948568>' if @games[0]=='DL'
    flwr='<:Final_Fragment:575255136012730368>' if @games[0]=='FGO'
    return flwr
  end
  
  def portrait(artype='Face',resp=false)
    return 'https://i.redd.it/pdeqrncp21r01.png' if @name=='Reinhardt(World)' && artype.length<=0
    charza=@name.gsub(' ','_')
    charza="#{charza}_Resplendent" if resp && artype=='Sprite'
    charza="#{charza}/Resplendent" if resp && artype != 'Sprite'
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Sprites/#{charza}.png" if artype=='Sprite'
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{charza}/#{artype}/Face.png" if @name=='Kiran'
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{charza}/#{artype}.png"
  end
  
  def pronoun(possessive=nil)
    return 'he' if @gender=='M' && possessive==false
    return 'she' if @gender=='F' && possessive==false
    return 'his' if @gender=='M' && possessive==true
    return 'him' if @gender=='M'
    return 'her' if @gender=='F'
    return 'their' if possessive==true
    return 'they' if possessive==false
    return 'them'
  end
  
  def stats40x(val); @stats40=val; end
  
  def hasDuelAccess?(xlevel=0)
    return false unless @duo.nil? || @duo[0][0]=='Harmonic'
    return false if !@legendary.nil? && (@legendary[1]=='Duel' || xlevel>3)
    s=$skills.find_index{|q| q.name=="#{self.weapon_color[0,1]} Duel #{@movement.gsub('Flier','Flying')}"}
    s=$skills.find_index{|q| q.name=="#{self.weapon_color[0,1]} Duel #{@movement.gsub('Flier','Flying')}" && q.level==xlevel} if xlevel>0
    return false if s.nil?
    return true
  end
  
  def isRevival?
    return false if !@availability[0].include?('TD')
    return false if @id<319
    return true
  end
  
  def is4Special?
    return false if !@availability[0].include?('TD')
    return true if @id<319
    return false
  end
end

class SuperUnit
  def pronoun(possessive=nil)
    @gender=@face[0] unless @face.nil? || @face=='Default'
    return super(possessive)
  end
end

class DevUnit
  def portrait(artype='Face',resp=false)
    return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Sprites/Alm(Saint)_Mathoo.png' if @name=='Alm(Saint)' && artype=='Sprite'
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{@name}/#{@face}/Face.png" if @name=='Kiran' && !@face.nil?
    artype="#{artype}_Mathoo" if @name=='Alm(Saint)'
    x=false
    x=true if @resplendent.downcase=='r'
    return super(artype,x)
  end
  
  def sortPriority
    return 52 if @name=='Sakura'
    return 51 if @name=='Bernie'
    return 50 if @name=='Mirabilis'
    return 40 if ['Sakura','Bernie','Cordelia','Mirabilis'].include?(@cohort)
    return 30 if @name=='Kiran'
    return 21 unless @support.nil? || @support.length<=0 || @support=='-'
    return 20 unless @true_support.nil? || @true_support.length<=0 || @true_support=='-'
    return 11 if ['Fjorm(Bride)','Cordelia(Bride)'].include?(@name)
    return 10 if ['Sakura','Bernie','Alm','Cordelia','Mirabilis'].include?(@alts[0])
    return 0
  end
end

class DonorUnit
  def portrait(artype='Face',resp=false)
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{@name}/#{@face}/Face.png" if @name=='Kiran' && !@face.nil?
    x=false
    x=true if @resplendent.downcase=='r'
    return super(artype,x)
  end
  
  def sortPriority
    return 3 unless @support.nil? || @support.length<=0 || @support=='-'
    return 4 unless @true_support.nil? || @true_support.length<=0 || @true_support=='-'
    return 0
  end
end

class FEHSkill  
  def legalize(unit)
    if ['Robin','Robin (shared stats)','Kris','Kris (shared stats)'].include?(unit.name)
      x=unit.name.split(' (')[0]
      x=[$units.find_index{|q| q.name=="#{x}(M)"},$units.find_index{|q| q.name=="#{x}(F)"}]
      x=x.compact.map{|q| $units[q]}
      return x.map{|q| self.legalize(q)}
    end
    nme=nil
    nrse=false
    if @name=='Falchion'
      if unit.games.nil? || unit.games.length<=0
      elsif unit.from_game('FE13',true)
        nme='Falchion (Awakening)'
      elsif unit.from_game(['FE2','FE15'],true)
        nme='Falchion (Valentia)'
      elsif unit.from_game(['FE1','FE3','FE11','FE12'],true)
        nme='Falchion (Mystery)'
      elsif unit.from_game('FE13')
        nme='Falchion (Awakening)'
      elsif unit.from_game(['FE2','FE15'])
        nme='Falchion (Valentia)'
      elsif unit.from_game(['FE1','FE3','FE11','FE12'])
        nme='Falchion (Mystery)'
      elsif unit.from_game('FE14')
        nme='Falchion (Awakening)'
      end
    elsif @name=='Missiletainn'
      if unit.from_game('FE14',true)
        nme='Missiletainn (Dusk)'
      elsif unit.from_game('FE13',true)
        nme='Missiletainn (Dark)'
      elsif unit.weapon[0,2]==['Red','Blade']
        nme='Missiletainn (Dark)'
      elsif unit.weapon[0,2]==['Blue','Tome']
        nme='Missiletainn (Dusk)'
      elsif unit.from_game('FE14')
        nme='Missiletainn (Dusk)'
      elsif unit.from_game('FE13')
        nme='Missiletainn (Dark)'
      elsif ['Blade','Dragon','Beast'].include?(unit.weapon[1])
        nme='Missiletainn (Dark)'
      elsif ['Tome','Dagger','Bow','Healer','Staff'].include?(unit.weapon[1])
        nme='Missiletainn (Dusk)'
      end
    elsif @name[0,7]=='Whelp (' || @name[0,11]=='Hatchling ('
      nme="Whelp (#{unit.movement})"
      nme="Hatchling (#{unit.movement})" if unit.movement=='Flier'
    elsif @name[0,10]=='Yearling (' || @name[0,11]=='Fledgling ('
      nme="Yearling (#{unit.movement})"
      nme="Fledgling (#{unit.movement})" if unit.movement=='Flier'
    elsif @name[0,7]=='Adult ('
      nme="Adult (#{unit.movement})"
    elsif ['Iron Sword','Iron Lance','Iron Axe','Iron Dagger','Iron Bow','Steel Sword','Steel Lance','Steel Axe','Steel Dagger','Steel Bow','Silver Sword','Silver Lance','Silver Axe','Silver Dagger','Silver Bow','Brave Sword','Brave Lance','Brave Axe','Brave Bow','Firesweep Sword','Firesweep Lance','Firesweep Axe','Firesweep Bow','Guard Sword','Guard Lance','Guard Axe','Barrier Blade','Barrier Lance','Barrier Axe','Killing Edge','Killer Lance','Killer Axe','Slaying Edge','Slaying Lance','Slaying Axe','Reprisal Lance','Reprisal Axe','Reprisal Sword'].include?(@name.gsub('+',''))
      t='Iron'
      t='Steel' if 'Steel '==@name[0,6]
      t='Silver' if 'Silver '==@name[0,7]
      t='Brave' if 'Brave '==@name[0,6]
      t='Firesweep' if 'Firesweep '==@name[0,10]
      t='Guard' if 'Guard '==@name[0,6] # not Guard Bow because it has a different effect from Guard Sword/Lance/Axe
      t='Barrier' if 'Barrier '==@name[0,8]
      t='Killer' if 'Killer '==@name[0,7] || 'Killing '==@name[0,8]
      t='Killing' if t=='Killer' && unit.weapon_color=='Red'
      t='Slaying' if 'Slaying '==@name[0,8]
      t='Reprisal' if 'Reprisal '==@name[0,9]
      nme="#{t} Sword" if unit.weapon_color=='Red'
      nme="#{t} Blade" if unit.weapon_color=='Red' && ['Barrier'].include?(t)
      nme="#{t} Edge" if unit.weapon_color=='Red' && ['Killer','Killing','Slaying'].include?(t)
      nme="#{t} Lance" if unit.weapon_color=='Blue'
      nme="#{t} Axe" if unit.weapon_color=='Green'
      nme="#{t} Rod" if unit.weapon_color=='Colorless'
      nme="#{t} Dagger" if unit.weapon_type=='Dagger' && ['Iron','Steel','Silver'].include?(t)
      nme="#{t} Bow" if unit.weapon_type=='Bow' && ['Iron','Steel','Silver','Brave','Firesweep','Killing','Killer','Slaying'].include?(t)
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Carrot Lance','Carrot Axe','Springy Lance','Springy Axe'].include?(@name.gsub('+',''))
      t='Carrot'
      t='Springy' if 'Springy '==@name[0,8]
      nme="#{t} Sword" if unit.weapon_color=='Red'
      nme="#{t} Lance" if unit.weapon_color=='Blue'
      nme="#{t} Axe" if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif @name[0,5]=='Raudr' || @name[0,4]=='Blar' || @name[0,5]=='Gronn' || @name[0,10]=='Keen Raudr' || @name[0,9]=='Keen Blar' || @name[0,10]=='Keen Gronn'
      x="#{@name}"
      nrse=true
      nme=x.gsub('Raudr',unit.norsetome) if @restrictions.include?('Red Tome Users Only')
      nme=x.gsub('Blar',unit.norsetome) if @restrictions.include?('Blue Tome Users Only')
      nme=x.gsub('Gronn',unit.norsetome) if @restrictions.include?('Green Tome Users Only')
    elsif ['Fire','Flux','Thunder','Light','Wind','Stone'].include?(@name)
      return [self,true] if @restrictions.include?("#{unit.weapon_color} Tome Users Only") && unit.weapon_type=='Tome'
      nme=['Fire','Flux'].sample if unit.weapon_color=='Red'
      nme='Fire' if unit.tome_tree=='Fire'
      nme='Flux' if unit.tome_tree=='Dark'
      nme=['Thunder','Light'].sample if unit.weapon_color=='Blue'
      nme='Thunder' if unit.tome_tree=='Thunder'
      nme='Light' if unit.tome_tree=='Light'
      nme=['Wind'].sample if unit.weapon_color=='Green'
      nme='Wind' if unit.tome_tree=='Wind'
      nme=['Stone'].sample if unit.weapon_color=='Colorless'
      nme='Stone' if unit.tome_tree=='Stone'
    elsif ['Elfire','Ruin','Elthunder','Ellight','Elwind','Elstone'].include?(@name)
      return [self,true] if @restrictions.include?("#{unit.weapon_color} Tome Users Only") && unit.weapon_type=='Tome'
      nme=['Elfire','Ruin'].sample if unit.weapon_color=='Red'
      nme='Elfire' if unit.tome_tree=='Fire'
      nme='Ruin' if unit.tome_tree=='Dark'
      nme=['Elthunder','Ellight'].sample if unit.weapon_color=='Blue'
      nme='Elthunder' if unit.tome_tree=='Thunder'
      nme='Ellight' if unit.tome_tree=='Light'
      nme=['Elwind'].sample if unit.weapon_color=='Green'
      nme='Elwind' if unit.tome_tree=='Wind'
      nme=['Elstone'].sample if unit.weapon_color=='Colorless'
      nme='Elstone' if unit.tome_tree=='Stone'
    elsif ['Bolganone','Fenrir','Thoron','Shine','Rexcalibur','Atlas'].include?(@name.gsub('+',''))
      return [self,true] if @restrictions.include?("#{unit.weapon_color} Tome Users Only") && unit.weapon_type=='Tome'
      nme=['Bolganone','Fenrir'].sample if unit.weapon_color=='Red'
      nme='Bolganone' if unit.tome_tree=='Fire'
      nme='Fenrir' if unit.tome_tree=='Dark'
      nme=['Thoron','Shine'].sample if unit.weapon_color=='Blue'
      nme='Thoron' if unit.tome_tree=='Thunder'
      nme='Shine' if unit.tome_tree=='Light'
      nme=['Rexcalibur'].sample if unit.weapon_color=='Green'
      nme='Rexcalibur' if unit.tome_tree=='Wind'
      nme=['Atlas'].sample if unit.weapon_color=='Colorless'
      nme='Atlas' if unit.tome_tree=='Stone'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Armorslayer','Heavy Spear','Hammer'].include?(@name.gsub('+',''))
      nme='Armorslayer' if unit.weapon_color=='Red'
      nme='Heavy Spear' if unit.weapon_color=='Blue'
      nme='Hammer' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Armorsmasher','Slaying Spear','Slaying Hammer'].include?(@name.gsub('+',''))
      nme='Armorsmasher' if unit.weapon_color=='Red'
      nme='Slaying Spear' if unit.weapon_color=='Blue'
      nme='Slaying Hammer' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Ruby Sword','Sapphire Lance','Emerald Axe'].include?(@name.gsub('+',''))
      nme='Ruby Sword' if unit.weapon_color=='Red'
      nme='Sapphire Lance' if unit.weapon_color=='Blue'
      nme='Emerald Axe' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Zanbato','Ridersbane','Poleaxe'].include?(@name.gsub('+',''))
      nme='Zanbato' if unit.weapon_color=='Red'
      nme='Ridersbane' if unit.weapon_color=='Blue'
      nme='Poleaxe' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Wo Dao','Harmonic Lance','Giant Spoon','Wo Gun'].include?(@name.gsub('+',''))
      nme='Wo Dao' if unit.weapon_color=='Red'
      nme='Harmonic Lance' if unit.weapon_color=='Blue'
      nme='Wo Gun' if unit.weapon_color=='Green' && @name.gsub('+','')!='Giant Spoon'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Unity Blooms','Pact Blooms','Amity Blooms'].include?(@name.gsub('+',''))
      nme='Unity Blooms' if unit.weapon_color=='Red'
      nme='Pact Blooms' if unit.weapon_color=='Blue'
      nme='Amity Blooms' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Safeguard','Vanguard','Rearguard'].include?(@name.gsub('+',''))
      nme='Safeguard' if unit.weapon_color=='Red'
      nme='Vanguard' if unit.weapon_color=='Blue'
      nme='Rearguard' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Red Egg','Red Gift','Blue Egg','Blue Gift','Green Egg','Green Gift'].include?(@name.gsub('+',''))
      t='Egg'
      t='Gift' if @name.include?('Gift')
      nme="#{unit.weapon_color} #{t}"
      nme="Empty #{t}" if unit.weapon_color=='Colorless'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
      nrse=true
    elsif ['Hibiscus Tome','Sealife Tome','Tomato Tome'].include?(@name.gsub('+',''))
      nme='Tomato Tome' if unit.weapon_color=='Red'
      nme='Sealife Tome' if unit.weapon_color=='Blue'
      nme='Hibiscus Tome' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Ninja Katana','Ninja Yari','Ninja Masakari'].include?(@name.gsub('+',''))
      nme='Ninja Katana' if unit.weapon_color=='Red'
      nme='Ninja Yari' if unit.weapon_color=='Blue'
      nme='Ninja Masakari' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ["Dancer's Ring","Dancer's Score"].include?(@name.gsub('+',''))
      nme="Dancer's Score" if unit.weapon_color=='Blue'
      nme="Dancer's Ring" if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Melon Crusher','Deft Harpoon'].include?(@name.gsub('+',''))
      nme='Deft Harpoon' if unit.weapon_color=='Blue'
      nme='Melon Crusher' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Conch Bouquet','Melon Float'].include?(@name.gsub('+',''))
      nme='Conch Bouquet' if unit.weapon_color=='Red'
      nme='Melon Float' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Kadomatsu','Hagoita'].include?(@name.gsub('+',''))
      nme='Kadomatsu' if unit.weapon_color=='Red'
      nme='Hagoita' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Faithful Axe',"Heart's Blade"].include?(@name.gsub('+',''))
      nme="Heart's Blade" if unit.weapon_color=='Red'
      nme='Faithful Axe' if unit.weapon_color=='Green'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Lofty Blossoms','Cake Cutter'].include?(@name.gsub('+',''))
      nme='Lofty Blossoms' if unit.weapon_color=='Red'
      nme='Cake Cutter' if unit.weapon_color=='Blue'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Carrot Cudgel','Gilt Fork'].include?(@name.gsub('+',''))
      nme='Carrot Cudgel' if unit.weapon_color=='Red'
      nme='Gilt Fork' if unit.weapon_color=='Blue'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    elsif ['Tannenboom!',"Sack o' Gifts",'Handbell'].include?(@name.gsub('+',''))
      nme='Tannenboom!' if unit.weapon_color=='Blue'
      nme=["Sack o' Gifts",'Handbell'].sample if unit.weapon_color=='Green' && @name.gsub('+','')=='Tannenboom!'
      nme="#{nme}+" if !nme.nil? && @name[-1]=='+'
    end
    checkwpn=self.clone
    if nme.nil?
    elsif @name.gsub('+','')=='Loyal Wreath' && unit.weapon[0,1]!=['Red', 'Tome']
      x=$skills.find_index{|q| q.name=="Raudrblooms#{'+' if @name[-1]=='+'}"}
      return $skills[x].legalize(unit) unless x.nil?
    else
      x=$skills.find_index{|q| q.name==nme}
      checkwpn=$skills[x].clone unless x.nil?
      if unit.norsetome=='Hoss' && x.nil? && nrse
        checkwpn.name=nme
        checkwpn.restrictions='Colorless Tome Users Only'
      end
    end
    if !checkwpn.exclusivity.nil? && !checkwpn.exclusivity.include?(unit.name)
      return [checkwpn,false]
    elsif checkwpn.restrictions.include?('Beasts Only') && checkwpn.restrictions.length>1 && !checkwpn.restrictions.include?("#{unit.movement.gsub('Flier','Fliers')} Only")
      return [checkwpn,false]
    elsif !checkwpn.restrictions.include?("#{unit.unit_group(true)} Only")
      return [checkwpn,false]
    end
    return [checkwpn,true]
  end
  
  def can_inherit?(unit)
    unless @exclusivity.nil?
      return true if @exclusivity.include?(unit.name)
      return false
    end
    return false if @restrictions.map{|q| q.downcase}.include?('no one')
    return true if @restrictions.map{|q| q.downcase}.include?('everyone')
    return true if @type.include?('Weapon') && has_any?(@tags,['Blade','Tome']) && unit.name=='Kiran' && unit.owner.nil?
    for i in 0...@restrictions.length
      x="#{@restrictions[i]}"
      if x=='Tome Users Only'
        return false unless unit.weapon_type=='Tome'
      elsif x=='Excludes Tome Users'
        return false if unit.weapon_type=='Tome'
      elsif x[0,9]=='Excludes '
        y=x[9,x.length-9].split(' and ')
        z=y.map{|q| true}
        for i2 in 0...y.length
          if ['Infantry','Fliers','Armor','Cavalry'].include?(y[i2])
            z[i2]=false if unit.movement.gsub('Flier','Fliers')==y[i2]
          elsif ['Dancers','Singers','Bards'].include?(y[i2])
            z[i2]=false if unit.isRefresher?(y[i2][0,y[i2].length-1])
          elsif y[i2].include?(' Weapon Users')
            y2=y[i2].gsub(' Weapon Users','')
            z[i2]=false if unit.weapon_color==y2
          else
            z[i2]=false if unit.unit_group(true)==y[i2]
          end
        end
        return false unless z.include?(true)
      elsif x[x.length-5,5]==' Only'
        y=x[0,x.length-5].split(' and ')
        z=y.map{|q| true}
        for i2 in 0...y.length
          if ['Infantry','Fliers','Armor','Cavalry'].include?(y[i2])
            z[i2]=false unless unit.movement.gsub('Flier','Fliers')==y[i2]
          elsif ['Dancers','Singers','Bards'].include?(y[i2])
            z[i2]=false unless unit.isRefresher?(y[i2][0,y[i2].length-1])
          elsif y[i2].include?(' Weapon Users')
            y2=y[i2].gsub(' Weapon Users','')
            z[i2]=false unless unit.weapon_color==y2
          else
            z[i2]=false unless unit.unit_group(true)==y[i2]
          end
        end
        return false unless z.include?(true)
      else
        return false
      end
    end
    return true
  end
  
  def learn_by_color(event,list=true)
    x=@learn.map{|q| q.map{|q2| $units.find_index{|q3| q3.name==q2}}.compact.map{|q2| $units[q2]}.reject{|q2| !q2.isPostable?(event)}}
    y=[[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    for i in 0...x.length
      for i2 in 0...x[i].length
        i3=[-1,-1]
        i3[0]=0 if x[i][i2].weapon_color=='Red'
        i3[0]=1 if x[i][i2].weapon_color=='Blue'
        i3[0]=2 if x[i][i2].weapon_color=='Green'
        i3[0]=3 if x[i][i2].weapon_color=='Colorless'
        i3[1]=0 if x[i][i2].availability[0].include?('p')
        i3[1]=1 if x[i][i2].availability[0].include?('p') && x[i][i2].availability[0].include?('TD')
        i3[1]=2 if x[i][i2].availability[0].gsub('0s','').include?('s')
        i4=13
        i4=1+i3[0]+4*i3[1] unless i3.min<0
        i4=0 if x[i][i2].availability[0]=='-'
        y[i4].push("#{x[i][i2].postName} (#{i+1}#{Rarity_stars[0][i]})")
      end
    end
    x2=['<:Orb_Red:455053002256941056> Red','<:Orb_Blue:455053001971859477> Blue','<:Orb_Green:455053002311467048> Green','<:Orb_Colorless:455053002152083457> Colorless']
    x3=['Summonables','PartSummons','Limited']
    x4=['<:Orb_Gold:455053002911514634> Unattached','','','','','','','','','','','','','<:Orb_Pink:549339019318788175> Free units']
    for i in 0...x2.length
      for i2 in 0...x3.length
        x4[1+i+4*i2]="#{x2[i]} #{x3[i2]}"
      end
    end
    x2=[]
    for i in 0...y.length
      if list
        x4[i]=x4[i][0,x4[i].length-1] if x4[i][-1]=='s'
        x4[i]="#{x4[i]} unit" unless x4[i].include?('unit')
        x2.push([x4[i],y[i]]) unless y[i].length<=0
      else
        x2.push("*#{x4[i]}:* #{y[i].join(', ')}") unless y[i].length<=0
      end
    end
    return x2.join("\n")
  end
  
  def cooldown(lst=[])
    x=@might*1
    for i in 0...lst.length
      x+=1 if ['SlowSpecial','SpecialSlow'].include?(lst[i])
      x-=1 if ['Killer'].include?(lst[i])
    end
    return [x,1].max
  end
  
  def backwards_tree(unt)
    return [self] if @prerequisite.nil? || @prerequisite.length<=0
    m="#{@prerequisite[0]}"
    if @prerequisite.length>1
      if !unt.owner.nil? && has_any?(unt.skills[0,6].flatten,@prerequisite)
        x=unt.skills[0,6].flatten
        m=x.find_index{|q| @prerequisite.include?(q)}
        return [self] if m.nil?
        m="#{x[m]}"
      elsif has_any?(unt.base.skill_list.flatten.map{|q| q.fullName},@prerequisite)
        x=unt.base.skill_list.flatten.map{|q| q.fullName}
        m=x.find_index{|q| @prerequisite.include?(q)}
        return [self] if m.nil?
        m="#{x[m]}"
      else
        return [self]
      end
    end
    x=$skills.find_index{|q| q.fullName==m}
    return [self] if x.nil?
    x=$skills[x].backwards_tree(unt)
    x.push(self)
    return x
  end
  
  def eff_against_2(refine='',event=nil)
    return nil unless @type.include?('Weapon')
    t=@tags.map{|q| q}
    t=@tags.map{|q| q.gsub('(R)','')} if refine.length>0
    t=@tags.map{|q| q.gsub('(R)','').gsub('(E)','')} if refine=='Effect'
    t.push('Pega-killer') if @restrictions.include?('Bow Users Only') && !@tags.include?('UnBow')
    lookout=$skilltags.reject{|q| q[2]!='Weapon' || q[3].nil? || !t.include?(q[0])}.map{|q| q[0]}
    return nil if lookout.length<=0
    k=$units.reject{|q| !q.fake.nil? || q.summonability<0}.map{|q| q.clone}
    m=[]
    for i in 0...lookout.length
      if lookout[i]=='Foot-killer'
        m.push(k.reject{|q| q.movement != 'Infantry'})
      elsif ['Horse-killer','Wolftome'].include?(lookout[i])
        m.push(k.reject{|q| q.movement != 'Cavalry'})
      elsif lookout[i]=='Pega-killer'
        m.push(k.reject{|q| q.movement != 'Flier'})
      elsif lookout[i]=='Armor-killer'
        m.push(k.reject{|q| q.movement != 'Armor'})
      elsif ['Sword-killer','Lance-killer','Axe-killer'].include?(lookout[i])
        m.push(k.reject{|q| q.unit_group != "#{lookout[i].gsub('-killer','')} Users"})
      elsif ['Tome-killer','Dragon-killer','Beast-killer','Bow-killer','Dagger-killer','Blade-killer','Staff-killer'].include?(lookout[i])
        m.push(k.reject{|q| q.weapon_type != lookout[i].gsub('-killer','')})
      elsif ['DTome-killer','DDragon-killer','DBeast-killer','DBow-killer','DDagger-killer','DStaff-killer'].include?(lookout[i])
        m.push(k.reject{|q| q.weapon_type != lookout[i].gsub('-killer','')} || q.weapon_color=='Colorless') # letter D as a prefix for "colored" weapons
      elsif ['RTome-killer','RDragon-killer','RBeast-killer','RBow-killer','RDagger-killer','RStaff-killer'].include?(lookout[i])
        m.push(k.reject{|q| q.weapon_type != lookout[i].gsub('-killer','')} || q.weapon_color != 'Red')
      elsif ['BTome-killer','BDragon-killer','BBeast-killer','BBow-killer','BDagger-killer','BStaff-killer'].include?(lookout[i])
        m.push(k.reject{|q| q.weapon_type != lookout[i].gsub('-killer','')} || q.weapon_color != 'Blue')
      elsif ['GTome-killer','GDragon-killer','GBeast-killer','GBow-killer','GDagger-killer','GStaff-killer'].include?(lookout[i])
        m.push(k.reject{|q| q.weapon_type != lookout[i].gsub('-killer','')} || q.weapon_color != 'Green')
      elsif ['CTome-killer','CDragon-killer','CBeast-killer','CBow-killer','CDagger-killer','CStaff-killer'].include?(lookout[i])
        m.push(k.reject{|q| q.weapon_type != lookout[i].gsub('-killer','')} || q.weapon_color != 'Colorless')
      end
      # units whose weapons or prf skills either grant or remove weaknesses
      if lookout[i]=='Pega-killer'
        m[-1]=m[-1].reject{|q| ['Ashnard(Fallen)','Hel','Robin(F)(Fallen)','Altina','Robin(F)(Fallen)(Halloween)','Minerva(Retro)'].include?(q.name)}
      elsif lookout[i]=='Armor-killer'
        m[-1]=m[-1].reject{|q| ['Hector(Brave)'].include?(q.name)}
      elsif ['Dragon-killer','DDragon-killer','RDragon-killer','BDragon-killer','GDragon-killer','CDragon-killer'].include?(lookout[i])
        m[-1]=m[-1].reject{|q| ['Sothis','Sothis(Christmas)','Garon'].include?(q.name)}
        m[-1].push(k.reject{|q| !['Julius'].include?(q.name)})
        m[-1].flatten!; m[-1].uniq!
      end
    end
    m.flatten!; m.uniq!
    f=m.length*100.0/k.length
    return "#{'%.2f' % f}% (#{m.length}/#{k.length}) of playable roster" if !event.nil? && safe_to_spam?(event)
    return "#{'%.2f' % f}% of playable roster"
  end
  
  def level_equal
    return '' unless @level.include?('W')
    return '5' if @name=='Quick Riposte'
    return '5.5' if @name=='Brash Assault'
    return ''
  end
end

class FEHItem
  def emotes(bot,includebonus=true)
    return '<:Current_Arena_Bonus:498797967042412544>' if @name=='Dueling Crest'
    return '<:Current_Aether_Bonus:510022809741950986>' if @name.include?(' Throne')
    return '<:Orb_Rainbow:471001777622351872>' if @name=='Orb'
    return '<:Arena_Crown:490334177124810772>' if @name=='Arena Crown'
    return '<:Shard_Red:443733396842348545>' if @name=='Scarlet Shard'
    return '<:Shard_Blue:443733396741554181>' if @name=='Azure Shard'
    return '<:Shard_Green:443733397190344714>' if @name=='Verdant Shard'
    return '<:Shard_Colorless:443733396921909248>' if @name=='Transparent Shard'
    return '<:Shard_Gold:443733396913520640>' if @name=='Universal Shard'
    return '<:Crystal_Scarlet:445510676350500897>' if @name=='Scarlet Crystal'
    return '<:Crystal_Azure:445510676434124800>' if @name=='Azure Crystal'
    return '<:Crystal_Verdant:445510676845166592>' if @name=='Verdant Crystal'
    return '<:Crystal_Transparent:445510676295843870>' if @name=='Transparent Crystal'
    return '<:Crystal_Gold:445510676346306560>' if @name=='Universal Crystal'
    return '<:Badge_Scarlet:445510676060962816>' if @name=='Scarlet Badge'
    return '<:Badge_Azure:445510675352125441>' if @name=='Azure Badge'
    return '<:Badge_Verdant:445510676056899594>' if @name=='Verdant Badge'
    return '<:Badge_Transparent:445510675976945664>' if @name=='Transparent Badge'
    return '<:Badge_Golden:595157392597975051>' if @name=='Badge'
    return '<:Great_Badge_Scarlet:443704781001850910>' if @name=='Great Scarlet Badge'
    return '<:Great_Badge_Azure:443704780783616016>' if @name=='Great Azure Badge'
    return '<:Great_Badge_Verdant:443704780943261707>' if @name=='Great Verdant Badge'
    return '<:Great_Badge_Transparent:443704781597573120>' if @name=='Great Transparent Badge'
    return '<:Great_Badge_Golden:443704781068959744>' if @name=='Great Badge'
    return '<:Sacred_Coin:453618312996323338>' if @name=='Sacred Coin'
    return '<:RRAffinity:565064751780986890>' if @name=='R&R Affinity'
    return '<:Refining_Stone:453618312165720086>' if @name=='Refining Stone'
    return '<:Divine_Dew:453618312434417691>' if @name=='Divine Dew'
    return '<:Hero_Feather:471002465542602753>' if @name=='Hero Feather'
    return '<:Dragonflower_Infantry:541170819980722176>' if @name=='Dragonflower (I)'
    return '<:Dragonflower_Flier:541170820089774091>' if @name=='Dragonflower (F)'
    return '<:Dragonflower_Cavalry:541170819955556352>' if @name=='Dragonflower (C)'
    return '<:Dragonflower_Armor:541170820001824778>' if @name=='Dragonflower (A)'
    return '<:Arena_Medal:453618312446738472>' if @name=='Arena Medal'
    return '<:Aether_Stone:510776805746278421>' if @name=='Aether Stone'
    return '<:Heavenly_Dew:510776806396395530>' if @name=='Heavenly Dew'
    return '<:Aether_Stone_SP:513982883560423425>' if @name.include?('Aether Stone')
    return '<:Forma_Soul:699042073176965241>' if @name=='Forma Soul'
    return '<:Midgard_Gem:675118366352211988>' if @name=='Midgard Gem'
    return '<:Divine_Code:675118366788419584>' if @name=='Divine Code'
    return '<:Divine_Code_2:676545832903770117>' if @name=='Divine Code 2'
    return '<:Special_Blade:800880639540068353>' if @name=='Special Blade'
    if @type=='Blessing'
      moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "Boost_#{@name.gsub(' Blessing','')}"}
      return moji[0].mention unless moji.length<=0
      return '<:Legendary_Effect_Unknown:443337603945857024>'
    end
    return ''
  end
end

class FEHGroup
  def aliases
    x=[]
    x=['bunnywhitewings','whitewingsbunny','easterwhitewings','whitewingseaster','springwhitewings','whitewingsspring','rabbitwhitewings','whitewingsrabbit','bunnywhitewing','whitewingbunny','easterwhitewing','whitewingeaster','springwhitewing','whitewingspring','rabbitwhitewing','whitewingrabbit'] if @name=='Whitewings(Bunny)'
    x=['arenabonus','bonusarena','arena'] if @name=='ArenaBonus'
    x=['aetherbonus','bonusaether','aether'] if @name=='AetherBonus'
    x=['resonantbonus','bonusresonant','resonantblades','resonantbladesbonus','bonusresonantblades'] if @name=='ResonantBonus'
    x=['tempestbonus','bonustempest'] if @name=='TempestBonus'
    x=['braveheroes','brave','cyl'] if @name=='BraveHeroes'
    x=['fallenheroes','fallen','dark','evil','alter'] if @name=='FallenHeroes'
    x=['winter','holiday'] if @name=='Winter'
    x=['worsethanliki','liki'] if @name=='WorseThanLiki'
    x=['bunnies','bunny','spring'] if @name=='Bunnies'
    x=['picnic','lunch'] if @name=='Picnic'
    x=['pirate','pirates'] if @name=='Pirate'
    x=['ninja','ninjas'] if @name=='Ninja'
    x=['summer','swimsuit','beach'] if @name=='Summer'
    x=['retro','baby','lilly','lily','oldschool'] if @name=='Retro'
    x=['bathers','bathhouse','bathouse','bath','bathing'] if @name=='Bathing'
    x=['valentines',"valentine's",'vday','v-day'] if @name=="Valentine's"
    x=['newyears',"newyear's",'newyear'] if @name=="NewYear's"
    x=['performing','awaodori','festival','soiree'] if @name=='AwaOdori'
    x=['brides','grooms','bride','groom','wedding'] if @name=='Wedding'
    x=['halloween','spoopy','spooky','scary'] if @name=='Halloween'
    x=['christmas','xmas','x-mas'] if @name=='Christmas'
    x=['hellspawn'] if @name=='Helspawn'
    x=['fairies','elves','fairy','dreamfairy','elf','bug','bugs','butterfly','butterflys','butterflies'] if @name=='DreamFairies'
    x=['dwarf','dwarves','dwarfs','mecha','mechadwarf','mechadwarves','mechadwarfs'] if @name=='MechaDwarves'
    x=['giant','giants','giantess','giantesses','giantesss','titan','titans'] if @name=='Giants'
    x=['daily_rotation','dailyrotation','daily'] if @name=='Daily_Rotation'
    x=['noprf','prf-less','prfless'] if @name=='Prfless'
    x=['upforprf','up4prf','prfsoon'] if @name=='Up4Prf'
    x=['retroprf','retro-prf','retroactive','retroprfs','retro-prfs'] if @name=='Retro-Prfs'
    x=['hallofforms','halloforms','hallofforma','halloforna','hallofform','halloform','halloffjorm','halloffjorms','hallofjorm','hallofjorms'] if @name=='HallOfForms'
    x=['worsethanliki','wtl'] if @name=='WorseThanLiki'
    x.push(@name.downcase.gsub('(','').gsub(')','').gsub(' ','').gsub('_',''))
    return x.uniq
  end
  
  def unit_list(event=nil)
    x=[]
    x=$units.reject{|q| !q.isBonusUnit?('Arena')} if @name=='ArenaBonus'
    x=$units.reject{|q| !q.isBonusUnit?('Aether')} if @name=='AetherBonus'
    x=$units.reject{|q| !q.isBonusUnit?('Tempest')} if @name=='TempestBonus'
    x=$units.reject{|q| !q.isBonusUnit?('Resonant')} if @name=='ResonantBonus'
    x=$units.reject{|q| !q.name.include?('(Brave)')} if @name=='BraveHeroes'
    x=$units.reject{|q| !q.name.include?('(Fallen)')} if @name=='FallenHeroes'
    x=$units.reject{|q| !q.name.include?('(NewYears)')} if @name=="NewYear's"
    x=$units.reject{|q| !q.name.include?('(Bath)')} if @name=='Bathing'
    x=$units.reject{|q| !q.name.include?('(Valentines)')} if @name=="Valentine's"
    x=$units.reject{|q| !q.name.include?('(Bunny)') && !q.name.include?('(Spring)')} if @name=='Bunnies'
    x=$units.reject{|q| !q.name.include?('(Picnic)')} if @name=='Picnic'
    x=$units.reject{|q| !q.name.include?('(Retro)')} if @name=='Retro'
    x=$units.reject{|q| !q.name.include?('(Bride)') && !q.name.include?('(Groom)')} if @name=='Wedding'
    x=$units.reject{|q| !q.name.include?('(Summer)')} if @name=='Summer'
    x=$units.reject{|q| !q.name.include?('(AwaOdori)')} if @name=='AwaOdori'
    x=$units.reject{|q| !q.name.include?('(Pirate)')} if @name=='Pirate'
    x=$units.reject{|q| !q.name.include?('(Ninja)')} if @name=='Ninja'
    x=$units.reject{|q| !q.name.include?('(Halloween)')} if @name=='Halloween'
    x=$units.reject{|q| !q.name.include?('(Christmas)')} if @name=='Christmas'
    x=$units.reject{|q| !q.name.include?('(Christmas)') && !q.name.include?('(NewYears)')} if @name=='Winter'
    x=$units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?} if @name=='Seasonals'
    x=$units.reject{|q| !q.availability[0].include?('t')} if @name=='Tempest'
    x=$units.reject{|q| !q.availability[0].include?('g')} if @name=='GHB'
    x=$units.reject{|q| !q.availability[0].gsub('0o','').include?('o')} if @name=='Forma'
    x=$units.reject{|q| !q.availability[0].include?('o')} if @name=='HallOfForms'
    x=$units.reject{|q| !q.availability[0].include?('d')} if @name=='Daily_Rotation'
    x=$units.reject{|q| !$dev_waifus.include?(q.name)} if @name=="Mathoo'sWaifus"
    if @name=='Bannerless'
      x=$units.reject{|q| !q.availability[0].include?('p')}
      x2=$banners.map{|q| q.banner_units}.flatten.uniq
      x=x.reject{|q| x2.include?(q.name)}
    elsif @name=='Prfless'
      x2=$skills.reject{|q| !q.type.include?('Weapon') || q.exclusivity.nil?}.map{|q| q.exclusivity}.flatten.uniq
      x=$units.reject{|q| x2.include?(q.name) || q.availability[0].include?('s') || q.availability[0].include?('-')}
    elsif @name=='Up4Prf'
      x2=$groups.find_index{|q| q.name=='Retro-Prfs'}
      x3=$groups.find_index{|q| q.name=='Prfless'}
      x=[]
      unless x2.nil? || x3.nil?
        x2=$groups[x2].unit_list.reject{|q| !q.fake.nil?}.map{|q| q.id}.max+10
        x3=$groups[x3].unit_list.reject{|q| !q.fake.nil?}.map{|q| q.name}
        x=$units.reject{|q| q.id>x2 || !x3.include?(q.name)}
      end
    elsif @name=='Retro-Prfs'
      x2=$skills.reject{|q| !q.type.include?('Weapon') || q.exclusivity.nil? || !q.prerequisite.nil?}.map{|q| q.exclusivity}.flatten.uniq
      x=$units.reject{|q| !x2.include?(q.name)}
    elsif @name=='WorseThanLiki'
      anchor='Tiki(Young)(Earth)'
      return [] if $units.find_index{|q| q.name==anchor}.nil?
      liki=$units[$units.find_index{|q| q.name==anchor}]
      x=$units.reject{|q| q.name==anchor || q.stats40.max<=0}
      for i in 0...liki.stats40.length
        x=x.reject{|q| q.stats40[i]>liki.stats40[i]}
        x=x.reject{|q| q.stats40[i]+2>liki.stats40[i] && q.hasResplendent?}
      end
    elsif @name=='Falchion_Users'
      x2=$skills.reject{|q| !q.name.include?('Falchion (')}
      x3=x2.map{|q| q.evolutions}.flatten
      x3.push('Breath of Fog')
      x3.push('Mirage Falchion')
      x3.push('Geirskogul')
      x3.push('Naga','Divine Naga','Virtuous Naga')
      x3=x3.map{|q| $skills.find_index{|q2| q2.name==q}}.compact.map{|q| $skills[q]}
      x2=[x2,x3].flatten.map{|q| q.exclusivity}.flatten
      x2.push('Tiki(Young)(Earth)','Tiki(Young)(Fallen)','Tiki(Young)(Summer)','Tiki(Young)(Halloween)')
      x2.push('Naga')
      x=$units.reject{|q| !x2.include?(q.name)}
    end
    if @units.length>0
      x.push($units.reject{|q| !@units.include?(q.name)})
      x.flatten!
    end
    if event.nil?
      return x.reject{|q| !q.fake.nil?}
    else
      return x.reject{|q| !q.isPostable?(event)}
    end
  end
  
  def isDynamic?
    return true if self.unit_list.length>@units.length
    return false
  end
  
  def fullName(noemotes=false)
    return @name if noemotes && ['Bathing','Winter','Bunnies','Christmas','Halloween','Pirate','Ninja','Summer',"Valentine's"].include?(@name)
    x=''
    # regional groups
    x='<:Great_Badge_Golden:443704781068959744> Askr' if @name=='Askr'
    x='<:Embla:746673234694504518> Embla' if @name=='Embla'
    x='<:Special_Offensive_Ice:454473651291422720> Nifl' if @name=='Nifl'
    x='<:Special_Offensive_Fire:454473651861979156> Muspell' if @name=='Muspell'
    x='<:Hel:746671718235635743> Helspawn' if @name=='Helspawn'
    x="\u{1F9DA} Dream Fairies" if @name=='DreamFairies'
    x="\u{1F474}\u{1F3FD} Mecha Dwarves" if @name=='MechaDwarves'
    x='<:WhiteWing:746668045199736853> Whitewings' if @name=='Whitewings'
    x='<:WingedBunny:746668044763398174> Whitewings(Bunny)' if @name=='Whitewings(Bunny)'
    # obtainment groups
    x="\u{1F4C5} Daily Rotation" if @name=='Daily_Rotation' # calendar
    x='<:Heroic_Grail:574798333898653696> GHB' if @name=='GHB'
    x='<:Seasonal:701278992677732442> Seasonals' if @name=='Seasonals'
    x='<:Godly_Grail:612717339611496450> Tempest' if @name=='Tempest'
    x='<:Forma_Soulless:699085674724327516> Hall of Forms' if @name=='HallOfForms'
    x='<:Forma_Soul:699042073176965241> Forma' if @name=='Forma'
    x='<:Bannerless:793294155865784380> Bannerless' if @name=='Bannerless'
    x='<:Prfless:793294156114034738> Prfless' if @name=='Prfless'
    x='<:UpForPrf:793294156004982836> Up4Prf' if @name=='Up4Prf'
    # seasonal groups
    x="\u{1F458} New Year's" if @name=="NewYear's" # kimono
    x=':hotsprings: Bathing' if @name=='Bathing'
    x="\u{1F498} Valentine's" if @name=="Valentine's" # heart with arrow
    x=':rabbit: Bunnies' if @name=='Bunnies'
    x="\u{1F9FA} Picnic" if @name=='Picnic' # basket, though not a traditional picnic basket
    x='<:RetroMarth:746670895992668181> Retro' if @name=='Retro'
    x="\u{1F470} Wedding" if @name=='Wedding' # bride with veil
    x=':sunny: Summer' if @name=='Summer'
    x="\u{1F483} Awa Odori" if @name=='AwaOdori' 
    x="\u{1F3F4}\u200D\u2620\uFE0F Pirate" if @name=='Pirate' # multi-part emote that results in a Jolly Roger
    x="\u{1F977} Ninja" if @name=='Ninja' # ninja
    x="\u{1F383} Halloween" if @name=='Halloween' # jack-o-lantern
    x="\u{1F384} Christmas" if @name=='Christmas' # Christmas tree
    x=':snowflake: Winter' if @name=='Winter'
    # unit archetypes
    x='<:DragonEff:701301177370804296> Falchion Users' if @name=='Falchion_Users'
    x='<:PurpleFire:701271290987806790> Fallen Heroes' if @name=='FallenHeroes'
    x='<:BraveHero:701268588266520578> Brave Heroes' if @name=='BraveHeroes'
    # Bonus Units
    x='<:Current_Arena_Bonus:498797967042412544> Arena Bonus' if @name=='ArenaBonus'
    x='<:Current_Aether_Bonus:510022809741950986> Aether Bonus' if @name=='AetherBonus'
    x='<:Special_Blade:800880639540068353> Resonant Blades Bonus' if @name=='ResonantBonus'
    x='<:Current_Tempest_Bonus:498797966740422656> Tempest Bonus' if @name=='TempestBonus'
    # other groups
    x='<:Divine_Dew:453618312434417691> Retro-Prfs' if @name=='Retro-Prfs'
    x="<:Icon_Support_Cyan:497430896249405450> Mathoo's Waifus" if @name=="Mathoo'sWaifus"
    x='<:Divine_Mist:701285239611195432> Worse Than Liki' if @name=='WorseThanLiki'
    return @name if x.length<=0
    x=x.split('> ')[-1] if noemotes
    x='Daily Rotation' if @name=='Daily_Rotation' && noemotes
    x='Dream Fairies' if @name=='DreamFairies' && noemotes
    x="New Year's" if @name=="NewYear's" && noemotes
    return x if x.length>0
    return @name
  end
end

class FEHBanner
  def red_legends; return self.unit_list.reject{|q| q.weapon_color != 'Red' || q.legendary.nil?}; end
  def blue_legends; return self.unit_list.reject{|q| q.weapon_color != 'Blue' || q.legendary.nil?}; end
  def green_legends; return self.unit_list.reject{|q| q.weapon_color != 'Green' || q.legendary.nil?}; end
  def colorless_legends; return self.unit_list.reject{|q| q.weapon_color != 'Colorless' || q.legendary.nil?}; end
  def gold_legends; return self.unit_list.reject{|q| ['Red','Blue','Green','Colorless'].include?(q.weapon_color) || q.legendary.nil?}; end
  
  def same_color(unit)
    return self.reds.reject{|q| q==unit || q.name==unit.name} if unit.weapon_color=='Red'
    return self.blues.reject{|q| q==unit || q.name==unit.name} if unit.weapon_color=='Blue'
    return self.greens.reject{|q| q==unit || q.name==unit.name} if unit.weapon_color=='Green'
    return self.colorlesses.reject{|q| q==unit || q.name==unit.name} if unit.weapon_color=='Colorless'
    return self.gold
  end
  
  def other_color(unit)
    x=[]
    x.push(self.reds) unless unit.weapon_color=='Red'
    x.push(self.blues) unless unit.weapon_color=='Blue'
    x.push(self.greens) unless unit.weapon_color=='Green'
    x.push(self.colorlesses) unless unit.weapon_color=='Colorless'
    x.push(self.golds) if ['Red','Blue','Green','Colorless'].include?(unit.weapon_color)
    return x.flatten
  end
  
  def calc_pity(x)
    newunits=false
    newunits=true if has_any?(@tags,['NewUnits'])
    unless @start_date.nil?
      newunits=false if @start_date[2]<2020
      newunits=false if @start_date[2]==2020 && @start_date[1]<2
    end
    six_focus=0; six_star=0
    five_focus=0; five_star=0
    four_focus=0; four_star=0
    three_focus=0; three_star=0
    two_focus=0; two_star=0
    one_focus=0; one_star=0
    if @starting_focus<0 # negative "starting focus" numbers indicate there is no non-focus rate
      sr=(x/5)*0.5
      sr=100.00 + @starting_focus if x>=120 && $summon_rate[2]%3==2
      b= 0 - @starting_focus
      s5 = [(6.00 - b), 0.00].max
      five_focus = b + sr * b / (b + s5)
      five_star = s5 + sr * s5 / (b + s5)
      if x>=120 && $summon_rate[2]%3==1
        five_focus = 50.00
        five_star = 50.00
      end
      four_star = (100.00 - five_focus - five_star) * 58.00 / (100.00 - b)
      four_focus = 3.00 * four_star / 58.00 if newunits
      four_special = 3.00 * four_star / 58.00
      three_star = 100.00 - five_focus - five_star - four_star
    else
      sr=(x/5)*0.5
      sr=97.00 - @starting_focus if x>=120 && $summon_rate[2]%3==2
      five_focus = @starting_focus + sr * @starting_focus / (@starting_focus + 3.00)
      five_star = 3.00 + sr * 3.00 / (@starting_focus + 3.00)
      if x>=120 && $summon_rate[2]%3==1
        five_focus = 50.00
        five_star = 50.00
      end
      four_star = (100.00 - five_focus - five_star) * 58.00 / (100.00 - @starting_focus - 3)
      four_focus = 3.00 * four_star / 58.00 if newunits
      four_special = 3.00 * four_star / 58.00
      three_star = 100.00 - five_focus - five_star - four_star
    end
    six_star=0 if six_focus>=100
    five_focus=0 if six_focus+six_star>=100
    five_star=0 if six_focus+six_star+five_focus>=100
    four_focus=0 if six_focus+six_star+five_focus+five_star>=100 || self.unit_list.reject{|q| !q.availability[0].include?('4p') && !q.availability[0].include?('4s')}.length<=0
    four_special=0 if six_focus+six_star+five_focus+five_star+four_focus>=100
    four_star=0 if six_focus+six_star+five_focus+five_star+four_focus+four_special>=100
    three_star=0 if six_focus+six_star+five_focus+five_star+four_focus+four_special+four_star>=100
    two_star=0 if six_focus+six_star+five_focus+five_star+four_focus+four_special+four_star+three_star>=100
    one_star=0 if six_focus+six_star+five_focus+five_star+four_focus+four_special+four_star+three_star+two_star>=100
    four_focus=four_star/2.0 if @focus_rarities.include?('4') && four_focus<=0
    three_focus=three_star/2.0 if @focus_rarities.include?('3') && three_focus<=0
    two_focus=two_star/2.0 if @focus_rarities.include?('2') && two_focus<=0
    one_focus=one_star/2.0 if @focus_rarities.include?('1') && one_focus<=0
    four_focus=0 if self.unit_list.reject{|q| !q.availability[0].include?('4p') && !q.availability[0].include?('4s')}.length<=0
    three_focus=0 if self.unit_list.reject{|q| !q.availability[0].include?('3p') && !q.availability[0].include?('3s')}.length<=0
    two_focus=0 if self.unit_list.reject{|q| !q.availability[0].include?('2p') && !q.availability[0].include?('2s')}.length<=0
    one_focus=0 if self.unit_list.reject{|q| !q.availability[0].include?('1p') && !q.availability[0].include?('1s')}.length<=0
    four_star-=four_focus if four_focus>0
    four_star-=four_special if four_special>0
    three_star-=three_focus if three_focus>0
    two_star-=two_focus if two_focus>0
    one_star-=one_focus if one_focus>0
    return [six_focus,six_star,five_focus,five_star,four_focus,four_special,four_star,three_focus,three_star,two_focus,two_star,one_focus,one_star]
  end
  
  def description(unit,chance)
    len='%.2f'
    len='%.4f' if Shardizard==4
    d=[]
    d.push("#{@start_date[0]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][@start_date[1]]} #{@start_date[2]}") unless @start_date.nil?
    d.push("#{@end_date[0]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][@end_date[1]]} #{@end_date[2]}") unless @end_date.nil?
    str=''
    str="*Duration:* #{d.join(' - ')}" unless d.length<=0
    if @focus_rarities.include?('0')
      str="#{str}\n*Multi-banner hybrid with #{self.unit_list.length} total focus units*"
    else
      str="#{str}\n*Same Focus Color:* #{self.same_color(unit).map{|q| q.name}.sort.join(', ')}" unless self.same_color(unit).length<=0
      str="#{str}\n*Other Focus Color:* #{self.other_color(unit).map{|q| q.name}.sort.join(', ')}" unless self.other_color(unit).length<=0
    end
    x2=self.calc_pity(0)
    str="#{str}\n*Starting Focus Chance:* #{"#{len % x2[0]}% (6<:Icon_Rarity_6p10:491487784822112256>), " unless x2[0]<=0}#{len % x2[2]}% (5<:Icon_Rarity_5p10:448272715099406336>)"
    str="#{str}, #{len % x2[4]}% (4<:Icon_Rarity_4p10:448272714210476033>)" unless x2[4]<=0
    str="#{str}, #{len % x2[7]}% (3<:Icon_Rarity_3:448266417934958592>)" unless x2[7]<=0
    str="#{str}, #{len % x2[9]}% (2<:Icon_Rarity_2:448266417872044032>)" unless x2[9]<=0
    str="#{str}, #{len % x2[11]}% (1<:Icon_Rarity_1:448266417481973781>)" unless x2[11]<=0
    unless chance<=0
      x2=self.calc_pity(chance)
      str="#{str}\n*Current Focus Chance:* #{"#{len % x2[0]}% (6<:Icon_Rarity_6p10:491487784822112256>), " unless x2[0]<=0}#{len % x2[2]}% (5<:Icon_Rarity_5p10:448272715099406336>)"
      str="#{str}, #{len % x2[4]}% (4<:Icon_Rarity_4p10:448272714210476033>)" unless x2[4]<=0
      str="#{str}, #{len % x2[7]}% (3<:Icon_Rarity_3:448266417934958592>)" unless x2[7]<=0
      str="#{str}, #{len % x2[9]}% (2<:Icon_Rarity_2:448266417872044032>)" unless x2[9]<=0
      str="#{str}, #{len % x2[11]}% (1<:Icon_Rarity_1:448266417481973781>)" unless x2[11]<=0
    end
    if x2[0]>0 && (unit.availability[0].include?('6p') || unit.availability[0].include?('6s'))
      m=x2[0]/(self.same_color(unit).reject{|q| !q.availability[0].include?('6p') && !q.availability[0].include?('6s')}.length+1)
      m2=x2[0]/self.unit_list.reject{|q| !q.availability[0].include?('6p') && !q.availability[0].include?('6s')}.length
      str="#{str}\n*6<:Icon_Rarity_6p10:491487784822112256> #{'Start ' if chance<=0}Chance:* "
      if m<=m2
        str="#{str}#{len % m}%"
      else
        str="#{str}#{len % m}% (Perceived), #{len % m2}% (Actual)"
      end
    end
    unless @focus_rarities.include?('0')
      if x2[2]>0 && (unit.availability[0].include?('5p') || unit.availability[0].include?('5s') || x2[0]+x2[1]<=0)
        m=x2[2]/(self.same_color(unit).length+1)
        m2=x2[2]/self.unit_list.length
        str="#{str}\n*5<:Icon_Rarity_5p10:448272715099406336> #{'Start ' if chance<=0}Chance:* "
        if m<=m2
          str="#{str}#{len % m}%"
        else
          str="#{str}#{len % m}% (Perceived), #{len % m2}% (Actual)"
        end
      end
      if x2[4]>0 && (unit.availability[0].include?('4p') || unit.availability[0].include?('4s'))
        m=x2[4]/(self.same_color(unit).reject{|q| !q.availability[0].include?('4p') && !q.availability[0].include?('4s')}.length+1)
        m2=x2[4]/self.unit_list.reject{|q| !q.availability[0].include?('4p') && !q.availability[0].include?('4s')}.length
        str="#{str}\n*4<:Icon_Rarity_4p10:448272714210476033> #{'Start ' if chance<=0}Chance:* "
        if m<=m2
          str="#{str}#{len % m}%"
        else
          str="#{str}#{len % m}% (Perceived), #{len % m2}% (Actual)"
        end
      end
      if x2[7]>0 && (unit.availability[0].include?('3p') || unit.availability[0].include?('3s'))
        m=x2[7]/(self.same_color(unit).reject{|q| !q.availability[0].include?('3p') && !q.availability[0].include?('3s')}.length+1)
        m2=x2[7]/self.unit_list.reject{|q| !q.availability[0].include?('3p') && !q.availability[0].include?('3s')}.length
        str="#{str}\n*3<:Icon_Rarity_3:448266417934958592> #{'Start ' if chance<=0}Chance:* "
        if m<=m2
          str="#{str}#{len % m}%"
        else
          str="#{str}#{len % m}% (Perceived), #{len % m2}% (Actual)"
        end
      end
      if x2[9]>0 && (unit.availability[0].include?('3p') || unit.availability[0].include?('2s'))
        m=x2[9]/(self.same_color(unit).reject{|q| !q.availability[0].include?('2p') && !q.availability[0].include?('2s')}.length+1)
        m2=x2[9]/self.unit_list.reject{|q| !q.availability[0].include?('2p') && !q.availability[0].include?('2s')}.length
        str="#{str}\n*2<:Icon_Rarity_2:448266417872044032> #{'Start ' if chance<=0}Chance:* "
        if m<=m2
          str="#{str}#{len % m}%"
        else
          str="#{str}#{len % m}% (Perceived), #{len % m2}% (Actual)"
        end
      end
      if x2[11]>0 && (unit.availability[0].include?('1p') || unit.availability[0].include?('1s'))
        m=x2[11]/(self.same_color(unit).reject{|q| !q.availability[0].include?('1p') && !q.availability[0].include?('1s')}.length+1)
        m2=x2[11]/self.unit_list.reject{|q| !q.availability[0].include?('1p') && !q.availability[0].include?('1s')}.length
        str="#{str}\n*1<:Icon_Rarity_1:448266417481973781> #{'Start ' if chance<=0}Chance:* "
        if m<=m2
          str="#{str}#{len % m}%"
        else
          str="#{str}#{len % m}% (Perceived), #{len % m2}% (Actual)"
        end
      end
    end
    return str
  end
  
  def full_banner
    f=[[],[]]
    f[0]=self.unit_list.reject{|q| !q.availability[0].include?('6p') && !q.availability[0].include?('6s')} if self.calc_pity(0)[0]>0
    f[1]=$units.reject{|q| !q.fake.nil? || !q.availability[0].include?('6p')} if self.calc_pity(0)[1]>0
    f.push(self.unit_list) if self.calc_pity(0)[2]>0
    f.push([]) unless self.calc_pity(0)[2]>0
    nu=false
    nu=true if has_any?(@tags,['NewUnits'])
    unless @start_date.nil?
      nu=false if @start_date[2]<2020
      nu=false if @start_date[2]==2020 && @start_date[1]<2
    end
    nu2=true if @start_date[2]>2021
    nu2=true if @start_date[2]==2020 && @start_date[1]>2
    nu2=true if @start_date[2]==2020 && @start_date[1]==2 && @start_date[0]>2
    nu=true if nu2
    f.push($units.reject{|q| !q.fake.nil? || !q.duo.nil? || !q.availability[0].include?('5p') || (q.availability[0].include?('TD') && nu)})
    if self.calc_pity(0)[4]>0
      f.push(self.unit_list.reject{|q| !q.availability[0].include?('4p') && !q.availability[0].include?('4s')})
    else
      f.push([])
    end
    if nu2
      f.push($units.reject{|q| !q.fake.nil? || !q.duo.nil? || !q.availability[0].include?('5p') || !q.availability[0].include?('TD')})
    else
      f.push([])
    end
    f.push($units.reject{|q| !q.fake.nil? || !q.availability[0].include?('4p')})
    if self.calc_pity(0)[6]>0
      f.push(self.unit_list.reject{|q| !q.availability[0].include?('3p') && !q.availability[0].include?('3s')})
    else
      f.push([])
    end
    f.push($units.reject{|q| !q.fake.nil? || !q.availability[0].include?('3p')})
    if self.calc_pity(0)[9]>0
      f.push(self.unit_list.reject{|q| !q.availability[0].include?('2p') && !q.availability[0].include?('2s')})
    else
      f.push([])
    end
    f.push($units.reject{|q| !q.fake.nil? || !q.availability[0].include?('2p')})
    if self.calc_pity(0)[11]>0
      f.push(self.unit_list.reject{|q| !q.availability[0].include?('1p') && !q.availability[0].include?('1s')})
    else
      f.push([])
    end
    f.push($units.reject{|q| !q.fake.nil? || !q.availability[0].include?('1p')})
    return f
  end
end

class FEHEvent
  def fullName
    @type='Voting Gauntlet' if @type=='VG'
    @type='Bound Hero Battle' if @type=='BHB'
    @type='Grand Hero Battle' if @type=='GHB'
    @type='Legendary Hero Battle' if @type=='LHB'
    @type='Limited Hero Battle' if @type=='LmHB'
    @type='Mythic Hero Battle' if @type=='MHB'
    @type='Daily Reward Battle' if ['DRM','Daily Reward Maps','DRB'].include?(@type)
    @type='Grand Conquests' if @type=='GC'
    @type='Rokkr Sieges' if ['RS','Rokkr'].include?(@type)
    @type='Tempest Trials' if ['TT','Tempest'].include?(@type)
    @type='Forging Bonds' if ['FB','Bonds','Bond Trials'].include?(@type)
    @type='Tap Battle' if @type=='Illusory Dungeon'
    @type='Lost Lore' if @type=='Lore'
    @type='Log-In Bonus' if @type=='Log-In' || @type=='Login'
    @type='Hall of Forms' if @type=='HoF' || @type=='HOF'
    @type='Pawns of Loki' if @type=='PoL' || @type=='POL'
    n="#{@name}"
    if ['Voting Gauntlet','Tempest Trials','Forging Bonds','Quests','Log-In Bonus','Lost Lore'].include?(@type)
      n="\"#{n}\" #{@type}"
    elsif ['Bound Hero Battle','Grand Hero Battle','Legendary Hero Battle','Mythic Hero Battle','Daily Reward Battle','Limited Hero Battle','Special Maps'].include?(@type)
      n="#{@type}: *#{n}*"
    elsif ['Rokkr Sieges','Grand Conquests','Pawns of Loki'].include?(@type)
      n="#{@type}"
    elsif ['Tap Battle','Hall of Forms'].include?(@type)
      n="#{@type}: #{n}"
    elsif @type=='Update'
      n="#{n} Update"
    elsif @type=='Orb Promo'
      n="#{@type} (#{n})"
    elsif @type=='Event'
    else
      n="#{n} (#{@type})"
    end
    return n
  end
  
  def extendedData
    return '' if @start_date.nil? || !self.isCurrent?
    str2=''
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    if @type=='Log-In Bonus'
      tt2=@end_date.map{|q| q}
      tt2=Time.new(tt2[2],tt2[1],tt2[0])+24*60*60
      t2=@start_date.map{|q| q}
      t2=Time.new(t2[2],t2[1],t2[0])+24*60*60
      tt2=tt2-t2
      t3=Time.new(t.year,t.month,t.day)+24*60*60
      t2=t3-t2
      t2=t2/(24*60*60)
      if 10-t2>0
        str2=" - #{[(10-t2).floor,tt2].min} gifts remain for daily players"
      else
        str2=" - no gifts remain for daily players"
      end
    elsif @type=='Grand Conquests'
      t4=@start_date.map{|q| q}
      t4=Time.new(t4[2],t4[1],t4[0])+24*60*60
      t3=Time.new(t.year,t.month,t.day)+24*60*60
      t4=t3-t4
      t4=t4/(24*60*60)
      t4=t4.floor
      t2=@start_date.map{|q| q}
      t2=Time.new(t2[2],t2[1],t2[0])+24*60*60
      t2+=24*60*60*(2*(t4/2+1)-1)
      t2=t2-t
      if t2/(60*60)>44
        str2=" - waiting until Battle #{t4/2+1}"
      elsif t2/(60*60)>1
        str2=" - #{(t2/(60*60)).floor} hours remain in Battle #{t4/2+1}"
        str2="#{str2} (Round #{(11-(t2/(60*60)).floor/4).floor} currently ongoing)"
      elsif t2/60>1
        str2=" - #{(t2/60).floor} minutes remain in Battle #{t4/2+1}"
        str2="#{str2} (Round #{(11-(t2/(60*60)).floor/4).floor} currently ongoing)"
      elsif t2>1
        str2=" - #{t2.floor} seconds remain in Battle #{t4/2+1}"
        str2="#{str2} (Round #{(1-(t2/(60*60)).floor/4).floor} currently ongoing)"
      elsif t2.floor<=0
        str2=" - waiting until Battle #{t4/2+2}"
      end
    elsif ['Rokkr Sieges','Pawns of Loki'].include?(@type)
      t4=@start_date.map{|q| q}
      t4=Time.new(t4[2],t4[1],t4[0])+24*60*60
      t3=Time.new(t.year,t.month,t.day)+24*60*60
      t4=t3-t4
      t4=t4/(24*60*60)
      t4=t4.floor
      t2=@start_date.map{|q| q}
      t2=Time.new(t2[2],t2[1],t2[0])+24*60*60
      t2+=24*60*60*(2*(t4/2+1)-1)
      t2=t2-t
      if t2/(60*60)>44
        str2=" - waiting until Battle #{t4/2+1}"
      elsif t2/(60*60)>1
        str2=" - #{(t2/(60*60)).floor} hours remain in Battle #{t4/2+1}"
      elsif t2/60>1
        str2=" - #{(t2/60).floor} minutes remain in Battle #{t4/2+1}"
      elsif t2>1
        str2=" - #{t2.floor} seconds remain in Battle #{t4/2+1}"
      elsif t2.floor<=0
        str2=" - waiting until Battle #{t4/2+2}"
      end
    elsif @type=='Voting Gauntlet'
      t4=@start_date.map{|q| q}
      t4=Time.new(t4[2],t4[1],t4[0])+24*60*60
      t3=Time.new(t.year,t.month,t.day)+24*60*60
      t4=t3-t4
      t4=t4/(24*60*60)
      t4=t4.floor
      t2=@start_date.map{|q| q}
      t2=Time.new(t2[2],t2[1],t2[0],21,0)
      t2+=24*60*60*(2*(t4/2+1)-1)
      t2=t2-t
      if t2/(60*60)>1
        str2=" - #{(t2/(60*60)).floor} hours remain in Round #{t4/2+1}"
      elsif t2/60>1
        str2=" - #{(t2/60).floor} minutes remain in Round #{t4/2+1}"
      elsif t2>1
        str2=" - #{t2.floor} seconds remain in Round #{t4/2+1}"
      elsif t4/2<2
        str2=" - waiting until Round #{t4/2+2}"
      else
        str2=" - post-gauntlet buffer period"
      end
    end
    return str2
  end
end

class FEHPath
  def ephemera
    return -1 unless @name.split(' ')[0]=='Ephemura'
    return @name.split(' ')[-1].to_i
  end
  
  def eMonth
    return nil if self.ephemera<0
    return @name.split(')')[0].gsub('Ephemura (','')
  end
  
  def isCurrent?(includempty=true,shift=false)
    return false unless self.ephemera>-1
    return super(includempty,shift) unless @start_date.nil? || @end_date.nil?
    x=$paths.reject{|q| q.name.split(')')[0]!=@name.split(')')[0] || q.ephemera>0}
    return false if x.length<=0
    return true if x[0].isCurrent?(includempty,shift)
    return false
  end
  
  def startsTomorrow?
    return false unless self.ephemera>-1
    return super unless @start_date.nil? || @end_date.nil?
    x=$paths.reject{|q| q.name.split(')')[0]!=@name.split(')')[0] || q.ephemera>0}
    return false if x.length<=0
    return true if x[0].startsTomorrow?
    return false
  end
  
  def isNext?(includempty=true)
    return false unless self.ephemera>-1
    return super(includempty) unless @start_date.nil? || @end_date.nil?
    x=$paths.reject{|q| q.name.split(')')[0]!=@name.split(')')[0] || q.ephemera>0}
    return false if x.length<=0
    return true if x[0].isNext?(includempty)
    return false
  end
  
  def isFuture?
    return false unless self.ephemera>-1
    return super unless @start_date.nil? || @end_date.nil?
    x=$paths.reject{|q| q.name.split(')')[0]!=@name.split(')')[0] || q.ephemera>0}
    return false if x.length<=0
    return true if x[0].isFuture?
    return false
  end
  
  def isPast?(includempty=true)
    return false unless self.ephemera>-1
    return super(includempty) unless @start_date.nil? || @end_date.nil?
    x=$paths.reject{|q| q.name.split(')')[0]!=@name.split(')')[0] || q.ephemera>0}
    return false if x.length<=0
    return true if x[0].isPast?(includempty)
    return false
  end
  
  def date_of_start
    return nil unless self.ephemera>-1
    return @start_date unless @start_date.nil?
    x=$paths.reject{|q| q.name.split(')')[0]!=@name.split(')')[0] || q.ephemera>0}
    return nil if x.length<=0
    return x[0].start_date
  end
  
  def date_of_end
    return nil unless self.ephemera>-1
    return @end_date unless @end_date.nil?
    x=$paths.reject{|q| q.name.split(')')[0]!=@name.split(')')[0] || q.ephemera>0}
    return nil if x.length<=0
    return x[0].end_date
  end
  
  def hasUnit?(unt)
    x=unt.clone
    x=unt.name if unt.is_a?(FEHUnit)
    return true if @codes.map{|q| q.unit_name}.include?(x)
    return false
  end
  
  def totalCost(len=0)
    return 'Free' if @codes.length<=0
    m=[]
    if len>0 && len<=@codes.length
      x=@codes[0,len].map{|q| q.cost[0]}.inject(0){|sum,x2| sum + x2 }
      m.push("#{x}<:Divine_Code:675118366788419584>") if x>0
      x=@codes[0,len].map{|q| q.cost[1]}.inject(0){|sum,x2| sum + x2 }
      m.push("#{x}<:Divine_Code_2:676545832903770117>") if x>0
    else
      x=@codes.map{|q| q.cost[0]}.inject(0){|sum,x2| sum + x2 }
      m.push("#{x}<:Divine_Code:675118366788419584>") if x>0
      x=@codes.map{|q| q.cost[1]}.inject(0){|sum,x2| sum + x2 }
      m.push("#{x}<:Divine_Code_2:676545832903770117>") if x>0
    end
    return m.join(', ') if m.length>0
    return 'Free'
  end
end

class FEHBonus
  def colosseum_season
    return -1 if @type=='Tempest' || @start_date.nil?
    t=Time.new(2017,2,2)
    t2=Time.new(@start_date[2],@start_date[1],@start_date[0])
    return ((t2-t)/(24*60*60)/7).to_i+2
  end
  
  def elements
    return @elements unless @elements.nil? || @elements.length<=0
    return @elements unless @type=='Aether'
    return ['Astra', 'Anima'] if self.colosseum_season%2==1
    return ['Light', 'Dark']
  end
end

class FEHCode
  def dispCost(ign=true)
    m=[]
    m.push("#{@cost[0]}#{'<:Divine_Code:675118366788419584>' if ign}") if @cost[0]>0
    m.push("#{@cost[1]}#{'<:Divine_Code_2:676545832903770117>' if ign}") if @cost[1]>0
    return 'free' if m.length<=0
    return m.join(', ')
  end
  
  def emotes(bot,includebonus=false)
    u=$units.find_index{|q| q.name==@unit_name}
    return '' if u.nil?
    return $units[u].emotes(bot,includebonus)
  end
  
  def disp_color(chain=0,mode=0)
    u=$units.find_index{|q| q.name==@unit_name}
    return '' if u.nil?
    return $units[u].disp_color(chain,mode)
  end
end

class FGOServant
  attr_accessor :clzz
  attr_accessor :rarity
  attr_accessor :grow_curve
  attr_accessor :max_level
  attr_accessor :hp,:atk
  attr_accessor :np_gain,:hit_count,:crit_star
  attr_accessor :death_rate
  attr_accessor :attribute
  attr_accessor :traits
  attr_accessor :actives,:passives,:np
  attr_accessor :deck
  attr_accessor :ascension_mats,:skill_mats
  attr_accessor :availability
  attr_accessor :team_cost
  attr_accessor :alignment
  attr_accessor :bond_ce,:valentines_ce
  attr_accessor :alts
  attr_accessor :costumes
  
  def clzz=(val); @clzz=val; end
  def rarity=(val); @rarity=val.to_i; end
  def grow_curve=(val); @grow_curve=val; end
  def max_level=(val); @max_level=val.to_i; end
  def hp=(val); @hp=val.split(', ').map{|q| q.to_i}; end
  def atk=(val); @atk=val.split(', ').map{|q| q.to_i}; end
  def hit_count=(val); @hit_count=val.split(', ').map{|q| q.to_i}; end
  def death_rate=(val); @death_rate=val.to_f; end
  def attribute=(val); @attribute=val; end
  def traits=(val); @traits=val.split(', '); end
  def actives=(val); @actives=val.split('; ').map{|q| q.split(', ')}; end
  def passives=(val); @passives=val.split(', '); end
  def np=(val); @np=val; end
  def deck=(val); @deck=val; end
  def ascension_mats=(val); @ascension_mats=val.split('; ').map{|q| q.split(', ')}; end
  def skill_mats=(val); @skill_mats=val.split('; ').map{|q| q.split(', ')}; end
  def availability=(val); @availability=val.split(', '); end
  def team_cost=(val); @team_cost=val.to_i; end
  def alignment=(val); @alignment=val; end
  def bond_ce=(val); @bond_ce=val.to_i; end
  def valentines_ce=(val); @valentines_ce=val.split(', ').map{|q| q.to_i}; end
  def alts=(val); @alts=val.split(', '); end
  def costumes=(val); @costumes=val.split(';; '); end
  
  def np_gain=(val)
    @np_gain=val.split(', ').map{|q| q.to_i}
    @np_gain[2]=val.split(', ')[2] if @np_gain.length>2
  end
  
  def crit_star=(val)
    @crit_star=val.split(', ')
    @crit_star[0]=@crit_star[0].to_i
    @crit_star[1]=@crit_star[1].to_f
  end
end

def find_in_units(bot,event,args=nil,mode=0,paired=false,ignore_limit=false)
  data_load(['unit'])
  if args.nil?
    args=event.message.text.gsub(',','').split(' ')
    args.shift
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  crsoff=nil
  if args.join(' ').include?('~~')
    s=args.join(' ')
    sy=args.join(' ')
    while sy.include?('~~')
      sy=remove_format(sy,'~~')
    end
    args=sy.split(' ')
    sn="~~#{s.gsub('~~',' ~~ ')}~~"
    while sn.include?('~~')
      sn=remove_format(sn,'~~')
    end
    crsoff=find_in_units(bot,event,sn.split(' '),13,true,true)
    crsoff=nil unless crsoff.is_a?(Array)
  end
  colors=[]
  weapons=[]
  color_weapons=[]
  movements=[]
  group=[]
  unitz=[]
  clzz=[]
  genders=[]
  xgames=[]
  supernatures=[]
  dancers=false
  legendaries=false; mythics=false
  duos=false; harmonics=false
  resplendents=false
  launch=false
  statlimits=[[-100,100],[-100,100],[-100,100],[-100,100],[-100,100]]
  for i in 0...args.length
    launch=true if ['launch'].include?(args[i].downcase)
    args[i]=args[i].downcase.gsub('user','') if args[i].length>4 && args[i][args[i].length-4,4].downcase=='user'
    dancers=true if ['dancers','singers','bards','dancer','singer','bard','refreshers','refresher'].include?(args[i].downcase)
    legendaries=true if ['legendary','legend','legends'].include?(args[i].downcase)
    mythics=true if ['mythic','mythicals','mythics','mythicals','mystics','mystic','mysticals','mystical'].include?(args[i].downcase)
    duos=true if ['duounit','duounits','duo','paired','pair'].include?(args[i].downcase)
    harmonics=true if ['resonantunit','resonantunits','resonant','harmonicunits','harmonicunit','harmonic','harmony','paired','pair'].include?(args[i].downcase)
    resplendents=true if ['resplendant','resplendent','ascension','ascend','resplend','ex'].include?(args[i].downcase)
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
    clzz.push(['Troubadour', nil, 'Staff', 'Cavalry']) if ['troubadour','trobadour','troubador','trobador','troubadours','trobadours','troubadors','trobadors'].include?(args[i].downcase)
    clzz.push(["F\u00E1fnir", nil, 'Dragon', 'Flier']) if ['fafnir','fafnirs'].include?(args[i].downcase)
    weapons.push('Blade') if ['physical','blade','blades','close','closerange'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','spell','tomes','mages','spells','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Dragon') if ['dragon','dragons','breath','manakete','manaketes','close','closerange'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz','close','closerange'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','thief','thiefs','thieves','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Staff') if ['healer','staff','cleric','healers','clerics','staves','range','ranged','distance','distant'].include?(args[i].downcase)
    movements.push('Flier') if ['flier','flying','flyer','fly','pegasus','wyvern','fliers','flyers','wyverns','pegasi'].include?(args[i].downcase)
    movements.push('Cavalry') if ['cavalry','horse','pony','horsie','horses','horsies','ponies','cavalier','cavaliers','cav','cavs'].include?(args[i].downcase)
    movements.push('Infantry') if ['infantry','foot','feet'].include?(args[i].downcase)
    movements.push('Armor') if ['armor','armour','armors','armours','armored','armoured'].include?(args[i].downcase)
    genders.push('M') if ['male','boy','m','males','boys','man','men','mans'].include?(args[i].downcase)
    genders.push('F') if ['female','woman','girl','f','females','women','girls','womans'].include?(args[i].downcase)
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
    group.push(find_group(event,args,args[i].downcase)) if !find_group(event,args,args[i].downcase).nil? && args[i].length>=3
  end
  gx=group.map{|q| q.name}
  if gx.include?('Bunnies') && gx.include?('Whitewings') && !gx.include?('Whitewings(Bunny)')
    group=group.reject{|q| ['Bunnies','Whitewings'].include?(q.name)}
    gx=$groups.find_index{|q| q.name=='Whitewings(Bunny)'}
    group.push($groups[gx]) unless gx.nil?
  end
  ggames=$origames.map{|q| q}
  for i in 0...ggames.length
    xgames.push(ggames[i][0]) if has_any?(ggames[i][1].map{|q| q.downcase},args.map{|q| q.downcase})
  end
  colors=colors.uniq
  colors2=colors.map{|q| q}
  weapons=weapons.uniq
  movements=movements.uniq
  genders=genders.uniq
  xgames=xgames.uniq
  group=group.uniq
  clzz=clzz.uniq
  supernatures=supernatures.uniq
  untz=$units.reject{|q| !q.isPostable?(event)}
  untz2=untz.map{|q| q}
  myunit=''
  if has_any?(args.map{|q| q.downcase},["mathoo'sunits","mathoo's",'mathoosunits','devunits','mathoosunit','devunit','mathoos'])
    untz=$dev_units.reject{|q| !q.isPostable?(event)}.map{|q| q.clone}
    myunit="*Developer's barracks*"
  elsif has_any?(args.map{|q| q.downcase},['myunits','myunit','mine']) && event.user.id==167657750971547648
    untz=$dev_units.reject{|q| !q.isPostable?(event)}.map{|q| q.clone}
    myunit="*Your barracks*"
  elsif has_any?(args.map{|q| q.downcase},['myunits','myunit','mine'])
    untz3=$donor_units.reject{|q| q.owner_id != event.user.id || !q.isPostable?(event)}.map{|q| q.clone}
    unless untz3.length<=0
      untz=$donor_units.reject{|q| q.owner_id != event.user.id || !q.isPostable?(event)}.map{|q| q.clone}
      myunit="*Your barracks*"
    end
  end
  stt=['HP','Atk','Spd','Def','Res']
  markxane=false
  for i in 0...statlimits.length
    untz=untz.reject{|q| q.stats40.nil? || q.stats40[1].nil? || q.stats40[i]<=statlimits[i][0] || q.stats40[i]>=statlimits[i][1]}
    if statlimits[i][0]>statlimits[i][1]
      tmp=statlimits[i][0]*1
      statlimits[i][0]=statlimits[i][1]*1
      statlimits[i][1]=tmp*1
    end
    if statlimits[i][0]>-100 && statlimits[i][1]<100
      markxane=true if i>0
      statlimits[i]="#{stt[i]} between #{statlimits[i][0]} and #{statlimits[i][1]}"
    elsif statlimits[i][0]>-100
      markxane=true if i>0
      statlimits[i]="#{stt[i]} above #{statlimits[i][0]}"
    elsif statlimits[i][1]<100
      markxane=true if i>0
      statlimits[i]="#{stt[i]} below #{statlimits[i][1]}"
    else
      statlimits[i]=nil
    end
  end
  statlimits.compact!
  if supernatures.include?('+HP') && supernatures.include?('-HP')
    untz=untz.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q.growths[0])}
  elsif supernatures.include?('+HP')
    untz=untz.reject{|q| ![-3,1,5,10,14].include?(q.growths[0])}
  elsif supernatures.include?('-HP')
    untz=untz.reject{|q| ![-2,2,6,11,15].include?(q.growths[0])}
  end
  if supernatures.include?('+Atk') && supernatures.include?('-Atk')
    markxane=true if i>0
    untz=untz.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q.growths[1])}
  elsif supernatures.include?('+Atk')
    markxane=true if i>0
    untz=untz.reject{|q| ![-3,1,5,10,14].include?(q.growths[1])}
  elsif supernatures.include?('-Atk')
    markxane=true if i>0
    untz=untz.reject{|q| ![-2,2,6,11,15].include?(q.growths[1])}
  end
  if supernatures.include?('+Spd') && supernatures.include?('-Spd')
    markxane=true if i>0
    untz=untz.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q.growths[2])}
  elsif supernatures.include?('+Spd')
    markxane=true if i>0
    untz=untz.reject{|q| ![-3,1,5,10,14].include?(q.growths[2])}
  elsif supernatures.include?('-Spd')
    markxane=true if i>0
    untz=untz.reject{|q| ![-2,2,6,11,15].include?(q.growths[2])}
  end
  if supernatures.include?('+Def') && supernatures.include?('-Def')
    markxane=true if i>0
    untz=untz.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q.growths[3])}
  elsif supernatures.include?('+Def')
    markxane=true if i>0
    untz=untz.reject{|q| ![-3,1,5,10,14].include?(q.growths[3])}
  elsif supernatures.include?('-Def')
    markxane=true if i>0
    untz=untz.reject{|q| ![-2,2,6,11,15].include?(q.growths[3])}
  end
  if supernatures.include?('+Res') && supernatures.include?('-Res')
    markxane=true if i>0
    untz=untz.reject{|q| ![-3,-2,1,5,10,2,6,11].include?(q.growths[4])}
  elsif supernatures.include?('+Res')
    markxane=true if i>0
    untz=untz.reject{|q| ![-3,1,5,10,14].include?(q.growths[4])}
  elsif supernatures.include?('-Res')
    markxane=true if i>0
    untz=untz.reject{|q| ![-2,2,6,11,15].include?(q.growths[4])}
  end
  xanexist=false
  if markxane
    for i in 0...untz.length
      if untz[i].name.include?('Xane')
        xanexist=true
        untz[i].name="#{untz[i].name} \\*"
      end
    end
  end
  markxane=false unless xanexist
  matches1=[]
  if colors.length>0 && weapons.length>0
    matches1=untz.reject{|q| !colors.include?(q.weapon_color) || !weapons.include?(q.weapon_type)}
  elsif colors.length>0
    matches1=untz.reject{|q| !colors.include?(q.weapon_color)}
  elsif weapons.length>0
    matches1=untz.reject{|q| !weapons.include?(q.weapon_type)}
  else
    matches1=untz.map{|q| q}
  end
  if color_weapons.length>0
    matches1=[] if matches1==untz
    for i in 0...untz.length
      for j in 0...color_weapons.length
        matches1.push(untz[i]) if untz[i].weapon[0,2]==color_weapons[j]
      end
    end
  end
  for i in 0...color_weapons.length
    colors.push(color_weapons[i][0])
  end
  matches1=matches1.uniq
  matches1=matches1.reject{|q| !movements.include?(q.movement)} if movements.length>0
  matches2=[]
  if clzz.length>0
    if colors2.length>0
      clzz2=[]
      for i in 0...clzz.length
        x=clzz[i].map{|q| q}
        if x[1].nil?
          for j in 0...colors2.length
            y=x.map{|q| q}
            y[1]="#{colors2[j]}"
            clzz2.push(y)
          end
        else
          clzz2.push(x)
        end
      end
      matches1=[] if clzz.reject{|q| q[1].nil?}.length<=0 && weapons.length<=0 && color_weapons.length<=0
    else
      clzz2=clzz.map{|q| q}
    end
    for i in 0...untz.length
      for j in 0...clzz2.length
        matches2.push(untz[i]) if (clzz2[j][1].nil? || untz[i].weapon_color==clzz2[j][1]) && untz[i].weapon_type==clzz2[j][2] && untz[i].movement==clzz2[j][3]
      end
    end
  end
  matches1=[] if matches1==untz
  untz=[matches1,matches2].flatten unless matches1.length<=0 && matches2.length<=0
  untz.uniq!
  colors.push(clzz.map{|q| q[1]}.compact)
  colors.flatten!
  colors.uniq!
  untz=untz.reject{|q| !genders.include?(q.gender)} if genders.length>0
  matches4=[]
  if xgames.length>0
    for i in 0...untz.length
      if has_any?(untz[i].games.map{|q| q.downcase},xgames.map{|q| q.downcase})
        matches4.push(untz[i])
      elsif has_any?(untz[i].games.map{|q| q.downcase},xgames.map{|q| "*#{q.downcase}"})
        matches4.push(untz[i])
      elsif !safe_to_spam?(event)
      elsif has_any?(untz[i].games.map{|q| q.downcase},xgames.map{|q| "(a)#{q.downcase}"})
        untz[i].name="#{untz[i].name} *[Amiibo]*"
        matches4.push(untz[i])
      elsif has_any?(untz[i].games.map{|q| q.downcase},xgames.map{|q| "(at)#{q.downcase}"})
        untz[i].name="#{untz[i].name} *[Assist Trophy]*"
        matches4.push(untz[i])
      elsif has_any?(untz[i].games.map{|q| q.downcase},xgames.map{|q| "(m)#{q.downcase}"})
        untz[i].name="#{untz[i].name} *[Mii Costume]*"
        matches4.push(untz[i])
      elsif has_any?(untz[i].games.map{|q| q.downcase},xgames.map{|q| "(t)#{q.downcase}"})
        untz[i].name="#{untz[i].name} *[Trophy]*"
        matches4.push(untz[i])
      elsif has_any?(untz[i].games.map{|q| q.downcase},xgames.map{|q| "(s)#{q.downcase}"})
        untz[i].name="#{untz[i].name} *[Spirit]*"
        matches4.push(untz[i])
      elsif has_any?(untz[i].games.map{|q| q.downcase},xgames.map{|q| "(st)#{q.downcase}"})
        untz[i].name="#{untz[i].name} *[Sticker]*"
        matches4.push(untz[i])
      end
    end
    untz=matches4.map{|q| q}
  end
  untz=untz.reject{|q| !group.map{|q2| q2.unit_list.map{|q3| q3.name}}.flatten.include?(q.name)} if group.length>0
  untz=untz.reject{|q| !q.availability[0].include?('LU')} if launch
  untz=untz.reject{|q| !q.isRefresher?} if dancers
  if legendaries && mythics
    untz=untz.reject{|q| q.legendary.nil?}
  elsif legendaries
    untz=untz.reject{|q| q.legendary.nil? || q.legendary[3]=='Mythic'}
  elsif mythics
    untz=untz.reject{|q| q.legendary.nil? || q.legendary[3]=='Legendary'}
  end
  if duos && harmonics
    untz=untz.reject{|q| q.duo.nil?}
  elsif duos
    untz=untz.reject{|q| q.duo.nil? || q.duo[0][0]=='Harmonic'}
  elsif harmonics
    untz=untz.reject{|q| q.duo.nil? || q.duo[0][0]=='Duo'}
  end
  untz=untz.reject{|q| !q.hasResplendent?} if resplendents
  if ignore_limit || !crsoff.nil?
  elsif untz.length>=untz2.length
    event.respond 'Your request is gibberish.' if ['hero','heroes','heros','unit','char','character','person','units','chars','charas','chara','people'].include?(args[0].downcase)
    return -1
  elsif mode==3
    return untz
  elsif untz.length.zero? && mode != 13
    event.respond 'There were no units that matched your request.' unless paired
    return -2
  end
  m=[]
  if myunit.length>0
    m.push(myunit)
    for i in 0...untz.length
      untz[i].stats40x(untz[i].dispStats(bot,40).map{|q| q})
      untz[i].stats1=untz[i].dispStats(bot,1).map{|q| q}
    end
  end
  for i in 0...colors2.length
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{colors2[i]}_Unknown"}
    colors2[i]="#{moji[0].mention} #{colors2[i]}" unless moji.length<=0
  end
  m.push("*Weapon colors:* #{colors2.join(', ')}") if colors2.length>0
  for i in 0...weapons.length
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{weapons[i].gsub('Healer','Staff')}"}
    weapons[i]="#{moji[0].mention} #{weapons[i]}" unless moji.length<=0
  end
  m.push("*Weapon types:* #{weapons.map{|q| q.gsub('Healer','Staff').gsub('Dragon','Breath')}.join(', ')}") if weapons.length>0
  for i in 0...color_weapons.length
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{color_weapons[i][0]}_#{color_weapons[i][1]}"}
    color_weapons[i]=color_weapons[i].join(' ').gsub('Healer','Staff')
    color_weapons[i]='Sword (Red Blade)' if color_weapons[i]=='Red Blade'
    color_weapons[i]='Lance (Blue Blade)' if color_weapons[i]=='Blue Blade'
    color_weapons[i]='Axe (Green Blade)' if color_weapons[i]=='Green Blade'
    color_weapons[i]='Rod (Colorless Blade)' if color_weapons[i]=='Colorless Blade'
    color_weapons[i]="#{moji[0].mention} #{color_weapons[i]}" unless moji.length<=0
  end
  m.push("*Complete weapons:* #{color_weapons.join(', ').gsub('Healer','Staff').gsub('Dragon','Breath')}") if color_weapons.length>0
  for i in 0...movements.length
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{movements[i]}"}
    movements[i]="#{moji[0].mention} #{movements[i]}" unless moji.length<=0
  end
  m.push("*Movement:* #{movements.join(', ')}") if movements.length>0
  m.push("*Complete classes:* #{clzz.map{|q| "#{q[0]} (#{q[1,q.length-1].compact.join(' ').gsub('Healer','Staff').gsub('Dragon','Breath')})"}.join(', ')}") if clzz.length>0
  m.push("\u{1F680} *Launch Units*") if launch
  m.push('<:Assist_Music:454462054959415296> *Refreshers*') if dancers
  if legendaries && mythics
    m.push('<:Legendary_Effect_Unknown:443337603945857024><:Mythic_Effect_Unknown:523328368079273984> *Legendaries/Mythics*')
  elsif legendaries
    m.push('<:Legendary_Effect_Unknown:443337603945857024> *Legendaries*')
  elsif mythics
    m.push('<:Mythic_Effect_Unknown:523328368079273984> *Mythics*')
  end
  if duos && harmonics
    m.push('<:Hero_Duo:631431055420948480><:Hero_Harmonic:722436762248413234> *Duo/Harmonic Units*')
  elsif duos
    m.push('<:Hero_Duo:631431055420948480> *Duo Units*')
  elsif harmonics
    m.push('<:Hero_Harmonic:722436762248413234> *Harmonic Units*')
  end
  m.push('<:Resplendent_Ascension:678748961607122945> *Resplendent*') if resplendents
  m.push("*Genders:* #{genders.map{|q| "#{q}#{'ale' if q=='M'}#{'emale' if q=='F'}"}.join(', ')}") if genders.length>0
  m.push("*Games:* #{xgames.join(', ')}") if xgames.length>0
  m.push("*Groups:* #{group.map{|q| q.fullName}.join(', ')}") if group.length>0
  m.push("*Stats:* #{statlimits.join(', ')}") if statlimits.length>0
  m.push("*Supernatures:* #{supernatures.map{|q| "#{q[1,q.length-1]} #{q[0].gsub('+','boon').gsub('-','bane')}"}.join(', ')}") if supernatures.length>0
  m.push("~~Xane's non-HP stats have little meaning when his weapon is equipped~~") if markxane
  unless crsoff.nil?
    m.push('')
    m.push('__**Excludes matches from this search**__')
    m.push(crsoff[0])
    m.flatten!
    untz=untz.reject{|q| crsoff[1].map{|q| q.name}.include?(q.name)}
  end
  ulength=untz.length
  ulength*=2 if group.map{|q| q.name}.include?('HallOfForms') && !group.map{|q| q.name}.include?('Forma')
  ulength*=2 if group.map{|q| q.name}.include?('Prfless') && !group.map{|q| q.name}.include?('Up4Prf')
  if (untz.map{|k| k.postName}.join("\n").length>=1900 || ulength>=25) && !safe_to_spam?(event) && !ignore_limit && mode != 13 && !paired
    str="__**Unit search**__\n#{m.join("\n")}\n\n__**Note**__\nAt #{untz.length} entries, there were so many unit matches that I would prefer you use the command in PM."
    str="#{str}\n\nI have noticed you are using the \"Hall of Forms\" group, which is a list of all units that appeared as playable in an HoF event.\nYou can reduce the number of units displayed by using the \"Forma\" group instead, as that's the list of units available with Forma Souls." if group.map{|q| q.name}.include?('HallOfForms') && !group.map{|q| q.name}.include?('Forma')
    str="#{str}\n\nI have noticed you are using the \"Prfless\" group, which is a list of all non-seasonal units without a Prf weapon.\nYou can reduce the number of units displayed by using the \"Up4Prf\" group instead, as that's the list of all such units who are likely to receive a retro-Prf soon." if group.map{|q| q.name}.include?('Prfless') && !group.map{|q| q.name}.include?('Up4Prf')
    event.respond str
    return -2
  elsif mode==2
    return untz
  elsif mode==1 || mode>=13
    f=untz.map{|k| k.name}
    return [m,untz] if mode>=13
    return [m,f]
  end
  return 1
end

def find_in_skills(bot,event,args=nil,mode=0,paired=false,ignore_limit=false,norename=false)
  data_load(['skill'])
  if args.nil?
    args=event.message.text.gsub(',','').split(' ')
    args.shift
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  crsoff=nil
  if args.join(' ').include?('~~')
    s=args.join(' ')
    sy=args.join(' ')
    while sy.include?('~~')
      sy=remove_format(sy,'~~')
    end
    args=sy.split(' ')
    sn="~~#{s.gsub('~~',' ~~ ')}~~"
    while sn.include?('~~')
      sn=remove_format(sn,'~~')
    end
    crsoff=find_in_skills(bot,event,sn.split(' '),3,true,true)
    crsoff=nil unless crsoff.is_a?(Array)
  end
  colors=[]
  weapons=[]
  skill_types=[]
  color_weapons=[]
  assists=[]
  specials=[]
  passives=[]
  weapon_subsets=[]
  passive_subsets=[]
  lookout=$skilltags.map{|q| q}
  for i in 0...args.length
    for i2 in 0...lookout.length
      if lookout[i2][1].include?(args[i].downcase)
        weapon_subsets.push(lookout[i2][0]) if lookout[i2][2]=='Weapon'
        assists.push(lookout[i2][0]) if lookout[i2][2]=='Assist'
        specials.push(lookout[i2][0]) if lookout[i2][2]=='Special'
        passives.push(lookout[i2][0]) if lookout[i2][2]=='Slot'
        passive_subsets.push(lookout[i2][0]) if lookout[i2][2]=='Passive'
      end
    end
    skill_types.push('Weapon') if ['weapon','weapons'].include?(args[i].downcase)
    skill_types.push('Assist') if ['assist','assists'].include?(args[i].downcase)
    skill_types.push('Special') if ['special','specials'].include?(args[i].downcase)
    skill_types.push('Passive') if ['passive','passives'].include?(args[i].downcase)
    skill_types.push('Duo') if ['duo','duos'].include?(args[i].downcase)
    skill_types.push('Harmonic') if ['harmonic','harmonics','resonant','resonants','resonance','resonances'].include?(args[i].downcase)
    colors.push('Red') if ['red','reds'].include?(args[i].downcase)
    colors.push('Blue') if ['blue','blues'].include?(args[i].downcase)
    colors.push('Green') if ['green','greens','grean','greans'].include?(args[i].downcase)
    colors.push('Colorless') if ['colorless','colourless','colorlesses','colourlesses','clear','clears'].include?(args[i].downcase)
    weapons.push('Blade') if ['physical','blade','blades','close','closerange'].include?(args[i].downcase)
    weapons.push('Tome') if ['tome','mage','spell','tomes','mages','spells','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Dragon') if ['dragon','dragons','breath','manakete','manaketes','close','closerange','fafnirs','fafnir'].include?(args[i].downcase)
    weapons.push('Beast') if ['beast','beasts','laguz','close','closerange'].include?(args[i].downcase)
    weapons.push('Bow') if ['bow','arrow','bows','arrows','archer','archers','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Dagger') if ['dagger','shuriken','knife','daggers','knives','thief','thiefs','thieves','range','ranged','distance','distant'].include?(args[i].downcase)
    weapons.push('Staff') if ['healer','staff','cleric','healers','clerics','staves','range','ranged','distance','distant','troubadour','trobadour','troubador','trobador','troubadours','trobadours','troubadors','trobadors'].include?(args[i].downcase)
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
  sklz=$skills.reject{|q| !q.isPostable?(event) || ['Whelp (All)','Yearling (All)','Adult (All)','Missiletainn','Falchion','Ragnarok+'].include?(q.name)}
  sklz2=sklz.map{|q| q.clone}
  skill_types2=skill_types.map{|q| q}
  sklz=sklz.reject{|q| !has_any?(skill_types,q.type) && !(skill_types.include?('Passive') && q.isPassive?)} if skill_types.length>0
  matches1=[]
  if colors.length>0 && weapons.length>0
    matches1=sklz.reject{|q| !has_any?(q.tags,colors) || !has_any?(q.tags,weapons.map{|q2| q2.gsub('Dragon','Breath')})}
  elsif colors.length>0
    matches1=sklz.reject{|q| !has_any?(q.tags,colors)}
  elsif weapons.length>0
    matches1=sklz.reject{|q| !has_any?(q.tags,weapons.map{|q2| q2.gsub('Dragon','Breath')})}
  end
  if color_weapons.length>0
    for i in 0...sklz.length
      for j in 0...color_weapons.length
        matches1.push(sklz[i]) if sklz[i].tags.include?(color_weapons[j][0]) && sklz[i].tags.include?(color_weapons[j][1].gsub('Dragon','Breath'))
      end
    end
  end
  sklz=sklz.reject{|q| q.type.include?('Weapon') && !matches1.include?(q)} if matches1.length>0
  if weapon_subsets.length>0
    matches1=sklz.reject{|q| !q.type.include?('Weapon')}
    for i in 0...matches1.length
      if has_any?(weapon_subsets,matches1[i].tags)
      elsif weapon_subsets.include?('Prf') && !matches1[i].exclusivity.nil?
      elsif weapon_subsets.include?('Inheritable') && matches1[i].exclusivity.nil?
      elsif weapon_subsets.include?('Retro-Prf') && !matches1[i].exclusivity.nil? && matches1[i].prerequisite.nil?
      elsif weapon_subsets.include?('Pega-killer') && !weapon_subsets.include?('Effective') && matches1[i].tags.include?('Bow') && !matches1[i].tags.include?('UnBow')
      elsif has_any?(weapon_subsets.map{|q| "(E)#{q}"},matches1[i].tags)
        matches1[i].name="#{matches1[i].name} *(+) Effect*" unless norename
      elsif has_any?(weapon_subsets.map{|q| "(R)#{q}"},matches1[i].tags)
        matches1[i].name="#{matches1[i].name} *(+) All*" unless norename
      elsif has_any?(weapon_subsets.map{|q| "(R)#{q}"},matches1[i].tags)
        matches1[i].name="#{matches1[i].name} *- Transformed*" unless norename
      elsif has_any?(weapon_subsets.map{|q| ["(ET)#{q}","(TE)#{q}","(E)(T)#{q}","(T)(E)#{q}"]}.flatten,matches1[i].tags)
        matches1[i].name="#{matches1[i].name} *(+) [Tsfrm]Effect*" unless norename
      elsif has_any?(weapon_subsets.map{|q| ["(RT)#{q}","(TR)#{q}","(R)(T)#{q}","(T)(R)#{q}"]}.flatten,matches1[i].tags)
        matches1[i].name="#{matches1[i].name} *(+) [Tsfrm]All*" unless norename
      else
        matches1[i]=nil
      end
    end
    matches1.compact!
    if matches1.length>0
      sklz=sklz.reject{|q| q.type.include?('Weapon')}
      sklz=[matches1,sklz].flatten
    end
  end
  sklz=sklz.reject{|q| q.type.include?('Weapon')} unless [colors,weapons,color_weapons,weapon_subsets].flatten.length>0 || skill_types.include?('Weapon')
  sklz=sklz.reject{|q| q.type.include?('Assist') && !has_any?(assists,q.tags)} if assists.length>0
  sklz=sklz.reject{|q| q.type.include?('Assist')} unless assists.length>0 || skill_types.include?('Assist')
  sklz=sklz.reject{|q| q.type.include?('Special') && !has_any?(specials,q.tags)} if specials.length>0
  sklz=sklz.reject{|q| q.type.include?('Special')} unless specials.length>0 || skill_types.include?('Special')
  sklz=sklz.reject{|q| q.isPassive? && !(has_any?(passives.map{|q2| "Passive(#{q2[0]})"},q.type) || (passives.include?('Seal') && q.type.include?('Seal')))} if passives.length>0
  sklz=sklz.reject{|q| q.isPassive?} unless passives.length>0 || passive_subsets.length>0 || skill_types.include?('Passive')
  sklz=sklz.reject{|q| (q.isPassive? || has_any?(q.type,['Duo','Harmonic'])) && !has_any?(passive_subsets,q.tags)} if passive_subsets.length>0
  sklz=sklz.reject{|q| q.type.include?('Duo')} unless passives.length>0 || passive_subsets.length>0 || skill_types.include?('Duo')
  sklz=sklz.reject{|q| q.type.include?('Harmonic')} unless passives.length>0 || passive_subsets.length>0 || skill_types.include?('Harmonic')
  if sklz.length>=sklz2.length && !crsoff.nil?
    event.respond 'Your request is gibberish.' unless ['skill','skills'].include?(args[0].downcase)
    return -1
  end
  m=[]
  skill_types=skill_types2.map{|q| q}
  for i in 0...skill_types2.length
    moji=bot.server(443704357335203840).emoji.values.reject{|q| q.name != "Skill_#{skill_types2[i]}"}
    moji=bot.server(443704357335203840).emoji.values.reject{|q| q.name != "#{skill_types2[i]}"} if skill_types2[i]=='Passive'
    skill_types2[i]="#{moji[0].mention} #{skill_types2[i]}" unless moji.length<=0
  end
  m.push("*Skill types:* #{skill_types2.join(', ')}") if skill_types2.length>0
  for i in 0...colors2.length
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{colors2[i]}_Unknown"}
    colors2[i]="#{moji[0].mention} #{colors2[i]}" unless moji.length<=0
  end
  m.push("*Weapon colors:* #{colors2.join(', ')}") if colors2.length>0
  for i in 0...weapons.length
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{weapons[i].gsub('Healer','Staff')}"}
    weapons[i]="#{moji[0].mention} #{weapons[i]}" unless moji.length<=0
  end
  m.push("*Weapon types:* #{weapons.map{|q| q.gsub('Healer','Staff').gsub('Dragon','Breath')}.join(', ')}") if weapons.length>0
  for i in 0...color_weapons.length
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{color_weapons[i][0]}_#{color_weapons[i][1]}"}
    color_weapons[i]=color_weapons[i].join(' ').gsub('Healer','Staff')
    color_weapons[i]='Sword (Red Blade)' if color_weapons[i]=='Red Blade'
    color_weapons[i]='Lance (Blue Blade)' if color_weapons[i]=='Blue Blade'
    color_weapons[i]='Axe (Green Blade)' if color_weapons[i]=='Green Blade'
    color_weapons[i]='Rod (Colorless Blade)' if color_weapons[i]=='Colorless Blade'
    color_weapons[i]="#{moji[0].mention} #{color_weapons[i]}" unless moji.length<=0
  end
  m.push("*Complete weapons:* #{color_weapons.join(', ').gsub('Healer','Staff')}") if color_weapons.length>0
  m.push("*Weapon subtypes:* #{weapon_subsets.join(', ')}") if weapon_subsets.length>0 && (skill_types.length<=0 || skill_types.include?('Weapon'))
  for i in 0...assists.length
    moji=bot.server(449988713330769920).emoji.values.reject{|q| q.name != "Assist_#{assists[i]}"}
    assists[i]="#{moji[0].mention} #{assists[i]}" unless moji.length<=0
  end
  m.push("*Assist subtypes:* #{assists.join(', ')}") if assists.length>0 && (skill_types.length<=0 || skill_types.include?('Assist'))
  for i in 0...specials.length
    moji=bot.server(449988713330769920).emoji.values.reject{|q| q.name != "Special_#{specials[i].gsub('Staff','Healer')}"}
    specials[i]="#{moji[0].mention} #{specials[i]}" unless moji.length<=0
    moji=bot.server(449988713330769920).emoji.values.reject{|q| q.name != "Special_Offensive_#{specials[i]}"}
    specials[i]="#{moji[0].mention} #{specials[i]}" unless moji.length<=0
    moji=bot.server(449988713330769920).emoji.values.reject{|q| q.name != "Special_Defensive_#{specials[i]}"}
    specials[i]="#{moji[0].mention} #{specials[i]}" unless moji.length<=0
  end
  m.push("*Special subtypes:* #{specials.join(', ')}") if specials.length>0 && (skill_types.length<=0 || skill_types.include?('Special'))
  for i in 0...passives.length
    passives[i]='<:Passive_A:443677024192823327> A' if passives[i]=='A'
    passives[i]='<:Passive_B:443677023257493506> B' if passives[i]=='B'
    passives[i]='<:Passive_C:443677023555026954> C' if passives[i]=='C'
    passives[i]='<:Passive_S:443677023626330122> Seal' if passives[i]=='Seal'
    passives[i]='<:Passive_W:443677023706152960> W' if passives[i]=='W'
  end
  m.push("*Passive slots:* #{passives.join(', ')}") if passives.length>0
  m.push("*Passive subtypes:* #{passive_subsets.map{|q| q.gsub('Staff','<:Passive_Staff:443677023848890388> Staff')}.join(', ')}") if passive_subsets.length>0 && (skill_types.length<=0 || skill_types.include?('Passive'))
  f2=sklz.map{|q| q}
  # display passive lines with multiple entries in the list as only one entry
  sklz=sklz.reject{|q| q.isPassive? && !q.level.nil? && !['-','example'].include?(q.level) && sklz.reject{|q2| q2.id/10!=q.id/10}.length>1}
  unless crsoff.nil?
    m.push('')
    m.push('__**Excludes matches from this search**__')
    m.push(crsoff[0])
    m.flatten!
    sklz=sklz.reject{|q| crsoff[2].map{|q| q.fullName}.include?(q.fullName)}
  end
  unless sklz.length<=100
    f2x=sklz.length
    sklz=sklz.reject{|q| 'Squad Ace '==q.name[0,10]} unless has_any?(args.map{|q| q.downcase},['squadace','squad','all'])
    sklz=sklz.reject{|q| 'Initiate Seal '==q.name[0,14]} unless has_any?(args.map{|q| q.downcase},['initiateseal','initiate','all'])
    m.push("A total of #{f2x-sklz.length} *Squad Ace* and *Initiate Seal* skills have been filtered out by default") unless sklz.length==f2x
  end
  unless norename
    for i in 0...sklz.length # display items with both the non-plus and + versions in the list as only one entry
      sklz[i].name="#{sklz[i].name.gsub('+','')}[+]" if sklz[i].name[-1]=='+' && sklz.map{|q| q.name}.include?(sklz[i].name.gsub('+',''))
    end
    x=sklz.map{|q| q.name}
    sklz=sklz.reject{|q| x.include?("#{q.name}[+]")}
    x=sklz.map{|q| q.id/10}.uniq
    y=[]
    for i in 0...x.length
      z=sklz.reject{|q| q.id/10 != x[i]}.sort{|a,b| a.id<=>b.id}
      if z[0].name[0,10]=='Falchion ('
        y.push(z)
        y.flatten!
      elsif has_any?(z.map{|q| q.tags}.flatten,['Iron','Steel','Silver']) && z[-1].name.split(' ').length>1 && !z[0].restrictions.include?('Dragons Only')
        z[-1].name="#{z.map{|q| q.name.split(' ')[0]}.join('/')} #{z[-1].name.split{' '}[1,z[-1].name.split{' '}.length-1].join(' ')}"
        y.push(z[-1])
      else
        z[-1].name=z.map{|q| q.name}.join('/')
        y.push(z[-1])
      end
    end
    sklz=y.map{|q| q}
  end
  if (sklz.length>25 || sklz.map{|q| q.fullName(f2)}.join("\n").length>=1900) && !safe_to_spam?(event) && mode==3 && !paired && !ignore_limit
    event.respond "__**Skill search**__\n#{m.join("\n")}\n\n__**Note**__\nAt #{sklz.length} entries, there were so many skill matches that I would prefer you use the command in PM." unless paired
    return -2
  elsif sklz.length.zero?
    event.respond 'There were no skills that matched your request.' unless paired
    return -2
  elsif mode==1
    f=sklz.map{|k| k.fullName(f2)}
    return [m,f]
  elsif mode==2 || mode==3
    return [m,sklz,f2]
  end
  return 1
end

def find_in_banners(bot,event,args=nil,mode=0,ff=false,ignore_limit=false)
  data_load(['banner'])
  if args.nil?
    args=event.message.text.gsub(',','').split(' ')
    args.shift
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  xtags=[]
  lookout=$skilltags.reject{|q| q[2]!='Banner'}
  b=$banners.map{|q| q}
  for i in 0...args.length
    for i2 in 0...lookout.length
      xtags.push(lookout[i2][0]) if lookout[i2][1].include?(args[i].downcase)
    end
  end
  xtags.uniq!
  b=b.reject{|q| q.tags.include?('Dynamic')} unless mode==1
  m=[]
  if xtags.include?('Current') && xtags.include?('Upcoming')
    m.push('*Current/Upcoming Banners*')
    b=b.reject{|q| q.isPast? || q.start_date.nil? || q.end_date.nil?}
  elsif xtags.include?('Current')
    m.push('*Current Banners*')
    b=b.reject{|q| !q.isCurrent?}
  elsif xtags.include?('Upcoming')
    m.push('*Upcoming Banners*')
    b=b.reject{|q| !q.isFuture?}
  end
  xtags=xtags.reject{|q| ['Current','Upcoming'].include?(q)}
  if xtags.length>0
    m.push("*Tags:* #{xtags.join(', ')}")
    if event.message.text.downcase.split(' ').include?('any')
      m.push('(searching for banners with any listed tag)') if xtags.length>1
      b=b.reject{|q| !has_any?(xtags, q.tags)}
    else
      m.push("(searching for banners with all listed tags)\n\n__**Additional Notes**__\nSearching defaults to searching for banners with all listed tags.\nTo search for banners with any of the listed tags, perform the search again with the word \"any\" in your message.") if xtags.length>1
      for i in 0...xtags.length
        b=b.reject{|q| !q.tags.include?(xtags[i])}
      end
    end
  end
  b.reverse!
  b.uniq!
  if (b.length>25 || b.map{|q| q.name}.join("\n").length>=1900) && !safe_to_spam?(event) && mode==0 && !ignore_limit
    event.respond "__**Banner search**__\n#{m.join("\n")}\n\n__**Note**__\nAt #{b.length} entries, there were so many banner matches that I would prefer you use the command in PM."
    return -2
  elsif b.length.zero?
    event.respond 'There were no banners that matched your request.'
    return -2
  else
    return [m,b]
  end
end

def display_units(bot,event,args=nil,mode=0)
  data_load()
  if args.nil?
    args=event.message.text.gsub(',','').split(' ')
    args.shift
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k=find_in_units(bot,event,args,14)
  return nil unless k.is_a?(Array)
  mk=k[0]
  k=k[1]
  k2=k.reject{|q| !q.fake.nil?}
  f=nil
  f=triple_finish(k.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}) unless k.length<=0
  if k.length<=0 && ($embedless.include?(event.user.id) || was_embedless_mentioned?(event))
    event.respond "__**Unit search**__\n#{mk.join("\n")}\n\n__**Results**__\nNo matches found"
    return nil
  elsif k.length<=0
    create_embed(event,"__**Unit search**__\n#{mk.join("\n")}\n\n__**Results**__",'No matches found',0xD49F61)
    return nil
  elsif k.map{|q| q.unit_group(true)}.uniq.length<=1 && k[0].weapon_type=='Tome' && k.map{|q| q.tome_tree}.uniq.length>1
    f=[]
    f.push(['<:Fire_Tome:499760605826252800> Fire Mages',k.reject{|q| q.tome_tree != 'Fire'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.tome_tree != 'Fire'}.length>0
    f.push(['<:Dark_Tome:499958772073103380> Dark Mages',k.reject{|q| q.tome_tree != 'Dark'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.tome_tree != 'Dark'}.length>0
    f.push(['<:Thunder_Tome:499790911178539009> Thunder Mages',k.reject{|q| q.tome_tree != 'Thunder'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.tome_tree != 'Thunder'}.length>0
    f.push(['<:Light_Tome:499760605381787650> Light Mages',k.reject{|q| q.tome_tree != 'Light'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.tome_tree != 'Light'}.length>0
    f.push(['<:Wind_Tome:499760605713137664> Wind Mages',k.reject{|q| q.tome_tree != 'Wind'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.tome_tree != 'Wind'}.length>0
    f.push(['<:Stone_Tome:694404021313732648> Stone Mages',k.reject{|q| q.tome_tree != 'Stone'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.tome_tree != 'Stone'}.length>0
  elsif k.map{|q| q.weapon_color}.uniq.length>1
    f=[]
    x=k[0].weapon_type
    x='Unknown' if k.map{|q| q.weapon_type}.uniq.length>1
    x5="#{x}"
    x='Mage' if x=='Tome'
    x2=['Red','Blue','Green','Colorless','Gold']
    for i in 0...x2.length
      mojix=''
      moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x2[i]}_#{x5}"}
      mojix=moji[0].mention unless moji.length<=0
      x3="#{x2[i]}#{" #{x}s" unless x=='Unknown'}".gsub('Staffs','Healers')
      x3="Swords" if x3=='Red Blades'
      x3="Lances" if x3=='Blue Blades'
      x3="Axes" if x3=='Green Blades'
      x3="Rods" if x3=='Colorless Blades'
      f.push(["#{mojix} #{x3}",k.reject{|q| q.weapon_color != x2[i]}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.weapon_color != x2[i]}.length>0
    end
  elsif k.map{|q| q.weapon_type}.uniq.length>1
    f=[]
    x=k.map{|q| q.weapon_type}.uniq
    x2=k[0].weapon_color
    x2='Gold' if k.map{|q| q.weapon_color}.uniq.length>1
    for i in 0...x.length
      mojix=''
      moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x2}_#{x[i]}"}
      mojix=moji[0].mention unless moji.length<=0
      x3="#{x2}#{" #{x[i]}s" unless x=='Unknown'}".gsub('Staffs','Healers')
      x3="Swords" if x3=='Red Blades'
      x3="Lances" if x3=='Blue Blades'
      x3="Axes" if x3=='Green Blades'
      x3="Rods" if x3=='Colorless Blades'
      f.push(["#{mojix} #{x3}",k.reject{|q| q.weapon_type != x[i]}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.weapon_type != x[i]}.length>0
    end
  elsif k.map{|q| q.movement}.uniq.length>1
    f=[]
    x=['Infantry','Armor','Flier','Cavalry']
    for i in 0...x.length
      mojix=''
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{x[i]}"}
      mojix=moji[0].mention unless moji.length<=0
      x3="#{x[i]}"
      x3="#{x[i]}s" if ['Flier','Armor'].include?(x[i])
      f.push(["#{mojix} #{x3}",k.reject{|q| q.movement != x[i]}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if k.reject{|q| q.movement != x[i]}.length>0
    end
  elsif mk.include?('<:Assist_Music:454462054959415296> *Refreshers*')
    f2=[k.reject{|q| !q.isRefresher?('Dancer')}.length,k.reject{|q| !q.isRefresher?('Singer')}.length,k.reject{|q| !q.isRefresher?('Bard')}.length]
    if f2.reject{|q| q<=0}.length>1
      f=[]
      f2=k.reject{|q| !q.isRefresher?('Dancer')}
      f.push(['Dancers',f2.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if f2.length>0
      f2=k.reject{|q| !q.isRefresher?('Singer')}
      f.push(['Singers',f2.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if f2.length>0
      f2=k.reject{|q| !q.isRefresher?('Bard')}
      f.push(['Bards',f2.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if f2.length>0
    end
  end
  metadata_load()
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event) || "__**Unit search**__\n#{mk.join("\n")}\n\n__**Results**__\n#{f.map{|q| "*#{q[0]}:* #{q[1].gsub("\n",', ')}"}}\n\n#{k.length} total#{" (#{k2.length} actual)" unless k2.length>=k.length}".length>=1900
    str="__**Unit search**__\n#{mk.join("\n")}\n\n__**Results**__"
    if f.length<=1
      f=f[0][1].split("\n")
      for i in 0...f.length
        str=extend_message(str,f[i],event,1,', ')
      end
    else
      for i in 0...f.length
        if "*#{f[i][0]}:* #{f[i][1].gsub("\n",', ')}".length>1500
          f[i][1]=f[i][1].split("\n")
          for i2 in 0...f[i][1].length
            chr=', '
            chr="\n" if i2==0
            str=extend_message(str,f[i][1][i2],event,1,chr)
          end
        else
          str=extend_message(str,"*#{f[i][0]}:* #{f[i][1].gsub("\n",', ')}",event)
        end
      end
    end
    str=extend_message(str,"#{k.length} total#{" (#{k2.length} actual)" unless k2.length>=k.length}",event,2)
    event.respond str
  elsif f.length<=1 && k.length<=10
    str=k.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")
    create_embed(event,"__**Unit search**__\n#{mk.join("\n")}\n\n__**Results**__",str,0xD49F61,"#{k.length} total#{" (#{k2.length} actual)" unless k2.length>=k.length}")
  else
    f=triple_finish(k.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}) if f.length<=1
    create_embed(event,"__**Unit search**__\n#{mk.join("\n")}\n\n__**Results**__",'',0xD49F61,"#{k.length} total#{" (#{k2.length} actual)" unless k2.length>=k.length}",nil,f,2)
  end
  return nil
end

def display_skills(bot,event,args=nil,mode=0)
  data_load()
  if args.nil?
    args=event.message.text.gsub(',','').split(' ')
    args.shift
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k=find_in_skills(bot,event,args,3)
  return nil unless k.is_a?(Array)
  mk=k[0]
  kx=k[2]
  k=k[1]
  k2=k.reject{|q| !q.fake.nil?}
  f=nil
  f=triple_finish(k.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}) unless k.length<=0
  if k.length<=0 && ($embedless.include?(event.user.id) || was_embedless_mentioned?(event))
    event.respond "__**Skill search**__\n#{mk.join("\n")}\n\n__**Results**__\nNo matches found"
    return nil
  elsif k.length<=0
    create_embed(event,"__**Skill search**__\n#{mk.join("\n")}\n\n__**Results**__",'No matches found',0xD49F61)
    return nil
  elsif k.reject{|q| q.type.include?('Weapon')}.length<=0 && k.reject{|q| q.restrictions[0].include?('Tome Users Only')}.length<=0 && k.map{|q| q.restrictions[0]}.uniq.length<=1
    f=[]
    if k.reject{|q| q.restrictions[0].include?('Red Tome Users Only')}.length<=0
      x=k.reject{|q| q.tome_tree != 'Fire'}
      f.push(['<:Fire_Tome:499760605826252800> Fire Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
      x=k.reject{|q| q.tome_tree != 'Raudr'}
      f.push(['<:Red_Tome:443172811826003968> Raudr Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
      x=k.reject{|q| q.tome_tree != 'Dark'}
      f.push(['<:Dark_Tome:499958772073103380> Dark Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    elsif k.reject{|q| q.restrictions[0].include?('Blue Tome Users Only')}.length<=0
      x=k.reject{|q| q.tome_tree != 'Thunder'}
      f.push(['<:Thunder_Tome:499790911178539009> Thunder Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
      x=k.reject{|q| q.tome_tree != 'Blar'}
      f.push(['<:Blue_Tome:467112472394858508> Blar Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
      x=k.reject{|q| q.tome_tree != 'Light'}
      f.push(['<:Light_Tome:499760605381787650> Light Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    elsif k.reject{|q| q.restrictions[0].include?('Green Tome Users Only')}.length<=0
      x=k.reject{|q| q.tome_tree != 'Wind'}
      f.push(['<:Wind_Tome:499760605713137664> Wind Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
      x=k.reject{|q| q.tome_tree != 'Gronn'}
      f.push(['<:Green_Tome:467122927666593822> Gronn Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    elsif k.reject{|q| q.restrictions[0].include?('Colorless Tome Users Only')}.length<=0
      x=k.reject{|q| q.tome_tree != 'Stone'}
      f.push(['<:Stone_Tome:694404021313732648> Stone Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
      x=k.reject{|q| q.tome_tree != 'Hoss'}
      f.push(['<:Colorless_Tome:443692133317345290> Hoss Magic',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    end
  elsif k.reject{|q| q.type.include?('Weapon')}.length<=0 && k.reject{|q| q.restrictions[0].include?('Beasts Only')}.length<=0
    f=[]
    x=k.reject{|q| q.tome_tree != 'Infantry'}
    f.push(['<:Icon_Move_Infantry:443331187579289601> Infantry Beast weapons',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| q.tome_tree != 'Armor'}
    f.push(['<:Icon_Move_Armor:443331186316673025> Armor Beast weapons',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| q.tome_tree != 'Flier'}
    f.push(['<:Icon_Move_Flier:443331186698354698> Flying Beast weapons',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| q.tome_tree != 'Cavalry'}
    f.push(['<:Icon_Move_Cavalry:443331186530451466> Cavalry Beast weapons',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  elsif k.reject{|q| q.type.include?('Weapon')}.length<=0
    colorsx=k.map{|q| q.tags.reject{|q2| !['Red','Blue','Green','Colorless','Gold'].include?(q2)}}
    colors=[]
    colors.push('Red') if colorsx.reject{|q| q.include?('Red')}.length<=0
    colors.push('Blue') if colorsx.reject{|q| q.include?('Blue')}.length<=0
    colors.push('Green') if colorsx.reject{|q| q.include?('Green')}.length<=0
    colors.push('Colorless') if colorsx.reject{|q| q.include?('Colorless')}.length<=0
    colors.push('Gold') if colorsx.reject{|q| q.include?('Gold')}.length<=0
    emotes=['<:Gold_Staff:774013610988797953>','<:Gold_Dagger:774013610862968833>','<:Gold_Dragon:774013610908581948>','<:Gold_Bow:774013609389981726>','<:Gold_Beast:774013608191459329>']
    emotes[0]='<:Colorless_Staff:443692132323295243>' unless $units.reject{|q| !q.isPostable?(event) || q.weapon_type != 'Healer' || q.weapon_color == 'Colorless'}.length>0
    emotes=['<:Red_Staff:443172812455280640>','<:Red_Dagger:443172811490721804>','<:Red_Dragon:443172811796774932>','<:Red_Bow:443172812455280641>','<:Red_Beast:532853459444170753>'] if colors.length==1 && colors[0]=='Red'
    emotes=['<:Blue_Staff:467112472407703553>','<:Blue_Dagger:467112472625545217>','<:Blue_Dragon:467112473313542144>','<:Blue_Bow:467112473313542155>','<:Blue_Beast:532853459842629642>'] if colors.length==1 && colors[0]=='Blue'
    emotes=['<:Green_Staff:467122927616262144>','<:Green_Dagger:467122926655897610>','<:Green_Dragon:467122926718550026>','<:Green_Bow:467122927536570380>','<:Green_Beast:532853459779846154>'] if colors.length==1 && colors[0]=='Green'
    emotes=['<:Colorless_Staff:443692132323295243>','<:Colorless_Dagger:443692132683743232>','<:Colorless_Dragon:443692132415438849>','<:Colorless_Bow:443692132616896512>','<:Colorless_Beast:532853459804749844>'] if colors.length==1 && colors[0]=='Colorless'
    emotes[0]='<:Colorless_Staff:443692132323295243>' unless $units.reject{|q| !q.isPostable?(event) || q.weapon_type != 'Healer' || q.weapon_color == 'Colorless'}.length>0
    f=[]
    x=k.reject{|q| !q.restrictions.include?('Sword Users Only')}
    f.push(['<:Red_Blade:443172811830198282> Swords',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Red Tome Users Only')}
    f.push(['<:Red_Tome:443172811826003968> Red Tomes',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Lance Users Only')}
    f.push(['<:Blue_Blade:467112472768151562> Lances',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}
    f.push(['<:Blue_Tome:467112472394858508> Blue Tomes',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Axe Users Only')}
    f.push(['<:Green_Blade:467122927230386207> Axes',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Green Tome Users Only')}
    f.push(['<:Green_Tome:467122927666593822> Green Tomes',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}
    f.push(['<:Colorless_Tome:443692133317345290> Colorless Tomes',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Dragons Only')}
    f.push(["#{emotes[2]} Dragon Breaths",x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Bow Users Only')}
    f.push(["#{emotes[3]} Bows",x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Dagger Users Only')}
    f.push(["#{emotes[1]} Daggers",x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Beasts Only')}
    f.push(["#{emotes[4]} Beast Damage",x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.restrictions.include?('Staff Users Only')}
    f.push(["#{emotes[0]} Damaging Staves",x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  elsif k.reject{|q| q.type.include?('Assist')}.length<=0
    f=[]
    x=k.reject{|q| !q.tags.include?('Music')}
    f.push(['<:Assist_Music:454462054959415296> Musical Assists',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('Staff')}
    f.push(['<:Assist_Staff:454451496831025162> Healing Staves',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('Move') || q.tags.include?('Music') || q.tags.include?('Staff')}
    f.push(['<:Assist_Move:454462055479508993> Movement Assists',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('Health') || q.tags.include?('Staff')}
    f.push(['<:Assist_Health:454462054636584981> Health Assists',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('Rally')}
    f.push(['<:Assist_Rally:454462054619807747> Rally Assists',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| has_any?(q.tags,['Music','Staff','Move','Health','Rally'])}
    f.push(['<:Assist_Unknown:454451496482897921> Misc. Assists',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  elsif k.reject{|q| q.type.include?('Special')}.length<=0 && k.reject{|q| q.tags.include?('Offensive')}.length<=0
    f=[]
    x=k.reject{|q| !q.tags.include?('MoonSpecial') || q.tags.include?('EclipseSpecial')}
    f.push(['<:Special_Offensive_Moon:454473651345948683> Moon Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('SunSpecial') || q.tags.include?('EclipseSpecial')}
    f.push(['<:Special_Offensive_Sun:454473651429965834> Sun Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('EclipseSpecial')}
    f.push(['<:Special_Offensive_Eclipse:454473651308199956> Eclipse Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('StarSpecial')}
    f.push(['<:Special_Offensive_Star:454473651396542504> Star Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('FireSpecial')}
    f.push(['<:Special_Offensive_Fire:454473651861979156> Fire Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('IceSpecial')}
    f.push(['<:Special_Offensive_Ice:454473651291422720> Ice Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('DragonSpecial')}
    f.push(['<:Special_Offensive_Dragon:454473651186696192> Dragon Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('DarknessSpecial')}
    f.push(['<:Special_Offensive_Darkness:454473651010535435> Darkness Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('RendSpecial')}
    f.push(['<:Special_Offensive_Rend:454473651119718401> Rend Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| has_any?(q.tags,['MoonSpecial','SunSpecial','EclipseSpecial','StarSpecial','FireSpecial','IceSpecial','DragonSpecial','DarknessSpecial','RendSpecial'])}
    f.push(['<:Special_Offensive:454460020793278475> Misc. Offensive Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  elsif k.reject{|q| q.type.include?('Special')}.length<=0 && k.reject{|q| q.tags.include?('Defensive')}.length<=0
    f=[]
    x=k.reject{|q| !q.tags.include?('AegisSpecial') || q.tags.include?('SupershieldSpecial')}
    f.push(['<:Special_Defensive_Aegis:454460020625768470> Aegis Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('PaviseSpecial') || q.tags.include?('SupershieldSpecial')}
    f.push(['<:Special_Defensive_Pavise:454460020801929237> Pavise Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('SupershieldSpecial')}
    f.push(['<:Special_Defensive_Supershield:454460021066170378> Supershield Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('MiracleSpecial')}
    f.push(['<:Special_Defensive_Miracle:454460020973764610> Miracle Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| has_any?(q.tags,['MiracleSpecial','SupershieldSpecial','PaviseSpecial','AegisSpecial'])}
    f.push(['<:Special_Defensive:454460020591951884> Misc. Defensive Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  elsif k.reject{|q| q.type.include?('Special')}.length<=0
    f=[]
    x=k.reject{|q| !q.tags.include?('Offensive')}
    f.push(['<:Special_Offensive:454460020793278475> Offensive Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('Defensive')}
    f.push(['<:Special_Defensive:454460020591951884> Defensive Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('AoE')}
    f.push(['<:Special_AoE:454460021665693696> Area-of-Effect Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.tags.include?('Staff')}
    f.push(['<:Special_Healer:454451451805040640> Healer Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| has_any?(q.tags,['Offensive','Defensive','AoE','Staff'])}
    f.push(['<:Special_Unknown:454451451603976192> Misc. Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  elsif k.reject{|q| q.isPassive?}.length<=0 && mk.include?("*Passive slots:* <:Passive_S:443677023626330122> Seal")
    f=[]
    x=k.reject{|q| q.shard_color.nil? || q.shard_color[0].downcase != 'scarlet'}
    f.push(['<:Great_Badge_Scarlet:443704781001850910> Scarlet Seals',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| q.shard_color.nil? || q.shard_color[0].downcase != 'azure'}
    f.push(['<:Great_Badge_Azure:443704780783616016> Azure Seals',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| q.shard_color.nil? || q.shard_color[0].downcase != 'verdant'}
    f.push(['<:Great_Badge_Verdant:443704780943261707> Verdant Seals',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| q.shard_color.nil? || q.shard_color[0].downcase != 'transparent'}
    f.push(['<:Great_Badge_Transparent:443704781597573120> Transparent Seals',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| q.shard_color.nil? || q.shard_color[0].downcase != 'gold'}
    f.push(['<:Great_Badge_Golden:443704781068959744> Golden Seals',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.shard_color.nil? && ['scarlet','azure','verdant','transparent','gold'].include?(q.shard_color[0].downcase)}
    f.push(['<:Great_Badge_Unknown:443704780754255874> Seals of unknown color',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  elsif k.reject{|q| q.isPassive?}.length<=0
    f=[]
    x=k.reject{|q| !q.type.include?('Passive(A)')}
    f.push(['<:Passive_A:443677024192823327> A Passives',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.type.include?('Passive(B)')}
    f.push(['<:Passive_B:443677023257493506> B Passives',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.type.include?('Passive(C)')}
    f.push(['<:Passive_C:443677023555026954> C Passives',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    xx=kx.reject{|q| !has_any?(q.type,['Passive(S)','Seal'])}
    x=xx.reject{|q| !['example','-'].include?(q.level)}
    f.push(['<:Passive_S:443677023626330122> Sacred Seals',x.map{|q| q.postName(xx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=kx.reject{|q| !q.type.include?('Passive(W)')}
    f.push(['<:Passive_W:443677023706152960> Weapon Effects',x.map{|q| q.postName(x,true,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.uniq.join("\n")]) if x.length>0
  elsif k.reject{|q| q.restrictions.include?('Staff Users Only')}.length<=0
    f=[]
    x=k.reject{|q| !q.type.include?('Weapon')}
    f.push(['<:Colorless_Staff:443692132323295243> Damaging Staves',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.type.include?('Assist')}
    f.push(['<:Assist_Staff:454451496831025162> Healing Staves',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.type.include?('Special')}
    f.push(['<:Special_Healer:454451451805040640> Healer Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.isPassive?}
    f.push(['<:Passive_Staff:443677023848890388> Healer Passives',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !has_any?(q.type,['Duo','Harmonic'])}
    f.push(['<:Hero_Duo:631431055420948480><:Hero_Harmonic:722436762248413234> Duo/Harmonic Skills',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  else
    f=[]
    x=k.reject{|q| !q.type.include?('Weapon')}
    f.push(['<:Skill_Weapon:444078171114045450> Weapons',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.type.include?('Assist')}
    f.push(['<:Skill_Assist:444078171025965066> Assists',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.type.include?('Special')}
    f.push(['<:Skill_Special:444078170665254929> Specials',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.isPassive?}
    f.push(['<:Passive:544139850677485579> Passives',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.type.include?('Duo')}
    f.push(['<:Hero_Duo:631431055420948480> Duo Skills',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
    x=k.reject{|q| !q.type.include?('Harmonic')}
    f.push(['<:Hero_Harmonic:722436762248413234> Harmonic Skills',x.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")]) if x.length>0
  end
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event) || "__**Skill search**__\n#{mk.join("\n")}\n\n__**Results**__\n#{f.map{|q| "*#{q[0]}:* #{q[1].gsub("\n",', ')}"}}\n\n#{k.length} total#{" (#{k2.length} actual)" unless k2.length>=k.length}".length>=1900
    str="__**Skill search**__\n#{mk.join("\n")}\n\n__**Results**__"
    if f.length<=1
      f=f[0][1].split("\n")
      for i in 0...f.length
        str=extend_message(str,f[i],event,1,', ')
      end
    else
      for i in 0...f.length
        if "*#{f[i][0]}:* #{f[i][1].gsub("\n",', ')}".length>1500
          f[i][1]=f[i][1].split("\n")
          for i2 in 0...f[i][1].length
            chr=', '
            chr="\n" if i2==0
            str=extend_message(str,f[i][1][i2],event,1,chr)
          end
        else
          str=extend_message(str,"*#{f[i][0]}:* #{f[i][1].gsub("\n",', ')}",event)
        end
      end
    end
    str=extend_message(str,"#{k.length} total#{" (#{k2.length} actual)" unless k2.length>=k.length}",event,2)
    event.respond str
  elsif f.length<=1 && k.length<=10
    str=k.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")
    create_embed(event,"__**Skill search**__\n#{mk.join("\n")}\n\n__**Results**__",str,0xD49F61,"#{k.length} total#{" (#{k2.length} actual)" unless k2.length>=k.length}")
  else
    f=triple_finish(k.map{|q| q.postName(kx,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}) if f.length<=1
    create_embed(event,"__**Skill search**__\n#{mk.join("\n")}\n\n__**Results**__",'',0xD49F61,"#{k.length} total#{" (#{k2.length} actual)" unless k2.length>=k.length}",nil,f,2)
  end
  return nil
end

def display_banners(bot,event,args=nil,mode=0)
  data_load(['banner'])
  if args.nil?
    args=event.message.text.gsub(',','').split(' ')
    args.shift
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  b=find_in_banners(bot,event,args,0)
  return nil unless b.is_a?(Array)
  str=''
  str="__**Banner Search**__\n#{b[0].join("\n")}" if b[0].length>0
  b=b[1]
  for i in 0...b.length
    x=['','']
    x[0]=b[i].start_date
    x[0]="#{x[0][0]}#{['','Jan','Feb','Mar','Apr','May','June','July','Aug','Sept','Oct','Nov','Dec'][x[0][1].to_i]}#{x[0][2]}" unless x[0].nil?
    x[1]=b[i].end_date
    x[1]="#{x[1][0]}#{['','Jan','Feb','Mar','Apr','May','June','July','Aug','Sept','Oct','Nov','Dec'][x[1][1].to_i]}#{x[1][2]}" unless x[1].nil?
    b[i].name="#{b[i].name} (#{x.join(' - ')})" unless x.reject{|q| q.length<=0}.length<=0
  end
  b=b.map{|q| q.name}
  if (b.length>20 || str.length+b.join("\n").length>=1900) && !safe_to_spam?(event)
    event.respond "#{str}\n\n__**Note**__\nAt #{b.length} entries, too much data is trying to be displayed.  Please use this command in PM."
  elsif str.length+b.join("\n").length>=1900
    str="#{str}\n\n__**Results**__"
    for i in 0...b.length
      str=extend_message(str,b[i],event)
    end
    str=extend_message(str,"#{b.length} total.",event,2)
    event.respond str
  else
    str="#{str}\n\n__**Results**__"
    create_embed(event,str,b.join("\n"),0xD49F61,"#{b.length} total.")
  end
end

def display_units_and_skills(bot,event,args=nil,xmode=0)
  args=event.message.text.split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  metadata_load()
  mode=1
  mode=0 if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
  (event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) rescue nil) if event.message.text.length>90
  if args.nil? || args.length.zero?
    p1=find_in_units(bot,event,args,13,true)
    p2=find_in_skills(bot,event,args,3,true)
    if !p1.is_a?(Array) && !p2.is_a?(Array)
      event.respond 'Your request is gibberish.'
    elsif !p1.is_a?(Array)
      display_skills(bot,event,args,mode)
    elsif !p2.is_a?(Array)
      display_units(bot,event,args,mode)
    else
      event.respond "I'm not displaying all units *and* all skills!"
    end
  elsif ['help'].include?(args[0].downcase)
    subcommand=nil
    subcommand=args[0] unless args.nil? || args.length.zero?
    subcommand='' if subcommand.nil?
    help_text(event,bot,'find',subcommand)
  elsif ['hero','heroes','heros','unit','char','character','person','units','chars','charas','chara','people'].include?(args[0].downcase)
    display_units(bot,event,args,mode)
  elsif ['skill','skills'].include?(args[0].downcase)
    display_skills(bot,event,args,mode)
  elsif ['summon','summons','banner','banners'].include?(args[0].downcase)
    display_banners(bot,event,args,mode)
  else
    p1=find_in_units(bot,event,args,13,true)
    p2=find_in_skills(bot,event,args,3,true)
    if !p1.is_a?(Array) && !p2.is_a?(Array)
      event.respond 'Your request is gibberish.'
      return nil
    elsif !p1.is_a?(Array)
      display_skills(bot,event,args,mode)
      return nil
    elsif !p2.is_a?(Array)
      display_units(bot,event,args,mode)
      return nil
    end
    m=[p1[0]]
    p1=p1[1]
    m.push(p2[0])
    x=p2[2].map{|q| q}
    p2=p2[1]
    if !p1.is_a?(Array) && !p2.is_a?(Array)
      event.respond 'Your request is gibberish.'
      return nil
    elsif !p1.is_a?(Array)
      display_skills(bot,event,args,mode)
      return nil
    elsif !p2.is_a?(Array)
      display_units(bot,event,args,mode)
      return nil
    end
    m2=m.flatten.uniq
    m3=[]
    for i in 0...m2.length
      m3.push(m2[i]) if m[0].include?(m2[i]) && m[1].include?(m2[i])
    end
    m[0]=m[0].reject{|q| m3.include?(q)}
    m[1]=m[1].reject{|q| m3.include?(q)}
    hdr=[]
    hdr.push("__**Overall Search**__\n#{m3.join("\n")}") if m3.length>0
    hdr.push("__**Unit Search**__\n#{m[0].join("\n")}") if m[0].length>0
    hdr.push("__**Skill Search**__\n#{m[1].join("\n")}") if m[1].length>0
    hdr=hdr.join("\n\n")
    if p1.map{|q| q.postName(true)}.join("\n").length+p2.map{|q| q.postName(x,false,true)}.join("\n").length+hdr.length<=1950 && (p1.length+p2.length<=25 || safe_to_spam?(event))
      unless $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        untz=p1.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")
        sklz=p2.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n")
        if p2.reject{|q| q.type.include?('Weapon')}.length<=0 # weapons only
          if p1.map{|q| q.weapon_type}.uniq.length<=1 && p1[0].weapon_type=='Beast' # beasts
            untz=[]
            untz.push(p1.reject{|q| q.movement != 'Infantry'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.movement != 'Armor'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.movement != 'Flier'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.movement != 'Cavalry'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| ['Infantry','Armor','Flier','Cavalry'].include?(q.movement)}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz=untz.reject{|q| q.length<=0}.join("\n\n")
          elsif p1.map{|q| q.weapon_type}.uniq.length<=1 && p1.map{|q| q.weapon_color}.uniq.length<=1 && p1.map{|q| q.tome_tree}.uniq.length>1 && p1[0].weapon_type=='Tome' # tomes
            untz=[]
            untz.push(p1.reject{|q| q.tome_tree != 'Fire'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.tome_tree != 'Dark'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.tome_tree != 'Thunder'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.tome_tree != 'Light'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.tome_tree != 'Wind'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.tome_tree != 'Stone'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| ['Fire','Dark','Thunder','Light','Wind','Stone'].include?(q.tome_tree)}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz=untz.reject{|q| q.length<=0}.join("\n\n")
          elsif p1.map{|q| q.weapon_color}.uniq.length<=1 && p1.map{|q| q.weapon_type}.uniq.length>1 # same weapon color but different types
            untz=[]
            untz.push(p1.reject{|q| q.weapon_type != 'Blade'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_type != 'Tome'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_type != 'Dragon'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_type != 'Bow'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_type != 'Dagger'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_type != 'Beast'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_type != 'Healer'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| ['Blade','Tome','Dagger','Bow','Dragon','Beast','Healer'].include?(q.weapon_type)}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz=untz.reject{|q| q.length<=0}.join("\n\n")
          elsif p1.map{|q| q.weapon_color}.uniq.length>1 # multiple weapon colors
            untz=[]
            untz.push(p1.reject{|q| q.weapon_color != 'Red'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_color != 'Blue'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_color != 'Green'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| q.weapon_color != 'Colorless'}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz.push(p1.reject{|q| ['Red','Blue','Green','Colorless'].include?(q.weapon_color)}.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            untz=untz.reject{|q| q.length<=0}.join("\n\n")
          end
          if p2.reject{|q| q.restrictions.include?('Beasts Only')}.length<=0 # beast weapons
            sklz=[]
            sklz.push(p2.reject{|q| q.tome_tree != 'Infantry'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Armor'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Flier'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Cavalry'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| ['Infantry','Armor','Cavalry','Flier'].include?(q.tome_tree) || q.isPassive?}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz=sklz.reject{|q| q.length<=0}.join("\n\n")
          elsif p2.map{|q| q.weapon_color}.uniq.length<=1 && p2.reject{|q| q.tags.include?('Tome')}.length<=0 # tomes
            sklz=[]
            sklz.push(p2.reject{|q| q.tome_tree != 'Fire'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Raudr'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Dark'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Thunder'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Blar'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Light'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Wind'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Gronn'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Stone'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.tome_tree != 'Hoss'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| ['Fire','Raudr','Dark','Thunder','Blar','Light','Wind','Gronn','Stone','Hoss'].include?(q.tome_tree) || q.isPassive?}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz=sklz.reject{|q| q.length<=0}.join("\n\n")
          elsif p2.map{|q| q.weapon_color}.uniq.length<=1
            sklz=[]
            sklz.push(p2.reject{|q| !has_any?(q.restrictions,['Sword Users Only','Lance Users Only','Axe Users Only','Rod Users Only'])}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| !has_any?(q.restrictions,['Red Tome Users Only','Blue Tome Users Only','Green Tome Users Only','Colorless Tome Users Only','Tome Users Only'])}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| has_any?(q.restrictions,['Sword Users Only','Lance Users Only','Axe Users Only','Rod Users Only','Red Tome Users Only','Blue Tome Users Only','Green Tome Users Only','Colorless Tome Users Only','Tome Users Only','Dragons Only','Bow Users Only','Dagger Users Only','Beasts Only','Staff Users Only'])}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz=sklz.reject{|q| q.length<=0}.join("\n\n")
          elsif p2.map{|q| q.weapon_color}.uniq.length>1 # multiple weapon colors
            sklz=[]
            sklz.push(p2.reject{|q| q.weapon_color != 'Red'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.weapon_color != 'Blue'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.weapon_color != 'Green'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| q.weapon_color != 'Colorless'}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz.push(p2.reject{|q| ['Red','Blue','Green','Colorless'].include?(q.weapon_color)}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
            sklz=sklz.reject{|q| q.length<=0}.join("\n\n")
          end
        elsif p2.map{|q| q.type}.uniq.length>1 && p2.reject{|q| q.isPassive?}.length>0 && p2.reject{|q| q.restrictions.include?('Staff Users Only')}.length<=0 # staff skills
          sklz=[]
          sklz.push(p2.reject{|q| !q.type.include?('Weapon')}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
          sklz.push(p2.reject{|q| !q.type.include?('Assist')}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
          sklz.push(p2.reject{|q| !q.type.include?('Special')}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
          sklz.push(p2.reject{|q| !q.isPassive?}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
          sklz.push(p2.reject{|q| has_any?(q.type,['Weapon','Assist','Special']) || q.isPassive?}.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}.join("\n"))
          sklz=sklz.reject{|q| q.length<=0}.join("\n\n")
        end
        create_embed(event,"#{hdr}\n\n__**Results**__",'',0xD49F61,"Totals: #{p1.uniq.length} units, #{p2.uniq.length} skills",nil,[['**Units**',untz],['**Skills**',sklz]],2)
        return nil
      end
    elsif !safe_to_spam?(event)
      str="#{hdr}"
      str=extend_message(str,"__**Note**__\nToo much data is trying to be displayed.  Please use this command in PM.",event,2)
      str=extend_message(str,"Totals: #{p1.uniq.length} units, #{p2.uniq.length} skills",event,2)
      event.respond str
      return nil
    end
    t="#{hdr}"
    t=extend_message(t,"__**Results**__",event,2)
    p1=p1.map{|q| q.postName(true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
    t=extend_message(t,"*Units:* #{p1[0]}",event)
    if p1.length>1
      for i in 1...p1.length
        t=extend_message(t,p1[i],event,1,', ')
      end
    end
    p2=p2.map{|q| q.postName(x,false,true)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
    t=extend_message(t,"*Skills:* #{p2[0]}",event,1)
    if p2.length>1
      for i in 1...p2.length
        t=extend_message(t,p2[i],event,1,', ')
      end
    end
    t=extend_message(t,"Totals: #{p1.uniq.length} units, #{p2.uniq.length} skills",event,2)
    event.respond t
  end
end

def sort_units(bot,event,args=nil)
  args=event.message.text.downcase.split(' ') if args.nil? || args.length.zero?
  (event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) rescue nil) if event.message.text.length>90
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  f=[0,0,0,0,0,0,0,0,0,0,0]
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
    v=10 if ['banner','banners'].include?(args[i].downcase)
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
  k=find_in_units(bot,event,args,13,false,true)
  return nil unless k.is_a?(Array)
  mk=k[0]
  k=k[1]
  s=['Name','<:HP_S:514712247503945739>HP','<:StrengthS:514712248372166666>Attack','<:SpeedS:514712247625580555>Speed','<:DefenseS:514712247461871616>Defense','<:ResistanceS:514712247574986752>Resistance','<:Arena_Medal:453618312446738472>BST','<:FreezePrtS:712371368037187655>FrzProtect','<:Divine_Dew:453618312434417691>Photon Points','<:Current_Arena_Bonus:498797967042412544>Bin','Banners']
  mk.push("*Sorted by:* #{f[0,10].uniq.map{|q| s[q]}.compact.join(', ')}")
  v=mk.find_index{|q| q[0,8]=='*Stats:*'}
  unless v.nil?
    v=mk[v]
    f.push(1) if v.include?('HP') && !f.include?(1)
    f.push(2) if v.include?('Atk') && !f.include?(2)
    f.push(3) if v.include?('Spd') && !f.include?(3)
    f.push(4) if v.include?('Def') && !f.include?(4)
    f.push(5) if v.include?('Res') && !f.include?(5)
  end
  if args.map{|q| q.downcase}.include?('stats')
    f.push(1) unless f.include?(1)
    f.push(2) unless f.include?(2)
    f.push(3) unless f.include?(3)
    f.push(4) unless f.include?(4)
    f.push(5) unless f.include?(5)
  end
  event.channel.send_temporary_message('Units found, sorting now...',3) rescue nil
  k=k.reject{|q| q.stats40.max<=0} # remove units for whom stats are unknown
  k=k.reject{|q| q.stats40[0,5].max<=0} unless has_any?(args,['enemy','enemies'])
  t=0
  b=0
  for i in 0...args.length
    if args[i].downcase[0,3]=='top' && t.zero?
      t=[args[i][3,args[i].length-3].to_i,k.length].min
    elsif args[i].downcase[0,6]=='bottom' && b.zero?
      b=[args[i][6,args[i].length-6].to_i,k.length].min
    end
  end
  for i in 0...k.length
    k[i].sort_data=k[i].stats40[0,5]
    k[i].sort_data=k[i].stats40[5,5] if k[i].stats40[0,5].max<=0
    k[i].sort_data=k[i].sort_data.map{|q| q+2} if k[i].hasResplendent?
    k[i].sort_data.push(k[i].sort_data[0,5].inject(0){|sum,x| sum + x })
    k[i].sort_data.push([k[i].sort_data[3],k[i].sort_data[4]].min)
    k[i].sort_data.push(k[i].sort_data[3]-k[i].sort_data[4])
    k[i].sort_data.push(k[i].sort_data[5]/5)
    k[i].sort_data[-1]+=0.1 if k[i].hasDuelAccess? && k[i].sort_data[-1]<34
    k[i].sort_data[-1]+=0.2 if k[i].hasDuelAccess?(4) && k[i].sort_data[-1]<36 && k[i].legendary.nil?
    k[i].sort_data[-1]=35 if !k[i].legendary.nil? && k[i].legendary[1]=='Duel'
    k[i].sort_data[-1]=36 if !k[i].legendary.nil? && k[i].legendary[1]=='Duel' && k[i].id>=500
    k[i].sort_data[-1]=37 if !k[i].legendary.nil? && k[i].legendary[1]=='Duel' && k[i].id>=640
    k[i].sort_data[-1]=37 unless k[i].duo.nil? || k[i].duo[0][0]=='Harmonic'
    k[i].sort_data[-1]=38 unless k[i].duo.nil? || k[i].duo[0][0]=='Harmonic' || k[i].id<=590
    k[i].sort_data.push(k[i].focus_banners.length)
    k[i].sort_data.unshift(k[i].name)
    k[i].sort_data.push(0)
    for i2 in 1...6
      k[i].sort_data[i2]+=0.1 if k[i].supernatures[i2-1]==' '
      k[i].sort_data[i2]+=0.2 if k[i].supernatures[i2-1]=='+'
    end
  end
  k=k.reject{|q| !q.fake.nil?} if t>0 || b>0
  k=k.reject{|q| !q.fake.nil? || !(q.availability[0].include?('p') || q.availability[0].gsub('0s','').include?('s'))} if f.include?(10)
  for i in 0...f.length
    f[i]=-1 if f[i]<=0
  end
  k=k.sort{|c,a| (a.sort_data[f[0]]<=>c.sort_data[f[0]])==0 ? ((a.sort_data[f[1]]<=>c.sort_data[f[1]])==0 ? ((a.sort_data[f[2]]<=>c.sort_data[f[2]])==0 ? ((a.sort_data[f[3]]<=>c.sort_data[f[3]])==0 ? ((a.sort_data[f[4]]<=>c.sort_data[f[4]])==0 ? ((a.sort_data[f[5]]<=>c.sort_data[f[5]])==0 ? ((a.sort_data[f[6]]<=>c.sort_data[f[6]])==0 ? ((a.sort_data[f[7]]<=>c.sort_data[f[7]])==0 ? ((a.sort_data[f[8]]<=>c.sort_data[f[8]])==0 ? ((a.sort_data[f[9]]<=>c.sort_data[f[9]])==0 ? c.name<=>a.name : (a.sort_data[f[9]]<=>c.sort_data[f[9]])) : (a.sort_data[f[8]]<=>c.sort_data[f[8]])) : (a.sort_data[f[7]]<=>c.sort_data[f[7]])) : (a.sort_data[f[6]]<=>c.sort_data[f[6]])) : (a.sort_data[f[5]]<=>c.sort_data[f[5]])) : (a.sort_data[f[4]]<=>c.sort_data[f[4]])) : (a.sort_data[f[3]]<=>c.sort_data[f[3]])) : (a.sort_data[f[2]]<=>c.sort_data[f[2]])) : (a.sort_data[f[1]]<=>c.sort_data[f[1]])) : (a.sort_data[f[0]]<=>c.sort_data[f[0]])}
  for i in 0...f.length
    f[i]=0 if f[i]<=0
  end
  display=[0,k.length]
  if t>0
    display=[0,t]
    mk.push("Showing top #{t} results")
  elsif b>0
    display=[k.length-b,k.length]
    mk.push("Showing bottom #{b} results")
  end
  m=[]
  m.push("__**Unit search**__\n#{mk.join("\n")}") if mk.length>0
  mk=[]
  mk.push("Please note that the stats listed are for neutral-nature units without stat-affecting skills.")
  mk.push("The Strength/Magic stat also does not account for weapon might.") if f.include?(2)
  m2=[]
  s=['','HP','Attack','Speed','Defense','Resistance','BST','FrzProtect','Photon Points','Bin','Banners']
  for i in display[0]...display[1]
    ls=[]
    for j in 0...f.length
      sf=s[f[j]]
      sf=k[i].atkName(true).gsub('Freeze','Magic') if f[j]==2 # give the proper attack stat name
      sfn=''
      sfn=k[i].supernatures.map{|q| "#{'(' unless q==' '}#{q unless q==' '}#{') ' unless q==' '}"}[f[j]-1] if f[j]>0 && f[j]<6
      if f[j]<=0
      elsif k[i].sort_data[f[j]]<0 && sf.length>0
        k[i].sort_data[f[j]]=0-k[i].sort_data[f[j]]
        sf="Anti#{sf[0,1].downcase}#{sf[1,sf.length-1]}"
        ls.push("#{k[i].sort_data[f[j]]} #{sfn}#{sf}")
      elsif f[j]==9
        ls.push("#{sf} ##{k[i].sort_data[f[j]].to_i} (#{k[i].sort_data[f[j]].to_i*5}-#{k[i].sort_data[f[j]].to_i*5+4})#{' <:P_Duel_Unknown:770193543935295490>' if k[i].hasDuelAccess? && k[i].sort_data[f[j]].to_i<34}")
      elsif f[j]==8 && k[i].sort_data[f[j]]>=5
        ls.push("*#{k[i].sort_data[f[j]]} #{sfn}#{sf}*") if sf.length>0
      else
        ls.push("#{k[i].sort_data[f[j]].to_i} #{sfn}#{sf}") if sf.length>0
      end
    end
    m2.push("#{'~~' unless k[i].fake.nil?}**#{k[i].name}**#{k[i].emotes(bot)}#{'<:Resplendent_Ascension:678748961607122945>' if k[i].hasResplendent?}#{' - ' if ls.length>0}#{ls.join(', ')}#{'~~' unless k[i].fake.nil?}")
  end
  if has_any?(f,[1,2,3,4,5]) && m2.join("\n").include?("(+)") && m2.join("\n").include?("(-)")
    mk.push("(+) and (-) mark units for whom a boon or unmerged bane would increase or decrease a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.")
  elsif has_any?(f,[1,2,3,4,5]) && m2.join("\n").include?("(+)")
    mk.push("(+) marks units for whom a boon would increase a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.")
  elsif has_any?(f,[1,2,3,4,5]) && m2.join("\n").include?("(-)")
    mk.push("(-) marks units for whom an unmerged bane would decrease a stat by 4 instead of the usual 3.\nThis can affect the order of units listed here.")
  end
  mk.push("<:Resplendent_Ascension:678748961607122945> marks units who have a Resplendent Ascension.  This increases all their stats by 2, which is reflected in the stats displayed here.") if k.reject{|q| !q.hasResplendent?}.length>0
  mk.push("<:P_Duel_Unknown:770193543935295490> marks units who have access to a Duel skill.  This increases their Bin to 34 (Phantom BST of 170-174) if equipped.\nNon-legendary, non-mythic units who have access to a T4 Duel skill have their Bin increased to 36 (Phantom BST of 180-184) instead.") if m2.join("\n").include?('<:P_Duel_Unknown:770193543935295490>')
  if has_any?(f,[7,8,9])
    mm=[]
    mm.push("FrzProtect is the lower of the units' Defense and Resistance stats, used by dragonstones when attacking ranged units and by Felicia's Plate all the time.") if f.include?(7)
    mm.push("Light Brand deals +7 damage to units with at least 5 Photon Points.") if f.include?(8)
    mm.push("The order of units listed here can be affected by natures#{" that affect a unit's Defense and/or Resistance" unless f.include?(9)}.")
    mk.push(mm.join("  "))
  end
  mk.push("When sorting by banner count, units not in the summon pool at all are removed") if f.include?(10)
  if "#{m[0]}\n\n__**Aditional Notes**__\n#{mk.join("\n#{"\n" if mk.reject{|q| !q.include?("\n")}.length>0}")}\n\n__**Results**__\n#{m2.join("\n")}".length>2000 && !safe_to_spam?(event)
    mk.push("Too much data is trying to be displayed.  Showing top ten results.\nYou can also make things easier by making the list shorter with words like `top#{rand(10)+1}` or `bottom#{rand(10)+1}`\nAlternatively, you can narrow by specific stats with words like `#{['HP','Atk','Spd','Def','Res'].sample}#{['>','<'].sample}#{rand(20)+15}`")
    m2=m2[0,10]
  end
  m.push("__**Aditional Notes**__\n#{mk.join("\n#{"\n" if mk.reject{|q| !q.include?("\n")}.length>0}")}") if mk.length>0
  m=m.join("\n\n")
  for i in 0...m2.length
    m=extend_message(m,"#{"\n" if i<=0}#{m2[i]}",event)
  end
  event.respond m
  return nil
end

def sort_skills(bot,event,args=[])
  args=event.message.text.downcase.split(' ') if args.nil? || args.length.zero?
  (event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) rescue nil) if event.message.text.length>90
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k=find_in_skills(bot,event,args,3,false,true)
  return nil unless k.is_a?(Array)
  mk=k[0]
  k=k[1]
  k=k.reject{|q| q.name[0,14]=='Initiate Seal ' || q.name[0,10]=='Squad Ace '}
  for i in 0...k.length
    k[i].sort_data=[k[i].sp_cost,0]
    if k[i].refine.nil?
    elsif k[i].exclusivity.nil? || k[i].exclusivity.length<=0
      k[i].sort_data[1]=350
    else
      k[i].sort_data[1]=400
    end
    if k[i].name.include?("*(+) Effect*") || k[i].name.include?("*(+) All*")
      k[i].sort_data[0]=k[i].sort_data[1]*1
      k[i].sort_data[1]=0
    end
  end
  k.sort! {|b,a| ((a.sort_data[0]<=>b.sort_data[0]) == 0 ? ((a.sort_data[1]<=>b.sort_data[1]) == 0 ? (b.name<=>a.name) : (a.sort_data[1]<=>b.sort_data[1])) : (a.sort_data[0]<=>b.sort_data[0]))}
  str="#{"__**Search**__\n#{mk.join("\n")}\n\n__**Additional Notes**__\n" if mk.length>0}All SP costs are without accounting for increased inheritance costs (1.5x the SP costs listed below)"
  for i in 0...k.length
    k[i].name="**#{k[i].name}**#{k[i].emotes(bot)} - #{k[i].sort_data[0]} SP"
    if k[i].type.include?('Weapon') && k[i].sort_data[1]>k[i].sort_data[0] && k[i].sort_data[0]>0
      k[i].name="#{k[i].name} (#{k[i].sort_data[1]} SP when refined)"
    elsif k[i].type.include?('Weapon') && k[i].sort_data[1]==k[i].sort_data[0] && k[i].sort_data[0]>0
      k[i].name="#{k[i].name} (refinement possible)"
    end
    unless k[i].exclusivity.nil? || k[i].exclusivity.length<=0
      y=k[i].exclusivity.map{|q| $units.find_index{|q2| q2.name==q}}.compact.map{|q| $units[q]}.reject{|q| !q.fake.nil?}.map{|q| q.name}
      k[i].name="#{k[i].name} - Prf to #{y.join(', ')}" if y.length>0
    end
  end
  if k.map{|q| q.name}.join("\n").length+str.length>1950 && !safe_to_spam?(event)
    str="#{str}\n\nThere are too many skills to list.  Please try this command in PM.\nShowing top ten results."
    k=k[0,10]
  end
  for i in 0...k.length
    str=extend_message(str,"#{"\n" if i==0}#{k[i].name}",event)
  end
  event.respond str
end

def pick_random_unit(event,args=[],bot=nil)
  k=find_in_units(bot,event,args,13,false,true)
  return nil unless k.is_a?(Array)
  mk=k[0]
  k=k[1]
  k=k.reject{|q| !q.fake.nil?} unless args.map{|q| q.downcase}.include?('all')
  disp_unit_stats(bot,event,k.sample,nil,'smol',false)
end

def pick_random_skill(event,args=[],bot=nil)
  k=find_in_skills(bot,event,args,3,false,true,true)
  return nil unless k.is_a?(Array)
  mk=k[0]
  k=k[1]
  k=k.reject{|q| !q.fake.nil?} unless args.map{|q| q.downcase}.include?('all')
  disp_skill_data(bot,event,k.sample.name)
end

def stats_of_multiunits(bot,event,args=nil,mode=0)
  if [-2,2].include?(mode)
    k=args.map{|q| q[0].clone}
  else
    args=event.message.text.downcase.split(' ') if args.nil? || args.length.zero?
    (event.channel.send_temporary_message('Calculating data, please wait...',event.message.text.length/30-1) rescue nil) if event.message.text.length>90
    args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
    k=find_in_units(bot,event,args,13,false,true)
    return nil unless k.is_a?(Array)
    mk=k[0]
    k=k[1]
    k=k.reject{|q| q.stats40.nil? || q.stats40[0,5].max<=0}
    k=k.reject{|q| !q.fake.nil?} unless args.map{|q| q.downcase}.include?('all')
  end
  hstats=[[0,[]],[0,[]],[0,[]],[0,[]],[0,[]],[0,[]]]
  hstats=[[1000,[]],[1000,[]],[1000,[]],[1000,[]],[1000,[]],[1000,[]]] if mode<0
  atkstat=[]
  ccz=[]
  for i in 0...k.length
    ccz.push(k[i].disp_color(0))
    atkstat.push(k[i].atkName(true))
    if [-2,2].include?(mode)
      k[i].sort_data=k[i].dispStats(bot,40,args[i][1],args[i][3],args[i][4],args[i][2],args[i][5])
      k[i].sort_data=k[i].dispStats(bot,40,args[i][1],args[i][3],args[i][4],args[i][2],args[i][5],'','',[],true)
      k[i].sort_data.push(k[i].sort_data.inject(0){|sum,x2| sum + x2 })
      k[i].name=args[i][6].gsub(k[i].name,'').gsub(' ','') unless args[i][6]==k[i].name
    else
      k[i].sort_data=k[i].stats40[0,5].map{|q| q}
      k[i].sort_data=k[i].stats40[0,5].map{|q| q+2} if k[i].hasResplendent? && k[i].owner.nil?
      k[i].sort_data.push(k[i].stats40[0]+k[i].stats40[1]+k[i].stats40[2]+k[i].stats40[3]+k[i].stats40[4])
    end
    for i2 in 0...k[i].sort_data.length
      if mode==0 # average stats
        hstats[i2][0]+=k[i].sort_data[i2]
      elsif mode<0 # lowest stats
        x=''
        x='*' if i2<5 && k[i].supernatures[i2]=='-' && (k[i].owner.nil? || k[i].merge_count==0)
        x='' if [-2,2].include?(mode) && args.reject{|q| q[1]<5 || q[3].length<=0 || q[3]==' ' || q[4].length<=0 || q[4]==' '}.length>0
        if k[i].sort_data[i2]<hstats[i2][0]
          hstats[i2]=[k[i].sort_data[i2],["#{x}#{k[i].name}#{x}"]]
        elsif k[i].sort_data[i2]==hstats[i2][0]
          hstats[i2][1].push("#{x}#{k[i].name}#{x}")
        end
      else # highest stats
        x=''
        x='*' if i2<5 && k[i].supernatures[i2]=='+'
        x='' if [-2,2].include?(mode) && args.reject{|q| q[1]<5 || q[3].length<=0 || q[3]==' ' || q[4].length<=0 || q[4]==' '}.length>0
        if k[i].sort_data[i2]>hstats[i2][0]
          hstats[i2]=[k[i].sort_data[i2],["#{x}#{k[i].name}#{x}"]]
        elsif k[i].sort_data[i2]==hstats[i2][0]
          hstats[i2][1].push("#{x}#{k[i].name}#{x}")
        end
      end
    end
  end
  if ccz.length.zero?
    ccz=0xFFD800
  else
    ccz=avg_color(ccz)
  end
  stzzz=['HP','Attack','Speed','Defense','Resistance','BST']
  stemoji=['<:HP_S:514712247503945739>','<:GenericAttackS:514712247587569664>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>','']
  if atkstat.uniq.length==1
    stzzz[1]=atkstat.uniq[0] unless atkstat.uniq[0]=='Freeze'
    stemoji[1]='<:StrengthS:514712248372166666>' if atkstat.uniq[0]=='Strength'
    stemoji[1]='<:MagicS:514712247289774111>' if atkstat.uniq[0]=='Magic'
    stemoji[1]='<:FreezeS:514712247474585610>' if atkstat.uniq[0]=='Freeze'
  end
  hbst=0
  x='Average'
  x='Highest' if mode>0
  x='Lowest' if mode<0
  for iz in 0...hstats.length
    hbst+=hstats[iz][0] if iz<5
    if mode==0
      hstats[iz][0]=div_100(hstats[iz][0]*100/k.length)
      hstats[iz]="#{stemoji[iz]}#{x} #{stzzz[iz]}: #{hstats[iz][0]}"
    elsif hstats[iz][1].length>=k.length
      hstats[iz]="#{stemoji[iz]}Constant #{stzzz[iz]}: #{hstats[iz][0]}"
    else
      hstats[iz]="#{stemoji[iz]}#{x} #{stzzz[iz]}: #{hstats[iz][0]} (#{hstats[iz][1].sort{|a,b| a.gsub('*','')<=>b.gsub('*','')}.join(', ')})"
    end
    hstats[iz]="\n#{hstats[iz]}" if iz==5
  end
  hstats.push("BST of #{x.downcase} stats: #{hbst}") unless mode==0
  x='Best' if mode>0
  x='Worst' if mode<0
  ftr=nil
  ftr='Italic names have a superboon in the listed stat' if mode>0 && hstats.join("\n").include?('*')
  ftr='Italic names have a superbane in the listed stat' if mode<0 && hstats.join("\n").include?('*')
  ftr='Units with Resplendent Ascensions are calculated with those stats' if k.reject{|q| !q.hasResplendent? || !q.owner.nil?}.length>0
  return [hstats.join("\n"),ftr] if [-2,2].include?(mode)
  x2=''
  x2="__**Unit Search**__\n#{mk.join("\n")}\n\n" if mk.length>0
  create_embed(event,"#{x2}__**#{x} among #{k.length} units**__",hstats.join("\n"),ccz,ftr)
end

def list_aliases(bot,event,args=nil,saliases=false,dispdata=false)
  if args.nil? || args.length.zero?
    args=event.message.text.downcase.split(' ')
    args.shift
  end
  data_load()
  len=3
  len=5 if (args.length<=0 || ['hero','heroes','heros','unit','units','characters','character','chara','charas','char','chars','skill','skills','skil','skils','structures','structure','struct','structs','items','item','accessorys','accessory','accessories'].include?(args[0].downcase)) && safe_to_spam?(event) && !dispdata
  (event.channel.send_temporary_message('Calculating data, please wait...',len) rescue nil) unless dispdata
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  k=nil
  k=find_best_match(event,args,nil,bot,false,0) unless (args.length<=0 || ['hero','heroes','heros','unit','units','characters','character','chara','charas','char','chars','skill','skills','skil','skils','structures','structure','struct','structs','items','item','accessorys','accessory','accessories'].include?(args[0].downcase))
  args=[''] if args.nil? || args.length<=0
  if k.nil? && (!safe_to_spam?(event) || event.server.id==350067448583553024) && !(saliases && !event.server.nil? && $aliases.reject{|q| q[3].nil? || !q[3].include?(event.server.id)}.length<=20)
    alz=args.join(' ')
    alz='>censored mention<' if alz.include?('@')
    str="The alias system can cover:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- Structures\n- Items\n- Accessories"
    str="#{str}\n\n*#{alz}* does not fall into any of these categories." if alz.length>0
    str="#{str}\n\nPlease include what you wish to look up the aliases for, or use this command in PM.\nBut if you do that, prepare to be getting messages for a long time.  There's #{longFormattedNumber($aliases.length)} of them." if alz.length<=0
    event.respond str
    return nil
  elsif ['hero','heroes','heros','unit','units','characters','character','chara','charas','char','chars','skill','skills','skil','skils'].include?(args[0].downcase)
    alztyp=''
    alztyp='Unit' if ['hero','heroes','heros','unit','units','characters','character','chara','charas','char','chars'].include?(args[0].downcase)
    alztyp='Skill' if ['skill','skills','skil','skils'].include?(args[0].downcase)
    x=$aliases.reject{|q| q[0]!=alztyp || q[2].is_a?(Array)}
    x=x.reject{|q| !q[3].nil? && !q[3].include?(event.server.id)} unless event.server.nil?
    x=x.reject{|q| q[3].nil?} if saliases
    u=[]
    u=$units.map{|q| q} if alztyp=='Unit'
    u=$skills.map{|q| q} if alztyp=='Skill'
    x=x.reject{|q| !q[2].is_a?(String) && (u.find_index{|q2| q2.id==q[2]}.nil? || !u[u.find_index{|q2| q2.id==q[2]}].name==q[2] || !u[u.find_index{|q2| q2.id==q[2]}].isPostable?(event))}
    f=["__**#{'Server-specific ' if saliases}#{alztyp} Aliases**__"]
    if event.server.nil?
      for i in 0...x.length
        str="#{x[i][1].gsub('`',"\`").gsub('*',"\*")} = "
        if x[i][2].is_a?(String)
          str="#{str}#{x[i][2]}"
        else
          str="#{str}#{u[u.find_index{|q2| q2.id==x[i][2]}].name}"
        end
        if q[3].nil?
          f.push(str)
        else
          f2=[]
          for j in 0...x[i][3].length
            srv=(bot.server(x[i][3][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              f2.push("*#{bot.server(x[i][3][j]).name}*") unless event.user.on(x[i][3][j]).nil?
            end
          end
          f.push("#{str} (in the following servers: #{list_lift(f2,'and')})") unless f2.length<=0
        end
      end
    else
      f=x.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")} = #{q[2] if q[2].is_a?(String)}#{u[u.find_index{|q2| q2.id==q[2]}].name if !q[2].is_a?(String)}#{' *[in this server only]*' unless q[3].nil? || saliases}"}
      f.unshift("__**#{'Server-specific ' if saliases}#{alztyp} Aliases**__")
    end
    unless saliases || alztyp != 'Unit'
      f.push(' ')
      f.push("__**Multi-Unit Aliases**__")
      x=$aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}
      for i in 0...x.length
        if x[i][2].reject{|q| !q.is_a?(String)}.length<=0 # purely unit names
          f.push("#{x[i][1].gsub('`',"\`").gsub('*',"\*")} = #{x[i][2].map{|q| u[u.find_index{|q2| q2.id==q}].name}.join(', ')}")
        elsif x[i][2].reject{|q| q.is_a?(String)}.length<=0 # purely unit IDs
          f.push("#{x[i][1].gsub('`',"\`").gsub('*',"\*")} = #{x[i][2].join(', ')}")
        end
      end
    end
  elsif ['structures','structure','struct','structs','items','item','accessorys','accessory','accessories'].include?(args[0].downcase)
    alztyp=''
    alztyp='Structure' if ['structures','structure','struct','structs'].include?(args[0].downcase)
    alztyp='Item' if ['items','item'].include?(args[0].downcase)
    alztyp='Accessory' if ['accessorys','accessory','accessories'].include?(args[0].downcase)
    x=$aliases.reject{|q| q[0]!=alztyp}
    x=x.reject{|q| !q[3].nil? && !q[3].include?(event.server.id)} unless event.server.nil?
    x=x.reject{|q| q[3].nil?} if saliases
    f=["__**#{'Server-specific ' if saliases}#{alztyp} Aliases**__"]
    if event.server.nil?
      for i in 0...x.length
        str="#{x[i][1].gsub('`',"\`").gsub('*',"\*")} = #{x[i][2]}"
        if q[3].nil?
          f.push(str)
        else
          f2=[]
          for j in 0...x[i][3].length
            srv=(bot.server(x[i][3][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              f2.push("*#{bot.server(x[i][3][j]).name}*") unless event.user.on(x[i][3][j]).nil?
            end
          end
          f.push("#{str} (in the following servers: #{list_lift(f2,'and')})") unless f2.length<=0
        end
      end
    else
      f=x.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")} = #{q[2]}#{' *[in this server only]*' unless q[3].nil? || saliases}"}
      f.unshift("__**#{'Server-specific ' if saliases}#{alztyp} Aliases**__")
    end
  elsif args.length>0 && args[0].length>0 && k.nil?
    alz=args.join(' ')
    alz='>censored mention<' if alz.include?('@')
    str="The alias system can cover:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- Structures\n- Items\n- Accessories"
    str="#{str}\n\n*#{alz}* does not fall into any of these categories."
    event.respond str
    return nil
  elsif k.nil?
    data_load(['aliases'])
    f=list_aliases(bot,event,['units'],saliases,true)
    f.push(' ')
    f.push(list_aliases(bot,event,['skills'],saliases,true))
    f.push(' ')
    f.push(list_aliases(bot,event,['structures'],saliases,true))
    f.push(' ')
    f.push(list_aliases(bot,event,['items'],saliases,true))
    f.push(' ')
    f.push(list_aliases(bot,event,['accessories'],saliases,true))
    f.flatten!
  elsif k.is_a?(Array) && k.length>0
    if k[0].is_a?(FEHUnit) && k.length>1 && k.reject{|q| ['Robin(F)','Robin(M)','Kris(F)','Kris(M)'].include?(q.name)}.length<=0
      k=k[0].clone
      k.name=k.name.split('(')[0]
      f=k.alias_list(bot,event,saliases)
      k2=find_data_ex(:find_skill,event,args,nil,bot)
      unless k2.nil? || ![k.name,"#{k.name}'s"].include?(k2.name.split(' ')[0])
        f.push(' ')
        f.push(k2.alias_list(bot,event,saliases))
        f.flatten!
      end
    elsif k[0].is_a?(FEHUnit)
      f=k.map{|q| q.alias_list(bot,event,saliases)}
      k2=$aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}
      for i in 0...k.length
        k2=k2.reject{|q| !q[2].include?(k[i].id) && !q[2].include?(k[i].name)}
        f[i].push(' ')
      end
      if k2.length>0 && !saliases
        k2=k2.map{|q| q[1]}
        if k.length>2
          k2.unshift('__**Multi-unit aliases that contain all of these units**__')
        elsif k.length==2
          k2.unshift('__**Multi-unit aliases that contain both of these units**__')
        else
          k2.unshift('__**Multi-unit aliases that contain this unit**__')
        end
        f.push(k2)
      end
      k2=find_data_ex(:find_skill,event,args,nil,bot)
      puts k2.to_s
      unless k2.nil? || ![k[0].name,"#{k[0].name}'s"].include?(k2.name.split(' ')[0])
        f.push(' ')
        f.push(k2.alias_list(bot,event,saliases))
      end
      f.flatten!
    else
      k=k[0]
      f=k.alias_list(bot,event,saliases)
    end
  elsif k.is_a?(FEHUnit)
    f=k.alias_list(bot,event,saliases)
    k2=$aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array) || !(q[2].include?(k.id) || q[2].include?(k.name))}
    if k2.length>0 && !saliases
      f.push(' ')
      f.push('__**Multi-unit aliases that contain this unit**__')
      f.push(k2.map{|q| q[1]})
      f.flatten!
    end
    args=["arden's"] if k.name=='Arden' # Without this line, Ardent Durandal will overwrite Arden's Blade when looking up the unit Arden, and the skill won't display
                                        # While technically intended behavior, since Ardent Durandal came first, it is not what users would expect given things like Berkut's Lance
    k2=find_data_ex(:find_skill,event,args,nil,bot)
    unless k2.nil? || !([k.name,"#{k.name}'s"].include?(k2.name.split(' ')[0]) || (k.name=='Erinys' && k2.name=='Fury'))
      f.push(' ')
      f.push(k2.alias_list(bot,event,saliases))
      f.flatten!
    end
  else
    f=k.alias_list(bot,event,saliases)
  end
  return f if dispdata
  if (f.join("\n").length>1900 || f.length>50) && !safe_to_spam?(event)
    event.respond "There are so many aliases that I don't want to spam the server.  Please use the command in PM."
    return nil
  end
  str=f[0]
  for i in 1...f.length
    str=extend_message(str,f[i],event)
  end
  event.respond str
end

def why_elise(event,bot)
  if (!event.message.text.downcase.include?('full') && !event.message.text.downcase.include?('long')) && !safe_to_spam?(event)
    str="When people learn that my main waifu is Sakura, almost invariably, the next question that springs to their mind is: \"If that's the case, then why does your bot take after the **opposite** *Fates* imouto healer?\""
    str="#{str}\n\nThe short answer is: I already had a SakuraBot for another server at the time of writing the bot, and lost a vote that would have made the bot be Priscilla."
    str="#{str}\n\nFor the full story, please use the command `FEH!whyelise full` or use the command in PM."
    create_embed(event,"__A word from my developer__",str,0x008b8b)
  else
    str="When people learn that my main waifu is Sakura, almost invariably, the next question that springs to their mind is: \"If that's the case, then why does your bot take after the **opposite** *Fates* imouto healer?\""
    str="#{str}\n\nThe short answer is: I already had a SakuraBot for another server at the time of writing the bot, and lost a vote that would have made the bot be Priscilla."
    str="#{str}\n\nThe long answer is:"
    str="#{str}\n\nBack when the bot that would become EliseBot was created, she was an entirely different beast.  At the time, all the tier lists were quite horrible - ten times worse than everyone says the DefPloy iteration of the Gamepedia list was.  So one of the servers I was in made their own tier list, and the bot that would become Elise was intended to be a server-specific bot to look up information on their custom tier list."
    str="#{str}\n\nAt this time, the server had a few other bots, and they were all named after *Fire Emblem* characters: Lucina was a mod bot, NinoBot was NinoBot, and Robin(M) was a bot for looking up information in *Awakening* and *Fates*.  In *Heroes* mechanics, that was a red character, a green character, and a blue character.  So the admin of the server suggested that I name the bot after a colorless character so the bots formed a color-balanced team."
    create_embed(event,"__A word from my developer__",str,0x008b8b)
    str="When it got time to actually name the bot, a friend on the server suggested Priscilla, and this idea appealed to me because I had been trying to summon for Priscilla for over three months with no success.  \"If the game isn't gonna give me a Priscilla, I'll just make one.\"  So she was coded with the name PriscillaBot - and in fact, that's still the filename of her source code."
    str="#{str}\n\nThe next day, I wake up to a message from the admin of the server, basically saying \"I like Priscilla as well, but shouldn't we make the bot someone the casual FEH player will recognize?\"  He, knowing my waifuism, suggested Sakura, and I had to turn him down.  So the two of us put the bot's identity up for a vote in the server, and PriscillaBot lost 6-7 in favor of EliseBot."
    str="#{str}\n\nEventually, Gamepedia started seeing things similarly to the server in question, and the server-specific tier list was depricated.  But by this point, I had already started experimenting with what would become her `stats` command, so Elise, rather than dying off, evolved into the community resource that you know her as today."
    create_embed(event,'',str,0xCF4030,"And yes, during the healer gauntlet, her original server was tossing jokes around left and right that it was a battle for the bot's true identity.")
  end
end

def attack_icon(event) # this is used by the attackcolor command to display all info
  str="**1.) The Def/Res icons**"
  str="#{str}\n<:DefenseS:514712247461871616> <:ResistanceS:514712247574986752>"
  str="#{str}\nIf one looks carefully, the icons for Defense and Resistance are the same design, but with different color backgrounds."
  str="#{str}\n\n**2.) The official Attack icon**"
  str="#{str}\n<:StrengthS:514712248372166666> <:DefenseS:514712247461871616>"
  str="#{str}\nLikewise, the Attack and Defense icons have the same color background.  Defense looks slightly redder, but that's because it has a large swatch of yellow inside it whereas Attack has a slightly smaller swatch of blue-white in it."
  str="#{str}\n\n**3.) The original patent for FEH's summoning system**"
  str="#{str}\n<:Orb_Red:455053002256941056> <:Orb_Blue:455053001971859477> <:Orb_Green:455053002311467048> <:Orb_Colorless:455053002152083457>"
  str="#{str}\nIf one looks at the original patent for FEH's summoning system, they learn that at some point during FEH's development, units had the possibility for simultaneously having two weapon types.  The patent specifically says that if the two weapon types (refered to as \"character attributes\") are different, the orb used to hide the character (refered to as \"the mask\") would be a hybrid of the two colors, akin to tye-dye or a Yin-Yang symbol."
  create_embed(event,"__**Why are the Attack stat icons colored weird?**__",str,0xC9304A)
  str="Taking these three facts into consideration, I believe that at some point in development, units were going to have six stats: <:HP_S:514712247503945739>HP, <:StrengthS:514712248372166666>Strength, <:MagicS:514712247289774111>Magic, <:SpeedS:514712247625580555>Speed, <:DefenseS:514712247461871616>Defense, and <:ResistanceS:514712247574986752>Resistance."
  str="#{str}\nThat what we now know as the attack icon would be used for Strength and a similar icon with a blue background would be used for Magic."
  str="#{str}\nThis would mean that when viewing stats, the red swords <:StrengthS:514712248372166666> would attack the enemy's red shield <:DefenseS:514712247461871616>, and the blue swords <:MagicS:514712247289774111> would attack the blue shield <:ResistanceS:514712247574986752>."
  str="#{str}\nThey then ran into issues with a proper control scheme on phones that allowed for this to be easy to understand for newcomers, so they reduced each character to a single weapon, and thus a single attacking stat.  Said stat was then reduced to a single color to prevent it from conflicting with the gradients of the \"dual stat\" icons."
  str="#{str}\n\nAll I am doing is acting on this theory and showing icons for each individual type of attacking stat:"
  str="#{str}\n<:StrengthS:514712248372166666> Sword/Lance/Axe users, Archers, and Thieves have Strength"
  str="#{str}\n<:MagicS:514712247289774111> Mages and Healers have Magic"
  str="#{str}\n<:FreezeS:514712247474585610> And Dragons have a stat that is a hybrid of the two (because it attacks the lower defensive stat in certain conditions)"
  str="#{str}\nCertain commands that deal with multiple units also have this symbol <:GenericAttackS:514712247587569664> for use when the units involved have different attacking stats."
  create_embed(event,'',str,0x3B659F)
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
    create_embed(event,"__**Non-healers**__","",xcolor,"Most non-healer units have at least one Scenario X passive and at least one Scenario Y passive",nil,[["__<:Skill_Weapon:444078171114045450> **Weapons**__","Tier 1 (*Iron, basic magic*) - Default at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*Steel, El- magic, Fire Breath+*) - Available at 2<:Icon_Rarity_2:448266417872044032>, Default at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 (*Silver, super magic*) - Available at 3<:Icon_Rarity_3:448266417934958592> ~~Kana(M) has his unavailable until 4\\*~~, default at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 (*+ weapons other than Fire Breath+, Prf weapons*) - default at 5<:Icon_Rarity_5:448266417553539104>\nRetro-Prfs (*Felicia's Plate*) - Available at 5<:Icon_Rarity_5:448266417553539104>, promotes from nothing",1],["__<:Skill_Assist:444078171025965066> **Assists**__","Tier 1 (*Rallies, Dance/Sing/Play, etc.*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 4<:Icon_Rarity_4:448266418459377684> ~~Sharena has hers default at 2\\*~~\nTier 2 (*Double Rallies, etc.*) - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 3 Assists (*Rally+ skills*) and Prf Assists (*Sacrifice, fairy dance skills, etc.*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Skill_Special:444078170665254929> **Specials**__","Miracle - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 1 (*Daylight, New Moon, etc.*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 4<:Icon_Rarity_4:448266418459377684> ~~Alfonse and Anna have theirs default at 2\\*~~\nTier 2 (*Sol, Luna, etc.*) - Available at 4<:Icon_Rarity_4:448266418459377684> ~~Jaffar and Saber have theirs also default at 5\\*~~\nTier 3 (*Galeforce, Aether, Prf Specials*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1]],2)
    create_embed(event,"__**Healers**__","",0x64757D,"Most healers have a Scenario Y passive",nil,[["__#{"<:Colorless_Staff:443692132323295243>" unless $units.reject{|q| q.weapon_type != 'Healer' || q.weapon_color=='Colorless'}.length>0}#{"<:Gold_Staff:774013610988797953>" if $units.reject{|q| q.weapon_type != 'Healer' || q.weapon_color=='Colorless'}.length>0} **Damaging Staves**__","Tier 1 (*only Assault*) - Available at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*non-plus staves*) - Available at 3<:Icon_Rarity_3:448266417934958592> ~~seasonal healers have theirs default when summoned~~\nTier 3 (*+ staves, Prf weapons*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Assist_Staff:454451496831025162> **Healing Staves**__","Tier 1 (*Heal*) - Default at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*Mend, Reconcile*) - Available at 2<:Icon_Rarity_2:448266417872044032>, default at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 (*all other non-plus staves*) - Available at 4<:Icon_Rarity_4:448266418459377684>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 4 (*+ staves, Prf staves if healers got them*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Special_Healer:454451451805040640> **Healer Specials**__","Miracle - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 1 (*Imbue*) - Available at 2<:Icon_Rarity_2:448266417872044032>, default at 3<:Icon_Rarity_3:448266417934958592>\nTier 2 (*single-stat Balms, Heavenly Light*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 3 (*double-stat Balms*) - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 (*+ Balms*) - Available at 5<:Icon_Rarity_5:448266417553539104>\nPrf Specials (*no examples yet, but they may come*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1]],2)
    create_embed(event,"__**Passives**__","",0x245265,nil,nil,[["__<:Passive_X:444078170900135936> **Scenario X**__","Tier 1 - Available at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 - Available at 2<:Icon_Rarity_2:448266417872044032> or 3<:Icon_Rarity_3:448266417934958592>\nTier 3 - Available at 4<:Icon_Rarity_4:448266418459377684>"],["__<:Passive_Y:444078171113914368> **Scenario Y**__","Tier 1 - Available at 3<:Icon_Rarity_3:448266417934958592>\nTier 2 - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 3 - Available at 5<:Icon_Rarity_5:448266417553539104>"],["__<:Passive_Prf:444078170887553024> **Prf Passives**__","Available at 5<:Icon_Rarity_5:448266417553539104>"],["__<:Passive_Z:481922026903437312> **Scenario Z**__","Tier 1 - Available at 2<:Icon_Rarity_2:448266417872044032>\nTier 2 - Available at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 - Available at 5<:Icon_Rarity_5:448266417553539104>"]],2)
  else
    str="By observing the skill lists of the Daily Hero Battle units - the only units we have available at 1\\* - I have learned that there is a set progression for which characters learn skills.  Only five units directly contradict this observation - and three of those units are the Askrians, who were likely given their Assists and Tier 1 Specials (depending on the character) at 2\\* in order to make them useable in the early story maps when the player has limited orbs and therefore limited unit choices.  The other two are Jaffar and Saber, who - for unknown reasons - have their respective Tier 2 Specials available right out of the box as 5\\*s."
    str="#{str}\n\nThe information as it is is not useless.  In fact, as seen quite recently as of the time of this writing, IntSys is willing to demote some units out of the 4-5\\* pool into the 3-4\\* one. This information allows us to predict which skills the new 3\\* versions of these characters will have."
    str="#{str}\n\nAs for units unlikely to demote, Paralogue maps will have lower-rarity versions of units with their base kits.  Training Tower and Tempest Trials attempt to build units according to recorded trends in Arena, but will use default base kits at lower difficulties.  Obviously you can't fodder a 4* Siegbert for Death Blow 3, but you can still encounter him in Tempest."
    create_embed(event,"**Supposed Bug: X character, despite not being available at #{r}, has skills listed for #{r.gsub('Y','that')} in the `skill` command.**\n\nA word from my developer",str,xcolor)
    event.respond "To see the progression I have discovered, please use the command `FEH!skillrarity progression`."
  end
end

def growth_explain(event,bot)
  disp="1.) Look for your unit's rarity in the top row."
  disp="#{disp}\n\n2.) Look for the value of your unit's GR in the leftmost column."
  disp="#{disp}\n- If you don't know the growth rates, you can find them on the wiki or by including the word `growths` in your message when using the `FEH!stats` command."
  disp="#{disp}\n\n3.) Where the two intersect is the character's actual growth value."
  disp="#{disp}\n- This is how many stat points the unit's stat increases by when they go from Level 1 to Level 40."
  disp="#{disp}\n\n4.) In addition to the level 1 stats, a unit's nature affects their GRs."
  disp="#{disp}\n- A boon in a stat increases that stat's GR by 5% compared to a neutral version of the unit."
  disp="#{disp}\n- Likewise, a bane in a stat decreases the stat's GR by 5% compared to neutral."
  disp="#{disp}\n\n5.) \"Superboons\" and \"Superbanes\" are marked by the thick blue and red arrows, respectively."
  disp="#{disp}\n- A superboon is when a stat increases by 4 instead of the usual 3."
  disp="#{disp}\n- Likewise, a superbane is when a stat decreases by 4 instead of the usual 3."
  disp="#{disp}\n- (This chart shows supernatures as increasing/decreasing by 3 instead of 2, but this does not account for the +1/-1 on the level 1 stats.)"
  disp="#{disp}\n\n6.) Thanks to Trait Fruit, 1<:Icon_Rarity_1:448266417481973781>-2<:Icon_Rarity_2:448266417872044032> units have access to \"microboons\" and \"microbanes\", where a stat increases or decreases by 2 instead of the usual 3."
  disp="#{disp}\n- These are marked by the thin blue and red arrows."
  if !safe_to_spam?(event)
    event.respond 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Growths.png'
  elsif $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event << disp
    event << ''
    event << 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Growths.png'
  else
    event.channel.send_embed("How do Growths work?") do |embed|
      embed.description=disp
      embed.color=0x008b8b
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Growths.png')
    end
  end
end

def merge_explain(event,bot)
  disp="1.) Look at the original unit's level 1 stats at 5<:Icon_Rarity_5:448266417553539104>."
  disp="#{disp}\n- The stats must be at 5<:Icon_Rarity_5:448266417553539104> regardless of the rarity of the unit being merged."
  disp="#{disp}\n\n2.) Sort them by value, highest first and lowest last."
  disp="#{disp}\n- in the case of two stats being equal, the stat listed higher in game goes first"
  disp="#{disp}\n- thus, if all five stats were equal, the order would be HP, Attack, Speed, Defense, Resistance...exactly as displayed in game."
  disp="#{disp}\n\n3.) The resulting list is the order in which stats increase, and each merge increases the next two stats on the list, which loops."
  disp="#{disp}\n\n4.) This does mean that the base unit's nature can affect the order in which stats increase."
  disp="#{disp}\n- For example, Sakura(Halloween)'s level 1 neutral stats are 16/8/8/4/8.  This means under normal circumstances, her stats increase in the following order: HP->Atk->Spd->Res->Def."
  disp="#{disp}\n- However, consider a +Res -Spd Sakura(Halloween); her level 1 stats are 16/8/7/4/9.  This changes the order stats increase to HP->Res->Atk->Spd->Def."
  disp="#{disp}\n\n5.) In addition, units with at least one merge get an additional boost to their stats."
  disp="#{disp}\n- Units with non-neutral natures get their bane completely removed."
  disp="#{disp}\n- Units with neutral natures get an additional point each to the first three stats in the list created in step 2."
  disp="#{disp}\n- These changes do affect the BST portion of the arena score calculation, even though it uses unmerged stats."
  create_embed(event,"__**How to predict what stats will increase by a merge**__",disp,0x008b8b)
end

def score_explain(event,bot)
  disp="**`5`<:Icon_Rarity_5:448266417553539104>`+0 level 40 BST` / 5, rounded down to the nearest full number**"
  disp="#{disp}\nEven if the unit is not 5\\* or level 40, or already merged, it is their 5\\*+0 level 40 BST without skills that determines their BST bin."
  disp="#{disp}\nDespite using unmerged stats for BST, the unit's bane is ignored if the unit is merged.  Neutral-natured merged units get +3 to their standard BST before the division by 5."
  disp="#{disp}\nIf the unit is 5\\* level 40 and has a level 3 Duel skill, the lowest this number can be is 34."
  disp="#{disp}\n\n**`Rarity` \* 5**"
  disp="#{disp}\nMost users will be using a team of full 5\*s, so this will usually be 25."
  disp="#{disp}\n\n**`Merge count` \* 2**"
  disp="#{disp}\nAt +10, this is 20."
  disp="#{disp}\n\n**`Level` \* 2.25**"
  disp="#{disp}\nAt level 40, this is always 90."
  disp="#{disp}\n\n**`Total SP cost of equipped skills` / 100, rounded down to the nearest full number.**"
  disp="#{disp}\n\n**`number of legendaries giving their blessing to unit` \* 4**"
  disp="#{disp}\nIf your unit is Water-blessed and on a team alongside three Fjorms, this is 12 during Water season and 0 during other seasons."
  disp="#{disp}\nFor Legendary Heroes, this is always 0."
  create_embed(event,"__**How to calculate a unit score**__",disp,0x008b8b)
  if safe_to_spam?(event)
    disp="**The average of the units' individual scores**"
    disp="#{disp}\nUnder most cases, this is the sum divided by 4."
    disp="#{disp}\n\n**Difficulty modification**"
    disp="#{disp}\nAssuming Advanced difficulty, this is 155."
    disp="#{disp}\n\n**`number of units on team` \* 7**"
    disp="#{disp}\nWith a full team, this is always 28."
    disp="#{disp}\n\n\n**With a bonus unit, multiply the total of everything above by 2.**"
    disp="#{disp}\nWithout a bonus unit, just use the total above."
    disp="#{disp}\n**Round the result to the nearest whole number, than decrease to the nearest even number.**"
    create_embed(event,"__**How to calculate a team score**__",disp,0x008b8b)
  end
end

def show_tools(event,bot)
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?('mobile') || event.message.text.downcase.include?('phone')
    event << '**Useful tools for players of** ***Fire Emblem Heroes***'
    event << '__Download the game__'
    event << 'Google Play: <https://play.google.com/store/apps/details?id=com.nintendo.zaba&hl=en>'
    event << 'Apple App Store: <https://itunes.apple.com/app/id1181774280>'
    event << ''
    event << '__News__'
    event << 'In-game news: <https://fire-emblem-heroes.com/en/topics/>'
    event << 'Twitter: <https://twitter.com/FE_Heroes_EN>'
    event << '*The Everyday Life of Heroes* manga: <https://fireemblem.gamepress.gg/feh-manga>'
    event << ''
    event << '__Wikis and Databases__'
    event << 'Gamepedia FEH wiki: <https://feheroes.gamepedia.com/>'
    event << 'Gamepress FEH database: <https://fireemblem.gamepress.gg/>'
    event << ''
    event << '__Simulators__'
    event << 'Summon Simulator: <https://fehstuff.com/summon-simulator/>'
    event << 'Inheritance tracker: <https://arghblargh.github.io/feh-inheritance-tool/>'
    event << 'Visual unit builder: <https://fehstuff.com/unit-builder/>'
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
    str="__Download the game__"
    str="#{str}\n[Google Play](https://play.google.com/store/apps/details?id=com.nintendo.zaba&hl=en)"
    str="#{str}\n[Apple App Store](https://itunes.apple.com/app/id1181774280)"
    str="#{str}\n\n__News__"
    str="#{str}\n[In-game news](https://fire-emblem-heroes.com/en/topics/)"
    str="#{str}\n[Twitter](https://twitter.com/FE_Heroes_EN)"
    str="#{str}\n[*The Everyday Life of Heroes* manga](https://fireemblem.gamepress.gg/feh-manga)"
    str="#{str}\n\n__Wikis and Databases__"
    str="#{str}\n[Gamepedia FEH wiki](https://feheroes.gamepedia.com/)"
    str="#{str}\n[Gamepress FEH database](https://fireemblem.gamepress.gg/)"
    str="#{str}\n\n__Simulators__"
    str="#{str}\n[Summon Simulator](https://fehstuff.com/summon-simulator/)"
    str="#{str}\n[Inheritance tracker](https://arghblargh.github.io/feh-inheritance-tool/)"
    str="#{str}\n[Visual unit builder](https://fehstuff.com/unit-builder)"
    str="#{str}\n\n__Damage Calculators__"
    str="#{str}\n[ASFox's mass duel simulator](http://arcticsilverfox.com/feh_sim/)"
    str="#{str}\n[Andu2's mass duel simulator fork](https://andu2.github.io/FEH-Mass-Simulator/)"
    str="#{str}\n\n[FEHKeeper](https://www.fehkeeper.com/)"
    str="#{str}\n\n[Arena Score Calculator](http://www.arcticsilverfox.com/score_calc/)"
    str="#{str}\n\n[Glimmer vs. Moonbow](https://i.imgur.com/kDKPMp7.png)"
    create_embed(event,'**Useful tools for players of** ***Fire Emblem Heroes***',str,0xD49F61,nil,'https://lh3.googleusercontent.com/r-Am90wLyxj1kOGkAfn3WzVP3GosLbcnyGp_CRof6o3VtFW-Pe7TR1tTJrxAXrqLat4=s180-rw')
    event.respond 'If you are on a mobile device and cannot click the links in the embed above, type `FEH!tools mobile` to receive this message as plaintext.'
  end
end

def oregano_explain(event,bot)
  if safe_to_spam?(event)
    str="**Q1.) Who is Oregano?**"
    str="#{str}\nA.) The first Discord server I ever joined was for a group of friends who were planning a *Fates* AU RP in a world where Corrin decided to leave the world entirely - yes, to join Smash.  This RP never happened (our Dungeon Master had real-life issues to take care of and the project died in his absence), but the group of friends remains together."
    str="#{str}\nOregano happens to be the in-universe daughter for one of the members of this group."
    str="#{str}\n\n**Q2.) What is she doing in Elise's data?**"
    str="#{str}\nA.) When I was learning how stats were calculated in FEH - growth points, BST and GPT limits based on class, etc. - the members of this server took the opportunity to translate their units to FEH mechanics.  In order to help them visualize how their units actually were, I made entries for them in Elise's data."
    str="#{str}\n~~I, for example, am an Infantry Sword user with 45/29/24/25/39 as my stats, with a superbane in Atk and superboons in both defenses.  My biggest uses are for my prf assist skill - which is effectively Rally Special Cooldown - and the fact that I would give Wrath as a 4<:Icon_Rarity_4:448266418459377684> inheritable skill...yes, I am skill fodder.~~"
    str="#{str}\nThe above was true at the initial writing of this explanation, but has since changed due to the introduction of Duo Heroes, which fit my unit's lore far better than any mechanic I could've imagined when FEH first released."
    str="#{str}\n\n**Q3.) Doesn't having fake units in the data alter the results for commands like `sort` and `bestamong`/`worstamong`/`average`?**"
    str="#{str}\nA.) Fake units, and the skills they can learn but no one else can, are exclusive to the server in which they were created, and even in that server, the commands mentioned above will only include the fake units if you type the word \"all\" in your message.  Except `sort`, in which those units will appear but be crossed out."
    create_embed(event,'A word from my developer',str,0x759371,nil,'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/Oregano/Face_FC.png')
    str="**Q4.) Wait...\"exclusive to the server in which they were created\"?  Then how did I see Oregano in the first place?**"
    str="#{str}\nA.) This answer gets a little technical."
    str="#{str}\nFirst off, Oregano is at the bottom of Elise's unit list.  She is, of Penumbra's second generation - or more specifically, those that had FEH units made - the alphabetically last character."
    str="#{str}\nWhen looking for an entry number within a list, I originally wrote code so that the function returns `-1` if no matching entries were found, and use `>=0` to make sure that I am looking at an entry."
    str="#{str}\n__However__, sometimes, interference of some kind causes either the `-1` to pass the check, or for a number that legitimately passed the check to __become__ -1 after the check.  I generally refer to this as a \"typewriter jam\" error, and it doesn't always become -1 - sometimes it will become the number for another entry, which is how you can look up Anna and get her stats but Abel's picture displays, for example."
    str="#{str}\nWhen the typewriter jam results in a legitimized -1, Ruby - the programming language Elise is written in - interprets that as \"read the last entry in the list\", which for the unit list is Oregano."
    str="#{str}\n\nThe code has since been changed in such a way that typewriter jams are less likely (if not outright impossible, though I want to avoid claiming such since code sometimes likes to do things that you don't tell it to do).  This means Oregano is less likely to appear outside the server she is supposed to appear in."
    str="#{str}\n\n**Q5.) What does her real-world father think of this?**"
    str="#{str}\nA.) IRL, Draco is a memelord, and he loves the fact that his daughter - who he designed to be a glass cannon to the utmost extreme - is legitimately \"breaking everything\" to the point that she is breaking my code and appearing places she shouldn't be."
    str="#{str}\n\n**Q6.) That thumbnail, who I presume is Oregano, is adorable.  Where do I find it?**\nMy friend BluechanXD, from the same server, made it based on Draco's description.  [Here's a link](https://www.deviantart.com/bluechanxd/art/FE-OC-Oregano-V2-765406579)." unless $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    create_embed(event,'',str,0x759371)
  else
    str="**Q1.) Who is Oregano?**"
    str="#{str}\nA.) A friend's fictitious daughter from a *Fates* AU RP."
    str="#{str}\n\n**Q2.) What is she doing in Elise's data?**"
    str="#{str}\nA.) The server that was going to do this RP translated their units into FEH mechanics, and I made them server-specific units to help visualize how the stats they chose actually worked in-game."
    str="#{str}\n\n**Q3.) \"Server-specific\", eh?  Then how did I see her?**"
    str="#{str}\nA.) Non-technical answer: a weird quirk of the programming language I coded Elise in, combined with how I store the unit data, sometimes means that the last listed unit in Elise's unit list is shown in other servers."
    str="#{str}\nIt is related to the same bug that causes, when you look up one unit, the unit color or profile image to be a different character."
    str="#{str}\nAs of the time of writing, changes to the code have been made to make this bug less likely, if not outright impossible, based on tricks I learned since the original coding of Elise."
    create_embed(event,'A word from my developer',str,0x759371,'For more detailed answers, use this command in PM.','https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/Oregano/Face_FC.png')
  end
end

def update_howto(event,bot)
  if ![368976843883151362,167657750971547648].include?(event.user.id)
    t=Time.now
    if t.month==10 && t.year==2019 && t.day>23 && t.day<30
      event.respond "Please note that my developer is away for the weekend, and cannot do updates.  I have code that allows my data collector to update me remotely, but that may take longer than usual."
    else
      event.respond "This command is unavailable to you."
    end
    return nil
  end
  str="1.) Edit [the sheet](https://docs.google.com/spreadsheets/d/15eDswPz7xK6w3c5R9-iUq8pt22KMMby71hsDuH6HlBA/edit#gid=2081531433)."
  str="#{str}\n- Any column whose header is a shade of grey, is formulaically calculated and thus you don't need to edit it.  Merely copy the formula from the cell above."
  str="#{str}\n- In *Units*'s \"Rarities\" column:\n> `5p` is for normal summonable units (\"pool\")\n> `5s` is used for seasonals and legendaries\n> `3g4g4g` is used for GHBs\n> `4t5t` is used for TT units\n> There are all-caps two-character markers, but they're used to mark Launch units + Book I 5\* units and are thus not relevant in Book IV."
  str="#{str}\n- In *Units*'s \"Game\" column, the game that FEH credits the unit with is listed first, but the remaining games are listed in chronological order."
  str="#{str}\n- In *Skills*'s sheet, add new skills above the fake skills in the same group.  Fake skills are marked by having the font significantly smaller."
  str="#{str}\n- Please note that when a skill that is obviously part of a stat-based family gets added, I add all stat variations immediately.  Thus, if a new skill in an existing family gets added, check to see if an entry for it already exists first."
  create_embed(event,"**How to update Elise's data while Mathoo is unavailable.**",str,0xD49F61)
  str="2.) Wait for the formulae to finish loading, then grab the EliseBot data column of the sheet you edited.  I generally highlight the lowest entry and CTRL+SHIFT+(up)."
  str="#{str}\n\n3.) Copy the selection from step 2 to a text file, with the following names based on sheet:"
  str="#{str}\n- *Units* should be copied to **FEHUnits.txt**"
  str="#{str}\n- *Skills* should be copied to **FEHSkills.txt**"
  str="#{str}\n- *Structures* should be copied to **FEHStructures.txt**"
  str="#{str}\n- *Accessories* should be copied to **FEHAccessories.txt**"
  str="#{str}\n- *Items* should be copied to **FEHItems.txt**"
  str="#{str}\n\n4.) Upload the text file to [the GitHub page here](https://github.com/Rot8erConeX/EliseBot/tree/master/EliseBot).  You might need to make a GitHub account to do so."
  str="#{str}\n\n5.) Wait probably five minutes for the file to settle on GitHub's servers, then use the command `FEH!reload` in my debug server."
  str="#{str}\n\n6.) Type the number 3 to select reloading data based on GitHub files."
  str="#{str}\n\n7.) Double-check that the edited data works.  It is important to remember that I will not be there to guide you to wherever any problems might be based on error codes."
  str="#{str}\n\n8.) Add any relevant aliases to the new data."
  create_embed(event,'',str,0xD49F61)
  return nil
end

def hybrid_range(x,y)
  # turning each string into an array, splitting by the fake newline character
  x=x.split("\n") if x.is_a?(String)
  y=y.split("\n") if y.is_a?(String)
  # making sure all the substrings in each array are the same length as each other, padding shorter strings to the left
  for i in 0...x.length
    x[i]=x[i].gsub(' ',"\u00A0")
    x[i]="#{x[i]}#{"\u00A0"*(x.map{|q| q.length}.max-x[i].length)}" if x[i].length<x.map{|q| q.length}.max
  end
  for i in 0...y.length
    y[i]=y[i].gsub(' ',"\u00A0")
    y[i]="#{y[i]}#{"\u00A0"*(y.map{|q| q.length}.max-y[i].length)}" if y[i].length<y.map{|q| q.length}.max
  end
  # making sure the two arrays are equal length to each other, padding the smaller one towards the center
  if x.length>y.length
    y.push("\u00A0"*y.map{|q| q.length}.max) if (x.length-y.length)%2==1
    for i in 0...(x.length-y.length)/2
      y.push("\u00A0"*y.map{|q| q.length}.max)
      y.unshift("\u00A0"*y.map{|q| q.length}.max)
    end
  elsif x.length<y.length
    x.push("\u00A0"*x.map{|q| q.length}.max) if (y.length-x.length)%2==1
    for i in 0...(y.length-x.length)/2
      x.push("\u00A0"*x.map{|q| q.length}.max)
      x.unshift("\u00A0"*x.map{|q| q.length}.max)
    end
  end
  # putting each line beside the corresponding line in the other array
  z=[]
  for i in 0...x.length
    z.push("#{x[i]}  \u200B  #{y[i]}")
  end
  return "```#{z.join("\n")}```"
end

def aoe(event,bot,args=nil)
  args=event.message.downcase.split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  args=args.map{|q| q.downcase}
  data_load(['skill'])
  sklz=$skills.map{|q| q}
  mode=0
  for i in 0...args.length
    mode=1 if mode==0 && ['flame','fire','flames','fires'].include?(args[i])
    mode=2 if mode==0 && ['wind','winds'].include?(args[i])
    mode=3 if mode==0 && ['thunder','thunders'].include?(args[i])
    mode=4 if mode==0 && ['light','lights','lightness'].include?(args[i])
  end
  if mode==0 && !safe_to_spam?(event)
    event.respond "This command, unless given inputs, takes a lot of screen space due to dealing with vertical attack ranges.\nPlease try again, either in PM or with one of the following words:\n- Flame\n- Wind\n- Thunder\n- Light"
    return nil
  end
  str2=''
  for i in 1...5
    type=['specials','Flame','Wind','Thunder','Light'][i]
    if [i,0].include?(mode)
      m=sklz[sklz.find_index{|q| q.name=="Blazing #{type}"}]
      m2=sklz[sklz.find_index{|q| q.name=="Growing #{type}"}]
      str="__**Blazing #{type}** vs. **Growing #{type}**__\n#{hybrid_range(m.range,m2.range)}"
      str2=extend_message(str2,str,event)
    end
  end
  type=['specials','Flame','Wind','Thunder','Light'][mode]
  str2=extend_message(str2,"Base damage is `Atk - eDR`, where eDR is the enemy's Def or Res, based on the type of weapon being used.\nBlazing #{type} do#{'es' if mode>0} 1.5x as much damage as Growing #{type}.\nRising #{type} ha#{'ve' if mode==0}#{'s' if mode>0} the range of Blazing but deal#{'s' if mode>0} as much damage as Growing.",event)
  event.respond str2
end

def show_bonus_smol(event,args=[],bot=nil,mode=0)
  data_load(['unit','bonus'])
  b=$bonus_units.reject{|q| !q.isCurrent?(false) || (args.length>0 && !args.include?(q.type))}
  b=$bonus_units.reject{|q| !q.isNext?(false,true) || (args.length>0 && !args.include?(q.type))} if mode==1
  b=$bonus_units.reject{|q| !q.isFuture? || q.isNext?(false) || (args.length>0 && !args.include?(q.type))} if mode==2
  return nil if b.length<=0
  f=[]
  season=0
  x=b.reject{|q| q.type != 'Arena'}
  unless x.length<=0
    season=x[0].colosseum_season unless x[0].colosseum_season<0
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{x[0].elements[0]}"}
    moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{x[0].elements[1]}"}
    f.push(["#{moji[0].mention unless moji.length<=0}#{moji2[0].mention unless moji2.length<=0}**Arena**",x[0].unit_list.map{|q| "#{q.name}"}.join("\n")])
  end
  x=b.reject{|q| q.type != 'Aether'}
  unless x.length<=0
    season=x[0].colosseum_season unless x[0].colosseum_season<0 || season>0
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{x[0].elements[0]}"}
    moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{x[0].elements[1]}"}
    str=x[0].unit_list.map{|q| "#{q.name}"}.join("\n")
    if x[0].offense_structure==x[0].defense_structure
      str="#{str}\n\n#{x[0].offense_structure} (O/D)"
    else
      str="#{str}\n\n#{x[0].offense_structure} (O)\n#{x[0].defense_structure} (D)"
    end
    f.push(["#{moji[0].mention unless moji.length<=0}#{moji2[0].mention unless moji2.length<=0}**Aether Raids**",str])
  end
  x=b.reject{|q| q.type != 'Tempest'}
  unless x.length<=0
    str=x[0].unit_list.map{|q| "#{q.name}"}.join("\n")
    str="#{str}\n\n#{x[0].seals.uniq.map{|q| "#{q.fullName('')}#{q.emotes(bot,true)}"}.join("\n")}"
    f.push(['<:Current_Tempest_Bonus:498797966740422656>**Tempest Trials**',str])
  end
  x=b.reject{|q| q.type != 'Resonant'}
  f.push(['<:Special_Blade:800880639540068353>Resonant Blades',get_games_list(x[0].bonuses,false).join("\n")]) unless x.length<=0
  str="__**Colosseum Season #{season}**__"
  str="__*Colosseum Season #{season}* - **Current week**__" if mode==0
  str="__*Colosseum Season #{season}* - **Next week**__" if mode==1
  create_embed(event,str,'',0xD49F61,nil,nil,f)
end

def show_bonus_units(event,args=[],bot=nil,mode=0)
  data_load(['unit','bonus'])
  b=$bonus_units.reject{|q| q.isPast?(false) || (args.length>0 && !args.include?(q.type))}
  b=b.reject{|q| !q.isCurrent?(false)} if mode==2
  b=b.reject{|q| !q.isNext?(false)} if mode==3
  b=b.sort{|a,c| a.typeAsNumber<=>c.typeAsNumber}
  if args.length<=0
    x=[]
    x.push('Arena') if b.reject{|q| q.type != 'Arena'}.length<=0
    x.push('Tempest Trials') if b.reject{|q| q.type != 'Tempest'}.length<=0
    x.push('Aether Raids') if b.reject{|q| q.type != 'Aether'}.length<=0
    x.push('Resonant Battles') if b.reject{|q| q.type != 'Resonant'}.length<=0
    return ["There are no known quantities about #{list_lift(x,'or')}"] if x.length>0 && mode>0
    event.respond "There are no known quantities about #{list_lift(x,'or')}" if x.length>0
  elsif b.length<=0 && mode>0
    x=[]
    x.push('Arena') if args.include?('Arena')
    x.push('Tempest Trials') if args.include?('Tempest')
    x.push('Aether Raids') if args.include?('Aether')
    x.push('Resonant Battles') if args.include?('Resonant')
    return ["There are no known quantities about #{list_lift(x,'or')}"]
  end
  if mode>0
    b2=b.map{|q| q.unit_list}.uniq
    for i in 0...b2.length
      b3=b.reject{|q| q.unit_list != b2[i]}
      str="__**#{b3[0].type} Season #{i+1}**__"
      str="__**Current #{b3[0].type} Season**__" if b3[0].isCurrent?(false)
      str="__**Next #{b3[0].type} Season**__" if b3[0].isNext?(false) || (i>0 && b2[i-1].include?('__**Current'))
      str=str.gsub('Season','Trials') if b3[0].type=='Tempest'
      str="#{str}\n*Bonus Units:* #{b3[0].unit_list.map{|q| q.name}.join(', ')}"
      for i2 in 0...b3.length
        str2="*Week #{i2+1}*"
        str2="*Current week*" if b3[i2].isCurrent?(false)
        str2="*Next week*" if b3[i2].isNext?(false)
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{b3[i2].elements[0]}"}
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{b3[i2].elements[1]}"}
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{b3[i2].elements[1]}"} if b3[i2].type=='Arena'
        str2="#{str2} #{moji[0].mention unless moji.length<=0}#{b3[i2].elements[0]}/#{moji2[0].mention unless moji2.length<=0}#{b3[i2].elements[1]}"
        if b3[i2].type=='Aether'
          if b3[i2].offense_structure==b3[i2].defense_structure
            str2="#{str2} - #{b3[i2].offense_structure} (O/D)"
          else
            str2="#{str2} - #{b3[i2].offense_structure} (O), #{b3[i2].defense_structure} (D)"
          end
        elsif b3[i2].type=='Tempest'
          str2="*Seals:* #{b3[i2].seals.uniq.map{|q| "#{q.fullName('')}#{q.emotes(bot,true)}"}.join(', ')}"
        end
        str="#{str}\n#{str2}" unless b3[i2].type=='Resonant'
      end
      b2[i]=str
    end
    return b2
  end
  x=b.map{|q| [q.type,q.unit_list,q.bonuses]}.uniq
  y=''
  for i in 0...x.length
    if x[i][0]=='Resonant'
      m=get_games_list(x[i][2],false).join("\n")
    else
      m=x[i][1].map{|q| "#{q.name}#{q.emotes(bot,false) unless !safe_to_spam?(event)}"}.join("\n")
    end
    xcolor=0xD49F61
    xcolor=0x002837 if x[i][0]=='Arena'
    xcolor=0x5ED0CF if x[i][0]=='Tempest'
    xcolor=0x54C571 if x[i][0]=='Aether'
    xcolor=0xC0EEB6 if x[i][0]=='Resonant'
    hdr="__**#{x[i][0]} Bonus Units**__"
    hdr="__**Tempest Trials Bonus Units**__" if x[i][0]=='Tempest'
    hdr="__**Aether Raids Bonus Units**__" if x[i][0]=='Aether'
    hdr="__**Resonant Battles Bonus Games**__" if x[i][0]=='Resonant'
    xf=b.reject{|q| q.type != x[i][0] || q.unit_list != x[i][1]}
    xf=b.reject{|q| q.type != x[i][0] || q.bonuses != x[i][2]} if x[i][0]=='Resonant'
    yy=10
    for i2 in 0...xf.length
      xx=[]
      xx.push("Colosseum #{xf[i2].colosseum_season}")
      if xf[i2].isCurrent?(false)
        xx[-1]="#{xx[-1]} - **Current week**"
      elsif xf[i2].isNext?(false)
        xx[-1]="#{xx[-1]} - *Next week*"
      else
        xx[-1]="*#{xx[-1]}*"
      end
      if ['Resonant'].include?(x[i][0])
        m="#{xx.join("\n")}\n#{m}"
      elsif ['Arena','Aether'].include?(x[i][0])
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{xf[i2].elements[0]}"}
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{xf[i2].elements[1]}"}
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{xf[i2].elements[1]}"} if x[i][0]=='Arena'
        xx.push("#{moji[0].mention unless moji.length<=0}#{xf[i2].elements[0]}, #{moji2[0].mention unless moji2.length<=0}#{xf[i2].elements[1]}")
        if x[i][0]=='Aether'
          if xf[i2].offense_structure==xf[i2].defense_structure
            xx.push("#{xf[i2].offense_structure} (O/D)")
          else
            xx.push("#{xf[i2].offense_structure} (O), #{xf[i2].defense_structure} (D)")
          end
        end
        m="#{m}\n#{"\n" unless xx.length<=1 && yy<=1 && i2>0}#{xx.join("\n")}"
        yy=xx.length
      elsif x[i][0]=='Tempest'
        m="#{m}\n\n__*Seals*__\n#{xf[i2].seals.uniq.map{|q| "#{q.fullName('')}#{q.emotes(bot,true)}"}.join("\n")}"
      end
    end
    hdr='' if y==hdr
    y=hdr if hdr.length>0
    create_embed(event,hdr,m,xcolor) unless !safe_to_spam?(event) && hdr.length<=0
  end
  return nil
end

def get_bond_name(event)
  if File.exist?("#{$location}devkit/FEHBondNames.txt")
    b=[]
    File.open("#{$location}devkit/FEHBondNames.txt").each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  return b.sample
end

def make_random_unit(event,args,bot)
  colors=[]
  weapons=[]
  movement=[]
  clazzez=[]
  color_weapons=[]
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  args=args.map{|q| q.downcase}
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
    weapons.push('Healer') unless has_any?(['dancer','singer','bard'],event.message.text.downcase.split(' '))
  end
  for i in 0...colors.length
    for j in 0...weapons.length
      if colors[i]=='Colorless'
        color_weapons.push([colors[i],weapons[j]]) unless (weapons[j]=='Blade' && $units.reject{|q| q.weapon_type != 'Blade' || q.weapon_color != 'Colorless'}.length<=0)
      elsif weapons[j]=='Healer' && $units.reject{|q| q.weapon_type != 'Healer' || q.weapon_color=='Colorless'}.length<=0
      else
        color_weapons.push([colors[i],weapons[j]])
      end
    end
  end
  if color_weapons.length<=0
    color_weapons=[['Red','Blade'],  ['Red','Tome'],      ['Red','Breath'],      ['Red','Bow'],      ['Red','Dagger'],      ['Red','Beast'],
                   ['Blue','Blade'], ['Blue','Tome'],     ['Blue','Breath'],     ['Blue','Bow'],     ['Blue','Dagger'],     ['Blue','Beast'],
                   ['Green','Blade'],['Green','Tome'],    ['Green','Breath'],    ['Green','Bow'],    ['Green','Dagger'],    ['Green','Beast'],
                                     ['Colorless','Tome'],['Colorless','Breath'],['Colorless','Bow'],['Colorless','Dagger'],['Colorless','Beast']]
    color_weapons.push(['Colorless', 'Blade']) if $units.reject{|q| q.weapon[0,2]!=['Colorless','Blade']}.length>0
    unless event.message.text.downcase.split(' ').include?('singer') || event.message.text.downcase.split(' ').include?('dancer')
      if $units.reject{|q| q.weapon_type != 'Healer' || q.weapon_color=='Colorless'}.length>0
        color_weapons.push(['Red', 'Healer'])
        color_weapons.push(['Blue', 'Healer'])
        color_weapons.push(['Green', 'Healer'])
      end
      color_weapons.push(['Colorless', 'Healer'])
    end
    color_weapons=color_weapons.reject{|q| !colors.include?(q[0])} unless colors.length<=0
    color_weapons=color_weapons.reject{|q| !weapons.include?(q[1])} unless weapons.length<=0
  end
  color_weapons.uniq!
  clazz=color_weapons.sample
  movement=['Infantry','Flier','Cavalry','Armor'] if movement.length<=0
  movement.uniq!
  mov=movement.sample
  l1_total=47
  gp_total=31
  if ['Tome','Bow','Dagger','Healer'].include?(clazz[1])
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
  elsif event.message.text.downcase.split(' ').include?('bard')
    clazz2.push('Bard')
    l1_total-=8
  elsif event.message.text.downcase.split(' ').include?('music') || event.message.text.downcase.split(' ').include?('musical')
    clazz2.push(['Dancer','Singer','Bard'].sample)
    l1_total-=8
  elsif event.message.text.downcase.split(' ').include?('nonmusical')
  elsif event.message.text.downcase.split(' ').include?('non-musical')
  elsif clazz[1]!='Healer' && rand(10).zero?
    clazz2.push(['Dancer','Singer','Bard'].sample)
    l1_total-=8
  end
  zzz=rand(100)
  zzz=rand(1000) if clazz2.include?('Trainee') || clazz2.include?('Veteran')
  if ['Dancer','Singer'].include?(clazz2)
  elsif args.include?('gen3')
    clazz2.push('Gen 3')
    if ['Tome', 'Healer'].include?(clazz[1]) # magical ranged
      l1_total+=2
      l1_total-=1 if ['Cavalry'].include?(mov)
      l1_total-=2 if ['Flier'].include?(mov)
      gp_total+=3
      gp_total-=4 if ['Cavalry'].include?(mov)
      gp_total-=2 if ['Flier'].include?(mov)
    elsif ['Bow', 'Dagger'].include?(clazz[1]) # physical ranged
      l1_total+=2
      l1_total-=1 if ['Cavalry'].include?(mov)
      gp_total+=3
      gp_total-=1 if ['Cavalry'].include?(mov)
    else # melee
      l1_total+=2
      l1_total-=1 if ['Cavalry','Flier'].include?(mov)
      l1_total-=1 if 'Flier'!=mov
      gp_total+=2
      gp_total+=2 if ['Infantry'].include?(mov)
      gp_total-=1 if ['Cavalry'].include?(mov)
    end
  elsif args.include?('gen2')
    clazz2.push('Gen 2')
    l1_total+=1
    l1_total-=1 if ['Cavalry','Flier'].include?(mov)
    l1_total-=1 if 'Flier'!=mov
    gp_total+=2
    gp_total-=1 if ['Cavalry'].include?(mov)
    gp_total-=1 if ['Tome', 'Bow', 'Dagger', 'Healer'].include?(clazz[1]) && 'Armor'!=mov
  elsif args.include?('gen1')
  elsif zzz<67
    clazz2.push('Gen 3')
    if ['Tome', 'Healer'].include?(clazz[1]) # magical ranged
      l1_total+=2
      l1_total-=1 if ['Cavalry'].include?(mov)
      l1_total-=2 if ['Flier'].include?(mov)
      gp_total+=3
      gp_total-=4 if ['Cavalry'].include?(mov)
      gp_total-=2 if ['Flier'].include?(mov)
    elsif ['Bow', 'Dagger'].include?(clazz[1]) # physical ranged
      l1_total+=2
      l1_total-=1 if ['Cavalry'].include?(mov)
      gp_total+=3
      gp_total-=1 if ['Cavalry'].include?(mov)
    else # melee
      l1_total+=2
      l1_total-=1 if ['Cavalry','Flier'].include?(mov)
      l1_total-=1 if 'Flier'!=mov
      gp_total+=2
      gp_total+=2 if ['Infantry'].include?(mov)
      gp_total-=1 if ['Cavalry'].include?(mov)
    end
  elsif zzz<33
    clazz2.push('Gen 2')
    l1_total+=1
    l1_total-=1 if ['Cavalry','Flier'].include?(mov)
    l1_total-=1 if 'Flier'!=mov
    gp_total+=2
    gp_total-=1 if ['Cavalry'].include?(mov)
    gp_total-=1 if ['Tome','Bow','Dagger','Healer'].include?(clazz[1]) && 'Armor'!=mov
  end
  gp_total+=15
  name=get_bond_name(event)
  mods=[[ 0, 0, 0, 0, 0, 0, 0],[ 1, 1, 1, 1, 1, 1, 2],[ 2, 3, 3, 3, 3, 4, 4],[ 4, 4, 5, 5, 6, 6, 7],[ 5, 6, 7, 7, 8, 8, 9],[ 7, 8, 8, 9,10,10,11],[ 8, 9,10,11,12,13,14],
        [10,11,12,13,14,15,16],[12,13,14,15,16,17,18],[13,14,15,17,18,19,21],[15,16,17,19,20,22,23],[16,18,19,21,22,24,25],[18,19,21,23,24,26,28],[19,21,23,25,26,28,30],
        [21,23,25,27,28,30,32],[23,24,26,29,31,33,35],[24,26,28,31,33,35,37],[26,28,30,33,35,37,39],[27,30,32,35,37,39,42],[29,31,34,37,39,42,44],[30,33,36,39,41,44,47]]
  stats=[0,0,0,0,0]
  gps=[0,0,0,0,0]
  stats[0]=10+rand(16)
  gps[0]=rand(mods.length-3)+1
  gps[0]=rand(mods.length-3)+1 if gps[0]<3 || gps[0]>14
  gps[0]=rand(mods.length-3)+1 if gps[0]<3 || gps[0]>14
  l1_total-=stats[0]
  gp_total-=gps[0]
  min_possible=[l1_total-40,2].max
  max_possible=[l1_total-8,14].min
  if max_possible<=min_possible
    stats[1]=min_possible
  else
    stats[1]=min_possible+rand(max_possible-min_possible+1)
  end
  min_possible=[gp_total-3*(mods.length-3),1].max
  max_possible=[gp_total-3,(mods.length-3)].min
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
  min_possible=[gp_total-2*(mods.length-3),1].max
  max_possible=[gp_total-2,(mods.length-3)].min
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
  min_possible=[gp_total-(mods.length-3),1].max
  max_possible=[gp_total-1,(mods.length-3)].min
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
  for i in 0...gps.length
    gps[i]-=3
  end
  unt=FEHUnit.new(name)
  unt.fake=['',event.user.id]
  unt.weapon=clazz.map{|q| q}
  unt.weapon.push(['Fire','Dark'].sample) if clazz==['Red','Tome']
  unt.weapon.push(['Thunder','Light'].sample) if clazz==['Blue','Tome']
  unt.weapon.push(['Wind'].sample) if clazz==['Green','Tome']
  unt.weapon.push(['Stone'].sample) if clazz==['Colorless','Tome']
  unt.movement=mov
  unt.growths=gps.map{|q| q}
  unt.stats1=stats.map{|q| q}
  unt.dancer_flag='Dancer' if clazz2.include?('Dancer')
  unt.dancer_flag='Singer' if clazz2.include?('Singer')
  unt.dancer_flag='Bard' if clazz2.include?('Bard')
  unt.clazz_flag=clazz2.reject{|q| ['Dancer','Singer','Bard'].include?(q)}
  disp_unit_stats(bot,event,unt,nil,'smol',false)
end

def disp_current_banners(event,bot,str='',returnlist=false,mode=0)
  data_load(['banner'])
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  str="#{str}\n\n#{date_display(event,t)}" unless returnlist
  x=$banners.reject{|q| !q.isCurrent?}.reverse
  str="#{"#{str}\n\n" unless returnlist || ![0,1].include?(mode)}__**Current Banners**__"
  for i in 0...x.length
    str2=x[i].name
    t2=Time.new(x[i].end_date[2],x[i].end_date[1],x[i].end_date[0])
    t2=t2-t
    t2+=24*60*60
    if t2/(24*60*60)>1
      str2="#{str2} - #{(t2/(24*60*60)).floor} days left"
    elsif t2/(60*60)>1
      str2="#{str2} - #{(t2/(60*60)).floor} hours left"
    elsif t2/60>1
      str2="#{str2} - #{(t2/60).floor} minutes left"
    elsif t2>1
      str2="#{str2} - #{(t2).floor} seconds left"
    end
    if ![0,1].include?(mode)
    elsif returnlist
      str="#{str}\n#{str2}"
    else
      str=extend_message(str,str2,event)
    end
  end
  if [0,3,4].include?(mode) && !returnlist
    book1=["Celica, Delthea, Genny",
           "Eirika(Memories), Hector(Brave), Myrrh",
           "Julia, Nephenee, Sigurd",
           "Hinoka(Wings), Kana(F), Siegbert",
           "Hector, Lyn, Lyn(Brave)",
           "Chrom(Branded), Maribelle, Sumia",
           "Ike, Ike(Brave), Mist",
           "Ishtar, Lene, Robin(M)(Fallen)",
           "Julia, Lucina, Lucina(Brave)",
           "Celica(Brave), Ephraim(Brave), Veronica(Brave)",
           "Hinoka, Ryoma, Takumi",
           "Hardin(Fallen), Olwen(World), Reinhardt(World)",
           "Genny, Katarina, Minerva",
           "Hector(Brave), Karla, Nino(Fangs)",
           "Alm, Delthea, Faye",
           "Morgan(F), Olivia(Traveler), Robin(M)(Fallen)",
           "Amelia, Ayra, Olwen(Bonds)",
           "Leif, Rhajat, Shiro",
           "Lyn(Brave), Ninian, Roy(Brave)",
           "Dorcas, Lute, Mia",
           "Hector, Luke, Tana",
           "Linde, Saber, Sonya",
           "Azura, Deirdre, Eldigan",
           "Ephraim, Jaffar, Karel",
           "Elincia, Innes, Tana",
           "Amelia, Nephenee, Sanaki",
           "Gray, Ike(Brave), Lucina(Brave)",
           "Azura, Elise, Leo",
           "Celica(Fallen), Ephraim(Brave), Hardin(Fallen)",
           "Deirdre, Linde, Tiki(Young)",
           "Micaiah, Veronica(Brave), Zelgius"]
    t2=Time.new(2017,2,2)-60*60
    t2=t-t2
    date=(((t2.to_i/60)/60)/24)
    book1.rotate(1) if mode==4
    f=book1[week_from(date,3)%book1.length].split(', ')
    f=f.map{|q| $units.find_index{|q2| q2.name==q}}.compact.map{|q| $units[q]}
    f=f.map{|q| "#{q.name}#{q.emotes(bot,false)}"}
    str=extend_message(str,"__**#{['Current','','','Current','Upcoming'][mode]} Book 1+2 Revival Units**__\n#{f.join(', ')}",event,2)
  end
  x=$banners.reject{|q| !q.isFuture?}.reverse
  return str if returnlist && mode==1
  if returnlist
    str="#{"#{str}\n\n" unless ![0,2].include?(mode)}__**Upcoming Banners**__"
  else
    str=extend_message(str,'__**Upcoming Banners**__',event,2)
  end
  for i in 0...x.length
    str2=x[i].name
    t2=Time.new(x[i].start_date[2],x[i].start_date[1],x[i].start_date[0])
    t2=t2-t
    if t2/(24*60*60)>1
      str2="#{str2} - #{(t2/(24*60*60)).floor} days from now"
    elsif t2/(60*60)>1
      str2="#{str2} - #{(t2/(60*60)).floor} hours from now"
    elsif t2/60>1
      str2="#{str2} - #{(t2/60).floor} minutes from now"
    elsif t2>1
      str2="#{str2} - #{(t2).floor} seconds from now"
    end
    if ![0,2].include?(mode)
    elsif returnlist
      str="#{str}\n#{str2}"
    else
      str=extend_message(str,str2,event)
    end
  end
  return str if returnlist
  event.respond str
end

def disp_current_events(event,bot,mode=0,shift=false)
  b=$events.reject{|q| !q.isCurrent?(true,shift)}
  b=$events.reject{|q| !q.isFuture?} if mode==1
  b=$events.reject{|q| !q.startsTomorrow?} if mode==2
  str="__**#{['Current ','Upcoming '][mode] if mode<2}Events#{' starting tomorrow' if mode==2}#{', as of tomorrow' if shift && mode==0}**__"
  mdfr=['left','from now',''][mode]
  t=Time.now
  t+=24*60*60 if shift
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  t-=24*60*60 if mode==1
  for i in 0...b.length
    str="#{str}\n#{b[i].fullName}"
    if mode==0
      t2=b[i].end_date.map{|q| q}
      t2=Time.new(t2[2],t2[1],t2[0])+24*60*60
      t2=t2-t
      t2+=24*60*60 if shift
    elsif mode==1
      t2=b[i].start_date.map{|q| q}
      t2=Time.new(t2[2],t2[1],t2[0])-24*60*60
      t2=t2-t
    end
    tt2=(t2/(24*60*60)).floor
    if t2/(24*60*60)>1
      str="#{str} - #{(t2/(24*60*60)).floor} days #{mdfr}"
    elsif t2/(60*60)>1
      str="#{str} - #{(t2/(60*60)).floor} hours #{mdfr}"
    elsif t2/60>1
      str="#{str} - #{(t2/60).floor} minutes #{mdfr}"
    elsif t2>1
      str="#{str} - #{(t2).floor} seconds #{mdfr}"
    end
    str="#{str}#{b[i].extendedData if mode==0}"
  end
  return str
end

def disp_current_paths(event,bot,mode=0,shift=false)
  data_load(['unit','path'])
  b=$paths.reject{|q| !q.isCurrent?(true,shift)}
  b=$paths.reject{|q| !q.isFuture?} if [-2,1].include?(mode)
  b=$paths.reject{|q| !q.startsTomorrow?} if mode==2
  return nil if mode<0 && b.length<=0
  str=str="__**#{['Current ','Upcoming '][mode] if mode<2}Ephemura Paths#{' starting tomorrow' if mode==2}#{', as of tomorrow' if shift && mode==0}**__"
  str=str="__**#{['','Current','Upcoming'][0-mode]} Ephemura Paths**__" if mode<0
  mdfr=['','left','from now'][0-mode]
  f=[]
  clr=[]; clr2=[]
  t=Time.now
  t+=24*60*60 if shift
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  if b.length>0
    b2=b.map{|q| q.eMonth}.uniq
    for i in 0...b2.length
      b3=b.reject{|q| q.eMonth != b2[i] || q.codes.length<=0}
      b4=b.reject{|q| q.eMonth != b2[i] || q.codes.length>0}
      if b3.map{|q| q.codes.length}.max<2 && mode>-1
        str2=b3.map{|q| q.codes[0]}.map{|q| "#{q.rarity}#{Rarity_stars[0][q.rarity-1]} #{q.unit_name}"}.join(', ')
        str="#{str}\n*#{b2[i]}:* #{str2}"
      else
        clr.push([])
        for i2 in 0...b3.length
          if mode<0
            for i3 in 0...b3[i2].codes.length
              cde=b3[i2].codes[i3]
              for i4 in 0...cde.rarity
                clr[i].push(cde.disp_color(0,1))
                clr2.push(cde.disp_color(0,1))
              end
            end
          end
          ign=true
          ign=false if b3[i2].codes.map{|q2| q2.cost[0]}.max<=0
          ign=false if b3[i2].codes.map{|q2| q2.cost[1]}.max<=0
          ign=true if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
          b3[i2]=b3[i2].codes.map{|q2| "#{q2.rarity}#{Rarity_stars[0][q2.rarity-1]} #{q2.unit_name}#{"#{q2.emotes(bot,false)} - #{q2.dispCost(ign)}" if mode<0}"}.join(' > ')
        end
        str="#{str}\n#{"\n" unless i==0}__*#{b2[i]}*__\n#{b3.join("\n")}" unless mode<0
        if mode<0
          if mode==-1
            t2=b4[0].end_date.map{|q| q}
            t2=Time.new(t2[2],t2[1],t2[0])+24*60*60
            t2=t2-t
            t2+=24*60*60 if shift
          elsif mode==-2
            t2=b4[0].start_date.map{|q| q}
            t2=Time.new(t2[2],t2[1],t2[0])-24*60*60
            t2=t2-t
          end
          tt2=(t2/(24*60*60)).floor
          if t2/(24*60*60)>1
            b3.push("\n#{(t2/(24*60*60)).floor} days #{mdfr}")
          elsif t2/(60*60)>1
            b3.push("\n#{(t2/(60*60)).floor} hours #{mdfr}")
          elsif t2/60>1
            b3.push("\n#{(t2/60).floor} minutes #{mdfr}")
          elsif t2>1
            b3.push("\n#{(t2).floor} seconds #{mdfr}")
          end
        end
        f.push([b2[i],b3.join("\n")])
      end
    end
  end
  if mode<0
    if b.length<=0
    elsif f.map{|q| "__**#{q[0]}**__\n#{q[1]}"}.join("\n\n").length>1900 || $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      f[0][0]="#{str}\n#{f[0][0]}"
      xpic='https://gamepedia.cursecdn.com/feheroes_gamepedia_en/9/9d/Divine_Code_Ephemera.png'
      for i in 0...f.length
        create_embed(event,f[i][0],f[i][1],avg_color(clr[i]),nil,xpic)
        xpic=nil
      end
    else
      create_embed(event,str,'',avg_color(clr2),nil,'https://gamepedia.cursecdn.com/feheroes_gamepedia_en/9/9d/Divine_Code_Ephemera.png',f)
    end
    return nil
  end
  return str
end

def avail_text(fgg='',includegrails=false,unt=nil,mode=0)
  ffgg=[]
  lowest_rarity=Max_rarity_merge[0]*1
  if fgg.length>1
    summon_type=[[],[],[],[],[],[],[],[]]
    for m in 1...Max_rarity_merge[0]+1
      summon_type[0].push("#{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}p") # summon pool
      summon_type[1].push("#{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}s")
      summon_type[2].push("#{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}d") # Daily Rotation Heroes
      summon_type[3].push("#{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}g") # Grand Hero Battles
      summon_type[4].push("#{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}f") # free heroes
      summon_type[5].push("#{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}q") # quest rewards
      summon_type[6].push("#{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}t") # Tempest Trials rewards
      summon_type[7].push("#{m}<:Icon_Rarity_Forma:699042072526585927> Forma Soul") if fgg.include?("#{m}o")
      summon_type[7].push("Story unit starting at #{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}y")
      summon_type[7].push("Purchasable at #{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}b")
      summon_type[7].push("Grail summon at #{m}#{Rarity_stars[0][m-1]}") if fgg.include?("#{m}r")
      lowest_rarity=[lowest_rarity,m].min if fgg.include?("#{m}d") || fgg.include?("#{m}g") || fgg.include?("#{m}f") || fgg.include?("#{m}q") || fgg.include?("#{m}t") || fgg.include?("#{m}s") || fgg.include?("#{m}p") || fgg.include?("#{m}o") || fgg.include?("#{m}y") || fgg.include?("#{m}b") || fgg.include?("#{m}r")
    end
    summon_type[7].push("~~Unavailable on New/Special Heroes banners~~") if fgg.include?('TD') && !unt.nil? && unt.id>318
    if summon_type[7].include?('Story unit starting at 2<:Icon_Rarity_2:448266417872044032>') && summon_type[7].include?('Story unit starting at 4<:Icon_Rarity_4:448266418459377684>')
      for i in 0...summon_type[7].length
        if summon_type[7][i]=='Story unit starting at 2<:Icon_Rarity_2:448266417872044032>'
          summon_type[7][i]='Story unit starting at 2<:Icon_Rarity_2:448266417872044032> (prior to version 2.5.0)'
        elsif summon_type[7][i]=='Story unit starting at 4<:Icon_Rarity_4:448266418459377684>'
          summon_type[7][i]='Story unit starting at 4<:Icon_Rarity_4:448266418459377684> (after version 2.5.0)'
        end
      end
    end
    for m in 0...6
      summon_type[m].sort!
    end
    mz=['summon','summon','daily rotation battles','Grand Hero Battle','free hero','quest reward','Tempest Trial reward']
    for m in 0...7
      if summon_type[m].length>0 && m==1
        summon_type[m]="Seasonal #{summon_type[m].join('/')} #{mz[m]}"
      elsif summon_type[m].length>0
        summon_type[m]="#{summon_type[m].join('/')} #{mz[m]}"
      else
        summon_type[m]=nil
      end
    end
    if summon_type[7].length>0
      summon_type[7]=summon_type[7].join(', ')
    else
      summon_type[7]=nil
    end
    summon_type.compact!
    ffgg=summon_type.map{|q| q}
  end
  highest_merge=Max_rarity_merge[1]
  unless fgg.gsub('0s','').include?('p') || fgg.gsub('0s','').include?('s')
    rardata2=fgg.gsub('0s','').gsub('PF','').gsub('XF','').gsub('TD','').gsub('RA','')
    for m in 1...Max_rarity_merge[0]+1
      rardata2=rardata2.gsub("#{m}r",'')
    end
    highest_merge=[Max_rarity_merge[1],rardata2.gsub('2y','').length/2-1].min
  end
  ffgg2=[]
  if (includegrails || mode==2) && highest_merge<Max_rarity_merge[1]
    if fgg.include?('r')
      ffgg2.push("**Highest grail-less merge:** #{highest_merge}")
    elsif highest_merge>=0
      ffgg2.push("**Highest available merge:** #{highest_merge}")
    end
    grails=0
    grailist=[100,150,200,250,300,350,400,450,500,500,500]
    grails=grailist[0,Max_rarity_merge[1]-highest_merge].inject(0){|sum,x| sum + x }
    unless unt.nil? || unt.owner.nil?
      ffgg2.push("**Current merge count:** #{unt.merge_count}")
      if unt.owner=='Mathoo' && unt.name=='Takumi(Fallen)'
        grails-=grailist[0,unt.merge_count].inject(0){|sum,x| sum + x } unless unt.merge_count<highest_merge
      else
        grails-=grailist[0,unt.merge_count-highest_merge].inject(0){|sum,x| sum + x } unless unt.merge_count<highest_merge
      end
    end
    grails=0 if !unt.nil? && ['Anna','Sharena','Alfonse'].include?(unt.name)
    grails=0 if !unt.nil? && unt.availability[0].include?('-')
    grails=0 if highest_merge<0
    ffgg2.push("<:Heroic_Grail:574798333898653696>**Grails to +10:** #{grails}") if grails>0
  end
  return [ffgg,ffgg2,highest_merge,lowest_rarity] if mode==2
  return [[ffgg,ffgg2].flatten,highest_merge,lowest_rarity] if mode==1
  return [ffgg,ffgg2].flatten
end

def banner_list(event,bot,args=[],xname=nil)
  args=event.message.text.downcase.split(' ') if args.nil? || args.length<=0
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  if xname.is_a?(Array)
    g=get_markers(event)
    u=$units.reject{|q| !q.fake.nil? && q.fake[0]!=g}.map{|q| q.name}
    xname=xname.reject{|q| !u.include?(q) && !['Robin','Kris'].include?(q)}
    for i in 0...xname.length
      banner_list(event,bot,args,xname[i])
    end
    return nil
  elsif xname.is_a?(FEHUnit)
    unit=xname.clone
  else
    unit=$units.find_index{|q| q.name==xname}
    return nil if unit.nil?
    unit=$units[unit].clone
  end
  bnrz=unit.focus_banners.map{|q| q}
  justnames=true
  metadata_load()
  fail_mode=$summon_rate[2]%3
  justnames2=false
  justnames2=true if has_any?(event.message.text.downcase.split(' '),['justnames','just_names']) || " #{event.message.text.downcase} ".include?(' just names ')
  if !safe_to_spam?(event)
    justnames=false if has_any?(event.message.text.downcase.split(' '),['rates','details','specifics'])
  else
    justnames=false
    justnames=true if has_any?(event.message.text.downcase.split(' '),['justnames','just_names']) || " #{event.message.text.downcase} ".include?(' just names ')
  end
  star_buff=nil
  for i in 0...args.length
    if args[i].to_i.to_s==args[i]
      star_buff=args[i].to_i if star_buff.nil?
    elsif args[i][0,1]=='+' && args[i][1,args[i].length-1].to_i.to_s==args[i][1,args[i].length-1]
      star_buff=args[i][1,args[i].length-1].to_i if star_buff.nil?
    elsif args[i][0,1]=='-' && args[i][1,args[i].length-1].to_i.to_s==args[i][1,args[i].length-1]
      star_buff=0-args[i][1,args[i].length-1].to_i if star_buff.nil?
    end
  end
  star_buff=0 if star_buff.nil?
  str=''
  str="__**Debut**__\n*Launch Unit*" if unit.availability[0].include?('LU')
  str='>Fake unit<' unless unit.fake.nil?
  otherstr=unit.availability[0].gsub('0s','').gsub('0o','').gsub('1p','').gsub('1s','').gsub('2p','').gsub('2s','').gsub('3p','').gsub('3s','').gsub('4p','').gsub('4s','').gsub('5p','').gsub('5s','').gsub('6p','').gsub('6s','')
  if unit.availability.length>1
    fgg=unit.availability[0].split('p')[0].split('s')[0]
    otherstr=unit.availability[0].gsub('0s','').gsub('0o','').split('p')[-1].split('s')[-1]
    fgg=fgg[0,fgg.length-1] if fgg.length>2
    ffgg=avail_text(fgg)
    str="#{"__**First appeared as**__\n#{ffgg.join("\n")}\n\n" if ffgg.length>0}__**Joined the summon pool during:**__\n#{unit.availability[1,unit.availability.length-1].join(', ')}"
  end
  otherstr=avail_text(otherstr) if otherstr.length>0
  if str.length<=0 && bnrz.length>0
    x=bnrz[0].clone
    bnrz.shift
    if justnames2
      str="__**Debut Banner**__\n#{x.name}"
    else
      str="__**Debut Banner**__\n__*#{x.name}*__\n#{x.description(unit,5*star_buff)}"
    end
  elsif str.length<=0
    ffgg=avail_text(unit.availability[0],true,unit)
    str=">No banners found<"
    str="#{str}\n\n#{ffgg.join("\n")}" unless ffgg.length<=0
  end
  hdr="__Banners **#{unit.name}#{unit.emotes(bot,false)}** has been on__"
  hdr="#{hdr}\nBanners in **+#{star_buff}** form (after #{star_buff*5} to #{star_buff*5+4} failures to get a 5<:Icon_Rarity_5:448266417553539104>)" if star_buff>0
  hdr="__Banners **#{unit.name}#{unit.emotes(bot,false)}** has been on__\nBanners in **Omega** form (after 120 failures to get a 5<:Icon_Rarity_5:448266417553539104>)" if star_buff>=24
  c=0
  if bnrz.length<=0 && (!unit.availability[0].include?('p') || justnames2)
    create_embed(event,hdr,str,unit.disp_color,"#{unit.focus_banners.length} total",unit.thumbnail(event,bot))
    return nil
  end
  xpic=unit.thumbnail(event,bot)
  str="#{str}#{"\n" unless justnames || !safe_to_spam?(event)}\n\n__**#{'Other ' if str.include?('__**Debut Banner**__')}Banners**__" if bnrz.length>0
  xf="\n"
  xf='' if justnames || !safe_to_spam?(event)
  for i in 0...bnrz.length
    str2=bnrz[i].name
    str2="__*#{bnrz[i].name}*__\n#{bnrz[i].description(unit,5*star_buff)}" unless justnames || !safe_to_spam?(event)
    if "#{str}\n#{xf unless i<=0}#{str2}".length>1900
      if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        event.respond str
      else
        create_embed(event,hdr,str,unit.disp_color(c),nil,xpic)
        hdr=''
        xpic=nil
        c+=1
      end
      str="#{str2}"
    else
      str="#{str}\n#{xf unless i<=0}#{str2}"
    end
  end
  if unit.availability[0].include?('p')
    len='%.2f'
    len='%.4f' if Shardizard==4
    str2=''
    m=[]
    if unit.availability[0].include?('5p') && !unit.availability[0].include?('TD') && unit.duo.nil?
      x=$banners.reject{|q| !q.tags.include?('NewHeroes') || q.start_date.nil? || q.start_date[2]<2020 || q.start_date[1]<3}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('5p') || q.availability[0].include?('TD') || !q.duo.nil? || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('5p') || q.availability[0].include?('TD') || !q.duo.nil? || !q.fake.nil?}.length
      y=x[3]/y
      y2=x[3]/y2
      has_revival=false
      has_revival=true if $units.reject{|q| !q.isRevival?}.length>0
      m.push("5<:Icon_Rarity_5:448266417553539104> Non-Focus#{' (New/Special Heroes)' if has_revival} - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.is4Special?
      x=$banners.reject{|q| q.start_date.nil? || q.start_date[2]<2021 || q.start_date[1]<2 || q.start_date[0]<2}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.is4Special? || !q.duo.nil? || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.is4Special? || !q.duo.nil? || !q.fake.nil?}.length
      y=x[3]/y
      y2=x[3]/y2
      m.push("4<:Icon_Rarity_4:448266418459377684> Special - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('5p') && unit.duo.nil? && $units.reject{|q| !q.isRevival?}.length>0
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('5p') || !q.duo.nil? || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('5p') || !q.duo.nil? || !q.fake.nil?}.length
      y=x[3]/y
      y2=x[3]/y2
      m.push("5<:Icon_Rarity_5:448266417553539104> Non-Focus (standard banner) - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('4p')
      x=$banners.reject{|q| !q.tags.include?('NewHeroes') || q.start_date.nil? || q.start_date[2]<2020 || q.start_date[1]<3}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('4p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('4p') || !q.fake.nil?}.length
      y3=[x[6]/y,x[6]/y2]
      m.push("4<:Icon_Rarity_4:448266418459377684> Non-Focus (New/Special Heroes) - #{len % y3[0]}% (Perceived), #{len % y3[1]}% (Actual)")
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=x[6]/y
      y2=x[6]/y2
      m.push("4<:Icon_Rarity_4:448266418459377684> (standard banner) - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('3p')
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('3p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('3p') || !q.fake.nil?}.length
      y=x[8]/y
      y2=x[8]/y2
      m.push("3<:Icon_Rarity_3:448266417934958592> all the time - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('2p')
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('2p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('2p') || !q.fake.nil?}.length
      y=x[10]/y
      y2=x[10]/y2
      m.push("2<:Icon_Rarity_2:448266417872044032> all the time - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('1p')
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('1p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('1p') || !q.fake.nil?}.length
      y=x[12]/y
      y2=x[12]/y2
      m.push("1<:Icon_Rarity_1:448266417481973781> all the time - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    str3=[]
    str3.push("__*Standard 3% banners*__\n#{m.join("\n")}") if m.length>0
    m=[]
    if unit.availability[0].include?('5p') && !unit.is4Special? && unit.duo.nil?
      x=$banners.reject{|q| !q.tags.include?('HeroFest')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('5p') || !q.duo.nil? || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('5p') || !q.duo.nil? || !q.fake.nil?}.length
      y3=[x[3]/y,x[3]/y2]
      m.push("5<:Icon_Rarity_5:448266417553539104> Non-Focus (Hero Fests) - #{len % y3[0]}% (Perceived), #{len % y3[1]}% (Actual)")
      x=$banners.reject{|q| !q.tags.include?('Book2')}.sample.calc_pity(star_buff*5)
      y=x[3]/y
      y2=x[3]/y2
      m.push("5<:Icon_Rarity_5:448266417553539104> Non-Focus (Revival banner) - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('4p')
      x=$banners.reject{|q| !q.tags.include?('4Star')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('4p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('4p') || !q.fake.nil?}.length
      y3=[x[6]/y,x[6]/y2]
      m.push("4<:Icon_Rarity_4:448266418459377684> Non-Focus (4+5 star focus banners) - #{len % y3[0]}% (Perceived), #{len % y3[1]}% (Actual)")
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('4p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('4p') || !q.fake.nil?}.length
      y=x[6]/y
      y2=x[6]/y2
      m.push("4<:Icon_Rarity_4:448266418459377684> (standard banner) - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('3p')
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('3p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('3p') || !q.fake.nil?}.length
      y=x[8]/y
      y2=x[8]/y2
      m.push("3<:Icon_Rarity_3:448266417934958592> all the time - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('2p')
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('2p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('2p') || !q.fake.nil?}.length
      y=x[10]/y
      y2=x[10]/y2
      m.push("2<:Icon_Rarity_2:448266417872044032> all the time - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    if unit.availability[0].include?('1p')
      x=$banners.reject{|q| !q.tags.include?('GHB')}.sample.calc_pity(star_buff*5)
      y=$units.reject{|q| q.weapon_color != unit.weapon_color || !q.availability[0].include?('1p') || !q.fake.nil?}.length
      y2=$units.reject{|q| !q.availability[0].include?('1p') || !q.fake.nil?}.length
      y=x[12]/y
      y2=x[12]/y2
      m.push("1<:Icon_Rarity_1:448266417481973781> all the time - #{len % y}% (Perceived), #{len % y2}% (Actual)")
    end
    str3.push("__*Other banners*__\n#{m.join("\n")}") if m.length>0
    str2="__**#{'Starting ' if star_buff<=0}Non-Focus Chances**__\n#{str3.join("\n\n")}" if str3.length>0
    if str2.length<=0
    elsif "#{str}\n#{xf*2}#{str2}".length>1900
      if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        event.respond str
      else
        create_embed(event,hdr,str,unit.disp_color(c),nil,xpic)
        hdr=''
        xpic=nil
        c+=1
      end
      str="#{str2}"
    else
      str="#{str}\n\n#{xf}#{str2}"
    end
  end
  if otherstr.length<=0
  elsif "#{str}\n#{xf*2}__**Other Appearances**__\n#{otherstr.join("\n")}".length>1900
    if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond str
    else
      create_embed(event,hdr,str,unit.disp_color(c),nil,xpic)
      hdr=''
      xpic=nil
      c+=1
    end
    str="__**Other Appearances**__\n#{otherstr.join("\n")}"
  else
    str="#{str}\n#{xf*2}__**Other Appearances**__\n#{otherstr.join("\n")}"
  end
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    str=extend_message(str,"#{unit.focus_banners.length} total",event,2)
    event.respond str
  else
    create_embed(event,hdr,str,unit.disp_color(c),"#{unit.focus_banners.length} total",xpic)
  end
end

def create_summon_list(clr,mainpool=nil)
  p=[['1<:Icon_Rarity_1:448266417481973781> exclusive',[]],['1<:Icon_Rarity_1:448266417481973781>-2<:Icon_Rarity_2:448266417872044032>',[]],['2<:Icon_Rarity_2:448266417872044032> exclusive',[]],['2<:Icon_Rarity_2:448266417872044032>-3<:Icon_Rarity_3:448266417934958592>',[]],['3<:Icon_Rarity_3:448266417934958592> exclusive',[]],['3<:Icon_Rarity_3:448266417934958592>-4<:Icon_Rarity_4:448266418459377684>',[]],['4<:Icon_Rarity_4:448266418459377684> exclusive',[]],['4<:Icon_Rarity_4:448266418459377684>-5<:Icon_Rarity_5:448266417553539104>',[]],['5<:Icon_Rarity_5:448266417553539104> exclusive',[]],['5<:Icon_Rarity_5:448266417553539104>-6<:Icon_Rarity_6:491487784650145812>',[]],['6<:Icon_Rarity_6:491487784650145812> exclusive',[]],['Other',[]]]
  for i in 0...clr.length
    clr[i].name="~~#{clr[i].name}~~" if clr[i].availability[0].include?('TD')
    if clr[i].availability[0].include?('1p')
      if clr[i].availability[0].include?('2p')
        p[1][1].push(clr[i].name)
      elsif clr[i].availability[0].include?('3p') || clr[i].availability[0].include?('4p') || clr[i].availability[0].include?('5p')
        p[11][0][1].push("#{clr[i].name} - 1#{'/3' if clr[i].availability[0].include?('3p')}#{'/4' if clr[i].availability[0].include?('4p')}#{'/5' if clr[i].availability[0].include?('5p')}#{'/6' if clr[i].availability[0].include?('6p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[0][1].push(clr[i].name)
      end
    elsif clr[i].availability[0].include?('2p')
      if clr[i].availability[0].include?('3p')
        p[3][1].push(clr[i].name)
      elsif clr[i].availability[0].include?('4p') || clr[i].availability[0].include?('5p')
        p[11][0][1].push("#{clr[i].name} - 2#{'/4' if clr[i].availability[0].include?('4p')}#{'/5' if clr[i].availability[0].include?('5p')}#{'/6' if clr[i].availability[0].include?('6p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[2][1].push(clr[i].name)
      end
    elsif clr[i].availability[0].include?('3p')
      if clr[i].availability[0].include?('4p')
        p[5][1].push(clr[i].name)
      elsif clr[i].availability[0].include?('5p') || clr[i].availability[0].include?('6p')
        p[11][0][1].push("#{clr[i][0]} - 3#{'/5' if clr[i].availability[0].include?('5p')}#{'/6' if clr[i].availability[0].include?('6p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[4][1].push(clr[i].name)
      end
    elsif clr[i].availability[0].include?('4p')
      if clr[i].availability[0].include?('5p')
        p[7][1].push(clr[i].name)
      elsif clr[i].availability[0].include?('6p')
        p[11][0][1].push("#{clr[i][0]} - 4#{'/6' if clr[i].availability[0].include?('6p')}<:Icon_Rarity_S:448266418035621888>")
      else
        p[6][1].push(clr[i].name)
      end
    elsif clr[i].availability[0].include?('5p')
      if clr[i].availability[0].include?('6p')
        p.availability[1].push(clr[i].name)
      else
        p[8][1].push(clr[i].name)
      end
    elsif clr[i].availability[0].include?('6p')
      p[10][1].push(clr[i].name)
    else
      p[11][0][1].push("#{clr[i].name} - weird")
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

def disp_summon_pool(event,args=[])
  args=event.message.text.downcase.split(' ') if args.nil? || args.length<=0
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load(['unit'])
  k=$units.reject{|q| !q.availability[0].include?('p') || !q.fake.nil? || !q.duo.nil?}
  k=k.reject{|q| !q.availability[0].include?('LU')} if args.map{|q| q.downcase}.include?('launch')
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
    r=k.reject{|q| q.weapon_color !='Red'}
    r=create_summon_list(r,pooltype)
    if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0xE22141,nil,nil,r,4)
    end
  end
  if colors.include?('Blue')
    r=k.reject{|q| q.weapon_color !='Blue'}
    r=create_summon_list(r,pooltype)
    if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x2764DE,nil,nil,r,4)
    end
  end
  if colors.include?('Green')
    r=k.reject{|q| q.weapon_color !='Green'}
    r=create_summon_list(r,pooltype)
    if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x09AA24,nil,nil,r,4)
    end
  end
  if colors.include?('Colorless')
    r=k.reject{|q| q.weapon_color !='Colorless'}
    r=create_summon_list(r,pooltype)
    if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond r.map{|q| "**#{q[0]}:** #{q[1].split("\n").join(', ')}"}.join("\n")
    else
      create_embed(event,"",'',0x64757D,nil,nil,r,4)
    end
  end
  
end

def summon_sim(bot,event,args=[])
  if event.server.id==238770788272963585 && event.channel.id != 377526015939051520
    event.respond 'This command is unavailable in this channel.  Please go to <#377526015939051520>.'
    return nil
  elsif event.server.id==330850148261298176 && event.channel.id != 330851389104455680
    event.respond 'This command is unavailable in this channel.  Please go to <#330851389104455680>.'
    return nil
  elsif event.server.id==328109510449430529 && event.channel.id != 328136987804565504
    event.respond 'This command is unavailable in this channel.  Please go to <#328136987804565504>.'
    return nil
  elsif event.server.id==305889949574496257 && event.channel.id != 460903186773835806
    event.respond 'This command is unavailable in this channel.  Please go to <#460903186773835806>.'
    return nil
  elsif event.server.id==271642342153388034 && event.channel.id != 312736133203361792
    event.respond 'This command is unavailable in this channel.  Please go to <#312736133203361792>.'
    return nil
  end
  trucolors=[]
  for i in 0...args.length
    trucolors.push('Red') if ['red','reds','all'].include?(args[i].downcase)
    trucolors.push('Blue') if ['blue','blues','all'].include?(args[i].downcase)
    trucolors.push('Green') if ['green','greens','all'].include?(args[i].downcase)
    trucolors.push('Colorless') if ['colorless','colourless','clear','clears','all'].include?(args[i].downcase)
  end
  autocrack=false
  multisummon=false
  multisummon=true if has_any?(args.map{|q| q.downcase},['multisummon','multi'])
  if $banner.length>0
    post=Time.now
    if (post - $banner[1]).to_f < 300 # time
      if trucolors.length>0 || multisummon
        autocrack=true
      elsif event.server.id==$banner[2] # server
        event.respond "<@#{$banner[0]}>, please choose your summons as others would like to use this command" # user
        return nil
      else
        event.respond 'Please wait, as another server is using this command.'
        return nil
      end
    else
      $banner=[]
    end
  end
  args=event.message.text.downcase.split(' ') if args.nil? || args.length<=0
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load(['unit','banner'])
  b=find_in_banners(bot,event,args,1,false,true)
  b=b[1]
  b=$banners.map{|q| q} if b.length<=0
  b=b.reject{|q| q.unit_list.length<=0}
  b=b.sample
  str="**Summoner:** #{event.user.distinct}\n\n**Banner:** #{b.name}"
  natures=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res','+Def -HP','+Def -Atk',
           '+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral']
  natures2=natures.map{|q| q}
  natures=['Neutral'] if ['TT Units','GHB Units'].include?(b.name)
  d=[]
  d.push("#{b.start_date[0]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][b.start_date[1]]} #{b.start_date[2]}") unless b.start_date.nil?
  d.push("#{b.end_date[0]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][b.end_date[1]]} #{b.end_date[2]}") unless b.end_date.nil?
  str="#{str}\n*Real world run:* #{d.join(' - ')}" unless d.length<=0
  str="#{str}\n\n__**Focus Units:**__"
  y=b.full_banner.map{|q| q}
  disprar=false
  disprar=true if y[4].length>0 && y[4]!=y[2]
  disprar=true if y[6].length>0 && y[6]!=y[2]
  disprar=true if y[8].length>0 && y[8]!=y[2]
  disprar=true if y[10].length>0 && y[10]!=y[2]
  x=b.reds.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if q.availability[0].include?('4p') || q.availability[0].include?('4s')}#{'<:Icon_Rarity_3:448266417934958592>' if q.availability[0].include?('3p') || q.availability[0].include?('3s')}#{'<:Icon_Rarity_2:448266417872044032>' if q.availability[0].include?('2p') || q.availability[0].include?('2s')}#{'<:Icon_Rarity_1:448266417481973781>' if q.availability[0].include?('1p') || q.availability[0].include?('1s')}"}
  x=b.reds.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Red:455053002256941056> *Red*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.blues.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if q.availability[0].include?('4p') || q.availability[0].include?('4s')}#{'<:Icon_Rarity_3:448266417934958592>' if q.availability[0].include?('3p') || q.availability[0].include?('3s')}#{'<:Icon_Rarity_2:448266417872044032>' if q.availability[0].include?('2p') || q.availability[0].include?('2s')}#{'<:Icon_Rarity_1:448266417481973781>' if q.availability[0].include?('1p') || q.availability[0].include?('1s')}"}
  x=b.blues.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Blue:455053001971859477> *Blue*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.greens.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if q.availability[0].include?('4p') || q.availability[0].include?('4s')}#{'<:Icon_Rarity_3:448266417934958592>' if q.availability[0].include?('3p') || q.availability[0].include?('3s')}#{'<:Icon_Rarity_2:448266417872044032>' if q.availability[0].include?('2p') || q.availability[0].include?('2s')}#{'<:Icon_Rarity_1:448266417481973781>' if q.availability[0].include?('1p') || q.availability[0].include?('1s')}"}
  x=b.greens.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Green:455053002311467048> *Green*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.colorlesses.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if q.availability[0].include?('4p') || q.availability[0].include?('4s')}#{'<:Icon_Rarity_3:448266417934958592>' if q.availability[0].include?('3p') || q.availability[0].include?('3s')}#{'<:Icon_Rarity_2:448266417872044032>' if q.availability[0].include?('2p') || q.availability[0].include?('2s')}#{'<:Icon_Rarity_1:448266417481973781>' if q.availability[0].include?('1p') || q.availability[0].include?('1s')}"}
  x=b.colorlesses.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Colorless:455053002152083457> *Colorless*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.golds.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if q.availability[0].include?('4p') || q.availability[0].include?('4s')}#{'<:Icon_Rarity_3:448266417934958592>' if q.availability[0].include?('3p') || q.availability[0].include?('3s')}#{'<:Icon_Rarity_2:448266417872044032>' if q.availability[0].include?('2p') || q.availability[0].include?('2s')}#{'<:Icon_Rarity_1:448266417481973781>' if q.availability[0].include?('1p') || q.availability[0].include?('1s')}"}
  x=b.golds.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Gold:549338084102111250> *Gold*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.calc_pity($summon_rate[0])
  str2="__**#{'Current ' unless $summon_rate[0]<=0}Summon Rates**__"
  if x[0]>0
    str2="#{str2}\n6<:Icon_Rarity_6p10:491487784822112256> Focus:  #{'%.2f' % x[0]}%"
    str2="#{str2}\nOther 6<:Icon_Rarity_6:491487784650145812>:  #{'%.2f' % x[1]}%" unless x[1]<=0
  elsif x[1]>0
    str2="#{str2}\n6<:Icon_Rarity_6:491487784650145812> Unit:  #{'%.2f' % x[1]}%"
  end
  if x[2]>0
    str2="#{str2}\n5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % x[2]}%"
    str2="#{str2}\nOther 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % x[3]}%" unless x[3]<=0
  elsif x[3]>0
    str2="#{str2}\n5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % x[3]}%"
  end
  if x[4]>0
    str2="#{str2}\n4<:Icon_Rarity_4p10:448272714210476033> Focus:  #{'%.2f' % (x[4])}%"
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Special:  #{'%.2f' % x[5]}%" unless x[5]<=0
    str2="#{str2}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % x[6]}%" unless x[6]<=0
  elsif x[5]>0
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Special:  #{'%.2f' % x[5]}%"
    str2="#{str2}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % x[6]}%" unless x[6]<=0
  elsif x[6]>0
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Unit:  #{'%.2f' % x[6]}%"
  end
  if x[7]>0
    str2="#{str2}\n3<:Icon_Rarity_3p10:448294378293952513> Focus:  #{'%.2f' % (x[7])}%"
    str2="#{str2}\nOther 3<:Icon_Rarity_3:448266417934958592>:  #{'%.2f' % x[8]}%" unless x[8]<=0
  elsif x[8]>0
    str2="#{str2}\n3<:Icon_Rarity_3:448266417934958592> Unit:  #{'%.2f' % x[8]}%"
  end
  if x[9]>0
    str2="#{str2}\n2<:Icon_Rarity_2p10:448294378205872130> Focus:  #{'%.2f' % (x[9])}%"
    str2="#{str2}\nOther 2<:Icon_Rarity_2:448266417872044032>:  #{'%.2f' % x[10]}%" unless x[10]<=0
  elsif x[10]>0
    str2="#{str2}\n2<:Icon_Rarity_2:448266417872044032> Unit:  #{'%.2f' % x[10]}%"
  end
  if x[11]>0
    str2="#{str2}\n1<:Icon_Rarity_1p10:448294377878716417> Focus:  #{'%.2f' % (x[11])}%"
    str2="#{str2}\nOther 1<:Icon_Rarity_1:448266417481973781>:  #{'%.2f' % x[12]}%" unless x[12]<=0
  elsif x[11]>0
    str2="#{str2}\n1<:Icon_Rarity_1:448266417481973781> Unit:  #{'%.2f' % x[12]}%"
  end
  if $summon_rate[0]>=120 && $summon_rate[2]%3==0
    str2=str2.gsub('4<:Icon_Rarity_4p10:448272714210476033>',"~~4\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('4<:Icon_Rarity_4:448266418459377684>',"~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('3<:Icon_Rarity_3p10:448294378293952513>',"~~3\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('3<:Icon_Rarity_3:448266417934958592>',"~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('2<:Icon_Rarity_2p10:448294378205872130>',"~~2\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('2<:Icon_Rarity_2:448266417872044032>',"~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('1<:Icon_Rarity_1p10:448294377878716417>',"~~1\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('1<:Icon_Rarity_1:448266417481973781>',"~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
  end
  str=extend_message(str,str2,event,2)
  r=[]
  rar=[6,6,5,5,4,4,4,3,3,2,2,1,1]
  rarities=['6<:Icon_Rarity_6p10:491487784822112256>','6<:Icon_Rarity_6:491487784650145812>','5<:Icon_Rarity_5p10:448272715099406336>','5<:Icon_Rarity_5:448266417553539104>',
            '4<:Icon_Rarity_4p10:448272714210476033>','~~4\\*S~~ 5<:Icon_Rarity_5:448266417553539104>','4<:Icon_Rarity_4:448266418459377684>','3<:Icon_Rarity_3:448266417934958592>F',
            '3<:Icon_Rarity_3:448266417934958592>','2<:Icon_Rarity_2:448266417872044032>F','2<:Icon_Rarity_2:448266417872044032>','1<:Icon_Rarity_1:448266417481973781>F',
            '1<:Icon_Rarity_1:448266417481973781>']
  superrarities=['6<:Icon_Rarity_6p10:491487784822112256>','6<:Icon_Rarity_6:491487784650145812>','5<:Icon_Rarity_5p10:448272715099406336>','5<:Icon_Rarity_5:448266417553539104>',
                 '~~4\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>','~~4\\*(s)~~ 5<:Icon_Rarity_5:448266417553539104>','~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>',
                 '~~3\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>','~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>','~~2\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>',
                 '~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>','~~1\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>','~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>']
  for i in 0...5
    k=rand(1000000)
    united=false
    for i2 in 0...x.length
      if united || x[i2]<=0
      elsif k<(x[0,i2+1].inject(0){|sum,q| sum+q}*10000).to_i
        united=true
        hx=b.full_banner[i2].sample
        rx=rarities[i2]
        rx=superrarities[i2] if $summon_rate[0]>=120 && $summon_rate[2]%3==0
        nr=natures.sample
        nr=natures2.sample if i2%2==1
        m=rar[i2]
      end
    end
    unless united # && !hx.nil?
      hx=b.full_banner[5].sample
      rx='4<:Icon_Rarity_4:448266418459377684>'
      rx='~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if $summon_rate[0]>=120 && $summon_rate[2]%3==0
      nr=natures2.sample
      m=4
    end
    r.push([rx,hx,nr,i+1,m])
  end
  if multisummon
    multi_summon(bot,event,event,event.user.id,trucolors,str,0,nil,b,r)
    return nil
  elsif trucolors.length>0
    r2=r.map{|q| q}
    r2=r.reject{|q| !trucolors.include?(q[1].weapon_color) && !(trucolors.include?('Gold') && !['Red','Blue','Green','Colorless'].include?(q[1].weapon_color))} if trucolors.length>0
    if r2.length<=0
      r2=[r[0].map{|q| q}]
      if autocrack
        str2="__**Summoning Results**__"
        for i in 0...r2.length
          str2="#{str2}\nOrb ##{r2[i][3]} contains a **#{r2[i][0]} #{r2[i][1].name}**#{r2[i][1].emotes(bot,false)} (*#{r2[i][2]}*)"
        end
        str=extend_message(str,str2,event,2)
        str2="In this current summoning session, you fired Breidablik #{r2.length} time#{'s' unless r2.length==1}, expending #{[0,5,9,13,17,20][r2.length]} orbs."
        str2="#{str2}\nSince the last 5\* summons, Breidablik has been fired #{$summon_rate[0]+r2.length} time#{"s" unless $summon_rate[0]+r2.length==1} and #{$summon_rate[1]+[0,5,9,13,17,20][r2.length]} orbs have been expended."
        str=extend_message(str,str2,event,2)
        $summon_rate[0]+=r2.length
        $summon_rate[1]+=[0,5,9,13,17,20][r2.length]
        if r2.reject{|q| q[4]<5}.length>0
          $summon_rate=[0,0,$summon_rate[2]]
          $summon_rate[2]=($summon_rate[2]+1)%3+3
        end
        metadata_save()
        return nil
      else
        str2="None of the colors you requested appeared.  Here are your **Orb options:**"
      end
    else
      str2="__**Summoning Results**__"
      for i in 0...r2.length
        str2="#{str2}\nOrb ##{r2[i][3]} contains a **#{r2[i][0]} #{r2[i][1].name}**#{r2[i][1].emotes(bot,false)} (*#{r2[i][2]}*)"
      end
      str=extend_message(str,str2,event,2)
      str2="In this current summoning session, you fired Breidablik #{r2.length} time#{'s' unless r2.length==1}, expending #{[0,5,9,13,17,20][r2.length]} orbs."
      str2="#{str2}\nSince the last 5\* summons, Breidablik has been fired #{$summon_rate[0]+r2.length} time#{"s" unless $summon_rate[0]+r2.length==1} and #{$summon_rate[1]+[0,5,9,13,17,20][r2.length]} orbs have been expended."
      str=extend_message(str,str2,event,2)
      $summon_rate[0]+=r2.length
      $summon_rate[1]+=[0,5,9,13,17,20][r2.length]
      if r2.reject{|q| q[4]<5}.length>0
        $summon_rate=[0,0,$summon_rate[2]]
        $summon_rate[2]=($summon_rate[2]+1)%3+3
      end
      metadata_save()
      event.respond str
      return nil
    end
  else
    str2='__**Orb options**__'
  end
  for i in 0...r.length
    wemote=''
    clr=r[i][1].weapon_color
    clr='Gold' unless ['Red','Blue','Green','Colorless'].include?(clr)
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Orb_#{clr}"}
    wemote=moji[0].mention unless moji.length<=0
    str2="#{str2}\nOrb ##{r[i][3]}.) #{wemote} #{clr}"
  end
  str=extend_message(str,str2,event,2)
  str2="To open orbs, please respond - in a single message - with the number of each orb you want to crack, or the colors of those orbs."
  str2="#{str2}\nYou can also just say \"Summon all\" to open all orbs."
  str2="#{str2}\nInclude the word \"Multisummon\" (with optional colors) to continue summoning until you pull a 5<:Icon_Rarity_5:448266417553539104>."
  str=extend_message(str,str2,event,2)
  event.respond str
  $banner=[event.user.id, Time.now, event.server.id, r.map{|q| q}, b.clone]
  trucolors=[]; trucolors2=[]
  trucolors2.push(['Red',['red','reds']])
  trucolors2.push(['Blue',['blue','blues']])
  trucolors2.push(['Green',['green','greens']])
  trucolors2.push(['Colorless',['colorless','colourless','clear','clears','grey','greys','gray','grays']])
  for i in 0...5
    trucolors.push(['Red',['red','reds']]) if $banner[3][i][1].weapon_color=='Red'
    trucolors.push(['Blue',['blue','blues']]) if $banner[3][i][1].weapon_color=='Blue'
    trucolors.push(['Green',['green','greens']]) if $banner[3][i][1].weapon_color=='Green'
    trucolors.push(['Colorless',['colorless','colourless','clear','clears','grey','greys','gray','grays']]) if $banner[3][i][1].weapon_color=='Colorless'
  end
  trucolors.uniq!
  event.channel.await(:bob, from: event.user.id) do |e|
    if $banner.length<=0
    elsif e.user.id==$banner[0] && e.message.text.downcase.split(' ').include?('multisummon')
      puts e.message.text
      l=[]
      for i in 0...trucolors2.length
        l.push(trucolors2[i][0]) if has_any?(trucolors2[i][1],e.message.text.downcase.split(' '))
      end
      multi_summon(bot,event,e,e.user.id,l)
    elsif e.user.id==$banner[0] && e.message.text.downcase.include?('summon all')
      puts e.message.text
      crack_orbs(bot,event,e,e.user.id,[1,2,3,4,5])
    elsif e.user.id==$banner[0] && (e.message.text =~ /1|2|3|4|5/ || has_any?(trucolors.map{|q| q[1]}.join(' ').split(' '),e.message.text.downcase.split(' ')))
      puts e.message.text
      l=[]
      for i in 1...6
        l.push(i) if e.message.text.include?(i.to_s)
      end
      for i in 0...trucolors.length
        l.push(trucolors[i][0]) if has_any?(trucolors[i][1],e.message.text.downcase.split(' '))
      end
      crack_orbs(bot,event,e,e.user.id,l)
    end
  end
  return nil
end

def crack_orbs(bot,event,e,user,list) # used by the `summon` command to wait for a reply
  summons=0
  five_focus=false
  five_star=false
  trucolors=[]
  bnr=$banner[3].map{|q| q}
  str=''
  for i in 0...5
    if list.include?(bnr[i][1].weapon_color) || list.include?(bnr[i][3])
      str="#{str}\nOrb ##{bnr[i][3]} contained a #{bnr[i][0]} **#{bnr[i][1].name}#{bnr[i][1].emotes(bot,false)}** (*#{bnr[i][2]}*)"
      summons+=1
      five_star=true if bnr[i][4]>4
      five_focus=true if bnr[i][4]>4 && bnr[i][0].include?('p10')
    end
  end
  str="#{str}\n\nIn this current summoning session, you fired Breidablik #{summons} time#{'s' unless summons==1}, expending #{[0,5,9,13,17,20][summons]} orbs."
  metadata_load()
  $summon_rate[0]+=summons
  $summon_rate[1]+=[0,5,9,13,17,20][summons]
  str="#{str}\nSince the last 5\* summons, Breidablik has been fired #{$summon_rate[0]} time#{'s' unless $summon_rate[0]==1} and #{$summon_rate[1]} orbs have been expended since the last focus summon."
  if five_focus
    $summon_rate=[0,0,$summon_rate[2]]
    $summon_rate[2]=($summon_rate[2]+1)%3+3
  elsif five_star && $summon_rate[0]>40
    $summon_rate[0]-=20
  elsif five_star
    $summon_rate[0]/=2
  end
  metadata_save()
  $banner=[]
  e.respond str
end

def multi_summon(bot,event,e,user,list,str='',wheel=0,srate=nil,bnr=nil,w2=nil)
  srate=$summon_rate.map{|q| q} if srate.nil?
  bnr=$banner[4].clone if $banner.length>4 && bnr.nil?
  w2=$banner[3].map{|q| q} if $banner.length>3 && w2.nil?
  summons=0
  five_focus=false
  five_star=false
  trucolors=[]
  for i in 0...list.length
    trucolors.push('Red') if ['red','reds','all'].include?(list[i].downcase)
    trucolors.push('Blue') if ['blue','blues','all'].include?(list[i].downcase)
    trucolors.push('Green') if ['green','greens','all'].include?(list[i].downcase)
    trucolors.push('Colorless') if ['colorless','colourless','clear','clears','all'].include?(list[i].downcase)
  end
  trucolors=['Red','Blue','Green','Colorless'] if trucolors.length<=0
  wheel+=1
  str2="__**Wheel ##{wheel}**__"
  r2=w2.reject{|q| !trucolors.include?(q[1].weapon_color)}
  if r2.length<=0
    str2="#{str2} - No target colors"
    r2=[w2[3]]
  end
  for i in 0...r2.length
    str2="#{str2}\nOrb ##{r2[i][3]} contains a **#{r2[i][0]} #{r2[i][1].name}**#{r2[i][1].emotes(bot,false)} (*#{r2[i][2]}*)"
  end
  str=extend_message(str,str2,event,2)
  str2="In this current summoning session, you fired Breidablik #{r2.length} time#{'s' unless r2.length==1}, expending #{[0,5,9,13,17,20][r2.length]} orbs."
  str2="#{str2}\nSince the last 5\* summons, Breidablik has been fired #{srate[0]+r2.length} time#{"s" unless srate[0]+r2.length==1}, and #{srate[1]+[0,5,9,13,17,20][r2.length]} orbs have been expended since the last focus unit."
  srate[0]+=r2.length
  srate[1]+=[0,5,9,13,17,20][r2.length]
  if r2.reject{|q| q[4]<5 || !q[0].include?('p10')}.length>0
    five_focus=true
    srate=[0,0,srate[2]]
    srate[2]=(srate[2]+1)%3+3
  elsif r2.reject{|q| q[4]<5}.length>0
    if srate[0]<40
      srate[0]/=2
    else
      srate[0]-=20
    end
  end
  spark=false
  spark=true if srate[0]>=40
  spark=false if five_star
  spark=false if !bnr.tags.include?('NewUnits')
  spark=false if bnr.tags.include?('Seasonal')
  spark=false if bnr.start_date.nil? || bnr.start_date[2]<2020
  spark=false if bnr.start_date.nil? || (bnr.start_date[2]==2020 && bnr.start_date[1]<2)
  str2="#{str2}\nBecause Breidablik has been fired #{srate[0]} times, you are now given the option of any focus unit on this banner.  (Not included in this sim.)" if spark
  str=extend_message(str,str2,event,2)
  event.respond str
  if spark || five_focus
    $banner=[]
    return nil
  end
  x=bnr.calc_pity(srate[0])
  str2="__**Summon Rates**__"
  if x[0]>0
    str2="#{str2}\n6<:Icon_Rarity_6p10:491487784822112256> Focus:  #{'%.2f' % x[0]}%"
    str2="#{str2}\nOther 6<:Icon_Rarity_6:491487784650145812>:  #{'%.2f' % x[1]}%" unless x[1]<=0
  elsif x[1]>0
    str2="#{str2}\n6<:Icon_Rarity_6:491487784650145812> Unit:  #{'%.2f' % x[1]}%"
  end
  if x[2]>0
    str2="#{str2}\n5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % x[2]}%"
    str2="#{str2}\nOther 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % x[3]}%" unless x[3]<=0
  elsif x[3]>0
    str2="#{str2}\n5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % x[3]}%"
  end
  if x[4]>0
    str2="#{str2}\n4<:Icon_Rarity_4p10:448272714210476033> Focus:  #{'%.2f' % (x[4])}%"
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Special:  #{'%.2f' % x[5]}%" unless x[5]<=0
    str2="#{str2}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % x[6]}%" unless x[6]<=0
  elsif x[5]>0
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Special:  #{'%.2f' % x[5]}%" unless x[5]<=0
    str2="#{str2}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % x[6]}%" unless x[6]<=0
  elsif x[6]>0
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Unit:  #{'%.2f' % x[6]}%"
  end
  if x[7]>0
    str2="#{str2}\n3<:Icon_Rarity_3p10:448294378293952513> Focus:  #{'%.2f' % (x[7])}%"
    str2="#{str2}\nOther 3<:Icon_Rarity_3:448266417934958592>:  #{'%.2f' % x[8]}%" unless x[8]<=0
  elsif x[8]>0
    str2="#{str2}\n3<:Icon_Rarity_3:448266417934958592> Unit:  #{'%.2f' % x[8]}%"
  end
  if x[9]>0
    str2="#{str2}\n2<:Icon_Rarity_2p10:448294378205872130> Focus:  #{'%.2f' % (x[9])}%"
    str2="#{str2}\nOther 2<:Icon_Rarity_2:448266417872044032>:  #{'%.2f' % x[10]}%" unless x[10]<=0
  elsif x[10]>0
    str2="#{str2}\n2<:Icon_Rarity_2:448266417872044032> Unit:  #{'%.2f' % x[10]}%"
  end
  if x[11]>0
    str2="#{str2}\n1<:Icon_Rarity_1p10:448294377878716417> Focus:  #{'%.2f' % (x[11])}%"
    str2="#{str2}\nOther 1<:Icon_Rarity_1:448266417481973781>:  #{'%.2f' % x[12]}%" unless x[12]<=0
  elsif x[12]>0
    str2="#{str2}\n1<:Icon_Rarity_1:448266417481973781> Unit:  #{'%.2f' % x[12]}%"
  end
  if srate[0]>=120 && srate[2]%3==0
    str2=str2.gsub('4<:Icon_Rarity_4p10:448272714210476033>',"~~4\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('4<:Icon_Rarity_4:448266418459377684>',"~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('3<:Icon_Rarity_3p10:448294378293952513>',"~~3\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('3<:Icon_Rarity_3:448266417934958592>',"~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('2<:Icon_Rarity_2p10:448294378205872130>',"~~2\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('2<:Icon_Rarity_2:448266417872044032>',"~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('1<:Icon_Rarity_1p10:448294377878716417>',"~~1\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('1<:Icon_Rarity_1:448266417481973781>',"~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
  end
  r=[]
  rar=[6,6,5,5,4,4,4,3,3,2,2,1,1]
  natures=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res','+Def -HP','+Def -Atk',
           '+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral']
  natures2=natures.map{|q| q}
  natures=['Neutral'] if ['TT Units','GHB Units'].include?(bnr.name)
  rarities=['6<:Icon_Rarity_6p10:491487784822112256>','6<:Icon_Rarity_6:491487784650145812>','5<:Icon_Rarity_5p10:448272715099406336>','5<:Icon_Rarity_5:448266417553539104>',
            '4<:Icon_Rarity_4p10:448272714210476033>','~~4\\*S~~ 5<:Icon_Rarity_5:448266417553539104>','4<:Icon_Rarity_4:448266418459377684>','3<:Icon_Rarity_3:448266417934958592>F',
            '3<:Icon_Rarity_3:448266417934958592>','2<:Icon_Rarity_2:448266417872044032>F','2<:Icon_Rarity_2:448266417872044032>','1<:Icon_Rarity_1:448266417481973781>F',
            '1<:Icon_Rarity_1:448266417481973781>']
  superrarities=['6<:Icon_Rarity_6p10:491487784822112256>','6<:Icon_Rarity_6:491487784650145812>','5<:Icon_Rarity_5p10:448272715099406336>','5<:Icon_Rarity_5:448266417553539104>',
                 '~~4\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>','~~4\\*(s)~~ 5<:Icon_Rarity_5:448266417553539104>','~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>',
                 '~~3\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>','~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>','~~2\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>',
                 '~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>','~~1\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>','~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>']
  for i in 0...5
    k=rand(1000000)
    united=false
    for i2 in 0...x.length
      if united || x[i2]<=0
      elsif k<(x[0,i2+1].inject(0){|sum,q| sum+q}*10000).to_i
        united=true
        hx=bnr.full_banner[i2].sample
        rx=rarities[i2]
        rx=superrarities[i2] if $summon_rate[0]>=120 && $summon_rate[2]%3==0
        nr=natures.sample
        nr=natures2.sample if i2%2==1
        m=rar[i2]
      end
    end
    unless united # && !hx.nil?
      hx=bnr.full_banner[5].sample
      rx='4<:Icon_Rarity_4:448266418459377684>'
      rx='~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if $summon_rate[0]>=120 && $summon_rate[2]%3==0
      nr=natures2.sample
      m=4
    end
    r.push([rx,hx,nr,i+1,m])
  end
  multi_summon(bot,event,e,user,list,str2,wheel,srate,bnr,r)
end

def skill_data(legal_skills,all_skills,event,mode=0)
  str2="**There are #{longFormattedNumber(legal_skills.length)}#{" (#{longFormattedNumber(all_skills.length)})" unless legal_skills.length==all_skills.length} #{['skills','skill lines','skill trees'][mode]}, including:**"
  l=legal_skills.reject{|q| !q.type.include?('Weapon')}
  a=all_skills.reject{|q| !q.type.include?('Weapon')}
  fmt=''
  if safe_to_spam?(event) || event.message.text.downcase.split(' ').include?('all')
    fmt='__'
    l2=l.reject{|q| !has_any?(q.restrictions,['Sword Users Only','Lance Users Only','Axe Users Only'])}
    a2=a.reject{|q| !has_any?(q.restrictions,['Sword Users Only','Lance Users Only','Axe Users Only'])}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Sword Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Sword Users Only')}
    m2="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Lance Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Lance Users Only')}
    m3="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Axe Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Axe Users Only')}
    m4="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Gold_Blade:774013609184460860> #{m} blades   <:Red_Blade:443172811830198282> #{m2} swords, <:Blue_Blade:467112472768151562> #{m3} lances, <:Green_Blade:467122927230386207> #{m4} axes"
    l2=l.reject{|q| !has_any?(q.restrictions,['Red Tome Users Only','Blue Tome Users Only','Green Tome Users Only','Colorless Tome Users Only'])}
    a2=a.reject{|q| !has_any?(q.restrictions,['Red Tome Users Only','Blue Tome Users Only','Green Tome Users Only','Colorless Tome Users Only'])}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Red Tome Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Red Tome Users Only')}
    m2="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}
    m3="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Green Tome Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Green Tome Users Only')}
    m4="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}
    m5="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Gold_Tome:774013610736484353> #{m} tomes   <:Red_Tome:443172811826003968> #{m2} red, <:Blue_Tome:467112472394858508> #{m3} blue, <:Green_Tome:467122927666593822> #{m4} green, <:Colorless_Tome:443692133317345290> #{m5} colorless"
    l2=l.reject{|q| !q.restrictions.include?('Dragons Only')}
    a2=a.reject{|q| !q.restrictions.include?('Dragons Only')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Gold_Dragon:774013610908581948> #{m} dragonstones"
    l2=l.reject{|q| !q.restrictions.include?('Bow Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Bow Users Only')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Gold_Bow:774013609389981726> #{m} bows"
    l2=l.reject{|q| !q.restrictions.include?('Dagger Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Dagger Users Only')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Gold_Dagger:774013610862968833> #{m} daggers"
    l2=l.reject{|q| !q.restrictions.include?('Staff Users Only')}
    a2=a.reject{|q| !q.restrictions.include?('Staff Users Only')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Gold_Staff:774013610988797953> #{m} damaging staves"
    l=l.reject{|q| !q.restrictions.include?('Beasts Only')}
    a=a.reject{|q| !q.restrictions.include?('Beasts Only')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    l2=l.reject{|q| !q.restrictions.include?('Infantry Only')}
    a2=a.reject{|q| !q.restrictions.include?('Infantry Only')}
    m2="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Cavalry Only')}
    a2=a.reject{|q| !q.restrictions.include?('Cavalry Only')}
    m3="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Fliers Only')}
    a2=a.reject{|q| !q.restrictions.include?('Fliers Only')}
    m4="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    l2=l.reject{|q| !q.restrictions.include?('Armor Only')}
    a2=a.reject{|q| !q.restrictions.include?('Armor Only')}
    m5="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Gold_Beast:774013608191459329> __#{m} beast weapons__   <:Icon_Move_Infantry:443331187579289601> #{m2} infantry, <:Icon_Move_Cavalry:443331186530451466> #{m3} cavalry, <:Icon_Move_Flier:443331186698354698> #{m4} flying, <:Icon_Move_Armor:443331186316673025> #{m5} armored"
    l=legal_skills.reject{|q| !q.type.include?('Assist')}
    a=all_skills.reject{|q| !q.type.include?('Assist')}
    l2=l.reject{|q| !q.tags.include?('Rally')}
    a2=a.reject{|q| !q.tags.include?('Rally')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Assist_Rally:454462054619807747> #{m} rally assists"
    l2=l.reject{|q| !q.tags.include?('Move') || q.tags.include?('Music') || q.tags.include?('Staff')}
    a2=a.reject{|q| !q.tags.include?('Move') || q.tags.include?('Music') || q.tags.include?('Staff')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Assist_Move:454462055479508993> #{m} movement assists"
    l2=l.reject{|q| !q.tags.include?('Music')}
    a2=a.reject{|q| !q.tags.include?('Music')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Assist_Music:454462054959415296> #{m} musical assists"
    l2=l.reject{|q| !q.tags.include?('Health') || q.tags.include?('Staff')}
    a2=a.reject{|q| !q.tags.include?('Health') || q.tags.include?('Staff')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Assist_Health:454462054636584981> #{m} health-based assists"
    l2=l.reject{|q| !q.tags.include?('Staff')}
    a2=a.reject{|q| !q.tags.include?('Staff')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Assist_Staff:454451496831025162> #{m} healing staves"
    l2=l.reject{|q| has_any?(q.tags,['Rally','Move','Music','Health','Staff'])}
    a2=a.reject{|q| has_any?(q.tags,['Rally','Move','Music','Health','Staff'])}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n__<:Assist_Unknown:454451496482897921> #{m} misc. assists__"
    l=legal_skills.reject{|q| !q.type.include?('Special')}
    a=all_skills.reject{|q| !q.type.include?('Special')}
    l2=l.reject{|q| !q.tags.include?('Offensive')}
    a2=a.reject{|q| !q.tags.include?('Offensive')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Special_Offensive:454460020793278475> #{m} offensive specials"
    l2=l.reject{|q| !q.tags.include?('Defensive')}
    a2=a.reject{|q| !q.tags.include?('Defensive')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Special_Defensive:454460020591951884> #{m} defensive specials"
    l2=l.reject{|q| !q.tags.include?('AoE')}
    a2=a.reject{|q| !q.tags.include?('AoE')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Special_AoE:454460021665693696> #{m} area-of-effect specials"
    l2=l.reject{|q| !q.tags.include?('Staff')}
    a2=a.reject{|q| !q.tags.include?('Staff')}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n<:Special_Healer:454451451805040640> #{m} healer specials"
    l2=l.reject{|q| has_any?(q.tags,['Offensive','Defensive','AoE','Staff'])}
    a2=a.reject{|q| has_any?(q.tags,['Offensive','Defensive','AoE','Staff'])}
    m="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
    str2="#{str2}\n__<:Special_Unknown:454451451603976192> #{m} misc. specials__"
  else
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Skill_Weapon:444078171114045450> #{m} Weapons"
    l=legal_skills.reject{|q| !q.type.include?('Assist')}
    a=all_skills.reject{|q| !q.type.include?('Assist')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Skill_Assist:444078171025965066> #{m} Assists"
    l=legal_skills.reject{|q| !q.type.include?('Special')}
    a=all_skills.reject{|q| !q.type.include?('Special')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Skill_Special:444078170665254929> #{m} Specials"
  end
  l=legal_skills.reject{|q| !q.type.include?('Passive(A)')}
  a=all_skills.reject{|q| !q.type.include?('Passive(A)')}
  m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
  str2="#{str2}\n<:Passive_A:443677024192823327> #{m} A Passives"
  l=legal_skills.reject{|q| !q.type.include?('Passive(B)')}
  a=all_skills.reject{|q| !q.type.include?('Passive(B)')}
  m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
  str2="#{str2}\n<:Passive_B:443677023257493506> #{m} B Passives"
  l=legal_skills.reject{|q| !q.type.include?('Passive(C)')}
  a=all_skills.reject{|q| !q.type.include?('Passive(C)')}
  m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
  str2="#{str2}\n<:Passive_C:443677023555026954> #{m} C Passives"
  l=legal_skills.reject{|q| !has_any?(q.tags,['Passive(S)','Seal'])}
  a=all_skills.reject{|q| !has_any?(q.tags,['Passive(S)','Seal'])}
  m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
  str2="#{str2}\n<:Passive_S:443677023626330122> #{m} Seal Passives"
  l=legal_skills.reject{|q| !q.type.include?('Passive(W)')}
  a=all_skills.reject{|q| !q.type.include?('Passive(W)')}
  m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
  str2="#{str2}\n<:Passive_W:443677023706152960> #{fmt}#{m} Weapon Passives#{fmt}"
  l=legal_skills.reject{|q| !q.type.include?('Duo')}
  a=all_skills.reject{|q| !q.type.include?('Duo')}
  m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
  str2="#{str2}\n<:Hero_Duo:631431055420948480> #{m} Duo skills"
  l=legal_skills.reject{|q| !q.type.include?('Harmonic')}
  a=all_skills.reject{|q| !q.type.include?('Harmonic')}
  m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
  str2="#{str2}\n<:Hero_Harmonic:722436762248413234> #{m} Harmonic Skills"
  str2=str2[1,str2.length-1] if str2[0,1]=="\n"
  str2=str2[2,str2.length-2] if str2[0,2]=="\n"
  return str2
end

def disp_all_prfs(event,bot)
  if !safe_to_spam?(event)
    event.respond "There is a lot of data being displayed.  Please use this command in PM."
    return nil
  end
  event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil
  data_load(['unit','skill'])
  sklz=$skills.reject{|q| ['Falchion','Ragnarok+','Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(q.name) || !q.type.include?('Weapon') || q.exclusivity.nil? || !q.isPostable?(event)}.map{|q| q.clone}
  untz=$units.map{|q| q}
  for i in 0...sklz.length
    x=sklz[i].exclusivity.reject{|q| untz.find_index{|q2| q2.name==q}.nil? || !untz[untz.find_index{|q2| q2.name==q}].isPostable?(event)}
    x=x.map{|q| untz[untz.find_index{|q2| q2.name==q}].postName}
    sklz[i].name="#{sklz[i].postName} \u2192 #{x.join(', ')}"
  end
  k=sklz.reject{|q| q.prerequisite.nil? || q.prerequisite.length<=0 || q.prerequisite=='-'}
  f=[['<:Red_Blade:443172811830198282> Swords',k.reject{|q| !q.restrictions.include?('Sword Users Only')}.map{|q| q.name}],
     ['<:Red_Tome:443172811826003968> Red Tomes',k.reject{|q| !q.restrictions.include?('Red Tome Users Only')}.map{|q| q.name}],
     ['<:Blue_Blade:467112472768151562> Lances',k.reject{|q| !q.restrictions.include?('Lance Users Only')}.map{|q| q.name}],
     ['<:Blue_Tome:467112472394858508> Blue Tomes',k.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}.map{|q| q.name}],
     ['<:Green_Blade:467122927230386207> Axes',k.reject{|q| !q.restrictions.include?('Axe Users Only')}.map{|q| q.name}],
     ['<:Green_Tome:467122927666593822> Green Tomes',k.reject{|q| !q.restrictions.include?('Green Tome Users Only')}.map{|q| q.name}],
     ['<:Colorless_Tome:443692133317345290> Colorless Tomes',k.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}.map{|q| q.name}],
     ['<:Gold_Dragon:774013610908581948> Dragon Breaths',k.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.name}],
     ['<:Gold_Beast:774013608191459329> Beast Damage',k.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.name}],
     ['<:Gold_Bow:774013609389981726> Bows',k.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.name}],
     ['<:Gold_Dagger:774013610862968833> Daggers',k.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.name}],
     ['<:Colorless_Staff:443692132323295243> Damaging Staves',k.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.name}]]
  f=f.reject{|q| q[1].nil? || q[1].length<=0}
  if f.map{|q| "__*#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
    str="__**Standard PRF Weapons**__"
    for i in 0...f.length
      str=extend_message(str,"__*#{f[i][0]}*__",event,2)
      for i2 in 0...f[i][1].length
        str=extend_message(str,f[i][1][i2],event)
      end
    end
    event.respond str
  else
    create_embed(event,'__**Standard PRF Weapons**__','',0xF4728C,nil,nil,f.map{|q| [q[0],q[1].join("\n")]})
  end
  k=sklz.reject{|q| !q.prerequisite.nil? && q.prerequisite.length>0 && q.prerequisite != '-'}
  f=[['<:Red_Blade:443172811830198282> Swords',k.reject{|q| !q.restrictions.include?('Sword Users Only')}.map{|q| q.name}],
     ['<:Red_Tome:443172811826003968> Red Tomes',k.reject{|q| !q.restrictions.include?('Red Tome Users Only')}.map{|q| q.name}],
     ['<:Blue_Blade:467112472768151562> Lances',k.reject{|q| !q.restrictions.include?('Lance Users Only')}.map{|q| q.name}],
     ['<:Blue_Tome:467112472394858508> Blue Tomes',k.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}.map{|q| q.name}],
     ['<:Green_Blade:467122927230386207> Axes',k.reject{|q| !q.restrictions.include?('Axe Users Only')}.map{|q| q.name}],
     ['<:Green_Tome:467122927666593822> Green Tomes',k.reject{|q| !q.restrictions.include?('Green Tome Users Only')}.map{|q| q.name}],
     ['<:Colorless_Tome:443692133317345290> Colorless Tomes',k.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}.map{|q| q.name}],
     ['<:Gold_Dragon:774013610908581948> Dragon Breaths',k.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.name}],
     ['<:Gold_Beast:774013608191459329> Beast Damage',k.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.name}],
     ['<:Gold_Bow:774013609389981726> Bows',k.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.name}],
     ['<:Gold_Dagger:774013610862968833> Daggers',k.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.name}],
     ['<:Colorless_Staff:443692132323295243> Damaging Staves',k.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.name}]]
  f=f.reject{|q| q[1].nil? || q[1].length<=0}
  if f.map{|q| "__*#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
    str="__**Retro-PRF Weapons**__"
    for i in 0...f.length
      str=extend_message(str,"__*#{f[i][0]}*__",event,2)
      for i2 in 0...f[i][1].length
        str=extend_message(str,f[i][1][i2],event)
      end
    end
    event.respond str
  else
    create_embed(event,'__**Retro-PRF Weapons**__','',0xF4728C,nil,nil,f.map{|q| [q[0],q[1].join("\n")]})
  end
  ast=$skills.reject{|q| !q.type.include?('Assist') || q.exclusivity.nil? || !q.isPostable?(event)}.map{|q| q.clone}
  for i in 0...ast.length
    x=ast[i].exclusivity.reject{|q| untz.find_index{|q2| q2.name==q}.nil? || !untz[untz.find_index{|q2| q2.name==q}].isPostable?(event)}
    x=x.map{|q| untz[untz.find_index{|q2| q2.name==q}].postName}
    ast[i].name="#{ast[i].postName} \u2192 #{x.join(', ')}"
  end
  spec=$skills.reject{|q| !q.type.include?('Special') || q.exclusivity.nil? || !q.isPostable?(event)}.map{|q| q.clone}
  for i in 0...spec.length
    x=spec[i].exclusivity.reject{|q| untz.find_index{|q2| q2.name==q}.nil? || !untz[untz.find_index{|q2| q2.name==q}].isPostable?(event)}
    x=x.map{|q| untz[untz.find_index{|q2| q2.name==q}].postName}
    spec[i].name="#{spec[i].postName} \u2192 #{x.join(', ')}"
  end
  if ast.map{|q| q.name}.join("\n").length+spec.map{|q| q.name}.join("\n").length>1800
    if ast.map{|q| q.name}.join("\n").length>1800
      str='<:Skill_Assist:444078171025965066>__**PRF Assists**__'
      for i in 0...ast.length
        str=extend_message(str,ast[i].name,event)
      end
      event.respond str
    else
      create_embed(event,'<:Skill_Assist:444078171025965066>__**PRF Assists**__','',0x07DFBB,nil,nil,triple_finish(ast.map{|q| q.name},true))
    end
    if spec.map{|q| q.name}.join("\n").length>1800
      str='<:Skill_Special:444078170665254929>__**PRF Specials**__'
      for i in 0...spec.length
        str=extend_message(str,spec[i].name,event)
      end
      event.respond str
    else
      create_embed(event,'<:Skill_Special:444078170665254929>__**PRF Specials**__','',0xF67EF8,nil,nil,triple_finish(spec.map{|q| q.name},true))
    end
  else
    create_embed(event,'__**PRF Assists and Specials**__','',0x7FAFDA,nil,nil,[['<:Skill_Assist:444078171025965066> Assists',ast.map{|q| q.name}.join("\n")],['<:Skill_Special:444078170665254929> Specials',spec.map{|q| q.name}.join("\n")]])
  end
  sklz=$skills.reject{|q| !q.isPassive? || q.exclusivity.nil? || !q.isPostable?(event) || q.learn.flatten.length<=0}.map{|q| q.clone}
  for i in 0...sklz.length
    x=sklz[i].exclusivity.reject{|q| untz.find_index{|q2| q2.name==q}.nil? || !untz[untz.find_index{|q2| q2.name==q}].isPostable?(event)}
    x=x.map{|q| untz[untz.find_index{|q2| q2.name==q}].postName}
    sklz[i].name="#{sklz[i].postName} \u2192 #{x.join(', ')}"
  end
  f=[['<:Passive_A:443677024192823327> A Passives',sklz.reject{|q| !q.type.include?('Passive(A)')}.map{|q| q.name},0xED888A,'A'],
     ['<:Passive_B:443677023257493506> B Passives',sklz.reject{|q| !q.type.include?('Passive(B)')}.map{|q| q.name},0x5CC4EF,'B'],
     ['<:Passive_C:443677023555026954> C Passives',sklz.reject{|q| !q.type.include?('Passive(C)')}.map{|q| q.name},0x5FED96,'C']]
  f=f.reject{|q| q[1].nil? || q[1].length<=0}
  if (f.map{|q| "__*#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800 && f.reject{|q| "__**#{q[0]}**__\n#{q[1].join("\n")}".length>=1800}.length>0) || Shardizard==4
    for i in 0...f.length
      if "__**#{f[i][0]}**__\n#{f[i][1].join("\n")}".length>=1800
        str="__**PRF #{f[i][3]} Passives**__"
        for i2 in 0...f[i][1].length
          str=extend_message(str,f[i][1][i2],event)
        end
        event.respond str
      else
        create_embed(event,"__**PRF #{f[i][3]} Passives**__",'',f[i][2],nil,nil,triple_finish(f[i][1],true))
      end
    end
  elsif f.map{|q| "__*#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
    str="__**PRF Passives**__"
    for i in 0...f.length
      str=extend_message(str,"__*#{f[i][0]}*__",event,2)
      for i2 in 0...f[i][1].length
        str=extend_message(str,f[i][1][i2],event)
      end
    end
    event.respond str
  else
    create_embed(event,'__**PRF Passives**__','',0xFDDC7E,nil,nil,f.map{|q| [q[0],q[1].join("\n")]})
  end
  data_load()
  return nil
end

def disp_all_refines(event,bot,effect=false)
  if !safe_to_spam?(event)
    event.respond "There is a lot of data being displayed.  Please use this command in PM."
    return nil
  end
  effect=true if event.message.text.downcase.split(' ').include?('effect')
  event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil
  data_load(['skill'])
  stones=[]
  dew=[]
  if effect
    sklz=$skills.reject{|q| ['Falchion','Ragnarok+','Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(q.name) || q.name.include?('Breidablik') || !q.type.include?('Weapon') || !q.isPostable?(event) || q.refine.nil? || q.refinement_name.nil?}
    for i in 0...sklz.length
      sklz[i].name="#{sklz[i].postName} \u2192 #{'~~' unless sklz[i].fake.nil?}#{sklz[i].refinement_name.fullName}#{'~~' unless sklz[i].fake.nil?}"
    end
    dew=sklz.reject{|q| q.exclusivity.nil?}
    stone=sklz.reject{|q| !q.exclusivity.nil?}
    if stones.map{|q| q.name}.join("\n").length+dew.map{|q| q.name}.join("\n").length>1900
      f=[['<:Red_Blade:443172811830198282> Swords',dew.reject{|q| !q.restrictions.include?('Sword Users Only')}.map{|q| q.name}],
         ['<:Red_Tome:443172811826003968> Red Tomes',dew.reject{|q| !q.restrictions.include?('Red Tome Users Only')}.map{|q| q.name}],
         ['<:Blue_Blade:467112472768151562> Lances',dew.reject{|q| !q.restrictions.include?('Lance Users Only')}.map{|q| q.name}],
         ['<:Blue_Tome:467112472394858508> Blue Tomes',dew.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}.map{|q| q.name}],
         ['<:Green_Blade:467122927230386207> Axes',dew.reject{|q| !q.restrictions.include?('Axe Users Only')}.map{|q| q.name}],
         ['<:Green_Tome:467122927666593822> Green Tomes',dew.reject{|q| !q.restrictions.include?('Green Tome Users Only')}.map{|q| q.name}],
         ['<:Colorless_Tome:443692133317345290> Colorless Tomes',dew.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}.map{|q| q.name}],
         ['<:Gold_Dragon:774013610908581948> Dragon Breaths',dew.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.name}],
         ['<:Gold_Beast:774013608191459329> Beast Damage',dew.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.name}],
         ['<:Gold_Bow:774013609389981726> Bows',dew.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.name}],
         ['<:Gold_Dagger:774013610862968833> Daggers',dew.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.name}],
         ['<:Colorless_Staff:443692132323295243> Damaging Staves',dew.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.name}]]
      f=f.reject{|q| q[1].nil? || q[1].length<=0}
      if f.map{|q| "__^#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
        msg='__**Weapon Refines with Effect Modes: Divine Dew <:Divine_Dew:453618312434417691>**__'
        for i in 0...f.length
          msg=extend_message(msg,"*#{f[i][0]}:* #{f[i][1].join(', ')}",event) if f[i][1].length>0
        end
        event.respond msg
      else
        create_embed(event,'__**Weapon Refines with Effect Modes: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x9BFFFF,nil,nil,f.map{|q| [q[0],q[1].join("\n")]},3)
      end
      f=[['<:Red_Blade:443172811830198282> Swords',stone.reject{|q| !q.restrictions.include?('Sword Users Only')}.map{|q| q.name}],
         ['<:Red_Tome:443172811826003968> Red Tomes',stone.reject{|q| !q.restrictions.include?('Red Tome Users Only')}.map{|q| q.name}],
         ['<:Blue_Blade:467112472768151562> Lances',stone.reject{|q| !q.restrictions.include?('Lance Users Only')}.map{|q| q.name}],
         ['<:Blue_Tome:467112472394858508> Blue Tomes',stone.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}.map{|q| q.name}],
         ['<:Green_Blade:467122927230386207> Axes',stone.reject{|q| !q.restrictions.include?('Axe Users Only')}.map{|q| q.name}],
         ['<:Green_Tome:467122927666593822> Green Tomes',stone.reject{|q| !q.restrictions.include?('Green Tome Users Only')}.map{|q| q.name}],
         ['<:Colorless_Tome:443692133317345290> Colorless Tomes',stone.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}.map{|q| q.name}],
         ['<:Gold_Dragon:774013610908581948> Dragon Breaths',stone.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.name}],
         ['<:Gold_Beast:774013608191459329> Beast Damage',stone.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.name}],
         ['<:Gold_Bow:774013609389981726> Bows',stone.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.name}],
         ['<:Gold_Dagger:774013610862968833> Daggers',stone.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.name}],
         ['<:Colorless_Staff:443692132323295243> Damaging Staves',stone.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.name}]]
      f=f.reject{|q| q[1].nil? || q[1].length<=0}
      if f.map{|q| "__^#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
        msg='__**Weapon Refines with Effect Modes: Divine Dew <:Divine_Dew:453618312434417691>**__'
        for i in 0...k.length
          msg=extend_message(msg,"*#{f[i][0]}:* #{f[i][1].join(', ')}",event) if f[i][1].length>0
        end
        event.respond msg
      else
        create_embed(event,'__**Weapon Refines with Effect Modes: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x688C68,nil,nil,f.map{|q| [q[0],q[1].join("\n")]},3)
      end
    else
      dew=dew.map{|q| q.name}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')}
      stone=stone.map{|q| q.name}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')}
      dew2=dew[dew.length/2+dew.length%2,dew.length/2].join("\n")
      dew=dew[0,dew.length/2+3*dew.length%2].join("\n")
      create_embed(event,'__**Weapon Refines with Effect Modes**__','',0x688C68,nil,nil,[['<:Divine_Dew:453618312434417691> Divine Dew',dew],['<:Divine_Dew:453618312434417691> Divine Dew',dew2],['<:Refining_Stone:453618312165720086> Refining Stones',stone.join("\n"),1]],3)
    end
    return nil
  end
  data_load()
  angery=$skills.reject{|q| ['Falchion','Ragnarok+','Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(q.name) || q.name.include?('Breidablik') || !q.type.include?('Weapon') || !q.prevos.nil? || !q.evolutions.nil? || q.exclusivity.nil? || q.exclusivity.reject{|q2| q.learn.flatten.include?(q2)}.length<=0}
  x=angery.map{|q| "#{q.postName}"}
  sklz=$skills.reject{|q| ['Falchion','Ragnarok+','Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(q.name) || q.name.include?('Breidablik') || q.evolutions.nil?}
  for i in 0...sklz.length
    sklz[i].name="#{'~~' unless sklz[i].fake.nil?}#{sklz[i].name} \u2192 #{sklz[i].evolutions.join(', ')}#{'~~' unless sklz[i].fake.nil?}"
  end
  dew=sklz.reject{|q| q.exclusivity.nil?}
  stone=sklz.reject{|q| !q.exclusivity.nil?}
  if stones.map{|q| q.name}.join("\n").length+dew.map{|q| q.name}.join("\n").length>1900
    f=[['<:Red_Blade:443172811830198282> Swords',dew.reject{|q| !q.restrictions.include?('Sword Users Only')}.map{|q| q.name}],
       ['<:Red_Tome:443172811826003968> Red Tomes',dew.reject{|q| !q.restrictions.include?('Red Tome Users Only')}.map{|q| q.name}],
       ['<:Blue_Blade:467112472768151562> Lances',dew.reject{|q| !q.restrictions.include?('Lance Users Only')}.map{|q| q.name}],
       ['<:Blue_Tome:467112472394858508> Blue Tomes',dew.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}.map{|q| q.name}],
       ['<:Green_Blade:467122927230386207> Axes',dew.reject{|q| !q.restrictions.include?('Axe Users Only')}.map{|q| q.name}],
       ['<:Green_Tome:467122927666593822> Green Tomes',dew.reject{|q| !q.restrictions.include?('Green Tome Users Only')}.map{|q| q.name}],
       ['<:Colorless_Tome:443692133317345290> Colorless Tomes',dew.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}.map{|q| q.name}],
       ['<:Gold_Dragon:774013610908581948> Dragon Breaths',dew.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.name}],
       ['<:Gold_Beast:774013608191459329> Beast Damage',dew.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.name}],
       ['<:Gold_Bow:774013609389981726> Bows',dew.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.name}],
       ['<:Gold_Dagger:774013610862968833> Daggers',dew.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.name}],
       ['<:Colorless_Staff:443692132323295243> Damaging Staves',dew.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.name}]]
    f=f.reject{|q| q[1].nil? || q[1].length<=0}
    if f.map{|q| "__^#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
      msg='__**Weapon Evolution: Divine Dew <:Divine_Dew:453618312434417691>**__'
      for i in 0...f.length
        msg=extend_message(msg,"*#{f[i][0]}:* #{f[i][1].join(', ')}",event) if f[i][1].length>0
      end
      event.respond msg
    else
      create_embed(event,'__**Weapon Evolution: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x9BFFFF,nil,nil,f.map{|q| [q[0],q[1].join("\n")]},3)
    end
    f=[['<:Red_Blade:443172811830198282> Swords',stone.reject{|q| !q.restrictions.include?('Sword Users Only')}.map{|q| q.name}],
       ['<:Red_Tome:443172811826003968> Red Tomes',stone.reject{|q| !q.restrictions.include?('Red Tome Users Only')}.map{|q| q.name}],
       ['<:Blue_Blade:467112472768151562> Lances',stone.reject{|q| !q.restrictions.include?('Lance Users Only')}.map{|q| q.name}],
       ['<:Blue_Tome:467112472394858508> Blue Tomes',stone.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}.map{|q| q.name}],
       ['<:Green_Blade:467122927230386207> Axes',stone.reject{|q| !q.restrictions.include?('Axe Users Only')}.map{|q| q.name}],
       ['<:Green_Tome:467122927666593822> Green Tomes',stone.reject{|q| !q.restrictions.include?('Green Tome Users Only')}.map{|q| q.name}],
       ['<:Colorless_Tome:443692133317345290> Colorless Tomes',stone.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}.map{|q| q.name}],
       ['<:Gold_Dragon:774013610908581948> Dragon Breaths',stone.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.name}],
       ['<:Gold_Beast:774013608191459329> Beast Damage',stone.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.name}],
       ['<:Gold_Bow:774013609389981726> Bows',stone.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.name}],
       ['<:Gold_Dagger:774013610862968833> Daggers',stone.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.name}],
       ['<:Colorless_Staff:443692132323295243> Damaging Staves',stone.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.name}]]
    f=f.reject{|q| q[1].nil? || q[1].length<=0}
    if f.map{|q| "__^#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
      msg='__**Weapon Evolution: Refining Stones <:Refining_Stone:453618312165720086>**__'
      for i in 0...k.length
        msg=extend_message(msg,"*#{f[i][0]}:* #{f[i][1].join(', ')}",event) if f[i][1].length>0
      end
      event.respond msg
    else
      create_embed(event,'__**Weapon Evolution: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x688C68,nil,nil,f.map{|q| [q[0],q[1].join("\n")]},3)
    end
  elsif stones.map{|q| q.name}.join("\n").length+dew.map{|q| q.name}.join("\n").length+x.join("\n").length>1900
    dew=dew.map{|q| q.name}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')}
    stone=stone.map{|q| q.name}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')}
    dew2=dew[dew.length/2+dew.length%2,dew.length/2].join("\n")
    dew=dew[0,dew.length/2+3*dew.length%2].join("\n")
    create_embed(event,'__**Weapon Evolution**__','',0x688C68,nil,nil,[['<:Divine_Dew:453618312434417691> Divine Dew',dew],['<:Divine_Dew:453618312434417691> Divine Dew',dew2],['<:Refining_Stone:453618312165720086> Refining Stones',stone.join("\n"),1]],3)
  else
    create_embed(event,'__**Weapon Evolution**__','',0x688C68,nil,nil,[['<:Divine_Dew:453618312434417691> Divine Dew',dew.map{|q| q.name}.join("\n")],['<:Refining_Stone:453618312165720086> Refining Stones',stone.map{|q| q.name}.join("\n")],["Weapons that *should* be evolutions but aren't",x.join("\n"),1]],3)
  end
  data_load()
  sklz=$skills.reject{|q| ['Falchion','Ragnarok+','Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(q.name) || q.name.include?('Breidablik') || q.refine.nil?}
  dew=sklz.reject{|q| q.exclusivity.nil?}
  stone=sklz.reject{|q| !q.exclusivity.nil?}
  if stones.map{|q| q.postName}.join("\n").length+dew.map{|q| q.postName}.join("\n").length>1900
    f=[['<:Red_Blade:443172811830198282> Swords',dew.reject{|q| !q.restrictions.include?('Sword Users Only')}.map{|q| q.postName}],
       ['<:Red_Tome:443172811826003968> Red Tomes',dew.reject{|q| !q.restrictions.include?('Red Tome Users Only')}.map{|q| q.postName}],
       ['<:Blue_Blade:467112472768151562> Lances',dew.reject{|q| !q.restrictions.include?('Lance Users Only')}.map{|q| q.postName}],
       ['<:Blue_Tome:467112472394858508> Blue Tomes',dew.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}.map{|q| q.postName}],
       ['<:Green_Blade:467122927230386207> Axes',dew.reject{|q| !q.restrictions.include?('Axe Users Only')}.map{|q| q.postName}],
       ['<:Green_Tome:467122927666593822> Green Tomes',dew.reject{|q| !q.restrictions.include?('Green Tome Users Only')}.map{|q| q.postName}],
       ['<:Colorless_Tome:443692133317345290> Colorless Tomes',dew.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}.map{|q| q.postName}],
       ['<:Gold_Dragon:774013610908581948> Dragon Breaths',dew.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.postName}],
       ['<:Gold_Beast:774013608191459329> Beast Damage',dew.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.postName}],
       ['<:Gold_Bow:774013609389981726> Bows',dew.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.postName}],
       ['<:Gold_Dagger:774013610862968833> Daggers',dew.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.postName}],
       ['<:Colorless_Staff:443692132323295243> Damaging Staves',dew.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.postName}]]
    f=f.reject{|q| q[1].nil? || q[1].length<=0}
    if f.map{|q| "__^#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
      msg='__**Weapon Refinement: Divine Dew <:Divine_Dew:453618312434417691>**__'
      for i in 0...f.length
        msg=extend_message(msg,"*#{f[i][0]}:* #{f[i][1].join(', ')}",event) if f[i][1].length>0
      end
      event.respond msg
    else
      create_embed(event,'__**Weapon Refinement: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x9BFFFF,nil,nil,f.map{|q| [q[0],q[1].join("\n")]},3)
    end
    f=[['<:Red_Blade:443172811830198282> Swords',stone.reject{|q| !q.restrictions.include?('Sword Users Only')}.map{|q| q.postName}],
       ['<:Red_Tome:443172811826003968> Red Tomes',stone.reject{|q| !q.restrictions.include?('Red Tome Users Only')}.map{|q| q.postName}],
       ['<:Blue_Blade:467112472768151562> Lances',stone.reject{|q| !q.restrictions.include?('Lance Users Only')}.map{|q| q.postName}],
       ['<:Blue_Tome:467112472394858508> Blue Tomes',stone.reject{|q| !q.restrictions.include?('Blue Tome Users Only')}.map{|q| q.postName}],
       ['<:Green_Blade:467122927230386207> Axes',stone.reject{|q| !q.restrictions.include?('Axe Users Only')}.map{|q| q.postName}],
       ['<:Green_Tome:467122927666593822> Green Tomes',stone.reject{|q| !q.restrictions.include?('Green Tome Users Only')}.map{|q| q.postName}],
       ['<:Colorless_Tome:443692133317345290> Colorless Tomes',stone.reject{|q| !q.restrictions.include?('Colorless Tome Users Only')}.map{|q| q.postName}],
       ['<:Gold_Dragon:774013610908581948> Dragon Breaths',stone.reject{|q| !q.restrictions.include?('Dragons Only')}.map{|q| q.postName}],
       ['<:Gold_Beast:774013608191459329> Beast Damage',stone.reject{|q| !q.restrictions.include?('Beasts Only')}.map{|q| q.postName}],
       ['<:Gold_Bow:774013609389981726> Bows',stone.reject{|q| !q.restrictions.include?('Bow Users Only')}.map{|q| q.postName}],
       ['<:Gold_Dagger:774013610862968833> Daggers',stone.reject{|q| !q.restrictions.include?('Dagger Users Only')}.map{|q| q.postName}],
       ['<:Colorless_Staff:443692132323295243> Damaging Staves',stone.reject{|q| !q.restrictions.include?('Staff Users Only')}.map{|q| q.postName}]]
    f=f.reject{|q| q[1].nil? || q[1].length<=0}
    if f.map{|q| "__^#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
      msg='__**Weapon Refinement: Refining Stones <:Refining_Stone:453618312165720086>**__'
      for i in 0...f.length
        msg=extend_message(msg,"*#{f[i][0]}:* #{f[i][1].join(', ')}",event) if f[i][1].length>0
      end
      event.respond msg
    else
      create_embed(event,'__**Weapon Refinement: Refining Stones <:Refining_Stone:453618312165720086>**__','',0x688C68,nil,nil,f.map{|q| [q[0],q[1].join("\n")]},3)
    end
  elsif stones.map{|q| q.postName}.join("\n").length+dew.map{|q| q.postName}.join("\n").length.length>1900
    dew=dew.map{|q| q.name}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')}
    stone=stone.map{|q| q.name}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')}
    dew2=dew[dew.length/2+dew.length%2,dew.length/2].join("\n")
    dew=dew[0,dew.length/2+3*dew.length%2].join("\n")
    create_embed(event,'__**Weapon Refinement**__','',0x688C68,nil,nil,[['<:Divine_Dew:453618312434417691> Divine Dew',dew],['<:Divine_Dew:453618312434417691> Divine Dew',dew2],['<:Refining_Stone:453618312165720086> Refining Stones',stone.join("\n"),1]],3)
  end
  return nil
end

def get_multiple_units(bot,event,args=[],includestats=true,isbst=false,maxunits=0)
  args=event.message.text.downcase.split(' ') if args.nil? || args.length<=0
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load(['unit'])
  if includestats
    event.channel.send_temporary_message('Parsing message, please wait...',5) rescue nil
  else
    event.channel.send_temporary_message('Calculating data, please wait...',5) rescue nil
  end
  a=true
  s=args.join(' ')
  s=sever(s)
  s2="#{s}"
  k=[]
  u=0
  while a && s.length>0
    args=s.split(' ')
    x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
    if x.nil? || x.length<=0
      a=false
    else
      k.push(x[0])
      s=first_sub(s,x[1],'')
      if x[0].is_a?(Array)
        u+=x[0].length
        s2=first_sub(s2,x[1],x[0][0].name.gsub(' ','_'))
      else
        u+=1
        s2=first_sub(s2,x[1],x[0].name.gsub(' ','_'))
      end
    end
    a=false if maxunits>0 && u>=maxunits
  end
  return k.flatten unless includestats
  s2=splice(s2)
  m=0
  k2=0
  event.channel.send_temporary_message('Message parsed, calculating units...',2) rescue nil
  for i in 0...s2.length
    x=sever(s2[i])
    y=find_data_ex(:find_unit,event,x.split(' '),nil,bot,false,0,1)
    unless y.nil?
      y3=y.clone
      y3=y[0] if y.is_a?(Array)
    end
    if y.nil?
      if x.downcase=="mathoo's" || (x.downcase=='my' && event.user.id==167657750971547648)
        m=167657750971547648
      elsif donate_trigger_word(event,x)>0
        m=donate_trigger_word(event,x)
      end
    elsif m==167657750971547648 && !$dev_units.find_index{|q| q.name==y3.name}.nil?
      f=find_stats_in_string(event,x,0,y3.name,true)
      y2=$dev_units[$dev_units.find_index{|q| q.name==y3.name}]
      k[k2]=[y2.clone,y2.rarity,y2.merge_count,y2.boon.gsub(' ',''),y2.bane.gsub(' ',''),y2.dragonflowers]
      k2+=1
    elsif m>0 && !$donor_units.find_index{|q| q.name==y3.name && q.owner_id==m}.nil?
      f=find_stats_in_string(event,x,0,y3.name,true)
      y2=$donor_units[$donor_units.find_index{|q| q.name==y3.name && q.owner_id==m}]
      k[k2]=[y2.clone,y2.rarity,y2.merge_count,y2.boon.gsub(' ',''),y2.bane.gsub(' ',''),y2.dragonflowers]
      k2+=1
    elsif y.is_a?(Array)
      f=find_stats_in_string(event,x,0,y[0].name,true)
      k[k2]=[k[k2],f[0],f[1],f[2],f[3],f[8]]
      k2+=1
    else
      f=find_stats_in_string(event,x,0,y.name,true)
      k[k2]=[k[k2],f[0],f[1],f[2],f[3],f[8]]
      k2+=1
    end
  end
  k2=[]
  event.channel.send_temporary_message('Units calculated, generating response...',2) rescue nil
  mu=0
  for i in 0...k.length
    if k[i][0].is_a?(Array) && (k[i][0].map{|q| q.name}.reject{|q| ['Robin(M)','Robin(F)'].include?(q)}.length<=0 || k[i][0].map{|q| q.name}.reject{|q| ['Kris(M)','Kris(F)'].include?(q)}.length<=0) && (k.length>1 || isbst)
      k[i][0]=k[i][0][0].clone
      k[i][0].name=k[i][0].name.split('(')[0]
      k2.push(k[i])
    elsif k[i][0].is_a?(Array)
      if isbst
        mu+=1
        k2.push("Multiunit #{mu}: #{list_lift(k[i][0].map{|q| "#{q.name}#{q.emotes(bot,false)}"},'or')}")
      else
        for i2 in 0...k[i][0].length
          k2.push([k[i][0][i2],k[i][1],k[i][2],k[i][3],k[i][4],k[i][5]])
        end
      end
    else
      k2.push(k[i])
    end
  end
  k=k2.map{|q| q}
  return k[0,maxunits] if maxunits>0
  return k
end

def combined_BST(bot,event,args=[])
  data_load(['unit'])
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  x=get_multiple_units(bot,event,args,true,true)
  data_load(['unit'])
  str=''
  if !safe_to_spam?(event) && (x.length>8 || x.reject{|q| q.is_a?(String)}.length>4)
    str="I'm not going to list all that data here.  Reducing to first four units.  If you want to see more, use this command in PM.\n"
    x=x.reject{|q| q.is_a?(String)}
    x=x[0,4]
  end
  u=0
  scr=[]; bst=[]
  str=''
  counters=[['Red', 0, 0, 0],
            ['Blue', 0, 0, 0],
            ['Green', 0, 0, 0],
            ['Colorless', 0, 0, 0],
            ['Tome', 0, 0, 0],
            ['Dragon', 0, 0, 0],
            ['Blade', 0, 0, 0],
            ['Staff', 0, 0, 0],
            ['Dagger', 0, 0, 0],
            ['Archer', 0, 0, 0],
            ['Beast', 0, 0, 0],
            ['Infantry', 0, 0, 0],
            ['Horse', 0, 0, 0],
            ['Armor', 0, 0, 0],
            ['Flier', 0, 0, 0],
            ['Story', 0, 0, 0],
            ['GHB', 0, 0, 0],
            ['Tempest', 0, 0, 0],
            [['', 'F2P', 'F2P', 'F2P'], 0, 0, 0],
            ['Alfonse', 0, 0, 0, ['Alfonse', 'Alfonse(Bunny)', 'Lif', 'Alfonse(Winter)', 'Hood']],
            ['Alm', 0, 0, 0, ['Alm', 'Alm(Saint)', 'Alm(Brave)', 'Alm(Valentines)']],
            ['Anna', 0, 0, 0, ['Anna', 'Anna(Winter)', 'Anna(Apotheosis)']],
            ['Azura', 0, 0, 0, ['Azura', 'Azura(Performing)', 'Azura(Winter)', 'Azura(Adrift)', 'Azura(Vallite)']],
            ['Berkut', 0, 0, 0, ['Berkut', 'Berkut(Fallen)', 'Berkut(Soiree)']],
            ['Byleth', 0, 0, 0, ['Byleth(M)', 'Byleth(F)', 'Byleth(F)(Summer)']],
            ['Caeda', 0, 0, 0, ['Caeda', 'Caeda(Bride)', 'Tsubasa', 'Caeda(Retro)']],
            ['Camilla', 0, 0, 0, ['Camilla', 'Camilla(Bunny)', 'Camilla(Winter)', 'Camilla(Summer)', 'Camilla(Adrift)', 'Camilla(Bath)', 'Camilla(Brave)']],
            ['Catria', 0, 0, 0, ['Catria(Launch)', 'Catria(SoV)', 'Catria(Bunny)', 'Palla(Retro)']],
            ['Celica', 0, 0, 0, ['Celica', 'Celica(Fallen)', 'Celica(Brave)', 'Alm(Valentines)']],
            ['Chrom', 0, 0, 0, ['Chrom(Launch)', 'Chrom(Bunny)', 'Chrom(Winter)', 'Chrom(Branded)', 'Itsuki', 'Chrom(Crowned)']],
            ['Cordelia', 0, 0, 0, ['Cordelia', 'Cordelia(Bride)', 'Cordelia(Summer)', 'Caeldori']],
            ['Corrin(F)', 0, 0, 0, ['Corrin(F)(Launch)', 'Corrin(F)(Summer)', 'Corrin(F)(Adrift)', 'Corrin(F)(Fallen)', 'Corrin(F)(Dusk)']],
            ['Corrin(M)', 0, 0, 0, ['Corrin(M)(Launch)', 'Corrin(M)(Winter)', 'Corrin(M)(Adrift)', 'Corrin(M)(Fallen)', 'Kamui']],
            ['Corrin', 0, 0, 0, ['Corrin(F)(Launch)', 'Corrin(F)(Summer)', 'Corrin(F)(Adrift)', 'Corrin(F)(Fallen)', 'Corrin(F)(Dusk)', 'Corrin(M)(Launch)', 'Corrin(M)(Winter)', 'Corrin(M)(Adrift)', 'Corrin(M)(Fallen)', 'Kamui']],
            ['Dimitri', 0, 0, 0, ['Dimitri', 'Dimitri(Brave)', 'Dimitri(Savior)', 'Dimitri(Fallen)']],
            ['Edelgard', 0, 0, 0, ['Edelgard', 'Flame Emperor', 'Edelgard(Emperor)', 'Edelgard(Brave)', 'Edelgard(Fallen)']],
            ['Eirika', 0, 0, 0, ['Eirika(Bonds)', 'Eirika(Memories)', 'Eirika(Graceful)', 'Eirika(Winter)', 'Eirika(Brave)']],
            ['Elise', 0, 0, 0, ['Elise', 'Elise(Summer)', 'Elise(Bath)']],
            ['Ephraim', 0, 0, 0, ['Ephraim', 'Ephraim(Fire)', 'Ephraim(Brave)', 'Ephraim(Winter)', 'Ephraim(Dynastic)']],
            ['Est', 0, 0, 0, ['Est', 'Est(Bunny)', 'Palla(Retro)']],
            ['Fjorm', 0, 0, 0, ['Fjorm', 'Fjorm(Winter)', 'Fjorm(Bride)']],
            ['Gunnthra', 0, 0, 0, ['Gunnthra', 'Gunnthra(Winter)', 'Gunnthra(Summer)']],
            ['Hector', 0, 0, 0, ['Hector', 'Hector(Valentines)', 'Hector(Marquess)', 'Hector(Brave)', 'Hector(Halloween)']],
            ['Hinoka', 0, 0, 0, ['Hinoka(Launch)', 'Hinoka(Wings)', 'Hinoka(Bath)']],
            ['Ike', 0, 0, 0, ['Ike', 'Ike(Vanguard)', 'Ike(Brave)', 'Ike(Valentines)', 'Ike(Fallen)']],
            ['Julia', 0, 0, 0, ['Julia', 'Julia(Crusader)', 'Julia(Fallen)']],
            ['Kris', 0, 0, 0, ['Fris(F)', 'Kris(M)', 'Kris(M)(Plegian)']],
            ['Laegjarn', 0, 0, 0, ['Laegjarn', 'Laegjarn(Winter)', 'Laegjarn(Summer)']],
            ['Laevatein', 0, 0, 0, ['Laevatein', 'Laevatein(Winter)', 'Laevatein(Summer)']],
            ['Leo', 0, 0, 0, ['Leo', 'Leo(Summer)', 'Leo(Picnic)']],
            ['Lilina', 0, 0, 0, ['Lilina', 'Lilina(Valentines)', 'Lilina(Summer)', 'Hector(Halloween)']],
            ['Lucina', 0, 0, 0, ['Lucina', 'Lucina(Bunny)', 'Marth(Masked)', 'Lucina(Brave)', 'Lucina(Glorious)', 'Mia(Summer)']],
            ['Lyn', 0, 0, 0, ['Lyn', 'Lyn(Bride)', 'Lyn(Brave)', 'Lyn(Valentines)', 'Lyn(Wind)', 'Lyn(Summer)']],
            ['Marth', 0, 0, 0, ['Marth', 'Marth(Groom)', 'Marth(Masked)', 'Marth(King)', 'Marth(Winter)', 'Marth(Retro)']],
            ['Micaiah', 0, 0, 0, ['Micaiah', 'Micaiah(Festival)', 'Micaiah(Brave)']],
            ['Morgan', 0, 0, 0, ['Morgan(M)', 'Morgan(F)', 'Morgan(M)(Fallen)', 'Morgan(F)(Fallen)']],
            ['Ninian', 0, 0, 0, ['Ninian', 'Ninian(Bride)', 'Tiki(Young)(Halloween)']],
            ['Nino', 0, 0, 0, ['Nino(Launch)', 'Nino(Fangs)', 'Nino(Winter)']],
            ['Olivia', 0, 0, 0, ['Olivia(Launch)', 'Olivia(Performing)', 'Olivia(Traveler)']],
            ['Palla', 0, 0, 0, ['Palla', 'Palla(Bunny)', 'Palla(Retro)']],
            ['Reinhardt', 0, 0, 0, ['Reinhardt(Bonds)', 'Reinhardt(World)', 'Reinhardt(Soiree)']],
            ['Robin(F)', 0, 0, 0, ['Robin(F)', 'Robin(F)(Summer)', 'Robin(F)(Fallen)', 'Robin(F)(Fallen)(Halloween)']],
            ['Robin(M)', 0, 0, 0, ['Robin(M)', 'Robin(M)(Winter)', 'Robin(M)(Fallen)', 'Tobin']],
            ['Robin', 0, 0, 0, ['Robin(F)', 'Robin(F)(Summer)', 'Robin(F)(Fallen)', 'Robin(F)(Fallen)(Halloween)', 'Robin(M)', 'Robin(M)(Winter)', 'Robin(M)(Fallen)', 'Tobin']],
            ['Roy', 0, 0, 0, ['Roy', 'Roy(Valentines)', 'Roy(Brave)', 'Roy(Fire)']],
            ['Ryoma', 0, 0, 0, ['Ryoma', 'Ryoma(Supreme)', 'Ryoma(Festival)', 'Ryoma(Bath)']],
            ['Sakura', 0, 0, 0, ['Sakura', 'Sakura(Halloween)', 'Sakura(Bath)']],
            ['Sharena', 0, 0, 0, ['Sharena', 'Sharena(Bunny)', 'Alfonse(Winter)']],
            ['Takumi', 0, 0, 0, ['Takumi', 'Takumi(Fallen)', 'Takumi(Winter)', 'Takumi(Summer)']],
            ['Tharja', 0, 0, 0, ['Tharja', 'Tharja(Winter)', 'Tharja(Bride)', 'Rhajat', 'Kiria', 'Tharja(Plegian)']],
            ['Tiki(Young)', 0, 0, 0, ['Tiki(Young)', 'Tiki(Young)(Summer)', 'Tiki(Young)(Earth)', 'Tiki(Young)(Fallen)', 'Tiki(Young)(Halloween)']],
            ['Tiki', 0, 0, 0, ['Tiki(Young)', 'Tiki(Adult)', 'Tiki(Adult)(Summer)', 'Tiki(Young)(Summer)', 'Tiki(Young)(Earth)', 'Tiki(Young)(Fallen)', 'Tiki(Young)(Halloween)']],
            ['Veronica', 0, 0, 0, ['Veronica', 'Veronica(Brave)', 'Veronica(Bunny)', 'Thrasir', 'Veronica(Pirate)']],
            ['Xander', 0, 0, 0, ['Xander', 'Xander(Bunny)', 'Xander(Summer)', 'Xander(Festival)', 'Veronica(Pirate)']]]
  colors=[[],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
  braves=[[],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0]]
  for i in 0...x.length
    if x[i].is_a?(String)
      str=extend_message(str,"~~#{x[i]}~~",event)
    else
      u+=1
      frmt=''
      frmt='__' if [4,8].include?(u)
      frmt='' if i+1==x.length
      str2="#{frmt}Unit #{u}:#{frmt}    #{x[i][0].starDisplay(bot,x[i][1],x[i][3],x[i][4],x[i][2],x[i][5])}"
      str2="#{str2}    BST: #{x[i][0].dispStats(bot,40,x[i][1],x[i][3],x[i][4],x[i][2],x[i][5]).inject(0){|sum,x2| sum + x2 }}"
      str2="#{str2}    Score: #{x[i][0].score(bot,40,x[i][1],x[i][3],x[i][4],x[i][2],x[i][5]).to_i}"
      bst.push(x[i][0].dispStats(bot,40,x[i][1],x[i][3],x[i][4],x[i][2],x[i][5]).inject(0){|sum,x2| sum + x2 })
      scr.push(x[i][0].score(bot,40,x[i][1],x[i][3],x[i][4],x[i][2],x[i][5]))
      str2="#{str2}+`SP`/100" if x[i][0].owner.nil?
      str=extend_message(str,str2,event)
      for i2 in 1...4
        if u-1<i2*4 || i2==3
          counters[0][i2]+=1 if x[i][0].weapon_color=='Red'
          counters[1][i2]+=1 if x[i][0].weapon_color=='Blue'
          counters[2][i2]+=1 if x[i][0].weapon_color=='Green'
          counters[3][i2]+=1 if x[i][0].weapon_color=='Colorless'
          counters[4][i2]+=1 if x[i][0].weapon_type=='Tome'
          counters[5][i2]+=1 if x[i][0].weapon_type=='Dragon'
          counters[6][i2]+=1 if x[i][0].weapon_type=='Blade'
          counters[7][i2]+=1 if x[i][0].weapon_type=='Staff'
          counters[8][i2]+=1 if x[i][0].weapon_type=='Dagger'
          counters[9][i2]+=1 if x[i][0].weapon_type=='Bow'
          counters[10][i2]+=1 if x[i][0].weapon_type=='Beast'
          counters[11][i2]+=1 if x[i][0].movement=='Infantry'
          counters[12][i2]+=1 if x[i][0].movement=='Cavalry'
          counters[13][i2]+=1 if x[i][0].movement=='Armor'
          counters[14][i2]+=1 if x[i][0].movement=='Flier'
          summon_type=x[i][0].availability[0]
          braves[i2][0]+=1 if ['Ike(Brave)','Lucina(Brave)','Lyn(Brave)','Roy(Brave)'].include?(x[i][0].name)
          braves[i2][1]+=1 if ['Celica(Brave)','Ephraim(Brave)','Hector(Brave)','Veronica(Brave)'].include?(x[i][0].name)
          braves[i2][2]+=1 if ['Micaiah(Brave)','Camilla(Brave)','Alm(Brave)','Eliwood(Brave)'].include?(x[i][0].name)
          braves[i2][3]+=1 if ['Claude(Brave)','Dimitri(Brave)','Edelgard(Brave)','Lysithea(Brave)'].include?(x[i][0].name)
          braves[i2][4]+=1 if ['Marianne(Brave)','Gatekeeper(Brave)','Marth(Brave)','Eirika(Brave)'].include?(x[i][0].name)
          counters[15][i2]+=1 if summon_type.include?('y')
          counters[16][i2]+=1 if summon_type.include?('g')
          counters[17][i2]+=1 if summon_type.include?('t')
          counters[18][i2]+=1 if summon_type.include?('y') || summon_type.include?('g') || summon_type.include?('t') || summon_type.include?('d') || summon_type.include?('f')
          if counters.length>19
            for i3 in 19...counters.length
              counters[i3][i2]+=1 if counters[i3][4].include?(x[i][0].name)
            end
          end
          colors[i2][0]+=1 if x[i][0].weapon_color=='Red'
          colors[i2][1]+=1 if x[i][0].weapon_color=='Blue'
          colors[i2][2]+=1 if x[i][0].weapon_color=='Green'
          colors[i2][3]+=1 if x[i][0].weapon_color=='Colorless'
          colors[i2][4]+=1 unless ['Red','Blue','Green','Colorless'].include?(x[i][0].weapon_color)
        end
      end
    end
  end
  emblem_name=[[],[],[],[]]
  extra_data=['','','','']
  unit_data=['','','','']
  x=x.reject{|q| q.is_a?(String)}
  for i in 1...4
    if braves[i].max==1
      counters[18][i]+=braves[i].inject(0){|sum,x| sum + x }
      counters[18][0][i]='Pseudo-F2P'
    end
    for i2 in 0...counters.length
      cmp=i*4
      cmp=x.length if i==3
      if counters[i2][i]==cmp
        if i2==18
          extra_data[i]=counters[18][0][i] unless extra_data[i].length>0
        elsif i2>18
          unit_data[i]=counters[i2][0] unless unit_data[i].length>0
        elsif i2>14
          extra_data[i]=counters[i2][0] unless extra_data[i].length>0
        else
          emblem_name[i].push(counters[i2][0])
        end
      end
    end
    emblem_name[i].unshift(extra_data[i]) if extra_data[i].length>0
    emblem_name[i].push(unit_data[i]) if unit_data[i].length>0
  end
  emblem_name[1].unshift('Color-balanced') if colors[1][0]==colors[1][1] && colors[1][0]==colors[1][2] && colors[1][0]==1
  emblem_name[2].unshift('Color-balanced') if colors[2][0]==colors[2][1] && colors[2][0]==colors[2][2] && colors[2][0]==2
  emblem_name[3].unshift('Color-balanced') if colors[3][0]==colors[3][1] && colors[3][0]==colors[3][2] && colors[3][3]+colors[3][4]<x.length/2
  for i in 1...4
    if emblem_name[i]==['Color-balanced']
      emblem_name[i]=emblem_name[i][0]
    elsif emblem_name[i].length>0
      emblem_name[i]="#{emblem_name[i].join(' ')} Emblem"
      emblem_name[i]=emblem_name[i].gsub('Red Blade','Sword')
      emblem_name[i]=emblem_name[i].gsub('Blue Blade','Lance')
      emblem_name[i]=emblem_name[i].gsub('Green Blade','Axe')
    else
      emblem_name[i]=''
    end
  end
  str3="__**#{"#{emblem_name[3]} " if emblem_name[3].length>0}Team**__"
  frmt='**'
  if x.length>4
    str2="__**First four listed units#{", which constitutes a#{'n' if ['A','E','I','O','U'].include?(emblem_name[1][0])} #{emblem_name[1]} team" if emblem_name[1].length>0}**__"
    str2="#{str2}\n**BST of all four units: #{bst[0,4].inject(0){|sum,x2| sum + x2 }}**"
    str2="#{str2}\n**Advanced Arena Score: #{(scr[0,4].inject(0){|sum,x2| sum + x2 }/4.0+183).round(1)}"
    str2="#{str2}+`SP`/400" if x[0,4].reject{|q| !q[0].owner.nil?}.length>0
    str2="#{str2}**, or #{(scr[0,4].inject(0){|sum,x2| sum + x2 }/2.0+366).round(1)}"
    str2="#{str2}+`SP`/200" if x[0,4].reject{|q| !q[0].owner.nil?}.length>0
    str2="#{str2} with bonus unit"
    str=extend_message(str,str2,event,2)
    str3="__*All listed units*__#{", which constitutes a#{'n' if ['A','E','I','O','U'].include?(emblem_name[3][0])} #{emblem_name[3]} team" if emblem_name[3].length>0}"
    frmt='*'
  end
  if x.length>8
    str2="__*First eight listed units#{", which constitutes a#{'n' if ['A','E','I','O','U'].include?(emblem_name[2][0])} #{emblem_name[2]} team" if emblem_name[2].length>0}*__"
    str2="#{str2}\n*BST of all eight units: #{bst[0,8].inject(0){|sum,x2| sum + x2 }}*"
    str2="#{str2}\n*Advanced Arena Score: #{(scr[0,8].inject(0){|sum,x2| sum + x2 }/8.0+211).round(1)}"
    str2="#{str2}+`SP`/800" if x[0,8].reject{|q| !q[0].owner.nil?}.length>0
    str2="#{str2}*, or #{(scr[0,8].inject(0){|sum,x2| sum + x2 }/4.0+422).round(1)}"
    str2="#{str2}+`SP`/400" if x[0,8].reject{|q| !q[0].owner.nil?}.length>0
    str2="#{str2} with bonus unit"
    str=extend_message(str,str2,event,2)
    str3="__All listed units#{", which constitutes a#{'n' if ['A','E','I','O','U'].include?(emblem_name[3][0])} #{emblem_name[3]} team" if emblem_name[3].length>0}__"
    frmt=''
  end
  str3="#{str3}\n#{frmt}BST of all units: #{bst.inject(0){|sum,x2| sum + x2 }}#{frmt}"
  str3="#{str3}\n#{frmt}Advanced Arena Score: #{(scr.inject(0){|sum,x2| sum + x2 }*1.0/scr.length+scr.length*7+155).round(1)}"
  str3="#{str3}+`SP`/#{x.length*100}" if x.reject{|q| !q[0].owner.nil?}.length>0
  str3="#{str3}#{frmt}, or #{(scr.inject(0){|sum,x2| sum + x2 }*2.0/scr.length+scr.length*14+310).round(1)}"
  str3="#{str3}+`SP`/#{x.length*50}" if x.reject{|q| !q[0].owner.nil?}.length>0
  str3="#{str3} with bonus unit"
  str=extend_message(str,str3,event,2)
  event.respond str
end

def shortstat(x)
  return 'Atk' if x=='Attack'
  return 'Spd' if x=='Speed'
  return 'Def' if x=='Defense'
  return 'Res' if x=='Resistance'
  return x
end

def comparison(bot,event,args=[])
  data_load(['unit'])
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  x=get_multiple_units(bot,event,args)
  data_load(['unit'])
  hdr="__Comparing #{x.length} units__"
  err=''
  if x.length>x.uniq.length
    x.uniq!
    err='Duplicate units found.  Collapsing into shorter list.'
  end
  event.respond err if err.length>0
  xpic=nil
  ignoreclone=false
  if x.length<=0
    event.respond 'No units were listed.'
    return nil
  elsif x.length<=1 && !x[0][0].hasEnemyForm?
    event.respond 'Only one unit found.  Switching to the `study` command, which is basically `compare` for one unit.'
    unit_study(bot,event,args,x[0][0].name)
    return nil
  elsif x.length<=1
    z="#{x[0][0].name}"
    hdr="Comparing **#{x[0][0].name}#{x[0][0].emotes(bot,false)}**"
    xpic="#{x[0][0].thumbnail(event,bot)}"
    x[0][10]=x[0][0].clone; ignoreclone=true
    x[0][0].name='Player'; x[0][6]='Player'
    y=x[0].map{|q| q}
    y[0]=y[0].clone
    y[0].name='Boss'; y[6]='Boss'
    y[0].growths=x[0][0].growths[5,5].map{|q| q}
    x[0][0].growths=x[0][0].growths[0,5].map{|q| q}
    y[0].stats40=x[0][0].stats40[5,5].map{|q| q}
    y[0].stats1=x[0][0].stats1[5,5].map{|q| q}
    x[0][0].stats40=x[0][0].stats40[0,5].map{|q| q}
    x[0][0].stats1=x[0][0].stats1[0,5].map{|q| q}
    x.push(y.map{|q| q})
    if x[0][0].stats40[0,5].max<=0
      event.respond "Only one unit found, and #{x[0][0].pronoun(false)} is enemy-exclusive.  I cannot `compare` one unit, and `study` is not available to enemies.  Displaying #{x[0][0].pronoun(true)} `stats`."
      y[0].name="#{z}"
      disp_unit_stats(bot,event,y[0].clone,'smol')
      return nil
    end
  elsif x.map{|q| q[0].name}.uniq.length<=1
    rar=true
    merges=true
    boon=true
    bane=true
    rar=false if x.map{|q| q[1]}.uniq.length<=1
    merges=false if x.map{|q| q[2]}.uniq.length<=1
    boon=false if x.map{|q| q[3]}.uniq.length<=1
    bane=false if x.map{|q| q[4]}.uniq.length<=1
    flowers=false if x.map{|q| q[5]}.uniq.length<=1
    for i in 0...x.length
      nat="#{"+#{shortstat(x[i][3])}" if boon && x[i][3].length>0 && x[i][3]!=' '}#{"-#{shortstat(x[i][4])}" if bane && x[i][4].length>0 && x[i][4]!=' '}"
      nat='(neutral)' if (x[i][3].length<=0 || x[i][3]==' ') && (x[i][4].length<=0 || x[i][4]==' ')
      x[i].push("#{"#{x[i][1]}\\* " if rar}#{x[i][0].name}#{" +#{x[i][2]}" if merges}#{" #{nat}" if (boon || bane) && !(rar || merges)}#{" f+#{x[i][5]}" if flowers && x[i][5]>0}")
    end
    hdr="Comparing **#{x[0][0].name}#{x[0][0].emotes(bot,false)}**"
    xpic=x[0][0].thumbnail(event,bot)
  else
    for i in 0...x.length
      x[i].push(x[i][0].name)
    end
    hdr="Comparing **#{x[0][0].name}** and **#{x[1][0].name}**" if x.length<=2
  end
  ftr=nil
  a=x.map{|q| q[0].alts[0]}.uniq
  if a.include?('Elise') && a.include?('Nino') && a.length<=2
    metadata_load()
    hdc=@server_data[0].inject(0){|sum,x2| sum + x2 }/701.0
    ftr="Heyday Coefficient: #{hdc.round(4)}" if hdc>1
  end
  xlx=2
  xlx=9 if safe_to_spam?(event)
  y=x.map{|q| q[0].emotes(bot,false).split('>').map{|q2| "#{q2}>"}}
  z=y[0]
  for i in 1...y.length
    z=z.reject{|q| !y[i].include?(q)}
  end
  xx=x.map{|q| q[0].name}.uniq
  if xx.include?('Robin(M)') && xx.include?('Robin(F)') && xx.reject{|q| ['Robin(M)','Robin(F)'].include?(q)}.length<=0
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Cyan_#{x[0][0].weapon_type}"}
    z.unshift(moji[0].mention) unless moji.length<=0
  elsif xx.include?('Kris(M)') && xx.include?('Kris(F)') && xx.reject{|q| ['Kris(M)','Kris(F)'].include?(q)}.length<=0
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Purple_#{x[0][0].weapon_type}"}
    z.unshift(moji[0].mention) unless moji.length<=0
  elsif x.map{|q| q[0].weapon_color}.uniq.length<=1 && x.map{|q| q[0].weapon_type}.uniq.length<=1 && x[0][0].weapon_type=='Tome' && x.map{|q| q[0].tome_tree}.uniq.length>1
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x[0][0].weapon_color}_#{x[0][0].weapon_type}"}
    z.unshift(moji[0].mention) unless moji.length<=0
  elsif x.map{|q| q[0].weapon_color}.uniq.length<=1 && x.map{|q| q[0].weapon_type}.uniq.length>1
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x[0][0].weapon_color}_Unknown"}
    z.unshift(moji[0].mention) unless moji.length<=0
  elsif x.map{|q| q[0].weapon_color}.uniq.length>1 && x.map{|q| q[0].weapon_type}.uniq.length<=1
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{x[0][0].weapon_type}"}
    z.unshift(moji[0].mention) unless moji.length<=0
  end
  z2=''
  if x.reject{|q| !q[0].legendary.nil?}.length<=0 && x.map{|q| q[0].legendary[0]}.uniq.length>1 && z[-1].include?('Ally_Boost_')
    z2="#{z[-1]}"
    z.pop
  end
  if x.reject{|q| !q[0].legendary.nil? && q[0].legendary[3]=='Legendary'}.length<=0 && x.map{|q| q[0].legendary[0]}.uniq.length>1
    z.push('<:Legendary_Effect_Unknown:443337603945857024>')
  elsif x.reject{|q| !q[0].legendary.nil? && q[0].legendary[3]=='Mythic'}.length<=0 && x.map{|q| q[0].legendary[0]}.uniq.length>1
    z.push('<:Mythic_Effect_Unknown:523328368079273984>')
  end
  z.push(z2) if z2.length>0
  str=z.join('')
  if x.length>xlx
    text=stats_of_multiunits(bot,event,x.map{|q| q},2)
    ftr=text[1] unless !ftr.nil? || text.is_a?(String) || text[1].nil?
    text=text[0] if text.is_a?(Array)
    text="#{str}\n#{text}" if str.length>0
    create_embed(event,"__#{hdr}__",text,avg_color(x.map{|q| q[0].disp_color(0,1)}),ftr,xpic)
    return nil
  end
  str='_ _' unless z.length>0 || !safe_to_spam?(event)
  f=[]
  ftr=nil
  for i in 0...x.length
    x[i][0]=x[i][0].clone
    x[i][10]=x[i][0].clone unless ignoreclone
    x[i][0].sort_data=x[i][0].dispStats(bot,40,x[i][1],x[i][3],x[i][4],x[i][2],x[i][5])
    x[i][0].sort_data.push(x[i][0].dispStats(bot,40,x[i][1],x[i][3],x[i][4],x[i][2],x[i][5]).inject(0){|sum,x2| sum + x2 })
    if !x[i][0].owner.nil? && x[i][0].resplendent.length>0
      x[i][0].sort_data=x[i][0].sort_data.map{|q| q+2}
      x[i][0].sort_data[5]+=8
    end
    sn=x[i][0].supernatures(x[i][1]).map{|q| q}
    if (x[i][3]!=' ' && x[i][3].length>0) || (x[i][4]!=' ' && x[i][4].length>0)
      sn[0]=' ' unless (sn[0]=='+' && x[i][3]=='HP') || (sn[0]=='-' && x[i][4]=='HP')
      sn[1]=' ' unless (sn[1]=='+' && ['Atk','Attack'].include?(x[i][3])) || (sn[1]=='-' && ['Atk','Attack'].include?(x[i][4]))
      sn[2]=' ' unless (sn[2]=='+' && ['Spd','Speed'].include?(x[i][3])) || (sn[2]=='-' && ['Spd','Speed'].include?(x[i][4]))
      sn[3]=' ' unless (sn[3]=='+' && ['Def','Defense'].include?(x[i][3])) || (sn[3]=='-' && ['Def','Defense'].include?(x[i][4]))
      sn[4]=' ' unless (sn[4]=='+' && ['Res','Resistance'].include?(x[i][3])) || (sn[4]=='-' && ['Res','Resistance'].include?(x[i][4]))
    end
    sn=sn.map{|q| "#{'+' if q=='+'}#{' ' unless q=='+'}"} if x[i][2]>0
    s=x[i][0].emotes(bot,false,true)
    s="#{s} / #{x[i][0].emotes(bot,false)}<:Resplendent_Ascension:678748961607122945>" if x[i][0].hasResplendent? && x[i][0].owner.nil?
    s="#{s}\nHP: #{x[i][0].sort_data[0]}"
    s="#{s} / #{x[i][0].sort_data[0]+2}" if x[i][0].hasResplendent? && x[i][0].owner.nil?
    s="#{s} (#{sn[0]})" unless sn[0]==' '
    s="#{s}\n#{x[i][0].atkName(false).gsub('Frz','Mag')}: #{x[i][0].sort_data[1]}"
    s="#{s} / #{x[i][0].sort_data[1]+2}" if x[i][0].hasResplendent? && x[i][0].owner.nil?
    s="#{s} (#{sn[1]})" unless sn[1]==' '
    s="#{s}\nSpd: #{x[i][0].sort_data[2]}"
    s="#{s} / #{x[i][0].sort_data[2]+2}" if x[i][0].hasResplendent? && x[i][0].owner.nil?
    s="#{s} (#{sn[2]})" unless sn[2]==' '
    s="#{s}\nDef: #{x[i][0].sort_data[3]}"
    s="#{s} / #{x[i][0].sort_data[3]+2}" if x[i][0].hasResplendent? && x[i][0].owner.nil?
    s="#{s} (#{sn[3]})" unless sn[3]==' '
    s="#{s}\nRes: #{x[i][0].sort_data[4]}"
    s="#{s} / #{x[i][0].sort_data[4]+2}" if x[i][0].hasResplendent? && x[i][0].owner.nil?
    s="#{s} (#{sn[4]})" unless sn[4]==' '
    s="#{s}\n\nBST: #{x[i][0].sort_data[5]}"
    if x[i][0].hasResplendent? && x[i][0].owner.nil?
      s="#{s} / #{x[i][0].sort_data[5]+10}"
      ftr='Units with Resplendent Ascension use those stats in the analysis.'
      for i2 in 0...5
        x[i][0].sort_data[i2]+=2
      end
      x[i][0].sort_data[5]+=10
    end
    h="#{x[i][1]}#{Rarity_stars[0][x[i][1]-1]} #{x[i][0].name}"
    h="#{x[i][1]}#{Rarity_stars[1][x[i][1]-1]} #{x[i][0].name}" if x[i][2]>=Max_rarity_merge[1]
    h="#{h} +#{x[i][2]}" if x[i][2]>0
    h="#{h} #{x[i][0].dragonflowerEmote}+#{x[i][5]}" if x[i][5]>0
    n=[]
    n.push("+#{shortstat(x[i][3])}") unless x[i][3].length<=0 || x[i][3]==' '
    n.push("#{'~~' if x[i][2]>0}-#{shortstat(x[i][4])}#{'~~' if x[i][2]>0}") unless x[i][4].length<=0 || x[i][4]==' '
    h="#{h} (#{n.join(' ')})" if n.length>0
    unless x[i][6]==x[i][0].name
      if x[i][0].owner.nil?
        x[i][0].name=x[i][6].gsub(x[i][0].name,'').gsub('(','').gsub(')','').gsub(' ','')
      else
        x[i][0].name="#{x[i][0].onwer}'s #{x[i][0].name}"
      end
    end
    h="#{x[i][0].owner}'s #{x[i][0].name}" unless x[i][0].owner.nil?
    f.push([h,s])
  end
  ecount=x.reject{|q| !['Elise'].include?(q[0].alts[0].gsub('*','')) && (q[0].duo.nil? || !q[0].duo.map{|q2| q2[1]}.include?('Elise'))}.length
  ncount=x.reject{|q| !['Nino'].include?(q[0].alts[0].gsub('*','')) && (q[0].duo.nil? || !q[0].duo.map{|q2| q2[1]}.include?('Nino'))}.length
  if ecount+ncount==x.length && ecount>0 && ncount>0
    len='%.2f'
    len='%.4f' if Shardizard==4
    hc=@server_data[0].inject(0){|sum,x| sum + x }*1.0
    hc/=701
    ftr="Heydey coefficient: #{len % hc}"
  end
  if x.length>2
    str2=stats_of_multiunits(bot,event,x.map{|q| q},2)
    str2=str2[0] if str2.is_a?(Array)
    str="#{str}\n#{str2.gsub('*','')}"
  else
    statnames=['HP','Attack','Speed','Defense','Resistance','BST']
    stemoji=['<:HP_S:514712247503945739>','<:GenericAttackS:514712247587569664>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>','']
    if x.map{|q| q[0].atkName}.uniq.length<=1 && x[i][0].atkName != 'Freeze'
      statnames[1]=x[i][0].atkName
      stemoji[1]='<:StrengthS:514712248372166666>' if statnames[1]=='Strength'
      stemoji[1]='<:MagicS:514712247289774111>' if statnames[1]=='Magic'
    end
    xx=0
    for i in 0...6
      str="#{str}\n" if i==5
      if x[0][0].sort_data[i]>x[1][0].sort_data[i]
        str="#{str}\n#{stemoji[i]}#{x[0][0].name} has #{x[0][0].sort_data[i]-x[1][0].sort_data[i]} more #{statnames[i]}"
        xx+=x[0][0].sort_data[i] unless i==5
      elsif x[0][0].sort_data[i]<x[1][0].sort_data[i]
        str="#{str}\n#{stemoji[i]}#{x[1][0].name} has #{x[1][0].sort_data[i]-x[0][0].sort_data[i]} more #{statnames[i]}"
        xx+=x[1][0].sort_data[i] unless i==5
      else
        str="#{str}\n#{stemoji[i]}Equal #{statnames[i]}"
        xx+=x[0][0].sort_data[i] unless i==5
      end
    end
    str="#{str}\nBST of highest stats: #{xx}"
  end
  f.push(['<:Ally_Boost_Spectrum:443337604054646804> Analysis',str])
  if x.map{|q| q[10].name}.uniq.length<2 && x.reject{|q| q[10].owner.nil?}.length<=0
    for i in 0...f.length
      s=f[i][1].split("\n")
      s.shift
      f[i][1]=s.join("\n")
    end
  end
  create_embed(event,"__#{hdr}__",'',avg_color(x.map{|q| q[0].disp_color(0,1)}),ftr,xpic,f)
end

def skill_comparison(bot,event,args=[])
  data_load(['unit'])
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  x=get_multiple_units(bot,event,args,true,false,2)
  data_load(['unit'])
  str="#{x[0][1]}#{Rarity_stars[0][x[0][1]-1]}"
  str="#{x[0][1]}#{Rarity_stars[1][x[0][1]-1]}" if x[0][2]>=Max_rarity_merge[1]
  str="#{str} #{x[0][0].name}#{x[0][0].emotes(bot,false)}"
  str2="#{x[1][1]}#{Rarity_stars[0][x[1][1]-1]}"
  str2="#{x[1][1]}#{Rarity_stars[1][x[1][1]-1]}" if x[1][2]>=Max_rarity_merge[1]
  str2="#{str2} #{x[1][0].name}#{x[1][0].emotes(bot,false)}"
  hdr="__Comparing the skills of **#{str}** and **#{str2}**__"
  l1=x[0][0].skill_list(x[0][1])
  s1=x[0][0].summoned(x[0][1])
  l2=x[1][0].skill_list(x[1][1])
  s2=x[1][0].summoned(x[1][1])
  data_load()
  l3=[]
  f=[['<:Skill_Weapon:444078171114045450>Weapon'],['<:Skill_Assist:444078171025965066>Assist'],['<:Skill_Special:444078170665254929>Special'],
     ['<:Passive_A:443677024192823327>A Passive'],['<:Passive_B:443677023257493506>B Passive'],['<:Passive_C:443677023555026954>C Passive'],
     ['<:Passive_S:443677023626330122>Passive Seal']]
  slt=['Weapon','Assist','Special','Passive(A)','Passive(B)','Passive(C)','Seal']
  ftr=nil
  for i in 0...6
    l1x=l1.reject{|q| !q.type.include?(slt[i])}
    l2x=l2.reject{|q| !q.type.include?(slt[i])}
    l3.push(l1x.reject{|q| !l2x.map{|q2| q2.fullName}.include?(q.fullName)})
    m=[]
    if l3[i].length<=0
      m.push('~~neither unit has skills~~')
      m=["~~only #{x[0][0].name} has skills~~"] if l1x.length>0
      m=["~~only #{x[1][0].name} has skills~~"] if l2x.length>0
      m=['~~no overlap~~'] if l2x.length>0 && l1x.length>0
    else
      m=l3[i].map{|q| q.fullName}
      for i2 in 0...m.length
        if s1.reject{|q| !q.type.include?(slt[i])}.map{|q| q.fullName}.include?(m[i2]) && s2.reject{|q| !q.type.include?(slt[i])}.map{|q| q.fullName}.include?(m[i2])
          m[i2]="**#{m[i2]}**"
        elsif s1.reject{|q| !q.type.include?(slt[i])}.map{|q| q.fullName}.include?(m[i2]) || s2.reject{|q| !q.type.include?(slt[i])}.map{|q| q.fullName}.include?(m[i2])
          m[i2]="*#{m[i2]}*"
          ftr='Italic skill names are known by one unit at the moment of summoning, but the other must learn it later.'
        end
      end
      m.unshift('~~different starts~~') unless l3[i][0].prerequisite.nil?
      m.push('~~different ends~~') if l1x[-1].fullName != l3[i][-1].fullName && l2x[-1].fullName != l3[i][-1].fullName
      m.push("~~#{x[1][0].name} has promotion~~") if l1x[-1].fullName==l3[i][-1].fullName && l2x[-1].fullName != l3[i][-1].fullName
      m.push("~~#{x[0][0].name} has promotion~~") if l1x[-1].fullName != l3[i][-1].fullName && l2x[-1].fullName==l3[i][-1].fullName
    end
    f[i].push(m.join("\n"))
  end
  f=f.reject{|q| q[1].nil? || q[1].length<=0}
  create_embed(event,hdr,'',avg_color(x.map{|q| q[0].disp_color(0,1)}),ftr,nil,f)
end

def find_alts(bot,event,args=[])
  event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil
  data_load(['unit'])
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  x=find_data_ex(:find_unit,event,args,nil,bot)
  a=[]
  if x.nil?
    event.respond 'No matches found.'
    return nil
  elsif x.is_a?(Array)
    for i in 0...x.length
      a.push(x[i].alts[0].gsub('*',''))
      unless x[i].duo.nil?
        for i2 in 0...x[i].duo.length
          a.push(x[i].duo[i2][1])
        end
      end
      a.push(x[i].awonk[1]) unless x[i].awonk.nil?
    end
  else
    a.push(x.alts[0].gsub('*',''))
    unless x.duo.nil?
      for i2 in 0...x.duo.length
        a.push(x.duo[i2][1])
      end
    end
    a.push(x.awonk[1]) unless x.awonk.nil?
  end
  a.uniq!
  for i in 0...a.length
    b=["#{a[i].split('[')[0]}"]
    b=['Tharja','Rhajat'] if ['Tharja','Rhajat'].include?(a[i])
    x=$units.reject{|q| !b.include?(q.alts[0].gsub('*',''))}
    x2=$units.reject{|q| q.duo.nil? || !q.duo.map{|q2| b.include?(q2[1].split('[')[0])}.include?(true)}
    x3=$units.reject{|q| q.awonk.nil? || !b.include?(q.awonk[1].split('[')[0])}
    data_load()
    for i2 in 0...x.length
      x[i2].sort_data=x[i2].alts.map{|q| q}
      x[i2].sort_data[0]=x[i2].sort_data[0].gsub('*','')
    end
    for i2 in 0...x2.length
      m=x2[i2].duo.find_index{|q| b.include?(q[1].split('[')[0])}
      x2[i2].sort_data=x2[i2].duo[m][1].gsub(']','').split('[')
    end
    for i2 in 0...x3.length
      x3[i2].sort_data=x3[i2].awonk[1].gsub(']','').split('[')
    end
    f=[]
    y=[]
    if x.reject{|q| q.alts.length<=1}.length>0 || b.length>1
      y=[x,x2,x3].flatten.map{|q| q.sort_data}.uniq
    else
      y=[[a[i]]]
    end
    y=y.sort{|aa,bb| supersort(aa,bb,1)}
    for i2 in 0...y.length
      z=x.reject{|q| q.sort_data != y[i2]}
      m=[]
      for i3 in 0...z.length
        m2=[]
        m2.push('default') if z[i3].name==z[i3].alts[0] || z[i3].alts[0][z[i3].alts[0].length-1,1]=='*'
        m2.push('sensible') if z[i3].alts[0][0]=='*'
        m2.push('seasonal') if z[i3].availability[0].include?('s') && z[i3].legendary.nil?
        m2.push('community-voted') if z[i3].name.include?('(Brave)')
        m2.push('Fallen') if z[i3].name.include?('(Fallen)')
        m2.push('Legendary/Mythical') unless z[i3].legendary.nil?
        m2.push("#{z[i3].duo[0][0]} (with #{list_lift(z[i3].duo.map{|q| q[2]},'and')})") unless z[i3].duo.nil?
        m2.push('out-of-left-field') if m2.length<=0
        m2.push('~~IntSys why~~') if count_in(z[i3].name,'(')>2
        m.push("#{z[i3].name}#{z[i3].emotes(bot,false)} - #{m2.join(', ')}") if m2.length>0
      end
      str2="#{y[i2][0]}"
      str2="#{str2}[#{y[i2][1]}]" if y[i2].length>1
      z2=x2.reject{|q| !q.duo.map{|q2| q2[1]}.include?(str2)}
      for i3 in 0...z2.length
        m2=[]
        m2.push('seasonal') if z2[i3].availability[0].include?('s') && z2[i3].legendary.nil?
        m2.push('community-voted') if z2[i3].name.include?('(Brave)')
        m2.push('Fallen') if z2[i3].name.include?('(Fallen)')
        m2.push('Legendary/Mythical') unless z2[i3].legendary.nil?
        m2.push('~~IntSys why~~') if count_in(z2[i3].name,'(')>2
        m2.push("#{z2[i3].duo[0][0]} (to #{z2[i3].alts[0].gsub('*','')}#{"[#{z2[i3].alts[1].gsub('Alfonse(Hel)','Lif')}]".gsub('Alfonse[Hel]','Lif') if z2[i3].alts.length>1})")
        m.push("#{z2[i3].name}#{z2[i3].emotes(bot,false)} - #{m2.join(', ')}")
      end
      z3=x3.reject{|q| q.awonk[1]!=str2}
      for i3 in 0...z3.length
        m2=[]
        m2.push('seasonal') if z3[i3].availability[0].include?('s') && z3[i3].legendary.nil?
        m2.push('community-voted') if z3[i3].name.include?('(Brave)')
        m2.push('Fallen') if z3[i3].name.include?('(Fallen)')
        m2.push('Legendary/Mythical') unless z3[i3].legendary.nil?
        m2.push('~~IntSys why~~') if count_in(z3[i3].name,'(')>2
        z3i3=z3[i3].emotes(bot,false)
        if z3[i3].awonk[0]=='Idol'
          z3i3="#{z3i3}<:Sharp:800585155320348732>"
          m2.push("Mirage Persona (to #{z3[i3].alts[0].gsub('*','')}#{"(#{z3[i3].alts[1]}) " if z3[i3].alts.length>1})")
        elsif z3[i3].awonk[0]=='Dream'
          m2.push("Dream Illusion (actually #{z3[i3].alts[0].gsub('*','')}#{"(#{z3[i3].alts[1]}) " if z3[i3].alts.length>1 && z3[i3].alts[1]!='Dream'})")
        else
          m2.push("#{z3[i3].awonk[0]} (to #{z3[i3].alts[0].gsub('*','')}#{"(#{z3[i3].alts[1]}) " if z3[i3].alts.length>1})")
        end
        m.push("#{z3[i3].name}#{z3i3} - #{m2.join(', ')}")
      end
      f.push([str2,m.join("\n"),1]) if m.length>0
    end
    x.push(x2)
    x.push(x3)
    x.flatten!
    str=''
    f.reverse! if f[-1][0].include?('[Academy]')
    f.reverse! if f[-1][0].include?('[Awakening]') && f[-2][0].include?('[Fates]')
    if f[0][0].include?('[') && !f.find_index{|q| q[0]==a[i].split('[')[0]}.nil?
      m=f[f.find_index{|q| q[0]==a[i].split('[')[0]}].map{|q| q}
      f=f.reject{|q| q[0]==a[i].split('[')[0]}
      f.unshift(m.map{|q| q})
    elsif a[i].split('[')[0]=='Camus'
      m=f[f.find_index{|q| q[0]=="#{a[i].split('[')[0]}[SD]"}].map{|q| q}
      f=f.reject{|q| q[0]=="#{a[i].split('[')[0]}[SD]"}
      f.unshift(m.map{|q| q})
    end
    if f.length==1 && f[0][0]==a[i]
      str="#{f[0][1]}"
      f=nil
    end
    b="__**#{a[i].split('[')[0]}**__"
    b="__Just **#{a[i].split('[')[0]}**__" if ['Tharja','Rhajat'].include?(a[i])
    if x.length>1
      y=x.map{|q| q.emotes(bot,false).split('>').map{|q2| "#{q2}>"}}
      z=y[0]
      for i in 1...y.length
        z=z.reject{|q| !y[i].include?(q)}
      end
      xx=x.map{|q| q.name}.uniq
      if xx.include?('Robin(M)') && xx.include?('Robin(F)') && xx.reject{|q| ['Robin(M)','Robin(F)'].include?(q)}.length<=0
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Cyan_#{x[0].weapon_type}"}
        z.unshift(moji[0].mention) unless moji.length<=0
      elsif xx.include?('Kris(M)') && xx.include?('Kris(F)') && xx.reject{|q| ['Kris(M)','Kris(F)'].include?(q)}.length<=0
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Purple_#{x[0].weapon_type}"}
        z.unshift(moji[0].mention) unless moji.length<=0
      elsif x.map{|q| q.weapon_color}.uniq.length<=1 && x.map{|q| q.weapon_type}.uniq.length<=1 && x[0].weapon_type=='Tome' && x.map{|q| q.tome_tree}.uniq.length>1
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x[0].weapon_color}_#{x[0].weapon_type}"}
        z.unshift(moji[0].mention) unless moji.length<=0
      elsif x.map{|q| q.weapon_color}.uniq.length<=1 && x.map{|q| q.weapon_type}.uniq.length>1
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x[0].weapon_color}_Unknown"}
        z.unshift(moji[0].mention) unless moji.length<=0
      elsif x.map{|q| q.weapon_color}.uniq.length>1 && x.map{|q| q.weapon_type}.uniq.length<=1
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{x[0].weapon_type}"}
        z.unshift(moji[0].mention) unless moji.length<=0
      end
      z2=''
      if x.reject{|q| !q.legendary.nil?}.length<=0 && x.map{|q| q.legendary[0]}.uniq.length>1 && z[-1].include?('Ally_Boost_')
        z2="#{z[-1]}"
        z.pop
      end
      if x.reject{|q| !q.legendary.nil? && q.legendary[3]=='Legendary'}.length<=0 && x.map{|q| q.legendary[0]}.uniq.length>1
        z.push('<:Legendary_Effect_Unknown:443337603945857024>')
      elsif x.reject{|q| !q.legendary.nil? && q.legendary[3]=='Mythic'}.length<=0 && x.map{|q| q.legendary[0]}.uniq.length>1
        z.push('<:Mythic_Effect_Unknown:523328368079273984>')
      end
      z.push(z2) if z2.length>0
      for i in 0...z.length
        str=str.gsub(z[i],'')
        unless f.nil? || f.length<=0
          for i2 in 0...f.length
            f[i2][1]=f[i2][1].gsub(z[i],'')
          end
        end
      end
      b="#{b}#{z.join('')}"
    end
    create_embed(event,b,str,avg_color(x.map{|q| q.disp_color(0,1)}),nil,nil,f)
  end
  return nil
end

def get_games_list(arr,includefeh=true)
  g=[]
  lookout=$origames.map{|q| q}
  for i in 0...arr.length
    for i2 in 0...lookout.length
      g.push(lookout[i2][2]) if lookout[i2][0]==arr[i]
    end
  end
  g.push('FEH - *Fire Emblem: Heroes* (obviously)') if !g.include?('FEH - *Fire Emblem: Heroes*') && includefeh
  return g
end

def game_data(bot,event,args=[],xname=nil)
  (event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil) if xname.nil?
  data_load(['unit','game'])
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  x=find_data_ex(:find_unit,event,args,xname,bot,true)
  data_load(['unit','game'])
  if x.nil?
    event.respond "No matches found."
    return nil
  elsif x.is_a?(Array)
    y=x.map{|q| q.alts[0].gsub('*','')}
    if y.uniq.length<=1
      z=x[0].clone
      z.name=z.name.split('(')[0]
      z.name='Grima' if x.length==2 && x.map{|q| q.name}.include?('Robin(M)(Fallen)') && x.map{|q| q.name}.include?('Robin(F)(Fallen)')
      z.color_flag=[avg_color(x.map{|q| q.disp_color(0)}),avg_color(x.map{|q| q.disp_color(1)}),avg_color(x.map{|q| q.disp_color(2)}),avg_color(x.map{|q| q.disp_color(3)}),
                    avg_color(x.map{|q| q.disp_color(4)}),avg_color(x.map{|q| q.disp_color(5)}),avg_color(x.map{|q| q.disp_color(6)}),avg_color(x.map{|q| q.disp_color(7)}),
                    avg_color(x.map{|q| q.disp_color(8)}),avg_color(x.map{|q| q.disp_color(9)})]
      z.weapon[0]='Gold' unless x.map{|q| q.weapon[0]}.uniq.length<2
      z.weapon[1]='Unknown' unless x.map{|q| q.weapon[1]}.uniq.length<2
      z.weapon[2]='Unknown' unless x.map{|q| q.weapon[2]}.uniq.length<2 || z.weapon[1]!='Tome'
      z.movement='Unknown' unless x.map{|q| q.movement}.uniq.length<2
      for i in 0...x.length
        x[i].games[0]="*#{x[i].games[0]}"
      end
      z.games=x.map{|q| q.games}.flatten.uniq
      x=z.clone
    else
      for i in 0...x.length
        game_data(bot,event,args,x[i].name)
      end
      return nil
    end
  end
  str=''
  y=x.games.reject{|q| !q.include?('*')}
  y.unshift(x.games[0])
  y2=get_games_list(y.map{|q| q.gsub('*','')},false).uniq
  str="__**Credit in FEH**__\n#{y2.join("\n")}" if y2.length>0
  y=x.games.reject{|q| q.include?('*')}
  y3=y2.map{|q| q}
  y2=get_games_list(y)
  y2=get_games_list(y,false) if has_any?(x.games,['FEH','FEH*','*FEH'])
  y2=y2.reject{|q| y3.include?(q)}
  str="#{str}\n\n__**Other games**__\n#{y2.join("\n")}" if y2.length>0
  y=x.games.reject{|q| !q.include?('(a)')}
  y2=get_games_list(y.map{|q| q.gsub('(a)','')},false)
  str="#{str}\n\n__**Also appears via Amiibo functionality in**__\n#{y2.join("\n")}" if y2.length>0 && safe_to_spam?(event)
  y=x.games.reject{|q| !q.include?('(at)')}
  y2=get_games_list(y.map{|q| q.gsub('(at)','')},false)
  str="#{str}\n\n__**Also appears as an Assist Trophy in**__\n#{y2.join("\n")}" if y2.length>0 && safe_to_spam?(event)
  y=x.games.reject{|q| !q.include?('(m)')}
  y2=get_games_list(y.map{|q| q.gsub('(m)','')},false)
  str="#{str}\n\n__**Also appears as a Mii Costume in**__\n#{y2.join("\n")}" if y2.length>0 && safe_to_spam?(event)
  y=x.games.reject{|q| !q.include?('(s)')}
  y2=get_games_list(y.map{|q| q.gsub('(s)','')},false)
  str="#{str}\n\n__**Also appears as a Spirit in**__\n#{y2.join("\n")}" if y2.length>0 && safe_to_spam?(event)
  y=x.games.reject{|q| !q.include?('(t)')}
  y2=get_games_list(y.map{|q| q.gsub('(t)','')},false)
  str="#{str}\n\n__**Also appears as a standard trophy in**__\n#{y2.join("\n")}" if y2.length>0 && safe_to_spam?(event)
  y=x.games.reject{|q| !q.include?('(st)')}
  y2=get_games_list(y.map{|q| q.gsub('(st)','')},false)
  str="#{str}\n\n__**Also appears as a Sticker in**__\n#{y2.join("\n")}" if y2.length>0 && safe_to_spam?(event)
  ftr='Only the games in the "Credit in FEH" section are viable for Resonant Blades and Limited Hero Battles.'
  ftr=nil if x.games.map{|q| q.gsub('*','')}==['FEH']
  if str.length>1800
    str=str.split("\n\n")
    clr=0
    z=0
    hdr="__Games **#{x.name}#{x.emotes(bot,false)}** appears in__"
    thumb=x.thumbnail(event,bot)
    for i in 1...str.length
      if "#{str[z]}\n\n#{str[i]}".length>1900
        create_embed(event,hdr,str[z],x.disp_color(clr),nil,thumb)
        hdr=''
        z=i*1
        clr+=1
        thumb=nil
      else
        str[z]="#{str[z]}\n\n#{str[i]}"
      end
    end
    create_embed(event,hdr,str[z],x.disp_color(clr),ftr,thumb)
  elsif $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event.respond "__Games **#{x.name}#{x.emotes(bot,false)}** appears in__\n\n#{str.gsub('__','')}\n\n#{ftr}"
  else
    create_embed(event,"__Games **#{x.name}#{x.emotes(bot,false)}** appears in__",str,x.disp_color(0,1),ftr,x.thumbnail(event,bot))
  end
end

def path_data(bot,event,args=[],xname=nil)
  (event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil) if xname.nil?
  data_load(['unit','path'])
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  x=find_data_ex(:find_unit,event,args,xname,bot,true)
  data_load(['unit','path'])
  if x.nil?
    disp_current_paths(event,bot,-1)
    return nil
  elsif x.is_a?(Array)
    for i in 0...x.length
      path_data(bot,event,args,x[i].name)
    end
    return nil
  end
  m=$paths.reject{|q| !q.hasUnit?(x)}
  f=[]
  str=''
  for i in 0...m.length
    y=m[i].codes.map{|q2| "#{'**' if q2.unit_name==x.name}#{q2.rarity}#{Rarity_stars[0][q2.rarity-1]} #{q2.unit_name}#{q2.emotes(bot,false)} - #{q2.dispCost}#{'**' if q2.unit_name==x.name}"}
    if m[i].codes.length>1
      y.push('')
      mm=m[i].codes.find_index{|q| q.unit_name==x.name}
      if mm+1>=m[i].codes.length
        y.push("*total* - #{m[i].totalCost}")
      else
        y.push("*to #{x.name}* - #{m[i].totalCost(mm+1)}")
        y.push("*whole path* - #{m[i].totalCost}")
      end
    end
    if m[i].isCurrent? || m[i].isFuture?
      t=Time.now
      timeshift=8
      timeshift-=1 unless t.dst?
      t-=60*60*timeshift
      mdfr='left'
      mdfr='from now'
      y.push('')
      if m[i].isCurrent?
        t2=m[i].date_of_end.map{|q| q}
        t2=Time.new(t2[2],t2[1],t2[0])+24*60*60
        t2=t2-t
        t2+=24*60*60 if shift
      elsif m[i].isFuture?
        t2=m[i].date_of_start.map{|q| q}
        t2=Time.new(t2[2],t2[1],t2[0])-24*60*60
        t2=t2-t
      end
      tt2=(t2/(24*60*60)).floor
      if t2/(24*60*60)>1
        y.push("#{(t2/(24*60*60)).floor} days #{mdfr}")
      elsif t2/(60*60)>1
        y.push("#{(t2/(60*60)).floor} hours #{mdfr}")
      elsif t2/60>1
        y.push("#{(t2/60).floor} minutes #{mdfr}")
      elsif t2>1
        y.push("#{(t2).floor} seconds #{mdfr}")
      end
    end
    f.push([m[i].name,y.join("\n")])
  end
  hdr="__Divine Paths that **#{x.name}#{x.emotes(bot,false)}** is on__"
  hdr="__the Divine Path that **#{x.name}#{x.emotes(bot,false)}** is on__" if m.length==1
  hdr="__Divine Paths and **#{x.name}#{x.emotes(bot,false)}**__" if m.length<=0
  if f.map{|q| "__*#{q[0]}*__\n#{q[1]}"}.join("\n\n").length>1900 || $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    f=f.map{|q| ["__*#{q[0]}*__",q[1].gsub("\n\n","\n")]}
    f[0][0]="#{hdr}\n#{f[0][0]}"
    thm=x.thumbnail(event,bot)
    for i in 0...f.length
      create_embed(event,f[i][0],f[i][1],x.disp_color(i,1),nil,thm)
      thm=nil
    end
  else
    if f.length<=0
      f=nil
      str='No data'
    end
    create_embed(event,hdr,str,x.disp_color(0,1),nil,x.thumbnail(event,bot),f)
  end
end

def apply_combat_buffs(event,skillls,stats,phase,nerfs=[]) # used to apply in-combat buffs
  k=0
  k=event.server.id unless event.server.nil?
  skillls=skillls.map{|q| q}
  lookout=$statskills.reject{|q| !['Enemy Phase','Player Phase','In-Combat Buffs 1','In-Combat Buffs 2'].include?(q[3])}
  for i in 0...skillls.length
    statskl=lookout.find_index{|q| q[0]==skillls[i]}
    unless statskl.nil?
      statskl=lookout[statskl]
      if statskl[3]=='Player Phase' && phase=='Enemy'
      elsif statskl[3]=='Enemy Phase' && phase=='Player'
      elsif skillls[i][-6,6]==' Unity' && !nerfs.nil? && nerfs.length>4
        stats[1]+=5-2*nerfs[1] if skillls[i].include?('Atk')
        stats[2]+=5-2*nerfs[2] if skillls[i].include?('Spd')
        stats[3]+=5-2*nerfs[3] if skillls[i].include?('Def')
        stats[4]+=5-2*nerfs[4] if skillls[i].include?('Res')
      else
        stats[0]+=statskl[4][0]
        stats[1]+=statskl[4][1]
        stats[2]+=statskl[4][2]
        stats[3]+=statskl[4][3]
        stats[4]+=statskl[4][4]
      end
    end
  end
  return stats
end

def study_suite(mode='',bot=nil,event=nil,args=[],xname=nil)
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  (event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil) if xname.nil?
  data_load()
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  if args.nil?
    args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
    args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
    args.compact!
  else
    s2=args.join(' ')
    args=sever(s2.gsub(',','').gsub('/',''),true).split(' ')
    args.compact!
  end
  unit=find_data_ex(:find_unit,event,args,xname,bot,false,0,1)
  data_load()
  atext=''
  if unit.nil?
    event.respond 'No unit found.'
    return nil
  end
  w=first_sub(args.join(' ').downcase,unit[1].downcase,'')
  unit=unit[0]
  if unit.is_a?(Array) && (unit.map{|q| q.name}.reject{|q| ['Robin(M)','Robin(F)'].include?(q)}.length<=0 || unit.map{|q| q.name}.reject{|q| ['Kris(M)','Kris(F)'].include?(q)}.length<=0)
    unit=unit.sort{|a,b| a.name<=>b.name}
    atext=unit[1].availability[0]
    unit=unit[0].clone
    unit.name="#{unit.name.split('(')[0]} (shared stats)"
  elsif unit.is_a?(Array)
    if mode=='Proc'
      hlrs=unit.reject{|q| q.weapon_type != 'Staff'}
      if hlrs.length==1
        event.respond "**#{hlrs[0].name}#{hlrs[0].emotes(bot,false)}** is a healer and thus cannot use proc skills."
      elsif hlrs.length>0
        event.respond "The following units are healers and thus cannot use proc skills.\n#{hlrs.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
      end
      for i in 0...unit.length
        study_suite(mode,bot,event,args,unit[i].name) unless unit[i].weapon_type=='Staff'
      end
    elsif mode=='Heal'
      hlrs=unit.reject{|q| q.weapon_type=='Staff'}
      if hlrs.length==1
        event.respond "**#{hlrs[0].name}#{hlrs[0].emotes(bot,false)}** isn't a healer and thus cannot use healing staves."
      elsif hlrs.length>0
        event.respond "The following units aren't healers and thus cannot use healing staves.\n#{hlrs.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
      end
      for i in 0...unit.length
        study_suite(mode,bot,event,args,unit[i].name) if unit[i].weapon_type=='Staff'
      end
    else
      for i in 0...unit.length
        study_suite(mode,bot,event,args,unit[i].name)
      end
    end
    return unit.length
  elsif mode=='Proc' && unit.weapon_type=='Staff'
    event.respond "**#{unit.name}#{unit.emotes(bot,false)}** is a healer and thus cannot use proc skills."
    return 1
  elsif mode=='Heal' && unit.weapon_type != 'Staff'
    event.respond "**#{unit.name}#{unit.emotes(bot,false)}** isn't a healer and thus cannot use healing staves."
    return 1
  end
  flurp=find_stats_in_string(event,s,0,unit.name)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  support=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  flowers=flurp[8]
  resp=flurp[9]
  bonus=get_bonus_type(event)
  wpn=[]
  wpn=w.downcase.split(' ') unless w.nil?
  weapon=nil
  wpninvoke=''
  wpnlegal=true
  modename='stats'
  modename='effective HP' if mode=='effHP'
  modename='cohort stat buffs' if mode=='PairUp'
  modename='healing effects' if mode=='Heal'
  modename='proc skill damage' if mode=='Proc'
  modename='in-combat stats' if mode=='Phase'
  if has_any?(args,["mathoo's"]) || (has_any?(args,['my']) && event.user.id==167657750971547648)
    u=$dev_units.find_index{|q| q.name==unit.name}
    if u.nil?
      if $dev_nobodies.include?(unit.name)
        event.respond "Mathoo has that unit, but marked that he doesn't want to record #{unit.pronoun(true)} data.  Showing default data."
      elsif [$dev_somebodies,$dev_waifus].flatten.include?(unit.name)
        event.respond "Mathoo does not have that unit, much as he wants to.  Showing default data."
      else
        event.respond "Mathoo does not have that unit.  Showing default data."
      end
    else
      unit=$dev_units[u].clone
      resp=false
      resp=true if unit.resplendent=='r'
      wpnlegal=true
      y=unit.equippedWeapon
      weapon=y[0]
      refinement=y[1]
    end
  elsif donate_trigger_word(event)>0
    m=donate_trigger_word(event)
    u=$donor_units.find_index{|q| q.name==unit.name && q.owner_id==m}
    unless u.nil?
      unit=$donor_units[u].clone
      resp=false
      resp=true if unit.resplendent=='r'
      wpnlegal=true
      y=unit.equippedWeapon
      weapon=y[0]
      refinement=y[1]
    end
  elsif unit.stats40.max<=0 && unit.name != 'Kiran'
    event.respond "#{unit.name}#{unit.emotes(bot)} does not have official stats.  I cannot study #{'his' if unit.gender=='M'}#{'her' if unit.gender=='F'}#{'their' unless ['M','F'].include?(unit.gender)} #{modename}."
    return nil
  elsif unit.stats40[0,5].max<=0 && unit.name != 'Kiran' && bonus != 'Enemy'
    event.respond "#{unit.name}#{unit.emotes(bot)} does not have playable stats.  I cannot study #{'his' if unit.gender=='M'}#{'her' if unit.gender=='F'}#{'their' unless ['M','F'].include?(unit.gender)} #{modename}, unless you include the word \"enemy\" in your message."
    return nil
  end
  if wpn.include?('prf') && !unit.dispPrf(bonus).nil?
    wpninvoke='prf'
    weapon=unit.dispPrf(bonus)
  elsif wpn.include?('summoned') && ['Robin','Kris','Robin (shared stats)','Kris (shared stats)'].include?(xname)
    wpninvoke='summoned'
    x2=unit.summoned.map{|q2| q2.reject{|q| !q.type.include?('Weapon')}.sort{|a,b| a.id<=>b.id}}
    weapon=x2.map{|q| q[-1]} unless x2.length<=0
  elsif wpn.include?('summoned')
    wpninvoke='summoned'
    x2=unit.summoned.reject{|q| !q.type.include?('Weapon')}.sort{|a,b| a.id<=>b.id}
    weapon=x2[-1] unless x2.length<=0
  else
    weapon=find_data_ex(:find_skill,event,wpn,nil,bot,false,true)
    weapon=nil if weapon.is_a?(Array) && weapon.length<=0
    weapon=weapon[0] if weapon.is_a?(Array) && weapon.length>0
    unless weapon.nil?
      weapon=weapon.legalize(unit)
      if weapon[0].is_a?(Array)
        wpnlegal=!weapon.map{|q| q[1]}.include?(false)
        weapon=weapon.map{|q| q[0]}
      else
        wpnlegal=weapon[1]
        weapon=weapon[0]
      end
    end
  end
  diff=[0,0,0,0,0]
  if weapon.is_a?(Array)
    weapon=weapon.map{|q| q.clone}
    weapon[0].name=weapon.map{|q| q.name}.join(' / ')
    for i in 0...diff.length
      xx2=weapon.map{|q| q.weapon_stats[i]}
      diff[i]=xx2[0]-xx2[1]
    end
    weapon=weapon[0]
  end
  skill_list=make_stat_skill_list_1(unit.name,event,args)
  toptext="__#{"#{unit.owner}'s " unless unit.owner.nil?}**#{unit.name}#{unit.emotes(bot) unless safe_to_spam?(event)}**#{unit.submotes(bot) if safe_to_spam?(event)}__"
  if mode=='effHP'
    skill_list_2=make_stat_skill_list_2(unit.name,event,args)
    pairup=false
    pairup=true if has_any?(event.message.text.downcase.split(' '),['pairup','paired','pair']) && !unit.owner.nil?
    text=unit.starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup)
    px=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,[skill_list,skill_list_2].flatten,pairup)
    y=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup)
    py=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,[skill_list,skill_list_2].flatten,pairup)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,skill_list,pairup) unless wpnlegal
    px=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,[skill_list,skill_list_2].flatten,pairup) unless wpnlegal
    x.push([x[3],x[4]].min)
    y.push([y[3],y[4]].min)
    px.push([px[3],px[4]].min)
    py.push([py[3],py[4]].min)
    phys=[]; mag=[]; frz=[]
    phys.push("#{get_eff_hp(x,3,1)}#{" (#{get_eff_hp(px,3,1)})" unless get_eff_hp(x,3,1)==get_eff_hp(px,3,1)}")
    mag.push("#{get_eff_hp(x,4,1)}#{" (#{get_eff_hp(px,4,1)})" unless get_eff_hp(x,4,1)==get_eff_hp(px,4,1)}")
    frz.push("#{get_eff_hp(x,5,1)}#{" (#{get_eff_hp(px,5,1)})" unless get_eff_hp(x,5,1)==get_eff_hp(px,5,1)}")
    phys.push("#{get_eff_hp(x,3,2)}#{" (#{get_eff_hp(px,3,2)})" unless get_eff_hp(x,3,2)==get_eff_hp(px,3,2)}")
    mag.push("#{get_eff_hp(x,4,2)}#{" (#{get_eff_hp(px,4,2)})" unless get_eff_hp(x,4,2)==get_eff_hp(px,4,2)}")
    frz.push("#{get_eff_hp(x,5,2)}#{" (#{get_eff_hp(px,5,2)})" unless get_eff_hp(x,5,2)==get_eff_hp(px,5,2)}")
    phys.push("#{get_eff_hp(x,3,4)}#{" (#{get_eff_hp(px,3,4)})" unless get_eff_hp(x,3,4)==get_eff_hp(px,3,4)}")
    mag.push("#{get_eff_hp(x,4,4)}#{" (#{get_eff_hp(px,4,4)})" unless get_eff_hp(x,4,4)==get_eff_hp(px,4,4)}")
    frz.push("#{get_eff_hp(x,5,4)}#{" (#{get_eff_hp(px,5,4)})" unless get_eff_hp(x,5,4)==get_eff_hp(px,5,4)}")
    phys.push("#{get_eff_hp(y,3,1)}#{" (#{get_eff_hp(py,3,1)})" unless get_eff_hp(y,3,1)==get_eff_hp(py,3,1)}")
    mag.push("#{get_eff_hp(y,4,1)}#{" (#{get_eff_hp(py,4,1)})" unless get_eff_hp(y,4,1)==get_eff_hp(py,4,1)}")
    frz.push("#{get_eff_hp(y,5,1)}#{" (#{get_eff_hp(py,5,1)})" unless get_eff_hp(y,5,1)==get_eff_hp(py,5,1)}")
    phys.push("#{get_eff_hp(y,3,2)}#{" (#{get_eff_hp(py,3,2)})" unless get_eff_hp(y,3,2)==get_eff_hp(py,3,2)}")
    mag.push("#{get_eff_hp(y,4,2)}#{" (#{get_eff_hp(py,4,2)})" unless get_eff_hp(y,4,2)==get_eff_hp(py,4,2)}")
    frz.push("#{get_eff_hp(y,5,2)}#{" (#{get_eff_hp(py,5,2)})" unless get_eff_hp(y,5,2)==get_eff_hp(py,5,2)}")
    phys.push("#{get_eff_hp(y,3,4)}#{" (#{get_eff_hp(py,3,4)})" unless get_eff_hp(y,3,4)==get_eff_hp(py,3,4)}")
    mag.push("#{get_eff_hp(y,4,4)}#{" (#{get_eff_hp(py,4,4)})" unless get_eff_hp(y,4,4)==get_eff_hp(py,4,4)}")
    frz.push("#{get_eff_hp(y,5,4)}#{" (#{get_eff_hp(py,5,4)})" unless get_eff_hp(y,5,4)==get_eff_hp(py,5,4)}")
    phys="Single-hit: #{"~~#{phys[3]}~~ " unless phys[3]==phys[0]}#{phys[0]}\nDouble-hit: #{"~~#{phys[4]}~~ " unless phys[4]==phys[1]}#{phys[1]}\nQuadruple-hit: #{"~~#{phys[5]}~~ " unless phys[5]==phys[2]}#{phys[2]}"
    mag="Single-hit: #{"~~#{mag[3]}~~ " unless mag[3]==mag[0]}#{mag[0]}\nDouble-hit: #{"~~#{mag[4]}~~ " unless mag[4]==mag[1]}#{mag[1]}\nQuadruple-hit: #{"~~#{mag[5]}~~ " unless mag[5]==mag[2]}#{mag[2]}"
    frz="Single-hit: #{"~~#{frz[3]}~~ " unless frz[3]==frz[0]}#{frz[0]}\nDouble-hit: #{"~~#{frz[4]}~~ " unless frz[4]==frz[1]}#{frz[1]}\nQuadruple-hit: #{"~~#{frz[5]}~~ " unless frz[5]==frz[2]}#{frz[2]}"
    flds=[]
    if frz==phys && frz==mag
      flds.push(['<:HP_S:514712247503945739> All damage',frz])
    elsif frz==phys
      flds.push(['<:DefenseS:514712247461871616> Physical/Adaptive',phys])
      flds.push(['<:ResistanceS:514712247574986752> Magical',mag])
    elsif frz==mag
      flds.push(['<:DefenseS:514712247461871616> Physical',phys])
      flds.push(['<:ResistanceS:514712247574986752> Magical/Adaptive',mag])
    else
      flds.push(['<:DefenseS:514712247461871616> Physical',phys])
      flds.push(['<:FreezePrtS:712371368037187655> Adaptive',frz])
      flds.push(['<:ResistanceS:514712247574986752> Magical',mag])
    end
    spd=[]
    spd.push("#{x[2]+5}#{" (#{px[2]+5})" unless x[2]==px[2]}")
    spd.push("#{y[2]+5}#{" (#{py[2]+5})" unless x[2]==py[2]}")
    spd="#{"~~#{spd[1]}~~ " unless spd.uniq.length<=1}#{spd[0]}"
    photon=[0,0,0,0]
    photon[0]=7 if x[4]-x[3]>=5
    photon[1]=7 if px[4]-px[3]>=5
    photon[2]=7 if y[4]-y[3]>=5
    photon[3]=7 if py[4]-py[3]>=5
    photon.push("#{photon[0]}#{" (#{photon[1]})" unless photon[1]==photon[0]}")
    photon.push("#{photon[2]}#{" (#{photon[3]})" unless photon[3]==photon[2]}")
    photon="#{"~~#{photon[5]}~~ " unless photon[5]==photon[4]}#{photon[4]}"
    if safe_to_spam?(event) && (bonus=='Enemy' && unit.hasEnemyForm?)
      xm=[]
      xm.push("#{spd} Spd is required to double #{unit.name}.")
      xm.push("#{unit.name} receives #{photon} extra damage from Photon weapons.") unless photon=='0'
      unless unit.weapon_type=='Staff'
        attk=[]
        attk.push("#{5*x[1]/8}#{" (#{5*px[1]/8})" unless 5*x[1]/8==5*px[1]/8}")
        attk.push("#{5*y[1]/8}#{" (#{5*py[1]/8})" unless 5*x[1]/8==5*py[1]/8}")
        attk="#{"~~#{attk[1]}~~ " unless attk.uniq.length<=1}#{attk[0]}"
        xx=unit.atkName(true,weapon,refinement,transformed)
        xm.push("\nMoonbow becomes better than Glimmer when:\nThe enemy has #{attk} #{'Defense' if xx=='Strength'}#{'Resistance' if xx=='Magic'}#{'as the lower of Def/Res' if xx=='Freeze'}#{'as their targeted defense stat' if xx=='Attack'}")
      end
      flds.push(['Misc.',xm.join("\n"),1])
    else
      text="#{text}\n\n#{spd} Spd is required to double #{unit.name}."
      text="#{text}\n#{unit.name} receives #{photon} extra damage from Photon weapons." unless photon=='0'
    end
    flds[-1][2]=nil if flds.length>0 && flds.length<=2
  elsif mode=='PairUp'
    cohort_type='cohort unit'
    cohort_type='pocket buddy' if ['Sakura','Bernie'].include?(unit.alts[0]) && unit.owner=='Mathoo'
    toptext="__#{"#{unit.owner}'s " unless unit.owner.nil?}**#{unit.name}#{unit.emotes(bot) unless safe_to_spam?(event)}**#{unit.submotes(bot) if safe_to_spam?(event)} as a #{cohort_type}__"
    text=unit.starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,[],wpnlegal)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list)
    y=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,skill_list) unless wpnlegal
    x2=[0,0,0,0,0,0]
    y2=[0,0,0,0,0,0]
    text="#{text}\n"
    emu=unit.statEmotes(nil,nil,false,true,true).map{|q| "**#{q}**"}
    for i in 1...x.length
      l=10
      l=25 if i==1
      x2[i]=[[(x[i]-l)/10,4].min,0].max
      y2[i]=[[(y[i]-l)/10,4].min,0].max
      s="#{"~~+#{y2[i]}~~ " unless y2[i]==x2[i]}+#{x2[i]}"
      if diff[i]!=0
        x2[x.length]=[[(x[i]+diff[i]-l)/10,4].min,0].max
        y2[x.length]=[[(y[i]+diff[i]-l)/10,4].min,0].max
        s2="#{"~~+#{y2[x.length]}~~ " unless y2[x.length]==x2[x.length]}+#{x2[x.length]}"
        s="#{s} / #{s2}" unless s==s2
      end
      text="#{text}\n#{emu[i]} #{s}"
    end
  elsif mode=='Heal'
    skill_list_2=make_stat_skill_list_2(unit.name,event,args)
    pairup=false
    pairup=true if has_any?(event.message.text.downcase.split(' '),['pairup','paired','pair']) && !unit.owner.nil?
    text=unit.starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup)
    px=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,[skill_list,skill_list_2].flatten,pairup)
    y=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup)
    py=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,[skill_list,skill_list_2].flatten,pairup)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,skill_list,pairup) unless wpnlegal
    px=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,[skill_list,skill_list_2].flatten,pairup) unless wpnlegal
    showall=false
    showall=true if args.map{|q| q.downcase}.include?('all')
    showall=false unless safe_to_spam?(event)
    staves=[]
    staves.push("**Heal:** heals target for 5 HP, 15 HP when Imbue triggers\n\n**Mend:** heals target for 10 HP, 20 HP when Imbue triggers\n\n**Physic:** heals target for 8 HP, 18 HP when Imbue triggers") if showall
    d=[x[1]/2,8].max
    d2=[px[1]/2,8].max
    cd=[y[1]/2,8].max
    cd2=[py[1]/2,8].max
    i="#{d+10}#{" (#{d2+10})" unless d==d2}"
    ci="#{cd+10}#{" (#{cd2+10})" unless cd==cd2}"
    i="~~#{i}~~ #{ci}" unless i==ci
    d="#{d}#{" (#{d2})" unless d==d2}"
    cd="#{cd}#{" (#{cd2})" unless cd==cd2}"
    d="~~#{d}~~ #{cd}" unless d==cd
    staves.push("**Physic+:** heals target for #{d} HP, #{i} HP when Imbue triggers")
    staves.push('*Phsyic[+] has a range of 2*')
    staves.push('')
    staves.push("**Recover:** heals target for 15 HP, 25 HP when Imbue triggers") if showall
    d=[x[1]/2+10,15].max
    d2=[px[1]/2+10,15].max
    cd=[y[1]/2+10,15].max
    cd2=[py[1]/2+10,15].max
    i="#{d+10}#{" (#{d2+10})" unless d==d2}"
    ci="#{cd+10}#{" (#{cd2+10})" unless cd==cd2}"
    i="~~#{i}~~ #{ci}" unless i==ci
    d="#{d}#{" (#{d2})" unless d==d2}"
    cd="#{cd}#{" (#{cd2})" unless cd==cd2}"
    d="~~#{d}~~ #{cd}" unless d==cd
    staves.push("**Recover+:** heals target for #{d} HP, #{i} HP when Imbue triggers")
    staves.push('')
    staves.push("**Restore:** heals target for 8 HP, 18 HP when Imbue triggers") if showall
    d=[x[1]/2,8].max
    d2=[px[1]/2,8].max
    cd=[y[1]/2,8].max
    cd2=[py[1]/2,8].max
    i="#{d+10}#{" (#{d2+10})" unless d==d2}"
    ci="#{cd+10}#{" (#{cd2+10})" unless cd==cd2}"
    i="~~#{i}~~ #{ci}" unless i==ci
    d="#{d}#{" (#{d2})" unless d==d2}"
    cd="#{cd}#{" (#{cd2})" unless cd==cd2}"
    d="~~#{d}~~ #{cd}" unless d==cd
    staves.push("**Restore+:** heals target for #{d} HP, #{i} HP when Imbue triggers")
    staves.push('*Restore[+] will also remove any negative status effects placed on the target.*')
    staves.push('')
    d=x[0]-1
    d2=px[0]-1
    cd=y[0]-1
    cd2=py[0]-1
    s="0-#{d}#{" (0-#{d2})" unless d==d2}"
    cs="0-#{cd}#{" (0-#{cd2})" unless cd==cd2}"
    i="17-#{d+17}#{" (17-#{d2+17})" unless d==d2}"
    ci="17-#{cd+17}#{" (17-#{cd2+17})" unless cd==cd2}"
    d="7-#{d+7}#{" (7-#{d2+7})" unless d==d2}"
    cd="7-#{cd+7}#{" (7-#{cd2+7})" unless cd==cd2}"
    s="~~#{s}~~ #{cs}" unless s==cs
    i="~~#{i}~~ #{ci}" unless i==ci
    d="~~#{d}~~ #{cd}" unless d==cd
    staves.push("**Reconcile:** heals target for 7 HP, 17 HP when Imbue triggers, also heals #{unit.name} for 7 HP\n\n**Martyr:** heals target for #{d} HP, #{i} HP when Imbue triggers, also heals #{unit.name} for #{s} HP") if showall
    d=[x[0]-1,[x[1]/2,7].max]
    d2=[px[0]-1,[px[1]/2,7].max]
    cd=[y[0]-1,[y[1]/2,7].max]
    cd2=[py[0]-1,[py[1]/2,7].max]
    s="0-#{d[0]}#{" (0-#{d2[0]})" unless d[0]==d2[0]}"
    cs="0-#{cd[0]}#{" (0-#{cd2[0]})" unless cd[0]==cd2[0]}"
    i="#{d[1]+10}-#{d[0]+d[1]+10}#{" (#{d2[1]+10}-#{d2[0]+d2[1]+10})" unless d==d2}"
    ci="#{cd[1]+10}-#{cd[0]+cd[1]+10}#{" (#{cd2[1]+10}-#{cd2[0]+cd2[1]+10})" unless cd==cd2}"
    d="#{d[1]}-#{d[0]+d[1]}#{" (#{d2[1]}-#{d2[0]+d2[1]})" unless d==d2}"
    cd="#{cd[1]}-#{cd[0]+cd[1]}#{" (#{cd2[1]}-#{cd2[0]+cd2[1]})" unless cd==cd2}"
    i="~~#{i}~~ #{ci}" unless i==ci
    s="~~#{s}~~ #{cs}" unless s==cs
    d="~~#{d}~~ #{cd}" unless d==cd
    staves.push("**Martyr+:** heals target for #{d} HP, #{i} HP when Imbue triggers, also heals #{unit.name} for #{s} HP")
    staves.push("*How much Martyr[+] heals is based on how much damage* #{unit.name} *has taken.*")
    staves.push('')
    staves.push("**Rehabilitate:** heals target for 7-105 HP, 17-115 HP when Imbue triggers") if showall
    d=[x[1]/2-10,7].max
    d2=[px[1]/2-10,7].max
    cd=[y[1]/2-10,7].max
    cd2=[py[1]/2-10,7].max
    i="#{d+10}-#{d+108}#{" (#{d2+10}-#{d2+108})" unless d==d2}"
    ci="#{cd+10}-#{cd+108}#{" (#{cd2+10}-#{cd2+108})" unless cd==cd2}"
    d="#{d}-#{d+98}#{" (#{d2}-#{d2+98})" unless d==d2}"
    cd="#{cd}-#{cd+98}#{" (#{cd2}-#{cd2+98})" unless cd==cd2}"
    i="~~#{i}~~ #{ci}" unless i==ci
    d="~~#{d}~~ #{cd}" unless d==cd
    staves.push("**Rehabilitate+:** heals target for #{d} HP, #{i} HP when Imbue triggers")
    staves.push("*How much Rehabilitate[+] heals is based on how much damage the target has taken.*\n*If they are above 50% HP, the lower end of the range is how much is healed.*")
    text="#{text}\n\n#{staves.join("\n")}" if staves.length>0
  elsif mode=='Proc'
    skill_list_2=make_stat_skill_list_2(unit.name,event,args)
    pairup=false
    pairup=true if has_any?(event.message.text.downcase.split(' '),['pairup','paired','pair']) && !unit.owner.nil?
    skill_listx=[]
    for i in 0...args.length
      skill_listx.push('Wrath') if ['wrath','wrath1','wrath2','wrath3'].include?(args[i].downcase)
      skill_listx.push('Bushido') if ['bushido'].include?(args[i].downcase) && unit.name=='Ryoma(Supreme)'
    end
    skill_list.push(skill_listx[0,[skill_listx.length,2].min]) if skill_listx.length>0
    skill_list.flatten!
    text=unit.starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup)
    px=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,[skill_list,skill_list_2].flatten,pairup)
    y=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup)
    py=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,[skill_list,skill_list_2].flatten,pairup)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,skill_list,pairup) unless wpnlegal
    px=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,[skill_list,skill_list_2].flatten,pairup) unless wpnlegal
    to_add=[]
    if weapon.nil?
    elsif refinement.nil? || refinement.length==0
      m=weapon.tags.map{|q| q}
      m=m.map{|q| q.gsub(/\(T\)\(E\)|\(TE\)|\(E\)\(T\)|\(ET\)/,'(E)').gsub(/\(T\)\(R\)|\(TR\)|\(R\)\(T\)|\(RT\)/,'(R)')} if weapon.restrictions.include?('Beasts Only') && transformed
      m=m.reject{|q| !['(E)','(R)'].include?(q[0,3])}.reject{|q| q[3,5]!='WoDao' && q[3,6]!='Killer' && !['SlowSpecial','SpecialSlow'].include?(q[3,11])}
      mx=['Atk','Spd','Def','Res']
      mx=['Wrathful','Dazzling'] if weapon.restrictions.include?('Staff Users Only')
      if m.length<=0
      elsif m.length==1 && m[0][0,3]=='(R)'
        to_add.push("#{weapon.name} has a *#{m[0][3,m[0].length-3]}* effect when refined.  This can affect the proc calculations.\nTo include a refinement, try typing the weapon as \"#{weapon.name} (+) #{mx.sample} Mode\" instead.")
      elsif m.length==1 && m[0][0,3]=='(E)'
        to_add.push("#{weapon.name} has a *#{m[0][3,m[0].length-3]}* effect when refined into its Effect Mode.  This can affect the proc calculations.\nTo include a refinement, try typing the weapon as \"#{weapon.name} (+) Effect Mode\" instead.")
      else
        mx.unshift('Effect')
        mergetext="The following effects can be applied to #{weapon.name} via Weapon Refinement.  This can affect the proc calculations."
        m2=m.reject{|q| q[0,3]=='(E)'}.map{|q| q[3,q.length-3]}
        mergetext="#{mergetext}\nAll refinements: #{m2.join(',')}" if m2.length>0
        m2=m.reject{|q| q[0,3]=='(R)'}.map{|q| q[3,q.length-3]}
        mergetext="#{mergetext}\nEffect Mode only: #{m2.join(',')}" if m2.length>0
        mergetext="#{mergetext}\nTo include a refinement, try typing the weapon as \"#{weapon.name} (+) #{mx.sample} Mode\" instead."
        to_add.push(mergetext)
      end
    end
    if weapon.nil?
    elsif weapon.restrictions.include?('Beasts Only') && !transformed
      m=weapon.tags.map{|q| q}
      unless refinement.nil? || refinement.length==0
        m=m.map{|q| q.gsub(/\(T\)\(R\)|\(TR\)|\(R\)\(T\)|\(RT\)/,'(T)')}
        m=m.map{|q| q.gsub(/\(T\)\(E\)|\(TE\)|\(E\)\(T\)|\(ET\)/,'(T)')} if refinement=='Effect'
      end
      m=m.reject{|q| q[0,3]!='(T)'}.reject{|q| q[3,5]!='WoDao' && q[3,6]!='Killer' && !['SlowSpecial','SpecialSlow'].include?(q[3,11])}
      if m.length<=0
      elsif m.length==1
        to_add.push("#{weapon.name} has a *#{m[0][3,m[0].length-3]}* effect when #{unit.name} is transformed.\nTo show #{unit.name}'s data when transformed, include the word \"Transformed\" in your message.")
      else
        to_add.push("When #{unit.name} is transformed, #{w2[0]} also has the following effects:\n#{m.join(', ')}\nTo show #{unit.name}'s data when transformed, include the word \"Transformed\" in your message.")
      end
    end
    text="#{text}\n\n#{to_add.join("\n\n")}" if to_add.length>0
    ttags=[]
    unless weapon.nil?
      ttags=weapon.tags.map{|q| q}
      ttags=ttags.map{|q| q.gsub(/\(T\)\(E\)|\(TE\)|\(E\)\(T\)|\(ET\)/,'(E)').gsub(/\(T\)\(R\)|\(TR\)|\(R\)\(T\)|\(RT\)/,'(R)')} if transformed && weapon.restrictions.include?('Beasts Only')
      ttags=ttags.map{|q| q.gsub('(E)','')} if refinement=='Effect'
      ttags=ttags.map{|q| q.gsub('(R)','')} if !refinement.nil? && refinement.length>0
    end
    extradmg=0
    for i in 0...skill_list.length
      extradmg+=10 if ['Wrath','Bushido'].include?(skill_list[i])
    end
    extradmg2=extradmg*1
    extradmg+=10 if ttags.include?('WoDao') && wpnlegal
    extradmg2+=10 if ttags.include?('WoDao')
    cdmg=0; cdmg2=0
    cdmg+=10 if ttags.include?('WoDao_Star') && wpnlegal
    cdmg2+=10 if ttags.include?('WoDao_Star')
    data_load(['skills'])
    skl=$skills.reject{|q| !q.type.include?('Special') || !q.tags.include?('Offensive')}
    list=[]; flds=[]
    s=skl.find_index{|q| q.name=='Night Sky'}
    unless s.nil? || !args.include?('all')
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`dmg /2#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`dmg /2#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Astra'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`3* dmg /2#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`3* dmg /2#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Regnal Astra'}
    s=skl.find_index{|q| q.name=='Imperial Astra'} if s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[2]*2/5+extradmg2+cdmg2}#{" (#{py[2]*2/5+extradmg2+cdmg2})" unless y[2]*2/5==py[2]*2/5}"
      d2="#{x[2]*2/5+extradmg+cdmg}#{" (#{px[2]*2/5+extradmg+cdmg})" unless x[2]*2/5==px[2]*2/5}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{d}, cooldown of #{c}**")
    end
    s=skl.find_index{|q| q.name=='Glimmer'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`dmg /2#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`dmg /2#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Deadeye'}
    unless s.nil? || unit.weapon_type != 'Bow'
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`dmg#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`dmg#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("*#{s.name} - #{d}, cooldown of #{c}, negates damage reduction*")
    end
    flds.push(['<:Special_Offensive_Star:454473651396542504>Star',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if ttags.include?('WoDao_Moon') && wpnlegal
    cdmg2+=10 if ttags.include?('WoDao_Moon')
    s=skl.find_index{|q| q.name=='New Moon'}
    unless s.nil? || !args.include?('all')
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`3* eDR /10#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`3* eDR /10#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Luna'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`eDR /2#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`eDR /2#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Black Luna'}
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`4* eDR /5#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`4* eDR /5#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{d}, cooldown of #{c}**")
    end
    s=skl.find_index{|q| q.name=='Moonbow'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`3* eDR /10#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`3* eDR /10#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Lunar Flash'}
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`eDR /5 +#{extradmg2+cdmg2+y[2]}`#{" (`eDR /5 +#{extradmg2+cdmg2+py[2]}`)" unless y[2]==py[2]}"
      d2="`eDR /5 +#{extradmg+cdmg+x[2]}`#{" (`eDR /5 +#{extradmg+cdmg+px[2]}`)" unless x[2]==px[2]}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{d}, cooldown of #{c}**")
    end
    flds.push(['<:Special_Offensive_Moon:454473651345948683>Moon',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if ttags.include?('WoDao_Sun') && wpnlegal
    cdmg2+=10 if ttags.include?('WoDao_Sun')
    wd="#{"#{extradmg2+cdmg2}, " if extradmg2+cdmg2>0}"
    wd="~~#{extradmg2+cdmg2}~~ #{extradmg2+cdmg2}, " unless extradmg2+cdmg2==extradmg2+cdmg2
    s=skl.find_index{|q| q.name=='Daylight'}
    unless s.nil? || !args.include?('all')
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`3* #{"(" if extradmg2+cdmg2>0}dmg#{" +#{extradmg2+cdmg2})" if extradmg2+cdmg2>0} /10`"
      d2="`3* #{"(" if extradmg+cdmg>0}dmg#{" +#{extradmg+cdmg})" if extradmg+cdmg>0} /10`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{wd}heals for #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Sol'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`#{"(" if extradmg2+cdmg2>0}dmg#{" +#{extradmg2+cdmg2})" if extradmg2+cdmg2>0} /2`"
      d2="`#{"(" if extradmg+cdmg>0}dmg#{" +#{extradmg+cdmg})" if extradmg+cdmg>0} /2`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{wd}heals for #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Noontime'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`3* #{"(" if extradmg2+cdmg2>0}dmg#{" +#{extradmg2+cdmg2})" if extradmg2+cdmg2>0} /10`"
      d2="`3* #{"(" if extradmg+cdmg>0}dmg#{" +#{extradmg+cdmg})" if extradmg+cdmg>0} /10`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{wd}heals for #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Sirius'}
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      wd="#{y[2]*3/10+extradmg2+cdmg2}#{" (#{py[2]*3/10+extradmg2+cdmg2})" unless py[2]==y[2]}"
      wd2="#{x[2]*3/10+extradmg+cdmg}#{" (#{px[2]*3/10+extradmg+cdmg})" unless px[2]==x[2]}"
      wd="~~#{wd}~~ #{wd2}" unless wd==wd2
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`3*dmg/10#{" + #{(extradmg2+cdmg2+(y[2]*3/10))*3/10}" unless (extradmg2+cdmg2+(y[2]*3/10))*3/10==0}`"
      d2="`3*dmg/10#{" + #{(extradmg2+cdmg2+(py[2]*3/10))*3/10}" unless (extradmg2+cdmg2+(py[2]*3/10))*3/10==0}`"
      d="#{d} (#{d2})" unless d==d2
      d2="`3*dmg/10#{" + #{(extradmg+cdmg+(x[2]*3/10))*3/10}" unless (extradmg+cdmg+(x[2]*3/10))*3/10==0}`"
      d3="`3*dmg/10#{" + #{(extradmg+cdmg+(px[2]*3/10))*3/10}" unless (extradmg+cdmg+(px[2]*3/10))*3/10==0}`"
      d2="#{d2} (#{d3})" unless d3==d2
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{wd}, heals for #{d}, cooldown of #{c}**")
    end
    flds.push(['<:Special_Offensive_Sun:454473651429965834>Sun',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if has_any?(ttags,['WoDao_Moon','WoDao_Sun','WoDao_Eclipse']) && wpnlegal
    cdmg2+=10 if has_any?(ttags,['WoDao_Moon','WoDao_Sun','WoDao_Eclipse'])
    wd="`eDR /2#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
    wd2="`eDR /2#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
    wd="~~#{wd}~~ #{wd2}" unless wd==wd2
    d="`#{"(" if extradmg2+cdmg2>0}dmg#{" +#{extradmg2+cdmg2})" if extradmg2+cdmg2>0} /2 + eDR /4`"
    d2="`#{"(" if extradmg+cdmg>0}dmg#{" +#{extradmg+cdmg})" if extradmg+cdmg>0} /2 + eDR /4`"
    d="~~#{d}~~ #{d2}" unless d==d2
    s=skl.find_index{|q| q.name=='Aether'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      list.push("#{s.name} - #{wd}, heals for #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Radiant Aether'}
    s=skl.find_index{|q| q.name=='Mayhem Aether'} if s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      list.push("**#{s.name} - #{wd}, heals for #{d}, cooldown of #{c}**")
    end
    flds.push(['<:Special_Offensive_Eclipse:454473651308199956>Eclipse',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if ttags.include?('WoDao_Fire') && wpnlegal
    cdmg2+=10 if ttags.include?('WoDao_Fire')
    s=skl.find_index{|q| q.name=='Glowing Ember'}
    unless s.nil? || !args.include?('all')
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[3]/2+extradmg2+cdmg2}#{" (#{py[3]/2+extradmg2+cdmg2})" unless y[3]/2==py[3]/2}"
      d2="#{x[3]/2+extradmg+cdmg}#{" (#{px[3]/2+extradmg+cdmg})" unless x[3]/2==px[3]/2}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Ignis'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[3]*4/5+extradmg2+cdmg2}#{" (#{py[3]*4/5+extradmg2+cdmg2})" unless y[3]*4/5==py[3]*4/5}"
      d2="#{x[3]*4/5+extradmg+cdmg}#{" (#{px[3]*4/5+extradmg+cdmg})" unless x[3]*4/5==px[3]*4/5}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Seidr Shell'}
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{15+extradmg2+cdmg2}"
      d2="#{15+extradmg+cdmg}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{d}, adapts to weaker defense stat, cooldown of #{c}**")
    end
    s=skl.find_index{|q| q.name=='Bonfire'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[3]/2+extradmg2+cdmg2}#{" (#{py[3]/2+extradmg2+cdmg2})" unless y[3]/2==py[3]/2}"
      d2="#{x[3]/2+extradmg+cdmg}#{" (#{px[3]/2+extradmg+cdmg})" unless x[3]/2==px[3]/2}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Open the Future'}
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      wd="#{y[3]/2+extradmg2+cdmg2}#{" (#{py[3]/2+extradmg2+cdmg2})" unless y[3]/2==py[3]/2}"
      wd2="#{x[3]/2+extradmg+cdmg}#{" (#{px[3]/2+extradmg+cdmg})" unless x[3]/2==px[3]/2}"
      wd="~~#{wd}~~ #{wd2}" unless wd==wd2
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[3]/8+extradmg2/4+cdmg2/4}#{" (#{py[3]/8+extradmg2/4+cdmg2/4})" unless y[3]/8==py[3]/8}"
      d2="#{x[3]/8+extradmg/4+cdmg/4}#{" (#{px[3]/8+extradmg/4+cdmg/4})" unless x[3]/8==px[3]/8}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{wd}, heals for `dmg/4+#{d}`, cooldown of #{c}**")
    end
    s=skl.find_index{|q| q.name=='Blue Flame'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{extradmg2+cdmg2}-#{10+extradmg2+cdmg2}"
      d2="#{extradmg+cdmg}-#{10+extradmg+cdmg}"
      d="~~#{d}~~ #{d2}" unless d==d2
      dx="#{d}"
      d="#{extradmg2+cdmg2}-#{25+extradmg2+cdmg2}"
      d2="#{extradmg+cdmg}-#{25+extradmg+cdmg}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{dx} (#{d} when adjacent to an ally), cooldown of #{c}")
    end
    flds.push(['<:Special_Offensive_Fire:454473651861979156>Fire',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if ttags.include?('WoDao_Ice') && wpnlegal
    cdmg2+=10 if ttags.include?('WoDao_Ice')
    s=skl.find_index{|q| q.name=='Chilling Wind'}
    unless s.nil? || !args.include?('all')
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[4]/2+extradmg2+cdmg2}#{" (#{py[4]/2+extradmg2+cdmg2})" unless y[4]/2==py[4]/2}"
      d2="#{x[4]/2+extradmg+cdmg}#{" (#{px[4]/2+extradmg+cdmg})" unless x[4]/2==px[4]/2}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Glacies'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[4]*4/5+extradmg2+cdmg2}#{" (#{py[4]*4/5+extradmg2+cdmg2})" unless y[4]*4/5==py[4]*4/5}"
      d2="#{x[4]*4/5+extradmg+cdmg}#{" (#{px[4]*4/5+extradmg+cdmg})" unless x[4]*4/5==px[4]*4/5}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Iceberg'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[4]/2+extradmg2+cdmg2}#{" (#{py[4]/2+extradmg2+cdmg2})" unless y[4]/2==py[4]/2}"
      d2="#{x[4]/2+extradmg+cdmg}#{" (#{px[4]/2+extradmg+cdmg})" unless x[4]/2==px[4]/2}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Twin Blades'}
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[4]*2/5+extradmg2+cdmg2}#{" (#{py[4]*2/5+extradmg2+cdmg2})" unless y[4]*2/5==py[4]*2/5}"
      d2="#{x[4]*2/5+extradmg+cdmg}#{" (#{px[4]*2/5+extradmg+cdmg})" unless x[4]*2/5==px[4]*2/5}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{d}, cooldown of #{c}, negates damage reduction**")
    end
    flds.push(['<:Special_Offensive_Ice:454473651291422720>Ice',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if has_any?(ttags,['WoDao_Fire','WoDao_Ice','WoDao_Freezeflame']) && wpnlegal
    cdmg2+=10 if has_any?(ttags,['WoDao_Fire','WoDao_Ice','WoDao_Freezeflame'])
    s=skl.find_index{|q| q.name=='Freezeflame'}
    unless s.nil? || !skl[s].isPostable?(event) || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[3]/2+y[4]/2+extradmg2+cdmg2}#{" (#{py[3]/2+py[4]/2+extradmg2+cdmg2})" unless y[3]/2+y[4]/2==py[3]/2+py[4]/2}"
      d2="#{x[3]/2+x[4]/2+extradmg+cdmg}#{" (#{px[3]/2+px[4]/2+extradmg+cdmg})" unless x[3]/2+x[4]/2==px[3]/2+px[4]/2}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{d}, cooldown of #{c}**")
    end
    flds.push(['<:Special_Offensive_Fire:454473651861979156><:Special_Offensive_Ice:454473651291422720>Freezeflame',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if ttags.include?('WoDao_Dragon') && wpnlegal
    cdmg2+=10 if ttags.include?('WoDao_Dragon')
    s=skl.find_index{|q| q.name=='Dragon Gaze'}
    unless s.nil? || !args.include?('all')
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[1]*3/10+extradmg2+cdmg2}#{" (#{py[1]*3/10+extradmg2+cdmg2})" unless y[1]*3/10==py[1]*3/10}"
      d2="#{x[1]*3/10+extradmg+cdmg}#{" (#{px[1]*3/10+extradmg+cdmg})" unless x[1]*3/10==px[1]*3/10}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - Up to #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Dragon Fang'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[1]/2+extradmg2+cdmg2}#{" (#{py[1]/2+extradmg2+cdmg2})" unless y[1]/2==py[1]/2}"
      d2="#{x[1]/2+extradmg+cdmg}#{" (#{px[1]/2+extradmg+cdmg})" unless x[1]/2==px[1]/2}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - Up to #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Draconic Aura'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[1]*3/10+extradmg2+cdmg2}#{" (#{py[1]*3/10+extradmg2+cdmg2})" unless y[1]*3/10==py[1]*3/10}"
      d2="#{x[1]*3/10+extradmg+cdmg}#{" (#{px[1]*3/10+extradmg+cdmg})" unless x[1]*3/10==px[1]*3/10}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - Up to #{d}, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Fire Emblem'}
    s=skl.find_index{|q| q.name=="Hero's Blood"} if s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{y[2]*3/10+extradmg2+cdmg2}#{" (#{py[2]*3/10+extradmg2+cdmg2})" unless y[2]*3/10==py[2]*3/10}"
      d2="#{x[2]*3/10+extradmg+cdmg}#{" (#{px[2]*3/10+extradmg+cdmg})" unless x[2]*3/10==px[2]*3/10}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("**#{s.name} - #{d}, cooldown of #{c}**")
    end
    flds.push(['<:Special_Offensive_Dragon:454473651186696192>Dragon',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if ttags.include?('WoDao_Darkness') && wpnlegal
    cdmg2+=10 if ttags.include?('WoDao_Darkness')
    s=skl.find_index{|q| q.name=='Retribution'}
    unless s.nil? || !args.include?('all')
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{extradmg2+cdmg2}-#{y[0]*3/10+extradmg2+cdmg2}#{" (#{extradmg2+cdmg2}-#{py[0]*3/10+extradmg2+cdmg2})" unless y[0]*3/10==py[0]*3/10}"
      d2="#{extradmg+cdmg}-#{x[0]*3/10+extradmg+cdmg}#{" (#{extradmg+cdmg}-#{px[0]*3/10+extradmg+cdmg})" unless x[0]*3/10==px[0]*3/10}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d} based on HP lost, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Vengeance'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{extradmg2+cdmg2}-#{y[0]/2+extradmg2+cdmg2}#{" (#{extradmg2+cdmg2}-#{py[0]/2+extradmg2+cdmg2})" unless y[0]/2==py[0]/2}"
      d2="#{extradmg+cdmg}-#{x[0]/2+extradmg+cdmg}#{" (#{extradmg+cdmg}-#{px[0]/2+extradmg+cdmg})" unless x[0]/2==px[0]/2}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d} based on HP lost, cooldown of #{c}")
    end
    s=skl.find_index{|q| q.name=='Reprisal'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="#{extradmg2+cdmg2}-#{y[0]*3/10+extradmg2+cdmg2}#{" (#{extradmg2+cdmg2}-#{py[0]*3/10+extradmg2+cdmg2})" unless y[0]*3/10==py[0]*3/10}"
      d2="#{extradmg+cdmg}-#{x[0]*3/10+extradmg+cdmg}#{" (#{extradmg+cdmg}-#{px[0]*3/10+extradmg+cdmg})" unless x[0]*3/10==px[0]*3/10}"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d} based on HP lost, cooldown of #{c}")
    end
    flds.push(['<:Special_Offensive_Darkness:454473651010535435>Darkness',list.join("\n"),1]) if list.length>0
    list=[]; cdmg=0; cdmg2=0
    cdmg+=10 if ttags.include?('WoDao_Rend') && wpnlegal
    cdmg2+=10 if ttags.include?('WoDao_Rend')
    s=skl.find_index{|q| q.name=='Ruptured Sky'}
    unless s.nil?
      s=skl[s]
      c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
      d="`eAtk \* X /5#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
      d2="`eAtk \* X /5#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
      d="~~#{d}~~ #{d2}" unless d==d2
      list.push("#{s.name} - #{d}, where X is 2 against dragons/beasts and 1 against everyone else, cooldown of #{c}")
    end
    flds.push(['<:Special_Offensive_Rend:454473651119718401>Rend',list.join("\n"),1]) if list.length>0
    ftr="eDR = Enemy Def/Res, eAtk = Enemy Atk, DMG = Damage dealt by non-proc calculations"
  elsif mode=='Phase'
    data_load(['stats'])
    skill_list_2=make_stat_skill_list_2(unit.name,event,args)
    pairup=false
    pairup=true if has_any?(event.message.text.downcase.split(' '),['pairup','paired','pair']) && !unit.owner.nil?
    text=unit.starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup)
    px=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,[skill_list,skill_list_2].flatten,pairup)
    y=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup)
    py=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,[skill_list,skill_list_2].flatten,pairup)
    x=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,skill_list,pairup) unless wpnlegal
    px=unit.dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,[skill_list,skill_list_2].flatten,pairup) unless wpnlegal
    nicknames_load()
    k=0
    k=event.server.id unless event.server.nil?
    alz=$aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(k)}.map{|q| [q[1],q[2]]}
    skill_list_3=[]
    lookout=$statskills.reject{|q| !['Enemy Phase','Player Phase','In-Combat Buffs 1'].include?(q[3])}
    args2=args.map{|q| q.gsub('(','').gsub(')','').gsub('/','').gsub('.','').gsub('!','').downcase}
    for i in 0...lookout.length
      m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
      lookout[i][1]+=m
      for i2 in 0...lookout[i][2]
        skill_list_3.push(lookout[i][0]) if count_in(args2,lookout[i][1])>i2
      end
    end
    if unit.is_a?(SuperUnit)
      skill_list_3=[]
      m=unit.skills[3].reject{|q| q.include?('~~')}[-1].gsub('__','')
      skill_list_3.push(m) if lookout.map{|q| q[0]}.include?(m)
      m=unit.skills[6].reject{|q| q.include?('~~')}[-1].gsub('__','')
      skill_list_3.push(m) if lookout.map{|q| q[0]}.include?(m)
    end
    hf=[]
    hf2=[]
    # Only the first eight Spur/Goad/Ward skills are allowed, as that's the most that can apply to the unit at once.
    # Tactic skills stack with this list's limit, but allow up to fourteen to be applied
    lookout=$statskills.reject{|q| !['In-Combat Buffs 2'].include?(q[3])}
    for i in 0...lookout.length
      m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
      lookout[i][1]+=m
    end
    for i in 0...args.length
      skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
      unless skl.nil? || (lookout[skl][5] && unit.movement != lookout[skl][0].split(' ')[1][0,lookout[skl][0].split(' ')[1].length-1])
        skl=lookout[skl]
        if skl[2]==1
          hf.push(skl[0])
        elsif skl[2]==2
          hf2.push(skl[0])
        end
      end
    end
    for i in 0...8
      skill_list_3.push(hf[i]) if hf.length>i
    end
    for i in 0...14-[8,hf.length].min
      skill_list_3.push(hf2[i]) if hf2.length>i
    end
    text="#{text}\nIn-combat buffs: #{skill_list_3.join(', ')}" if skill_list_3.length>0
    flds=unit.statList(bot,false,diff,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup)
    merges=unit.merge_count*1 if unit.is_a?(SuperUnit)
    flds=flds.reject{|q| q[0]!="Level 40#{" +#{merges}" unless merges<=0}"}
    flds[0][0]='Displayed Stats'
    flds[0][1]=flds[0][1].gsub(' (+)','').gsub(' (-)','')
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2','Stat-Buffing 1','Stat-Buffing 2','Stat-Buffing 3','Stat-Nerfing 1','Stat-Nerfing 2','Stat-Nerfing 3'].include?(q[3])}
    buffs=[0,0,0,0,0]
    nerfs=[0,0,0,0,0]
    for i in 0...skill_list.length
      x=lookout.find_index{|q| q[0]==skill_list[i]}
      unless x.nil?
        xx=lookout[x][4]
        for i2 in 0...5
          buffs[i2]=[buffs[i2],xx[i2]].max if ['Stat-Buffing 1','Stat-Buffing 2','Stat-Buffing 3'].include?(lookout[x][3])
          nerfs[i2]=[nerfs[i2],0-xx[i2]].min if ['Stat-Nerfing 1','Stat-Nerfing 2','Stat-Nerfing 3'].include?(lookout[x][3])
        end
      end
    end
    # Harsh Command turns all nerfs into buffs
    if has_any?(skill_list,['Harsh Command','Harsh Command+'])
      for i in 0...5
        buffs[i]=[buffs[i],0-nerfs[i]].max
        nerfs[i]=0
      end
    end
    # Panic Ploy reverses all buffs (negative buffs are not the same as debuffs)
    if skill_list.include?('Panic Ploy')
      for i in 0...5
        buffs[i]=0-buffs[i]
      end
    end
    if !weapon.nil? && wpnlegal && weapon.has_tag?('Chainy',refinement,transformed)
      px[1]=0; px[2]=0; px[3]=0; px[4]=0
      py[1]=0; py[2]=0; py[3]=0; py[4]=0
      ftr="#{unit.name}'s in-combat stats are borrowed from #{unit.pronoun(true)} nearby allies, so #{unit.pronoun(true)} base stats are set to 0 for in-combat stat purposes."
    end
    pphase=apply_combat_buffs(event,skill_list_3,px.map{|q| q},'Player',nerfs)
    ephase=apply_combat_buffs(event,skill_list_3,px.map{|q| q},'Enemy',nerfs)
    pphase_c=apply_combat_buffs(event,skill_list_3,py.map{|q| q},'Player',nerfs)
    ephase_c=apply_combat_buffs(event,skill_list_3,py.map{|q| q},'Enemy',nerfs)
    unless weapon.nil?
      pphase[1]-=2*nerfs[1] if weapon.has_tag?('PenaltyReversal',refinement,transformed) || weapon.has_tag?('AtkPenaltyReversal',refinement,transformed)
      ephase[1]-=2*nerfs[1] if weapon.has_tag?('PenaltyReversal',refinement,transformed) || weapon.has_tag?('AtkPenaltyReversal',refinement,transformed)
      pphase[2]-=2*nerfs[2] if weapon.has_tag?('PenaltyReversal',refinement,transformed) || weapon.has_tag?('SpdPenaltyReversal',refinement,transformed)
      ephase[2]-=2*nerfs[2] if weapon.has_tag?('PenaltyReversal',refinement,transformed) || weapon.has_tag?('SpdPenaltyReversal',refinement,transformed)
      pphase[3]-=2*nerfs[3] if weapon.has_tag?('PenaltyReversal',refinement,transformed) || weapon.has_tag?('DefPenaltyReversal',refinement,transformed)
      ephase[3]-=2*nerfs[3] if weapon.has_tag?('PenaltyReversal',refinement,transformed) || weapon.has_tag?('DefPenaltyReversal',refinement,transformed)
      pphase[4]-=2*nerfs[4] if weapon.has_tag?('PenaltyReversal',refinement,transformed) || weapon.has_tag?('ResPenaltyReversal',refinement,transformed)
      ephase[4]-=2*nerfs[4] if weapon.has_tag?('PenaltyReversal',refinement,transformed) || weapon.has_tag?('ResPenaltyReversal',refinement,transformed)
    end
    m=[0,0,0,0,0]
    for i in 0...5
      m[i]=buffs[i]+nerfs[i]
    end
    if !weapon.nil? && weapon.has_tag?('Buffstuffer',refinement,transformed)
      for i in 1...5
        pphase[i]+=m[i] if m[i]>0
        ephase[i]+=m[i] if m[i]>0
      end
    end
    if skill_list_3.reject{|q| q.length<14 || q[0,14]!='Bonus Doubler '}.length>0
      m2=skill_list_3.reject{|q| q.length<14 || q[0,14]!='Bonus Doubler '}
      for i2 in 0...m2.length
        qq=m2[i2][14,m2[i2].length-14].to_i+1
        for i in 1...5
          pphase[i]+=m[i]*qq/4 if m[i]>0
          pphase_c[i]+=m[i]*qq/4 if m[i]>0
          ephase[i]+=m[i]*qq/4 if m[i]>0
          ephase_c[i]+=m[i]*qq/4 if m[i]>0
        end
      end
    end
    if !weapon.nil? && weapon.has_tag?('BonusBoostAtk',refinement,transformed) && stat_skills_2.length>0
      pphase[1]+=3
      ephase[1]+=3
    end
    if !weapon.nil? && weapon.has_tag?('BonusBoostSpd',refinement,transformed) && stat_skills_2.length>0
      pphase[2]+=3
      ephase[2]+=3
    end
    if !weapon.nil? && weapon.has_tag?('BonusBoostDef',refinement,transformed) && stat_skills_2.length>0
      pphase[3]+=3
      ephase[3]+=3
    end
    if !weapon.nil? && weapon.has_tag?('BonusBoostRes',refinement,transformed) && stat_skills_2.length>0
      pphase[4]+=3
      ephase[4]+=3
    end
    unless weapon.nil?
      desc = /((((I|i)f|(w|W)hen) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (attack|combat)))|during combat(| (if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (the |)(attack|combat))))), |)((G|g)rants|((T|t)he u|U|u)nit receives) ((Atk|Spd|Def|Res)(\/|))+?\+\d ((if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (attack|combat)))|during combat(| (if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (the |)(attack|combat)))))/
      desc2 = /((G|g)rants|((T|t)he u|U|u)nit receives) ((Atk|Spd|Def|Res)(\/|))+?\+\d during combat (if|when) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (the |)(attack|combat)))/
      desc3 = /((i|I)f|(W|w)hen) (the |)(foe (attacks|initiates (attack|combat))|unit (attacks|is (attacked|under attack)|initiates (the |)(attack|combat))), (grants|((T|t)he u|U|u)nit receives) ((Atk|Spd|Def|Res)(\/|))+?\+\d during combat/
      wpnnn=weapon.description
      x=desc.match(wpnnn).to_s
      x=desc2.match(wpnnn).to_s unless desc2.match(wpnnn).nil?
      x=desc3.match(wpnnn).to_s unless desc3.match(wpnnn).nil?
      x=nil if !x.nil? && x.include?('to allies') # remove any matches that include "to allies", which were caught in the prior line so they weren't considered non-phase-based
      x=nil if wpnnn.include?(", #{x}") && (wpnnn.include?('If foe uses') || wpnnn.include?('If foe initiates combat and uses'))
      x=nil if weapon.tags.include?('(R)Overwrite') && !refinement.nil? && refinement.length>0
      x3=[0,0,0,0,0]
      x3pp=[0,0,0,0,0]
      x3ep=[0,0,0,0,0]
      unless x.nil?
        x2=x.scan(/\d+?/)[0].to_i
        x3[1]+=x2 if x.include?('Atk')
        x3[2]+=x2 if x.include?('Spd')
        x3[3]+=x2 if x.include?('Def')
        x3[4]+=x2 if x.include?('Res')
        x3pp=x3.map{|q| q} unless x.include?('foe initiates') || x.include?('is attacked') || x.include?('is under attack') || x.include?('foe attacks')
        x3ep=x3.map{|q| q} unless x.include?('unit initiates') || x.include?('unit attacks')
      end
      unless refinement.nil? || refinement=='' || weapon.refine.nil? || weapon.refine.outer.nil?
        wpnnn=weapon.refine.outer
        x=desc.match(wpnnn).to_s
        x=desc2.match(wpnnn).to_s unless desc2.match(wpnnn).nil?
        x=desc3.match(wpnnn).to_s unless desc3.match(wpnnn).nil?
        x=nil if !x.nil? && x.include?('to allies') # remove any matches that include "to allies", which were caught in the prior line so they weren't considered non-phase-based
        x=nil if wpnnn.include?(", #{x}") && (wpnnn.include?('If foe uses') || wpnnn.include?('If foe initiates combat and uses'))
        unless x.nil?
          x2=x.scan(/\d+?/)[0].to_i
          x3=[0,0,0,0,0]
          x3[1]+=x2 if x.include?('Atk')
          x3[2]+=x2 if x.include?('Spd')
          x3[3]+=x2 if x.include?('Def')
          x3[4]+=x2 if x.include?('Res')
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
      unless weapon.refine.nil? || weapon.refine.inner.nil? || refinement != 'Effect'
        lookout=$statskills.reject{|q| !['Enemy Phase','Player Phase','In-Combat Buffs 1','In-Combat Buffs 2'].include?(q[3])}
        if weapon.refinement_name.nil? || lookout.find_index{|q| q[0]==weapon.refinement_name.fullName}.nil?
          x=desc.match(wpnnn).to_s
          x=desc2.match(wpnnn).to_s unless desc2.match(wpnnn).nil?
          x=desc3.match(wpnnn).to_s unless desc3.match(wpnnn).nil?
          x=nil if !x.nil? && x.include?('to allies') # remove any matches that include "to allies", which were caught in the prior line so they weren't considered non-phase-based
          x=nil if wpnnn.include?(", #{x}") && (wpnnn.include?('If foe uses') || wpnnn.include?('If foe initiates combat and uses'))
          x2=x.scan(/\d+?/)[0].to_i
          x3=[0,0,0,0,0,0]
          x3[1]+=x2 if x.include?('Atk')
          x3[2]+=x2 if x.include?('Spd')
          x3[3]+=x2 if x.include?('Def')
          x3[4]+=x2 if x.include?('Res')
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
        else
          skl=lookout[lookout.find_index{|q| q[0]==weapon.refinement_name.fullName}]
          if ['Enemy Phase','Player Phase','In-Combat Buffs 1','In-Combat Buffs 2'].include?(skl[3])
            x3=skl[4].map{|q| q}
            x3[5]=0
            unless skl[3]=='Enemy Phase'
              for i in 0...x3pp.length
                x3pp[i]=[x3pp[i],x3[i]].max
              end
            end
            unless skl[3]=='Player Phase'
              for i in 0...x3ep.length
                x3ep[i]=[x3ep[i],x3[i]].max
              end
            end
          end
        end
      end
      for i in 1...x3pp.length
        pphase[i]+=x3pp[i]
        ephase[i]+=x3ep[i]
      end
    end
    close=[0,0,0,0,0,0,0,0,0,0]
    distant=[0,0,0,0,0,0,0,0,0,0]
    for i in 0...skill_list_3.length
      if skill_list_3[i]=='Close Spectrum'
        close[1]+=4
        close[2]+=4
        close[3]+=4
        close[4]+=4
      elsif skill_list_3[i]=='Close Stance'
        close[1]+=4
        close[2]+=4
        close[3]+=4
        close[4]+=4
      elsif skill_list_3[i][0,12]=='Close Guard '
        close[3]+=skill_list_3[i].scan(/\d+?/)[0].to_i+1
        close[4]+=skill_list_3[i].scan(/\d+?/)[0].to_i+1
        close[8]+=skill_list_3[i].scan(/\d+?/)[0].to_i+1
        close[9]+=skill_list_3[i].scan(/\d+?/)[0].to_i+1
      elsif skill_list_3[i][0,6]=='Close '
        close[1]+=2*skill_list_3[i].scan(/\d+?/)[0].to_i if skill_list_3[i].include?('Atk')
        close[2]+=2*skill_list_3[i].scan(/\d+?/)[0].to_i if skill_list_3[i].include?('Spd')
        close[3]+=2*skill_list_3[i].scan(/\d+?/)[0].to_i if skill_list_3[i].include?('Def')
        close[4]+=2*skill_list_3[i].scan(/\d+?/)[0].to_i if skill_list_3[i].include?('Def')
      end
      if skill_list_3[i]=='Distant Spectrum'
        distant[1]+=4
        distant[2]+=4
        distant[3]+=4
        distant[4]+=4
      elsif skill_list_3[i]=='Distant Stance'
        distant[1]+=4
        distant[2]+=4
        distant[3]+=4
        distant[4]+=4
      elsif skill_list_3[i][0,14]=='Distant Guard '
        distant[3]+=skill_list_3[i].scan(/\d+?/)[0].to_i+1
        distant[4]+=skill_list_3[i].scan(/\d+?/)[0].to_i+1
        distant[8]+=skill_list_3[i].scan(/\d+?/)[0].to_i+1
        distant[9]+=skill_list_3[i].scan(/\d+?/)[0].to_i+1
      elsif skill_list_3[i][0,8]=='Distant '
        distant[1]+=2*skill_list_3[i].scan(/\d+?/)[0].to_i if skill_list_3[i].include?('Atk')
        distant[2]+=2*skill_list_3[i].scan(/\d+?/)[0].to_i if skill_list_3[i].include?('Spd')
        distant[3]+=2*skill_list_3[i].scan(/\d+?/)[0].to_i if skill_list_3[i].include?('Def')
        distant[4]+=2*skill_list_3[i].scan(/\d+?/)[0].to_i if skill_list_3[i].include?('Def')
      end
    end
    unless weapon.nil?
      xtags=weapon.tags.map{|q| q}
      for i in 0...xtags.length
        if xtags[i][0,1]=='(' && xtags[i][3,1]==')'
          if xtags[i][1,2]=='cP'
            close[6]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Atk'
            close[7]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Spd'
            close[8]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Def'
            close[9]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Res'
          elsif xtags[i][1,2]=='dP'
            distant[6]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Atk'
            distant[7]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Spd'
            distant[8]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Def'
            distant[9]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Res'
          elsif xtags[i][1,2]=='cE'
            close[1]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Atk'
            close[2]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Spd'
            close[3]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Def'
            close[4]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Res'
          elsif xtags[i][1,2]=='dE'
            distant[1]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Atk'
            distant[2]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Spd'
            distant[3]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Def'
            distant[4]+=xtags[i][8,tags[i].length-8].to_i if xtags[i][4,3]=='Res'
          end
        end
      end
    end
    for i in 0...close.length
      m=[close[i],distant[i]].min
      if i<5
        ephase_c[i]+=m
      else
        pphase_c[i-5]+=m
      end
      close[i]-=m
      distant[i]-=m
    end
    cc=close.map{|q| q}; dc=distant.map{|q| q}
    if has_any?(args,['defensetile','defencetile','deftile','defensivetile','defencivetile','defenseterrain','defenceterrain','defterrain','defensiveterrain','defenciveterrain'])
      pphase[3]=(pphase[3]*1.3).to_i
      ephase[3]=(ephase[3]*1.3).to_i
      pphase_c[3]=(pphase_c[3]*1.3).to_i
      ephase_c[3]=(ephase_c[3]*1.3).to_i
      cc[3]=(cc[3]*1.3).to_i
      dc[3]=(dc[3]*1.3).to_i
      cc[8]=(cc[8]*1.3).to_i
      dc[8]=(dc[8]*1.3).to_i
      pphase[4]=(pphase[4]*1.3).to_i
      ephase[4]=(ephase[4]*1.3).to_i
      pphase_c[4]=(pphase_c[4]*1.3).to_i
      ephase_c[4]=(ephase_c[4]*1.3).to_i
      cc[4]=(cc[4]*1.3).to_i
      dc[4]=(dc[4]*1.3).to_i
      cc[9]=(cc[9]*1.3).to_i
      dc[9]=(dc[9]*1.3).to_i
    end
    pphase_c.push(pphase_c[0]+pphase_c[1]+pphase_c[2]+pphase_c[3]+pphase_c[4])
    ephase_c.push(ephase_c[0]+ephase_c[1]+ephase_c[2]+ephase_c[3]+ephase_c[4])
    for i in 0...5
      pphase_c[i]="#{pphase_c[i]}#{" (+#{cc[i+5]} against melee)" if cc[i+5]>0}#{" (+#{dc[i+5]} against ranged)" if dc[i+5]>0}"
      ephase_c[i]="#{ephase_c[i]}#{" (+#{cc[i]} against melee)" if cc[i]>0}#{" (+#{dc[i]} against ranged)" if dc[i]>0}"
    end
    unless weapon.nil?
      if weapon.has_tag?('CloseStance',refinement,transformed)
        close[1]+=4
        close[2]+=4
        close[3]+=4
        close[4]+=4
      end
      if weapon.has_tag?('CloseDef',refinement,transformed)
        close[3]+=6
        close[4]+=6
      end
      close[1]+=6 if weapon.has_tag?('CloseAtk',refinement,transformed)
      close[2]+=6 if weapon.has_tag?('CloseSpd',refinement,transformed)
      if weapon.has_tag?('DistantStance',refinement,transformed)
        distant[1]+=4
        distant[2]+=4
        distant[3]+=4
        distant[4]+=4
      end
      if weapon.has_tag?('DistantDef',refinement,transformed)
        distant[3]+=6
        distant[4]+=6
      end
      distant[1]+=6 if weapon.has_tag?('DistantAtk',refinement,transformed)
      distant[2]+=6 if weapon.has_tag?('DistantSpd',refinement,transformed)
    end
    for i in 0...close.length
      m=[close[i],distant[i]].min
      if i<5
        ephase[i]+=m
      else
        pphase[i-5]+=m
      end
      close[i]-=m
      distant[i]-=m
    end
    if has_any?(args,['defensetile','defencetile','deftile','defensivetile','defencivetile','defenseterrain','defenceterrain','defterrain','defensiveterrain','defenciveterrain'])
      text="#{text}\nDefense tile"
      pphase[3]=(pphase[3]*1.3).to_i
      ephase[3]=(ephase[3]*1.3).to_i
      close[3]=(close[3]*1.3).to_i
      distant[3]=(distant[3]*1.3).to_i
      close[8]=(close[8]*1.3).to_i
      distant[8]=(distant[8]*1.3).to_i
      pphase[4]=(pphase[4]*1.3).to_i
      ephase[4]=(ephase[4]*1.3).to_i
      close[4]=(close[4]*1.3).to_i
      distant[4]=(distant[4]*1.3).to_i
      close[9]=(close[9]*1.3).to_i
      distant[9]=(distant[9]*1.3).to_i
    end
    pphase.push(pphase[0]+pphase[1]+pphase[2]+pphase[3]+pphase[4])
    ephase.push(ephase[0]+ephase[1]+ephase[2]+ephase[3]+ephase[4])
    for i in 0...5
      pphase[i]="#{pphase[i]}#{" (+#{close[i+5]} against melee)" if close[i+5]>0}#{" (+#{distant[i+5]} against ranged)" if distant[i+5]>0}"
      ephase[i]="#{ephase[i]}#{" (+#{close[i]} against melee)" if close[i]>0}#{" (+#{distant[i]} against ranged)" if distant[i]>0}"
    end
    if wpnlegal
      pphase_c=pphase.map{|q| q}
      ephase_c=ephase.map{|q| q}
    end
    for i in 0...pphase.length
      pphase[i]="~~#{pphase_c[i]}~~ #{pphase[i]}" if pphase[i]!=pphase_c[i] && !wpnlegal
    end
    for i in 0...ephase.length
      ephase[i]="~~#{ephase_c[i]}~~ #{ephase[i]}" if ephase[i]!=ephase_c[i] && !wpnlegal
    end
    if pphase[0,6]==ephase[0,6]
      w=unit.statEmotes(weapon,refinement,transformed,true)
      s="#{w[0]}: #{pphase[0]}"
      s="#{s}\n#{w[1]}: #{pphase[1]}"
      s="#{s}\n#{w[2]}: #{pphase[2]}"
      s="#{s}\n#{w[3]}: #{pphase[3]}"
      s="#{s}\n#{w[4]}: #{pphase[4]}"
      s="#{s}\n\nBST: #{pphase[5]}"
      flds.push(['In-combat stats',s])
    else
      wx=unit.statEmotes(weapon,refinement,transformed,true)[0]
      a=unit.atkName(true,weapon,refinement,transformed)
      s="#{wx}: #{pphase[0]}"
      s="#{s}\n<:Death_Blow:514719899868856340>#{a}: #{pphase[1]}"
      s="#{s}\n<:Darting_Blow:514719899910668298>Speed: #{pphase[2]}"
      s="#{s}\n<:Armored_Blow:514719899927576578>Defense: #{pphase[3]}"
      s="#{s}\n<:Warding_Blow:514719900607053824>Resistance: #{pphase[4]}"
      s="#{s}\n\nBST: #{pphase[5]}"
      flds.push(['Player Phase',s])
      s="#{wx}: #{ephase[0]}"
      s="#{s}\n<:Fierce_Stance:514719899873050624>#{a}: #{ephase[1]}"
      s="#{s}\n<:Darting_Stance:514719899919056926>Speed: #{ephase[2]}"
      s="#{s}\n<:Steady_Stance:514719899856273408>Defense: #{ephase[3]}"
      s="#{s}\n<:Warding_Stance:514719899562672138>Resistance: #{ephase[4]}"
      s="#{s}\n\nBST: #{ephase[5]}"
      flds.push(['Enemy Phase',s])
    end
  end
  header=unit.class_header(bot)
  if !safe_to_spam?(event)
    header=nil
  elsif header.length>250
    h=header.split("\n")
    header=[h[0],'']
    j=0
    for i in 1...h.length
      if "#{header[j]}\n#{h[i]}".length>250 && j==0
        j+=1
        header[j]="#{h[i]}"
      else
        header[j]="#{header[j]}\n#{h[i]}"
      end
    end
  end
  ftr="Include the word \"#{unit.bonus_type}\" to include bonus unit stats" if unit.bonus_type.length>0 && bonus.length<=0 && ftr.nil?
  unless wpninvoke.length>0 || weapon.nil? || weapon.name[-1]=='+' || weapon.next_steps(event,1).reject{|q| q.name[-1]!='+'}.length<=0 || !unit.owner.nil?
    ftr="You equipped the T#{weapon.tier} version of the weapon.  Perhaps you meant #{weapon.name}+ ?"
  end
  ftr="\"Photon\" is weapons like Light's Brand and Shining Bow that deal extra damage if Def is lower than Res by 5+." unless mode != 'effHP' || photon=='0'
  unless (diff.max==0 && diff.min==0) || mode != 'effHP'
    ftr="Stats displayed are for #{unit.name.split(' (')[0]}(M).  #{unit.name.split(' (')[0]}(F) has "
    if diff[0]!=0 || diff[2,3].reject{|q| q==0}.length>0
      ftr="#{ftr}the following stat changes: #{diff.map{|q| "#{'+' if q>0}#{q}"}.join('/')}"
    elsif photon=='0'
      ftr=nil
    else
      ftr="\"Photon\" is weapons like Light's Brand and Shining Bow that deal extra damage if Def is lower than Res by 5+."
    end
  end
  ftr='For the Kiran-shaped enemy in Book IV Ch. 12-5, type the name "Hood".' if unit.name=='Kiran'
  f=0
  f=ftr.length unless ftr.nil?
  if mode=='Proc' && flds.map{|q| "#{q[0]}\n#{q[1]}"}.join("\n\n").length+toptext.length+header.length+text.length+f>1900
    fx=[['Star'],['Moon','Sun','Eclipse'],['Fire','Ice','Freezeflame'],['Dragon'],['Darkness'],['Rend']]
    l=0
    f=[]
    thumb=unit.thumbnail(event,bot,resp)
    for i in 0...fx.length
      f2=flds.reject{|q| !fx[i].include?(q[0].split('>')[-1])}
      h=0
      h=header.length unless header.nil?
      if f.map{|q| "#{q[0]}\n#{q[1]}"}.join("\n\n").length+f2.map{|q| "#{q[0]}\n#{q[1]}"}.join("\n\n").length+toptext.length+h+text.length>1900
        create_embed(event,[toptext,header],text,unit.disp_color(l),nil,thumb,f)
        thumb=nil; toptext=''; header=nil; text=''; l+=1; f=f2.map{|q| q}
      else
        for i2 in 0...f2.length
          f.push(f2[i2])
        end
      end
    end
    create_embed(event,[toptext,header],text,unit.disp_color(l),ftr,thumb,f)
  elsif mode=='Heal' && toptext.length+header.length+text.length+f>1900
    text=text.split("\n\n")
    l=0
    str="#{text[0]}"
    thumb=unit.thumbnail(event,bot,resp)
    for i in 1...text.length
      h=0
      h=header.length unless header.nil?
      if toptext.length+h+"#{str}\n\n#{text[i]}".length>1900
        create_embed(event,[toptext,header],str,unit.disp_color(l),nil,thumb)
        thumb=nil; toptext=''; header=nil; l+=1; str="#{text[i]}"
      else
        str="#{str}\n\n#{text[i]}"
      end
    end
    create_embed(event,[toptext,header],str,unit.disp_color(l),ftr,thumb)
  else
    create_embed(event,[toptext,header],text,unit.disp_color,ftr,unit.thumbnail(event,bot,resp),flds)
  end
  return 1
end

def proc_study(bot,event,args=[],xname=nil); return study_suite('Proc',bot,event,args,xname); end
def heal_study(bot,event,args=[],xname=nil); return study_suite('Heal',bot,event,args,xname); end
def phase_study(bot,event,args=[],xname=nil); return study_suite('Phase',bot,event,args,xname); end
def pair_up(bot,event,args=[],xname=nil); return study_suite('PairUp',bot,event,args,xname); end
def effHP(bot,event,args=[],xname=nil); return study_suite('effHP',bot,event,args,xname); end

def get_eff_hp(arr=[0,0,0,0,0,0],slot=3,div=1)
  return arr[0]/div+arr[slot]
end

def generate_rarity_row(rarity=5,merges=0,games=[])
  stars="**#{rarity}-star**" if rarity==0 || rarity-1>Rarity_stars[0].length
  stars=Rarity_stars[0][rarity-1]*rarity
  stars=Rarity_stars[1][rarity-1]*rarity if merges>=Max_rarity_merge[1]
  stars=['<:FGO_icon_rarity_dark:571937156981981184>','<:FGO_icon_rarity_sickly:571937157095227402>','<:FGO_icon_rarity_rust:523903558928826372>','<:FGO_icon_rarity_mono:523903551144198145>','<:FGO_icon_rarity_gold:523858991571533825>'][rarity-1]*rarity if games[0]=='FGO'
  stars="#{stars}#{'<:Blank:676220519690928179>'*(6-rarity)}" if rarity<6
  stars="#{['','<:Rarity_1:532086056594440231>','<:Rarity_2:532086056254963713>','<:Rarity_3:532086056519204864>','<:Rarity_4:532086056301101067>','<:Rarity_5:532086056737177600>'][rarity]*rarity}#{['','<:Rarity_1_Blank:555459856476274691>','<:Rarity_2_Blank:555459856400908299>','<:Rarity_3_Blank:555459856568418314>','<:Rarity_4_Blank:555459856497246218>','<:Rarity_5_Blank:555459856190930955>'][rarity]*(Max_rarity_merge[0]-rarity)}#{'<:Blank:676220519690928179>' if Max_rarity_merge[0]<6}" if games[0]=='DL'
  stars="#{stars.gsub('<:Blank:676220519690928179>','')}**+#{merges}**" if merges>=Max_rarity_merge[1]
  return stars
end

def learnable_skills(bot,event,args=[],xname=nil)
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  (event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil) if xname.nil?
  data_load(['unit','skill'])
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  if args.nil?
    args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
    args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
    args.compact!
  end
  unit=find_data_ex(:find_unit,event,args,xname,bot,false,0,1)
  data_load(['unit','skill'])
  atext=''
  if unit.nil?
    event.respond 'No unit found.'
    return nil
  end
  unit=unit[0]
  if unit.is_a?(Array) && (unit.map{|q| q.name}.reject{|q| ['Robin(M)','Robin(F)'].include?(q)}.length<=0 || unit.map{|q| q.name}.reject{|q| ['Kris(M)','Kris(F)'].include?(q)}.length<=0)
    unit=unit.sort{|a,b| a.name<=>b.name}
    unit2=unit.clone
    unit=unit[0].clone
    unit.name=unit.name.split('(')[0]
  elsif unit.is_a?(Array)
    event.respond "That is multiple units.  Please choose one of the following:\n#{unit.map{|q| "#{q.name}#{q.emotes(bot)}"}.join("\n")}"
    return nil
  end
  sklz=$skills.reject{|q| !q.isPostable?(event) || 'Umbra '==q.name[0,6] || ['Whelp (All)','Yearling (All)','Adult (All)','Missiletainn','Falchion','Ragnarok+'].include?(q.name) || !q.can_inherit?(unit) || q.type==['Passive(W)']}
  m=[]
  sklz2=sklz.map{|q| q.clone}
  sklz=sklz.reject{|q| q.isPassive? && !q.level.nil? && !['-','example'].include?(q.level) && sklz.reject{|q2| q2.id/10!=q.id/10}.length>1}
  squad_initiate=[sklz.reject{|q| 'Squad Ace '!=q.name[0,10]}.length,sklz.reject{|q| 'Initiate Seal '!=q.name[0,14]}.length]
  unless has_any?(args.map{|q| q.downcase},['squadace','squad','all']) && safe_to_spam?(event)
    sklz=sklz.reject{|q| 'Squad Ace '==q.name[0,10]}
    m.push("#{squad_initiate[0]} *Squad Ace*")
  end
  unless has_any?(args.map{|q| q.downcase},['initiateseal','initiate','all']) && safe_to_spam?(event)
    sklz=sklz.reject{|q| 'Initiate Seal '==q.name[0,14]}
    m.push("#{squad_initiate[1]} *Initiate Seal*")
  end
  m="A total of #{m.join(' and ')} skills have been filtered out by default" if m.length>0
  m='' if m.length<=0
  for i in 0...sklz.length # display items with both the non-plus and + versions in the list as only one entry
    sklz[i].name="#{sklz[i].name.gsub('+','')}[+]" if sklz[i].name[-1]=='+' && sklz.map{|q| q.name}.include?(sklz[i].name.gsub('+',''))
  end
  x=sklz.map{|q| q.name}
  sklz=sklz.reject{|q| x.include?("#{q.name}[+]")}
  x=sklz.map{|q| q.id/10}.uniq
  y=[]
  for i in 0...x.length
    z=sklz.reject{|q| q.id/10 != x[i]}.sort{|a,b| a.id<=>b.id}
    if z[0].name[0,10]=='Falchion (' || (unit.name=='Kiran')
      z[0].name="**#{z[0].name}**" if z[0].type.include?('Weapon') && unit.name=='Kiran'
      y.push(z)
      y.flatten!
    elsif has_any?(z.map{|q| q.tags}.flatten,['Iron','Steel','Silver']) && z[-1].name.split(' ').length>1 && !z[0].restrictions.include?('Dragons Only')
      z[-1].name="#{z.map{|q| q.name.split(' ')[0]}.join('/')} #{z[-1].name.split{' '}[1,z[-1].name.split{' '}.length-1].join(' ')}"
      y.push(z[-1])
    else
      z[-1].name=z.map{|q| q.name}.join('/')
      y.push(z[-1])
    end
    unless y[-1].exclusivity.nil?
      if unit.name=='Kiran'
      elsif y[-1].prevos.nil? && !y[-1].learn.flatten.include?(unit.name)
        y[-1].name="~~*#{y[-1].name}*~~"
      elsif y[-1].learn.flatten.include?(unit.name)
        y[-1].name="**#{y[-1].name}**"
      else
        y[-1].name="*#{y[-1].name}*"
      end
    end
    y[-1].name="~~#{y[-1].name}~~" unless y[-1].name.include?('~~') || y[-1].fake.nil?
  end
  sklz=y.map{|q| q}
  wpn2=sklz.reject{|q| !q.type.include?('Weapon')}
  wpn=wpn2.map{|q| q.name}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
  ast2=sklz.reject{|q| !q.type.include?('Assist')}
  ast=ast2.map{|q| q.name}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
  spec2=sklz.reject{|q| !q.type.include?('Special')}
  spec=spec2.map{|q| q.name}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
  a2=sklz.reject{|q| !q.type.include?('Passive(A)')}
  a_pass=a2.map{|q| q.fullName('',false,sklz2)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
  b2=sklz.reject{|q| !q.type.include?('Passive(B)')}
  b_pass=b2.map{|q| q.fullName('',false,sklz2)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
  c2=sklz.reject{|q| !q.type.include?('Passive(C)')}
  c_pass=c2.map{|q| q.fullName('',false,sklz2)}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
  s2=sklz.reject{|q| !has_any?(q.type,['Seal','Passive(S)'])}
  s_pass=s2.map{|q| q.fullName('',false,sklz2.reject{|q2| !has_any?(q2.type,['Seal','Passive(S)'])})}.sort{|a,b| a.gsub('~~','').gsub('*','')<=>b.gsub('~~','').gsub('*','')}
  str=''
  if unit.name=='Robin'
    wpn=['**Tactical Storm**']
    zzz=$skills.reject{|q| !q.isPostable?(event) || !q.type.include?('Weapon') || !q.name.include?('+')}
    fr=zzz.reject{|q| !q.can_inherit?(unit2[0])}.map{|q| q.postName.gsub('Gronn','Clor').gsub('+','[+]')}
    mr=zzz.reject{|q| !q.can_inherit?(unit2[1])}.map{|q| q.postName.gsub('Blar','Clor').gsub('+','[+]')}
    mr=mr.reject{|q| !fr.include?(q)}
    wpn.push(mr)
    wpn.push('Cyan Egg[+]')
    wpn.push('Cyan Gift[+]')
    wpn.push('Silver Tome[+]')
    wpn.flatten!
    wpn=wpn.sort{|a,b| a.gsub('**','').gsub('~~','')<=>b.gsub('**','').gsub('~~','')}
  elsif unit.name=='Kris'
    wpn=['**Point of Shadow**']
    zzz=$skills.reject{|q| !q.isPostable?(event) || !q.type.include?('Weapon') || !q.name.include?('+')}
    fr=zzz.reject{|q| !q.can_inherit?(unit2[0])}.map{|q| q.postName.gsub('Lance','Point').gsub('Spear','Point').gsub('+','[+]')}
    mr=zzz.reject{|q| !q.can_inherit?(unit2[1])}.map{|q| q.postName.gsub('Blade','Point').gsub('Sword','Point').gsub('Edge','Point').gsub('+','[+]')}
    mr=mr.reject{|q| !fr.include?(q)}
    wpn.push(mr)
    wpn.push('Killer Point[+]')
    wpn.push('Gem Point[+]')
    wpn.push('Armorkilling Point[+]')
    wpn.push('Armorsmashing Point[+]')
    wpn.push('Wo Jian[+]')
    wpn.push('Pointguard[+]')
    wpn.push("Hunter's Point[+]")
    wpn.flatten!
    wpn=wpn.sort{|a,b| a.gsub('**','').gsub('~~','')<=>b.gsub('**','').gsub('~~','')}
  end
  if !safe_to_spam?(event)
    str="__**#{unit.name}#{unit.emotes(bot)}** can inherit:__"
    str="#{str}\n#{Skill_Slots[0][0]} #{wpn.length} Weapons"
    str="#{str}\n#{Skill_Slots[0][1]} #{ast.length} Assists"
    str="#{str}\n#{Skill_Slots[0][2]} #{spec.length} Specials"
    str="#{str}\n#{Skill_Slots[0][3]} #{a_pass.length} A Passives"
    str="#{str}\n#{Skill_Slots[0][4]} #{b_pass.length} B Passives"
    str="#{str}\n#{Skill_Slots[0][5]} #{c_pass.length} C Passives"
    str="#{str}\n\n__**#{unit.name}#{unit.emotes(bot)}** can #{Skill_Slots[0][6]}equip:__"
    str="#{str}\n#{s_pass.length} Passive Seals"
    str="#{str}\n#{squad_initiate[0]} Squad Ace seals"
    str="#{str}\n#{squad_initiate[1]} Initate Seal seals"
  elsif wpn.join("\n").length+ast.join("\n").length+spec.join("\n").length+a_pass.join("\n").length+b_pass.join("\n").length+c_pass.join("\n").length+s_pass.join("\n").length>1800
    if wpn.join("\n").length+ast.join("\n").length+spec.join("\n").length+a_pass.join("\n").length+b_pass.join("\n").length+c_pass.join("\n").length>1800
      if wpn.join("\n").length+ast.join("\n").length+spec.join("\n").length>1800
        if wpn.join("\n").length>1900
          str="__Skills that **#{unit.name}**#{unit.emotes(bot)} can learn__\n*#{Skill_Slots[0][0]} #{Skill_Slots[1][0]}s*: #{wpn[0]}"
          for i in 1...wpn.length
            str=extend_message(str,wpn[i],event,1,', ')
          end
          event.respond str
        else
          create_embed(event,"__Skills that **#{unit.name}**#{unit.emotes(bot)} can learn__\n__*#{Skill_Slots[0][0]} #{Skill_Slots[1][0]}s*__",'',wpn2[0].disp_color(1),nil,unit.thumbnail(event,bot),triple_finish(wpn))
        end
        if ast.join("\n").length+spec.join("\n").length>1900
          if ast.join("\n").length>1900
            str=extend_message(str,"*#{Skill_Slots[0][1]} #{Skill_Slots[1][1]}*: #{ast[0]}",event,2)
            for i in 1...ast.length
              str=extend_message(str,ast[i],event,1,', ')
            end
          else
            event.respond str unless str.length<=0
            str=''
            create_embed(event,"__*#{Skill_Slots[0][1]} #{Skill_Slots[1][1]}*__",'',ast2[0].disp_color,nil,nil,triple_finish(ast))
          end
          if spec.join("\n").length>1900
            str=extend_message(str,"*#{Skill_Slots[0][1]} #{Skill_Slots[1][1]}*: #{spec[0]}",event,2)
            for i in 1...spec.length
              str=extend_message(str,spec[i],event,1,', ')
            end
          else
            event.respond str unless str.length<=0
            str=''
            create_embed(event,"__*#{Skill_Slots[0][2]} #{Skill_Slots[1][2]}*__",'',spec2[0].disp_color,nil,nil,triple_finish(spec))
          end
        else
          event.respond str unless str.length<=0
          str=''
          flds=[]
          flds.push(["#{Skill_Slots[0][1]} #{Skill_Slots[1][1]}",ast.join("\n")])
          flds.push(["#{Skill_Slots[0][2]} #{Skill_Slots[1][2]}",spec.join("\n")])
          create_embed(event,'','',avg_color([ast2[0].disp_color,spec2[0].disp_color]),nil,nil,flds)
        end
      else
        flds=[]
        flds.push(["#{Skill_Slots[0][0]} #{Skill_Slots[1][0]}",wpn.join("\n")])
        flds.push(["#{Skill_Slots[0][1]} #{Skill_Slots[1][1]}",ast.join("\n")])
        flds.push(["#{Skill_Slots[0][2]} #{Skill_Slots[1][2]}",spec.join("\n")])
        create_embed(event,"__Skills that **#{unit.name}**#{unit.emotes(bot)} can learn__",'',unit.disp_color,nil,unit.thumbnail(event,bot),flds)
      end
      forcetext=false
      if a_pass.join("\n").length>1900
        str=extend_message(str,"*#{Skill_Slots[0][3]} #{Skill_Slots[1][3]}s*: #{a_pass[0]}",event,2)
        for i in 1...a_pass.length
          str=extend_message(str,a_pass[i],event,1,', ')
        end
        forcetext=true
      else
        event.respond str unless str.length<=0
        str=''
        create_embed(event,"__*#{Skill_Slots[0][3]} #{Skill_Slots[1][3]}s*__",'',a2[0].disp_color(1),nil,nil,triple_finish(a_pass))
      end
      if b_pass.join("\n").length>1900 || forcetext
        str=extend_message(str,"*#{Skill_Slots[0][4]} #{Skill_Slots[1][4]}s*: #{b_pass[0]}",event,2)
        for i in 1...b_pass.length
          str=extend_message(str,b_pass[i],event,1,', ')
        end
        forcetext=true
      else
        event.respond str unless str.length<=0
        str=''
        create_embed(event,"__*#{Skill_Slots[0][4]} #{Skill_Slots[1][4]}s*__",'',b2[0].disp_color(1),nil,nil,triple_finish(b_pass))
      end
      if c_pass.join("\n").length>1900 || forcetext
        str=extend_message(str,"*#{Skill_Slots[0][5]} #{Skill_Slots[1][5]}s*: #{c_pass[0]}",event,2)
        for i in 1...c_pass.length
          str=extend_message(str,c_pass[i],event,1,', ')
        end
      else
        event.respond str unless str.length<=0
        str=''
        create_embed(event,"__*#{Skill_Slots[0][5]} #{Skill_Slots[1][5]}s*__",'',c2[0].disp_color(1),nil,nil,triple_finish(c_pass))
      end
    else
      flds=[]
      flds.push(["#{Skill_Slots[0][0]} #{Skill_Slots[1][0]}",wpn.join("\n")])
      flds.push(["#{Skill_Slots[0][1]} #{Skill_Slots[1][1]}",ast.join("\n")])
      flds.push(["#{Skill_Slots[0][2]} #{Skill_Slots[1][2]}",spec.join("\n")])
      flds.push(["#{Skill_Slots[0][3]} #{Skill_Slots[1][3]}s",a_pass.join("\n")])
      flds.push(["#{Skill_Slots[0][4]} #{Skill_Slots[1][4]}s",b_pass.join("\n")])
      flds.push(["#{Skill_Slots[0][5]} #{Skill_Slots[1][5]}s",c_pass.join("\n")])
      create_embed(event,"__Skills that **#{unit.name}**#{unit.emotes(bot)} can learn__",'',unit.disp_color,nil,unit.thumbnail(event,bot),flds)
    end
    if s_pass.join("\n").length>1800 || forcetext
      str=extend_message(str,"*#{Skill_Slots[0][6]} #{Skill_Slots[1][6]}s that **#{unit.name}**#{unit.emotes(bot)} can equip*: #{s_pass[0]}",event,2)
      for i in 1...s_pass.length
        str=extend_message(str,s_pass[i],event,1,', ')
      end
      str=extend_message(str,"~~#{m}~~",event) if m.length>0
    else
      m=nil if m.length<=0
      create_embed(event,"__#{Skill_Slots[0][6]} #{Skill_Slots[1][6]}s that **#{unit.name}**#{unit.emotes(bot)} can equip__",'',s2[-1].disp_color(1),m,nil,triple_finish(s_pass))
    end
  else
    m=nil if m.length<=0
    flds=[]
    flds.push(["#{Skill_Slots[0][0]} #{Skill_Slots[1][0]}",wpn.join("\n")])
    flds.push(["#{Skill_Slots[0][1]} #{Skill_Slots[1][1]}",ast.join("\n")])
    flds.push(["#{Skill_Slots[0][2]} #{Skill_Slots[1][2]}",spec.join("\n")])
    flds.push(["#{Skill_Slots[0][3]} #{Skill_Slots[1][3]}",a_pass.join("\n")])
    flds.push(["#{Skill_Slots[0][4]} #{Skill_Slots[1][4]}",b_pass.join("\n")])
    flds.push(["#{Skill_Slots[0][5]} #{Skill_Slots[1][5]}",c_pass.join("\n")])
    flds.push(["#{Skill_Slots[0][6]} #{Skill_Slots[1][6]}",s_pass.join("\n")])
    create_embed(event,"__Skills that **#{unit.name}**#{unit.emotes(bot)} can learn__",'',unit.disp_color,m,unit.thumbnail(event,bot),flds)
  end
  event.respond str unless str.length<=0
  return nil
end

def unit_study(bot,event,args=[],xname=nil)
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  (event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil) if xname.nil?
  data_load(['unit'])
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  if args.nil?
    args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
    args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
    args.compact!
  end
  unit=find_data_ex(:find_unit,event,args,xname,bot,true)
  data_load(['unit'])
  atext=''
  if unit.nil?
    event.respond 'No unit found.'
    return nil
  end
  if unit.is_a?(Array) && (unit.map{|q| q.name}.reject{|q| ['Robin(M)','Robin(F)'].include?(q)}.length<=0 || unit.map{|q| q.name}.reject{|q| ['Kris(M)','Kris(F)'].include?(q)}.length<=0)
    unit=unit.sort{|a,b| a.name<=>b.name}
    atext=unit[1].availability[0]
    unit=unit[0].clone
    unit.name="#{unit.name.split('(')[0]} (shared stats)"
  elsif unit.is_a?(Array)
    for i in 0...unit.length
      unit_study(bot,event,args,unit[i].name)
    end
    return nil
  end
  flurp=find_stats_in_string(event,s,0,unit.name)
  boon=flurp[2]
  bane=flurp[3]
  resp=flurp[9]
  resp2=flurp[9]
  if has_any?(args,["mathoo's"]) || (has_any?(args,['my']) && event.user.id==167657750971547648)
    u=$dev_units.find_index{|q| q.name==unit.name}
    if u.nil?
      if $dev_nobodies.include?(unit.name)
        event.respond "Mathoo has that unit, but marked that he doesn't want to record #{unit.pronoun(true)} data.  Showing default data."
      elsif [$dev_somebodies,$dev_waifus].flatten.include?(unit.name)
        event.respond "Mathoo does not have that unit, much as he wants to.  Showing default data."
      else
        event.respond "Mathoo does not have that unit.  Showing default data."
      end
    else
      unit=$dev_units[u].clone
      resp=false
      resp=true if unit.resplendent.length>0
      resp2=false
      resp2=true if unit.resplendent=='r'
      boon="#{unit.boon}"
      bane="#{unit.bane}"
      merges=unit.merge_count*1
      lowest_rarity=unit.rarity*1
    end
  elsif donate_trigger_word(event)>0
    m=donate_trigger_word(event)
    u=$donor_units.find_index{|q| q.name==unit.name && q.owner_id==m}
    unless u.nil?
      unit=$donor_units[u].clone
      resp=false
      resp=true if unit.resplendent.length>0
      resp2=false
      resp2=true if unit.resplendent=='r'
      boon="#{unit.boon}"
      bane="#{unit.bane}"
      merges=unit.merge_count*1
      lowest_rarity=unit.rarity*1
    end
  elsif unit.stats40.max<=0 && unit.name != 'Kiran'
    event.respond "#{unit.name}#{unit.emotes(bot)} does not have official stats.  I cannot study #{'his' if unit.gender=='M'}#{'her' if unit.gender=='F'}#{'their' unless ['M','F'].include?(unit.gender)} stats."
    return nil
  elsif unit.stats40[0,5].max<=0 && unit.name != 'Kiran'
    event.respond "#{unit.name}#{unit.emotes(bot)} does not have playable stats.  There's no point to studying #{'his' if unit.gender=='M'}#{'her' if unit.gender=='F'}#{'their' unless ['M','F'].include?(unit.gender)} stats."
    return nil
  else
    merges=0
    lowest_rarity=Max_rarity_merge[0]*1
  end
  flds=[]
  text=''; text2=''
  if boon.gsub(' ','').length>0 && bane.gsub(' ','').length>0
    n=Natures.reject{|q| q[1]!=boon || q[2]!=bane}
    n2=n.map{|q| q[0]}.join('/')
    n2=n[0][0] if unit.atkName(true)=='Strength'
    n2=n[-1][0] if unit.atkName(true)=='Magic'
    n2=n[0][0] if !unit.owner.nil? && unit.atkName(true,unit.equippedWeapon[0],unit.equippedWeapon[1])=='Strength'
    n2=n[-1][0] if !unit.owner.nil? && unit.atkName(true,unit.equippedWeapon[0],unit.equippedWeapon[1])=='Magic'
    text2="+#{boon}, -#{bane} (#{n2})"
    text2="+#{boon}, ~~-#{bane}~~ (#{n2}, bane neutralized)" if !unit.owner.nil? && unit.rarity==Max_rarity_merge[0] && unit.merge_count>0
  elsif boon.gsub(' ','').length>0
    text2="+#{boon}"
  elsif bane.gsub(' ','').length>0
    text2="-#{bane}"
    text2="~~-#{bane}~~ (neutralized)" if !unit.owner.nil? && unit.rarity==Max_rarity_merge[0] && unit.merge_count>0
  else
    text2="Neutral nature"
  end
  text2="#{text2}\n<:Resplendent_Ascension:678748961607122945>Resplendent Ascension" if resp
  header=unit.class_header(bot)
  if header.length>250
    h=header.split("\n")
    header=[h[0],'']
    j=0
    for i in 1...h.length
      if "#{header[j]}\n#{h[i]}".length>250 && j==0
        j+=1
        header[j]="#{h[i]}"
      else
        header[j]="#{header[j]}\n#{h[i]}"
      end
    end
  elsif header.length+text2.length<=250
    header="#{header}\n#{text2}"
    text2=''
  end
  imp=[Max_rarity_merge[1]]; lowest_rarity=5
  if atext.length>0 && avail_text(unit.availability[0],true,unit,2)!=avail_text(atext,true,unit,2)
    m=avail_text(atext,true,unit,2)
    imp.push(m[2]) unless [imp,0].flatten.include?(m[2])
    lowest_rarity=[lowest_rarity,m[3]].min
    text="#{text}\n\n**Male**\n#{m[0].map{|q| q.gsub('**','*')}.join("\n")}"
    text="#{text}\n#{m[1].map{|q| q.gsub('**','*')}.join("\n")}" if m[1].length>0
    text="#{text}\n\n**Female**"
  end
  m=avail_text(unit.availability[0],true,unit,2)
  imp.push(m[2]) unless [imp,0].flatten.include?(m[2])
  lowest_rarity=[lowest_rarity,m[3]].min
  if text.include?('**Female**')
    m[0]=m[0].map{|q| q.gsub('**','*')}
    m[1]=m[1].map{|q| q.gsub('**','*')}
  end
  text="#{text}\n#{m[0].join("\n")}"
  text="#{text}\n#{m[1].join("\n")}" if m[1].length>0
  x=[-1,-1,-1,-1,-1,-1]
  lowest_rarity=1 if has_any?(args.map{|q| q.downcase},['rarities','full'])
  if unit.owner.nil?
    for i in lowest_rarity-1...Max_rarity_merge[0]
      x[i]=0
    end
  elsif unit.rarity>=Max_rarity_merge[0]
    x[unit.rarity-1]=unit.merge_count
  else
    x[unit.rarity-1]=unit.merge_count
    for i in unit.rarity...Max_rarity_merge[0]
      x[i]=0
    end
  end
  for i in 0...x.length
    unless x[i]<0
      h=generate_rarity_row(i+1,x[i],unit.games)
      s=[]
      for i2 in x[i]...Max_rarity_merge[1]+1
        if has_any?(args.map{|q| q.downcase},['merges','full']) || i2%5==0 || [imp,x[i]].flatten.include?(i2)
          s2=unit.base.dispStats(bot,40,i+1,boon,bane,i2,0,'','',[],resp)
          s3=s2.inject(0){|sum,x| sum + x }
          s4=unit.base.score(bot,40,i+1,boon,bane,i2,0,'','',[],resp)
          s.push("#{"**#{i2} merge#{'s' unless i2==1}:** " unless x[i]==Max_rarity_merge[1]}#{s2.join(' / ')}  \u200B  \u200B  BST: #{s3}  \u200B  \u200B  Score: #{s4.to_i}")
        end
      end
      flds.push([h,s.join("\n"),1])
    end
  end
  if flds.length<=1
    if text2.length>0
      text2="#{flds[0][0]}\n#{text2}\n\n#{flds[0][1]}"
    else
      text2=flds[0][0,2].join("\n")
    end
    flds=[]
  end
  text="#{text}\n\n#{text2}" if text2.length>0
  ftr=nil
  ftr="Include the word \"Resplendent\" to ascend this unit" if unit.hasResplendent? && !resp && unit.owner.nil?
  flds=flds.map{|q| ["#{q[0].gsub('<:Blank:676220519690928179>','')}#{'.' if q[0][-1]=='>'}",q[1],q[2]]} if flds.length>0 && flds.map{|q| q[0,2].join("\n")}.join("\n\n").length+header.length+text.length>1900
  flds=flds[flds.length-3,3] if flds.length>3 && flds.map{|q| q[0,2].join("\n")}.join("\n\n").length+header.length+text.length>1900 && !safe_to_spam?(event)
  ftr='For the Kiran-shaped enemy in Book IV Ch. 12-5, type the name "Hood".' if unit.name=='Kiran'
  f=0
  f=ftr.length unless ftr.nil?
  if flds.length>0 && flds.map{|q| q[0,2].join("\n")}.join("\n\n").length+header.length+text.length+f>1900
    create_embed(event,["__#{"#{unit.owner}'s " unless unit.owner.nil?}**#{unit.name}**#{unit.submotes(bot)}__",header],text,unit.disp_color,nil,unit.thumbnail(event,bot,resp2))
    for i in 0...flds.length
      create_embed(event,flds[i][0],flds[i][1],unit.disp_color(i+1))
    end
    event.respond ftr unless ftr.nil?
  else
    create_embed(event,["__#{"#{unit.owner}'s " unless unit.owner.nil?}**#{unit.name}**#{unit.submotes(bot)}__",header],text,unit.disp_color,ftr,unit.thumbnail(event,bot,resp2),flds)
  end
  return nil
end

def find_kiran_face(event,forcemathoo=false)
  args=event.message.text.downcase.split(' ')
  face=''
  face='Default' if has_any?(args,['default','og','hood'])
  face='Male 1' if has_any?(args,['male1','boy1','m1','man1'])
  face='Male 2' if has_any?(args,['male2','boy2','m2','man2'])
  face='Male 3' if has_any?(args,['male3','boy3','m3','man3'])
  face='Male 3' if has_any?(args,['male4','boy4','m4','man4'])
  face='Female 1' if has_any?(args,['female0','woman0','girl0','f0']) && event.user.id==167657750971547648
  face='Female 1' if has_any?(args,['female1','woman1','girl1','f1'])
  face='Female 2' if has_any?(args,['female2','woman2','girl2','f2'])
  face='Female 3' if has_any?(args,['female3','woman3','girl3','f3'])
  face='Female 3' if has_any?(args,['female4','woman4','girl4','f4'])
  if face.length<=0
    gender=''; level=-1
    m=1
    for i in 0...args.length
      level=args[i].to_i if args[i].to_i.to_s==args[i] && args[i].to_i>=m && args[i].to_i<=9
      gender='Male' if ['male','boy','m','man'].include?(args[i])
      gender='Female' if ['female','woman','girl','f'].include?(args[i])
    end
    if gender.length<=0 && level<0
      face='Default'
      face='Mathoo' if event.user.id==167657750971547648 && forcemathoo
    elsif gender.length<=0
      level=1 if level<1 && event.user.id != 167657750971547648
      level=0 if level<0
      face=['Female 0','Default','Male 1','Male 2','Male3','Female 1','Female 2','Female 3','Male 4','Female 4'][level]
    elsif level<0
      level=1
      level=0 if gender=='Female' && event.user.id==167657750971547648
    else
      level-=5 if level>4 && gender=='Female'
      level=1 if level<1 && gender=='Male'
      level=4 if level>4
    end
    face="#{gender} #{level}" unless gender.length<=0
  end
  return face
end

def disp_unit_art(bot,event,args=[],xname=nil)
  (event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil) if xname.nil?
  data_load()
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  x=find_data_ex(:find_unit,event,args,xname,bot,true)
  if x.nil?
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
      movement.push('Steam') if ['steam','mecha','mech','robot'].include?(args[i].downcase)
      movement.push('Infantry') if ['infantry','foot','feet'].include?(args[i].downcase)
      movement.push('Armor') if ['armor','armour','armors','armours','armored','armoured'].include?(args[i].downcase)
    end
    if colors.length<=0 && weapons.length<=0 && color_weapons.length<=0 && movement.length<=0
      x=find_data_ex(:find_unit,event,args,xname,bot)
      if x.nil?
        event.respond "No matches found."
      elsif x.is_a?(Array)
        for i in 0...x.length
          disp_unit_art(bot,event,args,x[i].name)
        end
      else  
        disp_unit_art(bot,event,args,x.name)
      end
      return nil
    end
    if colors.length<=0
      colors=['Red']
      colors=['Colorless'] if weapons.length>0 && ['Dagger','Staff','Bow'].include?(weapons[0])
    end
    weapons=['Tome'] if weapons.length<=0
    color_weapons=["#{colors[0]}_#{weapons[0]}".gsub('Red_Blade','Sword').gsub('Blue_Blade','Lance').gsub('Green_Blade','Axe')] if color_weapons.length<=0
    movement=['Infantry'] if movement.length<=0
    movement[0]='Flier' if color_weapons[0][color_weapons[0].length-6,6]=='Dragon' && ['Pegasus','Wyvern'].include?(movement[0])
    movement[0]='Cavalry' if movement[0]=='Steam' && !['Sword','Axe','Lance'].include?(color_weapons[0])
    art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/GENERICS/#{color_weapons[0]}_#{movement[0]}/BtlFace.png"
    if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      event.respond art
    else
      str="__Generic: **#{color_weapons[0]}_#{movement[0]}**__"
      str="__Generic: **#{movement[0]}_#{color_weapons[0]}**__" if movement[0]=='Steam'
      create_embed(event,str,'',0x800000,nil,[nil,art])
    end
    return nil
  elsif x.is_a?(Array)
    for i in 0...x.length
      disp_unit_art(bot,event,args,x[i].name)
    end
    return nil
  end
  data_load()
  artype=[]
  resp=false
  resp=true if has_any?(args.map{|q| q.downcase},['resplendant','resplendent','ascension','ascend','resplend','ex'])
  resp=true if args.join(' ').include?('resplend')
  resp=true if args.join(' ').include?('ascend')
  resp=true if args.join(' ').include?('ascension')
  resp=false unless x.hasResplendent?
  if has_any?(args,['sprite'])
    m=false
    IO.copy_stream(open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Sprites/#{x.name.gsub(' ','_')}#{'_Resplendent' if resp}.png"),"#{$location}devkit/FEHTemp#{Shardizard}.png") rescue m=true
    if File.size("#{$location}devkit/FEHTemp#{Shardizard}.png")>100 && !m
      artype=['Sprite','In-game Sprite ~~with default weapon~~']
      x.artist=nil
      x.voice_na=nil
      x.voice_jp=nil
    else
      artype=['Face',"~~Sprite not yet on site~~\nDefault"]
    end
  elsif x.name=='Kiran'
    face=find_kiran_face(event)
    artype=[face.gsub(' ',''),face]
  elsif has_any?(args,['battle','attack','att','atk','attacking'])
    artype=['BtlFace','Attack']
  elsif has_any?(args,['damage','damaged','lowhealth','lowhp','low_health','low_hp','injured']) || (args.include?('low') && has_any?(args,['health','hp']))
    artype=['BtlFace_D','Damaged']
  elsif has_any?(args,['critical','special','crit','proc'])
    artype=['BtlFace_C','Special']
  elsif has_any?(args,['loading','load','title']) && ['Alfonse','Sharena','Veronica','Eirika(Bonds)','Marth','Roy','Ike','Chrom(Launch)','Camilla(Launch)','Takumi','Lyn','Marth(Launch)','Roy(Launch)','Ike(World)','Takumi(Launch)','Lyn(Launch)','Reginn'].include?(x.name)
    artype=['Face_Load','Title Screen']
    x.artist=nil
  end
  if has_any?(args,["mathoo's"]) || (has_any?(args,['my']) && event.user.id==167657750971547648)
    u=$dev_units.find_index{|q| q.name==x.name}
    if u.nil?
      if $dev_nobodies.include?(unit.name)
        event.respond "Mathoo has that unit, but marked that he doesn't want to record #{unit.pronoun(true)} data.  Showing default data."
      elsif [$dev_somebodies,$dev_waifus].flatten.include?(unit.name)
        event.respond "Mathoo does not have that unit, much as he wants to.  Showing default data."
      else
        event.respond "Mathoo does not have that unit.  Showing default data."
      end
    else
      x=$dev_units[u].clone
      resp=false
      resp=true if x.resplendent=='r'
    end
  elsif donate_trigger_word(event)>0
    m=donate_trigger_word(event)
    u=$donor_units.find_index{|q| q.name==x.name && q.owner_id==m}
    unless u.nil?
      x=$donor_units[u].clone
      resp=false
      resp=true if x.resplendent=='r'
    end
  end
  if x.name=='Reinhardt(World)' && (rand(100).zero? || has_any?(args,['zelda','link']) || event.message.text.downcase.include?('master sword'))
    resp=false
    artype=['','Meme Zelda']
    x.artist[0]="u/ZachminSSB (ft. #{x.artist[0]})"
  end
  lookout=$skilltags.reject{|q| q[2]!='Art'}
  zart=[]
  for i in 0...lookout.length
    zart.push(lookout[i][0]) if has_any?(args,lookout[i][1])
  end
  if zart.include?('Normal2') && zart.length>1
    zart2=[]
    for i in 0...zart.length
      if zart[i]=='Normal2'
        zart2.push(zart[i])
      elsif lookout.map{|q| q[0]}.include?("#{zart[i]}2")
        zart2.push("#{zart[i]}2")
        zart2.push(zart[i])
      end
    end
    zart=zart2.map{|q| q}
  end
  if x.name=='Hrid'
    if zart.include?('Toasty')
      zart=zart.reject{|q| q=='Toasty'}
      zart2=zart.map{|q| "#{q}_Toasty"}
      zart2.push('Toasty')
      for i in 0...zart.length
        zart2.push(zart[i])
      end
      zart=zart2.map{|q| q}
    end
  else
    zart=zart.reject{|q| q=='Toasty'}
  end
  artype2=[]
  for i in 0...zart.length
    charza=x.name.gsub(' ','_')
    m=false
    IO.copy_stream(open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{charza}/Face_#{zart[i]}.png"), "#{$location}devkit/FEHTemp#{Shardizard}.png") rescue m=true
    unless File.size("#{$location}devkit/FEHTemp#{Shardizard}.png")<=100 || m || artype2.length>1
      artype2=["Face_#{zart[i]}","#{zart[i].gsub('_',' ')}"]
    end
  end
  artype=artype2.map{|q| q} if artype2.length>0
  artype=['Face','Default'] if artype.length<=0
  av=0
  av=1 if resp && !x.artist.nil? && x.artist.length>1
  unless x.voice_na.nil? || x.voice_na.length<=0 || !resp
    x.voice_na=x.voice_na.map{|q| q.gsub('Laura Bailey','Alexis Tipton')}
    x.voice_na=['Sara Beth'] if x.id==110
  end
  str=''
  str="#{str}\n**Artist:** #{x.artist[av].split(' as ')[-1]}" unless x.artist.nil?
  if x.name=='Kiran' && x.owner.nil?
    str="#{str}\n**VA:** >Player<"
  elsif x.name=='Kiran'
    str="#{str}\n**VA:** #{x.owner}"
  else
    str="#{str}\n**VA (English):** #{x.voice_na.map{|q| q.split(' as ')[-1]}.join(' & ')}" unless x.voice_na.nil? || x.voice_na.length<=0
    str="#{str}\n**VA (Japanese):** #{x.voice_jp.map{|q| q.split(' as ')[-1]}.join(' & ')}" unless x.voice_jp.nil? || x.voice_jp.length<=0
  end
  artist=''
  vana=[]
  vajp=[]
  xartist=x.artist[av].split(' as ')[0] unless x.artist.nil?
  vana=x.voice_na.map{|q| q.split(' as ')[0]} unless x.voice_na.nil? || x.voice_na.length<=0
  vajp=x.voice_jp.map{|q| q.split(' as ')[0]} unless x.voice_jp.nil? || x.voice_jp.length<=0
  xartist=';' if xartist.nil? || xartist.length<=0
  vana=[';'] if vana.length<=0
  vajp=[';'] if vajp.length<=0
  f=nil
  unless has_any?(args,['just','justart','blank','noinfo']) || (x.artist.nil? && (x.voice_na.nil? || x.voice_na.length<=0) && (x.voice_jp.nil? || x.voice_jp.nil?))
    f=[[],[],[], # FEH Unit data
       [],[],    # FGO Servant data
       [],       # FGO CE data
       [],       # DL Adventurer/Dragon/NPC data
       []]       # DL Wyrmprint data
    u=$units.reject{|q| q.name==x.name}
    data_load()
    if vana.length<2 && vajp.length<2
      f[1].push('Feh the Owl *[Voice 1]*') if vana[0]=='Kimberly Tierney' && vajp[0]=='Kimura Juri'
      f[1].push('Feh the Owl *[Voice 2]*') if vana[0]=='Cassandra Lee Morris' && vajp[0]=='Kimura Juri'
      f[1].push('Feh the Owl *[English 1]*') if vana[0]=='Kimberly Tierney' && vajp[0]!='Kimura Juri'
      f[1].push('Feh the Owl *[English 2]*') if vana[0]=='Cassandra Lee Morris' && vajp[0]!='Kimura Juri'
      f[1].push('Feh the Owl *[Japanese]*') if vana[0]!='Kimberly Tierney' && vana[0]!='Cassandra Lee Morris' && vajp[0]=='Kimura Juri'
      f[1].push('Fehnix the Owl *[Both]*') if vana[0]=='Patrick Seitz' && vajp[0]=='Koyasu Takehito'
      f[1].push('Fehnix the Owl *[English]*') if vana[0]=='Patrick Seitz' && vajp[0]!='Koyasu Takehito'
      f[1].push('Fehnix the Owl *[Japanese]*') if vana[0]!='Patrick Seitz' && vajp[0]=='Koyasu Takehito'
    end
    for i in 0...u.length
      u[i].artist=[] if u[i].artist.nil?
      u[i].voice_na=[] if u[i].voice_na.nil?
      u[i].voice_jp=[] if u[i].voice_jp.nil?
      u[i].artist=u[i].artist.map{|q| q.split(' as ')[0]}
      u[i].voice_na=u[i].voice_na.map{|q| q.split(' as ')[0]}
      u[i].voice_jp=u[i].voice_jp.map{|q| q.split(' as ')[0]}
      respvana=nil
      unless u[i].voice_na.nil? || u[i].voice_na.length<=0
        respvana=u[i].voice_na.map{|q| q}
        respvana=u[i].voice_na.map{|q| q.gsub('Laura Bailey','Alexis Tipton')}
        respvana=['Sara Beth'] if u[i].id==110
      end
      unless u[i].artist.nil? || u[i].artist.length<=0
        f[2].push(u[i].name) if u[i].artist[0]==xartist && u[i].voice_na==vana && u[i].voice_jp==vajp
        f[2].push("#{u[i].name} [Resplendent]") if u[i].artist[1]==xartist && respvana==vana && u[i].voice_jp==vajp
        f[0].push(u[i].name) if u[i].artist[0]==xartist && !(u[i].voice_na==vana && u[i].voice_jp==vajp)
        f[0].push("#{u[i].name} [Resplendent]") if u[i].artist[1]==xartist && !(respvana==vana && u[i].voice_jp==vajp)
      end
      if vana.length<2 && vajp.length<2
        if u[i].artist[0]!=xartist && u[i].voice_na==vana && u[i].voice_jp==vajp
          f[1].push("#{u[i].name} *[Both]*")
        elsif u[i].artist.length>1 && u[i].artist[1]!=xartist && respvana==vana && u[i].voice_jp==vajp
          f[1].push("#{u[i].name} [Resplendent] *[Both]*")
        elsif u[i].voice_na==vana && u[i].voice_jp != vajp
          f[1].push("#{u[i].name} *[English]*")
        elsif u[i].voice_na != vana && u[i].voice_jp==vajp
          f[1].push("#{u[i].name} *[Japanese]*")
        elsif respvana==vana && u[i].voice_jp != vajp
          f[1].push("#{u[i].name} [Resplendent] *[English]*")
        end
      elsif u[i].voice_na.length<2 && u[i].voice_jp.length<2
        vana2=u[i].voice_na[0]
        vajp2=u[i].voice_jp[0]
        e=[]
        for i2 in 0...vana.length
          e.push("#{i2+1}") if vana[i2]==vana2
          e.push("#{i2+1}R") if u[i].hasResplendent? && !respvana.nil? && vana[i2]==respvana[0] && !e.include?("#{i2+1}")
        end
        j=[]
        for i2 in 0...vajp.length
          j.push("#{i2+1}") if vajp[i2]==vajp2
        end
        v=e.reject{|q| !j.include?(q)}
        e=e.reject{|q| v.include?(q)}
        j=j.reject{|q| v.include?(q)}
        m=[]
        if e.length<=0 && j.length<=0 && v.length>0
          m.push("Voice #{v.join('+')}")
        elsif e.length<=0 && j.length>0 && v.length<=0
          m.push("Japanese #{j.join('+')}")
        elsif e.length>0 && j.length<=0 && v.length<=0
          m.push("English #{e.join('+')}")
        else
          m.push("voice #{v.join('+').downcase}") if v.length>0
          m.push("E#{e.join('+').downcase}") if e.length>0
          m.push("J#{j.join('+').downcase}") if j.length>0
        end
        f[1].push("#{u[i].name} *[#{m.join(', ')}]*") if m.length>0
      end
    end
    if event.server.nil? || !bot.user(502288364838322176).on(event.server.id).nil? || Shardizard==4
      data_load(['FGO'])
      u=$fgo_servants.uniq
      for i in 0...u.length
        unless u[i].artist.nil? || f[3].map{|q| q.split('.)')[0]}.include?("*[FGO-Srv]* #{u[i].id.to_i}")
          f[3].push("*[FGO-Srv]* #{u[i].id.to_i}.) #{u[i].name}") if u[i].artist.split(' as ')[0]==xartist
        end
        unless u[i].voice_jp.nil? || f[4].map{|q| q.split('.)')[0]}.include?("*[FGO-Srv]* #{u[i].id.to_i}")
          if vajp.length<=1
            f[4].push("*[FGO-Srv]* #{u[i].id.to_i}.) #{u[i].name} *[Japanese]*") if u[i].voice_jp.split(' as ')[0]==vajp[0]
          else
            for i2 in 0...vajp.length
              f[4].push("*[FGO-Srv]* #{u[i].id.to_i}.) #{u[i].name} *[Japanese #{i2+1}]*") if u[i].voice_jp.split(' as ')[0]==vajp[i2]
            end
          end
        end
      end
      u=$fgo_crafts.uniq
      for i in 0...u.length
        f[5].push("*[FGO-CE]* #{u[i].id.to_i}.) #{u[i].name}") if !u[i].artist.nil? && u[i].artist.split(' as ')[0]==xartist
      end
    end
    if event.server.nil? || !bot.user(543373018303299585).on(event.server.id).nil? || Shardizard==4
      data_load(['DL'])
      u=$dl_adventurers.uniq
      for i in 0...u.length
        if vana.length<2 && vajp.length<2
          if u[i].voice_na==vana[0] && u[i].voice_jp==vajp[0]
            f[6].push("*[DL-Adv]* #{u[i].name} *[Both]*")
          elsif u[i].voice_na==vana[0]
            f[6].push("*[DL-Adv]* #{u[i].name} *[English]*")
          elsif u[i].voice_jp==vajp[0]
            f[6].push("*[DL-Adv]* #{u[i].name} *[Japanese]*")
          end
        else
          vana2=u[i].voice_na
          vajp2=u[i].voice_jp
          e=[]
          for i2 in 0...vana.length
            e.push("#{i2+1}") if vana[i2]==vana2
          end
          j=[]
          for i2 in 0...vajp.length
            j.push("#{i2+1}") if vajp[i2]==vajp2
          end
          v=e.reject{|q| !j.include?(q)}
          e=e.reject{|q| v.include?(q)}
          j=j.reject{|q| v.include?(q)}
          m=[]
          if e.length<=0 && j.length<=0 && v.length>0
            m.push("Voice #{v.join('+')}")
          elsif e.length<=0 && j.length>0 && v.length<=0
            m.push("Japanese #{j.join('+')}")
          elsif e.length>0 && j.length<=0 && v.length<=0
            m.push("English #{e.join('+')}")
          else
            m.push("voice #{v.join('+').downcase}") if v.length>0
            m.push("E#{e.join('+').downcase}") if e.length>0
            m.push("J#{j.join('+').downcase}") if j.length>0
          end
          f[6].push("*[DL-Adv]* #{u[i].name} *[#{m.join(', ')}]*") if m.length>0
        end
      end
      u=$dl_dragons.uniq
      for i in 0...u.length
        if vana.length<2 && vajp.length<2
          if u[i].voice_na==vana[0] && u[i].voice_jp==vajp[0]
            f[6].push("*[DL-Drg]* #{u[i].name} *[Both]*")
          elsif u[i].voice_na==vana[0]
            f[6].push("*[DL-Drg]* #{u[i].name} *[English]*")
          elsif u[i].voice_jp==vajp[0]
            f[6].push("*[DL-Drg]* #{u[i].name} *[Japanese]*")
          end
        else
          vana2=u[i].voice_na
          vajp2=u[i].voice_jp
          e=[]
          for i2 in 0...vana.length
            e.push("#{i2+1}") if vana[i2]==vana2
          end
          j=[]
          for i2 in 0...vajp.length
            j.push("#{i2+1}") if vajp[i2]==vajp2
          end
          v=e.reject{|q| !j.include?(q)}
          e=e.reject{|q| v.include?(q)}
          j=j.reject{|q| v.include?(q)}
          m=[]
          if e.length<=0 && j.length<=0 && v.length>0
            m.push("Voice #{v.join('+')}")
          elsif e.length<=0 && j.length>0 && v.length<=0
            m.push("Japanese #{j.join('+')}")
          elsif e.length>0 && j.length<=0 && v.length<=0
            m.push("English #{e.join('+')}")
          else
            m.push("voice #{v.join('+').downcase}") if v.length>0
            m.push("E#{e.join('+').downcase}") if e.length>0
            m.push("J#{j.join('+').downcase}") if j.length>0
          end
          f[6].push("*[DL-Drg]* #{u[i].name} *[#{m.join(', ')}]*") if m.length>0
        end
      end
      u=$dl_npcs.uniq rescue []
      for i in 0...u.length
        if vana.length<2 && vajp.length<2
          if u[i].voice_na==vana[0] && u[i].voice_jp==vajp[0]
            f[6].push("*[DL-NPC]* #{u[i].name} *[Both]*")
          elsif u[i].voice_na==vana[0]
            f[6].push("*[DL-NPC]* #{u[i].name} *[English]*")
          elsif u[i].voice_jp==vajp[0]
            f[6].push("*[DL-NPC]* #{u[i].name} *[Japanese]*")
          end
        else
          vana2=u[i].voice_na
          vajp2=u[i].voice_jp
          e=[]
          for i2 in 0...vana.length
            e.push("#{i2+1}") if vana[i2]==vana2
          end
          j=[]
          for i2 in 0...vajp.length
            j.push("#{i2+1}") if vajp[i2]==vajp2
          end
          v=e.reject{|q| !j.include?(q)}
          e=e.reject{|q| v.include?(q)}
          j=j.reject{|q| v.include?(q)}
          m=[]
          if e.length<=0 && j.length<=0 && v.length>0
            m.push("Voice #{v.join('+')}")
          elsif e.length<=0 && j.length>0 && v.length<=0
            m.push("Japanese #{j.join('+')}")
          elsif e.length>0 && j.length<=0 && v.length<=0
            m.push("English #{e.join('+')}")
          else
            m.push("voice #{v.join('+').downcase}") if v.length>0
            m.push("E#{e.join('+').downcase}") if e.length>0
            m.push("J#{j.join('+').downcase}") if j.length>0
          end
          f[6].push("*[DL-NPC]* #{u[i].name} *[#{m.join(', ')}]*") if m.length>0
        end
      end
      u=$dl_wyrmprints.uniq
      for i in 0...u.length
        f[7].push("*[DL-Print]* #{u[i].name}") if !u[i].artist.nil? && u[i].artist.split(' as ')[0]==xartist
      end
    end
    f=[['Same Artist',[f[0].sort,f[3].uniq,f[5].uniq,f[7].uniq.sort].flatten],['Same VA',[f[1].sort,f[4].uniq,f[6].uniq.sort].flatten],['Same Everything',f[2].sort,1]]
    if f[1][1].length>0 && f[1][1][0].include?(' *[') && f[1][1].reject{|q| q.include?(f[1][1][0].split(' *[')[-1])}.length<=0
      f[1][0]="Same VA (#{f[1][1][0].split(' *[')[-1].gsub(']*','')})"
      f[1][1]=f[1][1].map{|q| q.split(' *[')[0,q.split(' *[').length-1].join(' *[')}
    end
    f=f.reject{|q| q[1].length<=0}.map{|q| [q[0],q[1].join("\n"),q[2]]}
    m=f.map{|q| q[1].split("\n").length}
    f=f.map{|q| q[0,2]} if f.length<3
    if m.inject(0){|sum,x2| sum + x2 }>25 && !safe_to_spam?(event)
      str="#{str}\n\nThere were too many units with the same artist and/or VA to list them all.  Please use this command in PM."
      f=nil
    elsif f.length<=0
    elsif f.length<=1 && !($embedless.include?(event.user.id) || was_embedless_mentioned?(event)) && f[0][1].split("\n").length<=5
      str="#{str}\n\n__*#{f[0][0]}*__\n#{f[0][1]}"
      f=nil
    elsif f.length<=1 && !($embedless.include?(event.user.id) || was_embedless_mentioned?(event))
      str="#{str}\n\n#{f[0][0]}"
      f=triple_finish(f[0][1].split("\n"),true)
    elsif $embedless.include?(event.user.id) || was_embedless_mentioned?(event) || "__#{"#{x.owner}'s " unless x.owner.nil?}**#{x.name}#{x.emotes(bot)}**__#{"\nResplendent Ascension<:Resplendent_Ascension:678748961607122945>" if resp}\n#{artype[1]}".length+str.length+f.map{|q| "__*#{q[0]}*__\n#{q[1]}"}.join("\n\n").length>1900 || m.max>25
      str2=''
      for i in 0...f.length
        if "**#{f[i][0]}:** #{f[i][1].gsub("\n",' - ')}".length>1500
          f[i][1]=f[i][1].split("\n")
          str2=extend_message(str2,"**#{f[i][0]}:** #{f[i][1][0]}",event)
          for i2 in 1...f[i][1].length
            str2=extend_message(str2,f[i][1][i2],event,1,' - ')
          end
        else
          str2=extend_message(str2,"**#{f[i][0]}:** #{f[i][1].gsub("\n",' - ')}",event)
        end
      end
      event.respond str2
      f=nil
    end
  end
  hdr="__#{"#{x.owner}'s " unless x.owner.nil?}**#{x.name}#{x.emotes(bot)}**__"
  if x.is_a?(DevUnit) && x.name=='Alm(Saint)'
    x2=$dev_units.find_index{|q| q.name=='Sakura'}
    unless x2.nil?
      x2=$dev_units[x2]
      hdr="#{hdr}\nPocket companion: *#{x2.name}*#{x2.emotes(bot)}"
    end
  elsif x.is_a?(DevUnit) && x.name=='Kiran' && x.face=='Mathoo'
    h=[]
    x2=$dev_units.find_index{|q| q.name=='Sakura'}
    unless x2.nil?
      x2=$dev_units[x2]
      h.push("*#{x2.name}*#{x2.emotes(bot)}")
    end
    x2=$dev_units.find_index{|q| q.name=='Bernie'}
    unless x2.nil?
      x2=$dev_units[x2]
      h.push("*#{x2.name}*#{x2.emotes(bot)}")
    end
    x2=$dev_units.find_index{|q| q.name=='Mirabilis'}
    unless x2.nil?
      x2=$dev_units[x2]
      h.push("*#{x2.name}*#{x2.emotes(bot)}")
    end
    hdr="#{hdr}\nPocket companions: #{list_lift(h,'and')}" unless h.length<=0
  end
  hdr="#{hdr}\nResplendent Ascension<:Resplendent_Ascension:678748961607122945>" if resp
  hdr="#{hdr}\n#{artype[1]}"
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    str="#{hdr}\n#{str}"
    str="#{str}\n\n#{x.portrait(artype[0],resp)}"
    str="#{str}\n\nThis unit has a Resplendent Ascension.  Include the word \"Resplendent\" to look at that art." if x.hasResplendent? && !resp && artype[0]!='Face_Load'
    event.respond str
  else
    ftr=nil
    ftr="This unit has a Resplendent Ascension.  Include the word \"Resplendent\" to look at that art." if x.hasResplendent? && !resp && artype[0]!='Face_Load'
    create_embed(event,hdr,str,x.disp_color(0,1),ftr,[nil,x.portrait(artype[0],resp)],f)
  end
end

def date_display(event,t,shift=false)
  str="Time elapsed since today's reset: #{"#{t.hour} hours, " if t.hour>0}#{"#{'0' if t.min<10}#{t.min} minutes, " if t.hour>0 || t.min>0}#{'0' if t.sec<10}#{t.sec} seconds"
  str="#{str}\nTime until tomorrow's reset: #{"#{23-t.hour} hours, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds"
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  if shift
    str="Tomorrow's date: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
    str="#{str}\nDays since game release, come tomorrow: #{longFormattedNumber(date)}"
  else
    str="#{str}\nThe Arena season ends in #{"#{15-t.hour} hours, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete your daily Arena-related quests before then!" if date%7==4 && 15-t.hour>=0
    str="#{str}\nThe Aether Raid season ends in #{"#{15-t.hour} hours, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete any Aether-related quests before then!" if date%7==4 && 15-t.hour>=0
    str="#{str}\nThe monthly quests end in #{"#{23-t.hour} hours, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete them before then!" if t.month != (t+24*60*60).month
    str="#{str}\n\nDate assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
    str="#{str}\nDays since game release: #{longFormattedNumber(date)}"
  end
  if event.user.id==167657750971547648 && Shardizard==4
    str="#{str}\n#{"Tomorrow's d" if shift}#{'D' unless shift}aycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12"
    str="#{str}\n#{"Tomorrow's w" if shift}#{'W' unless shift}eekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%6+1}/6(Saturday) - #{week_from(date,0)%12+1}/12(Thursday) - #{week_from(date,3)%31+1}/31(Sunday)"
  end
  return str
end

def today_in_feh(event,bot,shift=false,chain='')
  colors=['Green <:Shard_Green:443733397190344714><:Crystal_Verdant:445510676845166592><:Badge_Verdant:445510676056899594><:Great_Badge_Verdant:443704780943261707>',
          'Colorless <:Shard_Colorless:443733396921909248><:Crystal_Transparent:445510676295843870><:Badge_Transparent:445510675976945664><:Great_Badge_Transparent:443704781597573120>',
          'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Red <:Shard_Red:443733396842348545><:Crystal_Scarlet:445510676350500897><:Badge_Scarlet:445510676060962816><:Great_Badge_Scarlet:443704781001850910>',
          'Blue <:Shard_Blue:443733396741554181><:Crystal_Azure:445510676434124800><:Badge_Azure:445510675352125441><:Great_Badge_Azure:443704780783616016>']
  dhb=['Sophia <:Dark_Tome:499958772073103380><:Icon_Move_Infantry:443331187579289601>','Virion <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
       'Hana <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601>','Subaki <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
       'Donnel <:Blue_Blade:467112472768151562><:Icon_Move_Infantry:443331187579289601>','Lissa <:Colorless_Staff:443692132323295243><:Icon_Move_Infantry:443331187579289601>',
       'Gunter <:Green_Blade:467122927230386207><:Icon_Move_Cavalry:443331186530451466>','Cecilia <:Wind_Tome:499760605713137664><:Icon_Move_Cavalry:443331186530451466>',
       'Felicia <:Colorless_Dagger:443692132683743232><:Icon_Move_Infantry:443331187579289601>','Wrys <:Colorless_Staff:443692132323295243><:Icon_Move_Infantry:443331187579289601>',
       'Olivia <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601>','Stahl <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466>']
  ghb=['Ursula <:Blue_Tome:467112472394858508><:Icon_Move_Cavalry:443331186530451466> / Clarisse <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
       'Lloyd <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Berkut <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Michalis <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Valter <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
       'Xander <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466> / Arvis <:Fire_Tome:499760605826252800><:Icon_Move_Infantry:443331187579289601>',
       'Narcian <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Zephiel <:Red_Blade:443172811830198282><:Icon_Move_Armor:443331186316673025>',
       'Navarre <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Camus <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Robin(F) <:Green_Tome:467122927666593822><:Icon_Move_Infantry:443331187579289601> / Legion <:Green_Blade:467122927230386207><:Icon_Move_Infantry:443331187579289601>']
  rd=['Cavalry <:Icon_Move_Cavalry:443331186530451466>','Flying <:Icon_Move_Flier:443331186698354698>','Infantry <:Icon_Move_Infantry:443331187579289601>',
      'Armored <:Icon_Move_Armor:443331186316673025>']
  garden=['Earth <:Legendary_Effect_Earth:443331186392170508>','Fire <:Legendary_Effect_Fire:443331186480119808>','Water <:Legendary_Effect_Water:443331186534776832>',
          'Wind <:Legendary_Effect_Wind:443331186467536896>']
  t=Time.now
  timeshift=8
  timeshift-=1 unless (t-24*60*60).dst?
  t-=60*60*timeshift
  str=date_display(event,t)
  str2='__**Today in** ***Fire Emblem Heroes***__'
  if shift
    str=str.split("\n\n")
    str[1]="~~#{str[1]}~~"
    t+=24*60*60
    str.push(date_display(event,t,true))
    str=str.join("\n\n")
    str2='__**Tomorrow in** ***Fire Emblem Heroes***__'
  end
  str="#{chain}" if chain.length>0
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  str2="#{str2}\nTraining Tower color: #{colors[date%colors.length]}"
  str2="#{str2}\nDaily Hero Battle: #{dhb[date%dhb.length]}"
  str2="#{str2}\nWeekend SP bonus!" if [1,2,3].include?(date%7)
  str2="#{str2}\nSpecial Training map: #{['Magic','The Workout','Melee','Ranged','Bows'][date%5]}"
  str2="#{str2}\nGrand Hero Battle revival: #{ghb[date%ghb.length].split(' / ')[0]}"
  str2="#{str2}\nGrand Hero Battle revival 2: #{ghb[date%ghb.length].split(' / ')[1]}"
  if rd[week_from(date,2)%rd.length]==''
    str2="#{str2}\n~~Rival Domains~~ Relay Defense"
  else
    str2="#{str2}\nRival Domains movement preference: #{rd[week_from(date,2)%rd.length]}"
  end
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
  str=extend_message(str,str2,event,2)
  if safe_to_spam?(event)
    b=disp_current_banners(event,bot,'',true,1)
    str=extend_message(str,b,event,2) unless shift || chain.length>0
    book1=["Celica, Delthea, Genny","Eirika(Memories), Hector(Brave), Myrrh","Julia, Nephenee, Sigurd","Hinoka(Wings), Kana(F), Siegbert","Hector, Lyn, Lyn(Brave)",
           "Chrom(Branded), Maribelle, Sumia","Ike, Ike(Brave), Mist","Ishtar, Lene, Robin(M)(Fallen)","Julia, Lucina, Lucina(Brave)","Celica(Brave), Ephraim(Brave), Veronica(Brave)",
           "Hinoka, Ryoma, Takumi","Hardin(Fallen), Olwen(World), Reinhardt(World)","Genny, Katarina, Minerva","Hector(Brave), Karla, Nino(Fangs)","Alm, Delthea, Faye",
           "Morgan(F), Olivia(Traveler), Robin(F)(Fallen)","Amelia, Ayra, Olwen(Bonds)","Leif, Rhajat, Shiro","Lyn(Brave), Ninian, Roy(Brave)","Dorcas, Lute, Mia","Hector, Luke, Tana",
           "Linde, Saber, Sonya","Azura, Deirdre, Eldigan","Ephraim, Jaffar, Karel","Elincia, Innes, Tana","Amelia, Nephenee, Sanaki","Gray, Ike(Brave), Lucina(Brave)",
           "Azura, Elise, Leo","Celica(Fallen), Ephraim(Brave), Hardin(Fallen)","Deirdre, Linde, Tiki(Young)","Micaiah, Veronica(Brave), Zelgius"]
    book1=book1.rotate(1) if chain.length>0 && t.wday==0
    f=book1[week_from(date,3)%book1.length].split(', ')
    u=$units.map{|q| q}
    f=f.map{|q2| "#{q2}#{u[u.find_index{|q| q.name==q2}].emotes(bot) unless u.find_index{|q| q.name==q2}.nil?}"}
    str=extend_message(str,"**Tomorrow's Book 1+2 revival units:** #{f.join(', ')}",event,2) if chain.length>0 && t.wday==0
    str=extend_message(str,"**Current Book 1+2 revival units:** #{f.join(', ')}",event,2) if chain.length<=0 && !shift
    b=disp_current_events(event,bot,0,shift)
    str=extend_message(str,b,event,2) unless chain.length>0
    b=disp_current_paths(event,bot,0,shift)
    str=extend_message(str,b,event,2) unless chain.length>0
    if chain.length>0
      b=$banners.reject{|q| !q.startsTomorrow?}
      str=extend_message(str,"__**Banners starting tomorrow**__\n#{b.map{|q| q.name}.join("\n")}",event,2) if b.length>0
      b=$events.reject{|q| !q.startsTomorrow?}
      str=extend_message(str,"__**Events starting tomorrow**__\n#{b.map{|q| q.fullName}.join("\n")}",event,2) if b.length>0
    end
    b=show_bonus_units(event,'Arena',bot,2)
    b=[] if chain.length>0
    b=show_bonus_units(event,'Arena',bot,3) if shift && t.wday==2
    for i in 0...b.length
      str=extend_message(str,b[i],event,2)
    end
    b=show_bonus_units(event,'Tempest',bot,2)
    b=[] if chain.length>0
    b=show_bonus_units(event,'Tempest',bot,3) if shift && t.wday==2
    for i in 0...b.length
      str=extend_message(str,b[i],event,2) unless b[i]=='There are no known quantities about Tempest Trials'
    end
    b=show_bonus_units(event,'Aether',bot,2)
    b=[] if chain.length>0
    b=show_bonus_units(event,'Aether',bot,3) if shift && t.wday==2
    for i in 0...b.length
      str=extend_message(str,b[i],event,2)
    end
  end
  str=today_in_feh(event,bot,true,str) if !shift && safe_to_spam?(event)
  return str if chain.length>0
  event.respond str
end

def next_events(bot,event,args=[])
  idx=-1
  for i in 0...args.length
    if idx<0
      idx=1 if ['trainingtower','training_tower','tower','color','shard','crystal'].include?(args[i].downcase)
      idx=2 if ['free','1*','2*','f2p','freehero','free_hero'].include?(args[i].downcase)
      idx=3 if ['special','specialtraining','special_training'].include?(args[i].downcase)
      idx=4 if ['ghb'].include?(args[i].downcase)
      idx=5 if ['ghb2'].include?(args[i].downcase)
      idx=6 if ['rival','domains','domain','rd','rivaldomains','rival_domains','rivaldomain','rival_domain'].include?(args[i].downcase)
      idx=7 if ['blessed','blessing','garden','gardens','blessedgarden','blessed_garden','blessedgardens','blessed_gardens','blessinggarden','blessing_garden','blessinggardens','blessing_gardens'].include?(args[i].downcase)
      idx=8 if ['banners','summoning','summon','banner','summonings','summons'].include?(args[i].downcase)
      idx=9 if ['event','events'].include?(args[i].downcase)
      idx=10 if ['legendary','legendaries','legend','legends','mythic','mythicals','mythics','mythicals','mystics','mystic','mysticals','mystical'].include?(args[i].downcase)
      idx=11 if ['tactics','tactic','drills','drill','tacticsdrills','tactics_drills','tacticsdrill','tactics_drill','tacticdrills','tactic_drills','tacticdrill','tactic_drill'].include?(args[i].downcase)
      idx=12 if ['arena','bonus','arenabonus','arena_bonus'].include?(args[i].downcase)
      idx=13 if ['tempest','tempestbonus','tempest_bonus'].include?(args[i].downcase)
      idx=14 if ['aether','aetherbonus','aether_bonus','raid','raidbonus','raid_bonus','raids','raidsbonus','raids_bonus'].include?(args[i].downcase)
      idx=15 if ['book1','book_one','bookone','book1revival','bookonerevival','book_onerevival','bookone_revival','book_one_revival'].include?(args[i].downcase)
      idx=15 if ['book2','book_two','booktwo','book2revival','booktworevival','book_tworevival','booktwo_revival','book_two_revival'].include?(args[i].downcase)
      idx=16 if ['divine','devine','path','ephemura','divines','devines','paths','ephemuras'].include?(args[i].downcase)
    end
  end
  if idx<0 && !safe_to_spam?(event)
    event.respond "I will not show everything at once.  Please use this command in PM, or narrow your search using one of the following terms:\nTower, Training_Tower, Color, Shard, Crystal\nFree, 1\\*, 2\\*, F2P, FreeHero\nSpecial, Special_Training\nGHB\nGHB2\nRival, Domain(s), RD, Rival_Domain(s)\nBlessed, Garden(s), Blessing, Blessed_Garden(s)\nTactics_Drills, Tactic(s), Drill(s)\nBanner(s), Summon(ing)(s)\nEvent(s)\nLegendary/Legendaries, Legend(s)\nArena, ArenaBonus, Arena_Bonus\nTempest, TempestBonus, Tempest_Bonus\nAether, AetherBonus, Aether_Bonus\nBonus\nBook1, Book1Revival, Book2, Book2Revival\nDivine, Path, Ephemura"
    return nil
  end
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  msg=date_display(event,t)
  if [-1,1].include?(idx)
    colors=['Green <:Shard_Green:443733397190344714><:Crystal_Verdant:445510676845166592><:Badge_Verdant:445510676056899594><:Great_Badge_Verdant:443704780943261707>',
            'Colorless <:Shard_Colorless:443733396921909248><:Crystal_Transparent:445510676295843870><:Badge_Transparent:445510675976945664><:Great_Badge_Transparent:443704781597573120>',
            'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Gold <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Random <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Red <:Shard_Red:443733396842348545><:Crystal_Scarlet:445510676350500897><:Badge_Scarlet:445510676060962816><:Great_Badge_Scarlet:443704781001850910>',
            'Blue <:Shard_Blue:443733396741554181><:Crystal_Azure:445510676434124800><:Badge_Azure:445510675352125441><:Great_Badge_Azure:443704780783616016>']
    colors=colors.rotate(date%colors.length)
    msg2='__**Training Tower colors**__'
    for i in 0...colors.length
      if i==0
        msg2="#{msg2}\n#{colors[i]} - Today"
      elsif colors[i]!=colors[i-1]
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{colors[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    unless colors[0]==colors[colors.length-1]
      t2=t+24*60*60*colors.length
      msg2="#{msg2}\n#{colors[0]} - #{colors.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    end
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,2].include?(idx)
    dhb=['Sophia <:Dark_Tome:499958772073103380><:Icon_Move_Infantry:443331187579289601>','Virion <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
         'Hana <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601>','Subaki <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
         'Donnel <:Blue_Blade:467112472768151562><:Icon_Move_Infantry:443331187579289601>','Lissa <:Colorless_Staff:443692132323295243><:Icon_Move_Infantry:443331187579289601>',
         'Gunter <:Green_Blade:467122927230386207><:Icon_Move_Cavalry:443331186530451466>','Cecilia <:Wind_Tome:499760605713137664><:Icon_Move_Cavalry:443331186530451466>',
         'Felicia <:Colorless_Dagger:443692132683743232><:Icon_Move_Infantry:443331187579289601>','Wrys <:Colorless_Staff:443692132323295243><:Icon_Move_Infantry:443331187579289601>',
         'Olivia <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601>','Stahl <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466>']
    dhb=dhb.rotate(date%dhb.length)
    msg2='__**Daily Hero Battles**__'
    for i in 0...dhb.length
      if i==0
        msg2="#{msg2}\n#{dhb[i]} - Today"
      else
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{dhb[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    t2=t+24*60*60*dhb.length
    msg2="#{msg2}\n#{dhb[0]} - #{dhb.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,3].include?(idx)
    spec=['Magic','The Workout','Melee','Ranged','Bows']
    spec=spec.rotate(date%spec.length)
    msg2="__**Special Training Maps**__"
    for i in 0...spec.length
      if i==0
        msg2="#{msg2}\n#{spec[i]} - Today"
      else
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{spec[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    t2=t+24*60*60*spec.length
    msg2="#{msg2}\n#{spec[0]} - #{spec.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    msg=extend_message(msg,msg2,event,2)
  end
  ghb=['Ursula <:Blue_Tome:467112472394858508><:Icon_Move_Cavalry:443331186530451466> / Clarisse <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
       'Lloyd <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Berkut <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Michalis <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Valter <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
       'Xander <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466> / Arvis <:Fire_Tome:499760605826252800><:Icon_Move_Infantry:443331187579289601>',
       'Narcian <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Zephiel <:Red_Blade:443172811830198282><:Icon_Move_Armor:443331186316673025>',
       'Navarre <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Camus <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Robin(F) <:Green_Tome:467122927666593822><:Icon_Move_Infantry:443331187579289601> / Legion <:Green_Blade:467122927230386207><:Icon_Move_Infantry:443331187579289601>']
  ghb=ghb.rotate(date%ghb.length)
  msg2='__**GHB Revival**__'
  msg3='__**GHB Revival 2**__'
  for i in 0...ghb.length
    if i==0
      msg2="#{msg2}\n#{ghb[i].split(' / ')[0]} - Today"
      msg3="#{msg3}\n#{ghb[i].split(' / ')[1]} - Today"
    else
      t2=t+24*60*60*i
      msg2="#{msg2}\n#{ghb[i].split(' / ')[0]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      msg3="#{msg3}\n#{ghb[i].split(' / ')[1]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    end
  end
  t2=t+24*60*60*ghb.length
  msg2="#{msg2}\n#{ghb[0].split(' / ')[0]} - #{ghb.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
  msg3="#{msg3}\n#{ghb[0].split(' / ')[1]} - #{ghb.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
  msg=extend_message(msg,msg2,event,2) if [-1,4].include?(idx)
  msg=extend_message(msg,msg3,event,2) if [-1,5].include?(idx) || (idx==4 && safe_to_spam?(event))
  msg=extend_message(msg,"Try the command again with \"GHB2\" if you're looking for the second set of Grand Hero Battles.\nYou may also want to try \"Events\" if you're looking for non-cyclical GHBs.",event,2) if [4].include?(idx) && !safe_to_spam?(event)
  msg=extend_message(msg,"You may also want to try \"Events\" if you're looking for non-cyclical GHBs.",event,2) if [4,5].include?(idx) && safe_to_spam?(event)
  if [-1,6].include?(idx)
    rd=['Cavalry <:Icon_Move_Cavalry:443331186530451466>','Flying <:Icon_Move_Flier:443331186698354698>','Infantry <:Icon_Move_Infantry:443331187579289601>',
        'Armored <:Icon_Move_Armor:443331186316673025>']
    rd=rd.rotate(week_from(date,2)%6)
    rd=rd.rotate(-1) if t.wday==6
    msg2='__**Rival Domains Prefered Movement Type**__'
    for i in 0...rd.length
      if i==0
        t2=t-24*60*60*t.wday+6*24*60*60
        t2+=7*24*60*60 if t.wday==6
        msg2="#{msg2}\n#{rd[i]} - This week until #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (Saturday)"
      elsif rd[i]==rd[i-1]
      else
        t2=t-24*60*60*t.wday+7*24*60*60*i-24*60*60
        t2+=7*24*60*60 if t.wday==6
        msg2="#{msg2}\n#{rd[i]} - #{"#{i} weeks from now" if i>1}#{"Next week" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year}"
      end
    end
    unless rd[0]==rd[rd.length-1]
      t2=t-24*60*60*t.wday+7*24*60*60*rd.length-24*60*60
      t2+=7*24*60*60 if t.wday==6
      msg2="#{msg2}\n#{rd[0]} - #{rd.length} weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year}"
    end
    msg=extend_message(msg,msg2,event,2)
  end
  msg=extend_message(msg,'Blessed Gardens has been depreciated',event,2) if [-1,7].include?(idx)
  if [-1,11].include?(idx)
    drill=['Skill Studies','Grandmaster']
    drill=drill.rotate(week_from(date,0)%2)
    drill=drill.rotate(-1) if t.wday==4
    msg2='__**Next Tactics Drills**__'
    for i in 0...drill.length
      if i==0
        t2=t-24*60*60*t.wday+4*24*60*60
        t2+=7*24*60*60 if t.wday==4
        msg2="#{msg2}\n#{drill[i]} - This week until #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (Thursday)"
      else
        t2=t-24*60*60*t.wday+7*24*60*60*i-72*60*60
        t2+=7*24*60*60 if t.wday==4
        msg2="#{msg2}\n#{drill[i]} - #{"#{i} weeks from now" if i>1}#{"Next week" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year}"
      end
    end
    t2=t-24*60*60*t.wday+7*24*60*60*drill.length-72*60*60
    t2+=7*24*60*60 if t.wday==4
    msg2="#{msg2}\n#{'__' if idx==-1}#{drill[0]} - #{drill.length} weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year}#{'__' if idx==-1}#{"\n" if idx==11}"
    drill=['300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','1<:Orb_Rainbow:471001777622351872>','1<:Orb_Rainbow:471001777622351872>']
    drill=drill.rotate(week_from(date,0)%drill.length)
    drill=drill.rotate(-1) if t.wday==4
    msg2="#{msg2}\nThis week's reward: #{drill[0]}"
    drill[0]=''
    if drill[1]=='1<:Orb_Rainbow:471001777622351872>'
      t2=t-24*60*60*t.wday+4*24*60*60
      t2+=7*24*60*60 if t.wday==4
      msg2="#{msg2}\nNext #{'<:Orb_Rainbow:471001777622351872>' if idx==-1}orb reward: Next week - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (Thursday)"
    else
      m=drill.find_index{|q| q=='1<:Orb_Rainbow:471001777622351872>'}
      t2=t-24*60*60*t.wday+4*24*60*60+7*24*60*60*m
      t2+=7*24*60*60 if t.wday==4
      msg2="#{msg2}\nNext #{'<:Orb_Rainbow:471001777622351872>' if idx==-1}orb reward: #{m} weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (Thursday)"
    end
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,8].include?(idx)
    str2=disp_current_banners(event,bot,'',true,1)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_banners(event,bot,'',true,2).gsub("__**Current Banners**__\n\n",'')
    msg=extend_message(msg,str2,event,2)
  end
  if [-1,9].include?(idx)
    str2=disp_current_events(event,bot,0)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_events(event,bot,1)
    msg=extend_message(msg,str2,event,2)
  end
  if [16].include?(idx)
    disp_current_paths(event,bot,-1)
    disp_current_paths(event,bot,-2) if safe_to_spam?(event)
  elsif [-1].include?(idx)
    str2=disp_current_paths(event,bot,0)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_paths(event,bot,1)
    msg=extend_message(msg,str2,event,2)
  end
  if [-1].include?(idx)
    m=sort_legendaries(event,bot,1)
    for i in 0...m.length
      str2="#{"__**Legendary/Mythic Heroes' next appearances**__\n" if i==0}*#{m[i][0]}*"
      m[i][1]=m[i][1].reject{|q| q[1]=='~~unknown~~'}
      n=m[i][1].map{|q| q[0]}.uniq
      for i2 in 0...n.length
        str2="#{str2} - #{n[i2]}: #{m[i][1].reject{|q| q[0]!=n[i2]}.map{|q| q[1]}.join(', ')}"
      end
      x=1
      x=2 if i==0
      msg=extend_message(msg,str2,event,x)
    end
  elsif [10].include?(idx)
    sort_legendaries(event,bot)
  end
  if idx==12
    show_bonus_units(event,'Arena',bot)
  elsif idx==-1
    b=show_bonus_units(event,'Arena',bot,1)
    for i in 0...b.length
      msg=extend_message(msg,b[i],event,2)
    end
  end
  idx=13 if args.map{|q| q.downcase}.include?('bonus')
  if idx==13
    show_bonus_units(event,'Tempest',bot)
  elsif idx==-1
    b=show_bonus_units(event,'Tempest',bot,1)
    for i in 0...b.length
      msg=extend_message(msg,b[i],event,2)
    end
  end
  idx=14 if args.map{|q| q.downcase}.include?('bonus')
  if idx==14
    show_bonus_units(event,'Aether',bot)
  elsif idx==-1
    b=show_bonus_units(event,'Aether',bot,1)
    for i in 0...b.length
      msg=extend_message(msg,b[i],event,2)
    end
  end
  if [-1,15].include?(idx)
    matz=["Celica, Delthea, Genny","Eirika(Memories), Hector(Brave), Myrrh","Julia, Nephenee, Sigurd","Hinoka(Wings), Kana(F), Siegbert","Hector, Lyn, Lyn(Brave)",
          "Chrom(Branded), Maribelle, Sumia","Ike, Ike(Brave), Mist","Ishtar, Lene, Robin(M)(Fallen)","Julia, Lucina, Lucina(Brave)","Celica(Brave), Ephraim(Brave), Veronica(Brave)",
          "Hinoka, Ryoma, Takumi","Hardin(Fallen), Olwen(World), Reinhardt(World)","Genny, Katarina, Minerva","Hector(Brave), Karla, Nino(Fangs)","Alm, Delthea, Faye",
          "Morgan(F), Olivia(Traveler), Robin(M)(Fallen)","Amelia, Ayra, Olwen(Bonds)","Leif, Rhajat, Shiro","Lyn(Brave), Ninian, Roy(Brave)","Dorcas, Lute, Mia","Hector, Luke, Tana",
          "Linde, Saber, Sonya","Azura, Deirdre, Eldigan","Ephraim, Jaffar, Karel","Elincia, Innes, Tana","Amelia, Nephenee, Sanaki","Gray, Ike(Brave), Lucina(Brave)",
          "Azura, Elise, Leo","Celica(Fallen), Ephraim(Brave), Hardin(Fallen)","Deirdre, Linde, Tiki(Young)","Micaiah, Veronica(Brave), Zelgius"]
    matz=matz.rotate(week_from(date,3)%31)
    u=$units.map{|q| q}
    if safe_to_spam?(event)
      mmzz=[]
      for i in 0...matz.length
        m=matz[i].split(', ')
        for i2 in 0...m.length
          mmzz.push([m[i2],i])
          mmzz.push([m[i2],20]) if i==0
        end
      end
      mmzz.sort!{|a,b| (a[0]<=>b[0])==0 ? (a[1]<=>b[1]) : (a[0]<=>b[0])}
      mmzz.reverse!
      for i in 0...mmzz.length-1
        if mmzz[i][0]==mmzz[i+1][0]
          mmzz[i+1][2]=mmzz[i][1]*1 unless mmzz[i+1][1]>0
          mmzz[i]=nil
        end
      end
      mmzz.compact!
      mmzz.reverse!
      msg=extend_message(msg,"__**Units available in Book 1+2 revival banners**__",event,2)
      strpost=false
      tx=t-t.wday*24*60*60
      for i in 0...mmzz.length
        str2="*#{mmzz[i][0]}*#{u[u.find_index{|q| q.name==mmzz[i][0]}].emotes(bot) unless u.find_index{|q| q.name==mmzz[i][0]}.nil?} -"
        if mmzz[i][1]==0
          str2="#{str2} **This week**#{' - Next available' unless mmzz[i][2].nil? || mmzz[i][2]<=0}"
          if mmzz[i][2].nil? || mmzz[i][2]<=0
          else
            t_d=tx+mmzz[i][2]*7*24*60*60
            if mmzz[i][2]==1
              str2="#{str2} next week (#{disp_date(t_d,1).gsub(" #{t.year}",'')})"
            else
              str2="#{str2} #{mmzz[i][2]} weeks from now (#{disp_date(t_d,1).gsub(" #{t.year}",'')})"
            end
          end
        else
          t_d=tx+mmzz[i][1]*7*24*60*60
          if mmzz[i][1]==1
            str2="#{str2} Next week (#{disp_date(t_d,1).gsub(" #{t.year}",'')})"
          else
            str2="#{str2} #{mmzz[i][1]} weeks from now (#{disp_date(t_d,1).gsub(" #{t.year}",'')})"
          end
        end
        msg=extend_message(msg,str2,event)
      end
    else
      str2=matz[0].split(', ').map{|q| "#{q}#{u[u.find_index{|q2| q2.name==q}].emotes(bot) unless u.find_index{|q2| q2.name==1}.nil?}"}.join(', ')
      str3=matz[1].split(', ').map{|q| "#{q}#{u[u.find_index{|q2| q2.name==q}].emotes(bot) unless u.find_index{|q2| q2.name==1}.nil?}"}.join(', ')
      msg=extend_message(msg,"__**Units available in Book 1+2 revival banners**__\n*This week:* #{str2}\n*Next week:* #{str3}",event,2)
    end
  end
  event.respond msg unless [10,12,13,14,16].include?(idx)
  return nil
end

def disp_stats_for_FGO(bot,event,args=[],srv=nil)
  srv=find_data_ex(:find_FGO_servant,event,args,nil,bot) if srv.nil?
  if srv.nil?
    event.respond "No matches found."
    return nil
  end
  if File.exist?("#{$location}devkit/FGOServants.txt")
    b=[]
    File.open("#{$location}devkit/FGOServants.txt").each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  x=b.find_index{|q| q.split('\\'[0])[0]==srv.id && q.split('\\'[0])[1]==srv.name}
  if x.nil?
    event.respond "Match found: *#{srv.id}#{'.' unless srv.id.to_i<2}) #{srv.name}*\nThis servant no longer exists."
    return nil
  end
  x=b[x]
  x=x[1,x.length-1] if x[0]=='"'
  x=x[0,x.length-1] if x[-1]=='"'
  x=x.gsub("\n",'').split('\\'[0])
  bob4=FGOServant.new(x[0])
  bob4.name=x[1]
  bob4.clzz=x[2]
  bob4.rarity=x[3]
  bob4.grow_curve=x[4]
  bob4.max_level=x[5]
  bob4.hp=x[6]; bob4.atk=x[7]
  bob4.np_gain=x[8]; bob4.hit_count=x[9]; bob4.crit_star=x[10]
  bob4.death_rate=x[11]
  bob4.attribute=x[12]
  bob4.traits=x[13]
  bob4.actives=x[14]; bob4.passives=x[15]; bob4.np=x[16]
  bob4.deck=x[17]
  bob4.ascension_mats=x[18]; bob4.skill_mats=x[19]
  bob4.availability=x[20]
  bob4.team_cost=x[21]
  bob4.alignment=x[22]
  bob4.bond_ce=x[23] unless x[23].nil?; bob4.valentines_ce=x[26] unless x[26].nil?
  bob4.artist=x[24] unless x[24].nil?; bob4.voice_jp=x[25] unless x[25].nil?
  bob4.alts=x[28] unless x[28].nil?
  bob4.costumes=x[29] unless x[29].nil?
  srv=bob4.clone
  hdr="**Availability:** #{['2<:FGO_icon_rarity_sickly:571937157095227402>','3<:FGO_icon_rarity_rust:523903558928826372>','3-4<:FGO_icon_rarity_mono:523903551144198145>','4<:FGO_icon_rarity_mono:523903551144198145>','4-5<:FGO_icon_rarity_gold:523858991571533825>','5<:FGO_icon_rarity_gold:523858991571533825>'][srv.rarity]}"
  if srv.availability.include?('Event')
    hdr="**Availability:** 3-4<:FGO_icon_rarity_mono:523903551144198145> GHB"
    hdr="**Availability:** 2-3<:FGO_icon_rarity_rust:523903558928826372> GHB" if srv.id==174
  elsif srv.availability.include?('Limited')
    hdr="#{hdr} Seasonal summon"
  elsif has_any?(srv.availability,['NonLimited','FPSummon'])
    hdr="#{hdr} Summon"
  elsif srv.availability.include?('StoryLocked')
    hdr="**Availability:** 4-5<:FGO_icon_rarity_gold:523858991571533825> Tempest Trial"
  elsif srv.availability.include?('Starter')
    hdr="**Availability:** Story unit starting at 2<:FGO_icon_rarity_sickly:571937157095227402>"
  elsif srv.availability.include?('StoryPromo')
    hdr="**Availability:** Story unit starting at 4<:FGO_icon_rarity_mono:523903551144198145>"
  elsif srv.availability.include?('Unavailable')
    hdr="**Availability:** Unobtainable"
  else
    hdr="#{hdr} Summon"
  end
  color='Colorless'
  wpn='Blade'
  wpname='Rod *(Colorless Blade)*'
  moji=[]
  if srv.id.to_i<2
    srv.id=srv.id.to_f
  else
    srv.id=srv.id.to_i
  end
  if srv.clzz=='Shielder'
  elsif [67,97,111,197,236,249].include?(srv.id)
    wpn='Staff'
    wpname='Healer *(Staff)*'
  elsif [24,26,27,28,50,66,86,89,108,116,144,154,155,161,162,209,210,219,226,229,261,267].include?(srv.id)
    color='Red'
    wpname='Sword *(Red Blade)*'
  elsif [48,52,94,98,106,113,163,206,222,243,251].include?(srv.id)
    color='Blue'
    wpname='Lance *(Blue Blade)*'
  elsif [73,80,115,132,233].include?(srv.id)
    color='Green'
    wpname='Axe *(Green Blade)*'
  elsif [58,81,147,149,151,202,238].include?(srv.id)
    wpn='Beast'
    color='Green' if srv.deck[6,1]=='Q'
    color='Blue' if srv.deck[6,1]=='A'
    color='Red' if srv.deck[6,1]=='B'
    color='Colorless' if srv.traits.include?('Divine') || [81].include?(srv.id)
    color='Red' if [151].include?(srv.id)
    wpname="#{color} Beast"
  elsif [23,265].include?(srv.id)
    color='Blue'
    wpn='Dagger'
    wpname='Blue Dagger'
  elsif [65,263].include?(srv.id)
    color='Green'
    wpn='Dagger'
    wpname='Green Dagger'
  elsif [93].include?(srv.id)
    color='Red'
    wpn='Dagger'
    wpname='Red Dagger'
  elsif [65,257,258].include?(srv.id)
    color='Colorless'
    wpn='Bow'
    wpname='Colorless Bow'
  elsif [129,164,184,250].include?(srv.id)
    color='Red'
    wpn='Bow'
    wpname='Red Bow'
  elsif [156].include?(srv.id)
    color='Blue'
    wpn='Bow'
    wpname='Blue Bow'
  elsif [179,239].include?(srv.id)
    color='Green'
    wpn='Bow'
    wpname='Green Bow'
  elsif [104,107,137].include?(srv.id)
    wpn='Dagger'
    wpname='Colorless Dagger'
  elsif [29,77,79,83,96,118,136,139,166,167,168,169,170,173,177,182,189,190,191,194,195,198,199,200,204,215,216,220,224,229,230,237,240,241,242,247,248,253,260].include?(srv.id)
    wpn='Tome'
    color='Green' if srv.deck[6,1]=='Q'
    color='Blue' if srv.deck[6,1]=='A'
    color='Red' if srv.deck[6,1]=='B'
    color='Blue' if [77,118,136,166,182,200,216,229,240,241,242,247,253].include?(srv.id)
    color='Green' if [215,224].include?(srv.id)
    color='Red' if [83,96,167,168,170,177,190,191,195,199,204,220,230,248,260].include?(srv.id)
    color='Colorless' if [169,194,198,237].include?(srv.id)
    color=['Red','Red','Red','Red','Blue','Blue','Blue','Blue','Green','Green','Colorless'].sample if [79].include?(srv.id)
    typ='Wind'
    typ=['Dark','Fire'][srv.id%2] if srv.deck[6,1]=='B'
    typ=['Light','Thunder'][srv.id%2] if srv.deck[6,1]=='A'
    if [79].include?(srv.id)
      typ='Wind'
      typ='Stone' if color=='Colorless'
      typ=['Dark','Fire'].sample if color=='Red'
      typ=['Light','Thunder'].sample if color=='Blue'
    end
    typ='Thunder' if [77,200].include?(srv.id)
    typ='Light' if [118,136,139,166,173,182,216,229,240,241,242,247,253].include?(srv.id)
    typ='Fire' if [190,191,195,248].include?(srv.id)
    typ='Ice' if [215,224].include?(srv.id)
    typ='Dark' if [83,96,167,168,170,177,195,199,204,220,230,260].include?(srv.id)
    typ='Story' if [169,237].include?(srv.id)
    typ='Riddle' if [194].include?(srv.id)
    typ='Paint' if [198].include?(srv.id)
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{typ}_#{wpn}"}
    wpname="#{typ} Mage *(#{color} Tome)*"
  elsif [56,201,208,211].include?(srv.id)
    wpn='Dragon'
    color='Green' if srv.deck[6,1]=='Q'
    color='Blue' if srv.deck[6,1]=='A'
    color='Red' if srv.deck[6,1]=='B'
    color='Red' if [208].include?(srv.id)
    color='Blue' if [211].include?(srv.id)
    color='Colorless' if srv.traits.include?('Divine')
    wpname="#{color} Dragon"
  elsif srv.clzz=='Saber'
    color='Red'
    wpname='Sword *(Red Blade)*'
  elsif srv.clzz=='Lancer'
    color='Blue'
    wpname='Lance *(Blue Blade)*'
  elsif srv.clzz=='Berserker'
    color='Green'
    wpname='Axe *(Green Blade)*'
  elsif srv.clzz=='Archer'
    wpn='Bow'
    color='Red' if [11,69].include?(srv.id)
    wpname="#{color} Bow"
  elsif srv.clzz=='Caster'
    wpn='Tome'
    color='Green' if srv.deck[6,1]=='Q'
    color='Blue' if srv.deck[6,1]=='A'
    color='Red' if srv.deck[6,1]=='B' || [62,120].include?(srv.id)
    typ='Wind'
    typ=['Dark','Fire'][srv.id%2] if srv.deck[6,1]=='B'
    typ=['Light','Thunder'][srv.id%2] if srv.deck[6,1]=='A'
    typ='Dark' if [62,120,203,225].include?(srv.id)
    typ='Light' if [127].include?(srv.id)
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{typ}_#{wpn}"}
    wpname="#{typ} Mage *(#{color} Tome)*"
  elsif srv.clzz=='Assassin'
    wpn='Dagger'
    wpname='Colorless Dagger'
  elsif srv.traits.include?('Dragon')
    wpn='Dragon'
    color='Green' if srv.deck[6,1]=='Q'
    color='Blue' if srv.deck[6,1]=='A'
    color='Red' if srv.deck[6,1]=='B'
    wpname="#{color} Dragon"
  elsif srv.traits.include?('Wild Beast')
    wpn='Beast'
    color='Green' if srv.deck[6,1]=='Q'
    color='Blue' if srv.deck[6,1]=='A'
    color='Red' if srv.deck[6,1]=='B'
    wpname="#{color} Beast"
  elsif srv.traits.include?('Divine')
    wpn='Staff'
    wpname='Healer *(Staff)*'
  elsif srv.traits.include?('Not Weak to Enuma Elish') && srv.id%2==0
    wpn='Staff'
    wpname='Healer *(Staff)*'
  elsif srv.traits.include?('Female') && srv.id%5==0
    wpn='Staff'
    wpname='Healer *(Staff)*'
  elsif ['Rider','Ruler'].include?(srv.clzz) && srv.id%7>0
    color='Green' if srv.deck[6,1]=='Q'
    color='Blue' if srv.deck[6,1]=='A'
    color='Red' if srv.deck[6,1]=='B'
    wpname='Axe *(Green Blade)*' if srv.deck[6,1]=='Q'
    wpname='Lance *(Blue Blade)*' if srv.deck[6,1]=='A'
    wpname='Sword *(Red Blade)*' if srv.deck[6,1]=='B'
  else
    color='Green' if srv.deck[6,1]=='Q'
    color='Blue' if srv.deck[6,1]=='A'
    color='Red' if srv.deck[6,1]=='B'
    wpn='Bow'
    wpn='Dagger' if srv.id%2==0
    wpname="#{color} #{wpn}"
  end
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{color}_#{wpn}"} unless wpn=='Tome' && !['Paint','Story','Riddle','Ice'].include?(typ)
  hdr="#{hdr}\n**Weapon:** #{moji[0].mention unless moji.length<=0} #{wpname}"
  mov='Infantry'
  if [142,23,29,60,62,65,94,144,172,214,225,233,234,255,257,267].include?(srv.id)
    mov='Flier'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Flier:443331186698354698> Flier"
  elsif [119,78,10,28,108,114,206,207,226,227,252].include?(srv.id)
    mov='Cavalry'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Cavalry:443331186530451466> Cavalry"
  elsif [2,5,24,25,59,64,90,175,192].include?(srv.id)
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Infantry:443331187579289601> Infantry"
  elsif [76,140,149,154,164,187,188,190,191,204,205,251,256].include?(srv.id)
    mov='Armor'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Armor:443331186316673025> Armor"
  elsif has_any?(srv.traits,['Greek','Roman','Soverign']) || srv.clzz=='Ruler'
    mov='Armor'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Armor:443331186316673025> Armor"
  elsif srv.clzz=='Rider'
    mov='Cavalry'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Cavalry:443331186530451466> Cavalry"
  else
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Infantry:443331187579289601> Infantry"
  end
  str=''
  basesttz=[[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
  actusttz=[[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
  basesttz[0][0]=(srv.hp[0]-1200)*11/10200+14
  basesttz[0][1]=(srv.atk[0]-900)*8/1400+4
  basesttz[1][0]=(srv.hp[2]-9000)*30/11000+30
  basesttz[1][1]=(srv.atk[2]-7000)*21/8000+20
  basesttz[1][2]=((srv.crit_star[1]-4)*25/22+16).to_i
  basesttz[1][3]=((100-srv.death_rate)*29/100+13).to_i
  basesttz[1][4]=((srv.crit_star[0]-9)*29/199+13).to_i+srv.np_gain[1]-1
  basesttz[2][0]=basesttz[1][0]-basesttz[0][0]
  basesttz[2][1]=basesttz[1][1]-basesttz[0][1]
  basesttz[2][2]=1+srv.hit_count[0]
  basesttz[2][3]=1+srv.hit_count[2]+srv.hit_count[4]/2
  basesttz[2][4]=1+srv.hit_count[1]
  f=srv.deck[0,5]
  if f.include?('QQQ')
    basesttz[1][2]*=3
    basesttz[1][2]/=2
    basesttz[2][2]+=2
  elsif f.include?('QQ')
    basesttz[1][2]*=5
    basesttz[1][2]/=4
    basesttz[2][2]+=1
  end
  if f.include?('AAA')
    basesttz[1][4]*=3
    basesttz[1][4]/=2
    basesttz[2][4]+=2
  elsif f.include?('AA')
    basesttz[1][4]*=5
    basesttz[1][4]/=4
    basesttz[2][4]+=1
  end
  if f.include?('BBB')
    basesttz[1][1]*=3
    basesttz[1][1]/=2
    basesttz[2][1]+=2
  elsif f.include?('BB')
    basesttz[1][1]*=5
    basesttz[1][1]/=4
    basesttz[2][1]+=1
  end
  if mov=='Armor'
    basesttz[1][3]*=4
    basesttz[1][3]/=3
    basesttz[2][3]+=1
    basesttz[2][2]-=1
  elsif mov=='Flier'
    basesttz[1][4]*=4
    basesttz[1][4]/=3
    basesttz[2][4]+=1
  elsif mov=='Infantry'
    basesttz[1][2]*=4
    basesttz[1][2]/=3
    basesttz[2][2]+=1
  end
  if srv.clzz=='Assassin' && srv.id !=75
    basesttz[1][2]*=2
    basesttz[1][2]/=3
  end
  if srv.clzz==12
    basesttz[1][2]*=7
    basesttz[1][2]/=3
    basesttz[1][1]*=4
    basesttz[1][1]/=3
    basesttz[1][3]*=4
    basesttz[1][3]/=5
    basesttz[1][4]*=4
    basesttz[1][4]/=5
  elsif color=='Colorless'
    if srv.deck[6,1]=='Q'
      basesttz[1][2]*=5
      basesttz[1][2]/=4
      basesttz[2][2]+=1
    elsif srv.deck[6,1]=='A'
      basesttz[1][4]*=5
      basesttz[1][4]/=4
      basesttz[2][4]+=1
    elsif srv.deck[6,1]=='B'
      basesttz[1][1]*=5
      basesttz[1][1]/=4
      basesttz[2][1]+=1
    end
  end
  m=Mods.map{|q| q[5]}
  basesttz[0][2]=[basesttz[1][2]-m[basesttz[2][2]+4],1].max
  basesttz[0][3]=[basesttz[1][3]-m[basesttz[2][3]+4],1].max
  basesttz[0][4]=[basesttz[1][4]-m[basesttz[2][4]+4],1].max
  for i in 0...5
    basesttz[1][i]=[[basesttz[1][i],99].min,1].max
  end
  f=(m.find_index{|q| basesttz[2][0]<=q}-4 rescue 16)
  basesttz[2][0]=f*1
  f=(m.find_index{|q| basesttz[2][1]<=q}-4 rescue 16)
  basesttz[2][1]=f*1
  totals=[0,0,0,0]
  totals[0]=basesttz[1][0]+basesttz[1][1]+basesttz[1][2]+basesttz[1][3]+basesttz[1][4]
  totals[2]=basesttz[0][0]+basesttz[0][1]+basesttz[0][2]+basesttz[0][3]+basesttz[0][4]
  totals[3]=basesttz[2][0]+basesttz[2][1]+basesttz[2][2]+basesttz[2][3]+basesttz[2][4]
  l1_total=47
  gp_total=31
  if ['Tome', 'Bow', 'Dagger', 'Staff'].include?(wpn)
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
  if srv.id>=151 || srv.id==1.2
    if ['Tome', 'Staff'].include?(wpn) # magical ranged
      l1_total+=2
      l1_total-=1 if ['Cavalry'].include?(mov)
      l1_total-=2 if ['Flier'].include?(mov)
      gp_total+=3
      gp_total-=4 if ['Cavalry'].include?(mov)
      gp_total-=2 if ['Flier'].include?(mov)
    elsif ['Bow', 'Dagger'].include?(wpn) # physical ranged
      l1_total+=2
      l1_total-=1 if ['Cavalry'].include?(mov)
      gp_total+=3
      gp_total-=1 if ['Cavalry'].include?(mov)
    else # melee
      l1_total+=2
      l1_total-=1 if ['Cavalry','Flier'].include?(mov)
      l1_total-=1 if 'Flier'!=mov
      gp_total+=2
      gp_total+=2 if ['Infantry'].include?(mov)
      gp_total-=1 if ['Cavalry'].include?(mov)
    end
  elsif srv.id>=60 || srv.id==1.1
    l1_total+=1
    l1_total-=1 if ['Cavalry','Flier'].include?(mov)
    l1_total-=1 if 'Flier'!=mov
    gp_total+=2
    gp_total-=1 if ['Cavalry'].include?(mov)
    gp_total-=1 if ['Tome', 'Bow', 'Dagger', 'Staff'].include?(wpn) && 'Armor'!=mov
  end
  actusttz[0]=basesttz[0].map{|q| q}
  order=[[0,4,3,2,1],[1,2,3,4,0],[2,4,1,3,0],[3,1,4,2,0],[4,3,2,1,0]][srv.id%5]
  unless totals[2]==l1_total
    actusttz[0][0]-=10
    for i in 0...5
      actusttz[0][i]*=(l1_total-10)
      actusttz[0][i]/=(totals[2]-10)
    end
    actusttz[0][0]+=10
    totals[2]=actusttz[0][0]+actusttz[0][1]+actusttz[0][2]+actusttz[0][3]+actusttz[0][4]
    unless totals[2]==l1_total
      for i in 0...(l1_total-totals[2])
        actusttz[0][order[i]]+=1
      end
    end
    totals[2]=actusttz[0][0]+actusttz[0][1]+actusttz[0][2]+actusttz[0][3]+actusttz[0][4]
  end
  actusttz[2]=basesttz[2].map{|q| q+4}
  unless totals[3]==gp_total
    for i in 0...5
      actusttz[2][i]*=(gp_total+20)
      actusttz[2][i]/=(totals[3]+20)
    end
    totals[3]=actusttz[2][0]+actusttz[2][1]+actusttz[2][2]+actusttz[2][3]+actusttz[2][4]-20
    unless totals[3]==gp_total
      for i in 0...(gp_total-totals[3])
        actusttz[2][order[i]]+=1
      end
    end
  end
  if actusttz[2][0]==actusttz[2].max
    actusttz[2][0]-=2
    actusttz[2][1]+=1
    actusttz[2][2]+=1
  else
    actusttz[2][1]+=1
    actusttz[2][2]+=1
    actusttz[2][3+(srv[0]%2)]-=1
    actusttz[2][3+(srv[0]%4)/2]-=1
  end
  if actusttz[2][0]==actusttz[2].max
    actusttz[2][0]-=2
    actusttz[2][1]+=1
    actusttz[2][2]+=1
  elsif actusttz[2][3]==actusttz[2].max
    actusttz[2][3]-=2
    actusttz[2][1]+=1
    actusttz[2][2]+=1
  elsif actusttz[2][4]==actusttz[2].max
    actusttz[2][4]-=2
    actusttz[2][1]+=1
    actusttz[2][2]+=1
  elsif actusttz[2][1]==actusttz[2].max
    actusttz[2][0]-=1
    actusttz[2][2]+=1
  elsif actusttz[2][2]==actusttz[2].max
    actusttz[2][0]-=1
    actusttz[2][1]+=1
  end
  for i in 0...5
    actusttz[1][i]=actusttz[0][i]+m[[actusttz[2][i],m.length-1].min]
  end
  totals[1]=actusttz[1][0]+actusttz[1][1]+actusttz[1][2]+actusttz[1][3]+actusttz[1][4]
  basesttz[0]=basesttz[0].map{|q| "#{' ' if q<10}#{q} "}.join('|')
  actusttz[0]=actusttz[0].map{|q| "#{' ' if q<10}#{q} "}.join('|')
  basesttz[1]=basesttz[1].map{|q| "#{' ' if q<10}#{q}"}
  actusttz[1]=actusttz[1].map{|q| "#{' ' if q<10}#{q}"}
  f=basesttz[2].join('| ')
  for i in 0...5
    basesttz[2][i]='+' if [-3,1,5,10,14].include?(basesttz[2][i])
    basesttz[2][i]='-' if [-2,2,6,11,15].include?(basesttz[2][i])
    basesttz[2][i]=' ' unless basesttz[2][i].is_a?(String)
    basesttz[1][i]="#{basesttz[1][i]}#{basesttz[2][i]}"
    actusttz[2][i]='+' if [-3,1,5,10,14].include?(actusttz[2][i])
    actusttz[2][i]='-' if [-2,2,6,11,15].include?(actusttz[2][i])
    actusttz[2][i]=' ' unless actusttz[2][i].is_a?(String)
    actusttz[1][i]="#{actusttz[1][i]}#{actusttz[2][i]}"
  end
  basesttz[1]=basesttz[1].join('|')
  actusttz[1]=actusttz[1].join('|')
  str='<:FGO_icon_rarity_gold:523858991571533825>'*5
  atk='<:StrengthS:514712248372166666>'
  atk='<:MagicS:514712247289774111>' if ['Tome','Staff'].include?(wpn)
  atk='<:FreezeS:514712247474585610>' if ['Dragon'].include?(wpn)
  statstr="\u200B\u00A0<:HP_S:514712247503945739>\u00A0\u00A0\u00B7\u00A0\u00A0#{atk}\u00A0\u00A0\u00B7\u00A0\u00A0<:SpeedS:514712247625580555>\u00A0\u00A0\u00B7\u00A0\u00A0<:DefenseS:514712247461871616>\u00A0\u00A0\u00B7\u00A0\u00A0<:ResistanceS:514712247574986752>\u00A0\u00A0\u00B7\u00A0\u00A0"
  str="#{str}\n\n__**Direct stat translation**__\n#{statstr}#{totals[0]}\u00A0BST\u2084\u2080\u00A0\u00A0\u00B7\u00A0\u00A0Score:\u00A0#{totals[0]/5+115}\n```#{basesttz[0]}\n#{basesttz[1]}```"
  str="#{str}\n__**Accounting for FEH legality**__\n#{statstr}#{totals[1]}\u00A0BST\u2084\u2080\u00A0\u00A0\u00B7\u00A0\u00A0Score:\u00A0#{totals[1]/5+115}\n```#{actusttz[0]}\n#{actusttz[1]}```"
  xcolor=0xE22141 if color=='Red'
  xcolor=0x2764DE if color=='Blue'
  xcolor=0x09AA24 if color=='Green'
  xcolor=0x64757D if color=='Colorless'
  art=rand(4)+1
  dispnum="#{'0' if srv.id<100}#{'0' if srv.id<10}#{srv.id.to_i}#{art}"
  dispnum="#{'0' if srv.id<100}#{'0' if srv.id<10}#{srv.id.to_i}2" if srv.id==74 && event.user.id==167657750971547648
  dispnum="0011" if srv.id<2
  dispnum="0014" if srv.id<2 && art==4
  unless art<=1
    m=false
    IO.copy_stream(open("http://fate-go.cirnopedia.org/icons/servant/servant_#{dispnum}.png"), "#{$location}devkit/FEHTemp#{Shardizard}.png") rescue m=true
    art=1 if File.size("#{$location}devkit/FEHTemp#{Shardizard}.png")<=10 || m
  end
  dispnum="#{'0' if srv.id<100}#{'0' if srv.id<10}#{srv.id.to_i}#{art}"
  dispnum="#{'0' if srv.id<100}#{'0' if srv.id<10}#{srv.id.to_i}2" if srv.id==74 && event.user.id==167657750971547648
  dispnum="0011" if srv.id<2
  dispnum="0014" if srv.id<2 && art==4
  xpic="http://fate-go.cirnopedia.org/icons/servant/servant_#{dispnum}.png"
  create_embed(event,["__**#{srv.name}** [FGO Unit-##{srv.id}]__",hdr],str,xcolor,nil,xpic)
end

def dev_flower_list(event,bot,args=[])
  mov=[]
  completex=false
  for i in 0...args.length
    mov.push('Flier') if ['flier','flying','flyer','fly','pegasus','wyvern','fliers','flyers','wyverns','pegasi'].include?(args[i].downcase)
    mov.push('Cavalry') if ['cavalry','horse','pony','horsie','horses','horsies','ponies','cavalier','cavaliers','cav','cavs'].include?(args[i].downcase)
    mov.push('Infantry') if ['infantry','foot','feet'].include?(args[i].downcase)
    mov.push('Armor') if ['armor','armour','armors','armours','armored','armoured'].include?(args[i].downcase)
    completex=true if ['complete','completed','finished','finish','done'].include?(args[i].downcase)
  end
  if mov.length<=0 && !completex && !safe_to_spam?(event)
    event.respond "<:Dragonflower_Infantry:541170819980722176><:Dragonflower_Orange:552648156790390796><:Dragonflower_Cavalry:541170819955556352><:Dragonflower_Armor:541170820001824778><:Dragonflower_Cyan:552648156202926097><:Dragonflower_Flier:541170820089774091><:Dragonflower_Purple:552648232673607701><:Dragonflower_Pink:552648232510160897>\nI won't post a list of all your units here, so instead, look at all the pretty flowers!\nhttps://www.getrandomthings.com/list-flowers.php"
    return nil
  end
  x=$dev_units.reject{|q| q.name=='Kiran'}
  x=$dev_units.reject{|q| mov[0]!=q.movement || q.name=='Kiran'} if mov.length>0
  x=x.reject{|q| q.dragonflowers<q.dragonflowerMax} if completex
  x=x.reject{|q| !q.fake.nil?}
  for i in 0...x.length
    x[i].sort_data=['',x[i].name]
    x[i].sort_data[0]="#{x[i].rarity}#{Rarity_stars[0][x[i].rarity-1]}"
    f=[0]
    f.push(Max_rarity_merge[1]) if x[i].rarity>=Max_rarity_merge[0]
    x[i].sort_data[0]="#{x[i].rarity}#{Rarity_stars[1][x[i].rarity-1]}" if x[i].merge_count>=Max_rarity_merge[1]
    x[i].sort_data[0]="#{x[i].rarity}<:Icon_Rarity_S:448266418035621888>" unless x[i].support=='-'
    x[i].sort_data[0]="#{x[i].rarity}<:Icon_Rarity_Sp10:448272715653054485>" unless x[i].support=='-' || x[i].rarity<Max_rarity_merge[0] || x[i].merge_count<Max_rarity_merge[1]
    x[i].sort_data[0]="#{x[i].rarity}<:Icon_Rarity_Forma:699042072526585927>" if x[i].forma
    x[i].sort_data[0]="#{x[i].rarity}<:Icon_Rarity_Forma_p10:699085674099376148>" unless !x[i].forma || x[i].rarity<Max_rarity_merge[0] || x[i].merge_count<Max_rarity_merge[1]
    x[i].sort_data[0]="#{x[i].sort_data[0]}+#{x[i].merge_count}" unless f.include?(x[i].merge_count)
    x[i].sort_data[0]="**#{x[i].sort_data[0]}**" if x[i].merge_count>=Max_rarity_merge[1]
    x[i].sort_data[0]="#{x[i].sort_data[0]}"
    if x[i].dragonflowers>=x[i].dragonflowerMax
      x[i].sort_data[1]="**#{x[i].name}**"
    elsif x[i].dragonflowers==0
      x[i].sort_data[1]="#{x[i].name}"
    else
      x[i].sort_data[1]="#{x[i].name} - df+#{x[i].dragonflowers}/#{x[i].dragonflowerMax}"
    end
    x[i].sort_data=x[i].sort_data.join(' ')
  end
  x=x.sort{|a,b| (a.dragonflowers<=>b.dragonflowers)==0 ? ((a.sortPriority<=>b.sortPriority)==0 ? (a.name<=>b.name) : (b.sortPriority<=>a.sortPriority)) : (b.dragonflowers<=>a.dragonflowers)}
  f=[]
  y=x.reject{|q| q.movement != 'Infantry' || q.dragonflowers>=q.dragonflowerMax}
  f.push(['<:Dragonflower_Infantry:541170819980722176>Infantry<:Icon_Move_Infantry:443331187579289601>',y.map{|q| q.sort_data}.join("\n"),0xF79FA0]) if y.length>0
  y=x.reject{|q| q.movement != 'Cavalry' || q.dragonflowers>=q.dragonflowerMax}
  f.push(['<:Dragonflower_Cavalry:541170819955556352>Cavalry<:Icon_Move_Cavalry:443331186530451466>',y.map{|q| q.sort_data}.join("\n"),0xEBBF70]) if y.length>0
  y=x.reject{|q| q.movement != 'Flier' || q.dragonflowers>=q.dragonflowerMax}
  f.push(['<:Dragonflower_Flier:541170820089774091>Fliers<:Icon_Move_Flier:443331186698354698>',y.map{|q| q.sort_data}.join("\n"),0x90C0F5]) if y.length>0
  y=x.reject{|q| q.movement != 'Armor' || q.dragonflowers>=q.dragonflowerMax}
  f.push(['<:Dragonflower_Armor:541170820001824778>Armored<:Icon_Move_Armor:443331186316673025>',y.map{|q| q.sort_data}.join("\n"),0x9FE0B3]) if y.length>0
  y=x.reject{|q| q.dragonflowers<q.dragonflowerMax}.sort{|a,b| (a.sortPriority<=>b.sortPriority)==0 ? (a.name<=>b.name) : (b.sortPriority<=>a.sortPriority)}
  f.push(['Completed Projects',y.map{|q| q.sort_data}.join("\n"),0x008b8b]) if y.length>0
  if f.map{|q| "__**#{q[0]}**__\n#{q[1]}"}.join("\n\n").length>1900
    for i in 0...f.length
      create_embed(event,"__**#{f[i][0]}**__",'',f[i][2],nil,nil,triple_finish(f[i][1].split("\n")))
    end
  elsif f.length<=1
    create_embed(event,"__**#{f[0][0]}**__",'',f[0][2],nil,nil,triple_finish(f[0][1].split("\n")))
  elsif f.length<=2 && f[0][1].split("\n").length/2>f[1][1].split("\n").length
    x=triple_finish(f[0][1].split("\n"),true)
    x=x.map{|q| ['Incomplete projects',q[1]]}
    x.push([f[1][0],f[1][1]])
    create_embed(event,"__**#{f[0][0]}**__",'',f[0][2],nil,nil,x)
  else
    f=f.map{|q| [q[0],q[1]]}
    create_embed(event,'__**Grail Projects**__','',0x008b8b,nil,nil,f)
  end
  return nil
end

def dev_grail_list(event,bot,args=[],mode='')
  x=$dev_units.reject{|q| !q.availability[0].include?('r') && !q.availability[0].include?('g') && !q.availability[0].include?('t')}
  x=$dev_units.reject{|q| !q.availability[0].include?('g')} if mode=='GHB'
  x=$dev_units.reject{|q| !q.availability[0].include?('t')} if mode=='Tempest'
  x=x.sort{|a,b| (a.merge_count<=>b.merge_count)==0 ? ((a.sortPriority<=>b.sortPriority)==0 ? (a.name<=>b.name) : (b.sortPriority<=>a.sortPriority)) : (b.merge_count<=>a.merge_count)}
  f=[]
  z=x.reject{|q| q.availability[0].include?('r') || (q.rarity>=Max_rarity_merge[0] && q.merge_count>=Max_rarity_merge[1])}
  f.push(['Currently ungrailable',z.map{|q| "#{q.rarity}#{Rarity_stars[0][q.rarity-1]}+#{q.merge_count} #{q.name}#{'<:Heroic_Grail:574798333898653696>' if q.availability[0].include?('g')}#{'<:Current_Tempest_Bonus:498797966740422656>' if q.availability[0].include?('t')}"}.join("\n")]) if z.length>0
  z=x.reject{|q| !q.availability[0].include?('r') || (q.rarity>=Max_rarity_merge[0] && q.merge_count>=Max_rarity_merge[1])}
  y=z.reject{|q| !q.availability[0].include?('g')}
  f.push(['GHB units',y.map{|q| "#{q.rarity}#{Rarity_stars[0][q.rarity-1]}+#{q.merge_count} #{q.name}"}.join("\n")]) if y.length>0
  y=z.reject{|q| !q.availability[0].include?('t')}
  f.push(['Tempest Trials units',y.map{|q| "#{q.rarity}#{Rarity_stars[0][q.rarity-1]}+#{q.merge_count} #{q.name}"}.join("\n")]) if y.length>0
  y=z.reject{|q| q.availability[0].include?('g') || q.availability[0].include?('t')}
  f.push(['Unknown Grail units',y.map{|q| "#{q.rarity}#{Rarity_stars[0][q.rarity-1]}+#{q.merge_count} #{q.name}"}.join("\n")]) if y.length>0
  y=x.reject{|q| q.rarity<Max_rarity_merge[0] || q.merge_count<Max_rarity_merge[1]}
  f.push(['Completed projects',y.map{|q| "**#{q.rarity}#{Rarity_stars[1][q.rarity-1]}** #{q.name}"}.join("\n")]) if y.length>0
  if f.map{|q| "__**#{q[0]}**__\n#{q[1]}"}.join("\n\n").length>1900
    for i in 0...f.length
      create_embed(event,"__**#{f[i][0]}**__",'',0x008b8b,nil,nil,triple_finish(f[i][1].split("\n")))
    end
  else
    create_embed(event,'__**Grail Projects**__','',0x008b8b,nil,nil,f)
  end
  return nil
end

def devunits_save()
  if File.exist?("#{$location}devkit/FEHDevUnits.txt")
    b=[]
    File.open("#{$location}devkit/FEHDevUnits.txt").each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  devpass='f2p'
  devpass='pass' if b[3].downcase=='pass'
  devpass='pass' if b[3].downcase=='feh pass'
  devpass='pass' if b[3].downcase=='fehpass'
  du=$dev_units.sort{|b,a| (a.sortPriority<=>b.sortPriority)==0 ? (b.name<=>a.name) : (a.sortPriority<=>b.sortPriority)}
  dw=$dev_waifus.reject{|q| ['Sakura','Bernie','Mirabilis'].include?(q)}.sort; dw.unshift('Mirabilis'); dw.unshift('Bernie'); dw.unshift('Sakura')
  open("#{$location}devkit/FEHDevUnits.txt", 'w') { |f|
    f.puts dw.join('\\'[0])
    f.puts $dev_somebodies.reject{|q| $dev_waifus.include?(q)}.sort.join('\\'[0])
    f.puts $dev_nobodies.reject{|q| [$dev_waifus,$dev_somebodies,$dev_units.map{|q2| q2.name}].flatten.include?(q)}.sort.join('\\'[0])
    f.puts devpass
    f.puts ''
    f.puts du.map{|q| q.storage_string}.join("\n\n")
    f.puts "\n"
  }
end

def new_devunit(bot,event,xname,flurp=[])
  x=$dev_units.find_index{|q| q.name==xname}
  unless x.nil?
    barracks='barracks'
    barracks='pocket' if ['Sakura','Bernie'].include?($dev_units[x].alts[0])
    event.respond "You already have a #{$dev_units[x].starDisplay(bot)} in your #{barracks}."
    return nil
  end
  if File.exist?("#{$location}devkit/FEHDevUnits.txt")
    b=[]
    File.open("#{$location}devkit/FEHDevUnits.txt").each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  devpass=true
  devpass=false if b[3].downcase=='pass'
  devpass=false if b[3].downcase=='feh pass'
  devpass=false if b[3].downcase=='fehpass'
  flurp[0]=5 if flurp[0].nil?
  bob4=DevUnit.new(xname,flurp[0])
  bob4.merge_count=0
  bob4.merge_count=flurp[1]*1 unless flurp[1].nil?
  bob4.boon=' '
  bob4.boon=flurp[2] unless flurp[2].nil?
  bob4.bane=' '
  bob4.bane=flurp[3] unless flurp[3].nil?
  bob4.support_load('-')
  bob4.support_load(flurp[4],devpass) unless flurp[4].nil?
  bob4.dragonflowers=0
  bob4.dragonflowers=flurp[8] unless flurp[8].nil?
  bob4.resplendent=flurp[9] if flurp[9]
  bob4.face=find_kiran_face(event,true).gsub(' ','') if bob4.name=='Kiran'
  $dev_units.push(bob4.clone)
  str="You have added a **#{bob4.creation_string(bot)}** to your collection."
  str="#{str}  Congrats!" if [$dev_waifus,$dev_somebodies].flatten.include?(xname)
  p=bob4.pronoun(false)
  str="#{str}\n#{p[0,1].upcase}#{p[1,p.length-1]} is currently using the #{bob4.face} portraits.  Use `FEH!devedit KiranFace` to change that." if bob4.name=='Kiran'
  devunits_save()
  event.respond str
  return nil
end

def kiran_weapon(m)
  m=m[0,2] if m.length>0
  return 'Sword Breidablik' if m==['Red', 'Blade']
  return 'Lance Breidablik' if m==['Blue', 'Blade']
  return 'Axe Breidablik' if m==['Green', 'Blade']
  return 'Scarlet Breidablik' if m==['Red', 'Tome']
  return 'Azure Breidablik' if m==['Blue', 'Tome']
  return 'Jade Breidablik' if m==['Green', 'Tome']
  return 'Dire Breidablik' if m==['Colorless', 'Tome']
  return 'Breidablik'
end

def dev_edit(bot,event,args=[],cmd='')
  if ((cmd.nil? || cmd.length.zero?) && (args.nil? || args.length.zero?)) || cmd.downcase=='help'
    subcommand=nil
    subcommand=args[0] unless args.nil? || args.length.zero?
    subcommand='' if subcommand.nil?
    help_text(event,bot,'devedit',subcommand)
    return nil
  end
  data_load()
  if ['kiranface','kiran','face','summoner','summonerface'].include?(cmd.downcase) && !$dev_units.find_index{|q| q.name=='Kiran'}.nil?
    dunit=$dev_units.find_index{|q| q.name=='Kiran'}
    $dev_units[dunit].face=find_kiran_face(event,true).gsub(' ','')
    str="Your #{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}'s face has been changed to #{$dev_units[dunit].face}."
    devunits_save()
    event.respond str
    return nil
  end
  unt=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
  unt[1]=first_sub(args.join(' ').downcase,unt[1].downcase,'') unless unt.nil?
  if unt.nil?
    event.respond 'No unit found.  Please include a unit name.'
    return nil
  elsif unt[0].is_a?(Array)
    event.respond "This command does not work with multiunits.  Please include one of the following units:\n#{unt[0].map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
    return nil
  end
  extstr="#{unt[1]}"
  unt=unt[0].clone
  cmd='' if cmd.nil?
  if ['newwaifu','newaifu','addwaifu','new_waifu','add_waifu','waifu'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && args[0].downcase=='waifu')
    if $dev_waifus.include?(unt.name)
      event.respond "#{unt.name}#{unt.emotes(bot,false)} is already listed among your waifus."
    else
      $dev_waifus.push(unt.name)
      str="#{unt.name}#{unt.emotes(bot,false)} has been added to your list of waifus."
      x=[]
      x.push('"somebodies"') if $dev_somebodies.include?(unt.name)
      x.push('"nobodies"') if $dev_nobodies.include?(unt.name)
      str="#{str}\nI have also taken the liberty of removing #{unt.pronoun} from your #{list_lift(x,'and')} list#{'s' if x.length>1}." if x.length>0
      devunits_save()
      event.respond str
    end
    return nil
  elsif ['newsomebody','newsomeone','newsomebodies','addsomebody','addsomeone','addsomebodies','new_somebody','new_someone','new_somebodies','add_somebody','add_someone','add_somebodies','somebody','somebodies','someone'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && ['somebody','somebodies','someone'].include?(args[0].downcase))
    if $dev_waifus.include?(unt.name)
      event.respond "#{unt.name}#{unt.emotes(bot,false)} is already listed among your waifus."
    elsif $dev_somebodies.include?(unt.name)
      event.respond "#{unt.name}#{unt.emotes(bot,false)} is already listed among your \"somebodies\" list."
    else
      $dev_somebodies.push(unt.name)
      str="#{unt.name}#{unt.emotes(bot,false)} has been added to your \"somebodies\" list."
      str="#{str}\nI have also taken the liberty of removing #{unt.pronoun} from your \"nobodies\" list." if $dev_nobodies.include?(unt.name)
      devunits_save()
      event.respond str
    end
    return nil
  elsif ['newnobody','newnoone','newnobodies','addnobody','addnoone','addnobodies','new_nobody','new_noone','new_nobodies','add_nobody','add_noone','add_nobodies','nobody','nobodies','noone'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && ['nobody','nobodies','noone'].include?(args[0].downcase))
    if $dev_waifus.include?(unt.name)
      event.respond "#{unt.name}#{unt.emotes(bot,false)} is already listed among your waifus."
    elsif $dev_somebodies.include?(unt.name)
      event.respond "#{unt.name}#{unt.emotes(bot,false)} is already listed among your \"somebodies\" list."
    elsif $dev_nobodies.include?(unt.name)
      event.respond "#{unt.name}#{unt.emotes(bot,false)} is already listed among your \"nobodies\" list."
    else
      $dev_nobodies.push(unt.name)
      str="#{unt.name}#{unt.emotes(bot,false)} has been added to your \"nobodies\" list."
      devunits_save()
      event.respond str
    end
    return nil
  elsif ['kiranweapon','kirantype','summonerweapon','summonertype'].include?(cmd.downcase) || (unt.name=='Kiran' && cmd.downcase=='weapon')
    dunit=$dev_units.find_index{|q| q.name==unt.name}
    if dunit.nil?
      $stored_event=[event,unt,dunit,flurp]
      event.respond 'You do not have this unit.  Do you wish to add them to your collection?'
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          new_devunit(bot,e,$stored_event[1].name,$stored_event[3])
        end
      end
      return nil
    end
    m=['', '']
    m[0]='Red' if has_any?(['red','reds'],args.map{|q| q.downcase})
    m[0]='Blue' if has_any?(['blue','blues'],args.map{|q| q.downcase})
    m[0]='Green' if has_any?(['green','greens','grean','greans'],args.map{|q| q.downcase})
    m[0]='Colorless' if has_any?(['colorless','colourless','colorlesses','colourlesses','clear','clears'],args.map{|q| q.downcase})
    m[1]='Blade' if has_any?(['physical','blade','blades','close','closerange'],args.map{|q| q.downcase})
    m[1]='Tome' if has_any?(['tome','mage','spell','tomes','mages','spells','range','ranged','distance','distant'],args.map{|q| q.downcase})
    m=['Red','Blade'] if has_any?(['sword','swords','katana'],args.map{|q| q.downcase})
    m=['Blue','Blade'] if has_any?(['lance','lances','lancer','lancers','spear','spears','naginata'],args.map{|q| q.downcase})
    m=['Green','Blade'] if has_any?(['axe','axes','ax','club','clubs'],args.map{|q| q.downcase})
    m=['Red','Tome'] if has_any?(['redtome','redtomes','redmage','redmages'],args.map{|q| q.downcase})
    m=['Blue','Tome'] if has_any?(['bluetome','bluetomes','bluemage','bluemages'],args.map{|q| q.downcase})
    m=['Green','Tome'] if has_any?(['greentome','greentomes','greenmage','greenmages'],args.map{|q| q.downcase})
    if m.map{|q| q.length}.max<=0
      event.respond "Please specify the type of weapon you would like Kiran to use."
      return nil
    end
    m[0]='Colorless' if m[0].length<=0
    m[1]='Tome' if m[1].length<=0
    m[0]='Red' if m[0]=='Colorless' && m[1]=='Blade'
    if m==$dev_units[dunit].weapon
      event.respond "Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** is already using that weapon type."
    else
      x=kiran_weapon($dev_units[dunit].weapon)
      $dev_units[dunit].weapon=m
      xx=false
      for i in 0...$dev_units[dunit].skills[0].length
        if $dev_units[dunit].skills[0][i]==x
          $dev_units[dunit].skills[0][i]=kiran_weapon(m)
          xx=true
        end
      end
      devunits_save()
      m="#{m.join(' ')}s"
      m='Swords' if m=='Red Blades'
      m='Lances' if m=='Blue Blades'
      m='Axes' if m=='Green Blades'
      str="You will need to edit #{$dev_units[dunit].pronoun(true)} weapon and skills yourself."
      str="You will need to edit #{$dev_units[dunit].pronoun(true)} non-weapon skills yourself." if xx
      event.respond "Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** is now using #{m}.\n#{str}"
    end
    return nil
  end
  dunit=$dev_units.find_index{|q| q.name==unt.name}
  flurp=find_stats_in_string(event,extstr,1,unt.name)
  if cmd.downcase=='create'
    new_devunit(bot,event,unt.name,flurp)
  elsif ['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase
    if $dev_waifus.include?(unt.name)
      event.respond "Woah, you're getting rid of one of your waifus?!?  Who hacked your Discord and/or FEH account?"
    elsif $dev_somebodies.include?(unt.name)
      $stored_event=[event,unt,dunit,flurp]
      event.respond "You're getting rid of one of your somebodies?  Should I remove them from the \"somebodies\" list?"
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          unt2=$stored_event[1].clone
          $dev_somebodies=$dev_somebodies.reject{|q| q==unt2.name}
          devunits_save()
          e.respond "#{unt2.name}#{unt2.emotes(bot,false)} has been removed from your \"somebodies\" list."
        end
      end
    elsif !dunit.nil?
      dunit=$dev_units[dunit]
      $stored_event=[event,unt,dunit,flurp]
      event.respond "I have a devunit stored for #{dunit.creation_string(bot)}.  Do you wish me to delete this build?"
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          unt2=$stored_event[1].clone
          dunit2=$stored_event[2].clone
          $dev_units=$dev_units.reject{|q| q.name==unt2.name}
          devunits_save()
          e.respond "#{dunit2.creation_string(bot)} has been removed from the devunits."
        end
      end
    elsif $dev_nobodies.include?(unt.name)
      $dev_somebodies=$dev_somebodies.reject{|q| q==unt.name}
      devunits_save()
      event.respond "#{unt.name}#{unt.emotes(bot,false)} has been removed from your \"nobodies\" list."
    else
      event.respond 'You never had that unit in the first place.'
    end
  elsif dunit.nil?
    $stored_event=[event,unt,dunit,flurp]
    if $dev_nobodies.include?(unt.name)
      event.respond "You have this unit but previously stated you don't want to input their data.  Do you wish to add them to your collection?"
    else
      event.respond 'You do not have this unit.  Do you wish to add them to your collection?'
    end
    event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
      if e.message.text.downcase.include?('no')
        e.respond 'Okay.'
      else
        new_devunit(bot,e,$stored_event[1].name,$stored_event[3])
      end
    end
  elsif ['promote','rarity','feathers'].include?(cmd.downcase)
    if $dev_units[dunit].rarity>=Max_rarity_merge[0]
      event.respond "Your #{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)} is already at max rarity."
      return nil
    end
    x=1
    r=$dev_units[dunit].resplendent
    r="#{r}f" if $dev_units[dunit].forma
    x=flurp[0] unless flurp[0].nil?
    x=flurp[1] unless flurp[1].nil?
    $dev_units[dunit].rarity="#{$dev_units[dunit].rarity.to_i+x}"
    $dev_units[dunit].rarity="#{[$dev_units[dunit].rarity.to_i,Max_rarity_merge[0]].min}#{r}"
    str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** has been promoted to #{$dev_units[dunit].rarity}#{Rarity_stars[0][$dev_units[dunit].rarity-1]}."
    p=$dev_units[dunit].pronoun(true)
    str="#{str}\n#{p[0].upcase}#{p[1,p.length-1]} merge count has also been reset to 0." if $dev_units[dunit].merge_count>0
    $dev_units[dunit].merge_count=0
    devunits_save()
    event.respond str
  elsif ['merge','combine'].include?(cmd.downcase)
    if $dev_units[dunit].merge_count>=Max_rarity_merge[1]
      event.respond "Your #{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)} is already at max merges."
      return nil
    elsif args.map{|q| q.downcase}.include?('reset')
      $dev_units[dunit].merge_count=0
      str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}**'s merge count has been reset to 0."
      devunits_save()
      event.respond str
      return nil
    end
    x=1
    x=flurp[0] unless flurp[0].nil?
    x=flurp[1] unless flurp[1].nil?
    $dev_units[dunit].merge_count+=x
    $dev_units[dunit].merge_count=[$dev_units[dunit].merge_count,Max_rarity_merge[1]].min
    str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** has been merged to +#{$dev_units[dunit].merge_count}."
    devunits_save()
    event.respond str
  elsif ['nature','ivs'].include?(cmd.downcase)
    n=''
    if flurp[2].nil? && flurp[3].nil?
      $dev_units[dunit].boon=' '
      $dev_units[dunit].bane=' '
      devunits_save()
      event.respond "You have changed your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}**'s nature to neutral!"
    elsif flurp[2].nil? && [nil,'',' '].include?($dev_units[dunit].boon)
      event.respond "You cannot have a bane without a boon."
    elsif flurp[3].nil? && $dev_units[dunit].merge_count>0
      $dev_units[dunit].boon=flurp[2]
      $dev_units[dunit].bane=' '
      devunits_save()
      event.respond "You have changed your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}**'s nature to +#{flurp[2]}.\nYou didn't give #{$dev_units[dunit].pronoun} a bane, but you might want to."
    elsif flurp[3].nil?
      event.respond "You cannot have a boon without a bane."
    else
      $dev_units[dunit].boon=flurp[2] unless flurp[2].nil?
      $dev_units[dunit].bane=flurp[3]
      n=Natures.reject{|q| q[1]!=$dev_units[dunit].boon || q[2]!=$dev_units[dunit].bane}
      n2=nil
      unless n.nil? || n.length<=0
        w=$dev_units[dunit].equippedWeapon
        u=unt.atkName(true,w[0],w[1])
        n2=n[0][0] if u=='Strength'
        n2=n[n.length-1][0] if u=='Magic'
        n2=n.map{|q| q[0]}.join(' / ') if ['Attack','Freeze'].include?(u)
        n2=nil if n[0][3]==true
      end
      devunits_save()
      dunit=$dev_units[dunit]
      event.respond "You have changed your **#{dunit.name}#{dunit.emotes(bot,false)}**'s nature to +#{dunit.boon} -#{dunit.bane}#{" (#{n2})" unless n2.nil?}."
    end
  elsif ['learn','teach'].include?(cmd.downcase)
    skill_types=[]
    for i in 0...args.length
      skill_types.push(0) if ['weapon','weapons'].include?(args[i].downcase)
      skill_types.push(1) if ['assist','assists'].include?(args[i].downcase)
      skill_types.push(2) if ['special','specials'].include?(args[i].downcase)
      skill_types.push(3) if ['a','apassives','apassive','passivea','passivesa','a_passives','a_passive','passive_a','passives_a'].include?(args[i].downcase)
      skill_types.push(4) if ['b','bpassives','bpassive','passiveb','passivesb','b_passives','b_passive','passive_b','passives_b'].include?(args[i].downcase)
      skill_types.push(5) if ['c','cpassives','cpassive','passivec','passivesc','c_passives','c_passive','passive_c','passives_c'].include?(args[i].downcase)
      skill_types.push(6) if ['s','seal','seals','spassives','spassive','passives','passivess','s_passives','s_passive','passive_s','passives_s','sealpassives','sealpassive','passiveseal','passivesseal','seal_passives','seal_passive','passive_seal','passives_seal','sealspassives','sealspassive','passiveseals','passivesseals','seals_passives','seals_passive','passive_seals','passives_seals'].include?(args[i].downcase)
    end
    if skill_types.length<=0
      event.respond "Please include the type of skill your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** will be learning."
      return nil
    end
    s='that type'
    s='those types' if skill_types.uniq.length>1
    for i in 0...skill_types.length
      k=false
      for jx in 0...$dev_units[dunit].skills[skill_types[i]].length
        if skill_types[i]==6
          seel=$dev_units[dunit].skills[skill_types[i]][0].scan(/\d+?/)[0].to_i
          seel=$dev_units[dunit].skills[skill_types[i]][0].gsub(seel.to_s,(seel+1).to_s)
          x=$skills.find_index{|q| q.fullName==seel}
          k=true unless x.nil? || !has_any?($skills[x].type,['Seal','Passive(S)'])
        else
          k=true if $dev_units[dunit].skills[skill_types[i]][jx][0,2]=='~~' && $dev_units[dunit].skills[skill_types[i]][jx]!='~~none~~' && $dev_units[dunit].skills[skill_types[i]][jx]!='~~unknown~~'
        end
      end
      skill_types[i]=nil unless k
    end
    skill_types.compact!
    if skill_types.length<=0
      event.respond "Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** has no unlearned skills of #{s}."
      return nil
    end
    skills_learned=[]
    for i in 0...skill_types.length
      if skill_types[i]==6 # skill seals
        seel=$dev_units[dunit].skills[skill_types[i]][0].scan(/\d+?/)[0].to_i
        seel=$dev_units[dunit].skills[skill_types[i]][0].gsub(seel.to_s,(seel+1).to_s)
        x=$skills.find_index{|q| q.fullName==seel}
        if x.nil? || !has_any?($skills[x].type,['Seal','Passive(S)'])
          skills_learned.push("#{Skill_Slots[0][skill_types[i]]} ~~#{$dev_units[dunit].skills[skill_types[i]][0]}~~ (already maximized)")
        else
          $dev_units[dunit].skills[skill_types[i]][0]=seel
          skills_learned.push("#{Skill_Slots[0][skill_types[i]]} #{$dev_units[dunit].skills[skill_types[i]][0]}")
        end
      else # other skills
        k=true
        for j in 0...$dev_units[dunit].skills[skill_types[i]].length
          if $dev_units[dunit].skills[skill_types[i]][j][0,2]=='~~' && k
            k=false
            $dev_units[dunit].skills[skill_types[i]][j]=$dev_units[dunit].skills[skill_types[i]][j].gsub('~~','')
            skills_learned.push("#{Skill_Slots[0][skill_types[i]]} #{$dev_units[dunit].skills[skill_types[i]][j]}")
          end
        end
      end
    end
    devunits_save()
    s="__Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** has learned the following skills__"
    for i in 0...skills_learned.length
      s=extend_message(s,skills_learned[i],event)
    end
    event.respond s
  elsif ['flower','flowers','dragonflower','dragonflowers'].include?(cmd.downcase)
    if $dev_units[dunit].dragonflowers>=$dev_units[dunit].dragonflowerMax
      event.respond "Your #{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)} is already at max flowers."
      return nil
    elsif args.map{|q| q.downcase}.include?('reset')
      $dev_units[dunit].dragonflowers=0
      str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}**'s dragonflower count has been reset to #{$dev_units[dunit].dragonflowerEmote}+0."
      devunits_save()
      event.respond str
      return nil
    end
    x=1
    x=flurp[0] unless flurp[0].nil?
    x=flurp[1] unless flurp[1].nil?
    x=flurp[8] unless flurp[8].nil?
    $dev_units[dunit].dragonflowers+=x
    $dev_units[dunit].dragonflowers=[$dev_units[dunit].dragonflowers,$dev_units[dunit].dragonflowerMax].min
    str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** now has a total of #{$dev_units[dunit].dragonflowerEmote}+#{$dev_units[dunit].dragonflowers}."
    devunits_save()
    event.respond str
  elsif ['pairup','pair','pair-up','paired','cohort'].include?(cmd.downcase)
    unt2=find_data_ex(:find_unit,event,extstr.split(' '),nil,bot,false,0)
    dunit2=nil
    dunit2=$dev_units.find_index{|q| q.name==unt2.name} unless unt2.nil?
    order=[]
    if dunit2.nil? || dunit==dunit2
      event.respond "This subcommand requires two devunits."
      return nil
    elsif !$dev_units[dunit].legendary.nil? && $dev_units[dunit].legendary[1]=='Duel'
      order=[$dev_units[dunit].clone,$dev_units[dunit2].clone]
    elsif !$dev_units[dunit2].legendary.nil? && $dev_units[dunit2].legendary[1]=='Duel'
      order=[$dev_units[dunit2].clone,$dev_units[dunit].clone]
    else
      event.respond "Neither #{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)} nor #{$dev_units[dunit2].name}#{$dev_units[dunit2].emotes(bot,false)} is a unit that has controllable Pair-Ups."
      return nil
    end
    for i in 0...$dev_units.length
      $dev_units[i].cohort=nil if [unt.name,unt2.name].include?($dev_units[i].cohort)
    end
    $dev_units[dunit].cohort=$dev_units[dunit2].name
    $dev_units[dunit2].cohort=$dev_units[dunit].name
    ctype='cohort unit'
    ctype='pocket buddy' if ['Sakura','Bernie'].include?(order[1].name)
    devunits_save()
    event.respond "Your **#{order[0].name}#{order[0].emotes(bot,false)}** is now using **#{order[1].name}#{order[1].emotes(bot,false)}** as a #{ctype}."
  elsif ['resplendant','resplendent','ascension','ascend','resplend'].include?(cmd.downcase)
    if !unt.hasResplendent?
      event.respond "#{unt.name}#{untz.emotes(bot,false)} does not have a Resplendent Ascension available to them."
      return nil
    end
    r=$dev_units[dunit].resplendent
    str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** has reached #{$dev_units[dunit].pronoun(true)} Resplendent Ascension."
    if r=='r'
      r='u'
      str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** keeps #{$dev_units[dunit].pronoun(true)} Resplendent Ascension's stats, but is using #{$dev_units[dunit].pronoun(true)} default art."
    elsif r=='u'
      r='r'
      str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** is returning to #{$dev_units[dunit].pronoun(true)} Resplendent Ascension."
    else
      r='r'
    end
    r="#{r}f" if $dev_units[dunit].forma
    $dev_units[dunit].rarity="#{$dev_units[dunit].rarity.to_i}#{r}"
    devunits_save()
    event.respond str
  elsif ['forma'].include?(cmd.downcase)
    if !unt.hasForma?
      event.respond "#{unt.name}#{untz.emotes(bot,false)} is unavailable as a Forma Unit."
      return nil
    end
    r=$dev_units[dunit].resplendent
    str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** is now a Forma Unit."
    if $dev_units[dunit].forma
      str="Your **#{$dev_units[dunit].name}#{$dev_units[dunit].emotes(bot,false)}** is no longer a Forma Unit."
    else
      r="#{r}f"
    end
    $dev_units[dunit].rarity="#{$dev_units[dunit].rarity.to_i}#{r}"
    devunits_save()
    event.respond str
  else
    event.respond 'Edit mode was not specified.'
  end
  return nil
end

def donorunits_save(id,tbl=[],data=[])
  if File.exist?("#{$location}devkit/EliseUserSaves/#{id}.txt")
    b=[]
    File.open("#{$location}devkit/EliseUserSaves/#{id}.txt").each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  du=tbl.sort{|b,a| (a.sortPriority<=>b.sortPriority)==0 ? (b.name<=>a.name) : (a.sortPriority<=>b.sortPriority)}
  open("#{$location}devkit/EliseUserSaves/#{id}.txt", 'w') { |f|
    f.puts b[0] unless data.length>0
    f.puts data.join('\\'[0]) if data.length>0
    f.puts ''
    f.puts du.map{|q| q.storage_string}.join("\n\n")
    f.puts "\n"
  }
end

def new_donorunit(bot,event,id,xname,flurp=[])
  tbl=$donor_units.reject{|q| q.owner_id != id}
  x=tbl.find_index{|q| q.name==xname}
  unless x.nil?
    event.respond "You already have a #{tbl[x].starDisplay(bot)} in your barracks."
    return nil
  end
  if File.exist?("#{$location}devkit/EliseUserSaves/#{id}.txt")
    b=[]
    File.open("#{$location}devkit/EliseUserSaves/#{id}.txt").each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  flurp[0]=5 if flurp[0].nil?
  bob4=DonorUnit.new(xname,flurp[0],b[0],id)
  bob4.merge_count=0
  bob4.merge_count=flurp[1]*1 unless flurp[1].nil?
  bob4.boon=' '
  bob4.boon=flurp[2] unless flurp[2].nil?
  bob4.bane=' '
  bob4.bane=flurp[3] unless flurp[3].nil?
  bob4.support='-'
  bob4.support=flurp[4] unless flurp[4].nil?
  bob4.dragonflowers=0
  bob4.dragonflowers=flurp[8] unless flurp[8].nil?
  bob4.resplendent=flurp[9] if flurp[9]
  bob4.face=find_kiran_face(event).gsub(' ','') if bob4.name=='Kiran'
  tbl.push(bob4.clone)
  str="You have added a **#{bob4.creation_string(bot)}** to your collection."
  p=bob4.pronoun(false)
  str="#{str}\n#{p[0,1].upcase}#{p[1,p.length-1]} is currently using the #{bob4.face} portraits.  Use `FEH!edit KiranFace` to change that." if bob4.name=='Kiran'
  donorunits_save(id,tbl)
  event.respond str
  return nil
end

def donor_edit(bot,event,args=[],cmd='')
  uid=event.user.id
  cmd='' if cmd.nil?
  if uid==167657750971547648
    event.respond "This command is for the donors.  Your version of the command is `FEH!devedit`."
    return nil
  elsif !get_donor_list().reject{|q| q[2][0]<4}.map{|q| q[0]}.include?(uid)
    event.respond "You do not have permission to use this command."
    return nil
  elsif !File.exist?("#{$location}devkit/EliseUserSaves/#{uid}.txt")
    event.respond "Please wait until my developer makes your storage file."
    return nil
  elsif ((cmd.nil? || cmd.length.zero?) && (args.nil? || args.length.zero?)) || cmd.downcase=='help'
    subcommand=nil
    subcommand=args[0] unless args.nil? || args.length.zero?
    subcommand='' if subcommand.nil?
    help_text(event,bot,'edit',subcommand)
    return nil
  end
  data_load()
  dulx=$donor_units.reject{|q| q.owner_id != uid}
  if ['kiranface','kiran','face','summoner','summonerface'].include?(cmd.downcase) && !dulx.find_index{|q| q.name=='Kiran'}.nil?
    dunit=dulx.find_index{|q| q.name=='Kiran'}
    dulx[dunit].face=find_kiran_face(event).gsub(' ','')
    str="Your #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}'s face has been changed to #{dulx[dunit].face}."
    donorunits_save(uid,dulx)
    event.respond str
    return nil
  end
  unt=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
  unt[1]=first_sub(args.join(' ').downcase,unt[1].downcase,'') unless unt.nil?
  if unt.nil?
    event.respond 'No unit found.  Please include a unit name.'
    return nil
  elsif unt[0].is_a?(Array)
    event.respond "This command does not work with multiunits.  Please include one of the following units:\n#{unt[0].map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
    return nil
  end
  extstr="#{unt[1]}"
  unt=unt[0].clone
  dunit=dulx.find_index{|q| q.name==unt.name}
  flurp=find_stats_in_string(event,extstr,1,unt.name)
  supdel=false
  supdel=true if ['unsupport','unmarry','unmarriage','divorce'].include?(cmd.downcase)
  supdel=true if ['remove','delete'].include?(cmd.downcase) && ['support','marry','marriage'].include?(args[0].downcase)
  supdel=true if ['support','marry','marriage'].include?(cmd.downcase) && ['remove','delete'].include?(args[0].downcase)
  supdel=false if dunit.nil?
  if cmd.downcase=='create'
    new_donorunit(bot,event,uid,unt.name,flurp)
  elsif ['kiranweapon','kirantype','summonerweapon','summonertype'].include?(cmd.downcase) || (unt.name=='Kiran' && cmd.downcase=='weapon')
    m=['', '']
    m[0]='Red' if has_any?(['red','reds'],args.map{|q| q.downcase})
    m[0]='Blue' if has_any?(['blue','blues'],args.map{|q| q.downcase})
    m[0]='Green' if has_any?(['green','greens','grean','greans'],args.map{|q| q.downcase})
    m[0]='Colorless' if has_any?(['colorless','colourless','colorlesses','colourlesses','clear','clears'],args.map{|q| q.downcase})
    m[1]='Blade' if has_any?(['physical','blade','blades','close','closerange'],args.map{|q| q.downcase})
    m[1]='Tome' if has_any?(['tome','mage','spell','tomes','mages','spells','range','ranged','distance','distant'],args.map{|q| q.downcase})
    m=['Red','Blade'] if has_any?(['sword','swords','katana'],args.map{|q| q.downcase})
    m=['Blue','Blade'] if has_any?(['lance','lances','lancer','lancers','spear','spears','naginata'],args.map{|q| q.downcase})
    m=['Green','Blade'] if has_any?(['axe','axes','ax','club','clubs'],args.map{|q| q.downcase})
    m=['Red','Tome'] if has_any?(['redtome','redtomes','redmage','redmages'],args.map{|q| q.downcase})
    m=['Blue','Tome'] if has_any?(['bluetome','bluetomes','bluemage','bluemages'],args.map{|q| q.downcase})
    m=['Green','Tome'] if has_any?(['greentome','greentomes','greenmage','greenmages'],args.map{|q| q.downcase})
    if m.map{|q| q.length}.max<=0
      event.respond "Please specify the type of weapon you would like Kiran to use."
      return nil
    end
    m[0]='Colorless' if m[0].length<=0
    m[1]='Tome' if m[1].length<=0
    m[0]='Red' if m[0]=='Colorless' && m[1]=='Blade'
    if m==dulx[dunit].weapon
      event.respond "Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** is already using that weapon type."
    else
      x=kiran_weapon(dulx[dunit].weapon)
      dulx[dunit].weapon=m
      xx=false
      for i in 0...dulx[dunit].skills[0].length
        if dulx[dunit].skills[0][i]==x
          dulx[dunit].skills[0][i]=kiran_weapon(m)
          xx=true
        end
      end
      devunits_save()
      m="#{m.join(' ')}s"
      m='Swords' if m=='Red Blades'
      m='Lances' if m=='Blue Blades'
      m='Axes' if m=='Green Blades'
      str="You will need to edit #{dulx[dunit].pronoun(true)} weapon and skills yourself."
      str="You will need to edit #{dulx[dunit].pronoun(true)} non-weapon skills yourself." if xx
      event.respond "Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** is now using #{m}.\n#{str}"
    end
    return nil
  elsif (['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase) && !supdel
    if !dunit.nil?
      dunit=dulx[dunit]
      $stored_event=[event,unt,dunit,flurp]
      event.respond "I have a donor unit stored for #{dunit.creation_string(bot)}.  Do you wish me to delete this build?"
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: event.user.id) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          unt2=$stored_event[1].clone
          dunit2=$stored_event[2].clone
          dulx=dulx.reject{|q| q.name==unt2.name}
          donorunits_save(uid,dulx)
          e.respond "#{dunit2.creation_string(bot)} has been removed from your donor units."
        end
      end
    else
      event.respond 'You never had that unit in the first place.'
    end
  elsif dunit.nil?
    $stored_event=[event,unt,dunit,flurp]
    event.respond 'You do not have this unit.  Do you wish to add them to your collection?'
    event.channel.await(:bob, contains: /(yes)|(no)/i, from: event.user.id) do |e|
      if e.message.text.downcase.include?('no')
        e.respond 'Okay.'
      else
        new_donorunit(bot,e,uid,$stored_event[1].name,$stored_event[3])
      end
    end
  elsif ['promote','rarity','feathers'].include?(cmd.downcase)
    if dulx[dunit].rarity>=Max_rarity_merge[0]
      event.respond "Your #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} is already at max rarity."
      return nil
    end
    x=1
    r=dulx[dunit].resplendent
    r="#{r}f" if dulx[dunit].forma
    x=flurp[0] unless flurp[0].nil?
    x=flurp[1] unless flurp[1].nil?
    dulx[dunit].rarity="#{dulx[dunit].rarity.to_i+x}"
    dulx[dunit].rarity="#{[dulx[dunit].rarity.to_i,Max_rarity_merge[0]].min}#{r}"
    str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** has been promoted to #{dulx[dunit].rarity}#{Rarity_stars[0][dulx[dunit].rarity-1]}."
    p=dulx[dunit].pronoun(true)
    str="#{str}\n#{p[0].upcase}#{p[1,p.length-1]} merge count has also been reset to 0." if dulx[dunit].merge_count>0
    dulx[dunit].merge_count=0
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['merge','combine'].include?(cmd.downcase)
    if dulx[dunit].merge_count>=Max_rarity_merge[1]
      event.respond "Your #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} is already at max merges."
      return nil
    elsif args.map{|q| q.downcase}.include?('reset')
      dulx[dunit].merge_count=0
      str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}**'s merge count has been reset to 0."
      donorunits_save(uid,dulx)
      event.respond str
      return nil
    end
    x=1
    x=flurp[0] unless flurp[0].nil?
    x=flurp[1] unless flurp[1].nil?
    dulx[dunit].merge_count+=x
    dulx[dunit].merge_count=[dulx[dunit].merge_count,Max_rarity_merge[1]].min
    str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** has been merged to +#{dulx[dunit].merge_count}."
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['nature','ivs'].include?(cmd.downcase)
    n=''
    if flurp[2].nil? && flurp[3].nil?
      dulx[dunit].boon=' '
      dulx[dunit].bane=' '
      donorunits_save(uid,dulx)
      event.respond "You have changed your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}**'s nature to neutral!"
    elsif flurp[2].nil? && [nil,'',' '].include?(dulx[dunit].boon)
      event.respond "You cannot have a bane without a boon."
    elsif flurp[3].nil? && dulx[dunit].merge_count>0
      dulx[dunit].boon=flurp[2]
      dulx[dunit].bane=' '
      donorunits_save(uid,dulx)
      event.respond "You have changed your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}**'s nature to +#{flurp[2]}.\nYou didn't give #{dulx[dunit].pronoun} a bane, but you might want to."
    elsif flurp[3].nil?
      event.respond "You cannot have a boon without a bane."
    else
      dulx[dunit].boon=flurp[2] unless flurp[2].nil?
      dulx[dunit].bane=flurp[3]
      n=Natures.reject{|q| q[1]!=dulx[dunit].boon || q[2]!=dulx[dunit].bane}
      n2=nil
      unless n.nil? || n.length<=0
        w=dulx[dunit].equippedWeapon
        u=unt.atkName(true,w[0],w[1])
        n2=n[0][0] if u=='Strength'
        n2=n[n.length-1][0] if u=='Magic'
        n2=n.map{|q| q[0]}.join(' / ') if ['Attack','Freeze'].include?(u)
        n2=nil if n[0][3]==true
      end
      donorunits_save(uid,dulx)
      dunit=dulx[dunit]
      event.respond "You have changed your **#{dunit.name}#{dunit.emotes(bot,false)}**'s nature to +#{dunit.boon} -#{dunit.bane}#{" (#{n2})" unless n2.nil?}."
    end
  elsif ['learn','teach'].include?(cmd.downcase)
    skill_types=[]
    for i in 0...args.length
      skill_types.push(0) if ['weapon','weapons'].include?(args[i].downcase)
      skill_types.push(1) if ['assist','assists'].include?(args[i].downcase)
      skill_types.push(2) if ['special','specials'].include?(args[i].downcase)
      skill_types.push(3) if ['a','apassives','apassive','passivea','passivesa','a_passives','a_passive','passive_a','passives_a'].include?(args[i].downcase)
      skill_types.push(4) if ['b','bpassives','bpassive','passiveb','passivesb','b_passives','b_passive','passive_b','passives_b'].include?(args[i].downcase)
      skill_types.push(5) if ['c','cpassives','cpassive','passivec','passivesc','c_passives','c_passive','passive_c','passives_c'].include?(args[i].downcase)
      skill_types.push(6) if ['s','seal','seals','spassives','spassive','passives','passivess','s_passives','s_passive','passive_s','passives_s','sealpassives','sealpassive','passiveseal','passivesseal','seal_passives','seal_passive','passive_seal','passives_seal','sealspassives','sealspassive','passiveseals','passivesseals','seals_passives','seals_passive','passive_seals','passives_seals'].include?(args[i].downcase)
    end
    if skill_types.length<=0
      event.respond "Please include the type of skill your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** will be learning."
      return nil
    end
    s='that type'
    s='those types' if skill_types.uniq.length>1
    for i in 0...skill_types.length
      k=false
      for jx in 0...dulx[dunit].skills[skill_types[i]].length
        if skill_types[i]==6
          seel=dulx[dunit].skills[skill_types[i]][0].scan(/\d+?/)[0].to_i
          seel=dulx[dunit].skills[skill_types[i]][0].gsub(seel.to_s,(seel+1).to_s)
          x=$skills.find_index{|q| q.fullName==seel}
          k=true unless x.nil? || !has_any?($skills[x].type,['Seal','Passive(S)'])
        else
          k=true if dulx[dunit].skills[skill_types[i]][jx][0,2]=='~~' && dulx[dunit].skills[skill_types[i]][jx]!='~~none~~' && dulx[dunit].skills[skill_types[i]][jx]!='~~unknown~~'
        end
      end
      skill_types[i]=nil unless k
    end
    skill_types.compact!
    if skill_types.length<=0
      event.respond "Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** has no unlearned skills of #{s}."
      return nil
    end
    skills_learned=[]
    for i in 0...skill_types.length
      if skill_types[i]==6 # skill seals
        seel=dulx[dunit].skills[skill_types[i]][0].scan(/\d+?/)[0].to_i
        seel=dulx[dunit].skills[skill_types[i]][0].gsub(seel.to_s,(seel+1).to_s)
        x=$skills.find_index{|q| q.fullName==seel}
        if x.nil? || !has_any?($skills[x].type,['Seal','Passive(S)'])
          skills_learned.push("#{Skill_Slots[0][skill_types[i]]} ~~#{dulx[dunit].skills[skill_types[i]][0]}~~ (already maximized)")
        else
          dulx[dunit].skills[skill_types[i]][0]=seel
          skills_learned.push("#{Skill_Slots[0][skill_types[i]]} #{dulx[dunit].skills[skill_types[i]][0]}")
        end
      else # other skills
        k=true
        for j in 0...dulx[dunit].skills[skill_types[i]].length
          if dulx[dunit].skills[skill_types[i]][j][0,2]=='~~' && k
            k=false
            dulx[dunit].skills[skill_types[i]][j]=dulx[dunit].skills[skill_types[i]][j].gsub('~~','')
            skills_learned.push("#{Skill_Slots[0][skill_types[i]]} #{dulx[dunit].skills[skill_types[i]][j]}")
          end
        end
      end
    end
    donorunits_save(uid,dulx)
    s="__Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** has learned the following skills__"
    for i in 0...skills_learned.length
      s=extend_message(s,skills_learned[i],event)
    end
    event.respond s
  elsif ['equip','skill'].include?(cmd.downcase)
    skl=find_data_ex(:find_skill,event,extstr.split(' '))
    if skl.nil?
      event.respond "No skill was listed."
      return nil
    elsif !has_any?(skl.type,['Weapon','Assist','Special','Passive(A)','Passive(B)','Passive(C)'])
      str="#{skl.name}#{skl.emotes(bot)} is not an equipable skill."
      str="#{str}\nUse `FEH!edit seal` to equip this as a Sacred Seal." if has_any?(skl.type,['Seal','Passive(S)'])
      event.respond str
      return nil
    elsif skl.level=='example'
      sklz=$skills.reject{|q| q.name != skl.name || q.level=='example' || q.level.include?('W') || !q.can_inherit?(dulx[dunit])}
      if sklz.length<=0
        event.respond "Your *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* cannot equip **#{skl.fullName}**#{skl.emotes(bot,true)}"
        return nil
      end
      skl=sklz[-1].clone
    elsif skl.type.include?('Weapon')
      s=skl.legalize(dulx[dunit])
      skl=s[0].clone if s[1]
    end
    if !skl.can_inherit?(dulx[dunit])
      event.respond "Your *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* cannot equip **#{skl.fullName}**#{skl.emotes(bot,true)}"
      return nil
    end
    m=skl.backwards_tree(dulx[dunit])
    mm=m.map{|q| q.fullName}
    str="Your *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* has now equipped **#{skl.fullName}**#{skl.emotes(bot,true)}."
    if !m[0].prerequisite.nil? && m[0].prerequisite.length>0
      mm.unshift('~~unknown~~')
      str="#{str}\nIt has some split prerequisites and I didn't know which to use, so that's marked as unknown."
    end
    if skl.type.include?('Weapon')
      dulx[dunit].skills[0]=mm.map{|q| q}
      if dulx[dunit].name=='Kiran'
        newclz=nil
        newclz=['Red', 'Blade'] if m[-1].weapon_class=='Sword (Red Blade)'
        newclz=['Red', 'Tome'] if m[-1].weapon_class=='Sword (Red Blade)'
        newclz=['Blue', 'Blade'] if m[-1].weapon_class=='Sword (Red Blade)'
        newclz=['Blue', 'Tome'] if m[-1].weapon_class=='Sword (Red Blade)'
        newclz=['Green', 'Blade'] if m[-1].weapon_class=='Sword (Red Blade)'
        newclz=['Green', 'Tome'] if m[-1].weapon_class=='Sword (Red Blade)'
        newclz=['Purple', 'Summon Gun'] if m[-1].weapon_class=='Summon Gun'
        if dulx[dunit].weapon.nil?
          event.respond "#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} cannot equip that weapon.  Please try again."
          return nil
        end
        dulx[dunit].weapon=newclz
      end
    elsif skl.type.include?('Assist')
      dulx[dunit].skills[1]=mm.map{|q| q}
    elsif skl.type.include?('Special')
      dulx[dunit].skills[2]=mm.map{|q| q}
    elsif skl.type.include?('Passive(A)')
      dulx[dunit].skills[3]=mm.map{|q| q}
    elsif skl.type.include?('Passive(B)')
      dulx[dunit].skills[4]=mm.map{|q| q}
    elsif skl.type.include?('Passive(C)')
      dulx[dunit].skills[5]=mm.map{|q| q}
    end
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['support','marry','marriage'].include?(cmd.downcase) && !supdel
    if dulx[dunit].true_support=='S'
      event.respond "You've already married #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}."
    elsif dulx[dunit].true_support=='A'
      dulx[dunit].true_support='S'
      dulx[dunit].support='S'
      donorunits_save(uid,dulx)
      event.respond "You've married #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}!  (Support rank **#{dulx[dunit].support}**)"
    elsif dulx[dunit].true_support=='B'
      dulx[dunit].true_support='A'
      dulx[dunit].support='A'
      donorunits_save(uid,dulx)
      event.respond "You've proposed to #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}!  (Support rank **#{dulx[dunit].support}**)"
    elsif dulx[dunit].true_support=='C'
      dulx[dunit].true_support='B'
      dulx[dunit].support='B'
      donorunits_save(uid,dulx)
      event.respond "You've started dating #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}!  (Support rank **#{dulx[dunit].support}**)"
    elsif dulx.reject{|q| [nil,'','-',' '].include?(q.true_support)}.length>=3
      x=dulx.reject{|q| [nil,'','-',' '].include?(q.true_support)}.map{|q| "*#{q.name}#{q.emotes(bot,false)}*"}
      event.respond "You're already supporting #{list_lift(x,'and')}.\nPlease remove your support with one of these units first."
    else
      dulx[dunit].true_support='C'
      dulx[dunit].support='C'
      donorunits_save(uid,dulx)
      event.respond "You've befriended #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}!  (Support rank **#{dulx[dunit].support}**)"
    end
  elsif supdel
    if [nil,'','-'].include?(dulx[dunit].true_support)
      event.respond "You never had support with your #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}."
    else
      dulx[dunit].true_support=''
      dulx[dunit].support=''
      donorunits_save(uid,dulx)
      event.respond "You've removed your support with your #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}."
    end
  elsif ['seal'].include?(cmd.downcase)
    skl=find_data_ex(:find_skill,event,extstr.split(' '))
    if skl.nil?
      event.respond "No skill was listed."
      return nil
    elsif !has_any?(skl.type,['Seal','Passive(S)'])
      event.respond "#{skl.name}#{skl.emotes(bot)} is not a Sacred Seal.  Use `FEH!edit equip` to equip that skill."
      return nil
    elsif skl.level=='example'
      sklz=$skills.reject{|q| q.name != skl.name || q.level=='example' || q.level.include?('W') || !has_any?(q.type,['Seal','Passive(S)'])}
      skl=sklz[-1].clone
    end
    if !skl.can_inherit?(dulx[dunit])
      event.respond "Your *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* cannot equip the **#{skl.fullName}**<:Passive_S:443677023626330122> Seal."
      return nil
    end
    dulx[dunit].skills[6]=[skl.fullName]
    str="Your *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* is now using the **#{skl.fullName}**<:Passive_S:443677023626330122> Seal."
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['refine','refinement','refinery'].include?(cmd.downcase)
    dulx[dunit].skills[0].pop if dulx[dunit].skills[0][-1].include?(' (+) ')
    wpname=dulx[dunit].skills[0][-1]
    crs=false
    crs=true if wpname.include?('~~')
    wpname=wpname.gsub('~~','').gsub('__','')
    wpn=$skills.find_index{|q| q.name==wpname}
    wpn=$skills[wpn] unless wpn.nil?
    if wpn.nil?
      event.respond "The weapon equipped to your #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}, #{wpname}, does not exist."
      return nil
    elsif wpn.refine.nil?
      event.respond "The weapon equipped to your #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}, **#{wpn.name}#{wpn.emotes(bot)}**, cannot be refined."
      return nil
    end
    words=[]
    words.push('Effect') if !wpn.exclusivity.nil? || !wpn.refinement_name.nil? || !wpn.refine.inner.nil?
    if wpn.restrictions.include?('Staff Users Only') && wpn.tome_tree=='WrazzleDazzle'
      words.push('Wrathful') unless wpn.description.include?("This weapon's damage is calculated the same as other weapons.") || wpn.description.include?('Damage from staff calculated like other weapons.')
      words.push('Dazzling') unless wpn.description.include?('The foe cannot counterattack.') || wpn.description.include?('Foe cannot counterattack.')
    elsif wpn.restrictions.include?('Staff Users Only') && wpn.tome_tree.nil?
    else
      words.push('Attack')
      words.push('Speed')
      words.push('Defense')
      words.push('Resistance')
    end
    refne=''
    for i in 0...args.length
      if refne.length.zero?
        refne='Effect' if ['effect','special','eff','+effect','+special','+eff'].include?(args[i].downcase) && words.include?('Effect')
        refne='Wrathful' if ['wrazzle','wrathful','+wrazzle','+wrathful','=w'].include?(args[i].downcase) && words.include?('Wrathful')
        refne='Dazzling' if ['dazzle','dazzling','+dazzle','+dazzling','+d'].include?(args[i].downcase) && words.include?('Dazzling')
        refne='Attack' if ['attack','atk','att','strength','str','magic','mag','+attack','+atk','+att','+strength','+str','+magic','+mag'].include?(args[i].downcase) && words.include?('Attack')
        refne='Speed' if ['spd','speed','+spd','+speed'].include?(args[i].downcase) && words.include?('Speed')
        refne='Defense' if ['defense','def','defence','+defense','+def','+defence'].include?(args[i].downcase) && words.include?('Defense')
        refne='Resistance' if ['res','resistance','+res','+resistance'].include?(args[i].downcase) && words.include?('Resistance')
      end
    end
    refne='Effect' if refne.length.zero? && words.include?('Effect')
    refne=words[0] if refne.length.zero? && words.length==1
    if refne.length.zero?
      event.respond "No refinement was defined.  Your options are:\n#{words.join("\n")}"
      return nil
    end
    m="#{wpname} (+) #{refne} Mode"
    m="~~#{m}~~" if crs
    dulx[dunit].skills[0].push(m)
    str="The weapon equipped to your *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}*, **#{wpn.name}#{wpn.emotes(bot)}**, has been refined with its #{refne} Mode."
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['flower','flowers','dragonflower','dragonflowers'].include?(cmd.downcase)
    if dulx[dunit].dragonflowers>=dulx[dunit].dragonflowerMax
      event.respond "Your #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} is already at max flowers."
      return nil
    elsif args.map{|q| q.downcase}.include?('reset')
      dulx[dunit].dragonflowers=0
      str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}**'s dragonflower count has been reset to #{dulx[dunit].dragonflowerEmote}+0."
      donorunits_save(uid,dulx)
      event.respond str
      return nil
    end
    x=1
    x=flurp[0] unless flurp[0].nil?
    x=flurp[1] unless flurp[1].nil?
    x=flurp[8] unless flurp[8].nil?
    dulx[dunit].dragonflowers+=x
    dulx[dunit].dragonflowers=[dulx[dunit].dragonflowers,dulx[dunit].dragonflowerMax].min
    str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** now has a total of #{dulx[dunit].dragonflowerEmote}+#{dulx[dunit].dragonflowers}."
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['pairup','pair','pair-up','paired','cohort'].include?(cmd.downcase)
    unt2=find_data_ex(:find_unit,event,extstr.split(' '),nil,bot,false,0)
    dunit2=nil
    dunit2=dulx.find_index{|q| q.name==unt2.name} unless unt2.nil?
    order=[]
    if dunit2.nil? || dunit==dunit2
      event.respond "This subcommand requires two donor units."
      return nil
    elsif !dulx[dunit].legendary.nil? && dulx[dunit].legendary[1]=='Duel'
      order=[dulx[dunit].clone,dulx[dunit2].clone]
    elsif !dulx[dunit2].legendary.nil? && dulx[dunit2].legendary[1]=='Duel'
      order=[dulx[dunit2].clone,dulx[dunit].clone]
    else
      event.respond "Neither #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} nor #{dulx[dunit2].name}#{dulx[dunit2].emotes(bot,false)} is a unit that has controllable Pair-Ups."
      return nil
    end
    for i in 0...dulx.length
      dulx[i].cohort=nil if [unt.name,unt2.name].include?(dulx[i].cohort)
    end
    dulx[dunit].cohort=dulx[dunit2].name
    dulx[dunit2].cohort=dulx[dunit].name
    ctype='cohort unit'
    ctype='pocket buddy' if ['Sakura','Bernie'].include?(order[1].name)
    donorunits_save(uid,dulx)
    event.respond "Your **#{order[0].name}#{order[0].emotes(bot,false)}** is now using **#{order[1].name}#{order[1].emotes(bot,false)}** as a #{ctype}."
  elsif ['resplendant','resplendent','ascension','ascend','resplend'].include?(cmd.downcase)
    if !unt.hasResplendent?
      event.respond "#{unt.name}#{untz.emotes(bot,false)} does not have a Resplendent Ascension available to them."
      return nil
    end
    r=dulx[dunit].resplendent
    str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** has reached #{dulx[dunit].pronoun(true)} Resplendent Ascension."
    if r=='r'
      r='u'
      str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** keeps #{dulx[dunit].pronoun(true)} Resplendent Ascension's stats, but is using #{dulx[dunit].pronoun(true)} default art."
    elsif r=='u'
      r='r'
      str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** is returning to #{dulx[dunit].pronoun(true)} Resplendent Ascension."
    else
      r='r'
    end
    r="#{r}f" if dulx[dunit].forma
    dulx[dunit].rarity="#{dulx[dunit].rarity.to_i}#{r}"
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['forma'].include?(cmd.downcase)
    if !unt.hasForma?
      event.respond "#{unt.name}#{untz.emotes(bot,false)} is unavailable as a Forma Unit."
      return nil
    end
    r=dulx[dunit].resplendent
    str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** is now a Forma Unit."
    if dulx[dunit].forma
      str="Your **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** is no longer a Forma Unit."
    else
      r="#{r}f"
    end
    dulx[dunit].rarity="#{dulx[dunit].rarity.to_i}#{r}"
    donorunits_save(uid,dulx)
    event.respond str
  else
    event.respond 'Edit mode was not specified.'
  end
  return nil
end

def snagstats(event,bot,f=nil,f2=nil)
  nicknames_load()
  data_load(['units','skills','groups','tags','games'])
  metadata_load()
  f='' if f.nil?
  f2='' if f2.nil?
  if ['servers','server','members','member','shard','shards','user','users'].include?(f.downcase)
    mx=Shards*1
    mx=f2.to_i if f2.to_i.to_s==f2 && event.user.id==167657750971547648
    str="**I am in #{longFormattedNumber(@server_data[0].inject(0){|sum,x| sum + x })} servers.**"
    for i in 0...mx
      m=i
      m=i+1 if i>3
      m=4 if m>@server_data[0].length-1
      str=extend_message(str,"The #{shard_data(0,true,mx)[i]} Shard is in #{longFormattedNumber(@server_data[0][m])} server#{"s" if @server_data[0][m]!=1}.",event)
    end
    if Shardizard==-1
      bot.servers.values(&:members)
      str=extend_message(str,"The Smol Shard is in 5 servers.",event)
    end
    str=extend_message(str,"The #{shard_data(0,false,mx)[4]} Shard is in 1 server.",event,2) if event.user.id==167657750971547648
    event.respond str
    return nil
  elsif ['alts','alt','alternate','alternates','alternative','alternatives'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3) rescue nil
    data_load(['unit'])
    nicknames_load()
    untz=$units.map{|q| q}
    untz2=[]
    for i in 0...untz.length
      m=[]
      m.push('default') if untz[i].name==untz[i].alts[0] || untz[i].alts[0][untz[i].alts[0].length-1,1]=='*'
      m.push('faceted') if untz[i].alts[0][0,1]=='*' && untz[i].alts.length>1
      m.push('sensible') if untz[i].alts[0][0,1]=='*' && untz[i].alts.length<2
      m.push('seasonal') if untz[i].availability[0].include?('s') && untz[i].legendary.nil?
      m.push('community-voted') if untz[i].name.include?('(Brave)')
      m.push('Legendary/Mythic') if !untz[i].legendary.nil?
      m.push('Fallen') if untz[i].name.include?('(Fallen)')
      m.push('out-of-left-field') if m.length<=0
      n=''
      unless untz[i].name==untz[i].alts[0] || untz[i].alts[0][untz[i].alts[0].length-1,1]=='*'
        k=untz.reject{|q| q.alts[0].gsub('*','')!=untz[i].alts[0].gsub('*','') || q.name==untz[i].name || !(q.name==q.alts[0] || q.alts[0].include?('*'))}
        n="x" if k.length<=0
        k=untz.reject{|q| q.availability[0].include?('-') || q.alts[0].gsub('*','')!=untz[i].alts[0].gsub('*','') || q.name==untz[i].name || !(q.name==q.alts[0] || q.alts[0].include?('*'))}
        n="#{n}y" if k.length<=0
      end
      untz2.push([untz[i].name,untz[i].alts.map{|q| q.gsub('*','')},m,n,untz[i].fake,untz[i].availability[0]])
      unless untz[i].duo.nil?
        for i2 in 0...untz[i].duo.length
          m="#{untz[i].duo[i2][1]}"
          n=''
          k=untz.reject{|q| q.alts[0].gsub('*','')!=m || q.name==untz[i].name || !(q.name==q.alts[0] || q.alts[0].include?('*'))}
          n="x" if k.length<=0
          k=untz.reject{|q| q.availability[0].include?('-') || q.alts[0].gsub('*','')!=m || q.name==untz[i].name || !(q.name==q.alts[0] || q.alts[0].include?('*'))}
          n="#{n}y" if k.length<=0
          untz2.push([untz[i].name,[m],['Duo/Harmonic backpack'],n,untz[i].fake,untz[i].availability[0]])
        end
      end
    end
    untz2.uniq!
    all_units=untz2.reject{|q| !q[4].nil? && !has_any?(get_markers(event), q[4][0])}
    all_units=untz2.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    legal_units=untz2.reject{|q| !q[4].nil?}
    a2=all_units.reject{|q| q[1][1].nil?}.map{|q| q[1][0]}.uniq
    l2=legal_units.reject{|q| q[1][1].nil?}.map{|q| q[1][0]}.uniq
    a3=all_units.reject{|q| !q[2].include?('default')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('default')}.uniq
    str="There are #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} characters in their default form, alongside #{l2.length}#{" (#{a2.length})" unless l2.length==a2.length} sets of character facets *(Tiki, dual-gendered characters, etc.)*"
    a3=all_units.reject{|q| !q[2].include?('sensible')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('sensible')}.uniq
    str="#{str}\nThere are #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} sensible alts *(Masked Marth, Dark Azura, etc.)*"
    a3=all_units.reject{|q| !q[2].include?('seasonal')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('seasonal')}.uniq
    str="#{str}\nThere are #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} seasonal alts"
    a3=all_units.reject{|q| !q[2].include?('community-voted')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('community-voted')}.uniq
    str="#{str}\nThere are #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} community-voted alts *(CYL winners)*"
    a3=all_units.reject{|q| !q[2].include?('Legendary/Mythic')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('Legendary/Mythic')}.uniq
    str="#{str}\nThere are #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} Legendary/Mythic alts"
    a3=all_units.reject{|q| !q[2].include?('Fallen')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('Fallen')}.uniq
    str="#{str}\nThere are #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} Fallen alts"
    a3=all_units.reject{|q| !q[2].include?('out-of-left-field')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('out-of-left-field')}.uniq
    str="#{str}\nThere are #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} out-of-left-field alts *(Eirika, Reinhardt, Hinoka, etc.)*"
    k=[]; k2=[]; k3=[]
    for i in 0...all_units.length
      x="#{'~~' unless all_units[i][4].nil? || all_units[i][4][0].length.zero?}"
      k.push("#{x}#{all_units[i][1][0]}#{x}") if !all_units[i][2].include?('faceted') && all_units[i][3].include?('x')
      k2.push("#{x}#{all_units[i][1][0]}#{x}") if !all_units[i][2].include?('faceted') && all_units[i][3].include?('y')
      k3.push("#{x}#{all_units[i][1][0]}#{x}") if !all_units[i][2].include?('faceted') && all_units[i][2].include?('Duo/Harmonic backpack') && all_units[i][3].include?('x')
    end
    k3.uniq!
    k=k.reject{|q| k3.include?(q)}.uniq
    k2=k2.reject{|q| [k,k3].flatten.include?(q)}.uniq
    u=untz.find_index{|q| q.name=='Veronica'}
    unless u.nil?
      u=untz[u]
      k2.push('Veronica') if u.availability[0].include?('-')
    end
    x=2
    if k.length>0 || k2.length>0 || k3.length>0
      str=extend_message(str,"The following characters have alts but not default units in FEH: #{list_lift(k.sort.map{|q| "*#{q}*"},"and")}.",event,2) if k.length>0
      str=extend_message(str,"The following characters have playable alts but not playable default units in FEH: #{list_lift(k2.sort.map{|q| "*#{q}*"},"and")}.",event) if k2.length>0
      str=extend_message(str,"The following characters are used as Duo/Harmonic backpacks, but have no base unit in FEH: #{list_lift(k3.sort.map{|q| "*#{q}*"},"and")}.",event) if k3.length>0
      x=1
    end
    k=legal_units.map{|q| [q[1][0],0]}.uniq
    for i in 0...k.length
      k[i][1]=legal_units.reject{|q| q[1][0]!=k[i][0]}.uniq.length
    end
    k=k.sort{|b,a| supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)}
    k=k.reject{|q| q[1]!=k[0][1]}
    str=extend_message(str,"#{list_lift(k.map{|q| "*#{q[0]}*"},'and')} #{"is" if k.length==1}#{"are" unless k.length==1} the character#{"s" unless k.length==1} with the most alts, with #{k[0][1]} alts (including the default)#{" each" unless k.length==1}.",event,x)
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
    str=extend_message(str,"#{list_lift(k.map{|q| "*#{q[0]}*"},'and')} #{"is" if k.length==1}#{"are" unless k.length==1} the character facet#{"s" unless k.length==1} with the most alts, with #{k[0][1]} alts (including the default)#{" each" unless k.length==1}.",event)
    event.respond str
    return nil
  elsif ['hero','heroes','heros','units','characters','unit','character','charas','chara','chars','char'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil
    all_units=$units.reject{|q| !q.isPostable?(event)}
    all_units=$units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    legal_units=$units.reject{|q| !q.fake.nil?}
    str="**There are #{longFormattedNumber(legal_units.length)}#{" (#{longFormattedNumber(all_units.length)})" unless legal_units.length==all_units.length} units, including:**"
    unless f2.nil? || f2.length<=0
      k=find_in_units(bot,event,[f2],13,false,true)
      all_units=all_units.reject{|q| !k[1].map{|q2| q2.name}.include?(q.name)}.uniq
      legal_units=legal_units.reject{|q| !k[1].map{|q2| q2.name}.include?(q.name)}.uniq
      str="#{k[0].join("\n")}\n**With these filters, there are #{longFormattedNumber(legal_units.length)}#{" (#{longFormattedNumber(all_units.length)})" unless legal_units.length==all_units.length} units, including:**"
    end
    str2=''
    l=legal_units.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=all_units.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} summonable unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| !q.availability[0].include?('g')}
    a=all_units.reject{|q| !q.availability[0].include?('g')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} Grand Hero Battle reward unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| !q.availability[0].include?('t')}
    a=all_units.reject{|q| !q.availability[0].include?('t')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} Tempest Trials reward unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?}
    a=all_units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} seasonal unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.legendary.nil?}
    a=all_units.reject{|q| q.legendary.nil?}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} legendary/mythic unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.duo.nil?}
    a=all_units.reject{|q| q.duo.nil?}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} duo/harmonic unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| !q.availability[0].include?('-')}
    a=all_units.reject{|q| !q.availability[0].include?('-')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} unobtainable unit#{'s' unless m=='1'}" unless m=='0'
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    str2=''
    l=legal_units.reject{|q| q.weapon_color != 'Red'}
    a=all_units.reject{|q| q.weapon_color != 'Red'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    l=l.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=a.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="<:Red_Unknown:443172811486396417> #{m} red unit#{'s' unless m=='1'},   <:Orb_Red:455053002256941056> with #{m2} in the main summon pool" unless m=='0'
    l=legal_units.reject{|q| q.weapon_color != 'Blue'}
    a=all_units.reject{|q| q.weapon_color != 'Blue'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    l=l.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=a.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Blue_Unknown:467112473980305418> #{m} blue unit#{'s' unless m=='1'},   <:Orb_Blue:455053001971859477> with #{m2} in the main summon pool" unless m=='0'
    l=legal_units.reject{|q| q.weapon_color != 'Green'}
    a=all_units.reject{|q| q.weapon_color != 'Green'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    l=l.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=a.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Green_Unknown:467122926785921044> #{m} green unit#{'s' unless m=='1'},   <:Orb_Green:455053002311467048> with #{m2} in the main summon pool" unless m=='0'
    l=legal_units.reject{|q| q.weapon_color != 'Colorless'}
    a=all_units.reject{|q| q.weapon_color != 'Colorless'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    l=l.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=a.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Colorless_Unknown:443692132738531328> #{m} colorless unit#{'s' unless m=='1'},   <:Orb_Colorless:455053002152083457> with #{m2} in the main summon pool" unless m=='0'
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    str2=''
    l=legal_units.reject{|q| q.weapon_type != 'Blade'}
    a=all_units.reject{|q| q.weapon_type != 'Blade'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    unless m=='0'
      l2=l.reject{|q| q.weapon_color !='Red'}
      a2=a.reject{|q| q.weapon_color !='Red'}
      m2="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      l2=l.reject{|q| q.weapon_color !='Blue'}
      a2=a.reject{|q| q.weapon_color !='Blue'}
      m3="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      l2=l.reject{|q| q.weapon_color !='Green'}
      a2=a.reject{|q| q.weapon_color !='Green'}
      m4="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      str2="#{str2}\n<:Gold_Blade:774013609184460860> #{m} blade user#{'s' unless m=='1'}:   <:Red_Blade:443172811830198282> #{m2} sword#{'s' unless m2=='1'}, <:Blue_Blade:467112472768151562> #{m3} lance#{'s' unless m3=='1'}, <:Green_Blade:467122927230386207> #{m4} axe#{'s' unless m4=='1'}"
    end
    l=legal_units.reject{|q| q.weapon_type != 'Tome'}
    a=all_units.reject{|q| q.weapon_type != 'Tome'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    unless m=='0'
      l2=l.reject{|q| q.weapon_color !='Red'}
      a2=a.reject{|q| q.weapon_color !='Red'}
      m2="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      l2=l.reject{|q| q.weapon_color !='Blue'}
      a2=a.reject{|q| q.weapon_color !='Blue'}
      m3="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      l2=l.reject{|q| q.weapon_color !='Green'}
      a2=a.reject{|q| q.weapon_color !='Green'}
      m4="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      l2=l.reject{|q| q.weapon_color !='Colorless'}
      a2=a.reject{|q| q.weapon_color !='Colorless'}
      m5="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      str2="#{str2}\n<:Gold_Tome:774013610736484353> #{m} tome user#{'s' unless m=='1'}:   <:Red_Tome:443172811826003968> #{m2} red, <:Blue_Tome:467112472394858508> #{m3} blue, <:Green_Tome:467122927666593822> #{m4} green, <:Colorless_Tome:443692133317345290> #{m5} colorless"
    end
    l=legal_units.reject{|q| q.weapon_type != 'Dragon'}
    a=all_units.reject{|q| q.weapon_type != 'Dragon'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Gold_Dragon:774013610908581948> #{m} dragon unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.weapon_type != 'Bow'}
    a=all_units.reject{|q| q.weapon_type != 'Bow'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Gold_Bow:774013609389981726> #{m} bow user#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.weapon_type != 'Dagger'}
    a=all_units.reject{|q| q.weapon_type != 'Dagger'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Gold_Dagger:774013610862968833> #{m} dagger user#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.weapon_type != 'Staff'}
    a=all_units.reject{|q| q.weapon_type != 'Staff'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Gold_Staff:774013610988797953> #{m} staff user#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.weapon_type != 'Beast'}
    a=all_units.reject{|q| q.weapon_type != 'Beast'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    unless m=='0'
      l2=l.reject{|q| q.movement !='Infantry'}
      a2=a.reject{|q| q.movement !='Infantry'}
      m2="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      l2=l.reject{|q| q.movement !='Cavalry'}
      a2=a.reject{|q| q.movement !='Cavalry'}
      m3="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      l2=l.reject{|q| q.movement !='Flier'}
      a2=a.reject{|q| q.movement !='Flier'}
      m4="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      l2=l.reject{|q| q.movement !='Armor'}
      a2=a.reject{|q| q.movement !='Armor'}
      m5="#{longFormattedNumber(l2.length)}#{" (#{longFormattedNumber(a2.length)})" unless l2.length==a2.length}"
      str2="#{str2}\n<:Gold_Beast:774013608191459329> #{m} beast unit#{'s' unless m=='1'}:   <:Icon_Move_Infantry:443331187579289601> #{m2} infantry, <:Icon_Move_Cavalry:443331186530451466> #{m3} cavalry, <:Icon_Move_Flier:443331186698354698> #{m4} flying, <:Icon_Move_Armor:443331186316673025> #{m5} armored"
    end
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    str2=''
    l=legal_units.reject{|q| q.movement != 'Infantry'}
    a=all_units.reject{|q| q.movement != 'Infantry'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Icon_Move_Infantry:443331187579289601> #{m} infantry unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.movement != 'Cavalry'}
    a=all_units.reject{|q| q.movement != 'Cavalry'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Icon_Move_Cavalry:443331186530451466> #{m} cavalry unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.movement != 'Flier'}
    a=all_units.reject{|q| q.movement != 'Flier'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Icon_Move_Flier:443331186698354698> #{m} flying unit#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.movement != 'Armor'}
    a=all_units.reject{|q| q.movement != 'Armor'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Icon_Move_Armor:443331186316673025> #{m} armored unit#{'s' unless m=='1'}" unless m=='0'
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
      str2=''
      x=['FE1','FE2','FE3','FE4','FE5','FE6','FE7','FE8','FE9','FE10','FE11','FE12','FE13','FE14','FEW','TMS','FE15','FE16']
      for i in 0...x.length
        l=legal_units.reject{|q| !q.from_game(x[i])}
        a=all_units.reject{|q| !q.from_game(x[i])}
        m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
        l=legal_units.reject{|q| !q.from_game(x[i],true)}
        a=all_units.reject{|q| !q.from_game(x[i],true)}
        m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"; m2='all' if m2==m; m2='none' if m2=='0'
        str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *#{x[i]}*,    #{m2} of which are credited" unless m=='0'
      end
      l=legal_units.reject{|q| !q.from_game('FEH')}
      a=all_units.reject{|q| !q.from_game('FEH')}
      m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
      l=legal_units.reject{|q| !q.from_game('FEH',true)}
      a=all_units.reject{|q| !q.from_game('FEH',true)}
      m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"; m2='all' if m2==m; m2='none' if m2=='0'
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FEH* itself,    #{m2} of which are credited" unless m=='0'
      str2=str2[1,str2.length-1] if str2[0,1]=="\n"
      str2=str2[2,str2.length-2] if str2[0,2]=="\n"
      str=extend_message(str,str2,event,2)
    end
    event.respond str
    return nil
  elsif ['skill','skills','weapon','weapons','assist','assists','special','specials','passive','passives'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3) rescue nil
    legal_skills=$skills.reject{|q| q.level=='example' || !q.fake.nil?}
    all_skills=$skills.reject{|q| q.level=='example' || !q.isPostable?(event)}
    all_skills=$skills.reject{|q| q.level=='example'} if event.server.nil? && event.user.id==167657750971547648
    str=''
    str2=skill_data(legal_skills,all_skills,event,0)
    str=extend_message(str,str2,event,2)
    sklz=$skills.reject{|q| q.isPassive? && !['-','example'].include?(q.level)}
    for i in 0...sklz.length # display items with both the non-plus and + versions in the list as only one entry
      sklz[i].name="#{sklz[i].name.gsub('+','')}[+]" if sklz[i].name[-1]=='+' && sklz.map{|q| q.name}.include?(sklz[i].name.gsub('+',''))
    end
    x=sklz.map{|q| q.name}
    sklz=sklz.reject{|q| x.include?("#{q.name}[+]")}
    x=sklz.map{|q| q.id/10}.uniq
    y=[]
    for i in 0...x.length
      z=sklz.reject{|q| q.id/10 != x[i]}.sort{|a,b| a.id<=>b.id}
      if z[0].name[0,10]=='Falchion ('
        y.push(z)
        y.flatten!
      elsif has_any?(z.map{|q| q.tags}.flatten,['Iron','Steel','Silver']) && z[-1].name.split(' ').length>1 && !z[0].restrictions.include?('Dragons Only')
        z[-1].name="#{z.map{|q| q.name.split(' ')[0]}.join('/')} #{z[-1].name.split{' '}[1,z[-1].name.split{' '}.length-1].join(' ')}"
        y.push(z[-1])
      else
        z[-1].name=z.map{|q| q.name}.join('/')
        y.push(z[-1])
      end
    end
    legal_skills=y.reject{|q| !q.fake.nil?}
    all_skills=y.reject{|q| !q.isPostable?(event)}
    all_skills=y.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    str2=skill_data(legal_skills,all_skills,event,1)
    str=extend_message(str,str2,event,2)
    event.respond str
    return nil
  elsif ['structure','structures','structs','struct'].include?(f.downcase)
    m=$structures.reject{|q| q.level=='example'}.map{|q| "#{q.fullName} / #{q.type.join('/') unless q.type.include?('Offensive') || q.type.include?('Defensive')}"}.uniq
    str="**There are #{longFormattedNumber(m.length)} structure levels, including:**"
    m=$structures.reject{|q| q.level=='example'}.map{|q| [q.name,q.level,q.type]}.uniq
    str="#{str}\n<:Offensive_Structure:510774545997758464> #{longFormattedNumber(m.reject{|q| !q[2].include?('Offensive')}.length)} Offensive structure levels"
    str="#{str}\n<:Defensive_Structure:510774545108566016> #{longFormattedNumber(m.reject{|q| !q[2].include?('Defensive')}.length)} Defensive structure levels"
    str="#{str}\n<:Trap_Structure:510774545179869194> #{longFormattedNumber(m.reject{|q| !q[2].include?('Trap')}.length)} Trap levels"
    str="#{str}\n<:Resource_Structure:510774545154572298> #{longFormattedNumber(m.reject{|q| !q[2].include?('Resources')}.length)} Resource structure levels"
    str="#{str}\n<:Mjolnir_Structure:691254233588301866> #{longFormattedNumber(m.reject{|q| !q[2].include?('Mjolnir')}.length)} Mjolnir Strike levels"
    m=$structures.reject{|q| q.level=='example'}.map{|q| [q.name,0,q.type]}.uniq
    str2="**There are #{longFormattedNumber(m.length)} structures, including:**"
    str2="#{str2}\n<:Offensive_Structure:510774545997758464> #{longFormattedNumber(m.reject{|q| !q[2].include?('Offensive')}.length)} Offensive structures"
    str2="#{str2}\n<:Defensive_Structure:510774545108566016> #{longFormattedNumber(m.reject{|q| !q[2].include?('Defensive')}.length)} Defensive structures"
    str2="#{str2}\n<:Trap_Structure:510774545179869194> #{longFormattedNumber(m.reject{|q| !q[2].include?('Trap')}.length)} Traps"
    str2="#{str2}\n<:Resource_Structure:510774545154572298> #{longFormattedNumber(m.reject{|q| !q[2].include?('Resources')}.length)} Resource structures"
    str2="#{str2}\n<:Mjolnir_Structure:691254233588301866> #{longFormattedNumber(m.reject{|q| !q[2].include?('Mjolnir')}.length)} Mjolnir Strike structures"
    str2="#{str2}\n<:Ornamental_Structure:510774545150640128> #{longFormattedNumber(m.reject{|q| !q[2].include?('Ornament')}.length)} Ornaments"
    str2="#{str2}\n<:Resort_Structure:565064414521196561> #{longFormattedNumber(m.reject{|q| !q[2].include?('Resort')}.length)} Resort-exclusive structures"
    str=extend_message(str,str2,event,2)
    event.respond str
    return nil
  elsif ['item','items'].include?(f.downcase)
    str2="**There are #{longFormattedNumber($itemus.length)} items, including:**"
    m=$itemus.reject{|q| q.type !='Main'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} main items"
    m=$itemus.reject{|q| q.type !='Implied'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} implied items"
    m=$itemus.reject{|q| q.type !='Blessing'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} blessings"
    m=$itemus.reject{|q| q.type !='Growth'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} unit growth items"
    m=$itemus.reject{|q| q.type !='Assault'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} Arena Assault / Resonant Blades items"
    m=$itemus.reject{|q| q.type !='Event'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} event items"
    str2="#{str2}\n~~3 thrones which are counted as structures in my data even though FEH counts them as both structures and items~~"
    event.respond str2
    return nil
  elsif ['accessories','accessory','accessorys','accessorie'].include?(f.downcase)
    str2="**There are #{longFormattedNumber($accessories.length)} accessories, including:**"
    m=$accessories.reject{|q| q.type !='Hair'}
    str2="#{str2}\n\n<:Accessory_Type_Hair:531733124741201940> #{longFormattedNumber(m.length)} pins and other hair accessories"
    m=$accessories.reject{|q| q.type !='Hat'}
    str2="#{str2}\n<:Accessory_Type_Hat:531733125227741194> #{longFormattedNumber(m.length)} hats and other top-of-head accessories"
    m=$accessories.reject{|q| q.type !='Mask'}
    str2="#{str2}\n<:Accessory_Type_Mask:531733125064163329> #{longFormattedNumber(m.length)} masks and other face accessories"
    m=$accessories.reject{|q| q.type !='Tiara'}
    str2="#{str2}\n<:Accessory_Type_Tiara:531733130734731284> #{longFormattedNumber(m.length)} tiaras and other back-of-head accessories"
    m=$accessories.reject{|q| !q.description.include?('Proof of victory over')}
    str2="#{str2}\n\n#{longFormattedNumber(m.length)} Golden Accessories"
    m=$accessories.reject{|q| !q.name.include?('8-Bit ')}
    str2="#{str2}\n#{longFormattedNumber(m.length)} 8-Bit Accessories"
    m=$accessories.reject{|q| !q.name.include?(' EX')}
    str2="#{str2}\n#{longFormattedNumber(m.length*2)} Forging Bonds Accessories (#{longFormattedNumber(m.length)} pairs)"
    m=$accessories.reject{|q| q.obtain.nil? || !q.obtain.include?('Illusory Dungeon')}
    str2="#{str2}\n#{longFormattedNumber(m.length*2)} Tap Battle Accessories"
    m=$accessories.reject{|q| q.name[0,4]!='(S) '}
    str2="#{str2}\n\n<:Summon_Gun:467557566050861074> #{longFormattedNumber(m.length)} Summoner-exclusive Accessories"
    event.respond str2
    return nil
  elsif ['alias','aliases','name','names','nickname','nicknames'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil
    glbl=$aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=$aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    all_units=$units.reject{|q| !q.isPostable?(event)}
    all_units=$units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    all_units=all_units.map{|q| [q.name,q.id,0,0]}
    legal_units=$units.reject{|q| !q.fake.nil?}
    srv_spec=srv_spec.reject{|q| !all_units.map{|q2| q2[1]}.include?(q[1])}
    for j in 0...all_units.length
      all_units[j][2]+=glbl.reject{|q| q[1]!=all_units[j][1]}.length
      all_units[j][3]+=srv_spec.reject{|q| q[1]!=all_units[j][1]}.length
    end
    str="**There are #{longFormattedNumber(glbl.length)} global single-unit aliases.**"
    all_units=all_units.sort{|b,a| supersort(a,b,2).zero? ? supersort(a,b,1) : supersort(a,b,2)}
    k=all_units.reject{|q| q[2]!=all_units[0][2]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2.name==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2.name==q[0]}.nil?}*"}
    str="#{str}\nThe unit#{"s" unless k.length==1} with the most global aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][2]} global aliases#{" each" unless k.length==1}."
    str="#{str}\n\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]unit aliases.**"
    if event.server.nil? && Shardizard==4
      str="#{str}\nDue to being the debug version, I cannot show more information."
    elsif event.server.nil? && Shardizard==-1
      str="#{str}\nDue to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str="#{str}\nServers you and I share account for #{$aliases.reject{|q| q[0]!='Unit' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str="#{str}\nThis server accounts for #{$aliases.reject{|q| q[0]!='Unit' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    all_units=all_units.sort{|b,a| supersort(a,b,3).zero? ? supersort(a,b,0) : supersort(a,b,3)}
    k=all_units.reject{|q| q[3]!=all_units[0][3]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2.name==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2.name==q[0]}.nil?}*"}
    str="#{str}\nThe unit#{"s" unless k.length==1} with the most server-specific aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][2]} server-specific aliases#{" each" unless k.length==1}."
    for i in 0...srv_spec.length
      srv_spec[i][2]=srv_spec[i][2].length
    end
    srv_spec=srv_spec.sort{|b,a| supersort(a,b,2).zero? ? (supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)) : supersort(a,b,2)}
    k=srv_spec.reject{|q| q[2]!=srv_spec[0][2]}.map{|q| "*#{q[0]} = #{all_units[all_units.find_index{|q2| q2[1]==q[1]}][0]}*"}
    str="#{str}\nThe most agreed-upon server-specific alias#{"es are" unless k.length==1}#{" is" if k.length==1} #{list_lift(k,"and")}.  #{srv_spec[0][2]} servers agree on #{"them" unless k.length==1}#{"it" if k.length==1}." if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
    k=srv_spec.map{|q| q[2]}.inject(0){|sum,x| sum + x }
    str="#{str}\nCounting each alias/server combo as a unique alias, there are #{longFormattedNumber(k)} server-specific aliases"
    multi=$aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}
    str="#{str}\n\n**There are #{longFormattedNumber(multi.length)} [global] multi-unit aliases, covering #{multi.map{|q| q[2]}.uniq.length} groups of units.**"
    data_load()
    untz=$units.map{|q| q}
    for i in 0...multi.length
      multi[i][2]=multi[i][2].map{|q| untz[untz.bsearch_index{|q2| q<=>q2.id}].name}
    end
    m=multi.map{|q| [q[2],0]}.uniq
    for i in 0...m.length
      m[i][1]+=multi.reject{|q| q[2]!=m[i][0]}.length
      m[i][0]=m[i][0].join('/')
    end
    m=m.sort{|b,a| supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)}
    k=m.reject{|q| q[1]!=m[0][1]}.map{|q| "*#{q[0]}*"}
    str="#{str}\n#{list_lift(k,"and")} #{"is" if k.length==1}#{"are" unless k.length==1} the group#{"s" unless k.length==1} of units with the most multi-unit aliases, with #{m[0][1]} multi-unit aliases#{" each" unless k.length==1}."
    m=m.sort{|a,b| supersort(a,b,1).zero? ? supersort(b,a,0) : supersort(a,b,1)}
    k=m.reject{|q| q[1]!=m[0][1]}.map{|q| "*#{q[0]}*"}
    str="#{str}\n#{list_lift(k,"and")} #{"is" if k.length==1}#{"are" unless k.length==1} the group#{"s" unless k.length==1} of units with the fewest multi-unit aliases (among those that have them), with #{m[0][1]} multi-unit alias#{"es" unless m[0][1]==1}#{" each" unless k.length==1}." if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
    glbl=$aliases.reject{|q| q[0]!='Skill' || q[2].is_a?(String) || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=$aliases.reject{|q| q[0]!='Skill' || q[2].is_a?(String) || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    all_units=$skills.reject{|q| !q.isPostable?(event)}
    all_units=$skills.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    all_units=all_units.map{|q| [q.id,q.fullName,0,0]}
    legal_skills=$skills.reject{|q| q.level=='example' || !q.fake.nil?}
    srv_spec=srv_spec.reject{|q| !all_units.map{|q| q[0]}.include?(q[1])}
    for j in 0...all_units.length
      all_units[j][2]+=glbl.reject{|q| q[1]!=all_units[j][0]}.length
      all_units[j][3]+=srv_spec.reject{|q| q[1]!=all_units[j][0]}.length
    end
    str2="**There are #{longFormattedNumber(glbl.length)} global single-skill aliases.**"
    all_units=all_units.sort{|b,a| supersort(a,b,2).zero? ? supersort(a,b,1) : supersort(a,b,2)}
    k=all_units.reject{|q| q[2]!=all_units[0][2]}.map{|q| "*#{q[1]}*"}
    str2="#{str2}\nThe skill#{"s" unless k.length==1} with the most global aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][2]} global aliases#{" each" unless k.length==1}."
    str2="#{str2}\n\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]skill aliases.**"
    if event.server.nil? && Shardizard==4
      str2="#{str2}\nDue to being the debug version, I cannot show more information."
    elsif event.server.nil? && Shardizard==-1
      str2="#{str2}\nDue to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str2="#{str2}\nServers you and I share account for #{$aliases.reject{|q| q[0]!='Skill' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str2="#{str2}\nThis server accounts for #{$aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    all_units=all_units.sort{|b,a| supersort(a,b,3).zero? ? supersort(a,b,1) : supersort(a,b,3)}
    k=all_units.reject{|q| q[3]!=all_units[0][3]}.map{|q| "*#{'~~' if legal_skills.find_index{|q2| q2.name==q[0]}.nil?}#{q[1]}#{'~~' if legal_skills.find_index{|q2| q2.name==q[0]}.nil?}*"}
    str2="#{str2}\nThe skill#{"s" unless k.length==1} with the most server-specific aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][3]} server-specific aliases#{" each" unless k.length==1}." unless k.length<=0
    for i in 0...srv_spec.length
      srv_spec[i][2]=srv_spec[i][2].length
    end
    srv_spec=srv_spec.sort{|b,a| supersort(a,b,2).zero? ? (supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)) : supersort(a,b,2)}
    k=srv_spec.reject{|q| q[2]!=srv_spec[0][2]}.map{|q| "*#{q[0]} = #{q[1]}*"}
    k=srv_spec.map{|q| q[2]}.inject(0){|sum,x| sum + x }
    str2="#{str2}\nCounting each alias/server combo as a unique alias, there are #{longFormattedNumber(k)} server-specific aliases"
    str2="#{str2}\n\n**There are 3 [global] multi-skill aliases.**"
    str=extend_message(str,str2,event,3)
    glbl=$aliases.reject{|q| q[0]!='Structure' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=$aliases.reject{|q| q[0]!='Structure' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**There are #{longFormattedNumber(glbl.length)} global [single-]structure aliases.**\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]structure aliases.**"
    if event.server.nil? && Shardizard==4
      str2="#{str2} - Due to being the debug version, I cannot show more information."
    elsif event.server.nil? && Shardizard==-1
      str2="#{str2} - Due to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str2="#{str2} - Servers you and I share account for #{$aliases.reject{|q| q[0]!='Structure' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str2="#{str2} - This server accounts for #{$aliases.reject{|q| q[0]!='Structure' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    str=extend_message(str,str2,event,3)
    glbl=$aliases.reject{|q| q[0]!='Accessory' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=$aliases.reject{|q| q[0]!='Accessory' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**There are #{longFormattedNumber(glbl.length)} global [single-]accessory aliases.**\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]accessory aliases.**"
    if event.server.nil? && Shardizard==4
      str2="#{str2} - Due to being the debug version, I cannot show more information."
    elsif event.server.nil? && Shardizard==-1
      str2="#{str2} - Due to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str2="#{str2} - Servers you and I share account for #{$aliases.reject{|q| q[0]!='Accessory' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str2="#{str2} - This server accounts for #{$aliases.reject{|q| q[0]!='Accessory' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    str=extend_message(str,str2,event,3)
    glbl=$aliases.reject{|q| q[0]!='Item' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=$aliases.reject{|q| q[0]!='Item' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**There are #{longFormattedNumber(glbl.length)} global [single-]item aliases.**\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]item aliases.**"
    if event.server.nil? && Shardizard==4
      str2="#{str2} - Due to being the debug version, I cannot show more information."
    elsif event.server.nil? && Shardizard==-1
      str2="#{str2} - Due to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str2="#{str2} - Servers you and I share account for #{$aliases.reject{|q| q[0]!='Item' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str2="#{str2} - This server accounts for #{$aliases.reject{|q| q[0]!='Item' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    str=extend_message(str,str2,event,3)
    event.respond str
    return nil
  elsif ['groups','group','groupings','grouping'].include?(f.downcase)
    (event.channel.send_temporary_message('Calculating data, please wait...',3) rescue nil) if safe_to_spam?(event)
    str="**There are #{longFormattedNumber($groups.reject{|q| !q.fake.nil?}.length-1)} global groups**"
    if safe_to_spam?(event)
      str="**There are #{longFormattedNumber($groups.reject{|q| !q.fake.nil?}.length-1)} global groups**, including the following dynamic ones:"
      str=extend_message(str,"<:Current_Aether_Bonus:510022809741950986> *Aether Bonus* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='AetherBonus'}].unit_list.length)} current members) - Any unit that is a bonus unit for the current Aether Raids season.",event)
      str=extend_message(str,"<:Current_Arena_Bonus:498797967042412544> *Arena Bonus* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='ArenaBonus'}].unit_list.length)} current members) - Any unit that is a bonus unit for the current Arena season.",event)
      str=extend_message(str,"<:Bannerless:793294155865784380> *Bannerless* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Bannerless'}].unit_list.length)} current members) - Any unit that has never been a focus unit on a banner.",event)
      str=extend_message(str,"<:BraveHero:701268588266520578> *Brave Heroes* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='BraveHeroes'}].unit_list.length)} current members) - Any unit with the phrase *(Brave)* in their internal name.",event)
      str=extend_message(str,"\u{1F4C5} *Daily Rotation* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Daily_Rotation'}].unit_list.length)} current members) - Any unit that can be obtained via the twelve rotating Daily Hero Battle maps.",event)
      str=extend_message(str,"<:DragonEff:701301177370804296> *Falchion Users* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Falchion_Users'}].unit_list.length)} current members) - Any unit that can use one of the three Falchions, or any of their evolutions.",event)
      str=extend_message(str,"<:PurpleFire:701271290987806790> *Fallen Heroes* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='FallenHeroes'}].unit_list.length)} current members) - Any unit with the phrase *(Fallen)* in their internal name.",event)
      str=extend_message(str,"<:Heroic_Grail:574798333898653696> *GHB* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='GHB'}].unit_list.length)} current members) - Any unit that can obtained via a Grand Hero Battle map.",event)
      str=extend_message(str,"<:Forma_Soulless:699085674724327516> *Hall of Forms* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='HallOfForms'}].unit_list.length)} current members) - Any unit was part of a Hall of Forms event.\n      <:Forma_Soul:699042073176965241> *Forma* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Forma'}].unit_list.length)} current members) - Any unit that was part of a Hall of Forms event released after the introduction of Forma Souls.",event)
      str=extend_message(str,"<:Prfless:793294156114034738> *Prfless* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Prfless'}].unit_list.length)} current members) - Any non-seasonal unit that lacks a prf weapon.\n      <:UpForPrf:793294156004982836> *Up4Prf* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Up4Prf'}].unit_list.length)} current members) - The subset of the Prfless group that joined the game either before, or within two banners of, the most recently-released unit to have received a retro-prf, and as such are the most likely considerations for retro-prfs.",event)
      str=extend_message(str,"<:Special_Blade:800880639540068353> *Resonant Bonus* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='ResonantBonus'}].unit_list.length)} current members) - Any unit that is a bonus unit for the current Resonant Blades season.",event)
      str=extend_message(str,"<:Divine_Dew:453618312434417691> *Retro-Prfs* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Retro-Prfs'}].unit_list.length)} current members) - Any unit that has access to a Prf weapon that does not promote from anything.",event)
      str=extend_message(str,"<:Seasonal:701278992677732442> *Seasonals* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Seasonals'}].unit_list.length)} current members) - Any unit that is limited summonable (or related to such an event), but does not give a Legendary Hero boost.\n      \u{1F458} *New Year's* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=="NewYear's"}].unit_list.length)})\n      :hotsprings: *Bathing* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Bathing'}].unit_list.length)})\n      \u{1F498} *Valentine's* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=="Valentine's"}].unit_list.length)})\n      :rabbit: *Bunny* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Bunnies'}].unit_list.length)})\n      \u{1F9FA} *Picnic* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Picnic'}].unit_list.length)})\n      <:RetroMarth:746670895992668181> *Retro* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Retro'}].unit_list.length)})\n      \u{1F470} *Wedding* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Wedding'}].unit_list.length)})\n      :sunny: *Summer* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Summer'}].unit_list.length)})\n      \u{1F483} *Awa Odori* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='AwaOdori'}].unit_list.length)})\n      \u{1F3F4}\u200D\u2620\uFE0F *Pirate* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Pirate'}].unit_list.length)})\n      \u{1F383} *Halloween* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Halloween'}].unit_list.length)})\n      \u{1F977} *Ninja* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Ninja'}].unit_list.length)})\n      \u{1F384} *Christmas* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Christmas'}].unit_list.length)})",event)
      str=extend_message(str,"<:Godly_Grail:612717339611496450> *Tempest* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='Tempest'}].unit_list.length)} current members) - Any unit that can be obtained via a Tempest Trials event.",event)
      str=extend_message(str,"<:Current_Tempest_Bonus:498797966740422656> *Tempest Bonus* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='TempestBonus'}].unit_list.length)} current members) - Any unit that is a bonus unit for the current Tempest Trials event.",event)
      str=extend_message(str,"<:Divine_Mist:701285239611195432> *Worse Than Liki* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=='WorseThanLiki'}].unit_list.length)} current members) - Any unit with every stat equal to or less than the same stat on Tiki(Young)(Earth), excluding Tiki(Young)(Earth) herself.",event)
      display=false
      display=true if event.user.id==167657750971547648
      display=true if !event.server.nil? && !bot.user(167657750971547648).on(event.server.id).nil? && rand(100).zero?
      display=true if !event.server.nil? && bot.user(167657750971547648).on(event.server.id).nil? && rand(10000).zero?
      str=extend_message(str,"<:Icon_Support:448293527642701824> *Mathoo's Waifus* (#{longFormattedNumber($groups[$groups.find_index{|q| q.name=="Mathoo'sWaifus"}].unit_list.length)} current members) - Any unit that my developer would enjoy cuddling.",event) if display
    end
    str=extend_message(str,"**There are #{longFormattedNumber($groups.reject{|q| q.fake.nil?}.length)} server-specific groups.**",event,2)
    if event.server.nil? && Shardizard==4
      str=extend_message(str,"Due to being the debug version, I cannot show more information.",event)
    elsif event.server.nil? && Shardizard==-1
      str=extend_message(str,"Due to being the smol version, I cannot show more information.",event)
    elsif event.server.nil?
      str=extend_message(str,"Servers you and I share account for #{$groups.reject{|q| q.fake.nil? || q.fake.reject{|q2| bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those.",event)
    else
      str=extend_message(str,"This server accounts for #{$groups.reject{|q| q.fake.nil? || !q.fake.include?(event.server.id)}.length} of those.",event)
    end
    event.respond str
    return nil
  elsif ['code','lines','line','sloc'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3) rescue nil
    b=[[],[],[],[],[]]
    File.open("#{$location}devkit/PriscillaBot.rb").each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      b[3].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[1].push(l) unless l.length<=0
    end
    File.open("#{$location}devkit/rot8er_functs.rb").each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[2].push(l) unless l.length<=0
    end
    File.open("#{$location}devkit/EliseClassFunctions.rb").each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[2].push(l) unless l.length<=0
    end
    event << "**I am #{longFormattedNumber(File.foreach("#{$location}devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} lines of code long.**"
    event << "Of those, #{longFormattedNumber(b[1].length)} are SLOC (non-empty)."
    event << "~~When fully collapsed, I appear to be #{longFormattedNumber(b[3].reject{|q| q.length>0 && (q[0,2]=='  ' || q[0,3]=='end' || q[0,4]=='else')}.length)} lines of code long.~~"
    event << ''
    event << "**I rely on multiple libraries that in total are #{longFormattedNumber(File.foreach("#{$location}devkit/rot8er_functs.rb").inject(0) {|c, line| c+1}+File.foreach("#{$location}devkit/EliseMulti1.rb").inject(0) {|c, line| c+1}+File.foreach("#{$location}devkit/EliseText.rb").inject(0) {|c, line| c+1})} lines of code long.**"
    event << "Of those, #{longFormattedNumber(b[2].length)} are SLOC (non-empty)."
    event << ''
    event << "**There are #{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command('}.length)} commands, invoked with #{longFormattedNumber(all_commands().length)} different phrases.**"
    event << 'This includes:'
    event << "#{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command(' || q.include?('from: 167657750971547648')}.length-b[0].reject{|q| q.gsub('  ','')!="event.respond 'You are not a mod.'" && q.gsub('  ','')!="str='You are not a mod.'"}.length)} global commands, invoked with #{longFormattedNumber(all_commands(false,0).length)} different phrases."
    event << "#{longFormattedNumber(b[0].reject{|q| q.gsub('  ','')!="event.respond 'You are not a mod.'" && q.gsub('  ','')!="str='You are not a mod.'"}.length)} mod-only commands, invoked with #{longFormattedNumber(all_commands(false,1).length)} different phrases."
    event << "#{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command(' || !q.include?('from: 167657750971547648')}.length)} dev-only commands, invoked with #{longFormattedNumber(all_commands(false,2).length)} different phrases."
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
      event << "#{longFormattedNumber(b.reject{|q| q[0,6]!='class '}.map{|q| q.split(' < ')[0]}.uniq.length)} `class` definitions invoked a total of #{longFormattedNumber(b.reject{|q| q[0,6]!='class '}.length)} times."
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
    if Shardizard==4 || Shardizard==-1
      s2="That server uses/would use #{shard_data(0,true)[(f.to_i >> 22) % Shards]} Shards."
    else
      srv=(bot.server(f.to_i) rescue nil)
      if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
        s2="I am not in that server, but it would use #{shard_data(0,true)[(f.to_i >> 22) % Shards]} Shards."
      else
        s2="__**#{srv.name}** (#{srv.id})__\n*Owner:* #{srv.owner.distinct} (#{srv.owner.id})\n*Shard:* #{shard_data(0,true)[(srv.id >> 22) % Shards]}\n*My nickname:* #{bot.user(312451658908958721).on(srv.id).display_name}"
      end
    end
    event.respond s2
    return nil
  end
  f='' if f.nil?
  f2='' if f2.nil?
  unless Shardizard==-1
    bot.servers.values(&:members)
    k=bot.servers.length
    k+=5 if Shardizard==0
    k=1 if Shardizard==4 # Debug shard shares the six emote servers with the main account
    @server_data[0][Shardizard]=k
    @server_data[1][Shardizard]=bot.users.size
    @server_data[0][4]=1
    metadata_save()
  end
  all_units=$units.reject{|q| !q.isPostable?(event)}
  all_units=$units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
  legal_units=$units.reject{|q| !q.fake.nil?}
  all_skills=$skills.reject{|q| q.level=='example' || !q.isPostable?(event)}
  all_skills=$skills.reject{|q| q.level=='example'} if event.server.nil? && event.user.id==167657750971547648
  legal_skills=$skills.reject{|q| q.level=='example' || !q.fake.nil?}
  b=[]
  File.open("#{$location}devkit/PriscillaBot.rb").each_line do |line|
    l=line.gsub(' ','').gsub("\n",'')
    b.push(l) unless l.length<=0
  end
  extln=1
  extln=2 if safe_to_spam?(event)
  extln=2 if f.downcase=="all"
  bot.servers.values(&:members)
  str="**I am in #{longFormattedNumber(@server_data[0].inject(0){|sum,x| sum + x })} *servers*.**"
  if Shardizard==-1
    str="#{str}\nThis Smol version is in 3 servers."
  else
    str="#{str}\nThis shard is in #{longFormattedNumber(@server_data[0][Shardizard])} server#{"s" unless @server_data[0][Shardizard]==1}."
  end
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{legal_units.length}#{" (#{all_units.length})" unless legal_units.length==all_units.length} *units*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    l=legal_units.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=all_units.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} summonable units"
    l=legal_units.reject{|q| !q.availability[0].include?('g')}
    a=all_units.reject{|q| !q.availability[0].include?('g')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Grand Hero Battle reward units"
    l=legal_units.reject{|q| !q.availability[0].include?('t')}
    a=all_units.reject{|q| !q.availability[0].include?('t')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Tempest Trials reward units"
    l=legal_units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?}
    a=all_units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} seasonal units"
    l=legal_units.reject{|q| q.legendary.nil?}
    a=all_units.reject{|q| q.legendary.nil?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} legendary/mythic units"
    l=legal_units.reject{|q| q.duo.nil?}
    a=all_units.reject{|q| q.duo.nil?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} duo/harmonic units"
    l=legal_units.reject{|q| !q.availability[0].include?('-')}
    a=all_units.reject{|q| !q.availability[0].include?('-')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} unobtainable units"
  end
  str=extend_message(str,str2,event,2)
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{legal_skills.length}#{" (#{all_skills.length})" unless legal_skills.length==all_skills.length} *skills*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    l=legal_skills.reject{|q| !q.type.include?('Weapon')}
    a=all_skills.reject{|q| !q.type.include?('Weapon')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Weapons"
    l=legal_skills.reject{|q| !q.type.include?('Assist')}
    a=all_skills.reject{|q| !q.type.include?('Assist')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Assists"
    l=legal_skills.reject{|q| !q.type.include?('Special')}
    a=all_skills.reject{|q| !q.type.include?('Special')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Specials"
    l=legal_skills.reject{|q| !q.isPassive?}
    a=all_skills.reject{|q| !q.isPassive?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Passives"
    l=legal_skills.reject{|q| !has_any?(q.type,['Duo','Harmonic'])}
    a=all_skills.reject{|q| !has_any?(q.type,['Duo','Harmonic'])}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Duo/Harmonic Skills"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{longFormattedNumber($structures.map{|q| q.name}.uniq.length)} *structures* with #{longFormattedNumber($structures.length)} levels#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    m=$structures.reject{|q| !q.type.include?('Offensive')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} Offensive structures#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Defensive')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} Defensive structures#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Trap')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} Traps#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Resources')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} Resource structures#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Ornament')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} Ornaments#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q.name}.uniq.length==m.length}"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{longFormattedNumber($itemus.length)} *items*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    m=$itemus.reject{|q| q.type !='Main'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} main items"
    m=$itemus.reject{|q| q.type !='Implied'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} implied items"
    m=$itemus.reject{|q| q.type !='Blessing'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} blessings"
    m=$itemus.reject{|q| q.type !='Growth'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} unit growth items"
    m=$itemus.reject{|q| q.type !='Assault'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} Arena Assault/Resonant Blades items"
    m=$itemus.reject{|q| q.type !='Event'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} event items"
    str2="#{str2}\n~~3 thrones which are counted as structures in my data even though FEH counts them as both structures and items~~"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{longFormattedNumber($accessories.length)} *accessories*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    m=$accessories.reject{|q| q.type !='Hair'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} pins and other hair accessories"
    m=$accessories.reject{|q| q.type !='Hat'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} hats and other top-of-head accessories"
    m=$accessories.reject{|q| q.type !='Mask'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} masks and other face accessories"
    m=$accessories.reject{|q| q.type !='Tiara'}
    str2="#{str2}\n__#{longFormattedNumber(m.length)} tiaras and other back-of-head accessories__"
    m=$accessories.reject{|q| !q.description.include?('Proof of victory over')}
    str2="#{str2}\n#{longFormattedNumber(m.length)} Golden Accessories"
  end
  str=extend_message(str,str2,event,extln)
  glbl=$aliases.reject{|q| !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[3].nil?}
  str2="**There are #{longFormattedNumber(glbl.length+2)} global and #{longFormattedNumber(srv_spec.length)} server-specific *aliases*.**"
  glbl=$aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Unit' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]unit aliases."
  str2="#{str2}\nThere are #{longFormattedNumber($aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}.length)} [global] multi-unit aliases."
  glbl=$aliases.reject{|q| q[0]!='Skill' || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Skill' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]skill aliases.\nThere are 3 global multi-skill aliases."
  glbl=$aliases.reject{|q| q[0]!='Structure' || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Structure' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]structure aliases."
  glbl=$aliases.reject{|q| q[0]!='Item' || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Item' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]item aliases."
  glbl=$aliases.reject{|q| q[0]!='Accessory' || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Accessory' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]accessory aliases."
  str=extend_message(str,str2,event,2)
  str=extend_message(str,"**There are #{longFormattedNumber($groups.reject{|q| !q.fake.nil?}.length-1)} global and #{longFormattedNumber($groups.reject{|q| q.fake.nil?}.length)} server-specific *groups*.**",event,2)
  str2="**I am #{longFormattedNumber(File.foreach("#{$location}devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} lines of *code* long.**"
  str2="#{str2}\nOf those, #{longFormattedNumber(b.length)} are SLOC (non-empty)."
  str=extend_message(str,str2,event,2)
  event.respond str
end
