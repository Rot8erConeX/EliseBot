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
    elsif str2.include?('bunny') || str2.include?('easter') || str2.include?('sf')
      return [str,['Camilla(Bunny)'],["bunny#{str}","#{str}bunny","easter#{str}","#{str}easter","sf#{str}","#{str}sf"]]
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
    if str2.include?('winter') || str2.include?('christmas') || str2.include?('holiday') || str2.gsub('flower','').include?('we') || str2.include?('santa')
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
      event.respond "The alias system can cover:\n- Units\n- Skills (weapons, assists, specials, and passives)\n- [Aether Raids] Structures\n- Accessories\n- Items\n\n#{args.join(' ')} does not fall into any of these categories."
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
  newname=newname.gsub('!','').gsub('(','').gsub(')','').gsub('_','')
  unit=unit.gsub('!','').gsub('(','').gsub(')','').gsub('_','')
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
  checkstr=normalize(newname,true)
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
  else
    type=type.map{|q| q.gsub('*','')}
  end
  checkstr=normalize(newname,true)
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

def legal_weapon(event,name,weapon,refinement='-',recursion=false)
  return '-' if weapon=='-'
  u=@units[@units.find_index{|q| q[0]==name.gsub('Laevatein','Lavatain')}]
  w=@skills[@skills.find_index{|q| q[0]==weapon.gsub('Laevatein','Bladeblade')}]
  unless w[0].split(' ')[0].length>u[0].length
    return '-' if w[0][0,u[0].length].downcase==u[0].downcase && count_in(event.message.text.downcase.split(' '),u[0].downcase,1)<=1
  end
  return '-' if w[4]!='Weapon'
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
    w=@skills[@skills.find_index{|q| q[0]==weapon.gsub('Laevatein','Bladeblade')}]
  elsif weapon=='Adult (All)'
    weapon="Adult (#{u[3]})"
    w=@skills[@skills.find_index{|q| q[0]==weapon.gsub('Laevatein','Bladeblade')}]
  end
  w2="#{weapon}"
  w2="#{weapon} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  return "~~#{w2}~~" if w[6]!='-' && !w[6].split(', ').include?(u[0]) # prf weapons are illegal on anyone but their holders
  u2=weapon_clss(u[1],event)
  u2='Bow' if u2.include?('Bow')
  u2='Dagger' if u2.include?('Dagger')
  u2="#{u2.gsub('Healer','Staff')} Users Only"
  u2='Dragons Only' if u[1][1]=='Dragon'
  u2="Beasts Only, #{u[3].gsub('Flier','Fliers')} Only" if u[1][1]=='Beast'
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
  elsif ['Blue Egg','Green Egg','Blue Gift','Green Gift'].include?(w[0].gsub('+',''))
    t='Egg'
    t='Gift' if ['Blue Gift','Green Gift'].include?(w[0].gsub('+',''))
    return weapon_legality(event,name,"Blue #{t}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Green #{t}#{'+' if w[0].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless','Red'].include?(u[1][0])
    w2="Empty #{t}#{'+' if w[0].include?('+')}"
    w2="Red #{t}#{'+' if w[0].include?('+')}" if u[1][0]=='Red'
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
  trucolors=[]
  for i in 1...6
    if list.include?(@units[@units.find_index{|q| q[0]==@banner[i][1]}][1][0])
      e << "Orb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,-1,@banner[i][1],false,4)} (*#{@banner[i][2]}*)"
      summons+=1
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5:448266417553539104>')
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5p10:448272715099406336>')
    elsif list.include?(i)
      e << "Orb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,-1,@banner[i][1],false,4)} (*#{@banner[i][2]}*)"
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
      str2="#{str2}\nOrb ##{i} contained a #{@banner[i][0]} **#{@banner[i][1].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,-1,@banner[i][1],false,4)} (*#{@banner[i][2]}*)"
      summons+=1
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5:448266417553539104>')
      five_star=true if @banner[i][0].include?('5<:Icon_Rarity_5p10:448272715099406336>')
    end
  end
  if summons<=0
    str2="#{str2} - No target colors\nOrb #4 contained a #{@banner[4][0]} **#{@banner[4][1].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,-1,@banner[4][1],false,4)} (*#{@banner[4][2]}*)"
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
      k[0].push(bnr[2][i].gsub('Lavatain','Laevatein')) if k2=='Red'
      k[1].push(bnr[2][i].gsub('Lavatain','Laevatein')) if k2=='Blue'
      k[2].push(bnr[2][i].gsub('Lavatain','Laevatein')) if k2=='Green'
      k[3].push(bnr[2][i].gsub('Lavatain','Laevatein')) if k2=='Colorless'
      k[4].push(bnr[2][i].gsub('Lavatain','Laevatein')) unless ['Red','Blue','Green','Colorless'].include?(k2)
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
          cracked_orbs.push([@banner[i],i]) if trucolors.include?(@units[find_unit(@banner[i][1],event)][1][0])
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
        str2="#{str2}\nOrb ##{cracked_orbs[i][1]} contained a #{cracked_orbs[i][0][0]} **#{cracked_orbs[i][0][1].gsub('Lavatain','Laevatein')}**#{unit_moji(bot,event,-1,cracked_orbs[i][0][1],false,4)} (*#{cracked_orbs[i][0][2]}*)"
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
        else
          return false
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
