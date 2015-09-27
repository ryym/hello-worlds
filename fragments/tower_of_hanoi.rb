require 'forwardable'

# A class which represents and solves the Tower of Hanoi puzzle.
class HanoiTower
  def initialize(n_disks)
    @n_disks = n_disks

    disks = n_disks.downto(1).map { |size| Disk.new size }
    @pole_A = Pole.new 'A', disks
    @pole_B = Pole.new 'B'
    @pole_C = Pole.new 'C'
    puts self, '---------------' # XXX: Debug
  end

  def solve
    move_disks @n_disks, @pole_A, @pole_C, @pole_B
  end

  def to_s
    [ @pole_A, @pole_B, @pole_C ].join("\n")
  end

  private

    # Move +n+ disks from the +src+ pole to the +dest+ pole.
    # A remaining pole also has to be specified as the last argument.
    def move_disks(n, src, dest, remain)
      return if n <= 0
      move_disks n - 1, src, remain, dest
      move_disk src, dest
      move_disks n - 1, remain, dest, src
    end

    def move_disk(src, dest)
      raise 'Invalid operation!' unless can_move? src, dest
      dest.push src.pop
      puts self, '---------------' # XXX: Debug
    end

    def can_move?(src, dest)
      return ! src.empty? &&
        (dest.empty? || src.top.size < dest.top.size)
    end


    # A pole (or tower) which stacks disks.
    class Pole
      extend Forwardable
      attr_reader :id
      def_delegator :@disks, :last, :top
      def_delegators :@disks, :empty?, :push, :pop

      def initialize(id, disks = [])
        @id    = id
        @disks = disks
      end

      def to_s
        "#{@id}: [#{@disks.join(', ')}]"
      end
    end

    # A disk slided onto towers of Hanoi.
    class Disk
      attr_reader :size

      def initialize(size)
        @size = size
      end

      def to_s
        "(#{@size})"
      end
    end
end

# HanoiTower.new(2).solve
# puts '================================================================================'
HanoiTower.new(3).solve
# puts '================================================================================'
# HanoiTower.new(4).solve
# puts '================================================================================'
# HanoiTower.new(5).solve
