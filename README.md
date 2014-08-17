Checklist
=========

Declare in you class what the instance should validate. This is essentially an admin tool for checkup or to known the current step of a wizard or a process.


Example
-------

### Declaration

class User
  include Checklist

  checklist do
    check "Facebook profile loaded" do
      facebook_profile.present?
    end
    check "Invites friends" do
      frients.invited.count >= 0
    end
  end
end


### Usage

```ruby
user = User.new
user.checklist.valid?

# return array of [message, boolean] without block
# return an array with block
user.checklist.map_checked do |msg, bool|
  [msg, bool]
end

# iterator with [message, boolean]
user.checklist.each_checked do |msg, bool|
  puts "#{msg} - #{bool}"
end

<table>
  <% user.checklist.each_checked do |message, checked| %>
  <tr>
    <td> <%= message %> </td>
    <td>
      <%= checked ? '<i class="icon icon-thumbs-up"/>' : '<i class="icon icon-thumbs-down"/>'%>
    </td>
  </tr>
</table>

```
