$spanishShard=-2
$spanish_Natures=[['Amable','Resistance','Defense'], # this is a list of all the nature names that can be displayed, with the affected stats
                  ['Osada','Defense','Attack'],
                  ['Miedosa','Speed','Attack'],
                  ['Huraña','Attack','Defense'],
                  ['Afable','Attack','Defense'],
                  ['Activa','Speed','Defense'],
                  ['Agitada','Defense','Attack'],
                  ['Serena','Resistance','Attack'],
                  ['Cauta','Resistance','Attack'],
                  ['Alegre','Speed','Attack'],
                  ['Ingenua','Speed','Resistance'],
                  ['Pícara','Attack','Resistance'],
                  ['Floja','Defense','Resistance'],
                  ['Alocada','Attack','Resistance'],
                  ['Plácida','Defense','Speed'],
                  ['Audaz','Attack','Speed'],
                  ['Mansa','Attack','Speed'],
                  ['Grosera','Resistance','Speed'],
                  ["`\u22C0`Ímpetu",'Attack','HP',true],
                  ["`\u22C0`Intelecto",'Attack','HP',true],
                  ["`\u22C0`Rápidad",'Speed','HP',true],
                  ["`\u22C0`Robustez",'Defense','HP',true],
                  ["`\u22C0`Aplomo",'Resistance','HP',true],
                  ["`\u22C1`Debilidad",'HP','Attack',true],
                  ["`\u22C1`Apatía",'HP','Attack',true],
                  ["`\u22C1`Lentitud",'HP','Speed',true],
                  ["`\u22C1`Fragilidad",'HP','Defense',true],
                  ["`\u22C1`Ansiedad",'HP','Resistance',true]]
$spanish_months=[['','enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'],
                 ['','January','February','March','April','May','June','July','August','September','October','November','December']]
$spanish_wday=['domingo','lunes','martes','miércoles','jueves','viernes','sábado']

