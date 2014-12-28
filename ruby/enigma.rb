# Relearning Ruby with an Enigma sim

$alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$letterMap = {}
#generate number to letter hash/map
for i in 0..25
	$letterMap[$alphabet[i]] = i
end

$rotorWirings = {
	"I" => "EKMFLGDQVZNTOWYHXUSPAIBRCJ",
	"II" => "AJDKSIRUXBLHWTMCQGZNPYFVOE",
	"III" => "BDFHJLCPRTXVZNYEIWGAKMUSQO"
}
$reflectorWirings = {
	"A" => "EJMZALYXVBWFCRQUONTSPIKHGD",
	"B" => "YRUHQSLDPXNGOKMIEBFZCWVJAT",
	"C" => "FVPJIAOYEDRZXWGCTKUQSBNMHL"
}

#switched sets of letters
$plugboardTest = "WFCDEBGHILKJMNSPQROTUVAZYX"

#shift a letter up by a number of 'letter positions'
# "C" shifts by 2, so D -> F
# "A" shifts by 0, leaving the input unchanged
def shiftLetter(letterIn, shift)
	letterPos = $letterMap[letterIn]
	shiftPos = $letterMap[shift]
	letterPos += shiftPos
	if letterPos > 25 then
		letterPos -= 26
	end
	$alphabet[letterPos]  #this is returned
end

# shifts a letter down by a number of 'letter positions'
# "B" shifts down by 1 so: E -> D and A -> Z
def unshiftLetter(letterIn, shift)
	letterPos = $letterMap[letterIn]
	shiftPos = $letterMap[shift]
	letterPos -= shiftPos
	if letterPos < 0 then
		letterPos += 26
	end
	$alphabet[letterPos]  #this is returned
end

#takes a wiring list and inverts it,
#switches input and output letters to make new list
def invertWiring(wiring)
	positions = []
	for i in 0..25
		letterIn = $alphabet[i]
		letterOut = wiring[i]
		positions[$letterMap[letterOut]] = letterIn
	end
	inverse = ""
	positions.each { |letter|
		inverse += letter
	}
	return inverse
end		
		
#uses a rotor wiring list to change a letter
def transformLetter(letterIn, wiring)
	letterIndex = $letterMap[letterIn]
	wiring[letterIndex]
end
		
class Rotor
	def initialize(wiring, notch, ringSetting="A", position="A")
		@wiring = wiring
		@inverseWiring = invertWiring(wiring)
		@notch = notch
		@ringSetting = ringSetting
		@position = position
	end
	
	def pos
		@position
	end
	
	def setPosition(position)
		@position = position
	end
	
	def letterOut(letterIn)
		self._shiftTransformUnshift(letterIn, @wiring)
	end
	
	def reflectedOut(letterIn)
		self._shiftTransformUnshift(letterIn, @inverseWiring)
	end
	
	def _shiftTransformUnshift(letterIn, wiring)
		letter = unshiftLetter(letterIn, @ringSetting)
		letter = shiftLetter(letter, self.pos)
		letter = transformLetter(letter, wiring)
		letter = unshiftLetter(letter, self.pos)
		shiftLetter(letter, @ringSetting)
	end
	
	def atNotch?
		@position == @notch
	end
	
	def advance
		#advances the rotor, returning true if a notch
		#position was crossed
		notchCrossed = self.atNotch?
		@position = shiftLetter(@position, "B")
		return notchCrossed
	end
	
end
		
class Reflector
	def initialize(wiring)
		@wiring = wiring
	end
	
	def letterOut(letterIn)
		transformLetter(letterIn, @wiring)
	end
end

class PlugBoard
	def initialize(wiring=$alphabet)
		#default wiring is 'no plugs wired'
		@wiring = wiring
	end
	
	def letterOut(letterIn)
		transformLetter(letterIn, @wiring)
	end
end
		
