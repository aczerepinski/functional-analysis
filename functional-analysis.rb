require_relative 'chords.rb'
require_relative 'songs.rb'

def transpose(song, key)
  transposed_song = []
  song.each do | chord |
    transposed_song.push(key[chord])
  end
  transposed_song
end

def first_pass_analysis(song, key)
  analyzed_song = []
  song.each do | chord |
    temp_hash = key.select { | key, value | value == chord}
    if temp_hash.length == 1
      analyzed_song.push(temp_hash.key(chord))
    else
      analyzed_song.push(temp_hash)
    end
  end
  analyzed_song
end

def next_chord(song, i)
  song[i+1]
end

def resolve_dominants(song, key)
  #V7(not needed), V7/II(not needed), V7/III(not needed), V7/IV(vs I7), V7/V(not needed), V7/VI(not needed)
  analyzed_song = []
  song.each.with_index do |chord, i|
    if chord.class == Hash
      if chord.keys.include?(:V7_of_IV)
        if next_chord(song) == :IVMaj7
          analyzed_song << :V7_of_IV
        else
          analyzed_song << :I7
        end
      end
    end
      analyzed_song << chord
  end
  analyzed_song
end

def second_pass_analysis(song, key)
  analyzed_song = []
  song.each.with_index do | chord, i |
    if chord.class == Hash
      if chord.keys.include?(:II_of_V)
        if next_chord(song, i) == :V7_of_V
          analyzed_song << :II_of_V
        else
          analyzed_song << :VImin7
        end
      elsif chord.keys.include?(:II_of_II)
        if next_chord(song, i) == :V7_of_II
          analyzed_song << :II_of_II
        else
          analyzed_song << :IIImin7
        end
      else
        analyzed_song << "no_match"
      end 
    else
      analyzed_song << chord
    end
  end
  analyzed_song
end

def analyze(song, key)
  #condense down to single chords and hashes of possible matches
  first_pass = first_pass_analysis(song, key)
  with_dominants = resolve_dominants(first_pass, key)
  #1resolve secondary and 2substitute dominants
  #3resolve secondary and 4substitute subdominants
  with_dominants
end
chords = Chords.new
songs = Songs.new

# first_pass = first_pass_analysis(songs.test_song, chords.key_of_c)
# print "first pass: #{first_pass}"
# puts ""
# second_pass = second_pass_analysis(first_pass, chords.key_of_c)
# print "second pass: #{second_pass}"
# puts ""
# print "second pass transposed to C: #{transpose(second_pass, chords.key_of_c)}"
# puts ""
# print "second pass transposed to F: #{transpose(second_pass, chords.key_of_f)}"

