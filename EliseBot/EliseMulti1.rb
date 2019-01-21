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
    elsif str2.include?('bunny') || str2.include?('easter') || str2.include?('sf')
      return [str,['Camilla(Bunny)'],["bunny#{str}","#{str}bunny","easter#{str}","#{str}easter","sf#{str}","#{str}sf"]]
    elsif str2.include?('bath') || str2.include?('bathhouse') || str2.include?('bathouse') || str2.include?('hotspring') || str2.include?('hot')
      return [str,['Camilla(Bath)'],["bath#{str}","#{str}bath","bathhouse#{str}","#{str}bathhouse","bathouse#{str}","#{str}bathouse","hotspring#{str}","#{str}hotspring","hot#{str}","#{str}hot"]]
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
    elsif str2.include?('wings') || str2.include?('kinshi') || str2.include?('winged') || str2.include?("#{str}2")
      return [str,['Hinoka(Wings)'],["wings#{str}","#{str}wings","kinshi#{str}","#{str}kinshi","winged#{str}","#{str}winged","#{str}2"]]
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
    skill=@skills[find_skill(args.join(''),event)][0]
    struct=find_structure(args.join(''),event)
    azry=@accessories[find_accessory(args.join(''),event)][0]
    itmu=@itemus[find_item_feh(args.join(''),event)][0]
    if !detect_multi_unit_alias(event,args.join(''),event.message.text.downcase,1).nil?
      x=detect_multi_unit_alias(event,args.join(''),event.message.text.downcase,1)
      unit=x[1]
      unit=[unit] unless unit.is_a?(Array)
      g=get_markers(event)
      u=@units.reject{|q| !has_any?(g, q[13][0])}.map{|q| q[0]}
      unit=unit.reject{|q| !u.include?(q)}
    elsif find_unit(args.join(''),event)==-1 && find_skill(args.join(''),event)==-1 && find_accessory(args.join(''),event)==-1 && find_item_feh(args.join(''),event)==-1 && find_structure(args.join(''),event).length<=0 && !has_any?(args,['unit','units','characters','character','chara','charas','char','chars','skill','skills','skil','skils','structures','structure','struct','structs','item','items','accessorys','accessory','accessories'])
      event.respond "The alias system can cover:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- [Aether Raids] Structures\n- Accessories\m- Items\n\n#{args.join(' ')} does not fall into any of these categories."
      return nil
    end
  end
  unless unit.nil? || unit.is_a?(Array)
    unit=nil if find_unit(args.join(''),event)<0
  end
  unless skill.nil? || skill.is_a?(Array)
    skill=nil if find_skill(args.join(''),event)<0
  end
  if struct.length>0
    struct=struct.map{|q| @structures[q]}
  else
    struct=nil
  end
  unless itmu.nil? || itmu.is_a?(Array)
    itmu=nil if find_item_feh(args.join(''),event)<0
  end
  unless azry.nil? || azry.is_a?(Array)
    azry=nil if find_accessory(args.join(''),event)<0
  end
  f=[]
  n=@aliases.reject{|q| q[0]!='Unit'}.map{|q| [q[1],q[2],q[3]]}
  m=@multi_aliases.map{|a| a}
  h=''
  skipmulti=false
  if unit.nil? && skill.nil? && struct.nil? && azry.nil? && itmu.nil?
    if has_any?(args,['unit','units','characters','character','chara','charas','char','chars'])
      f.push('__**Single-unit aliases**__')
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
      if m.length>0 && mode != 1
        f.push("\n__**Multi-unit aliases**__")
        for i in 0...m.length
          f.push("#{m[i][0]}#{" = #{m[i][1].join(', ')}" if unit.nil?}")
        end
      end
    elsif has_any?(args,['skill','skills','skil','skils'])
      n=@aliases.reject{|q| q[0]!='Skill'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Skill aliases**__')
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
    elsif has_any?(args,['structures','structure','struct','structs'])
      n=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**[Aether Raids] Structure aliases**__')
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
    elsif has_any?(args,['accessorys','accessory','accessories'])
      n=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Accessory aliases**__')
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
    elsif has_any?(args,['items','item'])
      n=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Item aliases**__')
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
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event)
        end
        unless mode==1
          msg=extend_message(msg,'__**Multi-unit aliases**__',event,2)
          for i in 0...m.length
            msg=extend_message(msg,"#{m[i][0]} = #{m[i][1].join(', ')}",event)
          end
        end
        n=@aliases.reject{|q| q[0]!='Skill'}.map{|q| [q[1],q[2],q[3]]}
        n=n.reject{|q| q[2].nil?} if mode==1
        msg=extend_message(startstr,'__**Skill aliases**__',event,2)
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event)
        end
        n=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
        n=n.reject{|q| q[2].nil?} if mode==1
        msg=extend_message(startstr,'__**[Aether Raids] Structure aliases**__',event,2)
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event)
        end
        n=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
        n=n.reject{|q| q[2].nil?} if mode==1
        msg=extend_message(startstr,'__**Accessory aliases**__',event,2)
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event)
        end
        n=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
        n=n.reject{|q| q[2].nil?} if mode==1
        msg=extend_message(startstr,'__**Item aliases**__',event,2)
        for i in 0...n.length
          msg=extend_message(msg,"#{n[i][0]} = #{n[i][1]}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event)
        end
        event.respond msg
        return nil
      end
      f.push('__**Single-unit aliases**__')
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
      if m.length>0 && mode != 1
        f.push("\n__**Multi-unit aliases**__")
        for i in 0...m.length
          f.push("#{m[i][0]}#{" = #{m[i][1].join(', ')}" if unit.nil?}")
        end
      end
      n=@aliases.reject{|q| q[0]!='Skill'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push("\n__**Skill aliases**__")
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
      n=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push("\n__**[Aether Raids] Structure aliases**__")
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
      n=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Accessory aliases**__')
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
      n=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
      n=n.reject{|q| q[2].nil?} if mode==1
      f.push('__**Item aliases**__')
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
      skill=[skill] unless skill.is_a?(Array)
      for i1 in 0...skill.length
        u=@skills[find_skill(skill[i1],event)]
        f.push("\n#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u[0].gsub('Bladeblade','Laevatein')}#{skill_moji(u,event,bot)}**#{"'s server-specific aliases__" if mode==1}")
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
  elsif !struct.nil?
    n=@aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
    n=n.reject{|q| q[2].nil?} if mode==1
    semote=''
    semote='<:Offensive_Structure:510774545997758464><:Defensive_Structure:510774545108566016>' if struct[0][2]=='Offensive/Defensive'
    semote='<:Defensive_Structure:510774545108566016>' if struct[0][2]=='Defensive'
    semote='<:Offensive_Structure:510774545997758464>' if struct[0][2]=='Offensive'
    semote='<:Trap_Structure:510774545179869194>' if struct[0][2]=='Trap'
    semote='<:Resource_Structure:510774545154572298>' if struct[0][2]=='Resources'
    semote='<:Ornamental_Structure:510774545150640128>' if struct[0][2]=='Ornament'
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
            f.push("#{n[i][0].gsub('_','\\_')} (in the following servers: #{list_lift(a,'and')})") if a.length>0
          elsif n[i][2].nil?
            f.push(n[i][0].gsub('_','\\_')) unless mode==1
          else
            f.push("#{n[i][0].gsub('_','\\_')}#{" *(in this server only)*" unless mode==1}") if n[i][2].include?(k)
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
  elsif !azry.nil?
    n=@aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
    n=n.reject{|q| q[2].nil?} if mode==1
    azry=[azry] unless azry.is_a?(Array)
    for i1 in 0...azry.length
      u=@accessories[find_accessory(azry[i1],event)]
      semote=''
      semote='<:Accessory_Type_Hair:531733124741201940>' if u[1]=='Hair'
      semote='<:Accessory_Type_Hat:531733125227741194>' if u[1]=='Hat'
      semote='<:Accessory_Type_Mask:531733125064163329>' if u[1]=='Mask'
      semote='<:Accessory_Type_Tiara:531733130734731284>' if u[1]=='Tiara'
      f.push("\n#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u[0]}**#{semote}#{"'s server-specific aliases__" if mode==1}")
      u=u[0]
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
  elsif !itmu.nil?
    n=@aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
    n=n.reject{|q| q[2].nil?} if mode==1
    itmu=[itmu] unless itmu.is_a?(Array)
    for i1 in 0...itmu.length
      u=@itemus[find_item_feh(itmu[i1],event)]
      f.push("\n#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u[0]}**#{"'s server-specific aliases__" if mode==1}")
      u=u[0]
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
  if find_unit(newname,event,true)>=0
    type[0]='Unit'
  elsif find_skill(newname,event,true)>=0
    type[0]='Skill'
  elsif find_structure(newname,event,true).length>0
    type[0]='Structure'
  elsif find_accessory(newname,event,true)>=0
    type[0]='Accessory'
  elsif find_item_feh(newname,event,true)>=0
    type[0]='Item'
  elsif find_unit(newname,event)>=0
    type[0]='Unit*'
  elsif find_skill(newname,event)>=0
    type[0]='Skill*'
  elsif find_structure(newname,event).length>0
    type[0]='Structure*'
  elsif find_accessory(newname,event)>=0
    type[0]='Accessory*'
  elsif find_item_feh(newname,event)>=0
    type[0]='Item*'
  end
  type[0]='Skill' if newname.downcase=='adult'
  if find_unit(unit,event,true)>=0
    type[1]='Unit'
  elsif find_skill(unit,event,true)>=0
    type[1]='Skill'
  elsif find_structure(unit,event,true).length>0
    type[1]='Structure'
  elsif find_accessory(unit,event,true)>=0
    type[1]='Accessory'
  elsif find_item_feh(unit,event,true)>=0
    type[1]='Item'
  elsif find_unit(unit,event)>=0
    type[1]='Unit*'
  elsif find_skill(unit,event)>=0
    type[1]='Skill*'
  elsif find_structure(unit,event).length>0
    type[1]='Structure*'
  elsif find_accessory(unit,event)>=0
    type[1]='Accessory*'
  elsif find_item_feh(unit,event)>=0
    type[1]='Item*'
  end
  type[1]='Skill' if unit.downcase=='adult'
  cck=nil
  checkstr=normalize(newname.gsub('!','').gsub('(','').gsub(')','').gsub('_',''))
  if type.reject{|q| q != 'Alias'}.length<=0
    type[0]='Alias' if type[0].include?('*')
    type[1]='Alias' if type[1].include?('*') && type[0]!='Alias'
  end
  if type.reject{|q| q == 'Alias'}.length<=0
    str="The alias system can cover:\n- Units\n- Skills (Weapons, Assists, Specials, Passives)\n- [Aether Raids] Structures\n- Accessories\n- Items\n\nNeither #{newname} nor #{unit} is any of the above."
    err=true
  elsif type.reject{|q| q != 'Alias'}.length<=0
    x=['a','a']
    x[0]='an' if ['item','accessory'].include?(type[0].downcase)
    x[1]='an' if ['item','accessory'].include?(type[1].downcase)
    str="#{newname} is #{x[0]} #{type[0].downcase}\n#{unit} is #{x[1]} #{type[1].downcase}"
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
  end
  if type[0]=='Alias' && type[1].gsub('*','')=='Unit'
    unt=@units[find_unit(unit,event)]
    checkstr2=checkstr.downcase.gsub(unt[12].split(', ')[0].gsub('*','').downcase,'')
    cck=unt[12].split(', ')[1][0,1].downcase if unt[12].split(', ').length>1
  elsif type[0]=='Alias' && type[1].gsub('*','')=='Skill'
    unt=@skills[find_skill(unit,event)]
    checkstr2=unt[0].gsub(' ','').downcase
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
    unt=@accessories[find_accessory(unit,event)]
    checkstr2="#{unt[0]}"
  elsif type[0]=='Alias' && type[1].gsub('*','')=='Item'
    unt=@itemus[find_item_feh(unit,event)]
    checkstr2="#{unt[0]}"
  end
  logchn=386658080257212417
  logchn=431862993194582036 if @shardizard==4
  newname=newname.gsub('!','').gsub('(','').gsub(')','').gsub('_','')
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
    if @aliases[i][3].nil? || @aliases[i][0]!=type[1]
    elsif @aliases[i][1].downcase==newname.downcase && @aliases[i][2].downcase==unit.downcase
      if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?
        @aliases[i][3]=nil
        @aliases[i][4]=nil
        @aliases[i].compact!
        bot.channel(chn).send_message("The alias **#{newname}** for the #{type[1].downcase} *#{unit.gsub('Lavatain','Laevatein').gsub('Bladeblade','Laevatein')}* exists in a server already.  Making it global now.")
        event.respond "The alias **#{newname}** for the #{type[1].downcase} *#{unit.gsub('Lavatain','Laevatein').gsub('Bladeblade','Laevatein')}* exists in a server already.  Making it global now.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit} - gone global.")
        double=true
      else
        @aliases[i][3].push(srv)
        bot.channel(chn).send_message("The alias **#{newname}** for the #{type[1].downcase} *#{unit.gsub('Lavatain','Laevatein').gsub('Bladeblade','Laevatein')}* exists in another server already.  Adding this server to those that can use it.")
        event.respond "The alias **#{newname}** for the #{type[1].downcase} *#{unit.gsub('Lavatain','Laevatein').gsub('Bladeblade','Laevatein')}* exists in another server already.  Adding this server to those that can use it.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        metadata_load()
        bot.user(167657750971547648).pm("The alias **#{@aliases[i][1]}** for the #{type[1].downcase} **#{@aliases[i][2]}** is used in quite a few servers.  It might be time to make this global") if @aliases[i][3].length >= @server_data[0].inject(0){|sum,x| sum + x } / 20 && @aliases[i][4].nil?
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit} - gained a new server that supports it.")
        double=true
      end
    end
  end
  unless double
    @aliases.push([type[1].gsub('*',''),newname,unit,m].compact)
    @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? ((a[2].downcase <=> b[2].downcase) == 0 ? (a[1].downcase <=> b[1].downcase) : (a[2].downcase <=> b[2].downcase)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    bot.channel(chn).send_message("**#{newname}** has been#{" globally" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?} added to the aliases for the #{type[1].gsub('*','').downcase} *#{unit}*.\nPlease test to be sure that the alias stuck.")
    event.respond "**#{newname}** has been#{" globally" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?} added to the aliases for the #{type[1].gsub('*','').downcase} *#{unit}*." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
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
end

def list_collapse(list,mode=0)
  list=list.uniq
  newlist=[]
  for i in 0...list.length
    unless list[i].nil? || (list[i][0][0,10]=='Falchion (' && skill_include?(list,'Falchion')>0) || (list[i][0][0,14]=='Missiletainn (' && skill_include?(list,'Missiletainn')>0)
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
      elsif list[i][0]=='Whelp (Infantry)' && skill_include?(list,'Yearling (Infantry)')>=0 && (mode/2)%2==1
        if skill_include?(list,'Adult (Infantry)')>=0
          list[i][0]='Whelp/Yearling/Adult (Infantry)'
          list[i][1]=200
          list[skill_include?(list,'Adult (Infantry)')]=nil if skill_include?(list,'Adult (Infantry)')>=0
          newlist[skill_include?(newlist,'Adult (Infantry)')]=nil if skill_include?(newlist,'Adult (Infantry)')>=0
        else
          list[i][0]='Whelp/Yearling (Infantry)'
          list[i][1]=100
        end
        list[skill_include?(list,'Yearling (Infantry)')]=nil
        newlist[skill_include?(newlist,'Yearling (Infantry)')]=nil if skill_include?(newlist,'Yearling (Infantry)')>=0
      elsif list[i][0]=='Hatchling (Flier)' && skill_include?(list,'Fledgeling (Flier)')>=0 && (mode/2)%2==1
        if skill_include?(list,'Adult (Flier)')>=0
          list[i][0]='Hatchling/Fledgeling/Adult (Flier)'
          list[i][1]=200
          list[skill_include?(list,'Adult (Flier)')]=nil if skill_include?(list,'Adult (Flier)')>=0
          newlist[skill_include?(newlist,'Adult (Flier)')]=nil if skill_include?(newlist,'Adult (Flier)')>=0
        else
          list[i][0]='Hatchling/Fledgeling (Flier)'
          list[i][1]=100
        end
        list[skill_include?(list,'Fledgeling (Flier)')]=nil
        newlist[skill_include?(newlist,'Fledgeling (Flier)')]=nil if skill_include?(newlist,'Fledgeling (Flier)')>=0
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
