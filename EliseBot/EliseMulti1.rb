def unit_into_multi(name,args3)
  if name.include?('(M)') || name.include?('(F)')
    if args3.length==1 || !['(','m','f'].include?(args3[1][0,1].downcase)
      if ['robin','reflet','daraen'].include?(args3[0].downcase)
        name='Robin'
      elsif ['morgan','marc','linfan'].include?(args3[0].downcase)
        name='Morgan'
      elsif ['kana','kanna'].include?(args3[0].downcase)
        name='Kana'
      elsif ['corrin','kamui','corrinlaunch','kamuilaunch','launchcorrin','launchkamui','corrindefault','kamuidefault','defaultcorrin','defaultkamui','corrinvanilla','kamuivanilla','vanillacorrin','vanillakamui','corrinog','kamuiog','ogcorrin','ogkamui'].include?(args3[0].gsub('(','').gsub(')','').downcase)
        name='Corrin'
      elsif ['corrinadrift','kamuiadrift','adriftcorrin','adriftkamui','corrindreaming','kamuidreaming','dreamingcorrin','dreamingkamui','corrindreamer','kamuidreamer','dreamercorrin','dreamerkamui','corrindreams','kamuidreams','dreamscorrin','dreamskamui','corrindream','kamuidream','dreamcorrin','dreamkamui','corrinfauxzura','kamuifauxzura','fauxzuracorrin','fauxzurakamui','corrinfauxura','kamuifauxura','fauxuracorrin','fauxurakamui'].include?(args3[0].gsub('(','').gsub(')','').downcase)
        name='CorrinAdrift'
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
  elsif name=='Camilla(Launch)' || name=='Camilla(Adrift)'
    if args3.length==1
      if ['camilla'].include?(args3[0].downcase)
        name='Camilla'
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
  nicknames_load()
  for i in 0...@multi_aliases.length
    m=@multi_aliases[i][1].map{|q| q}
    m=['Robin'] if (m==['Robin(M)', 'Robin(F)'] || m==['Robin(F)', 'Robin(M)']) && robinmode != 1
    return [str1, m, @multi_aliases[i][0].downcase] if @multi_aliases[i][0].downcase==str1
  end
  return ['laevatein', ['Lavatain'], 'laevatein'] if /laevatein/ =~ str1
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
    return [str1, [@aliases[i][2]], @aliases[i][1].downcase] if @aliases[0]=='Unit' && @aliases[i][1].downcase==str1 && (@aliases[i][3].nil? || @aliases[i][3].include?(k))
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
  elsif /(camil(|l)a|kamira)/ =~ str1
    str='camilla'
    str='camila' if str2.include?('camila')
    str='kamira' if str2.include?('kamira')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch')
      return [str,['Camilla(Launch)'],["vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","launch#{str}","#{str}launch"]]
    elsif str2.include?('bunny') || str2.include?('spring') || str2.include?('easter') || str2.include?('sf')
      return [str,['Camilla(Spring)'],["bunny#{str}","#{str}bunny","spring#{str}","#{str}spring","easter#{str}","#{str}easter","sf#{str}","#{str}sf"]]
    elsif str2.include?('winter') || str2.include?('newyear') || str2.include?('holiday') || str2.include?('ny')
      return [str,['Camilla(Winter)'],["winter#{str}","#{str}winter","newyear#{str}","#{str}newyear","holiday#{str}","#{str}holiday","ny#{str}","#{str}ny"]]
    elsif str2.include?('adrift') || str2.include?('dream') || str2.include?('valla') || str2.include?('vallite') || str2.include?('dreamy') || str2.include?('dreamer') || str2.include?('dreaming') || str2.include?('dreams') || str2.include?('fauxzura') || str2.include?('fauxura') || str2.include?('revelation') || str2.include?('rev') || str2.include?('sleepy') || str2.include?('sleep')
      return [str,['Camilla(Adrift)'],["adrift#{str}","#{str}adrift","dream#{str}","#{str}dream","valla#{str}","#{str}valla","vallite#{str}","#{str}vallite","dreamy#{str}","#{str}dreamy","dreamer#{str}","#{str}dreamer","dreaming#{str}","#{str}dreaming","dreams#{str}","#{str}dreams","fauxzura#{str}","#{str}fauxzura","fauxura#{str}","#{str}fauxura","revelation#{str}","#{str}revelation","revelations#{str}","#{str}revelations","rev#{str}","#{str}rev","#{str}sleepy","#{str}sleep","sleepy#{str}","sleep#{str}"]]
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
    if str2.include?('legendary') || str2.include?('legend') || str2.include?('graceful') || str2.include?("gr#{str}") || str2.include?("#{str}gr") || str2.include?('grace')
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
    if str2.include?('winter') || str2.include?('christmas') || str2.include?('holiday') || str2.include?('we') || str2.include?('santa')
      return [str,['Chrom(Winter)'],["winter#{str}","#{str}winter","christmas#{str}","#{str}christmas","holiday#{str}","#{str}holiday","we#{str}","#{str}we","santa#{str}","#{str}santa"]]
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
    if str=='kamui' && (str2.include?('gaiden') || str2.include?('sov')) && find_unit('Kamui',event,true)>-1
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
    return [str,['Kamui'],[str]] if str=='kamui' && find_unit('Kamui',event,true)>-1
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
    return nil if find_name_in_string(event,str1)
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
    elsif str2.include?('abounds') || str2.include?('valentines') || str2.include?("valentine's") || str2.include?("la#{str}") || str2.include?("#{str}la") || str2.include?("v#{str}") || str2.include?("#{str}v")
      return [str,['Lyn(Valentines)'],["love#{str}","abounds#{str}","valentines#{str}","valentine's#{str}","#{str}love","#{str}abounds","#{str}valentines","#{str}valentine's","la#{str}","#{str}la"]]
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
  name='Lucina' if name==['Lucina(Spring)','Lucina(Brave)']
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
      list_skill_aliases(event,args,bot,mode)
      return nil
    end
  end
  unless unit.nil? || unit.is_a?(Array)
    unit=nil if find_unit(unit,event)<0
  end
  f=[]
  n=@aliases.reject{|q| q[0]!='Unit'}.map{|q| [q[1],q[2],q[3]]}
  m=@multi_aliases.map{|a| a}
  h=''
  if unit.nil?
    if safe_to_spam?(event) || mode==1
      n=n.reject{|q| q[2].nil?} if mode==1
      unless event.server.nil?
        n=n.reject{|q| !q[2].nil? && !q[2].include?(event.server.id)}
        if n.length>25 && !safe_to_spam?(event)
          event.respond "There are so many aliases that I don't want to spam the server.  Please use the command in PM."
          return nil
        end
        msg='**Single-unit aliases**'
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event)
        end
        unless mode==1
          msg=extend_message(msg,'**Multi-unit aliases**',event,2)
          for i in 0...m.length
            msg=extend_message(msg,"#{m[i][0]} = #{m[i][1].join(', ')}",event)
          end
        end
        list_skill_aliases(event,args,bot,mode,msg)
        return nil
      end
      f.push('**Single-unit aliases**')
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
      event.respond 'Please either specify a unit/skill name or use this command in PM.'
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
      f.push("#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u.gsub('Lavatain','Laevatein')}#{unit_moji(bot,event,-1,u,false,4)}**#{"'s server-specific aliases__" if mode==1}")
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
  list_skill_aliases(event,args,bot,mode,msg)
  return nil
end

def list_skill_aliases(event,args,bot,mode=0,startstr='')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load()
  nicknames_load()
  unless args.length.zero?
    skill=@skills[find_skill(args.join(''),event)][0]
    if find_skill(args.join(''),event)==-1
      if startstr.length>0
        event.respond startstr
        return nil
      end
      event.respond "#{args[0]} is not a unit or skill name, or an alias."
      return nil
    end
  end
  unless skill.nil? || skill.is_a?(Array)
    skill=nil if find_skill(skill,event)<0
  end
  f=[]
  n=@aliases.reject{|q| q[0]!='Skill'}.map{|q| [q[1],q[2],q[3]]}
  h=''
  if skill.nil?
    if safe_to_spam?(event) || mode==1
      n=n.reject{|q| q[2].nil?} if mode==1
      unless event.server.nil?
        n=n.reject{|q| !q[2].nil? && !q[2].include?(event.server.id)}
        if n.length+startstr.split("\n").length>25 && !safe_to_spam?(event)
          event.respond "There are so many aliases that I don't want to spam the server.  Please use the command in PM."
          return nil
        elsif n.length<=0 && startstr.length>0
          event.respond startstr
          return nil
        end
        msg=extend_message(startstr,'**Single-skill aliases**',event,2)
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event)
        end
        event.respond msg
        return nil
      end
      f.push('**Single-skill aliases**')
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
      event.respond 'Please either specify a unit/skill name or use this command in PM.'
      return nil
    end
  else
    k=0
    k=event.server.id unless event.server.nil?
    skill=[skill] unless skill.is_a?(Array)
    for i1 in 0...skill.length
      u=@skills[find_skill(skill[i1],event)]
      f.push("#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u[0].gsub('Bladeblade','Laevatein')}#{skill_moji(u,event)}**#{"'s server-specific aliases__" if mode==1}")
      u=u[0]
      f.push(u) if u=='Bladeblade'
      f.push(u.gsub('(','').gsub(')','').gsub(' ','')) if u.include?('(') || u.include?(')') || u.include?(' ')
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
  f.uniq!
  if f.length+startstr.split("\n").length>50 && !safe_to_spam?(event)
    event.respond "There are so many aliases that I don't want to spam the server.  Please use the command in PM."
    return nil
  end
  msg="#{startstr}\n"
  for i in 0...f.length
    msg=extend_message(msg,f[i],event)
  end
  event.respond msg
  return nil
end
