@mash='Mini-Matt'

def triple_finish(list,forcetwo=false) # used to split a list into three roughly-equal parts for use in embeds
  return [['.',list.join("\n")]] if list.length<5
  if list.length<10 || forcetwo
    l=0
    l=1 if list.length%2==1
    p1=list[0,list.length/2+l].join("\n")
    p2=list[list.length/2+l,list.length/2].join("\n")
    return [['.',p1],['.',p2]]
  end
  l=0
  l=1 if list.length%3==2
  m=0
  m=1 if list.length%3==1
  p1=list[0,list.length/3+l].join("\n")
  p2=list[list.length/3+l,list.length/3+m].join("\n")
  p3=list[2*(list.length/3)+l+m,list.length/3+l].join("\n")
  return [['.',p1],['.',p2],['.',p3]]
end

def pseudocase(str)
  return '' if str.nil? || str.length<=0
  str=str.split(' ').compact
  str[0]=str[0].downcase
  return str.join(' ')
end

def get_donor_list()
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHDonorList.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHDonorList.txt').each_line do |line|
      b.push(line.gsub("\n",'').split('\\'[0]))
    end
    for i in 0...b.length
      b[i][0]=b[i][0].to_i
      b[i][2]=b[i][2].split(', ').map{|q| q.to_i}
      b[i][3]=b[i][3].split('/').map{|q| q.to_i} unless b[i][3].nil?
      b[i][4]=b[i][4].split(', ') unless b[i][4].nil?
    end
  else
    b=[]
  end
  return b
end

def is_mod?(user,server,channel,mode=0) # used by certain commands to determine if a user can use them
  return true if user.id==167657750971547648 # bot developer is always an EliseMod
  return false if server.nil? # no one is a EliseMod in PMs
  return true if user.id==server.owner.id # server owners are EliseMods by default
  for i in 0...user.roles.length # certain role names will count as EliseMods even if they don't have legitimate mod powers
    return true if ['mod','mods','moderator','moderators','admin','admins','administrator','administrators','owner','owners'].include?(user.roles[i].name.downcase.gsub(' ',''))
  end
  return true if user.permission?(:manage_messages,channel) # legitimate mod powers also confer BotMod powers
  return false if mode>0
  return true if get_donor_list().reject{|q| q[2].max<2}.map{|q| q[0]}.include?(user.id) # people who donate to the laptop fund will always be BotMods for aliases
  return false
end

