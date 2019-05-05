module Super
  class MemoryCache
    class LinkedList
      attr_reader :first, :last, :size

      def initialize
        @first = nil
        @last = nil
        @size = 0
      end

      def append(node)
        @size += 1
        return bootstrap_list(node) if @first.nil?

        @last.right = node
        node.left = @last
        @last = node
        node
      end

      def remove(node)
        return if @size.zero?
        return remove_final(node) if @size == 1
        return remove_last(node) if @last == node
        return remove_first(node) if @first == node

        @size -= 1
        node.left.right = node.right
        node.right.left = node.left
        node.clear
        node
      end

      def swap(node1, node2)
        swap_extremity('@first', node1, node2)
        swap_extremity('@last', node1, node2)
        node1.swap_with(node2)
      end

      def flush
        remove(@first) while @first
      end

      private

      def bootstrap_list(node)
        @first = node
        @last = node
      end

      def remove_first(node)
        @size -= 1
        @first = @first.right
        @first.clear_left
        node.clear
        node
      end

      def remove_last(node)
        @size -= 1
        @last = @last.left
        @last.clear_right
        node.clear
        node
      end

      def remove_final(node)
        @size -= 1
        @last.clear
        node.clear
        @first = nil
        @last = nil
        node
      end

      def swap_extremity(extremity, node1, node2)
        if instance_variable_get(extremity) == node1
          instance_variable_set(extremity, node2)
        elsif instance_variable_get(extremity) == node2
          instance_variable_set(extremity, node1)
        end
      end
    end
  end
end
