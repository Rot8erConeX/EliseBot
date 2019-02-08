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

def get_donor_list()
  if File.exist?('C:/Users/Mini-Matt/Desktop/devkit/FEHDonorList.txt')
    b=[]
    File.open('C:/Users/Mini-Matt/Desktop/devkit/FEHDonorList.txt').each_line do |line|
      b.push(line.gsub("\n",'').split('\\'[0]))
    end
    for i in 0...b.length
      b[i][0]=b[i][0].to_i
      b[i][2]=b[i][2].to_i
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
  return true if user.permission?(:manage_messages,channel) # legitimate mod powers also confer EliseMod powers
  return false if mode>0
  return true if get_donor_list().reject{|q| q[2]<1}.map{|q| q[0]}.include?(user.id) # people who donate to the laptop fund will always be EliseMods
  return false
end

def normalize(str) # used by the majority of commands that accept input, to replace all non-ASCII characters with their ASCII counterparts
  str=str.gsub(/\s+/,' ').gsub(/[[:space:]]+/,' ').gsub(/[[:cntrl:]]/,' ').gsub("``",'')
  str=str.gsub("\u2019","'").gsub("`","'").gsub("\u2018","'")
  str=str.gsub("\u{1F1E6}","A").gsub("\u{1F1E7}","B").gsub("\u{1F1E8}","C").gsub("\u{1F1E9}","D").gsub("\u{1F1EA}","E").gsub("\u{1F1EB}","F").gsub("\u{1F1EC}","G").gsub("\u{1F1ED}","H").gsub("\u{1F1EE}","I").gsub("\u{1F1EF}","J").gsub("\u{1F1F0}","K").gsub("\u{1F1F1}","L").gsub("\u{1F1F2}","M").gsub("\u{1F1F3}","N").gsub("\u{1F1F4}","O").gsub("\u{1F1F5}","P").gsub("\u{1F1F6}","Q").gsub("\u{1F1F7}","R").gsub("\u{1F1F8}","S").gsub("\u{1F1F9}","T").gsub("\u{1F1FA}","U").gsub("\u{1F1FB}","V").gsub("\u{1F1FC}","W").gsub("\u{1F1FD}","X").gsub("\u{1F1FE}","Y").gsub("\u{1F1FF}","Z")
  str=str.gsub("\u{1F170}",'A').gsub("\u{1F171}",'B').gsub("\u{1F18E}",'AB').gsub("\u{1F191}",'CL').gsub("\u2B55",'O').gsub("\u{1F17E}",'O').gsub("\u{1F198}",'SOS')
  str=str.gsub("\u00E1",'a').gsub("\u00C1",'a').gsub("\u0103",'a').gsub("\u01CE",'a').gsub("\u00C2",'a').gsub("\u00E2",'a').gsub("\u00C4",'a').gsub("\u00E4",'a').gsub("\u0227",'a').gsub("\u1EA1",'a').gsub("\u0201",'a').gsub("\u00C0",'a').gsub("\u00E0",'a').gsub("\u1EA3",'a').gsub("\u0203",'a').gsub("\u0101",'a').gsub("\u0105",'a').gsub("\u1E9A",'a').gsub("\u00C5",'a').gsub("\u00E5",'a').gsub("\u1E01",'a').gsub("\u023A",'a').gsub("\u00C3",'a').gsub("\u00E3",'a').gsub("\u0363",'a').gsub("\u1D00",'a').gsub("\u0251",'a').gsub("\u0250",'a').gsub("\u0252",'a').gsub("\u22C0",'a')
  str=str.gsub("\u00C6",'ae').gsub("\u1D01",'ae').gsub("\u00E6",'ae').gsub("\u1D02",'ae')
  str=str.gsub("\u1E03",'b').gsub("\u1E05",'b').gsub("\u0181",'b').gsub("\u0253",'b').gsub("\u1E07",'b').gsub("\u0243",'b').gsub("\u0180",'b').gsub("\u0183",'b').gsub("\u0299",'b').gsub("\u1D03",'b').gsub("\u212C",'b').gsub("\u0185",'b')
  str=str.gsub("\u0107",'c').gsub("\u010D",'c').gsub("\u00C7",'c').gsub("\u00E7",'c').gsub("\u0109",'c').gsub("\u0255",'c').gsub("\u010B",'c').gsub("\u0189",'c').gsub("\u023B",'c').gsub("\u023C",'c').gsub("\u2183",'c').gsub("\u212D",'c').gsub("\u0368",'c').gsub("\u2102",'c').gsub("\u1D04",'c').gsub("\u0297",'c').gsub("\u2184",'c')
  str=str.gsub("\u212D",'d').gsub("\u0256",'d').gsub("\u010F",'d').gsub("\u1E11",'d').gsub("\u1E13",'d').gsub("\u0221",'d').gsub("\u1E0B",'d').gsub("\u1E0D",'d').gsub("\u018A",'d').gsub("\u0257",'d').gsub("\u1E0F",'d').gsub("\u0111",'d').gsub("\u0256",'d').gsub("\u018C",'d').gsub("\u0369",'d').gsub("\u2145",'d').gsub("\u2146",'d').gsub("\u0189",'d').gsub("\u1D05",'d')
  str=str.gsub("\u00C9",'e').gsub("\u00E9",'e').gsub("\u0115",'e').gsub("\u011B",'e').gsub("\u0229",'e').gsub("\u1E19",'e').gsub("\u00CA",'e').gsub("\u00EA",'e').gsub("\u00CB",'e').gsub("\u00EB",'e').gsub("\u0117",'e').gsub("\u1EB9",'e').gsub("\u0205",'e').gsub("\u00C8",'e').gsub("\u00E8",'e').gsub("\u1EBB",'e').gsub("\u025D",'e').gsub("\u0207",'e').gsub("\u0113",'e').gsub("\u0119",'e').gsub("\u0246",'e').gsub("\u0247",'e').gsub("\u1E1B",'e').gsub("\u1EBD",'e').gsub("\u0364",'e').gsub("\u2147",'e').gsub("\u0190",'e').gsub("\u018E",'e').gsub("\u1D07",'e').gsub("\u029A",'e').gsub("\u025E",'e').gsub("\u0153",'e').gsub("\u025B",'e').gsub("\u0258",'e').gsub("\u025C",'e').gsub("\u01DD",'e').gsub("\u1D08",'e').gsub("\u2130",'e').gsub("\u212F",'e').gsub("\u0259",'e').gsub("\u018F",'e').gsub("\u22FF",'e')
  str=str.gsub("\u1E1F",'f').gsub("\u0192",'f').gsub("\u2131",'f').gsub("\u2132",'f').gsub("\u214E",'f')
  str=str.gsub("\u2640",'(f)')
  str=str.gsub("\u01F5",'g').gsub("\u011F",'g').gsub("\u01E7",'g').gsub("\u0123",'g').gsub("\u011D",'g').gsub("\u0121",'g').gsub("\u0193",'g').gsub("\u029B",'g').gsub("\u0260",'g').gsub("\u1E21",'g').gsub("\u01E5",'g').gsub("\u0262",'g').gsub("\u0261",'g').gsub("\u210A",'g').gsub("\u2141",'g')
  str=str.gsub("\u210C",'h').gsub("\u1E2B",'h').gsub("\u021F",'h').gsub("\u1E29",'h').gsub("\u0125",'h').gsub("\u1E27",'h').gsub("\u1E23",'h').gsub("\u1E25",'h').gsub("\u02AE",'h').gsub("\u0266",'h').gsub("\u1E96",'h').gsub("\u0127",'h').gsub("\u210C",'h').gsub("\u036A",'h').gsub("\u210D",'h').gsub("\u029C",'h').gsub("\u0265",'h').gsub("\u2095",'h').gsub("\u02B0",'h').gsub("\u210B",'h')
  str=str.gsub("\u2111",'i').gsub("\u0197",'i').gsub("\u0130",'i').gsub("\u00CD",'i').gsub("\u00ED",'i').gsub("\u012D",'i').gsub("\u01D0",'i').gsub("\u00CE",'i').gsub("\u00EE",'i').gsub("\u00CF",'i').gsub("\u00EF",'i').gsub("\u0130",'i').gsub("\u1CEB",'i').gsub("\u0209",'i').gsub("\u00CC",'i').gsub("\u00EC",'i').gsub("\u1EC9",'i').gsub("\u020B",'i').gsub("\u012B",'i').gsub("\u012F",'i').gsub("\u0197",'i').gsub("\u0268",'i').gsub("\u1E2D",'i').gsub("\u0129",'i').gsub("\u2111",'i').gsub("\u0365",'i').gsub("\u2148",'i').gsub("\u026A",'i').gsub("\u0131",'i').gsub("\u1D09",'i').gsub("\u1D62",'i').gsub("\u2110",'i').gsub("\u2071",'i').gsub("\u2139",'i').gsub("\uFE0F",'i').gsub("\u1FBE",'i').gsub("\u03B9",'i').gsub("\u0399",'i')
  str=str.gsub("\u0133",'ij')
  str=str.gsub("\u01F0",'j').gsub("\u0135",'j').gsub("\u029D",'j').gsub("\u0248",'j').gsub("\u0249",'j').gsub("\u025F",'j').gsub("\u2149",'j').gsub("\u1D0A",'j').gsub("\u0237",'j').gsub("\u02B2",'j')
  str=str.gsub("\u1E31",'k').gsub("\u01E9",'k').gsub("\u0137",'k').gsub("\u1E33",'k').gsub("\u0199",'k').gsub("\u1E35",'k').gsub("\u1D0B",'k').gsub("\u029E",'k').gsub("\u2096",'k').gsub("\u212A",'k').gsub("\u0138",'k')
  str=str.gsub("\u013A",'l').gsub("\u023D",'l').gsub("\u019A",'l').gsub("\u026C",'l').gsub("\u013E",'l').gsub("\u013C",'l').gsub("\u1E3D",'l').gsub("\u0234",'l').gsub("\u1E37",'l').gsub("\u1E3B",'l').gsub("\u0140",'l').gsub("\u026B",'l').gsub("\u026D",'l').gsub("\u1D0C",'l').gsub("\u0142",'l').gsub("\u029F",'l').gsub("\u2097",'l').gsub("\u02E1",'l').gsub("\u2143",'l').gsub("\u2112",'l').gsub("\u2113",'l').gsub("\u2142",'l')
  str=str.gsub("\u2114",'lb')
  str=str.gsub("\u264C",'leo')
  str=str.gsub("\u1E3F",'m').gsub("\u1E41",'m').gsub("\u1E43",'m').gsub("\u0271",'m').gsub("\u0270",'m').gsub("\u036B",'m').gsub("\u019C",'m').gsub("\u1D0D",'m').gsub("\u1D1F",'m').gsub("\u026F",'m').gsub("\u2098",'m').gsub("\u2133",'m')
  str=str.gsub("\u2642",'(m)')
  str=str.gsub("\u0144",'n').gsub("\u0148",'n').gsub("\u0146",'n').gsub("\u1E4B",'n').gsub("\u0235",'n').gsub("\u1E45",'n').gsub("\u1E47",'n').gsub("\u01F9",'n').gsub("\u019D",'n').gsub("\u0272",'n').gsub("\u1E49",'n').gsub("\u0220",'n').gsub("\u019E",'n').gsub("\u0273",'n').gsub("\u00D1",'n').gsub("\u00F1",'n').gsub("\u2115",'n').gsub("\u0274",'n').gsub("\u1D0E",'n').gsub("\u2099",'n').gsub("\u22C2",'n').gsub("\u220F",'n')
  str=str.gsub("\u00F3",'o').gsub("\u00F0",'o').gsub("\u00D3",'o').gsub("\u014F",'o').gsub("\u01D2",'o').gsub("\u00D4",'o').gsub("\u00F4",'o').gsub("\u00D6",'o').gsub("\u00F6",'o').gsub("\u022F",'o').gsub("\u1ECD",'o').gsub("\u0151",'o').gsub("\u020D",'o').gsub("\u00D2",'o').gsub("\u00F2",'o').gsub("\u1ECF",'o').gsub("\u01A1",'o').gsub("\u020F",'o').gsub("\u014D",'o').gsub("\u019F",'o').gsub("\u01EB",'o').gsub("\u00D8",'o').gsub("\u00F8",'o').gsub("\u1D13",'o').gsub("\u00D5",'o').gsub("\u00F5",'o').gsub("\u0366",'o').gsub("\u019F",'o').gsub("\u0186",'o').gsub("\u1D0F",'o').gsub("\u1D10",'o').gsub("\u0275",'o').gsub("\u1D11",'o').gsub("\u2134",'o').gsub("\u25CB",'o').gsub("\u00A4",'o')
  str=str.gsub("\u1D14",'oe').gsub("\u0153",'oe').gsub("\u0276",'oe')
  str=str.gsub("\u01A3",'oi')
  str=str.gsub("\u0223",'ou').gsub("\u1D15",'ou')
  str=str.gsub("\u1E55",'p').gsub("\u1E57",'p').gsub("\u01A5",'p').gsub("\u2119",'p').gsub("\u1D18",'p').gsub("\u209A",'p').gsub("\u2118",'p').gsub("\u214C",'p')
  str=str.gsub("\u024A",'q').gsub("\u024B",'q').gsub("\u02A0",'q').gsub("\u211A",'q').gsub("\u213A",'q')
  str=str.gsub("\u0239",'qp')
  str=str.gsub("\u211C",'r').gsub("\u0155",'r').gsub("\u0159",'r').gsub("\u0157",'r').gsub("\u1E59",'r').gsub("\u1E5B",'r').gsub("\u0211",'r').gsub("\u027E",'r').gsub("\u027F",'r').gsub("\u027B",'r').gsub("\u0213",'r').gsub("\u1E5F",'r').gsub("\u027C",'r').gsub("\u027A",'r').gsub("\u024C",'r').gsub("\u024D",'r').gsub("\u027D",'r').gsub("\u036C",'r').gsub("\u211D",'r').gsub("\u0280",'r').gsub("\u0281",'r').gsub("\u1D19",'r').gsub("\u1D1A",'r').gsub("\u0279",'r').gsub("\u1D63",'r').gsub("\u02B3",'r').gsub("\u02B6",'r').gsub("\u02B4",'r').gsub("\u211B",'r').gsub("\u01A6",'r')
  str=str.gsub("\u301C",'roy')
  str=str.gsub("\u015B",'s').gsub("\u0161",'s').gsub("\u015F",'s').gsub("\u015D",'s').gsub("\u0219",'s').gsub("\u1E61",'s').gsub("\u1E63",'s').gsub("\u0282",'s').gsub("\u023F",'s').gsub("\u209B",'s').gsub("\u02E2",'s').gsub("\u1E9B",'s').gsub("\u223E",'s').gsub("\u017F",'s').gsub("\u00DF",'s')
  str=str.gsub("\u0165",'t').gsub("\u0163",'t').gsub("\u1E71",'t').gsub("\u021B",'t').gsub("\u0236",'t').gsub("\u1E97",'t').gsub("\u023E",'t').gsub("\u1E6B",'t').gsub("\u1E6D",'t').gsub("\u01AD",'t').gsub("\u1E6F",'t').gsub("\u01AB",'t').gsub("\u01AE",'t').gsub("\u0288",'t').gsub("\u0167",'t').gsub("\u036D",'t').gsub("\u1D1B",'t').gsub("\u0287",'t').gsub("\u209C",'t')
  str=str.gsub("\u00FE",'th')
  str=str.gsub("\u00FA",'u').gsub("\u028A",'u').gsub("\u22C3",'u').gsub("\u0244",'u').gsub("\u0289",'u').gsub("\u00DA",'u').gsub("\u1E77",'u').gsub("\u016D",'u').gsub("\u01D4",'u').gsub("\u00DB",'u').gsub("\u00FB",'u').gsub("\u1E73",'u').gsub("\u00DC",'u').gsub("\u00FC",'u').gsub("\u1EE5",'u').gsub("\u0171",'u').gsub("\u0215",'u').gsub("\u00D9",'u').gsub("\u00F9",'u').gsub("\u1EE7",'u').gsub("\u01B0",'u').gsub("\u0217",'u').gsub("\u016B",'u').gsub("\u0173",'u').gsub("\u016F",'u').gsub("\u1E75",'u').gsub("\u0169",'u').gsub("\u0367",'u').gsub("\u1D1C",'u').gsub("\u1D1D",'u').gsub("\u1D1E",'u').gsub("\u1D64",'u')
  str=str.gsub("\u22C1",'v').gsub("\u030C",'v').gsub("\u1E7F",'v').gsub("\u01B2",'v').gsub("\u028B",'v').gsub("\u1E7D",'v').gsub("\u036E",'v').gsub("\u01B2",'v').gsub("\u0245",'v').gsub("\u1D20",'v').gsub("\u028C",'v').gsub("\u1D65",'v')
  str=str.gsub("\u1E83",'w').gsub("\u0175",'w').gsub("\u1E85",'w').gsub("\u1E87",'w').gsub("\u1E89",'w').gsub("\u1E81",'w').gsub("\u1E98",'w').gsub("\u1D21",'w').gsub("\u028D",'w').gsub("\u02B7",'w')
  str=str.gsub("\u2715",'x').gsub("\u2716",'x').gsub("\u2A09",'x').gsub("\u033D",'x').gsub("\u0353",'x').gsub("\u1E8D",'x').gsub("\u1E8B",'x').gsub("\u2717",'x').gsub("\u036F",'x').gsub("\u2718",'x').gsub("\u2A09",'x').gsub("\u02E3",'x').gsub("\u2A09",'x')
  str=str.gsub("\u00DD",'y').gsub("\u00FD",'y').gsub("\u0177",'y').gsub("\u0178",'y').gsub("\u00FF",'y').gsub("\u1E8F",'y').gsub("\u1EF5",'y').gsub("\u1EF3",'y').gsub("\u1EF7",'y').gsub("\u01B4",'y').gsub("\u0233",'y').gsub("\u1E99",'y').gsub("\u024E",'y').gsub("\u024F",'y').gsub("\u1EF9",'y').gsub("\u028F",'y').gsub("\u028E",'y').gsub("\u02B8",'y').gsub("\u2144",'y').gsub("\u00A5",'y')
  str=str.gsub("\u01B6",'z').gsub("\u017A",'z').gsub("\u017E",'z').gsub("\u1E91",'z').gsub("\u0291",'z').gsub("\u017C",'z').gsub("\u1E93",'z').gsub("\u0225",'z').gsub("\u1E95",'z').gsub("\u0290",'z').gsub("\u01B6",'z').gsub("\u0240",'z').gsub("\u2128",'z').gsub("\u2124",'z').gsub("\u1D22",'z')
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

