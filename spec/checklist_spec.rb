# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative '../lib/checklist'

class TestingChecklist
  include Checklist

  attr_accessor :world

  def initialize
    @world = "World"
    @true = true
  end

  checklist do
    it "World should contains the world string" do
      world == "World"
    end
    it "the truth" do
      @true == true
    end
  end
end

# verify if there is no collapsing in the rules
class TestingChecklist2
  include Checklist

  attr_accessor :world

  def initialize
    @world = "Monde"
  end

  checklist do
    it "World should contains the world string" do
      world == "Monde"
    end
  end
end


describe Checklist do

  let(:instance){ TestingChecklist.new }
  let(:instance2){ TestingChecklist2.new }
  let(:invalid){ a = TestingChecklist.new; a.world = "Blabla"; a }

  describe 'checklist' do
    it 'should return an array of ChecklistItem' do
      instance.checklist.items.first.should be_a(Checklist::Item)
    end

    it 'should not share items between classes' do
      instance.checklist.items.size.should == 2
      instance2.checklist.items.size.should == 1
    end
  end

  describe 'valid?' do
    context 'when calling from instance' do
      it 'should return true if all conditions return true' do
        instance.checklist.should be_valid
        instance2.checklist.should be_valid
      end
      it 'should return false if one fails' do
        invalid.checklist.should_not be_valid
      end

    end

    context 'when calling from class' do
      it 'should raise an exception' do
        lambda do
          TestingChecklist.get_checklist.valid?
        end.should raise_exception Checklist::InstanceMissingError
      end
    end
  end

  describe 'each_checked' do
    it 'should iterate and give the block the message and the true/false value' do
      instance.checklist.each_checked do |explain, checked|
        explain.should be_a(String)
        checked.should be
      end
    end
  end

  describe 'map_checked' do
    context 'without block' do
      it 'should return an array of array' do
        invalid.checklist.map_checked.should == [
          ["World should contains the world string", false],
          ["the truth", true],
        ]
      end
    end
    context 'with block' do
      it 'should work as the regular map but give the message and the true/false' do
        invalid.checklist.map_checked do |sms, checked|
          [checked, sms]
        end.should == [
          [false, "World should contains the world string"],
          [true, "the truth"]
        ]
      end
    end
  end

end