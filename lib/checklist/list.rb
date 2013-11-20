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
    def each_checked(&block)
      items.each do |item|
        block.call(item.explain, item.checked?)
      end
    end

    def map_checked(&block)
      if block_given?
        items.map {|item| block.call(item.explain, item.checked?) }
      else
        items.map {|item| [item.explain, item.checked?] }
      end
    end

    def errors
      items.select { |item| !item.checked? }
    end

    private

    def check(explain, &block)
      @items << Item.new(explain, self, &block)
    end

  end
end