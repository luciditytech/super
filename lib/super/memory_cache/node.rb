# frozen_string_literal: true

module Super
  class MemoryCache
    class Node
      attr_accessor :value, :left, :right

      def initialize(value)
        @value = value
      end

      def clear
        clear_right
        clear_left
      end

      def clear_right
        @right = nil
      end

      def clear_left
        @left = nil
      end

      def neighbor?(node)
        [@right, @left].include?(node)
      end

      def swap_with(node)
        return swap_neighbors(node) if neighbor?(node)

        old_left = @left
        old_right = @right

        place_after(node.left)
        place_before(node.right)

        node.place_after(old_left)
        node.place_before(old_right)
      end

      def place_after(node)
        @left = node
        return if node.nil?

        node.right = self
      end

      def place_before(node)
        @right = node
        return if node.nil?

        node.left = self
      end

      def inspect
        @value
      end

      private

      def swap_neighbors(node)
        old_left = @left
        place_before(node.right)
        node.place_after(old_left)
        place_after(node)
      end
    end
  end
end
