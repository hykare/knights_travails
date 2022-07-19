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

  def get_knight_path(start, target)
    start_node = state[start[0]][start[1]]
    target_node = state[target[0]][target[1]]

    queue = [start_node]
    visited = []
    start_node.source = start_node
    until queue.empty?
      node = queue.shift
      visited << node
      new_nodes = node.neighbors - visited - queue
      queue += new_nodes
      # put node as the source node of all enqueued items
      new_nodes.each { |new_node| new_node.source = node }

      next unless new_nodes.include? target_node

      path = []
      temp_node = target_node
      until temp_node == temp_node.source
        path.unshift temp_node
        temp_node = temp_node.source
      end
      path.unshift start_node
      return path
    end
  end
end

class Node
  attr_accessor :neighbors, :coordinates, :source

  def initialize
    @coordinates = nil
    @neighbors = []
    @source = nil
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
breadth_traversal = board.get_knight_path([1, 2], [4, 7])
puts breadth_traversal
