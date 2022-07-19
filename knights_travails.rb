class Board
  attr_accessor :state

  def initialize
    # a 2d array of blank nodes
    @state = Array.new(8) { Array.new(8) { Node.new } }
    # fill nodes with coordinates
    each_coordinates do |node, row, col|
      node.coordinates = [row, col]
    end
    # fill nodes' neighbors
    each_coordinates do |start_node, start_row, start_col|
      each_coordinates do |target_node, target_row, target_col|
        if (((start_row - target_row).abs == 2) && ((start_col - target_col).abs == 1)) ||
           (((start_row - target_row).abs == 1) && ((start_col - target_col).abs == 2))
          start_node.neighbors << target_node
        end
      end
    end
  end

  def display
    state.each do |row|
      row.each do |field|
        print "#{field} "
      end
      puts ''
    end
  end

  def each_coordinates
    state.each_with_index do |row, row_no|
      row.each_with_index do |node, col_no|
        yield node, row_no, col_no
      end
    end
  end

  def get_knight_path(start, _target)
    # someway to store path/from which node I came to each field?

    start_node = state[start[0]][start[1]]
    queue = [start_node]
    visited = []
    until queue.empty?
      node = queue.shift
      visited << node
      queue += node.neighbors - visited - queue
    end
    visited
  end
end

class Node
  attr_accessor :neighbors, :coordinates

  def initialize
    @coordinates = nil
    @neighbors = []
  end

  def to_s
    coordinates.to_s
  end

  def neighbors_s
    str_array = neighbors.map(&:to_s)
    str_array.join(' ')
  end
end

board = Board.new
breadth_traversal = board.get_knight_path([1, 2], [])
puts breadth_traversal
