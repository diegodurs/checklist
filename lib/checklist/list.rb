# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


require 'forwardable'

module Checklist
  class List
    extend ::Forwardable

    def_delegators :@list, :each, :map, :select, :first, :last

    attr_reader :items, :context

    def initialize(klass, &block)
      @klass, @items = klass, []
      update(&block)
    end

    def update(&block)
      instance_eval(&block) if block_given?
      self
    end

    # return true if all items are validated
    def valid?
      items.each do |item|
        return false unless item.checked?
      end
      return true
    end

    def context= (instance)
      @context = instance
    end

    # = Example
    # each_checked do |explain, checked|
    #   puts "#{explain} = #{checked}"
    # end
    def each_checked(options = {}, &block)
      options = parse_options(options)
      get_items(options).each do |item|
        block.call(item.explain, item.checked?)
      end
    end

    def map_checked(options = {}, &block)
      options = parse_options(options)
      block ||= lambda { |msg, checked| [msg, checked] }
      items.map {|item| block.call(item.explain, item.checked?) }
    end

    def errors
      items.select { |item| !item.checked? }
    end

    # items that should be checked
    def filtered_items
      items.select { |item| item.keep? }
    end

    private

    def check(explain, item_options = {}, &block)
      @items << Item.new(explain, self, item_options, &block)
    end

    def get_items(options)
      options[:filtered] ? filtered_items : items
    end

    def default_options
      { filtered: true }
    end

    def parse_options(options = {})
      default_options.merge(options)
    end

  end
end