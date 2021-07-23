Shardizard = ARGV.first.to_i # taking a single variable from the command prompt to get the shard value
system('color 0F')
Shards = 4                   # total number of shards
$spanishShard=nil

require 'discordrb'                    # Download link: https://github.com/meew0/discordrb
require 'open-uri'                     # pre-installed with Ruby in Windows
require 'net/http'                     # pre-installed with Ruby in Windows
require 'certified'
require 'tzinfo/data'                  # Downloaded with active_support below, but the require must be above active_support's require
require 'rufus-scheduler'              # Download link: https://github.com/jmettraux/rufus-scheduler
require 'active_support/core_ext/time' # Download link: https://rubygems.org/gems/activesupport/versions/5.0.0
require_relative 'rot8er_functs'       # functions I use commonly in bots
$location="C:/Users/#{@mash}/Desktop/"

# this is required to get her to change her avatar on certain holidays
ENV['TZ'] = 'America/Chicago'
@scheduler = Rufus::Scheduler.new

# All the possible command prefixes
@prefixes={}
load "#{$location}devkit/FEHPrefix.rb"

prefix_proc = proc do |message|
  next pseudocase(message.text[4..-1]) if message.text.downcase.start_with?('feh!') && pseudocase(message.text[4..-1]).split(' ')[0]!='reboot'
  next pseudocase(message.text[4..-1]) if message.text.downcase.start_with?('feh?') && pseudocase(message.text[4..-1]).split(' ')[0]!='reboot'
  next pseudocase(message.text[2..-1]) if message.text.downcase.start_with?('f?')
  next pseudocase(message.text[2..-1]) if message.text.downcase.start_with?('e?')
  next pseudocase(message.text[2..-1]) if message.text.downcase.start_with?('h?')
  load "#{$location}devkit/FEHPrefix.rb"
  next if message.channel.server.nil? || @prefixes[message.channel.server.id].nil? || @prefixes[message.channel.server.id].length<=0
  prefix = @prefixes[message.channel.server.id]
  # We use [prefix.size..-1] so we can handle prefixes of any length
  next pseudocase(message.text[prefix.size..-1]) if message.text.downcase.start_with?(prefix.downcase)
end

# The bot's token is basically their password, so is censored for obvious reasons
if Shardizard==4
  bot = Discordrb::Commands::CommandBot.new token: '>Debug Token<', client_id: 431895561193390090, prefix: prefix_proc
elsif Shardizard==-2
elsif Shardizard<0
  bot = Discordrb::Commands::CommandBot.new token: '>Smol Token<', client_id: 627511537237491715, prefix: prefix_proc
elsif Shardizard<4
  bot = Discordrb::Commands::CommandBot.new token: '>Main Token<', shard_id: Shardizard, num_shards: Shards, client_id: 312451658908958721, prefix: prefix_proc
else
  bot = Discordrb::Commands::CommandBot.new token: '>Main Token<', shard_id: (Shardizard-1), num_shards: Shards, client_id: 312451658908958721, prefix: prefix_proc
end
bot.gateway.check_heartbeat_acks = false

def shard_data(mode=0,ignoredebug=false,s=nil)
  s=Shards*1 if s.nil?
  if mode==0 # shard icons + names
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant','<:Shard_Gold:443733396913520640> Golden'] if s<=4
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant','<:Shard_Gold:443733396913520640> Golden','<:Shard_Cyan:552681863995588628> Sky'] if s==5
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant','<:Shard_Gold:443733396913520640> Golden','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Cyan:552681863995588628> Sky'] if s==6
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Blue:443733396741554181> Azure','<:Shard_Green:443733397190344714> Verdant','<:Shard_Gold:443733396913520640> Golden','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Purple:443733396401946625> Violet'] if s==7
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet'] if s==8
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s==9
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Pink:694402484365688874> Bubblegum','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s==10
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Black:694402483606257694> Onyx','<:Shard_Pink:694402484365688874> Bubblegum','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s==11
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Black:694402483606257694> Onyx','<:Shard_Grey:554090554963525639> Steel','<:Shard_Pink:694402484365688874> Bubblegum','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s==12
    k=['<:Shard_Colorless:443733396921909248> Transparent','<:Shard_Black:694402483606257694> Onyx','<:Shard_Grey:554090554963525639> Steel','<:Shard_Platinum:694402484470284370> Platinum','<:Shard_Rot8er:443733397223768084> Hybrid','<:Shard_Pink:694402484365688874> Bubblegum','<:Shard_Red:443733396842348545> Scarlet','<:Shard_Orange:552681863962165258> Citrus','<:Shard_Gold:443733396913520640> Golden','<:Shard_Green:443733397190344714> Verdant','<:Shard_Cyan:552681863995588628> Sky','<:Shard_Blue:443733396741554181> Azure','<:Shard_Purple:443733396401946625> Violet','<:Shard_Magenta:554090555533950986> Magenta'] if s>=13
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
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Pink:694402484365688874>','<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Rot8er:443733397223768084>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s==10
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Black:694402483606257694>','<:Shard_Pink:694402484365688874>','<:Shard_Red:443733396842348545>','<:Shard_Rot8er:443733397223768084>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s==11
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Black:694402483606257694>','<:Shard_Grey:554090554963525639>','<:Shard_Pink:694402484365688874>','<:Shard_Rot8er:443733397223768084>','<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s==12
    k=['<:Shard_Colorless:443733396921909248>','<:Shard_Black:694402483606257694>','<:Shard_Grey:554090554963525639>','<:Shard_Platinum:694402484470284370>','<:Shard_Rot8er:443733397223768084>','<:Shard_Pink:694402484365688874>','<:Shard_Red:443733396842348545>','<:Shard_Orange:552681863962165258>','<:Shard_Gold:443733396913520640>','<:Shard_Green:443733397190344714>','<:Shard_Cyan:552681863995588628>','<:Shard_Blue:443733396741554181>','<:Shard_Purple:443733396401946625>','<:Shard_Magenta:554090555533950986>'] if s>=13
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

if Shardizard==-1
  system("color 09")
  system("title loading EliseBot(Smol)")
elsif Shardizard==-2
  system("color 09")
  system("title loading Elispanol")
else
  system("color 0#{shard_data(4)[Shardizard,1]}") # command prompt color and title determined by the shard
  system("title loading #{shard_data(2)[Shardizard]} EliseBot")
end

$units=[]
$dev_units=[]
$donor_units=[]
$skills=[]
$structures=[]
$itemus=[]
$accessories=[]

$banners=[]
$skilltags=[]
$origames=[]
$statskills=[]
$bonus_units=[]
$events=[]
$paths=[]

$aliases=[]
$groups=[]

$fgo_servants=[]
$fgo_crafts=[]
$dl_adventurers=[]
$dl_dragons=[]
$dl_wyrmprints=[]
$dl_npcs=[]

$dev_waifus=[]
$dev_somebodies=[]
$dev_nobodies=[]
$donor_triggers=[]

Mods=[[ 0, 0, 0, 0, 0, 0, 0],
      [ 1, 1, 1, 1, 1, 1, 2],
      [ 2, 3, 3, 3, 3, 4, 4],
      [ 4, 4, 5, 5, 6, 6, 7],
      [ 5, 6, 7, 7, 8, 8, 9], # this is a translation of the graphic displayed in the "growths" command.
      [ 7, 8, 8, 9,10,10,11],
      [ 8, 9,10,11,12,13,14],
      [10,11,12,13,14,15,16],
      [12,13,14,15,16,17,18],
      [13,14,15,17,18,19,21],
      [15,16,17,19,20,22,23],
      [16,18,19,21,22,24,25],
      [18,19,21,23,24,26,28],
      [19,21,23,25,26,28,30],
      [21,23,25,27,28,30,32],
      [23,24,26,29,31,33,35],
      [24,26,28,31,33,35,37],
      [26,28,30,33,35,37,39],
      [27,30,32,35,37,39,42],
      [29,31,34,37,39,42,44],
      [30,33,36,39,41,44,47]]
Natures=[['Gentle','Resistance','Defense'], # this is a list of all the nature names that can be displayed, with the affected stats
         ['Bold','Defense','Attack'],
         ['Timid','Speed','Attack'],
         ['Lonely','Attack','Defense'],
         ['Mild','Attack','Defense'],
         ['Hasty','Speed','Defense'],
         ['Impish','Defense','Attack'],       # entries with "true" at the end cannot be typed in by end users but can be displayed, other entries can do both
         ['Calm','Resistance','Attack',true], # "Calm" cannot be typed in due to it meaning something different between FE and Pokemon
         ['Careful','Resistance','Attack'],
         ['Jolly','Speed','Attack'],
         ['Naive','Speed','Resistance'],
         ['Naughty','Attack','Resistance'],
         ['Lax','Defense','Resistance'],
         ['Rash','Attack','Resistance'],
         ['Relaxed','Defense','Speed'],
         ['Brave','Attack','Speed',true], # "Brave" cannot be typed due to it being both a unit classification and a weapon classification
         ['Quiet','Attack','Speed'],
         ['Sassy','Resistance','Speed'],
         ["`\u22C0`Strong",'Attack','HP',true],
         ["`\u22C0`Clever",'Attack','HP',true],
         ["`\u22C0`Quick",'Speed','HP',true],
         ["`\u22C0`Sturdy",'Defense','HP',true],
         ["`\u22C0`Calm",'Resistance','HP',true],
         ["`\u22C1`Weak",'HP','Attack',true],
         ["`\u22C1`Dull",'HP','Attack',true],
         ["`\u22C1`Sluggish",'HP','Speed',true],
         ["`\u22C1`Fragile",'HP','Defense',true],
         ["`\u22C1`Excitable",'HP','Resistance',true]]
Max_rarity_merge=[5,10,15]
Stat_Names=['HP','Attack','Speed','Defense','Resistance']
Skill_Slots=[['<:Skill_Weapon:444078171114045450>','<:Skill_Assist:444078171025965066>','<:Skill_Special:444078170665254929>','<:Passive_A:443677024192823327>',
              '<:Passive_B:443677023257493506>','<:Passive_C:443677023555026954>','<:Passive_S:443677023626330122>','<:Hero_Duo:631431055420948480><:Hero_Harmonic:722436762248413234>'],
             ['Weapon','Assist','Special','A Passive','B Passive','C Passive','Passive Seal','Duo/Harmonic'],
             ['Arma','Asistencia','Especial','Pasiva A','Pasiva B','Pasiva C','Insignia passiva','Dúo/al Son']]
Rarity_stars=[['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>',
               '<:Icon_Rarity_4:448266418459377684>','<:Icon_Rarity_5:448266417553539104>','<:Icon_Rarity_6:491487784650145812>'],
              ['<:Icon_Rarity_1:448266417481973781>','<:Icon_Rarity_2:448266417872044032>','<:Icon_Rarity_3:448266417934958592>',
               '<:Icon_Rarity_4p10:448272714210476033>','<:Icon_Rarity_5p10:448272715099406336>','<:Icon_Rarity_6p10:491487784822112256>']]
$embedless=[]
@ignored=[]
$server_markers=[]
$x_markers=[]
$spam_channels=[]
$summon_rate=[0,0,0]; $banner=[]
@server_data=[]
@headpats=[0,0,0]
$last_multi_reload=[0,0,0]
@zero_by_four=[0,0,0]
@avvie_info=['Elise','*Fire Emblem Heroes*','N/A']
Summon_servers=[330850148261298176,389099550155079680,256291408598663168,271642342153388034,285663217261477889,280125970252431360,356146569239855104,393775173095915521,
                 341729526767681549,380013135576432651,383563205894733824,374991726139670528,338856743553597440,297459718249512961,283833293894582272,305889949574496257,
                 214552543835979778,332249772180111360,334554496434700289,306213252625465354,197504651472535552,347491426852143109,392557615177007104,295686580528742420,
                 412303462764773376,442465051371372544,353997181193289728,462100851864109056,337397338823852034,446111983155150875,295001062790660097,328109510449430529,
                 483437489021911051,513061112896290816,327599133210705923]

# primary entities

class FEHUnit
  attr_accessor :name
  attr_accessor :weapon,:movement
  attr_accessor :legendary,:duo,:awonk
  attr_accessor :growths,:stats40,:stats1
  attr_accessor :artist,:voice_na,:voice_jp
  attr_accessor :id
  attr_accessor :availability
  attr_accessor :gender,:games
  attr_accessor :alts
  attr_accessor :fake
  attr_accessor :owner,:forma
  attr_accessor :sort_data
  attr_accessor :dancer_flag,:clazz_flag,:color_flag
  
  def initialize(val)
    @name=val
    @forma=false
    @id=-1
    @weapon=['Gold', 'Unknown']
    @movement='Unknown'
    @growths=[0,0,0,0,0]
    @stats1=[0,0,0,0,0]
    @stats40=[0,0,0,0,0]
    @availability=['-']
    @games=[]
  end
  
  def name=(val); @name=val; end
  def weapon=(val); @weapon=val; end
  def movement=(val); @movement=val; end
  def growths=(val); @growths=val; end
  def artist=(val); @artist=val; end
  def id=(val); @id=val; end
  def availability=(val); @availability=val; end
  def gender=(val); @gender=val; end
  def games=(val); @games=val; end
  def alts=(val); @alts=val; end
  def sort_data=(val); @sort_data=val; end
  def fake=(val); @fake=val unless val.nil? || val.length<=0; end
  def dancer_flag=(val); @dancer_flag=val; end
  def clazz_flag=(val); @clazz_flag=val; end
  def color_flag=(val); @color_flag=val; end
  def objt; return 'Unit'; end
  
  def base; return self; end
  
  def voice=(val)
    @voice_na=val[0].split(' & ') unless val[0].nil? || val[0].length<=0
    @voice_jp=val[1].split(' & ') unless val[1].nil? || val[1].length<=0
  end
  
  def legendary=(val)
    d=[]
    for i in 0...[val.length/3,1].max
      if ['Duo','Harmonic'].include?(val[3*i])
        d.push(val[3*i,3])
      elsif ['Fire','Water','Earth','Wind','Light','Dark','Astra','Anima'].include?(val[3*i]) && @legendary.nil?
        @legendary=val[3*i,3]
        @legendary[3]='Legendary'
        @legendary[3]='Mythic' if ['Light','Dark','Astra','Anima'].include?(val[3*i])
      elsif ['Fire','Water','Earth','Wind','Light','Dark','Astra','Anima'].include?(val[3*i])
      elsif !val[3*i].nil?
        @awonk=val[3*i,3]
      end
    end
    @duo=d.map{|q| q} if d.length>0
  end
  
  def weapon_color; return 'Cyan' if ['Robin (shared stats)','Robin'].include?(@name); return 'Purple' if ['Kris (shared stats)','Kris'].include?(@name); return @weapon[0]; end
  def weapon_type; return @weapon[1].gsub('Healer','Staff'); end
  def tome_tree; return nil if @weapon[1]!='Tome' || @name=='Robin (shared stats)'; return @weapon[2]; end
  def beast_species; return nil if @weapon[1]!='Beast'; return @weapon[2]; end
  
  def weapon_string
    return '*Mage* (Cyan Tome)' if @name=='Robin (shared stats)'
    return '*Melee* (Purple Blade)' if @name=='Kris (shared stats)'
    return '*Sword* (Red Blade)' if @weapon==['Red', 'Blade']
    return '*Lance* (Blue Blade)' if @weapon==['Blue', 'Blade']
    return '*Axe* (Green Blade)' if @weapon==['Green', 'Blade']
    return '*Rod* (Colorless Blade)' if @weapon==['Colorless', 'Blade']
    if @weapon[1]=='Tome'
      m=@weapon[2]
      m=@weapon[0] if m.nil?
      return "*#{m} Mage*" if @name=='Kiran'
      return "*#{m} Mage* (#{@weapon[0]} Tome)"
    end
    return "*Healer* (Colorless)" if @weapon[1]=='Healer' && $units.reject{|q| q.weapon_type != 'Healer' || q.weapon_color != 'Colorless'}.length<=0
    return "*#{@weapon[1]}*" if @weapon[0]=='Gold'
    return "*#{@weapon[0]} #{@weapon[1]}*"
  end
  
  def unit_group(inheritance=false,secondary=nil)
    return 'Blade Users' if ['Kris (shared stats)','Kris'].include?(@name)
    return 'Sword Users' if @weapon==['Red', 'Blade']
    return 'Lance Users' if @weapon==['Blue', 'Blade']
    return 'Axe Users' if @weapon==['Green', 'Blade']
    return 'Rod Users' if @weapon==['Colorless', 'Blade']
    if @weapon[1]=='Tome'
      m=@weapon[2]
      m=self.weapon_color if m.nil? || inheritance || ['Robin (shared stats)','Robin'].include?(@name)
      return "#{m} Tome Users"
    end
    return @weapon[1] if ['Dragon','Beast'].include?(@weapon[1]) && secondary==false
    return @weapon[0,2].join(' ') if ['Dragon','Beast'].include?(@weapon[1]) && secondary==true
    return "#{@weapon[1]}s" if ['Dragon','Beast'].include?(@weapon[1])
    return "#{@weapon[1].gsub('Healer','Staff')} Users"
  end
  
  def norsetome
    return 'Raudr' if self.weapon_color=='Red'
    return 'Blar' if self.weapon_color=='Blue'
    return 'Gronn' if self.weapon_color=='Green'
    return 'Hoss' if self.weapon_color=='Colorless'
    return 'Gullen'
  end
  
  def isRefresher?(type='')
    return true unless @dancer_flag.nil?
    return true if !$skills.find_index{|q| q.name=='Dance'}.nil? && $skills[$skills.find_index{|q| q.name=='Dance'}].learn.join(', ').split(', ').include?(@name) && ['','Dancer'].include?(type)
    return true if !$skills.find_index{|q| q.name=='Sing'}.nil? && $skills[$skills.find_index{|q| q.name=='Sing'}].learn.join(', ').split(', ').include?(@name) && ['','Singer'].include?(type)
    return true if !$skills.find_index{|q| q.name=='Play'}.nil? && $skills[$skills.find_index{|q| q.name=='Play'}].learn.join(', ').split(', ').include?(@name) && ['','Bard'].include?(type)
    return false
  end
  
  def hasResplendent?
    return true if @availability[0].include?('RA')
    return false
  end
  
  def hasEnemyForm?
    return true if @stats40.length>5
    return true if @stats1.length>5 && @growths.length>5
    return false
  end
  
  def hasForma?
    for i in 0...Max_rarity_merge[0]
      return true if @availability[0].include?("#{i+1}o")
    end
    return false
  end
  
  def fullName(format=nil)
    return @name if format.nil?
    return "#{format}#{@name}#{format.reverse}"
  end
  
  def class_header(bot,emotesonly=false,includebonus=true)
    wemote=''
    moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{self.weapon_color}_#{self.weapon_type}"}
    moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_#{self.weapon_color}_#{self.weapon_type}"} if @games[0]=='DL'
    wemote=moji[0].mention unless moji.length<=0
    unless self.weapon_type != 'Tome' || @weapon[2].nil? || ['Robin (shared stats)','Kris (shared stats)','Robin','Kris'].include?(name)
      moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{@weapon[2]}_#{self.weapon_type}"}
      wemote=moji[0].mention unless moji.length<=0
    end
    moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{@movement}"}
    moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_Mov_#{@movement}"} if @games[0]=='DL'
    memote=''
    memote=moji[0].mention unless moji.length<=0
    refresher=''
    refresher=@dancer_flag unless @dancer_flag.nil?
    refresher='Dancer' if !$skills.find_index{|q| q.name=='Dance'}.nil? && $skills[$skills.find_index{|q| q.name=='Dance'}].learn.join(', ').split(', ').include?(@name)
    refresher='Singer' if !$skills.find_index{|q| q.name=='Sing'}.nil? && $skills[$skills.find_index{|q| q.name=='Sing'}].learn.join(', ').split(', ').include?(@name)
    refresher='Bard' if !$skills.find_index{|q| q.name=='Play'}.nil? && $skills[$skills.find_index{|q| q.name=='Play'}].learn.join(', ').split(', ').include?(@name)
    if Shardizard==$spanishShard
      refresher="Bailarín#{'a' if @gender=='F'}" if refresher=='Dancer'
      refresher='Cantante' if refresher=='Singer'
      refresher="Bard#{self.spanish_gender.downcase}" if refresher=='Bard'
    end
    lemote1=''
    lemote2=''
    legstr=''
    unless @legendary.nil?
      lemote1='<:Legendary_Effect_Unknown:443337603945857024>'
      lemote1='<:Mythic_Effect_Unknown:523328368079273984>' if @legendary[3]=='Mythic'
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{@legendary[0]}"}
      moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_LElement_#{@legendary[0]}"} if @games[0]=='DL'
      lemote1=moji[0].mention unless moji.length<=0
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{@legendary[1].gsub(' Slot','')}"}
      moji=bot.server(554231720698707979).emoji.values.reject{|q| q.name != "Mythic_Slot_#{@legendary[1].gsub(' Slot','')}"} if @legendary[1].include?(' Slot')
      moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_LBoost_#{@legendary[1].gsub(' Slot','')}"} if @games[0]=='DL'
      lemote2=moji[0].mention unless moji.length<=0
      legstr="\n#{lemote1}*#{@legendary[0]}* / #{lemote2}*#{@legendary[1].gsub('Duel','Pair-Up').gsub(' Slot','* / *Slot+')}* #{@legendary[3]} Hero"
      legstr="\n#{lemote1}*#{@legendary[0]}* / #{lemote2}*#{@legendary[1].gsub('Duel','Pair-Up').gsub(' Slot','* / *Slot+')}* #{@legendary[3]} - #{self.seasonality}" if self.seasonality.length>0
      if Shardizard==$spanishShard
        legstr="\n#{lemote1}*Héroe #{self.spanish_legendary[3]} de#{self.spanish_legendary[2]} #{self.spanish_legendary[0]}* / #{lemote2}*#{self.spanish_legendary[1].gsub(' Slot','* / *Slot+')}*"
        legstr="\n#{lemote1}*#{self.spanish_legendary[3]} de#{self.spanish_legendary[2]} #{self.spanish_legendary[0]}* / #{lemote2}*#{self.spanish_legendary[1].gsub(' Slot','* / *Slot+')}* - #{self.seasonality}" if self.seasonality.length>0
      end
    end
    demote=''
    unless @duo.nil?
      moji=bot.server(554231720698707979).emoji.values.reject{|q| q.name != "Hero_#{@duo[0][0]}"}
      moji=bot.server(554231720698707979).emoji.values.reject{|q| q.name != "Hero_#{@duo[0][0]}_Mathoo"} if @name=='Mathoo'
      demote=moji[0].mention unless moji.length<=0
      duostr="\n#{demote}*#{@duo[0][0]} Hero* with #{list_lift(@duo.map{|q| q[2]},'and')}"
      duostr="\n#{demote}*Héroe #{self.spanish_duo}* con #{list_lift(@duo.map{|q| q[2]},'y')}" if Shardizard==$spanishShard
    end
    bemote=[]
    if includebonus
      if Shardizard==$spanishShard && !emotesonly
        bemote.push("<:Current_Arena_Bonus:498797967042412544> Bonificación actual en Arena") if self.isBonusUnit?('Arena')
        bemote.push("<:Current_Aether_Bonus:510022809741950986> Bonificación actual en Asaltos Etéreos") if self.isBonusUnit?('Aether')
        bemote.push("<:Special_Blade:800880639540068353> Bonificación actual en Batallas Fragorosas") if self.isBonusUnit?('Resonant')
        bemote.push("<:Current_Tempest_Bonus:498797966740422656> Bonificación actual en la Tormenta") if self.isBonusUnit?('Tempest')
      else
        bemote.push("<:Current_Arena_Bonus:498797967042412544>#{' Current Arena Bonus unit' unless emotesonly}") if self.isBonusUnit?('Arena')
        bemote.push("<:Current_Aether_Bonus:510022809741950986>#{' Current Aether Raids Bonus unit' unless emotesonly}") if self.isBonusUnit?('Aether')
        bemote.push("<:Special_Blade:800880639540068353>#{' Current Resonant Battles Bonus unit' unless emotesonly}") if self.isBonusUnit?('Resonant')
        bemote.push("<:Current_Tempest_Bonus:498797966740422656>#{' Current Tempest Trials Bonus unit' unless emotesonly}") if self.isBonusUnit?('Tempest')
      end
    end
    return "#{'<:Summon_Gun:467557566050861074>' if @name=='Kiran' || @id==0}#{wemote}#{memote}#{'<:Assist_Music:454462054959415296>' if refresher.length>0}#{lemote1}#{lemote2}#{demote}#{bemote.join('')}" if emotesonly
    refresher="\n<:Assist_Music:454462054959415296> *#{refresher}*" if refresher.length>0
    unless @clazz_flag.nil? || @clazz_flag.length<=0
      if Shardizard==$spanishShard
        refresher="#{refresher}\n*Modificadores adicionales:* #{@clazz_flag.join(', ')}"
      else
        refresher="#{refresher}\n*Other modifiers:* #{@clazz_flag.join(', ')}"
      end
    end
    return "#{"<:Summon_Gun:467557566050861074>*Arma para Convocar*\n" if @name=='Kiran' || @id==0}#{wemote}#{self.wstring_spanish}\n#{memote}*#{self.movement_spanish}*#{refresher}#{legstr}#{duostr}#{"\n" if bemote.length>0}#{bemote.join("\n")}" if Shardizard==$spanishShard
    return "#{"<:Summon_Gun:467557566050861074>*Summon Gun*\n" if @name=='Kiran' || @id==0}#{wemote}#{self.weapon_string}\n#{memote}*#{@movement}*#{refresher}#{legstr}#{duostr}#{"\n" if bemote.length>0}#{bemote.join("\n")}"
  end
  
  def emotes(bot,includebonus=true,includeresp=false,forceheart=false); return self.class_header(bot,true,includebonus); end
  def submotes(bot,forceheart=false); return ''; end
  
  def postName(x=false)
    x2=''
    x2='~~' unless @fake.nil?
    x2="*#{x2}" if x && @availability[0].include?('-')
    return "#{x2}#{@name}#{x2.reverse}"
  end
  
  def skill_list(rarity=5)
    x=$skills.reject{|q| !has_any?(q.learn[0,rarity].flatten,[@name,"All #{self.unit_group}"]) || q.level=='example' || ['Falchion','Missiletainn','Whelp (All)','Yearling (All)','Adult (All)'].include?(q.name)}.map{|q| q.clone}
    x=x.reject{|q| q.type.include?('Weapon') && q.learn[0,rarity].flatten.include?("All #{self.unit_group}")} if self.weapon_type=='Staff' && !@weapon[2].nil? && @weapon[2].include?('Ignore: ') && @weapon[2].include?('We')
    x=x.reject{|q| q.type.include?('Assist') && q.learn[0,rarity].flatten.include?("All #{self.unit_group}")} if self.weapon_type=='Staff' && !@weapon[2].nil? && @weapon[2].include?('Ignore: ') && @weapon[2].include?('As')
    x=x.reject{|q| q.type.include?('Special') && q.learn[0,rarity].flatten.include?("All #{self.unit_group}")} if self.weapon_type=='Staff' && !@weapon[2].nil? && @weapon[2].include?('Ignore: ') && @weapon[2].include?('Sp')
    return x
  end
  
  def summoned(rarity=5)
    if ['Robin','Robin (shared stats)','Kris','Kris (shared stats)'].include?(@name)
      x=@name.split(' (')[0]
      x=[$units.find_index{|q| q.name=="#{x}(M)"},$units.find_index{|q| q.name=="#{x}(F)"}]
      x=x.compact.map{|q| $units[q]}
      return x.map{|q| q.summoned(rarity)}
    end
    x=$skills.reject{|q| !has_any?(q.summon[0,rarity].flatten,[@name,"All #{self.unit_group}"]) || q.level=='example' || ['Falchion','Missiletainn','Whelp (All)','Yearling (All)','Adult(All)'].include?(q.name)}.map{|q| q.clone}
    x=x.reject{|q| q.type.include?('Weapon')} if self.weapon_type=='Staff' && !@weapon[2].nil? && @weapon[2].include?('Ignore: ') && @weapon[2].include?('We')
    x=x.reject{|q| q.type.include?('Assist')} if self.weapon_type=='Staff' && !@weapon[2].nil? && @weapon[2].include?('Ignore: ') && @weapon[2].include?('As')
    x=x.reject{|q| q.type.include?('Special')} if self.weapon_type=='Staff' && !@weapon[2].nil? && @weapon[2].include?('Ignore: ') && @weapon[2].include?('Sp')
    return x
  end
  
  def prf(excluderetro=false)
    if ['Robin','Robin (shared stats)','Kris','Kris (shared stats)'].include?(@name)
      x=@name.split(' (')[0]
      x=[$units.find_index{|q| q.name=="#{x}(M)"},$units.find_index{|q| q.name=="#{x}(F)"}]
      x=x.compact.map{|q| $units[q]}
      return x.map{|q| q.prf}
    end
    x=$skills.reject{|q| q.exclusivity.nil? || !q.exclusivity.include?(@name) || ['Falchion','Ragnarok+','Missiletainn'].include?(q.name)}.map{|q| q.clone}
    x=x.reject{|q| q.prerequisite.nil? || q.prerequisite.length<=0 || !q.type.include?('Weapon')} if excluderetro
    return x
  end
  
  def isPostable?(event)
    return true if @fake.nil?
    return false if event.server.nil?
    g=[nil]
    for i in 0...$server_markers.length
      g.push($server_markers[i][0]) if event.server.id==$server_markers[i][1]
      g.push($server_markers[i][0].downcase) if event.server.id==$server_markers[i][1]
    end
    g.push('X') if $x_markers.include?(event.server.id)
    g.push('x') if $x_markers.include?(event.server.id)
    return has_any?(g,@fake[0].chars)
  end
  
  def dispPrf(bonus='')
    if ['Robin','Robin (shared stats)','Kris','Kris (shared stats)'].include?(@name)
      x=@name.split(' (')[0]
      x=[$units.find_index{|q| q.name=="#{x}(M)"},$units.find_index{|q| q.name=="#{x}(F)"}]
      x=x.compact.map{|q| $units[q]}
      return x.map{|q| q.dispPrf(bonus)}
    end
    if bonus=='Enemy' && @name=='Hel'
      s=$skills.reject{|q| q.name != "Hel Scythe"}
      return s[0] unless s.length<=0
      return nil
    end
    s=$skills.reject{|q| !q.type.include?('Weapon') || q.exclusivity.nil? || !q.exclusivity.include?(@name) || ['Falchion','Missiletainn'].include?(q.name)}
    x=s.find_index{|q| q.prerequisite.nil? || q.prerequisite.length<=0}
    return s[x] unless x.nil?
    x=s.find_index{|q| q.summon.join(', ').split(', ').include?(@name)}
    return s[x] unless x.nil?
    x=s.find_index{|q| q.learn.join(', ').split(', ').include?(@name)}
    return s[x] unless x.nil?
    return nil
  end
  
  def stats1=(val); @stats1=val; end
  
  def stats40=(val)
    @stats40=val
    if @growths.max>0
      for i in 0...@stats40.length
        @stats1[i]=@stats40[i]-(0.39*(((@growths[i]*5+20)*(0.79+(0.07*5))).to_i)).to_i
      end
    end
  end
  
  def supernatures(rarity=5)
    x=[' ',' ',' ',' ',' ']
    for i in 0...x.length
      x[i]='+' if [-3,1,5,10,14].include?(@growths[i]) && rarity==5
      x[i]='-' if [-2,2,6,11,15].include?(@growths[i]) && rarity==5
      x[i]='+' if [-2,10].include?(@growths[i]) && rarity==4
      x[i]='-' if [-1,11].include?(@growths[i]) && rarity==4
    end
    return x
  end
  
  def thumbnail(event,bot,resp=false)
    args=event.message.text.downcase
    if @name=='Kiran'
      data_load(['library'])
      face=find_kiran_face(event).gsub(' ','')
      dd="#{@name}/#{face}"
    else
      return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{@name.split(' ')[0]}.png" if ['Robin','Robin (shared stats)','Kris (shared stats)','Kris'].include?(@name)
      return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{@name}.png" if ['Corrin','Grima','Kana','Morgan','Tiki'].include?(@name)
      return bot.user(@fake[1]).avatar_url if !@fake.nil? && !@fake[1].nil? && @fake[1].is_a?(Integer) && !bot.user(@fake[1]).nil?
      dd=@name.gsub(' ','_')
      if args.include?('face') || rand(1000).zero?
        return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/Face_Face.png" if ['Nino(Launch)','Amelia'].include?(@name)
      elsif args.include?('face') || rand(100).zero?
        return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/Face_Face.png" if ['Nino(Launch)'].include?(@name)
      elsif args.include?('creep') || args.include?('grin') || rand(100).zero?
        return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/Face_Face.png" if ['Reinhardt(Bonds)','Reinhardt(World)'].include?(@name)
      elsif args.include?('woke') || rand(100).zero?
        return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/Face_Face.png" if @name=='Arden'
      end
      dd="#{dd}/Resplendent" if (resp || has_any?(args.split(' '),['resplendant','resplendent','ascension','ascend','resplend','ex'])) && @availability[0].include?('RA')
    end
    args=args.split(' ')
    if has_any?(args,['battle','attacking'])
      return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/BtlFace_BU.png"
    elsif has_any?(args,['damage','damaged','lowhealth','lowhp','low_health','low_hp','injured'])
      return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/BtlFace_BU_D.png"
    end
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/Face_FC.png"
  end
  
  def disp_color(chain=0,mode=0)
    f=[]
    f.push(0x9400D3) if @name=='Kiran'
    xcolor=0xFFD800
    unless @legendary.nil?
      # Elemental colors - unused after the first embed
      xcolor=0xF98281 if @legendary[0]=='Fire'
      xcolor=0x91F4FF if @legendary[0]=='Water'
      xcolor=0x97FF99 if @legendary[0]=='Wind'
      xcolor=0xFFAF7E if @legendary[0]=='Earth'
      xcolor=0xFDF39D if @legendary[0]=='Light'
      xcolor=0xBE83FE if @legendary[0]=='Dark'
      xcolor=0xF5A4DA if @legendary[0]=='Astra'
      xcolor=0xE1DACF if @legendary[0]=='Anima'
      f.push(xcolor)
    end
    # Weapon colors
    xcolor=0xE22141 if self.weapon_color=='Red'
    xcolor=0x2764DE if self.weapon_color=='Blue'
    xcolor=0x09AA24 if self.weapon_color=='Green'
    xcolor=0x64757D if self.weapon_color=='Colorless'
    xcolor=avg_color([[226,33,65],[39,100,222]]) if @name=='Kris' || @name=='Kris (shared stats)'
    xcolor=avg_color([[39,100,222],[9,170,36]]) if @name=='Robin' || @name=='Robin (shared stats)'
    f.push(xcolor)
    # Duo colors
    unless @duo.nil?
      xcolor=0xB2C604
      xcolor=0x076F85 if @name=='Mathoo'
      xcolor=0xC0EEB6 if @duo[0][0]=='Harmonic'
      f.push(xcolor)
    end
    xcolor=0xD094F3
    xcolor=0xF79FA0 if @movement=='Infantry'
    xcolor=0x90C0F5 if @movement=='Flier'
    xcolor=0xEBBF70 if @movement=='Cavalry'
    xcolor=0x9FE0B3 if @movement=='Armor'
    f.push(xcolor)
    f=@color_flag unless @color_flag.nil?
    # Special colors
    xcolor=f[chain]
    xcolor=f[0] if chain>=f.length
    return f if chain<0
    return [xcolor/256/256, (xcolor/256)%256, xcolor%256] if mode==1 # in mode 1, return as three single-channel numbers - used when averaging colors
    return xcolor
  end
  
  def dispStats(bot,level=40,rarity=5,boon='',bane='',merges=0,flowers=0,support='',bonus='',blessing=[],resp=false,weapon=nil,refne='',transformed=false,skill_list=[],pairup=false)
    posit=0
    posit=5 if self.hasEnemyForm? && bonus=='Enemy'
    bonus='' if bonus=='Enemy'
    l1=@stats1[posit,5].map{|q| q}
    l2=@stats1[posit,5].map{|q| q}
    gr=@growths[posit,5].map{|q| q}
    if @name=='Kiran' && (@weapon[1]=='Blade' || (@weapon[0]=='Gold' && support.length>0))
      l1[1]+=1; l1[2]+=1; l1[3]+=1; l1[4]+=1
      l2[1]+=1; l2[2]+=1; l2[3]+=1; l2[4]+=1
      gr[0]+=1; gr[3]+=1; gr[4]+=1
    end
    flowers=[flowers,self.dragonflowerMax].min
    unless rarity==5
      xx=2-((rarity-1)/2)
      for i in 0...l1.length
        l1[i]-=xx
      end
      if rarity%2==0
        s=[[l1[1],1],[l1[2],2],[l1[3],3],[l1[4],4]]
        s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}
        l1[s[0][1]]+=1
        l1[s[1][1]]+=1
      end
    end
    if boon.length>0 || bane.length>0
      boonx=Stat_Names.find_index{|q| q==boon}
      banex=Stat_Names.find_index{|q| q==bane}
      l2[banex]-=1 unless banex.nil?
      banex=nil if merges>0
      unless boonx.nil?
        l1[boonx]+=1
        l2[boonx]+=1
        gr[boonx]+=1
      end
      unless banex.nil?
        l1[banex]-=1
        gr[banex]-=1
      end
    end
    if merges>0 || flowers>0
      s=[[l2[0],0],[l2[1],1],[l2[2],2],[l2[3],3],[l2[4],4]]
      s.sort! {|b,a| (a[0] <=> b[0]) == 0 ? (b[1] <=> a[1]) : (a[0] <=> b[0])}
      s.push(s[0],s[1],s[2],s[3],s[4])
      if merges>4 || flowers>4
        for i in 0...l1.length
          l1[i]+=(merges/5)*2+flowers/5
        end
      end
      if merges%5>0
        for i in 0...merges%5
          l1[s[2*i][1]]+=1
          l1[s[2*i+1][1]]+=1
        end
      end
      if flowers%5>0
        for i in 0...flowers%5
          l1[s[2*i][1]]+=1
        end
      end
      if merges>0 && boon.length<=0 && bane.length<=0
        l1[s[0][1]]+=1
        l1[s[1][1]]+=1
        l1[s[2][1]]+=1
      end
    end
    l1=@stats40.map{|q| q} if @growths.max<=0
    l1=[0,0,0,0,0] if @growths.max<=0 && level==1
    unless support.length<=0 || @name=='Kiran'
      l1[0]+=5 if support=='S'
      l1[0]+=4 if ['A','B'].include?(support)
      l1[0]+=3 if support=='C'
      l1[1]+=2 if support=='S'
      l1[2]+=2 if ['S','A'].include?(support)
      l1[3]+=2 if ['S','A','B'].include?(support)
      l1[4]+=2 if ['S','A','B','C'].include?(support)
    end
    unless bonus.length<=0
      l1[0]+=10
      l1[1]+=4
      l1[2]+=4
      l1[3]+=4
      l1[4]+=4
    end
    for i in 0...[blessing.length,7].min
      l1[0]+=3
      l1[0]+=2 if blessing[i].include?('Mythical')
      if blessing[i].include?('Attack')
        l1[1]+=2
        l1[1]+=1 if blessing[i].include?('Mythical')
      elsif blessing[i].include?('Speed')
        l1[2]+=3
        l1[2]+=1 if blessing[i].include?('Mythical')
      elsif blessing[i].include?('Defense')
        l1[3]+=4
        l1[3]+=1 if blessing[i].include?('Mythical')
      elsif blessing[i].include?('Resistance')
        l1[4]+=4
        l1[4]+=1 if blessing[i].include?('Mythical')
      end
    end
    unless weapon.nil? || weapon.weapon_stats.nil?
      if refne.length<=0 || weapon.refine.nil?
        for i in 0...l1.length
          l1[i]+=weapon.weapon_stats[i]
          l1[i]+=weapon.weapon_stats[i+5] if transformed && weapon.weapon_stats.length>5
        end
      else
        l1[1]+=weapon.refine.dispStats(refne)[0]
        for i in 0...l1.length
          l1[i]+=weapon.refine.dispStats(refne)[i+1]
          l1[i]+=weapon.weapon_stats[i+5] if transformed && weapon.weapon_stats.length>5
        end
      end
    end
    if resp && self.hasResplendent?
      l1[0]+=2
      l1[1]+=2
      l1[2]+=2
      l1[3]+=2
      l1[4]+=2
    end
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2','Stat-Buffing 1','Stat-Buffing 2','Stat-Buffing 3','Stat-Nerfing 1','Stat-Nerfing 2','Stat-Nerfing 3'].include?(q[3])}
    buffs=[0,0,0,0,0]
    nerfs=[0,0,0,0,0]
    for i in 0...skill_list.length
      x=lookout.find_index{|q| q[0]==skill_list[i]}
      unless x.nil?
        xx=lookout[x][4]
        for i2 in 0...l1.length
          if ['Stat-Buffing 1','Stat-Buffing 2','Stat-Buffing 3'].include?(lookout[x][3])
            buffs[i2]=[buffs[i2],xx[i2]].max
          elsif ['Stat-Nerfing 1','Stat-Nerfing 2','Stat-Nerfing 3'].include?(lookout[x][3])
            nerfs[i2]=[nerfs[i2],0-xx[i2]].min
          else
            l1[i2]=[l1[i2]+xx[i2],0].max
          end
        end
      end
    end
    # Harsh Command turns all nerfs into buffs
    if has_any?(skill_list,['Harsh Command','Harsh Command+'])
      for i in 0...l1.length
        buffs[i]=[buffs[i],0-nerfs[i]].max
        nerfs[i]=0
      end
    end
    # Panic Ploy reverses all buffs (negative buffs are not the same as debuffs)
    if skill_list.include?('Panic Ploy')
      for i in 0...l1.length
        buffs[i]=0-buffs[i]
      end
    end
    for i in 0...l1.length
      l1[i]=l1[i]+buffs[i]+nerfs[i]
    end
    if level>1 && @growths.max>0
      for i in 0...l1.length
        if level>40
          l1[i]+=(0.39*((((level-1)/38.0)*(gr[i]*5+20)*(0.79+(0.07*rarity))).to_i)).to_i
        else
          l1[i]+=(0.39*(((gr[i]*5+20)*(0.79+(0.07*rarity))).to_i)).to_i
        end
      end
    end
    return l1
  end
  
  def summonability
    return -100 if @availability.nil? # units without availability data are not summonable
    return -1 if @availability[0].include?('-') # enemy units are not summonable
    return 0 unless @availability[0].gsub('0s','').include?('s') || @availability[0].include?('p') # units that cannot appear on banners are not summonable
    return 1 unless @availability[0].include?('p') && @duo.nil? # seasonal units are level 1 summonable
    return 2 if @availability[0].include?('TD') && @id>319 # Book 1/2 units that are removed from New/Special Heroes banners are level 2 summonable
    return 3 # all other units are level 3 summonable
  end
  
  def dispSkills(bot,event,rarity=5,smol=false,emotes=true,zelgiused=false,explainemotes=false)
    if @name=='Robin' || @name.downcase=='robin (shared stats)'
      x=[$units.find_index{|q| q.name=='Robin(M)'},$units.find_index{|q| q.name=='Robin(F)'}]
      x=x.compact.map{|q| $units[q]}
      return x.map{|q| ["**#{q.name}**#{q.emotes(bot)}",q.dispSkills(bot,event,rarity,true)[0][1]]}
    elsif @name=='Kris' || @name.downcase=='kris (shared stats)'
      x=[$units.find_index{|q| q.name=='Kris(M)'},$units.find_index{|q| q.name=='Kris(F)'}]
      x=x.compact.map{|q| $units[q]}
      return x.map{|q| ["**#{q.name}**#{q.emotes(bot)}",q.dispSkills(bot,event,rarity,true)[0][1]]}
    end
    x=self.skill_list(rarity).clone
    x2=self.summoned(rarity).clone
    retroprf=nil
    extraskills=[]
    for i in 0...x.length
      x[i].name="**#{x[i].name}**" if x2.map{|q| q.name}.include?(x[i].name)
      x[i].name="#{x[i].name}\n#{x[i].description}" if has_any?(['Duo','Harmonic'],x[i].tags) && !smol
      if x[i].type.include?('Weapon') && !x[i].exclusivity.nil? && x[i].exclusivity.include?(@name) && x[i].prerequisite.nil? && x[i].id>=20
        retroprf=x[i].clone
        x[i]=nil
      elsif x[i].name.gsub('*','').split(' ')[-1]=='Breidablik' && x[i].id>999
        extraskills.push(x[i].clone)
        x[i]=nil
      end
      x[i].id+=50000 if !x[i].nil? && x[i].type.include?('Special') && x[i].id<210000
      if x[i].nil?
      elsif x[i].id<0
        x[i].id=0-x[i].id
        if x[i].id>=300000
          x[i].id+=90000
        elsif x[i].id>=100000
          x[i].id+=9000
        else
          x[i].id+=4000
        end
      end
      if !@legendary.nil?
        data_load(['library'])
        x[i]=self.legend_shift_skill(x[i])
      end
    end
    x.compact!
    x=x.sort{|a,b| a.id<=>b.id}
    x=x.reject{|q| q.type.include?('Weapon') || (has_any?(q.type,['Assist','Special']) && !q.exclusivity.nil?)} if zelgiused
    if @name=='Mathoo' && has_any?(event.message.text.downcase.split(' '),['boss','enemy','rokkr'])
      x=x.reject{|q| q.name=='Liliputia'}
      data_load(['skills'])
      m=$skills.find_index{|q| q.name=='Brobdingo'}
      m=$skills[m].clone
      m.exclusivity='Mathoo'
      x.push(m)
    elsif @name=='Hel' && has_any?(event.message.text.downcase.split(' '),['boss','enemy'])
      x=x.reject{|q| q.type.include?('Weapon') && !q.exclusivity.nil?}
      data_load(['skills'])
      m=$skills.find_index{|q| q.name=='Hel Scythe'}
      m=$skills[m].clone
      m.name="**#{m.name}**"
      x.push(m)
    end
    y=[x.reject{|q| !q.type.include?('Weapon')},x.reject{|q| !q.type.include?('Assist')},x.reject{|q| !q.type.include?('Special')},x.reject{|q| !q.type.include?('Passive(A)')},x.reject{|q| !q.type.include?('Passive(B)')},x.reject{|q| !q.type.include?('Passive(C)')},[],x.reject{|q| !has_any?(q.type,['Duo','Harmonic'])}]
    unless y[0][-1].nil? || y[0][-1].evolutions.nil? || (@name=='Hel' && has_any?(event.message.text.downcase.split(' '),['boss','enemy']))
      y2=$skills.find_index{|q| q.name==y[0][-1].evolutions[0]}
      unless y2.nil?
        y2=$skills[y2].clone
        y2.name="~~#{y2.name}~~"
        y[0].push(y2)
        unless y[0][-1].evolutions.nil?
          rld=false
          while !y[0][-1].evolutions.nil? && !rld
            y2=$skills.find_index{|q| q.name==y[0][-1].evolutions[0]}
            if y2.nil?
              rld=true
            else
              y2=$skills[y2].clone
              y2.name="~~#{y2.name}~~"
              y[0].push(y2)
            end
          end
        end
      end
    end
    if zelgiused
    elsif @name=='Kiran'
      unless smol
        y[0][-1].name="__#{y[0][-1].name}__"
        for i in 0...extraskills.length
          y[0].push(extraskills[i].clone)
        end
      end
    elsif !retroprf.nil?
      y[0][-1].name="__#{y[0][-1].name}__" unless smol
      y[0].push(retroprf)
      unless y[0][-1].evolutions.nil?
        y2=$skills.find_index{|q| q.name==y[0][-1].evolutions[0]}
        unless y2.nil?
          y2=$skills[y2].clone
          y2.name="~~#{y2.name}~~"
          y[0].push(y2)
        end
      end
    end
    y2=y.map{|q| q.map{|q2| q2.fullName}}
    for i in 0...y2.length
      y2[i]=['~~*none*~~'] if y2[i].length<=0
    end
    emotes2Bexplained=[false,false,false,false]
    if smol
      for i in 0...y2.length
        y3=y2[i].reject{|q| !q.include?('**')}
        y3=y3[-1] if y3.length>0
        y4=y2[i][-1]
        em=Skill_Slots[0][i]
        em='<:Hero_Duo:631431055420948480>' if Skill_Slots[1][i]=='Duo/Harmonic' && !@duo.nil? && @duo[0][0]=='Duo'
        em='<:Hero_Harmonic:722436762248413234>' if Skill_Slots[1][i]=='Duo/Harmonic' && !@duo.nil? && @duo[0][0]=='Harmonic'
        em='<:Hero_Duo_Mathoo:631431055513092106>' if Skill_Slots[1][i]=='Duo/Harmonic' && @name=='Mathoo'
        em="<:Summon_Gun:467557566050861074>**Breidablik**\n#{em}" if @name=='Kiran' && em=='<:Skill_Weapon:444078171114045450>'
        if y3.length>0 && y3 != y4
          y2[i]="#{em}#{y3} / #{y4}"
        else
          y2[i]="#{em}#{y4}"
        end
        if @name=='Kiran'
        elsif emotes && y[i].length>0 && !y[i][-1].exclusivity.nil?
          y2[i]="#{y2[i]} <:Prf_Sparkle:490307608973148180>"
          emotes2Bexplained[0]=true
        end
        if !emotes
        elsif i>2 && i<6 && y[i].length>0
          x=y[i][-1].learn.find_index{|q| q.include?(@name)}
          y2[i]="#{y2[i]} #{Rarity_stars[0][x]}" unless x.nil? || !y[i][-1].exclusivity.nil?
        end
        y2[i]=nil if ['<:Hero_Duo:631431055420948480><:Hero_Harmonic:722436762248413234>~~*none*~~','<:Passive_S:443677023626330122>~~*none*~~'].include?(y2[i])
      end
      y2.compact!
      return [['Habilidades',y2.join("\n")]] if Shardizard==$spanishShard
      return [['Skills',y2.join("\n")]]
    end
    for i in 0...y2.length
      pos=1
      pos=2 if Shardizard==$spanishShard
      em="#{Skill_Slots[0][i]}#{Skill_Slots[pos][i]}"
      em="<:Hero_Duo:631431055420948480>#{Skill_Slots[pos][i].split('/')[0]}" if Skill_Slots[1][i]=='Duo/Harmonic' && !@duo.nil? && @duo[0][0]=='Duo'
      em="<:Hero_Harmonic:722436762248413234>#{Skill_Slots[pos][i].split('/')[1]}" if Skill_Slots[1][i]=='Duo/Harmonic' && !@duo.nil? && @duo[0][0]=='Harmonic'
      em="<:Hero_Duo_Mathoo:631431055513092106>#{Skill_Slots[pos][i].split('/')[0]}" if Skill_Slots[1][i]=='Duo/Harmonic' && @name=='Mathoo'
      if Skill_Slots[1][i]=='Weapon' && y[i].length>0 && emotes
        for i2 in 0...y2[i].length
          if @name=='Kiran' && y[i][i2].id>999
            y2[i][i2]="#{y[i][i2].class_header(bot,true,true)}#{y2[i][i2]}"
          elsif !y[i][i2].exclusivity.nil?
            y2[i][i2]="#{y2[i][i2]}<:Prf_Sparkle:490307608973148180>"
            emotes2Bexplained[0]=true
          elsif y[i][i2].learn.join(', ').include?('All ')
          elsif y[i][i2].learn.join(', ').split(', ').reject{|q| $units.find_index{|q2| q2.name==q}.nil? || !$units[$units.find_index{|q2| q2.name==q}].fake.nil? || @name==q}.length==0
            y2[i][i2]="#{y2[i][i2]}<:Arena_Crown:490334177124810772>"
            emotes2Bexplained[1]=true
          elsif self.summonability<2
          elsif y[i][i2].learn.join(', ').split(', ').reject{|q| $units.find_index{|q2| q2.name==q}.nil? || !$units[$units.find_index{|q2| q2.name==q}].fake.nil? || $units[$units.find_index{|q2| q2.name==q}].summonability<2 || @name==q}.length==0
            y2[i][i2]="#{y2[i][i2]}<:Orb_Rainbow:471001777622351872>"
            emotes2Bexplained[2]=true
          elsif y[i][i2].learn.join(', ').split(', ').reject{|q| $units.find_index{|q2| q2.name==q}.nil? || !$units[$units.find_index{|q2| q2.name==q}].fake.nil? || $units[$units.find_index{|q2| q2.name==q}].summonability<3 || @name==q}.length==0
            y2[i][i2]="#{y2[i][i2]}<:Orb_Gold:549338084102111250>"
            emotes2Bexplained[3]=true
          end
        end
      end
      ub='~~*unknown base*~~'
      ub='~~*previo desconocido*~~' if Shardizard==$spanishShard
      y2[i].unshift(ub) if y[i].length>0 && !y[i][0].prerequisite.nil? && y[i][0].prerequisite.length>1
      y2[i]=[em,y2[i].join("\n")]
      if y[i].length<=0 || !emotes || ['Duo/Harmonic','Weapon'].include?(Skill_Slots[1][i])
      elsif !y[i][-1].exclusivity.nil?
        y2[i][1]="#{y2[i][1]}<:Prf_Sparkle:490307608973148180>"
        emotes2Bexplained[0]=true
      elsif y[i][-1].learn.join(', ').include?('All ') || @name=='Kiran'
      elsif y[i][-1].learn.join(', ').split(', ').reject{|q| $units.find_index{|q2| q2.name==q}.nil? || !$units[$units.find_index{|q2| q2.name==q}].fake.nil? || @name==q}.length==0
        y2[i][1]="#{y2[i][1]}<:Arena_Crown:490334177124810772>"
        emotes2Bexplained[1]=true
      elsif self.summonability<2
      elsif y[i][-1].learn.join(', ').split(', ').reject{|q| $units.find_index{|q2| q2.name==q}.nil? || !$units[$units.find_index{|q2| q2.name==q}].fake.nil? || $units[$units.find_index{|q2| q2.name==q}].summonability<2 || @name==q}.length==0
        y2[i][1]="#{y2[i][1]}<:Orb_Rainbow:471001777622351872>"
        emotes2Bexplained[2]=true
      elsif y[i][-1].learn.join(', ').split(', ').reject{|q| $units.find_index{|q2| q2.name==q}.nil? || !$units[$units.find_index{|q2| q2.name==q}].fake.nil? || $units[$units.find_index{|q2| q2.name==q}].summonability<3 || @name==q}.length==0
        y2[i][1]="#{y2[i][1]}<:Orb_Gold:549338084102111250>"
        emotes2Bexplained[3]=true
      end
      if i>2 && i<6 && y[i].length>0 && emotes
        x=y[i][-1].learn.find_index{|q| q.include?(@name)}
        y2[i][1]="#{y2[i][1]}   #{Rarity_stars[0][x]}" unless x.nil? || !y[i][-1].exclusivity.nil?
      end
      y2[i]=nil if ["<:Hero_Duo:631431055420948480><:Hero_Harmonic:722436762248413234>#{Skill_Slots[pos][7]}","<:Passive_S:443677023626330122>#{Skill_Slots[pos][6]}"].include?(y2[i][0]) && y2[i][1]=='~~*none*~~'
    end
    y2.compact!
    if explainemotes && emotes2Bexplained.include?(true)
      ftr=nil
      if emotes2Bexplained[1]
        ftr='Crowns mark inheritable skills only this unit has.'
        ftr='Purple sparkles mark Prf skills.  Crowns mark unique inheritable skills.' if emotes2Bexplained[0]
        ftr='Unique inheritable skills:  Crown = overall,   Gold orb = within Book 3-5 summon pool.' if emotes2Bexplained[3]
        ftr='Unique inheritable skills:  Crown = overall,   Orb = within non-limited summon pool.' if emotes2Bexplained[2]
        ftr='Las coronas indican habilidades que solo este personaje tiene.' if Shardizard==$spanishShard
      elsif emotes2Bexplained[0]
        ftr='Purple sparkles mark skills Prf to this unit.'
        ftr='Purple sparkles mark Prf skills.  Gold orbs mark semi-unique inheritable skills.' if emotes2Bexplained[3]
        ftr='Purple sparkles mark Prf skills.  Orbs mark semi-unique inheritable skills.' if emotes2Bexplained[2]
        ftr='Los destellos morados indican habilidades exclusivas de este personaje.' if Shardizard==$spanishShard
      elsif emotes2Bexplained[2]
        ftr='Orbs mark inheritable skills that within the non-limited summon pool, only this unit has.'
        ftr='Unique inheritable skills:  Gold orb = within Book 3-5 summon pool,  Rainbow orb = within non-limited summon pool.' if emotes2Bexplained[3]
        ftr='Los orbes indican habilidades que se pueden heredar pero excluyendo personajes de temporada, solo este personaje sabe.' if Shardizard==$spanishShard
      elsif emotes2Bexplained[3]
        ftr='Gold orbs mark inheritable skills that within the Book 3-5 summon pool, only this unit has.'
        ftr='Los orbes dorados indican habilidades que dentro del grupo estándar, solo este personaje tiene.' if Shardizard==$spanishShard
      end
      y2.push(ftr) unless ftr.nil?
    end
    return y2
  end
  
  def atkName(full=true,weapon=nil,refine=nil,transformed=false)
    x='Strength'
    unless full==1
      x='Freeze' if self.weapon_type=='Dragon'
      x='Freeze' if !weapon.nil? && weapon.has_tag?('Frostbite',refine,transformed)
    end
    x='Magic' if ['Tome','Staff'].include?(self.weapon_type)
    x='Attack' if @name=='Kiran'
    m='Fuerza'
    m='Magia' if x=='Magic'
    return m if Shardizard==$spanishShard && full==1
    return 'Atk' if !full && x=='Attack'
    return 'Frz' if !full && x=='Freeze'
    x=x[0,3] unless full
    return x
  end
  
  def starDisplay(bot,rarity=5,boon='',bane='',merges=0,flowers=0)
    flowers=[flowers,self.dragonflowerMax].min
    stars="#{rarity}#{Rarity_stars[0][rarity-1]}"
    stars="#{rarity}#{Rarity_stars[1][rarity-1]}" if merges>=Max_rarity_merge[1]
    if @forma
      stars="#{rarity}<:Icon_Rarity_Forma:699042072526585927>"
      stars="#{rarity}<:Icon_Rarity_Forma_p10:699085674099376148>" if rarity>=5 && merges>=Max_rarity_merge[1]
    end
    stars="#{rarity}#{['','<:Rarity_1:532086056594440231>','<:Rarity_2:532086056254963713>','<:Rarity_3:532086056519204864>','<:Rarity_4:532086056301101067>','<:Rarity_5:532086056737177600>'][rarity]}" if @games[0]=='DL'
    stars="#{rarity}#{['<:FGO_icon_rarity_dark:571937156981981184>','<:FGO_icon_rarity_sickly:571937157095227402>','<:FGO_icon_rarity_rust:523903558928826372>','<:FGO_icon_rarity_mono:523903551144198145>','<:FGO_icon_rarity_gold:523858991571533825>'][rarity-1]}" if @games[0]=='FGO'
    stars="#{rarity}-star" if rarity==0 || rarity>6
    nat=''
    boon2="#{boon}"; bane2="#{bane}"
    if Shardizard==$spanishShard
      boon2='Ataque' if boon=='Attack'
      bane2='Ataque' if bane=='Attack'
      boon2='Velocidad' if boon=='Speed'
      bane2='Velocidad' if bane=='Speed'
      boon2='Defensa' if boon=='Defense'
      bane2='Defensa' if bane=='Defense'
      boon2='Resistencia' if boon=='Resistance'
      bane2='Resistencia' if bane=='Resistance'
    end
    if boon2.length>0 && bane2.length>0
      nat="+#{boon2} -#{bane2}"
      nat="+#{boon2} ~~-#{bane2}~~" if merges>0
    elsif boon2.length>0
      nat="+#{boon2}"
    elsif bane2.length>0
      nat="#{'~~' if merges>0}-#{bane2}#{'~~' if merges>0}"
    end
    str="#{stars} #{@name}#{self.emotes(bot,true,true,true)}"
    str="#{str} +#{merges}" if merges>0
    str="#{str} (#{nat})" if nat.length>0
    str="#{str} #{self.dragonflowerEmote}+#{flowers}" if flowers>0
    return str
  end
  
  def dragonflowerEmote
    flwr='<:Dragonflower_Purple:552648232673607701>'
    flwr='<:Dragonflower_Infantry:541170819980722176>' if @movement=='Infantry'
    flwr='<:Dragonflower_Flier:541170820089774091>' if @movement=='Flier'
    flwr='<:Dragonflower_Cavalry:541170819955556352>' if @movement=='Cavalry'
    flwr='<:Dragonflower_Armor:541170820001824778>' if @movement=='Armor'
    flwr='<:Clover:575230371587948568>' if @games[0]=='DL'
    flwr='<:Final_Fragment:575255136012730368>' if @games[0]=='FGO'
    return flwr
  end
  
  def starHeader(bot,rarity=5,boon='',bane='',merges=0,flowers=0,support='',bonus='',blessing=[],resp=false,weapon=nil,refne='',transformed=false,skill_list=[],skill_list_2=[],wpnlegal=true,pairup=false,expanded_mode=1,owner='')
    flowers=[flowers,self.dragonflowerMax].min
    stars=Rarity_stars[0][rarity-1]*rarity
    stars=Rarity_stars[1][rarity-1]*rarity if merges>=Max_rarity_merge[1]
    if @owner=='Mathoo' || owner=='Mathoo'
      stars='<:FEH_rarity_M:577779126891577355>'*rarity
      stars='<:FEH_rarity_Mp10:577779126853959681>'*rarity if rarity>=5 && merges>=Max_rarity_merge[1]
    end
    if ['S','A','B','C'].include?(support)
      stars='<:Icon_Rarity_S:448266418035621888>'*rarity
      stars='<:Icon_Rarity_Sp10:448272715653054485>'*rarity if rarity>=5 && merges>=Max_rarity_merge[1]
    end
    if @forma
      stars='<:Icon_Rarity_Forma:699042072526585927>'*rarity
      stars='<:Icon_Rarity_Forma_p10:699085674099376148>'*rarity if rarity>=5 && merges>=Max_rarity_merge[1]
    end
    stars="#{['','<:Rarity_1:532086056594440231>','<:Rarity_2:532086056254963713>','<:Rarity_3:532086056519204864>','<:Rarity_4:532086056301101067>','<:Rarity_5:532086056737177600>'][rarity]*rarity}#{['','<:Rarity_1_Blank:555459856476274691>','<:Rarity_2_Blank:555459856400908299>','<:Rarity_3_Blank:555459856568418314>','<:Rarity_4_Blank:555459856497246218>','<:Rarity_5_Blank:555459856190930955>'][rarity]*(5-rarity)}" if @games[0]=='DL'
    stars=['<:FGO_icon_rarity_dark:571937156981981184>','<:FGO_icon_rarity_sickly:571937157095227402>','<:FGO_icon_rarity_rust:523903558928826372>','<:FGO_icon_rarity_mono:523903551144198145>','<:FGO_icon_rarity_gold:523858991571533825>'][rarity-1]*rarity if @games[0]=='FGO'
    stars="**#{rarity}-star**" if rarity==0 || rarity>6
    return "\u200B#{stars}#{"**+#{merges}**" if merges>0}" if expanded_mode==0
    nat=''
    support='' if support=='-' && expanded_mode==1
    support='-' if support=='' && expanded_mode==2
    boon2="#{boon}"; bane2="#{bane}"
    if Shardizard==$spanishShard
      boon2='Ataque' if boon=='Attack'
      bane2='Ataque' if bane=='Attack'
      boon2='Velocidad' if boon=='Speed'
      bane2='Velocidad' if bane=='Speed'
      boon2='Defensa' if boon=='Defense'
      bane2='Defensa' if bane=='Defense'
      boon2='Resistencia' if boon=='Resistance'
      bane2='Resistencia' if bane=='Resistance'
    end
    if boon.length>0 && bane.length>0
      n=Natures.reject{|q| q[1]!=boon || q[2]!=bane}
      n=$spanish_Natures.reject{|q| q[1]!=boon || q[2]!=bane} if Shardizard==$spanishShard
      n2=n.map{|q| q[0]}.join('/')
      n2=n[0][0] if self.atkName(true,weapon,refne,transformed)=='Strength'
      n2=n[-1][0] if self.atkName(true,weapon,refne,transformed)=='Magic'
      if n2.include?('/')
        n2=n[0][0] if self.atkName(true)=='Strength'
        n2=n[-1][0] if self.atkName(true)=='Magic'
        n2=n[-1][0] if n2.include?('/') && self.weapon_type=='Dragon'
      end
      nat="\n+#{boon2}, -#{bane2} (#{n2})"
      nat="\n+#{boon2}, ~~-#{bane2}~~ (#{n2}, bane neutralized)" if merges>0
      nat="\n+#{boon2}, ~~-#{bane2}~~ (#{n2}, perdición neutralizada)" if merges>0 && Shardizard==$spanishShard
    elsif boon.length>0
      nat="\n+#{boon2}"
    elsif bane.length>0
      nat="\n#{'~~' if merges>0}-#{bane2}#{'~~ (neutralized)' if merges>0}"
      nat="\n#{'~~' if merges>0}-#{bane2}#{'~~ (neutralizada)' if merges>0}" if Shardizard==$spanishShard
    elsif expanded_mode==2
      nat="\nNeutral nature"
      nat="\nNaturaleza neutral" if Shardizard==$spanishShard
    end
    heart='<:Icon_Support:448293527642701824>'
    heart='<:Lovewhistle:575233033024569365>' if @games[0]=='DL'
    heart='<:FGO_Favorite:679278523009204226>' if @games[0]=='FGO'
    bonus='Rokkr' if bonus=='Enemy' && @name=='Mathoo'
    bonus='' if bonus=='Enemy' && !self.hasEnemyForm?
    bonus='' if bonus=='Rokkr' && @name!='Mathoo'
    bonusx="#{bonus} Bouns Unit"
    bonusx="Enemy Boss Unit" if bonus=='Enemy'
    bonusx="Rokkr Unit" if bonus=='Rokkr'
    bonusx="Not a bonus unit" if bonus.length<=0
    trns=''
    if self.weapon_type=='Beast'
      trns="\nForm: Humanoid"
      trns="\nForma de Humanoide" if Shardizard==$spanishShard
      trns="\nForm: #{self.beast_species} (transformed)" if transformed
      trns="\nForma de #{self.spanish_beast} (transformad#{self.spanish_gender.downcase})" if transformed && Shardizard==$spanishShard
    end
    sl=skill_list.map{|q| q}
    for i in 0...sl.length
      if sl[i][0,20]=='Color Duel Movement '
        if self.weapon_color=='Gold'
          dclr='Color'
        else
          dclr=self.weapon_color[0]
        end
        sl[i]=sl[i].gsub('Color',dclr).gsub('Movement',@movement.gsub('Flier','Flying'))
      end
    end
    sl2=skill_list_2.map{|q| q}
    sb=[]
    sn=[]
    lookout=$statskills.reject{|q| !['Stat-Buffing 1','Stat-Buffing 2','Stat-Buffing 3','Stat-Nerfing 1','Stat-Nerfing 2','Stat-Nerfing 3'].include?(q[3])}
    for i in 0...sl2.length
      dclr=lookout.find_index{|q| q[0]==sl2[i]}
      unless dclr.nil?
        sl2[i]=sl2.gsub('Movement',self.movement.gsub('Flier','Fliers')) if sl2[i][sl2[i].length-9,9]==' Movement'
        if ['Stat-Buffing 1','Stat-Buffing 2','Stat-Buffing 3'].include?(lookout[dclr][3])
          sb.push(sl2[i])
        elsif ['Stat-Nerfing 1','Stat-Nerfing 2','Stat-Nerfing 3'].include?(lookout[dclr][3])
          sn.push(sl2[i])
        end
      end
    end
    refne2=''
    refne2='Efecto' if refne=='Effect'
    refne2='Ataque' if refne=='Attack'
    refne2='Velocidad' if refne=='Speed'
    refne2='Defensa' if refne=='Defense'
    refne2='Resistencia' if refne=='Resistance'
    refne2='Furioso' if refne=='Wrathful'
    refne2='Brillante' if refne=='Dazzling'
    return "\u200B#{stars}\nNumero de merge: **+#{merges}**\n#{self.dragonflowerEmote}Numero de Dracoflor: **x#{flowers}** (out of #{self.dragonflowerMax})#{"\n#{heart}Apoyo del Invocador: **#{support}**" if support.length>0}#{nat}#{"\n<:Resplendent_Ascension:678748961607122945>Atuendo Resplandeciente" if resp && @availability[0].include?('RA')}\nArma equipada: #{'~~*none*~~' if weapon.nil?}#{"#{'~~' unless wpnlegal}#{weapon.name}#{'~~' unless wpnlegal}#{"\nRefinando: #{'~~*none*~~' if refne.nil? || refne.length<=0}#{"#{'~~' unless wpnlegal}Modo de #{refne2}#{'~~' unless wpnlegal}" if !refne.nil? && refne.length>0}" unless weapon.refine.nil?}" unless weapon.nil?}#{trns}\nHabilidades que afectan las estadísticas: #{sl.join(', ') unless sl.length<=0}#{'*~~none~~*' if sl.length<=0}\nHabilidades que aumentan las estadísticas: #{sb.join(', ') unless sb.length<=0}#{'*~~none~~*' if sb.length<=0}\nHabilidades que disminuyen las estadísticas: #{sn.join(', ') unless sn.length<=0}#{'*~~none~~*' if sn.length<=0}\n#{bonusx}\nBendiciones aplicadas: #{blessing.join(', ') if blessing.length>0}#{'~~*none*~~' unless blessing.length>0}" if expanded_mode==2 && Shardizard==$spanishShard
    return "\u200B#{stars}\nMerge count: **+#{merges}**\n#{self.dragonflowerEmote}Dragonflower count: **x#{flowers}** (out of #{self.dragonflowerMax})#{"\n#{heart}Summoner Support: **#{support}**" if support.length>0}#{nat}#{"\n<:Resplendent_Ascension:678748961607122945>Resplendent Ascension" if resp && @availability[0].include?('RA')}\nEquipped weapon: #{'~~*none*~~' if weapon.nil?}#{"#{'~~' unless wpnlegal}#{weapon.name}#{'~~' unless wpnlegal}#{"\nRefinement: #{'~~*none*~~' if refne.nil? || refne.length<=0}#{"#{'~~' unless wpnlegal}#{refne} Mode#{'~~' unless wpnlegal}" if !refne.nil? && refne.length>0}" unless weapon.refine.nil?}" unless weapon.nil?}#{trns}\nStat-affecting skills: #{sl.join(', ') unless sl.length<=0}#{'*~~none~~*' if sl.length<=0}\nStat-buffing skills: #{sb.join(', ') unless sb.length<=0}#{'*~~none~~*' if sb.length<=0}\nStat-nerfing skills: #{sn.join(', ') unless sn.length<=0}#{'*~~none~~*' if sn.length<=0}\n#{bonusx}\nBlessings applied: #{blessing.join(', ') if blessing.length>0}#{'~~*none*~~' unless blessing.length>0}" if expanded_mode==2
    xblessings=''
    if blessing.length>0
      blessing=blessing[0,[blessing.length,7].min]
      xblessings="\n#{blessing[0].split('(')[1].gsub(')','')} Blessings applied: "
      b=blessing.map{|q| q.split('(')[0]}
      b2=b.uniq.map{|q| [q,0]}
      for i in 0...b2.length
        b2[i][1]=b.reject{|q| q != b2[i][0]}.length
        b2[i]="#{b2[i][0]}#{" x#{b2[i][1]}" unless b2[i][1]==1}"
      end
      xblessings="#{xblessings}#{b2.join(', ')}"
    end
    return "\u200B#{stars}#{"**+#{merges}**" if merges>0}#{"  \u00B7  #{heart}**#{support}**" if support.length>0}#{"  \u00B7  #{self.dragonflowerEmote}**x#{flowers}**" if flowers>0}#{nat}#{"\n<:Resplendent_Ascension:678748961607122945>Ascensión Resplandeciente" if resp && @availability[0].include?('RA')}#{"\nArma equipada: #{'~~' unless wpnlegal}#{weapon.name}#{" (+) Modo de #{refne2}" if !weapon.refine.nil? && !refne.nil? && refne.length>0}#{'~~' unless wpnlegal}#{trns}" unless weapon.nil?}#{"\n#{bonusx}" if bonus.length>0}#{xblessings}#{"\nHabilidades que afectan las estadísticas: #{sl.join(', ')}" unless sl.length<=0}#{"\nHabilidades que aumentan las estadísticas: #{sb.join(', ')}" unless sb.length<=0}#{"\nHabilidades que disminuyen las estadísticas: #{sn.join(', ')}" unless sn.length<=0}" if Shardizard==$spanishShard
    return "\u200B#{stars}#{"**+#{merges}**" if merges>0}#{"  \u00B7  #{heart}**#{support}**" if support.length>0}#{"  \u00B7  #{self.dragonflowerEmote}**x#{flowers}**" if flowers>0}#{nat}#{"\n<:Resplendent_Ascension:678748961607122945>Resplendent Ascension" if resp && @availability[0].include?('RA')}#{"\nEquipped weapon: #{'~~' unless wpnlegal}#{weapon.name}#{" (+) #{refne} Mode" if !weapon.refine.nil? && !refne.nil? && refne.length>0}#{'~~' unless wpnlegal}#{trns}" unless weapon.nil?}#{"\n#{bonusx}" if bonus.length>0}#{xblessings}#{"\nStat-affecting skills: #{sl.join(', ')}" unless sl.length<=0}#{"\nStat-buffing skills: #{sb.join(', ')}" unless sb.length<=0}#{"\nStat-nerfing skills: #{sn.join(', ')}" unless sn.length<=0}"
  end
  
  def starHeader2(bot,ignorenature=true,rarity=5,boon='',bane='',merges=0,flowers=0,support='',bonus='',blessing=[],resp=false,weapon=nil,refne='',transformed=false,skill_list=[],skill_list_2=[],wpnlegal=true,pairup=false,expanded_mode=1)
    return starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,skill_list_2,wpnlegal,pairup,expanded_mode)
  end
  
  def statEmotes(weapon=nil,refine=nil,transformed=false,includename=false,isgift=false)
    return ['<:HP:573344832307593216>HP',"<:Strength:573344931205349376>#{self.atkName(weapon,refine,transformed)}",'<:Speed:573366907357495296>Speed','<:FEHDefense:732740083370950727>Defense','<:Defense:573344832282689567>Resistance'] if !@games.nil? && @games[0]=='DL' && includename
    return ['<:HP:573344832307593216>','<:Strength:573344931205349376>','<:Speed:573366907357495296>','<:FEHDefense:732740083370950727>','<:Defense:573344832282689567>'] if !@games.nil? && @games[0]=='DL'
    atk='<:StrengthS:514712248372166666>'
    atk='<:FreezeS:514712247474585610>' if self.weapon_type=='Dragon'
    atk='<:MagicS:514712247289774111>' if ['Tome','Staff'].include?(self.weapon_type)
    if weapon.nil?
    elsif weapon.is_a?(FEHSkill)
      atk='<:FreezeS:514712247474585610>' if weapon.has_tag?('Frostbite',refine,transformed)
    else
      atk='<:MagicS:514712247289774111>' if ['Tome','Staff'].include?(weapon)
      atk='<:FreezeS:514712247474585610>' if weapon=='Dragon'
    end
    m='Fuerza'
    m='Magia' if atk=='<:MagicS:514712247289774111>'
    m='Congelación' if atk=='<:FreezeS:514712247474585610>'
    return ['<:HP_S:514712247503945739>HP',"#{atk}#{m}",'<:SpeedS:514712247625580555>Velocidad','<:DefenseS:514712247461871616>Defensa','<:ResistanceS:514712247574986752>Resistencia'] if includename && Shardizard==$spanishShard
    return ['<:HP_S:514712247503945739>HP',"#{atk}#{atk.split(':')[1][0,atk.split(':')[1].length-1].gsub('Generic','')}",'<:SpeedS:514712247625580555>Speed','<:DefenseS:514712247461871616>Defense','<:ResistanceS:514712247574986752>Resistance'] if includename
    return ['<:HP_S:514712247503945739>',atk,'<:SpeedS:514712247625580555>','<:DefenseS:514712247461871616>','<:ResistanceS:514712247574986752>']
  end
  
  def statGrid(bot,rarity=5,boon='',bane='',merges=0,flowers=0,support='',bonus='',blessing=[],resp=false,weapon=nil,refne='',transformed=false,skill_list=[],pairup=false,lvl=40)
    x=dispStats(bot,1,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup).map{|q| "#{' ' if q<10}#{q}"}.join(' |')
    x4=dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    x44=dispStats(bot,79,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    x444=dispStats(bot,99,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    m=[x4.inject(0){|sum,x| sum + x },x44.inject(0){|sum,x| sum + x },x444.inject(0){|sum,x| sum + x }]
    if lvl>98
      m=m[2]
    elsif lvl>40
      m=m[1]
    else
      m=m[0]
    end
    x44=x44.map{|q| "#{' ' if q<10}#{q}"}.join(' |')
    x444=x444.map{|q| "#{' ' if q<10}#{q}"}.join(' |')
    x2=x4.map{|q| "#{' ' if q<10}#{q}"}
    x3=self.supernatures(rarity).map{|q| q}
    x3=x3.map{|q| q.gsub('-',' ')} if merges>0
    boonx=Stat_Names.find_index{|q| q==boon}
    banex=Stat_Names.find_index{|q| q==bane}
    unless boonx.nil?
      for i in 0...x3.length
        x3[i]=' ' if x3[i]=='+' && i != boonx
      end
    end
    unless banex.nil?
      for i in 0...x3.length
        x3[i]=' ' if x3[i]=='-' && i != banex
      end
    end
    for i in 0...x2.length
      x2[i]="#{x2[i]}#{x3[i]}"
    end
    x2=x2.join('|')
    scorename='Score'
    scorename='Puntaje' if Shardizard==$spanishShard
    return "#{starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,[],true,pairup)}\n\n#{self.statEmotes(weapon,refne,transformed).join("\u00A0\u00A0\u00B7\u00A0\u00A0")}\u00A0\u00A0\u00B7\u00A0\u00A0#{m} BST#{micronumber(lvl)}#{"\u00A0\u00A0\u00B7\u00A0\u00A0#{scorename}: #{self.score(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}" unless bonus=='Enemy' && self.hasEnemyForm?}\n```#{x2}```" if @growths.max<=0
    return "#{starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,[],true,pairup)}\n\nPersonaje solo enemig#{self.spanish_gender.downcase}\nUsa la palabra \"Enemy\" para ver sus estadísticas." if @growths[0,5].max<=0 && self.hasEnemyForm? && bonus != 'Enemy' && Shardizard==$spanishShard
    return "#{starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,[],true,pairup)}\n\nEnemy Exclusive Unit\nUse the word \"Enemy\" to see #{self.pronoun(true)} stats." if @growths[0,5].max<=0 && self.hasEnemyForm? && bonus != 'Enemy'
    trns=''
    if self.weapon_type=='Beast' && !weapon.nil? && weapon.weapon_stats.length>5 && !transformed
      xx=[]
      xx.push("#{'+' if weapon.weapon_stats[5]>0}#{weapon.weapon_stats[5]} HP") unless weapon.weapon_stats[5]==0
      xx.push("#{'+' if weapon.weapon_stats[6]>0}#{weapon.weapon_stats[6]} At#{'k' unless Shardizard==$spanishShard}#{'q' if Shardizard==$spanishShard}") unless weapon.weapon_stats[6]==0
      xx.push("#{'+' if weapon.weapon_stats[7]>0}#{weapon.weapon_stats[7]} Spd") unless weapon.weapon_stats[7]==0 || Shardizard==$spanishShard
      xx.push("#{'+' if weapon.weapon_stats[7]>0}#{weapon.weapon_stats[7]} Vel") unless weapon.weapon_stats[7]==0 || Shardizard !=$spanishShard
      xx.push("#{'+' if weapon.weapon_stats[8]>0}#{weapon.weapon_stats[8]} Def") unless weapon.weapon_stats[8]==0
      xx.push("#{'+' if weapon.weapon_stats[9]>0}#{weapon.weapon_stats[9]} Res") unless weapon.weapon_stats[9]==0
      if xx.length>0
        if Shardizard==$spanishShard
          trns="\nCuando se transforma: #{xx.join(', ')}\nIncluye la palabra \"transformed\" tener esto aplicado."
        else
          trns="\nWhen transformed: #{xx.join(', ')}\nInclude the word \"transformed\" to apply this directly."
        end
      end
    end
    if @name=='Kiran' && @owner.nil?
      return "__**Con filo equipado**__<:Red_Blade:443172811830198282><:Blue_Blade:467112472768151562><:Green_Blade:467122927230386207>\n#{self.statEmotes('Blade',refne,transformed).join("\u00A0\u00A0\u00B7\u00A0\u00A0")}\u00A0\u00A0\u00B7\u00A0\u00A0#{m} BST#{micronumber(lvl)}#{"\u00A0\u00A0\u00B7\u00A0\u00A0#{scorename}: #{self.score(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}" unless bonus=='Enemy' && self.hasEnemyForm?}\n```#{x}\n#{x2}#{"\n#{x44}" if lvl>40}#{"\n#{x444}" if lvl>98}```#{trns}" if support.length>0 && Shardizard==$spanishShard
      return "__**Blade equipped**__<:Red_Blade:443172811830198282><:Blue_Blade:467112472768151562><:Green_Blade:467122927230386207>\n#{self.statEmotes('Blade',refne,transformed).join("\u00A0\u00A0\u00B7\u00A0\u00A0")}\u00A0\u00A0\u00B7\u00A0\u00A0#{m} BST#{micronumber(lvl)}#{"\u00A0\u00A0\u00B7\u00A0\u00A0#{scorename}: #{self.score(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}" unless bonus=='Enemy' && self.hasEnemyForm?}\n```#{x}\n#{x2}#{"\n#{x44}" if lvl>40}#{"\n#{x444}" if lvl>98}```#{trns}" if support.length>0
      return "__**Con tomo equipado**<:Red_Tome:443172811826003968><:Blue_Tome:467112472394858508><:Green_Tome:467122927666593822><:Colorless_Tome:443692133317345290>__\n#{self.statEmotes('Tome',refne,transformed).join("\u00A0\u00A0\u00B7\u00A0\u00A0")}\u00A0\u00A0\u00B7\u00A0\u00A0#{m} BST#{micronumber(lvl)}#{"\u00A0\u00A0\u00B7\u00A0\u00A0#{scorename}: #{self.score(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}" unless bonus=='Enemy' && self.hasEnemyForm?}\n```#{x}\n#{x2}#{"\n#{x44}" if lvl>40}#{"\n#{x444}" if lvl>98}```#{trns}" if Shardizard==$spanishShard
      return "__**Tome equipped**<:Red_Tome:443172811826003968><:Blue_Tome:467112472394858508><:Green_Tome:467122927666593822><:Colorless_Tome:443692133317345290>__\n#{self.statEmotes('Tome',refne,transformed).join("\u00A0\u00A0\u00B7\u00A0\u00A0")}\u00A0\u00A0\u00B7\u00A0\u00A0#{m} BST#{micronumber(lvl)}#{"\u00A0\u00A0\u00B7\u00A0\u00A0#{scorename}: #{self.score(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}" unless bonus=='Enemy' && self.hasEnemyForm?}\n```#{x}\n#{x2}#{"\n#{x44}" if lvl>40}#{"\n#{x444}" if lvl>98}```#{trns}"
    end
    return "#{starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,[],true,pairup)}\n\n#{self.statEmotes(weapon,refne,transformed).join("\u00A0\u00A0\u00B7\u00A0\u00A0")}\u00A0\u00A0\u00B7\u00A0\u00A0#{m} BST#{micronumber(lvl)}#{"\u00A0\u00A0\u00B7\u00A0\u00A0#{scorename}: #{self.score(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}" unless bonus=='Enemy' && self.hasEnemyForm?}\n```#{x}\n#{x2}#{"\n#{x44}" if lvl>40}#{"\n#{x444}" if lvl>98}```#{trns}"
  end
  
  def statList(bot,includegrowths=false,diff=[0,0,0,0,0],rarity=5,boon='',bane='',merges=0,flowers=0,support='',bonus='',blessing=[],resp=false,weapon=nil,refne='',transformed=false,skill_list=[],skill_list_2=[],wpnlegal=true,pairup=false,lvl=40)
    x=dispStats(bot,1,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    px=dispStats(bot,1,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,[skill_list,skill_list_2].flatten,pairup)
    y=dispStats(bot,1,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    py=dispStats(bot,1,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,[skill_list,skill_list_2].flatten,pairup)
    x=dispStats(bot,1,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,skill_list,pairup) unless wpnlegal
    px=dispStats(bot,1,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,[skill_list,skill_list_2].flatten,pairup) unless wpnlegal
    xx=x.inject(0){|sum,xy| sum + xy }
    yy=y.inject(0){|sum,xy| sum + xy }
    pxx=px.inject(0){|sum,xy| sum + xy }
    pyy=py.inject(0){|sum,xy| sum + xy }
    pd=diff.inject(0){|sum,xy| sum + xy }
    gr=@growths.map{|q| q}
    if boon.length>0 || bane.length>0
      boonx=Stat_Names.find_index{|q| q==boon}
      banex=Stat_Names.find_index{|q| q==bane}
      banex=nil if merges>0
      gr[boonx]+=1 unless boonx.nil?
      gr[banex]-=1 unless banex.nil?
    end
    gx=gr.inject(0){|sum,x| sum + x }
    x2=dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    px2=dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,[skill_list,skill_list_2].flatten,pairup)
    y2=dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    py2=dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,[skill_list,skill_list_2].flatten,pairup)
    x2=dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,skill_list,pairup) unless wpnlegal
    px2=dispStats(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,[skill_list,skill_list_2].flatten,pairup) unless wpnlegal
    xx2=x2.inject(0){|sum,x| sum + x }
    yy2=y2.inject(0){|sum,x| sum + x }
    pxx2=px2.inject(0){|sum,x| sum + x }
    pyy2=py2.inject(0){|sum,x| sum + x }
    x22=dispStats(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    px22=dispStats(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,[skill_list,skill_list_2].flatten,pairup)
    y22=dispStats(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,skill_list,pairup)
    py22=dispStats(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,transformed,[skill_list,skill_list_2].flatten,pairup)
    x22=dispStats(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,skill_list,pairup) unless wpnlegal
    px22=dispStats(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,nil,'',false,[skill_list,skill_list_2].flatten,pairup) unless wpnlegal
    xx22=x22.inject(0){|sum,x| sum + x }
    yy22=y22.inject(0){|sum,x| sum + x }
    pxx22=px22.inject(0){|sum,x| sum + x }
    pyy22=py22.inject(0){|sum,x| sum + x }
    x3=self.supernatures(rarity).map{|q| q}
    x3=x3.map{|q| q.gsub('-',' ')} if merges>0
    boonx=Stat_Names.find_index{|q| q==boon}
    banex=Stat_Names.find_index{|q| q==bane}
    scorename='Score'
    scorename='Puntaje' if Shardizard==$spanishShard
    unless boonx.nil?
      for i in 0...x3.length
        x3[i]=' ' if x3[i]=='+' && i != boonx
      end
    end
    unless banex.nil?
      for i in 0...x3.length
        x3[i]=' ' if x3[i]=='-' && i != banex
      end
    end
    x3=x3.map{|q| q.gsub('+','(+)').gsub('-','(-)')}
    for i in 0...x2.length
      unless diff[i]==0
        x[i]="#{x[i]}/#{x[i]+diff[i]}"
        y[i]="#{y[i]}/#{y[i]+diff[i]}"
        px[i]="#{px[i]}/#{px[i]+diff[i]}"
        py[i]="#{py[i]}/#{py[i]+diff[i]}"
        x2[i]="#{x2[i]}/#{x2[i]+diff[i]}"
        y2[i]="#{y2[i]}/#{y2[i]+diff[i]}"
        px2[i]="#{px2[i]}/#{px2[i]+diff[i]}"
        py2[i]="#{py2[i]}/#{py2[i]+diff[i]}"
        x22[i]="#{x22[i]}/#{x22[i]+diff[i]}"
        y22[i]="#{y22[i]}/#{y22[i]+diff[i]}"
        px22[i]="#{px22[i]}/#{px22[i]+diff[i]}"
        py22[i]="#{py22[i]}/#{py22[i]+diff[i]}"
      end
      y[i]="#{y[i]}#{" (#{py[i]})" unless y[i]==py[i]}"
      x[i]="#{x[i]}#{" (#{px[i]})" unless x[i]==px[i]}"
      y2[i]="#{y2[i]}#{" (#{py2[i]})" unless y2[i]==py2[i]}"
      x2[i]="#{x2[i]}#{" (#{px2[i]})" unless x2[i]==px2[i]}"
      y22[i]="#{y22[i]}#{" (#{py22[i]})" unless y22[i]==py22[i]}"
      x22[i]="#{x22[i]}#{" (#{px22[i]})" unless x22[i]==px22[i]}"
      emotestr="#{self.statEmotes(weapon,refne,transformed,true)[i]}"
      x[i]="#{emotestr}: #{"~~#{y[i]}~~ " unless x[i]==y[i]}#{x[i]}"
      gr[i]="#{emotestr}: #{gr[i]*5+20}%#{" #{x3[i]}" if includegrowths}"
      x2[i]="#{emotestr}: #{"~~#{y2[i]}~~ " unless x2[i]==y2[i]}#{x2[i]}#{" #{x3[i]}" unless includegrowths || skill_list_2.length>0 || !wpnlegal}"
      x22[i]="#{emotestr}: #{"~~#{y22[i]}~~ " unless x22[i]==y22[i]}#{x22[i]}"
    end
    x.push('')
    unless pd==0
      xx="#{xx}/#{xx+pd}"
      yy="#{yy}/#{yy+pd}"
      pxx="#{pxx}/#{pxx+pd}"
      pyy="#{pyy}/#{pyy+pd}"
      xx2="#{xx2}/#{xx2+pd}"
      yy2="#{yy2}/#{yy2+pd}"
      pxx2="#{pxx2}/#{pxx2+pd}"
      pyy2="#{pyy2}/#{pyy2+pd}"
      xx22="#{xx22}/#{xx22+pd}"
      yy22="#{yy22}/#{yy22+pd}"
      pxx22="#{pxx22}/#{pxx22+pd}"
      pyy22="#{pyy22}/#{pyy22+pd}"
    end
    yy="#{yy}#{" (#{pyy})" unless yy==pyy}"
    xx="#{xx}#{" (#{pxx})" unless xx==pxx}"
    x.push("BST: #{"~~#{yy}~~ " unless xx==yy}#{xx}")
    unless bonus=='Enemy' && self.hasEnemyForm?
      x.push("#{scorename}: #{self.score(bot,1,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}")
      x[-1]="#{x[-1]}+`SP`/100" unless self.is_a?(SuperUnit)
    end
    gr.push('')
    gr.push("GRT: #{gx*5+100}%")
    x2.push('')
    x22.push('')
    yy2="#{yy2}#{" (#{pyy2})" unless yy2==pyy2}"
    xx2="#{xx2}#{" (#{pxx2})" unless xx2==pxx2}"
    yy22="#{yy22}#{" (#{pyy22})" unless yy22==pyy22}"
    xx22="#{xx22}#{" (#{pxx22})" unless xx22==pxx22}"
    x2.push("BST: #{"~~#{yy2}~~ " unless xx2==yy2}#{xx2}")
    x22.push("BST: #{"~~#{yy22}~~ " unless xx22==yy22}#{xx22}")
    unless bonus=='Enemy' && self.hasEnemyForm?
      x2.push("#{scorename}: #{self.score(bot,40,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}")
      x22.push("#{scorename}: #{self.score(bot,lvl,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refne,skill_list).to_i}")
      x2[-1]="#{x2[-1]}+`SP`/100" unless self.is_a?(SuperUnit)
      x22[-1]="#{x22[-1]}+`SP`/100" unless self.is_a?(SuperUnit)
    end
    f=[]
    lvnm=['Level','Growths']
    lvnm=['Nivel','Crecimientos'] if Shardizard==$spanishShard
    f.push(["#{lvnm[0]} 1#{" +#{merges}" unless merges<=0}",x.join("\n")]) unless @growths.max<=0
    f.push([lvnm[1],gr.join("\n")]) if includegrowths && @growths.max>0 && lvl<41
    f.push(["#{lvnm[0]} 40#{" +#{merges}" unless merges<=0}",x2.join("\n")])
    if lvl>40
      f.push(["#{lvnm[0]} #{lvl}#{" +#{merges}" unless merges<=0}",x22.join("\n")])
      f.push([lvnm[1],gr.join("\n")]) if includegrowths && @growths.max>0
    end
    return f
  end
  
  def score(bot,level=40,rarity=5,boon='',bane='',merges=0,flowers=0,support='',bonus='',blessing=[],resp=false,weapon=nil,refne='',skill_list=[])
    xbane="#{bane}"
    xbane='' if merges>0
    x=dispStats(bot,40,rarity,boon,xbane,0,0).inject(0){|sum,x| sum + x }
    x=dispStats(bot,40,rarity,boon,xbane,0,0,'x').inject(0){|sum,x| sum + x } if @name=='Kiran' && (@weapon[1]=='Blade' || (@weapon[0]=='Gold' && support.length>0))
    x+=3 if boon.length<=0 && bane.length<=0 && merges>0
    x=[x,175].max if rarity>=5 && level>=40 && !@legendary.nil? && @legendary[1]=='Duel'
    x=[x,180].max if rarity>=5 && level>=40 && !@legendary.nil? && @legendary[1]=='Duel' && (@movement=='Armor' || @id>=500)
    x=[x,185].max if rarity>=5 && level>=40 && !@legendary.nil? && @legendary[1]=='Duel' && @id>=640
    x=[x,185].max if rarity>=5 && level>=40 && !@duo.nil? && @duo[0][0]=='Duo'
    x=[x,190].max if rarity>=5 && level>=40 && !@duo.nil? && @duo[0][0]=='Duo' && @id>590
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}
    for i in 0...skill_list.length
      x2=lookout.find_index{|q| q[0]==skill_list[i]}
      if lookout[x2][4].length>5
        x3=lookout[x2][4][5]
        x3=[lookout[x2][4][5],170].min unless @legendary.nil?
      end
      x=[x,x3].max if !x2.nil? && rarity>=5 && level>=40 && lookout[x2][4].length>5
    end
    x/=5
    x+=rarity*5+merges*2
    x+=level*2.25
    x+=blessing.length*4
    y=0
    unless weapon.nil?
      y=weapon.sp_cost*1
      y=350 if refne.length>0 && !weapon.refine.nil?
      y=400 if refne.length>0 && !weapon.refine.nil? && !weapon.exclusivity.nil?
      x+=y/100.0
    end
    return x
  end
  
  def from_game(gme,majoronly=false)
    if gme.is_a?(Array)
      for i in 0...gme.length
        return true if self.from_game(gme[i],majoronly)
      end
      return false
    end
    return false if @games.nil? || @games.length<=0
    return true if @games[0]==gme
    return true if @games.include?("*#{gme}")
    return true if gme=='FE14' && self.from_game(['FE14B','FE14C','FE14b','FE14c','FE14R','FE14g'],majoronly)
    return false if majoronly
    return true if @games.include?(gme)
    return false
  end
  
  def isBonusUnit?(xtype='Arena')
    return false if @name=='Kiran'
    if ['Robin','Robin (shared stats)','Kris','Kris (shared stats)'].include?(@name)
      x=@name.split(' (')[0]
      x=[$units.find_index{|q| q.name=="#{x}(M)"},$units.find_index{|q| q.name=="#{x}(F)"}]
      x=x.compact.map{|q| $units[q]}
      x=x.map{|q| q.isBonusUnit?(xtype)}
      return false if x.include?(false)
      return true
    end
    x=$bonus_units.find_index{|q| q.type==xtype && q.isCurrent?}
    return false if x.nil?
    x=$bonus_units[x]
    if xtype=='Resonant'
      return true if self.from_game(x.bonuses,true)
      return false
    end
    return true if x.bonuses.include?(@name)
    return false
  end
  
  def bonus_type
    b=[]
    b.push('Arena') if self.isBonusUnit?('Arena')
    b.push('Aether') if self.isBonusUnit?('Aether')
    b.push('Tempest') if self.isBonusUnit?('Tempest')
    b.push('Resonant') if self.isBonusUnit?('Resonant')
    return 'Bonus' if b.length>1 || b.include?('Resonant')
    return b[0] if b.length>0
    return ''
  end
  
  def seasonality
    return '' if @legendary.nil?
    if @legendary[3]=='Legendary'
      x=$bonus_units.find_index{|q| q.type=='Arena' && q.isCurrent?}
      return '' if x.nil?
      x=$bonus_units[x]
      return 'En temporada' if x.elements.include?(@legendary[0]) && Shardizard==$spanishShard
      return 'in season' if x.elements.include?(@legendary[0])
    elsif @legendary[3]=='Mythic'
      x=$bonus_units.find_index{|q| q.type=='Aether' && q.isCurrent?}
      return '' if x.nil?
      x=$bonus_units[x]
      return 'Temporada ofensiva' if @legendary[0]==x.elements[0] && Shardizard==$spanishShard
      return 'Offense season' if @legendary[0]==x.elements[0]
      return 'Temporada defensiva' if @legendary[0]==x.elements[1] && Shardizard==$spanishShard
      return 'Defense season' if @legendary[0]==x.elements[1]
    end
    return ''
  end
  
  def legendary_timing(number=false)
    return nil if @legendary.nil? || @legendary[2].nil?
    x=@legendary[2].split('/').map{|q| q.to_i}
    return 1000000000000 if x[0]<0 && number
    return 'Remix' if x[0]<0
    x[0]=21 if x[0]>=21
    x[0]=11 if x[0]>=11 && x[0]<21
    x[0]=1 if x[0]<11
    return x[2]*10000+x[1]*100+x[0] if number
    if Shardizard==$spanishShard
      x[0]=['Principios de ','Mediados de ','A fines de '][(x[0]-1)/10]
      x[1]=$spanish_months[0][x[1]]
    else
      x[0]=['Early ','Mid-','Late '][(x[0]-1)/10]
      x[1]=['','January','February','March','April','May','June','July','August','September','October','November','December'][x[1]]
    end
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    return "#{x[0]}#{x[1]}" if x[2]==t.year
    return "#{x[0]}#{x[1]} #{x[2]}"
  end
  
  def legendary_display_name
    return nil if @legendary.nil? || @legendary[2].nil?
    x=@legendary[2].split('/').map{|q| q.to_i}
    return "#{@name}" if x[0]<0
    return @name
  end
  
  def colorAsNumber
    return 1 if self.weapon_color=='Red'
    return 2 if self.weapon_color=='Blue'
    return 3 if self.weapon_color=='Green'
    return 4 if self.weapon_color=='Colorless'
    return 10
  end
  
  def focus_banners; return $banners.reject{|q| !q.banner_units.include?(@name)}.reverse; end
  
  def alias_list(bot,event,saliases=false,justaliases=false)
    if ['Robin','Robin (shared stats)','Kris','Kris (shared stats)'].include?(@name)
      x=@name.split(' (')[0]
      x=[$units.find_index{|q| q.name=="#{x}(M)"},$units.find_index{|q| q.name=="#{x}(F)"}]
      x=x.compact.map{|q| $units[q]}
      k=$aliases.reject{|q| q[0]!='Unit' || !q[2].is_a?(Array)}
      k=k.reject{|q| !q[2].include?(x[0].id) || !q[2].include?(x[1].id)}
      k=[] if saliases
      i=1
      i=2 if ['Kris','Kris (shared stats)'].include?(@name)
      x=x.map{|q| q.alias_list(bot,event,saliases)}
      x[0].push(' ')
      x[1].push(' ')
      x.push(k.map{|q| q[1]}.reject{|q| q==@name})
      x[2].unshift("__**#{@name}#{self.emotes(bot,false)}**#{" [Pseudounit-#{i}]" if Shardizard==4 || event.user.id==167657750971547648}__")
      x.flatten!
      return x
    end
    k=$aliases.reject{|q| q[0]!='Unit' || ![@id,@name].include?(q[2])}
    k=k.reject{|q| !q[3].nil? && !q[3].include?(event.server.id)} unless event.server.nil?
    k=k.reject{|q| q[3].nil?} if saliases
    return k.map{|q| q[1]}.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')} if justaliases
    if event.server.nil?
      for i in 0...k.length
        if k[i][3].nil?
          k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")}"
        else
          f=[]
          for j in 0...k[i][3].length
            srv=(bot.server(k[i][3][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              f.push("*#{bot.server(k[i][3][j]).name}*") unless event.user.on(k[i][3][j]).nil?
            end
          end
          if f.length<=0
            k[i]=nil
          else
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (in the following servers: #{list_lift(f,'and')})" unless Shardizard==$spanishShard
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (en los siguientes servidores: #{list_lift(f,'y')})" if Shardizard==$spanishShard
          end
        end
      end
      k.compact!
    else
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[in this server only]*' unless q[3].nil? || saliases}"} unless Shardizard==$spanishShard
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[solo en este servidor]*' unless q[3].nil? || saliases}"} if Shardizard==$spanishShard
    end
    k=k.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')}
    k.unshift(@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')) unless @name==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','') || saliases
    k.unshift("__#{'Alias ​​específicos del servidor de ' if saliases && Shardizard==$spanishShard}**#{@name}#{self.emotes(bot,false)}**#{"'s server-specific aliases" if saliases && Shardizard != $spanishShard}#{" [Unit-#{longFormattedNumber(@id)}]" if Shardizard==4 || event.user.id==167657750971547648}__")
    return k
  end
end

class SuperUnit < FEHUnit # attributes shared by Dev- and Donor- Units but not included in basic units
  attr_accessor :base_unit
  attr_accessor :face
  attr_accessor :rarity,:resplendent
  attr_accessor :merge_count
  attr_accessor :boon,:bane
  attr_accessor :support,:true_support
  attr_accessor :dragonflowers
  attr_accessor :cohort
  attr_accessor :skills
  
  def rarity=(val)
    @rarity=val.to_i
    @forma=false
    @resplendent=val.gsub("#{@rarity}",'')
    if @resplendent.include?('f')
      @forma=true
      @resplendent=@resplendent.gsub('f','')
    end
  end
  
  def merge_count=(val); @merge_count=val.to_i; end
  def dragonflowers=(val); @dragonflowers=val.to_i; end
  def boon=(val); @boon=val; end
  def bane=(val); @bane=val; end
  def cohort=(val); @cohort=val; end
  def skills=(val); @skills=val.map{|q| q}; end
  def face=(val); @face=val; end
  
  def resplendent=(val)
    @resplendent='' # units without Resplendent Ascensions
    @resplendent='r' if val==true # units with Resplendent Ascensions
    @resplendent='u' if val==false # units with Resplendent Ascensions but using default art
  end
  
  def base; return @base_unit; end
  
  def equippedWeapon
    return [nil,''] if @skills.nil? || @skills.length<=0 || @skills[0].reject{|q| q.include?('~~')}.length<=0
    m=@skills[0].reject{|q| q.include?('~~')}[-1].gsub('__','').split(' (+) ')
    m[1]='' if m[1].nil?
    x=$skills.find_index{|q| q.fullName==m[0]}
    return [nil,m[1].gsub(' Mode','')] if x.nil?
    x=$skills[x]
    return [x,m[1].gsub(' Mode','')]
  end
  
  def dispSkills(bot,event,f=5,smol=false,emotes=true,zelgiused=false,explainemotes=false)
    s=@skills.map{|q| q}
    if zelgiused
      s[0]=[]
      m=s[1].map{|q| q.gsub('~~','').gsub('__','')}.reject{|q| $skills.find_index{|q2| q2.fullName==q}.nil? || !$skills[$skills.find_index{|q2| q2.fullName==q}].exclusivity.nil?}
      s[1]=s[1].reject{|q| !m.include?(q.gsub('~~','').gsub('__',''))}
      m=s[2].map{|q| q.gsub('~~','').gsub('__','')}.reject{|q| $skills.find_index{|q2| q2.fullName==q}.nil? || !$skills[$skills.find_index{|q2| q2.fullName==q}].exclusivity.nil?}
      s[2]=s[2].reject{|q| !m.include?(q.gsub('~~','').gsub('__',''))}
    end
    pos=1
    pos=2 if Shardizard==$spanishShard
    demote=['<:Hero_Duo:631431055420948480><:Hero_Harmonic:722436762248413234>',Skill_Slots[pos][7]]
    unless @duo.nil?
      demote=['<:Hero_Duo:631431055420948480>',Skill_Slots[pos][7].split('/')[0]]
      demote=['<:Hero_Harmonic:722436762248413234>',Skill_Slots[pos][7].split('/')[1]] if @duo[0][0]=='Harmonic'
      demote=['<:Hero_Duo_Mathoo:631431055513092106>',Skill_Slots[pos][7].split('/')[0]] if @name=='Mathoo'
    end
    if smol
      for i in 0...s.length
        if s[i].length<=0
          s[i]='~~none~~'
        elsif s[i].reject{|q2| q2.include?('~~')}.length<=0
          s[i]=s[i][-1].gsub('__','')
        else
          s[i]=s[i].reject{|q2| q2.include?('~~')}[-1].gsub('__','')
        end
        if i>5
        elsif @base_unit.summoned.map{|q| q.fullName}.include?(s[i].split(' (+) ')[0])
          s[i]="**#{s[i]}**"
        elsif @base_unit.skill_list.map{|q| q.fullName}.include?(s[i].split(' (+) ')[0])
          s[i]="*#{s[i]}*"
        end
        if emotes
          m=$skills.find_index{|q| q.fullName==s[i].gsub('*','')}
          s[i]="#{s[i]} <:Prf_Sparkle:490307608973148180>" if !m.nil? && !$skills[m].exclusivity.nil?
        end
        s[i]="#{Skill_Slots[0][i]} #{s[i]}"
      end
      s[0]='~~none~~' if s[0].nil? || s[0].length<=0
      unless @duo.nil?
        d=$skills.find_index{|q| has_any?(['Duo','Harmonic'],q.type) && q.exclusivity.include?(@name)}
        s.push("#{demote[0]} **#{$skills[d].name}**") unless d.nil?
      end
      return [['Skills',s.join("\n")]]
    end
    f=[]
    ftr=nil
    for i in 0...s.length
      s[i]=['~~none~~'] if s[i].length<=0 && i==6
      for i2 in 0...s[i].length
        if i>5
        elsif @base_unit.summoned.map{|q| q.fullName}.include?(s[i][i2].gsub('~~','').gsub('__','').split(' (+) ')[0])
          s[i][i2]="**#{s[i][i2]}**"
        elsif @base_unit.skill_list.map{|q| q.fullName}.include?(s[i][i2].gsub('~~','').gsub('__','').split(' (+) ')[0])
          s[i][i2]="*#{s[i][i2]}*"
        end
        if emotes
          m=$skills.find_index{|q| q.fullName==s[i][i2].gsub('*','').gsub('~~','').gsub('__','')}
          if !m.nil? && !$skills[m].exclusivity.nil?
            s[i][i2]="#{s[i][i2]} <:Prf_Sparkle:490307608973148180>"
            ftr='Purple sparkles mark skills Prf to this unit.' if explainemotes
            ftr='Los destellos morados indican habilidades exclusivas de este personaje.' if explainemotes && Shardizard==$spanishShard
          end
        end
      end
      f.push(["#{Skill_Slots[0][i]} #{Skill_Slots[pos][i]}",s[i].join("\n")])
    end
    unless @duo.nil? || $skills.find_index{|q| has_any?(['Duo','Harmonic'],q.type) && q.exclusivity.include?(@name)}.nil?
      d=$skills[$skills.find_index{|q| has_any?(['Duo','Harmonic'],q.type) && q.exclusivity.include?(@name)}]
      f.push(["#{demote.join(' ')} Skill","**#{d.name}**#{"\n#{d.description}" if safe_to_spam?(event)}",1])
      f[-1][0]="#{demote[0]}Habilidad #{demote[1]}" if Shardizard==$spanishShard
      f[-1][2]=nil unless safe_to_spam?(event)
    end
    f.push(ftr) unless ftr.nil?
    return f
  end
  
  def score(bot,level=40,f=5,f2='',f3='',f4=0,f5=0,f6='',bonus='',blessing=[],f7=false,f8=nil,f9='',skill_list=[])
    r=false
    r=true if !@resplendent.nil? && @resplendent.length>0
    y=self.equippedWeapon
    sp=0
    unless @skills.nil? || @skills.length<=0
      s=@skills[1,@skills.length-1].map{|q| q.reject{|q2| q2.include?('~~')}}.reject{|q| q.length<=0}.map{|q| q[-1]}
      for i in 0...s.length
        x=$skills.find_index{|q| q.fullName==s[i]}
        sp+=$skills[x].sp_cost unless x.nil?
      end
    end
    sp/=100
    sp+=super(bot,level,@rarity,@boon,@bane,@merge_count,@dragonflowers,@support,bonus,blessing,r,y[0],y[1],skill_list)
    return sp
  end
  
  def starHeader2(bot,ignorenature=true,f=5,f2='',f3='',f4=0,f5=0,f6='',bonus='',blessing=[],f7=false,f8=nil,f9='',transformed=false,skill_list=[],skill_list_2=[],wpnlegal=true,pairup=false,expanded_mode=1)
    b=[@boon.gsub(' ',''),@bane.gsub(' ','')]
    b=['',''] if ignorenature
    return @base_unit.starHeader(bot,@rarity,b[0],b[1],@merge_count,@dragonflowers,@support,'',[],false,nil,'',false,[],[],true,false,1,@owner)
  end
  
  def skill_list(f=5); return $skills.reject{|q| !@skills.map{|q2| q2.gsub('~~','').gsub('__','')}.include?(q.fullName)}; end
  def summoned(f=5); return $skills.reject{|q| !@skills.map{|q2| q2.gsub('__','')}.include?(q.fullName)}; end
  
  def statGrid(bot,f=5,f2='',f3='',f4=0,f5=0,f6='',bonus='',blessing=[],f7=false,f8=nil,f9='',transformed=false,skill_list=[],pairup=false,lvl=40)
    r=false
    r=true if !@resplendent.nil? && @resplendent.length>0
    y=self.equippedWeapon
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}.map{|q| q[0]}
    sl=skill_list.reject{|q| lookout.include?(q)}
    unless @skills.nil? || @skills.length<=3 || @skills[3].reject{|q| q.include?('~~')}.length<=0
      m=@skills[3].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    unless @skills.nil? || @skills.length<=6 || @skills[6].reject{|q| q.include?('~~')}.length<=0
      m=@skills[6].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    return super(bot,@rarity,@boon,@bane,@merge_count,@dragonflowers,@support,bonus,blessing,r,y[0],y[1],transformed,sl,pairup,lvl)
  end
  
  def statList(bot,includegrowths=false,diff=[0,0,0,0,0],rarity=5,boon='',bane='',merges=0,flowers=0,support='',bonus='',blessing=[],resp=false,weapon=nil,refne='',transformed=false,skill_list=[],skill_list_2=[],wpnlegal=true,pairup=false,lvl=40)
    r=false
    r=true if !@resplendent.nil? && @resplendent.length>0
    y=self.equippedWeapon
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}.map{|q| q[0]}
    sl=skill_list.reject{|q| lookout.include?(q)}
    unless @skills.nil? || @skills.length<=3 || @skills[3].reject{|q| q.include?('~~')}.length<=0
      m=@skills[3].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    unless @skills.nil? || @skills.length<=6 || @skills[6].reject{|q| q.include?('~~')}.length<=0
      m=@skills[6].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    return super(bot,includegrowths,diff,@rarity,@boon,@bane,@merge_count,@dragonflowers,@support,bonus,blessing,r,y[0],y[1],transformed,sl,skill_list_2,true,pairup,lvl)
  end
  
  def creation_string(bot)
    return @base_unit.starDisplay(bot,@rarity,@boon.gsub(' ',''),@bane.gsub(' ',''),@merge_count,@dragonflowers)
  end
  
  def storage_string
    x="#{@name}"
    x="#{x}\\#{@face}\\#{@weapon.join(', ')}" if @name=='Kiran' && !@face.nil?
    x="#{x}\n#{@rarity}#{@resplendent}#{'f' if @forma}"
    x="#{x}\\#{@merge_count}"
    x="#{x}\\#{@boon.gsub(' ','')}"
    x="#{x}\\#{@bane.gsub(' ','')}"
    x="#{x}\\#{@true_support}"
    x="#{x}\\#{@dragonflowers}"
    x="#{x}\\#{@cohort}" unless @cohort.nil?
    for i in 0...@skills.length
      x="#{x}\n#{@skills[i].join("\\")}"
    end
    return x
  end
end

class DevUnit < SuperUnit
  def initialize(val,rar=0)
    @name=val
    if val.include?('\\'[0])
      val=val.split('\\'[0])
      @name=val[0]
      @face=val[1]
      val=val.join('\\'[0])
    end
    u=$units.find_index{|q| q.name==val.split('\\'[0])[0]}
    @base_unit=$units[u].clone
    if rar>0
      @rarity=rar
      lrn=@base_unit.skill_list(5).map{|q| q.clone}
      smn=@base_unit.summoned(rar).map{|q| q.clone}
      wpn=lrn.reject{|q| !q.type.include?('Weapon')}
      retroprf=wpn[-1].clone
      retroprf=nil if retroprf.exclusivity.nil? || !(retroprf.prerequisite.nil? || retroprf.prerequisite.length<=0)
      wpn.pop unless retroprf.nil?
      if !wpn[-1].refine.nil? && !wpn[-1].refine.overrides.find_index{|q| q[0]=='Effect'}.nil?
        wpn.push(wpn[-1].clone)
        wpn[-1].name="#{wpn[-1].name} (+) Effect Mode"
      elsif !wpn[-1].evolutions.nil? && wpn[-1].evolutions.length>0
        s=$skills.find_index{|q| q.fullName==wpn[-1].evolutions[0]}
        wpn.push($skills[s].clone) unless s.nil?
        if !wpn[-1].refine.nil? && !wpn[-1].refine.overrides.find_index{|q| q[0]=='Effect'}.nil?
          wpn.push(wpn[-1].clone)
          wpn[-1].name="#{wpn[-1].name} (+) Effect Mode"
        end
      end
      unless retroprf.nil?
        wpn[-1].name="__#{wpn[-1].name}__"
        wpn.push(retroprf.clone) unless retroprf.nil?
      end
      for i in 0...wpn.length
        wpn[i].name="~~#{wpn[i].name}~~" unless smn.map{|q| q.name}.include?(wpn[i].name.gsub('__',''))
      end
      lrn=lrn.reject{|q| q.type.include?('Weapon')}
      for i in 0...lrn.length
        lrn[i].name="#{lrn[i].fullName}"
        lrn[i].name="~~#{lrn[i].name}~~" unless smn.map{|q| q.fullName}.include?(lrn[i].fullName) || lrn[i].name.include?('~~')
      end
      lrn[i].id+=50000 if lrn[i].nil? && lrn[i].type.include?('Special') && lrn[i].id<210000
      if lrn[i].id<0
        lrn[i].id=0-lrn[i].id
        if lrn[i].id>=300000
          lrn[i].id+=90000
        elsif lrn[i].id>=100000
          lrn[i].id+=9000
        else
          lrn[i].id+=4000
        end
      end
      @skills=[wpn.map{|q| q.name},lrn.reject{|q| !q.type.include?('Assist')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name},
              lrn.reject{|q| !q.type.include?('Special')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name},
              lrn.reject{|q| !q.type.include?('Passive(A)')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name},
              lrn.reject{|q| !q.type.include?('Passive(B)')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name},
              lrn.reject{|q| !q.type.include?('Passive(C)')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name}]
      for i in 0...@skills.length
        @skills[i]=['~~none~~'] if @skills[i].length<=0
      end
      @skills.push([])
    end
    if val.include?('\\'[0]) && val.split('\\'[0]).length>2
      @weapon=val.split('\\'[0])[2].split(', ')
    else
      @weapon=@base_unit.weapon.map{|q| q}
    end
    @movement="#{@base_unit.movement}"
    @growths=@base_unit.growths.map{|q| q}
    @stats40=@base_unit.stats40.map{|q| q}
    @stats1=@base_unit.stats1.map{|q| q}
    @artist=@base_unit.artist.map{|q| q} unless @base_unit.artist.nil?
    if @name=='Alm(Saint)' && !@artist.nil?
      u2=$units.find_index{|q| q.name=='Sakura'}
      @artist[0]="#{@artist[0]}\n*Smol contribution from:* #{$units[u2].artist[0]}" unless u2.nil? || Shardizard==$spanishShard
      @artist[0]="#{@artist[0]}\n*Pequeña contribución de:* #{$units[u2].artist[0]}" unless u2.nil? || Shardizard != $spanishShard
    elsif @name=='Kiran' && @face=='Mathoo'
      h=[]
      u2=$units.find_index{|q| q.name=='Sakura'}
      h.push("#{$units[u2].artist[0]}") unless u2.nil?
      u2=$units.find_index{|q| q.name=='Bernie'}
      h.push("#{$units[u2].artist[0]}") unless u2.nil?
      u2=$units.find_index{|q| q.name=='Mirabilis'}
      h.push("#{$units[u2].artist[0]}") unless u2.nil?
      @artist[0]="#{@artist[0]}\n*Smol contributions from:* #{list_lift(h.uniq,'and')}" unless h.length<=0 || Shardizard==$spanishShard
      @artist[0]="#{@artist[0]}\n*Pequeña contribución de:* #{list_lift(h.uniq,'y')}" if h.length>0 && Shardizard==$spanishShard
    end
    @voice_na=@base_unit.voice_na.map{|q| q} unless @base_unit.voice_na.nil?
    @voice_jp=@base_unit.voice_jp.map{|q| q} unless @base_unit.voice_jp.nil?
    @id=@base_unit.id*1
    @availability=@base_unit.availability.map{|q| q} unless @base_unit.availability.nil?
    @gender="#{@base_unit.gender}" unless @base_unit.gender.nil?
    @games=@base_unit.games.map{|q| q} unless @base_unit.games.nil?
    @alts=@base_unit.alts.map{|q| q} unless @base_unit.alts.nil?
    @fake=@base_unit.fake.map{|q| q} unless @base_unit.fake.nil?
    @legendary=@base_unit.legendary.map{|q| q} unless @base_unit.legendary.nil?
    @duo=@base_unit.duo.map{|q| q} unless @base_unit.duo.nil?
    @owner='Mathoo'
  end
  
  def support_load(val,f2p=true)
    @true_support=val
    @support=val.gsub('(','').gsub(')','')
    @support='-' if val.include?('(') && f2p
  end
  
  def disp_color(chain=0,mode=0)
    f=super(-1,mode).map{|q| q}
    f.unshift(0x00DAFA)
    f.unshift(0xFFABAF) if self.sortPriority>49
    xcolor=f[chain]
    xcolor=f[0] if chain>=f.length || chain<0
    return [xcolor/256/256, (xcolor/256)%256, xcolor%256] if mode==1 # in mode 1, return as three single-channel numbers - used when averaging colors
    return xcolor
  end
  
  def thumbnail(event,bot,resp=false)
    dd=@name.gsub(' ','_')
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/Face_FC_Mathoo.png" if ['Alm(Saint)'].include?(@name) || self.sortPriority>49
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{dd}/#{@face}/Face_FC.png" if @name=='Kiran' && !@face.nil?
    x=false
    x=true if @resplendent.downcase=='r'
    return super(event,bot,x)
  end
  
  def emotes(bot,includebonus=true,includeresp=false,forceheart=false)
    x=super(bot,false)
    y=super(bot,includebonus).gsub(x,'')
    x="#{x}<:Resplendent_Ascension:678748961607122945>" if !@resplendent.nil? && @resplendent.length>0 && includeresp
    x="#{x}<:Icon_Support_Cyan:497430896249405450>"
    x="#{x}<:Icon_Support:448293527642701824>" if ['Sakura','Bernie','Mirabilis'].include?(@name)
    x="#{x}#{y}"
    return x
  end
  
  def submotes(bot,forceheart=false)
    x='<:Icon_Support_Cyan:497430896249405450>'
    x="#{x}<:Icon_Support:448293527642701824>" if self.sortPriority>39
    return x
  end
  
  def starDisplay(bot,f=5,f2='',f3='',f4=0,f5=0)
    x=super(bot,@rarity,@boon.gsub(' ',''),@bane.gsub(' ',''),@merge_count,@dragonflowers)
    if @support=='-' && @rarity>=5 && @merge_count>=Max_rarity_merge[1]
      x=x.gsub(Rarity_stars[0][@rarity-1],'<:FEH_rarity_Mp10:577779126853959681>')
      x=x.gsub(Rarity_stars[1][@rarity-1],'<:FEH_rarity_Mp10:577779126853959681>')
    elsif @support=='-'
      x=x.gsub(Rarity_stars[0][@rarity-1],'<:FEH_rarity_M:577779126891577355>')
      x=x.gsub(Rarity_stars[1][@rarity-1],'<:FEH_rarity_M:577779126891577355>')
    elsif @rarity>=5 && @merge_count>=Max_rarity_merge[1]
      x=x.gsub(Rarity_stars[0][@rarity-1],'<:Icon_Rarity_Sp10:448272715653054485>')
      x=x.gsub(Rarity_stars[1][@rarity-1],'<:Icon_Rarity_Sp10:448272715653054485>')
    else
      x=x.gsub(Rarity_stars[0][@rarity-1],'<:Icon_Rarity_S:448266418035621888>')
      x=x.gsub(Rarity_stars[1][@rarity-1],'<:Icon_Rarity_S:448266418035621888>')
    end
    return x
  end
  
  def starHeader(bot,f=5,f2='',f3='',f4=0,f5=0,f6='',bonus='',blessing=[],f7=false,f8=nil,f9='',transformed=false,skill_list=[],skill_list_2=[],wpnlegal=true,pairup=false,expanded_mode=1,owner='')
    r=false
    r=true if !@resplendent.nil? && @resplendent.length>0
    y=self.equippedWeapon
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}.map{|q| q[0]}
    sl=skill_list.reject{|q| lookout.include?(q)}
    unless @skills.nil? || @skills.length<=3 || @skills[3].reject{|q| q.include?('~~')}.length<=0
      m=@skills[3].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    unless @skills.nil? || @skills.length<=6 || @skills[6].reject{|q| q.include?('~~')}.length<=0
      m=@skills[6].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    bonus='' if bonus=='Enemy'
    x=super(bot,@rarity,@boon.gsub(' ',''),@bane.gsub(' ',''),@merge_count,@dragonflowers,@support,bonus,blessing,r,y[0],y[1],transformed,sl,skill_list_2,true,pairup,expanded_mode)
    if pairup && !@cohort.nil? && !$dev_units.find_index{|q| q.name==@cohort}.nil?
      m=$dev_units[$dev_units.find_index{|q| q.name==@cohort}]
      x=x.split("\n")
      l=1
      l=4 if expanded_mode==2
      l+=1 if r
      d='Pair-up cohort'
      d='Pocket companion' if ['Sakura','Bernie','Mirabilis'].include?(m.alts[0]) && @gender=='M'
      if Shardizard==$spanishShard
        d='Cohorte de Agrupar'
        d='Compañera de bolsillo' if ['Sakura','Bernie','Mirabilis'].include?(m.alts[0]) && @gender=='M'
      end
      x="#{x[0,l].join("\n")}\n*#{d}:* #{m.name}#{m.emotes(bot,false)}\n#{x[l,x.length-l].join("\n")}"
    end
    return x
  end
  
  def dispStats(bot,level=40,f=5,f2='',f3='',f4=0,f5=0,f6='',bonus='',blessing=[],f7=false,f8=nil,f9='',transformed=false,skill_list=[],pairup=false)
    r=false
    r=true if !@resplendent.nil? && @resplendent.length>0
    y=self.equippedWeapon
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}.map{|q| q[0]}
    sl=skill_list.reject{|q| lookout.include?(q)}
    unless @skills.nil? || @skills.length<=3 || @skills[3].reject{|q| q.include?('~~')}.length<=0
      m=@skills[3].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    unless @skills.nil? || @skills.length<=5 || @skills[5].reject{|q| q.include?('~~')}.length<=0
      m=@skills[5].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m) && m.include?('Rouse ')
    end
    unless @skills.nil? || @skills.length<=6 || @skills[6].reject{|q| q.include?('~~')}.length<=0
      m=@skills[6].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    bonus='' if bonus=='Enemy'
    x=super(bot,level,@rarity,@boon,@bane,@merge_count,@dragonflowers,@support,bonus,blessing,r,y[0],y[1],transformed,sl)
    if pairup && !@cohort.nil? && !$dev_units.find_index{|q| q.name==@cohort}.nil?
      m=$dev_units[$dev_units.find_index{|q| q.name==@cohort}]
      m=m.dispStats(bot,level,m.rarity,m.boon,m.bane,m.merge_count,m.dragonflowers,m.support,'',[],nil,'',transformed,[])
      x[1]+=[[(m[1]-25)/10,4].min,0].max
      x[2]+=[[(m[2]-10)/10,4].min,0].max
      x[3]+=[[(m[3]-10)/10,4].min,0].max
      x[4]+=[[(m[4]-10)/10,4].min,0].max
    end
    return x
  end
end

class DonorUnit < SuperUnit
  attr_accessor :owner_id
  attr_accessor :color_name,:color_tag
  
  def initialize(val,rar=0,owner='',ownerid=0)
    @name=val
    if val.include?('\\'[0])
      val=val.split('\\'[0])
      @name=val[0]
      @face=val[1]
      val=val.join('\\'[0])
    end
    u=$units.find_index{|q| q.name==val.split('\\'[0])[0]}
    @base_unit=$units[u].clone
    if rar>0
      @rarity=rar
      lrn=@base_unit.skill_list(5).map{|q| q.clone}
      smn=@base_unit.summoned(rar).map{|q| q.clone}
      wpn=lrn.reject{|q| !q.type.include?('Weapon')}
      retroprf=wpn[-1].clone
      retroprf=nil if retroprf.exclusivity.nil? || !(retroprf.prerequisite.nil? || retroprf.prerequisite.length<=0)
      wpn.pop unless retroprf.nil?
      if !wpn[-1].refine.nil? && !wpn[-1].refine.overrides.find_index{|q| q[0]=='Effect'}.nil?
      elsif !wpn[-1].evolutions.nil? && wpn[-1].evolutions.length>0
        s=$skills.find_index{|q| q.fullName==wpn[-1].evolutions[0]}
        wpn.push($skills[s].clone) unless s.nil?
      end
      unless retroprf.nil?
        wpn[-1].name="__#{wpn[-1].name}__"
        wpn.push(retroprf.clone) unless retroprf.nil?
      end
      for i in 0...wpn.length
        wpn[i].name="~~#{wpn[i].name}~~" unless smn.map{|q| q.name}.include?(wpn[i].name.gsub('__',''))
      end
      for i in 0...lrn.length
        lrn[i].name="#{lrn[i].fullName}"
        lrn[i].name="~~#{lrn[i].name}~~" unless smn.map{|q| q.fullName}.include?(lrn[i].fullName) || lrn[i].name.include?('~~')
      end
      lrn[i].id+=50000 if lrn[i].nil? && lrn[i].type.include?('Special') && lrn[i].id<210000
      if lrn[i].id<0
        lrn[i].id=0-lrn[i].id
        if lrn[i].id>=300000
          lrn[i].id+=90000
        elsif lrn[i].id>=100000
          lrn[i].id+=9000
        else
          lrn[i].id+=4000
        end
      end
      @skills=[wpn.map{|q| q.name},lrn.reject{|q| !q.type.include?('Assist')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name},
              lrn.reject{|q| !q.type.include?('Special')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name},
              lrn.reject{|q| !q.type.include?('Passive(A)')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name},
              lrn.reject{|q| !q.type.include?('Passive(B)')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name},
              lrn.reject{|q| !q.type.include?('Passive(C)')}.sort{|a,b| a.id<=>b.id}.map{|q| q.name}]
      for i in 0...@skills.length
        @skills[i]=['~~none~~'] if @skills[i].length<=0
      end
      @skills.push([])
    end
    if val.include?('\\'[0]) && val.split('\\'[0]).length>2
      @weapon=val.split('\\'[0])[2].split(', ')
    else
      @weapon=@base_unit.weapon.map{|q| q}
    end
    @movement="#{@base_unit.movement}"
    @growths=@base_unit.growths.map{|q| q}
    @stats40=@base_unit.stats40.map{|q| q}
    @stats1=@base_unit.stats1.map{|q| q}
    @artist=@base_unit.artist.map{|q| q} unless @base_unit.artist.nil?
    @voice_na=@base_unit.voice_na.map{|q| q} unless @base_unit.voice_na.nil?
    @voice_jp=@base_unit.voice_jp.map{|q| q} unless @base_unit.voice_jp.nil?
    @id=@base_unit.id*1
    @availability=@base_unit.availability.map{|q| q} unless @base_unit.availability.nil?
    @gender="#{@base_unit.gender}" unless @base_unit.gender.nil?
    @games=@base_unit.games.map{|q| q} unless @base_unit.games.nil?
    @alts=@base_unit.alts.map{|q| q} unless @base_unit.alts.nil?
    @fake=@base_unit.fake.map{|q| q} unless @base_unit.fake.nil?
    @legendary=@base_unit.legendary.map{|q| q} unless @base_unit.legendary.nil?
    @duo=@base_unit.duo.map{|q| q} unless @base_unit.duo.nil?
    owner=owner.split('\\'[0])
    @owner=owner[0]
    @color_tag=owner[1].hex
    @color_name=owner[2]
    @owner_id=ownerid
  end
  
  def support=(val); @support=val.gsub('-',''); @true_support=val.gsub('-',''); end
  
  def disp_color(chain=0,mode=0)
    f=super(-1,mode).map{|q| q}
    f.unshift(@color_tag) if get_donor_list().reject{|q| q[2][0]<5}.map{|q| q[0]}.include?(@owner_id)
    xcolor=f[chain]
    xcolor=f[0] if chain>=f.length || chain<0
    return [xcolor/256/256, (xcolor/256)%256, xcolor%256] if mode==1 # in mode 1, return as three single-channel numbers - used when averaging colors
    return xcolor
  end
  
  def thumbnail(event,bot,resp=false)
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHArt/#{@name}/#{@face}/Face_FC.png" if @name=='Kiran' && !@face.nil?
    x=false
    x=true if @resplendent.downcase=='r'
    return super(event,bot,x)
  end
  
  def emotes(bot,includebonus=true,includeresp=false,forceheart=false)
    x=super(bot,false)
    y=super(bot,includebonus,includeresp,forceheart).gsub(x,'')
    x="#{x}<:Resplendent_Ascension:678748961607122945>" if !@resplendent.nil? && @resplendent.length>0 && includeresp
    x="#{x}#{self.submotes(bot,forceheart)}#{y}"
    return x
  end
  
  def submotes(bot,forceheart=false)
    x=''
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "Icon_Support_#{@color_name}"}
    if get_donor_list().reject{|q| q[2][0]<5}.map{|q| q[0]}.include?(@owner_id)
      x=moji[0].mention unless moji.length<=0
      x="#{x}<:Icon_Support:448293527642701824>" unless @support.nil? || @support.length<=0 || @support=='-'
    elsif forceheart
      x=moji[0].mention unless moji.length<=0
    end
    return x
  end
  
  def starDisplay(bot,f=5,f2='',f3='',f4=0,f5=0)
    x=super(bot,@rarity,@boon.gsub(' ',''),@bane.gsub(' ',''),@merge_count,@dragonflowers)
    if @rarity>=5 && @merge_count>=Max_rarity_merge[1]
      x=x.gsub(Rarity_stars[0][@rarity-1],'<:Icon_Rarity_Sp10:448272715653054485>')
      x=x.gsub(Rarity_stars[1][@rarity-1],'<:Icon_Rarity_Sp10:448272715653054485>')
    else
      x=x.gsub(Rarity_stars[0][@rarity-1],'<:Icon_Rarity_S:448266418035621888>')
      x=x.gsub(Rarity_stars[1][@rarity-1],'<:Icon_Rarity_S:448266418035621888>')
    end
    return x
  end
  
  def starHeader(bot,f=5,f2='',f3='',f4=0,f5=0,f6='',bonus='',blessing=[],f7=false,f8=nil,f9='',transformed=false,skill_list=[],skill_list_2=[],wpnlegal=true,pairup=false,expanded_mode=1,owner='')
    r=false
    r=true if !@resplendent.nil? && @resplendent.length>0
    y=self.equippedWeapon
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}.map{|q| q[0]}
    sl=skill_list.reject{|q| lookout.include?(q)}
    unless @skills.nil? || @skills.length<=3 || @skills[3].reject{|q| q.include?('~~')}.length<=0
      m=@skills[3].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    unless @skills.nil? || @skills.length<=6 || @skills[6].reject{|q| q.include?('~~')}.length<=0
      m=@skills[6].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    bonus='' if bonus=='Enemy'
    x=super(bot,@rarity,@boon.gsub(' ',''),@bane.gsub(' ',''),@merge_count,@dragonflowers,@support,bonus,blessing,r,y[0],y[1],transformed,sl,skill_list_2,true,pairup,expanded_mode)
    if pairup && !@cohort.nil? && !$dev_units.find_index{|q| q.name==@cohort && q.owner_id==@owner_id}.nil?
      m=$donor_units[$donor_units.find_index{|q| q.name==@cohort && q.owner_id==@owner_id}]
      x=x.split("\n")
      l=1
      l=4 if expanded_mode==2
      l+=1 if r
      x="#{x[0,l].join("\n")}\n*Pair-up cohort:* #{m.name}#{m.emotes(bot,false)}\n#{x[l,x.length-l].join("\n")}"
    end
    return x
  end
  
  def dispStats(bot,level=40,f=5,f2='',f3='',f4=0,f5=0,f6='',bonus='',blessing=[],f7=false,f8=nil,f9='',transformed=false,skill_list=[],pairup=false)
    r=false
    r=true if !@resplendent.nil? && @resplendent.length>0
    y=self.equippedWeapon
    lookout=$statskills.reject{|q| !['Stat-Affecting 1','Stat-Affecting 2'].include?(q[3])}.map{|q| q[0]}
    sl=skill_list.reject{|q| lookout.include?(q)}
    unless @skills.nil? || @skills.length<=3 || @skills[3].reject{|q| q.include?('~~')}.length<=0
      m=@skills[3].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    unless @skills.nil? || @skills.length<=5 || @skills[5].reject{|q| q.include?('~~')}.length<=0
      m=@skills[5].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m) && m.include?('Rouse ')
    end
    unless @skills.nil? || @skills.length<=6 || @skills[6].reject{|q| q.include?('~~')}.length<=0
      m=@skills[6].reject{|q| q.include?('~~')}[-1]
      sl.push(m) if lookout.include?(m)
    end
    bonus='' if bonus=='Enemy'
    x=super(bot,level,@rarity,@boon,@bane,@merge_count,@dragonflowers,@support,bonus,blessing,r,y[0],y[1],transformed,sl)
    if pairup && !@cohort.nil? && !$donor_units.find_index{|q| q.name==@cohort && q.owner_id==@owner_id}.nil?
      m=$donor_units[$donor_units.find_index{|q| q.name==@cohort && q.owner_id==@owner_id}]
      m=m.dispStats(bot,level,m.rarity,m.boon,m.bane,m.merge_count,m.dragonflowers,m.support,'',[],nil,'',transformed,[])
      x[1]+=[[(m[1]-25)/10,4].min,0].max
      x[2]+=[[(m[2]-10)/10,4].min,0].max
      x[3]+=[[(m[3]-10)/10,4].min,0].max
      x[4]+=[[(m[4]-10)/10,4].min,0].max
    end
    return x
  end
end

class FEHSkill
  attr_accessor :id,:name,:level
  attr_accessor :tome_tree
  attr_accessor :sp_cost
  attr_accessor :might,:range
  attr_accessor :shard_color
  attr_accessor :type
  attr_accessor :restrictions,:exclusivity
  attr_accessor :weapon_stats,:weapon_gain
  attr_accessor :description,:dagger_debuff,:dagger_buff
  attr_accessor :prerequisite
  attr_accessor :summon,:learn
  attr_accessor :tags
  attr_accessor :evolutions
  attr_accessor :heal
  attr_accessor :refine
  attr_accessor :fake
  attr_accessor :sort_data
  
  def initialize(val)
    @name=val
    @sp_cost=0
    @type=[]
    @description=''
    @tags=[]
  end
  
  def id=(val); @id=val; end
  def name=(val); @name=val; end
  def sp_cost=(val); @sp_cost=val.to_i; end
  def might=(val); @might=val.to_i; end
  def type=(val); @type=val.split(', '); end
  def restrictions=(val); @restrictions=val.split(', '); end
  def exclusivity=(val); @exclusivity=nil; @exclusivity=val.split(', ') unless val.nil?; end
  def tags=(val); @tags=val.split(', '); end
  def evolutions=(val); @evolutions=val.split(', '); end
  def fake=(val); @fake=val unless val.nil? || val.length<=0; end
  def refine=(val); @refine=FEHRefine.new(val,self) unless val.nil? || val.length<=0 || !@type.include?('Weapon'); end
  def objt; return 'Skill'; end
  
  def prerequisite=(val)
    if val.include?('*, *')
      x=val.split(', ')
      x[-1]=x[-1].gsub('or ','')
      @prerequisite=x.map{|q| q.gsub('*','')}
    else
      @prerequisite=val.split(' or ').map{|q| q.gsub('*','')}
    end
  end
  
  def level=(val)
    if val.nil? || val.length<=0 || val=='-'
    elsif @type.include?('Weapon')
      @tome_tree=val
    else
      @level=val
    end
  end
  
  def range=(val)
    if val.nil? || val.length<=0
    elsif has_any?(['Weapon','Assist'],@type)
      @range=val.to_i
    elsif has_any?(['Special'],@type)
      @range=val.gsub('n',"\n")
    else
      x=val.split(' ')
      for i in 1...x.length
        x[i]=x[i].to_i
      end
      @shard_color=x.map{|q| q}
    end
  end
  
  def isPostable?(event)
    return true if @fake.nil?
    return false if event.server.nil?
    g=[nil]
    for i in 0...$server_markers.length
      g.push($server_markers[i][0]) if event.server.id==$server_markers[i][1]
      g.push($server_markers[i][0].downcase) if event.server.id==$server_markers[i][1]
    end
    g.push('X') if $x_markers.include?(event.server.id)
    g.push('x') if $x_markers.include?(event.server.id)
    return has_any?(g,@fake.chars)
  end
  
  def weapon_stats=(val)
    if val.nil? || val.length<=0
    elsif @type.include?('Weapon')
      @weapon_stats=val.split(',').map{|q| q.to_i}
    else
      @weapon_gain=val.split(', ')
    end
  end
  
  def disp_weapon_stats(vals=false,transformed=false)
    return nil if @weapon_stats.nil?
    if transformed
      x=@weapon_stats.map{|q| q}
      for i in 0...5
        x[i]+=x[i+5]
      end
      return x[0,5] if vals
      return x[0,5].map{|q| "#{'+' if q>0}#{q}"}.join('/')
    else
      return @weapon_stats[0,5] if vals
      return @weapon_stats[0,5].map{|q| "#{'+' if q>0}#{q}"}.join('/')
    end
  end
  
  def description=(val)
    if val.nil? || val.length<=0 || val=='-'
      @dexcription=''
    elsif @type.include?('Weapon') && @restrictions.include?('Dagger Users Only')
      x=val.split(' *** ')
      @description=x[0]
      @dagger_debuff=x[1].split(', ') unless x[1].nil?
      @dagger_buff=x[2].split(', ') unless x[2].nil?
    else
      @description=val
    end
  end
  
  def evolutions=(val)
    if val.nil? || val.length<=0
    elsif @type.include?('Weapon')
      @evolutions=val.split(', ')
    elsif @type.include?('Assist') && @restrictions.include?('Staff Users Only')
      @heal=val
    end
  end
  
  def summon=(val)
    x=val.split('; ').map{|q| q.split(', ')}
    for i in 0...x.length
      x[i]=[] if x[i][0]=='-'
    end
    @summon=x
  end
  
  def learn=(val)
    x=val.split('; ').map{|q| q.split(', ')}
    for i in 0...x.length
      x[i]=[] if x[i][0]=='-'
    end
    @learn=x
  end
  
  def isPassive?
    return true if ['Passive(A)','Passive(B)','Passive(C)','Passive(S)','Passive(W)','Seal'].include?(@type[0])
    return false
  end

  def disp_color(chain=0)
    return 0x40C0F0 if chain>10 && @type.include?('Assist')
    return 0xF4728C if chain%10>2 && @type.include?('Passive(W)')
    if chain%10>1
      return 0x688C68 if @type.include?('Weapon') && !@refine.nil?
      return 0xF7ED70 if has_any?(@type,['Seal','Passive(S)'])
      return 0xF4728C if @type.include?('Passive(W)')
    end
    if chain%10>0
      return 0xE22141 if has_any?(@restrictions,['Sword Users Only','Red Tome Users Only']) || (@tags.include?('Red') && !has_any?(@tags,['Blue','Green','Colorless']))
      return 0x2764DE if has_any?(@restrictions,['Lance Users Only','Blue Tome Users Only']) || (@tags.include?('Blue') && !has_any?(@tags,['Red','Green','Colorless']))
      return 0x09AA24 if has_any?(@restrictions,['Axe Users Only','Green Tome Users Only']) || (@tags.include?('Green') && !has_any?(@tags,['Blue','Red','Colorless']))
      return 0x64757D if has_any?(@restrictions,['Rod Users Only','Colorless Tome Users Only']) || (@tags.include?('Colorless') && !has_any?(@tags,['Blue','Green','Red']))
      return 0x688C68 if @type.include?('Weapon') && !@refine.nil?
      return 0x6C673A if @type.include?('Weapon')
      return 0xED888A if @type.include?('Passive(A)')
      return 0x5CC4EF if @type.include?('Passive(B)')
      return 0x5FED96 if @type.include?('Passive(C)')
      return 0xF7ED70 if has_any?(@type,['Seal','Passive(S)'])
      return 0xF4728C if @type.include?('Passive(W)')
    end
    return 0xF4728C if @type.include?('Weapon')
    return 0x07DFBB if @type.include?('Assist')
    return 0xF67EF8 if @type.include?('Special')
    return 0xFDDC7E if self.isPassive?
    return 0x076F85 if @type.include?('Duo') && @exclusivity.include?('Mathoo')
    return 0xB2C604 if @type.include?('Duo')
    return 0xC0EEB6 if @type.include?('Harmonic')
    return 0xFFD800
  end
  
  def weapon_class
    return nil unless @type.include?('Weapon')
    return 'Summon Gun' if @restrictions.include?('Summon Gun Users Only')
    return 'Multiplex' if ['Missiletainn','Umbra Burst'].include?(@name)
    return 'Sword (Red Blade)' if @restrictions.include?('Sword Users Only')
    return 'Lance (Blue Blade)' if @restrictions.include?('Lance Users Only')
    return 'Axe (Green Blade)' if @restrictions.include?('Axe Users Only')
    return 'Rod (Colorless Blade)' if @restrictions.include?('Rod Users Only')
    return 'Breath (Dragon)' if @restrictions.include?('Dragons Only')
    return 'Beast Damage' if @restrictions.include?('Beasts Only')
    return 'Bow' if @restrictions.include?('Bow Users Only')
    return 'Dagger' if @restrictions.include?('Dagger Users Only')
    return 'Staff' if @restrictions.include?('Staff Users Only')
    return "#{@tome_tree} Magic (#{@restrictions[0].gsub(' Users Only','')})" if @restrictions[0].include?(' Tome Users Only')
    return nil
  end
  
  def weapon_color
    return nil unless @type.include?('Weapon')
    return 'Gold' if has_any?(@restrictions,['Dragons Only','Beasts Only','Bow Users Only','Dagger Users Only'])
    x=[]
    x.push('Red') if @tags.include?('Red')
    x.push('Blue') if @tags.include?('Blue')
    x.push('Green') if @tags.include?('Green')
    x.push('Colorless') if @tags.include?('Colorless')
    return 'Gold' if x.length>1
    return x[0]
  end
  
  def mcr
    x=[]
    x.push('**Scale:** 1/12') if @name=='Liliputia'
    x.push('**Scale:** 12/1') if @name=='Brobdingo'
    x.push("**Might:** #{@might}") if @type.include?('Weapon') && !['Missiletainn','Umbra Burst'].include?(@name) && !@might.nil? && @might>0
    x.push("**Cooldown:** #{@might}") if has_any?(@type,['Special','Duo','Harmonic']) && !@might.nil? && @might>0
    x.push("**Range:** #{@range}") if has_any?(@type,['Weapon','Assist']) && !@range.nil? && @range>0
    return x.join("  \u200B  \u200B  \u200B  ")
  end
  
  def eff_against(refine='',ignorefollow=false,event=nil)
    return '' unless @type.include?('Weapon')
    f=[]
    f.push('<:Icon_Move_Flier:443331186698354698>') if @restrictions.include?('Bow Users Only') && !@tags.include?('UnBow')
    lookout=$skilltags.reject{|q| q[2]!='Weapon' || q[3].nil?}
    for i in 0...lookout.length
      f.push(lookout[i][3]) if @tags.include?(lookout[i][0])
      f.push(lookout[i][3]) if @tags.include?("(R)#{lookout[i][0]}") && refine.length>0
      f.push(lookout[i][3]) if @tags.include?("(E)#{lookout[i][0]}") && refine=='Effect'
    end
    f.push("  \u200B  \u200B  \u200B  #{self.eff_against_2(refine,event)}") unless self.eff_against_2(refine,event).nil? || ignorefollow
    return f.join('')
  end
  
  def tome_tree_reverse
    return nil unless @exclusivity.nil? || @exclusivity.length<=0
    return 'Dark' if @tome_tree=='Fire'
    return 'Fire' if @tome_tree=='Dark'
    return 'Thunder' if @tome_tree=='Light'
    return 'Light' if @tome_tree=='Thunder'
    return nil
  end
  
  def transform_type
    return nil unless @type.include?('Weapon') && @restrictions.include?('Beasts Only') && !@tags.include?('UnTransform') && !@name.include?(' (All)')
    if @restrictions.include?('Infantry Only')
      return 'If unit is transformed, grants Atk +2, and grants damage +10 when Special triggers.'
    elsif @restrictions.include?('Fliers Only')
      return 'If unit is transformed, grants Atk +2 and unit can move 1 extra space.'
    elsif @restrictions.include?('Cavalry Only')
      return 'If unit is transformed, grants Atk +2, and if unit initiates combat, inflicts Atk/Def-4 on foe during combat and foe cannot make a follow-up attack.'
    elsif @restrictions.include?('Armor Only')
      return 'If unit is transformed, grants Atk +2 and unit can counterattack regardless of distance.'
    else
      return 'If unit is transformed, grants Atk +2.'
    end
  end
  
  def class_header(bot,emotesonly=false,justseal=false)
    emo=[]
    emo.push('<:Skill_Weapon:444078171114045450>') if @type.include?('Weapon') && !justseal
    emo.push('<:Skill_Assist:444078171025965066>') if @type.include?('Assist')
    emo.push('<:Skill_Special:444078170665254929>') if @type.include?('Special')
    emo.push('<:Passive_A:443677024192823327>') if @type.include?('Passive(A)')
    emo.push('<:Passive_B:443677023257493506>') if @type.include?('Passive(B)')
    emo.push('<:Passive_C:443677023555026954>') if @type.include?('Passive(C)')
    emo.push('<:Passive_S:443677023626330122>') if (@type.include?('Passive(S)') || @type.include?('Seal')) && !(emo.length>0 && justseal)
    emo.push('<:Passive_W:443677023706152960>') if @type.include?('Passive(W)') && !justseal
    emo.push('<:Hero_Duo:631431055420948480>') if @type.include?('Duo') && !@exclusivity.include?('Mathoo')
    emo.push('<:Hero_Duo_Mathoo:631431055513092106>') if @type.include?('Duo') && @exclusivity.include?('Mathoo')
    emo.push('<:Hero_Harmonic:722436762248413234>') if @type.include?('Harmonic')
    text=emo.join('')
    text="#{text}**Skill Slot:** #{@type.join(', ')}" unless emotesonly
    if @type.include?('Weapon') && !['Missiletainn','Umbra Burst'].include?(@name)
      clr='Gold'
      clr='Red' if has_any?(@restrictions,['Sword Users Only','Red Tome Users Only']) || (@tags.include?('Red') && !has_any?(@tags,['Blue','Green','Colorless']))
      clr='Blue' if has_any?(@restrictions,['Lance Users Only','Blue Tome Users Only']) || (@tags.include?('Blue') && !has_any?(@tags,['Red','Green','Colorless']))
      clr='Green' if has_any?(@restrictions,['Axe Users Only','Green Tome Users Only']) || (@tags.include?('Green') && !has_any?(@tags,['Blue','Red','Colorless']))
      clr='Colorless' if has_any?(@restrictions,['Rod Users Only','Colorless Tome Users Only']) || (@tags.include?('Colorless') && !has_any?(@tags,['Blue','Green','Red']))
      tpe='Unknown'
      tpe='Blade' if has_any?(@restrictions,['Sword Users Only','Lance Users Only','Axe Users Only','Rod Users Only'])
      tpe='Tome' if has_any?(@restrictions,['Red Tome Users Only','Blue Tome Users Only','Green Tome Users Only','Colorless Tome Users Only'])
      tpe='Dragon' if @restrictions.include?('Dragons Only')
      tpe='Beast' if @restrictions.include?('Beasts Only')
      tpe='Bow' if @restrictions.include?('Bow Users Only')
      tpe='Dagger' if @restrictions.include?('Dagger Users Only')
      tpe='Staff' if @restrictions.include?('Staff Users Only')
      moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clr}_#{tpe}"}
      moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_#{clr}_#{tpe}"} if @tags.include?('Dragalia')
      wemote=''
      wemote=moji[0].mention unless moji.length<=0
      if tpe=='Tome'
        clr="#{@tome_tree}"
        moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{clr}_#{tpe}"}
        wemote=moji[0].mention unless moji.length<=0
      end
      wemote='<:Summon_Gun:467557566050861074>' if @restrictions.include?('Summon Gun Users Only')
      text="#{text}#{"\n" unless emotesonly}#{wemote}"
      text="#{text}**Weapon Type:** #{self.weapon_class}" unless emotesonly
      if tpe=='Beast' && !@tome_tree.nil?
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{@tome_tree}"}
        moji=bot.server(575426885048336388).emoji.values.reject{|q| q.name != "DL_Mov_#{@tome_tree}"} if @tags.include?('Dragalia')
        memote=''
        memote=moji[0].mention unless moji.length<=0
        text="#{text}#{"\n" unless emotesonly}#{memote}"
        text="#{text}**Movement Type:** #{@tome_tree}" unless emotesonly
      end
    elsif @type.include?('Assist') && @restrictions.include?('Staff Users Only')
      text="#{text}#{"\n" unless emotesonly}<:Assist_Staff:454451496831025162>"
      text="#{text}**Healing Staff**" unless emotesonly
    elsif @type.include?('Assist') && ['Liliputia','Brobdingo'].include?(@name) && !emotesonly
      text="#{text}\n<:Assist_Staff:454451496831025162>**Staff**"
    elsif @type.include?('Assist') && @tags.include?('Music')
      text="#{text}#{"\n" unless emotesonly}<:Assist_Music:454462054959415296>"
      text="#{text}**Refreshing**" unless emotesonly
    elsif @type.include?('Assist') && emotesonly
      text="#{text}<:Assist_Rally:454462054619807747>" if @tags.include?('Rally')
      text="#{text}<:Assist_Move:454462055479508993>" if @tags.include?('Move')
      text="#{text}<:Assist_Health:454462054636584981>" if @tags.include?('Health')
    elsif @type.include?('Special') && emotesonly
      text="#{text}<:Special_Offensive:454460020793278475>" if @tags.include?('Offensive')
      text="#{text}<:Special_Defensive:454460020591951884>" if @tags.include?('Defensive')
      text="#{text}<:Special_AoE:454460021665693696>" if @tags.include?('AoE')
      text="#{text}<:Special_Healer:454451451805040640>" if @restrictions.include?('Staff Users Only')
    end
    text="#{text}\n#{self.mcr}" unless @name=='Missiletainn' || self.mcr.length<=0 || emotesonly
    return text
  end
  
  def emotes(bot,justseal=false); return self.class_header(bot,true,justseal); end
  
  def postName(sklz=nil,includew=false,x=false)
    x2=''
    x2='~~' unless @fake.nil?
    y=[@learn,@exclusivity].compact.flatten
    y=y.reject{|q| $units.find_index{|q2| q2.name==q}.nil?}
    y=y.map{|q| $units[$units.find_index{|q2| q2.name==q}]}.reject{|q| !q.fake.nil? || q.postName(true).include?('*')}
    x2="*#{x2}*" if x && !has_any?(@type,['Passive(S)','Passive(W)','Seal','Duo','Harmonic']) && y.length<=0 && !x2.include?('~~') && !self.prevos.nil? && self.prevos.length<=0
    return "#{x2}#{self.fullName('',false,sklz,includew)}#{x2.reverse}"
  end
  
  def thumbnail(event,bot)
    return 'https://cdn.discord.com/emojis/631431055513092106.png' if @type.include?('Duo') && @exclusivity.include?('Mathoo')
    return 'https://cdn.discord.com/emojis/631431055420948480.png' if @type.include?('Duo')
    return 'https://cdn.discord.com/emojis/722436762248413234.png' if @type.include?('Harmonic')
    subname="#{@name}"
    dispname="#{self.fullName}"
    if subname[0,10]=='Squad Ace '
      subname="Squad Ace #{'ABCDE'[((@id-620000)/10)%5,1]}" if @id<620300
      subname="Squad Ace A#{'EFGHIJKLMN'[((@id-620300)/10)%10,1]}" if @id>620299 && @id<620500
    end
    dispname="#{subname} #{@level}" if isPassive? && !@level.nil? && @level!='-'
    if @level=='example'
      skz=$skills.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}
      dispname="#{subname}#{' ' unless @name[-1]=='+'}#{skz[-1].level.to_i}"
    end
    dispname="#{subname} W" if (!@level.nil? && @level[0,1]=='W') || has_any?(event.message.text.downcase.split(' '),['refinement','refinements','(w)'])
    dispname=dispname.gsub(' ','_').gsub('.','').gsub('/','_').gsub('!','').gsub(':','')
    dispname=dispname.gsub('+','') unless subname[-1]=='+' && self.isPassive?
    return "https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Weapons/#{dispname}.png?raw=true" if @type.include?('Weapon')
    return "https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Assists/#{dispname}.png?raw=true" if @type.include?('Assist')
    return "https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Specials/#{dispname}.png?raw=true" if @type.include?('Special')
    return "https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/skills/#{dispname}.png?raw=true" if self.isPassive?
    return ''
  end
  
  def fullName(format=nil,justlast=false,sklz=nil,includew=false)
    x="#{@name}"
    x="#{format}#{x}#{format.reverse}" unless format.nil?
    return x unless self.isPassive?
    return x if ['-'].include?(@level) || @level.nil?
    return x if ['example'].include?(@level) && format.nil? && !justlast
    x="#{x} " unless @name[-1]=='+'
    return "#{x}#{@level}" unless @level=='example'
    skz=$skills.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}
    skz=sklz.reject{|q| q.name != @name || q.level=='example' || (q.level.include?('W') && !includew)} unless sklz.nil?
    char='/'
    char=' / ' if skz.reject{|q| !q.level.include?('/')}.length>0
    if skz.length>5
      skz=[skz[0],skz[-1]]
      char=" \u2192 "
    end
    return "#{x}" if justlast && skz.length<=0
    return "#{x}#{skz[-1].level}" if justlast
    return "#{x}#{skz.map{|q| q.level}.join(char)}"
  end
  
  def tier
    s=$skills.map{|q| q}
    if @level=='example'
      x=s.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}
      y=x.map{|q| q.level.to_i}.min.to_s
      y=s.find_index{|q| q.name==@name && q.level.to_i==y.to_i}
      return x.length if y.nil?
      return x.length+s[y].tier-1
    end
    return 1 if @prerequisite.nil? || @prerequisite.length<=0 || @prerequisite[0]=='-'
    x=s.find_index{|q| q.fullName==@prerequisite[0]}
    return s[x].tier+1 unless @level=='example'
  end
  
  def disp_sp_cost(inherited=false,total=false)
    return 3*@sp_cost/2 if @level!='example' && inherited
    return @sp_cost unless @level=='example'
    return $skills.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}.map{|q| q.disp_sp_cost(inherited)}.inject(0){|sum,x| sum + x } if total
    return $skills.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}.map{|q| q.disp_sp_cost(inherited)}.join('/')
  end
  
  def cumulitive_sp_cost(inherited=false)
    return 3*@sp_cost/2 if (@prerequisite.nil? || @prerequisite.length<=0 || @prerequisite[0]=='-') && inherited
    return @sp_cost if @prerequisite.nil? || @prerequisite.length<=0 || @prerequisite[0]=='-'
    s=$skills.map{|q| q}
    x=s.find_index{|q| q.fullName==@prerequisite[0]}
    return s[x].cumulitive_sp_cost(true)+3*@sp_cost/2 if inherited && @name[-1]=='+' && (@tags.include?('Seasonal') || @restrictions.include?('Staff Users Only'))
    return s[x].cumulitive_sp_cost+3*@sp_cost/2 if @level!='example' && inherited
    return s[x].cumulitive_sp_cost+@sp_cost unless @level=='example'
    x=s.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}.map{|q| q.level.to_i}.max.to_s
    xx=s.find_index{|q| q.name==@name && q.level.to_i==x.to_i}
    return "#{s[xx].cumulitive_sp_cost(inherited)}-#{3*s[xx].cumulitive_sp_cost/2}" if inherited
    return s[xx].cumulitive_sp_cost
  end
  
  def next_steps(event,mode=0)
    s=$skills.map{|q| q}
    x=s.reject{|q| q.prerequisite.nil? || !q.prerequisite.include?(self.fullName) || ['Whelp (All)','Yearling (All)','Adult (All)','Missiletainn','Falchion','Ragnarok+'].include?(q.name)}
    if @level=='example'
      skz=s.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}.map{|q| q.level.to_i}.max.to_s
      xx=s.find_index{|q| q.name==@name && q.level.to_i==skz.to_i}
      return nil if xx.nil?
      return s[xx].next_steps(event,mode)
    end
    x=x.reject{|q| !q.isPostable?(event)}.sort{|a,b| a.fullName<=>b.fullName}
    return x if mode%2==1
    return list_lift(x.map{|q| "*#{q.postName}*"},'or') unless x.length<=0
    return nil
  end
  
  def side_steps(event,mode=0)
    return nil unless @level=='example'
    skz=$skills.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}
    x=[]
    for i in 0...skz.length
      xx=skz[i].next_steps(event,1)
      if !xx.nil? && xx.length>0
        for i2 in 0..xx.length
          x.push(xx[i2]) unless xx[i2].nil? || skz.include?(xx[i2]) || xx[i2].level=='example' || self.next_steps(event,1).include?(xx[i2])
        end
      end
    end
    x.compact!
    x.uniq!
    x=x.reject{|q| !q.isPostable?(event)}.sort{|a,b| a.fullName<=>b.fullName}
    return x if mode%2==1
    return list_lift(x.map{|q| q.postName},'or') unless x.length<=0
    return nil
  end
  
  def has_tag?(tag,refine=nil,transformed=false)
    return false if @tags.nil? || @tags.length<=0
    return true if @tags.include?(tag)
    return false unless @type.include?('Weapon')
    return true if @tags.include?("(E)#{tag}") && refine=='Effect'
    return true if @tags.include?("(R)#{tag}") && !refine.nil? && refine.length>0
    return true if @tags.include?("(T)#{tag}") && transformed
    return true if has_any?(@tags,["(TE)#{tag}","(ET)#{tag}","(T)(E)#{tag}","(E)(T)#{tag}"]) if transformed && refine=='Effect'
    return true if has_any?(@tags,["(TR)#{tag}","(RT)#{tag}","(T)(R)#{tag}","(R)(T)#{tag}"]) if transformed && !refine.nil? && refine.length>0
    return false
  end
  
  def prevos
    s=$skills.reject{|q| q.evolutions.nil? || !q.evolutions.include?(self.fullName)}
    return nil if s.length<=0
    return s
  end
  
  def isMagic?
    return false unless @type.include?('Weapon')
    return true if @restrictions.join(', ').include?('Tome Users Only')
    return true if @restrictions.include?('Dragons Only')
    return true if @restrictions.include?('Staff Users Only')
    return false
  end
  
  def isRanged?
    return false unless @type.include?('Weapon')
    return true if @restrictions.join(', ').include?('Tome Users Only')
    return true if has_any?(@restrictions,['Bow Users Only','Dagger Users Only'])
    return false
  end
  
  def refinement_name
    return nil unless @type.include?('Weapon')
    s=$skills.select{|q| !q.weapon_gain.nil? && q.weapon_gain.include?(@name)}
    return nil if s.length<=0 || s.nil?
    return s[0] if s.length==1 || s.reject{|q| q.level=='example'}.length<=0
    s=s.reject{|q| q.level=='example'}
    return s[0]
  end
  
  def seal_colors(bot,total=false)
    return nil if !has_any?(@type,['Seal','Passive(S)']) || @shard_color.nil? || @shard_color.length<=0 || @shard_color=='-' || @shard_color[0]=='-'
    if @level=='example'
      x=$skills.map{|q| q}.reject{|q| q.name != @name || q.level=='example' || q.shard_color.nil? || q.shard_color.length<=0 || q.shard_color=='-' || q.shard_color[0]=='-'}.map{|q| q.shard_color}
      xx=["#{x[0][0][0].upcase}#{x[0][0][1,x[0][0].length].downcase}"]
      for i in 1...x.map{|q| q.length}.max
        if total
          xx.push(x.map{|q| "#{q[i]}#{0 if q[i].nil?}".to_i}.inject(0){|sum,q| sum + q })
        else
          xx.push(x.map{|q| "#{q[i]}#{0 if q[i].nil?}"}.join('/'))
        end
      end
    else
      xx=@shard_color.map{|q| q}
    end
    bemote1='<:Badge_Golden:595157392597975051>'
    moji=bot.server(443704357335203840).emoji.values.reject{|q| q.name != "Badge_#{xx[0]}"}
    bemote1=moji[0].mention unless moji.length<=0
    bemote2='<:Great_Badge_Golden:443704781068959744>'
    moji=bot.server(443704357335203840).emoji.values.reject{|q| q.name != "Great_Badge_#{xx[0]}"}
    bemote2=moji[0].mention unless moji.length<=0
    return "#{bemote1}#{bemote2}" if xx.length==1 && !total
    return nil if xx.length<2
    return "#{xx[1]}#{bemote2} #{xx[2]}#{bemote1} #{xx[3]}<:Sacred_Coin:453618312996323338>"
  end
  
  def subUnits(event,lvl=0,totality=false)
    return nil unless @level=='example'
    x=$skills.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}
    x=x.reject{|q| q.tier != lvl} unless lvl<1 || totality
    x=x.reject{|q| q.tier<=lvl} unless lvl<1 || !totality
    x=x.map{|q| q.learn}
    x=x.flatten.uniq.reject{|q| @learn.flatten.include?(q)}
    x=x.reject{|q| !self.subUnits(event,lvl,true).nil? && self.subUnits(event,lvl,true).include?(q)} if lvl>0 && !totality
    x=x.reject{|q| $units.find_index{|q2| q2.name==q}.nil?}
    x=x.map{|q| $units[$units.find_index{|q2| q2.name==q}]}.reject{|q| !q.isPostable?(event)}
    x=x.map{|q| q.postName}
    x=x.uniq.sort
    return nil if x.length<=0
    return x
  end
  
  def lineCount
    return nil unless @level=='example'
    x=$skills.reject{|q| q.name != @name || q.level=='example' || q.level.include?('W')}
    return x.length
  end
  
  def alias_list(bot,event,saliases=false,justaliases=false)
    if ['Falchion','Missiletainn'].include?(@name)
      x=$skills.reject{|q| q.name[0,@name.length+2]!="#{@name} ("}
      f=x.map{|q| q.alias_list(bot,event,saliases)}
      for i in 0...f.length-1
        f[i].push(' ')
      end
      f.flatten!
      return f
    end
    k=$aliases.reject{|q| q[0]!='Skill' || ![@id,@name,self.fullName].include?(q[2])}
    k=k.reject{|q| !q[3].nil? && !q[3].include?(event.server.id)} unless event.server.nil?
    k=k.reject{|q| q[3].nil?} if saliases
    return k.map{|q| q[1]}.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')} if justaliases
    if event.server.nil?
      for i in 0...k.length
        if k[i][3].nil?
          k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")}"
        else
          f=[]
          for j in 0...k[i][3].length
            srv=(bot.server(k[i][3][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              f.push("*#{bot.server(k[i][3][j]).name}*") unless event.user.on(k[i][3][j]).nil?
            end
          end
          if f.length<=0
            k[i]=nil
          else
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (in the following servers: #{list_lift(f,'and')})" unless Shardizard==$spanishShard
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (en los siguientes servidores: #{list_lift(f,'y')})" if Shardizard==$spanishShard
          end
        end
      end
      k.compact!
    else
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[in this server only]*' unless q[3].nil? || saliases}"} unless Shardizard==$spanishShard
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[solo en este servidor]*' unless q[3].nil? || saliases}"} if Shardizard==$spanishShard
    end
    k=k.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')}
    k.unshift(@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')) unless @name==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','') || saliases
    k.unshift("__#{'Alias ​​específicos del servidor de ' if saliases && Shardizard==$spanishShard}**#{@name}#{self.emotes(bot,false)}**#{"'s server-specific aliases" if saliases && Shardizard !=$spanishShard}#{" [Skill-#{longFormattedNumber(@id)}]" if Shardizard==4 || event.user.id==167657750971547648}__")
    return k
  end
end

class FEHRefine
  attr_accessor :inner
  attr_accessor :outer
  attr_accessor :stats
  attr_accessor :overrides
  attr_accessor :to_add
  attr_accessor :name,:miniName
  attr_accessor :ref_of
  
  def initialize(val,weap)
    @stats=[0,0,0,0,0,0]
    @to_add=0
    @to_add=1 if weap.tags.include?('Silver')
    if val[0,1].to_i==val[0,1]
      @to_add+=val[0,1].to_i
      val=val[1,val.length-1]
      val='y' if val.length<=0
    elsif val[0,1]=='-' && val.length>1 && val[1,1].to_i==val[1,1]
      @to_add-=val[1,1].to_i
      val=val[2,val.length-2]
      val='y' if val.length<=0
    end
    for i in 0...6
      if val[0,1].to_i.to_s==val[0,1]
        @stats[i]+=val[0,1].to_i
        val=val[1,val.length-1]
        val='y' if val.length<=0
      elsif val[0,1]=='-' && val.length>1 && val[1,1].to_i.to_s==val[1,1]
        @stats[i]-=val[1,1].to_i
        val=val[2,val.length-2]
        val='y' if val.length<=0
      end
    end
    @overrides=[[0,3,0,0,0,0,'e'],[2,5,0,0,0,0,'a'],[0,5,0,3,0,0,'s'],[0,5,0,0,4,0,'d'],[0,5,0,0,0,4,'r']]
    @overrides=[[0,0,0,0,0,0,'e'],[1,2,0,0,0,0,'a'],[0,2,0,2,0,0,'s'],[0,2,0,0,3,0,'d'],[0,2,0,0,0,3,'r']] if weap.isRanged?
    @overrides=[[0,0,0,0,0,0,'e'],[0,0,0,0,0,0,'w',"This weapon's damage is calculated the same as other weapons."],[0,0,0,0,0,0,'d','The foe cannot counterattack.']] if weap.restrictions.include?('Staff Users Only') && weap.tome_tree=='WrazzleDazzle'
    @overrides=[[0,0,0,0,0,0,'e']] if weap.restrictions.include?('Staff Users Only') && weap.tome_tree.nil?
    for i in 0...@overrides.length
      if val[0,3]=="(#{@overrides[i][6]})"
        val=val[3,val.length-3]
        for i2 in 0...6
          if val[0,1].to_i.to_s==val[0,1]
            @overrides[i][i2]+=val[0,1].to_i
            val=val[1,val.length-1]
            val='y' if val.length<=0
          elsif val[0,1]=='-' && val.length>1 && val[1,1].to_i.to_s==val[1,1]
            @overrides[i][i2]-=val[1,1].to_i
            val=val[2,val.length-2]
            val='y' if val.length<=0
          end
        end
      end
    end
    @overrides[0][6]='Effect'
    if weap.restrictions.include?('Staff Users Only') && weap.tome_tree=='WrazzleDazzle'
      @overrides[1][6]='Wrathful'
      @overrides[2][6]='Dazzling'
    elsif weap.restrictions.include?('Staff Users Only') && weap.tome_tree.nil?
    else
      @overrides[1][6]='Attack'
      @overrides[2][6]='Speed'
      @overrides[3][6]='Defense'
      @overrides[4][6]='Resistance'
    end
    if val[0,1]=='*'
      @outer=val[1,val.length-1]
    elsif val.include?(' ** ')
      val=val.split(' ** ')
      @inner=val[0]
      @outer=val[1]
    elsif val=='y' || val.length<=0
    else
      @inner=val
    end
    @overrides=@overrides.reject{|q| q[6]=='Effect'} if weap.refinement_name.nil? && @inner.nil? && !['Falchion','Missiletainn'].include?(weap.name)
    @overrides=@overrides.reject{|q| q[6]=='Wrathful'} if weap.description.include?("This weapon's damage is calculated the same as other weapons.") || weap.description.include?('Damage from staff calculated like other weapons.') || weap.tags.include?('Wrathful')
    @overrides=@overrides.reject{|q| q[6]=='Dazzling'} if weap.description.include?('The foe cannot counterattack.') || weap.description.include?('Foe cannot counterattack.') || weap.tags.include?('Dazzling')
    @miniName="#{weap.refinement_name.name}" unless weap.refinement_name.nil?
    @name="#{weap.refinement_name.fullName}" unless weap.refinement_name.nil?
    @ref_of=weap
  end
  
  def objt; return 'Refine'; end
  
  def thumbnail
    return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Falchion_Refines.png' if @ref_of.name=='Falchion'
    return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Missiletainn_Refines.png' if @ref_of.name=='Missiletainn'
    return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Adult_Refines.png' if @ref_of.name=='Adult (All)'
    unless @ref_of.refinement_name.nil?
      x=@ref_of.refinement_name.name.gsub(' ','_')
      return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/#{x}_W.png" unless @ref_of.refinement_name.level.nil?
      return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/#{x}.png"
    end
    if @ref_of.restrictions.include?('Staff Users Only')
      return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Dazzling_W.png' if @ref_of.description.include?("This weapon's damage is calculated the same as other weapons.") || @ref_of.description.include?('Damage from staff calculated like other weapons.') || @ref_of.tags.include?('Wrathful')
      return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Wrathful_W.png' if @ref_of.description.include?('The foe cannot counterattack.') || @ref_of.description.include?('Foe cannot counterattack.') || @ref_of.tags.include?('Dazzling')
      return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Staff_Default_Refine.png'
    end
    return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Freeze.png' if has_any?(@ref_of.tags,['Frostbite','(R)Frostbite'])
    return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Magic.png' if @ref_of.isMagic?
    return 'https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/skills/Default_Refine_Strength.png'
  end
  
  def emote(r='Effect')
    if r=='Attack'
      return '<:FreezeW:449999580864708618>' if has_any?(@ref_of.tags,['Frostbite','(R)Frostbite'])
      return '<:MagicW:449999580835086337>' if @ref_of.isMagic?
      return '<:StrengthW:449999580948463617>'
    end
    return '<:SpeedW:449999580868640798>' if r=='Speed'
    return '<:DefenseW:449999580793274408>' if r=='Defense'
    return '<:ResistanceW:449999580864446514>' if r=='Resistance'
    return '<:Wrathful:449999580650668033>' if r=='Wrathful'
    return '<:Dazzling:449999580411592705>' if r=='Dazzling'
    return '<:EffectMode:450002917269831701>'
  end
  
  def dispStats(r='Effect',sttz=false,transformed=false)
    x=@overrides.find_index{|q| q[6]==r}
    return nil if x.nil?
    x=@overrides[x].map{|q| q}
    for i in 0...6
      x[i]+=@stats[i]
      x[i]+=@ref_of.weapon_stats[i-1] unless i==0
      x[i]+=@ref_of.weapon_stats[i+4] if i>0 && transformed
      if i==2
        x[0]+=@ref_of.might
        x[i]-=@ref_of.might
      end
    end
    x[0]+=@to_add
    if r=='Effect' && !@ref_of.refinement_name.nil? && !sttz
      x2=$statskills.find_index{|q| q[0]==@ref_of.refinement_name.fullName}
      unless x2.nil? || !['Stat-Affecting 1','Stat-Affecting 2'].include?($statskills[x2][3])
        x2=$statskills[x2]
        for i in 0...5
          x[i+1]+=x2[4][i]
        end
      end
    end
    if sttz
      str="Might: #{x[0]}  \u200B  \u200B  \u200B  Range: #{@ref_of.range}"
      if x[1,5].reject{|q| q==0}.length>2 && r != 'Effect'
        str="#{str}  \u200B  \u200B  \u200B  #{x[1,5].map{|q| "#{'+' if q>0}#{q}"}.join('/')}"
      else
        str="#{str}  \u200B  \u200B  \u200B  HP #{'+' if x[1]>0}#{x[1]}" unless x[1]==0
        str="#{str}  \u200B  \u200B  \u200B  Attack #{'+' if x[2]>0}#{x[2]}" unless x[2]==0
        str="#{str}  \u200B  \u200B  \u200B  Speed #{'+' if x[3]>0}#{x[3]}" unless x[3]==0
        str="#{str}  \u200B  \u200B  \u200B  Defense #{'+' if x[4]>0}#{x[4]}" unless x[4]==0
        str="#{str}  \u200B  \u200B  \u200B  Resistance #{'+' if x[5]>0}#{x[5]}" unless x[5]==0
      end
      str="#{str}  \u200B  \u200B  \u200B  #{x[7]}" unless x[7].nil?
      return str
    end
    return x
  end
end

class FEHStructure
  attr_accessor :name
  attr_accessor :level
  attr_accessor :type
  attr_accessor :description
  attr_accessor :destructable
  attr_accessor :costs
  attr_accessor :ar_tier,:charge
  attr_accessor :note
  
  def initialize(val); @name=val; end
  def name=(val); @name=val; end
  def level=(val); @level=val; end
  def type=(val); @type=val.split('/'); end
  def description=(val); @description=val; end
  def destructable=(val); @destructable=val; end
  def costs=(val); @costs=val.split(', ').map{|q| q.to_i}; end
  def note=(val); @note=val; end
  def objt; return 'Structure'; end
  def id; return nil; end

  def ar_tier=(val)
    if @type[0]=='Mjolnir'
      @charge=val.to_i
    else
      @ar_tier=val.to_i
    end
  end
  
  def fullName(format=nil,justlast=false)
    x="#{@name}"
    x="#{format}#{x}#{format.reverse}" unless format.nil?
    return x if ['-'].include?(@level) || @level.nil?
    return x if ['example'].include?(@level) && format.nil? && !justlast
    x="#{x} " unless @name[-1]=='+'
    return "#{x}#{@level}" unless @level=='example'
    skz=$structures.reject{|q| q.name != @name || q.level=='example'}
    char='/'
    if skz.length>5
      skz=[skz[0],skz[-1]]
      char='-'
    end
    return "#{x}#{skz[-1].level}" if justlast
    return "#{x}#{skz.map{|q| q.level}.uniq.join(char)}"
  end
  
  def thumbnail(event,bot)
    x=@name.gsub('False ','').gsub(' ','_').gsub('.','').gsub('/','_').gsub('+','').gsub('!','')
    return "https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/Structures/#{x}.png?raw=true"
  end
  
  def class_header(bot,emotesonly=false,includebonus=true)
    wemote=''
    moji=bot.server(497429938471829504).emoji.values.reject{|q| q.name != "#{self.type[0]}_Structure"}
    wemote=moji[0].mention unless moji.length<=0
    wemote='<:Battle_Structure:565064414454349843>' if self.type.include?('Offensive') && self.type.include?('Defensive')
    bemote=''
    bemote='<:Current_Aether_Bonus:510022809741950986>' if self.isBonus?.length>0 && includebonus
    return "#{wemote}#{bemote}" if emotesonly
    if Shardizard==$spanishShard
      return "#{wemote}**Tipo:** Desconocida#{"\n#{bemote}**#{self.isBonus?} Bonificación actual en Asaltos Etéreos**" if self.isBonus?.length>0 && includebonus}" if @type.length<=0
      return "#{wemote}**Tipo:** #{self.spanish_type.join('/')}#{"\n#{bemote}**#{self.isBonus?} Bonificación actual en Asaltos Etéreos**" if self.isBonus?.length>0 && includebonus}"
    end
    return "#{wemote}**Type:** Unknown#{"\n#{bemote}**#{self.isBonus?} Aether Bonus Structure**" if self.isBonus?.length>0 && includebonus}" if @type.length<=0
    return "#{wemote}**Type:** #{@type.join('/')}#{"\n#{bemote}**#{self.isBonus?} Aether Bonus Structure**" if self.isBonus?.length>0 && includebonus}"
  end
  
  def emotes(bot,includebonus=true); return self.class_header(bot,true,includebonus); end

  def isBonus?(x2=nil)
    x=$bonus_units.find_index{|q| q.type=='Aether' && q.isCurrent?}
    return '' if x.nil?
    x=$bonus_units[x]
    return 'Offense/Defense' if x.offense_structure==@name && x.defense_structure==@name
    return 'Offense' if x.offense_structure==@name
    return 'Defense' if x.defense_structure==@name
    return ''
  end
  
  def disp_color(chain=0)
    return 0x8CAA7B if @type.include?('Offensive') && @type.include?('Defensive')
    return 0xF0631E if @type[0]=='Offensive'
    return 0x27F2D8 if @type[0]=='Defensive'
    return 0xB950E9 if @type[0]=='Trap'
    return 0xD3DADC if @type[0]=='Resources'
    return 0xFEE257 if ['Ornament','Resort'].include?(@type[0])
    return 0xFBC948 if @type[0]=='Mjolnir'
    return 0x54C571
  end
  
  def alias_list(bot,event,saliases=false,justaliases=false)
    k=$aliases.reject{|q| q[0]!='Structure' || q[2]!=@name}
    k=k.reject{|q| !q[3].nil? && !q[3].include?(event.server.id)} unless event.server.nil?
    k=k.reject{|q| q[3].nil?} if saliases
    return k.map{|q| q[1]}.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')} if justaliases
    if event.server.nil?
      for i in 0...k.length
        if k[i][3].nil?
          k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")}"
        else
          f=[]
          for j in 0...k[i][3].length
            srv=(bot.server(k[i][3][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              f.push("*#{bot.server(k[i][3][j]).name}*") unless event.user.on(k[i][3][j]).nil?
            end
          end
          if f.length<=0
            k[i]=nil
          else
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (in the following servers: #{list_lift(f,'and')})" unless Shardizard==$spanishShard
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (en los siguientes servidores: #{list_lift(f,'y')})" if Shardizard==$spanishShard
          end
        end
      end
      k.compact!
    else
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[in this server only]*' unless q[3].nil? || saliases}"} unless Shardizard==$spanishShard
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[solo en este servidor]*' unless q[3].nil? || saliases}"} if Shardizard==$spanishShard
    end
    k=k.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')}
    k.unshift(@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')) unless @name==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','') || saliases
    k.unshift("__#{'Alias ​​específicos del servidor de ' if saliases && Shardizard==$spanishShard}**#{@name}#{self.emotes(bot,false)}**#{"'s server-specific aliases" if saliases && Shardizard !=$spanishShard}__")
    return k
  end
end

class FEHItem
  attr_accessor :name
  attr_accessor :type
  attr_accessor :maximum
  attr_accessor :description
  attr_accessor :note
  
  def initialize(val); @name=val; end
  def name=(val); @name=val; end
  def type=(val); @type=val; end
  def description=(val); @description=val; end
  def note=(val); @note=val; end
  def objt; return 'Item'; end
  def id; return nil; end
  
  def maximum=(val)
    if val.to_i.to_s==val
      @maximum=longFormattedNumber(val.to_i)
    else
      @maximum=val
    end
  end

  def fullName(format=nil)
    return @name if format.nil?
    return "#{format}#{@name}#{format.reverse}"
  end
  
  def thumbnail(event,bot)
    x=@name.gsub(' ','_').gsub('(','_').gsub(')','_').gsub('&','_')
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Items/#{x}.png"
  end
  
  def class_header(bot,emotesonly=false,ext=false)
    return '' if emotesonly
    if Shardizard==$spanishShard
      return "**Tipo:** Asalto del Coliseo/Batallas Fragorosas\n**Maxima:** #{k.maximum}" if @type=='Assault'
      return "**Tipo de Artículo:** #{self.spanish_type}\n**Maxima:** #{@maximum}"
    end
    return "**Type:** Arena Assault/Resonant Blades\n**Maximum:** #{k.maximum}" if @type=='Assault'
    return "**Item Type:** #{@type}\n**Maximum:** #{@maximum}"
  end
  
  def disp_color(chain=0)
    return 0x3B474D if @type=='Implied'
    return 0x332559 if @type=='Assault'
    if @type=='Blessing'
      return 0xF98281 if @name.include?('Fire')
      return 0x91F4FF if @name.include?('Water')
      return 0x97FF99 if @name.include?('Wind')
      return 0xFFAF7E if @name.include?('Earth')
      return 0xFDF39D if @name.include?('Light')
      return 0xBE83FE if @name.include?('Dark')
      return 0xF5A4DA if @name.include?('Astra')
      return 0xE1DACF if @name.include?('Anima')
    elsif @type=='Growth'
      return 0xE22141 if @name.include?('Scarlet')
      return 0x2764DE if @name.include?('Azure')
      return 0x09AA24 if @name.include?('Verdant')
      return 0x64757D if @name.include?('Transparent')
      return 0xBD9843
    end
    return 0x5BACB9
  end
  
  def alias_list(bot,event,saliases=false,justaliases=false)
    k=$aliases.reject{|q| q[0]!='Item' || q[2]!=@name}
    k=k.reject{|q| !q[3].nil? && !q[3].include?(event.server.id)} unless event.server.nil?
    k=k.reject{|q| q[3].nil?} if saliases
    return k.map{|q| q[1]}.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')} if justaliases
    if event.server.nil?
      for i in 0...k.length
        if k[i][3].nil?
          k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")}"
        else
          f=[]
          for j in 0...k[i][3].length
            srv=(bot.server(k[i][3][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              f.push("*#{bot.server(k[i][3][j]).name}*") unless event.user.on(k[i][3][j]).nil?
            end
          end
          if f.length<=0
            k[i]=nil
          else
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (in the following servers: #{list_lift(f,'and')})" unless Shardizard==$spanishShard
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (en los siguientes servidores: #{list_lift(f,'y')})" if Shardizard==$spanishShard
          end
        end
      end
      k.compact!
    else
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[in this server only]*' unless q[3].nil? || saliases}"} unless Shardizard==$spanishShard
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[solo en este servidor]*' unless q[3].nil? || saliases}"} if Shardizard==$spanishShard
    end
    k=k.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')}
    k.unshift(@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')) unless @name==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','') || saliases
    k.unshift("__#{'Alias ​​específicos del servidor de ' if saliases && Shardizard==$spanishShard}**#{@name}#{self.emotes(bot,false)}**#{"'s server-specific aliases" if saliases}__")
    return k
  end
end

class FEHAccessory
  attr_accessor :name
  attr_accessor :type
  attr_accessor :description
  attr_accessor :obtain
  attr_accessor :note
  
  def initialize(val); @name=val; end
  def name=(val); @name=val; end
  def type=(val); @type=val; end
  def description=(val); @description=val; end
  def obtain=(val); @obtain=val; end
  def note=(val); @note=val; end
  def objt; return 'Accessory'; end
  def id; return nil; end
  
  def fullName(format=nil)
    return @name if format.nil?
    return "#{format}#{@name}#{format.reverse}"
  end
  
  def thumbnail(event,bot)
    x=@name.gsub(' ','_').gsub('(','_').gsub(')','_').gsub('&','_')
    return "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Accessories/#{x}.png"
  end
  
  def class_header(bot,emotesonly=false,ext=false)
    wemote=''
    moji=bot.server(449988713330769920).emoji.values.reject{|q| q.name != "Accessory_Type_#{@type}"}
    wemote=moji[0].mention unless moji.length<=0
    return "#{'<:Summon_Gun:467557566050861074>' if @name[0,4]=='(S) '}#{wemote}" if emotesonly
    return "#{"<:Summon_Gun:467557566050861074>**Exclusivo para invocador**\n" if @name[0,4]=='(S) '}#{wemote}**Tipo de Accesorio:** #{self.spanish_type}" if Shardizard==$spanishShard
    return "#{"<:Summon_Gun:467557566050861074>**Summoner-exclusive**\n" if @name[0,4]=='(S) '}#{wemote}**Accessory Type:** #{@type}"
  end
  
  def emotes(bot,includebonus=true); return self.class_header(bot,true,includebonus); end
  def disp_color(chain=0); return 0xFF47FF; end
  
  def alias_list(bot,event,saliases=false,justaliases=false)
    k=$aliases.reject{|q| q[0]!='Accessory' || q[2]!=@name}
    k=k.reject{|q| !q[3].nil? && !q[3].include?(event.server.id)} unless event.server.nil?
    k=k.reject{|q| q[3].nil?} if saliases
    return k.map{|q| q[1]}.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')} if justaliases
    if event.server.nil?
      for i in 0...k.length
        if k[i][3].nil?
          k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")}"
        else
          f=[]
          for j in 0...k[i][3].length
            srv=(bot.server(k[i][3][j]) rescue nil)
            unless srv.nil? || bot.user(bot.profile.id).on(srv.id).nil?
              f.push("*#{bot.server(k[i][3][j]).name}*") unless event.user.on(k[i][3][j]).nil?
            end
          end
          if f.length<=0
            k[i]=nil
          else
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (in the following servers: #{list_lift(f,'and')})" unless Shardizard==$spanishShard
            k[i]="#{k[i][1].gsub('`',"\`").gsub('*',"\*")} (en los siguientes servidores: #{list_lift(f,'y')})" if Shardizard==$spanishShard
          end
        end
      end
      k.compact!
    else
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[in this server only]*' unless q[3].nil? || saliases}"} unless Shardizard==$spanishShard
      k=k.map{|q| "#{q[1].gsub('`',"\`").gsub('*',"\*")}#{' *[solo en este servidor]*' unless q[3].nil? || saliases}"} if Shardizard==$spanishShard
    end
    k=k.reject{|q| q==@name || q==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')}
    k.unshift(@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')) unless @name==@name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','') || saliases
    k.unshift(@name[4,@name.length-4].gsub('(','').gsub(')','').gsub(' ','').gsub('_','')) if @name[0,4]=='(S) ' && !saliases
    k.unshift("__#{'Alias ​​específicos del servidor de ' if saliases && Shardizard==$spanishShard}**#{@name}#{self.emotes(bot,false)}**#{"'s server-specific aliases" if saliases && Shardizard !=$spanishShard}__")
    return k
  end
end

# secondary entities

class FEHTimer
  attr_accessor :start_date,:end_date
  
  def date=(val)
    x=val.split(', ')
    @start_date=x[0].split('/').map{|q| q.to_i}
    @end_date=x[1].split('/').map{|q| q.to_i}
  end
  
  def isCurrent?(includempty=true,shift=false)
    return false if @start_date.nil?
    t=Time.now
    t+=24*60*60 if shift
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    return true if @start_date[0]==t.day && @start_date[1]==t.month && @start_date[2]==t.year
    return false if @end_date.nil?
    return false if @start_date[2]>t.year
    return false if @start_date[2]==t.year && @start_date[1]>t.month
    return false if @start_date[2]==t.year && @start_date[1]==t.month && @start_date[0]>t.day
    return false if @end_date[2]<t.year
    return false if @end_date[2]==t.year && @end_date[1]<t.month
    return false if @end_date[2]==t.year && @end_date[1]==t.month && @end_date[0]<t.day
    return false if @end_date[2]==t.year && @end_date[1]==t.month && @end_date[0]==t.day && self.is_a?(FEHBonus) && ['Arena','Aether'].include?(@type) && t.hour>15 && !includempty
    return true
  end
  
  def startsTomorrow?
    return false if @start_date.nil?
    t=Time.now
    t+=24*60*60
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    return true if @start_date[0]==t.day && @start_date[1]==t.month && @start_date[2]==t.year
    return false
  end
  
  def isNext?(includempty=true,ignorecurrency=false)
    return false if @start_date.nil?
    return false if self.isCurrent?(true) && !ignorecurrency
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    t+=7*24*60*60 # shift by a week
    return true if @start_date[0]==t.day && @start_date[1]==t.month && @start_date[2]==t.year
    return false if @end_date.nil?
    return false if @start_date[2]>t.year
    return false if @start_date[2]==t.year && @start_date[1]>t.month
    return false if @start_date[2]==t.year && @start_date[1]==t.month && @start_date[0]>t.day
    return false if @end_date[2]<t.year
    return false if @end_date[2]==t.year && @end_date[1]<t.month
    return false if @end_date[2]==t.year && @end_date[1]==t.month && @end_date[0]<t.day
    return true
  end
  
  def isFuture?
    return false if self.isCurrent? || @start_date.nil?
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    return false if @start_date[2]<t.year
    return false if @start_date[2]==t.year && @start_date[1]<t.month
    return false if @start_date[2]==t.year && @start_date[1]==t.month && @start_date[0]<t.day
    return true
  end
  
  def isPast?(includempty=true)
    return false if self.isCurrent?(includempty)
    return false if self.isFuture?
    return false if @start_date.nil? || @end_date.nil?
    return true
  end
end

class FEHBonus < FEHTimer
  attr_accessor :bonuses
  attr_accessor :type
  attr_accessor :elements
  attr_accessor :offense_structure,:defense_structure
  attr_accessor :seals
  
  def initialize
    @unit_list=[]
    @start_date=[]
    @end_date=[]
    @elements=[]
    @type=''
  end
  
  def bonuses=(val); @bonuses=[] if val.nil? || val.length<=0 || val=='-'; @bonuses=val.split(', ') unless val.nil? || val=='-'; end
  def type=(val); @type=val; end
  def objt; return 'Bonus'; end
  
  def unit_list
    x=@bonuses.map{|q| $units.find_index{|q2| q2.name==q}}
    x.compact!
    x=x.map{|q| $units[q]}
    return x
  end
  
  def subdata=(val)
    if val.nil?
    elsif @type=='Tempest'
      x=val.split(', ')
      @seals=[]
      for i in 0...x.length
        f=$skills.find_index{|q| q.fullName==x[i]}
        @seals.push($skills[f].clone) unless f.nil?
      end
      @seals=nil if @seals.length<=0
    elsif @type=='Aether'
      x=val.split(', ')
      @offense_structure=x[0]
      @defense_structure=x[-1]
    else
      @elements=val.split(', ')
    end
  end
  
  def typeAsNumber
    x=10
    x=1 if @type=='Arena'
    x=2 if @type=='Tempest'
    x=3 if @type=='Aether'
    x=4 if @type=='Resonant'
    return x*1000000000 if @start_date.nil?
    return x*1000000000+@start_date[2]*10000+@start_date[1]*100+@start_date[0]
  end
end

class FEHBanner < FEHTimer
  attr_accessor :name
  attr_accessor :starting_focus
  attr_accessor :banner_units
  attr_accessor :focus_rarities
  attr_accessor :tags
  
  def initialize(val)
    @name=val
    @starting_focus=3
    @focus_rarities='5'
    @tags=[]
  end
  
  def starting_focus=(val); @starting_focus=val.to_i; end
  def banner_units=(val); @banner_units=val.split(', '); end
  def focus_rarities=(val); @focus_rarities=val; end
  def tags=(val); @tags=val.split(', '); end
  def objt; return 'Banner'; end
  
  def unit_list
    return $units.reject{|q| !q.availability[0].include?('t') || !q.fake.nil?} if @tags.include?('Dynamic') && @tags.include?('Tempest')
    return $units.reject{|q| !q.availability[0].include?('g') || !q.fake.nil?} if @tags.include?('Dynamic') && @tags.include?('GHB')
    x=@banner_units.map{|q| $units.find_index{|q2| q2.name==q}}
    x.compact!
    x=x.map{|q| $units[q]}
    return x
  end
  
  def reds; return self.unit_list.reject{|q| q.weapon_color != 'Red'}; end
  def blues; return self.unit_list.reject{|q| q.weapon_color != 'Blue'}; end
  def greens; return self.unit_list.reject{|q| q.weapon_color != 'Green'}; end
  def colorlesses; return self.unit_list.reject{|q| q.weapon_color != 'Colorless'}; end
  def golds; return self.unit_list.reject{|q| ['Red','Blue','Green','Colorless'].include?(q.weapon_color)}; end
end

class FEHEvent < FEHTimer
  attr_accessor :name
  attr_accessor :type
  
  def initialize(val)
    @name=val
  end
  
  def type=(val); @type=val; end
end

class FEHCode
  attr_accessor :unit_name
  attr_accessor :rarity
  attr_accessor :cost
  
  def initialize(val)
    @unit_name=val
  end
  
  def rarity=(val); @rarity=val.to_i; end
  def cost=(val); @cost=val.split(', ').map{|q| q.to_i}; end
end

class FEHPath < FEHTimer
  attr_accessor :name
  attr_accessor :codes
  
  def initialize(val)
    @name=val
    @codes=[]
  end
  
  def new_code(val)
    v=val.split('; ')
    x=FEHCode.new(v[0])
    x.rarity=v[1]
    x.cost=v[2]
    @codes.push(x.clone)
  end
end

class FEHGroup
  attr_accessor :name
  attr_accessor :units
  attr_accessor :fake
  
  def initialize(val)
    @name=val
  end
  
  def units=(val); @units=val; end
  def fake=(val); @fake=val; end
  def objt; return 'Group'; end
  
  def isPostable?(event)
    return true if @fake.nil?
    return false if event.server.nil?
    return true if @fake.include?(event.server.id)
    return false
  end
end

# crossover crossreference entities

class FGOServant
  attr_accessor :id
  attr_accessor :name
  attr_accessor :artist
  attr_accessor :voice_jp
  
  def initialize(val)
    @id=val
  end
  
  def name=(val); @name=val; end
  def artist=(val); @artist=val; end
  def voice_jp=(val); @voice_jp=val; end
  
  def tid
    return @id.to_f if @id.to_i<2
    return @id.to_i
  end
end

class FGO_CE
  attr_accessor :id
  attr_accessor :name
  attr_accessor :artist
  
  def initialize(val)
    @id=val
  end
  
  def name=(val); @name=val; end
  def artist=(val); @artist=val; end
end

class DLSentient
  attr_accessor :name
  attr_accessor :voice_na
  attr_accessor :voice_jp
  
  def initialize(val)
    @name=val
  end
  
  def voice_na=(val); @voice_na=val; end
  def voice_jp=(val); @voice_jp=val; end
end

class DLPrint
  attr_accessor :name
  attr_accessor :artist
  
  def initialize(val)
    @name=val
  end
  
  def artist=(val); @artist=val; end
end

def data_load(to_reload=[])
  to_reload=[to_reload] if to_reload.is_a?(String)
  reload_everything=false
  if has_any?(to_reload.map{|q| q.downcase},['everything','all'])
    reload_everything=true
    to_reload=[]
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['units','unit'])
    # UNIT DATA
    if File.exist?("#{$location}devkit/FEHUnits.txt")
      b=[]
      File.open("#{$location}devkit/FEHUnits.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $units=[]
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHUnit.new(b[i][0])
      bob4.weapon=b[i][1].split(', ') # weapon classification is actually a two-part entry (three-part for mages)
      bob4.legendary=b[i][2].split(', ') if b[i][2].length>1 # Legendary Hero type is a two-part entry
      bob4.movement=b[i][3]
      bob4.growths=b[i][4].split(', ').map{|q| q.to_i}
      bob4.stats40=b[i][5].split(', ').map{|q| q.to_i}
      bob4.artist=b[i][6].split(';; ') if b[i][6].length>0
      bob4.voice=b[i][7].split(';; ') if b[i][7].length>0
      bob4.id=b[i][8].to_i
      bob4.availability=b[i][9].split(', ') if b[i][9].length>0
      bob4.gender=b[i][10]
      bob4.games=b[i][11].split(', ') if b[i][11].length>0 # the list of games should be spliced into an array of game abbreviations
      bob4.alts=b[i][12].split(', ')
      bob4.fake=[b[i][13].scan(/[[:alpha:]]+?/).join, b[i][13].gsub(b[i][13].scan(/[[:alpha:]]+?/).join,'').to_i] unless b[i][13].nil?
      $units.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['skills','skill'])
    # SKILL DATA
    if File.exist?("#{$location}devkit/FEHSkills.txt")
      b=[]
      File.open("#{$location}devkit/FEHSkills.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $skills=[]
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHSkill.new(b[i][1])
      bob4.id=b[i][0].to_i
      bob4.type=b[i][6]
      bob4.level=b[i][2]
      bob4.sp_cost=b[i][3]
      bob4.might=b[i][4]
      bob4.range=b[i][5]
      bob4.restrictions=b[i][7]
      bob4.exclusivity=b[i][8] unless b[i][8].nil? || b[i][8]=='-'
      bob4.description=b[i][9]
      bob4.prerequisite=b[i][10] unless b[i][10]=='-'
      bob4.summon=b[i][11]
      bob4.learn=b[i][12]
      bob4.tags=b[i][13]
      bob4.weapon_stats=b[i][14]
      bob4.fake=b[i][15]
      bob4.evolutions=b[i][16]
      bob4.refine=b[i][17]
      $skills.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['structures','structure'])
    # STRUCTURE DATA
    if File.exist?("#{$location}devkit/FEHStructures.txt")
      b=[]
      File.open("#{$location}devkit/FEHStructures.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $structures=[]
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHStructure.new(b[i][0])
      bob4.level=b[i][1]
      bob4.type=b[i][2]
      bob4.description=b[i][3]
      bob4.destructable=b[i][4]
      bob4.costs=b[i][5]
      bob4.ar_tier=b[i][6]
      bob4.note=b[i][7] unless b[i][7].nil?
      $structures.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['items','item'])
    # ITEM DATA
    if File.exist?("#{$location}devkit/FEHItems.txt")
      b=[]
      File.open("#{$location}devkit/FEHItems.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $itemus=[]
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHItem.new(b[i][0])
      bob4.type=b[i][1]
      bob4.maximum=b[i][2]
      bob4.description=b[i][3]
      bob4.note=b[i][4]
      $itemus.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['accessories','accessory'])
    # ITEM DATA
    if File.exist?("#{$location}devkit/FEHAccessories.txt")
      b=[]
      File.open("#{$location}devkit/FEHAccessories.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $accessories=[]
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHAccessory.new(b[i][0])
      bob4.type=b[i][1]
      bob4.description=b[i][2]
      bob4.obtain=b[i][3]
      bob4.note=b[i][4]
      $accessories.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['bonus'])
    # BONUS DATA
    if File.exist?("#{$location}devkit/FEHArenaTempest.txt")
      b=[]
      File.open("#{$location}devkit/FEHArenaTempest.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $bonus_units=[]
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHBonus.new
      bob4.bonuses=b[i][0]
      bob4.type=b[i][1]
      bob4.date=b[i][2]
      bob4.subdata=b[i][3]
      $bonus_units.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['banner','banners'])
    # BANNER DATA
    if File.exist?("#{$location}devkit/FEHBanners.txt")
      b=[]
      File.open("#{$location}devkit/FEHBanners.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $banners=[]
    for i in 0...b.length
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHBanner.new(b[i][0])
      bob4.starting_focus=b[i][1]
      bob4.banner_units=b[i][2]
      bob4.focus_rarities=b[i][3]
      bob4.date=b[i][4] unless b[i][4].nil? || b[i][4].length<=0
      bob4.tags=b[i][5] unless b[i][5].nil? || b[i][5].length<=0
      $banners.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['event','events'])
    # EVENT DATA
    if File.exist?("#{$location}devkit/FEHEvents.txt")
      b=[]
      File.open("#{$location}devkit/FEHEvents.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $events=[]
    for i in 0...b.length
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHEvent.new(b[i][0])
      bob4.type=b[i][1]
      bob4.date=b[i][2] unless b[i][2].nil? || b[i][2].length<=0
      $events.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['groups','group'])
    # GROUP DATA
    if File.exist?("#{$location}devkit/FEHGroups.txt")
      b=[]
      File.open("#{$location}devkit/FEHGroups.txt").each_line do |line|
        b.push(eval line)
      end
    else
      b=[]
    end
    $groups=[]
    for i in 0...b.length
      bob4=FEHGroup.new(b[i][0])
      bob4.units=b[i][1]
      bob4.fake=b[i][2] unless b[i][2].nil?
      $groups.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['tags','tag'])
    $skilltags=[]
    if File.exist?("#{$location}devkit/FEHSkillSubsets.txt")
      File.open("#{$location}devkit/FEHSkillSubsets.txt").each_line do |line|
        $skilltags.push(eval line)
      end
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['games','game'])
    $origames=[]
    if File.exist?("#{$location}devkit/FEHGames.txt")
      File.open("#{$location}devkit/FEHGames.txt").each_line do |line|
        $origames.push(eval line)
      end
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['stats','stat'])
    $statskills=[]
    if File.exist?("#{$location}devkit/FEHStatSkills.txt")
      File.open("#{$location}devkit/FEHStatSkills.txt").each_line do |line|
        $statskills.push(eval line)
      end
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['libraries','library','librarys'])
    rtime=5
    rtime=1 if Shardizard==4
    rtime=60 if to_reload.length<=0 && !reload_everything
    t=Time.now
    if t-$last_multi_reload[0]>rtime*60
      puts 'reloading EliseClassFunctions'
      load "#{$location}devkit/EliseClassFunctions.rb"
      unless !$spanishShard.nil? && Shardizard != $spanishShard
        puts 'reloading Elispanol'
        load "#{$location}devkit/Elispanol.rb"
      end
      $last_multi_reload[0]=t
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['path','code','paths','codes'])
    # DIVINE CODE DATA
    if File.exist?("#{$location}devkit/FEHPath.txt")
      b=[]
      File.open("#{$location}devkit/FEHPath.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    $paths=[]
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FEHPath.new(b[i][0])
      for i2 in 1...b[i].length
        if b[i][i2].include?('/')
          bob4.date=b[i][i2]
        else
          bob4.new_code(b[i][i2])
        end
      end
      $paths.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['devunits'])
    # DEV UNIT DATA
    if File.exist?("#{$location}devkit/FEHDevUnits.txt")
      b=[]
      File.open("#{$location}devkit/FEHDevUnits.txt").each_line do |line|
        b.push(line.gsub("\n",''))
      end
    else
      b=[]
    end
    $dev_units=[]
    $dev_waifus=b[0].split('\\'[0])
    $dev_somebodies=b[1].split('\\'[0])
    $dev_nobodies=b[2].split('\\'[0])
    devpass=true
    devpass=false if b[3].downcase=='pass'
    devpass=false if b[3].downcase=='feh pass'
    devpass=false if b[3].downcase=='fehpass'
    b.shift; b.shift; b.shift; b.shift; b.shift
    for i in 0...b.length/10
      bob4=DevUnit.new(b[i*10],0)
      m=b[i*10+1].split('\\'[0])
      bob4.rarity=m[0]
      bob4.merge_count=m[1]
      bob4.boon=m[2]
      bob4.bane=m[3]
      bob4.support_load(m[4],devpass)
      bob4.dragonflowers=m[5]
      bob4.cohort=m[6] unless m[6].nil?
      bob4.skills=[]
      bob4.skills.push(b[i*10+2].gsub("\n",'').split('\\'[0]))
      bob4.skills.push(b[i*10+3].gsub("\n",'').split('\\'[0]))
      bob4.skills.push(b[i*10+4].gsub("\n",'').split('\\'[0]))
      bob4.skills.push(b[i*10+5].gsub("\n",'').split('\\'[0]))
      bob4.skills.push(b[i*10+6].gsub("\n",'').split('\\'[0]))
      bob4.skills.push(b[i*10+7].gsub("\n",'').split('\\'[0]))
      bob4.skills.push(b[i*10+8].gsub("\n",'').split('\\'[0]))
      $dev_units.push(bob4)
    end
  end
  if to_reload.length<=0 || has_any?(to_reload.map{|q| q.downcase},['donorunits'])
    d=Dir["#{$location}devkit/EliseUserSaves/*.txt"]
    $donor_units=[]
    $donor_triggers=[]
    for i in 0...d.length
      b=[]
      File.open(d[i]).each_line do |line|
        b.push(line.gsub("\n",''))
      end
      d[i]=d[i].gsub("#{$location}devkit/EliseUserSaves/",'').gsub('.txt','').to_i
      if get_donor_list().reject{|q| q[2][0]<4}.map{|q| q[0]}.include?(d[i])
        owr="#{b[0]}"
        $donor_triggers.push([owr.split('\\'[0])[0],d[i],owr.split('\\'[0])[1],owr.split('\\'[0])[2]])
        b.shift; b.shift
        for i2 in 0...b.length/10
          bob4=DonorUnit.new(b[i2*10],0,owr,d[i])
          m=b[i2*10+1].split('\\'[0])
          bob4.rarity=m[0]
          bob4.merge_count=m[1]
          bob4.boon=m[2]
          bob4.bane=m[3]
          bob4.support=m[4]
          bob4.dragonflowers=m[5]
          bob4.cohort=m[6] unless m[6].nil?
          bob4.skills=[]
          bob4.skills.push(b[i2*10+2].gsub("\n",'').split('\\'[0]))
          bob4.skills.push(b[i2*10+3].gsub("\n",'').split('\\'[0]))
          bob4.skills.push(b[i2*10+4].gsub("\n",'').split('\\'[0]))
          bob4.skills.push(b[i2*10+5].gsub("\n",'').split('\\'[0]))
          bob4.skills.push(b[i2*10+6].gsub("\n",'').split('\\'[0]))
          bob4.skills.push(b[i2*10+7].gsub("\n",'').split('\\'[0]))
          bob4.skills.push(b[i2*10+8].gsub("\n",'').split('\\'[0]))
          $donor_units.push(bob4)
        end
      end
    end
  end
  if has_any?(to_reload.map{|q| q.downcase},['fgo','servants','crafts','servant','craft'])
    $fgo_servants=[]
    if File.exist?("#{$location}devkit/FGOServants.txt")
      b=[]
      File.open("#{$location}devkit/FGOServants.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FGOServant.new(b[i][0])
      bob4.name=b[i][1]
      bob4.artist=b[i][24] unless b[i][24].nil?
      bob4.voice_jp=b[i][25] unless b[i][25].nil?
      $fgo_servants.push(bob4)
    end
    if File.exist?("#{$location}devkit/FGOCraftEssances.txt")
      b=[]
      File.open("#{$location}devkit/FGOCraftEssances.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=FGO_CE.new(b[i][0])
      bob4.name=b[i][1]
      bob4.artist=b[i][9] unless b[i][9].nil?
      $fgo_crafts.push(bob4)
    end
  end
  if has_any?(to_reload.map{|q| q.downcase},['dl','dragalia','adventurer','adventurers','wyrm','wyrms','print','prints'])
    $dl_adventurers=[]
    if File.exist?("#{$location}devkit/DLAdventurers.txt")
      b=[]
      File.open("#{$location}devkit/DLAdventurers.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=DLSentient.new(b[i][0])
      bob4.voice_na=b[i][11] unless b[i][11].nil?
      bob4.voice_jp=b[i][10] unless b[i][10].nil?
      $dl_adventurers.push(bob4)
    end
    $dl_dragons=[]
    if File.exist?("#{$location}devkit/DLDragons.txt")
      b=[]
      File.open("#{$location}devkit/DLDragons.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=DLSentient.new(b[i][0])
      bob4.voice_na=b[i][14] unless b[i][14].nil?
      bob4.voice_jp=b[i][13] unless b[i][13].nil?
      $dl_dragons.push(bob4)
    end
    $dl_npcs=[]
    if File.exist?("#{$location}devkit/DL_NPCs.txt")
      b=[]
      File.open("#{$location}devkit/DL_NPCs.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=DLSentient.new(b[i][0])
      bob4.voice_na=b[i][3] unless b[i][3].nil?
      bob4.voice_jp=b[i][4] unless b[i][4].nil?
      $dl_npcs.push(bob4)
    end
    $dl_wyrmprints=[]
    if File.exist?("#{$location}devkit/DLWyrmprints.txt")
      b=[]
      File.open("#{$location}devkit/DLWyrmprints.txt").each_line do |line|
        b.push(line)
      end
    else
      b=[]
    end
    for i in 0...b.length
      b[i]=b[i][1,b[i].length-1] if b[i][0,1]=='"'
      b[i]=b[i][0,b[i].length-1] if b[i][-1,1]=='"'
      b[i]=b[i].gsub("\n",'').split('\\'[0])
      bob4=DLPrint.new(b[i][0])
      bob4.artist=b[i][7] unless b[i][7].nil?
      $dl_wyrmprints.push(bob4)
    end
  end
end

def metadata_load() # loads the metadata - users who choose to see plaintext over embeds, data regarding each shard's server count, number of headpats received, etc.
  if File.exist?("#{$location}devkit/FEHSave.txt")
    b=[]
    File.open("#{$location}devkit/FEHSave.txt").each_line do |line|
      b.push(eval line)
    end
  else
    b=[[],[],[0,0],[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]],[0,0,0],[],[],[]]
  end
  $embedless=b[0]
  $embedless=[168592191189417984, 256379815601373184] if $embedless.nil?
  @ignored=b[1]
  @ignored=[] if @ignored.nil?
  $summon_rate=b[2]
  $summon_rate=[0,0,3] if $summon_rate.nil?
  @server_data=b[3]
  @server_data=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] if @server_data.nil?
  if @server_data[0].length<Shards+1
    for i in 0...Shards+1
      @server_data[0][i]=0 if @server_data[0][i].nil?
    end
  end
  if @server_data[1].length<Shards+1
    for i in 0...Shards+1
      @server_data[1][i]=0 if @server_data[1][i].nil?
    end
  end
  @headpats=b[4] unless b[4].nil?
  $server_markers=b[5] unless b[5].nil?
  $x_markers=b[6] unless b[6].nil?
  $spam_channels=b[7]
  $spam_channels=[407149643923849218] if $spam_channels.nil?
end

def metadata_save() # saves the metadata
  if @server_data[0].length<Shards+1
    for i in 0...Shards+1
      @server_data[0][i]=0 if @server_data[0][i].nil?
    end
  end
  if @server_data[1].length<Shards+1
    for i in 0...Shards+1
      @server_data[1][i]=0 if @server_data[1][i].nil?
    end
  end
  x=[$embedless.map{|q| q}, @ignored.map{|q| q}, $summon_rate.map{|q| q}, @server_data.map{|q| q}, @headpats.map{|q| q}, $server_markers.map{|q| q}, $x_markers.map{|q| q}, $spam_channels.map{|q| q}]
  open("#{$location}devkit/FEHSave.txt", 'w') { |f|
    f.puts x[0].to_s
    f.puts x[1].to_s
    f.puts x[2].to_s
    f.puts x[3].to_s
    f.puts x[4].to_s
    f.puts x[5].to_s
    f.puts x[6].to_s
    f.puts x[7].to_s
    f.puts "\n"
  }
end

def nicknames_load() # loads the nickname list
  if File.exist?("#{$location}devkit/FEHNames.txt")
    b=[]
    File.open("#{$location}devkit/FEHNames.txt").each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  $aliases=b.reject{|q| q.nil? || q[1].nil?}.uniq
  t=Time.now
  $aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
end

def prefixes_save()
  x=@prefixes
  open("C:/Users/#{@mash}/Desktop/devkit/FEHPrefix.rb", 'w') { |f|
    f.puts x.to_s.gsub('=>',' => ').gsub(', ',",\n  ").gsub('{',"@prefixes = {\n  ").gsub('}',"\n}")
  }
end

def donate_trigger_word(event,str=nil)
  str=event.message.text if str.nil?
  str=str.downcase
  data_load(['donorunits'])
  b=$donor_triggers.map{|q| q}
  for i in 0...b.length
    return b[i][1] if str.split(' ').include?("#{b[i][0].downcase}'s")
    return b[i][1] if str.split(' ').include?("de#{b[i][0].downcase}") && Shardizard==$spanishShard
    return b[i][1] if event.user.id==b[i][1] && str.split(' ').include?('my')
    return b[i][1] if event.user.id==b[i][1] && str.split(' ').include?('mi') && Shardizard==$spanishShard
  end
  return 0
end

def safe_to_spam?(event,chn=nil) # determines whether or not it is safe to send extremely long messages
  return true if event.server.nil? # it is safe to spam in PM
  return false if event.user.id==213048998678888448
  return false if event.message.text.downcase.split(' ').include?('smol') && Shardizard==4
  return false if event.message.text.downcase.split(' ').include?('xsmol') && [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,691616574393811004,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388].include?(event.server.id) # it is safe to spam in the emoji servers
  return true if [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,691616574393811004,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388].include?(event.server.id) # it is safe to spam in the emoji servers
  return true if Shardizard==4 # it is safe to spam during debugging
  chn=event.channel if chn.nil?
  return true if ['bots','bot'].include?(chn.name.downcase) # channels named "bots" are safe to spam in
  return true if chn.name.downcase.include?('bot') && chn.name.downcase.include?('spam') # it is safe to spam in any bot spam channel
  return true if chn.name.downcase.include?('bot') && chn.name.downcase.include?('command') # it is safe to spam in any bot spam channel
  return true if chn.name.downcase.include?('bot') && chn.name.downcase.include?('channel') # it is safe to spam in any bot spam channel
  return true if chn.name.downcase.include?('elisebot')  # it is safe to spam in channels designed specifically for EliseBot
  return true if chn.name.downcase.include?('elise-bot')
  return true if chn.name.downcase.include?('elise_bot')
  return true if $spam_channels.include?(chn.id)
  return false
end

def overlap_prevent(event) # used to prevent servers with both Elise and her debug form from receiving two replies
  if event.server.nil? # failsafe code catching PMs as not a server
    return false
  elsif event.message.text.downcase.split(' ').include?('debug') && [443172595580534784,443704357335203840,443181099494146068,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,691616574393811004,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,572792502159933440].include?(event.server.id)
    return ![4].include?(Shardizard) # the debug bot can be forced to be used in the emoji servers by including the word "debug" in your message
  elsif event.message.text.downcase.split(' ').include?('smol') && [443172595580534784,443704357335203840,443181099494146068,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,691616574393811004,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,572792502159933440].include?(event.server.id)
    return ![-1].include?(Shardizard) # the debug bot can be forced to be used in the emoji servers by including the word "debug" in your message
  elsif [443172595580534784,443704357335203840,443181099494146068,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,691616574393811004,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,572792502159933440].include?(event.server.id) # emoji servers will use default Elise otherwise
    return [4,-1].include?(Shardizard)
  elsif event.server.id==332249772180111360 # two identical commands cannot be used in the same minute in the FEHKeeper server
    canpost=true
    post=Time.now
    if (post - @zero_by_four[2]).to_f > 60
      @zero_by_four[2]=post
    else
      canpost=false
    end
    s=event.message.text.downcase
    s=remove_prefix(s,event)
    return true if !canpost && s==@zero_by_four[3]
    @zero_by_four[3]=s
    return false
  end
  return false
end

def remove_prefix(s,event)
  s=s[2,s.length-2] if ['f?','e?','h?','f!','d?','d!'].include?(s.downcase[0,2])
  s=s[4,s.length-4] if ['feh!','feh?'].include?(s.downcase[0,4])
  x=nil
  x=@prefixes[event.server.id] unless event.server.nil?
  s=s[x.length,s.length-x.length] if !x.nil? && x.length>0 && [x.downcase].include?(s.downcase[0,x.length])
  return s
end

def all_commands(include_nil=false,permissions=-1)
  k=['reboot','boop','safe','spam','safetospam','safe2spam','long','longreplies','channellist','channelist','spamchannels','spamlist','skills','skils','fodder','manual','book','smol','combatmanual','alt',
     'skill','skil','color','colors','colour','colours','stats','stat','tinystats','smallstats','smolstats','microstats','squashedstats','sstats','statstiny','little','statssmall','statssmol','studyproc',
     'statsmicro','statssquashed','statss','stattiny','statsmall','statsmol','statmicro','statsquashed','sstat','tinystat','smallstat','smolstat','microstat','squashedstat','tiny','small','micro','daily',
     'squashed','littlestats','littlestat','statslittle','statlittle','prefix','flowers','flower','tol','macro','large','bigstats','tolstats','macrostats','largestats','bigstat','tolstat','skillearnable',
     'largestat','statsbig','statstol','statsmacro','statslarge','statbig','stattol','statmacro','statlarge','statol','big','huge','massive','giantstats','hugestats','massivestats','giantstat','schedule',
     'hugestat','massivestat','statsgiant','statshuge','statsmassive','statgiant','stathuge','statmassive','hero','unit','data','statsskills','statskills','stats_skills','stat_skills','inheritable_skill',
     'statandskills','stats_and_skills','stat_and_skills','statsskill','statskill','statskil','stats_skill','stat_skill','statsandskill','statandskill','stats_and_skill','stat_and_skill','resonancebonus',
     'statskils','stats_skils','stat_skils','statsandskils','statandskils','stats_and_skils','stat_and_skils','statsskil','stats_skil','stat_skil','statsandskil','statandskil','stats_and_skil','refinery',
     'stat_and_skil','bugreport','suggestion','feedback','shard','status','avatar','avvie','donation','donate','sendpm','ignoreuser','sendmessage','leaveserver','cleanupaliases','backup','statsandskills',
     'legendary','legendaries','legendarys','legend','legends','mythic','mythical','mythics','mythicals','mystic','mystical','mystics','mysticals','invite','score','merges','whoisoregano','bonusresonant',
     'oregano','growths','growth','gp','natures','headpat','patpat','pat','embeds','embed','groups','seegroups','checkgroups','find','search','lookup','update','sort','list','tools','links','tool','pool',
     'link','resources','resource','aoe','area','sortskill','skillsort','sortskills','skillssort','listskill','skillist','skillist','listskills','skillslist','sortstats','statssort','sortstat','two_star',
     'statsort','liststats','statslist','statlist','liststat','sortunits','unitssort','sortunit','unitsort','listunits','unitslist','unitlist','listunit','average','mean','bestamong','bestin','resonance',
     'beststats','higheststats','highest','best','highestamong','highestin','worstamong','worstin','worststats','loweststats','lowest','worst','lowestamong','lowestin','arena','arenabonus','aether_bonus',
     'bonusarena','bonus_arena','tempest','tempestbonus','tempest_bonus','bonustempest','bonus_tempest','tt','ttbonus','tt_bonus','bonustt','bonus_tt','aether','aetherbonus','arena_bonus','resonantbonus',
     'four_star','five_star','rand','random','randomunit','item','randunit','unitrandom','unitrand','randomstats','statsrand','statsrandom','randstats','banners','banner','summonpool','summon_pool','ghb',
     'skilllearn','skilllearnable','skillsinheritance','skillsinherit','skillsinheritable','skillslearn','skillslearnable','pair','inheritanceskills','inheritskill','inheritableskill','learnskill','proc',
     'learnableskill','inheritanceskills','inheritskills','inheritableskills','learnskills','learnableskills','all_inheritance','all_inherit','all_inheritable','skill_inheritance','skill_inherit','learn',
     'aethertempest','aether_tempest','raid','raidbonus','raid_bonus','bonusraid','bonus_raid','raidsbonus','bonusraids','raids_bonus','bonus_raids','bonus','attackicon','attackcolor','skills_comparison',
     'attackcolour','attackcolours','atkicon','atkcolor','atkcolors','atkcolour','atkcolours','atticon','attcolor','attcolors','attcolour','attcolours','staticon','statcolor','statcolors','inherit_skill',
     'skills_in_common','art','common_skills','comparisonskill','skillcomparison','skillscomparison','compare_skills','compare_skill','skill_compare','skills_compare','comparison_skills','devedit','heal',
     'inheritable','skillearn','macrostat','pocket','healstudy','heal_study','studyheal','study_heal','proc_study','compare','study_proc','phasestudy','studyphase','phase_study','study_phase','statstudy',
     'comparison_skill','skill_comparison','removefrommulti','skillsincommon','commonskills','addgroup','removemember','removefromgroup','removefrommultialias','removefromdualalias','attackcolors','edit',
     'greil','grail','study','statstudy','studystats','effhp','eff_hp','bulk','allinheritance','allinherit','allinheritable','skillinheritance','skillinherit','skillinheritable','gps','procstudy','phase',
     'statcolours','iconcolor','iconcolors','iconcolour','iconcolours','whyelise','skillrarity','onestar','twostar','threestar','fourstar','fivestar','skill_rarity','one_star','colores','learnable_skill',
     'bst','summon','help','command_list','acc','commands','reload','commandlist','snagstats','struct','structure','accessory','accessorie','aliases','checkaliases','seealiases','deletealias','dualalias',
     'removefrommultiunitalias','removefromdualunitalias','addmultialias','adddualalias','addualalias','addmultiunitalias','adddualunitalias','addualunitalias','multialias','artist','resonant','addmulti',
     'removealias','addalias','alias','refine','effect','bst','comparison','compareskills','compareskill','skillcompare','skillscompare','comparisonskills','bonus_resonance','dev_edit','learnable_skills',
     'raids','deletegroup','removegroup','alts','games','next','today','tomorrow','tomorow','tommorrow','tommorow','todayinfeh','today_in_feh','prfs','now','divine','devine','code','statcolour','inherit',
     'path','saliases','skill_inheritable','skill_learn','skill_learnable','skills_inheritance','skills_inherit','skills_inheritable','skills_learn','skills_learnable','inheritance_skills','pairup','prf',
     'learn_skill','three_star','inheritance_skills','pair_up','inherit_skills','inheritable_skills','learn_skills','resonance_bonus','inheritance','learnable','resonant_bonus','whyoregano','statsskills',
     'bonus_resonant','setmarker','bonusresonance','donacion']
  if permissions==0
    k=all_commands(false)-all_commands(false,1)-all_commands(false,2)
  elsif permissions==1
    k=['addalias','deletealias','removealias','addgroup','deletegroup','removegroup','removemember','removefromgroup','prefix']
  elsif permissions==2
    k=['reboot','addmultialias','adddualalias','addualalias','addmultiunitalias','adddualunitalias','addualunitalias','multialias','dualalias','addmulti','dev_edit','devedit',
       'removemultiunitalias','removedualunitalias','removemulti','removefrommultialias','removefromdualalias','removefrommultiunitalias','backup','update','removefromdualunitalias',
       'removefrommulti','sendpm','ignoreuser','sendmessage','leaveserver','cleanupaliases','setmarker','snagchannels','reload']
  end
  k.uniq!
  k.unshift(nil) if include_nil
  return k
end

bot.command(:help, aliases: [:commands,:command_list,:commandlist,:Help]) do |event, command, subcommand| # used to show tooltips regarding each command.  If no command name is given, shows a list of all commands
  return nil if overlap_prevent(event)
  data_load()
  help_text(event,bot,command,subcommand)
  return nil
end

bot.command(:reboot, from: 167657750971547648) do |event| # reboots Elise
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  puts 'FEH!reboot'
  exec "cd #{$location}devkit && PriscillaBot.rb #{Shardizard}"
end

def find_data_ex(callback,event,args=nil,xname=nil,bot=nil,fullname=false,ext=false,mode=0)
  args=event.message.text.split(' ') if args.nil?
  xname=args.join(' ') if xname.nil?
  if [:find_unit,:find_skill,:find_skill,:find_structure,:find_item_feh,:find_accessory,:find_FGO_servant].include?(callback)
    k=method(callback).call(event,args,xname,bot,true,ext)
    return [k,xname] if !k.nil? && mode==1
    return k if !k.nil?
    args=xname.split(' ')
    for i in 0...args.length
      for i2 in 0...args.length-i
        k=method(callback).call(event,args[i,args.length-i-i2],args[i,args.length-i-i2].join(''),bot,true,ext)
        return [k,args[i,args.length-i-i2].join(' ')] if !k.nil? && args[i,args.length-i-i2].length>0 && mode==1
        return k if !k.nil? && args[i,args.length-i-i2].length>0
      end
    end
    return nil if fullname || xname.length<=2
    k=method(callback).call(event,args,xname,bot,false,ext)
    return [k,xname] if !k.nil? && mode==1
    return k if !k.nil?
    args=xname.split(' ')
    for i in 0...args.length
      for i2 in 0...args.length-i
        k=method(callback).call(event,args[i,args.length-i-i2],args[i,args.length-i-i2].join(''),bot,false,ext)
        return [k,args[i,args.length-i-i2].join(' ')] if !k.nil? && args[i,args.length-i-i2].length>0 && mode==1
        return k if !k.nil? && args[i,args.length-i-i2].length>0
      end
    end
    return nil
  else
    k=method(callback).call(event,args,xname,bot,true,ext)
    return [k,xname] if k>=0 && mode==1
    return k if k>=0
    args=xname.split(' ')
    for i in 0...args.length
      for i2 in 0...args.length-i
        k=method(callback).call(event,args[i,args.length-i-i2],args[i,args.length-i-i2].join(''),bot,true,ext)
        return [k,args[i,args.length-i-i2].join(' ')] if k>=0 && args[i,args.length-i-i2].length>0 && mode==1
        return k if k>=0 && args[i,args.length-i-i2].length>0
      end
    end
    return -1 if fullname || xname.length<=2
    k=method(callback).call(event,args,xname,bot,false,ext)
    return [k,xname] if k>=0 && mode==1
    return k if k>=0
    args=xname.split(' ')
    for i in 0...args.length
      for i2 in 0...args.length-i
        k=method(callback).call(event,args[i,args.length-i-i2],args[i,args.length-i-i2].join(''),bot,false,ext)
        return [k,args[i,args.length-i-i2].join(' ')] if k>=0 && args[i,args.length-i-i2].length>0 && mode==1
        return k if k>=0 && args[i,args.length-i-i2].length>0
      end
    end
    return -1
  end
end

def find_best_match(event,args=nil,xname=nil,bot=nil,fullname=false,mode=1)
  data_load()
  functions=[[:find_unit,:disp_unit_stats],
             [:find_skill,:disp_skill_data],
             [:find_structure,:disp_struct],
             [:find_item_feh,:disp_itemu],
             [:find_accessory,:disp_accessory]]
  args=event.message.text.split(' ') if args.nil?
  xname2=remove_prefix(args.join(' '),event)
  xname=remove_prefix(args.join(''),event) if xname.nil?
  for i3 in 0...functions.length
    k=method(functions[i3][0]).call(event,args,xname,bot,true)
    return k if mode==0 && !k.nil?
    if k.is_a?(Array)
      return method(functions[i3][mode]).call(bot,event,k.map{|q| q.name},nil,'smol',true) if !functions[i3][mode].nil? && !k.nil? && functions[i3][mode]==:disp_unit_stats
      return method(functions[i3][mode]).call(bot,event,k.map{|q| q.name}) if !functions[i3][mode].nil? && !k.nil?
    else
      return method(functions[i3][mode]).call(bot,event,k.name,nil,'smol',true) if !functions[i3][mode].nil? && !k.nil? && functions[i3][mode]==:disp_unit_stats
      return method(functions[i3][mode]).call(bot,event,k.name) if !functions[i3][mode].nil? && !k.nil?
    end
  end
  args=xname2.split(' ')
  for i in 0...args.length
    for i2 in 0...args.length-i
      for i3 in 0...functions.length
        k=method(functions[i3][0]).call(event,args[i,args.length-i-i2],nil,bot,true)
        return k if mode==0 && !k.nil?
        w=first_sub(event.message.text.downcase,args[i,args.length-i-i2].join(' ').downcase,'')
        if k.is_a?(Array)
          return method(functions[i3][mode]).call(bot,event,k.map{|q| q.name},w,'smol',true) if !functions[i3][mode].nil? && !k.nil? && functions[i3][mode]==:disp_unit_stats
          return method(functions[i3][mode]).call(bot,event,k.map{|q| q.name}) if !functions[i3][mode].nil? && !k.nil? && args[i,args.length-i-i2].length>0
        else
          return method(functions[i3][mode]).call(bot,event,k.name,w,'smol',true) if !functions[i3][mode].nil? && !k.nil? && functions[i3][mode]==:disp_unit_stats
          return method(functions[i3][mode]).call(bot,event,k.name) if !functions[i3][mode].nil? && !k.nil? && args[i,args.length-i-i2].length>0
        end
      end
    end
  end
  event.respond nomf() if (fullname || xname.length<=2) && mode>1
  return nil if fullname || xname.length<=2
  for i3 in 0...functions.length
    k=method(functions[i3][0]).call(event,args,xname,bot)
    return k if mode==0 && !k.nil?
    if k.is_a?(Array)
      return method(functions[i3][mode]).call(bot,event,k.map{|q| q.name},nil,'smol',true) if !functions[i3][mode].nil? && !k.nil? && functions[i3][mode]==:disp_unit_stats
      return method(functions[i3][mode]).call(bot,event,k.map{|q| q.name}) if !functions[i3][mode].nil? && !k.nil?
    else
      return method(functions[i3][mode]).call(bot,event,k.name,nil,'smol',true) if !functions[i3][mode].nil? && !k.nil? && functions[i3][mode]==:disp_unit_stats
      return method(functions[i3][mode]).call(bot,event,k.name) if !functions[i3][mode].nil? && !k.nil?
    end
  end
  args=xname2.split(' ')
  for i in 0...args.length
    for i2 in 0...args.length-i
      for i3 in 0...functions.length
        k=method(functions[i3][0]).call(event,args[i,args.length-i-i2],nil,bot)
        return k if mode==0 && !k.nil?
        w=first_sub(event.message.text.downcase,args[i,args.length-i-i2].join(' ').downcase,'')
        if k.is_a?(Array)
          return method(functions[i3][mode]).call(bot,event,k.map{|q| q.name},w,'smol',true) if !functions[i3][mode].nil? && !k.nil? && functions[i3][mode]==:disp_unit_stats
          return method(functions[i3][mode]).call(bot,event,k.map{|q| q.name}) if !functions[i3][mode].nil? && !k.nil? && args[i,args.length-i-i2].length>0
        else
          return method(functions[i3][mode]).call(bot,event,k.name,w,'smol',true) if !functions[i3][mode].nil? && !k.nil? && functions[i3][mode]==:disp_unit_stats
          return method(functions[i3][mode]).call(bot,event,k.name) if !functions[i3][mode].nil? && !k.nil? && args[i,args.length-i-i2].length>0
        end
      end
    end
  end
  event.respond nomf() if mode>1
  return nil
end

def find_unit(event,args=nil,xname=nil,bot=nil,fullname=false,ext=0)
  data_load(['unit'])
  args=event.message.text.split(' ') if args.nil?
  xname=args.join('') if xname.nil?
  xname=normalize(xname.gsub('!',''))
  if xname.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    buff=xname.split(':')[1]
    buff=buff[3,buff.length-3] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,3].downcase=='gp_'
    buff=buff[2,buff.length-2] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,2].downcase=='gp'
    xname=buff unless find_unit(event,args,buff,bot,fullname).nil?
  end
  xname=xname.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')
  untz=$units.reject{|q| !q.isPostable?(event)}
  if event.user.id==131131245118619648 && xname=='me'
    x=untz.find_index{|q| q.name.downcase.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','')=='merric'}
    return untz[x] unless x.nil?
  end
  x=untz.find_index{|q| q.name.downcase.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','')==xname.downcase}
  return untz[x] unless x.nil?
  nicknames_load()
  alz=$aliases.reject{|q| q[0]!='Unit'}
  k=0
  k=event.server.id unless event.server.nil?
  x=alz.find_index{|q| q[1].gsub('||','').downcase==xname.downcase && (q[3].nil? || q[3].include?(k))}
  if x.nil?
  elsif alz[x][2].is_a?(Array)
    x2=alz[x][2].map{|q| untz.find_index{|q2| (!q.is_a?(String) && q2.id==q) || (q.is_a?(String) && q2.name.downcase==q.downcase)}}
    x2.compact!
    return nil if x2.length<=0
    return untz[x2[0]] if x2.length==1
    return x2.map{|q| untz[q]}
  else
    x2=untz.find_index{|q| q.id==alz[x][2]}
    x2=untz.find_index{|q| q.name.downcase==alz[x][2].downcase} if alz[x][2].is_a?(String)
    return untz[x2] unless x2.nil?
  end
  if [event.user.name,event.user.display_name].map{|q| normalize(q.downcase).gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','')}.include?(xname.downcase)
    x=untz.find_index{|q| q.name=='Kiran'}
    return untz[x] unless x.nil?
  end
  return nil if fullname || xname.length<2
  x=untz.find_index{|q| q.name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','')[0,xname.length].downcase==xname.downcase}
  return untz[x] unless x.nil?
  x=alz.find_index{|q| q[1].gsub('||','')[0,xname.length].downcase==xname.downcase && (q[3].nil? || q[3].include?(k))}
  if x.nil?
  elsif alz[x][2].is_a?(Array)
    x2=alz[x][2].map{|q| untz.find_index{|q2| (!q.is_a?(String) && q2.id==q) || (q.is_a?(String) && q2.name.downcase==q.downcase)}}
    x2.compact!
    return nil if x2.length<=0
    return untz[x2[0]] if x2.length==1
    return x2.map{|q| untz[q]}
  else
    x2=untz.find_index{|q| q.id==alz[x][2]}
    x2=untz.find_index{|q| q.name.downcase==alz[x][2].downcase} if alz[x][2].is_a?(String)
    return untz[x2] unless x2.nil?
  end
  # allow the word "launch" to work as a modifier for launch units without official modifiers, even if there's no actual alias for this.
  if xname.downcase.include?('launch')
    untz2=untz.reject{|q| q.name.include?('(') || ['Veronica','Bruno'].include?(q.name) || q.id>100 || !q.fake.nil?}
    xname2=xname.downcase.gsub('launch','')
    x=untz2.find_index{|q| q.name.downcase.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','')==xname2.downcase}
    return untz2[x] unless x.nil?
    alz2=alz.reject{|q| q[2].is_a?(Array) || (q[2].is_a?(String) && untz.map{|q2| q2.name}.include?(q[2])) || (!q[2].is_a?(String) && untz.map{|q2| q2.id}.include?(q[2]))}
    x=alz2.find_index{|q| q[1].gsub('||','').downcase==xname2.downcase && (q[3].nil? || q[3].include?(k))}
    unless x.nil?
      x2=untz2.find_index{|q| q.id==alz2[x][2]}
      x2=untz2.find_index{|q| q.name.downcase==alz2[x][2].downcase} if alz2[x][2].is_a?(String)
      return untz2[x2] unless x2.nil?
    end
  end
  if [event.user.name,event.user.display_name].map{|q| normalize(q.downcase).gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','')[0,xname.length]}.include?(xname.downcase)
    x=untz.find_index{|q| q.name=='Kiran'}
    return untz[x] unless x.nil?
  end
  xname2=nil
  xname2=xname.downcase.gsub('resplendent','') if xname.downcase.include?('resplendent')
  xname2=xname.downcase.gsub('resplendant','') if xname.downcase.include?('resplendant')
  unless xname2.nil?
    untz2=untz.reject{|q| !q.availability[0].include?('RA') || !q.fake.nil?}
    x=untz2.find_index{|q| q.name.downcase.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','')==xname2.downcase}
    return untz2[x] unless x.nil?
    alz2=alz.reject{|q| q[2].is_a?(Array) || (q[2].is_a?(String) && untz.map{|q2| q2.name}.include?(q[2])) || (!q[2].is_a?(String) && untz.map{|q2| q2.id}.include?(q[2]))}
    x=alz2.find_index{|q| q[1].gsub('||','').downcase==xname2.downcase && (q[3].nil? || q[3].include?(k))}
    unless x.nil?
      x2=untz2.find_index{|q| q.id==alz2[x][2]}
      x2=untz2.find_index{|q| q.name.downcase==alz2[x][2].downcase} if alz2[x][2].is_a?(String)
      return untz2[x2] unless x2.nil?
    end
  end
  return nil
end

def find_skill(event,args=nil,xname=nil,bot=nil,fullname=false,weaponsonly=false)
  data_load(['skill'])
  args=event.message.text.split(' ') if args.nil?
  xname=args.join('') if xname.nil?
  xname=normalize(xname.gsub('!',''))
  if xname.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    buff=xname.split(':')[1]
    buff=buff[3,buff.length-3] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,3].downcase=='gp_'
    buff=buff[2,buff.length-2] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,2].downcase=='gp'
    xname=buff unless find_skill(event,args,buff,bot,fullname).nil?
  end
  xname=xname.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','').gsub('.','').gsub('/','')
  untz=$skills.reject{|q| !q.isPostable?(event)}
  untz=untz.reject{|q| !q.type.include?('Weapon')} if weaponsonly
  x=untz.find_index{|q| q.fullName.downcase.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','').gsub('.','').gsub('/','')==xname.downcase}
  return untz[x] unless x.nil?
  nicknames_load()
  alz=$aliases.reject{|q| q[0]!='Skill'}
  k=0
  k=event.server.id unless event.server.nil?
  x=alz.find_index{|q| q[1].gsub('||','').downcase==xname.downcase && (q[3].nil? || q[3].include?(k))}
  if x.nil?
  elsif alz[x][2].is_a?(Array)
    x2=alz[x][2].map{|q| untz.find_index{|q2| (!q.is_a?(String) && q2.id==q) || (q.is_a?(String) && q2.fullName.downcase==q.downcase)}}
    x2.compact!
    return nil if x2.length<=0
    return untz[x2[0]] if x2.length==1
    return x2.map{|q| untz[q]}
  else
    x2=untz.find_index{|q| q.id==alz[x][2]}
    x2=untz.find_index{|q| q.fullName.downcase==alz[x][2].downcase} if alz[x][2].is_a?(String)
    return untz[x2] unless x2.nil?
  end
  return nil if fullname || xname.length<2
  x=untz.find_index{|q| q.fullName.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('!','').gsub('.','').gsub('/','')[0,xname.length].downcase==xname.downcase}
  return untz[x] unless x.nil?
  x=alz.find_index{|q| q[1].gsub('||','')[0,xname.length].downcase==xname.downcase && (q[3].nil? || q[3].include?(k))}
  if x.nil?
  elsif alz[x][2].is_a?(Array)
    x2=alz[x][2].map{|q| untz.find_index{|q2| (!q.is_a?(String) && q2.id==q) || (q.is_a?(String) && q2.fullName.downcase==q.downcase)}}
    x2.compact!
    return nil if x2.length<=0
    return untz[x2[0]] if x2.length==1
    return x2.map{|q| untz[q]}
  else
    x2=untz.find_index{|q| q.id==alz[x][2]}
    x2=untz.find_index{|q| q.fullName.downcase==alz[x][2].downcase} if alz[x][2].is_a?(String)
    return untz[x2] unless x2.nil?
  end
  return nil
end

def find_structure(event,args=nil,xname=nil,bot=nil,fullname=false,ext=0)
  data_load(['structure'])
  strct=$structures.map{|q| q}
  xname=args.join('') if xname.nil?
  xname=xname.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  k=strct.find_index{|q| q.fullName.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname}
  unless k.nil?
    k=strct[k]
    if k.level=='-'
      return [k] # items without levels should still be in an array
    elsif k.level=='example'
      return strct.reject{|q| q.name != k.name} # items with levels, but no level is listed, should return everything
    else
      return strct.reject{|q| q.fullName != k.fullName} # items with listed levels should return all matches, even cross-team
    end
  end
  alz=$aliases.reject{|q| q[0]!='Structure'}.map{|q| [q[1],q[2],q[3]]}
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname && (q[2].nil? || q[2].include?(g))}
  unless k.nil?
    m=strct.reject{|q| q.fullName != alz[k][1]}
    return m.map{|q| q} unless m.length<=0
    s=strct.reject{|q| q.name != alz[k][1]}
    return s.map{|q| q}
  end
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname && (q[2].nil? || q[2].include?(g))}
  unless k.nil?
    m=strct.reject{|q| q.fullName != alz[k][1]}
    return m.map{|q| q} unless m.length<=0
    s=strct.reject{|q| q.name != alz[k][1]}
    return s.map{|q| q}
  end
  return nil if fullname || xname.length<=2
  return nil if xname.length<3
  k=strct.find_index{|q| q.name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname}
  unless k.nil?
    k=strct[k]
    if k.level=='-'
      return [k]
    elsif k.level=='example'
      return strct.reject{|q| q.name != k.name}
    else
      return nil # partial aliases won't include the level
    end
  end
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname && (q[2].nil? || q[2].include?(g))}
  s=[]
  s=strct.reject{|q| q.name != alz[k][0]} unless k.nil?
  return s.map{|q| q} if s.length>0
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname && (q[2].nil? || q[2].include?(g))}
  s=[]
  s=strct.reject{|q| q.name != alz[k][0]} unless k.nil?
  return s.map{|q| q} if s.length>0
  return nil
end

def find_item_feh(event,args=nil,xname=nil,bot=nil,fullname=false,ext=0)
  data_load(['item'])
  itmu=$itemus.map{|q| q}
  xname=args.join('') if xname.nil?
  xname=xname.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  k=itmu.find_index{|q| q.name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname}
  return itmu[k] unless k.nil?
  nicknames_load()
  alz=$aliases.reject{|q| q[0]!='Item'}.map{|q| [q[1],q[2],q[3]]}
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q.name==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q.name==alz[k][1]}] unless k.nil?
  return nil if fullname || xname.length<3
  k=itmu.find_index{|q| q.name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname}
  return itmu[k] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q.name==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q.name==alz[k][1]}] unless k.nil?
  return nil
end

def find_accessory(event,args=nil,xname=nil,bot=nil,fullname=false,ext=0)
  data_load(['accessory'])
  itmu=$accessories.map{|q| q}
  xname=args.join('') if xname.nil?
  xname=xname.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  k=itmu.find_index{|q| q.name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname}
  return itmu[k] unless k.nil?
  nicknames_load()
  alz=$aliases.reject{|q| q[0]!='Accessory'}.map{|q| [q[1],q[2],q[3]]}
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q.name==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q.name==alz[k][1]}] unless k.nil?
  k=itmu.find_index{|q| q.name.length>4 && q.name[0,4]=='(S) ' && q.name[4,q.name.length-4].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname}
  return itmu[k] unless k.nil?
  return nil if fullname || xname.length<3
  k=itmu.find_index{|q| q.name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname}
  return itmu[k] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q.name==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname && (q[2].nil? || q[2].include?(g))}
  return itmu[itmu.find_index{|q| q.name==alz[k][1]}] unless k.nil?
  k=itmu.find_index{|q| q.name.length>4 && q.name[0,4]=='(S) ' && q.name[4,q.name.length-4].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname}
  return itmu[k] unless k.nil?
  return nil
end

def find_group(event,args=nil,xname=nil)
  args=event.message.text.split(' ') if args.nil?
  xname=args.join('') if xname.nil?
  xname=normalize(xname.gsub('!',''))
  if xname.downcase.gsub(' ','').gsub('_','')[0,2]=='<:'
    buff=xname.split(':')[1]
    buff=buff[3,buff.length-3] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,3].downcase=='gp_'
    buff=buff[2,buff.length-2] if !event.server.nil? && event.server.id==350067448583553024 && buff[0,2].downcase=='gp'
    xname=buff if find_unit(buff,event,fullname).length>0
  end
  xname=xname.gsub('(','').gsub(')','').gsub(' ','').gsub('_','')
  untz=$groups.reject{|q| !q.isPostable?(event)}
  x=untz.find_index{|q| q.name.downcase==xname.downcase || q.aliases.include?(xname.downcase)}
  return untz[x] unless x.nil? || ['Legendaries','Mythics','Resplendent','Refreshers','DuoUnits','HarmonicUnits'].include?(untz[x].name)
  x=untz.find_index{|q| q.name[0,xname.length].downcase==xname.downcase || q.aliases.map{|q2| q2[0,xname.length]}.include?(xname.downcase)}
  return untz[x] unless x.nil? || ['Legendaries','Mythics','Resplendent','Refreshers','DuoUnits','HarmonicUnits'].include?(untz[x].name)
  return nil
end

def find_FGO_servant(event,args=nil,xname=nil,bot=nil,fullname=false,ext=0)
  return nil unless event.server.nil? || !bot.user(502288364838322176).on(event.server.id).nil? || Shardizard==4
  data_load(['FGO'])
  xname=args.join('') if xname.nil?
  xname=xname.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  srvntz=$fgo_servants.map{|q| q}
  xname=normalize(xname)
  if xname[0,1]=='#'
    name2=xname[1,xname.length-1]
    if name2.to_i.to_s==name2 && name2.to_i<=srvntz[-1].id.to_i
      return srvntz[srvntz.find_index{|q| q.id.to_i==name2.to_i}]
    elsif name2.to_f.to_s==name2 && name2.to_f<2
      return srvntz[srvntz.find_index{|q| q.id.to_f==name2.to_f}]
    end
  elsif ['srv-#','srv_#','fgo-#','fgo_#'].include?(xname[0,4].downcase)
    name2=xname[5,xname.length-5]
    if name2.to_i.to_s==name2 && name2.to_i<=srvntz[-1].id.to_i
      return srvntz[srvntz.find_index{|q| q.id.to_i==name2.to_i}]
    elsif name2.to_f.to_s==name2 && name2.to_f<2
      return srvntz[srvntz.find_index{|q| q.id.to_f==name2.to_f}]
    end
  elsif ['srv-','srv_','srv#','fgo-','fgo_','fgo#'].include?(xname[0,4].downcase)
    name2=xname[4,xname.length-4]
    if name2.to_i.to_s==name2 && name2.to_i<=srvntz[-1].id.to_i
      return srvntz[srvntz.find_index{|q| q.id.to_i==name2.to_i}]
    elsif name2.to_f.to_s==name2 && name2.to_f<2
      return srvntz[srvntz.find_index{|q| q.id.to_f==name2.to_f}]
    end
  elsif xname[0,3].downcase=='srv' || xname[0,3].downcase=='fgo'
    name2=xname[3,xname.length-3]
    if name2.to_i.to_s==name2 && name2.to_i<=srvntz[-1].id.to_i
      return srvntz[srvntz.find_index{|q| q.id.to_i==name2.to_i}]
    elsif name2.to_f.to_s==name2 && name2.to_f<2
      return srvntz[srvntz.find_index{|q| q.id.to_f==name2.to_f}]
    end
  end
  xname=xname.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')
  return nil if xname.length<2
  k=srvntz.find_index{|q| q.name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname}
  return srvntz[k] unless k.nil?
  if File.exist?("#{$location}devkit/FGONames.txt")
    b=[]
    File.open("#{$location}devkit/FGONames.txt").each_line do |line|
      b.push(eval line)
    end
  else
    b=[]
  end
  alz=b.reject{|q| q[0]!='Servant' || q.nil? || q[1].nil? || q[2].nil?}.map{|q| [q[1],q[2],q[3]]}.uniq
  g=0
  g=event.server.id unless event.server.nil?
  k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname && (q[2].nil? || q[2].include?(g))}
  return srvntz[srvntz.find_index{|q| q.tid==alz[k][1]}] unless k.nil?
  k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')==xname && (q[2].nil? || q[2].include?(g))}
  return srvntz[srvntz.find_index{|q| q.tid==alz[k][1]}] unless k.nil?
  return nil if fullname || xname.length<=2
  k=srvntz.find_index{|q| q.name.downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname}
  return srvntz[k] unless k.nil?
  for i in xname.length...alz.map{|q| q[0].length}.max
    k=alz.find_index{|q| q[0].downcase.gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname && q[0].length<=i && (q[2].nil? || q[2].include?(g))}
    return srvntz[srvntz.find_index{|q| q.tid==alz[k][1]}] unless k.nil?
    k=alz.find_index{|q| q[0].downcase.gsub('||','').gsub(' ','').gsub('(','').gsub(')','').gsub('!','').gsub('?','').gsub('_','').gsub("'",'').gsub('"','').gsub(':','')[0,xname.length]==xname && q[0].length<=i && (q[2].nil? || q[2].include?(g))}
    return srvntz[srvntz.find_index{|q| q.tid==alz[k][1]}] unless k.nil?
  end
  return nil
end

def get_markers(event) # used to determine whether a server-specific unit/skill is safe to display
  metadata_load()
  k=0
  k=event.server.id unless event.server.nil?
  g=[nil]
  for i in 0...$server_markers.length
    g.push($server_markers[i][0]) if k==$server_markers[i][1]
    g.push($server_markers[i][0].downcase) if k==$server_markers[i][1]
  end
  g.push('X') if $x_markers.include?(k)
  g.push('x') if $x_markers.include?(k)
  return g
end

def spaceship_order(x)
  return 1 if x=='Unit'
  return 2 if x=='Skill'
  return 3 if x=='Structure'
  return 4 if x=='Item'
  return 5 if x=='Accessory'
  return 600
end

def nomf()
  return 'No hay coincidencias' if Shardizard==$spanishShard
  return 'No matches found'
end

def smol_err(bot,event,ignore=false,smol=false,force=false)
  if force
  elsif !find_data_ex(:find_FGO_servant,event,nil,nil,bot).nil?
    srv=find_data_ex(:find_FGO_servant,event,nil,nil,bot)
    event.respond "FGO servant found: #{srv.name} [Srv-##{srv.id}]\nTry `FEH!stats FGO #{srv.name}` if you wish to see what this servant's stats would be in FEH."
    return nil
  elsif !smol || $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event.respond 'No unit was included' unless ignore || Shardizard==$spanishShard
    event.respond 'No se encontró ningún carácter' unless ignore || Shardizard !=$spanishShard
    return nil
  end
  x=['No unit was included.  Have a smol me instead.','image source']
  x=['No se encontró ningún carácter. Toma esta versión miniaturizada de mí en su lugar.','fuente de imagen'] if Shardizard==$spanishShard
  event.channel.send_embed("__**#{x[0]}**__") do |embed|
    embed.color = 0xD49F61
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Smol_Elise.jpg")
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: x[1], url: "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=58900377")
  end
end

def sever(str,sklz=false,ignorenums=false)
  ssx=str.split(' ')
  for i in 0...ssx.length
    if ssx[i].include?('/')
      if ssx[i][-1].to_i.to_s==ssx[i][-1]
      elsif ssx[i].split('/').reject{|q| ['+','-'].include?(q[0])}.length != ssx[i].split('/').length
        ssx[i]=ssx[i].gsub('/',' / ')
      end
    end
  end
  str="#{ssx.join(' ')}#{" ``" if ['+','-','*'].include?(str[str.length-1,1])}"
  s=str.split(' ').join(' ')
  k=str.split('*')
  k2=1
  k2=0 if k.length==1 && k[0][0,1].to_i.to_s==k[0][0,1]
  if k.length==1 && k[0].include?(' ')
    k3=k[0].split(' ')
    k3=k3[k3.length-1]
    k2=0 if k3[0,1].to_i.to_s==k3[0,1]
  end
  unless ignorenums
    for i in 0...k.length-k2
      k[i]="#{k[i]}*"
    end
  end
  str=k.join(' ')
  str=str.gsub('(+)','(``)')
  k=str.split('+')
  for i in 1...k.length
    k[i]="+#{k[i]}"
  end
  str=k.join(' ')
  str=str.gsub('(``)','(+)')
  k=str.split(' ')
  for i in 1...k.length
    if k[i]=='+'
      if i==0 || k[i-1].length<2
      elsif k[i-1][0,7].downcase=='rallyup'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif k[i-1][0,5].downcase=='rally'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif k[i-1][k[i-1].length-4,4].downcase=='balm'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif ['windfire','earthwater','firewater','earthfire','earthwind','waterwind','waterearth','windearth','windwater','waterearth','waterfire'].include?(k[i-1].downcase.gsub('-',''))
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif ['HP','Attack','Speed','Defense','Resistance'].map{|q| q.downcase}.include?(k[i-1].downcase) && i==k.length-1
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      end
    elsif i>1 && !k[i-1].nil? && k[i][0,1]=='+' && k[i][1,k[i].length-1].to_i.to_s==k[i][1,k[i].length-1]
      k[i-1]=stat_modify(k[i-1].downcase)
      if k[i-1][0,7].downcase=='rallyup'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif k[i-1][0,5].downcase=='rally'
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif ['HP','Attack','Speed','Defense','Resistance'].map{|q| q.downcase}.include?(k[i-1].downcase) && i==k.length-1
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      elsif !sklz
      elsif ['HP','Attack','Speed','Defense','Resistance'].include?(k[i-1]) || ['attackspeed','atkspeed','attspeed','attackspd','atkspd','attspd','speedattack','speedatk','speedatt','spdattack','spdatk','spdatt','attackdefense','atkdefense','attdefense','attackdefence','atkdefence','attdefence','attackdef','atkdef','attdef','defenseattack','defenseatk','defenseatt','defenceattack','defenceatk','defenceatt','defattack','defatk','defatt','attackresistance','atkresistance','attresistance','attackres','atkres','attres','resistanceattack','resistanceatk','resistanceatt','resattack','resatk','resatt','speeddefense','spddefense','speeddefence','spddefence','speeddef','spddef','defensespeed','defensespd','defencespeed','defencespd','defspeed','defspd','speedresistance','spdresistance','speedres','spdres','resistancespeed','resistancespd','resspeed','resspd','defenseresistance','defenceresistance','defresistance','defenseres','defenceres','defres','resistancedefense','resistancedefence','resistancedef','resdefense','resdefence','resdef'].include?(k[i-1].downcase)
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      end
    elsif !sklz
    elsif k[i]=='(+)'
    elsif k[i-1]=='(+)'
      k[i]=stat_modify(k[i].downcase)
      if ['HP','Attack','Speed','Defense','Resistance'].include?(k[i])
        k[i-1]="#{k[i-1]}#{k[i]}"
        k[i]=nil
      end
    end
  end
  k.compact!
  str=k.join(' ')
  str=str.gsub('-star','``star')
  k=str.split('-')
  for i in 1...k.length
    k[i]="-#{k[i]}"
  end
  str=k.join(' ')
  str=str.gsub('``star','-star')
  str="#{str} +" if s[s.length-1,1]=='+'
  str="#{str} -" if s[s.length-1,1]=='-'
  str="* #{str}" if s[0,1]=='*'
  return str
end

def splice(str)
  s=sever(str).split(' ')
  for i in 0...s.length
    if s[i][s[i].length-1,1]=='*' && i<s.length-1
      s[i+1]="#{s[i]}#{s[i+1]}"
      s[i]=nil
    elsif ['+','-'].include?(s[i][0,1]) && i>0
      k=0
      for j in 0...i
        k=j unless s[j].nil?
      end
      s[k]="#{s[k]}#{s[i]}"
      s[i]=nil
    end
  end
  s.compact!
  return s
end

def find_stats_in_string(event,stringx=nil,mode=0,namex=nil,juststats=false)
  stringx=event.message.text.downcase if stringx.nil?
  s="#{stringx}"
  s=remove_prefix(s,event)
  a=s.split(' ')
 # s="#{stringx}" if all_commands().include?(a[0])
  if s.gsub(' ','').length.zero?
    args=[]
  else
    args=sever(s,true).gsub('.','').split(' ')
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args2=args.reject{ |q| ['feh!','feh?'].include?(q.downcase[0,4]) || ['f?','e?','h?'].include?(q.downcase[0,2]) }
  unless args2.length<=0
    args2.shift if ['feh'].include?(args2[0].downcase[0,3]) || ['f?','e?','h?'].include?(args2[0].downcase[0,2])
  end
  merges=nil
  rarity=nil
  boon=nil
  bane=nil
  support=nil
  refinement=nil
  blessing=[]
  transformed=false
  flowers=nil
  if args2.length>0
    cornatures=[['HP','Robust','Sickly','Aguante','Flaqueza'],
                ['Attack','Strong','Weak','Impetu','Debilidad'],
                ['Attack','Clever','Dull','Intelecto','Apatia'],
                ['Speed','Quick','Sluggish','Rapidad','Lentitud'],
                ['Defense','Sturdy','Fragile','Robustez','Fragilidad'],
                ['Resistance','Calm','Excitable','Aplomo','Ansiedad']]
    # first pass through inputs, searching for anything that has self-contained context clues as for what variable it should fill
    for i in 0...args.length
      unless juststats
        for j in 0...cornatures.length
          if args[i].downcase==cornatures[j][1].downcase
            args[i]="+#{cornatures[j][0]}"
          elsif args[i].downcase==cornatures[j][2].downcase
            args[i]="-#{cornatures[j][0]}"
          elsif Shardizard != $spanishShard
          elsif args[i].downcase==cornatures[j][3].downcase
            args[i]="+#{cornatures[j][0]}"
          elsif args[i].downcase==cornatures[j][4].downcase
            args[i]="-#{cornatures[j][0]}"
          end
        end
      end
      if juststats
      elsif ['s','ssupport','supports','support'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        support='S' if support.nil?
      elsif ['a'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        support='A' if support.nil?
      elsif ['b'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        support='B' if support.nil?
      elsif ['c'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
        support='C' if support.nil?
      end
      transformed=true if !juststats && ['t','transformed','transform'].include?(args[i].gsub('(','').gsub(')','').gsub('-','').gsub('_','').downcase)
      if args[i][0,1]=='+'
        x=args[i].gsub('(','').gsub(')','')[1,args[i].gsub('(','').gsub(')','').length-1]
        if x.to_i.to_s==x && merges.nil? # numbers preceeded by a plus sign automatically fill the merges variable
          merges=x.to_i
          args[i]=nil
        elsif x.to_i.to_s==x && flowers.nil?
          flowers=x.to_i
          args[i]=nil
        else # stat names preceeded by a plus sign automatically fill the boon variable
          x=stat_modify(x)
          if ['HP','Attack','Speed','Defense','Resistance'].include?(x) && boon.nil?
            boon=x
            args[i]=nil
          end
        end
      elsif args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-1,1]=='*' # numbers followed by an asterisk automatically fill the rarity variable
        x=args[i].gsub('(','').gsub(')','')[0,args[i].gsub('(','').gsub(')','').length-1]
        if x.to_i.to_s==x && rarity.nil?
          rarity=x.to_i
          args[i]=nil
        end
      elsif args[i].gsub('(','').gsub(')','')[0,1]=='-' # stat names preceeded by a minus sign automatically fill the bane variable
        x=stat_modify(args[i].gsub('(','').gsub(')','')[1,args[i].gsub('(','').gsub(')','').length-1])
        if ['HP','Attack','Speed','Defense','Resistance'].include?(x) && bane.nil?
          bane=x
          args[i]=nil
        end
      elsif juststats
      elsif args[i][0,1].downcase=='f' && args[i][1,args[i].length-1].to_i.to_s==args[i][1,args[i].length-1]
        flowers=args[i][1,args[i].length-1].to_i if flowers.nil?
        args[i]=nil
      elsif args[i][0,2].downcase=='df' && args[i][2,args[i].length-2].to_i.to_s==args[i][2,args[i].length-2]
        flowers=args[i][2,args[i].length-2].to_i if flowers.nil?
        args[i]=nil
      elsif args[i][0,6].downcase=='flower' && args[i][6,args[i].length-6].to_i.to_s==args[i][6,args[i].length-6]
        flowers=args[i][6,args[i].length-6].to_i if flowers.nil?
        args[i]=nil
      elsif args[i][0,12].downcase=='dragonflower' && args[i][12,args[i].length-12].to_i.to_s==args[i][12,args[i].length-12]
        flowers=args[i][12,args[i].length-12].to_i if flowers.nil?
        args[i]=nil
      elsif args[i][0,4].downcase=='flor' && args[i][4,args[i].length-4].to_i.to_s==args[i][4,args[i].length-4] && Shardizard==$spanishShard
        flowers=args[i][4,args[i].length-4].to_i if flowers.nil?
        args[i]=nil
      elsif args[i][0,9].downcase=='dracoflor' && args[i][9,args[i].length-9].to_i.to_s==args[i][9,args[i].length-9]
        flowers=args[i][9,args[i].length-9].to_i if flowers.nil?
        args[i]=nil
      elsif args[i][0,3]=='(+)' # stat names preceeded by a plus sign in parentheses automatically fill the refinement variable
        x=stat_modify(args[i][3,args[i].length-3])
        if ['Attack','Speed','Defense','Resistance'].include?(x)
          refinement=x if refinement.nil?
          args[i]=nil
        end
      elsif args[i].length>9 && (args[i].gsub('(','').gsub(')','')[0,9].downcase=='blessing2' || args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-9,9].downcase=='blessing2')
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing2',''),false,true)
        if ['Attack','Speed','Defense','Resistance','PairUp'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>15 && (['blessingmythical','mythicalblessing'].include?(args[i].gsub('(','').gsub(')','')[0,15].downcase) || ['blessingmythical','mythicalblessing'].include?(args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-15,15].downcase))
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing','').gsub('mythical',''),false,true)
        if ['Attack','Speed','Defense','Resistance','PairUp'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>13 && (['blessingmythic','mythicblessing'].include?(args[i].gsub('(','').gsub(')','')[0,13].downcase) || ['blessingmythic','mythicblessing'].include?(args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-13,13].downcase))
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing','').gsub('mythic',''),false,true)
        if ['Attack','Speed','Defense','Resistance','PairUp'].include?(x)
          blessing.push("#{x}(Mythical)")
          args[i]=nil
        end
      elsif args[i].length>8 && (args[i].gsub('(','').gsub(')','')[0,8].downcase=='blessing' || args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-8,8].downcase=='blessing')
        x=stat_modify(args[i].gsub('(','').gsub(')','').downcase.gsub('blessing',''),false,true)
        if ['Attack','Speed','Defense','Resistance','PairUp'].include?(x)
          blessing.push("#{x}(Legendary)")
          args[i]=nil
        end
      elsif args[i][0,1]=='(' && args[i][args[i].length-1,1]==')'
        x=stat_modify(args[i][1,args[i].length-2],true)
        if ['Attack','Speed','Defense','Resistance','Effect','Wrathful','Dazzling'].include?(x)
          refinement=x if refinement.nil?
          args[i]=nil
        end
      elsif args[i].gsub('(','').gsub(')','').length>5 && args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-5,5].downcase=='-star' # numbers followed by the word "star" automatically fill the rarity variable
        x=args[i].gsub('(','').gsub(')','')[0,args[i].gsub('(','').gsub(')','').length-5]
        if x.to_i.to_s==x && rarity.nil?
          rarity=x.to_i
          args[i]=nil
        end
      elsif args[i].gsub('(','').gsub(')','').length>4 && args[i].gsub('(','').gsub(')','')[args[i].gsub('(','').gsub(')','').length-4,4].downcase=='star' # numbers followed by the word "star" automatically fill the rarity variable
        x=args[i].gsub('(','').gsub(')','')[0,args[i].gsub('(','').gsub(')','').length-4]
        if x.to_i.to_s==x && rarity.nil?
          rarity=x.to_i
          args[i]=nil
        end
      elsif !find_nature(args[i].gsub('(','').gsub(')','')).nil? && (boon.nil? || bane.nil?) # Certain Pokemon nature names will fill both the boon and bane variables
        boon=find_nature(args[i].gsub('(','').gsub(')',''))[1] if boon.nil?
        bane=find_nature(args[i].gsub('(','').gsub(')',''))[2] if bane.nil?
        args[i]=nil
      end
      if juststats
      elsif i>0 && !args[i-1].nil? && !args[i].nil?
        x=stat_modify(args[i-1].gsub('(','').gsub(')',''))
        y=stat_modify(args[i].gsub('(','').gsub(')',''))
        if args[i].gsub('(','').gsub(')','').downcase=='star' && args[i-1].gsub('(','').gsub(')','').to_i.to_s==args[i-1].gsub('(','').gsub(')','') && rarity.nil?
          # the word "star", if preceeded by a number, will automatically fill the rarity variable with that number
          rarity=args[i-1].gsub('(','').gsub(')','').to_i
          args[i]=nil
          args[i-1]=nil
        elsif ['dragonflower','dragonflowers'].include?(args[i].gsub('(','').gsub(')','').downcase) && args[i-1].gsub('(','').gsub(')','').to_i.to_s==args[i-1].gsub('(','').gsub(')','') && flowers.nil?
          # the word "dragonflower", if preceeded by a number, will automatically fill the flowers variable with that number
          flowers=args[i-1].gsub('(','').gsub(')','').to_i
          args[i]=nil
          args[i-1]=nil
        elsif ['dracoflor','dracoflores'].include?(args[i].gsub('(','').gsub(')','').downcase) && args[i-1].gsub('(','').gsub(')','').to_i.to_s==args[i-1].gsub('(','').gsub(')','') && flowers.nil? && Shardizard==$spanishShard
          # the word "dragonflower", if preceeded by a number, will automatically fill the flowers variable with that number
          flowers=args[i-1].gsub('(','').gsub(')','').to_i
          args[i]=nil
          args[i-1]=nil
        elsif args[i].gsub('(','').gsub(')','').downcase=='mode' && ['Attack','Speed','Defense','Resistance'].include?(x) && refinement.nil?
          # the word "mode", if preceeded by a stat name other than HP, will turn that stat into the refinement of the weapon the unit is equipping
          refinement=x
          args[i]=nil
          args[i-1]=nil
        elsif args[i].gsub('(','').gsub(')','').downcase=='blessing' && ['Attack','Speed','Defense','Resistance'].include?(x)
          # the word "blessing", if preceeded by a stat name other than HP, will turn that stat into a blessing to be applied to the character
          bbb='Legendary'
          bbb=blessing[0].split('(')[1] if blessing.length>0
          blessing.push("#{x}(#{bbb}")
          args[i]=nil
          args[i-1]=nil
        elsif args[i-1].gsub('(','').gsub(')','').downcase=='(+)' && ['Attack','Speed','Defense','Resistance'].include?(y) && refinement.nil?
          # the character arrangement "(+)", if followed by a stat name other than HP, will turn that stat into the refinement of the weapon the unit is equipping
          refinement=y
          args[i]=nil
          args[i-1]=nil
        elsif args[i-1].gsub('(','').gsub(')','').downcase=='plus' && ['HP','Attack','Speed','Defense','Resistance'].include?(y) && boon.nil?
          # the word "plus", if followed by a stat name, will turn that stat into the unit's boon
          boon=y
          args[i]=nil
          args[i-1]=nil
        elsif args[i-1].gsub('(','').gsub(')','').downcase=='minus' && ['HP','Attack','Speed','Defense','Resistance'].include?(y) && bane.nil?
          # the word "minus", if followed by a stat name, will turn that stat into the unit's bane
          bane=y
          args[i]=nil
          args[i-1]=nil
        elsif args[i].gsub('(','').gsub(')','').downcase=='boon' && ['HP','Attack','Speed','Defense','Resistance'].include?(x) && boon.nil?
          # the word "boon", if preceeded by a stat name, will turn that stat into the unit's boon
          boon=x
          args[i]=nil
          args[i-1]=nil
        elsif args[i].gsub('(','').gsub(')','').downcase=='bane' && ['HP','Attack','Speed','Defense','Resistance'].include?(x) && bane.nil?
          # the word "minus", if preceeded by a stat name, will turn that stat into the unit's bane
          bane=x
          args[i]=nil
          args[i-1]=nil
        end
      end
      unless args[i].nil? || juststats
        refinement='Effect' if ['effect','special','eff'].include?(args[i].gsub('(','').gsub(')','').downcase) && refinement.nil?
        refinement='Wrathful' if ['wrazzle','wrathful'].include?(args[i].gsub('(','').gsub(')','').downcase) && refinement.nil?
        refinement='Dazzling' if ['dazzle','dazzling'].include?(args[i].gsub('(','').gsub(')','').downcase) && refinement.nil?
      end
    end
    args.compact!
    # second pass through arguments, literally only searching for remaining stats with a plus sign in front of them
    # applicable moments will fill the refinement variable if empty
    if refinement.nil? && args.length>0
      for i in 0...args.length
        if args[i][0,1]=='+'
          x=args[i].gsub('(','').gsub(')','')[1,args[i].gsub('(','').gsub(')','').length-1]
          if x.to_i.to_s==x && x.to_i>0 && x.to_i<Max_rarity_merge[1]+1
            if merges.nil?
              merges=x.to_i
              args[i]=nil
            elsif flowers.nil?
              flowers=x.to_i
              args[i]=nil
            end
          elsif ['HP','Attack','Speed','Defense','Resistance'].include?(stat_modify(x)) && refinement.nil? && !juststats
            refinement=stat_modify(x)
            args[i]=nil
          end
        end
        if juststats
        elsif i>0 && !args[i].nil? && !args[i-1].gsub('(','').gsub(')','').nil? && !args[i].gsub('(','').gsub(')','').nil?
          x=stat_modify(args[i-1].gsub('(','').gsub(')',''))
          y=stat_modify(args[i].gsub('(','').gsub(')',''))
          if args[i-1].gsub('(','').gsub(')','').downcase=='plus' && ['Attack','Speed','Defense','Resistance'].include?(y) && refinement.nil?
            refinement=y
            args[i]=nil
            args[i-1]=nil
          end
        end
      end
    end
    args.compact!
    # final pass through inputs, searching for numbers and stat names without self-contained context clues
    # numbers will prioritize filling the rarity variable if empty, fall back trying to fill the merges variable if empty
    # stat names will priotitize filling the boon variable if empty, fall back trying to fill the bane variable if empty, double fall back to weapon refinement if applicable
    unless juststats
      for i in 0...args.length
        x=stat_modify(args[i].gsub('(','').gsub(')',''))
        if x.to_i.to_s==x
          x=x.to_i
          if x<0 || x>Max_rarity_merge[1]
          elsif rarity.nil? && !x.zero? && x<Max_rarity_merge[0]
            rarity=x
            args[i]=nil
          elsif merges.nil?
            merges=x
            args[i]=nil
          elsif flowers.nil?
            flowers=x
            args[i]=nil
          end
        elsif ['HP','Attack','Speed','Defense','Resistance'].include?(x)
          if boon.nil?
            boon=x
            args[i]=nil
          elsif bane.nil?
            bane=x
            args[i]=nil
          elsif refinement.nil? && x != 'HP'
            refinement=x
            args[i]=nil
          end
        end
      end
    end
    args.compact!
    fw=['dragonflower','dragonflowers','df']
    fw=['dragonflower','dragonflowers','df','dracoflor','dracoflores'] if Shardizard==$spanishShard
    flowers=Max_rarity_merge[2] if has_any?(args.map{|q| q.downcase},fw) && flowers.nil?
  end
  blessing=[] if blessing.nil?
  if juststats
  elsif args.map{|q| q.downcase}.include?('duel')
    if blessing.length>0
      x="Duel(#{blessing[0].split('(')[1]}"
    else
      x='Duel(Legendary)'
    end
    blessing.push(x) unless blessing.include?(x)
  end
  btype=''
  btype=blessing[0].split('(')[1] if blessing.length>0
  unless namex.nil? || $units.find_index{|q| q.name==namex}.nil?
    unt=$units[$units.find_index{|q| q.name==namex}].legendary
    unless unt.nil?
      btype='Mythical)' if unt[0]=='Legendary'
      btype='Legendary)' if unt[0]=='Mythic'
    end
  end
  if blessing.length>0
    for i in 0...blessing.length
      blessing[i]="#{blessing[i].split('(')[0]}(#{btype}"
    end
  end
  blessing=blessing.reject{|q| q.split('(')[1]!=blessing[0].split('(')[1]} if blessing.length>0
  unless mode==1
    rarity=5 if rarity.nil?
    merges=0 if merges.nil?
    flowers=0 if flowers.nil?
    boon='' if boon.nil?
    bane='' if bane.nil?
    support='' if support.nil?
    refinement='' if refinement.nil?
  end
  rarity=Max_rarity_merge[0] if !rarity.nil? && rarity>Max_rarity_merge[0]
  merges=Max_rarity_merge[1] if !merges.nil? && merges>Max_rarity_merge[1]
  flowers=Max_rarity_merge[1] if !flowers.nil? && flowers>3*Max_rarity_merge[2]
  resp=false
  resp=true if has_any?(args.map{|q| q.downcase},['resplendant','resplendent','ascension','ascend','resplend','ex']) || event.message.text.downcase.include?('resplendent') || event.message.text.downcase.include?('resplendant')
  return [rarity,merges,boon,bane,support,refinement,blessing,transformed,flowers,resp]
end

def make_stat_skill_list_1(name,event,args) # this is for yellow-stat skills
  args=sever(event.message.text,true).split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.downcase.gsub('(','').gsub(')','').gsub('/','').gsub('.','').gsub('!','')}
  nicknames_load()
  k=0
  k=event.server.id unless event.server.nil?
  alz=$aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(k)}.map{|q| [q[1],q[2]]}
  stat_skills=[]
  lookout=$statskills.reject{|q| q[3]!='Stat-Affecting 1'}
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
    for i2 in 0...lookout[i][2]
      stat_skills.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  lokoout=lookout.map{|q| q[0]}
  args=event.message.text.downcase.split(' ') # reobtain args without the reformatting caused by the sever function
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }.map{|q| q.gsub('(','').gsub(')','')} # remove any mentions included in the inputs
  lookout=$statskills.reject{|q| q[3]!='Stat-Affecting 2'}
  for i in 0...lookout.length
    lokoout.push(lookout[i][0])
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
    for i2 in 0...lookout[i][2]
      stat_skills.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  return stat_skills
end

def make_stat_skill_list_2(unit,event,args) # this is for blue- and red- stat skills.  Character name is needed to know which movement Hone/Fortify to apply
  args=sever(event.message.text,true).split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args=args.map{|q| q.gsub('(','').gsub(')','').gsub('/','').gsub('.','').gsub('!','').downcase}
  nicknames_load()
  k=0
  k=event.server.id unless event.server.nil?
  alz=$aliases.reject{|q| q[0]!='Skill' || q[3].nil? || !q[3].include?(k)}.map{|q| [q[1],q[2]]}
  stat_skills_2=[]
  lookout=$statskills.reject{|q| !['Stat-Buffing 1','Stat-Nerfing 1'].include?(q[3])}
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
    for i2 in 0...lookout[i][2]
      stat_skills_2.push(lookout[i][0]) if count_in(args,lookout[i][1])>i2
    end
  end
  hf=[]
  hf2=[]
  # Only the first eight - was six until Rival Domains was released - Hone/Fortify skills are allowed, as that's the most that can apply to the unit at once.
  # Tactic skills stack with this list's limit, but allow up to fourteen to be applied
  lookout=$statskills.reject{|q| !['Stat-Buffing 2','Stat-Nerfing 2'].include?(q[3])}
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
  end
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil? || (lookout[skl][5] && unit.weapon_type != lookout[skl][0].split(' ')[1][0,lookout[skl][0].split(' ')[1].length-1])
      skl=lookout[skl]
      if skl[2]==1
        hf.push(skl[0])
      elsif skl[2]==2
        hf2.push(skl[0])
      end
    end
  end
  for i in 0...8
    stat_skills_2.push(hf[i]) if hf.length>i
  end
  for i in 0...14-[8,hf.length].min
    stat_skills_2.push(hf2[i]) if hf2.length>i
  end
  # Rally skills not stacking with themselves is handled in the apply_stat_skills function, so 'unaccepted' duplication is allowed.
  lookout=$statskills.reject{|q| !['Stat-Buffing 3','Stat-Nerfing 3'].include?(q[3])}
  for i in 0...lookout.length
    m=alz.reject{|q| q[1]!=lookout[i][0]}.map{|q| q[0].downcase}
    lookout[i][1]+=m
  end
  for i in 0...args.length
    skl=lookout.find_index{|q| q[1].include?(args[i].downcase)}
    unless skl.nil?
      stat_skills_2.push(lookout[skl][0])
    end
  end
  return stat_skills_2
end

def stat_modify(x,includerefines=false,includeduel=false) # used to find all stat names regardless of format and turn them into their proper format
  x='HP' if ['hp','health'].include?(x.downcase)
  x='Attack' if ['attack','atk','att','strength','str','magic','mag'].include?(x.downcase)
  x='Speed' if ['spd','speed'].include?(x.downcase)
  x='Defense' if ['defense','def','defence'].include?(x.downcase)
  x='Resistance' if ['res','resistance'].include?(x.downcase)
  x='PairUp' if ['duel','dual','pairup','pair','pair-up'].include?(x.downcase) && includeduel
  if includerefines
    x='Effect' if ['effect','special','eff'].include?(x.downcase)
    x='Wrathful' if ['wrazzle','wrathful'].include?(x.downcase)
    x='Dazzling' if ['dazzle','dazzling'].include?(x.downcase)
  end
  return x
end

def find_nature(name)
  for j in 0...Natures.length
    return Natures[j] if Natures[j][0].downcase==name.downcase && Natures[j][3].nil?
  end
  return nil unless Shardizard==$spanishShard
  for j in 0...$spanish_Natures.length
    return $spanish_Natures[j] if normalize($spanish_Natures[j][0]).downcase==name.downcase && $spanish_Natures[j][3].nil?
  end
  return nil
end

def get_bonus_type(event) # used to determine if the embed header should say Tempest or Arena bonus unit
  x=event.message.text.downcase.split(' ')
  x2=[]
  x2.push('Tempest') if x.include?('tempest')
  x2.push('Arena') if x.include?('arena')
  x2.push('Aether') if x.include?('aether') || x.include?('raid')
  x2.push('Tempest/Arena/Aether') if x.include?('bonus') && x2.length<=0
  x2=['Enemy'] if x.include?('enemy') || x.include?('boss')
  x2=['Rokkr'] if x.include?('rokkr')
  return x2.join('/')
end

def disp_legendary_list(bot,event,args=nil,dispmode='',forcesplit=false)
  args=event.message.text.downcase.split(' ') if args.nil?
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  args=args.map{|q| q.downcase}
  if has_any?(args,['time','next','future','month','months'])
    sort_legendaries(event,bot)
    return nil
  end
  data_load(['unit','banner'])
  l=$units.reject{|q| q.legendary.nil? || !q.isPostable?(event)}
  l=l.reject{|q| q.legendary[3]!=dispmode} unless safe_to_spam?(event) && !forcesplit
  l.sort!{|a,b| a.name<=>b.name}
  c=l.map{|q| q.disp_color(0)}
  l.uniq!
  x=[]
  x.push('Element') if has_any?(args,['element','flavor','elements','flavors','affinity','affinities','affinitys'])
  x.push('Stat') if has_any?(args,['stat','boost','stats','boosts'])
  x.push('Weapon') if has_any?(args,['weapon','weapons'])
  x.push('Color') if has_any?(args,['color','colour','colors','colours'])
  x.push('Movement') if has_any?(args,['move','movement','moves','movements'])
  x.push('Element') if x.length<=1
  x.push('Stat') if x.length<=1
  tri=''
  x=prio(x,['Element','Stat','Color','Weapon','Movement'])
  pri=x[0]
  sec=x[1]
  tri=x[2] if x.length>=3
  p1=[]
  if pri=='Element'
    x=['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima']; x22=x.map{|q| q}
    x22=['Fuego','Agua','Viento','Tierra','Luz','Oscuridad','Cosmos',"\u00C1nima"] if Shardizard==$spanishShard
    for i in 0...x.length
      lemote1=''
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{x[i]}"}
      lemote1=moji[0].mention unless moji.length<=0
      x2=l.reject{|q| q.legendary[0]!=x[i]}
      p1.push(["#{lemote1} #{x22[i]}",x2]) unless x2.length<=0
    end
  elsif pri=='Stat'
    x=['Attack','Speed','Defense','Resistance','Attack Slot','Speed Slot','Defense Slot','Resistance Slot','Duel']; x22=x.map{|q| q}
    x22=['Ataque','Velocidad','Defensa','Resistencia','Ataque Muesca','Velocidad Muesca','Defensa Muesca','Resistencia Muesca','Agrupar'] if Shardizard==$spanishShard
    for i in 0...x.length
      lemote2=''
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{x[i].gsub(' Slot','')}"}
      moji=bot.server(554231720698707979).emoji.values.reject{|q| q.name != "Mythic_Slot_#{x[i].gsub(' Slot','')}"} if x[i].include?(' Slot')
      lemote2=moji[0].mention unless moji.length<=0
      x2=l.reject{|q| q.legendary[1]!=x[i]}
      p1.push(["#{lemote2} #{x22[i].gsub('Duel','Duel/Pair-Up')}",x2]) unless x2.length<=0
    end
  elsif pri=='Color'
    x=['Red','Blue','Green','Colorless']; x22=x.map{|q| q}
    x22=['Roja','Azul','Verde','Gris'] if Shardizard==$spanishShard
    for i in 0...x.length
      cemote=''
      moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x[i]}_Unknown"}
      cemote=moji[0].mention unless moji.length<=0
      x2=l.reject{|q| q.weapon_color != x[i]}
      p1.push(["#{cemote} #{x22[i]}",x2]) unless x2.length<=0
    end
  elsif pri=='Movement'
    x=['Infantry','Armor','Cavalry','Flier']; x22=x.map{|q| q}
    x22=['Infantería','Blindado','Caballería','Volador'] if Shardizard==$spanishShard
    for i in 0...x.length
      memote=''
      moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{x[i]}"}
      memote=moji[0].mention unless moji.length<=0
      x2=l.reject{|q| q.movement != x[i]}
      p1.push(["#{memote} #{x22[i]}",x2]) unless x2.length<=0
    end
  elsif pri=='Weapon'
    x=['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Dragon','Bow','Dagger','Healer']; x22=x.map{|q| q}
    x22=['Espada','Tomo Rojo','Lanza','Tomo Azul','Hacha','Tomo Verde',"Drag\u00F3n",'Arco','Daga','Curadora'] if Shardizard==$spanishShard
    for i in 0...x.length
      x2=l.reject{|q| q.unit_group(true,false)!="#{x[i]} Users"}
      unless x2.length<=0
        cemote=''
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x2[0].weapon_color}_#{x2[0].weapon_type}"}
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{x2[0].weapon_type}"} if ['Dragon','Bow','Dagger'].include?(x[i])
        cemote=moji[0].mention unless moji.length<=0
        p1.push(["#{cemote} #{x22[i]}",x2])
      end
    end
  end
  triple=false
  for i2 in 0...p1.length
    x2=p1[i2][1].map{|q| q}
    p2=[]
    if sec=='Element'
      x=['Fire','Water','Wind','Earth','Light','Dark','Astra','Anima']; x22=x.map{|q| q}
      x22=['Fuego','Agua','Viento','Tierra','Luz','Oscuridad','Cosmos',"\u00C1nima"] if Shardizard==$spanishShard
      for i in 0...x.length
        lemote1=''
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Legendary_Effect_#{x[i]}"}
        lemote1=moji[0].mention unless moji.length<=0
        x3=x2.reject{|q| q.legendary[0]!=x[i]}
        p2.push(["#{lemote1} #{x22[i]}",x3]) unless x3.length<=0
      end
    elsif sec=='Stat'
      x=['Attack','Speed','Defense','Resistance','Attack Slot','Speed Slot','Defense Slot','Resistance Slot','Duel']; x22=x.map{|q| q}
      x22=['Ataque','Velocidad','Defensa','Resistencia','Ataque Muesca','Velocidad Muesca','Defensa Muesca','Resistencia Muesca','Agrupar'] if Shardizard==$spanishShard
      for i in 0...x.length
        lemote2=''
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Ally_Boost_#{x[i].gsub(' Slot','')}"}
        moji=bot.server(554231720698707979).emoji.values.reject{|q| q.name != "Mythic_Slot_#{x[i].gsub(' Slot','')}"} if x[i].include?(' Slot')
        lemote2=moji[0].mention unless moji.length<=0
        x3=x2.reject{|q| q.legendary[1]!=x[i]}
        p2.push(["#{lemote2} #{x22[i].gsub('Duel','Duel/Pair-Up')}",x3]) unless x3.length<=0
      end
    elsif sec=='Color'
      x=['Red','Blue','Green','Colorless']; x22=x.map{|q| q}
      x22=['Roja','Azul','Verde','Gris'] if Shardizard==$spanishShard
      for i in 0...x.length
        cemote=''
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x[i]}_Unknown"}
        cemote=moji[0].mention unless moji.length<=0
        x3=x2.reject{|q| q.weapon_color != x[i]}
        p2.push(["#{cemote} #{x22[i]}",x3]) unless x3.length<=0
      end
    elsif sec=='Movement'
      x=['Infantry','Armor','Cavalry','Flier']; x22=x.map{|q| q}
      x22=['Infantería','Blindado','Caballería','Volador'] if Shardizard==$spanishShard
      for i in 0...x.length
        memote=''
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{x[i]}"}
        memote=moji[0].mention unless moji.length<=0
        x3=x2.reject{|q| q.movement != x[i]}
        p2.push(["#{memote} #{x22[i]}",x3]) unless x3.length<=0
      end
    elsif sec=='Weapon'
      x=['Sword','Red Tome','Lance','Blue Tome','Axe','Green Tome','Dragon','Bow','Dagger','Healer']; x22=x.map{|q| q}
      x22=['Espada','Tomo Rojo','Lanza','Tomo Azul','Hacha','Tomo Verde',"Drag\u00F3n",'Arco','Daga','Curadora'] if Shardizard==$spanishShard
      for i in 0...x.length
        x3=x2.reject{|q| q.unit_group(true,false)!="#{x[i]} Users"}
        unless x3.length<=0
          cemote=''
          moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{x3[0].weapon_color}_#{x3[0].weapon_type}"}
          moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{x3[0].weapon_type}"} if ['Dragon','Bow','Dagger'].include?(x[i])
          cemote=moji[0].mention unless moji.length<=0
          p2.push(["#{cemote} #{x22[i]}",x3])
        end
      end
    end
    double=false
    for i in 0...p2.length
      for i3 in 0...p2[i][1].length
        if tri=='Element'
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].legendary[0]}*" unless Shardizard==$spanishShard
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].spanish_legendary[0]}*" if Shardizard==$spanishShard
        elsif tri=='Stat'
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].legendary[1]}*" unless Shardizard==$spanishShard
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].spanish_legendary[1]}*" if Shardizard==$spanishShard
        elsif tri=='Color'
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].weapon_color}*" unless Shardizard==$spanishShard
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].weapon_spanish[0]}*" if Shardizard==$spanishShard
        elsif tri=='Movement'
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].movement}*" unless Shardizard==$spanishShard
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].movement_spanish}*" if Shardizard==$spanishShard
        elsif tri=='Weapon'
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].unit_group(true,true).gsub(' Users','')}*" unless Shardizard==$spanishShard
          p2[i][1][i3]="#{p2[i][1][i3].postName} - *#{p2[i][1][i3].wstring_spanish}*" if Shardizard==$spanishShard
        else
          p2[i][1][i3]=p2[i][1][i3].postName
        end
      end
      if p2[i][1].length==0
        p2[i]=nil
      elsif p2[i][1].length==1
        p2[i]="*#{p2[i][0]}*: #{p2[i][1].join("\n")}"
      else
        double=true; triple=true
        p2[i]="__*#{p2[i][0]}*__\n#{p2[i][1].join("\n")}"
      end
    end
    p2.compact!
    p1[i2][1]=p2.join("\n#{"\n" if double}")
  end
  if p1.map{|q| "#{q[0]}\n#{q[1]}"}.join("\n\n").length>1900 && !forcesplit
    disp_legendary_list(bot,event,args,dispmode,true)
    if dispmode=='Legendary'
      disp_legendary_list(bot,event,args,'Mythic',true)
    elsif dispmode=='Mythic'
      disp_legendary_list(bot,event,args,'Legendary',true)
    end
    return nil
  end
  dispmode='Legendary/Mythic' if (dispmode.length<=0 || !forcesplit) && safe_to_spam?(event)
  str="__***All #{dispmode} Heroes***__"
  str="__***Todos los héroes #{dispmode.gsub('Legendary','Legendarios').gsub('Mythic','Míticos')}***__" if Shardizard==$spanishShard
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event) || p1.map{|q| "#{q[0]}\n#{q[1]}"}.join("\n\n").length>1900
    x=2
    x=3 if triple
    for i in 0...p1.length
      str=extend_message(str,"__**#{p1[i][0]}**__\n#{p1[i][1]}",event,x)
    end
    event.respond str
  else
    create_embed(event,str,'',avg_color(c),nil,nil,p1)
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
  data_load(['unit','banner'])
  legendaries=$units.reject{|q| q.legendary.nil? || q.legendary[2].nil? || !q.fake.nil? || q.legendary_timing.nil?}.uniq
  c=legendaries.map{|q| q.disp_color(0)}
  x=legendaries.map{|q| [q.legendary_timing,q.legendary_timing(true)]}.uniq.sort{|a,b| a[1]<=>b[1]}.map{|q| q[0]}
  y=[]
  topbnr=[]
  for i in 0...x.length
    f=[]
    x2=legendaries.reject{|q| q.legendary_timing != x[i]}
    if x2.reject{|q| q.weapon_color != 'Red'}.length<=0
      f.push('<:Orb_Red:455053002256941056> - ~~unknown~~')
    else
      f.push(x2.reject{|q| q.weapon_color != 'Red'}.map{|q| "<:Orb_Red:455053002256941056> - #{q.legendary_display_name}"}.sort)
    end
    if x2.reject{|q| q.weapon_color != 'Blue'}.length<=0
      f.push('<:Orb_Blue:455053001971859477> - ~~unknown~~')
    else
      f.push(x2.reject{|q| q.weapon_color != 'Blue'}.map{|q| "<:Orb_Blue:455053001971859477> - #{q.legendary_display_name}"}.sort)
    end
    if x2.reject{|q| q.weapon_color != 'Green'}.length<=0
      f.push('<:Orb_Green:455053002311467048> - ~~unknown~~')
    else
      f.push(x2.reject{|q| q.weapon_color != 'Green'}.map{|q| "<:Orb_Green:455053002311467048> - #{q.legendary_display_name}"}.sort)
    end
    if x2.reject{|q| q.weapon_color != 'Colorless'}.length<=0
      f.push('<:Orb_Colorless:455053002152083457> - ~~unknown~~')
    else
      f.push(x2.reject{|q| q.weapon_color != 'Colorless'}.map{|q| "<:Orb_Colorless:455053002152083457> - #{q.legendary_display_name}"}.sort)
    end
    x3=x2.reject{|q| ['Red','Blue','Green','Colorless'].include?(q.weapon_color)}
    f.push(x3.map{|q| "<:Orb_Gold:549338084102111250> - #{q.legendary_display_name}"}.sort) unless x3.length<=0
    f.flatten!
    topbnr=f.map{|q| q} if i==0
    lemoji1='<:Legendary_Effect_Unknown:443337603945857024>'
    lemoji1='<:Mythic_Effect_Unknown:523328368079273984>' if x[i].include?('January') || x[i].include?('March') || x[i].include?('May') || x[i].include?('July') || x[i].include?('September') || x[i].include?('November')
    lemoji1='<:Mythic_Effect_Unknown:523328368079273984>' if x[i].include?('enero') || x[i].include?('marzo') || x[i].include?('mayo') || x[i].include?('julio') || x[i].include?('septiembre') || x[i].include?('noviembre')
    lemoji1='' if x[i]=='Remix' || x[i].include?('Mid-') || x[i].include?('Mediados de')
    y.push(["#{x[i]}#{' ' unless lemoji1.length<=1}#{lemoji1}",f.join("\n")])
  end
  future_banner=$banners.reject{|q| !has_any?(q.tags,['Legendary','LegendaryRemix']) || !q.isFuture?}.uniq
  if future_banner.length>0
    future_banner.reverse!
    for i in 0...future_banner.length
      f=[]
      if future_banner[i].red_legends.length<=0
        f.push('<:Orb_Red:455053002256941056> - ~~unknown~~')
      else
        f.push(future_banner[i].red_legends.map{|q| "<:Orb_Red:455053002256941056> - #{q.name}"}.sort)
      end
      if future_banner[i].blue_legends.length<=0
        f.push('<:Orb_Blue:455053001971859477> - ~~unknown~~')
      else
        f.push(future_banner[i].blue_legends.map{|q| "<:Orb_Blue:455053001971859477> - #{q.name}"}.sort)
      end
      if future_banner[i].green_legends.length<=0
        f.push('<:Orb_Green:455053002311467048> - ~~unknown~~')
      else
        f.push(future_banner[i].green_legends.map{|q| "<:Orb_Green:455053002311467048> - #{q.name}"}.sort)
      end
      if future_banner[i].colorless_legends.length<=0
        f.push('<:Orb_Colorless:455053002152083457> - ~~unknown~~')
      else
        f.push(future_banner[i].colorless_legends.map{|q| "<:Orb_Colorless:455053002152083457> - #{q.name}"}.sort)
      end
      f.push(future_banner[i].gold_legends.map{|q| "<:Orb_Gold:549338084102111250> - #{q.name}"}.sort) if future_banner[i].gold_legends.length>0
      f.flatten!
      y=y.reject{|q| q[1]==f.join("\n")}
      f=[]
      f.push(future_banner[i].reds.map{|q| "<:Orb_Red:455053002256941056> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.push(future_banner[i].blues.map{|q| "<:Orb_Blue:455053001971859477> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.push(future_banner[i].greens.map{|q| "<:Orb_Green:455053002311467048> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.push(future_banner[i].colorlesses.map{|q| "<:Orb_Colorless:455053002152083457> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.push(future_banner[i].golds.map{|q| "<:Orb_Gold:549338084102111250> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.flatten!
      f2=future_banner[i].start_date
      lemoji1='<:Legendary_Effect_Unknown:443337603945857024>'
      lemoji1='<:Mythic_Effect_Unknown:523328368079273984>' if f2[1]%2==1 || future_banner[i].name.include?('Mythic Heroes:')
      lemoji1='<:Legendary_Effect_Unknown:443337603945857024>' if future_banner[i].name.include?('Legendary Heroes:')
      mo=['','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec']
      mo=$spanish_months[0].map{|q| "#{q[0].upcase unless q.length<=0}#{q[1,2]}"} if Shardizard==$spanishShard
      f2="#{f2[0]}#{mo[f2[1]]}#{f2[2]}"
      f3=future_banner[i].end_date
      f3="#{f3[0]}#{mo[f3[1]]}#{f3[2]}"
      y.unshift(["#{f2}#{lemoji1}#{f3}",f.join("\n")])
    end
  end
  current_banner=$banners.reject{|q| !has_any?(q.tags,['Legendary','LegendaryRemix']) || !q.isCurrent?}
  if current_banner.length>0
    current_banner.reverse!
    t=Time.now
    timeshift=8
    timeshift-=1 unless t.dst?
    t-=60*60*timeshift
    for i in 0...current_banner.length
      f=[]
      f.push(current_banner[i].reds.map{|q| "<:Orb_Red:455053002256941056> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.push(current_banner[i].blues.map{|q| "<:Orb_Blue:455053001971859477> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.push(current_banner[i].greens.map{|q| "<:Orb_Green:455053002311467048> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.push(current_banner[i].colorlesses.map{|q| "<:Orb_Colorless:455053002152083457> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.push(current_banner[i].golds.map{|q| "<:Orb_Gold:549338084102111250> - #{'~~' if q.legendary.nil?}#{q.name}#{'~~' if q.legendary.nil?}"}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')})
      f.flatten!
      f2=current_banner[i].start_date
      lemoji1='<:Legendary_Effect_Unknown:443337603945857024>'
      lemoji1='<:Mythic_Effect_Unknown:523328368079273984>' if f2[1]%2==1 || current_banner[i].name.include?('Mythic Heroes:')
      lemoji1='<:Legendary_Effect_Unknown:443337603945857024>' if current_banner[i].name.include?('Legendary Heroes:')
      f2=current_banner[i].end_date
      t2=Time.new(f2[2],f2[1],f2[0])
      timeshift=8
      timeshift-=1 unless t2.dst?
      t2-=60*60*timeshift
      t2=t2-t+24*60*60
      tme=['days left','hours left','minutes left','seconds left','Current']
      tme=['dias','horas','minutos','segundos','Actual'] if Shardizard==$spanishShard
      if t2/(24*60*60)>1
        f2="#{'Quedan ' if Shardizard==$spanishShard}#{(t2/(24*60*60)).floor} #{tme[0]}"
      elsif t2/(60*60)>1
        f2="#{'Quedan ' if Shardizard==$spanishShard}#{(t2/(60*60)).floor} #{tme[1]}"
      elsif t2/60>1
        f2="#{'Quedan ' if Shardizard==$spanishShard}#{(t2/60).floor} #{tme[2]}"
      elsif t2>1
        f2="#{'Quedan ' if Shardizard==$spanishShard}#{(t2).floor} #{tme[3]}"
      end
      y.unshift(["#{tme[4]}#{lemoji1}#{f2}",f.join("\n")])
    end
  end
  if mode==1
    return y.map{|q| [q[0], q[1].split("\n").map{|q2| q2.split(' - ')}]}
  elsif $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    y=y[0,3] unless safe_to_spam?(event)
    msg="__#{y[0][0]}__\n#{y[0][1]}"
    for i in 1...y.length
      msg=extend_message(msg,"__#{y[i][0]}__\n#{y[i][1]}",event,2)
    end
    event.respond msg
  elsif y.length>5 || y.map{|q| "__#{q[0]}__\n#{q[1]}"}.join("\n\n").length>1500
    y=y[0,6] unless safe_to_spam?(event)
    m=y.length/3
    m+=1 unless y.length%3==0
    for i in 0...m
      x=''
      x="__**Legendary and Mythic Heroes' Appearances**__" if i==0
      x="__**Apariciones de Héroes Legendarios y Míticos**__" if i==0 && Shardizard==$spanishShard
      create_embed(event,x,'',avg_color(c),nil,nil,y[3*i,[3,y.length-3*i].min],2)
    end
  else
    create_embed(event,"__**Legendary and Mythic Heroes' Appearances**__",'',avg_color(c),nil,nil,y,2)
  end
  return nil unless safe_to_spam?(event)
  b=$banners.reject{|q| q.tags.nil? || !has_any?(q.tags,['Legendary','DoubleSpecial','LegendaryRemix']) || q.unit_list.length<=0}.map{|q| q.banner_units}.flatten.uniq
  k=[$units.reject{|q| !q.legendary.nil? || !q.fake.nil? || !q.availability[0].include?('5s') || b.include?(q.name)}.sort{|a,b| a.id<=>b.id},
     $units.reject{|q| !q.legendary.nil? || !q.duo.nil? || !q.fake.nil? || !q.availability[0].include?('p') || q.availability[0].include?('1p') || q.availability[0].include?('2p') || q.availability[0].include?('3p') || q.availability[0].include?('4p') || q.availability[0].include?('TD') || b.include?(q.name)}.sort{|a,b| a.id<=>b.id}]
  colors=[['Red',0xE22141],['Blue',0x2764DE],['Green',0x09AA24],['Colorless',0x64757D],['Unknown',0xAA937A]]
  colors=[['Roja',0xE22141],['Azul',0x2764DE],['Verde',0x09AA24],['Gris',0x64757D],['Desconocido',0xAA937A]] if Shardizard==$spanishShard
  colors2=[[0xAA937A,"__**Seasonal units that have not yet been on a Legendary/Mythic or DoubleSpecial Banner**__","There are too many seasonal zzzzz heroes to display."],
           [avg_color([book_color(3,1)]),"__**5<:Icon_Rarity_5:448266417553539104>-Exclusive units that have not yet been on a Legendary or Mythic Banner**__","There are too many 5<:Icon_Rarity_5:448266417553539104>-Exclusive zzzzz heroes to display."],
           [avg_color([book_color(1,1),book_color(2,1),book_color(3,1)]),"x","zzzzz"]]
  if Shardizard==$spanishShard
    colors2=[[0xAA937A,"__**Personajes de temporada que aún no han estado en un estandarte Legendario/Mítico o DoubleSpecial**__","Hay demasiados héroes zzzzz de temporada para mostrar."],
             [avg_color([book_color(3,1)]),"__**Personajes exclusivos a 5<:Icon_Rarity_5:448266417553539104> que aún no han estado en un estandarte Legendario o Mítico**__","Hay demasiados héroes exclusivos a 5<:Icon_Rarity_5:448266417553539104> zzzzz para mostrar."],
             [avg_color([book_color(1,1),book_color(2,1),book_color(3,1)]),"x","zzzzz"]]
  end
  for i2 in 0...k.length
    f=[]
    k2=k[i2].reject{|q| q.weapon_color != 'Red'}.map{|q| q.name}
    f.push(["<:Orb_Red:455053002256941056>#{colors[0][0]}",k2.map{|q| q}]) unless k2.length<=0
    k2=k[i2].reject{|q| q.weapon_color != 'Blue'}.map{|q| q.name}
    f.push(["<:Orb_Blue:455053001971859477>#{colors[1][0]}",k2.map{|q| q}]) unless k2.length<=0
    k2=k[i2].reject{|q| q.weapon_color != 'Green'}.map{|q| q.name}
    f.push(["<:Orb_Green:455053002311467048>#{colors[2][0]}",k2.map{|q| q}]) unless k2.length<=0
    k2=k[i2].reject{|q| q.weapon_color != 'Colorless'}.map{|q| q.name}
    f.push(["<:Orb_Colorless:455053002152083457>#{colors[3][0]}",k2.map{|q| q}]) unless k2.length<=0
    k2=k[i2].reject{|q| ['Red','Blue','Green','Colorless'].include?(q.weapon_color)}.map{|q| q.name}
    f.push(["<:Orb_Gold:549338084102111250>#{colors[4][0]}",k2.map{|q| q}]) unless k2.length<=0
    if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
      msg=colors2[i2][1]
      tolongs=[]
      for i in 0...f.length
        if f[i][1].length>1900
          tolongs.push(f[i][0].split('>')[1])
        else
          msg=extend_message(msg,"*#{f[i][0]}*: #{f[i][1]}",event)
        end
      end
      msg=extend_message(msg,colors2[i2][2].gsub('zzzzz',list_lift(tolongs,'and')),event) if tolongs.length>0
      event.respond msg
    elsif f.map{|q| "__**#{q[0]}**__\n#{q[1].join("\n")}"}.join("\n\n").length>1700
      tolongs=[]
      for i in 0...f.length
        x=''
        x=colors2[i2][1] if i==0
        if f[i][1].length>1900
          event.respond x if x.length>0
          tolongs.push(f[i][0].split('>')[1])
        else
          c=f[i][0].split('>')[1]
          c=colors.find_index{|q| q[0]==c}
          c=i*1 if c.nil?
          c=colors[c][1]
          create_embed(event,x,'',c,nil,nil,triple_finish(f[i][1]),2)
        end
      end
      event.respond colors2[i2][2].gsub('zzzzz',list_lift(tolongs,'and')) if tolongs.length>0
    else
      create_embed(event,colors2[i2][1],'',colors[4][1],nil,nil,f.map{|q| [q[0],q[1].join("\n")]},2)
    end
    colors[4][1]=colors2[i2+1][0]
  end
end

def disp_groups(event,bot)
  dis=['Dynamic Global','Manually Global','Server-specific','Available Groups','members']
  dis=['Dinámico y Global','Manual y Global','Específico del servidor','Grupos disponibles','miembros'] if Shardizard==$spanishShard
  unless safe_to_spam?(event)
    k=0
    k=event.server.id unless event.server.nil?
    g1=$groups.reject{|q| !q.fake.nil? || (q.units.length==q.unit_list.length && q.unit_list.length>0) || ['Legendaries','Mythics','Resplendent','Refreshers','DuoUnits','HarmonicUnits'].include?(q.name)}
    g1x=$groups.reject{|q| !['Legendaries','Mythics','Resplendent','Refreshers','DuoUnits','HarmonicUnits'].include?(q.name)}
    g1=g1.reject{|q| q.name=="Mathoo'sWaifus"} unless event.user.id==167657750971547648
    g2=$groups.reject{|q| !q.fake.nil? || !(q.units.length==q.unit_list.length && q.unit_list.length>0)}
    g3=$groups.reject{|q| q.fake.nil? || !q.fake.include?(k)}
    g=[]
    g.push(["**#{dis[0]}**",g1.map{|q| "#{q.name.gsub('&','/')} (#{q.unit_list.length} #{dis[4]})"}.join("\n")])
    g[0][1]=g[0][1].split("\n").sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')}.join("\n")
    g.push(["**#{dis[1]}**",g2.map{|q| "#{q.name.gsub('&','/')} (#{q.unit_list.length} #{dis[4]})"}.join("\n")])
    g.push(["**#{dis[2]}**",g3.map{|q| "#{q.name.gsub('&','/')} (#{q.unit_list.length} #{dis[4]})"}.join("\n")]) if g3.length>0
    create_embed(event,"__**#{dis[3]}**__",'',0xD49F61,nil,nil,g,2)
    return nil
  end
  str=''
  x=$groups.map{|q| q}
  for i in 0...x.length
    if x[i].name=="Mathoo'sWaifus" && event.user.id != 167657750971547648
    elsif x[i].isPostable?(event)
      if x[i].unit_list(event).length>50
        str=extend_message(str,"**#{x[i].fullName}** - (#{x[i].unit_list(event).length} #{dis[4]})#{"\n*[#{dis[2]}]*" unless x[i].fake.nil?}",event,2)
      else
        str=extend_message(str,"__**#{x[i].fullName}**__#{"\n*[#{dis[2]}]*" unless x[i].fake.nil?}\n#{x[i].unit_list(event).map{|q| q.postName}.sort{|a,b| a.gsub('~~','')<=>b.gsub('~~','')}.join(', ')}",event,2)
      end
    end
  end
  event.respond str
end

def log_channel
  return 431862993194582036 if Shardizard==4
  return 536307117301170187 if Shardizard==-1
  return 386658080257212417
end

def add_new_alias(bot,event,newname,unit,modifier=nil,modifier2=nil,mode=0)
  return add_new_alias_to_spain(bot,event,newname,unit,modifier=nil,modifier2=nil,mode=0) if Shardizard==$spanishShard
  nicknames_load()
  err=false
  str=''
  if !event.server.nil? && event.server.id==363917126978764801
    str="You guys revoked your permission to add aliases when you refused to listen to me regarding the Erk alias for Serra."
    err=true
  elsif newname.nil? || unit.nil?
    str="The alias system can cover:\n- Units\n- Skills (Weapons, Assists, Specials, Passives)\n- Structures\n- Items\n- Accessories\n\nYou must specify both:\n- one of the above\n- an alias you wish to give that object"
    err=true
  elsif event.user.id != 167657750971547648 && event.server.nil?
    str='Only my developer is allowed to use this command in PM.'
    err=true
  elsif !is_mod?(event.user,event.server,event.channel) && ![368976843883151362,195303206933233665].include?(event.user.id)
    str='You are not a mod.'
    err=true
  elsif newname.include?('"') || unit.include?('"')
    str='Full stop.  " is not allowed in an alias.'
    err=true
  elsif newname.include?("\n") || unit.include?("\n")
    str="Newlines aren't allowed in aliases"
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
      str="You cannot add aliases to multiunits."
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
      str="You cannot add aliases to multiunits."
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
    str="The alias system can cover:\n- Units\n- Skills (Weapons, Assists, Specials, Passives)\n- Structures\n- Items\n- Accessories\n\nNeither #{newname} nor #{unit} is any of the above."
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
    str="#{newname} contains an Extended Unicode character (a character with a Unicode ID beyond 65,535, almost all of which are emoji).\nDue to the way I store aliases and how Ruby parses strings from text files, I could theoretically store an Extended Unicode character but be unable to find a matching alias."
  end
  if err
    str=["#{str}\nPlease try again.","#{str}\nTrying to list aliases instead."][mode]
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
    str2="**Server:** #{event.server.name} (#{event.server.id}) - #{shard_data(0)[Shardizard]} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:**"
  end
  str2="#{str2} #{event.user.distinct} (#{event.user.id})"
  if type[1].gsub('*','')=='Unit' && kk2.is_a?(FEHUnit) && first_sub(newname,kk2.alts[0].gsub('*',''),'').length<=1 && event.user.id != 167657750971547648
    event.respond "#{newname} has __***NOT***__ been added to #{matchnames[1]}'s aliases.\nOne need look no farther than BCamilla, SCamilla, BLucina, BLyn, LLyn, or SXander to understand why single-letter alias differentiation is a bad idea.  Especially BLucina and LLyn."
    bot.channel(logchn).send_message("#{str2}\n~~**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Single-letter differentiation.")
    return nil
  elsif checkstr.downcase =~ /(7|t)+?h+?(o|0)+?(7|t)+?/
    event.respond "#{newname} has __***NOT***__ been added to #{matchnames[1]}'s aliases."
    bot.channel(logchn).send_message("#{str2}\n~~**#{type[1].gsub('*','')} Alias:** #{newname} for #{unit}~~\n**Reason for rejection:** Begone, alias.")
    return nil
  elsif checkstr.downcase =~ /n+?((i|1)+?|(e|3)+?)(b|g|8)+?(a|4|(e|3)+?r+?)+?/
    event.respond "That name has __***NOT***__ been added to #{matchnames[1]}'s aliases."
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
  str="The alias **#{newname}** for the #{type[1].gsub('*','').downcase} *#{matchnames[1]}* exists in a server already."
  str="#{str}  Making it global now." if glbl<=0
  str="#{str}  Adding this server to those that can use it." unless glbl<=0
  str="**#{newname}** has been #{'globally ' if glbl<=0}added to the aliases for the #{type[1].gsub('*','').downcase} *#{matchnames[1]}*." if newalias
  str="#{str}\nPlease double-check that the alias stuck."
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

def remove_multialias(bot,event,multi,unit)
  alz=$aliases.map{|q| q}
  unt=find_unit(event,[],unit)
  mult=alz.find_index{|q| q[0]=='Unit' && q[1].downcase==multi.downcase && q[2].is_a?(Array)}
  return nil if unt.nil? || mult.nil?
  unt=[unt] unless unt.is_a?(Array)
  alz[mult][2]=alz[mult][2].reject{|q| unt.map{|q2| q2.id}.include?(q) || unt.map{|q2| q2.name}.include?(q)}
  logchn=log_channel()
  str1="#{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} has been removed from the multi-unit alias **#{alz[mult][1]}**."
  str2=''
  if event.server.nil?
    str2="**PM with dev:**"
  else
    str2="**Server:** #{event.server.name} (#{event.server.id}) - #{shard_data(0)[Shardizard]} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:**"
  end
  str2="#{str2} #{event.user.distinct} (#{event.user.id})"
  if alz[mult][2].length<=0
    str1="#{str1}\nThere are no more units in the alias, so I'm deleting it."
    str2="#{str2}\n~~**Multi-unit Alias:** #{alz[mult][1]} for #{unt.map{|q| q.name}.join(', ')}~~ "
    alz[mult]=nil
    if rand(1000)==0
      str2="#{str2}**YEETED**"
    else
      str2="#{str2}**DELETED**"
    end
  elsif alz[mult][2].length<=1
    alz[mult][2]=alz[mult][2][0]
    str1="#{str1}\nThere was only one unit in the alias, so I'm converting it to a single-unit alias."
    str2="#{str2}\n~~**Multi-unit Alias:** #{alz[mult][1]} for #{unt.map{|q| q.name}.join(', ')}~~ *Unit#{'s' unless unt.length==1} removed from alias*"
  else
    str2="#{str2}\n~~**Multi-unit Alias:** #{alz[mult][1]} for #{unt.map{|q| q.name}.join(', ')}~~ *Unit#{'s' unless unt.length==1} removed from alias*"
  end
  alz.compact!
  event.respond str1
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

def disp_unit_stats(bot,event,xname,extrastr=nil,sizex='smol',includeskills=false)
  args=event.message.text.downcase.split(' ')
  if has_any?(args,['tiny','small','smol','micro','little']) || (Shardizard==$spanishShard && has_any?(['pequeno','pequena','pequeño','pequeña'],args))
    sizex='xsmol'
  elsif has_any?(args,['big','tol','macro','large']) || (Shardizard==$spanishShard && args.include?('grande'))
    sizex='medium'
  elsif has_any?(args,['huge','massive']) || (Shardizard==$spanishShard && args.include?('enorme'))
    sizex='giant'
  end
  if sizex=='giant' && !safe_to_spam?(event)
    event.respond "I will not wipe the chat completely clean.  Please use this command in PM.\nIn the meantime, I will show the standard form of this command." unless Shardizard==$spanishShard
    event.respond "No limpiaré el chat por completo. Utilice este comando en mensajes privados.\nMientras tanto, mostraré la forma estándar de este comando." if Shardizard==$spanishShard
    sizex='medium'
  end
  xname=xname[0].split('(')[0] if xname==['Robin(M)','Robin(F)'] || xname==['Robin(F)','Robin(M)'] || xname==['Kris(M)','Kris(F)'] || xname==['Kris(F)','Kris(M)']
  if xname.is_a?(Array)
    g=get_markers(event)
    u=$units.reject{|q| !q.fake.nil? && q.fake[0]!=g}.map{|q| q.name}
    xname=xname.reject{|q| !u.include?(q) && !['Robin','Kris'].include?(q)}
    for i in 0...xname.length
      disp_unit_stats(bot,event,xname[i],extrastr,sizex)
    end
    return nil
  elsif xname.is_a?(FEHUnit)
  end
  data_load()
  ftr=nil
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args.compact!
  if xname.nil?
    if args.nil? || args.length<1
      smol_err(bot,event,false,['smol','xsmol'].include?(sizex))
      return nil
    end
  elsif xname.is_a?(FEHUnit)
    unit=xname.clone
  elsif ['Robin','Kris'].include?(xname)
    unit=$units.find_index{|q| q.name=="#{xname}(F)"}
    event.respond nomf() if unit.nil?
    return nil if unit.nil?
    unit=$units[unit].clone
    unit.name="#{xname} (shared stats)"
  else
    unit=$units.find_index{|q| q.name==xname}
    smol_err(bot,event,false,['smol','xsmol'].include?(sizex)) if unit.nil?
    return nil if unit.nil?
    unit=$units[unit].clone
  end
  sizex='medium' if sizex=='smol' && has_any?(event.message.text.downcase.split(' '),['growths','growth','gps','gp'])
  flurp=find_stats_in_string(event,s,0,unit.name)
  rarity=flurp[0]
  merges=flurp[1]
  boon=flurp[2]
  bane=flurp[3]
  support=flurp[4]
  refinement=flurp[5]
  blessing=flurp[6]
  blessing=blessing[0,8] if blessing.length>8
  transformed=flurp[7]
  flowers=flurp[8]
  resp=flurp[9]
  bonus=get_bonus_type(event)
  wpn=[]
  wpn=extrastr.downcase.split(' ') unless extrastr.nil?
  weapon=nil
  wpninvoke=''
  wpnlegal=true
  if has_any?(args,["mathoo's"]) || (has_any?(args,['my']) && event.user.id==167657750971547648) || (Shardizard==$spanishShard && (has_any?(args,["demathoo"]) || (has_any?(args,['mi']) && event.user.id==167657750971547648)))
    u=$dev_units.find_index{|q| q.name==unit.name}
    if u.nil?
      if Shardizard==$spanishShard
      elsif $dev_nobodies.include?(unit.name)
        event.respond "Mathoo has that unit, but marked that he doesn't want to record #{unit.pronoun(true)} data.  Showing default data."
      elsif [$dev_somebodies,$dev_waifus].flatten.include?(unit.name)
        event.respond "Mathoo does not have that unit, much as he wants to.  Showing default data."
      else
        event.respond "Mathoo does not have that unit.  Showing default data."
      end
    else
      unit=$dev_units[u].clone
      resp=false
      resp=true if unit.resplendent=='r'
    end
  elsif donate_trigger_word(event)>0
    m=donate_trigger_word(event)
    u=$donor_units.find_index{|q| q.name==unit.name && q.owner_id==m}
    unless u.nil?
      unit=$donor_units[u].clone
      resp=false
      resp=true if unit.resplendent=='r'
    end
  end
  if wpn.include?('prf') && !unit.dispPrf(bonus).nil?
    wpninvoke='prf'
    weapon=unit.dispPrf(bonus)
  elsif wpn.include?('summoned') && ['Robin','Kris','Robin (shared stats)','Kris (shared stats)'].include?(xname)
    wpninvoke='summoned'
    x=unit.summoned.map{|q2| q2.reject{|q| !q.type.include?('Weapon')}.sort{|a,b| a.id<=>b.id}}
    weapon=x.map{|q| q[-1]} unless x.length<=0
  elsif wpn.include?('summoned')
    wpninvoke='summoned'
    x=unit.summoned.reject{|q| !q.type.include?('Weapon')}.sort{|a,b| a.id<=>b.id}
    weapon=x[-1] unless x.length<=0
  else
    weapon=find_data_ex(:find_skill,event,wpn,nil,bot,false,true)
    weapon=nil if weapon.is_a?(Array) && weapon.length<=0
    weapon=weapon[0] if weapon.is_a?(Array) && weapon.length>0
    unless weapon.nil?
      weapon=weapon.legalize(unit)
      if weapon[0].is_a?(Array)
        wpnlegal=!weapon.map{|q| q[1]}.include?(false)
        weapon=weapon.map{|q| q[0]}
      else
        wpnlegal=weapon[1]
        weapon=weapon[0]
      end
    end
  end
  unless wpnlegal
    weapon=nil if sizex=='xsmol'
    sizex='medium' if sizex=='smol'
  end
  diff=[0,0,0,0,0]
  if weapon.is_a?(Array)
    weapon=weapon.map{|q| q.clone}
    weapon[0].name=weapon.map{|q| q.name}.join(' / ')
    for i in 0...diff.length
      xx2=weapon.map{|q| q.weapon_stats[i]}
      diff[i]=xx2[0]-xx2[1]
    end
    weapon=weapon[0]
  end
  skill_list=make_stat_skill_list_1(unit.name,event,args)
  skill_list_2=make_stat_skill_list_2(unit.name,event,args)
  skill_list_2=[] if sizex=='xsmol'
  sizex='medium' if sizex=='smol' && skill_list_2.length>0
  flds=[]
  zelg=false
  zelg=true if has_any?(event.message.text.downcase.split(' '),['weaponless','zelgiused',"zelgius'd"])
  zelg=true if event.message.text.downcase.split(' ').include?('zelgius') && unit.name != 'Zelgius'
  flds=unit.dispSkills(bot,event,rarity,true,true,zelg) if includeskills
  flds=unit.dispSkills(bot,event,rarity,false,true,zelg) if sizex=='giant'
  if sizex=='giant' && unit.owner.nil?
    flds.push(['<:Passive_S:443677023626330122> Sacred Seal','~~*none*~~'])
    unless unit.duo.nil?
      ff=flds[6].map{|q| q}
      flds=flds.reject{|q| q==ff}
      ff.push(1)
      flds.push(ff)
    end
  end
  header=unit.class_header(bot)
  if header.length>250
    h=header.split("\n")
    header=[h[0],'']
    j=0
    for i in 1...h.length
      if "#{header[j]}\n#{h[i]}".length>250 && j==0
        j+=1
        header[j]="#{h[i]}"
      else
        header[j]="#{header[j]}\n#{h[i]}"
      end
    end
  end
  pairup=false
  pairup=true if has_any?(event.message.text.downcase.split(' '),['pairup','paired','pair','pair-up']) && !unit.owner.nil?
  pairup=true if has_any?(event.message.text.downcase.split(' '),['agrupar']) && !unit.owner.nil? && Shardizard==$spanishShard
  lvlvl=40
  lvlvl=79 if has_any?(event.message.text.downcase.split(' '),['79','level79','lv79','l79'])
  lvlvl=99 if has_any?(event.message.text.downcase.split(' '),['99','level99','lv99','l99'])
  text=unit.statGrid(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup,lvlvl)
  if unit.name=='Kiran' && unit.owner.nil?
    text=unit.starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup)
    text="#{text}\n\n#{unit.statGrid(bot,rarity,boon,bane,merges,flowers,'',bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup,lvlvl)}"
    text="#{text}\n#{unit.statGrid(bot,rarity,boon,bane,merges,flowers,'x',bonus,blessing,resp,weapon,refinement,transformed,skill_list,pairup,lvlvl)}"
  else
    text=unit.starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup,2) unless ['smol','xsmol'].include?(sizex)
    text=unit.starHeader(bot,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup) if ['medium'].include?(sizex)
  end
  if unit.weapon_type=='Beast' && !weapon.nil? && weapon.weapon_stats.length>5 && !['smol','xsmol'].include?(sizex)
    xx=[]
    xx.push("#{'+' if weapon.weapon_stats[5]>0}#{weapon.weapon_stats[5]} HP") unless weapon.weapon_stats[5]==0
    xx.push("#{'+' if weapon.weapon_stats[6]>0}#{weapon.weapon_stats[6]} At#{'k' unless Shardizard==$spanishShard}#{'q' if Shardizard==$spanishShard}") unless weapon.weapon_stats[6]==0
    xx.push("#{'+' if weapon.weapon_stats[7]>0}#{weapon.weapon_stats[7]} Spd") unless weapon.weapon_stats[7]==0 || Shardizard==$spanishShard
    xx.push("#{'+' if weapon.weapon_stats[7]>0}#{weapon.weapon_stats[7]} Vel") unless weapon.weapon_stats[7]==0 || Shardizard !=$spanishShard
    xx.push("#{'+' if weapon.weapon_stats[8]>0}#{weapon.weapon_stats[8]} Def") unless weapon.weapon_stats[8]==0
    xx.push("#{'+' if weapon.weapon_stats[9]>0}#{weapon.weapon_stats[9]} Res") unless weapon.weapon_stats[9]==0
    if xx.length>0
      if Shardizard==$spanishShard
        text="#{text}\nCuando se transforma: #{xx.join(', ')}\nIncluye la palabra \"transformed\" tener esto aplicado."
      else
        text="#{text}\nWhen transformed: #{xx.join(', ')}\nInclude the word \"transformed\" to apply this directly."
      end
    end
  end
  unless ['smol','xsmol'].include?(sizex)
    f=unit.statList(bot,(sizex=='giant' || has_any?(event.message.text.downcase.split(' '),['growths','growth','gps','gp'])),diff,rarity,boon,bane,merges,flowers,support,bonus,blessing,resp,weapon,refinement,transformed,skill_list,skill_list_2,wpnlegal,pairup,lvlvl)
    f.shift if unit.is_a?(SuperUnit) && !(sizex=='giant' || has_any?(event.message.text.downcase.split(' '),['growths','growth','gps','gp'])) && flds.length>0
    for i in 0...f.length
      flds.unshift(f[f.length-1-i])
    end
  end
  flds=nil if flds.length<=0
  ftr="Include the word \"#{unit.bonus_type}\" to include bonus unit stats" if unit.bonus_type.length>0 && bonus.length<=0
  ftr="Incluye la palabra \"#{unit.bonus_type}\" para mostrar las estadísticas de un personaje con bonificación." if unit.bonus_type.length>0 && bonus.length<=0 && Shardizard==$spanishShard
  if ['smol','xsmol'].include?(sizex) && ftr.nil? && unit.owner.nil? && bonus != 'Enemy'
    ftr="Score does not include SP cost of #{'non-weapon ' unless weapon.nil?}skills."
    ftr="Puntaje no incluye el coste de SP de las habilidades#{' que no son armas' unless weapon.nil?}." if Shardizard==$spanishShard
  end
  ftr="Include the word \"Resplendent\" to ascend this unit." if unit.hasResplendent? && !resp && unit.owner.nil?
  ftr="Incluye la palabra \"Resplendent\" para hacer este carácter más fuerte." if unit.hasResplendent? && !resp && unit.owner.nil? && Shardizard==$spanishShard
  unless wpninvoke.length>0 || weapon.nil? || weapon.name[-1]=='+' || weapon.next_steps(event,1).reject{|q| q.name[-1]!='+'}.length<=0 || !unit.owner.nil?
    ftr="You equipped the T#{weapon.tier} version of the weapon.  Perhaps you meant #{weapon.name}+ ?"
    ftr="Equipaste la versión R#{weapon.tier} de la arma.  ¿Te refieres a #{weapon.name}+ ?"
  end
  unless (diff.max==0 && diff.min==0) || !['smol','xsmol'].include?(sizex)
    ftr="Stats displayed are for #{unit.name.split(' (')[0]}(M).  #{unit.name.split(' (')[0]}(F) has "
    if diff[0]!=0 || diff[2,3].reject{|q| q==0}.length>0
      ftr="#{ftr}the following stat changes: #{diff.map{|q| "#{'+' if q>0}#{q}"}.join('/')}"
    elsif diff[1]>0
      ftr="#{ftr}#{diff[1]} fewer Atk."
    elsif diff[1]<0
      ftr="#{ftr}#{-diff[1]} more Atk."
    else
      ftr=nil
    end
    if Shardizard==$spanishShard
      ftr="Las estadísticas que se muestran son para #{unit.name.split(' (')[0]}(M).  #{unit.name.split(' (')[0]}(F) tiene "
      if diff[0]!=0 || diff[2,3].reject{|q| q==0}.length>0
        ftr="#{ftr}los siguientes cambios: #{diff.map{|q| "#{'+' if q>0}#{q}"}.join('/')}"
      elsif diff[1]>0
        ftr="#{ftr}#{diff[1]} menos Atq."
      elsif diff[1]<0
        ftr="#{ftr}#{-diff[1]} más Atq."
      else
        ftr=nil
      end
    end
  end
  ftr='For the Kiran-shaped enemy in Book IV Ch. 12-5, type the name "Hood".' if unit.name=='Kiran'
  ftr='Para el enemigo con forma de Kiran en el libro 4 cap. 12-5, use el nombre "Hood".' if unit.name=='Kiran' && Shardizard==$spanishShard
  create_embed(event,["__#{"#{unit.owner}'s " unless unit.owner.nil? || Shardizard==$spanishShard}**#{unit.name}**#{unit.submotes(bot)}#{" de #{unit.owner}" unless unit.owner.nil? || Shardizard !=$spanishShard}__",header],text,unit.disp_color,ftr,unit.thumbnail(event,bot,resp),flds)
end

def disp_unit_skills(bot,event,xname)
  args=event.message.text.downcase.split(' ')
  xname='Robin' if xname==['Robin(M)', 'Robin(F)'] || xname==['Robin(F)', 'Robin(M)']
  xname='Kris' if xname==['Kris(M)', 'Kris(F)'] || xname==['Kris(F)', 'Kris(M)']
  if xname.is_a?(Array)
    g=get_markers(event)
    u=$units.reject{|q| !q.fake.nil? && q.fake[0]!=g}.map{|q| q.name}
    xname=xname.reject{|q| !u.include?(q) && !['Robin','Kris'].include?(q)}
    for i in 0...xname.length
      disp_unit_skills(bot,event,xname[i])
    end
    return nil
  end
  data_load()
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ')
  s=event.message.text if all_commands().include?(a[0])
  args=sever(s.gsub(',','').gsub('/',''),true).split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  args.compact!
  if xname.nil?
    if args.nil? || args.length<1
      event.respond nomf()
      return nil
    end
  elsif ['Robin','Kris'].include?(xname)
    unit=$units.find_index{|q| q.name=="#{xname}(F)"}
    event.respond "No matches found." if unit.nil?
    return nil if unit.nil?
    unit=$units[unit].clone
    unit.name="#{xname} (shared stats)"
  else
    unit=$units.find_index{|q| q.name==xname}
    event.respond nomf() if unit.nil?
    return nil if unit.nil?
    unit=$units[unit].clone
  end
  flurp=find_stats_in_string(event,s,0,unit.name)
  rarity=flurp[0]
  merges=flurp[1]
  resp=flurp[9]
  if has_any?(args,["mathoo's"]) || (has_any?(args,['my']) && event.user.id==167657750971547648) || (Shardizard==$spanishShard && (has_any?(args,["demathoo"]) || (has_any?(args,['mi']) && event.user.id==167657750971547648)))
    u=$dev_units.find_index{|q| q.name==unit.name}
    if u.nil?
      if Shardizard==$spanishShard
      elsif $dev_nobodies.include?(unit.name)
        event.respond "Mathoo has that unit, but marked that he doesn't want to record #{unit.pronoun(true)} data.  Showing default data."
      elsif [$dev_somebodies,$dev_waifus].flatten.include?(unit.name)
        event.respond "Mathoo does not have that unit, much as he wants to.  Showing default data."
      else
        event.respond "Mathoo does not have that unit.  Showing default data."
      end
    else
      unit=$dev_units[u].clone
      resp=false
      resp=true if unit.resplendent=='r'
    end
  elsif donate_trigger_word(event)>0
    m=donate_trigger_word(event)
    u=$donor_units.find_index{|q| q.name==unit.name && q.owner_id==m}
    unless u.nil?
      unit=$donor_units[u].clone
      resp=false
      resp=true if unit.resplendent=='r'
    end
  end
  flds=[]
  ftr=nil
  zelg=false
  zelg=true if has_any?(event.message.text.downcase.split(' '),['weaponless','zelgiused',"zelgius'd"])
  zelg=true if event.message.text.downcase.split(' ').include?('zelgius') && unit.name != 'Zelgius'
  flds=unit.dispSkills(bot,event,rarity,false,true,zelg,true)
  if flds[-1].is_a?(String)
    ftr="#{flds[-1]}"
    flds.pop
  end
  header=unit.class_header(bot)
  if header.length>250
    h=header.split("\n")
    header=[h[0],'']
    j=0
    for i in 1...h.length
      if "#{header[j]}\n#{h[i]}".length>250 && j==0
        j+=1
        header[j]="#{h[i]}"
      else
        header[j]="#{header[j]}\n#{h[i]}"
      end
    end
  end
  text=unit.starHeader2(bot,true,rarity,'','',merges,0,'','',[],false,nil,'',false,[],[],true,false,0)
  if Shardizard==$spanishShard
    text="#{text}\nLider sombrío" if unit.name=='Mathoo' && has_any?(event.message.text.downcase.split(' '),['rokkr','enemy','boss'])
    text="#{text}\nLider de los enemigos" if unit.name=='Hel' && has_any?(event.message.text.downcase.split(' '),['enemy','boss'])
    text="#{text}\nError de Zelgius aplicado" if zelg
    ftr='Para el enemigo con forma de Kiran en el libro 4 cap. 12-5, use el nombre "Hood".' if unit.name=='Kiran'
  else
    text="#{text}\nRokkr Unit" if unit.name=='Mathoo' && has_any?(event.message.text.downcase.split(' '),['rokkr','enemy','boss'])
    text="#{text}\nEnemy Boss Unit" if unit.name=='Hel' && has_any?(event.message.text.downcase.split(' '),['enemy','boss'])
    text="#{text}\nZelgius glitch applied" if zelg
    ftr='For the Kiran-shaped enemy in Book IV Ch. 12-5, type the name "Hood".' if unit.name=='Kiran'
  end
  create_embed(event,["__#{"#{unit.owner}'s " unless unit.owner.nil? || Shardizard==$spanishShard}**#{unit.name}**#{unit.submotes(bot)}#{" de #{unit.owner}" unless unit.owner.nil? || Shardizard !=$spanishShard}__",header],text,unit.disp_color,ftr,unit.thumbnail(event,bot,resp),flds)
end

def disp_skill_data(bot,event,xname,colors=false,includespecialerror=false)
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
  errstr="No matches found.  If you are looking for data on skills a particular unit learns, try ```#{event.message.text.downcase.gsub('skill','skills')}``` instead." if includespecialerror
  errstr="No hay coincidencias.  Si está buscando datos sobre las habilidades que aprende un personaje en particular, intente ```#{event.message.text.downcase.gsub('habilidad','habilidades')}``` en su lugar." if includespecialerror && Shardizard==$spanishShard
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
          event.respond "Multiunit found, please choose one of the following:\n#{x.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
          return nil
        end
      else
        disp_skill_data(bot,event,x.name,colors,includespecialerror)
        return nil
      end
    elsif x.is_a?(Array)
      event.respond "Multiunit found, please choose one of the following:\n#{x.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join("\n")}"
      return nil
    end
    sktype=[]; baseweapon=false; rar=0
    for i in 0...args.length
      rar=args[i][0,1].to_i if rar<=0 && args[i][0,1].to_i.to_s==args[i][0,1] && args[i][0,1].to_i>0 && args[i][0,1].to_i<=Max_rarity_merge[0] && ["#{args[i][0,1]}*","#{args[i][0,1]}star","#{args[i][0,1]}-star"].include?(args[i])
      blevel-=1 if args[i].downcase=='base' && !baseweapon
      baseweapon=true if ['base','summoned','baseweapon'].include?(args[i].downcase)
      sktype.push('Weapon') if ['weapon','baseweapon'].include?(args[i].downcase)
      sktype.push('Assist') if ['assist'].include?(args[i].downcase)
      sktype.push('Special') if ['special'].include?(args[i].downcase)
      sktype.push('Passive(A)') if ['a','apassive','passivea','a_passive','passive_a'].include?(args[i].downcase)
      sktype.push('Passive(B)') if ['b','bpassive','passiveb','b_passive','passive_b'].include?(args[i].downcase)
      sktype.push('Passive(C)') if ['c','cpassive','passivec','c_passive','passive_c'].include?(args[i].downcase)
      sktype.push('Resonant') if ['duo','duos','harmonic','harmonics','resonant','resonants','resonance','resonances'].include?(args[i].downcase) && !x.duo.nil?
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
        event.respond "You're looking up the skill of **#{x.name}#{x.emotes(bot)}**, but which one?"
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
        event.respond "**#{x.name}#{x.emotes(bot)}** does not have a skill in that slot#{' at that rarity' unless rar==Max_rarity_merge[0]}."
      else
        disp_skill_data(bot,event,x2.name,colors,includespecialerror)
      end
      return nil
    end
    skill=f[-1].clone
    skill=f[-2].clone if sktype[0]=='Weapon' && baseweapon && skill.prerequisite.nil?
  else
    skill=$skills[skill].clone
  end
  if skill.type.include?('Weapon') && has_any?(event.message.text.downcase.split(' '),['refinement','refinements','(w)'])
    if skill.name=='Falchion'
      disp_skill_data(bot,event,'Drive Spectrum',colors)
      disp_skill_data(bot,event,'Brave Falchion',colors)
      disp_skill_data(bot,event,'Spectrum Bond',colors)
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
        event.respond "#{skill.name} does not have an Effect Mode.  Showing #{skill.name}'s default data."
      elsif sk1==sk2
        disp_skill_data(bot,event,sk1.fullName,colors)
        return nil
      else
        disp_skill_data(bot,event,sk1.fullName,colors)
        disp_skill_data(bot,event,sk2.fullName,colors)
        return nil
      end
    elsif !skill.refinement_name.nil?
      disp_skill_data(bot,event,skill.refinement_name.fullName,colors)
      return nil
    elsif !skill.refine.nil?
      event.respond "#{skill.name} does not have an Effect Mode.  Showing #{skill.name}'s default data."
    else
      event.respond "#{skill.name} cannot be refined.  Showing #{skill.name}'s default data."
    end
  end
  unless skill.type.include?('Weapon') && event.message.text.downcase.split(' ').include?('refined') && blevel<=0
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
    colors=true if has_any?(['color','colors','colour','colours'],args)
    ftr=nil
    flds=nil
    text=''
    text="**Effective against:** #{skill.eff_against('',false,event)}" unless skill.eff_against('',false,event).length<=0
    text="#{text}**Beast Mechanics:** At start of turn, if unit is either not adjacent to any allies, or adjacent to only beast and dragon allies, unit transforms.  Otherwise, unit reverts back to humanoid form." if skill.tags.include?('Weapon') && skill.restrictions.include?('Beasts Only')
    text="#{text}\n**Transformation Mechanics:** #{skill.transform_type}" unless skill.transform_type.nil?
    endtext=''
    ftr="#{skill.tome_tree_reverse} Mages can still learn this skill, it will just take more SP." unless skill.tome_tree_reverse.nil?
    ftr="Debuff is applied at end of combat if unit attacks, and lasts until the foes' next actions." unless skill.dagger_debuff.nil? || skill.dagger_debuff.length<=0
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
      text="__**#{sk1.name}**__\n#{sk1.mcr}\n**Effect:** #{sk1.description}\n<:Prf_Sparkle:490307608973148180>**Prf to:** #{sk1.exclusivity.join(', ')}\n**Promotes from:** #{list_lift(sk1.prerequisite.map{|q| "*#{q}*"},'or')}"
      text="#{text}\n\n__**#{sk2.name}**__\n#{sk2.mcr}\n**Effect:** #{sk2.description}\n<:Prf_Sparkle:490307608973148180>**Prf to:** #{sk2.exclusivity.join(', ')}\n**Promotes from:** #{list_lift(sk2.prerequisite.map{|q| "*#{q}*"},'or')}"
      text="#{text}\n\n**SP Cost:** #{sk1.sp_cost} SP\n**Cumulitive SP Cost:** #{sk1.cumulitive_sp_cost} SP"
    elsif ['Whelp (All)','Yearling (All)','Adult (All)'].include?(skill.name)
      m=skill.name.split(' (')[0]
      skzz=$skills.reject{|q| q.name=="#{m} (All)" || (q.name[0,m.length+2]!="#{m} (" && !((q.name=='Hatchling (Flier)' && m=='Whelp') || (q.name=='Fledgling (Flier)' && m=='Yearling')))}
      for i in 0...skzz.length
        m=skzz[i].restrictions[1].split(' ').map{|q| q.gsub('s','')}.reject{|q| !['Infantry','Armor','Flier','Cavalry'].include?(q)}
        movemoji=''
        for i2 in 0...m.length
          moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Icon_Move_#{m[i2]}"}
          movemoji="#{movemoji}#{moji[0].mention}" if moji.length>0
        end
        text="#{text}\n\n#{movemoji} __**#{skzz[i].name}**__"
        text="#{text}\n**Transformation Mechanics:** #{skzz[i].transform_type}" unless skzz[i].transform_type.nil? || skzz[i].transform_type=='-'
        text="#{text}\n**Effect:** #{skzz[i].description}" unless skzz[i].description.nil? || skzz[i].description=='-' || skzz[i].description.length<=0
        text="#{text}\n**Promotes from:** #{list_lift(skzz[i].prerequisite.map{|q| "*#{q}*"},'or')}" unless skzz[i].prerequisite.nil? || skzz[i].prerequisite.length<=0
        text="#{text}\n**Promotes into:** #{skzz[i].next_steps(event)}" unless skzz[i].next_steps(event).nil? || skzz[i].next_steps(event).length<=0
      end
      text="#{text}\n\n**SP Cost:** #{skill.disp_sp_cost} SP#{" (#{skill.disp_sp_cost(true)} SP when inherited)" if skill.exclusivity.nil? || skill.exclusivity.length<=0}"
    else
      text="#{text}\n**Effect:** #{skill.description}" unless skill.description.nil? || skill.description.length<=0 || skill.description=='-'
      text="#{text}\nIf foe's Range = 2, calculates damage using the lower of foe's Def or Res." if skill.type.include?('Weapon') && skill.restrictions.include?('Dragons Only') && skill.tags.include?('Frostbite')
      if skill.name=='Umbra Burst'
        text="#{text}\n\n<:Gold_Dragon:774013610908581948>**Dragons gain:** If foe's Range = 2, calculates damage using the lower of foe's Def or Res."
        text="#{text}\n<:Gold_Bow:774013609389981726>**Bow is Effective against:** <:Icon_Move_Flier:443331186698354698>"
        text="#{text}\n<:Gold_Dagger:774013610862968833>**Dagger Debuff:**  \u200B  \u200B  \u200B  *Effect:* Def/Res-7  \u200B  \u200B  \u200B  *Affects:* Target and foes within 2 spaces of target"
        text="#{text}\n<:Gold_Staff:774013610988797953>**Staves':** damage is calculated like other weapons."
      end
      text="#{text}\n**Debuff:** *Effect:* #{skill.dagger_debuff[0]}   *Target:* #{skill.dagger_debuff[1]}" unless skill.dagger_debuff.nil? || skill.dagger_debuff.length<=0
      text="#{text}\n**Buff:** *Effect:* #{skill.dagger_buff[0]}   *Target:* #{skill.dagger_buff[1]}" unless skill.dagger_buff.nil? || skill.dagger_buff.length<=0
      if skill.type.include?('Weapon') && safe_to_spam?(event)
        mdfr=''
        mdfr=' (humanoid)' if skill.restrictions.include?('Beasts Only')
        mdfr=' (displayed)' if skill.tags.include?('Chainy')
        text="#{text}\n**Stats affected#{mdfr}:** #{skill.disp_weapon_stats}"
        text="#{text}\n**Stats affected (transformed):** #{skill.disp_weapon_stats(false,true)}" if skill.restrictions.include?('Beasts Only')
        text="#{text}\n**Stats affected (in combat):** #{'+' if skill.disp_weapon_stats(true)[0]>0}#{skill.disp_weapon_stats(true)[0]} HP, other stats have complex interactions" if skill.tags.include?('Chainy')
      elsif skill.type.include?('Assist') && !skill.heal.nil?
        text="#{text}\n**Heals:** #{skill.heal}"
      elsif skill.type.include?('Special')
        text="#{text}\n**Range:**\n```#{skill.range}```" unless skill.range.nil? || skill.range=='-'
      end
      unless skill.name[0,6]=='Umbra ' || has_any?(skill.type,['Duo','Harmonic'])
        text="#{text}\n\n**SP Cost:** #{skill.disp_sp_cost} SP#{" (#{skill.disp_sp_cost(true)} SP when inherited)" if skill.exclusivity.nil? || skill.exclusivity.length<=0}"
        text="#{text}\n**Total SP Cost:** #{skill.disp_sp_cost(false,true)} SP#{" (#{skill.disp_sp_cost(true,true)} SP when inherited)" if skill.exclusivity.nil? || skill.exclusivity.length<=0}" if skill.level=='example'
        text="#{text}\n**Cumulitive SP Cost:** #{skill.cumulitive_sp_cost} SP#{" (#{skill.cumulitive_sp_cost(true)} SP when inherited)" if skill.exclusivity.nil? || skill.exclusivity.length<=0}" unless skill.prerequisite.nil? || skill.prerequisite.length<=0 || !safe_to_spam?(event)
        text="#{text}\n**Seal:** #{skill.seal_colors(bot)}" if !skill.seal_colors(bot).nil? && skill.seal_colors(bot).length>0 && has_any?(skill.type,['Seal','Passive(S)'])
        text="#{text}\n**Seal Total:** #{skill.seal_colors(bot,true)}" if !skill.seal_colors(bot,true).nil? && skill.seal_colors(bot,true).length>0 && has_any?(skill.type,['Seal','Passive(S)']) && skill.level=='example'
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
        y.push('Mathoo [Rokkr]') if skill.name=='Brobdingo'
        text2.push("<:Prf_Sparkle:490307608973148180>**Prf to:** #{y.join(', ')}")
      elsif skill.name=='Brobdingo'
        text2.push("<:Prf_Sparkle:490307608973148180>**Prf to:** Mathoo [Rokkr]")
      elsif skill.restrictions != ['Everyone'] && !skill.type.include?('Weapon')
        text2.push("**Restrictions on inheritance:** #{skill.restrictions.join(', ').gsub('Excludes Tome Users, Excludes Staff Users, Excludes Dragons','Physical Weapon Users Only')}")
      end
      text2.push("**Promotes from:** #{list_lift(skill.prerequisite.map{|q| "*#{q}*"},'or')}") unless skill.prerequisite.nil? || skill.prerequisite.length<=0
      text2.push("**Side promotion#{'s' unless skill.side_steps(event,1).length==0}:** #{skill.side_steps(event)}") unless skill.side_steps(event).nil? || skill.side_steps(event).length<=0
      unless skill.next_steps(event).nil? || skill.next_steps(event).length<=0
        if skill.type.include?('Weapon') && skill.next_steps(event,1).length>8 && skill.next_steps(event,1).reject{|q| q.exclusivity.nil? || q.exclusivity.length<=0}.length>1 && skill.next_steps(event,1).reject{|q| !q.exclusivity.nil? && q.exclusivity.length<=0}.length>1 && !(event.message.text.downcase.split(' ').include?('expanded') && safe_to_spam?(event))
          y=skill.next_steps(event,1)
          z=y.reject{|q| q.exclusivity.nil? || q.exclusivity.length<=0}
          y=y.reject{|q| !q.exclusivity.nil? && q.exclusivity.length>0}
          if skill.fake.nil?
            y=y.map{|q| q.postName}
          else
            y=y.map{|q| q.fullName('')}
          end
          y=y.map{|q| "*#{q}*"}
          y.push("or any of #{z.length} prfs")
          ftr='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.'
          text2.push("**Promotes into:** #{y.join(', ')}")
        else
          text2.push("**Promotes into:** #{skill.next_steps(event)}")
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
        text2.push("**Evolves into:** #{list_lift(y,'and')}") if y.length>0
      end
      text="#{text}#{"\n" unless !has_any?(skill.tags,['Duo','Harmonic']) && text2.length==1}\n#{text2.join("\n")}" if text2.length>0
      unless skill.subUnits(event).nil?
        if safe_to_spam?(event)
          text2=[]
          lvv=skill.tier-skill.lineCount
          for i in 0...skill.tier
            text2.push("*To Level #{i+1-lvv}:* #{skill.subUnits(event,i+1).join(', ')}") unless skill.subUnits(event,i+1).nil?
          end
          text="#{text}\n\n**Heroes who can learn part of this line without inheritance:**\n#{text2.join("\n")}" unless text2.length<=0
        elsif skill.tier>=4
          text="#{text}\n\n**Heroes who can learn the second-to-last part of this line without inheritance:**\n#{skill.subUnits(event,skill.tier-1).join(', ')}" unless skill.subUnits(event,skill.tier-1).nil?
        end
      end
      if has_any?(['Duo','Harmonic'],skill.type) || colors
      elsif skill.summon.reject{|q| q.length<=0}.length>0
        text2="**Heroes who know this skill by default:**"
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
            if skill.type.include?('Weapon') && y.length>8 && !(event.message.text.downcase.split(' ').include?('expanded') && safe_to_spam?(event))
              z=y.reject{|q| q.prf(true).length<1}
              y=y.reject{|q| q.prf(true).length>0} unless z.length<2
              if skill.fake.nil?
                y=y.map{|q| q.postName}
              else
                y=y.map{|q| q.fullName('')}
              end
              y.push("and #{z.length} units who end up having Prf weapons") unless z.length<2
              ftr='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.' unless z.length<2
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
      elsif colors
        x=skill.learn_by_color(event)
        if x.length<=0
        elsif x.length==1 && skill.prevos.nil?
          endtext="**#{x[0][0]} who learn this skill**"
          flds=triple_finish(x[0][1])
        else
          x=skill.learn_by_color(event,false)
          text="#{text}\n\n**Heroes who can learn this skill without inheritance:**\n#{x}"
        end
      elsif skill.learn.reject{|q| q.length<=0}.length==1 && skill.summon.flatten.length<=0 && skill.prevos.nil?
        x=skill.learn.find_index{|q| q.length>0}
        y=skill.learn[x]
        y2=skill.learn[x].reject{|q| q[0,4]!='All '}
        if ['Assault','Heal','Imbue'].include?(skill.name) && y2.length>0
          u=$units.reject{|q| q.weapon[1]!='Healer' || q.weapon[2].nil? || q.weapon[2][0,8]!='Ignore: ' || !q.weapon[2].include?(skill.type[0][0,2]) || !q.isPostable?(event)}
          y2[0]="**#{y2[0]}** (except #{list_lift(u.sort{|a,b| a.name<=>b.name}.map{|q| q.fullName('')},'and')})" if u.length>0
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
          text="#{text}\n\n**Heroes who learn at #{x+1}#{Rarity_stars[0][x]}**\n#{y.join(',  ')}"
        else
          endtext="**Heroes who learn at #{x+1}#{Rarity_stars[0][x]}**"
          flds=triple_finish(y)
        end
      elsif skill.learn.flatten.reject{|q| skill.summon.flatten.include?(q)}.length<=0 && !safe_to_spam?(event)
      elsif skill.learn.reject{|q| q.length<=0}.length>0
        text="#{text}\n\n**Heroes who can learn this skill without inheritance:**"
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
              y.push("and #{z.length} units who end up having Prf weapons") unless z.length<2
              ftr='If you would like to include the Prfs and units who have them, include the word "expanded" when retrying this command.' unless z.length<2
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
          str2="**It #{'also ' if skill.learn.flatten.length>0}evolves from #{sk2.name}**"
          unless sk2.learn.flatten.length<=0
            str2="**It #{'also ' if skill.learn.flatten.length>0}evolves from #{sk2.name}, which is obtained from the following heroes:**"
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
          str3='**Evolution cost:** 300 SP (450 if inherited), 200<:Arena_Medal:453618312446738472> 20<:Refining_Stone:453618312165720086>'
          str3='**Evolution cost:** 300 SP (450 if inherited), 100<:Arena_Medal:453618312446738472> 10<:Refining_Stone:453618312165720086>' if skill.name=='Candlelight+'
          str3='**Evolution cost:** 400 SP, 375<:Arena_Medal:453618312446738472> 150<:Divine_Dew:453618312434417691>' unless skill.exclusivity.nil? || skill.exclusivity.length<=0
          str3='**Evolution cost:** 1 story-gift Gunnthra<:Wind_Tome:499760605713137664><:Icon_Move_Cavalry:443331186530451466><:Legendary_Effect_Wind:443331186467536896><:Ally_Boost_Resistance:443331185783865355>' if skill.name=='Chill Breidablik'
          str3='**Evolution cost:** 1 Outrealm Askr' if skill.name=='Dual Breidablik'
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
            text2.push("**Level #{skz[i].level}#{xtratext} gained via weapon refinement on:** #{y.join(', ')}") if y.length>0
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
          text="#{text}\n\n**Gained via weapon refinement on:** #{y.join(', ')}" if y.length>0
        end
      end
      if $statskills.map{|q| q[0]}.include?(skill.fullName(nil,true)) && safe_to_spam?(event)
        x=$statskills.find_index{|q| q[0]==skill.fullName(nil,true)}
        unless x.nil?
          x=$statskills[x]
          x[3]=x[3].split(' ')
          x[3]=x[3][0,x[3].length-1].join(' ')
          if ['Enemy Phase','Player Phase'].include?(x[3])
            text="#{text}\n\n**This skill can be applied to units in the `phasestudy` command.**\nInclude the word \"#{x[0].gsub('/','').gsub(' ','').gsub('.','')}\" in your message\n*Skill type:* #{x[3]}"
          elsif 'In-Combat Buffs'==x[3]
            text="#{text}\n\n**This skill can be applied to units in the `phasestudy` command.**\nInclude the word \"#{x[0].gsub('/','').gsub(' ','').gsub('.','')}\" in your message\n*Skill type:* In-Combat Buff"
          else
            text="#{text}\n\n**This skill can be applied to units in the `stats` command and any derivatives.**\nInclude the word \"#{x[0].gsub('/','').gsub(' ','').gsub('.','')}\" in your message\n*Skill type:* #{x[3]}"
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
          x[4]="#{x[4][0,5].join('/')}#{"\nBin adjusted to ##{x[4][5]/5} (BST range #{x[4][5]}-#{x[4][5]+4}) minimum" if x[4].length>5}"
          if x[4]=='0/0/0/0/0'
            text="#{text}\n~~*Stat alterations*~~ *Complex interactions with other skills*"
          else
            text="#{text}\n*Stat alterations:* #{x[4]}"
          end
        end
      end
    end
    text="#{text}\n\n#{endtext}" if endtext.length>0
    ftr="You may be looking for the reload command." if skill.name[0,7]=='Restore' && !event.message.text.downcase.include?('skill') && (event.user.id==167657750971547648 || event.channel.id==386658080257212417)
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
    create_embed(event,'',['',"The following skills are triggered when their holder uses#{' or is targeted by' unless skill.tags.include?('Music')} #{skill.name}:","The following skills, when used on or by the unit holding #{skill.name}, will trigger it:"][w2],skill.disp_color(10+clr),nil,nil,triple_finish(w))
    clr+=1
  elsif event.message.text.downcase.split(' ').include?('refined') && skill.refine.nil? && skill.type.include?('Weapon')
    event.respond "#{skill.name} does not have any refinements."
    return nil
  elsif !skill.refine.nil? && !(blevel>0 && !event.message.text.downcase.split(' ').include?('refined'))
    r=skill.refine
    text=''
    for i in 0...r.overrides.length
      if r.overrides[i][6]=='Effect'
        if skill.name=='Falchion'
          s1=$skills[$skills.find_index{|q| q.name=='Falchion (Mystery)'}]
          s2=$skills[$skills.find_index{|q| q.name=='Falchion (Awakening)'}]
          s3=$skills[$skills.find_index{|q| q.name=='Falchion (Valentia)'}]
          text="#{r.emote(r.overrides[i][6])} **#{s1.name} (+) Effect Mode**"
          text="#{text} - #{s1.refinement_name.name}" unless s1.refinement_name.nil?
          if safe_to_spam?(event)
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Effective against:* #{s1.eff_against('Effect',true,event)}" unless s1.eff_against('Effect',true,event).length<=0
            text="#{text}\n#{s1.refine.inner}" unless s1.refine.inner.nil?
            text="#{text}\n#{s1.refine.outer}"
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s2.name} (+) Effect Mode**"
            text="#{text} - #{s2.refinement_name.name}" unless s2.refinement_name.nil?
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Effective against:* #{s2.eff_against('Effect',true,event)}" unless s2.eff_against('Effect',true,event).length<=0
            text="#{text}\n#{s2.refine.inner}" unless s2.refine.inner.nil?
            text="#{text}\n#{s2.refine.outer}"
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s3.name} (+) Effect Mode**"
            text="#{text} - #{s3.refinement_name.name}" unless s3.refinement_name.nil?
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Effective against:* #{s3.eff_against('Effect',true,event)}" unless s3.eff_against('Effect',true,event).length<=0
            text="#{text}\n#{s3.refine.inner}" unless s3.refine.inner.nil?
            text="#{text}\n#{s3.refine.outer}"
          else
            text="#{text}\n#{s1.refine.inner}" unless s1.refine.inner.nil?
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s2.name} (+) Effect Mode**"
            text="#{text} - #{s2.refinement_name.name}" unless s2.refinement_name.nil?
            text="#{text}\n#{s2.refine.inner}" unless s2.refine.inner.nil?
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s3.name} (+) Effect Mode**"
            text="#{text} - #{s3.refinement_name.name}" unless s3.refinement_name.nil?
            text="#{text}\n#{s3.refine.inner}" unless s3.refine.inner.nil?
            text="#{text}\n\n<:Refine_Unknown:455609031701299220>**All Effect Refines**"
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Effective against:* #{s2.eff_against('Effect',false,event)}" unless s2.eff_against('Effect',false,event).length<=0
            text="#{text}\n#{s2.refine.outer}"
          end
        elsif skill.name=='Missiletainn'
          s1=$skills[$skills.find_index{|q| q.name=='Missiletainn (Dark)'}]
          s2=$skills[$skills.find_index{|q| q.name=='Missiletainn (Dusk)'}]
          text="#{r.emote(r.overrides[i][6])} **#{s1.name} (+) Effect Mode**"
          text="#{text} - #{s1.refinement_name.name}" unless s1.refinement_name.nil?
          if safe_to_spam?(event)
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Effective against:* #{s1.eff_against('Effect',false,event)}" unless s1.eff_against('Effect',false,event).length<=0
            text="#{text}\n#{s1.refine.inner}" unless s1.refine.inner.nil?
            text="#{text}\n#{s1.refine.outer}"
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s2.name} (+) Effect Mode**"
            text="#{text} - #{s2.refinement_name.name}" unless s2.refinement_name.nil?
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Effective against:* #{s2.eff_against('Effect',false,event)}" unless s2.eff_against('Effect',false,event).length<=0
            text="#{text}\n#{s2.refine.inner}" unless s2.refine.inner.nil?
            text="#{text}\n#{s2.refine.outer}"
          else
            text="#{text}\n#{s1.refine.inner}" unless s1.refine.inner.nil?
            text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{s2.name} (+) Effect Mode**"
            text="#{text} - #{s2.refinement_name.name}" unless s2.refinement_name.nil?
            text="#{text}\n#{s2.refine.inner}" unless s2.refine.inner.nil?
            text="#{text}\n\n<:Refine_Unknown:455609031701299220>**All Effect Refines**"
            text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
            text="#{text}\n*Effective against:* #{s2.eff_against('Effect',false,event)}" unless s2.eff_against('Effect',false,event).length<=0
            text="#{text}\n#{s2.refine.outer}"
          end
        elsif !skill.exclusivity.nil? && skill.exclusivity.include?('Nebby')
          x=r.inner.split('  ')
          text="#{r.emote(r.overrides[i][6])} **#{skill.name} (+) Full Metal Mode**"
          text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
          text="#{text}\n*Effective against:* #{skill.eff_against('Effect',false,event)}" unless skill.eff_against('Effect',false,event).length<=0
          text="#{text}\n#{x[0]}"
          text="#{text}\n\n#{r.emote(r.overrides[i][6])} **#{skill.name} (+) Shadow Mode**"
          text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
          text="#{text}\n*Effective against:* #{skill.eff_against('Effect',false,event)}" unless skill.eff_against('Effect',false,event).length<=0
          text="#{text}\n#{x[1]}"
        else
          text="#{r.emote(r.overrides[i][6])} **#{skill.name} (+) #{r.overrides[i][6]} Mode**"
          text="#{text} - #{skill.refinement_name.name}" unless skill.refinement_name.nil?
          text="#{text}\n#{r.dispStats(r.overrides[i][6],true)}"
          text="#{text}\n*Effective against:* #{skill.eff_against('Effect',false,event)}" unless skill.eff_against('Effect',false,event).length<=0
          text="#{text}\n#{r.inner}" unless r.inner.nil?
          if r.outer.nil?
            text="#{text}\n#{skill.description}" unless skill.description.nil? || skill.description.length<=0
            text="#{text}\n*Debuff:* #{skill.dagger_debuff.join('   *Target:* ')}" unless skill.dagger_debuff.nil?
            text="#{text}\n*Buff:* #{skill.dagger_buff.join('   *Target:* ')}" unless skill.dagger_buff.nil?
          elsif r.outer.include?(' *** ')
            x=r.outer.split(' *** ')
            text="#{text}\n#{x[0]}" unless x[0].nil? || x[0].length<=0 || x[0]=='-'
            x=x.map{|q| q.split(', ')}
            text="#{text}\n*Debuff:* #{x[1].join('   *Target:* ')}" unless x[1].nil?
            text="#{text}\n*Buff:* #{x[2].join('   *Target:* ')}" unless x[2].nil?
          else
            text="#{text}\n#{r.outer}"
            text="#{text}\n*Debuff:* #{skill.dagger_debuff.join('   *Target:* ')}" unless skill.dagger_debuff.nil?
            text="#{text}\n*Buff:* #{skill.dagger_buff.join('   *Target:* ')}" unless skill.dagger_buff.nil?
          end
          text="#{text}\nIf foe's Range = 2, damage calculated using the lower of foe's Def or Res." if (has_any?(skill.tags,['Frostbite','(E)Frostbite','(R)Frostbite']) && !skill.description.include?("amage calculated using the lower of foe's Def or Res")) || (skill.restrictions.include?('Dragons Only') && !skill.tags.include?('UnFrostbite'))
        end
        text="#{text}\n" if safe_to_spam?(event) || r.overrides[1,r.overrides.length-1].map{|q| q[7]}.compact.length>0
      elsif safe_to_spam?(event) || !r.overrides[i][7].nil?
        text="#{text}\n#{r.emote(r.overrides[i][6])} **#{r.overrides[i][6]} Mode**  \u200B  \u200B  \u200B  #{r.dispStats(r.overrides[i][6],true)}"
      end
    end
    unless skill.restrictions.include?('Staff Users Only') && skill.tome_tree.nil?
      every=[]
      every.push("*Effective against:* #{skill.eff_against('Refine',true,event)}") unless skill.eff_against('Refine',true,event).length<=0
      if r.outer.nil?
        every.push(skill.description) unless skill.description.nil? || skill.description.length<=0
        every.push("*Debuff:* #{skill.dagger_debuff.join('   *Target:* ')}") unless skill.dagger_debuff.nil?
        every.push("*Buff:* #{skill.dagger_buff.join('   *Target:* ')}") unless skill.dagger_buff.nil?
      elsif r.outer.include?(' *** ')
        x=r.outer.split(' *** ')
        every.push(x[0]) unless x[0].nil? || x[0].length<=0 || x[0]=='-'
        x=x.map{|q| q.split(', ')}
        x=x.map{|q| [q[0].split(' (')[0],q[1]]} if skill.name=='Peshkatz'
        every.push("*Debuff:* #{x[1].join('   *Target:* ')}") unless x[1].nil?
        every.push("*Buff:* #{x[2].join('   *Target:* ')}") unless x[2].nil?
      else
        every.push(r.outer)
        every.push("*Debuff:* #{skill.dagger_debuff.join('   *Target:* ')}") unless skill.dagger_debuff.nil?
        every.push("*Buff:* #{skill.dagger_buff.join('   *Target:* ')}") unless skill.dagger_buff.nil?
      end
      every.push("If foe's Range = 2, damage calculated using the lower of foe's Def or Res.") if (has_any?(skill.tags,['Frostbite','(E)Frostbite','(R)Frostbite']) && !skill.description.include?("amage calculated using the lower of foe's Def or Res")) || (skill.restrictions.include?('Dragons Only') && !skill.tags.include?('UnFrostbite'))
      typ=' Stat'
      typ=' Default' if skill.restrictions.include?('Staff Users Only') && skill.tome_tree=='WrazzleDazzle'
      typ='' if r.overrides[0][6]!='Effect'
      text="#{text}\n\n<:Refine_Unknown:455609031701299220>**All#{typ} Refinements**\n#{every.join("\n")}" if safe_to_spam?(event) && every.length>0
    end
    ftr='All refinements cost: 350 SP (525 if inherited), 500<:Arena_Medal:453618312446738472> 50<:Refining_Stone:453618312165720086>'
    ftr='All refinements cost: 400 SP, 500<:Arena_Medal:453618312446738472> 200<:Divine_Dew:453618312434417691>' unless skill.exclusivity.nil?
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
          create_embed(event,'__**Refinery Options**__',str,skill.disp_color(10+clr),nil,r.thumbnail) if clr==1
          create_embed(event,'',str,skill.disp_color(10+clr)) unless clr==1
          str=text[i]
          clr+=1
        else
          str="#{str}\n\n#{text[i]}"
        end
      end
      create_embed(event,'',str,skill.disp_color(10+clr))
    else
      create_embed(event,'__**Refinery Options**__',text,skill.disp_color(10+clr),nil,r.thumbnail)
    end
    clr+=1
  end
  if has_any?(event.message.text.downcase.split(' '),['tags','tag'])
    str=''
    flds=nil
    k=skill.tags.map{|q| q}
    if skill.type.include?('Weapon')
      str="#{str}\n**Slot:**  <:Skill_Weapon:444078171114045450> Weapon"
      k=k.reject{|q| q=='Weapon'}
      clrs=k.reject{|q| !['Red','Blue','Green','Colorless','Purple'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "#{clrs[i]}_Unknown"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Color#{'s' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['Red','Blue','Green','Colorless','Purple'].include?(q)}
      clrs=k.reject{|q| !['Blade','Tome','Breath','Bow','Dagger','Staff','Beast','Gun'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443172595580534784).emoji.values.reject{|q| q.name != "Gold_#{clrs[i]}"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Type#{'s' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['Blade','Tome','Breath','Bow','Dagger','Staff','Beast','Gun'].include?(q)}
      if k.reject{|q| q.include?('(E)') || q.include?('(R)') || q.include?('(T)') || q.include?('(TE)') || q.include?('(TR)') || q.include?('(ET)') || q.include?('(RT)') || q.include?('(T)(E)') || q.include?('(T)(R)') || q.include?('(E)(T)') || q.include?('(R)(T)')}.length<k.length
        flds=[['Base weapon',[]],['All refinements',[]],['Effect Mode refinement',[]],['Transformed base',[]],['Refined Transformation',[]],['Effect Transformation',[]]]
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
      str="#{str}\n**Slot:** <:Skill_Assist:444078171025965066> Assist"
      k=k.reject{|q| q=='Assist'}
    elsif skill.type.include?('Special')
      str="#{str}\n**Slot:** <:Skill_Special:444078170665254929> Special"
      k=k.reject{|q| q=='Special'}
    elsif skill.isPassive?
      str="#{str}\n**Type:** <:Passive:544139850677485579> Passive"
      k=k.reject{|q| q=='Passive'}
      clrs=k.reject{|q| !['A','B','C','Seal','W'].include?(q)}
      for i in 0...clrs.length
        moji=bot.server(443181099494146068).emoji.values.reject{|q| q.name != "Passive_#{clrs[i].gsub('Seal','S')}"}
        clrs[i]="#{"#{moji[0].mention} " if moji.length>0}#{clrs[i]}"
      end
      str="#{str}\n**Slot#{'s' if clrs.length>1}:** #{clrs.join(', ')}" if clrs.length>0
      k=k.reject{|q| ['A','B','C','Seal','W'].include?(q)}
    elsif skill.type.include?('Duo')
      str="#{str}\n**Slot:** <:Skill_Assist:444078171025965066> Assist"
      k=k.reject{|q| q=='Duo'}
    elsif skill.type.include?('Harmonic')
      str="#{str}\n**Slot:** <:Skill_Assist:444078171025965066> Assist"
      k=k.reject{|q| q=='Harmonic'}
    end
    str="#{str}\n\nSearchable tags"
    flds=triple_finish(k) if flds.nil?
    create_embed(event,'',str,skill.disp_color(clr),nil,nil,flds)
  end
end

def disp_struct(bot,event,xname,ignore=false)
  data_load(['structure','bonus'])
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ').reject{ |q| q.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=s.split(' ')
  args=xname.split(' ') unless xname.nil?
  if xname.nil?
    if args.nil? || args.length<1
      event.respond nomf()
      return nil
    end
  end
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  xname=args.join(' ') if xname.nil?
  k=find_data_ex(:find_structure,event,args,nil,bot)
  if k.nil? || k.length<=0
    event.respond nomf()
    return nil
  end
  hdr=k[0].class_header(bot)
  xcolor=k[0].disp_color
  stone='<:Aether_Stone:510776805746278421>'
  if k.map{|q| q.type}.uniq.length>0 && k.map{|q| q.type}.flatten.include?('Offensive') && k.map{|q| q.type}.flatten.include?('Defensive')
    xcolor=0x8CAA7B
    hdr="<:Battle_Structure:565064414454349843>**Type:** Offensive/Defensive#{"\n<:Current_Aether_Bonus:510022809741950986>#{k[0].isBonus?} Aether Bonus Structure" if k[0].isBonus?.length>0}"
    hdr="<:Battle_Structure:565064414454349843>**Tipo:** Ataque/Defensa#{"\n<:Current_Aether_Bonus:510022809741950986>#{k[0].isBonus?} Bonificación actual en Asaltos Etéreos" if k[0].isBonus?.length>0}" if Shardizard==$spanishShard
  elsif k[0].type[0]=='Mjolnir'
    stone='<:Midgard_Gem:675118366352211988>'
  end
  text=''
  x2='Effect'
  x2='Efecto' if Shardizard==$spanishShard
  x2='Description' if ['Resort','Ornament'].include?(k[0].type[0])
  x2='Descripción' if ['Resort','Ornament'].include?(k[0].type[0]) && Shardizard==$spanishShard
  text="**#{x2}:** #{k[0].description}"
  unless k[0].charge.nil? || k[0].charge<=0
    if Shardizard==$spanishShard
      text="#{text}\n**Rouds para recargar:** #{k[0].charge}"
    else
      text="#{text}\n**Turns to recharge:** #{k[0].charge}"
    end
  end
  desc=['Level','Cost','Requires reaching AR Tier','nothing','Cumulative Cost','Offensive','Defensive','Additional Note']
  desc=['Nivel','Precio','Requiere alcanzar AR Grada','nada','Precio Acumulativo','Ataque','Defensa','La Nota'] if Shardizard==$spanishShard
  if k.length>1
    x=' '
    x="\n" if k.map{|q| q.description}.uniq.length>1 || k.map{|q| q.destructable}.uniq.length>1 || k.map{|q| q.note}.uniq.length>1 
    x=' ' if k.map{|q| q.level}.include?('example')
    for i in 0...k.length
      text="#{text}\n" if (k.map{|q| q.description}.uniq.length>1 || k.map{|q| q.destructable}.uniq.length>1 || k.map{|q| q.note}.uniq.length>1 || i.zero?) && !k.map{|q| q.level}.include?('example')
      unless k[i].level=='example' || k.map{|q| q.level}.uniq.length<=1 || !safe_to_spam?(event)
        text="#{text}\n" if i>0 && k[i-1].level=='example'
        ktp=k[i].type.map{|q| q}
        ktp=k[i].spanish_type.map{|q| q} if Shardizard==$spanishShard
        text="#{text}\n**#{desc[0]} #{k[i].level}#{" [#{ktp.join('/')}]" unless k[i].type==k[0].type}:**"
        text="#{text}#{x}*#{desc[1]}:* "
        text="#{text}#{k[i].costs[0]}<:RRAffinity:565064751780986890>" if k[i].costs[0]>0
        text="#{text}#{k[i].costs[1]}#{stone}" if k[i].costs[1]>0
        text="#{text}#{k[i].costs[2]}<:Heavenly_Dew:510776806396395530>" if k[i].costs[2]>0
        text="#{text}#{k[i].costs[3]}<:Aether_Stone_SP:513982883560423425>" if k[i].costs[3]>0
        text="#{text} (#{desc[2]} #{k[i].ar_tier})" if !k[i].ar_tier.nil? && k[i].ar_tier>0
        text="#{text}~~#{desc[3]}~~" if (k[i].ar_tier.nil? || k[i].ar_tier<=0) && k[i].costs.max<=0
      end
      text="#{text}\n*#{x2}:* #{k[i].description}" unless k.map{|q| q.description}.uniq.length<2 || k.map{|q| q.level}.include?('example')
      unless k.map{|q| q.destructable}.uniq.length<2
        if ['yes','no'].include?(k[i].destructable.downcase)
          text="#{text}\n*#{"\u00BF" if Shardizard==$spanishShard}Destructible?:* #{k[i].destructable}"
        elsif k[0].type.include?('Trap') && Shardizard==$spanishShard
          text="#{text}\n*Las trampas se activan al pararse sobre ellas.*"
        elsif k[0].type.include?('Trap')
          text="#{text}\n*Traps are triggered by standing on them*"
        elsif k[i].destructable != '-'
          text="#{text}\n*#{"\u00BF" if Shardizard==$spanishShard}Destructible?:* #{k[i].destructable}"
        end
      end
      text="#{text}\n*#{desc[7]}:* #{k[i].note}" unless k.map{|q| q.note}.uniq.length<2 || k[i].note.nil? || k[i].note.length<=0
    end
    if k.map{|q| q.level}.uniq.length<2
      text="#{text}\n**#{desc[1]}:**  "
    else
      text="#{text}\n\n**#{desc[4]}:**  "
    end
    if k.map{|q| q.type}.uniq.length>1
      text="#{text}\n<:Offensive_Structure:510774545997758464>*#{desc[5]}:*  "
      m=k.reject{|q| !q.type.include?('Offensive') || q.level=='example'}
      text="#{text}#{m.map{|q| q.costs[0]}.inject(0){|sum,x| sum + x }}<:RRAffinity:565064751780986890>" if m.map{|q| q.costs[0]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[1]}.inject(0){|sum,x| sum + x }}#{stone}" if m.map{|q| q.costs[1]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[2]}.inject(0){|sum,x| sum + x }}<:Heavenly_Dew:510776806396395530>" if m.map{|q| q.costs[2]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[3]}.inject(0){|sum,x| sum + x }}<:Aether_Stone_SP:513982883560423425>" if m.map{|q| q.costs[3]}.inject(0){|sum,x| sum + x }>0
      text="#{text} (#{desc[2]} #{m.map{|q| q.ar_tier}.max})" if m.reject{|q| q.ar_tier.nil?}.length>0 && m.map{|q| q.ar_tier}.max>0
      text="#{text}\n<:Defensive_Structure:510774545108566016>*#{desc[6]}:*  "
      m=k.reject{|q| !q.type.include?('Defensive') || q.level=='example'}
      text="#{text}#{m.map{|q| q.costs[0]}.inject(0){|sum,x| sum + x }}<:RRAffinity:565064751780986890>" if m.map{|q| q.costs[0]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[1]}.inject(0){|sum,x| sum + x }}#{stone}" if m.map{|q| q.costs[1]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[2]}.inject(0){|sum,x| sum + x }}<:Heavenly_Dew:510776806396395530>" if m.map{|q| q.costs[2]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[3]}.inject(0){|sum,x| sum + x }}<:Aether_Stone_SP:513982883560423425>" if m.map{|q| q.costs[3]}.inject(0){|sum,x| sum + x }>0
      text="#{text} (#{desc[2]} #{m.map{|q| q.ar_tier}.max})" if m.reject{|q| q.ar_tier.nil?}.length>0 && m.map{|q| q.ar_tier}.max>0
    else
      m=k.reject{|q| q.level=='example'}
      text="#{text}#{m.map{|q| q.costs[0]}.inject(0){|sum,x| sum + x }}<:RRAffinity:565064751780986890>" if m.map{|q| q.costs[0]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[1]}.inject(0){|sum,x| sum + x }}#{stone}" if m.map{|q| q.costs[1]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[2]}.inject(0){|sum,x| sum + x }}<:Heavenly_Dew:510776806396395530>" if m.map{|q| q.costs[2]}.inject(0){|sum,x| sum + x }>0
      text="#{text}#{m.map{|q| q.costs[3]}.inject(0){|sum,x| sum + x }}<:Aether_Stone_SP:513982883560423425>" if m.map{|q| q.costs[3]}.inject(0){|sum,x| sum + x }>0
      text="#{text} (#{desc[2]} #{m.map{|q| q.ar_tier}.max})" if m.reject{|q| q.ar_tier.nil?}.length>0 && m.map{|q| q.ar_tier}.max>0
    end
  else
    text="#{text}\n\n**#{desc[1]}:** " if k[0].costs.max>0
    text="#{text}#{k[0].costs[0]}<:RRAffinity:565064751780986890>" if k[0].costs[0]>0
    text="#{text}#{k[0].costs[1]}#{stone}" if k[0].costs[1]>0
    text="#{text}#{k[0].costs[2]}<:Heavenly_Dew:510776806396395530>" if k[0].costs[2]>0
    text="#{text}#{k[0].costs[3]}<:Aether_Stone_SP:513982883560423425>" if k[0].costs[3]>0
    text="#{text}\n**#{desc[2].split(' ')[2,2].join(' ')}:** #{k[0].ar_tier}" if !k[0].ar_tier.nil? && k[0].ar_tier>0
  end
  text="#{text}\n"
  if k.map{|q| q.destructable}.uniq.length<2
    if ['yes','no'].include?(k[0].destructable.downcase)
      text="#{text}\n**#{"\u00BF" if Shardizard==$spanishShard}Destructible?:** #{k[0].destructable}"
    elsif k[0].type.include?('Trap') && Shardizard==$spanishShard
      text="#{text}\n**Las trampas se activan al pararse sobre ellas.**"
    elsif k[0].type.include?('Trap')
      text="#{text}\n**Traps are triggered by standing on them**"
    elsif k[0].destructable != '-'
      text="#{text}\n**#{"\u00BF" if Shardizard==$spanishShard}Destructible?:** #{k[0].destructable}"
    end
    text="#{text}\n"
  end
  text="#{text}\n**#{desc[7]}:** #{k[0].note}" unless k.map{|q| q.note}.uniq.length>1 || k[0].note.nil? || k[0].note.length<=0
  create_embed(event,["__#{k[0].fullName('**')}__",hdr],text,xcolor,nil,k[0].thumbnail(event,bot))
end

def disp_itemu(bot,event,xname,ignore=false)
  data_load(['item'])
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ').reject{ |q| q.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=s.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  xname=args.join(' ') if xname.nil?
  k=find_data_ex(:find_item_feh,event,args,nil,bot)
  if k.nil?
    event.respond nomf() unless ignore
    return nil
  end
  str="**Effect/Description:** #{k.description}"
  str="**Efecto/Descriptión:** #{k.description}" if Shardizard==$spanishShard
  if ['Implied','Assault'].include?(k.type)
    str="**Effect:** #{k.description}"
    str="**Efecto:** #{k.description}" if Shardizard==$spanishShard
  elsif ['Blessing','Growth'].include?(k.type)
    str="**Description:** #{k.description}"
    str="**Descriptión:** #{k.description}" if Shardizard==$spanishShard
  end
  str="#{str}\n\n**Additional Info:** #{k.note}" unless k.note.nil? || Shardizard==$spanishShard
  str="#{str}\n\n**La Nota:** #{k.note}" unless k.note.nil? || Shardizard !=$spanishShard
  create_embed(event,["__**#{k.name}**__#{k.emotes(bot) if Shardizard==4 && event.user.id==167657750971547648}",k.class_header(bot)],str,k.disp_color,nil,k.thumbnail(event,bot))
end

def disp_accessory(bot,event,xname,ignore=false)
  data_load(['accessory'])
  s=event.message.text
  s=remove_prefix(s,event)
  a=s.split(' ').reject{ |q| q.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  if all_commands().include?(a[0])
    a.shift
    s=a.join(' ')
  end
  args=s.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } # remove any mentions included in the inputs
  name=args.join(' ') if name.nil?
  k=find_data_ex(:find_accessory,event,args,nil,bot)
  if k.nil?
    event.respond nomf() unless ignore
    return nil
  end
  str="**Description:** #{k.description}"
  str="#{str}\n\n**To obtain:** #{k.obtain}" unless k.obtain.nil?
  str="#{str}\n\n**Additional Info:** #{k.note}" unless k.note.nil?
  if Shardizard==$spanishShard
    str="**Descriptión:** #{k.description}"
    str="#{str}\n\n**Obtención:** #{k.obtain}" unless k.obtain.nil?
    str="#{str}\n\n**La Nota:** #{k.note}" unless k.note.nil?
  end
  create_embed(event,["__**#{k.name}**__",k.class_header(bot)],str,k.disp_color,nil,k.thumbnail(event,bot))
end

bot.command(:stats, aliases: [:stat]) do |event, *args|
  return nil if overlap_prevent(event)
  skills=false
  data_load()
  if args.nil? || args.length<=0
    event.respond nomf()
    return nil
  elsif ['skill','skills','skil','skils'].include?(args[0].downcase) || (['habilidad','habilidades'].include?(args[0].downcase) && Shardizard==$spanishShard)
    skills=true
    args.shift
  elsif ['and','n','&'].include?(args[0].downcase) && ['skill','skills'].include?(args[1].downcase)
    args.shift
    args.shift
    skills=true
  elsif ['and','n','&','y'].include?(args[0].downcase) && ['skill','skills','habilidad','habilidades'].include?(args[1].downcase) && Shardizard==$spanishShard
    args.shift
    args.shift
    skills=true
  elsif ['rand','random'].include?(args[0].downcase) || (['aleatoria','aleatorio'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    pick_random_unit(event,args,bot)
    return nil
  elsif ['compare','comparison'].include?(args[0].downcase) || (['comparar','compara'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    comparison(bot,event,args)
    return nil
  elsif ['bst'].include?(args[0].downcase)
    args.shift
    combined_BST(bot,event,args)
    return nil
  elsif ['pairup','pair_up','pair','pocket'].include?(args[0].downcase) || (['agrupar','agrupa','par','bolsillo'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    pair_up(bot,event,args)
    return nil
  elsif ['eff_hp','effhp','bulk'].include?(args[0].downcase) || (['masa'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    effHP(bot,event,args)
    return nil
  elsif ['proc'].include?(args[0].downcase)
    args.shift
    proc_study(bot,event,args)
    return nil
  elsif ['heal'].include?(args[0].downcase) || (['curar','cura'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    heal_study(bot,event,args)
    return nil
  elsif ['study'].include?(args[0].downcase) || (Shardizard==$spanishShard && ['estudio','estudia','estudiar'].include?(args[0].downcase))
    args.shift
    if ['effhp','eff_hp','bulk'].include?(args[0].downcase) || (['masa'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=effHP(bot,event,args)
      return nil unless k.nil? || k<0
    elsif ['pair_up','pairup','pair','pocket'].include?(args[0].downcase) || (['agrupar','agrupa','par','bolsillo'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=effHP(bot,event,args)
      return nil unless k.nil? || k<0
    elsif ['heal'].include?(args[0].downcase) || (['curar','cura'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=heal_study(bot,event,args)
      return nil unless k.nil? || k<0
    elsif ['proc'].include?(args[0].downcase)
      args.shift
      k=proc_study(bot,event,args)
      return nil unless k.nil? || k<0
    elsif ['phase'].include?(args[0].downcase) || (['fase'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=phase_study(bot,event,args)
      return nil unless k.nil? || k<0
    end
    unit_study(bot,event,args)
    return nil
  elsif ['fgo'].include?(args[0].downcase) && !find_data_ex(:find_FGO_servant,event,args[1,args.length-1],nil,bot).nil?
    args.shift
    disp_stats_for_FGO(bot,event,args,find_data_ex(:find_FGO_servant,event,args,nil,bot))
    return nil
  end
  size='smol'
  size='medium' if ['big','tol','macro','large'].include?(args[0].downcase) || (['grande'].include?(args[0].downcase) && Shardizard==$spanishShard)
  size='giant' if ['huge','massive'].include?(args[0].downcase) || (['enorme'].include?(args[0].downcase) && Shardizard==$spanishShard)
  args.shift if ['big','tol','macro','large','huge','massive'].include?(args[0].downcase) || (['grande','enorme'].include?(args[0].downcase) && Shardizard==$spanishShard)
  skills=true if ['skill','skills','skil','skils'].include?(args[0].downcase) || (['habilidad','habilidades'].include?(args[0].downcase) && Shardizard==$spanishShard)
  args.shift if ['skill','skills','skil','skils'].include?(args[0].downcase) || (['habilidad','habilidades'].include?(args[0].downcase) && Shardizard==$spanishShard)
  args=sever(args.join(' ')).split(' ')
  x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
  x[1]=first_sub(args.join(' ').downcase,x[1].downcase,'') unless x.nil?
  if x.nil?
    event.respond nomf()
  elsif x[0].is_a?(Array)
    disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],size,skills)
  else
    disp_unit_stats(bot,event,x[0].name,x[1],size,skills)
  end
  return nil
end

bot.command(:skills, aliases: [:skils,:fodder,:manual,:book,:combatmanual]) do |event, *args|
  return nil if overlap_prevent(event)
  s=event.message.text
  s=remove_prefix(s,event)
  data_load()
  if args.nil? || args.length<=0
    event.respond nomf()
    return nil
  end
  if s.downcase[0,6]=='skills'
    andlist=['and','n','&']
    andlist.push('y') if Shardizard==$spanishShard
    if ['stat','stats'].include?(args[0].downcase)
      args.shift
      x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
      if x.nil?
        event.respond nomf()
      elsif x[0].is_a?(Array)
        disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],'smol',true)
      else
        disp_unit_stats(bot,event,x[0].name,x[1],'smol',true)
      end
      return nil
    elsif ['find','search'].include?(args[0].downcase) || (['encontra','busca','encontrar','buscar'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      data_load()
      display_skills(bot,event,args)
      return nil
    elsif ['rand','random'].include?(args[0].downcase) || (['aleatoria','aleatorio'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      pick_random_skill(event,args,bot)
      return nil
    elsif ['sort','list'].include?(args[0].downcase) || (['clasificar','clasifica','lista','listar'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      data_load()
      sort_skills(bot,event,args)
      return nil
    elsif ['compare','comparison'].include?(args[0].downcase) || (['comparar','compara'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      skill_comparison(bot,event,args)
      return nil
    elsif andlist.include?(args[0].downcase) && ['stat','stat'].include?(args[1].downcase)
      args.shift
      args.shift
      x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
      if x.nil?
        event.respond nomf()
      elsif x[0].is_a?(Array)
        disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],'smol',true)
      else
        disp_unit_stats(bot,event,x[0].name,x[1],'smol',true)
      end
      return nil
    end
  end
  args=sever(args.join(' ')).split(' ')
  x=find_data_ex(:find_unit,event,args,nil,bot)
  if x.nil? && Shardizard==$spanishShard
    event.respond "No hay coincidencia.  #{"Si está buscando datos sobre las habilidades que aprende un personaje en particular, intente ```#{first_sub(event.message.text,'habilidades','habilidad')}```, sin la s." if s.downcase[0,11]=='habilidades'}"
  elsif x.nil?
    event.respond "No matches found.  #{"If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s." if s.downcase[0,6]=='skills'}"
  elsif x.is_a?(Array)
    disp_unit_skills(bot,event,x.map{|q| q.name})
  else
    disp_unit_skills(bot,event,x.name)
  end
  return nil
end

bot.command(:skill, aliases: [:skil]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  clr=false
  andlist=['and','n','&']
  andlist.push('y') if Shardizard==$spanishShard
  if args.nil? || args.length<=0
    event.respond nomf()
    return nil
  elsif ['find','search'].include?(args[0].downcase) || (['encontra','busca','encontrar','buscar'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    display_skills(bot,event,args)
    return nil
  elsif ['sort','list'].include?(args[0].downcase) || (['clasificar','clasifica','lista','listar'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    sort_skills(bot,event,args)
    return nil
  elsif ['rand','random'].include?(args[0].downcase) || (['aleatoria','aleatorio'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    pick_random_skill(event,args,bot)
    return nil
  elsif ['compare','comparison'].include?(args[0].downcase) || (['comparar','compara'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    skill_comparison(bot,event,args)
    return nil
  elsif ['stat','stats'].include?(args[0].downcase)
    args.shift
    x=find_data_ex(:find_unit,event,args,nil,bot)
    if x.nil?
      event.respond nomf()
    elsif x.is_a?(Array)
      disp_unit_stats(bot,event,x.map{|q| q.name},nil,'smol',true)
    else
      disp_unit_stats(bot,event,x.name,nil,'smol',true)
    end
    return nil
  elsif andlist.include?(args[0].downcase) && ['stat','stat'].include?(args[1].downcase)
    args.shift
    args.shift
    x=find_data_ex(:find_unit,event,args,nil,bot)
    if x.nil?
      event.respond nomf()
    elsif x.is_a?(Array)
      disp_unit_stats(bot,event,x.map{|q| q.name},nil,'smol',true)
    else
      disp_unit_stats(bot,event,x.name,nil,'smol',true)
    end
    return nil
  elsif ['color','colors','colour','colours'].include?(args[0].downcase)
    clr=true
  end
  disp_skill_data(bot,event,nil,clr,true)
  return nil
end

bot.command(:colors, aliases: [:color,:colours,:colour,:colores]) do |event, *args|
  return nil if overlap_prevent(event)
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  data_load()
  x=find_data_ex(:find_skill,event,args,nil,bot)
  if x.nil?
    event.respond nomf()
  else
    disp_skill_data(bot,event,x.name,true)
  end
  return nil
end

bot.command(:tinystats, aliases: [:smallstats,:smolstats,:microstats,:squashedstats,:sstats,:statstiny,:statssmall,:statssmol,:statsmicro,:statssquashed,:statss,:stattiny,:statsmall,:statsmol,:statmicro,:statsquashed,:sstat,:tinystat,:smallstat,:smolstat,:microstat,:squashedstat,:tiny,:small,:micro,:smol,:squashed,:littlestats,:littlestat,:statslittle,:statlittle,:little]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  if args.nil? || args.length<=0
    smol_err(bot,event,false,true)
    return nil
  elsif ['rand','random'].include?(args[0].downcase)
    args.shift
    pick_random_unit(event,args,bot)
    return nil
  end
  args=sever(args.join(' ')).split(' ')
  x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
  x[1]=first_sub(args.join(' ').downcase,x[1].downcase,'') unless x.nil?
  if x.nil?
    smol_err(bot,event,false,true)
  elsif x[0].is_a?(Array)
    disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],'xsmol')
  else
    disp_unit_stats(bot,event,x[0].name,x[1],'xsmol')
  end
  return nil
end

bot.command(:big, aliases: [:tol,:macro,:large,:bigstats,:tolstats,:macrostats,:largestats,:bigstat,:tolstat,:macrostat,:largestat,:statsbig,:statstol,:statsmacro,:statslarge,:statbig,:stattol,:statmacro,:statlarge,:statol]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  if args.nil? || args.length<=0
    event.respond nomf()
    return nil
  elsif ['skill','skills','skil','skils'].include?(args[0].downcase) || (['habilidad','habilidades'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    skills=true
  elsif ['and','n','&'].include?(args[0].downcase) && ['skill','skills'].include?(args[1].downcase)
    args.shift
    args.shift
    skills=true
  elsif ['and','n','&','y'].include?(args[0].downcase) && ['skill','skills','habilidad','habilidades'].include?(args[1].downcase) && Shardizard==$spanishShard
    args.shift
    args.shift
    skills=true
  elsif ['rand','random'].include?(args[0].downcase) || (['aleatoria','aleatorio'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    pick_random_unit(event,args,bot)
    return nil
  end
  args=sever(args.join(' ')).split(' ')
  x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
  x[1]=first_sub(args.join(' ').downcase,x[1].downcase,'') unless x.nil?
  if x.nil?
    event.respond nomf()
  elsif x[0].is_a?(Array)
    disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],'medium',skills)
  else
    disp_unit_stats(bot,event,x[0].name,x[1],'medium',skills)
  end
  return nil
end

bot.command(:huge, aliases: [:massive,:giantstats,:hugestats,:massivestats,:giantstat,:hugestat,:massivestat,:statsgiant,:statshuge,:statsmassive,:statgiant,:stathuge,:statmassive]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  if args.nil? || args.length<=0
    event.respond nomf()
    return nil
  elsif ['rand','random'].include?(args[0].downcase) || (['aleatoria','aleatorio'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    pick_random_unit(event,args,bot)
    return nil
  end
  args=sever(args.join(' ')).split(' ')
  x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
  x[1]=first_sub(args.join(' ').downcase,x[1].downcase,'') unless x.nil?
  if x.nil?
    event.respond nomf()
  elsif x[0].is_a?(Array)
    disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],'giant',true)
  else
    disp_unit_stats(bot,event,x[0].name,x[1],'giant',true)
  end
  return nil
end

bot.command(:hero, aliases: [:unit,:data,:statsskills,:statskills,:stats_skills,:stat_skills,:statsandskills,:statandskills,:stats_and_skills,:stat_and_skills,:statsskill,:statskill,:stats_skill,:stat_skill,:statsandskill,:statandskill,:stats_and_skill,:stat_and_skill,:statsskils,:statskils,:stats_skils,:stat_skils,:statsandskils,:statandskils,:stats_and_skils,:stat_and_skils,:statsskil,:statskil,:stats_skil,:stat_skil,:statsandskil,:statandskil,:stats_and_skil,:stat_and_skil]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  if args.nil? || args.length<=0
    event.respond nomf()
    return nil
  elsif ['find','search'].include?(args[0].downcase) || (['encontra','busca','encontrar','buscar'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    display_units(bot,event,args)
    return nil
  elsif ['sort','list'].include?(args[0].downcase) || (['clasificar','clasifica','lista','listar'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    sort_units(bot,event,args)
    return nil
  elsif ['compare','comparison'].include?(args[0].downcase) || (['comparar','compara'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    comparison(bot,event,args)
    return nil
  elsif ['rand','random'].include?(args[0].downcase) || (['aleatoria','aleatorio'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    pick_random_unit(event,args,bot)
    return nil
  elsif ['pairup','pair_up','pair','pocket'].include?(args[0].downcase) || (['agrupar','agrupa','par','bolsillo'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    pair_up(bot,event,args)
    return nil
  elsif ['eff_hp','effhp','bulk'].include?(args[0].downcase) || (['masa'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    effHP(bot,event,args)
    return nil
  elsif ['proc'].include?(args[0].downcase)
    args.shift
    proc_study(bot,event,args)
    return nil
  elsif ['heal'].include?(args[0].downcase) || (['curar','cura'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    heal_study(bot,event,args)
    return nil
  elsif ['study'].include?(args[0].downcase) || (Shardizard==$spanishShard && ['estudio','estudia','estudiar'].include?(args[0].downcase))
    args.shift
    if ['effhp','eff_hp','bulk'].include?(args[0].downcase) || (['masa'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=effHP(bot,event,args)
      return nil unless k.nil? || k<0
    elsif ['pair_up','pairup','pair','pocket'].include?(args[0].downcase) || (['agrupar','agrupa','par','bolsillo'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=effHP(bot,event,args)
      return nil unless k.nil? || k<0
    elsif ['heal'].include?(args[0].downcase) || (['curar','cura'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=heal_study(bot,event,args)
      return nil unless k.nil? || k<0
    elsif ['proc'].include?(args[0].downcase)
      args.shift
      k=proc_study(bot,event,args)
      return nil unless k.nil? || k<0
    elsif ['phase'].include?(args[0].downcase) || (['fase'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=proc_study(bot,event,args)
      return nil unless k.nil? || k<0
    end
    unit_study(bot,event,args)
    return nil
  elsif ['fgo'].include?(args[0].downcase) && !find_data_ex(:find_FGO_servant,event,args[1,args.length-1],nil,bot).nil?
    args.shift
    disp_stats_for_FGO(bot,event,args,find_data_ex(:find_FGO_servant,event,args,nil,bot))
    return nil
  end
  args=sever(args.join(' ')).split(' ')
  x=find_data_ex(:find_unit,event,args,nil,bot,false,0,1)
  x[1]=first_sub(args.join(' ').downcase,x[1].downcase,'') unless x.nil?
  if x.nil?
    event.respond nomf()
  elsif x[0].is_a?(Array)
    disp_unit_stats(bot,event,x[0].map{|q| q.name},x[1],'smol',true)
  else
    disp_unit_stats(bot,event,x[0].name,x[1],'smol',true)
  end
  return nil
end

bot.command(:structure, aliases: [:struct]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_struct(bot,event,args.join(' '))
end

bot.command(:item) do |event, *args|
  return nil if overlap_prevent(event)
  disp_itemu(bot,event,args.join(' '))
end

bot.command(:acc, aliases: [:accessory,:accessorie]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_accessory(bot,event,args.join(' '))
end

# primary entities end here

bot.command(:today, aliases: [:todayinfeh,:todayInFEH,:today_in_feh,:today_in_FEH,:daily,:now]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  today_in_feh(event,bot)
  return nil
end

bot.command(:tomorrow, aliases: [:tomorow,:tommorrow,:tommorow]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  today_in_feh(event,bot,true)
  return nil
end

bot.command(:next, aliases: [:schedule]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  next_events(bot,event,args)
  return nil
end

bot.command(:aliases, aliases: [:checkaliases,:seealiases]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  list_aliases(bot,event,args)
  return nil
end

bot.command(:saliases, aliases: [:serveraliases]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  list_aliases(bot,event,args,1)
  return nil
end

bot.command(:addalias) do |event, newname, unit, modifier, modifier2|
  return nil if overlap_prevent(event)
  data_load(['library'])
  add_new_alias(bot,event,newname,unit,modifier,modifier2)
  return nil
end

bot.command(:alias) do |event, newname, unit, modifier, modifier2|
  return nil if overlap_prevent(event)
  data_load(['library'])
  add_new_alias(bot,event,newname,unit,modifier,modifier2,1)
  return nil
end

bot.command(:deletealias, aliases: [:removealias]) do |event, name|
  return nil if overlap_prevent(event)
  nicknames_load()
  if name.nil?
    event.respond "I can't delete nothing, silly!" unless Shardizard==$spanishShard
    event.respond "¡No puedo borrar nada, tonto!" if Shardizard==$spanishShard
    return nil
  elsif event.user.id != 167657750971547648 && event.server.nil?
    event.respond 'Only my developer is allowed to use this command in PM.' unless Shardizard==$spanishShard
    event.respond 'Solo mi desarrollador puede usar este comando en mensajes privados.' if Shardizard==$spanishShard
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.' unless Shardizard==$spanishShard
    event.respond 'No eres moderador.' if Shardizard==$spanishShard
    return nil
  end
  saliases=true
  saliases=false if event.user.id==167657750971547648 # only my developer can delete global aliases
  canremove=false
  k=find_best_match(event,[],name,bot,true,0)
  if !k.nil? && k.is_a?(Array)
    k=k[0] unless k[0].is_a?(FEHUnit) && event.user.id==167657750971547648
    k=nil if k.is_a?(FEHUnit)
  end
  cmpr=[]
  if k.nil?
    k=find_best_match(event,[],name,bot,false,0)
    if k.nil?
      event.respond "#{name} is not an alias, silly!" unless Shardizard==$spanishShard
      event.respond "¡#{name} no es un alias, tonto!" if Shardizard==$spanishShard
    else
      f=k.alias_list(bot,event,saliases,true)
      f=f.reject{|q| q[0,name.length].downcase != name.downcase}
      if f.length<=0
        event.respond "You cannot delete a global alias." unless Shardizard==$spanishShard
        event.respond "No puede eliminar un alias global." if Shardizard==$spanishShard
      else
        event.respond "Please use a whole alias, not a partial one.  The following aliases begin with the text you typed:\n#{f.join("\n")}" unless Shardizard==$spanishShard
        event.respond "Utilice un alias completo, no parcial. Los siguientes alias comienzan con el texto que escribió:\n#{f.join("\n")}" if Shardizard==$spanishShard
      end
    end
    return nil
  elsif k.is_a?(Array)
    k2='Unit'
    baseunt=k.map{|q| q.name}.join('/')
    cmpr.push(k.map{|q| q.name})
    cmpr.push(k.map{|q| q.id})
  elsif !k.alias_list(bot,event,saliases,true).map{|q| q.downcase}.include?(name.downcase) && event.user.id != 167657750971547648
    event.respond "You cannot delete a global alias." unless Shardizard==$spanishShard
    event.respond "No puede eliminar un alias global." if Shardizard==$spanishShard
    return nil
  else
    k2="#{k.objt}"
    baseunt="#{k.fullName}#{k.emotes(bot,false)}"
    cmpr.push(k.fullName)
    cmpr.push(k.id) unless k.id.nil?
  end
  kx=0
  kx=event.server.id unless event.server.nil?
  alz=$aliases.map{|q| q}
  globalattempt=false
  for i in 0...alz.length
    if alz[i][0]==k2 && alz[i][1].downcase==name.downcase && cmpr.include?(alz[i][2])
      if alz[i][3].nil?
        if event.user.id==167657750971547648
          alz[i]=nil
        else
          globalattempt=true
        end
      elsif alz[i][3].include?(kx)
        globalattempt=false
        alz[i][3]=alz[i][3].reject{|q| q==kx}
        alz[i]=nil if alz[i][3].length<=0
      end
    end
  end
  k2='Multiunit' if k.is_a?(Array)
  if globalattempt
    event.respond "You cannot delete a global alias." unless Shardizard==$spanishShard
    event.respond "No puede eliminar un alias global." if Shardizard==$spanishShard
    return nil
  end
  alz.uniq!
  alz.compact!
  alz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
  logchn=log_channel()
  str=''
  if event.server.nil?
    str="**PM with dev:**"
  else
    f="#{shard_data(0)[Shardizard]}"
    f="Spanish" if Shardizard==$spanishShard
    str="**Server:** #{event.server.name} (#{event.server.id}) - #{} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:**"
  end
  str="#{str} #{event.user.distinct} (#{event.user.id})"
  str="#{str}\n~~**#{k2} Alias:** #{name} for #{baseunt}~~ "
  if rand(1000)==0
    str="#{str}**YEETED**"
  else
    str="#{str}**DELETED**"
  end
  bot.channel(logchn).send_message(str)
  event.respond "#{name} has been removed from #{baseunt}'s aliases." unless Shardizard==$spanishShard
  event.respond "#{name} se ha eliminado de los alias de #{baseunt}." if Shardizard==$spanishShard
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

bot.command(:groups, aliases: [:seegroups,:checkgroups]) do |event|
  return nil if overlap_prevent(event)
  data_load()
  disp_groups(event,bot)
end

bot.command(:addgroup) do |event, groupname, *args|
  return nil if overlap_prevent(event)
  data_load()
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) } unless args.nil?
  if Shardizard==$spanishShard
    if groupname.nil?
      event.respond "¡No puedo añadir un grupo sin nombre, tonto!"
      return nil
    elsif args.nil? || args.length<=0
      event.respond "¡No puedo añadir un grupo sin miembros, tonto!\n...bueno, de hecho, podría, pero ¿cuál sería el punto?"
      return nil
    elsif event.server.nil? && event.user.id != 167657750971547648
      event.respond 'Solo mi desarrollador puede usar este comando en mensajes privados.'
      return nil
    elsif ![167657750971547648].include?(event.user.id) && !is_mod?(event.user,event.server,event.channel)
      event.respond 'No eres moderador.'
      return nil
    elsif find_group(event,[],groupname).nil?
    elsif find_group(event,[],groupname).fake.nil? && event.user.id != 167657750971547648
      event.respond 'No tiene los privilegios para editar este grupo global.'
      return nil
    elsif !find_unit(event,[],groupname).nil?
      event.respond "Esto no está permitido como nombre de grupo ya que es un nombre de personaje."
      return nil
    elsif !find_skill(event,[],groupname).nil?
      event.respond "Esto no está permitido como nombre de grupo ya que es un nombre de habilidad."
      return nil
    end
  elsif groupname.nil?
    event.respond "I can't add a group with no name, silly!"
    return nil
  elsif args.nil? || args.length<=0
    event.respond "I can't add a group with no members, silly!\n...well, actually, I could, but what would be the point?"
    return nil
  elsif event.server.nil? && event.user.id != 167657750971547648
    event.respond 'Only my developer is allowed to use this command in PM.'
    return nil
  elsif ![167657750971547648].include?(event.user.id) && !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.'
    return nil
  elsif find_group(event,[],groupname).nil?
  elsif find_group(event,[],groupname).fake.nil? && event.user.id != 167657750971547648
    event.respond 'You do not have the privileges to edit this global group.'
    return nil
  elsif !find_unit(event,[],groupname).nil?
    event.respond "This is not allowed as a group name as it's a unit name."
    return nil
  elsif !find_skill(event,[],groupname).nil?
    event.respond "This is not allowed as a group name as it's a skill name."
    return nil
  end
  x=get_multiple_units(bot,event,args,false)
  data_load()
  grps=$groups.map{|q| q}
  logchn=log_channel()
  str2=''
  if event.server.nil?
    str2="**PM with dev:**"
  else
    shrd="#{shard_data(0)[Shardizard]}"
    shrd="Spanish" if Shardizard==$spanishShard
    str2="**Server:** #{event.server.name} (#{event.server.id}) - #{shrd} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:**"
  end
  str2="#{str2} #{event.user.distinct} (#{event.user.id})"
  untz=x.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join(', ')
  untz=x.map{|q| q.name}.join(', ') if x.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join(', ').length>1000
  if x.length<2 && find_group(event,[],groupname).nil?
    event.respond "I need at least two units to add to the group." unless Shardizard==$spanishShard
    event.respond "Necesito al menos dos caracteres para agregar al grupo." if Shardizard==$spanishShard
    return nil
  elsif find_group(event,[],groupname).nil?
    b=FEHGroup.new(groupname)
    b.units=x.map{|q| q.name}.sort
    global=false
    global=true if event.user.id==167657750971547648 && (event.server.nil? || event.message.text.downcase.split(' ').include?('global'))
    b.fake=[event.server.id] unless global
    grps.push(b)
    event.respond "A new #{'global ' if global}group **#{groupname}** was created with the following members: #{untz}" unless Shardizard==$spanishShard
    event.respond "Se creó un nuevo grupo #{'global ' if global}**#{groupname}** con los siguientes miembros: #{untz}" if Shardizard==$spanishShard
    str2="#{str2}\n**#{'Global ' if global}Group Created:** #{groupname}\n**Units:** #{untz}"
  else
    b=find_group(event,[],groupname).clone
    grps=grps.reject{|q| q.name.downcase==b.name.downcase && q.fake==b.fake}
    for i in 0...x.length
      b.units.push(x[i].name)
    end
    b.units.sort!
    b.units.uniq!
    grps.push(b)
    event.respond "The existing #{'global ' if b.fake.nil?}group **#{b.name}** was updated to include the following members: #{untz}" unless Shardizard==$spanishShard
    event.respond "El grupo #{'global ' if b.fake.nil?}existente **#{b.name}** se actualizó para incluir los siguientes miembros: #{untz}" if Shardizard==$spanishShard
    str2="#{str2}\n**#{'Global ' if b.fake.nil?}Group:** #{b.name}\n**Units Added:** #{untz}"
  end
  bot.channel(logchn).send_message(str2)
  grps=grps.sort{|a,c| a.name.downcase<=>c.name.downcase}
  open("#{$location}devkit/FEHGroups.txt", 'w') { |f|
    f.puts grps.map{|q| [q.name, q.units, q.fake].compact.to_s}.join("\n")
  }
  bot.channel(logchn).send_message('Group list saved.')
  open("#{$location}devkit/FEHGroups2.txt", 'w') { |f|
    f.puts grps.map{|q| [q.name, q.units, q.fake].compact.to_s}.join("\n")
  }
  bot.channel(logchn).send_message('Group list has been backed up.')
  return nil
end

bot.command(:removemember, aliases: [:removefromgroup]) do |event, groupname, unit|
  return nil if overlap_prevent(event)
  data_load()
  if event.server.nil? && event.user.id != 167657750971547648
    event.respond 'Only my developer is allowed to use this command in PM.' unless Shardizard==$spanishShard
    event.respond 'Solo mi desarrollador puede usar este comando en mensajes privados.' if Shardizard==$spanishShard
    return nil
  elsif unit.nil? || groupname.nil?
    event.respond 'You must list a group and a unit to remove from it.' unless Shardizard==$spanishShard
    event.respond 'Debes enumerar un grupo y un personaje para eliminarlo.' if Shardizard==$spanishShard
    return nil
  elsif ![167657750971547648].include?(event.user.id) && !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.' unless Shardizard==$spanishShard
    event.respond 'No eres moderador.' if Shardizard==$spanishShard
    return nil
  elsif find_group(event,[],groupname).nil? || find_unit(event,[],unit).nil?
    multiform=false
    if event.user.id==167657750971547648 && !find_unit(event,[],unit).nil? && !find_unit(event,[],groupname).nil? && find_unit(event,[],groupname).is_a?(Array)
      # removing a member from a multi-unit alias
      multiform=true
      remove_multialias(bot,event,groupname,unit)
    end
    unless multiform
      f=[]
      if Shardizard==$spanishShard
        f.push("El grupo #{groupname} no existe.") if find_group(event,[],groupname).nil?
        f.push("La personaje #{unit} no existe.") if find_unit(event,[],unit).nil?
      else
        f.push("The group #{groupname} does not exist.") if find_group(event,[],groupname).nil?
        f.push("The unit #{unit} does not exist.") if find_unit(event,[],unit).nil?
      end
      event.respond f.join("\n") unless f.length<=0
    end
    return nil
  elsif find_group(event,[],groupname).fake.nil? && event.user.id != 167657750971547648
    event.respond 'You do not have the privileges to edit this global group.'
    return nil
  end
  grp=find_group(event,[],groupname).clone
  grpz=$groups.reject{|q| q.name==grp.name && q.fake==grp.fake}
  unt=find_unit(event,[],unit)
  unt=[unt] unless unt.is_a?(Array)
  if !has_any?(grp.units,unt.map{|q| q.name})
    if has_any?(grp.unit_list.map{|q| q.name},unt.map{|q| q.name})
      event.respond "The unit#{'s' unless unt.length==1} #{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} #{'is' if unt.length==1}#{'are' unless unt.length==1} in the group #{grp.fullName} dynamically.  If you wish to remove them, you must edit the formula adding units to the group." unless Shardizard==$spanishShard
      event.respond "El personaje #{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} está en el grupo #{grp.fullName} de forma dinámica. Si desea eliminarlos, debe editar la fórmula agregando unidades al grupo." if Shardizard==$spanishShard && unt.length==1
      event.respond "Los personajes #{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} están en el grupo #{grp.fullName} de forma dinámica. Si desea eliminarlos, debe editar la fórmula agregando unidades al grupo." if Shardizard==$spanishShard && unt.length>1
    elsis Shardizard==$spanishShard
      event.respond "El personaje #{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} no está en el grupo #{grp.fullName}." if unt.length==1
      event.respond "Los personajes #{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} no están en el grupo #{grp.fullName}." if unt.length>1
    else
      event.respond "The unit#{'s' unless unt.length==1} #{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} #{'is' if unt.length==1}#{'are' unless unt.length==1} not in the group #{grp.fullName}."
    end
    return nil
  end
  grp.units=grp.units.reject{|q| unt.map{|q2| q2.name}.include?(q)}
  logchn=log_channel()
  str1="#{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} has been removed from the group **#{grp.name}**."
  str1="#{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join('/')} ha sido eliminado del grupo **#{grp.name}**." if Shardizard==$spanishShard
  str2=''
  if event.server.nil?
    str2="**PM with dev:**"
  else
    shrd="#{shard_data(0)[Shardizard]}"
    shrd="Spanish" if Shardizard==$spanishShard
    str2="**Server:** #{event.server.name} (#{event.server.id}) - #{shrd} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:**"
  end
  str2="#{str2} #{event.user.distinct} (#{event.user.id})"
  if grp.units.length<=0 && !grp.fake.nil?
    str1="#{str1}\nThe group now has 0 members, so I'm deleting it." unless Shardizard==$spanishShard
    str1="#{str1}\nEl grupo ahora tiene 0 miembros, así que lo eliminaré." if Shardizard==$spanishShard
    if rand(1000)==0
      str2="#{str2}\n~~**Group:** #{grp.name}~~ **YEETED**"
    else
      str2="#{str2}\n~~**Group:** #{grp.name}~~ **DELETED**"
    end
  else
    str2="#{str2}\n**Group:** #{grp.name}\n**Units removed:** #{unt.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join(', ')}"
    grpz.push(grp)
  end
  event.respond str1
  bot.channel(logchn).send_message(str2)
  grpz=grpz.sort{|a,c| a.name.downcase<=>c.name.downcase}
  open("#{$location}devkit/FEHGroups.txt", 'w') { |f|
    f.puts grpz.map{|q| [q.name, q.units, q.fake].compact.to_s}.join("\n")
  }
  bot.channel(logchn).send_message('Group list saved.')
  open("#{$location}devkit/FEHGroups2.txt", 'w') { |f|
    f.puts grpz.map{|q| [q.name, q.units, q.fake].compact.to_s}.join("\n")
  }
  bot.channel(logchn).send_message('Group list has been backed up.')
  return nil
end

bot.command(:deletegroup, aliases: [:removegroup]) do |event, xname|
  return nil if overlap_prevent(event)
  data_load()
  if event.server.nil? && event.user.id != 167657750971547648
    event.respond 'Only my developer is allowed to use this command in PM.' unless Shardizard==$spanishShard
    event.respond 'Solo mi desarrollador puede usar este comando en mensajes privados.' if Shardizard==$spanishShard
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.' unless Shardizard==$spanishShard
    event.respond 'No eres moderador.' if Shardizard==$spanishShard
    return nil
  elsif xname.nil?
    event.respond 'I need the name of a group to delete!' unless Shardizard==$spanishShard
    event.respond '¡Necesito el nombre de un grupo para eliminar!' if Shardizard==$spanishShard
    return nil
  elsif find_group(event,[],xname).nil?
    event.respond "The group #{xname} doesn't even exist in the first place, silly!" unless Shardizard==$spanishShard
    event.respond "¡El grupo #{xname} ni siquiera existe en primer lugar, tonto!" if Shardizard==$spanishShard
    return nil
  elsif find_group(event,[],xname).fake.nil? && event.user.id != 167657750971547648
    event.respond 'You do not have the permission to delete global groups.' unless Shardizard==$spanishShard
    event.respond 'No tiene permiso para eliminar grupos globales.' if Shardizard==$spanishShard
    return nil
  elsif find_group(event,[],xname).isDynamic?
    event.respond "The group #{find_group(event,[],xname).name} is dynamic." unless Shardizard==$spanishShard
    event.respond "El grupo #{find_group(event,[],xname).name} es dinámico." if Shardizard==$spanishShard
    return nil
  end
  f=find_group(event,[],xname)
  grps=$groups.map{|q| q}
  grps=grps.reject{|q| q.name==f.name && ((event.user.id==167657750971547648 && q.fake.nil?) || (!event.server.nil? && q.fake==[event.server.id]))}
  logchn=log_channel()
  str2=''
  if event.server.nil?
    str2="**PM with dev:**"
  else
    shrd="#{shard_data(0)[Shardizard]}"
    shrd="Spanish" if Shardizard==$spanishShard
    str2="**Server:** #{event.server.name} (#{event.server.id}) - #{shrd} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:**"
  end
  str2="#{str2} #{event.user.distinct} (#{event.user.id})"
  if rand(1000)==0
    str2="#{str2}\n~~**Group:** #{f.name}~~ **YEETED**"
  else
    str2="#{str2}\n~~**Group:** #{f.name}~~ **DELETED**"
  end
  event.respond "The group **#{f.name}** has been deleted." unless Shardizard==$spanishShard
  event.respond "El grupo **#{f.name}** ha sido eliminado" if Shardizard==$spanishShard
  bot.channel(logchn).send_message(str2)
  grps=grps.sort{|a,c| a.name.downcase<=>c.name.downcase}
  open("#{$location}devkit/FEHGroups.txt", 'w') { |f|
    f.puts grps.map{|q| [q.name, q.units, q.fake].compact.to_s}.join("\n")
  }
  bot.channel(logchn).send_message('Group list saved.')
  open("#{$location}devkit/FEHGroups2.txt", 'w') { |f|
    f.puts grps.map{|q| [q.name, q.units, q.fake].compact.to_s}.join("\n")
  }
  bot.channel(logchn).send_message('Group list has been backed up.')
  return nil
end

bot.command(:addmultialias, aliases: [:adddualalias,:addualalias,:addmultiunitalias,:adddualunitalias,:addualunitalias,:multialias,:dualalias,:addmulti], from: 167657750971547648) do |event, multi, *args|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  data_load()
  if args.nil? || args.length.zero?
    event.respond 'No units were included.'
    return nil
  elsif multi.nil? || multi.length<=0
    event.respond 'No name was included.'
    return nil
  end
  x=get_multiple_units(bot,event,args,false)
  if x.length<2 && find_unit(event,[],multi).nil?
    event.respond "I need at least two units to give the alias to."
    return nil
  elsif !find_unit(event,[],multi,bot,true).nil? && !find_unit(event,[],multi,bot,true).is_a?(Array)
    event.respond "#{multi} is a single-unit alias."
    return nil
  end
  data_load()
  logchn=log_channel()
  str2=''
  if event.server.nil?
    str2="**PM with dev:**"
  else
    str2="**Server:** #{event.server.name} (#{event.server.id}) - #{shard_data(0)[Shardizard]} Shard\n**Channel:** #{event.channel.name} (#{event.channel.id})\n**User:**"
  end
  str2="#{str2} #{event.user.distinct} (#{event.user.id})"
  untz=x.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join(', ')
  untz=x.map{|q| q.name}.join(', ') if x.map{|q| "#{q.name}#{q.emotes(bot,false)}"}.join(', ').length>1000
  alz=$aliases.map{|q| q}
  if find_unit(event,[],multi,bot,true).nil?
    alz.push(['Unit',multi,x.map{|q| q.id}])
    str1="**#{multi}** has been (globally) added to the aliases for the units *#{untz}*."
    str2="#{str2}\n**Multi-Unit Alias:** #{multi} for #{untz}"
  else
    als=alz.find_index{|q| q[0]=='Unit' && q[1].downcase==multi.downcase && q[2].is_a?(Array)}
    als=alz[als]
    alz=alz.reject{|q| q[0]=='Unit' && q[1]==als[1] && q[2]==als[2]}
    als[2].push(x.map{|q| q.id})
    als[2].flatten!
    als[2].uniq!
    str1="The multi-unit alias **#{als[1]}** has been updated to include the units *#{untz}*."
    str2="#{str2}\n**Multi-Unit Alias:** #{multi} for #{untz} - additions"
    alz.push(als)
  end
  alz.uniq!
  alz.compact!
  alz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
  event.respond str1
  bot.channel(logchn).send_message(str2)
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

bot.command(:removefrommultialias, aliases: [:removefromdualalias,:removefrommultiunitalias,:removefromdualunitalias,:removefrommulti], from: 167657750971547648) do |event, multi, unit|
  return nil if overlap_prevent(event)
  data_load()
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  if multi.nil? || multi.length<=0
    event.respond 'No name was included.'
    return nil
  elsif unit.nil?
    event.respond 'No units were included.'
    return nil
  elsif find_unit(event,[],multi).nil? || !find_unit(event,[],multi).is_a?(Array) || find_unit(event,[],unit).nil?
    f=[]
    f.push("#{multi} is not a multi-unit alias.") if find_unit(event,[],multi).nil? || !find_unit(event,[],multi).is_a?(Array)
    f.push("The unit #{unit} does not exist.") if find_unit(event,[],unit).nil?
    event.respond f.join("\n") unless f.length<=0
    return nil
  end
  remove_multialias(bot,event,multi,unit)
  return nil
end

bot.command(:study, aliases: [:statstudy,:studystats,:statsstudy]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond nomf()
    return nil
  end
  data_load(['library'])
  if ['effhp','eff_hp','bulk'].include?(args[0].downcase) || (['masa'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    k=effHP(bot,event,args)
    return nil unless k.nil? || k<0
  elsif ['pair_up','pairup','pair','pocket'].include?(args[0].downcase) || (['agrupar','agrupa','par','bolsillo'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    k=effHP(bot,event,args)
    return nil unless k.nil? || k<0
  elsif ['heal'].include?(args[0].downcase) || (['curar','cura'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    k=heal_study(bot,event,args)
    return nil unless k.nil? || k<0
  elsif ['proc'].include?(args[0].downcase)
    args.shift
    k=proc_study(bot,event,args)
    return nil unless k.nil? || k<0
  elsif ['phase'].include?(args[0].downcase) || (['fase'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    k=0
    return nil unless k.nil? || k<0
  end
  unit_study(bot,event,args)
end

bot.command(:heal_study, aliases: [:healstudy,:studyheal,:study_heal,:heal]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond nomf()
    return nil
  end
  data_load(['library'])
  heal_study(bot,event,args)
  return nil
end

bot.command(:proc_study, aliases: [:procstudy,:studyproc,:study_proc,:proc]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond nomf()
    return nil
  end
  proc_study(bot,event,args)
  return nil
end

bot.command(:phase_study, aliases: [:phasestudy,:studyphase,:study_phase,:phase]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond nomf()
    return nil
  end
  phase_study(bot,event,args)
  return nil
end

bot.command(:effhp, aliases: [:effHP,:eff_hp,:eff_HP,:bulk]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond nomf()
    return nil
  end
  data_load(['library'])
  effHP(bot,event,args)
  return nil
end

bot.command(:pairup, aliases: [:pair_up,:pair,:pocket]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  data_load(['library'])
  pair_up(bot,event,args)
  return nil
end

bot.command(:alts, aliases: [:alt]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  find_alts(bot,event,args)
end

bot.command(:art, aliases: [:artist]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  if args.nil? || args.length<1
    event.respond 'No unit or generic data was included'
    return nil
  end
  disp_unit_art(bot,event,args)
end

bot.command(:games) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  game_data(bot,event,args)
  return nil
end

bot.command(:divine, aliases: [:devine,:code,:path]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  if args.nil? || args[0].nil? || ['next','schedule'].include?(args[0].downcase)
    disp_current_paths(event,bot,-1)
    disp_current_paths(event,bot,-2) if safe_to_spam?(event)
    return nil
  end
  path_data(bot,event,args)
  return nil
end

bot.command(:banners, aliases: [:banner]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  strx="No unit was included.  Showing current and upcoming banners."
  strx='' if Shardizard==$spanishShard
  nxt=['next','schedule']
  nxt.push(['siguiente','calendario']) if Shardizard==$spanishShard
  nxt.flatten!
  if args.nil? || args[0].nil? || nxt.include?(args[0].downcase)
    str=''
    str=strx unless !args.nil? && !args[0].nil? && nxt.include?(args[0].downcase)
    disp_current_banners(event,bot,str)
    return nil
  elsif ['find','search'].include?(args[0].downcase) || (['encontra','busca','encontrar','buscar'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    display_banners(bot,event,args)
    return nil
  end
  x=find_data_ex(:find_unit,event,args,nil,bot,false,0)
  unless x.is_a?(Array) || x.is_a?(FEHUnit)
    disp_current_banners(event,bot,strx)
    return nil
  end
  banner_list(event,bot,args,x)
end

bot.command(:allinheritance, aliases: [:allinherit,:allinheritable,:skillinheritance,:skillinherit,:skillinheritable,:skilllearn,:skilllearnable,:skillsinheritance,:skillsinherit,:skillsinheritable,:skillslearn,:skillslearnable,:inheritanceskills,:inheritskill,:inheritableskill,:learnskill,:learnableskill,:inheritanceskills,:inheritskills,:inheritableskills,:learnskills,:learnableskills,:all_inheritance,:all_inherit,:all_inheritable,:skill_inheritance,:skill_inherit,:skill_inheritable,:skill_learn,:skill_learnable,:skills_inheritance,:skills_inherit,:skills_inheritable,:skills_learn,:skills_learnable,:inheritance_skills,:inherit_skill,:inheritable_skill,:learn_skill,:learnable_skill,:inheritance_skills,:inherit_skills,:inheritable_skills,:learn_skills,:learnable_skills,:inherit,:learn,:inheritance,:learnable,:inheritable,:skillearn,:skillearnable]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<1
    event.respond 'No unit was included'
    return nil
  end
  data_load(['library'])
  learnable_skills(bot,event,args)
  return nil
end

bot.command(:bst) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  combined_BST(bot,event,args)
  return nil
end

bot.command(:compare, aliases: [:comparison]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  if args.nil? || args[0].nil?
  elsif ['skills','skill'].include?(args[0].downcase) || (['habilidad','habilidades'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    skill_comparison(bot,event,args)
    return nil
  end
  comparison(bot,event,args)
  return nil
end

bot.command(:compareskills, aliases: [:compareskill,:skillcompare,:skillscompare,:comparisonskills,:comparisonskill,:skillcomparison,:skillscomparison,:compare_skills,:compare_skill,:skill_compare,:skills_compare,:comparison_skills,:comparison_skill,:skill_comparison,:skills_comparison,:skillsincommon,:skills_in_common,:commonskills,:common_skills]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  skill_comparison(bot,event,args)
  return nil
end

bot.command(:find, aliases: [:search,:lookup]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  display_units_and_skills(bot,event,args)
end

bot.command(:sort, aliases: [:list]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  if args.nil? || args[0].nil?
  elsif ['skill','skills'].include?(args[0].downcase) || (['habilidad','habilidades'].include?(args[0].downcase) && Shardizard==$spanishShard)
    args.shift
    sort_skills(bot,event,args)
    return nil
  elsif event.user.id != 167657750971547648
  elsif ['flower','flowers'].include?(args[0])
    args.shift
    dev_flower_list(event,bot,args)
    return nil
  elsif ['grail','greil'].include?(args[0])
    args.shift
    dev_grail_list(event,bot,args)
    return nil
  elsif ['alias','aliases'].include?(args[0].downcase)
    nicknames_load()
    alz=$aliases.sort{|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    open("#{$location}devkit/FEHNames.txt", 'w') { |f|
      f.puts alz.map{|q| q.to_s}.join("\n")
    }
    event.respond 'The alias list has been sorted alphabetically'
    return nil
  elsif ['group','groups'].include?(args[0].downcase)
    data_load(['groups'])
    grps=$groups.sort{|a,c| a.name.downcase<=>c.name.downcase}
    open("#{$location}devkit/FEHGroups.txt", 'w') { |f|
      f.puts grps.map{|q| [q.name, q.units, q.fake].compact.to_s}.join("\n")
    }
    event.respond 'The groups list has been sorted alphabetically'
    return nil
  end
  sort_units(bot,event,args)
end

bot.command(:sortskill, aliases: [:skillsort,:sortskills,:skillssort,:listskill,:skillist,:skillist,:listskills,:skillslist]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  sort_skills(bot,event,args)
end

bot.command(:sortstats, aliases: [:statssort,:sortstat,:statsort,:liststats,:statslist,:statlist,:liststat,:sortunits,:unitssort,:sortunit,:unitsort,:listunits,:unitslist,:unitlist,:listunit]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  sort_units(bot,event,args)
end

bot.command(:average, aliases: [:mean]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  stats_of_multiunits(bot,event,args,0)
end

bot.command(:bestamong, aliases: [:bestin,:beststats,:higheststats,:highest,:best,:highestamong,:highestin]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  stats_of_multiunits(bot,event,args,1)
end

bot.command(:worstamong, aliases: [:worstin,:worststats,:loweststats,:lowest,:worst,:lowestamong,:lowestin]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  stats_of_multiunits(bot,event,args,-1)
end

bot.command(:random, aliases: [:rand]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  if args.nil? || args.length.zero?
  elsif ['hero','unit','real'].include?(args[0].downcase)
    args.shift
    pick_random_unit(event,args,bot)
    return nil
  elsif ['skill','skil'].include?(args[0].downcase)
    args.shift
    pick_random_skill(event,args,bot)
    return nil
  end
  make_random_unit(event,args,bot)
end

bot.command(:randomunit, aliases: [:randunit,:unitrandom,:unitrand,:randomstats,:statsrand,:statsrandom,:randstats]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  pick_random_unit(event,args,bot)
end

bot.command(:randomskill, aliases: [:randskill,:skillrandom,:skillrand,:randomskil,:skilrand,:skilrandom,:randskil]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  pick_random_skill(event,args,bot)
end

bot.command(:prf, aliases: [:prfs]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  disp_all_prfs(event,bot)
end

bot.command(:refine, aliases: [:refinery]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  disp_all_refines(event,bot)
end

bot.command(:effect) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  disp_all_refines(event,bot,true)
end

bot.command(:summonpool, aliases: [:summon_pool,:pool]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  disp_summon_pool(event,args)
end

bot.command(:summon) do |event, *colors|
  return nil if overlap_prevent(event)
  data_load()
  colors=['x'] if colors.nil? || colors.length<=0
  if ['find','search'].include?(colors[0].downcase)
    colors.shift
    display_banners(event,colors)
    return nil
  elsif colors[0].downcase=='pool' || !(!event.server.nil? && (Summon_servers.include?(event.server.id) || [-1,4].include?(Shardizard) || (has_any?(colors.map{|q| q.downcase},['multi','multisummon']) && safe_to_spam?(event))))
    args=colors.map{|q| q}
    args.shift if colors[0].downcase=='pool'
    disp_summon_pool(event,args)
    return nil
  end
  summon_sim(bot,event,colors)
end

bot.command(:bonus) do |event, *args|
  return nil if overlap_prevent(event)
  data_load()
  args=[] if args.nil? || args.length<=0
  args=args.map{|q| q.downcase}
  x=[]
  x.push('Arena') if args.include?('arena')
  x.push('Tempest') if has_any?(args,['tempest','tt'])
  x.push('Tempest') if has_any?(args,['tormenta']) && Shardizard==$spanishShard
  x.push('Aether') if has_any?(args,['aether','raid','raids','aetherraids','aetherraid','aether_raids','aether_raid','aetheraids','aetheraid'])
  x.push('Aether') if has_any?(args,['eter','etér']) && Shardizard==$spanishShard
  x.push('Resonant') if has_any?(args,['resonant','resonance','resonence'])
  x.push('Resonant') if has_any?(args,['fragorosas','fragorosa']) && Shardizard==$spanishShard
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
end

bot.command(:arena, aliases: [:arenabonus,:arena_bonus,:bonusarena,:bonus_arena]) do |event|
  return nil if overlap_prevent(event)
  data_load()
  show_bonus_units(event,['Arena'],bot)
end

bot.command(:tempest, aliases: [:tempestbonus,:tempest_bonus,:bonustempest,:bonus_tempest,:tt,:ttbonus,:tt_bonus,:bonustt,:bonus_tt]) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<=0
  elsif event.user.id==167657750971547648 && ['list'].include?(args[0])
    args.shift
    data_load()
    dev_grail_list(event,bot,args,'Tempest')
    return nil
  end
  data_load()
  show_bonus_units(event,['Tempest'],bot)
end

bot.command(:aether, aliases: [:aetherbonus,:aether_bonus,:aethertempest,:aether_tempest,:raid,:raidbonus,:raid_bonus,:bonusraid,:bonus_raid,:raids,:raidsbonus,:raids_bonus,:bonusraids,:bonus_raids]) do |event|
  return nil if overlap_prevent(event)
  data_load()
  show_bonus_units(event,['Aether'],bot)
end

bot.command(:resonant, aliases: [:resonantbonus,:resonant_bonus,:bonusresonant,:bonus_resonant,:resonance,:resonancebonus,:resonance_bonus,:bonusresonance,:bonus_resonance]) do |event|
  return nil if overlap_prevent(event)
  data_load()
  show_bonus_units(event,['Resonant'],bot)
end

bot.command(:ghb) do |event, *args|
  return nil if overlap_prevent(event) || args.nil? || args.length<=0 || !['list'].include?(args[0])
  return nil unless event.user.id==167657750971547648
  args.shift
  dev_grail_list(event,bot,args,'GHB')
  return nil
end

bot.command(:grail) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<=0
  elsif event.user.id==167657750971547648 && ['list'].include?(args[0])
    args.shift
    data_load(['library','devunits'])
    dev_grail_list(event,bot,args)
    return nil
  end
  disp_itemu(bot,event,'Heroic Grail')
end

bot.command(:greil) do |event, *args|
  return nil if overlap_prevent(event)
  if args.nil? || args.length<=0
  elsif event.user.id==167657750971547648 && ['list'].include?(args[0])
    args.shift
    data_load(['library','devunits'])
    dev_grail_list(event,bot,args)
    return nil
  end
  args=[] if args.nil?
  disp_unit_stats(bot,event,'Greil',args.join(' '),'smol',true)
end

bot.command(:embeds, aliases: [:embed]) do |event|
  return nil if overlap_prevent(event)
  embedless_swap(bot,event)
end

bot.command(:headpat, aliases: [:patpat,:pat]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  headpat(event,bot)
  return nil
end

bot.command(:natures) do |event|
  return nil if overlap_prevent(event)
  event << 'A guide to nature names.  Though things like `+Atk` and `-Def` still work' unless Shardizard==$spanishShard
  event << 'Una guía de nombres de la naturaleza.  Aunque cosas como `+Atq` y`-Def` todavía funcionan' if Shardizard==$spanishShard
  event << "https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/NatureNames#{'Spanish' if Shardizard==$spanishShard}.png?raw=true"
end

bot.command(:growths, aliases: [:gps,:growth,:gp]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  growth_explain(event,bot)
end

bot.command(:oregano) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['unit','library'])
  x=$units.find_index{|q| q.name=='Oregano'}
  if !x.nil? && $units[x].isPostable?(event)
    args=[] if args.nil?
    disp_unit_stats(bot,event,'Oregano',args.join(' '),'smol',true)
    return nil
  end
  oregano_explain(event,bot)
end

bot.command(:whoisoregano, aliases: [:whyoregano]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  oregano_explain(event,bot)
end

bot.command(:merges) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  merge_explain(event,bot)
end

bot.command(:score) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  score_explain(event,bot)
end

bot.command(:whyelise) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  why_elise(event,bot)
end

bot.command(:skillrarity, aliases: [:onestar,:twostar,:threestar,:fourstar,:fivestar,:skill_rarity,:one_star,:two_star,:three_star,:four_star,:five_star]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  skill_rarity(event)
end

bot.command(:attackicon, aliases: [:attackcolor,:attackcolors,:attackcolour,:attackcolours,:atkicon,:atkcolor,:atkcolors,:atkcolour,:atkcolours,:atticon,:attcolor,:attcolors,:attcolour,:attcolours,:staticon,:statcolor,:statcolors,:statcolour,:statcolours,:iconcolor,:iconcolors,:iconcolour,:iconcolours]) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  attack_icon(event)
end

bot.command(:invite) do |event, user|
  return nil if overlap_prevent(event)
  usr=event.user
  txt="**To invite me to your server: <https://goo.gl/HEuQK2>**\nTo look at my source code: <https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/PriscillaBot.rb>\nTo follow my creator's development Twitter and learn of updates: <https://twitter.com/EliseBotDev>\nIf you suggested me to server mods and they ask what I do, copy this image link to them: https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/MarketingElise.png"
  txt="**Para invitarme a tu servidor: <https://goo.gl/HEuQK2>**\nPara mirar mi código fuente: <https://github.com/Rot8erConeX/EliseBot/blob/master/EliseBot/PriscillaBot.rb>\nSeguir el desarrollo de mi creador en Twitter y conocer las actualizaciones: <https://twitter.com/EliseBotDev>\nSi me sugirió mods de servidor y me preguntan qué hago, copie este enlace de imagen a ellos: https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/MarketingElise.png" if Shardizard==$spanishShard
  user_to_name='you'
  user=nil if event.message.mentions.length<=0 && user.to_i.to_s != user
  unless user.nil?
    if /<@!?(?:\d+)>/ =~ user
      usr=event.message.mentions[0]
      txt="This message was sent to you at the request of #{event.user.distinct}.\n\n#{txt}" unless Shardizard=+$spanishShard
      txt="Este mensaje le fue enviado a solicitud de #{event.user.distinct}.\n\n#{txt}" if Shardizard=+$spanishShard
      user_to_name=usr.distinct
    else
      usr=bot.user(user.to_i)
      txt="This message was sent to you at the request of #{event.user.distinct}.\n\n#{txt}" unless Shardizard=+$spanishShard
      txt="Este mensaje le fue enviado a solicitud de #{event.user.distinct}.\n\n#{txt}" if Shardizard=+$spanishShard
      user_to_name=usr.distinct
    end
  end
  usr.pm(txt)
  texto='A PM was sent to'
  texto='Se envió un mensaje privado a' if Shardizard==$spanishShard
  user_to_name='usted' if user_to_name=='you' && Shardizard==$spanishShard
  event.respond "#{texto} #{user_to_name}." unless event.server.nil? && ['you','usted'].include?(user_to_name)
end

bot.command(:mythic, aliases: [:mythical,:mythics,:mythicals,:mystic,:mystical,:mystics,:mysticals]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_legendary_list(bot,event,args,'Mythic')
  return nil
end

bot.command(:legendary, aliases: [:legendaries,:legendarys,:legend,:legends]) do |event, *args|
  return nil if overlap_prevent(event)
  disp_legendary_list(bot,event,args,'Legendary')
  return nil
end

bot.command(:aoe, aliases: [:area]) do |event, *args|
  return nil if overlap_prevent(event)
  aoe(event,bot,args)
end

bot.command(:flowers, aliases: [:flower]) do |event, *args|
  return nil if overlap_prevent(event)
  data_load(['library','devunits'])
  if args.nil? || args.length<=0
  elsif event.user.id==167657750971547648 && ['list'].include?(args[0])
    args.shift
    dev_flower_list(event,bot,args)
    return nil
  end
  flower_array(event,bot)
end

bot.command(:shard) do |event, i, j|
  return nil if overlap_prevent(event)
  if j.to_i.to_s==j
    j=j.to_i
    if j>256*256 && i.to_i.to_s==i && i.to_i<=256*256
      k=j*1
      j=i.to_i
      i=k*1
    end
  else
    j=Shards*1
  end
  if (i.to_i.to_s==i || i.to_i==i) && i.to_i>256*256
    srv=(bot.server(i.to_i) rescue nil)
    if Shardizard==-1
      event.respond "This server uses Smol Shards, and I cannot check other servers."
    elsif Shardizard==$spanishShard
      event.respond "Este servidor usa el Shard español, y no puedo verificar otros servidores."
    elsif Shardizard ==4 && j != Shards
      event.respond "In a system of #{j} shards, that server would use #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards."
    elsif Shardizard ==4
      event.respond "That server uses/would use #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards."
    elsif srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
      event.respond "I am not in that server, but it would use #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards #{"(in a system of #{j} shards)" if j != Shards}."
    elsif j != Shards
      event.respond "In a system of #{j} shards, *#{srv.name}* would use #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards."
    else
      event.respond "*#{srv.name}* uses #{shard_data(0,true,j)[(i.to_i >> 22) % j]} Shards."
    end
    return nil
  elsif i.to_i.to_s==i
    j=i.to_i*1
    i=0
  end
  str=''
  str="\nBut it is always <:Shard_Orange:552681863962165258> Citrus in spirit!" if !event.server.nil? && event.server.id==392557615177007104
  str='' if shard_data(0,true,j)[(event.server.id >> 22) % j]=='<:Shard_Orange:552681863962165258> Citrus'
  event.respond "This server uses Smol Shards.#{str}" if Shardizard==-1
  event.respond "Este servidor usa el Shard español#{str}" if Shardizard==$spanishShard
  event.respond "This is the debug mode, which uses #{shard_data(0,false,j)[4]} Shards." if Shardizard==4
  event.respond "PMs always use #{shard_data(0,true,j)[0]} Shards." if event.server.nil? && ![-1,4,$spanishShard].include?(Shardizard)
  event.respond "In a system of #{j} shards, this server would use #{shard_data(0,true,j)[(event.server.id >> 22) % j]} Shards." unless event.server.nil? || [-1,4,$spanishShard].include?(Shardizard) || j == Shards
  event.respond "This server uses #{shard_data(0,true,j)[(event.server.id >> 22) % j]} Shards.#{str}" unless event.server.nil? || [-1,4,$spanishShard].include?(Shardizard) || j != Shards
end

bot.command(:status, aliases: [:avatar,:avvie]) do |event, *args|
  return nil if overlap_prevent(event)
  t=Time.now
  timeshift=6
  t-=60*60*timeshift
  if event.user.id==167657750971547648 && !args.nil? && args.length>0 # only work when used by the developer
    bot.game=args.join(' ')
    event.respond 'Status set.'
    return nil
  elsif Shardizard==$spanishShard
    spanish_avatar(bot,event)
    return nil
  end
  if $embedless.include?(event.user.id) || was_embedless_mentioned?(event)
    event << "Current avatar: #{bot.user(312451658908958721).avatar_url}"
    event << "Unit in avatar: #{@avvie_info[0]}"
    event << ''
    event << "Current status:"
    event << "[Playing] #{@avvie_info[1]}"
    event << ''
    event << "Reason: #{@avvie_info[2]}" unless @avvie_info[2].length.zero?
    event << ''
    event << "Dev's timezone: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]}) | #{'0' if t.hour<10}#{t.hour}:#{'0' if t.min<10}#{t.min}"
  else
    create_embed(event,'',"Unit in avatar: #{@avvie_info[0]}\n\nCurrent status:\n[Playing] #{@avvie_info[1]}#{"\n\nReason: #{@avvie_info[2]}" unless @avvie_info[2].length.zero?}\n\n[For a full calendar of avatars, click here](https://docs.google.com/spreadsheets/d/1j-tdpotMO_DcppRLNnT8DN8Ftau-rdQ-ZmZh5rZkZP0/edit?usp=sharing)",(t.day*7+t.month*21*256+(t.year-2000)*10*256*256),"Dev's timezone: #{t.day} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][t.month]} #{t.year} (a #{['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][t.wday]}) | #{'0' if t.hour<10}#{t.hour}:#{'0' if t.min<10}#{t.min}",bot.user(312451658908958721).avatar_url)
  end
  return nil
end

bot.command(:bugreport, aliases: [:suggestion,:feedback]) do |event, *args|
  return nil if overlap_prevent(event)
  event.respond "Tenga en cuenta que este comando responde en inglés, ya que es una comunicación directa con el desarrollador, cuyo idioma principal es el inglés." if Shardizard==$spanishShard
  x=['feh!','feh?','f?','e?','h?']
  x.push(@prefixes[event.server.id]) unless event.server.nil? || @prefixes[event.server.id].nil?
  bug_report(bot,event,args,Shards,shard_data(0,true),'Shard',x)
end

bot.command(:donation, aliases: [:donate,:donacion]) do |event, uid|
  return nil if overlap_prevent(event)
  uid="#{event.user.id}" if uid.nil? || uid.length.zero?
  if /<@!?(?:\d+)>/ =~ uid
    uid=event.message.mentions[0].id
  else
    uid=uid.to_i
    uid=event.user.id if uid==0
  end
  g=get_donor_list()
  data_load(['units','donorunits'])
  if uid==167657750971547648
    n=["#{bot.user(uid).distinct} is","He"]
    n=["You are","You"] if uid==event.user.id
    create_embed(event,"#{n[0]} my developer.","#{n[1]} can have whatever permissions #{n[1].downcase} want#{'s' unless uid==event.user.id} to have.",0x00DAFA)
  elsif g.map{|q| q[0]}.include?(uid)
    n="#{bot.user(uid).distinct} is"
    n="You are" if uid==event.user.id
    g=g[g.find_index{|q| q[0]==uid}]
    str=""
    n4=bot.user(uid).name
    n4=n4[0,[3,n4.length].min]
    n4=" #{n4}" if n4.length<2
    n2=n4.downcase
    n3=[]
    for i in 0...n2.length
      if "abcdefghijklmnopqrstuvwxyz".include?(n2[i])
        n3.push(9*("abcdefghijklmnopqrstuvwxyz".split(n2[i])[0].length)+25)
        n3[i]+=5 if n4[i]!=n2[i]
      elsif n2[i].to_i.to_s==n2[i]
        n3.push(n2[i].to_i*2+1)
      else
        n3.push(0)
      end
    end
    color=n3[0]*256*256+n3[1]*256+n3[2]
    str="**Tier 1:** Access to the donor-exclusive channel in my debug server.\n\u2713 This perk cannot be checked dynamically.\nYou can check if it was given to you by clicking this channel link: <#590642838497394689>" if g[2].max>=1
    str="#{str}\n\n**Tier 2:** Ability to give server-specific aliases in any server\n\u2713 Given" if g[2].max>=2
    if g[2][0]>=3
      if g[3].nil? || g[3].length.zero? || g[4].nil? || g[4].length.zero?
        str="#{str}\n\n**Tier 3:** Birthday avatar\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      elsif g[4][0]=='-'
        str="#{str}\n\n**Tier 3:** Birthday avatar\n\u2713 May be given via another bot."
      elsif !File.exist?("#{$location}devkit/EliseImages/#{g[4][0]}.png")
        str="#{str}\n\n**Tier 3:** Birthday avatar\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected.\n*Birthday:* #{g[3][1]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][g[3][0]]}\n*Character:* #{g[4][0]}"
      else
        str="#{str}\n\n**Tier 3:** Birthday avatar\n\u2713 Given\n*Birthday:* #{g[3][1]} #{['','January','February','March','April','May','June','July','August','September','October','November','December'][g[3][0]]}\n*Character:* #{g[4][0]}"
      end
    end
    dul=$donor_triggers.find_index{|q| q[1]==uid}
    dul=$donor_triggers[dul].map{|q| q} unless dul.nil?
    dul=[] if dul.nil?
    if g[2][0]>=4
      if !File.exist?("#{$location}devkit/EliseUserSaves/#{uid}.txt")
        str="#{str}\n\n**Tier 4:** Unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      else
        str="#{str}\n\n**Tier 4:** Unit tracking\n\u2713 Given\n*Trigger word:* #{dul[0]}'s"
      end
    end
    if g[2][0]>=5
      if !File.exist?("#{$location}devkit/EliseUserSaves/#{uid}.txt")
        str="#{str}\n\n**Tier 5:** __*Colored*__ unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      elsif dul[2].nil?
        str="#{str}\n\n**Tier 5:** __*Colored*__ unit tracking\n\u2717 Not given.  Please contact <@167657750971547648> to have this corrected."
      else
        str="#{str}\n\n**Tier 5:** __*Colored*__ unit tracking\n\u2713 Given\n*Color of choice:* #{dul[2]}"
        color=dul[2].hex
      end
    end
    create_embed(event,"__**#{n} a Tier #{g[2][0]} donor.**__",str,color)
  end
  donor_embed(bot,event)
  return nil
end

bot.command(:prefix) do |event, prefix|
  return nil if overlap_prevent(event)
  if prefix.nil?
    event.respond 'No prefix was defined.  Try again' unless Shardizard==$spanishShard
    event.respond 'No se definió ningún prefijo. Intentar otra vez' if Shardizard==$spanishShard
    return nil
  elsif event.server.nil?
    event.respond 'This command is not available in PM.' unless Shardizard==$spanishShard
    event.respond 'Este comando no está disponible en mensajes privados.' unless Shardizard==$spanishShard
    return nil
  elsif !is_mod?(event.user,event.server,event.channel)
    event.respond 'You are not a mod.' unless Shardizard==$spanishShard
    event.respond 'No eres moderador.' if Shardizard==$spanishShard
    return nil
  elsif ['feh!','feh?','f?','e?','h?','fgo!','fgo?','fg0!','fg0?','liz!','liz?','iiz!','iiz?','fate!','fate?','dl!','dl?','fe!','fe14!','fef!','fe13!','fea!','fe?','fe14?','fef?','fe13?','fea?'].include?(prefix.downcase)
    event.respond "That is a prefix that would conflict with either myself or another one of my developer's bots." unless Shardizard==$spanishShard
    event.respond "Ese es un prefijo que entraría en conflicto conmigo mismo o con otro de los bots de mi desarrollador." if Shardizard==$spanishShard
    return nil
  end
  @prefixes[event.server.id]=prefix
  prefixes_save()
  event.respond "This server's prefix has been saved as **#{prefix}**" unless Shardizard==$spanishShard
  event.respond "El prefijo de este servidor se ha guardado como **#{prefix}**" if Shardizard==$spanishShard
  return nil
end

bot.command(:tools, aliases: [:links,:tool,:link,:resources,:resources]) do |event|
  return nil if overlap_prevent(event)
  show_tools(event,bot)
end

bot.command(:safe, aliases: [:spam,:safetospam,:safe2spam,:long,:longreplies]) do |event, f|
  return nil if overlap_prevent(event)
  f='' if f.nil?
  if event.server.nil?
    event.respond 'It is safe for me to send long replies here because this is my PMs with you.' unless Shardizard==$spanishShard
    event.respond 'Es seguro para mí enviar respuestas largas aquí porque estos son mis mensajes privados contigo.' if Shardizard==$spanishShard
  elsif [443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,691616574393811004,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388].include?(event.server.id)
    event.respond 'It is safe for me to send long replies here because this is one of my emoji servers.' unless Shardizard==$spanishShard
    event.respond 'Es seguro para mí enviar respuestas largas aquí porque este es uno de mis servidores de emoji.' if Shardizard==$spanishShard
  elsif Shardizard==4
    event.respond 'It is safe for me to send long replies here because this is my debug mode.' unless Shardizard==$spanishShard
    event.respond 'Es seguro para mí enviar respuestas largas aquí porque este es mi modo de depuración.' if Shardizard==$spanishShard
  elsif ['bots','bot'].include?(event.channel.name.downcase)
    event.respond "It is safe for me to send long replies here because the channel is named `#{event.channel.name.downcase}`." unless Shardizard==$spanishShard
    event.respond "Es seguro para mí enviar respuestas largas aquí porque el canal se llama `#{event.channel.name.downcase}`." if Shardizard==$spanishShard
  elsif event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('spam')
    event.respond 'It is safe for me to send long replies here because the channel name includes both the word "bot" and the word "spam".' unless Shardizard==$spanishShard
    event.respond 'Es seguro para mí enviar respuestas largas aquí porque el nombre del canal incluye tanto la palabra "bot" como la palabra "spam".' if Shardizard==$spanishShard
  elsif event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('command')
    event.respond 'It is safe for me to send long replies here because the channel name includes both the word "bot" and the word "command".' unless Shardizard==$spanishShard
    event.respond 'Es seguro para mí enviar respuestas largas aquí porque el nombre del canal incluye tanto la palabra "bot" como la palabra "command".' if Shardizard==$spanishShard
  elsif event.channel.name.downcase.include?('bot') && event.channel.name.downcase.include?('channel')
    event.respond 'It is safe for me to send long replies here because the channel name includes both the word "bot" and the word "channel".' unless Shardizard==$spanishShard
    event.respond 'Es seguro para mí enviar respuestas largas aquí porque el nombre del canal incluye tanto la palabra "bot" como la palabra "channel".' if Shardizard==$spanishShard
  elsif event.channel.name.downcase.include?('elisebot') || event.channel.name.downcase.include?('elise-bot') || event.channel.name.downcase.include?('elise_bot')
    event.respond 'It is safe for me to send long replies here because the channel name specifically calls attention to the fact that it is made for me.' unless Shardizard==$spanishShard
    event.respond 'Es seguro para mí enviar respuestas largas aquí porque el nombre del canal llama específicamente la atención sobre el hecho de que está hecho para mí.' if Shardizard==$spanishShard
  elsif $spam_channels.include?(event.channel.id)
    if is_mod?(event.user,event.server,event.channel) && ['off','no','false'].include?(f.downcase)
      metadata_load()
      $spam_channels.delete(event.channel.id)
      metadata_save()
      event.respond 'This channel is no longer marked as safe for me to send long replies to.' unless Shardizard==$spanishShard
    elsif Shardizard==$spanishShard
      event << 'Este canal ha sido diseñado específicamente para que pueda enviar respuestas largas con seguridad.'
      event << ''
      event << 'Si desea cambiar eso, pídale a un mod de servidor que escriba `FEH!spam off` en este canal.'
    else
      event << 'This channel has been specifically designated for me to be safe to send long replies to.'
      event << ''
      event << 'If you wish to change that, ask a server mod to type `FEH!spam off` in this channel.'
    end
  elsif is_mod?(event.user,event.server,event.channel,1) && ['on','yes','true'].include?(f.downcase)
    metadata_load()
    $spam_channels.push(event.channel.id)
    metadata_save()
    event.respond 'This channel is now marked as safe for me to send long replies to.' unless Shardizard==$spanishShard
    event.respond 'Este canal ahora está marcado como seguro para enviar respuestas largas.' if Shardizard==$spanishShard
  elsif Shardizard==$spanishShard
    event << 'No es seguro para mí enviar respuestas largas aquí.'
    event << ''
    event << 'Si desea cambiar eso, pruebe una de las siguientes opciones:'
    event << '- Cambiar el nombre del canal a "bots".'
    event << '- Cambiar el nombre del canal para incluir la palabra "bot" y una de las siguientes palabras: "spam", "command(s)", "channel".'
    event << '- Haga que un moderador del servidor escriba `FEH!spam on` en este canal.'
  else
    event << 'It is not safe for me to send long replies here.'
    event << ''
    event << 'If you wish to change that, try one of the following:'
    event << '- Change the channel name to "bots".'
    event << '- Change the channel name to include the word "bot" and one of the following words: "spam", "command(s)", "channel".'
    event << '- Have a server mod type `FEH!spam on` in this channel.'
  end
end

bot.command(:channellist, aliases: [:chanelist,:spamchannels,:spamlist]) do |event|
  if event.server.nil?
    event.respond "Yes, it is safe to spam here."
    return nil
  end
  sfe=[[],[]]
  for i in 0...event.server.channels.length
    chn=event.server.channels[i]
    if safe_to_spam?(event,chn)
      sfe[0].push(chn.mention)
    end
  end
  event << '__**All long replies are safe**__'
  event << sfe[0].join("\n")
  event << 'In PM with any user'
end

bot.command(:update) do |event|
  return nil if overlap_prevent(event)
  data_load(['library'])
  update_howto(event,bot)
end

bot.command(:sendpm, from: 167657750971547648) do |event, user_id, *args| # sends a PM to a specific user
  return nil if overlap_prevent(event)
  dev_pm(bot,event,user_id)
end

bot.command(:ignoreuser, from: 167657750971547648) do |event, user_id| # causes Elise to ignore the specified user
  return nil if overlap_prevent(event)
  bliss_mode(bot,event,user_id)
end

bot.command(:sendmessage, from: 167657750971547648) do |event, channel_id, *args| # sends a message to a specific channel
  return nil if overlap_prevent(event)
  dev_message(bot,event,channel_id)
end

bot.command(:leaveserver, from: 167657750971547648) do |event, server_id| # forces Elise to leave a server
  return nil if overlap_prevent(event)
  walk_away(bot,event,server_id)
end

bot.command(:cleanupaliases, from: 167657750971547648) do |event|
  return nil if overlap_prevent(event)
  event.channel.send_temporary_message('Please wait...',10) rescue nil
  if Shardizard==4
    event.respond 'This command cannot be used by the debug version of me.  Please run this command in another server.'
    return nil
  elsif Shardizard==-1
    event.respond 'This command cannot be used by the smol version of me.  Please run this command in another server.'
    return nil
  end
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  nicknames_load()
  nmz=@aliases.map{|q| q}
  k=0
  for i in 0...nmz.length
    unless nmz[i][3].nil?
      for i2 in 0...nmz[i][3].length
        unless [285663217261477889,393775173095915521,295686580528742420].include?(nmz[i][3][i2])
          srv=(bot.server(nmz[i][3][i2]) rescue nil)
          if srv.nil? || bot.user(312451658908958721).on(srv.id).nil?
            k+=1
            nmz[i][3][i2]=nil
          end
        end
      end
      nmz[i][3].compact!
      nmz[i]=nil if nmz[i][3].length<=0
    end
  end
  nmz.compact!
  nmz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
  open("#{$location}devkit/FEHNames.txt", 'w') { |f|
    for i in 0...nmz.length
      f.puts "#{nmz[i].to_s}#{"\n" if i<nmz.length-1}"
    end
  }
  event.respond "#{k} aliases were removed due to being from servers I'm no longer in."
end

bot.command(:backup, from: 167657750971547648) do |event, trigger|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 || event.channel.id==386658080257212417
  if trigger.nil?
    event.respond 'Backup what?'
  elsif ['aliases','alias'].include?(trigger.downcase)
    nicknames_load()
    $aliases.uniq!
    $aliases.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
    if !$aliases[-1][2].is_a?(String) || $aliases[-1][2]<'Verdant Shard'
      event.respond 'Alias list has __***NOT***__ been backed up, as alias list has been corrupted.'
      return nil
    end
    nzzzzz=$aliases.map{|a| a}
    open("#{$location}devkit/FEHNames2.txt", 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event.respond 'Alias list has been backed up.'
  elsif ['groups','group'].include?(trigger.downcase)
    groups_load()
    nzzzzz=$groups.map{|q| [q.name, q.units, q.fake].compact}
    open("#{$location}devkit/FEHGroups2.txt", 'w') { |f|
      for i in 0...nzzzzz.length
        f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
      end
    }
    event.respond 'Groups list has been backed up.'
  else
    event.respond 'Backup what?'
  end
  return nil
end

bot.command(:setmarker, from: 167657750971547648) do |event, letter|
  return nil if overlap_prevent(event)
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  return nil if event.server.nil?
  return nil if letter.nil?
  letter=letter[0,1].upcase
  metadata_load()
  if letter=='X'
    $x_markers=[] if $x_markers.nil?
    if $x_markers.include?(event.server.id)
      event.respond 'This server can already see entries marked with X.'
      return nil
    end
    $x_markers.push(event.server.id)
  else
    for i in 0...$server_markers.length
      if $server_markers[i][0].downcase==letter.downcase
        event.respond "#{letter} is already another server's marker."
        return nil
      elsif $server_markers[i][1]==event.server.id
        event.respond "This server already has a marker: #{$server_markers[i][0]}"
        return nil
      end
    end
    $server_markers.push([letter, event.server.id])
  end
  metadata_save()
  event.respond "This server's marker has been set as #{letter}." unless letter=='X'
  event.respond "This server has been added to those that can see entries marked with #{letter}." if letter=='X'
end

bot.command(:reload, from: 167657750971547648) do |event|
  return nil if overlap_prevent(event)
  return nil unless [167657750971547648].include?(event.user.id) || [285663217261477889,386658080257212417].include?(event.channel.id)
  event.respond "Reload what?\n1.) Aliases, from backups#{' (unless includes the word "git")' if [167657750971547648].include?(event.user.id)}\n2.) Groups, from backups#{" (unless includes the word \"git\")\n3.) Data, from GitHub (include \"subset\" in your message to also reload FEHSkillSubsets)\n4.) Source code, from GitHub (include the word \"all\" to also reload rot8er_functs.rb)\n5.) Crossover data\n6.) Libraries, from code\n7.) Avatars, from GitHub" if event.user.id==167657750971547648}\nYou can include multiple numbers to load multiple things."
  event.channel.await(:bob, from: event.user.id) do |e|
    reload=false
    if e.message.text.include?('1')                                                 # Aliases
      if e.message.text.downcase.include?('git') && [167657750971547648].include?(event.user.id)
        download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHNames.txt")
        IO.copy_stream(download, "FEHTemp.txt")
        if File.size("FEHTemp.txt")>100
          b=[]
          File.open("FEHTemp.txt").each_line.with_index do |line, idx|
            b.push(line)
          end
          open("FEHNames.txt", 'w') { |f|
            f.puts b.join('')
          }
          open("FEHNames2.txt", 'w') { |f|
            f.puts b.join('')
          }
        end
        e.respond 'Alias list has been restored from GitHub, and placed in the backup as well.'
        reload=true
      else
        if File.exist?("#{$location}devkit/FEHNames2.txt")
          b=[]
          File.open("#{$location}devkit/FEHNames2.txt").each_line do |line|
            b.push(eval line)
          end
        else
          b=[]
        end
        nzzzzz=b.uniq
        if !nzzzzz[-1][2].is_a?(String) || nzzzzz[-1][2]<'Verdant Shard'
          event << 'Last backup of the alias list has been corrupted.  Restoring from manually-created backup.'
          if File.exist?("#{$location}devkit/FEHNames3.txt")
            b=[]
            File.open("#{$location}devkit/FEHNames3.txt").each_line do |line|
              b.push(eval line)
            end
          else
            b=[]
          end
          nzzzzz=b.uniq
        else
          e.respond 'Last backup of the alias list being used.'
        end
        nzzzzz.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
        open("#{$location}devkit/FEHNames.txt", 'w') { |f|
          for i in 0...nzzzzz.length
            f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
          end
        }
        e.respond 'Alias list has been restored from backup.'
        reload=true
      end
    end
    if e.message.text.include?('2')                                                 # Groups
      if e.message.text.include?('git') && [167657750971547648].include?(event.user.id)
        download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHGroups.txt")
        IO.copy_stream(download, "FEHTemp.txt")
        if File.size("FEHTemp.txt")>100
          b=[]
          File.open("FEHTemp.txt").each_line.with_index do |line, idx|
            b.push(line)
          end
          open("FEHGroups.txt", 'w') { |f|
            f.puts b.join('')
          }
          open("FEHGroups2.txt", 'w') { |f|
            f.puts b.join('')
          }
        end
        e.respond 'Group list has been restored from GitHub, and placed in the backup as well.'
        reload=true
      else
        if File.exist?("#{$location}devkit/FEHGroups2.txt")
          b=[]
          File.open("#{$location}devkit/FEHGroups2.txt").each_line do |line|
            b.push(eval line)
          end
        else
          b=[]
        end
        nzzzzz=b.uniq
        if nzzzzz.length<10
          e.respond 'Last backup of the group list has been corrupted.  Restoring from manually-created backup.'
          if File.exist?("#{$location}devkit/FEHGroups3.txt")
            b=[]
            File.open("#{$location}devkit/FEHGroups3.txt").each_line do |line|
              b.push(eval line)
            end
          else
            b=[]
          end
          nzzzzz=b.uniq
        else
          e.respond 'Last backup of the group list being used.'
        end
        open("#{$location}devkit/FEHGroups.txt", 'w') { |f|
          for i in 0...nzzzzz.length
            f.puts "#{nzzzzz[i].to_s}#{"\n" if i<nzzzzz.length-1}"
          end
        }
        e.respond 'Group list has been restored from backup.'
        reload=true
      end
    end
    if e.message.text.include?('3') && [167657750971547648].include?(event.user.id) # Data
      event.channel.send_temporary_message('Loading.  Please wait 5 seconds...',3) rescue nil
      to_reload=['Units','Skills','Accessories','Structures','Items','StatSkills','SkillSubsets','Banners','Events','Games','ArenaTempest','Path']
      for i in 0...to_reload.length
        download = (open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEH#{to_reload[i]}.txt") rescue nil)
        unless download.nil?
          IO.copy_stream(download, "FEHTemp.txt")
          if to_reload[i]=='SkillSubsets' && File.size("FEHTemp.txt")<File.size("FEHSkillSubsets.txt") && !e.message.text.downcase.include?('subset')
          elsif File.size("FEHTemp.txt")>100
            b=[]
            File.open("FEHTemp.txt").each_line.with_index do |line, idx|
              b.push(line)
            end
            open("FEH#{to_reload[i]}.txt", 'w') { |f|
              f.puts b.join('')
            }
          end
        end
      end
      strx="#{strx}#{"\n" if strx.length>0}FEHSkillSubsets also reloaded\n" if e.message.text.include?('subset')
      e.respond "New data loaded.\n#{strx}Now creating aliases for new units and skills..."
      data_load()
      nicknames_load()
      n=$aliases.map{|q| q}
      u=$units.map{|q| q}
      s=$skills.map{|q| q}
      for i in 0...u.length
        n.push(["Unit", u[i].name, u[i].id])
        n.push(["Unit", u[i].name.gsub('(','').gsub(')','').gsub(' ','').gsub('_',''), u[i].id])
      end
      for i in 0...s.length
        if ['Weapon','Assist','Special'].include?(s[i][6]) || ['-','example'].include?(s[i].level)
          n.push(["Skill", s[i].name, s[i].id])
          n.push(["Skill", s[i].name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('/','').gsub('!','').gsub('?',''), s[i].id])
        elsif s[i].name[-1]=='+'
          n.push(["Skill", "#{s[i].name}#{s[i].level}", s[i].id])
          n.push(["Skill", "#{s[i].name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('/','').gsub('!','').gsub('?','')}#{s[i].level}", s[i].id])
        else
          n.push(["Skill", "#{s[i].name} #{s[i].level}", s[i].id])
          n.push(["Skill", "#{s[i].name.gsub('(','').gsub(')','').gsub(' ','').gsub('_','').gsub('/','').gsub('!','').gsub('?','')} #{s[i].level}", s[i].id])
        end
      end
      n.sort! {|a,b| (spaceship_order(a[0]) <=> spaceship_order(b[0])) == 0 ? (supersort(a,b,2,nil,1) == 0 ? (a[1].downcase <=> b[1].downcase) : supersort(a,b,2,nil,1)) : (spaceship_order(a[0]) <=> spaceship_order(b[0]))}
      open("#{$location}devkit/FEHNames.txt", 'w') { |f|
        for i in 0...n.length
          f.puts "#{n[i].to_s}#{"\n" if i<n.length-1}"
        end
      }
      nicknames_load()
      nzzz=@aliases.map{|q| q}
      if nzzz[-1].length>1 && nzzz[-1][2].is_a?(String) && nzzz[-1][2]>='Verdant Shard'
        e.respond 'Alias list saved.'
        open("#{$location}devkit/FEHNames2.txt", 'w') { |f|
          for i in 0...nzzz.length
            f.puts "#{nzzz[i].to_s}"
          end
        }
        e.respond 'Alias list has been backed up.'
      end
      reload=true
    end
    if e.message.text.include?('4') && [167657750971547648].include?(event.user.id) # Source Code
      download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/PriscillaBot.rb")
      IO.copy_stream(download, "FEHTemp.txt")
      if File.size("FEHTemp.txt")>100
        if File.exist?("#{$location}devkit/BotTokens.txt")
          b2=[]
          File.open("#{$location}devkit/BotTokens.txt").each_line do |line|
            b2.push(line.split(' # ')[0])
          end
        else
          b2=[]
        end
        if b2.length>0
          b=[]
          File.open("FEHTemp.txt").each_line.with_index do |line, idx|
            if idx<200
              b.push(line.gsub('>Main Token<',b2[1]).gsub('>Spanish Token<',b2[-3]).gsub('>Smol Token<',b2[-2]).gsub('>Debug Token<',b2[-1]))
            else
              b.push(line)
            end
          end
          open("PriscillaBot.rb", 'w') { |f|
            f.puts b.join('')
          }
          e.respond 'New source code loaded.'
          reload=true
        end
      end
      puts 'reloading EliseClassFunctions'
      download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/EliseClassFunctions.rb")
      IO.copy_stream(download, "FEHTemp.txt")
      str=''
      if File.size("FEHTemp.txt")>100
        b=[]
        File.open("FEHTemp.txt").each_line.with_index do |line, idx|
          b.push(line)
        end
        open("EliseClassFunctions.rb", 'w') { |f|
          f.puts b.join('')
        }
        str="#{str}\nEliseClassFunctions loaded."
        reload=true
      end
      puts 'reloading Elispanol'
      download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/Elisepanol.rb")
      IO.copy_stream(download, "FEHTemp.txt")
      str=''
      if File.size("FEHTemp.txt")>100
        b=[]
        File.open("FEHTemp.txt").each_line.with_index do |line, idx|
          b.push(line)
        end
        open("Elisepanol.rb", 'w') { |f|
          f.puts b.join('')
        }
        str="#{str}\nElisepanol loaded."
        reload=true
      end
      download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/rot8er_functs.rb")
      IO.copy_stream(download, "FEHTemp.txt")
      if File.size("FEHTemp.txt")>100 && e.message.text.include?('all')
        b=[]
        File.open("FEHTemp.txt").each_line.with_index do |line, idx|
          b.push(line.gsub('Mini-Matt',@mash))
        end
        open("rot8er_functs.rb", 'w') { |f|
          f.puts b.join('')
        }
        str="#{str}\nrot8er_functs loaded."
        reload=true
      end
      t=Time.now
      $last_multi_reload[0]=t
      $last_multi_reload[1]=t
      e.respond str
      reload=true
    end
    if e.message.text.include?('5') && [167657750971547648].include?(event.user.id) # Crossdata
      to_reload=['Adventurers','Dragons','Wyrmprints']
      for i in 0...to_reload.length
        download = open("https://raw.githubusercontent.com/Rot8erConeX/BotanBot/master/DL#{to_reload[i]}.txt")
        IO.copy_stream(download, "DLTemp.txt")
        if File.size("DLTemp.txt")>100
          b=[]
          File.open("DLTemp.txt").each_line.with_index do |line, idx|
            b.push(line)
          end
          open("DL#{to_reload[i]}.txt", 'w') { |f|
            f.puts b.join('')
          }
        end
      end
      e.respond "New cross-data loaded."
      reload=true
    end
    if e.message.text.include?('6') && [167657750971547648].include?(event.user.id) # Library
      puts 'reloading EliseClassFunctions'
      load "#{$location}devkit/EliseClassFunctions.rb"
      unless !$spanishShard.nil? && Shardizard != $spanishShard && !has_any?(e.message.text.downcase.split(' '),['spanish','espanol'])
        puts 'reloading Elispanol'
        load "#{$location}devkit/Elispanol.rb"
      end
      t=Time.now
      $last_multi_reload[0]=t
      e.respond 'Libraries force-reloaded'
      reload=true
    end
    if e.message.text.include?('7') && [167657750971547648].include?(event.user.id) # Avatars
      download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHDonorList.txt")
      IO.copy_stream(download, "FEHTemp.txt")
      if File.size("FEHTemp.txt")>100
        b=[]
        File.open("FEHTemp.txt").each_line.with_index do |line, idx|
          b.push(line)
        end
        open("FEHDonorList.txt", 'w') { |f|
          f.puts b.join('')
        }
      end
      download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/FEHBotArtList.txt")
      IO.copy_stream(download, "FEHTemp.txt")
      x=[]
      if File.size("FEHTemp.txt")>100
        b=[]
        File.open("FEHTemp.txt").each_line.with_index do |line, idx|
          b.push(line)
        end
        x=b[0].gsub("\n",'').split('\\'[0])
        for i in 0...x.length
          download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/EliseImages/#{x[i]}.png")
          IO.copy_stream(download, "FEHTemp#{@shardizard}.png")
          if File.size("FEHTemp#{Shardizard}.png")>100
            download = open("https://raw.githubusercontent.com/Rot8erConeX/EliseBot/master/EliseBot/EliseImages/#{x[i]}.png")
            IO.copy_stream(download, "EliseImages/#{x[i]}.png")
          end
        end
      end
      e.respond 'Avatars reloaded'
      reload=true
    end
    e.respond 'Nothing reloaded.  If you meant to use the command, please try it again.' unless reload
  end
  return nil
end

bot.command(:devedit, aliases: [:dev_edit], from: 167657750971547648) do |event, cmd, *args|
  return nil if overlap_prevent(event)
  event.respond "This command is to allow the developer to edit his units.  Your version of the command is `FEH!edit`" if File.exist?("#{$location}devkit/EliseUserSaves/#{event.user.id}.txt")
  return nil unless event.user.id==167657750971547648 # only work when used by the developer
  data_load(['library'])
  dev_edit(bot,event,args,cmd)
end

bot.command(:edit) do |event, cmd, *args|
  return nil if overlap_prevent(event)
  data_load(['library'])
  donor_edit(bot,event,args,cmd)
end

bot.command(:snagstats) do |event, f, f2|
  return nil if overlap_prevent(event)
  data_load(['library'])
  snagstats(event,bot,f,f2)
end

bot.command(:boop) do |event, nme|
  return nil if overlap_prevent(event)
  event.respond 'boop' if Shardizard==4
  return nil
end

bot.server_create do |event|
  chn=event.server.general_channel
  if chn.nil?
    chnn=[]
    for i in 0...event.server.channels.length
      chnn.push(event.server.channels[i]) if bot.user(bot.profile.id).on(event.server.id).permission?(:send_messages,event.server.channels[i]) && event.server.channels[i].type.zero?
    end
    chn=chnn[0] if chnn.length>0
  end
  if ![285663217261477889,443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,691616574393811004,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,620710758841450529,572792502159933440].include?(event.server.id) && Shardizard==4
    (chn.send_message(get_debug_leave_message()) rescue nil)
    event.server.leave
  else
    bot.user(167657750971547648).pm("Joined server **#{event.server.name}** (#{event.server.id})\nOwner: #{event.server.owner.distinct} (#{event.server.owner.id})#{"\nAssigned to use #{shard_data(0,true)[(event.server.id >> 22) % Shards]} Shards" unless Shardizard<0}")
    metadata_load()
    @server_data[0][((event.server.id >> 22) % Shards)] += 1
    metadata_save()
    chn.send_message("<a:zeldawave:464974581434679296> I'm here to deliver the happiest of hellos - as well as data for heroes and skills in *Fire Emblem: Heroes*!  So, here I am!  Summon me with messages that start with `FEH!`.") rescue nil
  end
end

bot.server_delete do |event|
  unless Shardizard==4
    bot.user(167657750971547648).pm("Left server **#{event.server.name}**#{"\nThis server was using #{shard_data(0,true)[((event.server.id >> 22) % Shards)]} Shards" unless Shardizard<0}")
    metadata_load()
    @server_data[0][((event.server.id >> 22) % Shards)] -= 1
    metadata_save()
  end
end

bot.message do |event|
  str=event.message.text.downcase
  load "#{$location}devkit/FEHPrefix.rb"
  if Shardizard==4 && (['fea!','fef!','fea?','fef?'].include?(str[0,4]) || ['fe13!','fe14!','fe13?','fe14?'].include?(str[0,5]) || ['fe!','fe?'].include?(str[0,3])) && (event.server.nil? || event.server.id==285663217261477889)
    str=str[4,str.length-4] if ['fea!','fef!','fea?','fef?'].include?(str[0,4])
    str=str[5,str.length-5] if ['fe13!','fe14!','fe13?','fe14?'].include?(str[0,5])
    str=str[3,str.length-3] if ['fe!','fe?'].include?(str[0,3])
    a=str.split(' ')
    if a[0].downcase=='reboot'
      event.respond 'Becoming Robin.  Please wait approximately ten seconds...'
      exec "cd #{$location}devkit && RobinBot.rb 4"
    elsif event.server.nil? || event.server.id==285663217261477889
      event.respond 'I am not Robin right now.  Please use `FE!reboot` to turn me into Robin.'
    end
  elsif (['fgo!','fgo?','liz!','liz?'].include?(str[0,4]) || ['fate!','fate?'].include?(str[0,5])) && Shardizard==4 && (event.server.nil? || event.server.id==285663217261477889)
    s=event.message.text.downcase
    s=s[5,s.length-5] if ['fate!','fate?'].include?(event.message.text.downcase[0,5])
    s=s[4,s.length-4] if ['fgo!','fgo?','liz!','liz?'].include?(event.message.text.downcase[0,4])
    a=s.split(' ')
    if a[0].downcase=='reboot'
      event.respond "Becoming Liz.  Please wait approximately ten seconds..."
      exec "cd #{$location}devkit && LizBot.rb 4"
    elsif event.server.nil? || event.server.id==285663217261477889
      event.respond "I am not Liz right now.  Please use `FGO!reboot` to turn me into Liz."
    end
  elsif ['dl!','dl?'].include?(str[0,3]) && Shardizard==4 && (event.server.nil? || event.server.id==285663217261477889)
    s=event.message.text.downcase
    s=s[3,s.length-3]
    a=s.split(' ')
    if a[0].downcase=='reboot'
      event.respond "Becoming Botan.  Please wait approximately ten seconds..."
      exec "cd #{$location}devkit && BotanBot.rb 4"
    elsif event.server.nil? || event.server.id==285663217261477889
      event.respond "I am not Botan right now.  Please use `DL!reboot` to turn me into Botan."
    end
  elsif (['!weak '].include?(str[0,6]) || ['!weakness '].include?(str[0,10]))
    puts str
    if event.server.nil? || event.server.id==264445053596991498
    elsif !bot.user(304652483299377182).on(event.server.id).nil? # Robin
    elsif !bot.user(543373018303299585).on(event.server.id).nil? # Botan
    elsif !bot.user(502288364838322176).on(event.server.id).nil? # Liz
    elsif !bot.user(206147275775279104).on(event.server.id).nil? || Shardizard==4 || event.server.id==330850148261298176 # Pokedex
      triple_weakness(bot,event)
    end
  elsif overlap_prevent(event)
  elsif ['f?','e?','h?'].include?(event.message.text.downcase[0,2]) || ['feh!','feh?'].include?(event.message.text.downcase[0,4]) || (!event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0 && @prefixes[event.server.id].downcase==event.message.text.downcase[0,@prefixes[event.server.id].length])
    puts event.message.text
    s=event.message.text.downcase
    s=remove_prefix(s,event)
    s=s[1,s.length-1] if s[0,1]==' '
    s=s[2,s.length-2] if s[0,2]=='5*'
    a=s.split(' ')
    if a[0].downcase=='reboot' && event.user.id==167657750971547648
      exec "cd #{$location}devkit && PriscillaBot.rb #{Shardizard}"
    elsif ['laevatein','naga','sirius','fury','forseti'].include?(s.gsub(' ','').downcase)
      s=s.gsub(' ','').downcase
      s="#{s[0].upcase}#{s[1,s.length-1].downcase}"
      s2="#{s}"
      s2='Erinys' if s2=='Fury'
      disp_unit_stats(bot,event,s2,nil,'smol',true) unless find_unit(event,a,s2,bot,true).nil?
      disp_skill_data(bot,event,s)
    elsif s.gsub(' ','').gsub('?','').gsub('!','').length<2
    elsif !all_commands(true).include?(a[0]) && Shardizard==$spanishShard
      spanish_commands(bot,event,a)
    elsif !all_commands(true).include?(a[0])
      a=sever(a.join(' ')).split(' ')
      find_best_match(event,a,nil,bot)
    end
  elsif !event.server.nil? && (above_memes().include?("s#{event.server.id}") || above_memes().include?(event.server.id))
  elsif !event.channel.nil? && above_memes().include?("c#{event.channel.id}")
  elsif above_memes().include?("u#{event.user.id}") || above_memes().include?(event.user.id)
  elsif event.message.text.downcase.include?('kys') && !event.user.bot_account?
    s=event.message.text
    s=remove_format(s,'```')              # remove large code blocks
    s=remove_format(s,'`')                # remove small code blocks
    s=remove_format(s,'~~')               # remove crossed-out text
    s=remove_format(s,'||')               # remove spoiler tags
    s=s.gsub("\n",' ').gsub("  ",'')
    if s.split(' ').include?('kys') || s.split(' ').include?('KYS')
      if rand(1000)<13
        puts 'responded to KYS'
        event.respond "You're going down, scumbag!" unless Shardizard==$spanishShard
        event.respond "¡Vas a caer, cabrón!" if Shardizard==$spanishShard
      else
        puts 'saw KYS, did not respond'
      end
    end
  elsif event.message.text.include?('0x4') && !event.user.bot_account?
    s=event.message.text
    s=remove_format(s,'```')              # remove large code blocks
    s=remove_format(s,'`')                # remove small code blocks
    s=remove_format(s,'~~')               # remove crossed-out text
    s=remove_format(s,'||')               # remove spoiler tags
    s=s.gsub("\n",' ').gsub("  ",'')
    if s.split(' ').include?('0x4')
      puts s
      event.respond "#{"#{event.user.mention} " unless event.server.nil?}#{["Be sure to use Galeforce for 0x8.  #{['','Pair it with a Breath skill to get 0x8 even faster.'].sample}",'Be sure to include Astra to increase damage by 150%.',"If you're using an archer, use Deadeye to increase damage by 200% or more!",'Be sure to use a dancer for 0x8.',"Be sure to use Sol, so you can heal for half of that.  #{['','Peck, Ephraim(Fire) heals for 80% with his Solar Brace.','Pair it with a Breath skill to get even more healing!'].sample}","#{['Be sure to use Galeforce for 0x8.','Be sure to use a dancer for 0x8.'].sample}  Or combine a dancer and Galeforce for a whopping 0x12!"].sample}" unless Shardizard==$spanishShard
      event.respond "#{"#{event.user.mention} " unless event.server.nil?}#{["Asegúrese de usar Asalto Impetuoso para 0x8.  #{['','Combínalo con una habilidad de Soplo para obtener 0x8 aún más rápido.'].sample}",'Asegúrese de incluir Astrea para aumentar el daño en un 150%.',"Si estás usando un arquero, usa Ojo letal para aumentar el daño en un 200% o más.",'Asegúrese de usar un dancer para 0x8.',"Asegúrese de usar Helios, para que pueda curar la mitad de eso.  #{['','Peck, Ephraim(Fire) cura un 80% con su Brazalete Solar.','¡Combínalo con una habilidad de Soplo para obtener aún más curación!'].sample}","#{['Asegúrese de utilizar Asalto Impetuoso para 0x8.','Asegúrese de usar un dancer para 0x8.'].sample}  ¡O combina un dancer y un Asalto Impetuoso para obtener 0x12!"].sample}" if Shardizard==$spanishShard
    end
  end
end

bot.mention do |event|
  data_load(['everything'])
  puts event.message.text
  s=event.message.text.downcase
  args=s.split(' ')
  args=args.reject{ |a| a.match(/<@!?(?:\d+)>/) }
  args=sever(args.join(' ')).split(' ')
  s=args.join(' ')
  k=-1
  k=1 if event.user.bot_account?
  if k>0
  elsif ['f?','e?','h?'].include?(event.message.text.downcase[0,2]) || ['feh!','feh?'].include?(event.message.text.downcase[0,4]) || (!event.server.nil? && !@prefixes[event.server.id].nil? && @prefixes[event.server.id].length>0 && @prefixes[event.server.id].downcase==event.message.text.downcase[0,@prefixes[event.server.id].length])
    k=3
  elsif ['help','commands','command_list','commandlist'].include?(args[0].downcase)
    args.shift
    help_text(event,bot,args[0],args[1])
    k=1
  elsif ['today','daily','dailies','now'].include?(args[0].downcase)
    args.shift
    today_in_feh(event,bot)
    k=1
  elsif ['tomorrow','tommorrow','tomorow','tommorow'].include?(args[0].downcase)
    args.shift
    today_in_feh(event,bot,true)
    k=1
  elsif ['next','schedule'].include?(args[0].downcase)
    args.shift
    next_events(bot,event,args)
    k=1
  elsif ['snagstats'].include?(args[0].downcase)
    args.shift
    snagstats(event,bot,args[0],args[1])
    k=1
  elsif ['find','search','lookup'].include?(args[0].downcase)
    args.shift
    display_units_and_skills(bot,event,args)
    k=1
  elsif ['sort','list'].include?(args[0].downcase)
    args.shift
    if ['skill','skil','skills','skils'].include?(args[0].downcase) || (['habilidad','habilidades'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      sort_skills(bot,event,args)
    else
      sort_units(bot,event,args)
    end
    k=1
  elsif ['groups','seegroups','checkgroups'].include?(args[0].downcase)
    disp_groups(event,bot)
    k=1
  elsif ['prf','prfs'].include?(args[0].downcase)
    disp_all_prfs(event,bot)
    k=1
  elsif ['effhp','eff_hp','bulk'].include?(args[0].downcase)
    args.shift
    effHP(bot,event,args)
    k=1
  elsif ['pairup','pair_up','pair','pocket'].include?(args[0].downcase)
    args.shift
    pair_up(bot,event,args)
    k=1
  elsif ['heal','heal_study','healstudy','studyheal','study_heal'].include?(args[0].downcase)
    args.shift
    heal_study(bot,event,args)
    k=1
  elsif ['proc','proc_study','procstudy','studyproc','study_proc'].include?(args[0].downcase)
    args.shift
    proc_study(bot,event,args)
    k=1
  elsif ['phase','phase_study','phasestudy','studyphase','study_phase'].include?(args[0].downcase)
    args.shift
    phase_study(bot,event,args)
    k=1
  elsif ['study'].include?(args[0].downcase)
    args.shift
    if ['effhp','eff_hp','bulk'].include?(args[0].downcase)
      args.shift
      k=effHP(bot,event,args)
    elsif ['pairup','pair_up','pair','pocket'].include?(args[0].downcase) || (['agrupar','agrupa','par','bolsillo'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=pair_up(bot,event,args)
    elsif ['heal'].include?(args[0].downcase)
      args.shift
      k=heal_study(bot,event,args)
    elsif ['proc'].include?(args[0].downcase)
      args.shift
      k=proc_study(bot,event,args)
    elsif ['phase'].include?(args[0].downcase) || (['fase'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      k=phase_study(bot,event,args)
    end
    k=0 if k.nil?
    unit_study(bot,event,args) unless k>0
    k=1
  elsif ['art','artist'].include?(args[0].downcase)
    args.shift
    disp_unit_art(bot,event,args)
    k=1
  elsif ['art','artist'].include?(args[0].downcase)
    args.shift
    path_data(bot,event,args)
    k=1
  elsif ['game','games'].include?(args[0].downcase)
    args.shift
    game_data(bot,event,args)
    k=1
  elsif ['alt','alts'].include?(args[0].downcase)
    args.shift
    find_alts(bot,event,args,1)
    k=1
  elsif ['aliases','seealiases','checkaliases'].include?(args[0].downcase)
    args.shift
    list_aliases(bot,event,args)
    k=1
  elsif ['saliases','serveraliases'].include?(args[0].downcase)
    args.shift
    list_aliases(bot,event,args,1)
    k=1
  elsif ['laevatein','naga','sirius','fury','forseti'].include?(s.gsub(' ','').downcase)
    s=s.gsub(' ','').downcase
    s="#{s[0].upcase}#{s[1,s.length-1].downcase}"
    s2="#{s}"
    s2='Erinys' if s2=='Fury'
    disp_unit_stats(bot,event,s2,nil,'smol',true) unless find_unit(event,args,s2,bot,true).nil?
    disp_skill_data(bot,event,s)
    k=1
  elsif ['unit'].include?(args[0].downcase)
    args.shift
    if ['find','search','lookup'].include?(args[0].downcase) || (['encontra','busca','encontrar','buscar'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      display_units(bot,event,args)
    elsif ['sort','list'].include?(args[0].downcase) || (['clasificar','clasifica','lista','listar'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      sort_units(bot,event,args)
    elsif ['compare','comparison'].include?(args[0].downcase) || (['comparar','compara'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      comparison(bot,event,args)
    elsif ['pairup','pair_up','pair','pocket'].include?(args[0].downcase) || (['agrupar','agrupa','par','bolsillo'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      pair_up(bot,event,args)
    elsif ['fgo'].include?(args[0].downcase) && !find_data_ex(:find_FGO_servant,event,args[1,args.length-1],nil,bot).nil?
      args.shift
      disp_stats_for_FGO(bot,event,args,find_data_ex(:find_FGO_servant,event,args,nil,bot))
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
    k=1
  elsif ['stats','stat','big','tol','macro','large','huge','massive'].include?(args[0].downcase)
    if ['compare','comparison'].include?(args[1].downcase) && ['stats','stat'].include?(args[0].downcase)
      args.shift
      args.shift
      comparison(bot,event,args)
    elsif ['comparar','compara'].include?(args[0].downcase) && Shardizard==$spanishShard && ['stats','stat'].include?(args[0].downcase)
      args.shift
      args.shift
      comparison(bot,event,args)
    elsif ['fgo'].include?(args[0].downcase) && !find_data_ex(:find_FGO_servant,event,args[1,args.length-1],nil,bot).nil?
      args.shift
      disp_stats_for_FGO(bot,event,args,find_data_ex(:find_FGO_servant,event,args,nil,bot))
    elsif ['pairup','pair_up','pair','pocket'].include?(args[0].downcase) || (['agrupar','agrupa','par','bolsillo'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      pair_up(bot,event,args)
    else
      size='smol'
      size='medium' if ['big','tol','macro','large'].include?(args[0].downcase) || (['grande'].include?(args[0].downcase) && Shardizard==$spanishShard)
      size='giant' if ['huge','massive'].include?(args[0].downcase) || (['enorme'].include?(args[0].downcase) && Shardizard==$spanishShard)
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
    k=1
  elsif ['smol','small','tiny','little','squashed'].include?(args[0].downcase)
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
    k=1
  elsif ['skills','skils','fodder','manual','book','combatmanual'].include?(args[0].downcase)
    aa=args[0].downcase
    args.shift
    if ['find','search','lookup'].include?(args[0].downcase) || (['encontra','busca','encontrar','buscar'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      display_skills(bot,event,args)
    elsif ['sort','list'].include?(args[0].downcase) || (['clasificar','clasifica','lista','listar'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      sort_skills(bot,event,args)
    elsif ['compare','comparison'].include?(args[0].downcase) || (['comparar','compara'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      skill_comparison(bot,event,args)
    else
      x=find_data_ex(:find_unit,event,args,nil,bot)
      if x.nil? && Shardizard==$spanishShard
        event.respond "No hay coincidencia.  #{"Si está buscando datos sobre las habilidades que aprende un personaje en particular, intente ```#{first_sub(event.message.text,'habilidades','habilidad')}```, sin la s." if s.downcase[0,11]=='habilidades'}"
      elsif x.nil?
        event.respond "No matches found.  #{"If you are looking for data on a particular skill, try ```#{first_sub(event.message.text,'skills','skill')}```, without the s." if aa=='skills'}"
      elsif x.is_a?(Array)
        disp_unit_skills(bot,event,x.map{|q| q.name}.name)
      else
        disp_unit_skills(bot,event,x.name)
      end
    end
    k=1
  elsif ['skill','skil'].include?(args[0].downcase)
    args.shift
    if ['find','search','lookup'].include?(args[0].downcase) || (['encontra','busca','encontrar','buscar'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      display_skills(bot,event,args)
    elsif ['sort','list'].include?(args[0].downcase) || (['clasificar','clasifica','lista','listar'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      sort_skills(bot,event,args)
    elsif ['compare','comparison'].include?(args[0].downcase) || (['comparar','compara'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      skill_comparison(bot,event,args)
    else
      x=find_data_ex(:find_skill,event,args,nil,bot)
      if x.nil? && Shardizard==$spanishShard
        event.respond "No hay coincidencias.  Si está buscando datos sobre las habilidades que aprende un personaje en particular, intente ```#{event.message.text.downcase.gsub('habilidad','habilidades')}``` en su lugar."
      elsif x.nil?
        event.respond "No matches found.  If you are looking for data on the skills a character learns, try ```#{first_sub(event.message.text,'skill','skills',1)}```, with an s."
      else
        disp_skill_data(bot,event,x.name)
      end
    end
    k=1
  elsif ['compare','comparison'].include?(args[0].downcase)
    args.shift
    if ['skill','skil','skills','skils'].include?(args[0].downcase) || (['habilidad','habilidades'].include?(args[0].downcase) && Shardizard==$spanishShard)
      args.shift
      skill_comparison(bot,event,args)
    else
      comparison(bot,event,args)
    end
    k=1
  elsif ['bst'].include?(args[0].downcase)
    args.shift
    combined_BST(bot,event,args)
    k=1
  elsif ['structure','struct'].include?(args[0].downcase)
    args.shift
    disp_struct(bot,args.join(' '),event)
    k=1
  elsif ['item'].include?(args[0].downcase)
    args.shift
    disp_itemu(bot,args.join(' '),event)
    k=1
  elsif ['accessory','accessorie','acc'].include?(args[0].downcase)
    args.shift
    disp_accessory(bot,args.join(' '),event)
    k=1
  elsif ['color','colors','colour','colours','colores'].include?(args[0].downcase)
    args.shift
    x=find_data_ex(:find_skill,event,args,nil,bot)
    if x.nil?
      event.respond nomf()
    else
      disp_skill_data(bot,event,x.name,true)
    end
    k=1
  elsif ['legendary','legendaries','legendarys','legend','legends'].include?(args[0].downcase)
    disp_legendary_list(bot,event,args,'Legendary')
    k=1
  elsif ['mythic','mythical','mythics','mythicals','mystic','mystical','mystics','mysticals'].include?(args[0].downcase)
    disp_legendary_list(bot,event,args,'Mythic')
    k=1
  elsif ['aoe','area'].include?(args[0].downcase)
    aoe(event,bot,args)
    k=1
  elsif ['average','mean'].include?(args[0].downcase)
    stats_of_multiunits(bot,event,args,0)
    k=1
  elsif ['bestamong','bestin','beststats','higheststats','highest','best','highestamong','highestin'].include?(args[0].downcase)
    stats_of_multiunits(bot,event,args,1)
    k=1
  elsif ['worstamong','worstin','worststats','loweststats','lowest','worst','lowestamong','lowestin'].include?(args[0].downcase)
    stats_of_multiunits(bot,event,args,-1)
    k=1
  elsif ['bonus'].include?(args[0].downcase)
    args.shift
    x=[]
    x.push('Arena') if args.include?('arena')
    x.push('Tempest') if has_any?(args,['tempest','tt'])
    x.push('Aether') if has_any?(args,['aether','raid','raids','aetherraids','aetherraid','aether_raids','aether_raid','aetheraids','aetheraid'])
    x.push('Resonant') if has_any?(args,['resonant','resonance','resonence'])
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
    k=1
  elsif ['arena'].include?(args[0].downcase)
    show_bonus_units(event,['Arena'],bot)
    k=1
  elsif ['tempest','tt'].include?(args[0].downcase)
    show_bonus_units(event,['Tempest'],bot)
    k=1
  elsif ['aether','raid','raids','aetherraids','aetherraid','aether_raids','aether_raid','aetheraids','aetheraid'].include?(args[0].downcase)
    show_bonus_units(event,['Aether'],bot)
    k=1
  elsif ['resonant','resonance','resonence'].include?(args[0].downcase)
    show_bonus_units(event,['Resonant'],bot)
    k=1
  elsif ['headpat','pat','patpat'].include?(args[0].downcase)
    headpat(event,bot)
    k=1
  elsif ['flower','flowers'].include?(args[0].downcase)
    flower_array(event,bot)
    k=1
  elsif Shardizard==$spanishShard
    spanish_commands(bot,event,args)
    k=1
  end
  find_best_match(event,args,nil,bot) if k<0
end

def next_holiday(bot,mode=0)
  t=Time.now
  t-=60*60*6
  puts 'reloading EliseClassFunctions'
  load "#{$location}devkit/EliseClassFunctions.rb"
  $last_multi_reload[1]=t
  holidays=[[0,1,1,'Tiki(Young)','as Babby New Year',"New Year's Day"],
            [0,2,2,'Feh','the best gacha game ever!','Game Release Anniversary'],
            [0,2,14,'Cordelia(Bride)','with your heartstrings.',"Valentine's Day"],
            [0,4,1,'Priscilla','tribute to Xander for making this possible.',"April Fool's Day"],
            [0,4,24,'Sakura(BDay)','dressup as my best friend.',"Coder's birthday"],
            [0,4,29,'Anna',"with all the money you're giving me",'Golden Week'],
            [0,5,10,'Felicia(Maid)','errand-girl for Master','Maid Day'],
            [0,7,4,'Arthur','for freedom and justice.','Independance Day'],
            [0,7,20,'Celica(Fallen)','in the darkest timeline',"...let's just say that this is a sad day for my dev"],
            [0,10,31,'Henry(Halloween)','with a dead Emblian. Nyahaha!','Halloween'],
            [0,12,25,'Robin(M)(Christmas)','as Santa Claus for Askr.','Christmas'],
            [0,12,31,'Tiki(Adult)','as Mother Time',"New Year's Eve"]]
  d=get_donor_list().reject{|q| q[2][0]<3 || q[4][0]=='-'}
  for i in 0...d.length
    if d[i][4][0]!='-'
      holidays.push([0,d[i][3][0],d[i][3][1],d[i][4][0],"in recognition of contributions provided by #{bot.user(d[i][0]).distinct}","Donator's birthday"])
      holidays[-1][5]="Donator's Day" if d[i][0]==189235935563481088
    end
  end
  for i in 0...holidays.length
    if t.month>holidays[i][1] || (t.month==holidays[i][1] && t.day>holidays[i][2])
      holidays[i][0]=t.year+1
    else
      holidays[i][0]=t.year
    end
  end
  e=calc_easter()
  holidays.push([e[0],e[1],e[2],'Whitewings(Bunny)','with your expectations on where we hid the eggs.','Easter'])
  t=Time.now
  t-=60*60*6
  y8=t.year
  j8=Time.new(y8,6,8)
  fsij=8-j8.wday
  fsij-=7 if j8.sunday?
  fd=fsij+14
  if (t.month==6 && t.day>fd) || t.month>6
    y8+=1
    j8=Time.new(y8,6,8)
    fsij=8-j8.wday
    fsij-=7 if j8.sunday?
    fd=fsij+14
  end
  holidays.push([y8,6,fd,'Ike(Brave)',"with my father's keepsake, Urvan.","Father's Day"])
  t=Time.now
  t-=60*60*6
  y8=t.year
  m8=Time.new(y8,5,8)
  fsim=8-m8.wday
  fsim-=7 if m8.sunday?
  md=fsim+7
  if (t.month==5 && t.day>md) || t.month>5
    y8+=1
    m8=Time.new(y8,5,8)
    fsim=8-m8.wday
    fsim-=7 if m8.sunday?
    md=fsim+14
  end
  holidays.push([y8,5,md,'Deirdre','favorites.',"Mother's Day"])
  holidays.sort! {|a,b| supersort(a,b,0) == 0 ? (supersort(a,b,1) == 0 ? (supersort(a,b,2) == 0 ? (supersort(a,b,6) == 0 ? supersort(a,b,4) : supersort(a,b,6)) : supersort(a,b,2)) : supersort(a,b,1)) : supersort(a,b,0)}
  k=[]
  for i in 0...holidays.length
    k.push(holidays[i]) if holidays[i][0]==holidays[0][0] && holidays[i][1]==holidays[0][1] && holidays[i][2]==holidays[0][2]
  end
  div=[[],
       [[0,0]],
       [[0,0],[12,0]],
       [[0,0],[8,0],[16,0]],
       [[0,0],[6,0],[12,0],[18,0]],
       [[0,0],[4,48],[9,36],[14,24],[19,12]],
       [[0,0],[4,0],[8,0],[12,0],[16,0],[20,0]],
       [[0,0],[3,26],[6,52],[10,17],[13,43],[17,8],[18,34]],
       [[0,0],[3,0],[6,0],[9,0],[12,0],[15,0],[18,0],[21,0]]]
  t=Time.now
  t-=60*60*6
  if t.year==k[0][0] && t.month==k[0][1] && t.day==k[0][2]
    if k.length==1
      # Only one holiday is today.  Display new avatar, and set another check for midnight
      bot.game=k[0][4]
      if Shardizard.zero? || Shardizard==-1
        bot.profile.avatar=(File.open("#{$location}devkit/EliseImages/#{k[0][3]}.png",'r')) rescue nil
      end
      @avvie_info=[k[0][3],k[0][4],k[0][5]]
      t2= Time.now + 18*60*60
      t=Time.now
      @scheduler.at "#{t2.year}/#{t2.month}/#{t2.day} 0000" do
        next_holiday(bot,1)
      end
    else
      # multiple holidays are today.  Change avatar based on time of day, using div as a reference
      fcod=div[k.length][k.length-1]
      if t.hour>fcod[0] || (t.hour==fcod[0] && t.min>=fcod[1])
        # in last area of day.  Set avatar to the last one for the day, then set a check for tomorrow at midnight
        bot.game=k[k.length-1][4]
        if Shardizard.zero? || Shardizard==-1
          bot.profile.avatar=(File.open("#{$location}devkit/EliseImages/#{k[k.length-1][3]}.png",'r')) rescue nil
        end
        @avvie_info=[k[k.length-1][3],k[k.length-1][4],k[k.length-1][5]]
        t2= Time.now + 18*60*60
        t=Time.now
        @scheduler.at "#{t2.year}/#{t2.month}/#{t2.day} 0000" do
          next_holiday(bot,1)
        end
      else
        # find when in the day it is and...
        j=0
        t=Time.now
        t-=60*60*6
        for i in 0...div[k.length].length-1
          j=i if t.hour<div[k.length][i+1][0] || (t.hour==div[k.length][i+1][0] && t.min<div[k.length][i+1][1])
        end
        # ...set avatar properly and set check for the beginning of the next chunk of the day
        bot.game=k[j][4]
        if Shardizard.zero? || Shardizard==-1
          bot.profile.avatar=(File.open("#{$location}devkit/EliseImages/#{k[j][3]}.png",'r')) rescue nil
        end
        @avvie_info=[k[j][3],k[j][4],k[j][5]]
        t=Time.now
        t-=60*60*6
        @scheduler.at "#{t.year}/#{t.month}/#{t.day} #{div[k.length][j+1][0].to_s.rjust(2, '0')}#{div[k.length][j+1][1].to_s.rjust(2, '0')}" do
          next_holiday(bot,1)
        end
      end
    end
  else
    t=Time.now
    t-=60*60*6
    bot.game='Fire Emblem Heroes (FEH!help for info)' unless [9,10].include?(t.month) && t.year==2020
    if Shardizard==-1
      bot.profile.avatar=(File.open("#{$location}devkit/EliseBot(Smol).png",'r')) rescue nil
      @avvie_info=['EliseBot(Smol)','*Fire Emblem Heroes*','']
    elsif [6,7].include?(t.month)
      bot.profile.avatar=(File.open("#{$location}devkit/Elise(Summer).png",'r')) rescue nil if Shardizard.zero? || Shardizard==-1
      @avvie_info=['Elise(Summer)','*Fire Emblem Heroes*','']
    elsif [1,2].include?(t.month)
      bot.profile.avatar=(File.open("#{$location}devkit/Elise(Bath).png",'r')) rescue nil if Shardizard.zero? || Shardizard==-1
      @avvie_info=['Elise(Bath)','*Fire Emblem Heroes*','']
    else
      bot.profile.avatar=(File.open("#{$location}devkit/Elise.png",'r')) rescue nil if Shardizard.zero?
      @avvie_info=['Elise','*Fire Emblem Heroes*','']
    end
    t+=24*60*60
    @scheduler.at "#{t.year}/#{t.month}/#{t.day} 0000" do
      next_holiday(bot,1)
    end
  end
end

bot.ready do |event|
  if Shardizard==4
    for i in 0...bot.servers.values.length
      if ![285663217261477889,443172595580534784,443181099494146068,443704357335203840,449988713330769920,497429938471829504,554231720698707979,523821178670940170,523830882453422120,691616574393811004,523824424437415946,523825319916994564,523822789308841985,532083509083373579,575426885048336388,620710758841450529,572792502159933440].include?(bot.servers.values[i].id)
        bot.servers.values[i].general_channel.send_message(get_debug_leave_message()) rescue nil
        bot.servers.values[i].leave
      end
    end
  end
  if Shardizard==-1
    system("color 5E")
    system("title loading EliseBot(Smol)")
  elsif Shardizard==-2
    system("color 5E")
    system("title loading Elispanol")
  else
    system("color #{'4' if shard_data(4)[Shardizard,1]=='5'}#{'5' unless shard_data(4)[Shardizard,1]=='5'}#{shard_data(4)[Shardizard,1]}")
    system("title loading #{shard_data(2)[Shardizard]} EliseBot")
  end
  bot.game="Loading, please wait..."
  metadata_load()
  if Shardizard==-1
    system("color e5")
    system("title EliseBot(Smol)")
  elsif Shardizard==-2
    system("color e5")
    system("title Elisepanol")
  else
    system("color e#{shard_data(3)[Shardizard,1]}")
    system("title #{shard_data(2)[Shardizard]} EliseBot")
  end
  data_load(['everything'])
  next_holiday(bot)
  metadata_load()
  if @ignored.length>0
    for i in 0...@ignored.length
      bot.ignore_user(@ignored[i].to_i)
    end
  end
  metadata_save()
  bot.game='Fire Emblem Heroes (FEH!help for info)'
  if Shardizard==4
    bot.user(bot.profile.id).on(285663217261477889).nickname='EliseBot (Debug) - Resplendent'
    bot.profile.avatar=(File.open("#{$location}devkit/DebugElise.png",'r'))
  else
    puts 'Avatar loaded' if Shardizard.zero?
  end
  if Shardizard==4
    if File.exist?("#{$location}devkit/DebugSav.txt")
      b=[]
      File.open("#{$location}devkit/DebugSav.txt").each_line do |line|
        b.push(eval line)
      end
    else
      b=[]
    end
    bot.channel(285663217261477889).send_message("Lemme give you the happiest of hellos!") if b[0]!='Elise'
    open("#{$location}devkit/DebugSav.txt", 'w') { |f|
      f.puts '"Elise"'
    }
  end
end

bot.run