def normalize(str,allowspoiler=false) # used by the majority of commands that accept input, to replace all non-ASCII characters with their ASCII counterparts
  fallback_map={"\u2019" => "'", "`" => "'", "\u2018" => "'", "\u2B55" => 'O',
                "\u00E1" => 'a', "\u00C1" => 'a', "\u0103" => 'a', "\u01CE" => 'a', "\u00C2" => 'a', "\u00E2" => 'a', "\u00C4" => 'a', "\u00E4" => 'a',
                "\u0227" => 'a', "\u1EA1" => 'a', "\u0201" => 'a', "\u00C0" => 'a', "\u00E0" => 'a', "\u1EA3" => 'a', "\u0203" => 'a', "\u0101" => 'a',
                "\u0105" => 'a', "\u1E9A" => 'a', "\u00C5" => 'a', "\u00E5" => 'a', "\u1E01" => 'a', "\u023A" => 'a', "\u00C3" => 'a', "\u00E3" => 'a',
                "\u0363" => 'a', "\u1D00" => 'a', "\u0251" => 'a', "\u0250" => 'a', "\u0252" => 'a', "\u22C0" => 'a', "\u00C6" => 'ae', "\u1D01" => 'ae',
                "\u00E6" => 'ae', "\u1D02" => 'ae', "\u1E03" => 'b', "\u1E05" => 'b', "\u0181" => 'b', "\u0253" => 'b', "\u1E07" => 'b', "\u0243" => 'b',
                "\u0180" => 'b', "\u0183" => 'b', "\u0299" => 'b', "\u1D03" => 'b', "\u212C" => 'b', "\u0185" => 'b', "\u0107" => 'c', "\u010D" => 'c',
                "\u00C7" => 'c', "\u00E7" => 'c', "\u0109" => 'c', "\u0255" => 'c', "\u010B" => 'c', "\u0189" => 'c', "\u023B" => 'c', "\u023C" => 'c',
                "\u2183" => 'c', "\u212D" => 'c', "\u0368" => 'c', "\u2102" => 'c', "\u1D04" => 'c', "\u0297" => 'c', "\u2184" => 'c',"\u0256" => 'd', 
                "\u010F" => 'd', "\u1E11" => 'd', "\u1E13" => 'd', "\u0221" => 'd', "\u1E0B" => 'd', "\u1E0D" => 'd', "\u018A" => 'd', "\u0257" => 'd',
                "\u1E0F" => 'd', "\u0111" => 'd', "\u018C" => 'd', "\u0369" => 'd', "\u2145" => 'd', "\u2146" => 'd', "\u1D05" => 'd', "\u00C9" => 'e',
                "\u00E9" => 'e', "\u0115" => 'e', "\u011B" => 'e', "\u0229" => 'e', "\u1E19" => 'e', "\u00CA" => 'e', "\u00EA" => 'e', "\u00CB" => 'e',
                "\u00EB" => 'e', "\u0117" => 'e', "\u1EB9" => 'e', "\u0205" => 'e', "\u00C8" => 'e', "\u00E8" => 'e', "\u1EBB" => 'e', "\u025D" => 'e',
                "\u0207" => 'e', "\u0113" => 'e', "\u0119" => 'e', "\u0246" => 'e', "\u0247" => 'e', "\u1E1B" => 'e', "\u1EBD" => 'e', "\u0364" => 'e',
                "\u2147" => 'e', "\u0190" => 'e', "\u018E" => 'e', "\u1D07" => 'e', "\u029A" => 'e', "\u025E" => 'e', "\u025B" => 'e', "\u0258" => 'e',
                "\u025C" => 'e', "\u01DD" => 'e', "\u1D08" => 'e', "\u2130" => 'e', "\u212F" => 'e', "\u0259" => 'e', "\u018F" => 'e', "\u22FF" => 'e',
                "\u1E1F" => 'f', "\u0192" => 'f', "\u2131" => 'f', "\u2132" => 'f', "\u214E" => 'f', "\u2640" => '(f)', "\u01F5" => 'g', "\u011F" => 'g',
                "\u01E7" => 'g', "\u0123" => 'g', "\u011D" => 'g', "\u0121" => 'g', "\u0193" => 'g', "\u029B" => 'g', "\u0260" => 'g', "\u1E21" => 'g',
                "\u01E5" => 'g', "\u0262" => 'g', "\u0261" => 'g', "\u210A" => 'g', "\u2141" => 'g', "\u210C" => 'h', "\u1E2B" => 'h', "\u021F" => 'h',
                "\u1E29" => 'h', "\u0125" => 'h', "\u1E27" => 'h', "\u1E23" => 'h', "\u1E25" => 'h', "\u02AE" => 'h', "\u0266" => 'h', "\u1E96" => 'h',
                "\u0127" => 'h', "\u036A" => 'h', "\u210D" => 'h', "\u029C" => 'h', "\u0265" => 'h', "\u2095" => 'h', "\u02B0" => 'h', "\u210B" => 'h',
                "\u2111" => 'i', "\u0130" => 'i', "\u00CD" => 'i', "\u00ED" => 'i', "\u012D" => 'i', "\u01D0" => 'i', "\u00CE" => 'i', "\u00EE" => 'i',
                "\u00CF" => 'i', "\u00EF" => 'i', "\u1CEB" => 'i', "\u0209" => 'i', "\u00CC" => 'i', "\u00EC" => 'i', "\u1EC9" => 'i', "\u020B" => 'i',
                "\u012B" => 'i', "\u012F" => 'i', "\u0197" => 'i', "\u0268" => 'i', "\u1E2D" => 'i', "\u0129" => 'i', "\u0365" => 'i', "\u2148" => 'i',
                "\u026A" => 'i', "\u0131" => 'i', "\u1D09" => 'i', "\u1D62" => 'i', "\u2110" => 'i', "\u2071" => 'i', "\u2139" => 'i', "\uFE0F" => 'i',
                "\u1FBE" => 'i', "\u03B9" => 'i', "\u0399" => 'i', "\u0133" => 'ij', "\u01F0" => 'j', "\u0135" => 'j', "\u029D" => 'j', "\u0248" => 'j',
                "\u0249" => 'j', "\u025F" => 'j', "\u2149" => 'j', "\u1D0A" => 'j', "\u0237" => 'j', "\u02B2" => 'j', "\u1E31" => 'k', "\u01E9" => 'k',
                "\u0137" => 'k', "\u1E33" => 'k', "\u0199" => 'k', "\u1E35" => 'k', "\u1D0B" => 'k', "\u029E" => 'k', "\u2096" => 'k', "\u212A" => 'k',
                "\u0138" => 'k', "\u013A" => 'l', "\u023D" => 'l', "\u019A" => 'l', "\u026C" => 'l', "\u013E" => 'l', "\u013C" => 'l', "\u1E3D" => 'l',
                "\u0234" => 'l', "\u1E37" => 'l', "\u1E3B" => 'l', "\u0140" => 'l', "\u026B" => 'l', "\u026D" => 'l', "\u1D0C" => 'l', "\u0142" => 'l',
                "\u029F" => 'l', "\u2097" => 'l', "\u02E1" => 'l', "\u2143" => 'l', "\u2112" => 'l', "\u2113" => 'l', "\u2142" => 'l', "\u2114" => 'lb',
                "\u264C" => 'leo', "\u1E3F" => 'm', "\u1E41" => 'm', "\u1E43" => 'm', "\u0271" => 'm', "\u0270" => 'm', "\u036B" => 'm', "\u019C" => 'm',
                "\u1D0D" => 'm', "\u1D1F" => 'm', "\u026F" => 'm', "\u2098" => 'm', "\u2133" => 'm', "\u2642" => '(m)', "\u0144" => 'n', "\u0148" => 'n', 
                "\u0146" => 'n', "\u1E4B" => 'n', "\u0235" => 'n', "\u1E45" => 'n', "\u1E47" => 'n', "\u01F9" => 'n', "\u019D" => 'n', "\u0272" => 'n',
                "\u1E49" => 'n', "\u0220" => 'n', "\u019E" => 'n', "\u0273" => 'n', "\u00D1" => 'n', "\u00F1" => 'n', "\u2115" => 'n', "\u0274" => 'n',
                "\u1D0E" => 'n', "\u2099" => 'n', "\u22C2" => 'n', "\u220F" => 'n', "\u00F3" => 'o', "\u00F0" => 'o', "\u00D3" => 'o', "\u014F" => 'o',
                "\u01D2" => 'o', "\u00D4" => 'o', "\u00F4" => 'o', "\u00D6" => 'o', "\u00F6" => 'o', "\u022F" => 'o', "\u1ECD" => 'o', "\u0151" => 'o',
                "\u020D" => 'o', "\u00D2" => 'o', "\u00F2" => 'o', "\u1ECF" => 'o', "\u01A1" => 'o', "\u020F" => 'o', "\u014D" => 'o', "\u019F" => 'o',
                "\u01EB" => 'o', "\u00D8" => 'o', "\u00F8" => 'o', "\u1D13" => 'o', "\u00D5" => 'o', "\u00F5" => 'o', "\u0366" => 'o', "\u0186" => 'o',
                "\u1D0F" => 'o', "\u1D10" => 'o', "\u0275" => 'o', "\u1D11" => 'o', "\u2134" => 'o', "\u25CB" => 'o', "\u00A4" => 'o', "\u1D14" => 'oe',
                "\u0153" => 'oe', "\u0276" => 'oe', "\u01A3" => 'oi', "\u0223" => 'ou', "\u1D15" => 'ou', "\u1E55" => 'p', "\u1E57" => 'p', "\u01A5" => 'p',
                "\u2119" => 'p', "\u1D18" => 'p', "\u209A" => 'p', "\u2118" => 'p', "\u214C" => 'p', "\u024A" => 'q', "\u024B" => 'q', "\u02A0" => 'q',
                "\u211A" => 'q', "\u213A" => 'q', "\u0239" => 'qp', "\u211C" => 'r', "\u0155" => 'r', "\u0159" => 'r', "\u0157" => 'r', "\u1E59" => 'r',
                "\u1E5B" => 'r', "\u0211" => 'r', "\u027E" => 'r', "\u027F" => 'r', "\u027B" => 'r', "\u0213" => 'r', "\u1E5F" => 'r', "\u027C" => 'r',
                "\u027A" => 'r', "\u024C" => 'r', "\u024D" => 'r', "\u027D" => 'r', "\u036C" => 'r', "\u211D" => 'r', "\u0280" => 'r', "\u0281" => 'r',
                "\u1D19" => 'r', "\u1D1A" => 'r', "\u0279" => 'r', "\u1D63" => 'r', "\u02B3" => 'r', "\u02B6" => 'r', "\u02B4" => 'r', "\u211B" => 'r',
                "\u01A6" => 'r', "\u301C" => 'roy', "\u015B" => 's', "\u0161" => 's', "\u015F" => 's', "\u015D" => 's', "\u0219" => 's', "\u1E61" => 's',
                "\u1E63" => 's', "\u0282" => 's', "\u023F" => 's', "\u209B" => 's', "\u02E2" => 's', "\u1E9B" => 's', "\u223E" => 's', "\u017F" => 's',
                "\u00DF" => 's', "\u0165" => 't', "\u0163" => 't', "\u1E71" => 't', "\u021B" => 't', "\u0236" => 't', "\u1E97" => 't', "\u023E" => 't',
                "\u1E6B" => 't', "\u1E6D" => 't', "\u01AD" => 't', "\u1E6F" => 't', "\u01AB" => 't', "\u01AE" => 't', "\u0288" => 't', "\u0167" => 't',
                "\u036D" => 't', "\u1D1B" => 't', "\u0287" => 't', "\u209C" => 't', "\u00FE" => 'th', "\u00FA" => 'u', "\u028A" => 'u', "\u22C3" => 'u',
                "\u0244" => 'u', "\u0289" => 'u', "\u00DA" => 'u', "\u1E77" => 'u', "\u016D" => 'u', "\u01D4" => 'u', "\u00DB" => 'u', "\u00FB" => 'u',
                "\u1E73" => 'u', "\u00DC" => 'u', "\u00FC" => 'u', "\u1EE5" => 'u', "\u0171" => 'u', "\u0215" => 'u', "\u00D9" => 'u', "\u00F9" => 'u',
                "\u1EE7" => 'u', "\u01B0" => 'u', "\u0217" => 'u', "\u016B" => 'u', "\u0173" => 'u', "\u016F" => 'u', "\u1E75" => 'u', "\u0169" => 'u',
                "\u0367" => 'u', "\u1D1C" => 'u', "\u1D1D" => 'u', "\u1D1E" => 'u', "\u1D64" => 'u', "\u22C1" => 'v', "\u030C" => 'v', "\u1E7F" => 'v',
                "\u028B" => 'v', "\u1E7D" => 'v', "\u036E" => 'v', "\u01B2" => 'v', "\u0245" => 'v', "\u1D20" => 'v', "\u028C" => 'v', "\u1D65" => 'v',
                "\u1E83" => 'w', "\u0175" => 'w', "\u1E85" => 'w', "\u1E87" => 'w', "\u1E89" => 'w', "\u1E81" => 'w', "\u1E98" => 'w', "\u1D21" => 'w',
                "\u028D" => 'w', "\u02B7" => 'w', "\u2715" => 'x', "\u2716" => 'x', "\u033D" => 'x', "\u0353" => 'x', "\u1E8D" => 'x', "\u1E8B" => 'x',
                "\u2717" => 'x', "\u036F" => 'x', "\u2718" => 'x', "\u02E3" => 'x', "\u2A09" => 'x', "\u00DD" => 'y', "\u00FD" => 'y', "\u0177" => 'y',
                "\u0178" => 'y', "\u00FF" => 'y', "\u1E8F" => 'y', "\u1EF5" => 'y', "\u1EF3" => 'y', "\u1EF7" => 'y', "\u01B4" => 'y', "\u0233" => 'y',
                "\u1E99" => 'y', "\u024E" => 'y', "\u024F" => 'y', "\u1EF9" => 'y', "\u028F" => 'y', "\u028E" => 'y', "\u02B8" => 'y', "\u2144" => 'y',
                "\u00A5" => 'y', "\u01B6" => 'z', "\u017A" => 'z', "\u017E" => 'z', "\u1E91" => 'z', "\u0291" => 'z', "\u017C" => 'z', "\u1E93" => 'z',
                "\u0225" => 'z', "\u1E95" => 'z', "\u0290" => 'z', "\u0240" => 'z', "\u2128" => 'z', "\u2124" => 'z', "\u1D22" => 'z'}
  str=str.gsub(/\s+/,' ').gsub(/[[:space:]]+/,' ').gsub(/[[:cntrl:]]/,' ').gsub("``",'')
  str=str.gsub('||','') unless allowspoiler
  str=str.gsub("\u{1F1E6}","A").gsub("\u{1F1E7}","B").gsub("\u{1F1E8}","C").gsub("\u{1F1E9}","D").gsub("\u{1F1EA}","E").gsub("\u{1F1EB}","F").gsub("\u{1F1EC}","G").gsub("\u{1F1ED}","H").gsub("\u{1F1EE}","I").gsub("\u{1F1EF}","J").gsub("\u{1F1F0}","K").gsub("\u{1F1F1}","L").gsub("\u{1F1F2}","M").gsub("\u{1F1F3}","N").gsub("\u{1F1F4}","O").gsub("\u{1F1F5}","P").gsub("\u{1F1F6}","Q").gsub("\u{1F1F7}","R").gsub("\u{1F1F8}","S").gsub("\u{1F1F9}","T").gsub("\u{1F1FA}","U").gsub("\u{1F1FB}","V").gsub("\u{1F1FC}","W").gsub("\u{1F1FD}","X").gsub("\u{1F1FE}","Y").gsub("\u{1F1FF}","Z").gsub("\u{1F170}",'A').gsub("\u{1F171}",'B').gsub("\u{1F18E}",'AB').gsub("\u{1F191}",'CL').gsub("\u{1F17E}",'O').gsub("\u{1F198}",'SOS').gsub("\u{1F34D}",'pineapple').gsub("\u{1F5D1}",'trash').gsub("\u{1F345}",'tomato').gsub("\u{1F440}",'eyes').gsub("\u{1F954}",'potato').gsub("\u{1F63A}",'cat').gsub("\u{1F341}",'leaf').gsub("\u{1F342}",'leaf').gsub("\u{1F343}",'leaf').gsub("\u{1F34C}",'banana').gsub("\u{1F6AE}",'trash')
  strx=str.encode("ASCII", "UTF-8", fallback: fallback_map, invalid: :replace, undef: :replace, replace: "")
  str="#{strx}" unless strx.length<=0
  return str
