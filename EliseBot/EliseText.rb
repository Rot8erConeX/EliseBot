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
      create_embed(event,"**#{command.downcase}**","Returns:\n- the number of servers I'm in\n- the numbers of units and skills in the game\n- the numbers of aliases I keep track of\n- the numbers of groups I keep track of\n- how long of a file I am.\n\nYou can also include the following words to get more specialized data:\nServer(s), Member(s), Shard(s), User(s)\nUnit(s), Character(s), Char(a)(s)\nAlt(s)\nSkill(s)\nAlias(es), Name(s), Nickname(s)\nGroup(s), Grouping(s)\nCode, Line(s), SLOC#{"\n\nAs the bot developer, you can also include a server ID number to snag the shard number, owner, and my nickname in the specified server." if event.user.id==167657750971547648}",0x40C0F0)
    end
  elsif ['randomunit','randunit','unitrandom','unitrand','randomstats','statsrand','statsrandom','randstats'].include?(command.downcase) || (['random','rand'].include?(command.downcase) && ['unit','stats'].include?("#{subcommand}".downcase)) || (['unit','stats'].include?(command.downcase) && ['random','rand'].include?("#{subcommand}".downcase))
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
        create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_more_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, and game options can be displayed if you use this command in PM.",0xD49F61)
      else
        create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_more_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, by using the words below.",0xD49F61)
        create_embed(event,'Games','',0x40C0F0,nil,nil,triple_finish(d))
      end
    else
      create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_more_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, by using the words below.",0xD49F61)
      create_embed(event,'Games',d.join("\n\n"),0x40C0F0)
    end
  elsif command.downcase=='shard'
    create_embed(event,'**shard**','Returns the shard that this server is served by.',0x40C0F0)
  elsif ['bugreport','suggestion','feedback'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*message__",'PMs my developer with your username, the server, and the contents of the message `message`',0x40C0F0)
  elsif command.downcase=='invite'
    create_embed(event,'**invite**','PMs the invoker with a link to invite me to their server.',0x40C0F0)
  elsif command.downcase=='addalias'
    create_embed(event,'**addalias** __new alias__ __unit__',"Adds `new alias` to `unit`'s aliases.\nIf the arguments are listed in the opposite order, the command will auto-switch them.\n\nInforms you if the alias already belongs to someone.\nAlso informs you if the unit you wish to give the alias to does not exist.",0xC31C19)
  elsif ['oregano','whoisoregano'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Answers the question of who Oregano is.",0xD49F61)
  elsif ['allinheritance','allinherit','allinheritable','skillinheritance','skillinherit','skillinheritable','skilllearn','skilllearnable','skillsinheritance','skillsinherit','skillsinheritable','skillslearn','skillslearnable','inheritanceskills','inheritskill','inheritableskill','learnskill','learnableskill','inheritanceskills','inheritskills','inheritableskills','learnskills','learnableskills','all_inheritance','all_inherit','all_inheritable','skill_inheritance','skill_inherit','skill_inheritable','skill_learn','skill_learnable','skills_inheritance','skills_inherit','skills_inheritable','skills_learn','skills_learnable','inheritance_skills','inherit_skill','inheritable_skill','learn_skill','learnable_skill','inheritance_skills','inherit_skills','inheritable_skills','learn_skills','learnable_skills','inherit','learn','inheritance','learnable','inheritable','skillearn','skillearnable'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows all the skills that `name`can learn.\n\nIn servers, will only show the weapons, assists, and specials.\nIn PM, will also show the passive skills.",0xD49F61)
  elsif ['safe','spam','safetospam','safe2spam','long','longreplies'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __toggle__","Responds with whether or not the channel the command is invoked in is one in which I can send extremely long replies.\n\nIf the channel does not fill one of the many molds for acceptable channels, server mods can toggle the ability with the words \"on\" and \"off\".",0xD49F61)
  elsif ['data','unit'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats, and skills.",0xD49F61)
  elsif ['attackicon','attackcolor','attackcolors','attackcolour','attackcolours','atkicon','atkcolor','atkcolors','atkcolour','atkcolours','atticon','attcolor','attcolors','attcolour','attcolours','staticon','statcolor','statcolors','statcolour','statcolours','iconcolor','iconcolors','iconcolour','iconcolours'].include?(command.downcase) || (['stats','stat'].include?(command.downcase) && ['color','colors','colour','colours'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['color','colors','colour','colours'].include?("#{subcommand}".downcase)}**","Explains the reasoning behind the multiple Attack stat icons - <:StrengthS:514712248372166666> <:MagicS:514712247289774111> <:FreezeS:514712247474585610>",0xD49F61)
  elsif ['struct','struncture'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows data on the Aether Raid structure named `name`.',0xD49F61)
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
  elsif ['aliases','checkaliases','seealiases'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __unit__","Responds with a list of all `unit`'s aliases.\nIf no unit is listed, responds with a list of all aliases and who they are for.\n\nPlease note that if more than 50 aliases are to be listed, I will - for the sake of the sanity of other server members - only allow you to use the command in PM.",0xD49F61)
  elsif ['daily','today','todayinfeh','today_in_feh'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Shows the day's in-game daily events.\nIf in PM, will also show tomorrow's.",0xD49F61)
  elsif ['next','schedule'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __type__","Shows the next time in-game daily events of the type `type` will happen.\nIf in PM and `type` is unspecified, shows the entire schedule.\n\n__*Accepted Inputs*__\nTower, Training_Tower, Color, Shard, Crystal\nFree, 1\\*, 2\\*, F2P, FreeHero\nSpecial, Special_Training\nGHB\nGHB2\nRival, Domain(s), RD, Rival_Domain(s)\nBlessed, Garden(s), Blessing, Blessed_Garden(s)\nTactics_Drills, Tactic(s), Drill(s)\nBanner(s), Summon(ing)(s)\nEvent(s)\nLegendary/Legendaries, Legend(s)\nArena, ArenaBonus, Arena_Bonus\nTempest, TempestBonus, Tempest_Bonus\nBonus",0xD49F61)
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
  elsif ['art','artist'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __unit__ __art type__","Displays `unit`'s character art.  Defaults to their normal portrait, but can be adjusted to other portraits with the following words:\n*Default Attacking Image:* Battle/Battling, Attack/Atk/Att\n*Special Proc Image:* Critical/Crit, Special, Proc\n*Damaged Art:* Damage/Damaged, LowHP/LowHealth, Injured",0xD49F61)
  elsif ['bestamong','bestin','beststats','higheststats','highest','best','highestamong','highestin'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the best in each stat.\n\n#{disp_more_info(event,2)}",0xD49F61)
  elsif ['worstamong','worstin','worststats','loweststats','lowest','lowestamong','lowestin','worst'].include?(command.downcase)
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
    elsif ['nature','ivs'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*effects__","Causes me to change the nature of the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['equip','skill'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill name__","Equips the skill `skill name` on the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['seal'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill name__","Equips the skill seal `skill name` on the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['refine','refinery','refinement'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*refinement__","Refines the weapon equipped by the donor unit with the name `unit`, using the refinement `refinement`\n\nIf no refinement is defined and the equipped weapon has an Effect Mode, defaults to that.\nOtherwise, throws an error message if no refinement is defined.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['support','marry'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to change the support rank of the donor unit with the name `unit`.  If the donor unit has no rank, will wipe the other donor unit that has support.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    else
      create_embed(event,"**#{command.downcase}** __subcommand__ __unit__ __\*effects__","Allows me to create and edit the donor units.\n\nAvailable subcommands include:\n`FEH!#{command.downcase} create` - creates a new donor unit\n`FEH!#{command.downcase} promote` - promotes an existing donor unit (*also `rarity` and `feathers`*)\n`FEH!#{command.downcase} merge` - increases a donor unit's merge count (*also `combine`*)\n`FEH!#{command.downcase} nature` - changes a donor unit's nature (*also `ivs`*)\n`FEH!#{command.downcase} support` - causes me to change support ranks of donor units (*also `marry`*)\n\n`FEH!#{command.downcase} equip` - equip skill (*also `skill`*)\n`FEH!#{command.downcase} seal` - equip seal\n`FEH!#{command.downcase} refine` - refine weapon\n\n`FEH!#{command.downcase} send_home` - removes the unit from the donor units attached to the invoker (*also `fodder` or `remove` or `delete`*)\n\n**This command is only able to be used by certain people**.",0x9E682C)
    end
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
    create_embed([event,x],"","__**Other Data**__\n`bst` __\\*allies__\n`find` __\\*filters__ - used to generate a list of applicable units and/or skills (*also `search`*)\n`summonpool` \\*colors - for a list of summonable units sorted by rarity (*also `pool`*)\n`legendaries` \\*filters - for a sorted list of all legendaries. (*also `legendary`*)\n`bonus` - used to list all Arena and TT bonus units (*also `arena` and `tt`*)\n`refinery` - used to show a list of refineable weapons (*also `refine`*)\n`sort` __\\*filters__ - used to create a list of applicable units and sort them based on specified stats\n`skill` __skill name__ - used to show data on a specific skill\n`structure` __structure name__ - used to show data on a specific Aether Raid structure\n`average` __\\*filters__ - used to find the average stats of applicable units (*also `mean`*)\n`bestamong` __\\*filters__ - used to find the best stats among applicable units (*also `bestin`, `beststats`, or `higheststats`*)\n`worstamong` __\\*filters__ - used to find the worst stats among applicable units (*also `worstin`, `worststats`, or `loweststats`*)\n`compare` __\\*allies__ - compares units' stats (*also `comparison`*)\n`compareskills` __\\*allies__ - compares units' skills",0xD49F61)
    create_embed([event,x],"","__**Meta data**__\n`groups` (*also `checkgroups` or `seegroups`*) - for a list of all unit groups\n`tools` - for a list of tools aside from me that may aid you\n`natures` - for help understanding my nature names\n`growths` - for help understanding how growths work (*also `gps`*)\n`merges` - for help understanding how merges work\n`invite` - for a link to invite me to your server\n`random` - generates a random unit (*also `rand`*)\n`daily` - shows the current day's in-game daily events (*also `today` or `todayInFEH`*)\n`next` __type__ - to see a schedule of the next time in-game daily events will happen (*also `schedule`*)\n\n__**Developer Information**__\n`avatar` - to see why my avatar is different from the norm\n\n`bugreport` __\\*message__ - to send my developer a bug report\n`suggestion` __\\*message__ - to send my developer a feature suggestion\n`feedback` __\\*message__ - to send my developer other kinds of feedback\n~~the above three commands are actually identical, merely given unique entries to help people find them~~\n\n`donation` (*also `donate`*) - for information on how to donate to my developer\n`whyelise` - for an explanation as to how Elise was chosen as the face of the bot\n`skillrarity` (*also `skill_rarity`*)\n`attackcolor` - for a reason for multiple Atk icons (*also `attackicon`*)\n`snagstats` __type__ - to receive relevant bot stats\n`spam` - to determine if the current location is safe for me to send long replies to (*also `safetospam` or `safe2spam`*)#{"\n\n__**Server-specific command**__\n`summon` \\*colors - to simulate summoning on a randomly-chosen banner" if !event.server.nil? && @summon_servers.include?(event.server.id)}",0xD49F61)
    create_embed([event,x],"__**Server Admin Commands**__","__**Unit Aliases**__\n`addalias` __new alias__ __unit__ - Adds a new server-specific alias\n~~`aliases` __unit__ (*also `checkaliases` or `seealiases`*)~~\n`deletealias` __alias__ (*also `removealias`*) - deletes a server-specific alias\n\n__**Groups**__\n`addgroup` __name__ __\\*members__ - adds a server-specific group\n~~`groups` (*also `checkgroups` or `seegroups`*)~~\n`deletegroup` __name__ (*also `removegroup`*) - Deletes a server-specific group\n`removemember` __group__ __unit__ (*also `removefromgroup`*) - removes a single member from a server-specific group\n\n",0xC31C19) if is_mod?(event.user,event.server,event.channel)
    create_embed([event,x],"__**Bot Developer Commands**__","`devedit` __subcommand__ __unit__ __\\*effect__\n\n__**Mjolnr, the Hammer**__\n`ignoreuser` __user id number__ - makes me ignore a user\n`leaveserver` __server id number__ - makes me leave a server\n\n__**Communication**__\n`status` __\\*message__ - sets my status\n`sendmessage` __channel id__ __\\*message__ - sends a message to a specific channel\n`sendpm` __user id number__ __\\*message__ - sends a PM to a user\n\n__**Server Info**__\n`snagstats` - snags relevant bot stats\n`setmarker` __letter__\n\n__**Shards**__\n`reboot` - reboots this shard\n\n__**Meta Data Storage**__\n`reload` - reloads the unit and skill data\n`backup` __item__ - backs up the (alias/group) list\n`sort aliases` - sorts the alias list alphabetically by unit\n`sort groups` - sorts the group list alphabetically by group name\n\n__**Multi-unit Aliases**__\n`addmulti` __name__ __\\*units__ - to create a multi-unit alias\n`deletemulti` __name__ (*also `removemulti`*) - Deletes a multi-unit alias",0x008b8b) if (event.server.nil?|| event.channel.id==283821884800499714 || @shardizard==4 || command.downcase=='devcommands') && event.user.id==167657750971547648
    event.respond "If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nCommand Prefixes: #{@prefix.map{|q| q.upcase}.uniq.map {|s| "`#{s}`"}.join(', ')}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n\nWhen looking up a character or skill, you also have the option of @ mentioning me in a message that includes that character/skill's name" unless x==1
    event.user.pm("If the you see the above message as only three lines long, please use the command `FEH!embeds` to see my messages as plaintext instead of embeds.\n\nCommand Prefixes: #{@prefix.map{|q| q.upcase}.uniq.map {|s| "`#{s}`"}.join(', ')}\nYou can also use `FEH!help CommandName` to learn more on a particular command.\n\nWhen looking up a character or skill, you also have the option of @ mentioning me in a message that includes that character/skill's name") if x==1
    event.respond "A PM has been sent to you.\nIf you would like to show the help list in this channel, please use the command `FEH!help here`." if x==1
  end
end

def attack_icon(event) # this is used by the attackcolor command to display all info
  create_embed(event,"__**Why are the Attack stat icons colored weird?**__","**1.) The Def/Res icons**\n<:DefenseS:514712247461871616> <:ResistanceS:514712247574986752>\nIf one looks carefully, the icons for Defense and Resistance are the same design, but with different color backgrounds.\n\n**2.) The official Attack icon**\n<:StrengthS:514712248372166666> <:DefenseS:514712247461871616>\nLikewise, the Attack and Defense icons have the same color background.  Defense looks slightly redder, but that's because it has a large swatch of yellow inside it whereas Attack has a slightly smaller swatch of blue-white in it.\n\n**3.) The original patent for FEH's summoning system**\n<:Orb_Red:455053002256941056> <:Orb_Blue:455053001971859477> <:Orb_Green:455053002311467048> <:Orb_Colorless:455053002152083457>\nIf one looks at the original patent for FEH's summoning system, they learn that at some point during FEH's development, units had the possibility for simultaneously having two weapon types.  The patent specifically says that if the two weapon types (refered to as \"character attributes\") are different, the orb used to hide the character (refered to as \"the mask\") would be a hybrid of the two colors, akin to tye-dye or a Yin-Yang symbol.",0xC9304A)
  create_embed(event,'',"Taking these three facts into consideration, I believe that at some point in development, units were going to have six stats: <:HP_S:514712247503945739>HP, <:StrengthS:514712248372166666>Strength, <:MagicS:514712247289774111>Magic, <:SpeedS:514712247625580555>Speed, <:DefenseS:514712247461871616>Defense, and <:ResistanceS:514712247574986752>Resistance.\nThat what we now know as the attack icon would be used for Strength and a similar icon with a blue background would be used for Magic.\nThis would mean that when viewing stats, the red swords <:StrengthS:514712248372166666> would attack the enemy's red shield <:DefenseS:514712247461871616>, and the blue swords <:MagicS:514712247289774111> would attack the blue shield <:ResistanceS:514712247574986752>.\nThey then ran into issues with a proper control scheme on phones that allowed for this to be easy to understand for newcomers, so they reduced each character to a single weapon, and thus a single attacking stat.  Said stat was then reduced to a single color to prevent it from conflicting with the gradients of the \"dual stat\" icons.\n\nAll I am doing is acting on this theory and showing icons for each individual type of attacking stat:\n<:StrengthS:514712248372166666> Sword/Lance/Axe users, Archers, and Thieves have Strength\n<:MagicS:514712247289774111> Mages and Healers have Magic\n<:FreezeS:514712247474585610> And Dragons have a stat that is a hybrid of the two (because it attacks the lower defensive stat in certain conditions)\nCertain commands that deal with multiple units also have this symbol <:GenericAttackS:514712247587569664> for use when the units involved have different attacking stats.",0x3B659F)
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
    create_embed(event,"__**Non-healers**__","",xcolor,"Most non-healer units have at least one Scenario X passive and at least one Scenario Y passive",nil,[["__<:Skill_Weapon:444078171114045450> **Weapons**__","Tier 1 (*Iron, basic magic*) - Default at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*Steel, El- magic, Fire Breath+*) - Available at 2<:Icon_Rarity_2:448266417872044032>, Default at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 (*Silver, super magic*) - Available at 3<:Icon_Rarity_3:448266417934958592> ~~Kana(M) has his unavailable until 4\\*~~, default at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 (*+ weapons other than Fire Breath+, Prf weapons*) - default at 5<:Icon_Rarity_5:448266417553539104>\nRetro-Prfs (*Felicia's Plate*) - Available at 5<:Icon_Rarity_5:448266417553539104>, promotes from nothing",1],["__<:Skill_Assist:444078171025965066> **Assists**__","Tier 1 (*Rallies, Dance/Sing, etc.*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 4<:Icon_Rarity_4:448266418459377684> ~~Sharena has hers default at 2\\*~~\nTier 2 (*Double Rallies*) - Available at 4<:Icon_Rarity_4:448266418459377684>\nPrf Assists (*Sacrifice*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Skill_Special:444078170665254929> **Specials**__","Miracle - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 1 (*Daylight, New Moon, etc.*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 4<:Icon_Rarity_4:448266418459377684> ~~Alfonse and Anna have theirs default at 2\\*~~\nTier 2 (*Sol, Luna, etc.*) - Available at 4<:Icon_Rarity_4:448266418459377684> ~~Jaffar and Saber have theirs also default at 5\\*~~\nTier 3 (*Galeforce, Aether, Prf Specials*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1]],2)
    create_embed(event,"__**Healers**__","",0x64757D,"Most healers have a Scenario Y passive",nil,[["__#{"<:Colorless_Staff:443692132323295243>" unless alter_classes(event,'Colored Healers')}#{"<:Gold_Staff:443172811628871720>" if alter_classes(event,'Colored Healers')} **Damaging Staves**__","Tier 1 (*only Assault*) - Available at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*non-plus staves*) - Available at 3<:Icon_Rarity_3:448266417934958592> ~~Lyn(Bride) has hers default when summoned~~\nTier 3 (*+ staves, Prf weapons*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Assist_Staff:454451496831025162> **Healing Staves**__","Tier 1 (*Heal*) - Default at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 (*Mend, Reconcile*) - Available at 2<:Icon_Rarity_2:448266417872044032>, default at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 (*all other non-plus staves*) - Available at 4<:Icon_Rarity_4:448266418459377684>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 4 (*+ staves, Prf staves if healers got them*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1],["__<:Special_Healer:454451451805040640> **Healer Specials**__","Miracle - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 1 (*Imbue*) - Available at 2<:Icon_Rarity_2:448266417872044032>, default at 3<:Icon_Rarity_3:448266417934958592>\nTier 2 (*single-stat Balms, Heavenly Light*) - Available at 3<:Icon_Rarity_3:448266417934958592>, default at 5<:Icon_Rarity_5:448266417553539104>\nTier 3 (*double-stat Balms*) - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 (*+ Balms*) - Available at 5<:Icon_Rarity_5:448266417553539104>\nPrf Specials (*no examples yet, but they may come*) - Available at 5<:Icon_Rarity_5:448266417553539104>",1]],2)
    create_embed(event,"__**Passives**__","",0x245265,nil,nil,[["__<:Passive_X:444078170900135936> **Scenario X**__","Tier 1 - Available at 1<:Icon_Rarity_1:448266417481973781>\nTier 2 - Available at 2<:Icon_Rarity_2:448266417872044032> or 3<:Icon_Rarity_3:448266417934958592>\nTier 3 - Available at 4<:Icon_Rarity_4:448266418459377684>"],["__<:Passive_Y:444078171113914368> **Scenario Y**__","Tier 1 - Available at 3<:Icon_Rarity_3:448266417934958592>\nTier 2 - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 3 - Available at 5<:Icon_Rarity_5:448266417553539104>"],["__<:Passive_Prf:444078170887553024> **Prf Passives**__","Available at 5<:Icon_Rarity_5:448266417553539104>"],["__<:Passive_Z:481922026903437312> **Scenario Z**__","Tier 1 - Available at 2<:Icon_Rarity_2:448266417872044032>\nTier 2 - Available at 3<:Icon_Rarity_3:448266417934958592>\nTier 3 - Available at 4<:Icon_Rarity_4:448266418459377684>\nTier 4 - Available at 5<:Icon_Rarity_5:448266417553539104>"]],2)
  else
    create_embed(event,"**Supposed Bug: X character, despite not being available at #{r}, has skills listed for #{r.gsub('Y','that')} in the `skill` command.**\n\nA word from my developer","By observing the skill lists of the Daily Hero Battle units - the only units we have available at 1\\* - I have learned that there is a set progression for which characters learn skills.  Only six units directly contradict this observation - and three of those units are the Askrians, who were likely given their Assists and Tier 1 Specials (depending on the character) at 2\\* in order to make them useable in the early story maps when the player has limited orbs and therefore limited unit choices.  One is Lyn(Bride), who as the only seasonal healer so far, may be the start of a new pattern.  The other two are Jaffar and Saber, who - for unknown reasons - have their respective Tier 2 Specials available right out of the box as 5\\*s.\n\nThe information as it is is not useless.  In fact, as seen quite recently as of the time of this writing, IntSys is willing to demote some units out of the 4-5\\* pool into the 3-4\\* one. This information allows us to predict which skills the new 3\\* versions of these characters will have.\n\nAs for units unlikely to demote, Paralogue maps will have lower-rarity versions of units with their base kits.  Training Tower and Tempest Trials attempt to build units according to recorded trends in Arena, but will use default base kits at lower difficulties.  Obviously you can't fodder a 4* Siegbert for Death Blow 3, but you can still encounter him in Tempest.",xcolor)
    event.respond "To see the progression I have discovered, please use the command `FEH!skillrarity progression`."
  end
end

def oregano_explain(event,bot)
  if safe_to_spam?(event)
    create_embed(event,'A word from my developer',"**Q1.) Who is Oregano?**\nA.) The first Discord server I ever joined was for a group of friends who were planning a *Fates* AU RP in a world where Corrin decided to leave the world entirely - yes, to join Smash.  This RP never happened (our Dungeon Master had real-life issues to take care of and the project died in his absence), but the group of friends remains together.\nOregano happens to be the in-universe daughter for one of the members of this group.\n\n**Q2.) What is she doing in Elise's data?**\nA.) When I was learning how stats were calculated in FEH - growth points, BST and GPT limits based on class, etc. - the members of this server took the opportunity to translate their units to FEH mechanics.  In order to help them visualize how their units actually were, I made entries for them in Elise's data.\nI, for example, am an Infantry Sword user with 45/29/24/25/39 as my stats, with a superbane in Atk and superboons in both defenses.  My biggest uses are for my prf assist skill - which is effectively Rally Special Cooldown - and the fact that I would give Wrath as a 4<:Icon_Rarity_4:448266418459377684> inheritable skill...yes, I am skill fodder.\n\n**Q3.) Doesn't having fake units in the data alter the results for commands like `sort` and `bestamong`/`worstamong`/`average`?**\nA.) Fake units, and the skills they can learn but no one else can, are exclusive to the server in which they were created, and even in that server, the commands mentioned above will only include the fake units if you type the word \"all\" in your message.  Except `sort`, in which those units will appear but be crossed out.",0x759371,nil,'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/Oregano/Face_FC.png')
    create_embed(event,'',"**Q4.) Wait...\"exclusive to the server in which they were created\"?  Then how did I see Oregano in the first place?**\nA.) This answer gets a little technical.\nFirst off, Oregano is at the bottom of Elise's unit list.  She is, of Penumbra's second generation - or more specifically, those that had FEH units made - the alphabetically last character.\nWhen looking for an entry number within a list, I wrote code so that the function returns `-1` if no matching entries were found, and use `>=0` to make sure that I am looking at an entry.\n__However__, sometimes, interference of some kind causes either the `-1` to pass the check, or for a number that legitimately passed the check to __become__ -1 after the check.  I generally refer to this as a \"typewriter jam\" error, and it doesn't always become -1 - sometimes it will become the number for another entry, which is how you can look up Anna and get her stats but Abel's picture displays, for example.\nWhen the typewriter jam results in a legitimized -1, Ruby - the programming language Elise is written in - interprets that as \"read the last entry in the list\", which for the unit list is Oregano.\n\n**Q5.) What does her real-world father think of this?**\nA.) IRL, Draco is a memelord, and he loves the fact that his daughter - who he designed to be a glass cannon to the utmost extreme - is legitimately \"breaking everything\" to the point that she is breaking my code and appearing places she shouldn't be.#{"\n\n**Q6.) That thumbnail, who I presume is Oregano, is adorable.  Where do I find it?**\nMy friend BluechanXD, from the same server, made it based on Draco's description.  [Here's a link](https://www.deviantart.com/bluechanxd/art/FE-OC-Oregano-V2-765406579)." unless @embedless.include?(event.user.id) || was_embedless_mentioned?(event)}",0x759371)
  else
    create_embed(event,'A word from my developer',"**Q1.) Who is Oregano?**\nA.) A friend's fictitious daughter from a *Fates* AU RP.\n\n**Q2.) What is she doing in Elise's data?**\nA.) The server that was going to do this RP translated their units into FEH mechanics, and I made them server-specific units to help visualize how the stats they chose actually worked in-game.\n\n**Q3.) \"Server-specific\", eh?  Then how did I see her?**\nA.) Non-technical answer: a weird quirk of the programming language I coded Elise in, combined with how I store the unit data, sometimes means that the last listed unit in Elise's unit list is shown in other servers.\nIt is related to the same bug that causes, when you look up one unit, the unit color or profile image to be a different character.",0x759371,'For more detailed answers, use this command in PM.','https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/Oregano/Face_FC.png')
  end
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

def why_elise(event,bot)
  if (!event.message.text.downcase.include?('full') && !event.message.text.downcase.include?('long')) && !safe_to_spam?(event)
    create_embed(event,"__A word from my developer__","When people learn that my main waifu is Sakura, almost invariably, the next question that springs to their mind is: \"If that's the case, then why does your bot take after the **opposite** *Fates* imouto healer?\"\n\nThe short answer is: I already had a SakuraBot for another server at the time of writing the bot, and lost a vote that would have made the bot be Priscilla.\n\nFor the full story, please use the command `FEH!whyelise full` or use the command in PM.",0x008b8b)
  elsif @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event.respond "When people learn that my main waifu is Sakura, almost invariably, the next question that springs to their mind is: \"If that's the case, then why does your bot take after the **opposite** *Fates* imouto healer?\"\n\nThe short answer is: I already had a SakuraBot for another server at the time of writing the bot, and lost a vote that would have made the bot be Priscilla.\n\nThe long answer is:\n\nBack when the bot that would become EliseBot was created, she was an entirely different beast.  At the time, all the tier lists were quite horrible - ten times worse than everyone says the DefPloy iteration of the Gamepedia list was.  So one of the servers I was in made their own tier list, and the bot that would become Elise was intended to be a server-specific bot to look up information on their custom tier list.\n\nAt this time, the server had a few other bots, and they were all named after *Fire Emblem* characters: Lucina was a mod bot, NinoBot was NinoBot, and Robin(M) was a bot for looking up information in *Awakening* and *Fates*.  In *Heroes* mechanics, that was a red character, a green character, and a blue character.  So the admin of the server suggested that I name the bot after a colorless character so the bots formed a color-balanced team."
    event.respond "When it got time to actually name the bot, a friend on the server suggested Priscilla, and this idea appealed to me because I had been trying to summon for Priscilla for over three months with no success.  \"If the game isn't gonna give me a Priscilla, I'll just make one.\"  So she was coded with the name PriscillaBot - and in fact, that's still the filename of her source code.\n\nThe next day, I wake up to a message from the admin of the server, basically saying \"I like Priscilla as well, but shouldn't we make the bot someone the casual FEH player will recognize?\"  He, knowing my waifuism, suggested Sakura, and I had to turn him down.  So the two of us put the bot's identity up for a vote in the server, and PriscillaBot lost 6-7 in favor of EliseBot.\n\nEventually, Gamepedia started seeing things similarly to the server in question, and the server-specific tier list was depricated.  But by this point, I had already started experimenting with what would become her `stats` command, so Elise, rather than dying off, evolved into the community resource that you know her as today.\n\nAnd yes, during the healer gauntlet, her original server was tossing jokes around left and right that it was a battle for the bot's true identity."
  else
    create_embed(event,"__A word from my developer__","When people learn that my main waifu is Sakura, almost invariably, the next question that springs to their mind is: \"If that's the case, then why does your bot take after the **opposite** *Fates* imouto healer?\"\n\nThe short answer is: I already had a SakuraBot for another server at the time of writing the bot, and lost a vote that would have made the bot be Priscilla.\n\nThe long answer is:\n\nBack when the bot that would become EliseBot was created, she was an entirely different beast.  At the time, all the tier lists were quite horrible - ten times worse than everyone says the DefPloy iteration of the Gamepedia list was.  So one of the servers I was in made their own tier list, and the bot that would become Elise was intended to be a server-specific bot to look up information on their custom tier list.\n\nAt this time, the server had a few other bots, and they were all named after *Fire Emblem* characters: Lucina was a mod bot, NinoBot was NinoBot, and Robin(M) was a bot for looking up information in *Awakening* and *Fates*.  In *Heroes* mechanics, that was a red character, a green character, and a blue character.  So the admin of the server suggested that I name the bot after a colorless character so the bots formed a color-balanced team.",0x008b8b)
    create_embed(event,'',"When it got time to actually name the bot, a friend on the server suggested Priscilla, and this idea appealed to me because I had been trying to summon for Priscilla for over three months with no success.  \"If the game isn't gonna give me a Priscilla, I'll just make one.\"  So she was coded with the name PriscillaBot - and in fact, that's still the filename of her source code.\n\nThe next day, I wake up to a message from the admin of the server, basically saying \"I like Priscilla as well, but shouldn't we make the bot someone the casual FEH player will recognize?\"  He, knowing my waifuism, suggested Sakura, and I had to turn him down.  So the two of us put the bot's identity up for a vote in the server, and PriscillaBot lost 6-7 in favor of EliseBot.\n\nEventually, Gamepedia started seeing things similarly to the server in question, and the server-specific tier list was depricated.  But by this point, I had already started experimenting with what would become her `stats` command, so Elise, rather than dying off, evolved into the community resource that you know her as today.",0xCF4030,"And yes, during the healer gauntlet, her original server was tossing jokes around left and right that it was a battle for the bot's true identity.")
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
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
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

def today_in_feh(event,bot)
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  str="Time elapsed since today's reset: #{"#{t.hour} hours, " if t.hour>0}#{"#{'0' if t.min<10}#{t.min} minutes, " if t.hour>0 || t.min>0}#{'0' if t.sec<10}#{t.sec} seconds"
  str="#{str}\nTime until tomorrow's reset: #{"#{23-t.hour} hours, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds"
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  str="#{str}\nThe Arena season ends in #{"#{15-t.hour} hours, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete your daily Arena-related quests before then!" if date%7==4 && 15-t.hour>=0
  str="#{str}\nThe Aether Raid season ends in #{"#{15-t.hour} hours, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete any Aether-related quests before then!" if date%7==3 && 15-t.hour>=0
  str="#{str}\nThe monthly quests end in #{"#{23-t.hour} hours, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutes, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} seconds.  Complete them before then!" if t.month != (t+24*60*60).month
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
    str="#{str}\nWeekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%6+1}/6(Saturday) - #{week_from(date,0)%12+1}/12(Thursday)"
  end
  str2='__**Today in** ***Fire Emblem Heroes***__'
  str2="#{str2}\nTraining Tower color: #{colors[date%colors.length]}"
  str2="#{str2}\nDaily Hero Battle: #{dhb[date%dhb.length]}"
  str2="#{str2}\nWeekend SP bonus!" if [1,2].include?(date%7)
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
    bonus_load()
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b=@bonus_units.reject{|q| q[1]!='Arena' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2"There are no known quantities about Arena."
    else
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      m=k.length%2
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      str2="__**Current Arena Season**__\n*Bonus Units:*\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}\n*Elemental season:* #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}"
    end
    str=extend_message(str,str2,event,2)
    b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2="There are no Tempest Trials events going on."
    else
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      m=k.length%2
      str2="__**Current Tempest Trials+ Bonus Units**__\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}"
    end
    str=extend_message(str,str2,event,2)
    b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2"There are no known quantities about Aether Raids."
    else
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      m2=k.length%2
      m="#{b[0][3][0]} (O), #{b[0][3][1]} (D)"
      m="#{b[0][3][0]} (O/D)" if b[0][3][0]==b[0][3][1]
      str2="__**Current Aether Raids Season**__\n*Bonus Units:*\n#{k[0,k.length/2+m2].join(', ')}\n#{k[k.length/2+m2,k.length/2].join(', ')}\n*Current Bonus Structures:* #{m}"
    end
    str=extend_message(str,str2,event,2)
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
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0]!=tm}
    c2=c.reject{|q| q[2].nil? || q[2][0]!=tm}
    str2="#{str2}\nNew Banners: #{b2.map{|q| "*#{q[0]}*"}.join('; ')}" if b2.length>0
    str2="#{str2}\nNew Events: #{c2.map{|q| "*#{q[0]} (#{q[1]})*"}.join('; ')}" if c2.length>0
    tm="#{t3.year}#{'0' if t3.month<10}#{t3.month}#{'0' if t3.day<10}#{t3.day}".to_i
    bonus_load()
    b=@bonus_units.reject{|q| q[1]!='Arena' || q[2][0].split('/').reverse.join('').to_i != tm}
    unless b.length<=0
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      m=k.length%2
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      str2="#{str2}\nTomorrow's Arena Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}\nElemental season: #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}"
    end
    b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][0].split('/').reverse.join('').to_i != tm}
    unless b.length<=0
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      str2="#{str2}\nTomorrow's Tempest Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}"
    end
    b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][0].split('/').reverse.join('').to_i != tm}
    unless b.length<=0
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      m="#{b[0][3][0]} (O), #{b[0][3][1]} (D)"
      m="#{b[0][3][0]} (O/D)" if b[0][3][0]==b[0][3][1]
      str2="#{str2}\nTomorrow's Aether Raids Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}\nTomorrow's Aether Raids Bonus Structures: #{m}"
    end
    str=extend_message(str,str2,event,2)
  else
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b2=b.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i>tm || q[4].split(', ')[1].split('/').reverse.join('').to_i<tm}
    c2=c.reject{|q| q[2].nil? || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    str="#{str}\nCurrent Banners: #{b2.map{|q| "*#{q[0]}*"}.join('; ')}"
    str="#{str}\nCurrent Events: #{c2.map{|q| "*#{q[0]} (#{q[1]})*"}.join('; ')}"
    bonus_load()
    b=@bonus_units.reject{|q| q[1]!='Arena' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2="There are no known quantities about Arena."
    else
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      str2="Current Arena Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}\nElemental season: #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}"
    end
    str=extend_message(str,str2,event)
    b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2="There are no Tempest Trials events going on."
    else
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      str2="Current Tempest Trials+ Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}"
    end
    str=extend_message(str,str2,event)
    b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][0].split('/').reverse.join('').to_i>tm || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      str2="There are no known quantities about Aether Raids."
    else
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      m="#{b[0][3][0]} (O), #{b[0][3][1]} (D)"
      m="#{b[0][3][0]} (O/D)" if b[0][3][0]==b[0][3][1]
      str2="Current Aether Raids Bonus Units: #{k.map{|q| "*#{q}*"}.join(', ')}\nCurrent Aether Raids Bonus Structures: #{m}"
    end
    str=extend_message(str,str2,event)
  end
  event.respond str
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
  idx=10 if ['legendary','legendaries','legend','legends'].include?(type.downcase)
  idx=11 if ['tactics','tactic','drills','drill','tacticsdrills','tactics_drills','tacticsdrill','tactics_drill','tacticdrills','tactic_drills','tacticdrill','tactic_drill'].include?(type.downcase)
  idx=12 if ['arena','bonus','arenabonus','arena_bonus'].include?(type.downcase)
  idx=13 if ['tempest','tempestbonus','tempest_bonus'].include?(type.downcase)
  idx=14 if ['aether','aetherbonus','aether_bonus','raid','raidbonus','raid_bonus','raids','raidsbonus','raids_bonus'].include?(type.downcase)
  if idx<0 && !safe_to_spam?(event)
    event.respond "I will not show everything at once.  Please use this command in PM, or narrow your search using one of the following terms:\nTower, Training_Tower, Color, Shard, Crystal\nFree, 1\\*, 2\\*, F2P, FreeHero\nSpecial, Special_Training\nGHB\nGHB2\nRival, Domain(s), RD, Rival_Domain(s)\nBlessed, Garden(s), Blessing, Blessed_Garden(s)\nTactics_Drills, Tactic(s), Drill(s)\nBanner(s), Summon(ing)(s)\nEvent(s)\nLegendary/Legendaries, Legend(s)\nArena, ArenaBonus, Arena_Bonus\nTempest, TempestBonus, Tempest_Bonus\nAether, AetherBonus, Aether_Bonus\nBonus"
    return nil
  end
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  msg="Date assuming reset is at midnight: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  msg=extend_message(msg,"Days since game release: #{longFormattedNumber(date)}",event)
  if event.user.id==167657750971547648 && @shardizard==4
    msg=extend_message(msg,"Daycycles: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12",event)
    msg=extend_message(msg,"Weekcycles: #{week_from(date,3)%4+1}/4(Sunday) - #{week_from(date,2)%6+1}/6(Saturday) - #{week_from(date,0)%12+1}/12(Thursday)",event)
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
  msg=extend_message(msg,msg3,event,2) if [-1,5].include?(idx)
  msg=extend_message(msg,"Try the command again with \"GHB2\" if you're looking for the second set of Grand Hero Battles.\nYou may also want to try \"Events\" if you're looking for non-cyclical GHBs.",event,2) if [4].include?(idx)
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
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      m=k.length%2
      element=b[0][3][0]
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{element}"}
      element=b[0][3][1]
      moji2=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Boost_#{element}"}
      msg=extend_message(msg,"__**Current Arena Season**__\n*Bonus Units:*\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}\n*Elemental season:* #{moji[0].mention}#{b[0][3][0]}, #{moji2[0].mention}#{b[0][3][1]}",event,2)
      if b.length>1
        k2=b[1][0].map{|q| q.gsub('Lavatain','Laevatein')}
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
    t-=60*60*timeshift
    timeshift-=1 unless t.dst?
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b=@bonus_units.reject{|q| q[1]!='Tempest' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      msg=extend_message(msg,"There are no known quantities about Tempest Trials+.",event,2)
    else
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      if b[0][2][0].split('/').reverse.join('').to_i<tm || b.length>1
        msg2="__**Current Tempest Trials+ Bonus Units**__"
      else
        msg2="__**Future Tempest Trials+ Bonus Units**__"
      end
      m=k.length%2
      msg=extend_message(msg,"#{msg2}\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}",event,2)
      if b.length>1
        k=b[1][0].map{|q| q.gsub('Lavatain','Laevatein')}
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
    t-=60*60*timeshift
    timeshift-=1 unless t.dst?
    tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
    b=@bonus_units.reject{|q| q[1]!='Aether' || q[2][1].split('/').reverse.join('').to_i<tm}
    if b.length<=0
      msg=extend_message(msg,"There are no known quantities about Aether Raids.",event,2)
    else
      k=b[0][0].map{|q| q.gsub('Lavatain','Laevatein')}
      m=k.length%2
      struct="#{b[0][3][0]} (O), #{b[0][3][1]} (D)"
      struct="#{b[0][3][0]} (O/D)" if b[0][3][0]==b[0][3][1]
      msg=extend_message(msg,"__**Current Aether Raids Season**__\n*Bonus Units:*\n#{k[0,k.length/2+m].join(', ')}\n#{k[k.length/2+m,k.length/2].join(', ')}\n*Elemental season:* #{struct}",event,2)
      if b.length>1
        k2=b[1][0].map{|q| q.gsub('Lavatain','Laevatein')}
        m=k2.length%2
        d=b[1][2][0].split('/').map{|q| q.to_i}
        struct="#{b[1][3][0]} (O), #{b[1][3][1]} (D)"
        struct="#{b[1][3][0]} (O/D)" if b[1][3][0]==b[1][3][1]
        msg=extend_message(msg,"__**Next Aether Raids Season** (starting #{d[0]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][d[1]]} #{d[2]})__\n*Bonus Units:*#{"\n#{k2[0,k2.length/2+m].join(', ')}\n#{k2[k2.length/2+m,k2.length/2].join(', ')}" unless k2==k || k2.length<=1}#{'(same as current)' if k2==k}#{'(unknown)' if k2.length<=1}\n*Bonus Structures:* #{struct}",event,2)
      end
    end
  end
  event.respond msg unless [10,12,13,14].include?(idx)
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

def snagstats(event,bot,f=nil,f2=nil)
  nicknames_load()
  groups_load()
  g=get_markers(event)
  data_load()
  metadata_load()
  f='' if f.nil?
  f2='' if f2.nil?
  bot.servers.values(&:members)
  k=bot.servers.length
  k=1 if @shardizard==4 # Debug shard shares the five emote servers with the main account
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
      elsif event.server.nil? && event.user.id==167657750971547648
        if k.reject{|q| q.include?('~~')}.length.zero?
          event << "The following unit#{"s" unless k.length==1} have no global aliases: #{list_lift(k.map{|q| q.gsub('~~','')},"and")}"
        else
          event << "The following unit#{"s" unless k.reject{|q| q.include?('~~')}.length==1} have no global aliases: #{list_lift(k.reject{|q| q.include?('~~')},"and")}"
          event << "The following unit#{"s" unless k.reject{|q| !q.include?('~~')}.length==1} are fake: #{list_lift(k.reject{|q| !q.include?('~~')}.map{|q| q.gsub('~~','')},"and")}"
        end
      else
        event << "The following unit#{"s" unless k.length==1} have no global aliases: #{list_lift(k,"and")}"
      end
    end
    event << ''
    event << "**There are #{longFormattedNumber(srv_spec.length)} server-specific [single-unit] aliases.**"
    if event.server.nil? && @shardizard==4
      event << "Due to being the debug version, I cannot show more information."
    elsif event.server.nil?
      event << "Servers you and I share account for #{@aliases.reject{|q| q[2].nil? || q[2].reject{|q2| q2==285663217261477889 || bot.user(event.user.id).on(q2).nil?}.length<=0}.length} of those."
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
    event << "*Bannerless* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='Bannerless'}][1].length)} current members) - Any unit that has never been a focus unit on a banner."
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
    event << "*Worse Than Liki* (#{longFormattedNumber(gg[gg.find_index{|q| q[0]=='WorseThanLiki'}][1].length)} current members) - Any unit with every stat equal to or less than the same stat on Tiki(Young)(Earth), excluding Tiki(Young)(Earth) herself."
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
end
