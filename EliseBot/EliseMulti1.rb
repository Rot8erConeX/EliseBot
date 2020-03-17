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
  alz=@aliases.reject{|q| q[0]!='Unit' || q[2].is_a?(Array) || (!q[3].nil? && !q[3].include?(k))}
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
  elsif /bvero(ni(c|k)a|)/ =~ str1 || /broni/ =~ str1
    str='bvero'
    str='bveronica' if str2.include?('bveronica')
    str='bveronika' if str2.include?('bveronika')
    str='broni' if str2.include?('broni')
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Veronica(Brave)','Veronica(Bunny)'],[str]]
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
  elsif /(cel(l|)ica|ant(eze|hesis|hiese))/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='celica'
    str='cellica' if str2.include?('cellica')
    str='anteze' if str2.include?('anteze')
    str='anthesis' if str2.include?('anthesis')
    str='anthiese' if str2.include?('anthiese')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('legendary') || str2.include?('saint') || str2.include?('queen')
      return [str,['Celica(Queen)'],["legendary#{str}","#{str}legendary","saint#{str}","#{str}saint","queen#{str}","#{str}queen","queenly#{str}","#{str}queenly"]]
    elsif str2.include?('brave') || str2.include?('cyl') || str2.include?('bh')
      return [str,['Celica(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
    end
    return [str,['Celica(Brave)','Celica(Queen)'],[str]]
  elsif /alm/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='alm'
    str='arum' if str2.include?('arum')
    str='arumu' if str2.include?('arumu')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('legendary') || str2.include?('saint') || str2.include?('king')
      return [str,['Alm(Saint)'],["legendary#{str}","#{str}legendary","saint#{str}","#{str}saint","king#{str}","#{str}king"]]
    elsif str2.include?('brave') || str2.include?('cyl') || str2.include?('bh')
      return [str,['Alm(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
    end
    return [str,['Alm(Saint)','Alm(Brave)'],[str]]
  elsif /(eliwood|eliweed|elioud)/ =~ str1 && str1.include?('legend') && !str1.include?('legendary')
    str='eliwood'
    str='eliweed' if str2.include?('eliweed')
    str='elioud' if str2.include?('elioud')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('legendary') || str2.include?('blazing') || str2.include?('knight')
      return [str,['Eliwood(Wind)'],["legendary#{str}","#{str}legendary","blazing#{str}","#{str}blazing","knight#{str}","#{str}knight"]]
    elsif str2.include?('brave') || str2.include?('cyl')
      return [str,['Eliwood(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
    end
    return [str,['Hector(Marquess)','Hector(Brave)'],[str]]
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
  elsif /(catria|(c|k)atua)/ =~ str1
    str='catria'
    str='catua' if str2.include?('catua')
    str='katua' if str2.include?('katua')
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch') || str2.include?('archenea') || str2.include?('archanea')
      return [str,['Catria(Launch)'],["vanilla#{str}","#{str}vanilla","default#{str}","#{str}default","og#{str}","#{str}og","launch#{str}","#{str}launch","archenea#{str}","#{str}archenea","archanea#{str}","#{str}archanea"]]
    elsif str2.include?('sov') || str2.include?('valentia') || str2.include?('zofia')
      return [str,['Catria(SoV)'],["sov#{str}","#{str}sov","valentia#{str}","#{str}valentia","zofia#{str}","#{str}zofia"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Catria(Launch)','Catria(SoV)'],[str]]
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
    elsif str2.include?('brave') || str2.include?('cyl') || str2.include?('bh')
      return [str,['Camilla(Brave)'],["brave#{str}","#{str}brave","cyl#{str}","#{str}cyl","bh#{str}","#{str}bh"]]
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
    if str2.include?('winter') || str2.include?('christmas') || str2.include?('holiday') || str2.include?('gg') || str2.include?('santa')
      return [str,['Nino(Winter)'],["winter#{str}","#{str}winter","christmas#{str}","#{str}christmas","holiday#{str}","#{str}holiday","gg#{str}","#{str}gg","santa#{str}","#{str}santa"]]
    elsif str2.include?('default') || str2.include?('vanilla') || str2.include?('og') || str2.include?('launch')
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
    elsif str2.include?('branded') || str2.include?('brand') || str2.include?('exalted') || str2.include?('exalt') || str2.include?('sealed') || str2.include?('horse') || str2.include?('knight')
      return [str,['Chrom(Branded)'],["branded#{str}","#{str}branded","brand#{str}","#{str}brand","exalted#{str}","#{str}exalted","exalt#{str}","#{str}exalt","sealed#{str}","#{str}sealed","horse#{str}","#{str}horse","knight#{str}","#{str}knight"]]
    elsif str2.include?('crowned') || str2.include?('crown') || str2.include?('magalor') || str2.include?('chrom')
      return [str,['Chrom(Crowned)'],["crowned#{str}","#{str}crowned","crown#{str}","#{str}crown","magalor#{str}","#{str}magalor","chromchrom"]]
    elsif str2.include?('popstar') || str2.include?('star') || str2.include?('idol')
      return [str,['Itsuki'],["star#{str}","#{str}star","idol#{str}","#{str}idol","popstar#{str}","#{str}popstar"]]
    elsif str2.include?('king')
      return [str,['Chrom(Branded)','Chrom(Crowned)'],["king#{str}","#{str}king"]]
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
    elsif str2.include?('soiree') || str2.include?('splendid') || str2.include?("#{str}ss") || str2.include?("ss#{str}") || str2.include?('dancer') || str2.include?('dancing') || str2.include?('dance') || str2.include?('performing')
      return [str,['Reinhardt(Soiree)'],["soiree#{str}","#{str}soiree","splendid#{str}","#{str}splendid","ss#{str}","#{str}ss","dance#{str}","#{str}dance","dancer#{str}","#{str}dancer","dancing#{str}","#{str}dancing","performing#{str}","#{str}performing"]]
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
    elsif str2.include?('fallen') || str2.include?('evil') || str2.include?('darkness') || str2.include?('dark') || str2.include?('alter') || str2.include?('fh')
      strx='fallen'
      strx='evil' if str2.include?('evil')
      strx='dark' if str2.include?('dark')
      strx='darkness' if str2.include?('darkness')
      strx='alter' if str2.include?('alter')
      strx='fh' if str2.include?('fh')
      str2=str3.gsub(strx,'').gsub("#{str} ",str).gsub(" #{str}",str)
      m=["#{strx}#{str}","#{str}#{strx}","#{strx} #{str}","#{str} #{strx}"]
      return [str,['Tiki(Young)(Fallen)'],m]
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
    elsif str2.include?('fallen') || str2.include?('evil') || str2.include?('darkness') || str2.include?('dark') || str2.include?('alter') || str2.include?('fh') || str2.include?('grima')
      strx='fallen'
      strx='evil' if str2.include?('evil')
      strx='dark' if str2.include?('dark')
      strx='darkness' if str2.include?('darkness')
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
    elsif str2.include?('fallen') || str2.include?('evil') || str2.include?('darkness') || str2.include?('dark') || str2.include?('alter') || str2.include?('fh')
      strx='fallen'
      strx='evil' if str2.include?('evil')
      strx='dark' if str2.include?('dark')
      strx='darkness' if str2.include?('darkness')
      strx='alter' if str2.include?('alter')
      strx='fh' if str2.include?('fh')
      str2=str3.gsub(strx,'').gsub("#{str} ",str).gsub(" #{str}",str)
      m=["#{strx}#{str}","#{str}#{strx}","#{strx} #{str}","#{str} #{strx}"]
      return [str,['Corrin(F)(Fallen)'],m]
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
  elsif /(byleth)/ =~ str1
    str='byleth'
    str2=str2.gsub("#{str} ",str).gsub(" #{str}",str).gsub(str,'')
    str2=str3.gsub("#{str} ",str).gsub(" #{str}",str)
    if str2.include?("female#{str}") || str2.include?("#{str}female") || str2.include?("lass#{str}") || str2.include?("#{str}lass") || str2.include?("#{str}f") || str2.include?("f#{str}")
      return [str,['Byleth(F)'],["female#{str}","f#{str}","#{str}female","#{str}f"]]
    elsif str2.include?("male#{str}") || str2.include?("#{str}male") || str2.include?("lad#{str}") || str2.include?("#{str}lad") || str2.include?("#{str}m") || str2.include?("m#{str}")
      return [str,['Byleth(M)'],["male#{str}","m#{str}","#{str}male","#{str}m"]]
    end
    return nil if robinmode==2 && str2.downcase != str.downcase
    return [str,['Byleth(F)','Byleth(M)'],[str]]
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
    elsif str2.include?('summer') || str2.include?('beach') || str2.include?('swimsuit') || str2.include?('sr')
      return [str,['Lyn(Symmer)'],["summer#{str}","#{str}summer","beach#{str}","#{str}beach","#{str}swimsuit","swimsuit#{str}","sr#{str}","#{str}sr"]]
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
    unit=find_unit(args.join(''),event,true)[0] unless find_unit(args.join(''),event,true).length<=0
    skill=find_skill(args.join(''),event,false,true) unless find_skill(args.join(''),event,false,true).length<=0
    struct=find_structure(args.join(''),event,true) unless find_structure(args.join(''),event,true).length<=0
    azry=find_accessory(args.join(''),event,true)[0] unless find_accessory(args.join(''),event,true).length<=0
    itmu=find_item_feh(args.join(''),event,true)[0] unless find_item_feh(args.join(''),event,true).length<=0
    if unit.nil? && skill.nil? && struct.nil? && azry.nil? && itmu.nil?
      unit=find_unit(args.join(''),event)[0] unless find_unit(args.join(''),event).length<=0
      skill=find_skill(args.join(''),event) unless find_skill(args.join(''),event).length<=0
      struct=find_structure(args.join(''),event) unless find_structure(args.join(''),event).length<=0
      azry=find_accessory(args.join(''),event)[0] unless find_accessory(args.join(''),event).length<=0
      itmu=find_item_feh(args.join(''),event)[0] unless find_item_feh(args.join(''),event).length<=0
    end
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
  n=n.reject{|q| q[2].nil?} if mode==1
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
          msg=extend_message(msg,"#{n[i][0]} = #{uuu}#{' *(in this server only)*' unless n[i][2].nil? || mode==1}",event) unless n[i][0]==uuu
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
        f.push("\n#{"\n" unless i1.zero?}#{"__" if mode==1}**#{u[1]}#{"#{' ' unless u[1][-1,1]=='+'}#{u[2]}" unless ['-','example'].include?(u[2]) || ['Weapon','Assist','Special'].include?(u[6])}#{skill_moji(u,event,bot)}**#{" [Skl-##{u2}]" if @shardizard==4}#{"'s server-specific aliases__" if mode==1}")
        u="#{u[1]}#{"#{' ' unless u[1][-1,1]=='+'}#{u[2]}" unless ['-','example'].include?(u[2]) || ['Weapon','Assist','Special'].include?(u[6])}"
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
  if newname.include?("\\u{")
    err=true
    str="#{newname} contains an Extended Unicode character (a character with a Unicode ID beyond 65,535, almost all of which are emoji).\nDue to the way I store aliases and how Ruby parses strings from text files, I could theoretically store an Extended Unicode character but be unable to find a matching alias."
  end
  if err
    str=["#{str}\nPlease try again.","#{str}\nTrying to list aliases instead."][mode]
    event.respond str if str.length>0
    args=event.message.text.downcase.split(' ')
    args.shift
    list_unit_aliases(event,args,bot) if mode==1
    return nil
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
  logchn=536307117301170187 if @shardizard==-1
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
        bot.channel(chn).send_message("The alias **#{newname}** for the #{type[1].downcase} *#{unt[0]}* exists in a server already.  Making it global now.")
        event.respond "The alias **#{newname}** for the #{type[1].downcase} *#{unt[0]}* exists in a server already.  Making it global now.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unt[0]} - gone global.")
        double=true
      else
        @aliases[i][3].push(srv)
        bot.channel(chn).send_message("The alias **#{newname}** for the #{type[1].downcase} *#{unt[0]}* exists in another server already.  Adding this server to those that can use it.")
        event.respond "The alias **#{newname}** for the #{type[1].downcase} *#{unt[0]}* exists in another server already.  Adding this server to those that can use it.\nPlease test to be sure that the alias stuck." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
        metadata_load()
        bot.user(167657750971547648).pm("The alias **#{@aliases[i][1]}** for the #{type[1].downcase} **#{@aliases[i][2]}** is used in quite a few servers.  It might be time to make this global") if @aliases[i][3].length >= @server_data[0].inject(0){|sum,x| sum + x } / 20 && @aliases[i][4].nil?
        bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unt[0]} - gained a new server that supports it.")
        double=true
      end
    end
  end
  unless double
    @aliases.push([type[1].gsub('*',''),newname,unit,m].compact)
    pos=0
    pos=1 if type[1]=='Skill'
    @aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    bot.channel(chn).send_message("**#{newname}** has been#{" globally" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?} added to the aliases for the #{type[1].gsub('*','').downcase} *#{unt[pos]}*.\nPlease test to be sure that the alias stuck.")
    event.respond "**#{newname}** has been#{" globally" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?} added to the aliases for the #{type[1].gsub('*','').downcase} *#{unt[0]}*." if event.user.id==167657750971547648 && !modifier2.nil? && modifier2.to_i.to_s==modifier2
    bot.channel(logchn).send_message("**Server:** #{srvname} (#{srv})\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{type[1].gsub('*','')} Alias:** #{newname} for #{unt[pos]}#{" - global alias" if [167657750971547648,368976843883151362,195303206933233665].include?(event.user.id) && !modifier.nil?}")
  end
  @aliases.uniq!
  nzzz=@aliases.map{|a| a}
  open("#{@location}devkit/FEHNames.txt", 'w') { |f|
    for i in 0...nzzz.length
      f.puts "#{nzzz[i].to_s}#{"\n" if i<nzzz.length-1}"
    end
  }
  nicknames_load()
  nzzz=@aliases.map{|q| q}
  if nzzz[-1].length>1 && nzzz[-1][2].is_a?(String) && nzzz[-1][2]>='Verdant Shard'
    bot.channel(logchn).send_message('Alias list saved.')
    open("#{@location}devkit/FEHNames2.txt", 'w') { |f|
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
  data_load()
  u=@units[@units.find_index{|q| q[0]==name}]
  w=@skills[@skills.find_index{|q| q[1]==weapon}]
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
    w=@skills[@skills.find_index{|q| q[1]==weapon}]
  elsif weapon[0,7]=='Whelp (' || weapon[0,11]=='Hatchling ('
    weapon="Whelp (#{u[3]})"
    weapon="Hatchling (#{u[3]})" if u[3]=='Flier'
    w=@skills[@skills.find_index{|q| q[1]==weapon}]
  elsif weapon[0,10]=='Yearling (' || weapon[0,11]=='Fledgling ('
    weapon="Yearling (#{u[3]})"
    weapon="Fledgling (#{u[3]})" if u[3]=='Flier'
    w=@skills[@skills.find_index{|q| q[1]==weapon}]
  elsif weapon[0,7]=='Adult ('
    weapon="Adult (#{u[3]})"
    w=@skills[@skills.find_index{|q| q[1]==weapon}]
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
  elsif ['Kadomatsu','Hagoita'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Kadomatsu#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Hagoita#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Blue'
    w2="Sushi Sticks#{'+' if w[0].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Tannenboom!',"Sack o' Gifts",'Handbell'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Tannenboom!#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"#{["Sack o' Gifts",'Handbell'].sample}#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green' && w[1].gsub('+','')=='Tannenboom!'
    return "~~#{w2}~~" unless u[1][0]=='Red'
    w2="Santa's Sword#{'+' if w[1].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Loyal Wreath'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Raudrblooms#{'+' if w[1].include?('+')}",refinement) if u[1][0]!='Red'
  elsif ['Faithful Axe',"Heart's Blade"].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Heart's Blade#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Faithful Axe#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless','Blue'].include?(u[1][0])
    w2="Rod of Bonds#{'+' if w[1].include?('+')}"
    w2="Loving Lance#{'+' if w[1].include?('+')}" if u[1][0]=='Blue'
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Carrot Lance','Carrot Axe'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Carrot Lance#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Carrot Axe#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless','Red'].include?(u[1][0])
    w2="Carrot#{'+' if w[1].include?('+')}...just a carrot#{'+' if w[1].include?('+')}"
    w2="Carrot Sword#{'+' if w[1].include?('+')}" if u[1][0]=='Red'
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Red Egg','Blue Egg','Green Egg','Red Gift','Blue Gift','Green Gift'].include?(w[1].gsub('+',''))
    t='Egg'
    t='Gift' if ['Red Gift','Blue Gift','Green Gift'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Red #{t}#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Blue #{t}#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Green #{t}#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Colorless'].include?(u[1][0])
    w2="Empty #{t}#{'+' if w[1].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Safeguard','Vanguard','Rearguard'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Safeguard#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Vanguard#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Rearguard#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    w2="Midguard#{'+' if w[1].include?('+')}"
  elsif ['Lofty Blossoms','Cake Cutter'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Cake Cutter#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Lofty Blossoms#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return "~~#{w2}~~" unless ['Green'].include?(u[1][0])
    w2="Bouncer's Axe#{'+' if w[1].include?('+')}"
  elsif ['Carrot Cudgel','Gilt Fork'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Carrot Cudgel#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Gilt Fork#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return "~~#{w2}~~" unless ['Green'].include?(u[1][0])
    w2="Gilt Axe#{'+' if w[1].include?('+')}"
  elsif ['Melon Crusher','Deft Harpoon'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Deft Harpoon#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Melon Crusher#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless ['Red'].include?(u[1][0])
    w2="Ylissian Summer Sword#{'+' if w[1].include?('+')}"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Iron Sword','Iron Lance','Iron Axe','Steel Sword','Steel Lance','Steel Axe','Silver Sword','Silver Lance','Silver Axe','Brave Sword','Brave Lance','Brave Axe','Firesweep Sword','Firesweep Lance','Firesweep Axe','Guard Sword','Guard Lance','Guard Axe'].include?(w[1].gsub('+',''))
    t='Iron'
    t='Steel' if 'Steel '==w[1][0,6]
    t='Silver' if 'Silver '==w[1][0,7]
    t='Brave' if 'Brave '==w[1][0,6]
    t='Firesweep' if 'Firesweep '==w[1][0,10]
    t='Guard' if 'Guard '==w[1][0,10]
    if event.message.text.downcase.include?('sword') || event.message.text.downcase.include?('edge')
    elsif event.message.text.downcase.include?('lance')
    elsif event.message.text.downcase.include?('axe')
    elsif (['Iron','Steel','Silver'].include?(t) && u[1][1]=='Dagger') || u[1][1]=='Bow'
      return weapon_legality(event,name,"#{t} Dagger#{'+' if w[1].include?('+')}",refinement,true) if u[1][1]=='Dagger'
      return weapon_legality(event,name,"#{t} Bow#{'+' if w[1].include?('+')}",refinement,true) if u[1][1]=='Bow'
    end
    return weapon_legality(event,name,"#{t} Sword#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"#{t} Lance#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"#{t} Axe#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Colorless'
    w2="#{t} Rod"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Barrier Blade','Barrier Lance','Barrier Axe'].include?(w[1].gsub('+',''))
    t='Barrier'
    if event.message.text.downcase.include?('sword') || event.message.text.downcase.include?('edge')
    elsif event.message.text.downcase.include?('lance')
    elsif event.message.text.downcase.include?('axe')
    elsif u[1][1]=='Bow'
     # return weapon_legality(event,name,"#{t} Bow#{'+' if w[1].include?('+')}",refinement,true) if u[1][1]=='Bow'
    end
    return weapon_legality(event,name,"#{t} Blade#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"#{t} Lance#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"#{t} Axe#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Colorless'
    w2="#{t} Rod"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Killing Edge','Killer Lance','Killer Axe','Slaying Edge','Slaying Lance','Slaying Axe'].include?(w[1].gsub('+',''))
    t='Killer'
    t='Killing' if u[1][0]=='Red'
    t='Slaying' if 'Slaying '==w[1][0,8]
    if event.message.text.downcase.include?('sword') || event.message.text.downcase.include?('edge')
    elsif event.message.text.downcase.include?('lance')
    elsif event.message.text.downcase.include?('axe')
    elsif u[1][1]=='Bow'
      return weapon_legality(event,name,"#{t} Bow#{'+' if w[1].include?('+')}",refinement,true) if u[1][1]=='Bow'
    end
    return weapon_legality(event,name,"#{t} Edge#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"#{t} Lance#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"#{t} Axe#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
    return "~~#{w2}~~" unless u[1][0]=='Colorless'
    w2="#{t} Rod"
    w2="#{w2} (+) #{refinement} Mode" unless refinement.nil? || refinement.length<=0 || refinement=='-'
  elsif ['Fire','Flux','Thunder','Light','Wind'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,'Fire',refinement,true) if u[1][2]=='Fire'
    return weapon_legality(event,name,'Flux',refinement,true) if u[1][2]=='Dark'
    return weapon_legality(event,name,['Fire','Flux'].sample,refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,'Thunder',refinement,true) if u[1][2]=='Thunder'
    return weapon_legality(event,name,'Light',refinement,true) if u[1][2]=='Light'
    return weapon_legality(event,name,['Thunder','Light'].sample,refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,'Wind',refinement,true) if u[1][2]=='Wind'
    return weapon_legality(event,name,['Wind'].sample,refinement,true) if u[1][0]=='Green'
  elsif ['Elfire','Ruin','Elthunder','Ellight','Elwind'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,'Elfire',refinement,true) if u[1][2]=='Fire'
    return weapon_legality(event,name,'Ruin',refinement,true) if u[1][2]=='Dark'
    return weapon_legality(event,name,['Elfire','Ruin'].sample,refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,'Elthunder',refinement,true) if u[1][2]=='Thunder'
    return weapon_legality(event,name,'Ellight',refinement,true) if u[1][2]=='Light'
    return weapon_legality(event,name,['Elthunder','Ellight'].sample,refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,'Elwind',refinement,true) if u[1][2]=='Wind'
    return weapon_legality(event,name,['Elwind'].sample,refinement,true) if u[1][0]=='Green'
  elsif ['Bolganone','Fenrir','Thoron','Shine','Rexcalibur'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Bolganone#{'+' if w[1].include?('+')}",refinement,true) if u[1][2]=='Fire'
    return weapon_legality(event,name,"Fenrir#{'+' if w[1].include?('+')}",refinement,true) if u[1][2]=='Dark'
    return weapon_legality(event,name,"#{['Bolganone','Fenrir'].sample}#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Thoron#{'+' if w[1].include?('+')}",refinement,true) if u[1][2]=='Thunder'
    return weapon_legality(event,name,"Shine#{'+' if w[1].include?('+')}",refinement,true) if u[1][2]=='Light'
    return weapon_legality(event,name,"#{['Thoron','Shine'].sample}#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Rexcalibur#{'+' if w[1].include?('+')}",refinement,true) if u[1][2]=='Wind'
    return weapon_legality(event,name,"#{['Rexcalibur'].sample}#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Armorslayer','Heavy Spear','Hammer'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Armorslayer#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Heavy Spear#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Hammer#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Armorsmasher','Slaying Spear','Slaying Hammer'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Armorsmasher#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Slaying Spear#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Slaying Hammer#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Zanbato','Ridersbane','Poleaxe'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Zanbato#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Ridersbane#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Poleaxe#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Wo Dao','Harmonic Lance','Giant Spoon','Wo Gun'].include?(w[1].gsub('+',''))
    return weapon_legality(event,name,"Wo Dao#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Red'
    return weapon_legality(event,name,"Harmonic Lance#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Blue'
    return weapon_legality(event,name,"Wo Gun#{'+' if w[1].include?('+')}",refinement,true) if u[1][0]=='Green'
  elsif ['Whelp (Infantry)','Hatchling (Flier)'].include?(w[1])
    return weapon_legality(event,name,"Whelp (Infantry)",refinement,true) if u[3]=='Infantry'
    return weapon_legality(event,name,"Hatchling (Flier)",refinement,true) if u[3]=='Flier'
  elsif ['Yearling (Infantry)','Fledgeling (Flier)'].include?(w[1])
    return weapon_legality(event,name,"Yearling (Infantry)",refinement,true) if u[3]=='Infantry'
    return weapon_legality(event,name,"Fledgeling (Flier)",refinement,true) if u[3]=='Flier'
  elsif ['Adult (Infantry)','Adult (Flier)'].include?(w[1])
    return weapon_legality(event,name,"Adult (Infantry)",refinement,true) if u[3]=='Infantry'
    return weapon_legality(event,name,"Adult (Flier)",refinement,true) if u[3]=='Flier'
  end
  return "~~#{w2}~~"
end

def make_banner(event) # used by the `summon` command to pick a random banner and choose which units are on it.
  if File.exist?("#{@location}devkit/FEHBanners.txt")
    b=[]
    File.open("#{@location}devkit/FEHBanners.txt").each_line do |line|
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
  nu=true if bnr[5].include?('Seasonal')
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
  elsif nu && (bnr[0][1].split(', ')[0].split('/')[2].to_i>2020 || (bnr[0][1].split(', ')[0].split('/')[2].to_i==2020 && bnr[0][1].split(', ')[0].split('/')[1].to_i>1))
    # New Heroes and Seasonal banners after Februaury 2020 all have a 4* Focus unit
    fourstar=[]
    for i in 0...u.length
      fourstar.push(u[i][0]) if bnr[2].include?(u[i][0]) && (u[i][9][0].include?('4s') || u[i][9][0].include?('4p'))
    end
    fourstar=nil if fourstar.length<=0
    bnr.push(fourstar)
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
      bnr[3].push(u[i][0]) if u[i][9][0].include?('5p') && u[i][13][0].nil? && u[i][2][0]!='Duo' && (u[i][2][3].nil? || u[i][2][3]!='Duo')
      bnr[4].push(u[i][0]) if u[i][9][0].include?('4p') && u[i][13][0].nil? && u[i][2][0]!='Duo' && (u[i][2][3].nil? || u[i][2][3]!='Duo')
      bnr[5].push(u[i][0]) if u[i][9][0].include?('3p') && u[i][13][0].nil? && u[i][2][0]!='Duo' && (u[i][2][3].nil? || u[i][2][3]!='Duo')
      bnr[6].push(u[i][0]) if u[i][9][0].include?('2p') && u[i][13][0].nil? && u[i][2][0]!='Duo' && (u[i][2][3].nil? || u[i][2][3]!='Duo')
      bnr[7].push(u[i][0]) if u[i][9][0].include?('1p') && u[i][13][0].nil? && u[i][2][0]!='Duo' && (u[i][2][3].nil? || u[i][2][3]!='Duo')
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
    four_focus=0
    if bnr[1]<0 # negative "starting focus" numbers indicate there is no non-focus rate
      sr=(srate[0]/5)*0.5
      sr=100.00 + bnr[1] if srate[0]>=120 && srate[2]%3==2
      b= 0 - bnr[1]
      s5 = [(6.00 - b), 0.00].max
      focus = b + sr * b / (b + s5)
      five_star = s5 + sr * s5 / (b + s5)
      if srate[0]>=120 && srate[2]%3==1
        focus = 50.00
        five_star = 50.00
      end
      four_star = (100.00 - focus - five_star) * 58.00 / (100.00 - b)
      four_focus = 3.00 * four_star / 58.00 if !bnr[8].nil? && bnr[8]!=bnr[2]
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
      four_focus = 3.00 * four_star / 58.00 if !bnr[8].nil? && bnr[8]!=bnr[2]
      three_star = 100.00 - focus - five_star - four_star
      two_star = 0
      one_star = 0
    end
    five_star=0 if focus>=100
    four_focus=0 if focus+five_star>=100
    four_star=0 if focus+five_star+four_focus>=100
    three_star=0 if focus+five_star+four_focus+four_star>=100
    two_star=0 if focus+five_star+four_focus+four_star+three_star>=100
    one_star=0 if focus+five_star+four_focus+four_star+three_star+two_star>=100
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
      elsif four_focus>0
        str2="#{str2}\n~~4\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (four_focus)}%"
        str2="#{str2}\nOther ~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (four_star - four_focus)}%"
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
      elsif four_focus>0
        str2="#{str2}\n4<:Icon_Rarity_4p10:448272714210476033> Focus:  #{'%.2f' % (four_focus)}%"
        str2="#{str2}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % (four_star - four_focus)}%"
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
      elsif !bnr[8].nil? && four_focus>0 && k<focus*100+five_star*100+four_focus+100
        hx=bnr[8].sample
        rx='4<:Icon_Rarity_4p10:448272714210476033>'
        rx='~~4\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if srate[0]>=120 && srate[2]%3==0
        nr=n.sample
      elsif !bnr[8].nil? && four_focus<=0 && k<focus*100+five_star*100+four_star*50
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
      midname="#{bnr[2][i]}"
      midname="#{bnr[2][i]}<:Icon_Rarity_5p10:448272715099406336>" if !bnr[8].nil? && bnr[8]!=bnr[2]
      midname="#{midname}<:Icon_Rarity_4p10:448272714210476033>" if !bnr[8].nil? && bnr[8]!=bnr[2] && bnr[8].include?(bnr[2][i])
      k[0].push(midname) if k2=='Red'
      k[1].push(midname) if k2=='Blue'
      k[2].push(midname) if k2=='Green'
      k[3].push(midname) if k2=='Colorless'
      k[4].push(midname) unless ['Red','Blue','Green','Colorless'].include?(k2)
    end
    unless bnr[8].nil?
      midname=bnr[8].reject{|q| bnr[2].include?(q)}
      for i in 0...midname.length
        k2=untz[untz.find_index{|q| q[0]==midname[i]}][1][0]
        midname2="#{midname[i]}<:Icon_Rarity_4p10:448272714210476033>"
        k[0].push(midname2) if k2=='Red'
        k[1].push(midname2) if k2=='Blue'
        k[2].push(midname2) if k2=='Green'
        k[3].push(midname2) if k2=='Colorless'
        k[4].push(midname2) unless ['Red','Blue','Green','Colorless'].include?(k2)
      end
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
      s5 = [(6.00 - b), 0.00].max
      focus = b + sr * b / (b + s5)
      five_star = s5 + sr * s5 / (b + s5)
      if @summon_rate[0]>=120 && @summon_rate[2]%3==1
        focus = 50.00
        five_star = 50.00
      end
      four_star = (100.00 - focus - five_star) * 58.00 / (100.00 - b)
      four_focus = 0
      four_focus = 3.00 * four_star / 58.00 if !bnr[8].nil? && bnr[8]!=bnr[2]
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
      four_focus = 0
      four_focus = 3.00 * four_star / 58.00 if !bnr[8].nil? && bnr[8]!=bnr[2]
      three_star = 100.00 - focus - five_star - four_star
      two_star = 0
      one_star = 0
    end
    five_star=0 if focus>=100
    four_focus=0 if focus+five_star>=100
    four_star=0 if focus+five_star+four_focus>=100
    three_star=0 if focus+five_star+four_focus+four_star>=100
    two_star=0 if focus+five_star+four_focus+four_star+three_star>=100
    one_star=0 if focus+five_star+four_focus+four_star+three_star+two_star>=100
    fakes=false
    fakes=true if @summon_rate[0]>=120 && @summon_rate[2]%3==0
    str2="#{str2}\n5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % focus}%"
    str2="#{str2}\nOther 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % five_star}%" unless five_star<=0
    if fakes
      if bnr[8].nil?
        str2="#{str2}\n~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104> Unit:  #{'%.2f' % four_star}%" unless four_star<=0
      elsif four_focus>0
        str2="#{str2}\n~~4\\*~~ 5<:Icon_Rarity_5p10:448272715099406336> Focus:  #{'%.2f' % (four_focus)}%"
        str2="#{str2}\nOther ~~4\\*~~ 5<:Icon_Rarity_5:448266417553539104>:  #{'%.2f' % (four_star - four_focus)}%"
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
      elsif four_focus>0
        str2="#{str2}\n4<:Icon_Rarity_4p10:448272714210476033> Focus:  #{'%.2f' % (four_focus)}%"
        str2="#{str2}\nOther 4<:Icon_Rarity_4:448266418459377684>:  #{'%.2f' % (four_star-four_focus)}%"
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
      elsif !bnr[8].nil? && four_focus>0 && k<focus*100+five_star*100+four_focus*100
        hx=bnr[8].sample
        rx='4<:Icon_Rarity_4p10:448272714210476033>'
        rx='~~4\\*(f)~~ 5<:Icon_Rarity_5p10:448272715099406336>' if @summon_rate[0]>=120 && @summon_rate[2]%3==0
        nr=n.sample
      elsif !bnr[8].nil? && four_focus<=0 && k<focus*100+five_star*100+four_star*50
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
          r[0]=dv[1].to_i
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
            r[0]=x[x2][1].to_i
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
        unless k.nil? || k.length<=0
          for i2 in 0...i+1
            k[1]=k[1][1,k[1].length-1] if k[1][0,1]==' '
          end
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
            ['Marth', 0, 0, ['Marth', 'Marth(Groom)', 'Marth(Masked)', 'Marth(King)']],
            ['Robin(F)', 0, 0, ['Robin(F)', 'Robin(F)(Summer)', 'Robin(F)(Fallen)']],
            ['Robin(M)', 0, 0, ['Robin(M)', 'Robin(M)(Winter)', 'Robin(M)(Fallen)', 'Tobin']],
            ['Corrin(F)', 0, 0, ['Corrin(F)(Launch)', 'Corrin(F)(Summer)', 'Corrin(F)(Adrift)', 'Corrin(F)(Fallen)']],
            ['Corrin(M)', 0, 0, ['Corrin(M)(Launch)', 'Corrin(M)(Winter)', 'Corrin(M)(Adrift)', 'Kamui']],
            ['Xander', 0, 0, ['Xander', 'Xander(Bunny)', 'Xander(Summer)', 'Xander(Festival)']],
            ['Tiki', 0, 0, ['Tiki(Young)', 'Tiki(Adult)', 'Tiki(Adult)(Summer)', 'Tiki(Young)(Summer)', 'Tiki(Young)(Earth)', 'Tiki(Young)(Fallen)']],
            ['Lyn', 0, 0, ['Lyn', 'Lyn(Bride)', 'Lyn(Brave)', 'Lyn(Valentines)', 'Lyn(Wind)', 'Lyn(Summer)']],
            ['Chrom', 0, 0, ['Chrom(Launch)', 'Chrom(Bunny)', 'Chrom(Winter)', 'Chrom(Branded)']],
            ['Azura', 0, 0, ['Azura', 'Azura(Performing)', 'Azura(Winter)', 'Azura(Adrift)', 'Azura(Vallite)']],
            ['Camilla', 0, 0, ['Camilla', 'Camilla(Bunny)', 'Camilla(Winter)', 'Camilla(Summer)', 'Camilla(Adrift)', 'Camilla(Bath)', 'Camilla(Brave)']],
            ['Ike', 0, 0, ['Ike', 'Ike(Vanguard)', 'Ike(Brave)', 'Ike(Valentines)']],
            ['Roy', 0, 0, ['Roy', 'Roy(Valentines)', 'Roy(Brave)', 'Roy(Fire)']],
            ['Hector', 0, 0, ['Hector', 'Hector(Valentines)', 'Hector(Marquess)', 'Hector(Brave)', 'Hector(Halloween)']],
            ['Celica', 0, 0, ['Celica', 'Celica(Fallen)', 'Celica(Brave)']],
            ['Takumi', 0, 0, ['Takumi', 'Takumi(Fallen)', 'Takumi(Winter)', 'Takumi(Summer)']],
            ['Ephraim', 0, 0, ['Ephraim', 'Ephraim(Fire)', 'Ephraim(Brave)', 'Ephraim(Winter)', 'Ephraim(Dynastic)']],
            ['Tharja', 0, 0, ['Tharja', 'Tharja(Winter)', 'Tharja(Bride)', 'Rhajat']],
            ['Cordelia', 0, 0, ['Cordelia', 'Cordelia(Bride)', 'Cordelia(Summer)', 'Caeldori']],
            ['Olivia', 0, 0, ['Olivia(Launch)', 'Olivia(Performing)', 'Olivia(Traveler)']],
            ['Ryoma', 0, 0, ['Ryoma', 'Ryoma(Supreme)', 'Ryoma(Festival)', 'Ryoma(Bath)']],
            ['Eirika', 0, 0, ['Eirika(Bonds)', 'Eirika(Memories)', 'Eirika(Graceful)', 'Eirika(Winter)']],
            ['Sakura', 0, 0, ['Sakura', 'Sakura(Halloween)', 'Sakura(Bath)']],
            ['Elise', 0, 0, ['Elise', 'Elise(Summer)', 'Elise(Bath)']],
            ['Hinoka', 0, 0, ['Hinoka(Launch)', 'Hinoka(Wings)', 'Hinoka(Bath)']],
            ['Veronica', 0, 0, ['Veronica', 'Veronica(Brave)', 'Veronica(Bunny)', 'Thrasir']],
            ['Leo', 0, 0, ['Leo', 'Leo(Summer)', 'Leo(Picnic)']],
            ['Alm', 0, 0, ['Alm', 'Alm(Saint)', 'Alm(Brave)']],
            ['Micaiah', 0, 0, ['Micaiah', 'Micaiah(Festival)', 'Micaiah(Brave)']],
            ['Berkut', 0, 0, ['Berkut', 'Berkut(Fallen)', 'Berkut(Soiree)']],
            ['Reinhardt', 0, 0, ['Reinhardt(Bonds)', 'Reinhardt(World)', 'Reinhardt(Soiree)']],
            ['Lilina', 0, 0, ['Lilina', 'Lilina(Valentines)', 'Lilina(Summer)', 'Hector(Halloween)']]]
  colors=[[],[0,0,0,0,0],[0,0,0,0,0]]
  braves=[[],[0,0,0,0,0],[0,0,0,0,0]]
  m=false
  did=-1
  msg=""
  event.channel.send_temporary_message("Message parsed, calculating units...",2)
  resptot=0
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
      summon_type=mxx[9][0].gsub('LU','').gsub('PF','').downcase
    elsif !x.nil? && !x[1].is_a?(Array)
      mxx=find_data_ex(:find_unit,x[1],event)
      name=mxx[0]
      summon_type=mxx[9][0].gsub('LU','').gsub('PF','').downcase
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
      indvresp=false
      if m && find_in_dev_units(name)>=0
        dv=@dev_units[find_in_dev_units(name)]
        r[0]=dv[1].to_i
        indvresp=true if dv[1].include?('r')
        r[1]=dv[2]
        r[2]=dv[3].gsub(' ','')
        r[3]=dv[4].gsub(' ','')
        sup=dv[5]
      elsif did>0
        x=donor_unit_list(did)
        x2=x.find_index{|q| q[0]==name}
        unless x2.nil?
          r[0]=x[x2][1].to_i
          indvresp=true if x[x2][1].include?('r')
          r[1]=x[x2][2]
          r[2]=x[x2][3].gsub(' ','')
          r[3]=x[x2][4].gsub(' ','')
          sup=x[x2][5]
        end
      end
      resptot+=1 if j[9][0].include?('RA') && !indvresp
      st=get_stats(event,name,40,r[0],r[1],r[2],r[3])
      xxxx=0
      xxxx=10 if indvresp
      b.push(st[1]+st[2]+st[3]+st[4]+st[5]+xxxx)
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
      msg=extend_message(msg,"Unit #{u}: #{r[0]}#{rstar} #{name}#{unit_moji(bot,event,-1,name,m)} +#{r[1]} #{"(+#{r[2]}, -#{r[3]})" if !['',' '].include?(r[2]) || !['',' '].include?(r[3])}#{"(neutral)" if ['',' '].include?(r[2]) && ['',' '].include?(r[3])}  \u200B  \u200B  BST: #{b[b.length-1]}  \u200B  \u200B  Score: #{scr[scr.length-1]}+`SP`/100#{"  \u200B  (BST+10, Score+2 if Resplendent)" if j[9][0].include?('RA') && !indvresp}",event)
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

def divine_path(event,name,bot,weapon=nil)
  data_load()
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  u40x=find_unit(name,event)
  if u40x.nil? || u40x.length<=0
    event.respond "No matches found."
    return nil
  elsif u40x[0].is_a?(Array)
    for i in 0...u40x.length
      disp_path(event,u40x[i][0],bot)
    end
    return nil
  end
  if File.exist?("#{@location}devkit/FEHPath.txt")
    b=[]
    File.open("#{@location}devkit/FEHPath.txt").each_line do |line|
      b.push(line)
    end
  else
    b=[]
  end
  b2=[]
  for i in 0...b.length
    b[i]=b[i].gsub("\n",'').split('\\'[0])
    for i2 in 1...b[i].length
      b[i][i2]=b[i][i2].split('; ')
      b[i][i2][1]=b[i][i2][1].to_i
      b[i][i2][2]=b[i][i2][2].split(', ').map{|q| q.to_i}
    end
    b2.push(b[i]) if b[i][1,b[i].length-1].map{|q| q[0]}.include?(u40x[0])
  end
  if b2.length<=0
    event.respond "#{u40x[0]} is unavailable through Divine Paths"
    return nil
  end
  f=[]
  for i in 0...b2.length
    m=[]
    mm=[0,0,false,0,0]
    for i2 in 1...b2[i].length
      b2[i][i2][3]="#{b2[i][i2][1]}#{@rarity_stars[b2[i][i2][1]-1]} #{b2[i][i2][0]}#{unit_moji(bot,event,-1,b2[i][i2][0],false,4)}"
      b2[i][i2][3]="**#{b2[i][i2][3]}**" if b2[i][i2][0]==u40x[0]
      b2[i][i2][4]=[]
      b2[i][i2][4].push("#{b2[i][i2][2][0]}<:Divine_Code:675118366788419584>") if b2[i][i2][2][0]>0
      b2[i][i2][4].push("#{b2[i][i2][2][1]}<:Divine_Code_2:676545832903770117>") if b2[i][i2][2][1]>0
      b2[i][i2][3]="#{b2[i][i2][3]} - #{b2[i][i2][4].join(', ')}" if b2[i][i2][4].length>0
      m.push(b2[i][i2][3])
      mm[0]+=b2[i][i2][2][0]
      mm[1]+=b2[i][i2][2][1]
      if b2[i][i2][0]==u40x[0]
        mm[2]=true
        mm[3]+=b2[i][i2][2][0]
        mm[4]+=b2[i][i2][2][1]
      elsif !mm[2]
        mm[3]+=b2[i][i2][2][0]
        mm[4]+=b2[i][i2][2][1]
      end
    end
    if m.length>1
      m.push('')
      if mm[0]==mm[3] && mm[1]==mm[4]
        mmm=[]
        mmm.push("#{mm[0]}<:Divine_Code:675118366788419584>") if mm[0]>0
        mmm.push("#{mm[1]}<:Divine_Code_2:676545832903770117>") if mm[1]>0
        m.join("*Total - #{mmm.join(', ')}*") if mmm.length>0
      else
        m.push('__Totals__')
        mmm=[]
        mmm.push("#{mm[3]}<:Divine_Code:675118366788419584>") if mm[3]>0
        mmm.push("#{mm[4]}<:Divine_Code_2:676545832903770117>") if mm[4]>0
        m.push("*to #{u40x[0]} - #{mmm.join(', ')}*") if mmm.length>0
        mmm=[]
        mmm.push("#{mm[0]}<:Divine_Code:675118366788419584>") if mm[0]>0
        mmm.push("#{mm[1]}<:Divine_Code_2:676545832903770117>") if mm[1]>0
        m.push("*whole path - #{mmm.join(', ')}*") if mmm.length>0
      end
    end
    f.push([b2[i][0],m.join("\n")])
  end
  f=f.reject{|q| q[1].nil? || q[1].length<=0}
  f=nil if f.length<=0
  pic=pick_thumbnail(event,u40x,bot)
  xcolor=unit_color(event,u40x,u40x[0],0)
  create_embed(event,"__#{'the ' if f.length==1}Divine Path#{'s' unless f.length==1} that **#{u40x[0]}** is on__",'',xcolor,nil,pic,f)
end

def get_effHP(event,name,bot,weapon=nil)
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  flurp=find_stats_in_string(event)
  flurp[5]='' if flurp[5].nil?
  u40x=find_unit(name,event)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  summoner=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  flowers=flurp[8]
  resp=flurp[9]
  untz=@units.map{|q| q}
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Legendary','Mythical') unless blessing[i][0,5]=='Duel('
    end
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Mythical','Legendary') unless blessing[i][0,5]=='Duel('
    end
  end
  blessing.compact!
  unless name=='Robin'
    flowers=[@max_rarity_merge[2],flowers].min unless untz[untz.find_index{|q| q[0]==name}][9][0].include?('PF') && untz[untz.find_index{|q| q[0]==name}][3]=='Infantry'
  end
  args.compact!
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study #{'his' if u40x[10]=='M'}#{'her' if u40x[10]=='F'}#{'their' unless ['M','F'].include?(u40x[10])} effective HP."
      return nil
    end
  end
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  pair_up=[]
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1].to_i
      resp=(@dev_units[dv][1].include?('r'))
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      flowers=@dev_units[dv][6]
      weaponz=@dev_units[dv][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      unless @dev_units[dv][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        pair_up=[@dev_units[dv][14]]
        dv2=find_in_dev_units(pair_up[0])
        if dv2>=0
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],true,2)}",'Pair-Up cohort']
          pair_up[0][2]='Pocket companion' if pair_up[0][0].include?('Sakura')
          pair_up.push(@dev_units[dv2][1].to_i)
          pair_up.push(@dev_units[dv2][2])
          pair_up.push(@dev_units[dv2][3].gsub(' ',''))
          pair_up.push(@dev_units[dv2][4].gsub(' ',''))
          pair_up.push(@dev_units[dv2][5])
          pair_up.push(@dev_units[dv2][6])
          weaponz=@dev_units[dv2][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          pair_up.push(@dev_units[dv2][1].include?('r'))
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=@dev_units[dv2][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],@dev_units[dv2][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1].to_i
      resp=(x[x2][1].include?('r'))
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      flowers=x[x2][6]
      weaponz=x[x2][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      unless x[x2][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        x3=x.find_index{|q| q[0]==x[x2][14]}
        unless x3.nil?
          pair_up=[x[x2][14]]
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],false,2,uid)}",'Pair-Up cohort']
          pair_up.push(x[x3][1].to_i)
          pair_up.push(x[x3][2])
          pair_up.push(x[x3][3].gsub(' ',''))
          pair_up.push(x[x3][4].gsub(' ',''))
          pair_up.push(x[x3][5])
          pair_up.push(x[x3][6])
          weaponz=x[x3][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          pair_up.push(x[x3][1].include?('r'))
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=x[x3][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],x[x3][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    end
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0,0,0]
      else
        w2=find_skill(weapon,event)
      end
      if weapon2=='-'
        w22=['-',0,0,0,0]
      else
        w22=find_skill(weapon2,event)
      end
      diff_num=[w2[4]-w22[4],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=get_bonus_type(event)
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[1]==weapon}
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
  atk='Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  atk='Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='Strength'
    n=n[n.length-1] if atk=='Magic'
    n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane,flowers,resp)
  if !pair_up.nil? && pair_up.length>0
    u40cu=get_stats(event,pair_up[0][0],40,pair_up[1],pair_up[2],pair_up[3],pair_up[4],pair_up[6])
    m=pair_up[10,pair_up.length-10]
    m=[] if m.nil?
    u40cu=apply_stat_skills(event,m,u40cu,'',pair_up[5],pair_up[7],pair_up[8])
    if pair_up[9]
      for i in 2...6
        u40cu[i]+=2
      end
    end
    u40[2]+=(u40cu[2]-25)/10
    u40[3]+=(u40cu[3]-10)/10
    u40[4]+=(u40cu[4]-10)/10
    u40[5]+=(u40cu[5]-10)/10
  end
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,u40x,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|a| a}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed)
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
  x.push(['Misc.',"Defense + Resistance = #{rdr}#{"\n\n#{u40[0]} will take #{photon} extra Photon damage" unless photon=="0"}\n\nRequired to double #{u40[0]}:\n#{rs}#{"\nFull HP" if weapon=='Fell Breath'}#{"\n#{u40[4]+5}+#{" (#{blu40[4]+5}+)" if blu40[4]!=u40[4]} Defense" if weapon=='Great Flame'}#{"\nOutnumber #{u40[0]}'s allies within 2 spaces" if weapon=='Thunder Armads'}#{"\n\nMoonbow becomes better than Glimmer when:\nThe enemy has #{rmg} #{'Defense' if atk=="Strength"}#{'Resistance' if atk=="Magic"}#{'as the lower of Def/Res' if atk=="Freeze"}#{'as their targeted defense stat' if atk=="Attack"}" unless u40x[1][1]=='Healer'}",1])
  ftr="\"Frostbite\" is weapons like Felicia's Plate"
  ftr="#{ftr} and refined dragonstones" if ['Healer','Tome','Bow','Dagger'].include?(u40x[1][1])
  if photon=="0"
    ftr="#{ftr} that deal damage based on lower of Def and Res."
  else
    ftr="#{ftr}.  \"Photon\" is weapons like Light Brand."
  end
  pic=pick_thumbnail(event,u40x,bot,resp)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  create_embed(event,["__#{"Mathoo's " if mu}**#{u40[0]}**__",unit_clss(bot,event,u40x,u40[0])],"#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(u40x,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n",xcolor,ftr,pic,x,5)
end

def study_of_healing(event,name,bot,weapon=nil)
  u40x=find_unit(name,event)
  if name=='Robin' && u40x[0].is_a?(Array)
    u40x=u40x[0]
    u40x[0]='Robin (Shared stats)'
    u40x[1][0]='Cyan'
  end
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[10]=='M'}#{'she does' if u40x[10]=='F'}#{'they do' unless ['M','F'].include?(u40x[10])} with each healing staff."
      return nil
    end
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=remove_prefix(s,event)
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
  transformed=flurp[7]
  flowers=flurp[8]
  resp=flurp[9]
  untz=@units.map{|q| q}
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Legendary','Mythical') unless blessing[i][0,5]=='Duel('
    end
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Mythical','Legendary') unless blessing[i][0,5]=='Duel('
    end
  end
  blessing.compact!
  unless name=='Robin'
    flowers=[@max_rarity_merge[2],flowers].min unless untz[untz.find_index{|q| q[0]==name}][9][0].include?('PF') && untz[untz.find_index{|q| q[0]==name}][3]=='Infantry'
  end
  args.compact!
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  weapon='-' if weapon.nil?
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  pair_up=[]
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1].to_i
      resp=(@dev_units[dv][1].include?('r'))
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      flowers=@dev_units[dv][6]
      weaponz=@dev_units[dv][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      unless @dev_units[dv][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        pair_up=[@dev_units[dv][14]]
        dv2=find_in_dev_units(pair_up[0])
        if dv2>=0
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],true,2)}",'Pair-Up cohort']
          pair_up[0][2]='Pocket companion' if pair_up[0][0].include?('Sakura')
          pair_up.push(@dev_units[dv2][1].to_i)
          pair_up.push(@dev_units[dv2][2])
          pair_up.push(@dev_units[dv2][3].gsub(' ',''))
          pair_up.push(@dev_units[dv2][4].gsub(' ',''))
          pair_up.push(@dev_units[dv2][5])
          pair_up.push(@dev_units[dv2][6])
          weaponz=@dev_units[dv2][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          pair_up.push(@dev_units[dv2][1].include?('r'))
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=@dev_units[dv2][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],@dev_units[dv2][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1].to_i
      resp=(x[x2][1].include?('r'))
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      flowers=x[x2][6]
      weaponz=x[x2][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      unless x[x2][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        x3=x.find_index{|q| q[0]==x[x2][14]}
        unless x3.nil?
          pair_up=[x[x2][14]]
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],false,2,uid)}",'Pair-Up cohort']
          pair_up.push(x[x3][1].to_i)
          pair_up.push(x[x3][2])
          pair_up.push(x[x3][3].gsub(' ',''))
          pair_up.push(x[x3][4].gsub(' ',''))
          pair_up.push(x[x3][5])
          pair_up.push(x[x3][6])
          weaponz=x[x3][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          pair_up.push(x[x3][1].include?('r'))
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=x[x3][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],x[x3][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    end
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0,0,0]
      else
        w2=find_skill(weapon,event)
      end
      if weapon2=='-'
        w22=['-',0,0,0,0]
      else
        w22=find_skill(weapon2,event)
      end
      diff_num=[w2[4]-w22[4],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=get_bonus_type(event)
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[1]==weapon}
  ww2=-1 if ww2.nil?
  w2=sklz[ww2]
  if w2[17].nil?
    refinement=nil
  elsif w2[17].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[17][0,1].to_i.to_s==w2[17][0,1] && refinement=='Effect'
    refinement=nil if w2[17][1,1]=='*'
  elsif w2[17][0,1]=='-' && w2[17][1,1].to_i.to_s==w2[17][1,1] && refinement=='Effect'
    refinement=nil if w2[17][2,1]=='*'
  end
  refinement=nil if w2[7]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[7]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  atk='Attack'
  atk='Magic' if ['Tome','Dragon','Healer'].include?(u40x[1][1])
  atk='Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  atk='Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='Strength'
    n=n[n.length-1] if atk=='Magic'
    n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane,flowers,resp)
  if !pair_up.nil? && pair_up.length>0
    u40cu=get_stats(event,pair_up[0][0],40,pair_up[1],pair_up[2],pair_up[3],pair_up[4],pair_up[6])
    m=pair_up[10,pair_up.length-10]
    m=[] if m.nil?
    u40cu=apply_stat_skills(event,m,u40cu,'',pair_up[5],pair_up[7],pair_up[8])
    if pair_up[9]
      for i in 2...6
        u40cu[i]+=2
      end
    end
    u40[2]+=(u40cu[2]-25)/10
    u40[3]+=(u40cu[3]-10)/10
    u40[4]+=(u40cu[4]-10)/10
    u40[5]+=(u40cu[5]-10)/10
  end
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,u40x,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|q| q}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed) if wl.include?('~~')
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
  staves.push("**Reconcile:** heals target for 7 HP, 17 HP when Imbue triggers, also heals #{u40[0]} for 7 HP\n\n**Martyr:** heals target for #{d} HP, #{i} HP when Imbue triggers, also heals #{u40[0]} for #{s} HP") if event.message.text.downcase.include?(" all")
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
  staves.push("**Martyr+:** heals target for #{d} HP, #{i} HP when Imbue triggers, also heals #{u40[0]} for #{s} HP")
  staves.push("~~How much Martyr[+] heals is based on how much damage *#{u40[0]}* has taken.~~")
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
  pic=pick_thumbnail(event,u40x,bot,resp)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  k="__#{"Mathoo's " if mu}**#{u40[0]}**__\n\n#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(u40x,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n#{unit_clss(bot,event,u40x,u40[0])}"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all") || k.length+staves.join("\n").length>=1950
    event.respond "__#{"Mathoo's " if mu}**#{u40[0]}**__\n\n#{display_stars(bot,event,rarity,merges,summoner,[untz[j][3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(u40x,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n#{unit_clss(bot,event,u40x,u40[0])}"
    event.respond staves.join("\n")
  else
    create_embed(event,["__#{"Mathoo's " if mu}**#{u40[0]}**__",unit_clss(bot,event,u40x,u40[0])],"#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(u40x,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n",xcolor,nil,pic,[["Staves",staves.join("\n")]])
  end
end

def study_of_procs(event,name,bot,weapon=nil)
  u40x=find_unit(name,event)
  if name=='Robin' && u40x[0].is_a?(Array)
    u40x=u40x[0]
    u40x[0]='Robin (Shared stats)'
    u40x[1][0]='Cyan'
  end
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[10]=='M'}#{'she does' if u40x[10]=='F'}#{'they do' unless ['M','F'].include?(u40x[10])} with each proc skill."
      return nil
    end
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=remove_prefix(s,event)
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
  transformed=flurp[7]
  flowers=flurp[8]
  resp=flurp[9]
  untz=@units.map{|q| q}
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Legendary','Mythical') unless blessing[i][0,5]=='Duel('
    end
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Mythical','Legendary') unless blessing[i][0,5]=='Duel('
    end
  end
  blessing.compact!
  unless name=='Robin'
    flowers=[@max_rarity_merge[2],flowers].min unless untz[untz.find_index{|q| q[0]==name}][9][0].include?('PF') && untz[untz.find_index{|q| q[0]==name}][3]=='Infantry'
  end
  args.compact!
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  weapon='-' if weapon.nil?
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  wrathcount=0
  wrathcount+=1 if has_any?(event.message.text.downcase.split(' '),['wrath','wrath1','wrath2','wrath3'])
  wrathcount+=1 if count_in(event.message.text.downcase.split(' '),['wrath','wrath1','wrath2','wrath3'])>=2
  wrathsub=''
  wrathsub='Bushido' if event.message.text.downcase.split(' ').include?('bushido') && u40[0]=='Ryoma(Supreme)'
  pair_up=[]
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      wrathcount=0
      wrathsub=''
      rarity=@dev_units[dv][1].to_i
      resp=(@dev_units[dv][1].include?('r'))
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      flowers=@dev_units[dv][6]
      weaponz=@dev_units[dv][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      wrathcount+=1 if ['Wrath','Wrath 1','Wrath 2','Wrath 3'].include?(@dev_units[dv][10][-1])
      wrathcount+=1 if ['Wrath','Wrath 1','Wrath 2','Wrath 3'].include?(@dev_units[dv][12])
      wrathsub='Bushido' if 'Bushido'==@dev_units[dv][10][-1]
      unless @dev_units[dv][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        pair_up=[@dev_units[dv][14]]
        dv2=find_in_dev_units(pair_up[0])
        if dv2>=0
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],true,2)}",'Pair-Up cohort']
          pair_up[0][2]='Pocket companion' if pair_up[0][0].include?('Sakura')
          pair_up.push(@dev_units[dv2][1].to_i)
          pair_up.push(@dev_units[dv2][2])
          pair_up.push(@dev_units[dv2][3].gsub(' ',''))
          pair_up.push(@dev_units[dv2][4].gsub(' ',''))
          pair_up.push(@dev_units[dv2][5])
          pair_up.push(@dev_units[dv2][6])
          weaponz=@dev_units[dv2][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          pair_up.push(@dev_units[dv2][1].include?('r'))
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=@dev_units[dv2][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],@dev_units[dv2][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      wrathcount=0
      rarity=x[x2][1].to_i
      resp=(x[x2][1].include?('r'))
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      flowers=x[x2][6]
      weaponz=x[x2][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      wrathcount+=1 if ['Wrath','Wrath 1','Wrath 2','Wrath 3'].include?(x[x2][10][-1])
      wrathcount+=1 if ['Wrath','Wrath 1','Wrath 2','Wrath 3'].include?(x[x2][12])
      wrathsub='Bushido' if 'Bushido'==x[x2][10][-1]
      unless x[x2][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        x3=x.find_index{|q| q[0]==x[x2][14]}
        unless x3.nil?
          pair_up=[x[x2][14]]
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],false,2,uid)}",'Pair-Up cohort']
          pair_up.push(x[x3][1].to_i)
          pair_up.push(x[x3][2])
          pair_up.push(x[x3][3].gsub(' ',''))
          pair_up.push(x[x3][4].gsub(' ',''))
          pair_up.push(x[x3][5])
          pair_up.push(x[x3][6])
          weaponz=x[x3][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          pair_up.push(x[x3][1].include?('r'))
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=x[x3][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],x[x3][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    end
  elsif event.message.text.downcase.split(' ').include?('prf') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0,0,0]
      else
        w2=find_skill(weapon,event)
      end
      if weapon2=='-'
        w22=['-',0,0,0,0]
      else
        w22=find_skill(weapon2,event)
      end
      diff_num=[w2[4]-w22[4],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=get_bonus_type(event)
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[0]==weapon}
  ww2=-1 if ww2.nil?
  w2=sklz[ww2]
  if w2[17].nil?
    refinement=nil
  elsif w2[17].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[17][0,1].to_i.to_s==w2[17][0,1] && refinement=='Effect'
    refinement=nil if w2[17][1,1]=='*'
  elsif w2[17][0,1]=='-' && w2[17][1,1].to_i.to_s==w2[17][1,1] && refinement=='Effect'
    refinement=nil if w2[17][2,1]=='*'
  end
  refinement=nil if w2[7]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[7]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  mergetext=''
  if refinement.nil? || refinement.length==0
    m=w2[13]
    m=m.map{|q| q.gsub(/\(T\)\(E\)|\(TE\)|\(E\)\(T\)|\(ET\)/,'(E)').gsub(/\(T\)\(R\)|\(TR\)|\(R\)\(T\)|\(RT\)/,'(R)')} if w2[5].split(', ')[0]=='Beasts Only' && transformed
    m=m.reject{|q| !['(E)','(R)'].include?(q[0,3])}.reject{|q| q[3,5]!='WoDao' && q[3,6]!='Killer' && !['SlowSpecial','SpecialSlow'].include?(q[3,11])}
    mx=['Atk','Spd','Def','Res']
    mx=['Wrathful','Dazzling'] if w2[5]=='Staff Users Only'
    if m.length<=0
    elsif m.length==1 && m[0][0,3]=='(R)'
      mergetext="#{mergetext}\n\n#{w2[0]} has a *#{m[0][3,m[0].length-3]}* effect when refined.  This can affect the proc calculations.\nTo include a refinement, try typing the weapon as \"#{w2[0]} (+) #{mx.sample} Mode\" instead."
    elsif m.length==1 && m[0][0,3]=='(E)'
      mergetext="#{mergetext}\n\n#{w2[0]} has a *#{m[0][3,m[0].length-3]}* effect when refined into its Effect Mode.  This can affect the proc calculations.\nTo include a refinement, try typing the weapon as \"#{w2[0]} (+) Effect Mode\" instead."
    else
      mx.unshift('Effect')
      mergetext="#{mergetext}\n\nThe following effects can be applied to #{w2[0]} via Weapon Refinement.  This can affect the proc calculations."
      m2=m.reject{|q| q[0,3]=='(E)'}.map{|q| q[3,q.length-3]}
      mergetext="#{mergetext}\nAll refinements: #{m2.join(',')}" if m2.length>0
      m2=m.reject{|q| q[0,3]=='(R)'}.map{|q| q[3,q.length-3]}
      mergetext="#{mergetext}\nEffect Mode only: #{m2.join(',')}" if m2.length>0
      mergetext="#{mergetext}\nTo include a refinement, try typing the weapon as \"#{w2[0]} (+) #{mx.sample} Mode\" instead."
    end
  end
  if w2[5].split(', ')[0]=='Beasts Only' && !transformed
    m=w2[13]
    unless refinement.nil? || refinement.length==0
      m=m.map{|q| q.gsub(/\(T\)\(R\)|\(TR\)|\(R\)\(T\)|\(RT\)/,'(T)')}
      m=m.map{|q| q.gsub(/\(T\)\(E\)|\(TE\)|\(E\)\(T\)|\(ET\)/,'(T)')} if refinement=='Effect'
    end
    m=m.reject{|q| q[0,3]!='(T)'}.reject{|q| q[3,5]!='WoDao' && q[3,6]!='Killer' && !['SlowSpecial','SpecialSlow'].include?(q[3,11])}
    if m.length<=0
    elsif m.length==1
      mergetext="#{mergetext}\n\n#{w2[0]} has a *#{m[0][3,m[0].length-3]}* effect when #{u40x[0]} is transformed.\nTo show #{u40x[0]}'s data when transformed, include the word \"Transformed\" in your message."
    else
      mergetext="#{mergetext}\n\nWhen #{u40x[0]} is transformed, #{w2[0]} also has the following effects:\n#{m.join(', ')}\nTo show #{u40x[0]}'s data when transformed, include the word \"Transformed\" in your message."
    end
  end
  atk='Attack'
  atk='Magic' if ['Tome','Dragon','Healer'].include?(u40x[1][1])
  atk='Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  atk='Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='Strength'
    n=n[n.length-1] if atk=='Magic'
    n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane,flowers,resp)
  if !pair_up.nil? && pair_up.length>0
    u40cu=get_stats(event,pair_up[0][0],40,pair_up[1],pair_up[2],pair_up[3],pair_up[4],pair_up[6])
    m=pair_up[10,pair_up.length-10]
    m=[] if m.nil?
    u40cu=apply_stat_skills(event,m,u40cu,'',pair_up[5],pair_up[7],pair_up[8])
    if pair_up[9]
      for i in 2...6
        u40cu[i]+=2
      end
    end
    u40[2]+=(u40cu[2]-25)/10
    u40[3]+=(u40cu[3]-10)/10
    u40[4]+=(u40cu[4]-10)/10
    u40[5]+=(u40cu[5]-10)/10
  end
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,u40x,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|q| q}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed) if wl.include?('~~')
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
  if wrathcount>=1
    wdamage+=10
    wdamage2+=10
    stat_skills.push('Wrath')
  end
  if wrathcount>=2
    wdamage+=10
    wdamage2+=10
    stat_skills.push('Wrath')
  end
  if wrathsub.length>0
    wdamage+=10
    wdamage2+=10
    stat_skills.push(wrathsub)
  end
  wdamage+=10 if has_weapon_tag2?('WoDao',sklz[ww2],refinement,transformed)
  wdamage2+=10 if has_weapon_tag2?('WoDao',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  cdwn=0
  cdwn-=1 if has_weapon_tag2?('Killer',sklz[ww2],refinement,transformed)
  cdwn+=1 if has_weapon_tag2?('SlowSpecial',sklz[ww2],refinement,transformed) || has_weapon_tag2?('SpecialSlow',sklz[ww2],refinement,transformed)
  cdwn2=0
  cdwn2=cdwn unless wl.include?('~~')
  cdwns=cdwn
  cdwns="~~#{cdwn}~~ #{cdwn2}" unless cdwn2==cdwn
  staves=[[],[],[],[],[],[],[],[],[],[]]
  g=get_markers(event) 
  procs=@skills.reject{|q| !has_any?(g, q[15]) || q[6]!='Special'}
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Star',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag2?('WoDao_Star',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Night Sky',1)[4],cdwns)
  d="`dmg /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`dmg /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Night Sky - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Astra',1)[4],cdwns)
  d="`3* dmg /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`3* dmg /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Astra - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Regnal Astra',1)[4],cdwns)
  d="#{spdd*2/5+wdamage+czz}#{" (#{blspdd*2/5+wdamage+czz})" unless spdd*2/5==blspdd*2/5}"
  cd="#{crspdd*2/5+wdamage2+czz2}#{" (#{crblspdd*2/5+wdamage2+czz2})" unless crspdd*2/5==crblspdd*2/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[0].push("**Regnal Astra - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Regnal Astra',1)[8].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Glimmer',1)[4],cdwns)
  d="`dmg /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`dmg /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[0].push("Glimmer - #{d}, cooldown of #{c}")
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Moon',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag2?('WoDao_Moon',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'New Moon',1)[4],cdwns)
  d="`3* eDR /10#{" +#{wdamage+czz}" if wdamage+czz2>0}`"
  d2="`3* eDR /10#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("New Moon - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Luna',1)[4],cdwns)
  d="`eDR /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`eDR /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("Luna - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Black Luna',1)[4],cdwns)
  d="`4* eDR /5#{" +#{wdamage+czz}" if wdamage+czz2>0}`"
  d2="`4* eDR /5#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("**Black Luna - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Black Luna',1)[8].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Moonbow',1)[4],cdwns)
  d="`3* eDR /10#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`3* eDR /10#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("Moonbow - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Lunar Flash',1)[4],cdwns)
  d="`eDR /5 +#{wdamage+czz+spdd/5}`#{" (`eDR /5 +#{wdamage+czz+blspdd/5}`)" unless spdd/5==blspdd/5}"
  d2="`eDR /5 +#{wdamage2+czz2+crspdd/5}`#{" (`eDR /5 +#{wdamage+czz+crblspdd/5}`)" unless crspdd/5==crblspdd/5}"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[1].push("**Lunar Flash - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Lunar Flash',1)[8].split(', ').include?(u40[0])
  wd="#{"#{wdamage}, " if wdamage>0}"
  wd="~~#{wdamage}~~ #{wdamage2}, " unless wdamage==wdamage2
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Sun',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag2?('WoDao_Sun',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Daylight',1)[4],cdwns)
  d="`3* #{"(" if wdamage+czz>0}dmg#{" +#{wdamage+czz})" if wdamage+czz>0} /10`"
  d2="`3* #{"(" if wdamage2+czz2>0}dmg#{" +#{wdamage2+czz2})" if wdamage2+czz2>0} /10`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Daylight - #{wd}heals for #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Sol',1)[4],cdwns)
  d="`#{"(" if wdamage+czz>0}dmg#{" +#{wdamage+czz})" if wdamage+czz>0} /2`"
  d2="`#{"(" if wdamage2+czz2>0}dmg#{" +#{wdamage2+czz2})" if wdamage2+czz2>0} /2`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Sol - #{wd}heals for #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Noontime',1)[4],cdwns)
  d="`3* #{"(" if wdamage+czz>0}dmg#{" +#{wdamage+czz})" if wdamage+czz>0} /10`"
  d2="`3* #{"(" if wdamage2+czz2>0}dmg#{" +#{wdamage2+czz2})" if wdamage2+czz2>0} /10`"
  d="~~#{d}~~ #{d2}" unless d==d2
  staves[2].push("Noontime - #{wd}heals for #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Sirius',1)[4],cdwns)
  d="#{spdd*3/10+wdamage+czz}#{" (#{blspdd*3/10+wdamage+czz})" unless spdd*3/10==blspdd*3/10}"
  cd="#{crspdd*3/10+wdamage2+czz2}#{" (#{crblspdd*3/10+wdamage2+czz2})" unless crspdd*3/10==crblspdd*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  h="`3*dmg/10#{" + #{(wdamage+czz+(spdd*3/10))*3/10}" unless (wdamage+czz+(spdd*3/10))*3/10==0}`"
  h2="`3*dmg/10#{" + #{(wdamage2+czz2+(crspdd*3/10))*3/10}" unless (wdamage2+czz2+(crspdd*3/10))*3/10==0}`"
  h="~~#{h}~~ #{h2}" unless h==h2
  staves[3].push("**Sirius - #{d}, heals for #{h}, cooldown of #{c}**") if get_match_in_list(procs, 'Sirius',1)[8].split(', ').include?(u40[0])
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Sun',sklz[ww2],refinement,transformed) || has_weapon_tag2?('WoDao_Moon',sklz[ww2],refinement,transformed) || has_weapon_tag2?('WoDao_Eclipse',sklz[ww2],refinement,transformed)
  czz2+=10 if (has_weapon_tag2?('WoDao_Sun',sklz[ww2],refinement,transformed) || has_weapon_tag2?('WoDao_Moon',sklz[ww2],refinement,transformed) || has_weapon_tag2?('WoDao_Eclipse',sklz[ww2],refinement,transformed)) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Aether',1)[4],cdwns)
  d="`eDR /2#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  d2="`eDR /2#{" +#{wdamage2+czz2}" if wdamage2+czz2>0}`"
  d="~~#{d}~~ #{d2}" unless d==d2
  h="`#{"(" if wdamage+czz>0}dmg#{" +#{wdamage+czz})" if wdamage+czz>0} /2 + eDR /4`"
  h2="`#{"(" if wdamage2+czz2>0}dmg#{" +#{wdamage2+czz2})" if wdamage2+czz2>0} /2 + eDR /4`"
  h="~~#{h}~~ #{h2}" unless h==h2
  staves[3].push("Aether - #{d}, heals for #{h}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Radiant Aether',1)[4],cdwns)
  staves[3].push("**Radiant Aether - #{d}, heals for #{h}, cooldown of #{c}**") if get_match_in_list(procs, 'Radiant Aether',1)[8].split(', ').include?(u40[0])
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Fire',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag2?('WoDao_Fire',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Glowing Ember',1)[4],cdwns)
  d="#{deff/2+wdamage+czz}#{" (#{bldeff/2+wdamage+czz})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2+czz2}#{" (#{crbldeff/2+wdamage2+czz2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Glowing Ember - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Ignis',1)[4],cdwns)
  d="#{deff*4/5+wdamage+czz}#{" (#{bldeff*4/5+wdamage+czz})" unless deff*4/5==bldeff*4/5}"
  cd="#{crdeff*4/5+wdamage2+czz2}#{" (#{crbldeff*4/5+wdamage2+czz2})" unless crdeff*4/5==crbldeff*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Ignis - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Bonfire',1)[4],cdwns)
  d="#{deff/2+wdamage+czz}#{" (#{bldeff/2+wdamage+czz})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2+czz2}#{" (#{crbldeff/2+wdamage2+czz2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Bonfire - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Open the Future',1)[4],cdwns)
  d="#{deff/2+wdamage+czz}#{" (#{bldeff/2+wdamage+czz})" unless deff/2==bldeff/2}"
  cd="#{crdeff/2+wdamage2+czz2}#{" (#{crbldeff/2+wdamage2+czz2})" unless crdeff/2==crbldeff/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  h="#{deff/8+wdamage/4+czz/4}#{" (#{bldeff/8+wdamage/4+czz/4})" unless deff/8==bldeff/8}"
  ch="#{crdeff/8+wdamage2/4+czz2/4}#{" (#{crbldeff/8+wdamage2/4+czz2/4})" unless crdeff/8==crbldeff/8}"
  h="~~#{h}~~ #{ch}" unless h==ch
  staves[4].push("**Open the Future** - #{d}, heals for `dmg/4+#{h}`, cooldown of #{c}") if get_match_in_list(procs, 'Open the Future',1)[8].split(', ').include?(u40[0])
  c=add_number_to_string(get_match_in_list(procs, 'Blue Flame',1)[4],cdwns)
  d="#{wdamage+czz}-#{10+wdamage+czz}"
  cd="#{wdamage2+czz2}-#{10+wdamage2+czz2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  dx="#{d}"
  d="#{wdamage+czz}-#{25+wdamage+czz}"
  cd="#{wdamage2+czz2}-#{25+wdamage2+czz2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[4].push("Blue Flame - #{dx} (#{d} when adjacent to an ally), cooldown of #{c}")
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Ice',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag2?('WoDao_Ice',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Chilling Wind',1)[4],cdwns)
  d="#{ress/2+wdamage+czz}#{" (#{blress/2+wdamage+czz})" unless ress/2==blress/2}"
  cd="#{crress/2+wdamage2+czz2}#{" (#{crblress/2+wdamage2+czz2})" unless crress/2==crblress/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Chilling Wind - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Glacies',1)[4],cdwns)
  d="#{ress*4/5+wdamage+czz}#{" (#{blress*4/5+wdamage+czz})" unless ress*4/5==blress*4/5}"
  cd="#{crress*4/5+wdamage2+czz2}#{" (#{crblress*4/5+wdamage2+czz2})" unless crress*4/5==crblress*4/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Glacies - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Iceberg',1)[4],cdwns)
  d="#{ress/2+wdamage+czz}#{" (#{blress/2+wdamage+czz})" unless ress/2==blress/2}"
  cd="#{crress/2+wdamage2+czz2}#{" (#{crblress/2+wdamage2+czz2})" unless crress/2==crblress/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("Iceberg - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Twin Blades',1)[4],cdwns)
  d="#{ress*2/5+wdamage+czz}#{" (#{blress*2/5+wdamage+czz})" unless ress*2/5==blress*2/5}"
  cd="#{crress*2/5+wdamage2+czz2}#{" (#{crblress*2/5+wdamage2+czz2})" unless crress*2/5==crblress*2/5}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[5].push("**Twin Blades - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Twin Blades',1)[8].split(', ').include?(u40[0])
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Fire',sklz[ww2],refinement,transformed) || has_weapon_tag2?('WoDao_Ice',sklz[ww2],refinement,transformed) || has_weapon_tag2?('WoDao_Freezeflame',sklz[ww2],refinement,transformed)
  czz2+=10 if (has_weapon_tag2?('WoDao_Fire',sklz[ww2],refinement,transformed) || has_weapon_tag2?('WoDao_Ice',sklz[ww2],refinement,transformed) || has_weapon_tag2?('WoDao_Freezeflame',sklz[ww2],refinement,transformed)) && !wl.include?('~~')
  if procs.map{|q| q[1]}.include?('Freezeflame')
    c=add_number_to_string(get_match_in_list(procs, 'Freezeflame',1)[4],cdwns)
    d="#{deff/2+ress/2+wdamage+czz}#{" (#{bldeff/2+blress/2+wdamage+czz})" unless ress/2==blress/2}"
    cd="#{crdeff/2+crress/2+wdamage2+czz2}#{" (#{crbldeff/2+crblress/2+wdamage2+czz2})" unless crress/2==crblress/2}"
    d="~~#{d}~~ #{cd}" unless d==cd
    staves[6].push("Freezeflame - #{d}, cooldown of #{c}") if get_match_in_list(procs, 'Freezeflame',1)[8].split(', ').include?(u40[0])
  end
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Dragon',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag2?('WoDao_Dragon',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Dragon Gaze',1)[4],cdwns)
  d="#{atkk*3/10+wdamage+czz}#{" (#{blatkk*3/10+wdamage+czz})" unless atkk*3/10==blatkk*3/10}"
  cd="#{cratkk*3/10+wdamage2+czz2}#{" (#{crblatkk*3/10+wdamage2+czz2})" unless cratkk*3/10==crblatkk*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Dragon Gaze - Up to #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Dragon Fang',1)[4],cdwns)
  d="#{atkk/2+wdamage+czz}#{" (#{blatkk/2+wdamage+czz})" unless atkk/2==blatkk/2}"
  cd="#{cratkk/2+wdamage2+czz2}#{" (#{crblatkk/2+wdamage2+czz2})" unless cratkk/2==crblatkk/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Dragon Fang - Up to #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Draconic Aura',1)[4],cdwns)
  d="#{atkk*3/10+wdamage+czz}#{" (#{blatkk*3/10+wdamage+czz})" unless atkk*3/10==blatkk*3/10}"
  cd="#{cratkk*3/10+wdamage2+czz2}#{" (#{crblatkk*3/10+wdamage2+czz2})" unless cratkk*3/10==crblatkk*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("Draconic Aura - Up to #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Fire Emblem',1)[4],cdwns)
  d="#{spdd*3/10+wdamage+czz}#{" (#{blspdd*3/10+wdamage+czz})" unless spdd*3/10==blspdd*3/10}"
  cd="#{crspdd*3/10+wdamage2+czz2}#{" (#{crblspdd*3/10+wdamage2+czz2})" unless crspdd*3/10==crblspdd*3/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[7].push("**Fire Emblem - #{d}, cooldown of #{c}**") if get_match_in_list(procs, 'Fire Emblem',1)[8].split(', ').include?(u40[0])
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Darkness',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag2?('WoDao_Darkness',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Retribution',1)[4],cdwns)
  d="#{wdamage+czz}-#{3*hppp/10+wdamage+czz}#{" (#{wdamage+czz}-#{3*blhppp/10+wdamage+czz}) based on HP lost" if 3*hppp/10!=3*blhppp/10}"
  cd="#{wdamage2+czz2}-#{3*crhppp/10+wdamage2+czz2}#{" (#{wdamage2+czz2}-#{3*crblhppp/10+wdamage2+czz2}) based on HP lost" if 3*crhppp/10!=3*crblhppp/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[8].push("Retribution - #{d}, cooldown of #{c}") if event.message.text.downcase.include?(" all")
  c=add_number_to_string(get_match_in_list(procs, 'Vengeance',1)[4],cdwns)
  d="#{wdamage+czz}-#{hppp/2+wdamage+czz}#{" (#{wdamage+czz}-#{blhppp/2+wdamage+czz}) based on HP lost" if hppp/2!=blhppp/2}"
  cd="#{wdamage2+czz2}-#{crhppp/2+wdamage2+czz2}#{" (#{wdamage2+czz2}-#{crblhppp/2+wdamage2+czz2}) based on HP lost" if crhppp/2!=crblhppp/2}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[8].push("Vengeance - #{d}, cooldown of #{c}")
  c=add_number_to_string(get_match_in_list(procs, 'Reprisal',1)[4],cdwns)
  d="#{wdamage+czz}-#{3*hppp/10+wdamage+czz}#{" (#{wdamage+czz}-#{3*blhppp/10+wdamage+czz}) based on HP lost" if 3*hppp/10!=3*blhppp/10}"
  cd="#{wdamage2+czz2}-#{3*crhppp/10+wdamage2+czz2}#{" (#{wdamage2+czz2}-#{3*crblhppp/10+wdamage2+czz2}) based on HP lost" if 3*crhppp/10!=3*crblhppp/10}"
  d="~~#{d}~~ #{cd}" unless d==cd
  staves[8].push("Reprisal - #{d}, cooldown of #{c}")
  czz=0
  czz2=0
  czz+=10 if has_weapon_tag2?('WoDao_Rend',sklz[ww2],refinement,transformed)
  czz2+=10 if has_weapon_tag2?('WoDao_Rend',sklz[ww2],refinement,transformed) && !wl.include?('~~')
  c=add_number_to_string(get_match_in_list(procs, 'Ruptured Sky',1)[4],cdwns)
  d="`eAtk \* X /5#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  cd="`eAtk \* X /5#{" +#{wdamage+czz}" if wdamage+czz>0}`"
  staves[9].push("Ruptured Sky - #{d}, where X is 2 against dragons/beasts and 1 against everyone else, cooldown of #{c}")
  pic=pick_thumbnail(event,u40x,bot,resp)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  k="__#{"Mathoo's " if mu}**#{u40[0]}**__\n\n#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(u40x,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n#{unit_clss(bot,event,u40x,u40[0])}#{mergetext}\n\neDR = Enemy Def/Res, DMG = Damage dealt by non-proc calculations"
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(" all") || k.length+staves.map{|q| q.join("\n")}.join("\n\n").length>=1950
    event.respond "__#{"Mathoo's " if mu}**#{u40[0]}**__\n\n#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(u40x,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n#{unit_clss(bot,event,u40x,u40[0])}#{mergetext}\n\neDR = Enemy Def/Res, eAtk = Enemy Atk, DMG = Damage dealt by non-proc calculations"
    s=""
    for i in 0...staves.length
      s=extend_message(s,staves[i].join("\n"),event,2) unless staves[i].length.zero?
    end
    event.respond s
  else
    flds=[["<:Special_Offensive_Star:454473651396542504>Star",staves[0],1],["<:Special_Offensive_Moon:454473651345948683>Moon",staves[1]],["<:Special_Offensive_Sun:454473651429965834>Sun",staves[2]],["<:Special_Offensive_Eclipse:454473651308199956>Eclipse",staves[3],1],["<:Special_Offensive_Fire:454473651861979156>Fire",staves[4]],["<:Special_Offensive_Ice:454473651291422720>Ice",staves[5]],["<:Special_Offensive_Fire:454473651861979156><:Special_Offensive_Ice:454473651291422720>Freezeflame",staves[6]],["<:Special_Offensive_Dragon:454473651186696192>Dragon",staves[7],1],["<:Special_Offensive_Darkness:454473651010535435>Darkness",staves[8]],["<:Special_Offensive_Rend:454473651119718401>Rend",staves[9]]]
    for i in 0...flds.length
      if flds[i][1].length.zero?
        flds[i]=nil
      else
        flds[i][1]=flds[i][1].join("\n")
      end
    end
    flds.compact!
    create_embed(event,["__#{"Mathoo's " if mu}**#{u40[0]}**__",unit_clss(bot,event,u40x,u40[0])],"#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{display_stat_skills(u40x,stat_skills,stat_skills_2,nil,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}#{mergetext}\n",xcolor,"eDR = Enemy Def/Res, eAtk = Enemy Atk, DMG = Damage dealt by non-proc calculations",pic,flds)
  end
end

def study_of_banners(event,name,bot)
  b=[]
  if File.exist?("#{@location}devkit/FEHBanners.txt")
    b=[]
    File.open("#{@location}devkit/FEHBanners.txt").each_line do |line|
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
        # puts b[i][2][i2].to_s
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
          tm="\n*Duration:* #{t[0][0]} #{mo[t[0][1]]} #{t[0][2]} - #{t[1][0]} #{mo[t[1][1]]} #{t[1][2]}" if t.length>1
          tm="\n*Duration:* #{t[0][0]} #{mo[t[0][1]]} #{t[0][2]} - >Unknown<" unless t.length>1
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
  if j[9][0].include?('5p') && j[2][0]!='Duo' && (j[2][3].nil? || j[2][3]!='Duo')
    k=untz.reject{|q| !q[9][0].include?('5p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j) || j[9][0].include?('TD')
    k2=untz.reject{|q| !q[9][0].include?('5p') || q[9][0].include?('TD') || !q[13][0].nil?}
    k2.push(j) unless k2.include?(j)
    non_focus[0].push("5<:Icon_Rarity_5:448266417553539104> Non-Focus (New/Special Heroes) - #{len % (five_star[0]/k2.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (five_star[0]/k2.length)}% (Actual)") unless five_star[0]<=0 || j[9][0].include?('TD')
    non_focus[0].push("5<:Icon_Rarity_5:448266417553539104> Non-Focus (Other banners) - #{len % (five_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (five_star[0]/k.length)}% (Actual)") unless five_star[0]<=0
    non_focus[1].push("5<:Icon_Rarity_5:448266417553539104> Non-Focus (Hero Fest only) - #{len % (five_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (five_star[1]/k.length)}% (Actual)") unless five_star[1]<=0
  end
  if j[9][0].include?('4p')
    k=untz.reject{|q| !q[9][0].include?('4p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
    non_focus[0].push("4<:Icon_Rarity_4:448266418459377684> (standard banner) - #{len % (four_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (four_star[0]/k.length)}% (Actual)") unless four_star[0]<=0
    non_focus[0].push("4<:Icon_Rarity_4:448266418459377684> Non-Focus - #{len % ((four_star[0]/2)/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % ((four_star[0]/2)/k.length)}% (Actual)") unless four_star[0]<=0
    non_focus[1].push("4<:Icon_Rarity_4:448266418459377684> all the time - #{len % (four_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (four_star[1]/k.length)}% (Actual)") unless four_star[1]<=0
  end
  if j[9][0].include?('3p')
    k=untz.reject{|q| !q[9][0].include?('3p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
    non_focus[0].push("3<:Icon_Rarity_3:448266417934958592> all the time - #{len % (three_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (three_star[0]/k.length)}% (Actual)") unless three_star[0]<=0
    non_focus[1].push("3<:Icon_Rarity_3:448266417934958592> all the time - #{len % (three_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (three_star[1]/k.length)}% (Actual)") unless three_star[1]<=0
  end
  if j[9][0].include?('2p')
    k=untz.reject{|q| !q[9][0].include?('2p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
    non_focus[0].push("2<:Icon_Rarity_2:448266417872044032> all the time - #{len % (two_star[0]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (two_star[0]/k.length)}% (Actual)") unless two_star[0]<=0
    non_focus[1].push("2<:Icon_Rarity_2:448266417872044032> all the time - #{len % (two_star[1]/k.reject{|q| q[1][0]!=j[1][0]}.length)}% (Perceived), #{len % (two_star[1]/k.length)}% (Actual)") unless two_star[1]<=0
  end
  if j[9][0].include?('1p')
    k=untz.reject{|q| !q[9][0].include?('1p') || !q[13][0].nil?}
    k.push(j) unless k.include?(j)
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
    summon_type[6].push("~~Unavailable on New/Special Heroes banners~~") if rardata.include?('td')
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
    if j[9][1].nil?
      summon_type=['Unobtainable'] if summon_type.nil? || summon_type.length.zero?
      summon_type=summon_type.join("\n")
      banners.unshift(summon_type)
    else
      summon_type=summon_type.join("\n")
      banners.unshift(summon_type)
    end
  end
  if banners.length>0
    if j[9][1].nil?
      banners[0]="__**Debut:**__\n#{banners[0]}"
    else
      fgg=j[9][0].split('p')[0].split('s')[0]
      ffgg=[]
      if fgg.length>1
        fgg=fgg[0,fgg.length-1]
        summon_type=[[],[],[],[],[],[],[]]
        for m in 1...@max_rarity_merge[0]+1
          summon_type[1].push("#{m}#{@rarity_stars[m-1]}") if fgg.include?("#{m}d") # Daily Rotation Heroes
          summon_type[2].push("#{m}#{@rarity_stars[m-1]}") if fgg.include?("#{m}g") # Grand Hero Battles
          summon_type[3].push("#{m}#{@rarity_stars[m-1]}") if fgg.include?("#{m}f") # free heroes
          summon_type[4].push("#{m}#{@rarity_stars[m-1]}") if fgg.include?("#{m}q") # quest rewards
          summon_type[5].push("#{m}#{@rarity_stars[m-1]}") if fgg.include?("#{m}t") # Tempest Trials rewards
          summon_type[6].push("Seasonal #{m}#{@rarity_stars[m-1]} summon") if fgg.include?("#{m}s")
          summon_type[6].push("Story unit starting at #{m}#{@rarity_stars[m-1]}") if fgg.include?("#{m}y")
          summon_type[6].push("Purchasable at #{m}#{@rarity_stars[m-1]}") if fgg.include?("#{m}b")
          summon_type[6].push("Grail summon at #{m}#{@rarity_stars[m-1]}") if fgg.include?("#{m}r")
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
        ffgg=summon_type.map{|q| q}
      end
      banners[0]="#{"__**First appeared as**__\n#{ffgg.join("\n")}\n\n" if ffgg.length>0}__**Joined the summon pool during:**__\n#{j[9][1,j[9].length-1].join(', ')}"
    end
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
  hdr="__Banners **#{j[0]}** has been on__#{"\nBanners in **+#{star_buff}** form (after #{star_buff*5} to #{star_buff*5+4} failures to get a 5<:Icon_Rarity_5:448266417553539104>)" if star_buff>0}"
  hdr="__Banners **#{j[0]}** has been on__\nBanners in **Omega** form (after 120 failures to get a 5<:Icon_Rarity_5:448266417553539104>)" if star_buff>=24
  if banners.join("\n#{"\n" unless justnames}").length>1900 || @embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    msg=hdr.split(' ').join(' ')
    for i in 0...banners.length
      msg=extend_message(msg,banners[i],event,1,"\n#{"\n" unless justnames}")
    end
    event.respond msg
  else
    create_embed(event,hdr,banners.join("\n#{"\n" unless justnames}"),unit_color(event,j),ftr,pick_thumbnail(event,j,bot),nil,4)
  end
end

def study_of_phases(event,name,bot,weapon=nil)
  u40x=find_unit(name,event)
  if name=='Robin' && u40x[0].is_a?(Array)
    u40x=u40x[0]
    u40x[0]='Robin (Shared stats)'
    u40x[1][0]='Cyan'
  end
  if u40x[4].nil? || (u40x[4].max<=0 && u40x[5].max<=0)
    unless u40x[0]=='Kiran'
      event.respond "#{u40x[0]} does not have official stats.  I cannot study how #{'he does' if u40x[10]=='M'}#{'she does' if u40x[10]=='F'}#{'they do' unless ['M','F'].include?(u40x[10])} in each phase."
      return nil
    end
  end
  data_load()
  weapon='-' if weapon.nil?
  s=event.message.text
  s=remove_prefix(s,event)
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
  transformed=flurp[7]
  flowers=flurp[8]
  resp=flurp[9]
  untz=@units.map{|q| q}
  if untz.find_index{|q| q[0]==name}.nil?
  elsif ['Fire','Earth','Water','Wind'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Legendary','Mythical') unless blessing[i][0,5]=='Duel('
    end
  elsif ['Light','Dark','Astra','Anima'].include?(untz[untz.find_index{|q| q[0]==name}][2][0])
    for i in 0...blessing.length
      blessing[i]=blessing[i].gsub('Mythical','Legendary') unless blessing[i][0,5]=='Duel('
    end
  end
  blessing.compact!
  unless name=='Robin'
    flowers=[@max_rarity_merge[2],flowers].min unless untz[untz.find_index{|q| q[0]==name}][9][0].include?('PF') && untz[untz.find_index{|q| q[0]==name}][3]=='Infantry'
  end
  args.compact!
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  weapon='-' if weapon.nil?
  stat_skills=make_stat_skill_list_1(name,event,args)
  mu=false
  pair_up=[]
  if event.message.text.downcase.include?("mathoo's")
    devunits_load()
    dv=find_in_dev_units(name)
    if dv>=0
      mu=true
      rarity=@dev_units[dv][1].to_i
      resp=(@dev_units[dv][1].include?('r'))
      merges=@dev_units[dv][2]
      boon=@dev_units[dv][3].gsub(' ','')
      bane=@dev_units[dv][4].gsub(' ','')
      summoner=@dev_units[dv][5]
      flowers=@dev_units[dv][6]
      weaponz=@dev_units[dv][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      unless @dev_units[dv][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        pair_up=[@dev_units[dv][14]]
        dv2=find_in_dev_units(pair_up[0])
        if dv2>=0
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],true,2)}",'Pair-Up cohort']
          pair_up[0][2]='Pocket companion' if pair_up[0][0].include?('Sakura')
          pair_up.push(@dev_units[dv2][1].to_i)
          pair_up.push(@dev_units[dv2][2])
          pair_up.push(@dev_units[dv2][3].gsub(' ',''))
          pair_up.push(@dev_units[dv2][4].gsub(' ',''))
          pair_up.push(@dev_units[dv2][5])
          pair_up.push(@dev_units[dv2][6])
          weaponz=@dev_units[dv2][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          pair_up.push(@dev_units[dv2][1].include?('r'))
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=@dev_units[dv2][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],@dev_units[dv2][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    elsif @dev_nobodies.include?(name)
      event.respond "Mathoo has this character but doesn't care enough about including their stats.  Showing neutral stats."
    elsif @dev_waifus.include?(name) || @dev_somebodies.include?(name)
      event.respond 'Mathoo does not have that character...but not for a lack of wanting.  Showing neutral stats.'
    else
      event.respond 'Mathoo does not have that character.  Showing neutral stats.'
    end
  elsif donate_trigger_word(event)>0
    uid=donate_trigger_word(event)
    x=donor_unit_list(uid)
    x2=x.find_index{|q| q[0]==name}
    if x2.nil?
      event.respond "#{bot.user(uid).name} does not have that character, or did not feel like adding that character.  Showing neutral stats."
    else
      rarity=x[x2][1].to_i
      resp=(x[x2][1].include?('r'))
      merges=x[x2][2]
      boon=x[x2][3].gsub(' ','')
      bane=x[x2][4].gsub(' ','')
      summoner=x[x2][5]
      flowers=x[x2][6]
      weaponz=x[x2][7].reject{|q| q.include?('~~')}
      weapon=weaponz[weaponz.length-1]
      if weapon.nil?
        weapon='-'
      elsif weapon.include?(' (+) ')
        w=weapon.split(' (+) ')
        weapon=w[0]
        refinement=w[1].gsub(' Mode','')
      else
        refinement=nil
      end
      unless x[x2][14].nil? || !has_any?(event.message.text.downcase.split(' '),['pair','pairup'])
        x3=x.find_index{|q| q[0]==x[x2][14]}
        unless x3.nil?
          pair_up=[x[x2][14]]
          pair_up[0]=[pair_up[0],"**#{pair_up[0]}**#{unit_moji(bot,event,-1,pair_up[0],false,2,uid)}",'Pair-Up cohort']
          pair_up.push(x[x3][1].to_i)
          pair_up.push(x[x3][2])
          pair_up.push(x[x3][3].gsub(' ',''))
          pair_up.push(x[x3][4].gsub(' ',''))
          pair_up.push(x[x3][5])
          pair_up.push(x[x3][6])
          weaponz=x[x3][7].reject{|q| q.include?('~~')}[-1]
          if weaponz.include?(' (+) ')
            weaponz=weaponz.split(' (+) ')
            pair_up.push(weaponz[0])
            pair_up.push(weaponz[1].gsub(' Mode',''))
          elsif weaponz.length>0
            pair_up.push(weaponz)
            pair_up.push('')
          else
            pair_up.push('')
            pair_up.push('')
          end
          pair_up.push(x[x3][1].include?('r'))
          lookout=lookout_load('StatSkills',['Stat-Affecting 1']).map{|q| q[0]}
          a=x[x3][10].reject{|q| q.include?('~~')}
          x=[a[a.length-1],x[x3][13]]
          for i in 0...x.length
            pair_up.push(x[i]) if lookout.include?(x[i])
          end
        else
          pair_up=[]
        end
      end
    end
  elsif " #{event.message.text.downcase} ".include?(' prf ') || args.map{|q| q.downcase}.include?('prf')
    weapon=get_unit_prf(name)
    weapon2=weapon[1] unless weapon[1].nil?
    weapon=weapon[0]
    unless weapon2.nil?
      if weapon=='-'
        w2=['-',0,0,0,0]
      else
        w2=find_skill(weapon,event)
      end
      if weapon2=='-'
        w22=['-',0,0,0,0]
      else
        w22=find_skill(weapon2,event)
      end
      diff_num=[w2[4]-w22[4],'M','F']
    end
  end
  sklz=@skills.map{|q| q}
  tempest=get_bonus_type(event)
  deftile=false
  deftile=true if has_any?(event.message.text.downcase.split(' '),['defensetile','defencetile','deftile','defensivetile','defencivetile','defenseterrain','defenceterrain','defterrain','defensiveterrain','defenciveterrain'])
  stat_skills_2=make_stat_skill_list_2(name,event,args)
  ww2=sklz.find_index{|q| q[1]==weapon}
  ww2=-1 if ww2.nil?
  w2=sklz[ww2]
  if w2[17].nil?
    refinement=nil
  elsif w2[17].length<2 && refinement=='Effect'
    refinement=nil
  elsif w2[17][0,1].to_i.to_s==w2[17][0,1] && refinement=='Effect'
    refinement=nil if w2[17][1,1]=='*'
  elsif w2[17][0,1]=='-' && w2[17][1,1].to_i.to_s==w2[17][1,1] && refinement=='Effect'
    refinement=nil if w2[17][2,1]=='*'
  end
  refinement=nil if w2[7]!='Staff Users Only' && ['Wrathful','Dazzling'].include?(refinement)
  refinement=nil if w2[7]=='Staff Users Only' && !['Wrathful','Dazzling'].include?(refinement)
  atk='<:StrengthS:514712248372166666> Attack'
  atk='<:MagicS:514712247289774111> Magic' if ['Tome','Healer','Dragon'].include?(u40x[1][1])
  atk='<:StrengthS:514712248372166666> Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
  zzzl=sklz[ww2]
  atk='<:FreezeS:514712247474585610> Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
  staticons=['<:HP_S:514712247503945739>','<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>','<:Death_Blow:514719899868856340>','<:Darting_Blow:514719899910668298>','<:Armored_Blow:514719899927576578>','<:Warding_Blow:514719900607053824>','<:Fierce_Stance:514719899873050624>','<:Darting_Stance:514719899919056926>','<:Steady_Stance:514719899856273408>','<:Warding_Stance:514719899562672138>']
  if u40x[11][0]=='DL'
    atk='<:Strength:573344931205349376> Attack'
    atk='<:Strength:573344931205349376> Magic' if ['Tome','Dragon','Healer'].include?(u40x[1][1])
    atk='<:Strength:573344931205349376> Strength' if ['Blade','Bow','Dagger','Beast'].include?(u40x[1][1])
    atk='<:Strength:573344931205349376> Freeze' if has_weapon_tag2?('Frostbite',zzzl,refinement,transformed)
    staticons=['<:HP:573344832307593216>','<:Speed:573366907357495296>','<:FEHDefense:574702109325262878>','<:Defense:573344832282689567>','<:Strength:573344931205349376>','<:Speed:573366907357495296>','<:FEHDefense:574702109325262878>','<:Defense:573344832282689567>','<:Strength:573344931205349376>','<:Speed:573366907357495296>','<:FEHDefense:574702109325262878>','<:Defense:573344832282689567>']
  end
  n=nature_name(boon,bane)
  unless n.nil?
    n=n[0] if atk=='<:StrengthS:514712248372166666> Strength'
    n=n[n.length-1] if atk=='<:MagicS:514712247289774111> Magic'
    n=n.join(' / ') if ['<:StrengthS:514712248372166666> Attack','<:FreezeS:514712247474585610> Freeze'].include?(atk)
  end
  u40=get_stats(event,name,40,rarity,merges,boon,bane,flowers,resp)
  if !pair_up.nil? && pair_up.length>0
    u40cu=get_stats(event,pair_up[0][0],40,pair_up[1],pair_up[2],pair_up[3],pair_up[4],pair_up[6])
    m=pair_up[10,pair_up.length-10]
    m=[] if m.nil?
    u40cu=apply_stat_skills(event,m,u40cu,'',pair_up[5],pair_up[7],pair_up[8])
    if pair_up[9]
      for i in 2...6
        u40cu[i]+=2
      end
    end
    u40[2]+=(u40cu[2]-25)/10
    u40[3]+=(u40cu[3]-10)/10
    u40[4]+=(u40cu[4]-10)/10
    u40[5]+=(u40cu[5]-10)/10
  end
  bane2="#{bane}"
  bane2='' if merges>0
  u40x2=get_stats(event,name,40,5,0,boon,bane2)
  spec_wpn=false
  if name=='Robin'
    u40[0]='Robin (Shared stats)'
    w='*Tome*'
    spec_wpn=true
    wl=weapon_legality(event,'Robin(M)',weapon)
    wl2=weapon_legality(event,'Robin(F)',weapon)
    wl="#{wl}(M) / #{wl2}(F)" unless wl==wl2
  end
  xcolor=unit_color(event,u40x,u40[0],0,mu)
  unless spec_wpn
    wl=weapon_legality(event,u40[0],weapon,refinement)
    weapon=wl.split(' (+) ')[0] unless wl.include?('~~')
  end
  cru40=u40.map{|a| a}
  u40=apply_stat_skills(event,stat_skills,u40,tempest,summoner,weapon,refinement,blessing,transformed)
  cru40=apply_stat_skills(event,stat_skills,cru40,tempest,summoner,'-','',blessing,transformed)
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
  if has_weapon_tag2?('Buffstuffer',zzzl,refinement,transformed) || stat_skills_3.include?('Bonus Doubler 3')
    m=apply_stat_skills(event,stat_skills_2,[u40[0],0,0,0,0,0])
    for i in 2...6
      ppu40[i]+=m[i] if m[i]>0
      epu40[i]+=m[i] if m[i]>0
    end
  elsif stat_skills_3.reject{|q| q.length<14 || q[0,14]!='Bonus Doubler '}.length>0
    m2=stat_skills_3.reject{|q| q.length<14 || q[0,14]!='Bonus Doubler '}
    m=apply_stat_skills(event,stat_skills_2,[u40[0],0,0,0,0,0])
    for i2 in 0...m2.length
      qq=m2[i2][14,m2[i2].length-14].to_i+1
      for i in 2...6
        ppu40[i]+=m[i]*qq/4 if m[i]>0
        epu40[i]+=m[i]*qq/4 if m[i]>0
      end
    end
  end
  if has_weapon_tag2?('BonusBoostAtk',zzzl,refinement,transformed) && stat_skills_2.length>0
    ppu40[2]+=3
    epu40[2]+=3
  end
  if has_weapon_tag2?('BonusBoostSpd',zzzl,refinement,transformed) && stat_skills_2.length>0
    ppu40[3]+=3
    epu40[3]+=3
  end
  if has_weapon_tag2?('BonusBoostDef',zzzl,refinement,transformed) && stat_skills_2.length>0
    ppu40[4]+=3
    epu40[4]+=3
  end
  if has_weapon_tag2?('BonusBoostRes',zzzl,refinement,transformed) && stat_skills_2.length>0
    ppu40[5]+=3
    epu40[5]+=3
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
    x=nil if sklz[ww2][11].include?('(R)Overwrite') && !refinement.nil? && refinement.length>0
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
        zzz2=find_effect_name(sklz[ww2],event,1)
        lookout=lookout_load('StatSkills')
        statskl=lookout.find_index{|q| q[0]==zzz2}
        if statskl.nil?
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
        else
          statskl=lookout[statskl]
          if ['Enemy Phase','Player Phase','In-Combat Buffs 1','In-Combat Buffs 2'].include?(statskl[3])
            x3=statskl[4].map{|q| q}
            x3.unshift(0)
            x3[6]=0
            unless statskl[3]=='Enemy Phase'
              for i in 0...x3pp.length
                x3pp[i]=[x3pp[i],x3[i]].max
              end
            end
            unless statskl[3]=='Player Phase'
              for i in 0...x3ep.length
                x3ep[i]=[x3ep[i],x3[i]].max
              end
            end
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
    elsif stat_skills_3[i]=='Close Stance'
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
    elsif stat_skills_3[i]=='Distant Stance'
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
  unless weapon.nil? || weapon=='-'
    tags=zzzl[11]
    for i in 0...tags.length
      if tags[i][0,1]=='(' && tags[i][3,1]==')'
        if tags[i][1,2]=='cP'
          close[7]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Atk'
          close[8]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Spd'
          close[9]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Def'
          close[10]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Res'
        elsif tags[i][1,2]=='dP'
          distant[7]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Atk'
          distant[8]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Spd'
          distant[9]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Def'
          distant[10]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Res'
        elsif tags[i][1,2]=='cE'
          close[2]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Atk'
          close[3]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Spd'
          close[4]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Def'
          close[5]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Res'
        elsif tags[i][1,2]=='dE'
          distant[2]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Atk'
          distant[3]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Spd'
          distant[4]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Def'
          distant[5]+=tags[i][8,tags[i].length-8].to_i if tags[i][4,3]=='Res'
        end
      end
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
  if has_weapon_tag2?('CloseStance',zzzl,refinement,transformed)
    close[2]+=4
    close[3]+=4
    close[4]+=4
    close[5]+=4
  end
  if has_weapon_tag2?('CloseDef',zzzl,refinement,transformed)
    close[4]+=6
    close[5]+=6
  end
  if has_weapon_tag2?('CloseAtk',zzzl,refinement,transformed)
    close[2]+=6
  end
  if has_weapon_tag2?('CloseSpd',zzzl,refinement,transformed)
    close[3]+=6
  end
  if has_weapon_tag2?('DistantStance',zzzl,refinement,transformed)
    distant[2]+=4
    distant[3]+=4
    distant[4]+=4
    distant[5]+=4
  end
  if has_weapon_tag2?('DistantDef',zzzl,refinement,transformed)
    distant[4]+=6
    distant[5]+=6
  end
  if has_weapon_tag2?('DistantAtk',zzzl,refinement,transformed)
    distant[2]+=6
  end
  if has_weapon_tag2?('DistantSpd',zzzl,refinement,transformed)
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
  bb=0
  bb=3 if ['',' ',nil].include?(boon) && merges>0
  bin=((u40x2[1]+u40x2[2]+u40x2[3]+u40x2[4]+u40x2[5]+bb)/5)*5
  if rarity>=5 && !stat_skills.nil? && !stat_skills.length.zero?
    lookout=lookout_load('StatSkills',['Stat-Affecting'],1)
    for i in 0...stat_skills.length
      unless lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5].nil?
        bin=[bin,lookout[lookout.find_index{|q| q[0]==stat_skills[i]}][4][5]].max
      end
    end
  end
  bin=[bin,175].max if u40x[2].length>0 && u40x[2][1]=='Duel' && rarity>=5
  bin=[bin,185].max if u40x[2].length>0 && (u40x[2][0]=='Duo' || u40x[2][3]=='Duo') && rarity>=5
  pic=pick_thumbnail(event,u40x,bot,resp)
  pic='https://orig00.deviantart.net/bcc0/f/2018/025/b/1/robin_by_rot8erconex-dc140bw.png' if u40[0]=='Robin (Shared stats)'
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?(' all')
    event.respond "__#{"Mathoo's " if mu}**#{u40[0]}**__\n\n#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense Tile\n" if deftile}#{display_stat_skills(u40x,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,transformed,wl,false,false,resp)}#{"Pair-Up cohort: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n#{unit_clss(bot,event,u40x,u40[0])}"
    event.respond "**Displayed stats:**  #{u40[1]} / #{u40[2]} / #{u40[3]} / #{u40[4]} / #{u40[5]} - Score: #{bin/5+merges*2+rarity*5+blessing.length*4+90}+`SP`/100\n**#{"Player Phase" unless ppu40==epu40}#{"In-combat Stats" if ppu40==epu40}:**  #{ppu40[1]} / #{ppu40[2]} / #{ppu40[3]} / #{ppu40[4]} / #{ppu40[5]}  (#{ppu40[16]} BST)#{"\n**Enemy Phase:**  #{epu40[1]} / #{epu40[2]} / #{epu40[3]} / #{epu40[4]} / #{epu40[5]}  (#{epu40[16]} BST)" unless ppu40==epu40}"
  elsif ppu40==epu40
    create_embed(event,["__#{"Mathoo's " if mu}**#{u40[0]}**__",unit_clss(bot,event,u40x,u40[0])],"#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense Tile\n" if deftile}#{display_stat_skills(u40x,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}\n",xcolor,nil,pic,[["Displayed stats","#{staticons[0]} HP: #{u40[1]}\n#{atk}: #{u40[2]}\n#{staticons[1]} Speed: #{u40[3]}\n#{staticons[2]} Defense: #{u40[4]}\n#{staticons[3]} Resistance: #{u40[5]}\n\nBST: #{u40[16]}\nScore: #{bin/5+merges*2+rarity*5+blessing.length*4+90}+`SP`/100"],["In-combat Stats","#{staticons[0]} HP: #{ppu40[1]}\n#{atk}: #{ppu40[2]}\n#{staticons[1]} Speed: #{ppu40[3]}\n#{staticons[2]} Defense: #{ppu40[4]}\n#{staticons[3]} Resistance: #{ppu40[5]}\n\nBST: #{ppu40[16]}"]])
  else
    create_embed(event,["__#{"Mathoo's " if mu}**#{u40[0]}**__",unit_clss(bot,event,u40x,u40[0])],"#{display_stars(bot,event,rarity,merges,summoner,[u40x[3],flowers],false,u40x[11][0],mu)}#{"\n+#{boon}, -#{bane} #{"(#{n})" unless n.nil?}" unless boon=="" && bane==""}\n#{"Defense Tile\n" if deftile}#{display_stat_skills(u40x,stat_skills,stat_skills_2,stat_skills_3,tempest,blessing,transformed,wl,false,false,resp)}#{"#{pair_up[0][2]}: #{pair_up[0][1]}\n" unless pair_up.nil? || pair_up.length<=0}",xcolor,nil,pic,[["Displayed stats","#{staticons[0]} HP: #{u40[1]}\n#{atk}: #{u40[2]}\n#{staticons[1]} Speed: #{u40[3]}\n#{staticons[2]} Defense: #{u40[4]}\n#{staticons[3]} Resistance: #{u40[5]}\n\nBST: #{u40[16]}\nScore: #{bin/5+merges*2+rarity*5+blessing.length*4+90}+`SP`/100",1],["Player Phase","#{staticons[0]} HP: #{ppu40[1]}\n#{staticons[4]} Attack: #{ppu40[2]}\n#{staticons[5]} Speed: #{ppu40[3]}\n#{staticons[6]} Defense: #{ppu40[4]}\n#{staticons[7]} Resistance: #{ppu40[5]}\n\nBST: #{ppu40[16]}"],["Enemy Phase","#{staticons[0]} HP: #{epu40[1]}\n#{staticons[8]} Attack: #{epu40[2]}\n#{staticons[9]} Speed: #{epu40[3]}\n#{staticons[10]} Defense: #{epu40[4]}\n#{staticons[11]} Resistance: #{epu40[5]}\n\nBST: #{epu40[16]}"]])
  end
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
        color_weapons.push([colors[i],weapons[j]]) unless (weapons[j]=='Blade' && !alter_classes(event,'Colorless Blades'))
      elsif weapons[j]=='Healer' && !alter_classes(event,'Colored Healers')
      else
        color_weapons.push([colors[i],weapons[j]])
      end
    end
  end
  if color_weapons.length<=0
    color_weapons=[['Red', 'Blade'],  ['Red', 'Tome'],      ['Red', 'Breath'],      ['Red', 'Bow'],      ['Red', 'Dagger'],      ['Red','Beast'],
                   ['Blue', 'Blade'], ['Blue', 'Tome'],     ['Blue', 'Breath'],     ['Blue', 'Bow'],     ['Blue', 'Dagger'],     ['Blue','Beast'],
                   ['Green', 'Blade'],['Green', 'Tome'],    ['Green', 'Breath'],    ['Green', 'Bow'],    ['Green', 'Dagger'],    ['Green','Beast'],
                                      ['Colorless', 'Tome'],['Colorless', 'Breath'],['Colorless', 'Bow'],['Colorless', 'Dagger'],['Colorless','Beast']]
    color_weapons.push(['Colorless', 'Blade']) if alter_classes(event,'Colorless Blades')
    unless event.message.text.downcase.split(' ').include?('singer') || event.message.text.downcase.split(' ').include?('dancer')
      color_weapons.push(['Red', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Blue', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Green', 'Healer']) if alter_classes(event,'Colored Healers')
      color_weapons.push(['Colorless', 'Healer'])
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
    gp_total-=1 if ['Tome', 'Bow', 'Dagger', 'Healer'].include?(clazz[1]) && 'Armor'!=mov
  end
  gp_total+=15
  name=get_bond_name(event)
  stats=[0,0,0,0,0]
  gps=[0,0,0,0,0]
  stats[0]=10+rand(16)
  gps[0]=rand(@mods.length-3)+1
  gps[0]=rand(@mods.length-3)+1 if gps[0]<3 || gps[0]>14
  gps[0]=rand(@mods.length-3)+1 if gps[0]<3 || gps[0]>14
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
  min_possible=[gp_total-2*(@mods.length-3),1].max
  max_possible=[gp_total-2,(@mods.length-3)].min
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
  min_possible=[gp_total-(@mods.length-3),1].max
  max_possible=[gp_total-1,(@mods.length-3)].min
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
  stats.push(stats[0]+@mods[gps[0]][5])
  stats.push(stats[1]+@mods[gps[1]][5])
  stats.push(stats[2]+@mods[gps[2]][5])
  stats.push(stats[3]+@mods[gps[3]][5])
  stats.push(stats[4]+@mods[gps[4]][5])
  for i in 0...gps.length
    gps[i]-=3
  end
  stats.push(stats[0]+stats[1]+stats[2]+stats[3]+stats[4])
  stats.push(stats[5]+stats[6]+stats[7]+stats[8]+stats[9])
  stats.push(stats[0,5].map{|q| "#{' ' if q<10}#{q}"}.join("\u00A0|"))
  stats.push(stats[5,5].map{|q| "#{' ' if q<10}#{q}"})
  stat_names=['HP','Attack','Speed','Defense','Resistance']
  for i in 0...5
    stats[i+5]=stats[i+5].to_s
    stats[i+5]="#{stats[i+5]} (+)" if [-3,1,5,10,14].include?(gps[i])
    stats[i+5]="#{stats[i+5]} (-)" if [-2,2,6,11,15].include?(gps[i])
    zzz="\u00A0"
    zzz='+' if [-3,1,5,10,14].include?(gps[i])
    zzz='-' if [-2,2,6,11,15].include?(gps[i])
    stats[13][i]="#{stats[13][i]}#{zzz}"
  end
  stats[13]=stats[13].join('|')
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
  wx=nil
  if w=='*Red Tome*'
    wx=['Fire','Dark'].sample
    w="*#{wx} Mage* (Red Tome)"
  elsif w=='*Green Tome*'
    wx=['Wind'].sample
    w="*#{wx} Mage* (Green Tome)"
  elsif w=='*Blue Tome*'
    wx=['Thunder','Light'].sample
    w="*#{wx} Mage* (Blue Tome)"
  end
  atk='<:GenericAttackS:514712247587569664> Attack'
  atk='<:MagicS:514712247289774111> Magic' if ['Tome','Healer'].include?(clazz[1])
  atk='<:FreezeS:514712247474585610> Magic' if ['Dragon'].include?(clazz[1])
  atk='<:StrengthS:514712248372166666> Strength' if ['Blade','Bow','Dagger','Beast'].include?(clazz[1])
  r='<:Icon_Rarity_5:448266417553539104>'*5
  flds=[['**Level 1**',"<:HP_S:514712247503945739> HP: #{stats[0]}\n#{atk}: #{stats[1]}\n<:SpeedS:514712247625580555> Speed: #{stats[2]}\n<:DefenseS:514712247461871616> Defense: #{stats[3]}\n<:ResistanceS:514712247574986752> Resistance: #{stats[4]}\n\nBST: #{stats[10]}"]]
  args=args.map{|q| q.downcase}
  if args.include?('gps') || args.include?('gp') || args.include?('growths') || args.include?('growth')
    flds.push(['**Growth Rates**',"<:HP_S:514712247503945739> HP: #{micronumber(gps[0])} / #{gps[0]*5+20}%\n#{atk}: #{micronumber(gps[1])} / #{gps[1]*5+20}%\n<:SpeedS:514712247625580555> Speed: #{micronumber(gps[2])} / #{gps[2]*5+20}%\n<:DefenseS:514712247461871616> Defense: #{micronumber(gps[3])} / #{gps[3]*5+20}%\n<:ResistanceS:514712247574986752> Resistance: #{micronumber(gps[4])} / #{gps[4]*5+20}%\n\n\u0262\u1D18\u1D1B #{micronumber(gps[0]+gps[1]+gps[2]+gps[3]+gps[4])} / GRT: #{(gps[0]+gps[1]+gps[2]+gps[3]+gps[4])*5+100}%"])
  end
  flds.push(['**Level 40**',"<:HP_S:514712247503945739> HP: #{stats[5]}\n#{atk}: #{stats[6]}\n<:SpeedS:514712247625580555> Speed: #{stats[7]}\n<:DefenseS:514712247461871616> Defense: #{stats[8]}\n<:ResistanceS:514712247574986752> Resistance: #{stats[9]}\n\nBST: #{stats[11]}"])
  text='Neutral Nature'
  if flds.length<=2 && !(event.server.nil? || event.server.id==238059616028590080) && event.channel.id != 362017071862775810
    flds=nil
    text="\n<:HP_S:514712247503945739>\u00A0\u200B\u00A0\u200B\u00A0#{atk.split('>')[0]}>\u00A0\u200B\u00A0\u200B\u00A0<:SpeedS:514712247625580555>\u00A0\u200B\u00A0\u200B\u00A0<:DefenseS:514712247461871616>\u00A0\u200B\u00A0\u200B\u00A0<:ResistanceS:514712247574986752>\u00A0\u200B\u00A0\u200B\u00A0#{stats[11]}\u00A0L#{micronumber(40)}\u00A0BST\n```#{stats[12]}\n#{stats[13]}```"
  end
  img=nil
  ftr=nil
  unless event.server.nil?
    imgx=event.server.users.sample
    imgx=event.user if rand(100).zero? && event.server.users.length>100
    img=imgx.avatar_url
    ftr="Unit profile provided by #{imgx.distinct}"
  end
  if event.message.mentions.length>0 && rand(100)<[event.message.mentions.length*10,50].min
    imgx=event.message.mentions.sample
    img=imgx.avatar_url
    ftr="Unit profile provided by #{imgx.distinct}"
  end
  wemote=''
  moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clazz[0]}_#{clazz[1].gsub('Healer','Staff')}"}
  wemote=moji[0].mention unless moji.length<=0
  unless wx.nil?
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{wx}_#{clazz[1].gsub('Healer','Staff')}"}
    wemote=moji[0].mention unless moji.length<=0
  end
  memote=''
  moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{mov}"}
  memote=moji[0].mention unless moji.length<=0
  clazz3=clazz2.reject{|q| ['Dancer','Singer','Bard'].include?(q)}
  clazz2=clazz2.reject{|q| !['Dancer','Singer','Bard'].include?(q)}
  clazz2=clazz2[0] if clazz2.length>0
  create_embed(event,["__**#{name}**__","#{wemote} #{w}\n#{memote} *#{mov}*#{"\n<:Assist_Music:454462054959415296> *#{clazz2}*" if clazz2.length>0}\n#{"Additional Modifier#{'s' if clazz3.length>1}: #{clazz3.map{|q| "*#{q}*"}.join(', ')}" if clazz3.length>0}"],"#{r}\n#{text}",xcolor,ftr,img,flds,1)
end

def load_devunits()
  if File.exist?("#{@location}devkit/FEHDevUnits.txt")
    b=[]
    File.open("#{@location}devkit/FEHDevUnits.txt").each_line do |line|
      b.push(line.gsub("\n",''))
    end
  else
    b=[]
  end
  @dev_waifus=b[0].split('\\'[0])
  @dev_somebodies=b[1].split('\\'[0])
  @dev_nobodies=b[2].split('\\'[0])
  devpass=false
  devpass=true if b[3].downcase=='pass'
  devpass=true if b[3].downcase=='feh pass'
  devpass=true if b[3].downcase=='fehpass'
  b.shift
  b.shift
  b.shift
  b.shift
  b.shift
  @dev_units=[]
  for i in 0...b.length/10
    @dev_units[i]=[]
    @dev_units[i].push(b[i*10])
    k=b[i*10+1].split('\\'[0])
    @dev_units[i].push(k[0])
    @dev_units[i].push(k[1].to_i)
    @dev_units[i].push(k[2])
    @dev_units[i].push(k[3])
    if devpass
      @dev_units[i].push(k[4].gsub('(','').gsub(')',''))
    else
      @dev_units[i].push(k[4])
    end
    @dev_units[i].push(k[5].to_i)
    @dev_units[i].push(b[i*10+2].split('\\'[0]))
    @dev_units[i].push(b[i*10+3].split('\\'[0]))
    @dev_units[i].push(b[i*10+4].split('\\'[0]))
    @dev_units[i].push(b[i*10+5].split('\\'[0]))
    @dev_units[i].push(b[i*10+6].split('\\'[0]))
    @dev_units[i].push(b[i*10+7].split('\\'[0]))
    @dev_units[i].push(b[i*10+8])
    @dev_units[i].push(k[6]) unless k[6].nil?
  end
end

def save_devunits()
  b=[]
  File.open("#{@location}devkit/FEHDevUnits.txt").each_line do |line|
    b.push(line.gsub("\n",''))
  end
  devpass=b[3]
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
  alm=nil
  supported=[]
  subsupported=[]
  subsupported2=[]
  for i in 0...k.length
    if k[i][0]=='Sakura' && saku.nil?
      saku=k[i].map{|q| q}
      k[i]=nil
    elsif k[i][5].length>0 && k[i][5]!='-'
      supported.push(k[i].map{|q| q})
      k[i]=nil
    elsif k[i][0]=='Alm(Saint)' && k[i][14]=='Sakura' && alm.nil?
      alm=k[i].map{|q| q}
      k[i]=nil
    elsif k[i][0][0,3]=='Alm' || k[i][0][0,6]=='Sakura' || k[i][0][0,6]=='Bernie'
      subsupported.push(k[i].map{|q| q})
      k[i]=nil
    end
  end
  k.compact!
  k=k.sort{|a,b| a[0]<=>b[0]}
  supported=supported.sort{|a,b| a[0]<=>b[0]}
  subsupported=subsupported.sort{|a,b| a[0]<=>b[0]}
  untz=[saku.map{|q| q}]
  untz.push(alm.map{|q| q}) unless alm.nil?
  for i in 0...supported.length
    untz.push(supported[i].map{|q| q})
  end
  for i in 0...subsupported.length
    untz.push(subsupported[i].map{|q| q})
  end
  for i in 0...k.length
    untz.push(k[i].map{|q| q})
  end
  s="#{w.join('\\'[0])}\n#{sb.join('\\'[0])}\n#{nb.join('\\'[0])}\n#{devpass}"
  for i in 0...untz.length
    s="#{s}\n\n#{untz[i][0]}\n#{untz[i][1]}\\#{untz[i][2]}\\#{untz[i][3]}\\#{untz[i][4]}\\#{untz[i][5]}\\#{untz[i][6]}\\#{untz[i][14]}\n#{untz[i][7].join('\\'[0])}\n#{untz[i][8].join('\\'[0])}\n#{untz[i][9].join('\\'[0])}\n#{untz[i][10].join('\\'[0])}\n#{untz[i][11].join('\\'[0])}\n#{untz[i][12].join('\\'[0])}\n#{untz[i][13]}"
  end
  open("#{@location}devkit/FEHDevUnits.txt", 'w') { |f|
    f.puts s
    f.puts "\n"
  }
  return nil
end

def load_donorunits(uid, mode=0)
  return [] unless File.exist?("#{@location}devkit/EliseUserSaves/#{uid}.txt")
  b=[]
  File.open("#{@location}devkit/EliseUserSaves/#{uid}.txt").each_line do |line|
    b.push(line.gsub("\n",''))
  end
  m=b[0]
  b.shift
  b.shift
  untz=[]
  return untz if b.length<10
  for i in 0...b.length/10
    untz[i]=[]
    untz[i].push(b[i*10])
    k=b[i*10+1].split('\\'[0])
    untz[i].push(k[0])
    untz[i].push(k[1].to_i)
    untz[i].push(k[2])
    untz[i].push(k[3])
    untz[i].push(k[4])
    untz[i].push(k[5].to_i)
    untz[i].push(b[i*10+2].split('\\'[0]))
    untz[i].push(b[i*10+3].split('\\'[0]))
    untz[i].push(b[i*10+4].split('\\'[0]))
    untz[i].push(b[i*10+5].split('\\'[0]))
    untz[i].push(b[i*10+6].split('\\'[0]))
    untz[i].push(b[i*10+7].split('\\'[0]))
    untz[i].push(b[i*10+8])
    untz[i].push(k[6]) unless k[6].nil?
  end
  untz.unshift(m) if mode==1
  return untz
end

def save_donorunits(uid,table)
  return nil unless File.exist?("#{@location}devkit/EliseUserSaves/#{uid}.txt")
  # snag the username
  b=[]
  File.open("#{@location}devkit/EliseUserSaves/#{uid}.txt").each_line do |line|
    b.push(line.gsub("\n",''))
  end
  # sort the unit list alphabetically
  k=table.map{|q| q}
  k.compact!
  k=k.sort{|a,b| a[0]<=>b[0]}
  untz=[]
  for i in 0...k.length
    untz.push(k[i].map{|q| q})
  end
  s="#{b[0]}"
  for i in 0...untz.length
    s="#{s}\n\n#{untz[i][0]}\n#{untz[i][1]}\\#{untz[i][2]}\\#{untz[i][3]}\\#{untz[i][4]}\\#{untz[i][5]}\\#{untz[i][6]}\\#{untz[i][14]}\n#{untz[i][7].join('\\'[0])}\n#{untz[i][8].join('\\'[0])}\n#{untz[i][9].join('\\'[0])}\n#{untz[i][10].join('\\'[0])}\n#{untz[i][11].join('\\'[0])}\n#{untz[i][12].join('\\'[0])}\n#{untz[i][13]}"
  end
  open("#{@location}devkit/EliseUserSaves/#{uid}.txt", 'w') { |f|
    f.puts s
    f.puts "\n"
  }
  return nil
end

def dev_edit(bot,event,args=[],cmd='')
  if cmd.downcase=='help' || ((cmd.nil? || cmd.length.zero?) && (args.nil? || args.length.zero?))
    subcommand=nil
    subcommand=args[0] unless args.nil? || args.length.zero?
    subcommand='' if subcommand.nil?
    help_text(event,bot,'devedit',subcommand)
    return nil
  end
  data_load()
  j3=find_data_ex(:find_unit,args[0],event,true)
  j3=find_data_ex(:find_unit,event.message.text,event,false,1) if j3.nil? || j3.length<=0
  j=j3[0]
  j=j3 if j.length<=1
  j=j[0] if j.is_a?(Array)
  if j.nil? || j.length<0
    event.respond 'There is no unit by that name.'
    return nil
  end
  if ['newwaifu','newaifu','addwaifu','new_waifu','add_waifu','waifu'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && args[0].downcase=='waifu')
    if @dev_waifus.include?(j)
      event.respond "#{j} is already listed among your waifus."
    else
      @dev_waifus.push(j)
      rfs=false
      ren=false
      for i in 0...@dev_somebodies.length
        if @dev_somebodies[i]==j
          rfs=true
          @dev_somebodies[i]=nil
        end
      end
      @dev_somebodies.compact!
      for i in 0...@dev_nobodies.length
        if @dev_nobodies[i]==j
          rfn=true
          @dev_nobodies[i]=nil
        end
      end
      @dev_nobodies.compact!
      devunits_save()
      event.respond "#{j} has been added to the list of your waifus.#{"\nI have also taken the liberty of removing #{j} from your #{"\"somebodies\"" if rfs}#{" and " if rfs && rfn}#{'"nobodies"' if rfn} list#{'s' if rfs && rfn}." if rfs || rfn}"
    end
    return nil
  elsif ['newsomebody','newsomeone','newsomebodies','addsomebody','addsomeone','addsomebodies','new_somebody','new_someone','new_somebodies','add_somebody','add_someone','add_somebodies','somebody','somebodies','someone'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && ['somebody','somebodies','someone'].include?(args[0].downcase))
    if @dev_waifus.include?(j)
      event.respond "#{j} is already listed among your waifus."
    elsif @dev_somebodies.include?(j)
      event.respond "#{j} is already listed among your \"somebodies\" list."
    else
      @dev_somebodies.push(j)
      ren=false
      for i in 0...@dev_nobodies.length
        if @dev_nobodies[i]==j
          rfn=true
          @dev_nobodies[i]=nil
        end
      end
      @dev_nobodies.compact!
      devunits_save()
      event.respond "#{j} has been added to your \"somebodies\" list.#{"\nI have also taken the liberty of removing #{j} from your \"nobodies\" list." if rfn}"
    end
    return nil
  elsif ['newnobody','newnoone','newnobodies','addnobody','addnoone','addnobodies','new_nobody','new_noone','new_nobodies','add_nobody','add_noone','add_nobodies','nobody','nobodies','noone'].include?(cmd.downcase) || (['new','add'].include?(cmd.downcase) && ['nobody','nobodies','noone'].include?(args[0].downcase))
    if @dev_waifus.include?(j)
      event.respond "#{j} is already listed among your waifus."
    elsif @dev_somebodies.include?(j)
      event.respond "#{j} is already listed among your \"somebodies\" list."
    elsif @dev_nobodies.include?(j)
      event.respond "#{j} is already listed among your \"nobodies\" list."
    else
      @dev_nobodies.push(j)
      devunits_save()
      event.respond "#{j} has been added to your \"nobodies\" list."
    end
    return nil
  end
  j2=find_in_dev_units(j)
  if j2<0
    args=event.message.text.downcase.split(' ')
    if cmd.downcase=='create'
      sklz2=unit_skills(j,event,true)
      flurp=find_stats_in_string(event)
      @dev_units.push([j,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],flurp[8],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5],' '])
      for i in 0...@dev_nobodies.length
        @dev_nobodies[i]=nil if @dev_nobodies[i]==j
      end
      @dev_nobodies.compact!
      devunits_save()
      congrate=false
      congrats=true if @dev_waifus.include?(j) || @dev_somebodies.include?(j)
      event.respond "You have added a #{flurp[0]}#{@rarity_stars[flurp[0]-1]}#{"+#{flurp[1]}" if flurp[0]>0} #{j} to your collection.  #{'Congrats!' if congrats}"
    elsif ['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase
      if @dev_waifus.include?(j[0])
        event.respond "Woah, you're getting rid of one of your waifus?!?  Who hacked your Discord and/or FEH account?"
      elsif @dev_somebodies.include?(j[0])
        @stored_event=[event,j]
        event.respond "You're getting rid of one of your somebodies?  Should I remove them from the \"somebodies\" list?"
        event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
          if e.message.text.downcase.include?('no')
            e.respond 'Okay.'
          else
            jn=@stored_event[1][0]
            for i in 0...@dev_somebodies.length
              @dev_somebodies[i]=nil if @dev_somebodies[i]==jn
            end
            @dev_somebodies.compact!
            devunits_save()
            e.respond "#{jn} has been removed from your \"somebodies\" list."
          end
        end
      elsif @dev_nobodies.include?(j[0])
        for i in 0...@dev_nobodies.length
          @dev_nobodies[i]=nil if @dev_nobodies[i]==j[0]
        end
        @dev_nobodies.compact!
        devunits_save()
        e.respond "#{j[0]} has been removed from your \"nobodies\" list."
      else
        event.respond 'You never had that unit in the first place.'
      end
      return nil
    else
      @stored_event=[event,j]
      event.respond 'You do not have this unit.  Do you wish to add them to your collection?' unless @dev_nobodies.include?(j[0])
      event.respond "You Have this unit but previously stated you don't want to input their data.  Do you wish to add them to your collection?" if @dev_nobodies.include?(j[0])
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          jn=@stored_event[1][0]
          sklz2=unit_skills(jn,@stored_event[0],true)
          flurp=find_stats_in_string(@stored_event[0])
          @dev_units.push([jn,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],flurp[8],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5]])
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
    @stored_event=[event,j]
    event.respond "I have a devunit stored for #{@dev_units[j2][0]}.  Do you wish me to delete this build?"
    event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
      if e.message.text.downcase.include?('no')
        e.respond 'Okay.'
      else
        jn=@stored_event[1][0]
        @dev_units[find_in_dev_units(jn)]=nil
        @dev_units.compact!
        devunits_save()
        e.respond "#{jn} has been removed from the devunits."
      end
    end
  elsif cmd.downcase=='create'
    event.respond "You already have a #{@dev_units[j2][0]}."
    return nil
  elsif ['resplendant','resplendent','ascension','ascend','resplend'].include?(cmd.downcase)
    if @dev_units[j2][1].include?('r')
      event.respond "Your #{@dev_units[j2][0]} is already Resplendently Ascended."
      return nil
    elsif !j3[9][0].include?('RA')
      event.respond "#{@dev_units[j2][0]} does not have a Resplendent Ascension available to them."
      return nil
    else
      @dev_units[j2][1]="#{@dev_units[j2][1]}r"
      devunits_save()
      event.respond "Your #{@dev_units[j2][0]} has reached their Resplendent Ascension!"
    end
  elsif ['pairup','pair','pair-up','paired'].include?(cmd.downcase)
    s1=first_sub(args.join(' ').downcase,j3[1],'')
    j3=find_data_ex(:find_unit,s1,event)
    if j3.length<=0
      event.respond "This subcommand requires at least two devunits."
      return nil
    end
    j4=find_in_dev_units(j3[0])
    order=[]
    if j4<0
      event.respond "This subcommand requires at least two devunits."
      return nil
    elsif j[2].length>0 && j[2][1]=='Duel'
      order=[j[0],j3[0]]
    elsif j3[2].length>0 && j3[2][1]=='Duel'
      order=[j3[0],j[0]]
    else
      event.respond "Neither #{j[0]} nor #{j3[0]} is a unit that has controllable Pair-Ups."
      return nil
    end
    m=@dev_units.find_index{|q| q[14]==j[0]}
    @dev_units[m][14]=nil unless m.nil?
    m=@dev_units.find_index{|q| q[14]==j3[0]}
    @dev_units[m][14]=nil unless m.nil?
    @dev_units[j2][14]=@dev_units[j4][0]
    @dev_units[j4][14]=@dev_units[j2][0]
    devunits_save()
    event.respond "Your #{order[0]} is now using #{order[1]} as a cohort unit."
  elsif ['promote','rarity','feathers'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    resp=@dev_units[j2][1].include?('r')
    @dev_units[j2][1]=@dev_units[j2][1].to_i
    if !flurp[1].nil?
      @dev_units[j2][1]+=flurp[1]
    elsif !flurp[0].nil?
      @dev_units[j2][1]+=flurp[0]
    else
      @dev_units[j2][1]+=1
    end
    @dev_units[j2][1]=[@dev_units[j2][1],5].min
    @dev_units[j2][1]="#{@dev_units[j2][1]}#{'r' if resp}"
    @dev_units[j2][2]=0
    devunits_save()
    event.respond "You have promoted your #{@dev_units[j2][0]} to #{@dev_units[j2][1].to_i}#{@rarity_stars[@dev_units[j2][1].to_i-1]}!"
  elsif ['merge','combine'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    @dev_units[j2][2]+=flurp[1] unless flurp[1].nil?
    @dev_units[j2][2]+=1 if flurp[1].nil?
    @dev_units[j2][2]=[@dev_units[j2][2],@max_rarity_merge[1]].min
    devunits_save()
    event.respond "You have merged your #{@dev_units[j2][0]} to +#{@dev_units[j2][2]}!"
  elsif ['flower','flowers','dragonflower','dragonflowers'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    if !flurp[8].nil?
      @dev_units[j2][6]+=flurp[8]
    elsif !flurp[1].nil?
      @dev_units[j2][6]+=flurp[1]
    elsif !flurp[0].nil?
      @dev_units[j2][6]+=flurp[0]
    else
      @dev_units[j2][6]+=1
    end
    @dev_units[j2][6]=[@dev_units[j2][6],2*@max_rarity_merge[2]].min
    @dev_units[j2][6]=[@dev_units[j2][6],@max_rarity_merge[2]].min unless j3[3]=='Infantry' && j3[9][0].include?('PF')
    devunits_save()
    event.respond "You have given #{@dev_units[j2][0]} their #{longFormattedNumber(@dev_units[j2][6],true)} flower!"
  elsif ['nature','ivs'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    n=''
    if flurp[2].nil? && flurp[3].nil?
      @dev_units[j2][3]=' '
      @dev_units[j2][4]=' '
      devunits_save()
      event.respond "You have changed your #{@dev_units[j2][0]}'s nature to neutral!"
    elsif flurp[2].nil? || flurp[3].nil?
      @stored_event=[event,j]
      event.respond 'You cannot have a boon without a bane.  Set stats to neutral?' if flurp[3].nil?
      event.respond 'You cannot have a bane without a boon.  Set stats to neutral?' if flurp[2].nil?
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: 167657750971547648) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          j2=find_in_dev_units(@stored_event[1][0])
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
      atk='Magic' if ['Tome','Dragon','Healer'].include?(j3[1][1])
      atk='Strength' if ['Blade','Bow','Dagger','Beast'].include?(j3[1][1])
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
      skill_types.push(7) if ['weapon','weapons'].include?(args[i].downcase)
      skill_types.push(8) if ['assist','assists'].include?(args[i].downcase)
      skill_types.push(9) if ['special','specials'].include?(args[i].downcase)
      skill_types.push(10) if ['a','apassives','apassive','passivea','passivesa','a_passives','a_passive','passive_a','passives_a'].include?(args[i].downcase)
      skill_types.push(11) if ['b','bpassives','bpassive','passiveb','passivesb','b_passives','b_passive','passive_b','passives_b'].include?(args[i].downcase)
      skill_types.push(12) if ['c','cpassives','cpassive','passivec','passivesc','c_passives','c_passive','passive_c','passives_c'].include?(args[i].downcase)
      skill_types.push(13) if ['s','seal','seals','spassives','spassive','passives','passivess','s_passives','s_passive','passive_s','passives_s','sealpassives','sealpassive','passiveseal','passivesseal','seal_passives','seal_passive','passive_seal','passives_seal','sealspassives','sealspassive','passiveseals','passivesseals','seals_passives','seals_passive','passive_seals','passives_seals'].include?(args[i].downcase)
    end
    if skill_types.length<=0
      event.respond "Please include the type of skill your #{@dev_units[j2][0]} will be learning."
      return nil
    end
    s='that type'
    s='those types' if skill_types.uniq.length>1
    for i in 0...skill_types.length
      k=false
      for jx in 0...@dev_units[j2][skill_types[i]].length
        if skill_types[i]==13
          seel=@dev_units[j2][skill_types[i]].scan(/\d+?/)[0].to_i
          seel=@dev_units[j2][skill_types[i]].gsub(seel.to_s,(seel+1).to_s)
          k=true if find_skill(seel,event,true).length>0
        else
          k=true if @dev_units[j2][skill_types[i]][jx][0,2]=='~~' && @dev_units[j2][skill_types[i]][jx]!='~~none~~'
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
      if skill_types[i]==13 # skill seals
        seel=@dev_units[j2][skill_types[i]].scan(/\d+?/)[0].to_i
        seel=@dev_units[j2][skill_types[i]].gsub(seel.to_s,(seel+1).to_s)
        if find_skill(seel,event,true).length>0
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

def donor_edit(bot,event,args=[],cmd='')
  uid=event.user.id
  if uid==167657750971547648
    event.respond "This command is for the donors.  Your version of the command is `FEH!devedit`."
    return nil
  elsif !get_donor_list().reject{|q| q[2][0]<4}.map{|q| q[0]}.include?(uid)
    event.respond "You do not have permission to use this command."
    return nil
  elsif !File.exist?("#{@location}devkit/EliseUserSaves/#{uid}.txt")
    event.respond "Please wait until my developer makes your storage file."
    return nil
  elsif cmd.downcase=='help' || ((cmd.nil? || cmd.length.zero?) && (args.nil? || args.length.zero?))
    subcommand=nil
    subcommand=args[0] unless args.nil? || args.length.zero?
    subcommand='' if subcommand.nil?
    help_text(event,bot,'edit',subcommand)
    return nil
  end
  data_load()
  j=find_data_ex(:find_unit,event.message.text,event)
  if j.length<=0
    event.respond 'There is no unit by that name.'
    return nil
  end
  donor_units=donor_unit_list(uid)
  j2=donor_units.find_index{|q| q[0]==j[0]}
  if j2.nil?
    args=event.message.text.downcase.split(' ')
    if cmd.downcase=='create'
      jn=j[0]
      sklz2=unit_skills(jn,event,true)
      flurp=find_stats_in_string(event)
      donor_units=donor_unit_list(uid)
      donor_units.push([jn,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],flurp[8],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5],' '])
      donor_unit_save(uid,donor_units)
      event.respond "You have added a #{flurp[0]}#{@rarity_stars[flurp[0]-1]}#{"+#{flurp[1]}" if flurp[0]>0} #{jn} to your collection."
    elsif ['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase
      event.respond 'You never had that unit in the first place.'
      return nil
    else
      @stored_event=[event,j]
      event.respond "You do not have this unit.  Do you wish to add them to your collection?\nYes/No"
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: event.user.id) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          jn=@stored_event[1][0]
          sklz2=unit_skills(jn,@stored_event[0],true)
          flurp=find_stats_in_string(e)
          donor_units=donor_unit_list(uid)
          donor_units.push([jn,flurp[0],flurp[1],flurp[2],flurp[3],flurp[4],flurp[8],sklz2[0],sklz2[1],sklz2[2],sklz2[3],sklz2[4],sklz2[5],' '])
          donor_unit_save(uid,donor_units)
          event.respond "You have added a #{flurp[0]}#{@rarity_stars[flurp[0]-1]}#{"+#{flurp[1]}" if flurp[0]>0} #{jn} to your collection."
        end
      end
    end
  elsif ['support','marry','marriage'].include?(cmd.downcase)
    donor_units=donor_unit_list(uid)
    if ['remove','delete'].include?(args[0].downcase)
      if donor_units[j2][5]=='-'
        event.respond "You never had support rank with #{donor_units[j2][0]}."
      else
        donor_units[j2][5]='-'
        donor_unit_save(uid,donor_units)
        event.respond "You've removed your support with #{donor_units[j2][0]}."
      end
    elsif donor_units[j2][5]=='S'
      event.respond "You've already married #{donor_units[j2][0]}."
    elsif donor_units[j2][5]=='A'
      donor_units[j2][5]='S'
      donor_unit_save(uid,donor_units)
      event.respond "You've married #{donor_units[j2][0]}!  (Support rank #{donor_units[j2][5]})"
    elsif donor_units[j2][5]=='B'
      donor_units[j2][5]='A'
      donor_unit_save(uid,donor_units)
      event.respond "You've proposed to #{donor_units[j2][0]}!  (Support rank #{donor_units[j2][5]})"
    elsif donor_units[j2][5]=='C'
      donor_units[j2][5]='B'
      donor_unit_save(uid,donor_units)
      event.respond "You've started dating #{donor_units[j2][0]}!  (Support rank #{donor_units[j2][5]})"
    elsif donor_units.reject{|q| q[5].nil? || q[5].length<=0 || q[5]=='-'}.length>=3
      event.respond "You're already supporting #{list_lift(donor_units.reject{|q| q[5].nil? || q[5].length<=0 || q[5]=='-'}.map{|q| "*#{q[0]}*"},'and')}.\nPlease remove your support with one of these units first."
    elsif donor_units[j2][5]=='-'
      donor_units[j2][5]='C'
      donor_unit_save(uid,donor_units)
      event.respond "You've befriended #{donor_units[j2][0]}!  (Support rank #{donor_units[j2][5]})"
    end
  elsif ['resplendant','resplendent','ascension','ascend','resplend'].include?(cmd.downcase)
    donor_units=donor_unit_list(uid)
    if donor_units[j2][1].include?('r')
      event.respond "Your #{donor_units[j2][0]} is already Resplendently Ascended."
      return nil
    elsif !j3[9][0].include?('RA')
      event.respond "#{donor_units[j2][0]} does not have a Resplendent Ascension available to them."
      return nil
    else
      donor_units[j2][1]="#{donor_units[j2][1]}r"
      donor_unit_save(uid,donor_units)
      event.respond "Your #{donor_units[j2][0]} has reached their Resplendent Ascension!"
    end
  elsif ['pairup','pair','pair-up','paired'].include?(cmd.downcase)
    s1=first_sub(args.join(' ').downcase,j3[1],'')
    j3=find_data_ex(:find_unit,s1,event)
    if j3.length<=0
      event.respond "This subcommand requires at least two donorunits."
      return nil
    end
    j4=donor_units.find_index{|q| q[0]==j3[0]}
    order=[]
    if j4<0
      event.respond "This subcommand requires at least two donorunits."
      return nil
    elsif j[2].length>0 && j[2][1]=='Duel'
      order=[j[0],j3[0]]
    elsif j3[2].length>0 && j3[2][1]=='Duel'
      order=[j3[0],j[0]]
    else
      event.respond "Neither #{j[0]} nor #{j3[0]} is a unit that has controllable Pair-Ups."
      return nil
    end
    m=donor_units.find_index{|q| q[14]==j[0]}
    donor_units[m][14]=nil unless m.nil?
    m=donor_units.find_index{|q| q[14]==j3[0]}
    donor_units[m][14]=nil unless m.nil?
    donor_units[j2][14]=donor_units[j4][0]
    donor_units[j4][14]=donor_units[j2][0]
    donor_unit_save(uid,donor_units)
    event.respond "Your #{order[0]} is now using #{order[1]} as a cohort unit."
  elsif ['unsupport','unmarry','unmarriage','divorce'].include?(cmd.downcase)
    donor_units=donor_unit_list(uid)
    if donor_units[j2][5]=='-'
      event.respond "You never had support rank with #{donor_units[j2][0]}."
    else
      donor_units[j2][5]='-'
      donor_unit_save(uid,donor_units)
      event.respond "You've removed your support with #{donor_units[j2][0]}."
    end
  elsif ['remove','delete'].include?(cmd.downcase) && ['support','marry','marriage'].include?(args[0].downcase)
    donor_units=donor_unit_list(uid)
    if donor_units[j2][5]=='-'
      event.respond "You never had support rank with #{donor_units[j2][0]}."
    else
      donor_units[j2][5]='-'
      donor_unit_save(uid,donor_units)
      event.respond "You've removed your support with #{donor_units[j2][0]}."
    end
  elsif ['remove','delete','send_home','sendhome','fodder'].include?(cmd.downcase) || 'send home'=="#{cmd} #{args[0]}".downcase
    @stored_event=[event,j]
    event.respond "I have a unit stored for your #{donor_units[j2][0]}.  Do you wish me to delete this build?\nYes/No"
    event.channel.await(:bob, contains: /(yes)|(no)/i, from: event.user.id) do |e|
      if e.message.text.downcase.include?('no')
        e.respond 'Okay.'
      else
        jn=@stored_event[1][0]
        donor_units=donor_unit_list(uid)
        donor_units=donor_units.reject{|q| q[0]==jn}
        donor_unit_save(uid,donor_units)
        e.respond "#{jn} has been removed from your collection."
      end
    end
  elsif ['refine','refinement','refinery'].include?(cmd.downcase)
    jn=j[0]
    sklzz=@skills.map{|q| q}
    m=donor_units[j2][7]
    m.pop if m[m.length-1].include?(' (+) ')
    w=sklzz[sklzz.index{|q| q[1]==m[m.length-1]}]
    if w[17].nil?
      event.respond "#{m[m.length-1]} cannot be refined."
      return nil
    end
    inner_skill=w[17]
    if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
      inner_skill=inner_skill[1,inner_skill.length-1]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
    elsif inner_skill[0,1]=='-' && inner_skill.length>1
      inner_skill=inner_skill[2,inner_skill.length-2]
      inner_skill='y' if inner_skill.nil? || inner_skill.length<1
    end
    for i in 0...5
      if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
        inner_skill=inner_skill[1,inner_skill.length-1]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      elsif inner_skill[0,1]=='-' && inner_skill.length>1
        inner_skill=inner_skill[2,inner_skill.length-2]
        inner_skill='y' if inner_skill.nil? || inner_skill.length<1
      end
    end
    overides=['e','a','s','d','r']
    overides=['e','w','d'] if w[5]=='Staff Users Only'
    for i in 0...overides.length
      if inner_skill[0,3]=="(#{overides[i]})"
        inner_skill=inner_skill[3,inner_skill.length-3]
        for i2 in 0...6
          if inner_skill[0,1].to_i.to_s==inner_skill[0,1]
            inner_skill=inner_skill[1,inner_skill.length-1]
            inner_skill='y' if inner_skill.nil? || inner_skill.length<1
          elsif inner_skill[0,1]=='-' && inner_skill.length>1
            inner_skill=inner_skill[2,inner_skill.length-2]
            inner_skill='y' if inner_skill.nil? || inner_skill.length<1
          end
        end
      end
    end
    words=[]
    words.push('Effect') unless inner_skill=='y'
    if w[7]=='Staff Users Only'
      words.push('Wrathful') unless w[7].include?("This weapon's damage is calculated the same as other weapons.") || w[7].include?('Damage from staff calculated like other weapons.')
      words.push('Dazzling') unless w[7].include?('The foe cannot counterattack.') || w[7].include?('Foe cannot counterattack.')
    else
      words.push('Attack')
      words.push('Speed')
      words.push('Defense')
      words.push('Resistance')
    end
    refine=''
    for i in 0...args.length
      if refine.length.zero?
        refine='Effect' if ['effect','special','eff','+effect','+special','+eff'].include?(args[i].downcase) && words.include?('Effect')
        refine='Wrathful' if ['wrazzle','wrathful','+wrazzle','+wrathful','=w'].include?(args[i].downcase) && words.include?('Wrathful')
        refine='Dazzling' if ['dazzle','dazzling','+dazzle','+dazzling','+d'].include?(args[i].downcase) && words.include?('Dazzling')
        refine='Attack' if ['attack','atk','att','strength','str','magic','mag','+attack','+atk','+att','+strength','+str','+magic','+mag'].include?(args[i].downcase) && words.include?('Attack')
        refine='Speed' if ['spd','speed','+spd','+speed'].include?(args[i].downcase) && words.include?('Speed')
        refine='Defense' if ['defense','def','defence','+defense','+def','+defence'].include?(args[i].downcase) && words.include?('Defense')
        refine='Resistance' if ['res','resistance','+res','+resistance'].include?(args[i].downcase) && words.include?('Resistance')
      end
    end
    refine='Effect' if refine.length.zero? && words.include?('Effect')
    refine=words[0] if refine.length.zero? && words.length==1
    if refine.length.zero?
      event.respond "No refinement was defined.  Your options are:\n#{words.join("\n")}"
      return nil
    end
    m.push("#{m[m.length-1]} (+) #{refine} Mode")
    donor_units[j2][6]=m
    donor_unit_save(uid,donor_units)
    event.respond "Your #{donor_units[j2][0]}'s #{m[m.length-2]} has been given the #{refine} Mode refinement!"
  elsif ['seal'].include?(cmd.downcase)
    jn=j[0]
    sklzz=@skills.map{|q| q}
    k222=find_data_ex(:find_unit,event.message.text,event,false,1)
    k2=get_weapon(first_sub(args.join(' '),k222[1],''),event,1)
    unless k2[0][k2[0].length-1,1]!=k2[0][k2[0].length-1,1].to_i.to_s || k2[1][k2[1].length-1,1]==k2[1][k2[1].length-1,1].to_i.to_s
      skls=sklzz.reject{|q| q[0][0,q[0].length-1]!=k2[0][0,k2[0].length-1]}.map{|q| q[0]}.sort!
      k2[0]=skls[-1]
    end
    js=sklzz.find_index{|q| q[1]==k2[1] && q[2]==k2[2]}
    q=sklzz[j2]
    q="#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"
    if !sklzz[js][6].split(', ').include?('Passive(S)') && !sklzz[js][6].split(', ').include?('Seal')
      event.respond "#{q} cannot be equipped in the Seal slot.  Please use the `FEH!edit equip` command to equip this skill."
      return nil
    elsif !skill_legality(event,donor_units[j2][0],q)
      event.respond "#{donor_units[j2][0]} cannot equip the #{q} seal."
      return nil
    end
    donor_units[j2][13]=q
    donor_unit_save(uid,donor_units)
    event.respond "The #{sklzz[js][0]} seal has been given to your #{donor_units[j2][0]}!"
  elsif ['equip','skill'].include?(cmd.downcase)
    jn=j[0]
    k222=find_data_ex(:find_unit,event.message.text,event,false,1)
    sklzz=@skills.map{|q| q}
    k2=get_weapon(first_sub(args.join(' '),k222[1],''),event,1)
    unless k2[0][k2[0].length-1,1]!=k2[0][k2[0].length-1,1].to_i.to_s || k2[1][k2[1].length-1,1]==k2[1][k2[1].length-1,1].to_i.to_s
      skls=sklzz.reject{|q| q[0][0,q[0].length-1]!=k2[0][0,k2[0].length-1]}.map{|q| q[0]}.sort!
      k2[0]=skls[-1]
    end
    js=sklzz.find_index{|q| q[1]==k2[1] && q[2]==k2[2]}
    x=backwards_skill_tree(js)
    m=0
    q=sklzz[js]
    q="#{q[1]}#{"#{' ' unless q[1][-1,1]=='+'}#{q[2]}" unless ['Weapon','Assist','Special'].include?(q[6]) || ['-','example'].include?(q[2])}"
    if sklzz[js][6]!='Weapon' && !skill_legality(event,donor_units[j2][0],q)
      event.respond "#{donor_units[j2][0]} cannot equip #{q}."
      return nil
    end
    if sklzz[js][6]=='Weapon'
      w=weapon_legality(event,donor_units[j2][0],sklzz[js][0])
      if w.include?('~~')
        event.respond "#{donor_units[j2][0]} cannot equip #{q}."
        return nil
      end
      js=sklzz.find_index{|q| q[0]==w}
      m=7
    elsif sklzz[js][6]=='Assist'
      m=8
    elsif sklzz[js][6]=='Special'
      m=9
    elsif sklzz[js][6].split(', ').include?('Passive(A)')
      m=10
    elsif sklzz[js][6].split(', ').include?('Passive(B)')
      m=11
    elsif sklzz[js][6].split(', ').include?('Passive(C)')
      m=12
    else
      event.respond "#{q} cannot be equipped.#{"\nUse the `FEH!edit seal` command to equip a seal." if sklzz[js][6].split(', ').include?('Passive(S)') || sklzz[js][6].split(', ').include?('Seal')}"
      return nil
    end
    x=backwards_skill_tree(js, nil, donor_units[j2][m])
    donor_units[j2][m]=x[0].map{|q| q}
    donor_unit_save(uid,donor_units)
    dispstr=''
    unless x[1].nil?
      dispstr="#{x[1]} has been used as the base because your #{donor_units[j2][0]} already knows it."
      dispstr="#{donor_units[j2][0]} doesn't officially know any of the prerequisites so I marked it as \"Unknown base\"." if dispstr.include?('~~')
    end
    event.respond "#{q} has been given to your #{donor_units[j2][0]}!#{"\n#{dispstr}" unless dispstr.length.zero?}#{"\nPlease use the `FEH!edit refine` command to refine the weapon." if sklzz[js][6]=='Weapon'}"
  elsif cmd.downcase=='create'
    event.respond "You already have a #{donor_units[j2][0]}."
    return nil
  elsif ['promote','rarity','feathers'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    donor_units[j2][1]=flurp[0] unless flurp[0].nil?
    donor_units[j2][1]+=1 if flurp[0].nil?
    donor_units[j2][1]=[donor_units[j2][1],5].min
    donor_units[j2][2]=0
    donor_unit_save(uid,donor_units)
    event.respond "You have promoted your #{donor_units[j2][0]} to #{donor_units[j2][1]}#{@rarity_stars[donor_units[j2][1]-1]}!"
  elsif ['merge','combine'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    if !flurp[1].nil?
      donor_units[j2][2]+=flurp[1]
    elsif !flurp[0].nil?
      donor_units[j2][2]+=flurp[0]
    else
      donor_units[j2][2]+=1
    end
    donor_units[j2][2]=[donor_units[j2][2],@max_rarity_merge[1]].min
    donor_unit_save(uid,donor_units)
    event.respond "You have merged your #{donor_units[j2][0]} to +#{donor_units[j2][2]}!"
  elsif ['flower','flowers','dragonflower','dragonflowers'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    if !flurp[8].nil?
      donor_units[j2][6]+=flurp[8]
    elsif !flurp[1].nil?
      donor_units[j2][6]+=flurp[1]
    elsif !flurp[0].nil?
      donor_units[j2][6]+=flurp[0]
    else
      donor_units[j2][6]+=1
    end
    donor_units[j2][6]=[donor_units[j2][6],2*@max_rarity_merge[2]].min
    donor_units[j2][6]=[donor_units[j2][6],@max_rarity_merge[2]].min unless j[3]=='Infantry' && j[9][0].include?('PF')
    donor_unit_save(uid,donor_units)
    event.respond "You have given #{donor_units[j2][0]} their #{longFormattedNumber(donor_units[j2][6],true)} flower!"
  elsif ['nature','ivs'].include?(cmd.downcase)
    flurp=find_stats_in_string(event,nil,1)
    n=''
    if flurp[2].nil? && flurp[3].nil?
      donor_units[j2][3]=' '
      donor_units[j2][4]=' '
      donor_unit_save(uid,donor_units)
      event.respond "You have changed your #{donor_units[j2][0]}'s nature to neutral!"
    elsif flurp[2].nil? || flurp[3].nil?
      @stored_event=[event,j]
      event.respond "You cannot have a boon without a bane.  Set stats to neutral?\nYes/No" if flurp[3].nil?
      event.respond "You cannot have a bane without a boon.  Set stats to neutral?\nYes/No" if flurp[2].nil?
      event.channel.await(:bob, contains: /(yes)|(no)/i, from: event.user.id) do |e|
        if e.message.text.downcase.include?('no')
          e.respond 'Okay.'
        else
          j2=@stored_event[1][0]
          j2=donor_units.find_index{|q| q[0]==j[0]}
          donor_units[j2][3]=' '
          donor_units[j2][4]=' '
          donor_unit_save(uid,donor_units)
          event.respond "You have changed your #{donor_units[j2][0]}'s nature to neutral!"
        end
      end
    else
      donor_units[j2][3]=flurp[2]
      donor_units[j2][4]=flurp[3]
      atk='Attack'
      atk='Magic' if ['Tome','Dragon','Healer'].include?(j[1][1])
      atk='Strength' if ['Blade','Bow','Dagger','Beast'].include?(j[1][1])
      n=nature_name(flurp[2],flurp[3])
      unless n.nil?
        n=n[0] if atk=='Strength'
        n=n[n.length-1] if atk=='Magic'
        n=n.join(' / ') if ['Attack','Freeze'].include?(atk)
      end
      donor_unit_save(uid,donor_units)
      event.respond "You have changed your #{donor_units[j2][0]}'s nature to +#{flurp[2]}, -#{flurp[3]} (#{n})!"
    end
  else
    event.respond 'Edit mode was not specified.'
  end
  return nil
end