end

def has_any?(arr1,arr2) # used to determine if two arrays share any members
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
  return true if (arr1 & arr2).length>0
  return false
end

def count_in(arr,str,mode=0) # used to count the number of times a string is mentioned
  if str.is_a?(Array)
    return arr.count{|x| str.map{|y| y.downcase}.include?(x.downcase)}
  elsif arr.is_a?(String)
    return arr.chars.count{|x| x.downcase==str.downcase}
  end
  return arr.count{|x| x[0,str.length].downcase==str.downcase} if mode==1
  return arr.count{|x| x.downcase==str.downcase}
end

def first_sub(master,str1,str2,mode=0)
  master=master.gsub('!','') if mode==0
  posit=master.downcase.index(str1.downcase)
  return master if posit.nil?
  return "#{master[0,posit] if posit>0}#{str2}#{master[posit+str1.length,master.length] if posit+str1.length<master.length}"
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

def micronumber(n)
  m=["\u2080","\u2081","\u2082","\u2083","\u2084","\u2085","\u2086","\u2087","\u2088","\u2089"]
  return "\uFE63#{micronumber(0-n)}" if n<0
  return "#{micronumber(n/10)}#{m[n%10]}" if n>9
  return m[n]
end

def extend_message(msg1,msg2,event,enters=1,sym="\n")
  if "#{msg1}#{sym*enters}#{msg2}".length>=2000
    event.respond msg1
    return msg2
  else
    return "#{msg1}#{sym*enters}#{msg2}"
  end
