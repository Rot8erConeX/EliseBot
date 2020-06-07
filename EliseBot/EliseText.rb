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
    lookout=lookout_load('Games')
    lookout=lookout.reject{|q| q[0].length>4 && q[0][0,4]=='FE14'}
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
  elsif ['oregano','whoisoregano'].include?(command.downcase)
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
    lookout=lookout_load('SkillSubsets')
    w=lookout.reject{|q| q[2]!='Banner' || ['Current','Upcoming'].include?(q[0])}.map{|q| q[0]}.sort
    create_embed(event,'Banner types','',0x40C0F0,nil,nil,triple_finish(w)) if safe_to_spam?(event) || w.length<=50
  elsif ['effhp','eff_hp'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the effective HP data for the unit `name`.',0xD49F61)
  elsif ['pair','pairup','pair_up'].include?(command.downcase)
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
    unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
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
  elsif ['deletemultialias','deletedualalias','deletemultiunitalias','deletedualunitalias','deletemulti','removemultialias','removedualalias','removemultiunitalias','removedualunitalias','removemulti'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Removes the multi-unit alias with the name `name`\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
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
    u=random_dev_unit_with_nature(event,false)
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
      lookout=lookout_load('Games')
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
        lookout=lookout_load('SkillSubsets')
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
      lookout=lookout_load('SkillSubsets')
      w=lookout.reject{|q| q[2]!='Banner' || ['Current','Upcoming'].include?(q[0])}.map{|q| q[0]}.sort
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
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to Resplendently Ascend the donor unit with the name `unit`.\nIf the devunit cannot do so because either lack of ability, or having already done so, I inform you of this.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    else
      create_embed(event,"**#{command.downcase}** __subcommand__ __unit__ __\*effects__","Allows me to create and edit the donor units.\n\nAvailable subcommands include:\n`FEH!#{command.downcase} create` - creates a new donor unit\n`FEH!#{command.downcase} promote` - promotes an existing donor unit (*also `rarity` and `feathers`*)\n`FEH!#{command.downcase} merge` - increases a donor unit's merge count (*also `combine`*)\n`FEH!#{command.downcase} nature` - changes a donor unit's nature (*also `ivs`*)\n`FEH!#{command.downcase} support` - causes me to change support ranks of donor units (*also `marry`*)\n`FEH!#{command.downcase} unsupport` - causes me to remove the support ranks of donor units (*also `divorce`*)\n\n`FEH!#{command.downcase} equip` - equip skill (*also `skill`*)\n`FEH!#{command.downcase} seal` - equip seal\n`FEH!#{command.downcase} refine` - refine weapon\n`FEH!#{command.downcase} flower` - increases a donor unit's dragonflower count\n`FEH!#{command.downcase} pairup` - pairs one donor unit up as another's cohort\n`FEH!#{command.downcase} resplendent` - Resplendently Ascends a donor unit\n\n`FEH!#{command.downcase} send_home` - removes the unit from the donor units attached to the invoker (*also `fodder` or `remove` or `delete`*)\n\n**This command is only able to be used by certain people**.",0x9E682C)
    end
  elsif ['devedit','dev_edit'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['create'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*stats__","Allows me to create a new devunit with the character `unit` and stats described in `stats`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['resplendant','resplendent','ascension','ascend','resplend'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to Resplendently Ascend the devunit with the name `unit`.\nIf the devunit cannot do so because either lack of ability, or having already done so, I inform you of this.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
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
    else
      create_embed(event,"**#{command.downcase}** __subcommand__ __unit__ __\*effects__","Allows me to create and edit the devunits.\n\nAvailable subcommands include:\n`FEH!#{command.downcase} create` - creates a new devunit\n`FEH!#{command.downcase} promote` - promotes an existing devunit (*also `rarity` and `feathers`*)\n`FEH!#{command.downcase} merge` - increases a devunit's merge count (*also `combine`*)\n`FEH!#{command.downcase} nature` - changes a devunit's nature (*also `ivs`*)\n`FEH!#{command.downcase} teach` - teaches a new skill to a devunit (*also `learn`*)\n`FEH!#{command.downcase} flower` - increases a dev unit's dragonflower count\n`FEH!#{command.downcase} pairup` - pairs one devunit up as another's cohort\n`FEH!#{command.downcase} resplendent` - Resplendently Ascends a devunit\n\n`FEH!#{command.downcase} new_waifu` - adds a dev waifu (*also `add_waifu`*)\n`FEH!#{command.downcase} new_somebody` - adds a dev \"somebody\" (*also `add_somebody`*)\n`FEH!#{command.downcase} new_nobody` - adds a dev \"nobody\" (*also `add_nobody`*)\n\n`FEH!#{command.downcase} send_home` - removes the unit from either the devunits or the \"nobodies\" list (*also `fodder` or `remove` or `delete`*)\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    end
  elsif ['sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list in order based on their SP cost.\n\n#{disp_more_info(event,3)}",0xD49F61)
    if safe_to_spam?(event)
      lookout=lookout_load('SkillSubsets')
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
        lookout=lookout_load('SkillSubsets')
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
    str="#{str}\n\n__**Server-specific command**__\n`summon` \\*colors - to simulate summoning on a randomly-chosen banner" if !event.server.nil? && @summon_servers.include?(event.server.id)
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
    str="#{str}\n`deletemulti` __name__ - Deletes a multi-unit alias (*also `removemulti`*)"
    create_embed([event,x],"__**Bot Developer Commands**__",str,0x008b8b) if event.user.id==167657750971547648 && (x==1 || safe_to_spam?(event))
    event.respond "If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nGlobal Command Prefixes: `FEH!` `FEH?` `F?` `E?` `H?`#{"\nServer Command Prefix: `#{@prefixes[event.server.id]}`" if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n\nWhen looking up a character or skill, you also have the option of @ mentioning me in a message that includes that character/skill's name" unless x==1
    event.user.pm("If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nGlobal Command Prefixes: `FEH!` `FEH?` `F?` `E?` `H?`#{"\nServer Command Prefix: `#{@prefixes[event.server.id]}`" if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n\nWhen looking up a character or skill, you also have the option of @ mentioning me in a message that includes that character/skill's name") if x==1
    event.respond "A PM has been sent to you.\nIf you would like to show the help list in this channel, please use the command `FEH!help here`." if x==1
  end
end

def disp_more_info(event, mode=0) # used by the `help` command to display info that repeats in multiple help descriptions.
  if mode<1
    str="You can modify the unit by including any of the following in your message:"
    str="#{str}\n\n**Rarity**"
    str="#{str}\nProper format: #{rand(@max_rarity_merge[0])+1}\\*"
    str="#{str}\n~~Alternatively, the first number not given proper context will be set as the rarity value unless the rarity value is already defined~~"
    str="#{str}\nDefault: 5\\* unit"
    str="#{str}\n\n**Merges**"
    str="#{str}\nProper format: +#{rand(@max_rarity_merge[1])+1}"
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
    u=random_dev_unit_with_nature(event)
    return "**IMPORRTANT NOTE**\nUnlike my other commands, this one is heavily context based.  Please format all allies like the example below:\n`#{u[1]}* #{u[0]} +#{u[2]} +#{u[3]} -#{u[4]}`\nAny field with the exception of unit name can be ignored, but unlike my other commands the order is important."
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
    create_embed(event,"__**Non-healers**__","",xcolor,"Most non-healer units have at least one Scenario X passive and at least one Scenario Y passive",nil,[["__<:Skill_Weapon:444078171114045450> **Weapons**__","Tier 1 (*Iron, basic magic*) - Default at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*Steel, El- magic, Fire Breath+*) - Available at 2<:Icon_Rarity_2:448266417872044032>, Default at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 (*Silver, super magic*) - Available at 3<:Icon_Rarity_3:448266417934958592> ~~Kana(M) has his unavailable until 4\\*~~, default at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 (*+ weapons other than Fire Breath+, Prf weapons*) - default at 5<:Icon_Rarity_5:448266417553539104>\nRetro-Prfs (*Felicia's Plate*) - Available at 5<:Icon_Rarity_5:448266417553539104>, promotes from nothing",1],["__<:Skill_Assist:444078171025965066> **Assists**__","Tier 1 (*Rallies, Dance/Sing/Play, etc.*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 4<:Icon_Rarity_4:448266418459377684> ~~Sharena has hers default at 2\\*~~\nTier 2 (*Double Rallies*) - Available at 4<:Icon_Rarity_4:448266418459377684>\nPrf Assists (*Sacrifice*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Skill_Special:444078170665254929> **Specials**__","Miracle - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 1 (*Daylight, New Moon, etc.*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 4<:Icon_Rarity_4:448266418459377684> ~~Alfonse and Anna have theirs default at 2\\*~~\nTier 2 (*Sol, Luna, etc.*) - Available at 4<:Icon_Rarity_4:448266418459377684> ~~Jaffar and Saber have theirs also default at 5\\*~~\nTier 3 (*Galeforce, Aether, Prf Specials*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1]],2)
    create_embed(event,"__**Healers**__","",0x64757D,"Most healers have a Scenario Y passive",nil,[["__#{"<:Colorless_Staff:443692132323295243>" unless alter_classes(event,'Colored Healers')}#{"<:Gold_Staff:443172811628871720>" if alter_classes(event,'Colored Healers')} **Damaging Staves**__","Tier 1 (*only Assault*) - Available at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*non-plus staves*) - Available at 3<:Icon_Rarity_3:448266417934958592> ~~Lyn(Bride) has hers default when summoned~~\nTier 3 (*+ staves, Prf weapons*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Assist_Staff:454451496831025162> **Healing Staves**__","Tier 1 (*Heal*) - Default at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*Mend, Reconcile*) - Available at 2<:Icon_Rarity_2:448266417872044032>, default at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 (*all other non-plus staves*) - Available at 4<:Icon_Rarity_4:448266418459377684>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 4 (*+ staves, Prf staves if healers got them*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Special_Healer:454451451805040640> **Healer Specials**__","Miracle - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 1 (*Imbue*) - Available at 2<:Icon_Rarity_2:448266417872044032>, default at 3<:Icon_Rarity_3:448266417934958592>\nTier 2 (*single-stat Balms, Heavenly Light*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 3 (*double-stat Balms*) - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 (*+ Balms*) - Available at 5<:Icon_Rarity_5:448266417553539104>\nPrf Specials (*no examples yet, but they may come*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1]],2)
    create_embed(event,"__**Passives**__","",0x245265,nil,nil,[["__<:Passive_X:444078170900135936> **Scenario X**__","Tier 1 - Available at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 - Available at 2<:Icon_Rarity_2:448266417872044032> or 3<:Icon_Rarity_3:448266417934958592>\nTier 3 - Available at 4<:Icon_Rarity_4:448266418459377684>"],["__<:Passive_Y:444078171113914368> **Scenario Y**__","Tier 1 - Available at 3<:Icon_Rarity_3:448266417934958592>\nTier 2 - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 3 - Available at 5<:Icon_Rarity_5:448266417553539104>"],["__<:Passive_Prf:444078170887553024> **Prf Passives**__","Available at 5<:Icon_Rarity_5:448266417553539104>"],["__<:Passive_Z:481922026903437312> **Scenario Z**__","Tier 1 - Available at 2<:Icon_Rarity_2:448266417872044032>\nTier 2 - Available at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 - Available at 5<:Icon_Rarity_5:448266417553539104>"]],2)
  else
    str="By observing the skill lists of the Daily Hero Battle units - the only units we have available at 1\\* - I have learned that there is a set progression for which characters learn skills.  Only six units directly contradict this observation - and three of those units are the Askrians, who were likely given their Assists and Tier 1 Specials (depending on the character) at 2\\* in order to make them useable in the early story maps when the player has limited orbs and therefore limited unit choices.  One is Lyn(Bride), who as the only seasonal healer so far, may be the start of a new pattern.  The other two are Jaffar and Saber, who - for unknown reasons - have their respective Tier 2 Specials available right out of the box as 5\\*s."
    str="#{str}\n\nThe information as it is is not useless.  In fact, as seen quite recently as of the time of this writing, IntSys is willing to demote some units out of the 4-5\\* pool into the 3-4\\* one. This information allows us to predict which skills the new 3\\* versions of these characters will have."
    str="#{str}\n\nAs for units unlikely to demote, Paralogue maps will have lower-rarity versions of units with their base kits.  Training Tower and Tempest Trials attempt to build units according to recorded trends in Arena, but will use default base kits at lower difficulties.  Obviously you can't fodder a 4* Siegbert for Death Blow 3, but you can still encounter him in Tempest."
    create_embed(event,"**Supposed Bug: X character, despite not being available at #{r}, has skills listed for #{r.gsub('Y','that')} in the `skill` command.**\n\nA word from my developer",str,xcolor)
    event.respond "To see the progression I have discovered, please use the command `FEH!skillrarity progression`."
  end
end

def book_color(n,mode=0)
  if mode==1
    return [31,98,114] if n==1
    return [166,59,89] if n==2
    return [120,70,152] if n==3
  end
  return 0x1F6272 if n==1
  return 0xA63B59 if n==2
  return 0x784698 if n==3
end

def sort_legendaries(event,bot,mode=0)
  data_load()
  nicknames_load()
  g=get_markers(event)
  k=@units.reject{|q| !has_any?(g, q[13][0]) || q[2].nil? || [' ','Duo','Idol'].include?(q[2][0]) || q[2].length<3 || q[2][2].to_i<=0}.uniq
  c=[]
  for i in 0...k.length
    c.push([249,130,129]) if k[i][2][0]=='Fire'
    c.push([145,244,255]) if k[i][2][0]=='Water'
    c.push([152,255,153]) if k[i][2][0]=='Wind'
    c.push([255,175,126]) if k[i][2][0]=='Earth'
    c.push([253,243,157]) if k[i][2][0]=='Light'
    c.push([190,131,254]) if k[i][2][0]=='Dark'
    c.push([245,164,218]) if k[i][2][0]=='Astra'
    c.push([225,218,207]) if k[i][2][0]=='Anima'
    k[i][2][2]=k[i][2][2].split('/').map{|q| q.to_i}.reverse
    k[i][1][1]=1 if k[i][1][0]=='Red'
    k[i][1][1]=2 if k[i][1][0]=='Blue'
    k[i][1][1]=3 if k[i][1][0]=='Green'
    k[i][1][1]=4 if k[i][1][0]=='Colorless'
    k[i][1][1]=5 if k[i][1][1].is_a?(String)
  end
  k=k.sort{|a,b| ((a[2][2]<=>b[2][2]) == 0 ? ((a[1][1]<=>b[1][1]) == 0 ? b[0]<=>a[0] : a[1][1]<=>b[1][1]) : a[2][2]<=>b[2][2])}
  for i in 0...k.length
    m=k[i][2][2].reverse
    k[i][2][3]=k[i][2][2].map{|q| q}
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
  k2=[[k[0][2][2],[[k[0][1][1],"#{k[0][1][2]} - #{k[0][0]}"]],k[0][2][3]]]
  for i in 1...k.length
    if k[i][2][2]==k2[m][0]
      k2[m][1].push([k[i][1][1],"#{k[i][1][2]} - #{k[i][0]}"])
    else
      m+=1
      k2.push([k[i][2][2],[[k[i][1][1],"#{k[i][1][2]} - #{k[i][0]}"]],k[i][2][3]])
    end
  end
  for i in 0...k2.length
    k2[i][1].push([1,'<:Orb_Red:455053002256941056> - *unknown*']) unless k2[i][1].reject{|q| q[0]!=1}.length>0
    k2[i][1].push([2,'<:Orb_Blue:455053001971859477> - *unknown*']) unless k2[i][1].reject{|q| q[0]!=2}.length>0
    k2[i][1].push([3,'<:Orb_Green:455053002311467048> - *unknown*']) unless k2[i][1].reject{|q| q[0]!=3}.length>0
    k2[i][1].push([4,'<:Orb_Colorless:455053002152083457> - *unknown*']) unless k2[i][1].reject{|q| q[0]!=4}.length>0
    k2[i][1]=k2[i][1].sort{|a,b| (a[0]<=>b[0])==0 ? (a[1]<=>b[1]) : (a[0]<=>b[0])}.map{|q| q[1]}.join("\n")
  end
  bonus_load()
  bx=@bonus_units.reject{|q| q[1]!='Arena'}
  bx2=@bonus_units.reject{|q| q[1]!='Aether'}
  for i in 0...k2.length
    unless k2[i][2].nil?
      t2=Time.new(k2[i][2][0],k2[i][2][1],k2[i][2][2])
      t2+=(9-t2.wday)*24*60*60
      tm="#{t2.year}#{'0' if t2.month<10}#{t2.month}#{'0' if t2.day<10}#{t2.day}".to_i
      lemoji1='<:Legendary_Effect_Unknown:443337603945857024>'
      b2=[]
      if k2[i][0].include?('January') || k2[i][0].include?('March') || k2[i][0].include?('May') || k2[i][0].include?('July') || k2[i][0].include?('September') || k2[i][0].include?('November')
        t2+=(8-t2.wday)*24*60*60
        tm="#{t2.year}#{'0' if t2.month<10}#{t2.month}#{'0' if t2.day<10}#{t2.day}".to_i
        lemoji1='<:Mythic_Effect_Unknown:523328368079273984>'
        b2=[]
      else
        b2=bx.reject{|q| q[2].nil? || q[2][0].split(', ')[0].split('/').reverse.join('').to_i<=tm}
      end
      moji=[]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{b2[0][3][0]}"} if b2.length>0
      lemoji1=moji[0].mention unless moji.length<=0
      if count_in(k2[i][1].split("\n").map{|q| q.split('>')[1]}," - *unknown*")==1
        k2[i][1]=k2[i][1].gsub(' - *unknown*',"#{lemoji1} - *unknown*")
      else
        k2[i][0]="#{k2[i][0]} #{lemoji1}"
      end
      k2[i][2]=nil
      k2[i].compact!
    end
  end
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
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
  b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i<=tm || q[5].nil? || !q[5].split(', ').include?('Legendary') || q[2][0]=='-' || q[2].length<5}
  if b2.length>0
    m=[]
    for i in 0...b2.length
      for j in 0...b2[i][2].length
        m.push(b2[i][2][j])
      end
    end
    m.uniq!
    data_load()
    k=@units.reject{|q| !has_any?(g, q[13][0]) || q[2].nil? || [' ','Duo','Idol'].include?(q[2][0]) || q[2].length<2}.uniq
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
    k2[0][0]='Upcoming banner' if k==k2[0][1]
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
    k=@units.reject{|q| !has_any?(g, q[13][0]) || q[2].nil? || [' ','Duo','Idol'].include?(q[2][0]) || q[2].length<2}.uniq
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
      msg="__#{k2[0][0]}__\n#{k2[0][1]}"
      for i in 1...k2.length
        msg=extend_message(msg,"__#{k2[i][0]}__\n#{k2[i][1]}",event,2)
      end
      event.respond msg
    elsif k2.length>5 || k2.map{|q| "__#{q[0]}__\n#{q[1]}"}.join("\n\n").length>1500
      k2=k2[0,6] if k2.length>6 && !safe_to_spam?(event)
      m=k2.length/3
      m+=1 unless k2.length%3==0
      for i in 0...m
        x=''
        x="__**Legendary and Mythic Heroes' Appearances**__" if i==0
        create_embed(event,x,'',avg_color(c),nil,nil,k2[3*i,[3,k2.length-3*i].min],2)
      end
    else
      create_embed(event,"__**Legendary and Mythic Heroes' Appearances**__",'',avg_color(c),nil,nil,k2,2)
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
      k=@units.reject{|q| !q[13][0].nil? || q[2].nil? || q[2][0]!=' ' || !q[9][0].include?('5s') || m.include?(q[0])}.uniq
      m2=[['<:Orb_Red:455053002256941056>Red',[]],['<:Orb_Blue:455053001971859477>Blue',[]],['<:Orb_Green:455053002311467048>Green',[]],['<:Orb_Colorless:455053002152083457>Colorless',[]],['<:Orb_Pink:549339019318788175>Gold',[]]]
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
        msg="__**Seasonal units that have not yet been on a Legendary or Mythic Banner**__"
        tolongs=[]
        for i in 0...m2.length
          if m2[i][1].length>1900
            tolongs.push(m2[i][0].split('>')[1])
          else
            msg=extend_message(msg,"*#{m2[i][0]}*: #{m2[i][1]}",event)
          end
        end
        msg=extend_message(msg,"There are too many seasonal #{list_lift(tolongs,'and')} heroes to display.",event) if tolongs.length>0
        event.respond msg
      elsif m2.map{|q| "*#{q[0]}*: #{q[1]}"}.join("\n\n").length>1700
        tolongs=[]
        if m2[0][1].length>1900
          event.respond "__**Seasonal units that have not yet been on a Legendary or Mythic Banner**__"
          tolongs.push('Red')
        else
          create_embed(event,"__**Seasonal units that have not yet been on a Legendary or Mythic Banner**__",'',0xE22141,nil,nil,triple_finish(m2[0][1].split("\n")),2)
        end
        if m2[1][1].length>1900
          tolongs.push('Blue')
        else
          create_embed(event,'','',0x2764DE,nil,nil,triple_finish(m2[1][1].split("\n")),2)
        end
        if m2[2][1].length>1900
          tolongs.push('Green')
        else
          create_embed(event,'','',0x09AA24,nil,nil,triple_finish(m2[2][1].split("\n")),2)
        end
        if m2[3][1].length>1900
          tolongs.push('Colorless')
        else
          create_embed(event,'','',0x64757D,nil,nil,triple_finish(m2[3][1].split("\n")),2)
        end
        event.respond "There are too many seasonal #{list_lift(tolongs,'and')} heroes to display." if tolongs.length>0
      else
        create_embed(event,"__**Seasonal units that have not yet been on a Legendary or Mythic Banner**__",'',0xAA937A,nil,nil,m2,2)
      end
      data_load()
      k=@units.reject{|q| !q[13][0].nil? || q[2].nil? || q[2][0]!=' ' || !q[9][0].include?('p') || q[9][0].include?('4p') || q[9][0].include?('3p') || q[9][0].include?('2p') || q[9][0].include?('1p') || !q[9][0].include?('TD') || m.include?(q[0])}.uniq
      m2=[['<:Orb_Red:455053002256941056>Red',[]],['<:Orb_Blue:455053001971859477>Blue',[]],['<:Orb_Green:455053002311467048>Green',[]],['<:Orb_Colorless:455053002152083457>Colorless',[]],['<:Orb_Gold:549338084102111250>Gold',[]]]
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
        msg="__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units from Book 1 that have not yet been on a Legendary or Mythic Banner**__"
        tolongs=[]
        for i in 0...m2.length
          if m2[i][1].length>1900
            tolongs.push(m2[i][0].split('>')[1])
          else
            msg=extend_message(msg,"*#{m2[i][0]}*: #{m2[i][1]}",event)
          end
        end
        msg=extend_message(msg,"There are too many 5<:Icon_Rarity_5:448266417553539104>-Exclusive #{list_lift(tolongs,'and')} heroes from Book 1 to display.",event) if tolongs.length>0
        event.respond msg
      elsif m2.map{|q| "*#{q[0]}*: #{q[1]}"}.join("\n\n").length>1700
        tolongs=[]
        if m2[0][1].length>1900
          event.respond "__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units from Book 1 that have not yet been on a Legendary or Mythic Banner**__"
          tolongs.push('Red')
        else
          create_embed(event,"__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units from Book 1 that have not yet been on a Legendary or Mythic Banner**__",'',0xE22141,nil,nil,triple_finish(m2[0][1].split("\n")),2)
        end
        if m2[1][1].length>1900
          tolongs.push('Blue')
        else
          create_embed(event,'','',0x2764DE,nil,nil,triple_finish(m2[1][1].split("\n")),2)
        end
        if m2[2][1].length>1900
          tolongs.push('Green')
        else
          create_embed(event,'','',0x09AA24,nil,nil,triple_finish(m2[2][1].split("\n")),2)
        end
        if m2[3][1].length>1900
          tolongs.push('Colorless')
        else
          create_embed(event,'','',0x64757D,nil,nil,triple_finish(m2[3][1].split("\n")),2)
        end
        event.respond "There are too many 5<:Icon_Rarity_5:448266417553539104>-Exclusive #{list_lift(tolongs,'and')} heroes from Book 1 to display." if tolongs.length>0
      else
        create_embed(event,"__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units from Book 1 that have not yet been on a Legendary Banner**__",'',avg_color([book_color(1,1)]),nil,nil,m2,2)
      end
      data_load()
      k=@units.reject{|q| !q[13][0].nil? || q[2].nil? || q[2][0]!=' ' || !q[9][0].include?('p') || q[9][0].include?('4p') || q[9][0].include?('3p') || q[9][0].include?('2p') || q[9][0].include?('1p') || q[9][0].include?('TD') || m.include?(q[0])}.uniq
      m2=[['<:Orb_Red:455053002256941056>Red',[]],['<:Orb_Blue:455053001971859477>Blue',[]],['<:Orb_Green:455053002311467048>Green',[]],['<:Orb_Colorless:455053002152083457>Colorless',[]],['<:Orb_Gold:549338084102111250>Gold',[]]]
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
        msg="__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units that have not yet been on a Legendary or Mythic Banner**__"
        tolongs=[]
        for i in 0...m2.length
          if m2[i][1].length>1900
            tolongs.push(m2[i][0].split('>')[1])
          else
            msg=extend_message(msg,"*#{m2[i][0]}*: #{m2[i][1]}",event)
          end
        end
        msg=extend_message(msg,"There are too many 5<:Icon_Rarity_5:448266417553539104>-Exclusive #{list_lift(tolongs,'and')} heroes to display.",event) if tolongs.length>0
        event.respond msg
      elsif m2.map{|q| "*#{q[0]}*: #{q[1]}"}.join("\n\n").length>1700
        tolongs=[]
        if m2[0][1].length>1900
          event.respond "__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units that have not yet been on a Legendary or Mythic Banner**__"
          tolongs.push('Red')
        else
          create_embed(event,"__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units that have not yet been on a Legendary or Mythic Banner**__",'',0xE22141,nil,nil,triple_finish(m2[0][1].split("\n")),2)
        end
        if m2[1][1].length>1900
          tolongs.push('Blue')
        else
          create_embed(event,'','',0x2764DE,nil,nil,triple_finish(m2[1][1].split("\n")),2)
        end
        if m2[2][1].length>1900
          tolongs.push('Green')
        else
          create_embed(event,'','',0x09AA24,nil,nil,triple_finish(m2[2][1].split("\n")),2)
        end
        if m2[3][1].length>1900
          tolongs.push('Colorless')
        else
          create_embed(event,'','',0x64757D,nil,nil,triple_finish(m2[3][1].split("\n")),2)
        end
        event.respond "There are too many 5<:Icon_Rarity_5:448266417553539104>-Exclusive #{list_lift(tolongs,'and')} heroes to display." if tolongs.length>0
      else
        create_embed(event,"__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units that have not yet been on a Legendary Banner**__",'',avg_color([book_color(2,1),book_color(3,1)]),nil,nil,m2,2)
      end
    end
  end
  return nil
end

def disp_legendary_mythical(event,bot,args=[],dispmode='',forcesplit=false)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  args=args.map{|q| q.downcase}
  data_load()
  g=get_markers(event)
  l=@units.reject{|q| [' ','Duo','Idol'].include?(q[2][0]) || !has_any?(g, q[13][0])}
  l=@units.reject{|q| [' ','Duo','Idol','Light','Dark','Astra','Anima'].include?(q[2][0]) || !has_any?(g, q[13][0])} if dispmode=='Legendary' && (!safe_to_spam?(event) || forcesplit)
  l=@units.reject{|q| [' ','Duo','Idol','Fire','Water','Wind','Earth'].include?(q[2][0]) || !has_any?(g, q[13][0])} if dispmode=='Mythic' && (!safe_to_spam?(event) || forcesplit)
  l.sort!{|a,b| a[0]<=>b[0]}
  c=[]
  for i in 0...l.length
    c.push([249,130,129]) if l[i][2][0]=='Fire'
    c.push([145,244,255]) if l[i][2][0]=='Water'
    c.push([152,255,153]) if l[i][2][0]=='Wind'
    c.push([255,175,126]) if l[i][2][0]=='Earth'
    c.push([253,243,157]) if l[i][2][0]=='Light'
    c.push([190,131,254]) if l[i][2][0]=='Dark'
    c.push([245,164,218]) if l[i][2][0]=='Astra'
    c.push([225,218,207]) if l[i][2][0]=='Anima'
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
    l2=split_list(event,l,['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima'],-5)
  elsif pri=='Stat'
    l2=split_list(event,l,['Attack','Speed','Defense','Resistance','Duel'],-6)
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
      element=x2 if ['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima'].include?(x2)
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      x2="#{moji[0].mention} #{x2}" if moji.length>0
    elsif pri=='Stat'
      x2=p1[i][0][2][1]
      element='Spectrum'
      element=x2 if ['Attack','Speed','Defense','Resistance','Duel'].include?(x2)
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{element}"}
      x2="#{moji[0].mention} #{x2}#{' + Pair-Up' if x2=='Duel'}" if moji.length>0
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
      l2=split_list(event,p1[i],['Attack','Speed','Defense','Resistance','Duel'],-6)
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
        element=x3 if ['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima'].include?(x3)
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
        x3="#{moji[0].mention} #{x3}" if moji.length>0
      elsif sec=='Stat'
        x3=p2[j][0][2][1]
        element='Spectrum'
        element=x3 if ['Attack','Speed','Defense','Resistance','Duel'].include?(x3)
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{element}"}
        x3="#{moji[0].mention} #{x3}#{' + Pair-Up' if x3=='Duel'}" if moji.length>0
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
      p2[j]="__*#{x3}*__\n#{p2[j].map{|q| "#{'~~' unless q[13][0].nil?}#{q[0]}#{" - *#{weapon_clss(q[1],event,1) if tri=='Weapon'}#{q[1][0] if tri=='Color'}#{q[3] if tri=='Movement'}*" unless tri==''}#{'~~' unless q[13][0].nil?}"}.join("\n")}" unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || p2[j].length<=1
      p2[j]="*#{x3}*: #{p2[j].map{|q| "#{'~~' unless q[13][0].nil?}#{q[0]}#{" - *#{weapon_clss(q[1],event,1) if tri=='Weapon'}#{q[1][0] if tri=='Color'}#{q[3] if tri=='Movement'}*" unless tri==''}#{'~~' unless q[13][0].nil?}"}.join(", ")}" if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || p2[j].length<=1
    end
    p1[i]=[x2,p2.join("\n\n")] unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || !p2.join('').include?("\n")
    p1[i]=[x2,p2.join("\n")] if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || !p2.join('').include?("\n")
  end
  if p1.map{|q| "#{q[0]}\n#{q[1]}"}.join("\n\n").length>1900 && !forcesplit
    disp_legendary_mythical(event,bot,args,dispmode,true)
    if dispmode=='Legendary'
      disp_legendary_mythical(event,bot,args,'Mythic',true)
    elsif dispmode=='Mythic'
      disp_legendary_mythical(event,bot,args,'Legendary',true)
    end
    return nil
  end
  dispmode='Legendary/Mythic' if p1.length>4
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || p1.map{|q| "#{q[0]}\n#{q[1]}"}.join("\n\n").length>1900
    str="__**All #{dispmode} Heroes**__"
    for i in 0...p1.length
      str=extend_message(str,"__*#{p1[i][0]}*__\n#{p1[i][1]}",event,2)
    end
    event.respond str
  else
    create_embed(event,"__**All #{dispmode} Heroes**__",'',avg_color(c),nil,nil,p1)
  end
end

def disp_all_refines(event,bot)
  event.channel.send_temporary_message('Calculating data, please wait...',1)
  data_load()
  stones=[]
  dew=[]
  g=get_markers(event)
  skkz=@skills.map{|q| q}.reject{|q| ['Falchion','Missiletainn','Chill Breidablik','Breidablik','Whelp (All)','Yearling (All)','Adult (All)'].include?(q[1]) || q[6]!='Weapon' || !has_any?(g, q[15])}
  if event.message.text.downcase.include?('effect')
    for i in 0...skkz.length
      eff=false
      unless skkz[i][17].nil? || skkz[i][17].length.zero?
        str=skkz[i][17].split(' ').join(' ')
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
        if skkz[i][8]=='-'
          stones.push("#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]} \u2192 #{find_effect_name(skkz[i],event,1)}#{'~~' unless skkz[i][15].nil?}")
        else
          dew.push("#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]} \u2192 #{find_effect_name(skkz[i],event,1)}#{'~~' unless skkz[i][15].nil?}")
        end
      end
    end
    stones.uniq!
    stones.sort!{|a,b| a.gsub('~~','') <=> b.gsub('~~','')}
    dew.uniq!
    dew.sort!{|a,b| a.gsub('~~','') <=> b.gsub('~~','')}
    if stones.join("\n").length+dew.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      if dew.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg='__**Weapon Refines with Effect Modes: Divine Dew <:Divine_Dew:453618312434417691>**__'
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Colorless_Tome:443692133317345290> Colorless Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...dew.length
          k2="#{skkz[skkz.find_index{|q| q[1]==dew[i].gsub('~~','').split(" \u2192 ")[0]}][7].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Colorless_Tome:443692133317345290> Colorless Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...stones.length
          k2="#{skkz[skkz.find_index{|q| q[1]==stones[i].gsub('~~','').split(" \u2192 ")[0]}][7].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
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
    if !skkz[i][17].nil?
      if skkz[i][8]=='-'
        stones.push("#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]}#{'~~' unless skkz[i][15].nil?}")
      else
        dew.push("#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]}#{'~~' unless skkz[i][15].nil?}")
      end
    end
  end
  dew2=[]
  stones2=[]
  for i in 0...skkz.length
    unless skkz[i].nil?
      if !skkz[i][16].nil?
        s=skkz[i][16].split(', ')
        for j in 0...s.length
          if s[j].include?('!')
            s[j]=s[j].split('!')
            s2=skkz[skkz.find_index{|q| q[1]==s[j][1] && q[2]==s[j][2]}]
            if s2[8]=='-'
              stones2.push("#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]} -> #{s[j][1]} (#{s[j][0]})#{'~~' unless skkz[i][15].nil?}")
            else
              dew2.push("#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]} -> #{s[j][1]} (#{s[j][0]})#{'~~' unless skkz[i][15].nil?}")
            end
          else
            s2=skkz[skkz.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==s[j]}]
            if s2[8]=='-'
              stones2.push("#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]} -> #{s[j]}#{'~~' unless skkz[i][15].nil?}")
            else
              dew2.push("#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]} -> #{s[j]}#{'~~' unless skkz[i][15].nil?}")
            end
          end
        end
      end
    end
  end
  stones=stones.uniq
  stones.sort!{|a,b| a.gsub('~~','') <=> b.gsub('~~','')}
  stones2=stones2.uniq
  stones2.sort!{|a,b| a.gsub('~~','') <=> b.gsub('~~','')}
  dew=dew.uniq
  dew.sort!{|a,b| a.gsub('~~','') <=> b.gsub('~~','')}
  dew2=dew2.uniq
  dew2.sort!{|a,b| a.gsub('~~','') <=> b.gsub('~~','')}
  if stones.join("\n").length+dew.join("\n").length+stones2.join("\n").length+dew2.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    if dew2.join("\n").length+stones2.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      if dew2.join("\n").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        msg='__**Weapon Evolution: Divine Dew <:Divine_Dew:453618312434417691>**__'
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Colorless_Tome:443692133317345290> Colorless Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...dew2.length
          k2="#{skkz[skkz.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==stat_buffs(dew2[i].gsub('~~',''))}][7].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Colorless_Tome:443692133317345290> Colorless Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...stones2.length
          k2="#{skkz[skkz.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==stat_buffs(stones2[i].gsub('~~',''))}][7].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Colorless_Tome:443692133317345290> Colorless Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...dew.length
          k2="#{skkz[skkz.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"==stat_buffs(dew[i].gsub('~~',''))}][7].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
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
        k=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],['<:Colorless_Tome:443692133317345290> Colorless Tomes',[]],['<:Gold_Dragon:443172811641454592> Dragonstones',[]],['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],["#{'<:Gold_Staff:443172811628871720>' if alter_classes(event,'Colored Healers')}#{'<:Colorless_Staff:443692132323295243>' unless alter_classes(event,'Colored Healers')} Staves",[]],['<:Gold_Beast:532854442299752469> Beaststones',[]]]
        for i in 0...stones.length
          k2="#{skkz[skkz.find_index{|q| "#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}".gsub(' ','').downcase==stat_buffs(stones[i].gsub('~~','')).downcase}][7].gsub(' Only','').gsub(' Users','').gsub('Dragons','Dragonstone').gsub('Beasts','Beaststone')}s"
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

def disp_all_prfs(event,bot)
  if !safe_to_spam?(event)
    event.respond "There is a lot of data being displayed.  Please use this command in PM."
    return nil
  end
  event.channel.send_temporary_message('Calculating data, please wait...',1)
  data_load()
  g=get_markers(event)
  skkz=@skills.reject{|q| ['Falchion','Ragnarok+','Missiletainn','Chill Breidablik','Breidablik','Whelp (All)','Yearling (All)','Adult (All)'].include?(q[1]) || q[6]!='Weapon' || q[8]=='-' || !has_any?(g, q[15])}
  untz=@units.reject{|q| !has_any?(g, q[13][0])}
  for i in 0...skkz.length
    skkz[i][8]=skkz[i][8].split(', ').reject{|q| untz.find_index{|q2| q2[0]==q}.nil?}
    skkz[i][8]=skkz[i][8].map{|q| "#{'~~' unless untz[untz.find_index{|q2| q2[0]==q}][13][0].nil?}#{q}#{'~~' unless untz[untz.find_index{|q2| q2[0]==q}][13][0].nil?}"}
    skkz[i][8]=skkz[i][8].join(', ')
    skkz[i][1]="#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]}#{'~~' unless skkz[i][15].nil?} \u2192 #{skkz[i][8]}"
  end
  k=skkz.reject{|q| q[10]=='-'}
  f=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],
     ['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],
     ['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],
     ['<:Colorless_Tome:443692133317345290> Colorless Tomes',[]],
     ['<:Gold_Dragon:443172811641454592> Dragon Breaths',[]],['<:Gold_Beast:532854442299752469> Beast Damage',[]],
     ['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],
     ["#{"<:Gold_Staff:443172811628871720>" if alter_classes(event,'Colored Healers')}#{"<:Colorless_Staff:443692132323295243>" unless alter_classes(event,'Colored Healers')} Damaging Staves",[]]]
  for i in 0...k.length
    f[0][1].push(k[i][1]) if k[i][7]=='Sword Users Only'
    f[1][1].push(k[i][1]) if k[i][7]=='Red Tome Users Only'
    f[2][1].push(k[i][1]) if k[i][7]=='Lance Users Only'
    f[3][1].push(k[i][1]) if k[i][7]=='Blue Tome Users Only'
    f[4][1].push(k[i][1]) if k[i][7]=='Axe Users Only'
    f[5][1].push(k[i][1]) if k[i][7]=='Green Tome Users Only'
    f[6][1].push(k[i][1]) if k[i][7]=='Colorless Tome Users Only'
    f[7][1].push(k[i][1]) if k[i][7]=='Dragons Only'
    f[8][1].push(k[i][1]) if k[i][7].split(', ').include?('Beasts Only')
    f[9][1].push(k[i][1]) if k[i][7]=='Bow Users Only'
    f[10][1].push(k[i][1]) if k[i][7]=='Dagger Users Only'
    f[12][1].push(k[i][1]) if k[i][7]=='Staff Users Only'
  end
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
  k=skkz-k
  f=[['<:Red_Blade:443172811830198282> Swords',[]],['<:Red_Tome:443172811826003968> Red Tomes',[]],
     ['<:Blue_Blade:467112472768151562> Lances',[]],['<:Blue_Tome:467112472394858508> Blue Tomes',[]],
     ['<:Green_Blade:467122927230386207> Axes',[]],['<:Green_Tome:467122927666593822> Green Tomes',[]],
     ['<:Gold_Dragon:443172811641454592> Dragon Breaths',[]],['<:Gold_Beast:532854442299752469> Beast Damage',[]],
     ['<:Gold_Bow:443172812492898314> Bows',[]],['<:Gold_Dagger:443172811461230603> Daggers',[]],
     ["#{"<:Gold_Staff:443172811628871720>" if alter_classes(event,'Colored Healers')}#{"<:Colorless_Staff:443692132323295243>" unless alter_classes(event,'Colored Healers')} Damaging Staves",[]]]
  for i in 0...k.length
    f[0][1].push(k[i][1]) if k[i][7]=='Sword Users Only'
    f[1][1].push(k[i][1]) if k[i][7]=='Red Tome Users Only'
    f[2][1].push(k[i][1]) if k[i][7]=='Lance Users Only'
    f[3][1].push(k[i][1]) if k[i][7]=='Blue Tome Users Only'
    f[4][1].push(k[i][1]) if k[i][7]=='Axe Users Only'
    f[5][1].push(k[i][1]) if k[i][7]=='Green Tome Users Only'
    f[6][1].push(k[i][1]) if k[i][7]=='Dragons Only'
    f[7][1].push(k[i][1]) if k[i][7].split(', ').include?('Beasts Only')
    f[8][1].push(k[i][1]) if k[i][7]=='Bow Users Only'
    f[9][1].push(k[i][1]) if k[i][7]=='Dagger Users Only'
    f[10][1].push(k[i][1]) if k[i][7]=='Staff Users Only'
  end
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
  skkz=@skills.reject{|q| q[6]!='Assist' || q[8]=='-' || !has_any?(g, q[15])}
  for i in 0...skkz.length
    skkz[i][8]=skkz[i][8].split(', ').reject{|q| untz.find_index{|q2| q2[0]==q}.nil?}
    skkz[i][8]=skkz[i][8].map{|q| "#{'~~' unless untz[untz.find_index{|q2| q2[0]==q}][13][0].nil?}#{q}#{'~~' unless untz[untz.find_index{|q2| q2[0]==q}][13][0].nil?}"}
    skkz[i][8]=skkz[i][8].join(', ')
    skkz[i][1]="#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]}#{'~~' unless skkz[i][15].nil?} \u2192 #{skkz[i][8]}"
  end
  k=skkz.map{|q| q}
  skkz=@skills.reject{|q| q[6]!='Special' || q[8]=='-' || !has_any?(g, q[15])}
  for i in 0...skkz.length
    skkz[i][8]=skkz[i][8].split(', ').reject{|q| untz.find_index{|q2| q2[0]==q}.nil?}
    skkz[i][8]=skkz[i][8].map{|q| "#{'~~' unless untz[untz.find_index{|q2| q2[0]==q}][13][0].nil?}#{q}#{'~~' unless untz[untz.find_index{|q2| q2[0]==q}][13][0].nil?}"}
    skkz[i][8]=skkz[i][8].join(', ')
    skkz[i][1]="#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]}#{'~~' unless skkz[i][15].nil?} \u2192 #{skkz[i][8]}"
  end
  if k.map{|q| q[0]}.join("\n").length+skkz.map{|q| q[0]}.join("\n").length>1800
    if k.map{|q| q[0]}.join("\n").length>1800
      str='<:Skill_Assist:444078171025965066>__**PRF Assists**__'
      for i in 0...k.length
        str=extend_message(str,k[i],event)
      end
      event.respond str
    else
      create_embed(event,'<:Skill_Assist:444078171025965066>__**PRF Assists**__','',0x07DFBB,nil,nil,triple_finish(k.map{|q| q[1]},true))
    end
    if skkz.map{|q| q[0]}.join("\n").length>1800
      str='<:Skill_Special:444078170665254929>__**PRF Specials**__'
      for i in 0...skkz.length
        str=extend_message(str,skkz[i],event)
      end
      event.respond str
    else
      create_embed(event,'<:Skill_Special:444078170665254929>__**PRF Specials**__','',0xF67EF8,nil,nil,triple_finish(skkz.map{|q| q[1]},true))
    end
  else
    create_embed(event,'__**PRF Assists and Specials**__','',0x7FAFDA,nil,nil,[['<:Skill_Assist:444078171025965066> Assists',k.map{|q| q[1]}.join("\n")],['<:Skill_Special:444078170665254929> Specials',skkz.map{|q| q[1]}.join("\n")]])
  end
  skkz=@skills.reject{|q| ['Weapon','Assist','Special','Seal','Passive(W)'].include?(q[6]) || q[12].reject{|q2| q2=='-'}.length<=0 || q[8]=='-' || !has_any?(g, q[15])}
  for i in 0...skkz.length
    skkz[i][8]=skkz[i][8].split(', ').reject{|q| untz.find_index{|q2| q2[0]==q}.nil?}
    skkz[i][8]=skkz[i][8].map{|q| "#{'~~' unless untz[untz.find_index{|q2| q2[0]==q}][13][0].nil?}#{q}#{'~~' unless untz[untz.find_index{|q2| q2[0]==q}][13][0].nil?}"}
    skkz[i][8]=skkz[i][8].join(', ')
    skkz[i][1]="#{'~~' unless skkz[i][15].nil?}#{skkz[i][1]}#{'~~' unless skkz[i][15].nil?} \u2192 #{skkz[i][8]}"
  end
  f=[['<:Passive_A:443677024192823327> A Passives',[]],['<:Passive_B:443677023257493506> B Passives',[]],['<:Passive_C:443677023555026954> C Passives',[]]]
  for i in 0...skkz.length
    f[0][1].push(skkz[i][1]) if skkz[i][6].split(', ').include?('Passive(A)')
    f[1][1].push(skkz[i][1]) if skkz[i][6].split(', ').include?('Passive(B)')
    f[2][1].push(skkz[i][1]) if skkz[i][6].split(', ').include?('Passive(C)')
  end
  f=f.reject{|q| q[1].nil? || q[1].length<=0}
  if f.map{|q| "__*#{q[0]}*__\n#{q[1].join("\n")}"}.join("\n\n").length>=1800
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
    str="#{str}\n\n**Q6.) That thumbnail, who I presume is Oregano, is adorable.  Where do I find it?**\nMy friend BluechanXD, from the same server, made it based on Draco's description.  [Here's a link](https://www.deviantart.com/bluechanxd/art/FE-OC-Oregano-V2-765406579)." unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
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

def random_dev_unit_with_nature(event,x=true) # used by `disp_more_info()` to randomly display a non-neutral dev unit as an example on how to format units
  devunits_load()
  u=@dev_units.sample
  if x
    # try again if the randomly-chosen unit is neutral or server-specific to another server
    return random_dev_unit_with_nature(event) if u[3]==' ' || u[4]==' ' || find_unit(u[0],event,true).length<=0
  end
  return u
end

def hybrid_range(x,y)
  # turning each string into an array, splitting by the fake newline character
  x=x.split("n") if x.is_a?(String)
  y=y.split("n") if y.is_a?(String)
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
  data_load()
  sklz=@skills.map{|q| q}
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
      m=sklz[sklz.find_index{|q| q[1]=="Blazing #{type}"}]
      m2=sklz[sklz.find_index{|q| q[1]=="Growing #{type}"}]
      str="__**Blazing #{type}** vs. **Growing #{type}**__\n#{hybrid_range(m[5],m2[5])}"
      str2=extend_message(str2,str,event)
    end
  end
  type=['specials','Flame','Wind','Thunder','Light'][mode]
  str2=extend_message(str2,"Base damage is `Atk - eDR`, where eDR is the enemy's Def or Res, based on the type of weapon being used.\nBlazing #{type} do#{'es' if mode>0} 1.5x as much damage as Growing #{type}.\nRising #{type} ha#{'ve' if mode==0}#{'s' if mode>0} the range of Blazing but deal#{'s' if mode>0} as much damage as Growing.",event)
  event.respond str2
end

def disp_unit_art(event,name,bot)
  untz=@units.map{|q| q}
  j=untz[untz.find_index{|q| q[0]==name}]
  data_load()
  args=event.message.text.downcase.split(' ')
  artype=[]
  resp=false
  resp=true if has_any?(args.map{|q| q.downcase},['resplendant','resplendent','ascension','ascend','resplend','ex'])
  resp=true if args.join(' ').include?('resplend')
  resp=true if args.join(' ').include?('ascend')
  resp=true if args.join(' ').include?('ascension')
  resp=false unless j[9][0].include?('RA')
  if has_any?(args,['sprite'])
    art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Sprites/#{j[0]}#{'_Resplendent' if resp}.png"
    m=false
    IO.copy_stream(open(art),"C:/Users/Mini-Matt/Desktop/devkit/FEHTemp#{@shardizard}.png") rescue m=true
    if File.size("C:/Users/Mini-Matt/Desktop/devkit/FEHTemp#{@shardizard}.png")>100 && !m
      artype=['Sprite','In-game Sprite ~~with default weapon~~']
      j[6]=''
      j[7]=['','']
    else
      artype=['Face',"~~Sprite not yet on site~~\nDefault"]
    end
  elsif has_any?(args,['battle','attack','att','atk','attacking'])
    artype=['BtlFace','Attack']
  elsif has_any?(args,['damage','damaged','lowhealth','lowhp','low_health','low_hp','injured']) || (args.include?('low') && has_any?(args,['health','hp']))
    artype=['BtlFace_D','Damaged']
  elsif has_any?(args,['critical','special','crit','proc'])
    artype=['BtlFace_C','Special']
  elsif has_any?(args,['loading','load','title']) && ['Alfonse','Sharena','Veronica','Eirika(Bonds)','Marth','Roy','Ike','Chrom(Launch)','Camilla(Launch)','Takumi','Lyn','Marth(Launch)','Roy(Launch)','Ike(World)','Takumi(Launch)','Lyn(Launch)'].include?(j[0])
    artype=['Face_Load','Title Screen']
    j[6]=''
  end
  lookout=lookout_load('SkillSubsets')
  lookout=lookout.reject{|q| q[2]!='Art'}
  charza=j[0].gsub(' ','_')
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
  if j[0]=='Hrid'
    if zart.include?('Toasty')
      for i in 0...zart.length
        zart[i]=nil if zart[i]=='Toasty'
      end
      zart.compact!
      zart2=zart.map{|q| "#{q}_Toasty"}
      zart2.push('Toasty')
      for i in 0...zart.length
        zart2.push(zart[i])
      end
      zart=zart2.map{|q| q}
    end
  else
    for i in 0...zart.length
      zart[i]=nil if zart[i]=='Toasty'
    end
    zart.compact!
  end
  artype2=[]
  charza="#{charza}/Resplendent" if resp
  for i in 0...zart.length
    m=false
    IO.copy_stream(open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{charza}/Face_#{zart[i]}.png"), "C:/Users/Mini-Matt/Desktop/devkit/FEHTemp#{@shardizard}.png") rescue m=true
    unless File.size("C:/Users/Mini-Matt/Desktop/devkit/FEHTemp#{@shardizard}.png")<=100 || m || artype2.length>1
      artype2=["Face_#{zart[i]}","#{zart[i].gsub('_',' ')}"]
    end
  end
  artype=artype2.map{|q| q} if artype2.length>0
  artype=['Face','Default'] if artype.length<=0
  art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{charza}/#{artype[0]}.png"
  if artype[0]=='Sprite'
    charza=charza.gsub('/','_')
    art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Sprites/#{charza}.png"
  end
  disp=''
  nammes=['','','']
  pos=0
  pos=1 if resp && j[6].length>1
  xcolor=unit_color(event,find_unit(j[0],event),j[0],0)
  mathooz=false
  if args.map{|q| q.downcase}.include?("mathoo's") && find_in_dev_units(j[0])>0
    mathooz=true
    xcolor=0x00DAFA
    xcolor=0xFFABAF if j[0]=='Sakura'
  end
  unless j[6][pos].nil? || j[6][pos].length<=0
    m=j[6][pos].split(' as ')
    nammes[0]=m[0]
    disp="#{disp}\n**Artist:** #{m[m.length-1]}"
    if j[0]=='Alm(Saint)' && mathooz
      artype[0]="#{artype[0]}_Mathoo"
      artype[1]="*Pocket companion:* **Sakura**#{unit_moji(bot,event,-1,'Sakura',true,4)}\n#{artype[1]}"
      art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{charza}/#{artype[0]}.png"
      if artype[0]=='Sprite'
        charza=charza.gsub('/','_')
        art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Sprites/#{charza}_Mathoo.png"
      else
        j2=untz.find_index{|q| q[0]=='Sakura'}
        unless j2.nil?
          j2=untz[j2]
          m2=j2[6][0].split(' as ')
          disp="#{disp}\n*Smol contribution from:* #{m2[m2.length-1]}"
        end
      end
    end
  end
  if j[0]=='Alm(Saint)' && mathooz && artype[0]=='Sprite'
    charza=charza.gsub('/','_')
    artype[1]="*Pocket companion:* **Sakura**#{unit_moji(bot,event,-1,'Sakura',true,4)}\n#{artype[1]}"
    art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Sprites/#{charza}_Mathoo.png"
  end
  unless j[7][0].nil? || j[7][0].length<=0
    m=j[7][0].split(' & ').map{|q| q.split(' as ')}
    for i in 0...m.length
      m[i]=['Sara Beth'] if j[8]==110 && resp
      m[i]=['Alexis Tipton'] if resp && m[i]=='Laura Bailey'
    end
    nammes[1]=m.map{|q| q[0]}.reject{|q| q=='>unknown<'}.join(' & ')
    disp="#{disp}\n**VA (English):** #{m.map{|q| q[-1]}.join(' & ')}"
  end
  unless j[7][1].nil? || j[7][1].length<=0
    m=j[7][1].split(' & ').map{|q| q.split(' as ')}
    nammes[2]=m.map{|q| q[0]}.reject{|q| q=='>unknown<'}.join(' & ')
    disp="#{disp}\n**VA (Japanese):** #{m.map{|q| q[-1]}.join(' & ')}"
  end
  crosspost=false
  if args.include?('just') || args.include?('justart') || args.include?('blank') || args.include?('noinfo')
    charsx=[[],[],[]]
  else
    if j[0]=='Reinhardt(World)' && (rand(100).zero? || event.message.text.downcase.include?('zelda') || event.message.text.downcase.include?('link') || event.message.text.downcase.include?('master sword'))
      art='https://i.redd.it/pdeqrncp21r01.png'
      artype=['','Meme Zelda']
      j[6]="u/ZachminSSB (ft. #{j[6]})"
    elsif j[0]=='Arden' && (rand(1000).zero? || event.message.text.downcase.include?('infinity'))
      art='https://pbs.twimg.com/media/DcEh5jRWsAAYofz.png'
      artype=['','Meme Thanos']
      j[6]='@_DJSaturn (twitter)'
    end
    g=get_markers(event)
    chars=untz.reject{|q| q[0]==j[0] || !has_any?(g, q[13][0]) || ((q[6].nil? || q[6].length<=0) && (q[7][0].nil? || q[7][0].length<=0) && (q[7][1].nil? || q[7][1].length<=0))}
    charsx=[[],[],[]]
    charsx[1].push('Feh the Owl *[voice 1]*') if nammes[1]=='Kimberly Tierney' && nammes[2]=='Kimura Juri'
    charsx[1].push('Feh the Owl *[voice 2]*') if nammes[1]=='Cassandra Lee Morris' && nammes[2]=='Kimura Juri'
    charsx[1].push('Feh the Owl *[English 1]*') if nammes[1]=='Kimberly Tierney' && nammes[2]!='Kimura Juri'
    charsx[1].push('Feh the Owl *[English 2]*') if nammes[1]=='Cassandra Lee Morris' && nammes[2]!='Kimura Juri'
    charsx[1].push('Feh the Owl *[Japanese]*') if nammes[1]!='Kimberly Tierney' && nammes[1]!='Cassandra Lee Morris' && nammes[2]=='Kimura Juri'
    charsx[1].push('Fehnix *[both]*') if nammes[1]=='Patrick Seitz' && nammes[2]=='Koyasu Takehito'
    charsx[1].push('Fehnix *[English]*') if nammes[1]=='Patrick Seitz' && nammes[2]!='Koyasu Takehito'
    charsx[1].push('Fehnix *[Japanese]*') if nammes[1]!='Patrick Seitz' && nammes[2]=='Koyasu Takehito'
    for i in 0...chars.length
      x=chars[i]
      unless x[6].nil? || x[6].length<=0 || x[7][0].nil? || x[7][0].length<=0 || x[7][1].nil? || x[7][1].length<=0
        m=x[6][0].split(' as ')
        m2=x[7][0].split(' as ')
        m3=x[7][1].split(' as ')
        charsx[2].push("#{x[0]}") if m[0]==nammes[0] && m2[0]==nammes[1] && m3[0]==nammes[2]
      end
      unless x[6][0].nil? || x[6][0].length<=0
        m=x[6][0].split(' as ')
        charsx[0].push(x[0]) if m[0]==nammes[0] && !charsx[2].include?(x[0])
      end
      unless x[6][1].nil? || x[6][1].length<=0
        m=x[6][1].split(' as ')
        charsx[0].push("#{x[0]} - Resplendent") if m[0]==nammes[0] && !charsx[2].include?(x[0])
      end
      unless x[7][0].nil? || x[7][0].length<=0 || x[7][1].nil? || x[7][1].length<=0
        if nammes[1].include?(' & ') || nammes[2].include?(' & ')
          nammes[1]=nammes[1].split(' & ')
          nammes[2]=nammes[2].split(' & ')
          for i2 in 0...[nammes[1].length,nammes[2].length].max
            nammes[1].push(nammes[1][0]) if nammes[1].length<nammes[2].length
            nammes[2].push(nammes[2][0]) if nammes[2].length<nammes[1].length
          end
          m=x[7][0].split(' as ')
          m2=x[7][1].split(' as ')
          if [nammes[1].length,nammes[2].length].max>2
            m3=[]
            for i2 in 0...[nammes[1].length,nammes[2].length].max
              m3.push("v#{i2+1}") if m[0]==nammes[1][i2] && m2[0]==nammes[2][i2]
              m3.push("E#{i2+1}") if m[0]==nammes[1][i2] && m2[0]!=nammes[2][i2]
              m3.push("J#{i2+1}") if m[0]!=nammes[1][i2] && m2[0]==nammes[2][i2]
            end
            charsx[1].push("#{x[0]} *[#{m3.join('+')}]*") if m3.length>3
            charsx[1].push("#{x[0]} *[#{m3[0].gsub('E','English ').gsub('J','Japanese ').gsub('v','voice ')}]*") if m3.length==1
          else
            if charsx[2].include?(x[0])
            elsif m[0]==nammes[1][0] && m2[0]==nammes[2][0]
              charsx[1].push("#{x[0]} *[voice 1]*")
            elsif m[0]==nammes[1][1] && m2[0]==nammes[2][1]
              charsx[1].push("#{x[0]} *[voice 2]*")
            elsif m[0]==nammes[1][0] && m2[0]==nammes[2][1]
              charsx[1].push("#{x[0]} *[E1+J2]*")
            elsif m[0]==nammes[1][1] && m2[0]==nammes[2][0]
              charsx[1].push("#{x[0]} *[E2+J1]*")
            end
          end
          nammes[1]=nammes[1].uniq.join(' & ')
          nammes[2]=nammes[2].uniq.join(' & ')
        else
          m=x[7][0].split(' & ').map{|q| q.split(' as ')[0]}.join(' & ')
          xx="#{x[0]}"
          if nammes[1]=='Sara Beth' && x[8]==110
            m='Sara Beth'
            xx="#{xx} - Resplendent"
          elsif nammes[1]=='Alexis Tipton' && m=='Laura Bailey' && x[9][0].include?('RA')
            m='Alexis Tipton'
            xx="#{xx} - Resplendent"
          end
          m2=x[7][1].split(' & ').map{|q| q.split(' as ')[0]}.join(' & ')
          charsx[1].push("#{xx} *[Both]*") if [m.length,m2.length].max<3 && m==nammes[1] && m2==nammes[2] && !charsx[2].include?(x[0])
        end
      end
      unless x[7][0].nil? || x[7][0].length<=0 || x[7][1].nil? || x[7][1].length<=0
        m=x[7][0].split(' & ').map{|q| q.split(' as ')[0]}.join(' & ')
        xx="#{x[0]}"
        if nammes[1]=='Sara Beth' && x[8]==110
          m='Sara Beth'
          xx="#{xx} - Resplendent"
        elsif nammes[1]=='Alexis Tipton' && m=='Laura Bailey' && x[9][0].include?('RA')
          m='Alexis Tipton'
          xx="#{xx} - Resplendent"
        end
        m2=x[7][1].split(' & ').map{|q| q.split(' as ')[0]}.join(' & ')
        unless nammes[1].include?(' & ') || nammes[2].include?(' & ')
          charsx[1].push("#{xx} *[Both]*") if m==nammes[1] && m2==nammes[2] && !charsx[1].map{|q| q.split(' *[')[0]}.include?(x[0]) && !charsx[2].include?(x[0])
        end
      end
      unless x[7][0].nil? || x[7][0].length<=0
        m=x[7][0].split(' & ').map{|q| q.split(' as ')[0]}.join(' & ')
        xx="#{x[0]}"
        if nammes[1]=='Sara Beth' && x[8]==110
          m='Sara Beth'
          xx="#{xx} - Resplendent"
        elsif nammes[1]=='Alexis Tipton' && m=='Laura Bailey' && x[9][0].include?('RA')
          m='Alexis Tipton'
          xx="#{xx} - Resplendent"
        end
        if nammes[1].include?(' & ')
          m2=nammes[1].split(' & ')
          for i2 in 0...m2.length
            charsx[1].push("#{xx} *[English #{i2+1}]*") if m==m2[i2] && !charsx[1].map{|q| q.split(' *[')[0]}.include?(x[0]) && !charsx[2].include?(x[0])
          end
        else
          charsx[1].push("#{xx} *[English]*") if m==nammes[1] && !charsx[1].map{|q| q.split(' *[')[0]}.include?(xx) && !charsx[2].include?(xx)
        end
      end
      unless x[7][1].nil? || x[7][1].length<=0
        m=x[7][1].split(' & ').map{|q| q.split(' as ')[0]}.join(' & ')
        if nammes[2].include?(' & ')
          m2=nammes[2].split(' & ')
          for i2 in 0...m2.length
            charsx[1].push("#{x[0]} *[Japanese #{i2+1}]*") if m==m2[i2] && !charsx[1].map{|q| q.split(' *[')[0]}.include?(x[0]) && !charsx[2].include?(x[0])
          end
        else
          charsx[1].push("#{x[0]} *[Japanese]*") if m==nammes[2] && !charsx[1].map{|q| q.split(' *[')[0]}.include?(x[0]) && !charsx[2].include?(x[0])
        end
      end
    end
    fgosrv=[]
    dladv=[]
    dldrg=[]
    dlnpc=[]
    if event.server.nil? || !bot.user(502288364838322176).on(event.server.id).nil? || @shardizard==4
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FGOServants.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/FGOServants.txt').each_line do |line|
          b.push(line)
        end
      else
        b=[]
      end
      crosspost=true
      b=b.map{|q| q.gsub("\n",'').split('\\'[0])}
      for i in 0...b.length
        if b[i][0].include?('.')
          b[i][0]=[b[i][0].to_f,true]
        else
          b[i][0]=[b[i][0].to_i,false]
        end
      end
      for i in 0...b.length
        dispnum="#{b[i][0][0]}#{'.' unless b[i][0][1]}"
        if b[i][0][1]
          b2=b.reject{|q| q[0][0].to_i != b[i][0][0].to_i}.map{|q| [q[24],q[25]]}.uniq
          if b[i][0][0].to_i==b[i][0][0]
            dispnum="#{b[i][0][0].to_i}." if b2.length<2
            b[i][0][1]=false
          else
            b[i][0][1]=false if b2.length>1
          end
        end
        unless nammes[0].nil? || nammes[0].length<=0 || b[i][24].nil? || b[i][24].length<=0
          charsx[0].push("*[FGO]* Srv-#{dispnum}) #{b[i][1]}") if b[i][24]==nammes[0] && !b[i][0][1]
        end
        unless nammes[2].nil? || nammes[2].length<=0 || b[i][25].nil? || b[i][25].length<=0
          charsx[1].push("*[FGO]* Srv-#{dispnum}) #{b[i][1]} *[Japanese]*") if b[i][25].split(' & ').include?(nammes[2]) && !b[i][0][1]
        end
      end
      fgosrv=b.map{|q| q}
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
          charsx[0].push("*[FGO]* CE-#{b[i][0]}#{".) #{b[i][1]}" unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}") if b[i][9]==nammes[0]
        end
      end
    end
    if event.server.nil? || !bot.user(543373018303299585).on(event.server.id).nil? || @shardizard==4
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/DLAdventurers.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/DLAdventurers.txt').each_line do |line|
          b.push(line)
        end
      else
        b=[]
      end
      crosspost=true
      for i in 0...b.length
        b[i]=b[i].gsub("\n",'').split('\\'[0])
        unless b[i][10].nil? || b[i][10].length<=0 || b[i][11].nil? || b[i][11].length<=0
          m=b[i][10].split(' as ')
          m2=b[i][11].split(' as ')
          charsx[1].push("*[DL-Adv]* #{b[i][0]} *[Both]*") if m[0]==nammes[2] && m2[0]==nammes[1]
        end
        unless b[i][11].nil? || b[i][11].length<=0
          m=b[i][11].split(' as ')
          charsx[1].push("*[DL-Adv]* #{b[i][0]} *[English]*") if m[0]==nammes[1] && !charsx[1].include?("*[DL-Adv]* #{b[i][0]} *[Both]*")
        end
        unless b[i][10].nil? || b[i][10].length<=0
          m=b[i][10].split(' as ')
          charsx[1].push("*[DL-Adv]* #{b[i][0]} *[Japanese]*") if m[0]==nammes[2] && !charsx[1].include?("*[DL-Adv]* #{b[i][0]} *[Both]*")
        end
      end
      dladv=b.map{|q| q}
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/DLDragons.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/DLDragons.txt').each_line do |line|
          b.push(line)
        end
      else
        b=[]
      end
      for i in 0...b.length
        b[i]=b[i].gsub("\n",'').split('\\'[0])
        unless b[i][13].nil? || b[i][13].length<=0 || b[i][14].nil? || b[i][14].length<=0
          m=b[i][13].split(' as ')
          m2=b[i][14].split(' as ')
          charsx[1].push("*[DL-Drg]* #{b[i][0]} *[Both]*") if m[0]==nammes[2] && m2[0]==nammes[1]
        end
        unless b[i][14].nil? || b[i][14].length<=0
          m=b[i][14].split(' as ')
          charsx[1].push("*[DL-Drg]* #{b[i][0]} *[English]*") if m[0]==nammes[1] && !charsx[1].include?("*[DL-Drg]* #{b[i][0]} *[Both]*")
        end
        unless b[i][13].nil? || b[i][13].length<=0
          m=b[i][13].split(' as ')
          charsx[1].push("*[DL-Drg]* #{b[i][0]} *[Japanese]*") if m[0]==nammes[2] && !charsx[1].include?("*[DL-Drg]* #{b[i][0]} *[Both]*")
        end
      end
      dldrg=b.map{|q| q}
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/DL_NPCs.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/DL_NPCs.txt').each_line do |line|
          b.push(line)
        end
      else
        b=[]
      end
      for i in 0...b.length
        b[i]=b[i].gsub("\n",'').split('\\'[0])
        unless b[i][3].nil? || b[i][3].length<=0 || b[i][4].nil? || b[i][4].length<=0
          m=b[i][4].split(' as ')
          m2=b[i][3].split(' as ')
          charsx[1].push("*[DL-NPC]* #{b[i][0]} *[Both]*") if m[0]==nammes[2] && m2[0]==nammes[1]
        end
        unless b[i][3].nil? || b[i][3].length<=0
          m=b[i][3].split(' as ')
          charsx[1].push("*[DL-NPC]* #{b[i][0]} *[English]*") if m[0]==nammes[1] && !charsx[1].include?("*[DL-NPC]* #{b[i][0]} *[Both]*")
        end
        unless b[i][4].nil? || b[i][4].length<=0
          m=b[i][4].split(' as ')
          charsx[1].push("*[DL-NPC]* #{b[i][0]} *[Japanese]*") if m[0]==nammes[2] && !charsx[1].include?("*[DL-NPC]* #{b[i][0]} *[Both]*")
        end
      end
      dlnpc=b.map{|q| q}
      if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/DLWyrmprints.txt')
        b=[]
        File.open('C:/Users/Mini-Matt/Desktop/devkit/DLWyrmprints.txt').each_line do |line|
          b.push(line)
        end
      else
        b=[]
      end
      for i in 0...b.length
        b[i]=b[i].gsub("\n",'').split('\\'[0])
        unless b[i][7].nil? || b[i][7].length<=0 || b[i][0].include?('Wily Warriors ')
          m=b[i][7].split(' as ')
          charsx[0].push("*[DL-Print]* #{b[i][0]}") if m[0]==nammes[0]
        end
      end
      if j[7].nil? || j[7][1].nil?
      elsif (!j[7][0].nil? && j[7][0].include?(' & ')) || j[7][1].include?(' & ')
        m=''
        m=j[7][0].split(' & ') unless j[7][0].nil?
        m2=j[7][1].split(' & ')
        for i in 0...([m.length,m2.length].max-[m.length,m2.length].min)
          m.push(m[0]) if m.length<m2.length
          m2.push(m2[0]) if m2.length<m.length
        end
        m3=[[],[],[]]
        for i in 0...m.length
          fxx=fgosrv.reject{|q| q[25]!=m2[i]}.map{|q| "*[FGO]* Srv-#{q[0]}#{'.' if q[0].to_i>=2}) #{q[1]} *[Japanese #{i+1}]*"}
          charsx[1].push(fxx)
          fxx=dladv.reject{|q| q[10].nil? || q[10].length<=0 || q[10]!=m2[i] || q[11].nil? || q[11].length<=0 || q[11]!=m[i]}.map{|q| "*[DL-Adv]* #{q[0]} *[voice #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
          fxx=dladv.reject{|q| q[10].nil? || q[10].length<=0 || q[10]==m2[i] || q[11].nil? || q[11].length<=0 || q[11]!=m[i]}.map{|q| "*[DL-Adv]* #{q[0]} *[English #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
          fxx=dladv.reject{|q| q[10].nil? || q[10].length<=0 || q[10]!=m2[i] || q[11].nil? || q[11].length<=0 || q[11]==m[i]}.map{|q| "*[DL-Adv]* #{q[0]} *[Japanese #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
          fxx=dldrg.reject{|q| q[13].nil? || q[13].length<=0 || q[13]!=m2[i] || q[14].nil? || q[14].length<=0 || q[14]!=m[i]}.map{|q| "*[DL-Drg]* #{q[0]} *[voice #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
          fxx=dldrg.reject{|q| q[13].nil? || q[13].length<=0 || q[13]==m2[i] || q[14].nil? || q[14].length<=0 || q[14]!=m[i]}.map{|q| "*[DL-Drg]* #{q[0]} *[English #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
          fxx=dldrg.reject{|q| q[13].nil? || q[13].length<=0 || q[13]!=m2[i] || q[14].nil? || q[14].length<=0 || q[14]==m[i]}.map{|q| "*[DL-Drg]* #{q[0]} *[Japanese #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
          fxx=dlnpc.reject{|q| q[4].nil? || q[4].length<=0 || q[4]!=m2[i] || q[3].nil? || q[3].length<=0 || q[3]!=m[i]}.map{|q| "*[DL-NPC]* #{q[0]} *[voice #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
          fxx=dlnpc.reject{|q| q[4].nil? || q[4].length<=0 || q[4]==m2[i] || q[3].nil? || q[3].length<=0 || q[3]!=m[i]}.map{|q| "*[DL-NPC]* #{q[0]} *[English #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
          fxx=dlnpc.reject{|q| q[4].nil? || q[4].length<=0 || q[4]!=m2[i] || q[3].nil? || q[3].length<=0 || q[3]==m[i]}.map{|q| "*[DL-NPC]* #{q[0]} *[Japanese #{i+1}]*"}
          m3[0].push(fxx) if fxx.length>0
        end
        m3=m3.map{|q| q.flatten.sort}
        charsx[1].push(m3)
        charsx[1].flatten!
        charsx[1].compact!
      end
    end
    disp='>No information<' if disp.length<=0 && artype[0]!='Sprite'
  end
  dispx="#{disp}"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    disp="__**#{j[0]}**#{unit_moji(bot,event,-1,j[0],false,6)}__\n#{artype[1]}#{' art' unless artype[0]=='Sprite'}\n\n#{disp}"
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
    event.respond "This unit has a Resplendent Ascension.  Include the word \"Resplendent\" to look at that art." if j[9][0].include?('RA') && !resp
  else
    ftr=nil
    ftr="This unit has a Resplendent Ascension.  Include the word \"Resplendent\" to look at that art." if j[9][0].include?('RA') && !resp
    flds=[]
    flds.push(['Same Artist',charsx[0].join("\n")]) if charsx[0].length>0
    if charsx[1].length>0
      if charsx[1].length==charsx[1].reject{|q| !q.include?('*[Both]*')}.length
        flds.push(['Same VA (Both)',charsx[1].map{|q| q.gsub(' *[Both]*','')}.join("\n")])
      elsif charsx[1].length==charsx[1].reject{|q| !q.include?('*[English]*')}.length
        flds.push(['Same VA (English)',charsx[1].map{|q| q.gsub(' *[English]*','')}.join("\n")])
      elsif charsx[1].length==charsx[1].reject{|q| !q.include?('*[Japanese]*')}.length
        flds.push(['Same VA (Japanese)',charsx[1].map{|q| q.gsub(' *[Japanese]*','')}.join("\n")])
      else
        flds.push(['Same VA',charsx[1].join("\n")])
      end
    end
    flds.push(['Same everything',charsx[2].join("\n"),1]) if charsx[2].length>0
    if flds.length.zero?
      flds=nil
    elsif (flds.map{|q| q.join("\n")}.join("\n\n").length>=1500 || flds.map{|q| q[1].split("\n").length}.max>20) && safe_to_spam?(event)
      if flds.map{|q| q.join("\n")}.join("\n\n").length>=1500 || flds.map{|q| q[1].split("\n").length}.max>20
        for i in 0...flds.length
          if "__**#{flds[i][0]}**__\n#{flds[i][1]}".length>1900
            x="__**#{flds[i][0]}**__"
            x2=flds[i][1].split("\n")
            for i2 in 0...x2.length
              x=extend_message(x,x2[i2],event)
            end
            event.respond x
          elsif "__**#{flds[i][0]}**__\n#{flds[i][1]}".length>1500
            create_embed(event,"__**#{flds[i][0]}**__",flds[i][1],unit_color(event,find_unit(j[0],event),j[0],0))
          else
            create_embed(event,"__**#{flds[i][0]}**__",'',unit_color(event,find_unit(j[0],event),j[0],0),nil,nil,triple_finish(flds[i][1].split("\n"),true))
          end
        end
      else
        create_embed(event,'','',unit_color(event,find_unit(j[0],event),j[0],0),nil,nil,flds)
      end
      create_embed(event,"__#{"Mathoo's " if mathooz}**#{j[0]}**#{unit_moji(bot,event,-1,j[0],mathooz,4)}__#{"\nResplendent Ascension<:Resplendent_Ascension:678748961607122945>" if resp}\n#{artype[1]}#{' art' unless artype[0]=='Sprite'}",disp,xcolor,nil,[nil,art])
      return nil
    elsif flds.map{|q| q.join("\n")}.join("\n\n").length>=1500 || flds.map{|q| q[1].split("\n").length}.max>20
      disp="#{disp}\nThe list of units with the same artist and/or VA is so long that I cannot fit it into a single embed. Please use this command in PM."
      flds=nil
    else
      flds[-1][2]=nil if flds.length<3
      flds[-1].compact!
    end
    create_embed(event,"__#{"Mathoo's " if mathooz}**#{j[0]}**#{unit_moji(bot,event,-1,j[0],mathooz,4)}__#{"\nResplendent Ascension<:Resplendent_Ascension:678748961607122945>" if resp}\n#{artype[1]}#{' art' unless artype[0]=='Sprite'}",disp,xcolor,ftr,[nil,art],flds)
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
  if colors.length<=0 && weapons.length<=0 && color_weapons.length<=0 && movement.length<=0
    event.respond 'No unit was included.'
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
  art="https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/GENERICS/#{color_weapons[0]}_#{movement[0]}/BtlFace.png"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event.respond art
  else
    create_embed(event,"__Generic: **#{color_weapons[0]}_#{movement[0]}**__",'',0x800000,nil,[nil,art])
  end
end

def disp_learnable_skills(event,name,bot)
  data_load()
  untz=@units.map{|q| q}
  sklz=@skills.map{|q| q}
  j=untz[untz.find_index{|q| q[0]==name}]
  k=sklz.reject{|q| q[6]=='Passive(W)'}.map{|q| q[7]}.uniq
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
          u2=sklz[sklz.find_index{|q| q[1]=='Dance'}]
          b=[]
          for i3 in 0...@max_rarity_merge[0]
            u=u2[9][i3].split(', ')
            for j2 in 0...u.length
              b.push(u[j2]) unless b.include?(u[j2]) || u[j2].include?('-')
            end
          end
          k4=true if b.include?(j[0])
        end
        if k2[i2].include?('Singers')
          u2=sklz[sklz.find_index{|q| q[1]=='Sing'}]
          b=[]
          for i3 in 0...@max_rarity_merge[0]
            u=u2[9][i3].split(', ')
            for j2 in 0...u.length
              b.push(u[j2]) unless b.include?(u[j2]) || u[j2].include?('-')
            end
          end
          k4=true if b.include?(j[0])
        end
        if k2[i2].include?('Bards')
          u2=sklz[sklz.find_index{|q| q[1]=='Play'}]
          b=[]
          for i3 in 0...@max_rarity_merge[0]
            u=u2[9][i3].split(', ')
            for j2 in 0...u.length
              b.push(u[j2]) unless b.include?(u[j2]) || u[j2].include?('-')
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
  matches3=sklz.reject{|q| !bbb.include?(q[7]) || !has_any?(g, q[15]) || (q[8]!='-' && !q[8].split(', ').include?(j[0])) || q[1].include?('Squad Ace ') || q[1].include?('Initiate Seal ') || (q[6].split(', ').include?('Passive(W)') && !q[6].split(', ').include?('Passive(S)') && !q[6].split(', ').include?('Seal') && q[12].map{|q2| q2.split(', ').length}.max<2)}
  q=sklz[sklz.length-1]
  matches4=collapse_skill_list(matches3,3)
  matches4=split_list(event,matches4,['Weapon','Assist','Special','Passive(A)','Passive(B)','Passive(C)','Passive(S)'],6,true,'Skills')
  p1=[[]]
  p2=0
  for i in 0...matches4.length
    if matches4[i][1]=='- - -'
      p1.push([])
      p2+=1
    else
      p1[p2].push(matches4[i][1])
    end
  end
  j=untz.find_index{|q| q[0]==j[0]}
  p1=p1.map{|q| q.join("\n")}
  if p1[0].length+p1[1].length+p1[2].length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    msg="__Skills **#{untz[j][0]}**#{unit_moji(bot,event,j)} can learn__"
    msg=extend_message(msg,"<:Skill_Weapon:444078171114045450> *Weapons:* #{p1[0].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"<:Skill_Assist:444078171025965066> *Assists:* #{p1[1].gsub("\n",', ')}",event,2)
    msg=extend_message(msg,"<:Skill_Special:444078170665254929> *Specials:* #{p1[2].gsub("\n",', ')}",event,2)
    event.respond msg
  else
    create_embed(event,"__Skills **#{untz[j][0]}**#{unit_moji(bot,event,j)} can learn__",'',unit_color(event,j),nil,pick_thumbnail(event,j,bot),[["<:Skill_Weapon:444078171114045450> Weapons",p1[0]],["<:Skill_Assist:444078171025965066> Assists",p1[1]],["<:Skill_Special:444078170665254929> Specials",p1[2]]],4)
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
    create_embed(event,"__<:Passive_S:443677023626330122> Seals **#{untz[j][0]}**#{unit_moji(bot,event,j)} can equip__",'',unit_color(event,j),nil,nil,triple_finish(p1[6].split("\n")),4) unless p1[6].nil?
    event.respond 'Any undisplayed skill categories have too many applicable skills to display.' if p1.map{|q| q.gsub("\n",', ').length}.max>1900
  end
  return nil
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

def growth_explain(event,bot)
  disp="1.) Look for your unit's rarity in the top row."
  disp="#{disp}\n\n2.) Look for the value of your unit's GP in the leftmost column."
  disp="#{disp}\n- If you don't know the growth points, you can find them on the wiki or by including the word `growths` in your message when using the `FEH!stats` command."
  disp="#{disp}\n\n3.) Where the two intersect is the character's actual growth value."
  disp="#{disp}\n- This is how many points the unit's stat increases by when they go from Level 1 to Level 40."
  disp="#{disp}\n\n4.) In addition to the level 1 stats, a unit's nature affects their GPs."
  disp="#{disp}\n- A boon in a stat increases that stat's GP by 1 compared to a neutral version of the unit."
  disp="#{disp}\n- Likewise, a bane in a stat decreases the stat's GP by 1 compared to neutral."
  disp="#{disp}\n\n5.) \"Superboons\" and \"Superbanes\" are marked by the thick blue and red arrows, respectively."
  disp="#{disp}\n- A superboon is when a stat increases by 4 instead of the usual 3."
  disp="#{disp}\n- Likewise, a superbane is when a stat decreases by 4 instead of the usual 3."
  disp="#{disp}\n- (This chart shows supernatures as increasing/decreasing by 3 instead of 2, but this does not account for the +1/-1 on the level 1 stats.)"
  disp="#{disp}\n\n6.) If 1<:Icon_Rarity_1:448266417481973781>-2<:Icon_Rarity_2:448266417872044032> units could get natures, then they would have the possibility for \"microboons\" and \"microbanes\", where a stat increases or decreases by 2 instead of the usual 3."
  disp="#{disp}\n- These are marked by the thin blue and red arrows."
  if !safe_to_spam?(event)
    event.respond 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Growths.png'
  elsif @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
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
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?('mobile') || event.message.text.downcase.include?('phone')
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
    str="#{str}\n[Summon Simulator](https://feh-stuff.github.io/summon-simulator/)"
    str="#{str}\n[Inheritance tracker](https://arghblargh.github.io/feh-inheritance-tool/)"
    str="#{str}\n[Visual unit builder](https://feh-stuff.github.io/unit-builder/)"
    str="#{str}\n\n__Damage Calculators__"
    str="#{str}\n[ASFox's mass duel simulator](http://arcticsilverfox.com/feh_sim/)"
    str="#{str}\n[Andu2's mass duel simulator fork](https://andu2.github.io/FEH-Mass-Simulator/)"
    str="#{str}\n\n[FEHKeeper](https://www.fehkeeper.com/)"
    str="#{str}\n\n[Arena Score Calculator](http://www.arcticsilverfox.com/score_calc/)"
    str="#{str}\n\n[Glimmer vs. Moonbow](https://i.imgur.com/kDKPMp7.png)"
    create_embed(event,'**Useful tools for players of** ***Fire Emblem Heroes***',str,0xD49F61,nil,'https://lh3.googleusercontent.com/dVaaoEW7mJA7P34qV58lNovI3X9RDmbxhqVd1nUO886UVQjWJWvc7NDPXfKInk4JplE=s180-rw')
    event.respond 'If you are on a mobile device and cannot click the links in the embed above, type `FEH!tools mobile` to receive this message as plaintext.'
  end
end

def today_in_feh(event,bot,shift=false)
  t=Time.now
  timeshift=8
  timeshift-=1 unless (t-24*60*60).dst?
  t-=60*60*timeshift
  str="Time elapsed since today's reset: #{"#{t.hour} hours, " if t.hour>0}#{"#{'0' if t.min<10}#{t.min} minutes, " if t.hour>0 || t.min>0}#{'0' if t.sec<10}#{t.sec} seconds"
  str="#{str}\nTime until tomorrow's reset: #{"#{23-t.hour} hours, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds"
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  str="#{str}\n#{'~~' if shift}The Arena season ends in #{"#{15-t.hour} hours, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete your daily Arena-related quests before then!#{'~~' if shift}" if date%7==4 && 15-t.hour>=0
  str="#{str}\n#{'~~' if shift}The Aether Raid season ends in #{"#{15-t.hour} hours, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete any Aether-related quests before then!#{'~~' if shift}" if date%7==4 && 15-t.hour>=0
  str="#{str}\n#{'~~' if shift}The monthly quests end in #{"#{23-t.hour} hours, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete them before then!#{'~~' if shift}" if t.month != (t+24*60*60).month
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
  str="#{str}\n\n#{'~~' if shift}Date assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})#{'~~' if shift}"
  str="#{str}\n#{'~~' if shift}Days since game release: #{longFormattedNumber(date)}#{'~~' if shift}"
  if event.user.id==167657750971547648 && @shardizard==4
    str="#{str}\n#{'~~' if shift}Daycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12#{'~~' if shift}"
    str="#{str}\n#{'~~' if shift}Weekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%6+1}/6(Saturday) - #{week_from(date,0)%12+1}/12(Thursday) - #{week_from(date,3)%20+1}/20(Sunday)#{'~~' if shift}"
  end
  if shift
    t+=24*60*60
    t2=Time.new(2017,2,2)-60*60
    t2=t-t2
    date=(((t2.to_i/60)/60)/24)
    str="#{str}\n\nTomorrow's date: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
    str="#{str}\nDays since game release, come tomorrow: #{longFormattedNumber(date)}"
    if event.user.id==167657750971547648 && @shardizard==4
      str="#{str}\nTomorrow's daycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12"
      str="#{str}\nTomorrow's weekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%6+1}/6(Saturday) - #{week_from(date,0)%12+1}/12(Thursday) - #{week_from(date,3)%20+1}/20(Sunday)"
    end
    str2='__**Tomorrow in** ***Fire Emblem Heroes***__'
  else
    str2='__**Today in** ***Fire Emblem Heroes***__'
  end
  str2="#{str2}\nTraining Tower color: #{colors[date%colors.length]}"
  str2="#{str2}\nDaily Hero Battle: #{dhb[date%dhb.length]}"
  str2="#{str2}\nWeekend SP bonus!" if [1,2,3].include?(date%7)
  str2="#{str2}\nSpecial Training map: #{['Magic','The Workout','Melee','Ranged','Bows'][date%5]}"
  str2="#{str2}\nGrand Hero Battle revival: #{ghb[date%ghb.length].split(' / ')[0]}"
  str2="#{str2}\nGrand Hero Battle revival 2: #{ghb[date%ghb.length].split(' / ')[1]}"
  if (date)%7==3
    str2="#{str2}\nNew Blessed Gardens addition: #{garden[week_from(date,3)%garden.length]}"
  else
    str2="#{str2}\nNewest Blessed Gardens addition: #{garden[week_from(date,3)%garden.length]}"
  end
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
  bx=b.map{|q| q}
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
    c[i][1]='Lost Lore' if c[i][1]=='Lore'
    c[i][1]='Log-In Bonus' if c[i][1]=='Log-In' || c[i][1]=='Login'
    c[i][2]=c[i][2].split(', ')
  end
  str=extend_message(str,str2,event,2)
  str2=disp_current_events(bot,event,3,shift)
  str=extend_message(str,str2,event)
  if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(' tomorrow ') || " #{event.message.text.downcase} ".include?(' next ')
    str2=disp_current_events(bot,event,1,shift)
    str=extend_message(str,str2,event,2)
    str2=disp_current_events(bot,event,2,shift)
    str=extend_message(str,str2,event,2)
    str2=current_paths(event,bot,1)
    str2="__**Current Ephemura Paths**__\n#{str2}".split("\n")
    str=extend_message(str,str2[0],event,2)
    for i in 1...str2.length
      str=extend_message(str,str2[i],event,1)
    end
    bonus_load()
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b=@bonus_units.reject{|q| q[1]!='Arena' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2"There are no known quantities about Arena."
    else
      k=b[0][0].map{|q| q}
      m=k.length%2
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      str2="__**Current Arena Season#{', as of tomorrow' if shift}**__\n*Bonus Units:*\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}\n*Elemental season:* #{moji[0].mention unless moji.length<=0}#{b[0][3][0]}, #{moji2[0].mention unless moji2.length<=0}#{b[0][3][1]}"
    end
    str=extend_message(str,str2,event,2)
    b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2="There are no Tempest Trials events going on."
    else
      k=b[0][0].map{|q| q}
      m=k.length%2
      str2="__**Current Tempest Trials+ Bonus Units#{', as of tomorrow' if shift}**__\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}"
    end
    str=extend_message(str,str2,event,2)
    b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2"There are no known quantities about Aether Raids."
    else
      k=b[0][0].map{|q| q}
      m2=k.length%2
      m="#{b[0][4][0]} (O), #{b[0][4][1]} (D)"
      m="#{b[0][4][0]} (O/D)" if b[0][4][0]==b[0][4][1]
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      str2="__**Current Aether Raids Season#{', as of tomorrow' if shift}**__\n*Bonus Units:*\n#{k[0,k.length/2+m2].join(', ')}\n#{k[k.length/2+m2,k.length/2].join(', ')}\n*Bonus Structures:* #{m}\n*Elemental Season:* #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}"
    end
    str=extend_message(str,str2,event,2)
    unless shift
      str2='__**Tomorrow in** ***Fire Emblem Heroes***__'
      str2="#{str2}\nTraining Tower color: #{colors[(date+1)%colors.length]}"
      str2="#{str2}\nDaily Hero Battle: #{dhb[(date+1)%dhb.length]}"
      str2="#{str2}\nWeekend SP bonus!" if [1,2].include?((date+1)%7)
      str2="#{str2}\nSpecial Training map: #{['Magic','The Workout','Melee','Ranged','Bows'][(date+1)%5]}"
      str2="#{str2}\nGrand Hero Battle revival: #{ghb[(date+1)%ghb.length].split(' / ')[0]}"
      str2="#{str2}\nGrand Hero Battle revival 2: #{ghb[(date+1)%ghb.length].split(' / ')[1]}"
      str2="#{str2}\nNew Blessed Gardens addition: #{garden[week_from(date+1,3)%garden.length]}" if (date+1)%7==3
      if (date+1)%7==2 && rd[week_from(date+1,2)%rd.length]!=rd[week_from(date,2)%rd.length]
        if rd[week_from(date+1,2)%rd.length]==''
          str2="#{str2}\nRival Domains will be replaced with Relay Defense"
        else
          str2="#{str2}\nRival Domains movement preference: #{rd[week_from(date+1,2)%rd.length]}"
        end
      end
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
      b2=bx.reject{|q| q[4].nil? || q[4].split(', ')[0]!=tm}
      c2=c.reject{|q| q[2].nil? || q[2][0]!=tm}
      str2="#{str2}\nNew Banners: #{b2.map{|q| "*#{q[0]}*"}.join('; ')}" if b2.length>0
      str2="#{str2}\nNew Events: #{c2.map{|q| "*#{q[0]} (#{q[1]})*"}.join('; ')}" if c2.length>0
      tm="#{t3.year}#{'0' if t3.month<10}#{t3.month}#{'0' if t3.day<10}#{t3.day}".to_i
      bonus_load()
      b=@bonus_units.reject{|q| q[1]!='Arena' || q[2][0].split('/').reverse.join('').to_i != tm}
      unless b.length<=0
        k=b[0][0].map{|q| q}
        m=k.length%2
        element=b[0][3][0]
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
        element=b[0][3][1]
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        str2="#{str2}\nTomorrow's Arena Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}\nElemental season: #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}"
      end
      b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][0].split('/').reverse.join('').to_i != tm}
      unless b.length<=0
        k=b[0][0].map{|q| q}
        str2="#{str2}\nTomorrow's Tempest Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}"
      end
      b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][0].split('/').reverse.join('').to_i != tm}
      unless b.length<=0
        k=b[0][0].map{|q| q}
        m="#{b[0][4][0]} (O), #{b[0][4][1]} (D)"
        m="#{b[0][4][0]} (O/D)" if b[0][4][0]==b[0][4][1]
        element=b[0][3][0]
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        element=b[0][3][1]
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        str2="#{str2}\nTomorrow's Aether Raids Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}\nTomorrow's Aether Raids Bonus Structures: #{m}\nElemental Season: #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}"
      end
      str=extend_message(str,str2,event,2)
    end
  else
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i>tm || q[4].split(', ')[1].split('/').reverse.join('').to_i<tm}
    c2=c.reject{|q| q[2].nil? || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    str="#{str}\nCurrent Banners#{', as of tomorrow' if shift}: #{b2.map{|q| "*#{q[0]}*"}.join('; ')}"
    str="#{str}\nCurrent Events#{', as of tomorrow' if shift}: #{c2.map{|q| "*#{q[0]} (#{q[1]})*"}.join('; ')}"
    bonus_load()
    b=@bonus_units.reject{|q| q[1]!='Arena' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2="There are no known quantities about Arena."
    else
      k=b[0][0].map{|q| q}
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      str2="Current Arena Bonus Units#{', as of tomorrow' if shift}: #{k.map{|q| "*#{q}*"}.join(', ')}\nElemental season: #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}"
    end
    str=extend_message(str,str2,event)
    b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2="There are no Tempest Trials events going on."
    else
      k=b[0][0].map{|q| q}
      str2="Current Tempest Trials+ Bonus Units#{', as of tomorrow' if shift}: #{k.map{|q| "*#{q}*"}.join(', ')}"
    end
    str=extend_message(str,str2,event)
    b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2="There are no known quantities about Aether Raids."
    else
      k=b[0][0].map{|q| q}
      m="#{b[0][4][0]} (O), #{b[0][4][1]} (D)"
      m="#{b[0][4][0]} (O/D)" if b[0][4][0]==b[0][4][1]
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      str2="Current Aether Raids Bonus Units#{', as of tomorrow' if shift}: #{k.map{|q| "*#{q}*"}.join(', ')}\nCurrent Aether Raids Bonus Structures: #{m}\nElemental Season: #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}"
    end
    str=extend_message(str,str2,event)
  end
  event.respond str
end

def disp_current_events(bot,event,mode=0,shift=false)
  t=Time.now
  timeshift=8
  timeshift-=1 unless (t-24*60*60).dst?
  t-=60*60*timeshift
  t+=24*60*60 if shift && mode>0
  tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
  mdfr='left'
  mdfr='from now' if mode<0
  m=mode*1
  m=0-m if m<0
  str2="__**#{'Current' if mode>0}#{'Future' if mode<0} #{['','Banners','Events'][m]}#{', as of tomorrow' if shift}**__"
  str2="#{str2}\n~~all \"time remaining\" indicators shown as if from today's viewpoint~~" if shift && mode>0
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
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i>tm || (q[4].split(', ').length>1 && q[4].split(', ')[1].split('/').reverse.join('').to_i<tm)}
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i<=tm}.reverse if mode<0
    for i in 0...b2.length
      t2=b2[i][4].split(', ')[[mode,0].max].split('/').map{|q| q.to_i}
      t2=Time.new(t2[2],t2[1],t2[0])+24*60*60*([0,mode].min+1)
      t2=t2-t
      t2+=24*60*60 if shift && mode>0
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
      c[i][1]='Limited Hero Battle' if c[i][1]=='LmHB'
      c[i][1]='Mythic Hero Battle' if c[i][1]=='MHB'
      c[i][1]='Daily Reward Battle' if ['DRM','Daily Reward Maps','DRB'].include?(c[i][1])
      c[i][1]='Grand Conquests' if c[i][1]=='GC'
      c[i][1]='Rokkr Sieges' if ['RS','Rokkr'].include?(c[i][1])
      c[i][1]='Tempest Trials' if ['TT','Tempest'].include?(c[i][1])
      c[i][1]='Forging Bonds' if ['FB','Bonds','Bond Trials'].include?(c[i][1])
      c[i][1]='Tap Battle' if c[i][1]=='Illusory Dungeon'
      c[i][1]='Lost Lore' if c[i][1]=='Lore'
      c[i][1]='Log-In Bonus' if c[i][1]=='Log-In' || c[i][1]=='Login'
      c[i][1]='Hall of Forms' if c[i][1]=='HoF' || c[i][1]=='HOF'
      c[i][2]=c[i][2].split(', ') unless c[i][2].nil?
      c[i]=nil if c[i][2].nil?
    end
    c.compact!
    c2=c.reject{|q| q[2].nil? || q[2][0].split('/').reverse.join('').to_i>tm || (q.length>1 && q[2][1].split('/').reverse.join('').to_i<tm)}
    c2=c.reject{|q| q[2].nil? || q[2][0].split('/').reverse.join('').to_i<=tm} if mode<0
    for i in 0...c2.length
      t2=c2[i][2][[mode,0].max].split('/').map{|q| q.to_i}
      t2=Time.new(t2[2],t2[1],t2[0])+24*60*60*([0,mode].min+1)
      t2=t2-t
      t2+=24*60*60 if shift && mode>0
      n=c2[i][0]
      if ['Voting Gauntlet','Tempest Trials','Forging Bonds','Quests','Log-In Bonus','Lost Lore'].include?(c2[i][1])
        n="\"#{n}\" #{c2[i][1]}"
      elsif ['Bound Hero Battle','Grand Hero Battle','Legendary Hero Battle','Mythic Hero Battle','Daily Reward Battle','Limited Hero Battle','Special Maps'].include?(c2[i][1])
        n="#{c2[i][1]}: *#{n}*"
      elsif c2[i][1]=='Grand Conquests'
        n="Grand Conquests"
      elsif c2[i][1]=='Rokkr Sieges'
        n="Rokkr Sieges"
      elsif c2[i][1]=='Tap Battle'
        n="Tap Battle: #{n}"
      elsif c2[i][1]=='Hall of Forms'
        n="Hall of Forms: #{n}"
      elsif c2[i][1]=='Update'
        n="#{n} Update"
      elsif c2[i][1]=='Orb Promo'
        n="#{c2[i][1]} (#{n})"
      elsif c2[i][1]=='Event'
      else
        n="#{n} (#{c2[i][1]})"
      end
      tt2=(t2/(24*60*60)).floor
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
          str2="#{str2} - #{[(10-t2).floor,tt2].min} gifts remain for daily players"
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
      elsif c2[i][1]=='Rokkr Sieges' && mode>0
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
        elsif t2/60>1
          str2="#{str2} - #{(t2/60).floor} minutes remain in Battle #{t4/2+1}"
        elsif t2>1
          str2="#{str2} - #{t2.floor} seconds remain in Battle #{t4/2+1}"
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
  elsif [3,4,-3,-4].include?(mode)
    book1=["Amelia, Nephenee, Sanaki",
           "Gray, Ike(Brave), Lucina(Brave)",
           "Azura, Elise, Leo",
           "Deirdre, Linde, Tiki(Young)",
           "Cecilia, Delthea, Genny",
           "Julia, Nephenee, Sigurd",
           "Hector, Lyn, Lyn(Brave)",
           "Ike, Ike(Brave), Mist",
           "Julia, Lucina, Lucina(Brave)",
           "Hinoka, Ryoma, Takumi",
           "Genny, Katarina, Minerva",
           "Alm, Delthea, Faye",
           "Amelia, Ayra, Olwen(Bonds)",
           "Lyn(Brave), Ninian, Roy(Brave)",
           "Dorcas, Lute, Mia",
           "Hector, Luke, Tana",
           "Linde, Saber, Sonya",
           "Azura, Deirdre, Eldigan",
           "Ephraim, Jaffar, Karel",
           "Elincia, Innes, Tana"]
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    t2=Time.new(2017,2,2)-60*60
    t2=t-t2
    date=(((t2.to_i/60)/60)/24)
    if [3,4].include?(mode)
      f=book1[week_from(date,3)%20].split(', ')
      f=f.map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"}
      f=f.join(', ')
      return "#{'__**' if mode==4}Current Book 1 revival units#{"**__\n" if mode==4}#{': ' if mode==3}#{f}"
    elsif [-3,-4].include?(mode)
      book1=book1.rotate(1)
      f=book1[week_from(date,3)%20].split(', ')
      f=f.map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"}
      f=f.join(', ')
      return "#{'__**' if mode==4}Next Book 1 revival units#{"**__\n" if mode==4}#{': ' if mode==3}#{f}"
    end
    book1=book1.rotate(week_from(date,3)%20)
    str2=book1[0]
  end
  return str2
end

def show_bonus_units(event,args='',bot)
  bonus_load()
  data_load()
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
  unless args=='Tempest' || args=='Aether'
    b=@bonus_units.reject{|q| q[1]!='Arena' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      event.respond "There are no known quantities about Arena."
    else
      s=[0,1]
      m=[]
      k=[]
      flds=[]
      for i in 0...b.length
        if b[i][0]!=k
          unless i==0
            ss="Season #{s[0]}"
            ss="Current Season" if s[0]==1
            ss="Next Season" if s[0]==2
            if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
              event.respond "__**#{ss}**__\n\n#{m.join("\n")}" unless s[0]>2
            else
              flds.push([ss,m.join("\n")])
            end
          end
          k=b[i][0].map{|q| q}
          m=[]
          m.push(b[i][0].map{|q| "#{q}#{unit_moji(bot,event,-1,q,false,4) if safe_to_spam?(event)}"}.join("\n"))
          m.push('')
          s[0]+=1
          s[1]=1
        end
        element=b[i][3][0]
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
        element=b[i][3][1]
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"} if element=='Unknown'
        if i==0
          t2=Time.new(2017,2,2)-60*60
          t2=t-t2
          date=(((t2.to_i/60)/60)/24)
          m.push("Current week: #{moji[0].mention}#{b[i][3][0]}, #{moji2[0].mention}#{b[i][3][1]}") if date%7 != 4 || 15-t.hour>=0
        elsif i==1
          m.push("Next week: #{moji[0].mention}#{b[i][3][0]}, #{moji2[0].mention}#{b[i][3][1]}")
        elsif m[0,1]=='-' && s[1]>10
        elsif moji2.length<=0
          m.push("Week #{s[1]}: #{moji[0].mention}#{b[i][3][0]}, <:Legendary_Effect_Unknown:443337603945857024>#{b[i][3][1]}")
        else
          m.push("Week #{s[1]}: #{moji[0].mention}#{b[i][3][0]}, #{moji2[0].mention}#{b[i][3][1]}")
        end
        s[1]+=1
      end
      ss="Season #{s[0]}"
      ss="Current Season" if s[0]==1
      ss="Next Season" if s[0]==2
      if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        event.respond "__**#{ss}**__\n\n#{m.join("\n")}" unless s[0]>2
      else
        if safe_to_spam?(event)
          flds.push([ss,m.join("\n")])
          for i in 0...flds.length
            create_embed(event,"__**Arena: #{flds[i][0]}**__",flds[i][1],0x002837)
          end
        else
          create_embed(event,"__**Arena Bonus Units**__",'',0x002837,nil,nil,flds[0,[2,flds.length].min])
        end
      end
    end
  end
  unless args=='Arena' || args=='Aether'
    b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      event.respond "There are no known quantities about Tempest."
    else
      flds=[]
      k=b[0][0].map{|q| "#{q}#{unit_moji(bot,event,-1,q,false,4) if safe_to_spam?(event)}"}
      if b[0][2][0].split('/').reverse.join('').to_i<tm || b.length>1
        msg2="Current"
      else
        msg2="Future"
      end
      flds.push([msg2,k.join("\n")])
      if b.length>1
        k=b[1][0].map{|q| "#{q}#{unit_moji(bot,event,-1,q,false,4) if safe_to_spam?(event)}"}
        flds.push(['Future',k.join("\n")])
      end
      if flds.map{|q| "#{q[0]}\n#{q[1]}"}.join("\n\n").length>1500
        for i in 0...flds.length
          create_embed(event,"__**Tempest Trials: #{flds[i][0]}**__",flds[i][1],0x5ED0CF)
        end
      else
        create_embed(event,"__**Tempest Trials Bonus Units**__",'',0x5ED0CF,nil,nil,flds)
      end
    end
  end
  unless args=='Arena' || args=='Tempest'
    b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      event.respond "There are no known quantities about Aether Raids."
    else
      s=[0,1]
      m=[]
      m2=[]
      k=[]
      flds=[]
      for i in 0...b.length
        if b[i][0]!=k
          unless i==0
            ss="Season #{s[0]}"
            ss="Current Season" if s[0]==1
            ss="Next Season" if s[0]==2
            if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
              event.respond "__**#{ss}**__\n\n#{m.join("\n")}" unless s[0]>2
            else
              flds.push([ss,m.join("\n")])
            end
          end
          k=b[i][0].map{|q| q}
          m=[]
          m.push(b[i][0].map{|q| "#{q}#{unit_moji(bot,event,-1,q,false,4) if safe_to_spam?(event)}"}.join("\n"))
          m.push('')
          s[0]+=1
          s[1]=1
        end
        element=b[i][3][0]
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        element=b[i][3][1]
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        mm2="#{b[i][4][0]} (O), #{b[i][4][1]} (D)"
        mm2="#{b[i][4][0]} (O/D)" if b[i][4][0]==b[i][4][1]
        if i==0
          t2=Time.new(2017,2,2)-60*60
          t2=t-t2
          date=(((t2.to_i/60)/60)/24)
          m.push("#{"\n" unless s[1]==1}*Current week*\n#{moji[0].mention unless moji[0].nil?}#{b[i][3][0]}, #{moji2[0].mention unless moji2[0].nil?}#{b[i][3][1]}\n#{mm2}") if date%7 != 3 || 15-t.hour>=0
        elsif i==1
          m.push("#{"\n" unless s[1]==1}*Next week*\n#{moji[0].mention unless moji[0].nil?}#{b[i][3][0]}, #{moji2[0].mention unless moji2[0].nil?}#{b[i][3][1]}\n#{mm2}")
        elsif m[0,1]=='-' && s[1]>10
        else
          m.push("#{"\n" unless s[1]==1}*Week #{s[1]}*\n#{moji[0].mention unless moji[0].nil?}#{b[i][3][0]}, #{moji2[0].mention unless moji2[0].nil?}#{b[i][3][1]}\n#{mm2}")
        end
        s[1]+=1
      end
      ss="Season #{s[0]}"
      ss="Current Season" if s[0]==1
      ss="Next Season" if s[0]==2
      if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
        event.respond "__**#{ss}**__\n\n#{m.join("\n")}" unless s[0]>2
      else
        flds.push([ss,m.join("\n")])
        if safe_to_spam?(event)
          for i in 0...flds.length
            create_embed(event,"__**Aether Raids: #{flds[i][0]}**__",flds[i][1],0x54C571)
          end
        else
          create_embed(event,"__**Aether Raids Bonus Units**__",'',0x54C571,nil,nil,flds[0,[2,flds.length].min])
        end
      end
    end
  end
end

def next_events(event,bot,type)
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
  idx=10 if ['legendary','legendaries','legend','legends','mythic','mythicals','mythics','mythicals','mystics','mystic','mysticals','mystical'].include?(type.downcase)
  idx=11 if ['tactics','tactic','drills','drill','tacticsdrills','tactics_drills','tacticsdrill','tactics_drill','tacticdrills','tactic_drills','tacticdrill','tactic_drill'].include?(type.downcase)
  idx=12 if ['arena','bonus','arenabonus','arena_bonus'].include?(type.downcase)
  idx=13 if ['tempest','tempestbonus','tempest_bonus'].include?(type.downcase)
  idx=14 if ['aether','aetherbonus','aether_bonus','raid','raidbonus','raid_bonus','raids','raidsbonus','raids_bonus'].include?(type.downcase)
  idx=15 if ['book1','book_one','bookone','book1revival','bookonerevival','book_onerevival','bookone_revival','book_one_revival'].include?(type.downcase)
  idx=16 if ['divine','devine','path','ephemura','divines','devines','paths','ephemuras'].include?(type.downcase)
  if idx<0 && !safe_to_spam?(event)
    event.respond "I will not show everything at once.  Please use this command in PM, or narrow your search using one of the following terms:\nTower, Training_Tower, Color, Shard, Crystal\nFree, 1\\*, 2\\*, F2P, FreeHero\nSpecial, Special_Training\nGHB\nGHB2\nRival, Domain(s), RD, Rival_Domain(s)\nBlessed, Garden(s), Blessing, Blessed_Garden(s)\nTactics_Drills, Tactic(s), Drill(s)\nBanner(s), Summon(ing)(s)\nEvent(s)\nLegendary/Legendaries, Legend(s)\nArena, ArenaBonus, Arena_Bonus\nTempest, TempestBonus, Tempest_Bonus\nAether, AetherBonus, Aether_Bonus\nBonus\nBook1, Book1Revival\nDivine, Path, Ephemura"
    return nil
  end
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  msg="Time elapsed since today's reset: #{"#{t.hour} hours, " if t.hour>0}#{"#{'0' if t.min<10}#{t.min} minutes, " if t.hour>0 || t.min>0}#{'0' if t.sec<10}#{t.sec} seconds"
  msg="#{msg}\nTime until tomorrow's reset: #{"#{23-t.hour} hours, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds"
  msg="#{msg}\n\nDate assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  msg="#{msg}\nDays since game release: #{longFormattedNumber(date)}"
  if event.user.id==167657750971547648 && @shardizard==4
    msg=extend_message(msg,"Daycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12",event)
    msg=extend_message(msg,"Weekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%6+1}/6(Saturday) - #{week_from(date,0)%12+1}/12(Thursday) - #{week_from(date,3)%20+1}/20(Sunday)",event)
  end
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
        msg2="#{msg2}\n#{colors[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    unless colors[0]==colors[colors.length-1]
      t2=t+24*60*60*colors.length
      msg2="#{msg2}\n#{colors[0]} - #{colors.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
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
    dhb=dhb.rotate(date%dhb.length)
    msg2='__**Daily Hero Battles**__'
    for i in 0...dhb.length
      if i==0
        msg2="#{msg2}\n#{dhb[i]} - Today"
      else
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{dhb[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    t2=t+24*60*60*dhb.length
    msg2="#{msg2}\n#{dhb[0]} - #{dhb.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
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
        msg2="#{msg2}\n#{spec[i]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      end
    end
    t2=t+24*60*60*spec.length
    msg2="#{msg2}\n#{spec[0]} - #{spec.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    msg=extend_message(msg,msg2,event,2)
  end
  ghb=['Ursula <:Blue_Tome:467112472394858508><:Icon_Move_Cavalry:443331186530451466> / Clarisse <:Colorless_Bow:443692132616896512><:Icon_Move_Infantry:443331187579289601>',
       'Lloyd <:Red_Blade:443172811830198282><:Icon_Move_Infantry:443331187579289601> / Berkut <:Blue_Blade:467112472768151562><:Icon_Move_Cavalry:443331186530451466>',
       'Michalis <:Green_Blade:467122927230386207><:Icon_Move_Flier:443331186698354698> / Valter <:Blue_Blade:467112472768151562><:Icon_Move_Flier:443331186698354698>',
       'Xander <:Red_Blade:443172811830198282><:Icon_Move_Cavalry:443331186530451466> / Arvis <:Red_Tome:443172811826003968><:Icon_Move_Infantry:443331187579289601>',
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
      msg2="#{msg2}\n#{ghb[i].split(' / ')[0]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
      msg3="#{msg3}\n#{ghb[i].split(' / ')[1]} - #{"#{i} days from now" if i>1}#{"Tomorrow" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
    end
  end
  t2=t+24*60*60*ghb.length
  msg2="#{msg2}\n#{ghb[0].split(' / ')[0]} - #{ghb.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
  msg3="#{msg3}\n#{ghb[0].split(' / ')[1]} - #{ghb.length} days from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t2.wday]})"
  msg=extend_message(msg,msg2,event,2) if [-1,4].include?(idx)
  msg=extend_message(msg,msg3,event,2) if [-1,5].include?(idx) || (idx==4 && safe_to_spam?(event))
  msg=extend_message(msg,"Try the command again with \"GHB2\" if you're looking for the second set of Grand Hero Battles.\nYou may also want to try \"Events\" if you're looking for non-cyclical GHBs.",event,2) if [4].include?(idx) && !safe_to_spam?(event)
  msg=extend_message(msg,"You may also want to try \"Events\" if you're looking for non-cyclical GHBs.",event,2) if [4,5].include?(idx) && safe_to_spam?(event)
  if [-1,6].include?(idx)
    rd=['Cavalry <:Icon_Move_Cavalry:443331186530451466>',
        'Flying <:Icon_Move_Flier:443331186698354698>',
        'Infantry <:Icon_Move_Infantry:443331187579289601>',
        'Armored <:Icon_Move_Armor:443331186316673025>']
    rd=rd.rotate(week_from(date,2)%6)
    rd=rd.rotate(-1) if t.wday==6
    msg2='__**Rival Domains Prefered Movement Type**__'
    for i in 0...rd.length
      if i==0
        t2=t-24*60*60*t.wday+6*24*60*60
        t2+=7*24*60*60 if t.wday==6
        msg2="#{msg2}\n#{rd[i]} - This week until #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year} (Saturday)"
      elsif rd[i]==rd[i-1]
      else
        t2=t-24*60*60*t.wday+7*24*60*60*i-24*60*60
        t2+=7*24*60*60 if t.wday==6
        msg2="#{msg2}\n#{rd[i]} - #{"#{i} weeks from now" if i>1}#{"Next week" if i==1} - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}"
      end
    end
    unless rd[0]==rd[rd.length-1]
      t2=t-24*60*60*t.wday+7*24*60*60*rd.length-24*60*60
      t2+=7*24*60*60 if t.wday==6
      msg2="#{msg2}\n#{rd[0]} - #{rd.length} weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}"
    end
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,7].include?(idx)
    garden=['Earth <:Legendary_Effect_Earth:443331186392170508>',
            'Fire <:Legendary_Effect_Fire:443331186480119808>',
            'Water <:Legendary_Effect_Water:443331186534776832>',
            'Wind <:Legendary_Effect_Wind:443331186467536896>']
    garden=garden.rotate(week_from(date,3)%garden.length)
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
    t2=t-24*60*60*t.wday+7*24*60*60*garden.length
    t2+=7*24*60*60 if t.wday==0
    msg2="#{msg2}\n#{garden[0]} - #{garden.length} weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}"
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
    t2=t-24*60*60*t.wday+7*24*60*60*drill.length-72*60*60
    t2+=7*24*60*60 if t.wday==4
    msg2="#{msg2}\n#{'__' if idx==-1}#{drill[0]} - #{drill.length} weeks from now - #{t2.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t2.month]} #{t2.year}#{'__' if idx==-1}#{"\n" if idx==11}"
    drill=['300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','1<:Orb_Rainbow:471001777622351872>','1<:Orb_Rainbow:471001777622351872>']
    drill=drill.rotate(week_from(date,0)%drill.length)
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
    str2=disp_current_events(bot,event,1)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_events(bot,event,-1)
    msg=extend_message(msg,str2,event,2)
  end
  if [-1,9].include?(idx)
    str2=disp_current_events(bot,event,2)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_events(bot,event,-2)
    msg=extend_message(msg,str2,event,2)
  end
  if [-1].include?(idx)
    msg=extend_message(msg,"__**Legendary Heroes' Appearances**__\n#{sort_legendaries(event,bot,1)}",event,2)
  elsif [10].include?(idx)
    sort_legendaries(event,bot)
  end
  if [-1].include?(idx)
    str2=current_paths(event,bot,1)
    str2="__**Current Ephemura Paths**__\n#{str2}".split("\n")
    msg=extend_message(msg,str2[0],event,2)
    for i in 1...str2.length
      msg=extend_message(msg,str2[i],event,1)
    end
  elsif [16].include?(idx)
    current_paths(event,bot)
  end
  if idx==12
    show_bonus_units(event,'Arena',bot)
  elsif idx==-1
    bonus_load()
    data_load()
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b=@bonus_units.reject{|q| q[1]!='Arena' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      msg=extend_message(msg,"There are no known quantities about Arena.",event,2)
    else
      k=b[0][0].map{|q| q}
      m=k.length%2
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      msg=extend_message(msg,"__**Current Arena Season**__\n*Bonus Units:*\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}\n*Elemental season:* #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}",event,2)
      if b.length>1
        k2=b[1][0].map{|q| q}
        m=k2.length%2
        element=b[1][3][0]
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
        element=b[1][3][1]
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        d=b[1][2][0].split('/').map{|q| q.to_i}
        msg=extend_message(msg,"__**Next Arena Season** (starting #{d[0]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][d[1]]} #{d[2]})__\n*Bonus Units:*#{"\n#{k2[0,k2.length/2+m].join(', ')}\n#{k2[k2.length/2+m,k2.length/2].join(', ')}" unless k2==k || k2.length<=1}#{'(same as current)' if k2==k}#{'(unknown)' if k2.length<=1}\n*Elemental season:* #{moji[0].mention}#{b[1][3][0]}, #{moji2[0].mention}#{b[1][3][1]}",event,2)
        if b.length>2
          msg2="__**Future Elemental Seasons**__"
          for i in 2...[b.length,12].min
            element=b[i][3][0]
            moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
            element=b[i][3][1]
            moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
            d=b[i][2][0].split('/').map{|q| q.to_i}
            msg2="#{msg2}\n*Starting #{d[0]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][d[1]]} #{d[2]}:* #{moji[0].mention}#{b[i][3][0]}, #{moji2[0].mention}#{b[i][3][1]}"
          end
          msg=extend_message(msg,msg2,event,2)
        end
      end
    end
  end
  idx=13 if ['bonus'].include?(type.downcase)
  if idx==13
    show_bonus_units(event,'Tempest',bot)
  elsif idx==-1
    bonus_load()
    data_load()
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      msg=extend_message(msg,"There are no known quantities about Tempest Trials+.",event,2)
    else
      k=b[0][0].map{|q| q}
      if b[0][2][0].split('/').reverse.join('').to_i<tm || b.length>1
        msg2="__**Current Tempest Trials+ Bonus Units**__"
      else
        msg2="__**Future Tempest Trials+ Bonus Units**__"
      end
      m=k.length%2
      msg=extend_message(msg,"#{msg2}\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}",event,2)
      if b.length>1
        k=b[1][0].map{|q| q}
        m=k.length%2
        msg=extend_message(msg,"__**Future Tempest Trials+ Bonus Units**__\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}",event,2)
      end
    end
  end
  idx=14 if ['bonus'].include?(type.downcase)
  if idx==14
    show_bonus_units(event,'Aether',bot)
  elsif idx==-1
    bonus_load()
    data_load()
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      msg=extend_message(msg,"There are no known quantities about Aether Raids.",event,2)
    else
      k=b[0][0].map{|q| q}
      m=k.length%2
      struct="#{b[0][4][0]} (O), #{b[0][4][1]} (D)"
      struct="#{b[0][4][0]} (O/D)" if b[0][4][0]==b[0][4][1]
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      msg=extend_message(msg,"__**Current Aether Raids Season**__\n*Bonus Units:*\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}\n*Bonus Structures:* #{struct}\n*Elemental Season:* #{moji[0].mention unless moji[0].nil?}#{b[0][3][0]}, #{moji2[0].mention unless moji2[0].nil?}#{b[0][3][1]}",event,2)
      if b.length>1
        k2=b[1][0].map{|q| q}
        m=k2.length%2
        d=b[1][2][0].split('/').map{|q| q.to_i}
        struct="#{b[1][4][0]} (O), #{b[1][4][1]} (D)"
        struct="#{b[1][4][0]} (O/D)" if b[1][4][0]==b[1][4][1]
        element=b[1][3][0]
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        element=b[1][3][1]
        moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
        msg=extend_message(msg,"__**Next Aether Raids Season** (starting #{d[0]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][d[1]]} #{d[2]})__\n*Bonus Units:*#{"\n#{k2[0,k2.length/2+m].join(', ')}\n#{k2[k2.length/2+m,k2.length/2].join(', ')}" unless k2==k || k2.length<=1}#{'(same as current)' if k2==k}#{'(unknown)' if k2.length<=1}\n*Bonus Structures:* #{struct}\n*Elemental Season:* #{moji[0].mention unless moji[0].nil?}#{b[1][3][0]}, #{moji2[0].mention unless moji2[0].nil?}#{b[1][3][1]}",event,2)
      end
    end
  end
  if [-1,15].include?(idx)
    matz=["Amelia, Nephenee, Sanaki",
          "Gray, Ike(Brave), Lucina(Brave)",
          "Azura, Elise, Leo",
          "Deirdre, Linde, Tiki(Young)",
          "Cecilia, Delthea, Genny",
          "Julia, Nephenee, Sigurd",
          "Hector, Lyn, Lyn(Brave)",
          "Ike, Ike(Brave), Mist",
          "Julia, Lucina, Lucina(Brave)",
          "Hinoka, Ryoma, Takumi",
          "Genny, Katarina, Minerva",
          "Alm, Delthea, Faye",
          "Amelia, Ayra, Olwen(Bonds)",
          "Lyn(Brave), Ninian, Roy(Brave)",
          "Dorcas, Lute, Mia",
          "Hector, Luke, Tana",
          "Linde, Saber, Sonya",
          "Azura, Deirdre, Eldigan",
          "Ephraim, Jaffar, Karel",
          "Elincia, Innes, Tana"]
    matz=matz.rotate(week_from(date,3)%20)
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
      msg=extend_message(msg,"__**Units available in Book 1 revival banners**__",event,2)
      strpost=false
      tx=t-t.wday*24*60*60
      for i in 0...mmzz.length
        str2="*#{mmzz[i][0]}*#{unit_moji(bot,event,-1,mmzz[i][0])} -"
        if mmzz[i][1]==0
          str2="#{str2} **This week**#{' - Next available' unless mmzz[i][2].nil? || mmzz[i][2]<=0}"
          if mmzz[i][2].nil? || mmzz[i][2]<=0
          else
            t_d=tx+mmzz[i][2]*7*24*60*60
            if mmzz[i][2]==1
              str2="#{str2} next week (#{disp_date(t_d,1)})"
            else
              str2="#{str2} #{mmzz[i][2]} weeks from now (#{disp_date(t_d,1)})"
            end
          end
        else
          t_d=tx+mmzz[i][1]*7*24*60*60
          if mmzz[i][1]==1
            str2="#{str2} Next week (#{disp_date(t_d,1)})"
          else
            str2="#{str2} #{mmzz[i][1]} weeks from now (#{disp_date(t_d,1)})"
          end
        end
        msg=extend_message(msg,str2,event)
      end
    else
      str2=matz[0].split(', ').map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"}.join(', ')
      str3=matz[1].split(', ').map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"}.join(', ')
      msg=extend_message(msg,"__**Units available in Book 1 revival banners**__\n*This week:* #{str2}\n*Next week:* #{str3}",event,2)
    end
  end
  event.respond msg unless [10,12,13,14,16].include?(idx)
end

def skill_data(legal_skills,all_skills,event,mode=0)
  str="**There are #{filler(legal_skills,all_skills,-1)} #{['skills','skill lines','skill trees'][mode]}, including:**"
  if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
    ls2=legal_skills.reject{|q| q[6]!='Weapon' || ['Whelp (All)','Yearling (All)','Adult (All)','Falchion','Missiletainn'].include?(q[1])}
    as2=all_skills.reject{|q| q[6]!='Weapon' || ['Whelp (All)','Yearling (All)','Adult (All)','Falchion','Missiletainn'].include?(q[1])}
    str="#{str}\n<:Gold_Blade:443172811620745236> #{filler(ls2,as2,7,-1,['Sword Users Only','Lance Users Only','Axe Users Only'],-3)} blades   <:Red_Blade:443172811830198282> #{filler(ls2,as2,7,-1,'Sword Users Only')} swords, <:Blue_Blade:467112472768151562> #{filler(ls2,as2,7,-1,'Lance Users Only')} lances, <:Green_Blade:467122927230386207> #{filler(ls2,as2,7,-1,'Axe Users Only')} axes"
    str="#{str}\n<:Gold_Tome:443172812413337620> #{filler(ls2,as2,7,-1,['Red Tome Users Only','Blue Tome Users Only','Green Tome Users Only'],-3)} tomes   <:Red_Tome:443172811826003968> #{filler(ls2,as2,7,-1,'Red Tome Users Only')} red, <:Blue_Tome:467112472394858508> #{filler(ls2,as2,7,-1,'Blue Tome Users Only')} blue, <:Green_Tome:467122927666593822> #{filler(ls2,as2,7,-1,'Green Tome Users Only')} green, <:Colorless_Tome:443692133317345290> #{filler(ls2,as2,7,-1,'Colorless Tome Users Only')} colorless"
    str="#{str}\n<:Gold_Dragon:443172811641454592> #{filler(ls2,as2,7,-1,'Dragons Only')} dragonstones"
    str="#{str}\n<:Gold_Bow:443172812492898314> #{filler(ls2,as2,7,-1,'Bow Users Only')} bows"
    str="#{str}\n<:Gold_Dagger:443172811461230603> #{filler(ls2,as2,7,-1,'Dagger Users Only')} daggers"
    str="#{str}\n<:Gold_Staff:443172811628871720> #{filler(ls2,as2,7,-1,'Staff Users Only')} damaging staves"
    str="#{str}\n<:Gold_Beast:532854442299752469> __#{filler(ls2,as2,7,-1,['Beasts Only, Infantry Only','Beasts Only, Armor Only','Beasts Only, Fliers Only','Beasts Only, Cavalry Only'],-3)} beast weapons__"
    ls2=legal_skills.reject{|q| q[6]!='Assist'}
    as2=all_skills.reject{|q| q[6]!='Assist'}
    str="#{str}\n<:Assist_Rally:454462054619807747> #{filler(ls2,as2,13,-1,'Rally',1)} rally assists"
    str="#{str}\n<:Assist_Move:454462055479508993> #{filler(ls2,as2,13,[-1,-1],['Move','Music'],[1,-1])} movement assists"
    str="#{str}\n<:Assist_Music:454462054959415296> #{filler(ls2,as2,13,-1,'Music',1)} musical assists"
    str="#{str}\n<:Assist_Health:454462054636584981> #{filler(ls2,as2,13,[-1,-1],['Health','Staff'],[1,-1])} health-based assists"
    str="#{str}\n<:Assist_Staff:454451496831025162> #{filler(ls2,as2,13,-1,'Staff',1)} healing staves"
    ls2=legal_skills.reject{|q| q[6]!='Assist' || q[0]>=110000}
    as2=all_skills.reject{|q| q[6]!='Assist' || q[0]>=110000}
    str="#{str}\n__<:Assist_Unknown:454451496482897921> #{ls2.length}#{" (#{as2.length})" unless ls2.length==as2.length} misc. assists__"
    ls2=legal_skills.reject{|q| q[6]!='Special'}
    as2=all_skills.reject{|q| q[6]!='Special'}
    str="#{str}\n<:Special_Offensive:454460020793278475> #{filler(ls2,as2,13,[-1,-1],['Offensive','Defensive'],[1,-1])} offensive specials"
    str="#{str}\n<:Special_Defensive:454460020591951884> #{filler(ls2,as2,13,-1,'Defensive',1)} defensive specials"
    str="#{str}\n<:Special_AoE:454460021665693696> #{filler(ls2,as2,13,-1,'AoE',1)} Area-of-Effect specials"
    str="#{str}\n<:Special_Healer:454451451805040640> #{filler(ls2,as2,13,-1,'Staff',1)} healer specials"
    ls2=legal_skills.reject{|q| q[6]!='Special' || q[0]>=210000}
    as2=all_skills.reject{|q| q[6]!='Special' || q[0]>=210000}
    str="#{str}\n__<:Special_Unknown:454451451603976192> #{ls2.length}#{" (#{as2.length})" unless ls2.length==as2.length} misc. specials__"
  else
    str="#{str}\n<:Skill_Weapon:444078171114045450> #{filler(legal_skills,all_skills,6,-1,'Weapon')} Weapons"
    str="#{str}\n<:Skill_Assist:444078171025965066> #{filler(legal_skills,all_skills,6,-1,'Assist')} Assists"
    str="#{str}\n<:Skill_Special:444078170665254929> #{filler(legal_skills,all_skills,6,-1,'Special')} Specials"
  end
  ls2=legal_skills.reject{|q| q[6]!='Seal' && !q[6].include?('Passive')}
  as2=all_skills.reject{|q| q[6]!='Seal' && !q[6].include?('Passive')}
  str="#{str}\n<:Passive_A:443677024192823327> #{filler(ls2,as2,6,-1,'Passive(A)',1)} A Passives"
  str="#{str}\n<:Passive_B:443677023257493506> #{filler(ls2,as2,6,-1,'Passive(B)',1)} B Passives"
  str="#{str}\n<:Passive_C:443677023555026954> #{filler(ls2,as2,6,-1,'Passive(C)',1)} C Passives"
  if mode==2
    str="#{str}\n<:Passive_S:443677023626330122> #{filler(ls2,as2,6,-1,'Seal')} Passive Seals"
  else
    str="#{str}\n<:Passive_S:443677023626330122> #{filler(ls2,as2,6,-1,'Seal',1)} Passive Seals   #{filler(ls2,as2,6,-1,'Seal')} of which are exclusive to the Seal slot"
  end
  if mode==2
    str="#{str}\n<:Passive_W:443677023706152960> #{filler(ls2,as2,6,-1,'Passive(W)')} Weapon-refine Passives"
  else
    str="#{str}\n<:Passive_W:443677023706152960> #{filler(ls2,as2,6,-1,'Passive(W)',1)} Weapon-refine Passives   #{filler(ls2,as2,6,-1,'Passive(W)')} of which are exclusive to the Weapon-refine slot"
  end
  return str
end

def disp_FGO_based_stats(bot,event,srv=nil)
  hdr="**Availability:** #{['2<:FGO_icon_rarity_sickly:571937157095227402>','3<:FGO_icon_rarity_rust:523903558928826372>','3-4<:FGO_icon_rarity_mono:523903551144198145>','4<:FGO_icon_rarity_mono:523903551144198145>','4-5<:FGO_icon_rarity_gold:523858991571533825>','5<:FGO_icon_rarity_gold:523858991571533825>'][srv[3]]}"
  srv[20]=srv[20].split(', ')
  if srv[20].include?('Event')
    hdr="**Availability:** 3-4<:FGO_icon_rarity_mono:523903551144198145> GHB"
    hdr="**Availability:** 2-3<:FGO_icon_rarity_rust:523903558928826372> GHB" if srv[0]==174
  elsif srv[20].include?('Limited')
    hdr="#{hdr} Seasonal summon"
  elsif srv[20].include?('NonLimited') || srv[20].include?('FPSummon')
    hdr="#{hdr} Summon"
  elsif srv[20].include?('StoryLocked')
    hdr="**Availability:** 4-5<:FGO_icon_rarity_gold:523858991571533825> Tempest Trial"
  elsif srv[20].include?('Starter')
    hdr="**Availability:** Story unit starting at 2<:FGO_icon_rarity_sickly:571937157095227402>"
  elsif srv[20].include?('StoryPromo')
    hdr="**Availability:** Story unit starting at 4<:FGO_icon_rarity_mono:523903551144198145>"
  elsif srv[20].include?('Unavailable')
    hdr="**Availability:** Unobtainable"
  else
    hdr="#{hdr} Summon"
  end
  color='Colorless'
  wpn='Blade'
  wpname='Rod *(Colorless Blade)*'
  moji=[]
  if srv[2]=='Shielder'
  elsif [67,97,111,197,236,249].include?(srv[0])
    wpn='Staff'
    wpname='Healer *(Staff)*'
  elsif [24,26,27,28,50,66,86,89,108,116,144,154,155,161,162,209,210,219,226,229,261,267].include?(srv[0])
    color='Red'
    wpname='Sword *(Red Blade)*'
  elsif [48,52,94,98,106,113,163,206,222,243,251].include?(srv[0])
    color='Blue'
    wpname='Lance *(Blue Blade)*'
  elsif [73,80,115,132,233].include?(srv[0])
    color='Green'
    wpname='Axe *(Green Blade)*'
  elsif [58,81,147,149,151,202,238].include?(srv[0])
    wpn='Beast'
    color='Green' if srv[17][6,1]=='Q'
    color='Blue' if srv[17][6,1]=='A'
    color='Red' if srv[17][6,1]=='B'
    color='Colorless' if srv[13].include?('Divine') || [81].include?(srv[0])
    color='Red' if [151].include?(srv[0])
    wpname="#{color} Beast"
  elsif [23,265].include?(srv[0])
    color='Blue'
    wpn='Dagger'
    wpname='Blue Dagger'
  elsif [65,263].include?(srv[0])
    color='Green'
    wpn='Dagger'
    wpname='Green Dagger'
  elsif [93].include?(srv[0])
    color='Red'
    wpn='Dagger'
    wpname='Red Dagger'
  elsif [65,257,258].include?(srv[0])
    color='Colorless'
    wpn='Bow'
    wpname='Colorless Bow'
  elsif [129,164,184,250].include?(srv[0])
    color='Red'
    wpn='Bow'
    wpname='Red Bow'
  elsif [156].include?(srv[0])
    color='Blue'
    wpn='Bow'
    wpname='Blue Bow'
  elsif [179,239].include?(srv[0])
    color='Green'
    wpn='Bow'
    wpname='Green Bow'
  elsif [104,107,137].include?(srv[0])
    wpn='Dagger'
    wpname='Colorless Dagger'
  elsif [29,77,79,83,96,118,136,139,166,167,168,169,170,173,177,182,189,190,191,194,195,198,199,200,204,215,216,220,224,229,230,237,240,241,242,247,248,253,260].include?(srv[0])
    wpn='Tome'
    color='Green' if srv[17][6,1]=='Q'
    color='Blue' if srv[17][6,1]=='A'
    color='Red' if srv[17][6,1]=='B'
    color='Blue' if [77,118,136,166,182,200,216,229,240,241,242,247,253].include?(srv[0])
    color='Green' if [215,224].include?(srv[0])
    color='Red' if [83,96,167,168,170,177,190,191,195,199,204,220,230,248,260].include?(srv[0])
    color='Colorless' if [169,194,198,237].include?(srv[0])
    color=['Red','Red','Blue','Blue','Green'].sample if [79].include?(srv[0])
    typ='Wind'
    srv[17]="#{srv[0,5]}(X)"
    typ=['Dark','Fire'][srv[0]%2] if srv[17][6,1]=='B' || ([79].include?(srv[0]) && color=='Red')
    typ=['Light','Thunder'][srv[0]%2] if srv[17][6,1]=='A' || ([79].include?(srv[0]) && color=='Blue')
    typ='Thunder' if [77,200].include?(srv[0])
    typ='Light' if [118,136,139,166,173,182,216,229,240,241,242,247,253].include?(srv[0])
    typ='Fire' if [190,191,195,248].include?(srv[0])
    typ='Ice' if [215,224].include?(srv[0])
    typ='Dark' if [83,96,167,168,170,177,195,199,204,220,230,260].include?(srv[0])
    typ='Story' if [169,237].include?(srv[0])
    typ='Riddle' if [194].include?(srv[0])
    typ='Paint' if [198].include?(srv[0])
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{typ}_#{wpn}"}
    wpname="#{typ} Mage *(#{color} Tome)*"
  elsif [56,201,208,211].include?(srv[0])
    wpn='Dragon'
    color='Green' if srv[17][6,1]=='Q'
    color='Blue' if srv[17][6,1]=='A'
    color='Red' if srv[17][6,1]=='B'
    color='Red' if [208].include?(srv[0])
    color='Blue' if [211].include?(srv[0])
    color='Colorless' if srv[13].include?('Divine')
    wpname="#{color} Dragon"
  elsif srv[2]=='Saber'
    color='Red'
    wpname='Sword *(Red Blade)*'
  elsif srv[2]=='Lancer'
    color='Blue'
    wpname='Lance *(Blue Blade)*'
  elsif srv[2]=='Berserker'
    color='Green'
    wpname='Axe *(Green Blade)*'
  elsif srv[2]=='Archer'
    wpn='Bow'
    color='Red' if [11,69].include?(srv[0])
    wpname="#{color} Bow"
  elsif srv[2]=='Caster'
    wpn='Tome'
    color='Green' if srv[17][6,1]=='Q'
    color='Blue' if srv[17][6,1]=='A'
    color='Red' if srv[17][6,1]=='B' || [62,120].include?(srv[0])
    typ='Wind'
    typ=['Dark','Fire'][srv[0]%2] if srv[17][6,1]=='B'
    typ=['Light','Thunder'][srv[0]%2] if srv[17][6,1]=='A'
    typ='Dark' if [62,120,203,225].include?(srv[0])
    typ='Light' if [127].include?(srv[0])
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{typ}_#{wpn}"}
    wpname="#{typ} Mage *(#{color} Tome)*"
  elsif srv[2]=='Assassin'
    wpn='Dagger'
    wpname='Colorless Dagger'
  elsif srv[13].include?('Dragon')
    wpn='Dragon'
    color='Green' if srv[17][6,1]=='Q'
    color='Blue' if srv[17][6,1]=='A'
    color='Red' if srv[17][6,1]=='B'
    wpname="#{color} Dragon"
  elsif srv[13].include?('Wild Beast')
    wpn='Beast'
    color='Green' if srv[17][6,1]=='Q'
    color='Blue' if srv[17][6,1]=='A'
    color='Red' if srv[17][6,1]=='B'
    wpname="#{color} Beast"
  elsif srv[13].include?('Divine')
    wpn='Staff'
    wpname='Healer *(Staff)*'
  elsif srv[13].include?('Not Weak to Enuma Elish') && srv[0]%2==0
    wpn='Staff'
    wpname='Healer *(Staff)*'
  elsif srv[13].include?('Female') && srv[0]%5==0
    wpn='Staff'
    wpname='Healer *(Staff)*'
  elsif ['Rider','Ruler'].include?(srv[2]) && srv[0]%7>0
    color='Green' if srv[17][6,1]=='Q'
    color='Blue' if srv[17][6,1]=='A'
    color='Red' if srv[17][6,1]=='B'
    wpname='Axe *(Green Blade)*' if srv[17][6,1]=='Q'
    wpname='Lance *(Blue Blade)*' if srv[17][6,1]=='A'
    wpname='Sword *(Red Blade)*' if srv[17][6,1]=='B'
  else
    color='Green' if srv[17][6,1]=='Q'
    color='Blue' if srv[17][6,1]=='A'
    color='Red' if srv[17][6,1]=='B'
    wpn='Bow'
    wpn='Dagger' if srv[0]%2==0
    wpname="#{color} #{wpn}"
  end
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{color}_#{wpn}"} unless wpn=='Tome' && color != 'Colorless'
  hdr="#{hdr}\n**Weapon:** #{moji[0].mention unless moji.length<=0} #{wpname}"
  mov='Infantry'
  if [142,23,29,60,62,65,94,144,172,214,225,233,234,255,257,267].include?(srv[0])
    mov='Flier'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Flier:443331186698354698> Flier"
  elsif [119,78,10,28,108,114,206,207,226,227,252].include?(srv[0])
    mov='Cavalry'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Cavalry:443331186530451466> Cavalry"
  elsif [2,5,24,25,59,64,90,175,192].include?(srv[0])
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Infantry:443331187579289601> Infantry"
  elsif [76,140,149,154,164,187,188,190,191,204,205,251,256].include?(srv[0])
    mov='Armor'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Armor:443331186316673025> Armor"
  elsif has_any?(srv[13],['Greek','Roman','Soverign']) || srv[2]=='Ruler'
    mov='Armor'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Armor:443331186316673025> Armor"
  elsif srv[2]=='Rider'
    mov='Cavalry'
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Cavalry:443331186530451466> Cavalry"
  else
    hdr="#{hdr}\n**Movement:** <:Icon_Move_Infantry:443331187579289601> Infantry"
  end
  basesttz=[[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
  actusttz=[[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
  basesttz[0][0]=(srv[6][0]-1200)*11/10200+14
  basesttz[0][1]=(srv[7][0]-900)*8/1400+4
  basesttz[1][0]=(srv[6][2]-9000)*30/11000+30
  basesttz[1][1]=(srv[7][2]-7000)*21/8000+20
  basesttz[1][2]=((srv[10][1]-4)*25/22+16).to_i
  basesttz[1][3]=((100-srv[11])*29/100+13).to_i
  basesttz[1][4]=((srv[10][0]-9)*29/199+13).to_i+srv[8][1]-1
  basesttz[2][0]=basesttz[1][0]-basesttz[0][0]
  basesttz[2][1]=basesttz[1][1]-basesttz[0][1]
  basesttz[2][2]=1+srv[9][0]
  basesttz[2][3]=1+srv[9][2]+srv[9][4]/2
  basesttz[2][4]=1+srv[9][1]
  f=srv[17][0,5]
  if f.include?('QQQ')
    basesttz[1][2]*=3
    basesttz[1][2]/=2
    basesttz[2][2]+=2
  elsif f.include?('QQ')
    basesttz[1][2]*=5
    basesttz[1][2]/=4
    basesttz[2][2]+=1
  end
  if f.include?('AA')
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
  if srv[2]=='Assassin' && srv[0]!=75
    basesttz[1][2]*=2
    basesttz[1][2]/=3
  end
  if srv[0]==12
    basesttz[1][2]*=7
    basesttz[1][2]/=3
    basesttz[1][1]*=4
    basesttz[1][1]/=3
    basesttz[1][3]*=4
    basesttz[1][3]/=5
    basesttz[1][4]*=4
    basesttz[1][4]/=5
  elsif color=='Colorless'
    if srv[17][6,1]=='Q'
      basesttz[1][2]*=5
      basesttz[1][2]/=4
      basesttz[2][2]+=1
    elsif srv[17][6,1]=='A'
      basesttz[1][4]*=5
      basesttz[1][4]/=4
      basesttz[2][4]+=1
    elsif srv[17][6,1]=='B'
      basesttz[1][1]*=5
      basesttz[1][1]/=4
      basesttz[2][1]+=1
    end
  end
  m=@mods.map{|q| q[5]}
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
  if srv[0]>=151 || srv[0]==1.1
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
  elsif srv[0]>=60 || srv[0]==1.2
    l1_total+=1
    l1_total-=1 if ['Cavalry','Flier'].include?(mov)
    l1_total-=1 if 'Flier'!=mov
    gp_total+=2
    gp_total-=1 if ['Cavalry'].include?(mov)
    gp_total-=1 if ['Tome', 'Bow', 'Dagger', 'Staff'].include?(wpn) && 'Armor'!=mov
  end
  actusttz[0]=basesttz[0].map{|q| q}
  order=[[0,4,3,2,1],[1,2,3,4,0],[2,4,1,3,0],[3,1,4,2,0],[4,3,2,1,0]][srv[0]%5]
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
  statstr="\u200B\u00A0<:HP_S:514712247503945739>\u00A0\u200B\u00A0\u200B\u00A0#{atk}\u00A0\u200B\u00A0\u200B\u00A0<:SpeedS:514712247625580555>\u00A0\u200B\u00A0\u200B\u00A0<:DefenseS:514712247461871616>\u00A0\u200B\u00A0\u200B\u00A0<:ResistanceS:514712247574986752>\u00A0\u200B\u00A0\u200B\u00A0"
  str="#{str}\n\n__**Direct stat translation**__\n#{statstr}#{totals[0]}\u00A0BST\u2084\u2080\n```#{basesttz[0]}\n#{basesttz[1]}```"
  str="#{str}\n__**Accounting for FEH legality**__\n#{statstr}#{totals[1]}\u00A0BST\u2084\u2080\n```#{actusttz[0]}\n#{actusttz[1]}```"
  xcolor=0xE22141 if color=='Red'
  xcolor=0x2764DE if color=='Blue'
  xcolor=0x09AA24 if color=='Green'
  xcolor=0x64757D if color=='Colorless'
  art=rand(4)+1
  dispnum="#{'0' if srv[0]<100}#{'0' if srv[0]<10}#{srv[0].to_i}#{art}"
  dispnum="#{'0' if srv[0]<100}#{'0' if srv[0]<10}#{srv[0].to_i}2" if srv[0]==74 && event.user.id==167657750971547648
  dispnum="0011" if srv[0]<2
  dispnum="0014" if srv[0]<2 && art==4
  unless art<=1
    m=false
    IO.copy_stream(open("http://fate-go.cirnopedia.org/icons/servant/servant_#{dispnum}.png"), "#{@location}devkit/FEHTemp#{@shardizard}.png") rescue m=true
    art=1 if File.size("#{@location}devkit/FEHTemp#{@shardizard}.png")<=10 || m
  end
  dispnum="#{'0' if srv[0]<100}#{'0' if srv[0]<10}#{srv[0].to_i}#{art}"
  dispnum="#{'0' if srv[0]<100}#{'0' if srv[0]<10}#{srv[0].to_i}2" if srv[0]==74 && event.user.id==167657750971547648
  dispnum="0011" if srv[0]<2
  dispnum="0014" if srv[0]<2 && art==4
  xpic="http://fate-go.cirnopedia.org/icons/servant/servant_#{dispnum}.png"
  create_embed(event,["__**#{srv[1]}** [FGO Unit-##{srv[0]}]__",hdr],str,xcolor,nil,xpic)
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
  str="#{str}\n- In *Units*'s \"Rarities\" column:\n> `5p` is for normal summonable units (\"pool\")\n> `5s` is used for seasonals and legendaries\n> `3g4g4g` is used for GHBs\n> `4t5t` is used for TT units\n> There are all-caps duo markers, but they're used to mark Launch units + Book I 5\* units and are thus not relevant in Book IV."
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
  str="#{str}\n\n6.) Type the number 2 to select reloading data based on GitHub files."
  str="#{str}\n\n7.) Double-check that the edited data works.  It is important to remember that I will not be there to guide you to wherever any problems might be based on error codes."
  str="#{str}\n\n8.) Add any relevant aliases to the new data."
  create_embed(event,'',str,0xD49F61)
  return nil
end

def support_order(x)
  return 4 if x=='S'
  return 3 if x=='A'
  return 2 if x=='B'
  return 1 if x=='C'
  return 0
end

def flower_list(event,bot,args=[])
  movement=[]
  completex=false
  for i in 0...args.length
    movement.push('Flier') if ['flier','flying','flyer','fly','pegasus','wyvern','fliers','flyers','wyverns','pegasi'].include?(args[i].downcase)
    movement.push('Cavalry') if ['cavalry','horse','pony','horsie','horses','horsies','ponies','cavalier','cavaliers','cav','cavs'].include?(args[i].downcase)
    movement.push('Infantry') if ['infantry','foot','feet'].include?(args[i].downcase)
    movement.push('Armor') if ['armor','armour','armors','armours','armored','armoured'].include?(args[i].downcase)
    completex=true if ['complete','completed','finished','finish','done'].include?(args[i].downcase)
  end
  if movement.length<=0 && !completex && !safe_to_spam?(event)
    event.respond "<:Dragonflower_Infantry:541170819980722176><:Dragonflower_Orange:552648156790390796><:Dragonflower_Cavalry:541170819955556352><:Dragonflower_Armor:541170820001824778><:Dragonflower_Cyan:552648156202926097><:Dragonflower_Flier:541170820089774091><:Dragonflower_Purple:552648232673607701><:Dragonflower_Pink:552648232510160897>\nI won't post a list of all your units here, so instead, look at all the pretty flowers!\nhttps://www.getrandomthings.com/list-flowers.php"
    return nil
  end
  load_devunits()
  data_load()
  untz=@units.map{|q| q}
  m=@dev_units.reject{|q| untz.find_index{|q2| q2[0]==q[0]}.nil? || !untz[untz.find_index{|q2| q2[0]==q[0]}][13][0].nil?}.map{|q| [q[0],q[1],q[2],q[6],q[5]]}
  m=m.sort{|b,a| ((support_order(a[4]) <=> support_order(b[4]))) == 0? ((a[3] <=> b[3]) == 0 ? (b[0] <=> a[0]) : (a[3] <=> b[3])) : (support_order(a[4]) <=> support_order(b[4]))}
  f=[['<:Dragonflower_Infantry:541170819980722176>Infantry<:Icon_Move_Infantry:443331187579289601>',[]],
     ['<:Dragonflower_Cavalry:541170819955556352>Cavalry<:Icon_Move_Cavalry:443331186530451466>',[]],
     ['<:Dragonflower_Flier:541170820089774091>Fliers<:Icon_Move_Flier:443331186698354698>',[]],
     ['<:Dragonflower_Armor:541170820001824778>Armored<:Icon_Move_Armor:443331186316673025>',[]],
     ['Completed Projects',[]]]
  for i in 0...m.length
    x=untz.find_index{|q| q[0]==m[i][0]}
    unless x.nil?
      x=untz[x]
      m[i][4]='-' if m[i][4].include?('(')
      xx="#{m[i][1].to_i}#{@rarity_stars[m[i][1].to_i-1]}#{"+#{m[i][2]}" if m[i][2].to_i>0} **#{m[i][0]}**#{" df+#{m[i][3]}" if m[i][3].to_i>0}"
      xx="#{m[i][1].to_i}<:Icon_Rarity_S:448266418035621888>#{"+#{m[i][2]}" if m[i][2].to_i>0} **#{m[i][0]}**#{" df+#{m[i][3]}" if m[i][3].to_i>0}" if m[i][4]!='-'
      xx="**5<:Icon_Rarity_5p10:448272715099406336> #{m[i][0]}**#{" df+#{m[i][3]}" if m[i][3].to_i>0}" if m[i][1].to_i==5 && m[i][2].to_i==10
      xx="**5<:Icon_Rarity_5p10:448272715099406336> #{m[i][0]}**#{" df+#{m[i][3]}" if m[i][3].to_i>0}" if m[i][1].to_i==5 && m[i][2].to_i==10 && m[i][4]!='-'
      complete=false
      if x[3]=='Infantry' && x[9][0].include?('PF')
        complete=true if m[i][3]>=10
      else
        complete=true if m[i][3]>=5 
      end
      if movement.length>0 && x[3]!=movement[0]
      elsif complete && !safe_to_spam?(event) && !completex
      elsif complete
        xx="#{m[i][1].to_i}#{@rarity_stars[m[i][1].to_i-1]}#{"+#{m[i][2]}" if m[i][2].to_i>0} **#{m[i][0]}**"
        xx="#{m[i][1].to_i}<:Icon_Rarity_S:448266418035621888>#{"+#{m[i][2]}" if m[i][2].to_i>0} **#{m[i][0]}**" if m[i][4]!='-'
        xx="**5<:Icon_Rarity_5p10:448272715099406336> #{m[i][0]}**" if m[i][1].to_i==5 && m[i][2].to_i==10
        xx="**5<:Icon_Rarity_Sp10:448272715653054485> #{m[i][0]}**" if m[i][1].to_i==5 && m[i][2].to_i==10 && m[i][4]!='-'
        f[4][1].push(xx)
      elsif completex
      else
        f[0][1].push(xx) if x[3]=='Infantry'
        f[1][1].push(xx) if x[3]=='Cavalry'
        f[2][1].push(xx) if x[3]=='Flier'
        f[3][1].push(xx) if x[3]=='Armor'
      end
    end
  end
  f=f.reject{|q| q[1].length<=0}
  if f[0][1].length>16 && !safe_to_spam?(event)
    if f[0][1].reject{|q| !q.include?('** df+')}.length>0
      f[0][1]=f[0][1].reject{|q| !q.include?('** df+') && !q.include?('Alm') && !q.include?('Sakura')}
    elsif f[0][1].reject{|q| !q.include?('p10:')}.length>0
      f[0][1]=f[0][1].reject{|q| !q.include?('p10') && !q.include?('Alm') && !q.include?('Sakura')}
    elsif f[0][1].reject{|q| !q.include?('>+')}.length>0
      f[0][1]=f[0][1].reject{|q| !q.include?('>+') && !q.include?('Alm') && !q.include?('Sakura')}
    end
  end
  if f.length<=0
    event.respond "Empty list"
  elsif f.map{|q| "#{q[0]}\n#{q[1].join("\n")}"}.join("\n\n").length>1800
    if f.reject{|q| q[0].include?('Infantry')}.map{|q| "#{q[0]}\n#{q[1].join("\n")}"}.join("\n\n").length>1800
      for i in 0...f.length
        create_embed(event,f[i][0],'',0x008b8b,nil,nil,triple_finish(f[i][1]))
      end
    else
      create_embed(event,f[0][0],'',0x008b8b,nil,nil,triple_finish(f[0][1]))
      create_embed(event,'','',0x008b8b,nil,nil,f.reject{|q| q[0].include?('Infantry')}.map{|q| [q[0],q[1].join("\n")]})
    end
  else
    title=''
    if movement.length>0 && f.length>1
      title="#{f[0][0]}"
      f[0][0]='Incomplete Projects'
    end
    create_embed(event,title,'',0x008b8b,nil,nil,f.map{|q| [q[0],q[1].join("\n")]})
  end
end

def grail_list(event,bot,args=[],subcategory=nil)
  movement=[]
  completex=false
  for i in 0...args.length
    movement.push('GHB') if ['ghb','grandherobattle','battle'].include?(args[i].downcase)
    movement.push('Tempest') if ['tempest','tempesttrials','tempestrials','trials','trial'].include?(args[i].downcase)
    movement.push('Extra') if ['extra','ex'].include?(args[i].downcase)
    completex=true if ['complete','completed','finished','finish','done'].include?(args[i].downcase)
  end
  movement=[subcategory] unless subcategory.nil? || subcategory.length<=0
  load_devunits()
  data_load()
  untz=@units.map{|q| q}
  m=@dev_units.reject{|q| untz.find_index{|q2| q2[0]==q[0]}.nil? || !untz[untz.find_index{|q2| q2[0]==q[0]}][13][0].nil?}.map{|q| [q[0],q[1],q[2],q[6],q[5]]}
  m=m.sort{|b,a| ((a[2] <=> b[2])) == 0? ((a[3] <=> b[3]) == 0 ? (b[0] <=> a[0]) : (a[3] <=> b[3])) : (a[2] <=> b[2])}
  ftr=nil
  f=[['Grand Hero Battles',[]],
     ['Tempest Trials',[]],
     ['Other Grail units',[]],
     ['Completed Projects',[]]]
  for i in 0...m.length
    x=untz.find_index{|q| q[0]==m[i][0]}
    unless x.nil?
      x=untz[x]
      xx="#{m[i][1].to_i}#{@rarity_stars[m[i][1].to_i-1]}#{"+#{m[i][2]}" if m[i][2].to_i>0} **#{m[i][0]}**"
      xx="#{m[i][1].to_i}<:Icon_Rarity_S:448266418035621888>#{"+#{m[i][2]}" if m[i][2].to_i>0} **#{m[i][0]}**" if m[i][4]!='-'
      xx="**5<:Icon_Rarity_5p10:448272715099406336> #{m[i][0]}**" if m[i][1].to_i==5 && m[i][2].to_i==10
      xx="**5<:Icon_Rarity_5p10:448272715099406336> #{m[i][0]}**" if m[i][1].to_i==5 && m[i][2].to_i==10 && m[i][4]!='-'
      complete=false
      complete=true if m[i][1].to_i==5 && m[i][2].to_i==10
      ftr2=nil
      unless x[9][0].include?('r') || (m[i][1].to_i==5 && m[i][2].to_i==10)
        xx="#{m[i][1].to_i}#{@rarity_stars[m[i][1].to_i-1]}#{"+#{m[i][2]}" if m[i][2].to_i>0} #{m[i][0]}"
        xx="#{m[i][1].to_i}<:Icon_Rarity_S:448266418035621888>#{"+#{m[i][2]}" if m[i][2].to_i>0} #{m[i][0]}" if m[i][4]!='-'
        xx="**5<:Icon_Rarity_5p10:448272715099406336>** #{m[i][0]}" if m[i][1].to_i==5 && m[i][2].to_i==10
        xx="**5<:Icon_Rarity_5p10:448272715099406336>** #{m[i][0]}" if m[i][1].to_i==5 && m[i][2].to_i==10 && m[i][4]!='-'
        xx="~~#{xx}~~"
        ftr2='Crossed out units cannot be summoned through grails at this time'
      end
      if complete && !safe_to_spam?(event) && !completex
      elsif !x[9][0].include?('g') && !x[9][0].include?('t') && !x[9][0].include?('r')
      elsif x[9][0].include?('g') && movement.length>0 && movement[0]!='GHB'
      elsif x[9][0].include?('t') && movement.length>0 && movement[0]!='Tempest'
      elsif complete
        f[3][1].push(xx)
        ftr="#{ftr2}" unless ftr2.nil?
      elsif x[9][0].include?('g')
        f[0][1].push(xx)
        ftr="#{ftr2}" unless ftr2.nil?
      elsif x[9][0].include?('t')
        f[1][1].push(xx)
        ftr="#{ftr2}" unless ftr2.nil?
      else
        f[2][1].push(xx) unless movement.length>0 && movement[0]!='Extra'
        ftr="#{ftr2}" unless ftr2.nil?
      end
    end
  end
  if f[0][1].length>16 && !safe_to_spam?(event)
    if f[0][1].reject{|q| !q.include?('>+')}.length>0
      f[0][1]=f[0][1].reject{|q| !q.include?('>+') && !q.include?('Alm') && !q.include?('Sakura')}
    end
  end
  if f[1][1].length>16 && !safe_to_spam?(event)
    if f[1][1].reject{|q| !q.include?('>+')}.length>0
      f[1][1]=f[1][1].reject{|q| !q.include?('>+') && !q.include?('Alm') && !q.include?('Sakura')}
    end
  end
  if f[2][1].length>16 && !safe_to_spam?(event)
    if f[2][1].reject{|q| !q.include?('>+')}.length>0
      f[2][1]=f[2][1].reject{|q| !q.include?('>+') && !q.include?('Alm') && !q.include?('Sakura')}
    end
  end
  f=f.reject{|q| q[1].length<=0}
  if f.length<=0
    event.respond "Empty list"
  elsif f.map{|q| "#{q[0]}\n#{q[1].join("\n")}"}.join("\n\n").length>1800
    for i in 0...f.length
      m=nil
      m=ftr if i==f.length-1
      create_embed(event,f[i][0],'',0x008b8b,ftr,nil,triple_finish(f[i][1]))
    end
  else
    title=''
    if movement.length>0 && f.length>1
      title="#{f[0][0]}"
      f[0][0]='Incomplete Projects'
    end
    create_embed(event,title,'',0x008b8b,ftr,nil,f.map{|q| [q[0],q[1].join("\n")]})
  end
end

def snagstats(event,bot,f=nil,f2=nil)
  nicknames_load()
  groups_load()
  g=get_markers(event)
  data_load()
  metadata_load()
  f='' if f.nil?
  f2='' if f2.nil?
  unless @shardizard==-1
    bot.servers.values(&:members)
    k=bot.servers.length
    k+=5 if @shardizard==0
    k=1 if @shardizard==4 # Debug shard shares the six emote servers with the main account
    @server_data[0][@shardizard]=k
    @server_data[1][@shardizard]=bot.users.size
    @server_data[0][4]=1
    metadata_save()
  end
  all_units=@units.reject{|q| !has_any?(g, q[13][0])}
  all_units=@units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
  legal_units=@units.reject{|q| !q[13][0].nil?}
  all_skills=@skills.reject{|q| !has_any?(g, q[15])}
  all_skills=@skills.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
  legal_skills=@skills.reject{|q| !q[15].nil?}
  b=[]
  File.open('C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb').each_line do |line|
    l=line.gsub(' ','').gsub("\n",'')
    b.push(l) unless l.length<=0
  end
  if ['servers','server','members','member','shard','shards','user','users'].include?(f.downcase)
    str="**I am in #{longFormattedNumber(@server_data[0].inject(0){|sum,x| sum + x })} servers.**"
    for i in 0...@shards
      m=i
      m=i+1 if i>3
      srvcnt=@server_data[0][m]
      srvcnt-=3 if m==0 && @shardizard==-1
      str=extend_message(str,"The #{shard_data(0,true)[i]} Shard is in #{longFormattedNumber(srvcnt)} server#{"s" if srvcnt !=1}.",event)
    end
    if @shardizard==-1
      bot.servers.values(&:members)
      str=extend_message(str,"The Smol Shard is in 5 servers.",event)
    end
    str=extend_message(str,"The #{shard_data(0)[4]} Shard is in 1 server.",event,2) if event.user.id==167657750971547648
    event.respond str
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
      m.push('community-voted') if @aliases.reject{|q| q[0]!='Unit' || q[2]!=untz[i][8] || !q[3].nil?}.map{|q| q[1]}.include?("#{untz[i][0].split('(')[0]}CYL")
      m.push('Legendary/Mythic') if !untz[i][2].nil? && !untz[i][2][0].nil? && untz[i][2][0].length>1 && !m.include?('default')
      m.push('Fallen') if untz[i][0].include?('(Fallen)')
      m.push('out-of-left-field') if m.length<=0
      n=''
      unless untz[i][0]==untz[i][12] || untz[i][12][untz[i][12].length-1,1]=='*'
        k=untz.reject{|q| q[12].gsub('*','').split(', ')[0]!=untz[i][12].gsub('*','').split(', ')[0] || q[0]==untz[i][0] || !(q[0]==q[12].split(', ')[0] || q[12].split(', ')[0].include?('*'))}
        n="x" if k.length<=0
        k=untz.reject{|q| q[9][0]=='-' || q[12].gsub('*','').split(', ')[0]!=untz[i][12].gsub('*','').split(', ')[0] || q[0]==untz[i][0] || !(q[0]==q[12].split(', ')[0] || q[12].split(', ')[0].include?('*'))}
        n="#{n}y" if k.length<=0
      end
      untz2.push([untz[i][0],untz[i][12].gsub('*','').split(', '),m,n,untz[i][13],untz[i][9][0]])
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
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'Legendary/Mythic',1)} Legendary/Mythic alts"
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'Fallen',1)} Fallen alts"
    event << "There are #{filler(legal_units.uniq,all_units.uniq,2,-1,'out-of-left-field',1)} out-of-left-field alts *(Eirika, Reinhardt, Hinoka, etc.)*"
    k=[]
    k2=[]
    for i in 0...all_units.length
      x="#{'~~' unless all_units[i][4][0].nil? || all_units[i][4][0].length.zero?}"
      k.push("#{x}#{all_units[i][1][0]}#{x}") if !all_units[i][2].include?('faceted') && all_units[i][3].include?('x')
      k2.push("#{x}#{all_units[i][1][0]}#{x}") if !all_units[i][2].include?('faceted') && all_units[i][3].include?('y')
    end
    k.uniq!
    k2=k2.reject{|q| k.include?(q)}.uniq
    event << ''
    if k.length>0 || k2.length>0
      event << "The following characters have alts but not default units in FEH: #{list_lift(k.map{|q| "*#{q}*"},"and")}." if k.length>0
      event << "The following characters have playable alts but not playable default units in FEH: #{list_lift(k2.map{|q| "*#{q}*"},"and")}." if k2.length>0
      event << ''
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
  elsif ['hero','heroes','heros','units','characters','unit','character','charas','chara','chars','char'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',1)
    all_units=@units.reject{|q| !has_any?(g, q[13][0])}
    all_units=@units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    legal_units=@units.reject{|q| !q[13][0].nil?}
    str="**There are #{filler(legal_units,all_units,-1)} units, including:**"
    unless f2.nil?
      k=find_in_units(bot,event,13,false,false,[f2])
      all_units=all_units.reject{|q| !k[1].include?(q)}.uniq
      legal_units=legal_units.reject{|q| !k[1].include?(q)}.uniq
      str="#{k[0].join("\n")}\n\n**With these filters, there are #{filler(legal_units,all_units,-1)} units, including:**"
    end
    m=filler(legal_units,all_units,9,0,'p',1)
    str2=''
    str2="#{m} summonable unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,9,0,'g',1)
    str2="#{str2}\n#{m} Grand Hero Battle reward unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,9,0,'t',1)
    str2="#{str2}\n#{m} Tempest Trials reward unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,[9,2],[0,0],['s',2],[1,-2])
    str2="#{str2}\n#{m} seasonal unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,2,0,['Fire','Earth','Water','Wind','Astra','Anima','Light','Dark'],-3)
    str2="#{str2}\n#{m} legendary/mythic unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,[2,2],[0,3],['Duo','Duo'],[0,0],'&&')
    str2="#{str2}\n#{m} Duo unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,9,0,'-',1)
    str2="#{str2}\n#{m} unobtainable unit#{'s' unless m=='1'}" unless m=='0'
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    str2=''
    m=filler(legal_units,all_units,1,0,'Red')
    str2="<:Red_Unknown:443172811486396417> #{m} red unit#{'s' unless m=='1'},   <:Orb_Red:455053002256941056> with #{filler(legal_units,all_units,[1,9],[0,0],['Red','p'],[0,1])} in the main summon pool" unless m=='0'
    m=filler(legal_units,all_units,1,0,'Blue')
    str2="#{str2}\n<:Blue_Unknown:467112473980305418> #{m} blue unit#{'s' unless m=='1'},   <:Orb_Blue:455053001971859477> with #{filler(legal_units,all_units,[1,9],[0,0],['Blue','p'],[0,1])} in the main summon pool" unless m=='0'
    m=filler(legal_units,all_units,1,0,'Green')
    str2="#{str2}\n<:Green_Unknown:467122926785921044> #{m} green unit#{'s' unless m=='1'},   <:Orb_Green:455053002311467048> with #{filler(legal_units,all_units,[1,9],[0,0],['Green','p'],[0,1])} in the main summon pool" unless m=='0'
    m=filler(legal_units,all_units,1,0,'Colorless')
    str2="#{str2}\n<:Colorless_Unknown:443692132738531328> #{m} colorless unit#{'s' unless m=='1'},   <:Orb_Colorless:455053002152083457> with #{filler(legal_units,all_units,[1,9],[0,0],['Colorless','p'],[0,1])} in the main summon pool" unless m=='0'
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    str2=''
    m=filler(legal_units,all_units,1,1,'Blade')
    str2="<:Gold_Blade:443172811620745236> #{m} blade user#{'s' unless m=='1'}:   <:Red_Blade:443172811830198282> #{filler(legal_units,all_units,1,-1,['Red','Blade'])} swords, <:Blue_Blade:467112472768151562> #{filler(legal_units,all_units,1,-1,['Blue','Blade'])} lances, <:Green_Blade:467122927230386207> #{filler(legal_units,all_units,1,-1,['Green','Blade'])} axes" unless m=='0'
    m=filler(legal_units,all_units,1,1,'Tome')
    str2="#{str2}\n<:Gold_Tome:443172812413337620> #{m} tome user#{'s' unless m=='1'}:   <:Red_Tome:443172811826003968> #{filler(legal_units,all_units,1,-1,[['Red','Tome','Fire'],['Red','Tome','Dark']],-3)} red, <:Blue_Tome:467112472394858508> #{filler(legal_units,all_units,1,-1,[['Blue','Tome','Thunder'],['Blue','Tome','Light']],-3)} blue, <:Green_Tome:467122927666593822> #{filler(legal_units,all_units,1,-1,[['Green','Tome','Wind'],['Green','Tome','Wind']],-3)} green, <:Colorless_Tome:443692133317345290> #{filler(legal_units,all_units,1,-1,[['Colorless','Tome','Stone'],['Colorless','Tome','Stone']],-3)} colorless" unless m=='0'
    m=filler(legal_units,all_units,1,1,'Dragon')
    str2="#{str2}\n<:Gold_Dragon:443172811641454592> #{m} dragon unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,1,1,'Bow')
    str2="#{str2}\n<:Gold_Bow:443172812492898314> #{m} bow user#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,1,1,'Dagger')
    str2="#{str2}\n<:Gold_Dagger:443172811461230603> #{m} dagger user#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,1,1,'Healer')
    str2="#{str2}\n<:Gold_Staff:443172811628871720> #{m} staff user#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,1,1,'Beast')
    str2="#{str2}\n<:Gold_Beast:532854442299752469> #{m} beast unit#{'s' unless m=='1'}" unless m=='0'
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    str2=''
    m=filler(legal_units,all_units,3,-1,'Infantry')
    str2="<:Icon_Move_Infantry:443331187579289601> #{m} infantry unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,3,-1,'Cavalry')
    str2="#{str2}\n<:Icon_Move_Cavalry:443331186530451466> #{m} cavalry unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,3,-1,'Flier')
    str2="#{str2}\n<:Icon_Move_Flier:443331186698354698> #{m} flying unit#{'s' unless m=='1'}" unless m=='0'
    m=filler(legal_units,all_units,3,-1,'Armor')
    str2="#{str2}\n<:Icon_Move_Armor:443331186316673025> #{m} armored unit#{'s' unless m=='1'}" unless m=='0'
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
      str2=''
      m=filler(legal_units,all_units,11,-1,['FE1','*FE1'],4)
      str2="#{m} unit#{'s' unless m=='1'} from *FE1*,    #{filler(legal_units,all_units,11,0,'FE1',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE2','*FE2'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE2*,    #{filler(legal_units,all_units,11,0,'FE2',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE3','*FE3'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE3*,    #{filler(legal_units,all_units,11,0,'FE3',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE4','*FE4'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE4*,    #{filler(legal_units,all_units,11,0,'FE4',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE5','*FE5'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE5*,    #{filler(legal_units,all_units,11,0,'FE5',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE6','*FE6'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE6*,    #{filler(legal_units,all_units,11,0,'FE6',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE7','*FE7'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE7*,    #{filler(legal_units,all_units,11,0,'FE7',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE8','*FE8'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE8*,    #{filler(legal_units,all_units,11,0,'FE8',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE9','*FE9'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE9*,    #{filler(legal_units,all_units,11,0,'FE9',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE10','*FE10'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE10*,    #{filler(legal_units,all_units,11,0,'FE10',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE11','*FE11'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE11*,    #{filler(legal_units,all_units,11,0,'FE11',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE12','*FE12'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE12*,    #{filler(legal_units,all_units,11,0,'FE12',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE13','*FE13'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE13*,    #{filler(legal_units,all_units,11,0,'FE13',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE14','FE14B','FE14C','FE14R','FE14g','*FE14','*FE14B','*FE14C','*FE14R','*FE14g'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE14*,  #{filler(legal_units,all_units,11,0,['FE14','FE14B','FE14C','FE14R','FE14g'],100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE15','*FE15'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE15*,    #{filler(legal_units,all_units,11,0,'FE15',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FE16','*FE16'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FE16*,    #{filler(legal_units,all_units,11,0,'FE16',100)} of which are credited" unless m=='0'
      m=filler(legal_units,all_units,11,-1,['FEH','*FEH'],4)
      str2="#{str2}\n#{m} unit#{'s' unless m=='1'} from *FEH* itself,    #{filler(legal_units,all_units,11,0,'FEH',100)} of which are credited" unless m=='0'
      str2=str2[1,str2.length-1] if str2[0,1]=="\n"
      str2=str2[2,str2.length-2] if str2[0,2]=="\n"
      str=extend_message(str,str2,event,2)
    end
    event.respond str
    return nil
  elsif ['skill','skills','weapon','weapons','assist','assists','special','specials','passive','passives'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3)
    data_load()
    all_skills_1=@skills.reject{|q| !has_any?(g, q[15])}
    all_skills_1=@skills.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    legal_skills_1=@skills.reject{|q| !q[15].nil?}
    msg=skill_data(legal_skills,all_skills,event,0)
    legal_skills=legal_skills_1.reject{|q| !q[15].nil? || q[1].include?('Initiate Seal ') || q[1].include?('Squad Ace ')}
    legal_skills=collapse_skill_list(legal_skills,6)
    all_skills=all_skills_1.reject{|q| !has_any?(g, q[15]) || q[1].include?('Initiate Seal ') || q[1].include?('Squad Ace ')}
    all_skills=all_skills_1.reject{|q| q[1].include?('Initiate Seal ') || q[1].include?('Squad Ace ')} if event.server.nil? && event.user.id==167657750971547648
    all_skills=collapse_skill_list(all_skills,6)
    msg=extend_message(msg,skill_data(legal_skills,all_skills,event,1),event,2)
    event.respond msg
    return nil
  elsif ['structure','structures','structs','struct'].include?(f.downcase)
    m=@structures.reject{|q| q[2]=='example'}.map{|q| "#{q[0]} #{q[1]} / #{q[2] unless q[2].include?('Offensive') || q[2].include?('Defensive')}"}.uniq
    str="**There are #{longFormattedNumber(m.length)} structure levels, including:**"
    str="#{str}\n<:Offensive_Structure:510774545997758464> #{longFormattedNumber(m.reject{|q| !q[2].include?('Offensive')}.length)} Offensive structure levels"
    str="#{str}\n<:Defensive_Structure:510774545108566016> #{longFormattedNumber(m.reject{|q| !q[2].include?('Defensive')}.length)} Defensive structure levels"
    str="#{str}\n<:Trap_Structure:510774545179869194> #{longFormattedNumber(m.reject{|q| !q[2].include?('Trap')}.length)} Trap levels"
    str="#{str}\n<:Resource_Structure:510774545154572298> #{longFormattedNumber(m.reject{|q| !q[2].include?('Resources')}.length)} Resource structure levels"
    str="#{str}\n<:Ornamental_Structure:510774545150640128> #{longFormattedNumber(m.reject{|q| !q[2].include?('Ornament')}.length)} Ornament levels"
    str="#{str}\n<:Mjolnir_Structure:691254233588301866> #{longFormattedNumber(m.reject{|q| !q[2].include?('Mjolnir')}.length)} Mjolnir Strike levels"
    m=@structures.reject{|q| q[2]=='example'}.map{|q| [q[0],0,q[2]]}.uniq
    str2="**There are #{longFormattedNumber(m.length)} structures, including:**"
    str2="#{str2}\n<:Offensive_Structure:510774545997758464> #{longFormattedNumber(m.reject{|q| !q[2].include?('Offensive')}.length)} Offensive structures"
    str2="#{str2}\n<:Defensive_Structure:510774545108566016> #{longFormattedNumber(m.reject{|q| !q[2].include?('Defensive')}.length)} Defensive structures"
    str2="#{str2}\n<:Trap_Structure:510774545179869194> #{longFormattedNumber(m.reject{|q| !q[2].include?('Trap')}.length)} Traps"
    str2="#{str2}\n<:Resource_Structure:510774545154572298> #{longFormattedNumber(m.reject{|q| !q[2].include?('Resources')}.length)} Resource structures"
    str2="#{str2}\n<:Ornamental_Structure:510774545150640128> #{longFormattedNumber(m.reject{|q| !q[2].include?('Ornament')}.length)} Ornaments"
    str2="#{str2}\n<:Mjolnir_Structure:691254233588301866> #{longFormattedNumber(m.reject{|q| !q[2].include?('Mjolnir')}.length)} Mjolnir Strike structures"
    str=extend_message(str,str2,event,2)
    event.respond str
    return nil
  elsif ['accessories','accessory','accessorys','accessorie'].include?(f.downcase)
    str2="**There are #{longFormattedNumber(@accessories.length)} accessories, including:**"
    m=@accessories.reject{|q| q[1]!='Hair'}
    str2="#{str2}\n\n<:Accessory_Type_Hair:531733124741201940> #{longFormattedNumber(m.length)} pins and other hair accessories"
    m=@accessories.reject{|q| q[1]!='Hat'}
    str2="#{str2}\n<:Accessory_Type_Hat:531733125227741194> #{longFormattedNumber(m.length)} hats and other top-of-head accessories"
    m=@accessories.reject{|q| q[1]!='Mask'}
    str2="#{str2}\n<:Accessory_Type_Mask:531733125064163329> #{longFormattedNumber(m.length)} masks and other face accessories"
    m=@accessories.reject{|q| q[1]!='Tiara'}
    str2="#{str2}\n<:Accessory_Type_Tiara:531733130734731284> #{longFormattedNumber(m.length)} tiaras and other back-of-head accessories"
    m=@accessories.reject{|q| !q[2].include?('Proof of victory over')}
    str2="#{str2}\n\n#{longFormattedNumber(m.length)} Golden Accessories"
    m=@accessories.reject{|q| !q[0].include?(' EX')}
    str2="#{str2}\n#{longFormattedNumber(m.length*2)} Forging Bonds Accessories (#{longFormattedNumber(m.length)} pairs)"
    m=@accessories.reject{|q| q[3].nil? || !q[3].include?('Illusory Dungeon')}
    str2="#{str2}\n#{longFormattedNumber(m.length*2)} Tap Battle Accessories"
    event.respond str2
    return nil
  elsif ['item','items'].include?(f.downcase)
    str2="**There are #{longFormattedNumber(@itemus.length)} items, including:**"
    m=@itemus.reject{|q| q[1]!='Main'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} main items"
    m=@itemus.reject{|q| q[1]!='Implied'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} implied items"
    m=@itemus.reject{|q| q[1]!='Blessing'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} blessings"
    m=@itemus.reject{|q| q[1]!='Growth'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} unit growth items"
    m=@itemus.reject{|q| q[1]!='Assault'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} Arena Assault items"
    m=@itemus.reject{|q| q[1]!='Event'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} event items"
    str2="#{str2}\n~~3 thrones which are counted as structures in my data even though FEH counts them as both structures and items~~"
    event.respond str2
    return nil
  elsif ['alias','aliases','name','names','nickname','nicknames'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',1)
    glbl=@aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=@aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    all_units=@units.reject{|q| !has_any?(g, q[13][0])}
    all_units=@units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    all_units=all_units.map{|q| [q[0],q[8],0,0]}
    srv_spec=srv_spec.reject{|q| !all_units.map{|q2| q2[1]}.include?(q[1])}
    for j in 0...all_units.length
      all_units[j][2]+=glbl.reject{|q| q[1]!=all_units[j][1]}.length
      all_units[j][3]+=srv_spec.reject{|q| q[1]!=all_units[j][1]}.length
    end
    str="**There are #{longFormattedNumber(glbl.length)} global single-unit aliases.**"
    all_units=all_units.sort{|b,a| supersort(a,b,2).zero? ? supersort(a,b,1) : supersort(a,b,2)}
    k=all_units.reject{|q| q[2]!=all_units[0][2]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}*"}
    str="#{str}\nThe unit#{"s" unless k.length==1} with the most global aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][1]} global aliases#{" each" unless k.length==1}."
    str="#{str}\n\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]unit aliases.**"
    if event.server.nil? && @shardizard==4
      str="#{str}\nDue to being the debug version, I cannot show more information."
    elsif event.server.nil? && @shardizard==-1
      str="#{str}\nDue to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str="#{str}\nServers you and I share account for #{@aliases.reject{|q| q[0]!='Unit' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str="#{str}\nThis server accounts for #{@aliases.reject{|q| q[0]!='Unit' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    all_units=all_units.sort{|b,a| supersort(a,b,3).zero? ? supersort(a,b,0) : supersort(a,b,3)}
    k=all_units.reject{|q| q[3]!=all_units[0][3]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2[0]==q[0]}.nil?}*"}
    str="#{str}\nThe unit#{"s" unless k.length==1} with the most server-specific aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][2]} server-specific aliases#{" each" unless k.length==1}."
    for i in 0...srv_spec.length
      srv_spec[i][2]=srv_spec[i][2].length
    end
    srv_spec=srv_spec.sort{|b,a| supersort(a,b,2).zero? ? (supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)) : supersort(a,b,2)}
    k=srv_spec.reject{|q| q[2]!=srv_spec[0][2]}.map{|q| "*#{q[0]} = #{all_units[all_units.find_index{|q2| q2[1]==q[1]}][0]}*"}
    str="#{str}\nThe most agreed-upon server-specific alias#{"es are" unless k.length==1}#{" is" if k.length==1} #{list_lift(k,"and")}.  #{srv_spec[0][2]} servers agree on #{"them" unless k.length==1}#{"it" if k.length==1}." if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")
    k=srv_spec.map{|q| q[2]}.inject(0){|sum,x| sum + x }
    str="#{str}\nCounting each alias/server combo as a unique alias, there are #{longFormattedNumber(k)} server-specific aliases"
    multi=@aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}
    str="#{str}\n\n**There are #{longFormattedNumber(multi.length)} [global] multi-unit aliases, covering #{multi.map{|q| q[2]}.uniq.length} groups of units.**"
    data_load()
    untz=@units.map{|q| q}
    for i in 0...multi.length
      multi[i][2]=multi[i][2].map{|q| untz[untz.bsearch_index{|q2| q<=>q2[8]}][0]}
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
    glbl=@aliases.reject{|q| q[0]!='Skill' || q[2].is_a?(String) || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=@aliases.reject{|q| q[0]!='Skill' || q[2].is_a?(String) || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    all_units=@skills.reject{|q| !has_any?(g, q[15])}
    all_units=@skills.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    all_units=all_units.map{|q| [q[0],"#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['-','example'].include?(q[2]) || ['Weapon','Assist','Special'].include?(q[6])}",0,0]}
    srv_spec=srv_spec.reject{|q| !all_units.map{|q| q[0]}.include?(q[1])}
    for j in 0...all_units.length
      all_units[j][2]+=glbl.reject{|q| q[1]!=all_units[j][0]}.length
      all_units[j][3]+=srv_spec.reject{|q| q[1]!=all_units[j][0]}.length
    end
    str2="**There are #{longFormattedNumber(glbl.length)} global single-skill aliases.**"
    all_units=all_units.sort{|b,a| supersort(a,b,2).zero? ? supersort(a,b,1) : supersort(a,b,2)}
    k=all_units.reject{|q| q[2]!=all_units[0][2]}.map{|q| "*#{'~~' if legal_skills.find_index{|q2| q2[0]==q[0]}.nil?}#{q[1]}#{'~~' if legal_skills.find_index{|q2| q2[0]==q[0]}.nil?}*"}
    str2="#{str2}\nThe skill#{"s" unless k.length==1} with the most global aliases #{"is" if k.length==1}#{"are" unless k.length==1} #{list_lift(k,"and")}, with #{all_units[0][2]} global aliases#{" each" unless k.length==1}."
    str2="#{str2}\n\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]skill aliases.**"
    if event.server.nil? && @shardizard==4
      str2="#{str2}\nDue to being the debug version, I cannot show more information."
    elsif event.server.nil? && @shardizard==-1
      str2="#{str2}\nDue to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str2="#{str2}\nServers you and I share account for #{@aliases.reject{|q| q[0]!='Skill' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str2="#{str2}\nThis server accounts for #{@aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    all_units=all_units.sort{|b,a| supersort(a,b,3).zero? ? supersort(a,b,1) : supersort(a,b,3)}
    k=all_units.reject{|q| q[3]!=all_units[0][3]}.map{|q| "*#{'~~' if legal_skills.find_index{|q2| q2[0]==q[0]}.nil?}#{q[1]}#{'~~' if legal_skills.find_index{|q2| q2[0]==q[0]}.nil?}*"}
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
    glbl=@aliases.reject{|q| q[0]!='Structure' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=@aliases.reject{|q| q[0]!='Structure' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**There are #{longFormattedNumber(glbl.length)} global [single-]structure aliases.**\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]structure aliases.**"
    if event.server.nil? && @shardizard==4
      str2="#{str2} - Due to being the debug version, I cannot show more information."
    elsif event.server.nil? && @shardizard==-1
      str2="#{str2} - Due to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str2="#{str2} - Servers you and I share account for #{@aliases.reject{|q| q[0]!='Structure' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str2="#{str2} - This server accounts for #{@aliases.reject{|q| q[0]!='Structure' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    str=extend_message(str,str2,event,3)
    glbl=@aliases.reject{|q| q[0]!='Accessory' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=@aliases.reject{|q| q[0]!='Accessory' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**There are #{longFormattedNumber(glbl.length)} global [single-]accessory aliases.**\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]accessory aliases.**"
    if event.server.nil? && @shardizard==4
      str2="#{str2} - Due to being the debug version, I cannot show more information."
    elsif event.server.nil? && @shardizard==-1
      str2="#{str2} - Due to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str2="#{str2} - Servers you and I share account for #{@aliases.reject{|q| q[0]!='Accessory' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str2="#{str2} - This server accounts for #{@aliases.reject{|q| q[0]!='Accessory' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    str=extend_message(str,str2,event,3)
    glbl=@aliases.reject{|q| q[0]!='Item' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=@aliases.reject{|q| q[0]!='Item' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**There are #{longFormattedNumber(glbl.length)} global [single-]item aliases.**\n**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-]item aliases.**"
    if event.server.nil? && @shardizard==4
      str2="#{str2} - Due to being the debug version, I cannot show more information."
    elsif event.server.nil? && @shardizard==-1
      str2="#{str2} - Due to being the smol version, I cannot show more information."
    elsif event.server.nil?
      str2="#{str2} - Servers you and I share account for #{@aliases.reject{|q| q[0]!='Item' || q[3].nil? || q[3].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
    else
      str2="#{str2} - This server accounts for #{@aliases.reject{|q| q[0]!='Item' || q[3].nil? || !q[3].include?(event.server.id)}.length} of those."
    end
    str=extend_message(str,str2,event,3)
    event.respond str
    return nil
  elsif ['groups','group','groupings','grouping'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3) if safe_to_spam?(event)
    str="**There are #{longFormattedNumber(@groups.reject{|q| !q[2].nil?}.length-1)} global groups**"
    if safe_to_spam?(event)
      str="**There are #{longFormattedNumber(@groups.reject{|q| !q[2].nil?}.length-1)} global groups**, including the following dynamic ones:"
      gg=@groups.reject{|q| !q[2].nil? || q[1].length>0}.map{|q| [q[0],get_group(q[0],event)[1].reject{|q2| all_units.find_index{|q3| q3[0]==q2}.nil?}]}
      str=extend_message(str,"<:Current_Aether_Bonus:510022809741950986> *Aether Bonus* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='AetherBonus'}][1].length)} current members) - Any unit that is a bonus unit for the current Aether Raids season.",event)
      str=extend_message(str,"<:Current_Arena_Bonus:498797967042412544> *Arena Bonus* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='ArenaBonus'}][1].length)} current members) - Any unit that is a bonus unit for the current Arena season.",event)
      str=extend_message(str,"<:Bannerless:701268588270714901> *Bannerless* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Bannerless'}][1].length)} current members) - Any unit that has never been a focus unit on a banner.",event)
      str=extend_message(str,"<:BraveHero:701268588266520578> *Brave Heroes* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='BraveHeroes'}][1].length)} current members) - Any unit with the phrase *(Brave)* in their internal name.",event)
      str=extend_message(str,"\u{1F4C5} *Daily Rotation* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Daily_Rotation'}][1].length)} current members) - Any unit that can be obtained via the twelve rotating Daily Hero Battle maps.",event)
      str=extend_message(str,"<:Hero_Duo:631431055420948480> *Duo Units* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='DuoUnits'}][1].length)} current members) - Any unit that is actually two characters.",event)
      str=extend_message(str,"<:DragonEff:701301177370804296> *Falchion Users* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Falchion_Users'}][1].length)} current members) - Any unit that can use one of the three Falchions, or any of their evolutions.",event)
      str=extend_message(str,"<:PurpleFire:701271290987806790> *Fallen Heroes* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='FallenHeroes'}][1].length)} current members) - Any unit with the phrase *(Fallen)* in their internal name.",event)
      str=extend_message(str,"<:Forma_Soul:699042073176965241> *Forma* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Forma'}][1].length)} current members) - Any unit that was part of a Hall of Forms event released after the introduction of Forma Souls.",event)
      str=extend_message(str,"<:Heroic_Grail:574798333898653696> *GHB* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='GHB'}][1].length)} current members) - Any unit that can obtained via a Grand Hero Battle map.",event)
      str=extend_message(str,"<:Forma_Soulless:699085674724327516> *Hall of Forms* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='HallOfForms'}][1].length)} current members) - Any unit was part of a Hall of Forms event.",event)
      str=extend_message(str,"<:Ally_Boost_Spectrum:443337604054646804> *Legendaries/Mythics* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Legendaries'}][1].length)} current members) - Any unit that gives a Legendary Hero Boost to blessed allies during specific seasons, or any unit that gives a Mythic Boost to blessed allies in Aether Raids during specific seasons.",event)
      str=extend_message(str,"<:Assist_Music:454462054959415296> *Refreshers* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Refreshers'}][1].length)} current members) - Any unit that can learn any of the skills: Dance, Sing, or Play.",event)
      str=extend_message(str,"<:Resplendent_Ascension:678748961607122945> *Resplendent* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Resplendent'}][1].length)} current members) - Any unit that has a Resplendent Ascension.",event)
      str=extend_message(str,"<:Divine_Dew:453618312434417691> *Retro-Prfs* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Retro-Prfs'}][1].length)} current members) - Any unit that has access to a Prf weapon that does not promote from anything.",event)
      str=extend_message(str,"<:Seasonal:701278992677732442> *Seasonals* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Seasonals'}][1].length)} current members) - Any unit that is limited summonable (or related to such an event), but does not give a Legendary Hero boost.\n      The following subsets of the Seasonals group are also dynamic: *Bathing* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Bathing'}][1].length)}), *Valentine's* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=="Valentine's"}][1].length)}), *Bunny* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Bunnies'}][1].length)}), *Picnic* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Picnic'}][1].length)}), *Retro* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Retro'}][1].length)}), *Wedding* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Wedding'}][1].length)}), *Summer* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Summer'}][1].length)}), *Halloween* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Halloween'}][1].length)}), *Winter* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Winter'}][1].length)})",event)
      str=extend_message(str,"<:Godly_Grail:612717339611496450> *Tempest* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Tempest'}][1].length)} current members) - Any unit that can be obtained via a Tempest Trials event.",event)
      str=extend_message(str,"<:Current_Tempest_Bonus:498797966740422656> *Tempest Bonus* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='TempestBonus'}][1].length)} current members) - Any unit that is a bonus unit for the current Tempest Trials event.",event)
      str=extend_message(str,"<:Divine_Mist:701285239611195432> *Worse Than Liki* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='WorseThanLiki'}][1].length)} current members) - Any unit with every stat equal to or less than the same stat on Tiki(Young)(Earth), excluding Tiki(Young)(Earth) herself.",event)
      display=false
      display=true if event.user.id==167657750971547648
      display=true if !event.server.nil? && !bot.user(167657750971547648).on(event.server.id).nil? && rand(100).zero?
      display=true if !event.server.nil? && bot.user(167657750971547648).on(event.server.id).nil? && rand(10000).zero?
      str=extend_message(str,"<:Icon_Support:448293527642701824> *Mathoo's Waifus* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=="Mathoo'sWaifus"}][1].length)} current members) - Any unit that my developer would enjoy cuddling.",event) if display
    end
    str=extend_message(str,"**There are #{longFormattedNumber(@groups.reject{|q| q[2].nil?}.length)} server-specific groups.**",event,2)
    if event.server.nil? && @shardizard==4
      str=extend_message(str,"Due to being the debug version, I cannot show more information.",event)
    elsif event.server.nil? && @shardizard==-1
      str=extend_message(str,"Due to being the smol version, I cannot show more information.",event)
    elsif event.server.nil?
      str=extend_message(str,"Servers you and I share account for #{@groups.reject{|q| q[2].nil? || q[2].reject{|q2| bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those.",event)
    else
      str=extend_message(str,"This server accounts for #{@groups.reject{|q| q[2].nil? || !q[2].include?(event.server.id)}.length} of those.",event)
    end
    event.respond str
    return nil
  elsif ['code','lines','line','sloc'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',3)
    b=[[],[],[],[],[]]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb').each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      b[3].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[1].push(l) unless l.length<=0
    end
    File.open('C:/Users/Mini-Matt/Desktop/devkit/rot8er_functs.rb').each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[2].push(l) unless l.length<=0
    end
    File.open('C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb').each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[2].push(l) unless l.length<=0
    end
    File.open('C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb').each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[2].push(l) unless l.length<=0
    end
    event << "**I am #{longFormattedNumber(File.foreach("C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} lines of code long.**"
    event << "Of those, #{longFormattedNumber(b[1].length)} are SLOC (non-empty)."
    event << "~~When fully collapsed, I appear to be #{longFormattedNumber(b[3].reject{|q| q.length>0 && (q[0,2]=='  ' || q[0,3]=='end' || q[0,4]=='else')}.length)} lines of code long.~~"
    event << ''
    event << "**I rely on multiple libraries that in total are #{longFormattedNumber(File.foreach("C:/Users/Mini-Matt/Desktop/devkit/rot8er_functs.rb").inject(0) {|c, line| c+1}+File.foreach("C:/Users/Mini-Matt/Desktop/devkit/EliseMulti1.rb").inject(0) {|c, line| c+1}+File.foreach("C:/Users/Mini-Matt/Desktop/devkit/EliseText.rb").inject(0) {|c, line| c+1})} lines of code long.**"
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
    if @shardizard==4 || @shardizard==-1
      s2="That server uses/would use #{shard_data(0,true)[(f.to_i >> 22) % @shards]} Shards."
    else
      srv=(bot.server(f.to_i) rescue nil)
      if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
        s2="I am not in that server, but it would use #{shard_data(0,true)[(f.to_i >> 22) % @shards]} Shards."
      else
        s2="__**#{srv.name}** (#{srv.id})__\n*Owner:* #{srv.owner.distinct} (#{srv.owner.id})\n*Shard:* #{shard_data(0,true)[(srv.id >> 22) % @shards]}\n*My nickname:* #{bot.user(312451658908958721).on(srv.id).display_name}"
      end
    end
    event.respond s2
    return nil
  end
  extln=1
  extln=2 if safe_to_spam?(event)
  extln=2 if f.downcase=="all"
  bot.servers.values(&:members)
  str="**I am in #{longFormattedNumber(@server_data[0].inject(0){|sum,x| sum + x })} *servers*.**"
  if @shardizard==-1
    str="#{str}\nThis Smol version is in 3 servers."
  else
    str="#{str}\nThis shard is in #{longFormattedNumber(@server_data[0][@shardizard])} server#{"s" unless @server_data[0][@shardizard]==1}."
  end
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{filler(legal_units,all_units,-1)} *units*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    str2="#{str2}\n#{filler(legal_units,all_units,9,0,'p',1)} summonable units"
    str2="#{str2}\n#{filler(legal_units,all_units,9,0,'g',1)} Grand Hero Battle reward units"
    str2="#{str2}\n#{filler(legal_units,all_units,9,0,'t',1)} Tempest Trials reward units"
    str2="#{str2}\n#{filler(legal_units,all_units,[9,2],[0,0],['s',2],[1,-2])} seasonal units"
    str2="#{str2}\n#{filler(legal_units,all_units,2,0,2,2)} legendary/mythic units"
    str2="#{str2}\n#{filler(legal_units,all_units,9,0,'-',1)} unobtainable units"
  end
  str=extend_message(str,str2,event,2)
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{filler(legal_skills,all_skills,-1)} *skills*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    str2="#{str2}\n#{filler(legal_skills,all_skills,6,-1,'Weapon')} Weapons"
    str2="#{str2}\n#{filler(legal_skills,all_skills,6,-1,'Assist')} Assists"
    str2="#{str2}\n#{filler(legal_skills,all_skills,6,-1,'Special')} Specials"
    str2="#{str2}\n#{filler(legal_skills,all_skills,6,-1,['Weapon','Assist','Special'],3)} Passives"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{longFormattedNumber(@structures.map{|q| q[0]}.uniq.length)} *structures* with #{longFormattedNumber(@structures.length)} levels#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    m=@structures.reject{|q| !q[2].include?('Offensive')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q[0]}.uniq.length)} Offensive structures#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q[0]}.uniq.length==m.length}"
    m=@structures.reject{|q| !q[2].include?('Defensive')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q[0]}.uniq.length)} Defensive structures#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q[0]}.uniq.length==m.length}"
    m=@structures.reject{|q| !q[2].include?('Trap')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q[0]}.uniq.length)} Traps#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q[0]}.uniq.length==m.length}"
    m=@structures.reject{|q| !q[2].include?('Resources')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q[0]}.uniq.length)} Resource structures#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q[0]}.uniq.length==m.length}"
    m=@structures.reject{|q| !q[2].include?('Ornament')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q[0]}.uniq.length)} Ornaments#{" with #{longFormattedNumber(m.length)} levels" unless m.map{|q| q[0]}.uniq.length==m.length}"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{longFormattedNumber(@accessories.length)} *accessories*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    m=@accessories.reject{|q| q[1]!='Hair'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} pins and other hair accessories"
    m=@accessories.reject{|q| q[1]!='Hat'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} hats and other top-of-head accessories"
    m=@accessories.reject{|q| q[1]!='Mask'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} masks and other face accessories"
    m=@accessories.reject{|q| q[1]!='Tiara'}
    str2="#{str2}\n__#{longFormattedNumber(m.length)} tiaras and other back-of-head accessories__"
    m=@accessories.reject{|q| !q[2].include?('Proof of victory over')}
    str2="#{str2}\n#{longFormattedNumber(m.length)} Golden Accessories"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}There are #{longFormattedNumber(@itemus.length)} *items*#{", including:**" if safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}#{"." unless safe_to_spam?(event) || " #{event.message.text.downcase} ".include?(" all ")}"
  if safe_to_spam?(event) || f.downcase=="all"
    m=@itemus.reject{|q| q[1]!='Main'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} main items"
    m=@itemus.reject{|q| q[1]!='Implied'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} implied items"
    m=@itemus.reject{|q| q[1]!='Blessing'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} blessings"
    m=@itemus.reject{|q| q[1]!='Growth'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} unit growth items"
    m=@itemus.reject{|q| q[1]!='Assault'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} Arena Assault items"
    m=@itemus.reject{|q| q[1]!='Event'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} event items"
    str2="#{str2}\n~~3 thrones which are counted as structures in my data even though FEH counts them as both structures and items~~"
  end
  str=extend_message(str,str2,event,extln)
  glbl=@aliases.reject{|q| !q[3].nil?}
  srv_spec=@aliases.reject{|q| q[3].nil?}
  str2="**There are #{longFormattedNumber(glbl.length+2)} global and #{longFormattedNumber(srv_spec.length)} server-specific *aliases*.**"
  glbl=@aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || !q[3].nil?}
  srv_spec=@aliases.reject{|q| q[0]!='Unit' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]unit aliases."
  str2="#{str2}\nThere are #{longFormattedNumber(@aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}.length)} [global] multi-unit aliases."
  glbl=@aliases.reject{|q| q[0]!='Skill' || !q[3].nil?}
  srv_spec=@aliases.reject{|q| q[0]!='Skill' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]skill aliases.\nThere are 3 global multi-skill aliases."
  glbl=@aliases.reject{|q| q[0]!='Structure' || !q[3].nil?}
  srv_spec=@aliases.reject{|q| q[0]!='Structure' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]structure aliases."
  glbl=@aliases.reject{|q| q[0]!='Accessory' || !q[3].nil?}
  srv_spec=@aliases.reject{|q| q[0]!='Accessory' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]accessory aliases."
  glbl=@aliases.reject{|q| q[0]!='Item' || !q[3].nil?}
  srv_spec=@aliases.reject{|q| q[0]!='Item' || q[3].nil?}
  str2="#{str2}\nThere are #{longFormattedNumber(glbl.length)} global and #{longFormattedNumber(srv_spec.length)} server-specific [single-]item aliases."
  str=extend_message(str,str2,event,2)
  str=extend_message(str,"**There are #{longFormattedNumber(@groups.reject{|q| !q[2].nil?}.length-1)} global and #{longFormattedNumber(@groups.reject{|q| q[2].nil?}.length)} server-specific *groups*.**",event,2)
  str2="**I am #{longFormattedNumber(File.foreach("C:/Users/Mini-Matt/Desktop/devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} lines of *code* long.**"
  str2="#{str2}\nOf those, #{longFormattedNumber(b.length)} are SLOC (non-empty)."
  str=extend_message(str,str2,event,2)
  event.respond str
end
