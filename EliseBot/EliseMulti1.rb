def multi_for_units(event,str1,str2,robinmode=0)
  str1=str1.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  s=event.message.text.downcase
  if ['f?','e?','h?'].include?(str1.downcase[0,2]) || ['feh!','feh?'].include?(str1.downcase[0,4])
    s=s[2,s.length-2] if ['f?','e?','h?'].include?(str1.downcase[0,2])
    s=s[4,s.length-4] if ['feh!','feh?'].include?(str1.downcase[0,4])
    a=s.split(' ')
    a.shift if all_commands(true).include?(a[0]) || (['f?','e?','h?'].include?(a[0].downcase[0,2]) && all_commands(true).include?(a[0][2,a[0].length-2])) || (['feh?','feh!'].include?(a[0].downcase[0,4]) && all_commands(true).include?(a[0][4,a[0].length-4]))
    str1=a.join(' ').gsub('!','')
  elsif ['f','e','h'].include?(str1.downcase[0,1]) || ['feh!','feh?'].include?(str1.downcase[0,3])
    s=s[1,s.length-1] if ['f','e','h'].include?(str1.downcase[0,1])
    s=s[3,s.length-3] if ['feh','feh'].include?(str1.downcase[0,3])
    a=s.split(' ')
    a.shift if all_commands(true).include?(a[0]) || (['f','e','h'].include?(a[0].downcase[0,1]) && all_commands(true).include?(a[0][1,a[0].length-1])) || (['feh','feh'].include?(a[0].downcase[0,3]) && all_commands(true).include?(a[0][3,a[0].length-3]))
    str1=a.join(' ').gsub('!','')
  end
  k=0
  k=event.server.id unless event.server.nil?
  data_load()
  g=get_markers(event)
  u=@units.reject{|q| !has_any?(g, q[13][0])}
  nicknames_load()
  multi=@aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}
  for i in 0...multi.length
    if multi[i][1].downcase==str1
      m=multi[i][2].map{|q| u[u.find_index{|q2| q2[8]==q}][0]}
      m=['Robin'] if (m==['Robin(M)', 'Robin(F)'] || m==['Robin(F)', 'Robin(M)']) && robinmode != 1
      return [str1, m, multi[i][1].downcase]
    end
  end
  return nil if robinmode==3 # only allow actual multi-unit aliases without context clues
  for i in 0...u.length
    return [str1, [u[i][0]], str1] if str1.downcase==u[i][0].downcase.gsub('(','').gsub(')','')
  end
  alz=@aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || (!q[3].nil? && q[3].include?(k))}
  for i in 0...alz.length
    return [str1, [u[u.find_index{|q| q[8]==alz[i][2]}][0]], alz[i][1].downcase] if alz[i][1].downcase==str1
  end
  str3=str2.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  str2=str2.downcase.gsub('(','').gsub(')','').gsub('_','').gsub('!','').gsub('hp','').gsub('attack','').gsub('speed','').gsub('defense','').gsub('defence','').gsub('resistance','')
  if /blu(e(-|)|)cina/ =~ str1 || /bluc(i|y)/ =~ str1
    str='blucina'
    str='bluecina' if str2.include?('bluecina')
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Lucina(Bunny)','Lucina(Brave)','Lucina(Glorious)'],[str]]
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
  elsif /(hector|hektor|kektor|heckutoru)/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='hector'
    str='hektor' if str2.include?('hektor')
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
  elsif /(roy|roi||ourboy)/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='roy'
    str='roi' if str2.include?('roi')
    str='ourboy' if str2.include?('ourboy')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('legendary')
      return [str,['Roy(Fire)'],["legendary#{str}","#{str}legendary"]]
    elsif str2.include?('brave') || str2.include?('cyl') || str2.include?('bh')
      return [str,['Roy(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
    end
    return [str,['Roy(Brave)','Roy(Fire)'],[str]]
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
  elsif /(camil(|l)a|kamira)/ =~ str1
    str='camilla'
    str='camila' if str2.include?('camila')
    str='kamira' if str2.include?('kamira')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch')
      return [str,['Camilla(Launch)'],["vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","launch#{str}","#{str}launch"]]
    elsif str2.include?('bunny') || str2.include?('easter') || str2.include?('sf') || str2.include?('rabbit')
      return [str,['Camilla(Bunny)'],["bunny#{str}","#{str}bunny","easter#{str}","#{str}easter","sf#{str}","#{str}sf","rabbit#{str}","#{str}rabbit"]]
    elsif str2.include?('bath') || str2.include?('bathhouse') || str2.include?('bathouse') || str2.include?('hotspring') || str2.include?('hot') || str2.include?('spa')
      return [str,['Camilla(Bath)'],["bath#{str}","#{str}bath","bathhouse#{str}","#{str}bathhouse","bathouse#{str}","#{str}bathouse","hotspring#{str}","#{str}hotspring","hot#{str}","#{str}hot","spa#{str}","#{str}spa"]]
    elsif str2.include?('winter') || str2.include?('newyear') || str2.include?('holiday') || str2.include?('ny')
      return [str,['Camilla(Winter)'],["winter#{str}","#{str}winter","newyear#{str}","#{str}newyear","holiday#{str}","#{str}holiday","ny#{str}","#{str}ny"]]
    elsif str2.include?('adrift') || str2.include?('dream') || str2.include?('valla') || str2.include?('vallite') || str2.include?('dreamy') || str2.include?('dreamer') || str2.include?('dreaming') || str2.include?('dreams') || str2.include?('fauxzura') || str2.include?('fauxura') || str2.include?('revelation') || str2.include?('rev') || str2.include?('sleepy') || str2.include?('sleep')
      return [str,['Camilla(Adrift)'],["adrift#{str}","#{str}adrift","dream#{str}","#{str}dream","valla#{str}","#{str}valla","vallite#{str}","#{str}vallite","dreamy#{str}","#{str}dreamy","dreamer#{str}","#{str}dreamer","dreaming#{str}","#{str}dreaming","dreams#{str}","#{str}dreams","fauxzura#{str}","#{str}fauxzura","fauxura#{str}","#{str}fauxura","revelation#{str}","#{str}revelation","revelations#{str}","#{str}revelations","rev#{str}","#{str}rev","#{str}sleepy","#{str}sleep","sleepy#{str}","sleep#{str}"]]
    elsif str2.include?('spring')
      return [str,['Camilla(Bunny)','Camilla(Bath)'],["spring#{str}","#{str}spring","b#{str}","#{str}b"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Camilla(Launch)','Camilla(Adrift)'],[str]]
  elsif /(eirika|eirik|eiriku|erika|eirica)/ =~ str1
    str='eirik'
    str='eiriku' if str2.include?('eiriku')
    str='eirika' if str2.include?('eirika')
    str='eirica' if str2.include?('eirica')
    str='erika' if str2.include?('erika')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('winter') || str2.include?('christmas') || str2.include?('holiday') || str2.include?('gw') || str2.include?('gifts') || str2.include?('gift') || str2.include?('santa') || str2.include?("sant#{str}")
      return [str,['Eirika(Winter)'],["winter#{str}","#{str}winter","christmas#{str}","#{str}christmas","holiday#{str}","#{str}holiday","gifts#{str}","#{str}gifts","gift#{str}","#{str}gift","santa#{str}","#{str}santa","gw#{str}","#{str}gw","sant#{str}"]]
    elsif str2.include?('legendary') || str2.include?('legend') || str2.include?('graceful') || str2.include?("gr#{str}") || str2.include?("#{str}gr") || str2.include?('grace')
      return [str,['Eirika(Graceful)'],["graceful#{str}","#{str}graceful","grace#{str}","#{str}grace","gr#{str}","#{str}gr","legendary#{str}","legend#{str}","lh#{str}","#{str}legendary","#{str}legend","#{str}lh"]]
    elsif str2.include?('bonds') || str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?("#{str}b") || str2.include?("b#{str}") || str2.include?("fb")
      return [str,['Eirika(Bonds)'],["vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","bonds#{str}","b#{str}","fb#{str}","#{str}bonds","#{str}b","#{str}fb"]]
    elsif str2.include?('memories') || str2.include?("#{str}m") || str2.include?("m#{str}") || str2.include?("sm") || str2.include?("mage#{str}") || str2.include?("#{str}mage") || str2.include?("#{str}2") || str2.include?('eiricav')
      return [str,['Eirika(Memories)'],["memories#{str}","mage#{str}","m#{str}","sm#{str}","#{str}memories","#{str}mage","#{str}m","#{str}sm","#{str}2",'eiricav']]
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
    elsif str2.include?('wings') || str2.include?('kinshi') || str2.include?('wf') || str2.include?('winged') || str2.include?("#{str}2")
      return [str,['Hinoka(Wings)'],["wings#{str}","#{str}wings","kinshi#{str}","#{str}kinshi","wf#{str}","#{str}wf","winged#{str}","#{str}winged","#{str}2"]]
    elsif str2.include?('bath') || str2.include?('bathhouse') || str2.include?('bathouse') || str2.include?('hotspring') || str2.include?('hot') || str2.include?('spring')
      return [str,['Hinoka(Bath)'],["bath#{str}","#{str}bath","bathhouse#{str}","#{str}bathhouse","bathouse#{str}","#{str}bathouse","hotspring#{str}","#{str}hotspring","hot#{str}","#{str}hot","spring#{str}","#{str}spring"]]
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
    if str2.include?('winter') || str2.include?('christmas') || str2.include?('holiday') || str2.gsub('flower','').include?('we') || str2.include?('santa')
      return [str,['Chrom(Winter)'],["winter#{str}","#{str}winter","christmas#{str}","#{str}christmas","holiday#{str}","#{str}holiday","we#{str}","#{str}we","santa#{str}","#{str}santa"]]
    elsif str2.include?('bunny') || str2.include?('spring') || str2.include?('easter') || str2.include?('sf') || str2.include?('rabbit')
      return [str,['Chrom(Bunny)'],["bunny#{str}","#{str}bunny","spring#{str}","#{str}spring","easter#{str}","#{str}easter","sf#{str}","#{str}sf","rabbit#{str}","#{str}rabbit"]]
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
    elsif str2.include?('creatonist')
      return [str,['Tiki(Young)(Earth)'],["creationist#{str}","#{str}creatonist","creationistiki"]]
    elsif str2.include?('legendary') || str2.include?('legend') || str2.include?('caped') || str2.include?('cape') || str2.include?('hood') || str2.include?('hooded') || str2.include?('cloak') || str2.include?('cloaked') || str2.include?('earth') || str2.include?('leg')
      return [str,['Tiki(Young)(Earth)'],["legendary#{str}","#{str}legendary","#{str}legend","legend#{str}","#{str}caped","caped#{str}","#{str}cape","cape#{str}","#{str}hood","hood#{str}","#{str}hooded","hooded#{str}","#{str}cloak","cloak#{str}","#{str}cloaked","cloaked#{str}","#{str}earth","earth#{str}","leg#{str}","#{str}leg"]]
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
    elsif str2.include?('winter') || str2.include?('christmas') || str2.include?('holiday') || str2.gsub('flower','').include?('we')
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
    return [str,['Robin(M)','Robin(F)'],[str]] if robinmode==1
    return [str,['Robin'],[str]] if robinmode.zero?
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
    if str=='kamui' && (str2.include?('gaiden') || str2.include?('sov')) && find_unit('Kamui',event,true).length>0
      return [str,['Kamui'],['kamuigaiden','kamuisov','gaidenkamui','sovkamui']]
    elsif str2.include?('summer') || str2.include?('beach') || str2.include?('swimsuit') || str2.include?('ns')
      return [str,['Corrin(F)(Summer)']]
    elsif str2.include?('winter') || str2.include?('newyear') || str2.include?('holiday') || str2.include?('ny')
      return [str,['Corrin(M)(Winter)']]
    elsif str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch')
      strx='default'
      strx='vanilla' if str2.include?('vanilla')
      strx='og' if str2.include?('og')
      strx='launch' if str2.include?('launch')
      str2=str3.gsub(strx,'').gsub("#{str} ",str).gsub(" #{str}",str)
      m=["#{strx}#{str}","#{str}#{strx}","#{strx} #{str}","#{str} #{strx}"]
      if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}")
        for i in 0...m.length
          return [m[i],['Corrin(F)(Launch)'],m] if event.message.text.downcase.include?(m[i])
        end
        return [str,['Corrin(F)(Launch)'],m]
      elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
        for i in 0...m.length
          return [m[i],['Corrin(M)(Launch)'],m] if event.message.text.downcase.include?(m[i])
        end
        return [str,['Corrin(M)(Launch)'],m]
      end
      for i in 0...m.length
        return [m[i],['Corrin(M)(Launch)','Corrin(F)(Launch)'],m] if event.message.text.downcase.include?(m[i])
      end
      return [str,['Corrin(M)(Launch)','Corrin(F)(Launch)'],m]
    elsif str2.include?('adrift') || str2.include?('dream') || str2.include?('valla') || str2.include?('vallite') || str2.include?('dreamy') || str2.include?('dreamer') || str2.include?('dreaming') || str2.include?('dreams') || str2.include?('fauxzura') || str2.include?('fauxura') || str2.include?('revelation') || str2.include?('rev') || str2.include?('revelations') || str2.include?('sleepy') || str2.include?('sleep')
      strx='adrift'
      strx='dream' if str2.include?('dream')
      strx='dreamy' if str2.include?('dreamy')
      strx='dreams' if str2.include?('dreams')
      strx='dreamer' if str2.include?('dreamer')
      strx='dreaming' if str2.include?('dreaming')
      strx='valla' if str2.include?('valla')
      strx='vallite' if str2.include?('vallite')
      strx='fauxzura' if str2.include?('fauxzura')
      strx='fauxura' if str2.include?('fauxura')
      strx='rev' if str2.include?('rev')
      strx='revelation' if str2.include?('revelation')
      strx='revelations' if str2.include?('revelations')
      str2=str3.gsub(strx,'').gsub("#{str} ",str).gsub(" #{str}",str)
      m=["#{strx}#{str}","#{str}#{strx}","#{strx} #{str}","#{str} #{strx}"]
      if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("#{str}f") || str2.include?("f#{str}")
        for i in 0...m.length
          return [m[i],['Corrin(F)(Adrift)'],m] if event.message.text.downcase.include?(m[i])
        end
        return [str,['Corrin(F)(Adrift)'],m]
      elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("#{str}m") || str2.include?("m#{str}")
        for i in 0...m.length
          return [m[i],['Corrin(M)(Adrift)'],m] if event.message.text.downcase.include?(m[i])
        end
        return [str,['Corrin(M)(Adrift)'],m]
      end
      for i in 0...m.length
        return [m[i],['Corrin(M)(Adrift)','Corrin(F)(Adrift)'],m] if event.message.text.downcase.include?(m[i])
      end
      return [str,['Corrin(M)(Adrift)','Corrin(F)(Adrift)'],m]
    end
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('female') || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Corrin(F)(Launch)'],["female#{str}","f#{str}","#{str}female","#{str}f"]]
    elsif str2.include?('male') || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Corrin(M)(Launch)'],["male#{str}","m#{str}","#{str}male","#{str}m"]]
    end
    return [str,['Kamui'],[str]] if str=='kamui' && find_unit('Kamui',event,true).length>0
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Corrin(M)(Launch)','Corrin(F)(Launch)'],[str]]
  elsif /(morgan|marc)/ =~ str1 || (/linfan/ =~ str1 && !(/duelinfantry/ =~ str1))
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
    return nil if find_data_ex(:find_unit,event.message.text,event).length>0
    str='lyn'
    str='rin' if str2.include?('rin')
    str='lyndis' if str2.include?('lyndis')
    str='rindisu' if str2.include?('rindisu')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('ethlyn')
      return [str,['Ethlyn'],[str]]
    elsif str2.include?('florina')
      return [str,['Florina'],[str]]
    elsif str2.include?("bb#{str}") || str2.include?("#{str}bb") || str2.include?('bride') || str2.include?('bridal') || str2.include?('wedding')
      return [str,['Lyn(Bride)'],["bb#{str}","#{str}bb","#{str}bride","#{str}bridal","#{str}wedding","bride#{str}","bridal#{str}","wedding#{str}"]]
    elsif str2.include?('brave') || str2.include?('cyl') || str2.include?('nomad') || str2.include?("bh#{str}") || str2.include?("#{str}bh")
      return [str,['Lyn(Brave)'],["brave#{str}","nomad#{str}","cyl#{str}","bh#{str}","#{str}nomad","#{str}brave","#{str}cyl","#{str}bh"]]
    elsif str2.include?('abounds') || str2.include?('valentines') || str2.include?('devoted') || str2.include?("valentine's") || str2.include?("la#{str}") || str2.include?("#{str}la") || str2.include?("v#{str}") || str2.include?("#{str}v")
      return [str,['Lyn(Valentines)'],["love#{str}","abounds#{str}","devoted#{str}","valentines#{str}","valentine's#{str}","#{str}love","#{str}devoted","#{str}abounds","#{str}valentines","#{str}valentine's","la#{str}","#{str}la"]]
    elsif str2.include?('winds') || str2.include?('wind') || str2.include?('bladelord') || str2.include?('legendary') || str2.include?("#{str}lh") || str2.include?("lh#{str}")
      return [str,['Lyn(Wind)'],["wind#{str}","#{str}wind","bladelord#{str}","#{str}bladelord","#{str}legendary","legendary#{str}","lh#{str}","#{str}lh"]]
    elsif str2.include?('love')
      return [str,['Lyn(Bride)','Lyn(Valentines)'],["love#{str}","#{str}love"]]
    elsif str2.include?('bow') || str2.include?('archer') || str2.include?('legend')
      return [str,['Lyn(Brave)','Lyn(Wind)'],["#{str}bow","#{str}archer","bow#{str}","archer#{str}","#{str}legend","legend#{str}"]]
    elsif str2.include?("b#{str}") || str2.include?("br#{str}")
      return [str,['Lyn(Bride)','(Brave)'],["b#{str}","br#{str}"]]
    elsif str2.include?('eth')
      return [str,['Ethlyn'],[str]]
    elsif str2.include?('flo')
      return [str,['Florina'],[str]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Lyn'],[str]]
  end
  return nil
end

def game_adjust(name)
  name='Robin' if name==['Robin(M)','Robin(F)'] || name==['Robin(F)','Robin(M)']
  name='Corrin' if name==['Corrin(M)(Launch)','Corrin(F)(Launch)'] || name==['Corrin(F)(Launch)','Corrin(M)(Launch)']
  name='Corrin' if name==['Corrin(M)(Adrift)','Corrin(F)(Adrift)'] || name==['Corrin(F)(Adrift)','Corrin(M)(Adrift)']
  name='Azura' if name==['Azura(Performing)','Azura(Winter)']
  name='Lucina' if name==['Lucina(Bunny)','Lucina(Brave)']
  name='Hector' if name==['Hector(Marquess)','Hector(Brave)']
  name='Tiki' if name==['Tiki(Young)','Tiki(Adult)']
  name='Tiki' if name==['Tiki(Adult)(Summer)','Tiki(Young)(Summer)']
  name='Chrom(Launch)' if name==['Chrom(Launch)','Chrom(Branded)']
  name='Lyn' if name==['Lyn(Bride)','Lyn(Brave)'] || name==['Lyn(Brave)','Lyn(Wind)'] || name==['Lyn(Bride)','Lyn(Valentines)']
  name=name[0].gsub('(M)','(F)') if name.is_a?(Array) && name.length==2 && name[0].gsub('(M)','').gsub('(F)','')!=name[0] && name[0].gsub('(M)','').gsub('(F)','')==name[0].gsub('(F)','').gsub('(M)','')
  return name
end

def game_hybrid(u,event,bot)
  args=event.message.text.downcase.split(' ')
  if ['Robin(F)','Robin(M)'].include?(u)
    pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png'
    name='Robin'
    xcolor=avg_color([[39,100,222],[9,170,36]])
  elsif ['Morgan(F)','Morgan(M)'].include?(u)
    pic='https://orig00.deviantart.net/97f6/f/2018/068/a/c/morgan_by_rot8erconex-dc5drdn.png'
    name='Morgan'
    xcolor=avg_color([[39,100,222],[226,33,65]])
  elsif ['Kana(F)','Kana(M)'].include?(u)
    name='Kana'
    xcolor=avg_color([[39,100,222],[9,170,36]])
  elsif ['Robin(F)(Fallen)','Robin(M)(Fallen)'].include?(u)
    pic='https://orig00.deviantart.net/33ea/f/2018/104/2/7/grimleal_by_rot8erconex-dc8svax.png'
    name='Grima: Robin(Fallen)'
    xcolor=avg_color([[9,170,36],[222,95,9]])
  elsif ['Corrin(F)(Launch)','Corrin(M)(Launch)'].include?(u)
    pic='https://orig00.deviantart.net/d8ce/f/2018/051/1/a/corrin_by_rot8erconex-dc3tj34.png'
    name='Corrin'
    xcolor=avg_color([[226,33,65],[39,100,222]])
  elsif 'Chrom(Branded)'==u && !args.join('').include?('brand') && !args.join('').include?('exalt') && !args.join('').include?('sealed') && !args.join('').include?('branded') && !args.join('').include?('exalted') && !args.join('').include?('knight')
    return [pick_thumbnail(event,find_unit('Chrom(Launch)',event),bot),'Chrom(Launch)']
  else
    return []
  end
  return [pic,name,xcolor]
end

def list_unit_aliases(event,args,bot,mode=0)
  event.channel.send_temporary_message('Calculating data, please wait...',2)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load()
  nicknames_load()
  unit=nil
  skill=nil
  struct=nil
  azry=nil
  itmu=nil
  unless args.length.zero?
    unit=find_unit(args.join(''),event)[0] unless find_unit(args.join(''),event).length<=0
    skill=find_skill(args.join(''),event) unless find_skill(args.join(''),event).length<=0
    struct=find_structure(args.join(''),event) unless find_structure(args.join(''),event).length<=0
    azry=find_accessory(args.join(''),event)[0] unless find_accessory(args.join(''),event).length<=0
    itmu=find_item_feh(args.join(''),event)[0] unless find_item_feh(args.join(''),event).length<=0
    if !detect_multi_unit_alias(event,args.join(''),event.message.text.downcase,1).nil?
      x=detect_multi_unit_alias(event,args.join(''),event.message.text.downcase,1)
      unit=x[1]
      unit=[unit] unless unit.is_a?(Array)
      g=get_markers(event)
      u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
      unit=unit.reject{|q| !u.include?(q)}
    elsif find_unit(args.join(''),event).length<=0 && find_skill(args.join(''),event).length<=0 && find_accessory(args.join(''),event).length<=0 && find_item_feh(args.join(''),event).length<=0 && find_structure(args.join(''),event).length<=0 && !has_any?(args,['hero','heroes','heros','unit','units','characters','character','chara','charas','char','chars','skill','skills','skil','skils','structures','structure','struct','structs','item','items','accessorys','accessory','accessories'])
      alz=args.join(' ')
      alz='>censored mention<' if alz.include?('@')
      event.respond "The alias system can cover:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- [Aether Raids] Structures\n- Accessories\n- Items\n\n#{alz} does not fall into any of these categories."
      return nil
    end
  end
  unless unit.nil? || unit.is_a?(Array)
    unit=nil if find_unit(args.join(''),event).length<=0
  end
  unless skill.nil? || skill.is_a?(Array)
    skill=nil if find_skill(args.join(''),event).length<=0
  end
  if !struct.nil? && struct.length>0
    struct=struct.map{|q| @structures[q]}
  else
    struct=nil
  end
  unless itmu.nil? || itmu.is_a?(Array)
    itmu=nil if find_item_feh(args.join(''),event).length<=0
  end
  unless azry.nil? || azry.is_a?(Array)
    azry=nil if find_accessory(args.join(''),event).length<=0
  end
  f=[]
  n=@aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array)}.map{|q| [q[1],q[2],q[3]]}
  m=@aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}.map{|q| [q[1],q[2]]}
  h=''
  skipmulti=false
  if unit.nil? && skill.nil? && struct.nil? && azry.nil? && itmu.nil?
    if has_any?(args,['hero','heroes','heros','unit','units','characters','character','chara','charas','char','chars'])
      f.push('__**Single-unit aliases**__')
      for i in 0...n.length
        uuu=n[i][1]
        unless uuu.is_a?(String)
          if uuu<1000
            uuu=@units[uuu][0]
          else
            uu2=@units.find_index{|q| q[8]==uuu}
            uuu=@units[uu2][0] unless uu2.nil?
          end
        end
        if uuu==n[i][0]
        elsif n[i][2].nil?
          f.push("#{n[i][0]} = #{uuu}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{uuu}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{uuu} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
      if m.length>0 && mode != 1
        f.push("\n__**Multi-unit aliases**__")
        for i in 0...m.length
          uuuu=[]
          for i2 in 0...m[i][1].length
            uuu=m[i][1][i1]
            unless uuu.is_a?(String)
              if uuu<1000
                uuu=@units[uuu][0]
              else
                uu2=@units.find_index{|q| q[8]==uuu}
                uuu=@units[uu2][0] unless uu2.nil?
              end
            end
            uuuu.push(uuu)
          end
          f.push("#{m[i][0]}#{" = #{uuuu.join(', ')}" if unit.nil?}")
        end
      end
    elsif has_any?(args,['skill','skills','skil','skils'])
      n=@aliases.reject{|q| q[0]!='Skill'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Skill aliases**__')
      for i in 0...n.length
        uuu=n[i][1]
        unless uuu.is_a?(String)
          uu2=@skills.find_index{|q| q[0]==uuu}
          uu2=@skills[uu2] unless uu2.nil?
          unless uu2.nil?
            uuu="#{uu2[1]}#{"#{' ' unless uu2[1][-1,1]=='+'}#{uu2[2]}" unless ['-','example'].include?(uu2[2]) || ['Weapon','Assist','Special'].include?(uu2[6])}"
          end
        end
        if n[i][0]==uuu || n[i][0]==uuu.gsub(' ','')
        elsif n[i][2].nil?
          f.push("#{n[i][0]} = #{uuu}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{uuu}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{uuu} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
    elsif has_any?(args,['structures','structure','struct','structs'])
      n=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**[Aether Raids] Structure aliases**__')
      for i in 0...n.length
        if n[i][2].nil?
          f.push("#{n[i][0]} = #{n[i][1]}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{n[i][1]}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{n[i][1]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
    elsif has_any?(args,['accessorys','accessory','accessories'])
      n=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Accessory aliases**__')
      for i in 0...n.length
        if n[i][2].nil?
          f.push("#{n[i][0]} = #{n[i][1]}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{n[i][1]}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{n[i][1]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
    elsif has_any?(args,['items','item'])
      n=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Item aliases**__')
      for i in 0...n.length
        if n[i][2].nil?
          f.push("#{n[i][0]} = #{n[i][1]}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{n[i][1]}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{n[i][1]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
    elsif safe_to_spam?(event) || mode==1
      n=n.reject{|q| q[2].nil?} if mode==1
      unless event.server.nil?
        n=n.reject{|q| !q[2].nil? && !q[2].include?(event.server.id)}
        if n.length>25 && !safe_to_spam?(event)
          event.respond "There are so many aliases that I don't want to spam the server.  Please use the command in PM."
          return nil
        end
        msg='__**Single-unit aliases**__'
        for i in 0...n.length
          uuu=n[i][1]
          unless uuu.is_a?(String)
            if uuu<1000
              uuu=@units[uuu][0]
            else
              uu2=@units.find_index{|q| q[8]==uuu}
              uuu=@units[uu2][0] unless uu2.nil?
            end
          end
          msg=extend_message(msg,"#{n[i][0]} = #{uuu}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event) unless mode==1 && !event.server.nil?
        end
        unless mode==1
          msg=extend_message(msg,'__**Multi-unit aliases**__',event,2)
          for i in 0...m.length
            uuuu=[]
            for i2 in 0...m[i][1].length
              uuu=m[i][1][i1]
              unless uuu.is_a?(String)
                if uuu<1000
                  uuu=@units[uuu][0]
                else
                  uu2=@units.find_index{|q| q[8]==uuu}
                  uuu=@units[uu2][0] unless uu2.nil?
                end
              end
              uuuu.push(uuu)
            end
            msg=extend_message(msg,"#{m[i][0]} = #{uuuu.join(', ')}",event)
          end
        end
        n=@aliases.reject{|q| q[0]!='Skill'}.map{|q| [q[1],q[2],q[3]]}
        n=n.reject{|q| q[2].nil? || !q[2].include?(event.server.id)} if mode==1
        msg=extend_message(msg,'__**Skill aliases**__',event,2)
        for i in 0...n.length
          uuu=n[i][1]
          unless uuu.is_a?(String)
            uu2=@skills.find_index{|q| q[0]==uuu}
            uu2=@skills[uu2] unless uu2.nil?
            unless uu2.nil?
              uuu="#{uu2[1]}#{"#{' ' unless uu2[1][-1,1]=='+'}#{uu2[2]}" unless ['-','example'].include?(uu2[2]) || ['Weapon','Assist','Special'].include?(uu2[6])}"
            end
          end
          msg=extend_message(msg,"#{n[i][0]} = #{uuu}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event) unless mode==1 && !event.server.nil? && !n[i][2].nil? && !n[i][2].include?(event.server.id)
        end
        n=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
        n=n.reject{|q| q[2].nil? || !q[2].include?(event.server.id)} if mode==1
        msg=extend_message(msg,'__**[Aether Raids] Structure aliases**__',event,2)
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event) unless mode==1 && !event.server.nil? && !n[i][2].nil? && !n[i][2].include?(event.server.id)
        end
        n=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
        n=n.reject{|q| q[2].nil? || !q[2].include?(event.server.id)} if mode==1
        msg=extend_message(msg,'__**Accessory aliases**__',event,2)
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event) unless mode==1 && !event.server.nil? && !n[i][2].nil? && !n[i][2].include?(event.server.id)
        end
        n=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
        n=n.reject{|q| q[2].nil? || !q[2].include?(event.server.id)} if mode==1
        msg=extend_message(msg,'__**Item aliases**__',event,2)
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event) unless mode==1 && !event.server.nil? && !n[i][2].nil? && !n[i][2].include?(event.server.id)
        end
        event.respond msg
        return nil
      end
      f.push('__**Single-unit aliases**__')
      for i in 0...n.length
        uuu=n[i][1]
        unless uuu.is_a?(String)
          if uuu<1000
            uuu=@units[uuu][0]
          else
            uu2=@units.find_index{|q| q[8]==uuu}
            uuu=@units[uu2][0] unless uu2.nil?
          end
        end
        if uuu==n[i][0]
        elsif n[i][2].nil?
          f.push("#{n[i][0]} = #{uuu}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{uuu}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{uuu} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
      if m.length>0 && mode != 1
        f.push("\n__**Multi-unit aliases**__")
        for i in 0...m.length
          uuuu=[]
          for i2 in 0...m[i][1].length
            uuu=m[i][1][i1]
            unless uuu.is_a?(String)
              if uuu<1000
                uuu=@units[uuu][0]
              else
                uu2=@units.find_index{|q| q[8]==uuu}
                uuu=@units[uu2][0] unless uu2.nil?
              end
            end
            uuuu.push(uuu)
          end
          f.push("#{m[i][0]}#{" = #{uuuu.join(', ')}" if unit.nil?}")
        end
      end
      n=@aliases.reject{|q| q[0]!='Skill'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push("\n__**Skill aliases**__")
      for i in 0...n.length
        uuu=n[i][1]
        unless uuu.is_a?(String)
          uu2=@skills.find_index{|q| q[0]==uuu}
          uu2=@skills[uu2] unless uu2.nil?
          unless uu2.nil?
            uuu="#{uu2[1]}#{"#{' ' unless uu2[1][-1,1]=='+'}#{uu2[2]}" unless ['-','example'].include?(uu2[2]) || ['Weapon','Assist','Special'].include?(uu2[6])}"
          end
        end
        if n[i][0]==uuu || n[i][0]==uuu.gsub(' ','')
        elsif n[i][2].nil?
          f.push("#{n[i][0]} = #{uuu}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{uuu}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{uuu} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
      n=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push("\n__**[Aether Raids] Structure aliases**__")
      for i in 0...n.length
        if n[i][2].nil?
          f.push("#{n[i][0]} = #{n[i][1]}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{n[i][1]}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{n[i][1]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
      n=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Accessory aliases**__')
      for i in 0...n.length
        if n[i][2].nil?
          f.push("#{n[i][0]} = #{n[i][1]}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{n[i][1]}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{n[i][1]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
      n=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Item aliases**__')
      for i in 0...n.length
        if n[i][2].nil?
          f.push("#{n[i][0]} = #{n[i][1]}")
        elsif !event.server.nil? && n[i][2].include?(event.server.id)
          f.push("#{n[i][0]} = #{n[i][1]}#{" *(in this server only)*" unless mode==1}")
        elsif !event.server.nil?
        else
          a=[]
          for j in 0...n[i][2].length
            srv=(bot.server(n[i][2][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
            end
          end
          f.push("#{n[i][0]} = #{n[i][1]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
        end
      end
    else
      event.respond "The alias system can cover:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- [Aether Raids] Structures\n- Accessories\n- Items\n\Please either specify a member of one of these categories or use this command in PM."
      return nil
    end
  elsif !unit.nil? || !skill.nil?
    k=0
    k=event.server.id unless event.server.nil?
    if !unit.nil?
      unit=[unit] unless unit.is_a?(Array)
      h=' that contain this unit'
      h=' that contain both of these units' if unit.length>1
      h=' that contain all of these units' if unit.length>2
      for i1 in 0...unit.length
        u=find_unit(unit[i1],event)[0]
        u2=find_unit(unit[i1],event)[8]
        m=m.reject{|q| !q[1].include?(u2)}
        f.push("#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u}#{unit_moji(bot,event,-1,u,false,4)}**#{" [Unt-##{u2}]" if @shardizard==4}#{"'s server-specific aliases__" if mode==1}")
        f.push(u.gsub('(','').gsub(')','')) if u.include?('(') || u.include?(')')
        for i in 0...n.length
          mtch=false
          mtch=true if n[i][1].is_a?(String) && n[i][1].downcase==u.downcase
          mtch=true if !n[i][1].is_a?(String) && n[i][1]==u2
          mtch=false if !n[i][1].is_a?(String) && n[i][0].downcase==u.downcase
          if mtch
            if event.server.nil? && !n[i][2].nil?
              a=[]
              for j in 0...n[i][2].length
                srv=(bot.server(n[i][2][j]) rescue nil)
                unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
                  a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
                end
              end
              f.push("#{n[i][0]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
            elsif n[i][2].nil?
              f.push(n[i][0]) unless mode==1
            else
              f.push("#{n[i][0]}#{" *(in this server only)*" unless mode==1}") if n[i][2].include?(k)
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
    end
    if !skill.nil?
      n=@aliases.reject{|q| q[0]!='Skill'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      skill=[skill] unless skill[0].is_a?(Array)
      for i1 in 0...skill.length
        u=skill[i1]
        u2=u[0]
        f.push("\n#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u[1].gsub('Bladeblade','Laevatein')}#{"#{' ' unless u[1][-1,1]=='+'}#{u[2]}" unless ['-','example'].include?(u[2]) || ['Weapon','Assist','Special'].include?(u[6])}#{skill_moji_2(u,event,bot)}**#{" [Skl-##{u2}]" if @shardizard==4}#{"'s server-specific aliases__" if mode==1}")
        u="#{u[1]}#{"#{' ' unless u[1][-1,1]=='+'}#{u[2]}" unless ['-','example'].include?(u[2]) || ['Weapon','Assist','Special'].include?(u[6])}"
        f.push(u) if u=='Bladeblade'
        f.push(u.gsub('(','').gsub(')','').gsub(' ','')) if u.include?('(') || u.include?(')') || u.include?(' ')
        for i in 0...n.length
          mtch=false
          mtch=true if n[i][1].is_a?(String) && n[i][1].downcase==u.downcase
          mtch=true if !n[i][1].is_a?(String) && n[i][1]==u2
          mtch=false if !n[i][1].is_a?(String) && n[i][0].downcase==u.downcase
          if mtch
            if event.server.nil? && !n[i][2].nil?
              a=[]
              for j in 0...n[i][2].length
                srv=(bot.server(n[i][2][j]) rescue nil)
                unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
                  a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
                end
              end
              f.push("#{n[i][0]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
            elsif n[i][2].nil?
              f.push(n[i][0]) unless mode==1
            else
              f.push("#{n[i][0]}#{" *(in this server only)*" unless mode==1}") if n[i][2].include?(k)
            end
          end
        end
      end
    end
  elsif !struct.nil?
    k=0
    k=event.server.id unless event.server.nil?
    n=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
    n=n.reject{|q| q[2].nil?} if mode==1
    semote=''
    semote='<:Battle_Structure:565064414454349843>' if struct[0][2]=='Offensive/Defensive'
    semote='<:Defensive_Structure:510774545108566016>' if struct[0][2]=='Defensive'
    semote='<:Offensive_Structure:510774545997758464>' if struct[0][2]=='Offensive'
    semote='<:Trap_Structure:510774545179869194>' if struct[0][2]=='Trap'
    semote='<:Resource_Structure:510774545154572298>' if struct[0][2]=='Resources'
    semote='<:Ornamental_Structure:510774545150640128>' if struct[0][2]=='Ornament'
    semote='<:Resort_Structure:565064414521196561>' if struct[0][2]=='Resort'
    unless n.find_index{|q| q[1].downcase==struct[0][0].downcase}.nil?
      f.push("\n#{"__" if mode==1}**#{struct[0][0]}#{semote}**#{"'s server-specific aliases__" if mode==1}")
      f.push("#{struct[0][0].gsub('(','').gsub(')','').gsub(' ','')}") if struct[0][0].include?('(') || struct[0][0].include?(')') || struct[0][0].include?(' ')
      for i in 0...n.length
        if n[i][1].downcase==struct[0][0].downcase
          if event.server.nil? && !n[i][2].nil?
            a=[]
            for j in 0...n[i][2].length
              srv=(bot.server(n[i][2][j]) rescue nil)
              unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
                a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
              end
            end
            f.push("#{n[i][0]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
          elsif n[i][2].nil?
            f.push(n[i][0]) unless mode==1
          else
            f.push("#{n[i][0]}#{" *(in this server only)*" unless mode==1}") if n[i][2].include?(k)
          end
        end
      end
    end
    for i1 in 0...struct.length
      unless n.find_index{|q| q[1].downcase=="#{struct[i1][0]} #{struct[i1][1]}".downcase}.nil?
        f.push("\n#{"\n" unless i1.zero?}#{"__" if mode==1}**#{struct[i1][0]} #{struct[i1][1]}#{semote}**#{"'s server-specific aliases__" if mode==1}")
        f.push("#{struct[i1][0].gsub('(','').gsub(')','').gsub(' ','')}#{struct[i1][1]}")
        for i in 0...n.length
          if n[i][1].downcase=="#{struct[i1][0]} #{struct[i1][1]}".downcase
            if event.server.nil? && !n[i][2].nil?
              a=[]
              for j in 0...n[i][2].length
                srv=(bot.server(n[i][2][j]) rescue nil)
                unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
                  a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
                end
              end
              f.push("#{n[i][0]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
            elsif n[i][2].nil?
              f.push(n[i][0]) unless mode==1
            else
              f.push("#{n[i][0]}#{" *(in this server only)*" unless mode==1}") if n[i][2].include?(k)
            end
          end
        end
      end
    end
  elsif !azry.nil?
    k=0
    k=event.server.id unless event.server.nil?
    n=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
    n=n.reject{|q| q[2].nil?} if mode==1
    azry=[azry] unless azry.is_a?(Array)
    for i1 in 0...azry.length
      u=find_accessory(azry[i1],event)
      semote=''
      semote='<:Accessory_Type_Hair:531733124741201940>' if u[1]=='Hair'
      semote='<:Accessory_Type_Hat:531733125227741194>' if u[1]=='Hat'
      semote='<:Accessory_Type_Mask:531733125064163329>' if u[1]=='Mask'
      semote='<:Accessory_Type_Tiara:531733130734731284>' if u[1]=='Tiara'
      f.push("\n#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u[0]}**#{semote}#{"'s server-specific aliases__" if mode==1}")
      u=u[0]
      f.push(u.gsub('(','').gsub(')','').gsub(' ','')) if u.include?('(') || u.include?(')') || u.include?(' ')
      for i in 0...n.length
        mtch=false
        mtch=true if n[i][1].is_a?(String) && n[i][1].downcase==u.downcase
       # mtch=true if !n[i][1].is_a?(String) && n[i][1]==u2
        if mtch
          if event.server.nil? && !n[i][2].nil?
            a=[]
            for j in 0...n[i][2].length
              srv=(bot.server(n[i][2][j]) rescue nil)
              unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
                a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
              end
            end
            f.push("#{n[i][0]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
          elsif n[i][2].nil?
            f.push(n[i][0]) unless mode==1
          else
            f.push("#{n[i][0]}#{" *(in this server only)*" unless mode==1}") if n[i][2].include?(k)
          end
        end
      end
    end
  elsif !itmu.nil?
    k=0
    k=event.server.id unless event.server.nil?
    n=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
    n=n.reject{|q| q[2].nil?} if mode==1
    itmu=[itmu] unless itmu.is_a?(Array)
    for i1 in 0...itmu.length
      u=find_item_feh(itmu[i1],event)
      f.push("\n#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u[0]}**#{"'s server-specific aliases__" if mode==1}")
      u=u[0]
      f.push(u.gsub('(','').gsub(')','').gsub(' ','')) if u.include?('(') || u.include?(')') || u.include?(' ')
      for i in 0...n.length
        mtch=false
        mtch=true if n[i][1].is_a?(String) && n[i][1].downcase==u.downcase
       # mtch=true if !n[i][1].is_a?(String) && n[i][1]==u2
        if mtch
          if event.server.nil? && !n[i][2].nil?
            a=[]
            for j in 0...n[i][2].length
              srv=(bot.server(n[i][2][j]) rescue nil)
              unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
                a.push("*#{bot.server(n[i][2][j]).name}*") unless event.user.on(n[i][2][j]).nil?
              end
            end
            f.push("#{n[i][0]} (in the following servers: #{list_lift(a,'and')})") if a.length>0
          elsif n[i][2].nil?
            f.push(n[i][0]) unless mode==1
          else
            f.push("#{n[i][0]}#{" *(in this server only)*" unless mode==1}") if n[i][2].include?(k)
          end
        end
      end
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

def add_new_alias(bot,event,newname=nil,unit=nil,modifier=nil,modifier2=nil,mode=0)
  data_load()
  nicknames_load()
  err=false
  str=''
  if newname.nil? || unit.nil?
    str="The alias system can cover:\n- Units\n- Skills (Weapons, Assists, Specials, Passives)\n- [Aether Raids] Structures\n- Accessories\n- Items\n\nYou must specify both:\n- one of the above\n- an alias you wish to give that object"
    err=true
  elsif event.user.id != 167657750971547648 && event.server.nil?
    str='Only my developer is allowed to use this command in PM.'
    err=true
  elsif !is_mod?(event.user,event.server,event.channel) && ![368976843883151362,195303206933233665].include?(event.user.id)
    str='You are not a mod.'
    err=true
  elsif newname.include?('"') || newname.include?("\n")
    str='Full stop.  " is not allowed in an alias.'
    err=true
  elsif !event.server.nil? && event.server.id==363917126978764801
    str="You guys revoked your permission to add aliases when you refused to listen to me regarding the Erk alias for Serra."
    err=true
  end
  if err
    event.respond str if str.length>0 && mode==0
    args=event.message.text.downcase.split(' ')
    args.shift
    list_unit_aliases(event,args,bot) if mode==1
    return nil
  end
  type=['Alias','Alias']
  newname=newname.gsub('!','').gsub('(','').gsub(')','').gsub('_','')
  unit=unit.gsub('!','').gsub('(','').gsub(')','').gsub('_','')
  if find_unit(newname,event,true).length>0
    type[0]='Unit'
  elsif find_skill(newname,event,true).length>0
    type[0]='Skill'
  elsif find_structure(newname,event,true).length>0
    type[0]='Structure'
  elsif find_accessory(newname,event,true).length>0
    type[0]='Accessory'
  elsif find_item_feh(newname,event,true).length>0
    type[0]='Item'
  elsif find_unit(newname,event).length>0
    type[0]='Unit*'
  elsif find_skill(newname,event).length>0
    type[0]='Skill*'
  elsif find_structure(newname,event).length>0
    type[0]='Structure*'
  elsif find_accessory(newname,event).length>0
    type[0]='Accessory*'
  elsif find_item_feh(newname,event).length>0
    type[0]='Item*'
  end
  type[0]='Skill' if newname.downcase=='adult'
  if find_unit(unit,event,true).length>0
    type[1]='Unit'
  elsif find_skill(unit,event,true).length>0
    type[1]='Skill'
  elsif find_structure(unit,event,true).length>0
    type[1]='Structure'
  elsif find_accessory(unit,event,true).length>0
    type[1]='Accessory'
  elsif find_item_feh(unit,event,true).length>0
    type[1]='Item'
  elsif find_unit(unit,event).length>0
    type[1]='Unit*'
  elsif find_skill(unit,event).length>0
    type[1]='Skill*'
  elsif find_structure(unit,event).length>0
    type[1]='Structure*'
  elsif find_accessory(unit,event).length>0
    type[1]='Accessory*'
  elsif find_item_feh(unit,event).length>0
    type[1]='Item*'
  end
  type[1]='Skill' if unit.downcase=='adult'
  cck=nil
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
    str="The alias system can cover:\n- Units\n- Skills (Weapons, Assists, Specials, Passives)\n- [Aether Raids] Structures\n- Accessories\n- Items\n\nNeither #{newname} nor #{unit} is any of the above."
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
  if err
    str=["#{str}\nPlease try again.","#{str}\nTrying to list aliases instead."][mode]
    event.respond str if str.length>0
    args=event.message.text.downcase.split(' ')
    args.shift
    list_unit_aliases(event,args,bot) if mode==1
    return nil
  end
  if type[1]=='Alias' && type[0]!='Alias'
    f="#{newname}"
    newname="#{unit}"
    unit="#{f}"
    type=type.reverse.map{|q| q.gsub('*','')}
  else
    type=type.map{|q| q.gsub('*','')}
  end
  checkstr=normalize(newname,true)
  if type[0]=='Alias' && type[1].gsub('*','')=='Unit'
    unt=find_unit(unit,event)
    unt=unt[0] if unt[0].is_a?(Array)
    checkstr2=checkstr.downcase.gsub(unt[12].split(', ')[0].gsub('*','').downcase,'')
    cck=unt[12].split(', ')[1][0,1].downcase if unt[12].split(', ').length>1
  elsif type[0]=='Alias' && type[1].gsub('*','')=='Skill'
    unt=find_skill(unit,event)
    unt=unt[0] if unt[0].is_a?(Array)
    checkstr2="#{unt[1]}#{"#{' ' unless unt[1][-1,1]=='+'}#{unt[2]}" unless ['-','example'].include?(unt[2]) || ['Weapon','Assist','Special'].include?(unt[6])}".gsub(' ','')
    unless @shardizard==4
      event.respond "Adding aliases to skills is currently disabled due to an overhaul being made to the skill system.  Please be patient as this may take a few days."
      return nil
    end
  elsif type[0]=='Alias' && type[1].gsub('*','')=='Structure'
    unt=find_structure(unit,event)
    if unt.is_a?(Array) && unt.length<=1
      unt=@structures[unt[0]]
      unt[0]="#{unt[0]} #{unt[1]}"
    elsif unt.is_a?(Array)
      unt=@structures[unt[0]]
    else
      unt=@structures[unt]
    end
    checkstr2="#{unt[0]}"
  elsif type[0]=='Alias' && type[1].gsub('*','')=='Accessory'
    unt=find_accessory(unit,event)
    checkstr2="#{unt[0]}"
  elsif type[0]=='Alias' && type[1].gsub('*','')=='Item'
    unt=find_item_feh(unit,event)
    checkstr2="#{unt[0]}"
  end
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  srv=0
  srv=event.server.id unless event.server.nil?
  srv=modifier.to_i if event.user.id==167657750971547648 && modifier.to_i.to_s==modifier
  srvname='PM with dev'
  srvname=bot.server(srv).name unless event.server.nil? && srv.zero?
  k=event.message.emoji
  for i in 0...k.length
    checkstr=checkstr.gsub("<:#{k[i].name}:#{k[i].id}>",k[i].name)
  end
  if type[1]=='Unit' && checkstr2.length<=1 && checkstr2 != cck && event.user.id != 167657750971547648
    event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nOne need look no farther than BLucina, BLyn, BCamilla, or SCamilla to understand why single-letter alias differentiation is a bad idea."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Single-letter differentiation.")
    return nil
  elsif !detect_multi_unit_alias(event,checkstr.downcase,checkstr.downcase,2).nil?
    x=detect_multi_unit_alias(event,checkstr.downcase,checkstr.downcase,2)
    if checkstr.downcase==x[0] || (!x[2].nil? && x[2].include?(checkstr.downcase))
      event.respond "#{newname} has __***NOT***__ been added to #{unt[0]}'s aliases.\nThis is a multi-unit alias."
      bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Confusion prevention.")
      return nil
    end
  elsif checkstr.downcase =~ /(7|t)+?h+?(o|0)+?(7|t)+?/
    event.respond "That name has __***NOT***__ been added to #{unt[0]}'s aliases."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  elsif checkstr.downcase =~ /n+?((i|1)+?|(e|3)+?)(b|g|8)+?(a|4|(e|3)+?r+?)+?/
    event.respond "That name has __***NOT***__ been added to #{unt[0]}'s aliases."
    bot.channel(logchn).send_message("~~**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** >Censored< for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  end
  newname=normalize(newname,true)
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
  unit=unt[8] if type[1]=='Unit'
  unit="#{unt[1]}#{"#{' ' unless unt[1][-1,1]=='+'}#{unt[2]}" unless ['-','example'].include?(unt[2]) || ['Weapon','Assist','Special'].include?(unt[6])}" if type[1]=='Skill'
  double=false
  for i in 0...@aliases.length
    mtch=false
    mtch=true if @aliases[i][2].is_a?(String) && unit.is_a?(String) && @aliases[i][2].downcase==unit.downcase
    mtch=true if !@aliases[i][2].is_a?(String) && !unit.is_a?(String) && @aliases[i][2]==unit
    if @aliases[i][3].nil? || @aliases[i][0]!=type[1]
    elsif @aliases[i][1].downcase==newname.downcase && mtch
      if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?
        @aliases[i][3]=nil
        @aliases[i][4]=nil
        @aliases[i].compact!
        bot.channel(chn).send_message("The alias **#{newname}** for the #{type[1].downcase} *#{unit.gsub('Bladeblade','Laevatein')}* exists in a server already.  Making it global now.")
        event.respond "The alias **#{newname}** for the #{type[1].downcase} *#{unit.gsub('Bladeblade','Laevatein')}* exists in a server already.  Making it global now.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit} - gone global.")
        double=true
      else
        @aliases[i][3].push(srv)
        bot.channel(chn).send_message("The alias **#{newname}** for the #{type[1].downcase} *#{unt[0].gsub('Bladeblade','Laevatein')}* exists in another server already.  Adding this server to those that can use it.")
        event.respond "The alias **#{newname}** for the #{type[1].downcase} *#{unt[0].gsub('Bladeblade','Laevatein')}* exists in another server already.  Adding this server to those that can use it.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        metadata_load()
        bot.user(167657750971547648).pm("The alias **#{@aliases[i][1]}** for the #{type[1].downcase} **#{@aliases[i][2]}** is used in quite a few servers.  It might be time to make this global") if @aliases[i][3].length >= @server_data[0].inject(0){|sum,x| sum + x } / 20 && @aliases[i][4].nil?
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unt[0]} - gained a new server that supports it.")
        double=true
      end
    end
  end
  unless double
    @aliases.push([type[1].gsub('*',''),newname,unt[0],m].compact)
    @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    bot.channel(chn).send_message("**#{newname}** has been#{" globally" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?} added to the aliases for the #{type[1].gsub('*','').downcase} *#{unit}*.\nPlease test to be sure that the alias stuck.")
    event.respond "**#{newname}** has been#{" globally" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?} added to the aliases for the #{type[1].gsub('*','').downcase} *#{unt[0]}*." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit}#{" - global alias" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?}")
  end
  @aliases.uniq!
  nzzz=@aliases.map{|a| a}
  open('C:/Users/Mini-Matt/Desktop/devkit/FEHNames.txt', 'w') { |f|
    for i in 0...nzzz.length
      f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
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

def list_collapse(list,mode=0)
  list2=list.map{|q| "#{'-' if q[0]<0}#{q[0].abs/10}"}.uniq
  list3=[]
  for i in 0...list2.length
    m=list.reject{|q| "#{'-' if q[0]<0}#{q[0].abs/10}" != list2[i]}
    n=m[-1]
    if ['Falchion','Missiletainn'].include?(m[0][1])
      for i2 in 0...m.length
        list3.push(m[i2]) unless ['Falchion','Missiletainn'].include?(m[i2][1])
      end
    elsif ['Whelp (All)','Yearling (All)','Adult (All)'].include?(m[0][1])
    elsif ['Weapon','Assist','Special'].include?(n[6])
      x=m.map{|q| q[1].gsub('~~','')}
      if (mode/2)%2==0 && ['Fire Breath','Fire Breath+','Flametongue','Flametongue+'].include?(x[0])
        if n[1].include?('Flametongue')
          if x.include?('Fire Breath') && x.include?('Fire Breath+')
            m[1][1]='Fire Breath[+]'
            list3.push(m[1])
          else
            list3.push(m[0])
          end
        end
        n[1]=n[1].gsub('+','[+]') if n[1].include?('+') && x.include?(n[1].gsub('+',''))
      elsif m[0][1]=='Ragnarok'
        n=m[0].map{|q| q}
      elsif x.include?("#{x[0]}+")
        n[1]="#{x[0]}[+]"
        n[1]="#{x[0]}[+]/Flametongue" if x.include?('Flametongue')
        n[1]="#{x[0]}[+]/Flametongue+" if x.include?('Flametongue+')
        n[1]="#{x[0]}[+]/Flametongue[+]" if x.include?('Flametongue') && x.include?('Flametongue+')
      elsif x[0].gsub('+','')=='Fire Breath'
        n[1]="#{x[0]}/Flametongue" if x.include?('Flametongue')
        n[1]="#{x[0]}/Flametongue+" if x.include?('Flametongue+')
        n[1]="#{x[0]}/Flametongue[+]" if x.include?('Flametongue') && x.include?('Flametongue+')
      elsif (mode/2)%2==0 && ['Ruin','Flux','Fenrir','Fenrir+','Fire','Elfire','Bolganone','Bolganone+','Thunder','Elthunder','Thoron','Thoron+','Light','Ellight','Shine','Shine+','Wind','Elwind','Rexcalibur','Rexcalibur+'].include?(x[0])
        for i2 in 0...m.length
          list3.push(m[i2]) unless m[i2][1].gsub('+','')==n[1].gsub('+','')
        end
        n[1]=n[1].gsub('+','[+]') if n[1].include?('+') && x.include?(n[1].gsub('+',''))
      elsif ['Ruin','Flux','Fenrir','Fenrir+'].include?(x[0])
        n[1]=''
        n[1]="Ruin" if x.include?('Ruin')
        n[1]="#{n[1]}/Flux" if x.include?('Flux')
        n[1]="#{n[1]}/Fenrir" if x.include?('Fenrir')
        if x.include?('Fenrir+')
          if n[1].include?('Fenrir')
            n[1]="#{n[1]}[+]"
          else
            n[1]="#{n[1]}/Fenrir+"
          end
        end
      elsif ['Fire','Elfire','Bolganone','Bolganone+'].include?(x[0])
        n[1]=''
        n[1]="Fire" if x.include?('Fire')
        n[1]="Elfire" if x.include?('Elfire')
        n[1]="[El]Fire" if x.include?('Fire') && x.include?('Elfire')
        n[1]="#{n[1]}/Bolganone" if x.include?('Bolganone')
        if x.include?('Bolganone+')
          if n[1].include?('Bolganone')
            n[1]="#{n[1]}[+]"
          else
            n[1]="#{n[1]}/Bolganone+"
          end
        end
      elsif ['Thunder','Elthunder','Thoron','Thoron+'].include?(x[0])
        n[1]=''
        n[1]="Thunder" if x.include?('Thunder')
        n[1]="Elthunder" if x.include?('Elthunder')
        n[1]="[El]Thunder" if x.include?('Thunder') && x.include?('Elthunder')
        n[1]="#{n[1]}/Thoron" if x.include?('Thoron')
        if x.include?('Thoron+')
          if n[1].include?('Thoron')
            n[1]="#{n[1]}[+]"
          else
            n[1]="#{n[1]}/Thoron+"
          end
        end
      elsif ['Light','Ellight','Shine','Shine+'].include?(x[0])
        n[1]=''
        n[1]="Light" if x.include?('Light')
        n[1]="Ellight" if x.include?('Ellight')
        n[1]="[El]Light" if x.include?('Light') && x.include?('Ellight')
        n[1]="#{n[1]}/Shine" if x.include?('Shine')
        if x.include?('Shine+')
          if n[1].include?('Shine')
            n[1]="#{n[1]}[+]"
          else
            n[1]="#{n[1]}/Shine+"
          end
        end
      elsif ['Wind','Elwind','Rexcalibur','Rexcalibur+'].include?(x[0])
        n[1]=''
        n[1]="Wind" if x.include?('Wind')
        n[1]="Elwind" if x.include?('Elwind')
        n[1]="[El]Wind" if x.include?('Wind') && x.include?('Elwind')
        n[1]="#{n[1]}/Rexcalibur" if x.include?('Rexcalibur')
        if x.include?('Rexcalibur+')
          if n[1].include?('Rexcalibur')
            n[1]="#{n[1]}[+]"
          else
            n[1]="#{n[1]}/Rexcalibur+"
          end
        end
      elsif x[0][0,5]=='Iron ' || x[0][0,6]=='Steel '
        mm=x[0].split(' ')[1]
        n[1]=''
        n[1]="Iron" if x.include?("Iron #{mm}")
        n[1]="#{n[1]}/Steel" if x.include?("Steel #{mm}")
        n[1]="#{n[1]}/Silver" if x.include?("Silver #{mm}")
        if x.include?("Silver #{mm}+")
          if n[1].include?('Silver')
            n[1]="#{n[1]}[+]"
          else
            n[1]="#{n[1]}/Silver+"
          end
        end
        n[1]="#{n[1]} #{mm}"
      elsif x[0][0,7]=='Whelp (' || x[0][0,11]=='Hatchling (' || x[0][0,10]=='Yearling (' || x[0][0,11]=='Fledgling (' || x[0][0,7]=='Adult( '
        mm=x[0].split(' (')[1]
        n[1]=''
        n[1]="Whelp" if x.include?("Whelp (#{mm}")
        n[1]="Hatchling" if x.include?("Hatchling (#{mm}")
        n[1]="#{n[1]}/Yearling" if x.include?("Yearling (#{mm}")
        n[1]="#{n[1]}/Fledgling" if x.include?("Fledgling (#{mm}")
        n[1]="#{n[1]}/Adult" if x.include?("Adult (#{mm}")
        n[1]="#{n[1]} (#{mm}"
      end
      n[1]=n[1][1,n[1].length-1] if n[1][0,1]=='/'
      list3.push(n)
    elsif m.length<=1 || m.reject{|q| q[2].to_i.to_s != q[2]}.length<=1
    else
      n=m.reject{|q| q[2].to_i.to_s != q[2]}[-1].map{|q| q}
      n[2]='-'
      n[1]="#{n[1]}#{' ' unless n[1][-1,1]=='+'}#{m.reject{|q| q[2].to_i.to_s != q[2]}.map{|q| q[2]}.uniq.join('/')}"
      list3.push(n)
    end
  end
  list3=list3.sort {|a,b| a[1].gsub('~~','').gsub('*','').gsub('[El]','').downcase <=> b[1].gsub('~~','').gsub('*','').gsub('[El]','').downcase} unless (mode/8)%2==1
  return list3
end

def legal_weapon(event,name,weapon,refinement='-',recursion=false)
  return '-' if weapon=='-'
  u=@units[@units.find_index{|q| q[0]==name}]
  w=@skills[@skills.find_index{|q| q[1]==weapon.gsub('Laevatein','Bladeblade')}]
  unless w[1].split(' ')[0].length>u[0].length
    return '-' if w[1][0,u[0].length].downcase==u[0].downcase && count_in(event.message.text.downcase.split(' '),u[0].downcase,1)<=1
  end
  return '-' if w[6]!='Weapon'
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
    w=@skills[@skills.find_index{|q| q[1]==weapon.gsub('Laevatein','Bladeblade')}]
  elsif weapon=='Whelp (All)'
    weapon="Whelp (#{u[3]})"
    weapon="Hatchling (#{u[3]})" if u[3]=='Flier'
    w=@skills[@skills.find_index{|q| q[1]==weapon.gsub('Laevatein','Bladeblade')}]
  elsif weapon=='Yearling (All)'
    weapon="Yearling (#{u[3]})"
    weapon="Fledgling (#{u[3]})" if u[3]=='Flier'
    w=@skills[@skills.find_index{|q| q[1]==weapon.gsub('Laevatein','Bladeblade')}]
  elsif weapon=='Adult (All)'
    weapon="Adult (#{u[3]})"
    w=@skills[@skills.find_index{|q| q[1]==weapon.gsub('Laevatein','Bladeblade')}]
  end
  w2="#{weapon}"
  w2="#{weapon} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  return "~~#{w2}~~" if w[8]!='-' && !w[8].split(', ').include?(u[0]) # prf weapons are illegal on anyone but their holders
  u2=weapon_clss(u[1],event)
  u2='Bow' if u2.include?('Bow')
  u2='Dagger' if u2.include?('Dagger')
  u2="#{u2.gsub('Healer','Staff')} Users Only"
  u2='Dragons Only' if u[1][1]=='Dragon'
  u2="Beasts Only, #{u[3].gsub('Flier','Fliers')} Only" if u[1][1]=='Beast'
  return w2 if u2==w[7]
  return "~~#{w2}~~" if recursion
  if 'Raudr'==w[1][0,5] || 'Blar'==w[1][0,4] || 'Gronn'==w[1][0,5] || 'Keen Raudr'==w[1][0,10] || 'Keen Blar'==w[1][0,9] || 'Keen Gronn'==w[1][0,10]
    return weapon_legality(event,name,weapon.gsub('Blar','Raudr').gsub('Gronn','Raudr'),refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,weapon.gsub('Raudr','Blar').gsub('Gronn','Blar'),refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,weapon.gsub('Raudr','Gronn').gsub('Blar','Gronn'),refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Colorless'
    w2="#{weapon.gsub('Raudr','Hoss').gsub('Blar','Hoss').gsub('Gronn','Hoss')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Ruby Sword','Sapphire Lance','Emerald Axe'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Ruby Sword#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Sapphire Lance#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Emerald Axe#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Hibiscus Tome','Sealife Tome','Tomato Tome'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Tomato Tome#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Sealife Tome#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Hibiscus Tome#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ["Dancer's Ring","Dancer's Score"].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Dancer's Score#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Dancer's Ring#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Red'
    w2="Dancer's Ribbon#{'+' if w[1].include?('+')}"
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
  elsif ["Loyal Wreath"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Raudrblooms#{'+' if w[0].include?('+')}",refinement) if u[1][0]!='Red'
  elsif ["Faithful Axe","Heart's Blade"].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Heart's Blade#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Faithful Axe#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless','Blue'].include?(u[1][0])
    w2="Rod of Bonds#{'+' if w[0].include?('+')}"
    w2="Loving Lance#{'+' if w[0].include?('+')}" if u[1][0]=='Blue'
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Carrot Lance','Carrot Axe'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Carrot Lance#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Carrot Axe#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless','Red'].include?(u[1][0])
    w2="Carrot#{'+' if w[0].include?('+')}...just a carrot#{'+' if w[0].include?('+')}"
    w2="Carrot Sword#{'+' if w[0].include?('+')}" if u[1][0]=='Red'
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Red Egg','Blue Egg','Green Egg','Red Gift','Blue Gift','Green Gift'].include?(w[0].gsub('+',''))
    t='Egg'
    t='Gift' if ['Red Gift','Blue Gift','Green Gift'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Red #{t}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Blue #{t}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Green #{t}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless'].include?(u[1][0])
    w2="Empty #{t}#{'+' if w[0].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Safeguard','Vanguard'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Safeguard#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Vanguard#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return "~~#{w2}~~" unless ['Green'].include?(u[1][0])
    w2="Midguard#{'+' if w[0].include?('+')}"
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
    if b[i][5].nil?
      b[i][5]=[]
    else
      b[i][5]=b[i][5].split(', ')
    end
  end
  b=b.reject{|q| q[2].length==0 && !q[0].include?('GHB') && !q[0].include?('TT')}
  args=event.message.text.downcase.gsub("\n",' ').split(' ')
  lookout=lookout_load('SkillSubsets')
  banner_types=[]
  for i in 0...args.length
    for i2 in 0...lookout.length
      if lookout[i2][1].include?(args[i].downcase)
        banner_types.push(lookout[i2][0]) if lookout[i2][2]=='Banner'
      end
    end
  end
  b2=b.map{|q| q}
  b2=b2.reject{|q| q[5].nil? || !has_any?(q[5],banner_types.reject{|q2| ['Current','Upcoming'].include?(q2)})} if banner_types.reject{|q2| ['Current','Upcoming'].include?(q2)}.length>0
  b2=b.map{|q| q} if b2.length==0
  t=Time.now
  timeshift=8
  timeshift-=1 unless t.dst?
  t-=60*60*timeshift
  tm="#{t.year}#{'0' if t.month<10}#{t.month}#{'0' if t.day<10}#{t.day}".to_i
  b3=b2.map{|q| q}
  b3=b2.reject{|q| q[4].nil? || q[4].split(', ').length<2 || q[4].split(', ')[0].split('/').reverse.join('').to_i>tm || q[4].split(', ')[-1].split('/').reverse.join('').to_i<tm} if banner_types.include?('Current')
  b3=b2.reject{|q| q[4].nil? || q[4].split(', ')[0].split('/').reverse.join('').to_i<=tm} if banner_types.include?('Upcoming')
  b3=b2.reject{|q| q[4].nil? || q[4].split(', ')[-1].split('/').reverse.join('').to_i<tm} if banner_types.include?('Current') && banner_types.include?('Upcoming')
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
  nu=false
  nu=true if bnr[5].include?('NewUnits')
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
    unless u[i][9][0].include?('TD') && nu
      bnr[3].push(u[i][0]) if u[i][9][0].include?('5p') && u[i][13][0].nil?
      bnr[4].push(u[i][0]) if u[i][9][0].include?('4p') && u[i][13][0].nil?
      bnr[5].push(u[i][0]) if u[i][9][0].include?('3p') && u[i][13][0].nil?
      bnr[6].push(u[i][0]) if u[i][9][0].include?('2p') && u[i][13][0].nil?
      bnr[7].push(u[i][0]) if u[i][9][0].include?('1p') && u[i][13][0].nil?
    end
  end
  return bnr
end

def crack_orbs(bot,event,e,user,list) # used by the `summon` command to wait for a reply
  summons=0
  five_star=false
  trucolors=[]
  for i in 1...6
    if list.include?(@units[@units.find_index{|q| q[0]==@banner[i][1]}][1][0])
      e << "Orb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1]}**#{unit_moji(bot,event,-1,@banner[i][1],false,4)} (*#{@banner[i][2]}*)"
      summons+=1
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5:448266417553539104>')
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5p10:448272715099406336>')
    elsif list.include?(i)
      e << "Orb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1]}**#{unit_moji(bot,event,-1,@banner[i][1],false,4)} (*#{@banner[i][2]}*)"
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

def multi_summon(bot,event,e,user,list,str2='',wheel=0,srate=nil)
  srate=@summon_rate.map{|q| q} if srate.nil?
  summons=0
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
  str2="#{str2}\n\n**Wheel ##{wheel}**"
  for i in 1...6
    if trucolors.include?(@units[@units.find_index{|q| q[0]==@banner[i][1]}][1][0])
      str2="#{str2}\nOrb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1]}**#{unit_moji(bot,event,-1,@banner[i][1],false,4)} (*#{@banner[i][2]}*)"
      summons+=1
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5:448266417553539104>')
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5p10:448272715099406336>')
    end
  end
  if summons<=0
    str2="#{str2} - No target colors\nOrb #4 contained a #{@banner[4][0]} **#{@banner[4][1]}**#{unit_moji(bot,event,-1,@banner[4][1],false,4)} (*#{@banner[4][2]}*)"
    summons+=1
    five_star=true if @banner[4][0].include?('5<:Icon_Rarity_5:448266417553539104>')
    five_star=true if @banner[4][0].include?('5<:Icon_Rarity_5p10:448272715099406336>')
  end
  str2="#{str2}\n\nIn this current summoning session, you fired Breidablik #{summons} time#{'s' unless summons==1}, expending #{[0,5,9,13,17,20][summons]} orbs."
  metadata_load()
  srate[0]+=summons
  srate[1]+=[0,5,9,13,17,20][summons]
  str2="#{str2}\nSince the last 5\* summons, Breidablik has been fired #{srate[0]} time#{'s' unless srate[0]==1} and #{srate[1]} orbs have been expended."
  e.respond str2 if safe_to_spam?(e) || five_star
  event.channel.send_temporary_message('Calculating data, please wait...',3) if !safe_to_spam?(e) && wheel==1
  if five_star
    if srate[2]>2
      srate=[0,0,(srate[2]+1)%3+3]
    else
      srate=[0,0,srate[2]]
    end
    metadata_save()
    @banner=[]
  else
    bnr=@banner[6]
    if bnr[1]<0 # negative "starting focus" numbers indicate there is no non-focus rate
      sr=(srate[0]/5)*0.5
      sr=100.00 + bnr[1] if srate[0]>=120 && srate[2]%3==2
      b= 0 - bnr[1]
      focus = b + sr
      five_star = 0.00
      if srate[0]>=120 && srate[2]%3==1
        focus = 50.00
        five_star = 50.00
      end
      four_star = (100.00 - focus - five_star) * 58.00 / (100.00 - b)
      three_star = 100.00 - focus - five_star - four_star
      two_star = 0
      one_star = 0
    else
      sr=(srate[0]/5)*0.5
      sr=97.00 - bnr[1] if srate[0]>=120 && srate[2]%3==2
      focus = bnr[1] + sr * bnr[1] / (bnr[1] + 3.00)
      five_star = 3.00 + sr * 3.00 / (bnr[1] + 3.00)
      if srate[0]>=120 && srate[2]%3==1
        focus = 50.00
        five_star = 50.00
      end
      four_star = (100.00 - focus - five_star) * 58.00 / (100.00 - bnr[1] - 3)
      three_star = 100.00 - focus - five_star - four_star
      two_star = 0
      one_star = 0
    end
    five_star=0 if focus>=100
    four_star=0 if focus+five_star>=100
    three_star=0 if focus+five_star+four_star>=100
    two_star=0 if focus+five_star+four_star+three_star>=100
    one_star=0 if focus+five_star+four_star+three_star+two_star>=100
    fakes=false
    fakes=true if srate[0]>=120 && srate[2]%3==0
    str2="**Summon rates:**"
    str2="#{str2}\n5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % focus}%"
    str2="#{str2}\nOther 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % five_star}%" unless five_star<=0
    n=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res','+Def -HP',
       '+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral']
    n=['Neutral'] if bnr[0][0]=='TT Units' || bnr[0][0]=='GHB Units'
    if fakes
      if bnr[8].nil?
        str2="#{str2}\n~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % four_star}%" unless four_star<=0
      elsif four_star>0
        str2="#{str2}\n~~4\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (four_star/2)}%"
        str2="#{str2}\nOther ~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (four_star/2)}%"
      end
      if bnr[9].nil?
        str2="#{str2}\n~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % three_star}%" unless three_star<=0
      elsif three_star>0
        str2="#{str2}\n~~3\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (three_star/2)}%"
        str2="#{str2}\nOther ~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (three_star/2)}%"
      end
      if bnr[10].nil?
        str2="#{str2}\n~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % two_star}%" unless two_star<=0
      elsif two_star>0
        str2="#{str2}\n~~2\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (two_star/2)}%"
        str2="#{str2}\nOther ~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (two_star/2)}%"
      end
      if bnr[11].nil?
        str2="#{str2}\n~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % one_star}%" unless one_star<=0
      elsif two_star>0
        str2="#{str2}\n~~1\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (one_star/2)}%"
        str2="#{str2}\nOther ~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (one_star/2)}%"
      end
    else
      if bnr[8].nil?
        str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Unit:  #{'%.2f' % four_star}%" unless four_star<=0
      elsif four_star>0
        str2="#{str2}\n4<:Icon_Rarity_4p10:448272714210476033> Focus:  #{'%.2f' % (four_star/2)}%"
        str2="#{str2}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % (four_star/2)}%"
      end
      if bnr[9].nil?
        str2="#{str2}\n3<:Icon_Rarity_3:448266417934958592> Unit:  #{'%.2f' % three_star}%" unless three_star<=0
      elsif three_star>0
        str2="#{str2}\n3<:Icon_Rarity_3p10:448294378293952513> Focus:  #{'%.2f' % (three_star/2)}%"
        str2="#{str2}\nOther 3<:Icon_Rarity_3:448266417934958592>:  #{'%.2f' % (three_star/2)}%"
      end
      if bnr[10].nil?
        str2="#{str2}\n2<:Icon_Rarity_2:448266417872044032> Unit:  #{'%.2f' % two_star}%" unless two_star<=0
      elsif two_star>0
        str2="#{str2}\n2<:Icon_Rarity_2p10:448294378205872130> Focus:  #{'%.2f' % (two_star/2)}%"
        str2="#{str2}\nOther 2<:Icon_Rarity_2:448266417872044032>:  #{'%.2f' % (two_star/2)}%"
      end
      if bnr[11].nil?
        str2="#{str2}\n1<:Icon_Rarity_1:448266417481973781> Unit:  #{'%.2f' % one_star}%" unless one_star<=0
      elsif two_star>0
        str2="#{str2}\n1<:Icon_Rarity_1p10:448294377878716417> Focus:  #{'%.2f' % (one_star/2)}%"
        str2="#{str2}\nOther 1<:Icon_Rarity_1:448266417481973781>:  #{'%.2f' % (one_star/2)}%"
      end
    end
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
        rx='~~4\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if srate[0]>=120 && srate[2]%3==0
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100
        hx=bnr[4].sample
        rx='4<:Icon_Rarity_4:448266418459377684>'
        rx='~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if srate[0]>=120 && srate[2]%3==0
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      elsif !bnr[9].nil? && k<focus*100+five_star*100+four_star*100+three_star*50
        hx=bnr[9].sample
        rx='3<:Icon_Rarity_3p10:448294378293952513>'
        rx='~~3\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if srate[0]>=120 && srate[2]%3==0
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100+three_star*100
        hx=bnr[5].sample
        rx='3<:Icon_Rarity_3:448266417934958592>'
        rx='~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if srate[0]>=120 && srate[2]%3==0
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      elsif !bnr[10].nil? && k<focus*100+five_star*100+four_star*100+three_star*100+two_star*50
        hx=bnr[10].sample
        rx='2<:Icon_Rarity_2p10:448294378205872130>'
        rx='~~2\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if srate[0]>=120 && srate[2]%3==0
        nr=n.sample
      elsif k<focus*100+five_star*100+four_star*100+three_star*100+two_star*100
        hx=bnr[6].sample
        rx='2<:Icon_Rarity_2:448266417872044032>'
        rx='~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if srate[0]>=120 && srate[2]%3==0
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      elsif !bnr[11].nil? && k<focus*100+five_star*100+four_star*100+three_star*100+two_star*100+one_star*50
        hx=bnr[11].sample
        rx='1<:Icon_Rarity_1p10:448294377878716417>'
        rx='~~1\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if srate[0]>=120 && srate[2]%3==0
        nr=n.sample
      else
        hx=bnr[7].sample
        rx='1<:Icon_Rarity_1:448266417481973781>'
        rx='~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>' if srate[0]>=120 && srate[2]%3==0
        nr=['+HP -Atk','+HP -Spd','+HP -Def','+HP -Res','+Atk -HP','+Atk -Spd','+Atk -Def','+Atk -Res','+Spd -HP','+Spd -Atk','+Spd -Def','+Spd -Res',
            '+Def -HP','+Def -Atk','+Def -Spd','+Def -Res','+Res -HP','+Res -Atk','+Res -Spd','+Res -Def','Neutral'].sample
      end
      @banner[i]=[rx,hx,nr]
    end
    multi_summon(bot,event,e,user,list,str2,wheel,srate)
  end
end

def summon_sim(bot,event,colors)
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
      str="#{str}\n*Real world run:* #{b[0][0]} #{m[b[0][1].to_i]} #{b[0][2]} - #{b[1][0]} #{m[b[1][1].to_i]} #{b[1][2]}" if b.length>1
      str="#{str}\n*Real world run:* #{b[0][0]} #{m[b[0][1].to_i]} #{b[0][2]} - >Unknown<" unless b.length>1
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
    str="#{str}\n<:Orb_Gold:549338084102111250> *Gold*:  #{k[4].join(', ')}" if k[4].length>0
    str2="**Summon rates:**"
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
    five_star=0 if focus>=100
    four_star=0 if focus+five_star>=100
    three_star=0 if focus+five_star+four_star>=100
    two_star=0 if focus+five_star+four_star+three_star>=100
    one_star=0 if focus+five_star+four_star+three_star+two_star>=100
    fakes=false
    fakes=true if @summon_rate[0]>=120 && @summon_rate[2]%3==0
    str2="#{str2}\n5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % focus}%"
    str2="#{str2}\nOther 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % five_star}%" unless five_star<=0
    if fakes
      if bnr[8].nil?
        str2="#{str2}\n~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % four_star}%" unless four_star<=0
      elsif four_star>0
        str2="#{str2}\n~~4\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (four_star/2)}%"
        str2="#{str2}\nOther ~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (four_star/2)}%"
      end
      if bnr[9].nil?
        str2="#{str2}\n~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % three_star}%" unless three_star<=0
      elsif three_star>0
        str2="#{str2}\n~~3\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (three_star/2)}%"
        str2="#{str2}\nOther ~~3\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (three_star/2)}%"
      end
      if bnr[10].nil?
        str2="#{str2}\n~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % two_star}%" unless two_star<=0
      elsif two_star>0
        str2="#{str2}\n~~2\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (two_star/2)}%"
        str2="#{str2}\nOther ~~2\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (two_star/2)}%"
      end
      if bnr[11].nil?
        str2="#{str2}\n~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % one_star}%" unless one_star<=0
      elsif two_star>0
        str2="#{str2}\n~~1\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (one_star/2)}%"
        str2="#{str2}\nOther ~~1\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (one_star/2)}%"
      end
    else
      if bnr[8].nil?
        str2="#{str2}\n4<:Icon_Rarity_4:448266418459377684> Unit:  #{'%.2f' % four_star}%" unless four_star<=0
      elsif four_star>0
        str2="#{str2}\n4<:Icon_Rarity_4p10:448272714210476033> Focus:  #{'%.2f' % (four_star/2)}%"
        str2="#{str2}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % (four_star/2)}%"
      end
      if bnr[9].nil?
        str2="#{str2}\n3<:Icon_Rarity_3:448266417934958592> Unit:  #{'%.2f' % three_star}%" unless three_star<=0
      elsif three_star>0
        str2="#{str2}\n3<:Icon_Rarity_3p10:448294378293952513> Focus:  #{'%.2f' % (three_star/2)}%"
        str2="#{str2}\nOther 3<:Icon_Rarity_3:448266417934958592>:  #{'%.2f' % (three_star/2)}%"
      end
      if bnr[10].nil?
        str2="#{str2}\n2<:Icon_Rarity_2:448266417872044032> Unit:  #{'%.2f' % two_star}%" unless two_star<=0
      elsif two_star>0
        str2="#{str2}\n2<:Icon_Rarity_2p10:448294378205872130> Focus:  #{'%.2f' % (two_star/2)}%"
        str2="#{str2}\nOther 2<:Icon_Rarity_2:448266417872044032>:  #{'%.2f' % (two_star/2)}%"
      end
      if bnr[11].nil?
        str2="#{str2}\n1<:Icon_Rarity_1:448266417481973781> Unit:  #{'%.2f' % one_star}%" unless one_star<=0
      elsif two_star>0
        str2="#{str2}\n1<:Icon_Rarity_1p10:448294377878716417> Focus:  #{'%.2f' % (one_star/2)}%"
        str2="#{str2}\nOther 1<:Icon_Rarity_1:448266417481973781>:  #{'%.2f' % (one_star/2)}%"
      end
    end
    str=extend_message(str,str2,event,2)
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
      str2="**Orb options:**"
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
          cracked_orbs.push([@banner[i],i]) if trucolors.include?(find_unit(@banner[i][1],event)[1][0])
        end
        str2="#{str2}\nNone of the colors you requested appeared.  Here are your **Orb options:**" if cracked_orbs.length.zero?
      else
        str2="#{str2}\n**Orb options:**"
      end
    end
    if cracked_orbs.length>0
      summons=0
      five_star=false
      str2="**Summoning Results:**"
      for i in 0...cracked_orbs.length
        str2="#{str2}\nOrb ##{cracked_orbs[i][1]} contained a #{cracked_orbs[i][0][0]} **#{cracked_orbs[i][0][1]}**#{unit_moji(bot,event,-1,cracked_orbs[i][0][1],false,4)} (*#{cracked_orbs[i][0][2]}*)"
        summons+=1
        five_star=true if cracked_orbs[i][0][0].include?('5<:Icon_Rarity_5:448266417553539104>')
        five_star=true if cracked_orbs[i][0][0].include?('5<:Icon_Rarity_5p10:448272715099406336>')
      end
      str=extend_message(str,str2,event,2)
      str2="In this current summoning session, you fired Breidablik #{summons} time#{'s' unless summons==1}, expending #{[0,5,9,13,17,20][summons]} orbs."
      metadata_load()
      @summon_rate[0]+=summons
      @summon_rate[1]+=[0,5,9,13,17,20][summons]
      str2="#{str2}\nSince the last 5\* summons, Breidablik has been fired #{@summon_rate[0]} time#{"s" unless @summon_rate[0]==1} and #{@summon_rate[1]} orbs have been expended."
      str=extend_message(str,str2,event,2)
      event.respond str
      if @summon_rate[2]>2
        @summon_rate=[0,0,(@summon_rate[2]+1)%3+3] if five_star
      else
        @summon_rate=[0,0,@summon_rate[2]] if five_star
      end
      metadata_save()
      @banner=[]
    else
      str2=''
      for i in 1...@banner.length
        k=untz[untz.find_index{|q| q[0]==@banner[i][1]}][1][0]
        str2="#{str2}\n#{i}.) <:Orb_Red:455053002256941056> *Red*" if k=='Red'
        str2="#{str2}\n#{i}.) <:Orb_Blue:455053001971859477> *Blue*" if k=='Blue'
        str2="#{str2}\n#{i}.) <:Orb_Green:455053002311467048> *Green*" if k=='Green'
        str2="#{str2}\n#{i}.) <:Orb_Colorless:455053002152083457> *Colorless*" if k=='Colorless'
        str2="#{str2}\n#{i}.) <:Orb_Gold:549338084102111250> *Gold*" unless ['Red','Blue','Green','Colorless'].include?(k)
      end
      str=extend_message(str,str2,event)
      str2="To open orbs, please respond - in a single message - with the number of each orb you want to crack, or the colors of those orbs."
      str2="#{str2}\nYou can also just say \"Summon all\" to open all orbs."
      str2="#{str2}\nInclude the word \"Multisummon\" (with optional colors) to continue summoning until you pull a 5<:Icon_Rarity_5:448266417553539104>."
      str=extend_message(str,str2,event,2)
      event.respond str
      @banner.push(bnr)
      trucolors=[]
      trucolors2=[]
      for i in 1...6
        m=@units[@units.find_index{|q| q[0]==@banner[i][1]}][1][0]
        trucolors.push(['Red',['red','reds']]) if m=='Red'
        trucolors2.push(['Red',['red','reds']])
        trucolors.push(['Blue',['blue','blues']]) if m=='Blue'
        trucolors2.push(['Blue',['blue','blues']])
        trucolors.push(['Green',['green','greens']]) if m=='Green'
        trucolors2.push(['Green',['green','greens']])
        trucolors.push(['Colorless',['colorless','colourless','clear','clears','grey','greys','gray','grays']]) if m=='Colorless'
        trucolors2.push(['Colorless',['colorless','colourless','clear','clears','grey','greys','gray','grays']])
      end
      event.channel.await(:bob, from: event.user.id) do |e|
        if @banner[0].nil?
        elsif e.user.id == @banner[0][0] && e.message.text.downcase.split(' ').include?('multisummon')
          l=[]
          for i in 0...trucolors2.length
            l.push(trucolors2[i][0]) if has_any?(trucolors2[i][1],e.message.text.downcase.split(' '))
          end
          multi_summon(bot,event,e,e.user.id,l,'',0)
        elsif e.user.id == @banner[0][0] && e.message.text.downcase.include?('summon all')
          crack_orbs(bot,event,e,e.user.id,[1,2,3,4,5])
        elsif e.user.id == @banner[0][0] && (e.message.text =~ /1|2|3|4|5/ || has_any?(trucolors.map{|q| q[1]}.join(' ').split(' '),e.message.text.downcase.split(' ')))
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
    end
  end
  return nil
end

def shard_data(mode=0,ignoredebug=false,s=nil)
  s=@shards*1 if s.nil?
  if mode==0 # shard icons + names
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant','<:Shard_Gold:443733396913520640> Golden'] if s<=4
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant','<:Shard_Gold:443733396913520640> Golden','<:Shard_Cyan:552681863995588628> Sky'] if s==5
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant','<:Shard_Gold:443733396913520640> Golden','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Cyan:552681863995588628> Sky'] if s==6
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant','<:Shard_Gold:443733396913520640> Golden','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Purple:443733396401946625> Violet'] if s==7
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet'] if s==8
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s==9
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Pink:554109520906027018> Bubblegum','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s==10
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Black:554090555932540941> Onyx','<:Shard_Pink:554109520906027018> Bubblegum','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s==11
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Black:554090555932540941> Onyx','<:Shard_Grey:554090554963525639> Steel','<:Shard_Pink:554109520906027018> Bubblegum','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s==12
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Black:554090555932540941> Onyx','<:Shard_Grey:554090554963525639> Steel','<:Shard_Platinum:554109521182588957> Platinum','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Pink:554109520906027018> Bubblegum','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s>=13
    if k.length<s
      k2=['<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta']
      i=2
      while k.length<s+1
        k3=k2.map{|q| "#{q}#{i}"}
        for j in 0...k3.length
          k.push(k3[j])
        end
        i+=1
      end
    end
  elsif mode==1 # shard icons, no names
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Red:443733396842348545>','<:Shard_Blue:443733396741554181>','<:Shard_Green:443733397190344714>','<:Shard_Gold:443733396913520640>'] if s<=4
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Red:443733396842348545>','<:Shard_Blue:443733396741554181>','<:Shard_Green:443733397190344714>','<:Shard_Gold:443733396913520640>','<:Shard_Cyan:552681863995588628>'] if s==5
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Red:443733396842348545>','<:Shard_Blue:443733396741554181>','<:Shard_Green:443733397190344714>','<:Shard_Gold:443733396913520640>','<:Shard_Orange:552681863962165258>','<:Shard_Cyan:552681863995588628>'] if s==6
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Red:443733396842348545>','<:Shard_Blue:443733396741554181>','<:Shard_Green:443733397190344714>','<:Shard_Gold:443733396913520640>','<:Shard_Orange:552681863962165258>','<:Shard_Cyan:552681863995588628>','<:Shard_Purple:443733396401946625>'] if s==7
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Rot8er:443733397223768084>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>'] if s==8
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Rot8er:443733397223768084>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s==9
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Pink:554109520906027018>','<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Rot8er:443733397223768084>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s==10
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Black:554090555932540941>','<:Shard_Pink:554109520906027018>','<:Shard_Red:443733396842348545>','<:Shard_Rot8er:443733397223768084>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s==11
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Black:554090555932540941>','<:Shard_Grey:554090554963525639>','<:Shard_Pink:554109520906027018>','<:Shard_Rot8er:443733397223768084>','<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s==12
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Black:554090555932540941>','<:Shard_Grey:554090554963525639>','<:Shard_Platinum:554109521182588957>','<:Shard_Rot8er:443733397223768084>','<:Shard_Pink:554109520906027018>','<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s>=13
    if k.length<s
      k2=['<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>']
      i=2
      while k.length<s+1
        k3=k2.map{|q| "#{q}*#{i}*"}
        for j in 0...k3.length
          k.push(k3[j])
        end
        i+=1
      end
    end
  elsif mode==2 # shard names, no icons
    k=['Transparent','Scarlet','Azure','Verdant','Golden'] if s<=4
    k=['Transparent','Scarlet','Azure','Verdant','Golden','Sky'] if s==5
    k=['Transparent','Scarlet','Azure','Verdant','Golden','Citrus','Sky'] if s==6
    k=['Transparent','Scarlet','Azure','Verdant','Golden','Citrus','Sky','Violet'] if s==7
    k=['Transparent','Scarlet','Citrus','Golden','Hybrid','Verdant','Sky','Azure','Violet'] if s==8
    k=['Transparent','Scarlet','Citrus','Golden','Hybrid','Verdant','Sky','Azure','Violet','Magenta'] if s==9
    k=['Transparent','Bubblegum','Scarlet','Citrus','Hybrid','Golden','Verdant','Sky','Azure','Violet','Magenta'] if s==10
    k=['Transparent','Onyx','Bubblegum','Scarlet','Hybrid','Citrus','Golden','Verdant','Sky','Azure','Violet','Magenta'] if s==11
    k=['Transparent','Onyx','Steel','Bubblegum','Hybrid','Scarlet','Citrus','Golden','Verdant','Sky','Azure','Violet','Magenta'] if s==12
    k=['Transparent','Onyx','Steel','Platinum','Hybrid','Bubblegum','Scarlet','Citrus','Golden','Verdant','Sky','Azure','Violet','Magenta'] if s>=13
    if k.length<s
      k2=['Scarlet','Citrus','Golden','Verdant','Sky','Azure','Violet','Magenta']
      i=2
      while k.length<s+1
        k3=k2.map{|q| "#{q}#{i}"}
        for j in 0...k3.length
          k.push(k3[j])
        end
        i+=1
      end
    end
  elsif mode==3 # bright command prompt text color
    k=['0','4','1','2','6'] if s<=4
    k=['0','4','1','2','6','9'] if s==5
    k=['0','4','1','2','6','C','9'] if s==6
    k=['0','4','1','2','6','C','9','5'] if s==7
    k=['0','4','C','6','0','2','9','1','5'] if s==8
    k=['0','4','C','6','0','2','9','1','5','5'] if s==9
    k=['0','5','4','C','0','6','2','9','1','5','5'] if s==10
    k=['0','0','5','4','0','C','6','2','9','1','5','5'] if s==11
    k=['0','0','8','5','0','4','C','6','2','9','1','5','5'] if s==12
    k=['0','0','8','8','0','5','4','C','6','2','9','1','5','5'] if s>=13
    if k.length<s
      k2=['C','6','8','A','B','9','5','D']
      i=2
      while k.length<s+1
        for j in 0...k2.length
          k.push(k2[j])
        end
        i+=1
      end
    end
  elsif mode==4 # dark command prompt text color
    k=['7','C','B','A','E'] if s<=4
    k=['7','C','B','A','E','B'] if s==5
    k=['7','C','B','A','E','D','B'] if s==6
    k=['7','C','B','A','E','D','B','5'] if s==7
    k=['7','C','6','E','8','A','B','9','5'] if s==8
    k=['7','C','6','E','8','A','B','9','5','D'] if s==9
    k=['7','D','C','E','6','8','A','B','9','5','D'] if s==10
    k=['7','F','D','E','C','6','8','A','B','9','5','D'] if s==11
    k=['7','F','7','E','D','C','6','8','A','B','9','5','D'] if s==12
    k=['7','F','8','E','7','D','C','6','8','A','B','9','5','D'] if s>=13
    if k.length<s
      k2=['C','6','8','A','B','9','5','D']
      i=2
      while k.length<s+1
        for j in 0...k2.length
          k.push(k2[j])
        end
        i+=1
      end
    end
  end
  if ignoredebug
    k[4]=nil
    k.compact!
  end
  return k.join('') if mode>2
  return k
end

def combined_BST(event,args,bot)
  event.channel.send_temporary_message('Parsing message, please wait...',8)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  s1=args.join(' ').gsub(',','').gsub('/','').downcase
  s2=args.join(' ').gsub(',','').gsub('/','')
  if s1.include?('|')
    k=[]
    f=s1.gsub(' |','|').gsub('| ','|').split('|')
    for i in 0...f.length
      x=detect_multi_unit_alias(event,f[i],f[i],1)
      if !x.nil? && x[1].length>1
        r=find_stats_in_string(event,f[i])
        k.push("#{r[0]}*#{x[0]}+#{r[1]}#{"+#{r[2]}" if r[2].length>0}#{"-#{r[3]}" if r[3].length>0}")
      elsif find_data_ex(:find_unit,f[i],event).length>0
        name=find_data_ex(:find_unit,f[i],event)
        r=find_stats_in_string(event,f[i])
        u=find_unit(name[0],event)
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
        k=find_data_ex(:find_unit,s1,event,false,1)
        unless k.length<=0
          if k[0].is_a?(Array)
            if k[0][0].is_a?(Array)
              k[0]=k[0].map{|q| q[0]}
            else
              k[0]=k[0][0]
            end
          end
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
  counters=[['Infantry', 0, 0],
            ['Horse', 0, 0],
            ['Armor', 0, 0],
            ['Flier', 0, 0],
            ['Magic', 0, 0],
            ['Dragon', 0, 0],
            ['Melee', 0, 0],
            ['Healer', 0, 0],
            ['Dagger', 0, 0],
            ['Archer', 0, 0],
            ['Beast', 0, 0],
            ['Red', 0, 0],
            ['Blue', 0, 0],
            ['Green', 0, 0],
            ['Colorless', 0, 0],
            [['', 'F2P', 'F2P'], 0, 0],
            ['Story', 0, 0],
            ['GHB', 0, 0],
            ['Tempest', 0, 0],
            ['Yandere', 0, 0, ['Valter', 'Tharja', 'Rhajat', 'Camilla', 'Faye', 'Tharja(Winter)', 'Tharja(Bride)']],
            ['Lucina', 0, 0, ['Lucina', 'Lucina(Bunny)', 'Marth(Masked)', 'Lucina(Brave)', 'Lucina(Glorious)']],
            ['Marth', 0, 0, ['Marth', 'Marth(Groom)', 'Marth(Masked)']],
            ['Robin', 0, 0, ['Robin(M)', 'Robin(F)', 'Robin(F)(Summer)', 'Robin(M)(Winter)', 'Robin(M)(Fallen)', 'Robin(F)(Fallen)', 'Tobin']],
            ['Corrin', 0, 0, ['Corrin(M)(Launch)', 'Corrin(F)(Launch)', 'Corrin(F)(Summer)', 'Corrin(M)(Winter)', 'Corrin(M)(Adrift)', 'Corrin(F)(Adrift)', 'Kamui']],
            ['Xander', 0, 0, ['Xander', 'Xander(Bunny)', 'Xander(Summer)', 'Xander(Festival)']],
            ['Tiki', 0, 0, ['Tiki(Young)', 'Tiki(Adult)', 'Tiki(Adult)(Summer)', 'Tiki(Young)(Summer)', 'Tiki(Young)(Earth)']],
            ['Lyn', 0, 0, ['Lyn', 'Lyn(Bride)', 'Lyn(Brave)', 'Lyn(Valentines)', 'Lyn(Wind)']],
            ['Chrom', 0, 0, ['Chrom(Launch)', 'Chrom(Bunny)', 'Chrom(Winter)', 'Chrom(Branded)']],
            ['Azura', 0, 0, ['Azura', 'Azura(Performing)', 'Azura(Winter)', 'Azura(Adrift)', 'Azura(Vallite)']],
            ['Camilla', 0, 0, ['Camilla', 'Camilla(Bunny)', 'Camilla(Winter)', 'Camilla(Summer)', 'Camilla(Adrift)', 'Camilla(Bath)']],
            ['Ike', 0, 0, ['Ike', 'Ike(Vanguard)', 'Ike(Brave)']],
            ['Roy', 0, 0, ['Roy', 'Roy(Valentines)', 'Roy(Brave)']],
            ['Hector', 0, 0, ['Hector', 'Hector(Valentines)', 'Hector(Marquess)', 'Hector(Brave)']],
            ['Celica', 0, 0, ['Celica', 'Celica(Fallen)', 'Celica(Brave)']],
            ['Takumi', 0, 0, ['Takumi', 'Takumi(Fallen)', 'Takumi(Winter)', 'Takumi(Summer)']],
            ['Ephraim', 0, 0, ['Ephraim', 'Ephraim(Fire)', 'Ephraim(Brave)', 'Ephraim(Winter)']],
            ['Tharja', 0, 0, ['Tharja', 'Tharja(Winter)', 'Tharja(Bride)', 'Rhajat']],
            ['Cordelia', 0, 0, ['Cordelia', 'Cordelia(Bride)', 'Cordelia(Summer)', 'Caeldori']],
            ['Olivia', 0, 0, ['Olivia(Launch)', 'Olivia(Performing)', 'Olivia(Traveler)']],
            ['Ryoma', 0, 0, ['Ryoma', 'Ryoma(Supreme)', 'Ryoma(Festival)', 'Ryoma(Bath)']],
            ['Marth', 0, 0, ['Marth', 'Marth(Masked)', 'Marth(Groom)', 'Marth(King)']],
            ['Eirika', 0, 0, ['Eirika(Bonds)', 'Eirika(Memories)', 'Eirika(Graceful)', 'Eirika(Winter)']],
            ['Sakura', 0, 0, ['Sakura', 'Sakura(Halloween)', 'Sakura(Bath)']],
            ['Elise', 0, 0, ['Elise', 'Elise(Summer)', 'Elise(Bath)']],
            ['Hinoka', 0, 0, ['Hinoka(Launch)', 'Hinoka(Wings)', 'Hinoka(Bath)']],
            ['Veronica', 0, 0, ['Veronica', 'Veronica(Brave)', 'Veronica(Bunny)']],
            ['Leo', 0, 0, ['Leo', 'Leo(Summer)', 'Leo(Picnic)']]]
  colors=[[],[0,0,0,0,0],[0,0,0,0,0]]
  braves=[[],[0,0,0,0,0],[0,0,0,0,0]]
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
          name=find_unit(find_data_ex(:find_unit,x[1][0],event),event)[0]
          summon_type=find_unit(find_data_ex(:find_unit,x[1][0],event),event)[9][0].downcase
        end
      else
        au+=1
        msg=extend_message(msg,"Ambiguous Unit #{au}: #{x[0]} - #{list_lift(x[1].map{|q| "#{q}#{unit_moji(bot,event,-1,q)}"},'or')}",event)
      end
    elsif find_data_ex(:find_unit,sever(k[i]),event).length>0
      mxx=find_data_ex(:find_unit,sever(k[i]),event)
      name=mxx[0]
      summon_type=mxx[9][0].downcase
    elsif !x.nil? && !x[1].is_a?(Array)
      mxx=find_data_ex(:find_unit,x[1],event)
      name=mxx[0]
      summon_type=mxx[9][0].downcase
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
      j=find_unit(name,event)
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
          counters[10][i2]+=1 if j[1][1]=='Beast'
          counters[11][i2]+=1 if j[1][0]=='Red'
          counters[12][i2]+=1 if j[1][0]=='Blue'
          counters[13][i2]+=1 if j[1][0]=='Green'
          counters[14][i2]+=1 if j[1][0]=='Colorless'
          if ['',' '].include?(r[2]) && ['',' '].include?(r[3])
            counters[15][i2]+=1 if summon_type.include?('y') || summon_type.include?('g') || summon_type.include?('t') || summon_type.include?('d') || summon_type.include?('f')
            braves[i2][0]+=1 if ['Ike(Brave)','Lucina(Brave)','Lyn(Brave)','Roy(Brave)'].include?(name)
            braves[i2][1]+=1 if ['Celica(Brave)','Ephraim(Brave)','Hector(Brave)','Veronica(Brave)'].include?(name)
            braves[i2][2]+=1 if ['Micaiah(Brave)','Camilla(Brave)','Alm(Brave)','Eliwood(Brave)'].include?(name)
          end
          counters[16][i2]+=1 if [summon_type].include?('y')
          counters[17][i2]+=1 if [summon_type].include?('g')
          counters[18][i2]+=1 if [summon_type].include?('t')
          if counters.length>19
            for i3 in 19...counters.length
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
      bane2="#{r[3]}"
      bane2='' if r[1]>0
      st=get_stats(event,name,40,5,0,r[2],bane2)
      bb=0
      bb=3 if ['',' ',nil].include?(r[2]) && r[1]>0
      scr.push(((st[1]+st[2]+st[3]+st[4]+st[5]+bb)/5)+r[0]*5+r[1]*2+90)
      rstar=@rarity_stars[r[0]-1]
      rstar=['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>','<:Icon_Rarity_4p10:448272714210476033>','<:Icon_Rarity_5p10:448272715099406336>','<:Icon_Rarity_6p10:491487784822112256>'][r[0]-1] if r[1]>=10
      rstar='<:Icon_Rarity_S:448266418035621888>' unless sup=='-'
      rstar='<:Icon_Rarity_Sp10:448272715653054485>' if sup != '-' && r[1]>=10
      msg=extend_message(msg,"Unit #{u}: #{r[0]}#{rstar} #{name}#{unit_moji(bot,event,-1,name,m)} +#{r[1]} #{"(+#{r[2]}, -#{r[3]})" if !['',' '].include?(r[2]) || !['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}  \u200B  \u200B  BST: #{b[b.length-1]}  \u200B  \u200B  Score: #{scr[scr.length-1]}+`SP`/100",event)
    end
  end
  event.channel.send_temporary_message("#{event.user.mention} Units found, calculating BST and arena score...",8)
  if braves[1].max==1
    counters[15][1]+=braves[1][1]+braves[1][0]
    counters[15][0][1]='Pseudo-F2P'
  end
  if braves[2].max==1
    counters[15][2]+=braves[2][1]+braves[2][0]
    counters[15][0][2]='Pseudo-F2P'
  end
  event << ''
  emblem_name=['','','']
  for i in 0...counters.length
    cname=counters[i][0]
    for i2 in 1...3
      cname=counters[i][0][i2] if i==15 # F2P marker
      if counters[i][i2]>=[[i2*4,k.length].min,2].max
        if emblem_name[i2].length>0 && i>3 && i<10 && emblem_name[i2].split(' ').length<=2
          emblem_name[i2]="#{cname} #{emblem_name[i2]}"
        elsif emblem_name[i2].length>0 && i>9 && i<15 && emblem_name[i2].split(' ').length<=3
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
    event.respond 'No units listed'
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