end

def supersort(a,b,m,n=nil,mode=0)
  unless n.nil?
    return supersort(a,b,0) if n<0
    if a[m][n].is_a?(String) && b[m][n].is_a?(String) && mode==1
      return a[m][n].downcase <=> b[m][n].downcase
    elsif a[m][n].is_a?(String) && b[m][n].is_a?(String)
      return b[m][n].downcase <=> a[m][n].downcase
    elsif a[m][n].is_a?(String)
      return -1
    elsif b[m][n].is_a?(String)
      return 1
    elsif a[m][n].is_a?(Array) && b[m][n].is_a?(Array)
      return a[m][n][0] <=> b[m][n][0]
    elsif a[m][n].is_a?(Array)
      return 1
    elsif b[m][n].is_a?(Array)
      return -1
    else
      return a[m][n] <=> b[m][n]
    end
  end
  if a[m].is_a?(String) && b[m].is_a?(String) && mode==1
    return a[m].downcase <=> b[m].downcase
  elsif a[m].is_a?(String) && b[m].is_a?(String)
    return b[m].downcase <=> a[m].downcase
  elsif a[m].is_a?(String)
    return -1
  elsif b[m].is_a?(String)
    return 1
  elsif a[m].is_a?(Array) && b[m].is_a?(Array)
    return a[m][0] <=> b[m][0]
  elsif a[m].is_a?(Array)
    return 1
  elsif b[m].is_a?(Array)
    return -1
  else
    return a[m] <=> b[m]
  end
end

def not_both(a,b)
  return false if a && b
  return true if a || b
  return false
end

def list_lift(a,c)
  if a.length==1
    return a[0]
  elsif a.length==2
    return "#{a[0]} #{c} #{a[1]}"
  else
    b=a[a.length-1]
    a.pop
    a.uniq!
    return "#{a.join(', ')}, #{c} #{b}"
  end
end

def avg_color(c,mode=0)
  m=[0,0,0]
  for i in 0...c.length
    unless c[i].is_a?(Array)
      x=1*c[i]
      c[i]=[]
      c[i].push(x/(256*256))
      x=x % (256*256)
      c[i].push(x/256)
      x=x%256
      c[i].push(x)
    end
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
    k='th'
    unless (number%100)/10==1
      k='st' if number%10==1
      k='nd' if number%10==2
      k='rd' if number%10==3
    end
    return "#{longFormattedNumber(number,false)}#{k}"
  end
  return "#{number}" if number<1000
  if number%1000<10
    bob="00#{number%1000}"
  elsif number%1000<100
    bob="0#{number%1000}"
  elsif number%1000<1000
    bob="#{number%1000}"
  end
  return "#{longFormattedNumber(number/1000)},#{bob}"
end

def prio(arr,o)
  x=[]
  for i in 0...o.length
    x.push(o[i]) if arr.include?(o[i])
  end
  return x
end

def was_embedless_mentioned?(event) # used to detect if someone who wishes to see responses as plaintext is relevant to the information being displayed
  for i in 0...@embedless.length
    return true if event.user.id==@embedless[i]
    return true if event.message.text.include?("<@#{@embedless[i].to_s}>")
    return true if event.message.text.include?("<@!#{@embedless[i].to_s}>")
  end
  return false
end