class EnigmaMachine
	def initialize(leftRotor, middleRotor, rightRotor, reflector, plugBoard)
		@leftRotor = leftRotor
		@middleRotor = middleRotor
		@rightRotor = rightRotor
		@reflector = reflector
		@plugBoard = plugBoard
		@doubleStep = false
	end
	
	def setLeftRotor(position)
		@leftRotor.setPosition(position)
	end
	
	def setMiddleRotor(position)
		@middleRotor.setPosition(position)
	end
	
	def setRightRotor(position)
		@rightRotor.setPosition(position)
	end

	def setRotors(positions)
		self.setLeftRotor(positions[0])
		self.setMiddleRotor(positions[1])
		self.setRightRotor(positions[2])
	end
	
	def getRotorSettings
		@leftRotor.pos + @middleRotor.pos + @rightRotor.pos
	end
	
	def advanceRotors
		#doublestep needs test
		if @rightRotor.advance or @doubleStep
			if @middleRotor.advance
				@leftRotor.advance
			end
			@doubleStep = @middleRotor.atNotch?
		end
	end
	
	def letterOut(letterIn)
		letter = @plugBoard.letterOut(letterIn)
		letter = @rightRotor.letterOut(letter)
		letter = @middleRotor.letterOut(letter)
		letter = @leftRotor.letterOut(letter)
		letter = @reflector.letterOut(letter)
		letter = @leftRotor.reflectedOut(letter)
		letter = @middleRotor.reflectedOut(letter)
		letter = @rightRotor.reflectedOut(letter)
		@plugBoard.letterOut(letter)
	end
	
	def pressKey(letterIn)
		self.advanceRotors
		self.letterOut(letterIn)
	end
	
	def encrypt(plaintext)
		ctext = ""
		plaintext.each_char {|letter|
			ctext += self.pressKey(letter)
		}
		return ctext
	end
	
end
		
#Lots of tests
print(shiftLetter("A", "D") + "\n")
print( unshiftLetter(shiftLetter("E", "C"),"C") + "\n" )

["I", "II", "III"].each { |rotor|
	print("Rotor #{rotor}:\n")
	wiring = $rotorWirings[rotor]
	inverse = invertWiring(wiring)
	print("\t#{wiring} -> #{inverse}\n\n")
}
transformed = transformLetter("D", $rotorWirings["I"])
print ("Rotor I: D -> #{transformed}\n")

rightRotor = Rotor.new($rotorWirings["III"], "R", "A", "A")
print(rightRotor.pos + "\n")
print("Advance notch = #{rightRotor.advance}\n")
print(rightRotor.pos + "\n")
print ("Right Rotor: D -> #{rightRotor.letterOut("D")}\n")
print("Advance notch = #{rightRotor.advance}\n")
print(rightRotor.pos + "\n")
print ("Right Rotor: D -> #{rightRotor.letterOut("D")}\n")
print("\n\nEnigma at 'AAA', '1, 2, 3' Test setting:\n")
rotorI = Rotor.new($rotorWirings["I"], "R")
rotorII = Rotor.new($rotorWirings["II"], "F")
rotorIII = Rotor.new($rotorWirings["III"], "W")
enigma = EnigmaMachine.new(
			leftRotor = rotorI,
			middleRotor = rotorII,
			rightRotor = rotorIII,
			reflector = Reflector.new($reflectorWirings["B"]),
			plugBoard = PlugBoard.new() )
"AAAAA".each_char { |letter|
	print("#{letter} -> #{enigma.pressKey(letter)}\n")
}

print("\n\nEnigma at 'AAA', '1, 2, 3' Test setting w Rings at B-positions:\n")
rotorI = Rotor.new($rotorWirings["I"], "Q", ringSetting="B")
rotorII = Rotor.new($rotorWirings["II"], "E", ringSetting="B")
rotorIII = Rotor.new($rotorWirings["III"], "V", ringSetting="B")
enigma = EnigmaMachine.new(
			leftRotor = rotorI,
			middleRotor = rotorII,
			rightRotor = rotorIII,
			reflector = Reflector.new($reflectorWirings["B"]),
			plugBoard = PlugBoard.new() )
"AAAAA".each_char { |letter|
	print("#{letter} -> #{enigma.pressKey(letter)}\n")
}
print("\nEnigma test #2, encrypt/decrypt:\n")
rotorI = Rotor.new($rotorWirings["I"], "Q", ringSetting="A")
rotorII = Rotor.new($rotorWirings["II"], "E", ringSetting="B")
rotorIII = Rotor.new($rotorWirings["III"], "V", ringSetting="C")
enigma = EnigmaMachine.new(
			leftRotor = rotorIII,
			middleRotor = rotorI,
			rightRotor = rotorII,
			reflector = Reflector.new($reflectorWirings["C"]),
			plugBoard = PlugBoard.new($plugboardTest) )
enigma.setRotors("XYZ")
plaintext = "HELLOWORLDHELLO"
ciphertext = enigma.encrypt(plaintext)
endSetting = enigma.getRotorSettings
#see if we can decrypt the ciphertext with the same setting
enigma.setRotors("XYZ")
decrypt = enigma.encrypt(ciphertext)
print("Encrpyted #{plaintext} to #{ciphertext}\n")
print("New setting = #{endSetting}\n")
print("Reset machine\n")
print("Decrypted #{ciphertext} to #{decrypt}\n")