def supersort(a,b,m,n=nil)
  unless n.nil?
    return supersort(a,b,0) if n<0
    if a[m][n].is_a?(String) && b[m][n].is_a?(String)
      return b[m][n].downcase <=> a[m][n].downcase
    elsif a[m][n].is_a?(String)
      return -1
    elsif b[m][n].is_a?(String)
      return 1
    else
      return a[m][n] <=> b[m][n]
    end
  end
  if a[m].is_a?(String) && b[m].is_a?(String)
    return b[m].downcase <=> a[m].downcase
  elsif a[m].is_a?(String)
    return -1
  elsif b[m].is_a?(String)
    return 1
  else
    return a[m] <=> b[m]
  end
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
  return "1,000" if number==1000
  return "#{number}" if number<1000
  if number<1000
    bob="#{number%1000}"
  elsif number%1000<10
    bob="00#{number%1000}"
  elsif number%1000<100
    bob="0#{number%1000}"
  elsif number%1000<1000
    bob="#{number%1000}"
  end
  while number>1000
    number=number/1000
    if number<1000
      bob="#{number%1000},#{bob}"
    elsif number%1000<10
      bob="00#{number%1000},#{bob}"
    elsif number%1000<100
      bob="0#{number%1000},#{bob}"
    elsif number%1000<1000
      bob="#{number%1000},#{bob}"
    end
  end
  return bob
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
  if @embedless.include?(event.user.id) || (was_embedless_mentioned?(event) && ch_id==0)
    str=''
    if header.length>0
      if header.include?('*') || header.include?('_')
        str=header
      else
        str="__**#{header.gsub('!','')}**__"
      end
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