def create_embed(event,header,text,xcolor=nil,xfooter=nil,xpic=nil,xfields=nil,mode=0) # used by most commands to display embeds or plaintext, based on the results of the above function
  ftrlnth=0
  ftrlnth=xfooter.length unless xfooter.nil?
  ch_id=0
  if event.is_a?(Array)
    ch_id=event[1]
    event=event[0]
  end
  title=nil
  if header.is_a?(Array)
    title=header[1]
    header=header[0]
    header='' if header.nil?
  end
  if title.is_a?(Array)
    text="#{title[1]}\n\n#{text}"
    title=title[0]
  end
  if @embedless.include?(event.user.id) || (was_embedless_mentioned?(event) && ch_id==0)
    str=''
    if header.length>0
      if header.include?('*') || header.include?('_')
        str=header
      else
        str="__**#{header.gsub('!','')}**__"
      end
    end
    unless title.nil? || title.length<=0
      str="#{str}\n" unless title[0,2]=='<:'
      str="#{str}\n#{title}"
      str="#{str}\n" unless [title[title.length-1,1],title[title.length-2,2]].include?("\n")
    end
    unless text.length<=0
      str="#{str}\n" unless text[0,2]=='<:'
      str="#{str}\n#{text}"
      str="#{str}\n" unless [text[text.length-1,1],text[text.length-2,2]].include?("\n")
    end
    unless xfields.nil?
      if mode.zero?
        for i in 0...xfields.length
          k="__#{xfields[i][0]}:__ #{xfields[i][1].gsub("\n",' / ')}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      elsif [-1,1].include?(mode)
        if mode==-1
          last_field=xfields[xfields.length-1][1].split("\n").join("\n")
          last_field_name=xfields[xfields.length-1][0].split("\n").join("\n")
          xfields.pop
        end
        atk=xfields[0][1].split("\n")[1].split(': ')[0]
        statnames=['<:HP_S:467037520538894336> HP: ',"#{atk}: ",'<:SpeedS:467037520534962186> Speed: ','<:DefenseS:467037520249487372> Defense: ','<:ResistanceS:467037520379641858> Resistance: ','BST: ']
        fields=[[],['**<:HP_S:467037520538894336> HP:**'],["**#{atk}:**"],['**<:SpeedS:467037520534962186> Speed:**'],['**<:DefenseS:467037520249487372> Defense:**'],['**<:ResistanceS:467037520379641858> Resistance:**'],['**BST:**']]
        for i in 0...xfields.length
          fields[0].push(xfields[i][0])
          flumb=xfields[i][1].split("\n")
          flumb[5]=nil
          flumb.compact!
          for j in 0...flumb.length
            if i.zero?
              fields[j+1][0]="#{fields[j+1][0]}  #{flumb[j].gsub(statnames[j],'').gsub('GPT: ','')}"
            else
              fields[j+1].push(flumb[j].gsub(statnames[j],'').gsub('GPT: ',''))
            end
          end
        end
        str="#{str}\n"
        for i in 0...fields.length
          k=fields[i].join(' / ')
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
        if mode==-1
          k="\n__**#{last_field_name.gsub('**','')}**__\n#{last_field}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      elsif mode==-2
        last_field=xfields[xfields.length-1][1].split("\n").join("\n")
        last_field_name=xfields[xfields.length-1][0].split("\n").join("\n")
        emo=last_field.split("\n")[1].split(' ')[0]
        xfields.pop
        atk=xfields[0][1].split("\n")[2].split(': ')[0]
        statnames=['HP: ',"#{atk}: ",'Speed: ','Defense: ','Resistance: ','BST: ']
        fields=[[],['**<:HP_S:467037520538894336> HP:**'],["**#{emo} #{atk}:**"],['**<:SpeedS:467037520534962186> Speed:**'],['**<:DefenseS:467037520249487372> Defense:**'],['**<:ResistanceS:467037520379641858> Resistance:**'],['**BST:**']]
        for i in 0...xfields.length
          fields[0].push(xfields[i][0])
          flumb=xfields[i][1].split("\n")
          flumb.shift
          flumb[5]=nil
          flumb.compact!
          for j in 0...flumb.length
            if i.zero?
              fields[j+1][0]="#{fields[j+1][0]}  #{flumb[j].gsub(statnames[j],'').gsub('GPT: ','')}"
            else
              fields[j+1].push(flumb[j].gsub(statnames[j],'').gsub('GPT: ',''))
            end
          end
        end
        str="#{str}\n"
        for i in 0...fields.length
          k=fields[i].join(' / ')
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
        str="#{str}\n"
        k="__**#{last_field_name.gsub('**','')}**__\n#{last_field}"
        if str.length+k.length>=1900
          if ch_id==1
            event.user.pm(str)
          else
            event.channel.send_message(str)
          end
          str=k
        else
          str="#{str}\n#{k}"
        end
      elsif mode==3
        for i in 0...xfields.length
          k="__#{xfields[i][0]}:__ #{xfields[i][1].gsub("\n",', ')}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      elsif mode==4
        for i in 0...xfields.length
          k="**#{xfields[i][0]}:** #{xfields[i][1].gsub("\n",', ')}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      elsif mode==5
        for i in 0...xfields.length-1
          k="**#{xfields[i][0]}:** #{xfields[i][1].gsub("\n",' / ')}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
        i=xfields.length-1
        str="#{str}\n**#{xfields[i][0]}:**"
        m=xfields[i][1].split("\n\n").map{|q| q.split("\n")}
        for i in 0...m.length
          if m[i].length<=1
            k="*#{m[i][0]}*"
          else
            k="*#{m[i][0]}*: #{m[i][1,m[i].length-1].join(' / ')}"
          end
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str)
            else
              event.channel.send_message(str)
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      else
        for i in 0...xfields.length
          k="\n#{xfields[i][0]}\n#{xfields[i][1]}"
          if str.length+k.length>=1900
            if ch_id==1
              event.user.pm(str.gsub("```\n\n","```"))
            else
              event.channel.send_message(str.gsub("```\n\n","```"))
            end
            str=k
          else
            str="#{str}\n#{k}"
          end
        end
      end
    end
    k=''
    k="\n#{xfooter}" unless xfooter.nil?
    if str.length+k.length>=1900
      if ch_id==1
        event.user.pm(str.gsub("```\n\n","```"))
        event.user.pm(k.gsub("```\n\n","```"))
      else
        event.channel.send_message(str.gsub("```\n\n","```"))
        event.channel.send_message(k.gsub("```\n\n","```"))
      end
    elsif ch_id==1
      event.user.pm("#{str}\n#{k}".gsub("```\n\n","```"))
    else
      event.channel.send_message("#{str}\n#{k}".gsub("```\n\n","```"))
    end
  elsif !xfields.nil? && ftrlnth+header.length+text.length+xfields.map{|q| "#{q[0]}\n\n#{q[1]}"}.length>=1950 && ch_id==1
    event.user.pm.send_embed(header) do |embed|
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
    end
    event.user.pm.send_embed('') do |embed|
      embed.description=''
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil? || xpic.is_a?(Array)
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic[0]) unless xpic.nil? || !xpic.is_a?(Array) || xpic[0].nil?
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: xpic[1]) unless xpic.nil? || !xpic.is_a?(Array) || xpic[1].nil?
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0].gsub('**',''), value: xfields[i][1], inline: xfields[i][2].nil?)
        end
      end
    end
  elsif !xfields.nil? && ftrlnth+header.length+text.length+xfields.map{|q| "#{q[0]}\n\n#{q[1]}"}.length>=1950
    event.channel.send_embed(header) do |embed|
      embed.title=title unless title.nil?
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
    end
    event.channel.send_embed('') do |embed|
      embed.description=''
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil? || xpic.is_a?(Array)
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic[0]) unless xpic.nil? || !xpic.is_a?(Array) || xpic[0].nil?
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: xpic[1]) unless xpic.nil? || !xpic.is_a?(Array) || xpic[1].nil?
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0].gsub('**',''), value: xfields[i][1], inline: xfields[i][2].nil?)
        end
      end
    end
  elsif ch_id==1
    event.user.pm.send_embed(header) do |embed|
      embed.title=title unless title.nil?
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0].gsub('**',''), value: xfields[i][1], inline: xfields[i][2].nil?)
        end
      end
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil? || xpic.is_a?(Array)
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic[0]) unless xpic.nil? || !xpic.is_a?(Array) || xpic[0].nil?
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: xpic[1]) unless xpic.nil? || !xpic.is_a?(Array) || xpic[1].nil?
    end
  else
    event.channel.send_embed(header) do |embed|
      embed.title=title unless title.nil?
      embed.description=text
      embed.color=xcolor unless xcolor.nil?
      embed.footer={"text"=>xfooter} unless xfooter.nil?
      unless xfields.nil?
        for i in 0...xfields.length
          embed.add_field(name: xfields[i][0].gsub('**',''), value: xfields[i][1], inline: xfields[i][2].nil?)
        end
      end
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic) unless xpic.nil? || xpic.is_a?(Array)
      embed.thumbnail=Discordrb::Webhooks::EmbedThumbnail.new(url: xpic[0]) unless xpic.nil? || !xpic.is_a?(Array) || xpic[0].nil?
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: xpic[1]) unless xpic.nil? || !xpic.is_a?(Array) || xpic[1].nil?
    end
  end
  return nil
