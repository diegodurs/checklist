# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Checklist
  class Item
    attr_reader :explain, :key, :list, :options

    def initialize(explain, list = nil, options = {}, &block)
      @options = options
      @list = list
      @block = block
      @explain = explain
    end

    def checked?
      raise Checklist::InstanceMissingError unless list.context
      context.instance_eval(&@block) == true
    end

    # return true if the item should be checked
    def keep?
      keep = only_applies?
      keep = except_applies? if keep.nil?
      keep
    end

    private

    def context
      list.context
    end

    # based on options[:except], the method ...
    #  return false if item should not be checked
    #  return true if the item should be checked
    #  return nil if option was not supplied
    def except_applies?
      options[:except].nil? ? nil : !exec(options[:except])
    end

    # based on options[:only], the method ...
    #  return false if item should not be checked
    #  return true if the item should be checked
    #  return nil if option was not supplied
    def only_applies?
      options[:only].nil? ? nil : exec(options[:only])
    end

    def exec(sym_or_proc)
      if sym_or_proc.is_a?(Symbol)
        context.send(sym_or_proc)
      elsif sym_or_proc.is_a?(Proc)
        context.instance_eval(&sym_or_proc)
      end
    end

  end
end