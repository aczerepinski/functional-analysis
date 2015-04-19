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
        next_chord(song, i) == :IVMaj7 ? analyzed_song << :V7_of_IV : analyzed_song << :I7
      else #if doesn't include
        analyzed_song << chord
      end
    else #if not hash
      analyzed_song << chord
    end
  end #each loop
  analyzed_song
end

def resolve_substitute_dominants(song, key)
  #subv(not needed), subv/ii(not needed), subv/iii (vs IV7), subv/iv(not needed), subv/v(not needed), subv/vi(vs bVII7)
  analyzed_song = []
  song.each.with_index do |chord, i|
    if chord.class == Hash
      if chord.keys.include?(:sub_V7_of_III)
        next_chord(song, i) == :IIImin7 ? analyzed_song << :sub_V7_of_III : analyzed_song << :IV7
      elsif chord.keys.include?(:sub_V7_of_VI)
        next_chord(song, i) == :VImin7 ? analyzed_song << :sub_V7_of_VI : analyzed_song << :bVII7
      else #if not included
        analyzed_song << chord
      end
    else #if not hash
      analyzed_song << chord
    end
  end #each loop
  analyzed_song
end

def resolve_subdominants(song, key)
  #IImin7(not needed), II/III (not needed), II/IV(vs Vmin7), II/V (vs VImin7), II/VI(vs VIImin7b5)
  analyzed_song = []
  song.each.with_index do |chord, i|
    if chord.class == Hash
      if chord.keys.include?(:II_of_II)
        next_chord(song, i) == :V7_of_II ? analyzed_song << :II_of_II : analyzed_song << :IIImin7
      elsif chord.keys.include?(:II_of_IV)
        next_chord(song, i) == :V7_of_IV ? analyzed_song << :II_of_IV : analyzed_song << :Vmin7
      elsif chord.keys.include?(:II_of_V)
        next_chord(song, i) == :V7_of_V ? analyzed_song << :II_of_V : analyzed_song << :VImin7
      elsif chord.keys.include?(:II_of_VI)
        next_chord(song, i) == :V7_of_VI ? analyzed_song << :II_of_VI : analyzed_song << :VIImin7b5
      else
        analyzed_song << chord
      end #cases
    else #if not hash
      analyzed_song << chord
    end
  end #each loop
  analyzed_song
end

def resolve_substitute_subdominants(song, key)
      #subII(not needed), subII/II(not needed), sub II/III(vs Imin7), sub II/IV(not needed), sub II/V(not needed), sub II/VI(IVmin)
    analyzed_song = []
    song.each.with_index do |chord, i|
    if chord.class == Hash
      if chord.keys.include?(:sub_II_of_III)
        next_chord(song, i) == :sub_V7_of_III ? analyzed_song << :sub_II_of_III : analyzed_song << :Imin7
      elsif chord.keys.include?(:sub_II_of_VI)
        next_chord(song, i) == :sub_V7_of_VI ? analyzed_song << :sub_II_of_VI : analyzed_song << :IVmin7
      else
        analyzed_song << chord
      end #cases
    else #if not hash
      analyzed_song << chord
    end
  end
  analyzed_song
end

def analyze(song, key)
  first_pass = first_pass_analysis(song, key)
  with_dominants = resolve_dominants(first_pass, key)
  with_substitute_dominants = resolve_substitute_dominants(with_dominants, key)
  with_subdominants = resolve_subdominants(with_substitute_dominants, key)
  with_sub_subdominants = resolve_substitute_subdominants(with_subdominants, key)
  with_sub_subdominants
end