end

def triple_weakness(bot,event)
  types=[[1, 1,   1,   1,   1,   0.5, 1,   0,   0.5, 1,   1,   1,   1,   1,   1,   1,   1,   1,   "Normal",   0xA8A77A],
         [2, 1,   0.5, 0.5, 1,   2,   0.5, 0,   2,   1,   1,   1,   1,   0.5, 2,   1,   2,   0.5, "Fighting", 0xC22E28, ['fight']],
         [1, 2,   1,   1,   1,   0.5, 2,   1,   0.5, 1,   1,   2,   0.5, 1,   1,   1,   1,   1,   "Flying",   0xA98FF3, ['fly', 'air', 'bird', 'wind']],
         [1, 1,   1,   0.5, 0.5, 0.5, 1,   0.5, 0,   1,   1,   2,   1,   1,   1,   1,   1,   2,   "Poison",   0xA33EA1, ['psn', 'toxic']],
         [1, 1,   0,   2,   1,   2,   0.5, 1,   2,   2,   1,   0.5, 2,   1,   1,   1,   1,   1,   "Ground",   0xE2BF65],
         [1, 0.5, 2,   1,   0.5, 1,   2,   1,   0.5, 2,   1,   1,   1,   1,   2,   1,   1,   1,   "Rock",     0xB6A136],
         [1, 0.5, 0.5, 0.5, 1,   1,   1,   0.5, 0.5, 0.5, 1,   2,   1,   2,   1,   1,   2,   0.5, "Bug",      0xA6B91A, ['insect']],
         [0, 1,   1,   1,   1,   1,   1,   2,   1,   1,   1,   1,   1,   2,   1,   1,   0.5, 1,   "Ghost",    0x735797, ['spooky', 'spook', 'spoopy']],
         [1, 1,   1,   1,   1,   2,   1,   1,   0.5, 0.5, 0.5, 1,   0.5, 1,   2,   1,   1,   2,   "Steel",    0xB7B7CE, ['metal']],
         [1, 1,   1,   1,   1,   0.5, 2,   1,   2,   0.5, 0.5, 2,   1,   1,   2,   0.5, 1,   1,   "Fire",     0xEE8130, ['flame']],
         [1, 1,   1,   1,   2,   2,   1,   1,   1,   2,   0.5, 0.5, 1,   1,   1,   0.5, 1,   1,   "Water",    0x6390F0, ['aqua']],
         [1, 1,   0.5, 0.5, 2,   2,   0.5, 1,   0.5, 0.5, 2,   0.5, 1,   1,   1,   0.5, 1,   1,   "Grass",    0x7AC74C, ['plant']],
         [1, 1,   2,   1,   0,   1,   1,   1,   1,   1,   2,   0.5, 0.5, 1,   1,   0.5, 1,   1,   "Electric", 0xF7D02C, ['elec', 'lightning']],
         [1, 2,   1,   2,   1,   1,   1,   1,   0.5, 1,   1,   1,   1,   0.5, 1,   1,   0,   1,   "Psychic",  0xF95587, ['psy']],
         [1, 1,   2,   1,   2,   1,   1,   1,   0.5, 0.5, 0.5, 2,   1,   1,   0.5, 2,   1,   1,   "Ice",      0x96D9D6, ['icy']],
         [1, 1,   1,   1,   1,   1,   1,   1,   0.5, 1,   1,   1,   1,   1,   1,   2,   1,   0,   "Dragon",   0x6F35FC],
         [1, 0.5, 1,   1,   1,   1,   1,   2,   1,   1,   1,   1,   1,   2,   1,   1,   0.5, 0.5, "Dark",     0x705746, ['evil', 'darkness']],
         [1, 2,   1,   0.5, 1,   1,   1,   1,   0.5, 0.5, 1,   1,   1,   1,   1,   2,   2,   1,   "Fairy",    0xD685AD, ['fae', 'faerie']]]
  args=event.message.text.downcase.gsub(',','').split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  tpz=[]
  inv=false
  for i in 0...args.length
    for j in 0...types.length
      tpz.push(j) if args[i]==types[j][18].downcase || (!types[j][20].nil? && types[j][20].include?(args[i]))
    end
    inv=true if ['inverse','reverse','backwards'].include?(args[i])
  end
  tpz=tpz.uniq
  if @shardizard==4
  elsif !event.server.nil? && event.server.id==330850148261298176 && bot.user(206147275775279104).on(event.server.id).nil?
  else
    return nil if tpz.length<3 && !inv
  end
  if inv
    for i in 0...types.length
      for i2 in 0...types.length
        if types[i][i2]==0
          types[i][i2]=2
        else
          types[i][i2]=1.0/types[i][i2]
        end
      end
    end
  end
  w=types.map{|q| [q[18],1]}
  colors=[]
  for i in 0...[3,tpz.length].min
    colors.push(types[tpz[i]][19])
    for i2 in 0...w.length
      w[i2][1]*=types[i2][tpz[i]]
    end
  end
  w.push(['~~Flying Press~~',w[1][1]*w[2][1]])
  w.push(['~~Freeze Dry~~',w[10][1]*4]) if tpz[0,3].map{|q| types[q][18]}.include?('Water') && !inv
  for i in 0...w.length
    w[i][1]=w[i][1].to_i if w[i][1]==w[i][1].to_i
  end
  flds=[['8x weak to:',w.reject{|q| q[1]!=8}.map{|q| q[0]}.join(', ')],
        ['4x weak to:',w.reject{|q| q[1]!=4}.map{|q| q[0]}.join(', ')],
        ['2x weak to:',w.reject{|q| q[1]!=2}.map{|q| q[0]}.join(', ')],
        ['Takes neutral damage from:',w.reject{|q| q[1]!=1}.map{|q| q[0]}.join(', ')],
        ['2x resists:',w.reject{|q| q[1]!=0.5}.map{|q| q[0]}.join(', ')],
        ['4x resists:',w.reject{|q| q[1]!=0.25}.map{|q| q[0]}.join(', ')],
        ['8x resists:',w.reject{|q| q[1]!=0.125}.map{|q| q[0]}.join(', ')],
        ['Immune to:',w.reject{|q| q[1]!=0}.map{|q| q[0]}.join(', ')]]
  flds=flds.reject{|q| q[1].nil? || q[1].length<=0}
  create_embed(event,"#{tpz[0,3].map{|q| types[q][18]}.join('/')}#{' (in an Inverse Battle)' if inv}",flds.map{|q| "**#{q[0]}**\n#{q[1]}"}.join("\n\n"),avg_color(colors))