def dev_pm(bot,event,user_id)
  return nil unless event.server.nil?
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  f=event.message.text.split(' ')
  f="#{f[0]} #{f[1]} "
  bot.user(user_id.to_i).pm(first_sub(event.message.text,f,'',1))
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

def dev_message(bot,event,channel_id)
  return nil unless event.server.nil? || [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,508792801455243266,508793141202255874,508793425664016395].include?(event.server.id)
  if event.user.id==167657750971547648
  else
    event.respond 'Are you trying to use the `bugreport`, `suggestion`, or `feedback` command?'
    bot.user(167657750971547648).pm("#{event.user.distinct} (#{event.user.id}) tried to use the `sendmessage` command.")
    return nil
  end
  f=event.message.text.split(' ')
  f="#{f[0]} #{f[1]} "
  bot.channel(channel_id).send_message(first_sub(event.message.text,f,'',1))
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
    event << "Donor List and perks: <https://goo.gl/ds1LHA>"
    event << ''
    event << str
  else
    create_embed(event,"__**If you wish to donate to me:** A word from my developer__","Due to income regulations within the building where I live, I cannot accept donations in the form of PayPal, Patreon, or other forms of direct payment.  Only a small percentage of any such donations would actually reach me and the rest would end up in the hands of the owners of my building.\n\nHowever, there are other options:\n- You can purchase items from [this list](http://a.co/0p3sBec) and they will be delivered to me.\n- You can also [purchase an Amazon gift card](https://goo.gl/femEcw) and have it delivered via email to **rot8er.conex@gmail.com**.\n\n[Donor List and perks](https://goo.gl/ds1LHA)\n\n#{str}",0x008b8b,"Please note that supporting me means indirectly enabling my addiction to pretzels and pizza rolls.")
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
