

class Assembler < Object
    @@labels = { "SP" => 0,
                "LCL" => 1,
                "ARG" => 2,
                "THIS" => 3,
                "THAT" => 4,
                "R0" => 0,
                "R1" => 1,
                "R2" => 2,
                "R3" => 3,
                "R4" => 4,
                "R5" => 5,
                "R6" => 6,
                "R7" => 7,
                "R8" => 8,
                "R9" => 9,
                "R10" => 10,
                "R11" => 11,
                "R12" => 12,
                "R13" => 13,
                "R14" => 14,
                "R15" => 15,
                "SCREEN" => 16384,
                "KBD" => 24576 }

    def initialize(name)
        parser = Parser.new(name)
        @lines = parser.lines
        labelsparser = LabelsParser.new(@lines, @@labels)
        @lines = labelsparser.getLines()
        @@labels = labelsparser.getLabels();
        converter = Converter.new(@lines, @@labels)
        @lines = converter.getLines()
        out_file = File.new(name.split(".")[0] + ".hack", "w")
        @lines.each do |line|
            out_file.puts(line)
        end
        out_file.close
    end
end

class LabelsParser < Object
    @@lines = []
    @@labels

    def initialize(lines, labels)
        count = 0
        puts lines
        lines.each do |line|
            line = line.gsub(/\s+/, "")
            if line[0] == "("
                label = line[1..-2]
                unless labels.has_key?(label)
                    labels[label] = count
                end
            else
                @@lines.push(line)
                count += 1
            end
        end
        puts labels
        @@labels = labels
    end

    def getLines()
        @@lines
    end

    def getLabels()
        @@labels
    end
end

class Converter < Object
    @@lines = []
    @@instr = { "0" => "0101010",
               "1" => "0111111",
               "-1" => "0111010",
               "D" => "0001100",
               "A" => "0110000",
               "M" => "1110000",
               "!D" => "0001101",
               "!A" => "0110001",
               "!M" => "1110001",
                "-D" => "0001111",
                "-A" => "0110011",
                "-M" => "1110011",
                "D+1" => "0011111",
                "A+1" => "0110111",
                "M+1" => "1110111",
                "D-1" => "0001110",
                "A-1" => "0110010",
                "M-1" => "1110010",
                "D+A" => "0000010",
                "D+M" => "1000010",
                "D-A" => "0010011",
                "D-M" => "1010011",
                "A-D" => "0000111",
                "M-D" => "1000111",
                "D&A" => "0000000",
                "D&M" => "1000000",
                "D|A" => "0010101",
                "D|M" => "1010101" }
    @@jmps = { "null" => "000",
              "JGT" => "001",
              "JEQ" => "010",
              "JGE" => "011",
              "JLT" => "100",
              "JNE" => "101",
              "JLE" => "110",
              "JMP" => "111" }
    @@dest = { "A" => 4,
              "M" => 1,
              "D" => 2 }
    def initialize(lines, labels)
        freememory = 16
        lines.each do |line|
            if line[0] == "@"
                addr = line[1..-1]
                if !is_number?(addr)
                    if labels.has_key? addr
                        addr = labels[addr].to_s
                    else
                        labels[addr] = freememory
                        addr = freememory.to_s
                        freememory += 1
                    end
                end
                addr = addr.to_i(10).to_s(2)
                additional = 16 - addr.length
                addr = "0"*additional + addr
                @@lines.push(addr)
            else
                dest = "000"
                jmp = "000"
                if line.include? "="
                    rgstrs = line.split("=")[0]
                    addr = 0
                    rgstrs.split("").each {|d| addr |= @@dest[d]}
                    dest = appendZeros(addr.to_s(2), 3)
                    line = line.split("=")[1]
                end
                if line.include? ";"
                    arr = line.split(";")
                    jmp = @@jmps[arr[1]]
                    line = arr[0]
                end
                instr = @@instr[line]
                result = "111" + instr + dest + jmp
                @@lines.push(result)
            end
        end
    end

    def getLines()
        @@lines
    end
end

def appendZeros(string, length)
    additional = length - string.length
    result = "0"*additional + string
    result
end

def is_number?(str)
    true if Float(str) rescue false
end

class Parser < Object
    @name
    @lines
    @lineNum
    attr_accessor :lines


    def initialize(name)
        @name = name
        @lines = []
        File.readlines(name).each do |line|
            if line.include? "//"
                line = line[0, line.index("//")]
            end
            line = line.strip
            if line != ""
                @lines.push(line)
            end
        end
    end
end

Assembler.new(ARGV[0])