end

def embedless_swap(bot,event)
  metadata_load()
  if @embedless.include?(event.user.id)
    for i in 0...@embedless.length
      @embedless[i]=nil if @embedless[i]==event.user.id
    end
    @embedless.compact!
    event.respond 'You will now see my replies as embeds again.'
  else
    @embedless.push(event.user.id)
    event.respond 'You will now see my replies as plaintext.'
  end
  metadata_save()
end

def dev_pm(bot,event,user_id,allowedids=[])
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648 || allowedids.include?(event.user.id) # only work when used by the developer
  f=event.message.text.split(' ')
  jke=false
  jke=true if ['rcx','.','x'].include?(f[2].downcase) && event.user.id==167657750971547648
  f="#{f[0]} #{f[1]} #{"#{f[2]} " if jke}"
  sig="<:MCandleTop:642901964308480040>\n<:MCandleBottom:642901962005938181>"
  sig="<:Smol_Ephraim:644015195710291968>" if event.user.id==78649866577780736
  bot.user(user_id.to_i).pm("#{first_sub(event.message.text,f,'',1)}#{"\n#{sig}" unless jke}")
  event.respond 'Message sent.'
end

def bliss_mode(bot,event,user_id)
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  metadata_load()
  bot.ignore_user(user_id.to_i)
  event.respond "#{bot.user(user_id.to_i).distinct} is now being ignored."
  @ignored.push(bot.user(user_id.to_i).id)
  bot.user(user_id.to_i).pm('You have been added to my ignore list.')
  metadata_save()
end

def dev_message(bot,event,channel_id,allowedids=[])
  return nil unless event.server.nil? || [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,508792801455243266,508793141202255874,508793425664016395,572792502159933440,523830882453422120].include?(event.server.id)
  if event.user.id==167657750971547648 || allowedids.include?(event.user.id)
  else
    event.respond 'Are you trying to use the `bugreport`, `suggestion`, or `feedback` command?'
    bot.user(167657750971547648).pm("#{event.user.distinct} (#{event.user.id}) tried to use the `sendmessage` command.")
    return nil
  end
  f=event.message.text.split(' ')
  jke=false
  jke=true if ['rcx','.','x'].include?(f[2].downcase) && event.user.id==167657750971547648
  f="#{f[0]} #{f[1]} #{"#{f[2]} " if jke}"
  sig="<:MCandleTop:642901964308480040>\n<:MCandleBottom:642901962005938181>"
  sig="<:Smol_Ephraim:644015195710291968>" if event.user.id==78649866577780736
  if jke
    bot.channel(channel_id).send_message("#{first_sub(event.message.text,f,'',1)}")
  else
    bot.channel(channel_id).send_message("#{first_sub(event.message.text,f,'',1)}\n#{sig}")
    bot.user(167657750971547648).pm("**Channel:** #{bot.channel(channel_id).name} (#{channel_id})\n**Responder:** #{event.user.distinct} (#{event.user.id})\n**Message:** #{first_sub(event.message.text,f,'',1)}") unless event.user.id==167657750971547648
    for i in 0...allowedids.length
      bot.user(allowedids[i]).pm("**Channel:** #{bot.channel(channel_id).name} (#{channel_id})\n**Responder:** #{event.user.distinct} (#{event.user.id})\n**Message:** #{first_sub(event.message.text,f,'',1)}") unless event.user.id==allowedids[i]
    end
  end
  event.respond 'Message sent.'
end

def donor_embed(bot,event,str='')
  str='' if str.nil?
  if @embedless.include?(event.user.id) || was_embedless_mentioned?(event) || event.message.text.downcase.include?('mobile') || event.message.text.downcase.include?('phone')
    event << '__**If you wish to donate to me:** A word from my developer__'
    event << ''
    event << 'Due to income regulations within the building where I live, I cannot accept donations in the form of PayPal, Patreon, or other forms of direct payment.  Only a small percentage of any such donations would actually reach me and the rest would end up in the hands of the owners of my building.'
    event << ''
    event << 'However, there are other options:'
    event << "- My Amazon wish list: http://a.co/0p3sBec (Items purchased from this list will be delivered to me)"
    event << '- You can also purchase an Amazon gift card and have it delivered via email to **rot8er.conex@gmail.com**.  (Quicklink: <https://goo.gl/femEcw>)'
    event << ''
    event << '~~Please note that supporting me means indirectly enabling my addiction to pretzels and pizza rolls.~~'
    event << ''
    event << "Donor List: <https://tinyurl.com/y5m8dv6k>"
    event << "Donor perks: <https://urlzs.com/kthnr>"
    event << ''
    event << str
  else
    str2="Due to income regulations within the building where I live, I cannot accept donations in the form of PayPal, Patreon, or other forms of direct payment.  Only a small percentage of any such donations would actually reach me and the rest would end up in the hands of the owners of my building."
    str2="#{str2}\n\nHowever, there are other options:"
    str2="#{str2}\n- You can purchase items from [this list](http://a.co/0p3sBec) and they will be delivered to me."
    str2="#{str2}\n- You can [purchase an Amazon gift card](https://goo.gl/femEcw) and have it delivered via email to **rot8er.conex@gmail.com**."
    str2="#{str2}\n- You can use your Nitro Boost on either [Elise's](https://discord.gg/9TaRd2h) or [Liz's](https://discord.gg/bcRcanR) primary emote servers, which will count as a $5 donation per month."
    str2="#{str2}\n\n[Donor List](https://tinyurl.com/y5m8dv6k)"
    str2="#{str2}\n[Donor Perks](https://urlzs.com/kthnr)"
    str2="#{str2}\n\n#{str}"
    create_embed(event,"__**If you wish to donate to me:** A word from my developer__",str2,0x008b8b,"Please note that supporting me means indirectly enabling my addiction to pretzels and pizza rolls.")
    event.respond "If you are on a mobile device and cannot click the links in the embed above, retype the command but with \"mobile\" in your message, to receive this message as plaintext."
  end
end

def walk_away(bot,event,server_id)
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  chn=bot.server(server_id.to_i).general_channel
  if chn.nil?
    chnn=[]
    for i in 0...bot.server(server_id.to_i).channels.length
      chnn.push(bot.server(server_id.to_i).channels[i]) if bot.user(bot.profile.id).on(server_id.to_i).permission?(:send_messages,bot.server(server_id.to_i).channels[i]) && bot.server(server_id.to_i).channels[i].type.zero?
    end
    chn=chnn[0] if chnn.length>0
  end
  chn.send_message("My coder would rather that I not associate with you guys.  I'm sorry.  If you would like me back, please take it up with him.") rescue nil
  bot.server(server_id.to_i).leave
end

def bug_report(bot,event,args,shrd_num,shrd_names,shrd_type,pref,echo=nil)
  s5=event.message.text.downcase
  for i in 0...pref.length
    s5=s5[pref[i].length,s5.length-pref[i].length] if pref[i].downcase==s5.downcase[0,pref[i].length]
  end
  a=s5.split(' ')
  a[0]=a[0].split("\n")[0] if a[0].include?("\n")
  s3='Bug Report'
  s3='Suggestion' if a[0]=='suggestion'
  s3='Feedback' if a[0]=='feedback'
  if args.nil? || args.length.zero?
    event.respond "You did not include a description of your #{s3.downcase}.  Please retry the command like this:\n```#{event.message.text} here is where you type the description of your #{s3.downcase}```"
    if event.server.nil?
      s="**#{s3} sent by PM**"
    else
      s="**Server:** #{event.server.name} (#{event.server.id}) - #{shrd_names[(event.server.id >> 22) % shrd_num]} #{shrd_type}\n**Channel:** #{event.channel.name} (#{event.channel.id})"
    end
    bot.user(167657750971547648).pm("#{s}\n#{event.user.distinct} (#{event.user.id}) just tried to use the #{s3.downcase} command but gave no arguments.")
    bot.channel(echo).send_message("#{s}\n#{event.user.distinct} (#{event.user.id}) just tried to use the #{s3.downcase} command but gave no arguments.") unless echo.nil? || bot.channel(echo).nil?
    return nil
  elsif event.server.nil?
    s="**#{s3} sent by PM**"
  else
    s="**Server:** #{event.server.name} (#{event.server.id}) - #{shrd_names[(event.server.id >> 22) % shrd_num]} #{shrd_type}\n**Channel:** #{event.channel.name} (#{event.channel.id})"
  end
  f=event.message.text.split(' ')
  f="#{f[0]} "
  bot.user(167657750971547648).pm("#{s}\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{s3}:** #{first_sub(event.message.text,f,'',1)}")
  bot.channel(echo).send_message("#{s}\n**User:** #{event.user.distinct} (#{event.user.id})\n**#{s3}:** #{first_sub(event.message.text,f,'',1)}") unless echo.nil? || bot.channel(echo).nil?
  s3='Bug' if s3=='Bug Report'
  t=Time.now
  event << "Your #{s3.downcase} has been logged."
end

def week_from(d,dow)
  m=d*1
  m-=m%7
  m/=7
  return m+1 if d%7>=dow
  return m
end

def calc_easter()
  t = Time.now
  y = t.year
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
  if t.month>m || (t.month==m && t.day>d)
    y += 1
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
  end
  return [y,m,d]
end

def get_debug_leave_message()
  str="I am Mathoo's personal debug bot.  As such, I do not belong here.  You may be looking for one of my facets, so I'll drop all the invite links here."
  str="#{str}\n\n**EliseBot** allows you to look up stats and skill data for characters in *Fire Emblem: Heroes*"
  str="#{str}\nHere's her invite link: <https://goo.gl/Hf9RNj>"
  str="#{str}\n\n**RobinBot**, also known as **FEIndex**, is for *Fire Emblem: Awakening* and *Fire Emblem Fates*."
  str="#{str}\nHere's her invite link: <https://goo.gl/f1wSGd>"
  str="#{str}\n\n**LizBot** allows you to look up stats, mats, and skill data in *Fate/Grand Order*"
  str="#{str}\nHere's her invite link: <https://goo.gl/ox9CxB>"
  return str
end

def disp_date(t,mode=0)
  return "#{t.day}#{['','Jan','Feb','Mar','Apr','May','June','July','Aug','Sept','Oct','Nov','Dec'][t.month]}#{t.year}" if mode==2
  return "#{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year}" if mode==1
  return "#{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]})"
end