def texto_ayuda(event,bot,command=nil,subcommand=nil)
  command='' if command.nil?
  k=0
  k=event.server.id unless event.server.nil?
  if ['help','commands','command_list','commandlist','comandos','ayuda','auxilio'].include?(command.downcase)
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
    if ['alts','alt','alternate','alternates','alternative','alternatives'].include?(subcommand.downcase)
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
      create_embed(event,"**#{command.downcase}**","Returns:\n- the number of servers I'm in\n- the numbers of units, skills, structures, accessories, and items in the game\n- the numbers of aliases of each type I keep track of\n- the numbers of groups I keep track of\n- how long of a file I am.\n\nYou can also include the following words to get more specialized data:\nUnit(s), Character(s), Char(a)(s)\nAlt(s)\nSkill(s)\nStructure(s), Struct(s)\nAccessory, Accessories\nItem(s)\nAlias(es), Name(s), Nickname(s)\nGroup(s), Grouping(s)\nCode, Line(s), SLOC#{"\n\nAs the bot developer, you can also include a server ID number to snag the shard number, owner, and my nickname in the specified server." if event.user.id==167657750971547648}",0x40C0F0)
    end
  elsif ['randomunit','randunit','unitrandom','unitrand','randomstats','statsrand','statsrandom','randstats'].include?(command.downcase) || (['random','rand','aleatoria','aleatorio'].include?(command.downcase) && ['hero','personaje','unit','stats'].include?("#{subcommand}".downcase)) || (['unit','stats'].include?(command.downcase) && ['random','rand','aleatoria','aleatorio'].include?("#{subcommand}".downcase))
    lookout=$origames.reject{|q| q[0].length>4 && q[0][0,4]=='FE14'}
    d=[]
    for i in 0...lookout.length
      d.push("**#{lookout[i][2].gsub("#{lookout[i][0]} - ",'').gsub(" (All paths)",'')}**\n#{lookout[i][1].join(', ')}")
    end
    if d.join("\n\n").length>=1900 || !safe_to_spam?(event)
      d=lookout.map{|q| q[0]}
      if d.length>50 && !safe_to_spam?(event)
        create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','personaje','aleatoria','aleatorio','hero','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_mas_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, and game options can be displayed if you use this command in PM.",0xD49F61)
      else
        create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','personaje','aleatoria','aleatorio','hero','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_mas_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, by using the words below.",0xD49F61)
        create_embed(event,'Games','',0x40C0F0,nil,nil,triple_finish(d))
      end
    else
      create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['random','rand','personaje','aleatoria','aleatorio','hero','unit','stats'].include?(command.downcase)}** __\*filters__","Picks a random unit within the desired group, and displays that unit's stats and skills.\n\n#{disp_mas_info(event,2)}\n\nYou can also group units by gender.\nYou can group by game as well, by using the words below.",0xD49F61)
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
  elsif ['data','hero','unit','personaje'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats, and skills.",0xD49F61)
  elsif ['attackicon','attackcolor','attackcolors','attackcolour','attackcolours','atkicon','atkcolor','atkcolors','atkcolour','atkcolours','atticon','attcolor','attcolors','attcolour','attcolours','staticon','statcolor','statcolors','statcolour','statcolours','iconcolor','iconcolors','iconcolour','iconcolours'].include?(command.downcase) || (['stats','stat'].include?(command.downcase) && ['color','colors','colour','colours'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['color','colors','colour','colours'].include?("#{subcommand}".downcase)}**","Explains the reasoning behind the multiple Attack stat icons - <:StrengthS:514712248372166666> <:MagicS:514712247289774111> <:FreezeS:514712247474585610>",0xD49F61)
  elsif ['divine','devine','code','path'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows all Divine Code paths that the unit named `name` can be found on.',0xD49F61)
  elsif ['struct','struncture','estructura'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows data on the Aether Raids or Mjolnir Strike structure named `name`.',0xD49F61)
  elsif ['aoe','area'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __type__","Shows the range of all AoE specials of the type `type`.\nIf `type` is unspecified in PM, shows the range of all AoE specials.",0xD49F61)
  elsif ['item','articulo','artículo'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows data on the item named `name`.',0xD49F61)
  elsif ['accessory','acc','accessorie','accesorio','accesoria'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows data on the accessory named `name`.',0xD49F61)
  elsif ['arena','arenabonus','arena_bonus','bonusarena','bonus_arena'].include?(command.downcase) || (['bonus','extra'].include?(command.downcase) && ['arena'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['arena'].include?("#{subcommand}".downcase)}**",'Displays current and future Arena Bonus Units',0xD49F61)
  elsif ['fragorosas','fragorosa','resonant','resonantbonus','resonant_bonus','bonusresonant','bonus_resonant','resonance','resonancebonus','resonance_bonus','bonusresonance','bonus_resonance'].include?(command.downcase) || (['bonus','extra'].include?(command.downcase) && ['fragorosas','fragorosa','resonant','resonance'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['arena'].include?("#{subcommand}".downcase)}**",'Displays current and future Resonant Blades Games',0xD49F61)
  elsif ['tempest','tempestbonus','tempest_bonus','bonustempest','bonus_tempest','tt','ttbonus','tt_bonus','bonustt','bonus_tt','tormenta'].include?(command.downcase) || (['bonus','extra'].include?(command.downcase) && ['tempest','tt','tormenta'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['tempest','tt','tormenta'].include?("#{subcommand}".downcase)}**",'Displays current and future Tempest Trials Bonus Units',0xD49F61)
  elsif ['aetherbonus','aether_bonus','aethertempest','aether_tempest','raid','raidbonus','raid_bonus','bonusraid','bonus_raid','raids','raidsbonus','raids_bonus','bonusraids','aether','bonus_raids','etér','eter'].include?(command.downcase) || (['bonus','extra'].include?(command.downcase) && ['aether','raid','raids','etér','eter'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['aether','raid','raids','etér','eter'].include?("#{subcommand}".downcase)}**",'Displays current and future Aether Raids Bonus Units',0xD49F61)
  elsif ['bonus','extra'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Displays current and future Bonus Units for Arena, Tempest Trials, and Aether Raids.',0xD49F61)
  elsif ['skillrarity','skilrarity','onestar','twostar','threestar','fourstar','fivestar','skill_rarity','one_star','two_star','three_star','four_star','five_star'].include?(command.downcase) || (['skill'].include?(command.downcase) && ['rarity','rarities'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['rarity','rarities'].include?("#{subcommand}".downcase)}**",'Explains why some units have skills listed at lower rarities than they are available at.',0xD49F61)
  elsif ['color','colors','colour','colours','colores'].include?(command.downcase) || (['skill','habilidad','skil'].include?(command.downcase) && ['color','colors','colour','colours','colores'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['color','colors','colour','colours'].include?("#{subcommand}".downcase)}** __name__","Shows data on the skill `name`.\n\nIf the skill is a weapon that can be refined, also shows all possible refinements.\nIncluding the word \"default\" or \"base\" in these cases will make this command only show the default weapon.\nOn the flip side, including the word \"refined\" will make this command only show data on the refinements.\n\nThis version of the command causes the display to sort the units by color instead of rarity, allowing users to see what color they should summon when looking for a particular skill.",0xD49F61)
  elsif ['skill','skil','habilidad'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows data on the skill `name`.\n\nIf the skill is a weapon that can be refined, also shows all possible refinements.\nIncluding the word \"default\" or \"base\" in these cases will make this command only show the default weapon.\nOn the flip side, including the word \"refined\" will make this command only show data on the refinements.\n\nFollowing the command with the word \"colo(u)rs\" will cause the display to sort the units by color instead of rarity, allowing users to see what color they should summon when looking for a particular skill.",0xD49F61)
  elsif ['tinystats','smallstats','smolstats','microstats','squashedstats','sstats','statstiny','statssmall','statssmol','statsmicro','statssquashed','statss','stattiny','statsmall','statsmol','statmicro','statsquashed','sstat','tinystat','smallstat','smolstat','microstat','squashedstat','tiny','small','micro','smol','squashed','littlestats','littlestat','statslittle','statlittle','little','pequeño','pequeña','pequeno','pequena'].include?(command.downcase) || (['stat','stats'].include?(command.downcase) && ['tiny','small','micro','smol','squashed','little','pequeño','pequeña','pequeno','pequena'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['stat','stats'].include?(command.downcase)}** __name__","Shows `name`'s stats.",0xD49F61)
    disp_mas_info(event,-2) if safe_to_spam?(event)
  elsif ['big','tol','macro','large','huge','massive','giantstats','bigstats','tolstats','macrostats','largestats','hugestats','massivestats','giantstat','bigstat','tolstat','macrostat','largestat','hugestat','massivestat','statsgiant','statsbig','statstol','statsmacro','statslarge','statshuge','statsmassive','statgiant','statbig','stattol','statmacro','statlarge','stathuge','statmassive','statol','grande','enorme'].include?(command.downcase) || (['stat','stats'].include?(command.downcase) && ['giant','big','tol','macro','large','huge','massive','grande','enorme'].include?("#{subcommand}".downcase))
    create_embed(event,"**#{command.downcase}#{" #{subcommand.downcase}" if ['stat','stats'].include?(command.downcase)}** __name__","Shows `name`'s weapon color/type, movement type, stats, skills, and all possible modifiers.",0xD49F61)
    disp_mas_info(event) if safe_to_spam?(event)
  elsif ['stats','stat'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__","Shows `name`'s weapon color/type, movement type, and stats.",0xD49F61)
    disp_mas_info(event) if safe_to_spam?(event)
  elsif ['healstudy','studyheal','heal_study','study_heal','heal','curar','cura'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine how much is healed with each healing staff.',0xD49F61)
  elsif ['procstudy','studyproc','proc_study','study_proc','proc'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine how much extra damage is dealt when each Special skill procs.',0xD49F61)
  elsif ['phasestudy','studyphase','phase_study','study_phase','phase','fase','fases'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Takes the stats of the unit `name` and uses them to determine the actual stats the unit has during combat.',0xD49F61)
    disp_mas_info(event,-1) if safe_to_spam?(event)
  elsif ['study','statstudy','statsstudy','studystats','estudio','estudia','estudiar'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the level 40 stats for the unit `name` for a combination of multiple rarities with 0, 5, and 10 merges.',0xD49F61)
  elsif ['summonpool','summon_pool','pool'].include?(command.downcase) || (['summon'].include?(command.downcase) && "#{subcommand}".downcase=='pool')
    create_embed(event,"**#{command.downcase}#{" pool" if command.downcase=='summon'}** __*colors__","Shows the summon pool for the listed color.\n\nIn PM, all colors listed will be displayed, or all colors if none are specified.\nIn servers, only the first color listed will be displayed.",0xD49F61)
  elsif (Summon_servers.include?(k) || [-1,4].include?(Shardizard)) && ['summon'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*colors__","Simulates summoning on a randomly-chosen banner.\n\nIf given `colors`, auto-cracks open any orbs of said colors.\nOtherwise, requires a follow-up response of numbers.\n\nYou can include the word \"current\" or \"now\" to force me to choose a banner that is currently available in-game.\nThe words \"upcoming\" and \"future\" allow you to force a banner that will be available in the future.\nYou can also include one or more of the words below to force the banner to fit into those categories.\n\n**This command is only available in certain servers**.",0x9E682C)
    w=$skilltags.reject{|q| q[2]!='Banner' || ['Current','Upcoming'].include?(q[0])}.map{|q| q[0]}.sort
    create_embed(event,'Banner types','',0x40C0F0,nil,nil,triple_finish(w)) if safe_to_spam?(event) || w.length<=50
  elsif ['effhp','eff_hp'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the effective HP data for the unit `name`.',0xD49F61)
  elsif ['pair','pairup','pair_up','pocket','agrupar','agrupa','par','bolsillo'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows the stats the unit `name` gives to the main unit when `name` is the cohort in a Pair-Up pair.',0xD49F61)
    disp_mas_info(event,-3) if safe_to_spam?(event)
  elsif ['natures','naturalezas'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a chart with my nature names.',0xD49F61)
  elsif ['growths','growth','gps','gp','crecimientos'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a chart and explanation on how growths work, and how this creates what the fandom has dubbed "superboons" and "superbanes".',0xD49F61)
  elsif ['merges','fusiona'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with an explanation on how stats are affected by merging units.',0xD49F61)
  elsif ['tools','links','tool','link','resources','resources','útiles','utiles','útile','utile','vínculo','vinculo','vínculos','vinculos','recursos','recurso'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a list of links useful to players of *Fire Emblem Heroes*.',0xD49F61)
  elsif ['score','puntaje'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Responds with an explanation on how a unit's Arena Score is calculated.",0xD49F61)
  elsif ['flowers','flower'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with a link to a page with a random flower.',0xD49F61)
  elsif ['donation','donate','donacion'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Responds with information regarding potential donations to my developer.',0xD49F61)
  elsif ['headpat','mima'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Causes the invoker to try to headpat me.',0xD49F61)
  elsif ['alts','alt'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Responds with a list of alts that the character has in *Fire Emblem Heroes*.',0xD49F61)
  elsif ['skills','skils','fodder','manual','book','combatmanual','habilidades','pienso','libro','manualdecombate'].include?(command.downcase)
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
  elsif ['daily','dailies','today','todayinfeh','today_in_feh','now','hoy','diarios','diario','diaria','ahora'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Shows the day's in-game daily events.\nIf in PM, will also show tomorrow's.",0xD49F61)
  elsif ['next','schedule','manana','manyana','mañana'].include?(command.downcase)
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
    create_embed(event,"**#{command.downcase}** __*allies__","Shows the BST of the units listed in `allies`.  If more than four characters are listed, I show both the BST of all those listed and the BST of the first four listed.\n\n#{disp_mas_info(event,1)}",0xD49F61)
  elsif ['effect'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**",'Lists all weapons that can be refined to obtain an Effect Mode in the weapon refinery.',0xD49F61)
  elsif ['refinery','refine'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Lists all weapons that can be refined or evolved in the weapon refinery, organized by whether they use Divine Dew or Refining Stones.\n\nYou can also include the word \"Effect\" in your message to show only weapons that get Effect Mode refines.",0xD49F61)
  elsif ['prf','prfs'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Lists all skills that are PRF to one or more units.",0xD49F61)
  elsif ['legendary','legendaries','mythic','mythicals','mythics','mythicals','mystics','mystic','mysticals','mystical','legend','legends','legendarys','legendario','legendarios','legendaria','legendarias','mítica','míticas','mitica','miticas','mítico','míticos','mitico','miticos','mística','místicas','mistica','misticas','místico','místicos','mistico','misticos'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Lists all of the Legendary and Mythic heroes, sorted by up to three defined filters.\nBy default, will sort by __Element__ and then the non-HP __stat__ boost given by the hero.\n\nPossible filters (in order of priority when applied) :\nElement(s), Flavor(s), Affinity/Affinities\nStat(s), Boost(s)\nWeapon(s)\nColo(u)r(s)\nMove(s), Movement(s)\nNext, Time, Future, Month(s)",0xD49F61)
  elsif ['games','juego','juegos'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows a list of games that the unit `name` is in.',0xD49F61)
  elsif ['banners','banner','pancarta','pancartas'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __name__",'Shows a list of banners that the unit `name` has been a focus unit on.',0xD49F61)
  elsif ['rand','random'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__",'Generates a random unit with random, but still valid, stats.',0xD49F61)
  elsif ['compare','comparison'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*allies__","Compares the units listed in `allies`.  Shows each set of stats, as well as an analysis.\nThis command can compare anywhere between two and ten units.\n\n#{disp_mas_info(event,1)}",0xD49F61)
  elsif ['compareskills','compareskill','skillcompare','skillscompare','comparisonskills','comparisonskill','skillcomparison','skillscomparison','compare_skills','compare_skill','skill_compare','skills_compare','comparison_skills','comparison_skill','skill_comparison','skills_comparison','skillsincommon','skills_in_common','commonskills','common_skills'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __*allies__","Compares the units listed in `allies`.  Shows the skills that the units have in common.\nThis command can compare exactly two units.\n\n#{disp_mas_info(event,1)}",0xD49F61)
  elsif ['bestamong','bestin','beststats','higheststats','highest','best','highestamong','highestin','mejor'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the best in each stat.\n\n#{disp_mas_info(event,2)}",0xD49F61)
  elsif ['worstamong','worstin','worststats','loweststats','lowest','lowestamong','lowestin','worst','peor'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then finds the unit(s) with the worst in each stat.\n\n#{disp_mas_info(event,2)}",0xD49F61)
  elsif ['average','mean','promedio'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units that fit in the `filters`, then calculates their average in each stat.\n\n#{disp_mas_info(event,2)}",0xD49F61)
  elsif ['art','artist','arte','artista'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __unit__ __art type__","Displays `unit`'s character art.  Defaults to their normal portrait, but can be adjusted to other portraits with the following words:\n*Default Attacking Image:* Battle/Battling, Attack/Atk/Att\n*Special Proc Image:* Critical/Crit, Special, Proc\n*Damaged Art:* Damage/Damaged, LowHP/LowHealth, Injured\n*In-game Sprite:* Sprite (only available for units who have profiles on the official website)",0xD49F61)
  elsif ['find','search','lookup','encontra','busca','encontrar','buscar'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['hero','heroes','heros','unit','char','character','person','units','chars','charas','chara','people','personaje','personajes'].include?(subcommand.downcase)
      lookout=$origames.reject{|q| q[0].length>4 && q[0][0,4]=='FE14'}
      d=[]
      for i in 0...lookout.length
        d.push("**#{lookout[i][2].gsub("#{lookout[i][0]} - ",'').gsub(" (All paths)",'')}**\n#{lookout[i][1].join(', ')}")
      end
      if d.join("\n\n").length>=1900 || !safe_to_spam?(event)
        d=lookout.map{|q| q[0]}
        if d.length>50 && !safe_to_spam?(event)
          create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list.\n\n#{disp_mas_info(event,2)}\n\nYou can also search for units by gender.\nYou can search by game as well, and game options can be displayed if you use this command in PM.",0xD49F61)
        else
          create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list.\n\n#{disp_mas_info(event,2)}\n\nYou can also search for units by gender.\nYou can search by game as well, by using the words below.",0xD49F61)
          create_embed(event,'Games','',0x40C0F0,nil,nil,triple_finish(d))
        end
      else
        create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list.\n\n#{disp_mas_info(event,2)}\n\nYou can also search for units by gender.\nYou can search by game as well, by using the words below.",0xD49F61)
        create_embed(event,'Games',d.join("\n\n"),0x40C0F0)
      end
    elsif ['skill','skills','habilidades','habilidad'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list.\n\n#{disp_mas_info(event,3)}#{"\n\nI also have tags for weapon and passive \"flavors\".  Use this command in PM to see them." unless safe_to_spam?(event)}",0xD49F61)
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
    elsif ['summon','summons','banner','banners','pancarta','pancartas'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all banners which match your defined filters, then displays the resulting list.",0xD49F61)
      w=$skilltags.reject{|q| q[2]!='Banner' || ['Current','Upcoming'].include?(q[0])}.map{|q| q[0]}.sort
      create_embed(event,'Banner types','',0x40C0F0,nil,nil,triple_finish(w)) if safe_to_spam?(event) || w.length<=50
    else
      create_embed(event,"**#{command.downcase}** __\*filters__","Combines the results of `FEH!find unit` and `FEH!find skill`, showing them in a single embed.  This combined form is particularly useful when looking at weapon types, so you can see all the weapons *and* all the units that can use them side-by-side.\n\n#{disp_mas_info(event,4)}",0xD49F61)
    end
  elsif ['setmarker'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __letter__","Sets the server's \"marker\", allowing for server-specific custom units and skills.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['backup'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}** __item__","Backs up the alias list or the group list, depending on the word used as `item`.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['reload'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Reloads specified data.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
  elsif ['status','avatar','avvie','estado'].include?(command.downcase)
    create_embed(event,"**#{command.downcase}**","Shows my current avatar, status, and reason for such.\n\nWhen used by my developer with a message following it, sets my status to that message.",0xD49F61)
  elsif ['edit','editar','edita'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['create','crear'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*stats__","Allows me to create a new donor unit with the character `unit` and stats described in `stats`.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['promote','rarity','feathers','promover','promove','rareza','plumas'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","Causes me to promote the donor unit with the name `unit`.\n\nIf `number` is defined, I will promote the donor unit that many times.\nIf not, I will promote them once.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['remove','delete','send_home','sendhome','fodder','elimina','eliminar'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Removes a unit from the donor units attached to the invoker.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['merge','combine','fusiona','combina','combinar'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __number__","Causes me to merge the donor unit with the name `unit`.\n\nIf `number` is defined, I will merge the donor unit that many times.\nIf not, I will merge them once.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['flower','flowers','dragonflower','dragonflowers','flor','flores','dracoflor','dracoflores'].include?(subcommand.downcase)
      create_embed(event,"**edit #{subcommand.downcase}** __unit__ __number__","Causes me to equip the donor unit with the name `unit`, with an additional dragonflower.\n\nIf `number` is defined, I will equip that many dragonflowers.\nIf not, I will equip one.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['nature','ivs','naturaleza'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*effects__","Causes me to change the nature of the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['equip','skill','habilidad','equipar','equipa'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill name__","Equips the skill `skill name` on the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['seal','insignia'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill name__","Equips the skill seal `skill name` on the donor unit with the name `unit`\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['refine','refinery','refinement','refina','refinar'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*refinement__","Refines the weapon equipped by the donor unit with the name `unit`, using the refinement `refinement`\n\nIf no refinement is defined and the equipped weapon has an Effect Mode, defaults to that.\nOtherwise, throws an error message if no refinement is defined.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['unsupport','unmarry','unmarriage','divorce','divorcio'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to remove the support rank of the donor unit with the name `unit`.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['support','marry','marriage','amistad','matrimonio','casar','casa'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to change the support rank of the donor unit with the name `unit`.  More than three donor units cannot have support.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['pairup','pair','pair-up','paired','agrupar','agrupa','par'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit1__ __unit2__","Allows me to pair up the two listed donor units.  This can be shown when looking up either unit alongside the term \"pairup\".\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['resplendant','resplendent','ascension','ascenscion','ascend','resplend'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to Resplendently Ascend the donor unit with the name `unit`.\nIf the donor unit cannot do so, I inform you of this.\nIf the donor unit is already Resplendently Ascended, toggles off their art but keeps their stats.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['kiranface','kiran','face','summoner','summonerface','cara','caradekiran'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to edit the face used by the donor unit based on the summoner.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['forma','quimérica','quimerica'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__","Causes me to toggle the donor unit with the name `unit` into or out of being a Forma Unit.\n\n**This command is only able to be used by certain people**.",0x9E682C)
    elsif ['learn','teach','aprender','aprende','enseñar','enseña','ensenar','ensena'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __unit__ __\*skill types__","Causes me to teach the skills in slots `skill types` to the donor unit with the name `unit`.\n\n**This command is only able to be used by certain people**.",0x9E682C)
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
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list in order based on their SP cost.\n\n#{disp_mas_info(event,3)}",0xD49F61)
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
    create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list in order based on the stats you include.\n\n#{disp_mas_info(event,2)}",0xD49F61)
  elsif ['sort','list','clasificar','clasifica','lista','listar'].include?(command.downcase)
    subcommand='' if subcommand.nil?
    if ['groups','group'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Sorts the groups list alphabetically by group name.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['alias','aliases'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}**","Sorts the alias list alphabetically by unit the alias is for.\n\n**This command is only able to be used by Rot8er_ConeX**.",0x008b8b)
    elsif ['stat','stats','hero','unit','units','personajes','personaje'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list in order based on the stats you include.\n\n#{disp_mas_info(event,2)}",0xD49F61)
    elsif ['skills','skill','habilidad','habilidades'].include?(subcommand.downcase)
      create_embed(event,"**#{command.downcase} #{subcommand.downcase}** __\*filters__","Finds all skills which match your defined filters, then displays the resulting list in order based on their SP cost.\n\n#{disp_mas_info(event,3)}",0xD49F61)
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
      create_embed(event,"**#{command.downcase}** __\*filters__","Finds all units which match your defined filters, then displays the resulting list in order based on the stats you include.\n\n#{disp_mas_info(event,2)}\n\n\nIn addition, you can use `FEH!sort skill` to sort skills by their SP cost.",0xD49F61)
    end
    
  else
    x=0
    x=1 unless safe_to_spam?(event)
    if ['here','aquí','aqui'].include?(command.downcase)
      x=0
      command=''
    end
    event.respond "#{command.downcase} is not a command" if command!='' && command.downcase != 'devcommands'
    str="__**Datos de Personajes**__"
    str="#{str}\n`data` __personaje__ - muestra estadísticas y habilidades (*además `unit`*)"
    str="#{str}\n`stats` __personaje__ - muestra solo las estadísticas"
    str="#{str}\n`grande` __personaje__ - muestra estas estadísticas en un formato más grande"
    str="#{str}\n`habilidades` __personaje__ - muestra solo las habilidades (*además `forraje`*)"
    str="#{str}\n\n`aliases` __personaje__ - mostrar todos los alias del personaje (*además `checkaliases` or `seealiases`*)"
    str="#{str}\n`serveraliases` __personaje__ - muestre los alias específicos del servidor para el personaje"
    str="#{str}\n\n`estudio` __personaje__ - para un estudio del personaje en múltiples rarezas y fusiones"
    str="#{str}\n`effHP` __personaje__ - para un estudio del volumen del personaje (*además `masa`*)"
    str="#{str}\n`curar` __personaje__ - para ver cuánto hace cada bastón de curación"
    str="#{str}\n`proc` __personaje__ - para ver cuánto hace cada Especial dañino"
    str="#{str}\n`fases` __personaje__ - para ver cuáles son las estadísticas reales que tiene el personaje durante el combate"
    str="#{str}\n`agrupar` __personaje__ - para ver las estadísticas que da la personaje durante agrupar (*además `par`*)"
    str="#{str}\n~~Los comandos anteriores se denominan colectivamente \"la suite `estudio`\"~~"
    str="#{str}\n\n`pancartes` __personaje__ - para una lista de pancartas, el personaje se ha centrado en"
    str="#{str}\n`arte` __personaje__ __tipo de arte__ - por el arte del personaje"
    str="#{str}\n`inheritable` __personaje__ - para una lista de todas las habilidades que se pueden aprender"
    str="#{str}\n\n`juegos` __character__ - para una lista de juegos en los que está el personaje"
    str="#{str}\n`alts` __caracter__ - para una lista de todas las personajes que tiene este caracter"
    str="#{str}\n`divine` __personaje__ - para una lista de todas las rutas del Código Divino en la que se puede encontrar la personaje"
    str="#{str}\n\n\n__**Datos de Habilidades**__"
    str="#{str}\n`habilidad` __nombre de habilidad__ - muestra datos sobre una habilidad específica"
    str="#{str}\n`AoE` __tipo__ - para mostrar el rango de todas las habilidades de AoE (*además `area`*)"
    create_embed([event,x],"Prefixes Globales de Comandos: `FEH!` `FEH?` `F?` `E?` `H?`#{"\nPrefix del servidor: `#{@prefixes[event.server.id]}`" if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0}\nTambién puede utilizar `FEH!ayuda Command` para aprender más sobre un comando en particular.\n__**ayuda a EliseBot**__",str,0xD49F61)
    str="__**Datos de Índice Adicionales**__"
    str="#{str}\n`estructura` __nombre de estructura__ - muestra datos sobre una estructura específica"
    str="#{str}\n`articulo` __nombre de articulo__ - muestra datos sobre un artículo específico"
    str="#{str}\n`accesorio` __nombre de accesorio__ - muestra datos sobre un accesorio específico (*además `accesoria`*)"
    str="#{str}\n\n__**Eventos Actuales**__"
    str="#{str}\n`extra` - enumera todos los personajes adicionales para los modos relevantes (*además `arena`, `tormenta`, `éter`, o `fragorosas`*)"
    str="#{str}\n`hoy` - muestra los eventos diarios del juego del día actual (*además `diario`*)"
    str="#{str}\n`siguiente` __type__ - para obtener un cronograma de la próxima vez que ocurran eventos diarios en el juego (*además `calendario`*)"
    str="#{str}\n\n__**Listos**__"
    str="#{str}\n`summonpool` __\\*colores__ - enumera personajes acumulables ordenadas por rareza"
    str="#{str}\n`legendarios` __\\*filtros__ - para una lista ordenada de todos los legendarios"
    str="#{str}\n`míticos` __\\*filtros__ - para una lista ordenada de todos los míticos"
    str="#{str}\n`refinery` - enumera todas las armas refinables (*además `refine`*)"
    str="#{str}\n`prf` - enumera todas las habilidades PRF"
    str="#{str}\n\n__**Búsquedas**__"
    str="#{str}\n`encontra` __\\*filtros__ - genera una lista de personajes y/o habilidades aplicables"
    str="#{str}\n`clasificar` __\\*filtros__ - crea una lista de personajes aplicables y los ordena según las estadísticas especificadas"
    str="#{str}\n`promedio` __\\*filtros__ - encuentra las estadísticas promedio de los personajes aplicables"
    str="#{str}\n`mejor` __\\*filtros__ - encuentra las estadísticas mejores de los personajes aplicables"
    str="#{str}\n`peor` __\\*filtros__ - encuentra las estadísticas peores de los personajes aplicables"
    str="#{str}\n\n__**Comparaciones**__"
    str="#{str}\n`comparar` __\\*aliados__ - compara las estadísticas de los personajes"
    str="#{str}\n`compareskills` __\\*aliados__ - compara las habilidades de los personajes"
    str="#{str}\n\n__**Other Data**__"
    str="#{str}\n`bst` __\\*aliados__"
    create_embed([event,x],"",str,0xD49F61)
    str="__**Metadatos**__"
    str="#{str}\n`útiles` - enumera algunas herramientas aparte de mí que pueden ayudarlo"
    str="#{str}\n\n`aliases` - mostrar todos los alias (*además `checkaliases` o `seealiases`*)"
    str="#{str}\n`serveraliases` - muestre los alias específicos del servidor"
    str="#{str}\n`grupos` - enumera todos los grupos de personajes"
    str="#{str}\n\n`naturalezas` - por ayuda para entender los nombres de naturalezas"
    str="#{str}\n`crecimientos` - para ayudar a comprender cómo funcionan los crecimientos"
    str="#{str}\n`fusiona` - para obtener ayuda para comprender cómo funcionan las fusiones"
    str="#{str}\n`puntaje` - para obtener ayuda para comprender cómo se calcula la puntuación de la arena"
    str="#{str}\n`skillrarity` - explica por qué los personajes tienen habilidades en rarezas más bajas de lo esperado"
    str="#{str}\n`attackcolor` - por una razón para múltiples íconos de ataque"
    str="#{str}\n\n`invite` - para un enlace para invitarme a su servidor"
    str="#{str}\n\n`random` - genera un personaje aleatoria (*además `rand`*)"
    str="#{str}\n\n\n__**Información del Desarrollador**__"
    str="#{str}\n`avatar` - para ver por qué mi avatar es diferente a la norma"
    str="#{str}\n\n`bugreport` __\\*message__ - para enviar a mi desarrollador un informe de error"
    str="#{str}\n`suggestion` __\\*message__ - para enviarle a mi desarrollador una sugerencia de función"
    str="#{str}\n`feedback` __\\*message__ - para enviarle a mi desarrollador otros tipos de comentarios"
    str="#{str}\n~~los tres comandos anteriores son en realidad idénticos, simplemente se les dan entradas únicas para ayudar a las personas a encontrarlos~~"
    str="#{str}\n\n`donate` - para obtener información sobre cómo donar a mi desarrollador"
    str="#{str}\n`whyelise` - para una explicación de cómo se eligió a Elise como la cara del bot"
    str="#{str}\n`snagstats` __tipo__ - para recibir estadísticas relevantes de bots"
    str="#{str}\n`spam` - para determinar si la ubicación actual es segura para enviar respuestas largas a"
    str="#{str}\n\n__**Comando específico del servidor**__\n`summon` \\*colores - para simular la invocación en un estandarte elegido al azar" if !event.server.nil? && Summon_servers.include?(event.server.id)
    create_embed([event,x],"",str,0xD49F61)
    str="__**Aliases**__"
    str="#{str}\n`addalias` __alias nuevo__ __objeto__ - Agrega un nuevo alias específico del servidor"
    str="#{str}\n~~`aliases` __objeto__ (*además `checkaliases` or `seealiases`*)~~"
    str="#{str}\n~~`serveraliases` __objeto__ (*además `saliases`*)~~"
    str="#{str}\n`deletealias` __alias__ - elimina un alias específico del servidor (*además `removealias`*)"
    str="#{str}\n\n__**Grupos**__"
    str="#{str}\n`addgroup` __nombre__ __\\*miembros__ - agrega un grupo específico del servidor"
    str="#{str}\n~~`groups` (*además `checkgroups` o `seegroups`*)~~"
    str="#{str}\n`deletegroup` __nombre__ - elimina un grupo específico del servidor (*además `removegroup`*)"
    str="#{str}\n`removemember` __grupo__ __personaje__ - elimina un solo miembro de un grupo específico del servidor (*además `removefromgroup`*)"
    str="#{str}\n\n__**Canales**__"
    str="#{str}\n`spam` __palanca__ - para permitir que el canal actual sea seguro para enviar respuestas largas a (*además `safetospam` or `safe2spam`*)"
    str="#{str}\n\n__**Personalización**__"
    str="#{str}\n`prefix` __chars__ - para crear o editar el prefix de comando personalizado del servidor"
    create_embed([event,x],"__**Comandos de Administrador del Servidor**__",str,0xC31C19) if is_mod?(event.user,event.server,event.channel)
    str="`devedit` __subcomando__ __personaje__ __\\*efecto__"
    str="#{str}\n\n__**Mjolnr, el Martillo**__"
    str="#{str}\n`ignoreuser` __user id__ - me hace ignorar a un usuario"
    str="#{str}\n`leaveserver` __server id__ - me hace dejar un servidor"
    str="#{str}\n\n__**Comunicación**__"
    str="#{str}\n`status` __\\*mensaje__ - establece mi estado"
    str="#{str}\n`sendmessage` __channel id__ __\\*mensaje__ - envía un mensaje a un canal específico"
    str="#{str}\n`sendpm` __user id number__ __\\*mensaje__ - envía un mensaje privado a un usuario"
    str="#{str}\n\n__**Información del Servidor**__"
    str="#{str}\n`snagstats` - engancha estadísticas relevantes de bot"
    str="#{str}\n`setmarker` __letra__"
    str="#{str}\n\n__**Shards**__"
    str="#{str}\n`reboot` - reinicia este fragmento"
    str="#{str}\n\n__**Almacenamiento de Metadatos**__"
    str="#{str}\n`reload` - recarga los datos de personajes y habilidades"
    str="#{str}\n`backup` __articulo__ - hace una copia de seguridad de la lista (alias/grupo)"
    str="#{str}\n`sort aliases` - ordena la lista de alias alfabéticamente por carácter"
    str="#{str}\n`sort grupo` - ordena la lista de grupos alfabéticamente por nombre de grupo"
    str="#{str}\n\n__**Alias ​​de Multipersonje**__"
    str="#{str}\n`addmulti` __nombre__ __\\*personajes__ - para crear un alias de multipersonaje"
    create_embed([event,x],"__**Bot Developer Commands**__",str,0x008b8b) if event.user.id==167657750971547648 && (x==1 || safe_to_spam?(event))
    event.respond "Si ve el mensaje anterior con solo tres líneas de longitud, utilice el comando `FEH!embeds` para ver mis mensajes como texto sin formato en lugar de incrustados.\n\nPrefixes Globales de Comandos: `FEH!` `FEH?` `F?` `E?` `H?`#{"\nPrefix del servidor: `#{@prefixes[event.server.id]}`" if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0}\nTambién puede utilizar `FEH!ayuda Command` para aprender más sobre un comando en particular.\n\nAl buscar un personaje o habilidad, también tienes la opción de @ mencionarme en un mensaje que incluye el nombre de ese personaje/habilidad." unless x==1
    event.user.pm("Si ve el mensaje anterior con solo tres líneas de longitud, utilice el comando `FEH!embeds` para ver mis mensajes como texto sin formato en lugar de incrustados.\n\nPrefixes Globales de Comandos: `FEH!` `FEH?` `F?` `E?` `H?`#{"\nPrefix del servidor: `#{@prefixes[event.server.id]}`" if !event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0}\nTambién puede utilizar `FEH!ayuda Command` para aprender más sobre un comando en particular.\n\nAl buscar un personaje o habilidad, también tienes la opción de @ mencionarme en un mensaje que incluye el nombre de ese personaje/habilidad.") if x==1
    event.respond "Se te ha enviado un mensaje privado.\nSi desea mostrar la lista de ayuda en este canal, utilice el comando `FEH!ayuda aquí`." if x==1
  end
end

def disp_mas_info(event,mode=0) # used by the `help` command to display info that repeats in multiple help descriptions.
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
  def weapon_spanish(ignoregender=false)
    m=[]
    wgender=''
    if @weapon[1]=='Blade'
      m.push('Filo')
      wgender='M'
    elsif @weapon[1]=='Tome'
      m.push('Tomo')
      wgender='M'
    elsif @weapon[1]=='Dragon'
      m.push("Drag\u00F3n")
      wgender='M'
    elsif @weapon[1]=='Dagger'
      m.push('Daga')
      wgender='F'
    elsif @weapon[1]=='Bow'
      m.push('Arco')
      wgender='M'
    elsif @weapon[1]=='Healer'
      m.push("Curador#{'a' if @gender=='F'}")
      wgender="#{@gender}"
    elsif @weapon[1]=='Beast'
      m.push("Bestia")
      wgender='F'
    elsif @weapon[1]=='Summon Gun'
      m.push('Arma de Convocar')
      wgender='F'
    else
      m.push('Ignoto')
      wgender="#{@gender}"
    end
    if ['Robin (shared stats)','Robin'].include?(@name)
      m.unshift('Cian')
    elsif ['Kris (shared stats)','Kris'].include?(@name)
      m.unshift('Morada')
    elsif @weapon[0]=='Red'
      m.unshift('Roja') if wgender=='F' && !ignoregender
      m.unshift('Rojo') if wgender=='M' || ignoregender
    elsif @weapon[0]=='Blue'
      m.unshift('Azul')
    elsif @weapon[0]=='Green'
      m.unshift('Verde')
    elsif @weapon[0]=='Colorless'
      m.unshift('Gris')
    elsif @weapon[0]=='Purple'
      m.unshift('Morada')
    else
      m.unshift('Ignoto')
    end
    if @weapon[2]=='Fire'
      m.push('Fuego')
    elsif @weapon[2]=='Dark'
      m.push('Ruina')
    elsif @weapon[2]=='Thunder'
      m.push('Trueno')
    elsif @weapon[2]=='Light'
      m.push('Luz')
    elsif @weapon[2]=='Wind'
      m.push('Viento')
    elsif @weapon[2]=='Stone'
      m.push('Roca')
    else
      m.push(@weapon[2]) unless @weapon[2].nil?
    end
    return m
  end
  
  def spanish_gender
    return 'E' if @name=='Kiran'
    return 'A' if @gender=='F'
    return 'O'
  end
  
  def wstring_spanish
    return '*Mago* (Tomo Cian)' if @name=='Robin (shared stats)'
    return '*Cuerpo a cuerpo* (Filo Morado)' if @name=='Kris (shared stats)'
    return '*Espada* (Filo Rojo)' if @weapon==['Red', 'Blade']
    return '*Lanza* (Filo Azul)' if @weapon==['Blue', 'Blade']
    return '*Hacha* (Filo Verde)' if @weapon==['Green', 'Blade']
    return "*Ca\u00D1a* (Filo Gris)" if @weapon==['Colorless', 'Blade']
    if @weapon[1]=='Tome'
      m=self.weapon_spanish[2]
      m=self.weapon_spanish[0] if m.nil?
      x="*Mag#{self.spanish_gender.downcase} de#{'l' unless m[-1]=='a'}#{' la' if m[-1]=='a'} #{m}*"
      x="#{x} (Tomo #{self.weapon_spanish[0]})" unless @name=='Kiran'
      return x
    end
    return "*Curador#{'a' if @gender=='F'}* (Gris)" if @weapon[1]=='Healer' && $units.reject{|q| q.weapon_type != 'Healer' || q.weapon_color != 'Colorless'}.length<=0
    return "*#{self.weapon_spanish[1]}*" if @weapon[0]=='Gold'
    return "*#{self.weapon_spanish[1]} #{self.weapon_spanish[0]}*"
  end
  
  def movement_spanish
    return "Infantería" if @movement=='Infantry'
    return "Volador" if @movement=='Flier'
    return "Caballería" if @movement=='Cavalry'
    return "Blindad#{self.spanish_gender.downcase}" if @movement=='Armor'
    return "Ignoto"
  end
  
  def spanish_beast
    return nil unless @weapon[1]=='Beast'
    return "Lob#{self.spanish_gender.downcase}" if @weapon[2]=='Wolf'
    return "Garz#{self.spanish_gender.downcase}" if @weapon[2]=='Heron'
    return "Halcón" if @weapon[2]=='Hawk'
    return "Cuerv#{self.spanish_gender.downcase}" if @weapon[2]=='Raven'
    return "Zorropiel" if @weapon[2]=='Kitsune'
    return "Lobopiel" if @weapon[2]=='Wolfskin'
    return "Conejopiel" if @weapon[2]=='Taguel'
    return "León" if @weapon[2]=='Lion'
    return "Tigre" if @weapon[2]=='Tiger'
    return "Cabr#{self.spanish_gender.downcase}" if @weapon[2]=='Goat'
    return "Gat#{self.spanish_gender.downcase}" if @weapon[2]=='Cat'
    return "Cáscara" if @weapon[2]=='Husk'
    return @weapon[2]
  end
  
  def spanish_legendary
    return nil if @legendary.nil? || @legendary.length<=0
    m=[]
    if @legendary[0]=='Water'
      m.push('Agua')
    elsif @legendary[0]=='Wind'
      m.push('Viento')
    elsif @legendary[0]=='Earth'
      m.push('Tierra')
    elsif @legendary[0]=='Fire'
      m.push('Fuego')
    elsif @legendary[0]=='Light'
      m.push('Luz')
    elsif @legendary[0]=='Anima'
      m.push("\u00C1nima")
    elsif @legendary[0]=='Dark'
      m.push('Oscuridad')
    elsif @legendary[0]=='Astra'
      m.push('Cosmos')
    else
      m.push(@legendary[0])
    end
    if @legendary[1].split(' ')[0]=='Attack'
      m.push('Ataque')
    elsif @legendary[1].split(' ')[0]=='Speed'
      m.push('Velocidad')
    elsif @legendary[1].split(' ')[0]=='Defense'
      m.push('Defensa')
    elsif @legendary[1].split(' ')[0]=='Resistance'
      m.push('Resistencia')
    elsif @legendary[1].split(' ')[0]=='Duel'
      m.push('Agrupar')
    end
    m[-1]="#{m[-1]}* / *Muesca" if @legendary[1].split(' ').include?('Slot')
    if m[0][-1]=='s'
      m.push(' los')
    elsif m[0][-1]=='o'
      m.push('l')
    else
      m.push(' la')
    end
    if @legendary[3]=='Legendary'
      m.push('Legendario')
    elsif @legendary[3]=='Mythic'
      m.push('Mítico')
    else
      m.push(@legendary[3])
    end
    return m
  end
  
  def spanish_duo
    return nil if @duo.nil? || @duo.length<=0 || @duo[0].length<=0
    return 'Dúo' if @duo[0][0]=='Duo'
    return 'al Son' if @duo[0][0]=='Harmonic'
  end
  
  
end

class FEHSkill
  def tome_tree_reversa
    return nil unless @exclusivity.nil? || @exclusivity.length<=0
    return 'Ruina' if @tome_tree=='Fire'
    return 'Fuego' if @tome_tree=='Dark'
    return 'Trueno' if @tome_tree=='Light'
    return 'Luz' if @tome_tree=='Thunder'
    return nil
  end
  
  def arbor_tomo
    return 'Fuego' if @tome_tree=='Fire'
    return 'Ruina' if @tome_tree=='Dark'
    return 'Trueno' if @tome_tree=='Thunder'
    return 'Luz' if @tome_tree=='Light'
    return 'Viento' if @tome_tree=='Wind'
    return 'Roca' if @tome_tree=='Stone'
    return "Infantería" if @tome_tree=='Infantry'
    return "Volador" if @tome_tree=='Flier'
    return "Caballería" if @tome_tree=='Cavalry'
    return "Blindada" if @tome_tree=='Armor'
    return @tome_tree unless @tome_tree.nil?
  end
  
  def colore
    return 'Rojo' if self.weapon_color=='Red'
    return 'Azul' if self.weapon_color=='Blue'
    return 'Verde' if self.weapon_color=='Green'
    return 'Gris' if self.weapon_color=='Colorless'
    return 'Oro'
  end
  
  def clasa_de_arma
    return 'Pistola para Convocar' if @restrictions.include?('Summon Gun Users Only')
    return 'Multicine' if ['Missiletainn','Umbra Burst'].include?(@name)
    return 'Espada (Filo Rojo)' if @restrictions.include?('Sword Users Only')
    return 'Lanza (Filo Azul)' if @restrictions.include?('Lance Users Only')
    return 'Hacha (Filo Verde)' if @restrictions.include?('Axe Users Only')
    return "Rod (Colorless Blade)" if @restrictions.include?('Rod Users Only')
    return 'Ca\u00D1a (Filo Gris)' if @restrictions.include?('Dragons Only')
    return 'Daño de Bestia' if @restrictions.include?('Beasts Only')
    return 'Arco' if @restrictions.include?('Bow Users Only')
    return 'Daga' if @restrictions.include?('Dagger Users Only')
    return 'Bastón' if @restrictions.include?('Staff Users Only')
    return "Magia de #{@tome_tree} (Tomo #{self.colore})" if @restrictions[0].include?(' Tome Users Only')
    return nil
  end
end

class FEHStructure
  def spanish_type
    x=@type.map{|q| q}
    for i in 0...x.length
      x[i]='Trampa' if x[i]=='Trap'
      x[i]='Artefacto' if x[i]=='Mjolnir'
      x[i]='Ataque' if x[i]=='Offensive'
      x[i]='Defensa' if x[i]=='Defensive'
      x[i]='Recurso' if x[i]=='Resource' || x[i]=='Resources'
      x[i]='Lugar de verano' if x[i]=='Resort'
      x[i]='Decorado' if x[i]=='Ornament'
    end
    return x
  end
end

class FEHItem
  def spanish_type
    return 'Principal' if @type=='Main'
    return 'Implícito' if @type=='Implied'
    return 'Bendición' if @type=='Blessing'
    return 'Crecimiento' if @type=='Growth'
    return 'Evento' if @type=='Event'
    return @type
  end
end

class FEHAccessory
  def spanish_type
    return 'Cabello' if @type=='Hair'
    return 'Sombrero' if @type=='Hat'
    return 'Máscara' if @type=='Mask'
    return @type
  end
end

class FEHBonus
  def spanish_type
    return 'Tormenta' if @type=='Tempest'
    return 'Etéreos' if @type=='Aether'
    return 'Fragante' if @type=='Resonant'
    return @type
  end
end

class FEHPath
  def spanish_name
    return @name unless @name.split(' ')[0]=='Ephemura'
    f=@name.gsub('Ephemura','efímero')
    for i in 1...$spanish_months[0].length
      f=f.gsub($spanish_months[1][i],$spanish_months[0][i])
    end
    return f
  end
end

def disp_data_habilidad(bot,event,xname,colors=false,includespecialerror=false)
  args=event.message.text.downcase.split(' ')
  data_load()
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true,true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args.compact!
  errstr=nomf()
  errstr="No hay coincidencias.  Si está buscando datos sobre las habilidades que aprende un personaje en particular, intente ```#{event.message.text.downcase.gsub('habilidad','habilidades')}``` en su lugar." if includespecialerror
  if xname.nil?
    if args.nil? || args.length<1
      event.respond errstr
      return nil
    else
      xname=''
      x=find_data_ex(:find_skill,event,args,nil,bot,true)
      xname=x.fullName unless x.nil?
    end
  end
  skill=$skills.find_index{|q| q.fullName==xname}
  blevel=0
  blevel=count_in(event.message.text.downcase.split(' '),'base')
  blevel=100 if event.message.text.downcase.split(' ').include?('default')
  if skill.nil?
    x=find_data_ex(:find_unit,event,args,nil,bot,true)
    if x.nil?
      x=find_data_ex(:find_skill,event,args,nil,bot)
      if x.nil?
        x=find_data_ex(:find_unit,event,args,nil,bot)
        if x.nil?
          event.respond errstr
          return nil
        elsif x.is_a?(Array)
          event.respond "Multipersonaje encontrado, utilice uno de los siguientes:\n#{x.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
          return nil
        end
      else
        disp_skill_data(bot,event,x.name,colors,includespecialerror)
        return nil
      end
    elsif x.is_a?(Array)
      event.respond "Multipersonaje encontrado, utilice uno de los siguientes:\n#{x.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
      return nil
    end
    sktype=[]; baseweapon=false; rar=0
    for i in 0...args.length
      rar=args[i][0,1].to_i if rar<=0 && args[i][0,1].to_i.to_s==args[i][0,1] && args[i][0,1].to_i>0 && args[i][0,1].to_i<=Max_rarity_merge[0] && ["#{args[i][0,1]}*","#{args[i][0,1]}star","#{args[i][0,1]}-star"].include?(args[i])
      blevel-=1 if ['base','defecto'].include?(args[i].downcase) && !baseweapon
      baseweapon=true if ['base','summoned','baseweapon','defecto','convocado','convocada','basearma','armabase'].include?(args[i].downcase)
      sktype.push('Weapon') if ['weapon','baseweapon','armabase','basearma','base'].include?(args[i].downcase)
      sktype.push('Assist') if ['assist','asistencia'].include?(args[i].downcase)
      sktype.push('Special') if ['special','especial'].include?(args[i].downcase)
      sktype.push('Passive(A)') if ['a','apassive','passivea','a_passive','passive_a','pasivaa','apasiva','pasiva_a','a_pasiva'].include?(args[i].downcase)
      sktype.push('Passive(B)') if ['b','bpassive','passiveb','b_passive','passive_b','pasivab','bpasiva','pasiva_b','b_pasiva'].include?(args[i].downcase)
      sktype.push('Passive(C)') if ['c','cpassive','passivec','c_passive','passive_c','pasivac','cpasiva','pasiva_c','c_pasiva'].include?(args[i].downcase)
      sktype.push('Resonant') if ['duo','duos','harmonic','harmonics','resonant','resonants','resonance','resonances','alsol'].include?(args[i].downcase) && !x.duo.nil?
    end
    if rar<=0
      for i in 0...args.length
        rar=args[i].to_i if args[i].to_i.to_s==args[i] && args[i].to_i>0 && args[i].to_i<=Max_rarity_merge[0]
      end
      rar=Max_rarity_merge[0]*1 if rar<=0
    end
    sktype.push('Assist') if x.name=='Mathoo'
    sktype.push('Resonant') unless x.duo.nil?
    sktype.push('Weapon') if baseweapon || !x.dispPrf.nil?
    f=x.skill_list(rar).clone
    for i in 0...f.length
      f[i].id+=50000 if !f[i].nil? && f[i].type.include?('Special') && f[i].id<210000
      if f[i].nil?
      elsif f[i].id<0
        f[i].id=0-f[i].id
        if f[i].id>=300000
          f[i].id+=90000
        elsif f[i].id>=100000
          f[i].id+=9000
        else
          f[i].id+=4000
        end
      end
    end
    if sktype.length<=0
      x2=find_data_ex(:find_skill,event,args,nil,bot)
      if x2.nil?
        event.respond "Estás buscando la habilidad de **#{x.name}#{x.emotes(bot)}**, pero ¿cuál?"
      else
        disp_skill_data(bot,event,x2.name,colors,includespecialerror)
      end
      return nil
    elsif sktype[0]=='Resonant'
      sktype=['Duo','Harmonic']
    else
      sktype=sktype[0,1]
    end
    f=f.reject{|q| !has_any?(q.type,sktype)}.sort{|a,b| a.id<=>b.id}
    if f.length<=0
      x2=find_data_ex(:find_skill,event,args,nil,bot)
      if x2.nil?
        event.respond "**#{x.name}#{x.emotes(bot)}** no tiene una habilidad en ese espacio#{' en esa rareza' unless rar==Max_rarity_merge[0]}."
      else
        disp_data_habilidad(bot,event,x2.name,colors,includespecialerror)
      end
      return nil
    end
    skill=f[-1].clone
    skill=f[-2].clone if sktype[0]=='Weapon' && baseweapon && skill.prerequisite.nil?
  else
    skill=$skills[skill].clone
  end
  if skill.type.include?('Weapon') && has_any?(event.message.text.downcase.split(' '),['refinement','refinements','refinamiento','refinamientos','(w)'])
    if skill.name=='Falchion'
      sk1=$skills.find_index{|q| q.name=='Falchion (Mystery)'}
      sk2=$skills.find_index{|q| q.name=='Falchion (Valentia)'}
      sk3=$skills.find_index{|q| q.name=='Falchion (Awakening)'}
      sk1=$skills[sk1].refinement_name unless sk1.nil?
      sk2=$skills[sk2].refinement_name unless sk2.nil?
      sk3=$skills[sk3].refinement_name unless sk3.nil?
      disp_data_habilidad(bot,event,sk1.fullName,colors) unless sk1.nil?
      disp_data_habilidad(bot,event,sk2.fullName,colors) unless sk2.nil?
      disp_data_habilidad(bot,event,sk3.fullName,colors) unless sk3.nil?
      return nil
    elsif skill.name=='Missiletainn'
      sk1=$skills.find_index{|q| q.name=='Missiletainn (Dark)'}
      sk2=$skills.find_index{|q| q.name=='Missiletainn (Dusk)'}
      if sk1.nil? && sk2.nil?
        event.respond errstr
        return nil
      end
      sk1=$skills[sk1].refinement_name
      sk2=$skills[sk2].refinement_name
      if sk1.nil? && sk2.nil?
        event.respond "#{skill.name} no tiene un modo de efecto.  Mostrando los datos predeterminados de #{skill.name}."
      elsif sk1==sk2
        disp_data_habilidad(bot,event,sk1.fullName,colors)
        return nil
      else
        disp_data_habilidad(bot,event,sk1.fullName,colors)
        disp_data_habilidad(bot,event,sk2.fullName,colors)
        return nil
      end
    elsif !skill.refinement_name.nil?
      disp_data_habilidad(bot,event,skill.refinement_name.fullName,colors)
      return nil
    elsif !skill.refine.nil?
      event.respond "#{skill.name} no tiene un modo de efecto.  Mostrando los datos predeterminados de #{skill.name}."
    else
      event.respond "#{skill.name} no se puede refinar.  Mostrando los datos predeterminados de #{skill.name}."
    end
  end
  unless skill.type.include?('Weapon') && has_any?(['refinado','refinada','refined'],event.message.text.downcase.split(' ')) && blevel<=0
    header=skill.class_header(bot)
    header=skill.mcr unless safe_to_spam?(event)
    header='' if skill.name=='Missiletainn' && !safe_to_spam?(event)
    if header.length>200
      h=header.split("\n")
      header=[h[0],'']
      j=0
      for i in 1...h.length
        if "#{header[j]}\n#{h[i]}".length>200 && j==0
          j+=1
          header[j]="#{h[i]}"
        else
          header[j]="#{header[j]}\n#{h[i]}"
        end
      end
    end
    unless colors
      colors=true if has_any?(['color','colors','colour','colours','colores'],args)
      colors=1 if has_any?(['divine','path','code','paths','codes','ephemura'],args)
    end
    ftr=nil
    flds=nil
    text=''
    text="**Eficaz contra:** #{skill.eff_against('',false,event)}" unless skill.eff_against('',false,event).length<=0
    text="#{text}**Mecánica para bestias:** Al comienzo del turno, si el personaje no está adyacente a ningún aliado, o solo está adyacente a los aliados de bestias y dragones, el personaje se transforma.  De lo contrario, el personaje vuelve a su forma humanoide." if skill.tags.include?('Weapon') && skill.restrictions.include?('Beasts Only')
    text="#{text}\n**Mecánica para la transformación:** #{skill.transform_type}" unless skill.transform_type.nil?
    endtext=''
    ftr="Los magos de #{skill.tome_tree_reversa} aún pueden aprender esta habilidad, solo necesitará más SP." unless skill.tome_tree_reversa.nil?
    ftr="La desventaja se aplica al final del combate si el personaje ataca y dura hasta las próximas acciones de los enemigos." unless skill.dagger_debuff.nil? || skill.dagger_debuff.length<=0
    if ['Missiletainn'].include?(skill.name)
      sk1=$skills.find_index{|q| q.name=='Missiletainn (Dark)'}
      sk2=$skills.find_index{|q| q.name=='Missiletainn (Dusk)'}
      if sk1.nil? && sk2.nil?
        event.respond nomf()
        return nil
      elsif sk1.nil?
        disp_skill_data(bot,event,'Missiletainn (Dusk)',colors)
        return nil
      elsif sk2.nil?
        disp_skill_data(bot,event,'Missiletainn (Dark)',colors)
        return nil
      end
      sk1=$skills[sk1]
      sk2=$skills[sk2]
      text="__**#{sk1.class_header(bot,1)}#{sk1.name}**__\n#{sk1.mcr}\n**Efecto:** #{sk1.description}\n<:Prf_Sparkle:490307608973148180>**Prf a:** #{sk1.exclusivity.join(', ')}\n**Promueve desde:** #{list_lift(sk1.prerequisite.map{|q| "*#{q}*"},'or')}"
      text="#{text}\n\n__**#{sk2.class_header(bot,1)}#{sk2.name}**__\n#{sk2.mcr}\n**Efecto:** #{sk2.description}\n<:Prf_Sparkle:490307608973148180>**Prf a:** #{sk2.exclusivity.join(', ')}\n**Promueve desde:** #{list_lift(sk2.prerequisite.map{|q| "*#{q}*"},'or')}"
      text="#{text}\n\n**Precio SP:** #{sk1.sp_cost} SP\n**Precio SP acumulativo:** #{sk1.cumulitive_sp_cost} SP"
    elsif ['Whelp (All)','Yearling (All)','Adult (All)','Cachorro (Todo)','Fiera joven (Todo)','Fiera adulta (Todo)'].include?(skill.name)
      m=skill.name.split(' (')[0]
      skzz=$skills.reject{|q| q.name=="#{m} (All)" || (q.name[0,m.length+2]!="#{m} (" && !((q.name=='Hatchling (Flier)' && m=='Whelp') || (q.name=='Fledgling (Flier)' && m=='Yearling') || (q.name=='Polluelo (Pájaro)' && m=='Cachorro') || (q.name=='Joven (Pájaro)' && m=='Fiera joven') || (q.name=='Adulto (Pájaro)' && m=='Fiera adulta')))}
      for i in 0...skzz.length
        m=skzz[i].restrictions[1].split(' ').map{|q| q.gsub('s','')}.reject{|q| !['Infantry','Armor','Flier','Cavalry'].include?(q)}
        movemoji=''
        for i2 in 0...m.length
          moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{m[i2]}"}
          movemoji="#{movemoji}#{moji[0].mention}" if moji.length>0
        end
        text="#{text}\n\n#{movemoji} __**#{skzz[i].name}**__"
        text="#{text}\n**Mecánica para la transformación:** #{skzz[i].transform_type}" unless skzz[i].transform_type.nil? || skzz[i].transform_type=='-'
        text="#{text}\n**Efecto:** #{skzz[i].description}" unless skzz[i].description.nil? || skzz[i].description=='-' || skzz[i].description.length<=0
        text="#{text}\n**Promueve desde:** #{list_lift(skzz[i].prerequisite.map{|q| "*#{q}*"},'o')}" unless skzz[i].prerequisite.nil? || skzz[i].prerequisite.length<=0
        text="#{text}\n**Promueve en:** #{skzz[i].next_steps(event)}" unless skzz[i].next_steps(event).nil? || skzz[i].next_steps(event).length<=0
      end
      text="#{text}\n\n**Precio SP:** #{skill.disp_sp_cost} SP#{" (#{skill.disp_sp_cost(true)} SP cuando se hereda)" if skill.exclusivity.nil? || skill.exclusivity.length<=0}"
    else
      text="#{text}\n**Efecto:** #{skill.description}" unless skill.description.nil? || skill.description.length<=0 || skill.description=='-'
      text="#{text}\nSi el Alcance del enemigo = 2, calcula el daño usando el valor más bajo de Def o Res." if skill.type.include?('Weapon') && skill.restrictions.include?('Dragons Only') && skill.tags.include?('Frostbite')
      if skill.name=='Umbra Burst'
        text="#{text}\n\n<:Gold_Dragon:774013610908581948>**Dragones ganan:** Si el Alcance del enemigo = 2, calcula el daño usando el valor más bajo de Def o Res."
        text="#{text}\n<:Gold_Bow:774013609389981726>**Arco es Eficaz contra:** <:Icon_Move_Flier:443331186698354698>"
        text="#{text}\n<:Gold_Dagger:774013610862968833>**Desventaja de Daga:**  \u200B  \u200B  \u200B  *Efecto:* Def/Res-7  \u200B  \u200B  \u200B  *Affects:* Objetivo y enemigos a 2 espacios del objetivo"
        text="#{text}\n<:Gold_Staff:774013610988797953>**Bastónes:** El daño se calcula como otras armas."
      end
      text="#{text}\n**Desventaja:** *Efecto:* #{skill.dagger_debuff[0]}   *Afecta:* #{skill.dagger_debuff[1]}" unless skill.dagger_debuff.nil? || skill.dagger_debuff.length<=0
      text="#{text}\n**Pulidor:** *Efecto:* #{skill.dagger_buff[0]}   *Afecta:* #{skill.dagger_buff[1]}" unless skill.dagger_buff.nil? || skill.dagger_buff.length<=0
      if skill.type.include?('Weapon') && safe_to_spam?(event)
        mdfr=''
        mdfr=' (humanoide)' if skill.restrictions.include?('Beasts Only')
        mdfr=' (desplegada)' if skill.tags.include?('Chainy')
        text="#{text}\n**Estadísticas Afectadas#{mdfr}:** #{skill.disp_weapon_stats}"
        text="#{text}\n**Estadísticas Afectadas (transformada):** #{skill.disp_weapon_stats(false,true)}" if skill.restrictions.include?('Beasts Only')
        text="#{text}\n**Estadísticas Afectadas (en combate):** #{'+' if skill.disp_weapon_stats(true)[0]>0}#{skill.disp_weapon_stats(true)[0]} HP, other stats have complex interactions" if skill.tags.include?('Chainy')
      elsif skill.type.include?('Assist') && !skill.heal.nil?
        text="#{text}\n**Cura:** #{skill.heal}"
      elsif skill.type.include?('Special')
        text="#{text}\n**Alcance:**\n```#{skill.range}```" unless skill.range.nil? || skill.range=='-'
      end
      unless skill.name[0,6]=='Umbra ' || has_any?(skill.type,['Duo','Harmonic'])
        text="#{text}\n\n**Precio SP:** #{skill.disp_sp_cost} SP#{" (#{skill.disp_sp_cost(true)} SP cuando se hereda)" if skill.exclusivity.nil? || skill.exclusivity.length<=0}"
        text="#{text}\n**Precio Total del SP:** #{skill.disp_sp_cost(false,true)} SP#{" (#{skill.disp_sp_cost(true,true)} SP cuando se hereda)" if skill.exclusivity.nil? || skill.exclusivity.length<=0}" if skill.level=='example'
        text="#{text}\n**Precio SP acumulativo:** #{skill.cumulitive_sp_cost} SP#{" (#{skill.cumulitive_sp_cost(true)} SP cuando se hereda)" if skill.exclusivity.nil? || skill.exclusivity.length<=0}" unless skill.prerequisite.nil? || skill.prerequisite.length<=0 || !safe_to_spam?(event)
        unless colors==1
          text="#{text}\n**Insignia:** #{skill.seal_colors(bot)}" if !skill.seal_colors(bot).nil? && skill.seal_colors(bot).length>0 && has_any?(skill.type,['Seal','Passive(S)'])
          text="#{text}\n**Total de Insignia:** #{skill.seal_colors(bot,true)}" if !skill.seal_colors(bot,true).nil? && skill.seal_colors(bot,true).length>0 && has_any?(skill.type,['Seal','Passive(S)']) && skill.level=='example'
        end
      end
      text2=[]
      if !skill.exclusivity.nil?
        y=skill.exclusivity
        y=y.reject{|q| $units.find_index{|q2| q2.name==q}.nil?}
        y=y.map{|q| $units[$units.find_index{|q2| q2.name==q}]}.reject{|q| !q.isPostable?(event)}
        if skill.fake.nil?
          y=y.map{|q| q.postName}
        else
          y=y.map{|q| q.fullName('')}
        end
        y.push('Mathoo [Rokkr]') if skill.name=='Brobdingo' || skill.name=='Upelkuchen'
        text2.push("<:Prf_Sparkle:490307608973148180>**Prf a:** #{y.join(', ')}")
      elsif skill.name=='Brobdingo' || skill.name=='Upelkuchen'
        text2.push("<:Prf_Sparkle:490307608973148180>**Prf a:** Mathoo [Rokkr]")
      elsif skill.restrictions != ['Everyone'] && !skill.type.include?('Weapon')
        text2.push("**Restricciones a la herencia:** #{skill.restrictions.join(', ').gsub('Excludes Tome Users, Excludes Staff Users, Excludes Dragons','Physical Weapon Users Only')}")
      end
      text2.push("**Promueve desde:** #{list_lift(skill.prerequisite.map{|q| "*#{q}*"},'or')}") unless skill.prerequisite.nil? || skill.prerequisite.length<=0
      text2.push("**Promoción#{'es' unless skill.side_steps(event,1).length==0} lateral#{'es' unless skill.side_steps(event,1).length==0}:** #{skill.side_steps(event)}") unless skill.side_steps(event).nil? || skill.side_steps(event).length<=0
      unless skill.next_steps(event).nil? || skill.next_steps(event).length<=0
        if skill.type.include?('Weapon') && skill.next_steps(event,1).length>8 && skill.next_steps(event,1).reject{|q| q.exclusivity.nil? || q.exclusivity.length<=0}.length>1 && skill.next_steps(event,1).reject{|q| !q.exclusivity.nil? && q.exclusivity.length<=0}.length>1 && !(has_any?(['expanded','expandido'],event.message.text.downcase.split(' ')) && safe_to_spam?(event))
          y=skill.next_steps(event,1)
          z=y.reject{|q| q.exclusivity.nil? || q.exclusivity.length<=0}
          y=y.reject{|q| !q.exclusivity.nil? && q.exclusivity.length>0}
          if skill.fake.nil?
            y=y.map{|q| q.postName}
          else
            y=y.map{|q| q.fullName('')}
          end
          y=y.map{|q| "*#{q}*"}
          y.push("o cualquiera de las #{z.length} prfs")
          ftr='Si desea incluir las Prfs y los caracteres que las tienen, incluya la palabra "expandido" cuando vuelva a intentar este comando.'
          text2.push("**Promueve en:** #{y.join(', ')}")
        else
          text2.push("**Promueve en:** #{skill.next_steps(event)}")
        end
      end
      unless skill.evolutions.nil?
        y=skill.evolutions.map{|q| $skills.find_index{|q2| q2.name==q}}.compact.map{|q| $skills[q]}
        if skill.fake.nil?
          y=y.map{|q| q.postName}
        else
          y=y.map{|q| q.fullName('')}
        end
        y=y.map{|q| "*#{q}*"}
        text2.push("**Evoluciona en:** #{list_lift(y,'y')}") if y.length>0
      end
      text="#{text}#{"\n" unless !has_any?(skill.tags,['Duo','Harmonic']) && text2.length==1}\n#{text2.join("\n")}" if text2.length>0
      unless skill.subUnits(event).nil?
        if safe_to_spam?(event)
          text2=[]
          lvv=skill.tier-skill.lineCount
          for i in 0...skill.tier
            text2.push("*Al nivel #{i+1-lvv}:* #{skill.subUnits(event,i+1).join(', ')}") unless skill.subUnits(event,i+1).nil?
          end
          text="#{text}\n\n**Héroes que pueden aprender parte de esta línea sin heredar:**\n#{text2.join("\n")}" unless text2.length<=0
        elsif skill.tier>=4
          text="#{text}\n\n**Héroes que pueden aprender la penúltima parte de esta línea sin heredar:**\n#{skill.subUnits(event,skill.tier-1).join(', ')}" unless skill.subUnits(event,skill.tier-1).nil?
        end
      end
      if has_any?(['Duo','Harmonic'],skill.type) || colors
      elsif skill.summon.reject{|q| q.length<=0}.length>0
        text2="**Héroes que conocen esta habilidad por defecto:**"
        for i in 0...Max_rarity_merge[0]
          y=skill.summon[i]
          if y.length>0
            y2=y.reject{|q| q[0,4]!='All '}
            if ['Assault','Heal','Imbue'].include?(skill.name) && y2.length>0
              u=$units.reject{|q| q.weapon[1]!='Healer' || q.weapon[2].nil? || q.weapon[2][0,8]!='Ignore: ' || !q.weapon[2].include?(skill.type[0][0,2]) || !q.isPostable?(event)}
              y2[0]="**#{y2[0]}** (except #{list_lift(u.sort{|a,b| a.name<=>b.name}.map{|q| q.fullName('')},'and')})" if u.length>0
            end
            y=y.reject{|q| $units.find_index{|q2| q2.name==q}.nil?}
            y=y.map{|q| $units[$units.find_index{|q2| q2.name==q}]}.reject{|q| !q.isPostable?(event)}
            if skill.type.include?('Weapon') && y.length>8 && !(has_any?(['expanded','expandido'],event.message.text.downcase.split(' ')) && safe_to_spam?(event))
              z=y.reject{|q| q.prf(true).length<1}
              y=y.reject{|q| q.prf(true).length>0} unless z.length<2
              if skill.fake.nil?
                y=y.map{|q| q.postName}
              else
                y=y.map{|q| q.fullName('')}
              end
              y.push("y #{z.length} personajes que terminan teniendo armas Prf") unless z.length<2
              ftr='Si desea incluir las Prfs y los caracteres que las tienen, incluya la palabra "expandido" cuando vuelva a intentar este comando.' unless z.length<2
            elsif skill.fake.nil?
              y=y.map{|q| q.postName}
            else
              y=y.map{|q| q.fullName('')}
            end
            y.push(y2)
            y.flatten!
            text2="#{text2}\n*#{i+1}#{Rarity_stars[0][i]}:* #{y.join(', ')}" if y.length>0
          end
        end
        text="#{text}\n\n#{text2}" if text2.split("\n").length>1
      end
      if has_any?(['Duo','Harmonic'],skill.type)
      elsif colors==1
        x=skill.learn_by_path(event)
        if x.length==0
          text="#{text}\n\nNingún personaje disponible a través de manuales tiene esta habilidad#{", y no podría ser heredada incluso si lo hicieran" unless skill.exclusivity.nil?}."
        elsif !skill.exclusivity.nil?
          text="#{text}\n\nEsta habilidad no se puede heredar. Ningún manual puede dárselo a las personajes que aún no tienen acceso a él."
        elsif skill.prevos.nil? && x.length==1
          text="#{text}\n\n__**Caminos Divinos de #{x[0][0]} que contiene esta habilidad**__\n#{x[0][1]}"
        elsif skill.prevos.nil?
          endtext="**Caminos Divinos que contiene esta habilidad:**"
          flds=x.map{|q| q}
        else
          text="#{text}\n\n__**Caminos Divinos que contiene esta habilidad:**__\n#{x.map{|q| "*#{q[0]}:* #{q[1].gsub("\n",', ')}"}.join("\n")}"
        end
      elsif colors==true
        x=skill.learn_by_color(event)
        if x.length<=0
        elsif x.length==1 && skill.prevos.nil?
          endtext="**#{x[0][0]} que aprenden esta habilidad**"
          flds=triple_finish(x[0][1])
        else
          x=skill.learn_by_color(event,false)
          text="#{text}\n\n**Héroes que pueden aprender esta habilidad sin heredar:**\n#{x}"
        end
      elsif skill.learn.reject{|q| q.length<=0}.length==1 && skill.summon.flatten.length<=0 && skill.prevos.nil?
        x=skill.learn.find_index{|q| q.length>0}
        y=skill.learn[x]
        y2=skill.learn[x].reject{|q| q[0,4]!='All '}
        if ['Assault','Heal','Imbue'].include?(skill.name) && y2.length>0
          u=$units.reject{|q| q.weapon[1]!='Healer' || q.weapon[2].nil? || q.weapon[2][0,8]!='Ignore: ' || !q.weapon[2].include?(skill.type[0][0,2]) || !q.isPostable?(event)}
          y2[0]="**#{y2[0]}** (excepto #{list_lift(u.sort{|a,b| a.name<=>b.name}.map{|q| q.fullName('')},'y')})" if u.length>0
        end
        y=y.reject{|q| $units.find_index{|q2| q2.name==q}.nil?}
        y=y.map{|q| $units[$units.find_index{|q2| q2.name==q}]}.reject{|q| !q.isPostable?(event)}
        if skill.fake.nil?
          y=y.map{|q| q.postName}
        else
          y=y.map{|q| q.fullName('')}
        end
        y.push(y2)
        y.flatten!
        if y.length<=3 || !skill.prevos.nil?
          text="#{text}\n\n**Héroes que aprenden a las #{x+1}#{Rarity_stars[0][x]}**\n#{y.join(',  ')}"
        else
          endtext="**Héroes que aprenden a las #{x+1}#{Rarity_stars[0][x]}**"
          flds=triple_finish(y)
        end
      elsif skill.learn.flatten.reject{|q| skill.summon.flatten.include?(q)}.length<=0 && !safe_to_spam?(event)
      elsif skill.learn.reject{|q| q.length<=0}.length>0
        text="#{text}\n\n**Héroes que pueden aprender esta habilidad sin heredar:**"
        for i in 0...Max_rarity_merge[0]
          y=skill.learn[i]
          y2=skill.learn[i].reject{|q| q[0,4]!='All '}
          if ['Assault','Heal','Imbue'].include?(skill.name) && y2.length>0
            u=$units.reject{|q| q.weapon[1]!='Healer' || q.weapon[2].nil? || q.weapon[2][0,8]!='Ignore: ' || !q.weapon[2].include?(skill.type[0][0,2]) || !q.isPostable?(event)}
            y2[0]="**#{y2[0]}** (except #{list_lift(u.sort{|a,b| a.name<=>b.name}.map{|q| q.fullName('')},'and')})" if u.length>0
          end
          y=y.reject{|q| skill.summon.flatten.include?(q)} unless safe_to_spam?(event)
          if y.length>0
            y=y.reject{|q| $units.find_index{|q2| q2.name==q}.nil?}
            y=y.map{|q| $units[$units.find_index{|q2| q2.name==q}]}.reject{|q| !q.isPostable?(event)}
            if skill.type.include?('Weapon') && y.length>8 && !(event.message.text.downcase.split(' ').include?('expanded') && safe_to_spam?(event))
              z=y.reject{|q| q.prf(true).length<1}
              y=y.reject{|q| q.prf(true).length>0} unless z.length<2
              if skill.fake.nil?
                y=y.map{|q| q.postName}
              else
                y=y.map{|q| q.fullName('')}
              end
              y.push("y #{z.length} personajes que terminan teniendo armas Prf") unless z.length<2
              ftr='Si desea incluir las Prfs y los caracteres que las tienen, incluya la palabra "expandido" cuando vuelva a intentar este comando.' unless z.length<2
            elsif skill.fake.nil?
              y=y.map{|q| q.postName}
            else
              y=y.map{|q| q.fullName('')}
            end
            y.push(y2)
            y.flatten!
            text="#{text}\n*#{i+1}#{Rarity_stars[0][i]}:* #{y.join(', ')}" if y.length>0
          end
        end
      end
      unless skill.prevos.nil?
        for i in 0...skill.prevos.length
          sk2=skill.prevos[i]
          unless colors==1 && sk2.learn_by_path(event,false).length<=0
            str2="**#{'También e' if skill.learn.flatten.length>0}#{'E' unless skill.learn.flatten.length>0}voluciona de #{sk2.name}**"
            unless sk2.learn.flatten.length<=0
              str2="**#{'También e' if skill.learn.flatten.length>0}#{'E' unless skill.learn.flatten.length>0}voluciona de #{sk2.name}, que se obtiene de los siguientes héroes:**"
              str2="**#{'También e' if skill.learn.flatten.length>0}#{'E' unless skill.learn.flatten.length>0}voluciona de #{sk2.name}, que se obtiene de los siguientes Caminos Divinos:**" if colors==1
              if colors
                str2="#{str2}\n#{skill.learn_by_color(event,false)}"
              else
                for i2 in 0...Max_rarity_merge[0]
                  y=sk2.learn[i2]
                  y=y.reject{|q| $units.find_index{|q2| q2.name==q}.nil?}
                  y=y.map{|q| $units[$units.find_index{|q2| q2.name==q}]}.reject{|q| !q.isPostable?(event)}
                  if skill.fake.nil?
                    y=y.map{|q| q.postName}
                  else
                    y=y.map{|q| q.fullName('')}
                  end
                  str2="#{str2}\n*#{i2+1}#{Rarity_stars[0][i2]}:* #{y.join(', ')}" unless y.length<=0
                end
              end
            end
          end
          str3='**Precio Evolución:** 300 SP (450 si es heredado), 200<:Arena_Medal:453618312446738472> 20<:Refining_Stone:453618312165720086>'
          str3='**Precio Evolución:** 300 SP (450 si es heredado), 100<:Arena_Medal:453618312446738472> 10<:Refining_Stone:453618312165720086>' if skill.name=='Candlelight+'
          str3='**Precio Evolución:** 400 SP, 375<:Arena_Medal:453618312446738472> 150<:Divine_Dew:453618312434417691>' unless skill.exclusivity.nil? || skill.exclusivity.length<=0
          str3='**Precio Evolución:** 1 Gunnthra<:Wind_Tome:499760605713137664><:Icon_Move_Cavalry:443331186530451466><:Legendary_Effect_Wind:443331186467536896><:Ally_Boost_Resistance:443331185783865355> dado por la historia' if skill.name=='Chill Breidablik'
          str3='**Precio Evolución:** 1 Outrealm Askr' if skill.name=='Dual Breidablik'
          text="#{text}\n\n#{str2}\n#{str3}"
        end
      end
      unless skill.weapon_gain.nil?
        if skill.level=='example'
          skz=$skills.reject{|q| q.level=='example' || q.name != skill.name || q.weapon_gain.nil?}
          text2=[]
          for i in 0...skz.length
            y=skz[i].weapon_gain
            y=y.reject{|q| $skills.find_index{|q2| q2.name==q}.nil?}
            y=y.map{|q| $skills[$skills.find_index{|q2| q2.name==q}]}.reject{|q| !q.isPostable?(event)}
            if skill.fake.nil?
              y=y.map{|q| q.postName}
            else
              y=y.map{|q| q.fullName('')}
            end
            xtratext=''
            xtratext=" (#{skz[i].level_equal})" if skz[i].level.include?('W') && skz[i].level_equal.length>0
            text2.push("**Nivel #{skz[i].level}#{xtratext} obtenido mediante el refinamiento en:** #{y.join(', ')}") if y.length>0
          end
          text="#{text}\n\n#{text2.join("\n")}" unless text2.length<=0
        else
          y=skill.weapon_gain
          y=y.reject{|q| $skills.find_index{|q2| q2.name==q}.nil?}
          y=y.map{|q| $skills[$skills.find_index{|q2| q2.name==q}]}.reject{|q| !q.isPostable?(event)}
          if skill.fake.nil?
            y=y.map{|q| q.postName}
          else
            y=y.map{|q| q.fullName('')}
          end
          text="#{text}\n\n**Obtenido mediante el refinamiento en:** #{y.join(', ')}" if y.length>0
        end
      end
      if $statskills.map{|q| q[0]}.include?(skill.fullName(nil,true)) && safe_to_spam?(event)
        x=$statskills.find_index{|q| q[0]==skill.fullName(nil,true)}
        unless x.nil?
          x=$statskills[x]
          x[3]=x[3].split(' ')
          x[3]=x[3][0,x[3].length-1].join(' ')
          if ['Enemy Phase','Player Phase'].include?(x[3])
            text="#{text}\n\n**Esta habilidad se puede aplicar a las unidades en el comando `fase`.**\nIncluya la palabra \"#{x[0].gsub('/','').gsub(' ','').gsub('.','')}\" en su mensaje\n*Tipo de habilidad:* Fase del #{x[3].split(' ')[0].gsub('Enemy','Enemigo').gsub('Player','Jugador')}"
          elsif 'In-Combat Buffs'==x[3]
            text="#{text}\n\n**Esta habilidad se puede aplicar a las unidades en el comando `fase`.**\nIncluya la palabra \"#{x[0].gsub('/','').gsub(' ','').gsub('.','')}\" en su mensaje\n*Tipo de habilidad:* Mejora en Combate"
          else
            text="#{text}\n\n**Esta habilidad se puede aplicar a las unidades en el comando `stats` y sus derivados.**\nIncluya la palabra \"#{x[0].gsub('/','').gsub(' ','').gsub('.','')}\" en su mensaje\n*Tipo de habilidad:* #{x[3].gsub('Buffing','Buliendo').gsub('Nerfing','Debilitado').gsub('Affecting','Conmovedorado')}"
          end
          for i4 in 0...5
            if x[4][i4]==0
            elsif x[4][i4]<0
              x[4][i4]="+#{0-x[4][i4]}" if x[3][0,12]=='Stat-Nerfing'
            elsif x[3][0,12]=='Stat-Nerfing'
              x[4][i4]="-#{x[4][i4]}"
            else
              x[4][i4]="+#{x[4][i4]}"
            end
          end
          x[4]="#{x[4][0,5].join('/')}#{"\nCubeta ajustado a ##{x[4][5]/5} (Alcance de BST: #{x[4][5]}-#{x[4][5]+4}) mínima" if x[4].length>5}"
          if x[4]=='0/0/0/0/0'
            text="#{text}\n~~*Alteraciones de estadísticas*~~ *Interacciones complejas con otras habilidades*"
          else
            text="#{text}\n*Alteraciones de estadísticas:* #{x[4]}"
          end
        end
      end
    end
    text="#{text}\n\n#{endtext}" if endtext.length>0
    ftr="You may be looking for the reload command." if skill.name[0,7]=='Restore' && !event.message.text.downcase.include?('skill') && (event.user.id==167657750971547648 || event.channel.id==386658080257212417) # not translated because this is a message directly aimed at me, an English speaker, and not to most users
    tl=skill.fullName('**').length+skill.emotes(bot).length+header.length+text.length
    tl+=ftr.length unless ftr.nil?
    tl+=flds.map{|q| "__**#{q[0]}**__\n#{q[1]}"}.join("\n\n").length unless flds.nil?
    if tl>1900
      text=text.split("\n\n")
      x=0
      for i in 0...text.length
        if "#{text[x]}\n\n#{text[i]}#{"\n\n#{header}\n\n#{skill.fullName('**')}\n\n#{skill.emotes(bot)}" if x==0}".length>1500
          x=i*1
        else
          text[x]="#{text[x]}\n\n#{text[i]}"
          text[i]=nil
        end
      end
      text.compact!
      clr=0
      for i in 0...text.length
        if i==0
          create_embed(event,["__#{skill.fullName('**')}__#{skill.emotes(bot) unless safe_to_spam?(event)}",header],text[i],skill.disp_color(clr),nil,skill.thumbnail(event,bot))
        else
          create_embed(event,'',text[i],skill.disp_color(clr))
        end
        clr+=1
      end
      unless flds.nil? && ftr.nil?
        create_embed(event,'','',skill.disp_color(clr),ftr,nil,flds)
        clr+=1
      end
    else
      create_embed(event,["__#{skill.fullName('**')}__#{skill.emotes(bot) unless safe_to_spam?(event)}",header],text,skill.disp_color,ftr,skill.thumbnail(event,bot),flds)
      clr=1
    end
  end
  w=[]
  w2=0
  if skill.type.include?('Assist') && skill.tags.include?('Music')
    w=$skills.reject{|q| !has_any?(q.tags,['DanceRally','Cantrip'])}
    w2=1
  elsif skill.type.include?('Assist') && skill.tags.include?('Move') && skill.tags.include?('Rally')
    w=$skills.reject{|q| !has_any?(q.tags,['Link','Feint'])}
    w2=1
  elsif skill.type.include?('Assist') && skill.tags.include?('Move')
    w=$skills.reject{|q| !q.tags.include?('Link')}
    w2=1
  elsif skill.type.include?('Assist') && skill.tags.include?('Rally')
    w=$skills.reject{|q| !q.tags.include?('Feint')}
    w2=1
  elsif skill.isPassive? && skill.tags.include?('Link')
    w=$skills.reject{|q| !q.type.include?('Assist') || !q.tags.include?('Move') || q.tags.include?('Music')}
    w2=2
  elsif skill.isPassive? && skill.tags.include?('Feint')
    w=$skills.reject{|q| !q.type.include?('Assist') || !q.tags.include?('Rally')}
    w2=2
  elsif skill.isPassive? && has_any?(skill.tags,['DanceRally','Cantrip'])
    w=$skills.reject{|q| !q.type.include?('Assist') || !q.tags.include?('Music')}
    w2=2
  end
  if w.length>0 && w2>0 && safe_to_spam?(event)
    w=w.reject{|q| !q.isPostable?(event) || !['example','-','',nil].include?(q.level)}
    w=w.sort{|a,b| a.name<=>b.name}
    w=w.map{|q| q.postName}
    create_embed(event,'',['',"Las siguientes habilidades se activan cuando su poseedor usa#{' o es objetivo de' unless skill.tags.include?('Music')} #{skill.name}:","Las siguientes habilidades, cuando se usan en o por la unidad que tiene #{skill.name}, lo activarán:"][w2],skill.disp_color(10+clr),nil,nil,triple_finish(w))
    clr+=1
  elsif event.message.text.downcase.split(' ').include?('refined') && skill.refine.nil? && skill.type.include?('Weapon')
    event.respond "#{skill.name} no tiene refinamientos."
    return nil
  elsif !skill.refine.nil? && !(blevel>0 && !event.message.text.downcase.split(' ').include?('refined'))
    r=skill.refine
    text=''
    for i in 0...r.overrides.length
      if r.overrides[i][6]=='Efecto'
        if skill.name=='Falchion'
          s1=$skills[$skills.find_index{|q| q.name=='Falchion (Mystery)'}]
          s2=$skills[$skills.find_index{|q| q.name=='Falchion (Awakening)'}]
          s3=$skills[$skills.find_index{|q| q.name=='Falchion (Valentia)'}]
          text="#{r.emote(r.overrides[i][6])} **#{s1.name} (+) Modo de Efecto**"
          text="#{text} - #{s1.refinement_name.name}" unless s1.refinement_name.nil?
          if safe_to_spam?(event)
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Eficaz contra:* #{s1.eff_against('Effect',true,event)}" unless s1.eff_against('Effect',true,event).length<=0
            text="#{text}\n#{s1.refine.inner}" unless s1.refine.inner.nil?
            text="#{text}\n#{s1.refine.outer}"
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s2.name} (+) Modo de Efecto**"
            text="#{text} - #{s2.refinement_name.name}" unless s2.refinement_name.nil?
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Eficaz contra:* #{s2.eff_against('Effect',true,event)}" unless s2.eff_against('Effect',true,event).length<=0
            text="#{text}\n#{s2.refine.inner}" unless s2.refine.inner.nil?
            text="#{text}\n#{s2.refine.outer}"
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s3.name} (+) Modo de Efecto**"
            text="#{text} - #{s3.refinement_name.name}" unless s3.refinement_name.nil?
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Eficaz contra:* #{s3.eff_against('Effect',true,event)}" unless s3.eff_against('Effect',true,event).length<=0
            text="#{text}\n#{s3.refine.inner}" unless s3.refine.inner.nil?
            text="#{text}\n#{s3.refine.outer}"
          else
            text="#{text}\n#{s1.refine.inner}" unless s1.refine.inner.nil?
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s2.name} (+) Modo de Efecto**"
            text="#{text} - #{s2.refinement_name.name}" unless s2.refinement_name.nil?
            text="#{text}\n#{s2.refine.inner}" unless s2.refine.inner.nil?
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s3.name} (+) Modo de Efecto**"
            text="#{text} - #{s3.refinement_name.name}" unless s3.refinement_name.nil?
            text="#{text}\n#{s3.refine.inner}" unless s3.refine.inner.nil?
            text="#{text}\n\n<:Refine_Unknown:455609031701299220>**All Effect Refines**"
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Eficaz contra:* #{s2.eff_against('Effect',false,event)}" unless s2.eff_against('Effect',false,event).length<=0
            text="#{text}\n#{s2.refine.outer}"
          end
        elsif skill.name=='Missiletainn'
          s1=$skills[$skills.find_index{|q| q.name=='Missiletainn (Dark)'}]
          s2=$skills[$skills.find_index{|q| q.name=='Missiletainn (Dusk)'}]
          text="#{r.emote(r.overrides[i][6])} **#{s1.name} (+) Modo de Efecto**"
          text="#{text} - #{s1.refinement_name.name}" unless s1.refinement_name.nil?
          if safe_to_spam?(event)
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Eficaz contra:* #{s1.eff_against('Effect',false,event)}" unless s1.eff_against('Effect',false,event).length<=0
            text="#{text}\n#{s1.refine.inner}" unless s1.refine.inner.nil?
            text="#{text}\n#{s1.refine.outer}"
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s2.name} (+) Modo de Efecto**"
            text="#{text} - #{s2.refinement_name.name}" unless s2.refinement_name.nil?
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Eficaz contra:* #{s2.eff_against('Effect',false,event)}" unless s2.eff_against('Effect',false,event).length<=0
            text="#{text}\n#{s2.refine.inner}" unless s2.refine.inner.nil?
            text="#{text}\n#{s2.refine.outer}"
          else
            text="#{text}\n#{s1.refine.inner}" unless s1.refine.inner.nil?
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s2.name} (+) Modo de Efecto**"
            text="#{text} - #{s2.refinement_name.name}" unless s2.refinement_name.nil?
            text="#{text}\n#{s2.refine.inner}" unless s2.refine.inner.nil?
            text="#{text}\n\n<:Refine_Unknown:455609031701299220>**All Effect Refines**"
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Eficaz contra:* #{s2.eff_against('Effect',false,event)}" unless s2.eff_against('Effect',false,event).length<=0
            text="#{text}\n#{s2.refine.outer}"
          end
        elsif !skill.exclusivity.nil? && skill.exclusivity.include?('Nebby')
          x=r.inner.split('  ')
          text="#{r.emote(r.overrides[i][6])} **#{skill.name} (+) Modo Metálico**"
          text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
          text="#{text}\n*Eficaz contra:* #{skill.eff_against('Effect',false,event)}" unless skill.eff_against('Effect',false,event).length<=0
          text="#{text}\n#{x[0]}"
          text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{skill.name} (+) Modo Espectro**"
          text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
          text="#{text}\n*Eficaz contra:* #{skill.eff_against('Effect',false,event)}" unless skill.eff_against('Effect',false,event).length<=0
          text="#{text}\n#{x[1]}"
        else
          text="#{r.emote(r.overrides[i][6])} **#{skill.name} (+) Modo de #{r.overrides[i][6]}**"
          text="#{text} - #{skill.refinement_name.name}" unless skill.refinement_name.nil?
          text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
          text="#{text}\n*Eficaz contra:* #{skill.eff_against('Effect',false,event)}" unless skill.eff_against('Effect',false,event).length<=0
          text="#{text}\n#{r.inner}" unless r.inner.nil?
          if r.outer.nil?
            text="#{text}\n#{skill.description}" unless skill.description.nil? || skill.description.length<=0
            text="#{text}\n*Desventaja:* #{skill.dagger_debuff.join('   *Afecta:* ')}" unless skill.dagger_debuff.nil?
            text="#{text}\n*Pulidor:* #{skill.dagger_buff.join('   *Afecta:* ')}" unless skill.dagger_buff.nil?
          elsif r.outer.include?(' *** ')
            x=r.outer.split(' *** ')
            text="#{text}\n#{x[0]}" unless x[0].nil? || x[0].length<=0 || x[0]=='-'
            x=x.map{|q| q.split(', ')}
            text="#{text}\n*Desventaja:* #{x[1].join('   *Afecta:* ')}" unless x[1].nil?
            text="#{text}\n*Pulidor:* #{x[2].join('   *Afecta:* ')}" unless x[2].nil?
          else
            text="#{text}\n#{r.outer}"
            text="#{text}\n*Desventaja:* #{skill.dagger_debuff.join('   *Afecta:* ')}" unless skill.dagger_debuff.nil?
            text="#{text}\n*Pulidor:* #{skill.dagger_buff.join('   *Afecta:* ')}" unless skill.dagger_buff.nil?
          end
          text="#{text}\nSi el Alcance del enemigo = 2, calcula el daño usando el valor más bajo de Def o Res." if (has_any?(skill.tags,['Frostbite','(E)Frostbite','(R)Frostbite']) && !skill.description.include?("i el Alcance del enemigo = 2, calcula el daño usando el valor más bajo de Def o Res")) || (skill.restrictions.include?('Dragons Only') && !skill.tags.include?('UnFrostbite'))
        end
        text="#{text}\n" if safe_to_spam?(event) || r.overrides[1,r.overrides.length-1].map{|q| q[7]}.compact.length>0
      elsif safe_to_spam?(event) || !r.overrides[i][7].nil?
        text="#{text}\n#{r.emote(r.overrides[i][6])} **Modo de #{r.overrides[i][6]}**  \u200B  \u200B  \u200B  #{r.dispStats(r.overrides[i][6],true)}"
      end
    end
    unless skill.restrictions.include?('Staff Users Only') && skill.tome_tree.nil?
      every=[]
      every.push("*Eficaz contra:* #{skill.eff_against('Refine',true,event)}") unless skill.eff_against('Refine',true,event).length<=0
      if r.outer.nil?
        every.push(skill.description) unless skill.description.nil? || skill.description.length<=0
        every.push("*Desventaja:* #{skill.dagger_debuff.join('   *Afecta:* ')}") unless skill.dagger_debuff.nil?
        every.push("*Pulidor:* #{skill.dagger_buff.join('   *Afecta:* ')}") unless skill.dagger_buff.nil?
      elsif r.outer.include?(' *** ')
        x=r.outer.split(' *** ')
        every.push(x[0]) unless x[0].nil? || x[0].length<=0 || x[0]=='-'
        x=x.map{|q| q.split(', ')}
        x=x.map{|q| [q[0].split(' (')[0],q[1]]} if skill.name=='Peshkatz'
        every.push("*Desventaja:* #{x[1].join('   *Afecta:* ')}") unless x[1].nil?
        every.push("*Pulidor:* #{x[2].join('   *Afecta:* ')}") unless x[2].nil?
      else
        every.push(r.outer)
        every.push("*Desventaja:* #{skill.dagger_debuff.join('   *Afecta:* ')}") unless skill.dagger_debuff.nil?
        every.push("*Pulidor:* #{skill.dagger_buff.join('   *Afecta:* ')}") unless skill.dagger_buff.nil?
      end
      every.push("Si el Alcance del enemigo = 2, calcula el daño usando el valor más bajo de Def o Res.") if (has_any?(skill.tags,['Frostbite','(E)Frostbite','(R)Frostbite']) && !skill.description.include?("i el Alcance del enemigo = 2, calcula el daño usando el valor más bajo de Def o Res")) || (skill.restrictions.include?('Dragons Only') && !skill.tags.include?('UnFrostbite'))
      typ=' de Estadísticas'
      typ=' Predeterminados' if skill.restrictions.include?('Staff Users Only') && skill.tome_tree=='WrazzleDazzle'
      typ='' if r.overrides[0][6]!='Effect' && r.overrides[0][6]!='Efecto'
      text="#{text}\n\n<:Refine_Unknown:455609031701299220>**Todos los Refinamientos#{typ}**\n#{every.join("\n")}" if safe_to_spam?(event) && every.length>0
    end
    ftr='Cada refinamiento tiene un precio: 350 SP (525 si es heredado), 500<:Arena_Medal:453618312446738472> 50<:Refining_Stone:453618312165720086>'
    ftr='Cada refinamiento tiene un precio: 400 SP, 500<:Arena_Medal:453618312446738472> 200<:Divine_Dew:453618312434417691>' unless skill.exclusivity.nil?
    text="#{text}\n\n#{ftr}".gsub("\n\n\n","\n\n")
    if text.length>1900
      text=text.split("\n\n")
      if safe_to_spam?(event) && text[-2][0,'<:Refine_Unknown:455609031701299220>'.length]=='<:Refine_Unknown:455609031701299220>'
        text[-3]="#{text[-3]}\n\n#{text[-2]}"
        text[-2]=nil
        text.compact!
      end
      str=text[0]
      for i in 1...text.length
        if "#{str}\n\n#{text[i]}".length>=1800
          create_embed(event,'__**Opciones de Refinería**__',str,skill.disp_color(10+clr),nil,r.thumbnail) if clr==1
          create_embed(event,'',str,skill.disp_color(10+clr)) unless clr==1
          str=text[i]
          clr+=1
        else
          str="#{str}\n\n#{text[i]}"
        end
      end
      create_embed(event,'',str,skill.disp_color(10+clr))
    else
      create_embed(event,'__**Opciones de Refinería**__',text,skill.disp_color(10+clr),nil,r.thumbnail)
    end
    clr+=1
  end
  if has_any?(event.message.text.downcase.split(' '),['tags','tag'])
    str=''
    flds=nil
    k=skill.tags.map{|q| q}
    if skill.type.include?('Weapon')
      str="#{str}\n**Espacio:**  <:Skill_Weapon:444078171114045450> Weapon"
      k=k.reject{|q| q=='Weapon'}
      clrs=k.reject{|q| !['Red','Blue','Green','Colorless','Purple'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clrs[i]}_Unknown"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Color#{'es' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['Red','Blue','Green','Colorless','Purple'].include?(q)}
      clrs=k.reject{|q| !['Blade','Tome','Breath','Bow','Dagger','Staff','Beast','Gun'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{clrs[i]}"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Tipo#{'s' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['Blade','Tome','Breath','Bow','Dagger','Staff','Beast','Gun'].include?(q)}
      if k.reject{|q| q.include?('(E)') || q.include?('(R)') || q.include?('(T)') || q.include?('(TE)') || q.include?('(TR)') || q.include?('(ET)') || q.include?('(RT)') || q.include?('(T)(E)') || q.include?('(T)(R)') || q.include?('(E)(T)') || q.include?('(R)(T)')}.length<k.length
        flds=[['Arma base',[]],['Todos los refinamientos',[]],['Refinamiento para el efecto',[]],['Base transformada',[]],['Transformación refinada',[]],['Transformación del efecto',[]]]
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
      end
    elsif skill.type.include?('Assist')
      str="#{str}\n**Espacio:** <:Skill_Assist:444078171025965066> Assist"
      k=k.reject{|q| q=='Assist'}
    elsif skill.type.include?('Special')
      str="#{str}\n**Espacio:** <:Skill_Special:444078170665254929> Special"
      k=k.reject{|q| q=='Special'}
    elsif skill.isPassive?
      str="#{str}\n**Espacio:** <:Passive:544139850677485579> Passive"
      k=k.reject{|q| q=='Passive'}
      clrs=k.reject{|q| !['A','B','C','Seal','W'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Passive_#{clrs[i].gsub('Seal','S')}"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Espacio#{'s' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['A','B','C','Seal','W'].include?(q)}
    elsif skill.type.include?('Duo')
      str="#{str}\n**Espacio:** <:Hero_Duo:631431055420948480> Duo"
      k=k.reject{|q| q=='Duo'}
    elsif skill.type.include?('Harmonic')
      str="#{str}\n**Espacio:** <:Hero_Harmonic:722436762248413234> Harmonic"
      k=k.reject{|q| q=='Harmonic'}
    end
    str="#{str}\n\nEstas etiquetas están en inglés porque así es como se almacenan y cómo se deben buscar.\n\n**Etiquetas de búsqueda**"
    flds=triple_finish(k) if flds.nil?
    create_embed(event,'',str,skill.disp_color(clr),nil,nil,flds)
  end
end

def merge_explain_spanish(event,bot)
  disp="1.) Mira las estadísticas de lvl 1 de la unidad original en 5<:Icon_Rarity_5:448266417553539104>"
  disp="#{disp}\n- Las estadísticas deben estar en 5<:Icon_Rarity_5:448266417553539104> independientemente de la rareza de la unidad que se mergea"
  disp="#{disp}\n\n2.) Ordénelos por valor, el más alto primero y el más bajo al final."
  disp="#{disp}\n- en el caso de que dos estadísticas sean iguales, la estadística que va más arriba en el juego va primero"
  disp="#{disp}\n- por lo tanto, si las cinco estadísticas fueran iguales, el orden sería HP, Ataque, Velocidad, Defensa, Resistencia ... exactamente como se muestra en el juego."
  disp="#{disp}\n\n3.) La lista resultante es el orden en el que aumentan las estadísticas, y cada combinación aumenta las siguientes dos estadísticas de la lista, que se repiten."
  disp="#{disp}\n\n4.) Esto significa que la naturaleza de la unidad base puede afectar el orden en que aumentan las estadísticas."
  disp="#{disp}\n- Por ejemplo, las estadísticas neutrales de lvl 1 de Sakura(Halloween) son 16/8/8/4/8. Esto significa que, en circunstancias normales, sus estadísticas aumentan en el siguiente orden: HP->Atk->Vel->Res->Def."
  disp="#{disp}\n- Sin embargo, considere un +Res -Vel Sakura(Halloween); sus estadísticas de nivel 1 son 16/8/7/4/9. Esto cambia el aumento de las estadísticas de orden a HP->Res->Atk->Vel->Def."
  disp="#{disp}\n\n5.) Además, las unidades con al menos un merge obtienen un impulso adicional en sus estadísticas."
  disp="#{disp}\n- Las unidades con naturalezas no neutrales obtienen su bane completamente eliminada."
  disp="#{disp}\n- Las unidades con naturaleza neutra obtienen un punto adicional cada una a las tres primeras estadísticas de la lista creada en el paso 2."
  disp="#{disp}\n- Estos cambios afectan la parte BST del cálculo de la puntuación del coliseo, aunque utiliza estadísticas no mergeadas"
  create_embed(event,"__**Cómo predecir qué estadísticas aumentarán mediante un merge**__",disp,0x008b8b)
end

def spanish_proc_study(bot,event,args=[],skill_list=[],ttags=[],wpnlegal=false,unit=nil,xxyy=[])
  extradmg=0
  for i in 0...skill_list.length
    extradmg+=10 if ['Wrath','Bushido'].include?(skill_list[i])
  end
  x=xxyy[0].map{|q| q}
  y=xxyy[1].map{|q| q}
  px=xxyy[2].map{|q| q}
  py=xxyy[3].map{|q| q}
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
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Astra'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`3* dmg /2#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
    d2="`3* dmg /2#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Regnal Astra'}
  s=skl.find_index{|q| q.name=='Imperial Astra'} if s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[2]*2/5+extradmg2+cdmg2}#{" (#{py[2]*2/5+extradmg2+cdmg2})" unless y[2]*2/5==py[2]*2/5}"
    d2="#{x[2]*2/5+extradmg+cdmg}#{" (#{px[2]*2/5+extradmg+cdmg})" unless x[2]*2/5==px[2]*2/5}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("**#{s.name} - #{d}, cuenta atrás de #{c}**")
  end
  s=skl.find_index{|q| q.name=='Glimmer'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`dmg /2#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
    d2="`dmg /2#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Deadeye'}
  unless s.nil? || unit.weapon_type != 'Bow'
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`dmg#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
    d2="`dmg#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("*#{s.name} - #{d}, cuenta atrás de #{c}, niega la reducción de daños*")
  end
  s=skl.find_index{|q| q.name=='Righteous Wind'}
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[2]*3/10+extradmg2+cdmg2}#{" (#{py[2]*3/10+extradmg2+cdmg2})" unless y[2]*3/10==py[2]*3/10}"
    d2="#{x[2]*3/10+extradmg+cdmg}#{" (#{px[2]*3/10+extradmg+cdmg})" unless x[2]*3/10==px[2]*3/10}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("**#{s.name} - #{d}, cuenta atrás de #{c}, Cura 10 HP a la unidad y a todos los aliados después del combate en el que se activa**")
  end
  flds.push(['<:Special_Offensive_Star:454473651396542504>Estrella',list.join("\n"),1]) if list.length>0
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
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Luna'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`eDR /2#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
    d2="`eDR /2#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Black Luna'}
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`4* eDR /5#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
    d2="`4* eDR /5#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("**#{s.name} - #{d}, cuenta atrás de #{c}**")
  end
  s=skl.find_index{|q| q.name=='Moonbow'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`3* eDR /10#{" +#{extradmg2+cdmg2}" if extradmg2+cdmg2>0}`"
    d2="`3* eDR /10#{" +#{extradmg+cdmg}" if extradmg+cdmg>0}`"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Lunar Flash'}
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`eDR /5 +#{extradmg2+cdmg2+y[2]}`#{" (`eDR /5 +#{extradmg2+cdmg2+py[2]}`)" unless y[2]==py[2]}"
    d2="`eDR /5 +#{extradmg+cdmg+x[2]}`#{" (`eDR /5 +#{extradmg+cdmg+px[2]}`)" unless x[2]==px[2]}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("**#{s.name} - #{d}, cuenta atrás de #{c}**")
  end
  flds.push(['<:Special_Offensive_Moon:454473651345948683>Luna',list.join("\n"),1]) if list.length>0
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
    list.push("#{s.name} - #{wd}cura para #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Sol'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`#{"(" if extradmg2+cdmg2>0}dmg#{" +#{extradmg2+cdmg2})" if extradmg2+cdmg2>0} /2`"
    d2="`#{"(" if extradmg+cdmg>0}dmg#{" +#{extradmg+cdmg})" if extradmg+cdmg>0} /2`"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{wd}cura para #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Noontime'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="`3* #{"(" if extradmg2+cdmg2>0}dmg#{" +#{extradmg2+cdmg2})" if extradmg2+cdmg2>0} /10`"
    d2="`3* #{"(" if extradmg+cdmg>0}dmg#{" +#{extradmg+cdmg})" if extradmg+cdmg>0} /10`"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{wd}cura para #{d}, cuenta atrás de #{c}")
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
    list.push("**#{s.name} - #{wd}, cura para #{d}, cuenta atrás de #{c}**")
  end
  flds.push(['<:Special_Offensive_Sun:454473651429965834>Sol',list.join("\n"),1]) if list.length>0
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
    list.push("#{s.name} - #{wd}, cura para #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Radiant Aether II'}
  s=skl.find_index{|q| q.name=='Radiant Aether'} if s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
  s=skl.find_index{|q| q.name=='Mayhem Aether'} if s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    list.push("**#{s.name} - #{wd}, cura para #{d}, cuenta atrás de #{c}#{', derriba la mitad de la cuenta atrás al comienzo del turno 1' if s.name.include?('II')}**")
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
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Ignis'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[3]*4/5+extradmg2+cdmg2}#{" (#{py[3]*4/5+extradmg2+cdmg2})" unless y[3]*4/5==py[3]*4/5}"
    d2="#{x[3]*4/5+extradmg+cdmg}#{" (#{px[3]*4/5+extradmg+cdmg})" unless x[3]*4/5==px[3]*4/5}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Seidr Shell'}
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{15+extradmg2+cdmg2}"
    d2="#{15+extradmg+cdmg}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("**#{s.name} - #{d}, se adapta a estadísticas defensivas más débiles, cuenta atrás de #{c}**")
  end
  s=skl.find_index{|q| q.name=='Bonfire'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[3]/2+extradmg2+cdmg2}#{" (#{py[3]/2+extradmg2+cdmg2})" unless y[3]/2==py[3]/2}"
    d2="#{x[3]/2+extradmg+cdmg}#{" (#{px[3]/2+extradmg+cdmg})" unless x[3]/2==px[3]/2}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
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
    list.push("**#{s.name} - #{wd}, cura para `dmg/4+#{d}`, cuenta atrás de #{c}**")
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
    list.push("#{s.name} - #{dx} (#{d} cuando está adyacente a un aliado), cuenta atrás de #{c}")
  end
  flds.push(['<:Special_Offensive_Fire:454473651861979156>Fuego',list.join("\n"),1]) if list.length>0
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
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Glacies'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[4]*4/5+extradmg2+cdmg2}#{" (#{py[4]*4/5+extradmg2+cdmg2})" unless y[4]*4/5==py[4]*4/5}"
    d2="#{x[4]*4/5+extradmg+cdmg}#{" (#{px[4]*4/5+extradmg+cdmg})" unless x[4]*4/5==px[4]*4/5}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Iceberg'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[4]/2+extradmg2+cdmg2}#{" (#{py[4]/2+extradmg2+cdmg2})" unless y[4]/2==py[4]/2}"
    d2="#{x[4]/2+extradmg+cdmg}#{" (#{px[4]/2+extradmg+cdmg})" unless x[4]/2==px[4]/2}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Twin Blades'}
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[4]*2/5+extradmg2+cdmg2}#{" (#{py[4]*2/5+extradmg2+cdmg2})" unless y[4]*2/5==py[4]*2/5}"
    d2="#{x[4]*2/5+extradmg+cdmg}#{" (#{px[4]*2/5+extradmg+cdmg})" unless x[4]*2/5==px[4]*2/5}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("**#{s.name} - #{d}, cuenta atrás de #{c}, niega la reducción de daños**")
  end
  flds.push(['<:Special_Offensive_Ice:454473651291422720>Hielo',list.join("\n"),1]) if list.length>0
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
    list.push("**#{s.name} - #{d}, cuenta atrás de #{c}**")
  end
  flds.push(['<:Special_Offensive_Fire:454473651861979156><:Special_Offensive_Ice:454473651291422720>Volcán Gélido',list.join("\n"),1]) if list.length>0
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
    list.push("#{s.name} - hasta #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Dragon Fang'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[1]/2+extradmg2+cdmg2}#{" (#{py[1]/2+extradmg2+cdmg2})" unless y[1]/2==py[1]/2}"
    d2="#{x[1]/2+extradmg+cdmg}#{" (#{px[1]/2+extradmg+cdmg})" unless x[1]/2==px[1]/2}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - hasta #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Draconic Aura'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[1]*3/10+extradmg2+cdmg2}#{" (#{py[1]*3/10+extradmg2+cdmg2})" unless y[1]*3/10==py[1]*3/10}"
    d2="#{x[1]*3/10+extradmg+cdmg}#{" (#{px[1]*3/10+extradmg+cdmg})" unless x[1]*3/10==px[1]*3/10}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - hasta #{d}, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Holy-Knight Aura'}
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[1]/4+extradmg2+cdmg2}#{" (#{py[1]/4+extradmg2+cdmg2})" unless y[1]/4==py[1]/4}"
    d2="#{x[1]/4+extradmg+cdmg}#{" (#{px[1]/4+extradmg+cdmg})" unless x[1]/4==px[1]/4}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("**#{s.name} - #{d}, cuenta atrás de #{c}, otorga movimiento adicional y Atq+6 a todos los aliados después de disparar**")
  end
  s=skl.find_index{|q| q.name=='Fire Emblem'}
  s=skl.find_index{|q| q.name=="Hero's Blood"} if s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[2]*3/10+extradmg2+cdmg2}#{" (#{py[2]*3/10+extradmg2+cdmg2})" unless y[2]*3/10==py[2]*3/10}"
    d2="#{x[2]*3/10+extradmg+cdmg}#{" (#{px[2]*3/10+extradmg+cdmg})" unless x[2]*3/10==px[2]*3/10}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("**#{s.name} - #{d}, cuenta atrás de #{c}**")
  end
  flds.push(['<:Special_Offensive_Dragon:454473651186696192>Dragón',list.join("\n"),1]) if list.length>0
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
    list.push("#{s.name} - #{d} basado en HP que falta, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Vengeance'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{extradmg2+cdmg2}-#{y[0]/2+extradmg2+cdmg2}#{" (#{extradmg2+cdmg2}-#{py[0]/2+extradmg2+cdmg2})" unless y[0]/2==py[0]/2}"
    d2="#{extradmg+cdmg}-#{x[0]/2+extradmg+cdmg}#{" (#{extradmg+cdmg}-#{px[0]/2+extradmg+cdmg})" unless x[0]/2==px[0]/2}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d} basado en HP que falta, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Reprisal'}
  unless s.nil?
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{extradmg2+cdmg2}-#{y[0]*3/10+extradmg2+cdmg2}#{" (#{extradmg2+cdmg2}-#{py[0]*3/10+extradmg2+cdmg2})" unless y[0]*3/10==py[0]*3/10}"
    d2="#{extradmg+cdmg}-#{x[0]*3/10+extradmg+cdmg}#{" (#{extradmg+cdmg}-#{px[0]*3/10+extradmg+cdmg})" unless x[0]*3/10==px[0]*3/10}"
    d="~~#{d}~~ #{d2}" unless d==d2
    list.push("#{s.name} - #{d} basado en HP que falta, cuenta atrás de #{c}")
  end
  flds.push(['<:Special_Offensive_Darkness:454473651010535435>Infierno',list.join("\n"),1]) if list.length>0
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
    list.push("#{s.name} - #{d}, donde X es 2 contra dragones/bestias y 1 contra todos los demás, cuenta atrás de #{c}")
  end
  s=skl.find_index{|q| q.name=='Sublime Heaven'}
  unless s.nil? || skl[s].exclusivity.nil? || !skl[s].exclusivity.include?(unit.name)
    s=skl[s]
    c="#{'~~' unless wpnlegal}#{s.cooldown(ttags)}#{"~~ #{s.cooldown}" unless wpnlegal}"
    d="#{y[1]/4+extradmg2+cdmg2}#{" (#{py[1]/4+extradmg2+cdmg2})" unless y[1]/4==py[1]/4}"
    d2="#{x[1]/4+extradmg+cdmg}#{" (#{px[1]/4+extradmg+cdmg})" unless x[1]/4==px[1]/4}"
    d="~~#{d}~~ #{d2}" unless d==d2
    i="#{y[1]/2+extradmg2+cdmg2}#{" (#{py[1]/2+extradmg2+cdmg2})" unless y[1]/2==py[1]/2}"
    i2="#{x[1]/2+extradmg+cdmg}#{" (#{px[1]/2+extradmg+cdmg})" unless x[1]/2==px[1]/2}"
    i="~~#{i}~~ #{d2}" unless i==i2
    list.push("**#{s.name} - #{i} contra dragones y bestias, #{d} contra todos los demás, cuenta atrás de #{c}, niega la reducción de daños**")
  end
  flds.push(['<:Special_Offensive_Rend:454473651119718401>Rasgón',list.join("\n"),1]) if list.length>0
  return flds
end

def spanish_avatar(bot,event)
  t=Time.now
  timeshift=6
  t-=60*60*timeshift
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event << "Foto de perfil actual: #{bot.user(312451658908958721).avatar_url}"
    event << "Personaje en la foto de perfil: #{@avvie_info[0]}"
    event << ''
    event << "Estado actual:"
    event << "[Playing] #{@avvie_info[1]}"
    event << ''
    event << "Motivo: #{@avvie_info[2]}" unless @avvie_info[2].length.zero?
    event << ''
    event << "Zona horaria del desarrollador: #{t.day} #{$spanish_months[0][t.month]} #{t.year} (un #{$spanish_wday[t.wday]}) | #{'0' if t.hour<10}#{t.hour}:#{'0' if t.min<10}#{t.min}"
  else
    create_embed(event,'',"Personaje en la foto de perfil: #{@avvie_info[0]}\n\nEstado actual:\n[Playing] #{@avvie_info[1]}#{"\n\nMotivo: #{@avvie_info[2]}" unless @avvie_info[2].length.zero?}\n\n[Para un calendario completo de fotos de perfil, haga clic aquí](https://docs.google.com/spreadsheets/d/1j-tdpotMO_DcppRLNnT8DN8Ftau-rdQ-ZmZh5rZkZP0/edit?usp=sharing)",(t.day*7+t.month*21*256+(t.year-2000)*10*256*256),"Zona horaria del desarrollador: #{t.day} #{$spanish_months[0][t.month]} #{t.year} (un #{$spanish_wday[t.wday]}) | #{'0' if t.hour<10}#{t.hour}:#{'0' if t.min<10}#{t.min}",bot.user(312451658908958721).avatar_url)
  end
end

def show_tools_to_spain(event,bot)
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?('mobile') || event.message.text.downcase.include?('phone')
    event << '**Herramientas útiles para jugadores de** ***Fire Emblem Heroes***'
    event << '__Descargar el juego__'
    event << 'Google Play: <https://play.google.com/store/apps/details?id=com.nintendo.zaba&hl=en>'
    event << 'Apple App Store: <https://itunes.apple.com/app/id1181774280>'
    event << ''
    event << '__Noticias__'
    event << 'Noticias del juego: <https://fire-emblem-heroes.com/en/topics/>'
    event << 'Twitter: <https://twitter.com/FE_Heroes_EN>'
    event << '*The Everyday Life of Heroes* manga: <https://fireemblem.gamepress.gg/feh-manga>'
    event << ''
    event << '__Wikis y bases de datos__'
    event << 'Gamepedia FEH wiki: <https://feheroes.gamepedia.com/>'
    event << 'Gamepress FEH database: <https://fireemblem.gamepress.gg/>'
    event << ''
    event << '__Simuladores__'
    event << 'Simulador de invocación: <https://fehstuff.com/summon-simulator/>'
    event << 'Rastreador de herencias: <https://arghblargh.github.io/feh-inheritance-tool/>'
    event << 'Constructor visual de personajes: <https://fehstuff.com/unit-builder/>'
    event << ''
    event << '__Calculadoras de daños__'
    event << "ASFox simulador de duelo masivo: <http://arcticsilverfox.com/feh_sim/>"
    event << "Andu2 simulador de duelo masivo fork: <https://andu2.github.io/FEH-Mass-Simulator/>"
    event << ''
    event << 'FEHKeeper: <https://www.fehkeeper.com/>'
    event << ''
    event << 'Calculadora de puntuación de arena: <http://www.arcticsilverfox.com/score_calc/>'
    event << ''
    event << 'Destello v. Arcoíris lunar: <https://i.imgur.com/kDKPMp7.png>'
  else
    str="__Descargar el juego__"
    str="#{str}\n[Google Play](https://play.google.com/store/apps/details?id=com.nintendo.zaba&hl=en)"
    str="#{str}\n[Apple App Store](https://itunes.apple.com/app/id1181774280)"
    str="#{str}\n\n__Noticias__"
    str="#{str}\n[Noticias del juego](https://fire-emblem-heroes.com/en/topics/)"
    str="#{str}\n[Twitter](https://twitter.com/FE_Heroes_EN)"
    str="#{str}\n[*The Everyday Life of Heroes* manga](https://fireemblem.gamepress.gg/feh-manga)"
    str="#{str}\n\n__Wikis y bases de datos__"
    str="#{str}\n[Gamepedia FEH wiki](https://feheroes.gamepedia.com/)"
    str="#{str}\n[Gamepress FEH database](https://fireemblem.gamepress.gg/)"
    str="#{str}\n\n__Simuladores__"
    str="#{str}\n[Simulador de invocación](https://fehstuff.com/summon-simulator/)"
    str="#{str}\n[Rastreador de herencias](https://arghblargh.github.io/feh-inheritance-tool/)"
    str="#{str}\n[Constructor visual de personajes](https://fehstuff.com/unit-builder)"
    str="#{str}\n\n__Calculadoras de daños__"
    str="#{str}\n[ASFox simulador de duelo masivo](http://arcticsilverfox.com/feh_sim/)"
    str="#{str}\n[Andu2 simulador de duelo masivo fork](https://andu2.github.io/FEH-Mass-Simulator/)"
    str="#{str}\n\n[FEHKeeper](https://www.fehkeeper.com/)"
    str="#{str}\n\n[Calculadora de puntuación de arena](http://www.arcticsilverfox.com/score_calc/)"
    str="#{str}\n\n[Destello v. Arcoíris lunar](https://i.imgur.com/kDKPMp7.png)"
    create_embed(event,'**Herramientas útiles para jugadores de** ***Fire Emblem Heroes***',str,0xD49F61,nil,'https://lh3.googleusercontent.com/r-Am90wLyxj1kOGkAfn3WzVP3GosLbcnyGp_CRof6o3VtFW-Pe7TR1tTJrxAXrqLat4=s180-rw')
    event.respond 'Si está en un dispositivo móvil y no puede hacer clic en los enlaces en la inserción de arriba, escriba `FEH!tools mobile` para recibir este mensaje como texto sin formato.'
  end
end

def summon_sim_spanish(bot,event,args=[])
  if event.server.id==238770788272963585 && event.channel.id != 377526015939051520
    event.respond 'Este comando no está disponible en este canal. Por favor ve a <#377526015939051520>.'
    return nil
  elsif event.server.id==330850148261298176 && event.channel.id != 330851389104455680
    event.respond 'Este comando no está disponible en este canal. Por favor ve a <#330851389104455680>.'
    return nil
  elsif event.server.id==328109510449430529 && event.channel.id != 328136987804565504
    event.respond 'Este comando no está disponible en este canal. Por favor ve a <#328136987804565504>.'
    return nil
  elsif event.server.id==305889949574496257 && event.channel.id != 460903186773835806
    event.respond 'Este comando no está disponible en este canal. Por favor ve a <#460903186773835806>.'
    return nil
  elsif event.server.id==271642342153388034 && event.channel.id != 312736133203361792
    event.respond 'Este comando no está disponible en este canal. Por favor ve a <#312736133203361792>.'
    return nil
  end
  trucolors=[]
  for i in 0...args.length
    trucolors.push('Red') if ['red','reds','all','rojo','roja','rojos','rojas'].include?(args[i].downcase)
    trucolors.push('Blue') if ['blue','blues','all','azul','azules'].include?(args[i].downcase)
    trucolors.push('Green') if ['green','greens','all','verde','verdes'].include?(args[i].downcase)
    trucolors.push('Colorless') if ['colorless','colourless','clear','clears','all','gris','grises'].include?(args[i].downcase)
  end
  autocrack=false
  multisummon=false
  multisummon=true if has_any?(args.map{|q| q.downcase},['multisummon','multi','multiconvocar'])
  if $banner.length>0
    post=Time.now
    if (post - $banner[1]).to_f < 300 # time
      if trucolors.length>0 || multisummon
        autocrack=true
      elsif event.server.id==$banner[2] # server
        event.respond "<@#{$banner[0]}>, elija su citación ya que a otros les gustaría usar este comando" # user
        return nil
      else
        event.respond 'Espere, ya que otro servidor está usando este comando.'
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
  str="**Invocador/a:** #{event.user.distinct}\n\n**Pancarta:** #{b.name}"
  natures=['+HP -Atq','+HP -Vel','+HP -Def','+HP -Res','+Atq -HP','+Atq -Vel','+Atq -Def','+Atq -Res','+Vel -HP','+Vel -Atq','+Vel -Def','+Vel -Res','+Def -HP','+Def -Atq','+Def -Vel','+Def -Res',
           '+Res -HP','+Res -Atq','+Res -Vel','+Res -Def','Neutral']
  natures2=natures.map{|q| q}
  natures=['Neutral'] if ['TT Units','GHB Units'].include?(b.name)
  d=[]
  d.push("#{b.start_date[0]} #{$spanish_months[0][b.start_date[1]]} #{b.start_date[2]}") unless b.start_date.nil?
  d.push("#{b.end_date[0]} #{$spanish_months[0][b.end_date[1]]} #{b.end_date[2]}") unless b.end_date.nil?
  str="#{str}\n*Apariencia del mundo real:* #{d.join(' - ')}" unless d.length<=0
  str="#{str}\n\n__**Personajes de enfoque:**__"
  y=b.full_banner.map{|q| q}
  disprar=false
  disprar=true if y[4].length>0 && y[4]!=y[2]
  disprar=true if y[7].length>0 && y[7]!=y[2]
  disprar=true if y[9].length>0 && y[9]!=y[2]
  disprar=true if y[11].length>0 && y[11]!=y[2]
  xx=b.calc_pity($summon_rate[0])
  disprar=false if xx[4]<=0 && xx[7]<=0 && xx[9]<=0 && xx[11]<=0
  x=b.reds.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if (q.availability[0].include?('4p') || q.availability[0].include?('4s')) && xx[4]>0}#{'<:Icon_Rarity_3:448266417934958592>' if (q.availability[0].include?('3p') || q.availability[0].include?('3s')) && xx[7]>0}#{'<:Icon_Rarity_2:448266417872044032>' if (q.availability[0].include?('2p') || q.availability[0].include?('2s')) && xx[9]>0}#{'<:Icon_Rarity_1:448266417481973781>' if (q.availability[0].include?('1p') || q.availability[0].include?('1s')) && xx[11]>0}"}
  x=b.reds.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Red:455053002256941056> *Rojo*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.blues.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if (q.availability[0].include?('4p') || q.availability[0].include?('4s')) && xx[4]>0}#{'<:Icon_Rarity_3:448266417934958592>' if (q.availability[0].include?('3p') || q.availability[0].include?('3s')) && xx[7]>0}#{'<:Icon_Rarity_2:448266417872044032>' if (q.availability[0].include?('2p') || q.availability[0].include?('2s')) && xx[9]>0}#{'<:Icon_Rarity_1:448266417481973781>' if (q.availability[0].include?('1p') || q.availability[0].include?('1s')) && xx[11]>0}"}
  x=b.blues.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Blue:455053001971859477> *Azul*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.greens.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if (q.availability[0].include?('4p') || q.availability[0].include?('4s')) && xx[4]>0}#{'<:Icon_Rarity_3:448266417934958592>' if (q.availability[0].include?('3p') || q.availability[0].include?('3s')) && xx[7]>0}#{'<:Icon_Rarity_2:448266417872044032>' if (q.availability[0].include?('2p') || q.availability[0].include?('2s')) && xx[9]>0}#{'<:Icon_Rarity_1:448266417481973781>' if (q.availability[0].include?('1p') || q.availability[0].include?('1s')) && xx[11]>0}"}
  x=b.greens.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Green:455053002311467048> *Verde*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.colorlesses.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if (q.availability[0].include?('4p') || q.availability[0].include?('4s')) && xx[4]>0}#{'<:Icon_Rarity_3:448266417934958592>' if (q.availability[0].include?('3p') || q.availability[0].include?('3s')) && xx[7]>0}#{'<:Icon_Rarity_2:448266417872044032>' if (q.availability[0].include?('2p') || q.availability[0].include?('2s')) && xx[9]>0}#{'<:Icon_Rarity_1:448266417481973781>' if (q.availability[0].include?('1p') || q.availability[0].include?('1s')) && xx[11]>0}"}
  x=b.colorlesses.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Colorless:455053002152083457> *Gris*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.golds.map{|q| "#{q.name}<:Icon_Rarity_5p10:448272715099406336>#{'<:Icon_Rarity_4p10:448272714210476033>' if (q.availability[0].include?('4p') || q.availability[0].include?('4s')) && xx[4]>0}#{'<:Icon_Rarity_3:448266417934958592>' if (q.availability[0].include?('3p') || q.availability[0].include?('3s')) && xx[7]>0}#{'<:Icon_Rarity_2:448266417872044032>' if (q.availability[0].include?('2p') || q.availability[0].include?('2s')) && xx[9]>0}#{'<:Icon_Rarity_1:448266417481973781>' if (q.availability[0].include?('1p') || q.availability[0].include?('1s')) && xx[11]>0}"}
  x=b.golds.map{|q| q.name} if !disprar
  str=extend_message(str,"<:Orb_Gold:549338084102111250> *Oro*:  #{x.join(', ')}",event) unless x.length<=0
  x=b.calc_pity($summon_rate[0])
  str2="__**#{'Actual ' unless $summon_rate[0]<=0}Tasas de Invocación**__"
  if x[0]>0
    str2="#{str2}\n6<:Icon_Rarity_6p10:491487784822112256> Enfocar:  #{'%.2f' % x[0]}%"
    str2="#{str2}\nOtro 6<:Icon_Rarity_6:491487784650145812>:  #{'%.2f' % x[1]}%" unless x[1]<=0
  elsif x[1]>0
    str2="#{str2}\n6<:Icon_Rarity_6:491487784650145812> Personaje:  #{'%.2f' % x[1]}%"
  end
  if x[2]>0
    str2="#{str2}\n5<:Icon_Rarity_5p10:448272715099406336> Enfocar:  #{'%.2f' % x[2]}%"
    str2="#{str2}\nOtro 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % x[3]}%" unless x[3]<=0
  elsif x[3]>0
    str2="#{str2}\n5<:Icon_Rarity_5:448266417553539104> Personaje:  #{'%.2f' % x[3]}%"
  end
  if x[4]>0
    str2="#{str2}\n4<:Icon_Rarity_4p10:448272714210476033> Enfocar:  #{'%.2f' % (x[4])}%"
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Especial:  #{'%.2f' % x[5]}%" unless x[5]<=0
    str2="#{str2}\nOtro 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % x[6]}%" unless x[6]<=0
  elsif x[5]>0
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Especial:  #{'%.2f' % x[5]}%"
    str2="#{str2}\nOtro 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % x[6]}%" unless x[6]<=0
  elsif x[6]>0
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Personaje:  #{'%.2f' % x[6]}%"
  end
  if x[7]>0
    str2="#{str2}\n3<:Icon_Rarity_3p10:448294378293952513> Enfocar:  #{'%.2f' % (x[7])}%"
    str2="#{str2}\nOtro 3<:Icon_Rarity_3:448266417934958592>:  #{'%.2f' % x[8]}%" unless x[8]<=0
  elsif x[8]>0
    str2="#{str2}\n3<:Icon_Rarity_3:448266417934958592> Personaje:  #{'%.2f' % x[8]}%"
  end
  if x[9]>0
    str2="#{str2}\n2<:Icon_Rarity_2p10:448294378205872130> Enfocar:  #{'%.2f' % (x[9])}%"
    str2="#{str2}\nOtro 2<:Icon_Rarity_2:448266417872044032>:  #{'%.2f' % x[10]}%" unless x[10]<=0
  elsif x[10]>0
    str2="#{str2}\n2<:Icon_Rarity_2:448266417872044032> Personaje:  #{'%.2f' % x[10]}%"
  end
  if x[11]>0
    str2="#{str2}\n1<:Icon_Rarity_1p10:448294377878716417> Enfocar:  #{'%.2f' % (x[11])}%"
    str2="#{str2}\nOtro 1<:Icon_Rarity_1:448266417481973781>:  #{'%.2f' % x[12]}%" unless x[12]<=0
  elsif x[11]>0
    str2="#{str2}\n1<:Icon_Rarity_1:448266417481973781> Personaje:  #{'%.2f' % x[12]}%"
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
        str2="__**Resultados de Invocación**__"
        for i in 0...r2.length
          str2="#{str2}\nOrbe ##{r2[i][3]} contiene **#{r2[i][0]} #{r2[i][1].name}**#{r2[i][1].emotes(bot,false)} (*#{r2[i][2]}*)"
        end
        str=extend_message(str,str2,event,2)
        str2="En esta sesión de invocación actual, disparaste Breidablik #{r2.length} veces, usando orbes #{[0,5,9,13,17,20][r2.length]}."
        str2="#{str2}\nDesde las últimas 5\* invocaciones, Breidablik se ha disparado #{$summon_rate[0]+r2.length} veces y se han utilizado orbes #{$summon_rate[1]+[0,5,9,13,17,20][r2.length]}."
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
      str2="__**Resultados de Invocación**__"
      for i in 0...r2.length
        str2="#{str2}\nOrbe ##{r2[i][3]} contiene **#{r2[i][0]} #{r2[i][1].name}**#{r2[i][1].emotes(bot,false)} (*#{r2[i][2]}*)"
      end
      str=extend_message(str,str2,event,2)
      str2="En esta sesión de invocación actual, disparaste Breidablik #{r2.length} veces, usando orbes #{[0,5,9,13,17,20][r2.length]}."
      str2="#{str2}\nDesde las últimas 5\* invocaciones, Breidablik se ha disparado #{$summon_rate[0]+r2.length} veces y se han utilizado orbes #{$summon_rate[1]+[0,5,9,13,17,20][r2.length]}."
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
    str2='__**Optiones de orbes**__'
  end
  for i in 0...r.length
    wemote=''
    clrx=r[i][1].weapon_color
    clr=r[i][1].weapon_spanish(true)[0]
    clr='Oro' unless ['Rojo','Azul','Verde','Gris'].include?(clr)
    clrx='Gold' unless ['Rojo','Azul','Verde','Gris'].include?(clr)
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Orb_#{clrx}"}
    wemote=moji[0].mention unless moji.length<=0
    str2="#{str2}\nOrbe ##{r[i][3]}.) #{wemote} #{clr}"
  end
  str=extend_message(str,str2,event,2)
  str2="Para abrir orbes, responda, en un solo mensaje, con el número de cada orbe que desea romper o los colores de esos orbes."
  str2="#{str2}\nTambién puedes decir \"Summon all\" para abrir todos los orbes."
  str2="#{str2}\nIncluya la palabra \"Multisummon\" (con colores opcionales) para continuar convocando hasta que saque un 5<:Icon_Rarity_5:448266417553539104>."
  str=extend_message(str,str2,event,2)
  event.respond str
  $banner=[event.user.id, Time.now, event.server.id, r.map{|q| q}, b.clone]
  trucolors=[]; trucolors2=[]
  trucolors2.push(['Red',['red','reds','rojo','roja','rojos','rojas']])
  trucolors2.push(['Blue',['blue','blues','azul','azules']])
  trucolors2.push(['Green',['green','greens','verde','verdes']])
  trucolors2.push(['Colorless',['colorless','colourless','clear','clears','grey','greys','gray','grays','gris','grises']])
  for i in 0...5
    trucolors.push(['Red',['red','reds','rojo','roja','rojos','rojas']]) if $banner[3][i][1].weapon_color=='Red'
    trucolors.push(['Blue',['blue','blues','azul','azules']]) if $banner[3][i][1].weapon_color=='Blue'
    trucolors.push(['Green',['green','greens','verde','verdes']]) if $banner[3][i][1].weapon_color=='Green'
    trucolors.push(['Colorless',['colorless','colourless','clear','clears','grey','greys','gray','grays','gris','grises']]) if $banner[3][i][1].weapon_color=='Colorless'
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
      multi_summon_spanish(bot,event,e,e.user.id,l)
    elsif e.user.id==$banner[0] && e.message.text.downcase.include?('summon all')
      puts e.message.text
      crack_orbs_spanish(bot,event,e,e.user.id,[1,2,3,4,5])
    elsif e.user.id==$banner[0] && (e.message.text =~ /1|2|3|4|5/ || has_any?(trucolors.map{|q| q[1]}.join(' ').split(' '),e.message.text.downcase.split(' ')))
      puts e.message.text
      l=[]
      for i in 1...6
        l.push(i) if e.message.text.include?(i.to_s)
      end
      for i in 0...trucolors.length
        l.push(trucolors[i][0]) if has_any?(trucolors[i][1],e.message.text.downcase.split(' '))
      end
      crack_orbs_spanish(bot,event,e,e.user.id,l)
    end
  end
  return nil
end

def crack_orbs_spanish(bot,event,e,user,list) # used by the `summon` command to wait for a reply
  summons=0
  five_focus=false
  five_star=false
  trucolors=[]
  bnr=$banner[3].map{|q| q}
  str=''
  for i in 0...5
    if list.include?(bnr[i][1].weapon_color) || list.include?(bnr[i][3])
      str="#{str}\nOrbe ##{bnr[i][3]} contenía #{bnr[i][0]} **#{bnr[i][1].name}#{bnr[i][1].emotes(bot,false)}** (*#{bnr[i][2]}*)"
      summons+=1
      five_star=true if bnr[i][4]>4
      five_focus=true if bnr[i][4]>4 && bnr[i][0].include?('p10')
    end
  end
  str="#{str}\n\nEn esta sesión de invocación actual, disparaste Breidablik #{summons} veces, usando orbes #{[0,5,9,13,17,20][summons]}."
  metadata_load()
  $summon_rate[0]+=summons
  $summon_rate[1]+=[0,5,9,13,17,20][summons]
  str="#{str}\nDesde las últimas 5\* invocaciones, Breidablik se ha disparado #{$summon_rate[0]} veces y se han utilizado orbes #{$summon_rate[1]}."
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

def multi_summon_spanish(bot,event,e,user,list,str='',wheel=0,srate=nil,bnr=nil,w2=nil)
  srate=$summon_rate.map{|q| q} if srate.nil?
  bnr=$banner[4].clone if $banner.length>4 && bnr.nil?
  w2=$banner[3].map{|q| q} if $banner.length>3 && w2.nil?
  summons=0
  five_focus=false
  five_star=false
  trucolors=[]
  for i in 0...list.length
    trucolors.push('Red') if ['red','reds','all','rojo','roja','rojos','rojas'].include?(list[i].downcase)
    trucolors.push('Blue') if ['blue','blues','all','azul','azules'].include?(list[i].downcase)
    trucolors.push('Green') if ['green','greens','all','verde','verdes'].include?(list[i].downcase)
    trucolors.push('Colorless') if ['colorless','colourless','clear','clears','all','gris','grises'].include?(list[i].downcase)
  end
  trucolors=['Red','Blue','Green','Colorless'] if trucolors.length<=0
  wheel+=1
  str2="__**Rueda ##{wheel}**__"
  r2=w2.reject{|q| !trucolors.include?(q[1].weapon_color)}
  if r2.length<=0
    str2="#{str2} - No hay colores deseados"
    r2=[w2[3]]
  end
  for i in 0...r2.length
    str2="#{str2}\nOrbe ##{r2[i][3]} contenía **#{r2[i][0]} #{r2[i][1].name}**#{r2[i][1].emotes(bot,false)} (*#{r2[i][2]}*)"
  end
  str=extend_message(str,str2,event,2)
  str2="En esta sesión de invocación actual, disparaste Breidablik #{r2.length} veces, usando orbes #{[0,5,9,13,17,20][r2.length]}."
  str2="#{str2}\nDesde las últimas 5\* invocaciones, Breidablik se ha disparado #{srate[0]+r2.length} veces y se han utilizado orbes #{srate[1]+[0,5,9,13,17,20][r2.length]}."
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
  str2="#{str2}\nDebido a que Breidablik ha sido despedido # {srate [0]} veces, ahora tienes la opción de cualquier personaje de enfoque en este pancarta. (No incluido en esta simulación.)" if spark
  str=extend_message(str,str2,event,2)
  event.respond str
  if spark || five_focus
    $banner=[]
    return nil
  end
  x=bnr.calc_pity(srate[0])
  str2="__**Tasas de Invocación**__"
  if x[0]>0
    str2="#{str2}\n6<:Icon_Rarity_6p10:491487784822112256> Enfocar:  #{'%.2f' % x[0]}%"
    str2="#{str2}\nOtra 6<:Icon_Rarity_6:491487784650145812>:  #{'%.2f' % x[1]}%" unless x[1]<=0
  elsif x[1]>0
    str2="#{str2}\n6<:Icon_Rarity_6:491487784650145812> Personaje:  #{'%.2f' % x[1]}%"
  end
  if x[2]>0
    str2="#{str2}\n5<:Icon_Rarity_5p10:448272715099406336> Enfocar:  #{'%.2f' % x[2]}%"
    str2="#{str2}\nOtra 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % x[3]}%" unless x[3]<=0
  elsif x[3]>0
    str2="#{str2}\n5<:Icon_Rarity_5:448266417553539104> Personaje:  #{'%.2f' % x[3]}%"
  end
  if x[4]>0
    str2="#{str2}\n4<:Icon_Rarity_4p10:448272714210476033> Enfocar:  #{'%.2f' % (x[4])}%"
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Especial:  #{'%.2f' % x[5]}%" unless x[5]<=0
    str2="#{str2}\nOtra 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % x[6]}%" unless x[6]<=0
  elsif x[5]>0
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Especial:  #{'%.2f' % x[5]}%" unless x[5]<=0
    str2="#{str2}\nOtra 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % x[6]}%" unless x[6]<=0
  elsif x[6]>0
    str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Personaje:  #{'%.2f' % x[6]}%"
  end
  if x[7]>0
    str2="#{str2}\n3<:Icon_Rarity_3p10:448294378293952513> Enfocar:  #{'%.2f' % (x[7])}%"
    str2="#{str2}\nOtra 3<:Icon_Rarity_3:448266417934958592>:  #{'%.2f' % x[8]}%" unless x[8]<=0
  elsif x[8]>0
    str2="#{str2}\n3<:Icon_Rarity_3:448266417934958592> Personaje:  #{'%.2f' % x[8]}%"
  end
  if x[9]>0
    str2="#{str2}\n2<:Icon_Rarity_2p10:448294378205872130> Enfocar:  #{'%.2f' % (x[9])}%"
    str2="#{str2}\nOtra 2<:Icon_Rarity_2:448266417872044032>:  #{'%.2f' % x[10]}%" unless x[10]<=0
  elsif x[10]>0
    str2="#{str2}\n2<:Icon_Rarity_2:448266417872044032> Personaje:  #{'%.2f' % x[10]}%"
  end
  if x[11]>0
    str2="#{str2}\n1<:Icon_Rarity_1p10:448294377878716417> Enfocar:  #{'%.2f' % (x[11])}%"
    str2="#{str2}\nOtra 1<:Icon_Rarity_1:448266417481973781>:  #{'%.2f' % x[12]}%" unless x[12]<=0
  elsif x[12]>0
    str2="#{str2}\n1<:Icon_Rarity_1:448266417481973781> Personaje:  #{'%.2f' % x[12]}%"
  end
  if srate[0]>=120 && srate[2]%3==0
    str2=str2.gsub('4<:Icon_Rarity_4p10:448272714210476033>',"~~4\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('4<:Icon_Rarity_4:448266418459377684>',"~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('3<:Icon_Rarity_3p10:448294378293952513>',"~~3\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('3<:Icon_Rarity_3:448266417934958592>',"~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('2<:Icon_Rarity_2p10:448294378205872130>',"~~2\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('2<:Icon_Rarity_2:448266417872044032>',"~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
    str2=str2.gsub('1<:Icon_Rarity_1p10:448294377878716417>',"~~1\\*~~ 5<:Icon_Rarity_5p10:448272715099406336>").gsub('1<:Icon_Rarity_1:448266417481973781>',"~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>")
  end
  r=[]
  rar=[6,6,5,5,4,4,4,3,3,2,2,1,1]
  natures=['+HP -Atq','+HP -Vel','+HP -Def','+HP -Res','+Atq -HP','+Atq -Vel','+Atq -Def','+Atq -Res','+Vel -HP','+Vel -Atq','+Vel -Def','+Vel -Res','+Def -HP','+Def -Atq','+Def -Vel','+Def -Res',
           '+Res -HP','+Res -Atq','+Res -Vel','+Res -Def','Neutral']
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
  multi_summon_spanish(bot,event,e,user,list,str2,wheel,srate,bnr,r)
end

def add_new_alias_to_spain(bot,event,newname,unit,modifier=nil,modifier2=nil,mode=0)
  nicknames_load()
  err=false
  str=''
  if !event.server.nil? && event.server.id==363917126978764801
    str="Ustedes revocaron su permiso para agregar alias cuando se negaron a escucharme con respecto al alias de Erk para Serra."
    err=true
  elsif newname.nil? || unit.nil?
    str="El sistema de alias puede cubrir lo siguiente:\n- Personajes\n- Habilidades (Armas, Asistencias, Especiales, Pasivas)\n- Estructuras\n- Artículos\n- Accesorios\n\nDebe especificar ambos de los siguientes:\n- uno de los anteriores\n- un alias que desea darle a ese objeto"
    err=true
  elsif event.user.id != 167657750971547648 && event.server.nil?
    str='Solo mi desarrollador puede usar este comando en mensajes privados.'
    err=true
  elsif !is_mod?(event.user,event.server,event.channel) && ![368976843883151362,195303206933233665].include?(event.user.id)
    str='No eres moderador.'
    err=true
  elsif newname.include?('"') || unit.include?('"')
    str='Punto final.  " no está permitido en un alias.'
    err=true
  elsif newname.include?("\n") || unit.include?("\n")
    str="No se permiten nuevas líneas en los alias."
    err=true
  end
  if err
    event.respond str if str.length>0 && mode==0
    args=event.message.text.downcase.split(' ')
    args.shift
    list_aliases(event,args,bot) if mode==1
    return nil
  end
  str=''
  type=['Alias','Alias']
  matches=[0,0]
  matchnames=['','']
  newname=newname.gsub('!','').gsub('(','').gsub(')','').gsub('_','')
  k=find_best_match(event,[],newname,bot,true,0)
  if k.nil?
    k=find_best_match(event,[],newname,bot,false,0)
    if k.nil?
    elsif k.is_a?(Array)
      if k[0].is_a?(FEHUnit) && event.user.id != 167657750971547648
      elsif k[0].is_a?(FEHUnit)
        type[0]='Unit*'
        matches[0]=k.map{|q| q.id}
        matchnames[0]=k.map{|q| q.name}.join('/')
      else
        k=k[0]
        type[0]="#{k.objt}*"
        matches[0]=k.fullName
        matches[0]=k.id unless k.id.nil?
        matchnames[0]="#{k.fullName}#{k.emotes(bot,false)}"
      end
    else
      type[0]="#{k.objt}*"
      matches[0]=k.fullName
      matches[0]=k.id unless k.id.nil?
      matchnames[0]="#{k.fullName}#{k.emotes(bot,false)}"
    end
  elsif k.is_a?(Array)
    if k[0].is_a?(FEHUnit) && event.user.id != 167657750971547648
      str="No puedes agregar alias a los multipersonajes."
      err=true
    elsif k[0].is_a?(FEHUnit)
      type[0]='Unit'
      matches[0]=k.map{|q| q.id}
      matchnames[0]=k.map{|q| q.name}.join('/')
    elsif k[0].nil?
    else
      k=k[0]
      type[0]="#{k.objt}"
      matches[0]=k.fullName
      matches[0]=k.id unless k.id.nil?
      matchnames[0]="#{k.fullName}#{k.emotes(bot,false)}"
    end
  else
    type[0]="#{k.objt}"
    matches[0]=k.fullName
    matches[0]=k.id unless k.id.nil?
    matchnames[0]="#{k.fullName}#{k.emotes(bot,false)}"
  end
  unit=unit.gsub('!','').gsub('(','').gsub(')','').gsub('_','')
  k2=find_best_match(event,[],unit,bot,true,0)
  if k2.nil?
    k2=find_best_match(event,[],unit,bot,false,0)
    if k2.nil?
    elsif k2.is_a?(Array)
      if k2[0].is_a?(FEHUnit) && event.user.id != 167657750971547648
      elsif k2[0].is_a?(FEHUnit)
        type[0]='Unit*'
        matches[0]=k2.map{|q| q.id}
        matchnames[0]=k2.map{|q| q.name}.join('/')
      else
        k2=k2[0]
        type[0]="#{k2.objt}*"
        matches[0]=k2.fullName
        matches[0]=k2.id unless k2.id.nil?
        matchnames[0]="#{k2.fullName}#{k2.emotes(bot,false)}"
      end
    else
      type[0]="#{k2.objt}*"
      matches[0]=k2.fullName
      matches[0]=k2.id unless k2.id.nil?
      matchnames[0]="#{k2.fullName}#{k2.emotes(bot,false)}"
    end
  elsif k2.is_a?(Array)
    if k2[0].is_a?(FEHUnit) && event.user.id != 167657750971547648
      str="No puedes agregar alias a los multipersonajes."
      err=true
    elsif k2[0].is_a?(FEHUnit)
      type[1]='Unit'
      matches[1]=k2.map{|q| q.id}
      matchnames[1]=k2.map{|q| q.name}.join('/')
    elsif k2[0].nil?
    else
      k2=k2[0]
      type[1]="#{k2.objt}"
      matches[1]=k2.fullName
      matches[1]=k2.id unless k2.id.nil?
      matchnames[1]="#{k2.fullName}#{k2.emotes(bot,false)}"
    end
  else
    type[1]="#{k2.objt}"
    matches[1]=k2.fullName
    matches[1]=k2.id unless k2.id.nil?
    matchnames[1]="#{k2.fullName}#{k2.emotes(bot,false)}"
  end
  checkstr=normalize(newname,true)
  if type.reject{|q| q != 'Alias'}.length<=0
    type[0]='Alias' if type[0].include?('*')
    type[1]='Alias' if type[1].include?('*') && type[0]!='Alias'
  end
  if type.reject{|q| q == 'Alias'}.length<=0
    alz1=newname
    alz2=unit
    alz1='>Censored mention<' if alz1.include?('@')
    alz2='>Censored mention<' if alz2.include?('@')
    str="El sistema de alias puede cubrir lo siguiente:\n- Personajes\n- Habilidades (Armas, Asistencias, Especiales, Pasivas)\n- Estructuras\n- Artículos\n- Accesorios\n\nNi #{newname} ni #{unit} son ninguno de los anteriores"
    err=true
  elsif type.reject{|q| q != 'Alias'}.length<=0
    alz1=newname
    alz2=unit
    alz1='>Censored mention<' if alz1.include?('@')
    alz2='>Censored mention<' if alz2.include?('@')
    x=['a','a']
    x[0]='an' if ['item','accessory'].include?(type[0].downcase)
    x[1]='an' if ['item','accessory'].include?(type[1].downcase)
    str="#{alz1} is #{x[0]} #{type[0].downcase}\n#{alz2} is #{x[1]} #{type[1].downcase}"
    err=true
  end
  if type[1]=='Alias' && type[0]!='Alias'
    f="#{newname}"
    newname="#{unit}"
    unit="#{f}"
    type=type.reverse.map{|q| q.gsub('*','')}
    matches.reverse!
    matchnames.reverse!
    kk1=k2
    kk2=k
  else
    kk1=k
    kk2=k2
    type=type.map{|q| q.gsub('*','')}
  end
  if newname.include?("\\u{")
    err=true
    str="#{newname} contiene un carácter Unicode Extendido (un carácter con un ID Unicode superior a 65.535, casi todos emoji).\nDebido a la forma en que almaceno los alias y cómo Ruby analiza las cadenas de los archivos de texto, teóricamente podría almacenar un carácter Unicode Extendido pero no puedo encontrar un alias coincidente."
  end
  if err
    str=["#{str}\nInténtalo de nuevo.","#{str}\nIntentando enumerar los alias en su lugar."][mode]
    event.respond str if str.length>0
    args=event.message.text.downcase.split(' ')
    args.shift
    list_aliases(event,args,bot) if mode==1
    return nil
  end
  logchn=log_channel()
  str2=''
  if event.server.nil?
    str2="**PM with dev:**"
  else
    str2="**Server:** #{event.server.name} (#{event.server.id}) - Spanish Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:**"
  end
  str2="#{str2} #{event.user.distinct} (#{event.user.id})"
  if type[1].gsub('*','')=='Unit' && kk2.is_a?(FEHUnit) && first_sub(newname,kk2.alts[0].gsub('*',''),'').length<=1 && event.user.id != 167657750971547648
    event.respond "#{newname} se ha agregado __***NO***__ a los alias de #{matchnames[1]}.\nOne need look no farther than BCamilla, SCamilla, BLucina, BLyn, LLyn, or SXander to understand why single-letter alias differentiation is a bad idea.  Especially BLucina and LLyn."
    bot.channel(logchn).send_message("#{str2}\n~~**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Single-letter differentiation.")
    return nil
  elsif checkstr.downcase =~ /(7|t)+?h+?(o|0)+?(7|t)+?/
    event.respond "#{newname} se ha agregado __***NO***__ a los alias de #{matchnames[1]}."
    bot.channel(logchn).send_message("#{str2}\n~~**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  elsif checkstr.downcase =~ /n+?((i|1)+?|(e|3)+?)(b|g|8)+?(a|4|(e|3)+?r+?)+?/
    event.respond "Ese nombre se ha agregado __***NO***__ a los alias de #{matchnames[1]}.  Incluye una palabra muy mala en inglés que mi desarrollador preferiría no almacenar en su computadora."
    bot.channel(logchn).send_message("#{str2}\n~~**#{type[1].gsub('*','')} Alias:** >CENSORED< for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  end
  newname=normalize(newname,true)
  glbl=10000000000000000000000
  glbl=event.server.id unless event.server.nil?
  if event.user.id==167657750971547648 && modifier.to_i.to_s==modifier
    glbl=0
    glbl=modifier.to_i unless bot.server(modifier.to_i).nil? || bot.on(modifier.to_i).nil?
  elsif [167657750971547648,368976843883151362].include?(event.user.id) && !modifier.nil?
    glbl=0
  end
  alz=$aliases.map{|q| q}
  x=alz.find_index{|q| q[0]==type[1].gsub('*','') && q[1].downcase==newname.downcase && q[2]==matches[1]}
  mewalias=false
  if x.nil?
    m=[type[1].gsub('*',''),newname,matches[1],[glbl]]
    m=[type[1].gsub('*',''),newname,matches[1]] if glbl<=0
    alz.push(m)
    newalias=true
  else
    alz[x][3].push(glbl)
    alz[x][3]=nil if glbl<=0
  end
  typesp=type[1].gsub('*','').downcase
  typesp='de la personaje' if typesp=='unit'
  typesp='de la habilidad' if typesp=='skill'
  typesp='de la estructura' if typesp=='structure'
  typesp='del articulo' if typesp=='item'
  typesp='del accesorio' if typesp=='accessory'
  typesp2=typesp.split(' ')
  typesp2=typesp2[-2,2]
  typesp2=typesp2[1,typesp2.length-1] if typesp[0]=='d'
  str="El alias **#{newname}** para #{typesp2} *#{matchnames[1]}* ya existe en un servidor."
  str="#{str}  Haciéndolo global ahora." if glbl<=0
  str="#{str}  Añadiendo este servidor a aquellos que pueden utilizarlo." unless glbl<=0
  str="**#{newname}** se ha agregado #{'globalmente ' if glbl<=0}a los alias #{typesp} *#{matchnames[1]}*." if newalias
  str="#{str}\nComprueba que el alias funcionó."
  event.respond str
  (bot.channel(modifier2).send_message(str) if !modifier2.nil? && modifier2.to_i.to_s==modifier2) rescue nil
  type[1]='Multiunit' if kk2.is_a?(Array)
  str2="#{str2}\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{matchnames[1]}"
  str2="#{str2} - gained a new server that supports it" unless newalias || glbl<=0
  str2="#{str2} - gone global" if !newalias && glbl<=0
  str2="#{str2} - global alias" if newalias && glbl<=0
  bot.channel(logchn).send_message(str2)
  alz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
  open("#{$location}devkit/FEHNames.txt", 'w') { |f|
    f.puts alz.map{|q| q.to_s}.join("\n")
  }
  bot.channel(logchn).send_message('Alias list saved.')
  nicknames_load()
  unless !$aliases[-1][2].is_a?(String) || $aliases[-1][2]<'Verdant Shard'
    open("#{$location}devkit/FEHNames2.txt", 'w') { |f|
      f.puts alz.map{|q| q.to_s}.join("\n")
    }
    bot.channel(logchn).send_message('Alias list has been backed up.')
  end
  return nil
end

def editar_para_donantes(bot,event,args=[],cmd='')
  uid=event.user.id
  cmd='' if cmd.nil?
  if uid==167657750971547648
    event.respond "This command is for the donors.  Your version of the command is `FEH!devedit`."
    return nil
  elsif !get_donor_list().reject{|q| q[2][0]<4}.map{|q| q[0]}.include?(uid)
    event.respond "No tienes permiso para usar este comando."
    return nil
  elsif !File.exist?("#{$location}devkit/EliseUserSaves/#{uid}.txt")
    event.respond "Espere hasta que mi desarrollador cree su archivo de almacenamiento."
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
  if ['kiranface','kiran','face','summoner','summonerface','cara','caradekiran'].include?(cmd.downcase) && !dulx.find_index{|q| q.name=='Kiran'}.nil?
    dunit=dulx.find_index{|q| q.name=='Kiran'}
    dulx[dunit].face=find_kiran_face(event).gsub(' ','')
    str="La cara de tu #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} se ha cambiado a #{dulx[dunit].face}."
    donorunits_save(uid,dulx)
    event.respond str
    return nil
  end
  unt=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
  unt[1]=first_sub(args.join(' ').downcase,unt[1].downcase,'') unless unt.nil?
  if unt.nil?
    event.respond 'No se encontró ningún personaje. Incluya el nombre de un personaje.'
    return nil
  elsif unt[0].is_a?(Array)
    event.respond "Este comando no funciona con multipersonajes.  Incluya una de las siguientes personajes:\n#{unt[0].map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
    return nil
  end
  extstr="#{unt[1]}"
  unt=unt[0].clone
  dunit=dulx.find_index{|q| q.name==unt.name}
  flurp=find_stats_in_string(event,extstr,1,unt.name)
  supdel=false
  supdel=true if ['unsupport','unmarry','unmarriage','divorce','divorcio'].include?(cmd.downcase)
  supdel=true if ['remove','delete','elimina','eliminar'].include?(cmd.downcase) && ['support','marry','marriage','amistad','matrimonio','casar','casa'].include?(args[0].downcase)
  supdel=true if ['support','marry','marriage','amistad','matrimonio','casar','casa'].include?(cmd.downcase) && ['remove','delete','elimina','eliminar'].include?(args[0].downcase)
  supdel=false if dunit.nil?
  if ['create','crear'].include?(cmd.downcase)
    new_donorunit(bot,event,uid,unt.name,flurp)
  elsif ['kiranweapon','kirantype','summonerweapon','summonertype','armadekiran'].include?(cmd.downcase) || (unt.name=='Kiran' && cmd.downcase=='weapon')
    m=['', '']
    m[0]='Red' if has_any?(['red','reds','rojo','rojos','roja','rojas'],args.map{|q| q.downcase})
    m[0]='Blue' if has_any?(['blue','blues','azul','azules'],args.map{|q| q.downcase})
    m[0]='Green' if has_any?(['green','greens','grean','greans','verde','verdes'],args.map{|q| q.downcase})
    m[0]='Colorless' if has_any?(['colorless','colourless','colorlesses','colourlesses','clear','clears','gris','grises','translucida','translucido'],args.map{|q| q.downcase})
    m[1]='Blade' if has_any?(['physical','blade','blades','close','closerange','fisica','fisico','fisicas','fisicos','filo','filos','cuerpo'],args.map{|q| q.downcase})
    m[1]='Tome' if has_any?(['tome','mage','spell','tomes','mages','spells','range','ranged','distance','distant','tomo','mago','tomos','magos','distante'],args.map{|q| q.downcase})
    m=['Red','Blade'] if has_any?(['sword','swords','katana','espada','espadas'],args.map{|q| q.downcase})
    m=['Blue','Blade'] if has_any?(['lance','lances','lancer','lancers','spear','spears','naginata','lanza','lanzas'],args.map{|q| q.downcase})
    m=['Green','Blade'] if has_any?(['axe','axes','ax','club','clubs','hacha','hachas'],args.map{|q| q.downcase})
    m=['Red','Tome'] if has_any?(['redtome','redtomes','redmage','redmages'],args.map{|q| q.downcase})
    m=['Blue','Tome'] if has_any?(['bluetome','bluetomes','bluemage','bluemages'],args.map{|q| q.downcase})
    m=['Green','Tome'] if has_any?(['greentome','greentomes','greenmage','greenmages'],args.map{|q| q.downcase})
    if m.map{|q| q.length}.max<=0
      event.respond "Especifique el tipo de arma que le gustaría que usara Kiran."
      return nil
    end
    m[0]='Colorless' if m[0].length<=0
    m[1]='Tome' if m[1].length<=0
    m[0]='Red' if m[0]=='Colorless' && m[1]=='Blade'
    if m==dulx[dunit].weapon
      event.respond "Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** ya está usando ese tipo de arma."
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
      str="Necesitarás editar su arma y habilidades tú mismo."
      str="Deberá editar sus habilidades sin armas usted mismo." if xx
      event.respond "Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** ahora está usando #{m}.\n#{str}"
    end
    return nil
  elsif (['remove','delete','send_home','sendhome','fodder','elimina','eliminar'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase) && !supdel
    if !dunit.nil?
      dunit=dulx[dunit]
      $stored_event=[event,unt,dunit,flurp]
      event.respond "Tengo un personaje de donante almacenado para #{dunit.creation_string(bot)}.  ¿Quieres que elimine esta compilación?"
      event.channel.await(:bob, contains: /(si)|(no)/i, from: event.user.id) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          unt2=$stored_event[1].clone
          dunit2=$stored_event[2].clone
          dulx=dulx.reject{|q| q.name==unt2.name}
          donorunits_save(uid,dulx)
          e.respond "Se ha eliminado #{dunit2.creation_string(bot)}de sus personajes de donantes."
        end
      end
    else
      event.respond 'En primer lugar, nunca tuvo esa personaje.'
    end
  elsif dunit.nil?
    $stored_event=[event,unt,dunit,flurp]
    event.respond 'No tienes este personaje. ¿Deseas agregarlos a tu colección?'
    event.channel.await(:bob, contains: /(si)|(no)/i, from: event.user.id) do |e|
      if e.message.text.downcase.include?('no')
        e.respond 'Okey.'
      else
        new_donorunit(bot,e,uid,$stored_event[1].name,$stored_event[3])
      end
    end
  elsif ['promote','rarity','feathers','promover','promove','rareza','plumas'].include?(cmd.downcase)
    if dulx[dunit].rarity>=Max_rarity_merge[0]
      event.respond "Tu #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} ya está en la rareza máxima."
      return nil
    end
    x=1
    r=dulx[dunit].resplendent
    r="#{r}f" if dulx[dunit].forma
    x=flurp[0] unless flurp[0].nil?
    x=flurp[1] unless flurp[1].nil?
    dulx[dunit].rarity="#{dulx[dunit].rarity.to_i+x}"
    dulx[dunit].rarity="#{[dulx[dunit].rarity.to_i,Max_rarity_merge[0]].min}#{r}"
    str="Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** ha sido ascendido a #{dulx[dunit].rarity}#{Rarity_stars[0][dulx[dunit].rarity-1]}."
    p=dulx[dunit].pronoun(true)
    str="#{str}\nSu recuento de fusiones también se ha restablecido a 0" if dulx[dunit].merge_count>0
    dulx[dunit].merge_count=0
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['merge','combine','fusiona','combina','combinar'].include?(cmd.downcase)
    if dulx[dunit].merge_count>=Max_rarity_merge[1]
      event.respond "Tu #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} ya está en la fusion máxima."
      return nil
    elsif args.map{|q| q.downcase}.include?('reset')
      dulx[dunit].merge_count=0
      str="Recuento de fusiones de tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** también se ha restablecido a 0."
      donorunits_save(uid,dulx)
      event.respond str
      return nil
    end
    x=1
    x=flurp[0] unless flurp[0].nil?
    x=flurp[1] unless flurp[1].nil?
    dulx[dunit].merge_count+=x
    dulx[dunit].merge_count=[dulx[dunit].merge_count,Max_rarity_merge[1]].min
    str="Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** se ha fusionado con +#{dulx[dunit].merge_count}."
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['nature','ivs','naturaleza'].include?(cmd.downcase)
    n=''
    if flurp[2].nil? && flurp[3].nil?
      dulx[dunit].boon=' '
      dulx[dunit].bane=' '
      donorunits_save(uid,dulx)
      event.respond "¡Has cambiado la naturaleza de tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** a neutral!"
    elsif flurp[2].nil? && [nil,'',' '].include?(dulx[dunit].boon)
      event.respond "No puedes tener una perdición sin una bendición."
    elsif flurp[3].nil? && dulx[dunit].merge_count>0
      dulx[dunit].boon=flurp[2]
      dulx[dunit].bane=' '
      donorunits_save(uid,dulx)
      event.respond "Has cambiado la naturaleza de tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** a +#{flurp[2]}.\nNo le diste una maldición, pero es posible que quieras hacerlo."
    elsif flurp[3].nil?
      event.respond "No puedes tener una bendición sin una perdición."
    else
      dulx[dunit].boon=flurp[2] unless flurp[2].nil?
      dulx[dunit].bane=flurp[3]
      n=$spanish_Natures.reject{|q| q[1]!=dulx[dunit].boon || q[2]!=dulx[dunit].bane}
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
      event.respond "Has cambiado la naturaleza de tu **#{dunit.name}#{dunit.emotes(bot,false)}** a +#{dunit.boon} -#{dunit.bane}#{" (#{n2})" unless n2.nil?}."
    end
  elsif ['learn','teach','aprender','aprende','enseñar','enseña','ensenar','ensena'].include?(cmd.downcase)
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
      event.respond "Incluya el tipo de habilidad que aprenderá su **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}**."
      return nil
    end
    s='ese tipo'
    s='esos tipos' if skill_types.uniq.length>1
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
      event.respond "Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** no tiene habilidades no aprendidas de #{s}."
      return nil
    end
    skills_learned=[]
    for i in 0...skill_types.length
      if skill_types[i]==6 # skill seals
        seel=dulx[dunit].skills[skill_types[i]][0].scan(/\d+?/)[0].to_i
        seel=dulx[dunit].skills[skill_types[i]][0].gsub(seel.to_s,(seel+1).to_s)
        x=$skills.find_index{|q| q.fullName==seel}
        if x.nil? || !has_any?($skills[x].type,['Seal','Passive(S)'])
          skills_learned.push("#{Skill_Slots[0][skill_types[i]]} ~~#{dulx[dunit].skills[skill_types[i]][0]}~~ (ya maximizada)")
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
    s="__Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** ha aprendido las siguientes habilidades__"
    for i in 0...skills_learned.length
      s=extend_message(s,skills_learned[i],event)
    end
    event.respond s
  elsif ['equip','skill','equipar','equipa'].include?(cmd.downcase)
    skl=find_data_ex(:find_skill,event,extstr.split(' '))
    if skl.nil?
      event.respond "No se incluyó ninguna habilidad."
      return nil
    elsif !has_any?(skl.type,['Weapon','Assist','Special','Passive(A)','Passive(B)','Passive(C)'])
      str="#{skl.name}#{skl.emotes(bot)} no es una habilidad equipable."
      str="#{str}\nUsa `FEH!edit seal` para equipar esto como un Insignia Passiva." if has_any?(skl.type,['Seal','Passive(S)'])
      event.respond str
      return nil
    elsif skl.level=='example'
      sklz=$skills.reject{|q| q.name != skl.name || q.level=='example' || q.level.include?('W') || !q.can_inherit?(dulx[dunit])}
      if sklz.length<=0
        event.respond "Tu *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* no puede equipar a **#{skl.fullName}**#{skl.emotes(bot,true)}"
        return nil
      end
      skl=sklz[-1].clone
    elsif skl.type.include?('Weapon')
      s=skl.legalize(dulx[dunit])
      skl=s[0].clone if s[1]
    end
    if !skl.can_inherit?(dulx[dunit])
      event.respond "Tu *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* no puede equipar a **#{skl.fullName}**#{skl.emotes(bot,true)}"
      return nil
    end
    m=skl.backwards_tree(dulx[dunit])
    mm=m.map{|q| q.fullName}
    str="Tu *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* ahora ha equipado **#{skl.fullName}**#{skl.emotes(bot,true)}."
    if !m[0].prerequisite.nil? && m[0].prerequisite.length>0
      mm.unshift('~~unknown~~')
      str="#{str}\nTiene algunos requisitos previos divididos y no sabía cuál usar, por lo que está marcado como desconocido."
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
          event.respond "#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} no puede equipar esa arma. Inténtalo de nuevo."
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
  elsif ['support','marry','marriage','matrimonio','casar','casa'].include?(cmd.downcase) && !supdel
    if dulx[dunit].true_support=='S'
      event.respond "Ya te has casado con #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}."
    elsif dulx[dunit].true_support=='A'
      dulx[dunit].true_support='S'
      dulx[dunit].support='S'
      donorunits_save(uid,dulx)
      event.respond "¡Te has casado con #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}!  (Apoyo de invocador **#{dulx[dunit].support}**)"
    elsif dulx[dunit].true_support=='B'
      dulx[dunit].true_support='A'
      dulx[dunit].support='A'
      donorunits_save(uid,dulx)
      event.respond "¡Le has propuesto matrimonio a #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}!  (Apoyo de invocador **#{dulx[dunit].support}**)"
    elsif dulx[dunit].true_support=='C'
      dulx[dunit].true_support='B'
      dulx[dunit].support='B'
      donorunits_save(uid,dulx)
      event.respond "¡Has empezado a salir con #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}!  (Apoyo de invocador **#{dulx[dunit].support}**)"
    elsif dulx.reject{|q| [nil,'','-',' '].include?(q.true_support)}.length>=5
      x=dulx.reject{|q| [nil,'','-',' '].include?(q.true_support)}.map{|q| "*#{q.name}#{q.emotes(bot,false)}*"}
      event.respond "Ya eres amigo de #{list_lift(x,'y')}.\nPrimero, elimine su amistad con uno de estos personajes."
    else
      dulx[dunit].true_support='C'
      dulx[dunit].support='C'
      donorunits_save(uid,dulx)
      event.respond "¡Te has hecho amigo de #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}!  (Apoyo de invocador **#{dulx[dunit].support}**)"
    end
  elsif supdel
    if [nil,'','-'].include?(dulx[dunit].true_support)
      event.respond "Nunca tuviste amistad con tu #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}."
    else
      dulx[dunit].true_support=''
      dulx[dunit].support=''
      donorunits_save(uid,dulx)
      event.respond "Has eliminado tu amistad con tu #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}."
    end
  elsif ['seal','insignia'].include?(cmd.downcase)
    skl=find_data_ex(:find_skill,event,extstr.split(' '))
    if skl.nil?
      event.respond "No se incluyó ninguna habilidad."
      return nil
    elsif !has_any?(skl.type,['Seal','Passive(S)'])
      event.respond "#{skl.name}#{skl.emotes(bot)} no es una Insignia Passiva.  Usa `FEH!edit equip` para equipar esa habilidad."
      return nil
    elsif skl.level=='example'
      sklz=$skills.reject{|q| q.name != skl.name || q.level=='example' || q.level.include?('W') || !has_any?(q.type,['Seal','Passive(S)'])}
      skl=sklz[-1].clone
    end
    if !skl.can_inherit?(dulx[dunit])
      event.respond "Tu *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* no puede equipar la Insignia de **#{skl.fullName}**<:Passive_S:443677023626330122>."
      return nil
    end
    dulx[dunit].skills[6]=[skl.fullName]
    str="Tu *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}* ahora usa Insignia de **#{skl.fullName}**<:Passive_S:443677023626330122>."
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['refine','refinement','refinery','refina','refinar'].include?(cmd.downcase)
    dulx[dunit].skills[0].pop if dulx[dunit].skills[0][-1].include?(' (+) ')
    wpname=dulx[dunit].skills[0][-1]
    crs=false
    crs=true if wpname.include?('~~')
    wpname=wpname.gsub('~~','').gsub('__','')
    wpn=$skills.find_index{|q| q.name==wpname}
    wpn=$skills[wpn] unless wpn.nil?
    if wpn.nil?
      event.respond "El arma equipada para tu #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}, #{wpname}, no existe."
      return nil
    elsif wpn.refine.nil?
      event.respond "El arma equipada para tu #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}, **#{wpn.name}#{wpn.emotes(bot)}**, no se puede refinar."
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
      event.respond "No se definió ningún refinamiento. Tus opciones son:\n#{words.join("\n")}"
      return nil
    end
    m="#{wpname} (+) Modo #{refne}"
    m="~~#{m}~~" if crs
    dulx[dunit].skills[0].push(m)
    str="El arma equipada para tu *#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}*, **#{wpn.name}#{wpn.emotes(bot)}**, se ha refinado con su modo #{refne}."
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['flower','flowers','dragonflower','dragonflowers','flor','flores','dracoflor','dracoflores'].include?(cmd.downcase)
    if dulx[dunit].dragonflowers>=dulx[dunit].dragonflowerMax
      event.respond "Tu #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} ya está en el máximo de flores."
      return nil
    elsif args.map{|q| q.downcase}.include?('reset')
      dulx[dunit].dragonflowers=0
      str="El recuento de flores de dragón de tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** se ha restablecido a #{dulx[dunit].dragonflowerEmote}+0."
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
    str="Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** ahora tiene un total de #{dulx[dunit].dragonflowerEmote}+#{dulx[dunit].dragonflowers}."
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['pairup','pair','pair-up','paired','cohort','agrupar','agrupa','par'].include?(cmd.downcase)
    unt2=find_data_ex(:find_unit,event,extstr.split(' '),nil,bot,false,0)
    dunit2=nil
    dunit2=dulx.find_index{|q| q.name==unt2.name} unless unt2.nil?
    order=[]
    if dunit2.nil? || dunit==dunit2
      event.respond "Este subcomando requiere dos personajes donantes."
      return nil
    elsif !dulx[dunit].legendary.nil? && dulx[dunit].legendary[1]=='Duel'
      order=[dulx[dunit].clone,dulx[dunit2].clone]
    elsif !dulx[dunit2].legendary.nil? && dulx[dunit2].legendary[1]=='Duel'
      order=[dulx[dunit2].clone,dulx[dunit].clone]
    else
      event.respond "Ni #{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)} ni #{dulx[dunit2].name}#{dulx[dunit2].emotes(bot,false)} es un personaje que tenga Agrupares controlables."
      return nil
    end
    for i in 0...dulx.length
      dulx[i].cohort=nil if [unt.name,unt2.name].include?(dulx[i].cohort)
    end
    dulx[dunit].cohort=dulx[dunit2].name
    dulx[dunit2].cohort=dulx[dunit].name
    donorunits_save(uid,dulx)
    event.respond "Tu **#{order[0].name}#{order[0].emotes(bot,false)}** ahora usa **#{order[1].name}#{order[1].emotes(bot,false)}** como una personaje de cohorte."
  elsif ['resplendant','resplendent','ascenscion','ascension','ascend','resplend'].include?(cmd.downcase)
    if !unt.hasResplendent?
      event.respond "#{unt.name}#{untz.emotes(bot,false)} no tiene una Ascensión Resplandecientea su disposición."
      return nil
    end
    r=dulx[dunit].resplendent
    str="Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** ha alcanzado su Resplandeciente Ascensión."
    if r=='r'
      r='u'
      str="Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** mantiene las estadísticas de su Ascensión Resplandeciente, pero usa su arte predeterminado."
    elsif r=='u'
      r='r'
      str="Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** regresa a su Resplandeciente Ascensión."
    else
      r='r'
    end
    r="#{r}f" if dulx[dunit].forma
    dulx[dunit].rarity="#{dulx[dunit].rarity.to_i}#{r}"
    donorunits_save(uid,dulx)
    event.respond str
  elsif ['forma','quimérica','quimerica'].include?(cmd.downcase)
    if !unt.hasForma?
      event.respond "#{unt.name}#{untz.emotes(bot,false)} no está disponible como Personaje Quiméric#{unt.spanish_gender.downcase}."
      return nil
    end
    r=dulx[dunit].resplendent
    str="Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** es ahora un#{'a' if unit.gender=='F'} Personaje Quiméric#{unt.spanish_gender.downcase}."
    if dulx[dunit].forma
      str="Tu **#{dulx[dunit].name}#{dulx[dunit].emotes(bot,false)}** ya no es un#{'a' if unit.gender=='F'} Personaje Quiméric#{unt.spanish_gender.downcase}."
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

def display_date(event,t,shift=false)
  str="Tiempo transcurrido desde el reinicio de hoy: #{"#{t.hour} horas, " if t.hour>0}#{"#{'0' if t.min<10}#{t.min} minutos, " if t.hour>0 || t.min>0}#{'0' if t.sec<10}#{t.sec} segundos"
  str="#{str}\nTiempo hasta el reinicio de mañana: #{"#{23-t.hour} horas, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutos, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} segundos"
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  if shift
    str="La cita de mañana: #{t.day} #{$spanish_months[0][t.month]} #{t.year} (#{$spanish_wday[t.wday]})"
    str="#{str}\nDías desde el lanzamiento del juego, ven mañana: #{longFormattedNumber(date)}"
  else
    str="#{str}\nLa temporada de la Arena termina en #{"#{15-t.hour} horas, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutos, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} segundos.  ¡Completa tus misiones diarias relacionadas con la arena antes de esa fecha!" if date%7==4 && 15-t.hour>=0
    str="#{str}\nLa temporada de Asaltos Etéreos termina en #{"#{15-t.hour} horas, " if 15-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutos, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} segundos.  ¡Completa todas las misiones relacionadas con el Etéreos antes de esa fecha!" if date%7==4 && 15-t.hour>=0
    str="#{str}\nLas misiones mensuales terminan en #{"#{23-t.hour} horas, " if 23-t.hour>0}#{"#{'0' if 59-t.min<10}#{59-t.min} minutos, " if 23-t.hour>0 || 59-t.min>0}#{'0' if 60-t.sec<10}#{60-t.sec} segundos.  ¡Completalas antes de entonces!" if t.month != (t+24*60*60).month
    str="#{str}\n\nLa fecha asumiendo que el reinicio es a la medianoche: #{t.day} #{$spanish_months[0][t.month]} #{t.year} (#{$spanish_wday[t.wday]})"
    str="#{str}\nDías desde el lanzamiento del juego: #{longFormattedNumber(date)}"
  end
  if event.user.id==167657750971547648 && Shardizard==4
    str="#{str}\nCiclos diarios#{' de mañana' if shift}: #{date%5+1}/5 - #{date%7+1}/7 - #{date%12+1}/12"
    str="#{str}\nCiclos semanales#{' de mañana' if shift}: #{week_from(date,3)%4+1}/4(#{$spanish_wday[0]}) - #{week_from(date,2)%6+1}/6(#{$spanish_wday[6]}) - #{week_from(date,0)%12+1}/12(#{$spanish_wday[4]}) - #{week_from(date,3)%31+1}/31(#{$spanish_wday[0]})"
  end
  return str
end

def today_en_feh(event,bot,shift=false,chain='')
  colors=['Verde <:Shard_Green:443733397190344714><:Crystal_Verdant:445510676845166592><:Badge_Verdant:445510676056899594><:Great_Badge_Verdant:443704780943261707>',
          'Gris <:Shard_Colorless:443733396921909248><:Crystal_Transparent:445510676295843870><:Badge_Transparent:445510675976945664><:Great_Badge_Transparent:443704781597573120>',
          'Oro <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Aleatorio <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Oro <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Aleatorio <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Oro <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Aleatorio <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
          'Rojo <:Shard_Red:443733396842348545><:Crystal_Scarlet:445510676350500897><:Badge_Scarlet:445510676060962816><:Great_Badge_Scarlet:443704781001850910>',
          'Azul <:Shard_Blue:443733396741554181><:Crystal_Azure:445510676434124800><:Badge_Azure:445510675352125441><:Great_Badge_Azure:443704780783616016>']
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
  rd=['Caballería <:Icon_Move_Cavalry:443331186530451466>','Volador <:Icon_Move_Flier:443331186698354698>','Infantería <:Icon_Move_Infantry:443331187579289601>',
      'Blindadas <:Icon_Move_Armor:443331186316673025>']
  garden=['Tierra <:Legendary_Effect_Earth:443331186392170508>','Fuego <:Legendary_Effect_Fire:443331186480119808>','Agua <:Legendary_Effect_Water:443331186534776832>',
          'Viento <:Legendary_Effect_Wind:443331186467536896>']
  t=Time.now
  timeshift=8
  timeshift-=1 unless (t-24*60*60).dst?
  t-=60*60*timeshift
  str=date_display(event,t)
  str2='__**Hoy en** ***Fire Emblem Heroes***__'
  if shift
    str=str.split("\n\n")
    str[1]="~~#{str[1]}~~"
    t+=24*60*60
    str.push(date_display(event,t,true))
    str=str.join("\n\n")
    str2='__**Mañana en** ***Fire Emblem Heroes***__'
  end
  str="#{chain}" if chain.length>0
  t2=Time.new(2017,2,2)-60*60
  t2=t-t2
  date=(((t2.to_i/60)/60)/24)
  str2="#{str2}\nColor de Torre de Práctica: #{colors[date%colors.length]}"
  str2="#{str2}\nBatalla Diaria: #{dhb[date%dhb.length]}"
  str2="#{str2}\n¡Bono SP de fin de semana!" if [1,2,3].include?(date%7)
  str2="#{str2}\nMapa de Práctica Especial: #{['Magia','Práctica general','Adyacentes','A distancia','Arcos'][date%5]}"
  str2="#{str2}\nRenacimiento de Batalla Mítica: #{ghb[date%ghb.length].split(' / ')[0]}"
  str2="#{str2}\nRenacimiento 2 de Batalla Mítica: #{ghb[date%ghb.length].split(' / ')[1]}"
  if rd[week_from(date,2)%rd.length]==''
    str2="#{str2}\n~~Dominios rivales~~ Def. por relevos"
  else
    str2="#{str2}\nPreferencia de movimiento de Dominios Rivales: #{rd[week_from(date,2)%rd.length]}"
  end
  if (date)%7==0
    str2="#{str2}\nNueva incorporación de Maniobras: #{['Estudios de Habilidades','Gran maestro'][week_from(date,0)%2]}"
  else
    str2="#{str2}\nLa última incorporación de Maniobras: #{['Estudios de Habilidades','Gran maestro'][week_from(date,0)%2]}"
  end
  if [10,11].include?(week_from(date,0)%12)
    str2="#{str2}, 1<:Orb_Rainbow:471001777622351872> recompensa"
  else
    str2="#{str2}, 300<:Hero_Feather:471002465542602753> recompensa"
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
    str=extend_message(str,"**Personajes del Renacimiento de mañana:** #{f.join(', ')}",event,2) if chain.length>0 && t.wday==0
    str=extend_message(str,"**Personajes Actuales del Renacimiento:** #{f.join(', ')}",event,2) if chain.length<=0 && !shift
    b=disp_current_events(event,bot,0,shift)
    str=extend_message(str,b,event,2) unless chain.length>0
    b=disp_current_paths(event,bot,0,shift)
    str=extend_message(str,b,event,2) unless chain.length>0
    if chain.length>0
      b=$banners.reject{|q| !q.startsTomorrow?}
      str=extend_message(str,"__**Pancartas a partir de mañana**__\n#{b.map{|q| q.name}.join("\n")}",event,2) if b.length>0
      b=$events.reject{|q| !q.startsTomorrow?}
      str=extend_message(str,"__**Eventos que comienzan mañana**__\n#{b.map{|q| q.fullName}.join("\n")}",event,2) if b.length>0
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

def next_eventos(bot,event,args=[])
  idx=-1
  for i in 0...args.length
    if idx<0
      idx=1 if ['trainingtower','training_tower','tower','color','shard','crystal','torredepractica','torre_de_practica','torre','practica','lasca','gema'].include?(args[i].downcase)
      
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
    event.respond "No mostraré todo a la vez.  Utilice este comando en mensajes privados o limite su búsqueda utilizando uno de los siguientes términos:\nTorre, Torre_de_Práctica, Práctica, Color, Lasca, Gema\nFree, 1\\*, 2\\*, F2P, FreeHero\nSpecial, Special_Training\nGHB\nGHB2\nRival, Domain(s), RD, Rival_Domain(s)\nBlessed, Garden(s), Blessing, Blessed_Garden(s)\nTactics_Drills, Tactic(s), Drill(s)\nBanner(s), Summon(ing)(s)\nEvent(s)\nLegendary/Legendaries, Legend(s)\nArena, ArenaBonus, Arena_Bonus\nTempest, TempestBonus, Tempest_Bonus\nAether, AetherBonus, Aether_Bonus\nBonus\nBook1, Book1Revival, Book2, Book2Revival\nDivine, Path, Ephemura"
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
    colors=['Verde <:Shard_Green:443733397190344714><:Crystal_Verdant:445510676845166592><:Badge_Verdant:445510676056899594><:Great_Badge_Verdant:443704780943261707>',
            'Gris <:Shard_Colorless:443733396921909248><:Crystal_Transparent:445510676295843870><:Badge_Transparent:445510675976945664><:Great_Badge_Transparent:443704781597573120>',
            'Oro <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Aleatorio <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Oro <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Aleatorio <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Oro <:Shard_Gold:443733396913520640><:Crystal_Gold:445510676346306560> / Aleatorio <:Badge_Random:445510676677525504><:Great_Badge_Random:445510674777636876>',
            'Rojo <:Shard_Red:443733396842348545><:Crystal_Scarlet:445510676350500897><:Badge_Scarlet:445510676060962816><:Great_Badge_Scarlet:443704781001850910>',
            'Azul <:Shard_Blue:443733396741554181><:Crystal_Azure:445510676434124800><:Badge_Azure:445510675352125441><:Great_Badge_Azure:443704780783616016>']
    colors=colors.rotate(date%colors.length)
    msg2='__**Colores de Torre de Práctica**__'
    for i in 0...colors.length
      if i==0
        msg2="#{msg2}\n#{colors[i]} - Hoy dia"
      elsif colors[i]!=colors[i-1]
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{colors[i]} - #{"en #{i} días" if i>1}#{"Mañana" if i==1} - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
      end
    end
    unless colors[0]==colors[colors.length-1]
      t2=t+24*60*60*colors.length
      msg2="#{msg2}\n#{colors[0]} - en #{colors.length} días - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
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
    msg2='__**Batallas Diarias**__'
    for i in 0...dhb.length
      if i==0
        msg2="#{msg2}\n#{dhb[i]} - Hoy dia"
      else
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{dhb[i]} - #{"en #{i} días" if i>1}#{"Mañana" if i==1} - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
      end
    end
    t2=t+24*60*60*dhb.length
    msg2="#{msg2}\n#{dhb[0]} - en #{dhb.length} días - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,3].include?(idx)
    spec=['Magia','Práctica general','Adyacentes','A distancia','Arcos']
    spec=spec.rotate(date%spec.length)
    msg2="__**Mapas de Práctica Especial**__"
    for i in 0...spec.length
      if i==0
        msg2="#{msg2}\n#{spec[i]} - Hoy dia"
      else
        t2=t+24*60*60*i
        msg2="#{msg2}\n#{spec[i]} - #{"en #{i} días" if i>1}#{"Mañana" if i==1} - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
      end
    end
    t2=t+24*60*60*spec.length
    msg2="#{msg2}\n#{spec[0]} - en #{spec.length} días - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
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
  msg2='__**Renacimiento de Batalla Mítica**__'
  msg3='__**Renacimiento 2 de Batalla Mítica**__'
  for i in 0...ghb.length
    if i==0
      msg2="#{msg2}\n#{ghb[i].split(' / ')[0]} - Hoy dia"
      msg3="#{msg3}\n#{ghb[i].split(' / ')[1]} - Hoy dia"
    else
      t2=t+24*60*60*i
      msg2="#{msg2}\n#{ghb[i].split(' / ')[0]} - #{"en #{i} días" if i>1}#{"Mañana" if i==1} - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
      msg3="#{msg3}\n#{ghb[i].split(' / ')[1]} - #{"en #{i} días" if i>1}#{"Mañana" if i==1} - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
    end
  end
  t2=t+24*60*60*ghb.length
  msg2="#{msg2}\n#{ghb[0].split(' / ')[0]} - en #{ghb.length} días - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
  msg3="#{msg3}\n#{ghb[0].split(' / ')[1]} - en #{ghb.length} días - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (#{$spanish_wday[t2.wday]})"
  msg=extend_message(msg,msg2,event,2) if [-1,4].include?(idx)
  msg=extend_message(msg,msg3,event,2) if [-1,5].include?(idx) || (idx==4 && safe_to_spam?(event))
  msg=extend_message(msg,"Vuelve a intentar el comando con \"GHB2\" si buscas el segundo set de Batallas Míticas.\nTambién puede probar \"Eventos\" si está buscando Batallas Míticas no cíclicas.",event,2) if [4].include?(idx) && !safe_to_spam?(event)
  msg=extend_message(msg,"También puede probar\"Eventos\" si está buscando Batallas Míticas no cíclicas.",event,2) if [4,5].include?(idx) && safe_to_spam?(event)
  if [-1,6].include?(idx)
    rd=['Caballería <:Icon_Move_Cavalry:443331186530451466>','Volador <:Icon_Move_Flier:443331186698354698>','Infantería <:Icon_Move_Infantry:443331187579289601>',
        'Blindadas <:Icon_Move_Armor:443331186316673025>']
    rd=rd.rotate(week_from(date,2)%6)
    rd=rd.rotate(-1) if t.wday==6
    msg2='__**Preferencia de movimiento de Dominios Rivales**__'
    for i in 0...rd.length
      if i==0
        t2=t-24*60*60*t.wday+6*24*60*60
        t2+=7*24*60*60 if t.wday==6
        msg2="#{msg2}\n#{rd[i]} - Esta semana hasta #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (sábado)"
      elsif rd[i]==rd[i-1]
      else
        t2=t-24*60*60*t.wday+7*24*60*60*i-24*60*60
        t2+=7*24*60*60 if t.wday==6
        msg2="#{msg2}\n#{rd[i]} - #{"en #{i} semanas" if i>1}#{"La próxima semana" if i==1} - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year}"
      end
    end
    unless rd[0]==rd[rd.length-1]
      t2=t-24*60*60*t.wday+7*24*60*60*rd.length-24*60*60
      t2+=7*24*60*60 if t.wday==6
      msg2="#{msg2}\n#{rd[0]} - en #{rd.length} semanas - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year}"
    end
    msg=extend_message(msg,msg2,event,2)
  end
  msg=extend_message(msg,'Jardines benditos se ha depreciado',event,2) if [-1,7].include?(idx)
  if [-1,11].include?(idx)
    drill=['Estudios de Habilidades','Gran maestro']
    drill=drill.rotate(week_from(date,0)%2)
    drill=drill.rotate(-1) if t.wday==4
    msg2='__**Siguiente Maniobras**__'
    for i in 0...drill.length
      if i==0
        t2=t-24*60*60*t.wday+4*24*60*60
        t2+=7*24*60*60 if t.wday==4
        msg2="#{msg2}\n#{drill[i]} - Esta semana hasta #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (jueves)"
      else
        t2=t-24*60*60*t.wday+7*24*60*60*i-72*60*60
        t2+=7*24*60*60 if t.wday==4
        msg2="#{msg2}\n#{drill[i]} - #{"en #{i} semanas" if i>1}#{"La próxima semana" if i==1} - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year}"
      end
    end
    t2=t-24*60*60*t.wday+7*24*60*60*drill.length-72*60*60
    t2+=7*24*60*60 if t.wday==4
    msg2="#{msg2}\n#{'__' if idx==-1}#{drill[0]} - #{drill.length} semanas a partir de ahora - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year}#{'__' if idx==-1}#{"\n" if idx==11}"
    drill=['300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>',
           '300<:Hero_Feather:471002465542602753>','300<:Hero_Feather:471002465542602753>','1<:Orb_Rainbow:471001777622351872>','1<:Orb_Rainbow:471001777622351872>']
    drill=drill.rotate(week_from(date,0)%drill.length)
    drill=drill.rotate(-1) if t.wday==4
    msg2="#{msg2}\nLa recompensa de esta semana: #{drill[0]}"
    drill[0]=''
    if drill[1]=='1<:Orb_Rainbow:471001777622351872>'
      t2=t-24*60*60*t.wday+4*24*60*60
      t2+=7*24*60*60 if t.wday==4
      msg2="#{msg2}\nPróxima recompensa de #{'<:Orb_Rainbow:471001777622351872>' if idx==-1}orbe: La próxima semana - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (Thursday)"
    else
      m=drill.find_index{|q| q=='1<:Orb_Rainbow:471001777622351872>'}
      t2=t-24*60*60*t.wday+4*24*60*60+7*24*60*60*m
      t2+=7*24*60*60 if t.wday==4
      msg2="#{msg2}\nPróxima recompensa de #{'<:Orb_Rainbow:471001777622351872>' if idx==-1}orbe: #{m} semanas a partir de ahora - #{t2.day} #{$spanish_months[0][t2.month]}#{" #{t2.year}" unless t2.year==t.year} (Thursday)"
    end
    msg=extend_message(msg,msg2,event,2)
  end
  if [-1,8].include?(idx)
    str2=disp_current_banners(event,bot,'',true,1)
    msg=extend_message(msg,str2,event,2)
    str2=disp_current_banners(event,bot,'',true,2).gsub("__**Pancartas Actual**__\n\n",'')
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
      str2="#{"__**Apariciones de Héroes Legendarios y Míticos**__\n" if i==0}*#{m[i][0]}*"
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
      msg=extend_message(msg,"__**Personajes del Renacimiento**__",event,2)
      strpost=false
      tx=t-t.wday*24*60*60
      for i in 0...mmzz.length
        str2="*#{mmzz[i][0]}*#{u[u.find_index{|q| q.name==mmzz[i][0]}].emotes(bot) unless u.find_index{|q| q.name==mmzz[i][0]}.nil?} -"
        if mmzz[i][1]==0
          str2="#{str2} **Esta semana**#{' - Próximo disponible' unless mmzz[i][2].nil? || mmzz[i][2]<=0}"
          if mmzz[i][2].nil? || mmzz[i][2]<=0
          else
            t_d=tx+mmzz[i][2]*7*24*60*60
            if mmzz[i][2]==1
              str2="#{str2} la próxima semana (#{disp_date(t_d,1).gsub(" #{t.year}",'')})"
            else
              str2="#{str2} en #{mmzz[i][2]} semanas (#{disp_date(t_d,1).gsub(" #{t.year}",'')})"
            end
          end
        else
          t_d=tx+mmzz[i][1]*7*24*60*60
          if mmzz[i][1]==1
            str2="#{str2} La próxima semana (#{disp_date(t_d,1).gsub(" #{t.year}",'')})"
          else
            str2="#{str2} en #{mmzz[i][1]} semanas (#{disp_date(t_d,1).gsub(" #{t.year}",'')})"
          end
        end
        msg=extend_message(msg,str2,event)
      end
    else
      str2=matz[0].split(', ').map{|q| "#{q}#{u[u.find_index{|q2| q2.name==q}].emotes(bot) unless u.find_index{|q2| q2.name==1}.nil?}"}.join(', ')
      str3=matz[1].split(', ').map{|q| "#{q}#{u[u.find_index{|q2| q2.name==q}].emotes(bot) unless u.find_index{|q2| q2.name==1}.nil?}"}.join(', ')
      msg=extend_message(msg,"__**Personajes del Renacimiento**__\n*Esta semana:* #{str2}\n*La próxima semana:* #{str3}",event,2)
    end
  end
  event.respond msg unless [10,12,13,14,16].include?(idx)
  return nil
end



def snagstats_spanish(event,bot,f=nil,f2=nil)
  nicknames_load()
  data_load(['units','skills','groups','tags','games'])
  metadata_load()
  f='' if f.nil?
  f2='' if f2.nil?
  evrythg=false
  evrythg=true if event.message.text.downcase.include?('all')
  evrythg=true if event.message.text.downcase.include?('todos')
  evrythg=true if safe_to_spam?(event)
  if ['alts','alt','alternate','alternates','alternative','alternatives'].include?(f.downcase)
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
          n=''
          if untz[i].duo[i2][1].include?('[')
            m=untz[i].duo[i2][1].gsub(']','').split('[')
            k=untz.reject{|q| q.alts.map{|q2| q2.gsub('*','')}!=m || q.name==untz[i].name || !(q.name==q.alts[0] || q.alts[0].include?('*'))}
          else
            m="#{untz[i].duo[i2][1]}"
            k=untz.reject{|q| q.alts[0].gsub('*','')!=m || q.name==untz[i].name || !(q.name==q.alts[0] || q.alts[0].include?('*'))}
          end
          n="x" if k.length<=0
          k=untz.reject{|q| q.availability[0].include?('-') || q.alts[0].gsub('*','')!=m || q.name==untz[i].name || !(q.name==q.alts[0] || q.alts[0].include?('*'))}
          k=untz.reject{|q| q.availability[0].include?('-') || q.alts.map{|q2| q2.gsub('*','')}!=m || q.name==untz[i].name || !(q.name==q.alts[0] || q.alts[0].include?('*'))} if m.is_a?(Array)
          n="#{n}y" if k.length<=0
          m="#{m[0]}[#{m[1,m.length-1].join('][')}]" if m.is_a?(Array)
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
    str="Hay #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} personajes en su forma predeterminada, junto con #{l2.length}#{" (#{a2.length})" unless l2.length==a2.length} conjuntos de facetas de personajes *(como Tiki o personajes con varios géneros)*"
    a3=all_units.reject{|q| !q[2].include?('sensible')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('sensible')}.uniq
    str="#{str}\nHay #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} formas alternativas sensatas de personajes *[Marth(Masked), Azura Oscuridad, etc.]*"
    a3=all_units.reject{|q| !q[2].include?('seasonal')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('seasonal')}.uniq
    str="#{str}\nHay #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} formas alternativas de personajes estacionales"
    a3=all_units.reject{|q| !q[2].include?('community-voted')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('community-voted')}.uniq
    str="#{str}\nHay #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} formas alternativas de personajes votados por la comunidad"
    a3=all_units.reject{|q| !q[2].include?('Legendary/Mythic')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('Legendary/Mythic')}.uniq
    str="#{str}\nHay #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} formas alternativas de personajes Legendarios o Míticos"
    a3=all_units.reject{|q| !q[2].include?('Fallen')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('Fallen')}.uniq
    str="#{str}\nHay #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} formas alternativas de personajes Fallen"
    a3=all_units.reject{|q| !q[2].include?('out-of-left-field')}.uniq
    l3=legal_units.reject{|q| !q[2].include?('out-of-left-field')}.uniq
    str="#{str}\nHay #{longFormattedNumber(l3.length)}#{" (#{longFormattedNumber(a3.length)})" unless l3.length==a3.length} formas alternativas aleatorias de personajes *(Eirika, Reinhardt, Hinoka, etc.)*"
    k=[]; k2=[]; k3=[]
    for i in 0...all_units.length
      x="#{'~~' unless all_units[i][4].nil? || all_units[i][4][0].length.zero?}"
      k.push("#{x}#{all_units[i][1][0]}#{x}") if !all_units[i][2].include?('faceted') && all_units[i][3].include?('x')
      k2.push("#{x}#{all_units[i][1][0]}#{x}") if !all_units[i][2].include?('faceted') && all_units[i][3].include?('y')
      k3.push("#{x}#{all_units[i][1][0]}#{x}") if !all_units[i][2].include?('faceted') && all_units[i][2].include?('Duo/Harmonic backpack') && all_units[i][3].include?('x')
    end
    k3.uniq!
    k=k.reject{|q| k3.include?(q) || q=='Unknown'}.uniq
    k2=k2.reject{|q| [k,k3].flatten.include?(q) || q=='Unknown'}.uniq
    u=untz.find_index{|q| q.name=='Veronica'}
    unless u.nil?
      u=untz[u]
      k2.push('Veronica') if u.availability[0].include?('-')
    end
    x=2
    if k.length>0 || k2.length>0 || k3.length>0
      str=extend_message(str,'',event)
      str=extend_message(str,"Los siguientes caracteres tienen formas alternativas pero no versiones predeterminadas en FEH: #{list_lift(k.sort.map{|q| "*#{q}*"},"y")}.",event) if k.length>0
      str=extend_message(str,"Los siguientes personajes tienen alts jugables pero no versiones predeterminadas jugables en FEH: #{list_lift(k2.sort.map{|q| "*#{q}*"},"y")}.",event) if k2.length>0
      str=extend_message(str,"Los siguientes personajes se utilizan como mochilas Dúo/al Son, pero no tienen una versión base en FEH: #{list_lift(k3.reject{|q| q=='Unknown'}.sort.map{|q| "*#{q}*"},"y")}.",event) if k3.length>0
      x=1
    end
    k=legal_units.map{|q| [q[1][0],0]}.uniq
    for i in 0...k.length
      k[i][1]=legal_units.reject{|q| q[1][0]!=k[i][0]}.uniq.length
    end
    k=k.sort{|b,a| supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)}
    k=k.reject{|q| q[1]!=k[0][1]}
    str=extend_message(str,"#{list_lift(k.map{|q| "*#{q[0]}*"},'y')} es el personaje con más versiones alternativas, con #{k[0][1]} alternativas (incluido el predeterminado).",event,x) if k.length==1
    str=extend_message(str,"#{list_lift(k.map{|q| "*#{q[0]}*"},'y')} son los personajes con más versiones alternativas, con #{k[0][1]} alternativas (incluido el predeterminado) cada uno.",event,x) unless k.length==1
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
    str=extend_message(str,"#{list_lift(k.map{|q| "*#{q[0]}*"},'y')} es el personaje que se enfrenta a la mayoría de las versiones alternativas, con #{k[0][1]} alternativas (incluido el predeterminado).",event) if k.length==1
    str=extend_message(str,"#{list_lift(k.map{|q| "*#{q[0]}*"},'y')} son las facetas de los personajes con más versiones alternativas, con #{k[0][1]} alternativas (incluida la predeterminada) cada una.",event) unless k.length==1
    event.respond str
    return nil
  elsif ['hero','heroes','heros','units','characters','unit','character','charas','chara','chars','char','personaje','personajes','heroe','caracter','caractera','unidad','unidades'].include?(f.downcase)
    event.channel.send_temporary_message('Calculating data, please wait...',1) rescue nil
    all_units=$units.reject{|q| !q.isPostable?(event)}
    all_units=$units.map{|q| q} if event.server.nil? && event.user.id==167657750971547648
    legal_units=$units.reject{|q| !q.fake.nil?}
    str="**Hay #{longFormattedNumber(legal_units.length)}#{" (#{longFormattedNumber(all_units.length)})" unless legal_units.length==all_units.length} personajes, que incluyen:**"
    unless f2.nil? || f2.length<=0
      k=find_in_units(bot,event,[f2],13,false,true)
      all_units=all_units.reject{|q| !k[1].map{|q2| q2.name}.include?(q.name)}.uniq
      legal_units=legal_units.reject{|q| !k[1].map{|q2| q2.name}.include?(q.name)}.uniq
      str="#{k[0].join("\n")}\n**Con estos filtros, hay #{longFormattedNumber(legal_units.length)}#{" (#{longFormattedNumber(all_units.length)})" unless legal_units.length==all_units.length} personajes, que incluyen:**"
    end
    str2=''
    l=legal_units.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=all_units.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} invocable#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| !q.availability[0].include?('g')}
    a=all_units.reject{|q| !q.availability[0].include?('g')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} de Batalla Mítica" unless m=='0'
    l=legal_units.reject{|q| !q.availability[0].include?('t')}
    a=all_units.reject{|q| !q.availability[0].include?('t')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} de la Tormenta" unless m=='0'
    l=legal_units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?}
    a=all_units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} de temporada" unless m=='0'
    l=legal_units.reject{|q| q.legendary.nil?}
    a=all_units.reject{|q| q.legendary.nil?}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} legendario#{'s' unless m=='1'} o mítico#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.duo.nil?}
    a=all_units.reject{|q| q.duo.nil?}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} de Dúo o al Son" unless m=='0'
    l=legal_units.reject{|q| !q.availability[0].include?('-')}
    a=all_units.reject{|q| !q.availability[0].include?('-')}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} inalcanzable#{'s' unless m=='1'}" unless m=='0'
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
    str2="<:Red_Unknown:443172811486396417> #{m} personaje#{'s' unless m=='1'} rojo#{'s' unless m=='1'},   <:Orb_Red:455053002256941056> con #{m2} en el grupo de invocación principal" unless m=='0'
    l=legal_units.reject{|q| q.weapon_color != 'Blue'}
    a=all_units.reject{|q| q.weapon_color != 'Blue'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    l=l.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=a.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Blue_Unknown:467112473980305418> #{m} personaje#{'s' unless m=='1'} azul#{'es' unless m=='1'},   <:Orb_Blue:455053001971859477> con #{m2} en el grupo de invocación principal" unless m=='0'
    l=legal_units.reject{|q| q.weapon_color != 'Green'}
    a=all_units.reject{|q| q.weapon_color != 'Green'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    l=l.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=a.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Green_Unknown:467122926785921044> #{m} personaje#{'s' unless m=='1'} verde#{'s' unless m=='1'},   <:Orb_Green:455053002311467048> con #{m2} en el grupo de invocación principal" unless m=='0'
    l=legal_units.reject{|q| q.weapon_color != 'Colorless'}
    a=all_units.reject{|q| q.weapon_color != 'Colorless'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    l=l.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=a.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Colorless_Unknown:443692132738531328> #{m} personaje#{'s' unless m=='1'} gris#{'es' unless m=='1'},   <:Orb_Colorless:455053002152083457> con #{m2} en el grupo de invocación principal" unless m=='0'
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
      str2="#{str2}\n<:Gold_Blade:774013609184460860> #{m} usuario#{'s' unless m=='1'} de filo:   <:Red_Blade:443172811830198282> #{m2} espada#{'s' unless m2=='1'}, <:Blue_Blade:467112472768151562> #{m3} lanza#{'s' unless m3=='1'}, <:Green_Blade:467122927230386207> #{m4} hacha#{'s' unless m4=='1'}"
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
      str2="#{str2}\n<:Gold_Tome:774013610736484353> #{m} usuario#{'s' unless m=='1'} de tomo:   <:Red_Tome:443172811826003968> #{m2} rojos, <:Blue_Tome:467112472394858508> #{m3} azules, <:Green_Tome:467122927666593822> #{m4} verdes, <:Colorless_Tome:443692133317345290> #{m5} grises"
    end
    l=legal_units.reject{|q| q.weapon_type != 'Dragon'}
    a=all_units.reject{|q| q.weapon_type != 'Dragon'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Gold_Dragon:774013610908581948> #{m} drag\u00F3n#{'es' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.weapon_type != 'Bow'}
    a=all_units.reject{|q| q.weapon_type != 'Bow'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Gold_Bow:774013609389981726> #{m} usuario#{'s' unless m=='1'} de arco" unless m=='0'
    l=legal_units.reject{|q| q.weapon_type != 'Dagger'}
    a=all_units.reject{|q| q.weapon_type != 'Dagger'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Gold_Dagger:774013610862968833> #{m} usuario#{'s' unless m=='1'} de daga" unless m=='0'
    l=legal_units.reject{|q| q.weapon_type != 'Staff'}
    a=all_units.reject{|q| q.weapon_type != 'Staff'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Gold_Staff:774013610988797953> #{m} usuario#{'s' unless m=='1'} de bastón" unless m=='0'
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
      str2="#{str2}\n<:Gold_Beast:774013608191459329> #{m} bestia#{'s' unless m=='1'}:   <:Icon_Move_Infantry:443331187579289601> #{m2} infanterías, <:Icon_Move_Cavalry:443331186530451466> #{m3} caballerías, <:Icon_Move_Flier:443331186698354698> #{m4} voladores, <:Icon_Move_Armor:443331186316673025> #{m5} blindados"
    end
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    str2=''
    l=legal_units.reject{|q| q.movement != 'Infantry'}
    a=all_units.reject{|q| q.movement != 'Infantry'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Icon_Move_Infantry:443331187579289601> #{m} infantería#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.movement != 'Cavalry'}
    a=all_units.reject{|q| q.movement != 'Cavalry'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Icon_Move_Cavalry:443331186530451466> #{m} caballería#{'s' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.movement != 'Flier'}
    a=all_units.reject{|q| q.movement != 'Flier'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Icon_Move_Flier:443331186698354698> #{m} volador#{'es' unless m=='1'}" unless m=='0'
    l=legal_units.reject{|q| q.movement != 'Armor'}
    a=all_units.reject{|q| q.movement != 'Armor'}
    m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
    str2="#{str2}\n<:Icon_Move_Armor:443331186316673025> #{m} blindado#{'s' unless m=='1'}" unless m=='0'
    str2=str2[1,str2.length-1] if str2[0,1]=="\n"
    str2=str2[2,str2.length-2] if str2[0,2]=="\n"
    str=extend_message(str,str2,event,2)
    if evrythg
      str2=''
      x=['FE1','FE2','FE3','FE4','FE5','FE6','FE7','FE8','FE9','FE10','FE11','FE12','FE13','FE14','FEW','TMS','FE15','FE16']
      for i in 0...x.length
        l=legal_units.reject{|q| !q.from_game(x[i])}
        a=all_units.reject{|q| !q.from_game(x[i])}
        m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
        l=legal_units.reject{|q| !q.from_game(x[i],true)}
        a=all_units.reject{|q| !q.from_game(x[i],true)}
        m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"; m2='todos' if m2==m; m2='ninguno' if m2=='0'
        str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} de *#{x[i]}*,    #{m2} de los cuales están acreditados" unless m=='0'
      end
      l=legal_units.reject{|q| !q.from_game('FEH')}
      a=all_units.reject{|q| !q.from_game('FEH')}
      m="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"
      l=legal_units.reject{|q| !q.from_game('FEH',true)}
      a=all_units.reject{|q| !q.from_game('FEH',true)}
      m2="#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length}"; m2='todos' if m2==m; m2='ninguno' if m2=='0'
      str2="#{str2}\n#{m} personaje#{'s' unless m=='1'} de *FEH* itself,    #{m2} de los cuales están acreditados" unless m=='0'
      str2=str2[1,str2.length-1] if str2[0,1]=="\n"
      str2=str2[2,str2.length-2] if str2[0,2]=="\n"
      str=extend_message(str,str2,event,2)
    end
    event.respond str
    return nil
  elsif ['skill','skills','weapon','weapons','assist','assists','special','specials','passive','passives','habilidades','habilidad','arma','armas','pasivas','pasiva','especial','especiales','asistencias','asistencia'].include?(f.downcase)
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
        z[-1].name="#{z.map{|q| q.name.split(' ')[0]}.join('/')} #{z[-1].name.split(' ')[1,z[-1].name.split{' '}.length-1].join(' ')}"
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
  elsif ['structure','structures','structs','struct','estructuras','estructura'].include?(f.downcase)
    m=$structures.reject{|q| q.level=='example'}.map{|q| "#{q.fullName} / #{q.type.join('/') unless q.type.include?('Offensive') || q.type.include?('Defensive')}"}.uniq
    str="**Hay #{longFormattedNumber(m.length)} niveles de estructura, que incluyen:**"
    m=$structures.reject{|q| q.level=='example'}.map{|q| [q.name,q.level,q.type]}.uniq
    str="#{str}\n<:Offensive_Structure:510774545997758464> #{longFormattedNumber(m.reject{|q| !q[2].include?('Offensive')}.length)} niveles de estructuras Ofensivas"
    str="#{str}\n<:Defensive_Structure:510774545108566016> #{longFormattedNumber(m.reject{|q| !q[2].include?('Defensive')}.length)} niveles de estructuras Defensivas"
    str="#{str}\n<:Trap_Structure:510774545179869194> #{longFormattedNumber(m.reject{|q| !q[2].include?('Trap')}.length)} niveles de Trampas"
    str="#{str}\n<:Resource_Structure:510774545154572298> #{longFormattedNumber(m.reject{|q| !q[2].include?('Resources')}.length)} niveles de estructuras Recursos"
    str="#{str}\n<:Mjolnir_Structure:691254233588301866> #{longFormattedNumber(m.reject{|q| !q[2].include?('Mjolnir')}.length)} niveles de estructuras de Embate de Mjolnir"
    m=$structures.reject{|q| q.level=='example'}.map{|q| [q.name,0,q.type]}.uniq
    str2="**Hay #{longFormattedNumber(m.length)} estructuras, que incluyen:**"
    str2="#{str2}\n<:Offensive_Structure:510774545997758464> #{longFormattedNumber(m.reject{|q| !q[2].include?('Offensive')}.length)} estructuras Ofensivas"
    str2="#{str2}\n<:Defensive_Structure:510774545108566016> #{longFormattedNumber(m.reject{|q| !q[2].include?('Defensive')}.length)} estructuras Defensivas"
    str2="#{str2}\n<:Trap_Structure:510774545179869194> #{longFormattedNumber(m.reject{|q| !q[2].include?('Trap')}.length)} Trampas"
    str2="#{str2}\n<:Resource_Structure:510774545154572298> #{longFormattedNumber(m.reject{|q| !q[2].include?('Resources')}.length)} estructuras Recursos"
    str2="#{str2}\n<:Mjolnir_Structure:691254233588301866> #{longFormattedNumber(m.reject{|q| !q[2].include?('Mjolnir')}.length)} estructuras de Embate de Mjolnir"
    str2="#{str2}\n<:Ornamental_Structure:510774545150640128> #{longFormattedNumber(m.reject{|q| !q[2].include?('Ornament')}.length)} estrucutras Decoradas"
    str2="#{str2}\n<:Resort_Structure:565064414521196561> #{longFormattedNumber(m.reject{|q| !q[2].include?('Resort')}.length)} estrucutras exclusivas para Lugar de verano"
    str=extend_message(str,str2,event,2)
    event.respond str
    return nil
  elsif ['item','items','articulos','articulo'].include?(f.downcase)
    str2="**Hay #{longFormattedNumber($itemus.length)} artículos, que incluyen:**"
    m=$itemus.reject{|q| q.type !='Main'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos principales"
    m=$itemus.reject{|q| q.type !='Implied'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos implícitos"
    m=$itemus.reject{|q| q.type !='Blessing'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} bendiciónes"
    m=$itemus.reject{|q| q.type !='Growth'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos para el crecimiento del personaje"
    m=$itemus.reject{|q| q.type !='Assault'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos de Asalto del Coliseo / Batallas Fragorosas"
    m=$itemus.reject{|q| q.type !='Event'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos de eventos"
    str2="#{str2}\n~~3 tronos que se cuentan como estructuras en mis datos aunque FEH los cuenta como estructuras y artículos~~"
    event.respond str2
    return nil
  elsif ['accessories','accessory','accessorys','accessorie','accesorio','accesorios'].include?(f.downcase)
    str2="**Hay #{longFormattedNumber($accessories.length)} accesorios, que incluyen:**"
    m=$accessories.reject{|q| q.type !='Hair'}
    str2="#{str2}\n\n<:Accessory_Type_Hair:531733124741201940> #{longFormattedNumber(m.length)} horquillas y otros accesorios para el cabello"
    m=$accessories.reject{|q| q.type !='Hat'}
    str2="#{str2}\n<:Accessory_Type_Hat:531733125227741194> #{longFormattedNumber(m.length)} sombreros y otros accesorios para la parte superior de la cabeza"
    m=$accessories.reject{|q| q.type !='Mask'}
    str2="#{str2}\n<:Accessory_Type_Mask:531733125064163329> #{longFormattedNumber(m.length)} mascarillas y otros accesorios faciales"
    m=$accessories.reject{|q| q.type !='Tiara'}
    str2="#{str2}\n<:Accessory_Type_Tiara:531733130734731284> #{longFormattedNumber(m.length)} tiaras y otros accesorios para la nuca"
    m=$accessories.reject{|q| !q.description.include?('Proof of victory over')}
    str2="#{str2}\n\n#{longFormattedNumber(m.length)} Accesorios Dorados"
    m=$accessories.reject{|q| !q.name.include?('8-Bit ')}
    str2="#{str2}\n#{longFormattedNumber(m.length)} Accesorios 8-Bit"
    m=$accessories.reject{|q| !q.name.include?(' EX')}
    str2="#{str2}\n#{longFormattedNumber(m.length*2)} Accesorios de Creando Lazos (#{longFormattedNumber(m.length)} pares)"
    m=$accessories.reject{|q| q.obtain.nil? || !q.obtain.include?('Illusory Dungeon')}
    str2="#{str2}\n#{longFormattedNumber(m.length*2)} Accesorios de Batalla de Toques"
    m=$accessories.reject{|q| q.name[0,4]!='(S) '}
    str2="#{str2}\n\n<:Summon_Gun:467557566050861074> #{longFormattedNumber(m.length)} Accesorios exclusivos de Invocador"
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
    str="**Hay #{longFormattedNumber(glbl.length)} alias globales de un solo personaje.**"
    all_units=all_units.sort{|b,a| supersort(a,b,2).zero? ? supersort(a,b,1) : supersort(a,b,2)}
    k=all_units.reject{|q| q[2]!=all_units[0][2]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2.name==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2.name==q[0]}.nil?}*"}
    str="#{str}\nLos personajes con la mayor cantidad de alias globales son #{list_lift(k,"y")}, con #{all_units[0][2]} alias cada uno." unless k.length==1
    str="#{str}\nEl personaje con más alias globales es #{list_lift(k,"y")}, con #{all_units[0][2]} alias." if k.length==1
    str="#{str}\n\n**Hay #{longFormattedNumber(srv_spec.length)} alias [de un solo] personaje específicos del servidor.**"
    if event.server.nil?
      str="#{str}\nEn mensajes privados, no puedo dar más información."
    else
      str="#{str}\nEste servidor representa #{$aliases.reject{|q| q[0]!='Unit' || q[3].nil? || !q[3].include?(event.server.id)}.length} de esos."
    end
    all_units=all_units.sort{|b,a| supersort(a,b,3).zero? ? supersort(a,b,0) : supersort(a,b,3)}
    k=all_units.reject{|q| q[3]!=all_units[0][3]}.map{|q| "*#{'~~' if legal_units.find_index{|q2| q2.name==q[0]}.nil?}#{q[0]}#{'~~' if legal_units.find_index{|q2| q2.name==q[0]}.nil?}*"}
    str="#{str}\nEl personaje con la mayoría de los alias específicos del servidor es #{list_lift(k,"y")}, con #{all_units[0][2]} alias específicos del servidor." if k.length==1
    str="#{str}\nLos personajes con la mayoría de los alias específicos del servidor son #{list_lift(k,"y")}, con #{all_units[0][2]} alias específicos del servidor cada uno." unless k.length==1
    for i in 0...srv_spec.length
      srv_spec[i][2]=srv_spec[i][2].length
    end
    srv_spec=srv_spec.sort{|b,a| supersort(a,b,2).zero? ? (supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)) : supersort(a,b,2)}
    k=srv_spec.reject{|q| q[2]!=srv_spec[0][2]}.map{|q| "*#{q[0]} = #{all_units[all_units.find_index{|q2| q2[1]==q[1]}][0]}*"}
    if evrythg
      str="#{str}\nEl alias específico del servidor más acordado es #{list_lift(k,"y")}.  #{srv_spec[0][2]} servidores están de acuerdo." if k.length==1
      str="#{str}\nLos alias específicos del servidor más acordados son #{list_lift(k,"y")}.  #{srv_spec[0][2]} servidores están de acuerdo en ellos." unless k.length==1
    end
    k=srv_spec.map{|q| q[2]}.inject(0){|sum,x| sum + x }
    str="#{str}\nContando cada combinación de alias y servidor como un alias único, hay #{longFormattedNumber(k)} alias específicos del servidor."
    multi=$aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}
    str="#{str}\n\n**Hay #{longFormattedNumber(multi.length)} alias [globales] de múltipersonajes, que cubren #{multi.map{|q| q[2]}.uniq.length} grupos de personajes.**"
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
    str="#{str}\n#{list_lift(k,"y")} es el grupo de personajes con más alias de multipersonaje, con #{m[0][1]} alias de multipersonajes." if k.length==1
    str="#{str}\n#{list_lift(k,"y")} son los grupos de personajes con más alias de multipersonaje, con #{m[0][1]} alias de multipersonajes cada uno." unless k.length==1
    m=m.sort{|a,b| supersort(a,b,1).zero? ? supersort(b,a,0) : supersort(a,b,1)}
    k=m.reject{|q| q[1]!=m[0][1]}.map{|q| "*#{q[0]}*"}
    if evrythg
      str="#{str}\n#{list_lift(k,"y")} es el grupo de personajes con menos alias de multipersonaje (entre los que los tienen), con #{m[0][1]} alias de multipersonajes." if k.length==1
      str="#{str}\n#{list_lift(k,"y")} son los grupos de personajes con menos alias de multipersonaje (entre los que los tienen), con #{m[0][1]} alias de multipersonajes cada uno." unless k.length==1
    end
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
    str2="**Hay #{longFormattedNumber(glbl.length)} alias globales de habilidad única.**"
    all_units=all_units.sort{|b,a| supersort(a,b,2).zero? ? supersort(a,b,1) : supersort(a,b,2)}
    k=all_units.reject{|q| q[2]!=all_units[0][2]}.map{|q| "*#{q[1]}*"}
    str2="#{str2}\nLa habilidad con más alias globales es #{list_lift(k,"y")}, con #{all_units[0][2]} alias globales." if k.length==1
    str2="#{str2}\nLas habilidades con más alias globales son #{list_lift(k,"y")}, con #{all_units[0][2]} alias globales cada uno." unless k.length==1
    str2="#{str2}\n\n**Hay #{longFormattedNumber(srv_spec.length)} alias [únicas] de habilidades específicas del servidor.**"
    if event.server.nil?
      str2="#{str2}\nEn mensajes privados, no puedo dar más información."
    else
      str2="#{str2}\nEste servidor representa #{$aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(event.server.id)}.length} de esos."
    end
    all_units=all_units.sort{|b,a| supersort(a,b,3).zero? ? supersort(a,b,1) : supersort(a,b,3)}
    k=all_units.reject{|q| q[3]!=all_units[0][3]}.map{|q| "*#{'~~' if legal_skills.find_index{|q2| q2.name==q[0]}.nil?}#{q[1]}#{'~~' if legal_skills.find_index{|q2| q2.name==q[0]}.nil?}*"}
    str2="#{str2}\nEl habilidad con la mayoría de los alias específicos del servidor es #{list_lift(k,"y")}, con #{all_units[0][2]} alias específicos del servidor." if k.length==1
    str2="#{str2}\nLos habilidades con la mayoría de los alias específicos del servidor son #{list_lift(k,"y")}, con #{all_units[0][2]} alias específicos del servidor cada uno." unless k.length<=1
    for i in 0...srv_spec.length
      srv_spec[i][2]=srv_spec[i][2].length
    end
    srv_spec=srv_spec.sort{|b,a| supersort(a,b,2).zero? ? (supersort(a,b,1).zero? ? supersort(a,b,0) : supersort(a,b,1)) : supersort(a,b,2)}
    k=srv_spec.reject{|q| q[2]!=srv_spec[0][2]}.map{|q| "*#{q[0]} = #{q[1]}*"}
    k=srv_spec.map{|q| q[2]}.inject(0){|sum,x| sum + x }
    str2="#{str2}\nContando cada combinación de alias y servidor como un alias único, hay #{longFormattedNumber(k)} alias específicos del servidor."
    str2="#{str2}\n\n**Hay 3 alias [globales] de multihabilidad.**"
    str=extend_message(str,str2,event,3)
    glbl=$aliases.reject{|q| q[0]!='Structure' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=$aliases.reject{|q| q[0]!='Structure' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**Hay #{longFormattedNumber(glbl.length)} alias globales para estructuras.**\n**Hay #{longFormattedNumber(srv_spec.length)} alias específicos del servidor para estructuras.**"
    if event.server.nil?
      str2="#{str2} - En mensajes privados, no puedo dar más información."
    else
      str2="#{str2} - Este servidor representa #{$aliases.reject{|q| q[0]!='Structure' || q[3].nil? || !q[3].include?(event.server.id)}.length} de esos."
    end
    str=extend_message(str,str2,event,3)
    glbl=$aliases.reject{|q| q[0]!='Accessory' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=$aliases.reject{|q| q[0]!='Accessory' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**Hay #{longFormattedNumber(glbl.length)} alias globales para accesorios.**\n**Hay #{longFormattedNumber(srv_spec.length)} alias específicos del servidor para accesorios.**"
    if event.server.nil?
      str2="#{str2} - En mensajes privados, no puedo dar más información."
    else
      str2="#{str2} - Este servidor representa #{$aliases.reject{|q| q[0]!='Accessory' || q[3].nil? || !q[3].include?(event.server.id)}.length} de esos."
    end
    str=extend_message(str,str2,event,3)
    glbl=$aliases.reject{|q| q[0]!='Item' || !q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    srv_spec=$aliases.reject{|q| q[0]!='Item' || q[3].nil?}.map{|q| [q[1],q[2],q[3]]}
    str2="**Hay #{longFormattedNumber(glbl.length)} alias globales para los artículos.**\n**Hay #{longFormattedNumber(srv_spec.length)} alias específicos del servidor para los articulos.**"
    if event.server.nil?
      str2="#{str2} - En mensajes privados, no puedo dar más información."
    else
      str2="#{str2} - Este servidor representa #{$aliases.reject{|q| q[0]!='Item' || q[3].nil? || !q[3].include?(event.server.id)}.length} de esos."
    end
    str=extend_message(str,str2,event,3)
    event.respond str
    return nil
  elsif ['groups','group','groupings','grouping','grupo','grupos'].include?(f.downcase)
    (event.channel.send_temporary_message('Calculating data, please wait...',3) rescue nil) if safe_to_spam?(event)
    str="**Hay #{longFormattedNumber($groups.reject{|q| !q.fake.nil?}.length-1)} grupos globales.**"
    str=extend_message(str,"**Hay #{longFormattedNumber($groups.reject{|q| q.fake.nil?}.length)} grupos específicos del servidor.**",event,2)
    if event.server.nil?
      str=extend_message(str,"En mensajes privados, no puedo dar más información.",event)
    else
      str=extend_message(str,"Este servidor representa #{$groups.reject{|q| q.fake.nil? || !q.fake.include?(event.server.id)}.length} de esos.",event)
    end
    event.respond str
    return nil
  elsif ['code','lines','line','sloc','codigo','lineas'].include?(f.downcase)
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
    File.open("#{$location}devkit/Elispanol.rb").each_line do |line|
      l=line.gsub("\n",'')
      b[0].push(l)
      l=line.gsub("\n",'').gsub(' ','')
      b[2].push(l) unless l.length<=0
    end
    event << "**Tengo #{longFormattedNumber(File.foreach("#{$location}devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} líneas de código.**"
    event << "De esos, #{longFormattedNumber(b[1].length)} no están vacíos."
    event << "~~Cuando está completamente contraído, parece que tengo #{longFormattedNumber(b[3].reject{|q| q.length>0 && (q[0,2]=='  ' || q[0,3]=='end' || q[0,4]=='else')}.length)} líneas de código.~~"
    event << ''
    event << "**Confío en varias catálogos que, en total, tienen #{longFormattedNumber(File.foreach("#{$location}devkit/rot8er_functs.rb").inject(0) {|c, line| c+1}+File.foreach("#{$location}devkit/EliseClassFunctions.rb").inject(0) {|c, line| c+1}+File.foreach("#{$location}devkit/Elispanol.rb").inject(0) {|c, line| c+1})} líneas de código.**"
    event << "De esos, #{longFormattedNumber(b[2].length)} no están vacíos."
    event << ''
    event << "**Hay #{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command('}.length)} comandos, invocados con #{longFormattedNumber(all_commands().length)} frases diferentes.**"
    event << 'Esto incluye:'
    event << "#{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command(' || q.include?('from: 167657750971547648')}.length-b[0].reject{|q| q.gsub('  ','')!="event.respond 'You are not a mod.'" && q.gsub('  ','')!="str='You are not a mod.'"}.length)} comandos globales, invocados con #{longFormattedNumber(all_commands(false,0).length)} frases diferentes."
    event << "#{longFormattedNumber(b[0].reject{|q| q.gsub('  ','')!="event.respond 'You are not a mod.'" && q.gsub('  ','')!="str='You are not a mod.'"}.length)} comandos específicos del moderador, invocados con #{longFormattedNumber(all_commands(false,1).length)} frases diferentes."
    event << "#{longFormattedNumber(b[0].reject{|q| q[0,12]!='bot.command(' || !q.include?('from: 167657750971547648')}.length)} comandos específicos del desarrollador, invocados con #{longFormattedNumber(all_commands(false,2).length)} frases diferentes."
    event << ''
    event << "**Hay #{longFormattedNumber(b[0].reject{|q| q[0,4]!='def '}.length)} funciones que utilizan los comandos.**"
    if evrythg
      b=b[0].map{|q| q.gsub('  ','')}.reject{|q| q.length<=0}
      for i in 0...b.length
        b[i]=b[i][1,b[i].length-1] if b[i][0,1]==' '
      end
      event << ''
      event << 'Hay:'
      event << "#{longFormattedNumber(b.reject{|q| q[0,4]!='for '}.length)} bucles `for`."
      event << "#{longFormattedNumber(b.reject{|q| q[0,6]!='while '}.length)} bucles `while`."
      event << "#{longFormattedNumber(b.reject{|q| q[0,6]!='class '}.map{|q| q.split(' < ')[0]}.uniq.length)} definiciones `class` invocadas un total de #{longFormattedNumber(b.reject{|q| q[0,6]!='class '}.length)} veces."
      event << "#{longFormattedNumber(b.reject{|q| q[0,3]!='if '}.length)} árboles `if`, junto con #{longFormattedNumber(b.reject{|q| q[0,6]!='elsif '}.length)} ramas `elsif` y #{longFormattedNumber(b.reject{|q| q[0,4]!='else'}.length)} ramas `else`."
      event << "#{longFormattedNumber(b.reject{|q| q[0,7]!='unless '}.length)} árboles `unless`."
      event << "#{longFormattedNumber(b.reject{|q| count_in(q,'[')<=count_in(q,']')}.length)} matrices multilíneas."
      event << "#{longFormattedNumber(b.reject{|q| count_in(q,'{')<=count_in(q,'}')}.length)} hashes multilíneas."
      event << "#{longFormattedNumber(b.reject{|q| q[0,3]=='if ' || !remove_format(remove_format(q,"'"),'"').include?(' if ')}.length)} condicionales `if` de una sola línea."
      event << "#{longFormattedNumber(b.reject{|q| q[0,7]=='unless ' || !remove_format(remove_format(q,"'"),'"').include?(' unless ')}.length)} condicionales `unless` de una sola línea."
      event << "#{longFormattedNumber(b.reject{|q| q[0,7]!='return '}.length)} líneas `return`."
    end
    return nil
  end
  f='' if f.nil?
  f2='' if f2.nil?
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
  extln=2 if evrythg
  bot.servers.values(&:users)
  str="**Estoy en #{bot.servers.length} servidores, llegando a #{bot.users.length} usuarios.**"
  str2="#{"**" if evrythg}Hay #{legal_units.length}#{" (#{all_units.length})" unless legal_units.length==all_units.length} *personajes*#{", que incluyen:**" if evrythg}#{"." unless evrythg}"
  if evrythg
    l=legal_units.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    a=all_units.reject{|q| !q.availability[0].include?('p') || !q.duo.nil?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} personajes invocables"
    l=legal_units.reject{|q| !q.availability[0].include?('g')}
    a=all_units.reject{|q| !q.availability[0].include?('g')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} personajes de Batalla Mítica"
    l=legal_units.reject{|q| !q.availability[0].include?('t')}
    a=all_units.reject{|q| !q.availability[0].include?('t')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} personajes de la Tormenta"
    l=legal_units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?}
    a=all_units.reject{|q| !q.availability[0].include?('s') || !q.legendary.nil?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} personajes de temporada"
    l=legal_units.reject{|q| q.legendary.nil?}
    a=all_units.reject{|q| q.legendary.nil?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} personajes legendarios o míticos"
    l=legal_units.reject{|q| q.duo.nil?}
    a=all_units.reject{|q| q.duo.nil?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} personajes de Dúo o al Son"
    l=legal_units.reject{|q| !q.availability[0].include?('-')}
    a=all_units.reject{|q| !q.availability[0].include?('-')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} personajes inalcanzables"
  end
  str=extend_message(str,str2,event,2)
  str2="#{"**" if evrythg}Hay #{legal_skills.length}#{" (#{all_skills.length})" unless legal_skills.length==all_skills.length} *habilidades*#{", que incluyen:**" if evrythg}#{"." unless evrythg}"
  if evrythg
    l=legal_skills.reject{|q| !q.type.include?('Weapon')}
    a=all_skills.reject{|q| !q.type.include?('Weapon')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Armas"
    l=legal_skills.reject{|q| !q.type.include?('Assist')}
    a=all_skills.reject{|q| !q.type.include?('Assist')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Asistencias"
    l=legal_skills.reject{|q| !q.type.include?('Special')}
    a=all_skills.reject{|q| !q.type.include?('Special')}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Especiales"
    l=legal_skills.reject{|q| !q.isPassive?}
    a=all_skills.reject{|q| !q.isPassive?}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} Pasivas"
    l=legal_skills.reject{|q| !has_any?(q.type,['Duo','Harmonic'])}
    a=all_skills.reject{|q| !has_any?(q.type,['Duo','Harmonic'])}
    str2="#{str2}\n#{longFormattedNumber(l.length)}#{" (#{longFormattedNumber(a.length)})" unless l.length==a.length} habilidades Dúo/al Son"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if evrythg}Hay #{longFormattedNumber($structures.map{|q| q.name}.uniq.length)} *estructuras* con #{longFormattedNumber($structures.length)} niveles#{", que incluyen:**" if evrythg}#{"." unless evrythg}"
  if evrythg
    m=$structures.reject{|q| !q.type.include?('Offensive')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} estructuras Ofensivas#{" con #{longFormattedNumber(m.length)} niveles" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Defensive')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} estructuras Defensivas#{" con #{longFormattedNumber(m.length)} niveles" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Trap')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} Trampas#{" con #{longFormattedNumber(m.length)} niveles" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Resources')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} estructuras Recursos#{" con #{longFormattedNumber(m.length)} niveles" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Mjolnir')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} estructuras de Embate de Mjolnir#{" con #{longFormattedNumber(m.length)} niveles" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Ornament')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} estrucutras Decoradas#{" con #{longFormattedNumber(m.length)} niveles" unless m.map{|q| q.name}.uniq.length==m.length}"
    m=$structures.reject{|q| !q.type.include?('Resort')}
    str2="#{str2}\n#{longFormattedNumber(m.map{|q| q.name}.uniq.length)} estrucutras exclusivas para Lugar de verano#{" con #{longFormattedNumber(m.length)} niveles" unless m.map{|q| q.name}.uniq.length==m.length}"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if evrythg}Hay #{longFormattedNumber($itemus.length)} *artículos*#{", que incluyen:**" if evrythg}#{"." unless evrythg}"
  if evrythg
    m=$itemus.reject{|q| q.type !='Main'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos principales"
    m=$itemus.reject{|q| q.type !='Implied'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos implícitos"
    m=$itemus.reject{|q| q.type !='Blessing'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} bendiciónes"
    m=$itemus.reject{|q| q.type !='Growth'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos para el crecimiento del personaje"
    m=$itemus.reject{|q| q.type !='Assault'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos de Asalto del Coliseo / Batallas Fragorosas"
    m=$itemus.reject{|q| q.type !='Event'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} artículos de eventos"
    str2="#{str2}\n~~3 tronos que se cuentan como estructuras en mis datos aunque FEH los cuenta como estructuras y artículos~~"
  end
  str=extend_message(str,str2,event,extln)
  str2="#{"**" if evrythg}Hay #{longFormattedNumber($accessories.length)} *accesorios*#{", que incluyen:**" if evrythg}#{"." unless evrythg}"
  if evrythg
    m=$accessories.reject{|q| q.type !='Hair'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} horquillas y otros accesorios para el cabello"
    m=$accessories.reject{|q| q.type !='Hat'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} sombreros y otros accesorios para la parte superior de la cabeza"
    m=$accessories.reject{|q| q.type !='Mask'}
    str2="#{str2}\n#{longFormattedNumber(m.length)} mascarillas y otros accesorios faciales"
    m=$accessories.reject{|q| q.type !='Tiara'}
    str2="#{str2}\n__#{longFormattedNumber(m.length)} tiaras y otros accesorios para la nuca__"
    m=$accessories.reject{|q| !q.description.include?('Proof of victory over')}
    str2="#{str2}\n#{longFormattedNumber(m.length)} Accesorios Dorados"
  end
  str=extend_message(str,str2,event,extln)
  glbl=$aliases.reject{|q| !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[3].nil?}
  str2="**Hay #{longFormattedNumber(glbl.length+2)} *alias* global y #{longFormattedNumber(srv_spec.length)} alias específico del servidor.**"
  glbl=$aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Unit' || q[3].nil?}
  str2="#{str2}\nHay #{longFormattedNumber(glbl.length)} alias global y #{longFormattedNumber(srv_spec.length)} alias específico del servidor para personajes [únicos]."
  str2="#{str2}\nHay #{longFormattedNumber($aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}.length)} alias [global] para multipersonajes."
  glbl=$aliases.reject{|q| q[0]!='Skill' || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Skill' || q[3].nil?}
  str2="#{str2}\nHay #{longFormattedNumber(glbl.length)} alias global y #{longFormattedNumber(srv_spec.length)} alias específico del servidor para habilidades [únicos]\nHay 3 alias global para multihabilidades."
  glbl=$aliases.reject{|q| q[0]!='Structure' || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Structure' || q[3].nil?}
  str2="#{str2}\nHay #{longFormattedNumber(glbl.length)} alias global y #{longFormattedNumber(srv_spec.length)} alias específico del servidor para estructuras [únicos]."
  glbl=$aliases.reject{|q| q[0]!='Item' || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Item' || q[3].nil?}
  str2="#{str2}\nHay #{longFormattedNumber(glbl.length)} alias global y #{longFormattedNumber(srv_spec.length)} alias específico del servidor para artículos [únicos]."
  glbl=$aliases.reject{|q| q[0]!='Accessory' || !q[3].nil?}
  srv_spec=$aliases.reject{|q| q[0]!='Accessory' || q[3].nil?}
  str2="#{str2}\nHay #{longFormattedNumber(glbl.length)} alias global y #{longFormattedNumber(srv_spec.length)} alias específico del servidor para accesorios [únicos]."
  str=extend_message(str,str2,event,2)
  str=extend_message(str,"**Hay #{longFormattedNumber($groups.reject{|q| !q.fake.nil?}.length-1)} *grupos* globales and #{longFormattedNumber($groups.reject{|q| q.fake.nil?}.length)} grupos específico del servidor.**",event,2)
  str2="**Tengo #{longFormattedNumber(File.foreach("#{$location}devkit/PriscillaBot.rb").inject(0) {|c, line| c+1})} líneas de código.**"
  str2="#{str2}\nDe esos, #{longFormattedNumber(b.length)} no están vacíos."
  str=extend_message(str,str2,event,2)
  event.respond str
end

def spanish_commands(bot,event,args=[])
  args=args.map{|q| q.downcase}
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  if ['comandos','ayuda','auxilio'].include?(args[0])
    args.shift
    help_text(event,bot,args[0],args[1])
  elsif ['hoy','diarios','diario','diaria','ahora'].include?(args[0])
    args.shift
    today_in_feh(event,bot)
  elsif ['manana','manyana','mañana'].include?(args[0])
    args.shift
    today_in_feh(event,bot,true)
  elsif ['siguiente','calendario'].include?(args[0])
    args.shift
    next_events(bot,event,args)
  elsif ['encontra','busca','encontrar','buscar'].include?(args[0])
    args.shift
    display_units_and_skills(bot,event,args)
  elsif ['clasificar','clasifica','lista','listar'].include?(args[0].downcase)
    args.shift
    if ['skill','skil','skills','skils','habilidad','habilidades'].include?(args[0].downcase)
      args.shift
      sort_skills(bot,event,args)
    else
      sort_units(bot,event,args)
    end
  elsif ['grupos'].include?(args[0])
    disp_groups(event,bot)
  elsif ['masa'].include?(args[0])
    args.shift
    effHP(bot,event,args)
  elsif ['agrupar','agrupa','par','bolsillo'].include?(args[0])
    args.shift
    pair_up(bot,event,args)
  elsif ['curar','cura'].include?(args[0].downcase)
    args.shift
    heal_study(bot,event,args)
  elsif ['fase','fases'].include?(args[0].downcase)
    args.shift
    phase_study(bot,event,args)
  elsif ['estudio','estudia','estudiar'].include?(args[0].downcase)
    args.shift
    if ['effhp','eff_hp','bulk','masa'].include?(args[0].downcase)
      args.shift
      k=effHP(bot,event,args)
    elsif ['pairup','pair_up','pair','pocket','agrupar','agrupa','par','bolsillo'].include?(args[0].downcase)
      args.shift
      k=pair_up(bot,event,args)
    elsif ['heal','curar','cura'].include?(args[0].downcase)
      args.shift
      k=heal_study(bot,event,args)
    elsif ['proc'].include?(args[0].downcase)
      args.shift
      k=proc_study(bot,event,args)
    elsif ['fase','phase'].include?(args[0].downcase)
      args.shift
      k=phase_study(bot,event,args)
    end
    k=0 if k.nil?
    unit_study(bot,event,args) unless k>0
  elsif ['arte','artista'].include?(args[0].downcase)
    args.shift
    path_data(bot,event,args)
  elsif ['juego','juegos'].include?(args[0].downcase)
    args.shift
    game_data(bot,event,args)
  elsif ['personaje'].include?(args[0].downcase)
    args.shift
    if ['find','search','lookup','encontra','busca','encontrar','buscar'].include?(args[0].downcase)
      args.shift
      display_units(bot,event,args)
    elsif ['fgo'].include?(args[0].downcase) && !find_data_ex(:find_FGO_servant,event,args[1,args.length-1],nil,bot).nil?
      args.shift
      disp_stats_for_FGO(bot,event,args,find_data_ex(:find_FGO_servant,event,args,nil,bot))
    elsif ['sort','list','clasificar','clasifica','lista','listar'].include?(args[0].downcase)
      args.shift
      sort_units(bot,event,args)
    elsif ['compare','comparison','comparar','compara'].include?(args[0].downcase)
      args.shift
      comparison(bot,event,args)
    elsif ['pairup','pair_up','pair','pocket','agrupar','agrupa','par','bolsillo'].include?(args[0].downcase)
      args.shift
      pair_up(bot,event,args)
    else
      x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
      x[1]=first_sub(args.join(' ').downcase,x[1].downcase,'') unless x.nil?
      if x.nil?
        event.respond nomf()
      elsif x[0].is_a?(Array)
        disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],size)
      else
        disp_unit_stats(bot,event,x[0].name,x[1],size)
      end
    end
  elsif ['grande','enorme'].include?(args[0].downcase)
    if ['fgo'].include?(args[0].downcase) && !find_data_ex(:find_FGO_servant,event,args[1,args.length-1],nil,bot).nil?
      args.shift
      disp_stats_for_FGO(bot,event,args,find_data_ex(:find_FGO_servant,event,args,nil,bot))
    elsif ['pairup','pair_up','pair','pocket','agrupar','agrupa','par','bolsillo'].include?(args[0].downcase)
      args.shift
      pair_up(bot,event,args)
    else
      size='smol'
      size='medium' if ['big','tol','macro','large','grande'].include?(args[0].downcase)
      size='giant' if ['huge','massive','enorme'].include?(args[0].downcase)
      args.shift
      x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
      x[1]=first_sub(args.join(' ').downcase,x[1].downcase,'') unless x.nil?
      if x.nil?
        event.respond nomf()
      elsif x[0].is_a?(Array)
        disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],size)
      else
        disp_unit_stats(bot,event,x[0].name,x[1],size)
      end
    end
  elsif ['pequeno','pequena','pequeño','pequeña'].include?(args[0].downcase)
    args.shift
    x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
    x[1]=first_sub(args.join(' ').downcase,x[1].downcase,'') unless x.nil?
    if x.nil?
      smol_err(bot,event,false,true,true)
    elsif x[0].is_a?(Array)
      disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],'smol')
    else
      disp_unit_stats(bot,event,x[0].name,x[1],'smol')
    end
  elsif ['habilidades','pienso','libro','manualdecombate'].include?(args[0].downcase)
    aa=args[0].downcase
    args.shift
    if ['find','search','lookup','encontra','busca','encontrar','buscar'].include?(args[0].downcase)
      args.shift
      display_skills(bot,event,args)
    elsif ['sort','list','clasificar','clasifica','lista','listar'].include?(args[0].downcase)
      args.shift
      sort_skills(bot,event,args)
    elsif ['compare','comparison','comparar','compara'].include?(args[0].downcase)
      args.shift
      skill_comparison(bot,event,args)
    else
      x=find_data_ex(:find_unit,event,args,nil,bot)
      if x.nil?
        event.respond "No hay coincidencia.  #{"Si está buscando datos sobre las habilidades que aprende un personaje en particular, intente ```#{first_sub(event.message.text,'habilidades','habilidad')}```, sin la s." if s.downcase[0,11]=='habilidades'}"
      elsif x.is_a?(Array)
        disp_unit_skills(bot,event,x.map{|q| q.name}.name)
      else
        disp_unit_skills(bot,event,x.name)
      end
    end
  elsif ['habilidad'].include?(args[0].downcase)
    args.shift
    if ['find','search','lookup','encontra','busca','encontrar','buscar'].include?(args[0].downcase)
      args.shift
      display_skills(bot,event,args)
    elsif ['sort','list','clasificar','clasifica','lista','listar'].include?(args[0].downcase)
      args.shift
      sort_skills(bot,event,args)
    elsif ['compare','comparison','comparar','compara'].include?(args[0].downcase)
      args.shift
      skill_comparison(bot,event,args)
    else
      x=find_data_ex(:find_skill,event,args,nil,bot)
      if x.nil?
        event.respond "No hay coincidencias.  Si está buscando datos sobre las habilidades que aprende un personaje en particular, intente ```#{event.message.text.downcase.gsub('habilidad','habilidades')}``` en su lugar."
      else
        disp_skill_data(bot,event,x.name)
      end
    end
  elsif ['comparar','compara'].include?(args[0].downcase)
    args.shift
    if ['skill','skil','skills','skils','habilidad','habilidades'].include?(args[0].downcase)
      args.shift
      skill_comparison(bot,event,args)
    else
      comparison(bot,event,args)
    end
  elsif ['estructura'].include?(args[0].downcase)
    args.shift
    disp_struct(bot,args.join(' '),event)
  elsif ['articulo','artículo'].include?(args[0].downcase)
    args.shift
    disp_itemu(bot,args.join(' '),event)
  elsif ['accesorio','accesoria'].include?(args[0].downcase)
    args.shift
    disp_accessory(bot,args.join(' '),event)
  elsif ['legendario','legendarios','legendaria','legendarias'].include?(args[0].downcase)
    disp_legendary_list(bot,event,args,'Legendary')
  elsif ['mítica','míticas','mitica','miticas','mítico','míticos','mitico','miticos','mística','místicas','mistica','misticas','místico','místicos','mistico','misticos'].include?(args[0].downcase)
    disp_legendary_list(bot,event,args,'Mythic')
  elsif ['extra'].include?(args[0].downcase)
    x=[]
    x.push('Arena') if args.include?('arena')
    x.push('Tempest') if has_any?(args,['tempest','tt','tormenta'])
    x.push('Aether') if has_any?(args,['aether','raid','raids','aetherraids','aetherraid','aether_raids','aether_raid','aetheraids','aetheraid','eter','etér'])
    x.push('Resonant') if has_any?(args,['resonant','resonance','resonence','fragorosas','fragorosa'])
    if x.length<=0
      show_bonus_smol(event,x,bot)
      if safe_to_spam?(event)
        show_bonus_smol(event,x,bot,1)
        show_bonus_smol(event,x,bot,2)
      end
      return nil
    end
    x=[x[0]] unless safe_to_spam?(event)
    show_bonus_units(event,x,bot)
  elsif ['tormenta'].include?(args[0].downcase)
    show_bonus_units(event,['Tempest'],bot)
  elsif ['eter','etér'].include?(args[0].downcase)
    show_bonus_units(event,['Aether'],bot)
  elsif ['fragorosas','fragorosa'].include?(args[0].downcase)
    show_bonus_units(event,['Resonant'],bot)
  elsif ['naturalezas'].include?(args[0].downcase)
    event.respond "Una guía de nombres de la naturaleza.  Aunque cosas como `+Atq` y `-Def` todavía funcionan\nhttps://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/NatureNamesSpanish.png?raw=true"
  elsif ['fusiona'].include?(args[0].downcase)
    merge_explain(event,bot)
  elsif ['crecimientos'].include?(args[0].downcase)
    growth_explain(event,bot)
  elsif ['útiles','utiles','útile','utile','vínculo','vinculo','vínculos','vinculos','recursos','recurso'].include?(args[0].downcase)
    show_tools(event,bot)
  elsif ['pancarta','pancartas'].include?(args[0].downcase)
    args.shift
    if ['next','schedule','siguiente','calendario'].include?(args[0].downcase)
      disp_current_banners(event,bot,'')
      return nil
    elsif ['find','search','encontra','busca','encontrar','buscar'].include?(args[0].downcase)
      args.shift
      display_banners(bot,event,args)
      return nil
    end
    x=find_data_ex(:find_unit,event,args,nil,bot,false,0)
    unless x.is_a?(Array) || x.is_a?(FEHUnit)
      disp_current_banners(event,bot,'')
      return nil
    end
    banner_list(event,bot,args,x)
  elsif ['puntaje'].include?(args[0].downcase)
    score_explain(event,bot)
  elsif ['promedio'].include?(args[0].downcase)
    stats_of_multiunits(bot,event,args,0)
  elsif ['mejor'].include?(args[0].downcase)
    stats_of_multiunits(bot,event,args,1)
  elsif ['peor'].include?(args[0].downcase)
    stats_of_multiunits(bot,event,args,-1)
  elsif ['estado'].include?(args[0].downcase)
    spanish_avatar(bot,event)
  elsif ['grupos'].include?(args[0].downcase)
    disp_groups(event,bot)
  elsif ['mima'].include?(args[0].downcase)
    headpat(event,bot)
  elsif ['flor','flores'].include?(args[0].downcase)
    flower_array(event,bot)
  elsif ['editar','edita'].include?(args[0].downcase)
    args.shift
    cmd=args.shift
    donor_edit(bot,event,args,cmd)
  else
    args=sever(args.join(' ')).split(' ')
    find_best_match(event,args,nil,bot)
  end
  return nil
end
